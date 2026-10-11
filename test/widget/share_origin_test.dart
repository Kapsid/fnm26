import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/util/share_origin.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

void main() {
  /// [target]'s context, placed at [rect] inside the 800 x 600 test view.
  Future<BuildContext> place(WidgetTester tester, Rect rect) async {
    late BuildContext target;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fromRect(
              rect: rect,
              child: Builder(
                builder: (context) {
                  target = context;
                  return const SizedBox.expand();
                },
              ),
            ),
          ],
        ),
      ),
    );
    return target;
  }

  testWidgets('the global rect of the widget it is given', (tester) async {
    final target = await place(tester, const Rect.fromLTWH(40, 60, 120, 30));
    expect(shareOriginOf(target), const Rect.fromLTWH(40, 60, 120, 30));
  });

  // share_plus on an iPad refuses any origin not wholly inside the view
  // (CGRectContainsRect), so a card scrolled half off the top, or a tile
  // under the status bar, must point at its visible part only.
  testWidgets('a widget partly off screen points at its visible part', (
    tester,
  ) async {
    final view = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(view, const Size(800, 600));
    final target = await place(
      tester,
      const Rect.fromLTWH(-40, -20, 120, 30),
    );
    expect(shareOriginOf(target), const Rect.fromLTWH(0, 0, 80, 10));
    final below = await place(tester, const Rect.fromLTWH(700, 580, 200, 50));
    expect(shareOriginOf(below), const Rect.fromLTWH(700, 580, 100, 20));
  });

  testWidgets('a widget wholly off screen points at the whole view', (
    tester,
  ) async {
    final target = await place(
      tester,
      const Rect.fromLTWH(-300, -100, 120, 30),
    );
    expect(shareOriginOf(target), const Rect.fromLTWH(0, 0, 800, 600));
  });

  // The tile's export points at its own button, not at the whole tile.
  testWidgets('a save tile hands its export button rect to onShare', (
    tester,
  ) async {
    Rect? received;
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SaveTile(
            save: Career(
              id: 1,
              managerName: 'M',
              nationId: 1,
              rngSeed: 7,
              createdAt: DateTime(2026, 7),
              inGameDate: DateTime(2026, 7),
              cyclePointer: 1,
            ),
            nation: null,
            onContinue: () {},
            onDelete: () {},
            onShare: (origin) {
              taps++;
              received = origin;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final button = find.widgetWithText(TextButton, 'Back up this save');
    expect(taps, 0);
    expect(received, isNull);
    await tester.tap(button);
    expect(taps, 1);
    expect(received, tester.getRect(button));
    expect(received, isNot(tester.getRect(find.byType(SaveTile))));
  });

  // Review Focus 3. An iPad refuses a share sheet with nowhere to point
  // (share_plus: "sharePositionOrigin: argument must be set"), and every
  // caller catches that and says the export failed.
  test('every share sheet in the app says where it points from', () {
    final share = RegExp(r'SharePlus\.instance\.share\s*\(');
    final origin = RegExp(r'sharePositionOrigin\s*:\s*(?!null\b)[A-Za-z_(]');
    // The deprecated static API has no origin of its own to check.
    final legacy = RegExp(r'\bShare\.(share|shareXFiles|shareUri)\s*\(');
    final offenders = <String>[];
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      // Comments do not count, for or against.
      final src = file
          .readAsLinesSync()
          .map((line) => line.replaceFirst(RegExp('//.*'), ''))
          .join('\n');
      if (legacy.hasMatch(src)) offenders.add('${file.path}: Share.*');
      for (final call in share.allMatches(src)) {
        final args = _argumentsFrom(src, call.end);
        if (!origin.hasMatch(args)) {
          offenders.add('${file.path}: ${_lineOf(src, call.start)}');
        }
      }
    }
    expect(offenders, isEmpty);
  });
}

/// The text of a call's arguments, from just after its `(` at [open] to the
/// matching `)`.
String _argumentsFrom(String src, int open) {
  var depth = 1;
  for (var i = open; i < src.length; i++) {
    final c = src[i];
    if (c == '(') depth++;
    if (c == ')' && --depth == 0) return src.substring(open, i);
  }
  return src.substring(open);
}

/// The 1-based line of [offset] in [src], for a readable failure.
int _lineOf(String src, int offset) =>
    '\n'.allMatches(src.substring(0, offset)).length + 1;
