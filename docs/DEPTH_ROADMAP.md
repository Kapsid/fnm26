# Depth Roadmap — implementation-grade design

Systems that add gameplay depth, designed against the actual architecture
(determinism model, drift/repository conventions, match-engine seams). Line
numbers are anchors at time of writing — re-grep before editing.

## Design rules this doc obeys

1. **Derive-from-seed by default.** If a property is an intrinsic, replayable
   fact about a player, it is a *pure function of id* (à la
   `PlayerLifecycle.developmentPotential(id)`, `player_lifecycle.dart:132`,
   hash `_mix` at `:143`). No table, no migration, free on cloud restore.
2. **Store only manager/result-mutated state**, in a career-scoped table keyed
   `{careerId, …}` with `onDelete: KeyAction.cascade`. Resolve player identity
   live from the id — never copy attributes/names into the table (the
   `NaturalizedPlayers` pattern).
3. **Match engine stays a pure replay** of `(teams, subs, changes, talks, rng)`.
   New per-team/per-player match state added to `_Live` is fine (it is rebuilt
   on every `_resim`); anything that touches outcomes must be added to
   *ratings*, not to an RNG stream, or the three forked streams
   (`rng` / `assistRng` `:404` / `setPieceRng` `:408`) drift.
4. **No Riverpod codegen.** Providers declared by hand in
   `features/<area>/<area>_providers.dart`; repos in `data_providers.dart`.

---

# System 1 — Player Traits & Star Quality (derived, no storage)

**The keystone.** Collapsing attributes to 3 made players fungible; traits give
each a fingerprint. Fully derived from id + position, so stable across saves and
free.

### New file `lib/domain/services/player/player_traits.dart`

```dart
enum PlayerTrait {
  // attacking
  clinicalFinisher, deadBallSpecialist, playmaker, flair, poacher,
  // physical
  pacey, aerialThreat, engine, powerhouse,
  // defensive / mental
  wall, ballWinner, composed, leader, bigGameplayer,
  // negative
  injuryProne, hotHeaded, inconsistent,
}

extension PlayerTraitX on PlayerTrait {
  String get label => switch (this) { … };      // "Clinical Finisher"
  bool get isNegative => switch (this) {
        PlayerTrait.injuryProne || PlayerTrait.hotHeaded ||
        PlayerTrait.inconsistent => true,
        _ => false,
      };
}

abstract final class PlayerTraits {
  /// Deterministic hidden traits from id + position ALONE (position is stable;
  /// attributes are not, so we don't gate on them → traits never flip on aging).
  /// Rarity-tuned: most players get 0-1 trait, stars 2-3.
  static Set<PlayerTrait> forPlayer(int id, PlayerPosition pos) {
    final h = _mix(id);                        // reuse the avalanche hash idea
    final cat = pos.category;
    final out = <PlayerTrait>{};
    // Each trait is an independent low-probability draw from a distinct bit
    // window of the hash, gated to plausible positions. Deterministic.
    void draw(PlayerTrait t, int bit, double p, {bool ok = true}) {
      if (ok && ((h >> bit) & 0x3ff) / 1024.0 < p) out.add(t);
    }
    draw(PlayerTrait.clinicalFinisher, 0,  0.10, ok: cat == PositionCategory.forward);
    draw(PlayerTrait.poacher,          2,  0.08, ok: cat == PositionCategory.forward);
    draw(PlayerTrait.playmaker,        4,  0.10, ok: cat == PositionCategory.midfielder);
    draw(PlayerTrait.wall,             6,  0.10, ok: cat == PositionCategory.defender);
    draw(PlayerTrait.deadBallSpecialist,8, 0.07);
    draw(PlayerTrait.aerialThreat,     10, 0.12,
        ok: cat == PositionCategory.defender || cat == PositionCategory.forward);
    draw(PlayerTrait.leader,           12, 0.06);
    draw(PlayerTrait.bigGamePlayer,    14, 0.05);
    draw(PlayerTrait.pacey,            16, 0.14);
    draw(PlayerTrait.injuryProne,      18, 0.08);
    draw(PlayerTrait.hotHeaded,        20, 0.08);
    // …cap at 3, negatives allowed on top.
    return out;
  }

  /// 1..5 perceived stardom, so two 82-overalls differ in aura. A hidden id
  /// draw blended with overall — used for news salience, "talisman", morale.
  static double starQuality(int id, int overall) {
    final base = (overall - 50) / 49;                 // 0..1 from ability
    final flair = ((_mix(id ^ 0x51ED) & 0x3ff) / 1024.0 - 0.5) * 0.3;
    return (1 + (base + flair).clamp(0, 1) * 4).clamp(1, 5);
  }

  static int _mix(int x) { … }                        // copy from PlayerLifecycle
}
```

### Wire onto the entity (zero plumbing everywhere else)

`lib/domain/entities/player.dart` — add derived getters next to `overall`
(`:33`), using the existing `const Player._();`:

```dart
Set<PlayerTrait> get traits => PlayerTraits.forPlayer(id, position);
double get starQuality => PlayerTraits.starQuality(id, overall);
```

Now traits are available in the match engine, set-piece screen, player detail,
and news with no new fields threaded.

### Match-engine hooks (`match_engine.dart`) — all byte-stable (multiply ratings/weights, touch no RNG)

| Effect | Function / line | Change |
|---|---|---|
| Clinical finisher converts better | conversion at `:499` & `:513` (`p = baseP * _finishingSharpness(energy)`) | `* _traitFinish(shooter)` where `clinicalFinisher`→1.15, `poacher`→1.08 |
| Who shoots | `_pickScorer` weight closure `:1035` | `* traitScorerWeight(p)` beside `roleOf(p.id)` |
| Who assists | `_pickAssister` weight `:1008` | `playmaker`→1.2 |
| Dead-ball priority | `_setPieceTaker` `:1136`, `_penaltyTaker` `:976` | `deadBallSpecialist` outranks by technical |
| Aerial goals | `_pickHeader` weight `:1114` | `aerialThreat`→1.3 |
| Cards | `_pickCulprit` `:863` / `_discipline` `:764` | `hotHeaded`→more likely; `composed`→less |
| Big-game lift | new `momentumAttack` (System 3) or a knockout flag threaded via `MatchTeam` | `bigGamePlayer` gets a small rating bump in finals |

Add `Map<int, Set<PlayerTrait>> traitsById` to `MatchTeam` (`:13`) computed once
in `match_providers.dart` (`p.traits`), or just call `shooter.traits` inline —
it's a cheap hash. Prefer inline; no struct change.

### Injury-prone hook
`hub_providers.dart` discipline/injury application (`Discipline.applyMatch`
`:837`) and the engine `_discipline` injuryFactor path (`match_engine.dart:764`,
factor from `injuryFactorByNation`): multiply per-player injury odds by
`injuryProne ? 1.6 : 1.0`.

### UI touchpoints
- `player_detail_screen.dart` — a trait chip row under the 3 stat bars; show
  `starQuality` as stars beside overall.
- `tactics_screen.dart` set-piece row (already shows technical) — badge
  `deadBallSpecialist`.
- News (`message_providers.dart`) — see the narrative engine below.

### Scouting gate (ties to System 6)
Store a per-career "trait revealed" flag so traits are hidden until a player is
capped N times or scouted — but the *values* stay derived. Reveal state is the
only stored bit.

**Effort:** M. One new pure file, two entity getters, ~7 one-line engine
multipliers, one UI row. No schema change.

---

# System 2 — Player Morale (derived from stored appearances, no new table)

Player-level morale, distinct from the existing *team* morale
(`Condition.morale`, used in `squadConditionProvider`,
`condition_providers.dart:75`). Lean on already-stored data: **Appearances**
(minutes/selection) + fixtures results. No new table.

### New pure service `lib/domain/services/player/player_morale.dart`

```dart
abstract final class PlayerMorale {
  /// 0..100 from recent selection & results for this player.
  /// Inputs are all already persisted (appearances + fixture results).
  static int of({
    required List<({DateTime date, int minutes})> recentApps, // from Appearances
    required List<int> teamResults,   // +1/0/-1 newest first, like NationForm
    required bool wasSelectedLast,
    required int starQuality,          // benching a star hurts more
    required DateTime asOf,
  }) {
    var m = 55.0;
    // playing time
    final started = recentApps.where((a) => a.minutes >= 60).length;
    m += started * 3 - (recentApps.isEmpty ? 8 : 0);
    if (!wasSelectedLast) m -= 4 + starQuality * 2;   // stars sulk
    // results (shared mood)
    for (final r in teamResults.take(6)) m += r * 2.0;
    return m.round().clamp(0, 100);
  }

  /// Net rating delta from morale, folded into overall like condition does.
  static int overallDelta(int morale) =>
      ((morale - 55) / 12).round().clamp(-3, 3);
}
```

### Integration (reuses the existing condition pipeline)
`condition_providers.dart` already folds a per-player delta into `overall` via
`withConditionDelta(p, delta)` (`:9`) and exposes `squadConditionProvider`
(`:75`) + `conditionDeltasFor` (`:102`, read by the match preview). **Add morale
into that same delta** so it flows to the engine for free:

- In `squadConditionProvider`, fetch each player's recent `Appearances`
  (`competitionRepository`) and compute `PlayerMorale.of(...)`, then combine
  `Condition.of(...).overallDelta + PlayerMorale.overallDelta(m)`.
- Team talks (`TeamTalk`, engine `:305`) become more/less effective by squad
  morale spread — pass a morale summary into `matchPreviewProvider` and scale
  `TeamTalkToneX.effect`.

### UI
- Call-up screen (`call_up_screen.dart`) already has a `_FormDot`; add a morale
  face/colour next to it.
- Player detail: a morale line + a one-line reason ("Wants more minutes").

**Effort:** S–M. One pure file, extend one provider. No schema change (derives
from stored appearances). If you later want *event-driven* morale (a bust-up, a
promise), that becomes a stored `{careerId, playerId}` table per the checklist.

---

# System 3 — In-match Momentum (engine-local, pure)

Swings within a match so a game breathes — a concession rocks a side, a goal
lifts it. Precedent: `talkAttack/talkDefence` (`_Live` `:305-306`).

### `match_engine.dart` changes
1. Add to `_Live` (`:281`): `double momentumAttack = 0, momentumDefence = 0;`
2. In `playMinute`, fold into the rating assembly (`:470-481`) exactly where
   `talkAttack` is added:
   ```dart
   final homeAttack = _attack(liveHome) + liveHome.talkAttack
       + liveHome.momentumAttack + homeAdv + _matchup(...);
   ```
3. **Update after goals are known** — right after the set-piece/goal block
   (`~:540`, `homeScore`/`awayScore` in scope). Pure function of events so far:
   ```dart
   void _bumpMomentum(_Live scoring, _Live conceding) {
     scoring.momentumAttack  = (scoring.momentumAttack + 1.4).clamp(-2.5, 2.5);
     conceding.momentumDefence =
         (conceding.momentumDefence - 1.0).clamp(-2.5, 2.5);
   }
   // plus per-minute decay toward 0 in _deplete or top of playMinute:
   liveHome.momentumAttack *= 0.94;
   ```
4. Optional: `bigGamePlayer` trait damps negative momentum for that side.

Because momentum is derived from the deterministic event stream and added to
ratings (not RNG), all three RNG streams stay byte-identical and `_resim`
rebuilds it correctly. Surface it as a live "momentum bar" in `match_screen.dart`
by exposing a `List<double> momentumByMinute` on `MatchResult` (like
`homeXgByMinute`, `:250`).

**Effort:** S. ~15 lines in one file + optional UI bar.

---

# System 4 — Tactical Familiarity & Squad Chemistry (stored per-career)

A whole-team multiplier rewarding a settled side and a drilled formation —
precedent is `_numbers(t)` (`_attack` `:1267` `return v * _numbers(t);`).

### Two signals
- **Formation familiarity** — how long the manager has used this shape.
- **Squad cohesion** — how often the current XI has played together.

Both are functions of stored appearances/tactics history, but computing cohesion
from co-occurrence every match is heavy; store a rolling scalar instead.

### Storage (follow the checklist)
`tables.dart`:
```dart
@DataClassName('TacticFamiliarityRow')
class TacticFamiliarities extends Table {
  IntColumn get careerId => integer().references(Careers, #id,
      onDelete: KeyAction.cascade)();
  TextColumn get formation => textEnum<Formation>()();
  RealColumn get familiarity => real().withDefault(const Constant(0))(); // 0..1
  @override Set<Column> get primaryKey => {careerId, formation};
}
```
Register in `app_database.dart`, bump `schemaVersion` (32→33, wipes saves).

### Service `lib/domain/services/tactics/team_chemistry.dart`
```dart
abstract final class TeamChemistry {
  /// Whole-team multiplier ~0.94..1.06 fed into _attack/_defence.
  static double factor({required double formationFamiliarity,
                        required double cohesion}) =>
      1 + (formationFamiliarity * 0.04 + cohesion * 0.04) - 0.04;

  /// Rolling update after a match: familiarity for the used formation rises,
  /// others decay; cohesion rises when the XI overlaps the last one.
  static double bumpFamiliarity(double current, {required bool used}) =>
      (used ? current + 0.08 : current - 0.03).clamp(0, 1);
}
```
Update in `SeasonService.playPlayerMatch` (`hub_providers.dart:771`, after result
recorded) and `startNextCycle` (decay on nation switch → new squad resets
cohesion, `:2189`).

### Engine hook
Thread `Map<int, double> chemistryByNation` into `MatchEngine.play` **exactly
like `injuryFactorByNation`** (`:366`), read it in `_attack` (`:1252`) and
`_defence` (`:1270`): `return v * _numbers(t) * chem;`. Built in
`match_providers.dart:254-283` beside the injury factor.

**Effort:** M. One table + repo + service + two engine lines + assembly.

---

# System 5 — Board Objectives with Stakes + Dynamic Difficulty (stored per-cycle)

Today `cycleObjectiveProvider` (`objective_providers.dart:29`) grades **only the
World Cup**, is fully derived, and has **no consequence**. Make objectives
multiple, staked, and consequential; add an adaptive difficulty scalar.

### 5a. Multi-objective with stakes
Widen `CycleObjective` (`objective_providers.dart:11`) and set a *committed*
objective set at cycle start so it can't drift when the ranking moves.

Store the committed targets (they're a promise, not derivable after the fact):
```dart
@DataClassName('CycleObjectiveRow')
class CycleObjectives extends Table {
  IntColumn get careerId => integer().references(Careers, #id,
      onDelete: KeyAction.cascade)();
  IntColumn get cycle => integer()();
  TextColumn get kind => textEnum<ObjectiveKind>()(); // worldCup/continental/ranking/develop
  IntColumn get target => integer()();                 // ordinal or rank
  TextColumn get stake => textEnum<ObjectiveStake>()();// mustHit/bonus
  @override Set<Column> get primaryKey => {careerId, cycle, kind};
}
```
Set them inside `startNextCycle` (`hub_providers.dart:2130`, right after
`advanceCycle` `:2208`) from the frozen cycle-start rank (reuse `_targetOrdinal`
`:62`). Grade at the boundary in `rolloverVerdictProvider`
(`nation_offers_providers.dart:80`).

### 5b. Consequences
Fold objective outcomes into the existing verdict maths:
- `_reputation` (`nation_offers_providers.dart:203`) — bonus for exceeding, hit
  for missing a `mustHit`.
- `sackBar` (`:123`) — a missed `mustHit` raises it hard (real sack risk).
- Board message chosen in `_verdict` (`:268`) and filed by `startNextCycle:2193`
  names the objective ("The board wanted the semi-finals; you delivered.").
- Feed graded result into `satisfactionProvider` (already hooks objectives at
  `achievement_providers.dart:177`).

### 5c. Dynamic difficulty (the missing challenge layer)
Add a `strengthFactorByNation` to `MatchEngine.play` **mirroring
`injuryFactorByNation`** (`:366`), applied in `_mean` (`:1290`) or as a team
scalar in `_attack`/`_defence`. Build it in `match_providers.dart:254` and in
`_squadStrength` (`hub_providers.dart:508`) for background sides.

```dart
// lib/domain/services/difficulty/difficulty.dart
abstract final class Difficulty {
  /// >1 makes YOUR opponents tougher. Rubber-bands to keep a dynasty honest:
  /// high reputation + easy objective ⇒ opponents raise their game.
  static double opponentFactor({
    required int reputation,      // rolloverVerdictProvider
    required int boardSatisfaction,
    required int cyclesAtNation,
  }) => (1 + (reputation - 50) / 400 + (cyclesAtNation) * 0.004)
        .clamp(0.95, 1.12);
}
```
Combine inputs in a `difficultyProvider(careerId)` reading `rolloverVerdict`,
`satisfaction`, career; read it where teams are assembled. Persist a difficulty
seed/scalar alongside `investment` via `careerRepository` if you want it sticky
per cycle.

**Effort:** L. One table, verdict rewrite, engine factor plumb (parallels an
existing pattern), a difficulty service + provider.

---

# System 6 — Scouting Network (stored links, clones naturalisation)

Reasons to act between tournaments + the reveal gate for traits. The
naturalisation pipeline is the template end-to-end.

- **Department**: `FederationFinance` already labels the naturalisation building
  "Scouting Office" (`federation_finance.dart:206`). Reuse
  `Department.naturalization`'s slider and `naturalizationChance` curve (`:140`)
  as scouting yield.
- **Roll/candidate model**: clone `_maybeGenerateNaturalizationOffer`
  (`hub_providers.dart:2448`) + `_rollNaturalizationIfDue` (`:2434`) → generate
  *scout reports* on newgens/foreign talent (players resolved live via
  `playerRepository.byNation(agingYears:, saveSeed:)`).
- **Storage**: a `ScoutReports {careerId, playerId, revealedTraits(bool),
  knowledge(int 0..100)}` table (checklist §), exactly like `NaturalizedPlayers`
  stores only the link.
- **Event**: new `HubEventKind.scoutReport` in `nextEventProvider`
  (`hub_event.dart:23` enum + a branch by the naturalisation one `:185`).
- **Payoff**: scouting raises `knowledge`, which reveals System-1 traits and the
  hidden `developmentPotential` band, informing call-ups and (future) a
  naturalise/promote decision.

**Effort:** M–L (mostly cloning an existing pipeline + one screen).

---

# System 7 — Standout Performances & Player Legacy

Make individual games memorable and give players a remembered history beyond
goals.

### 7a. Richer match ratings
`_mark` (`match_engine.dart:671`) currently keys only on
goals/assists/result/cards. Add lightweight per-player counters to `_Live`
(increment the resolved `shooter` at `:497/:511`, assister, header, culprit
victims), pass aggregates into `_rate` (`:622`)→`_mark`. `manOfTheMatch`
(`:272`) improves for free; traits/momentum triggers can feed it too.

### 7b. Memorable-match store
Persist standout games (hat-tricks, high MOTM, big-game winners) so a player's
profile and the news can recall them:
```dart
@DataClassName('CareerMomentRow')
class CareerMoments extends Table {
  IntColumn get careerId => integer().references(Careers, #id,
      onDelete: KeyAction.cascade)();
  IntColumn get playerId => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get kind => textEnum<MomentKind>()(); // hatTrick, finalWinner, motmStreak
  TextColumn get note => text()();
  @override Set<Column> get primaryKey => {careerId, playerId, date};
}
```
Write in `playPlayerMatch` (`hub_providers.dart:771`, after `_rate`/records
`:971`). Surface in `player_detail_screen.dart` and the records book
(`record_book_*`).

**Effort:** M.

---

# Cross-cutting — Narrative / Commentary engine

The systems above only *feel* deep if surfaced. One consumer ties them together.

- **Match timeline text** — when the engine emits a goal `MatchEvent` (`:943`),
  attach a phrase keyed by scorer traits + momentum ("the poacher pounces",
  "against the run of play"). Do it in `match_screen.dart` event rendering, not
  the engine (keep the engine data-only), reading `event` + `player.traits`.
- **News** (`message_providers.dart`) — the existing variant system already
  names players (awards `:304`). Add: talisman watch (high `starQuality`), morale
  bust-ups (System 2), objective verdicts (System 5), scout reveals (System 6),
  legacy moments (System 7). Keep the short, dry tone from the recent rewrite.

---

# Suggested build order

1. **System 1 (Traits) + narrative goal text** — highest identity payoff, no
   schema change, self-contained. Do first.
2. **System 3 (Momentum)** — tiny, makes matches read as dramatic; pairs with 1.
3. **System 2 (Morale)** — reuses the condition pipeline, no schema change.
4. **System 5 (Objectives + Difficulty)** — the stakes/challenge layer; first
   schema bump.
5. **System 4 (Chemistry)** and **System 7 (Legacy)** — polish.
6. **System 6 (Scouting)** — biggest, and best once traits (1) exist to reveal.

Each of 1–3 is shippable alone. 4–7 share one schema bump (batch them).

# Determinism & test checklist (per system)

- Traits/star quality: pure `f(id, position)` → add a golden test asserting a
  fixed id yields a fixed set; assert stability across `agingYears`.
- Momentum/counters: assert `MatchEngine.play` is still byte-identical for the
  same seed with the feature off (factor = 1), and that `_resim` reproduces the
  same `MatchResult` (the `match_screen` re-sim path).
- Morale/chemistry/objectives: career-scoped tables → covered by the destructive
  migration; add a unit test that the derived delta is 0 at the neutral input so
  existing match tests don't shift.
- Any engine factor map (`chemistryByNation`, `strengthFactorByNation`) must
  default to `1.0` / empty so all current `test/unit/match/*` stay green.
