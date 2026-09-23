# Guided tour — 2026-08-21

A manager opening the game for the first time is dropped into an
event-driven flow with a forced budget allocation and no explanation of what
any of it is for. This walks him through the screens once, on request.

## What it is

A **continuous** tour: after the first career is created the game asks whether
he wants a walk through; on yes it navigates the real screens in order,
dimming each one and captioning what it is for.

Real screens, not depictions. Some of them are genuinely empty on a brand-new
save — no fixtures drawn, no squad named — and that is accepted: the tour
teaches what a screen is FOR, and a manager who has just pressed "new career"
has nothing in any of them yet by definition.

## Trigger

Asked **once ever**, not once per career. The flag lives in
`SharedPreferences` (`tour_offered_v1`), beside the existing sound and
language settings:

* it is a property of the person, not of a save — a second career does not
  make him a beginner again;
* it therefore needs no schema bump and cannot be lost to a save migration.

The offer is made from the hub on its first build when a career exists and the
flag is unset. The hub is the right place because every path into a save ends
there, including "start from the bottom" and an imported career.

Settings gains **Replay the tutorial**, which starts it immediately from step
one. That is the only way back in, and it works whether or not it was ever
taken.

## The steps

Seven, in the order the game itself asks for them:

| # | Route | What it says |
|---|---|---|
| 1 | `hub` | The game is the next event; the button changes as the cycle moves. Board confidence and the objectives live here. |
| 2 | `budgetSetup` | One forced allocation per cycle. Staff wages come off the top before the departments. |
| 3 | `tactics` | Shape, playstyle, captain, set-piece takers. |
| 4 | `tactics` (squad tab) | The whole pool: form, condition, who is injured or banned. |
| 5 | `callUps` | One squad per international window, and it holds for the window. |
| 6 | `careers` | History, team records, past matches. |
| 7 | `tournaments` | Standings, groups, and the cups running in the world. |

The live match is deliberately absent. It is the one screen a manager reaches
with something already at stake, and a scrim over it would be an interruption
rather than a lesson. Adding it later is one entry in the list.

## How it draws

A `TourOverlay` above the router: a scrim over the whole screen, a caption
card, **Back / Next / Skip**, and a dot per step.

**Not** a cut-out spotlight around individual controls. That needs a
`GlobalKey` wired into six screens' internals and breaks silently whenever one
of those layouts changes — a standing maintenance cost paid on every future
UI change, for the first version of a feature that is read once. If specific
controls want highlighting later it should be done on the two screens where it
earns its keep (the hub's action, the budget sliders), not as a framework.

## Design

* `lib/features/onboarding/tour_steps.dart` — `TourStep` (route + caption
  resolver) and the seven-step list. Pure data; no Flutter beyond the l10n
  lookup.
* `lib/features/onboarding/tour_providers.dart` — the prefs flag, the current
  step, and `startTour` / `advance` / `endTour`.
* `lib/features/onboarding/tour_overlay.dart` — the scrim and the card.
* `lib/app.dart` — the overlay wraps the router's output so it floats over
  every screen.
* `lib/features/hub/hub_screen.dart` — makes the offer once.
* `lib/features/settings/settings_screen.dart` — the replay row.

Navigation is `context.go` per step, so the tour cannot stack routes: each
step replaces the last and Skip lands on the hub whatever step it stopped at.

## Testing

| Area | Test |
|---|---|
| Steps | Every step's route is a real route; every caption resolves non-empty in EN and CS |
| Flag | Offered once: after answering, the offer is not made again; replay clears it |
| Overlay | Renders the caption; Next advances; Back goes back; Skip ends and lands on the hub; the last step reads "Done" |
| Settings | The replay row exists and starts the tour |
| Whole app | analyze clean, full suite green |
