# Player agency

**Date:** 2026-08-07
**Status:** approved design

## Problem

The squad is inventory. Nobody asks why he isn't playing, nobody wants back in,
nobody minds being shoved out of position. There is a full press system that
trades dressing room against boardroom, and a morale model that feeds every
match — but no player has ever addressed the manager personally.

## Decisions

- Two grievances ship: **game time** and **a squad place**. A **role**
  grievance was designed and cut on contact with the data — see below. Not the
  armband.
- The manager **answers with a tone**, exactly as he answers the press.
  Answers are not tracked as breakable promises.
- Ignoring a man costs **team morale**, gets him **complaining on Y**, and can
  end with him **walking away from international football**.
- **No schema change and no wiped save.** Answers reuse `PressAnswers` under a
  `grv:` key; a walkout is recorded as the inbox message that announces it.

## Grievances

`GrievanceKind { gameTime, squadPlace, role }`, detected by a pure function over
data the save already holds:

- **gameTime** — in the current squad, with no appearance in the nation's last
  **3** played matches. `CallUps` holds only the current squad and no history,
  so "three windows in the squad" is not knowable; "in the squad and not
  playing" is, and is the same grievance.
- **squadPlace** — inside the **top 25** of the nation's pool by rating, **not**
  called up for 3 consecutive windows, and aged 24 or over. A young player left
  out is waiting his turn; a 29-year-old repeatedly passed over is being told
  something.
**The role grievance is not in this build.** `PlayerRatings` records what a
player did in a match but not the position he was played in, so "he keeps being
shoved out of position" is not derivable from anything stored. It needs a new
column, which means a schema bump and a wiped save — a real cost to pay for one
grievance, and a decision for the player rather than an accident. The
`GrievanceKind` enum leaves room for it.

At most **one grievance per player**, and at most **two active at once**, so the
hub never becomes a queue of complaints. When more men qualify than there is
room for, the most senior by caps speaks — he is the one with the standing to.

A grievance's key is `grv:<kind>:<playerId>:<window>`, so it is raised once and
never re-asked.

## Answering

It arrives as a hub event beside the press conference, with three tones:

| Tone | Dressing room | Standing |
| --- | --- | --- |
| `reassure` — you are in my plans | +3 | −1 |
| `honest` — you are behind others, and here is why | +1 | +1 |
| `dismiss` — I pick the team | −3 | +1 |

Sized like a press answer: a nudge, not a result. `honest` is deliberately the
safe answer and `reassure` the cheap one, because promises are **not** tracked
and broken — so an unkept promise costs nothing later, and telling a man the
truth must therefore not be worse than lying to him.

Stored in the existing `PressAnswers` table: `questionKey` takes the `grv:` key,
`tone` the grievance tone's name, and the deltas the table already carries.

## Ignoring him

A grievance left unanswered for a full window hardens:

1. **Morale.** −4 to the dressing room while it stands, through the existing
   morale term, so it reaches every match.
2. **Y.** He posts about it — a new `YVoice.player` on the feed. The public
   takes a view, which moves public mood, which now reaches the board.
3. **The walkout.** A player aged **30 or over** whose grievance has stood
   unanswered for **two** windows retires from international football. Younger
   men sulk; a proud veteran leaves.

## The walkout, without a wipe

A permanent retirement needs a persisted fact, and a new table would mean
schema 40 and another wiped save. Instead the walkout is recorded as the inbox
message announcing it, keyed `walkout:<playerId>` — a permanent, per-career row
in a table that already exists. **The announcement is the record.**

This makes the inbox load-bearing in a way it was not before, which is unusual
and is the one thing to weigh against it. The alternative costs the player their
save, which is worse.

Walked-out players are filtered out of `squadDataProvider` (so they cannot be
called up) and `tacticDataProvider` (so they cannot be fielded). The derived
pool itself is untouched — a walkout is a fact about this career, not about the
player.

## Testing

- A settled squad raises no grievance.
- Each kind fires on its own threshold and not before.
- One grievance per player; at most two active; the most-capped man speaks.
- A key is never raised twice.
- Tone effects are bounded and `honest` is never worse than `dismiss`.
- An ignored grievance escalates on schedule: morale, then a post, then — for a
  veteran only — a walkout.
- A walked-out player never appears in the call-up pool again, and the record
  survives a reload because it is a stored message.

## Out of scope

The armband as a grievance, promises tracked and broken, players reacting to
each other, transfer or club demands, and any new table.
