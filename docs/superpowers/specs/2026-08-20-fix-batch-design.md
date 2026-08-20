# Fix batch — 2026-08-20

Twenty-four items from a device playtest, lettered a–x. Most are small; six
touch real subsystems (manager staff, youth intake, the press conference,
call-up windows, transfer economics, world-sim variance) and one needs a
schema bump.

## a–b, j–k, m, n — Text is never cut

**Symptom.** Y post titles, squad surnames, the call-up list, the next-match
card and the stadium blurb all end in `…`. A truncated surname is not a name.

**Root cause.** `TextOverflow.ellipsis` at ~40 call sites. The problem was
already solved once, properly, in `tactics_pitch.dart`: surnames have no
spaces, so the pitch inserts zero-width break opportunities (`​`) between
letters and wraps inside a `FittedBox(fit: scaleDown)` over a *bounded* width.
The name wraps to a second line first and only then scales down, so it always
arrives whole.

**Design.** Extract that treatment into `lib/shared/widgets/whole_text.dart`:

```dart
/// Text that is never cut. Wraps first (surnames get break opportunities
/// between letters), then scales down to fit, never ellipsised.
class WholeText extends StatelessWidget {
  const WholeText(this.text, {this.style, this.maxLines = 2, this.align, ...});
}
```

`tactics_pitch.dart`'s `_DiscContents` becomes a caller rather than the owner
of the logic. Apply at:

| Item | Site |
|---|---|
| a | `y_screen.dart:310,319` — post title and handle |
| b | `nation_squad_tab.dart:307,333,514,540,564` — squad rows |
| m | `call_up_screen.dart:332,666,774,780,848,896,919` — nomination rows |
| k | `hub_screen.dart:628` — next-match card |
| j | `ground_card.dart:60` and the tournament-stadium rows — stadium text |

**n.** The substitution line repeats the position (`CB`) the disc already
shows, and the repetition is what pushes the age off the end. Drop the position
token from the sub text; the age renders whole.

**Not in scope.** The other ~25 `ellipsis` sites (club names, competition
names, opponent names) stay as they are — a clipped club name is a nuisance,
a clipped surname is a bug. Only the name/identity sites change.

## c — Club history is hidden for players who never moved

**Root cause.** `_ClubHistoryCard` (`player_detail_screen.dart:583`) returns
`SizedBox.shrink()` when `spells.length < 2`, on the reasoning that a single
spell duplicates the club already shown at the top of the card. The effect is
that a one-club player looks like a player with no transfer record at all,
which reads as a bug rather than as a career.

**Design.** Always render the card when there is at least one spell. A single
spell reads `2026– · <flag> <club>` under the same heading, so the section
answers "has he ever moved?" instead of going silent.

## d–e — The manager section, and where money lives

**Symptom.** The manager screen mixes three unrelated things (attributes,
training focus, staff hiring). Focus is noise. Staff are a *cost*, and costs
belong next to the budget.

**Design.**

1. **`TrainingFocus` is deleted** — enum, the `careers.trainingFocus` column,
   `setTrainingFocus`, `focusOn`, the radio list, and all four `managerFocus*`
   l10n keys. Its effects fold into the assistant, so the choice disappears but
   the *outcomes* do not:
   - `Training.injuryFactor(focus, assistant)` → `Staff.injuryFactor` absorbs a
     `1 - 0.06 * trainingEffect(assistant)` term (half the old fitness-focus
     bonus, now unconditional).
   - `Training.familiarityGain` → shape familiarity gains
     `1 + 0.12 * trainingEffect(assistant)` unconditionally.
   - `Training.youthTalentBonus` → `0.025 * trainingEffect(assistant)`
     unconditionally.

   Half-weight is deliberate: a manager who *chose* fitness got the full
   effect; a manager who now gets all three gets each at half. `abstract final
   class Training` disappears with the enum.

2. **`manager_screen.dart` keeps attributes and XP only.**

3. **Staff become named people, hired from the Budget screen.** A new
   `StaffCandidate` — `({int id, String name, String country, StaffRole role,
   StaffTier tier})` — generated deterministically from `(saveSeed, cycle,
   role, slot)` by `Staff.marketFor(...)`, using the existing fictional name
   pools. Three candidates per role per cycle, spread across tiers. Hiring one
   stores the candidate id; the tier (and therefore every existing effect) is
   read back from the id, so `Staff.trainingEffect` and friends are untouched.

**Schema (bump).** `careers` gains `staffAssistantId`, `staffScoutId`,
`staffFitnessCoachId` (nullable ints). The existing
`staffAssistant/staffScout/staffFitnessCoach` tier columns STAY — they are the
source of truth for effects, and a save that upgrades keeps its tiers with a
null identity (shown as "—", replaceable at the next rollover). Stepwise
migration per the project's usual recipe.

**UI.** `budget_setup_screen.dart` gains a "Staff" section under the
departments: three role cards, each showing the person currently in the job
(name, flag, tier, cost/cycle) and a sheet to pick from this cycle's
candidates. The wage total already flows through `Staff.totalCost` into
`season_rollover.dart:45` and `manager_providers.dart:66` — unchanged.

## f–g — The youth pyramid

**g. First, a diagnosis.** Intake is *already* at eleven: `intakeAge = 11`,
`backfillYears = 6`, and `youthPoolAt` builds ages 11–20, so newgens should
enter at U13 and climb. The report says new faces appear at U17 as well.
Before changing anything, write a test that walks one nation's pyramid across
ten years and asserts the ids at U15 in year N are a superset (minus releases)
of the ids at U13 in year N−1. If it fails, the fix is whatever it exposes; if
it passes, the symptom is presentational and the fix is in `youth_screen` /
`Prospects.watchlist`, which is what is marking players as new. **Do not
change generation before this test says what is wrong.**

**f. Wonderkids are too common.** `potential >= 1.70` currently marks a
wonderkid, and the U13 level shows several. Raise the bar and thin the tail so
a generational talent is roughly one per 2–3 intakes for a mid-table nation
(≈ one in 15–20 newgens), measured by a test that counts wonderkids across 12
intake years rather than asserted by eye.

**Late bloomers.** A small, separate roll on `(id, saveSeed)` gives ~4% of
newgens a potential uplift that only *reveals* at 17–19, so the pyramid is not
fully readable at thirteen. It is an uplift to the existing potential, not a
second potential: a boy who was going to be good becomes very good, nobody
comes from nowhere.

## h, w — The press conference

**w. It becomes a real event.** `HubEventKind.press` already exists but only
fires for a tournament opening. Every *due* conference becomes the hub's next
event, and the press sheet stops being reachable from the hub while one is
pending. Questions past `Press.askWindowDays` are dropped rather than left
answerable — a stale question answered next month is the bug being reported.

**h. Questions stop being generic.**

- `conferenceLength` becomes `Press.lengthFor(topic)` → 1–4. A triumph, an
  elimination or a tournament preview runs to four; a routine friendly or a
  ranking peak runs to one or two. Always-three is what makes it read as a
  form.
- **Tone options are filtered by context.** `Press.optionsFor(topic)` gains a
  context record `({int target, int worldRank, int boardMood})` and drops
  tones that make no sense for the side: `raiseTheBar` is not offered when the
  stated objective is merely to qualify (`target <= 2`) or the nation is
  outside the top 40 — the reported "weak team says it only wants to win the
  cup" line. `playItDown` remains always available.
- **Wording names things.** Questions already carry `subjectNationId`;
  extend the drafts to substitute the opponent's name, the nation's stated
  objective, and (for selection/dressing-room probes) a named player from the
  current squad, so the room sounds like it watched the match.

## i, s — The board

**i.** Objective rows in `board_objectives_screen` currently read met/missed.
`BoardSatisfaction.objectiveSwing` already computes the gap in rounds; surface
it — "Two rounds better than asked", "Three rounds short" — colour-scaled, so
a wild overachievement and a bare pass do not look the same.

**s.** `BoardSatisfaction.compute` is pure and starts every cycle at
`neutral = 50`, so a manager who won the last World Cup begins the new cycle
with exactly the credit of one who was sacked-adjacent. Add an optional
`previousCycle` term: the caller passes the *previous* cycle's settled
objectives, and their swing is applied at **25%**. A good cycle buys a little
rope; it cannot carry a manager through a bad one. Derived from data already
in the DB — **no schema change**.

## l — Player complaints, off

Grievance *generation* goes to zero and the UI entry disappears:
`HubEventKind.grievance` never fires, `grievance_sheet` is unrouted, the
squad-screen entry point is removed. `lib/domain/services/squad/grievances.dart`
and its tests stay in the tree behind a single `Grievances.enabled = false`
constant, so turning it back on is a one-line change rather than an
archaeology exercise.

## o — Transfers that make sense

**Root cause.** `_transferFee` (`season_rollover.dart:313`) is
`player.value × premium`, with no reference to where he is going. A €30M fee
in Romania is the arithmetic working exactly as written.

**Design.**

1. **Fees scale to the destination league.** `ClubService` already knows a
   league `tier` (1 = elite … 5 = lower) per country. Fees gain a tier ceiling:
   roughly €120M / €45M / €15M / €5M / €2M by tier, applied as a soft cap so a
   move *into* a tier-4 league cannot print a marquee number. A move that
   crosses tiers upward keeps the buying league's ceiling, which is the
   realistic direction of the money.
2. **More moves abroad.** `_staysHome` / `homeRetention` decide whether a good
   player at a small nation stays in his domestic league. Lower retention for
   players whose overall is well above their home league's tier, so the strong
   ones leave — which is both realistic and what makes the tier ceiling bite.

Both are pure functions with tests: a fee-ceiling test per tier, and a
distribution test asserting that a nation's top players are predominantly
abroad after a few cycles.

## p — Passive simulation, carefully

**Symptom.** Surprise winners dominate the world's competitions.

**Constraint stated by the user: the balance is currently good and has only a
little slack. Measure before touching, move one notch, stop.**

1. Write `test/unit/match/world_variance_test.dart`: simulate 25 seasons of
   background competitions and report how often the winner sits outside the
   world top ten. This is a *measurement* first — it prints the number.
2. Only if that number is clearly unrealistic, raise the rating-gap dial in
   `RatingMatchSimulator` from `exp(0.026 * diff)` by **one step to 0.028**,
   and re-run `match_balance_test.dart`, which must stay green. `MatchEngine`
   is NOT touched — the two simulators are calibrated together and the
   player's own matches are not the complaint.
3. Record the before/after number in the commit message.

## q — Notifications one step late

**Root cause.** `showUnreadMessagePopups` deliberately reads the repository
directly and does not sync, on the reasoning that `messageInboxProvider` syncs
as a side effect of the hub's unread badge. But the popup call in
`hub_screen.dart:64` runs on the first frame, before that provider has
resolved — so a freshly-advanced step has generated nothing yet, and the
messages appear only on the *next* visit to the hub.

**Design.** `showUnreadMessagePopups` awaits an explicit
`messageSyncProvider(careerId)` (or the service's `sync`) before reading
unread. The comment explaining why it does not sync is replaced with one
explaining why it must. The badge path is unaffected — sync is idempotent.

## r — Save slots and paywall copy

- `maxSaveSlots` → **3 free, 10 Pro** (was 2 / 5).
- Copy, EN and CS:
  - `paywallBenefitEndless` / `gateBenefitEndless` → "Unlimited careers"
  - `paywallBenefitSaveSlots` / `gateBenefitSaves` → "10 save slots instead of 3"
  - `gateBenefitUpdates` → "Every future update included"
  - `gateBenefitOffline` → "Works offline — no subscription, no ads, no account"
- The `savesFull` / Pro-prompt strings that name a number are re-checked
  against the new limits.

## t — One call-up per window

**Now.** The call-up event fires per campaign block, and a manager re-picks
every few matches.

**Design.** A squad is named once per international window (the 2–3 matches
that block covers) and once per tournament, and holds for the whole of it.
`HubEventKind.callUp` fires at the head of a window only. Between matches the
call-up screen is read-only, showing the named squad. An injury inside the
window pulls in a replacement automatically and posts a message rather than
reopening selection.

**Storage.** The window a squad was named for is stored so re-entering the hub
does not re-ask (`careers.callUpWindowId`, folded into the same schema bump as
the staff ids).

## u — Warn when the side is not set up

Before kick-off, if no captain is named or set-piece takers are unset, the
match preview shows a warning strip with a tap through to the relevant screen.
It warns; it does not block. Both are already stored per career, so this is a
read plus a banner.

## v — "My Career"

`navCareers`: "Careers" → "My Career", "Kariéry" → "Moje kariéra". The route
and screen names stay.

## x — Formations

All seventeen shapes already exist in `Formation` and all seventeen are
already offered — as a `Wrap` of text chips (`tactics_screen.dart:264`), which
is the actual complaint: seventeen text labels are unreadable as a choice.

**Design.** Replace the chip wrap with a scrollable grid of mini-pitch tiles:
each tile draws the shape's slot positions as dots on a small pitch, with the
label beneath and the current shape emphasised. The dot positions come from
the formation's existing slot geometry — the same data the tactics pitch
lays out — so the picker cannot drift from what the pitch shows. Add two
genuinely missing shapes while there: **4-3-2-1** and **3-5-1-1**.

## Testing

| Area | Test |
|---|---|
| a–b, j–n | Widget test: `WholeText` renders a 16-letter surname whole at a narrow width |
| c | Widget test: one-spell player still shows the club-history card |
| d–e | Unit: `Staff.marketFor` is deterministic; wage total unchanged for a given tier set. Migration test v(n−1) → v(n) preserves tiers |
| f–g | Unit: pyramid continuity across ten years; wonderkid frequency across twelve intakes; late-bloomer share |
| h, w | Unit: `lengthFor` per topic; `optionsFor` never offers `raiseTheBar` to a qualify-only minnow |
| i, s | Unit: carry-over is 25% and cannot alone move a cycle from failing to passing |
| o | Unit: fee ceiling per league tier; abroad-share distribution |
| p | `world_variance_test` (measurement) + existing `match_balance_test` (guard) |
| q | Unit/widget: a message written by the step is popped on the same hub visit |
| r | Unit: `maxSaveSlots` 3/10; l10n keys resolve in EN and CS |
| t | Unit: one call-up per window; an in-window injury does not reopen selection |
| Whole batch | `flutter analyze` clean; full suite green; device playtest on the iPhone |

## Order of work

1. Mechanical and isolated: v, r, c, q, n, u
2. The shared widget and its call sites: a, b, j, k, m
3. Schema bump + manager/staff/budget: d, e (and t's column)
4. Youth diagnosis then fix: g, f
5. Press: h, w
6. Board: i, s
7. Squad flow: l, t, x
8. World realism, measured: o, p
9. Analyze, full suite, build, deploy to device

Schema bumps in one go (staff ids + call-up window), so the migration is
written once.
