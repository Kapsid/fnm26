# Release 1.1.2: handoff (2026-11-14)

Where 1.1.2 stands, so work can continue in another session (cloud). Read with:
- `docs/superpowers/specs/2026-11-13-release-112-design.md` (stages 1-7, owner decisions)
- `docs/superpowers/specs/2026-11-07-real-world-playoffs-design.md` (the calendar realism spec the stages implement)
- `docs/superpowers/specs/2026-11-13-ui-redesign-112-design.md` (UI redesign, all done)

## Release state

- **In the stores:** 1.1.1 (49), built from `eb6fabac`, waiting for review (iOS + Android beta). Do not ship anything else as 1.1.1.
- **`pubspec.yaml` on main:** still `1.1.1+49`. Bump to `1.1.2+50` (or higher than the last uploaded build) when 1.1.2 is built.
- **Web editor:** a 1.1.1 build was made for upload (`www/editor/` on Active24). The 1.1.2 web editor must only ship together with the 1.1.2 apps: main writes pack format 8 (manager ages), which 1.1.1 cannot read.

## Done and on `main`

| Area | What | Gate / save safety |
|---|---|---|
| UI redesign | Record book (tiles), world ranking (team card + dense table), hub programme strip, full schedule (month cards + filters), set pieces in sub-tabs, press room (ticker + microphone, newspaper verdict) | UI only |
| Set pieces | Ordered takers: penalties and free kicks 1-3, corners left/right 1-2; engine takes the first listed man on the pitch | prefs JSON, additive; old JSON reads as before; single-taker results byte-identical (determinism test) |
| Stage 1 | Manager ages (own manager at career start, world managers shown, editor field, pack format 8); schema 57 incl. `DrawSlots` table and `Competitions.edition` | stepwise migration 56 to 57, real old-save upgrade tests, bundle carries DrawSlots |
| Stage 2 | `calendar2`: Europe Nations Cup twice a cycle (edition 0/1), ladder after each edition, Euro qualifying Mar-Nov Y+1, NC Finals Fours in June, WC qualifying draw after NC edition 2, CONMEBOL from Sep Y+2 | per-cycle marker `calendar2`; unmarked cycles unchanged |
| Stage 6 | Tournament spacing (`TournamentCalendar`, rest of 4+ days, staggered groups), weighted fatigue, one round popup per matchday, camp slack | own marker `tourSpacing1`; unmarked cycles unchanged (byte-identical guard) |
| Stage 3 | Euro play-offs via NC edition 1 (paths, one-leg semis 21 Mar, path finals 26 Mar), Euro finals draw with "Path X winner" placeholders stored in DrawSlots, ceremonies, board lock-in from DrawSlots | calendar2 only |
| Fixes | Picker names on one line (Android), manager-link duplicate keys, tablet route for the Euro play-off draw, Grudge verdict on the stored draw, a play-off tie lost on penalties ends the run | |

## Done on `claude/pensive-ride-htv7xa` (2026-11-15, not yet on main)

The branch holds `integ/stage4` merged with main, and on top of it:

| Area | What |
|---|---|
| Stage 4 | Merged. The Grudge test's normal-career twin now keeps the campaign's host rules (the two careers staged the 2030 finals in different countries; main matched only by luck). Story (a) re-found: Belgium, seed 31. |
| Stage 5 | CAF (best four below the group places, one-leg semis 1v4/2v3 and a final at the African Championship's host, rounds `AFSF`/`AFFINAL`: not `C`-prefixed, every reader takes `C` for the continental championship), AFC (2 places held back, the next six in two groups of three `AQ4`, winners through, runners-up in a TWO-LEGGED `AQ5L1`/`AQ5L2`), OFC (place held back, final `OFINAL` at the Oceania Cup's host, loser to the IC). Kind `worldCupQualifyingPlayoff`, DrawSlots per confederation, all in November W-1 after the last qualifier; the play-off and finals draws wait for them. `TwoLegged` (aggregate, ET and pens in leg 2 at the levelling margin, no away goals; engine `extraTimeAtMargin`, live screen, background sim and recorded result). `Fixture.shown*Score` takes the shootout goal off the side that won the kicks (identical for one-off ties). Watching, cup screen list, labels, round popup, Y stakes, board, qualifying-table highlighting. |
| Stage 7 (part) | NC promotion EUR 1M at the cycle's close (calendar2, both European editions) with news for every ladder move; play-off qualifiers already earn the finals prize; a preview press conference before a side's first play-off match. |
| Owner's list | Stadium size chosen when built (5k to 90k, priced by seats, `stadiumBuild2:` marker); match banners read a custom world's competition names; calendar2 groups never three home/away running (`balancedDoubleRoundRobin`); blue player-of-the-match star; whole names in the tablet's side column; goals in view (phone scoreboard, tablet left column); goal blink on the 2D picture; Player of the Year reads the manager's (engine-rated) matches on the world's scale; managers do not step far down while in demand; friendly opponents rest 2-4 best men; 'let the assistant take' a friendly; handballs (forked stream, results unchanged); a live group table and minute-by-minute same-day scores; a shot map at full time; next-match card on the nation page. |

Tests: run with `TZ=Europe/Prague` (pinned dates and the daylight test assume CET). Goldens fail wholesale on a Flutter other than the owner's (fonts); ignore them off the owner's machine.

## Done after the handoff (2026-11-15, same branch)

| Area | What |
|---|---|
| Player stats | Schema 58: six counters on `player_ratings` (penalties taken/scored in play; a keeper's shots on target faced, saves, penalties faced/saved). Engine matches fill them from the shot record; background matches give the keeper box-score-derived saves (no RNG). Player page tiles. Migration test 57 -> 58. |
| 2D picture | Offside line as the flag goes up (at the defending side's last outfield man, fading); keepers drawn at full stretch in a dive (read off the script's motion). More chances made on screen: through balls, one-twos and runs weigh more, an assist is played into space more often, a run with the ball takes on the defender who steps in (display only, results unchanged). |
| Bracket | `BracketTree`: ties ordered between their feeders, elbow lines (the manager's road in the accent colour), rounds to come as empty boxes, trophy and champion at the end, shootouts with their real score and kicks; full names on wide panes. |
| Y | Play-off draw posts: the draw leaves a `ypo:` draw-watched note (day, first opponent, competition), Y posts it as a landmark (`YTemplate.playoffDrawn`). |
| Tablet | The first goal no longer resets the left column's tab; the WC play-off draw route is tablet-ready and swept. |

## Still to do

1. **Campaign star odds:** re-tune with `test/story/campaign_lab_test.dart` (every calendar2 change moved the worlds); see the latest lab numbers in the commit that touches `campaigns.dart`, if any.
2. **Before the build:** full suite incl. slow stories; device playtest of a calendar2 cycle (CAF/AFC/OFC steps, the two-legged tie, the live table, the new bracket, penalties/saves on the player page).

## Known failing tests (pre-existing, not from 1.1.2)

- `test/unit/pitch/tactical_style_test.dart` (a few pitch-staging expectations)
- `test/widget/preview_tactics_reach_kickoff_test.dart` (hangs/times out)

## Rules that bite (owner)

- Never break saves: additive migrations; new world rules only from the next cycle via per-cycle `draws_watched` markers; real old-save upgrade tests for every schema bump; the career bundle carries every career table.
- Determinism: unmarked cycles must stay byte-identical; never shift an existing RNG stream (add a salt/stream instead).
- Copy: every string in all 28 ARB files (real translations), then `flutter gen-l10n`, then `dart run tool/export_copy.dart`, then convert `copy/strings.csv` back to CRLF. No em dashes. Never "World Cup" in English copy.
- Every Nations Cup / continental lookup names its confederation (and edition where relevant).
- Riverpod without codegen; `build_runner` needs `--force-jit`.
- Never `flutter install` on a device (it wipes data).
- Push only when asked; the GitHub account is Kapsid.

## Not in the repo (local machine only)

- Promo/store-shot harness (`integration_test/promo/store_shots.dart`, `store_capture.sh`, `promo_main.dart` edits, clip scripts) and the promo saves live in a local scratch worktree, untracked.
- Merged modders database `discord_modders_db.fnmdb` and the Kovac/Real Name source files are local only (real names: never commit).
