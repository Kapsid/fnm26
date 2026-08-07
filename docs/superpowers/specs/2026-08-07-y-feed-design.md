# Y — the social feed

**Date:** 2026-08-07
**Status:** approved design

## Problem

The world plays on without ever talking. Results, draws, hosts, records and
retirements all happen, and the only voice that responds is the inbox — a
private, formal channel from the federation. Nobody is delighted, nobody is
furious, and a manager never learns what the country thinks of him except
through a board gauge.

Y is that missing public voice: a Twitter-shaped feed the world writes about
you.

## Decisions

- **Read-only.** Press conferences already give the manager a voice with real
  consequences. Y is where he is talked *about*.
- **It bites.** Public mood feeds the board — see the overlap section, which is
  the part of this design that can go wrong.
- **A fifth bottom-nav tab**, beside hub, squad, competitions and careers.
- **Derived, never stored.** Posts are a pure function of events the world has
  already recorded, exactly as players are a pure function of seeds and years.

## The feed

Newest first, capped at the most recent 60 posts so a long save does not build
an unbounded list. Each post carries an author, a template with its arguments, and the in-game
date of the event that produced it. It carries a TEMPLATE rather than a finished
string because the words are localised at render — the same reason the squad
report encodes structure and lets the sheet do the wording.

```dart
enum YVoice { pundit, fan, rival, stats }

typedef YPost = ({
  YVoice voice,
  String handle,      // '@' name, stable for a given author
  String displayName,
  YTemplate template, // WHAT is said; the words are chosen at render
  List<String> args,  // the nouns it needs: opponent, score, a player's name
  DateTime date,
  String key,         // the event that produced it; stable across rebuilds
});
```

**The voices**, each with its own register:

- **Pundit** — named and persistent. The same ex-player recurs across a career,
  drawn deterministically from the nation, so a manager comes to know his
  critics.
- **Fan** — of the manager's nation. Delighted, furious, fickle.
- **Rival** — a supporter of whoever just beat you, or of a neighbour enjoying
  your misfortune.
- **Stats** — an account that posts numbers and nothing else. It is never
  pleased or annoyed, which is what makes it useful.

**What they react to:** match results, qualification and elimination,
tournament outcomes, draws, host announcements, an upcoming tournament, the
manager's squad announcement, records and milestones, retirements, ranking
moves, and the academy intake.

## How posts are made

A pure function from the world's recent events to a list of posts. Author and
phrasing are chosen deterministically from the event's own key through the
existing `varietySeed` / `pickVariant` helpers in `lib/core/util/text_variety.dart`,
so scrolling back a year shows the same posts it showed then. No table, no
migration, nothing to keep in sync.

Each event yields between zero and three posts depending on how much there is
to say: a routine win against a weaker side might draw one flat line from the
stats account, while a humiliation draws a pundit, two furious fans and a rival.

## Public mood, and the overlap trap

Fan mood must **not** be a second copy of the board's form term. The board
already weighs recent results heavily; a mood derived the same way would simply
double-weight them and make the gauge twice as jumpy for no new information.

So mood measures something the board does not see: **expectation versus
reality**. Every result is scored against the ranking gap between the two
nations. Beating a side far above you thrills the public out of proportion to
the single point it earns; grinding past a minnow moves them not at all; losing
to one is a catastrophe the league table alone would call a minor setback. The
public is also short-memoried and volatile where the board is slow and
objective-driven, so its window is shorter.

`PublicMood.of(...)` returns 0–100, neutral at 50.

**The board hook.** `BoardSatisfaction.compute` gains an optional
`publicMood`, contributing a term sized like the existing ranking bonus —
roughly ±5 points at the extremes. **A neutral mood of 50 must contribute
exactly zero**, so the board's current behaviour is provably unchanged when the
public has no opinion. That is the guard test.

This is the part of the design most likely to need tuning after play. It is
deliberately small for that reason: two systems tuned at once is how both end up
wrong.

## Placement

`AppTab` gains a fifth member and `AppBottomNav` a fifth destination. The nav
bar is already tight on a narrow phone, so the labels stay short and the layout
is checked at the smallest supported width — there is an existing
`layout_regression_test.dart` for exactly this class of problem, and Y's tab
belongs in it.

## Localisation

Every post template needs an English and a Czech string through `gen_l10n`.
This is the bulk of the work and it caps how many variants are sensible: four to
six phrasings per event type, which is enough that a save does not repeat itself
quickly without becoming a translation project.

Templates take placeholders (nation names, scores, player names) rather than
being assembled from fragments, because fragment assembly does not survive
translation into a language with cases — and Czech has seven.

## Testing

- The same event always produces the same posts: same authors, same wording.
- Every event type produces at least one post.
- The feed is capped at 60 and ordered newest first.
- A pundit's identity is stable across a career for a given nation.
- Public mood rises on an upset win and falls on a humiliation, and does **not**
  move much for a routine win over a much weaker side.
- **The board guard:** `BoardSatisfaction.compute` with `publicMood: 50` returns
  exactly what it returns with no mood at all, and the extremes shift it by no
  more than ±5.

## Out of scope

Posting as the manager, likes and replies, direct messages, posts from players
about their own situation (that belongs with the player-agency work), and any
notification or unread badge.
