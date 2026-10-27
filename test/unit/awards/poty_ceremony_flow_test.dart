import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/poty_card.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/tournament_stars_of.dart';

import '../../story/driver.dart';

/// The yearly Player of the Year event through a real save: the first
/// December of a career files the vote and offers the ceremony once; taking
/// it or simulating past it marks it seen; a year already voted (by this
/// build or an older one) is never voted again and has no ceremony.
void main() {
  late AppDatabase db;
  late ProviderContainer c;
  late StoryDriver d;

  /// Plays the career until the ceremony is the hub's event.
  Future<HubEvent> untilCeremony() async {
    for (var i = 0; i < 400; i++) {
      final e = await d.nextEvent();
      if (e.kind == HubEventKind.awardsCeremony) return e;
      await d.step();
    }
    throw StateError('no ceremony');
  }

  Future<List<({int id, String body, bool read, int year})>> awards() async => [
    for (final m
        in await c.read(competitionRepositoryProvider).messages(d.careerId))
      if (m.category == 'award')
        (id: m.id, body: m.body, read: m.read, year: m.year),
  ];

  setUp(() async {
    db = storyDb();
    c = storyContainer(db);
    addTearDown(c.dispose);
    d = await StoryDriver.start(c, 3);
  });

  test('the first December files the vote and offers the ceremony', () async {
    final e = await untilCeremony();
    final year = int.parse(Uri.parse(e.route!).queryParameters['year']!);
    // The first year anybody reaches the appearance floor: a career opens in
    // July, and some calendar years are quiet ones.
    expect(year, greaterThanOrEqualTo(2026));
    final filed = (await awards()).single;
    expect(filed.read, isFalse);
    final vote = decodePotyVote(filed.body)!;
    expect(vote.best, hasLength(5));
    expect(vote.best.map((p) => p.rank), [1, 2, 3, 4, 5]);
    // The young award can be short in a thin first half-year: its floor
    // stops at three games.
    expect(vote.young.length, lessThanOrEqualTo(3));
    expect(vote.young.every((p) => p.age <= 20), isTrue);
    // The honours are recorded as before.
    final cabinet = await c
        .read(competitionRepositoryProvider)
        .playerHonours(d.careerId, vote.best.first.playerId);
    expect(cabinet.map((a) => a.kind), contains(AwardKind.playerOfYear));
    // The list screen reads it back.
    final back = await c.read(
      potyVoteProvider((careerId: d.careerId, year: year)).future,
    );
    expect(back!.best.first.playerId, vote.best.first.playerId);
  });

  test('taking it marks it seen and reads the message, once', () async {
    final e = await untilCeremony();
    final year = int.parse(Uri.parse(e.route!).queryParameters['year']!);
    await c.read(awardServiceProvider).takeCeremony(d.careerId, year);
    expect((await d.nextEvent()).kind, isNot(HubEventKind.awardsCeremony));
    expect((await awards()).single.read, isTrue);
    // A new container (a reload) does not offer it again.
    final again = storyContainer(db);
    addTearDown(again.dispose);
    final career = (await again
        .read(careerRepositoryProvider)
        .byId(d.careerId))!;
    expect(
      await pendingCeremonyYear(
        again.read(competitionRepositoryProvider),
        career,
      ),
      isNull,
    );
  });

  test(
    'simulating past it marks it seen silently; the message stays',
    () async {
      await untilCeremony();
      await c.read(seasonServiceProvider).advance(d.careerId);
      final career = (await c.read(careerRepositoryProvider).byId(d.careerId))!;
      expect(
        await pendingCeremonyYear(
          c.read(competitionRepositoryProvider),
          career,
        ),
        isNull,
      );
      final kept = (await awards()).single;
      expect(kept.read, isFalse);
      expect(decodePotyVote(kept.body), isNotNull);
    },
  );

  test('a settled year is never voted again', () async {
    final e = await untilCeremony();
    final year = int.parse(Uri.parse(e.route!).queryParameters['year']!);
    await c.read(awardServiceProvider).takeCeremony(d.careerId, year);
    final before = await awards();
    await c.read(awardServiceProvider).settleYear(d.careerId);
    expect(await awards(), before);
    expect((await d.nextEvent()).kind, isNot(HubEventKind.awardsCeremony));
  });

  test(
    'a year voted by an older build keeps its card and has no ceremony',
    () async {
      // The first three years filed the old way, as a 1.0.6 save would have
      // them, before the vote ever runs.
      final comp = c.read(competitionRepositoryProvider);
      final repo = c.read(careerRepositoryProvider);
      for (final year in [2026, 2027, 2028]) {
        await comp.addTextMessage(
          l: c.read(appLocalizationsProvider),
          careerId: d.careerId,
          dedupKey: 'poty:$year',
          category: 'award',
          title: MsgText(MsgKey.newsPotyTitle, [year]),
          rawBody: encodePotyReport([
            (
              young: false,
              name: 'Old Winner',
              nationCode: 'eng',
              nationName: 'England',
              age: 27,
              overall: 85,
              apps: 9,
              goals: 6,
              assists: 2,
              meanRating: 7.4,
              motms: 2,
            ),
          ]),
          year: year,
        );
      }
      for (var i = 0; i < 600; i++) {
        final career = (await repo.byId(d.careerId))!;
        if (career.inGameDate.year >= 2029) break;
        final e = await d.nextEvent();
        expect(e.kind, isNot(HubEventKind.awardsCeremony));
        await d.step();
      }
      final filed = await awards();
      for (final year in [2026, 2027, 2028]) {
        final y = filed.where((m) => m.year == year).toList();
        expect(y, hasLength(1));
        expect(decodePotyReport(y.single.body), hasLength(1));
        expect(
          await comp.hasWatchedDraw(d.careerId, 0, potyDueKind(year)),
          isFalse,
        );
      }
    },
  );

  test('a career bundle carries the markers', () async {
    final e = await untilCeremony();
    final year = int.parse(Uri.parse(e.route!).queryParameters['year']!);
    final pendingCopy = await CareerBundle.import(
      db,
      await CareerBundle.export(db, d.careerId),
    );
    final comp = c.read(competitionRepositoryProvider);
    expect(
      await comp.hasWatchedDraw(pendingCopy, 0, potyDueKind(year)),
      isTrue,
    );
    expect(
      await comp.hasWatchedDraw(pendingCopy, 0, potySeenKind(year)),
      isFalse,
    );
    await c.read(awardServiceProvider).takeCeremony(d.careerId, year);
    final seenCopy = await CareerBundle.import(
      db,
      await CareerBundle.export(db, d.careerId),
    );
    expect(await comp.hasWatchedDraw(seenCopy, 0, potySeenKind(year)), isTrue);
    expect(
      decodePotyVote(
        (await comp.messages(
          seenCopy,
        )).firstWhere((m) => m.category == 'award').body,
      ),
      isNotNull,
    );
  });

  test('the vote reads the stored tournament honours, the ones the '
      'tournament screen shows', () async {
    // Play on, taking each ceremony, to the first December after a
    // continental championship.
    final comp = c.read(competitionRepositoryProvider);
    int? year;
    for (var i = 0; i < 1500 && year == null; i++) {
      final e = await d.nextEvent();
      if (e.kind == HubEventKind.awardsCeremony) {
        final y = int.parse(Uri.parse(e.route!).queryParameters['year']!);
        final stored = await comp.playerHonoursForYear(d.careerId, y);
        if (stored.any((h) => h.kind == AwardKind.goldenBall)) year = y;
      }
      await d.step();
    }
    expect(year, isNotNull, reason: 'no championship decided');
    final stored = await comp.playerHonoursForYear(d.careerId, year!);
    final balls = stored.where((h) => h.kind == AwardKind.goldenBall).toList();
    expect(
      balls.map((h) => h.competition),
      contains('European Championship'),
    );
    // Europe's Golden Ball is the man the championship's own screen names.
    final screen = await c.read(
      continentalDetailProvider((
        careerId: d.careerId,
        confederation: Confederation.europe,
      )).future,
    );
    expect(
      balls
          .firstWhere((h) => h.competition == 'European Championship')
          .playerId,
      screen!.teamOfTournament.first.id,
    );
    // And a whole Team of the Tournament is in the cabinet.
    expect(
      stored
          .where(
            (h) =>
                h.kind == AwardKind.teamOfTournament &&
                h.competition == 'European Championship',
          )
          .length,
      11,
    );
    // The screen rebuilds from the stored rows, not a fresh computation:
    // hand it a stored set naming another man and he is the Golden Ball.
    final career = (await c.read(careerRepositoryProvider).byId(d.careerId))!;
    final ref = c.read(_refProvider);
    final euroComp = (await comp.fixturesByRound(
      d.careerId,
      'CFINAL',
      kind: CompetitionKind.continentalFinals,
      confederation: Confederation.europe,
    )).single;
    Future<TournamentStarsOf> stars(List<PlayerAward> stored) =>
        tournamentStarsOf(
          ref,
          career,
          competitionId: euroComp.competitionId,
          knockout: const [],
          roundDepth: continentalRoundDepth,
          champion: null,
          stored: stored,
        );
    final team = (await stars(const [])).team;
    final other = team.last;
    final fake = <PlayerAward>[
      (
        playerId: other.id,
        nationId: other.nationId,
        kind: AwardKind.goldenBall,
        competition: 'European Championship',
        year: year,
      ),
      for (final s in team)
        (
          playerId: s.id,
          nationId: s.nationId,
          kind: AwardKind.teamOfTournament,
          competition: 'European Championship',
          year: year,
        ),
    ];
    final rebuilt = await stars(fake);
    expect(rebuilt.team.first.id, other.id);
    expect(
      rebuilt.team.map((s) => s.id).toSet(),
      team.map((s) => s.id).toSet(),
    );
  });

  test('a World Championship\'s honours are fixed the night of the final, '
      'and the vote on 1 December reads the same rows', () async {
    final comp = c.read(competitionRepositoryProvider);
    // To the final: the hub then offers the next cycle.
    for (var i = 0; i < 3000; i++) {
      final e = await d.nextEvent();
      if (e.kind == HubEventKind.cycleRollover) break;
      await d.step();
    }
    final wcYear = 2030;
    final stored = await storedTournamentHonours(
      comp,
      d.careerId,
      competition: 'World Championship',
      year: wcYear,
    );
    final ball = stored.firstWhere((h) => h.kind == AwardKind.goldenBall);
    final screen = await c.read(cupDetailProvider(d.careerId).future);
    expect(screen!.teamOfTournament.first.id, ball.playerId);
    expect(
      stored.where((h) => h.kind == AwardKind.teamOfTournament).length,
      11,
    );
    // Over the rollover to the year's vote: it stores nothing new for it.
    for (var i = 0; i < 3000; i++) {
      if ((await comp.messageKeys(d.careerId)).contains('poty:$wcYear')) {
        break;
      }
      await d.step();
    }
    final after = await storedTournamentHonours(
      comp,
      d.careerId,
      competition: 'World Championship',
      year: wcYear,
    );
    expect(after.length, stored.length);
    expect(
      after.firstWhere((h) => h.kind == AwardKind.goldenBall).playerId,
      ball.playerId,
    );
    expect(await comp.messageKeys(d.careerId), contains('poty:$wcYear'));
  }, timeout: const Timeout(Duration(minutes: 5)));
}

final Provider<Ref> _refProvider = Provider<Ref>((ref) => ref);
