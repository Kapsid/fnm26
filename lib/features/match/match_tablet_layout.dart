part of 'match_screen.dart';

/// The live match on a tablet, landscape: commentary, your shape and the
/// momentum, then stats and line-ups. The same widgets the phone shows in
/// three tabs, all on screen at once. Overlays (goal, intervals) sit on top
/// exactly as on the phone.
class _MatchTabletLayout extends StatelessWidget {
  const _MatchTabletLayout({
    required this.ft,
    required this.topBar,
    required this.scoreboard,
    required this.momentum,
    required this.shootout,
    required this.timeline,
    required this.stats,
    required this.lineups,
    required this.pitch,
    required this.overlays,
  });

  static const double _commentaryWidth = 320;
  static const double _sideWidth = 340;

  final bool ft;
  final Widget topBar;
  final Widget scoreboard;
  final Widget? momentum;
  final Widget? shootout;
  final Widget timeline;
  final Widget stats;
  final Widget lineups;
  final Widget pitch;
  final List<Widget> overlays;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      key: MatchScreen.tabletLayoutKey,
      child: Stack(
        children: [
          Column(
            children: [
              topBar,
              scoreboard,
              ?shootout,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: _commentaryWidth,
                        child: Panel(
                          title: l.matchTabTimeline,
                          expand: true,
                          padding: EdgeInsets.zero,
                          child: timeline,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md - 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Panel(
                                title: l.matchYourXi,
                                expand: true,
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                child: pitch,
                              ),
                            ),
                            if (momentum != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Panel(
                                title: l.matchMomentum,
                                padding: EdgeInsets.zero,
                                child: momentum!,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md - 4),
                      SizedBox(
                        width: _sideWidth,
                        child: PanelBox(
                          child: DefaultTabController(
                            length: 2,
                            // Recreated at the whistle, like the phone's.
                            key: ValueKey(ft),
                            child: Column(
                              children: [
                                Material(
                                  color: AppColors.surfaceContainer,
                                  child: TabBar(
                                    labelColor: AppColors.onSurface,
                                    unselectedLabelColor:
                                        AppColors.onSurfaceVariant,
                                    indicatorColor: AppColors.primary,
                                    tabs: [
                                      Tab(text: l.matchTabStats),
                                      Tab(text: l.matchTabLineups),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [stats, lineups],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ...overlays,
        ],
      ),
    );
  }
}
