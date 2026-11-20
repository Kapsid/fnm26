import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';

import '../../helpers/fixtures.dart';

/// The 1.1.2 export rule (`clubExportsKind`): a player leaving his own
/// league goes more often to his own region's. Without it a Czech squad man
/// played in Morocco or Colombia as often as in Austria, and a Jamaican in
/// China: the fourth tier holds no European league at all.
void main() {
  const europe = [
    'eng',
    'esp',
    'ita',
    'ger',
    'fra',
    'por',
    'ned',
    'bel',
    'tur',
    'sco',
    'gre',
    'sui',
    'aut',
    'cze',
    'nor',
    'swe',
    'den',
    'svk',
    'pol',
    'cro',
  ];
  const concacaf = ['usa', 'mex', 'jam', 'crc', 'hon', 'pan', 'can'];

  /// The share of [home]'s exports (players placed abroad) whose league is
  /// in [region], over a spread of ids and levels.
  double regionalShare(
    String home,
    List<String> region, {
    required bool exports,
  }) {
    var abroad = 0;
    var near = 0;
    for (var id = 1; id <= 4000; id++) {
      final level = 55 + id % 30;
      final p = player(
        id: id,
        nationId: 1,
        age: 22 + id % 10,
        attributes: PlayerAttributes(
          physical: level,
          technical: level,
          stamina: level,
        ),
      );
      final c = ClubService.clubForSeed(
        p,
        7,
        homeCode: home,
        strength: true,
        homeRegion: region,
        exports: exports,
      );
      if (c.country == home || c.country.isEmpty) continue;
      abroad++;
      if (region.contains(c.country)) near++;
    }
    expect(abroad, greaterThan(200), reason: 'too few exports to read');
    return near / abroad;
  }

  test('a Czech export goes to a European league far more often', () {
    final before = regionalShare('cze', europe, exports: false);
    final after = regionalShare('cze', europe, exports: true);
    expect(after, greaterThan(0.85));
    expect(after, greaterThan(before + 0.1));
  });

  test('a Jamaican one reaches the American and Mexican leagues', () {
    final before = regionalShare('jam', concacaf, exports: false);
    final after = regionalShare('jam', concacaf, exports: true);
    expect(after, greaterThan(before * 2));
  });

  test('without the rule every club stays where it was', () {
    for (var id = 1; id <= 500; id++) {
      final p = player(id: id, nationId: 1);
      expect(
        ClubService.clubForSeed(
          p,
          7,
          homeCode: 'cze',
          strength: true,
          homeRegion: europe,
        ),
        ClubService.clubForSeed(p, 7, homeCode: 'cze', strength: true),
      );
    }
  });
}
