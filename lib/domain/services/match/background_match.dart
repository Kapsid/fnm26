import 'dart:math';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/performance_mark.dart';
import 'package:fnm/domain/services/player/player_traits.dart';

/// One player's line from a match nobody watched.
typedef BackgroundLine = ({
  int playerId,
  int nationId,
  PositionCategory category,
  double rating,
  int goals,
  int assists,
  int yellows,
  int reds,
  bool cleanSheet,
  bool motm,
});

/// Everything about a background match beyond its scoreline.
typedef BackgroundDetail = ({
  int homeShots,
  int awayShots,
  int homePossession,
  double homeXg,
  double awayXg,
  List<BackgroundLine> lines,

  /// Cards and knocks as engine events, so [Discipline] applies exactly the
  /// same suspension and injury rules to the rest of the world as it does to
  /// the manager's own squad.
  List<MatchEvent> events,
});

/// Gives a match the tactical engine never played everything except its
/// scoreline: a box score, assists, cards, knocks and a mark for every player.
///
/// The world used to be results-only. That had three consequences that all
/// read as the game being shallower than it is: rival nations never lost a
/// player to a suspension or an injury (so squad depth was the manager's
/// problem alone and nobody else's), no performance data existed outside the
/// manager's own fixtures (so a Team of the Tournament could only be picked on
/// goals, and a defender could never make it), and a nation's page could show
/// what it won but never how it played.
///
/// This is derived, not simulated: it takes the scoreline the match simulator
/// already produced and dresses it. That is deliberate — running the full
/// tactical engine for every fixture on Earth would be far too slow, and
/// re-deriving the score would invalidate every result already in the save.
///
/// Determinism: the caller must pass an RNG stream FORKED from the one that
/// produced the scoreline and the scorers (see `SeededRng.forFixture` with a
/// distinct salt). Drawing from the scoring stream would shift every result in
/// the world.
abstract final class BackgroundMatch {
  /// How much of a lead in strength turns into possession, per rating point.
  static const double _possessionPerPoint = 0.9;

  /// Roughly how much expected goal a shot is worth — a shot count is derived
  /// from xG rather than rolled on its own so the two always agree.
  static const double _xgPerShot = 0.11;

  /// The chance a goal was made by somebody rather than taken solo.
  static const double _assistChance = 0.72;

  /// Per-player chance of a booking in a competitive match. A friendly is a
  /// fraction of it (see [_friendlyCardFactor]).
  static const double _yellowChance = 0.085;

  /// Per-player chance of a sending-off. Rare: about one red every six or
  /// seven matches across both sides.
  static const double _redChance = 0.0035;

  /// What share of those dismissals are a second booking rather than violent
  /// conduct. The world used to send everyone off with a straight red, so the
  /// two-card dismissal the live engine models never showed up in the feed.
  static const double _secondYellowShare = 0.7;

  /// Per-player chance of picking up a knock.
  static const double _injuryChance = 0.011;

  /// Cards are far less common in a friendly, though knocks are not.
  static const double _friendlyCardFactor = 0.35;

  /// Builds the detail for a match that finished [homeScore]–[awayScore].
  ///
  /// [goalsByPlayer] is the scorer attribution the caller has already made, so
  /// the marks agree with the goals actually recorded. [homeStrength] and
  /// [awayStrength] are the same figures the scoreline was drawn from.
  /// A substitute's share of the cards and knocks a starter risks — they are on
  /// the pitch for roughly the last half-hour.
  static const double _benchShare = 0.33;

  static BackgroundDetail detail({
    required List<Player> homeXi,
    required List<Player> awayXi,
    List<Player> homeSubs = const [],
    List<Player> awaySubs = const [],
    required int homeNationId,
    required int awayNationId,
    required int homeScore,
    required int awayScore,
    required int homeStrength,
    required int awayStrength,
    required Map<int, int> goalsByPlayer,
    required SeededRng rng,
    required bool competitive,
    int saveSeed = 0,
  }) {
    final diff = homeStrength - awayStrength;
    final possession = (50 + _possessionPerPoint * diff + rng.nextInt(9) - 4)
        .round()
        .clamp(28, 72);

    // xG sits between what the sides' quality suggested and what they actually
    // scored, so a 4-0 never reads as 0.6 xG and a goalless draw never as 3.0.
    final homeXg = _xg(homeStrength - awayStrength, homeScore, rng);
    final awayXg = _xg(awayStrength - homeStrength, awayScore, rng);

    final events = <MatchEvent>[];
    final assists = <int, int>{};

    _assign(
      xi: homeXi,
      subs: homeSubs,
      nationId: homeNationId,
      goalsByPlayer: goalsByPlayer,
      assists: assists,
      events: events,
      rng: rng,
      competitive: competitive,
      saveSeed: saveSeed,
    );
    _assign(
      xi: awayXi,
      subs: awaySubs,
      nationId: awayNationId,
      goalsByPlayer: goalsByPlayer,
      assists: assists,
      events: events,
      rng: rng,
      competitive: competitive,
      saveSeed: saveSeed,
    );

    final booked = <int>{
      for (final e in events)
        if (e.type == MatchEventType.yellowCard) e.playerId,
    };
    final sentOff = <int>{
      for (final e in events)
        if (e.type == MatchEventType.redCard) e.playerId,
    };

    final lines = <BackgroundLine>[
      for (final (xi, nationId, mine, theirs) in [
        ([...homeXi, ...homeSubs], homeNationId, homeScore, awayScore),
        ([...awayXi, ...awaySubs], awayNationId, awayScore, homeScore),
      ])
        for (final p in xi)
          (
            playerId: p.id,
            nationId: nationId,
            category: p.category,
            rating: PerformanceMark.forPlayer(
              category: p.category,
              goals: goalsByPlayer[p.id] ?? 0,
              assists: assists[p.id] ?? 0,
              booked: booked.contains(p.id),
              sentOff: sentOff.contains(p.id),
              teamScore: mine,
              oppScore: theirs,
            ),
            goals: goalsByPlayer[p.id] ?? 0,
            assists: assists[p.id] ?? 0,
            yellows: booked.contains(p.id) ? 1 : 0,
            reds: sentOff.contains(p.id) ? 1 : 0,
            cleanSheet: theirs == 0,
            motm: false,
          ),
    ];

    return (
      homeShots: _shots(homeXg, rng),
      awayShots: _shots(awayXg, rng),
      homePossession: possession,
      homeXg: homeXg,
      awayXg: awayXg,
      lines: _withMotm(lines),
      events: events,
    );
  }

  /// A side's expected goals: the quality-implied figure blended with what
  /// they actually put away, plus a little noise.
  static double _xg(int edge, int scored, SeededRng rng) {
    final implied = (1.25 * exp(0.026 * edge)).clamp(0.15, 4.5);
    final blended = implied * 0.55 + scored * 0.45;
    final noise = 0.85 + rng.nextInt(31) / 100; // 0.85–1.15
    return ((blended * noise).clamp(0.05, 6.0) * 100).roundToDouble() / 100;
  }

  static int _shots(double xg, SeededRng rng) =>
      (xg / _xgPerShot + rng.nextInt(7) - 3).round().clamp(1, 34);

  /// Draws one side's assists, cards and knocks onto its XI and its [subs].
  ///
  /// Substitutes take a full part — they can set a goal up, be booked, be sent
  /// off or pick up a knock — at [_benchShare] of a starter's exposure, since
  /// they are only on for the closing stretch.
  static void _assign({
    required List<Player> xi,
    required int nationId,
    required Map<int, int> goalsByPlayer,
    required Map<int, int> assists,
    required List<MatchEvent> events,
    required SeededRng rng,
    required bool competitive,
    required int saveSeed,
    List<Player> subs = const [],
  }) {
    if (xi.isEmpty) return;
    final played = [...xi, ...subs];
    final benchIds = {for (final p in subs) p.id};
    double minutes(Player p) => benchIds.contains(p.id) ? _benchShare : 1.0;

    // Assists: creators are weighted by how much of the game they see on the
    // ball, so a midfield runs the goals rather than a centre-back nodding
    // every one in.
    final creators = <Player>[
      for (final p in played)
        if (p.category != PositionCategory.goalkeeper) p,
    ];
    for (final p in played) {
      final goals = goalsByPlayer[p.id] ?? 0;
      for (var g = 0; g < goals; g++) {
        if (!rng.chance(_assistChance)) continue;
        final candidates = [
          for (final c in creators)
            if (c.id != p.id) c,
        ];
        if (candidates.isEmpty) continue;
        final pick = _weighted(
          candidates,
          rng,
          (c) => _creatorWeight(c) * minutes(c),
        );
        assists.update(pick.id, (v) => v + 1, ifAbsent: () => 1);
      }
    }

    final cardFactor = competitive ? 1.0 : _friendlyCardFactor;
    for (final p in played) {
      final traits = PlayerTraits.of(p, saveSeed: saveSeed);
      // A hothead collects cards; a keeper barely ever does.
      final discipline =
          (traits.contains(PlayerTrait.hothead) ? 2.2 : 1.0) *
          _cardWeight(p.category) *
          minutes(p);
      if (rng.chance(_redChance * discipline * cardFactor)) {
        final secondYellow = rng.chance(_secondYellowShare);
        final minute = 60 + rng.nextInt(30);
        if (secondYellow) {
          // The booking he was already on, so the feed reads as a match does:
          // a caution, then the second one that sends him off.
          events.add(
            _event(
              MatchEventType.yellowCard,
              p,
              nationId,
              10 + rng.nextInt(minute - 10),
            ),
          );
        }
        events.add(
          _event(
            MatchEventType.redCard,
            p,
            nationId,
            minute,
            secondYellow: secondYellow,
          ),
        );
        continue; // a dismissed player is not also booked again
      }
      if (rng.chance(_yellowChance * discipline * cardFactor)) {
        events.add(
          _event(MatchEventType.yellowCard, p, nationId, 10 + rng.nextInt(80)),
        );
      }
    }

    for (final p in played) {
      final traits = PlayerTraits.of(p, saveSeed: saveSeed);
      // An iron man shrugs off what puts others out; nobody is immune.
      final frailty = traits.contains(PlayerTrait.ironMan) ? 0.45 : 1.0;
      if (rng.chance(_injuryChance * frailty * minutes(p))) {
        events.add(
          _event(MatchEventType.injury, p, nationId, 15 + rng.nextInt(70)),
        );
      }
    }
  }

  static MatchEvent _event(
    MatchEventType type,
    Player p,
    int nationId,
    int minute, {
    bool secondYellow = false,
  }) => MatchEvent(
    minute: minute,
    type: type,
    teamNationId: nationId,
    playerId: p.id,
    playerName: p.name,
    secondYellow: secondYellow,
  );

  /// How likely a player is to be the one who made the goal.
  static double _creatorWeight(Player p) => switch (p.category) {
    PositionCategory.midfielder => 3.0,
    PositionCategory.forward => 2.2,
    PositionCategory.defender => 1.0,
    PositionCategory.goalkeeper => 0.05,
  };

  /// How likely a player is to be carded, by where they play.
  static double _cardWeight(PositionCategory c) => switch (c) {
    PositionCategory.defender => 1.35,
    PositionCategory.midfielder => 1.25,
    PositionCategory.forward => 0.8,
    PositionCategory.goalkeeper => 0.15,
  };

  static Player _weighted(
    List<Player> from,
    SeededRng rng,
    double Function(Player) weight,
  ) {
    var total = 0.0;
    for (final p in from) {
      total += weight(p);
    }
    if (total <= 0) return from[rng.nextInt(from.length)];
    var roll = rng.nextDouble() * total;
    for (final p in from) {
      roll -= weight(p);
      if (roll <= 0) return p;
    }
    return from.last;
  }

  /// Flags the best mark on the pitch as man of the match. Ties break toward
  /// the line that appears first, which is stable for a given fixture.
  static List<BackgroundLine> _withMotm(List<BackgroundLine> lines) {
    if (lines.isEmpty) return lines;
    var bestAt = 0;
    for (var i = 1; i < lines.length; i++) {
      if (lines[i].rating > lines[bestAt].rating) bestAt = i;
    }
    return [
      for (var i = 0; i < lines.length; i++)
        if (i == bestAt)
          (
            playerId: lines[i].playerId,
            nationId: lines[i].nationId,
            category: lines[i].category,
            rating: lines[i].rating,
            goals: lines[i].goals,
            assists: lines[i].assists,
            yellows: lines[i].yellows,
            reds: lines[i].reds,
            cleanSheet: lines[i].cleanSheet,
            motm: true,
          )
        else
          lines[i],
    ];
  }
}
