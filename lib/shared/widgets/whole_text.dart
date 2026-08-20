import 'package:flutter/material.dart';

/// A zero-width space, inserted between the letters of a word so that a long
/// SINGLE word can still break across lines.
///
/// Surnames have no spaces in them, so without a break opportunity the layout
/// has nowhere to wrap and a sixteen-letter name has to shrink to a fifth of
/// its size to fit its box. With one between every letter it wraps like a
/// sentence would, and the type stays readable. It is invisible and adds
/// nothing to the rendered glyphs.
const String breakOpportunity = '​';

/// [text] with a break opportunity between the letters of every space-free
/// run, so a long word may wrap instead of being cut or shrunk to nothing.
String withBreakOpportunities(String text) =>
    text.split(' ').map((w) => w.split('').join(breakOpportunity)).join(' ');

/// Text that is NEVER cut.
///
/// A name that ends in `…` is not a name any more, and the squad list, the
/// call-up screen and the pitch all deal in names. So the order of concessions
/// here is deliberate and it never reaches truncation: the text wraps first
/// (up to [maxLines], with [withBreakOpportunities] giving a long surname
/// somewhere to break), and only if it still does not fit does it scale down.
///
/// The pitch solved this first, disc by disc; this is that treatment lifted
/// out so every list that shows a person's name can promise the same thing.
///
/// Give it a bounded width. An unbounded [Text] lays out on one endless line
/// and the [FittedBox] then shrinks that line to nothing — the bounded width
/// is exactly what lets the wrap happen before any scaling does.
///
/// The break opportunities are only inserted when they are NEEDED: a name that
/// already fits is rendered exactly as it was given. That keeps the widget
/// honest about what is on screen (and keeps `find.text` matching, which
/// matters at every call site that already tests for a name).
class WholeText extends StatelessWidget {
  const WholeText(
    this.text, {
    this.style,
    this.maxLines = 2,
    this.textAlign,
    super.key,
  });

  /// The text as it should READ. Break opportunities are added internally.
  final String text;

  final TextStyle? style;

  /// How many lines it may wrap to before it starts scaling down.
  final int maxLines;

  final TextAlign? textAlign;

  /// Whether [text] lays out inside [width] without needing anywhere new to
  /// break. Measured rather than guessed, so short names are left untouched.
  static bool _fits(
    String text,
    TextStyle style,
    double width,
    BuildContext context,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    return painter.width <= width;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    // OUTSIDE the FittedBox on purpose. A FittedBox hands its child unbounded
    // constraints, so a LayoutBuilder within one measures infinity, never
    // wraps, and the widget quietly degenerates into "scale everything down"
    // — which is the behaviour this exists to avoid.
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      if (!width.isFinite) {
        // Nothing to wrap against; just draw it.
        return Text(text, maxLines: maxLines, textAlign: textAlign, style: style);
      }
      final resolved = style ?? DefaultTextStyle.of(context).style;
      final needsBreaks = !_fits(text, resolved, width, context);
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: switch (textAlign) {
          TextAlign.left || TextAlign.start => Alignment.centerLeft,
          TextAlign.right || TextAlign.end => Alignment.centerRight,
          _ => Alignment.center,
        },
        child: SizedBox(
          // A bounded width is what lets the wrap happen BEFORE any scaling:
          // an unbounded Text lays out on one endless line and the FittedBox
          // then shrinks that line to nothing.
          width: width,
          child: Text(
            needsBreaks ? withBreakOpportunities(text) : text,
            maxLines: maxLines,
            textAlign: textAlign,
            style: style,
            // No overflow and no softWrap override: wrapping is the point, and
            // there is deliberately no ellipsis to fall back to.
          ),
        ),
      );
    },
  );
}
