# A player's trophy cabinet

**Date:** 2026-08-07
**Status:** approved design

## Problem

The game hands out individual trophies — Golden Ball, Golden Boot, Golden
Glove, a Team of the Tournament — and then loses them. They are computed inside
`tournament_awards.dart`, shown on that tournament's screen, and never seen
again. A player's own card lists caps, goals, clubs and form but not one honour
he has won, so a fifteen-year career reads exactly like a fifteen-year career
that won nothing.

And every award is tied to a tournament, which comes round every two years at
best. There is nothing that accumulates.

## Decisions

- Awards are **stored**, in a table of their own. Deriving them on demand would
  mean recomputing every past tournament each time a card is opened; a table is
  clean and fast, and the save wipe it costs is accepted.
- The selection logic moves out of the widget into a **pure domain service**, so
  the tournament screen and the cabinet ask the same question of the same code.
- **Player of the Year is world-wide.** A rival winning it has to sting, or the
  announcements are pointless.
- Team of the Tournament counts as an honour — eleven a time, and a line reading
  "Team of the Tournament ×3" is a career.

## Awards

```dart
enum AwardKind {
  goldenBall,        // best player of a finals
  goldenBoot,        // top scorer of a finals
  goldenGlove,       // best keeper of a finals
  teamOfTournament,  // one of the best XI of a finals
  playerOfYear,      // the world's best, that calendar year
  youngPlayerOfYear, // the world's best under-21, that calendar year
}
```

Each is chosen by a pure function over the same shape the awards screen already
reads — `TournamentLine`s carrying apps, goals, assists, mean rating and MOTMs.
The existing Golden Ball / Boot / Glove / XI rules move across unchanged so the
tournament screen's behaviour does not shift.

**Player of the Year** ranks the world's players for a calendar year on mean
rating, weighted by appearances so a man with three good games does not beat one
with fifteen, with goals and MOTMs as the tiebreak. `PlayerRatings` already
holds a row for every match played anywhere in the world, so this needs one new
query and no new data.

**Young Player of the Year** is the same computation over players under 21 —
the age the youth pyramid now defines.

## Storage

A new `PlayerHonours` table:

| column | |
| --- | --- |
| `careerId` | the save |
| `playerId` | who won it |
| `nationId` | who he won it for |
| `kind` | `AwardKind`, stored by name |
| `competition` | the competition's name, empty for the yearly awards |
| `year` | the year it was won |

Primary key `(careerId, kind, competition, year, playerId)`, so an award is
recorded once however many times the settling code runs — the same
write-once-by-key discipline the inbox uses.

Schema **40**, with a `from39To40` step that creates the table. Existing saves
do not survive it; that is accepted.

## When they are awarded

- **Tournament awards** when a finals settles, alongside the roll-of-honour
  entry the game already records.
- **The yearly awards** when a year turns, on the same tick that produces the
  squad-development report.

## The cabinet

A section on the player card, newest first, above the career record: the award,
the competition or year, and a small trophy glyph. A player with nothing shows
nothing — no empty state, because an empty cabinet is a statement of its own and
does not need a caption.

## Announcements

Player of the Year and Young Player of the Year each land as an inbox message
and a Y post when they are decided. A foreign winner is posted about too, so
someone else's trophy is something you hear about rather than something you have
to go looking for.

## Testing

- Each award picks the right winner from a known set of lines, and ties break
  the way the rules say.
- Player of the Year prefers a season of fifteen good games to three great ones.
- Young Player of the Year never picks a 21-year-old.
- An award is recorded once even if the settling code runs twice.
- The cabinet returns a player's honours newest first, and nothing for a player
  who has won nothing.
- The migration creates the table and a save opened at 40 keeps its data.

## Out of scope

Awards for playmakers and defenders (assists and clean sheets make them
derivable later, and they feed the same cabinet), club awards, a global
all-time awards leaderboard, and voting or shortlists.
