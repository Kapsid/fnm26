import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

/// The kinds of thing the hub's main action can be — the game is a timeline of
/// these events rather than a single "continue".
enum HubEventKind {
  /// A draw ceremony to watch (qualifying or finals).
  draw,

  /// A squad call-up window before a campaign or tournament.
  callUp,

  /// A foreign player's offer to naturalise, awaiting accept/decline.
  naturalization,

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

/// Watched-draw key for the continental championship (finals) group draw.
const continentalFinalsDrawKind = 'contFinalsDraw';

/// A short label for the call-up event, tailored to the period its first match
/// [f] opens (a qualifying campaign, its matchday-6 reshuffle, a friendly
/// window, or a specific tournament).
String _callUpLabel(Fixture f) {
  if (f.round == 'FRIENDLY') return 'Name your squad for the friendlies';
  if (f.matchday == 6) return 'Re-name your qualifying squad';
  return switch (f.round) {
    'GROUP' => 'Name your World Cup squad',
    'CGROUP' => 'Name your squad for the finals',
    'NGROUP' => 'Name your Nations Cup squad',
    'CQ' || null => 'Name your qualifying squad',
    _ => 'Name your squad',
  };
}

/// Every main-tournament finals round (World Cup + continental) — a fixture in
/// one of these means the player is contesting that tournament themselves.
const _mainFinalsRounds = {
  'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL',
  'CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL',
};

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

  // 1b. A foreign player is asking to naturalise — a one-time decision the
  //     manager makes at their leisure (accept to add them to the squad).
  if (await ref
          .watch(careerRepositoryProvider)
          .pendingNaturalization(careerId) !=
      null) {
    return HubEvent(
      kind: HubEventKind.naturalization,
      label: 'Review naturalisation offer',
      icon: Icons.how_to_reg_rounded,
      route: '${Routes.naturalization}?careerId=$careerId',
      subtitle: 'A foreign player wants to switch allegiance to you',
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

  // 2a. The continental championship's finals draw, once it exists and hasn't
  //     been watched — like the World Cup draw above, and deliberately NOT
  //     gated on the player having a game in it.
  //
  //     It used to fire only before the player's own first group match, so a
  //     manager whose nation missed out never got the event — and watching it
  //     is the only thing that reveals the finals groups, so their continent's
  //     group stage stayed locked behind advice ("watch the finals draw from
  //     the hub") they could never follow, leaving only the knockouts visible.
  //     A non-qualifier following their continent's draw is the point, not an
  //     edge case.
  final playerConf = hub.nations[hub.career.nationId]?.confederation;
  if (playerConf != null &&
      await comp.hasTournament(careerId, CompetitionKind.continentalFinals) &&
      !await comp.hasWatchedDraw(careerId, cycle, continentalFinalsDrawKind)) {
    return HubEvent(
      kind: HubEventKind.draw,
      label: 'Watch the finals draw',
      icon: Icons.casino,
      route: '${Routes.continentalDraw}?careerId=$careerId'
          '&conf=${playerConf.name}',
    );
  }

  final next = hub.next;

  // 2c. A main finals tournament (World Cup or continental) is under way and
  //     the player isn't contesting it — its next match falls before their next
  //     fixture. Surface it so they step through every round, day by day,
  //     rather than it silently fast-forwarding to the champion.
  final nextIsFinalsMatch =
      next != null && _mainFinalsRounds.contains(next.round);
  final finalsDate = await comp.earliestUnplayedFinalsDate(careerId);
  if (finalsDate != null &&
      !nextIsFinalsMatch &&
      (next == null || !finalsDate.isAfter(next.date))) {
    final wcLive = hub.hasFinals && hub.championNationId == null;
    if (wcLive) {
      return HubEvent(
        kind: HubEventKind.watchTournament,
        label: 'Play the next World Cup round',
        icon: Icons.fast_forward_rounded,
        route: '${Routes.cup}?careerId=$careerId',
      );
    }
    final conf = hub.nations[hub.career.nationId]?.confederation;
    final cupName = conf == null
        ? 'the continental finals'
        : ContinentalCups.byConfederation[conf]?.name ??
            'the continental finals';
    return HubEvent(
      kind: HubEventKind.watchTournament,
      label: 'Play the next $cupName match',
      icon: Icons.fast_forward_rounded,
      route: conf == null
          ? null
          : '${Routes.continental}?careerId=$careerId&conf=${conf.name}',
    );
  }

  // 2d. The Nations Cup Finals Four is under way and the player isn't in it —
  //     surface it so its semis and final are watched, not skipped past.
  final nextIsNcFinals =
      next != null && (next.round == 'NSF' || next.round == 'NFINAL');
  final ncFinalsDate =
      await comp.earliestUnplayedNationsCupFinalsDate(careerId);
  if (ncFinalsDate != null &&
      !nextIsNcFinals &&
      (next == null || !ncFinalsDate.isAfter(next.date))) {
    return HubEvent(
      kind: HubEventKind.watchTournament,
      label: 'Play the next Nations Cup match',
      icon: Icons.fast_forward_rounded,
      route: '${Routes.nationsCup}?careerId=$careerId',
    );
  }

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

    // 2e. The Nations Cup group draw, forced once before the player's first
    //     group match. The group tables stay hidden until it is watched.
    if (next.round == 'NGROUP' &&
        !await comp.hasWatchedDraw(careerId, cycle, nationsCupDrawKind)) {
      return drawEvent(
        'Watch the Nations Cup draw',
        '${Routes.nationsCupDraw}?careerId=$careerId',
      );
    }

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

    // 4. The squad call-up: a fresh nomination is forced at the start of every
    //    period — before a qualifying campaign and again before matchday 6,
    //    before a friendly window, and before each tournament. Keyed on the
    //    period's first match so every window fires exactly once, then locks
    //    the squad until the next period opens.
    final playerFixtures =
        await comp.fixturesForNation(careerId, hub.career.nationId);
    if (Nomination.windowOpen(playerFixtures)) {
      final period = Nomination.currentPeriod(playerFixtures);
      if (period.isNotEmpty) {
        final periodKey = 'callup:${period.first.id}';
        if (!await comp.hasWatchedDraw(careerId, cycle, periodKey)) {
          return callUp(_callUpLabel(period.first), periodKey);
        }
      }
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
    return HubEvent(
      kind: HubEventKind.watchTournament,
      label: 'Play the next World Cup round',
      icon: Icons.fast_forward_rounded,
      // After simming the round, open the bracket so its results are shown.
      route: '${Routes.cup}?careerId=$careerId',
    );
  }

  // 5b. The continental championship is under way and the player isn't in it
  //     (they didn't qualify). Surface it so it's played out as a visible event
  //     rather than silently fast-forwarded — open the bracket via the Trophy
  //     tab to watch the results.
  if (await comp.hasLiveContinentalFinals(careerId)) {
    final conf = hub.nations[hub.career.nationId]?.confederation;
    final cupName = conf == null
        ? 'the continental finals'
        : ContinentalCups.byConfederation[conf]?.name ??
            'the continental finals';
    return HubEvent(
      kind: HubEventKind.watchTournament,
      label: 'Play the next $cupName match',
      icon: Icons.fast_forward_rounded,
      route: conf == null
          ? null
          : '${Routes.continental}?careerId=$careerId&conf=${conf.name}',
    );
  }

  // 6. Nothing to present — quick-sim the world to the next event.
  return const HubEvent(
    kind: HubEventKind.advance,
    label: 'Advance the world',
    icon: Icons.fast_forward_rounded,
  );
});
