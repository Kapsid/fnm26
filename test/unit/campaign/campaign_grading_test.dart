import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/campaign/campaign_grading.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';

/// The star rules: a finish ordinal against the campaign's thresholds, and the
/// rivalry's three rule-based stars.
void main() {
  test('starsForFinish counts the thresholds met', () {
    const t = [2, 3, 4];
    expect(starsForFinish(0, t), 0);
    expect(starsForFinish(2, t), 1);
    expect(starsForFinish(3, t), 2);
    expect(starsForFinish(4, t), 3);
    expect(starsForFinish(7, t), 3);
  });

  test('the transplant: qualify, the knockouts, then only the title', () {
    final t = Campaigns.transplant.starThresholds;
    expect(starsForFinish(0, t), 0);
    expect(starsForFinish(2, t), 1);
    expect(starsForFinish(3, t), 2);
    expect(starsForFinish(4, t), 2); // a quarter-final no longer earns it
    expect(starsForFinish(6, t), 2); // nor does losing the final
    expect(starsForFinish(7, t), 3);
  });

  test(
    'grudgeStars: nothing below the rival, then qualify, then both wins',
    () {
      expect(grudgeStars(aboveRival: false, qualified: true, wonBoth: true), 0);
      expect(grudgeStars(aboveRival: true, qualified: false, wonBoth: true), 1);
      expect(grudgeStars(aboveRival: true, qualified: true, wonBoth: false), 2);
      expect(grudgeStars(aboveRival: true, qualified: true, wonBoth: true), 3);
    },
  );

  test('beatRivalsStars: both rivals beaten first, then qualify, then the '
      'quarter-final', () {
    expect(beatRivalsStars(beatAll: false, bestOrdinal: 7), 0);
    expect(beatRivalsStars(beatAll: true, bestOrdinal: 0), 1);
    expect(beatRivalsStars(beatAll: true, bestOrdinal: 2), 2);
    expect(beatRivalsStars(beatAll: true, bestOrdinal: 3), 2);
    expect(beatRivalsStars(beatAll: true, bestOrdinal: 4), 3);
    expect(beatRivalsStars(beatAll: true, bestOrdinal: 7), 3);
  });

  test('worldThenTitlesStars: the highest tier reached', () {
    int stars({bool q = false, bool euro = false, bool world = false}) =>
        worldThenTitlesStars(
          qualifiedWorld: q,
          wonContinental: euro,
          wonWorld: world,
        );
    expect(stars(), 0);
    expect(stars(q: true), 1);
    expect(stars(q: true, euro: true), 2);
    // The tiers stand alone: a European title without a World Championship
    // place is still two, a world title is three whatever else happened.
    expect(stars(euro: true), 2);
    expect(stars(q: true, world: true), 3);
    expect(stars(q: true, euro: true, world: true), 3);
  });

  test('Young Finns: Finland, three cycles, Pro, cannot be continued, its '
      'own golden generation', () {
    const def = Campaigns.youngFinns;
    expect(def.nationId, 17);
    expect(def.cycles, 3);
    expect(def.needsPro, isTrue);
    expect(def.canContinue, isFalse);
    expect(def.goldenGeneration, isTrue);
    expect(def.goal, CampaignGoal.qualifyWorldThenTitles);
    expect(def.difficulty, CampaignDifficulty.medium);
    expect(Campaigns.all, contains(def));
    expect(Campaigns.byId('youngFinns'), def);
    // Only this campaign rebuilds a pool.
    expect(
      [
        for (final c in Campaigns.all)
          if (c.goldenGeneration) c.id,
      ],
      ['youngFinns'],
    );
  });

  test('qualifyBothThenTitleStars: the highest tier reached', () {
    for (final euro in [false, true]) {
      for (final world in [false, true]) {
        for (final title in [false, true]) {
          expect(
            qualifyBothThenTitleStars(
              qualifiedContinental: euro,
              qualifiedWorld: world,
              wonTitle: title,
            ),
            title
                ? 3
                : world
                ? 2
                : euro
                ? 1
                : 0,
            reason: 'euro $euro world $world title $title',
          );
        }
      }
    }
  });

  test('A Greenland Century: Pro, 25 cycles, can be continued, its dormant '
      'world', () {
    const def = Campaigns.greenland;
    expect(def.nationId, 212);
    expect(def.dormantNationId, 212);
    expect(def.cycles, 25);
    expect(def.needsPro, isTrue);
    expect(def.canContinue, isTrue);
    expect(def.friendlyNationId, isNull);
    expect(def.goal, CampaignGoal.qualifyBothThenTitle);
    expect(def.difficulty, CampaignDifficulty.hard);
    expect(Campaigns.all.last, def);
    expect(Campaigns.byId('greenland'), def);
    expect(
      [
        for (final c in Campaigns.all)
          if (c.dormantNationId != null) c.id,
      ],
      ['greenland'],
    );
  });
}
