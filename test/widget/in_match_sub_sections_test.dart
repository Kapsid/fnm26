import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';

/// The substitution list, and the two things the manager could not do with it.
///
/// "celkovo to nabizeni hracov na striedanie mi prislo celkom neprehladne.
/// vlastne z toho neviem kto hra od zaciatku. mam len tie percenta" — the
/// offer was unreadable, it never said who was playing from the start, and the
/// only thing on a row was a bare percentage. "nabízí to všechny.. mělo by to
/// zašednout ty už vystřídané, mít tam sekci podle eligibility" — it offers
/// everyone; grey out the ones already used and sort them into sections.
///
/// And: "drag mi nefunguje, nescrolluje sa to alebo som to nepochopil".
/// Dragging was the only way to make a change, which makes a gesture nobody
/// finds the only door into the feature. Tapping is the second door; the drag
/// is untouched and its own tests still hold it.
void main() {
  const formation = Formation.f442;

  /// Eleven starters (ids 1..11, each in his slot's own position) and five
  /// substitutes (ids 12..16). Bench16 is the reserve KEEPER, so the list can
  /// be asked whether it offers him for an outfield place.
  List<Player> squad() => [
    for (var i = 0; i < 11; i++)
      player(
        id: i + 1,
        nationId: 1,
        name: 'Starter${i + 1}',
        position: formation.positions[i],
      ),
    for (var i = 12; i <= 16; i++)
      player(
        id: i,
        nationId: 1,
        name: 'Bench$i',
        position: i == 16 ? PlayerPosition.gk : PlayerPosition.cm,
      ),
  ];

  /// Opens the real editor over a launcher, the way the match screen does.
  ///
  /// The locale goes on the MaterialApp, NOT on a `Localizations.override`
  /// around the launcher: the editor is a route pushed under the root
  /// Navigator, so an override there leaves the sheet in English and turns a
  /// Czech width case into the English one run twice.
  Future<AppLocalizations> openSheet(
    WidgetTester tester, {
    List<int?>? lineup,
    Set<int> sentOffIds = const {},
    Map<int, int> cameOnAt = const {},
    Map<int, int> wentOffAt = const {},
    Map<int, int> energyByPlayer = const {},
    int maxSubs = 5,
    double width = 400,
    double height = 2600,
    Locale locale = const Locale('en'),
  }) async {
    tester.view
      ..physicalSize = Size(width, height)
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
                  onPressed: () => showInMatchTactics(
                    inner,
                    minute: 70,
                    formation: formation,
                    lineup: lineup ?? [for (var i = 1; i <= 11; i++) i],
                    instructions: const TacticalInstructions(),
                    pool: squad(),
                    startingIds: {for (var i = 1; i <= 11; i++) i},
                    maxSubs: maxSubs,
                    sentOffIds: sentOffIds,
                    cameOnAt: cameOnAt,
                    wentOffAt: wentOffAt,
                    energyByPlayer: energyByPlayer,
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
    return AppLocalizations.delegate.load(locale);
  }

  /// Switches the sheet to the ON THE PITCH half. It opens on the candidates,
  /// because that is what a manager came here to change.
  Future<void> showPitchTab(WidgetTester tester, AppLocalizations l) async {
    // By the localised label, not by the English one: in Czech the chip reads
    // "NA HRISTI" and an English finder simply finds nothing, which surfaces
    // as a bare "No element" a long way from the cause.
    final stem = l.tacticsSectionOnPitch(0, 0).split('\u00b7').first.trim();
    final chip = find.textContaining(stem);
    await tester.ensureVisible(chip.first);
    await tester.pumpAndSettle();
    await tester.tap(chip.first);
    await tester.pumpAndSettle();
  }

  /// Taps a row by the name printed on it, scrolling it into view first.
  Future<void> tapRow(WidgetTester tester, String name) async {
    // The sheet is a lazy ListView, so a row below the fold is not merely
    // off screen, it has not been BUILT and no finder can see it. Scroll
    // until it exists, then tap. `.first` because a name can be on screen
    // twice, once on its pitch disc and once on its row.
    if (find.text(name).evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        find.text(name).first,
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
    }
    final row = find.text(name).first;
    await tester.ensureVisible(row);
    await tester.pumpAndSettle();
    await tester.tap(row);
    await tester.pumpAndSettle();
  }

  testWidgets('the squad is two tabs, and a used man is in neither', (
    tester,
  ) async {
    // Bench12 came on for Starter3 before this sheet opened, so there is a
    // man in each state at once, including one who is spent.
    final l = await openSheet(
      tester,
      lineup: [1, 2, 12, 4, 5, 6, 7, 8, 9, 10, 11],
    );

    expect(find.text(l.tacticsSectionOnPitch(11, 11)), findsOneWidget);
    // Four of the five substitutes are left; Starter3 cannot come back.
    expect(find.text(l.tacticsSectionAvailable(4)), findsOneWidget);
    // There is no third pile. A man already taken off leaves the sheet
    // rather than sitting greyed at the bottom of it.
    expect(find.text('Starter3'), findsNothing);
    // The count of changes left sits beside the tabs.
    expect(find.text(l.tacticsSubsUsed(1, 5)), findsOneWidget);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('every man on the pitch says whether he started or came on', (
    tester,
  ) async {
    final l = await openSheet(
      tester,
      lineup: [1, 2, 12, 4, 5, 6, 7, 8, 9, 10, 11],
      cameOnAt: {12: 55},
    );

    await showPitchTab(tester, l);
    expect(find.text(l.tacticsRowStarted), findsNWidgets(10));
    expect(
      find.text(l.tacticsRowCameOn(55)),
      findsOneWidget,
      reason: 'a substitute must say at what minute he came on',
    );
  });

  testWidgets('the energy percentage is no longer a bare number', (
    tester,
  ) async {
    final l = await openSheet(
      tester,
      energyByPlayer: {for (var i = 1; i <= 16; i++) i: 60},
    );

    expect(find.text(l.tacticsEnergyLabel), findsWidgets);
    expect(find.text('60%'), findsWidgets);
  });

  testWidgets('tapping a man on the pitch, then a substitute, changes them', (
    tester,
  ) async {
    final l = await openSheet(tester);

    expect(find.text(l.tacticsSubsUsed(0, 5)), findsOneWidget);
    await showPitchTab(tester, l);
    await tapRow(tester, 'Starter11');

    // The sheet now says what the next tap will do.
    expect(
      find.text(l.tacticsPickReplacementFor('Starter11')),
      findsOneWidget,
    );

    await tapRow(tester, 'Bench12');

    expect(find.text(l.tacticsSubsUsed(1, 5)), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Text && w.data == 'BENCH12',
        description: 'the pitch name BENCH12',
      ),
      findsOneWidget,
    );
    // He is not in a pile: there is no pile. A man taken off leaves the
    // sheet, which is the whole of what the third section used to say.
    expect(find.text('Starter11'), findsNothing);
    // The prompt is gone with the change it asked for.
    expect(find.text(l.tacticsDragSubOn), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping the selected man again puts the idea back', (
    tester,
  ) async {
    final l = await openSheet(tester);
    await showPitchTab(tester, l);

    await tapRow(tester, 'Starter11');
    expect(find.text(l.tacticsPickReplacementFor('Starter11')), findsOneWidget);

    // Choosing him moved the sheet to the candidates, so taking the idea
    // back means going to find him again.
    await showPitchTab(tester, l);
    await tapRow(tester, 'Starter11');
    expect(find.text(l.tacticsPickReplacementFor('Starter11')), findsNothing);
    expect(find.text(l.tacticsDragSubOn), findsOneWidget);
    expect(find.text(l.tacticsSubsUsed(0, 5)), findsOneWidget);
  });

  testWidgets('a tap cannot make a change a drag would have been refused', (
    tester,
  ) async {
    // Every change spent. The rules answer for the tap exactly as they answer
    // for the drop, so the bench is greyed and there is nothing to tap.
    final l = await openSheet(
      tester,
      lineup: [12, 13, 14, 4, 5, 6, 7, 8, 9, 10, 11],
      maxSubs: 3,
    );

    // Nobody left to bring on, and nobody listed as a might-have-been: with
    // the changes spent the candidates tab is empty and says so, rather than
    // showing five greyed men who cannot be used.
    expect(find.text(l.tacticsSectionAvailable(0)), findsOneWidget);
    expect(find.text(l.tacticsNoSubs), findsOneWidget);
    expect(find.text('Bench16'), findsNothing);
  });

  testWidgets('picking a man narrows the bench to who can take his place', (
    tester,
  ) async {
    // The rule the slot picker has always applied: a goalkeeping place is
    // keeper-only, every other place is outfield-only. The bench drop target
    // never asked, which a tap makes far easier to trip over.
    final l = await openSheet(tester);

    expect(find.text(l.tacticsSectionAvailable(5)), findsOneWidget);

    // An outfield place: the reserve keeper is not one of the answers.
    // Choosing a man to come off moves the sheet to the candidates by itself,
    // which is why each trip back to the eleven asks for the tab again.
    await showPitchTab(tester, l);
    await tapRow(tester, 'Starter11');
    expect(find.text(l.tacticsSectionAvailable(4)), findsOneWidget);
    expect(find.text('Bench16'), findsNothing);

    // The keeper's place: only the reserve keeper is.
    await showPitchTab(tester, l);
    await tapRow(tester, 'Starter11');
    await tapRow(tester, 'Starter1');
    expect(find.text(l.tacticsSectionAvailable(1)), findsOneWidget);
    expect(find.text('Bench16'), findsOneWidget);
    expect(find.text('Bench12'), findsNothing);
  });

  for (final width in <double>[320, 360, 400]) {
    for (final locale in const [Locale('en'), Locale('cs')]) {
      testWidgets(
        'the two tabs fit ${width.toInt()}px in ${locale.languageCode}',
        (tester) async {
          final l = await openSheet(
            tester,
            // One man in every state at once: a starter, a substitute already
            // on, a man taken off, a man sent off, and a full bench.
            lineup: [1, 2, 12, 4, 5, 6, 7, 8, 9, 10, 11],
            sentOffIds: {11},
            cameOnAt: {12: 55},
            wentOffAt: {3: 55},
            energyByPlayer: {for (var i = 1; i <= 16; i++) i: 100},
            width: width,
            locale: locale,
          );

          // The sheet really is in this language. It is a pushed route, so an
          // override around the launcher would never have reached it.
          // Proved off a tab, which is always on screen. It used to be
          // proved off the unavailable heading, and that heading is gone.
          expectLocale(
            tester,
            find.text(l.tacticsSectionAvailable(4)),
            locale.languageCode,
          );
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);

          expectWhole(
            find.text(l.tacticsSectionOnPitch(10, 11)),
            'the on-pitch heading',
          );
          expectWhole(
            find.text(l.tacticsSectionAvailable(4)),
            'the available heading',
          );
          expectWhole(
            find.text(l.tacticsSubsUsed(1, 5)),
            'the count of changes left',
          );
          expectWhole(find.text(l.tacticsEnergyLabel), 'the energy caption');
          expectWhole(find.text('100%'), 'an energy reading');

          // The other half. Its rows are only measurable once it is open,
          // which is the point of the tabs: half the sheet at a time.
          await showPitchTab(tester, l);
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);
          expectWhole(find.text(l.tacticsRowStarted), 'the starter marker');
          expectWhole(find.text(l.tacticsRowCameOn(55)), 'the came-on minute');
          // A name on an on-pitch row is scaled rather than cut, so ask how
          // far it had to shrink instead of whether it overflowed.
          expect(
            find.text('Starter10'),
            findsWidgets,
            reason: 'the on-pitch list is built',
          );
          expectLegible(
            tester,
            find.text('Starter10'),
            'a name in the on-pitch list',
          );

          // And the prompt that replaces the hint once a man is picked, which
          // is the longest line either language puts on this sheet.
          await tapRow(tester, 'Starter10');
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);
          expectWhole(
            find.text(l.tacticsPickReplacementFor('Starter10')),
            'the replacement prompt',
          );
        },
      );
    }
  }
}
