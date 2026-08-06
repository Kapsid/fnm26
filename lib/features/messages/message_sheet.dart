import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The icon and colour a message category is shown with. Shared so a message
/// looks the same whether it pops up over the hub or is opened in the inbox.
({IconData icon, Color color}) messageStyle(String category) =>
    switch (category) {
      'triumph' => (icon: Icons.emoji_events, color: AppColors.primary),
      'champion' => (
        icon: Icons.emoji_events_outlined,
        color: AppColors.onSurfaceVariant,
      ),
      'qualify' => (icon: Icons.flight_takeoff, color: AppColors.positive),
      'eliminated' => (icon: Icons.flight_land, color: AppColors.error),
      'draw' => (icon: Icons.casino, color: AppColors.primary),
      'aging' => (icon: Icons.trending_up, color: AppColors.positive),
      'youth' => (icon: Icons.school_outlined, color: AppColors.primary),
      'ranking' => (icon: Icons.leaderboard, color: AppColors.primary),
      'milestone' => (icon: Icons.military_tech, color: AppColors.primary),
      'award' => (icon: Icons.workspace_premium, color: AppColors.primary),
      'retirement' => (
        icon: Icons.waving_hand_outlined,
        color: AppColors.onSurfaceVariant,
      ),
      'halloffame' => (icon: Icons.star_rounded, color: AppColors.primary),
      'discipline' => (icon: Icons.dangerous, color: AppColors.error),
      'injury' => (icon: Icons.healing, color: AppColors.warning),
      'board' => (icon: Icons.gavel, color: AppColors.warning),
      'naturalize' => (
        icon: Icons.how_to_reg_rounded,
        color: AppColors.positive,
      ),
      'cycle' => (icon: Icons.flag_rounded, color: AppColors.primary),
      'transfer' => (icon: Icons.swap_horiz_rounded, color: AppColors.primary),
      'record' => (icon: Icons.leaderboard_rounded, color: AppColors.primary),
      _ => (icon: Icons.mail_outline, color: AppColors.onSurfaceVariant),
    };

/// One message, full text, for a popup or the inbox.
///
/// [action] adds a confirming button — the hub uses it to step through a run of
/// messages ("Next", then "Done"); the inbox leaves it off and lets the sheet
/// be dismissed.
class MessageSheet extends StatelessWidget {
  const MessageSheet({required this.message, this.action, super.key});

  final MessageItem message;
  final ({String label, VoidCallback onPressed})? action;

  @override
  Widget build(BuildContext context) {
    final style = messageStyle(message.category);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(style.icon, color: style.color, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    message.title,
                    style: AppTypography.headlineMedium,
                  ),
                ),
                Text(
                  '${message.year}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // The yearly squad report is a table, not a paragraph — a run of
            // "A 78→82, B 74→76, …" was unreadable once more than a couple of
            // players moved. Anything else is plain text.
            if (decodeSquadDevReport(message.body) case final report?) ...[
              if (report.note case final note?) ...[
                Text(
                  note,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              SquadDevTable(rows: report.rows),
            ]
            else
              Text(message.body, style: AppTypography.bodyMedium),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: action!.label,
                onPressed: action!.onPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
