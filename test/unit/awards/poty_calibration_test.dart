import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/awards/award_year.dart';
import 'package:fnm/domain/services/awards/player_of_year.dart';

import '../../helpers/poty_pack.dart';

/// The Player of the Year vote against the world as it actually plays out:
/// simulated world-years from the awards lab (15 worlds, three cycles each),
/// packed in [kPotyPackPath]. Regenerate with
/// `LAB_AWARDS=1,..,15 LAB_CYCLES=3 LAB_OUT=<dir>` and then
/// `LAB_AWARDS_PACK=<dir>` on `test/story/awards_lab_test.dart`.
///
/// The bands are what a fan expects of a Ballon d'Or:
///  * a World Championship year belongs to the champions' best man, and the
///    winner comes from the last four;
///  * in a continental year the continental champions dominate;
///  * a man whose nation won nothing can make the top five, but rarely wins;
///  * keepers and defenders win now and then (about 5 to 20% of years);
///  * a winner's score is about half his own year and a third his trophies.
void main() {
  final years = loadPotyPack();

  ({List<PotyEntry> top, PackedYear y}) vote(PackedYear y) => (
    top: PlayerOfYear.rank(y.awardYear, y.profiles, minApps: y.floor),
    y: y,
  );

  bool isWc(PackedYear y) => y.awardYear.trophies.any(
    (t) => t.family == TrophyFamily.worldChampionship,
  );
  bool isContinental(PackedYear y) =>
      !isWc(y) &&
      y.awardYear.trophies.any((t) => t.family == TrophyFamily.continental);
  // A partial first year (the save starts in July) is not a year.
  final full = [
    for (final y in years)
      if (y.year > 2026) y,
  ];

  test('every year with football has a ceremony: five and three places', () {
    for (final y in full) {
      // A year with no football at all has nothing to vote on.
      if (y.awardYear.lines.isEmpty) continue;
      expect(vote(y).top, hasLength(5), reason: 'seed ${y.seed} ${y.year}');
      // The young award: three places, or every youngster who played
      // three games when a thin year has fewer (the floor stops at three).
      final youngsters = y.profiles.entries
          .where(
            (e) =>
                PlayerOfYear.young(e.value) &&
                (y.awardYear.lines[e.key]?.apps ?? 0) >=
                    PlayerOfYear.floors.last,
          )
          .length;
      expect(
        PlayerOfYear.rank(
          y.awardYear,
          y.profiles,
          eligible: PlayerOfYear.young,
          limit: 3,
        ),
        hasLength(youngsters < 3 ? youngsters : 3),
        reason: 'young, seed ${y.seed} ${y.year}',
      );
    }
  });

  test('the set is big enough to mean something', () {
    expect(full.where(isWc).length, greaterThanOrEqualTo(20));
    expect(full.where(isContinental).length, greaterThanOrEqualTo(20));
  });

  test('a World Championship year belongs to the World Champions', () {
    var championInTop5 = 0;
    var winnerFromLastFour = 0;
    final wc = full.where(isWc).toList();
    for (final y in wc) {
      final t = y.awardYear.trophies.firstWhere(
        (t) => t.family == TrophyFamily.worldChampionship,
      );
      final all = PlayerOfYear.rank(
        y.awardYear,
        y.profiles,
        limit: 1 << 20,
        minApps: y.floor,
      );
      final top = all.take(5).toList();
      final champBest = all.firstWhere((e) => e.nationId == t.champion);
      if (top.contains(champBest)) championInTop5++;
      if (t.placeOf(top.first.nationId) != null) winnerFromLastFour++;
    }
    expect(championInTop5 / wc.length, greaterThanOrEqualTo(0.7));
    expect(winnerFromLastFour / wc.length, greaterThanOrEqualTo(0.6));
  });

  test('in a continental year the continental champions dominate', () {
    final cont = full.where(isContinental).toList();
    var winnerChampion = 0;
    for (final y in cont) {
      final top = vote(y).top;
      final champions = {
        for (final t in y.awardYear.trophies)
          if (t.family == TrophyFamily.continental) t.champion,
      };
      if (champions.contains(top.first.nationId)) winnerChampion++;
    }
    expect(winnerChampion / cont.length, greaterThanOrEqualTo(0.6));
  });

  test('a nation that won nothing can reach the top five, rarely the top', () {
    final big = full.where((y) => isWc(y) || isContinental(y)).toList();
    var inTop5 = 0;
    var wins = 0;
    for (final y in big) {
      final top = vote(y).top;
      if (top.any((e) => e.team == 0)) inTop5++;
      if (top.first.team == 0) wins++;
    }
    expect(inTop5 / big.length, greaterThanOrEqualTo(0.05));
    expect(wins / big.length, lessThanOrEqualTo(0.1));
  });

  test('keepers and defenders win sometimes, and are never shut out', () {
    var backWins = 0;
    var backInTop5 = 0;
    for (final y in full) {
      final top = vote(y).top;
      if (top.isEmpty) continue;
      bool back(PotyEntry e) =>
          e.category == PositionCategory.goalkeeper ||
          e.category == PositionCategory.defender;
      if (back(top.first)) backWins++;
      backInTop5 += top.where(back).length;
    }
    // Measured 22 of 164 voted years (13.4%), the middle of the 10-15% the
    // owner asked for; the band leaves headroom for a repack.
    expect(backWins / full.length, inInclusiveRange(0.08, 0.18));
    expect(backInTop5, greaterThan(full.length ~/ 2));
  });

  test("a winner's score is about half his year and a third his trophies", () {
    final big = full.where((y) => isWc(y) || isContinental(y)).toList();
    var individual = 0.0;
    var team = 0.0;
    for (final y in big) {
      final w = vote(y).top.first;
      individual += w.individual / w.total;
      team += w.team / w.total;
    }
    expect(individual / big.length, inInclusiveRange(0.45, 0.65));
    expect(team / big.length, inInclusiveRange(0.25, 0.42));
  });

  test('the vote is deterministic', () {
    for (final y in full.take(10)) {
      final a = vote(y).top.map((e) => e.playerId).toList();
      final reversed = Map.fromEntries(y.profiles.entries.toList().reversed);
      final b = PlayerOfYear.rank(
        y.awardYear,
        reversed,
        minApps: y.floor,
      ).map((e) => e.playerId).toList();
      expect(b, a);
    }
  });
}
