import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/squad/grievances.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// What a player has come to say.
String grievanceText(AppLocalizations l, Grievance g) => switch (g.kind) {
  GrievanceKind.gameTime => l.grievanceGameTime(g.playerName),
  GrievanceKind.squadPlace => l.grievanceSquadPlace(g.playerName),
  GrievanceKind.role => l.grievanceRole(g.playerName),
};

/// How an answer reads.
String grievanceToneLabel(AppLocalizations l, GrievanceTone t) => switch (t) {
  GrievanceTone.reassure => l.grievanceReassure,
  GrievanceTone.honest => l.grievanceHonest,
  GrievanceTone.dismiss => l.grievanceDismiss,
};

/// A player asking where he stands, and the three ways to answer him.
///
/// Modelled on the press sheet, because it is the same kind of decision: every
/// answer trades the dressing room against the manager's own standing, and
/// there is no reply that pleases everyone.
class GrievanceSheet extends ConsumerStatefulWidget {
  const GrievanceSheet({
    required this.careerId,
    required this.grievance,
    super.key,
  });

  final int careerId;
  final Grievance grievance;

  @override
  ConsumerState<GrievanceSheet> createState() => _GrievanceSheetState();
}

class _GrievanceSheetState extends ConsumerState<GrievanceSheet> {
  /// Set while an answer is being written: a second tap (another tone, or
  /// the same one twice) would record a second answer, and the dressing room
  /// and the board would count it twice.
  bool _answering = false;

  Future<void> _answer(GrievanceTone tone) async {
    if (_answering) return;
    _answering = true;
    final service = ref.read(grievanceServiceProvider);
    final navigator = Navigator.of(context);
    try {
      await service.answer(widget.careerId, widget.grievance, tone);
      if (mounted) navigator.pop();
    } finally {
      if (mounted) _answering = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final grievance = widget.grievance;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.grievanceTitle,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(grievanceText(l, grievance), style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            for (final tone in GrievanceTone.values) ...[
              OutlinedButton(
                onPressed: () => _answer(tone),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: AppColors.onSurface,
                  side: const BorderSide(color: AppColors.outlineVariant),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(grievanceToneLabel(l, tone)),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}
