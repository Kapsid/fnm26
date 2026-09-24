import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/press/press.dart';

/// What a conference LEADS with.
///
/// Batch 1 stated the ladder and could only populate its ends: an incident, or
/// the team. With a named man and the next opponent on it, the whole thing is
/// worth pinning — the generic team question is the filler it should always
/// have been, and a question about a man beats one about a fixture next month.
void main() {
  PressQuestion q(PressTopic topic, PressSubject subject) => (
    key: '${Press.keyPrefixOf(topic)}:1',
    topic: topic,
    subject: subject,
    subjectNationId: null,
    options: Press.optionsFor(topic),
  );

  const incident = PressSubjectIncident(
    type: MatchEventType.redCard,
    minute: 34,
    name: 'Hayes',
  );
  const stale = PressSubjectIncident(
    type: MatchEventType.redCard,
    minute: 34,
    name: 'Hayes',
    fromLastMatch: false,
  );
  const player = PressSubjectPlayer(playerId: 7, name: 'Molina', count: 8);
  const opponent = PressSubjectOpponent(9, count: 5);
  const team = PressSubjectTeam();

  test('the four rungs are in the order the spec states', () {
    expect(Press.precedenceOf(incident), lessThan(Press.precedenceOf(player)));
    expect(Press.precedenceOf(player), lessThan(Press.precedenceOf(opponent)));
    expect(Press.precedenceOf(opponent), lessThan(Press.precedenceOf(team)));
  });

  test('an incident from an older match no longer leads', () {
    // It leads because it is the last thing that happened. Once it is not, a
    // named man is the more current story.
    expect(
      Press.precedenceOf(stale),
      greaterThan(Press.precedenceOf(player)),
      reason: 'a red card from a fortnight ago is not the news',
    );
  });

  group('the room leads with the most specific subject present', () {
    /// Every candidate on the card, in the least helpful order: the generic
    /// team question first, so a selector that simply took the head of the
    /// list would fail.
    List<PressQuestion> card(List<(PressTopic, PressSubject)> rest) => [
      q(PressTopic.underPressure, team),
      for (final (topic, subject) in rest) q(topic, subject),
    ];

    void expectLeads(List<PressQuestion> candidates, PressTopic topic) {
      for (var seed = 0; seed < 40; seed++) {
        expect(
          Press.pick(candidates, seed: seed)?.topic,
          topic,
          reason: 'seed $seed led with the wrong story',
        );
      }
    }

    test('a man beats the next opponent and the run of form', () {
      expectLeads(
        card(const [
          (PressTopic.rivalryNext, opponent),
          (PressTopic.strikerDrought, player),
        ]),
        PressTopic.strikerDrought,
      );
    });

    test('the next opponent beats the run of form', () {
      expectLeads(
        card(const [(PressTopic.rivalryNext, opponent)]),
        PressTopic.rivalryNext,
      );
    });

    test('and what just happened beats all of them', () {
      expectLeads(
        card(const [
          (PressTopic.rivalryNext, opponent),
          (PressTopic.debutant, player),
          (PressTopic.sendingOff, incident),
        ]),
        PressTopic.sendingOff,
      );
    });

    test('but a stale incident does not', () {
      expectLeads(
        card(const [
          (PressTopic.sendingOff, stale),
          (PressTopic.debutant, player),
        ]),
        PressTopic.debutant,
      );
    });
  });

  test('every new topic has answers, a length and a key of its own', () {
    // A topic that reaches the sheet with no tones is an unanswerable
    // question, and two topics sharing a key prefix would file one another's
    // answers — [Press.topicOfKey] reads the prefix back.
    final prefixes = <String>{};
    for (final topic in PressTopic.values) {
      expect(
        Press.optionsFor(topic),
        isNotEmpty,
        reason: '${topic.name} offers nothing to say',
      );
      expect(
        Press.lengthFor(topic),
        greaterThan(0),
        reason: '${topic.name} is a conference of no questions',
      );
      final prefix = Press.keyPrefixOf(topic);
      expect(
        prefixes.add(prefix),
        isTrue,
        reason: '${topic.name} shares the key prefix "$prefix"',
      );
      expect(Press.topicOfKey('$prefix:1'), topic);
    }
  });
}
