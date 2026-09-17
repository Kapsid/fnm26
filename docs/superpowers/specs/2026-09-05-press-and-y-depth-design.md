# Press and Y: depth, personality and memory

**Status:** built 2026-09-06. See the notes at the foot for what the
implementation changed about the design.
**Date:** 2026-09-05

## The problem

Three complaints, in the order they bite:

1. **It repeats itself.** A post's wording is picked by
   `varietySeed('$key|${voice.name}') % variantCount`, and `variantCount` is 4.
   Six result templates fire every single match, so a manager sees the same
   four sentences about a win within a dozen games. Replies are worse: six
   moods answer every event in the game, at six wordings each.
2. **The voices have no personality.** `YVoice` decides *who* posts, never
   *what sort of person they are*. The pundit, the ex-pro and the fan draw from
   the same bank; swap their handles and nothing reads differently. Nobody has
   an opinion that survives one post.
3. **Nothing is remembered.** No callbacks, no running feuds, no "third time
   this year". `noRepeatWindow` suppresses a repeated shape but puts nothing in
   its place.

And underneath all three, the thing the original request named: **the world
does not know how good you are.** `YFeed.classify` re-derives its own crude
±25 rank gap, the press ignore strength entirely, and `PublicMood` — which
already models expectation properly — is wired to the board and nothing else.
A 60th-ranked side and a favourite get the same coverage of the same scoreline.

## Constraints that shape everything

- **Sentences are whole and localised.** Czech has seven cases, so a post
  cannot be assembled from fragments. Every phrasing is two hand-written
  strings. This is the budget, and it is why the design spends copy last.
- **Nothing is stored.** The feed is derived from events the world already
  recorded, so scrolling back a year shows what it showed then. Personas and
  stances must therefore be *computed* from `(nation, saveSeed)` and the run of
  history, never persisted.
- **Determinism.** Same save, same feed, every rebuild.

## The design, in three layers

### Layer C — one shared reading of a result

New `lib/domain/services/press/expectation.dart`.

`PublicMood._verdict` already answers "how did that go, for a side like ours?"
on a −1…+1 scale. Promote it to a named, shared concept and let three callers
share one answer instead of three disagreeing ones.

```
enum ResultStanding { heroic, creditable, par, poor, humiliating }

Expectation.of({nationRank, opponentRank})      → double  −1 … +1
Expectation.standing({expected, scored, conceded, competitive}) → ResultStanding
```

`PublicMood` keeps its own weighting but calls `Expectation.of` rather than
holding a second copy of the maths. `YFeed.classify` is rewritten in terms of
`ResultStanding` and its ±25 constant deleted.

What standing then drives:

- **Volume.** How many voices speak about a match. A `humiliating` result is
  loud, a `par` one gets a line from the stats account. Today this is `loud`,
  derived from the template; it becomes derived from standing, so a minnow
  holding a giant is *news* and a giant beating a minnow is not.
- **Who speaks.** The rival account turns up for `humiliating`, not merely for
  any defeat. The ex-pro appears when standing is extreme in either direction.
- **Which wording tier.** See Layer A.
- **What the press ask.** `Press.pick` currently orders candidates by whatever
  the caller passed. Standing gives the story list a real priority, and adds
  three topics the game cannot currently ask about: `overachieving`,
  `luckyWin`, `crisis`.

### Layer B — personas and memory

New `lib/domain/services/press/persona.dart`.

**Personas.** Each nation has a small, stable cast, derived from
`(nation, saveSeed)` — the pundit is already stable this way; this extends it
to every recurring voice and gives each one a trait:

```
enum YTrait { loyalist, cynic, nostalgic, statshead, hypeman, contrarian, doomer }
```

A trait does two things, both free of new copy:

- it **biases which template** that author reaches for (a `doomer` posts
  `boardPressure` off a narrow win; a `hypeman` posts `winStreak` off two);
- it **shifts the wording tier** — the same event read sourly or generously.

**Stance.** A number in −100…100 for how each persona currently rates the
manager, computed by running the same result history the feed already walks,
weighted by trait (a `loyalist` forgives, a `cynic` does not). Derived, not
stored, so it stays deterministic and historically honest: scroll back and the
pundit who had turned on you in 2031 is still turned on you there.

**Memory.** `YFeed.forRun` already walks history in one pass with a
`recent` window. Extend that pass to carry a small `YHistory`: how many times
this shape has occurred, when it last did, and against whom. A repeat unlocks a
**callback family** of templates — `againstThemAgain`, `sameOldStory`,
`toldYouSo` — which is where "it doesn't remember anything" is actually fixed.

**Press reporters** get the same treatment: `PressReporter` gains a stance, so
a tabloid you have feuded with pushes harder and a broadsheet you have been
straight with gives you room. `Press.effectOf(tone)` stops being a constant per
tone and takes context: backing the players after a humiliation costs more
board credit than backing them after a narrow defeat; demanding more from a
squad already low on morale bites deeper than demanding more from a happy one.

### Layer A — copy, spent where it repeats

Only now, and only on the templates that actually fire often.

| Group | Templates | Variants now | After |
|---|---|---|---|
| Result | winUpset, winRoutine, winTight, drew, lost, lostBadly | 4 | 12 |
| Reaction | 6 moods | 6 | 12 |
| Frequent extras | scorerStar, winStreak, lossStreak, rivalry, injuryBlow, boardPressure | 4 | 8 |
| Callbacks (new) | againstThemAgain, sameOldStory, toldYouSo | — | 6 |
| Cold | trophy, hostNamed, groupDrawn, … | 4 | 4 |

Variants are **tone-banded**: the first third of a template's variants read
generously, the middle neutrally, the last sourly. Selection becomes

```
tier   = f(standing, persona.trait, persona.stance)
variant = tier.offset + varietySeed('$key|$author') % tier.size
```

so the extra sentences are not merely more numerous, they are *apt* — a
`heroic` draw draws elation, the same scoreline as a favourite draws scorn.

Roughly **160 new sentences per language**, plus press wording for the three
new topics.

## Files

| File | Change |
|---|---|
| `domain/services/press/expectation.dart` | new — the shared reading |
| `domain/services/press/persona.dart` | new — traits, stance, cast |
| `domain/services/press/public_mood.dart` | delegates its maths to `Expectation` |
| `domain/services/press/y_feed.dart` | `classify` in terms of standing; volume, voice choice and variant tier from standing + persona; `YHistory` in `forRun`; callback templates |
| `domain/services/press/press.dart` | three new topics; reporter stance; context-sensitive `effectOf` |
| `features/y/y_providers.dart` | pass standing and persona through; no new queries — every input already exists here |
| `l10n/app_en.arb`, `app_cs.arb` | the copy |

`y_feed.dart` is 792 lines and will grow; the persona and expectation logic go
in their own files rather than swelling it further.

## Testing

- **Expectation** is a pure function: a table test over rank gaps and
  scorelines, pinning that a minnow's draw with a giant is `heroic` and a
  favourite's is `poor`.
- **Determinism** is the property most at risk from personas: a test builds the
  same feed twice from the same save and asserts identical output, and a second
  asserts that a feed built from a *prefix* of history matches the same posts
  in the full feed (this is what "scroll back and it still says that" means).
- **Variety** is measurable: over a 60-match synthetic save, assert no wording
  repeats within N posts and that the distinct-sentence count clears a floor.
  This is the test that would have failed before the change, which is the point.
- **Stance** — a run of humiliations must move a `cynic` further than a
  `loyalist`, and both in the same direction.
- **Copy parity** — every new key exists in both ARBs (the existing l10n tests
  already enforce this shape).

## Deliberately not doing

- **Fragment assembly.** It would multiply variety combinatorially and it
  cannot survive Czech declension. The tone-banded whole sentences are the
  compromise.
- **Storing personas or stance.** Derivation keeps the feed honest when
  scrolled back, and avoids a schema bump.
- **New data sources.** Everything the design reads — ranks, scorers, streaks,
  absences, board mood, meetings — is already assembled in `y_providers.dart`.


---

## What the build changed about this design

Three things the design got wrong, found by writing it.

**The tone must follow the SPEAKER, not the result.** The first cut derived a
post's tone mostly from `ResultStanding`, which reads sensibly and collapses in
practice: the template already encodes the standing, so `winUpset` was always
worded generously and its sour phrasings were unreachable by anybody. Each
template used one band, and the feed ended up drawing on *fewer* sentences than
before the bands existed. Disposition now leads and the result only leans.

**A pre-existing bug was doing most of the damage.** `forRun` de-duplicated
posts by `template|args`, and every voice reporting one match shares both — so
the fan's and the pundit's match reports were dropped as repeats of the stats
desk's. One result post per match, ever, and the whole `loud` calculation about
how big an occasion it was decided nothing. The shape is now the *sentence*
(template, wording and arguments), which restored the extra voices and roughly
doubled the feed's volume.

**Press effects had to scale, not shift.** Adding a standing-derived term to
the board cost pushed it past zero after a good result, so taking the blame for
a triumph both lifted the dressing room and pleased the board — the one thing
no answer is allowed to do. The standing now scales the cost.

Delivered: `expectation.dart`, `persona.dart`, `YMemory` and three callback
templates, result templates at 12 phrasings, replies at 12, mid-tier at 8,
three new press topics, and context-sensitive press effects wired to both the
sheet and the save. About 300 new sentences per language rather than the 160
estimated, because replies and the new topics needed more than the design
assumed.

Measured: distinct phrasings in a 60-match save went from 30 to 60.
