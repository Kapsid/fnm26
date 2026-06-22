import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';

/// A recessed "inset" text field with an optional monospace label above it.
/// The inset look comes from the app's [InputDecorationTheme].
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.hint,
    this.label,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofocus = false,
    super.key,
  });

  final String hint;
  final String? label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      autofocus: autofocus,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
      decoration: InputDecoration(hintText: hint),
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label!.toUpperCase(),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        field,
      ],
    );
  }
}
