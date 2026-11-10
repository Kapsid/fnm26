part of 'pack_home_screen.dart';

/// A database's home on a landscape tablet: the ready bar over the whole
/// list of what is missing on the left, the sections as a grid on the
/// right. The editor's language and Undo sit in the header.
class _PackHomeTabletLayout extends StatelessWidget {
  const _PackHomeTabletLayout({
    required this.state,
    required this.pack,
    required this.view,
    required this.onUndo,
  });

  final _PackHomeScreenState state;
  final WorldPack pack;
  final _PackView view;
  final VoidCallback? onUndo;

  static const double _sideWidth = 400;
  static const double _minTileWidth = 200;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: PackHomeScreen.tabletLayoutKey,
      title: ProfanityFilter.mask(pack.name),
      onBack: state._back,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.sm,
        children: [
          const EditorLanguageChip(),
          TextButton.icon(
            key: PackHomeScreen.undoKey,
            onPressed: onUndo,
            icon: const Icon(Icons.undo),
            label: Text(l.editorUndo),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: _sideWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ReadyCard(view: view),
                if (view.notes.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Panel(
                    title: l.editorNotesTitle,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      children: [
                        for (final e in view.notes.entries)
                          _LanguageNote(
                            language: e.key,
                            count: e.value,
                            onRemove: () => state._removeLanguage(e.key),
                          ),
                      ],
                    ),
                  ),
                ],
                if (view.issues.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: Panel(
                      title: l.editorMissingTitle,
                      expand: true,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: ListView.builder(
                        itemCount: view.issues.length,
                        itemBuilder: (context, i) => _IssueRow(
                          index: i,
                          issue: view.issues[i],
                          onTap: () => state._openIssue(view, i),
                          onRemove: state._remover(view, i),
                          removeAll: state._removeAll(view, pack, i),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: LayoutBuilder(
              builder: (context, box) {
                const gap = AppSpacing.sm;
                final perRow = (box.maxWidth / _minTileWidth).floor().clamp(
                  2,
                  4,
                );
                final width = (box.maxWidth - gap * (perRow - 1)) / perRow;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _SectionHeader(l.editorSectionsTitle),
                      ),
                      Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          for (final s in EditorSection.onHome)
                            SizedBox(
                              width: width,
                              height: _SectionTile.height + 8,
                              child: _SectionTile(
                                section: s,
                                facts: view.sections[s]!,
                                onTap: () => state._open(s),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const _CommunityRow(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
