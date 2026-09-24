import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/substitution_rules.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';

/// The in-match substitution sheet: what it says about a man before he is
/// tapped, and taking a misclick back.
///
/// Two faults the manager reported. The squad list gave no sign at all that a
/// player had already been taken off or was carrying a knock, so he found out
/// by being refused. And a slot filled by accident could not be reversed
/// without leaving the sheet and losing every other change with it.
///
/// The scope of the undo is the point of two of these tests: only what THIS
/// sheet changed comes back. A substitution made ten minutes ago belongs to
/// the match, and football has no re-entry, so no amount of undo may walk a
/// withdrawn man back onto the pitch.
void main() {
  const formation = Formation.f442;

  /// Names on the pitch are drawn with zero-width spaces between their letters
  /// so a long one can wrap inside the ball, so plain text never finds them.
  Finder onPitchName(String text) => find.byWidgetPredicate(
    (w) => w is Text && w.data?.replaceAll('​', '') == text,
    description: 'pitch name "$text"',
  );

  /// Eleven starters (ids 1..11, named Starter1..Starter11, each in his slot's
  /// own position) and five substitutes (ids 12..16, all midfielders).
  List<Player> squad() => [
    for (var i = 0; i < 11; i++)
      player(
        id: i + 1,
        nationId: 1,
        name: 'Starter${i + 1}',
        position: formation.positions[i],
      ),
    for (var i = 12; i <= 16; i++) player(id: i, nationId: 1, name: 'Bench$i'),
  ];

  /// Opens the real editor over a launcher, the way the match screen does.
  ///
  /// [lineup] defaults to the untouched XI; pass one with a substitute in it
  /// to model a change made EARLIER in the match, before this sheet opened.
  ///
  /// The locale goes on the MaterialApp, NOT on a `Localizations.override`
  /// around the launcher: the editor is a route pushed under the root
  /// Navigator, so it is built outside anything wrapping the launcher. An
  /// override there leaves the sheet in English and turns a Czech width case
  /// into the English one run twice.
  Future<void> openSheet(
    WidgetTester tester, {
    List<int?>? lineup,
    Set<int> injuredIds = const {},
    Set<int> sentOffIds = const {},
    int maxSubs = 5,
    double width = 400,
    Locale locale = const Locale('en'),
  }) async {
    // setSurfaceSize, not tester.view.physicalSize. The editor is a PUSHED
    // ROUTE, and a probe showed its layout coming out identical at 320 and at
    // 430 with physicalSize set: these width cases were not constraining the
    // sheet at all, which is how a tab strip that painted its counter over
    // its second tab passed them. The surface size does reach it.
    await tester.binding.setSurfaceSize(Size(width, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
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
                    minute: 60,
                    formation: formation,
                    lineup: lineup ?? [for (var i = 1; i <= 11; i++) i],
                    instructions: const TacticalInstructions(),
                    pool: squad(),
                    startingIds: {for (var i = 1; i <= 11; i++) i},
                    maxSubs: maxSubs,
                    injuredIds: injuredIds,
                    sentOffIds: sentOffIds,
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
  }

  /// Opens the slot picker on the pitch node showing [starterName].
  Future<void> openPicker(WidgetTester tester, String starterName) async {
    await tester.tap(onPitchName(starterName.toUpperCase()));
    await tester.pumpAndSettle();
  }

  /// Puts [benchName] into the slot [starterName] occupies, through the slot
  /// picker — the tap path a manager actually uses.
  Future<void> substitute(
    WidgetTester tester,
    String starterName,
    String benchName,
  ) async {
    await openPicker(tester, starterName);
    // The squad list behind the modal sheet carries the same name; the sheet
    // was pushed later, so it is the last match in the tree.
    final target = find.text(benchName).last;
    // On a narrow phone the picker's list runs past the bottom of the sheet.
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  testWidgets('a man already taken off is not offered at all', (
    tester,
  ) async {
    // Bench12 came on for Starter3 before this sheet opened.
    await openSheet(
      tester,
      lineup: [1, 2, 12, 4, 5, 6, 7, 8, 9, 10, 11],
    );

    // He used to sit in a greyed pile with "already off" beside his name.
    // The manager decided that pile was not worth a third list, so a
    // withdrawn man simply leaves the sheet: not greyed, not listed.
    expect(
      find.text('Starter3'),
      findsNothing,
      reason: 'a man already taken off is no longer shown at all',
    );

    // The RULE has not moved with the row. It lives in refusalToBringOn and
    // still refuses him, which is what stops a drag rather than the absence
    // of a row: see the unit tests on substitution_rules.
    expect(
      canBringOn(
        startingIds: {for (var i = 1; i <= 11; i++) i},
        onPitch: {1, 2, 12, 4, 5, 6, 7, 8, 9, 10, 11},
        sentOffIds: const {},
        withdrawnIds: const {3},
        maxSubs: 5,
        playerId: 3,
      ),
      isFalse,
      reason: 'he still cannot come back on',
    );
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('a man hurt in this match is marked in the squad list', (
    tester,
  ) async {
    await openSheet(tester, injuredIds: {13});
    final l = await AppLocalizations.delegate.load(const Locale('en'));

    expect(find.text(l.tacticsSubInjured), findsOneWidget);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('undo restores the man and gives the substitution back', (
    tester,
  ) async {
    await openSheet(tester);
    final l = await AppLocalizations.delegate.load(const Locale('en'));

    expect(find.text(l.tacticsSubsUsed(0, 5)), findsOneWidget);
    expect(find.text(l.tacticsUndoLastChange), findsNothing);

    await substitute(tester, 'Starter11', 'Bench12');

    expect(find.text(l.tacticsSubsUsed(1, 5)), findsOneWidget);
    expect(onPitchName('BENCH12'), findsOneWidget);
    expect(onPitchName('STARTER11'), findsNothing);

    await tester.tap(find.text(l.tacticsUndoLastChange));
    await tester.pumpAndSettle();

    // The count is DERIVED from the lineup, so restoring the slot restores it.
    expect(find.text(l.tacticsSubsUsed(0, 5)), findsOneWidget);
    expect(onPitchName('STARTER11'), findsOneWidget);
    expect(onPitchName('BENCH12'), findsNothing);
    // And with nothing left to take back, the button is gone again.
    expect(find.text(l.tacticsUndoLastChange), findsNothing);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('undo does not reach a change made earlier in the match', (
    tester,
  ) async {
    // Bench12 already replaced Starter3 before the sheet opened.
    await openSheet(
      tester,
      lineup: [1, 2, 12, 4, 5, 6, 7, 8, 9, 10, 11],
    );
    final l = await AppLocalizations.delegate.load(const Locale('en'));

    // Nothing has been changed HERE, so there is nothing to take back.
    expect(find.text(l.tacticsUndoLastChange), findsNothing);
    expect(find.text(l.tacticsSubsUsed(1, 5)), findsOneWidget);

    // Make one change here, take it back, and the earlier one still stands.
    await substitute(tester, 'Starter11', 'Bench13');
    expect(find.text(l.tacticsSubsUsed(2, 5)), findsOneWidget);
    await tester.tap(find.text(l.tacticsUndoLastChange));
    await tester.pumpAndSettle();

    expect(find.text(l.tacticsSubsUsed(1, 5)), findsOneWidget);
    expect(onPitchName('BENCH12'), findsOneWidget);
    expect(onPitchName('STARTER3'), findsNothing);
    // Football has no re-entry, and undoing a LATER change does not give him
    // back. He is not marked out of the game any more, he is simply not in
    // the sheet: the greyed pile that used to carry that marker is gone.
    expect(find.text('Starter3'), findsNothing);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('undoing a chain hands the middle man back as pickable', (
    tester,
  ) async {
    // The case the snapshot shape exists for. Starter11 off for Bench12, then
    // Bench12 off for Bench13, then take the second change back.
    //
    // Bench12 is not a starter, so nothing derived from the starting XI knows
    // he was ever withdrawn — the withdrawn SET has to come back with the
    // lineup. Remembering only (slot, previous) would leave him marked out of
    // the game while he stands on the pitch, and the rules refuse a withdrawn
    // man before they ever look at whether he is on it.
    await openSheet(tester);
    final l = await AppLocalizations.delegate.load(const Locale('en'));

    await substitute(tester, 'Starter11', 'Bench12');
    await substitute(tester, 'Bench12', 'Bench13');

    // One starter is off the pitch, so one change is spent, chain or no chain.
    expect(find.text(l.tacticsSubsUsed(1, 5)), findsOneWidget);
    expect(onPitchName('BENCH13'), findsOneWidget);

    await tester.tap(find.text(l.tacticsUndoLastChange));
    await tester.pumpAndSettle();

    expect(onPitchName('BENCH12'), findsOneWidget);
    expect(onPitchName('BENCH13'), findsNothing);
    expect(find.text(l.tacticsSubsUsed(1, 5)), findsOneWidget);

    // And the man handed back is a man the manager can still move.
    await openPicker(tester, 'Bench12');
    final tile = find.widgetWithText(ListTile, 'Bench12');
    expect(tile, findsOneWidget);
    expect(
      tester.widget<ListTile>(tile).enabled,
      isTrue,
      reason: 'the returning man must not be refused as already withdrawn',
    );
    expect(
      find.descendant(of: tile, matching: find.text(l.tacticsSubOffAlready)),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('undoing a swap puts both men back, and neither twice', (
    tester,
  ) async {
    // The other case the snapshot shape exists for. Picking a man who is
    // ALREADY on the pitch moves him and pushes the slot's occupant into the
    // one he left: two slots change on one tap. Remembering only the slot that
    // was tapped would restore that slot alone and leave the other man
    // standing in two places at once.
    await openSheet(tester);
    final l = await AppLocalizations.delegate.load(const Locale('en'));

    // Both are strikers, so the picker for slot 11 offers slot 10's man.
    await substitute(tester, 'Starter11', 'Starter10');
    expect(find.text(l.tacticsSubsUsed(0, 5)), findsOneWidget);

    await tester.tap(find.text(l.tacticsUndoLastChange));
    await tester.pumpAndSettle();

    expect(onPitchName('STARTER10'), findsOneWidget);
    expect(onPitchName('STARTER11'), findsOneWidget);
    expect(find.text(l.tacticsSubsUsed(0, 5)), findsOneWidget);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  for (final width in <double>[400, 360]) {
    for (final locale in const [Locale('en'), Locale('cs')]) {
      testWidgets(
        'the markers and the undo fit ${width.toInt()}px in '
        '${locale.languageCode}',
        (tester) async {
          final l = await AppLocalizations.delegate.load(locale);
          await openSheet(
            tester,
            lineup: [1, 2, 12, 4, 5, 6, 7, 8, 9, 10, 11],
            injuredIds: {13},
            width: width,
            locale: locale,
          );
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);

          // The sheet really is in this language. It is a pushed route, so an
          // override around the launcher would never have reached it.
          // Proved off the candidates tab, which is always on screen. It
          // used to be proved off "already off", which lived in the spent
          // pile; that pile is gone, and a language check anchored to a
          // deleted section fails for the wrong reason.
          // Proved off a tab word, which is always on screen. It used to be
          // proved off the available heading, and that heading became a tab
          // label with its count on a line of its own.
          expect(
            find.text(l.tacticsTabSuitable),
            findsOneWidget,
            reason: 'the sheet did not render in ${locale.languageCode}',
          );

          expectWhole(
            find.text(l.tacticsSubsUsed(1, 5)),
            'the count of changes left',
          );
          expectWhole(find.text(l.tacticsSubInjured), 'the injury marker');
          // The already-off marker is gone with the pile it lived in. An
          // injured man is still OFFERED, with a warning, so his marker stays;
          // a withdrawn man is not offered at all any more, so there is no row
          // left to carry one.
          // A real candidate. Starter3 used to serve here, but in this
          // lineup he is a starter who is no longer on the pitch, which is
          // exactly the state that no longer appears in a list at all.
          expectWhole(find.text('Bench14'), 'a squad row name');

          // Any change made HERE brings the undo row out. A swap of two men
          // already on the pitch does it without spending a substitution, and
          // both sort to the top of the picker, which a bench midfielder does
          // not on a 360px sheet.
          await substitute(tester, 'Starter11', 'Starter10');
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);
          expectWhole(
            find.text(l.tacticsSubsUsed(1, 5)),
            'the count of changes left',
          );
          expectWhole(find.text(l.tacticsUndoLastChange), 'the undo button');
        },
      );
    }
  }

  // The GRAPHICAL route to a substitution, which is the one most managers
  // take: tap a man on the pitch and pick his replacement. The bench list
  // below the pitch was given sections; this sheet was not, so it went on
  // offering a man already taken off exactly as it offered a fit substitute
  // and a manager reported that it still looked old. It did.
  testWidgets('the slot picker is sectioned, not one flat list', (
    tester,
  ) async {
    await openSheet(tester);

    // Take somebody off first, so there is a man who cannot come back on and
    // the unavailable section has something in it to prove.
    await substitute(tester, 'Starter11', 'Bench12');
    await openPicker(tester, 'Starter10');

    // TWICE each: once in the bench list underneath, once in the picker over
    // it. That is the assertion. Before this the picker had none of its own
    // and every heading was found exactly once, which is what the old flat
    // list looked like from here.
    // The picker carries the same three groups the squad list has as tabs.
    // It used to be one flat run, and keeping the two surfaces apart is what
    // made substituting from the pitch look older than substituting from the
    // list.
    for (final heading in ['ON THE PITCH', 'AVAILABLE', 'UNAVAILABLE']) {
      expect(
        find.textContaining(heading),
        findsWidgets,
        reason: '"$heading" is missing from the slot picker',
      );
    }
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });
}
