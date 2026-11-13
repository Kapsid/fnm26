import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ordered set-piece takers (1.1.2): the stored JSON grew from a pair to four
/// lists. Every save and preference written before must read back as it
/// played, and what is written now must still carry the pair's two keys.
void main() {
  ProviderContainer container() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  group('the old pair', () {
    test('reads back as one-man orders on every duty it covered', () async {
      SharedPreferences.setMockInitialValues({
        'set_piece_takers_v1:1': jsonEncode({'penalty': 7, 'deadBall': 4}),
      });
      final t = await container().read(setPieceTakersStoreProvider).load(1);
      expect(t.penalties, [7]);
      expect(t.freeKicks, [4]);
      expect(t.cornersLeft, [4]);
      expect(t.cornersRight, [4]);
      expect(t.penalty, 7);
      expect(t.deadBall, 4);
    });

    test('a half-named pair keeps the other half automatic', () async {
      SharedPreferences.setMockInitialValues({
        'set_piece_takers_v1:1': jsonEncode({'penalty': null, 'deadBall': 4}),
      });
      final t = await container().read(setPieceTakersStoreProvider).load(1);
      expect(t.penalties, isEmpty);
      expect(t.freeKicks, [4]);
    });

    test('ids stored as strings still read', () async {
      SharedPreferences.setMockInitialValues({
        'set_piece_takers_v1:1': jsonEncode({'penalty': '7', 'deadBall': '4'}),
      });
      final t = await container().read(setPieceTakersStoreProvider).load(1);
      expect(t, SetPieceOrder.single(penalty: 7, deadBall: 4));
    });

    test('garbage reads as automatic', () async {
      SharedPreferences.setMockInitialValues({
        'set_piece_takers_v1:1': 'not json',
      });
      final t = await container().read(setPieceTakersStoreProvider).load(1);
      expect(t, SetPieceOrder.none);
    });
  });

  group('the new shape', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('round-trips every order', () async {
      final store = container().read(setPieceTakersStoreProvider);
      const order = SetPieceOrder(
        penalties: [9, 7, 5],
        freeKicks: [4, 9],
        cornersLeft: [4, 8],
        cornersRight: [8],
      );
      await store.save(1, order);
      expect(await store.load(1), order);
    });

    test(
      'keeps the pair keys, so the old reader sees the first choices',
      () async {
        final store = container().read(setPieceTakersStoreProvider);
        await store.save(
          1,
          const SetPieceOrder(
            penalties: [9, 7],
            freeKicks: [4],
            cornersLeft: [8],
          ),
        );
        final prefs = await SharedPreferences.getInstance();
        final map =
            jsonDecode(prefs.getString('set_piece_takers_v1:1')!) as Map;
        expect(map['penalty'], 9);
        expect(map['deadBall'], 4);
      },
    );

    test('cuts each order to its length and to one entry per man', () {
      final t = SetPieceOrder.fromJson({
        'penalties': [1, 2, 2, 3, 4],
        'cornersLeft': [5, 6, 7],
      });
      expect(t.penalties, [1, 2, 3]);
      expect(t.cornersLeft, [5, 6]);
      expect(t.freeKicks, isEmpty);
      expect(t.cornersRight, isEmpty);
    });

    test('one duty changes alone', () async {
      final store = container().read(setPieceTakersStoreProvider);
      await store.setBoth(1, penalty: 7, deadBall: 4);
      await store.setDuty(1, SetPieceDuty.cornersRight, [8, 4]);
      final t = await store.load(1);
      expect(t.penalties, [7]);
      expect(t.freeKicks, [4]);
      expect(t.cornersLeft, [4]);
      expect(t.cornersRight, [8, 4]);
    });

    test('keepOnly drops men who left the eleven, the order kept', () async {
      final store = container().read(setPieceTakersStoreProvider);
      await store.save(
        1,
        const SetPieceOrder(penalties: [9, 7, 5], freeKicks: [7, 4]),
      );
      await store.keepOnly(1, {5, 4, 9});
      final t = await store.load(1);
      expect(t.penalties, [9, 5]);
      expect(t.freeKicks, [4]);
    });
  });
}
