import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The "free for one cycle" note sells the upgrade; a manager who has
/// already paid must not be told what he gets for nothing.
void main() {
  final note = AppLocalizationsEn().careerFreeCycleNote;

  for (final (label, size, formFactor) in [
    ('phone', kPhoneSize, FormFactor.phone),
    ('tablet', kTabletSize, FormFactor.tablet),
  ]) {
    for (final premium in [false, true]) {
      testWidgets('$label, premium $premium: the free-cycle note '
          '${premium ? 'is hidden' : 'shows'}', (tester) async {
        final save = await seedSave(tester, formFactor: formFactor);
        save.container.read(premiumUnlockedProvider.notifier).state = premium;
        await pumpRoute(
          tester,
          save,
          '${Routes.newGame}?nationId=${rivalNation.id}',
          size: size,
        );
        expect(find.text(note), premium ? findsNothing : findsOneWidget);
      });
    }
  }
}
