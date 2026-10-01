/// What the manager can put on the record at a press conference.
enum StatementKind { winNext, jobOnTheLine, backPlayer, blamePlayer }

/// Where a statement stands: waiting on its window, or judged by what followed.
enum StatementStatus { open, kept, broken, lapsed }

/// A promise or a verdict the manager gave the press, kept so that what
/// happens next can be held against it.
typedef PressStatement = ({
  int id,
  int cycle,
  int nationId,
  StatementKind kind,
  int? playerId,
  DateTime madeOn, // the date of the match the conference was about
  int madeAfterFixtureId,
  StatementStatus status,
  DateTime? judgedOn,
  bool thrownBack,
});
