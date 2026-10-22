import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/match/ai_substitutions.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_providers.dart';

import '../../helpers/fixtures.dart';

/// The AI's extra-time change is planned from who finished the ninety. The
/// engine takes a hurt man off exactly like a sent-off one, and the AI gets
/// no injury replacement, so a starter hurt in regulation is gone: picking
/// him to come off at 91 would have the engine drop the change silently.
void main() {
  // A 4-3-3 of 80s whose striker in the last slot is the side's weakest man,
  // so he is the one the change takes off whenever he is still on.
  const weakId = 299;
  final base = ratedTeam(2, 80);
  final strikerSlot = Formation.f433.positions.length - 1;
  final aiTeam = MatchTeam(
    nationId: 2,
    instructions: base.instructions,
    xi: [
      for (var i = 0; i < base.xi.length; i++)
        if (i == strikerSlot)
          player(
            id: weakId,
            nationId: 2,
            position: base.xi[i].position,
            attributes: flatAttributes(60),
          )
        else
          base.xi[i],
    ],
  );
  final bench = [
    for (var i = 0; i < 2; i++)
      player(
        id: 250 + i,
        nationId: 2,
        position: base.xi[strikerSlot].position,
        attributes: flatAttributes(78),
      ),
  ];

  MatchResult levelAfterEt(List<MatchEvent> events) => MatchResult(
    homeScore: 1,
    awayScore: 1,
    events: events,
    homeShots: 5,
    awayShots: 5,
    homePossession: 50,
    extraTime: (homeScore: 1, awayScore: 1),
  );

  /// The extra-time change the helper adds on its second run, or null.
  Substitution? etSubFor(List<MatchEvent> events) {
    final calls = <List<Substitution>>[];
    playWithAiExtraTimeSub(
      play: (subs) {
        calls.add(subs);
        return levelAfterEt(events);
      },
      aiSubs: const [],
      aiTeam: aiTeam,
      aiBench: bench,
      saveSeed: 42,
      fixtureId: 7,
    );
    return calls.length < 2 ? null : calls.last.single;
  }

  test('with everyone on, the weakest striker is the one taken off', () {
    // The control: without it the next test could pass for the wrong reason.
    final sub = etSubFor(const []);
    expect(sub, isNotNull);
    expect(sub!.offId, weakId);
    expect(sub.minute, AiSubstitutions.extraTimeMinute);
  });

  test('a starter hurt in regulation is not taken off at 91', () {
    final sub = etSubFor(const [
      MatchEvent(
        minute: 30,
        type: MatchEventType.injury,
        teamNationId: 2,
        playerId: weakId,
        playerName: 'Player 299',
      ),
    ]);
    expect(sub, isNotNull, reason: 'he still has fresh legs to bring on');
    expect(sub!.offId, isNot(weakId));
    expect(
      aiTeam.xi.map((p) => p.id),
      contains(sub.offId),
      reason: 'the man taken off is one still on the pitch',
    );
  });

  test('a starter sent off in regulation is not taken off at 91', () {
    final sub = etSubFor(const [
      MatchEvent(
        minute: 55,
        type: MatchEventType.redCard,
        teamNationId: 2,
        playerId: weakId,
        playerName: 'Player 299',
      ),
    ]);
    expect(sub, isNotNull);
    expect(sub!.offId, isNot(weakId));
  });
}
