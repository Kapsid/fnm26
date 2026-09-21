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
/// * [expectLegible] — for a [WholeText], which no ellipsis guard can fail
///   because it scales itself down instead. Asks how far it had to shrink.
///
/// A caveat that applies to all of them: a widget test renders in Flutter's
/// fallback face, which draws every glyph a full em wide, where the app's own
/// faces are nearer six tenths of that. Every measurement here is therefore
/// PESSIMISTIC by roughly forty per cent. A clear failure is real; a marginal
/// one may not be.

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

/// How far a [WholeText] had to scale its child down to fit: 1.0 is untouched,
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

/// Asserts a [WholeText] is still readable: it did not have to scale below
/// [min] to fit.
///
/// Converting to what the manager sees: the test font is about an em per
/// glyph against the app's six tenths, so the scale on a real device is
/// roughly `shrink / 0.6`, capped at 1.0. A default [min] of 0.36 therefore
/// stands for "not below about sixty per cent on a phone", which is the point
/// at which a name in a list stops being worth printing and the caller should
/// offer a `shortText` instead.
void expectLegible(
  WidgetTester tester,
  Finder finder,
  String what, {
  double min = 0.36,
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
