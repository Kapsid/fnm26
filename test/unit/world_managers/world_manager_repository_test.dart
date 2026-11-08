import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_world_manager_repository.dart';
import 'package:fnm/domain/entities/world_manager.dart';

import '../../helpers/test_database.dart';

WorldManager _m(int id, {DateTime? retired}) => WorldManager(
  managerId: id,
  name: 'Manager $id',
  nationality: 'TST',
  birthYear: 1970,
  style: 'balanced',
  origin: ManagerOrigin.fresh,
  enteredAt: DateTime.utc(2030),
  retiredAt: retired,
);

ManagerSpell _s(int no, int mgr, int nation, DateTime from, [DateTime? to]) =>
    ManagerSpell(
      spellNo: no,
      managerId: mgr,
      nationId: nation,
      fromDate: from,
      toDate: to,
      endReason: to == null ? null : SpellEnd.sacked,
      contractUntil: DateTime.utc(2034),
    );

void main() {
  late AppDatabase db;
  late DriftWorldManagerRepository repo;
  late int career;

  setUp(() async {
    db = createTestDatabase();
    repo = DriftWorldManagerRepository(db);
    career = await db
        .into(db.careers)
        .insert(
          CareersCompanion.insert(
            nationId: 1,
            managerName: 'Manager',
            createdAt: DateTime.utc(2030),
            inGameDate: DateTime.utc(2030, 6, 1),
            rngSeed: 7,
          ),
        );
  });

  tearDown(() => db.close());

  test('apply then load round-trips managers, spells and ties', () async {
    expect(await repo.hasManagers(career), isFalse);
    await repo.apply(
      career,
      ManagerChanges(
        added: [_m(1), _m(2)],
        opened: [_s(1, 1, 10, DateTime.utc(2030))],
        ties: [
          ManagerTie(
            tieNo: 1,
            managerId: 1,
            kind: TieKind.grudge,
            delta: -2,
            date: DateTime.utc(2030, 2),
          ),
        ],
      ),
    );
    final w = await repo.load(career);
    expect(await repo.hasManagers(career), isTrue);
    expect(w.managers.map((m) => m.managerId), [1, 2]);
    expect(w.managers.first.origin, ManagerOrigin.fresh);
    expect(w.spells.single.nationId, 10);
    expect(w.spells.single.current, isTrue);
    expect(w.nextManagerId, 3);
    expect(w.nextSpellNo, 2);
    final t = (await repo.ties(career)).single;
    expect((t.kind, t.delta), (TieKind.grudge, -2));

    await repo.addTie(
      career,
      managerId: 2,
      kind: TieKind.protege,
      delta: 1,
      date: DateTime.utc(2030, 3),
    );
    expect((await repo.ties(career)).map((t) => t.tieNo), [1, 2]);

    await repo.apply(
      career,
      ManagerChanges(updated: [_m(2).copyWith(retiredAt: DateTime.utc(2031))]),
    );
    expect(
      (await repo.load(career)).managers.last.retiredAt!.toUtc(),
      DateTime.utc(2031),
    );
    expect(
      (await repo.load(
        career,
      )).free(DateTime.utc(2031)).map((m) => m.managerId),
      isEmpty,
    );
  });

  test(
    'inChargeOn picks the spell covering the date and null before any',
    () async {
      await repo.apply(
        career,
        ManagerChanges(
          added: [_m(1), _m(2)],
          opened: [
            _s(1, 1, 10, DateTime.utc(2030), DateTime.utc(2032)),
            _s(2, 2, 10, DateTime.utc(2032)),
          ],
        ),
      );
      expect(await repo.inChargeOn(career, 10, DateTime.utc(2029)), isNull);
      expect(
        (await repo.inChargeOn(career, 10, DateTime.utc(2031)))!.managerId,
        1,
      );
      expect(
        (await repo.inChargeOn(career, 10, DateTime.utc(2033)))!.managerId,
        2,
      );
      expect(await repo.inChargeOn(career, 11, DateTime.utc(2031)), isNull);
      final w = await repo.load(career);
      expect(w.inChargeOn(10, DateTime.utc(2031))!.managerId, 1);
      expect(w.currentAt(10)!.managerId, 2);
    },
  );

  test('inChargeOn breaks a same-moment start by the higher spellNo', () {
    // The same instant written once in UTC and once in local time: `==`
    // tells them apart, the tie-break must not.
    final w = ManagerWorld(
      managers: [_m(1), _m(2)],
      spells: [
        _s(4, 1, 10, DateTime.utc(2030)),
        _s(7, 2, 10, DateTime.utc(2030).toLocal()),
      ],
    );
    expect(w.inChargeOn(10, DateTime.utc(2031))!.spellNo, 7);
  });

  test(
    'closing a spell and opening the successor on one date gives the successor from that date',
    () async {
      final day = DateTime.utc(2032, 5);
      final first = _s(1, 1, 10, DateTime.utc(2030));
      await repo.apply(
        career,
        ManagerChanges(added: [_m(1), _m(2)], opened: [first]),
      );
      await repo.apply(
        career,
        ManagerChanges(
          closed: [first.close(day, SpellEnd.sacked)],
          opened: [_s(2, 2, 10, day)],
        ),
      );
      expect((await repo.inChargeOn(career, 10, day))!.managerId, 2);
      expect(
        (await repo.inChargeOn(
          career,
          10,
          day.subtract(const Duration(days: 1)),
        ))!.managerId,
        1,
      );
      expect(
        (await repo.spellsOf(career, 1)).single.endReason,
        SpellEnd.sacked,
      );
      expect((await repo.load(career)).inChargeOn(10, day)!.managerId, 2);
    },
  );

  test(
    'apply is one transaction: a duplicate spellNo leaves nothing written',
    () async {
      await repo.apply(
        career,
        ManagerChanges(
          added: [_m(1)],
          opened: [_s(1, 1, 10, DateTime.utc(2030))],
        ),
      );
      await expectLater(
        repo.apply(
          career,
          ManagerChanges(
            added: [_m(2)],
            opened: [_s(1, 2, 11, DateTime.utc(2031))],
          ),
        ),
        throwsA(anything),
      );
      final w = await repo.load(career);
      expect(w.managers.map((m) => m.managerId), [1]);
      expect(w.spells.length, 1);
    },
  );

  test('movesSince lists spells opened or closed since the date', () async {
    await repo.apply(
      career,
      ManagerChanges(
        added: [_m(1), _m(2), _m(3)],
        opened: [
          _s(1, 1, 10, DateTime.utc(2029), DateTime.utc(2031)),
          _s(2, 2, 11, DateTime.utc(2029)),
          _s(3, 3, 12, DateTime.utc(2032)),
        ],
      ),
    );
    final since = await repo.movesSince(career, DateTime.utc(2031));
    expect(since.map((s) => s.spellNo), [1, 3]);
  });
}
