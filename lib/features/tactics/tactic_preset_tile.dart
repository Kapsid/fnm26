import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// One saved tactic preset as a list row: the name, its shape, and a tap that
/// applies it. Shared by the pre-match sheet (which can also delete) and the
/// in-match editor (apply only), so both read the same.
class TacticPresetTile extends StatelessWidget {
  const TacticPresetTile({
    required this.preset,
    required this.onApply,
    super.key,
    this.onDelete,
    this.onSaveToLibrary,
  });

  final TacticPreset preset;
  final VoidCallback onApply;

  /// Null hides the delete button.
  final VoidCallback? onDelete;

  /// Copies the preset into the cross-save tactics library; null hides it.
  final VoidCallback? onSaveToLibrary;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.bookmark, color: AppColors.primary),
      title: Text(preset.name, style: AppTypography.bodyMedium),
      subtitle: Text(
        preset.formation.label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: onDelete == null && onSaveToLibrary == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onSaveToLibrary case final save?)
                  IconButton(
                    icon: const Icon(
                      Icons.library_add_outlined,
                      color: AppColors.onSurfaceVariant,
                    ),
                    tooltip: AppLocalizations.of(context).tacticsSaveToLibrary,
                    onPressed: save,
                  ),
                if (onDelete case final delete?)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.onSurfaceVariant,
                    ),
                    onPressed: delete,
                  ),
              ],
            ),
      onTap: onApply,
    );
  }
}
