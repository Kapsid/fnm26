import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/hub/board_objectives_screen.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/messages/message_popup.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/messages/message_sheet.dart' show messageStyle;
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/features/y/y_screen.dart' show yPostBody;
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'hub_tablet_layout.dart';

/// In-game home ("National Hub"): continue/play, calendar, next match, squad
/// status, and the group table, with the in-game bottom navigation.
class HubScreen extends ConsumerStatefulWidget {
  const HubScreen({required this.careerId, super.key});

  final int careerId;

  static const Key tabletLayoutKey = Key('hub.tabletLayout');
  static const Key nextMatchPanelKey = Key('hub.tablet.nextMatch');

  @override
  ConsumerState<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends ConsumerState<HubScreen> {
  /// Guards against a second run while a sheet is already up — the hub rebuilds
  /// often, and each rebuild would otherwise stack another popup.
  bool _popping = false;

  /// True from the moment the offer is scheduled until it has been answered
  /// (or deferred because something else was on screen).
  ///
  /// Cleared in [_offerTour]'s `finally`, so a deferred offer is retried on
  /// the next rebuild instead of being lost for the rest of the session.
  bool _offeringTour = false;

  /// Whether unread news must wait because of the walk through.
  ///
  /// News and the tour used to race on a new save's first hub frame: both are
  /// post-frame callbacks, and the news one spends a few awaits syncing before
  /// it shows anything, so the offer won the guard check and the news popup
  /// then landed on top of it (or under it, whichever lost). Accept the tour
  /// with news still up and it got worse: the tour's overlay sits above the
  /// Navigator, so the news dialog stayed UNDER the scrim, covering the
  /// control being lit and untappable behind the AbsorbPointer, and the
  /// tour's first `go` to another screen tore it down (a dialog is a pageless
  /// route on the hub page), after which the batch was marked read unseen.
  ///
  /// So news waits while the offer is pending or open, and for as long as the
  /// tour runs. It stays unread meanwhile, and pops once the offer is declined
  /// (see [_offerTour]) or the tour ends (the hub watches [tourStepProvider],
  /// and finishing or skipping lands back on the hub anyway).
  bool get _tourHoldsNews =>
      _offeringTour ||
      !ref.read(tourOfferedProvider) ||
      ref.read(tourStepProvider) != null;

  /// Asks, once ever, whether the manager wants showing around.
  ///
  /// Recorded whatever the answer is: "no thanks" is an answer, and asking it
  /// again would make an offer into a nag. Settings is the way back in.
  Future<void> _offerTour() async {
    var started = false;
    try {
      // Something else is up (an action's own popup, or news that got in
      // before the stored flag had loaded). Not recorded as offered, so the
      // next rebuild, which that popup's own invalidations bring, asks again.
      if (!mounted || appPopupBusy) return;
      started = await _askTour();
    } finally {
      _offeringTour = false;
      // Declined (or never asked): the news that waited for the answer goes
      // now. Accepted: it keeps waiting for the tour to end.
      if (mounted && !started) unawaited(_popMessages());
    }
  }

  /// Puts the question; true when the tour was started.
  Future<bool> _askTour() async {
    final l = AppLocalizations.of(context);
    await markTourOffered(ref);
    if (!mounted) return false;
    final wants = await showAppPopup<bool>(
      context: context,
      builder: (popupContext) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.tourOfferTitle,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l.tourOfferBody, style: AppTypography.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: l.tourOfferYes,
              onPressed: () => Navigator.of(popupContext).pop(true),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: () => Navigator.of(popupContext).pop(false),
              child: Text(l.tourOfferNo),
            ),
          ],
        ),
      ),
    );
    if (!mounted || !(wants ?? false)) return false;
    startTour(ref, careerId);
    return true;
  }

  int get careerId => widget.careerId;

  /// Opens the competition [hub]'s group belongs to: the Nations Cup, the
  /// World Championship for its qualifiers and finals, else the manager's
  /// continental cup.
  void _openGroup(BuildContext context, HubData hub) {
    final comp = hub.group!.competition;
    final conf = hub.nations[hub.career.nationId]?.confederation;
    // Any of the three cups (Europe's, North America's, Africa's): his own,
    // which the screen opens on.
    if (hub.group!.kind == CompetitionKind.nationsLeague ||
        NationsCups.isNationsCup(comp)) {
      context.go('${Routes.nationsCup}?careerId=$careerId');
      return;
    }
    final isWc = comp == 'World Cup Qualifiers' || comp == 'World Championship';
    context.go(
      isWc || conf == null
          ? '${Routes.cup}?careerId=$careerId'
          : '${Routes.continental}?careerId=$careerId&conf=${conf.name}',
    );
  }

  /// Pops any unread news over the hub. Driven from here rather than from each
  /// action because everything returns to the hub — a match, a draw, a stepped
  /// tournament round — so this catches them all in one place.
  Future<void> _popMessages() async {
    // Wait if an action is already showing its own popup: stepping a final
    // fires the champion news and the final's result together, and racing them
    // buries one behind the other. That path pops the news itself when done.
    // And while the walk through is being offered or is running: see
    // [_tourHoldsNews].
    if (_popping || appPopupBusy || !mounted || _tourHoldsNews) return;
    _popping = true;
    try {
      if (mounted) await showUnreadMessagePopups(context, ref, careerId);
    } finally {
      _popping = false;
      // An offer that arrived while this was on screen deferred itself; give
      // it the rebuild it retries on, now the screen is clear.
      if (mounted && !ref.read(tourOfferedProvider)) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(hubDataProvider(careerId));
    final host = ref.watch(wcHostThemeProvider(careerId)).valueOrNull;
    // The continental cup gets the same host re-skin as the World Cup. Only one
    // can be live at a time, and the World Cup wins if they ever overlap.
    final contHost = ref
        .watch(continentalHostThemeProvider(careerId))
        .valueOrNull;
    final unread = ref.watch(unreadMessagesProvider(careerId)).valueOrNull ?? 0;
    // What the world has said since the manager last looked.
    final yUnread = ref.watch(yUnreadCountProvider(careerId)).valueOrNull ?? 0;

    // Watched so the hub rebuilds when the tour ends, which is what lets the
    // news it held back through [_tourHoldsNews] pop.
    ref.watch(tourStepProvider);

    // Achievements the last step unlocked, shown with its news.
    final pendingAchievements = ref
        .watch(pendingAchievementUnlocksProvider(careerId))
        .isNotEmpty;

    // Surface news the moment it lands, rather than leaving it to be found.
    if ((unread > 0 || pendingAchievements) && !_popping) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _popMessages());
    }

    // The offer of a walk through, made once ever. The hub is where it
    // belongs: every path into a save ends here — a new career, an imported
    // one, a start from the bottom — so one hook catches them all.
    if (!ref.watch(tourOfferedProvider) && !_offeringTour) {
      _offeringTour = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _offerTour());
    }

    // The popups above run for both layouts; only the drawing differs.
    if (TabletShellScope.isActive(context)) {
      return _HubTabletLayout(
        careerId: careerId,
        onOpenGroup: (hub) => _openGroup(context, hub),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.home),
        ),
        // One line, shrunk to fit rather than wrapped. The title shares the bar
        // with a back button and four actions, which leaves it roughly 160dp
        // on a 412dp phone; "NÁRODNÍ CENTRÁLA" in the tracked mono face needs
        // more than that once the system font is enlarged, and a wrapped title
        // spills out of the toolbar's height. A title is a label, not reading
        // matter, so a few percent smaller beats two lines.
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            l.hubNationalHub,
            maxLines: 1,
            softWrap: false,
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: l.hubMessages,
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.mail_outline, color: AppColors.primary),
            ),
            onPressed: () =>
                context.go('${Routes.messages}?careerId=$careerId'),
          ),
          IconButton(
            tooltip: l.navY,
            icon: Badge(
              isLabelVisible: yUnread > 0,
              label: Text('$yUnread'),
              child: const Icon(Icons.tag, color: AppColors.primary),
            ),
            onPressed: () => context.push('${Routes.y}?careerId=$careerId'),
          ),
          IconButton(
            tooltip: l.managerTitle,
            icon: const Icon(
              Icons.badge_outlined,
              color: AppColors.primary,
            ),
            onPressed: () =>
                context.push('${Routes.manager}?careerId=$careerId'),
          ),
          IconButton(
            tooltip: l.homeSettings,
            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
            // push (not go) so Settings' back button returns to the hub.
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        careerId: careerId,
        current: AppTab.hub,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorState(
          message: l.hubCouldNotLoadSave('').trim(),
          onRetry: () => ref.invalidate(hubDataProvider(careerId)),
        ),
        data: (hub) {
          if (hub == null) {
            return Center(child: Text(l.hubSaveNotFound));
          }
          final nation = hub.nations[hub.career.nationId];
          final date = AppDate.dayMonthYear(context, hub.career.inGameDate);
          String code(int id) => hub.nations[id]?.code ?? '??';
          String name(int id) => hub.nations[id]?.name ?? l.hubUnknown;
          // Hide the opponent and group table until the draw has been watched.
          final drawWatched = hub.nextDrawWatched;
          // The same figure the world ranking screen shows, read from the same
          // provider: two screens quoting different movement for one nation is
          // a bug the manager reports as "which one is right?".
          final playerRank = ref
              .watch(playerRankProvider(careerId))
              .valueOrNull;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              HubHeader(
                code: nation?.code ?? '??',
                nationName: nation?.name ?? '…',
                managerName: hub.career.managerName,
                date: date,
                rank: playerRank?.rank,
                movement: playerRank?.movement ?? 0,
              ),
              const SizedBox(height: AppSpacing.md),
              // Host-nation strip while a finals is under way — the World Cup,
              // or the continental championship when that's the live one.
              if (host?.active ?? false) ...[
                WcHostBanner(theme: host!, code: code),
                const SizedBox(height: AppSpacing.md),
              ] else if (contHost?.active ?? false) ...[
                WcHostBanner(theme: contHost!, code: code),
                const SizedBox(height: AppSpacing.md),
              ],
              if (hub.championNationId != null) ...[
                _ChampionBanner(
                  name: name(hub.championNationId!),
                  code: code(hub.championNationId!),
                  onView: () => context.go('${Routes.cup}?careerId=$careerId'),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              // The press, when they have something to ask. A card, not a
              // forced step: it waits, and it goes away on its own if the
              // manager would rather not talk.
              _BoardFinanceCard(
                key: TourKeys.hubBoard,
                careerId: careerId,
                onFinances: () =>
                    context.go('${Routes.finances}?careerId=$careerId'),
                onObjectives: () => context.go(
                  '${Routes.boardObjectives}?careerId=$careerId',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // The primary action is whatever the next timeline event is
              // (a draw, the next match, a tournament to follow, or rollover).
              HubEventButton(careerId: careerId),
              if (hub.championNationId == null && drawWatched) ...[
                const SizedBox(height: AppSpacing.md),
                _NextMatch(next: hub.next, code: code),
              ],
              const SizedBox(height: AppSpacing.md),
              _SquadStatus(
                rating: hub.squadRating,
                size: hub.squadSize,
                morale: ref.watch(moraleProvider(careerId)).valueOrNull ?? 50,
                onManage: () =>
                    context.go('${Routes.tactics}?careerId=$careerId'),
              ),
              const SizedBox(height: AppSpacing.md),
              // Always show the next group — but only reveal the table once its
              // own draw has been watched; before then it's "to be drawn".
              if (hub.group != null)
                if (hub.groupDrawWatched)
                  _GroupTable(
                    group: hub.group!,
                    playerNationId: hub.career.nationId,
                    directCount: hub.groupDirectCount,
                    contentionPos: hub.groupContentionPos,
                    relegateCount: hub.groupRelegateCount,
                    code: code,
                    name: name,
                    onTap: () => _openGroup(context, hub),
                  )
                else
                  _GroupPlaceholder(competition: hub.group!.competition),
              const SizedBox(height: AppSpacing.lg),
            ],
          );
        },
      ),
    );
  }
}

class _ChampionBanner extends StatelessWidget {
  const _ChampionBanner({
    required this.name,
    required this.code,
    required this.onView,
  });

  final String name;
  final String code;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        children: [
          const Icon(Icons.emoji_events, color: AppColors.primary, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.hubWorldChampions,
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlagDisc(code, size: 28),
              const SizedBox(width: AppSpacing.sm),
              Text(name, style: AppTypography.headlineMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(onPressed: onView, child: Text(l.hubViewBracket)),
        ],
      ),
    );
  }
}

/// The strip's buttons: short enough that two of them plus the confidence
/// figure read as one line of status rather than three stacked controls.
final ButtonStyle _stripButton = OutlinedButton.styleFrom(
  foregroundColor: AppColors.primary,
  side: const BorderSide(color: AppColors.outlineVariant),
  textStyle: AppTypography.labelSmall,
  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
  minimumSize: const Size(0, 32),
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

/// A single compact strip: board confidence (shown immediately, colour-coded)
/// on the left, the federation funds as a button through to the finances screen
/// on the right, and a way through to the board's objectives below.
class _BoardFinanceCard extends ConsumerWidget {
  const _BoardFinanceCard({
    required this.careerId,
    super.key,
    required this.onFinances,
    required this.onObjectives,
  });

  final int careerId;
  final VoidCallback onFinances;
  final VoidCallback onObjectives;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final value = ref.watch(satisfactionProvider(careerId)).valueOrNull;
    final (color, verdict) = boardVerdict(l, value);
    // What is left to SPEND, not what the federation holds. The balance still
    // contains the staff's wages — they are paid at the rollover — so a manager
    // who had just committed every last euro on the budget screen came back to
    // the hub, saw the wage bill sitting there as a balance, and read it as his
    // allocation having gone nowhere. See [federationFundsProvider].
    final funds = ref.watch(federationFundsProvider(careerId)).valueOrNull;
    // Tighter than a default pod. This strip is a STATUS line, not a section:
    // at full padding with two full-height buttons it took as much of the hub
    // as the fixture it sits above, for two numbers and a way through.
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel, color: color, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value == null ? l.hubBoard : '$value%',
                    style: AppTypography.bodyMedium.copyWith(color: color),
                  ),
                  Text(
                    verdict,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: onFinances,
                icon: const Icon(Icons.account_balance, size: 14),
                label: Text(formatEuros(funds?.free ?? 0)),
                style: _stripButton,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // The objectives themselves live on their own screen: spelled out in
          // full they never fit this strip, and an ellipsised half-sentence
          // told the manager less than the confidence figure above already
          // does.
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onObjectives,
              icon: const Icon(Icons.flag_outlined, size: 14),
              label: Text(l.boardObjectivesTitle),
              style: _stripButton,
            ),
          ),
        ],
      ),
    );
  }
}

/// Human-readable stage for a fixture (distinguishes qualifiers from finals).

class _NextMatch extends StatelessWidget {
  const _NextMatch({required this.next, required this.code});

  final Fixture? next;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final f = next;
    if (f == null) {
      return AppCard(
        child: Center(child: Text(l.hubNoMoreFixtures)),
      );
    }
    final date = AppDate.weekdayDayMonthCaps(context, f.date);
    return AppCard(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(l.hubNextMatch, style: AppTypography.labelMedium),
          ),
          const SizedBox(height: AppSpacing.xs),
          // On its own full-width line, at the heading's size. Squeezed into
          // the room beside the heading it was shrunk to fit, and players read
          // which match this is from it: a qualifier or a semi-final.
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              MatchStage.label(l, f),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMedium.copyWith(
                color: f.round == null
                    ? AppColors.onSurfaceVariant
                    : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Side(code: code(f.homeNationId)),
              Column(
                children: [
                  Text(l.hubVs, style: AppTypography.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              _Side(code: code(f.awayNationId)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlagDisc(code, size: 40),
        const SizedBox(height: AppSpacing.xs),
        Text(code, style: AppTypography.labelMedium),
      ],
    );
  }
}

/// The dashboard's identity line: the flag and the nation, and under them who
/// is in charge, what day it is, and where the nation stands in the world.
///
/// The ranking sits beside the date because that is where the manager already
/// looks for "where am I today": it is a number and an arrow, not a sentence,
/// so it survives a 360px phone in either language.
class HubHeader extends StatelessWidget {
  const HubHeader({
    required this.code,
    required this.nationName,
    required this.managerName,
    required this.date,
    required this.rank,
    required this.movement,
    super.key,
  });

  final String code;
  final String nationName;
  final String managerName;

  /// Today, already formatted.
  final String date;

  /// The nation's world position, or null while the ranking is still loading.
  final int? rank;

  /// Places climbed (positive) or dropped (negative) since the freeze the
  /// world ranking screen measures its own arrows from.
  final int movement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FlagDisc(code, size: 44),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nationName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.headlineMedium,
              ),
              Row(
                children: [
                  // The name and the date give way first. Every label here
                  // carries a maxLines: one left free to wrap would make this
                  // row taller than the header, which reads as a squashed
                  // flag rather than as an overflow anyone can see.
                  Flexible(
                    child: Text(
                      '$managerName · $date',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (rank != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    HubRank(rank: rank!, movement: movement),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The nation's world position with its movement, laid out to sit on the
/// date's own line: an inline arrow rather than the ranking screen's stacked
/// cell, which is twice as tall as this line allows.
class HubRank extends StatelessWidget {
  const HubRank({required this.rank, required this.movement, super.key});

  final int rank;

  /// Places climbed (positive) or dropped (negative).
  final int movement;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final up = movement > 0;
    final color = up ? AppColors.up : AppColors.down;
    return Tooltip(
      message: l.hubWorldRankLabel,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Plain Text, deliberately: WholeText scales itself down to fit, so
          // a width guard reading didExceedMaxLines can never fail inside one.
          Text(
            l.hubWorldRank(rank),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (movement != 0) ...[
            Icon(
              up ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              size: 16,
              color: color,
            ),
            Text(
              '${movement.abs()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SquadStatus extends StatelessWidget {
  const _SquadStatus({
    required this.rating,
    required this.size,
    required this.morale,
    required this.onManage,
  });

  final int rating;
  final int size;
  final int morale;
  final VoidCallback onManage;

  Color get _moraleColor => morale >= 60
      ? AppColors.positive
      : morale >= 42
      ? AppColors.primary
      : morale >= 25
      ? AppColors.warning
      : AppColors.error;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l.hubSquadStatus, style: AppTypography.labelMedium),
              const Spacer(),
              Text(
                l.hubPlayers(size),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                l.hubAvgRating,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text('$rating', style: AppTypography.labelMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: Stack(
              children: [
                Container(height: 6, color: AppColors.surfaceContainerHighest),
                FractionallySizedBox(
                  widthFactor: (rating / 99).clamp(0.0, 1.0),
                  child: Container(height: 6, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                l.hubMorale,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                moraleLabel(l, morale),
                style: AppTypography.labelMedium.copyWith(color: _moraleColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: Stack(
              children: [
                Container(height: 6, color: AppColors.surfaceContainerHighest),
                FractionallySizedBox(
                  widthFactor: (morale / 100).clamp(0.0, 1.0),
                  child: Container(height: 6, color: _moraleColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Outlined, like Tactics on the match preview: the event button is
          // the one call to action on the hub, and a second silver slab here
          // competed with it.
          OutlinedButton.icon(
            onPressed: onManage,
            icon: const Icon(Icons.groups, size: 18),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(l.hubManageTeam, maxLines: 1, softWrap: false),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSpacing.minHitArea),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.outlineVariant),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stand-in for the group table before its draw ceremony has been watched —
/// the competition is known, the groups are not yet revealed.
class _GroupPlaceholder extends StatelessWidget {
  const _GroupPlaceholder({required this.competition});

  final String competition;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.casino, color: AppColors.primary, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  competitionLabel(l, competition).toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.hubGroupsToBeDrawn,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupTable extends StatelessWidget {
  const _GroupTable({
    required this.group,
    required this.playerNationId,
    required this.directCount,
    required this.contentionPos,
    required this.code,
    required this.name,
    this.relegateCount = 0,
    this.onTap,
    this.framed = true,
  });

  final GroupTable group;
  final int playerNationId;

  /// Positions that advance outright (green) and the single "in contention"
  /// (amber) position, matching the tournament detail screens.
  final int directCount;
  final int? contentionPos;

  /// How many bottom places go down (red) — the Nations Cup relegates each
  /// group's last side.
  final int relegateCount;

  final String Function(int) code;
  final String Function(int) name;
  final VoidCallback? onTap;

  /// False inside a tablet panel, which already supplies the box and names
  /// the competition: the table is drawn bare and without that first line.
  final bool framed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (framed)
          Row(
            children: [
              Expanded(
                child: Text(
                  competitionLabel(l, group.competition).toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
            ],
          ),
        Text(l.hubGroupName(group.name), style: AppTypography.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        _row(
          '#',
          l.hubTblTeam,
          l.hubTblP,
          l.hubTblGd,
          l.hubTblPts,
          header: true,
        ),
        const Divider(),
        for (var i = 0; i < group.standings.length; i++)
          _standingRow(i + 1, group.standings[i]),
      ],
    );
    return framed
        ? AppCard(onTap: onTap, child: content)
        : InkWell(onTap: onTap, child: content);
  }

  Widget _standingRow(int pos, GroupStanding s) {
    final isPlayer = s.nationId == playerNationId;
    // Greens the outright qualifiers, ambers the single "in contention" spot
    // (best runner-up / best third / play-off) and reds the relegation places,
    // using the same format the tournament detail screens compute, so the two
    // never disagree.
    final direct = pos <= directCount;
    final inContention = pos == contentionPos;
    final relegated =
        relegateCount > 0 && pos > group.standings.length - relegateCount;
    final zoneColor = direct
        ? AppColors.positive
        : inContention
        ? AppColors.warning
        : relegated
        ? AppColors.error
        : null;
    final gd = s.goalDifference;
    return Container(
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.surfaceContainerHigh : null,
        border: Border(
          left: BorderSide(
            color: zoneColor ?? Colors.transparent,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color:
                    zoneColor ??
                    (isPlayer ? AppColors.primary : AppColors.onSurfaceVariant),
                fontWeight: direct ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          FlagDisc(code(s.nationId), size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name(s.nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          _cell('${s.played}'),
          _cell(gd > 0 ? '+$gd' : '$gd'),
          _cell('${s.points}', emphasize: true),
        ],
      ),
    );
  }

  Widget _row(
    String a,
    String b,
    String c,
    String d,
    String e, {
    bool header = false,
  }) {
    final style = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 7),
      child: Row(
        children: [
          SizedBox(width: 20, child: Text(a, style: style)),
          const SizedBox(width: 22 + AppSpacing.sm),
          Expanded(child: Text(b, style: style)),
          _cell(c, header: true),
          _cell(d, header: true),
          _cell(e, header: true),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool header = false, bool emphasize = false}) {
    return SizedBox(
      width: 34,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.labelSmall.copyWith(
          color: header
              ? AppColors.onSurfaceVariant
              : (emphasize ? AppColors.primary : AppColors.onSurface),
          fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}
