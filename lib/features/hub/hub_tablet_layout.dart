part of 'hub_screen.dart';

/// The hub on a tablet: the mockup's dashboard. Data comes from the same
/// providers the phone hub watches; the only additions are the objectives
/// and the Y feed (kept alive by the hub State's own watch of
/// `satisfactionProvider` and `yUnreadCountProvider`, which resolves the feed
/// it counts) and the federation buildings (changed only on screens that
/// leave the hub).
class _HubTabletLayout extends ConsumerWidget {
  const _HubTabletLayout({required this.careerId, required this.onOpenGroup});

  final int careerId;
  final void Function(HubData hub) onOpenGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(hubDataProvider(careerId));
    final host = ref.watch(wcHostThemeProvider(careerId)).valueOrNull;
    final contHost = ref
        .watch(continentalHostThemeProvider(careerId))
        .valueOrNull;
    final isCampaign =
        ref.watch(activeCampaignProvider(careerId)).valueOrNull != null;
    return Scaffold(
      key: HubScreen.tabletLayoutKey,
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorState(
          message: l.hubCouldNotLoadSave('').trim(),
          onRetry: () => ref.invalidate(hubDataProvider(careerId)),
        ),
        data: (hub) {
          if (hub == null) return Center(child: Text(l.hubSaveNotFound));
          final nation = hub.nations[hub.career.nationId];
          String code(int id) => hub.nations[id]?.code ?? '??';
          final playerRank = ref
              .watch(playerRankProvider(careerId))
              .valueOrNull;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HubHeader(
                  code: nation?.code ?? '??',
                  nationName: nation?.name ?? '…',
                  managerName: hub.career.managerName,
                  date: AppDate.dayMonthYear(context, hub.career.inGameDate),
                  rank: playerRank?.rank,
                  movement: playerRank?.movement ?? 0,
                ),
                const SizedBox(height: AppSpacing.md),
                if (host?.active ?? false) ...[
                  WcHostBanner(theme: host!, code: code),
                  const SizedBox(height: AppSpacing.md),
                ] else if (contHost?.active ?? false) ...[
                  WcHostBanner(theme: contHost!, code: code),
                  const SizedBox(height: AppSpacing.md),
                ],
                // Every tile must report an intrinsic height: no lists, no
                // LayoutBuilder, no WholeText (see DashboardGrid).
                DashboardGrid(
                  tiles: [
                    if (isCampaign)
                      DashboardTile(
                        span: 12,
                        child: CampaignHubCard(careerId: careerId),
                      ),
                    DashboardTile(
                      span: 5,
                      child: _NextMatchPanel(
                        key: HubScreen.nextMatchPanelKey,
                        careerId: careerId,
                        hub: hub,
                      ),
                    ),
                    DashboardTile(
                      span: 4,
                      child: _GroupPanel(
                        careerId: careerId,
                        hub: hub,
                        onOpen: () => onOpenGroup(hub),
                      ),
                    ),
                    DashboardTile(
                      span: 3,
                      child: _BoardPanel(
                        key: TourKeys.hubBoard,
                        careerId: careerId,
                      ),
                    ),
                    DashboardTile(
                      span: 3,
                      child: _FormPanel(careerId: careerId, hub: hub),
                    ),
                    DashboardTile(
                      span: 5,
                      child: _InboxPanel(careerId: careerId),
                    ),
                    DashboardTile(
                      span: 4,
                      child: _YPanel(careerId: careerId),
                    ),
                    DashboardTile(
                      span: 12,
                      child: _FederationPanel(careerId: careerId),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// The current window's matches, the full schedule, and the two places a
/// manager goes before the next one. An opponent is held back until the draw
/// that decides him has been watched, as everywhere else (the rows gate
/// themselves).
class _NextMatchPanel extends StatelessWidget {
  const _NextMatchPanel({
    required this.careerId,
    required this.hub,
    super.key,
  });

  final int careerId;
  final HubData hub;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final champion = hub.championNationId;
    final Widget body;
    if (champion != null) {
      body = Column(
        children: [
          const Icon(Icons.emoji_events, color: AppColors.primary, size: 32),
          const SizedBox(height: AppSpacing.xs),
          Text(l.hubWorldChampions, style: TabletText.barMeta),
          const SizedBox(height: AppSpacing.xs),
          _Team(
            code: hub.nations[champion]?.code ?? '??',
            name: hub.nations[champion]?.name ?? l.hubUnknown,
          ),
          TextButton(
            onPressed: () => context.go('${Routes.cup}?careerId=$careerId'),
            child: Text(l.hubViewBracket),
          ),
        ],
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UpcomingRows(careerId: careerId),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () =>
                  context.push('${Routes.schedule}?careerId=$careerId'),
              child: Text(l.hubFullSchedule),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      context.go('${Routes.callUps}?careerId=$careerId'),
                  child: Text(l.sideCallUps, maxLines: 1),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      context.go('${Routes.tactics}?careerId=$careerId'),
                  child: Text(l.sideTactics, maxLines: 1),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Panel(title: l.hubUpcoming, child: body);
  }
}

class _Team extends StatelessWidget {
  const _Team({required this.code, required this.name});

  final String code;
  final String name;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      FlagDisc(code, size: 44),
      const SizedBox(height: 6),
      Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TabletText.barStrong,
      ),
    ],
  );
}

/// The group or ladder the manager is in, once its draw has been watched;
/// "to be drawn" before; the squad's state when there is no group at all.
class _GroupPanel extends ConsumerWidget {
  const _GroupPanel({
    required this.careerId,
    required this.hub,
    required this.onOpen,
  });

  final int careerId;
  final HubData hub;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final g = hub.group;
    if (g == null) {
      final morale = ref.watch(moraleProvider(careerId)).valueOrNull ?? 50;
      return Panel(
        title: l.hubSquadStatus,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Fact(label: l.hubAvgRating, value: '${hub.squadRating}'),
            const SizedBox(height: AppSpacing.xs),
            _Fact(label: l.hubMorale, value: moraleLabel(l, morale)),
          ],
        ),
      );
    }
    if (!hub.groupDrawWatched) {
      return Panel(
        title: competitionLabel(l, g.competition),
        child: Row(
          children: [
            const Icon(Icons.casino, color: AppColors.primary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(l.hubGroupsToBeDrawn, style: TabletText.cell),
            ),
          ],
        ),
      );
    }
    return Panel(
      title: competitionLabel(l, g.competition),
      action: PanelLink(label: l.panelViewAll, onTap: onOpen),
      child: _GroupTable(
        framed: false,
        careerId: careerId,
        group: g,
        playerNationId: hub.career.nationId,
        directCount: hub.groupDirectCount,
        contentionPos: hub.groupContentionPos,
        playoffNations: hub.groupPlayoffNations,
        relegateCount: hub.groupRelegateCount,
        code: (id) => hub.nations[id]?.code ?? '??',
        name: (id) => hub.nations[id]?.name ?? l.hubUnknown,
        onTap: onOpen,
      ),
    );
  }
}

/// The board's confidence and each objective's status, in short.
class _BoardPanel extends ConsumerWidget {
  const _BoardPanel({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final value = ref.watch(satisfactionProvider(careerId)).valueOrNull;
    final (color, verdict) = boardVerdict(l, value);
    final objectives =
        ref.watch(cycleObjectivesProvider(careerId)).valueOrNull ??
        const <CycleObjective>[];
    return Panel(
      title: l.sideBoard,
      action: PanelLink(
        label: l.panelViewAll,
        onTap: () => context.go('${Routes.boardObjectives}?careerId=$careerId'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.boardObjectivesConfidence,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.cell,
                ),
              ),
              if (value != null)
                Text(
                  '$value%',
                  style: TabletText.cellNumeric.copyWith(color: color),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _Bar(fraction: (value ?? 0) / 100, color: color),
          // The verdict only once there is a figure: without one,
          // boardVerdict's placeholder is a dash, not a word.
          if (value != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(verdict, style: TabletText.barMeta.copyWith(color: color)),
          ],
          for (final o in objectives) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(o.label, style: TabletText.cell),
            Text(
              objectiveStatusLabel(l, o),
              style: TabletText.barMeta.copyWith(
                color: objectiveStatusColor(o),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The last five results as pills, newest on the right, and the last three
/// spelled out.
class _FormPanel extends StatelessWidget {
  const _FormPanel({required this.careerId, required this.hub});

  final int careerId;
  final HubData hub;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = hub.career.nationId;
    final recent = hub.recentResults.take(5).toList();
    int sign(Fixture f) {
      final mine = f.homeNationId == me ? f.homeScore! : f.awayScore!;
      final theirs = f.homeNationId == me ? f.awayScore! : f.homeScore!;
      return (mine - theirs).sign;
    }

    return Panel(
      title: l.playerStatForm,
      action: PanelLink(
        label: l.panelViewAll,
        onTap: () => context.go('${Routes.results}?careerId=$careerId'),
      ),
      child: recent.isEmpty
          ? Text(l.matchDossierNoGames, style: TabletText.barMeta)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    for (final f in recent.reversed) ...[
                      Expanded(child: _FormPill(result: sign(f))),
                      if (f != recent.first) const SizedBox(width: 6),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final f in recent.take(3))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        FlagDisc(
                          hub
                                  .nations[f.homeNationId == me
                                      ? f.awayNationId
                                      : f.homeNationId]
                                  ?.code ??
                              '??',
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            hub
                                    .nations[f.homeNationId == me
                                        ? f.awayNationId
                                        : f.homeNationId]
                                    ?.name ??
                                l.hubUnknown,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TabletText.cell,
                          ),
                        ),
                        Text(
                          '${f.homeScore}-${f.awayScore}',
                          style: TabletText.cellNumeric,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

/// W, D or L, as the scouting dossier writes it.
class _FormPill extends StatelessWidget {
  const _FormPill({required this.result});

  /// +1 win, 0 draw, -1 loss.
  final int result;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (result) {
      > 0 => ('W', AppColors.positive),
      < 0 => ('L', AppColors.error),
      _ => ('D', AppColors.outline),
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        label,
        style: TabletText.cellNumeric.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// The five newest messages. A tap opens the inbox.
class _InboxPanel extends ConsumerWidget {
  const _InboxPanel({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // The same provider the hub's unread badge already keeps alive.
    final messages =
        ref.watch(messageInboxProvider(careerId)).valueOrNull?.messages ??
        const <MessageItem>[];
    void open() => context.go('${Routes.messages}?careerId=$careerId');
    return Panel(
      title: l.sideInbox,
      padding: EdgeInsets.zero,
      action: PanelLink(label: l.panelViewAll, onTap: open),
      child: messages.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l.messagesNoMessagesYet, style: TabletText.barMeta),
            )
          : Column(
              children: [
                for (final m in messages.take(5))
                  InkWell(
                    onTap: open,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.divider),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: m.read
                                  ? AppColors.outlineVariant
                                  : messageStyle(m.category).color,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              readMessage(l, m).title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TabletText.cell,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text('${m.year}', style: TabletText.barMeta),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// The two newest stories on Y. Drawn here rather than with `YPostTile`,
/// which is built on WholeText (a LayoutBuilder) and would assert inside the
/// dashboard's IntrinsicHeight rows.
class _YPanel extends ConsumerWidget {
  const _YPanel({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // Kept alive by the hub State's watch of yUnreadCountProvider, which
    // reads this feed to count.
    final posts = [
      for (final p
          in ref.watch(yFeedProvider(careerId)).valueOrNull?.posts ??
              const <YPost>[])
        if (p.replyTo == null) p,
    ].take(2).toList();
    void open() => context.go('${Routes.y}?careerId=$careerId');
    return Panel(
      title: l.navY,
      action: PanelLink(label: l.panelViewAll, onTap: open),
      child: posts.isEmpty
          ? Text(l.yEmpty, style: TabletText.barMeta)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final p in posts)
                  InkWell(
                    onTap: open,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: p.displayName,
                                  style: TabletText.barStrong,
                                ),
                                TextSpan(
                                  text: '  ${p.handle}',
                                  style: TabletText.barMeta,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            yPostBody(l, p),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TabletText.cell.copyWith(
                              color: AppColors.onSurfaceVariant,
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

/// What the federation can spend, and each department's building level.
class _FederationPanel extends ConsumerWidget {
  const _FederationPanel({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final funds = ref.watch(federationFundsProvider(careerId)).valueOrNull;
    final buildings =
        ref.watch(federationBuildingsProvider(careerId)).valueOrNull ??
        const <DepartmentBuilding>[];
    return Panel(
      title: l.sideGroupFederation,
      action: PanelLink(
        label: l.panelViewAll,
        onTap: () => context.go('${Routes.finances}?careerId=$careerId'),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _Figure(
              label: l.federationFreeToSpend,
              value: formatEuros(funds?.free ?? 0),
            ),
          ),
          for (final b in buildings) ...[
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _Figure(
                label: departmentLabel(l, b.department),
                value: l.federationLevelBadge(b.level),
                fraction: b.level / FederationBuildings.maxLevel,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value, this.fraction});

  final String label;
  final String value;
  final double? fraction;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TabletText.header,
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: TabletText.cellNumeric.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      if (fraction != null) ...[
        const SizedBox(height: AppSpacing.xs),
        _Bar(fraction: fraction!, color: AppColors.primary, height: 4),
      ],
    ],
  );
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(label, style: TabletText.cell)),
      Text(value, style: TabletText.barStrong),
    ],
  );
}

/// A thin filled bar. FractionallySizedBox rather than a progress indicator:
/// it reports an intrinsic height, which a dashboard tile needs.
class _Bar extends StatelessWidget {
  const _Bar({required this.fraction, required this.color, this.height = 6});

  final double fraction;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadii.smAll,
    child: Stack(
      children: [
        Container(height: height, color: AppColors.surfaceContainerHighest),
        FractionallySizedBox(
          widthFactor: fraction.clamp(0.0, 1.0),
          child: Container(height: height, color: color),
        ),
      ],
    ),
  );
}
