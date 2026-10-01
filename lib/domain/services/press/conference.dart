/// Why the season called a press conference.
enum ConferenceReason { bigWin, bigLoss, crisis, jobVerdict }

/// Whether the manager has opened a conference the season called.
enum ConferenceStatus { pending, held, skipped }

/// A press conference the season has called, as stored.
typedef PressConferenceRow = ({
  int id,
  int cycle,
  ConferenceReason reason,
  int fixtureId,
  DateTime triggeredOn, // the match date
  ConferenceStatus status,
});
