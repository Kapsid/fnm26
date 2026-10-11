import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/press/press_desk.dart';
import 'package:fnm/features/press/press_providers.dart';

import '../../helpers/test_database.dart';

/// Records which providers changed state, so a test can see what was rebuilt.
class _Updates extends ProviderObserver {
  final List<ProviderBase<Object?>> seen = [];

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) => seen.add(provider);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late CareerRepository repo;
  late CompetitionRepository comp;
  late PressDesk desk;
  late Career career;
  late int careerId;
  late List<Nation> nations;
  late _Updates updates;

  setUp(() async {
    final db = createTestDatabase();
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    updates = _Updates();
    container = ProviderContainer(
      observers: [updates],
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => false),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
    await container.read(seedLoaderProvider).ensureSeeded();
    career =
        (await container
                .read(careerServiceProvider)
                .create(
                  nationId: nations.first.id,
                  managerName: 'M',
                  rngSeed: 7,
                ))
            .valueOrNull!;
    careerId = career.id;
    repo = container.read(careerRepositoryProvider);
    comp = container.read(competitionRepositoryProvider);
    desk = container.read(pressDeskProvider);
  });

  /// Plays the career's first [n] competitive fixtures as losses, moves the
  /// clock past them, and returns them (by date).
  Future<List<Fixture>> playLosses(int n) async {
    final all = await comp.fixturesForNation(careerId, career.nationId);
    final own = [
      for (final f in all)
        if (!f.hasResult && f.round != Rounds.friendly) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    final picked = own.take(n).toList();
    expect(picked, hasLength(n));
    for (final f in picked) {
      final home = f.homeNationId == career.nationId;
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: home ? 0 : 2,
        awayScore: home ? 2 : 0,
      );
    }
    await repo.updateInGameDate(
      careerId,
      picked.last.date.add(const Duration(days: 1)),
    );
    return picked;
  }

  test('nothing is called before his first competitive match', () async {
    await desk.afterMatches(careerId);
    expect(await repo.conferences(careerId), isEmpty);
  });

  test('a pending conference from an earlier cycle is skipped', () async {
    final id = await repo.recordConference(
      careerId: careerId,
      cycle: -1,
      reason: ConferenceReason.crisis,
      fixtureId: 1,
      triggeredOn: DateTime.utc(2020),
    );
    await desk.afterMatches(careerId);
    expect(
      (await repo.conferences(careerId)).firstWhere((c) => c.id == id).status,
      ConferenceStatus.skipped,
    );
  });

  test('a broken job promise is judged once and calls a job-verdict '
      'conference', () async {
    final all = await comp.fixturesForNation(careerId, career.nationId);
    final first = ([
      for (final f in all)
        if (f.round != Rounds.friendly) f,
    ]..sort((a, b) => a.date.compareTo(b.date))).first;
    await repo.recordStatement(
      careerId: careerId,
      cycle: career.cyclePointer,
      nationId: career.nationId,
      kind: StatementKind.jobOnTheLine,
      madeOn: first.date.subtract(const Duration(days: 1)),
      madeAfterFixtureId: first.id,
    );
    await playLosses(3);
    await desk.afterMatches(careerId);
    await desk.afterMatches(careerId); // idempotent
    final s = (await repo.statements(careerId)).single;
    expect(s.status, StatementStatus.broken);
    final stmtRows = (await repo.pressAnswers(careerId)).where(
      (a) => a.questionKey == 'stmt:${s.id}',
    );
    expect(stmtRows, hasLength(1));
    expect(
      (await repo.conferences(careerId)).last.reason,
      ConferenceReason.jobVerdict,
    );
  });

  test('running twice for the same match calls one conference', () async {
    await playLosses(3);
    await desk.afterMatches(careerId);
    await desk.afterMatches(careerId);
    expect(await repo.conferences(careerId), hasLength(1));
  });

  test("a new cycle never calls a conference about the last cycle's "
      'match', () async {
    final played = await playLosses(3);
    // The cycle's ceiling is reached, so the last loss calls nothing now.
    for (var i = 0; i < ConferenceTrigger.maxPerCycle; i++) {
      await repo.recordConference(
        careerId: careerId,
        cycle: career.cyclePointer,
        reason: ConferenceReason.crisis,
        fixtureId: -1 - i,
        triggeredOn: DateTime.utc(2000),
      );
    }
    await desk.afterMatches(careerId);
    expect(await repo.conferences(careerId), hasLength(6));
    // The rollover resets the ceiling; the old loss is still not news.
    await repo.advanceCycle(
      careerId,
      career.cyclePointer + 1,
      played.last.date.add(const Duration(days: 2)),
    );
    await desk.afterMatches(careerId);
    final calls = await repo.conferences(careerId);
    expect(calls, hasLength(6));
    expect(calls.any((c) => c.fixtureId == played.last.id), isFalse);
  });

  test("a new job never calls a conference about the new nation's "
      'matches before he took over', () async {
    final everything = await comp.allFixtures(careerId);
    final other = everything
        .firstWhere(
          (f) =>
              f.round != Rounds.friendly &&
              f.homeNationId != career.nationId &&
              f.awayNationId != career.nationId,
        )
        .homeNationId;
    final theirs = [
      for (final f in await comp.fixturesForNation(careerId, other))
        if (f.round != Rounds.friendly) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    final picked = theirs.take(3).toList();
    expect(picked, hasLength(3));
    for (final f in picked) {
      final home = f.homeNationId == other;
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: home ? 0 : 2,
        awayScore: home ? 2 : 0,
      );
    }
    await repo.switchNation(careerId, other);
    await repo.advanceCycle(
      careerId,
      career.cyclePointer + 1,
      picked.last.date.add(const Duration(days: 1)),
    );
    await desk.afterMatches(careerId);
    expect(await repo.conferences(careerId), isEmpty);
  });

  test('a match older than the stale window is never called late', () async {
    final played = await playLosses(3);
    await repo.updateInGameDate(
      careerId,
      played.last.date.add(const Duration(days: PressDesk.staleDays + 1)),
    );
    await desk.afterMatches(careerId);
    expect(await repo.conferences(careerId), isEmpty);
  });

  test('reads the board fresh even while the hub keeps it alive', () async {
    // The hub holds the board's providers open across the advance.
    container
      ..listen(cycleObjectiveOutcomesProvider(careerId), (_, _) {})
      ..listen(cycleObjectivesProvider(careerId), (_, _) {})
      ..listen(satisfactionProvider(careerId), (_, _) {});
    await container.read(cycleObjectiveOutcomesProvider(careerId).future);
    await container.read(satisfactionProvider(careerId).future);
    await playLosses(3);
    updates.seen.clear();
    await desk.afterMatches(careerId);
    expect(updates.seen, contains(cycleObjectiveOutcomesProvider(careerId)));
    expect(updates.seen, contains(cycleObjectivesProvider(careerId)));
  });

  group('the pending conference', () {
    Future<PendingConference?> pending() {
      container.invalidate(pendingConferenceProvider(careerId));
      return container.read(pendingConferenceProvider(careerId).future);
    }

    test('is offered while its cycle and its news last', () async {
      await playLosses(3);
      await desk.afterMatches(careerId);
      expect(await pending(), isNotNull);
    });

    test('from an earlier cycle is not offered', () async {
      final played = await playLosses(3);
      await desk.afterMatches(careerId);
      await repo.advanceCycle(
        careerId,
        career.cyclePointer + 1,
        played.last.date.add(const Duration(days: 2)),
      );
      expect(await pending(), isNull);
    });

    test('older than the stale window is not offered', () async {
      final played = await playLosses(3);
      await desk.afterMatches(careerId);
      await repo.updateInGameDate(
        careerId,
        played.last.date.add(const Duration(days: PressDesk.staleDays + 1)),
      );
      expect(await pending(), isNull);
    });

    test('throws back his newest statement for this nation since the last '
        'conference', () async {
      final played = await playLosses(3);
      final d = played.last.date;
      final previous = await repo.recordConference(
        careerId: careerId,
        cycle: career.cyclePointer,
        reason: ConferenceReason.bigWin,
        fixtureId: -1,
        triggeredOn: d.subtract(const Duration(days: 50)),
      );
      await repo.setConferenceStatus(previous, ConferenceStatus.held);
      await desk.afterMatches(careerId);
      Future<int> said(int nationId, StatementStatus status, int ago) async {
        final id = await repo.recordStatement(
          careerId: careerId,
          cycle: career.cyclePointer,
          nationId: nationId,
          kind: StatementKind.winNext,
          madeOn: d.subtract(Duration(days: ago + 5)),
          madeAfterFixtureId: played.first.id,
        );
        await repo.judgeStatement(
          id,
          status: status,
          judgedOn: d.subtract(Duration(days: ago)),
        );
        return id;
      }

      final otherNation = nations.firstWhere((n) => n.id != career.nationId).id;
      await said(otherNation, StatementStatus.kept, 20); // another job
      await said(career.nationId, StatementStatus.kept, 55); // before last
      await said(career.nationId, StatementStatus.kept, 30);
      final newest = await said(career.nationId, StatementStatus.broken, 10);
      final c = await pending();
      expect(c, isNotNull);
      expect(c!.facts.throwback?.id, newest);
    });

    test(
      'throws nothing back when nothing of his nation is in the window',
      () async {
        final played = await playLosses(3);
        await desk.afterMatches(careerId);
        final otherNation = nations
            .firstWhere((n) => n.id != career.nationId)
            .id;
        final id = await repo.recordStatement(
          careerId: careerId,
          cycle: career.cyclePointer,
          nationId: otherNation,
          kind: StatementKind.winNext,
          madeOn: played.first.date,
          madeAfterFixtureId: played.first.id,
        );
        await repo.judgeStatement(
          id,
          status: StatementStatus.kept,
          judgedOn: played.last.date,
        );
        final c = await pending();
        expect(c, isNotNull);
        expect(c!.facts.throwback, isNull);
      },
    );
  });
}
