import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/kickoff_keys.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';

export 'package:fnm/domain/services/competition/kickoff_keys.dart'
    show continentalKickoffKind, worldCupKickoffKind;
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

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

  /// A press conference the manager must face (the opening of a tournament),
  /// opened in place rather than on its own screen.
  press,

  /// A player wants a word.
  grievance,

  /// Points to spend on the manager's own skills, offered once a cycle.
  managerSkills,

  /// Choosing the squad's base camp in the host country, before a tournament's
  /// opening ceremony.
  trainingCamp,

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

/// Watched key for the once-a-cycle prompt to spend manager skill points.
/// Stamped when the prompt is TAKEN rather than when points are spent — see
/// where it is offered for why.
const skillsPromptKind = 'skillsPrompt';

/// Watched key for the intercontinental play-off reveal (fires once, after
/// qualifying and before the finals draw).
const worldCupPlayoffKind = 'worldCupPlayoff';

/// A short label for the call-up event, tailored to the period its first match
/// [f] opens (a qualifying campaign, its matchday-6 reshuffle, a friendly
/// window, or a specific tournament).
String _callUpLabel(AppLocalizations l, Fixture f) {
  if (f.round == 'FRIENDLY') return l.hubCallUpFriendlies;
  if (f.matchday == 6) return l.hubCallUpRequalify;
  return switch (f.round) {
    'GROUP' => l.hubCallUpWorldCup,
    'CGROUP' => l.hubCallUpFinals,
    'NGROUP' => l.hubCallUpNationsCup,
    'CQ' || null => l.hubCallUpQualifying,
    _ => l.hubCallUpGeneric,
  };
}

/// Every main-tournament finals round (World Championship + continental) — a
/// fixture in one of these means the player is contesting that tournament
/// themselves. The round sets themselves live in [FinalsRounds], shared with
/// everything else that has to tell a participant from a spectator.
const Set<String> _mainFinalsRounds = {
  ...FinalsRounds.worldChampionship,
  ...FinalsRounds.continental,
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
final AutoDisposeFutureProviderFamily<HubEvent, int>
nextEventProvider = FutureProvider.autoDispose.family<HubEvent, int>((
  ref,
  careerId,
) async {
  final l = ref.watch(appLocalizationsProvider);
  final hub = await ref.watch(hubDataProvider(careerId).future);
  if (hub == null) {
    return HubEvent(
      kind: HubEventKind.advance,
      label: l.hubEventAdvanceWorld,
      icon: Icons.fast_forward_rounded,
    );
  }
  final comp = ref.watch(competitionRepositoryProvider);
  final cycle = hub.career.cyclePointer;
  String opp(int id) => hub.nations[id]?.name ?? l.hubUnknown;

  // Whether the manager is contesting each finals tournament themselves — they
  // have an unplayed fixture in one of its rounds. This decides whether an
  // opening ceremony may be held back behind their own friendly windows: a
  // participant's warm-ups genuinely come first, but a manager who is only
  // WATCHING the tournament must still see it opened before its first match.
  final playerInWcFinals = contestsFinals(
    hub.fixtures,
    FinalsRounds.worldChampionship,
    unplayedOnly: true,
  );
  final playerInContFinals = contestsFinals(
    hub.fixtures,
    FinalsRounds.continental,
    unplayedOnly: true,
  );

  // 1. The World Cup is decided — roll into the next cycle.
  if (hub.championNationId != null) {
    return HubEvent(
      kind: HubEventKind.cycleRollover,
      label: l.hubEventStartCycle(SeasonService.finalsYear(cycle + 1)),
      icon: Icons.skip_next_rounded,
      route: '${Routes.cycleRollover}?careerId=$careerId',
      subtitle: l.hubEventWorldChampions(opp(hub.championNationId!)),
    );
  }

  // 1a. The federation budget is the FORCED first event of every cycle (and of
  //     a brand-new save): the manager must distribute the war chest across the
  //     departments before anything else happens.
  if (!await comp.hasWatchedDraw(careerId, cycle, budgetSetupKind)) {
    return HubEvent(
      kind: HubEventKind.budget,
      label: l.hubEventSetBudget,
      icon: Icons.account_balance_rounded,
      route: '${Routes.budgetSetup}?careerId=$careerId',
      subtitle: l.hubEventSetBudgetSub,
    );
  }

  // 1a-ii. Points to spend on the manager himself. Two arrive at the end of
  //         every cycle and one with every trophy, and NOTHING ever said so:
  //         the manager page is reachable from a menu, so a manager who never
  //         opened it banked points for a decade and played the whole save
  //         with the skills he started with. It sits beside the budget because
  //         it is the same decision about a different pot.
  //
  //         Marked seen the moment it is offered, so it is a prompt and not a
  //         toll: a manager who would rather save his points is not asked
  //         again until the next cycle turns.
  if (!await comp.hasWatchedDraw(careerId, cycle, skillsPromptKind)) {
    final manager = await ref.watch(managerViewProvider(careerId).future);
    if (manager != null && manager.pointsAvailable > 0) {
      return HubEvent(
        kind: HubEventKind.managerSkills,
        label: l.hubEventManagerSkills(manager.pointsAvailable),
        icon: Icons.school_rounded,
        route: '${Routes.manager}?careerId=$careerId',
        subtitle: l.hubEventManagerSkillsSub,
      );
    }
  }

  // 1b. A foreign player is asking to naturalise — a one-time decision the
  //     manager makes at their leisure (accept to add them to the squad).
  if (await ref
          .watch(careerRepositoryProvider)
          .pendingNaturalization(careerId) !=
      null) {
    return HubEvent(
      kind: HubEventKind.naturalization,
      label: l.hubEventNaturalization,
      icon: Icons.how_to_reg_rounded,
      route: '${Routes.naturalization}?careerId=$careerId',
      subtitle: l.hubEventNaturalizationSub,
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
      label: l.hubEventIntercontinentalPlayoff,
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
      label: l.hubEventWatchWcDraw,
      icon: Icons.casino,
      route: '${Routes.finalsDraw}?careerId=$careerId',
    );
  }

  // 2·4. The base camp. Before a tournament is opened, the squad has to be
  //      billeted somewhere in the host country — a decision with real weight
  //      (travel against recovery against comfort) that a manager makes once
  //      per tournament. It comes BEFORE the opening ceremony because that is
  //      when a real squad flies out.
  //
  //      Gated on the tournament's own draw having been watched, so it never
  //      jumps in front of the draw that decides whether there is a tournament
  //      to camp for.
  final campPlan = await ref.watch(trainingCampPlanProvider(careerId).future);
  if (campPlan != null && !campPlan.decided) {
    final drawWatched = campPlan.tournament == 'GROUP'
        ? await comp.hasWatchedDraw(careerId, cycle, worldCupDrawKind)
        : await comp.hasWatchedDraw(careerId, cycle, continentalFinalsDrawKind);
    if (drawWatched) {
      return HubEvent(
        kind: HubEventKind.trainingCamp,
        label: l.hubEventChooseCamp,
        icon: Icons.holiday_village_rounded,
        route: '${Routes.trainingCamp}?careerId=$careerId',
        subtitle: l.hubEventChooseCampSub(campPlan.hostName),
      );
    }
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
      // Hold the ceremony while a PARTICIPANT still has open friendly windows to
      // arrange before the finals — an un-arranged friendly isn't a fixture yet,
      // so it wouldn't push out hub.next and the ceremony would jump ahead of it.
      //
      // A manager who isn't in the finals is never held: they always have an
      // open window across the tournament's summer, so the hold never lifted
      // and the ceremony landed only once the group stage had already been
      // simulated — the tournament "started" after it had begun.
      (!playerInWcFinals ||
          await ref.watch(friendliesPlanProvider(careerId).future) == null) &&
      await _finalsImminent(
        comp,
        careerId,
        CompetitionKind.worldCupFinals,
        hub.next?.date,
      )) {
    return HubEvent(
      kind: HubEventKind.tournamentKickoff,
      label: l.hubEventWorldCupHere,
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
  // Named confederation: every continent's cup is a competition of this same
  // kind, so an unqualified check fires on somebody else's tournament.
  if (playerConf != null &&
      await comp.hasTournament(
        careerId,
        CompetitionKind.continentalFinals,
        confederation: playerConf,
      ) &&
      !await comp.hasWatchedDraw(careerId, cycle, continentalFinalsDrawKind)) {
    return HubEvent(
      kind: HubEventKind.draw,
      label: l.hubEventWatchFinalsDraw,
      icon: Icons.casino,
      route:
          '${Routes.continentalDraw}?careerId=$careerId'
          '&conf=${playerConf.name}',
    );
  }

  // 2a·5. The continental championship's opening ceremony — the same trophy/host
  //       reveal the World Cup gets, so every finals tournament kicks off as an
  //       occasion. Fires once, as the LAST thing before its first finals match
  //       (friendlies in the window play first), like the World Cup above.
  if (playerConf != null &&
      await comp.hasTournament(
        careerId,
        CompetitionKind.continentalFinals,
        confederation: playerConf,
      ) &&
      await comp.hasWatchedDraw(careerId, cycle, continentalFinalsDrawKind) &&
      !await comp.hasWatchedDraw(careerId, cycle, continentalKickoffKind) &&
      // As with the World Cup, a participant waits until any open friendly
      // windows are dealt with; a manager only watching the cup does not (see
      // the World Cup branch above).
      (!playerInContFinals ||
          await ref.watch(friendliesPlanProvider(careerId).future) == null) &&
      await _finalsImminent(
        comp,
        careerId,
        CompetitionKind.continentalFinals,
        hub.next?.date,
        confederation: playerConf,
      )) {
    return HubEvent(
      kind: HubEventKind.tournamentKickoff,
      label: l.hubEventFinalsHere,
      icon: Icons.emoji_events_rounded,
      route:
          '${Routes.tournamentKickoff}?careerId=$careerId'
          '&conf=${playerConf.name}',
    );
  }

  // 2b. Somebody wants a word. A man who has been in the squad without
  //     playing, or left out of it altogether, has come to ask where he
  //     stands — and leaving him unanswered has a price.
  final wantsAWord = await ref.watch(grievanceProvider(careerId).future);
  if (wantsAWord.isNotEmpty) {
    return HubEvent(
      kind: HubEventKind.grievance,
      label: l.hubEventGrievance(wantsAWord.first.playerName),
      icon: Icons.record_voice_over_outlined,
      subtitle: l.hubEventGrievanceSub,
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
  final playerInFinals = playerInWcFinals || playerInContFinals;
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
  //
  // A finals round due BEFORE the player's own next finals match is his to
  // watch too: the World Championship's third-place play-off is played two days
  // ahead of its final, so the step that carried a finalist to his own match
  // used to resolve the play-off underneath it, unseen. The continental
  // championship has no third-place play-off — its final is always the last
  // fixture of its tournament — which is the only reason it never showed this.
  // Mirrors the same guard in [SeasonService._advance].
  final finalsRoundBeforeOwn =
      finalsDate != null &&
      nextIsFinalsMatch &&
      finalsDate.isBefore(next.date);
  if (finalsDate != null &&
      (finalsRoundBeforeOwn ||
          (!nextIsFinalsMatch &&
              !playerInFinals &&
              (next == null || !finalsDate.isAfter(next.date) || wcLive)))) {
    if (wcLive) {
      return HubEvent(
        kind: HubEventKind.watchTournament,
        label: l.hubEventPlayWcRound,
        icon: Icons.fast_forward_rounded,
        route: '${Routes.cup}?careerId=$careerId',
      );
    }
    final conf = hub.nations[hub.career.nationId]?.confederation;
    final cupName = conf == null
        ? l.hubEventContinentalFinalsFallback
        : ContinentalCups.byConfederation[conf]?.name ??
              l.hubEventContinentalFinalsFallback;
    return HubEvent(
      kind: HubEventKind.watchTournament,
      label: l.hubEventPlayCupMatch(cupName),
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
  final ncFinalsDate = await comp.earliestUnplayedNationsCupFinalsDate(
    careerId,
  );
  if (ncFinalsDate != null &&
      !nextIsNcFinals &&
      !playerInNcFinals &&
      (next == null || !ncFinalsDate.isAfter(next.date))) {
    return HubEvent(
      kind: HubEventKind.watchTournament,
      label: l.hubEventPlayNationsCupMatch,
      icon: Icons.fast_forward_rounded,
      route: '${Routes.nationsCup}?careerId=$careerId',
    );
  }

  // EVERY question the press has is an event, not just the one before a
  // tournament. A conference the manager could walk past was a conference he
  // answered whenever he happened to open the screen — which meant answering
  // questions about a match played weeks earlier, and reading as a form rather
  // than a room full of people waiting.
  //
  // It sits BELOW the watch-the-tournament events on purpose. A tournament the
  // manager is not in is one he steps through from the stands, and the press
  // were stopping him between rounds of it — a conference on the night of
  // somebody else's final, held by a manager who was not there. His own
  // fixtures are what the room turns up for, so the questions wait until the
  // tournament he is only watching has been played out.
  final pressQuestion = await ref.watch(pressQuestionProvider(careerId).future);
  if (pressQuestion != null) {
    return HubEvent(
      kind: HubEventKind.press,
      label: l.hubEventPressConference,
      icon: Icons.mic_rounded,
      subtitle: l.hubEventPressConferenceSub,
    );
  }

  if (next != null) {
    HubEvent callUp(String label, String kind) => HubEvent(
      kind: HubEventKind.callUp,
      label: label,
      icon: Icons.groups,
      route:
          '${Routes.callUps}?careerId=$careerId'
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
      // Named confederation: every confederation runs a qualifying campaign
      // now, so an unqualified lookup answers for whichever continent the query
      // happens to land on rather than the manager's.
      final euroUpcoming =
          playerConf != null &&
          await comp.hasTournament(
            careerId,
            CompetitionKind.continentalQualifying,
            confederation: playerConf,
          ) &&
          (!await comp.allPlayedForKind(
                careerId,
                CompetitionKind.continentalQualifying,
                confederation: playerConf,
              ) ||
              (await comp.hasTournament(
                    careerId,
                    CompetitionKind.continentalFinals,
                    confederation: playerConf,
                  ) &&
                  !await comp.hasWatchedDraw(
                    careerId,
                    cycle,
                    continentalFinalsDrawKind,
                  )));
      if (!euroUpcoming) {
        return drawEvent(
          l.hubEventWatchNationsCupDraw,
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
    final playerIsContHost =
        playerConf != null &&
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
          l.hubEventWatchHostSelection,
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
          l.hubEventWatchQualifyingDraw,
          '${Routes.qualifyingDraw}?careerId=$careerId',
        );
      }
    }
    // The World Cup host reveal belongs AFTER the continental championship has
    // been played out — for everyone, whether or not they're in it, and whether
    // or not they host it.
    //
    // A host of either tournament auto-qualifies and so has no qualifier to
    // time the reveal off. Without a hold, a continental host's next fixture is
    // already a WC qualifier the moment the cycle opens, and the WC host draw
    // fired immediately after the continental host draw — two host ceremonies
    // back to back, years before the cup they belong to.
    //
    // Pending if ANY of these is true, as independent clauses (a confederation
    // with no group qualifying — CONMEBOL — would otherwise fall through a
    // guard gated on "has qualifying"):
    //   * continental qualifying is still being played;
    //   * the continental finals hasn't been drawn yet;
    //   * the continental finals is drawn but not finished.
    final contQualUnfinished =
        playerConf != null &&
        await comp.hasTournament(
          careerId,
          CompetitionKind.continentalQualifying,
          confederation: playerConf,
        ) &&
        !await comp.allPlayedForKind(
          careerId,
          CompetitionKind.continentalQualifying,
          confederation: playerConf,
        );
    final hasContFinals =
        playerConf != null &&
        await comp.hasTournament(
          careerId,
          CompetitionKind.continentalFinals,
          confederation: playerConf,
        );
    final contFinalsUndrawn =
        hasContFinals &&
        !await comp.hasWatchedDraw(
          careerId,
          cycle,
          continentalFinalsDrawKind,
        );
    // allPlayedForKind is false while any fixture of the cup is unplayed — and
    // also before its fixtures exist, which the undrawn clause above already
    // covers.
    final contFinalsUnfinished =
        hasContFinals &&
        !await comp.allPlayedForKind(
          careerId,
          CompetitionKind.continentalFinals,
          confederation: playerConf,
        );
    final contCampaignPending =
        contQualUnfinished || contFinalsUndrawn || contFinalsUnfinished;
    // The host reveal waits for the continental cup to be done — for hosts and
    // non-hosts alike.
    if ((isWcQualGame || playerIsWcHost) && !contCampaignPending) {
      if (!await comp.hasWatchedDraw(
        careerId,
        cycle,
        worldCupHostDrawKind,
      )) {
        return drawEvent(
          l.hubEventWatchWcHostSelection,
          '${Routes.hostDraw}?careerId=$careerId&worldCup=true',
        );
      }
    }
    // The qualifying draw is NOT held behind the continental cup: it belongs to
    // the campaign the player is about to start, and blocking it on a cup that
    // somehow overran would leave them unable to see their own group.
    if (isWcQualGame &&
        !await comp.hasWatchedDraw(
          careerId,
          cycle,
          worldCupQualDrawKind,
        )) {
      return drawEvent(
        l.hubEventWatchWcQualifyingDraw,
        '${Routes.qualifyingDraw}?careerId=$careerId&worldCup=true',
      );
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
        label: l.hubEventArrangeFriendlies,
        icon: Icons.handshake_outlined,
        route: '${Routes.friendlies}?careerId=$careerId',
        subtitle: l.hubEventFriendliesSub(n),
      );
    }

    // 5. The squad call-up: a fresh nomination is forced at the start of every
    //    period — before a qualifying campaign and again before matchday 6,
    //    before a friendly window, and before each tournament. Keyed on the
    //    period's first match so every window fires exactly once, then locks
    //    the squad until the next period opens. Runs after friendlies are
    //    arranged, so the nearest period (and its call-up) is the friendly
    //    window when one exists.
    //    Scoped to THIS cycle: the window is read off the first unplayed match
    //    by date, so one fixture left behind in an earlier cycle would hold the
    //    head of an all-time list for ever and no later period — a tournament's
    //    group stage above all — would ever open a call-up again.
    final playerFixtures = await comp.cycleFixturesForNation(
      careerId,
      hub.career.nationId,
    );
    if (Nomination.windowOpen(playerFixtures)) {
      final period = Nomination.currentPeriod(playerFixtures);
      if (period.isNotEmpty) {
        final periodKey = 'callup:${period.first.id}';
        if (!await comp.hasWatchedDraw(careerId, cycle, periodKey)) {
          return callUp(_callUpLabel(l, period.first), periodKey);
        }
      }
    }

    // 5b. A named starter is suspended or injured (or the XI is short) — the
    //     manager must reshape the side THEMSELVES before the match. Without
    //     this, the preview quietly auto-filled the gap with a best XI, so a
    //     ban or injury never actually cost the manager a decision.
    final tactic = await ref
        .watch(tacticsRepositoryProvider)
        .tacticForCareer(careerId);
    final lineupIds = (tactic?.lineup ?? const <int?>[])
        .whereType<int>()
        .toList();
    if (lineupIds.isNotEmpty) {
      final absences = await ref
          .watch(absenceRepositoryProvider)
          .forCareer(careerId);
      final out = lineupIds
          .where((id) => !(absences[id]?.isAvailable ?? true))
          .length;
      if (out > 0 || lineupIds.length < 11) {
        return HubEvent(
          kind: HubEventKind.callUp,
          label: l.hubEventReshapeXi,
          icon: Icons.healing_rounded,
          route: '${Routes.tactics}?careerId=$careerId',
          subtitle: out > 0
              ? l.hubEventReshapeOutSub(out)
              : l.hubEventReshapeShortSub(11 - lineupIds.length),
        );
      }
    }

    // 6. Play the next match (opens its pre-match preview first).
    final oppId = next.homeNationId == hub.career.nationId
        ? next.awayNationId
        : next.homeNationId;
    return HubEvent(
      kind: HubEventKind.match,
      label: l.hubEventPlayOpponent(opp(oppId)),
      icon: Icons.play_arrow_rounded,
      route: '${Routes.matchPreview}?careerId=$careerId',
    );
  }

  // 5. No match for the player, but the World Cup is under way — step it
  //    forward one matchday at a time (round-by-round views land later).
  if (hub.hasFinals) {
    return HubEvent(
      kind: HubEventKind.watchTournament,
      label: l.hubEventPlayWcRound,
      icon: Icons.fast_forward_rounded,
      // After simming the round, open the bracket so its results are shown.
      route: '${Routes.cup}?careerId=$careerId',
    );
  }

  // 5b. The continental championship is under way and the player isn't in it
  //     (they didn't qualify). Surface it so it's played out as a visible event
  //     rather than silently fast-forwarded — open the bracket via the Trophy
  //     tab to watch the results.
  // Their OWN continent's: every confederation's championship is live in this
  // window, and an unqualified lookup would offer the manager a front-row seat
  // at a tournament on the other side of the world.
  final myConf = hub.nations[hub.career.nationId]?.confederation;
  if (await comp.hasLiveContinentalFinals(
    careerId,
    confederation: myConf,
  )) {
    final conf = myConf;
    final cupName = conf == null
        ? l.hubEventContinentalFinalsFallback
        : ContinentalCups.byConfederation[conf]?.name ??
              l.hubEventContinentalFinalsFallback;
    return HubEvent(
      kind: HubEventKind.watchTournament,
      label: l.hubEventPlayCupMatch(cupName),
      icon: Icons.fast_forward_rounded,
      route: conf == null
          ? null
          : '${Routes.continental}?careerId=$careerId&conf=${conf.name}',
    );
  }

  // 6. Nothing to present — quick-sim the world to the next event.
  return HubEvent(
    kind: HubEventKind.advance,
    label: l.hubEventAdvanceWorld,
    icon: Icons.fast_forward_rounded,
  );
});
