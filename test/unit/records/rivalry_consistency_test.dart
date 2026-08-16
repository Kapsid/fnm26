import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/features/records/rivalry_providers.dart';

import '../../helpers/test_database.dart';

/// The record book's fiercest-rival card and the head-to-head screen used to
/// count the same fixtures differently: the card dropped friendlies, the
/// screen kept them, and one pairing read P4 on one and P5 on the other. Both
/// now read the one ledger.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int careerId;
  late int nationId;
  late int opponentId;

  setUp(() async {
    db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
    final me = nations.firstWhere((n) => n.code == 'CZE');
    final them = nations.firstWhere((n) => n.code == 'SVK');
    nationId = me.id;
    opponentId = them.id;
    final career =
        (await container
                .read(careerServiceProvider)
                .create(
                  nationId: nationId,
                  managerName: 'M',
                ))
            .valueOrNull!;
    careerId = career.id;

    // Three friendlies against the same nation: a win, a draw and a defeat.
    final comp = container.read(competitionRepositoryProvider);
    await comp.saveFriendlies(
      careerId: careerId,
      nationId: nationId,
      cycle: career.cyclePointer,
      friendlies: [
        for (var i = 0; i < 3; i++)
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
    expect(mine, hasLength(3));
    const scores = [(2, 0), (1, 1), (0, 3)];
    for (var i = 0; i < mine.length; i++) {
      await comp.recordResult(
        fixtureId: mine[i].id,
        homeScore: scores[i].$1,
        awayScore: scores[i].$2,
      );
    }
    container
      ..invalidate(rivalryProvider(careerId))
      ..invalidate(myHeadToHeadsProvider(careerId));
  });

  test('the rival card and the head-to-head ledger agree', () async {
    final rival = await container.read(rivalryProvider(careerId).future);
    expect(rival, isNotNull, reason: 'three meetings make a rivalry');
    expect(rival!.rival.id, opponentId);

    final ledger = await container.read(
      myHeadToHeadsProvider(careerId).future,
    );
    final line = ledger.firstWhere((l) => l.opponentId == opponentId);

    expect(rival.played, line.played);
    expect(rival.wins, line.wins);
    expect(rival.draws, line.draws);
    expect(rival.losses, line.losses);
    expect(rival.goalsFor, line.goalsFor);
    expect(rival.goalsAgainst, line.goalsAgainst);
  });

  test('and both agree with the pairing the h2h screen queries', () async {
    final rival = await container.read(rivalryProvider(careerId).future);
    final repo = await container
        .read(competitionRepositoryProvider)
        .headToHead(careerId, nationId, opponentId);

    expect(rival!.played, repo.played);
    expect(rival.wins, repo.winsA);
    expect(rival.draws, repo.draws);
    expect(rival.losses, repo.winsB);
  });

  test('a friendly counts — every result does', () async {
    // The old card filtered friendlies, so these three meetings were no
    // rivalry at all and the card showed nothing.
    final rival = await container.read(rivalryProvider(careerId).future);
    expect(rival!.played, 3);
    expect(rival.wins, 1);
    expect(rival.draws, 1);
    expect(rival.losses, 1);
  });
}
