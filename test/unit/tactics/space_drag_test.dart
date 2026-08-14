import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

void main() {
  const flat = TacticalInstructions();

  /// The y a band sits at, so a test can aim at a line without hardcoding a
  /// coordinate the layout table owns.
  double bandYWith(Formation f, PositionCategory c, TacticalInstructions i) {
    final ys = <double>[];
    final positions = f.positions;
    for (var slot = 0; slot < positions.length; slot++) {
      if (positions[slot].category != c) continue;
      ys.add(adjustedSlotY(layoutOf(f)[slot].$2, c, i));
    }
    return ys.reduce((a, b) => a + b) / ys.length;
  }

  double bandY(Formation f, PositionCategory c) => bandYWith(f, c, flat);

  int slotOf(Formation f, PositionCategory c) =>
      f.positions.indexWhere((p) => p.category == c);

  group('resolveSpaceDrag', () {
    test('a midfielder dropped among the forwards makes 4-4-2 into 4-3-3', () {
      final out = resolveSpaceDrag(
        Formation.f442,
        flat,
        slotOf(Formation.f442, PositionCategory.midfielder),
        bandY(Formation.f442, PositionCategory.forward),
      );
      expect(out, isA<ReshapeTo>());
      expect((out! as ReshapeTo).formation, Formation.f433);
    });

    test('a forward dropped among the defenders makes 4-3-3 into 5-3-2', () {
      final out = resolveSpaceDrag(
        Formation.f433,
        flat,
        slotOf(Formation.f433, PositionCategory.forward),
        bandY(Formation.f433, PositionCategory.defender),
      );
      expect(out, isA<ReshapeTo>());
      expect((out! as ReshapeTo).formation, Formation.f532);
    });

    test("a drop in the player's own band does nothing", () {
      expect(
        resolveSpaceDrag(
          Formation.f442,
          flat,
          slotOf(Formation.f442, PositionCategory.midfielder),
          bandY(Formation.f442, PositionCategory.midfielder),
        ),
        isNull,
      );
    });

    test('the keeper cannot be dragged out of goal', () {
      for (final band in [
        PositionCategory.defender,
        PositionCategory.midfielder,
        PositionCategory.forward,
      ]) {
        expect(
          resolveSpaceDrag(
            Formation.f442,
            flat,
            slotOf(Formation.f442, PositionCategory.goalkeeper),
            bandY(Formation.f442, band),
          ),
          isNull,
          reason: 'the keeper reached the $band band',
        );
      }
    });

    test("nobody can be dropped into the keeper's band", () {
      expect(
        resolveSpaceDrag(
          Formation.f442,
          flat,
          slotOf(Formation.f442, PositionCategory.forward),
          0.99,
        ),
        isNull,
      );
    });

    test('the bands track an extreme defensive line', () {
      // Read off the RENDERED layout, so a drop aimed at where the defenders
      // actually are resolves the same whatever the instructions did to them.
      const high = TacticalInstructions(defensiveLine: 100);
      final out = resolveSpaceDrag(
        Formation.f433,
        high,
        slotOf(Formation.f433, PositionCategory.forward),
        bandYWith(Formation.f433, PositionCategory.defender, high),
      );
      expect(out, isA<ReshapeTo>());
      expect((out! as ReshapeTo).formation, Formation.f532);
    });

    test(
      'every outcome is a real formation, from every band of every shape',
      () {
        // The constraint the whole feature rests on: a drag can never invent a
        // shape the game does not have.
        for (final f in Formation.values) {
          for (var slot = 0; slot < f.positions.length; slot++) {
            for (final band in PositionCategory.values) {
              final out = resolveSpaceDrag(f, flat, slot, bandY(f, band));
              if (out is ReshapeTo) {
                expect(Formation.values, contains(out.formation));
              }
            }
          }
        }
      },
    );
  });
}
