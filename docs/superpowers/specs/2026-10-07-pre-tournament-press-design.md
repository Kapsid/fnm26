# Pre-tournament press conference

Date: 2026-10-07. Builds on the press overhaul
(`2026-10-01-press-overhaul-design.md`).

## Goal

Before the manager's first match of a campaign he is actually in, the press
ask him a few questions that are about that campaign. The main one is "what's
your aim?", and his answer goes on the record as a stated target that is judged
when the campaign is judged.

Approved in chat on 2026-10-07: stated target, judged later (not flavour only).

## When it happens

A preview conference is due before the manager's **first own fixture** of each
of these campaigns in the current cycle:

| Campaign | First fixture |
|---|---|
| World Championship qualifying | first `worldCupQualifying` fixture (round code null) |
| Continental qualifying | first `CQ` fixture |
| World Championship finals | first `GROUP` fixture |
| Continental finals | first `CGROUP` fixture |

- At most 4 per cycle. Hosts who skip qualifying get no qualifying preview.
  A side that did not qualify has no finals fixture and gets no finals preview.
- No preview for the Nations Cup, the Continental Clash or friendlies.
- Due only while that fixture is the manager's **next** fixture and is
  unplayed. Once it is played, the preview is gone; it is never offered late.
- Once per campaign: due only if no conference row with reason `preview`
  exists for that fixture.
- Exempt from `ConferenceTrigger.maxPerCycle` and `quietDays`, in both
  directions: previews are not counted when deciding post-match conferences,
  and post-match conferences do not block a preview.

### Where it sits in the hub timeline

As a `HubEventKind.press` event placed **directly above the match event**, so it
comes after the call-up, base camp, draw and opening ceremony, and it is the
last thing before kick-off. An existing pending post-match conference keeps its
current place and is offered first.

## Derived until opened

Nothing is written by the simulation. `previewDueProvider(careerId)` works out
the due preview (campaign, fixture) from the fixtures. The hub event and
`pendingConferenceProvider` read it. When the manager opens the sheet,
`ConferenceService.openPreview` records the `press_conferences` row (reason
`preview`, `fixtureId` = the opening fixture, `triggeredOn` = today) and the
sheet then runs against that row exactly as for any other conference. The
existing stale-row cleanup in `PressDesk` retires one opened and left
unfinished.

## The beats

`ConferenceFacts` gains the preview's context: `campaign` (enum
`PreviewCampaign { wcQualifying, contQualifying, wcFinals, contFinals }`),
`briefTarget` (the board's target ordinal for that tier, from
`cycleObjectiveOutcomesProvider`), `rivalNationId` (best-ranked other nation
in his group, or null) and `keyPlayerId` (his highest-overall called-up player,
or null).

1. **Aim** (`BeatKind.aim`). Always asked.
   - Finals: `aimHigher`, `matchBrief`, `playDown`.
   - Qualifying: `promiseQualify`, `playDown`, `deflect`.
   - When the brief is already 7 (win it), `aimHigher` is not offered.
   - `promiseQualify` is scored as `aimHigher` when the brief is 1 (top half
     of the qualifying group), and as `matchBrief` when the brief is 2 or more.
2. **The draw** (`BeatKind.rival`). Asked only when `rivalNationId` is set.
   Answers `fearNobody`, `respectRival`, `deflect`. Instant effects only.
3. **Key player** (`BeatKind.keyPlayer`). Asked only when `keyPlayerId` is set
   and he has no open statement. Answers `backPlayer` (the existing statement,
   judged on his next 3 games as today), `teamFirst`, `deflect`.

The throwback beat is never asked at a preview: the occasion is the campaign.

## The stated target

A new `StatementKind.target`, stored with a new nullable `target` column
(the stated ordinal, 1–7) and `madeAfterFixtureId` = the opening fixture.

Stated ordinal by answer:

| Answer | Stated target |
|---|---|
| `aimHigher` | brief + 1 (max 7) |
| `matchBrief` | brief |
| `promiseQualify` | 2 |
| `playDown` | brief − 1, and min 0; judged as "beat the brief" only (see below) |

`deflect` records no target.

### Judging

Judged by `PressDesk.afterMatches` (the existing judge step), against the
campaign's tier in `cycleObjectiveOutcomesProvider`:

- **Qualifying statement:** settled the moment qualification is settled. It's
  kept once the side has a finals fixture (`actual >= 2`), and broken once the
  tier's objective is `decided` with `actual < 2`.
- **Finals statement:** settled when the tier's objective is `decided`. It's
  kept when `actual >= stated`, else broken.
- Lapses, as today, on a change of nation or cycle.

### Effects

Instant effects follow `ConferenceBuilder.effectOf` (scaled by credibility).
Judged effects are written to `press_answers` as `stmt:<id>`, the same as the
existing statements.

| Answer | Instant (morale, board) | Kept | Broken |
|---|---|---|---|
| `aimHigher` (and `promiseQualify` at brief 1) | (+3, +2) | board +10 | board −10 |
| `matchBrief` (and `promiseQualify` at brief ≥ 2) | (+2, +1) | board +4 | board −6 |
| `playDown` | (0, −2) | board +2 only if the brief itself is beaten (`actual > brief`), else 0 | 0 |
| `fearNobody` | (+3, 0) | | |
| `respectRival` | (+1, +1) | | |
| `teamFirst` | (+2, 0) | | |

A kept or broken target feeds `Credibility` like the existing statements.

## Storage

- `press_statements.target`: `IntColumn`, nullable. Schema 49 → 50 with a
  stepwise migration (`addColumn`), following the saves-preserving recipe.
- `ConferenceReason.preview` is stored by name in the existing text column; no
  change is needed.

## Copy

New keys for the three beats' questions, the new answers, the target's inbox
throwback lines and the hub event subtitle ("The press want to hear your aims
for the {competition}"). Written in EN, CS, FR, IT, PL, ES and DE, and
round-tripped through `copy/strings.csv`. No em dashes. "World Championship",
never "World Cup". The aim answers name the brief's own wording (reusing
`objectiveDemandText`) so "aim higher" reads as, e.g., "We're going for the
semi-finals".

## Testing

- `previewDue`: each of the 4 campaigns fires once, before its first own
  fixture; not for hosts' qualifying, not for a non-qualifier's finals, not
  once that fixture is played, and not twice.
- Trigger isolation: a preview doesn't count toward the cap or quiet window,
  and a recent post-match conference doesn't block a preview.
- Beat building: aim options by campaign and brief (7 has no `aimHigher`),
  and the rival and key-player beats are skipped when there are no facts.
- Judging: qualifying kept at the finals draw and broken when it fails;
  finals kept, broken and beaten; `playDown` bonus only when the brief is
  beaten; lapses on a nation or cycle change.
- Migration: a v49 database opens at v50 with its statements intact.
- Copy: each new string fits a 320px-wide screen in all 7 languages, and the
  existing copy guards pass.

## Out of scope

The Nations Cup and Clash previews, a pre-match conference before every game,
and a visible credibility meter.

## Amendments (during the build, 2026-10-07)

- **Finals brief floor.** At the finals the press hold him to at least
  "reach the knockouts" (`PreviewCampaign.briefFor` clamps a finals brief to
  3–7). Without it, a side whose board brief was "qualify" could promise to
  match the brief at the finals and have it count as kept on the day it was
  said. Qualifying briefs are clamped to 0–2 as specified.
- **`promiseQualify` instant effect** is always (+2, +1). Only its judged
  effect depends on the brief (aim higher at brief 1, match the brief at 2).
- **Answer effect row wraps.** The squad/board line under each answer was a
  fixed row that overflowed a 320px screen in French, Polish and German on
  any zero-effect answer. That was an existing bug in every conference,
  found by the new fit test.
