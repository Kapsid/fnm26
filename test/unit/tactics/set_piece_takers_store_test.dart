import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The quick pick names both takers at once, which is one write and not two:
/// [SetPieceTakersStore.set] re-reads the stored pair to keep the other half,
/// so two of those racing each other can drop the first man named.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  ProviderContainer container() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  test('nothing named reads as automatic on both duties', () async {
    final store = container().read(setPieceTakersStoreProvider);
    expect(await store.load(1), (penalty: null, deadBall: null));
  });

  test('the quick pick names both men in one write', () async {
    final store = container().read(setPieceTakersStoreProvider);

    await store.setBoth(1, penalty: 7, deadBall: 4);

    expect(await store.load(1), (penalty: 7, deadBall: 4));
  });

  test('the quick pick replaces a pair already stored', () async {
    final store = container().read(setPieceTakersStoreProvider);

    await store.setBoth(1, penalty: 2, deadBall: 3);
    await store.setBoth(1, penalty: 7, deadBall: 4);

    // One write, both halves: setBoth does not re-read the stored pair to keep
    // the other side of it the way [SetPieceTakersStore.set] must, so there is
    // no read for a second call to race.
    expect(await store.load(1), (penalty: 7, deadBall: 4));
  });

  test(
    'a later single change keeps the other half of the quick pick',
    () async {
      final store = container().read(setPieceTakersStoreProvider);

      await store.setBoth(1, penalty: 7, deadBall: 4);
      await store.set(1, penalty: true, playerId: 9);

      expect(await store.load(1), (penalty: 9, deadBall: 4));
    },
  );

  test('clearing one duty leaves it automatic and the other named', () async {
    final store = container().read(setPieceTakersStoreProvider);

    await store.setBoth(1, penalty: 7, deadBall: 4);
    await store.set(1, penalty: true, playerId: null);

    expect(await store.load(1), (penalty: null, deadBall: 4));
  });

  test('a write reaches the provider the screens watch', () async {
    // Kept alive: the provider is autoDispose, and a bare read would drop it
    // and recompute on the next one whether or not the write invalidated it,
    // which is precisely what this is asking about.
    final c = container()..listen(setPieceTakersProvider(1), (_, _) {});
    expect(await c.read(setPieceTakersProvider(1).future), (
      penalty: null,
      deadBall: null,
    ));

    await c
        .read(setPieceTakersStoreProvider)
        .setBoth(
          1,
          penalty: 7,
          deadBall: 4,
        );

    // The store used to invalidate a provider that depended on it, which
    // Riverpod calls circular: in a debug build the write landed in the prefs
    // and the screen was never told, so naming a taker looked like it did
    // nothing at all.
    expect(await c.read(setPieceTakersProvider(1).future), (
      penalty: 7,
      deadBall: 4,
    ));
  });

  test("one career's takers are not another's", () async {
    final store = container().read(setPieceTakersStoreProvider);

    await store.setBoth(1, penalty: 7, deadBall: 4);

    expect(await store.load(2), (penalty: null, deadBall: null));
  });
}
