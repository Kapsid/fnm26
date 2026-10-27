import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The full-backs' individual instructions as a full-size control: one row per
/// full-back the shape has, each a choice of push on, no instruction or hold
/// back.
///
/// The arrow on the pitch is the shortcut; this is the control a screen
/// reader, or a thumb, can use without aiming at a mark on the rim of a ball.
/// A shape with no full-back on a flank (a back three) has no row for it, and
/// with none at all the control draws nothing.
class FullBackInstructions extends StatelessWidget {
  const FullBackInstructions({
    required this.formation,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Formation formation;
  final FullBackPushes value;
  final void Function(FullBackSide side, FullBackPush push) onChanged;

  /// The choices in the order they read, attacking first.
  static const List<FullBackPush> _order = [
    FullBackPush.up,
    FullBackPush.neutral,
    FullBackPush.down,
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sides = [
      for (final side in FullBackSide.values)
        if (FullBackPushes.hasSide(formation.positions, side)) side,
    ];
    if (sides.isEmpty) return const SizedBox.shrink();
    String label(FullBackPush p) => switch (p) {
      FullBackPush.up => l.tacticsFullBackUp,
      FullBackPush.neutral => l.tacticsFullBackOff,
      FullBackPush.down => l.tacticsFullBackDown,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final side in sides)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  side == FullBackSide.left
                      ? l.tacticsFullBackLeft
                      : l.tacticsFullBackRight,
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                // A Wrap, not a segmented bar: "Nousee hyökkäykseen" and its
                // neighbours do not fit three across at 360 wide and 1.4.
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final p in _order)
                      ChoiceChip(
                        key: ValueKey('fullBackChoice.${side.name}.${p.name}'),
                        label: Text(label(p)),
                        selected: value.of(side) == p,
                        onSelected: (_) => onChanged(side, p),
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
