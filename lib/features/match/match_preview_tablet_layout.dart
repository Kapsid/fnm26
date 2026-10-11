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
          final p = _PreviewParts(
            preview: preview,
            careerId: careerId,
            l10n: l10n,
            host: host,
            themedRounds: themedRounds,
          );
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
                        MatchStage.label(l10n, p.fixture),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TabletText.barMeta.copyWith(
                          color: p.hosted ? accent : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (p.hosted) ...[
                  const SizedBox(height: AppSpacing.sm),
                  WcHostBanner(theme: host!, code: p.code),
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
                            p.headline(),
                            const SizedBox(height: AppSpacing.lg),
                            p.strength(),
                            p.xiHeader(),
                            const SizedBox(height: AppSpacing.sm),
                            p.xiCard(),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ListView(
                          children: [
                            p.briefing(),
                            const SizedBox(height: AppSpacing.lg),
                            p.groundTitle(),
                            const SizedBox(height: AppSpacing.sm),
                            p.ground(),
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
