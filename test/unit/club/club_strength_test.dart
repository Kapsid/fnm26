import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/club/clubs.dart';

import '../../helpers/fixtures.dart';

Player _at(int overall, int id, {int age = 27}) => player(
  id: id,
  nationId: 7,
  position: PlayerPosition.cm,
  age: age,
  attributes: flatAttributes(overall),
);

/// Where [count] players of [overall] from [home] land under the strength
/// rule, over eight save seeds: each club's stars, counted.
///
/// At thirty, his peak: the club is read off his level when he joined
/// ([ClubService.clubLevel]), which for a younger man still carries part of
/// the climb ahead of him.
Map<int, int> _starsOfDraws(
  String home,
  int overall, {
  bool homeOnly = true,
  int count = 300,
}) {
  final out = <int, int>{};
  const seeds = [3, 17, 31, 64, 99, 512, 1234, 5678];
  for (final seed in seeds) {
    for (var i = 0; i < count; i++) {
      final c = ClubService.clubForSeed(
        _at(overall, 5000 + i * 13, age: 30),
        seed,
        homeCode: home,
        strength: true,
      );
      if (homeOnly && c.country != home) continue;
      final s = ClubService.starsOf(c);
      out[s] = (out[s] ?? 0) + 1;
    }
  }
  return out;
}

double _share(Map<int, int> m, bool Function(int stars) where) {
  final total = m.values.fold(0, (a, b) => a + b);
  final hit = m.entries
      .where((e) => where(e.key))
      .fold(0, (a, e) => a + e.value);
  return hit / total;
}

/// Every nation code of the game (the 209 base nations and the dormant
/// three).
Set<String> _allCodes() {
  final raw = jsonDecode(File('assets/data/nations.json').readAsStringSync());
  return {
    for (final n in raw as List) (n as Map)['code'].toString().toLowerCase(),
    'blr',
    'grl',
    'zan',
  };
}

void main() {
  group('ClubStrength.derived', () {
    test('tier sets the range, place in the list the step', () {
      // England: 18 clubs, tier 1.
      final eng = [for (var i = 0; i < 18; i++) ClubStrength.derived(i, 18, 1)];
      expect(eng.first, 5);
      expect(eng.last, 3);
      expect(eng.where((s) => s == 5).length, 5);
      expect(eng.where((s) => s == 4).length, 6);
      expect(eng.where((s) => s == 3).length, 7);
      // Tier 3 (Czechia, 14): 3/2/1.
      expect(ClubStrength.derived(0, 14, 3), 3);
      expect(ClubStrength.derived(6, 14, 3), 2);
      expect(ClubStrength.derived(13, 14, 3), 1);
      // Tier 4: 2/1/1. Tier 5: 1 throughout.
      expect(ClubStrength.derived(0, 8, 4), 2);
      expect(ClubStrength.derived(7, 8, 4), 1);
      for (var i = 0; i < 6; i++) {
        expect(ClubStrength.derived(i, 6, 5), 1);
      }
    });

    test('a club reads its stars off its league', () {
      expect(ClubService.starsOf((name: 'Man Blue', country: 'eng')), 5);
      expect(ClubService.starsOf((name: 'FC Blšany', country: 'cze')), 1);
      expect(ClubService.starsOf((name: 'Prague Iron', country: 'CZE')), 3);
      expect(
        ClubService.starsOf((name: ClubService.freeAgent, country: 'eng')),
        0,
      );
      expect(ClubService.starsOf((name: 'X', country: '')), 0);
      // A side named for a city (a career from before the leagues): its
      // league's lowest.
      expect(ClubService.starsOf((name: 'Zagreb City', country: 'cro')), 1);
      expect(ClubService.leagueStars('eng').first, 5);
    });

    test('a world sets a game club\'s stars and an added club\'s own', () {
      final world = ClubWorld(
        added: const {
          'cze': ['Added One', 'Added Two'],
        },
        addedStrengths: const {
          'cze': {'Added One': 3},
        },
        strengths: const {'FC Blšany': 3, 'Man Blue': 9},
      );
      expect(
        ClubService.starsOf((name: 'FC Blšany', country: 'cze'), world: world),
        3,
      );
      // Out of range: the default stands.
      expect(
        ClubService.starsOf((name: 'Man Blue', country: 'eng'), world: world),
        5,
      );
      expect(
        ClubService.starsOf((name: 'Added One', country: 'cze'), world: world),
        3,
      );
      // None set: the league's lowest.
      expect(
        ClubService.starsOf((name: 'Added Two', country: 'cze'), world: world),
        1,
      );
      expect(ClubService.addedDefaultStars('eng'), 3);
      expect(ClubService.addedDefaultStars('zzz'), 1);
    });
  });

  group('the level-weighted pick', () {
    test('a level-85 player in England: 70% or more at a five-star club, '
        'no more than 6% at a three-star one', () {
      final m = <int, int>{};
      for (var h = 0; h < 20000; h++) {
        final name = ClubService.pickByStrength(
          'eng',
          85,
          (h * 2654435761) & 0x7fffffff,
        )!;
        final s = ClubService.starsOf((name: name, country: 'eng'));
        m[s] = (m[s] ?? 0) + 1;
      }
      expect(_share(m, (s) => s == 5), greaterThanOrEqualTo(0.70));
      expect(_share(m, (s) => s <= 3), lessThanOrEqualTo(0.06));
    });

    test('an 85-rated man at his peak, read through his contract', () {
      // His level when he joined sits a point or two under 85 now and then,
      // so a little less than the pick alone.
      final m = _starsOfDraws('eng', 85);
      expect(_share(m, (s) => s == 5), greaterThanOrEqualTo(0.60));
      expect(_share(m, (s) => s <= 3), lessThanOrEqualTo(0.08));
    });

    test('74 to 79 players in England spread over the middle, '
        'not the top', () {
      final m = <int, int>{};
      for (var o = 74; o <= 79; o++) {
        for (final e in _starsOfDraws('eng', o, count: 80).entries) {
          m[e.key] = (m[e.key] ?? 0) + e.value;
        }
      }
      expect(_share(m, (s) => s == 5), lessThan(0.15));
      expect(_share(m, (s) => s == 3 || s == 4), greaterThan(0.80));
    });

    test('the best Czech at home is at a big Czech club', () {
      final m = _starsOfDraws('cze', 82);
      expect(_share(m, (s) => s == 3), greaterThanOrEqualTo(0.70));
      expect(_share(m, (s) => s == 1), lessThanOrEqualTo(0.06));
    });

    test('a weak player is at a small club', () {
      final m = _starsOfDraws('cze', 60);
      expect(_share(m, (s) => s == 1), greaterThanOrEqualTo(0.70));
    });

    test('an export lands at a club of his level abroad', () {
      final m = _starsOfDraws('cro', 86, homeOnly: false);
      expect(_share(m, (s) => s >= 4), greaterThan(0.75));
    });

    test('every pick is a club of the league (or an added one)', () {
      final world = ClubWorld(
        added: const {
          'and': ['Added Andorra'],
        },
      );
      final names = {...ClubService.leagueClubs('and'), 'Added Andorra'};
      for (var i = 0; i < 400; i++) {
        final c = ClubService.clubForSeed(
          _at(55 + i % 30, 9000 + i),
          11,
          homeCode: 'and',
          world: world,
          strength: true,
        );
        if (c.country == 'and') expect(names, contains(c.name));
      }
    });

    test('deterministic: the same player and seed, the same club', () {
      for (var i = 0; i < 50; i++) {
        final p = _at(70 + i % 20, 7000 + i);
        expect(
          ClubService.clubForSeed(p, 5, homeCode: 'eng', strength: true),
          ClubService.clubForSeed(p, 5, homeCode: 'eng', strength: true),
        );
      }
    });

    test('a renewal keeps him where he is (contract clock unchanged)', () {
      var moves = 0;
      var seasons = 0;
      for (var i = 0; i < 200; i++) {
        ClubSide? last;
        for (var age = 18; age <= 34; age++) {
          final c = ClubService.clubForSeed(
            _at(72, 3000 + i * 11, age: age),
            9,
            homeCode: 'cze',
            strength: true,
          );
          if (last != null) {
            seasons++;
            if (c != last) moves++;
          }
          last = c;
        }
      }
      // The legacy clock moves a player in about a quarter of seasons.
      expect(moves / seasons, lessThan(0.40));
      expect(moves / seasons, greaterThan(0.10));
    });
  });

  group('the leagues', () {
    test('every nation has at least five named clubs, none twice', () {
      for (final code in _allCodes()) {
        final clubs = ClubService.leagueClubs(code);
        expect(clubs.length, greaterThanOrEqualTo(5), reason: code);
        expect(clubs.toSet().length, clubs.length, reason: code);
      }
    });

    test('names are names: short, no dashes of the wrong kind, fictional', () {
      const realBrands = {
        'Dinamo',
        'Dynamo',
        'Partizan',
        'Red Star',
        'Crvena',
        'Hajduk',
        'Legia',
        'Peñarol',
        'Colo-Colo',
        'Maccabi',
        'Hapoel',
        'Beitar',
        'Persepolis',
        'Esteghlal',
        'Shakhtar',
        'Steaua',
        'Highlanders',
        'Kaizer',
        'Orlando Pirates',
        'Sundowns',
        'Al Ahly',
        'Zamalek',
        'Wydad',
        'Espérance',
      };
      for (final l in ClubService.allLeagues()) {
        for (final c in l.clubs) {
          expect(c.length, lessThanOrEqualTo(40), reason: c);
          expect(c.contains('—'), isFalse, reason: c);
          expect(c.contains('–'), isFalse, reason: c);
          for (final b in realBrands) {
            expect(c.contains(b), isFalse, reason: '$c names $b');
          }
        }
      }
    });

    test('the curated leagues the old draw indexes are untouched', () {
      // A running career's draw indexes these lists: never reorder or
      // shorten them (append only, and only behind a marker).
      const lengths = {
        'eng': 18, 'esp': 18, 'ita': 18, 'ger': 18, 'fra': 18, //
        'cze': 14, 'tpe': 8, 'nor': 6, 'den': 6,
      };
      for (final e in lengths.entries) {
        expect(ClubService.leagueClubs(e.key).length, e.value, reason: e.key);
      }
      expect(ClubService.leagueClubs('eng').first, 'Man Blue');
      expect(ClubService.leagueClubs('cze').last, 'FC Blšany');
    });

    test('the new leagues are no destination abroad', () {
      // Nobody from abroad is placed in a league that only keeps its own.
      final curated = {
        for (final code in [
          'eng', 'esp', 'ita', 'ger', 'fra', 'por', 'ned', 'bra', 'arg', //
          'ksa', 'usa', 'tur', 'bel', 'mex', 'sco', 'gre', 'jpn', 'kor', //
          'sui', 'aut', 'col', 'egy', 'rsa', 'mar', 'nga', 'aus', 'chn', //
          'ecu', 'par', 'nor', 'swe', 'den', 'cze', 'tpe', //
        ])
          code,
      };
      for (var i = 0; i < 2000; i++) {
        final c = ClubService.clubForSeed(
          _at(50 + i % 45, 20000 + i),
          i % 8,
          homeCode: 'and',
          strength: true,
        );
        if (c.country != 'and') expect(curated, contains(c.country));
      }
      // And their tier moves no fee: an uncurated country is still tier 5.
      expect(ClubService.tierOfCountry('cro'), 5);
    });
  });
}
