import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';

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

  /// Slider granularity — €500k steps.
  static const _step = 500000;

  int get _allocated => _youth + _commercial + _medical + _naturalization;
  int get _remaining => widget.available - _allocated;

  FederationInvestment get _current => (
        youth: _youth,
        commercial: _commercial,
        medical: _medical,
        naturalization: _naturalization,
      );

  void _set(Department dept, double raw) {
    // Round to the step, then cap so the departments never exceed the balance.
    final others = _allocated -
        switch (dept) {
          Department.youth => _youth,
          Department.commercial => _commercial,
          Department.medical => _medical,
          Department.naturalization => _naturalization,
        };
    final capped = (raw ~/ _step * _step).clamp(0, widget.available - others);
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
      }
    });
    widget.onChanged(_current);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('UNALLOCATED', style: AppTypography.labelSmall),
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
            child: Text(
              dept.blurb,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
