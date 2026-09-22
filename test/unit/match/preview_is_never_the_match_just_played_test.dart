import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// The bug this pins: "after I finish a match, the next match flashes up with
/// the current score."
///
/// [matchPreviewProvider] promises the player's NEXT fixture, simulated and
/// ready to play. It is auto-disposed, so a screen that has it open is the only
/// thing keeping it — and while it is kept, nothing tells it the world moved.
/// Committing a match result is exactly the world moving: the fixture the
/// preview holds has just been PLAYED, and its `result` is the score the
/// manager was looking at a second ago. Serve that to anything that opens next
/// and the finished match is what it draws.
///
/// The season service already refreshes the hub, the ranking and the board's
/// brief by hand for this very reason. The next match belongs on that list.
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

  test('committing a result moves the preview off the match just played', () async {
    final c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final career = (await c
            .read(careerServiceProvider)
            .create(
              nationId: nations.first.id,
              managerName: 'M',
              rngSeed: 20260922,
            ))
        .valueOrNull!;
    final careerId = career.id;

    // A screen has the preview open, and keeps it open across the commit —
    // which is what the live match screen does between the final whistle and
    // the route away from it.
    final held = c.listen(matchPreviewProvider(careerId), (_, _) {});
    addTearDown(held.close);

    final played = (await c.read(matchPreviewProvider(careerId).future))!;
    await c
        .read(seasonServiceProvider)
        .playPlayerMatch(careerId, played.fixture, played.result);

    // The fixture is in the books now — the database says so.
    final recorded = await c
        .read(competitionRepositoryProvider)
        .fixturesForNation(careerId, career.nationId);
    expect(
      recorded.firstWhere((f) => f.id == played.fixture.id).hasResult,
      isTrue,
      reason: 'the setup must actually play the match',
    );

    // So "the next match" must not be the one just played, and the score it
    // carries must not be the one still on the manager's screen.
    final next = (await c.read(matchPreviewProvider(careerId).future))!;
    expect(
      next.fixture.id,
      isNot(played.fixture.id),
      reason: 'the preview is still serving the fixture that was just played',
    );
    expect(next.fixture.hasResult, isFalse);
  }, timeout: const Timeout(Duration(minutes: 3)));
}
