import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/manager/staff.dart';

int grant(int rank, int change) => FederationFinance.centralGrantFor(
  worldRank: rank,
  rankChangeOverCycle: change,
);

void main() {
  group('FederationFinance.centralGrantFor', () {
    test('the null control: the midpoint, standing still, pays the anchor', () {
      // Load-bearing. A nation at the midpoint rank whose position has not
      // moved must be paid exactly the anchor, to the euro — not a rounding
      // artefact one side or the other of it. Every other number in this file,
      // and every piece of reasoning about the federation economy, is measured
      // from here.
      expect(
        grant(FederationFinance.midpointRank, 0),
        FederationFinance.centralGrant,
      );
    });

    test('a nation that climbed is funded better than one that slid', () {
      final champion = grant(5, 20); // 25th to 5th: a championship cycle
      final steady = grant(5, 0); // was already 5th, stayed 5th
      final fallen = grant(5, -15); // was 5th's neighbour, now sliding
      expect(champion, greaterThan(steady));
      expect(steady, greaterThan(fallen));
    });

    test('a nation that fell down the ladder gets less than it did', () {
      // The same nation, two cycles running: 20th and holding, then 20th to
      // 45th. The second cheque is smaller than the first.
      final held = grant(20, 0);
      final slid = grant(45, -25);
      expect(slid, lessThan(held));
    });

    test('standing alone moves the grant, at rest in both directions', () {
      final best = grant(1, 0);
      final mid = grant(FederationFinance.midpointRank, 0);
      final minnow = grant(209, 0);
      expect(best, greaterThan(mid));
      expect(mid, greaterThan(minnow));
    });

    test('movement is priced in points, not places', () {
      // Five places at the top of the table is a different thing from five
      // places in mid-table, because the points between them are.
      final topFive = grant(1, 5) - grant(1, 0);
      final midFive =
          grant(FederationFinance.midpointRank, 5) -
          grant(FederationFinance.midpointRank, 0);
      expect(topFive, greaterThan(midFive));
      expect(midFive, greaterThan(0));
    });

    test('the band holds, and its floor runs a federation', () {
      // The extremes the game can actually reach, plus absurd inputs.
      final ceiling =
          (FederationFinance.centralGrant *
                  FederationFinance.maxGrantMultiplier)
              .round();
      final floor =
          (FederationFinance.centralGrant *
                  FederationFinance.minGrantMultiplier)
              .round();
      for (final (rank, change) in const [
        (1, 0),
        (1, 208),
        (5, 20),
        (60, 0),
        (100, -40),
        (209, 0),
        (209, -150),
        (-5, 500),
        (5000, -5000),
      ]) {
        final g = grant(rank, change);
        expect(g, lessThanOrEqualTo(ceiling));
        expect(g, greaterThanOrEqualTo(floor));
      }

      // The floor has to clear the federation's only compulsory outgoing: the
      // staff wage bill. A manager who hires an elite room and then has the
      // worst cycle in the game still pays them and is still solvent — being
      // bankrupted by one bad cycle would be a worse bug than a flat grant.
      final elite = Staff.totalCost({
        for (final r in StaffRole.values) r: StaffTier.elite,
      });
      expect(floor, greaterThan(elite));
      expect(grant(209, -150), greaterThan(elite));
    });

    test('the grant is paid in tidy euros', () {
      for (final (rank, change) in const [
        (1, 0),
        (17, 9),
        (60, -3),
        (140, -22),
      ]) {
        expect(grant(rank, change) % FederationFinance.grantRounding, 0);
      }
    });
  });
}
