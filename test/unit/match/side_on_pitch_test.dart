import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_providers.dart';

import '../../helpers/fixtures.dart';

/// Who is on the pitch at full time decides who may take a kick, so a man
/// substituted, sent off or hurt must not be in the opposition's order.
void main() {
  MatchEvent ev(MatchEventType t, int minute, int playerId, {String? off}) =>
      MatchEvent(
        minute: minute,
        type: t,
        teamNationId: 2,
        playerId: playerId,
        playerName: 'Player $playerId',
        secondaryName: off,
      );

  test('subs, the extra-time change, reds and injuries are applied', () {
    final team = ratedTeam(2, 80);
    final xi = team.xi;
    final benchA = player(id: 250, nationId: 2);
    final benchB = player(id: 251, nationId: 2);
    final benchC = player(id: 252, nationId: 2);
    final planned = Substitution(
      teamNationId: 2,
      minute: 60,
      offId: xi[0].id,
      on: benchA,
    );
    final ids = sideOnPitchAtEnd(
      team: team,
      bench: [benchA, benchB, benchC],
      plannedSubs: [planned],
      events: [
        ev(MatchEventType.substitution, 60, 250, off: xi[0].name),
        // The extra-time change is not in the plan: read from the event.
        ev(MatchEventType.substitution, 91, 251, off: xi[1].name),
        ev(MatchEventType.redCard, 70, xi[2].id),
        ev(MatchEventType.injury, 100, xi[3].id),
      ],
    ).map((p) => p.id).toSet();
    expect(ids, hasLength(9));
    expect(ids, containsAll([250, 251]));
    expect(ids, isNot(contains(xi[0].id)));
    expect(ids, isNot(contains(xi[1].id)));
    expect(ids, isNot(contains(xi[2].id)));
    expect(ids, isNot(contains(xi[3].id)));
    expect(ids, isNot(contains(252)));
  });
}
