import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/tactics/familiarity_band.dart';
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
    this.drilling,
    super.key,
  });

  final Formation selected;
  final ValueChanged<Formation> onSelected;

  /// How drilled the side is in each shape it has been fielded in, `0..1`;
  /// shapes never played are absent from the map and read as unplayed.
  ///
  /// Null means "no reading available" and shows none at all — the in-match
  /// editor uses the same control, and drilling is preparation, not something
  /// that moves at half-time.
  final Map<Formation, double>? drilling;

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
                    drilling: drilling,
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
                // Both hold a line each. A label with no maxLines does not
                // overflow when it runs out of room, it WRAPS — and what the
                // manager sees is not an error but the row growing taller and
                // the shape drawing beside it squashed to fit.
                Text(
                  selected.label,
                  maxLines: 1,
                  style: AppTypography.titleMedium,
                ),
                Text(
                  l.tacticsFormation,
                  maxLines: 1,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                // How well the side knows the shape it is in. The effect was
                // always in the engine and never on the screen, which makes a
                // real thing read as imaginary.
                if (drilling case final d?) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SizedBox(
                        width: 56,
                        child: DrillingBar(familiarity: d[selected]),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: DrillingLabel(familiarity: d[selected]),
                      ),
                    ],
                  ),
                ],
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
    this.drilling,
    super.key,
  });

  final Formation selected;
  final ValueChanged<Formation> onSelected;

  /// Familiarity per shape, `0..1`. See [FormationField.drilling].
  final Map<Formation, double>? drilling;

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 92,
      // Room under the label for the drilling reading, where there is one.
      childAspectRatio: drilling == null ? 0.78 : 0.60,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
    ),
    itemCount: Formation.values.length,
    itemBuilder: (context, i) {
      final f = Formation.values[i];
      return FormationTile(
        formation: f,
        selected: f == selected,
        familiarity: drilling?[f],
        showDrilling: drilling != null,
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
    this.familiarity,
    this.showDrilling = false,
    super.key,
  });

  final Formation formation;
  final bool selected;
  final VoidCallback onTap;

  /// Stored familiarity with this shape, `0..1`, or null for a shape the side
  /// has never been fielded in.
  final double? familiarity;

  /// Whether a drilling reading belongs on this tile at all.
  final bool showDrilling;

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
          // Scaled down rather than clipped. Four across on a narrow phone
          // leaves about seventy points a tile, and the longest shapes
          // ("4-1-2-1-2") are the ones a manager is least able to guess from
          // half of themselves.
          SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formation.label,
                maxLines: 1,
                style: AppTypography.labelSmall.copyWith(
                  color: selected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
          if (showDrilling) ...[
            const SizedBox(height: 4),
            DrillingBar(familiarity: familiarity),
            const SizedBox(height: 2),
            DrillingLabel(familiarity: familiarity, align: TextAlign.center),
          ],
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

/// A thin bar that fills with how drilled the side is in one shape.
///
/// A null [familiarity] is a shape never fielded: the track is still drawn,
/// empty. "You have never played this" is a real state and has to look
/// different from "absent", which is what leaving the bar off would say.
///
/// The bar is fed familiarity ALONE. Predictability — how well opponents have
/// read the side — is hidden by design, and a manager who could subtract this
/// reading from anything else on screen would have it back.
class DrillingBar extends StatelessWidget {
  const DrillingBar({required this.familiarity, super.key});

  final double? familiarity;

  @override
  Widget build(BuildContext context) {
    final band = familiarityBand(familiarity);
    return Semantics(
      label: AppLocalizations.of(context).tacticsDrilling,
      value: _bandWord(AppLocalizations.of(context), band),
      child: Container(
        height: 4,
        decoration: const BoxDecoration(
          color: AppColors.outlineVariant,
          borderRadius: AppRadii.smAll,
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: (familiarity ?? 0).clamp(0.0, 1.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _bandColor(band),
              borderRadius: AppRadii.smAll,
            ),
          ),
        ),
      ),
    );
  }
}

/// The band under the bar, in words: new, settling, drilled.
///
/// Words and not a percentage on purpose. The manager is being told how well
/// his side knows the shape, not handed a number to farm to 100.
class DrillingLabel extends StatelessWidget {
  const DrillingLabel({required this.familiarity, this.align, super.key});

  final double? familiarity;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    final band = familiarityBand(familiarity);
    return Text(
      _bandWord(AppLocalizations.of(context), band),
      textAlign: align,
      // Two lines, because the longest band word in Czech is two words and the
      // narrowest tile in the grid is about seventy points across.
      maxLines: 2,
      style: AppTypography.labelSmall.copyWith(
        fontSize: 9,
        letterSpacing: 0.2,
        height: 1.2,
        color: _bandColor(band),
      ),
    );
  }
}

String _bandWord(AppLocalizations l, FamiliarityBand band) => switch (band) {
  FamiliarityBand.unplayed => l.tacticsDrillingUnplayed,
  FamiliarityBand.fresh => l.tacticsDrillingNew,
  FamiliarityBand.settling => l.tacticsDrillingSettling,
  FamiliarityBand.drilled => l.tacticsDrillingDrilled,
};

Color _bandColor(FamiliarityBand band) => switch (band) {
  FamiliarityBand.unplayed => AppColors.onSurfaceVariant,
  FamiliarityBand.fresh => AppColors.onSurfaceVariant,
  FamiliarityBand.settling => AppColors.onSurfaceVariant,
  FamiliarityBand.drilled => AppColors.primary,
};
