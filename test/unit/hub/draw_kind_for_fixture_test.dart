import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

/// Which watched draw unlocks a fixture. A wrong answer hides the opponent on
/// the hub behind "draw pending", so the arranged one-offs matter most.
void main() {
  Fixture f({String? round, int? groupId}) => Fixture(
    id: 1,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime.utc(2030),
    homeNationId: 1,
    awayNationId: 2,
    round: round,
    groupId: groupId,
  );

  test('a friendly waits on no draw', () {
    expect(drawKindForFixture(f(round: 'FRIENDLY')), isNull);
  });

  test('nor does the Continental Clash', () {
    expect(drawKindForFixture(f(round: 'FFINAL')), isNull);
  });

  test('the competitions with a ceremony still wait on theirs', () {
    expect(drawKindForFixture(f(groupId: 3)), worldCupQualDrawKind);
    expect(drawKindForFixture(f(round: 'CQ')), continentalQualDrawKind);
    expect(drawKindForFixture(f(round: 'CGROUP')), continentalFinalsDrawKind);
    expect(drawKindForFixture(f(round: 'NGROUP')), nationsCupDrawKind);
    expect(drawKindForFixture(f(round: 'FINAL')), worldCupDrawKind);
  });
}
