import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The colour a between-match fatigue state is drawn in, everywhere it shows.
Color fatigueColor(FatigueState state) => switch (state) {
  FatigueState.exhausted => const Color(0xFFD64545),
  FatigueState.tired => const Color(0xFFEFC94C),
  FatigueState.ready || FatigueState.fresh => AppColors.onSurfaceVariant,
};

/// The word for a fatigue state ('' for fresh, which is never labelled).
String fatigueLabel(AppLocalizations l, FatigueState state) => switch (state) {
  FatigueState.exhausted => l.tacticsFatigueExhausted,
  FatigueState.tired => l.tacticsFatigueTired,
  FatigueState.ready => l.tacticsFatigueMatchLegs,
  FatigueState.fresh => '',
};

/// A compact tag flagging a fatigued player, to nudge rotation. Fresh draws
/// nothing. With [iconOnly] the word is dropped for a bare icon (still spoken
/// by a Semantics label), for rows with no room for it.
class FatigueTag extends StatelessWidget {
  const FatigueTag({required this.state, this.iconOnly = false, super.key});

  final FatigueState state;
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    if (state == FatigueState.fresh) return const SizedBox.shrink();
    final label = fatigueLabel(AppLocalizations.of(context), state);
    final color = fatigueColor(state);
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.battery_alert_rounded,
            size: iconOnly ? 13 : 11,
            color: color,
          ),
          if (!iconOnly) ...[
            const SizedBox(width: 2),
            Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
          ],
        ],
      ),
    );
  }
}

/// The marker on a player's disc on the line-up pitch: the same battery icon
/// in dark on a plate of the state colour, so it reads over any kit.
class FatigueDot extends StatelessWidget {
  const FatigueDot({required this.state, required this.size, super.key});

  final FatigueState state;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (state == FatigueState.fresh) return const SizedBox.shrink();
    final color = fatigueColor(state);
    return Semantics(
      label: fatigueLabel(AppLocalizations.of(context), state),
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: AppColors.surfaceContainerLowest),
        ),
        child: Icon(
          Icons.battery_alert_rounded,
          size: size * 0.72,
          color: AppColors.surfaceContainerLowest,
        ),
      ),
    );
  }
}
