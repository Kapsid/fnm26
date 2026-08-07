import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/club/club_form.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';

/// Returns [p] with every attribute shifted by [delta] (their condition), so
/// the derived overall — and thus their weight in the match engine — reflects
/// form, fatigue and morale. A no-op when [delta] is zero.
// NOTE: condition (form / fatigue / morale) is deliberately NOT baked into a
// player's attributes any more. Doing that changed their displayed `overall`,
// so the same footballer read one rating on the squad screen, another in the
// pre-match XI and another in the live match. The delta is now passed to the
// engine as `MatchTeam.conditionByPlayer` and applied to strength only — a
// hidden effect on a stable, single rating.

/// A nation's recent competitive shape, for a pre-match dossier: its last few
/// results (newest first, +1 win / 0 draw / −1 loss) and a morale read (0–100).
/// Works for any nation, so it can profile the opponent as well as the manager.
typedef NationForm = ({List<int> results, int morale, int played});

/// The recent form of the (careerId, nationId) key's nation — its last five
/// results and morale, derived purely from recorded fixtures (nothing to
/// persist). Keyed so it can profile the opponent as well as the manager.
final AutoDisposeFutureProviderFamily<NationForm,
        ({int careerId, int nationId})> nationFormProvider =
    FutureProvider.autoDispose
        .family<NationForm, ({int careerId, int nationId})>((ref, key) async {
  final fixtures = await ref
      .watch(competitionRepositoryProvider)
      .fixturesForNation(key.careerId, key.nationId);
  final played = [
    for (final f in fixtures)
      if (f.hasResult) f,
  ]..sort((a, b) => b.date.compareTo(a.date)); // newest first
  final results = <int>[];
  for (final f in played.take(5)) {
    final isHome = f.homeNationId == key.nationId;
    final gf = isHome ? f.homeScore! : f.awayScore!;
    final ga = isHome ? f.awayScore! : f.homeScore!;
    results.add(gf > ga ? 1 : (gf < ga ? -1 : 0));
  }
  return (
    results: results,
    morale: Condition.morale(fixtures, key.nationId),
    played: played.length,
  );
});

/// Team morale (0–100) for the manager's nation, derived from recent results.
final AutoDisposeFutureProviderFamily<int, int> moraleProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return 50;
  final fixtures = await ref
      .watch(competitionRepositoryProvider)
      .fixturesForNation(careerId, career.nationId);
  // Results are most of morale — but what the manager said in public moves it
  // too, which is the only lever they have on it between matches.
  final press = await ref.watch(pressEffectProvider(careerId).future);
  // And who leads the side out. A dressing room with a natural captain in it
  // is a steadier one; see `Captaincy` for why the armband works through
  // morale rather than straight into ratings.
  final captain = await ref.watch(captainMoraleProvider(careerId).future);
  return (Condition.morale(fixtures, career.nationId) +
          press.morale +
          captain)
      .clamp(0, 100);
});

/// Every squad player's live condition (form + fatigue + the morale shift),
/// keyed by player id, for the manager's nation as of the current in-game date.
final AutoDisposeFutureProviderFamily<Map<int, PlayerCondition>, int>
    squadConditionProvider =
    FutureProvider.autoDispose.family<Map<int, PlayerCondition>, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return const {};
  final recent = await ref
      .watch(competitionRepositoryProvider)
      .recentRatingsByNation(careerId, career.nationId);
  final morale = await ref.watch(moraleProvider(careerId).future);
  final mDelta = Condition.moraleDelta(morale);
  // The tournament base camp, while one is running: where the squad is living
  // shows up as travel wear and a sharpness lift.
  final camp = await ref.watch(activeCampProvider(careerId).future);
  final asOf = career.inGameDate;
  // Where each man stands at his club this window — the third term beside form
  // and fatigue. A striker who has not started since October arrives rusty.
  final pool = await ref.watch(playerRepositoryProvider).byNation(
        career.nationId,
        agingYears: CareerService.agingYears(career),
        saveSeed: career.rngSeed,
        minAge: 15,
      );
  final byId = {for (final p in pool) p.id: p};
  final window = ClubForm.windowIndexFor(asOf);
  return {
    for (final entry in recent.entries)
      entry.key: () {
        final p = byId[entry.key];
        final standing = p == null
            ? null
            : ClubForm.standingFor(
                playerId: p.id,
                overall: p.overall,
                age: p.age,
                saveSeed: career.rngSeed,
                windowIndex: window,
              );
        return Condition.of(
          [for (final r in entry.value) r.rating],
          [for (final r in entry.value) r.date],
          asOf,
          mDelta,
          travelFatigue: camp?.travelFatigue ?? 1,
          campBonus: camp?.conditionBonus ?? 0,
          clubDelta: standing == null ? 0 : ClubForm.sharpnessDelta(standing),
          clubStanding: standing,
        );
      }(),
  };
});

/// A map of player id → net rating delta from condition, for the match engine
/// to apply. Read without watching (the match preview builds once).
Future<Map<int, int>> conditionDeltasFor(Ref ref, int careerId) async {
  final conditions = await ref.read(squadConditionProvider(careerId).future);
  return {
    for (final e in conditions.entries)
      if (e.value.overallDelta != 0) e.key: e.value.overallDelta,
  };
}
