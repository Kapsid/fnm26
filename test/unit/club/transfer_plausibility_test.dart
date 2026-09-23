import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/club/clubs.dart';

import '../../helpers/fixtures.dart';

Player _at(int overall, {required int id, required int age}) => player(
  id: id,
  nationId: 7,
  position: PlayerPosition.cm,
  age: age,
  attributes: flatAttributes(overall),
);

/// Which way a career's moves went between league tiers, as a percentage of
/// the moves made: up, down and sideways. This is the same reading the report
/// prints on each row (`TransferRow.step`), measured over a whole career and
/// across several save seeds, because one seed's draws carry a few points of
/// noise and the thresholds here are not that tight.
({int up, int down, int side, int moves}) _steps(int overall) {
  var up = 0;
  var down = 0;
  var side = 0;
  for (final seed in [3, 17, 31, 64, 99]) {
    for (var i = 0; i < 120; i++) {
      final id = 4000 + i * 7;
      String? previous;
      int? previousTier;
      for (var age = 18; age < 34; age++) {
        final c = ClubService.clubForSeed(
          _at(overall, id: id, age: age),
          seed,
          homeCode: 'bra',
          homeCities: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
        );
        final key = '${c.name}|${c.country}';
        final tier = ClubService.tierOfCountry(c.country);
        if (previous != null && previous != key) {
          // 1 is elite and 5 is lower, so a SMALLER tier is the better league.
          final step = previousTier!.compareTo(tier);
          if (step > 0) {
            up++;
          } else if (step < 0) {
            down++;
          } else {
            side++;
          }
        }
        previous = key;
        previousTier = tier;
      }
    }
  }
  final moves = up + down + side;
  return (
    up: (100 * up / moves).round(),
    down: (100 * down / moves).round(),
    side: (100 * side / moves).round(),
    moves: moves,
  );
}

/// "The moves are implausible" was one of four complaints about the transfer
/// report, and the one a test can actually hold: a star should not be seen
/// dropping down the leagues every other window.
void main() {
  /// The share of a top player's moves that may go DOWN a tier.
  ///
  /// Twenty-five per cent, and the number is a ceiling rather than a target.
  /// The step-down destination is drawn 12% of the time by design — it is the
  /// money move, the Saudi or Turkish contract, the season in Portugal, and a
  /// world where it never happens is as wrong as one where it always does.
  /// Measured across five seeds it comes out at 7% of an elite player's
  /// career moves. The ceiling sits far enough above that to survive the draw
  /// and far enough below a coin flip (50%) to fail loudly if the tier pick
  /// were ever inverted or the rating stopped reaching it.
  const maxDownShare = 25;

  test('a star does not spend his career dropping down the leagues', () {
    final s = _steps(86);
    expect(s.moves, greaterThan(500), reason: 'too few moves to read a share');
    expect(
      s.down,
      lessThanOrEqualTo(maxDownShare),
      reason: 'an 86-rated player moved down in ${s.down}% of his moves',
    );
    // The asymmetry is the point: the elite leagues come for him, so a move
    // is more often a step up than a step down.
    expect(s.up, greaterThan(s.down));
  });

  test('a first-choice international still steps up more than down', () {
    final s = _steps(80);
    expect(s.down, lessThanOrEqualTo(maxDownShare));
    expect(s.up, greaterThan(s.down));
  });

  test('most moves are sideways, whatever the rating', () {
    // A transfer market where every move changed a player's league would read
    // as a tombola. The common move is a club at the same level.
    for (final overall in [86, 80, 74]) {
      final s = _steps(overall);
      expect(
        s.side,
        greaterThan(s.up + s.down),
        reason: 'at $overall only ${s.side}% of moves held their level',
      );
    }
  });
}
