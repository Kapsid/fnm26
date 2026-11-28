import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

/// The app boots in Russian: the hub, the squad's tactics and the home menu
/// open on a real save with the Russian strings, and nothing throws.
void main() {
  const ru = Locale('ru');
  final l = lookupAppLocalizations(ru);

  testWidgets('the hub opens in Russian', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      locale: ru,
    );
    expect(tester.takeException(), isNull);
    expect(find.text(l.navHub), findsWidgets);
    expect(find.text(l.navSquad), findsWidgets);
    expect(l.navHub, 'Центр');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('tactics and home open in Russian', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      locale: ru,
    );
    expect(tester.takeException(), isNull);
    await pumpRoute(tester, save, Routes.home, locale: ru);
    expect(tester.takeException(), isNull);
    expect(find.text(l.homeNewGame), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
