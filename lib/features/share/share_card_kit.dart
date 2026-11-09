import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/world_pack/trophy_image.dart';
import 'package:fnm/shared/widgets/country_flag.dart';

/// A custom world's trophy picture as the share cards draw it: decoded no
/// bigger than [TrophyImage] decodes it in the cabinet. One provider per
/// bytes, so the capture's warm-up and the card hit the same cache entry.
ImageProvider shareTrophyImage(Uint8List png) => ResizeImage(
  MemoryImage(png),
  width: TrophyImage.decodeBound,
  height: TrophyImage.decodeBound,
  policy: ResizeImagePolicy.fit,
);

/// A trophy on a share card, exactly as [TrophyImage] resolves it in the
/// cabinet: the career world's own picture ([custom]) when it has one, the
/// bundled [asset] otherwise, and the bundled one if the picture will not
/// decode.
class ShareTrophyArt extends StatelessWidget {
  const ShareTrophyArt({
    required this.asset,
    required this.height,
    this.custom,
    super.key,
  });

  final String asset;
  final Uint8List? custom;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bundled = Image.asset(asset, height: height, fit: BoxFit.contain);
    final png = custom;
    if (png == null) return bundled;
    return Image(
      image: shareTrophyImage(png),
      height: height,
      fit: BoxFit.contain,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => bundled,
    );
  }
}

/// The two shapes a share card is drawn in, at Instagram's own pixel sizes.
///
/// A card is laid out on a canvas of exactly [size] LOGICAL pixels and
/// captured at a pixel ratio of 1, so one unit in the card code is one pixel
/// in the shared image, whatever the phone's own density.
enum ShareFormat {
  /// A feed post, 1:1.
  square(Size(1080, 1080)),

  /// A story, 9:16.
  story(Size(1080, 1920));

  const ShareFormat(this.size);

  final Size size;

  bool get isStory => this == ShareFormat.story;

  /// Where the card's content goes. A story keeps its top and bottom 250 px
  /// clear: Instagram lays its progress bar and profile chip over the top
  /// and the reply box over the bottom.
  EdgeInsets get contentInsets => switch (this) {
    ShareFormat.square => const EdgeInsets.fromLTRB(64, 56, 64, 0),
    ShareFormat.story => const EdgeInsets.fromLTRB(72, 250, 72, 250),
  };
}

/// The brand name and handle. Never translated.
abstract final class ShareBrand {
  static const name = 'Football Nations Manager';
  static const handle = '@fnm.football';
  static const logoAsset = 'assets/images/fnm_logo.png';
}

/// The brushed silver of the match score plate (as on the score bug).
const List<Color> kShareSilverPlate = [
  Color(0xFFF2F6FA),
  Color(0xFFDCE4ED),
  Color(0xFFB8C2CD),
  Color(0xFFC9D2DC),
  Color(0xFFA6B0BB),
];
const List<double> kShareSilverStops = [0, 0.46, 0.54, 0.84, 1];

/// The gold every final and the World Championship wear.
const Color kShareGold = Color(0xFFF3D27A);

/// The card's canvas: near-black brushed steel, lit from either side by the
/// two given colours (the two nations' colours on a match card), with a thin
/// steel frame inset from the edge.
class ShareBackdrop extends StatelessWidget {
  const ShareBackdrop({
    required this.child,
    this.leftGlow,
    this.rightGlow,
    this.topGlow,
    super.key,
  });

  final Widget child;
  final Color? leftGlow;
  final Color? rightGlow;

  /// A light from above the content (the trophy cabinet's gold).
  final Color? topGlow;

  /// Whether two side lights would muddy the card where they meet: colours
  /// too alike (they read as one smear), opposite (they mix to grey), or a
  /// yellow or olive, which turns khaki over near-black. Then the lights are
  /// kept to the edges and the middle stays neutral steel.
  static bool muddyBlend(Color a, Color b) {
    final ha = HSLColor.fromColor(a);
    final hb = HSLColor.fromColor(b);
    bool yellowish(HSLColor c) =>
        c.saturation > 0.25 && c.hue >= 38 && c.hue <= 80;
    bool grey(HSLColor c) => c.saturation < 0.15;
    if (grey(ha) || grey(hb)) return false;
    if (yellowish(ha) || yellowish(hb)) return true;
    final d = (ha.hue - hb.hue).abs() % 360;
    final gap = d > 180 ? 360 - d : d;
    return gap < 35 || gap > 150;
  }

  @override
  Widget build(BuildContext context) {
    final edge =
        leftGlow != null &&
        rightGlow != null &&
        muddyBlend(leftGlow!, rightGlow!);
    Widget glow(Color c, Alignment at, double radius, double alpha) =>
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: at,
                radius: radius,
                colors: [
                  _lift(c).withValues(alpha: alpha),
                  _lift(c).withValues(alpha: 0),
                ],
              ),
            ),
          ),
        );
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B1E22), Color(0xFF111316), Color(0xFF08090B)],
          stops: [0, 0.5, 1],
        ),
      ),
      child: Stack(
        children: [
          if (leftGlow != null)
            glow(
              leftGlow!,
              Alignment(edge ? -1.45 : -1.25, -0.25),
              edge ? 0.7 : 0.9,
              0.2,
            ),
          if (rightGlow != null)
            glow(
              rightGlow!,
              Alignment(edge ? 1.45 : 1.25, -0.25),
              edge ? 0.7 : 0.9,
              0.2,
            ),
          // Two colours that would meet in a dull middle keep to the edges,
          // and the middle stays steel.
          if (edge)
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.2),
                    radius: 0.62,
                    colors: [Color(0xE6131518), Color(0x00131518)],
                    stops: [0.35, 1],
                  ),
                ),
              ),
            ),
          if (topGlow != null)
            glow(topGlow!, const Alignment(0, -0.35), 0.75, 0.16),
          const Positioned.fill(child: CustomPaint(painter: _BrushedPainter())),
          // A vignette, so the corners settle and the middle reads first.
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.1,
                  colors: [Color(0x00000000), Color(0x8C000000)],
                  stops: [0.55, 1],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }

  /// A nation's colour, lifted off black so a dark kit still lights the card.
  static Color _lift(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness(math.max(hsl.lightness, 0.42)).toColor();
  }
}

/// Faint horizontal grain, as on turned metal.
class _BrushedPainter extends CustomPainter {
  const _BrushedPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    final p = Paint()..strokeWidth = 1;
    for (var y = 0.0; y < size.height; y += 3) {
      p.color = Colors.white.withValues(
        alpha: 0.008 + rnd.nextDouble() * 0.014,
      );
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_BrushedPainter oldDelegate) => false;
}

/// A nation's flag as a large enamel disc: the app's `FlagDisc` look, with a
/// steel ring and a drop shadow drawn to poster size.
class ShareFlag extends StatelessWidget {
  const ShareFlag(this.code, {required this.size, this.ring, super.key});

  final String code;
  final double size;

  /// The ring's colour; steel when null.
  final Color? ring;

  @override
  Widget build(BuildContext context) {
    final rim = size * 0.035;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(rim),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: ring == null
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEFF3F7),
                  Color(0xFF8E98A3),
                  Color(0xFFD5DCE3),
                  Color(0xFF5F6872),
                ],
                stops: [0, 0.45, 0.6, 1],
              )
            : null,
        color: ring,
        boxShadow: [
          BoxShadow(
            color: const Color(0xB3000000),
            blurRadius: size * 0.12,
            offset: Offset(0, size * 0.04),
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CountryFlag(code),
            const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment(-0.45, -0.5),
                  radius: 0.95,
                  colors: [
                    Color(0x40FFFFFF),
                    Color(0x00FFFFFF),
                    Color(0x26000000),
                  ],
                  stops: [0, 0.55, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Text that shrinks (down to [minSize]) until it fits [maxLines] lines in
/// its width without breaking a word, then ellipsises as a last resort.
class ShareFitText extends StatelessWidget {
  const ShareFitText(
    this.text, {
    required this.style,
    this.maxLines = 1,
    this.minSize = 12,
    this.textAlign = TextAlign.center,
    this.matching = const [],
    super.key,
  });

  final String text;
  final TextStyle style;
  final int maxLines;
  final double minSize;
  final TextAlign textAlign;

  /// Texts set beside this one in a box of the same width (the other
  /// nation's name): all of them take the size the hardest one needs, so a
  /// long name does not leave a short one looking shouted.
  final List<String> matching;

  /// The largest size (from [style]'s, down to [minSize]) at which [text]
  /// fits [maxLines] lines of [maxWidth] without breaking a word.
  static double fitSize(
    String text,
    TextStyle style,
    double maxWidth,
    int maxLines,
    double minSize,
  ) {
    var size = style.fontSize ?? 14;
    final words = text.split(RegExp(r'\s+'));
    bool fits(double s) {
      final st = style.copyWith(fontSize: s);
      for (final w in words) {
        final tp = TextPainter(
          text: TextSpan(text: w, style: st),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout();
        if (tp.width > maxWidth) return false;
      }
      final tp = TextPainter(
        text: TextSpan(text: text, style: st),
        textDirection: TextDirection.ltr,
        maxLines: maxLines,
      )..layout(maxWidth: maxWidth);
      return !tp.didExceedMaxLines;
    }

    while (size > minSize && !fits(size)) {
      size -= 1;
    }
    return size;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        var size = fitSize(text, style, c.maxWidth, maxLines, minSize);
        for (final m in matching) {
          final other = fitSize(m, style, c.maxWidth, maxLines, minSize);
          if (other < size) size = other;
        }
        return Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: style.copyWith(fontSize: size),
        );
      },
    );
  }
}

/// A small caps caption, tracked wide: the cards' section labels.
class ShareCaption extends StatelessWidget {
  const ShareCaption(this.text, {this.color, this.size = 22, super.key});

  final String text;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    textAlign: TextAlign.center,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: AppTypography.labelSmall.copyWith(
      fontSize: size,
      height: 1.2,
      letterSpacing: size * 0.22,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.onSurfaceVariant,
    ),
  );
}

/// A hairline that fades out at both ends.
class ShareRule extends StatelessWidget {
  const ShareRule({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      height: 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            c.withValues(alpha: 0),
            c.withValues(alpha: 0.35),
            c.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

/// The brand strip at the foot of every card: the logo, the game's name and
/// the Instagram handle.
class ShareWatermark extends StatelessWidget {
  const ShareWatermark({required this.format, super.key});

  final ShareFormat format;

  @override
  Widget build(BuildContext context) {
    final story = format.isStory;
    final logo = story ? 84.0 : 72.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ShareRule(),
        SizedBox(height: story ? 28 : 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ShareBrand.logoAsset,
              height: logo,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ShareBrand.name.toUpperCase(),
                  style: AppTypography.headlineMedium.copyWith(
                    fontSize: story ? 30 : 27,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.4,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  ShareBrand.handle,
                  style: AppTypography.labelMedium.copyWith(
                    fontSize: story ? 25 : 23,
                    height: 1.1,
                    letterSpacing: 1.2,
                    color: AppColors.primaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// The fixed canvas a card is drawn on: exactly [ShareFormat.size], with the
/// platform's text scaling switched off so the image is the same on every
/// phone.
class ShareCanvas extends StatelessWidget {
  const ShareCanvas({required this.format, required this.child, super.key});

  final ShareFormat format;
  final Widget child;

  @override
  Widget build(BuildContext context) => MediaQuery.withNoTextScaling(
    child: SizedBox.fromSize(
      size: format.size,
      child: DefaultTextStyle(
        style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
        child: child,
      ),
    ),
  );
}
