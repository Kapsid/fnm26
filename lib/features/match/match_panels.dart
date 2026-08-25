part of 'match_screen.dart';

/// What the manager reads while the game runs: the timeline, the box score,
/// the two line-ups, momentum, and the moments that interrupt — a goal, a
/// shootout, half time.
class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.events,
    required this.live,
    required this.homeId,
  });
  final List<MatchEvent> events;
  final bool live;
  final int homeId;

  @override
  Widget build(BuildContext context) {
    // Substitutions are shown on the Lineups tab, not in the event feed.
    final visible = events
        .where((e) => e.type != MatchEventType.substitution)
        .toList();
    if (visible.isEmpty) {
      return Center(
        child: Text(
          live ? 'Kick-off!' : 'No events yet.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    // Most recent at the top.
    final reversed = visible.reversed.toList();
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        for (final e in reversed)
          _TimelineRow(event: e, isHome: e.teamNationId == homeId),
      ],
    );
  }
}

/// One event on a two-sided timeline: home events sit on the left, away on the
/// right, with the minute down the centre spine.
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.isHome});

  final MatchEvent event;
  final bool isHome;

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
            child: Text(_eventClock(event), style: AppTypography.labelSmall),
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
    final isGoal = event.type == MatchEventType.goal;
    final iconData = switch (event.type) {
      MatchEventType.goal => Icons.sports_soccer,
      MatchEventType.substitution => Icons.swap_horiz,
      MatchEventType.yellowCard ||
      MatchEventType.redCard => Icons.square_rounded,
      MatchEventType.injury => Icons.medical_services,
    };
    final iconColor = switch (event.type) {
      MatchEventType.goal => AppColors.primary,
      MatchEventType.yellowCard => _yellowCard,
      MatchEventType.redCard => _redCard,
      _ => AppColors.onSurfaceVariant,
    };
    // A second booking shows both cards, the way it happened; a straight red
    // shows one. The manager can tell at a glance which one cost him the man.
    final icon = event.type == MatchEventType.redCard && event.secondYellow
        ? const _SecondYellowIcon()
        : Icon(iconData, size: 16, color: iconColor);
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
    final text = Flexible(
      child: Text(
        label,
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodyMedium.copyWith(
          color: isGoal ? AppColors.onSurface : AppColors.onSurfaceVariant,
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

const Color _yellowCard = Color(0xFFEFC94C);
const Color _redCard = Color(0xFFD64545);

/// The two-card mark of a second booking: the yellow he was already on, with
/// the red that followed it overlapping in front.
class _SecondYellowIcon extends StatelessWidget {
  const _SecondYellowIcon();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 22,
    height: 16,
    child: Stack(
      children: [
        Positioned(
          left: 0,
          child: Icon(Icons.square_rounded, size: 14, color: _yellowCard),
        ),
        Positioned(
          right: 0,
          child: Icon(Icons.square_rounded, size: 16, color: _redCard),
        ),
      ],
    ),
  );
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

class _StatsLocked extends StatelessWidget {
  const _StatsLocked();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).matchStatsAtFullTime,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({
    required this.result,
    required this.homeCode,
    required this.awayCode,
    required this.homeNationId,
    required this.ground,
    required this.neutral,
    required this.groundCode,
  });
  final bool neutral;
  final String groundCode;
  final MatchResult result;
  final String homeCode;
  final String awayCode;
  final int homeNationId;
  final MatchGround ground;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final motm = result.manOfTheMatch;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        GroundCard(
          ground: ground,
          neutral: neutral,
          groundNationCode: groundCode,
        ),
        const SizedBox(height: AppSpacing.lg),
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
            Text(homeCode, style: AppTypography.labelMedium),
            Text(awayCode, style: AppTypography.labelMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _StatBar(
          label: l.tacticsInstrPossession,
          home: result.homePossession,
          away: result.awayPossession,
          suffix: '%',
        ),
        _StatBar(
          label: l.matchStatShots,
          home: result.homeShots,
          away: result.awayShots,
        ),
        _XgBar(home: result.homeXg, away: result.awayXg),
        if (result.ratings.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppLocalizations.of(context).matchPlayerRatings,
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
            teamCode,
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
                  _RatingPill(r.rating),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$home$suffix', style: AppTypography.labelMedium),
              Text(
                label.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text('$away$suffix', style: AppTypography.labelMedium),
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

class _Lineups extends StatelessWidget {
  const _Lineups({
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

  /// Per-player match ratings, keyed by player id. Empty until full time.
  final Map<int, double> ratings;

  /// Per-player remaining energy (0–100) at full time, keyed by player id.
  final Map<int, int> energy;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        _xi(context, homeCode, home, homeSubs, homeBench),
        const SizedBox(height: AppSpacing.lg),
        _xi(context, awayCode, away, awaySubs, awayBench),
      ],
    );
  }

  Widget _xi(
    BuildContext context,
    String teamCode,
    List<Player> xi,
    List<MatchEvent> subs,
    List<Player> bench,
  ) {
    // Anyone already on the pitch is no longer a substitute.
    final onPitch = {for (final p in xi) p.id};
    final remaining = [
      for (final p in bench)
        if (!onPitch.contains(p.id)) p,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          teamCode,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final p in xi)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(width: 36, child: TacticalChip(p.position.label)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(p.name, style: AppTypography.bodyMedium),
                ),
                if (energy[p.id] case final e?) ...[
                  _EnergyPip(e),
                  const SizedBox(width: AppSpacing.sm),
                ],
                if (ratings[p.id] case final r?) ...[
                  _RatingPill(r),
                  const SizedBox(width: AppSpacing.sm),
                ],
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
            AppLocalizations.of(context).matchSubstitutions,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final s in subs)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
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
                  // playerName is the player coming on, secondaryName the one
                  // going off (see MatchEvent docs).
                  Expanded(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: AppTypography.bodySmall,
                        children: [
                          const TextSpan(
                            text: '▲ ',
                            style: TextStyle(color: AppColors.positive),
                          ),
                          TextSpan(text: s.playerName),
                          const TextSpan(text: '   '),
                          const TextSpan(
                            text: '▼ ',
                            style: TextStyle(color: AppColors.error),
                          ),
                          TextSpan(
                            text: s.secondaryName ?? '—',
                            style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        if (remaining.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppLocalizations.of(context).matchSubstitutes,
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
}

/// A coloured match-rating badge: green for a strong game, red for a poor one.
/// A compact battery-style energy pip: green when fresh, amber tiring, red when
/// spent — a cue that a player is ready to be subbed.
class _EnergyPip extends StatelessWidget {
  const _EnergyPip(this.energy);

  final int energy;

  @override
  Widget build(BuildContext context) {
    final color = energyColor(energy);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.battery_charging_full, size: 12, color: color),
        const SizedBox(width: 2),
        Text(
          '$energy%',
          style: AppTypography.labelSmall.copyWith(
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill(this.rating);

  final double rating;

  static Color colorFor(double r) => AppColors.ratingColor(r);

  @override
  Widget build(BuildContext context) {
    final color = colorFor(rating);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        rating.toStringAsFixed(1),
        style: AppTypography.labelMedium.copyWith(
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
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
                  '$name · $teamCode',
                  style: AppTypography.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _RatingPill(rating),
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
  /// between two red teams still reads as two sides — see [KitColors.opposed].
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
                homeCode,
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
                awayCode,
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
  const _GoalFlash({required this.event, required this.flagCode});

  final MatchEvent event;

  /// FIFA code of the team that scored, so the popup shows their flag.
  final String flagCode;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: TweenAnimationBuilder<double>(
            key: ValueKey('${event.minute}-${event.playerId}'),
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
                  Text(event.playerName, style: AppTypography.titleMedium),
                  Text(
                    event.penalty
                        ? 'PENALTY · ${_eventClock(event)}'
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
              '$lastName: ${lastScored ? 'SCORED' : 'MISSED'}',
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
          code,
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

/// The half-time interval overlay: the score, a read of the first half, and the
/// team talk — each tone shown with what it does and a recommendation for the
/// current game state. The manager can reshape the side (Tactics) too.
class _HalfTimePrompt extends StatelessWidget {
  const _HalfTimePrompt({
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
        ? 'You lead by ${diff == 1 ? 'a goal' : '$diff goals'}'
        : diff < 0
        ? 'You trail by ${-diff == 1 ? 'a goal' : '${-diff} goals'}'
        : 'It\'s all square';
    final stateColor = diff > 0
        ? AppColors.positive
        : diff < 0
        ? AppColors.error
        : AppColors.onSurface;
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black54,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.lg),
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
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlagDisc(homeCode, size: 28),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '$homeScore – $awayScore',
                        style: AppTypography.headlineMedium,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      FlagDisc(awayCode, size: 28),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$state · $possession% possession',
                    style: AppTypography.bodySmall.copyWith(color: stateColor),
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                  for (final tone in options)
                    _TalkOption(
                      label: teamTalkLabel(l10n, tone),
                      blurb: teamTalkBlurb(l10n, tone),
                      effect: tone.effect,
                      selected: selectedTalk == tone,
                      onTap: () => onTalk(tone),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onTactics,
                          icon: const Icon(Icons.tune, size: 18),
                          label: Text(
                            l10n.matchTacticsWithSubs(subsUsed, kMaxSubs),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.outlineVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PrimaryButton(
                    label: l10n.matchContinue,
                    icon: Icons.play_arrow_rounded,
                    onPressed: onContinue,
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
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.16)
            : AppColors.surfaceContainerHighest,
        borderRadius: AppRadii.baseAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.baseAll,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
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
                      Text(label, style: AppTypography.bodyMedium),
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
