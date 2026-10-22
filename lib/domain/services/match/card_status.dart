import 'package:fnm/domain/services/match/match_engine.dart';

/// The card a player is carrying in a match: one booking, a second booking
/// that sent him off, or a straight red.
enum MatchCard {
  yellow,
  secondYellow,
  red;

  /// Whether this card has ended his match.
  bool get sentOff => this != MatchCard.yellow;
}

/// The card each of [nationId]'s players is carrying at [upToMinute], read
/// straight off the match [events].
///
/// The one answer every in-match screen draws — the pitch, the substitution
/// lists, the sent-off set the editor plays a man short with — so a booked
/// man can never wear his card in one place and not in the next. Derived
/// rather than accumulated, so it survives the re-simulation a tactical change
/// triggers. A red outranks the booking that came before it whatever order
/// the events arrive in.
Map<int, MatchCard> cardStatusFor(
  Iterable<MatchEvent> events, {
  required int nationId,
  required int upToMinute,
}) {
  final out = <int, MatchCard>{};
  for (final e in events) {
    if (e.teamNationId != nationId || e.minute > upToMinute) continue;
    switch (e.type) {
      case MatchEventType.yellowCard:
        out.putIfAbsent(e.playerId, () => MatchCard.yellow);
      case MatchEventType.redCard:
        out[e.playerId] = e.secondYellow
            ? MatchCard.secondYellow
            : MatchCard.red;
      case MatchEventType.goal ||
          MatchEventType.substitution ||
          MatchEventType.injury:
        break;
    }
  }
  return out;
}
