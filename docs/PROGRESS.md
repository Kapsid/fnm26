# FNM — Progress & Next Steps

_Last updated: 2026-07-13. Working tree is **uncommitted**; `flutter analyze` clean
(bar one pre-existing lint in `match_screen.dart:214`), **120 tests green**.
A release APK for everything below has been built (`build/app/outputs/flutter-apk/app-release.apk`)._

## How to deploy (wireless)
1. `flutter build apk --release`
2. Phone → Settings → Developer options → Wireless debugging → copy the **current** `IP:port`
   (it changes every time the screen sleeps / debugging re-enables).
3. `adb connect <ip:port>` → `adb -s <ip:port> install -r build/app/outputs/flutter-apk/app-release.apk`
4. Launch: `adb -s <ip:port> shell monkey -p com.fnm.fnm -c android.intent.category.LAUNCHER 1`

---

## DONE — "manager depth" batch (Opus session, 2026-07-13)

1. **Regen + retirement** — `lib/domain/services/player/player_lifecycle.dart`
   (`PlayerLifecycle.poolAt`). Pure derived, no migration. Retire at 37; 22 newgens/nation/cycle,
   ids ≥1e9 encoded `base + nationId*1e6 + bornCycle*1e3 + slot`. Wired into
   `DriftPlayerRepository.byNation/byId`. `byId` resolves retired legends (identity ≠ pool).
3. **Assists + per-match ratings** — `match_engine.dart`: `MatchEvent.assist*`,
   `MatchResult.ratings` + `manOfTheMatch`. Assists on an INDEPENDENT rng (scoreline unchanged).
   Ratings pure post-pass. UI: LINEUPS rating pills, STATS man-of-the-match. (Assist line on the
   timeline was later REMOVED per feedback.)
4. **AI opponent subs** — `lib/domain/services/match/ai_substitutions.dart`; fed into the preview +
   live re-sim via `MatchPreview.opponentSubs`.
6. **Out-of-position effective rating** — shared `lib/domain/services/tactics/position_fit.dart`;
   pitch node shows recalculated red rating e.g. `84→62`.
7. **Weighted hosts + biggest cities** — `hosts.dart` (square-law over top-8),
   `venues.dart` (biggest cities + stadium capacity shown in `venues_card.dart`).
5. **Nation vitrine** — `/nation?careerId&nationId`,
   `lib/features/nations/nation_vitrine_{providers,screen}.dart`. Honours, all-time scorers,
   ranking-history line chart. Entry: tap a row in World Ranking.

## DONE — playtest feedback fixes (same session)

- Assists removed from match timeline (`match_screen.dart`).
- Russia/Belarus self-heal: `SeedLoader._reconcileNations` prunes nations dropped from source.
- Age shown in squad pick-lists (`tactics_screen.dart`, `in_match_tactics.dart`).
- Same-position substitutes first (`PositionFit.bySlotFit`).
- Flatter quality curve after the top 23 (`pool_generator.dart`: anchor top-half, taper 1.06→0.62).
- Back button on country select (`nation_select_screen.dart`).
- "YOUR REGION" chip removed; player's group shown first (`cup_detail_screen.dart`,
  `continental_detail_screen.dart`).
- Hub standings colours now top-2 green (matches bracket screens) (`hub_screen.dart:_standingRow`).
- Hub no longer mislabels WC-quali as "Europe" — named "World Cup Qualifiers"
  (`career_providers.dart` buildCalendar Step 2).
- Friendlies vary per cycle (seeded shuffle over closest-60) (`friendlies_providers.dart`).
- Draw ceremony: flags in pots + reveal shows the group filling up (`draw_ceremony.dart`).
- Competitions as SQUARE TILES + Finalissima / Nations League "coming soon"
  (`tournaments_screen.dart`, single-scrollable `_tileGrid`).
- New persistent bottom nav **Hub · Squad · Standings · Careers**
  (`lib/shared/widgets/app_bottom_nav.dart`) + Careers hub
  (`lib/features/career/careers_screen.dart`, route `/careers`). Applied to hub, tactics, ranking.
- Red-card impact CONFIRMED already working (man down for the match + next-match suspension). No change.

---

## NEXT — remaining playtest items (need device iteration and/or a design call)

### A. Tournament scheduling flow (highest value, interlocking) — investigated, not started
Root causes (from code map):
- **WC-quali fixtures exist during the EURO** — `CareerService.buildCalendar` Step 2
  (`career_providers.dart:168-186`) writes ALL confederations' WC-qualifying fixtures up front at
  cycle start, ungated. **Fix:** move Step 2 out of `buildCalendar` and generate lazily once the
  continental finals complete, mirroring `SeasonService._generateContinentalFinals`
  (`hub_providers.dart:645-691`). Update `full_cycle_test`/`season_flow_test` which assert WC-quali
  fixtures exist early.
- **Flow the user wants:** host envelope → draw → fixtures generated (WC-quali not until EURO ends).
  Draws are currently purely presentational replays over already-persisted fixtures; moving fixture
  creation into the draw-consumption path is the same change as above.
- **EURO finals invisible when the player fails to qualify** — finals ARE generated & background-
  simmed, but no event fires: the CGROUP draw event needs a *player* fixture (`hub_event.dart:132`),
  and `hasFinals`/`watchTournament` is World-Cup-only (`drift_competition_repository.dart:601`,
  `hub_event.dart:246`, `hub_providers.dart:378-381`). **Fix:** add a `hasContinentalFinals` flag +
  a `watchTournament`-style event routing to the continental detail screen when the player isn't in
  the finals; ensure `advance` surfaces/【fast-sims those matchdays. (In-progress design; not coded.)

### B. Qualification-format realism — NEEDS A DESIGN CALL from the user
- "Advancing" highlight is hardcoded `advanceCount = 2` in cup/continental detail — wrong for WC
  qualifying (e.g. CONMEBOL single-table league qualifies ~6). Drive it from the qualification
  format / berths instead of a constant.
- South America Cup has no qualifying (CONMEBOL too small for a group stage → seeds finals). Real
  Copa América has no qualifying, but real CONMEBOL **World Cup** qualifying is a single 10-team
  double round-robin league (top ~6 qualify).
- **Question to resolve:** how "real" per competition? (Confederation-specific WC-quali formats +
  berth counts; continental qualifying counts.) Blocks q/v/w.

### C. Smaller items
- Show other nations' friendly results after playing a friendly (no other friendlies are simmed
  today — would need to generate a few plausible results for display).
- Tab spacing above competition detail tabs (ambiguous; confirm on device).
- "Skip draw" — the ceremony already has a Skip (fast-forwards the animation); confirm if the user
  wants a one-tap instant-draw that bypasses the screen entirely (call `markDrawWatched` + navigate).

---

## Suggested order next session
1. Get the app on device; validate this build.
2. Decide the format-realism question (B) — unblocks the qualification work.
3. Tournament flow (A): lazy WC-quali generation + continental-finals event, with updated tests.
4. Qualification visuals (B) once formats are decided.
5. Smaller polish (C).
