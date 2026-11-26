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
    final loyal = posts(
      seedWhereExProIs(YTrait.loyalist),
    ).firstWhere((p) => p.voice == YVoice.expro).variant;
    final cynical = posts(
      seedWhereExProIs(YTrait.cynic),
    ).firstWhere((p) => p.voice == YVoice.expro).variant;
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

  group('a second red in the same match (owner, 1.1.4)', () {
    List<YPost> red(int minute, String name, int menLeft) => YFeed.forIncident(
      incident: PressSubjectIncident(
        type: MatchEventType.redCard,
        minute: minute,
        playerId: minute,
        name: name,
        menLeft: menLeft,
      ),
      date: DateTime(2030, 6, 10),
      key: 'red:fx:7:$minute',
      nation: nation,
      seed: 1,
    );

    test('the first red reads as a first red, the second says nine', () {
      final first = red(34, 'Hayes', 10);
      final second = red(71, 'Morrow', 9);
      final firstReports = first.where((p) => p.replyTo == null).toList();
      final secondReports = second.where((p) => p.replyTo == null).toList();
      expect(
        firstReports.map((p) => p.template).toSet(),
        {YTemplate.sentOff},
      );
      expect(
        secondReports.map((p) => p.template).toSet(),
        {YTemplate.sentOffAgain},
        reason: 'a side already down to ten was told it had ten men again',
      );
      for (final p in secondReports) {
        expect(p.args, ['Morrow', '71', '9']);
        expect(p.variant, lessThan(YFeed.variantsFor(YTemplate.sentOffAgain)));
      }
      expect(
        second.any((p) => p.replyTo != null && p.mood == YMood.fury),
        isTrue,
      );
    });

    test('a third red counts down again', () {
      final third = red(80, 'Pike', 8).where((p) => p.replyTo == null);
      expect(third.every((p) => p.template == YTemplate.sentOffAgain), isTrue);
      expect(third.first.args.last, '8');
    });

    test('a single red is exactly what it was before', () {
      // menLeft defaults to ten, so the posts must be identical to the ones
      // an incident without it draws.
      String sig(List<YPost> ps) => [
        for (final p in ps)
          '${p.voice}|${p.template}|${p.variant}|${p.args}|${p.mood}',
      ].join(';');
      for (final seed in [1, 7, 42]) {
        final before = YFeed.forIncident(
          incident: incident,
          date: DateTime(2030, 6, 10),
          key: key,
          nation: nation,
          seed: seed,
        );
        final explicit = YFeed.forIncident(
          incident: const PressSubjectIncident(
            type: MatchEventType.redCard,
            minute: 34,
            playerId: 44,
            name: 'Hayes',
            menLeft: 10,
          ),
          date: DateTime(2030, 6, 10),
          key: key,
          nation: nation,
          seed: seed,
        );
        expect(sig(explicit), sig(before));
        expect(
          before
              .where((p) => p.replyTo == null)
              .every((p) => p.template == YTemplate.sentOff),
          isTrue,
        );
        expect(before.first.args, ['Hayes', '34']);
      }
    });
  });

  test('every wording of a sending-off is real words', () {
    // The screen throws on a variant with nothing behind it; this is the
    // arithmetic that decides how many there are.
    expect(YFeed.variantsFor(YTemplate.sentOff), YFeed.midVariantCount);
    expect(YFeed.variantsFor(YTemplate.sentOffAgain), YFeed.variantCount);
  });
}
