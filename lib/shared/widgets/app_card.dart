import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';

/// A "Pod": the primary organisational surface. A rounded container that sits
/// on the dark canvas with a 1px border slightly lighter than its fill to
/// define the edge. Optionally tappable.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.color,
    this.border,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Overrides the fill colour (defaults to `surfaceContainer`).
  final Color? color;

  /// Overrides the edge border (defaults to a subtle `outlineVariant`).
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color ?? AppColors.surfaceContainer,
      borderRadius: AppRadii.baseAll,
      border: border ?? Border.all(color: AppColors.outlineVariant),
    );

    final content = Padding(padding: padding, child: child);

    // A Material either way, even when the card does not answer a tap.
    //
    // Without one, a plain card was a bare DecoratedBox, and any ListTile
    // inside it asserted in debug: a ListTile paints its background and its
    // ink on the nearest Material ANCESTOR, so a DecoratedBox between the two
    // hides both. The call-up list is a page of ListTiles inside cards and
    // every one of its tests was throwing that assertion.
    //
    // The decoration goes through Ink rather than DecoratedBox so the Material
    // paints it, which is what keeps the splash on top of the fill instead of
    // under it.
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.baseAll,
      child: onTap == null
          ? Ink(decoration: decoration, child: content)
          : InkWell(
              onTap: onTap,
              borderRadius: AppRadii.baseAll,
              child: Ink(decoration: decoration, child: content),
            ),
    );
  }
}
