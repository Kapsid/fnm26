part of 'tournaments_screen.dart';

/// The Tournaments screen on a tablet: every competition listed on the left
/// (the world ranking first, then yours, then the other continents'), the
/// picked one open on the right in its own tabs. Until the manager picks,
/// the pane shows the competition being played now.
class _TournamentsTabletLayout extends ConsumerStatefulWidget {
  const _TournamentsTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_TournamentsTabletLayout> createState() =>
      _TournamentsTabletLayoutState();
}

class _TournamentsTabletLayoutState
    extends ConsumerState<_TournamentsTabletLayout> {
  /// Where the pick is kept in the route's page storage. The layout is torn
  /// down when the window narrows under 1000 (iPad split view) and built
  /// afresh when it widens again; the route, and its storage, stay.
  static const _pickStorageId = 'tournaments.tablet.pick';

  /// What the manager picked, or null for the live competition.
  late _Pick? _picked =
      PageStorage.maybeOf(
            context,
          )?.readState(context, identifier: _pickStorageId)
          as _Pick?;

  void _pick(_Pick pick) {
    setState(() => _picked = pick);
    PageStorage.maybeOf(
      context,
    )?.writeState(context, pick, identifier: _pickStorageId);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final overviewAsync = ref.watch(tournamentsOverviewProvider(careerId));
    return Scaffold(
      key: TournamentsScreen.tabletLayoutKey,
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            Center(child: Text(l.tourSharedCouldNotLoadTournaments)),
        data: (overview) {
          final mine = TournamentsScreen._mineSpecs(careerId, overview);
          final others = TournamentsScreen._otherSpecs(careerId, overview);
          final shown =
              [
                ...mine,
                ...others,
              ].where((s) => s.pick == _picked).firstOrNull ??
              mine.firstWhere(
                (s) => s.status?.phase == TournamentPhase.live,
                orElse: () => mine.first,
              );
          Widget row(_Spec s) => _CompetitionListRow(
            key: Key(
              'competition.${s.pick.kind.name}.${s.pick.conf?.name ?? 'world'}',
            ),
            spec: s,
            selected: s.pick == shown.pick,
            onTap: () => _pick(s.pick),
          );
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: MasterDetail(
              initialFraction: 0.32,
              minFraction: 0.22,
              maxFraction: 0.4,
              minDetailWidth: 480,
              master: PanelBox(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: Text(
                        l.tourSharedCompetitions,
                        style: TabletText.screenTitle,
                      ),
                    ),
                    _RankingListRow(
                      key: TourKeys.worldRanking,
                      onTap: () =>
                          context.go('${Routes.ranking}?careerId=$careerId'),
                    ),
                    _ListLabel(l.tourYourCompetitions),
                    for (final s in mine) row(s),
                    _ListLabel(l.tourOtherContinents),
                    for (final s in others) row(s),
                  ],
                ),
              ),
              detail: PanelBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PaneHeader(spec: shown),
                    Expanded(
                      child: KeyedSubtree(
                        // Another competition is another set of tabs: no
                        // tab index or scroll carried over from the last.
                        key: ValueKey(shown.pick),
                        child: _paneBody(l, shown),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// The picked competition's own view, for ITS confederation.
  Widget _paneBody(AppLocalizations l, _Spec s) {
    if (!(s.status?.available ?? false)) {
      return MasterDetailPlaceholder(text: l.tourSharedComingSoon);
    }
    final careerId = widget.careerId;
    return switch (s.pick.kind) {
      _PickKind.worldChampionship => CupDetailView(careerId: careerId),
      _PickKind.continental => ContinentalDetailView(
        careerId: careerId,
        confederation: s.pick.conf!,
      ),
      _PickKind.nationsCup => NationsCupView(
        careerId: careerId,
        confederation: s.pick.conf,
      ),
      _PickKind.clash => ContinentalClashView(careerId: careerId),
    };
  }
}

/// A status's colour: green while it is being played, the accent once there
/// is something to see, grey before.
Color _accentOf(TournamentStatus? status) {
  if (!(status?.available ?? false)) return AppColors.onSurfaceVariant;
  return status?.phase == TournamentPhase.live
      ? AppColors.positive
      : AppColors.primary;
}

/// A heading in the competition list.
class _ListLabel extends StatelessWidget {
  const _ListLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
    child: Text(
      text.capsIn(Localizations.localeOf(context).languageCode),
      style: TabletText.sectionLabel,
    ),
  );
}

/// The list's first line: the world ranking, which is a page of its own.
class _RankingListRow extends StatelessWidget {
  const _RankingListRow({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.leaderboard, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l.tourWorldRanking,
                  style: TabletText.cell.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One competition in the list: trophy, name, strap, status.
class _CompetitionListRow extends StatelessWidget {
  const _CompetitionListRow({
    required this.spec,
    required this.selected,
    required this.onTap,
    super.key,
  });

  /// The strap under the name, found by tests within one row.
  static const Key strapKey = Key('competition.strap');

  final _Spec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = spec.championship;
    final available = spec.status?.available ?? false;
    final accent = _accentOf(spec.status);
    final trophy = Trophies.forCompetitionName(c.name);
    return Material(
      color: selected ? AppColors.surfaceContainerHighest : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: trophy == null
                    ? Icon(c.icon, size: 22, color: accent)
                    : Opacity(
                        opacity: available ? 1 : 0.5,
                        child: Image.asset(
                          trophy,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) =>
                              Icon(c.icon, size: 22, color: accent),
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // As on the phone tile: a Nations Cup says just that,
                      // and its strap names the continent.
                      NationsCups.isNationsCup(c.name)
                          ? l.compNationsCup
                          : competitionLabel(l, c.name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TabletText.cell.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // The strap is read whole: on a Nations Cup row it is all
                    // that tells "LEAGUE A" from "N. AMERICA". The status
                    // follows it on its line while there is room, and drops
                    // under it when there is not, rather than cutting it.
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          c.zone(l),
                          key: _CompetitionListRow.strapKey,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.sectionLabel,
                        ),
                        _StatusChip(
                          label: spec.status?.label ?? l.tourSharedSoon,
                          accent: accent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The pane's heading: the competition's full name, its champion, its
/// status.
class _PaneHeader extends StatelessWidget {
  const _PaneHeader({required this.spec});

  final _Spec spec;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      height: 40,
      color: AppColors.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              competitionLabel(l, spec.championship.name).capsIn(l.localeName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TabletText.panelTitle,
            ),
          ),
          if (spec.championName != null) ...[
            Text(spec.championName!, style: TabletText.barMeta),
            const SizedBox(width: AppSpacing.sm),
          ],
          _StatusChip(
            label: spec.status?.label ?? l.tourSharedSoon,
            accent: _accentOf(spec.status),
          ),
        ],
      ),
    );
  }
}

/// A competition's status, in its colour, never wider than a column allows.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 120),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSmall.copyWith(color: accent),
      ),
    ),
  );
}
