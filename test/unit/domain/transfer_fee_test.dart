import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/club/clubs.dart';

/// A transfer fee used to be the player's book value times a premium, with no
/// reference at all to who was paying — so a world-class player joining a
/// Romanian club was announced at thirty million euros. That is the arithmetic
/// working exactly as written, and nothing like a transfer.
void main() {
  group('what a league can pay', () {
    test('the ceiling falls with the league', () {
      final ceilings = [
        for (var tier = 1; tier <= 5; tier++)
          ClubService.feeCeilingForTier(tier),
      ];
      for (var i = 1; i < ceilings.length; i++) {
        expect(
          ceilings[i],
          lessThan(ceilings[i - 1]),
          reason: 'tier ${i + 1} must not out-pay tier $i',
        );
      }
    });

    test('an elite league can pay what an elite league pays', () {
      expect(
        ClubService.feeCeilingForTier(1),
        greaterThanOrEqualTo(100000000),
      );
    });

    test('the bottom of the pyramid cannot print a marquee fee', () {
      expect(ClubService.feeCeilingForTier(5), lessThanOrEqualTo(5000000));
    });

    test('a country with no curated league is treated as the lowest', () {
      expect(ClubService.tierOfCountry('zzz'), 5);
    });

    test('the big leagues are tier one, and the code is case-blind', () {
      expect(ClubService.tierOfCountry('eng'), 1);
      expect(ClubService.tierOfCountry('ENG'), 1);
      expect(ClubService.tierOfCountry('esp'), 1);
    });

    test('Romania cannot out-pay England', () {
      expect(
        ClubService.feeCeilingForTier(ClubService.tierOfCountry('rou')),
        lessThan(
          ClubService.feeCeilingForTier(ClubService.tierOfCountry('eng')),
        ),
      );
    });
  });
}
