import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/match/stadium/ground_look.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';

void main() {
  group('Landmarks', () {
    test('the curated cities find their landmark, accents and case aside', () {
      expect(Landmarks.forCity('Paris'), LandmarkKind.eiffel);
      expect(Landmarks.forCity('Roma'), LandmarkKind.colosseum);
      expect(Landmarks.forCity('Rome'), LandmarkKind.colosseum);
      expect(Landmarks.forCity('London'), LandmarkKind.bigBen);
      expect(Landmarks.forCity('Rio de Janeiro'), LandmarkKind.christRedeemer);
      expect(Landmarks.forCity('Reykjavík'), LandmarkKind.hallgrims);
      expect(Landmarks.forCity('REYKJAVIK'), LandmarkKind.hallgrims);
      expect(Landmarks.forCity('Ciudad de México'), LandmarkKind.angel);
      expect(Landmarks.forCity('København'), LandmarkKind.spires);
    });

    test('an unknown city has none', () {
      expect(Landmarks.forCity('Tórshavn'), LandmarkKind.none);
    });

    test('there are thirty landmarks', () {
      expect(LandmarkKind.values.length - 1, 30);
    });
  });

  group('the ground look', () {
    test('mowing and goals are fixed per ground', () {
      for (final s in ['Arena A', 'Stadion B', 'Estadio C']) {
        expect(MowingPattern.forStadium(s), MowingPattern.forStadium(s));
        final g = GoalStyle.forGround(
          stadium: s,
          groundCode: 'FRA',
          confederation: Confederation.europe,
          capacity: 50000,
        );
        expect(
          GoalStyle.forGround(
            stadium: s,
            groundCode: 'FRA',
            confederation: Confederation.europe,
            capacity: 50000,
          ),
          g,
        );
      }
    });

    test('every mowing pattern turns up across grounds', () {
      final seen = {
        for (var i = 0; i < 200; i++) MowingPattern.forStadium('Ground $i'),
      };
      expect(seen, MowingPattern.values.toSet());
    });

    test('South America mostly has box nets, small grounds the old goal', () {
      var box = 0, old = 0;
      for (var i = 0; i < 200; i++) {
        final big = GoalStyle.forGround(
          stadium: 'S$i',
          groundCode: 'ARG',
          confederation: Confederation.southAmerica,
          capacity: 50000,
        );
        if (big == GoalStyle.boxNet) box++;
        final small = GoalStyle.forGround(
          stadium: 'S$i',
          groundCode: 'ARG',
          confederation: Confederation.southAmerica,
          capacity: 6000,
        );
        if (small == GoalStyle.oldGround) old++;
      }
      expect(box, greaterThan(140));
      expect(old, greaterThan(110));
    });

    test('terrain follows the country', () {
      expect(
        Terrain.forGround(groundCode: 'BOL', capacity: 40000),
        Terrain.mountains,
      );
      expect(Terrain.forGround(groundCode: 'MLT', capacity: 8000), Terrain.sea);
      expect(
        Terrain.forGround(groundCode: 'QAT', capacity: 40000),
        Terrain.desert,
      );
      expect(
        Terrain.forGround(groundCode: 'GER', capacity: 60000),
        Terrain.city,
      );
      expect(
        Terrain.forGround(groundCode: 'GER', capacity: 9000),
        Terrain.hills,
      );
    });
  });
}
