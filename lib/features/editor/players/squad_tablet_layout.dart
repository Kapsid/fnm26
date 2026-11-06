part of 'squad_screen.dart';

/// A squad on a landscape tablet: the list on the left, the picked player's
/// editor on the right. Undo, Add player and (for the picked player) the
/// menu with Delete sit in the header.
class _SquadTabletLayout extends StatelessWidget {
  const _SquadTabletLayout({
    required this.state,
    required this.title,
    required this.view,
    required this.onUndo,
  });

  final _SquadScreenState state;
  final String title;
  final _SquadView view;
  final VoidCallback? onUndo;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final picked = state._picked;
    final shown = picked == null
        ? null
        : view.squad.where((p) => p.id == picked).firstOrNull;
    return EditorFrame(
      tablet: true,
      tabletKey: SquadScreen.tabletLayoutKey,
      title: title,
      onBack: state._back,
      actions: [
        TextButton.icon(
          key: SquadScreen.undoKey,
          onPressed: onUndo,
          icon: const Icon(Icons.undo),
          label: Text(l.editorUndo),
        ),
        FilledButton.icon(
          key: SquadScreen.addKey,
          onPressed: () => state._add(tablet: true),
          // The app's filled buttons stretch to the width they are given;
          // in the header there is no width to give.
          style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          icon: const Icon(Icons.person_add_alt_1),
          label: Text(l.editorSquadAdd),
        ),
        if (shown != null)
          EditorDeleteMenu(
            menuKey: SquadScreen.menuKey,
            deleteKey: SquadScreen.deleteKey,
            onDelete: () => state._remove(shown),
          ),
      ],
      body: MasterDetail(
        initialFraction: 0.42,
        minDetailWidth: 420,
        master: _SquadList(
          view: view,
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          picked: shown?.id,
          onTap: (p) => state._open(p.id, tablet: true),
          onRemove: state._remove,
        ),
        detail: shown == null
            ? null
            : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: PlayerEditForm(
                  key: ValueKey('editorSquad.form.${shown.id}'),
                  packId: state._id,
                  nationId: state._nation,
                  playerId: shown.id,
                  onRemoved: (p) {
                    state._unpick();
                    showRemovedSnackBar(context, l, p, state._editor);
                  },
                ),
              ),
        placeholder: EditorMessage(
          l.editorPickPlayer,
          icon: Icons.touch_app_outlined,
        ),
      ),
    );
  }
}
