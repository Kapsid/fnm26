# Press overhaul: fewer conferences, answers that go on record

**Status:** spec, awaiting approval
**Reported by:** the owner, playtesting 1.0.2, 2026-10-01

> "press conferences still very odd.. tell me if i gave up before 1 match ever?
> Seriously, press is bad now most of the time, repetitive and pointless"

The 2026-09-24 spec (`2026-09-24-press-and-feed-depth-design.md`) carried a
playtester report of the same shape ("they kept asking when I'd resign"). That
spec gave the press names and incidents. This one changes what a conference IS.

## What is wrong today

Mapped from `lib/domain/services/press/press.dart`,
`lib/features/press/press_providers.dart` and `press_sheet.dart`:

1. **Probes are context-blind.** `Press.followUp` picks a probe from the tone
   just taken (`probeAfter`) or, on the last question, from the second
   reporter's angle (`closingProbe`). Neither looks at results, matches played,
   time in the job or even the topic. With the branch's uncommitted 2-question
   cap every follow-up is the closing probe, and a tabloid reporter (2 of 10)
   always asks `yourFuture`. Day one, `newJob` is the only candidate, so a
   manager with zero matches can be asked "At what point is that a
   resignation?" (`pressProbeYourFuture3`).
2. **Every choice is the same choice.** Each topic offers 3 to 4 of five global
   tones with fixed morale-versus-board trades (`effectOf`). `playItDown` is a
   free 0/0 on almost every topic. The answer is a formula, not a judgement.
3. **Nothing is remembered.** Apart from the tone-habit needle and never asking a
   question key twice, nothing said is carried forward. A raised bar is never
   checked against results.
4. **Effects are small, hidden, and wiped each cycle** (clamped to morale ±12,
   board ±10 per cycle).
5. **Repetition.** Follow-ups are generic ("Thousands travelled for that" after a
   ranking climb); answer copy barely varies across topics; seeds land the same
   variant offsets; topic memory is ~3 conferences.
6. **Grievances share the press table.** `grievance_providers.dart` writes into
   `press_answers`, so a grievance restarts the press quiet clock and adds to the
   press totals.

## Decisions taken

| Question | Decision |
|---|---|
| What press should be | Rare conferences at real moments, AND memory of what was said |
| Which moments | Big single results and crisis / job on the line. Not tournament milestones, not a "promise due" trigger, not day one |
| What answers do | Some answers are on-record statements, stored and judged later |
| Which statements | Result promises, job on the line, backing or blaming a player |
| Credibility | Tracked but hidden; felt through reporter tone and headlines |
| Approach | Rebuild the conference; keep reporters, sheet UI, effect plumbing, Y feed |
| Volume | Less press overall than today |

## 1. When a conference happens

`ConferenceTrigger.reasonFor(...)` returns one of `bigResult`, `crisis`,
`jobVerdict`, or null. It is evaluated once, after each of the manager's own
matches is committed.

**bigResult.** The match is competitive (not `FRIENDLY`), its standing by
`Expectation` is `heroic` or `humiliating`, AND it matters: it is a knockout
tie, or it decides or effectively decides the group/qualifying position, or it
starts or ends a run of 3+ (wins or winless). A routine favourite's win or an
underdog's narrow loss never qualifies.

**crisis.** Any of: 3+ competitive matches without a win of which at least 2
are losses; board satisfaction below the existing "worried" threshold. Draws
alone never make a crisis (the 2026-09-24 bug).

**jobVerdict.** An open `jobOnTheLine` statement was just judged broken. This
one always gets a conference.

**Cadence.**
- No conference before the manager's first competitive match. No day-one
  `newJob` conference.
- 45 in-game days quiet after any conference. Only `jobVerdict` breaks it.
- At most 6 conferences per four-year cycle (`jobVerdict` still counts toward
  the 6, but is never refused by it).
- One conference per match at most. Priority: `jobVerdict` > `crisis` >
  `bigResult`.
- The existing watched-finals timing in `hub_event.dart` (press about his own
  match reaches him before he goes off to watch another tournament) is kept.

Target: roughly one conference every 8 to 12 in-game months (4 to 6 a cycle). Measured by a
long-sim test (see Testing), not assumed.

## 2. One conference

`ConferenceBuilder.build(reason, facts)` returns 2 or 3 beats. Facts: the match
(score, opponent, competition, round), its standing, the current run, the best
and worst rated players of the match, credibility band, and statements due a
throwback.

**Beat 1, the moment.** About the result or the run, worded for the reason
(bigResult heroic / bigResult humiliating / crisis / jobVerdict).

**Beat 2, the reaction.** Chosen from the manager's beat-1 answer AND the facts:
- blamed the team → "who?" (offers to name the worst-rated player, which is a
  `blamePlayer` statement, or to decline);
- promised a result → "and if you don't?" (offers `jobOnTheLine`, or to back
  off);
- praised or defended the side → a question naming the standout or the
  struggling player (offers `backPlayer`);
- otherwise a follow-up on the result itself.

**Hard gates on content**, enforced in the builder and pinned by tests:
- No future/resignation question unless the reason is `crisis` or `jobVerdict`.
- No "you promised" line unless a statement exists.
- A player is only named if he played in the match.

**Beat 3, the throwback.** Only when a statement has been judged since the last
conference and not yet thrown back: "You said you'd get out of the group. You
didn't." / "You backed him. He delivered." Each judged statement is thrown back
once, then lives only in history.

**Answers.** 3 to 4 per beat, written for that beat. No universal free option:
deflecting exists but is noted (small credibility cost, see 3). An answer can
carry a statement; the sheet marks those ("on the record").

**Reporters.** The existing 10, unchanged as people. Their tone band (warm,
neutral, hostile) follows the manager's credibility band, per the existing rule
that tone follows the speaker.

**Visible effect.** The existing per-answer arrows stay. Statement answers also
show a short "on the record: ..." line so the stake is clear.

## 3. Statements on record

New table `press_statements` (schema 48 → 49, created empty; existing saves
unaffected):

| column | type | notes |
|---|---|---|
| `id` | int PK | |
| `careerId` | int FK, cascade | |
| `kind` | text | `resultPromise`, `jobOnTheLine`, `backPlayer`, `blamePlayer` |
| `playerId` | int? | for back/blame |
| `target` | text? | for resultPromise: `winNext`, `outOfGroup`, `reachRound:<code>` |
| `madeOn` | date | |
| `madeAfterFixtureId` | int | the match whose conference produced it |
| `status` | text | `open`, `kept`, `broken`, `lapsed` |
| `judgedOn` | date? | |
| `thrownBack` | bool | default false |

Career-bundle export/import: `press_statements` carries `career_id`; its
`playerId` is seed data (not remapped); `madeAfterFixtureId` is remapped with
fixtures. The bundle coverage test forces this decision.

**Judging** (`StatementJudge`, pure; run by the season service after each of the
manager's matches, before the trigger):

| kind | judged by | kept | broken |
|---|---|---|---|
| `resultPromise` `winNext` | next competitive match | morale +4, board +3 | board −6, morale −2 |
| `resultPromise` `outOfGroup` / `reachRound` | the tournament outcome | morale +5, board +5 | board −8 |
| `jobOnTheLine` | next 3 competitive matches: ≥2 wins | board +10 | board −12, immediate `jobVerdict` conference |
| `backPlayer` | his mean rating over his next 3 appearances ≥ 6.8 | his morale up, credibility up | credibility down |
| `blamePlayer` | immediate: his morale −8, squad morale −2. Then over 3 appearances | responds (≥ 6.8): no further effect | stays poor: board +2. Never picked again in that window: lapses quietly |

A statement whose window cannot complete (eliminated before it is judged, player
retires, cycle ends) becomes `lapsed`: no effect, no throwback.

All numbers are starting values, tuned in implementation against the long-sim
test; they are named constants in one place.

**Credibility** (hidden, 0 to 100, start 50) is DERIVED from statement history,
never stored, so it cannot drift from the save: kept +8, broken −10, lapsed 0,
each deflect −2 (deflects are recorded as answers, see below), clamped. Bands:
low < 35, mid, high > 65. It scales answer effects (×0.6 at 0 to ×1.4 at 100)
and selects reporter tone.

**Effects across cycles.** Press and statement effects stop being wiped at the
cycle boundary: half of the previous cycle's total carries in. The existing
per-cycle caps (morale ±12, board ±10) stay as a safety net.

## 4. Data and cleanup

- `press_answers` stays as the record of answers (it now also records the beat
  key and whether the answer was a deflect). Grievances get their own
  `grievance_answers` table (or a `source` column filtered out of every press
  read; decided in the plan), so they stop restarting the press clock and stop
  feeding press totals. Migration moves existing grievance rows over.
- The old `PressTopic` catalogue, `PressProbe`, `closingProbe`/`probeAfter` and
  the tone-habit needle are removed. Copy that fits the new beats is moved, not
  rewritten; the rest of the old press strings are deleted from both ARBs.
- The branch's uncommitted press edits (`maxConferenceLength` 2 cap, the
  watched-finals filter in `press_providers.dart`) are superseded; the
  `hub_event.dart` ordering is kept.

## 5. Y feed

A judged statement may produce one post from the existing personas ("He said
they'd get out of the group..."), through the existing tone-band machinery. No
new persona work.

## 6. Copy

EN and CS for every beat family and answer, 4 to 6 wordings each; tone-banded
generous / neutral / sour per the press-and-Y-depth rule. No em dashes in
user-facing copy. "World Championship", never "World Cup", in EN. Re-export
`copy/strings.csv` after ARB edits.

## Testing

- **Trigger:** none before the first competitive match; 45-day quiet; ceiling of
  6 per cycle; `jobVerdict` breaks both; draws alone never a crisis; friendlies
  never a bigResult.
- **Builder:** no future/resignation question outside crisis/jobVerdict; no
  "you promised" without a statement; named players played in the match;
  throwback exactly once.
- **Judge:** each kind kept, broken and lapsed; credibility bounds and bands.
- **Migration:** schema 48 → 49 on a populated save (the existing generic
  migration test), grievance rows moved.
- **Bundle:** round-trip with statements.
- **Widget:** a full 3-beat conference including a statement and its "on the
  record" line.
- **Long sim:** several seeds over full cycles; assert conferences per cycle
  stay at or under 6 and average in a target band (about 4 to 6), and that no
  conference precedes the first competitive match.

## Out of scope

Tournament-milestone conferences, a visible credibility meter, style/approach
claims ("we'll keep attacking"), recurring storylines across cycles.
