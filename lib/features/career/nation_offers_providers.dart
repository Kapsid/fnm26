import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_summary_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// One job offer a manager can accept between cycles.
class NationOffer {
  const NationOffer({
    required this.nation,
    required this.position,
    required this.tier,
  });

  final Nation nation;

  /// The nation's world position (1 = strongest).
  final int position;

  /// 'Step up' / 'Lateral move' / 'A rebuild' — relative to the current job.
  final String tier;
}

/// The board's end-of-cycle verdict and the job market it opens up.
class RolloverVerdict {
  const RolloverVerdict({
    required this.performance,
    required this.headline,
    required this.detail,
    required this.sacked,
    required this.currentNation,
    required this.offers,
  });

  /// A 0–100 rating of the cycle just gone.
  final int performance;
  final String headline;
  final String detail;

  /// Whether the manager has been dismissed (they must take a new, lesser job).
  final bool sacked;
  final Nation? currentNation;
  final List<NationOffer> offers;
}

/// Evaluates the manager's just-finished cycle and produces the board verdict
/// plus a tiered set of job offers — strong showings open up better nations,
/// poor ones only lesser jobs, and a dismal cycle can end in the sack.
final AutoDisposeFutureProviderFamily<RolloverVerdict?, int>
    rolloverVerdictProvider =
    FutureProvider.autoDispose.family<RolloverVerdict?, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final ranking = await ref.watch(worldRankingProvider(careerId).future);
  if (ranking == null) return null;
  final perf = await ref.watch(satisfactionProvider(careerId).future);
  final summary = await ref.watch(careerSummaryProvider(careerId).future);

  final ordered = ranking.nations; // strongest first
  final total = ordered.length;
  final currentNation =
      ordered.where((n) => n.id == career.nationId).firstOrNull;
  final currentPos =
      ranking.position[career.nationId] ?? currentNation?.ranking ?? total;

  // A genuinely dismal cycle costs the manager their job; the bar is low-ish so
  // most cycles are survived.
  final sacked = perf < 25;

  // How the offer band shifts from the current job: strong cycles unlock
  // stronger nations, weak ones only weaker.
  final double factor;
  if (perf >= 55) {
    factor = 1 - (perf - 55) / 45 * 0.45; // up to 45% stronger
  } else {
    factor = 1 + (55 - perf) / 55 * 2.2; // up to ~3.2x weaker
  }
  final center = (currentPos * factor).round().clamp(1, total);

  final rng = SeededRng(career.rngSeed ^ (career.cyclePointer * 0x77) ^ 0xB0A5);
  final offers = <NationOffer>[];
  final used = <int>{career.nationId};
  for (final spread in const [-6, 2, 11]) {
    var pos = (center + spread + rng.nextInt(5) - 2).clamp(1, total);
    // Find the nearest not-yet-offered nation to that world position.
    Nation? pick;
    for (var step = 0; step < total; step++) {
      for (final p in [pos + step, pos - step]) {
        if (p < 1 || p > total) continue;
        final n = ordered[p - 1];
        if (!used.contains(n.id)) {
          pick = n;
          pos = p;
          break;
        }
      }
      if (pick != null) break;
    }
    if (pick == null) continue;
    used.add(pick.id);
    final tier = pos < currentPos * 0.85
        ? 'Step up'
        : pos > currentPos * 1.2
            ? 'A rebuild'
            : 'Lateral move';
    offers.add(NationOffer(nation: pick, position: pos, tier: tier));
  }
  offers.sort((a, b) => a.position.compareTo(b.position));

  final best = _bestResult(summary, career.cyclePointer);
  final (headline, detail) = _verdict(perf, sacked, best);

  return RolloverVerdict(
    performance: perf,
    headline: headline,
    detail: detail,
    sacked: sacked,
    currentNation: currentNation,
    offers: offers,
  );
});

/// The best tournament placement the manager achieved this cycle, for flavour.
String _bestResult(CareerSummary? summary, int cycle) {
  if (summary == null) return 'a quiet cycle';
  final year = CareerService.worldCupYear(cycle);
  for (final r in summary.runs) {
    if (r.competition == 'World Cup' && r.year == year) {
      return 'the World Cup: ${r.placement}';
    }
  }
  return 'the cycle';
}

(String, String) _verdict(int perf, bool sacked, String best) {
  if (sacked) {
    return (
      'The board has dismissed you',
      'A dismal cycle (form rating $perf%). Your reign ends here — only '
          'lesser nations are willing to take a chance on you now.',
    );
  }
  if (perf >= 80) {
    return (
      'The board is delighted',
      'An outstanding cycle (rating $perf%) after $best. Bigger nations are '
          'circling — or stay and build a dynasty.',
    );
  }
  if (perf >= 55) {
    return (
      'A solid cycle',
      'The board is content (rating $perf%). A few clubs of similar standing '
          'would welcome you, but there is no pressure to move.',
    );
  }
  if (perf >= 30) {
    return (
      'The board expected more',
      'A disappointing cycle (rating $perf%). You keep your job, but the '
          'offers on the table are a step down.',
    );
  }
  return (
    'You are under real pressure',
    'A poor cycle (rating $perf%). You survive — just — but only weaker '
        'nations are interested if you fancy a fresh start.',
  );
}
