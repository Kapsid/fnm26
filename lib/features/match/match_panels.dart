part of 'match_screen.dart';

/// A penalty given in play (not a shootout kick), as the Timeline and the
/// box score read it: who took it, for which side, and whether it went in.
typedef InPlayPenalty = ({
  int minute,
  int stoppage,
  int teamNationId,
  String takerName,
  bool scored,
});

/// The penalties in [r] the clock has reached. A scored one is reached with
/// its goal ([eventReached]: a goal still on its way in on the 2D TV is
/// held back with it); one that did not go in has no event, so it is
/// reached by its minute ([momentReached]). [names] names the takers.
List<InPlayPenalty> inPlayPenalties(
  MatchResult r, {
  required Map<int, String> names,
  required bool Function(MatchEvent e) eventReached,
  required bool Function(int minute, int stoppage) momentReached,
}) {
  bool reached(ShotMoment s) {
    if (s.outcome != ShotOutcome.goal) {
      return momentReached(s.minute, s.stoppage);
    }
    final g = s.goalEventIndex;
    return g != null && g < r.events.length && eventReached(r.events[g]);
  }

  return [
    for (final s in r.moments.whereType<ShotMoment>())
      if (s.origin == ShotOrigin.penalty && reached(s))
        (
          minute: s.minute,
          stoppage: s.stoppage,
          teamNationId: s.teamNationId,
          takerName: names[s.shooterId] ?? '',
          scored: s.outcome == ShotOutcome.goal,
        ),
  ];
}

/// What the manager reads while the game runs: the timeline, the box score,
/// the two line-ups, momentum, and the moments that interrupt — a goal, a
/// shootout, half time.
///
/// The Timeline lists the events and, with them, every penalty that did not
/// go in: a miss is no event, so a penalty saved used to leave no trace here
/// at all (a scored one is its goal, marked "(pen)").
class MatchTimeline extends StatelessWidget {
  const MatchTimeline({
    required this.events,
    required this.live,
    required this.homeId,
    this.penalties = const [],
    super.key,
  });
  final List<MatchEvent> events;
  final List<InPlayPenalty> penalties;
  final bool live;
  final int homeId;

  @override
  Widget build(BuildContext context) {
    // Substitutions are shown on the Lineups tab, not in the event feed.
    final rows = <({int minute, int stoppage, _TimelineRow row})>[
      for (final e in events)
        if (e.type != MatchEventType.substitution)
          (
            minute: e.minute,
            stoppage: e.stoppage,
            row: _TimelineRow(event: e, isHome: e.teamNationId == homeId),
          ),
      for (final p in penalties)
        if (!p.scored)
          (
            minute: p.minute,
            stoppage: p.stoppage,
            row: _TimelineRow(
              missedPenalty: p,
              isHome: p.teamNationId == homeId,
            ),
          ),
    ];
    if (rows.isEmpty) {
      return Center(
        child: Text(
          live
              ? AppLocalizations.of(context).matchFeedKickOff
              : AppLocalizations.of(context).matchFeedNoEvents,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    // In match order (the events keep their own order on a tie), then the
    // most recent at the top.
    final indexed = [for (var i = 0; i < rows.length; i++) (i, rows[i])]
      ..sort((a, b) {
        final m = a.$2.minute.compareTo(b.$2.minute);
        if (m != 0) return m;
        final st = a.$2.stoppage.compareTo(b.$2.stoppage);
        return st != 0 ? st : a.$1.compareTo(b.$1);
      });
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [for (final r in indexed.reversed) r.$2.row],
    );
  }
}

/// One event on a two-sided timeline: home events sit on the left, away on the
/// right, with the minute down the centre spine. Either an [event] or a
/// [missedPenalty] (a penalty saved or missed, which is no event).
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.isHome, this.event, this.missedPenalty})
    : assert(
        (event == null) != (missedPenalty == null),
        'a row is an event or a missed penalty',
      );

  final MatchEvent? event;
  final InPlayPenalty? missedPenalty;
  final bool isHome;

  String get _clock {
    final e = event;
    if (e != null) return _eventClock(e);
    final p = missedPenalty!;
    return p.stoppage > 0 ? '90+${p.stoppage}' : "${p.minute}'";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: isHome
                ? _entry(context, alignEnd: true)
                : const SizedBox.shrink(),
          ),
          Container(
            width: 34,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: AppRadii.smAll,
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Text(_clock, style: AppTypography.labelSmall),
          ),
          Expanded(
            child: !isHome
                ? _entry(context, alignEnd: false)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _entry(BuildContext context, {required bool alignEnd}) {
    final event = this.event;
    if (event == null) {
      // A penalty saved or missed: the ball with a red cross, the taker's
      // name alone. The old "NAME: MISSED" text ran off the edge in the
      // longer languages; the icon says it in 18 px and carries the wording
      // for screen readers.
      final name = _abbrevName(missedPenalty!.takerName);
      return _entryOf(
        icon: Semantics(
          label: AppLocalizations.of(context).matchShootoutKickMissed(name),
          child: const ExcludeSemantics(child: MissedPenaltyMark()),
        ),
        label: name,
        emphasised: false,
        alignEnd: alignEnd,
      );
    }
    final isGoal = event.type == MatchEventType.goal;
    // A card is the shared [CardMark], the same one the pitch and the
    // substitution lists wear. A second booking shows both cards, the way it
    // happened; a straight red shows one. The manager can tell at a glance
    // which one cost him the man.
    final icon = switch (event.type) {
      MatchEventType.goal => const Icon(
        Icons.sports_soccer,
        size: 16,
        color: AppColors.primary,
      ),
      MatchEventType.substitution => const Icon(
        Icons.swap_horiz,
        size: 16,
        color: AppColors.onSurfaceVariant,
      ),
      MatchEventType.injury => const Icon(
        Icons.medical_services,
        size: 16,
        color: AppColors.onSurfaceVariant,
      ),
      MatchEventType.yellowCard => const CardMark(MatchCard.yellow),
      MatchEventType.redCard => CardMark(
        event.secondYellow ? MatchCard.secondYellow : MatchCard.red,
      ),
    };
    final label = switch (event.type) {
      MatchEventType.substitution =>
        '${_abbrevName(event.playerName)} ↔ '
            '${_abbrevName(event.secondaryName ?? '')}',
      MatchEventType.goal when event.penalty =>
        '${_abbrevName(event.playerName)} (pen)',
      // A dismissal carries the name alone. The CARD says which one it was —
      // two overlapping cards for a second booking, one red for a straight
      // one — so naming it again in text said nothing the icon had not
      // already said, and ran the row off the edge doing it.
      _ => _abbrevName(event.playerName),
    };
    return _entryOf(
      icon: icon,
      label: label,
      emphasised: isGoal,
      alignEnd: alignEnd,
    );
  }

  Widget _entryOf({
    required Widget icon,
    required String label,
    required bool emphasised,
    required bool alignEnd,
  }) {
    final text = Flexible(
      child: Text(
        label,
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodyMedium.copyWith(
          color: emphasised ? AppColors.onSurface : AppColors.onSurfaceVariant,
        ),
      ),
    );
    return Padding(
      padding: EdgeInsets.only(
        left: alignEnd ? 0 : AppSpacing.sm,
        right: alignEnd ? AppSpacing.sm : 0,
      ),
      child: Row(
        mainAxisAlignment: alignEnd
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: alignEnd
            ? [text, const SizedBox(width: AppSpacing.sm), icon]
            : [icon, const SizedBox(width: AppSpacing.sm), text],
      ),
    );
  }
}

/// The clock label for an event: a stoppage-time event reads "90+3", everything
/// else its plain minute with an apostrophe ("67'").
String _eventClock(MatchEvent e) =>
    e.stoppage > 0 ? '90+${e.stoppage}' : "${e.minute}'";

/// "Adam Test" → "A. Test" for the compact match timeline; single names and
/// blanks pass through unchanged.
String _abbrevName(String full) {
  final parts = full.trim().split(RegExp(r'\s+'));
  if (parts.length < 2 || parts.first.isEmpty) return full;
  return '${parts.first[0]}. ${parts.last}';
}

/// The box score, readable from the first whistle.
///
/// It used to say "Stats available at full time." for ninety minutes and then
/// fill in all at once, which made a tab that was on screen the whole match
/// useless for all of it. Everything the engine records minute by minute
/// (shots, xG) or as timed events (goals, cards) is now reported as of
/// [minute]; only the figures that genuinely are not settled until the whistle
/// wait for it, and a line says which ones rather than leaving a gap.
class MatchStatsPanel extends StatelessWidget {
  const MatchStatsPanel({
    super.key,
    required this.result,
    required this.homeCode,
    required this.awayCode,
    required this.homeNationId,
    required this.ground,
    required this.neutral,
    required this.groundCode,
    this.homeFans,
    this.kickOff,
    this.weather,
    required this.minute,
    required this.fullTime,
    required this.events,
    this.penalties = const [],
    this.showGround = true,
  });

  /// Whether the ground's card closes the stats, under the figures (and
  /// over the full-time ratings), where the crowd is read like one more.
  final bool showGround;
  final bool neutral;
  final String groundCode;
  final MatchResult result;
  final String homeCode;
  final String awayCode;
  final int homeNationId;
  final MatchGround ground;

  /// The kick-off time and weather the 2D TV draws, for the venue card.
  final KickOffTime? kickOff;
  final WeatherKind? weather;

  /// How the home supporters feel, at a home game of the manager's side.
  final FanMoodBand? homeFans;

  /// The minute on the clock. Extra time reads past the end of the per-minute
  /// series, so it is clamped to the last recorded point.
  final int minute;

  /// The final whistle has gone: the whole-match figures can be stated.
  final bool fullTime;

  /// The events the clock has REACHED, already gated for added time by the
  /// screen, so counting them here needs no minute arithmetic of its own.
  final List<MatchEvent> events;

  /// The penalties given in play that the clock has reached (see
  /// [inPlayPenalties]). Without them a penalty saved was only a shot more.
  final List<InPlayPenalty> penalties;

  /// A per-minute series read as of the clock: the full-match total once the
  /// whistle has gone (the series' last point is that total), and 0 for a
  /// result that never recorded the series.
  T _asOf<T extends num>(List<T> series, T total, T zero) {
    if (fullTime) return total;
    if (series.isEmpty) return zero;
    return series[minute.clamp(0, series.length - 1)];
  }

  int _count(MatchEventType type, {required bool home}) => events
      .where((e) => e.type == type && (e.teamNationId == homeNationId) == home)
      .length;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // The man of the match is a verdict on ninety minutes, not a running
    // total, so it stays behind the whistle however good someone looks at 20'.
    final motm = fullTime ? result.manOfTheMatch : null;
    final homeYellow = _count(MatchEventType.yellowCard, home: true);
    final awayYellow = _count(MatchEventType.yellowCard, home: false);
    final homeRed = _count(MatchEventType.redCard, home: true);
    final awayRed = _count(MatchEventType.redCard, home: false);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (motm != null) ...[
          _MotmCard(
            name: motm.playerName,
            rating: motm.rating,
            teamCode: motm.teamNationId == homeNationId ? homeCode : awayCode,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(nationCodeLabel(homeCode), style: AppTypography.labelMedium),
            Text(nationCodeLabel(awayCode), style: AppTypography.labelMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _StatBar(
          label: l.matchStatGoals,
          home: _count(MatchEventType.goal, home: true),
          away: _count(MatchEventType.goal, home: false),
        ),
        _StatBar(
          label: l.matchStatShots,
          home: _asOf(result.homeShotsByMinute, result.homeShots, 0),
          away: _asOf(result.awayShotsByMinute, result.awayShots, 0),
        ),
        _XgBar(
          home: _asOf(result.homeXgByMinute, result.homeXg, 0.0),
          away: _asOf(result.awayXgByMinute, result.awayXg, 0.0),
        ),
        // Possession is a share of the whole match, not a per-minute series:
        // printing the final figure at 20' would state something that is not
        // true yet, so it waits with the rest of the full-time block.
        if (fullTime)
          _StatBar(
            label: l.tacticsInstrPossession,
            home: result.homePossession,
            away: result.awayPossession,
            suffix: '%',
          ),
        // Cards appear once there are any: a 0 v 0 red-card row in the eight
        // matches out of ten that have none is noise, not information.
        if (homeYellow + awayYellow > 0)
          _StatBar(
            label: l.matchStatYellowCards,
            home: homeYellow,
            away: awayYellow,
          ),
        if (homeRed + awayRed > 0)
          _StatBar(label: l.matchStatRedCards, home: homeRed, away: awayRed),
        // Penalties given, scored or not, like the cards: once there are any.
        if (penalties.isNotEmpty)
          _StatBar(
            label: l.tacticsPenalties,
            home: penalties.where((p) => p.teamNationId == homeNationId).length,
            away: penalties.where((p) => p.teamNationId != homeNationId).length,
          ),
        if (!fullTime) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.matchStatsAtFullTime,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
        if (showGround) ...[
          const SizedBox(height: AppSpacing.lg),
          GroundCard(
            ground: ground,
            neutral: neutral,
            groundNationCode: groundCode,
            fans: homeFans,
            kickOff: kickOff,
            weather: weather,
          ),
        ],
        if (fullTime && result.ratings.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.matchPlayerRatings,
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ratingsBlock(homeCode, homeNationId),
          const SizedBox(height: AppSpacing.md),
          _ratingsBlock(awayCode, null),
        ],
      ],
    );
  }

  /// A team's players and their match marks, best first. [teamId] is the home
  /// nation id for the home block, or null for the away block.
  Widget _ratingsBlock(String teamCode, int? teamId) {
    // Read top-down like a team sheet: goalkeeper, defence, midfield, attack
    // (then rating within a line), rather than purely by score.
    final players =
        [
          for (final r in result.ratings)
            if ((r.teamNationId == homeNationId) == (teamId != null)) r,
        ]..sort((a, b) {
          final byLine = a.position.category.index.compareTo(
            b.position.category.index,
          );
          if (byLine != 0) return byLine;
          final byPos = a.position.index.compareTo(b.position.index);
          if (byPos != 0) return byPos;
          return b.rating.compareTo(a.rating);
        });
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nationCodeLabel(teamCode),
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final r in players)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  // Lead with the position so the marks read like a team sheet,
                  // not just a flat list of names.
                  SizedBox(
                    width: 36,
                    child: TacticalChip(r.position.label),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      r.playerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                  RatingBadge(
                    r.rating,
                    motm: r.playerId == result.manOfTheMatch?.playerId,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The expected-goals stat row: fractional values (one decimal) with a bar
/// split by each side's xG share.
class _XgBar extends StatelessWidget {
  const _XgBar({required this.home, required this.away});

  final double home;
  final double away;

  @override
  Widget build(BuildContext context) {
    final total = (home + away) == 0 ? 1.0 : home + away;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(home.toStringAsFixed(1), style: AppTypography.labelMedium),
              Text(
                'XG',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(away.toStringAsFixed(1), style: AppTypography.labelMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // The split SLIDES. These bars move while the match is being
          // played, and a bar that jumps from one share to another reads as a
          // redraw rather than as something happening on the pitch. Same
          // duration and curve as the possession bar further down this file,
          // so two bars on one screen do not move at different speeds.
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: home / total),
              duration: _barDuration,
              curve: _barCurve,
              builder: (context, share, _) => Row(
                children: [
                  Expanded(
                    flex: (share * 1000).round().clamp(1, 1000),
                    child: Container(height: 6, color: AppColors.primary),
                  ),
                  Expanded(
                    flex: ((1 - share) * 1000).round().clamp(1, 1000),
                    child: Container(
                      height: 6,
                      color: AppColors.outlineVariant,
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

/// How a live stat bar moves. Matched to the possession bar's own constants
/// further down, so nothing on the screen animates at two different speeds.
const Duration _barDuration = Duration(milliseconds: 450);
const Curve _barCurve = Curves.easeOutCubic;

/// One side's number, which FLIPS when it changes rather than counting.
///
/// Counting would print values that never happened: a shot count easing from
/// four to five passes through four-point-something, and there is no such
/// thing. So the old number leaves and the new one arrives, which says a
/// thing has changed without inventing a number in between.
class _Tally extends StatelessWidget {
  const _Tally({required this.value, required this.suffix});

  final int value;
  final String suffix;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 220),
    transitionBuilder: (child, animation) => FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.vertical,
        axisAlignment: -1,
        child: child,
      ),
    ),
    child: Text(
      '$value$suffix',
      key: ValueKey(value),
      style: AppTypography.labelMedium,
    ),
  );
}

class _StatBar extends StatelessWidget {
  const _StatBar({
    required this.label,
    required this.home,
    required this.away,
    this.suffix = '',
  });

  final String label;
  final int home;
  final int away;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final total = (home + away) == 0 ? 1 : home + away;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          Row(
            children: [
              _Tally(value: home, suffix: suffix),
              // The label takes the room the two numbers leave, rather than
              // whatever width it wants: a long one (ZLUTE KARTY) used to push
              // a spaceBetween row past the screen and overflow it.
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Text(
                    label.capsIn(Localizations.localeOf(context).languageCode),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              _Tally(value: away, suffix: suffix),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: Row(
              children: [
                Expanded(
                  flex: (home / total * 1000).round().clamp(1, 1000),
                  child: Container(height: 6, color: AppColors.primary),
                ),
                Expanded(
                  flex: (away / total * 1000).round().clamp(1, 1000),
                  child: Container(height: 6, color: AppColors.outlineVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The two line-ups, each player with his match rating and what he has done
/// so far: goals, assists, cards, coming on or going off.
///
/// PUBLIC so a widget test can pump it on its own. While the match is played
/// [ratings] are the live marks (see `LiveRatings`): built only from the
/// [events] the clock has reached, so they never show a mark the match has
/// not earned yet. At full time they are the stored marks and [motmId] gets
/// its star.
class MatchLineups extends StatelessWidget {
  const MatchLineups({
    super.key,
    required this.home,
    required this.away,
    required this.homeCode,
    required this.awayCode,
    this.homeSubs = const [],
    this.awaySubs = const [],
    this.homeBench = const [],
    this.awayBench = const [],
    this.ratings = const {},
    this.energy = const {},
    this.events = const [],
    this.motmId,
    this.live = false,
  });

  final List<Player> home;
  final List<Player> away;
  final String homeCode;
  final String awayCode;

  /// Substitutions made by each side (off ↔ on), shown under its XI.
  final List<MatchEvent> homeSubs;
  final List<MatchEvent> awaySubs;

  /// Every substitute named on each teamsheet — the tab used to show only the
  /// eleven who started plus whoever had already come on, so the rest of the
  /// bench was invisible for the whole match.
  final List<Player> homeBench;
  final List<Player> awayBench;

  /// Per-player match ratings, keyed by player id: the live marks while the
  /// match is played, the stored ones at full time. A player who has not
  /// been on the pitch has none.
  final Map<int, double> ratings;

  /// Per-player remaining energy (0–100) at full time, keyed by player id.
  final Map<int, int> energy;

  /// The events the clock has reached, for each player's markers.
  final List<MatchEvent> events;

  /// The player of the match, starred at full time; null while it is played.
  final int? motmId;

  /// The match is still being played: the ratings are running marks.
  final bool live;

  /// Key of the line-up row for [playerId], for tests.
  static Key rowKey(int playerId) => ValueKey(('lineupRow', playerId));

  /// Below this width (the tablet's Pitch-mode column, about 256 wide) a
  /// row drops the energy figure and puts the markers under the name, so
  /// the name keeps about ten characters and no badge is ever cut.
  static const double narrowWidth = 280;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) => _list(context, narrow: c.maxWidth < narrowWidth),
  );

  Widget _list(BuildContext context, {required bool narrow}) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: EdgeInsets.all(narrow ? AppSpacing.md : AppSpacing.marginMobile),
      children: [
        if (live && ratings.isNotEmpty) ...[
          Text(
            l.matchLiveRatingsNote,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        _xi(context, homeCode, home, homeSubs, homeBench, narrow: narrow),
        const SizedBox(height: AppSpacing.lg),
        _xi(context, awayCode, away, awaySubs, awayBench, narrow: narrow),
      ],
    );
  }

  Widget? _badge(int playerId) => switch (ratings[playerId]) {
    final r? => RatingBadge(r, compact: true, motm: playerId == motmId),
    null => null,
  };

  Widget _xi(
    BuildContext context,
    String teamCode,
    List<Player> xi,
    List<MatchEvent> subs,
    List<Player> bench, {
    required bool narrow,
  }) {
    final l = AppLocalizations.of(context);
    // Anyone already on the pitch is no longer a substitute.
    final onPitch = {for (final p in xi) p.id};
    final remaining = [
      for (final p in bench)
        if (!onPitch.contains(p.id)) p,
    ];
    // The side's mean over everyone who has played, the subs it has
    // already made included.
    final played = {
      ...onPitch,
      for (final s in subs) ...[s.playerId, ?s.secondaryPlayerId],
    };
    final marks = [
      for (final id in played) ?ratings[id],
    ];
    final average = marks.isEmpty
        ? null
        : marks.reduce((a, b) => a + b) / marks.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              nationCodeLabel(teamCode),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            if (average != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l.matchAverageRating,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              RatingBadge(average, compact: true),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final p in xi)
          Padding(
            key: rowKey(p.id),
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(width: 36, child: TacticalChip(p.position.label)),
                const SizedBox(width: AppSpacing.sm),
                // The name and his markers share what the fixed columns
                // leave, the name first. In a narrow column the markers go
                // under the name instead of beside it.
                Expanded(
                  child: narrow
                      ? _nameOver(p, _markers(p.id))
                      : Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodyMedium,
                              ),
                            ),
                            if (_markers(p.id) case final marks
                                when marks.isNotEmpty)
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: marks,
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
                if (energy[p.id] case final e?) ...[
                  const SizedBox(width: AppSpacing.xs),
                  _EnergyPip(e, showFigure: !narrow),
                ],
                if (_badge(p.id) case final b?) ...[
                  const SizedBox(width: AppSpacing.sm),
                  b,
                ],
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 20,
                  child: Text(
                    '${p.overall}',
                    textAlign: TextAlign.end,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (subs.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.matchSubstitutions,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final s in subs) _subRow(s, onPitch),
        ],
        if (remaining.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.matchSubstitutes,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final p in remaining)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(width: 36, child: TacticalChip(p.position.label)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    child: Text(
                      '${p.overall}',
                      textAlign: TextAlign.end,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  /// A substitution: who came on (above) and who went off (below). A player
  /// not listed in the eleven above (the man taken off, or the opponent's
  /// newcomer) carries his rating here instead, so everyone who played has
  /// one on the tab. The badge sits outside the name, so a long name is cut
  /// and the badge never is.
  Widget _subRow(MatchEvent s, Set<int> listed) {
    // playerName is the player coming on, secondaryName the one going off
    // (see MatchEvent docs).
    Widget line(String arrow, Color arrowColor, String name, int? id) {
      final badge = id == null || listed.contains(id) ? null : _badge(id);
      return Row(
        children: [
          Text(
            arrow,
            style: AppTypography.bodySmall.copyWith(color: arrowColor),
          ),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: arrow == '▲ '
                    ? AppColors.onSurface
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: AppSpacing.xs),
            badge,
          ],
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Text(
              "${s.minute}'",
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const Icon(
            Icons.swap_horiz,
            size: 16,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                line('▲ ', AppColors.positive, s.playerName, s.playerId),
                line(
                  '▼ ',
                  AppColors.error,
                  s.secondaryName ?? '-',
                  s.secondaryPlayerId,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A narrow column's name cell: the name on its own line, whatever he has
  /// done so far in small marks under it.
  Widget _nameOver(Player p, List<Widget> marks) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        p.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodyMedium,
      ),
      if (marks.isNotEmpty)
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            key: ValueKey(('markersUnder', p.id)),
            mainAxisSize: MainAxisSize.min,
            children: marks.skip(1).toList(),
          ),
        ),
    ],
  );

  /// The small marks after a player's name for what the clock has shown him
  /// do: goals (a count past one), assists, his card, a knock, and coming on
  /// or going off.
  List<Widget> _markers(int id) {
    var goals = 0;
    var assists = 0;
    var cameOn = false;
    var wentOff = false;
    var injured = false;
    MatchCard? card;
    for (final e in events) {
      switch (e.type) {
        case MatchEventType.goal:
          if (e.playerId == id) goals++;
          if (e.assistPlayerId == id) assists++;
        case MatchEventType.yellowCard:
          if (e.playerId == id) card ??= MatchCard.yellow;
        case MatchEventType.redCard:
          if (e.playerId == id) {
            card = e.secondYellow ? MatchCard.secondYellow : MatchCard.red;
          }
        case MatchEventType.substitution:
          if (e.playerId == id) cameOn = true;
          if (e.secondaryPlayerId == id) wentOff = true;
        case MatchEventType.injury:
          if (e.playerId == id) injured = true;
      }
    }
    Widget counted(Widget icon, int n, Key key) => Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        if (n > 1)
          Text(
            '$n',
            style: AppTypography.labelSmall.copyWith(
              fontSize: 10,
              color: AppColors.onSurfaceVariant,
            ),
          ),
      ],
    );
    final marks = <Widget>[
      if (goals > 0)
        counted(
          const Icon(Icons.sports_soccer, size: 12, color: AppColors.primary),
          goals,
          ValueKey(('goalMark', id)),
        ),
      if (assists > 0)
        counted(
          const Icon(
            Icons.handshake_rounded,
            size: 12,
            color: AppColors.onSurfaceVariant,
          ),
          assists,
          ValueKey(('assistMark', id)),
        ),
      if (card case final c?)
        CardMark(c, size: 10, key: ValueKey(('cardMark', id))),
      if (injured)
        Icon(
          Icons.medical_services,
          size: 12,
          color: AppColors.warning,
          key: ValueKey(('injuryMark', id)),
        ),
      if (cameOn)
        Icon(
          Icons.arrow_upward_rounded,
          size: 12,
          color: AppColors.positive,
          key: ValueKey(('subOnMark', id)),
        ),
      if (wentOff)
        Icon(
          Icons.arrow_downward_rounded,
          size: 12,
          color: AppColors.error,
          key: ValueKey(('subOffMark', id)),
        ),
    ];
    return [
      for (final m in marks) ...[const SizedBox(width: 3), m],
    ];
  }
}

/// A compact battery-style energy pip: green when fresh, amber tiring, red when
/// spent — a cue that a player is ready to be subbed.
class _EnergyPip extends StatelessWidget {
  const _EnergyPip(this.energy, {this.showFigure = true});

  final int energy;

  /// The percentage beside the battery; a narrow column shows the battery,
  /// in its colour, alone.
  final bool showFigure;

  @override
  Widget build(BuildContext context) {
    final color = energyColor(energy);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.battery_charging_full, size: 12, color: color),
        if (showFigure) ...[
          const SizedBox(width: 2),
          Text(
            '$energy%',
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ],
    );
  }
}

/// A "player of the match" highlight card shown on the full-time stats tab.
class _MotmCard extends StatelessWidget {
  const _MotmCard({
    required this.name,
    required this.rating,
    required this.teamCode,
  });

  final String name;
  final double rating;
  final String teamCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: AppRadii.mdAll,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).matchPlayerOfTheMatch,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$name · ${nationCodeLabel(teamCode)}',
                  style: AppTypography.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          RatingBadge(rating),
        ],
      ),
    );
  }
}

/// A live momentum bar: a bold two-sided track where the home share (left,
/// primary) pushes against the away share (right, positive). The split, the
/// percentages and the pointer at the boundary all glide as the game swings.
class _MomentumBar extends StatelessWidget {
  const _MomentumBar({
    required this.homePercent,
    required this.homeCode,
    required this.awayCode,
    required this.homeColor,
    required this.awayColor,
  });

  final double homePercent; // 0..100
  final String homeCode;
  final String awayCode;

  /// The two nations' own colours, already separated from each other so a bar
  /// between two red teams still reads as two sides; see [KitClash.barColours].
  /// The bar used to be the app's blue against the app's green, which said
  /// nothing about who was who.
  final Color homeColor;
  final Color awayColor;

  static const _duration = Duration(milliseconds: 450);
  static const Curve _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final h = (homePercent / 100).clamp(0.0, 1.0);
    final homePct = homePercent.round();
    final leaningHome = h >= 0.5;
    final homeC = homeColor;
    final awayC = awayColor;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                nationCodeLabel(homeCode),
                style: AppTypography.labelMedium.copyWith(color: homeC),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$homePct%',
                style: AppTypography.labelMedium.copyWith(
                  color: leaningHome ? homeC : AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(l.matchMomentum, style: AppTypography.labelSmall),
              const Spacer(),
              Text(
                '${100 - homePct}%',
                style: AppTypography.labelMedium.copyWith(
                  color: leaningHome ? AppColors.onSurfaceVariant : awayC,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                nationCodeLabel(awayCode),
                style: AppTypography.labelMedium.copyWith(color: awayC),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: SizedBox(
              height: 16,
              child: Stack(
                children: [
                  // Away side fills the whole track; the home fill overlays it
                  // from the left, so the boundary is where momentum sits.
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0x33000000), awayC],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedFractionallySizedBox(
                      duration: _duration,
                      curve: _curve,
                      widthFactor: h,
                      alignment: Alignment.centerLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [homeC, const Color(0x33000000)],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // A bright pointer that rides the boundary between the sides.
                  Positioned.fill(
                    child: AnimatedAlign(
                      duration: _duration,
                      curve: _curve,
                      alignment: Alignment(h * 2 - 1, 0),
                      child: Container(
                        width: 3,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: AppRadii.smAll,
                          boxShadow: [
                            BoxShadow(
                              color: (leaningHome ? homeC : awayC).withValues(
                                alpha: 0.8,
                              ),
                              blurRadius: 6,
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
    );
  }
}

/// The animated "GOAL!" overlay shown briefly when a goal is scored.
class _GoalFlash extends StatelessWidget {
  const _GoalFlash({
    required this.event,
    required this.flagCode,
    required this.goalNumber,
  });

  final MatchEvent event;

  /// Goals so far in the match: tells two goals by one player in one
  /// minute apart.
  final int goalNumber;

  /// FIFA code of the team that scored, so the popup shows their flag.
  final String flagCode;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: TweenAnimationBuilder<double>(
            key: ValueKey((event.minute, event.playerId, goalNumber)),
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 320),
            curve: Curves.elasticOut,
            builder: (context, t, child) => Transform.scale(
              scale: 0.6 + t * 0.4,
              child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: AppRadii.lgAll,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlagDisc(flagCode, size: 44),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppLocalizations.of(context).matchGoalShout,
                    style: AppTypography.headlineLargeMobile.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    initialledName(event.playerName),
                    style: AppTypography.titleMedium,
                  ),
                  Text(
                    event.penalty
                        ? '${AppLocalizations.of(context).matchPenalty} · '
                              '${_eventClock(event)}'
                        : event.longThrow
                        ? '${AppLocalizations.of(context).matchGoalLongThrow}'
                              ' · ${_eventClock(event)}'
                        : _eventClock(event),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A blocking overlay shown when one of the manager's players is injured: the
/// clock is paused and the manager must decide whether to bring on a
/// replacement or play on. Dimmed scrim intercepts taps behind it.
/// A compact penalty-shootout summary shown under the score at full time: the
/// running pen tally and a row of scored/missed dots per side.
class _ShootoutStrip extends StatelessWidget {
  const _ShootoutStrip({
    required this.outcome,
    required this.homeCode,
    required this.awayCode,
    this.revealed = 1 << 30,
    this.homeTakers = const [],
    this.awayTakers = const [],
  });

  final KnockoutOutcome outcome;
  final String homeCode;
  final String awayCode;

  /// Each side's takers in order, so the strip can name whoever just stepped
  /// up. Cycled in sudden death, exactly as the kicks are.
  final List<String> homeTakers;
  final List<String> awayTakers;

  /// How many kicks (across both teams, home-first) have been taken so far —
  /// the strip reveals them one at a time as the shootout plays out live.
  final int revealed;

  @override
  Widget build(BuildContext context) {
    // Kicks alternate home-first: for `revealed` total, home has taken the
    // ceiling and away the floor of half.
    final homeShown = ((revealed + 1) ~/ 2).clamp(0, outcome.homeKicks.length);
    final awayShown = (revealed ~/ 2).clamp(0, outcome.awayKicks.length);
    final homeKicks = outcome.homeKicks.take(homeShown).toList();
    final awayKicks = outcome.awayKicks.take(awayShown).toList();
    final homePens = homeKicks.where((s) => s).length;
    final awayPens = awayKicks.where((s) => s).length;
    // Who just stepped up, and what happened — a shootout is a sequence of
    // individuals, not a row of anonymous dots.
    final lastIsHome = revealed.isOdd;
    final lastIndex = (lastIsHome ? homeShown : awayShown) - 1;
    final takers = lastIsHome ? homeTakers : awayTakers;
    final kicks = lastIsHome ? homeKicks : awayKicks;
    final lastName = lastIndex >= 0 && takers.isNotEmpty
        ? takers[lastIndex % takers.length]
        : null;
    final lastScored = lastIndex >= 0 && lastIndex < kicks.length
        ? kicks[lastIndex]
        : null;
    return Container(
      width: double.infinity,
      color: AppColors.surfaceContainerHigh,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).matchShootoutScore(
              homePens,
              awayPens,
            ),
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          _kicks(homeCode, homeKicks),
          const SizedBox(height: 2),
          _kicks(awayCode, awayKicks),
          if (lastName != null && lastScored != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              lastScored
                  ? AppLocalizations.of(
                      context,
                    ).matchShootoutKickScored(lastName)
                  : AppLocalizations.of(
                      context,
                    ).matchShootoutKickMissed(lastName),
              style: AppTypography.labelSmall.copyWith(
                color: lastScored ? AppColors.positive : AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _kicks(String code, List<bool> kicks) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 34,
        child: Text(
          nationCodeLabel(code),
          style: AppTypography.labelSmall,
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      for (final scored in kicks)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            scored ? Icons.circle : Icons.circle_outlined,
            size: 12,
            color: scored ? AppColors.positive : AppColors.error,
          ),
        ),
    ],
  );
}

/// The tab strip above the live match detail.
///
/// Its own widget, and PUBLIC, so a width test can pump the real strip rather
/// than a reconstruction of it: the three labels are fixed copy sharing a
/// phone's width between them, and Czech's are half again as long as English's
/// ("STATISTIKY" against "STATS").
///
/// [WholeText] rather than `Tab(text:)`, for the reason the substitution strip
/// uses it too: a tab that is cut, or broken into STATIS / TIKY, is not a tab.
/// A label too long for its third of a 320-wide phone scales down instead, and
/// [expectLegible] is the guard built for that.
///
/// In Pitch mode ([withTimeline] false) the pitch and its commentary line
/// stand in for the Timeline: Stats and Lineups only.
class MatchDetailTabs extends StatelessWidget {
  const MatchDetailTabs({this.withTimeline = true, super.key});

  final bool withTimeline;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabBar(
      labelColor: AppColors.onSurface,
      unselectedLabelColor: AppColors.onSurfaceVariant,
      indicatorColor: AppColors.primary,
      tabs: [
        for (final label in [
          if (withTimeline) l.matchTabTimeline,
          l.matchTabStats,
          l.matchTabLineups,
        ])
          Tab(
            child: WholeText(label, maxLines: 1, textAlign: TextAlign.center),
          ),
      ],
    );
  }
}

/// The half-time interval overlay: the score, a read of the first half, and the
/// team talk — each tone shown with what it does and a recommendation for the
/// current game state. The manager can reshape the side (Tactics) too.
///
/// PUBLIC for the same reason as [MatchDetailTabs]: the scoreline read back
/// ("You lead by 3 goals · 60% possession") is copy a width test measures.
class HalfTimePrompt extends StatelessWidget {
  const HalfTimePrompt({
    super.key,
    required this.heading,
    required this.homeCode,
    required this.awayCode,
    required this.homeScore,
    required this.awayScore,
    required this.playerIsHome,
    required this.possession,
    required this.subsUsed,
    required this.selectedTalk,
    required this.options,
    required this.onTalk,
    required this.onTactics,
    required this.onContinue,
    required this.maxSubs,
  });

  /// Which interval this is — half time, the break before extra time, or the
  /// turnaround midway through it.
  final String heading;

  final String homeCode;
  final String awayCode;
  final int homeScore;
  final int awayScore;
  final bool playerIsHome;
  final int possession;
  final int subsUsed;

  /// The substitutions allowed (see [maxSubsAllowed]): a friendly's whole
  /// bench, otherwise [kMaxSubs], one more at the extra-time breaks
  /// ([kMaxSubsExtraTime]). Required, so no interval falls back to five
  /// where the match allows more.
  final int maxSubs;
  final TeamTalkTone? selectedTalk;

  /// The tones offered this interval — a seeded, varied subset of the full set
  /// rather than every tone in a fixed order.
  final List<TeamTalkTone> options;
  final ValueChanged<TeamTalkTone> onTalk;
  final VoidCallback onTactics;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final diff = playerIsHome ? homeScore - awayScore : awayScore - homeScore;
    final state = diff > 0
        ? l10n.matchStateLead(diff)
        : diff < 0
        ? l10n.matchStateTrail(-diff)
        : l10n.matchStateLevel;
    final stateColor = diff > 0
        ? AppColors.positive
        : diff < 0
        ? AppColors.error
        : AppColors.onSurface;
    // The card is laid out so Continue is ALWAYS on screen.
    //
    // It used to be one scroll view around the whole card, with Continue at
    // the bottom of it. On a phone with the system font turned up, three talk
    // options whose blurbs wrap to two or three lines each ran the card past
    // the bottom of the screen, and the one action every interval ends with
    // was below the fold: the manager had to go looking for the way back to
    // his match. Now the header and the two buttons are fixed, only the talk
    // options scroll, and they take whatever height is left between them.
    // The type and the padding are a step smaller too, so on most phones
    // nothing scrolls at all.
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            constraints: const BoxConstraints(maxWidth: 420),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppRadii.lgAll,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  heading,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    // No tracking: its trailing gap pushes a centred caps
                    // heading ("PRODLOUŽENÍ · POLOČAS") off the middle.
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                // Centred on the dash, not as a block: each side takes an
                // equal half, so the dash sits on the card's centre line
                // whatever the two numbers are.
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlagDisc(homeCode, size: 24),
                          const SizedBox(width: AppSpacing.sm),
                          Text('$homeScore', style: _scoreStyle),
                        ],
                      ),
                    ),
                    Text(' – ', style: _scoreStyle),
                    Expanded(
                      child: Row(
                        children: [
                          Text('$awayScore', style: _scoreStyle),
                          const SizedBox(width: AppSpacing.sm),
                          FlagDisc(awayCode, size: 24),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$state · ${l10n.matchPossessionShare(possession)}',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(color: stateColor),
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.teamTalkHeading,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                // The only part that scrolls, and only when it must.
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final tone in options)
                          _TalkOption(
                            label: teamTalkLabel(l10n, tone),
                            blurb: teamTalkBlurb(l10n, tone),
                            effect: tone.effect,
                            selected: selectedTalk == tone,
                            onTap: () => onTalk(tone),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onTactics,
                    icon: const Icon(Icons.tune, size: 18),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        l10n.matchTacticsWithSubs(subsUsed, maxSubs),
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(
                  label: l10n.matchContinue,
                  icon: Icons.play_arrow_rounded,
                  height: 48,
                  onPressed: onContinue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The interval scoreline: a step down from the headline size it was, which
  /// is room the talk options need more than the score does.
  static final TextStyle _scoreStyle = AppTypography.titleMedium.copyWith(
    fontWeight: FontWeight.w700,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

/// One team-talk option in the half-time card: its label, what it asks for, and
/// the attack/defence swing it applies. No "suggested" hint — the manager reads
/// the game and decides.
class _TalkOption extends StatelessWidget {
  const _TalkOption({
    required this.label,
    required this.blurb,
    required this.effect,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String blurb;
  final (double, double) effect;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (atk, def) = effect;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.16)
            : AppColors.surfaceContainerHighest,
        borderRadius: AppRadii.baseAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.baseAll,
          child: Container(
            // Tighter than a list row: three of these sit between the score
            // and Continue, and every point of padding here is a point of
            // talk the manager has to scroll past on a small phone.
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm + AppSpacing.xs,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadii.baseAll,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 18,
                  color: selected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The body-small face rather than body-medium: the
                      // option's name is a word or two and reads fine a size
                      // down, set bold so it still leads its blurb.
                      Text(
                        label,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        blurb,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Effect shown as arrows, not numbers: green up for a lift, red
                // down for a cost — two arrows when the swing is bigger.
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _SwingArrows(label: l.matchSwingAtk, value: atk),
                    const SizedBox(height: 2),
                    _SwingArrows(label: l.matchSwingDef, value: def),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A team-talk effect shown as arrows instead of a number: one green up arrow
/// for a small lift, two for a bigger one; red down arrow(s) for a cost. A
/// neutral (zero) swing shows a single muted dash.
class _SwingArrows extends StatelessWidget {
  const _SwingArrows({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final magnitude = value.abs().round();
    final count = magnitude >= 3 ? 2 : 1;
    final up = value > 0;
    final color = magnitude == 0
        ? AppColors.onSurfaceVariant
        : up
        ? AppColors.positive
        : AppColors.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 4),
        if (magnitude == 0)
          Icon(Icons.remove_rounded, size: 14, color: color)
        else
          for (var i = 0; i < count; i++)
            Icon(
              up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 14,
              color: color,
            ),
      ],
    );
  }
}

/// The Pitch view's shape in Pitch mode on a phone: full width, the
/// proportions the ground was designed and checked at (390 x 280).
const double kPitchModeAspect = 390 / 280;

/// The commentary line's height under the pitch.
const double kPitchCommentaryHeight = 44;

/// The phone's Pitch mode, top to bottom: [head] (the occasion and the
/// score), the [pitch] full width at its own proportions, [under] it the
/// commentary, momentum and shootout, then the [tabBar] and the [tabs]'
/// content.
///
/// The head stays put, like the bottom bar: the score is never scrolled out
/// of sight. Everything under it scrolls as one page when it does not fit:
/// the pitch keeps its full size, and the tab content gets the whole screen
/// once the pitch has gone up, the tab bar pinned under the head. A drag
/// that starts on the pitch scrolls the page (the pitch has no drags of its
/// own). The pitch scrolled out of view is only not painted: it is still
/// built, so its clock, pauses and goal flash run on exactly as before.
class PitchModeColumn extends StatelessWidget {
  const PitchModeColumn({
    required this.head,
    required this.pitch,
    required this.under,
    required this.tabBar,
    required this.tabs,
    super.key,
  });

  final Widget head;
  final Widget pitch;
  final Widget under;
  final Widget tabBar;
  final Widget tabs;

  /// The key of the scrolling page under the head.
  static const Key scrollKey = Key('match.pitchModeScroll');

  @override
  Widget build(BuildContext context) => CustomMultiChildLayout(
    delegate: _PitchModeLayout(),
    // The head is painted last: the score bug's goal banner slides out
    // over the top of the pitch.
    children: [
      LayoutId(
        id: _PitchModePart.page,
        child: NestedScrollView(
          key: scrollKey,
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: AspectRatio(aspectRatio: kPitchModeAspect, child: pitch),
            ),
            SliverToBoxAdapter(child: under),
          ],
          // The tab bar heads the body, so once the page has scrolled the
          // pitch away it sits pinned at the top and the lists scroll under
          // it (each picks up the page's inner controller as its primary).
          body: Column(
            children: [
              ColoredBox(color: AppColors.surface, child: tabBar),
              Expanded(child: tabs),
            ],
          ),
        ),
      ),
      LayoutId(id: _PitchModePart.head, child: head),
    ],
  );
}

enum _PitchModePart { head, page }

class _PitchModeLayout extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final w = size.width;
    final h = size.height;
    final head = layoutChild(
      _PitchModePart.head,
      BoxConstraints(minWidth: w, maxWidth: w, maxHeight: h),
    ).height;
    layoutChild(
      _PitchModePart.page,
      BoxConstraints.tight(Size(w, math.max(0.0, h - head))),
    );
    positionChild(_PitchModePart.head, Offset.zero);
    positionChild(_PitchModePart.page, Offset(0, head));
  }

  @override
  bool shouldRelayout(_PitchModeLayout oldDelegate) => false;
}

/// Before kick-off, in the Timeline's place, for a manager who has never
/// chosen: watch on the Pitch or follow the Timeline. The choice is kept for
/// the next match, and the header switches it at any time.
class MatchViewChooser extends StatelessWidget {
  const MatchViewChooser({required this.onChoose, super.key});

  final ValueChanged<MatchViewMode> onChoose;

  static const Key pitchKey = Key('match.chooser.pitch');
  static const Key timelineKey = Key('match.chooser.timeline');

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget option({
      required Key key,
      required IconData icon,
      required String title,
      required String blurb,
      required MatchViewMode mode,
    }) => Expanded(
      child: Material(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadii.lgAll,
        child: InkWell(
          key: key,
          borderRadius: AppRadii.lgAll,
          onTap: () => onChoose(mode),
          child: Container(
            // Both options the same height in any language.
            constraints: const BoxConstraints(minHeight: 140),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: AppColors.primary),
                const SizedBox(height: AppSpacing.sm),
                WholeText(
                  title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  blurb,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: Column(
        children: [
          Text(
            l.matchViewChooseTitle,
            textAlign: TextAlign.center,
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              option(
                key: pitchKey,
                icon: Icons.stadium_outlined,
                title: l.matchViewPitch,
                blurb: l.matchViewPitchBlurb,
                mode: MatchViewMode.pitch,
              ),
              const SizedBox(width: AppSpacing.md),
              option(
                key: timelineKey,
                icon: Icons.format_list_bulleted_rounded,
                title: l.matchViewTimeline,
                blurb: l.matchViewTimelineBlurb,
                mode: MatchViewMode.timeline,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l.matchViewChooseHint,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// The one live commentary line under the pitch: the latest real moment's
/// line ([lineAt] the Pitch clock's time), faded in as it changes. It reads
/// the line only when a new one is in ([countAt]), not every frame.
class PitchCommentaryLine extends StatefulWidget {
  const PitchCommentaryLine({
    required this.clock,
    required this.countAt,
    required this.lineAt,
    super.key,
  });

  final PitchClock clock;

  /// How many lines are in by the clock's time (cheap: it runs every tick).
  final int Function(Duration t) countAt;
  final String? Function(Duration t) lineAt;

  @override
  State<PitchCommentaryLine> createState() => _PitchCommentaryLineState();
}

class _PitchCommentaryLineState extends State<PitchCommentaryLine> {
  String? _line;
  int _count = 0;

  /// Bumped for every new line, so a line worded the same as the one
  /// before it (one player scoring twice in a minute) still fades in.
  int _serial = 0;

  @override
  void initState() {
    super.initState();
    widget.clock.addListener(_onClock);
    _read();
  }

  @override
  void didUpdateWidget(PitchCommentaryLine old) {
    super.didUpdateWidget(old);
    if (!identical(old.clock, widget.clock)) {
      old.clock.removeListener(_onClock);
      widget.clock.addListener(_onClock);
    }
    // A new picture (a re-simulated match, a new speed) may word it again;
    // the same line stays put.
    final before = _line;
    _read();
    if (_line != before) _serial++;
  }

  @override
  void dispose() {
    widget.clock.removeListener(_onClock);
    super.dispose();
  }

  void _read() {
    final t = widget.clock.value;
    _count = widget.countAt(t);
    _line = widget.lineAt(t);
  }

  void _onClock() {
    if (widget.countAt(widget.clock.value) == _count) return;
    setState(() {
      final before = _line;
      _read();
      if (_line != before || _line != null) _serial++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = _line ?? AppLocalizations.of(context).matchFeedKickOff;
    return Container(
      width: double.infinity,
      height: kPitchCommentaryHeight,
      color: AppColors.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: Text(
          text,
          key: ValueKey(_serial),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: _line == null
                ? AppColors.onSurfaceVariant
                : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

/// The tablet's commentary feed: every line the Pitch view's commentary has
/// said so far, newest first. Rebuilt only when a new line comes in, not on
/// every frame of the clock.
class PitchCommentaryFeed extends StatefulWidget {
  const PitchCommentaryFeed({
    required this.clock,
    required this.countAt,
    required this.linesAt,
    super.key,
  });

  final PitchClock clock;

  /// How many lines are in by the clock's time (cheap: it runs every tick).
  final int Function(Duration t) countAt;

  /// All the lines in by the clock's time, oldest first.
  final List<String> Function(Duration t) linesAt;

  @override
  State<PitchCommentaryFeed> createState() => _PitchCommentaryFeedState();
}

class _PitchCommentaryFeedState extends State<PitchCommentaryFeed> {
  List<String> _lines = const [];
  int _count = 0;

  @override
  void initState() {
    super.initState();
    widget.clock.addListener(_onClock);
    _refresh();
  }

  @override
  void didUpdateWidget(PitchCommentaryFeed old) {
    super.didUpdateWidget(old);
    if (!identical(old.clock, widget.clock)) {
      old.clock.removeListener(_onClock);
      widget.clock.addListener(_onClock);
    }
    // A new picture (a re-simulated match, a new speed) may word them again.
    _refresh();
  }

  @override
  void dispose() {
    widget.clock.removeListener(_onClock);
    super.dispose();
  }

  void _refresh() {
    final t = widget.clock.value;
    _count = widget.countAt(t);
    _lines = widget.linesAt(t);
  }

  void _onClock() {
    if (widget.countAt(widget.clock.value) == _count) return;
    setState(_refresh);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (_lines.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Text(
          l.matchFeedKickOff,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return ListView.separated(
      key: const Key('match.pitchFeed'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      itemCount: _lines.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Text(
          _lines[_lines.length - 1 - i],
          style: AppTypography.bodyMedium.copyWith(
            color: i == 0 ? AppColors.onSurface : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// One side for [MatchFullTimeLineups]: the team as it kicked off, who came
/// off the bench, and how it is drawn.
@visibleForTesting
typedef FullTimeSide = ({
  int nationId,
  String code,
  MatchTeam team,
  List<Player> cameOn,
  List<Color>? kit,
  Map<int, MatchCard> cards,
});

/// The line-ups after the final whistle: one side at a time on the pitch, in
/// the shape it kicked off in, each man's match rating on his disc (the
/// player of the match starred), and whoever came off the bench in a row
/// under it with theirs. A toggle swaps the two sides, another swaps the
/// pitch for the full list ([list], the live line-ups as they stood).
///
/// The pitch is the tactics pitch the tablet's YOUR XI draws, read-only.
@visibleForTesting
class MatchFullTimeLineups extends StatefulWidget {
  const MatchFullTimeLineups({
    required this.home,
    required this.away,
    required this.ratings,
    required this.motmId,
    required this.playerNationId,
    required this.list,
    super.key,
  });

  final FullTimeSide home;
  final FullTimeSide away;
  final Map<int, double> ratings;
  final int? motmId;

  /// The manager's side, shown first.
  final int playerNationId;

  /// The list view, behind the toggle.
  final Widget list;

  static const Key pitchKey = Key('match.ftLineups.pitch');
  static const Key listToggleKey = Key('match.ftLineups.list');
  static const Key pitchToggleKey = Key('match.ftLineups.pitchToggle');
  static Key sideKey(int nationId) => ValueKey(('ftLineupsSide', nationId));
  static Key cameOnKey(int playerId) => ValueKey(('ftCameOn', playerId));

  @override
  State<MatchFullTimeLineups> createState() => _MatchFullTimeLineupsState();
}

class _MatchFullTimeLineupsState extends State<MatchFullTimeLineups> {
  late int _side = widget.playerNationId == widget.away.nationId
      ? widget.away.nationId
      : widget.home.nationId;
  bool _asList = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final side = _side == widget.away.nationId ? widget.away : widget.home;
    final toggles = Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: Row(
        children: [
          if (!_asList)
            for (final s in [widget.home, widget.away]) ...[
              _Toggle(
                key: MatchFullTimeLineups.sideKey(s.nationId),
                label: nationCodeLabel(s.code),
                selected: s.nationId == _side,
                onTap: () => setState(() => _side = s.nationId),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
          const Spacer(),
          _Toggle(
            key: MatchFullTimeLineups.pitchToggleKey,
            label: l.matchLineupsViewPitch,
            iconOnly: true,
            icon: Icons.sports_soccer_rounded,
            selected: !_asList,
            onTap: () => setState(() => _asList = false),
          ),
          const SizedBox(width: AppSpacing.xs),
          _Toggle(
            key: MatchFullTimeLineups.listToggleKey,
            label: l.matchLineupsViewList,
            iconOnly: true,
            icon: Icons.format_list_bulleted_rounded,
            selected: _asList,
            onTap: () => setState(() => _asList = true),
          ),
        ],
      ),
    );
    if (_asList) {
      return Column(
        children: [
          toggles,
          Expanded(child: widget.list),
        ],
      );
    }
    final team = side.team;
    final byId = {
      for (final p in team.xi) p.id: p,
      for (final p in side.cameOn) p.id: p,
    };
    final motm = byId[widget.motmId];
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      children: [
        toggles,
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: IgnorePointer(
                  child: TacticsPitch(
                    key: MatchFullTimeLineups.pitchKey,
                    formation: team.formation,
                    instructions: team.instructions,
                    fullBacks: team.fullBacks,
                    switches: team.switches,
                    lineup: [for (final p in team.xi) p.id],
                    byId: byId,
                    teamColors: side.kit,
                    cardsByPlayer: side.cards,
                    ratingByPlayer: widget.ratings,
                    motmId: widget.motmId,
                    onTapSlot: (_) {},
                    onSwap: (_, _) {},
                    onBenchIn: (_, _) {},
                  ),
                ),
              ),
            ),
          ),
        ),
        if (side.cameOn.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.matchLineupsCameOn,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final p in side.cameOn)
                      _CameOnChip(
                        key: MatchFullTimeLineups.cameOnKey(p.id),
                        player: p,
                        rating: widget.ratings[p.id],
                        motm: p.id == widget.motmId,
                      ),
                  ],
                ),
              ],
            ),
          ),
        if (motm != null && widget.ratings[motm.id] != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              0,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    '${l.ratingPlayerOfTheMatch}: ${motm.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A small pill choice for [MatchFullTimeLineups]' two toggles.
class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.iconOnly = false,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  /// Just the icon, [label] as its tooltip: the narrow tablet column has
  /// no room for the words beside the two sides' codes.
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.onPrimary : AppColors.onSurfaceVariant;
    final icon = this.icon;
    if (iconOnly && icon != null) {
      return Tooltip(
        message: label,
        child: Semantics(
          button: true,
          selected: selected,
          label: label,
          excludeSemantics: true,
          child: Material(
            color: selected
                ? AppColors.primary
                : AppColors.surfaceContainerHigh,
            borderRadius: AppRadii.baseAll,
            child: InkWell(
              borderRadius: AppRadii.baseAll,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Icon(icon, size: 16, color: fg),
              ),
            ),
          ),
        ),
      );
    }
    return Material(
      color: selected ? AppColors.primary : AppColors.surfaceContainerHigh,
      borderRadius: AppRadii.baseAll,
      child: InkWell(
        borderRadius: AppRadii.baseAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: fg),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                maxLines: 1,
                style: AppTypography.labelMedium.copyWith(color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A substitute who came on: his place, his surname and his rating.
class _CameOnChip extends StatelessWidget {
  const _CameOnChip({
    required this.player,
    required this.rating,
    required this.motm,
    super.key,
  });

  final Player player;
  final double? rating;
  final bool motm;

  @override
  Widget build(BuildContext context) {
    final r = rating;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadii.baseAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TacticalChip(player.position.label),
          const SizedBox(width: 6),
          Text(
            surnameOf(player.name),
            maxLines: 1,
            style: AppTypography.bodySmall,
          ),
          if (r != null) ...[
            const SizedBox(width: 6),
            RatingBadge(r, compact: true, motm: motm),
          ],
        ],
      ),
    );
  }
}

/// Key on the missed-penalty icon in a Timeline row.
const Key missedPenaltyMarkKey = Key('match.missedPenaltyMark');

/// A ball with a small red cross on it: a penalty that did not go in
/// (saved, missed or off the woodwork). Replaces a "MISSED" text chip.
class MissedPenaltyMark extends StatelessWidget {
  const MissedPenaltyMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      key: missedPenaltyMarkKey,
      width: 20,
      height: 18,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 1,
            child: Icon(
              Icons.sports_soccer,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 11, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
