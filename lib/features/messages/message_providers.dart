import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/messages/intake_report.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';
import 'package:fnm/features/messages/watch_news.dart';
import 'package:fnm/features/squad/youth_watch_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';

/// How far a tournament must move the manager's nation before the inbox says
/// so, in world places.
///
/// A place is worth roughly three and a half ranking points in the middle of
/// the widened table, so five places is about seventeen points: more than a
/// campaign of qualifiers and friendlies can drift a side, and well inside
/// what one tournament does (a championship win can be worth twenty places).
/// Anything smaller is noise, and the brief is explicit that a one-place move
/// files nothing.
const int kRankJumpPlaces = 5;

/// A message to be added to the inbox if not already present.
///
/// The title and body are the message's MEANING, not its words: they are
/// rendered when the manager reads them, in whatever language he is reading in.
/// [rawBody] is the exception — a body that is an encoded report rather than a
/// sentence, stored as it comes, with [note] carrying the line above it.
class _Draft {
  const _Draft(
    this.key,
    this.category,
    this.title,
    this.body,
    this.year,
    this.phase, {
    this.rawBody,
    this.note,
  });
  final String key;
  final String category;
  final MsgPart title;
  final MsgPart? body;
  final String? rawBody;
  final MsgPart? note;
  final int year;

  /// Orders messages within a year: 0 cycle-start, 1 draw, 2 qualify, 3 result.
  final int phase;

  int get sort => year * 10 + phase;
}

/// Builds and persists the manager's inbox from the current save state. Each
/// message has a stable dedup key so re-syncing only adds what's new.
class MessageService {
  MessageService(this._ref);

  final Ref _ref;

  Future<void> sync(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    final comp = _ref.read(competitionRepositoryProvider);
    // The news is STORED AS MEANING and written when it is read, so the inbox
    // is in the manager's language whatever language the news happened in — see
    // `core/util/message_text.dart`. This reading of the strings is only for the
    // rendered columns that travel alongside the meaning.
    final l = _ref.read(appLocalizationsProvider);
    final nations = {
      for (final n in await _ref.read(nationRepositoryProvider).all()) n.id: n,
    };
    String nameOf(int id) => nations[id]?.name ?? l.msgANation;
    final conf = nations[career.nationId]?.confederation;
    // The continental cup by its CANONICAL STORED name, written for whoever
    // reads it — the same journey a competition name makes everywhere else.
    final contComp = MsgComp(
      conf == null
          ? 'Continental Championship'
          : ContinentalCups.byConfederation[conf]?.name ??
                'Continental Championship',
    );
    final cycle = career.cyclePointer;
    final wcYear = CareerService.worldCupYear(cycle);
    final existing = await comp.messageKeys(careerId);

    // In-game years each phase actually falls in, so messages read as the year
    // they happened rather than the far-off finals year.
    final cycleStartYear = cycle == 0
        ? CareerService.cycleStart.year
        : CareerService.worldCupYear(cycle - 1);
    final contYear = wcYear - 2; // the continental finals sit two years out

    // Named hosts, so the host-chosen messages actually say who won the bid.
    final nationList = nations.values.toList();
    final wcHostName = WorldCupHosts.hostsFor(
      year: wcYear,
      nations: nationList,
      seed: career.rngSeed,
    ).map(nameOf).join(' & ');
    // Every host, like the World Cup line above — naming only the primary told
    // the manager a jointly-hosted championship had one host.
    final contHosts = conf == null
        ? const <int>[]
        : WorldCupHosts.continentalHostsFor(
            confederation: conf,
            cycle: cycle,
            seed: career.rngSeed,
            nations: nationList,
          );
    final contHostName = contHosts.isEmpty
        ? l.msgAHostNation
        : contHosts.map(nameOf).join(' & ');

    final cycleSeed = varietySeed('cyclestart:$cycle:${career.rngSeed}');
    final drafts = <_Draft>[
      _Draft(
        'cycle:$cycle',
        'cycle',
        pickVariant([
          const MsgText(MsgKey.msgCycleTitle1),
          MsgText(MsgKey.msgCycleTitle2, [wcYear]),
          const MsgText(MsgKey.msgCycleTitle3),
          const MsgText(MsgKey.msgCycleTitle4),
        ], cycleSeed),
        pickVariant([
          MsgText(MsgKey.msgCycleBody1, [wcYear]),
          MsgText(MsgKey.msgCycleBody2, [wcYear]),
          MsgText(MsgKey.msgCycleBody3, [wcYear]),
          MsgText(MsgKey.msgCycleBody4, [wcYear]),
        ], cycleSeed),
        cycleStartYear,
        0,
      ),
    ];

    // Draws made this cycle, each dated to when it takes place.
    final drawSpecs = <(String, MsgPart, MsgPart, int)>[
      (
        continentalHostDrawKind,
        MsgText(MsgKey.msgContHostTitle, [contComp, contHostName]),
        MsgText(MsgKey.msgContHostBody, [contHostName, contComp]),
        cycleStartYear,
      ),
      (
        continentalQualDrawKind,
        MsgText(MsgKey.msgContQualDrawTitle, [contComp]),
        MsgText(MsgKey.msgContQualDrawBody, [contComp]),
        cycleStartYear,
      ),
      (
        worldCupHostDrawKind,
        MsgText(MsgKey.msgWcHostTitle, [wcHostName, wcYear]),
        MsgText(MsgKey.msgWcHostBody, [wcHostName, wcYear]),
        contYear,
      ),
      (
        worldCupQualDrawKind,
        const MsgText(MsgKey.msgWcQualDrawTitle),
        const MsgText(MsgKey.msgWcQualDrawBody),
        contYear,
      ),
      (
        continentalFinalsDrawKind,
        MsgText(MsgKey.msgContFinalsDrawTitle, [contComp]),
        MsgText(MsgKey.msgContFinalsDrawBody, [contComp]),
        contYear,
      ),
      (
        worldCupDrawKind,
        const MsgText(MsgKey.msgWcFinalsDrawTitle),
        MsgText(MsgKey.msgWcFinalsDrawBody, [wcYear]),
        wcYear,
      ),
    ];
    for (final (kind, title, body, year) in drawSpecs) {
      if (await comp.hasWatchedDraw(careerId, cycle, kind)) {
        drafts.add(_Draft('draw:$kind:$cycle', 'draw', title, body, year, 1));
      }
    }

    // Qualifications — inferred from the finals-group fixtures, dated to when
    // qualifying actually ends (a year or two before the finals themselves).
    final fixtures = await comp.fixturesForNation(careerId, career.nationId);
    for (final y in {
      for (final f in fixtures)
        if (f.round == 'GROUP') f.date.year,
    }) {
      final qs = varietySeed('qualwc:$y:${career.rngSeed}');
      drafts.add(
        _Draft(
          'qual:wc:$y',
          'qualify',
          pickVariant([
            const MsgText(MsgKey.msgQualWcTitle1),
            const MsgText(MsgKey.msgQualWcTitle2),
            const MsgText(MsgKey.msgQualWcTitle3),
            const MsgText(MsgKey.msgQualWcTitle4),
          ], qs),
          pickVariant([
            MsgText(MsgKey.msgQualWcBody1, [y]),
            MsgText(MsgKey.msgQualWcBody2, [y]),
            MsgText(MsgKey.msgQualWcBody3, [y]),
            MsgText(MsgKey.msgQualWcBody4, [y]),
          ], qs),
          y - 2,
          2,
        ),
      );
    }
    for (final y in {
      for (final f in fixtures)
        if (f.round == 'CGROUP') f.date.year,
    }) {
      final qcs = varietySeed('qualcont:$y:${career.rngSeed}');
      drafts.add(
        _Draft(
          'qual:cont:$y',
          'qualify',
          pickVariant([
            MsgText(MsgKey.msgQualContTitle1, [contComp]),
            MsgText(MsgKey.msgQualContTitle2, [contComp]),
            MsgText(MsgKey.msgQualContTitle3, [contComp]),
          ], qcs),
          pickVariant([
            MsgText(MsgKey.msgQualContBody1, [contComp]),
            MsgText(MsgKey.msgQualContBody2, [contComp]),
            MsgText(MsgKey.msgQualContBody3, [contComp]),
          ], qcs),
          y - 1,
          2,
        ),
      );
    }

    // Champions — this career's editions only (never the pre-seeded history).
    //
    // Every cup result is announced from its honour row, and only from there.
    // A background-simulated cup used to file its own message as well, so each
    // of the other confederations' titles arrived twice: once here without the
    // scoreline, and once from the simulator with it. The honour carries the
    // final score, so this is the one message and it carries the result.
    final honours = await comp.honours(careerId);
    for (final h in honours) {
      if (!CareerService.isOwnHonourYear(h.year)) continue;
      final display = MsgComp(h.competition);
      final mine = h.championId == career.nationId;

      final homeScore = h.finalHomeScore;
      final awayScore = h.finalAwayScore;
      // Read into the body as an argument, and empty when the final's score was
      // never recorded — the copy is written to close cleanly without it. A
      // level final was settled on penalties (the champion is stored first).
      final result = homeScore == null || awayScore == null
          ? ''
          : homeScore == awayScore
          ? MsgText(MsgKey.msgFinalPensSuffix, [homeScore, awayScore])
          : MsgText(MsgKey.msgFinalScoreSuffix, [homeScore, awayScore]);

      final chSeed = varietySeed(
        'champ:${h.competition}:${h.year}:${career.rngSeed}',
      );
      final loser = nameOf(h.runnerUpId);
      final champTitle = mine
          ? pickVariant([
              MsgText(MsgKey.msgChampTitleMine1, [display]),
              MsgText(MsgKey.msgChampTitleMine2, [display]),
              MsgText(MsgKey.msgChampTitleMine3, [display]),
            ], chSeed)
          : pickVariant([
              MsgText(MsgKey.msgChampTitleOther1, [display]),
              MsgText(MsgKey.msgChampTitleOther2, [display]),
              MsgText(MsgKey.msgChampTitleOther3, [display]),
            ], chSeed);
      final champBody = mine
          ? pickVariant([
              MsgText(MsgKey.msgChampBodyMine1, [
                display,
                loser,
                result,
                h.year,
              ]),
              MsgText(MsgKey.msgChampBodyMine2, [
                display,
                loser,
                result,
                h.year,
              ]),
              MsgText(MsgKey.msgChampBodyMine3, [
                display,
                loser,
                result,
                h.year,
              ]),
            ], chSeed)
          : pickVariant([
              MsgText(MsgKey.msgChampBodyOther1, [
                nameOf(h.championId),
                display,
                loser,
                result,
                h.year,
              ]),
              MsgText(MsgKey.msgChampBodyOther2, [
                nameOf(h.championId),
                display,
                loser,
                result,
                h.year,
              ]),
            ], chSeed);
      drafts.add(
        _Draft(
          'champ:${h.competition}:${h.year}',
          mine ? 'triumph' : 'champion',
          champTitle,
          champBody,
          h.year,
          3,
        ),
      );
    }

    // World Player of the Year — crowned at each World Cup from the finals'
    // leading marksmen, weighted by their level and how far their nation went.
    if (!existing.contains('wpoty:$cycle')) {
      final wc = honours
          .where((h) => h.competition == worldCupHonourName && h.year == wcYear)
          .toList();
      if (wc.isNotEmpty) {
        final honour = wc.first;
        final finalsScorers = await comp.topScorers(
          careerId,
          kind: CompetitionKind.worldCupFinals,
          limit: 12,
        );
        final playerRepo = _ref.read(playerRepositoryProvider);
        ({int nationId, String name, num score})? best;
        for (final s in finalsScorers.take(8)) {
          final p = await playerRepo.byId(
            s.playerId,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
          );
          if (p == null) continue;
          final teamBonus = s.nationId == honour.championId
              ? 25
              : s.nationId == honour.runnerUpId
              ? 10
              : 0;
          final score = s.goals * 10 + p.overall + teamBonus;
          if (best == null || score > best.score) {
            best = (nationId: s.nationId, name: p.name, score: score);
          }
        }
        if (best != null) {
          final mine = best.nationId == career.nationId;
          drafts.add(
            _Draft(
              'wpoty:$cycle',
              'award',
              const MsgText(MsgKey.msgWpotyTitle),
              MsgText(
                mine ? MsgKey.msgWpotyBodyMine : MsgKey.msgWpotyBodyOther,
                [best.name, nameOf(best.nationId), wcYear],
              ),
              wcYear,
              4,
            ),
          );
        }

        // Young Player of the Tournament — the standout finals performer aged
        // 21 or under, weighted like the senior award. A separate trophy so a
        // breakout star is recognised even when a veteran takes the main prize.
        ({int nationId, String name, int age, num score})? young;
        for (final s in finalsScorers) {
          final p = await playerRepo.byId(
            s.playerId,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
          );
          if (p == null || p.age > 21) continue;
          final teamBonus = s.nationId == honour.championId
              ? 25
              : s.nationId == honour.runnerUpId
              ? 10
              : 0;
          final score = s.goals * 10 + p.overall + teamBonus;
          if (young == null || score > young.score) {
            young = (
              nationId: s.nationId,
              name: p.name,
              age: p.age,
              score: score,
            );
          }
        }
        if (young != null) {
          final mine = young.nationId == career.nationId;
          drafts.add(
            _Draft(
              'ypot:$cycle',
              'award',
              const MsgText(MsgKey.msgYpotTitle),
              MsgText(
                mine ? MsgKey.msgYpotBodyMine : MsgKey.msgYpotBodyOther,
                [young.name, nameOf(young.nationId), young.age, wcYear],
              ),
              wcYear,
              4,
            ),
          );
        }
      }
    }

    // Every world-ranking release: who leads, where the manager's nation sits,
    // and how far it has moved this cycle.
    //
    // Movement is measured against the SAME freeze the ranking screen's arrows
    // use — [movementBaselineFor], the World Championship draw that ended the
    // previous cycle. Reporting the move since the previous release instead
    // made the inbox narrate every monthly wiggle while the screen showed only
    // the net change, so the two flatly disagreed; and across a change of
    // nation it compared the old nation's rank with the new one's, announcing
    // a job change as a 37-place climb.
    final releases = await _ref
        .read(rankingReleaseRepositoryProvider)
        .all(careerId);
    final seedRanks = _ref.read(seedRankingRepositoryProvider);
    for (final release in releases) {
      final baseline = await movementBaselineFor(
        seedRanks,
        careerId,
        release.cycle,
      );
      // Cycle 0 (and any legacy save) has no snapshot: fall back to the static
      // seed ranking, exactly as the screen's baseline provider does.
      final was =
          baseline.rankById[release.nationId] ??
          nations[release.nationId]?.ranking;
      final leader = nameOf(release.leaderNationId);
      final rank = release.playerRank;

      final rSeed = varietySeed(
        'rank:${release.publishedOn.toIso8601String()}:'
        '${career.rngSeed}',
      );
      final MsgText movement;
      if (was == null || was == rank) {
        movement = pickVariant([
          MsgText(MsgKey.msgRankHold1, [rank]),
          MsgText(MsgKey.msgRankHold2, [rank]),
          MsgText(MsgKey.msgRankHold3, [rank]),
        ], rSeed);
      } else {
        final move = was - rank; // positive = climbed
        movement = move > 0
            ? pickVariant([
                MsgText(MsgKey.msgRankUp1, [move, rank]),
                MsgText(MsgKey.msgRankUp2, [move, rank]),
                MsgText(MsgKey.msgRankUp3, [move, rank]),
              ], rSeed)
            : pickVariant([
                MsgText(MsgKey.msgRankDown1, [-move, rank]),
                MsgText(MsgKey.msgRankDown2, [-move, rank]),
                MsgText(MsgKey.msgRankDown3, [-move, rank]),
              ], rSeed);
      }
      final lead = release.leaderNationId == release.nationId
          ? const MsgText(MsgKey.msgRankLeadYou)
          : MsgText(MsgKey.msgRankLeadOther, [leader]);

      drafts.add(
        _Draft(
          'rankrel:${release.publishedOn.toIso8601String()}',
          'ranking',
          MsgText(MsgKey.msgRankTitle, [rank]),
          MsgText(MsgKey.msgRankBody, [lead, movement]),
          release.publishedOn.year,
          0,
        ),
      );
    }

    // The swing a World Championship itself produced: where the nation went
    // into the finals and where it came out.
    //
    // Tournament placings move the ranking hard now — a champion can climb
    // twenty places — but the move was, until this, invisible: the cycle
    // baseline the screen's arrows measure against is re-frozen at the
    // rollover that follows the final, from the standings that final produced,
    // so by the time the manager looked every arrow read zero. This is the one
    // record of it, and being a stored message it survives the rollover.
    final stints = await _ref.read(careerRepositoryProvider).stints(careerId);
    for (final h in honours) {
      if (h.competition != worldCupHonourName) continue;
      if (!CareerService.isOwnHonourYear(h.year)) continue;
      final tournamentCycle = (h.year - CareerService.cycleStart.year) ~/ 4 - 1;
      if (tournamentCycle < 0) continue;
      if (existing.contains('rankjump:$tournamentCycle')) continue;

      // Whose climb it was: the nation the manager held that cycle, not
      // whoever he has moved on to since.
      final movedNation = stints[tournamentCycle] ?? career.nationId;
      // Before: the live ranking frozen when the finals were drawn, which is
      // after every qualifier and before a ball of the finals was kicked.
      final before = await seedRanks.forCycle(
        careerId,
        drawSeedCycle(tournamentCycle, drawSlotWorldCupFinals),
      );
      final from = before[movedNation];
      if (from == null) continue;
      final to = await _rankAfter(careerId, tournamentCycle, movedNation);
      if (to == null) continue;

      final move = from - to; // positive = climbed
      if (move.abs() < kRankJumpPlaces) continue;
      final tournament = MsgComp(h.competition);
      final who = nameOf(movedNation);
      drafts.add(
        _Draft(
          'rankjump:$tournamentCycle',
          'ranking',
          MsgText(
            move > 0 ? MsgKey.msgRankJumpTitleUp : MsgKey.msgRankJumpTitleDown,
            [to],
          ),
          move > 0
              ? MsgText(MsgKey.msgRankJumpBodyUp, [
                  tournament,
                  who,
                  from,
                  to,
                  move,
                ])
              : MsgText(MsgKey.msgRankJumpBodyDown, [
                  tournament,
                  who,
                  from,
                  to,
                  -move,
                ]),
          h.year,
          3,
        ),
      );
    }

    // Player milestones — caps and goals crossing round numbers. Each is filed
    // once (the dedup key carries the threshold), so they surface the season a
    // player passes them and never repeat.
    final playerRepo = _ref.read(playerRepositoryProvider);
    final agingYears = CareerService.agingYears(career);
    final milestoneNames = <int, String>{};
    Future<String> playerName(int id) async {
      if (milestoneNames.containsKey(id)) return milestoneNames[id]!;
      final p = await playerRepo.byId(
        id,
        agingYears: agingYears,
        saveSeed: career.rngSeed,
      );
      return milestoneNames[id] = p?.name ?? l.msgAPlayer;
    }

    const capTiers = [25, 50, 100, 150];
    const goalTiers = [10, 25, 50, 75, 100];
    final milestoneYear = career.inGameDate.year;
    final caps = await comp.nationTopAppearances(
      careerId,
      career.nationId,
      limit: 60,
    );
    for (final c in caps) {
      for (final t in capTiers) {
        if (c.games < t) continue;
        final key = 'mile:caps:${c.playerId}:$t';
        if (existing.contains(key)) continue;
        final name = await playerName(c.playerId);
        drafts.add(
          _Draft(
            key,
            'milestone',
            MsgText(MsgKey.msgCapsTitle, [name, t]),
            MsgText(MsgKey.msgCapsBody, [name, t]),
            milestoneYear,
            5,
          ),
        );
      }
    }
    final scorers = await comp.nationTopScorers(
      careerId,
      career.nationId,
      limit: 60,
    );
    for (final s in scorers) {
      for (final t in goalTiers) {
        if (s.goals < t) continue;
        final key = 'mile:goals:${s.playerId}:$t';
        if (existing.contains(key)) continue;
        final name = await playerName(s.playerId);
        drafts.add(
          _Draft(
            key,
            'milestone',
            MsgText(MsgKey.msgGoalsTitle, [name, t]),
            MsgText(MsgKey.msgGoalsBody, [name, t]),
            milestoneYear,
            5,
          ),
        );
      }
    }

    // Yearly squad report — how the player's pool aged each season (who
    // improved, declined, retired, or emerged). Computed only for years that
    // don't yet have a report.
    final currentYears = CareerService.agingYears(career);
    final missingYears = [
      for (var y = 1; y <= currentYears; y++)
        if (!existing.contains('aging:$y')) y,
    ];
    if (missingYears.isNotEmpty) {
      final playerRepo = _ref.read(playerRepositoryProvider);
      // The same development inputs the rest of the app derives players with,
      // so the intake reported here is the intake the Youth screen shows.
      final academyBonus = await _ref.read(
        youthBonusByCycleProvider(careerId).future,
      );
      // The standing half of that same total, so the intake note can name the
      // cause rather than leaving the manager to guess which of the two paid.
      final standingBonus = await _ref.read(
        intakeStandingByCycleProvider(careerId).future,
      );
      final careerDev = await _ref.read(
        careerDevBonusProvider(careerId).future,
      );
      final needed = <int>{
        for (final y in missingYears) ...[y, y - 1],
      };
      final squads = <int, Map<int, Player>>{};
      for (final y in needed) {
        final list = await playerRepo.byNation(
          career.nationId,
          agingYears: y,
          saveSeed: career.rngSeed,
        );
        squads[y] = {for (final p in list) p.id: p};
      }
      // Career caps/goals, to judge who deserves an individual send-off and who
      // belongs in the hall of fame.
      final capsById = {for (final c in caps) c.playerId: c.games};
      final goalsById = {for (final s in scorers) s.playerId: s.goals};
      // Who has actually been in the squad. The milestone list above is a
      // top-sixty leaderboard and would call four fifths of the pool fringe;
      // this is every man with a cap to his name, plus whoever is called up
      // right now and has yet to play one.
      final everCapped = await comp.nationTopAppearances(
        careerId,
        career.nationId,
        limit: 500,
      );
      final calledUp = <int>{
        for (final a in everCapped)
          if (a.games > 0) a.playerId,
        ...await _ref.read(squadRepositoryProvider).callUps(careerId),
      };

      for (final y in missingYears) {
        final reportYear = CareerService.cycleStart.year + y;
        // Two reports, not one. Who grew and who faded is a question about the
        // side you already have; who has just come through is a question about
        // the side you are about to have. Bundled together, the newcomers —
        // the part of the year a manager actually wants to read — were three
        // rows at the top of a hundred-row table of ±1 rating moves.
        final before = squads[y - 1]!;
        final after = squads[y]!;
        drafts.add(
          _Draft(
            'aging:$y',
            'aging',
            MsgText(MsgKey.msgDevTitle, [reportYear]),
            null,
            reportYear,
            4,
            rawBody: _developmentReport(before, after, calledUp),
          ),
        );
        // These are the boys who have come THROUGH the pyramid and are old
        // enough for the senior pool — not a second intake. Reported as one
        // used to be ("New faces", rows tagged "new", scout stars beside
        // them), it read as though the academy took an intake twice a year,
        // once at eleven and again at seventeen. Same news, said properly.
        final newcomers = _newcomerReport(
          before,
          after,
          l.msgThroughNote,
          scout: career.staffScout,
        );
        if (newcomers != null) {
          drafts.add(
            _Draft(
              'newcomers:$y',
              'aging',
              MsgText(MsgKey.msgThroughTitle, [reportYear]),
              null,
              reportYear,
              4,
              rawBody: newcomers,
              note: const MsgText(MsgKey.msgThroughNote),
            ),
          );
        }

        // The year's academy intake: the eleven-year-olds who have just come
        // in. The pyramid was otherwise silent — a manager only learned an
        // intake had happened by going and looking for it.
        final pyramid = await playerRepo.youthByNation(
          career.nationId,
          agingYears: y,
          saveSeed: career.rngSeed,
          youthBonusByCycle: academyBonus,
          careerStartsByPlayer: careerDev,
        );
        final intake = intakeRows(pyramid, scout: career.staffScout);
        // Which of the two causes brought a better crop through, as a KEY: the
        // note above the table is stored as meaning like the rest of the
        // message, so it is written in the language it is read in.
        final intakeCycle = PlayerLifecycle.cycleOfIntake(y);
        final standing = standingBonus[intakeCycle] ?? 0;
        final noteKey = intakeNoteKey(
          // The stored total carries both; the academy's own share is what is
          // left once the standing is taken back out.
          academyBonus: (academyBonus[intakeCycle] ?? 0) - standing,
          standingBonus: standing,
        );
        if (intake.isNotEmpty) {
          drafts.add(
            _Draft(
              'intake:$y',
              'youth',
              MsgText(MsgKey.msgIntakeTitle, [reportYear]),
              null,
              reportYear,
              4,
              rawBody: encodeSquadDevReport(
                intake,
                note: noteKey == null
                    ? null
                    : renderMsgKey(l, MsgText(noteKey)),
              ),
              note: noteKey == null ? null : MsgText(noteKey),
            ),
          );
        }

        // Notable individuals bowing out — a dignified international retirement
        // announcement, and a hall-of-fame induction for the true greats. Both
        // are derived from the same year-on-year pool diff the report uses.
        final retirees =
            [
              for (final e in squads[y - 1]!.entries)
                if (!squads[y]!.containsKey(e.key) && e.value.age >= 34)
                  e.value,
            ]..sort((a, b) {
              final ca = (capsById[a.id] ?? 0) + (goalsById[a.id] ?? 0);
              final cb = (capsById[b.id] ?? 0) + (goalsById[b.id] ?? 0);
              return cb.compareTo(ca);
            });
        for (final p in retirees) {
          final pc = capsById[p.id] ?? 0;
          final pg = goalsById[p.id] ?? 0;
          // Worth an individual send-off: a real international career, not a
          // fringe player who won a couple of caps.
          final notable = pc >= 30 || pg >= 15 || p.overall >= 82;
          // Losing the captain is not just another retirement: the armband is
          // vacant from here, and the manager has to be told rather than
          // finding out when the morale lift quietly stops.
          final wasCaptain = career.captainPlayerId == p.id;
          if (wasCaptain) {
            await _ref
                .read(careerRepositoryProvider)
                .setCaptain(careerId, null);
            // Everything that answers "who is captain" reads the career row
            // imperatively, so clearing it behind their backs left the screens
            // (and the pre-match strip) still naming a man who has retired.
            _ref
              ..invalidate(captainProvider)
              ..invalidate(storedCaptainIdProvider)
              ..invalidate(captainMoraleProvider)
              ..invalidate(careerByIdProvider);
          }
          if ((notable || wasCaptain) && !existing.contains('retire:${p.id}')) {
            // His record, as pieces rather than as a sentence: a tally is two
            // plurals with a comma between them, and both of them count
            // differently in Czech.
            final tally = MsgJoin([
              if (pc > 0) MsgText(MsgKey.msgTallyCaps, [pc]),
              if (pg > 0) MsgText(MsgKey.msgTallyGoals, [pg]),
            ], separator: ', ');
            final farewell = tally.parts.isEmpty
                ? MsgText(MsgKey.msgRetireBody, [p.name, p.age])
                : MsgText(MsgKey.msgRetireBodyWith, [p.name, tally, p.age]);
            drafts.add(
              _Draft(
                'retire:${p.id}',
                'retirement',
                MsgText(
                  wasCaptain
                      ? MsgKey.msgRetireCaptainTitle
                      : MsgKey.msgRetireTitle,
                  [p.name],
                ),
                wasCaptain
                    ? MsgJoin([
                        farewell,
                        const MsgText(MsgKey.msgArmbandVacant),
                      ])
                    : farewell,
                reportYear,
                4,
              ),
            );
          }
          // Hall of Fame — reserved for the genuine greats.
          final worthy = pc >= 60 || pg >= 30;
          if (worthy && !existing.contains('hof:${p.id}')) {
            drafts.add(
              _Draft(
                'hof:${p.id}',
                'halloffame',
                MsgText(MsgKey.msgHofTitle, [p.name]),
                MsgText(MsgKey.msgHofBody, [p.name, pc, pg]),
                reportYear,
                4,
              ),
            );
          }
        }
      }
    }

    // The boys the manager has BOOKMARKED on the youth screen. Nothing at all
    // happens for a save with an empty watchlist, which is most of them: the
    // pyramid is a derived pool and building it is not free.
    final marks = await loadYouthMarks(careerId);
    if (marks.isNotEmpty) {
      final academy = await _ref.read(
        youthBonusByCycleProvider(careerId).future,
      );
      final devBonus = await _ref.read(careerDevBonusProvider(careerId).future);
      final youthByYear = <int, Map<int, Player>>{};
      Future<Map<int, Player>> youthAt(int y) async {
        final cached = youthByYear[y];
        if (cached != null) return cached;
        final pool = await playerRepo.youthByNation(
          career.nationId,
          agingYears: y,
          saveSeed: career.rngSeed,
          youthBonusByCycle: academy,
          careerStartsByPlayer: devBonus,
        );
        return youthByYear[y] = {for (final p in pool) p.id: p};
      }

      // One digest a year, and only for years that passed while the boy was
      // already marked: bookmarking a fifteen-year-old today must not backfill
      // four reports about the seasons nobody was watching him.
      for (var y = 1; y <= currentYears; y++) {
        final key = 'watch:$y';
        if (existing.contains(key)) continue;
        final watched = {
          for (final m in marks)
            if (m.year < y) m.playerId,
        };
        if (watched.isEmpty) continue;
        final reportYear = CareerService.cycleStart.year + y;
        final digest = watchlistDigest(
          marked: watched,
          now: await youthAt(y),
          before: await youthAt(y - 1),
          year: reportYear,
        );
        if (digest == null) continue;
        drafts.add(
          _Draft(key, 'youth', digest.title, digest.body, reportYear, 4),
        );
      }

      // A debut is not a rollover event, so it is judged against the WHOLE
      // appearance list rather than the top-sixty leaderboard above: a boy's
      // first cap is one game, and one game does not reach a leaderboard.
      // Skipped entirely once every marked boy has his, which is the steady
      // state — the inbox syncs on every read and this is a pool build.
      final undebuted = {
        for (final m in marks)
          if (!existing.contains('watch:debut:${m.playerId}')) m.playerId,
      };
      if (undebuted.isNotEmpty) {
        final appearances = await comp.nationTopAppearances(
          careerId,
          career.nationId,
          limit: 500,
        );
        for (final debut in watchlistDebuts(
          marked: undebuted,
          pool: await youthAt(currentYears),
          capsByPlayer: {for (final a in appearances) a.playerId: a.games},
        )) {
          drafts.add(
            _Draft(
              'watch:debut:${debut.playerId}',
              // A milestone rather than 'youth', which is held back while a
              // tournament is being played: he won the cap IN the tournament.
              'milestone',
              debut.title,
              debut.body,
              career.inGameDate.year,
              5,
            ),
          );
        }
      }
    }

    drafts.sort((a, b) => a.sort.compareTo(b.sort));
    for (final d in drafts) {
      if (existing.contains(d.key)) continue;
      await comp.addTextMessage(
        l: l,
        careerId: careerId,
        dedupKey: d.key,
        category: d.category,
        title: d.title,
        body: d.body,
        rawBody: d.rawBody,
        note: d.note,
        year: d.year,
      );
    }
  }

  /// Where [nationId] stood once the [cycle] World Championship was over.
  ///
  /// A cycle that has already rolled over has the answer in store: the seeding
  /// snapshot for the NEXT cycle is frozen at the rollover, which happens
  /// straight after the final, so it is the post-tournament table itself.
  ///
  /// Otherwise the live ranking answers — and this is where the save can lie.
  /// The message is filed by the sync that runs immediately after the final,
  /// in the same step that settled it, and `worldRankingProvider` is a derived
  /// provider that does not notice a simulation step: read as it stands it
  /// hands back the table from BEFORE the tournament, and the message would
  /// state, confidently and permanently, the position the nation held before
  /// the thing it is reporting. So it is invalidated first.
  Future<int?> _rankAfter(int careerId, int cycle, int nationId) async {
    final rolled = await _ref
        .read(seedRankingRepositoryProvider)
        .forCycle(careerId, cycle + 1);
    if (rolled.isNotEmpty) return rolled[nationId];
    _ref.invalidate(worldRankingProvider(careerId));
    final live = await _ref.read(worldRankingProvider(careerId).future);
    return live?.position[nationId];
  }
}

/// The year's development report from [before] → [after] (keyed by player id):
/// who stepped up, who declined and who retired, each with their rating move.
///
/// Newcomers are deliberately absent — they get [_newcomerReport] to
/// themselves.
String _developmentReport(
  Map<int, Player> before,
  Map<int, Player> after,
  Set<int> calledUp,
) {
  final rows = <SquadDevRow>[];
  for (final e in after.entries) {
    final was = before[e.key];
    if (was == null) continue; // a new face, reported separately
    rows.add(
      SquadDevRow(
        name: e.value.name,
        age: e.value.age,
        position: e.value.position.label,
        rating: e.value.overall,
        change: e.value.overall - was.overall,
        status: SquadDevStatus.stayed,
        tier: squadDevTierFor(
          calledUp: calledUp.contains(e.key),
          age: e.value.age,
        ),
      ),
    );
  }
  for (final e in before.entries) {
    if (after.containsKey(e.key)) continue;
    rows.add(
      SquadDevRow(
        name: e.value.name,
        age: e.value.age,
        position: e.value.position.label,
        rating: e.value.overall,
        status: SquadDevStatus.gone,
        // A man who has left is read where he played: a retiring regular is
        // news about the first eleven, not about the reserves.
        tier: squadDevTierFor(
          calledUp: calledUp.contains(e.key),
          age: e.value.age,
        ),
      ),
    );
  }
  return encodeSquadDevReport(rows);
}

/// The players who have come into the pool this year, with the scouting read on
/// each — so a wonderkid is a headline rather than one line among a hundred.
/// Null when nobody emerged.
String? _newcomerReport(
  Map<int, Player> before,
  Map<int, Player> after,
  String note, {
  StaffTier scout = StaffTier.none,
}) {
  final rows = <SquadDevRow>[
    for (final e in after.entries)
      if (!before.containsKey(e.key))
        SquadDevRow(
          name: e.value.name,
          age: e.value.age,
          position: e.value.position.label,
          rating: e.value.overall,
          status: SquadDevStatus.arrived,
          // Unproven, so this is the scout's read, not the truth — the same
          // estimate the under-21 watchlist shows, and it can be a star out.
          stars: Prospects.scoutedStars(
            e.value.id,
            age: e.value.age,
            scout: scout,
          ),
          wonderkid:
              e.value.age <= 21 &&
              Prospects.trueStars(e.value.id, age: e.value.age) >= 5,
        ),
  ];
  if (rows.isEmpty) return null;
  return encodeSquadDevReport(rows, note: note);
}

final Provider<MessageService> messageServiceProvider =
    Provider<MessageService>(MessageService.new);

/// The inbox plus its unread count, syncing new events on read.
typedef MessageInbox = ({List<MessageItem> messages, int unread});

final AutoDisposeFutureProviderFamily<MessageInbox, int> messageInboxProvider =
    FutureProvider.autoDispose.family<MessageInbox, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      await ref.watch(messageServiceProvider).sync(careerId);
      final messages = await ref
          .watch(competitionRepositoryProvider)
          .messages(careerId);
      return (
        messages: messages,
        unread: messages.where((m) => !m.read).length,
      );
    });

/// The inbox categories that are held back while a tournament is being played.
///
/// These are the between-seasons items — how the pool aged, who came through
/// the academy, who moved club, the year's awards. They are worth reading and
/// worth reading LATER: arriving as a popup between a quarter-final and a
/// semi-final, they interrupt the one thing the manager is actually in the
/// middle of. Match news (a ban, an injury, going out) is not held: that IS
/// the tournament.
const Set<String> kBetweenSeasonsCategories = {
  'aging',
  'youth',
  'award',
  'record',
  'transfer',
  'naturalize',
  'halloffame',
};

/// Whether a tournament the manager is following is under way right now.
///
/// True from the moment a finals group stage kicks off until its final has
/// been played — for the World Cup, or for the manager's own continental cup.
/// Deliberately about the TOURNAMENT rather than about this nation's own
/// fixtures: a manager knocked out in the group stage is still stepping
/// through the rest of it, and a side between the group stage and a knockout
/// round it has not been drawn into yet has no unplayed fixture to detect.
final AutoDisposeFutureProviderFamily<bool, int> tournamentInProgressProvider =
    FutureProvider.autoDispose.family<bool, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return false;
      final comp = ref.watch(competitionRepositoryProvider);
      final conf = (await ref.watch(nationRepositoryProvider).all())
          .where((n) => n.id == career.nationId)
          .firstOrNull
          ?.confederation;

      Future<bool> running(
        String groupRound,
        String finalRound,
        CompetitionKind kind, {
        Confederation? confederation,
      }) async {
        final group = await comp.fixturesByRound(
          careerId,
          groupRound,
          kind: kind,
          confederation: confederation,
        );
        if (!group.any((f) => f.hasResult)) return false;
        final decider = await comp.fixturesByRound(
          careerId,
          finalRound,
          kind: kind,
          confederation: confederation,
        );
        return decider.isEmpty || decider.any((f) => !f.hasResult);
      }

      if (await running('GROUP', 'FINAL', CompetitionKind.worldCupFinals)) {
        return true;
      }
      if (conf == null) return false;
      return running(
        'CGROUP',
        'CFINAL',
        CompetitionKind.continentalFinals,
        confederation: conf,
      );
    });

/// Unread-message count, for the navigation badge.
final AutoDisposeFutureProviderFamily<int, int> unreadMessagesProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
      final inbox = await ref.watch(messageInboxProvider(careerId).future);
      return inbox.unread;
    });
