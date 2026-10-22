import 'package:fnm/domain/repositories/competition_repository.dart';

/// Who holds a competition's trophy as an edition is shown.
///
/// The newest champion, the edition on screen included once its final is
/// played: that edition is recorded to the roll of honour the night it is
/// decided, and its winner holds the trophy from then on. It used to name the
/// holder going INTO the edition instead, so a cup won in July still showed
/// the previous winner as holders until the cycle turned in September.
abstract final class TournamentHolders {
  /// The newest [honours] entry for [competition] no later than
  /// [editionYear] (the year of the edition on screen): its own champion once
  /// decided, the previous one before. Null before this competition has ever
  /// been won.
  ///
  /// [honours] must be newest-first, as `CompetitionRepository.honours`
  /// returns them.
  static ({int nationId, int year})? forEdition({
    required List<Honour> honours,
    required String competition,
    required int editionYear,
  }) {
    for (final h in honours) {
      if (h.competition == competition && h.year <= editionYear) {
        return (nationId: h.championId, year: h.year);
      }
    }
    return null;
  }
}
