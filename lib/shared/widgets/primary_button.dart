import 'package:flutter/material.dart';

/// A reusable primary call-to-action button with an optional loading state.
///
/// Wrapping [FilledButton] in one place keeps button sizing, the busy
/// spinner, and the leading-icon layout consistent across every screen
/// (DRY) and gives us a single seam to restyle later.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  /// Button text.
  final String label;

  /// Tap handler. When `null` (or while [isLoading]) the button is disabled.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// When `true`, shows a spinner and disables interaction.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: child,
    );
  }
}
