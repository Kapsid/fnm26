import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tactics.freezed.dart';

/// Team instructions, each on a 0–100 scale (50 = balanced).
@freezed
abstract class TacticalInstructions with _$TacticalInstructions {
  const factory TacticalInstructions({
    @Default(50) int mentality, // defensive ↔ attacking
    @Default(50) int pressing, // low block ↔ high press
    @Default(50) int tempo, // patient ↔ fast
    @Default(50) int width, // narrow ↔ wide
    @Default(50) int defensiveLine, // deep ↔ high
    @Default(50) int directness, // possession ↔ direct
  }) = _TacticalInstructions;
}

/// The side's general playing style: one decision that sets the whole shape of
/// the instructions beneath it.
///
/// Six dials, each 0–100, is a lot to ask of a manager who simply wants their
/// team to press and play out from the back. A playstyle is that sentence: it
/// composes straight into [TacticalInstructions], and the dials stay available
/// underneath for anyone who wants to trim it. Moving a dial by hand makes the
/// style [Playstyle.custom] — the style is a description of the tactic, so it
/// must never claim to describe one it no longer matches.
enum Playstyle {
  /// No stated style: whatever the dials happen to say.
  custom,

  /// Nothing overdone in any direction.
  balanced,

  /// Keep the ball, move it patiently, squeeze the pitch high.
  possession,

  /// Hunt the ball the moment it is lost, high line, quick vertical play.
  gegenpress,

  /// Sit off, stay compact, break at speed the moment the ball turns over.
  counter,

  /// Get it forward early and play for the second ball.
  direct,

  /// Deep, narrow and hard to beat; the game is survived rather than won.
  lowBlock,

  /// Stretch the pitch, get round the outside and cross.
  wingPlay,
}

/// What each playstyle actually asks for, on the same 0–100 dials.
extension PlaystyleX on Playstyle {
  /// The instructions this style composes into. [Playstyle.custom] has none —
  /// it *is* whatever the dials say — so it returns null.
  TacticalInstructions? get instructions => switch (this) {
    Playstyle.custom => null,
    Playstyle.balanced => const TacticalInstructions(),
    Playstyle.possession => const TacticalInstructions(
      mentality: 60,
      pressing: 60,
      tempo: 35,
      width: 60,
      defensiveLine: 65,
      directness: 20,
    ),
    Playstyle.gegenpress => const TacticalInstructions(
      mentality: 75,
      pressing: 90,
      tempo: 80,
      width: 55,
      defensiveLine: 85,
      directness: 60,
    ),
    Playstyle.counter => const TacticalInstructions(
      mentality: 35,
      pressing: 30,
      tempo: 70,
      width: 40,
      defensiveLine: 30,
      directness: 75,
    ),
    Playstyle.direct => const TacticalInstructions(
      mentality: 60,
      pressing: 55,
      tempo: 75,
      width: 55,
      defensiveLine: 55,
      directness: 90,
    ),
    Playstyle.lowBlock => const TacticalInstructions(
      mentality: 20,
      pressing: 20,
      tempo: 40,
      width: 30,
      defensiveLine: 20,
      directness: 60,
    ),
    Playstyle.wingPlay => const TacticalInstructions(
      mentality: 60,
      pressing: 55,
      tempo: 60,
      width: 90,
      defensiveLine: 55,
      directness: 55,
    ),
  };

  /// The style whose profile [i] matches exactly, or [Playstyle.custom].
  static Playstyle matching(TacticalInstructions i) {
    for (final s in Playstyle.values) {
      if (s == Playstyle.custom) continue;
      if (s.instructions == i) return s;
    }
    return Playstyle.custom;
  }
}

/// A team's tactic for a save: shape, chosen XI (slot → player id, or null if a
/// slot is empty), instructions, and the general style they compose from.
@freezed
abstract class Tactic with _$Tactic {
  const factory Tactic({
    required Formation formation,
    required List<int?> lineup, // length 11, slot order matches the formation
    @Default(TacticalInstructions()) TacticalInstructions instructions,
    @Default(Playstyle.custom) Playstyle playstyle,
    @Default(FullBackPushes.neutral) FullBackPushes fullBacks,

    /// Places changed within the formation (see [SlotSwitches]).
    @Default(SlotSwitches.none) SlotSwitches switches,

    /// How the side takes its throw-ins (see [ThrowInStyle]).
    @Default(ThrowInStyle.neutral) ThrowInStyle throwInStyle,
  }) = _Tactic;

  const Tactic._();

  /// The place each slot plays: the formation's positions with [switches]
  /// applied. Read this, never `formation.positions`, wherever a slot's
  /// position matters.
  List<PlayerPosition> get positions => switches.apply(formation);
}

/// How a side takes its throw-ins.
///
/// Deliberately slight, and [neutral] is exactly the game as it always was:
/// the engine reads nothing new for it. [long] turns the odd throw in the
/// attacking third into a delivery into the box (a small extra chance, worth
/// more with a strong thrower and tall attackers) at the price of giving the
/// ball away a touch more often. [defensive] keeps every throw safe: a few
/// fewer turnovers, and a few fewer chances made. See
/// `MatchEngine.throwInLift` and `MatchEngine._longThrow`.
enum ThrowInStyle {
  /// No instruction: throws taken as the play allows (the default).
  neutral,

  /// Long throws into the box from the attacking third.
  long,

  /// Throws kept short and safe.
  defensive,
}

extension ThrowInStyleX on ThrowInStyle {
  /// Reads a stored name; anything unknown or missing is
  /// [ThrowInStyle.neutral], so a save, preset or library entry from before
  /// throw-ins existed plays as it always did.
  static ThrowInStyle parse(Object? name) => ThrowInStyle.values.firstWhere(
    (v) => v.name == name,
    orElse: () => ThrowInStyle.neutral,
  );
}

/// One full-back's individual instruction: stay put, push on, or hold back.
///
/// Deliberately slight. Pushing a full-back on adds a little to the side's
/// chance creation and as much to what it concedes down that flank; holding
/// him back is the reverse. See `MatchEngine.fullBackLift`.
enum FullBackPush {
  /// No instruction: he plays the side's plan (the default).
  neutral,

  /// Push on: overlap and join the attack.
  up,

  /// Hold back: stay home and mind the flank.
  down,
}

extension FullBackPushX on FullBackPush {
  /// +1 pushed on, -1 held back, 0 neutral.
  int get step => switch (this) {
    FullBackPush.neutral => 0,
    FullBackPush.up => 1,
    FullBackPush.down => -1,
  };

  /// The next state a tap on the pitch arrow moves to: neutral, up, down,
  /// neutral.
  FullBackPush get next => switch (this) {
    FullBackPush.neutral => FullBackPush.up,
    FullBackPush.up => FullBackPush.down,
    FullBackPush.down => FullBackPush.neutral,
  };

  /// Reads a stored name; anything unknown or missing is
  /// [FullBackPush.neutral], so a save or preset from before the arrows
  /// existed plays as it always did.
  static FullBackPush parse(Object? name) => FullBackPush.values.firstWhere(
    (v) => v.name == name,
    orElse: () => FullBackPush.neutral,
  );
}

/// Which full-back an arrow belongs to.
enum FullBackSide { left, right }

/// The left and right full-backs' arrows (see [FullBackPush]).
///
/// An arrow only counts while the shape has a defender on that flank: the
/// left-back's slot ([PlayerPosition.lb]) or the right-back's
/// ([PlayerPosition.rb]), which a back four and a back five both have and a
/// back three does not. Without one it is kept (so switching back restores it)
/// but does nothing; see [netFor].
@immutable
class FullBackPushes {
  const FullBackPushes({
    this.left = FullBackPush.neutral,
    this.right = FullBackPush.neutral,
  });

  /// Reads [toJson]'s form back; missing or damaged values are neutral.
  factory FullBackPushes.fromJson(Object? json) => json is Map
      ? FullBackPushes(
          left: FullBackPushX.parse(json['left']),
          right: FullBackPushX.parse(json['right']),
        )
      : neutral;

  static const FullBackPushes neutral = FullBackPushes();

  final FullBackPush left;
  final FullBackPush right;

  FullBackPush of(FullBackSide side) =>
      side == FullBackSide.left ? left : right;

  /// These arrows with [side] set to [push].
  FullBackPushes withSide(FullBackSide side, FullBackPush push) =>
      side == FullBackSide.left
      ? FullBackPushes(left: push, right: right)
      : FullBackPushes(left: left, right: push);

  /// These arrows with [side] moved on one tap ([FullBackPushX.next]).
  FullBackPushes cycled(FullBackSide side) => withSide(side, of(side).next);

  /// What a loaded preset or library entry leaves: [loaded]'s arrows, unless
  /// it has none set, when these stay. An entry saved before the arrows
  /// existed (or saved without touching them) says nothing about the
  /// full-backs, so loading it must not quietly clear the manager's.
  FullBackPushes overlaidWith(FullBackPushes loaded) =>
      loaded.isNeutral ? this : loaded;

  bool get isNeutral =>
      left == FullBackPush.neutral && right == FullBackPush.neutral;

  /// The side whose full-back plays [position], or null for any other place.
  static FullBackSide? sideOf(PlayerPosition position) => switch (position) {
    PlayerPosition.lb => FullBackSide.left,
    PlayerPosition.rb => FullBackSide.right,
    _ => null,
  };

  /// Whether a side lined up in [slots] has a full-back on [side].
  static bool hasSide(Iterable<PlayerPosition> slots, FullBackSide side) =>
      slots.any((p) => sideOf(p) == side);

  /// The net push (up = +1, down = -1 per arrow) of a side lined up in
  /// [slots]: an arrow on a flank with no full-back counts nothing.
  int netFor(Iterable<PlayerPosition> slots) =>
      (hasSide(slots, FullBackSide.left) ? left.step : 0) +
      (hasSide(slots, FullBackSide.right) ? right.step : 0);

  /// Stored form: only the non-neutral sides, so an untouched tactic writes
  /// nothing.
  Map<String, String> toJson() => {
    if (left != FullBackPush.neutral) 'left': left.name,
    if (right != FullBackPush.neutral) 'right': right.name,
  };

  @override
  bool operator ==(Object other) =>
      other is FullBackPushes && other.left == left && other.right == right;

  @override
  int get hashCode => Object.hash(left, right);

  @override
  String toString() =>
      'FullBackPushes(left: ${left.name}, '
      'right: ${right.name})';
}

/// A couple of places changed WITHIN a formation, without picking another one:
/// one of a 4-3-3's central midfielders dropped into a holding role or pushed
/// up behind the striker, a wide midfielder pushed on as a winger, a striker
/// dropped in behind his partner.
///
/// Choosing a formation chooses a whole structure; this is the small tweak a
/// manager makes to the structure he already has. Each slot may only become a
/// position natural for it ([alternativesFor]), and only [maxChanged] slots
/// may be changed at once, so the shape stays recognisably the one picked.
///
/// The switched position is simply the slot's [PlayerPosition] from then on:
/// every reader (fit and out-of-position marks, the match engine, the shape
/// count, auto-pick) reads [apply]'s list instead of [FormationX.positions].
/// Nothing new is weighed anywhere; the existing positional logic does the
/// rest.
@immutable
class SlotSwitches {
  const SlotSwitches([this.bySlot = const {}]);

  /// Reads [toJson]'s form back. Anything damaged or unknown is dropped
  /// rather than failing the load: an entry that is not valid for the
  /// formation it is used with is ignored by [apply] anyway.
  factory SlotSwitches.fromJson(Object? json) {
    if (json is! Map) return none;
    final out = <int, PlayerPosition>{};
    for (final e in json.entries) {
      final slot = int.tryParse('${e.key}');
      final position = PlayerPosition.values
          .where((p) => p.name == '${e.value}')
          .firstOrNull;
      if (slot != null && position != null) out[slot] = position;
    }
    return out.isEmpty ? none : SlotSwitches(Map.unmodifiable(out));
  }

  static const SlotSwitches none = SlotSwitches();

  /// How many slots may be changed at once: "a couple".
  static const int maxChanged = 2;

  /// Slot index (0 to 10) to the position it plays instead of the
  /// formation's own.
  final Map<int, PlayerPosition> bySlot;

  /// The positions a slot that is [base] in its formation may switch to.
  /// Only positions the game already has; a slot with none (the keeper, the
  /// back line) cannot be switched.
  static List<PlayerPosition> alternativesFor(PlayerPosition base) =>
      switch (base) {
        PlayerPosition.cm => const [PlayerPosition.dm, PlayerPosition.am],
        // A holding man may step up one line or two: a 4-3-3 whose DM plays
        // as a ten is still a 4-3-3.
        PlayerPosition.dm => const [PlayerPosition.cm, PlayerPosition.am],
        PlayerPosition.am => const [PlayerPosition.cm, PlayerPosition.st],
        PlayerPosition.lm => const [PlayerPosition.lw],
        PlayerPosition.rm => const [PlayerPosition.rw],
        PlayerPosition.lw => const [PlayerPosition.lm],
        PlayerPosition.rw => const [PlayerPosition.rm],
        PlayerPosition.st => const [PlayerPosition.am],
        PlayerPosition.gk ||
        PlayerPosition.lb ||
        PlayerPosition.cb ||
        PlayerPosition.rb => const [],
      };

  /// Only the entries that make sense in [formation] (a real slot, switched
  /// to one of its alternatives), and at most [maxChanged] of them.
  SlotSwitches validFor(Formation formation) {
    final base = formation.positions;
    final kept = <int, PlayerPosition>{};
    for (final slot in bySlot.keys.toList()..sort()) {
      if (kept.length >= maxChanged) break;
      if (slot < 0 || slot >= base.length) continue;
      final to = bySlot[slot]!;
      if (alternativesFor(base[slot]).contains(to)) kept[slot] = to;
    }
    if (kept.length == bySlot.length) return this;
    return kept.isEmpty ? none : SlotSwitches(Map.unmodifiable(kept));
  }

  /// [formation]'s positions with these switches applied: the place each slot
  /// actually plays. Invalid entries are ignored (see [validFor]).
  List<PlayerPosition> apply(Formation formation) {
    final valid = validFor(formation);
    if (valid.isEmpty) return formation.positions;
    final out = [...formation.positions];
    valid.bySlot.forEach((slot, to) => out[slot] = to);
    return List.unmodifiable(out);
  }

  /// Whether [slot] may be switched now in [formation]: it has alternatives,
  /// and either it is already switched or fewer than [maxChanged] are.
  bool canSwitch(Formation formation, int slot) {
    final base = formation.positions;
    if (slot < 0 || slot >= base.length) return false;
    if (alternativesFor(base[slot]).isEmpty) return false;
    final valid = validFor(formation);
    return valid.bySlot.containsKey(slot) || valid.count < maxChanged;
  }

  /// These switches with [slot] playing [to] in [formation]. The slot's own
  /// position (or null) resets it. A switch the slot does not allow, or one
  /// over the limit, leaves these unchanged.
  SlotSwitches withSlot(Formation formation, int slot, PlayerPosition? to) {
    final valid = validFor(formation);
    final base = formation.positions;
    if (slot < 0 || slot >= base.length) return valid;
    if (to == null || to == base[slot]) {
      if (!valid.bySlot.containsKey(slot)) return valid;
      final next = Map.of(valid.bySlot)..remove(slot);
      return next.isEmpty ? none : SlotSwitches(Map.unmodifiable(next));
    }
    if (!canSwitch(formation, slot)) return valid;
    if (!alternativesFor(base[slot]).contains(to)) return valid;
    return SlotSwitches(Map.unmodifiable({...valid.bySlot, slot: to}));
  }

  bool get isEmpty => bySlot.isEmpty;
  int get count => bySlot.length;

  /// Stored form: slot index (as a string) to position name. Empty for an
  /// untouched shape, so a tactic with no switches writes nothing.
  Map<String, String> toJson() => {
    for (final e in bySlot.entries) '${e.key}': e.value.name,
  };

  @override
  bool operator ==(Object other) =>
      other is SlotSwitches &&
      other.bySlot.length == bySlot.length &&
      bySlot.entries.every((e) => other.bySlot[e.key] == e.value);

  @override
  int get hashCode => Object.hashAllUnordered(
    bySlot.entries.map((e) => Object.hash(e.key, e.value)),
  );

  @override
  String toString() => 'SlotSwitches(${toJson()})';
}
