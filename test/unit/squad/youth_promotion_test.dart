import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';

/// A boy reaching the age moves UP a band; a band is not a fresh cohort. If it
/// were, an older group could read weaker than the group below it — which is
/// what "the U-21s are worse than the U-19s" would mean.
void main() {
  List<Player> seeded(int nation) => [
    for (var i = 0; i < 25; i++)
      player(id: nation * 1000 + i, nationId: nation, age: 17 + i % 16),
  ];

  /// The mean overall of one band's home-grown players.
  ///
  /// Newgens only: the seeded players mixed into the top two bands are real
  /// internationals whose quality says nothing about the pyramid's shape.
  double? _meanOverall(List<Player> youth, YouthLevel level) {
    final band = [
      for (final p in youth)
        if (YouthLevel.forAge(p.age) == level &&
            PlayerLifecycle.isNewgenId(p.id))
          p.overall,
    ];
    if (band.isEmpty) return null;
    return band.reduce((a, b) => a + b) / band.length;
  }

  test('the pyramid rises band by band', () {
    // Aggregated across nations and years: a single nation can field a golden
    // generation that outshines the boys a year older than them — that is
    // football, and the model is meant to allow it. What must never happen is
    // the pyramid reading weaker the further up it you look.
    final totals = <YouthLevel, List<double>>{
      for (final level in YouthLevel.values) level: [],
    };
    for (var nation = 1; nation <= 20; nation++) {
      for (final years in [0, 2, 4, 8]) {
        final youth = PlayerLifecycle.youthPoolAt(
          seeded(nation),
          nation,
          years,
        );
        for (final level in YouthLevel.values) {
          final mean = _meanOverall(youth, level);
          if (mean != null) totals[level]!.add(mean);
        }
      }
    }
    double overall(YouthLevel level) {
      final v = totals[level]!;
      return v.reduce((a, b) => a + b) / v.length;
    }

    for (var i = 1; i < YouthLevel.values.length; i++) {
      final level = YouthLevel.values[i];
      final below = YouthLevel.values[i - 1];
      expect(
        overall(level),
        greaterThan(overall(below)),
        reason: '${level.label} should read stronger than ${below.label}',
      );
    }
  });

  test('the same player carries his development up a band', () {
    // He is in a lower band one year and the next band the next — as himself,
    // better than he was, not replaced by somebody new.
    final youth = PlayerLifecycle.youthPoolAt(seeded(3), 3, 0);
    final onTheEdge = youth
        .where((p) => p.age == YouthLevel.u19.maxAge)
        .toList();
    expect(onTheEdge, isNotEmpty);

    final nextYear = {
      for (final p in PlayerLifecycle.youthPoolAt(seeded(3), 3, 1)) p.id: p,
    };
    for (final p in onTheEdge) {
      final promoted = nextYear[p.id];
      if (promoted == null) continue; // retired or grown out of the pyramid
      expect(YouthLevel.forAge(promoted.age), YouthLevel.u21);
      expect(
        promoted.overall,
        greaterThanOrEqualTo(p.overall),
        reason: 'player ${p.id} should not be worse for being promoted',
      );
    }
  });
}
