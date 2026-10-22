import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/repositories/drift_competition_repository.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/naturalization_rules.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

const int _italy = 26;
const int _sanMarino = 45;

/// A Ref to hand the career-pool helpers, which take one like a provider does.
final Provider<Ref> _refProvider = Provider<Ref>((ref) => ref);

/// "When a player is naturalised he kept his nationality, and it makes no
/// sense if he had previous starts for the old nation: he should have three
/// at most."
///
/// The pools already moved him (see naturalised_one_nation_test). What did
/// not: the identity read every card and list resolves him through, the caps
/// log that keeps one row per player, and the offer itself, which went to
/// men with any number of caps.
void main() {
  late AppDatabase db;
  late ProviderContainer c;
  late Career career;
  late Player star;

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
    career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: _sanMarino, managerName: 'M', rngSeed: 7))
            .valueOrNull!;
    star =
        (await c
                .read(playerRepositoryProvider)
                .byNation(
                  _italy,
                  agingYears: CareerService.agingYears(career),
                  saveSeed: career.rngSeed,
                  careerId: career.id,
                ))
            .first;
  });

  Future<void> offer() => c
      .read(careerRepositoryProvider)
      .addNaturalizationOffer(
        careerId: career.id,
        playerId: star.id,
        sourceNationId: _italy,
        cycle: 0,
      );

  Future<void> accept() async {
    await offer();
    await c
        .read(careerRepositoryProvider)
        .setNaturalizationStatus(career.id, star.id, 'accepted');
  }

  Future<Player?> lookUp() => c
      .read(playerRepositoryProvider)
      .byId(
        star.id,
        agingYears: CareerService.agingYears(career),
        saveSeed: career.rngSeed,
        careerId: career.id,
      );

  Future<void> caps(int nationId, int n) async {
    for (var i = 0; i < n; i++) {
      await c.read(competitionRepositoryProvider).recordAppearances(
        career.id,
        nationId,
        [star.id],
      );
    }
  }

  group('he is the new nation everywhere', () {
    test('his identity read names the nation he switched to', () async {
      expect((await lookUp())!.nationId, _italy, reason: 'before the switch');
      await accept();
      final him = (await lookUp())!;
      expect(him.nationId, _sanMarino);
      expect(him.name, star.name, reason: 'his name stays his own');
      // Without a career there is no naturalisation to read.
      final bare = await c.read(playerRepositoryProvider).byId(star.id);
      expect(bare!.nationId, _italy);
    });

    test('his player card shows the new flag', () async {
      await accept();
      // The view is a private record, exposed only as an Object: its fields
      // are read dynamically.
      final view =
          (await c.read(playerDetailFuture(career.id, star.id)))! as dynamic;
      // ignore: avoid_dynamic_calls, the private record's field (see above)
      expect((view.nation as Nation).id, _sanMarino);
      // ignore: avoid_dynamic_calls, the private record's field (see above)
      expect((view.player as Player).nationId, _sanMarino);
    });

    test(
      'his card still counts the goals he scored for the old nation',
      () async {
        final comp = c.read(competitionRepositoryProvider);
        GoalRecord goal(int nationId, int fixtureId) => (
          careerId: career.id,
          competitionId: 1,
          fixtureId: fixtureId,
          nationId: nationId,
          playerId: star.id,
          minute: 10,
        );
        await comp.recordGoals([goal(_italy, 1), goal(_italy, 2)]);
        await accept();
        await comp.recordGoals([goal(_sanMarino, 3)]);
        final view =
            (await c.read(playerDetailFuture(career.id, star.id)))! as dynamic;
        // ignore: avoid_dynamic_calls, the private record's field (see above)
        expect(view.goals as int, 3);
        // The goals themselves keep the nation they were scored for.
        expect(
          (await comp.nationTopScorers(
            career.id,
            _italy,
          )).where((t) => t.playerId == star.id).single.goals,
          2,
        );
      },
    );

    test('his match history knows which side he was on that day', () async {
      final comp = c.read(competitionRepositoryProvider);
      final forItaly = (await comp.nextFixtureForNation(career.id, _italy))!;
      PlayerMatchLine line(int nationId) => (
        playerId: star.id,
        nationId: nationId,
        rating: 7,
        goals: 0,
        assists: 0,
        cleanSheet: false,
        motm: false,
        yellows: 0,
        reds: 0,
      );
      await comp.recordPlayerMatchStats(career.id, forItaly.id, [line(_italy)]);
      await accept();
      final history = await comp.playerMatchHistory(career.id, star.id);
      expect(history.single.nationId, _italy);
    });

    test('he keeps the new nation after the manager leaves it', () async {
      await accept();
      final repo = c.read(careerRepositoryProvider);
      await repo.switchNation(career.id, _italy);
      await repo.recordStint(career.id, 1, _italy);
      career = (await repo.byId(career.id))!;
      expect((await lookUp())!.nationId, _sanMarino);
    });

    test('a new career is marked: its caps follow the nation', () async {
      expect(
        await c
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(career.id, 0, capsFollowNationKind),
        isTrue,
      );
    });

    test('in a marked career his caps after the switch count for the new '
        'nation', () async {
      await caps(_italy, 2);
      await accept();
      await caps(_sanMarino, 3);
      final comp = c.read(competitionRepositoryProvider);
      final mine = await comp.nationTopAppearances(career.id, _sanMarino);
      expect(
        mine.where((a) => a.playerId == star.id).map((a) => a.games),
        [5],
        reason: 'the caps log keeps one row per player: it follows him',
      );
      final theirs = await comp.nationTopAppearances(career.id, _italy);
      expect(theirs.map((a) => a.playerId), isNot(contains(star.id)));
    });

    test('an older (unmarked) career keeps his first-cap nation', () async {
      await (db.delete(db.drawsWatched)..where(
            (t) =>
                t.careerId.equals(career.id) &
                t.kind.equals(capsFollowNationKind),
          ))
          .go();
      // A fresh repository: one remembers a yes per career.
      final comp = DriftCompetitionRepository(db);
      for (var i = 0; i < 2; i++) {
        await comp.recordAppearances(career.id, _italy, [star.id]);
      }
      await accept();
      for (var i = 0; i < 3; i++) {
        await comp.recordAppearances(career.id, _sanMarino, [star.id]);
      }
      final theirs = await comp.nationTopAppearances(career.id, _italy);
      expect(
        theirs.where((a) => a.playerId == star.id).map((a) => a.games),
        [5],
        reason: 'exactly the old behaviour: the row keeps the first nation',
      );
      final mine = await comp.nationTopAppearances(career.id, _sanMarino);
      expect(mine.map((a) => a.playerId), isNot(contains(star.id)));
    });

    test('a career bundle carries the mark', () async {
      final bundle = await CareerBundle.export(db, career.id);
      expect(
        CareerBundle.watchedKindsOf(bundle),
        contains(capsFollowNationKind),
      );
      final imported = await CareerBundle.import(db, bundle);
      expect(
        await c
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(imported, 0, capsFollowNationKind),
        isTrue,
      );
    });
  });

  group('ten caps at most', () {
    test('the rule is ten caps', () {
      expect(kMaxCapsToSwitch, 10);
      expect(canSwitchAllegiance(10), isTrue);
      expect(canSwitchAllegiance(11), isFalse);
    });

    test('caps are read from the caps log, for that nation only', () async {
      final comp = c.read(competitionRepositoryProvider);
      expect(await comp.capsFor(career.id, _italy, star.id), 0);
      await caps(_italy, 4);
      expect(await comp.capsFor(career.id, _italy, star.id), 4);
      expect(await comp.capsFor(career.id, _sanMarino, star.id), 0);
    });

    test('an offer already made stands, caps or not', () async {
      await caps(_italy, 11);
      await offer();
      final link = await currentNaturalizationOffer(
        c.read(careerRepositoryProvider),
        career,
      );
      expect(link?.playerId, star.id);
    });

    test('a naturalisation already accepted stands, caps or not', () async {
      await caps(_italy, 11);
      await accept();
      final mine = await naturalizedPlayersFor(c.read(_refProvider), career);
      expect(mine.map((p) => p.id), [star.id]);
    });

    test('capped men are passed over and the offers still come', () async {
      final careers = c.read(careerRepositoryProvider);
      final comp = c.read(competitionRepositoryProvider);
      await careers.setInvestment(career.id, career.cyclePointer, (
        youth: 0,
        commercial: 0,
        medical: 0,
        naturalization: 40000000,
        boardRelations: 0,
      ));
      Future<List<int>> offered() async => [
        for (final r in await db.select(db.naturalizedPlayers).get())
          r.playerId,
      ];
      // The roll as it falls with nobody capped.
      await c.read(seasonServiceProvider).rollNaturalization(career.id);
      final first = await offered();
      expect(first, isNotEmpty, reason: 'the roll must make offers to test');

      // The same roll again, with every man it picked now an established
      // international.
      await db.delete(db.naturalizedPlayers).go();
      for (final id in first) {
        final p = await c
            .read(playerRepositoryProvider)
            .byId(id, careerId: career.id);
        for (var i = 0; i <= kMaxCapsToSwitch; i++) {
          await comp.recordAppearances(career.id, p!.nationId, [id]);
        }
      }
      await c.read(seasonServiceProvider).rollNaturalization(career.id);
      final second = await offered();
      expect(second, hasLength(first.length), reason: 'as many offers');
      expect(second.toSet().intersection(first.toSet()), isEmpty);
      for (final r in await db.select(db.naturalizedPlayers).get()) {
        expect(
          await comp.capsFor(career.id, r.sourceNationId, r.playerId),
          lessThanOrEqualTo(kMaxCapsToSwitch),
        );
      }
    });
  });
}
