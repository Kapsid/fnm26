import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/repositories/drift_tactics_repository.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

/// The throw-in style is stored with the tactic and the thrower beside it,
/// both as cycle-0 markers (no schema change), so they travel in a career
/// bundle; presets and the library carry them; anything from before throw-ins
/// existed reads neutral with an automatic thrower.
void main() {
  late AppDatabase db;
  late DriftTacticsRepository repo;

  setUp(() {
    db = createTestDatabase();
    repo = DriftTacticsRepository(db);
  });
  tearDown(() => db.close());

  final lineup = [for (var i = 0; i < 11; i++) 100 + i];

  test('round trip: the style comes back; neutral writes nothing', () async {
    final t = Tactic(
      formation: Formation.f442,
      lineup: lineup,
      throwInStyle: ThrowInStyle.long,
    );
    await repo.saveTactic(1, t);
    expect((await repo.tacticForCareer(1))!.throwInStyle, ThrowInStyle.long);
    await repo.saveTactic(
      1,
      t.copyWith(throwInStyle: ThrowInStyle.defensive),
    );
    expect(
      (await repo.tacticForCareer(1))!.throwInStyle,
      ThrowInStyle.defensive,
    );
    await repo.saveTactic(1, t.copyWith(throwInStyle: ThrowInStyle.neutral));
    expect(
      (await repo.tacticForCareer(1))!.throwInStyle,
      ThrowInStyle.neutral,
    );
    expect(await db.select(db.drawsWatched).get(), isEmpty);
  });

  test('the thrower is kept apart from the tactic, and survives a save of '
      'it', () async {
    expect(await repo.throwInTaker(1), isNull);
    await repo.setThrowInTaker(1, 105);
    await repo.saveTactic(1, Tactic(formation: Formation.f442, lineup: lineup));
    expect(await repo.throwInTaker(1), 105);
    await repo.setThrowInTaker(1, 106);
    expect(await repo.throwInTaker(1), 106);
    expect(await repo.throwInTaker(2), isNull, reason: 'per career');
    await repo.setThrowInTaker(1, null);
    expect(await repo.throwInTaker(1), isNull);
  });

  test('style and thrower travel in a career bundle', () async {
    final careerId = await db
        .into(db.careers)
        .insert(
          CareersCompanion.insert(
            nationId: 1,
            managerName: 'Thrower',
            createdAt: DateTime.utc(2030),
            inGameDate: DateTime.utc(2030, 6, 1),
            rngSeed: 7,
            cyclePointer: const Value(0),
          ),
        );
    await repo.saveTactic(
      careerId,
      Tactic(
        formation: Formation.f442,
        lineup: lineup,
        throwInStyle: ThrowInStyle.long,
      ),
    );
    await repo.setThrowInTaker(careerId, 103);
    final bundle = CareerBundle.decode(
      CareerBundle.encode(await CareerBundle.export(db, careerId)),
    ).bundle!;
    final imported = await CareerBundle.import(db, bundle);
    expect(imported, isNot(careerId));
    expect(
      (await repo.tacticForCareer(imported))!.throwInStyle,
      ThrowInStyle.long,
    );
    expect(await repo.throwInTaker(imported), 103);
  });

  group('presets and the library', () {
    test('a preset carries the style; an old one says nothing', () {
      const p = TacticPreset(
        name: 'Launch',
        formation: Formation.f442,
        instructions: TacticalInstructions(),
        throwInStyle: ThrowInStyle.long,
      );
      final json = jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>;
      expect(TacticPreset.fromJson(json)!.throwInStyle, ThrowInStyle.long);
      final old = Map<String, dynamic>.of(json)..remove('throwInStyle');
      expect(TacticPreset.fromJson(old)!.throwInStyle, isNull);
    });

    test('a library entry carries the style and the thrower by slot', () {
      final t = LibraryTactic.capture(
        name: 'Launch',
        tactic: Tactic(
          formation: Formation.f442,
          lineup: lineup,
          throwInStyle: ThrowInStyle.defensive,
        ),
        throwInTaker: 102,
      );
      final back = LibraryTactic.fromData(name: 'Launch', data: t.toData());
      expect(back.throwInStyle, ThrowInStyle.defensive);
      expect(back.throwInSlot, 2);

      // Re-attached to whoever fills slot 2 in another squad.
      final other = [for (var i = 0; i < 11; i++) 500 + i];
      final byId = <int, Player>{
        for (final id in other)
          id: player(id: id, nationId: 1, position: PlayerPosition.cm),
      };
      expect(back.fit(other, byId).throwInTaker, 502);

      final old = (jsonDecode(t.toData()) as Map<String, dynamic>)
        ..remove('throwInStyle')
        ..remove('throwInSlot');
      final oldEntry = LibraryTactic.fromData(
        name: 'Old',
        data: jsonEncode(old),
      );
      expect(oldEntry.throwInStyle, isNull);
      expect(oldEntry.throwInSlot, isNull);
      expect(oldEntry.fit(other, byId).throwInTaker, isNull);
    });
  });
}
