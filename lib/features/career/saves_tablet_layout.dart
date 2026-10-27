part of 'saves_screen.dart';

/// The saves on a landscape tablet: every save in a sortable table on the
/// left with the screen's other actions under it; the picked save's career
/// on the right, with what can be done to it (open, back up, delete). Every
/// action is the phone's own ([_SavesScreenState._continue], [_shareCareer],
/// [_SavesScreenState._confirmDelete], [_SavesScreenState._actions]), and the
/// pick is the State's, so a resize keeps it.
class _SavesTabletLayout extends StatelessWidget {
  const _SavesTabletLayout({
    required this.state,
    required this.savesAsync,
    required this.nationsById,
    required this.premium,
    required this.limit,
    required this.lockedIds,
  });

  final _SavesScreenState state;
  final AsyncValue<List<Career>> savesAsync;
  final Map<int, Nation> nationsById;
  final bool premium;
  final int? limit;

  /// The saves that need Pro to be opened.
  final Set<int> lockedIds;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cap = limit;
    return Scaffold(
      key: SavesScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: savesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(l.careerCouldNotLoadSaves('$e'))),
            data: (saves) {
              final full = cap != null && saves.length >= cap;
              // The pick, or the first save when there is none or it has
              // just been deleted: the pane never shows a save that is gone.
              final selected =
                  saves.where((s) => s.id == state._selectedId).firstOrNull ??
                  saves.firstOrNull;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabletScreenHeader(
                    title: l.savesTitle,
                    onBack: () => context.go(Routes.home),
                    trailing: Text(
                      cap == null
                          ? l.careerSlotsUsed(saves.length)
                          : l.careerSlotsCount(saves.length, cap),
                      style: AppTypography.labelMedium,
                    ),
                  ),
                  Expanded(
                    child: MasterDetail(
                      initialFraction: 0.5,
                      minFraction: 0.4,
                      minDetailWidth: 380,
                      master: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: PanelBox(
                              child: saves.isEmpty
                                  ? state._empty(context)
                                  : DataGrid<Career>(
                                      rows: saves,
                                      columnSets: [
                                        _saveColumns(
                                          context,
                                          l,
                                          nationsById,
                                          lockedIds,
                                        ),
                                      ],
                                      selected: selected,
                                      onSelect: state._select,
                                    ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          state._actions(
                            context,
                            saves: saves,
                            full: full,
                            premium: premium,
                          ),
                        ],
                      ),
                      detail: PanelBox(
                        child: selected == null
                            ? MasterDetailPlaceholder(text: l.careerNoSavesYet)
                            : _SavePane(
                                // A new save is a new pane: no scroll or
                                // busy spinner carried over.
                                key: ValueKey(selected.id),
                                state: state,
                                save: selected,
                                nation: nationsById[selected.nationId],
                                locked: lockedIds.contains(selected.id),
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// The saves table's one view: whose nation, which manager, how far into
/// the game, and when last played.
GridColumnSet<Career> _saveColumns(
  BuildContext context,
  AppLocalizations l,
  Map<int, Nation> nationsById,
  Set<int> lockedIds,
) {
  String name(Career c) =>
      nationsById[c.nationId]?.name ?? l.careerUnknownNation;
  return GridColumnSet<Career>(
    id: 'overview',
    label: l.gridViewOverview,
    columns: [
      GridColumn<Career>(
        id: 'nation',
        label: l.gridColNation,
        flex: 3,
        sortKey: name,
        cell: (c) => Row(
          children: [
            FlagDisc(nationsById[c.nationId]?.code ?? '??', size: 22),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                name(c),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (lockedIds.contains(c.id)) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.lock_rounded,
                size: 14,
                color: AppColors.warning,
              ),
            ],
          ],
        ),
      ),
      GridColumn<Career>(
        id: 'manager',
        label: l.gridColManager,
        flex: 2,
        sortKey: (c) => c.managerName,
        cell: (c) => Text(c.managerName),
      ),
      GridColumn<Career>(
        id: 'date',
        label: l.gridColDate,
        width: 110,
        sortKey: (c) => c.inGameDate,
        cell: (c) => Text(AppDate.monthYear(context, c.inGameDate)),
      ),
      GridColumn<Career>(
        id: 'lastPlayed',
        label: l.gridColLastPlayed,
        width: 110,
        numeric: true,
        sortKey: (c) => c.lastPlayedAt ?? DateTime(0),
        cell: (c) => Text(
          c.lastPlayedAt == null ? '' : agoShort(c.lastPlayedAt!),
        ),
      ),
    ],
  );
}

/// The picked save: who and where, the three things to do with it, and its
/// career summary under them.
class _SavePane extends StatelessWidget {
  const _SavePane({
    required this.state,
    required this.save,
    required this.nation,
    required this.locked,
    super.key,
  });

  final _SavesScreenState state;
  final Career save;
  final Nation? nation;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final played = playedLabel(l, save.playedSeconds);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: [
              FlagDisc(nation?.code ?? '??', size: 44, highlighted: true),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nation?.name ?? l.careerUnknownNation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium,
                    ),
                    Text(
                      '${save.managerName} · '
                      '${AppDate.monthYear(context, save.inGameDate)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (played != null)
                      Text(
                        played,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    if (locked)
                      const SaveLockedNote(key: SaveTile.lockedBadgeKey),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(
                width: 180,
                child: PrimaryButton(
                  key: SavesScreen.continueKey,
                  label: l.hubContinue,
                  icon: locked ? Icons.lock_rounded : Icons.play_arrow_rounded,
                  onPressed: () => state._continue(save),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              // The Builder hands the share sheet this button's own rect
              // (an iPad's popover points at it).
              Builder(
                builder: (button) => TextButton.icon(
                  key: SavesScreen.exportKey,
                  onPressed: state._busy
                      ? null
                      : () => state._run(
                          () => _shareCareer(
                            context,
                            state.ref,
                            save.id,
                            origin: shareOriginOf(button),
                          ),
                        ),
                  icon: state._busy
                      ? const _Spinner()
                      : const Icon(Icons.ios_share_rounded, size: 18),
                  label: Text(l.careerExportSave),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                key: SavesScreen.deleteKey,
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                onPressed: () => state._confirmDelete(
                  context,
                  state.ref,
                  nation?.name ?? l.careerThisSave,
                  save.id,
                ),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: Text(l.careerDelete),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: CareerSummaryView(
            key: ValueKey(('save', save.id)),
            careerId: save.id,
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
