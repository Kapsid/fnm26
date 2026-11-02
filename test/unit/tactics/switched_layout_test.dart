import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/switched_layout.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

/// A switched slot's disc is drawn in the row of the place it now plays.
void main() {
  const f433 = Formation.f433;
  // 4-3-3 slots: 0 gk, 1 lb, 2 cb, 3 cb, 4 rb, 5 dm, 6 cm, 7 cm, 8 lw, 9 st,
  // 10 rw. Layout: DM (0.5, 0.55), CMs (0.30/0.70, 0.42), ST (0.5, 0.13).
  const dm = 5;

  List<(double, double)> layout(
    Map<int, PlayerPosition> m, [
    Formation f = f433,
  ]) => switchedLayoutOf(f, SlotSwitches(m));

  test('with no switches every shape draws exactly as its table', () {
    for (final f in Formation.values) {
      expect(switchedLayoutOf(f, SlotSwitches.none), layoutOf(f));
    }
  });

  test('4-3-3 DM to CM: three CMs across the CM row, evenly, symmetric', () {
    final l = layout({dm: PlayerPosition.cm});
    final cmY = layoutOf(f433)[6].$2;
    for (final s in [5, 6, 7]) {
      expect(l[s].$2, closeTo(cmY, 0.035), reason: 'slot $s on the CM row');
    }
    final xs = [
      for (final s in [5, 6, 7]) l[s].$1,
    ]..sort();
    expect(xs[1], closeTo(0.5, 1e-9), reason: 'the DM is the middle one');
    expect(xs[1] - xs[0], closeTo(xs[2] - xs[1], 1e-9), reason: 'even');
    expect(xs[0] + xs[2], closeTo(1, 1e-9), reason: 'symmetric');
    // The two outer CMs level with each other.
    expect(l[6].$2, l[7].$2);
    // Nobody else moved.
    for (final s in [0, 1, 2, 3, 4, 8, 9, 10]) {
      expect(l[s], layoutOf(f433)[s], reason: 'slot $s');
    }
  });

  test('4-3-3 DM to AM: centrally behind the striker, CMs re-centred', () {
    final base = layoutOf(f433);
    final l = layout({dm: PlayerPosition.am});
    expect(l[dm].$1, 0.5);
    expect(l[dm].$2, lessThan(base[6].$2), reason: 'in front of the CMs');
    expect(l[dm].$2, greaterThan(base[9].$2), reason: 'behind the striker');
    // The two CMs close up around the middle, still level and symmetric.
    expect(l[6].$2, l[7].$2);
    expect(l[6].$1 + l[7].$1, closeTo(1, 1e-9));
    expect(l[6].$1, greaterThan(base[6].$1));
    expect(l[7].$1, lessThan(base[7].$1));
  });

  test('4-3-3 CM to DM: two holding men side by side, the CM centred', () {
    final l = layout({6: PlayerPosition.dm});
    expect(l[5].$2, l[6].$2, reason: 'one DM row');
    expect(l[5].$1 + l[6].$1, closeTo(1, 1e-9));
    expect(l[6].$1, lessThan(0.5), reason: 'the left CM drops on the left');
    expect(l[7].$1, 0.5);
    expect(l[7].$2, lessThan(l[5].$2));
  });

  test('switching back draws the formation spot again', () {
    final on = SlotSwitches.none.withSlot(f433, dm, PlayerPosition.am);
    expect(switchedLayoutOf(f433, on), isNot(layoutOf(f433)));
    final off = on.withSlot(f433, dm, PlayerPosition.dm);
    expect(switchedLayoutOf(f433, off), layoutOf(f433));
  });

  test('4-4-2 LM to LW: up into the forward row on the left', () {
    const f = Formation.f442; // 5 lm, 6 cm, 7 cm, 8 rm, 9 st, 10 st
    final base = layoutOf(f);
    final l = layout({5: PlayerPosition.lw}, f);
    expect(l[5].$1, lessThan(0.2), reason: 'still on the left flank');
    expect(l[5].$1, lessThan(l[9].$1));
    expect(
      (l[5].$2 - base[9].$2).abs(),
      lessThan(0.08),
      reason: 'level with the strikers, a winger a shade deeper',
    );
    expect(l[5].$2, lessThan(base[6].$2 - 0.2), reason: 'out of midfield');
  });

  test('4-3-3 LW to LM: down into midfield on the left', () {
    final l = layout({8: PlayerPosition.lm});
    expect(l[8].$1, lessThan(0.2));
    expect((l[8].$2 - l[6].$2).abs(), lessThan(0.05), reason: 'CM row');
  });

  test('4-4-2 striker to AM: behind the other, who stays a striker', () {
    const f = Formation.f442;
    final l = layout({9: PlayerPosition.am}, f);
    expect(l[9].$1, 0.5);
    expect(l[10].$1, 0.5, reason: 'the lone striker re-centres');
    expect(l[9].$2, greaterThan(l[10].$2));
    expect(l[9].$2, lessThan(l[6].$2));
  });

  test('two tens in a 4-3-3 stand side by side', () {
    final l = layout({6: PlayerPosition.am, 7: PlayerPosition.am});
    expect(l[6].$2, l[7].$2);
    expect(l[6].$1 + l[7].$1, closeTo(1, 1e-9));
    expect(l[6].$1, lessThan(l[7].$1));
  });

  group('the drag zones read the disc where it is drawn', () {
    test('an AM moved up from DM is dragged back from the AM row', () {
      const s = SlotSwitches({dm: PlayerPosition.am});
      final (x, y) = switchedLayoutOf(f433, s)[dm];
      expect(slotZoneAt(f433, dm, x, y, switches: s), PlayerPosition.am);
      expect(slotZoneAt(f433, dm, 0.5, 0.42, switches: s), PlayerPosition.cm);
      expect(slotZoneAt(f433, dm, 0.5, 0.55, switches: s), PlayerPosition.dm);
      expect(
        switchIntentAt(f433, s, dm, 0.5, 0.55),
        PlayerPosition.dm,
        reason: 'back to his own place',
      );
    });

    test('a winger pushed on from LM is dragged back down the flank', () {
      const f = Formation.f442;
      const s = SlotSwitches({5: PlayerPosition.lw});
      final (x, y) = switchedLayoutOf(f, s)[5];
      expect(slotZoneAt(f, 5, x, y, switches: s), PlayerPosition.lw);
      expect(slotZoneAt(f, 5, 0.12, 0.45, switches: s), PlayerPosition.lm);
      expect(switchIntentAt(f, s, 5, 0.12, 0.45), PlayerPosition.lm);
    });
  });
}
