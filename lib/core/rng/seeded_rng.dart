/// A small, fast, fully deterministic pseudo-random number generator.
///
/// The entire match-simulation engine is driven by this class so that a given
/// (save seed, fixture id) pair always reproduces the exact same match. That
/// determinism is what makes the engine unit-testable and replay-safe, and it
/// keeps simulated results consistent across devices and cloud restores.
///
/// Implementation is the **mulberry32** algorithm: a 32-bit-state generator
/// with good statistical quality for game purposes. 32-bit arithmetic is used
/// throughout so results are identical on every platform (native and web).
class SeededRng {
  /// Creates a generator from a raw 32-bit [seed].
  SeededRng(int seed) : _state = seed & _mask32;

  /// Derives a generator for a single fixture from the save-level [saveSeed].
  ///
  /// Mixing in [fixtureId] means every fixture in a save has its own
  /// reproducible stream, while the whole save stays reproducible from one
  /// stored seed.
  factory SeededRng.forFixture(int saveSeed, int fixtureId) {
    final mixed = (saveSeed ^ ((fixtureId + 1) * 0x9E3779B1)) & _mask32;
    return SeededRng(mixed);
  }

  static const int _mask32 = 0xFFFFFFFF;

  int _state;

  /// The current internal state, for persisting/restoring a stream mid-run.
  int get state => _state;

  /// Restores a previously captured [state].
  set state(int value) => _state = value & _mask32;

  /// Returns the next double in the half-open range `[0, 1)`.
  double nextDouble() {
    _state = (_state + 0x6D2B79F5) & _mask32;
    var t = _state;
    t = (t ^ (t >>> 15)) * (t | 1) & _mask32;
    t ^= t + (t ^ (t >>> 7)) * (t | 61) & _mask32;
    t = (t ^ (t >>> 14)) & _mask32;
    return t / 4294967296.0;
  }

  /// Returns an int in the half-open range `[0, max)`. [max] must be positive.
  int nextInt(int max) {
    assert(max > 0, 'max must be positive');
    return (nextDouble() * max).floor();
  }

  /// Returns an int in the inclusive range `[min, max]`.
  int rangeInt(int min, int max) {
    assert(max >= min, 'max must be >= min');
    return min + nextInt(max - min + 1);
  }

  /// Returns a double in the half-open range `[min, max)`.
  double rangeDouble(double min, double max) {
    assert(max >= min, 'max must be >= min');
    return min + nextDouble() * (max - min);
  }

  /// Returns `true` with the given [probability] (clamped to `[0, 1]`).
  bool chance(double probability) => nextDouble() < probability.clamp(0.0, 1.0);

  /// Returns a uniformly random element from a non-empty [items] list.
  T pick<T>(List<T> items) {
    assert(items.isNotEmpty, 'cannot pick from an empty list');
    return items[nextInt(items.length)];
  }

  /// Returns a new shuffled copy of [items] (Fisher–Yates), leaving the
  /// original untouched.
  List<T> shuffled<T>(List<T> items) {
    final copy = List<T>.of(items);
    for (var i = copy.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final tmp = copy[i];
      copy[i] = copy[j];
      copy[j] = tmp;
    }
    return copy;
  }
}
