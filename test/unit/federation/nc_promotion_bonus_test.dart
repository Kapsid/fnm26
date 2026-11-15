import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';

import '../../helpers/calendar2_draws.dart';
import '../../helpers/test_database.dart';

/// A Nations Cup promotion pays EUR 1M at the cycle's close (owner, 1.1.2),
/// each one: Europe can climb twice a calendar2 cycle. An unmarked cycle
/// pays as before.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the prize table adds the bonus per promotion', () {
    final none = FederationFinance.resultsPrize(
      wcRounds: const {},
      contRounds: const {},
      titlesWon: const {},
    );
    expect(none, 0);
    expect(
      FederationFinance.resultsPrize(
        wcRounds: const {'GROUP'},
        contRounds: const {},
        titlesWon: const {},
        ncPromotions: 2,
      ),
      6000000 + 2 * FederationFinance.ncPromotionBonus,
    );
  });

  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();

  late AppDatabase db;
  late ProviderContainer c;
  setUp(() async {
    db = createTestDatabase();
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    await c.read(seedLoaderProvider).ensureSeeded();
  });
  tearDown(() async {
    c.dispose();
    await db.close();
  });

  /// Wins every Nations Cup group game of [me] in both editions, every
  /// other game a goalless draw.
  Future<void> winBothEditions(int id, int me) async {
    await drawSecondNationsCupNow(c, id);
    final comps =
        await (db.select(db.competitions)..where(
              (t) =>
                  t.careerId.equals(id) &
                  t.kind.equalsValue(CompetitionKind.nationsLeague) &
                  t.confederation.equalsValue(Confederation.europe),
            ))
            .get();
    final fx =
        await (db.select(db.fixtures)..where(
              (t) =>
                  t.competitionId.isIn([for (final r in comps) r.id]) &
                  t.round.equals('NGROUP'),
            ))
            .get();
    final comp = c.read(competitionRepositoryProvider);
    for (final f in fx) {
      final home = f.homeNationId == me;
      final away = f.awayNationId == me;
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: home ? 2 : 0,
        awayScore: away ? 2 : 0,
      );
    }
  }

  Future<(int, int)> careerIn({required bool calendar2}) async {
    // A European side outside League A.
    final tiersProbe = await c
        .read(careerServiceProvider)
        .create(
          nationId: 1,
          managerName: 'M',
          rngSeed: 7,
          calendar2: calendar2,
        );
    final tiers = await c
        .read(careerRepositoryProvider)
        .nationsCupTiers(tiersProbe.valueOrNull!.id);
    final me = nations
        .where((n) => n.confederation == Confederation.europe)
        .firstWhere((n) => (tiers[n.id] ?? 0) == 2)
        .id;
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: me,
                  managerName: 'M',
                  rngSeed: 7,
                  calendar2: calendar2,
                ))
            .valueOrNull!;
    return (career.id, me);
  }

  test('a calendar2 European side that wins its group in both editions '
      'banks two bonuses', () async {
    final (id, me) = await careerIn(calendar2: true);
    expect(
      await c
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(
            id,
            0,
            Calendar2.kind,
          ),
      isTrue,
    );
    await winBothEditions(id, me);
    final income = await c
        .read(federationServiceProvider)
        .incomeForCycle(id, 0);
    expect(income.prize, 2 * FederationFinance.ncPromotionBonus);
  });

  test('an unmarked cycle pays no bonus', () async {
    final (id, me) = await careerIn(calendar2: false);
    final comp = c.read(competitionRepositoryProvider);
    final comps =
        await (db.select(db.competitions)..where(
              (t) =>
                  t.careerId.equals(id) &
                  t.kind.equalsValue(CompetitionKind.nationsLeague),
            ))
            .get();
    for (final f
        in await (db.select(db.fixtures)..where(
              (t) => t.competitionId.isIn([for (final r in comps) r.id]),
            ))
            .get()) {
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: f.homeNationId == me ? 2 : 0,
        awayScore: f.awayNationId == me ? 2 : 0,
      );
    }
    final income = await c
        .read(federationServiceProvider)
        .incomeForCycle(id, 0);
    expect(income.prize, 0);
  });
}
