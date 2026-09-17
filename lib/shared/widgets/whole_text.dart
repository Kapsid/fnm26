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

/// A person's name with the forename cut down to an initial: "Xenon John"
/// becomes "X. John".
///
/// The surname is the half that identifies a footballer, so when a name has to
/// give something up it gives up the front. Anything that is already one word
/// is returned untouched, and everything after the first word is kept whole —
/// "Jan van der Berg" shortens to "J. van der Berg", not to "J. Berg".
String initialledName(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length < 2) return name;
  final first = parts.first;
  if (first.isEmpty) return name;
  final initial = first.characters.first;
  // Already an initial ("J. Berg") — nothing to shorten.
  if (first.length <= 2 && first.endsWith('.')) return name;
  return '$initial. ${parts.skip(1).join(' ')}';
}

/// Text that is NEVER cut.
///
/// A name that ends in `…` is not a name any more, and the squad list, the
/// call-up screen and the pitch all deal in names. So the order of concessions
/// here is deliberate and it never reaches truncation: the text wraps first
/// (up to [maxLines], with [withBreakOpportunities] giving a long surname
/// somewhere to break), then falls back to [shortText] if one was offered, and
/// only then does it scale down.
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
    this.shortText,
    super.key,
  });

  /// The text as it should READ. Break opportunities are added internally.
  final String text;

  final TextStyle? style;

  /// How many lines it may wrap to before it starts scaling down.
  final int maxLines;

  final TextAlign? textAlign;

  /// A shorter way of saying the same thing, used when [text] itself will not
  /// fit — see [initialledName]. Shrinking a name to half its size is worse
  /// than writing it shorter, so a caller that has a shorter form offers it
  /// here and the widget only scales once even that has run out of room.
  final String? shortText;

  /// How wide [text] wants to be on one unbroken line. Measured rather than
  /// guessed, so short names are left untouched.
  static double _lineWidth(
    String text,
    TextStyle style,
    BuildContext context,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    return painter.width;
  }

  /// Whether [text] lays out inside [width] on a single line — no need to
  /// break, and nothing to gain from shortening.
  static bool _fits(
    String text,
    TextStyle style,
    double width,
    BuildContext context,
  ) => _lineWidth(text, style, context) <= width;

  /// How far the type may be scaled down before writing the text shorter is
  /// the better of the two concessions. A name a shade too wide is better
  /// slightly smaller than initialled; one that needs to halve is not.
  static const double _shrinkBeforeShortening = 0.85;

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
        return Text(
          text,
          maxLines: maxLines,
          textAlign: textAlign,
          style: style,
        );
      }
      final resolved = style ?? DefaultTextStyle.of(context).style;
      // What actually gets drawn. The shorter form is the LAST concession
      // before the type gets too small to read, so a name that fits — or that
      // only has to give up a little size — is written out in full.
      final short = shortText;
      final drawn =
          short != null &&
              short != text &&
              _lineWidth(text, resolved, context) >
                  width / _shrinkBeforeShortening
          ? short
          : text;

      if (maxLines == 1) {
        // One line has nowhere to wrap onto, so the only concession left is
        // size — and the text must be handed to the FittedBox UNBOUNDED to
        // get it. Bounded (as this used to be), a two-word name wrapped onto
        // a second line that maxLines then threw away: the squad list showed
        // a forename and silently swallowed the surname.
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: _alignment,
          child: Text(
            drawn,
            maxLines: 1,
            softWrap: false,
            textAlign: textAlign,
            style: style,
          ),
        );
      }

      // Break opportunities only help if there is a second line to break onto.
      final needsBreaks = !_fits(drawn, resolved, width, context);
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: _alignment,
        child: SizedBox(
          // A bounded width is what lets the wrap happen BEFORE any scaling:
          // an unbounded Text lays out on one endless line and the FittedBox
          // then shrinks that line to nothing.
          width: width,
          child: Text(
            needsBreaks ? withBreakOpportunities(drawn) : drawn,
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

  /// Where the drawn text sits in the box when it is NARROWER than the box —
  /// which, inside a [FittedBox], is most of the time.
  ///
  /// The default follows [Text]: against the leading edge. It used to centre
  /// whatever did not say otherwise, so a short name in a list row floated
  /// into the middle of its column while the flag and the icon beside it
  /// stayed put — the row read as broken, and only for the SHORT names.
  Alignment get _alignment => switch (textAlign) {
    TextAlign.right || TextAlign.end => Alignment.centerRight,
    TextAlign.center => Alignment.center,
    _ => Alignment.centerLeft,
  };
}
