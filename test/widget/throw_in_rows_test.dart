import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';

/// The throw-in taker and style in the in-match editor: the same summary
/// line and row badge as the other takers, the keeper never the automatic
/// thrower, and the style chips coming back in the confirmed result.
void main() {
  const formation = Formation.f442;
  const throwerName = 'Strongarm';

  /// Eleven starters. The keeper (id 1) is the strongest of all and must
  /// still not be the automatic thrower; the left-back (id 2) is next.
  List<Player> squad() => [
    for (var i = 0; i < 11; i++)
      player(
        id: i + 1,
        nationId: 1,
        name: i == 1 ? throwerName : 'Starter${i + 1}',
        position: formation.positions[i],
        attributes: PlayerAttributes(
          physical: switch (i) {
            0 => 99,
            1 => 88,
            _ => 70,
          },
          // Weaker on the ball, so the penalty and dead-ball lines name
          // somebody else and his name appears once, on the throw-in line.
          technical: i == 1 ? 60 : 70,
          stamina: 70,
        ),
      ),
  ];

  InMatchTacticsResult? result;

  Future<AppLocalizations> open(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    double width = 400,
  }) async {
    result = null;
    tester.view
      ..physicalSize = Size(width, 2400)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (inner) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async => result = await showInMatchTactics(
                    inner,
                    minute: 60,
                    formation: formation,
                    lineup: [for (var i = 1; i <= 11; i++) i],
                    instructions: const TacticalInstructions(),
                    pool: squad(),
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
    final l = await AppLocalizations.delegate.load(locale);
    await tester.tap(find.text(l.tacticsTabTactics));
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.byKey(ThrowInStylePicker.chipKey(ThrowInStyle.long)),
      find.byType(ListView).last,
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    return l;
  }

  Finder summary(String text) => find.descendant(
    of: find.byType(SetPieceTakerSummary),
    matching: find.text(text),
  );

  testWidgets('the automatic thrower is the strongest outfielder, never the '
      'keeper', (tester) async {
    final l = await open(tester);
    expect(
      summary('${l.tacticsThrowIns}  ·  ${l.tacticsTakerAuto}'),
      findsOneWidget,
    );
    expect(summary(throwerName), findsOneWidget);
    // Every man on the pitch has a throw-in badge, the same as the others.
    for (var id = 1; id <= 11; id++) {
      expect(find.byKey(ValueKey('throwInBadge.$id')), findsOneWidget);
    }
    // Neutral is selected until the manager says otherwise.
    final neutral = tester.widget<ChoiceChip>(
      find.byKey(ThrowInStylePicker.chipKey(ThrowInStyle.neutral)),
    );
    expect(neutral.selected, isTrue);
    expect(find.text(l.tacticsThrowInNeutralBlurb), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('naming a thrower and a style comes back in the result', (
    tester,
  ) async {
    final l = await open(tester);
    await tester.tap(find.byKey(const ValueKey('throwInBadge.5')));
    await tester.pumpAndSettle();
    expect(summary(l.tacticsThrowIns), findsOneWidget);
    expect(summary('Starter5'), findsOneWidget);

    await tester.tap(find.byKey(ThrowInStylePicker.chipKey(ThrowInStyle.long)));
    await tester.pumpAndSettle();
    expect(find.text(l.tacticsThrowInLongBlurb), findsOneWidget);

    await tester.tap(find.text(l.tacticsApply));
    await tester.pumpAndSettle();
    expect(result, isNotNull);
    expect(result!.throwIn, (style: ThrowInStyle.long, taker: 5));
  });

  testWidgets('Czech at 360: the throw-in rows fit', (tester) async {
    final l = await open(tester, locale: const Locale('cs'), width: 360);
    expect(l.tacticsThrowIns, 'Auty');
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });
}
