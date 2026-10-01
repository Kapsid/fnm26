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
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/press_desk.dart';

import '../../helpers/test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late CareerRepository repo;
  late CompetitionRepository comp;
  late PressDesk desk;
  late Career career;
  late int careerId;

  setUp(() async {
    final db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
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
}
