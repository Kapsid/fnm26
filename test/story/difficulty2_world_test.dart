@Tags(['slow'])
library;

import 'package:drift/drift.dart' show Variable;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/big_game_difficulty.dart';

import 'driver.dart';

/// The 1.1.2 difficulty never touches the AI-v-AI world: the same seed with
/// a near-top nation (Türkiye), its first cycle marked and unmarked, played
/// to the end of its World Championship. Every fixture between two other
/// nations comes out the same, score for score, up to the manager's first
/// result that differs (after which the bracket itself, and so who meets
/// whom, may legitimately move).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const turkiye = 53;

  Future<(List<List<Object?>>, bool)> run({required bool difficulty2}) async {
    final db = storyDb();
    final c = storyContainer(db);
    try {
      final d = await StoryDriver.start(
        c,
        42,
        nationId: turkiye,
        difficulty2: difficulty2,
      );
      for (var i = 0; i < 4000; i++) {
        if (!await d.step(stopAtRollover: true)) break;
      }
      final rows = await db
          .customSelect(
            'SELECT id, date, round, home_nation_id, away_nation_id, '
            'home_score, away_score, home_penalties, away_penalties '
            'FROM fixtures WHERE career_id = ? ORDER BY date, id',
            variables: [Variable<int>(d.careerId)],
          )
          .get();
      final fixtures = [
        for (final r in rows)
          [
            r.read<int>('id'),
            r.read<DateTime>('date').toUtc().toIso8601String(),
            r.readNullable<String>('round'),
            r.read<int>('home_nation_id'),
            r.read<int>('away_nation_id'),
            r.readNullable<int>('home_score'),
            r.readNullable<int>('away_score'),
            r.readNullable<int>('home_penalties'),
            r.readNullable<int>('away_penalties'),
          ],
      ];
      final knockout = fixtures.any(
        (f) =>
            (f[3] == turkiye || f[4] == turkiye) &&
            BigGameDifficulty.finalsKnockoutStage(f[2] as String?) != null,
      );
      return (fixtures, knockout);
    } finally {
      c.dispose();
      await db.close();
    }
  }

  test(
    'the world plays the same in a marked cycle',
    () async {
      final (marked, reachedKnockout) = await run(difficulty2: true);
      final (plain, _) = await run(difficulty2: false);
      bool mine(List<Object?> f) => f[3] == turkiye || f[4] == turkiye;
      final plainById = {for (final f in plain) f[0]: f};
      // The manager's first result that differs between the two runs.
      String? divergedAt;
      for (final f in marked.where(mine)) {
        final other = plainById[f[0]];
        if (other == null || other.toString() != f.toString()) {
          divergedAt = f[1] as String?;
          break;
        }
      }
      var compared = 0;
      for (final f in marked) {
        if (mine(f)) continue;
        if (divergedAt != null && (f[1] as String).compareTo(divergedAt) >= 0) {
          continue;
        }
        expect(plainById[f[0]], f, reason: 'fixture ${f[0]}');
        compared++;
      }
      // ignore: avoid_print
      print(
        'compared $compared world fixtures; manager diverged at $divergedAt; '
        'reached a finals knockout: $reachedKnockout',
      );
      expect(compared, greaterThan(500));
    },
    timeout: const Timeout(Duration(minutes: 60)),
  );
}
