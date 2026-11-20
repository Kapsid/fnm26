@Tags(['slow'])
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import 'driver.dart';

/// A card ban is served only in competitive games, and it does not keep a
/// man out of a friendly in the meantime. A tester's player, sent off in a
/// qualifier, could not play four friendlies in a row.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test(
    'a banned man may play a friendly, and not a competitive match',
    () async {
      final db = storyDb();
      final c = storyContainer(db);
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 42, nationId: 12);
      final id = d.careerId;
      final comp = c.read(competitionRepositoryProvider);
      final absences = c.read(absenceRepositoryProvider);

      Future<({List<int> pool, List<int> preview})> picks() async {
        c
          ..invalidate(tacticDataProvider(id))
          ..invalidate(matchPreviewProvider(id));
        final data = await c.read(tacticDataProvider(id).future);
        final sub = c.listen(matchPreviewProvider(id).future, (_, _) {});
        final preview = await sub.read();
        sub.close();
        return (
          pool: [for (final p in data!.pool) p.id],
          preview: <int>[
            for (final p in [
              ...(preview!.homeTeam.nationId == 12
                      ? preview.homeTeam
                      : preview.awayTeam)
                  .xi,
              ...preview.bench,
            ])
              p.id,
          ],
        );
      }

      Future<void> stepUntil(bool Function(String? round) want) async {
        for (var i = 0; i < 3000; i++) {
          final next = await comp.nextFixtureForNation(id, 12);
          final called = await c.read(squadRepositoryProvider).callUps(id);
          if (next != null && called.isNotEmpty && want(next.round)) return;
          await d.step();
        }
        fail('never reached the match wanted');
      }

      // A friendly next: the banned man is in the pool and the preview.
      await stepUntil((r) => r == Rounds.friendly);
      final before = await picks();
      final banned = before.pool.first;
      await absences.replace(id, [
        PlayerAbsence(playerId: banned, banMatches: 2),
      ]);
      final friendly = await picks();
      expect(friendly.pool, contains(banned));
      expect(friendly.preview, contains(banned));

      // A competitive match next: he sits it out.
      await stepUntil((r) => r != Rounds.friendly);
      final stillBanned = (await absences.forCareer(id))[banned];
      if (stillBanned == null || stillBanned.banMatches == 0) {
        await absences.replace(id, [
          PlayerAbsence(playerId: banned, banMatches: 1),
        ]);
      }
      final competitive = await picks();
      expect(competitive.pool, isNot(contains(banned)));
      expect(competitive.preview, isNot(contains(banned)));
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
