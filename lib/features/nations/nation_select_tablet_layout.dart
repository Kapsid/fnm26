part of 'nation_select_screen.dart';

/// The nation pick on a landscape tablet: a bar with the way back, the title,
/// the search and the two other ways in; the confederations as chips with
/// their counts; every nation as a tile (rank, strength, flag, name, best
/// player); and the previewed nation beside them. A tap only previews; Manage
/// takes the job. The search, the confederation, Random team and From the
/// bottom are the phone's own (the same providers and functions), and the
/// preview is held by the screen State and handed in, so a resize keeps it.
class _NationSelectTabletLayout extends ConsumerStatefulWidget {
  const _NationSelectTabletLayout({
    required this.previewId,
    required this.onPreview,
  });

  /// The nation the manager last tapped, or null before the first tap.
  final int? previewId;

  /// Previews the nation with this id.
  final ValueChanged<int> onPreview;

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
                          .where((n) => n.id == widget.previewId)
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
                                  _ShownCount(count: shown.length),
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
                                          onTap: () => widget.onPreview(n.id),
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
                        width: 330,
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
      key: NationSelectScreen.topBarKey,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceContainerHigh),
        ),
      ),
      child: Row(
        children: [
          SizedBox.square(
            key: NationSelectScreen.backKey,
            dimension: 36,
            child: Tooltip(
              message: MaterialLocalizations.of(context).backButtonTooltip,
              child: Material(
                color: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.baseAll,
                  side: BorderSide(color: AppColors.outlineVariant),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.go(Routes.home),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
          const SizedBox(width: 12),
          SizedBox(
            width: 260,
            height: 36,
            child: TextField(
              controller: search,
              onChanged: onSearch,
              textAlignVertical: TextAlignVertical.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurface,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: l.nationsSearchHint,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 16,
                  color: AppColors.outline,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 36,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _BarModeButton(
            icon: Icons.casino_outlined,
            label: l.nationsRandomTeam,
            onTap: onRandom,
          ),
          const SizedBox(width: 12),
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

/// The phone's [_ModeButton] at its own width, for a row it shares. A long
/// label (a translation) is capped and ellipsized, so it never squeezes the
/// title out.
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
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 170),
    child: OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 15),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        // The mockup sets these in the sans, not the mono read-out face.
        style: AppTypography.bodySmall.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.outlineVariant),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.baseAll),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(0, 36),
        maximumSize: const Size(170, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
      ),
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
          height: 30,
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
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: active
                      ? AppColors.onSurface
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
                    ? const [_selectedTileTop, _selectedTileBottom]
                    : const [
                        AppColors.surfaceContainerHigh,
                        AppColors.surfaceContainerLow,
                      ],
              ),
              // Selected: the mockup's 1 px primary border plus its inset
              // 1 px primary ring, which together paint a 2 px primary edge.
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : AppColors.surfaceContainerHighest,
                width: selected ? 2 : 1,
              ),
              boxShadow: [if (selected) _tileLiftShadow else _tileRestShadow],
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
                        _TileFlag(code: nation.code, selected: selected),
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
                          _StarLine(
                            position: s.best.position.label,
                            rating: s.best.overall,
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

/// The selected tile's gradient, top left to bottom right. The mockup's
/// steel-tinted greys have no theme token.
const _selectedTileTop = Color(0xFF3A3F45);
const _selectedTileBottom = Color(0xFF23272B);

/// Every tile sits on a small drop shadow; the selected one lifts higher.
const _tileRestShadow = BoxShadow(
  color: Color(0x4D000000),
  offset: Offset(0, 3),
  blurRadius: 6,
);
const _tileLiftShadow = BoxShadow(
  color: Color(0x73000000),
  offset: Offset(0, 6),
  blurRadius: 14,
);

/// A tile's flag: the shared [FlagDisc] with a light 2 px ring painted over
/// its own and a small drop shadow, so every tile's disc reads as enamel.
/// Wrapped here so [FlagDisc]'s own look (phones) is untouched.
class _TileFlag extends StatelessWidget {
  const _TileFlag({required this.code, required this.selected});

  final String code;
  final bool selected;

  static const double _size = 56;

  @override
  Widget build(BuildContext context) => Container(
    width: _size,
    height: _size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Color(0x80000000),
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    ),
    foregroundDecoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0x2EFFFFFF), width: 2),
    ),
    child: FlagDisc(code, size: _size, highlighted: selected),
  );
}

/// "Star ST 93" with the position and rating in the brighter weight. The
/// label is whatever the copy puts before the position (found by rendering
/// the copy with a marker in its place), so no new copy is needed; a
/// translation that puts the position first reads as one plain line.
class _StarLine extends StatelessWidget {
  const _StarLine({required this.position, required this.rating});

  final String position;
  final int rating;

  static const _marker = '\u{E000}';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final full = l.nationsStarTile(position, rating);
    final template = l.nationsStarTile(_marker, rating);
    final at = template.indexOf(_marker);
    final label = at > 0 ? template.substring(0, at) : '';
    final split = label.isNotEmpty && full.startsWith(label);
    return Text.rich(
      split
          ? TextSpan(
              text: label,
              children: [
                TextSpan(
                  text: full.substring(label.length),
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : TextSpan(text: full),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.bodySmall.copyWith(
        fontSize: 11,
        color: AppColors.outline,
      ),
    );
  }
}

/// "16 NATIONS" with the number in primary. The number is found in the
/// rendered copy, so no new copy is needed; copy without the digits (a
/// spelled-out "one") reads as one plain label.
class _ShownCount extends StatelessWidget {
  const _ShownCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final full = AppLocalizations.of(
      context,
    ).nationsShownCount(count).toUpperCase();
    final digits = '$count';
    final at = full.indexOf(digits);
    return Text.rich(
      at < 0
          ? TextSpan(text: full)
          : TextSpan(
              children: [
                TextSpan(text: full.substring(0, at)),
                TextSpan(
                  text: digits,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: full.substring(at + digits.length)),
              ],
            ),
      style: TabletText.sectionLabel,
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
