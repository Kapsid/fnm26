import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/services/press/expectation.dart';

/// What sort of account this is, beyond which KIND of account it is.
///
/// [YVoice] says a fan is posting. It never said what sort of fan, which is
/// why the feed had eight voices and one personality: swap the handles around
/// and nothing read differently. A trait is what makes the same afternoon draw
/// a shrug from one account and a threat from another.
enum YTrait {
  /// Backs the side whatever happens. Slow to turn, quick to forgive.
  loyalist,

  /// Assumes the worst and is delighted to be proved right.
  cynic,

  /// Everything was better before. Measures you against people who retired.
  nostalgic,

  /// Cares about the numbers and nothing else. Barely has a mood.
  statshead,

  /// Two good results and it is a golden generation.
  hypeman,

  /// Whatever the room thinks, the opposite.
  contrarian,

  /// It is going to go wrong. It is always going to go wrong.
  doomer,
}

/// One recurring account: a name that comes back all career, and the
/// disposition behind it.
typedef YPersona = ({String handle, String displayName, YTrait trait});

/// How warmly a post is worded, independent of what it is about.
///
/// The same event, read three ways. This is what the extra phrasings are FOR:
/// without it, twelve wordings of "we lost" is just twelve ways to say the
/// same thing in the same tone of voice.
enum YTone { generous, neutral, sour }

/// The cast, and how it feels about you.
///
/// Nothing here is stored. Every persona is derived from the nation and the
/// save seed, and every stance from the run of results the feed is already
/// walking — so scrolling back a year shows the account that had turned on you
/// then, still turned on you, saying what it said. A stored stance would show
/// today's opinion under a post from 2031.
abstract final class YCast {
  /// How many recurring accounts a nation has per voice.
  ///
  /// Small on purpose. The feed used to draw a fresh name out of a list of
  /// seven for every single post, so nobody ever appeared twice and the
  /// country had no faces in it. Three is enough to not feel like one person
  /// and few enough that the manager learns who they are.
  static const int castSize = 3;

  /// The recurring cast for one voice in one save.
  static List<YPersona> of(
    List<String> names, {
    required String nation,
    required int seed,
    required String voiceKey,
  }) {
    if (names.isEmpty) return const [];
    final base = varietySeed('$nation|$voiceKey') ^ seed;
    final take = names.length < castSize ? names.length : castSize;
    return [
      for (var i = 0; i < take; i++)
        () {
          final name = names[(base + i * _stride) % names.length];
          return (
            handle: '@$name',
            displayName: name,
            trait: traitFor(name),
          );
        }(),
    ];
  }

  /// What sort of account somebody called [name] is.
  ///
  /// The trait travels with the NAME, not with the slot it was drawn into, so
  /// an account called LongSufferingLen is a doomer in every save he turns up
  /// in — which is the difference between a cast and a shuffle.
  ///
  /// Public because the PROFILE needs it too, and needs it to agree with the
  /// feed. Nothing about a persona is stored, so a screen showing a post from
  /// 2031 re-derives its author's disposition from the one thing the post
  /// carries: the name above it. Deriving it twice from the same name is what
  /// makes the account read the same in 2031 as it did in 2027; a second copy
  /// of this arithmetic somewhere else would be a second answer waiting to
  /// drift.
  static YTrait traitFor(String name) =>
      YTrait.values[varietySeed('trait|$name') % YTrait.values.length];

  /// A prime-ish stride so a cast of three is spread across the name list
  /// rather than being three consecutive entries.
  static const int _stride = 3;

  /// Which of [cast] is posting about [key]. Stable for an event, so a rebuild
  /// of the feed puts the same person under the same match.
  static YPersona? pick(List<YPersona> cast, String key) =>
      cast.isEmpty ? null : cast[varietySeed(key) % cast.length];

  /// How this persona currently rates the manager, −100 … 100.
  ///
  /// [history] is the run of results so far, oldest first. Each is worth its
  /// [Expectation.weight], scaled by how much this sort of account lets a
  /// result move them and decayed so the recent past dominates — a feed is a
  /// mob with a short memory, not a ledger.
  static int stance(YPersona p, List<ResultStanding> history) {
    if (history.isEmpty) return _baseline(p.trait);
    var score = 0.0;
    var weightSum = 0.0;
    // Newest last, so walk backwards and decay as we go.
    for (var i = 0; i < history.length; i++) {
      final age = history.length - 1 - i;
      if (age > _memory) continue;
      final w = _decayAt(age);
      score += Expectation.weight(history[i]) * w;
      weightSum += w;
    }
    if (weightSum == 0) return _baseline(p.trait);
    // −2 … +2 becomes −100 … 100, then bent by who is reading it.
    final avg = score / weightSum;
    final moved = avg * 50 * _swing(p.trait);
    return (_baseline(p.trait) + moved).round().clamp(-100, 100);
  }

  /// How many results back anybody remembers.
  static const int _memory = 8;

  static double _decayAt(int age) {
    var w = 1.0;
    for (var i = 0; i < age; i++) {
      w *= _decay;
    }
    return w;
  }

  static const double _decay = 0.72;

  /// Where a trait sits before a ball is kicked.
  static int _baseline(YTrait t) => switch (t) {
    YTrait.loyalist => 35,
    YTrait.hypeman => 20,
    YTrait.nostalgic => -15,
    YTrait.cynic => -25,
    YTrait.doomer => -40,
    YTrait.contrarian => 0,
    YTrait.statshead => 0,
  };

  /// How far a run of results can move this sort of account.
  static double _swing(YTrait t) => switch (t) {
    // A hypeman is all swing and a statshead is nearly none: the numbers desk
    // reports a humiliation in the same voice it reports a win.
    YTrait.hypeman => 1.5,
    YTrait.doomer => 1.2,
    YTrait.cynic => 1.1,
    YTrait.contrarian => 0.9,
    YTrait.nostalgic => 0.7,
    YTrait.loyalist => 0.6,
    YTrait.statshead => 0.2,
  };

  /// How warmly this persona words a post about a result of [standing].
  ///
  /// Both halves matter. A loyalist calls a defeat unlucky; a doomer calls the
  /// same defeat the end. But a run of humiliations turns even the loyalist,
  /// which is what makes the feed feel like it is watching rather than
  /// reciting.
  static YTone toneFor(YPersona p, ResultStanding standing, int stance) {
    if (p.trait == YTrait.statshead) return YTone.neutral;
    // A contrarian reads the room and takes the other side of it — the one
    // trait whose tone is decided by everyone else's.
    final reading = p.trait == YTrait.contrarian
        ? -Expectation.weight(standing)
        : Expectation.weight(standing);
    // WHO is talking decides the tone; WHAT happened only leans on it.
    //
    // The other way round looks obvious and is wrong, because the template
    // already carries what happened: a shock win is only ever filed as
    // winUpset. Letting the result dominate the tone as well meant winUpset
    // was always worded generously, its sour phrasings could not be reached
    // by anybody, and each template collapsed onto a single band — fewer
    // sentences in play than before the bands existed. The disposition leads,
    // so the cynic can be grudging about a triumph and the loyalist measured
    // about a hammering.
    final mood = stance * _stanceWeight + reading * _resultWeight;
    if (mood >= _generousAt) return YTone.generous;
    if (mood <= _sourAt) return YTone.sour;
    return YTone.neutral;
  }

  /// How much a standing opinion decides the wording.
  static const double _stanceWeight = 0.8;

  /// And how much the afternoon itself leans on it.
  static const double _resultWeight = 10;

  static const double _generousAt = 18;
  static const double _sourAt = -18;

  /// The slice of a template's phrasings that carries [tone].
  ///
  /// Variants are written in tone order — the generous ones first, the sour
  /// ones last — so a tone is a contiguous third of the range and a template
  /// can be deepened later without renumbering anything.
  static (int offset, int size) band(YTone tone, int total) {
    if (total < 3) return (0, total);
    final size = total ~/ 3;
    return switch (tone) {
      YTone.generous => (0, size),
      YTone.neutral => (size, size),
      // The last band takes the remainder, so a total that does not divide by
      // three loses nothing.
      YTone.sour => (size * 2, total - size * 2),
    };
  }

  /// The variant [key] draws, within the band [tone] allows.
  static int variantFor({
    required String key,
    required YTone tone,
    required int total,
  }) {
    final (offset, size) = band(tone, total);
    if (size <= 0) return 0;
    return offset + varietySeed(key) % size;
  }
}
