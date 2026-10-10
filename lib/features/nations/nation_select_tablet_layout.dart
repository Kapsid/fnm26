part of 'nation_select_screen.dart';

/// The nation pick on a landscape tablet: a bar with the way back, the title,
/// the search and the two other ways in; the confederations as chips with
/// their counts; every nation as a tile (rank, strength, flag, name, best
/// player); and the previewed nation beside them. A tap only previews; Manage
/// takes the job. The search, the confederation, Random team and From the
/// bottom are the phone's own (the same providers and functions), and the
/// preview is the screen State's, so a resize keeps it.
class _NationSelectTabletLayout extends ConsumerStatefulWidget {
  const _NationSelectTabletLayout({required this.state});

  final _NationSelectScreenState state;

  @override
  ConsumerState<_NationSelectTabletLayout> createState() =>
      _NationSelectTabletLayoutState();
}

class _NationSelectTabletLayoutState
    extends ConsumerState<_NationSelectTabletLayout> {
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState();
    // Seeded from the query, so a window crossing 1000 px keeps what was
    // typed on either side of it.
    _search = TextEditingController(text: ref.read(nationSearchProvider));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final nationsAsync = ref.watch(nationsProvider);
    final strengths =
        ref.watch(nationStrengthsProvider).valueOrNull ??
        const <int, NationStrength>{};
    final selectedConf = ref.watch(selectedConfederationProvider);
    final query = ref.watch(nationSearchProvider).trim().toLowerCase();
    return Scaffold(
      key: NationSelectScreen.tabletLayoutKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TabletTopBar(
              search: _search,
              onSearch: (v) =>
                  ref.read(nationSearchProvider.notifier).state = v,
              onRandom: () => _startRandom(context, nationsAsync.valueOrNull),
              onBottom: () => context.go(Routes.startFromBottom),
            ),
            Expanded(
              child: nationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    l.nationsCouldNotLoadNations(e.toString()),
                    textAlign: TextAlign.center,
                  ),
                ),
                data: (nations) {
                  final shown = _filterNations(nations, selectedConf, query);
                  // The pick while it is on show, else the first tile: the
                  // pane is never empty while there are tiles.
                  final previewed =
                      shown
                          .where((n) => n.id == widget.state._previewId)
                          .firstOrNull ??
                      shown.firstOrNull;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _ConfederationChips(
                              nations: nations,
                              selected: selectedConf,
                              onSelect: (c) =>
                                  ref
                                          .read(
                                            selectedConfederationProvider
                                                .notifier,
                                          )
                                          .state =
                                      c,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.lg,
                                0,
                                AppSpacing.lg,
                                AppSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    l
                                        .nationsShownCount(shown.length)
                                        .toUpperCase(),
                                    style: TabletText.sectionLabel,
                                  ),
                                  const Spacer(),
                                  Text(
                                    l.nationsSortedByRank.toUpperCase(),
                                    style: TabletText.sectionLabel,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: shown.isEmpty
                                  ? Center(child: Text(l.nationsNoMatch))
                                  : GridView.builder(
                                      key: NationSelectScreen.gridKey,
                                      padding: const EdgeInsets.fromLTRB(
                                        AppSpacing.lg,
                                        AppSpacing.xs,
                                        AppSpacing.lg,
                                        AppSpacing.lg,
                                      ),
                                      gridDelegate: _tileGrid,
                                      itemCount: shown.length,
                                      itemBuilder: (context, i) {
                                        final n = shown[i];
                                        return _NationTile(
                                          key: NationSelectScreen.tileKey(n.id),
                                          nation: n,
                                          strength: strengths[n.id],
                                          selected: n.id == previewed?.id,
                                          onTap: () =>
                                              widget.state._preview(n.id),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: AppColors.outlineVariant,
                      ),
                      SizedBox(
                        width: 340,
                        child: Material(
                          color: AppColors.surfaceContainerLow,
                          child: previewed == null
                              ? MasterDetailPlaceholder(text: l.nationsNoMatch)
                              : _PreviewPane(nation: previewed),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The tiles: as many 180 px columns as fit, each tile 172 tall.
const _tileGrid = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 180,
  mainAxisExtent: 172,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
);

/// The bar across the top: back, the title, the search and the two other
/// ways into a career.
class _TabletTopBar extends StatelessWidget {
  const _TabletTopBar({
    required this.search,
    required this.onSearch,
    required this.onRandom,
    required this.onBottom,
  });

  final TextEditingController search;
  final ValueChanged<String> onSearch;
  final VoidCallback onRandom;
  final VoidCallback onBottom;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          IconButton(
            key: NationSelectScreen.backKey,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(Routes.home),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.nationsNationalLevel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.sectionLabel.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  l.nationsSelectHeading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.screenTitle.copyWith(fontSize: 19),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 260,
            child: TextField(
              controller: search,
              onChanged: onSearch,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurface,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: l.nationsSearchHint,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 18,
                  color: AppColors.outline,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _BarModeButton(
            icon: Icons.casino_outlined,
            label: l.nationsRandomTeam,
            onTap: onRandom,
          ),
          const SizedBox(width: AppSpacing.sm),
          _BarModeButton(
            icon: Icons.trending_down_rounded,
            label: l.nationsFromTheBottom,
            onTap: onBottom,
          ),
        ],
      ),
    );
  }
}

/// The phone's [_ModeButton] at its own width, for a row it shares.
class _BarModeButton extends StatelessWidget {
  const _BarModeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 16),
    label: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.labelSmall,
    ),
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.outlineVariant),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      minimumSize: const Size(0, 40),
    ),
  );
}

/// The confederations as chips, each with how many nations it holds.
class _ConfederationChips extends StatelessWidget {
  const _ConfederationChips({
    required this.nations,
    required this.selected,
    required this.onSelect,
  });

  final List<Nation> nations;
  final Confederation selected;
  final ValueChanged<Confederation> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final counts = {for (final c in Confederation.values) c: 0};
    for (final n in nations) {
      counts[n.confederation] = counts[n.confederation]! + 1;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final c in Confederation.values)
            _ConfederationChip(
              key: NationSelectScreen.chipKey(c),
              label: confederationLabel(l, c).toUpperCase(),
              count: counts[c]!,
              active: c == selected,
              onTap: () => onSelect(c),
            ),
        ],
      ),
    );
  }
}

class _ConfederationChip extends StatelessWidget {
  const _ConfederationChip({
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
    super.key,
  });

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlAll,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: active
                ? AppColors.secondaryContainer
                : AppColors.surfaceContainer,
            borderRadius: AppRadii.xlAll,
            border: Border.all(
              color: active ? AppColors.primary : AppColors.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: active
                      ? AppColors.onSecondaryContainer
                      : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: TabletText.cellNumeric.copyWith(
                  fontSize: 10,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One nation as a tile: the world rank top left, the strength top right,
/// the flag, the name, and the best player's position and rating.
class _NationTile extends StatelessWidget {
  const _NationTile({
    required this.nation,
    required this.strength,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Nation nation;
  final NationStrength? strength;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = strength;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdAll,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadii.mdAll,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: selected
                    ? const [
                        AppColors.surfaceContainerHighest,
                        AppColors.surfaceContainerHigh,
                      ]
                    : const [
                        AppColors.surfaceContainerHigh,
                        AppColors.surfaceContainerLow,
                      ],
              ),
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : AppColors.surfaceContainerHighest,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 9,
                  child: Text(
                    '#${nation.ranking}',
                    style: TabletText.cellNumeric.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (s != null)
                  Positioned(
                    top: 10,
                    right: 9,
                    child: StrengthMeter(tier: s.tier),
                  ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 26, 10, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlagDisc(nation.code, size: 56, highlighted: selected),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          nation.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                        if (s != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            l.nationsStarTile(
                              s.best.position.label,
                              s.best.overall,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The previewed nation and the one button that takes its job.
class _PreviewPane extends StatelessWidget {
  const _PreviewPane({required this.nation});

  final Nation nation;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      key: NationSelectScreen.previewKey,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              // A new nation is a new preview: no scroll offset carried over.
              key: ValueKey(('preview', nation.id)),
              child: NationPreview(nation: nation),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            key: NationSelectScreen.manageKey,
            label: l.nationsManage(nation.name),
            icon: Icons.play_arrow_rounded,
            onPressed: () =>
                context.go('${Routes.newGame}?nationId=${nation.id}'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.nationsManagerNext,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }
}
