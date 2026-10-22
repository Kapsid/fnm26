# Campaign: Best of Guineas (Pro, two cycles)

Date: 2026-10-21 · Status: owner request with answers, 2026-10-21

## What

A third campaign, the first Pro one. The manager takes **Equatorial Guinea** (id 116, rank 117, the lowest-ranked African Guinea) for **two cycles**.

- **Goal (★):** beat **Guinea** (123) and **Guinea-Bissau** (124) at least once each, in any match (competitive or friendly), across the two cycles.
- **★★:** ★ and qualify for an Africa Cup (continental finals, Africa) in either cycle.
- **★★★:** ★ and reach an Africa Cup quarter-final (or better) in either cycle.
- **Papua New Guinea (206):** not part of the goal. A friendly against them is pre-arranged at the start ("the fourth Guinea") as a fun extra, shown on the brief.

## Rules (owner's answers + Claude's calls)

- Pro only (`needsPro: true`). A free player sees a "Pro" badge on the card; Start opens the paywall, never a run. Pro players start it like the free ones.
- Two cycles: an unmoved run rolls over from its first cycle into its second (with the normal rollover screen; the manager keeps the job unless sacked). The run ends in the campaigns list only after its last cycle, as the free campaigns do after theirs. The general rule becomes: an unmoved campaign cannot start a cycle at or beyond `def.cycles`.
- Settlement: as soon as ★★★ is reached (nothing left to improve), otherwise at the end of the second cycle (World Championship decided in cycle index 1). A sacking before settlement fails the run (stars 0). Stars are the best reached at settlement.
- "Beat" = won the match (after extra time/penalties counts as a win for the shootout winner, as elsewhere in the game).
- Progress card: each rival with a tick once beaten; Africa Cup status per cycle (not qualified / qualified / best stage).
- Fixed world seed: Equatorial Guinea is not an Africa Cup host in either cycle; the seed guard test pins it (cycle 0 and cycle 1 hosts).
- The PNG friendly: arranged at campaign start in the first free international window of cycle 0, home, using the existing friendly-arrangement path. If no window is free it is skipped silently.
- Copy in all 12 languages: title "Best of Guineas", twist, goal, intro (mentions the PNG friendly), three star lines, "Pro" badge (existing string if one exists).
- Calibration: run the lab; autopilot never arranges friendlies, so report figures without forcing a band (a human can arrange friendlies against the rivals). Report the numbers to the owner.

## Constraints

No schema change (markers as for the other campaigns). Existing campaigns and normal careers unchanged. The general fix to multi-cycle rollover must keep the one-cycle campaigns ending exactly as now.
