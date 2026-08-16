import 'package:fnm/domain/entities/fixture.dart';

/// One played match seen from one nation's side of it.
typedef NationResult = ({
  int opponentId,
  int scored,
  int conceded,
  DateTime date,
  String? round,
});

/// A nation's record against one opponent.
typedef OpponentRecord = ({
  int opponentId,
  int played,
  int wins,
  int draws,
  int losses,
  int goalsFor,
  int goalsAgainst,
});

/// A fixture list from [nationId]'s point of view, oldest first.
///
/// The "was I home or away, so which score is mine" decomposition was written
/// out by hand in five different providers, and each one then decided for
/// itself whether friendlies counted. They did not all decide the same way:
/// the record book's fiercest-rival card dropped friendlies while the
/// head-to-head screen kept them, so the same pairing read P4 on one screen and
/// P5 on the next.
///
/// **Every played match counts.** A result is a result; a screen that wants
/// only competitive ones filters this list itself, visibly, rather than each
/// one quietly picking its own rule.
List<NationResult> nationResults(Iterable<Fixture> fixtures, int nationId) {
  final out = <NationResult>[];
  for (final f in fixtures) {
    if (!f.hasResult) continue;
    final home = f.homeNationId == nationId;
    final away = f.awayNationId == nationId;
    if (!home && !away) continue;
    final opponentId = home ? f.awayNationId : f.homeNationId;
    // A nation cannot be its own opponent; such a row is data corruption
    // rather than a match, and counting it would double its goals.
    if (opponentId == nationId) continue;
    out.add((
      opponentId: opponentId,
      scored: home ? f.homeScore! : f.awayScore!,
      conceded: home ? f.awayScore! : f.homeScore!,
      date: f.date,
      round: f.round,
    ));
  }
  out.sort((a, b) => a.date.compareTo(b.date));
  return out;
}

/// The nation's record against every opponent it has faced, keyed by opponent.
Map<int, OpponentRecord> opponentLedger(Iterable<NationResult> results) {
  final out = <int, OpponentRecord>{};
  for (final r in results) {
    final was =
        out[r.opponentId] ??
        (
          opponentId: r.opponentId,
          played: 0,
          wins: 0,
          draws: 0,
          losses: 0,
          goalsFor: 0,
          goalsAgainst: 0,
        );
    out[r.opponentId] = (
      opponentId: r.opponentId,
      played: was.played + 1,
      wins: was.wins + (r.scored > r.conceded ? 1 : 0),
      draws: was.draws + (r.scored == r.conceded ? 1 : 0),
      losses: was.losses + (r.scored < r.conceded ? 1 : 0),
      goalsFor: was.goalsFor + r.scored,
      goalsAgainst: was.goalsAgainst + r.conceded,
    );
  }
  return out;
}

/// The best win in [results]: the biggest margin, and the most goals scored
/// where two wins share a margin. Null if the nation has never won.
NationResult? biggestWinOf(Iterable<NationResult> results) {
  NationResult? best;
  for (final r in results) {
    if (r.scored <= r.conceded) continue;
    final margin = r.scored - r.conceded;
    if (best == null) {
      best = r;
      continue;
    }
    final bestMargin = best.scored - best.conceded;
    if (margin > bestMargin ||
        (margin == bestMargin && r.scored > best.scored)) {
      best = r;
    }
  }
  return best;
}

/// The longest run without defeat in [results], which must be in date order.
int longestUnbeatenOf(Iterable<NationResult> results) {
  var longest = 0;
  var run = 0;
  for (final r in results) {
    if (r.scored >= r.conceded) {
      run++;
      if (run > longest) longest = run;
    } else {
      run = 0;
    }
  }
  return longest;
}
