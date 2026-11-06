part of 'squad_screen.dart';

/// A nation's players on a landscape tablet: the Squad and Pool tabs with
/// the list on the left, the picked player's editor on the right. Undo, Add
/// player (to the tab on show) and (for the picked player) the menu with
/// Delete sit in the header.
class _SquadTabletLayout extends StatelessWidget {
  const _SquadTabletLayout({
    required this.state,
    required this.title,
    required this.view,
    required this.poolView,
    required this.tabs,
    required this.onUndo,
  });

  final _SquadScreenState state;
  final String title;
  final _SquadView view;
  final _PoolView poolView;
  final Widget tabs;
  final VoidCallback? onUndo;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final onPool = state._onPool;
    final picked = state._picked;
    final pickedPool = state._pickedPool;
    // The picked player, while his tab is on show.
    final shown = picked == null || pickedPool != onPool
        ? null
        : (pickedPool ? poolView.pool ?? const <PackPlayer>[] : view.squad)
              .where((p) => p.id == picked)
              .firstOrNull;
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
            onDelete: () => pickedPool
                ? state._removeFromPool(shown)
                : state._remove(shown),
          ),
      ],
      body: MasterDetail(
        initialFraction: 0.42,
        minDetailWidth: 420,
        master: Column(
          children: [
            tabs,
            Expanded(
              child: onPool
                  ? _PoolPane(
                      state: state,
                      view: poolView,
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      picked: shown?.id,
                      onTap: (p) => state._open(p.id, tablet: true, pool: true),
                    )
                  : _SquadList(
                      view: view,
                      padding: const EdgeInsets.only(
                        top: AppSpacing.sm,
                        bottom: AppSpacing.lg,
                      ),
                      picked: shown?.id,
                      onTap: (p) =>
                          state._open(p.id, tablet: true, pool: false),
                      onRemove: state._remove,
                    ),
            ),
          ],
        ),
        detail: shown == null
            ? null
            : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: PlayerEditForm(
                  key: ValueKey(
                    'editorSquad.form.${pickedPool ? 'pool' : 'squad'}'
                    '.${shown.id}',
                  ),
                  packId: state._id,
                  nationId: state._nation,
                  playerId: shown.id,
                  pool: pickedPool,
                  onRemoved: (p) {
                    state._unpick();
                    showRemovedSnackBar(
                      context,
                      l,
                      p,
                      state._editor,
                      pool: pickedPool,
                    );
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
