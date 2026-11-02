# Final cross-feature review: 1.0.7 batch 2 (asia quali, hosting v2 + fixes, Y reactions, stadium map)

Read-only. Nothing edited, staged, formatted or restored. `dart analyze lib`: 0 errors, 0 warnings (613 infos, line length and the like). Flutter tests were not run (the suite holds the lock). Copy sweep by script (scratchpad/frev2/copycheck.py) over all 28 ARBs.

Verdict: **ISSUES**. One medium, tone only. No path changes stored results or money, the rollover is ordered correctly and is safe to retry, and 1.0.6 saves open through every new path. The rest are lows and notes.

## Issues

### 1. MED (tone): Y now fills the whole "humiliation" room after a narrow defeat by a near-equal side
- **Where:** `lib/domain/services/press/y_feed.dart:622` (humiliating = heat 3), `:937` (heat 3 brings in the neutral account and the away fans), `:584` (`lostShock`). Thresholds at `lib/domain/services/press/expectation.dart:117,120`.
- **Cause:** `Expectation` cuts "humiliating" at surprise <= -1.15. A one-goal defeat scores `-1 - expected`, with `expected = gap/60`. So a defeat by a side only **9 places lower** already counts as humiliating. Before batch 2 that drew 3 voices and the plain `lost` wording. Now it is heat 3:
  - `lostShock` ("a side we should beat comfortably");
  - the pundit;
  - `neutralLoss` ("a neutral account on our humiliation");
  - `awayFansGloat`;
  - and every reply voice.
- **Uneven:** a heroic win needs the opponent at least 15 places higher (1.25), so defeats reach full volume more easily than wins do.
- **Disagrees with the minnow board:** `BoardSatisfaction.isHumiliation` (board_satisfaction.dart:141) needs a margin of 4 or more against a fellow minnow. A 0-1 between two bottom-30 sides is a plain defeat to the board (minnow weight -2), but Y treats it as a disgrace.
- **What does hold:** a heavy defeat by a giant does NOT flood the feed. Greenland 0-7 Germany scores surprise 0 (par), reaches heat 2 from the margin only, and gets the `lostRout` "not a disgrace" wording from stats, fan and pundit, with no gap desk, neutral or away fans. That matches the board, which charges 0 for a defeat as clear underdog.
- **Failure:** Germany (1st) loses 0-1 to the Netherlands (10th) in a qualifier and gets 5 to 7 posts of "humiliation" with gloating Dutch fans. Or a 180th-ranked minnow loses 0-1 to the 205th side, the board shrugs, and the feed calls it a disgrace.
- **Fix (any one):** let a humiliating standing reach heat 3 only with a margin of 2+ or a gap of ~25+. Or make the neutral account and away fans wait for heat 4 on a one-goal defeat. Or give Y its own humiliation cut of about -1.4.

### 2. LOW: a hosted finals ignores the estate the bid was won with
- **Where:** `lib/features/tournaments/tournament_summary.dart:54` and `lib/domain/services/match/attendance.dart:66` read `VenueGenerator.forHosts` (static curated grounds). Only a non-neutral home game uses `careerStadiumsFor` (match_providers.dart:537).
- **Failure:** a manager builds two Arena Novas to reach "4 grounds of 40,000+", wins the World Championship bid, and the venues card and finals crowds show only the curated grounds. His new stadiums appear on the map and count for the bid, but stage nothing.
- No money or results are involved.

### 3. LOW (dev saves only): old stadium works can drop off the estate
- **Where:** `lib/domain/services/federation/national_stadiums.dart` `forNation` / `nationalSet` (take(8) by seed order).
- Batch-1 `stadiumUp:` and pre-fix `stadiumSize:` markers name the city of the old tapered estate. Where that city is not among the curated top 8, the paid work now sits outside the national set: no income, no map pin, no eligibility. It still counts for reputation and for home games.
- No 1.0.6 save has markers, and the last device APK (24 Oct 08:47) predates the stadium and bid work. So only test or dev saves are affected.

### 4. LOW (cosmetic): the play-off final scores as a trophy final
- **Where:** `y_feed.dart:601`: `'POFINAL'.endsWith('FINAL')`, so the intercontinental play-off final gets +2 heat, the same as a World Championship final.
- **Failure:** a play-off final win reaches heat 5. Arguably deserved, but it was probably not intended.

### Notes (no action needed)
- Y uses today's ranks, not the ranks on the day of the match (already known). Greenland's defeats keep being read as par, so this is harmless here.
- When the manager switches nation, the old nation's last stadium income goes to the new federation (documented decision 4).

## 1. Rollover: order and retry safety, OK
Order in `season_rollover.dart`:
1. `resolveDue(atRollover)` (:22) decides any older bid that is still open.
2. `rolloverMoney` (:77): balance + negotiated income - wages + stadium income. The stadium income is capped at 10% of the closing cycle's grant (`incomeAt`, national_stadium_providers.dart:400). The screen uses the same cap and the same grant (:231).
3. One transaction (:91-126), in this order:
   - re-check `cycleBanked`, then return on a retry;
   - `settlePledges`: pays each pledge and writes the real `hostBid:` marker; a pledge lapses with a message for the wrong nation or a funds shortfall;
   - the investment;
   - `setBudget`;
   - the `cycleBanked` marker;
   - the `stadiumIncome` marker.
4. `resolveDue(atRollover)` (:131) decides the new bids. It runs its own transaction with the result marker re-checked, so the grant is paid once.
5. Ladders, nation switch, `advanceCycle`, then `buildCalendar` on `forCareer` nations. `forCareer` attaches the bids uncached (drift_nation_repository.dart:64), so continental qualifying for c+1 is built without the host.

What holds:
- **Pledge charge and income are paid once.** A retry finds `cycleBanked` and banks nothing again.
- **Crash between steps 3 and 4:** the retry's step 1 decides the bid, and the grant is paid once (the `_decide` transaction).
- **Pledges stay coverable.** `place` checks free funds with the same `rolloverMoney` sum and the same next-cycle wages that `settlePledges` subtracts.
- **The host draw itself** (`hosts.dart`) reads no stadium data. The lodged chance is frozen in the marker. So the curated estates cannot move any host, past or present.
- **WC host berths:**
  - WC qualifying is built lazily in January of wcYear-1, after the rollover, so the bid-decided host is known and sits out.
  - `resolveWorldCupHostBerths` locks `wcHostBerths` before the play-off and finals snapshots (season_finals.dart:37, :225).
  - The old-rule check (`finalsGroupTables`, seed snapshots) is cycle-scoped (`_tournamentComp` filters by cycle), so later cycles get the new rule.
  - No bid can be placed for an edition whose qualifying already exists: `place` requires `editionCycle == cycle+1` and a WC champion.

## 2. Curated stadiums against stored data, OK (display only)
- **Not stored:** venues, attendance and capacities are never stored. Fixtures, scores, and the stored messages hold no venue or crowd.
- **Money:** federation income does not read attendance (grep of federation_service, federation_providers, federation_finance).
- **Past matches:** past tournaments' venue cards and ground cards now show the real grounds and capacities. That is a minor display change, as allowed.
- **Atmosphere:** it feeds only the manager's match engine for a match not yet played, so stored results cannot change.
- **Base camps** (`TrainingCamps.forHost`) read country_cities.json, which this batch left unchanged, so stored camp indices still resolve to the same camps.

## 3. Map and estate, OK
- **Assets:** 210 geo files, Greenland (212) included, and `assets/geo/` is in pubspec.
- **Pins:** come from `view.stadiums` (the national set, built grounds included, hollow while being built). A city with no position is filtered out through `boxOf == null` and never hits the `cities[c]!` lookups, so nothing can crash. Tests assert every seed, curated and extra-host city has a position.
- **Builds:** candidates are `cities[nationId]` minus built cities, all positioned. A build adds a built ground to the set, which shows a ring and then a marker.
- **Resizes:** a resize from the sheet or the list goes through the shared order helpers, and those invalidate `nationalStadiumsViewProvider`, so the marker's size and colour follow. Pin indices stay stable because `nationalSet` keeps seed order, not capacity order.

## 4. Y magnitude with Greenland and the minnows: see issue 1
- A heavy defeat by a giant behaves as the board does.
- A narrow defeat by a near-equal side is over-loud for every nation, minnows included.

## 5. 1.0.6 saves, OK
- **No markers:** the rollover finds no pledges, pays the capped stadium income once, and runs the normal banking.
- **Host-bid status:** with no markers it reads the rotation from recomputed hosts, which are the same as before.
- **WC berths:** a cycle still in qualifying moves to the new berth rule (documented). A cycle with a seeded play-off or finals keeps the old rule.
- **Y:** old fixtures without penalties give `shootoutWon` null. Ranks fall back to the seed ranking or the total.
- **Map:** every nation has a file.
- **compat_105:** passes 4/4 per the ledger, with saves in `.superpowers/saves105`.
- `dart analyze` is clean.

## 6. Copy, OK
- **Keys:** 3041 keys in each of the 28 ARBs, 460 new against HEAD. None missing, none extra.
- **Placeholders:** top-level placeholders and ICU argument names match app_en.arb in every locale.
- **Em dashes:** none anywhere.
- **World Cup names:** none in any language. The checked phrases are every banned name in new_languages_naming_test plus the first languages' own names, and the es/pt noun "Mundial". The script flagged two hits, both false: pt "(Campeonato Mundial" (the adjective) and ro "Campioni mondiali" (it contains the Italian-only phrase "i mondiali").
- **Other text:** no em dash in national_stadiums.json, and no banned name in the new Dart string literals.
