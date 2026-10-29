import 'dart:async';

import 'package:drift/drift.dart' show Variable;
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../story/driver.dart';

/// When the yearly Player of the Year ceremony is offered.
///
/// The vote is on 31 December, once the year's football is all in (the
/// owner's rule: "2030 on 31/12/2030"). It used to be filed only by the step
/// AFTER the one that crossed the year's end, so a side whose next match was
/// months away met "Player of the Year 2029" in the middle of the 2030
/// finals; and a save that went past a year's end without a vote never got
/// it ("I am in Euro 2032 but 2031 did not happen").
void main() {
  group('voteStopBefore', () {
    test('a step over 31 December stops on it', () {
      expect(
        voteStopBefore(DateTime(2029, 10, 9), DateTime(2030, 6, 11)),
        DateTime(2029, 12, 31),
      );
      expect(
        voteStopBefore(DateTime(2029, 12, 30), DateTime(2030, 1, 2)),
        DateTime(2029, 12, 31),
      );
    });

    test('a step that stays on one side of it does not', () {
      // December football is played before the vote.
      expect(
        voteStopBefore(DateTime(2029, 11, 19), DateTime(2029, 12, 15)),
        isNull,
      );
      // Already on the day: the vote is filed at this step's end.
      expect(
        voteStopBefore(DateTime(2029, 12, 31), DateTime(2030, 3, 20)),
        isNull,
      );
      expect(
        voteStopBefore(DateTime(2030, 3, 9), DateTime(2030, 6, 11)),
        isNull,
      );
      // A match ON 31 December is played; the vote follows it.
      expect(
        voteStopBefore(DateTime(2029, 11, 19), DateTime(2029, 12, 31)),
        isNull,
      );
    });

    test('the year a date votes for turns on 31 December', () {
      expect(potyYearOn(DateTime(2031, 12, 30)), 2030);
      expect(potyYearOn(DateTime(2031, 12, 31)), 2031);
      expect(potyYearOn(DateTime(2032, 6, 14)), 2031);
    });
  });

  // One career through a whole cycle, two finals and into the next: every
  // year's ceremony is offered once, on 31 December, before anything else
  // moves the clock, and none is passed by unseen.
  for (final (name, nation) in [('England', england), ('Senegal', 142)]) {
    test(
      '$name: one ceremony a year, on 31 December, never during the finals',
      () async {
        final db = storyDb();
        final c = storyContainer(db);
        addTearDown(c.dispose);
        final d = await StoryDriver.start(c, 3, nationId: nation);
        final comp = c.read(competitionRepositoryProvider);
        final repo = c.read(careerRepositoryProvider);
        final offered = <int, List<DateTime>>{};
        var rolledOver = false;
        for (var i = 0; i < 6000; i++) {
          final career = (await repo.byId(d.careerId))!;
          if (career.inGameDate.isAfter(DateTime(2031, 4))) break;
          final e = await d.nextEvent();
          if (e.kind == HubEventKind.cycleRollover) rolledOver = true;
          if (e.kind == HubEventKind.awardsCeremony) {
            final year = int.parse(
              Uri.parse(e.route!).queryParameters['year']!,
            );
            (offered[year] ??= []).add(career.inGameDate);
            expect(
              career.inGameDate.month,
              isNot(anyOf(6, 7)),
              reason: '$year offered during the finals',
            );
          }
          await d.step();
        }
        expect(rolledOver, isTrue, reason: 'never reached the 2030 final');
        for (final year in [2026, 2027, 2028, 2029, 2030]) {
          // Offered at exactly one hub moment (the driver takes it there),
          // on the day of the vote.
          expect(offered[year], [DateTime(year, 12, 31)], reason: '$year');
          expect(
            await comp.hasWatchedDraw(d.careerId, 0, potySeenKind(year)),
            isTrue,
          );
        }
        // No football on or after the vote day was left out of its year:
        // nothing is ever played on 31 December itself.
        final late = await db
            .customSelect(
              "SELECT COUNT(*) AS n FROM fixtures WHERE career_id = ? AND "
              "strftime('%m-%d', date, 'unixepoch') = '12-31'",
              variables: [Variable<int>(d.careerId)],
            )
            .map((r) => r.read<int>('n'))
            .getSingle();
        expect(late, 0);
      },
      timeout: const Timeout(Duration(minutes: 10)),
    );
  }

  // A save past a year's 31 December with no vote for it (filed by an older
  // build, or never settled): it is voted and offered at the very next hub
  // moment, in the middle of the Euro if need be, and never skipped. Several
  // missed years are all filed, with one ceremony: the most recent year's.
  test(
    'a missed year is caught up at the next hub moment, mid-finals',
    () async {
      final db = storyDb();
      final c = storyContainer(db);
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 3);
      final comp = c.read(competitionRepositoryProvider);
      final repo = c.read(careerRepositoryProvider);

      // To the European Championship 2032, between two of its matchdays.
      Future<bool> euroLive() => comp.hasLiveContinentalFinals(
        d.careerId,
        confederation: Confederation.europe,
      );
      for (var i = 0; i < 9000; i++) {
        final career = (await repo.byId(d.careerId))!;
        if (career.inGameDate.year == 2032 &&
            career.inGameDate.month >= 6 &&
            await euroLive()) {
          final e = await d.nextEvent();
          if (e.kind != HubEventKind.awardsCeremony) break;
        }
        await d.step();
      }
      expect(await euroLive(), isTrue, reason: 'never reached Euro 2032');

      Future<void> forget(List<int> years) async {
        for (final y in years) {
          await db.customStatement(
            'DELETE FROM messages WHERE career_id = ? AND dedup_key = ?',
            [d.careerId, 'poty:$y'],
          );
          await db.customStatement(
            'DELETE FROM draws_watched WHERE career_id = ? '
            'AND kind IN (?, ?, ?)',
            [d.careerId, potyDueKind(y), potySeenKind(y), potyVoidKind(y)],
          );
        }
      }

      Future<int?> ceremony() async {
        final e = await d.nextEvent();
        if (e.kind != HubEventKind.awardsCeremony) return null;
        return int.parse(Uri.parse(e.route!).queryParameters['year']!);
      }

      // One year missed, as the owner's save had it.
      await forget([2031]);
      expect(await ceremony(), 2031);
      expect(await comp.messageKeys(d.careerId), contains('poty:2031'));
      expect(await euroLive(), isTrue, reason: 'offered before the finals end');
      await c.read(awardServiceProvider).takeCeremony(d.careerId, 2031);
      expect(await ceremony(), isNull);

      // Three in a row: all three voted and filed, but ONE ceremony, the
      // most recent year's; the older two are marked seen silently and
      // their inbox messages still carry the top five.
      await forget([2029, 2030, 2031]);
      final seen = <int>[];
      for (var i = 0; i < 5; i++) {
        final year = await ceremony();
        if (year == null) break;
        seen.add(year);
        await c.read(awardServiceProvider).takeCeremony(d.careerId, year);
      }
      expect(seen, [2031]);
      final keys = await comp.messageKeys(d.careerId);
      for (final y in [2029, 2030, 2031]) {
        expect(keys, contains('poty:$y'));
        expect(
          await comp.hasWatchedDraw(d.careerId, 0, potySeenKind(y)),
          isTrue,
        );
        final vote = await c.read(
          potyVoteProvider((careerId: d.careerId, year: y)).future,
        );
        expect(vote, isNotNull, reason: '$y has no top five');
      }
      expect(await euroLive(), isTrue);

      // Holes OLDER than a year already held (2031 voted and seen): filed
      // silently, no ceremony out of order, and no lift for today's squad.
      final cycle = (await repo.byId(d.careerId))!.cyclePointer;
      final answersBefore = await repo.pressAnswers(d.careerId, cycle: cycle);
      await forget([2029, 2030]);
      expect(await ceremony(), isNull);
      for (final y in [2029, 2030]) {
        expect(await comp.messageKeys(d.careerId), contains('poty:$y'));
        expect(
          await comp.hasWatchedDraw(d.careerId, 0, potySeenKind(y)),
          isTrue,
        );
      }
      expect(
        (await repo.pressAnswers(d.careerId, cycle: cycle)).length,
        answersBefore.length,
      );

      // A year nobody can be voted for (its football gone): tried once,
      // marked void, and never re-run at every hub moment.
      await forget([2031]);
      await db.customStatement(
        'DELETE FROM player_ratings WHERE career_id = ? AND fixture_id IN '
        '(SELECT id FROM fixtures WHERE career_id = ? AND '
        "strftime('%Y', date, 'unixepoch') = '2031')",
        [d.careerId, d.careerId],
      );
      expect(await ceremony(), isNull);
      expect(
        await comp.hasWatchedDraw(d.careerId, 0, potyVoidKind(2031)),
        isTrue,
      );
      expect(await c.read(awardServiceProvider).behind(d.careerId), isFalse);
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );

  // A vote that throws never stops the game: the hub still offers its next
  // event and a step still moves the clock.
  test('a failing vote neither breaks the hub nor blocks a step', () async {
    final c = storyContainer(null, 0, [
      awardServiceProvider.overrideWith(_BrokenAwards.new),
    ]);
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, 3);
    final e = await d.nextEvent();
    expect(e.kind, isNot(HubEventKind.awardsCeremony));
    final repo = c.read(careerRepositoryProvider);
    final before = (await repo.byId(d.careerId))!.inGameDate;
    await c.read(seasonServiceProvider).advance(d.careerId);
    expect((await repo.byId(d.careerId))!.inGameDate.isAfter(before), isTrue);
  });

  // The hub's catch-up never swallows a tap: an advance made while it holds
  // the lock waits for it, then runs.
  test('an advance during the catch-up queues behind it', () async {
    final gate = Completer<void>();
    final c = storyContainer(null, 0, [
      awardServiceProvider.overrideWith((ref) => _SlowAwards(ref, gate)),
    ]);
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, 3);
    final repo = c.read(careerRepositoryProvider);
    final season = c.read(seasonServiceProvider);
    final before = (await repo.byId(d.careerId))!.inGameDate;
    final catchUp = season.catchUpAwards(d.careerId);
    final advance = season.advance(d.careerId);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect((await repo.byId(d.careerId))!.inGameDate, before);
    gate.complete();
    await catchUp;
    await advance;
    expect((await repo.byId(d.careerId))!.inGameDate.isAfter(before), isTrue);
  });
}

class _BrokenAwards extends AwardService {
  _BrokenAwards(super.ref);

  @override
  Future<bool> behind(int careerId) async => true;

  @override
  Future<void> settleYear(int careerId) async => throw StateError('vote');
}

class _SlowAwards extends AwardService {
  _SlowAwards(super.ref, this.gate);

  final Completer<void> gate;

  @override
  Future<void> settleYear(int careerId) => gate.future;
}
