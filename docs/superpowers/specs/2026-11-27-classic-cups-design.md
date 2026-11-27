# Classic Cups

Date: 2026-11-27 · Status: approved by the owner's brief 2026-11-27 · pricing
revised 2026-11-27 (four editions free, three with Unlimited)

## What it is

A new way to play, beside careers and campaigns: replay a past World
Championship finals in its real format, with its real hosts and its real
group draw, in one sitting. Pick an edition, pick any of its nations, play
from the first group match to the final or to elimination. Each edition has
medals to collect.

Seven editions: 2026, 2022, 2018, 2014, 2010, 2006 and 2002.

## Why

The career is a four-year cycle; some evenings a manager wants one
tournament, now. Real draws make the run instantly readable ("Group of death
with Spain and the Netherlands"), and the medals turn seven tournaments into
dozens of goals worth returning for: win with every nation, rewrite history,
win with a minnow from every confederation.

## Goals

1. A Classic Cups tile on the home screen opens the edition picker.
2. Edition → nation pick, showing the real group, a strength meter and the
   medals the nation already holds.
3. Group stage, knockouts and final played with the game's match engine,
   with injuries and suspensions carried from match to match.
4. A run is resumable and can be abandoned.
5. Medals per edition and overall, stored on the device, with a Medals
   screen showing progress counts.
6. An editor section to edit any edition's teams: strength, kit and players.

## Non-goals (first version)

- Qualifying, board, transfers, growth, press, world managers.
- The career's own match screen and call-up screens (they read a career
  save end to end; see "Reuse" for what is reused instead).
- Cloud sync of medals.

## Anti-goals (licensing, hard rules)

- **No real players.** Every player is generated from the nation's name pool
  through the same real-name guards the game uses (every list in
  `real_internationals.dart`); a strong 2002 Brazil is strong through ratings,
  never names. No real player is named in data, copy, comments or tests.
- **No trademarks.** Never "FIFA", never "World Cup": editions are labelled
  "World Championship 2002 · Korea & Japan", in each language with the game's
  existing name for the World Championship. No logos, emblems, mascots, ball
  names or slogans. Medals are drawn with Material icons.
- **Grounds** follow the game's practice: real host cities, ground names from
  the game's own generator (`Venues.gameGroundName`), never a real stadium
  name.
- A licence audit test scans the new assets and all 29 languages' new copy.

## Data

One JSON file per edition, `assets/data/classic/<year>.json`:

- `year`, `hosts` (nation ids, primary first), `hostLabel` (an l10n key
  suffix for "Korea & Japan"), `free` (pricing), `teams` (32 or 48),
  `opener` date, a `calendar` template (group matchday gaps and knockout day
  windows, as `TournamentCalendar` reads them), `cities` per host with seats,
  `opening` and `final` city;
- `groups`: name → nation ids in the real draw order (position 1 to 4);
- per team: `nation`, `pot` (where the draw used ranking pots), `overall`
  (the XI's mean rating), `star` (the best player's rating), `depth` (the
  bench's mean), `style` (a `NationStyle` name), and optionally `display`
  for an edition-only name;
- `result`: `champion`, `runnerUp`, `third`, `fourth` by nation id.

Ratings are written fresh for each edition from that era's reputation: the
ranking at the time, results, golden generations. The current database is
never aged down.

### Nations that changed or are missing

- **Serbia and Montenegro (2006)** plays as Serbia's nation id with the
  edition-only display name `serbiaMontenegro` (localised).
- **Russia** (2002, 2014, 2018 host) is not in the game's world. Classic Cups
  carries it as a classic-only nation (id 44, the retired id; code `RUS`,
  its own localised name and flag file). It exists only inside Classic Cups;
  no career ever sees it. Its name pool is a classic-only pool.
- **Czech Republic (2006)** plays as Czechia, its current name.

## Format

- **2002–2022:** 8 groups of 4, single round robin in the official matchday
  order (1v2 3v4, 1v3 4v2, 4v1 2v3), top two through. Round of 16 with the
  real pairings: 2006–2022 1A–2B, 1C–2D, 1E–2F, 1G–2H, 1B–2A, 1D–2C, 1F–2E,
  1H–2G (reusing `WorldCupFinals.roundOf16`); 2002 its own 1E–2B, 1G–2D,
  1B–2E, 1D–2G, 1A–2F, 1C–2H, 1F–2A, 1H–2C. Then QF, SF, third place, final.
- **2026:** 12 groups of 4; top two plus the 8 best thirds (the game's
  `CrossGroup` ranking) into the official round of 32 (matches 73 to 88),
  then the official round-of-16 and later pairings. The eight thirds are
  slotted into the eight winner slots that take a third (1A, 1B, 1D, 1E, 1G,
  1I, 1K, 1L), each slot only from its official group set (for example 1E
  meets a third from A, B, C, D or F). The game's own World Championship
  seeds its round of 32 by rank and has no slotting table, so Classic Cups
  adds one: a deterministic matching over the official eligibility sets.
- Group ties: points, goal difference, goals scored, head to head, then a
  seeded lot.
- Knockouts: extra time and penalties through the engine
  (`extraTimeIfLevel`) and `WorldCupFinals.decideKnockout`.
- Dates: `TournamentCalendar.groupDate` and `knockoutDates` with the
  edition's own template, so the group matches are spaced as the real
  tournament was and the knockout days fall in the real windows.

## Squads

Generated deterministically from the edition and nation (`year`, `nationId`
seed): 23 players (26 in 2026, the real squad size), positions balanced like
the game's seeded squads (3 keepers, 8 defenders, 7 midfielders, 5 forwards
for 23), ages 19 to 35 weighted to the peak years, ratings shaped from the
team's `overall`, `star` and `depth`. Names from the nation's current pool
(`currentNamePool`), never a name on any real-name list. The same squad for
everyone until the editor changes it.

## Play flow

- **Home:** a Classic Cups tile beside Saves and Campaigns.
- **Edition picker:** the seven editions, newest first: label, hosts, field
  size, champion's flag, medal progress, a lock on Unlimited editions.
- **Edition page:** every group in the real draw; each nation shows its
  strength meter and a medal mark if it already won this edition. Tapping a
  nation opens its sheet: group, strength, medals with it, Start (or Resume /
  Abandon when a run exists).
- **Run hub:** the next match (opponent, date, city, ground) with Play; tabs
  for Group (all tables, live), Bracket (`BracketTree`), Squad (formation,
  playing style, the XI with injured and suspended men marked, tap to swap).
- **Match:** the engine plays the whole match; the screen runs it on a clock
  (speed control), with the score bug, the event feed and the full-time
  summary. The other matches of the day are simulated with the same engine.
- **End:** champion or elimination screen, medals earned, back to the
  edition page.

Injuries: an injury rules a man out for 1 to 3 matches. Suspensions: a red
card is a one-match ban; two yellows in separate matches are a one-match ban;
single yellows are wiped after the quarter-finals.

## Reuse

The match engine (`MatchEngine.play`), `bestEleven`, `AiTactics`,
`WorldCupFinals` knockout helpers, `CrossGroup` ranking,
`TournamentCalendar`, `BracketTree`, `CountryFlag`, `Venues`, nation display
names, the playstyle labels, the paywall. Saves: none of the career tables;
see Storage.

## Storage

No schema change. Shared preferences, like campaign records:

- `classic_run_v1:<year>`: the run in progress (one per edition).
- `classic_wins_v1`: every finished run (edition, nation, champion, unbeaten,
  beat the real champion, golden boot, eliminated), the source of medals.
- `classic_edits_v1`: the editor overlay (per edition and nation: strength,
  kit, and per player name, position, ratings, age).

## Medals

Per edition:

| Medal | Earned by |
|---|---|
| Champion | Win the edition with any nation |
| Collection | Win with each nation (shown as 7 of 32) |
| Continents | Win with a nation from each confederation present |
| Giant-killer | Win with a pot-4 nation, or one in the bottom third by strength |
| Rewrite history | Knock out the edition's real champion |
| Unbeaten | Win without losing a match (shootouts count as draws) |
| Golden boot | One of your players tops the tournament's scorers |

Overall:

| Medal | Earned by |
|---|---|
| Grand slam | Win all seven editions |
| Seven flags | Win with seven different nations |
| Every confederation | Win with a nation from each of the six confederations |
| One nation, every era | Win every edition with the same nation |
| Perfectionist | Earn every medal of one edition |

Medals for an edition locked behind Unlimited show as locked. Achievements
are not touched: they are per career.

## Pricing

2026, 2018, 2014 and 2006 are free. 2022, 2010 and 2002 need Unlimited
(`premiumUnlockedProvider`): they show a lock, can still be browsed (hosts and
groups), and starting one opens the paywall. The paywall gains a benefit line,
`paywallBenefitClassicCups`.

## Editor

A Classic Cups section in the editor: editions → teams → team page
(strength sliders, kit colours, players) → player page (name, position,
ratings, age). Edits are an overlay over the generated squad; "Reset" drops
the overlay of one team. User-typed names are the user's content.

## Copy

All new strings in the 29 ARBs; French with a no-break space before colons;
Serbian through the shared `extra.json`. "Classic Cups" translated naturally.

## Claude's calls (for the owner to check)

- Russia is carried as a classic-only nation so the 2018 host and its 2002
  and 2014 groups are exact.
- The 2026 thirds are slotted by an eligibility-respecting matching rather
  than a transcription of the official 495-row table.
- Venue per group match is dealt across the host cities, opener and final
  in their real cities; exact per-match venues are not reproduced.
- One run per edition at a time.
