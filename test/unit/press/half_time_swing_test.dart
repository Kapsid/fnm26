import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/half_time_swing.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

/// The afternoon the second half turned over.
///
/// Two goals down at the break and it finished level or won; two goals up at
/// the break and it finished level or lost. A fixture row cannot tell either
/// story — it keeps the final score and nothing about the road to it — so both
/// are read off the goal timeline, by one definition that the feed shares.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// One goal, as the timeline hands it over.
  ({int nationId, int playerId, int minute}) goal(int nationId, int minute) =>
      (nationId: nationId, playerId: 1, minute: minute);

  group('what counts as a swing', () {
    test('two down at the break and drawn is a comeback', () {
      expect(
        halfTimeSwingOf(
          goals: [goal(2, 10), goal(2, 30), goal(1, 55), goal(1, 70)],
          nationId: 1,
          scored: 2,
          conceded: 2,
        ),
        HalfTimeSwing.comeback,
      );
    });

    test('two up at the break and beaten is a collapse', () {
      expect(
        halfTimeSwingOf(
          goals: [
            goal(1, 10),
            goal(1, 30),
            goal(2, 55),
            goal(2, 70),
            goal(2, 80),
          ],
          nationId: 1,
          scored: 2,
          conceded: 3,
        ),
        HalfTimeSwing.collapse,
      );
    });

    test('one goal either way is an afternoon, not a story', () {
      expect(
        halfTimeSwingOf(
          goals: [goal(2, 30), goal(1, 70)],
          nationId: 1,
          scored: 1,
          conceded: 1,
        ),
        isNull,
      );
    });

    test('two down at the break and still beaten is just a defeat', () {
      expect(
        halfTimeSwingOf(
          goals: [goal(2, 10), goal(2, 30), goal(1, 70)],
          nationId: 1,
          scored: 1,
          conceded: 2,
        ),
        isNull,
      );
    });

    test('a two-goal lead built AFTER the break is not a half-time lead', () {
      expect(
        halfTimeSwingOf(
          goals: [goal(1, 50), goal(1, 60), goal(2, 75), goal(2, 85)],
          nationId: 1,
          scored: 2,
          conceded: 2,
        ),
        isNull,
        reason: 'nothing had been thrown away at the interval',
      );
    });

    test('a goal on the stroke of half time is a first-half goal', () {
      expect(
        halfTimeSwingOf(
          goals: [
            goal(2, 20),
            goal(2, halfTimeMinute),
            goal(1, 60),
            goal(1, 80),
          ],
          nationId: 1,
          scored: 2,
          conceded: 2,
        ),
        HalfTimeSwing.comeback,
      );
    });
  });

  group('the feed', () {
    const nation = 'Chile';
    const key = 'swing:fx:7';

    List<YPost> posts(HalfTimeSwing swing, int seed) => YFeed.forSwing(
      swing: swing,
      opponent: 'Peru',
      date: DateTime(2030, 6, 10),
      key: key,
      nation: nation,
      seed: seed,
    );

    /// A save whose former international is [trait], so two dispositions can
    /// be put in front of the same turnaround. The ex-pros are the voice whose
    /// pool holds both a loyalist and a cynic.
    int seedWhereExProIs(YTrait trait) {
      for (var seed = 0; seed < 5000; seed++) {
        if (YFeed.personaFor(YVoice.expro, nation, seed, key).trait == trait) {
          return seed;
        }
      }
      fail('no save in five thousand has a $trait former international');
    }

    test('a comeback and a collapse are different posts', () {
      expect(
        posts(
          HalfTimeSwing.comeback,
          1,
        ).map((p) => p.template).contains(YTemplate.turnedItRound),
        isTrue,
      );
      expect(
        posts(
          HalfTimeSwing.collapse,
          1,
        ).map((p) => p.template).contains(YTemplate.threwItAway),
        isTrue,
      );
    });

    test('the post names the side it happened against', () {
      final report = posts(HalfTimeSwing.comeback, 1).firstWhere(
        (p) => p.template == YTemplate.turnedItRound,
      );
      expect(report.args, ['Peru']);
    });

    test('the room piles in, as it does on any turnaround', () {
      expect(
        posts(HalfTimeSwing.comeback, 1).any((p) => p.replyTo != null),
        isTrue,
      );
    });

    test('a cynic and a loyalist do not tell the same joke', () {
      final loyal = posts(
        HalfTimeSwing.comeback,
        seedWhereExProIs(YTrait.loyalist),
      ).firstWhere((p) => p.voice == YVoice.expro).variant;
      final cynical = posts(
        HalfTimeSwing.comeback,
        seedWhereExProIs(YTrait.cynic),
      ).firstWhere((p) => p.voice == YVoice.expro).variant;
      expect(
        loyal,
        isNot(cynical),
        reason:
            'both accounts reached for the same sentence about the same '
            'afternoon, which is the feed having a cast and not using it',
      );
      // The wordings are written generous-first, sour-last (see YCast.band).
      expect(loyal, lessThan(cynical));
    });

    test('there are enough wordings for a band each', () {
      // Four would give one generous wording, one neutral and two sour, which
      // is too thin for a joke a loyalist and a cynic have to tell differently.
      expect(
        YFeed.variantsFor(YTemplate.turnedItRound),
        YFeed.subjectVariantCount,
      );
      expect(
        YFeed.variantsFor(YTemplate.threwItAway),
        YFeed.subjectVariantCount,
      );
    });
  });
}
