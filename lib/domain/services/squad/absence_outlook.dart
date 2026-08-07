import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player_absence.dart';

/// How long a player is actually out for, in the terms a manager thinks in.
///
/// [PlayerAbsence] counts in MATCHES, which is what the engine needs but not
/// what anyone asks: "out for two games" says nothing about whether he is back
/// for the qualifier in March. Read against the nation's fixture list, the same
/// two games become a date, a number of weeks, and the tie he returns for.
typedef AbsenceOutlook = ({
  /// Injured, as opposed to suspended (an injury is shown differently and can
  /// be nursed; a ban simply has to be served).
  bool injured,

  /// Matches still to sit out.
  int matches,

  /// Whole weeks until the return match, 0 when no fixture is scheduled that
  /// far ahead.
  int weeks,

  /// The date and details of the first match back, when one is scheduled.
  DateTime? returnDate,
  int? returnOpponentId,
  String? returnRound,
});

abstract final class AbsenceOutlooks {
  /// The outlook for [absence] against [upcoming] (the nation's unplayed
  /// fixtures, any order), as of [from]. Null when the player is available.
  ///
  /// A ban and an injury run CONCURRENTLY — [Discipline] serves a match off
  /// both every game — so the player is out for the longer of the two, not
  /// their sum.
  static AbsenceOutlook? forAbsence(
    PlayerAbsence? absence, {
    required List<Fixture> upcoming,
    required DateTime from,
    required int nationId,
  }) {
    if (absence == null || absence.isAvailable) return null;
    final misses = absence.injuryMatches > absence.banMatches
        ? absence.injuryMatches
        : absence.banMatches;
    final fixtures = [...upcoming]..sort((a, b) => a.date.compareTo(b.date));
    final back = misses < fixtures.length ? fixtures[misses] : null;
    final weeks = back == null
        ? 0
        : ((back.date.difference(from).inDays) / 7).ceil().clamp(0, 520);
    return (
      injured: absence.injuryMatches > 0,
      matches: misses,
      weeks: weeks,
      returnDate: back?.date,
      returnOpponentId: back == null ? null : opponentOf(back, nationId),
      returnRound: back?.round,
    );
  }

  /// The opponent of [f] from [nationId]'s point of view.
  static int opponentOf(Fixture f, int nationId) =>
      f.homeNationId == nationId ? f.awayNationId : f.homeNationId;
}
