import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/stats/spot_lines.dart';

/// Penalty and save counters from a match's shots, and a background
/// keeper's saves from its box score.
void main() {
  ShotMoment shot(
    int seq,
    int shooter,
    ShotOutcome outcome, {
    ShotOrigin origin = ShotOrigin.openPlay,
    int? keeper = 1,
  }) => ShotMoment(
    minute: seq,
    stoppage: 0,
    seq: seq,
    teamNationId: 9,
    shooterId: shooter,
    zone: PitchZone.boxCentre,
    xg: 0.2,
    outcome: outcome,
    origin: origin,
    keeperId: keeper,
  );

  test('penalties to the taker and the keeper, shots on target to the '
      'keeper', () {
    final m = SpotLines.fromMoments([
      shot(1, 10, ShotOutcome.goal, origin: ShotOrigin.penalty),
      shot(2, 10, ShotOutcome.saved, origin: ShotOrigin.penalty),
      shot(3, 11, ShotOutcome.saved),
      shot(4, 11, ShotOutcome.wide),
      shot(5, 12, ShotOutcome.blocked),
      shot(6, 12, ShotOutcome.goal, keeper: null),
    ]);
    expect(m[10]!.penTaken, 2);
    expect(m[10]!.penScored, 1);
    expect(m[11], isNull);
    final k = m[1]!;
    expect((k.onTargetFaced, k.saves), (3, 2));
    expect((k.penFaced, k.penSaved), (2, 1));
  });

  test('a background keeper faces a third of the shots, never fewer than '
      'the goals', () {
    final a = SpotLines.derivedKeeper(opponentShots: 12, conceded: 1);
    expect((a.onTargetFaced, a.saves), (4, 3));
    final b = SpotLines.derivedKeeper(opponentShots: 3, conceded: 4);
    expect((b.onTargetFaced, b.saves), (4, 0));
  });
}
