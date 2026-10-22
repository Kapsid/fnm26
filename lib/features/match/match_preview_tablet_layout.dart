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
        // See the phone layout: never the old teamsheet while it refreshes.
        skipLoadingOnRefresh: false,
        loading: () => _withActions(
          context,
          ref,
          l10n,
          const CircularProgressIndicator(),
        ),
        error: (e, _) => _withActions(
          context,
          ref,
          l10n,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.matchCouldNotLoad('$e'), textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => ref.invalidate(matchPreviewProvider(careerId)),
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
        data: (preview) {
          if (preview == null) {
            return _withActions(
              context,
              ref,
              l10n,
              Text(l10n.matchNoUpcoming, textAlign: TextAlign.center),
            );
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  p.briefing(capitals: true),
                                  const SizedBox(height: AppSpacing.lg),
                                  p.groundTitle(),
                                  const SizedBox(height: AppSpacing.sm),
                                  p.ground(),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _actions(context, ref, l10n),
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
    );
  }

  /// [message] centred while there is no preview to show (loading, an error,
  /// no match), with the two actions still at the foot of the right-hand
  /// half where the preview puts them: the manager can always kick off.
  Widget _withActions(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Widget message,
  ) => Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: Center(child: message)),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const Spacer(),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _actions(context, ref, l10n)),
          ],
        ),
      ],
    ),
  );

  /// How tall the two actions stand: well over the phone bar's, as the one
  /// thing on the screen to do next.
  static const double _actionHeight = 64;

  /// Tactics over Kick-off, each the full width of the right-hand column, at
  /// the foot of it: no bar of their own across the bottom of the screen.
  Widget _actions(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) => SafeArea(
    top: false,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: () => screen._openTactics(context, ref),
          icon: const Icon(Icons.tune, size: 20),
          label: Text(l10n.matchTactics, maxLines: 1),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(_actionHeight),
            foregroundColor: AppColors.primary,
            backgroundColor: AppColors.surfaceContainer,
            textStyle: AppTypography.labelLarge,
            side: const BorderSide(color: AppColors.primary),
            // Kick-off's own corners, so the two read as one pair.
            shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdAll),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: l10n.matchKickOff,
          icon: Icons.sports_soccer,
          height: _actionHeight,
          onPressed: () => context.go('${Routes.match}?careerId=$careerId'),
        ),
      ],
    ),
  );
}
