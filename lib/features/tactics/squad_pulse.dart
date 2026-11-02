import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The squad's average rating and its morale, as two labelled bars.
///
/// Lived on the hub as "Squad status" until 1.0.9; the owner moved it to the
/// squad tab, where the manager acts on it, and took it off the dashboard.
class SquadPulse extends StatelessWidget {
  const SquadPulse({required this.rating, required this.morale, super.key});

  final int rating;
  final int morale;

  Color get _moraleColor => morale >= 60
      ? AppColors.positive
      : morale >= 42
      ? AppColors.primary
      : morale >= 25
      ? AppColors.warning
      : AppColors.error;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _line(l.hubAvgRating, Text('$rating', style: AppTypography.labelLarge)),
        const SizedBox(height: AppSpacing.xs),
        _bar(rating / 99, AppColors.primary),
        const SizedBox(height: AppSpacing.sm),
        _line(
          l.hubMorale,
          Text(
            moraleLabel(l, morale),
            style: AppTypography.labelLarge.copyWith(color: _moraleColor),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        _bar(morale / 100, _moraleColor),
      ],
    );
  }

  Widget _line(String label, Widget value) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      value,
    ],
  );

  Widget _bar(double fraction, Color color) => ClipRRect(
    borderRadius: AppRadii.smAll,
    child: Stack(
      children: [
        Container(height: 6, color: AppColors.surfaceContainerHighest),
        FractionallySizedBox(
          widthFactor: fraction.clamp(0.0, 1.0),
          child: Container(height: 6, color: color),
        ),
      ],
    ),
  );
}
