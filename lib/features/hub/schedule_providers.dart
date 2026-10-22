import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/match_schedule.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_providers.dart';

/// The cycle's fixtures for the player's nation, folded into schedule blocks.
typedef ScheduleData = ({
  int nationId,
  List<ScheduleBlock> blocks,
  int currentIndex, // -1 when the cycle has nothing left
  Map<int, Nation> nations, // from HubData.nations
  Set<String> watchedDrawKinds,
});

/// The match schedule behind the hub card and the schedule screen.
///
/// It awaits [hubDataProvider] first, so it refreshes whenever the hub does:
/// every sim step and every watched draw already invalidates that provider,
/// and an imperative read here would otherwise serve a pre-match snapshot.
final AutoDisposeFutureProviderFamily<ScheduleData?, int> scheduleProvider =
    FutureProvider.autoDispose.family<ScheduleData?, int>((
      ref,
      careerId,
    ) async {
      final hub = await ref.watch(hubDataProvider(careerId).future);
      if (hub == null) return null;
      final comp = ref.watch(competitionRepositoryProvider);
      final nationId = hub.career.nationId;
      final fixtures = await comp.cycleFixturesForNation(careerId, nationId);
      final blocks = MatchSchedule.blocks(
        fixtures,
        nationId: nationId,
        knockoutsDrawnFor: await _knockoutsDrawn(
          comp,
          careerId,
          hub.nations[nationId]?.confederation,
        ),
      );
      // The same watched-draw check the Results feed and team page use, so all
      // three screens agree on when an opponent may be named.
      final watched = await watchedFixtureDraws(
        comp,
        careerId,
        hub.career.cyclePointer,
      );
      return (
        nationId: nationId,
        blocks: blocks,
        currentIndex: MatchSchedule.currentIndex(blocks),
        nations: hub.nations,
        watchedDrawKinds: watched,
      );
    });

/// The group round codes whose finals tournament already has knockout
/// fixtures in the world: `GROUP` for the World Championship, `CGROUP` for
/// the nation's continental cup.
Future<Set<String>> _knockoutsDrawn(
  CompetitionRepository comp,
  int careerId,
  Confederation? confederation,
) async {
  final out = <String>{};
  if ((await comp.finalsKnockoutFixtures(careerId)).isNotEmpty) {
    out.add('GROUP');
  }
  // Without a confederation the probe would match any cup's knockouts.
  if (confederation == null) return out;
  for (final round in const ['CR32', 'CR16', 'CQF', 'CSF', 'CFINAL']) {
    final drawn = await comp.fixturesByRound(
      careerId,
      round,
      kind: CompetitionKind.continentalFinals,
      confederation: confederation,
    );
    if (drawn.isNotEmpty) {
      out.add('CGROUP');
      break;
    }
  }
  return out;
}

/// False while the draw that decides [f]'s opponent is unwatched.
bool opponentKnown(ScheduleData d, Fixture f) =>
    fixtureRevealed(f, d.watchedDrawKinds);
