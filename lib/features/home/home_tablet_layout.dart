part of 'home_screen.dart';

/// The home screen on a landscape tablet: the logo and the title on the
/// left; on the right the way back into the last save or campaign, a new
/// game, and the saves list. Every button is the phone's own; settings stay
/// top right.
class _HomeTabletLayout extends StatelessWidget {
  const _HomeTabletLayout({
    required this.hasSave,
    required this.cards,
  });

  /// Whether a normal save exists (the secondary button then says "All saves").
  final bool hasSave;

  /// The continue cards, most recently played first; none for a fresh install.
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: HomeScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: l.homeSettings,
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                  onPressed: () => context.go(Routes.settings),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // The artwork's aspect (about 0.96:1), as on the
                          // phone: a box of another shape letterboxes it.
                          Image.asset(
                            'assets/images/fnm_logo.png',
                            width: 260,
                            height: 270,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stack) => const Icon(
                              Icons.sports_soccer,
                              size: 140,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Football Nations\nManager',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineLarge,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l.homeLeadTheNation,
                            textAlign: TextAlign.center,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final card in cards) ...[
                                card,
                                const SizedBox(height: AppSpacing.md),
                              ],
                              PrimaryButton(
                                label: l.homeNewGame,
                                icon: Icons.play_arrow_rounded,
                                onPressed: () => context.go(Routes.nations),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              TextButton(
                                onPressed: () => context.go(Routes.saves),
                                child: Text(
                                  hasSave ? l.homeAllSaves : l.homeLoadGame,
                                ),
                              ),
                              TextButton(
                                key: HomeScreen.campaignsKey,
                                onPressed: () => context.go(Routes.campaigns),
                                child: Text(l.homeCampaigns),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
