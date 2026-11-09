import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/world_managers/manager_decisions.dart';
import 'package:fnm/domain/services/world_managers/manager_entrants.dart';
import 'package:fnm/domain/services/world_managers/manager_names.dart';
import 'package:fnm/domain/services/world_managers/manager_seeder.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/staff_providers.dart';
import 'package:fnm/features/world_managers/manager_windows.dart';
import 'package:fnm/features/world_managers/world_manager_markers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart'
    show worldManagerStyleEnabledProvider;
import 'package:fnm/features/world_pack/world_pack_providers.dart'
    show worldPackRepositoryProvider;

/// The world managers of a career: seeded the first time something asks
/// for them, and read by date.
///
/// Seeding never runs on its own: not when a career opens, not on a hub
/// read. Only [ensureSeeded] (directly, or through [styleOn]) seeds.
class WorldManagerService {
  WorldManagerService(this._ref);

  final Ref _ref;

  /// One seeding per career, shared by every caller while it runs. A failed
  /// one is forgotten, so the next caller tries again.
  final Map<int, Future<void>> _seeding = {};

  /// Seeds career [careerId]'s managers unless it has them already: as of
  /// the day its current cycle opened, in one transaction.
  Future<void> ensureSeeded(int careerId) =>
      _seeding[careerId] ??= _seedOnce(careerId);

  Future<void> _seedOnce(int careerId) async {
    try {
      await _seed(careerId);
    } on Object {
      _seeding.removeWhere((id, _) => id == careerId);
      rethrow;
    }
  }

  /// Every real person the pools are known to be able to name, whatever
  /// the era: a manager is named once, when he is seeded, so guarding them
  /// all moves nobody's name.
  static final Set<String> _realNames = {
    ...realFinlandInternationals,
    for (final m in [
      guardedNamesByNation,
      guardedNamesFullPoolsByNation,
      guardedNamesPoolsV4ByNation,
      guardedNamesPoolsV5ByNation,
    ])
      for (final names in m.values) ...names,
  };

  Future<void> _seed(int careerId) async {
    final repo = _ref.read(worldManagerRepositoryProvider);
    if (await repo.hasManagers(careerId)) return;
    final watch = Stopwatch()..start();
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    final seedCycle = career.cyclePointer;
    final players = _ref.read(playerRepositoryProvider);
    final nations = await _ref
        .read(nationRepositoryProvider)
        .forCareer(careerId);
    final snapshot = await _ref
        .read(seedRankingRepositoryProvider)
        .forCycle(careerId, seedCycle);
    final world = ManagerSeeder.seed(
      rngSeed: career.rngSeed,
      seedCycle: seedCycle,
      asOf: CareerService.cycleOpens(seedCycle),
      nations: nations,
      // The cycle's seeding snapshot; the live table only where there is
      // none (a cycle 0 from before snapshots).
      rankById: snapshot.isNotEmpty
          ? snapshot
          : {for (final n in nations) n.id: n.ranking},
      playerNationIds: {career.nationId},
      pools: await players.namePoolsFor(careerId),
      defaultPools: await players.namePoolsFor(careerId, worldLists: false),
      // Checked again here: a world can come in by a career bundle too.
      packManagers: WorldPack.usableManagers(
        await _ref.read(worldPackRepositoryProvider).managersFor(careerId),
        nationIds: {for (final n in nations) n.id},
        codes: {for (final n in nations) n.code.toUpperCase()},
        dropped: (id, why) =>
            AppLog.info('mgr-seed', 'manager of nation $id dropped: $why'),
      ),
      realNames: _realNames,
    );
    await repo.apply(
      careerId,
      ManagerChanges(added: world.managers, opened: world.spells),
    );
    AppLog.info('mgr-seed', '${watch.elapsedMilliseconds} ms');
  }

  /// Whether the cycle open on [date] is run by world managers.
  Future<bool> cycleHasManagers(int careerId, DateTime date) => _ref
      .read(competitionRepositoryProvider)
      .hasWatchedDraw(careerId, CareerService.cycleAt(date), worldManagersKind);

  /// The style of the manager in charge of [nationId] on [date]: the style
  /// the AI's tactics blend into the nation's own (`AiTactics.forOpponent`).
  /// Null when that date's cycle is not run by world managers, when nobody
  /// was in charge, or when manager style is switched off
  /// ([worldManagerStyleEnabledProvider]); the nation's own style is read
  /// alone then, exactly as before world managers.
  ///
  /// Every AI-tactics reading (the live match, the skip path, the scout's
  /// replays) asks this with the FIXTURE's date, never today's, so all of
  /// them meet the same manager for the same fixture.
  ///
  /// It sits on the match hot paths, so it reads two indexed rows (the
  /// spell in charge, then its manager) rather than the whole manager world,
  /// and keeps no cache that a later write could leave stale.
  Future<NationStyle?> styleOn(
    int careerId,
    int nationId,
    DateTime date,
  ) async {
    if (!_ref.read(worldManagerStyleEnabledProvider)) return null;
    if (!await cycleHasManagers(careerId, date)) return null;
    await ensureSeeded(careerId);
    final repo = _ref.read(worldManagerRepositoryProvider);
    final spell = await repo.inChargeOn(careerId, nationId, date);
    if (spell == null) return null;
    final manager = await repo.managerById(careerId, spell.managerId);
    if (manager == null) return null;
    return NationStyle.values.asNameMap()[manager.style];
  }

  /// Whether the finals decision point [key] on [date] is still to run:
  /// its cycle is run by world managers and the point has not run yet. Two
  /// marker reads; lets a hook skip building its scope.
  Future<bool> finalsPending(
    int careerId, {
    required String key,
    required DateTime date,
  }) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final cycle = CareerService.cycleAt(date);
    return await comp.hasWatchedDraw(careerId, cycle, worldManagersKind) &&
        !await comp.hasWatchedDraw(careerId, cycle, mgrDecidedKind(key));
  }

  /// The decision point after a finals tournament settles: [key] is the
  /// tournament's ([ManagerWindows.worldKey] or
  /// [ManagerWindows.continentalKey]), [scope] the nations whose brief it
  /// settles, [date] the day of its final. Runs once per [key], and only in
  /// a cycle run by world managers; returns the moves it made.
  Future<List<ManagerMove>> afterFinals(
    int careerId, {
    required String key,
    required Set<int> scope,
    required DateTime date,
  }) {
    final cycle = CareerService.cycleAt(date);
    return _pass(
      careerId,
      cycle: cycle,
      closing: cycle,
      marker: mgrDecidedKind(key),
      key: key,
      scope: scope,
      date: date,
      rollover: false,
    );
  }

  /// The decision point of the rollover into [nextCycle], on the day it
  /// opens: retirements, contracts, poaching and hiring across the world.
  /// Called once the cycle pointer has moved and [nextCycle]'s seeding
  /// ranking is frozen; runs once, and only if [nextCycle] is marked
  /// [worldManagersKind].
  Future<List<ManagerMove>> atRollover(
    int careerId, {
    required int nextCycle,
  }) => _rollover(careerId, nextCycle, null);

  /// The rollover's decision point when the player takes a new job: run in
  /// place of [atRollover], as one pass, on the day the cycle open on
  /// [date] opens. The man in charge at [to] loses his job to the player
  /// (`replacedByPlayer`, with a grudge tie) and joins the free pool; the
  /// nation [from] hires at once in the same pass, and its new man gets a
  /// successor tie. Runs once, and only if that cycle is marked
  /// [worldManagersKind].
  Future<List<ManagerMove>> playerMoved(
    int careerId, {
    required int? from,
    required int to,
    required DateTime date,
  }) => _rollover(careerId, CareerService.cycleAt(date), (from: from, to: to));

  Future<List<ManagerMove>> _rollover(
    int careerId,
    int nextCycle,
    _PlayerMove? move,
  ) => _pass(
    careerId,
    cycle: nextCycle,
    closing: nextCycle - 1,
    marker: mgrRolloverKind,
    key: 'rollover:$nextCycle',
    scope: null,
    date: CareerService.cycleOpens(nextCycle),
    rollover: true,
    move: move,
  );

  /// The tie a manager forms with the player when one of them takes the
  /// other's job, and when an assistant of his leaves or a player of his
  /// comes into management (spec section 3).
  static const int grudgeDelta = -25;
  static const int successorDelta = -25;
  static const int protegeDelta = 40;
  static const int formerPlayerDelta = 20;

  /// The games a former international must have played under the player to
  /// enter as his former player.
  static const int formerPlayerMinCaps = 5;

  /// How many former internationals are looked up, at most, to find the
  /// rollover's share of them.
  static const int maxExPlayerLookups = 200;

  /// An assistant who leaves enters the pool this old, in years.
  static const int assistantMinAge = 38;
  static const int assistantMaxAge = 55;

  /// The player's assistant [candidateId] has left him on [date] (replaced,
  /// let go, or left behind when the player moved): he enters the free pool
  /// as an `exAssistant`, with a protégé tie, unless he is in it already.
  /// Nothing happens when [date]'s cycle is not run by world managers.
  ///
  /// [name] and [country] are what the staff room knew him as. An empty
  /// [name] (a man hired in an earlier cycle) is derived again from his id
  /// ([assistantNamed]), and [country] with it.
  Future<void> assistantLeft(
    int careerId, {
    required int candidateId,
    required String name,
    required String? country,
    required DateTime date,
  }) async {
    if (!await cycleHasManagers(careerId, date)) return;
    await ensureSeeded(careerId);
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    var who = (name: name.trim(), country: country);
    if (who.name.isEmpty) who = await assistantNamed(careerId, candidateId);
    final code = (who.country ?? '').trim().toUpperCase();
    final nationality = code.isNotEmpty
        ? code
        : await _homeCode(career.nationId);
    final rng = SeededRng(
      varietySeed('mgr:asstAge:${career.rngSeed}:$candidateId'),
    );
    final age = rng.rangeInt(assistantMinAge, assistantMaxAge);
    final style = ManagerSeeder.drawStyle('', nationality, rng);
    final repo = _ref.read(worldManagerRepositoryProvider);
    await _ref.read(appDatabaseProvider).transaction(() async {
      final w = await repo.load(careerId);
      if (w.managers.any(
        (m) =>
            m.origin == ManagerOrigin.exAssistant && m.sourceId == candidateId,
      )) {
        return;
      }
      final id = w.nextManagerId;
      await repo.apply(
        careerId,
        ManagerChanges(
          added: [
            WorldManager(
              managerId: id,
              name: who.name,
              nationality: nationality,
              birthYear: date.year - age,
              style: style.name,
              origin: ManagerOrigin.exAssistant,
              enteredAt: date,
              sourceId: candidateId,
            ),
          ],
        ),
      );
      await repo.addTie(
        careerId,
        managerId: id,
        kind: TieKind.protege,
        delta: protegeDelta,
        date: date,
      );
    });
    AppLog.info('mgr-pass', 'assistant $candidateId entered the pool');
  }

  /// The name and country of staff candidate [candidateId], derived again
  /// from his id: the staff market of the cycle he applied in
  /// ([StaffMarket.cycleOf]), drawn from the staff room's name pool as it
  /// stands. Only if that market cannot name him (no pool at all) is he
  /// named from the home pool, as a man of the player's own country.
  ///
  /// Read it before the player moves on: the pool is drawn around his
  /// current nation.
  Future<({String name, String? country})> assistantNamed(
    int careerId,
    int candidateId,
  ) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return (name: '', country: null);
    final pool = await staffNamePool(_ref.read, careerId);
    final hit = StaffMarket.forRole(
      saveSeed: career.rngSeed,
      cycle: StaffMarket.cycleOf(candidateId),
      role: StaffMarket.roleOf(candidateId),
      namePool: pool,
    ).where((c) => c.id == candidateId).firstOrNull;
    if (hit != null && hit.name.trim().isNotEmpty) {
      return (name: hit.name, country: hit.country);
    }
    final home = await _homeCode(career.nationId);
    final pools = await _ref
        .read(playerRepositoryProvider)
        .namePoolsFor(careerId);
    return (
      name: ManagerNames.build(
        ManagerNames.poolFor(pools, home),
        SeededRng(varietySeed('mgr:asst:$candidateId')),
      ),
      country: home,
    );
  }

  Future<String> _homeCode(int nationId) async {
    final nation = await _ref.read(nationRepositoryProvider).byId(nationId);
    return nation?.code.toUpperCase() ?? 'ENG';
  }

  /// One decision point. [cycle] is the cycle the point belongs to (its
  /// markers live there); [closing] is the cycle whose results it judges,
  /// the same one except at a rollover. [scope] null is every nation.
  ///
  /// Reads: the managers once, the [closing] cycle's competitions and
  /// fixtures once, the honours once, the seeding rankings, and a marker per
  /// earlier finals point. Writes the changes and [marker] in one
  /// transaction.
  Future<List<ManagerMove>> _pass(
    int careerId, {
    required int cycle,
    required int closing,
    required String marker,
    required String key,
    required Set<int>? scope,
    required DateTime date,
    required bool rollover,
    _PlayerMove? move,
  }) async {
    final comp = _ref.read(competitionRepositoryProvider);
    if (!await comp.hasWatchedDraw(careerId, cycle, worldManagersKind)) {
      return const [];
    }
    if (await comp.hasWatchedDraw(careerId, cycle, marker)) return const [];
    await ensureSeeded(careerId);
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return const [];
    final repo = _ref.read(worldManagerRepositoryProvider);
    final loaded = await repo.load(careerId);
    // The player's new job: the man in charge there is out before anything
    // is decided, so he is in the free pool the hiring draws from.
    final replaced = move == null
        ? null
        : loaded.currentAt(move.to)?.close(date, SpellEnd.replacedByPlayer);
    final w = ManagerWorld(
      managers: loaded.managers,
      spells: [
        for (final sp in loaded.spells)
          if (replaced != null && sp.spellNo == replaced.spellNo)
            replaced
          else
            sp,
      ],
    );
    final nations = await _ref
        .read(nationRepositoryProvider)
        .forCareer(careerId);
    final rankings = _ref.read(seedRankingRepositoryProvider);
    Future<Map<int, int>> rankOf(int c) async {
      final snap = await rankings.forCycle(careerId, c);
      return snap.isNotEmpty
          ? snap
          : {for (final n in nations) n.id: n.ranking};
    }

    final rankById = await rankOf(cycle);
    final inScope = scope ?? {for (final n in nations) n.id};
    final players = {move?.to ?? career.nationId};

    // The windows. A rollover judges only a cycle that was itself run by
    // world managers: an upgraded save's first cycle had none, and its
    // results sack nobody.
    final windows = <int, NationWindow>{};
    final metOn = <int, DateTime>{};
    if (!rollover ||
        await comp.hasWatchedDraw(careerId, closing, worldManagersKind)) {
      final read = await comp.cycleFixtures(careerId, closing);
      final briefs = ManagerWindows(
        nations: nations,
        baseline: closing == cycle ? rankById : await rankOf(closing),
        competitions: read.competitions,
        fixtures: read.fixtures,
      );
      _windows(
        briefs,
        windows: windows,
        metOn: metOn,
        w: w,
        scope: inScope,
        players: players,
        own: rollover ? null : ManagerWindows.fromKey(key, date),
        ran: {
          for (final t in briefs.decided)
            if (t.key != key &&
                t.finalOn.isBefore(date) &&
                await comp.hasWatchedDraw(
                  careerId,
                  closing,
                  mgrDecidedKind(t.key),
                ))
              t.key,
        },
        opens: CareerService.cycleOpens(closing),
        date: date,
      );
    }

    final ctx = (
      date: date,
      rankById: rankById,
      scope: inScope,
      playerNationIds: players,
      rngSeed: career.rngSeed,
      key: key,
      rollover: rollover,
    );
    final honours = _honoursByManager(await comp.honours(careerId), w);
    final codeById = {for (final n in nations) n.id: n.code};
    ManagerChanges decide(List<WorldManager> entrants) =>
        ManagerDecisions.decide(
          w,
          windows,
          ctx,
          honoursByManager: honours,
          entrants: entrants,
          finalsBriefMetOn: metOn,
          codeById: codeById,
        );

    var changes = decide(const []);
    final ties = <({int managerId, TieKind kind, int delta})>[];
    if (rollover) {
      // The entrants top the pool back up to its size: they join it after
      // the retirements and departures (which they cannot change), so a
      // first run without them says how many are wanted.
      final want = ManagerEntrants.poolSize - _poolAfterExits(w, changes, date);
      if (want > 0) {
        final entrants = await _entrants(
          career,
          w,
          nations,
          cycle: cycle,
          date: date,
          count: want,
        );
        changes = decide(entrants.managers);
        ties.addAll(entrants.ties);
      }
    }
    final moves = [...changes.moves];
    if (replaced != null) {
      changes = ManagerChanges(
        added: changes.added,
        updated: changes.updated,
        opened: changes.opened,
        closed: [replaced, ...changes.closed],
        renewed: changes.renewed,
        ties: changes.ties,
        moves: changes.moves,
      );
      ties.add((
        managerId: replaced.managerId,
        kind: TieKind.grudge,
        delta: grudgeDelta,
      ));
      moves
        ..add((
          nationId: replaced.nationId,
          outgoingId: replaced.managerId,
          why: SpellEnd.replacedByPlayer,
          incomingId: null,
          date: date,
        ))
        ..sort((a, b) => a.nationId.compareTo(b.nationId));
    }
    if (move?.from case final left?) {
      for (final m in changes.moves) {
        if (m.nationId == left && m.incomingId != null) {
          ties.add((
            managerId: m.incomingId!,
            kind: TieKind.successor,
            delta: successorDelta,
          ));
        }
      }
    }

    var applied = false;
    await _ref.read(appDatabaseProvider).transaction(() async {
      if (await comp.hasWatchedDraw(careerId, cycle, marker)) return;
      await repo.apply(careerId, changes);
      for (final t in ties) {
        await repo.addTie(
          careerId,
          managerId: t.managerId,
          kind: t.kind,
          delta: t.delta,
          date: date,
        );
      }
      await comp.markDrawWatched(careerId, cycle, marker);
      applied = true;
    });
    if (!applied) return const [];
    AppLog.info(
      'mgr-pass',
      '$key: ${moves.length} moves, ${windows.length} windows, '
          '${changes.added.length} entrants',
    );
    return moves;
  }

  /// The free pool once [changes]' retirements and departures are counted,
  /// before anyone is hired: the free and unretired, plus every man who
  /// lost his job at this point and did not retire or move straight on.
  static int _poolAfterExits(
    ManagerWorld w,
    ManagerChanges changes,
    DateTime date,
  ) {
    final retired = {
      for (final m in changes.updated)
        if (m.retiredAt != null) m.managerId,
    };
    return {
      for (final m in w.free(date))
        if (!retired.contains(m.managerId)) m.managerId,
      for (final sp in changes.closed)
        if (sp.endReason != SpellEnd.poached && !retired.contains(sp.managerId))
          sp.managerId,
    }.length;
  }

  /// The rollover's [count] entrants and the ties they bring: a share of
  /// former internationals (those the international-retirement markers
  /// name, aged [ManagerEntrants.exPlayerMinAge] to
  /// [ManagerEntrants.exPlayerMaxAge] this year, not in the world already),
  /// the rest fresh names. A former international who played
  /// [formerPlayerMinCaps] games for the player, inside the cycles he ran
  /// the man's nation, enters as his former player.
  Future<
    ({
      List<WorldManager> managers,
      List<({int managerId, TieKind kind, int delta})> ties,
    })
  >
  _entrants(
    Career career,
    ManagerWorld w,
    List<Nation> nations, {
    required int cycle,
    required DateTime date,
    required int count,
  }) async {
    final careerId = career.id;
    final players = _ref.read(playerRepositoryProvider);
    final codeOf = {for (final n in nations) n.id: n.code.toUpperCase()};
    final years = CareerService.agingYears(career.copyWith(inGameDate: date));

    // The former internationals, in a seeded order, looked up one at a
    // time until the share is found.
    final wantEx = ManagerEntrants.exPlayersOf(count);
    final ex = <ExInternational>[];
    final exNation = <int, int>{};
    if (wantEx > 0) {
      final known = {
        for (final m in w.managers)
          if (m.origin == ManagerOrigin.exPlayer && m.sourceId != null)
            m.sourceId!,
      };
      final retired = await players.internationalRetirements(careerId);
      final ids = [
        for (final e in retired.entries)
          if (!known.contains(e.key) && e.value.isRetiredAt(years)) e.key,
      ]..sort();
      final order = SeededRng(
        varietySeed('mgr:exintl:${career.rngSeed}:$cycle'),
      ).shuffled(ids);
      var looked = 0;
      for (final id in order) {
        if (ex.length >= wantEx || looked >= maxExPlayerLookups) break;
        looked++;
        final p = await players.byId(
          id,
          agingYears: years,
          saveSeed: career.rngSeed,
          careerId: careerId,
        );
        if (p == null ||
            p.age < ManagerEntrants.exPlayerMinAge ||
            p.age > ManagerEntrants.exPlayerMaxAge) {
          continue;
        }
        final code = codeOf[p.nationId];
        if (code == null || p.name.trim().isEmpty) continue;
        ex.add((
          playerId: p.id,
          name: p.name.trim(),
          birthYear: date.year - p.age,
          nationality: code,
        ));
        exNation[p.id] = p.nationId;
      }
    }

    final managers = ManagerEntrants.build(
      rngSeed: career.rngSeed,
      cycle: cycle,
      date: date,
      count: count,
      firstId: w.nextManagerId,
      nations: nations,
      pools: await players.namePoolsFor(careerId),
      defaultPools: await players.namePoolsFor(careerId, worldLists: false),
      realNames: _realNames,
      usedNames: {for (final m in w.managers) m.name},
      exPlayers: ex,
    );

    // The player's spells in charge of each nation, before this cycle,
    // each run of consecutive cycles one stretch of dates.
    final ties = <({int managerId, TieKind kind, int delta})>[];
    if (ex.isNotEmpty) {
      final stints = await _ref.read(careerRepositoryProvider).stints(careerId);
      final stretches = <int, List<({DateTime from, DateTime to})>>{};
      final cycles = stints.keys.where((c) => c < cycle).toList()..sort();
      for (var k = 0; k < cycles.length; k++) {
        final first = cycles[k];
        final nationId = stints[first]!;
        while (k + 1 < cycles.length &&
            cycles[k + 1] == cycles[k] + 1 &&
            stints[cycles[k + 1]] == nationId) {
          k++;
        }
        (stretches[nationId] ??= []).add((
          from: CareerService.cycleOpens(first),
          to: CareerService.cycleOpens(cycles[k] + 1),
        ));
      }

      final comp = _ref.read(competitionRepositoryProvider);
      for (final m in managers) {
        if (m.origin != ManagerOrigin.exPlayer) continue;
        final nationId = exNation[m.sourceId];
        if (nationId == null) continue;
        var caps = 0;
        for (final r
            in stretches[nationId] ??
                const <({DateTime from, DateTime to})>[]) {
          caps += await comp.capsUnder(
            careerId,
            m.sourceId!,
            nationId,
            r.from,
            r.to,
          );
        }
        if (caps >= formerPlayerMinCaps) {
          ties.add((
            managerId: m.managerId,
            kind: TieKind.formerPlayer,
            delta: formerPlayerDelta,
          ));
        }
      }
    }
    return (managers: managers, ties: ties);
  }

  /// Fills [windows] and [metOn] for the AI nations of [scope] that have a
  /// manager in charge.
  ///
  /// A nation's window runs from the later of its manager's start and its
  /// last decision point (the closing cycle's opening [opens], or an earlier
  /// finals point that [ran]) up to [date]. The briefs settled in it are
  /// [own] (the point's own tournament) and any other tournament whose final
  /// fell inside it without its own point having run; a nation with none
  /// gets no window at all, so a rollover judges contracts on the score each
  /// spell carries.
  ///
  /// [metOn] is the shield's memory, which nothing stores: the day of the
  /// latest earlier finals point that [ran] in the last 12 months at which
  /// the nation met its brief, re-read from the same fixtures. Finals points
  /// are two years apart, so the only one ever inside 12 months is the
  /// World Championship before its rollover, in the same cycle.
  static void _windows(
    ManagerWindows briefs, {
    required Map<int, NationWindow> windows,
    required Map<int, DateTime> metOn,
    required ManagerWorld w,
    required Set<int> scope,
    required Set<int> players,
    required SettlingTournament? own,
    required Set<String> ran,
    required DateTime opens,
    required DateTime date,
  }) {
    final yearAgo = DateTime(date.year - 1, date.month, date.day);
    for (final n in scope) {
      if (players.contains(n)) continue;
      final spell = w.currentAt(n);
      if (spell == null) continue;
      var from = spell.fromDate.isAfter(opens) ? spell.fromDate : opens;
      for (final t in briefs.decided) {
        if (!ran.contains(t.key) || !briefs.touches(n, t)) continue;
        if (t.finalOn.isAfter(from)) from = t.finalOn;
        if (t.finalOn.isAfter(yearAgo) && briefs.met(n, t)) {
          final seen = metOn[n];
          if (seen == null || t.finalOn.isAfter(seen)) metOn[n] = t.finalOn;
        }
      }
      final settled = [
        if (own != null && briefs.touches(n, own)) own,
        for (final t in briefs.decided)
          if (t.key != own?.key &&
              !ran.contains(t.key) &&
              briefs.touches(n, t) &&
              t.finalOn.isAfter(from) &&
              !t.finalOn.isAfter(date))
            t,
      ];
      final win = briefs.window(n, from: from, to: date, settled: settled);
      if (win != null) windows[n] = win;
    }
  }

  /// Each manager's major titles (World Championships and continental
  /// championships this career has played): credited to whoever was in
  /// charge of the champion mid-tournament, the 15th of the month it is
  /// played in. No decision point falls inside a nation's own tournament,
  /// so that is the man who took it to the final.
  ///
  /// An approximation: the honour row stores no final date, so a spell
  /// that began or ended between the 15th and the final (none does today,
  /// as no point of the champion's falls there) would be credited wrongly.
  static Map<int, int> _honoursByManager(
    List<Honour> honours,
    ManagerWorld w,
  ) {
    final month = {
      'World Championship': 6,
      for (final cup in ContinentalCups.byConfederation.values)
        cup.name: cup.month,
    };
    final out = <int, int>{};
    for (final h in honours) {
      final m = month[h.competition];
      if (m == null || !CareerService.isOwnHonourYear(h.year)) continue;
      final on = DateTime(h.year, m, 15);
      for (final nationId in h.champions) {
        final spell = w.inChargeOn(nationId, on);
        if (spell == null) continue;
        out[spell.managerId] = (out[spell.managerId] ?? 0) + 1;
      }
    }
    return out;
  }
}

/// The player's move at a rollover: the nation he left (if any) and the one
/// he took.
typedef _PlayerMove = ({int? from, int to});
