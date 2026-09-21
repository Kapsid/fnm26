import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/repositories/tactic_familiarity_repository.dart';
import 'package:fnm/domain/services/tactics/familiarity_band.dart';
import 'package:fnm/features/tactics/familiarity_providers.dart';
import 'package:fnm/features/tactics/formation_picker.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

/// Familiarity you can watch build.
///
/// The mechanic was already in the engine and already moved results — a side
/// that keeps its shape plays a little sharper — and absolutely nothing on
/// screen said so, which makes a real effect read as imaginary. This is the
/// reading: a bar that fills under every shape, banded in words.
///
/// Two things these tests exist to hold down. The band is WORDS, never a
/// percentage, because the manager is being told how well his side knows the
/// shape rather than handed a dial to farm. And predictability — what the
/// opposition has worked out, hidden by design — must not reach the screen,
/// nor be recoverable from what does.
void main() {
  /// Pumps [widget] with the locale set on the MaterialApp itself.
  ///
  /// `Localizations.override` around a launcher does NOT reach a route pushed
  /// on the root navigator — the picker sheet is exactly such a route — and the
  /// test then silently measures English while believing it is measuring Czech.
  Future<void> pump(
    WidgetTester tester,
    Widget widget, {
    Locale locale = const Locale('en'),
    List<Override> overrides = const [],
  }) => tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.theme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    ),
  );

  void sizeTo(WidgetTester tester, double width) {
    tester.view
      ..physicalSize = Size(width, 820)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  /// How full the bar under [formation] is drawn, 0..1.
  double fillOf(WidgetTester tester, Formation formation) {
    final tile = find.ancestor(
      of: find.text(formation.label),
      matching: find.byType(FormationTile),
    );
    final bar = find.descendant(of: tile, matching: find.byType(DrillingBar));
    expect(bar, findsOneWidget, reason: '${formation.label} has no bar at all');
    return tester
            .widget<FractionallySizedBox>(
              find.descendant(
                of: bar,
                matching: find.byType(FractionallySizedBox),
              ),
            )
            .widthFactor ??
        -1;
  }

  /// Four fielded shapes plus the rest never played. 4-3-3 is second nature,
  /// 4-4-2 is coming together, 3-5-2 has had one outing.
  const drilling = {
    Formation.f433: 0.88,
    Formation.f442: 0.48,
    Formation.f352: 0.08,
    Formation.f4231: 0.0,
  };

  group('the bands', () {
    test('a shape with nothing stored is unplayed, not new', () {
      expect(familiarityBand(null), FamiliarityBand.unplayed);
      expect(familiarityBand(0), FamiliarityBand.fresh);
    });

    test('the bands climb with the outings', () {
      expect(familiarityBand(0.08), FamiliarityBand.fresh);
      expect(familiarityBand(0.48), FamiliarityBand.settling);
      expect(familiarityBand(0.88), FamiliarityBand.drilled);
      expect(familiarityBand(1), FamiliarityBand.drilled);
    });
  });

  testWidgets('every shape carries a bar, filled to what is stored', (
    tester,
  ) async {
    await pump(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: FormationPicker(
            selected: Formation.f442,
            drilling: drilling,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byType(DrillingBar),
      findsNWidgets(Formation.values.length),
      reason: 'every shape offered gets a reading, not just the played ones',
    );
    expect(fillOf(tester, Formation.f433), closeTo(0.88, 0.001));
    expect(fillOf(tester, Formation.f442), closeTo(0.48, 0.001));
    expect(fillOf(tester, Formation.f352), closeTo(0.08, 0.001));
  });

  testWidgets('a shape never fielded reads as empty, not absent', (
    tester,
  ) async {
    await pump(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: FormationPicker(
            selected: Formation.f442,
            drilling: drilling,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 5-3-2 is not in the stored map at all: the bar is still drawn, empty.
    expect(fillOf(tester, Formation.f532), 0);
    // And it is a state of its own — "never played" is not "played and barely
    // remembered", which 4-2-3-1 (stored, decayed to nothing) is.
    expect(fillOf(tester, Formation.f4231), 0);
    expect(find.text('UNPLAYED'), findsWidgets);
    expect(find.text('NEW'), findsWidgets);
  });

  testWidgets('the reading is words, never a percentage', (tester) async {
    await pump(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: FormationPicker(
            selected: Formation.f442,
            drilling: drilling,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('DRILLED'), findsOneWidget);
    expect(find.text('SETTLING'), findsOneWidget);
    for (final text in tester.widgetList<Text>(find.byType(Text))) {
      expect(
        text.data ?? '',
        isNot(contains('%')),
        reason: 'a number invites min-maxing a thing meant to be felt',
      );
    }
  });

  testWidgets('what the opposition knows never reaches the screen', (
    tester,
  ) async {
    // Every fielded shape is heavily READ as well as drilled. None of that may
    // show, and none of it may be recoverable from what does: the bar is fed
    // familiarity alone, so the fills below are the familiarity figures
    // untouched by predictability.
    await pump(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: FormationPicker(
            selected: Formation.f442,
            drilling: const {Formation.f433: 0.88, Formation.f442: 0.48},
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(fillOf(tester, Formation.f433), closeTo(0.88, 0.001));
    expect(fillOf(tester, Formation.f442), closeTo(0.48, 0.001));
  });

  test('the provider hands the screen familiarity and nothing else', () async {
    final container = ProviderContainer(
      overrides: [
        tacticFamiliarityRepositoryProvider.overrideWithValue(
          _ReadSideRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final byShape = await container.read(shapeDrillingProvider(7).future);

    // A `Map<Formation, double>` cannot carry predictability at all, which is
    // the point: the hidden figure is dropped at the data boundary rather than
    // handed to a widget that is trusted not to draw it.
    expect(byShape, {Formation.f433: 0.88, Formation.f442: 0.48});
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
            Scaffold(
              body: Align(
                alignment: Alignment.topCenter,
                child: FormationField(
                  selected: Formation.f433,
                  drilling: drilling,
                  onSelected: (_) {},
                ),
              ),
            ),
            locale: locale,
          );
          await tester.pumpAndSettle();

          // The locale really is the one we asked for: a Czech-only string is
          // on screen before anything is measured.
          if (locale.languageCode == 'cs') {
            expect(
              find.text('SEHRANÉ'),
              findsOneWidget,
              reason: 'the sheet silently rendered English',
            );
          } else {
            expect(find.text('DRILLED'), findsOneWidget);
          }
          expectWhole(find.text('4-3-3'), 'the shape on the compact field');
          expectWhole(
            find.byWidgetPredicate(
              (w) => w is Text && _bandWords.contains(w.data),
            ),
            'the drilling band on the compact field',
          );

          // And in the grid behind it, where the tiles are narrowest.
          await tester.tap(find.byType(FormationField));
          await tester.pumpAndSettle();
          expect(find.byType(FormationTile), findsWidgets);

          for (final f in Formation.values) {
            expectWhole(find.text(f.label), 'the shape "${f.label}"');
          }
          expectWhole(
            find.byWidgetPredicate(
              (w) => w is Text && _bandWords.contains(w.data),
            ),
            'a drilling band in the grid',
          );
          expectNothingCut(tester);
        });
      }
    }
  });
}

/// Every band word in both languages, so a width sweep catches the long one
/// whichever locale is being measured.
const _bandWords = {
  'UNPLAYED',
  'NEW',
  'SETTLING',
  'DRILLED',
  'NEHRANÉ',
  'NOVÉ',
  'SEHRÁVÁ SE',
  'SEHRANÉ',
};

/// A stored side that is both well drilled AND thoroughly read: if any of the
/// second figure escaped the data layer, it would have to show up downstream.
class _ReadSideRepository implements TacticFamiliarityRepository {
  @override
  Future<Map<Formation, ShapeDrilling>> forCareer(int careerId) async => {
    Formation.f433: (familiarity: 0.88, predictability: 0.91),
    Formation.f442: (familiarity: 0.48, predictability: 0.63),
  };

  @override
  Future<void> recordMatch(int careerId, Formation used, {int planKey = 0}) =>
      throw UnimplementedError();

  @override
  Future<void> reset(int careerId) => throw UnimplementedError();
}
