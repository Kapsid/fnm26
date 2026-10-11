part of 'player_detail_screen.dart';

/// A player's page on a tablet: who he is (the headline card, abilities,
/// traits, club, club history, cabinet) on the left; what he has done (the
/// career record, recent form, every match) on the right. The card's own
/// sections and read ([_playerSections], `_playerDetailProvider`), side by
/// side. The detail pane beside a grid keeps the one-column [PlayerView].
class _PlayerTabletLayout extends ConsumerWidget {
  const _PlayerTabletLayout({required this.careerId, required this.playerId});

  final int careerId;
  final int playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(
      _playerDetailProvider((careerId: careerId, playerId: playerId)),
    );
    return TabletPage(
      scaffoldKey: PlayerDetailScreen.tabletLayoutKey,
      title: l.playerPageTitle,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.playerLoadError('$e'))),
        data: (view) {
          final p = view.player;
          if (p == null) return Center(child: Text(l.playerNotFound));
          final sections = _playerSections(context, view, p, careerId);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  key: PlayerDetailScreen.profileKey,
                  children: sections.profile,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: ListView(
                  key: PlayerDetailScreen.recordKey,
                  children: sections.record,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
