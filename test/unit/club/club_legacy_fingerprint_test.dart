import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/club/clubs.dart';

import '../../helpers/fixtures.dart';

/// The club draw of every career from before club strength, pinned.
///
/// Clubs are derived on every read, never stored: a change to the draw a
/// running career reads would move every player in it to another club and
/// rewrite his club history. So the legacy draw ([ClubService.clubForSeed]
/// without `strength`) must give exactly what it gave before the strength
/// rule and the new leagues landed. [_expected] was measured on the build
/// before them (main at adc7c1b2) and must never be edited.
///
/// It covers curated and uncurated home countries (with and without
/// cities), abroad moves at every level, ages across the contract clock and
/// a world's added clubs, over eight save seeds.
const _expected = 0x1620DD10;

int _fingerprint() {
  var h = 0x811C9DC5;
  void add(String s) {
    for (final u in s.codeUnits) {
      h ^= u;
      h = (h * 0x01000193) & 0xFFFFFFFF;
    }
    h ^= 0x7C;
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }

  const homes = <(String, List<String>)>[
    ('eng', ['London', 'Manchester']),
    ('cze', ['Praha', 'Brno', 'Ostrava']),
    ('fra', ['Paris']),
    ('and', ['Andorra la Vella', 'Escaldes-Engordany', 'Encamp', 'Sant Julià']),
    ('cro', ['Zagreb', 'Split', 'Rijeka', 'Osijek', 'Zadar', 'Pula']),
    ('zzz', []),
    ('', []),
  ];
  const added = <String, List<String>>{
    'cze': ['Added Praha', 'Added Brno'],
    'and': ['Added Andorra'],
    'eng': ['Added London'],
  };
  const seeds = [0, 1, 7, 42, 99, 1234, 98765, 2026];
  for (final seed in seeds) {
    for (final (code, cities) in homes) {
      for (var i = 0; i < 60; i++) {
        final id = 1000 + i * 37 + code.length;
        final overall = 50 + (i * 7) % 43;
        final age = 16 + (i * 5) % 21;
        final p = player(
          id: id,
          nationId: 7,
          position: PlayerPosition.cm,
          age: age,
          attributes: flatAttributes(overall),
        );
        for (final world in [const <String, List<String>>{}, added]) {
          final c = ClubService.clubForSeed(
            p,
            seed,
            homeCode: code,
            homeCities: cities,
            added: world,
          );
          add(c.name);
          add(c.country);
        }
      }
    }
  }
  return h;
}

void main() {
  test('the legacy club draw is exactly what it was before strength', () {
    final got = _fingerprint();
    expect(
      got,
      _expected,
      reason: 'fingerprint 0x${got.toRadixString(16).toUpperCase()}',
    );
  });
}
