/// Deterministic phrasing variety for generated flavour text (the inbox, news
/// blurbs, elimination notices). Keeps a long save from reprinting the exact
/// same sentence every cycle, while staying stable across rebuilds of the same
/// event so a message never changes wording under the player.
library;

/// A stable non-negative FNV-1a hash of [s] — used to seed [pickVariant].
int varietySeed(String s) {
  var h = 0x811c9dc5;
  for (final c in s.codeUnits) {
    h = ((h ^ c) * 0x01000193) & 0x7fffffff;
  }
  return h & 0x7fffffff;
}

/// Picks one phrasing from [options] deterministically from [seed].
///
/// Generic, because a phrasing is not always a String any more: a message
/// stored as MEANING picks between `MsgText`s (see `core/util/message_text.dart`)
/// and must pick the same one for the same event, whatever language it is later
/// read in.
T pickVariant<T>(List<T> options, int seed) => options[seed % options.length];
