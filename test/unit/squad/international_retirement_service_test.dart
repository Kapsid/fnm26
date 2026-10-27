import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/repositories/drift_international_retirement_repository.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/repositories/international_retirement_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/player/international_retirement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/squad/international_retirement_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// The real store, with the finished tournaments handed in by the test, so a
/// wave can be run without simulating a whole cycle first.
class _ScriptedFinals implements InternationalRetirementRepository {
  _ScriptedFinals(this._inner);

  final DriftInternationalRetirementRepository _inner;
  List<FinishedFinals> finals = const [];

  @override
  Future<List<FinishedFinals>> finishedFinals(
    int careerId, {
    Set<int> skip = const {},
  }) async => [
    for (final f in finals)
      if (!skip.contains(f.competitionId)) f,
  ];

  @override
  Future<bool> hasMarker(int careerId, String kind) =>
      _inner.hasMarker(careerId, kind);

  @override
  Future<Set<String>> markersWithPrefix(int careerId, String prefix) =>
      _inner.markersWithPrefix(careerId, prefix);

  @override
  Future<void> addMarkers(int careerId, int cycle, Iterable<String> kinds) =>
      _inner.addMarkers(careerId, cycle, kinds);
}

final List<Nation> _nations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync())
            as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

final List<Player> _players = PoolGenerator.expand(
  (jsonDecode(File('assets/data/players.json').readAsStringSync())
          as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, Object?>))
      .toList(),
);

int get _strongest => _nations
    .where((n) => n.confederation == Confederation.europe)
    .reduce((a, b) => a.ranking <= b.ranking ? a : b)
    .id;

typedef _Save = ({
  ProviderContainer container,
  Career career,
  _ScriptedFinals finals,
});

Future<_Save> _newSave({int seed = 777, bool realFinals = false}) async {
  SharedPreferences.setMockInitialValues({});
  final db = createTestDatabase();
  final scripted = _ScriptedFinals(DriftInternationalRetirementRepository(db));
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => true),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: _nations, playerList: _players),
      ),
      if (!realFinals)
        internationalRetirementRepositoryProvider.overrideWithValue(scripted),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(db.close);
  await container.read(seedLoaderProvider).ensureSeeded();
  final career =
      (await container
              .read(careerServiceProvider)
              .create(nationId: _strongest, managerName: 'M', rngSeed: seed))
          .valueOrNull!;
  return (container: container, career: career, finals: scripted);
}

/// A World Championship every nation played, won by [champion].
FinishedFinals _worldChampionship(int champion) => (
  competitionId: 999001,
  kind: CompetitionKind.worldCupFinals,
  confederation: Confederation.europe,
  cycle: 0,
  participants: {for (final n in _nations) n.id},
  championId: champion,
  endedOn: DateTime(2026, 7, 19),
);

Future<Set<String>> _retireMarkers(_Save s) => s.container
    .read(internationalRetirementRepositoryProvider)
    .markersWithPrefix(s.career.id, InternationalRetirement.retiredPrefix);

void main() {
  _moreTests();
  test('an old save starts with nobody retired', () async {
    final s = await _newSave();
    // A tournament already finished before this build ever saw the save.
    s.finals.finals = [_worldChampionship(_strongest)];
    final service = s.container.read(internationalRetirementServiceProvider);
    expect(await service.settle(s.career.id), isFalse);
    expect(await service.settle(s.career.id), isFalse);
    expect(await _retireMarkers(s), isEmpty);
    expect(
      await s.container
          .read(playerRepositoryProvider)
          .internationalRetirements(s.career.id),
      isEmpty,
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  test(
    'a finished tournament retires veterans everywhere, and they are no '
    'longer selectable by the manager or the AI',
    () async {
      final s = await _newSave();
      final service = s.container.read(internationalRetirementServiceProvider);
      // First look: nothing finished yet.
      expect(await service.settle(s.career.id), isFalse);
      s.finals.finals = [_worldChampionship(_strongest)];
      expect(await service.settle(s.career.id), isTrue);
      // Run once only.
      expect(await service.settle(s.career.id), isFalse);

      final repo = s.container.read(playerRepositoryProvider);
      final retired = await repo.internationalRetirements(s.career.id);
      expect(retired, isNotEmpty);
      // A wave, not a cull: about one veteran per nation that played (every
      // nation played this one), held under the per-wave cap.
      expect(retired.length, lessThan(_nations.length * 2));
      // Veterans, not boys: nobody under twenty-nine.
      final years = CareerService.agingYears(s.career);
      for (final id in retired.keys) {
        final p = await repo.byId(
          id,
          agingYears: years,
          saveSeed: s.career.rngSeed,
          careerId: s.career.id,
        );
        expect(p, isNotNull, reason: 'a retired player still exists');
        expect(p!.age, greaterThanOrEqualTo(29));
      }

      // Not selectable: no nation's pool (the world's read) holds them.
      final byNation = <int, List<int>>{};
      for (final id in retired.keys) {
        final p = (await repo.byId(id, careerId: s.career.id))!;
        (byNation[p.nationId] ??= []).add(id);
      }
      for (final e in byNation.entries) {
        final pool = await careerPoolOf(
          _ref(s.container),
          s.career,
          e.key,
        );
        for (final id in e.value) {
          expect(pool.map((p) => p.id), isNot(contains(id)));
        }
        // And without the career (no save: the nation pick) they are there.
        final raw = await repo.byNation(e.key, agingYears: years);
        expect(raw.map((p) => p.id), containsAll(e.value));
      }

      // The manager's own call-up pool leaves them out too.
      final squad = await s.container.read(
        squadDataProvider(s.career.id).future,
      );
      final mine = byNation[s.career.nationId] ?? const [];
      for (final id in mine) {
        expect(squad!.pool.map((p) => p.id), isNot(contains(id)));
      }
      // And his own retirees were announced in the inbox.
      final keys = await s.container
          .read(competitionRepositoryProvider)
          .messageKeys(s.career.id);
      for (final id in mine) {
        expect(keys, contains('retire:$id'));
      }

      // Every nation keeps a full pool.
      for (final nid in byNation.keys) {
        final pool = await repo.byNation(
          nid,
          agingYears: years,
          saveSeed: s.career.rngSeed,
          careerId: s.career.id,
        );
        expect(
          pool.length,
          greaterThanOrEqualTo(InternationalRetirement.minPool),
        );
        expect(
          pool.where((p) => p.category == PositionCategory.goalkeeper).length,
          greaterThanOrEqualTo(2),
        );
      }
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );

  test('the same seed retires the same players', () async {
    Future<Set<String>> run() async {
      final s = await _newSave(seed: 4242);
      final service = s.container.read(internationalRetirementServiceProvider);
      await service.settle(s.career.id);
      s.finals.finals = [_worldChampionship(_strongest)];
      await service.settle(s.career.id);
      return _retireMarkers(s);
    }

    final a = await run();
    final b = await run();
    expect(a, isNotEmpty);
    expect(a, b);
  }, timeout: const Timeout(Duration(minutes: 10)));

  test('a comeback restores selectability from its year on', () async {
    final s = await _newSave();
    final repo = s.container.read(playerRepositoryProvider);
    final store = s.container.read(internationalRetirementRepositoryProvider);
    final nid = s.career.nationId;
    final pool = await repo.byNation(
      nid,
      agingYears: 2,
      saveSeed: s.career.rngSeed,
      careerId: s.career.id,
    );
    final star = pool.first;
    await store.addMarkers(s.career.id, 0, [
      InternationalRetirement.retiredKind(star.id, 2, DateTime(2028, 7, 20)),
    ]);
    Future<bool> inPool(int years) async => (await repo.byNation(
      nid,
      agingYears: years,
      saveSeed: s.career.rngSeed,
      careerId: s.career.id,
    )).any((p) => p.id == star.id);

    expect(await inPool(1), isTrue, reason: 'before he announced it');
    expect(await inPool(2), isFalse);
    expect(await inPool(3), isFalse);
    await store.addMarkers(s.career.id, 0, [
      InternationalRetirement.comebackKind(star.id, 4, DateTime(2030, 3, 1)),
    ]);
    expect(await inPool(3), isFalse);
    expect(await inPool(4), isTrue, reason: 'back from his comeback year');
  }, timeout: const Timeout(Duration(minutes: 5)));
}

/// A [Ref] for helpers that take one, read through a throwaway provider.
Ref _ref(ProviderContainer c) => c.read(_refProvider);

final Provider<Ref> _refProvider = Provider((ref) => ref);

/// A finished World Championship written straight into the save's tables:
/// eight nations, a played quarter-final round, semis, a third-place
/// play-off two days before the final. [champion] wins the final.
Future<int> _insertFinishedFinals(
  AppDatabase db,
  int careerId,
  List<int> nationIds,
  int champion, {
  int cycle = 9,
  bool finished = true,
}) async {
  final compId = await db
      .into(db.competitions)
      .insert(
        CompetitionsCompanion.insert(
          careerId: careerId,
          confederation: Confederation.europe,
          name: 'World Championship',
          kind: const Value(CompetitionKind.worldCupFinals),
          cycle: Value(cycle),
        ),
      );
  Future<void> fixture(
    int home,
    int away,
    DateTime date, {
    bool homeWins = true,
    bool played = true,
  }) => db
      .into(db.fixtures)
      .insert(
        FixturesCompanion.insert(
          careerId: careerId,
          competitionId: compId,
          matchday: 1,
          date: date,
          homeNationId: home,
          awayNationId: away,
          homeScore: Value(played ? (homeWins ? 2 : 0) : null),
          awayScore: Value(played ? (homeWins ? 0 : 1) : null),
          played: Value(played),
        ),
      );
  final n = nationIds;
  for (var i = 0; i < 8; i += 2) {
    await fixture(n[i], n[i + 1], DateTime(2034, 7, 1));
  }
  await fixture(n[0], n[2], DateTime(2034, 7, 8));
  await fixture(n[4], n[6], DateTime(2034, 7, 8));
  // Third place two days BEFORE the final: the final is still the last.
  await fixture(n[2], n[6], DateTime(2034, 7, 17));
  await fixture(
    n[4],
    champion,
    DateTime(2034, 7, 19),
    homeWins: false,
    played: finished,
  );
  return compId;
}

void _moreTests() {
  test(
    'the real store reads a finished finals, and only a finished one',
    () async {
      final s = await _newSave(realFinals: true);
      final db = s.container.read(appDatabaseProvider);
      final eight = [for (final x in _nations.take(8)) x.id];
      final done = await _insertFinishedFinals(
        db,
        s.career.id,
        eight,
        eight[0],
      );
      await _insertFinishedFinals(
        db,
        s.career.id,
        eight,
        eight[0],
        cycle: 10,
        finished: false,
      );
      final store = s.container.read(internationalRetirementRepositoryProvider);
      final finals = await store.finishedFinals(s.career.id);
      expect(finals.map((f) => f.competitionId), [done]);
      expect(finals.single.participants, eight.toSet());
      expect(finals.single.championId, eight[0]);
      expect(finals.single.cycle, 9);
      expect(
        await store.finishedFinals(s.career.id, skip: {done}),
        isEmpty,
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test('a bundle round trip re-runs no wave', () async {
    final s = await _newSave(realFinals: true);
    final db = s.container.read(appDatabaseProvider);
    final service = s.container.read(internationalRetirementServiceProvider);
    expect(await service.settle(s.career.id), isFalse); // first look
    final eight = [for (final x in _nations.take(8)) x.id];
    await _insertFinishedFinals(db, s.career.id, eight, eight[0]);
    await service.settle(s.career.id);
    final store = s.container.read(internationalRetirementRepositoryProvider);
    final before = await store.markersWithPrefix(
      s.career.id,
      InternationalRetirement.retiredPrefix,
    );

    final bundle = await CareerBundle.export(db, s.career.id);
    final imported = await CareerBundle.import(db, bundle);
    expect(imported, isNot(s.career.id));
    // The imported tournament has a NEW competition id; its wave is done all
    // the same, so settling the import changes nothing.
    expect(await service.settle(imported), isFalse);
    expect(
      await store.markersWithPrefix(
        imported,
        InternationalRetirement.retiredPrefix,
      ),
      before,
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  test(
    'comebacks: a good retiree can return in an injury crisis, with news',
    () async {
      final s = await _newSave();
      final service = s.container.read(internationalRetirementServiceProvider);
      expect(await service.settle(s.career.id), isFalse); // first look
      final repo = s.container.read(playerRepositoryProvider);
      final store = s.container.read(
        internationalRetirementRepositoryProvider,
      );
      final nid = s.career.nationId;
      final pool = await repo.byNation(
        nid,
        agingYears: 3,
        saveSeed: s.career.rngSeed,
        careerId: s.career.id,
      );
      // Forty good men under 34 retired at the opening tournament.
      final retirees = [
        for (final p in pool)
          if (p.age <= 33) p,
      ].take(40).toList();
      await store.addMarkers(s.career.id, 0, [
        for (final p in retirees)
          InternationalRetirement.retiredKind(
            p.id,
            0,
            DateTime(2026, 7, 20),
            nationId: nid,
          ),
      ]);
      // An injury crisis among those left.
      final left = await repo.byNation(
        nid,
        agingYears: 3,
        saveSeed: s.career.rngSeed,
        careerId: s.career.id,
      );
      await s.container.read(absenceRepositoryProvider).replace(s.career.id, [
        for (final p in left.take(5))
          PlayerAbsence(playerId: p.id, injuryMatches: 2),
      ]);
      await s.container
          .read(careerRepositoryProvider)
          .updateInGameDate(s.career.id, DateTime(2029, 1, 10));
      expect(await service.settle(s.career.id), isTrue);
      final back = InternationalRetirement.decode(
        await store.markersWithPrefix(
          s.career.id,
          InternationalRetirement.comebackPrefix,
        ),
      );
      final retired = await repo.internationalRetirements(s.career.id);
      final returned = [
        for (final r in retired.values)
          if (r.comebackAging != null) r.playerId,
      ];
      expect(returned, isNotEmpty);
      expect(back, isEmpty, reason: 'decode keys comebacks on retirements');
      final now = await repo.byNation(
        nid,
        agingYears: 3,
        saveSeed: s.career.rngSeed,
        careerId: s.career.id,
      );
      final keys = await s.container
          .read(competitionRepositoryProvider)
          .messageKeys(s.career.id);
      for (final id in returned) {
        expect(now.map((p) => p.id), contains(id));
        expect(keys, contains('intlBack:$id'));
      }
      // Rolled once a year only.
      expect(await service.settle(s.career.id), isFalse);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'a long save: thousands of retirees cost no stall, reads are cached',
    () async {
      final s = await _newSave();
      final service = s.container.read(internationalRetirementServiceProvider);
      expect(await service.settle(s.career.id), isFalse); // first look
      final repo = s.container.read(playerRepositoryProvider);
      final store = s.container.read(
        internationalRetirementRepositoryProvider,
      );
      // Six thousand retirements over the save: most long ago (past any
      // comeback), some recent enough to be rolled for.
      final ids = [for (final p in _players) (p.id, p.nationId)];
      final markers = <String>[];
      for (var i = 0; i < 6000 && i < ids.length; i++) {
        final (id, nid) = ids[i];
        markers.add(
          InternationalRetirement.retiredKind(
            id,
            i % 10 == 0 ? 9 : 1,
            DateTime(2030, 7, 20),
            nationId: nid,
          ),
        );
      }
      await store.addMarkers(s.career.id, 0, markers);
      final all = await repo.internationalRetirements(s.career.id);
      expect(all.length, markers.length);
      expect(
        identical(all, await repo.internationalRetirements(s.career.id)),
        isTrue,
        reason: 'decoded once, then served from the cache',
      );

      await s.container
          .read(careerRepositoryProvider)
          .updateInGameDate(s.career.id, DateTime(2038, 1, 10));
      final watch = Stopwatch()..start();
      await service.settle(s.career.id);
      final roll = watch.elapsedMilliseconds;
      // Every nation's selectable pool, as a world-simulation step reads it.
      watch.reset();
      for (final n in _nations) {
        await repo.byNation(
          n.id,
          agingYears: 12,
          saveSeed: s.career.rngSeed,
          careerId: s.career.id,
        );
      }
      final pools = watch.elapsedMilliseconds;
      // The timings, for the report; the bounds below are the check.
      // ignore: avoid_print
      print('comeback roll ${roll}ms, ${_nations.length} pools ${pools}ms');
      expect(roll, lessThan(20000));
      expect(pools, lessThan(20000));

      // A new marker drops the cache: the next read sees it.
      final extra = _players.last;
      await store.addMarkers(s.career.id, 0, [
        InternationalRetirement.retiredKind(
          extra.id,
          12,
          DateTime(2038, 1, 10),
          nationId: extra.nationId,
        ),
      ]);
      final after = await repo.internationalRetirements(s.career.id);
      expect(identical(after, all), isFalse);
      expect(after.containsKey(extra.id), isTrue);
      expect(
        (await repo.internationalRetirementsByNation(
          s.career.id,
        ))[extra.nationId]?.containsKey(extra.id),
        isTrue,
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
