import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/career/career_providers.dart';

/// A called-up player hurt earlier in the window still being played, whom the
/// manager may send home and replace.
typedef InjuryCover = ({
  int playerId,
  String playerName,
  int fixtureId,
  int matchesOut,
});

/// The watched-event key that records the manager's answer for one injury,
/// replaced or kept.
String injuryCoverKey(int fixtureId, int playerId) =>
    'injuryCover:$fixtureId:$playerId';

/// The next injury the manager has not yet answered, or null. Read fresh
/// every time (a plain function, not a cached provider): the hub asks after
/// every match, and a cached answer would outlive the match that changed it.
///
/// Only an injury from a match already played in the CURRENT window, to a
/// player still in the squad and still out: an injury in a window's last match
/// is answered by the next window's call-up instead. Bans are not covered: a
/// suspended player is replaced by nobody, at a tournament or anywhere else.
/// Several injuries come one at a time, in the order they happened.
Future<InjuryCover?> pendingInjuryCover(Ref ref, int careerId) async {
  final career = await ref.read(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.read(competitionRepositoryProvider);
  final fixtures = await comp.cycleFixturesForNation(careerId, career.nationId);
  if (Nomination.windowOpen(fixtures)) return null;
  if (Nomination.currentPeriod(fixtures).isEmpty) return null;
  final played = Nomination.playedInCurrentPeriod(fixtures);
  if (played.isEmpty) return null;
  // An empty stored squad means "the whole pool": nobody to send home.
  final callUps = await ref.read(squadRepositoryProvider).callUps(careerId);
  if (callUps.isEmpty) return null;
  final absences = await ref
      .read(absenceRepositoryProvider)
      .forCareer(careerId);
  final incidents = await comp.incidentsByFixture(careerId, career.nationId);
  for (final f in played) {
    for (final i in incidents[f.id] ?? const <MatchIncident>[]) {
      if (i.type != MatchEventType.injury) continue;
      if (i.nationId != career.nationId) continue;
      if (!callUps.contains(i.playerId)) continue;
      final out = absences[i.playerId]?.injuryMatches ?? 0;
      if (out <= 0) continue;
      if (await comp.hasWatchedDraw(
        careerId,
        career.cyclePointer,
        injuryCoverKey(f.id, i.playerId),
      )) {
        continue;
      }
      final pool = await ref
          .read(playerRepositoryProvider)
          .byNation(
            career.nationId,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
            careerId: career.id,
            minAge: PlayerLifecycle.callUpMinAge,
          );
      final name =
          pool.where((p) => p.id == i.playerId).firstOrNull?.name ?? '';
      return (
        playerId: i.playerId,
        playerName: name,
        fixtureId: f.id,
        matchesOut: out,
      );
    }
  }
  return null;
}

/// [pendingInjuryCover] for the replacement screen.
final AutoDisposeFutureProviderFamily<InjuryCover?, int>
pendingInjuryCoverProvider = FutureProvider.autoDispose
    .family<InjuryCover?, int>(pendingInjuryCover);
