import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/app_segmented_tabs.dart';

/// The app's one tab control: even segments when every label fits a share,
/// a sideways strip when not, and never a label scaled down or broken.

Future<void> _pump(
  WidgetTester tester,
  Widget Function(AppLocalizations l) build, {
  double width = 320,
  String locale = 'en',
  double scale = 1,
}) async {
  tester.view.physicalSize = Size(width, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, c) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: c!,
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) => build(AppLocalizations.of(context)),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Widget _tabs(List<String> labels, {List<Key> keys = const []}) =>
    DefaultTabController(
      length: labels.length,
      child: Column(
        children: [
          AppSegmentedTabs(
            tabs: [
              for (var i = 0; i < labels.length; i++)
                SegmentTab(labels[i], key: i < keys.length ? keys[i] : null),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (final s in labels) Center(child: Text('body $s')),
              ],
            ),
          ),
        ],
      ),
    );

/// Every label drawn whole on one line, at the size it was set: not cut, not
/// broken, not scaled.
void _expectAllWhole(WidgetTester tester, List<String> labels) {
  for (final label in labels) {
    final finder = find.descendant(
      of: find.byType(AppTabSegment),
      matching: find.text(label),
    );
    expect(finder, findsOneWidget, reason: '"$label" is missing');
    final paragraph = tester.renderObject<RenderParagraph>(finder);
    expect(paragraph.didExceedMaxLines, isFalse, reason: '"$label" is cut');
    expect(
      paragraph.text.toPlainText(),
      isNot(contains('\u200B')),
      reason: '"$label" has break points in it',
    );
    expect(
      paragraph.size.width,
      greaterThanOrEqualTo(paragraph.getMaxIntrinsicWidth(double.infinity)),
      reason: '"$label" was squeezed',
    );
    final painted =
        tester.getBottomRight(finder).dx - tester.getTopLeft(finder).dx;
    expect(
      painted,
      closeTo(paragraph.size.width, 0.5),
      reason: '"$label" scaled down',
    );
  }
  expect(find.byType(FittedBox), findsNothing);
}

void main() {
  testWidgets('three short labels share the width evenly', (tester) async {
    await _pump(tester, (_) => _tabs(const ['One', 'Two', 'Three']));
    expect(find.byType(SingleChildScrollView), findsNothing);
    final widths = {
      for (final s in const ['One', 'Two', 'Three'])
        tester
            .getSize(
              find.ancestor(
                of: find.text(s),
                matching: find.byType(AppTabSegment),
              ),
            )
            .width
            .round(),
    };
    expect(widths, hasLength(1), reason: 'the segments differ: $widths');
    _expectAllWhole(tester, const ['One', 'Two', 'Three']);
  });

  testWidgets('too many tabs scroll as a strip', (tester) async {
    final labels = [for (var i = 1; i <= 9; i++) 'Section $i'];
    await _pump(tester, (_) => _tabs(labels));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    _expectAllWhole(tester, labels);
    // The last is off screen; selecting it brings it into view.
    final last = find.text('Section 9');
    expect(tester.getTopLeft(last).dx, greaterThan(320));
    await tester.dragUntilVisible(
      last,
      find.byType(SingleChildScrollView),
      const Offset(-100, 0),
    );
    await tester.tap(last);
    await tester.pumpAndSettle();
    expect(find.text('body Section 9'), findsOneWidget);
  });

  testWidgets('keys tap the tab and drive the TabBarView', (tester) async {
    const a = Key('a');
    const b = Key('b');
    await _pump(tester, (_) => _tabs(const ['A', 'B'], keys: const [a, b]));
    expect(find.text('body A'), findsOneWidget);
    await tester.tap(find.byKey(b));
    await tester.pumpAndSettle();
    expect(find.text('body B'), findsOneWidget);
    // A swipe of the view moves the selection too.
    await tester.fling(find.text('body B'), const Offset(400, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('body A'), findsOneWidget);
    final seg = tester.widget<AppTabSegment>(
      find.ancestor(of: find.text('A'), matching: find.byType(AppTabSegment)),
    );
    expect(seg.selected, isTrue);
  });

  testWidgets('each segment is a tab, selected or not', (tester) async {
    final handle = tester.ensureSemantics();
    await _pump(tester, (_) => _tabs(const ['Left', 'Right']));
    expect(
      tester.getSemantics(find.text('Left')),
      matchesSemantics(
        label: 'Left',
        hint: 'Tab 1 of 2',
        isSelected: true,
        hasSelectedState: true,
        isButton: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.text('Right')),
      matchesSemantics(
        label: 'Right',
        hint: 'Tab 2 of 2',
        hasSelectedState: true,
        isButton: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });

  group('long translations at the largest text size, 320 wide', () {
    for (final locale in const ['cs', 'de', 'fi']) {
      testWidgets('$locale: match full time and cup tabs stay whole', (
        tester,
      ) async {
        late List<String> match;
        await _pump(
          tester,
          (l) {
            match = [
              l.matchTabTimeline,
              l.matchTabSummary,
              l.matchTabStats,
              l.matchTabLineups,
            ];
            return _tabs(match);
          },
          locale: locale,
          scale: 1.4,
        );
        expect(tester.takeException(), isNull);
        _expectAllWhole(tester, match);

        late List<String> cup;
        await _pump(
          tester,
          (l) {
            cup = [
              l.tourCupTabSummary,
              l.tourCupTabQualifying,
              l.tourCupTabPlayoff,
              l.tourCupTabFinals,
              l.tourCupTabBracket,
              l.tourCupTabAwards,
              l.tourCupTabScorers,
              l.tourCupTabHistory,
              l.tourCupTabRecords,
            ];
            return _tabs(cup);
          },
          locale: locale,
          scale: 1.4,
        );
        expect(tester.takeException(), isNull);
        _expectAllWhole(tester, cup);

        late List<String> profile;
        await _pump(
          tester,
          (l) {
            profile = [
              l.profileTabOverview,
              l.profileTabStats,
              l.profileTabCareer,
            ];
            return _tabs(profile);
          },
          locale: locale,
          scale: 1.4,
        );
        expect(tester.takeException(), isNull);
        _expectAllWhole(tester, profile);
      });
    }
  });
}
