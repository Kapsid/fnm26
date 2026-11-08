# Calendar realism: real-world play-offs, a two-year rhythm, tournament spacing, host stadiums

Date: 2026-11-07. Status: design draft for the owner. No code written.
Sources: player feedback (two messages: the WC half of the cycle, then the Euro half and match spacing) and the owner ("play-offs like the real world, all of them but really working and watchable"; "the World Cup should not be played at 8k, these may need to co-host").

## 0. Save compatibility (decided first, because the calendar is baked into saves)

- **New cycles only.** A per-cycle marker `calendar2` (a `draws_watched` kind, like `fluidWindows1` / `briefRules2`, see release-106) is stamped at career creation and at every rollover by the new build. Every reader below branches on it. A cycle without it plays out to the end on today's calendar, today's play-off and today's 3-day tournament spacing. The next rollover (September of the WC year) starts the new calendar. A brand-new career (opens July 2026) is on it from day one.
- **Hosts:** host rules are already gated per edition by `hostRules:` markers (`HostBidding.rulesKind`). The stadium rule adds a `hostRules2` marker for editions decided from now on. Editions already decided (which covers every host a save has shown) never move. The forward `_wcHostChain` must keep reading the old rule for unmarked editions.
- **One schema bump (54 to 55), using the stepwise migration recipe** (schema-bumps-preserve-saves):
  - a `DrawSlots` table (career, cycle, competition kind, confederation, group, position, nation id or placeholder key, resolved nation id) holding any draw that contains placeholders;
  - `Competitions.edition` (default 0), so that a cycle can hold two Nations Cup editions.
  - Old rows stay valid through the defaults. The career bundle export/import (save-portability) must carry `DrawSlots` and remap its ids.
- **Legacy paths stay:** the cycles without the marker keep `wcPlayoffStreamKind`, `playoffLegacyStream`, the deterministic `playoffBracket` and `VenueRules.original`. Nothing is deleted.

## 1. What exists today (1.1.0 / 37)

| Area | Today | Where |
|---|---|---|
| Cycle | Opens Sep of WC year Y (cycle 0 opens Jul 2026). | `CareerService.cycleOpens`, `worldCupYear` |
| Euro qualifying | Groups of 6, Sep Y to Jun Y+1 (`CQ`). The finals are drawn as soon as CQ is fully played (about Jul Y+1), top N straight from the tables. **No play-offs.** | `CareerService.buildCalendar`, `SeasonService._generateContinentalFinals` |
| Continental finals | Jun Y+2 (Africa/Asia Jan Y+2). Group matchdays every **3 days**, all groups on the same day; first KO round +5 or +7 days, then +4 per round. | `saveTournamentGroups` (`drift_competition_repository.dart`), `_advanceTournamentKnockout`, `_progressContinental` |
| Nations Cup (Europe) | **One edition per cycle**: league phase Sep to Nov Y+2, Finals Four in June Y+3 (18th/21st). The NA ladder sits in the same slot. Africa has zones plus NR16 to NFINAL in Nov Y+2. | `buildCalendar` step 1c, `season_cycle.dart` |
| WC qualifying | Drawn lazily in Jan Y+3 (`wcQualifyingDrawMonth`), Mar to Nov Y+3. CONMEBOL is a single league running to Mar Y+4. Europe plays groups of 5 (53 nations, so 11 groups); its 16 places go to winners plus best runners-up. | `buildWorldCupQualifying`, `QualificationFormat` |
| Play-offs | **Only the 6-team intercontinental play-off.** Entrants are the next-best of each confederation (CONCACAF 2; CONMEBOL, CAF, AFC, OFC 1 each); the two best-ranked get byes. Only the **manager's own ties** are fixtures (`POSF`/`POFINAL`, dated in-game date +7). Every other tie is an RNG bracket that is never played, so it can't be watched. No UEFA paths, no CAF/AFC/OFC play-off steps, no Euro play-offs. | `season_finals.dart` `_progressPlayoff`, `playoff_paths.dart`, `WorldCupFinals.playoffPoolFor/playoffBracket` |
| WC finals draw | Held only after **all** qualifying **and** the play-off are done (about April Y+4). There are **no placeholder slots in any draw.** The finals open on 11 Jun Y+4. Groups are 3 days apart, then R32 at +7. | `_generateFinals`, `saveFinals` |
| Draw ceremonies | Read the stored groups (`drawn_groups.dart`); a draw is never re-run for display. | finals/continental/qualifying draw providers |
| Hosts | Chosen by **ranking**, with random co-host rolls and an occasional outsider. **No stadium requirement.** Venues are derived, not stored: real grounds come from `national_stadiums.json` (at most 10 per nation), and extra cities are tapered off the biggest ground (rank 8+ is about 26% of it). `countForField`: 48 teams = 16 venues. The player's host bid is solo only; its odds read the seats of the 8 biggest grounds. | `hosts.dart`, `venues.dart`, `host_cities.dart`, `host_bidding.dart`, `host_bid_screen.dart` |
| Fatigue | Counts the games in a 14-day window, so spacing changes nothing: 3 games in 7 days and 3 games in 11 days both read "tired". | `squad/condition.dart` |

## 2. The target four-year rhythm (Y = WC year; one cycle = Sep Y to Aug Y+4)

| When | Europe | Rest of world |
|---|---|---|
| Sep–Nov Y | **Nations Cup edition 1**, league phase (cycle opens here) | Continental qualifying as today (Sep Y to Jun Y+1) |
| Dec Y | Euro qualifying draw. The four NC finalists go into the 5-team groups, so their June is free | |
| Mar, Jun, Sep, Oct, Nov Y+1 | **Euro qualifying**. NC edition 1 Finals Four in **June Y+1** (semis 4th/5th, final 8th) | |
| late Nov Y+1 | Euro play-off draw (paths from NC edition 1) | |
| early Dec Y+1 | **Euro finals draw** with "Play-off Path A/B/C winner" placeholders in pot 4 | |
| Jan Y+2 | | AFCON / Asian Cup (unchanged) |
| Mar Y+2 | **Euro play-offs**; non-entrants play friendlies | |
| Mar–early Jun Y+2 | 3–4 friendlies and warm-ups (existing friendlies event and `warm_ups.dart`) | |
| Jun–Jul Y+2 | **EURO** (new spacing, §5) | Copa, Gold Cup, Oceania Cup |
| Sep–Nov Y+2 | **Nations Cup edition 2**, league phase | CONMEBOL WC qualifying starts Sep Y+2 (18 matchdays need Sep Y+2 to Nov Y+3) |
| Dec Y+2 | WC qualifying draw for every confederation except CONMEBOL (moved from January). NC edition 2's finalists go into the 4-team groups | |
| Mar, Jun, Sep, Oct, Nov Y+3 | **WC qualifying**: groups of 5 play Mar–Nov, groups of 4 play Sep–Nov. NC edition 2 Finals Four in **June Y+3** | CAF/AFC/OFC/CONCACAF groups, then their own play-off steps (§3.3) |
| ~20 Nov Y+3 | UEFA play-off draw (Paths A–D) and intercontinental play-off draw, each with its own ceremony | |
| ~5 Dec Y+3 | **WC finals draw** with "UEFA Path A–D winner" and "Intercontinental Path 1/2 winner" placeholders in pot 4 | |
| late Mar Y+4 | **UEFA play-offs and the intercontinental play-off** in the same window | |
| Jun 11–Jul 19 Y+4 | **World Championship** (48 teams, R32) | |

How the two halves fit together:
- The two halves mirror each other: Nations Cup in the autumn, qualifying across the next year, play-off draw in Nov, finals draw in Dec, play-offs in March, finals in summer.
- **The Nations Cup feeds both play-offs, as it does in reality.** Edition 1 seeds the Euro play-off paths; edition 2 supplies the 4 best group winners for the WC paths.
- Each edition's Finals Four sits in the June of the following qualifying year. That is safe because NC finalists are always drawn into qualifying groups that do not play in June.
- **Answer to the player's question:** the Nations Cup sits in **Sep–Nov, not Sep/Oct and not Oct/Nov.** Its six matchdays need all three autumn windows (2 per window), which is what the real Nations League uses. Today's fluid windows already deliver this, so it needs no change for edition 2.
- Not modelled: the real March NL quarter-finals. March Y+1 and March Y+3 are qualifying windows, and the Finals Four alone keeps the June conflict-free.

## 3. Play-offs (every one is a real competition)

The same contract applies to all of them:
- a **stored** draw and its ceremony (never re-drawn for display);
- **every** tie is a fixture on the calendar, the background ones simulated like the continental cups;
- live play (Timeline and 2D TV) for the manager's tie, and watch-only live for the rest through the existing `watchTournament` flow;
- a bracket tab on the competition screen that **reads fixtures**;
- news, Y and press coverage;
- the board brief reacts to them;
- seeding and hosting follow the real rules below.

Draw seeding uses new `drawSeedCycle` slots (4 UEFA WC play-off, 5 Euro play-off, 6 IC draw, 7 WC finals draw with slots, 8 Euro finals draw with slots).

### 3.1 UEFA WC play-offs (real 2026 format)
- **Qualifying:** 12 groups (the real 54 = 6 of 5 plus 6 of 4; ours adjusts to 53 or 54 minus hosts). The **12 group winners qualify directly.**
- **Entrants:** the **12 runners-up** plus the **4 best Nations Cup edition-2 group winners** (by overall NC ranking) that neither qualified nor finished runner-up. If fewer than 4 exist, fill down the NC overall ranking.
- **Pots** (by the snapshotted world ranking): pot 1 = runners-up 1–4, pot 2 = 5–8, pot 3 = 9–12, pot 4 = the 4 NC entrants.
- **Paths A–D:** each holds one team from each pot. Semis are pot 1 v pot 4 and pot 2 v pot 3, **one leg, hosted by the higher seed** (pot 1 / pot 2). The **final venue is drawn** at the play-off draw.
- **Hosts:** a European host takes one of the 16 places, so paths = 16 − 12 − European hosts. A path that drops out takes away its NC entrant and its weakest runner-up first.
- Round codes: `UPSF` / `UPFINAL`, group name = path letter. New `CompetitionKind.worldCupPlayoffEurope`. It is a text enum, so no migration is needed.

### 3.2 Euro qualifying play-offs (Euro 2024 model)
- **Qualifying:** 10 groups of 5–6 (hosts sit out, as today). The **top two of each group (20) qualify.**
- **Places through the play-offs:** 24 − 20 − hosts (normally 3).
- **Paths:** one path per NC edition-1 league (A, B, C, then D if needed). Each holds the 4 best-ranked non-qualified sides of that league, group winners first. A short league fills from the next league down, by NC overall ranking.
- **Format:** same as 3.1 (one-leg semis 1v4 and 2v3 at the higher seed, drawn final venue). The draw comes a few weeks after the November matchday.
- Kind: `CompetitionKind.continentalPlayoff` (confederation-scoped), rounds `EPSF` / `EPFINAL`.

### 3.3 Other confederations' real steps, feeding the intercontinental play-off
| Confed | Real step | Model |
|---|---|---|
| CAF | 9 group winners direct; the **4 best runners-up** play SF + final | One leg, Nov Y+3, neutral host (the next African Championship host). Winner goes to the IC play-off. Rounds `CPSF`/`CPFINAL` |
| AFC | 4th round (6 teams, 2 groups of 3, central venue), then the 5th round (the two runners-up) | Groups finish by Sep Y+3. 6 best group winners direct. The other 2 winners + 4 best runners-up play the 4th round in Oct: 2 groups of 3, hosted by each group's top seed. The winners qualify (8 in total). The two runners-up meet in the 5th round in Nov; that winner goes to the IC play-off. Rounds `AQ4`, `AQ5` |
| OFC | Final between the group winners | One neutral match, Oct Y+3. The winner qualifies; **the loser goes to the IC play-off.** Round `OFINAL` |
| CONCACAF | Group winners direct, the 2 best runners-up to the IC play-off | No extra step (today's logic is correct) |
| CONMEBOL | 7th place to the IC play-off | Unchanged, but the league now ends Nov Y+3 |

These steps use kind `worldCupQualifyingPlayoff`, scoped by confederation. Every lookup names its confederation (the same trap as `continentalFinals`).

### 3.4 Intercontinental play-off (real 2026)
- 6 teams.
- The **two best-ranked are seeded straight into the two path finals**; the other four play semis (3v6, 4v5). `playoffPathOf` already encodes this.
- **All five matches are fixtures, late March Y+4, hosted in the WC host nation** (real: Mexico).
- The draw is in late November, so its placeholders can enter the December finals draw.
- Replaces `_progressPlayoff` for `calendar2` cycles. The "manager's tie dated in-game date +7" hack and the RNG-only bracket remain for legacy cycles only.

### 3.5 WC finals draw in December with placeholders (and the Euro's equivalent)
- **When:** at ~5 Dec Y+3 the draw is persisted in `DrawSlots`. It holds the 42 known nations and 6 placeholder keys (`UEFA-A..D`, `IC-1/2`), all in pot 4.
- **Group caps:** confederation caps (`confederationCaps`) treat a UEFA placeholder as Europe. An IC placeholder carries **every** confederation of its possible winners, as the real draw did; relax only if no legal draw exists.
- **Ceremony:** shows "Path A winner" balls. `finals_draw_providers` reads `DrawSlots`, never re-draws.
- **When the play-offs resolve (end of March):** `saveFinals` is called **from the stored draw**, with each winner substituted into the exact group and position its placeholder was drawn into. Only then does the finals competition, with its fixtures, exist. `hasFinals` keeps its meaning (fixtures exist), so every guard that reads it is unaffected.
- **The Euro** does the same: a December Y+1 draw with `Path A–C winner` slots, and finals created after the March Y+2 play-offs.
- Group screens and the schedule show the placeholder name until it resolves.

## 4. Interactions

- **Manager's path:**
  - In November, news reports the path ("Path B: semi at home to X, 26 March; final away / venue drawn"). The play-off draw ceremony is a hub event (`hub_event.dart`).
  - A March call-up window opens for entrants. Non-entrants get the friendlies event.
  - In the Dec finals draw the manager's nation appears as a placeholder. The UI says so ("your group if you win Path B").
- **Watch flow:**
  - Add a `playerInPlayoff` all-unplayed-fixtures guard (finals-participant-guard) on **both** copies: `nextEventProvider` and `SeasonService.advance`.
  - The guard covers every new play-off round. Keep these rounds out of `_mainFinalsRounds`.
- **Board brief** (board-brief-locks-in):
  - A nation qualified directly locks in **at the December draw**. Today lock-in is read off a scheduled finals GROUP fixture, which will not exist until March; the lock-in must read `DrawSlots` too.
  - A play-off nation is **not** locked in at the draw. It locks in when its path is won.
  - Reaching the play-offs grades on the existing below-qualify ordinal rung. A play-off loss files the elimination notice and ends the WC run (`_runIsOver`).
  - The board brief **does** change: with two Nations Cup editions, the cycle's Nations Cup brief grades **edition 2** (the post-Euro one). That is the slot it grades today, so old briefs keep their meaning.
- **Y and press:**
  - Y stakes: `y_feed.dart` already knows `POFINAL`; extend it to every new round code (semis = knockout, path finals = decider).
  - Press (press-overhaul): add fact triggers for the play-off draw ("drawn away in the final"), a preview conference before a path final, and a statement judged after it.
  - Y posts for the December draw should not use a future-dated watermark (see the parked y-friendlies-watermark bug).
- **Campaigns:** campaigns start new careers, so they get the new calendar. Star goals worded "qualify for X" must accept a play-off route. Re-run `test/story/campaign_lab_test.dart` and re-tune the star odds (Transplant, Grudge, Young Finns, Greenland, Guineas).
- **Ladders:** Nations Cup promotion/relegation now runs after each edition, so twice a cycle. Edition 1's ladder update happens before the December Euro qualifying draw.

## 5. Tournament match spacing (all finals: WC, EURO and every continental cup)

There is one shared domain service, `TournamentCalendar`, that dates every group and knockout fixture. It replaces `groupStart + (matchday−1)*3` in `saveFinals` / `saveTournamentGroups`, and the +4 / +5 / +7 steps in `_advanceTournamentKnockout`, `_progressContinental` and the background continental sim. It applies to `calendar2` cycles only.

- **Staggered groups:**
  - Groups are dealt into day slots, about 2 groups a day, so not every group plays on the same day.
  - Each group keeps its slot for all of its matchdays.
  - The last matchday of a group is played on one day for all its teams.
- **Per-team rest:** group games 4–6 days apart; the first KO round ≥4 days after the team's last group game; then 4–5 days per round.
  - A KO tie is placed on a day that keeps both teams' rest at ≥4. Bracket halves map to early and late days.
- **Templates** (days from the opener):

| Format | Groups | Knockouts |
|---|---|---|
| WC 48 (real 2026) | Jun 11–27 (MD gaps 6 then 5, 2 groups a day) | R32 Jun 29–Jul 3, R16 Jul 4–7, QF Jul 9–11, SF Jul 14–15, 3rd Jul 18, Final Jul 19 |
| 24-team (EURO, AFCON, Asian) | +0..+11 (gaps 5 then 4) | R16 +15..+18, QF +21..+22, SF +25..+26, Final +30 (EURO: Jun 14 to Jul 14) |
| 16-team (Gold Cup) | 4 groups, gaps 4 | QF +4/5, SF +4, F +4 |
| 10-team Copa (2 groups of 5) | One team rests each matchday; per-team gap ≥4 | |
| 8-team Oceania | Gaps 4 | |

- The Nations Cup Finals Four moves to the June 4/5 semis and June 8 final.
- Africa's November NC knockouts are out of scope (a one-window event).

Knock-on effects:
- **Fatigue** (`Condition.fatigue`): wider spacing changes nothing today, because it counts games in 14 days.
  - Weight each appearance by the days since it (≤3 days counts 1.0, 4–5 days 0.6, 6–9 days 0.3, older 0), so a normal tournament rhythm reads "ready" and only congestion tires.
  - Guard it with a test, and re-check the match-balance lab. The background `RatingMatchSimulator` is untouched.
- **Base camp travel** (`training_camp.dart`) scales the same weighted count. **Injuries** are counted in matches (`injuryMatches`) and return dates are read off fixtures (`absence_outlook.dart`), so they need no change.
- **Call-up windows** are month-based (`WindowPlan`, `MatchSchedule`). A tournament that crosses June into July must stay **one** call-up window, so test the fold.
- **Sim steps and popups:** with staggered days there are more distinct dates. `round_popup.dart` should summarise a group matchday once its last day is played (one popup per matchday, not per day). The watch flow steps day by day, as it already does.
- **Board and press:** both are round-based, so the dates themselves do not matter to them. Pre-tournament press keys off the opener date, which moves.

## 6. Host stadium requirements

**Rule.** A bid (solo or joint) is eligible only if its **combined qualifying grounds** meet the bar for that tournament.
- A ground counts if it is a seed ground in `national_stadiums.json`, or one of the manager's own estate grounds that is enlarged or built and opens by the tournament year (`NationalStadium.openIn`).
- The generated extra cities never count.

| Tournament | Grounds | Final / opener | Semi grounds | Others | Solo-eligible in today's data |
|---|---|---|---|---|---|
| World Championship (48) | ≥10 | 1 × ≥60,000 | 2 × ≥40,000 | ≥30,000 | 13 (ENG ESP GER FRA ITA TUR, ARG BRA, USA, RSA, CHN JPN KOR) |
| EURO (24) | ≥8 | ≥50,000 | 2 × ≥35,000 | ≥25,000 | 7 European |
| AFCON / Asian Cup (24) | ≥6 | ≥40,000 | 1 × ≥30,000 | ≥20,000 | 9 African / 14 Asian |
| Gold Cup (16) | ≥6 | ≥40,000 | 1 × ≥30,000 | ≥20,000 | USA, MEX, CAN |
| Copa (10) | ≥5 | ≥40,000 | 1 × ≥30,000 | ≥20,000 | 9 of 10 |
| Oceania Cup (8) | ≥2 | ≥10,000 | n/a | ≥5,000 | NZL FIJ NCL PNG TAH |

- The WC is then played in **10–16 grounds**: every qualifying ground across the hosts, up to `countForField` (16). It is never padded with sub-30k generated grounds.
- **Selection** (`WorldCupHosts.hostBids` / `_bidsFromShortlist` / `continentalHostsFor`):
  - A shortlisted nation that fails the bar can stand only in a **joint bid** with neighbours: same subregion first, then the same confederation, up to 3 hosts in all.
  - Each co-host must bring ≥2 qualifying grounds, and the primary is the nation with the final ground.
  - If no joint bid reaches the bar, the nation is dropped from that edition. The ranking-weighted draw is otherwise unchanged.
  - Last-3-hosts and previous-confederation exclusions stay (wc-host-rotation).
- **Player's bid** (`host_bid_screen.dart`, `host_bid_providers.dart`, `HostBidOdds`):
  - Show a requirement checklist: grounds needed and held, the final ground, the semi grounds.
  - If the nation falls short, offer **co-host partners** from the neighbours whose grounds close the gap, or point to the stadium screen (`national_stadiums_screen.dart`) to build or enlarge in time.
  - Joint bids need a new marker prefix (`hostBid2:` with partner ids); the old `hostBid:` decode stays untouched.
  - A bid that cannot meet the bar cannot be lodged.
- **Venues:** under `VenueRules.scaled` (`venues.dart`), `forHosts` uses only qualifying grounds for `hostRules2` editions. The 2D TV already sizes the stadium from capacity, so it follows automatically.

## 7. Acceptance (playtester checks, one block per item)

1. **Calendar:** on a new career, the schedule screen shows: NC Sep–Nov 2026, Euro qualifying Mar–Nov 2027, Euro play-offs Mar 2028, EURO Jun–Jul 2028, NC Sep–Nov 2028, WC qualifying Mar–Nov 2029, play-offs Mar 2030, WC Jun 11–Jul 19 2030. NC Finals Fours are in June 2027 and June 2029, and no NC finalist has a qualifier in those Junes.
2. **UEFA WC play-offs:**
   - Finish 2nd in a WC qualifying group, and a November ceremony shows four paths with your semi at home (if pot 1 or 2).
   - You play the semi live (Timeline and 2D TV) in late March. The final's venue matches the one the draw showed.
   - Win, and you appear in the group your Path placeholder was drawn into in December. As a non-entrant you can watch the four paths live, and the bracket tab shows the real scores.
3. **NC back door:** as a League C/D group winner in edition 2 that misses qualifying, you are in pot 4 of the WC paths.
4. **Euro play-offs:** miss direct Euro qualifying while having a strong edition-1 NC league, and you get a path in your league. The December Euro draw shows "Path X winner", and the March result fills that exact slot.
5. **Intercontinental:** in late March, all five matches appear as fixtures in the WC host nation. As CONCACAF 2nd-best runner-up you play them. As a European manager you can watch them. The two winners land in their December placeholder groups.
6. **CAF / AFC / OFC steps:**
   - CAF: as a top-4 runner-up, play the November SF and final at a neutral venue.
   - AFC: play the October group of 3, then the November tie if you finish runner-up.
   - OFC: lose the final, and your team is an IC entrant.
   - Each step has a ceremony or bracket, news and Y posts.
7. **Board:**
   - A direct qualifier's WC brief is locked in at the December draw.
   - A play-off team's brief is not locked until the path is won.
   - A play-off loss ends the WC run with a single elimination message.
8. **Spacing:**
   - At the EURO your three group games are ≥4 days apart. Groups play on different days, and the R16 is ≥4 days after your last group game.
   - At the WC you play a Round of 32.
   - Squad condition between tournament games reads "ready", not "tired", unless rotated badly.
9. **Stadiums:**
   - No edition decided after the update is hosted by a nation (or bid) below its bar. A small nation can appear only inside a joint bid.
   - Your own short bid shows the checklist and offers partners.
   - Host cities on the cup screen are all ≥ the bar.
10. **Old saves:**
    - A 1.1.0 save opened mid-cycle finishes that cycle exactly as before: same play-off, same dates, same hosts.
    - At the next rollover it switches to the new calendar. Export and import of the career bundle round-trips `DrawSlots`.

## 8. Open questions for the owner

1. **Two Nations Cup editions per cycle (Europe):** is this confirmed? It doubles ladder movement and is what both feedback messages imply. Should the North America and Africa cups follow, or stay at one edition (recommended: they stay)?
2. **Two-legged ties:** the real AFC 5th round, and the AFCON / Asian Cup / Gold Cup preliminary rounds, are two-legged. Should we build aggregate (two-leg) support and add those preliminary rounds? The recommendation is single neutral matches now, with the preliminary rounds deferred.
3. **WC solo hosting:** with today's stadium data only 13 nations can host the WC alone. Should AI and player bids be allowed to count "planned" new grounds (Qatar/Saudi style), or should the bar stay hard (recommended: hard)?

## Owner decisions (2026-11-07)

1. Nations Cups: Europe runs two editions per cycle; North America and Africa keep one.
2. Two-legged ties: build real home-and-away ties where the real format has them (AFC final round, AFCON / Asian Cup / Gold Cup preliminary rounds), with aggregate rules.
3. Stadiums: a bid may count planned new stadiums it promises to build, so a rich nation can host alone; define the cost, delivery deadline and the consequence of a broken promise.

Note: the world-managers spec also bumps the schema 54 to 55. Whichever lands second takes 56.

## Save safety (owner hard rule, 2026-11-07: "we need to be really careful to NOT break saves")

- Additive migrations only; no column holding player data is dropped or rewritten.
- New behaviour starts at the next cycle via markers; a career mid-cycle finishes on old rules.
- Required test: open real saves from earlier builds (1.0.9, 1.1.0 (37) and the build before this change), migrate, advance through a cycle rollover, and assert results, squads, trophies, names and history are unchanged.
- The per-career bundle export/import carries every new table; a bundle from the old build imports into the new one.
- A failed migration must leave the original file intact (backup before migrating) and show an error, never a wiped career.

## Release scope (owner, 2026-11-08)

Ships in 1.1.1, after world managers (1.1.0), so this feature takes schema 56.
