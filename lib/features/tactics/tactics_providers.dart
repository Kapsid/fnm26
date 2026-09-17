import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';

/// Smallest squad a manager may call up (must field an XI plus cover).
const int kMinSquadSize = 16;

/// Largest squad a manager may call up (a full tournament squad).
const int kMaxSquadSize = 23;

/// The fewest AVAILABLE (unbanned, uninjured) players a squad must contain.
/// A manager may name someone serving a ban or nursing a knock — that's their
/// call — but the squad still has to be able to field a legal XI.
const int kMinFitPlayers = 11;

/// Resolves the squad actually available for selection from a nation [pool]
/// given the manager's [callUps]. An empty call-up set means the whole pool is
/// available (the default for new/legacy saves).
///
/// Call-ups that select *nobody* fall back to the whole pool too. A squad of
/// zero is never something a manager chose — it means the call-ups belong to
/// another nation (ids are partitioned per nation, so a stale set selects
/// nothing). Fielding the pool is wrong-ish; fielding nobody is fatal.
List<Player> availableSquad(List<Player> pool, Set<int> callUps) {
  if (callUps.isEmpty) return pool;
  final selected = pool.where((p) => callUps.contains(p.id)).toList();
  return selected.isEmpty ? pool : selected;
}

/// The members of [pool] who can actually play the next match — dropping anyone
/// serving a ban or an injury.
///
/// A suspension only means something if it keeps the player off the pitch. The
/// absence used to be a badge on the call-up screen and nothing more: the
/// manager could pick a banned player, save him into the XI, and only the match
/// would quietly refuse to field him.
List<Player> selectable(List<Player> pool, Map<int, PlayerAbsence> absences) =>
    pool.where((p) => absences[p.id]?.isAvailable ?? true).toList();

/// Everything the tactics screen needs for a save.
class TacticData {
  const TacticData({
    required this.tactic,
    required this.pool,
    required this.byId,
    this.absences = const {},
    this.unavailable = const [],
  });

  final Tactic tactic;

  /// The called-up squad (selectable for the XI and bench).
  final List<Player> pool;
  final Map<int, Player> byId;

  /// Suspension/injury standing keyed by player id (only notable players).
  final Map<int, PlayerAbsence> absences;

  /// Called-up players who cannot play the next match (banned or injured) —
  /// shown on the screen with their reason, never hidden. Hiding them entirely
  /// left the manager staring at a forced "reshape your XI" event with no way
  /// to see WHO was out.
  final List<Player> unavailable;

  /// The starters (lineup members) currently unavailable, with reasons.
  List<Player> get unavailableStarters {
    final xi = tactic.lineup.whereType<int>().toSet();
    return unavailable.where((p) => xi.contains(p.id)).toList();
  }
}

// Auto-disposed, like hubDataProvider: a career's nation can change mid-save
// (the manager takes a new job) and nothing here watches that column, so a
// cached snapshot would keep showing the previous nation's squad.
final AutoDisposeFutureProviderFamily<TacticData?, int>
tacticDataProvider = FutureProvider.autoDispose.family<TacticData?, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final tactic = await ref
      .watch(tacticsRepositoryProvider)
      .tacticForCareer(
        careerId,
      );
  if (tactic == null) return null;
  // The naturalised players belong in this pool exactly as they do in the
  // call-up pool and the match pool. They were missing here alone, so a
  // naturalised player could be picked in the squad and then never appear on
  // the tactics screen — nominated, but impossible to field.
  final fullPool = [
    ...await ref
        .watch(playerRepositoryProvider)
        .byNation(
          career.nationId,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
          youthBonusByCycle: await ref.watch(
            youthBonusByCycleProvider(careerId).future,
          ),
          careerStartsByPlayer: await ref.watch(
            careerDevBonusProvider(careerId).future,
          ),
        ),
    ...await naturalizedPlayersFor(ref, career),
  ]..sort((a, b) => b.overall.compareTo(a.overall));
  // A man who walked away cannot be fielded, whatever the saved XI says.
  final walked = await ref.watch(walkoutsProvider(careerId).future);
  fullPool.removeWhere((p) => walked.contains(p.id));
  final callUps = await ref.watch(squadRepositoryProvider).callUps(careerId);
  // A banned or injured player can't be picked, so he isn't in the pool the
  // manager picks from. The match already refuses to field him — but it did so
  // silently, discarding the whole saved XI and re-picking eleven fresh names,
  // so the side that kicked off was not the side on this screen.
  final absences = await ref
      .watch(absenceRepositoryProvider)
      .forCareer(careerId);
  final called = availableSquad(fullPool, callUps);
  final pool = selectable(called, absences);
  return TacticData(
    tactic: tactic,
    pool: pool,
    // Resolve over the full pool so the XI renders even if a player was just
    // dropped from the squad (the squad service repairs the lineup on save).
    byId: {for (final p in fullPool) p.id: p},
    absences: absences,
    unavailable: called
        .where((p) => !(absences[p.id]?.isAvailable ?? true))
        .toList(),
  );
});

/// Everything the call-up (squad selection) screen needs for a save.
class SquadData {
  const SquadData({
    required this.pool,
    required this.callUps,
    required this.absences,
    this.hasPreviousSquad = false,
  });

  /// The full nation pool, eligible to be called up.
  final List<Player> pool;

  /// The currently called-up player ids (every pool member when none have been
  /// explicitly chosen yet).
  final Set<int> callUps;

  /// Suspension/injury standing keyed by player id (only notable players).
  final Map<int, PlayerAbsence> absences;

  /// Whether the manager has ever named a squad. [callUps] can't answer this:
  /// it reports the whole pool when nothing has been chosen, so "everyone" and
  /// "the previous squad happened to be everyone" look identical.
  final bool hasPreviousSquad;
}

/// The shape the manager is currently playing, without loading a squad.
///
/// [tacticDataProvider] carries the formation too, but it resolves the whole
/// nation pool to do it — far too much to ask of a screen that only needs to
/// know how many defenders the side lines up with.
final AutoDisposeFutureProviderFamily<Formation, int> currentFormationProvider =
    FutureProvider.autoDispose.family<Formation, int>((ref, careerId) async {
      final tactic = await ref
          .watch(tacticsRepositoryProvider)
          .tacticForCareer(careerId);
      return tactic?.formation ?? Formation.f433;
    });

// Auto-disposed for the same reason as [tacticDataProvider].
/// The squad a manager who has named nobody starts from: every senior.
///
/// The pool now reaches down to fifteen so a wonderkid CAN be named, but the
/// default must not name him — left as "everyone in the pool", a new save would
/// auto-select its whole academy.
Set<int> defaultCallUpIds(List<Player> pool) => {
  for (final p in pool)
    if (p.age >= 17) p.id,
};

final AutoDisposeFutureProviderFamily<SquadData?, int>
squadDataProvider = FutureProvider.autoDispose.family<SquadData?, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final pool = [
    // Down to fifteen: the U-17s are selectable, tagged, so a genuine wonderkid
    // is a decision the manager can make. Every other caller keeps the default
    // seventeen — see [PlayerLifecycle.poolAt].
    ...await ref
        .watch(playerRepositoryProvider)
        .byNation(
          career.nationId,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
          minAge: 15,
          youthBonusByCycle: await ref.watch(
            youthBonusByCycleProvider(careerId).future,
          ),
          careerStartsByPlayer: await ref.watch(
            careerDevBonusProvider(careerId).future,
          ),
        ),
    ...await naturalizedPlayersFor(ref, career),
  ]..sort((a, b) => b.overall.compareTo(a.overall));
  // A man who walked away is not available to be called up again.
  final walked = await ref.watch(walkoutsProvider(careerId).future);
  pool.removeWhere((p) => walked.contains(p.id));
  final stored = await ref.watch(squadRepositoryProvider).callUps(careerId);
  final callUps = stored.isEmpty ? defaultCallUpIds(pool) : stored;
  final absences = await ref
      .watch(absenceRepositoryProvider)
      .forCareer(careerId);
  return SquadData(
    pool: pool,
    callUps: callUps,
    absences: absences,
    hasPreviousSquad: stored.isNotEmpty,
  );
});

/// Mutates and persists the team tactic for a save.
class TacticService {
  TacticService(this._ref);

  final Ref _ref;

  Future<void> _update(
    int careerId,
    Tactic Function(Tactic current, List<Player> pool) change,
  ) async {
    final repo = _ref.read(tacticsRepositoryProvider);
    final current = await repo.tacticForCareer(careerId);
    if (current == null) return;
    final pool = await _availablePool(careerId);
    await repo.saveTactic(careerId, change(current, pool));
    _ref.invalidate(tacticDataProvider);
  }

  Future<List<Player>> _availablePool(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return const [];
    final pool = [
      ...await _ref
          .read(playerRepositoryProvider)
          .byNation(
            career.nationId,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
            youthBonusByCycle: await _ref.read(
              youthBonusByCycleProvider(careerId).future,
            ),
            careerStartsByPlayer: await _ref.read(
              careerDevBonusProvider(careerId).future,
            ),
          ),
      ...await naturalizedPlayersFor(_ref, career),
    ]..sort((a, b) => b.overall.compareTo(a.overall));
    final callUps = await _ref.read(squadRepositoryProvider).callUps(careerId);
    // Reshaping the side must not fill a slot with someone serving a ban.
    final absences = await _ref
        .read(absenceRepositoryProvider)
        .forCareer(careerId);
    return selectable(availableSquad(pool, callUps), absences);
  }

  Future<void> setFormation(int careerId, Formation formation) => _update(
    careerId,
    (t, pool) => t.copyWith(
      formation: formation,
      lineup: bestEleven(formation, pool),
    ),
  );

  /// Changes the shape but keeps the players currently in the XI, re-fitting
  /// them to the new formation's slots (used when a drag reshapes the team, so
  /// dragging one player doesn't reshuffle the whole side from the pool).
  Future<void> reshapeFormation(int careerId, Formation formation) => _update(
    careerId,
    (t, pool) {
      final ids = t.lineup.whereType<int>().toSet();
      final current = pool.where((p) => ids.contains(p.id)).toList();
      final fitPool = current.length >= 11
          ? current
          : [...current, ...pool.where((p) => !ids.contains(p.id))];
      return t.copyWith(
        formation: formation,
        lineup: bestEleven(formation, fitPool),
      );
    },
  );

  /// Adopts a general playing style, composing it straight into the six
  /// instruction dials.
  ///
  /// This is the "what do we do" decision; the dials underneath are the "how
  /// much" of it, and stay available. [Playstyle.custom] is not adoptable — it
  /// is what the tactic BECOMES when a dial is moved by hand.
  Future<void> setPlaystyle(int careerId, Playstyle style) {
    final composed = style.instructions;
    if (composed == null) return Future.value();
    return _update(
      careerId,
      (t, _) => t.copyWith(playstyle: style, instructions: composed),
    );
  }

  Future<void> setInstructions(int careerId, TacticalInstructions i) => _update(
    careerId,
    // A hand-moved dial re-labels the tactic honestly: it is the named style
    // only while it still matches that style's profile exactly.
    (t, _) => t.copyWith(instructions: i, playstyle: PlaystyleX.matching(i)),
  );

  /// Applies a saved preset: adopts its shape (re-picking the best available XI
  /// for it) and its instruction sliders in one write.
  Future<void> applyPreset(
    int careerId,
    Formation formation,
    TacticalInstructions instructions,
  ) => _update(
    careerId,
    (t, pool) => t.copyWith(
      formation: formation,
      lineup: bestEleven(formation, pool),
      instructions: instructions,
      playstyle: PlaystyleX.matching(instructions),
    ),
  );

  /// Assigns [playerId] to [slot], swapping if they already start elsewhere.
  Future<void> setSlot(int careerId, int slot, int playerId) =>
      _update(careerId, (t, _) {
        final lineup = [...t.lineup];
        final existing = lineup.indexOf(playerId);
        if (existing != -1) lineup[existing] = lineup[slot];
        lineup[slot] = playerId;
        return t.copyWith(lineup: lineup);
      });

  /// Swaps the players occupying [slotA] and [slotB] (drag-and-drop on pitch).
  Future<void> swapSlots(int careerId, int slotA, int slotB) =>
      _update(careerId, (t, _) {
        if (slotA == slotB) return t;
        final lineup = [...t.lineup];
        final tmp = lineup[slotA];
        lineup[slotA] = lineup[slotB];
        lineup[slotB] = tmp;
        return t.copyWith(lineup: lineup);
      });
}

final Provider<TacticService> tacticServiceProvider = Provider(
  TacticService.new,
);

/// Mutates and persists the called-up squad for a save.
class SquadService {
  SquadService(this._ref);

  final Ref _ref;

  /// Replaces the called-up squad, then repairs the saved XI so it only
  /// contains called-up players (refilling dropped slots from the new squad).
  ///
  /// Returns whether the squad was saved: too small a squad is rejected, and
  /// the caller must not report success (or retire a forced call-up event) for
  /// a save that didn't happen.
  Future<bool> setCallUps(int careerId, Set<int> ids) async {
    if (ids.length < kMinSquadSize) return false;
    await _ref.read(squadRepositoryProvider).setCallUps(careerId, ids);

    final tacticRepo = _ref.read(tacticsRepositoryProvider);
    final tactic = await tacticRepo.tacticForCareer(careerId);
    if (tactic != null) {
      final career = await _ref.read(careerRepositoryProvider).byId(careerId);
      final pool = career == null
          ? <Player>[]
          : [
              ...await _ref
                  .read(playerRepositoryProvider)
                  .byNation(
                    career.nationId,
                    agingYears: CareerService.agingYears(career),
                    saveSeed: career.rngSeed,
                    youthBonusByCycle: await _ref.read(
                      youthBonusByCycleProvider(careerId).future,
                    ),
                    careerStartsByPlayer: await _ref.read(
                      careerDevBonusProvider(careerId).future,
                    ),
                  ),
              ...await naturalizedPlayersFor(_ref, career),
            ];
      // A squad may now legitimately include banned/injured players (the
      // manager picks the squad; the game decides who can play), so the XI is
      // refilled from those actually available for the next match.
      final absences = await _ref
          .read(absenceRepositoryProvider)
          .forCareer(careerId);
      final squad = selectable(availableSquad(pool, ids), absences);
      final dropped = tactic.lineup.whereType<int>().any(
        (id) => !ids.contains(id),
      );
      if (dropped) {
        await tacticRepo.saveTactic(
          careerId,
          tactic.copyWith(lineup: bestEleven(tactic.formation, squad)),
        );
      }
    }

    _ref
      ..invalidate(squadDataProvider)
      ..invalidate(tacticDataProvider);
    return true;
  }
}

final Provider<SquadService> squadServiceProvider = Provider(SquadService.new);
