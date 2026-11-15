import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/tournaments/bracket_tree.dart';

/// The bracket's tree order: each tie between the two it is fed by, rounds
/// still to come as empty ties.
void main() {
  var id = 0;
  Fixture tie(String round, int home, int away, {int? hs, int? as}) => Fixture(
    id: id++,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2030, 7, 1),
    homeNationId: home,
    awayNationId: away,
    homeScore: hs,
    awayScore: as,
    round: round,
    played: hs != null,
  );

  test('a played round is reordered under the round it feeds', () {
    // Quarter-finals stored 1v2, 3v4, 5v6, 7v8; the semis paired the winners
    // of 1v2 with 7v8 and of 3v4 with 5v6.
    final qf = [
      tie('QF', 1, 2, hs: 1, as: 0),
      tie('QF', 3, 4, hs: 1, as: 0),
      tie('QF', 5, 6, hs: 1, as: 0),
      tie('QF', 7, 8, hs: 1, as: 0),
    ];
    final sf = [tie('SF', 1, 7), tie('SF', 3, 5)];
    final cols = BracketTree.order([qf, sf, []]);
    expect(cols, hasLength(3));
    expect([for (final f in cols[0]) f!.homeNationId], [1, 7, 3, 5]);
    expect([for (final f in cols[1]) f!.homeNationId], [1, 3]);
    // The final not drawn yet: one empty tie.
    expect(cols[2], [null]);
  });

  test('rounds still to come halve, rounds before the first drawn are '
      'left out', () {
    final r16 = [for (var i = 0; i < 8; i++) tie('R16', 2 * i, 2 * i + 1)];
    final cols = BracketTree.order([[], r16, [], [], []]);
    expect([for (final c in cols) c.length], [8, 4, 2, 1]);
    expect(cols[0].first!.homeNationId, 0);
  });

  test('a shootout winner, stored a goal up, goes through', () {
    final f = Fixture(
      id: 1,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2030, 7, 1),
      homeNationId: 1,
      awayNationId: 2,
      homeScore: 1,
      awayScore: 2,
      homePenalties: 3,
      awayPenalties: 4,
      round: 'FINAL',
      played: true,
    );
    expect(BracketTree.winnerOf(f), 2);
    expect((f.shownHomeScore, f.shownAwayScore), (1, 1));
    expect(BracketTree.winnerOf(null), isNull);
  });
}
