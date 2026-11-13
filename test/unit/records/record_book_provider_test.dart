import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/records/record_book_providers.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../../helpers/test_database.dart';

/// The record book's headline figures, read from a save: the totals over
/// every result, the heaviest defeat, the keepers' clean-sheet board, and the
/// titles won in the save's own editions.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int careerId;
  late int nationId;
  late int opponentId;
  late List<Player> squad;

  setUp(() async {
    db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final me = nations.firstWhere((n) => n.code == 'CZE');
    final them = nations.firstWhere((n) => n.code == 'NZL');
    nationId = me.id;
    opponentId = them.id;
    squad =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .where((p) => p.nationId == nationId)
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: squad),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nationId, managerName: 'M'))
            .valueOrNull!;
    careerId = career.id;

    // Four friendlies against one nation: 3-0, 1-1, 0-3, 1-2.
    final comp = container.read(competitionRepositoryProvider);
    await comp.saveFriendlies(
      careerId: careerId,
      nationId: nationId,
      cycle: career.cyclePointer,
      friendlies: [
        for (var i = 0; i < 4; i++)
          (
            date: career.inGameDate.add(Duration(days: 10 + i * 10)),
            opponentId: opponentId,
            home: true,
          ),
      ],
    );
    final mine =
        (await comp.fixturesForNation(
            careerId,
            nationId,
          )).where((f) => f.awayNationId == opponentId && !f.hasResult).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    expect(mine, hasLength(4));
    const scores = [(3, 0), (1, 1), (0, 3), (1, 2)];
    for (var i = 0; i < mine.length; i++) {
      await comp.recordResult(
        fixtureId: mine[i].id,
        homeScore: scores[i].$1,
        awayScore: scores[i].$2,
      );
    }

    // The clean sheet in the 3-0 is logged on the keeper's row and on an
    // outfielder's, as the match engine logs it; another keeper played in a
    // second (made-up) clean sheet too, so the board has an order to keep.
    final keepers = [
      for (final p in squad)
        if (p.category == PositionCategory.goalkeeper) p,
    ];
    final outfielder = squad.firstWhere(
      (p) => p.category != PositionCategory.goalkeeper,
    );
    PlayerMatchLine line(Player p, {required bool clean}) => (
      playerId: p.id,
      nationId: nationId,
      rating: 7,
      goals: 0,
      assists: 0,
      cleanSheet: clean,
      motm: false,
      yellows: 0,
      reds: 0,
    );
    await comp.recordPlayerMatchStats(careerId, mine[0].id, [
      line(keepers[0], clean: true),
      line(outfielder, clean: true),
    ]);
    await comp.recordPlayerMatchStats(careerId, mine[1].id, [
      line(keepers[0], clean: true),
      line(keepers[1], clean: true),
      line(outfielder, clean: true),
    ]);

    // One title in the save's own years; one from the seeded past, which is
    // history rather than the save's own and stays out of the count.
    await comp.recordHonour(
      careerId: careerId,
      year: 2032,
      competition: 'European Championship',
      championId: nationId,
      runnerUpId: opponentId,
    );
    await comp.recordHonour(
      careerId: careerId,
      year: 1976,
      competition: 'European Championship',
      championId: nationId,
      runnerUpId: opponentId,
    );
    container.invalidate(recordBookProvider(careerId));
  });

  test('totals add up every result, goals both ways', () async {
    final book = (await container.read(recordBookProvider(careerId).future))!;
    final t = book.totals;
    expect(t.played, 4);
    expect(t.wins, 1);
    expect(t.draws, 1);
    expect(t.losses, 2);
    expect(t.goalsFor, 5);
    expect(t.goalsAgainst, 6);
  });

  test('the heaviest defeat is the widest margin', () async {
    final book = (await container.read(recordBookProvider(careerId).future))!;
    expect(book.biggestDefeat, (oppId: opponentId, gf: 0, ga: 3));
    expect(book.biggestWin, (oppId: opponentId, gf: 3, ga: 0));
  });

  test('the clean-sheet board ranks keepers only, most first', () async {
    final book = (await container.read(recordBookProvider(careerId).future))!;
    final keepers = [
      for (final p in squad)
        if (p.category == PositionCategory.goalkeeper) p.id,
    ];
    expect(
      [for (final r in book.topCleanSheets) r.playerId],
      [
        keepers[0],
        keepers[1],
      ],
    );
    expect([for (final r in book.topCleanSheets) r.value], [2, 1]);
  });

  test(
    'trophies count the save’s own titles, the latest written short',
    () async {
      final book = (await container.read(recordBookProvider(careerId).future))!;
      expect(book.trophies, 1);
      expect(book.latestTrophy, '${AppLocalizationsEn().matchTinyEurope} 2032');
    },
  );

  test('a stored honour name becomes its fan tag', () {
    final l = AppLocalizationsEn();
    expect(trophyTag(l, 'World Championship'), l.matchTinyWorld);
    expect(trophyTag(l, 'Asian Championship'), l.matchTinyAsia);
    expect(trophyTag(l, 'African Nations Cup'), l.matchTinyNationsCup);
    expect(trophyTag(l, 'Continental Clash'), l.matchTinyClash);
  });
}
