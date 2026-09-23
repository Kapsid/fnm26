import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/player/player_aging.dart';

import '../../helpers/fixtures.dart';

Player at(int overall, {int id = 5001, int age = 26}) => player(
  id: id,
  nationId: 7,
  position: PlayerPosition.cm,
  age: age,
  attributes: flatAttributes(overall),
);

/// The share (%) of a notional squad rated around [overall] that ends up at a
/// club in [code]'s own country.
///
/// Measured across several SAVE SEEDS, not one. A single seed's 240 players
/// carry about three points of sampling noise, which is the same size as the
/// gaps these tests assert — so a thresholds-by-a-point assertion passed or
/// failed on the draw rather than on the model, and re-tuning the threshold
/// when it flipped would have been fitting the test to the noise.
int domesticShare(String code, int overall) {
  var home = 0;
  var total = 0;
  const seeds = [3, 17, 31, 64, 99, 512, 1234, 5678];
  for (final seed in seeds) {
    for (var i = 0; i < 240; i++) {
      final c = ClubService.clubForSeed(
        at(overall, id: 4000 + i * 7),
        seed,
        homeCode: code,
        homeCities: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
      );
      if (c.country == code) home++;
      total++;
    }
  }
  return (100 * home / total).round();
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

  group('the transfer clock', () {
    /// Walks a whole career one season at a time and reports how many clubs it
    /// passed through, and in what share of its seasons the club changed.
    ({double clubs, double movedPercent}) career(String code) {
      var moves = 0, years = 0;
      var totalClubs = 0, careers = 0;
      for (var i = 0; i < 240; i++) {
        final base = player(
          id: 5000 + i * 3,
          nationId: 7,
          position: PlayerPosition.cm,
          age: 17,
          attributes: flatAttributes(52 + (i * 11) % 30),
        );
        final seen = <String>{};
        String? previous;
        for (var year = 0; year <= 19; year++) {
          final aged = PlayerAging.agedYears(base, year);
          final c = ClubService.clubForSeed(
            aged,
            77,
            homeCode: code,
            homeCities: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
          );
          final key = '${c.name}|${c.country}';
          seen.add(key);
          if (previous != null) {
            years++;
            if (key != previous) moves++;
          }
          previous = key;
        }
        totalClubs += seen.length;
        careers++;
      }
      return (
        clubs: totalClubs / careers,
        movedPercent: 100 * moves / years,
      );
    }

    test('a career is a handful of clubs, not one a season', () {
      // The whole point of [ClubService.contractAt]. Reading the club off the
      // live overall meant a developing teenager crossed a standing band most
      // years and an aging veteran crossed one on the way back down, so the
      // history card said "transferred" in four seasons out of five and a
      // twenty-year career came out as nine clubs. Nobody's does.
      for (final code in ['eng', 'bra', 'cze', 'mex', 'zzz']) {
        final c = career(code);
        expect(
          c.clubs,
          inInclusiveRange(3, 6.5),
          reason: '$code: ${c.clubs} clubs in a twenty-season career',
        );
        expect(
          c.movedPercent,
          lessThan(35),
          reason: '$code moved in ${c.movedPercent}% of seasons',
        );
      }
    });

    test('a contract runs for years, and is often signed again', () {
      // Every deal is two to four seasons and half of them are renewed, so a
      // player is on his fourth or fifth CLUB, not his fifteenth, by the end.
      final spans = <int>[];
      for (var i = 0; i < 400; i++) {
        final id = 9000 + i * 13;
        var previous = ClubService.contractAt(id, 17).since;
        for (var age = 18; age <= 36; age++) {
          final since = ClubService.contractAt(id, age).since;
          if (since != previous) {
            spans.add(since - previous);
            previous = since;
          }
        }
      }
      expect(spans, isNotEmpty);
      final mean = spans.reduce((a, b) => a + b) / spans.length;
      expect(mean, inInclusiveRange(2.0, 4.0));
      // A deal is never open-ended, and never a single season by design (only
      // the rare early exit is).
      expect(spans.every((s) => s >= 1 && s <= 4), isTrue);
    });

    test('a running deal holds a player where an expiring one moves him', () {
      // The bug this whole clock exists for. A club used to be read off the
      // LIVE overall in five-point bands, and a developing player crosses a
      // band every couple of seasons — so the history card said "transferred"
      // in four seasons out of five, at every age. A move now belongs to the
      // end of a contract: a season in the middle of one moves a player far
      // less often than the season his deal runs out.
      var midMoves = 0, midSeasons = 0;
      var endMoves = 0, endSeasons = 0;
      for (var i = 0; i < 300; i++) {
        final base = player(
          id: 3100 + i * 7,
          nationId: 7,
          position: PlayerPosition.cm,
          age: 17,
          attributes: flatAttributes(50 + (i * 13) % 32),
        );
        ClubSide clubOf(Player p) => ClubService.clubForSeed(
          p,
          5,
          homeCode: 'cze',
          homeCities: const ['Alpha', 'Beta'],
        );
        for (var year = 1; year <= 18; year++) {
          final before = PlayerAging.agedYears(base, year - 1);
          final after = PlayerAging.agedYears(base, year);
          final expired =
              ClubService.contractAt(base.id, before.age).index !=
              ClubService.contractAt(base.id, after.age).index;
          final moved = clubOf(before) != clubOf(after);
          if (expired) {
            endSeasons++;
            if (moved) endMoves++;
          } else {
            midSeasons++;
            if (moved) midMoves++;
          }
        }
      }
      expect(midSeasons, greaterThan(1000));
      expect(endSeasons, greaterThan(200));
      final mid = 100 * midMoves / midSeasons;
      final end = 100 * endMoves / endSeasons;
      expect(end, greaterThan(80), reason: 'an expiry should be a move');
      expect(
        mid,
        lessThan(15),
        reason: 'mid-contract seasons moved $mid% of the time',
      );
      expect(end, greaterThan(mid * 4));
    });
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
