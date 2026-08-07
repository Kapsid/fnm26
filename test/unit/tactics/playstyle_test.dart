import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';

void main() {
  group('Playstyle', () {
    test('every named style composes into instructions', () {
      for (final s in Playstyle.values) {
        if (s == Playstyle.custom) {
          expect(s.instructions, isNull);
        } else {
          expect(s.instructions, isNotNull, reason: '$s must be playable');
        }
      }
    });

    test('a composed style names itself back', () {
      for (final s in Playstyle.values) {
        final composed = s.instructions;
        if (composed == null) continue;
        expect(PlaystyleX.matching(composed), s);
      }
    });

    test('moving a dial by hand makes the tactic custom', () {
      final gegenpress = Playstyle.gegenpress.instructions!;
      final nudged = gegenpress.copyWith(pressing: gegenpress.pressing - 5);
      expect(PlaystyleX.matching(nudged), Playstyle.custom);
    });

    test('the styles are genuinely different from one another', () {
      final profiles = [
        for (final s in Playstyle.values)
          if (s.instructions case final i?) i,
      ];
      expect(profiles.toSet(), hasLength(profiles.length));
    });

    test('the styles say what their names claim', () {
      final press = Playstyle.gegenpress.instructions!;
      final block = Playstyle.lowBlock.instructions!;
      expect(press.pressing, greaterThan(block.pressing));
      expect(press.defensiveLine, greaterThan(block.defensiveLine));

      final possession = Playstyle.possession.instructions!;
      final direct = Playstyle.direct.instructions!;
      expect(possession.directness, lessThan(direct.directness));

      expect(
        Playstyle.wingPlay.instructions!.width,
        greaterThan(Playstyle.lowBlock.instructions!.width),
      );
      expect(
        Playstyle.counter.instructions!.mentality,
        lessThan(Playstyle.gegenpress.instructions!.mentality),
      );
    });

    test('a tactic defaults to no stated style', () {
      const t = Tactic(formation: Formation.f433, lineup: []);
      expect(t.playstyle, Playstyle.custom);
    });
  });
}
