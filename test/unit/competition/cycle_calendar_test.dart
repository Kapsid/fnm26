import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../helpers/test_database.dart';

/// The cycle calendar, driven end-to-end with the real nation set from the
/// point of view of a nation that does *not* reach the World Cup finals.
///
/// Regression cover for a calendar bug that made the World Cup unwatchable:
/// `_matchdayDates` ignored `start.month` and always opened at the September
/// window, so qualifying ran nine months past the hard-coded June finals slot.
/// The finals were then created already in the past, and `_catchUp`'s
/// resolve-a-stale-tournament loop played all seven rounds in a single
/// `advance` — crowning a champion with nothing to watch.
void main() {
  test('the cycle calendar runs in order and the finals step round by round',
      () async {
    final db = createTestDatabase();
    final nations = (jsonDecode(
      File('assets/data/nations.json').readAsStringSync(),
    ) as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    await container.read(seedLoaderProvider).ensureSeeded();
    // The weakest European nation: it won't qualify, so the finals are watched
    // rather than played — the passive path this test is about.
    final player = nations
        .where((n) => n.confederation == Confederation.europe)
        .reduce((a, b) => a.ranking >= b.ranking ? a : b);
    final career = (await container.read(careerServiceProvider).create(
          nationId: player.id,
          managerName: 'A',
        ))
        .valueOrNull!;

    final season = container.read(seasonServiceProvider);
    final comp = container.read(competitionRepositoryProvider);

    // How many distinct advances moved the World Cup finals forward. Each
    // round must be its own step, so the player sees every matchday.
    final finalsSteps = <String>{};
    var lastPlayedCount = 0;
    const wcRounds = ['GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'];

    var lastDate = DateTime(1900);
    for (var i = 0; i < 400; i++) {
      await season.advance(career.id);
      final hub = await container.read(hubDataProvider(career.id).future);
      if (hub == null) break;

      if (await comp.hasFinals(career.id)) {
        var played = 0;
        for (final r in wcRounds) {
          played +=
              (await comp.fixturesByRound(career.id, r)).where((f) => f.played).length;
        }
        if (played > lastPlayedCount) {
          finalsSteps.add(hub.career.inGameDate.toIso8601String());
          lastPlayedCount = played;
        }
      }

      if (hub.championNationId != null) break;
      if (!hub.career.inGameDate.isAfter(lastDate)) break;
      lastDate = hub.career.inGameDate;
    }

    Future<DateTime> firstDate(String round, CompetitionKind kind) async {
      final fx = await comp.fixturesByRound(career.id, round, kind: kind);
      return (fx.map((f) => f.date).toList()..sort()).first;
    }

    // 3 group matchdays + R32 + R16 + QF + SF + 3RD + FINAL = 9 steps.
    expect(
      finalsSteps.length,
      greaterThanOrEqualTo(9),
      reason: 'the finals should advance one matchday at a time, not resolve '
          'in a single step',
    );

    // The play-off and the final are separate occasions: sharing a date
    // collapsed them into one popup titled after the play-off.
    final thirdDate = await firstDate('3RD', CompetitionKind.worldCupFinals);
    final finalDate = await firstDate('FINAL', CompetitionKind.worldCupFinals);
    expect(
      finalDate.isAfter(thirdDate),
      isTrue,
      reason: 'the final must come after the third-place play-off',
    );

    // The World Cup is a June tournament.
    final wcGroupStart = await firstDate('GROUP', CompetitionKind.worldCupFinals);
    expect(wcGroupStart.month, 6);

    // Nations Cup groups (autumn) → Final Four → World Cup, in that order and
    // all settled before the finals begin.
    const nc = CompetitionKind.nationsLeague;
    final ncGroupStart = await firstDate('NGROUP', nc);
    final ncFinal = await firstDate('NFINAL', nc);
    expect(ncGroupStart.month, 9, reason: 'Nations Cup groups open in autumn');
    expect(ncFinal.month, 6, reason: 'the Final Four takes the June window');
    expect(ncFinal.isAfter(ncGroupStart), isTrue);
    expect(
      ncFinal.isBefore(wcGroupStart),
      isTrue,
      reason: 'the Final Four must be settled before the World Cup',
    );

    // World Cup qualifying opens in spring and ends before the finals.
    final quals = (await comp.allFixtures(career.id))
        .where((f) => f.round == null) // qualifying fixtures carry no round
        .map((f) => f.date)
        .toList()
      ..sort();
    expect(quals.first.month, 3, reason: 'qualifying opens in the March window');
    expect(quals.last.isBefore(wcGroupStart), isTrue);

    // No nation is ever booked for two matches on the same day.
    final perNationDay = <String, int>{};
    for (final f in await comp.allFixtures(career.id)) {
      final day = f.date.toIso8601String().substring(0, 10);
      for (final id in [f.homeNationId, f.awayNationId]) {
        perNationDay['$id@$day'] = (perNationDay['$id@$day'] ?? 0) + 1;
      }
    }
    expect(
      perNationDay.values.where((v) => v > 1),
      isEmpty,
      reason: 'competitions must not double-book a nation on one day',
    );
  }, timeout: const Timeout(Duration(minutes: 6)));
}
