part of 'friendlies_screen.dart';

/// Arranging friendlies on a tablet: what is being arranged and why the
/// marked sides are marked, the game picked for each window and Confirm on
/// the left; every open window's card (the phone's, with its opponents)
/// beside them. The picks and the write are the screen State's
/// (`_picks`, [_FriendliesScreenState._confirm]), so a resize keeps them.
class _FriendliesTabletLayout extends ConsumerWidget {
  const _FriendliesTabletLayout({required this.state});

  final _FriendliesScreenState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    final async = ref.watch(friendliesPlanProvider(careerId));
    return TabletPage(
      scaffoldKey: FriendliesScreen.tabletLayoutKey,
      title: l.hubEventArrangeFriendlies,
      onBack: () => context.go('${Routes.hub}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.friendliesLoadError(e.toString()))),
        data: (plan) {
          if (plan == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: PrimaryButton(
                  label: l.friendliesContinue,
                  icon: Icons.check_rounded,
                  onPressed: () =>
                      context.go('${Routes.hub}?careerId=$careerId'),
                ),
              ),
            );
          }
          final picks = state._picks;
          Widget card(int i) {
            final window = plan.windows[i];
            final offered = _opponentsFor(
              plan.opponents,
              i,
              plan.windows.length,
            );
            return _WindowCard(
              label: _label(l, window),
              home: friendlyIsHome(window),
              opponents: offered,
              // The head of this window's own deal: the sides the line on
              // the left is talking about.
              marked: offered.take(_markedPerWindow).map((n) => n.id).toSet(),
              selected: picks[window],
              code: (id) => plan.nations[id]?.code ?? '??',
              name: (id) => plan.nations[id]?.name ?? l.hubUnknown,
              onPick: (id) => state._pick(window, id),
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l.friendliesArrangeIntro(plan.windows.length),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            _reasonFor(l, plan),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: Panel(
                        title: l.friendliesYourGames,
                        expand: true,
                        padding: EdgeInsets.zero,
                        child: ListView(
                          padding: const EdgeInsets.all(12),
                          children: [
                            for (final w in plan.windows)
                              _PickLine(
                                label: _label(l, w),
                                home: friendlyIsHome(w),
                                pick: picks[w] == null
                                    ? null
                                    : plan.nations[picks[w]],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButton(
                      key: FriendliesScreen.confirmKey,
                      label: picks.isEmpty
                          ? l.friendliesNoneThisWindow
                          : l.friendliesConfirmCount(picks.length),
                      icon: Icons.check_rounded,
                      // While a step's refresh re-reads the plan this one
                      // may hold a window already gone: Confirm waits.
                      onPressed: state._saving || async.isLoading
                          ? null
                          : () => unawaited(state._confirm(plan)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SingleChildScrollView(
                  child: ColumnFlow(
                    minTileWidth: 260,
                    maxColumns: 2,
                    children: [
                      for (var i = 0; i < plan.windows.length; i++) card(i),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// One window in the picks panel: when, home or away, and who (or free).
class _PickLine extends StatelessWidget {
  const _PickLine({
    required this.label,
    required this.home,
    required this.pick,
  });

  final String label;
  final bool home;
  final Nation? pick;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final nation = pick;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: AppTypography.labelMedium),
          ),
          _VenueBadge(home: home),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: nation == null
                  ? Text(
                      l.friendliesFree,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FlagDisc(nation.code, size: 18, highlighted: true),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            nation.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
