# Europe's World Championship qualifying: the real UEFA shape (handoff spec, 2026-11-18)

Status: BUILT (2026-11-18, cloud session). The owner chose option 2 for a European host (see "Open decision").

## Why (owner)

The owner sees Europe's qualifying sending "only the best through and some best runners-up". He wants the real UEFA picture:

- **1st place green.** The group winners go straight to the finals.
- **Every 2nd place orange.** All runners-up go to the play-off.
- **The runners-up table below the groups, as before.** Now it ranks the runners-up for the play-off pots; it no longer decides who is in.
- **Plus the Nations Cup route status.** Show which Nations Cup sides take the pot-4 play-off places.

## What the code does today

**Unmarked (pre-`calendar2`) cycles: old shape.**
- `QualificationFormat` Europe has `finalsBerths: 16`, groups of 5.
- `Qualification.qualifiers` fills the 16 places a POSITION AT A TIME: all winners, then the best runners-up.
- `GroupAdvancement.worldCupQualifying` paints those places green and the partly covered tier amber.
- This is what the owner is seeing.
- Leave it alone: unmarked cycles must stay byte-identical.

**`calendar2` cycles: `UefaWcPlayoffs`.**
- Code is in `lib/domain/services/competition/wc_playoffs.dart`.
- 12 groups (`groupCount`); the winners go through.
- `pathCount = (berths - groupCount).clamp(0, 4)`, where `berths = qualifyingBerths(hosts)`.
- `entrants()` takes the best `3 × paths` from the cross-group ladder (`CrossGroup.comparable`) for pots 1-3.
- Pot 4 takes `paths` Nations Cup sides: the second Nations Cup's best group winners that neither qualified nor finished runner-up, then down its overall ranking (`EuroPlayoffs.overallRanking`), then the world ranking.
- The problem: with a European host, berths are 15, so only 3 paths. Only 9 of the 12 runners-up get a play-off, and the other 3 drop out.
- `GroupAdvancement.worldCupPlayoffNations(playoffPaths:)` marks the "best runners-up, three a path".

**Related files:**
- `lib/domain/services/competition/group_advancement.dart`
- `lib/domain/services/competition/finals.dart` (`hostBerths`, `selectFinalists`, `playoffPoolFor`)
- `lib/features/hub/season_wc_playoffs.dart`
- `lib/features/tournaments/wc_playoff_providers.dart`
- `lib/features/tournaments/continental_detail_*`
- `lib/features/tournaments/cup_detail_*`, where the qualifying tables and marks are drawn. See the recent commits "Qualifying tables mark only what the tables show" and "the qualifying tables mark the sides on course for the play-off paths".

## What to build

**1. Always four paths on the new rhythm.** All 12 runners-up go to pots 1-3, ranked by the world ranking the day qualifying ends, as now. Pot 4 takes 4 Nations Cup sides by the existing rule.

**2. Table marks for Europe.**
- 1st is green.
- Every 2nd is orange (play-off).
- Below 2nd there are no marks. There are no "best third" or ladder marks.

**3. Runners-up table under the groups, as before.**
- The 12 runners-up on comparable records.
- The heading and legend say it seeds the play-off. All 12 rows are orange.

**4. Nations Cup route panel.**
- Shows the candidates for the 4 pot-4 places from the second Nations Cup.
- Each candidate is marked as **in** (holding a place), **out** (already qualified, or a runner-up, so it takes its place another way) or **open** (not yet decided).
- It is filled the way `entrants()` fills pot 4.
- The legend explains every mark. Recent commits already added "its own tag beside the name, and a legend for every mark" for the Nations Cup play-off route; build on that.

**5. Gate it.**
- Apply only to cycles with a NEW per-cycle `draws_watched` marker (e.g. `euroQuali2`), written at the cycle rollover.
- Unmarked cycles, including `calendar2` cycles without the new marker, stay byte-identical.
- Add a guard test, and re-pin the pinned-world tests only for the marked cycles.

**6. Copy.**
- Put every new string in all 28 ARB files with real translations, then run `flutter gen-l10n` and `dart run tool/export_copy.dart`.
- Convert `copy/strings.csv` back to CRLF.
- No em dashes. Never "World Cup" in English copy (it is "World Championship"). In Czech the Nations Cup is "Spojená liga".
- Display only: stored names stay canonical.

## Open decision: DECIDED, option 2 (owner, 2026-11-18)

With a European HOST: 12 winners + 4 path winners + the host = 17 for Europe's 16 places.

1. **(Recommended)** The host sits on top of Europe's 16. The finals stay at 48 because the intercontinental play-off shrinks by one (6 → 5 entrants; decide fairly which confederation loses its entrant, e.g. the lowest-ranked entrant's).
2. Only 3 paths in a host cycle: 12 runners-up + 0 Nations Cup, so the Nations Cup route disappears that cycle.
3. The weakest group winner drops into the play-off.

## Hard rules

- **Never break saves.** Prefer the marker and derived values, with no schema bump. If anything persisted changes, write a real old-save upgrade test.
- **Unmarked cycles stay byte-identical.** Never shift an existing RNG stream; add a salt.
- **The AI world** may change only in marked cycles, and only through this new format.
- **Every Nations Cup / continental lookup names its confederation**, and the edition where relevant: this uses the SECOND Nations Cup, edition 1.
- **Tests run with `TZ=Europe/Prague`.** Use targeted tests per change, then ONE full suite before a build. Known pre-existing failures: `test/unit/pitch/tactical_style_test.dart` and `test/widget/preview_tactics_reach_kickoff_test.dart`.
- **Riverpod without codegen.** `build_runner` needs `--force-jit`.
- **Tablet:** the qualifying screens have tablet layouts, so check both.

## As built

- **Marker:** `UefaWcPlayoffs.kind2` = `euroQuali2`, read by `isEuroQuali2`.
  - Stamped at `CareerService.create` for cycle 0 when the career is on `calendar2` (param `euroQuali2`, default true).
  - Stamped in `season_rollover.dart` for every new cycle.
- **Entrants:** `UefaWcPlayoffs.entrants(allRunnersUp:)` takes every runner-up (up to four a path), and the Nations Cup fills only what they leave.
  - With a European host: 3 paths, all 12 runners-up, no Nations Cup place (option 2).
  - Without one: the same 12 + 4 as before.
- **Draw:** `UefaWcPlayoffs.draw` cuts the runners-up (by rank) then the cup's sides into four pots. For the old shape's inputs this is the same draw, byte for byte.
- **Marks:** `GroupAdvancement.worldCupPlayoffNations(allRunnersUp:)` marks every runner-up.
  - The bar is unchanged: 1st green, no ladder below 2nd.
- **Screen** (`cup_detail_screen.dart`):
  - `PlayoffStripeLegend(allRunnersUp:)`.
  - `_RealShapeUnderTables`: the runners-up table (`BestThirdsCard` with `summary`, all yellow) and the Nations Cup route panel (`UefaWcPlayoffs.nationsCupRoute`: holds / qualified / runner-up / waiting, with a legend). In a host cycle, a note instead of the panel.
  - The tablet uses the same widgets.
- **Colour:** the existing play-off colour (`AppColors.playoff`, a yellow) rather than a new orange, to match every other play-off mark in the game.
- **Czech copy:** keeps "Pohár národů", the name used everywhere else in the Czech ARB. "Spojená liga" appears nowhere in it.
- **Tests:**
  - `wc_playoffs_test` group "the real UEFA shape".
  - `euro_quali2_marker_test`.
  - `wc_qualifying_playoff_marker_test`: real shape, host cycle, tablet.
