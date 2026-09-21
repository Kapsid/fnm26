import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/match/strength_factors.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/match/strength_panel.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tactics/familiarity_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The pre-match reading of what is helping and what is hurting.
///
/// Four separate pieces of feedback said the same thing in four ways: tired
/// players, the shape, how drilled the side is and the staff room all read as
/// doing nothing. They were all doing something; none of it was ever said. So
/// what these tests hold down is that the saying happens, that it happens on
/// ONE scale, that a quiet side is left alone rather than handed an empty box,
/// and that the figure the whole panel exists for is never cut off.
void main() {
  /// Asserts that every [finder] match is rendered WHOLE, not ellipsised.
  ///
  /// `takeException` alone is not enough and never was: it passes for any
  /// amount of quiet truncation, which is how six width bugs shipped past
  /// width tests that already existed in this batch — two of them in English.
  void expectWhole(Finder finder, String what) {
    final elements = finder.evaluate();
    expect(elements, isNotEmpty, reason: '$what is not on screen at all');
    for (final element in elements) {
      final paragraph = element.renderObject! as RenderParagraph;
      expect(
        paragraph.didExceedMaxLines,
        isFalse,
        reason:
            '$what is cut off: it wants '
            '${paragraph.getMaxIntrinsicWidth(double.infinity)}px '
            'and was given ${paragraph.size.width}px',
      );
    }
  }

  /// Pumps [panel] with the locale set on the MaterialApp itself.
  ///
  /// `Localizations.override` around a launcher does NOT reach a route pushed
  /// on the root navigator, and a test that uses one silently measures English
  /// while believing it is measuring Czech. Every Czech case below also asserts
  /// a Czech-only string is present before it measures anything.
  Future<void> pump(
    WidgetTester tester,
    Widget panel, {
    Locale locale = const Locale('en'),
  }) => tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.theme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: panel,
        ),
      ),
    ),
  );

  void sizeTo(WidgetTester tester, double width) {
    tester.view
      ..physicalSize = Size(width, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  /// A side with something to say on every line: drilled in its shape, tired,
  /// sharp at their clubs, a happy room, a captain, and a staff room worth the
  /// point it is worth.
  const everything = <StrengthFactor>[
    (kind: StrengthFactorKind.familiarity, delta: 3, subject: '4-3-3'),
    (kind: StrengthFactorKind.fatigue, delta: -2, subject: null),
    (kind: StrengthFactorKind.clubForm, delta: 1, subject: null),
    (kind: StrengthFactorKind.morale, delta: 2, subject: null),
    (kind: StrengthFactorKind.captain, delta: 1, subject: null),
    (kind: StrengthFactorKind.staff, delta: 1, subject: null),
  ];

  group('the scaling', () {
    /// What `StrengthFactors.of` hands over: the two squad lines are SUMS
    /// across twenty-three men, the other four are already side-level.
    const raw = <StrengthFactor>[
      (kind: StrengthFactorKind.fatigue, delta: -46, subject: null),
      (kind: StrengthFactorKind.clubForm, delta: 23, subject: null),
      (kind: StrengthFactorKind.morale, delta: 3, subject: null),
      (kind: StrengthFactorKind.familiarity, delta: 2, subject: '4-4-2'),
    ];

    test('the squad lines come down to the same scale as the rest', () {
      final scaled = {
        for (final f in perNamedMan(raw, 23)) f.kind: f.delta,
      };

      // Two points off each of twenty-three men is two points off the side,
      // not forty-six. Drawn unscaled it would be the biggest number on the
      // panel by an order of magnitude, next to a dressing room worth three.
      expect(scaled[StrengthFactorKind.fatigue], -2);
      expect(scaled[StrengthFactorKind.clubForm], 1);
      // And the side-level lines are left exactly as they came.
      expect(scaled[StrengthFactorKind.morale], 3);
      expect(scaled[StrengthFactorKind.familiarity], 2);
    });

    test('the order is taken again after the scaling, not before', () {
      // Unscaled, fatigue is far and away the biggest line. Scaled, the
      // dressing room is — and the order the manager reads has to be the order
      // of the numbers he is shown.
      expect(
        perNamedMan(raw, 23).map((f) => f.kind).toList(),
        [
          StrengthFactorKind.morale,
          // Familiarity and fatigue both come out at two; the tie falls back to
          // the declared order, so the same side never reads in a different
          // order twice running.
          StrengthFactorKind.familiarity,
          StrengthFactorKind.fatigue,
          StrengthFactorKind.clubForm,
        ],
      );
    });

    test('a line that scales away is dropped like any other zero', () {
      // One point off the whole squad is not a point off the side.
      final scaled = perNamedMan(const [
        (kind: StrengthFactorKind.clubForm, delta: 1, subject: null),
        (kind: StrengthFactorKind.morale, delta: -1, subject: null),
      ], 23);

      expect(scaled.map((f) => f.kind), [StrengthFactorKind.morale]);
    });

    test('an empty squad is nothing to report, not a division by zero', () {
      expect(perNamedMan(raw, 0), isEmpty);
    });
  });

  testWidgets('a line per factor, each with its direction and size', (
    tester,
  ) async {
    await pump(tester, const StrengthFactorList(factors: everything));

    expect(find.text('WHAT IS MOVING THE SIDE'), findsOneWidget);
    expect(find.text('Drilled shape'), findsOneWidget);
    expect(find.text('Tired legs'), findsOneWidget);
    expect(find.text('Club form'), findsOneWidget);
    expect(find.text('Dressing room'), findsOneWidget);
    expect(find.text('Captain'), findsOneWidget);
    expect(find.text('Staff room'), findsOneWidget);

    // The sign is written out, both ways: a plus has to be as loud as a minus,
    // and neither may depend on the colour alone.
    expect(find.text('+3'), findsOneWidget);
    expect(find.text('-2'), findsOneWidget);
    expect(find.text('+2'), findsOneWidget);
    expect(find.text('+1'), findsNWidgets(3));
    expect(find.byIcon(Icons.arrow_upward), findsNWidgets(5));
    expect(find.byIcon(Icons.arrow_downward), findsOneWidget);

    // And the subject, where there is one: which shape the side is drilled in.
    expect(find.text('4-3-3'), findsOneWidget);
  });

  testWidgets('a side with nothing acting on it gets no panel at all', (
    tester,
  ) async {
    await pump(tester, const StrengthFactorList(factors: []));

    // Not an empty card, not a heading over nothing, not a "nothing to
    // report" row. A settled, rested, contented squad is simply not
    // interrupted.
    expect(find.byType(AppCard), findsNothing);
    expect(find.text('WHAT IS MOVING THE SIDE'), findsNothing);
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('what the opposition knows is not on the panel', (tester) async {
    await pump(tester, const StrengthFactorList(factors: everything));

    // Predictability is hidden by design: it is what the opposition has worked
    // out about the side, not something the manager is told. The familiarity
    // figure this widget is handed is computed with it at zero, so there is
    // nothing here to subtract it out of — and nothing may creep onto the
    // panel later that there would be. Every word on it is accounted for.
    final allowed = {
      'WHAT IS MOVING THE SIDE',
      '4-3-3',
      ..._labels,
      for (final f in everything) signed(f.delta),
    };
    for (final text in tester.widgetList<Text>(find.byType(Text))) {
      expect(
        allowed,
        contains(text.data),
        reason: '"${text.data}" is on the panel and nothing asked for it',
      );
    }
  });

  group('a reading from before the manager changed his shape', () {
    // A side that has drilled 4-3-3 for years and has barely played 4-4-2.
    const stored = {Formation.f433: 0.9, Formation.f442: 0.2};
    const careerId = 1;

    StrengthPanelKey keyFor(Formation f) =>
        (careerId: careerId, formation: f, sideRating: 80);

    /// Everything `strengthFactorsProvider` reads, faked flat, so the only
    /// thing that can move the reading is the shape: no conditions (so the two
    /// squad lines are zero and drop), morale at the neutral 50, no captain,
    /// and whatever staff [careers] is holding.
    List<Override> overrides(_FakeCareers careers) => [
      careerRepositoryProvider.overrideWithValue(careers),
      shapeDrillingProvider.overrideWith((ref, id) async => stored),
      squadConditionProvider.overrideWith(
        (ref, id) async => const <int, PlayerCondition>{},
      ),
      squadDataProvider.overrideWith(
        (ref, id) async => SquadData(
          pool: const [],
          callUps: {for (var i = 1; i <= 23; i++) i},
          absences: const {},
        ),
      ),
      moraleProvider.overrideWith((ref, id) async => 50),
      captainProvider.overrideWith((ref, id) async => null),
      captainMoraleProvider.overrideWith((ref, id) async => 0),
    ];

    test(
      'a different shape is a different reading, never a cached one',
      () async {
        final container = ProviderContainer(
          overrides: overrides(_FakeCareers()),
        );
        addTearDown(container.dispose);

        // The shape is part of the provider KEY, so a manager who comes back
        // from the tactics screen having changed it is not reading the same
        // provider any more — there is no instance holding the old figure to
        // serve him. This is the guarantee the panel actually rests on.
        final drilled = await container.read(
          strengthFactorsProvider(keyFor(Formation.f433)).future,
        );
        final strange = await container.read(
          strengthFactorsProvider(keyFor(Formation.f442)).future,
        );

        expect(drilled.single.kind, StrengthFactorKind.familiarity);
        expect(drilled.single.delta, 5);
        expect(drilled.single.subject, '4-3-3');
        expect(strange.single.delta, 1);
        expect(strange.single.subject, '4-4-2');
      },
    );

    testWidgets('changing the shape changes the figure on screen', (
      tester,
    ) async {
      Future<void> show(Formation f) => tester.pumpWidget(
        ProviderScope(
          overrides: overrides(_FakeCareers()),
          child: MaterialApp(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: StrengthPanel(
                careerId: careerId,
                formation: f,
                sideRating: 80,
              ),
            ),
          ),
        ),
      );

      await show(Formation.f433);
      await tester.pumpAndSettle();
      expect(find.text('+5'), findsOneWidget);
      expect(find.text('4-3-3'), findsOneWidget);

      // The manager goes to the tactics screen and comes back in a shape his
      // side hardly knows. The panel has to say so.
      await show(Formation.f442);
      await tester.pumpAndSettle();
      expect(find.text('4-4-2'), findsOneWidget);
      expect(
        find.text('+5'),
        findsNothing,
        reason: 'the panel is still reading the shape he left behind',
      );
      expect(find.text('+1'), findsOneWidget);
    });

    test('an input the key cannot see still reaches the panel', () async {
      // The shape is in the key; the staff room is not. So this is what the
      // invalidation on the way back from the tactics screen is FOR — and it
      // is kept for the inputs that work this way, not for the shape, which
      // could not go stale if the invalidation were deleted tomorrow.
      final careers = _FakeCareers();
      final container = ProviderContainer(overrides: overrides(careers));
      addTearDown(container.dispose);
      // Held open, so the value below really is a cached one and the
      // invalidation really is doing the work.
      final key = keyFor(Formation.f433);
      container.listen(strengthFactorsProvider(key), (_, _) {});

      final before = await container.read(
        strengthFactorsProvider(key).future,
      );
      expect(
        before.where((f) => f.kind == StrengthFactorKind.staff),
        isEmpty,
        reason: 'nobody is hired yet',
      );

      careers.career = careers.career.copyWith(
        staffFitnessCoach: StaffTier.elite,
        staffAssistant: StaffTier.elite,
      );
      container.invalidate(strengthFactorsProvider);
      final after = await container.read(strengthFactorsProvider(key).future);

      expect(
        after.where((f) => f.kind == StrengthFactorKind.staff),
        isNotEmpty,
        reason: 'a full staff room is worth a point and the panel missed it',
      );
    });
  });

  group('width', () {
    for (final width in [360.0, 400.0]) {
      for (final locale in [const Locale('en'), const Locale('cs')]) {
        testWidgets('${locale.languageCode} at ${width.toInt()}px', (
          tester,
        ) async {
          sizeTo(tester, width);
          await pump(
            tester,
            const StrengthFactorList(factors: everything),
            locale: locale,
          );

          // The locale really is the one we asked for, before anything is
          // measured: otherwise this is an English test wearing a Czech name.
          if (locale.languageCode == 'cs') {
            expect(
              find.text('Realizační tým'),
              findsOneWidget,
              reason: 'the panel silently rendered English',
            );
          } else {
            expect(find.text('Staff room'), findsOneWidget);
          }

          // Every NUMBER, whole. The number is the whole point of the panel:
          // a cut label is bad and a cut figure is a lie.
          for (final n in ['+3', '-2', '+2', '+1']) {
            expectWhole(find.text(n), 'the figure "$n"');
          }
          expectWhole(find.text('4-3-3'), 'the shape on the familiarity line');
          expectWhole(
            find.byWidgetPredicate(
              (w) => w is Text && _labels.contains(w.data),
            ),
            'a factor label',
          );
          expectWhole(
            find.byWidgetPredicate(
              (w) =>
                  w is Text &&
                  (w.data == 'WHAT IS MOVING THE SIDE' ||
                      w.data == 'CO OVLIVŇUJE TÝM'),
            ),
            'the panel heading',
          );
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}

/// Every factor label in both languages, so the width sweep catches the long
/// one whichever locale is being measured.
const _labels = {
  'Drilled shape',
  'Tired legs',
  'Club form',
  'Dressing room',
  'Captain',
  'Staff room',
  'Nacvičené rozestavení',
  'Únava',
  'Forma v klubu',
  'Nálada v kabině',
  'Kapitán',
  'Realizační tým',
};

/// A save whose staff room can be changed under the panel, so an input that is
/// NOT part of the provider key can be shown reaching the screen.
class _FakeCareers implements CareerRepository {
  Career career = Career(
    id: 1,
    managerName: 'Tester',
    nationId: 1,
    rngSeed: 1,
    createdAt: DateTime(2026),
    inGameDate: DateTime(2026, 6),
  );

  @override
  Future<Career?> byId(int id) async => career;

  /// Everything else on the interface would only be noise here; a call to one
  /// is a test reading something it never meant to.
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not faked');
}
