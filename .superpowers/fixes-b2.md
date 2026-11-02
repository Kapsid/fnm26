# Fixes from final-review-b2 (items 1, 2, 4) plus lower bid conditions

Nothing staged, stashed or restored. `dart format` only on the files changed. No copy changed.

## 1. MED: Y defeat threshold (review issue 1)
- `expectation.dart`: `_humiliatingAt` -1.15 -> -1.25. A one-goal defeat is now humiliating only against a side at least 15 places lower, the mirror of a heroic one-goal win (15 places higher).
- To keep the board's idea (a heavy defeat by a peer is a humiliation), each goal of a defeat past the third adds 0.1 to the margin weight (max 2 extra goals). 0-4 between equals is still humiliating; 0-3 is poor. The win side is unchanged.
- `y_feed.dart` `magnitudeOf`: a humiliating defeat starts at heat 3 only with a margin of 2+ or a gap of 30+ places below (`humiliationGap`). Otherwise heat 2: stats, fan, pundit and `lostShock`, but no neutral account or away fans.
- Results:
  - Germany (1st) 0-1 v 10th: poor, `lost`, heat 1, no shock or humiliation posts.
  - 180th 0-1 v 205th: `lostShock` at heat 2, with no neutral account or away fans.
  - Big upsets are unchanged: 5th 0-3 v 90th is still heat 4+ with the full room.
- Tests: `test/unit/press/y_magnitude_test.dart` (15-place symmetry, Germany 0-1, minnow shock, the room still fills on margin 2 or gap 30+); `test/unit/press/expectation_test.dart` (0-3 between equals is poor).

## 2. LOW: hosted finals use the live estate (review issue 2)
- `VenueGenerator.forHosts(estates:)` and `Attendance.forFixture(hostEstates:)`: a host listed there gets its share from the estate, biggest first. Other hosts keep the static grounds.
- `hostEstatesFor(ref, careerId, hostIds)` in `national_stadium_providers.dart` returns the career nation's open estate for the current cycle: built Arena Novas plus enlarged or downsized grounds. It returns nothing when that nation is not a host or has no stadium works. So an untouched estate and every AI host are byte-identical to before.
- Wired into:
  - `CupData` / `ContinentalData` -> `TournamentSummaryTab(hostEstates:)`;
  - the match ground and crowd in `match_providers.dart`.
- Venues are never stored (review section 2), so no stored venue can change. Only the current edition's card and the crowds of matches still to be played read the estate.
- Tests:
  - `test/unit/match/neutral_venue_test.dart`: the estate replaces the static list, co-hosts are untouched, the final is in the Arena Nova, and crowds fit the estate.
  - `test/unit/federation/national_stadiums_flow_test.dart`: an upgrade shows in `hostEstatesFor`, which equals the home-game grounds; it covers only the career nation and is empty before any work or when not hosting.

## 3. LOW: play-off final is not a trophy final (review issue 4)
- `YFeed.stakesOf('POFINAL')` -> `YStakes.knockout` (`YFeed.playoffFinalRound`).
- Test: in `y_magnitude_test.dart`, the play-off final has the same heat as a knockout and less than a trophy final.

Review issue 3 (dev saves only): left as accepted.

## 4. Extra: lower hosting conditions (revised numbers), chance model untouched
`host_bidding.dart` `HostingRequirements` and its doc table:

| Tournament | Grounds | Big grounds |
|---|---|---|
| World Championship | 6 of 15k+ | 3 of 30k+ |
| Europe / Africa / Asia | 5 of 15k+ | 2 of 20k+ |
| North / South America | 3 of 10k+ | 2 of 15k+ |
| Oceania | 2 of 5k+ | 1 of 10k+ |

Eligible at the start, measured by `test/unit/federation/national_stadiums_test.dart`:

| | Europe | S. America | N. America | Africa | Asia | Oceania |
|---|---|---|---|---|---|---|
| World Championship (was) | 14 (7) | 8 (5) | 3 (3) | 9 (4) | 14 (10) | 1 (0) |
| Own championship (was) | 20 (14) | 10 (10) | 7 (3) | 15 (9) | 19 (14) | 5 (3) |

- Tests updated:
  - the count maps and shortfall example in `national_stadiums_test.dart`;
  - `national_stadium_data_test.dart`: Chile, Nigeria and Tanzania now reach the World Championship. Kuwait is the "own championship only" case. Cambodia, Kenya, Andorra and Czechia are still out.
- The copy takes the numbers as placeholders, so no copy changed.

## Verification
- `ftest.sh`, 591 tests, all passed:
  - test/unit/press (all)
  - host_bid_flow, host_bid, hosts_venues, honour_cohosts
  - national_stadium_data, national_stadiums_flow, national_stadiums, neutral_venue
  - widget: host_bid_budget, host_bid_screen, national_stadiums_screen, stadium_map, venues_card, cup/continental_detail_tablet, y_* and press_*
  - golden: phone_guard_y
- `dart analyze lib` + the touched test dirs: 0 errors, 0 warnings.
