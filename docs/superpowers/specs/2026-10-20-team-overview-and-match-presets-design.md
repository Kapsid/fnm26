# Team overview everywhere, and tactic presets during the match

Date: 2026-10-20 · For release 1.0.6 · Status: approved in conversation, pending plan

Two pieces of player feedback, built together because both are about reaching
what the game already has with fewer taps.

## A. Tap any team, see its overview

### Why

Players report that the only way to see another nation's world ranking is to
open the Rankings screen and find it there. A team's page already exists (the
nation "vitrine", `lib/features/nations/nation_vitrine_screen.dart` with its
tablet layout and `NationView` in the tablet detail pane), but only the world
ranking opens it. Everywhere else a team's name or flag is a dead end.

### Goals

1. Wherever a nation's name or flag appears as a row or a side of a fixture,
   tapping it opens that nation's team page.
2. The team page leads with the nation as it is NOW, then keeps its history.

### Non-goals

- No new data model, no schema change, no new stored state. Everything shown
  is derived from data the save already has.
- No redesign of the history sections (medals, titles, all-time scorers,
  ranking chart): they stay as they are, below the new top.
- Not making every tiny flag in every widget tappable (see "Where" below for
  the rule).

### Anti-goals (would make this a failure even if it works)

- A tap that does something different from one screen to the next. One
  helper, one behaviour: `openNation(context, careerId:, nationId:)` in
  `lib/features/shell/detail_pane_host.dart` (side pane on a tablet, pushed
  page on a phone). The world ranking's own row currently pushes the route
  directly and should switch to this helper too.
- Taps that steal a gesture a screen already uses (a row that already opens a
  match, a bracket tie that already opens round results). Where a row already
  has a tap, only the flag/name inside it becomes the team tap, or nothing
  changes; never break an existing navigation.
- Slowing a list down: the page loads its own data when opened; the lists
  pass only the nation id.

### Where (the rule, then the known places)

Rule: a nation shown as an identifiable entry (a standings row, one side of a
fixture or result, a bracket slot, a draw pot/group entry, a head-to-head
side, a match preview team block) is tappable. Decorative flags inside
sentences (news text, Y posts) are not.

Known places to cover, at least (the builder sweeps for the rest using the
rule): group/league standings tables (World Championship, continental,
Nations Cup, qualifying), the results and "My matches" lists, round results,
tournament brackets (cup detail, continental detail, Nations Cup finals,
Continental Clash), draw ceremonies' finished groups, the match preview's two
team blocks, head-to-head and meetings screens, the world ranking (switch to
the helper). The player's own nation opens its page too.

### The team page's new top section ("now")

Above the existing history, in this order:

1. **Ranking:** current world position, its movement since the last ranking
   release (the arrow/number the ranking screen already shows), points, and
   the confederation. Tapping the ranking opens the world ranking screen.
2. **Form:** the last five results (W/D/L chips with score and opponent),
   from the nation's fixtures in this save.
3. **Next match:** the nation's next fixture, if any (opponent, competition,
   date).
4. **Squad:** the team's overall strength (the same rating the match preview
   uses, "Overall 83") and its three best current players (name, position,
   rating). Builder's choice whether the players tap through to the player
   page; if they do, use the existing player detail target.
5. **Against you:** for any nation other than the manager's, the head-to-head
   record against the manager's nation (W/D/L and last meeting), linking to
   the existing meetings screen. Hidden on the manager's own page.

Both layouts: phone (`nation_vitrine_screen.dart`) and tablet
(`nation_vitrine_tablet_layout.dart` / `NationView`). Copy goes through the
normal l10n route (all seven `.arb` files, `copy/strings.csv` re-exported);
no em dashes; Czech written naturally (the copy review in progress flagged
nation names placed after prepositions: prefer label: value layouts).

### Left to the builder

Exact visual layout of the "now" block within the existing design system,
how many places beyond the known list are worth wiring, whether squad players
are tappable, loading/empty states (e.g. no fixtures yet, a nation with no
results this save).

## B. Tactic presets during the match

### Why

Before kick-off a manager applies a saved preset (a named shape plus the six
style sliders; `lib/domain/entities/tactic_preset.dart`, saved across saves,
applied from the tactics screen's app bar). During the match the same changes
are possible by hand in the in-match tactics sheet
(`lib/features/tactics/in_match_tactics.dart`: shape, XI, subs and the style
sliders are all live), but a prepared plan ("Chase it", "Park the bus") has to
be rebuilt slider by slider. Players want the presets there too, "the same as
before the match".

### Goals

1. The in-match tactics sheet offers the manager's saved presets, presented
   and applied the same way as on the pre-match tactics screen.
2. Applying one sets the formation and all six style sliders at once, as
   before kick-off.

### Behaviour

- Applying a preset mid-match changes the formation and instructions only.
  It never makes substitutions: the eleven on the pitch stay on and are
  re-placed into the new shape's slots the way an in-match formation change
  already re-places them. (Pre-match application re-picks the best XI; that
  part does not apply during a match.)
- The change takes effect from the current minute through the existing live
  re-simulation path (`_applyTactics` → `_resim` in
  `lib/features/match/match_screen.dart`), exactly like a manual change. No
  new engine path.
- Available wherever the in-match tactics sheet opens: during play, at half
  time, at the extra-time huddle and turnaround, and from the injury pause.
  Phone and tablet layouts of the sheet.
- The sliders stay manually adjustable after applying a preset, as they are
  now.
- Saving a new preset from inside the match is not required (builder's
  choice; if offered, it uses the existing preset store).
- The unused `matchInstructionsLocked` string ("set before kick-off…")
  describes a rule that no longer exists; remove it from all `.arb` files and
  the copy CSV so it can't resurface.

### Constraints for both parts

- Existing saves keep working: nothing here touches stored data.
- No schema change.
- Tests: widget tests for (A) a representative set of tap targets opening the
  page and the "now" section on phone and tablet, and for (B) applying a
  preset in the in-match sheet producing the expected formation and
  instructions with the same eleven players; the tablet route sweep and
  golden tests must stay green (update goldens only where the new top section
  legitimately changes the vitrine).

### Extra time responds to tactics (owner's decision)

Today a level knockout's extra time is not played by the match engine: at 90'
`WorldCupFinals.decideKnockout` draws it from a few half-chances weighted by a
strength pair (only the pre-extra-time talk tilts it), and the background
commit path in `hub_providers.dart` draws it again the same way. Shape,
sliders, substitutions and presets changed at the 90' huddle or the 105'
turnaround therefore do nothing. The owner chose to make them count:

- The live match engine plays extra time as two 15-minute periods
  (91'-105', 106'-120') with the same per-minute model as the ninety: fatigue
  carries on, changes and talks made at either break apply from that minute,
  and the AI opponent keeps reacting. Extra-time stoppage is not needed.
- The shootout stays as it is (named takers, composure from the turnaround
  talk), drawn from its own seeded stream (`fixture.id ^ 0x7F`, as today), so
  naming takers never moves extra time.
- What the screen shows is what is stored: the live commit path records the
  engine's after-extra-time score and the shown shootout, never a second
  `decideKnockout` draw. The background path for AI-only ties is unchanged.
- Each side keeps its substitution limit; extra time adds the extra
  substitution real tournaments allow (Claude's call: one more).
- Calibration guard: across many simulated level knockouts, the share decided
  in extra time vs on penalties stays close to today's (measured: about half settled in
  extra time), and the stronger side's edge does not grow beyond what the
  ninety minutes give it. Existing match-balance guard tests stay green.
- Saves: nothing stored changes shape; a knockout already played keeps its
  stored score.

### Decided by Claude (for the owner to check)

- `openNation` uses the side pane only on screens that have one; elsewhere
  (and on phones) it pushes the full page.
- "Overall" on the team page is the best XI's rating for other nations and
  the current lineup's for the manager's own.
- One extra substitution in extra time.

- One shared tap helper (`openNation`), side pane on tablet.
- Decorative flags in sentences are not tappable.
- Applying a preset mid-match never substitutes; it re-places the current
  eleven.
- The leftover "instructions locked" string is deleted.
