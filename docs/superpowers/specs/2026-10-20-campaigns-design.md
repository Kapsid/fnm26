# Campaigns

Date: 2026-10-20 · Status: approved 2026-10-20 · calibrated 2026-10-21 (owner: more Italians, stronger rival) — Transplant uses nine Italians, Grudge's rival is Albania (seed 10)

## What it is

A new way to play: a **campaign** is a hand-made, limited challenge on top of a
normal career. It fixes a nation, adds a twist that bends the usual rules, sets
a goal, and judges the run with a verdict and a star rating. First release:
two free campaigns, each one cycle long.

## Why

Players finish a career cycle and want a reason to start another with a fresh
angle. Short, sharp scenarios with a clear target and a star rating give that,
are easy to explain in the store and on social media, and reuse almost
everything the game already simulates. Free campaigns are also a showcase that
ends naturally inside the free cycle; longer Pro campaigns come later.

## Goals

1. A Campaigns entry on the home screen listing the campaigns, each with its
   nation, twist, goal, star thresholds and the player's best result.
2. Starting a campaign creates a career with that campaign's rules applied.
3. During the campaign the hub shows the goal and progress; when the goal is
   settled the player gets a verdict (success or failure) and stars.
4. The two launch campaigns below, each tested to be beatable and not
   trivial.

## Non-goals (this release)

- Pro or multi-cycle campaigns (the format must allow them later: a campaign
  definition carries its length and whether it needs Pro).
- Leaderboards, online sharing, or cloud sync of stars.
- A campaign editor.
- Mid-cycle starts or other twists not needed by the two launch campaigns.

## Anti-goals

- A campaign that silently behaves like a normal career because a twist did
  not apply (e.g. AI Italy still fielding a player who switched to San
  Marino). Twists must be enforced everywhere the rule could leak: call-ups,
  auto-picks, the match XI, and the background simulation.
- Breaking existing saves or the normal game: no schema change, and a normal
  career must behave exactly as before.
- A campaign whose outcome is settled by luck alone (unbeatable, or won by
  doing nothing). Each is calibrated with the existing autopilot career driver
  before release.

## The two launch campaigns

All free, one cycle. Stars use the board-objective finish scale the game
already has (2 = qualify, 3 = reach the knockouts, 4 = quarter-final…).

| Campaign | Nation | Twist | Goal (success) | ★ | ★★ | ★★★ |
|---|---|---|---|---|---|---|
| **The Transplant** | San Marino | Five of Italy's best players switch allegiance to San Marino at the start | Qualify for the European Championship | Qualify | Reach the knockouts | Quarter-final or better |
| **Grudge** | Georgia | Drawn in the same Euro qualifying group as Armenia (Claude's call: Russia is not in the game) | Finish above Armenia in qualifying | Above Armenia | And qualify for the Euro | And win both matches against Armenia |

The thresholds are a starting point: calibration (below) may move them.

## How it works

### A campaign definition

A campaign is defined in code (a registry of constant definitions), not stored
data: id, nation, fixed world seed, twist settings, goal type, star thresholds,
length in cycles, whether Pro is needed, and its copy keys (title, twist line,
goal line, intro, verdict lines). Adding a campaign later is adding one entry
plus copy.

### Marking a career as a campaign

When a campaign starts, the career is created normally (`CareerService.create`
with the campaign's nation and its fixed seed) and then marked with a
per-career key in the existing watched-events table (`campaign:<id>`, at cycle
0): the same no-schema technique as the 1.0.6 rule markers. Everything that
behaves differently in a campaign asks "is this career a campaign, and which?"
through one helper, so a normal career is untouched.

### Twists

- **Transplant:** at creation, the five highest-rated Italian players are
  attached to San Marino through the existing naturalisation link (accepted,
  source nation Italy). They then appear in San Marino's pool, call-ups and
  matches exactly as naturalised players do today, and are no longer Italy's
  anywhere: Italy's squads in the background simulation must not field them.
  Today an accepted naturalisation does not remove the player from his old
  nation in the background simulation, which is a bug in the normal game too;
  it is fixed generally (Claude's call), so a naturalised player plays for
  one nation only, in every career.
- **Grudge:** the campaign's fixed world seed is chosen so that Georgia and
  Armenia are drawn into the same European Championship qualifying group. No
  draw manipulation in the engine; a test asserts the seed still produces the
  shared group (it will fail loudly if a future change to the draw breaks it,
  and the seed is then re-picked).


### Goals, verdict and stars

- Goals are evaluated from data the game already records: continental
  qualifying standings and the continental finals run (the board-objective
  grading already turns those into the finish scale), and the two
  head-to-head results against the rival for Grudge.
- The verdict is given as soon as it is settled: Grudge when its qualifying
  group ends (stars for qualifying/both wins settle then too); Transplant
  when the team is out of the European Championship or fails to qualify. Success needs at least one star.
- The verdict appears as a dedicated screen (title, result, stars, the run in
  numbers) reached from the hub, the same way other one-off events are, then
  the hub shows a "campaign complete" card.
- Getting sacked at the end of the cycle ends the campaign as a failure (if
  not already settled). The normal board keeps running alongside the
  campaign.
- The best result per campaign (stars, or failed) is remembered on the
  device (shared preferences, keyed by campaign id), so it survives
  abandoning, moving or deleting the run; the campaign list's stamp shows it.

### Where campaigns live (owner's decision)

Campaigns do not use save slots. A campaign in progress lives in the
Campaigns area, not in the saves list: it is resumed from its card on the
campaign list, and it never counts toward the save-slot limit (so a free
player with both slots full can still play every free campaign, and no
paywall appears). One run per campaign at a time: starting a campaign that
already has a run in progress asks whether to resume it or abandon it and
start again.

Once a campaign is settled (won or failed), the player may **move it into
the saves**: from then on it is an ordinary career in the saves list, counts
toward the slot limit, and follows the normal free/Pro rules (its second
cycle needs Pro, as for any career). If the slots are full at that moment the
player is told to free one first; moving is never required (a settled
campaign can also simply be abandoned from its card).

Technically: the campaign marker identifies a campaign career; a second
per-career key (`campaignMoved`) records that it has been moved into the
saves. The saves list and the slot count skip campaign careers that have not
been moved.

### After the verdict

The career carries on to the end of its cycle like any other. Twists last
for the campaign's length only (Claude's call): after the campaign's cycle,
a career moved into the saves plays normally (the five Italians stay with San
Marino, having switched allegiance).

### Screens

- **Home:** a "Campaigns" entry.
- **Campaign list:** a card per campaign: nation flag, title, twist, goal,
  star thresholds, difficulty label, Free/Pro badge, and its **stamp**: a
  "Conquered" stamp with the best stars earned, a "Failed" stamp if it has
  only ever been failed, none if never finished; a run in progress shows a
  Resume action instead of Start. The stamp is the visual centrepiece of the
  card, designed like a passport/approval stamp in the app's style, and is
  remembered on the device (it survives abandoning or deleting the run).
- **Campaign brief:** the intro story, rules and goal, manager name, Start.
- **Hub card:** the campaign goal and live progress ("Qualifying: 2nd, above
  Armenia on goal difference").
- **Verdict screen:** as above.
- Phone and tablet layouts for each (the tablet route sweep must include the
  new routes).

### Copy

All text in the seven app languages through the normal `.arb` route and
`copy/strings.csv`; no em dashes; never "World Cup"; Czech written naturally,
avoiding nation names after prepositions (use label: value forms), in line
with the copy review in progress.

## Calibration

A campaign's world is fixed (same draw, hosts and calendar for everyone, from
its seed), but match results vary from attempt to attempt exactly as they do
in the normal game (the live match's random salt). Claude's call: the seed
for each campaign is also chosen so the campaign nation is not a host of the
European Championship (hosts skip qualifying).

Before release, each campaign is played many times on autopilot with the
existing career driver (as the objectives lab did), varying the match
randomness, and the success rate and star distribution are reported. Target, Claude's call: an autopilot success
rate of roughly 20-50% for one star, three stars rare. Thresholds or twists
(e.g. which five Italians, Grudge's rival) are adjusted to land there.

## Constraints

- No schema change; existing saves and normal careers behave exactly as
  before.
- Deterministic: a campaign's world is the same for everyone (fixed seed),
  so it can be calibrated and tested.
- Free campaigns must never trigger the paywall.

## Left to the builder

Visual design of the new screens within the existing design system; the exact
wording of copy (in seven languages); which "run in numbers" stats the verdict
shows; where exactly the hub card sits; how the campaign list orders cards.

## Claude's calls (for the owner to check)

- Armenia as Georgia's rival (Russia is not in the game).
- The five Italians are the five highest-rated at the campaign's start.
- Twists last for the campaign's length; afterwards the career is normal.
- Naturalised players leave their old nation in the background simulation,
  in every career (a general fix).
- Same world for everyone, results vary per attempt; seeds avoid the
  campaign nation hosting the Euro.
- Stars are stored on the device per campaign.
- The normal board runs alongside the campaign; a sacking fails it.
- Calibration target: 20-50% autopilot success for one star.
