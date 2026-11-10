# Competitions screen: the silver list (planned for the next 1.1.x update)

Status: direction chosen by the owner on 2026-11-10 (option A of three).
Mockup: `mockups/2026-11-10-competitions-screen.html` (open in a browser;
option A is the left phone). Not built yet.

## Why

The owner finds today's competitions screen (`lib/features/tournaments/
tournaments_screen.dart`, the "Trophy" destination) chaotic: too much text,
tiles of different shapes, and names that shrink (`_fitLongestWord`) or
squeeze ("VENCEDORES ANTERIORES" scaled down in its chip). He wants it
simple but more premium: the state, and the winner's name and flag, and
nothing that shrinks or overflows.

## What it is

One competition per row, full width, in the same two groups as today
("Your competitions", "Other continents"), World ranking link kept above.

Each row is a silver card of one fixed height:

- **left:** the competition's trophy artwork (`TrophyImage`, as today),
  in a fixed square; dimmed while unavailable, as today;
- **middle:** the competition name on **one line**, at a fixed size, with
  an ellipsis if it is ever too long (never scaled down); under it the
  holder: "Holder" + flag + nation name (muted), or nothing when there is
  no holder yet;
- **right:** one status chip (the stage while it is live, e.g. FINAL; the
  year it next starts; or done/league), never scaled down: chip texts
  must be short enough in every language, or shortened in the copy.

The live competition keeps its green accent (border + chip), as today.
Silver = a subtle dark grey gradient with a light top edge, the same
surface for every row.

## Rules

- No `FittedBox` / scale-down and no `_fitLongestWord` on this screen:
  type sizes are fixed by the theme.
- Every row the same height in every language; long names ellipsise.
- Phone first; the tablet layout (`tournaments_tablet_layout.dart`) should
  use the same row in its list pane.
- Copy stays in `copy/strings.csv`; no em dashes; never "World Cup".

## Left to the builder

Exact heights, gradient values and the chip's short status strings (check
all 28 languages fit), and whether the Nations Cup's league strap moves
into the chip.

## Wider context

Part of a broader wish for a calmer, more premium look with stable font
sizes across the app; this screen is the first one. Other screens
(cups/trophy pages and more) to be drafted the same way later.
