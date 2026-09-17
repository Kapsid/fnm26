import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

/// A group table is not an exit.
///
/// A nation whose last match of a tournament was a group game may have topped
/// the group and be waiting on a draw that has not been made, may have gone
/// up a league, or may genuinely be out — and the fixtures alone cannot tell
/// those apart until the tournament has moved on without them. Saying "we are
/// out" on the strength of "no more fixtures" told a group WINNER they had
/// been eliminated.
void main() {
  YMilestone? end(String? round, {bool goneAtGroup = false}) =>
      YFeed.endOfCampaign(
        round: round,
        competition: 'Nations Cup',
        won: false,
        date: DateTime(2030, 6, 21),
        key: 'cmp:9',
        goneAtGroup: goneAtGroup,
      );

  test('a knockout defeat is an exit without anybody being asked', () {
    for (final round in ['R32', 'R16', 'QF', 'SF', '3RD']) {
      expect(end(round)?.template, YTemplate.eliminated, reason: round);
    }
  });

  test('a group finish says nothing until the exit is established', () {
    expect(end('GROUP'), isNull);
    expect(end('NGROUP'), isNull);
    expect(end('CGROUP'), isNull);
  });

  test('a group finish that IS an exit still says so', () {
    expect(end('GROUP', goneAtGroup: true)?.template, YTemplate.eliminated);
    expect(end('NGROUP', goneAtGroup: true)?.template, YTemplate.eliminated);
  });

  test('a final is still read from the result, not from the group flag', () {
    expect(
      YFeed.endOfCampaign(
        round: 'NFINAL',
        competition: 'Nations Cup',
        won: true,
        date: DateTime(2030, 6, 21),
        key: 'cmp:9',
      )?.template,
      YTemplate.trophy,
    );
  });
}
