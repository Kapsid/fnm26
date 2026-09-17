import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/features/hub/board_objectives_screen.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/features/squad/grievance_sheet.dart';
import 'package:fnm/features/press/press_sheet.dart';
import 'package:fnm/features/hub/round_popup.dart';
import 'package:fnm/features/messages/message_popup.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// In-game home ("National Hub"): continue/play, calendar, next match, squad
/// status, and the group table, with the in-game bottom navigation.
class HubScreen extends ConsumerStatefulWidget {
  const HubScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends ConsumerState<HubScreen> {
  /// Guards against a second run while a sheet is already up — the hub rebuilds
  /// often, and each rebuild would otherwise stack another popup.
  bool _popping = false;

  /// Guards the offer against firing twice while its popup is opening.
  bool _offeringTour = false;

  /// Asks, once ever, whether the manager wants showing around.
  ///
  /// Recorded whatever the answer is: "no thanks" is an answer, and asking it
  /// again would make an offer into a nag. Settings is the way back in.
  Future<void> _offerTour() async {
    if (!mounted || appPopupBusy) return;
    final l = AppLocalizations.of(context);
    await markTourOffered(ref);
    if (!mounted) return;
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
    if (!mounted) return;
    if (wants ?? false) startTour(ref, careerId);
  }

  int get careerId => widget.careerId;

  /// Pops any unread news over the hub. Driven from here rather than from each
  /// action because everything returns to the hub — a match, a draw, a stepped
  /// tournament round — so this catches them all in one place.
  Future<void> _popMessages() async {
    // Wait if an action is already showing its own popup: stepping a final
    // fires the champion news and the final's result together, and racing them
    // buries one behind the other. That path pops the news itself when done.
    if (_popping || appPopupBusy) return;
    _popping = true;
    try {
      if (mounted) await showUnreadMessagePopups(context, ref, careerId);
    } finally {
      _popping = false;
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

    // Surface news the moment it lands, rather than leaving it to be found.
    if (unread > 0 && !_popping) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _popMessages());
    }

    // The offer of a walk through, made once ever. The hub is where it
    // belongs: every path into a save ends here — a new career, an imported
    // one, a start from the bottom — so one hook catches them all.
    if (!ref.watch(tourOfferedProvider) && !_offeringTour) {
      _offeringTour = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _offerTour());
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.home),
        ),
        title: Text(
          l.hubNationalHub,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
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
          final date = DateFormat('d MMM yyyy').format(hub.career.inGameDate);
          String code(int id) => hub.nations[id]?.code ?? '??';
          String name(int id) => hub.nations[id]?.name ?? l.hubUnknown;
          // Hide the opponent and group table until the draw has been watched.
          final drawWatched = hub.nextDrawWatched;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Row(
                children: [
                  FlagDisc(nation?.code ?? '??', size: 44),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nation?.name ?? '…',
                          style: AppTypography.headlineMedium,
                        ),
                        Text(
                          '${hub.career.managerName} · $date',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
              _EventButton(careerId: careerId),
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
                    // Open the right competition detail: the Nations Cup, the
                    // World Cup for its qualifiers/finals, else the player's
                    // continental cup.
                    onTap: () {
                      final comp = hub.group!.competition;
                      final conf =
                          hub.nations[hub.career.nationId]?.confederation;
                      if (comp.startsWith('Nations Cup')) {
                        context.go(
                          '${Routes.nationsCup}?careerId=$careerId',
                        );
                        return;
                      }
                      final isWc =
                          comp == 'World Cup Qualifiers' ||
                          comp == 'World Championship';
                      context.go(
                        isWc || conf == null
                            ? '${Routes.cup}?careerId=$careerId'
                            : '${Routes.continental}?careerId=$careerId'
                                  '&conf=${conf.name}',
                      );
                    },
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

/// The hub's primary action, driven by the next timeline event: watch a draw,
/// play the next match, step a live tournament, or roll into the next cycle.
class _EventButton extends ConsumerStatefulWidget {
  const _EventButton({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_EventButton> createState() => _EventButtonState();
}

class _EventButtonState extends ConsumerState<_EventButton> {
  /// Whether a world-simulating step is running right now.
  ///
  /// Stepping a tournament the manager is only watching simulates every match
  /// of a round across the world, which on a big matchday takes a couple of
  /// seconds — and until now NOTHING said so. The button stayed as it was, the
  /// screen did not move, and the only honest reading was that the tap had
  /// missed. The spinner is the whole difference between "working" and
  /// "broken".
  bool _busy = false;

  int get careerId => widget.careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final event = ref.watch(nextEventProvider(careerId)).valueOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          key: TourKeys.hubAction,
          label: event?.label ?? l.hubContinue,
          icon: event?.icon ?? Icons.play_arrow_rounded,
          isLoading: _busy,
          onPressed: event == null
              ? null
              : () => _dispatch(context, ref, event),
        ),
        if (event?.subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            event!.subtitle!,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  /// Runs a world-mutating season call that nothing awaits, and puts any
  /// failure in front of the player.
  ///
  /// These used to be bare `unawaited(...)`: anything thrown inside the sim
  /// became an unhandled async error, so the hub silently failed to move and
  /// the player was left tapping a button that looked dead. Now the error is
  /// recorded for Settings → Diagnostics and shown as a snackbar.
  void _guarded(BuildContext context, Future<void> Function() op) {
    if (_busy) return;
    setState(() => _busy = true);
    unawaited(() async {
      try {
        await op();
      } on Object catch (e, st) {
        AppLog.error('hub:action', e, st);
        if (!context.mounted) return;
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.hubCouldNotAdvance('$e'))),
        );
      } finally {
        if (mounted) setState(() => _busy = false);
      }
    }());
  }

  void _dispatch(BuildContext context, WidgetRef ref, HubEvent event) {
    final season = ref.read(seasonServiceProvider);
    switch (event.kind) {
      case HubEventKind.watchTournament:
        // Sim the next round, then pop up its results (with a link to the full
        // bracket); group-stage rounds fall through to the bracket directly.
        final route = event.route;
        _guarded(
          context,
          // Guarded from before the first await: advancing invalidates the hub,
          // which would otherwise let its automatic news popup race this one —
          // and the round that generates news is the final, the one round the
          // player most wants to see.
          () => withAppPopupGuard(() async {
            await season.advance(careerId);
            if (context.mounted) {
              await showRoundPopup(context, ref, careerId, route: route);
            }
            // Then the news, in order, rather than on top.
            if (context.mounted) {
              await showUnreadMessagePopups(context, ref, careerId);
            }
          }),
        );
      case HubEventKind.advance:
        _guarded(context, () => season.advance(careerId));
      case HubEventKind.grievance:
        final open = ref.read(grievanceProvider(careerId)).valueOrNull;
        if (open == null || open.isEmpty) return;
        unawaited(
          showModalBottomSheet<void>(
            context: context,
            backgroundColor: AppColors.surfaceContainer,
            isScrollControlled: true,
            builder: (_) => GrievanceSheet(
              careerId: careerId,
              grievance: open.first,
            ),
          ),
        );
      case HubEventKind.press:
        // The press conference has no screen of its own — it is the same sheet
        // the optional press card opens, just reached as a forced step.
        final question = ref.read(pressQuestionProvider(careerId)).valueOrNull;
        if (question == null) return;
        final nations =
            ref.read(hubDataProvider(careerId)).valueOrNull?.nations ??
            const <int, Nation>{};
        unawaited(
          showModalBottomSheet<void>(
            context: context,
            backgroundColor: AppColors.surfaceContainer,
            isScrollControlled: true,
            builder: (_) => PressSheet(
              careerId: careerId,
              question: question,
              opponentName: switch (question.subjectNationId) {
                final id? => nations[id]?.name,
                _ => null,
              },
            ),
          ),
        );
      case HubEventKind.managerSkills:
        // Marked seen as it is TAKEN, not when the points are spent: a manager
        // who looks at his skills and decides to bank them has answered the
        // prompt, and asking again every time he returns to the hub would make
        // an offer into a toll. It comes back when the next cycle turns.
        final cycle = ref
            .read(hubDataProvider(careerId))
            .valueOrNull
            ?.career
            .cyclePointer;
        if (cycle != null) {
          _guarded(context, () async {
            await ref
                .read(competitionRepositoryProvider)
                .markDrawWatched(careerId, cycle, skillsPromptKind);
            ref.invalidate(nextEventProvider(careerId));
          });
        }
        // PUSHED, not `go`: the manager page is the one event screen that
        // leaves by popping itself. Replacing the hub with it left nothing
        // underneath, so its back arrow popped the last route in the stack and
        // the player was staring at a black screen.
        if (event.route != null) context.push(event.route!);
      case HubEventKind.cycleRollover:
      case HubEventKind.draw:
      case HubEventKind.tournamentKickoff:
      case HubEventKind.callUp:
      case HubEventKind.budget:
      case HubEventKind.naturalization:
      case HubEventKind.friendlies:
      case HubEventKind.trainingCamp:
      case HubEventKind.match:
        if (event.route != null) context.go(event.route!);
    }
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
    final date = DateFormat('EEE d MMM').format(f.date).toUpperCase();
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Text(l.hubNextMatch, style: AppTypography.labelMedium),
              const Spacer(),
              Flexible(
                // "World Cup qualifying · Matchday 6" is longer than the room
                // left beside the heading, and a stage that ends in "…" tells
                // the manager nothing about which match this is. The compact
                // form writes the qualifying campaigns with a Q, which is the
                // difference between a banner you can read here and one that
                // has been scaled down to a grey smear.
                child: WholeText(
                  MatchStage.labelCompact(l, f),
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  style: AppTypography.labelSmall.copyWith(
                    color: f.round == null
                        ? AppColors.onSurfaceVariant
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
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
                Condition.moraleLabel(morale),
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
          PrimaryButton(
            label: l.hubManageTeam,
            icon: Icons.groups,
            onPressed: onManage,
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
                  competition.toUpperCase(),
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  group.competition.toUpperCase(),
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
      ),
    );
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
