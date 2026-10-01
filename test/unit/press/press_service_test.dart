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
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/press_providers.dart';

import '../../helpers/test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late CareerRepository repo;
  late CompetitionRepository comp;
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
  });

  /// A played fixture of the career's, and a pending conference about it.
  Future<(Fixture, int)> playedWithConference() async {
    final all = await comp.fixturesForNation(careerId, career.nationId);
    final f =
        (all.where((f) => !f.hasResult).toList()
              ..sort((a, b) => a.date.compareTo(b.date)))
            .first;
    final home = f.homeNationId == career.nationId;
    await comp.recordResult(
      fixtureId: f.id,
      homeScore: home ? 3 : 0,
      awayScore: home ? 0 : 3,
    );
    final id = await repo.recordConference(
      careerId: careerId,
      cycle: career.cyclePointer,
      reason: ConferenceReason.bigWin,
      fixtureId: f.id,
      triggeredOn: f.date,
    );
    return (f, id);
  }

  Future<PendingConference> pending() async {
    final c = await container.read(pendingConferenceProvider(careerId).future);
    return c!;
  }

  test(
    'answering a promise records the answer and an open statement',
    () async {
      final (f, id) = await playedWithConference();
      final c = await pending();
      const beat = (
        kind: BeatKind.moment,
        answers: [AnswerKind.promiseWinNext],
        playerId: null,
      );
      final svc = container.read(conferenceServiceProvider);
      final effect = await svc.answer(
        careerId,
        c,
        0,
        beat,
        AnswerKind.promiseWinNext,
      );
      final rows = await repo.pressAnswers(careerId);
      expect(rows.single.questionKey, 'conf:$id:0');
      expect(rows.single.tone, 'promiseWinNext');
      expect(rows.single.moraleDelta, effect.morale);
      final s = (await repo.statements(careerId)).single;
      expect(s.kind, StatementKind.winNext);
      expect(s.status, StatementStatus.open);
      expect(s.madeOn, f.date);
      expect(s.madeAfterFixtureId, f.id);
    },
  );

  test('answering a throwback beat marks the statement thrown back', () async {
    final (f, _) = await playedWithConference();
    final sid = await repo.recordStatement(
      careerId: careerId,
      cycle: career.cyclePointer,
      nationId: career.nationId,
      kind: StatementKind.winNext,
      madeOn: f.date.subtract(const Duration(days: 30)),
      madeAfterFixtureId: f.id,
    );
    await repo.judgeStatement(
      sid,
      status: StatementStatus.broken,
      judgedOn: f.date,
    );
    container.invalidate(pressStatementsProvider(careerId));
    final c = await pending();
    expect(c.facts.throwback?.id, sid);
    await container.read(conferenceServiceProvider).answer(
      careerId,
      c,
      0,
      (
        kind: BeatKind.throwback,
        answers: [AnswerKind.admitMistake],
        playerId: null,
      ),
      AnswerKind.admitMistake,
    );
    expect(
      (await repo.statements(
        careerId,
      )).firstWhere((s) => s.id == sid).thrownBack,
      isTrue,
    );
  });

  test('finish marks the conference held', () async {
    final (_, id) = await playedWithConference();
    await container.read(conferenceServiceProvider).finish(careerId, id);
    expect(
      (await repo.conferences(careerId)).single.status,
      ConferenceStatus.held,
    );
    expect(
      await container.read(pendingConferenceProvider(careerId).future),
      isNull,
    );
  });

  test('a grv: row does not change the press effect', () async {
    final before = await container.read(pressEffectProvider(careerId).future);
    await repo.recordPressAnswer(
      careerId: careerId,
      cycle: career.cyclePointer,
      questionKey: 'grv:1',
      tone: 'x',
      moraleDelta: 5,
      boardDelta: 5,
      answeredAt: career.inGameDate,
    );
    container.invalidate(pressEffectProvider(careerId));
    expect(await container.read(pressEffectProvider(careerId).future), before);
  });
}
