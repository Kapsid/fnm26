import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/trophies.dart';

export 'package:fnm/domain/services/world_pack/trophy_normaliser.dart';

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

  /// The longest side a custom picture is decoded at.
  static const int decodeBound = 600;

  final String trophyKey;
  final double? height;
  final BoxFit fit;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final custom = ref.watch(activeWorldProvider).trophy(trophyKey);
    final asset = Image.asset(
      Trophies.assetForKey(trophyKey) ?? Trophies.worldCup,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
    if (custom == null) return asset;
    // A picture that will not decode falls back to the bundled artwork.
    // Decoded no bigger than the largest stored trophy (400x600), whatever
    // the bytes claim: a second guard behind the normaliser.
    return Image(
      image: ResizeImage(
        MemoryImage(custom),
        width: decodeBound,
        height: decodeBound,
        policy: ResizeImagePolicy.fit,
      ),
      height: height,
      fit: fit,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => asset,
    );
  }
}
