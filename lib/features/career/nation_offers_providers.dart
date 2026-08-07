import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_summary_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
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
    required this.reputation,
    required this.nationalHero,
    required this.cyclesAtNation,
  });

  /// A 0–100 rating of the cycle just gone.
  final int performance;
  final String headline;
  final String detail;

  /// Whether the manager has been dismissed (they must take a new, lesser job).
  final bool sacked;
  final Nation? currentNation;
  final List<NationOffer> offers;

  /// A 0–100 career-long standing built from trophies won and years served —
  /// it cushions the job market so a decorated manager keeps drawing big offers
  /// through a lean cycle, and an unproven one has to earn them.
  final int reputation;

  /// Whether the manager is a national hero at their current nation (a long,
  /// decorated tenure): the board will not sack a hero, and the nation implores
  /// them to stay.
  final bool nationalHero;

  /// Consecutive cycles served at the current nation.
  final int cyclesAtNation;

  /// A short label for the reputation tier, for the UI.
  String get reputationLabel => switch (reputation) {
        >= 85 => 'Iconic',
        >= 70 => 'Renowned',
        >= 50 => 'Established',
        >= 30 => 'Up-and-coming',
        _ => 'Unproven',
      };
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
  // How far the cycle's briefs were BEATEN, in rounds, summed across the
  // objectives the board set. Satisfaction already rewards overachievement, but
  // it is a 0–100 gauge with a ceiling: a manager who drags a middling nation
  // to a World Cup semi-final pegs it at 100 and looks no different in the job
  // market from one who merely did the job. Rounds beyond the brief are read
  // separately, so the phone rings from higher up.
  final outcomes =
      await ref.watch(cycleObjectiveOutcomesProvider(careerId).future);
  var beatenBy = 0;
  for (final o in outcomes) {
    if (!o.decided) continue;
    final gap = o.actual - o.target;
    if (gap > 0) beatenBy += gap;
  }

  final ordered = ranking.nations; // strongest first
  final total = ordered.length;
  final currentNation =
      ordered.where((n) => n.id == career.nationId).firstOrNull;
  final currentPos =
      ranking.position[career.nationId] ?? currentNation?.ranking ?? total;

  // Career-long reputation and national-hero standing — the "job market depth"
  // beyond a single cycle's form. Built from the manager's own titles and how
  // long they've served, computed from stored honours + stints (no new state).
  final careerRepo = ref.watch(careerRepositoryProvider);
  final stints = await careerRepo.stints(careerId);
  final honours =
      await ref.watch(competitionRepositoryProvider).honours(careerId);
  final rep = _reputation(career, stints, honours);
  final cyclesAtNation = _cyclesAtNation(career, stints);
  final titlesAtNation =
      _titlesAtNation(career, stints, honours, career.nationId);
  // A hero: a long, decorated stay with the same nation. The board won't sack
  // a hero, and the nation begs them to stay.
  final nationalHero =
      (cyclesAtNation >= 3 && titlesAtNation >= 1) || cyclesAtNation >= 5;

  // A truly disastrous cycle costs the manager their job — but the board is
  // patient: only a dismal showing risks the sack, a decent reputation buys
  // extra rope, investing in Board Relations buys still more, and a national
  // hero is never dismissed.
  final tolerance = FederationFinance.boardTolerance(
    (await careerRepo.investment(careerId, career.cyclePointer)).boardRelations,
  );
  final sackBar = (rep + tolerance >= 60 ? 8 : 15) - tolerance ~/ 3;
  final sacked = perf < sackBar && !nationalHero;

  // How the offer band shifts from the current job: strong cycles unlock
  // stronger nations, weak ones only weaker.
  final double factor;
  if (perf >= 55) {
    factor = 1 - (perf - 55) / 45 * 0.45; // up to 45% stronger
  } else {
    factor = 1 + (55 - perf) / 55 * 2.2; // up to ~3.2x weaker
  }
  // Reputation cushions the band: an iconic manager still draws strong offers
  // after a lean cycle; an unproven one is marked tougher (±20% at the ends).
  final repFactor = 1 - (rep - 50) / 50 * 0.20;
  // Beating the brief pulls the whole band upward, on top of what satisfaction
  // already did — 12% stronger per round beyond it, up to a little over a third.
  final overFactor = 1 - (beatenBy.clamp(0, 3) * 0.12);
  final center =
      (currentPos * factor * repFactor * overFactor).round().clamp(1, total);

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
  final heroNote = nationalHero && !sacked
      ? ' ${currentNation?.name ?? 'The nation'} adore you — a national hero '
          'after $cyclesAtNation cycles; your job is safe for as long as you '
          'want it.'
      : '';

  return RolloverVerdict(
    performance: perf,
    headline: nationalHero && perf < 30 ? 'The nation stands by you' : headline,
    detail: '$detail$heroNote',
    sacked: sacked,
    currentNation: currentNation,
    offers: offers,
    reputation: rep,
    nationalHero: nationalHero,
    cyclesAtNation: cyclesAtNation,
  );
});

/// Which cycle an honour belongs to (the cycle whose World Cup is the next one
/// on or after the honour's year) — mirrors the challenge/summary mapping.
int _cycleForYear(int year) {
  final c = ((year - CareerService.worldCupYear(0)) / 4).ceil();
  return c < 0 ? 0 : c;
}

/// The nation the manager led in [cycle] (their current nation if unrecorded).
int _managedIn(Career career, Map<int, int> stints, int cycle) =>
    stints[cycle] ?? career.nationId;

/// A 0–100 career reputation from the manager's own major honours and tenure.
int _reputation(Career career, Map<int, int> stints, List<Honour> honours) {
  var wc = 0;
  var cont = 0;
  var other = 0;
  for (final h in honours) {
    if (h.year < CareerService.cycleStart.year) continue;
    final managed = _managedIn(career, stints, _cycleForYear(h.year));
    if (h.championId != managed) continue;
    switch (h.competition) {
      case 'World Championship':
        wc++;
      case 'Nations Cup':
      case 'Continental Clash':
        other++;
      default:
        cont++; // continental championships
    }
  }
  final years = career.inGameDate.year - CareerService.cycleStart.year;
  final score = 20 + wc * 20 + cont * 8 + other * 4 + (years * 0.5);
  return score.round().clamp(0, 100);
}

/// Consecutive cycles the manager has served at their current nation, counting
/// back from the just-finished cycle.
int _cyclesAtNation(Career career, Map<int, int> stints) {
  var count = 0;
  for (var c = career.cyclePointer; c >= 0; c--) {
    if (_managedIn(career, stints, c) == career.nationId) {
      count++;
    } else {
      break;
    }
  }
  return count;
}

/// Major titles the manager won specifically with [nationId].
int _titlesAtNation(
  Career career,
  Map<int, int> stints,
  List<Honour> honours,
  int nationId,
) {
  var titles = 0;
  for (final h in honours) {
    if (h.year < CareerService.cycleStart.year) continue;
    final managed = _managedIn(career, stints, _cycleForYear(h.year));
    if (managed == nationId && h.championId == nationId) titles++;
  }
  return titles;
}

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
      'A dismal cycle (rating $perf%). Your reign ends here. Only lesser '
          'nations will take a chance on you now.',
    );
  }
  if (perf >= 80) {
    return (
      'The board is delighted',
      'An outstanding cycle (rating $perf%) after $best. Bigger nations are '
          'interested, or you can stay and build.',
    );
  }
  if (perf >= 55) {
    return (
      'A solid cycle',
      'The board is content (rating $perf%). A few nations of similar '
          'standing would take you, but there is no pressure to move.',
    );
  }
  if (perf >= 30) {
    return (
      'The board expected more',
      'A disappointing cycle (rating $perf%). You keep your job, but any '
          'offers are a step down.',
    );
  }
  return (
    'You are under real pressure',
    'A poor cycle (rating $perf%). You survive, but only weaker nations are '
        'interested if you fancy a fresh start.',
  );
}
