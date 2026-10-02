import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// The rungs of a Nations Cup brief that name the cup ("win it", "reach the
/// final", and the "winners" finish) name the cup the objective is about. An
/// African champion used to be filed as "Nations Cup winners", Europe's line.
void main() {
  final l = AppLocalizationsEn();
  const tier = TournamentTier.nationsCup;

  test('each cup is named on its own top rungs', () {
    final expected = {
      NationsCups.europe: (
        'Win the Nations Cup',
        'Reach the Nations Cup final',
        'Nations Cup winners',
      ),
      NationsCups.northAmerica: (
        'Win the North America Nations Cup',
        'Reach the North America Nations Cup final',
        'North America Nations Cup winners',
      ),
      NationsCups.africa: (
        // Shown as the plain cup: the African-named form is the real AFCON.
        'Win the Nations Cup',
        'Reach the Nations Cup final',
        'Nations Cup winners',
      ),
    };
    for (final e in expected.entries) {
      expect(objectiveDemandText(l, tier, 7, competition: e.key), e.value.$1);
      expect(objectiveDemandText(l, tier, 6, competition: e.key), e.value.$2);
      expect(objectiveFinishText(l, tier, 7, competition: e.key), e.value.$3);
    }
  });

  test('the lower rungs keep their own format', () {
    expect(
      objectiveDemandText(l, tier, 5, competition: NationsCups.africa),
      'Reach the Finals Eight',
    );
    expect(
      objectiveDemandText(l, tier, 5, competition: NationsCups.northAmerica),
      'Reach the Finals Four',
    );
  });
}
