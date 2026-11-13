# 1.1.2 UI redesign: hub programme, schedule, set pieces, world ranking

Date: 2026-11-13. Owner picked these variants from the design canvas (https://claude.ai/artifact/TVmZCbCtfi14Yr3LEfq1ex). Mockup sources: `/private/tmp/claude-501/-Users-martinurbanczyk-Documents-Work-fnm26/c6149fe3-863d-40f4-becf-0b197ca92755/scratchpad/redesign4/project/*.dc.html` (HTML, app tokens). Mockups show phone; tablet layouts adapt the same content.

Global: app tokens and shared widgets only (AppCard, segmented tabs, chips, TacticalChip, ActiveBadge, PrimaryButton, flag discs); every string through ARB in all 28 languages + copy/strings.csv; no em dashes; never "World Cup"; no logic changes, no schema change. Golden + widget tests updated.

## 1. Hub programme (variant Hub A, `CalHubA.dc.html`)
- Replace the UPCOMING card with a section header "NADCHÁZEJÍCÍ / Upcoming" + "Full schedule ›" link, and a horizontal strip of the next 2 fixtures as small cards (date + home/away in mono, flag disc + opponent, competition + group in mono), the next one with a highlighted border, plus a dashed "next window: +N" card for the following month.
- Under it one warning line when relevant (call-up deadline in N days), mono, warning colour.
- Board / funds tiles and the silver Play button stay as today, above the strip.

## 2. Full schedule (variant C, `CalFullC.dc.html`)
- Grouped by month (mono section header, "Today" marker on the current month), each month one card with rows: weekday+day (mono), flag disc, opponent, mono line "COMPETITION · GROUP · HOME/AWAY".
- Draw events (WC/Euro draws) appear as dashed rows in gold.
- Filter chips at the top: Mine / Competitions / Draws (Mine default). Today's data source (`scheduleProvider`) stays.

## 3. Set pieces in sub-tabs (variant A, `SetA.dc.html`)
- The ROLES & SET PIECES tab gets a row of chips: Roles, Captain, Penalties, Free kicks, Corners, Throw-ins. Each shows one job:
  - Roles: today's per-starter role rows.
  - Captain: today's captain + vice captains card.
  - Penalties / Free kicks: the starters ordered by suitability (TacticalChip position, name, mono attribute line), the chosen 1st and 2nd taker marked "1." / "2." on the right; tap a row to make him 1st, tap again for 2nd. Buttons "Pick best" and (free kicks) "Same as penalties".
  - Corners: left and right taker. Throw-ins: taker + the existing throw-in style picker.
- Same data and services as today (set-piece takers store, throw-in style); only the layout changes. Tablet layout uses the same sub-tabs.

## 4. World ranking (variant A, `RankA.dc.html`)
- Top: "your team" card (flag disc, "#10 England", mono movement since the WC draw + points, small trend sparkline from the existing history).
- Region chips stay. The list becomes ONE card with dense rows (rank, mono ▲/▼ movement, flag disc, name, mono points); the manager's row highlighted with the "YOUR TEAM" tag; a dashed playoff-yellow divider marking the pot 1 cut-off for the next draw when it is known.
- The big per-row cards and the separate history chart card go (the sparkline replaces the chart; tapping the team card opens the existing full chart).

## 5. Team records (variant A, `Main.dc.html`)
- Record book screen (lib/features/records/record_book_screen.dart + tablet layout): top row of three stat tiles (matches with W/D/L, win share with goals for:against, trophies with the latest one in gold).
- One card of team records as label/value rows (mono label left, value right): best finish, longest unbeaten run, biggest win and biggest defeat (flag disc + score + opponent).
- "Record holders" section: one card with rows per category (caps, goals, clean sheets): mono category, holder's name, number, ACTIVE badge when still playing.
- Fiercest rival card (flag disc, name, mono record line, aggregate score).
- The existing Legends / All-time world / Head to head tiles stay reachable (compact row of buttons at the bottom); the most-caps list moves behind them or the record-holder rows.

## 6. Press conference (variants F + C, `PressF.dc.html` + `PressC.dc.html`)
Owner picked F for the questions and C for the end screen (2026-11-13).
- **Question screen (F):** a ticker strip at the top with what the conference is tied to: the competition/group label in warning colour, then the relevant results (short codes + score) and the standing line (e.g. "ENG 1 PT · 3RD"); for a preview conference the upcoming fixture, for a post-match one the result(s). Under it a stage area with a large drawn microphone (vector, app tokens) and "YOU HAVE THE FLOOR · 2/4". The journalist line (name · outlet) centred in mono, the question in large centred type (24px, 700), answers as large full-width buttons (the first, the "main" answer, styled like the silver primary button only if that matches the existing answer semantics; otherwise all outlined). Keep the effect hints (aim/effect text) the current sheet shows, as a small mono line under each answer.
- **End screen (C):** the "tomorrow's headline" verdict becomes a newspaper card (light card, outlet + date header rule, big headline, standfirst), then three effect tiles (morale / board / press) with signed values, then a "YOU PROMISED" card when a stated target was made, tied to the fixture it is judged on, then the silver Continue button.
- Data: reuse what the press sheet and press desk already compute (conference kind, fixture, campaign, answers, effects, stated targets, headline). Where the ticker needs results/standings, read existing providers read-only. No logic/schema change.
