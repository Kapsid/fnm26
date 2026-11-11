import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/match/stadium/ground_look.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';
import 'package:fnm/features/match/pitch/landmark_paths.dart';

void main() {
  group('Landmarks', () {
    test('the curated cities find their landmark, accents and case aside', () {
      expect(Landmarks.forCity('Paris'), LandmarkKind.eiffel);
      expect(Landmarks.forCity('Roma'), LandmarkKind.colosseum);
      expect(Landmarks.forCity('Rome'), LandmarkKind.colosseum);
      expect(Landmarks.forCity('London'), LandmarkKind.bigBen);
      expect(Landmarks.forCity('Rio de Janeiro'), LandmarkKind.sugarloaf);
      expect(Landmarks.forCity('Reykjavík'), LandmarkKind.hallgrims);
      expect(Landmarks.forCity('REYKJAVIK'), LandmarkKind.hallgrims);
      expect(Landmarks.forCity('Ciudad de México'), LandmarkKind.angel);
      expect(Landmarks.forCity('København'), LandmarkKind.spires);
    });

    test('an unknown city has none', () {
      expect(Landmarks.forCity('Tórshavn'), LandmarkKind.none);
    });

    test('there are eighty landmarks', () {
      expect(LandmarkKind.values.length - 1, 80);
    });

    // The second set, keyed on the spellings the game's data uses.
    const second = {
      'Vienna': LandmarkKind.riesenrad,
      'Brussels': LandmarkKind.brusselsTownHall,
      'Warsaw': LandmarkKind.palaceOfCulture,
      'Munich': LandmarkKind.frauenkirche,
      'Stockholm': LandmarkKind.stockholmCityHall,
      'Helsinki': LandmarkKind.helsinkiCathedral,
      'Edinburgh': LandmarkKind.edinburghCastle,
      'Dublin': LandmarkKind.dublinSpire,
      'Kyiv': LandmarkKind.motherland,
      'Bucharest': LandmarkKind.palaceOfParliament,
      'Zagreb': LandmarkKind.zagrebCathedral,
      'Riyadh': LandmarkKind.kingdomCentre,
      'Doha': LandmarkKind.aspireTorch,
      'Tehran': LandmarkKind.azadi,
      'Delhi': LandmarkKind.indiaGate,
      'Bangkok': LandmarkKind.watArun,
      'Shanghai': LandmarkKind.orientalPearl,
      'Philadelphia': LandmarkKind.independenceHall,
      'Montevideo': LandmarkKind.palacioSalvo,
      'Bogotá': LandmarkKind.monserrate,
      'Santiago': LandmarkKind.costanera,
      'Casablanca': LandmarkKind.hassanII,
      'Nairobi': LandmarkKind.kicc,
      'Auckland': LandmarkKind.skyTower,
    };

    test('the second set: each city hosts a ground in the game data and '
        'finds its landmark', () {
      final stadiums =
          jsonDecode(
                File('assets/data/national_stadiums.json').readAsStringSync(),
              )
              as Map<String, Object?>;
      final hosts = {
        for (final list in stadiums.values)
          for (final g in (list! as List).cast<Map<String, Object?>>())
            g['city']! as String,
      };
      for (final MapEntry(key: city, value: kind) in second.entries) {
        expect(hosts, contains(city), reason: city);
        expect(Landmarks.forCity(city), kind, reason: city);
      }
      // One landmark each: none shared with another city of the set.
      expect(second.values.toSet().length, second.length);
    });

    test('the second set: local spellings, accents and case aside', () {
      for (final (city, kind) in [
        ('Wien', LandmarkKind.riesenrad),
        ('Bruxelles', LandmarkKind.brusselsTownHall),
        ('Brussel', LandmarkKind.brusselsTownHall),
        ('Warszawa', LandmarkKind.palaceOfCulture),
        ('München', LandmarkKind.frauenkirche),
        ('MUENCHEN', LandmarkKind.frauenkirche),
        ('Helsingfors', LandmarkKind.helsinkiCathedral),
        ('Kiev', LandmarkKind.motherland),
        ('Kyjiv', LandmarkKind.motherland),
        ('București', LandmarkKind.palaceOfParliament),
        ('Bucureşti', LandmarkKind.palaceOfParliament),
        ('New Delhi', LandmarkKind.indiaGate),
        ('Bogota', LandmarkKind.monserrate),
        ('Santiago de Chile', LandmarkKind.costanera),
        ('Teheran', LandmarkKind.azadi),
        ('Riyad', LandmarkKind.kingdomCentre),
      ]) {
        expect(Landmarks.forCity(city), kind, reason: city);
      }
      // Namesakes elsewhere keep no landmark.
      for (final city in [
        'Santiago de Cuba',
        'Santiago de los Caballeros',
        'Wiener Neustadt',
        'Helsingborg',
      ]) {
        expect(Landmarks.forCity(city), LandmarkKind.none, reason: city);
      }
    });

    test('every landmark has a silhouette; the second set one unit tall', () {
      for (final k in LandmarkKind.values.skip(1)) {
        expect(LandmarkPaths.of(k).getBounds().isEmpty, isFalse);
      }
      for (final k in second.values) {
        final b = LandmarkPaths.of(k).getBounds();
        expect(b.isEmpty, isFalse, reason: k.name);
        expect(b.top, closeTo(-1, 0.05), reason: k.name);
        expect(b.bottom, closeTo(0, 0.02), reason: k.name);
      }
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
  });
}
