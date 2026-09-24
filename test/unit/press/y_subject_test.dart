import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

/// The feed can see the squad.
///
/// Batch 1 gave the country a red card to talk about. It still could not see
/// who had been picked: a boy handed a first cap, a forward who had stopped
/// scoring and the neighbours next week all passed without a word, because
/// every shape on the feed was assembled from a scoreline.
///
/// The test that matters is not that a post exists. It is that a nostalgic and
/// a hypeman write DIFFERENT posts about the same debutant, through the cast
/// and the tone bands that were already there.
void main() {
  const nation = 'Chile';
  final date = DateTime(2030, 6, 10);
  const key = 'debutant:44:18';
  const debutant = PressSubjectPlayer(
    playerId: 44,
    name: 'Lindqvist',
    count: 18,
  );

  /// The same first cap, in a country that has just had a creditable week.
  ///
  /// The run matters: a stance is a baseline MOVED by results, and two traits
  /// only sound different in a country with something to have an opinion
  /// about. This is what [yFeedProvider] hands in — the standings up to the
  /// post's own date.
  List<YPost> debut(int seed) => YFeed.forPlayer(
    topic: PressTopic.debutant,
    subject: debutant,
    date: date,
    key: key,
    nation: nation,
    seed: seed,
    history: const [ResultStanding.creditable],
  );

  /// A save whose fan account is [trait], so two dispositions can be put in
  /// front of the same first cap.
  int seedWhereFanIs(YTrait trait) {
    for (var seed = 0; seed < 5000; seed++) {
      if (YFeed.personaFor(YVoice.fan, nation, seed, key).trait == trait) {
        return seed;
      }
    }
    fail('no save in five thousand has a $trait supporter');
  }

  test('a first cap is posted about by name', () {
    final out = debut(1);
    final report = out.firstWhere((p) => p.template == YTemplate.debut);
    expect(report.args, ['Lindqvist']);
    expect(
      out.where((p) => p.template == YTemplate.debut).length,
      2,
      reason: 'the fans and a former international, as with any squad news',
    );
    expect(
      out.any((p) => p.replyTo != null),
      isTrue,
      reason: 'a debut is exactly the sort of thing the room argues about',
    );
  });

  test('a nostalgic and a hypeman do not write the same post', () {
    final hyped = debut(
      seedWhereFanIs(YTrait.hypeman),
    ).firstWhere((p) => p.voice == YVoice.fan).variant;
    final wistful = debut(
      seedWhereFanIs(YTrait.nostalgic),
    ).firstWhere((p) => p.voice == YVoice.fan).variant;
    expect(
      hyped,
      isNot(wistful),
      reason:
          'both accounts reached for the same sentence about the same boy, '
          'which is the feed having a cast and not using it',
    );
    // Generous wordings are written first and sour ones last — see
    // [YCast.band] — and a hypeman is the warmer of the two.
    expect(hyped, lessThan(wistful));
  });

  test('a drought is posted about with the number attached', () {
    final out = YFeed.forPlayer(
      topic: PressTopic.strikerDrought,
      subject: const PressSubjectPlayer(
        playerId: 7,
        name: 'Molina',
        count: 9,
      ),
      date: date,
      key: 'strikerDrought:7:9',
      nation: nation,
      seed: 3,
    );
    final report = out.firstWhere((p) => p.template == YTemplate.drought);
    expect(report.args, ['Molina', '9']);
  });

  test('the arguments a room has are left to the room', () {
    // A dropped star and a captain out of form are questions somebody has to
    // ANSWER. The feed having an opinion about them without one would be the
    // country arguing with itself.
    for (final topic in const [
      PressTopic.droppedStar,
      PressTopic.captaincyQuestion,
      PressTopic.veteranEnd,
      PressTopic.youngsterBreakthrough,
    ]) {
      expect(
        YFeed.forPlayer(
          topic: topic,
          subject: debutant,
          date: date,
          key: key,
          nation: nation,
          seed: 1,
        ),
        isEmpty,
        reason: '${topic.name} should be a press question, not a post',
      );
    }
  });

  test('a rivalry coming up is posted about by name and number', () {
    final out = YFeed.forOpponent(
      topic: PressTopic.rivalryNext,
      subject: const PressSubjectOpponent(9, count: 6),
      opponent: 'Peru',
      date: date,
      key: 'rivalryNext:9:6',
      nation: nation,
      seed: 5,
    );
    final report = out.firstWhere((p) => p.template == YTemplate.rivalryLooms);
    expect(report.args, ['Peru', '6']);
    expect(
      out.map((p) => p.voice),
      contains(YVoice.rival),
      reason: 'the neighbours have an account too',
    );
  });

  test('a head-to-head record is not a post', () {
    for (final topic in const [
      PressTopic.headToHeadRun,
      PressTopic.revengeMatch,
    ]) {
      expect(
        YFeed.forOpponent(
          topic: topic,
          subject: const PressSubjectOpponent(9, count: 6),
          opponent: 'Peru',
          date: date,
          key: 'x:9:6',
          nation: nation,
          seed: 5,
        ),
        isEmpty,
      );
    }
  });

  test('every new template has as many wordings as the screen expects', () {
    // The screen throws on a variant with nothing behind it, and the bands
    // need three clean thirds — see [YFeed.subjectVariantCount].
    for (final t in const [
      YTemplate.debut,
      YTemplate.drought,
      YTemplate.rivalryLooms,
    ]) {
      expect(YFeed.variantsFor(t), YFeed.subjectVariantCount);
    }
    expect(YFeed.subjectVariantCount % 3, 0);
  });
}
