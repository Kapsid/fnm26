import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
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

  test('typeOf reads back the type it built', () {
    for (final pos in PlayerPosition.values) {
      for (final t in PlayerType.values) {
        expect(
          PlayerBuild.typeOf(PlayerBuild.attributesFor(pos, t, 70)),
          t,
          reason: '$pos $t',
        );
      }
    }
  });
}
