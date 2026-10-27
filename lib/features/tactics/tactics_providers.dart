import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/player_roles_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';

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
///
/// The manager's pools read down to [PlayerLifecycle.callUpMinAge] so a U-17
/// he called up can be fielded; both fallbacks are the SENIORS of [pool], so a
/// squad nobody named never sweeps in the academy (the same rule as
/// [defaultCallUpIds]). A pool that stops at seventeen is unaffected.
List<Player> availableSquad(List<Player> pool, Set<int> callUps) {
  List<Player> seniors() =>
      pool.where((p) => p.age >= PlayerLifecycle.seniorMinAge).toList();
  if (callUps.isEmpty) return seniors();
  final selected = pool.where((p) => callUps.contains(p.id)).toList();
  return selected.isEmpty ? seniors() : selected;
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
    ...await withoutNaturalizedAway(
      ref,
      careerId,
      await ref
          .watch(playerRepositoryProvider)
          .byNation(
            career.nationId,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
            careerId: career.id,
            minAge: PlayerLifecycle.callUpMinAge,
            youthBonusByCycle: await ref.watch(
              youthBonusByCycleProvider(careerId).future,
            ),
            careerStartsByPlayer: await ref.watch(
              careerDevBonusProvider(careerId).future,
            ),
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
    if (p.age >= PlayerLifecycle.seniorMinAge) p.id,
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
    // is a decision the manager can make. The pools his XI is picked from read
    // down as far (see [availableSquad]); the world keeps the default
    // seventeen — see [PlayerLifecycle.poolAt].
    ...await withoutNaturalizedAway(
      ref,
      careerId,
      await ref
          .watch(playerRepositoryProvider)
          .byNation(
            career.nationId,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
            careerId: career.id,
            minAge: PlayerLifecycle.callUpMinAge,
            youthBonusByCycle: await ref.watch(
              youthBonusByCycleProvider(careerId).future,
            ),
            careerStartsByPlayer: await ref.watch(
              careerDevBonusProvider(careerId).future,
            ),
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

  /// The write in flight, so the next waits for it.
  ///
  /// Every change reads the stored tactic, works, and saves; two started
  /// together both read the same tactic and the second save threw the first
  /// away. Nothing invited quick repeat taps until the full-back arrow, where
  /// two taps to reach "hold back" landed as one.
  Future<void> _tail = Future<void>.value();

  Future<void> _update(
    int careerId,
    Tactic Function(Tactic current, List<Player> pool) change,
  ) {
    final run = _tail.then((_) => _write(careerId, change));
    _tail = run.then((_) {}, onError: (Object _) {});
    return run;
  }

  Future<void> _write(
    int careerId,
    Tactic Function(Tactic current, List<Player> pool) change,
  ) async {
    final repo = _ref.read(tacticsRepositoryProvider);
    final current = await repo.tacticForCareer(careerId);
    if (current == null) return;
    final pool = await _availablePool(careerId);
    await repo.saveTactic(careerId, change(current, pool));
    _ref
      ..invalidate(tacticDataProvider)
      // The forced "reshape your XI" event reads the saved lineup. On a phone
      // the hub is rebuilt on the way back and asks again, but the tablet
      // keeps the event button in the shell's top bar for the whole session,
      // so its answer was never thrown away: the manager fixed the XI and the
      // button went on sending him back to fix it.
      ..invalidate(nextEventProvider(careerId));
    // And the match about to be played. The pre-match screen holds it open
    // underneath tactics, and refreshing it on the way back missed every other
    // way in (the set-up warning) and any write still landing.
    _refreshMatchPreview(_ref, careerId);
  }

  Future<List<Player>> _availablePool(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return const [];
    final pool = [
      ...await withoutNaturalizedAway(
        _ref,
        careerId,
        await _ref
            .read(playerRepositoryProvider)
            .byNation(
              career.nationId,
              agingYears: CareerService.agingYears(career),
              saveSeed: career.rngSeed,
              careerId: career.id,
              minAge: PlayerLifecycle.callUpMinAge,
              youthBonusByCycle: await _ref.read(
                youthBonusByCycleProvider(careerId).future,
              ),
              careerStartsByPlayer: await _ref.read(
                careerDevBonusProvider(careerId).future,
              ),
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
    TacticalInstructions instructions, {
    FullBackPushes fullBacks = FullBackPushes.neutral,
  }) => _update(
    careerId,
    (t, pool) => t.copyWith(
      formation: formation,
      lineup: bestEleven(formation, pool),
      instructions: instructions,
      playstyle: PlaystyleX.matching(instructions),
      fullBacks: t.fullBacks.overlaidWith(fullBacks),
    ),
  );

  /// Moves [side]'s full-back arrow on one tap (neutral, push on, hold back)
  /// and returns the state it now holds, read off the stored tactic rather
  /// than the screen, which may be a tap behind.
  Future<FullBackPush> cycleFullBack(int careerId, FullBackSide side) async {
    var now = FullBackPush.neutral;
    await _update(careerId, (t, _) {
      final next = t.fullBacks.cycled(side);
      now = next.of(side);
      return t.copyWith(fullBacks: next);
    });
    return now;
  }

  /// Sets [side]'s full-back arrow to [push] (the Instructions tab).
  Future<void> setFullBack(
    int careerId,
    FullBackSide side,
    FullBackPush push,
  ) => _update(
    careerId,
    (t, _) => t.copyWith(fullBacks: t.fullBacks.withSide(side, push)),
  );

  /// Loads [library] from the tactics library into this save: its shape (with
  /// the best available eleven re-picked for it), style and dials in one
  /// write, then its roles and set-piece takers re-attached to whoever now
  /// fills each slot (see [LibraryTactic.fit]). Returns how it fitted, or null
  /// when the save has no tactic to load into.
  Future<LibraryFit?> applyLibraryTactic(
    int careerId,
    LibraryTactic library,
  ) async {
    LibraryFit? fit;
    await _update(careerId, (t, pool) {
      final lineup = bestEleven(library.formation, pool);
      fit = library.fit(lineup, {for (final p in pool) p.id: p});
      return t.copyWith(
        formation: library.formation,
        lineup: lineup,
        instructions: library.instructions,
        playstyle: library.playstyle,
        fullBacks: t.fullBacks.overlaidWith(library.fullBacks),
      );
    });
    final result = fit;
    if (result == null) return null;
    await _ref.read(playerRolesStoreProvider).setRoles(careerId, result.roles);
    await _ref
        .read(setPieceTakersStoreProvider)
        .setBoth(
          careerId,
          penalty: result.penaltyTaker,
          deadBall: result.deadBallTaker,
        );
    return result;
  }

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
              ...await withoutNaturalizedAway(
                _ref,
                careerId,
                await _ref
                    .read(playerRepositoryProvider)
                    .byNation(
                      career.nationId,
                      agingYears: CareerService.agingYears(career),
                      saveSeed: career.rngSeed,
                      careerId: career.id,
                      minAge: PlayerLifecycle.callUpMinAge,
                      youthBonusByCycle: await _ref.read(
                        youthBonusByCycleProvider(careerId).future,
                      ),
                      careerStartsByPlayer: await _ref.read(
                        careerDevBonusProvider(careerId).future,
                      ),
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
      ..invalidate(tacticDataProvider)
      // The call-up can repair the XI too; see [TacticService._update].
      ..invalidate(nextEventProvider(careerId));
    _refreshMatchPreview(_ref, careerId);
    return true;
  }

  /// Sends [outId], injured (or banned) mid-window, home and calls [inId] up
  /// in his place: the squad stays the same size, so its limits hold.
  ///
  /// Not through [setCallUps], which re-picks the whole XI when a starter is
  /// dropped. Only the injured man's slot is emptied; the forced "reshape your
  /// XI" step then asks the manager to fill it, as it would have anyway.
  Future<void> replaceInjured(
    int careerId, {
    required int outId,
    required int inId,
  }) => sendHome(careerId, outId: outId, inId: inId);

  /// Sends [outId] home for the rest of the window, calling [inId] up in his
  /// place when given (the squad is one short when not). The same surgery as
  /// [replaceInjured]: only his slot in the XI is emptied, and the forced
  /// "reshape your XI" step asks the manager to fill it.
  ///
  /// Out of the stored squad is out of everything that picks from it: the
  /// tactics board, the auto-picked XI and the quick-sim of his own matches
  /// all read the call-ups.
  Future<void> sendHome(
    int careerId, {
    required int outId,
    int? inId,
  }) async {
    final squads = _ref.read(squadRepositoryProvider);
    final current = await squads.callUps(careerId);
    await squads.setCallUps(
      careerId,
      {
          ...current,
        }
        ..remove(outId)
        ..addAll([?inId]),
    );
    final tacticRepo = _ref.read(tacticsRepositoryProvider);
    final tactic = await tacticRepo.tacticForCareer(careerId);
    if (tactic != null && tactic.lineup.contains(outId)) {
      await tacticRepo.saveTactic(
        careerId,
        tactic.copyWith(
          lineup: [for (final id in tactic.lineup) id == outId ? null : id],
        ),
      );
    }
    _ref
      ..invalidate(squadDataProvider)
      ..invalidate(tacticDataProvider)
      ..invalidate(nextEventProvider(careerId));
    _refreshMatchPreview(_ref, careerId);
  }
}

final Provider<SquadService> squadServiceProvider = Provider(SquadService.new);

/// Refreshes the pre-match preview after a change to the teamsheet, if one is
/// open. Only if: invalidating one nobody holds would build it, squads and a
/// whole simulated match, for every tweak made from anywhere.
void _refreshMatchPreview(Ref ref, int careerId) {
  if (ref.exists(matchPreviewProvider(careerId))) {
    ref.invalidate(matchPreviewProvider(careerId));
  }
}
