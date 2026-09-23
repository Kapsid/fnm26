import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/player/prospects.dart';

import '../../helpers/fixtures.dart';

/// The WONDERKID badge, and the few boys who come good late.
///
/// The badge used to be "the scouts gave him four stars", which made it out of
/// scout NOISE: below seventeen the star read is deliberately vague by up to
/// two stars either way, so roughly one intake child in every two and a half
/// wore the word — three a year at seven boys an intake. It now comes from the
/// player's real ceiling, and the numbers below are what "generational" has to
/// mean for the word to be worth anything.
void main() {
  List<Player> seeded(int nation) => [
    for (var i = 0; i < 25; i++)
      player(id: nation * 1000 + i, nationId: nation, age: 18 + i % 15),
  ];

  /// Every eleven-year-old who arrived across [years] intakes in [nations].
  List<Player> intakes({int nations = 40, int years = 11}) => [
    for (var nation = 1; nation <= nations; nation++)
      for (var year = 0; year <= years; year++)
        for (final p in PlayerLifecycle.youthPoolAt(seeded(nation), nation, year))
          if (p.age == PlayerLifecycle.intakeAge) p,
  ];

  test('a wonderkid is one boy every two or three intakes', () {
    final children = intakes();
    final flagged = children
        .where((p) => Prospects.trueStars(p.id, age: p.age) >= 5)
        .length;
    final oneIn = children.length / flagged;

    // At seven boys an intake, one in 14–25 is one every two to three years.
    expect(
      oneIn,
      inInclusiveRange(14, 25),
      reason:
          'one wonderkid in every ${oneIn.toStringAsFixed(1)} intake children '
          '(${flagged} of ${children.length})',
    );
  });

  test('the stars a manager SEES are still the scout\'s guess', () {
    // The badge is honest; the number beside it is not, and must not become
    // so — not knowing is what makes watching a boy come through a decision.
    final children = intakes(nations: 8);
    final disagreements = children
        .where(
          (p) =>
              Prospects.scoutedStars(p.id, age: p.age) !=
              Prospects.trueStars(p.id, age: p.age),
        )
        .length;
    expect(disagreements, greaterThan(children.length ~/ 3));
  });

  group('late bloomers', () {
    test('a few of every intake find something in their late teens', () {
      final children = intakes(nations: 40);
      final late = children.where((p) => PlayerLifecycle.bloomsLate(p.id)).length;
      final share = late / children.length * 100;
      expect(share, inInclusiveRange(1, 8), reason: '$share% bloom late');
    });

    test('nobody comes from nowhere', () {
      // A late bloomer was always at least an ordinary prospect. The uplift
      // turns a good one into a great one; it does not invent a player.
      for (final p in intakes(nations: 12)) {
        if (!PlayerLifecycle.bloomsLate(p.id)) continue;
        expect(
          PlayerLifecycle.basePotential(p.id),
          greaterThanOrEqualTo(PlayerLifecycle.lateBloomFloor),
        );
      }
    });

    test('the bloom is invisible until it happens', () {
      final bloomers = [
        for (final p in intakes(nations: 12))
          if (PlayerLifecycle.bloomsLate(p.id)) p,
      ];
      expect(bloomers, isNotEmpty, reason: 'need somebody to check');
      for (final p in bloomers.take(50)) {
        final atThirteen = PlayerLifecycle.developmentPotential(p.id, age: 13);
        final grown = PlayerLifecycle.developmentPotential(p.id, age: 19);
        expect(atThirteen, PlayerLifecycle.basePotential(p.id));
        expect(grown, greaterThan(atThirteen));
      }
    });

    test('everybody else is exactly who they always were', () {
      for (final p in intakes(nations: 8)) {
        if (PlayerLifecycle.bloomsLate(p.id)) continue;
        expect(
          PlayerLifecycle.developmentPotential(p.id, age: 13),
          PlayerLifecycle.developmentPotential(p.id, age: 25),
        );
      }
    });
  });
}
