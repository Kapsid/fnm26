import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

/// PlayerView is the player page's body, on its own: what both the route and
/// a tablet detail pane draw. Tested once here, at the pane's width.
void main() {
  testWidgets('a player card fits a 320-wide pane', (tester) async {
    final save = await seedSave(tester);
    late int playerId;
    late String name;
    await tester.runAsync(() async {
      final pool = await save.container
          .read(playerRepositoryProvider)
          .byNation(
            save.nationId,
            agingYears: CareerService.agingYears(save.career),
            saveSeed: save.career.rngSeed,
            careerId: save.career.id,
          );
      playerId = pool.first.id;
      name = pool.first.name;
    });
    tester.view.physicalSize = kTabletSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 320,
                height: 760,
                child: PlayerView(careerId: save.careerId, playerId: playerId),
              ),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text(name), findsOneWidget);
    // The ability ring upper-cases its label.
    expect(find.text(enL.playerAttrPhysical.toUpperCase()), findsOneWidget);
    expect(find.byType(AppBar), findsNothing, reason: 'the view has no chrome');
  });
}
