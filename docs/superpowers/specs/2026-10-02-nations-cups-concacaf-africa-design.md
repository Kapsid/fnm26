# Nations Cups for CONCACAF and Africa

**Status:** spec, awaiting approval
**Asked for by:** the owner, from playtester feedback, 2026-10-02

> "Missing competitions: ... the CONCACAF Nations League, the recently introduced
> African Nations League ..."

## Real world (checked 2026-10-02)

| Confederation | Real competition |
|---|---|
| UEFA | Nations League since 2018: tiered leagues, promotion/relegation, Finals Four |
| CONCACAF | Nations League since 2019: tiered leagues A/B/C |
| CAF | African Nations League, announced Dec 2025, first edition 2029: 54 nations in four geographic zones (North 6, West 16, East 16, Central & Southern 16), zone matches in the Sep/Oct windows, top teams to a November finals; annual; AFCON moves to every four years |
| AFC, CONMEBOL, OFC | none |

## Today in FNM

The Nations Cup is Europe-only (`career_providers.dart` `if (me.confederation ==
Confederation.europe)`), scheduled only when the manager is European, and every
Nations Cup read is unscoped by confederation (one cup per cycle is assumed
throughout).

## Decisions

| Question | Decision |
|---|---|
| Which confederations | Europe (as now), CONCACAF (same ladder), Africa (zone format) |
| Background | All three are scheduled and played every cycle wherever the manager is, like the continental championships |
| Names (stored, canonical English) | `Nations Cup` (Europe, unchanged so saves, honours and real history keep working), `North America Nations Cup`, `African Nations Cup`; translated at display like every competition name |
| Frequency | Once per cycle each, in wcYear − 2 (the year after the continental finals) |
| Schema | No change |
| Existing saves | The new cups start with the next cycle's calendar |

## 1. Per-confederation plumbing

Every Nations Cup read and write is scoped by confederation, following
`_progressContinental` / `_progressContinentalFor` in `season_cycle.dart`
(manager's confederation first, then the rest; every repository call passes
`confederation:`; short-circuit on `hasHonour(cupName, year)` with the cup's own
name). Affected (from the code survey): `buildCalendar`,
`_progressNationsLeague`, `_recordNationsLeagueHonour`, rollover
promotion/relegation (`season_rollover.dart`), `hasLiveNationsCupFinals`,
`earliestUnplayedNationsCupFinalsDate`, the Nations Cup draw ceremony
(`nations_cup_draw_providers.dart`), `nations_cup_screen.dart`,
`tournaments_providers.dart`, `round_popup.dart`, `objective_providers.dart`,
`group_advancement.dart`, hub events. Hub events, draws, objectives and the
manager-facing screens use the MANAGER'S confederation's cup; the tournaments
screen can show the other cups read-only.

A helper maps confederation → cup name and format:
`NationsCups.forConfederation(c)` → `({String name, NationsCupFormat format})?`
(`ladder` for Europe and CONCACAF, `zones` for Africa, null elsewhere).

Everything that tests a competition name with `== 'Nations Cup'` /
`startsWith('Nations Cup')` (trophies, achievements, challenges, vitrine,
nation offers, message text, competition labels) accepts all three names.
Achievements and challenges about "the Nations Cup" count any of them.

## 2. CONCACAF: the ladder

Same code path as Europe: `NationsCup.seedTiers` (already per confederation),
leagues of 16 in groups of 4, home and away, Sep/Oct of wcYear − 2, League A
group winners to a Finals Four in June of wcYear − 1, promotion/relegation at
rollover per confederation. CONCACAF has 35 nations: a remainder league smaller
than 4 is merged into the league above it (B becomes 19, groups of 4 and 5)
instead of being skipped. The same remainder rule applies to Europe (53 nations
already split cleanly, so no change there).

## 3. Africa: zones

A fixed code → zone map (an approximation of CAF's zones; nations.json has no
sub-region field):

- **North (6):** ALG, EGY, LBY, MAR, MTN, TUN
- **West (16):** BEN, BFA, CHA, CIV, CPV, GAM, GHA, GNB, GUI, LBR, MLI, NGA, NIG, SEN, SLE, TOG
- **East (16):** BDI, COM, DJI, ERI, ETH, KEN, MAD, MRI, MWI, RWA, SDN, SEY, SOM, SSD, TAN, UGA
- **Central & Southern (16):** ANG, BOT, CGO, CMR, COD, CTA, EQG, GAB, LES, MOZ, NAM, RSA, STP, SWZ, ZAM, ZIM

A test pins that the map covers exactly the 54 African nations of nations.json.

**Groups:** each 16-team zone plays 4 groups of 4, home and away (6 matchdays,
Sep/Oct of wcYear − 2, the existing window days). North plays 2 groups of 3,
home and away (4 matchdays). Group draw seeded by ranking within the zone.
Group names encode the zone (`N1`, `N2`, `W1`..`W4`, `E1`..`E4`, `S1`..`S4`).

**Finals Eight (November of wcYear − 2):** the two best group winners of each
zone (best by points, then goal difference, goals scored, ranking), single-leg
knockout: quarter-finals (day 12), semi-finals (day 15), final (day 18). Pairing:
zone winners kept apart in the quarter-finals (W1 v E2, E1 v S2, S1 v N2, N1 v
W2). Round codes `NQF`, `NSF`, `NFINAL` (so the existing N-prefixed handling in
match stage, Elo, attendance, nomination keeps working); Africa's group round is
`NGROUP` like the others.

**No promotion/relegation;** `group_advancement` shows "group winner may reach
the Finals Eight" for Africa instead of the ladder rule.

**Board objectives (African manager):** by strength: win your group / reach the
Finals Eight / reach the final / win it (ordinals slot into the existing
objective ladder; no "avoid relegation").

## 4. Copy

New keys in all five ARBs (en, cs, fr, it, pl): the two new cup names, the four
zone names, the Finals Eight heading and round names if not already covered
(quarter-final exists), the Africa group-advancement line, the Africa objective
lines, and any "This cycle's Nations Cup" line that must name which cup. No em
dashes, no trademarks ("Nations League" itself is a UEFA/CONCACAF name: keep
"Nations Cup"). `copy/strings.csv` re-exported.

## Testing

- Calendar: a European, a CONCACAF, an African and an Asian career each get all
  three cups scheduled in wcYear − 2 with no fixture clash for any nation.
- Progression: driving a full cycle completes all three cups, records three
  distinct champions (three honours), and runs promotion/relegation for Europe
  and CONCACAF separately (a CONCACAF result never moves a European nation).
- CONCACAF remainder merge: no nation is left without a Nations Cup.
- Africa: zone map covers the 54 nations; Finals Eight takes two group winners
  per zone; zone winners apart in the quarter-finals; no tier changes at rollover.
- Manager-facing: an African manager gets the draw ceremony, objectives, the
  hub's Finals watch for HIS cup; a European manager's screens are unchanged.
- The existing cycle tests (`full_cycle_test`, `cycle_calendar_test`,
  `season_flow_test`, `hub_nations_cup_zones_test`) keep passing.
- Full suite + the long end-of-cycle test.

## Out of scope

Regional cups (Gulf Cup, COSAFA, ...), a second African edition per cycle,
Asian/South American/Oceanian Nations Cups.
