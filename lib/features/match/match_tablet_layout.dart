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
    this.viewSwitch,
    this.pitchView,
    this.feed,
  });

  /// The share of the width each side column takes, within these bounds.
  static const double _sideShare = 0.26;
  static const double _sideMin = 270;
  static const double _sideMax = 360;

  /// Pitch mode gives the picture more of the width.
  static const double _pitchSideShare = 0.22;
  static const double _pitchSideMin = 250;
  static const double _pitchSideMax = 300;
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

  /// The Pitch / Timeline switch, in the stats panel's header.
  final Widget? viewSwitch;

  /// Pitch mode: the picture, filling the centre column under the score. Null
  /// in Timeline mode, which is laid out exactly as it always was.
  final Widget? pitchView;

  /// Pitch mode: the commentary feed (null while the picture is built).
  final Widget? feed;

  bool get _pitchMode => pitchView != null;

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
                      final side = _pitchMode
                          ? (c.maxWidth * _pitchSideShare).clamp(
                              _pitchSideMin,
                              _pitchSideMax,
                            )
                          : (c.maxWidth * _sideShare).clamp(
                              _sideMin,
                              _sideMax,
                            );
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: side, child: _statsColumn(l)),
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

  /// The match stats; in Pitch mode the momentum sits over them.
  Widget _statsColumn(AppLocalizations l) {
    final panel = Panel(
      title: l.matchTabStats,
      action: viewSwitch,
      expand: true,
      padding: EdgeInsets.zero,
      child: stats,
    );
    if (!_pitchMode || momentum == null) return panel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PanelBox(child: momentum!),
        const SizedBox(height: AppSpacing.sm),
        Expanded(child: panel),
      ],
    );
  }

  /// The momentum over the score, then the shootout if there is one, then
  /// the commentary filling the rest. In Pitch mode the momentum is on the
  /// left and the picture fills what the commentary would.
  Widget _centre(AppLocalizations l) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (momentum != null && !_pitchMode) ...[
        // No panel header: the bar names itself.
        PanelBox(child: momentum!),
        const SizedBox(height: AppSpacing.sm),
      ],
      scoreboard,
      ?shootout,
      const SizedBox(height: AppSpacing.sm),
      if (_pitchMode)
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: kPitchModeAspect,
              child: ClipRRect(
                borderRadius: AppRadii.baseAll,
                child: pitchView,
              ),
            ),
          ),
        )
      else
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
  ///
  /// Opens on YOUR XI: the manager's own shape, with its energy and its
  /// holes, is what he watches a match through. Both line-ups are the tab he
  /// looks up now and then.
  Widget _lineupsColumn(AppLocalizations l) => _pitchMode
      ? _feedColumn(l)
      : PanelBox(
          child: DefaultTabController(
            length: 2,
            initialIndex: 1,
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

  /// Pitch mode: the commentary so far (newest first) and both line-ups, a
  /// tab each. The manager's own shape is on the big pitch already.
  Widget _feedColumn(AppLocalizations l) => PanelBox(
    child: DefaultTabController(
      length: 2,
      key: ValueKey(('pitch', ft)),
      child: Column(
        children: [
          Material(
            color: AppColors.surfaceContainer,
            child: TabBar(
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: [
                // Scaled down rather than cut off in the narrow column.
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(l.matchTabCommentary),
                  ),
                ),
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(l.matchTabLineups),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                feed ?? const Center(child: CircularProgressIndicator()),
                lineups,
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
