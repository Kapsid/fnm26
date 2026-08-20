import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';

/// Turns a nation's raw home-kit hexes into colours that actually work on the
/// app's near-black canvas.
///
/// Kit colours are stored as they really are — including `#FFFFFF` (England),
/// `#000000` (a black change strip) and near-navy blues. Painted straight onto
/// the dark UI those either blind or vanish, so everything that re-skins a
/// surface with a nation's colours goes through here: the tones are lifted into
/// a legible band, near-duplicates are dropped from a gradient, and the text
/// colour to sit on top is derived rather than guessed.
///
/// Shared by the tactics pitch (team identity on the player discs) and the
/// tournament host re-skin (banners and accents), which previously each had
/// their own copy — or, in the pitch's case, no colour at all.
abstract final class KitColors {
  /// Parses a `#RRGGBB` kit colour into an opaque [Color]; falls back to the
  /// app accent on a malformed value.
  static Color parse(String hex) {
    var h = hex.replaceAll('#', '').trim();
    if (h.length == 6) h = 'FF$h';
    final v = int.tryParse(h, radix: 16);
    return v == null ? AppColors.primary : Color(v);
  }

  /// Lifts one raw kit colour into a tone that reads on the dark UI without
  /// losing its identity: a near-black or blinding-white kit is pulled toward a
  /// mid band, a vivid one stays vivid.
  static Color legible(Color raw) {
    final h = HSLColor.fromColor(raw);
    final l = h.saturation >= 0.15
        ? h.lightness.clamp(0.34, 0.66) // colourful: vivid, not muddy/blinding
        : h.lightness.clamp(0.40, 0.62); // greyscale: a visible grey
    return h.withLightness(l).toColor();
  }

  /// Whether two palette colours read as the same (two reds, two whites), so a
  /// gradient doesn't waste a stop on a near-duplicate.
  static bool tooClose(Color a, Color b) {
    final x = HSLColor.fromColor(a);
    final y = HSLColor.fromColor(b);
    final dh = (x.hue - y.hue).abs();
    final hueDist = dh > 180 ? 360 - dh : dh;
    return hueDist < 24 &&
        (x.lightness - y.lightness).abs() < 0.18 &&
        (x.saturation - y.saturation).abs() < 0.25;
  }

  /// Nudges a colour lighter/darker — for fanning a single-colour kit into a
  /// gradient of itself.
  static Color shade(Color c, double dl) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness + dl).clamp(0.0, 1.0)).toColor();
  }

  /// A legible lead colour from a kit's two hexes. Picks the "team colour" (the
  /// more saturated of the two), then lifts it into a band that reads on the
  /// dark UI — so a navy kit becomes a visible tone rather than vanishing, and
  /// an all-white/black kit lands on a clean light shade.
  static Color accent(String primaryHex, String secondaryHex) {
    final a = HSLColor.fromColor(parse(primaryHex));
    final b = HSLColor.fromColor(parse(secondaryHex));
    var pick = a.saturation >= b.saturation ? a : b;
    if (pick.saturation < 0.15) {
      // Greyscale kit — keep the lighter of the two as the base.
      pick = a.lightness >= b.lightness ? a : b;
    }
    final l = pick.saturation >= 0.15
        ? pick.lightness.clamp(0.42, 0.68) // colourful: vivid but visible
        : 0.85; // greyscale → a clean light tone
    return pick
        .withLightness(l)
        .withSaturation(pick.saturation.clamp(0.0, 1.0))
        .toColor();
  }

  /// Readable text/icon colour to sit on top of [accent].
  static Color onAccent(Color accent) =>
      accent.computeLuminance() > 0.5 ? AppColors.surface : Colors.white;

  /// A gradient palette from one or more kits (each a `(primary, secondary)`
  /// hex pair): every colour made UI-legible, with near-duplicates dropped. Two
  /// or more kits make a richer sweep — a Spain·Portugal edition runs
  /// red→yellow→green rather than one flat tint.
  static List<Color> gradient(Iterable<(String, String)> kits) {
    final out = <Color>[];
    for (final (primaryHex, secondaryHex) in kits) {
      for (final hex in [primaryHex, secondaryHex]) {
        final c = legible(parse(hex));
        if (out.any((o) => tooClose(o, c))) continue;
        out.add(c);
      }
    }
    return out;
  }

  /// Two nations' colours, guaranteed to read as DIFFERENT from each other.
  ///
  /// A two-sided bar showing which way a match is going is only worth painting
  /// in the teams' own colours if the two sides can be told apart — and two of
  /// the reds in this game are all but identical. When the leads collide the
  /// second kit's colour is tried, and failing that one side is pushed lighter
  /// and the other darker, which separates any pair without either losing its
  /// identity.
  static (Color, Color) opposed(
    (String, String) homeKit,
    (String, String) awayKit,
  ) {
    final home = accent(homeKit.$1, homeKit.$2);
    var away = accent(awayKit.$1, awayKit.$2);
    if (!tooClose(home, away)) return (home, away);
    // Their second colour, if that is genuinely a different colour.
    final alt = legible(parse(awayKit.$2));
    if (!tooClose(home, alt)) return (home, alt);
    return (shade(home, 0.16), shade(away, -0.16));
  }

  /// A two-stop fill for a small surface (a player disc, a chip) in a single
  /// nation's colours. Uses the second kit colour when it reads as genuinely
  /// different, otherwise a darker shade of the first — so every nation gets a
  /// gradient, and a two-colour kit gets its own two colours.
  static List<Color> discFill(String primaryHex, String secondaryHex) {
    final lead = accent(primaryHex, secondaryHex);
    final other = legible(
      parse(
        tooClose(legible(parse(primaryHex)), lead) ? secondaryHex : primaryHex,
      ),
    );
    if (!tooClose(lead, other)) return [lead, other];
    return [lead, shade(lead, -0.20)];
  }
}
