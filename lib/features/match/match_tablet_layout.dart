part of 'match_screen.dart';

/// The live match on a tablet, landscape, in three columns: the match stats
/// on the left; the momentum, the score and the commentary down the centre;
/// the line-ups (and the manager's own shape on the pitch) on the right. The
/// same widgets the phone shows in three tabs, all on screen at once.
/// Overlays (goal, intervals) sit on top exactly as on the phone, and the
/// controls (with the Pitch / Timeline toggle) stay in the pinned bar below.
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
    this.pitchView,
    this.feed,
    this.tvHeader,
    this.tvOverlays = const [],
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

  /// Pitch mode: the picture, filling the centre column under the score. Null
  /// in Timeline mode, which is laid out exactly as it always was.
  final Widget? pitchView;

  /// Pitch mode: the commentary feed (null while the picture is built).
  final Widget? feed;

  /// Pitch mode: the broadcast header across the top of the picture, in
  /// place of the scoreboard (see [MatchTvHeader]).
  final Widget? tvHeader;

  /// Pitch mode: what the TV puts over the picture (the goal's banner, the
  /// moment feed down its right edge).
  final List<Widget> tvOverlays;

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
                          // The line-ups column is as wide in both modes, so
                          // the line-ups read the same in each.
                          SizedBox(
                            width: (c.maxWidth * _sideShare).clamp(
                              _sideMin,
                              _sideMax,
                            ),
                            child: _lineupsColumn(l),
                          ),
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
  /// left and the picture fills what the commentary would, under the TV's
  /// broadcast header (which stands for the scoreboard there).
  Widget _centre(AppLocalizations l) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (momentum != null && !_pitchMode) ...[
        // No panel header: the bar names itself.
        PanelBox(child: momentum!),
        const SizedBox(height: AppSpacing.sm),
      ],
      if (!_pitchMode) scoreboard,
      ?shootout,
      if (!_pitchMode || shootout != null)
        const SizedBox(height: AppSpacing.sm),
      if (_pitchMode)
        Expanded(child: _tv())
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

  /// Pitch mode: the TV as one set, the broadcast header across the top of
  /// the picture and as wide as it, the goal's banner and the moment feed
  /// over the picture. As big as the column allows.
  Widget _tv() => LayoutBuilder(
    builder: (context, c) {
      const header = MatchTvHeader.height;
      final w = math.max<double>(
        0,
        math.min(c.maxWidth, (c.maxHeight - header) * kPitchModeAspect),
      );
      return Center(
        child: ClipRRect(
          borderRadius: AppRadii.baseAll,
          child: SizedBox(
            width: w,
            height: header + w / kPitchModeAspect,
            child: Column(
              children: [
                SizedBox(height: header, child: tvHeader),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [?pitchView, ...tvOverlays],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
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

  /// Pitch mode: the commentary so far (newest first), then the line-ups
  /// exactly as Timeline mode shows them: both line-ups, and the manager's
  /// own shape on the pitch (its energy, its holes; a tap opens the tactics).
  Widget _feedColumn(AppLocalizations l) => PanelBox(
    child: DefaultTabController(
      length: 3,
      key: ValueKey(('pitch', ft)),
      child: Column(
        children: [
          Material(
            color: AppColors.surfaceContainer,
            child: TabBar(
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              // Three tabs in the column: tighter gutters, so each label
              // keeps its size (a long translation still scales down rather
              // than being cut off).
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              tabs: [
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
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(l.matchYourXi),
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
