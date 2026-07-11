import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';

/// The kinds of thing the hub's main action can be — the game is a timeline of
/// these events rather than a single "continue".
enum HubEventKind {
  /// A draw ceremony to watch (qualifying or finals).
  draw,

  /// A squad call-up window before a campaign or tournament.
  callUp,

  /// A prompt to arrange friendlies in the gap before the next block.
  friendlies,

  /// The player's own next match (opens the match, via its preview).
  match,

  /// A tournament the player isn't in is under way — watch or skip it.
  watchTournament,

  /// The World Cup is decided; roll over to the next cycle.
  cycleRollover,

  /// Nothing to present for the player — quick-sim the world forward.
  advance,
}

/// A single step in the game timeline the hub presents as its primary action.
class HubEvent {
  const HubEvent({
    required this.kind,
    required this.label,
    required this.icon,
    this.route,
    this.subtitle,
  });

  final HubEventKind kind;
  final String label;
  final IconData icon;

  /// Where the action navigates, or null for an in-place action (advance /
  /// rollover handled by the hub).
  final String? route;

  /// Optional one-line context shown under the button.
  final String? subtitle;
}

/// Watched-draw keys for the qualifying draws (finals uses [worldCupDrawKind]).
const continentalQualDrawKind = 'contQualDraw';
const worldCupQualDrawKind = 'wcQualDraw';

/// Call-up window keys (reuse the watched-draw store, one per campaign/cycle).
const continentalQualCallUpKind = 'callup:contQual';
const worldCupQualCallUpKind = 'callup:wcQual';
const worldCupFinalsCallUpKind = 'callup:wcFinals';

/// The World Cup finals rounds, used to detect a finals match.
const _finalsRounds = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};

/// Computes the next timeline event for the save — the heart of the
/// event-driven flow. Draws are surfaced right before the player's first match
/// in that competition (and only once), matches open their preview, a live
/// tournament the player isn't in becomes a watch/skip event, and a decided
/// World Cup becomes the cycle-rollover event.
final AutoDisposeFutureProviderFamily<HubEvent, int> nextEventProvider =
    FutureProvider.autoDispose.family<HubEvent, int>((ref, careerId) async {
  final hub = await ref.watch(hubDataProvider(careerId).future);
  if (hub == null) {
    return const HubEvent(
      kind: HubEventKind.advance,
      label: 'Advance the world',
      icon: Icons.fast_forward_rounded,
    );
  }
  final comp = ref.watch(competitionRepositoryProvider);
  final cycle = hub.career.cyclePointer;
  String opp(int id) => hub.nations[id]?.name ?? 'Unknown';

  // 1. The World Cup is decided — roll into the next cycle.
  if (hub.championNationId != null) {
    return HubEvent(
      kind: HubEventKind.cycleRollover,
      label: 'Start ${SeasonService.finalsYear(cycle + 1)} cycle',
      icon: Icons.skip_next_rounded,
      route: '${Routes.cycleRollover}?careerId=$careerId',
      subtitle: '${opp(hub.championNationId!)} are World Champions',
    );
  }

  // 2. The World Cup finals draw, once it exists and hasn't been watched.
  if (hub.hasFinals &&
      !await comp.hasWatchedDraw(careerId, cycle, worldCupDrawKind)) {
    return HubEvent(
      kind: HubEventKind.draw,
      label: 'Watch the World Cup draw',
      icon: Icons.casino,
      route: '${Routes.finalsDraw}?careerId=$careerId',
    );
  }

  final next = hub.next;
  if (next != null) {
    HubEvent callUp(String label, String kind) => HubEvent(
          kind: HubEventKind.callUp,
          label: label,
          icon: Icons.groups,
          route: '${Routes.callUps}?careerId=$careerId'
              '&event=$kind&cycle=$cycle',
        );

    HubEvent drawEvent(String label, String route) => HubEvent(
          kind: HubEventKind.draw,
          label: label,
          icon: Icons.casino,
          route: route,
        );

    // 3. Each tournament's draws are forced, one-time events before its squad
    //    call-up. For a campaign the order is: host selection → qualifying draw
    //    → call-up. The continental campaign comes before the World Cup one;
    //    the World Cup finals draw is handled above.
    final isWcQualGame = next.round == null && next.groupId != null;

    if (next.round == 'CQ') {
      if (!await comp.hasWatchedDraw(
        careerId,
        cycle,
        continentalHostDrawKind,
      )) {
        return drawEvent(
          'Watch the host selection',
          '${Routes.hostDraw}?careerId=$careerId',
        );
      }
      if (!await comp.hasWatchedDraw(
        careerId,
        cycle,
        continentalQualDrawKind,
      )) {
        return drawEvent(
          'Watch the qualifying draw',
          '${Routes.qualifyingDraw}?careerId=$careerId',
        );
      }
    }
    if (isWcQualGame) {
      if (!await comp.hasWatchedDraw(
        careerId,
        cycle,
        worldCupHostDrawKind,
      )) {
        return drawEvent(
          'Watch the World Cup host selection',
          '${Routes.hostDraw}?careerId=$careerId&worldCup=true',
        );
      }
      if (!await comp.hasWatchedDraw(
        careerId,
        cycle,
        worldCupQualDrawKind,
      )) {
        return drawEvent(
          'Watch the World Cup qualifying draw',
          '${Routes.qualifyingDraw}?careerId=$careerId&worldCup=true',
        );
      }
    }

    // 4. The squad call-up before each campaign / tournament.
    if (next.round == 'CQ' &&
        !await comp.hasWatchedDraw(
          careerId,
          cycle,
          continentalQualCallUpKind,
        )) {
      return callUp('Name your qualifying squad', continentalQualCallUpKind);
    }
    if (isWcQualGame &&
        !await comp.hasWatchedDraw(careerId, cycle, worldCupQualCallUpKind)) {
      return callUp('Name your qualifying squad', worldCupQualCallUpKind);
    }
    if (_finalsRounds.contains(next.round) &&
        !await comp.hasWatchedDraw(careerId, cycle, worldCupFinalsCallUpKind)) {
      return callUp('Name your World Cup squad', worldCupFinalsCallUpKind);
    }

    // 5. Arrange friendlies in an open gap before the next competitive block.
    final friendlies = await ref.watch(
      friendliesPlanProvider(careerId).future,
    );
    if (friendlies != null) {
      final n = friendlies.windows.length;
      return HubEvent(
        kind: HubEventKind.friendlies,
        label: 'Arrange friendlies',
        icon: Icons.handshake_outlined,
        route: '${Routes.friendlies}?careerId=$careerId',
        subtitle: "You haven't arranged your $n open "
            "window${n == 1 ? '' : 's'} yet",
      );
    }

    // 6. Play the next match (opens its pre-match preview first).
    final oppId = next.homeNationId == hub.career.nationId
        ? next.awayNationId
        : next.homeNationId;
    return HubEvent(
      kind: HubEventKind.match,
      label: 'Play ${opp(oppId)}',
      icon: Icons.play_arrow_rounded,
      route: '${Routes.matchPreview}?careerId=$careerId',
    );
  }

  // 5. No match for the player, but the World Cup is under way — step it
  //    forward one matchday at a time (round-by-round views land later).
  if (hub.hasFinals) {
    return const HubEvent(
      kind: HubEventKind.watchTournament,
      label: 'Next World Cup match',
      icon: Icons.fast_forward_rounded,
    );
  }

  // 6. Nothing to present — quick-sim the world to the next event.
  return const HubEvent(
    kind: HubEventKind.advance,
    label: 'Advance the world',
    icon: Icons.fast_forward_rounded,
  );
});
