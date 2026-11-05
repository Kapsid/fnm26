part of 'editor_list_screen.dart';

/// The editor list on a landscape tablet: the tablet header with Import and
/// New on its right, over the phone's cards laid out in as many columns as
/// fit.
class _EditorListTabletLayout extends StatelessWidget {
  const _EditorListTabletLayout({required this.state, required this.list});

  final _EditorListScreenState state;
  final Widget list;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: EditorListScreen.tabletLayoutKey,
      title: l.editorTitle,
      onBack: () => context.go(Routes.home),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state._creating) ...[
            Text(
              l.editorCreating,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          OutlinedButton.icon(
            key: EditorListScreen.importKey,
            onPressed: state._busy ? null : state._import,
            icon: const Icon(Icons.file_download_outlined),
            label: Text(l.editorImport),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 220,
            child: PrimaryButton(
              key: EditorListScreen.newKey,
              label: l.editorNew,
              icon: Icons.add,
              height: 44,
              isLoading: state._creating,
              onPressed: state._busy ? null : state._new,
            ),
          ),
        ],
      ),
      child: list,
    );
  }
}
