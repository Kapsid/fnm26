import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/finals.dart';

/// 200 shootouts, half through `decideKnockout`, half through
/// `decideShootout` with named takers. Captured before the kick detail was
/// added; the scored/missed sequences must never change.
String _line(int seed) {
  final skill = [1.1, 0.8, 1.0, 0.9, 1.15];
  final KnockoutOutcome o;
  if (seed.isEven) {
    o = WorldCupFinals.decideShootout(
      1,
      1,
      SeededRng(seed),
      homeStrength: 1 + (seed % 7) / 5,
      awayStrength: 1 + (seed % 3) / 4,
      homeTakerSkill: seed % 4 == 0 ? skill : const [],
      awayTakerSkill: seed % 6 == 0 ? skill.reversed.toList() : const [],
    );
  } else {
    o = WorldCupFinals.decideKnockout(
      0,
      0,
      SeededRng(seed),
      homeStrength: 1 + (seed % 5) / 3,
      homeTakerSkill: seed % 3 == 0 ? skill : const [],
    );
  }
  String s(List<bool> k) => k.map((b) => b ? '1' : '0').join();
  return '$seed ${o.homeScore}-${o.awayScore} ${s(o.homeKicks)} ${s(o.awayKicks)}';
}

void main() {
  const path = 'test/unit/competition/golden/shootout_golden.txt';
  test('shootout results are unchanged', () {
    final lines = [for (var i = 1; i <= 200; i++) _line(i * 7919)];
    if (Platform.environment['GEN_GOLDEN'] == '1') {
      File(path).writeAsStringSync('${lines.join('\n')}\n');
    }
    final golden = File(path).readAsStringSync().trim().split('\n');
    expect(lines, golden);
  });
}
