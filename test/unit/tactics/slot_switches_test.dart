import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/repositories/drift_tactics_repository.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

/// A couple of places changed WITHIN a formation (a 4-3-3's central midfielder
/// dropped into a holding role, a wide midfielder pushed on as a winger)
/// without picking a new formation.
void main() {
  const f433 = Formation.f433;
  // 4-3-3 slots: 0 gk, 1 lb, 2 cb, 3 cb, 4 rb, 5 dm, 6 cm, 7 cm, 8 lw, 9 st,
  // 10 rw.
  final lineup = [for (var i = 0; i < 11; i++) 100 + i];

  group('the switches themselves', () {
    test('a CM in a 4-3-3 can become a DM, and the slot reads as one', () {
      final s = SlotSwitches.none.withSlot(f433, 6, PlayerPosition.dm);
      expect(s.bySlot, {6: PlayerPosition.dm});
      final t = Tactic(formation: f433, lineup: lineup, switches: s);
      expect(t.positions[6], PlayerPosition.dm);
      // Nothing else moves, and the formation is still the 4-3-3.
      expect(t.formation, f433);
      for (var i = 0; i < 11; i++) {
        if (i != 6) expect(t.positions[i], f433.positions[i]);
      }
    });

    test('only natural alternatives, only positions the game has', () {
      expect(SlotSwitches.alternativesFor(PlayerPosition.cm), [
        PlayerPosition.dm,
        PlayerPosition.am,
      ]);
      expect(SlotSwitches.alternativesFor(PlayerPosition.lm), [
        PlayerPosition.lw,
      ]);
      expect(SlotSwitches.alternativesFor(PlayerPosition.rw), [
        PlayerPosition.rm,
      ]);
      expect(SlotSwitches.alternativesFor(PlayerPosition.st), [
        PlayerPosition.am,
      ]);
      for (final p in [
        PlayerPosition.gk,
        PlayerPosition.lb,
        PlayerPosition.cb,
        PlayerPosition.rb,
      ]) {
        expect(SlotSwitches.alternativesFor(p), isEmpty);
      }
      // A centre-back cannot be turned into a striker, and the keeper stays.
      expect(
        SlotSwitches.none.withSlot(f433, 2, PlayerPosition.st),
        SlotSwitches.none,
      );
      expect(SlotSwitches.none.canSwitch(f433, 0), isFalse);
    });

    test('at most two slots; the third is refused until one is reset', () {
      var s = SlotSwitches.none
          .withSlot(f433, 6, PlayerPosition.dm)
          .withSlot(f433, 7, PlayerPosition.am);
      expect(s.count, SlotSwitches.maxChanged);
      expect(s.canSwitch(f433, 9), isFalse);
      // The two already changed may still be changed again.
      expect(s.canSwitch(f433, 6), isTrue);
      final refused = s.withSlot(f433, 9, PlayerPosition.am);
      expect(refused, s);
      s = s.withSlot(f433, 6, PlayerPosition.am);
      expect(s.bySlot[6], PlayerPosition.am);
      // Resetting one (its own position, or null) frees the room.
      s = s.withSlot(f433, 7, PlayerPosition.cm);
      expect(s.bySlot.containsKey(7), isFalse);
      s = s.withSlot(f433, 9, PlayerPosition.am);
      expect(s.bySlot, {6: PlayerPosition.am, 9: PlayerPosition.am});
      expect(s.withSlot(f433, 9, null).bySlot, {6: PlayerPosition.am});
    });

    test('a switch that does not fit the formation is ignored', () {
      // Slot 5 is the 4-3-3's DM but the 4-4-2's LM, where a switch to CM
      // is not on offer.
      const s = SlotSwitches({5: PlayerPosition.cm});
      expect(s.apply(f433)[5], PlayerPosition.cm);
      expect(s.apply(Formation.f442), Formation.f442.positions);
      expect(s.validFor(Formation.f442), SlotSwitches.none);
      // And a damaged entry over the limit is cut to the limit.
      const many = SlotSwitches({
        6: PlayerPosition.dm,
        7: PlayerPosition.dm,
        9: PlayerPosition.am,
      });
      expect(many.validFor(f433).count, SlotSwitches.maxChanged);
    });

    test('auto-pick fits the switched place', () {
      // A spare natural DM, as good as everyone else. Without a switch the
      // shape has one DM place and he sits out; with slot 6 switched to DM
      // there are two, and he fits the second free.
      final pool = [
        for (var i = 0; i < 11; i++)
          player(id: 200 + i, nationId: 1, position: f433.positions[i]),
        player(id: 300, nationId: 1, position: PlayerPosition.dm),
      ];
      expect(bestEleven(f433, pool).contains(300), isFalse);
      final s = SlotSwitches.none.withSlot(f433, 6, PlayerPosition.dm);
      final picked = bestEleven(f433, pool, slots: s.apply(f433));
      expect(picked.toSet().contains(300), isTrue);
    });

    test('json round trip; an untouched shape writes nothing', () {
      const s = SlotSwitches({6: PlayerPosition.dm, 9: PlayerPosition.am});
      final back = SlotSwitches.fromJson(jsonDecode(jsonEncode(s.toJson())));
      expect(back, s);
      expect(SlotSwitches.none.toJson(), isEmpty);
      expect(SlotSwitches.fromJson(null), SlotSwitches.none);
      expect(SlotSwitches.fromJson({'x': 'dm', '6': 'nonsense'}), isEmpty);
    });
  });

  group('stored with the tactic', () {
    late AppDatabase db;
    late DriftTacticsRepository repo;

    setUp(() {
      db = createTestDatabase();
      repo = DriftTacticsRepository(db);
    });
    tearDown(() => db.close());

    test('round trip: the switches come back as saved', () async {
      const s = SlotSwitches({6: PlayerPosition.dm, 8: PlayerPosition.lm});
      await repo.saveTactic(
        1,
        Tactic(formation: f433, lineup: lineup, switches: s),
      );
      final back = (await repo.tacticForCareer(1))!;
      expect(back.switches, s);
      expect(back.positions[6], PlayerPosition.dm);
      expect(back.positions[8], PlayerPosition.lm);
      expect(back.lineup, lineup);
    });

    test('a tactic from before switches loads exactly as it was', () async {
      await repo.saveTactic(1, Tactic(formation: f433, lineup: lineup));
      expect(await db.select(db.drawsWatched).get(), isEmpty);
      final back = (await repo.tacticForCareer(1))!;
      expect(back.switches, SlotSwitches.none);
      expect(back.positions, f433.positions);
    });

    test('resetting clears the marks; careers never share them', () async {
      final t = Tactic(
        formation: f433,
        lineup: lineup,
        switches: const SlotSwitches({6: PlayerPosition.dm}),
      );
      await repo.saveTactic(1, t);
      await repo.saveTactic(2, Tactic(formation: f433, lineup: lineup));
      expect((await repo.tacticForCareer(2))!.switches, SlotSwitches.none);
      await repo.saveTactic(1, t.copyWith(switches: SlotSwitches.none));
      expect((await repo.tacticForCareer(1))!.switches, SlotSwitches.none);
      expect(await db.select(db.drawsWatched).get(), isEmpty);
    });

    test('a career bundle carries them across', () async {
      final careerId = await db
          .into(db.careers)
          .insert(
            CareersCompanion.insert(
              nationId: 1,
              managerName: 'Switch',
              createdAt: DateTime.utc(2030),
              inGameDate: DateTime.utc(2030, 6, 1),
              rngSeed: 7,
            ),
          );
      const s = SlotSwitches({6: PlayerPosition.dm, 9: PlayerPosition.am});
      await repo.saveTactic(
        careerId,
        Tactic(formation: f433, lineup: lineup, switches: s),
      );
      final bundle = CareerBundle.decode(
        CareerBundle.encode(await CareerBundle.export(db, careerId)),
      ).bundle!;
      final imported = await CareerBundle.import(db, bundle);
      expect(imported, isNot(careerId));
      expect((await repo.tacticForCareer(imported))!.switches, s);
    });

    test('stale switches saved under a new shape are not stored', () async {
      await repo.saveTactic(
        1,
        Tactic(
          formation: Formation.f442,
          lineup: lineup,
          // Slot 5 is the 4-3-3's DM; in a 4-4-2 it is the LM.
          switches: const SlotSwitches({5: PlayerPosition.cm}),
        ),
      );
      expect((await repo.tacticForCareer(1))!.switches, SlotSwitches.none);
    });
  });

  group('presets and the library', () {
    const s = SlotSwitches({6: PlayerPosition.dm});

    test('a library entry carries the switches; an old one has none', () {
      final t = LibraryTactic.capture(
        name: 'Holding',
        tactic: Tactic(formation: f433, lineup: lineup, switches: s),
      );
      final back = LibraryTactic.fromData(name: 'Holding', data: t.toData());
      expect(back.switches, s);
      final old = (jsonDecode(t.toData()) as Map<String, dynamic>)
        ..remove('switches');
      expect(
        LibraryTactic.fromData(name: 'Old', data: jsonEncode(old)).switches,
        SlotSwitches.none,
      );
    });

    test('a preset carries the switches; an old one has none', () {
      const p = TacticPreset(
        name: 'Holding',
        formation: f433,
        instructions: TacticalInstructions(),
        switches: s,
      );
      final json = jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>;
      expect(TacticPreset.fromJson(json)!.switches, s);
      final old = Map<String, dynamic>.of(json)..remove('switches');
      expect(TacticPreset.fromJson(old)!.switches, SlotSwitches.none);
    });
  });
}
