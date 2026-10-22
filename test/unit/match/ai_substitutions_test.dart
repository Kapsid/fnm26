import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/match/ai_substitutions.dart';

import '../../helpers/fixtures.dart';

void main() {
  final xi = [
    for (var i = 0; i < 11; i++)
      player(
        id: 100 + i,
        nationId: 1,
        position: Formation.f433.positions[i],
        attributes: flatAttributes(70),
      ),
  ];
  final bench = [
    for (var i = 0; i < 7; i++)
      player(
        id: 200 + i,
        nationId: 1,
        position: PlayerPosition.values[(i + 1) % PlayerPosition.values.length],
        attributes: flatAttributes(66),
      ),
  ];

  test('plans 2-3 subs within the second-half window', () {
    final subs = AiSubstitutions.plan(
      nationId: 1,
      xi: xi,
      bench: bench,
      rng: SeededRng.forFixture(9, 3),
    );
    expect(subs.length, inInclusiveRange(2, 3));
    expect(subs.every((s) => s.minute >= 58 && s.minute <= 82), isTrue);
    expect(subs.every((s) => s.teamNationId == 1), isTrue);
    // Minutes are non-decreasing (subs don't stack out of order).
    for (var i = 1; i < subs.length; i++) {
      expect(subs[i].minute, greaterThanOrEqualTo(subs[i - 1].minute));
    }
  });

  test('never subs off the goalkeeper and never reuses a bench player', () {
    final subs = AiSubstitutions.plan(
      nationId: 1,
      xi: xi,
      bench: bench,
      rng: SeededRng.forFixture(4, 1),
    );
    final gkId = xi.firstWhere((p) => p.position == PlayerPosition.gk).id;
    expect(subs.any((s) => s.offId == gkId), isFalse);
    expect(subs.any((s) => s.on.position == PlayerPosition.gk), isFalse);
    final onIds = subs.map((s) => s.on.id).toList();
    final offIds = subs.map((s) => s.offId).toList();
    expect(onIds.toSet(), hasLength(onIds.length));
    expect(offIds.toSet(), hasLength(offIds.length));
  });

  test('deterministic for the same seed', () {
    List<String> keys(SeededRng rng) => AiSubstitutions.plan(
      nationId: 1,
      xi: xi,
      bench: bench,
      rng: rng,
    ).map((s) => '${s.minute}:${s.offId}:${s.on.id}').toList();
    expect(keys(SeededRng.forFixture(7, 2)), keys(SeededRng.forFixture(7, 2)));
  });

  test('an empty bench yields no subs', () {
    final subs = AiSubstitutions.plan(
      nationId: 1,
      xi: xi,
      bench: const [],
      rng: SeededRng.forFixture(1, 1),
    );
    expect(subs, isEmpty);
  });
  group('extra time', () {
    test('one sub at minute 91, never the keeper, fresh legs only', () {
      for (var seed = 0; seed < 50; seed++) {
        final sub = AiSubstitutions.planExtraTime(
          nationId: 1,
          onPitchAt90: xi,
          bench: bench,
          rng: SeededRng(seed ^ 0x5196),
        )!;
        expect(sub.minute, 91);
        expect(sub.teamNationId, 1);
        expect(xi.map((p) => p.id), contains(sub.offId));
        expect(bench.map((p) => p.id), contains(sub.on.id));
        expect(sub.on.position, isNot(PlayerPosition.gk));
        final gkId = xi.firstWhere((p) => p.position == PlayerPosition.gk).id;
        expect(sub.offId, isNot(gkId));
      }
    });

    test('deterministic for the same seed', () {
      String key(int seed) {
        final s = AiSubstitutions.planExtraTime(
          nationId: 1,
          onPitchAt90: xi,
          bench: bench,
          rng: SeededRng(seed ^ 0x5196),
        )!;
        return '${s.minute}:${s.offId}:${s.on.id}';
      }

      expect(key(17), key(17));
    });

    test('no fresh outfield legs means no sub', () {
      final keeperOnly = bench
          .where((p) => p.position == PlayerPosition.gk)
          .toList();
      expect(
        AiSubstitutions.planExtraTime(
          nationId: 1,
          onPitchAt90: xi,
          bench: keeperOnly,
          rng: SeededRng(1),
        ),
        isNull,
      );
    });
  });
}
