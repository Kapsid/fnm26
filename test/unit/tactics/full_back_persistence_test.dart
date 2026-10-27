import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_tactics_repository.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';

import '../../helpers/test_database.dart';

/// The full-back arrows are stored with the rest of the tactic (as cycle-0
/// markers, so no schema change), carried by presets and the library, and a
/// save or preset from before they existed reads as neutral.
void main() {
  late AppDatabase db;
  late DriftTacticsRepository repo;

  setUp(() {
    db = createTestDatabase();
    repo = DriftTacticsRepository(db);
  });
  tearDown(() => db.close());

  const arrows = FullBackPushes(
    left: FullBackPush.up,
    right: FullBackPush.down,
  );
  final lineup = [for (var i = 0; i < 11; i++) 100 + i];

  test('round trip: the arrows come back as saved', () async {
    await repo.saveTactic(
      1,
      Tactic(formation: Formation.f442, lineup: lineup, fullBacks: arrows),
    );
    final back = await repo.tacticForCareer(1);
    expect(back!.fullBacks, arrows);
    expect(back.lineup, lineup);
  });

  test('a tactic saved before the arrows existed reads neutral', () async {
    // What an old save holds: a tactics row and its slots, and no marker.
    await repo.saveTactic(1, Tactic(formation: Formation.f433, lineup: lineup));
    expect(
      await db.select(db.drawsWatched).get(),
      isEmpty,
      reason: 'an untouched tactic writes nothing',
    );
    expect((await repo.tacticForCareer(1))!.fullBacks, FullBackPushes.neutral);
  });

  test('changing an arrow replaces the old mark, neutral clears it', () async {
    final t = Tactic(
      formation: Formation.f442,
      lineup: lineup,
      fullBacks: arrows,
    );
    await repo.saveTactic(1, t);
    await repo.saveTactic(
      1,
      t.copyWith(fullBacks: const FullBackPushes(left: FullBackPush.down)),
    );
    expect(
      (await repo.tacticForCareer(1))!.fullBacks,
      const FullBackPushes(left: FullBackPush.down),
    );
    await repo.saveTactic(1, t.copyWith(fullBacks: FullBackPushes.neutral));
    expect((await repo.tacticForCareer(1))!.fullBacks, FullBackPushes.neutral);
    expect(await db.select(db.drawsWatched).get(), isEmpty);
  });

  test("one career's arrows never leak into another", () async {
    await repo.saveTactic(
      1,
      Tactic(formation: Formation.f442, lineup: lineup, fullBacks: arrows),
    );
    await repo.saveTactic(2, Tactic(formation: Formation.f442, lineup: lineup));
    expect((await repo.tacticForCareer(2))!.fullBacks, FullBackPushes.neutral);
    expect((await repo.tacticForCareer(1))!.fullBacks, arrows);
  });

  group('presets and the library', () {
    test('a preset carries the arrows; an old preset reads neutral', () {
      const p = TacticPreset(
        name: 'Overlap',
        formation: Formation.f442,
        instructions: TacticalInstructions(),
        fullBacks: arrows,
      );
      final json = jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>;
      expect(TacticPreset.fromJson(json)!.fullBacks, arrows);
      final old = Map<String, dynamic>.of(json)..remove('fullBacks');
      expect(TacticPreset.fromJson(old)!.fullBacks, FullBackPushes.neutral);
    });

    test('a library entry carries the arrows; an old one reads neutral', () {
      final t = LibraryTactic.capture(
        name: 'Overlap',
        tactic: Tactic(
          formation: Formation.f442,
          lineup: lineup,
          fullBacks: arrows,
        ),
      );
      final back = LibraryTactic.fromData(name: 'Overlap', data: t.toData());
      expect(back.fullBacks, arrows);
      final old = (jsonDecode(t.toData()) as Map<String, dynamic>)
        ..remove('fullBacks');
      expect(
        LibraryTactic.fromData(name: 'Old', data: jsonEncode(old)).fullBacks,
        FullBackPushes.neutral,
      );
    });
  });
}
