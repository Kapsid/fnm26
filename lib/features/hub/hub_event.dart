import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
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

  /// The opening ceremony of a finals tournament (trophy + host reveal), shown
  /// once after its draw and before its first matchday.
  tournamentKickoff,

  /// A squad call-up window before a campaign or tournament.
  callUp,

  /// The forced budget allocation that opens each cycle.
  budget,

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

/// Watched key for the World Cup opening ceremony (fires once per edition, after
/// the finals draw and before the first matchday).
const worldCupKickoffKind = 'worldCupKickoff';

/// The watched-key for a continental championship's opening ceremony (trophy +
/// host reveal), so it fires once per edition like the World Cup kickoff.
const continentalKickoffKind = 'contKickoff';

/// Watched key for the intercontinental play-off reveal (fires once, after
/// qualifying and before the finals draw).
const worldCupPlayoffKind = 'worldCupPlayoff';

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

/// Whether a tournament of [kind] is about to kick off: its first unplayed
/// fixture is due on or before the player's [nextFixtureDate] (or they have no
/// next fixture) — so its opening ceremony fires right before the first match
/// rather than weeks early, ahead of friendlies still to be played.
Future<bool> _finalsImminent(
  CompetitionRepository comp,
  int careerId,
  CompetitionKind kind,
  DateTime? nextFixtureDate, {
  Confederation? confederation,
}) async {
  final first = await comp.earliestUnplayedDateOfKind(
    careerId,
    kind,
    confederation: confederation,
  );
  if (first == null) return false;
  return nextFixtureDate == null || !first.isAfter(nextFixtureDate);
}

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

  // 1a. The federation budget is the FORCED first event of every cycle (and of
  //     a brand-new save): the manager must distribute the war chest across the
  //     departments before anything else happens.
  if (!await comp.hasWatchedDraw(careerId, cycle, budgetSetupKind)) {
    return HubEvent(
      kind: HubEventKind.budget,
      label: 'Set your federation budget',
      icon: Icons.account_balance_rounded,
      route: '${Routes.budgetSetup}?careerId=$careerId',
      subtitle: 'Allocate this cycle’s war chest before the season begins',
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

  // 1z. The intercontinental play-off that settled the last two finals berths,
  //     shown as its own step BEFORE the finals draw (not buried on it). Gated
  //     on qualifying being complete so the tie results are real, never an empty
  //     "no play-off this cycle" screen shown before the games were played.
  if (hub.hasFinals &&
      await comp.allQualifyingPlayed(careerId) &&
      !await comp.hasWatchedDraw(careerId, cycle, worldCupPlayoffKind)) {
    return HubEvent(
      kind: HubEventKind.draw,
      label: 'The intercontinental play-off',
      icon: Icons.swap_calls_rounded,
      route: '${Routes.intercontinentalPlayoff}?careerId=$careerId',
    );
  }

  // 2. The World Cup finals draw, once it exists and the play-off has been seen.
  if (hub.hasFinals &&
      await comp.hasWatchedDraw(careerId, cycle, worldCupPlayoffKind) &&
      !await comp.hasWatchedDraw(careerId, cycle, worldCupDrawKind)) {
    return HubEvent(
      kind: HubEventKind.draw,
      label: 'Watch the World Cup draw',
      icon: Icons.casino,
      route: '${Routes.finalsDraw}?careerId=$careerId',
    );
  }

  // 2·5. The World Cup opening ceremony — a trophy/host reveal that fires once,
  //      as the LAST thing before the first finals match (not weeks early behind
  //      friendlies), for EVERY manager (in the finals or not). Gated on the
  //      first WC finals match being imminent: due on or before the player's
  //      next fixture, so any friendlies play first and the ceremony lands right
  //      as the tournament kicks off.
  if (hub.hasFinals &&
      await comp.hasWatchedDraw(careerId, cycle, worldCupDrawKind) &&
      !await comp.hasWatchedDraw(careerId, cycle, worldCupKickoffKind) &&
      await _finalsImminent(
        comp,
        careerId,
        CompetitionKind.worldCupFinals,
        hub.next?.date,
      )) {
    return HubEvent(
      kind: HubEventKind.tournamentKickoff,
      label: 'The World Cup is here',
      icon: Icons.emoji_events_rounded,
      route: '${Routes.tournamentKickoff}?careerId=$careerId',
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

  // 2a·5. The continental championship's opening ceremony — the same trophy/host
  //       reveal the World Cup gets, so every finals tournament kicks off as an
  //       occasion. Fires once, as the LAST thing before its first finals match
  //       (friendlies in the window play first), like the World Cup above.
  if (playerConf != null &&
      await comp.hasTournament(careerId, CompetitionKind.continentalFinals) &&
      await comp.hasWatchedDraw(careerId, cycle, continentalFinalsDrawKind) &&
      !await comp.hasWatchedDraw(careerId, cycle, continentalKickoffKind) &&
      await _finalsImminent(
        comp,
        careerId,
        CompetitionKind.continentalFinals,
        hub.next?.date,
        confederation: playerConf,
      )) {
    return HubEvent(
      kind: HubEventKind.tournamentKickoff,
      label: 'The finals are here',
      icon: Icons.emoji_events_rounded,
      route: '${Routes.tournamentKickoff}?careerId=$careerId'
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
  // The manager is contesting the finals themselves if they have ANY unplayed
  // finals fixture — not just when their *immediate* next fixture is one. A
  // participant always plays their own matches; only the `wcLive` fast-forward
  // below (for non-participants) may run ahead of their friendlies.
  final playerInFinals = hub.fixtures.any(
    (f) => !f.hasResult && _mainFinalsRounds.contains(f.round),
  );
  // Restrict the "watch the live finals" date to the World Cup and the player's
  // OWN continental finals — otherwise a foreign continental final dated earlier
  // points `finalsDate` at a match the WC "watch" route can't show, and the WC
  // appears to stall/skip while a foreign result pops up instead.
  final finalsDate = await comp.earliestUnplayedFinalsDate(
    careerId,
    playerConfederation: hub.nations[hub.career.nationId]?.confederation,
  );
  final wcLive = hub.hasFinals && hub.championNationId == null;
  // Normally the player's own next fixture is played first; but a live World
  // Cup finals (its climax rounds, up to and including the final) takes
  // priority so it's always watched through to the champion rather than being
  // silently caught up behind a friendly. A finals participant is never
  // fast-forwarded past their own matches.
  if (finalsDate != null &&
      !nextIsFinalsMatch &&
      !playerInFinals &&
      (next == null || !finalsDate.isAfter(next.date) || wcLive)) {
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
  //     surface it so its semis and final are watched, not skipped past. As with
  //     the World Cup guard above, a participant is detected from ANY unplayed
  //     Finals Four fixture, not just their immediate next one — otherwise a
  //     host (who fills the pre-finals window with friendlies) is wrongly routed
  //     to watch, and their own semi/final is auto-simmed and never played.
  final nextIsNcFinals =
      next != null && (next.round == 'NSF' || next.round == 'NFINAL');
  final playerInNcFinals = hub.fixtures.any(
    (f) => !f.hasResult && (f.round == 'NSF' || f.round == 'NFINAL'),
  );
  final ncFinalsDate =
      await comp.earliestUnplayedNationsCupFinalsDate(careerId);
  if (ncFinalsDate != null &&
      !nextIsNcFinals &&
      !playerInNcFinals &&
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
      // Don't let it jump ahead of the continental campaign. A host plays no
      // qualifiers, so an NGROUP game can become its next fixture before the Euro
      // is even drawn — firing here would burn this one-shot and the Nations Cup
      // would never be drawn after the Euro. Hold it until the continental
      // campaign is resolved: qualifying done and, if the player has a finals,
      // that finals is drawn.
      final euroUpcoming = playerConf != null &&
          await comp.hasTournament(
              careerId, CompetitionKind.continentalQualifying) &&
          (!await comp.allPlayedForKind(
                  careerId, CompetitionKind.continentalQualifying) ||
              (await comp.hasTournament(
                      careerId, CompetitionKind.continentalFinals) &&
                  !await comp.hasWatchedDraw(
                      careerId, cycle, continentalFinalsDrawKind)));
      if (!euroUpcoming) {
        return drawEvent(
          'Watch the Nations Cup draw',
          '${Routes.nationsCupDraw}?careerId=$careerId',
        );
      }
    }

    // 3. Each tournament's draws are forced, one-time events before its squad
    //    call-up. For a campaign the order is: host selection → qualifying draw
    //    → call-up. The continental campaign comes before the World Cup one;
    //    the World Cup finals draw is handled above.
    final isWcQualGame = next.round == null && next.groupId != null;

    // A host auto-qualifies and plays no qualifiers, so it has no CQ / WC-qual
    // fixture to key the host-selection ceremony off. Detect the host directly
    // (deterministic) so it still sees its OWN selection ceremony rather than it
    // being silently skipped.
    final nationsList = hub.nations.values.toList();
    final playerIsContHost = playerConf != null &&
        WorldCupHosts.continentalHostsFor(
          confederation: playerConf,
          cycle: cycle,
          seed: hub.career.rngSeed,
          nations: nationsList,
        ).contains(hub.career.nationId);
    final playerIsWcHost = WorldCupHosts.worldCupHostIds(
      year: CareerService.worldCupYear(cycle),
      nations: nationsList,
      seed: hub.career.rngSeed,
    ).contains(hub.career.nationId);

    if (next.round == 'CQ' || playerIsContHost) {
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
      // The qualifying draw is only for a side actually in qualifying — a host
      // sits it out, so don't force it on them.
      if (next.round == 'CQ' &&
          !await comp.hasWatchedDraw(
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
    if (isWcQualGame || playerIsWcHost) {
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
      if (isWcQualGame &&
          !await comp.hasWatchedDraw(
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

    // 4. Arrange friendlies in an open gap BEFORE the next competitive block —
    //    ahead of the squad call-up, so a friendly window between two blocks is
    //    booked first and then nominated for. Otherwise the manager nominated
    //    for the upcoming tournament, arranged friendlies, and was immediately
    //    asked to nominate again for those friendlies.
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

    // 5. The squad call-up: a fresh nomination is forced at the start of every
    //    period — before a qualifying campaign and again before matchday 6,
    //    before a friendly window, and before each tournament. Keyed on the
    //    period's first match so every window fires exactly once, then locks
    //    the squad until the next period opens. Runs after friendlies are
    //    arranged, so the nearest period (and its call-up) is the friendly
    //    window when one exists.
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

    // 5b. A named starter is suspended or injured (or the XI is short) — the
    //     manager must reshape the side THEMSELVES before the match. Without
    //     this, the preview quietly auto-filled the gap with a best XI, so a
    //     ban or injury never actually cost the manager a decision.
    final tactic =
        await ref.watch(tacticsRepositoryProvider).tacticForCareer(careerId);
    final lineupIds =
        (tactic?.lineup ?? const <int?>[]).whereType<int>().toList();
    if (lineupIds.isNotEmpty) {
      final absences =
          await ref.watch(absenceRepositoryProvider).forCareer(careerId);
      final out = lineupIds
          .where((id) => !(absences[id]?.isAvailable ?? true))
          .length;
      if (out > 0 || lineupIds.length < 11) {
        return HubEvent(
          kind: HubEventKind.callUp,
          label: 'Reshape your starting XI',
          icon: Icons.healing_rounded,
          route: '${Routes.tactics}?careerId=$careerId',
          subtitle: out > 0
              ? '$out of your XI ${out == 1 ? 'is' : 'are'} out '
                  '(suspended or injured) — pick their replacement'
              : 'Your starting XI is short — fill the open '
                  '${11 - lineupIds.length == 1 ? 'slot' : 'slots'}',
        );
      }
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
