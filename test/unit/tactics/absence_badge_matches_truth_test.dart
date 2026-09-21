import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/absence_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// The bug this pins: "injured 4g on the call-up list, and he played anyway."
///
/// The badge and the eleven read the same column of the same table, but not at
/// the same MOMENT. Every screen that reads absences does so through an
/// auto-disposed provider, and a provider kept alive by a mounted screen is
/// never told that the world moved: [SeasonService] flushes the served-down
/// absences to the database and invalidates the ranking, the hub and the
/// board's brief, but nothing that reads a suspension or a knock. So the
/// call-up row goes on showing the injury the man was carrying when the screen
/// first loaded, while the match — whose provider IS refreshed, by the preview
/// screen itself — reads the database and quite correctly lets him play.
///
/// He was never unfieldable. He was wrongly LABELLED.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  late AppDatabase db;
  late List<Nation> nations;
  late List<Player> players;

  ProviderContainer open() {
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() {
    db = createTestDatabase();
    addTearDown(db.close);
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
  });

  test(
    'the call-up list stops calling a healed man injured',
    () async {
      final c = open();
      await c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(nationId: nations.first.id, managerName: 'M'))
              .valueOrNull!;
      final careerId = career.id;
      final absRepo = c.read(absenceRepositoryProvider);

      // The call-up screen is open: its two absence readers are alive, exactly
      // as a mounted screen keeps them (the hazard `SeasonService` already names
      // for the ranking providers, and guards against there and nowhere else).
      final squadSub = c.listen(squadDataProvider(careerId), (_, _) {});
      addTearDown(squadSub.close);
      final outlookSub = c.listen(absenceOutlookProvider(careerId), (_, _) {});
      addTearDown(outlookSub.close);

      final squad = (await c.read(squadDataProvider(careerId).future))!;
      final hurt = squad.pool.first.id;
      await absRepo.replace(careerId, [
        PlayerAbsence(playerId: hurt, injuryMatches: 1),
      ]);
      c
        ..invalidate(squadDataProvider)
        ..invalidate(absenceOutlookProvider);

      final before = (await c.read(squadDataProvider(careerId).future))!;
      expect(
        before.absences[hurt]?.isAvailable,
        isFalse,
        reason: 'the setup must actually put a knock on him',
      );

      // He sits the match out; the knock is served and written back.
      c.invalidate(matchPreviewProvider);
      final preview = (await c.read(matchPreviewProvider(careerId).future))!;
      expect(
        (preview.playerIsHome ? preview.homeTeam : preview.awayTeam).xi.map(
          (p) => p.id,
        ),
        isNot(contains(hurt)),
        reason: 'he is genuinely out of THIS one',
      );
      await c
          .read(seasonServiceProvider)
          .playPlayerMatch(careerId, preview.fixture, preview.result);

      // The database is the truth, and it says he is fit again.
      expect(
        (await absRepo.forCareer(careerId))[hurt]?.isAvailable ?? true,
        isTrue,
        reason: 'one match served clears a one-match knock',
      );

      // He can play the next one — the match path re-reads and lets him.
      c.invalidate(matchPreviewProvider);
      final next = (await c.read(matchPreviewProvider(careerId).future))!;
      final fieldable = [
        ...(next.playerIsHome ? next.homeTeam : next.awayTeam).xi,
        ...next.bench,
      ].map((p) => p.id);
      expect(fieldable, contains(hurt), reason: 'he is available again');

      // ...so the call-up list must not still be badging him as injured. This is
      // the line that goes red: nothing refreshed the screen's absences, so the
      // row still reads "Injured · 1g" for a man the game will happily field.
      final after = (await c.read(squadDataProvider(careerId).future))!;
      expect(
        after.absences[hurt]?.isAvailable ?? true,
        isTrue,
        reason: 'the call-up badge must not outlive the absence it describes',
      );
      final outlooks = await c.read(absenceOutlookProvider(careerId).future);
      expect(
        outlooks[hurt],
        isNull,
        reason: 'and neither must the "out for N" line beside it',
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
