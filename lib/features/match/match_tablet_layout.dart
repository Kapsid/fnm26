part of 'match_screen.dart';

/// The live match on a tablet, landscape, in three columns: the match stats
/// on the left; the momentum, the score and the commentary down the centre;
/// the line-ups (and the manager's own shape on the pitch) on the right. The
/// same widgets the phone shows in three tabs, all on screen at once.
/// Overlays (goal, intervals) sit on top exactly as on the phone, and the
/// controls stay in the pinned bar below.
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

  /// The share of the width each side column takes, within these bounds.
  static const double _sideShare = 0.26;
  static const double _sideMin = 270;
  static const double _sideMax = 360;
  static const double _gap = AppSpacing.md - 4;

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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final side = (c.maxWidth * _sideShare).clamp(
                        _sideMin,
                        _sideMax,
                      );
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: side,
                            child: Panel(
                              title: l.matchTabStats,
                              expand: true,
                              padding: EdgeInsets.zero,
                              child: stats,
                            ),
                          ),
                          const SizedBox(width: _gap),
                          Expanded(child: _centre(l)),
                          const SizedBox(width: _gap),
                          SizedBox(width: side, child: _lineupsColumn(l)),
                        ],
                      );
                    },
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

  /// The momentum over the score, then the shootout if there is one, then
  /// the commentary filling the rest.
  Widget _centre(AppLocalizations l) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (momentum != null) ...[
        // No panel header: the bar names itself.
        PanelBox(child: momentum!),
        const SizedBox(height: AppSpacing.sm),
      ],
      scoreboard,
      ?shootout,
      const SizedBox(height: AppSpacing.sm),
      Expanded(
        child: Panel(
          title: l.matchTabTimeline,
          expand: true,
          padding: EdgeInsets.zero,
          child: timeline,
        ),
      ),
    ],
  );

  /// Both line-ups, with the manager's own shape on the pitch a tab away
  /// (a tap on it opens the tactics, as the bar's Tactics button does).
  Widget _lineupsColumn(AppLocalizations l) => PanelBox(
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
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: l.matchTabLineups),
                Tab(text: l.matchYourXi),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                lineups,
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: pitch,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
