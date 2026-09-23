import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/press.dart';

/// The press used to lead with whatever was biggest, every time, with no
/// memory — so a manager on a bad run was asked the same question at
/// conference after conference.
void main() {
  PressQuestion q(String key, PressTopic topic) => (
    key: key,
    topic: topic,
    subjectNationId: null,
    options: Press.optionsFor(topic),
  );

  test('a key round-trips to its topic', () {
    for (final topic in PressTopic.values) {
      expect(
        Press.topicOfKey('${Press.keyPrefixOf(topic)}:whatever:2030'),
        topic,
        reason: '${topic.name} must be recognisable from its stored key',
      );
    }
  });

  test('a grievance in the same table is not mistaken for a question', () {
    expect(Press.topicOfKey('grv:gameTime:17:2030'), isNull);
  });

  test('the press do not lead with what they just asked about', () {
    final candidates = [
      q('pressure:1', PressTopic.underPressure),
      q('defeat:2', PressTopic.heavyDefeat),
      q('exit:3', PressTopic.elimination),
    ];
    // Whatever the draw, it will not be the story they covered last time.
    for (var seed = 0; seed < 30; seed++) {
      final picked = Press.pick(
        candidates,
        recentTopics: const {PressTopic.underPressure},
        seed: seed,
      );
      expect(picked!.topic, isNot(PressTopic.underPressure));
    }
  });

  test('when there is nothing else, they ask again rather than nothing', () {
    final only = [q('pressure:1', PressTopic.underPressure)];
    final picked = Press.pick(
      only,
      recentTopics: const {PressTopic.underPressure},
      seed: 1,
    );
    expect(picked?.topic, PressTopic.underPressure);
  });

  test('consecutive conferences do not ask the same thing', () {
    // Twelve conferences over a run where the same handful of stories stay
    // live. Nothing should be asked twice running.
    final candidates = [
      q('pressure:1', PressTopic.underPressure),
      q('defeat:2', PressTopic.heavyDefeat),
      q('exit:3', PressTopic.elimination),
      q('rout:4', PressTopic.bigWin),
    ];
    final asked = <PressTopic>[];
    for (var i = 0; i < 12; i++) {
      final picked = Press.pick(
        candidates,
        recentTopics: asked.reversed.take(3).toSet(),
        seed: i,
      );
      asked.add(picked!.topic);
    }
    for (var i = 1; i < asked.length; i++) {
      expect(
        asked[i],
        isNot(asked[i - 1]),
        reason: 'conference $i repeated conference ${i - 1}',
      );
    }
    // And over a dozen conferences they got round to more than one story.
    expect(asked.toSet().length, greaterThan(2));
  });

  test('an empty week has no conference', () {
    expect(Press.pick(const [], seed: 3), isNull);
  });
}
