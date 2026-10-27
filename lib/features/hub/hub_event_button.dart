import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/awards/awards_ceremony_screen.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/round_popup.dart';
import 'package:fnm/features/messages/message_popup.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/press/press_copy.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/press/press_sheet.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/features/squad/grievance_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Whether a world-simulating step started by a hub action is running.
///
/// Stepping a tournament the manager is only watching simulates every match
/// of a round across the world, which on a big matchday takes a couple of
/// seconds — and until now NOTHING said so. The button stayed as it was, the
/// screen did not move, and the only honest reading was that the tap had
/// missed. The spinner is the whole difference between "working" and
/// "broken".
///
/// Shared by every [HubEventButton] for a career: on a tablet the top bar and
/// the hub both show one, and two taps must not start two advances.
final StateProviderFamily<bool, int> hubActionBusyProvider =
    StateProvider.family<bool, int>((ref, careerId) => false);

/// The hub's primary action, driven by the next timeline event: watch a draw,
/// play the next match, step a live tournament, or roll into the next cycle.
class HubEventButton extends ConsumerStatefulWidget {
  const HubEventButton({
    required this.careerId,
    this.compact = false,
    this.tourTarget,
    super.key,
  });

  final int careerId;

  /// The top-bar variant: no subtitle under it. Whether it carries the tour's
  /// key is [tourTarget]'s call, not this flag's (one GlobalKey, one widget).
  final bool compact;

  /// Whether this button carries [TourKeys.hubAction]. Defaults to the
  /// full-size (in-body) button. The tablet top bar sets it, because the
  /// tablet hub has no in-body button; one GlobalKey, one widget, always.
  final bool? tourTarget;

  @override
  ConsumerState<HubEventButton> createState() => _HubEventButtonState();
}

class _HubEventButtonState extends ConsumerState<HubEventButton> {
  int get careerId => widget.careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final event = ref.watch(nextEventProvider(careerId)).valueOrNull;
    final busy = ref.watch(hubActionBusyProvider(careerId));
    final button = PrimaryButton(
      key: (widget.tourTarget ?? !widget.compact) ? TourKeys.hubAction : null,
      label: event?.label ?? l.hubContinue,
      icon: event?.icon ?? Icons.play_arrow_rounded,
      isLoading: busy,
      // The tablet top bar gives the button room to read as metal: 44 tall
      // with breathing space above and below.
      height: widget.compact ? 44 : AppSpacing.minHitArea + 8,
      onPressed: event == null ? null : () => _dispatch(context, ref, event),
    );
    if (widget.compact) return button;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        button,
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
    // Read once: the notifier outlives this widget, `ref` does not.
    final busy = ref.read(hubActionBusyProvider(careerId).notifier);
    if (busy.state) return;
    busy.state = true;
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
        busy.state = false;
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
          showAdaptiveSheet<void>(
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
        final pending = ref
            .read(pendingConferenceProvider(careerId))
            .valueOrNull;
        final preview = ref.read(previewDueProvider(careerId)).valueOrNull;
        final hub = ref.read(hubDataProvider(careerId)).valueOrNull;
        if ((pending == null && preview == null) || hub == null) return;
        unawaited(() async {
          // A preview has no row until he opens it: write it, then read the
          // conference back like any other.
          var conference = pending;
          if (conference == null && preview != null) {
            await ref
                .read(conferenceServiceProvider)
                .openPreview(careerId, preview);
            conference = await ref.read(
              pendingConferenceProvider(careerId).future,
            );
          }
          if (conference == null) return;
          final ids = {
            conference.facts.bestPlayerId,
            conference.facts.worstPlayerId,
            conference.facts.throwback?.playerId,
            conference.facts.preview?.keyPlayerId,
          }.whereType<int>().toSet();
          final pool = await ref
              .read(playerRepositoryProvider)
              .byNation(
                hub.career.nationId,
                agingYears: CareerService.agingYears(hub.career),
                saveSeed: hub.career.rngSeed,
                careerId: hub.career.id,
                minAge: PlayerLifecycle.callUpMinAge,
              );
          final names = {
            for (final p in pool)
              if (ids.contains(p.id)) p.id: p.name,
          };
          if (!context.mounted) return;
          unawaited(
            showAdaptiveSheet<void>(
              context: context,
              backgroundColor: AppColors.surfaceContainer,
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              builder: (sheetContext) {
                final facts = conference!.facts.preview;
                return PressSheet(
                  careerId: careerId,
                  conference: conference,
                  playerNames: names,
                  opponentName:
                      hub.nations[conference.opponentNationId]?.name ?? '',
                  competitionName: facts == null
                      ? ''
                      : previewCompetitionName(
                          AppLocalizations.of(sheetContext),
                          facts.campaign,
                          hub.nations[hub.career.nationId]?.confederation,
                        ),
                  rivalName: facts?.rivalNationId == null
                      ? ''
                      : hub.nations[facts!.rivalNationId]?.name ?? '',
                );
              },
            ),
          );
        }());
      case HubEventKind.awardsCeremony:
        // Two ways in, chosen on a sheet: watch the reveal, or go straight to
        // the list. Either one takes the ceremony.
        final route = event.route;
        final year = int.tryParse(
          Uri.parse(route ?? '').queryParameters['year'] ?? '',
        );
        if (route == null || year == null) return;
        unawaited(
          showAdaptiveSheet<void>(
            context: context,
            backgroundColor: AppColors.surfaceContainer,
            builder: (sheetContext) => AwardsCeremonyChoiceSheet(
              year: year,
              onChoose: (watch) {
                Navigator.of(sheetContext).pop();
                _guarded(context, () async {
                  await ref
                      .read(awardServiceProvider)
                      .takeCeremony(careerId, year);
                  ref
                    ..invalidate(nextEventProvider(careerId))
                    ..invalidate(messageInboxProvider(careerId))
                    ..invalidate(unreadMessagesProvider(careerId));
                  if (context.mounted) {
                    context.go(watch ? '$route&watch=1' : route);
                  }
                });
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
      case HubEventKind.campaignVerdict:
      case HubEventKind.draw:
      case HubEventKind.tournamentKickoff:
      case HubEventKind.callUp:
      case HubEventKind.scandal:
      case HubEventKind.budget:
      case HubEventKind.naturalization:
      case HubEventKind.friendlies:
      case HubEventKind.trainingCamp:
      case HubEventKind.match:
        if (event.route != null) context.go(event.route!);
    }
  }
}
