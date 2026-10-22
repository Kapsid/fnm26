# Campaign: Young Finns (Pro, three cycles)

Date: 2026-10-21 · Status: owner request with answers, 2026-10-21

## What

A fourth campaign, Pro, medium difficulty. The manager takes **Finland** (id 17) for **three cycles**, but Finland's whole senior player pool has been replaced by a golden generation of teenagers: every player available to Finland at the start is **18 or younger**. They are raw now and grow into a very good side, the way Norway's young generation did. Flavour, not real people: no real player is named anywhere.

- **★:** qualify for a World Championship (the finals) in any of the three cycles.
- **★★:** win a European Championship in any of the three cycles.
- **★★★:** win a World Championship in any of the three cycles.
- Stars are the highest tier reached (winning the World Championship is ★★★ even without a European title). Claude's call: the owner listed the tiers as separate goals, and ★★★ already implies qualifying.

## The players (owner: "all higher potential, something around Portugal, but realistically Finnish")

- At the start, Finland's selectable pool is only these youngsters, aged 15 to 18 (most 17-18, a few 15-16 call-ups allowed by the existing `callUpMinAge`). Enough of them for a full squad in every position, with depth (about 30 to 35).
- Their current ability is low for now, as teenagers are: Finland should be roughly as strong as today or a bit weaker in cycle 1, so qualifying is not a given.
- Their potential is high, so by cycle 2 to 3 the side reaches roughly Portugal's level (a top-ten side) if the manager plays and develops them. A few rare stars, not a whole team of superstars.
- Names: realistic Finnish first names and surnames from Finland's own name pools (the same pools the game uses for Finland), no duplicates, no real internationals.
- The run is fixed: the same youngsters every time the campaign starts (deterministic from the campaign seed).
- The existing senior Finns leave Finland's pool for this run only (retired or otherwise unavailable to Finland). Other nations are untouched.

## Rules

- Pro only (`needsPro: true`), lock sticker like the other Pro campaign. Free players: Start opens the paywall.
- Three cycles, rolling over like Best of Guineas. Settles as soon as ★★★ is reached, otherwise at the end of the third cycle. A sacking before settlement fails the run (0 stars), as for the other campaigns.
- `canContinue: false`: a settled run cannot be moved into the save slots (the modifier is too big for a normal career).
- Fixed world seed: Finland is never a host of the World Championship or the European Championship in any of the three cycles (it would hand over a qualification). A seed guard test pins this, like the other campaigns' seed tests.
- Copy in every app language: title "Young Finns", the twist line, goal, brief intro (golden generation, Norway-style rise, no real names, no "World Cup"), three star lines.
- Calibration: run the campaign lab on autopilot and report star rates to the owner. Target "medium": autopilot should usually get ★ at least once in three cycles and rarely ★★★. Tune potential/ability, not the goal.

## Constraints

- No schema change. Existing saves and the other campaigns behave exactly as now. Normal careers never see these players.
- Whatever mechanism creates the youngsters must survive save/reload, rollover, aging, the youth pyramid and the per-career bundle export/import, like any other player in a run.
- Use existing seams (the player pool, naturalisation, the youth pyramid's newgen rows, the per-career markers) rather than a parallel player system. The builder chooses which.
