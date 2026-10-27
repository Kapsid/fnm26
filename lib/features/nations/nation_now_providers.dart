import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/nations/nation_vitrine_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

/// One match in a nation's recent form: the outcome is 'W', 'D' or 'L' from the
/// nation's side, following the winner when a knockout went to penalties.
typedef FormChip = ({
  Fixture fixture,
  int opponentId,
  int goalsFor,
  int goalsAgainst,
  String outcome,
});

/// What the "now" block on a nation's team page shows: where it stands, how it
/// has played, who it meets next and how strong its squad is today.
class NationNow {
  const NationNow({
    required this.rank,
    required this.points,
    required this.movement,
    required this.baseline,
    required this.confederation,
    required this.form,
    required this.next,
    required this.overall,
    required this.topPlayers,
    required this.againstYou,
    required this.isPlayerNation,
  });

  final int? rank;
  final int? points;
  final int movement;
  final RankBaseline? baseline;
  final Confederation confederation;

  /// The last five results, latest first.
  final List<FormChip> form;

  /// The earliest match still to play this cycle.
  final Fixture? next;

  /// The side's strength today; null when the pool is empty.
  final int? overall;

  /// The three best players by overall.
  final List<Player> topPlayers;

  /// The manager's record against this nation and the latest meeting; null on
  /// the manager's own page or when the two have never met.
  final ({HeadToHead record, Fixture? last})? againstYou;

  final bool isPlayerNation;
}

/// The "now" block of a nation's team page.
///
/// The manager's own nation is read from the lineup he has actually set, so the
/// number matches what he will field; every other nation is the best XI of its
/// pool in the preview's default formation, less anyone out hurt or banned.
final AutoDisposeFutureProviderFamily<NationNow?, NationVitrineArg>
nationNowProvider = FutureProvider.autoDispose
    .family<NationNow?, NationVitrineArg>((ref, arg) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(arg.careerId);
      if (career == null) return null;
      final nation = await ref
          .watch(nationRepositoryProvider)
          .byId(arg.nationId);
      if (nation == null) return null;
      final isOwn = career.nationId == arg.nationId;

      final ranking = await ref.watch(
        worldRankingProvider(arg.careerId).future,
      );
      final comp = ref.watch(competitionRepositoryProvider);

      // Form: the latest five played matches, all time.
      final all = await comp.fixturesForNation(arg.careerId, arg.nationId);
      final played = all.where((f) => f.hasResult).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      final form = <FormChip>[
        for (final f in played.take(5)) _chip(f, arg.nationId),
      ];

      final cycle = await comp.cycleFixturesForNation(
        arg.careerId,
        arg.nationId,
      );
      // Not a fixture whose draw the manager has yet to watch: the page must
      // not name an opponent before the balls come out.
      final watched = await watchedFixtureDraws(
        comp,
        arg.careerId,
        career.cyclePointer,
      );
      final upcoming =
          cycle.where((f) => !f.played && fixtureRevealed(f, watched)).toList()
            ..sort((a, b) => a.date.compareTo(b.date));

      // Strength and the three to watch.
      final List<Player> xi;
      final List<Player> pool;
      if (isOwn) {
        final data = await ref.watch(tacticDataProvider(arg.careerId).future);
        pool = data?.pool ?? const [];
        xi = [
          for (final id in data?.tactic.lineup ?? const <int?>[])
            if (id != null && data!.byId[id] != null) data.byId[id]!,
        ];
      } else {
        final absences = await ref
            .watch(absenceRepositoryProvider)
            .forCareer(arg.careerId);
        pool = selectable(
          await careerPoolOf(ref, career, arg.nationId),
          absences,
        );
        final byId = {for (final p in pool) p.id: p};
        xi = [
          for (final id in bestEleven(Formation.f433, pool))
            if (id != null) byId[id]!,
        ];
      }
      final top = [...pool]..sort((a, b) => b.overall.compareTo(a.overall));

      // Against the manager's nation.
      ({HeadToHead record, Fixture? last})? against;
      if (!isOwn) {
        final record = await comp.headToHead(
          arg.careerId,
          career.nationId,
          arg.nationId,
        );
        if (record.played > 0) {
          final meetings = played
              .where(
                (f) =>
                    f.homeNationId == career.nationId ||
                    f.awayNationId == career.nationId,
              )
              .toList();
          against = (
            record: record,
            last: meetings.isEmpty ? null : meetings.first,
          );
        }
      }

      return NationNow(
        rank: ranking?.position[arg.nationId],
        points: ranking?.points[arg.nationId],
        movement: ranking?.movement[arg.nationId] ?? 0,
        baseline: ranking?.baseline,
        confederation: nation.confederation,
        form: form,
        next: upcoming.isEmpty ? null : upcoming.first,
        overall: xi.isEmpty ? null : squadOverall(xi),
        topPlayers: top.take(3).toList(),
        againstYou: against,
        isPlayerNation: isOwn,
      );
    });

FormChip _chip(Fixture f, int nationId) {
  final home = f.homeNationId == nationId;
  final gf = (home ? f.homeScore : f.awayScore)!;
  final ga = (home ? f.awayScore : f.homeScore)!;
  var outcome = gf > ga ? 'W' : (gf < ga ? 'L' : 'D');
  if (outcome == 'D' && f.wentToShootout) {
    final pf = (home ? f.homePenalties : f.awayPenalties)!;
    final pa = (home ? f.awayPenalties : f.homePenalties)!;
    outcome = pf > pa ? 'W' : 'L';
  }
  return (
    fixture: f,
    opponentId: home ? f.awayNationId : f.homeNationId,
    goalsFor: gf,
    goalsAgainst: ga,
    outcome: outcome,
  );
}
