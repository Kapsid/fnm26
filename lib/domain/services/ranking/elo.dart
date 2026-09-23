import 'dart:math';

/// How deep a nation went in a finals tournament — the placing itself, as
/// opposed to the matches that produced it.
///
/// [credit] is the share of the tournament a placing is worth, from 0 for a
/// group-stage exit to 1 for the trophy. Only the DIFFERENCES matter: the
/// placing exchange subtracts the field's mean credit, so the numbers are a
/// shape (a semi-final is a bit over half a title; a last-16 exit is barely
/// above the group) rather than a scale. The scale is [Elo.placement].
enum FinalsPlacing {
  groupStage(0),
  roundOf32(0.08),
  roundOf16(0.18),
  quarterFinal(0.32),
  fourth(0.48),
  third(0.56),
  runnerUp(0.72),
  champion(1)
  ;

  const FinalsPlacing(this.credit);

  /// This placing's share of the tournament (0 = group exit, 1 = champion).
  final double credit;
}

/// One played finals match, as [Elo.placingsFromRounds] reads it: the round
/// code, the two nations and the score that decided it.
typedef FinalsResult = ({
  String round,
  int home,
  int away,
  int homeScore,
  int awayScore,
});

/// A FIFA-style Elo ranking model.
///
/// Each nation carries a points total; a match nudges the two sides toward or
/// away from each other based on the result versus what their ratings predicted
/// (an upset moves more points than an expected win). Bigger games carry more
/// weight. The exchange is zero-sum, so the world's total points are conserved.
///
/// A tournament settles in two parts: the matches ([homeDelta] at
/// [finalsSettled]), and the finishing placings themselves
/// ([placementDeltas] at [placement]) — see that pair for why.
abstract final class Elo {
  /// Base points for a nation with no history (mid-table).
  static const int base = 1300;

  /// Importance weight (the K-factor) for a match, by how much is at stake.
  /// Final tournaments carry far more weight than qualifiers, which outweigh
  /// the Nations Cup, which outweighs friendlies.
  ///
  /// These are sized against the MID-TABLE spread — about 3.4 points per world
  /// place around a hundredth place, which is where nearly all qualifying is
  /// played. Weights that are too small round away entirely: at K=8 an expected
  /// qualifying win is `8 × 0.1 = 0.8` → 1 point → a quarter of a place, and an
  /// expected friendly win rounds to 0 and moves nothing at all. The table then
  /// looks frozen. These follow FIFA's own K-factors, so a win is worth a
  /// visible move and an upset is worth a real climb.
  //
  // A correction (2026-09-21): every retune below used to say these were sized
  // against "4 points per world place", which was [seedFromRanking]'s old flat
  // line and true of no table anybody had played on. The real ranking is
  // stretched at the top and dense in the middle. The floors argued below were
  // all argued about mid-table qualifying sides, where the spread is still
  // about 3.4 points a place, so the reasoning stands — but a place near the
  // top of the table costs tens of points, and no ordinary result buys one.
  // Trimmed from the FIFA-scale K-factors: a single result still moves a side,
  // but the table drifts more gently game to game (it read as swinging too far,
  // too often). Friendly stays at 4 — any lower and an expected friendly win
  // rounds to zero and the table looks frozen. The finals weight is only used
  // for continental cups now — the World Cup finals are not settled live at all
  // (see [finalsSettled]).
  //
  // Retuned again (2026-08-14): the complaint was that an ordinary match swung
  // the table while a World Cup barely showed. What was wrong is the RATIO, so
  // the tournament settlement went up and the cups came down — but the
  // QUALIFIER stayed at 16, because it has a floor of its own: at 12 a
  // favoured side beating the team below it in qualifying gains three points,
  // under the four that make a world place, and the table reads as stuck for
  // exactly the sides who play the most qualifiers. Friendly is at its own
  // documented floor and does not move either.
  static const double friendly = 4;
  static const double nationsCup = 8;
  static const double qualifier = 16;

  /// The continental-cup weight. Trimmed from 40, then to 24: a cup run is six
  /// or seven matches at this weight and every one of them lands live, so
  /// winning a continental championship was on its own worth a climb of dozens
  /// of world places — more than a World Cup, which is settled once at
  /// [finalsSettled]. It is still comfortably the heaviest thing that happens
  /// outside a World Cup, so lifting the trophy moves a nation a long way; it
  /// just no longer rewrites the top of the table by itself.
  ///
  /// Raised 24 → 28 (2026-09-21) with [finalsSettled], keeping the ratio
  /// between the two exactly where the 2026-08-14 retune put it (1:3): a
  /// continental run is worth a sixth more than it was, and still nothing like
  /// a World Championship.
  static const double finals = 28;

  /// The weight used to settle the World Cup finals into the ranking *after* the
  /// tournament, in one pass, rather than live round by round. It is heavier
  /// than every other match, so a deep run at the World Cup is the single
  /// biggest thing that can move a nation's ranking in a cycle.
  ///
  /// Raised from 48 to 72 alongside the trim below it: at 48 against a
  /// continental weight of 30, a cup run of seven live matches out-moved the
  /// World Cup it was supposed to be the warm-up for. At 72 against 24 the
  /// tournament is unmistakably the thing that decides where a nation stands.
  ///
  /// Raised again 72 → 84 (2026-09-21), see [placement].
  static const double finalsSettled = 84;

  /// The weight of a FINISHING PLACE, as opposed to the matches that produced
  /// it (2026-09-21).
  ///
  /// The complaint: "success at a tournament should boost the ranking more",
  /// and "I don't see the big jump after the World Championship anywhere".
  /// Raising [finalsSettled] alone does not fix that, because Elo pays for
  /// RESULTS AGAINST EXPECTATION, not for trophies: a champion who beats the
  /// sides it was supposed to beat and wins three shootouts on the way has, by
  /// Elo's reckoning, done nothing surprising, and barely moves. Measured on a
  /// played-in table, such a champion starting 25th finished 15th on the
  /// matches alone — a good tournament, not a coronation.
  ///
  /// So the placing is paid for separately. [placementDeltas] hands every
  /// entrant `placement × (its credit − the field's mean credit)`, which is
  /// zero-sum like every other exchange here: the champion is paid by the
  /// nations that went out early, and the world's total is conserved. Winning
  /// is worth +82 points — about ten world places from the twenties, and only
  /// two or three at the very top, where the table is stretched — on top of
  /// whatever the matches were worth. A group-stage exit costs 14, whoever you
  /// are.
  ///
  /// MEASURED, on tables across the range a played-in ranking occupies (the gap
  /// from 1st to 25th runs 321 to 436 points): that unconvincing champion from
  /// 25th finishes between 5th and 9th, a convincing one 2nd to 4th, and a
  /// favourite dumped out in the group slips and loses over a hundred points.
  /// Both ends matter. Half this weight leaves the scrappy champion around 9th
  /// to 11th and the original complaint stands; much more and it simply buys
  /// the top spot, which winning three shootouts has not proved. The tests hold
  /// it between those.
  ///
  /// Note what it is NOT sized against: the old flat seeding, on which a
  /// champion reached number one under the previous weights and any award at
  /// all looked enormous. See [seedFromRanking].
  ///
  /// This is the World Championship's weight. The continental cups are not
  /// settled this way — their matches land live at [finals], which went up with
  /// it — so the World Championship stays the one tournament that rewrites the
  /// top of the table.
  static const double placement = 96;

  /// Knockout round codes, ignoring any competition prefix ('CQF', 'NSF', …).
  static const List<String> _knockoutSuffixes = [
    'R32',
    'R16',
    'QF',
    'SF',
    '3RD',
    'FINAL',
  ];

  /// The round code of a friendly international.
  static const String friendlyRound = 'FRIENDLY';

  /// The importance weight for a fixture's [round].
  ///
  /// World Cup qualifiers carry no round code at all, so null means qualifier.
  /// The Nations Cup is checked before the knockout suffixes because its own
  /// rounds ('NSF', 'NFINAL') end with them but are not finals football.
  static double weightForRound(String? round) {
    if (round == null) return qualifier;
    if (round == friendlyRound) return friendly;
    if (round.startsWith('N')) return nationsCup;
    // Both finals group stages, the World Cup's and a continental cup's.
    if (round == 'GROUP' || round == 'CGROUP') return finals;
    if (_knockoutSuffixes.any(round.endsWith)) return finals;
    // Continental qualifying ('CQ') and anything else unaccounted for.
    return qualifier;
  }

  /// The bracket depth of a [round]: 0 for a group stage, rising to the final.
  /// Any competition prefix is ignored ('CQF' is a quarter-final), as in
  /// [weightForRound].
  static int _depthOf(String round) {
    for (var i = 0; i < _knockoutSuffixes.length; i++) {
      if (round.endsWith(_knockoutSuffixes[i])) return i + 1;
    }
    return 0;
  }

  /// Where each nation finished a finals tournament, read off the rounds it
  /// played in [results].
  ///
  /// A nation's placing is the deepest round it appears in: the last 16 for a
  /// side that played a group and an R16, the trophy for the one that won the
  /// final. The final and the third-place play-off are read by score, with a
  /// level score meaning the home side went through — the same convention the
  /// honours roll uses, so both tell the same story about the same tournament.
  /// A bracket with no third-place play-off (the continental cups) leaves both
  /// beaten semi-finalists sharing the bronze, exactly as the honours roll
  /// records them.
  static Map<int, FinalsPlacing> placingsFromRounds(
    Iterable<FinalsResult> results,
  ) {
    final deepest = <int, int>{};
    final wonIt = <int, bool>{};
    for (final r in results) {
      final depth = _depthOf(r.round);
      final homeWon = r.homeScore >= r.awayScore;
      for (final side in [(r.home, homeWon), (r.away, !homeWon)]) {
        final known = deepest[side.$1];
        if (known == null || depth > known) {
          deepest[side.$1] = depth;
          wonIt[side.$1] = side.$2;
        }
      }
    }
    return {
      for (final e in deepest.entries)
        e.key: switch (e.value) {
          6 => wonIt[e.key]! ? FinalsPlacing.champion : FinalsPlacing.runnerUp,
          5 => wonIt[e.key]! ? FinalsPlacing.third : FinalsPlacing.fourth,
          4 => FinalsPlacing.third,
          3 => FinalsPlacing.quarterFinal,
          2 => FinalsPlacing.roundOf16,
          1 => FinalsPlacing.roundOf32,
          _ => FinalsPlacing.groupStage,
        },
    };
  }

  /// The points every entrant takes from its FINISHING PLACE, on top of what
  /// its matches were worth (see [placement] for why the placing is paid for
  /// separately at all).
  ///
  /// Each nation is handed `weight × (its credit − the field's mean credit)`,
  /// so the exchange is zero-sum like every other one here: the champion is
  /// paid by the nations that went out early, and the world's total points are
  /// conserved. Rounding is settled the same way — the residue is handed back
  /// to the nations rounding treated best (or worst), so the returned deltas
  /// sum to exactly zero.
  ///
  /// [rotation] (the tournament's year, from the caller) decides WHICH of the
  /// tied nations take that residue. It must not be left at its default for a
  /// real tournament: a 48-team field's residue is the same nine points every
  /// edition, and the nations tied for it are the whole group stage, so any
  /// tie-break that reads nation id hands those nine points to the same nations
  /// — in practice the same confederation — forever. Measured before this was
  /// fixed: over a hundred confederation-shaped editions one confederation took
  /// 59% of the residue on 33% of the field, in one direction, for no
  /// footballing reason. The year mixes into the ordering instead, so the
  /// residue lands somewhere different every edition.
  ///
  /// Because the credits are measured against the field's own mean, this works
  /// for any bracket: a 48-team World Championship, a 16-team continental cup,
  /// or a field where everybody went out together (in which case nobody moves).
  static Map<int, int> placementDeltas(
    Map<int, FinalsPlacing> placingByNation, {
    double weight = placement,
    int rotation = 0,
  }) {
    if (placingByNation.isEmpty) return const {};
    final ids = placingByNation.keys.toList()..sort();
    final mean =
        ids.fold<double>(0, (a, id) => a + placingByNation[id]!.credit) /
        ids.length;
    final raw = {
      for (final id in ids) id: weight * (placingByNation[id]!.credit - mean),
    };
    final deltas = {for (final id in ids) id: raw[id]!.round()};
    var residue = deltas.values.fold<int>(0, (a, b) => a + b);
    if (residue != 0) {
      // Whoever rounding favoured most gives the surplus back first (and, when
      // rounding left points on the table, whoever it shortchanged takes them).
      final step = residue > 0 ? -1 : 1;
      final order = ids.toList()
        ..sort((a, b) {
          final gainA = deltas[a]! - raw[a]!;
          final gainB = deltas[b]! - raw[b]!;
          final byGain = residue > 0
              ? gainB.compareTo(gainA)
              : gainA.compareTo(gainB);
          if (byGain != 0) return byGain;
          return _residueKey(a, rotation).compareTo(_residueKey(b, rotation));
        });
      for (var i = 0; residue != 0; i++) {
        final id = order[i % order.length];
        deltas[id] = deltas[id]! + step;
        residue += step;
      }
    }
    return deltas;
  }

  /// The ordering key that decides who takes a rounding residue point.
  ///
  /// A cheap integer mix of the nation id and the tournament year: stable for a
  /// given pair (so a settlement is reproducible), but with no order in common
  /// with the id, so neither the low ids nor any block of them is favoured, and
  /// a different edition favours a different nine nations. Ties are broken on
  /// this and never on the id itself — see [placementDeltas].
  static int _residueKey(int id, int rotation) {
    var h = (id * 0x9E3779B1) ^ (rotation * 0x85EBCA77 + 0x165667B1);
    h &= 0x3FFFFFFF;
    h ^= h >> 15;
    h = (h * 0x2545F491) & 0x3FFFFFFF;
    return h ^ (h >> 13);
  }

  /// The shape a played-in world ranking actually settles into: (world place,
  /// points), measured off the engine's own equilibrium after one to four full
  /// cycles of simulated football with the whole world of nations.
  ///
  /// The table is nothing like a straight line. The top is stretched — the gap
  /// between first and fifth is bigger than the gap between fortieth and
  /// hundredth — because the best sides keep beating everyone and the points
  /// pile up at the top.
  static const List<(int, int)> _seedShape = [
    (1, 2130),
    (5, 1930),
    (25, 1760),
    (40, 1700),
    (100, 1495),
  ];

  /// Starting points for a nation seeded from its static seed [ranking]
  /// position (1 = strongest). Keeps early tables looking sensible before any
  /// results have moved anyone.
  ///
  /// Widened (2026-09-21) from a flat `1900 - 4 × (place - 1)` to the measured
  /// [_seedShape]. The flat line was about four times too compressed at the top
  /// — 96 points from 1st to 25th, where a table that has seen one cycle of
  /// football carries 321 to 436 — so in a NEW save the first World
  /// Championship sent its champion straight to number one however it had won,
  /// and no tuning of [placement] could have fixed that: on the old flat table
  /// the match half of a championship run was on its own worth the entire
  /// top 25.
  /// It also made this file's own reasoning a fiction: every retune above says
  /// it is "sized against a spread of 4 points per world place", which was only
  /// ever true of a table nobody had played on.
  ///
  /// Mid-table — where nearly all qualifying is played, and where all those
  /// floors were argued — the spread is still about 3.4 points per place, so
  /// they hold. The top of the table is now properly sticky: at fifth a place
  /// costs some 40 points, so a nation arrives there by winning things, not by
  /// grinding out qualifiers.
  ///
  /// Saves in progress store their own points and are untouched; this changes
  /// where a NEW save starts.
  static int seedFromRanking(int ranking) {
    final place = ranking < 1 ? 1 : ranking;
    for (var i = 1; i < _seedShape.length; i++) {
      final (lowPlace, lowPoints) = _seedShape[i - 1];
      final (highPlace, highPoints) = _seedShape[i];
      if (place <= highPlace) {
        final t = (place - lowPlace) / (highPlace - lowPlace);
        return (lowPoints + (highPoints - lowPoints) * t).round().clamp(
          1000,
          2130,
        );
      }
    }
    // Past the last anchor the tail keeps the slope it arrived with.
    final (lowPlace, lowPoints) = _seedShape[_seedShape.length - 2];
    final (lastPlace, lastPoints) = _seedShape.last;
    final slope = (lastPoints - lowPoints) / (lastPlace - lowPlace);
    return (lastPoints + slope * (place - lastPlace)).round().clamp(1000, 2130);
  }

  /// World positions (1 = top) for every nation in [pointsById], ordered by
  /// points. Ties break by [seedRankById] (the static seed order) when given,
  /// else by nation id, so the ordering is always deterministic.
  static Map<int, int> positions(
    Map<int, int> pointsById, {
    Map<int, int>? seedRankById,
  }) {
    final ids = pointsById.keys.toList()
      ..sort((a, b) {
        final byPoints = (pointsById[b] ?? base).compareTo(
          pointsById[a] ?? base,
        );
        if (byPoints != 0) return byPoints;
        return (seedRankById?[a] ?? a).compareTo(seedRankById?[b] ?? b);
      });
    return {for (var i = 0; i < ids.length; i++) ids[i]: i + 1};
  }

  /// The change to the home side's points after a match; the away side moves by
  /// the negative of the same amount. [homeScore]/[awayScore] decide the result
  /// and [weight] is one of the importance constants above.
  static int homeDelta({
    required int homePoints,
    required int awayPoints,
    required int homeScore,
    required int awayScore,
    required double weight,
  }) {
    final expected = 1 / (1 + pow(10, (awayPoints - homePoints) / 400));
    final actual = homeScore > awayScore
        ? 1.0
        : homeScore == awayScore
        ? 0.5
        : 0.0;
    return (weight * (actual - expected)).round();
  }
}
