import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart' show layoutOf;
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The formation control on the tactics screen: the shape you are playing,
/// drawn small, with a tap through to the full grid.
///
/// The grid used to sit inline. Nineteen shapes at three across is seven rows
/// — about 981 points on a phone, a screen and a half of formations between
/// the manager and his own pitch. The choice is worth a whole screen when he
/// is making it and worth a single line the rest of the time, so it moved
/// behind this.
class FormationField extends StatelessWidget {
  const FormationField({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final Formation selected;
  final ValueChanged<Formation> onSelected;

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<Formation>(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      isScrollControlled: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (context, controller) => Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).tacticsChooseShape,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: FormationPicker(
                    selected: selected,
                    onSelected: (f) => Navigator.of(sheetContext).pop(f),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) onSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      onTap: () => _open(context),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            height: 44,
            child: CustomPaint(
              painter: _ShapePainter(
                layout: layoutOf(selected),
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(selected.label, style: AppTypography.titleMedium),
                Text(
                  l.tacticsFormation,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

/// A shape, drawn.
///
/// Seventeen formations were already offered — as seventeen text chips, which
/// is a list of numbers, not a choice. "4-1-4-1" and "4-4-1-1" are one glyph
/// apart and nothing about either says what the side would look like. A shape
/// is a picture, so this draws one: eleven dots at the positions the tactics
/// pitch itself would put them, off the same layout table, so the picker can
/// never drift from what the manager sees when he taps it.
class FormationPicker extends StatelessWidget {
  const FormationPicker({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final Formation selected;
  final ValueChanged<Formation> onSelected;

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 92,
      childAspectRatio: 0.78,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
    ),
    itemCount: Formation.values.length,
    itemBuilder: (context, i) {
      final f = Formation.values[i];
      return FormationTile(
        formation: f,
        selected: f == selected,
        onTap: () => onSelected(f),
      );
    },
  );
}

/// One shape on the picker: a mini pitch with the side drawn on it, the label
/// beneath, and the current shape picked out.
class FormationTile extends StatelessWidget {
  const FormationTile({
    required this.formation,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Formation formation;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = selected ? AppColors.primary : AppColors.outlineVariant;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.surfaceContainerLowest,
                borderRadius: AppRadii.smAll,
                border: Border.all(
                  color: accent,
                  width: selected ? 1.5 : 1,
                ),
              ),
              padding: const EdgeInsets.all(5),
              child: CustomPaint(
                painter: _ShapePainter(
                  layout: layoutOf(formation),
                  color: selected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            formation.label,
            maxLines: 1,
            style: AppTypography.labelSmall.copyWith(
              color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Eleven dots, and the halfway line so the picture reads as a pitch rather
/// than a scatter plot.
class _ShapePainter extends CustomPainter {
  const _ShapePainter({required this.layout, required this.color});

  final List<(double, double)> layout;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()
        ..color = color.withValues(alpha: 0.25)
        ..strokeWidth = 0.6,
    );
    final dot = Paint()..color = color;
    for (final (x, y) in layout) {
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        2.1,
        dot,
      );
    }
  }

  @override
  bool shouldRepaint(_ShapePainter old) =>
      old.color != color || old.layout != layout;
}
