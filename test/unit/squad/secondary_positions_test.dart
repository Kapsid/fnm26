import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/player/secondary_positions.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';

Player _p({
  required int id,
  PlayerPosition position = PlayerPosition.lw,
  int physical = 70,
  int technical = 70,
  int stamina = 70,
  List<PlayerPosition>? fixed,
}) => Player(
  id: id,
  nationId: 1,
  name: 'P$id',
  age: 26,
  position: position,
  attributes: PlayerAttributes(
    physical: physical,
    technical: technical,
    stamina: stamina,
  ),
  fixedSecondaries: fixed,
);

/// The whole seed pool, as the game ships it.
List<Player> _seedPool() => [
  for (final j
      in jsonDecode(File('assets/data/players.json').readAsStringSync())
          as List)
    Player.fromJson(j as Map<String, Object?>),
];

/// The first id in 1..5000 whose roll gives [want] secondaries to [p]'s
/// build (so a test can look at a player who has them).
int _idWith(Player p, int want) {
  for (var id = 1; id < 5000; id++) {
    if (SecondaryPositions.derive(id, p.position, p.attributes).length ==
        want) {
      return id;
    }
  }
  throw StateError('no id gives $want');
}

void main() {
  final pool = _seedPool();
  final outfield = [
    for (final p in pool)
      if (p.position != PlayerPosition.gk) p,
  ];

  group('SecondaryPositions distribution (the whole seed pool)', () {
    test('about three in ten outfielders have one, a few have two', () {
      var one = 0, two = 0;
      for (final p in outfield) {
        final n = SecondaryPositions.of(p).length;
        if (n == 1) one++;
        if (n == 2) two++;
        expect(n, lessThanOrEqualTo(SecondaryPositions.max));
      }
      final oneShare = one / outfield.length;
      final twoShare = two / outfield.length;
      expect(oneShare, inInclusiveRange(0.25, 0.35), reason: '$one');
      expect(twoShare, inInclusiveRange(0.05, 0.08), reason: '$two');
    });

    test('keepers never have one', () {
      for (final p in pool.where((p) => p.position == PlayerPosition.gk)) {
        expect(SecondaryPositions.of(p), isEmpty);
      }
    });

    test('every pair is a plausible one, never his own position', () {
      final seen = <(PlayerPosition, PlayerPosition)>{};
      for (final p in outfield) {
        for (final s in SecondaryPositions.of(p)) {
          expect(s.position, isNot(p.position));
          expect(
            SecondaryPositions.candidatesFor(p.position),
            contains(s.position),
          );
          expect(s.position, isNot(PlayerPosition.gk));
          seen.add((p.position, s.position));
        }
      }
      // Not one kind of move everywhere: both moves within a line and moves
      // across lines appear, and the owner's own examples among them.
      expect(seen, contains((PlayerPosition.lw, PlayerPosition.am)));
      expect(seen, contains((PlayerPosition.lw, PlayerPosition.lb)));
      expect(seen, contains((PlayerPosition.am, PlayerPosition.st)));
      expect(seen, contains((PlayerPosition.cb, PlayerPosition.dm)));
      expect(seen.length, greaterThan(25));
    });

    test('factors are almost his own position, never better', () {
      for (final p in outfield) {
        for (final s in SecondaryPositions.of(p)) {
          expect(
            s.factor,
            inInclusiveRange(
              SecondaryPositions.minFactor,
              SecondaryPositions.maxFactor,
            ),
          );
          expect(s.factor, lessThan(PositionFit.factorFor(p, p.position)));
          expect(PositionFit.factorFor(p, s.position), s.factor);
        }
      }
    });
  });

  group('SecondaryPositions plausibility', () {
    test('a winger who never defends is never a full-back', () {
      for (var id = 1; id < 4000; id++) {
        final winger = _p(
          id: id,
          physical: 62,
          technical: 82,
          stamina: 55,
        );
        final rightWinger = winger.copyWith(position: PlayerPosition.rw);
        expect(
          SecondaryPositions.of(winger).map((s) => s.position),
          isNot(contains(PlayerPosition.lb)),
        );
        expect(
          SecondaryPositions.of(rightWinger).map((s) => s.position),
          isNot(contains(PlayerPosition.rb)),
        );
        expect(
          SecondaryPositions.suitability(
            PlayerPosition.lw,
            PlayerPosition.lb,
            winger.attributes,
          ),
          isNull,
        );
      }
    });

    test('a winger who runs and tackles can drop to full-back', () {
      const a = PlayerAttributes(physical: 74, technical: 66, stamina: 80);
      expect(
        SecondaryPositions.suitability(PlayerPosition.lw, PlayerPosition.lb, a),
        isNotNull,
      );
      final id = _idWith(
        _p(id: 0, physical: 74, technical: 66, stamina: 80),
        1,
      );
      final p = _p(id: id, physical: 74, technical: 66, stamina: 80);
      // His best fit is the one he gets: across a line before his own line.
      expect(
        SecondaryPositions.of(p).single.position,
        isNot(PlayerPosition.rw),
      );
    });

    test('a better fit plays the secondary closer to his own position', () {
      const just = PlayerAttributes(physical: 70, technical: 72, stamina: 70);
      const well = PlayerAttributes(physical: 76, technical: 62, stamina: 84);
      final lo = SecondaryPositions.factorFor(
        PlayerPosition.lw,
        PlayerPosition.lb,
        just,
      );
      final hi = SecondaryPositions.factorFor(
        PlayerPosition.lw,
        PlayerPosition.lb,
        well,
      );
      expect(hi, greaterThan(lo));
      expect(hi, lessThanOrEqualTo(SecondaryPositions.maxFactor));
      expect(lo, greaterThanOrEqualTo(SecondaryPositions.minFactor));
    });

    test('a keeper has none, nor does anyone get a keeper place', () {
      for (var id = 1; id < 2000; id++) {
        expect(
          SecondaryPositions.of(_p(id: id, position: PlayerPosition.gk)),
          isEmpty,
        );
      }
      expect(SecondaryPositions.candidatesFor(PlayerPosition.gk), isEmpty);
      for (final pos in PlayerPosition.values) {
        expect(
          SecondaryPositions.candidatesFor(pos),
          isNot(contains(PlayerPosition.gk)),
        );
      }
    });
  });

  group('SecondaryPositions determinism', () {
    test('the same player gets the same secondaries every time', () {
      for (final p in outfield.take(500)) {
        final first = SecondaryPositions.of(p);
        // A fresh copy, as another session's read would build him.
        final again = SecondaryPositions.of(
          Player.fromJson(
            jsonDecode(jsonEncode(p.toJson())) as Map<String, Object?>,
          ),
        );
        expect(again, first);
        expect(
          SecondaryPositions.derive(p.id, p.position, p.attributes),
          first,
        );
      }
    });
  });

  group('SecondaryPositions override (a world pack pick)', () {
    test('a pick replaces the derived ones; an empty pick is none', () {
      final base = _p(id: _idWith(_p(id: 0), 1));
      expect(SecondaryPositions.of(base), hasLength(1));
      final none = base.copyWith(fixedSecondaries: const []);
      expect(SecondaryPositions.of(none), isEmpty);
      final picked = base.copyWith(
        fixedSecondaries: const [PlayerPosition.st, PlayerPosition.am],
      );
      expect(SecondaryPositions.of(picked).map((s) => s.position), [
        PlayerPosition.st,
        PlayerPosition.am,
      ]);
    });

    test('a pick keeps to the rules: two at most, no own place, no keeper', () {
      final p = _p(
        id: 7,
        fixed: const [
          PlayerPosition.lw,
          PlayerPosition.gk,
          PlayerPosition.st,
          PlayerPosition.st,
          PlayerPosition.am,
          PlayerPosition.cb,
        ],
      );
      expect(SecondaryPositions.of(p).map((s) => s.position), [
        PlayerPosition.st,
        PlayerPosition.am,
      ]);
      for (final s in SecondaryPositions.of(p)) {
        expect(
          s.factor,
          inInclusiveRange(
            SecondaryPositions.minFactor,
            SecondaryPositions.maxFactor,
          ),
        );
      }
    });
  });

  group('PositionFit with secondaries', () {
    final lw = _p(
      id: 1,
      physical: 74,
      technical: 66,
      stamina: 80,
      fixed: const [PlayerPosition.lb],
    );
    final plain = lw.copyWith(fixedSecondaries: const []);

    test('factor: a secondary plays almost as well, across lines', () {
      expect(PositionFit.factorFor(plain, PlayerPosition.lb), 0.60);
      final f = PositionFit.factorFor(lw, PlayerPosition.lb);
      expect(f, inInclusiveRange(0.92, 0.98));
      expect(PositionFit.factorFor(lw, PlayerPosition.lw), 1);
      // Anything else is as before.
      expect(PositionFit.factorFor(lw, PlayerPosition.cm), 0.80);
      expect(
        PositionFit.factor(
          PlayerPosition.lw,
          PlayerPosition.lb,
          secondaries: SecondaryPositions.of(lw),
        ),
        f,
      );
    });

    test('a secondary in his own line is never worse than without it', () {
      final st = lw.copyWith(fixedSecondaries: const [PlayerPosition.st]);
      expect(
        PositionFit.factorFor(st, PlayerPosition.st),
        greaterThanOrEqualTo(0.95),
      );
    });

    test('effectiveOverall and fitRank count it', () {
      expect(
        PositionFit.effectiveOverall(lw, PlayerPosition.lb),
        greaterThan(PositionFit.effectiveOverall(plain, PlayerPosition.lb)),
      );
      expect(PositionFit.fitRank(lw, PlayerPosition.lw), 2);
      expect(PositionFit.fitRank(lw, PlayerPosition.lb), 1);
      expect(PositionFit.fitRank(plain, PlayerPosition.lb), 0);
      expect(PositionFit.secondaryAt(lw, PlayerPosition.lb), isNotNull);
      expect(PositionFit.secondaryAt(lw, PlayerPosition.lw), isNull);
      expect(PositionFit.secondaryOf(lw).single.position, PlayerPosition.lb);
    });

    test('bySlotFit orders a secondary above an out-of-line man', () {
      final cm = _p(
        id: 3,
        position: PlayerPosition.cm,
        physical: 74,
        technical: 66,
        stamina: 80,
        fixed: const [],
      );
      final list = [cm, plain, lw]
        ..sort(PositionFit.bySlotFit(PlayerPosition.lb));
      expect(list.first, lw);
    });

    test('best eleven fields a secondary before a weaker natural', () {
      final f = Formation.values.firstWhere(
        (f) => f.positions.contains(PlayerPosition.lb),
      );
      final squad = <Player>[];
      var id = 100;
      for (final pos in f.positions) {
        // The natural left-back is clearly weaker than the winger.
        final weak = pos == PlayerPosition.lb;
        squad.add(
          _p(
            id: id++,
            position: pos,
            physical: weak ? 60 : 70,
            technical: weak ? 60 : 70,
            stamina: weak ? 60 : 70,
            fixed: const [],
          ),
        );
      }
      final star = _p(
        id: 999,
        physical: 84,
        technical: 76,
        stamina: 88,
        fixed: const [PlayerPosition.lb],
      );
      final noSecond = star.copyWith(fixedSecondaries: const []);
      final lbSlot = f.positions.indexOf(PlayerPosition.lb);
      expect(bestEleven(f, [...squad, star])[lbSlot], 999);
      expect(bestEleven(f, [...squad, noSecond])[lbSlot], isNot(999));
    });
  });
}
