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
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Overrides the fill colour (defaults to `surfaceContainer`).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color ?? AppColors.surfaceContainer,
      borderRadius: AppRadii.baseAll,
      border: Border.all(color: AppColors.outlineVariant),
    );

    final content = Padding(padding: padding, child: child);

    if (onTap == null) {
      return DecoratedBox(decoration: decoration, child: content);
    }

    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.baseAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.baseAll,
        child: Ink(decoration: decoration, child: content),
      ),
    );
  }
}
