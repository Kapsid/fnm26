import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/editor_ui.dart';
import 'package:fnm/features/editor/pack_issue_text.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:go_router/go_router.dart';

/// A database section's screen ([section] of pack [packId], on [nationId]
/// for a per-nation one).
///
/// A stand-in until the section editors land: the routes, and every jump
/// from the database home into them, are already the real ones.
class EditorSectionScreen extends ConsumerWidget {
  const EditorSectionScreen({
    required this.section,
    required this.packId,
    this.nationId,
    super.key,
  });

  static const Key tabletLayoutKey = Key('editorSection.tabletLayout');

  final EditorSection section;
  final int packId;
  final int? nationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(packEditorProvider(packId));
    final editor = ref.watch(packEditorProvider(packId).notifier);
    final pack = async.valueOrNull;
    final nationName = pack == null || nationId == null
        ? null
        : packNationName(pack, {
            for (final n in editor.world) n.id: n,
          }, nationId!);
    final title = sectionTitle(l, section);
    void back() => context.go(editorPackLocation(packId));

    final body = Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sectionIcon(section), size: 48, color: AppColors.primary),
            const SizedBox(height: AppSpacing.md),
            if (nationName != null) ...[
              Text(
                nationName,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            Text(
              l.editorSectionSoon,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );

    if (useTabletLayout(context, ref)) {
      return TabletPage(
        scaffoldKey: tabletLayoutKey,
        title: title,
        onBack: back,
        child: body,
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: back,
        ),
        title: Text(
          title,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(top: false, child: body),
    );
  }
}
