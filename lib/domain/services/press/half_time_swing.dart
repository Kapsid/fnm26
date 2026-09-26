/// A match the second half turned over: the half-time score said one thing and
/// the full-time score said the opposite.
///
/// Two goals is the bar because two goals is the point at which a lead stops
/// being a scoreline and starts being a position. A side that leads by one and
/// draws has had an afternoon; a side that leads by two and loses has thrown
/// something away, and everyone watching knows it.
enum HalfTimeSwing {
  /// Two or more behind at the break, and it finished level or won.
  comeback,

  /// Two or more ahead at the break, and it finished level or lost.
  collapse,
}

/// The minute a first half is over by.
const int halfTimeMinute = 45;

/// How many goals make a half-time score a position rather than a number.
const int swingMargin = 2;

/// Which way [nationId]'s match swung, or null if it did not.
///
/// [goals] is the match's goal timeline — the only record of how a result got
/// to where it finished, since the fixture row keeps the final score and
/// nothing about the road to it. [scored] and [conceded] are that final score,
/// from [nationId]'s side.
///
/// Read by the press room and by the feed, from one definition, so the
/// conference and the country cannot disagree about whether an afternoon was a
/// turnaround.
HalfTimeSwing? halfTimeSwingOf({
  required Iterable<({int nationId, int playerId, int minute})> goals,
  required int nationId,
  required int scored,
  required int conceded,
}) {
  var mine = 0;
  var theirs = 0;
  for (final g in goals) {
    if (g.minute > halfTimeMinute) continue;
    if (g.nationId == nationId) {
      mine++;
    } else {
      theirs++;
    }
  }
  final atBreak = mine - theirs;
  final atEnd = scored - conceded;
  if (atBreak <= -swingMargin && atEnd >= 0) return HalfTimeSwing.comeback;
  if (atBreak >= swingMargin && atEnd <= 0) return HalfTimeSwing.collapse;
  return null;
}
