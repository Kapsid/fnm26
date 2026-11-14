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

## In progress

- **Stage 4 (UEFA WC play-offs + intercontinental play-off as real March fixtures + WC finals draw with placeholders):** finished on branch `worktree-agent-ad0f50c0a4ec5a142` and merged into `integ/stage4` (no conflicts, analyze clean). **Not merged into main yet.** The fast suite on `integ/stage4` (`flutter test --exclude-tags slow test/unit test/golden test/widget`) hung after ~3,000 tests and was stopped; before that it showed one NEW failure to fix first: `test/unit/campaign/campaign_verdict_event_test.dart` (Grudge verdict step budget; stage 3 already made this test compute "the step Georgia's place in the field is known" from the stored draws, stage 4 moves the world again; check whether the verdict still arrives when the Euro field is known or whether a WC play-off event now outranks it). Also seen: `test/unit/pitch/frame_budget_test.dart` (timing, likely machine load; re-run alone). Then re-run the suite in chunks to find where it hangs (compare with main), and merge `integ/stage4` into main. Summary: Europe 12 groups (winners direct), runners-up + best NC edition-2 group winners in 4 paths (semis 26 Mar W, finals 31 Mar W), IC with 6 teams all in the WC host nation, rounds `UPSF/UPFINAL` and `ICSF/ICFINAL`, three draws stored in Nov W-1.

## Still to do

1. **Stage 5:** CAF (4 best runners-up, SF + final, rounds CPSF/CPFINAL), AFC (4th round 2 groups of 3 in Oct, 5th round TWO-LEGGED in Nov, aggregate, ET + pens in leg 2, rounds AQ4/AQ5), OFC (final, loser to the IC, round OFINAL), reusable two-legged tie support; feed the IC entrants from these steps; the WC finals draw waits until they are decided. Kind `worldCupQualifyingPlayoff`, confederation-scoped. Not started (the agent was stopped before it wrote anything).
2. **Stage 7:** board and money (NC promotion EUR 1M; play-offs no own prize, a play-off qualifier earns what a direct one does), press triggers and Y posts for the play-off draws and results and the mid-cycle ladder move, news, re-tune campaign star odds (Transplant, Grudge, Legacy, Guineas, Young Finns, Greenland, Zanzibar) with `test/story/campaign_lab_test.dart`.
3. **Before the build:** full suite incl. slow stories; time `end_of_cycle_has_a_next_action_test` on main (one seed took 104 minutes on stage 4, unclear whether that predates it); device playtest of a new career through a whole calendar2 cycle (play-offs, ceremonies, knockouts stepping day by day on the new spacing).

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
