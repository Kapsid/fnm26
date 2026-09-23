/// Flags that put a TESTING AID into the app.
///
/// Everything declared here exists for the bench, not for the manager, and
/// every one of them is one edit from gone: flip the constant to `false` and
/// the aid is absent from the build, with nothing else to remember. Each flag
/// names, in its own doc, what turning it off takes away.
///
/// They live together in one file for a reason. The last aid that shipped by
/// accident was `premiumUnlockedProvider`, defaulted to `true` for months
/// behind a comment asking someone to flip it back; nobody did, and the paywall
/// stood open. A comment is not a switch. A named constant everything reads,
/// in a file called this, is.
library;

/// Whether the live match screen offers the skip-to-full-time control: the pill
/// on the match control bar that jumps the clock to the final whistle.
///
/// A testing aid, so a match can be moved through quickly rather than watched.
/// It is NOT how the game is meant to be played: a match the manager opened is
/// a match he watches, and simulating one without watching it is what the hub
/// offers, before the match is opened.
///
/// Setting this to `false` removes the pill from the control bar; the screen
/// then passes no skip callback at all and nothing else changes. The shootout
/// taker sheet is asked by the clock either way, so turning the aid off cannot
/// leave a manager un-asked.
const bool kShowSkipMatch = false;

/// Whether the paywall prints the reason the store gave, under the
/// "Store unavailable" note.
///
/// A testing aid for a build that cannot yet buy anything. "Store unavailable"
/// is one message covering three unrelated failures — the device has no store,
/// the store answered with an error, or the product id simply is not
/// configured — and on a TestFlight build the only way to tell them apart is
/// to be told. The line is deliberately technical, carries the product id, and
/// is NOT translated: it is a note to the bench, not copy for a manager.
///
/// Setting this to `false` removes the line; the note above it and the "Try
/// again" button stay, which is the whole of what a real player is meant to
/// see.
const bool kShowStoreDiagnostics = true;
