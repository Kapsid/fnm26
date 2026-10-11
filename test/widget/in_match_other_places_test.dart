import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/fixtures.dart';

/// The men who do not naturally fill the place, and what they would play it at.
///
/// The shortlist keeps fitRank 1 and 2, so anybody out of line was not merely
/// ranked last, he was absent: a winger offered as an emergency striker was
/// nowhere in the sheet. The rating he would actually play the place at is the
/// thing being weighed, so it travels with him.
void main() {
  const formation = Formation.f442;

  Future<AppLocalizations> openSheet(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (inner) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showInMatchTactics(
                    inner,
                    minute: 60,
                    formation: formation,
                    lineup: [for (var i = 1; i <= 11; i++) i],
                    instructions: const TacticalInstructions(),
                    pool: [
                      for (var i = 0; i < 11; i++)
                        player(
                          id: i + 1,
                          nationId: 1,
                          name: 'Starter${i + 1}',
                          position: formation.positions[i],
                        ),
                      // A bench of keepers and defenders only, so a striker's
                      // place has nobody who naturally fills it.
                      player(
                        id: 12,
                        nationId: 1,
                        name: 'BenchKeeper',
                        position: PlayerPosition.gk,
                      ),
                      for (var i = 13; i <= 15; i++)
                        player(
                          id: i,
                          nationId: 1,
                          name: 'BenchBack$i',
                          position: PlayerPosition.cb,
                        ),
                    ],
                    startingIds: {for (var i = 1; i <= 11; i++) i},
                    maxSubs: 5,
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return AppLocalizations.of(tester.element(find.byType(Scaffold).last));
  }

  testWidgets('a centre-back is out of line for a striker, by fitRank', (
    tester,
  ) async {
    // The rule the tab is built on, stated where it can be read.
    expect(
      PositionFit.fitRank(
        player(id: 1, nationId: 1, name: 'CB', position: PlayerPosition.cb),
        PlayerPosition.st,
      ),
      0,
      reason: 'a centre-back does not naturally play up front',
    );
  });

  testWidgets('the other-places tab explains itself before anybody is picked', (
    tester,
  ) async {
    final l = await openSheet(tester);

    await tester.tap(find.text(l.tacticsTabOtherPositions));
    await tester.pumpAndSettle();

    // Without a man chosen there is no place to be out of, so the tab says so
    // rather than sitting blank.
    expect(find.text(l.tacticsPickSomebodyFirst), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('choosing a striker puts the defenders in other places', (
    tester,
  ) async {
    final l = await openSheet(tester);

    // Starter11 fills the last slot of a 4-4-2, which is a forward's place.
    await tester.tap(find.text(l.tacticsTabOnPitch));
    await tester.pumpAndSettle();
    final man = find.text('Starter11');
    await tester.ensureVisible(man);
    await tester.pumpAndSettle();
    await tester.tap(man);
    await tester.pumpAndSettle();

    await tester.tap(find.text(l.tacticsTabOtherPositions));
    await tester.pumpAndSettle();

    expect(
      find.text('BenchBack13'),
      findsOneWidget,
      reason: 'a centre-back is somebody you CAN try up front',
    );
    expect(
      find.text(l.tacticsOutOfPositionNote),
      findsWidgets,
      reason: 'and the row says that is what he would be',
    );
    expect(tester.takeException(), isNull);
  });
}
