# Release 1.1.2: manager ages + real play-offs and the two-year rhythm

Date: 2026-11-13. Status: draft for the owner. No code written.

1.1.2 = **A. manager ages** (new, below) + **B. the calendar realism spec** `2026-11-07-real-world-playoffs-design.md` (owner decisions of 2026-11-07 stand), minus its §6 host stadium rule, which already shipped (`hostRules2`/`hostRules3`).

Owner answers 2026-11-13: ages for the own manager and all world managers, editable in the editor; every play-off really played (UEFA WC, Euro via Nations Cup, intercontinental, other confederations); Nations Cup twice a cycle UEFA-style (Europe; North America and Africa keep one, per the 11-07 decision); calendar, promotion/relegation display, board + money, news/press/Y around it.

## A. Manager ages

### Own manager
- **Career creation:** an age field next to the manager name (default 45, range 30 to 75). Stored as `Careers.managerBirthYear` (nullable int; schema bump, additive). Birth year = career start year minus age.
- **Old saves:** null birth year means "age not set". The manager page shows no age, and a one-time hub prompt after the update asks for it (skippable, never blocks Continue). Nothing in the sim reads it, so null is safe everywhere.
- **Shown:** manager page header, job offers, the end-of-career summary, press bios. Ages with the in-game date.
- **Not editable inside a running career** (owner: change it in the editor, not mid-career).
- **No forced retirement for the player.** Optional flavour only: at 70+ a board line ("the board asks about succession plans"), never an ending.

### World managers
- Already have `birthYear` and age-based retirement (64+, certain at 75). Keep the rules; make age **visible** where managers are listed (managers list rows, manager profile header, match preview "Their manager", news "X (61) retires").
- New entrants keep today's ranges.

### Editor (web + mobile)
- Managers section gains an **age** field per nation's day-one manager (30 to 75).
- Pack format 6: `managers` entries gain an optional `age`. Seeding uses it as birthYear = start year minus age; absent = today's random age. Older packs import unchanged.
- The own manager's age stays a career-creation field (not in packs).

### Save safety
- Schema +1 (one column, nullable). Bundle export/import carries it. Real-old-save upgrade test (owner rule: never break saves).

## B. Calendar realism (see the 11-07 spec)

Sections that ship: §0 save compatibility (`calendar2` marker, `DrawSlots`, `Competitions.edition`), §2 four-year rhythm, §3 all play-offs, §3.5 December draws with placeholders, §4 interactions (board, press, Y, news, campaigns, ladders), §5 tournament spacing, §7 acceptance, plus the owner's decision 2 (two-legged ties where real formats have them).

Schema: world managers took 55, pack versions 56. This release takes **57** (manager birth year + `DrawSlots` + `Competitions.edition`, one stepwise migration).

## Delivery order (each stage merges and is playable on its own)

1. **Manager ages** (small, independent). Schema 57 lands here with all three additive changes so there is only one bump.
2. **Calendar2 skeleton:** marker, two Nations Cup editions (Europe), ladder after each edition, new dates for Euro/WC qualifying, NC Finals Four in June. No play-offs yet; qualifying places as today.
3. **Euro play-offs** via NC edition 1 + December Euro draw with placeholders.
4. **UEFA WC play-offs** + intercontinental as real fixtures in March + December WC draw with placeholders.
5. **CAF / AFC / OFC steps** (incl. two-legged AFC 5th round and aggregate rules).
6. **Tournament spacing** (`TournamentCalendar`) + weighted fatigue.
7. **Around it:** board briefs and money (play-off prizes, NC promotion bonus), press triggers, Y posts, news, campaign star re-tune.

## Owner decisions (2026-11-13)

1. Tournament spacing and the fatigue rework ship in 1.1.2 (stage 6).
2. Two-legged ties ship in 1.1.2 (stage 5).
3. Money: play-offs get no prize of their own; a nation through a play-off earns exactly what a direct qualifier earns, and a play-off loss fails the "qualify" brief. Nations Cup promotion pays EUR 1M. The board grades Nations Cup edition 2, as today.
