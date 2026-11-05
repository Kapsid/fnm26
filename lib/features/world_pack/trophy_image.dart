import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/trophies.dart';

/// Turns a picture the player chose into a trophy picture the game can show:
/// a transparent PNG, 400x400 for the World Championship and 400x600 for
/// every other trophy.
abstract final class TrophyNormaliser {
  static const int _maxBytes = 15 * 1024 * 1024;
  static const int _maxSide = 4096;

  /// The size trophy [key] is stored at.
  static ui.Size sizeFor(String key) =>
      key == 'world' ? const ui.Size(400, 400) : const ui.Size(400, 600);

  /// [input] cropped to [crop] (source pixels; the whole picture when null),
  /// scaled to fit [sizeFor] [key], centred on a transparent canvas and
  /// re-encoded as PNG. [hasAlpha] says whether the source had any
  /// see-through pixel. Null when [input] is too big or cannot be decoded.
  static Future<({Uint8List png, bool hasAlpha})?> normalise(
    Uint8List input,
    String key, {
    ui.Rect? crop,
  }) async {
    if (input.isEmpty || input.length > _maxBytes) return null;
    ui.Image? src;
    ui.Image? out;
    try {
      final codec = await ui.instantiateImageCodec(input);
      try {
        src = (await codec.getNextFrame()).image;
      } finally {
        codec.dispose();
      }
      if (src.width > _maxSide || src.height > _maxSide) return null;

      final bounds = ui.Rect.fromLTWH(
        0,
        0,
        src.width.toDouble(),
        src.height.toDouble(),
      );
      var from = crop == null ? bounds : crop.intersect(bounds);
      if (from.isEmpty) from = bounds;

      final rgba = await src.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (rgba == null) return null;
      var hasAlpha = false;
      for (var i = 3; i < rgba.lengthInBytes; i += 4) {
        if (rgba.getUint8(i) < 255) {
          hasAlpha = true;
          break;
        }
      }

      final target = sizeFor(key);
      final scale = (target.width / from.width) < (target.height / from.height)
          ? target.width / from.width
          : target.height / from.height;
      final w = from.width * scale;
      final h = from.height * scale;
      final to = ui.Rect.fromLTWH(
        (target.width - w) / 2,
        (target.height - h) / 2,
        w,
        h,
      );

      final recorder = ui.PictureRecorder();
      ui.Canvas(recorder).drawImageRect(
        src,
        from,
        to,
        ui.Paint()..filterQuality = ui.FilterQuality.high,
      );
      final picture = recorder.endRecording();
      try {
        out = await picture.toImage(
          target.width.round(),
          target.height.round(),
        );
      } finally {
        picture.dispose();
      }
      final png = await out.toByteData(format: ui.ImageByteFormat.png);
      if (png == null) return null;
      return (
        png: png.buffer.asUint8List(png.offsetInBytes, png.lengthInBytes),
        hasAlpha: hasAlpha,
      );
    } on Object {
      return null;
    } finally {
      src?.dispose();
      out?.dispose();
    }
  }
}

/// Trophy [trophyKey] ([Trophies.keyForCompetitionName]): the career's custom
/// picture when its world has one, the bundled artwork otherwise. Watches the
/// active world, so the picture appears when the world arrives.
class TrophyImage extends ConsumerWidget {
  const TrophyImage(
    this.trophyKey, {
    this.height,
    this.fit = BoxFit.contain,
    this.errorBuilder,
    super.key,
  });

  final String trophyKey;
  final double? height;
  final BoxFit fit;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final custom = ref.watch(activeWorldProvider).trophy(trophyKey);
    if (custom != null) {
      return Image.memory(
        custom,
        height: height,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: errorBuilder,
      );
    }
    return Image.asset(
      Trophies.assetForKey(trophyKey) ?? Trophies.worldCup,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
