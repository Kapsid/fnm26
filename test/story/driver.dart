import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/kickoff_keys.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/match/penalty_takers.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/squad/grievances.dart';
import 'package:fnm/domain/services/squad/squad_selection.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/squad/camp_scandal_providers.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/features/squad/injury_cover_providers.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/features/tactics/nomination_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_database.dart';

const int england = 14;

/// The sides England measures itself against: friendlies are booked with
/// these, in this order.
const List<int> rivalIds = [
  46,
  20,
  56,
  18,
  58,
  26,
  55,
]; // SCO GER ARG FRA BRA ITA WAL

final List<Nation> storyNations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

/// Greenland's squad, or (LAB_GREENLAND_FACTOR, the campaign lab only) the
/// same squad rebuilt from San Marino's attributes at another factor, the way
/// `greenlandSquad` was written.
final List<Player> _labGreenland = () {
  final f = double.tryParse(
    Platform.environment['LAB_GREENLAND_FACTOR'] ?? '',
  );
  if (f == null) return greenlandSquad;
  final sm = [
    for (final p in _players)
      if (p.nationId == 45) p,
  ];
  int scaled(int v) => (v * f).round().clamp(25, 99);
  return [
    for (var i = 0; i < greenlandSquad.length; i++)
      greenlandSquad[i].copyWith(
        attributes: PlayerAttributes(
          physical: scaled(sm[i].attributes.physical),
          technical: scaled(sm[i].attributes.technical),
          stamina: scaled(sm[i].attributes.stamina),
        ),
      ),
  ];
}();

/// LAB_ENGAGED=1 (the campaign lab only): the autopilot plays an engaged
/// manager. All the federation money into the youth academy (the rest into
/// the naturalisation office), every naturalisation offer accepted, every
/// manager-skill point into youth development. Without it the autopilot
/// spreads the money evenly, declines every offer and spends no points.
final bool labEngaged = Platform.environment['LAB_ENGAGED'] == '1';
final Map<int, Nation> nationById = {for (final n in storyNations) n.id: n};
final List<Player> _players =
    (jsonDecode(File('assets/data/players.json').readAsStringSync()) as List)
        .map((e) => Player.fromJson(e as Map<String, Object?>))
        .toList();
final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

AppDatabase storyDb() {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  return createTestDatabase();
}

/// [salt] varies the match results between runs of one world (labs).
ProviderContainer storyContainer([AppDatabase? shared, int salt = 0]) =>
    _storyContainer(shared ?? storyDb(), premium: true, salt: salt);

/// A [storyContainer] for a free player: campaigns, and the free cycle's wall.
ProviderContainer freeStoryContainer() =>
    _storyContainer(storyDb(), premium: false);

ProviderContainer _storyContainer(
  AppDatabase db, {
  required bool premium,
  int salt = 0,
}) {
  final c = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => premium),
      matchAttemptSaltProvider.overrideWithValue(() => salt),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(
          nationList: storyNations,
          playerList: _players,
          // As the app's asset source: Greenland is in every database, and
          // only a Greenland campaign's world includes it. Its 23 base
          // players, like every other nation here (players.json unexpanded).
          dormantNations: DormantNations.all,
          dormantPlayers: _labGreenland,
        ),
      ),
      formFactorProvider.overrideWithValue(FormFactor.phone),
      countryCitiesProvider.overrideWith((ref) async => _cities),
    ],
  );
  return c;
}

/// Plays a career one hub event at a time, completing each as its screen
/// would. The hooks see each event before it is done and each match before
/// and after it is committed.
class StoryDriver {
  StoryDriver(this.c, this.careerId);

  final ProviderContainer c;
  final int careerId;
  int _friendlyCursor = 0;

  Future<void> Function(HubEvent e)? beforeEvent;
  Future<void> Function(MatchPreview p)? beforeMatch;
  Future<void> Function(Fixture played)? afterMatch;

  static Future<StoryDriver> start(
    ProviderContainer c,
    int seed, {
    int nationId = england,
    Map<int, int> startingRanks = const {},
  }) async {
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: nationId,
                  managerName: 'M. Urbanczyk',
                  rngSeed: seed,
                  startingRanks: startingRanks,
                ))
            .valueOrNull!;
    return StoryDriver(c, career.id);
  }

  /// Starts a run of the campaign [def], as its brief's Start does.
  static Future<StoryDriver> startCampaign(
    ProviderContainer c,
    CampaignDef def,
  ) async {
    await c.read(seedLoaderProvider).ensureSeeded();
    final career = await c
        .read(campaignServiceProvider)
        .start(def, managerName: 'M. Urbanczyk');
    return StoryDriver(c, career.id);
  }

  Future<int> get _cycle async =>
      (await c.read(careerRepositoryProvider).byId(careerId))!.cyclePointer;

  Future<void> _watch(String kind) async => c
      .read(competitionRepositoryProvider)
      .markDrawWatched(careerId, await _cycle, kind);

  Future<HubEvent> nextEvent() async {
    c
      ..invalidate(nextEventProvider(careerId))
      ..invalidate(hubDataProvider(careerId));
    final sub = c.listen(nextEventProvider(careerId).future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  Future<T> _read<T>(AutoDisposeFutureProvider<T> p) async {
    final sub = c.listen(p.future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  String? _lastKey;
  int _repeat = 0;

  /// Completes one event. Returns false once [stopAtRollover] meets the
  /// rollover, and once a campaign run's cycle is over (its "campaign
  /// complete", which leads to the campaigns list).
  Future<bool> step({bool stopAtRollover = false}) async {
    final e = await nextEvent();
    final key = '${e.kind}|${e.route}';
    _repeat = key == _lastKey ? _repeat + 1 : 0;
    _lastKey = key;
    if (_repeat > 40 &&
        e.kind != HubEventKind.advance &&
        e.kind != HubEventKind.watchTournament) {
      throw StateError('stuck on $key');
    }
    if (e.kind == HubEventKind.cycleRollover && stopAtRollover) return false;
    await beforeEvent?.call(e);
    final uri = e.route == null ? null : Uri.parse(e.route!);
    switch (e.kind) {
      case HubEventKind.draw:
        await _watch(_drawKind(uri!));
      case HubEventKind.tournamentKickoff:
        await _watch(
          uri!.queryParameters['conf'] == null
              ? worldCupKickoffKind
              : continentalKickoffKind,
        );
      case HubEventKind.callUp:
        if (uri!.path == Routes.injuryCover) {
          // Keep the injured man and play on.
          c.invalidate(pendingInjuryCoverProvider(careerId));
          final cover = await _read(pendingInjuryCoverProvider(careerId));
          if (cover != null) {
            await _watch(injuryCoverKey(cover.fixtureId, cover.playerId));
          }
        } else if (uri.path == Routes.tactics) {
          await _callUp(null);
          final f = await _read(currentFormationProvider(careerId));
          await c.read(tacticServiceProvider).setFormation(careerId, f);
        } else {
          await _callUp(uri.queryParameters['event']);
        }
      case HubEventKind.scandal:
        // Keep him: the default a manager who never answers gets anyway.
        c.invalidate(pendingScandalProvider(careerId));
        final scandal = await _read(pendingScandalProvider(careerId));
        if (scandal != null) {
          await c.read(campScandalServiceProvider).keep(careerId, scandal);
        }
      case HubEventKind.budget:
        await _budget();
      case HubEventKind.naturalization:
        final repo = c.read(careerRepositoryProvider);
        final link = await repo.pendingNaturalization(careerId);
        // An engaged manager (LAB_ENGAGED) takes every offer: for a side at
        // the bottom, any international who wants to come is an upgrade.
        await repo.setNaturalizationStatus(
          careerId,
          link!.playerId,
          labEngaged ? 'accepted' : 'declined',
        );
      case HubEventKind.friendlies:
        await _friendlies();
      case HubEventKind.press:
        await _press();
      case HubEventKind.grievance:
        final g = (await _read(grievanceProvider(careerId))).first;
        await c
            .read(grievanceServiceProvider)
            .answer(careerId, g, GrievanceTone.reassure);
      case HubEventKind.managerSkills:
        if (labEngaged) {
          // Every point into youth development, the one skill that lifts
          // the nation's own players.
          while (await c
              .read(managerServiceProvider)
              .raise(careerId, ManagerSkill.youthDevelopment)) {}
        }
        await _watch(skillsPromptKind);
      case HubEventKind.awardsCeremony:
        // Skip to the list: taking it either way marks it seen.
        await c
            .read(awardServiceProvider)
            .takeCeremony(careerId, int.parse(uri!.queryParameters['year']!));
      case HubEventKind.trainingCamp:
        final plan = (await _read(trainingCampPlanProvider(careerId)))!;
        await c
            .read(trainingCampServiceProvider)
            .choose(careerId, plan, plan.options.first);
      case HubEventKind.match:
        await _match();
      case HubEventKind.watchTournament:
      case HubEventKind.advance:
        await c.read(seasonServiceProvider).advance(careerId);
      case HubEventKind.campaignVerdict:
        await c.read(campaignServiceProvider).acknowledgeVerdict(careerId);
        if (e.route == Routes.campaigns) return false;
      case HubEventKind.cycleRollover:
        final v = await _read(rolloverVerdictProvider(careerId));
        await c
            .read(seasonServiceProvider)
            .startNextCycle(
              careerId,
              switchToNationId: null,
              boardTitle: v?.headline,
              boardBody: v?.detail,
            );
    }
    return true;
  }

  String _drawKind(Uri uri) {
    final wc = uri.queryParameters['worldCup'] == 'true';
    return switch (uri.path) {
      Routes.qualifyingDraw =>
        wc ? worldCupQualDrawKind : continentalQualDrawKind,
      Routes.continentalDraw => continentalFinalsDrawKind,
      Routes.finalsDraw => worldCupDrawKind,
      Routes.hostDraw => wc ? worldCupHostDrawKind : continentalHostDrawKind,
      Routes.intercontinentalPlayoff => worldCupPlayoffKind,
      Routes.nationsCupDraw => nationsCupDrawKind,
      _ => throw StateError('unknown draw ${uri.path}'),
    };
  }

  Future<void> _callUp(String? eventKind) async {
    final data = (await _read(squadDataProvider(careerId)))!;
    final window = await _read(nominationWindowProvider(careerId));
    final formation = await _read(currentFormationProvider(careerId));
    final picked = SquadSelection.bestQuality(
      pool: data.pool,
      absences: data.absences,
      coverage: math.max(1, window.matches.length),
      formation: formation,
      max: 23,
    );
    await c.read(squadServiceProvider).setCallUps(careerId, picked);
    if (eventKind != null) await _watch(eventKind);
    c.invalidate(hubDataProvider(careerId));
  }

  Future<void> _budget() async {
    final repo = c.read(careerRepositoryProvider);
    final career = (await repo.byId(careerId))!;
    final free = (await _read(federationFundsProvider(careerId))).free;
    const price = FederationFinance.investLevelPrice;
    int share(Department d) => math.min(
      (free ~/ 5) ~/ price * price,
      FederationFinance.maxLevels(d) * price,
    );
    int cap(Department d, int euros) => math.min(
      euros ~/ price * price,
      FederationFinance.maxLevels(d) * price,
    );
    // An engaged manager (LAB_ENGAGED) puts everything into the academy, and
    // what it cannot absorb into the naturalisation office.
    final youthAll = cap(Department.youth, free);
    final FederationInvestment a = labEngaged
        ? (
            youth: youthAll,
            commercial: 0,
            medical: 0,
            naturalization: cap(Department.naturalization, free - youthAll),
            boardRelations: 0,
          )
        : (
            youth: share(Department.youth),
            commercial: share(Department.commercial),
            medical: share(Department.medical),
            naturalization: share(Department.naturalization),
            boardRelations: share(Department.boardRelations),
          );
    final spend =
        a.youth +
        a.commercial +
        a.medical +
        a.naturalization +
        a.boardRelations;
    await repo.setInvestment(careerId, career.cyclePointer, a);
    await repo.setBudget(careerId, career.budget - spend);
    await _watch(budgetSetupKind);
    c
      ..invalidate(federationFundsProvider(careerId))
      ..invalidate(hubDataProvider(careerId));
  }

  Future<void> _friendlies() async {
    final plan = (await _read(friendliesPlanProvider(careerId)))!;
    final picks = <DateTime, int>{};
    for (final w in plan.windows.take(2)) {
      picks[w] = rivalIds[_friendlyCursor++ % rivalIds.length];
    }
    await c
        .read(friendliesServiceProvider)
        .arrange(
          careerId,
          nationId: plan.playerNationId,
          cycle: plan.cycle,
          picks: picks,
          allWindows: plan.windows,
        );
  }

  Future<void> _press() async {
    final svc = c.read(conferenceServiceProvider);
    c
      ..invalidate(pendingConferenceProvider(careerId))
      ..invalidate(previewDueProvider(careerId));
    var conf = await _read(pendingConferenceProvider(careerId));
    if (conf == null) {
      final due = await _read(previewDueProvider(careerId));
      if (due == null) return;
      await svc.openPreview(careerId, due);
      c.invalidate(pendingConferenceProvider(careerId));
      conf = await _read(pendingConferenceProvider(careerId));
    }
    if (conf == null) return;
    final isPreview = conf.facts.preview != null;
    final tb = ConferenceBuilder.throwback(conf.facts);
    final beats = isPreview
        ? ConferenceBuilder.previewBeats(conf.facts)
        : [ConferenceBuilder.opening(conf.facts)];
    final len = isPreview ? beats.length : (tb == null ? 2 : 3);
    for (var i = 0; i < len && i < beats.length; i++) {
      final beat = beats[i];
      const prefer = [
        AnswerKind.fearNobody,
        AnswerKind.teamFirst,
        AnswerKind.respectRival,
        AnswerKind.takeResponsibility,
        AnswerKind.creditPlayers,
      ];
      final a = prefer.firstWhere(
        beat.answers.contains,
        orElse: () => beat.answers.first,
      );
      await svc.answer(careerId, conf, i, beat, a);
      if (!isPreview) {
        if (i == 0) {
          beats.add(ConferenceBuilder.reaction(conf.facts, a));
        } else if (i == 1 && tb != null) {
          beats.add(tb);
        }
      }
    }
    await svc.finish(careerId, conf.row.id);
    c
      ..invalidate(pendingConferenceProvider(careerId))
      ..invalidate(previewDueProvider(careerId));
  }

  /// Leaves set pieces to the coach, as a manager may before kick-off.
  Future<void> prepareMatch() =>
      c.read(setPieceTakersStoreProvider).acceptAuto(careerId);

  /// Hands the armband to the best fit man for a photo, returning the old
  /// holder to restore after (the armband moves the result, and the story
  /// was found without one).
  Future<int?> lendArmband() async {
    final repo = c.read(careerRepositoryProvider);
    final career = (await repo.byId(careerId))!;
    c.invalidate(squadDataProvider(careerId));
    final data = (await _read(squadDataProvider(careerId)))!;
    bool fit(int id) =>
        data.callUps.contains(id) && (data.absences[id]?.isAvailable ?? true);
    final pick = data.pool.where((p) => fit(p.id)).toList()
      ..sort((a, b) {
        final byOverall = b.overall.compareTo(a.overall);
        return byOverall != 0 ? byOverall : b.age.compareTo(a.age);
      });
    if (pick.isNotEmpty) await repo.setCaptain(careerId, pick.first.id);
    _forgetCaptain();
    return career.captainPlayerId;
  }

  Future<void> returnArmband(int? previous) async {
    await c.read(careerRepositoryProvider).setCaptain(careerId, previous);
    _forgetCaptain();
  }

  // What the app's own `setCaptain` invalidates.
  void _forgetCaptain() => c
    ..invalidate(captainProvider)
    ..invalidate(storedCaptainIdProvider)
    ..invalidate(captainMoraleProvider)
    ..invalidate(squadDataProvider);

  Future<void> _match() async {
    await prepareMatch();
    c.invalidate(matchPreviewProvider(careerId));
    final p = (await _read(matchPreviewProvider(careerId)))!;
    await beforeMatch?.call(p);
    final salt = c.read(matchAttemptSaltProvider)();
    final result = _attemptFor(p, salt);
    await c
        .read(seasonServiceProvider)
        .playPlayerMatch(
          careerId,
          p.fixture,
          result,
          knockout: salt == 0 ? null : _knockoutFor(p, result, salt),
        );
    await c.read(achievementServiceProvider).checkAndRecord(careerId);
    final nation =
        (await c.read(careerRepositoryProvider).byId(careerId))!.nationId;
    final played =
        (await c
                .read(competitionRepositoryProvider)
                .fixturesForNation(careerId, nation))
            .firstWhere((f) => f.id == p.fixture.id);
    await afterMatch?.call(played);
  }
}

/// The result the live screen would play for [p]: the preview's own at
/// [salt] 0, otherwise the same match re-run from the salted seed, as
/// `_MatchScreenState._resim` does with no changes or talks.
MatchResult _attemptFor(MatchPreview p, int salt) {
  if (salt == 0) return p.result;
  final opp = p.playerIsHome ? p.awayTeam : p.homeTeam;
  return playWithAiExtraTimeSub(
    play: (subs) => const MatchEngine().play(
      home: p.homeTeam,
      away: p.awayTeam,
      rng: SeededRng.forFixture(p.saveSeed ^ salt, p.fixture.id),
      subs: subs,
      aiManagedNationIds: {opp.nationId},
      injuryFactorByNation: p.injuryFactorByNation,
      chemistryByNation: p.chemistryByNation,
      neutralVenue: p.neutralVenue,
      venueHostId: p.venueHostId,
      bigMatch: p.bigMatch,
      atmosphere: Attendance.atmosphere(p.ground),
      extraTimeIfLevel: Rounds.isKnockout(p.fixture.round),
    ),
    aiSubs: p.opponentSubs,
    aiTeam: opp,
    aiBench: p.opponentBench,
    saveSeed: p.saveSeed,
    fixtureId: p.fixture.id,
  );
}

/// The extra-time-and-shootout outcome the live screen hands over for a level
/// knockout played from [salt] (`_MatchScreenState._knockoutOutcome` with no
/// talks and automatic takers), or null when there is none. At salt 0 the
/// driver passes none, as before, and the season service draws its own.
KnockoutOutcome? _knockoutFor(MatchPreview p, MatchResult r, int salt) {
  if (!Rounds.isKnockout(p.fixture.round) || r.homeScore != r.awayScore) {
    return null;
  }
  final et = r.extraTime ?? (homeScore: r.homeScore, awayScore: r.awayScore);
  if (et.homeScore != et.awayScore) {
    return KnockoutOutcome(
      homeScore: et.homeScore,
      awayScore: et.awayScore,
      afterExtraTime: true,
      homeKicks: const [],
      awayKicks: const [],
    );
  }
  Set<int> sentOff(int nationId) => {
    for (final e in r.events)
      if (e.type == MatchEventType.redCard && e.teamNationId == nationId)
        e.playerId,
  };
  final me = p.playerIsHome ? p.homeTeam : p.awayTeam;
  final opp = p.playerIsHome ? p.awayTeam : p.homeTeam;
  final mySkill = PenaltyTakers.skillOrder(
    PenaltyTakers.autoOrder(
      me.xi,
      unavailable: sentOff(me.nationId),
      traitsByPlayer: me.traitsByPlayer,
    ),
    traitsByPlayer: me.traitsByPlayer,
  );
  final oppSkill = PenaltyTakers.skillOrder(
    PenaltyTakers.autoOrder(
      sideOnPitchAtEnd(
        team: opp,
        bench: p.opponentBench,
        plannedSubs: p.opponentSubs,
        events: r.events,
      ),
      unavailable: sentOff(opp.nationId),
      traitsByPlayer: opp.traitsByPlayer,
    ),
    traitsByPlayer: opp.traitsByPlayer,
  );
  return WorldCupFinals.decideShootout(
    et.homeScore,
    et.awayScore,
    SeededRng.forFixture(p.saveSeed ^ salt, p.fixture.id ^ 0x7F),
    homeTakerSkill: p.playerIsHome ? mySkill : oppSkill,
    awayTakerSkill: p.playerIsHome ? oppSkill : mySkill,
  );
}

String describe(Fixture f, {int nationId = england}) {
  final home = f.homeNationId == nationId;
  final opp = nationById[home ? f.awayNationId : f.homeNationId]!;
  final gf = home ? f.homeScore : f.awayScore;
  final ga = home ? f.awayScore : f.homeScore;
  final pens = f.wentToShootout
      ? ' pens ${home ? f.homePenalties : f.awayPenalties}-${home ? f.awayPenalties : f.homePenalties}'
      : '';
  final tags = [
    if (gf! < ga! && opp.ranking > 30) 'UPSET',
    if (rivalIds.contains(opp.id)) 'RIVAL',
  ];
  return '${f.date.toIso8601String().substring(0, 10)} ${f.round ?? 'FR'} '
      '${home ? 'H' : 'A'} ${opp.name}(#${opp.ranking}) $gf-$ga$pens '
      '${tags.join(' ')}';
}
