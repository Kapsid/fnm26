import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';

/// A world manager's style blends into the AI's instructions: each of the six
/// style shifts becomes the rounded mean of the nation's and the manager's.
/// Without a manager (or with one of the nation's own style) the AI sets up
/// exactly as it did before world managers.
void main() {
  List<int> six(TacticalInstructions i) => [
    i.mentality,
    i.pressing,
    i.tempo,
    i.width,
    i.defensiveLine,
    i.directness,
  ];

  String line(AiSetup s) =>
      '${s.formation.name}:${six(s.instructions).join(',')};';

  /// A value the 8..92 clamp may have cut: no shift can be read off it.
  bool edge(int v) => v <= 8 || v >= 92;

  /// FNV-1a over every setup [forOpponent] and [typicalSetups] give for 200
  /// seeds, 8 styles and 5 strength gaps, [manager] picking each one's
  /// manager style.
  int digest(NationStyle? Function(NationStyle style) manager) {
    var h = 0x811c9dc5;
    void eat(String s) {
      for (final c in s.codeUnits) {
        h = ((h ^ c) * 0x01000193) & 0xffffffff;
      }
    }

    for (final style in NationStyle.values) {
      for (final diff in const [-12.0, -5.0, 0.0, 5.0, 12.0]) {
        for (var seed = 0; seed < 200; seed++) {
          eat(
            line(
              AiTactics.forOpponent(
                opponentStrength: 70 + diff,
                playerStrength: 70,
                seed: seed * 7919 + 13,
                style: style,
                managerStyle: manager(style),
              ),
            ),
          );
        }
        for (final s in AiTactics.typicalSetups(
          opponentStrength: 70 + diff,
          playerStrength: 70,
          style: style,
          managerStyle: manager(style),
        )) {
          eat(line(s));
        }
      }
    }
    return h;
  }

  /// The digest of the code before world managers (commit 0e0af81f).
  const today = 2488166273;

  test('null managerStyle equals today for 200 seeds × 8 styles', () {
    expect(digest((_) => null), today);
    // A manager of the nation's own style changes nothing either.
    expect(digest((s) => s), today);
  });

  test('blend is the rounded mean of both shifts', () {
    // An even gap keeps every value well inside 8..92, so no clamp hides a
    // shift: a style's shift is its setup minus the balanced side's (whose
    // shift is zero) on the same seed.
    List<int> setup(int seed, NationStyle style, NationStyle? manager) => six(
      AiTactics.forOpponent(
        opponentStrength: 70,
        playerStrength: 70,
        seed: seed,
        style: style,
        managerStyle: manager,
      ).instructions,
    );
    for (var seed = 1; seed <= 40; seed++) {
      final base = setup(seed, NationStyle.balanced, null);
      List<int> shift(NationStyle s) => [
        for (var i = 0; i < 6; i++) setup(seed, s, null)[i] - base[i],
      ];
      for (final nation in NationStyle.values) {
        for (final manager in NationStyle.values) {
          final n = shift(nation);
          final m = shift(manager);
          final got = setup(seed, nation, manager);
          final read = [
            for (final v in [base, setup(seed, nation, null), got]) ...v,
            for (final v in [setup(seed, manager, null)]) ...v,
          ];
          for (var i = 0; i < 6; i++) {
            if ([for (var k = i; k < read.length; k += 6) read[k]].any(edge)) {
              continue;
            }
            expect(
              got[i] - base[i],
              ((n[i] + m[i]) / 2).round(),
              reason: 'seed $seed, $nation under a $manager manager, field $i',
            );
          }
        }
      }
    }
    // The typical setups blend the same way.
    for (final nation in NationStyle.values) {
      for (final manager in NationStyle.values) {
        List<List<int>> typical(NationStyle s, NationStyle? m) => [
          for (final t in AiTactics.typicalSetups(
            opponentStrength: 70,
            playerStrength: 70,
            style: s,
            managerStyle: m,
          ))
            six(t.instructions),
        ];
        final base = typical(NationStyle.balanced, null);
        final n = typical(nation, null);
        final m = typical(manager, null);
        final got = typical(nation, manager);
        for (var k = 0; k < base.length; k++) {
          expect(
            [for (var i = 0; i < 6; i++) got[k][i] - base[k][i]],
            [
              for (var i = 0; i < 6; i++)
                ((n[k][i] - base[k][i] + m[k][i] - base[k][i]) / 2).round(),
            ],
            reason: 'typical $k, $nation under a $manager manager',
          );
        }
      }
    }
  });

  test('same rng draws with and without a manager', () {
    // The posture pick and every jitter draw are the same: the formation
    // never moves, and the difference a manager makes is the same on every
    // seed (only the shift moved, never a draw).
    for (final nation in NationStyle.values) {
      for (final manager in NationStyle.values) {
        List<int>? delta;
        for (var seed = 0; seed < 200; seed++) {
          final without = AiTactics.forOpponent(
            opponentStrength: 70,
            playerStrength: 70,
            seed: seed,
            style: nation,
          );
          final with_ = AiTactics.forOpponent(
            opponentStrength: 70,
            playerStrength: 70,
            seed: seed,
            style: nation,
            managerStyle: manager,
          );
          expect(with_.formation, without.formation);
          final a = six(with_.instructions);
          final b = six(without.instructions);
          delta ??= List.filled(6, 999);
          for (var i = 0; i < 6; i++) {
            if (edge(a[i]) || edge(b[i])) continue;
            if (delta[i] == 999) delta[i] = a[i] - b[i];
            expect(
              a[i] - b[i],
              delta[i],
              reason: 'seed $seed, $nation / $manager, field $i',
            );
          }
        }
      }
    }
  });
}
