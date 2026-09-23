import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
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

/// A three-department allocation editor: sliders for Youth, Commercial and
/// Medical that together cannot exceed the available balance. Reports the
/// current split on every change. Youth can be disabled (e.g. the opening
/// cycle, which has no academy intake yet).
class InvestmentEditor extends StatefulWidget {
  const InvestmentEditor({
    required this.available,
    required this.initial,
    required this.onChanged,
    this.youthEnabled = true,
    super.key,
  });

  /// The most that can be allocated across all departments combined.
  final int available;
  final FederationInvestment initial;
  final ValueChanged<FederationInvestment> onChanged;
  final bool youthEnabled;

  @override
  State<InvestmentEditor> createState() => _InvestmentEditorState();
}

class _InvestmentEditorState extends State<InvestmentEditor> {
  late int _youth = widget.initial.youth;
  late int _commercial = widget.initial.commercial;
  late int _medical = widget.initial.medical;
  late int _naturalization = widget.initial.naturalization;
  late int _boardRelations = widget.initial.boardRelations;

  /// Slider granularity — €500k steps.
  static const _step = 500000;

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

  void _set(Department dept, double raw) {
    // Round to the step, then cap so the departments never exceed the balance.
    final others =
        _allocated -
        switch (dept) {
          Department.youth => _youth,
          Department.commercial => _commercial,
          Department.medical => _medical,
          Department.naturalization => _naturalization,
          Department.boardRelations => _boardRelations,
        };
    final room = widget.available - others;
    final capped = clampDepartment(raw: raw, room: room, step: _step);
    setState(() {
      switch (dept) {
        case Department.youth:
          _youth = capped;
        case Department.commercial:
          _commercial = capped;
        case Department.medical:
          _medical = capped;
        case Department.naturalization:
          _naturalization = capped;
        case Department.boardRelations:
          _boardRelations = capped;
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
    // A FIXED scale per slider (the department cap, or the whole balance if
    // smaller) so moving one slider never shifts the others' thumbs — the
    // total is instead enforced by clamping on change in [_set].
    final cap = FederationFinance.maxInvestPerDepartment < widget.available
        ? FederationFinance.maxInvestPerDepartment
        : widget.available;
    final max = (cap < _step ? _step : cap).toDouble();
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(dept.label, style: AppTypography.bodyMedium),
              ),
              Text(
                formatEuros(value),
                style: AppTypography.labelMedium.copyWith(
                  color: value > 0
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Slider(
            value: value.toDouble().clamp(0, max),
            max: max,
            onChanged: enabled ? (v) => _set(dept, v) : null,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dept.blurb,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                // What this money actually buys, live as the slider moves.
                // The effect used to be legible only on the finances screen's
                // impact table — a screen away from the decision.
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
            ),
          ),
        ],
      ),
    );
  }
}

/// What a department actually takes when the slider is dragged to [raw], given
/// there is [room] left in the budget.
///
/// Rounds DOWN to [step] like the slider does, except at the very top, where
/// it takes the exact remainder instead.
///
/// Without that exception a budget that is not a whole number of steps could
/// never be finished: the balance is whatever the federation happens to hold,
/// so a manager dragging every slider to its limit was still left staring at a
/// few hundred thousand — or, with an odd balance and five roundings, rather
/// more — that no slider would accept. Money you can see and cannot assign
/// reads as a bug whatever the arithmetic behind it, and the screen refuses to
/// confirm until the balance is spent, so it could also strand the manager on
/// the one screen he is forced to finish.
int clampDepartment({required double raw, required int room, required int step}) {
  if (room <= 0) return 0;
  final rounded = raw ~/ step * step;
  return rounded >= room ? room : rounded.clamp(0, room);
}
