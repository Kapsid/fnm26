part of 'match_preview_screen.dart';

/// The preview on a tablet: two columns under one heading, the two actions
/// bottom right. The same widgets as the phone, laid side by side.
class _MatchPreviewTabletLayout extends ConsumerWidget {
  const _MatchPreviewTabletLayout({
    required this.screen,
    required this.host,
    required this.themedRounds,
    required this.accent,
  });

  final MatchPreviewScreen screen;
  final WcHostTheme? host;
  final Set<String> themedRounds;
  final Color accent;

  int get careerId => screen.careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final previewAsync = ref.watch(matchPreviewProvider(careerId));
    return Scaffold(
      key: MatchPreviewScreen.tabletLayoutKey,
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.matchCouldNotLoad('$e'))),
        data: (preview) {
          if (preview == null) {
            return Center(child: Text(l10n.matchNoUpcoming));
          }
          final f = preview.fixture;
          String code(int id) => preview.nations[id]?.code ?? '??';
          String name(int id) =>
              preview.nations[id]?.name ?? l10n.matchUnknownNation;
          final team = preview.playerIsHome
              ? preview.homeTeam
              : preview.awayTeam;
          final positions = team.formation.positions;
          final myNationId = preview.playerIsHome
              ? f.homeNationId
              : f.awayNationId;
          final oppNationId = preview.playerIsHome
              ? f.awayNationId
              : f.homeNationId;
          final hosted = host != null && themedRounds.contains(f.round);
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.matchPreviewTitle,
                      style: TabletText.screenTitle.copyWith(color: accent),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        MatchStage.label(l10n, f),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TabletText.barMeta.copyWith(
                          color: hosted ? accent : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (hosted) ...[
                  const SizedBox(height: AppSpacing.sm),
                  WcHostBanner(theme: host!, code: code),
                ],
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            SquadSetupWarning(careerId: careerId),
                            MatchHeadline(
                              homeCode: code(f.homeNationId),
                              homeOverall: squadOverall(preview.homeTeam.xi),
                              awayCode: code(f.awayNationId),
                              awayOverall: squadOverall(preview.awayTeam.xi),
                              date: f.date,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            StrengthPanel(
                              careerId: careerId,
                              formation: team.formation,
                              sideRating: team.xi.isEmpty
                                  ? StrengthFactors.defaultSideRating
                                  : squadOverall(team.xi),
                            ),
                            Row(
                              children: [
                                Text(
                                  l10n.matchYourXi,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  team.formation.label,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            AppCard(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm,
                                horizontal: AppSpacing.md,
                              ),
                              child: Column(
                                children: [
                                  for (var i = 0; i < team.xi.length; i++)
                                    _XiRow(
                                      player: team.xi[i],
                                      slot: i < positions.length
                                          ? positions[i]
                                          : team.xi[i].position,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ListView(
                          children: [
                            OpponentBriefing(
                              careerId: careerId,
                              myNationId: myNationId,
                              oppNationId: oppNationId,
                              oppName: name(oppNationId),
                              oppCode: code(oppNationId),
                              keyMen: _keyMen(
                                preview.playerIsHome
                                    ? preview.awayTeam.xi
                                    : preview.homeTeam.xi,
                              ),
                              saveSeed: preview.saveSeed,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              l10n.matchGroundTitle,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            GroundCard(
                              ground: preview.ground,
                              neutral: preview.neutralVenue,
                              groundNationCode: code(
                                preview.ground.groundNationId,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Spacer(),
              SizedBox(
                width: 220,
                child: OutlinedButton.icon(
                  onPressed: () => screen._openTactics(context, ref),
                  icon: const Icon(Icons.tune, size: 18),
                  label: Text(l10n.matchTactics, maxLines: 1),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      MatchPreviewScreen._barButtonHeight,
                    ),
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 220,
                child: PrimaryButton(
                  label: l10n.matchKickOff,
                  icon: Icons.sports_soccer,
                  height: MatchPreviewScreen._barButtonHeight,
                  onPressed: () =>
                      context.go('${Routes.match}?careerId=$careerId'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
