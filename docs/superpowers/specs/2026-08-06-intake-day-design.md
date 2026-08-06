# Intake day

**Date:** 2026-08-06
**Status:** approved design

## Problem

The youth pyramid exists but never announces itself. Seven boys enter every
nation's academy each year, grow through five levels, and roughly a fifth are
released before seventeen — and a manager only learns any of it by going and
looking at the Youth screen. The one moment worth a manager's attention, the
day a new intake arrives, passes in silence.

The inbox already carries the year's other two reports — "Squad development"
and "New faces". Intake day is the third, and it is the one that makes the
pyramid felt rather than merely available.

## Decisions

- One message a year, in the existing inbox. No new screen, no new player
  state, nothing persisted beyond the message row itself.
- It reports the **scouts' impression, not the truth**: the star read it shows
  is the deliberately vague sub-17 read (±2 stars, never settled until a boy has
  played three times). The message says what the coaches think.
- **Golden generations are out of scope.** Detecting them was considered and
  dropped.

## Behaviour

**When.** On the same yearly tick the other two reports use — `agingYears`,
which advances on 1 December. Keyed `intake:$y`, so it generates once and never
duplicates, and any year skipped past is backfilled, exactly as
`aging:$y` and `newcomers:$y` already behave.

**Title.** `Academy intake · <year>`, where the year is
`CareerService.cycleStart.year + y`, matching the sibling reports.

**Category.** A new `youth` category with its own icon and colour, so intake day
reads distinctly from a squad report in the inbox list.

**Body.** The year's eleven-year-olds — the boys whose age is exactly
`PlayerLifecycle.intakeAge` in that year's pyramid — rendered as the table the
squad report already uses: name, age, position, rating, and the scouts' star
read. Ordering is the encoder's existing rule, which puts the scouts' verdict
first, so the boy worth stopping on is at the top.

Star reads come from `Prospects.scoutedStars(id, age: 11)`, which at that age is
two stars wide in either direction. A rating alone would be misleading — an
eleven-year-old's overall says almost nothing about what he becomes — so the
stars are the point of the message and the rating is context.

**The academy line.** One line above the table saying whether the federation's
youth-academy investment showed in this intake: the bonus that intake drew
(`youthBonusByCycle` for its cycle) against zero. Backfilled cohorts and years
with no investment simply say nothing.

## The encoding change

`encodeSquadDevReport` has no slot for a headline. It gains an optional note
line and its tag moves from `SQUADDEV1` to `SQUADDEV2`; `decodeSquadDevReport`
continues to accept `SQUADDEV1` bodies unchanged, so reports already sitting in
players' saves still render. The note is rendered above the table by the same
widget, which means the yearly squad report can use it later at no extra cost.

The decoder is already tolerant of extra fields (it reads by index and skips
short lines), so the format stays forward-compatible in the same way.

## Where the code lives

- `lib/features/messages/squad_dev_report.dart` — the optional note in the
  encoder, the decoder's v1/v2 handling, and the renderer.
- `lib/features/messages/message_providers.dart` — the new draft. It already
  reads `youthBonusByCycleProvider` and the player repository; the boys come
  from `youthByNation` filtered to `age == PlayerLifecycle.intakeAge`.
- The new `youth` category's icon and colour go wherever `messageStyle` maps
  categories today.

Nothing else changes. No new tables, no schema bump.

## Testing

- The encoder round-trips a note; a body written with a note decodes with it.
- A `SQUADDEV1` body — no note — still decodes, with every row intact. This is
  the guard that stops the change breaking saves in the wild.
- A body with a note but no rows decodes to an empty table rather than throwing.
- The intake draft picks exactly the eleven-year-olds and nobody else.
- The draft's key is stable, so a second generation pass adds no duplicate.
- A year whose intake drew no academy bonus produces no note.

## Out of scope

Golden-generation detection, any change to the Youth screen, any change to what
a boy's rating or potential is, and any mechanical effect — this feature reports
and does not alter the world.
