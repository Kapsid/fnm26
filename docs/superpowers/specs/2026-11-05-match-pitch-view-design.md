# Match Pitch View — Design

Date: 2026-11-05. Owner-approved points are marked as theirs; items marked *(builder's call)* were decided by Claude where the owner gave no direction.

## Intent

The manager wants to *see* their match, not just read it. A condensed, realistic highlight view in the spirit of Football Manager's 2D match: a tilted stadium pitch with 22 moving players and a ball, where every real moment of the match (chances, saves, set pieces, penalties, cards, goals, subs) plays out on screen, in step with the clock and the commentary. The owner's reference is a screen recording of another mobile football manager (`~/Downloads/Video-2.mov`, 26 s): tilted stadium pitch with crowd in team colours, numbered discs, name tags on the ball players, one live commentary line, momentum bar, speed buttons. FNM builds its own version in its own visual style; it is inspiration, not a template.

Success: a manager picks Pitch before kick-off and watches a whole match in a few minutes that feels like a real match of football, where every goal they see is the goal the engine produced, in a stadium that clearly belongs to that match.

## Goals

- A **Pitch** view of the live match, chosen before kick-off on the Timeline area (Pitch or Timeline) and switchable at any time during the match. *(owner)*
- **Realistic, condensed** play. Time simply runs; there is no "nothing happening" card. Quiet spells show the teams keeping shape and moving the ball while the clock runs; real moments play out in full. *(owner)*
- **Unique moments, not canned clips**: open-play chances, shots (scored, saved, wide, blocked, woodwork), corners, free kicks (incl. wall), penalties (scored and missed), throw-ins, fouls, offsides, cards, injuries, substitutions. Each is staged from the match's own data so two matches never look the same. *(owner)*
- **The picture must agree exactly with the engine.** Every goal, shot, card and set piece on screen is one the engine produced; the animation never decides an outcome. *(owner: "yes, it must")*
- **Match length at the three speeds**: slowest 3–4 min, middle 2–3 min, fastest 1–2 min for a full 90 minutes, varying with how eventful the match is. Real moments are never rushed. *(owner)*
- **The stadium belongs to the match** *(owner)*:
  - the home nation's flags around the ground;
  - the crowd wears the two teams' colours, split by home and away support;
  - the stadium's size and shape follow its capacity (small ground: one low stand, open corners; mid: two tiers; big national stadium: tall stands all round);
  - crowd density follows the actual attendance;
  - famous cities show a landmark silhouette behind the stands (Paris Eiffel Tower, Rome Colosseum, more).
- **Commentary for real moments only**, several wordings per moment, in all 28 languages. No narration of build-up passes. *(owner)*
- **Tablet shows more**: a bigger pitch with live stats, line-ups and the full commentary feed visible at once. *(owner)*

## Non-goals

- A playable or controllable match. The manager still only manages (tactics, subs, talks).
- True 3D. The stadium is drawn with Flutter's own canvas as a tilted 2D projection, like the current pitch; no game engine, no 3D models. *(builder's call)*
- Commentary for build-up play.
- Changing background (unwatched) matches. `RatingMatchSimulator` and its October calibration stay untouched.
- Replaying past matches. (Possible later; see "Left to the builder".)
- A Pro gate. The Pitch view is free for everyone.
- Real players, real kits, real club crests or any real-world branding. Landmark silhouettes are generic city shapes, not logos.

## Anti-goals (owner's words: "bugs, unrealistic situations, bad graphics, out of the app design graphics")

- **Bugs**: the picture disagreeing with the score, timeline or commentary; a goal shown that didn't happen or not shown that did; the ball or a player teleporting; a sent-off or substituted player still on the pitch; crashes or hangs on any screen size.
- **Unrealistic situations**: players walking through each other, the keeper out of his goal for no reason, a corner taken from the wrong side, offside goals, a free kick with no wall, 12 players on one side, everyone chasing the ball, play that ignores the formation and tactics.
- **Bad graphics**: jitter, stutter, blurry or pixelated drawing, unreadable name tags, a crowd that is visibly a repeating pattern, a slow frame rate on an ordinary phone.
- **Out-of-design graphics**: anything that does not look like FNM ("Pro Pitch Executive" dark theme, its colours, typography, radii and disc style). No bright arcade look copied from the reference video.

## The engine change (owner: "it should play it but only internally for other modes")

Today `MatchEngine` (lib/domain/services/match/match_engine.dart) computes the whole match per minute and keeps only 5 event types: goal, substitution, yellow, red, injury. Shots, saves, corners, free kicks, fouls and offsides are decided implicitly or not at all, and then discarded. Penalties are a relabel of 9% of goals, so a penalty is never missed in play.

Decision *(owner)*: the engine itself plays the richer match, for **every** view, so a match is the same whichever view the manager watches. Specifically:

- It records every shot with shooter, minute, quality (xG), outcome (goal, saved, wide, blocked, woodwork) and the goalkeeper.
- Set pieces are typed (corner, free kick, throw-in, penalty) and recorded when they come to nothing, not just when they score.
- Penalties are awarded from fouls in the box and can be missed or saved. Free kicks come from fouls and can hit the wall.
- Fouls record the fouler and the fouled player. Offsides are recorded.
- Every event carries enough to stage it: team, players involved, a pitch zone or position, and an order within the minute (seconds or a sequence index).
- The player going off in a substitution gets an id, not just a name.
- The shootout records each kick's taker and outcome (scored, saved, missed) and a direction for the drawing.

The other views (Timeline, Stats, Lineups, tablet columns) keep showing what they show today; the extra detail is internal to them and drawn only by the Pitch view.

**Calibration**: the manager's own matches will play slightly differently from today. The engine is recalibrated so the outcomes stay close to the current figures (goals per match, home/away and favourite/underdog win rates, draw rate, share of penalty and set-piece goals, cards per match), pinned by guard tests in the same style as the existing match-balance tests. Background matches are unchanged.

**Saves**: matches already played keep their stored results. No existing save changes.

## Staging (how the pitch view plays the match)

- Between real moments, a **story layer** makes up believable build-up from the formations, tactics (width, line height, pressing, tempo), possession share and momentum: passes, carries, switches of play, pressing and recovery. It never creates an outcome; it only leads into the next real moment and back out of it.
- Each real moment is staged from its data: who, where, outcome. For example, a corner from the correct side with the taker, the header from the recorded scorer, and the keeper's save; a penalty with the fouled player, the run-up, the taker and the keeper's dive.
- The animation's own randomness is seeded from the match and the event, so the same match plays the same way when the manager switches views or pauses.
- Players keep their formation shape, move at believable speeds, keep spacing, and never pass through each other. Goalkeepers stay goalkeepers. Sent-off and substituted players leave the pitch on screen.
- Name tags show on the players on the ball and the key players of a moment, readable at every speed.
- Pausing for tactics, subs, half-time and extra-time talks works exactly as today; the clock-based pacing replaces the current fixed 360 ms-per-minute tick only in Pitch view.

## The stadium

- Drawn as a tilted (perspective) pitch with stands around it, in FNM's palette.
- Stand height and tiers follow `MatchGround.capacity`; crowd fill follows `attendance`.
- Crowd colours use the two nations' kit colours. The away share is a new small model *(builder's call)*: higher for neighbours, for big travelling nations and in tournaments, lower for long trips; neutral venues split by both teams' following. Home flags around the ground use the existing flag assets.
- Kits: the home team in its colours; the away team in its colours unless they clash, then a change kit derived from its secondary colour (new clash logic, *builder's call*).
- Landmarks: a curated first set of about 30 cities with a silhouette drawn in code (no image files) behind the far stand; every other ground gets a generic skyline or hills. More can be added in later updates.

## Screens

- **Before kick-off**: the Timeline area offers **Pitch** or **Timeline**. The choice is remembered for the next match *(builder's call)*.
- **During the match**: a switch between Pitch and Timeline at any time.
- **Phone (Pitch)**:
  - scoreboard and clock at the top;
  - the pitch;
  - one live commentary line under it;
  - the momentum bar;
  - play/pause and speed;
  - Stats and Lineups tabs;
  - Tactics, Subs and Talks in the bottom bar, as today.
- **Tablet (Pitch)**: a larger pitch with live stats, both line-ups and the full commentary feed visible at once, following the existing three-column tablet match layout.
- The goal flash, injury pause, half-time and shootout keep working; the shootout is drawn on the pitch (taker, run-up, dive, result).

## Copy

- Commentary lines for every real moment type, several wordings each, in all 28 languages through the `copy/strings.csv` round trip.
- Names come from the career (player names re-drawn per save, world-pack names when the career uses a database).
- No em dashes, never "World Cup" in English copy, and the World Championship naming rules apply.

## Constraints from the existing game

- Saves stay compatible. Any schema change follows the stepwise migration recipe.
- The match stays deterministic within an attempt. A re-sim after a tactics change reproduces every minute already watched; changes land at minute+1. This must keep holding.
- Must run smoothly on the ordinary Android phones the game already supports, at phone and tablet sizes. The tablet-ready sweep must cover the new view.
- Riverpod 2.6.1 without codegen. Drift with `build_runner --force-jit`.
- The 1.1.0 database editor is being built on `feature/world-editor`. This work goes on its own branch and worktree, and test runs take turns with the editor's (never two flutter processes at once).

## Decisions after the builder check (2026-11-05)

Owner:
1. **Free for everyone.** No Pro gate on the Pitch view.
2. **Ships in 1.1.0**, together with the database editor. Work runs on its own branch. The engine change and recalibration land first, as an invisible step, then the phone view, then tablet, landmarks and the away-fan model. All of it must be in 1.1.0.
3. **Visual sign-off first.** Before crowds, landmarks and movement are built, a static mock of the stadium and pitch (phone and tablet, small and big ground) is shown to the owner. Building stops until they approve the look.

Builder's calls:
4. **Minor moments flow, consequential ones are staged.**
   - Routine throw-ins, fouls with no consequence, and goal kicks are folded into the flow: the ball restarts in the right place, play doesn't stop, and there is no commentary line.
   - A moment is staged in full when it leads somewhere or matters on its own: a dangerous free kick, a card, a penalty, a corner, a long throw into the box, an offside that stops an attack, every shot.
   - The engine records what the staging needs: every shot and set piece, every card and penalty, plus a per-minute count for routine restarts. It does not record every throw-in as an event.
5. **Translations.** Claude writes all 28 languages' commentary through the `copy/strings.csv` round trip, as for earlier releases.
6. **Performance target.** 60 fps on the owner's Galaxy A56 at phone size, and never below 30 fps on weaker supported phones. The static stadium and crowd are cached, not redrawn every frame.
7. **Where new moments show outside the Pitch view.**
   - Missed and saved penalties, saves and woodwork are real match facts. They count in Stats (shots, xG come from the recorded shots), player ratings and stats, press and achievements wherever those already read shots or penalties.
   - The Timeline keeps its current event types.
   - Stats and Timeline therefore never contradict the pitch, because they read the same match.

## Owner's review of the first mock (2026-11-06)

The owner reviewed the first mock: "not bad but can we differ the feel a bit from that app". Then: "keep angle but add night options (and maybe times for matches and based on that country daylight?), also change a bit those players pills and maybe add different designs for pitch layering".

1. **Camera.** Keep the tilted end-on angle.
2. **Kick-off times and daylight.**
   - Every match gets a deterministic local kick-off time (builder's call):
     - friendlies are mostly in the evening;
     - tournament matches use their usual slots;
     - a share of matches are afternoon games.
   - Lighting follows real daylight at the ground on that date (day, dusk or night). It comes from the sun's elevation, using the nation's approximate latitude and the date.
   - Nations get an approximate latitude in a new data table (builder's call).
   - The kick-off time shows in the score strip.
3. **Night and dusk looks.**
   - Night: floodlight pools on the grass, soft shadows from the four corner towers, and the stands lit in team colours.
   - Dusk: a warm sky and longer shadows.
   - Day: as in the first mock.
4. **Player tokens.**
   - Shirt-shaped tokens in the kit colours replace the round discs and name pills. The number is on the shirt, and a small mark shows which way the player faces.
   - The name is a slim label under the token, with no pill.
5. **Mowing patterns.**
   - Stripes, checkerboard, wide bands, diagonal and centre circles.
   - The pattern is chosen per stadium, so a ground always looks the same.
7. **Sunset during the match** (owner: "which will change to night when appropriate").
   - Light is worked out for each minute, from the real clock time of that minute, at the nation's latitude on that date.
   - The clock includes half-time, the extra-time break and stoppage.
   - The sky, shadows and grass shift gradually.
   - Floodlights ramp up through dusk and never switch off during a match.
   - Stands light up in team colours at night.
8. **Goal styles by region** (owner: "different types of goal based on continent and country").
   - There are 3–4 net and frame styles, for example a deep box net with tall stanchions (South America) and a sloped European net.
   - The style is chosen by confederation, with country overrides and small-ground variants, and is the same every time per stadium.
   - True goal size is unchanged.
9. **Terrain and landmarks behind the stands** (owner: "i dont see that eifel, maybe mountains in bolivia and more"). This part of Task 12 is pulled forward into the second mock.
   - Terrain by country: mountains (Andes, Alps), sea, desert, hills, or a city skyline.
   - About 30 landmark silhouettes are drawn on top of the terrain.
   - Both react to day, dusk and night.
10. **Tournament dressing** (owner: "final tournaments should have some stripe or something … and finals golden design").
    - Finals-tournament matches get a tournament band on the ad boards and a coloured stripe around the pitch edge.
    - The final gets a golden look: gold accents, a gold stripe, and gold confetti at full time.
6. **Gate.** A second mock goes to the owner before anything else is built. It shows the same ground at day, dusk and night, three mowing patterns, and the new tokens.

## Left to the builder

- The event model's exact shape: new event types versus a richer event class; sequence or seconds within a minute; zones versus coordinates.
- The calibration method and the exact tolerance bands for each guard figure.
- The story layer's movement model (steering, formation anchoring, pass timing) and how it is tested for "no teleport, no overlap, legal positions".
- The rendering approach within Flutter's canvas (layers, caching the static stadium, frame budget).
- The away-fan share formula and the kit-clash rule.
- The landmark city list and the silhouettes.
- Commentary wording sets and how variants are picked deterministically.
- Whether to also persist the per-attempt seed so a finished match could be replayed later (not required now).
