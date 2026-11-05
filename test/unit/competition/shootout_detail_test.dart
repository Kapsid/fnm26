import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/finals.dart';

KnockoutOutcome _shoot(
  int seed, {
  List<int> home = const [],
  List<int> away = const [],
}) => WorldCupFinals.decideShootout(
  1,
  1,
  SeededRng(seed),
  homeStrength: 1 + (seed % 5) / 4,
  homeTakerIds: home,
  awayTakerIds: away,
);

void main() {
  test('detail agrees with the bools', () {
    var misses = 0;
    final counts = <KickResult, int>{};
    for (var seed = 1; seed <= 400; seed++) {
      final o = _shoot(seed);
      for (final (kicks, detail) in [
        (o.homeKicks, o.homeDetail),
        (o.awayKicks, o.awayDetail),
      ]) {
        expect(detail.length, kicks.length);
        for (var i = 0; i < kicks.length; i++) {
          final k = detail[i];
          expect(k.lane, inInclusiveRange(0, 5));
          expect(k.diveLane, inInclusiveRange(0, 5));
          expect(k.result == KickResult.scored, kicks[i]);
          if (kicks[i]) {
            if (k.diveLane == k.lane)
              expect(k.lane == 3 || k.lane == 5, isTrue);
          } else {
            misses++;
            counts[k.result] = (counts[k.result] ?? 0) + 1;
            if (k.result == KickResult.saved) {
              expect(k.diveLane, k.lane);
            } else {
              expect(k.diveLane, isNot(k.lane));
              expect(k.lane % 3, isNot(1), reason: 'edge column');
            }
          }
        }
      }
    }
    expect(counts[KickResult.saved]! / misses, closeTo(0.6, 0.08));
    expect(counts[KickResult.wide]! / misses, closeTo(0.3, 0.08));
    expect(counts[KickResult.post]! / misses, closeTo(0.1, 0.06));
  });

  test('takers follow the given order', () {
    final home = [11, 12, 13, 14, 15];
    final away = [21, 22, 23, 24, 25];
    var sawSuddenDeath = false;
    for (var seed = 1; seed <= 300; seed++) {
      final o = _shoot(seed, home: home, away: away);
      for (var i = 0; i < o.homeDetail.length; i++) {
        expect(o.homeDetail[i].takerId, home[i % 5]);
      }
      for (var i = 0; i < o.awayDetail.length; i++) {
        expect(o.awayDetail[i].takerId, away[i % 5]);
      }
      if (o.homeKicks.length > 5) sawSuddenDeath = true;
    }
    expect(sawSuddenDeath, isTrue);
    expect(_shoot(3).homeDetail.every((k) => k.takerId == 0), isTrue);
  });
}
