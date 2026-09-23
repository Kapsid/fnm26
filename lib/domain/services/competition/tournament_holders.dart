import 'package:fnm/domain/repositories/competition_repository.dart';

/// Who currently holds a competition's trophy, going into an edition still on
/// screen.
///
/// A tournament's own just-decided edition is recorded to the roll of honour
/// the moment its final is played — often before the manager has even opened
/// the screen showing it. So the newest entry in `honours` is not always the
/// PREVIOUS holder: once an edition is done, it is briefly the newest entry
/// and also the one on screen. [forEdition] is given the on-screen edition's
/// year so it can tell the two apart.
abstract final class TournamentHolders {
  /// The newest [honours] entry for [competition] whose year is strictly
  /// before [beforeYear] (the year of the edition on screen) — null before
  /// this competition has ever been won.
  ///
  /// [honours] must be newest-first, as `CompetitionRepository.honours`
  /// returns them.
  static ({int nationId, int year})? forEdition({
    required List<Honour> honours,
    required String competition,
    required int beforeYear,
  }) {
    for (final h in honours) {
      if (h.competition == competition && h.year < beforeYear) {
        return (nationId: h.championId, year: h.year);
      }
    }
    return null;
  }
}
