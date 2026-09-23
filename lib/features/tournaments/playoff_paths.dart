import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/finals.dart';

/// Where one nation sits in the six-team intercontinental play-off bracket.
///
/// The two best-ranked entrants have byes into their path final; the other four
/// contest a semi first. Which slot a nation occupies follows only from its
/// seeding, so the hub (which creates the fixtures) and the bracket screen
/// (which shows them) derive the same answer from the same pool — the
/// invariant that keeps the bracket, the played result and the finals field
/// telling one story.
typedef PlayoffPath = ({int? semiSlot, int finalSlot});

/// The path [nationId] takes through the bracket, or null when it is not in
/// [pool] or the field is not the standard six.
PlayoffPath? playoffPathOf({
  required List<int> pool,
  required Map<int, int> rankingById,
  required int nationId,
}) {
  if (pool.length != 6) return null;
  int rank(int id) => rankingById[id] ?? 9999;
  final seeds = [...pool]..sort((a, b) => rank(a).compareTo(rank(b)));
  final idx = seeds.indexOf(nationId);
  if (idx < 0) return null;
  // Semis are (seed 3 v seed 6) and (seed 4 v seed 5); each path final pits a
  // bye seed against the winner of the semi in the same half.
  if (idx < 2) return (semiSlot: null, finalSlot: idx);
  final slot = (idx == 2 || idx == 5) ? 0 : 1;
  return (semiSlot: slot, finalSlot: slot);
}

/// The round codes the manager's own play-off ties are stored under. Both end
/// in a knockout suffix so a level tie goes to penalties like any other.
const String playoffSemiFixtureRound = 'POSF';
const String playoffFinalFixtureRound = 'POFINAL';

/// The manager's played ties, keyed by [WorldCupFinals.tieKey] and ready to
/// hand to [WorldCupFinals.playoffWinners] / [WorldCupFinals.playoffBracket].
///
/// Only the manager's own ties are ever fixtures; the rest of the bracket stays
/// deterministic, which is why an empty result here reproduces the old
/// behaviour exactly.
({Map<String, int> results, Map<String, (int, int)> scores}) playoffPlayed({
  required PlayoffPath path,
  required List<Fixture> semis,
  required List<Fixture> finals,
}) {
  final results = <String, int>{};
  final scores = <String, (int, int)>{};

  void record(String key, Fixture f) {
    final homeWon = f.homeScore! >= f.awayScore!;
    results[key] = homeWon ? f.homeNationId : f.awayNationId;
    // Stored winner-first, so the bracket can show the real scoreline whichever
    // way round the fixture was drawn.
    scores[key] = homeWon
        ? (f.homeScore!, f.awayScore!)
        : (f.awayScore!, f.homeScore!);
  }

  final semiSlot = path.semiSlot;
  if (semiSlot != null) {
    final f = semis.where((f) => f.hasResult).firstOrNull;
    if (f != null) {
      record(
        WorldCupFinals.tieKey(
          round: WorldCupFinals.playoffSemiRound,
          slot: semiSlot,
        ),
        f,
      );
    }
  }
  final f = finals.where((f) => f.hasResult).firstOrNull;
  if (f != null) {
    record(
      WorldCupFinals.tieKey(
        round: WorldCupFinals.playoffFinalRound,
        slot: path.finalSlot,
      ),
      f,
    );
  }
  return (results: results, scores: scores);
}
