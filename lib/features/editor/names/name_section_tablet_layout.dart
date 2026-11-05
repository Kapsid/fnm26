part of 'name_section_screen.dart';

/// A name section on a landscape tablet: the search and the list on the
/// left, the picked row's editor on the right. Undo sits in the header.
class _NameSectionTabletLayout extends StatelessWidget {
  const _NameSectionTabletLayout({
    required this.state,
    required this.title,
    required this.view,
    required this.picked,
    required this.world,
    required this.onUndo,
  });

  final _NameSectionScreenState state;
  final String title;
  final _NameView view;
  final NameEntry? picked;
  final List<Nation> world;
  final VoidCallback? onUndo;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final shown = picked;
    return EditorFrame(
      tablet: true,
      tabletKey: NameSectionScreen.tabletLayoutKey,
      title: title,
      onBack: state._back,
      actions: [
        TextButton.icon(
          key: NameSectionScreen.undoKey,
          onPressed: onUndo,
          icon: const Icon(Icons.undo),
          label: Text(l.editorUndo),
        ),
      ],
      body: MasterDetail(
        initialFraction: 0.45,
        minDetailWidth: 380,
        master: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SearchField(state: state),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _NameList(
                state: state,
                view: view,
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                picked: shown?.key,
                chevrons: false,
                onTap: (e) => state._open(e, tablet: true, world: world),
              ),
            ),
          ],
        ),
        detail: shown == null
            ? null
            // Top, not centred: the split's row hands the detail a loose
            // height.
            : Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: NameEditForm(
                      key: ValueKey('editorNames.form.${shown.key}'),
                      packId: state._id,
                      section: state._section,
                      entry: shown,
                      world: world,
                    ),
                  ),
                ),
              ),
        placeholder: EditorMessage(
          l.editorNamesPick,
          icon: Icons.touch_app_outlined,
        ),
      ),
    );
  }
}
