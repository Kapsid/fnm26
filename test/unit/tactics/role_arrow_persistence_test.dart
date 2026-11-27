import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_tactics_repository.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';

import '../../helpers/test_database.dart';

/// Slot roles and movement arrows are stored with the rest of the tactic (as
/// cycle-0 markers, so no schema change), carried by presets and the library,
/// and a save, preset or library entry from before they existed reads as
/// neutral.
void main() {
  late AppDatabase db;
  late DriftTacticsRepository repo;

  setUp(() {
    db = createTestDatabase();
    repo = DriftTacticsRepository(db);
  });
  tearDown(() => db.close());

  final lineup = [for (var i = 0; i < 11; i++) 100 + i];
  // 4-3-3: 0 gk, 1 lb, 2 cb, 3 cb, 4 rb, 5 dm, 6 cm, 7 cm, 8 lw, 9 st, 10 rw.
  const roles = SlotRoles({
    0: PlayerRole.sweeperKeeper,
    5: PlayerRole.anchor,
    9: PlayerRole.falseNine,
  });
  const arrows = SlotArrows({
    6: MoveArrow.forward,
    8: MoveArrow.forwardInside,
  });

  group('the save (DriftTacticsRepository)', () {
    test('round trip: roles and arrows come back as saved', () async {
      await repo.saveTactic(
        1,
        Tactic(
          formation: Formation.f433,
          lineup: lineup,
          roles: roles,
          arrows: arrows,
        ),
      );
      final back = (await repo.tacticForCareer(1))!;
      expect(back.roles, roles);
      expect(back.arrows, arrows);
      expect(back.roleAt(9), PlayerRole.falseNine);
      expect(back.arrowAt(8), MoveArrow.forwardInside);
      expect(back.lineup, lineup);
    });

    test(
      'a tactic from before them reads neutral and writes nothing',
      () async {
        await repo.saveTactic(
          1,
          Tactic(formation: Formation.f433, lineup: lineup),
        );
        expect(await db.select(db.drawsWatched).get(), isEmpty);
        final back = (await repo.tacticForCareer(1))!;
        expect(back.roles, SlotRoles.none);
        expect(back.arrows, SlotArrows.none);
        for (var s = 0; s < 11; s++) {
          expect(back.roleAt(s), PlayerRole.none);
          expect(back.arrowAt(s), MoveArrow.none);
        }
      },
    );

    test('clearing them removes the marks; other careers untouched', () async {
      final t = Tactic(
        formation: Formation.f433,
        lineup: lineup,
        roles: roles,
        arrows: arrows,
      );
      await repo.saveTactic(1, t);
      await repo.saveTactic(2, t);
      await repo.saveTactic(
        1,
        t.copyWith(roles: SlotRoles.none, arrows: SlotArrows.none),
      );
      final one = (await repo.tacticForCareer(1))!;
      expect(one.roles, SlotRoles.none);
      expect(one.arrows, SlotArrows.none);
      final two = (await repo.tacticForCareer(2))!;
      expect(two.roles, roles);
      expect(two.arrows, arrows);
    });

    test('the full-backs keep their own marks, read as arrows', () async {
      await repo.saveTactic(
        1,
        Tactic(
          formation: Formation.f433,
          lineup: lineup,
          fullBacks: const FullBackPushes(left: FullBackPush.up),
        ),
      );
      final back = (await repo.tacticForCareer(1))!;
      expect(back.arrowAt(1), MoveArrow.forward);
      expect(back.arrowAt(4), MoveArrow.none);
      expect(back.arrows, SlotArrows.none);
    });
  });

  group('the tactic', () {
    final t = Tactic(formation: Formation.f433, lineup: lineup);

    test('a role or arrow the place does not offer is refused', () {
      expect(t.withRole(0, PlayerRole.poacher), t);
      expect(t.withArrow(0, MoveArrow.forward), t);
      expect(t.withArrow(6, MoveArrow.inside), t, reason: 'central man');
      expect(t.withRole(9, PlayerRole.poacher).roleAt(9), PlayerRole.poacher);
    });

    test("a full-back's arrow is his FullBackPushes arrow", () {
      final up = t.withArrow(4, MoveArrow.forward);
      expect(up.fullBacks, const FullBackPushes(right: FullBackPush.up));
      expect(up.arrows, SlotArrows.none);
      expect(up.arrowAt(4), MoveArrow.forward);
      final back = up.withArrow(4, MoveArrow.back);
      expect(back.fullBacks.right, FullBackPush.down);
      expect(back.withArrow(4, MoveArrow.none).fullBacks.isNeutral, isTrue);
      expect(t.withArrow(1, MoveArrow.inside), t);
    });

    test('a role the shape no longer offers is kept but plays none', () {
      final poacher = t.withRole(9, PlayerRole.poacher);
      // Slot 9 is a striker in a 4-3-3 but in a 4-4-2 slot 9 is a striker
      // too; in a 3-5-2 slot 9 is still a striker. Switch the slot to AM.
      final switched = poacher.copyWith(
        switches: const SlotSwitches({9: PlayerPosition.am}),
      );
      expect(switched.positions[9], PlayerPosition.am);
      expect(switched.roleAt(9), PlayerRole.none);
      expect(switched.roles, poacher.roles, reason: 'kept for switching back');
    });

    test('a reshape carries each man his role and arrow', () {
      final set = t
          .withRole(6, PlayerRole.boxToBox)
          .withArrow(6, MoveArrow.forward)
          .withRole(9, PlayerRole.poacher);
      // The same men, the box-to-box man (106) now in slot 7.
      final moved = [...lineup]
        ..[6] = 107
        ..[7] = 106;
      final next = set.carriedTo(formation: Formation.f433, lineup: moved);
      expect(next.roleAt(7), PlayerRole.boxToBox);
      expect(next.arrowAt(7), MoveArrow.forward);
      expect(next.roleAt(6), PlayerRole.none);
      expect(next.roleAt(9), PlayerRole.poacher);
    });

    test('the legacy per-player role is the fallback', () {
      const legacy = {109: PlayerRole.targetMan};
      expect(t.effectiveRoleAt(9, legacy), PlayerRole.targetMan);
      expect(
        t.withRole(9, PlayerRole.poacher).effectiveRoleAt(9, legacy),
        PlayerRole.poacher,
      );
    });

    test('stored forms survive damage', () {
      expect(SlotRoles.fromJson('junk'), SlotRoles.none);
      expect(
        SlotRoles.fromJson(const {'x': 'poacher', '3': 'nobody'}),
        SlotRoles.none,
      );
      expect(SlotRoles.fromJson(roles.toJson()), roles);
      expect(SlotArrows.fromJson(const {'2': 'sideways'}), SlotArrows.none);
      expect(SlotArrows.fromJson(arrows.toJson()), arrows);
    });

    test('a drag picks the nearest arrow the place offers', () {
      final wide = MoveArrowX.optionsFor(PlayerPosition.lw);
      // Up the screen is forward; right is inside for a left winger.
      expect(MoveArrowX.nearest(wide, 0, -60, -1), MoveArrow.forward);
      expect(MoveArrowX.nearest(wide, 50, -50, -1), MoveArrow.forwardInside);
      expect(MoveArrowX.nearest(wide, -60, 0, -1), MoveArrow.outside);
      expect(MoveArrowX.nearest(wide, 60, 0, 1), MoveArrow.outside);
      expect(MoveArrowX.nearest(wide, 3, -4, -1), isNull, reason: 'too short');
      final central = MoveArrowX.optionsFor(PlayerPosition.cm);
      expect(MoveArrowX.nearest(central, 60, 0, 0), isNull);
      expect(MoveArrowX.nearest(central, 5, 60, 0), MoveArrow.back);
    });
  });

  group('presets and the library', () {
    test('a preset carries them; one from before them says nothing', () {
      const p = TacticPreset(
        name: 'Press',
        formation: Formation.f433,
        instructions: TacticalInstructions(),
        roles: roles,
        arrows: arrows,
      );
      final back = TacticPreset.fromJson(
        jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>,
      )!;
      expect(back.roles, roles);
      expect(back.arrows, arrows);
      final old = TacticPreset.fromJson(const {
        'name': 'Old',
        'formation': 'f442',
      })!;
      expect(old.roles, isNull);
      expect(old.arrows, isNull);
    });

    test('the library captures slot roles over legacy ones, and arrows', () {
      final t = Tactic(
        formation: Formation.f433,
        lineup: lineup,
        roles: roles,
        arrows: arrows,
      );
      final entry = LibraryTactic.capture(
        name: 'Ours',
        tactic: t,
        roles: const {
          109: PlayerRole.targetMan,
          110: PlayerRole.invertedWinger,
        },
      );
      expect(entry.rolesBySlot[9], PlayerRole.falseNine);
      expect(entry.rolesBySlot[10], PlayerRole.invertedWinger);
      expect(entry.rolesBySlot[0], PlayerRole.sweeperKeeper);
      final back = LibraryTactic.fromData(name: 'Ours', data: entry.toData());
      expect(back.rolesBySlot, entry.rolesBySlot);
      expect(back.arrows, arrows);
      final old = LibraryTactic.fromData(
        name: 'Old',
        data: jsonEncode({'formation': 'f433'}),
      );
      expect(old.arrows, isNull);
    });
  });
}
