import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Width guards with teeth.
///
/// `expect(tester.takeException(), isNull)` is the assertion these replace,
/// and it was never enough: it fires only on a RenderFlex overflow, so a
/// [Text] that wants 220px and is handed 120px passes it while quietly
/// printing an ellipsis. Four width bugs shipped past tests written that way,
/// two of them in English.
///
/// Three things a width test can ask here, in rising order of reach:
///
/// * [expectWhole] — this particular number or name is printed in full.
/// * [expectNothingCut] — NOTHING anywhere on the screen is cut. It found
///   bugs nobody was looking for; prefer it where a screen can afford it.
/// * [expectLegible] — for a `WholeText`, which no ellipsis guard can fail
///   because it scales itself down instead. Asks how far it had to shrink.
///
/// These measure what the phone will show. `test/flutter_test_config.dart`
/// loads the app's OWN typefaces before any test runs, so a marginal failure
/// here is a marginal failure on the device and is worth acting on.
///
/// It was not always so. Until that config existed, a widget test rendered in
/// Flutter's fallback face, which draws every glyph a full em wide where
/// Hanken Grotesk is nearer six tenths, and every measurement was about forty
/// per cent pessimistic. Thresholds written in that era were scaled for it;
/// if you meet one that still is, it is too lenient by that same margin.

/// Asserts that every paragraph [finder] matches is rendered WHOLE.
///
/// [what] names the thing for the failure message, which reports the width the
/// text wanted against the width it was granted.
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

/// Asserts that NOTHING anywhere on the pumped screen ran out of room.
///
/// The broad sweep: every [RenderParagraph] in the tree, whether or not the
/// test thought to name it. [where] names the screen in the failure message.
void expectNothingCut(WidgetTester tester, [String where = 'the screen']) {
  for (final element in find.byType(Text).evaluate()) {
    final paragraph = element.renderObject;
    if (paragraph is! RenderParagraph) continue;
    expect(
      paragraph.didExceedMaxLines,
      isFalse,
      reason:
          'something on $where is cut off: '
          '"${(element.widget as Text).data}" wants '
          '${paragraph.getMaxIntrinsicWidth(double.infinity)}px '
          'and was given ${paragraph.size.width}px',
    );
  }
}

/// How far a `WholeText` had to scale its child down to fit: 1.0 is untouched,
/// 0.5 is half size.
///
/// A `WholeText` never ellipsises, so [expectWhole] can never fail inside one
/// and the question there is not "does it fit" but "can it still be read".
/// This measures the painted width against the width the paragraph laid out
/// at, which is exactly the [FittedBox]'s scale factor.
///
/// [finder] must match exactly one [Text] — the one INSIDE the `WholeText`.
double shrinkOf(WidgetTester tester, Finder finder) {
  final element = finder.evaluate().single;
  final paragraph = element.renderObject! as RenderParagraph;
  final f = find.byWidget(element.widget);
  final painted = tester.getBottomRight(f).dx - tester.getTopLeft(f).dx;
  return painted / paragraph.size.width;
}

/// Asserts a `WholeText` is still readable: it did not have to scale below
/// [min] to fit.
///
/// The measured scale IS the scale on the phone, because the real faces are
/// loaded. [min] defaults to 0.6: the point at which a name in a list stops
/// being worth printing and the caller should offer a `shortText` instead.
///
/// It read 0.36 until 2026-09-26, which was the same threshold expressed in
/// the fallback face's units (`0.6 * 0.6`) and left over from before
/// `flutter_test_config.dart` loaded the real fonts. Against real metrics it
/// waved through anything above 36 per cent. Tightening it to 0.6 failed
/// nothing, so no screen was relying on the slack.
void expectLegible(
  WidgetTester tester,
  Finder finder,
  String what, {
  double min = 0.6,
}) {
  final shrink = shrinkOf(tester, finder);
  expect(
    shrink,
    greaterThanOrEqualTo(min),
    reason:
        '$what is squeezed to ${(shrink * 100).round()}% of its size '
        '(about ${(shrink / 0.6 * 100).clamp(0, 100).round()}% on a phone). '
        'Give it a shortText, or write the label around it shorter.',
  );
}

/// Asserts that the widget [inside] matches was really built in
/// [languageCode], before anything about its width is measured.
///
/// The trap this closes: `Localizations.override` wrapped around a launcher
/// does NOT reach a route pushed on the root [Navigator], so a test written
/// that way renders ENGLISH while believing it is measuring Czech — and a
/// Czech width case becomes the English one run twice. Reading the locale off
/// an element of the screen under test says which language is actually on
/// screen, whatever the harness intended. Pass a finder for something that
/// belongs to the screen being measured, not to the launcher behind it.
void expectLocale(WidgetTester tester, Finder inside, String languageCode) {
  final elements = inside.evaluate();
  expect(
    elements,
    isNotEmpty,
    reason: 'nothing to read a locale from: the screen never appeared',
  );
  final locale = Localizations.localeOf(elements.first);
  expect(
    locale.languageCode,
    languageCode,
    reason:
        'this screen rendered in ${locale.languageCode}, not $languageCode: '
        'the width measured below is the wrong language',
  );
}

/// Asserts that no paragraph [finder] matches had to BREAK A WORD to fit.
///
/// The gap [expectNothingCut] leaves: a paragraph that is allowed to wrap can
/// never exceed its line count, so it passes every ellipsis guard — and then
/// Flutter, handed a single word wider than the line, breaks it wherever the
/// edge falls. A question carrying a surname like Randriamampionona at 320px
/// is exactly that case, and it reads as a rendering fault rather than as long
/// copy.
///
/// A paragraph's MINIMUM intrinsic width is the width of its longest
/// unbreakable run, so anything wider than the space it was given was broken.
/// Takes a finder rather than sweeping the screen: a whole-screen sweep at
/// 320px turns up headings that are meant to wrap, and a guard that cries
/// wolf is turned off. Name the paragraph whose wrapping you care about.
void expectNoBrokenWord(Finder finder, String what) {
  final elements = finder.evaluate();
  expect(elements, isNotEmpty, reason: '$what is not on screen at all');
  for (final element in elements) {
    final paragraph = element.renderObject! as RenderParagraph;
    final longestWord = paragraph.getMinIntrinsicWidth(double.infinity);
    expect(
      longestWord,
      lessThanOrEqualTo(paragraph.size.width + 0.5),
      reason:
          '$what is broken across lines mid-word: its longest word wants '
          '${longestWord}px in a ${paragraph.size.width}px column',
    );
  }
}

/// Asserts that every paragraph [finder] matches is drawn on ONE line.
///
/// The failure this catches is not an overflow and not an ellipsis: Flutter
/// does not overflow a word that is wider than its line, it BREAKS it wherever
/// the edge happens to fall. A surname arriving as LEWANDO / WSKI passes every
/// other guard in this file — it exceeded no line count and lost no letters —
/// and is still unreadable. Where a label is meant to sit on one line, this is
/// what says so.
///
/// A paragraph's maximum intrinsic height is the height it takes at unbounded
/// width, which is exactly one line; anything taller than that has wrapped.
void expectOneLine(Finder finder, String what) {
  final elements = finder.evaluate();
  expect(elements, isNotEmpty, reason: '$what is not on screen at all');
  for (final element in elements) {
    final paragraph = element.renderObject! as RenderParagraph;
    final oneLine = paragraph.getMaxIntrinsicHeight(double.infinity);
    expect(
      paragraph.size.height,
      lessThanOrEqualTo(oneLine + 0.5),
      reason:
          '$what wrapped onto another line: it is '
          '${paragraph.size.height}px tall where one line is ${oneLine}px, '
          'and a word with no space in it breaks mid-word when it does',
    );
  }
}
