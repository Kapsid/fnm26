import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

/// A drag released in open space that lands in the zone of a place its slot
/// may switch to is a switch within the shape, not a reshape.
void main() {
  const flat = TacticalInstructions();
  const f433 = Formation.f433;
  // 4-3-3 slots: 0 gk, 1 lb, 2 cb, 3 cb, 4 rb, 5 dm, 6 cm, 7 cm, 8 lw, 9 st,
  // 10 rw. Layout: DM (0.5, 0.55), CMs y 0.42, ST (0.5, 0.13).
  const dm = 5;

  /// [resolveSwitchDrop] at layout point (x, y), with the space drop's own
  /// fraction taken as the same y (close enough for which band it reads).
  PlayerPosition? drop(
    int slot,
    double x,
    double y, {
    Formation f = f433,
    SlotSwitches switches = SlotSwitches.none,
  }) => resolveSwitchDrop(
    f,
    flat,
    switches,
    slot,
    x: x,
    y: y,
    dropY: y,
  );

  group('slotZoneAt', () {
    test('the 4-3-3 DM: CM a line up, AM two, ST three', () {
      expect(slotZoneAt(f433, dm, 0.5, 0.55), PlayerPosition.dm);
      expect(slotZoneAt(f433, dm, 0.5, 0.43), PlayerPosition.cm);
      expect(slotZoneAt(f433, dm, 0.5, 0.30), PlayerPosition.am);
      expect(slotZoneAt(f433, dm, 0.5, 0.16), PlayerPosition.st);
      expect(slotZoneAt(f433, dm, 0.5, 0.72), isNull, reason: 'back line');
      expect(slotZoneAt(f433, dm, 0.1, 0.30), isNull, reason: 'a flank');
    });

    test('a wide man only on his own flank', () {
      const lm = 5; // 4-4-2 LM at (0.12, 0.45)
      expect(slotZoneAt(Formation.f442, lm, 0.10, 0.18), PlayerPosition.lw);
      expect(slotZoneAt(Formation.f442, lm, 0.90, 0.18), isNull);
      expect(slotZoneAt(Formation.f442, lm, 0.50, 0.18), isNull);
    });

    test('defenders and the keeper have no zones', () {
      for (final slot in [0, 1, 2, 3, 4]) {
        expect(slotZoneAt(f433, slot, 0.5, 0.30), isNull);
      }
    });
  });

  group('resolveSwitchDrop', () {
    test('the 4-3-3 DM into the gap behind the forwards plays AM', () {
      expect(drop(dm, 0.5, 0.30), PlayerPosition.am);
      final next = SlotSwitches.none.withSlot(f433, dm, PlayerPosition.am);
      expect(next.apply(f433)[dm], PlayerPosition.am);
    });

    test('into the striker line it is not a switch: the reshape stands', () {
      expect(drop(dm, 0.5, 0.15), isNull);
      // And what happens instead is exactly what happened before.
      expect(resolveSpaceDrag(f433, flat, dm, 0.15), isA<ReshapeTo>());
    });

    test('a centre-back dragged into attack is never a switch', () {
      expect(drop(2, 0.5, 0.30), isNull);
      expect(drop(2, 0.5, 0.15), isNull);
    });

    test('the place it already plays is no switch', () {
      const s = SlotSwitches({dm: PlayerPosition.am});
      expect(drop(dm, 0.5, 0.30, switches: s), isNull);
    });

    test('back into its own zone undoes a switch, even at the limit', () {
      const s = SlotSwitches({dm: PlayerPosition.am, 6: PlayerPosition.dm});
      expect(drop(dm, 0.62, 0.55, switches: s), PlayerPosition.dm);
    });

    test('at the limit: the old reshape where there was one', () {
      const s = SlotSwitches({6: PlayerPosition.dm, 7: PlayerPosition.am});
      // The AM gap reads as the forward band, so the old drop reshaped.
      expect(resolveSpaceDrag(f433, flat, dm, 0.28), isA<ReshapeTo>());
      expect(drop(dm, 0.5, 0.28, switches: s), isNull);
    });

    test('at the limit: the refused switch where the old drop bounced', () {
      const s = SlotSwitches({6: PlayerPosition.dm, 7: PlayerPosition.am});
      // The CM zone is the DM's own band, where the old drop did nothing,
      // so the switch comes back for the caller to refuse out loud.
      expect(resolveSpaceDrag(f433, flat, dm, 0.43), isNull);
      expect(drop(dm, 0.5, 0.43, switches: s), PlayerPosition.cm);
      expect(SlotSwitches.none.canSwitch(f433, dm), isTrue);
      expect(s.canSwitch(f433, dm), isFalse);
    });
  });
}
