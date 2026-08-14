import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/club/clubs.dart';

import '../../helpers/fixtures.dart';

Player at(int overall, {int id = 5001, int age = 26}) => player(
  id: id,
  nationId: 7,
  position: PlayerPosition.cm,
  age: age,
  attributes: flatAttributes(overall),
);

/// The share (%) of a notional 24-player squad rated around [overall] that ends
/// up at a club in [code]'s own country.
int domesticShare(String code, int overall) {
  var home = 0;
  const n = 240;
  for (var i = 0; i < n; i++) {
    final c = ClubService.clubForSeed(
      at(overall, id: 4000 + i * 7),
      31,
      homeCode: code,
      homeCities: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
    );
    if (c.country == code) home++;
  }
  return (100 * home / n).round();
}

void main() {
  test('a club is stable while a player is', () {
    final a = ClubService.clubForSeed(at(70), 99, homeCode: 'cze');
    final b = ClubService.clubForSeed(at(70), 99, homeCode: 'cze');
    expect(a.name, b.name);
    expect(a.country, b.country);
  });

  test('a player who steps up earns a move, even below the league tiers', () {
    // The whole point of the standing band: two players in the SAME league tier
    // (5, everything under 66) must still be able to change club, or a nation
    // whose pool never reaches 66 has an empty transfer window for ever.
    expect(ClubService.tierForOverall(52), ClubService.tierForOverall(60));
    final moves = <String>{};
    for (var overall = 48; overall <= 64; overall += 4) {
      moves.add(
        ClubService.clubForSeed(
          at(overall),
          99,
          homeCode: 'zzz', // no curated league, no cities → placed abroad
        ).name,
      );
    }
    expect(moves.length, greaterThan(1));
  });

  test('a point of aging noise does not move anyone', () {
    final before = ClubService.clubForSeed(at(72), 4, homeCode: 'zzz');
    final after = ClubService.clubForSeed(at(73), 4, homeCode: 'zzz');
    expect(after.name, before.name);
  });

  test('standing bands span five rating points', () {
    // The band width is what decides how busy a transfer window looks: a player
    // gains about a point a year, so a five-point band means roughly a fifth of
    // a squad moves club in a season. Narrower, and the news saturates at its
    // three-headline cap every single year.
    expect(ClubService.standingBandWidth, 5);
    expect(ClubService.standingBand(70), ClubService.standingBand(74));
    expect(ClubService.standingBand(74), isNot(ClubService.standingBand(75)));
  });

  group('home retention', () {
    test('every listed country is a real nation code', () {
      // A typo here fails silently — the country just drops to the fallback
      // curve — so the table is checked against the seed data.
      final nations =
          jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<Object?>;
      final codes = {
        for (final n in nations.cast<Map<String, Object?>>())
          (n['code']! as String).toLowerCase(),
      };
      final unknown = ClubService.homeRetention.keys
          .where((c) => !codes.contains(c))
          .toList();
      expect(unknown, isEmpty, reason: 'not FIFA codes in the seed data');
    });

    test('a league that exports is not confused with a weak one', () {
      // The case that gave the whole model away: France is a top-tier league
      // whose internationals nearly all play abroad, while England's nearly all
      // play at home. No league-strength ordering can produce both, so the
      // shares are data.
      expect(domesticShare('eng', 86), greaterThan(75));
      expect(domesticShare('fra', 86), lessThan(35));
    });

    test('a mid-standard league with money keeps its players', () {
      // Mexico, Saudi Arabia and China are nobody's idea of elite football and
      // keep almost everyone; the old tier maths sent them all abroad.
      expect(domesticShare('mex', 80), greaterThan(60));
      expect(domesticShare('ksa', 78), greaterThan(85));
      expect(domesticShare('chn', 72), greaterThan(85));
    });

    test('a talent factory exports even from a modest pool', () {
      expect(domesticShare('sen', 82), lessThan(15));
      expect(domesticShare('cro', 84), lessThan(15));
    });

    test('the very best of a country leave more often than its squad men', () {
      expect(domesticShare('por', 90), lessThan(domesticShare('por', 74)));
    });

    test('an unlisted minnow keeps its players; an unlisted star leaves', () {
      // The fallback curve, for the two hundred nations with no measured share.
      expect(domesticShare('zzz', 48), greaterThan(80));
      expect(domesticShare('zzz', 88), lessThan(30));
    });

    test('an export lands mostly in the big leagues, not at its own level', () {
      // A 74-rated international is far more often a big-five squad man than
      // the best player at a tier-three club — matching destination to the
      // player's own tier left nine tenths of such a squad outside the big
      // five.
      const big5 = {'eng', 'esp', 'ita', 'ger', 'fra'};
      var abroad = 0;
      var inBig5 = 0;
      // A real pool, not one rating: a squad runs from its stars down to its
      // fringe, and it is the middle of it the old model misplaced.
      for (var i = 0; i < 240; i++) {
        final c = ClubService.clubForSeed(
          at(72 + i % 17, id: 9000 + i * 13),
          77,
          homeCode: 'sen',
        );
        if (c.country == 'sen') continue;
        abroad++;
        if (big5.contains(c.country)) inBig5++;
      }
      expect(abroad, greaterThan(180), reason: 'Senegal exports its squad');
      expect(100 * inBig5 / abroad, greaterThan(40));
    });
  });

  group('boys are at their home clubs', () {
    /// The share (%) of a notional squad of [age]-year-olds rated [overall]
    /// who end up at a club in their own country.
    int youngDomesticShare(String code, int overall, int age) {
      var home = 0;
      const n = 300;
      for (var i = 0; i < n; i++) {
        final club = ClubService.clubForSeed(
          at(overall, id: 7000 + i * 11, age: age),
          99,
          homeCode: code,
          homeCities: const ['Alpha', 'Beta', 'Gamma'],
        );
        if (club.country == code) home++;
      }
      return (home / n * 100).round();
    }

    test('an under-17 is nearly always at home', () {
      // A fifteen-year-old moving abroad is the exception that gets written
      // about, not the norm the rating curve would otherwise produce for a
      // talented kid from a small country.
      for (final code in ['eng', 'cze', 'bra']) {
        expect(
          youngDomesticShare(code, 62, 15),
          greaterThan(85),
          reason: '$code lets its fifteen-year-olds go too easily',
        );
      }
    });

    test('but a few do go abroad', () {
      // "Rare", not "never" — the wonderkid picked up by a giant is real.
      var anyAbroad = false;
      for (final code in ['cze', 'bra', 'nor']) {
        if (youngDomesticShare(code, 62, 15) < 100) anyAbroad = true;
      }
      expect(anyAbroad, isTrue);
    });

    test('the door opens as he grows up', () {
      // Home share falls with age rather than dropping off a cliff.
      final fifteen = youngDomesticShare('cze', 70, 15);
      final eighteen = youngDomesticShare('cze', 70, 18);
      final grown = youngDomesticShare('cze', 70, 24);
      expect(eighteen, lessThanOrEqualTo(fifteen));
      expect(grown, lessThan(fifteen));
    });
  });
}
