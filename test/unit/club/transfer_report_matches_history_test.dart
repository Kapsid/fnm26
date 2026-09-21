import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/club/club_history.dart';
import 'package:fnm/domain/services/club/transfer_window.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';

import '../../helpers/test_database.dart';

/// The window report and a player's own club history are two views of ONE
/// thing: the clubs the save derived for him, season by season. They must
/// agree about how many times he moved.
///
/// They did not. The card walks every season of the player's life
/// ([ClubHistory.spells] over a `byId` walk); the report was built from the
/// nation's top ten by overall, so a manager's eleventh-best player moved
/// club without the window ever mentioning it — and then his card showed the
/// move he had never been told about.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late List<Nation> nations;

  /// How many seasons of the save to walk. Long enough for most of the pool
  /// to have changed club at least once, short enough to stay a unit test.
  const years = 10;

  setUp(() async {
    db = createTestDatabase();
    addTearDown(db.close);
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
  });

  test('every move in a player\'s history is in that year\'s window', () async {
    final nation = nations.first;
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nation.id, managerName: 'M'))
            .valueOrNull!;
    final repo = container.read(playerRepositoryProvider);
    final youth = await container.read(
      youthBonusByCycleProvider(career.id).future,
    );
    final starts = await container.read(
      careerDevBonusProvider(career.id).future,
    );

    // The pool the report is written from, season by season.
    final pools = <int, List<Player>>{};
    for (var y = 0; y <= years; y++) {
      pools[y] = await repo.byNation(
        nation.id,
        agingYears: y,
        saveSeed: career.rngSeed,
        youthBonusByCycle: youth,
        careerStartsByPlayer: starts,
      );
    }
    // The window reports, one per season, exactly as the rollover writes them.
    final windows = <int, Set<int>>{
      for (var y = 1; y <= years; y++)
        y: {
          for (final m in TransferWindow.moves(pools[y - 1]!, pools[y]!))
            m.now.id,
        },
    };

    // The players a manager can open a card for. The whole pool, not its head:
    // the bug lived entirely in the tail.
    final ids = pools[years]!.map((p) => p.id).toList();
    expect(ids.length, greaterThan(20));

    var checked = 0;
    for (final id in ids) {
      // Exactly the walk [clubHistoryProvider] does for the card.
      final seasons = <({int year, String club, String country})>[];
      for (var y = 0; y <= years; y++) {
        final p = await repo.byId(
          id,
          agingYears: y,
          saveSeed: career.rngSeed,
          youthBonusByCycle: youth,
          careerStartsByPlayer: starts,
        );
        if (p == null) continue;
        seasons.add((year: y, club: p.club, country: p.clubCountry));
      }
      final spells = ClubHistory.spells(seasons);
      for (var i = 1; i < spells.length; i++) {
        final moveYear = spells[i].fromYear;
        // Only seasons the pool holds him for can be reported: before his
        // seventeenth birthday, and after he retires, he is not in it.
        if (!(pools[moveYear]?.any((p) => p.id == id) ?? false)) continue;
        if (!(pools[moveYear - 1]?.any((p) => p.id == id) ?? false)) continue;
        checked++;
        expect(
          windows[moveYear],
          contains(id),
          reason:
              'the card shows a move to ${spells[i].club} in season '
              '$moveYear that the window report never listed',
        );
      }
    }
    expect(checked, greaterThan(20), reason: 'no moves were actually checked');
  });

  test('a window reports the pool, not only its best ten', () async {
    // The discriminating assertion: the cap that used to be here kept every
    // move by anyone outside the nation's top ten out of the report, which is
    // most of a squad.
    final nation = nations.first;
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nation.id, managerName: 'M'))
            .valueOrNull!;
    final repo = container.read(playerRepositoryProvider);

    var deep = 0;
    var total = 0;
    for (var y = 1; y <= years; y++) {
      final before = await repo.byNation(
        nation.id,
        agingYears: y - 1,
        saveSeed: career.rngSeed,
      );
      final after = await repo.byNation(
        nation.id,
        agingYears: y,
        saveSeed: career.rngSeed,
      );
      // byNation sorts by overall, so a player's index IS his rank.
      final rank = {for (var i = 0; i < after.length; i++) after[i].id: i};
      for (final m in TransferWindow.moves(before, after)) {
        if ((rank[m.now.id] ?? 0) >= 10) deep++;
        total++;
      }
    }
    // Measured on this save: 151 moves over ten seasons, of which 124 — more
    // than four in five — belong to a player outside the nation's top ten and
    // were reported to nobody.
    expect(total, greaterThan(50));
    expect(deep, greaterThan(total ~/ 2));
  });
}
