import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/messages/intake_report.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';

/// A message to be added to the inbox if not already present.
class _Draft {
  const _Draft(
    this.key,
    this.category,
    this.title,
    this.body,
    this.year,
    this.phase,
  );
  final String key;
  final String category;
  final String title;
  final String body;
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
    final nations = {
      for (final n in await _ref.read(nationRepositoryProvider).all()) n.id: n,
    };
    String nameOf(int id) => nations[id]?.name ?? 'A nation';
    final conf = nations[career.nationId]?.confederation;
    final contName = conf == null
        ? 'the continental championship'
        : ContinentalCups.byConfederation[conf]?.name ??
              'the continental championship';
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
        ? 'a host nation'
        : contHosts.map(nameOf).join(' & ');

    final cycleSeed = varietySeed('cyclestart:$cycle:${career.rngSeed}');
    final drafts = <_Draft>[
      _Draft(
        'cycle:$cycle',
        'cycle',
        pickVariant([
          'A new cycle begins',
          'The road to $wcYear opens',
          'A fresh campaign dawns',
          'Back to work',
        ], cycleSeed),
        pickVariant([
          'The road to the $wcYear World Cup starts here.',
          'A new cycle. The $wcYear World Cup is the target.',
          'Four years to the $wcYear World Cup. Work starts now.',
          'The $wcYear campaign begins today.',
        ], cycleSeed),
        cycleStartYear,
        0,
      ),
    ];

    // Draws made this cycle, each dated to when it takes place.
    final drawSpecs = <(String, String, String, int)>[
      (
        continentalHostDrawKind,
        '$contName host: $contHostName',
        '$contHostName will host the next $contName.',
        cycleStartYear,
      ),
      (
        continentalQualDrawKind,
        '$contName qualifying draw',
        'The $contName qualifying groups have been drawn.',
        cycleStartYear,
      ),
      (
        worldCupHostDrawKind,
        '$wcYear World Cup host: $wcHostName',
        '$wcHostName will host the $wcYear World Cup.',
        contYear,
      ),
      (
        worldCupQualDrawKind,
        'World Cup qualifying draw',
        'The World Cup qualifying groups have been drawn.',
        contYear,
      ),
      (
        continentalFinalsDrawKind,
        '$contName finals draw',
        'The $contName finals groups have been drawn.',
        contYear,
      ),
      (
        worldCupDrawKind,
        'World Cup finals draw',
        'The $wcYear World Cup finals draw has been made.',
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
            'Through to the World Cup',
            'World Cup booked',
            "We're going to the World Cup",
            'Ticket punched',
          ], qs),
          pickVariant([
            'You have qualified for the $y World Cup finals.',
            "It's official: your nation is at the $y World Cup.",
            'A place at the $y World Cup is secured.',
            "You're through to the $y World Cup finals.",
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
            'Through to $contName',
            '$contName booked',
            'Qualified for $contName',
          ], qcs),
          pickVariant([
            'You have qualified for the $contName finals.',
            'Your nation has sealed its place at $contName.',
            "You're through to $contName.",
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
      if (h.year < CareerService.cycleStart.year) continue;
      final display = h.competition == worldCupHonourName
          ? 'World Cup'
          : h.competition;
      final mine = h.championId == career.nationId;

      final scored = h.finalHomeScore != null && h.finalAwayScore != null;
      // A level final was settled on penalties (the champion is stored first).
      final pens = scored && h.finalHomeScore == h.finalAwayScore;
      final result = !scored
          ? ''
          : pens
          ? ' on penalties, after a ${h.finalHomeScore}–'
                '${h.finalAwayScore} final'
          : ' ${h.finalHomeScore}–${h.finalAwayScore} in the final';

      final chSeed = varietySeed(
        'champ:${h.competition}:${h.year}:${career.rngSeed}',
      );
      final champTitle = mine
          ? pickVariant([
              '$display CHAMPIONS!',
              'Champions of the $display!',
              "You've won the $display!",
            ], chSeed)
          : pickVariant([
              '$display decided',
              '$display champions crowned',
              'The $display is won',
            ], chSeed);
      final champBody = mine
          ? pickVariant([
              'Your nation are the ${h.year} $display champions, beating '
                  '${nameOf(h.runnerUpId)}$result.',
              "You've won the ${h.year} $display, seeing off "
                  '${nameOf(h.runnerUpId)}$result.',
              'The ${h.year} $display is yours. '
                  '${nameOf(h.runnerUpId)} beaten$result.',
            ], chSeed)
          : pickVariant([
              '${nameOf(h.championId)} won the ${h.year} $display, beating '
                  '${nameOf(h.runnerUpId)}$result.',
              '${nameOf(h.championId)} are the ${h.year} $display champions, '
                  'defeating ${nameOf(h.runnerUpId)}$result.',
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
              'World Player of the Year',
              '${best.name} (${nameOf(best.nationId)}) is named $wcYear '
                  'World Player of the Year${mine ? ', one of yours.' : '.'}',
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
              'Young Player of the Tournament',
              '${young.name} (${nameOf(young.nationId)}), aged ${young.age}, is '
                  'named $wcYear Young Player of the Tournament'
                  '${mine ? ', one of yours.' : '.'}',
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
    // Movement is measured against the cycle's starting positions — the SAME
    // baseline the ranking screen's arrows use (see worldRankingProvider).
    // Reporting the move since the previous release instead made the inbox
    // narrate every monthly wiggle while the screen showed only the net change,
    // so the two flatly disagreed; and across a change of nation it compared
    // the old nation's rank with the new one's, announcing a job change as a
    // 37-place climb.
    final releases = await _ref
        .read(rankingReleaseRepositoryProvider)
        .all(careerId);
    final seedRanks = _ref.read(seedRankingRepositoryProvider);
    for (final release in releases) {
      final baseline = await seedRanks.forCycle(careerId, release.cycle);
      // Cycle 0 (and any legacy save) has no snapshot: fall back to the static
      // seed ranking, exactly as seedRankByIdProvider does.
      final was =
          baseline[release.nationId] ?? nations[release.nationId]?.ranking;
      final leader = nameOf(release.leaderNationId);
      final rank = release.playerRank;

      final rSeed = varietySeed(
        'rank:${release.publishedOn.toIso8601String()}:'
        '${career.rngSeed}',
      );
      final String movement;
      if (was == null || was == rank) {
        movement = pickVariant([
          'You hold at #$rank.',
          'No change, still #$rank.',
          'Steady at #$rank.',
        ], rSeed);
      } else {
        final move = was - rank; // positive = climbed
        final places = move.abs() == 1 ? 'place' : 'places';
        movement = move > 0
            ? pickVariant([
                'Up $move $places this cycle, to #$rank.',
                'A climb of $move $places lifts you to #$rank.',
                "Up $move $places, now #$rank.",
              ], rSeed)
            : pickVariant([
                'Down ${-move} $places this cycle, to #$rank.',
                'A slide of ${-move} $places drops you to #$rank.',
                "Down ${-move} $places, now #$rank.",
              ], rSeed);
      }
      final lead = release.leaderNationId == release.nationId
          ? 'You top the world.'
          : '$leader top the world.';

      drafts.add(
        _Draft(
          'rankrel:${release.publishedOn.toIso8601String()}',
          'ranking',
          'World ranking · #$rank',
          'The world ranking has been updated. $lead $movement',
          release.publishedOn.year,
          0,
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
      return milestoneNames[id] = p?.name ?? 'A player';
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
            '$name reaches $t caps',
            '$name has now made $t appearances for your nation.',
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
            '$name reaches $t goals',
            '$name has scored $t international goals for your nation.',
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
            'Squad development · $reportYear',
            _developmentReport(before, after),
            reportYear,
            4,
          ),
        );
        final newcomers = _newcomerReport(before, after);
        if (newcomers != null) {
          drafts.add(
            _Draft(
              'newcomers:$y',
              'aging',
              'New faces · $reportYear',
              newcomers,
              reportYear,
              4,
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
        final intake = intakeRows(pyramid);
        if (intake.isNotEmpty) {
          drafts.add(
            _Draft(
              'intake:$y',
              'youth',
              'Academy intake · $reportYear',
              encodeSquadDevReport(
                intake,
                note: intakeNote(
                  academyBonus[PlayerLifecycle.cycleOfIntake(y)] ?? 0,
                ),
              ),
              reportYear,
              4,
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
          }
          if ((notable || wasCaptain) && !existing.contains('retire:${p.id}')) {
            final tally = [
              if (pc > 0) '$pc caps',
              if (pg > 0) '$pg goals',
            ].join(', ');
            final sendoff = tally.isEmpty ? '' : ', bowing out with $tally';
            drafts.add(
              _Draft(
                'retire:${p.id}',
                'retirement',
                wasCaptain
                    ? 'Your captain ${p.name} retires'
                    : '${p.name} retires from internationals',
                '${p.name} has retired from international football at '
                    '${p.age}$sendoff.'
                    '${wasCaptain ? ' The armband is vacant — name a new '
                              'captain from the call-up screen.' : ''}',
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
                '${p.name} inducted into the Hall of Fame',
                '${p.name} joins your nation’s Hall of Fame '
                    '($pc caps, $pg goals). See them in Legends.',
                reportYear,
                4,
              ),
            );
          }
        }
      }
    }

    drafts.sort((a, b) => a.sort.compareTo(b.sort));
    for (final d in drafts) {
      if (existing.contains(d.key)) continue;
      await comp.addMessage(
        careerId: careerId,
        dedupKey: d.key,
        category: d.category,
        title: d.title,
        body: d.body,
        year: d.year,
      );
    }
  }
}

/// The year's development report from [before] → [after] (keyed by player id):
/// who stepped up, who declined and who retired, each with their rating move.
///
/// Newcomers are deliberately absent — they get [_newcomerReport] to
/// themselves.
String _developmentReport(Map<int, Player> before, Map<int, Player> after) {
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
      ),
    );
  }
  return encodeSquadDevReport(rows);
}

/// The players who have come into the pool this year, with the scouting read on
/// each — so a wonderkid is a headline rather than one line among a hundred.
/// Null when nobody emerged.
String? _newcomerReport(Map<int, Player> before, Map<int, Player> after) {
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
          stars: Prospects.scoutedStars(e.value.id),
        ),
  ];
  if (rows.isEmpty) return null;
  return encodeSquadDevReport(rows);
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

/// Unread-message count, for the navigation badge.
final AutoDisposeFutureProviderFamily<int, int> unreadMessagesProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
      final inbox = await ref.watch(messageInboxProvider(careerId).future);
      return inbox.unread;
    });
