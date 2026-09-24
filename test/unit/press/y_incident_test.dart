import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

/// The feed can see the pitch.
///
/// Every post the country wrote came off a scoreline, so a side that lost a
/// man in the thirty-fourth minute and then lost the match was reported as
/// having lost a match. A sending-off now reaches the feed as the SAME
/// [PressSubjectIncident] the press room reads, and the cast that already
/// exists says different things about it — which is the whole point of having
/// a cast.
void main() {
  const nation = 'Chile';
  const key = 'red:fx:7:44';
  const incident = PressSubjectIncident(
    type: MatchEventType.redCard,
    minute: 34,
    playerId: 44,
    name: 'Hayes',
  );

  List<YPost> posts(int seed) => YFeed.forIncident(
    incident: incident,
    date: DateTime(2030, 6, 10),
    key: key,
    nation: nation,
    seed: seed,
  );

  /// A save whose former international is [trait], so two dispositions can be
  /// put in front of the same red card. The ex-pros are the voice whose pool
  /// holds both a loyalist and a cynic; every save draws a different one.
  int seedWhereExProIs(YTrait trait) {
    for (var seed = 0; seed < 5000; seed++) {
      if (YFeed.personaFor(YVoice.expro, nation, seed, key).trait == trait) {
        return seed;
      }
    }
    fail('no save in five thousand has a $trait former international');
  }

  test('a red card is posted about by name and minute', () {
    final out = posts(1);
    final report = out.firstWhere((p) => p.template == YTemplate.sentOff);
    expect(report.args, ['Hayes', '34']);
    expect(
      out.where((p) => p.template == YTemplate.sentOff).length,
      2,
      reason: 'the fans and a former international, as with any bad news',
    );
    expect(
      out.any((p) => p.replyTo != null),
      isTrue,
      reason: 'a red card is the sort of thing the room piles onto',
    );
  });

  test('a cynic and a loyalist do not write the same post', () {
    final loyal = posts(seedWhereExProIs(YTrait.loyalist))
        .firstWhere((p) => p.voice == YVoice.expro)
        .variant;
    final cynical = posts(seedWhereExProIs(YTrait.cynic))
        .firstWhere((p) => p.voice == YVoice.expro)
        .variant;
    expect(
      loyal,
      isNot(cynical),
      reason:
          'both accounts reached for the same sentence about the same red '
          'card, which is the feed having a cast and not using it',
    );
    // And they are on the right side of the tone bands: the wordings are
    // written generous-first, sour-last (see [YCast.band]).
    expect(loyal, lessThan(cynical));
  });

  test('a booking is not a sending-off', () {
    expect(
      YFeed.forIncident(
        incident: const PressSubjectIncident(
          type: MatchEventType.yellowCard,
          minute: 34,
          name: 'Hayes',
        ),
        date: DateTime(2030, 6, 10),
        key: key,
        nation: nation,
        seed: 1,
      ),
      isEmpty,
    );
  });

  test('the country does not post about the other side losing a man', () {
    expect(
      YFeed.forIncident(
        incident: const PressSubjectIncident(
          type: MatchEventType.redCard,
          minute: 34,
          name: 'Hayes',
          ours: false,
        ),
        date: DateTime(2030, 6, 10),
        key: key,
        nation: nation,
        seed: 1,
      ),
      isEmpty,
    );
  });

  test('a man nobody can name draws no post at all', () {
    expect(
      YFeed.forIncident(
        incident: const PressSubjectIncident(
          type: MatchEventType.redCard,
          minute: 34,
        ),
        date: DateTime(2030, 6, 10),
        key: key,
        nation: nation,
        seed: 1,
      ),
      isEmpty,
    );
  });

  test('every wording of a sending-off is real words', () {
    // The screen throws on a variant with nothing behind it; this is the
    // arithmetic that decides how many there are.
    expect(YFeed.variantsFor(YTemplate.sentOff), YFeed.midVariantCount);
  });
}
