import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/squad/youth_watch_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fixtures.dart';

/// The marks live in preferences, keyed per career, and they have to survive
/// closing the app. This is that promise, plus the reading each mark carries:
/// the whole shortlist is measured against what a boy was on the day he caught
/// the eye, so a second mark must never overwrite the first.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  ProviderContainer container() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  test('a mark carries what the boy was when he was marked', () async {
    final store = container().read(youthWatchStoreProvider);
    final lad = player(id: 42, nationId: 1, name: 'Novák', age: 14);
    await store.mark(7, lad, 3);

    final marks = await loadYouthMarks(7);
    expect(marks, hasLength(1));
    expect(marks.single.playerId, 42);
    expect(marks.single.name, 'Novák');
    expect(marks.single.rating, lad.overall);
    expect(marks.single.age, 14);
    expect(marks.single.year, 3);
  });

  test('marking a boy twice keeps the FIRST reading', () async {
    final store = container().read(youthWatchStoreProvider);
    await store.mark(7, playerWithOverall(50, id: 42), 3);
    await store.mark(7, playerWithOverall(70, id: 42), 6);

    final marks = await loadYouthMarks(7);
    expect(marks, hasLength(1));
    expect(
      marks.single.rating,
      50,
      reason: 'the mark is the reading the movement is measured against',
    );
    expect(marks.single.year, 3);
  });

  test('unmarking takes him off and leaves the others alone', () async {
    final store = container().read(youthWatchStoreProvider);
    await store.mark(7, playerWithOverall(50, id: 1), 1);
    await store.mark(7, playerWithOverall(55, id: 2), 1);
    await store.unmark(7, 1);

    expect((await loadYouthMarks(7)).map((m) => m.playerId), [2]);
  });

  test('toggle marks a boy who is not marked and unmarks one who is', () async {
    final store = container().read(youthWatchStoreProvider);
    final lad = playerWithOverall(50, id: 1);
    await store.toggle(7, lad, 1);
    expect(await loadYouthMarks(7), hasLength(1));
    await store.toggle(7, lad, 1);
    expect(await loadYouthMarks(7), isEmpty);
  });

  test('two careers do not share a watchlist', () async {
    final store = container().read(youthWatchStoreProvider);
    await store.mark(7, playerWithOverall(50, id: 1), 1);
    await store.mark(8, playerWithOverall(55, id: 2), 1);

    expect((await loadYouthMarks(7)).map((m) => m.playerId), [1]);
    expect((await loadYouthMarks(8)).map((m) => m.playerId), [2]);
  });

  test('unreadable preferences are an empty list, not a crash', () async {
    SharedPreferences.setMockInitialValues({
      'youth_watchlist_v1:7': 'not json at all',
    });
    expect(await loadYouthMarks(7), isEmpty);

    SharedPreferences.setMockInitialValues({
      'youth_watchlist_v1:7': '[{"no":"id here"},{"i":5,"n":"Kept"}]',
    });
    final marks = await loadYouthMarks(7);
    expect(marks, hasLength(1), reason: 'a junk entry must not lose the rest');
    expect(marks.single.name, 'Kept');
  });
}
