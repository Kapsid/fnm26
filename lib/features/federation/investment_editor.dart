import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/department_effect.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Formats euros compactly for the finance UI (e.g. `€4.5M`, `€250K`, `€0`).
String formatEuros(int euros) {
  if (euros >= 1000000) {
    final m = euros / 1000000;
    return '€${m.toStringAsFixed(m == m.roundToDouble() ? 0 : 1)}M';
  }
  if (euros >= 1000) return '€${(euros / 1000).round()}K';
  return '€$euros';
}

/// The department allocation editor: one slider per department, in whole
/// levels (see [FederationFinance.investLevelPrice]), that together cannot
/// exceed the available balance. Reports the
/// current split on every change. Youth can be disabled (e.g. the opening
/// cycle, which has no academy intake yet).
class InvestmentEditor extends StatefulWidget {
  const InvestmentEditor({
    required this.available,
    required this.initial,
    required this.onChanged,
    this.youthEnabled = true,
    this.showEffects = true,
    super.key,
  });

  /// The most that can be allocated across all departments combined.
  final int available;
  final FederationInvestment initial;
  final ValueChanged<FederationInvestment> onChanged;
  final bool youthEnabled;

  /// Whether each slider states, under its blurb, what its money buys. The
  /// tablet says that once, beside the sliders, and turns this off.
  final bool showEffects;

  @override
  State<InvestmentEditor> createState() => _InvestmentEditorState();
}

class _InvestmentEditorState extends State<InvestmentEditor> {
  late int _youth = widget.initial.youth;
  late int _commercial = widget.initial.commercial;
  late int _medical = widget.initial.medical;
  late int _naturalization = widget.initial.naturalization;
  late int _boardRelations = widget.initial.boardRelations;

  static const _price = FederationFinance.investLevelPrice;

  int get _allocated =>
      _youth + _commercial + _medical + _naturalization + _boardRelations;
  int get _remaining => widget.available - _allocated;

  FederationInvestment get _current => (
    youth: _youth,
    commercial: _commercial,
    medical: _medical,
    naturalization: _naturalization,
    boardRelations: _boardRelations,
  );

  int _valueOf(Department dept) => investmentIn(_current, dept);

  void _set(Department dept, double rawLevel) {
    // Whole levels only, and never more than the balance left once the other
    // departments are paid for.
    final room = widget.available - (_allocated - _valueOf(dept));
    final level = affordableLevel(
      wanted: rawLevel.round(),
      room: room,
      price: _price,
      max: FederationFinance.maxLevels(dept),
    );
    final euros = level * _price;
    setState(() {
      switch (dept) {
        case Department.youth:
          _youth = euros;
        case Department.commercial:
          _commercial = euros;
        case Department.medical:
          _medical = euros;
        case Department.naturalization:
          _naturalization = euros;
        case Department.boardRelations:
          _boardRelations = euros;
      }
    });
    widget.onChanged(_current);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l.federationUnallocated, style: AppTypography.labelSmall),
            const Spacer(),
            Text(
              formatEuros(_remaining),
              style: AppTypography.labelMedium.copyWith(
                color: _remaining > 0
                    ? AppColors.positive
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _slider(Department.youth, _youth, enabled: widget.youthEnabled),
        _slider(Department.commercial, _commercial),
        _slider(Department.medical, _medical),
        _slider(Department.naturalization, _naturalization),
        _slider(Department.boardRelations, _boardRelations),
      ],
    );
  }

  Widget _slider(Department dept, int value, {bool enabled = true}) {
    final l = AppLocalizations.of(context);
    // A FIXED scale per slider (the department's own levels) so moving one
    // slider never shifts the others' thumbs: the total is enforced on change
    // in [_set] instead.
    final levels = FederationFinance.maxLevels(dept);
    final level = (value ~/ _price).clamp(0, levels);
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  departmentLabel(l, dept),
                  style: AppTypography.bodyMedium,
                ),
              ),
              Text(
                l.deptLevelCost(level, formatEuros(value)),
                style: AppTypography.labelMedium.copyWith(
                  color: value > 0
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Slider(
            value: level.toDouble(),
            max: levels.toDouble(),
            divisions: levels,
            onChanged: enabled ? (v) => _set(dept, v) : null,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departmentBlurb(l, dept),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                if (widget.showEffects) ...[
                  const SizedBox(height: 2),
                  // What this money actually buys, live as the slider moves.
                  // The effect used to be legible only on the finances
                  // screen's impact table — a screen away from the decision.
                  Text(
                    value <= 0
                        ? AppLocalizations.of(context).deptEffectNone
                        : DepartmentEffect.describe(
                            AppLocalizations.of(context),
                            dept,
                            value,
                          ),
                    style: AppTypography.labelSmall.copyWith(
                      color: value > 0
                          ? AppColors.positive
                          : AppColors.onSurfaceVariant,
                      fontWeight: value > 0 ? FontWeight.w700 : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// What [alloc] puts into [dept].
int investmentIn(FederationInvestment alloc, Department dept) => switch (dept) {
  Department.youth => alloc.youth,
  Department.commercial => alloc.commercial,
  Department.medical => alloc.medical,
  Department.naturalization => alloc.naturalization,
  Department.boardRelations => alloc.boardRelations,
};

/// The level a department actually gets when the slider asks for [wanted]:
/// never above its [max], and never more levels than the [room] left in the
/// budget pays for at [price] each.
int affordableLevel({
  required int wanted,
  required int room,
  required int price,
  required int max,
}) {
  if (room < price) return 0;
  final affordable = room ~/ price;
  return wanted.clamp(0, affordable < max ? affordable : max);
}
