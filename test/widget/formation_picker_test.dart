import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/features/tactics/formation_picker.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart' show layoutOf;

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// Seventeen shapes were already offered — as seventeen text chips, which is a
/// list of numbers rather than a choice: "4-1-4-1" and "4-4-1-1" are one glyph
/// apart and neither says what the side would look like.
void main() {
  testWidgets('every shape in the game is offered, drawn', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: FormationPicker(
            selected: Formation.f442,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byType(FormationTile),
      findsNWidgets(Formation.values.length),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the shapes added with the picker are among them', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: FormationPicker(
            selected: Formation.f442,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('4-3-2-1'), findsOneWidget);
    expect(find.text('3-5-1-1'), findsOneWidget);
  });

  testWidgets('tapping a shape reports it', (tester) async {
    Formation? picked;
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: FormationPicker(
            selected: Formation.f442,
            onSelected: (f) => picked = f,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('4-3-3'));
    expect(picked, Formation.f433);
  });

  test('every shape has eleven positions and eleven dots', () {
    for (final f in Formation.values) {
      expect(f.positions, hasLength(11), reason: '${f.label} positions');
      expect(layoutOf(f), hasLength(11), reason: '${f.label} layout');
    }
  });

  group('the compact field on the tactics screen', () {
    testWidgets('shows the shape you are playing, drawn, in one line', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: FormationField(
            selected: Formation.f433,
            onSelected: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('4-3-3'), findsOneWidget);
      // The whole grid is NOT on the screen — that is the point of it.
      expect(find.byType(FormationTile), findsNothing);
    });

    testWidgets('it fits in a fraction of what the grid took', (tester) async {
      tester.view
        ..physicalSize = const Size(360, 780)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpApp(
        Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: FormationField(
              selected: Formation.f433,
              onSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The inline grid was about 981pt on this width.
      expect(tester.getSize(find.byType(FormationField)).height, lessThan(120));
    });

    testWidgets('tapping it opens the full grid, and picking reports back', (
      tester,
    ) async {
      Formation? picked;
      await tester.pumpApp(
        Scaffold(
          body: FormationField(
            selected: Formation.f433,
            onSelected: (f) => picked = f,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FormationField));
      await tester.pumpAndSettle();
      expect(find.byType(FormationTile), findsWidgets);

      await tester.tap(find.text('4-4-2').last);
      await tester.pumpAndSettle();
      expect(picked, Formation.f442);
      // And the sheet closes behind the choice.
      expect(find.byType(FormationTile), findsNothing);
    });
  });

  /// The shapes at the widths a phone really is, in both languages.
  ///
  /// Four tiles across a 360pt phone leaves about seventy points each, and
  /// every one of them carries a label, a drawing and — once a side has drilled
  /// a shape — a word for how well it knows it. The Czech band words are the
  /// longest strings in the control.
  ///
  /// `expect(tester.takeException(), isNull)` is not the guard here. It passes
  /// for any amount of ellipsis, and a tile reading "SEZNAM..." has told the
  /// manager nothing.
  group('the shapes at phone widths', () {
    /// Every shape drilled to a different degree, so each band word — and so
    /// the longest of them — appears somewhere in the grid.
    final drilling = <Formation, double>{
      for (final (i, f) in Formation.values.indexed)
        f: i / Formation.values.length,
    };

    for (final width in [400.0, 360.0]) {
      for (final locale in [const Locale('en'), const Locale('cs')]) {
        testWidgets(
          'the grid holds every label at ${width.toInt()}px in '
          '${locale.languageCode}',
          (tester) async {
            tester.view
              ..physicalSize = Size(width, 1600)
              ..devicePixelRatio = 1.0;
            addTearDown(tester.view.reset);
            await tester.pumpApp(
              Scaffold(
                body: SingleChildScrollView(
                  child: FormationPicker(
                    selected: Formation.f442,
                    drilling: drilling,
                    onSelected: (_) {},
                  ),
                ),
              ),
              locale: locale,
            );
            await tester.pumpAndSettle();

            expectLocale(
              tester,
              find.byType(FormationPicker),
              locale.languageCode,
            );
            expectNothingCut(
              tester,
              'the formation grid in ${locale.languageCode}',
            );
          },
        );

        testWidgets(
          'the compact field holds its shape and its drilling at '
          '${width.toInt()}px in ${locale.languageCode}',
          (tester) async {
            tester.view
              ..physicalSize = Size(width, 900)
              ..devicePixelRatio = 1.0;
            addTearDown(tester.view.reset);
            await tester.pumpApp(
              Scaffold(
                body: Align(
                  alignment: Alignment.topCenter,
                  child: FormationField(
                    selected: Formation.f41212,
                    drilling: drilling,
                    onSelected: (_) {},
                  ),
                ),
              ),
              locale: locale,
            );
            await tester.pumpAndSettle();

            expectLocale(
              tester,
              find.byType(FormationField),
              locale.languageCode,
            );
            expectNothingCut(
              tester,
              'the formation field in ${locale.languageCode}',
            );

            // And the sheet it opens, which is a route on the ROOT navigator:
            // a Localizations.override around this launcher would never have
            // reached it, which is why the locale is on the MaterialApp.
            await tester.tap(find.byType(FormationField));
            await tester.pumpAndSettle();
            expectLocale(
              tester,
              find.byType(FormationPicker),
              locale.languageCode,
            );
            expectNothingCut(
              tester,
              'the formation sheet in ${locale.languageCode}',
            );
          },
        );
      }
    }
  });
}
