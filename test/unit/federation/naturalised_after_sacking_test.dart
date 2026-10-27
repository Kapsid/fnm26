import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

const int _americanSamoa = 201;
const int _montserrat = 89;

/// A Ref to hand the career-pool helpers, which take one like a provider does.
final Provider<Ref> _refProvider = Provider<Ref>((ref) => ref);

/// "Managing American Samoa for the 2030 cycle, after World Cup qualifying
/// there was a naturalisation offer which I accepted, but was fired after,
/// and then I switched to managing Montserrat; the naturalised player for
/// American Samoa was then playing for Montserrat."
///
/// The owner's sequence end to end: the offer rolled late in the cycle, taken
/// from the decision the hub puts to him, the cycle played out, and the move
/// made through the real rollover. The man switched allegiance to American
/// Samoa and stays there; nothing still on the table goes with the manager.
void main() {
  late AppDatabase db;
  late ProviderContainer c;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = createTestDatabase();
    addTearDown(db.close);
    List<T> load<T>(String f, T Function(Map<String, Object?>) from) =>
        (jsonDecode(File('assets/data/$f').readAsStringSync()) as List)
            .map((e) => from(e as Map<String, Object?>))
            .toList();
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: load('nations.json', Nation.fromJson),
            playerList: load('players.json', Player.fromJson),
          ),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
  });

  test(
    'a man naturalised for American Samoa stays there when the manager '
    'moves to Montserrat',
    () async {
      final careers = c.read(careerRepositoryProvider);
      final season = c.read(seasonServiceProvider);
      var career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: _americanSamoa,
                    managerName: 'M',
                    rngSeed: 11,
                  ))
              .valueOrNull!;
      Future<Career> reload() async => (await careers.byId(career.id))!;

      // Play on past World Championship qualifying.
      final pastQualifying = DateTime(
        CareerService.worldCupYear(career.cyclePointer),
      );
      for (var i = 0; i < 400; i++) {
        if (!(await reload()).inGameDate.isBefore(pastQualifying)) break;
        await season.advance(career.id);
      }
      career = await reload();
      expect(career.inGameDate.isBefore(pastQualifying), isFalse);

      // A naturalisation office spending heavily, so the roll lands offers.
      await careers.setInvestment(career.id, career.cyclePointer, (
        youth: 0,
        commercial: 0,
        medical: 0,
        naturalization: 40000000,
        boardRelations: 0,
      ));
      await db.delete(db.naturalizedPlayers).go();
      await season.rollNaturalization(career.id);

      // He takes the offer the hub puts to him, the way the decision screen
      // files it.
      final offer = await currentNaturalizationOffer(careers, career);
      expect(offer, isNotNull, reason: 'the roll must make an offer to test');
      await careers.setNaturalizationStatus(
        career.id,
        offer!.playerId,
        'accepted',
      );
      final starId = offer.playerId;
      // And a second approach is still waiting when the cycle ends (two
      // hits queue; a second one is added here so the case is always met).
      final pool = await careerPoolOf(
        c.read(_refProvider),
        career,
        offer.sourceNationId,
      );
      final suitor = pool.firstWhere((p) => p.id != starId);
      await careers.addNaturalizationOffer(
        careerId: career.id,
        playerId: suitor.id,
        sourceNationId: suitor.nationId,
        cycle: career.cyclePointer,
      );
      final queued = (await careers.pendingNaturalization(career.id))!;
      final queuedId = queued.playerId;
      final another = pool.firstWhere(
        (p) => p.id != starId && p.id != queuedId && p.id != suitor.id,
      );
      await careers.addNaturalizationOffer(
        careerId: career.id,
        playerId: another.id,
        sourceNationId: another.nationId,
        cycle: career.cyclePointer,
      );

      // Play out the cycle.
      for (var i = 0; i < 400; i++) {
        if (await c
                .read(competitionRepositoryProvider)
                .worldChampion(career.id) !=
            null) {
          break;
        }
        final before = (await reload()).inGameDate;
        await season.advance(career.id);
        if (!(await reload()).inGameDate.isAfter(before)) break;
      }
      expect(
        await c.read(competitionRepositoryProvider).worldChampion(career.id),
        isNotNull,
        reason: 'the cycle must finish before the manager can move',
      );

      // Out of the American Samoa job, into Montserrat's.
      await season.startNextCycle(career.id, switchToNationId: _montserrat);
      career = await reload();
      expect(career.nationId, _montserrat);
      final ref = c.read(_refProvider);

      // He plays for American Samoa, everywhere.
      expect(
        (await careerPoolOf(ref, career, _americanSamoa)).map((p) => p.id),
        contains(starId),
      );
      expect(
        (await careerPoolOf(ref, career, _montserrat)).map((p) => p.id),
        isNot(contains(starId)),
      );
      expect(
        (await c
                .read(playerRepositoryProvider)
                .byId(starId, careerId: career.id))!
            .nationId,
        _americanSamoa,
      );
      // Not in Montserrat's squad, call-ups or XI.
      expect(await naturalizedPlayersFor(ref, career), isEmpty);
      expect(
        (await c.read(squadDataProvider(career.id).future))!.pool.map(
          (p) => p.id,
        ),
        isNot(contains(starId)),
      );
      final tactic = (await c.read(tacticDataProvider(career.id).future))!;
      expect(tactic.pool.map((p) => p.id), isNot(contains(starId)));
      expect(tactic.tactic.lineup, isNot(contains(starId)));
      expect(await c.read(naturalizedCountProvider(career.id).future), 0);

      // Every approach made to American Samoa lapsed with the job, not just
      // the first one found: none is left pending for Montserrat to answer.
      expect(await careers.pendingNaturalization(career.id), isNull);
      expect(
        await c.read(pendingNaturalizationProvider(career.id).future),
        isNull,
      );
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
