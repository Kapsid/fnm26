import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/player_build.dart';

void main() {
  test('every position, type and overall 20..99 lands within 1', () {
    final bad = <String>[];
    for (final pos in PlayerPosition.values) {
      for (final t in PlayerType.values) {
        for (var o = 20; o <= 99; o++) {
          final a = PlayerBuild.attributesFor(pos, t, o);
          final got = OverallRating.forPosition(pos, a);
          if ((got - o).abs() > 1) bad.add('$pos $t $o -> $got');
        }
      }
    }
    expect(bad, isEmpty);
  });

  test('qualities stay within 1..99', () {
    for (final pos in PlayerPosition.values) {
      for (final t in PlayerType.values) {
        for (var o = 1; o <= 99; o++) {
          final a = PlayerBuild.attributesFor(pos, t, o);
          for (final q in [a.physical, a.technical, a.stamina]) {
            expect(q, inInclusiveRange(1, 99), reason: '$pos $t $o');
          }
        }
      }
    }
  });

  test('typeOf reads back the type it built, at every overall', () {
    // Near 99 the qualities cap and a type's ratio no longer fits: the
    // exact rebuild still names it.
    for (final pos in PlayerPosition.values) {
      for (final t in PlayerType.values) {
        for (var o = 1; o <= 99; o++) {
          final a = PlayerBuild.attributesFor(pos, t, o);
          // At the very bottom two types can round to the same qualities;
          // then either name is right.
          final twins = {
            for (final u in PlayerType.values)
              if (PlayerBuild.attributesFor(pos, u, o) == a) u,
          };
          final read = PlayerBuild.typeOf(pos, a);
          expect(
            twins.length == 1 ? read == t : twins.contains(read),
            isTrue,
            reason: '$pos $t $o read as $read',
          );
        }
      }
    }
  });

  test('typeOf falls back to the nearest ratio for hand-made qualities', () {
    expect(
      PlayerBuild.typeOf(
        PlayerPosition.st,
        const PlayerAttributes(physical: 80, technical: 61, stamina: 70),
      ),
      PlayerType.athlete,
    );
    expect(
      PlayerBuild.typeOf(
        PlayerPosition.cm,
        const PlayerAttributes(physical: 55, technical: 75, stamina: 58),
      ),
      PlayerType.technician,
    );
  });
}
