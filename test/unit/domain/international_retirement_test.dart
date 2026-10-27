import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/international_retirement.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';

/// Every roll succeeds: the harshest possible wave, which only the pool guard
/// (and the per-wave cap) can hold back.
class _AlwaysRng extends SeededRng {
  _AlwaysRng() : super(1);

  @override
  double nextDouble() => 0;
}

const IntlRetireContext _played = (
  participated: true,
  champion: false,
  worldChampionship: true,
  appsByPlayer: <int, int>{},
  ratingByPlayer: <int, double>{},
);

/// A deep, ordinary squad: [n] players spread over the lines and the ages.
List<Player> _squad(int n, {int nationId = 1, int idBase = 1000}) => [
  for (var i = 0; i < n; i++)
    player(
      id: idBase + i,
      nationId: nationId,
      name: 'P$i',
      position: const [
        PlayerPosition.gk,
        PlayerPosition.cb,
        PlayerPosition.lb,
        PlayerPosition.rb,
        PlayerPosition.cm,
        PlayerPosition.dm,
        PlayerPosition.am,
        PlayerPosition.st,
        PlayerPosition.lw,
        PlayerPosition.cb,
      ][i % 10],
      age: 19 + (i % 19), // 19 … 37
      attributes: flatAttributes(60 + (i * 7) % 30),
    ),
];

void main() {
  group('markers', () {
    test('decode reads retirements and a later comeback, once per player', () {
      final kinds = [
        InternationalRetirement.retiredKind(7, 4, DateTime(2030, 7, 20)),
        // A second announcement for the same man is ignored: the first stands.
        InternationalRetirement.retiredKind(7, 6, DateTime(2032, 7, 20)),
        InternationalRetirement.comebackKind(7, 6, DateTime(2032, 3, 1)),
        InternationalRetirement.retiredKind(8, 2, DateTime(2028, 7, 15)),
        'worldCupFinals',
        'intlRetDone:12',
      ];
      final r = InternationalRetirement.decode(kinds);
      expect(r.keys, unorderedEquals([7, 8]));
      expect(r[7]!.retiredAging, 4);
      expect(r[7]!.retiredYear, 2030);
      expect(r[7]!.retiredOn, DateTime(2030, 7, 20));
      expect(r[7]!.comebackAging, 6);
      expect(r[7]!.comebackYear, 2032);
      expect(r[8]!.comebackAging, isNull);
    });

    test('a retired player is out from his year until his comeback', () {
      const r = IntlRetirement(
        playerId: 1,
        retiredAging: 4,
        retiredYear: 2030,
        comebackAging: 7,
        comebackYear: 2033,
      );
      expect(r.isRetiredAt(3), isFalse, reason: 'before he announced it');
      expect(r.isRetiredAt(4), isTrue);
      expect(r.isRetiredAt(6), isTrue);
      expect(r.isRetiredAt(7), isFalse, reason: 'the comeback restores him');
    });

    test('filterPool drops the retired and keeps the rest as they were', () {
      final pool = _squad(40);
      final kinds = [
        InternationalRetirement.retiredKind(pool[3].id, 2, DateTime(2028)),
        InternationalRetirement.retiredKind(pool[5].id, 2, DateTime(2028)),
        InternationalRetirement.comebackKind(pool[5].id, 4, DateTime(2030)),
      ];
      final r = InternationalRetirement.decode(kinds);
      final at3 = InternationalRetirement.filterPool(pool, r, 3);
      expect(at3.map((p) => p.id), isNot(contains(pool[3].id)));
      expect(at3.map((p) => p.id), isNot(contains(pool[5].id)));
      expect(at3, hasLength(38));
      final at4 = InternationalRetirement.filterPool(pool, r, 4);
      expect(at4.map((p) => p.id), contains(pool[5].id));
      expect(at4, hasLength(39));
      // Before anyone retired, the pool comes back untouched.
      expect(
        identical(InternationalRetirement.filterPool(pool, r, 1), pool),
        isTrue,
      );
    });
  });

  group('wave identity', () {
    test('a wave is keyed on what the tournament is, not its row id', () {
      expect(
        InternationalRetirement.waveKey(
          CompetitionKind.worldCupFinals,
          Confederation.africa,
          3,
        ),
        'wc:3',
      );
      expect(
        InternationalRetirement.waveKey(
          CompetitionKind.continentalFinals,
          Confederation.africa,
          3,
        ),
        'cont:africa:3',
      );
      // The seed salt is a fixed function of the key.
      expect(
        InternationalRetirement.stableHash('wc:3'),
        InternationalRetirement.stableHash('wc:3'),
      );
      expect(
        InternationalRetirement.stableHash('wc:3'),
        isNot(InternationalRetirement.stableHash('wc:4')),
      );
    });

    test('the marker carries the nation and whether he was notable', () {
      final r = InternationalRetirement.decodeRows([
        (
          kind: InternationalRetirement.retiredKind(
            5,
            2,
            DateTime(2028, 7, 1),
            nationId: 44,
            notable: true,
          ),
          cycle: 0,
        ),
      ])[5]!;
      expect(r.nationId, 44);
      expect(r.notable, isTrue);
      expect(r.retiredCycle, 0);
    });
  });

  group('the guard pool', () {
    test('leaves out the age wave due next December and the long injured', () {
      final pool = _squad(60);
      final dueOut = pool.firstWhere(
        (p) => PlayerLifecycle.hasRetiredAt(p.id, p.age + 1, 1),
      );
      final staying = pool.firstWhere(
        (p) => !PlayerLifecycle.hasRetiredAt(p.id, p.age + 1, 1),
      );
      final guard = InternationalRetirement.guardPoolFor(
        pool,
        0,
        longInjured: {staying.id},
      );
      expect(guard.map((p) => p.id), isNot(contains(dueOut.id)));
      expect(guard.map((p) => p.id), isNot(contains(staying.id)));
    });

    test('a keeper may not go if the age wave takes the cover next', () {
      // Four top keepers: three of thirty, one due to age out in December.
      final keepers = [
        for (var i = 0; i < 4; i++)
          player(
            id: 9100 + i,
            nationId: 1,
            position: PlayerPosition.gk,
            age: i == 1 ? 41 : 30,
            attributes: flatAttributes(92),
          ),
      ];
      final pool = [
        for (final p in _squad(80))
          if (p.position != PlayerPosition.gk) p,
        ...keepers,
      ];
      final out = InternationalRetirement.waveFor(
        pool: pool,
        guardPool: InternationalRetirement.guardPoolFor(pool, 0),
        context: _played,
        rng: _AlwaysRng(),
      );
      expect(
        // The one due to age out anyway may announce it (losing him costs
        // the guard nothing); the three who stay may not.
        out.where(
          (d) => d.player.position == PlayerPosition.gk && d.player.id != 9101,
        ),
        isEmpty,
        reason: 'three stay after December: none of them may go',
      );
    });
  });

  group('the wave', () {
    test('retirements skew old: rare under 31, common from 34', () {
      // Many nations' worth of the same deep squad, each its own roll.
      final byAge = <int, (int, int)>{};
      for (var nation = 0; nation < 400; nation++) {
        final pool = _squad(120, nationId: nation, idBase: nation * 1000);
        final out = InternationalRetirement.waveFor(
          pool: pool,
          context: _played,
          rng: SeededRng(InternationalRetirement.seedFor(99, 1, nation)),
        );
        final retired = {for (final d in out) d.player.id};
        for (final p in pool) {
          final (n, k) = byAge[p.age] ?? (0, 0);
          byAge[p.age] = (n + 1, k + (retired.contains(p.id) ? 1 : 0));
        }
      }
      double rate(bool Function(int) ages) {
        var n = 0;
        var k = 0;
        for (final e in byAge.entries) {
          if (!ages(e.key)) continue;
          n += e.value.$1;
          k += e.value.$2;
        }
        return k / n;
      }

      final young = rate((a) => a < 29);
      final surprise = rate((a) => a == 29 || a == 30);
      final mid = rate((a) => a >= 31 && a <= 33);
      final old = rate((a) => a >= 34);
      expect(young, 0);
      expect(surprise, greaterThan(0), reason: 'the odd surprise');
      expect(surprise, lessThan(0.02));
      expect(mid, greaterThan(surprise * 2));
      expect(old, greaterThan(mid * 1.5));
    });

    test('a nation that missed the finals loses only its stars', () {
      const missed = (
        participated: false,
        champion: false,
        worldChampionship: true,
        appsByPlayer: <int, int>{},
        ratingByPlayer: <int, double>{},
      );
      final pool = _squad(120);
      final ranked = [...pool]
        ..sort((a, b) {
          final by = b.overall.compareTo(a.overall);
          return by != 0 ? by : a.id.compareTo(b.id);
        });
      final stars = ranked.take(6).map((p) => p.id).toSet();
      final out = InternationalRetirement.waveFor(
        pool: pool,
        context: missed,
        rng: _AlwaysRng(),
      );
      for (final d in out) {
        expect(stars, contains(d.player.id));
        expect(d.player.age, greaterThanOrEqualTo(31));
        expect(d.reason, IntlRetireReason.missedOut);
      }
    });

    test('a champion star of thirty-plus may go out on a high', () {
      final star = player(
        id: 1,
        nationId: 1,
        position: PlayerPosition.st,
        age: 30,
        attributes: flatAttributes(90),
      );
      final c = InternationalRetirement.chanceFor(
        p: star,
        rank: 0,
        poolSize: 120,
        context: (
          participated: true,
          champion: true,
          worldChampionship: true,
          appsByPlayer: const {1: 7},
          ratingByPlayer: const {1: 7.4},
        ),
      );
      expect(c.reason, IntlRetireReason.onAHigh);
      expect(c.chance, greaterThan(0.15));
    });

    test('a continental title sends nobody out on a high', () {
      ({double chance, IntlRetireReason reason}) at(int age, int rank) =>
          InternationalRetirement.chanceFor(
            p: player(
              id: 1,
              nationId: 1,
              position: PlayerPosition.st,
              age: age,
              attributes: flatAttributes(90),
            ),
            rank: rank,
            poolSize: 120,
            context: (
              participated: true,
              champion: true,
              worldChampionship: false,
              appsByPlayer: const {1: 7},
              ratingByPlayer: const {1: 7.4},
            ),
          );
      // A star in his early thirties stays on.
      expect(at(31, 0).chance, 0);
      expect(at(33, 3).chance, 0);
      // The oldest may still stop, but not "on a high".
      expect(at(34, 0).chance, greaterThan(0));
      expect(at(34, 0).reason, isNot(IntlRetireReason.onAHigh));
      // So may a man on the fringe of the squad.
      expect(at(32, 25).chance, greaterThan(0));
    });

    test('the same seed tells the same story', () {
      final pool = _squad(120);
      List<int> run(int seed) => [
        for (final d in InternationalRetirement.waveFor(
          pool: pool,
          context: _played,
          rng: SeededRng(seed),
        ))
          d.player.id,
      ];
      expect(run(4242), run(4242));
      final differs = {for (var s = 0; s < 30; s++) run(s).join(',')};
      expect(differs.length, greaterThan(1));
    });

    test('a thin pool retires far less than a deep one', () {
      expect(
        InternationalRetirement.depthFactor(35),
        lessThan(InternationalRetirement.depthFactor(120) / 5),
      );
      expect(InternationalRetirement.maxPerWave(35), 1);
      expect(InternationalRetirement.maxPerWave(120), 3);
    });
  });

  group('the pool guard', () {
    test('never takes a pool below the floor or a line below its minimum', () {
      // Exactly at the floor: nobody may leave, however the dice fall.
      final atFloor = _squad(InternationalRetirement.minPool);
      expect(
        InternationalRetirement.waveFor(
          pool: atFloor,
          context: _played,
          rng: _AlwaysRng(),
        ),
        isEmpty,
      );
      // Three keepers in a deep pool: none of them may go.
      final squad = [
        for (final p in _squad(80))
          if (p.position != PlayerPosition.gk) p,
        for (var i = 0; i < 3; i++)
          player(
            id: 9000 + i,
            nationId: 1,
            position: PlayerPosition.gk,
            age: 36,
            attributes: flatAttributes(70),
          ),
      ];
      final out = InternationalRetirement.waveFor(
        pool: squad,
        context: _played,
        rng: _AlwaysRng(),
      );
      expect(
        out.where((d) => d.player.position == PlayerPosition.gk),
        isEmpty,
        reason: 'the last three keepers stay',
      );
    });

    test('never leaves fewer than two keepers good enough to play', () {
      // Two good keepers and two schoolboy-level ones: the good ones stay.
      final squad = [
        for (final p in _squad(80))
          if (p.position != PlayerPosition.gk) p,
        player(
          id: 9001,
          nationId: 1,
          position: PlayerPosition.gk,
          age: 36,
          attributes: flatAttributes(80),
        ),
        player(
          id: 9002,
          nationId: 1,
          position: PlayerPosition.gk,
          age: 35,
          attributes: flatAttributes(79),
        ),
        player(
          id: 9003,
          nationId: 1,
          position: PlayerPosition.gk,
          age: 20,
          attributes: flatAttributes(35),
        ),
        player(
          id: 9004,
          nationId: 1,
          position: PlayerPosition.gk,
          age: 20,
          attributes: flatAttributes(35),
        ),
      ];
      final out = InternationalRetirement.waveFor(
        pool: squad,
        context: _played,
        rng: _AlwaysRng(),
      );
      expect(
        out.where((d) => d.player.position == PlayerPosition.gk),
        isEmpty,
      );
    });

    test('holds for a minnow over a long run of cycles (stress)', () {
      // The thinnest real nation, aged through 40 years with a wave after
      // every tournament (each even year) in which every roll succeeds.
      final base =
          (jsonDecode(File('assets/data/players.json').readAsStringSync())
                  as List<dynamic>)
              .map((e) => Player.fromJson(e as Map<String, Object?>))
              .toList();
      final all = PoolGenerator.expand(base);
      final byNation = <int, List<Player>>{};
      for (final p in all) {
        (byNation[p.nationId] ??= []).add(p);
      }
      // A minnow: the weakest squad, cut back to its real 23 so its pool is
      // thin and the guard has to work.
      final weakest = byNation.entries.reduce((a, b) {
        double avg(List<Player> ps) =>
            ps.fold<int>(0, (s, p) => s + p.overall) / ps.length;
        return avg(a.value) <= avg(b.value) ? a : b;
      });
      final nationId = weakest.key;
      final seeded = [
        for (final p in weakest.value)
          if (p.id < 10000000) p,
      ];
      var records = <int, IntlRetirement>{};
      var anyRetired = false;
      var checkNext = false;
      for (var years = 0; years <= 40; years++) {
        final pool = InternationalRetirement.filterPool(
          PlayerLifecycle.poolAt(seeded, nationId, years),
          records,
          years,
        );
        // The year after a wave (the December age wave has run): the pool
        // the guard promised must still be there.
        if (checkNext) {
          checkNext = false;
          expect(
            pool.length,
            greaterThanOrEqualTo(InternationalRetirement.minPool),
            reason: 'year $years, after the age wave',
          );
          for (final e in InternationalRetirement.minByLine.entries) {
            expect(
              pool.where((p) => p.category == e.key).length,
              greaterThanOrEqualTo(e.value),
              reason: 'year $years, ${e.key}, after the age wave',
            );
          }
        }
        if (years.isOdd) continue;
        final out = InternationalRetirement.waveFor(
          pool: pool,
          guardPool: InternationalRetirement.guardPoolFor(pool, years),
          context: _played,
          rng: _AlwaysRng(),
          alreadyRetired: records.keys.toSet(),
        );
        if (out.isEmpty) continue;
        anyRetired = true;
        checkNext = true;
        records = {
          ...records,
          for (final d in out)
            d.player.id: IntlRetirement(
              playerId: d.player.id,
              retiredAging: years,
              retiredYear: 2026 + years,
            ),
        };
      }
      expect(anyRetired, isTrue, reason: 'the stress run must stress');
    });
  });

  group('comebacks', () {
    test('only a player still good enough, and likelier in a crisis', () {
      final pool = _squad(60);
      final good = player(
        id: 1,
        nationId: 1,
        position: PlayerPosition.cm,
        age: 33,
        attributes: flatAttributes(92),
      );
      final poor = player(
        id: 2,
        nationId: 1,
        position: PlayerPosition.cm,
        age: 33,
        attributes: flatAttributes(40),
      );
      int count(Player p, {int injured = 0}) {
        var n = 0;
        for (var s = 0; s < 2000; s++) {
          if (InternationalRetirement.comesBack(
            p: p,
            pool: pool,
            injuredInSquad: injured,
            newManager: false,
            rng: SeededRng(s * 7919 + 13),
          )) {
            n++;
          }
        }
        return n;
      }

      expect(count(poor, injured: 5), 0);
      final calm = count(good);
      final crisis = count(good, injured: 4);
      expect(calm, greaterThan(0));
      expect(calm, lessThan(200), reason: 'rare in normal times');
      expect(crisis, greaterThan(calm * 2));
    });
  });
}
