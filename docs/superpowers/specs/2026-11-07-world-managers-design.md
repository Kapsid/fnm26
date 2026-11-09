# World managers: design

Date: 2026-11-07. Base: main, 1.1.0 (37), schema 54, pack format 2.

## What exists today

- No AI manager exists. Opponent behaviour comes from `NationIdentity.styleOf(code)` (curated, derived, 8 `NationStyle`s) fed into `AiTactics.forOpponent` and bent by `AiCounter.forFixture`. Three call sites must agree: live match (`match_providers.dart:448`), skip path (`hub_providers.dart:1559`), scout report (`scout_report_providers.dart:57`).
- The player's job flow: `rolloverVerdictProvider` (`nation_offers_providers.dart`) gives verdict, sack and offers; stints in `career_stints`. Board briefs are pure functions: `worldObjectiveTarget`, `continentalObjectiveTarget` and the Nations Cup targets in `objective_providers.dart`. Result reading: `Expectation.surprise/standing`.
- Staff: `StaffMarket` derives named coaches from `(saveSeed, cycle, role, slot)`; only `careers.staffAssistantId` is stored. Staff do not follow the player to a new job.
- Y personas and press are derived from history; press triggers are fact-driven and capped (6 per cycle, 45-day quiet).
- World packs rename clubs, stadiums, competitions, Y accounts, reporters, sponsors and per-nation name lists. No managers.

## 1. The manager entity

One row per person, per career: `id` (unique within the career), `name`, `nationality` (FIFA code), `birthYear`, `style` (`NationStyle`), `origin` (fresh, exPlayer, exAssistant), `retiredAt` (nullable). The name is built like `StaffMarket._nameFrom`, from the nationality's name pools (pack lists and `namePools2` respected). It is stored at creation, so nobody is ever renamed. Names are fictional.

- **Domestic or foreign.** This is not stored; it is read as nationality against the nation he manages. At seeding, the domestic share is about 85% for pedigree 1 to 2 nations and about 55% for pedigree 4 to 5. Foreign coaches mostly come from pedigree 1 to 3 nations.
- **Style.** A domestic manager takes the nation's `NationIdentity` style 70% of the time, otherwise a neighbouring style. A foreign manager takes his own country's style 60% of the time. The three AI-tactics call sites read the manager **in charge on the fixture's date** (spell lookup). They do not read today's manager, so live, skip, scout and replay always agree. If a nation has no manager row, it falls back to `NationIdentity`. The background `RatingMatchSimulator` and match strength are untouched, so the balance calibration and the tactics-impact guards stand.
- **Career history** is a list of spells: `managerId, nationId, from, to, endReason` (sacked, resigned, poached, retired, contractEnd, replacedByPlayer). Spells store no per-match counters. W/D/L and best finish are read from `fixtures` and honours inside the spell's dates, and only when a screen asks.
- **Reputation (0 to 100)** is derived, not stored. It is computed from spells: the strength of the nations managed, honours, and briefs beaten versus missed. It is computed in memory over the roughly 400 managers only when hiring runs.

## 2. Lifecycle

**Seeding.** A new career seeds 209 incumbents plus a free pool of about 60. Each incumbent gets a backdated spell start, drawn from 0 to 6 years, and one or two fictional earlier spells. Seeding is deterministic from `careers.rngSeed` on its own salt (`varietySeed('mgr:...')`). It must not draw from the world RNG stream. Guard test: a pinned-seed world is identical to today's apart from the new tables. The player's nation has no AI manager.

**Decision points.** Changes happen only at these points, never mid-tournament:
- (a) when a nation's tournament settles, qualifying or finals. Hook: the `_recordHonourIfDecided` family in `season_cycle.dart`.
- (b) at the cycle rollover (`_startNextCycle`). This is also when retirements, new entrants and poaching run.

**Sacking.** Each AI nation's brief for the cycle uses the same pure target functions as the player, read off the cycle-start ranking snapshot. Score = Σ(actual ordinal − target) over settled briefs + 0.5 × the summed `Expectation.surprise` of the window's competitive fixtures. If the score is below −2, the sack chance is 60%. If it is below −1, the chance is 25%.

**Hiring.** The best free manager by reputation that the nation's rank can attract. Ex-players and ex-assistants get a small domestic preference.

**Poaching (rollover only).** A vacant top-40 nation may take an employed manager who is at a nation at least 20 places lower and whose reputation beats the best free candidate by 15 or more. The nation he leaves hires from the free pool, with no further chain.

**Retirement.** From age 64, with a chance rising to certainty at 75. Free managers unhired for 8 years also leave.

**New faces.** At each rollover, entrants top the free pool back up to about 60. They are a mix of fresh names, ex-internationals of that nation, and the player's departed assistants. A departed assistant enters the pool the moment he leaves, whether replaced or left behind when the player moves.

**The player's moves.** These stay exactly as they are; this feature only reacts to them.
- When he takes a job, the incumbent's spell ends `replacedByPlayer` and he joins the pool.
- When he leaves or is sacked, that nation hires at once.

**Targets and safeguards.** Mean tenure is 4 to 6 years. About 20% of nations change per year, with most changes in the window after a finals tournament. The safeguards:
- No results sack inside 12 months of hiring.
- At most one change per nation per 12 months.
- No more than 25% of the world changes at any single decision point.
- A manager who met his last finals brief is safe for 12 months.
- Every manager has a contract of 2 to 6 years, with renewal if score ≥ 0.

Tune these with a lab (`FNM_LAB`-style, 5 cycles × 8 seeds), not by feel. A guard test pins the tenure band.

## 3. Relationships with the player

A manager's relationship with the player is derived on read. It folds two things: (i) head-to-head fixtures inside his spells, and (ii) an append-only `manager_ties` table (`managerId, kind, delta, date`) that is expected to hold fewer than 100 rows per career. No decay job runs.

**Warmth.** Warmth runs from −100 to +100 and starts at 0. Its label is one of: neutral, respect, rival, grudge, protégé, old boss, former player. The label comes from the strongest structural tie, or else from warmth.

**What moves it:**
- Each competitive meeting adds familiarity.
- A knockout elimination either way adds −10 warmth and moves the label toward rival.
- A heavy win for the player (margin of 3 or more) costs −5.
- A press dig the player hits back at costs −15. A respectful answer adds +10.
- Replaced by the player (he lost his job to you) or replacing the player (he took over after you left): a grudge or successor tie at −25. This tie stays as a label.
- A former assistant: protégé at +40.
- A player who earned at least 5 caps under you and later manages: former player at +20.

**Decay.** Warmth decays 25% per year without a meeting. A rival label falls back to neutral after 2 cycles without a meeting. Structural labels stay for life, but their warmth fades. Never meeting means neutral.

**Where it shows.** Only when the tie is not neutral, apart from the plain name:
- **Press:** one optional beat in an already-triggered conference whose match opponent's manager has a tie. It counts against the existing cap, and no new trigger is added.
- **Y:** at most one post before a match against a tied manager. Tone follows the speaker, as now.
- **Match preview and dossier:** his name and tie chip in the preview. The dossier adds his style plus your record against him.
- **News:** see section 4.

## 4. Screens (phone and tablet layouts)

- **Nation page** (`nation_vitrine_screen`): a "Manager" row on `NationNowCard` with name, flag, age, appointment date and record. Tapping it opens a profile sheet with his spells, your record against him and the tie.
- **Match preview** (`OpponentBriefing`): one line with the opposing manager, plus the tie chip if there is one.
- **Managers list:** reached from the Nations area. It has two tabs: "Current" (all 209, filterable by confederation, sortable by reputation) and "Recent moves" (the last 2 years).
- **News:** a `manager` message category, stored as meaning (`MsgPart`), never as words. News is only sent when a change involves one of: a tied manager, your current or former nations, your upcoming opponents or group, or your confederation's top 10. There are at most 3 per decision point. Everything else appears only under Recent moves.

## 5. Editor

World packs can rename **day-one incumbents**. Pack format 3 adds `managers: {nationId: {name, nationality}}` and a "Managers" name section. `WorldPack.migrate` lifts format 2 packs. Later hires already follow the pack's name lists. Managers cannot be edited inside a running career.

## 6. Saves

Schema goes from 54 to 55, using the stepwise recipe in `schema-bumps-preserve-saves`. The bump is additive: three tables (`world_managers`, `manager_spells`, `manager_ties`), each keyed `(careerId, id)`. Because ids are per career, `CareerBundle` needs no id remapping, and the coverage test forces this decision. The migration itself writes no rows.

Existing careers are seeded **lazily on first open** if they have no manager rows. The seeding is deterministic from `rngSeed`, and backdated spells cover the past, so head-to-head with earlier fixtures reads correctly. The populated-save migration test is extended to cover the new tables.

## 7. Performance

- Nothing runs per match.
- At each decision point, one in-memory pass over at most about 270 managers and one batched write.
- The briefs reuse the ranking snapshots already loaded.
- No hub or career-load provider watches the manager tables. The nation card, preview and list each read only what they show.
- Lazy seeding for an existing career is a single transaction with a budget of under 50 ms on the Galaxy A56. It is measured before merge.
- Before building, profile the reported "open last career" lag so this feature is not blamed for it or added to it.

## 8. Copy

Every string goes through `copy/strings.csv` and the 28 ARBs:
- tie labels
- end reasons
- news templates
- profile and list labels
- the press beat (two answers)
- Y variants (4, tone-banded)

Names are not translated. The existing guards (em dash, "World Cup", ALL CAPS) cover the new keys.

## 9. Out of scope

- Club managers.
- The player choosing, approaching or displacing a specific manager. The job flow is unchanged.
- Manager effects on match strength or on the background simulator.
- Interim managers, salaries and contracts as UI, and an AI manager's skills or staff.
- Renaming managers in a running career.

## 10. Acceptance checks (playtester)

1. Start a new career. Every nation page shows a manager whose name fits the country, with an age and an appointment date. Start a second career with the same seed: the managers are identical.
2. Open an existing 1.1.0 save. It loads at its usual speed and keeps its progress, and every nation now has a manager.
3. Play one full cycle. After the World Championship, several weak performers have new managers. The "Recent moves" tab lists 15 to 30% of nations for the year. You get no more than 3 news items per window.
4. Take a new job. The previous manager there appears in the free pool with a grudge tie. The nation you left names a successor within the same advance.
5. Replace your assistant. Within a few cycles he can turn up managing a nation, marked protégé.
6. Knock a side out twice. Its manager shows rival in the preview, and a later conference may offer the dig beat. Answer it, and the label or warmth changes.
7. A skipped match, a played match and the scout report against the same nation all describe the same manager and style.
8. Switch to Czech. All manager copy is Czech, with no em dash and no "World Cup".
9. A world pack that renames Czechia's manager shows that name on day one of a new career.

## 11. Open questions

1. **Turnover.** Is a mean tenure of about 5 years (about 20% of nations per year, concentrated after finals) right, or should it be calmer?
2. **Style.** A foreign manager may bring a style other than the nation's identity, so some opponents will play differently from today. Is that acceptable, or should the style always stay the nation's?
3. **Pack format 3.** Renaming managers means 1.1.0 builds will refuse packs made with the new editor. Ship it, or leave managers out of packs (they still follow pack name lists)?

## Owner decisions (2026-11-07)

1. Turnover: mean tenure about 5 years (about 20% of nations change per year, mostly after a finals tournament).
2. Style: blend. The manager's style mixes with the nation's identity.
3. Editor: yes, ship pack format 3 so world packs can rename the starting managers. Packs made with the new editor will not open in older 1.1.0 builds.

Note: the real-world play-offs spec also bumps the schema 54 to 55. Whichever lands second takes 56.

## Save safety (owner hard rule, 2026-11-07: "we need to be really careful to NOT break saves")

- Additive migrations only; no column holding player data is dropped or rewritten.
- New behaviour starts at the next cycle via markers; a career mid-cycle finishes on old rules.
- Required test: open real saves from earlier builds (1.0.9, 1.1.0 (37) and the build before this change), migrate, advance through a cycle rollover, and assert results, squads, trophies, names and history are unchanged.
- The per-career bundle export/import carries every new table; a bundle from the old build imports into the new one.
- A failed migration must leave the original file intact (backup before migrating) and show an error, never a wiped career.

## Release scope (owner, 2026-11-08)

The full world-managers feature ships in 1.1.0. The real-world play-offs, calendar and stadium rules move to 1.1.1, so this feature takes schema 55.
