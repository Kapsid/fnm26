import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

/// Plans an AI-controlled team's substitutions for a match. The human manager
/// already reshapes their side live; this gives the opponent the same second-
/// half freshening so games aren't a static XI for 90 minutes.
///
/// The plan is deterministic from the supplied [SeededRng], so a match that is
/// re-simulated from its seed (as the live screen does after every human
/// change) always reproduces the same opponent subs — the timeline never jumps.
abstract final class AiSubstitutions {
  /// Second-half window the AI makes its changes in.
  static const _firstMinute = 58;
  static const _lastMinute = 82;

  /// A deterministic set of [Substitution]s for [nationId], swapping the
  /// weakest outfield starters for the best fresh legs of the same line. Never
  /// touches the goalkeeper. Returns fewer subs (or none) if the bench is thin.
  static List<Substitution> plan({
    required int nationId,
    required List<Player> xi,
    required List<Player> bench,
    required SeededRng rng,
    int maxSubs = 3,
  }) {
    // Fresh outfield options, strongest first.
    final available =
        bench.where((p) => p.category != PositionCategory.goalkeeper).toList()
          ..sort((a, b) => b.overall.compareTo(a.overall));
    if (available.isEmpty) return const [];

    final count = rng.rangeInt(2, maxSubs).clamp(0, available.length);
    if (count == 0) return const [];

    // Minutes: spread across the window, in order, so subs don't stack.
    final minutes = <int>[];
    for (var k = 0; k < count; k++) {
      final lo = _firstMinute + (_lastMinute - _firstMinute) * k ~/ count;
      final hi = _firstMinute + (_lastMinute - _firstMinute) * (k + 1) ~/ count;
      minutes.add(rng.rangeInt(lo, hi < lo ? lo : hi));
    }

    final onPitch = [...xi];
    final subs = <Substitution>[];
    var benchIdx = 0;
    for (var k = 0; k < count && benchIdx < available.length; k++) {
      final incoming = available[benchIdx++];
      // Replace the weakest outfield player of the incoming player's line who
      // is still on; fall back to the weakest outfield player overall.
      final off =
          _weakestOutfield(onPitch, incoming.category) ??
          _weakestOutfield(onPitch, null);
      if (off == null) break;
      onPitch.removeWhere((p) => p.id == off.id);
      subs.add(
        Substitution(
          teamNationId: nationId,
          minute: minutes[k],
          offId: off.id,
          on: incoming,
        ),
      );
    }
    return subs;
  }

  /// The minute an AI side makes its extra-time change: the first of the
  /// added thirty, so the fresh legs have the whole of extra time.
  static const extraTimeMinute = 91;

  /// One extra-time [Substitution] for [nationId] at [extraTimeMinute]: one of
  /// the two best fresh outfield players (picked by [rng], so the change is not
  /// the same every tie) for the weakest outfield player of his line still on,
  /// or the weakest outfield player overall. [onPitchAt90] is who finished the
  /// ninety (after regulation subs and dismissals) and [bench] who is still
  /// available, both the caller's to resolve. Null when no fresh outfield
  /// player is left. The caller seeds [rng] on its own stream (the live
  /// screen uses `fixture.id ^ 0x5196`), so the regulation [plan]'s draws are
  /// untouched by it.
  static Substitution? planExtraTime({
    required int nationId,
    required List<Player> onPitchAt90,
    required List<Player> bench,
    required SeededRng rng,
  }) {
    final available =
        bench.where((p) => p.category != PositionCategory.goalkeeper).toList()
          ..sort((a, b) => b.overall.compareTo(a.overall));
    if (available.isEmpty) return null;
    final incoming =
        available[rng.nextInt(available.length < 2 ? available.length : 2)];
    final off =
        _weakestOutfield(onPitchAt90, incoming.category) ??
        _weakestOutfield(onPitchAt90, null);
    if (off == null) return null;
    return Substitution(
      teamNationId: nationId,
      minute: extraTimeMinute,
      offId: off.id,
      on: incoming,
    );
  }

  /// The lowest-rated outfield player on the pitch, optionally restricted to a
  /// position category [cat]; null if there is none.
  static Player? _weakestOutfield(List<Player> onPitch, PositionCategory? cat) {
    Player? worst;
    for (final p in onPitch) {
      if (p.category == PositionCategory.goalkeeper) continue;
      if (cat != null && p.category != cat) continue;
      if (worst == null || p.overall < worst.overall) worst = p;
    }
    return worst;
  }
}
