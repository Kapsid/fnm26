import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_career_repository.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';

void main() {
  late AppDatabase db;
  late DriftCareerRepository repo;
  late int careerId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = DriftCareerRepository(db);
    careerId = await db
        .into(db.careers)
        .insert(
          CareersCompanion.insert(
            nationId: 1,
            managerName: 'M',
            createdAt: DateTime.utc(2030),
            inGameDate: DateTime.utc(2030, 6, 1),
            rngSeed: 7,
          ),
        );
  });
  tearDown(() => db.close());

  test('a statement is stored open, judged, then thrown back', () async {
    final id = await repo.recordStatement(
      careerId: careerId,
      cycle: 0,
      nationId: 1,
      kind: StatementKind.backPlayer,
      playerId: 42,
      madeOn: DateTime.utc(2030, 6, 1),
      madeAfterFixtureId: 9,
    );
    var s = (await repo.statements(careerId)).single;
    expect(s.id, id);
    expect(s.status, StatementStatus.open);
    expect(s.thrownBack, isFalse);
    await repo.judgeStatement(
      id,
      status: StatementStatus.kept,
      judgedOn: DateTime.utc(2030, 9, 1),
    );
    await repo.markThrownBack(id);
    s = (await repo.statements(careerId)).single;
    expect(s.status, StatementStatus.kept);
    expect(s.judgedOn!.toUtc(), DateTime.utc(2030, 9, 1)); // drift reads local
    expect(s.thrownBack, isTrue);
  });

  test('a conference is stored pending and can be held', () async {
    final id = await repo.recordConference(
      careerId: careerId,
      cycle: 0,
      reason: ConferenceReason.crisis,
      fixtureId: 9,
      triggeredOn: DateTime.utc(2030, 6, 1),
    );
    expect(
      (await repo.conferences(careerId)).single.status,
      ConferenceStatus.pending,
    );
    await repo.setConferenceStatus(id, ConferenceStatus.held);
    final c = (await repo.conferences(careerId)).single;
    expect(c.status, ConferenceStatus.held);
    expect(c.reason, ConferenceReason.crisis);
  });
}
