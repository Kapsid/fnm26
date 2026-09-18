import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/awards/awards.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';

/// Drift-backed [CompetitionRepository].
class DriftCompetitionRepository implements CompetitionRepository {
  DriftCompetitionRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> transact(Future<void> Function() action) =>
      _db.transaction(action);

  /// The save's current 4-year cycle (Careers.cyclePointer).
  Future<int> _cycle(int careerId) async {
    final c =
        await (_db.select(_db.careers)
              ..where((t) => t.id.equals(careerId))
              ..limit(1))
            .getSingleOrNull();
    return c?.cyclePointer ?? 0;
  }

  @override
  Future<bool> hasSchedule(int careerId) async {
    final row =
        await (_db.select(_db.competitions)
              ..where((t) => t.careerId.equals(careerId))
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  @override
  Future<void> saveSchedule({
    required int careerId,
    required GeneratedSchedule schedule,
    int cycle = 0,
    CompetitionKind kind = CompetitionKind.worldCupQualifying,
    String? fixtureRound,
  }) async {
    await _db.transaction(() async {
      final compId = await _db
          .into(_db.competitions)
          .insert(
            CompetitionsCompanion.insert(
              careerId: careerId,
              confederation: schedule.confederation,
              name: schedule.name,
              cycle: Value(cycle),
              kind: Value(kind),
            ),
          );

      for (final group in schedule.groups) {
        final groupId = await _db
            .into(_db.qualifyingGroups)
            .insert(
              QualifyingGroupsCompanion.insert(
                competitionId: compId,
                name: group.name,
              ),
            );
        await _db.batch((b) {
          b
            ..insertAll(_db.groupMembers, [
              for (final nationId in group.nationIds)
                GroupMembersCompanion.insert(
                  groupId: groupId,
                  nationId: nationId,
                ),
            ])
            ..insertAll(_db.fixtures, [
              for (final f in group.fixtures)
                FixturesCompanion.insert(
                  careerId: careerId,
                  competitionId: compId,
                  groupId: Value(groupId),
                  matchday: f.matchday,
                  date: f.date,
                  homeNationId: f.homeNationId,
                  awayNationId: f.awayNationId,
                  round: Value(fixtureRound),
                ),
            ]);
        });
      }
    });
  }

  @override
  Future<List<Fixture>> fixturesForNation(int careerId, int nationId) async {
    final query = _db.select(_db.fixtures)
      ..where(
        (t) =>
            t.careerId.equals(careerId) &
            (t.homeNationId.equals(nationId) | t.awayNationId.equals(nationId)),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.date)]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<Fixture>> cycleFixturesForNation(
    int careerId,
    int nationId,
  ) async {
    final cycle = await _cycle(careerId);
    final comps = await (_db.select(
      _db.competitions,
    )..where((t) => t.careerId.equals(careerId) & t.cycle.equals(cycle))).get();
    if (comps.isEmpty) return const [];
    final ids = comps.map((c) => c.id).toList();
    final query = _db.select(_db.fixtures)
      ..where(
        (t) =>
            t.careerId.equals(careerId) &
            t.competitionId.isIn(ids) &
            (t.homeNationId.equals(nationId) | t.awayNationId.equals(nationId)),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.date)]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<Map<int, String>> competitionNames(int careerId) async {
    final comps = await (_db.select(
      _db.competitions,
    )..where((t) => t.careerId.equals(careerId))).get();
    return {for (final c in comps) c.id: c.name};
  }

  @override
  Future<List<Fixture>> allFixtures(int careerId) async {
    final query = _db.select(_db.fixtures)
      ..where((t) => t.careerId.equals(careerId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.matchday),
        (t) => OrderingTerm(expression: t.date),
      ]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<Fixture>> unplayedDueBy(
    int careerId,
    DateTime date, {
    int? excludeNationId,
  }) async {
    final query = _db.select(_db.fixtures)
      ..where(
        (t) =>
            t.careerId.equals(careerId) &
            t.played.equals(false) &
            t.date.isSmallerOrEqualValue(date) &
            (excludeNationId == null
                ? const Constant(true)
                : (t.homeNationId.equals(excludeNationId) |
                          t.awayNationId.equals(excludeNationId))
                      .not()),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.date)]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<Fixture?> nextFixtureForNation(int careerId, int nationId) async {
    final query = _db.select(_db.fixtures)
      ..where(
        (t) =>
            t.careerId.equals(careerId) &
            t.played.equals(false) &
            (t.homeNationId.equals(nationId) | t.awayNationId.equals(nationId)),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.date)])
      ..limit(1);
    return (await query.getSingleOrNull())?.toDomain();
  }

  @override
  Future<void> recordResult({
    required int fixtureId,
    required int homeScore,
    required int awayScore,
    bool afterExtraTime = false,
    int? homePenalties,
    int? awayPenalties,
  }) async {
    await (_db.update(
      _db.fixtures,
    )..where((t) => t.id.equals(fixtureId))).write(
      FixturesCompanion(
        homeScore: Value(homeScore),
        awayScore: Value(awayScore),
        played: const Value(true),
        afterExtraTime: Value(afterExtraTime),
        homePenalties: Value(homePenalties),
        awayPenalties: Value(awayPenalties),
      ),
    );
  }

  @override
  Future<void> rescheduleFixture(int fixtureId, DateTime date) async {
    await (_db.update(_db.fixtures)..where((t) => t.id.equals(fixtureId)))
        .write(FixturesCompanion(date: Value(date)));
  }

  @override
  Future<GroupTable?> groupTableForNation(int careerId, int nationId) async {
    final cycle = await _cycle(careerId);
    final all = await (_db.select(
      _db.competitions,
    )..where((t) => t.careerId.equals(careerId) & t.cycle.equals(cycle))).get();
    // The Continental Clash is a ONE-OFF match, stored as a single-fixture
    // "group" (the tournament writer only speaks groups) — so the hub read it
    // as a live group stage and led with "Group F" and a two-line table on the
    // week of the Clash. It has no group stage to show; it belongs on the hub
    // as the next match and nothing else.
    final comps = [
      for (final c in all)
        if (c.kind != CompetitionKind.finalissima) c,
    ];
    if (comps.isEmpty) return null;

    // Rank finals ahead of qualifying so an active tournament (World Cup or
    // continental finals) is shown, not a qualifier running alongside it.
    final ordered = [
      ...comps.where((c) => c.kind == CompetitionKind.worldCupFinals),
      ...comps.where((c) => c.kind == CompetitionKind.continentalFinals),
      ...comps.where(
        (c) =>
            c.kind != CompetitionKind.worldCupFinals &&
            c.kind != CompetitionKind.continentalFinals,
      ),
    ];
    const finalsKinds = {
      CompetitionKind.worldCupFinals,
      CompetitionKind.continentalFinals,
    };
    final kindByComp = {for (final c in comps) c.id: c.kind};
    final groups =
        await (_db.select(_db.qualifyingGroups)..where(
              (t) => t.competitionId.isIn(ordered.map((c) => c.id).toList()),
            ))
            .get();
    if (groups.isEmpty) return null;

    final memberships = await (_db.select(
      _db.groupMembers,
    )..where((t) => t.nationId.equals(nationId))).get();
    final groupById = {for (final g in groups) g.id: g};
    // Pick the membership in the most advanced competition (finals first).
    final rank = {for (var i = 0; i < ordered.length; i++) ordered[i].id: i};
    final compIds = ordered.map((c) => c.id).toList();

    // Competitions still in progress (some fixture unplayed). A qualifying
    // table whose competition is finished must not linger on the hub while the
    // player
    // is between stages (e.g. playing friendlies) — only a live stage is shown.
    final liveRows =
        await (_db.select(_db.fixtures)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.competitionId.isIn(compIds) &
                  t.played.equals(false),
            ))
            .get();
    final liveComps = liveRows.map((f) => f.competitionId).toSet();

    // The player's next unplayed fixture — prefer its group when it's a group
    // game, so the stage they're about to play is what's on screen.
    final nextFx =
        await (_db.select(_db.fixtures)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.competitionId.isIn(compIds) &
                    t.played.equals(false) &
                    (t.homeNationId.equals(nationId) |
                        t.awayNationId.equals(nationId)),
              )
              ..orderBy([(t) => OrderingTerm(expression: t.date)])
              ..limit(1))
            .getSingleOrNull();

    QualifyingGroupRow? group;
    // 1. A live finals group the player is in wins — the active tournament is
    //    always what the hub shows, even if a qualifier's fixture falls sooner.
    var best = 1 << 30;
    for (final m in memberships) {
      final g = groupById[m.groupId];
      if (g == null || !liveComps.contains(g.competitionId)) continue;
      if (!finalsKinds.contains(kindByComp[g.competitionId])) continue;
      final r = rank[g.competitionId] ?? best;
      if (r < best) {
        best = r;
        group = g;
      }
    }
    // 2. Otherwise the group of the stage they're about to play.
    if (group == null && nextFx?.groupId != null) {
      group = groupById[nextFx!.groupId];
    }
    // 3. Otherwise any live group they're in (most advanced first).
    if (group == null) {
      best = 1 << 30;
      for (final m in memberships) {
        final g = groupById[m.groupId];
        if (g == null || !liveComps.contains(g.competitionId)) continue;
        final r = rank[g.competitionId] ?? best;
        if (r < best) {
          best = r;
          group = g;
        }
      }
    }
    if (group == null) return null;
    final groupId = group.id;
    final members = await (_db.select(
      _db.groupMembers,
    )..where((t) => t.groupId.equals(groupId))).get();
    final fixtures = await (_db.select(
      _db.fixtures,
    )..where((t) => t.groupId.equals(groupId))).get();

    final standings = GroupStanding.table(
      members.map((m) => m.nationId).toList(),
      fixtures.map((r) => r.toDomain()).toList(),
    );
    final comp = ordered.firstWhere((c) => c.id == group!.competitionId);
    final groupCount = groups
        .where((g) => g.competitionId == group!.competitionId)
        .length;
    return (
      groupId: groupId,
      name: group.name,
      competition: comp.name,
      kind: comp.kind,
      groupCount: groupCount,
      standings: standings,
    );
  }

  @override
  Future<RoundResults?> lastRoundResults(int careerId, int nationId) async {
    // The player's most recently played fixture (any stage).
    final played =
        await (_db.select(_db.fixtures)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.played.equals(true) &
                    (t.homeNationId.equals(nationId) |
                        t.awayNationId.equals(nationId)),
              )
              ..orderBy([
                (t) =>
                    OrderingTerm(expression: t.date, mode: OrderingMode.desc),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (played == null) return null;

    // A knockout tie → show that round's ties across the tournament, not the
    // now-finished group stage.
    final round = played.round;
    if (round != null && _isKnockoutRound(round)) {
      final comp = await (_db.select(
        _db.competitions,
      )..where((t) => t.id.equals(played.competitionId))).getSingleOrNull();
      if (comp == null) return null;
      final ties =
          await (_db.select(_db.fixtures)
                ..where(
                  (t) =>
                      t.competitionId.equals(played.competitionId) &
                      t.round.equals(round) &
                      t.played.equals(true),
                )
                ..orderBy([(t) => OrderingTerm(expression: t.id)]))
              .get();
      return (
        competition: comp.name,
        kind: comp.kind,
        groupCount: 0,
        matchday: played.matchday,
        groups: const <RoundResultGroup>[],
        stage: _stageLabel(round),
        knockoutFixtures: ties.map((r) => r.toDomain()).toList(),
      );
    }

    final playedGroupId = played.groupId;
    if (playedGroupId == null) return null; // a friendly — nothing to show

    final matchday = played.matchday;
    final group = await (_db.select(
      _db.qualifyingGroups,
    )..where((t) => t.id.equals(playedGroupId))).getSingleOrNull();
    if (group == null) return null;
    final comp = await (_db.select(
      _db.competitions,
    )..where((t) => t.id.equals(group.competitionId))).getSingleOrNull();
    if (comp == null) return null;

    final groups =
        await (_db.select(_db.qualifyingGroups)
              ..where((t) => t.competitionId.equals(group.competitionId))
              ..orderBy([(t) => OrderingTerm(expression: t.name)]))
            .get();

    final result = <RoundResultGroup>[];
    for (final g in groups) {
      final members = await (_db.select(
        _db.groupMembers,
      )..where((t) => t.groupId.equals(g.id))).get();
      final fixtures = await (_db.select(
        _db.fixtures,
      )..where((t) => t.groupId.equals(g.id))).get();
      final standings = GroupStanding.table(
        members.map((m) => m.nationId).toList(),
        fixtures.map((r) => r.toDomain()).toList(),
      );
      final roundFixtures =
          fixtures
              .where((f) => f.matchday == matchday && f.played)
              .map((r) => r.toDomain())
              .toList()
            ..sort((a, b) => a.id.compareTo(b.id));
      result.add((name: g.name, standings: standings, fixtures: roundFixtures));
    }
    // Put the player's own group first, then the rest by name.
    result.sort((a, b) {
      if (a.name == group.name) return -1;
      if (b.name == group.name) return 1;
      return a.name.compareTo(b.name);
    });
    return (
      competition: comp.name,
      kind: comp.kind,
      groupCount: result.length,
      matchday: matchday,
      groups: result,
      stage: null,
      knockoutFixtures: const <Fixture>[],
    );
  }

  /// Whether a round label is a knockout tie (continental rounds are 'C'-
  /// prefixed; group and qualifying rounds never are).
  static bool _isKnockoutRound(String round) => Rounds.isKnockout(round);

  /// A human label for a knockout round (prefix-agnostic).
  static String _stageLabel(String round) {
    final core = round.startsWith('C') ? round.substring(1) : round;
    return switch (core) {
      'R32' => 'Round of 32',
      'R16' => 'Round of 16',
      'QF' => 'Quarter-finals',
      'SF' => 'Semi-finals',
      '3RD' => 'Third-place play-off',
      'FINAL' => 'Final',
      _ => core,
    };
  }

  @override
  Future<List<ConfederationGroupTable>> allGroupTablesByConfederation(
    int careerId,
  ) async {
    final cycle = await _cycle(careerId);
    final comps =
        await (_db.select(_db.competitions)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.cycle.equals(cycle) &
                    t.kind.equalsValue(CompetitionKind.worldCupQualifying),
              )
              ..orderBy([(t) => OrderingTerm(expression: t.id)]))
            .get();

    final result = <ConfederationGroupTable>[];
    for (final comp in comps) {
      final groups =
          await (_db.select(_db.qualifyingGroups)
                ..where((t) => t.competitionId.equals(comp.id))
                ..orderBy([(t) => OrderingTerm(expression: t.name)]))
              .get();
      for (final group in groups) {
        final members = await (_db.select(
          _db.groupMembers,
        )..where((t) => t.groupId.equals(group.id))).get();
        final fixtures = await (_db.select(
          _db.fixtures,
        )..where((t) => t.groupId.equals(group.id))).get();
        result.add((
          confederation: comp.confederation,
          groupName: group.name,
          standings: GroupStanding.table(
            members.map((m) => m.nationId).toList(),
            fixtures.map((r) => r.toDomain()).toList(),
          ),
        ));
      }
    }
    return result;
  }

  @override
  Future<List<Fixture>> fixturesForConfederation(
    int careerId,
    Confederation confederation,
  ) async {
    final cycle = await _cycle(careerId);
    final comp =
        await (_db.select(_db.competitions)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.cycle.equals(cycle) &
                    t.confederation.equalsValue(confederation) &
                    t.kind.equalsValue(CompetitionKind.worldCupQualifying),
              )
              ..limit(1))
            .getSingleOrNull();
    if (comp == null) return [];
    final query = _db.select(_db.fixtures)
      ..where((t) => t.competitionId.equals(comp.id))
      ..orderBy([
        (t) => OrderingTerm(expression: t.matchday),
        (t) => OrderingTerm(expression: t.date),
      ]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<Map<int, String>> groupNames(int careerId) async {
    final comps = await (_db.select(
      _db.competitions,
    )..where((t) => t.careerId.equals(careerId))).get();
    if (comps.isEmpty) return const {};
    final ids = [for (final c in comps) c.id];
    final groups = await (_db.select(
      _db.qualifyingGroups,
    )..where((t) => t.competitionId.isIn(ids))).get();
    return {for (final g in groups) g.id: g.name};
  }

  @override
  Future<List<GroupTable>> allGroupTables(int careerId) async {
    final comp =
        await (_db.select(_db.competitions)
              ..where((t) => t.careerId.equals(careerId))
              ..limit(1))
            .getSingleOrNull();
    if (comp == null) return [];

    final groups =
        await (_db.select(_db.qualifyingGroups)
              ..where((t) => t.competitionId.equals(comp.id))
              ..orderBy([(t) => OrderingTerm(expression: t.name)]))
            .get();

    final tables = <GroupTable>[];
    for (final group in groups) {
      final members = await (_db.select(
        _db.groupMembers,
      )..where((t) => t.groupId.equals(group.id))).get();
      final fixtures = await (_db.select(
        _db.fixtures,
      )..where((t) => t.groupId.equals(group.id))).get();
      tables.add((
        groupId: group.id,
        name: group.name,
        competition: comp.name,
        kind: comp.kind,
        groupCount: groups.length,
        standings: GroupStanding.table(
          members.map((m) => m.nationId).toList(),
          fixtures.map((r) => r.toDomain()).toList(),
        ),
      ));
    }
    return tables;
  }

  @override
  Future<void> saveFriendlies({
    required int careerId,
    required int nationId,
    required int cycle,
    required List<({DateTime date, int opponentId, bool home})> friendlies,
  }) async {
    if (friendlies.isEmpty) return;
    final compId = await _db
        .into(_db.competitions)
        .insert(
          CompetitionsCompanion.insert(
            careerId: careerId,
            confederation: Confederation.northAmerica, // unused for friendlies
            name: 'Friendlies',
            kind: const Value(CompetitionKind.friendly),
            cycle: Value(cycle),
          ),
        );
    await _db.batch((b) {
      var matchday = 1;
      for (final f in friendlies) {
        b.insert(
          _db.fixtures,
          FixturesCompanion.insert(
            careerId: careerId,
            competitionId: compId,
            matchday: matchday++,
            date: f.date,
            homeNationId: f.home ? nationId : f.opponentId,
            awayNationId: f.home ? f.opponentId : nationId,
            round: const Value('FRIENDLY'),
          ),
        );
      }
    });
  }

  // --- World Cup finals -----------------------------------------------------

  Future<CompetitionRow?> _finals(int careerId) =>
      _tournamentComp(careerId, CompetitionKind.worldCupFinals);

  @override
  Future<bool> hasLiveContinentalFinals(
    int careerId, {
    Confederation? confederation,
  }) async {
    final comp = await _tournamentComp(
      careerId,
      CompetitionKind.continentalFinals,
      confederation: confederation,
    );
    if (comp == null) return false;
    final unplayed =
        await (_db.select(_db.fixtures)
              ..where(
                (t) => t.competitionId.equals(comp.id) & t.played.equals(false),
              )
              ..limit(1))
            .getSingleOrNull();
    return unplayed != null;
  }

  @override
  Future<bool> hasLiveNationsCupFinals(int careerId) async {
    final comp = await _tournamentComp(careerId, CompetitionKind.nationsLeague);
    if (comp == null) return false;
    final unplayed =
        await (_db.select(_db.fixtures)
              ..where(
                (t) =>
                    t.competitionId.equals(comp.id) &
                    t.played.equals(false) &
                    t.round.isIn(const ['NSF', 'NFINAL']),
              )
              ..limit(1))
            .getSingleOrNull();
    return unplayed != null;
  }

  /// The current cycle's competition of [kind] — scoped to [confederation]
  /// when given, which matters now that every confederation's continental
  /// finals exist as real competitions in the same cycle.
  Future<CompetitionRow?> _tournamentComp(
    int careerId,
    CompetitionKind kind, {
    Confederation? confederation,
  }) async {
    final cycle = await _cycle(careerId);
    return (_db.select(_db.competitions)
          ..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.cycle.equals(cycle) &
                t.kind.equalsValue(kind) &
                (confederation == null
                    ? const Constant(true)
                    : t.confederation.equalsValue(confederation)),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<bool> hasTournament(
    int careerId,
    CompetitionKind kind, {
    Confederation? confederation,
  }) async =>
      (await _tournamentComp(careerId, kind, confederation: confederation)) !=
      null;

  @override
  Future<void> createKnockout({
    required int careerId,
    required int cycle,
    required Confederation confederation,
    required CompetitionKind kind,
    required String name,
    required List<(int home, int away)> pairings,
    required DateTime date,
    String firstRound = 'R16',
  }) async {
    final compId = await _db
        .into(_db.competitions)
        .insert(
          CompetitionsCompanion.insert(
            careerId: careerId,
            confederation: confederation,
            name: name,
            kind: Value(kind),
            cycle: Value(cycle),
          ),
        );
    await _db.batch((b) {
      b.insertAll(_db.fixtures, [
        for (final (home, away) in pairings)
          FixturesCompanion.insert(
            careerId: careerId,
            competitionId: compId,
            matchday: 99,
            date: date,
            homeNationId: home,
            awayNationId: away,
            round: Value(firstRound),
          ),
      ]);
    });
  }

  @override
  Future<bool> allQualifyingPlayed(int careerId) =>
      allPlayedForKind(careerId, CompetitionKind.worldCupQualifying);

  @override
  Future<bool> allPlayedForKind(
    int careerId,
    CompetitionKind kind, {
    Confederation? confederation,
  }) async {
    final cycle = await _cycle(careerId);
    final comps =
        await (_db.select(_db.competitions)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.cycle.equals(cycle) &
                  t.kind.equalsValue(kind) &
                  (confederation == null
                      ? const Constant(true)
                      : t.confederation.equalsValue(confederation)),
            ))
            .get();
    if (comps.isEmpty) return false;
    final ids = comps.map((c) => c.id).toList();
    final unplayed =
        await (_db.select(_db.fixtures)
              ..where(
                (t) => t.competitionId.isIn(ids) & t.played.equals(false),
              )
              ..limit(1))
            .getSingleOrNull();
    return unplayed == null;
  }

  @override
  Future<bool> hasFinals(int careerId) async =>
      (await _finals(careerId)) != null;

  @override
  Future<DateTime?> earliestUnplayedDate(
    int careerId,
    DateTime onOrAfter,
  ) async {
    final row =
        await (_db.select(_db.fixtures)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.played.equals(false) &
                    t.date.isBiggerOrEqualValue(onOrAfter),
              )
              ..orderBy([(t) => OrderingTerm(expression: t.date)])
              ..limit(1))
            .getSingleOrNull();
    return row?.date;
  }

  @override
  Future<DateTime?> earliestUnplayedFinalsDate(
    int careerId, {
    Confederation? playerConfederation,
  }) async {
    // Every confederation's continental finals now exist as fixtures, but the
    // player only steps THEIR region's cup (and the World Cup) day by day —
    // the rest resolve in the background as their dates pass.
    final comps =
        await (_db.select(_db.competitions)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  (t.kind.equalsValue(CompetitionKind.worldCupFinals) |
                      (t.kind.equalsValue(CompetitionKind.continentalFinals) &
                          (playerConfederation == null
                              ? const Constant(true)
                              : t.confederation.equalsValue(
                                  playerConfederation,
                                )))),
            ))
            .get();
    if (comps.isEmpty) return null;
    final ids = comps.map((c) => c.id).toList();
    final row =
        await (_db.select(_db.fixtures)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.played.equals(false) &
                    t.competitionId.isIn(ids),
              )
              ..orderBy([(t) => OrderingTerm(expression: t.date)])
              ..limit(1))
            .getSingleOrNull();
    return row?.date;
  }

  @override
  Future<DateTime?> earliestUnplayedNationsCupFinalsDate(int careerId) async {
    final comp = await _tournamentComp(careerId, CompetitionKind.nationsLeague);
    if (comp == null) return null;
    final row =
        await (_db.select(_db.fixtures)
              ..where(
                (t) =>
                    t.competitionId.equals(comp.id) &
                    t.played.equals(false) &
                    t.round.isIn(const ['NSF', 'NFINAL']),
              )
              ..orderBy([(t) => OrderingTerm(expression: t.date)])
              ..limit(1))
            .getSingleOrNull();
    return row?.date;
  }

  @override
  Future<DateTime?> earliestUnplayedDateOfKind(
    int careerId,
    CompetitionKind kind, {
    Confederation? confederation,
  }) async {
    final comps =
        await (_db.select(_db.competitions)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.kind.equalsValue(kind) &
                  (confederation == null
                      ? const Constant(true)
                      : t.confederation.equalsValue(confederation)),
            ))
            .get();
    if (comps.isEmpty) return null;
    final ids = comps.map((c) => c.id).toList();
    final row =
        await (_db.select(_db.fixtures)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.played.equals(false) &
                    t.competitionId.isIn(ids),
              )
              ..orderBy([(t) => OrderingTerm(expression: t.date)])
              ..limit(1))
            .getSingleOrNull();
    return row?.date;
  }

  @override
  Future<void> saveFinals({
    required int careerId,
    required FinalsDraw draw,
    required DateTime groupStart,
    int cycle = 0,
  }) async {
    await _db.transaction(() async {
      final compId = await _db
          .into(_db.competitions)
          .insert(
            CompetitionsCompanion.insert(
              careerId: careerId,
              // Finals are global; a value is required but never read (queries
              // filter by kind), so a placeholder confederation is stored.
              confederation: Confederation.northAmerica,
              name: 'World Championship Finals',
              kind: const Value(CompetitionKind.worldCupFinals),
              cycle: Value(cycle),
            ),
          );

      for (final group in draw.groups) {
        final groupId = await _db
            .into(_db.qualifyingGroups)
            .insert(
              QualifyingGroupsCompanion.insert(
                competitionId: compId,
                name: group.name,
              ),
            );
        await _db.batch((b) {
          b
            ..insertAll(_db.groupMembers, [
              for (final nationId in group.nationIds)
                GroupMembersCompanion.insert(
                  groupId: groupId,
                  nationId: nationId,
                ),
            ])
            ..insertAll(_db.fixtures, [
              for (final (matchday, home, away) in group.fixtures)
                FixturesCompanion.insert(
                  careerId: careerId,
                  competitionId: compId,
                  groupId: Value(groupId),
                  matchday: matchday,
                  date: groupStart.add(Duration(days: (matchday - 1) * 3)),
                  homeNationId: home,
                  awayNationId: away,
                  round: const Value('GROUP'),
                ),
            ]);
        });
      }
    });
  }

  @override
  Future<List<FinalsGroupTable>> finalsGroupTables(int careerId) async =>
      _groupTables(await _finals(careerId));

  @override
  Future<List<FinalsGroupTable>> tournamentGroupTables(
    int careerId,
    CompetitionKind kind, {
    Confederation? confederation,
  }) async => _groupTables(
    await _tournamentComp(careerId, kind, confederation: confederation),
  );

  /// Builds the group tables for [comp] (empty if it has no group stage).
  Future<List<FinalsGroupTable>> _groupTables(CompetitionRow? comp) async {
    if (comp == null) return [];
    final groups =
        await (_db.select(_db.qualifyingGroups)
              ..where((t) => t.competitionId.equals(comp.id))
              ..orderBy([(t) => OrderingTerm(expression: t.name)]))
            .get();
    final tables = <FinalsGroupTable>[];
    for (final group in groups) {
      final members = await (_db.select(
        _db.groupMembers,
      )..where((t) => t.groupId.equals(group.id))).get();
      final fixtures = await (_db.select(
        _db.fixtures,
      )..where((t) => t.groupId.equals(group.id))).get();
      tables.add((
        name: group.name,
        standings: GroupStanding.table(
          members.map((m) => m.nationId).toList(),
          fixtures.map((r) => r.toDomain()).toList(),
        ),
      ));
    }
    return tables;
  }

  @override
  Future<void> saveTournamentGroups({
    required int careerId,
    required int cycle,
    required Confederation confederation,
    required CompetitionKind kind,
    required String name,
    required FinalsDraw draw,
    required DateTime groupStart,
    String round = 'GROUP',
  }) async {
    await _db.transaction(() async {
      final compId = await _db
          .into(_db.competitions)
          .insert(
            CompetitionsCompanion.insert(
              careerId: careerId,
              confederation: confederation,
              name: name,
              kind: Value(kind),
              cycle: Value(cycle),
            ),
          );
      for (final group in draw.groups) {
        final groupId = await _db
            .into(_db.qualifyingGroups)
            .insert(
              QualifyingGroupsCompanion.insert(
                competitionId: compId,
                name: group.name,
              ),
            );
        await _db.batch((b) {
          b
            ..insertAll(_db.groupMembers, [
              for (final nationId in group.nationIds)
                GroupMembersCompanion.insert(
                  groupId: groupId,
                  nationId: nationId,
                ),
            ])
            ..insertAll(_db.fixtures, [
              for (final (matchday, home, away) in group.fixtures)
                FixturesCompanion.insert(
                  careerId: careerId,
                  competitionId: compId,
                  groupId: Value(groupId),
                  matchday: matchday,
                  date: groupStart.add(Duration(days: (matchday - 1) * 3)),
                  homeNationId: home,
                  awayNationId: away,
                  round: Value(round),
                ),
            ]);
        });
      }
    });
  }

  @override
  Future<List<Fixture>> fixturesByRound(
    int careerId,
    String round, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
    Confederation? confederation,
  }) async {
    final comp = await _tournamentComp(
      careerId,
      kind,
      confederation: confederation,
    );
    if (comp == null) return [];
    final query = _db.select(_db.fixtures)
      ..where(
        (t) => t.competitionId.equals(comp.id) & t.round.equals(round),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.id)]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  /// The finals knockout round labels, in bracket order. Anything outside this
  /// set (group games, or stray/duplicate rows) is never shown as a tie.
  static const _knockoutRounds = ['R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'];

  @override
  Future<List<Fixture>> finalsKnockoutFixtures(int careerId) async {
    final comp = await _finals(careerId);
    if (comp == null) return [];
    final query = _db.select(_db.fixtures)
      ..where(
        (t) => t.competitionId.equals(comp.id) & t.round.isIn(_knockoutRounds),
      )
      ..orderBy([
        (t) => OrderingTerm(expression: t.date),
        (t) => OrderingTerm(expression: t.id),
      ]);
    final rows = (await query.get()).map((r) => r.toDomain()).toList();
    // Guard against duplicate inserts leaking into the bracket: keep one tie
    // per (round, home, away). A single knockout has at most 32 ties.
    final seen = <String>{};
    return [
      for (final f in rows)
        if (seen.add('${f.round}:${f.homeNationId}:${f.awayNationId}')) f,
    ];
  }

  @override
  Future<void> addKnockoutFixtures({
    required int careerId,
    required String round,
    required List<(int home, int away)> pairings,
    required DateTime date,
    CompetitionKind kind = CompetitionKind.worldCupFinals,
    Confederation? confederation,
  }) async {
    final comp = await _tournamentComp(
      careerId,
      kind,
      confederation: confederation,
    );
    if (comp == null) return;
    await _db.batch((b) {
      b.insertAll(_db.fixtures, [
        for (final (home, away) in pairings)
          FixturesCompanion.insert(
            careerId: careerId,
            competitionId: comp.id,
            matchday: 99,
            date: date,
            homeNationId: home,
            awayNationId: away,
            round: Value(round),
          ),
      ]);
    });
  }

  @override
  Future<int?> worldChampion(int careerId) async {
    final comp = await _finals(careerId);
    if (comp == null) return null;
    final f =
        await (_db.select(_db.fixtures)
              ..where(
                (t) =>
                    t.competitionId.equals(comp.id) &
                    t.round.equals(WorldCupFinals.finalRound) &
                    t.played.equals(true),
              )
              ..limit(1))
            .getSingleOrNull();
    if (f == null || f.homeScore == null || f.awayScore == null) return null;
    return f.homeScore! >= f.awayScore! ? f.homeNationId : f.awayNationId;
  }

  @override
  Future<int?> continentalChampion(
    int careerId, {
    Confederation? confederation,
  }) async {
    final comp = await _tournamentComp(
      careerId,
      CompetitionKind.continentalFinals,
      confederation: confederation,
    );
    if (comp == null) return null;
    final f =
        await (_db.select(_db.fixtures)
              ..where(
                (t) =>
                    t.competitionId.equals(comp.id) &
                    t.round.equals('CFINAL') &
                    t.played.equals(true),
              )
              ..limit(1))
            .getSingleOrNull();
    if (f == null || f.homeScore == null || f.awayScore == null) return null;
    // A level score means penalties settled it; the stored score already has
    // the shootout winner one clear (see WorldCupFinals.resolveTie).
    return f.homeScore! >= f.awayScore! ? f.homeNationId : f.awayNationId;
  }

  // --- Goals & honours ------------------------------------------------------

  @override
  Future<void> recordGoals(List<GoalRecord> goals) async {
    if (goals.isEmpty) return;
    await _db.batch((b) {
      b.insertAll(_db.goalEvents, [
        for (final g in goals)
          GoalEventsCompanion.insert(
            careerId: g.careerId,
            competitionId: g.competitionId,
            fixtureId: g.fixtureId,
            nationId: g.nationId,
            playerId: g.playerId,
            minute: g.minute,
          ),
      ]);
    });
  }

  @override
  Future<List<({int playerId, int apps, double meanRating, int motms})>>
  nationTopRatings(
    int careerId,
    int nationId, {
    int minApps = 5,
    int limit = 25,
  }) async {
    final rows =
        await (_db.select(_db.playerRatings)..where(
              (t) => t.careerId.equals(careerId) & t.nationId.equals(nationId),
            ))
            .get();
    final acc = <int, ({int apps, double sum, int motms})>{};
    for (final r in rows) {
      final was = acc[r.playerId];
      acc[r.playerId] = (
        apps: (was?.apps ?? 0) + 1,
        sum: (was?.sum ?? 0) + r.rating,
        motms: (was?.motms ?? 0) + (r.motm ? 1 : 0),
      );
    }
    final out = [
      for (final e in acc.entries)
        if (e.value.apps >= minApps)
          (
            playerId: e.key,
            apps: e.value.apps,
            meanRating: e.value.sum / e.value.apps,
            motms: e.value.motms,
          ),
    ]..sort((a, b) => b.meanRating.compareTo(a.meanRating));
    return out.take(limit).toList();
  }

  @override
  Future<List<TournamentLine>> competitionPlayerLines(
    int careerId,
    int competitionId,
  ) async {
    // Every rating row belonging to a fixture of this competition. The join is
    // on the fixture rather than a competition column on PlayerRatings, which
    // keeps the rating rows competition-agnostic.
    final query =
        _db.select(_db.playerRatings).join([
          innerJoin(
            _db.fixtures,
            _db.fixtures.id.equalsExp(_db.playerRatings.fixtureId),
          ),
        ])..where(
          _db.playerRatings.careerId.equals(careerId) &
              _db.fixtures.competitionId.equals(competitionId),
        );
    final rows = await query.get();

    final acc =
        <
          int,
          ({
            int nationId,
            int apps,
            double sum,
            int goals,
            int assists,
            int motms,
            int cleanSheets,
          })
        >{};
    for (final r in rows) {
      final p = r.readTable(_db.playerRatings);
      final was = acc[p.playerId];
      acc[p.playerId] = (
        nationId: p.nationId,
        apps: (was?.apps ?? 0) + 1,
        sum: (was?.sum ?? 0) + p.rating,
        goals: (was?.goals ?? 0) + p.goals,
        assists: (was?.assists ?? 0) + p.assists,
        motms: (was?.motms ?? 0) + (p.motm ? 1 : 0),
        cleanSheets: (was?.cleanSheets ?? 0) + (p.cleanSheet ? 1 : 0),
      );
    }
    return [
      for (final e in acc.entries)
        (
          playerId: e.key,
          nationId: e.value.nationId,
          apps: e.value.apps,
          meanRating: e.value.apps == 0 ? 0.0 : e.value.sum / e.value.apps,
          goals: e.value.goals,
          assists: e.value.assists,
          motms: e.value.motms,
          cleanSheets: e.value.cleanSheets,
        ),
    ];
  }

  @override
  Future<Map<int, List<({int nationId, int minute})>>> goalTimeline(
    int careerId,
  ) async {
    final rows =
        await (_db.select(_db.goalEvents)
              ..where((t) => t.careerId.equals(careerId))
              ..orderBy([(t) => OrderingTerm(expression: t.minute)]))
            .get();
    final out = <int, List<({int nationId, int minute})>>{};
    for (final r in rows) {
      (out[r.fixtureId] ??= []).add((nationId: r.nationId, minute: r.minute));
    }
    return out;
  }

  @override
  Future<Map<int, Map<int, int>>> scorersByFixture(
    int careerId,
    int nationId,
  ) async {
    final rows =
        await (_db.select(_db.goalEvents)..where(
              (t) => t.careerId.equals(careerId) & t.nationId.equals(nationId),
            ))
            .get();
    final out = <int, Map<int, int>>{};
    for (final r in rows) {
      (out[r.fixtureId] ??= <int, int>{}).update(
        r.playerId,
        (v) => v + 1,
        ifAbsent: () => 1,
      );
    }
    return out;
  }

  @override
  Future<List<ScorerTally>> topScorers(
    int careerId, {
    CompetitionKind? kind,
    Confederation? confederation,
    int limit = 20,
  }) async {
    // Scope to the current cycle's competitions (optionally of one kind, and
    // of one confederation — each region's cup now has its own scorer chart).
    final cycle = await _cycle(careerId);
    final comps =
        await (_db.select(_db.competitions)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.cycle.equals(cycle) &
                  (kind == null
                      ? const Constant(true)
                      : t.kind.equalsValue(kind)) &
                  (confederation == null
                      ? const Constant(true)
                      : t.confederation.equalsValue(confederation)),
            ))
            .get();
    final compIds = comps.map((c) => c.id).toSet();
    if (compIds.isEmpty) return [];

    final rows = await (_db.select(
      _db.goalEvents,
    )..where((t) => t.careerId.equals(careerId))).get();

    final tally = <int, ({int nationId, int goals})>{};
    for (final r in rows) {
      if (!compIds.contains(r.competitionId)) continue;
      final cur = tally[r.playerId];
      tally[r.playerId] = (
        nationId: r.nationId,
        goals: (cur?.goals ?? 0) + 1,
      );
    }

    final list =
        tally.entries
            .map(
              (e) => (
                playerId: e.key,
                nationId: e.value.nationId,
                goals: e.value.goals,
              ),
            )
            .toList()
          ..sort((a, b) => b.goals.compareTo(a.goals));
    return list.take(limit).toList();
  }

  @override
  Future<List<ScorerTally>> allTimeTopScorers(
    int careerId, {
    CompetitionKind? kind,
    Confederation? confederation,
    Set<CompetitionKind>? kinds,
    int limit = 50,
  }) async {
    // Every cycle's competitions of [kind] (optionally scoped to one region's
    // continental cup) — the all-time chart. Goal events exist only for
    // simulated matches, so the pre-seeded real-world history (honours-only)
    // never counts here.
    final comps =
        await (_db.select(_db.competitions)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  (kind == null
                      ? const Constant(true)
                      : t.kind.equalsValue(kind)) &
                  (confederation == null
                      ? const Constant(true)
                      : t.confederation.equalsValue(confederation)),
            ))
            .get();
    final compIds = comps
        .where((c) => kinds == null || kinds.contains(c.kind))
        .map((c) => c.id)
        .toSet();
    if (compIds.isEmpty) return [];

    final rows = await (_db.select(
      _db.goalEvents,
    )..where((t) => t.careerId.equals(careerId))).get();

    final tally = <int, ({int nationId, int goals})>{};
    for (final r in rows) {
      if (!compIds.contains(r.competitionId)) continue;
      final cur = tally[r.playerId];
      tally[r.playerId] = (
        nationId: r.nationId,
        goals: (cur?.goals ?? 0) + 1,
      );
    }

    final list =
        tally.entries
            .map(
              (e) => (
                playerId: e.key,
                nationId: e.value.nationId,
                goals: e.value.goals,
              ),
            )
            .toList()
          ..sort((a, b) => b.goals.compareTo(a.goals));
    return list.take(limit).toList();
  }

  @override
  Future<List<ScorerTally>> nationTopScorers(
    int careerId,
    int nationId, {
    CompetitionKind? kind,
    int limit = 20,
  }) async {
    // Optionally restrict to one competition kind (across every cycle).
    Set<int>? compIds;
    if (kind != null) {
      final comps =
          await (_db.select(_db.competitions)..where(
                (t) => t.careerId.equals(careerId) & t.kind.equalsValue(kind),
              ))
              .get();
      compIds = comps.map((c) => c.id).toSet();
      if (compIds.isEmpty) return [];
    }

    final rows =
        await (_db.select(_db.goalEvents)..where(
              (t) => t.careerId.equals(careerId) & t.nationId.equals(nationId),
            ))
            .get();

    final tally = <int, int>{};
    for (final r in rows) {
      if (compIds != null && !compIds.contains(r.competitionId)) continue;
      tally[r.playerId] = (tally[r.playerId] ?? 0) + 1;
    }

    final list =
        tally.entries
            .map((e) => (playerId: e.key, nationId: nationId, goals: e.value))
            .toList()
          ..sort((a, b) => b.goals.compareTo(a.goals));
    return list.take(limit).toList();
  }

  @override
  Future<void> recordHonour({
    required int careerId,
    required int year,
    required String competition,
    required int championId,
    required int runnerUpId,
    int? thirdId,
    int? thirdId2,
    int? hostId,
    List<int> hostIds = const [],
    int? finalHomeScore,
    int? finalAwayScore,
    String? topScorerName,
    int? topScorerGoals,
  }) async {
    // The primary host is the first of the list when the caller gave one, so a
    // co-hosted edition still answers "whose tournament was it" the way every
    // existing reader of [hostId] expects.
    final primaryId = hostId ?? (hostIds.isEmpty ? null : hostIds.first);
    await _db
        .into(_db.honours)
        .insert(
          HonoursCompanion.insert(
            careerId: careerId,
            year: year,
            competition: competition,
            championId: championId,
            runnerUpId: runnerUpId,
            thirdId: Value(thirdId),
            thirdId2: Value(thirdId2),
            hostId: Value(primaryId),
            hostIds: Value(hostIds.isEmpty ? null : hostIds.join(',')),
            finalHomeScore: Value(finalHomeScore),
            finalAwayScore: Value(finalAwayScore),
            topScorerName: Value(topScorerName),
            topScorerGoals: Value(topScorerGoals),
          ),
        );
  }

  @override
  Future<bool> hasWatchedDraw(int careerId, int cycle, String kind) async {
    final row =
        await (_db.select(_db.drawsWatched)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.cycle.equals(cycle) &
                    t.kind.equals(kind),
              )
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  @override
  Future<void> markDrawWatched(int careerId, int cycle, String kind) async {
    await _db
        .into(_db.drawsWatched)
        .insert(
          DrawWatchedRow(careerId: careerId, cycle: cycle, kind: kind),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<bool> hasHonour(int careerId, String competition, int year) async {
    final row =
        await (_db.select(_db.honours)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.competition.equals(competition) &
                    t.year.equals(year),
              )
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  @override
  Future<List<Honour>> honours(int careerId) async {
    final rows =
        await (_db.select(_db.honours)
              ..where((t) => t.careerId.equals(careerId))
              ..orderBy([
                (t) =>
                    OrderingTerm(expression: t.year, mode: OrderingMode.desc),
              ]))
            .get();
    return [
      for (final r in rows)
        (
          year: r.year,
          competition: r.competition,
          championId: r.championId,
          runnerUpId: r.runnerUpId,
          thirdId: r.thirdId,
          thirdId2: r.thirdId2,
          hostId: r.hostId,
          hostIds: _hostIds(r),
          finalHomeScore: r.finalHomeScore,
          finalAwayScore: r.finalAwayScore,
          topScorerName: r.topScorerName,
          topScorerGoals: r.topScorerGoals,
        ),
    ];
  }

  @override
  Future<void> recordAppearances(
    int careerId,
    int nationId,
    Iterable<int> playerIds,
  ) async {
    for (final id in playerIds) {
      await _db.customStatement(
        'INSERT INTO appearances (career_id, nation_id, player_id, count) '
        'VALUES (?, ?, ?, 1) '
        'ON CONFLICT(career_id, player_id) DO UPDATE SET count = count + 1',
        [careerId, nationId, id],
      );
    }
  }

  @override
  Future<List<({int playerId, int games})>> nationTopAppearances(
    int careerId,
    int nationId, {
    int limit = 25,
  }) async {
    final rows =
        await (_db.select(_db.appearances)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) & t.nationId.equals(nationId),
              )
              ..orderBy([
                (t) =>
                    OrderingTerm(expression: t.count, mode: OrderingMode.desc),
              ])
              ..limit(limit))
            .get();
    return [for (final r in rows) (playerId: r.playerId, games: r.count)];
  }

  @override
  Future<List<({int playerId, int nationId, int games})>> allTimeTopAppearances(
    int careerId, {
    int limit = 50,
  }) async {
    // Appearances are keyed per (career, player) with the player's nation, and
    // logged for background matches too — so this is a true all-time global
    // record across every nation in the save.
    final rows =
        await (_db.select(_db.appearances)
              ..where((t) => t.careerId.equals(careerId))
              ..orderBy([
                (t) =>
                    OrderingTerm(expression: t.count, mode: OrderingMode.desc),
              ])
              ..limit(limit))
            .get();
    return [
      for (final r in rows)
        (playerId: r.playerId, nationId: r.nationId, games: r.count),
    ];
  }

  @override
  Future<void> recordTournamentAppearances(
    int careerId,
    int competitionId,
    Iterable<({int playerId, int nationId, bool started})> players,
  ) async {
    for (final p in players) {
      final s = p.started ? 1 : 0;
      await _db.customStatement(
        'INSERT INTO tournament_appearances '
        '(career_id, competition_id, nation_id, player_id, starts, apps) '
        'VALUES (?, ?, ?, ?, ?, 1) '
        'ON CONFLICT(career_id, competition_id, player_id) DO UPDATE SET '
        'starts = starts + ?, apps = apps + 1',
        [careerId, competitionId, p.nationId, p.playerId, s, s],
      );
    }
  }

  @override
  Future<Map<int, int>> careerStartsByPlayer(int careerId) async {
    // Only FINISHED competitions count. Tournament starts drive the
    // career-development bump, so counting them live meant a player's overall
    // ticked up in the middle of a tournament: the number on his shirt changed
    // between the quarter-final and the semi-final, the squad list disagreed
    // with the team sheet the manager had just picked, and a run to the final
    // silently reshaped the XI underneath them. A tournament's game time is
    // banked when the tournament is over, so a cup is played out by the squad
    // that started it.
    //
    // Excluding the running tournament is not enough on its own, because a
    // DIFFERENT competition can settle in the middle of it. The Nations Cup
    // Finals Four is played on 18 June, inside a continental championship that
    // began on the 8th — so the moment it finished, a whole tournament's game
    // time banked and the squad re-rated between two matches of the cup it was
    // actually playing. While a finals is in progress, nothing banks: any
    // competition whose last fixture falls after that tournament kicked off
    // waits until the tournament is over.
    final unfinished = await _unfinishedCompetitionIds(careerId);
    final freezeFrom = await _finalsInProgressSince(careerId);
    final lastFixtureByComp = await _lastFixtureDateByCompetition(careerId);
    final rows = await (_db.select(
      _db.tournamentAppearances,
    )..where((t) => t.careerId.equals(careerId))).get();
    final byPlayer = <int, int>{};
    for (final r in rows) {
      if (r.starts <= 0) continue;
      if (unfinished.contains(r.competitionId)) continue;
      if (freezeFrom != null) {
        final last = lastFixtureByComp[r.competitionId];
        if (last != null && last.isAfter(freezeFrom)) continue;
      }
      byPlayer.update(
        r.playerId,
        (v) => v + r.starts,
        ifAbsent: () => r.starts,
      );
    }
    return byPlayer;
  }

  /// When the earliest finals tournament that is currently IN PROGRESS kicked
  /// off, or null if no finals is running.
  ///
  /// Only a finals counts. Qualifying campaigns run for the best part of a
  /// season and always have unplayed fixtures somewhere, so treating them as
  /// "in progress" would freeze development permanently.
  Future<DateTime?> _finalsInProgressSince(int careerId) async {
    const finalsKinds = {
      CompetitionKind.worldCupFinals,
      CompetitionKind.continentalFinals,
    };
    final comps = await (_db.select(
      _db.competitions,
    )..where((t) => t.careerId.equals(careerId))).get();
    final finalsIds = {
      for (final c in comps)
        if (finalsKinds.contains(c.kind)) c.id,
    };
    if (finalsIds.isEmpty) return null;
    final fixtures = await (_db.select(
      _db.fixtures,
    )..where((t) => t.careerId.equals(careerId))).get();
    DateTime? earliest;
    final played = <int, DateTime>{};
    final hasUnplayed = <int>{};
    for (final f in fixtures) {
      if (!finalsIds.contains(f.competitionId)) continue;
      if (f.played) {
        final at = played[f.competitionId];
        if (at == null || f.date.isBefore(at)) played[f.competitionId] = f.date;
      } else {
        hasUnplayed.add(f.competitionId);
      }
    }
    for (final entry in played.entries) {
      if (!hasUnplayed.contains(entry.key)) continue; // already settled
      if (earliest == null || entry.value.isBefore(earliest)) {
        earliest = entry.value;
      }
    }
    return earliest;
  }

  /// The date of each competition's last fixture — when its game time banks.
  Future<Map<int, DateTime>> _lastFixtureDateByCompetition(int careerId) async {
    final rows = await (_db.select(
      _db.fixtures,
    )..where((t) => t.careerId.equals(careerId))).get();
    final out = <int, DateTime>{};
    for (final f in rows) {
      final at = out[f.competitionId];
      if (at == null || f.date.isAfter(at)) out[f.competitionId] = f.date;
    }
    return out;
  }

  /// Competitions in this save that still have an unplayed fixture — i.e. are
  /// in progress rather than settled.
  Future<Set<int>> _unfinishedCompetitionIds(int careerId) async {
    final rows =
        await (_db.select(_db.fixtures)..where(
              (t) => t.careerId.equals(careerId) & t.played.equals(false),
            ))
            .get();
    return {for (final f in rows) f.competitionId};
  }

  @override
  Future<List<({int playerId, int nationId, int starts})>> mostTournamentStarts(
    int careerId, {
    required CompetitionKind kind,
    int limit = 10,
  }) async {
    final compIds = await _competitionIdsOfKinds(careerId, {kind});
    if (compIds.isEmpty) return [];
    final rows = await (_db.select(
      _db.tournamentAppearances,
    )..where((t) => t.careerId.equals(careerId))).get();
    final tally = <int, ({int nationId, int starts})>{};
    for (final r in rows) {
      if (!compIds.contains(r.competitionId) || r.starts == 0) continue;
      final cur = tally[r.playerId];
      tally[r.playerId] = (
        nationId: r.nationId,
        starts: (cur?.starts ?? 0) + r.starts,
      );
    }
    final list =
        tally.entries
            .map(
              (e) => (
                playerId: e.key,
                nationId: e.value.nationId,
                starts: e.value.starts,
              ),
            )
            .toList()
          ..sort((a, b) => b.starts.compareTo(a.starts));
    return list.take(limit).toList();
  }

  @override
  Future<List<({int playerId, int nationId, int tournaments})>>
  mostTournamentsAttended(
    int careerId, {
    required Set<CompetitionKind> kinds,
    int limit = 10,
  }) async {
    final compIds = await _competitionIdsOfKinds(careerId, kinds);
    if (compIds.isEmpty) return [];
    final rows = await (_db.select(
      _db.tournamentAppearances,
    )..where((t) => t.careerId.equals(careerId))).get();
    // One row per (competition, player) — so counting the matching rows per
    // player is the number of distinct tournament editions they attended.
    final count = <int, int>{};
    final nation = <int, int>{};
    for (final r in rows) {
      if (!compIds.contains(r.competitionId)) continue;
      count.update(r.playerId, (v) => v + 1, ifAbsent: () => 1);
      nation[r.playerId] = r.nationId;
    }
    final list =
        count.entries
            .map(
              (e) => (
                playerId: e.key,
                nationId: nation[e.key]!,
                tournaments: e.value,
              ),
            )
            .toList()
          ..sort((a, b) => b.tournaments.compareTo(a.tournaments));
    return list.take(limit).toList();
  }

  /// The competition ids in the save whose kind is one of [kinds].
  Future<Set<int>> _competitionIdsOfKinds(
    int careerId,
    Set<CompetitionKind> kinds,
  ) async {
    final comps = await (_db.select(
      _db.competitions,
    )..where((t) => t.careerId.equals(careerId))).get();
    return {
      for (final c in comps)
        if (kinds.contains(c.kind)) c.id,
    };
  }

  @override
  Future<List<({int playerId, int nationId, int games, int finals})>>
  playerCupRecords(
    int careerId, {
    required CompetitionKind kind,
    Confederation? confederation,
  }) async {
    final comps = await (_db.select(
      _db.competitions,
    )..where((t) => t.careerId.equals(careerId))).get();
    final compIds = {
      for (final c in comps)
        if (c.kind == kind &&
            (confederation == null || c.confederation == confederation))
          c.id,
    };
    if (compIds.isEmpty) return [];
    // One row per (edition, player): apps = matches played that edition, so a
    // row means the player was in that edition's squad (attended it).
    final rows = await (_db.select(
      _db.tournamentAppearances,
    )..where((t) => t.careerId.equals(careerId))).get();
    final games = <int, int>{};
    final finals = <int, int>{};
    final nation = <int, int>{};
    for (final r in rows) {
      if (!compIds.contains(r.competitionId)) continue;
      nation[r.playerId] = r.nationId;
      finals.update(r.playerId, (v) => v + 1, ifAbsent: () => 1);
      if (r.apps > 0) {
        games.update(r.playerId, (v) => v + r.apps, ifAbsent: () => r.apps);
      }
    }
    final list = [
      for (final id in nation.keys)
        (
          playerId: id,
          nationId: nation[id]!,
          games: games[id] ?? 0,
          finals: finals[id] ?? 0,
        ),
    ]..sort((a, b) => b.games.compareTo(a.games));
    return list;
  }

  @override
  Future<
    List<
      ({
        int cycle,
        String league,
        int position,
        int groupSize,
        String? finals,
      })
    >
  >
  nationsCupFinishes(int careerId, int nationId) async {
    final comps =
        await (_db.select(_db.competitions)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.kind.equalsValue(CompetitionKind.nationsLeague),
            ))
            .get();
    final out =
        <
          ({
            int cycle,
            String league,
            int position,
            int groupSize,
            String? finals,
          })
        >[];
    for (final comp in comps) {
      // Find the nation's league group in this edition.
      final groups = await (_db.select(
        _db.qualifyingGroups,
      )..where((t) => t.competitionId.equals(comp.id))).get();
      QualifyingGroupRow? myGroup;
      var members = <int>[];
      for (final g in groups) {
        final ms = await (_db.select(
          _db.groupMembers,
        )..where((t) => t.groupId.equals(g.id))).get();
        final ids = ms.map((m) => m.nationId).toList();
        if (ids.contains(nationId)) {
          myGroup = g;
          members = ids;
          break;
        }
      }
      if (myGroup == null) continue;

      final gfx = await (_db.select(
        _db.fixtures,
      )..where((t) => t.groupId.equals(myGroup!.id))).get();
      final standings = GroupStanding.table(
        members,
        gfx.map((r) => r.toDomain()).toList(),
      );
      final position = standings.indexWhere((s) => s.nationId == nationId) + 1;
      final league = myGroup.name.isEmpty ? 'A' : myGroup.name[0];

      // Finals Four result (League A group winners only) from NSF/NFINAL.
      final ko =
          await (_db.select(_db.fixtures)..where(
                (t) =>
                    t.competitionId.equals(comp.id) &
                    (t.round.equals('NSF') | t.round.equals('NFINAL')) &
                    (t.homeNationId.equals(nationId) |
                        t.awayNationId.equals(nationId)),
              ))
              .get();
      String? finals;
      if (ko.isNotEmpty) {
        final theFinal = ko
            .where((f) => f.round == 'NFINAL' && f.played)
            .firstOrNull;
        if (theFinal != null) {
          final home = theFinal.homeNationId == nationId;
          final my = home ? theFinal.homeScore! : theFinal.awayScore!;
          final other = home ? theFinal.awayScore! : theFinal.homeScore!;
          finals = my >= other ? 'Champions' : 'Runners-up';
        } else {
          finals = 'Semi-finalist';
        }
      }

      out.add((
        cycle: comp.cycle,
        league: league,
        position: position < 1 ? members.length : position,
        groupSize: members.length,
        finals: finals,
      ));
    }
    return out;
  }

  @override
  Future<HeadToHead> headToHead(
    int careerId,
    int nationA,
    int nationB,
  ) async {
    final rows =
        await (_db.select(_db.fixtures)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.played.equals(true) &
                  ((t.homeNationId.equals(nationA) &
                          t.awayNationId.equals(nationB)) |
                      (t.homeNationId.equals(nationB) &
                          t.awayNationId.equals(nationA))),
            ))
            .get();
    var played = 0;
    var winsA = 0;
    var draws = 0;
    var winsB = 0;
    var goalsA = 0;
    var goalsB = 0;
    var bestA = 0;
    var bestB = 0;
    for (final f in rows) {
      final hs = f.homeScore;
      final as = f.awayScore;
      if (hs == null || as == null) continue;
      final aIsHome = f.homeNationId == nationA;
      final sa = aIsHome ? hs : as;
      final sb = aIsHome ? as : hs;
      played++;
      goalsA += sa;
      goalsB += sb;
      if (sa > sb) {
        winsA++;
        if (sa - sb > bestA) bestA = sa - sb;
      } else if (sa < sb) {
        winsB++;
        if (sb - sa > bestB) bestB = sb - sa;
      } else {
        draws++;
      }
    }
    return (
      played: played,
      winsA: winsA,
      draws: draws,
      winsB: winsB,
      goalsA: goalsA,
      goalsB: goalsB,
      biggestWinMarginA: bestA,
      biggestWinMarginB: bestB,
    );
  }

  @override
  Future<void> recordPlayerMatchStats(
    int careerId,
    int fixtureId,
    Iterable<PlayerMatchLine> lines,
  ) async {
    final list = lines.toList();
    if (list.isEmpty) return;
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(_db.playerRatings, [
        for (final r in list)
          PlayerRatingsCompanion.insert(
            careerId: careerId,
            fixtureId: fixtureId,
            playerId: r.playerId,
            nationId: Value(r.nationId),
            rating: r.rating,
            goals: Value(r.goals),
            assists: Value(r.assists),
            cleanSheet: Value(r.cleanSheet),
            motm: Value(r.motm),
            yellows: Value(r.yellows),
            reds: Value(r.reds),
          ),
      ]);
    });
  }

  @override
  Future<void> recordTeamStats(
    int careerId,
    int fixtureId, {
    required int homeShots,
    required int awayShots,
    required int homePossession,
    double homeXg = 0,
    double awayXg = 0,
  }) async {
    await _db
        .into(_db.matchTeamStats)
        .insertOnConflictUpdate(
          MatchTeamStatRow(
            careerId: careerId,
            fixtureId: fixtureId,
            homeShots: homeShots,
            awayShots: awayShots,
            homePossession: homePossession,
            homeXg: homeXg,
            awayXg: awayXg,
          ),
        );
  }

  @override
  Future<List<PlayerMatchStat>> playerMatchHistory(
    int careerId,
    int playerId, {
    int limit = 50,
  }) async {
    final rows =
        await (_db.select(_db.playerRatings)..where(
              (t) => t.careerId.equals(careerId) & t.playerId.equals(playerId),
            ))
            .get();
    if (rows.isEmpty) return const [];
    final byFixture = {for (final r in rows) r.fixtureId: r};

    final fixtures = await (_db.select(
      _db.fixtures,
    )..where((t) => t.id.isIn(byFixture.keys.toList()))).get();

    final stats = <PlayerMatchStat>[
      for (final f in fixtures)
        if (byFixture[f.id] case final r?)
          (
            fixtureId: f.id,
            date: f.date,
            homeNationId: f.homeNationId,
            awayNationId: f.awayNationId,
            homeScore: f.homeScore,
            awayScore: f.awayScore,
            round: f.round,
            rating: r.rating,
            goals: r.goals,
            assists: r.assists,
            cleanSheet: r.cleanSheet,
            motm: r.motm,
          ),
    ]..sort((a, b) => b.date.compareTo(a.date));
    return stats.take(limit).toList();
  }

  @override
  Future<
    List<
      ({
        int playerId,
        int goals,
        int assists,
        double rating,
        bool motm,
        int yellows,
        int reds,
      })
    >
  >
  careerPlayerLines(int careerId, Set<int> nationIds) async {
    if (nationIds.isEmpty) return const [];
    final rows =
        await (_db.select(_db.playerRatings)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.nationId.isIn(nationIds.toList()),
            ))
            .get();
    return [
      for (final r in rows)
        (
          playerId: r.playerId,
          goals: r.goals,
          assists: r.assists,
          rating: r.rating,
          motm: r.motm,
          yellows: r.yellows,
          reds: r.reds,
        ),
    ];
  }

  @override
  Future<Map<int, List<({DateTime date, double rating})>>>
  recentRatingsByNation(
    int careerId,
    int nationId, {
    int perPlayer = 8,
  }) async {
    final rows =
        await (_db.select(_db.playerRatings)..where(
              (t) => t.careerId.equals(careerId) & t.nationId.equals(nationId),
            ))
            .get();
    if (rows.isEmpty) return const {};
    final fixtures = await (_db.select(
      _db.fixtures,
    )..where((t) => t.id.isIn(rows.map((r) => r.fixtureId).toList()))).get();
    final dateOf = {for (final f in fixtures) f.id: f.date};
    final byPlayer = <int, List<({DateTime date, double rating})>>{};
    for (final r in rows) {
      final d = dateOf[r.fixtureId];
      if (d == null) continue;
      (byPlayer[r.playerId] ??= []).add((date: d, rating: r.rating));
    }
    for (final list in byPlayer.values) {
      list.sort((a, b) => b.date.compareTo(a.date)); // newest first
      if (list.length > perPlayer) list.removeRange(perPlayer, list.length);
    }
    return byPlayer;
  }

  @override
  Future<PlayerCareerStats?> playerCareerStats(
    int careerId,
    int playerId,
  ) async {
    final rows =
        await (_db.select(_db.playerRatings)..where(
              (t) => t.careerId.equals(careerId) & t.playerId.equals(playerId),
            ))
            .get();
    if (rows.isEmpty) return null;
    // Newest-first for the form window.
    final byFixture = await (_db.select(
      _db.fixtures,
    )..where((t) => t.id.isIn(rows.map((r) => r.fixtureId).toList()))).get();
    final dateOf = {for (final f in byFixture) f.id: f.date};
    final sorted = [...rows]
      ..sort(
        (a, b) => (dateOf[b.fixtureId] ?? DateTime(0)).compareTo(
          dateOf[a.fixtureId] ?? DateTime(0),
        ),
      );

    var goals = 0;
    var assists = 0;
    var cleanSheets = 0;
    var motm = 0;
    var yellows = 0;
    var reds = 0;
    var ratingSum = 0.0;
    var best = 0.0;
    for (final r in rows) {
      goals += r.goals;
      assists += r.assists;
      if (r.cleanSheet) cleanSheets++;
      if (r.motm) motm++;
      yellows += r.yellows;
      reds += r.reds;
      ratingSum += r.rating;
      if (r.rating > best) best = r.rating;
    }
    final form = sorted.take(5).toList();
    final formAvg = form.isEmpty
        ? 0.0
        : form.fold<double>(0, (s, r) => s + r.rating) / form.length;
    return (
      caps: rows.length,
      goals: goals,
      assists: assists,
      cleanSheets: cleanSheets,
      motm: motm,
      yellows: yellows,
      reds: reds,
      avgRating: ratingSum / rows.length,
      bestRating: best,
      formRating: formAvg,
    );
  }

  @override
  Future<List<({int playerId, int assists})>> nationTopAssists(
    int careerId,
    int nationId, {
    int limit = 25,
  }) async {
    final rows =
        await (_db.select(_db.playerRatings)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.nationId.equals(nationId) &
                  t.assists.isBiggerThanValue(0),
            ))
            .get();
    final tally = <int, int>{};
    for (final r in rows) {
      tally.update(r.playerId, (v) => v + r.assists, ifAbsent: () => r.assists);
    }
    final sorted = tally.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return [
      for (final e in sorted.take(limit)) (playerId: e.key, assists: e.value),
    ];
  }

  @override
  Future<void> recordPlayerHonour({
    required int careerId,
    required int playerId,
    required int nationId,
    required AwardKind kind,
    required int year,
    String competition = '',
  }) async {
    // Write-once by key: settling code that runs twice records one trophy.
    await _db
        .into(_db.playerHonours)
        .insert(
          PlayerHonoursCompanion.insert(
            careerId: careerId,
            playerId: playerId,
            nationId: nationId,
            kind: kind,
            year: year,
            competition: Value(competition),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<List<PlayerAward>> playerHonours(int careerId, int playerId) async {
    final rows =
        await (_db.select(_db.playerHonours)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) & t.playerId.equals(playerId),
              )
              ..orderBy([
                (t) =>
                    OrderingTerm(expression: t.year, mode: OrderingMode.desc),
              ]))
            .get();
    return [
      for (final r in rows)
        (
          playerId: r.playerId,
          nationId: r.nationId,
          kind: r.kind,
          competition: r.competition,
          year: r.year,
        ),
    ];
  }

  @override
  Future<List<AwardLine>> awardLinesForYear(int careerId, int year) async {
    // Every match played anywhere in the world is rated, so a year can be
    // judged on the whole world rather than the manager's corner of it.
    final ratings =
        await (_db.select(
          _db.playerRatings,
        )..where((t) => t.careerId.equals(careerId))).join([
          innerJoin(
            _db.fixtures,
            _db.fixtures.id.equalsExp(_db.playerRatings.fixtureId),
          ),
        ]).get();

    final apps = <int, int>{};
    final nation = <int, int>{};
    final goals = <int, int>{};
    final assists = <int, int>{};
    final motms = <int, int>{};
    final ratingSum = <int, double>{};
    for (final row in ratings) {
      final f = row.readTable(_db.fixtures);
      if (f.date.year != year) continue;
      final r = row.readTable(_db.playerRatings);
      apps.update(r.playerId, (v) => v + 1, ifAbsent: () => 1);
      nation[r.playerId] = r.nationId;
      goals.update(r.playerId, (v) => v + r.goals, ifAbsent: () => r.goals);
      assists.update(
        r.playerId,
        (v) => v + r.assists,
        ifAbsent: () => r.assists,
      );
      if (r.motm) motms.update(r.playerId, (v) => v + 1, ifAbsent: () => 1);
      ratingSum.update(
        r.playerId,
        (v) => v + r.rating,
        ifAbsent: () => r.rating,
      );
    }
    return [
      for (final id in apps.keys)
        (
          playerId: id,
          nationId: nation[id] ?? 0,
          // Name and age are filled in by the caller, which has the pool; the
          // repository knows what happened, not who it happened to.
          name: '',
          age: 0,
          apps: apps[id]!,
          goals: goals[id] ?? 0,
          assists: assists[id] ?? 0,
          meanRating: ratingSum[id]! / apps[id]!,
          motms: motms[id] ?? 0,
        ),
    ];
  }

  @override
  Future<Set<String>> messageKeys(int careerId) async {
    final rows = await (_db.select(
      _db.messages,
    )..where((t) => t.careerId.equals(careerId))).get();
    return {for (final r in rows) r.dedupKey};
  }

  @override
  Future<void> addMessage({
    required int careerId,
    required String dedupKey,
    required String category,
    required String title,
    required String body,
    required int year,
  }) async {
    await _db
        .into(_db.messages)
        .insert(
          MessagesCompanion.insert(
            careerId: careerId,
            dedupKey: dedupKey,
            category: category,
            title: title,
            body: body,
            year: year,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<List<MessageItem>> messages(int careerId) async {
    final rows =
        await (_db.select(_db.messages)
              ..where((t) => t.careerId.equals(careerId))
              ..orderBy([
                (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
              ]))
            .get();
    return [
      for (final r in rows)
        (
          id: r.id,
          category: r.category,
          title: r.title,
          body: r.body,
          year: r.year,
          read: r.read,
        ),
    ];
  }

  @override
  Future<int> unreadMessageCount(int careerId) async {
    final rows = await (_db.select(
      _db.messages,
    )..where((t) => t.careerId.equals(careerId) & t.read.equals(false))).get();
    return rows.length;
  }

  @override
  Future<void> markMessagesRead(int careerId, {List<int>? ids}) async {
    if (ids != null && ids.isEmpty) return;
    await (_db.update(_db.messages)..where(
          (t) =>
              t.careerId.equals(careerId) &
              t.read.equals(false) &
              (ids == null ? const Constant(true) : t.id.isIn(ids)),
        ))
        .write(const MessagesCompanion(read: Value(true)));
  }

  @override
  Future<Set<String>> earnedAchievements(int careerId) async {
    final rows = await (_db.select(
      _db.achievements,
    )..where((t) => t.careerId.equals(careerId))).get();
    return {for (final r in rows) r.achievementId};
  }

  @override
  Future<void> recordAchievement(
    int careerId,
    String achievementId,
    int year,
  ) async {
    await _db
        .into(_db.achievements)
        .insert(
          AchievementRow(
            careerId: careerId,
            achievementId: achievementId,
            earnedYear: year,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }
}

/// The hosts of [row], primary first.
///
/// The list column is nullable because it arrived after the table did: a row
/// written before it holds only [HonourRow.hostId], and that lone host is
/// exactly who hosted, so it reads back as a one-element list rather than as
/// nothing. Empty only for a row that never recorded a host at all.
List<int> _hostIds(HonourRow row) {
  final stored = row.hostIds;
  if (stored == null || stored.isEmpty) {
    return row.hostId == null ? const [] : [row.hostId!];
  }
  return [
    for (final part in stored.split(','))
      if (int.tryParse(part.trim()) case final id?) id,
  ];
}
