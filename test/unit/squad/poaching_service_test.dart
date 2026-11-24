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
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/player/poaching.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/squad/poaching_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

const int _italy = 26;
const int _sanMarino = 45;

final Provider<Ref> _refProvider = Provider<Ref>((ref) => ref);

/// A rival federation trying to recruit one of the manager's players who has
/// not played a competitive match for his nation yet.
void main() {
  late AppDatabase db;
  late ProviderContainer c;
  late Career career;

  Future<Career> reload() async =>
      (await c.read(careerRepositoryProvider).byId(career.id))!;

  Future<List<Player>> pool(int nationId) async =>
      careerPoolOf(c.read(_refProvider), await reload(), nationId);

  Future<Set<String>> markers() => c
      .read(internationalRetirementRepositoryProvider)
      .markersWithPrefix(career.id, Poaching.prefix);

  Future<Set<String>> messageKeys() =>
      c.read(competitionRepositoryProvider).messageKeys(career.id);

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
  });

  test('a player lured away plays for the rival everywhere', () async {
    final him = (await pool(_sanMarino)).first;
    final repo = c.read(careerRepositoryProvider);
    await repo.addNaturalizationOffer(
      careerId: career.id,
      playerId: him.id,
      sourceNationId: _sanMarino,
      cycle: 0,
    );
    await repo.setNaturalizationStatus(
      career.id,
      him.id,
      '$poachedStatusPrefix$_italy',
    );

    final links = await repo.acceptedNaturalizations(career.id);
    expect(links.single.targetNationId, _italy);
    expect((await pool(_sanMarino)).map((p) => p.id), isNot(contains(him.id)));
    final italy = await pool(_italy);
    final there = italy.where((p) => p.id == him.id).toList();
    expect(there, hasLength(1));
    expect(there.single.nationId, _italy);
    expect(
      await naturalizedPlayersFor(c.read(_refProvider), await reload()),
      isEmpty,
      reason: "he is no naturalisation INTO the manager's nation",
    );
    final byId = await c
        .read(playerRepositoryProvider)
        .byId(
          him.id,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
          careerId: career.id,
        );
    expect(byId?.nationId, _italy, reason: 'his page flies the new flag');
  });

  test('now and then a rival approaches a young uncapped player', () async {
    final careers = c.read(careerRepositoryProvider);
    final service = c.read(poachingServiceProvider);
    PoachCase? open;
    var date = career.inGameDate;
    for (var q = 0; q < 40 && open == null; q++) {
      await service.settle(career.id);
      open = await c.read(openPoachProvider(career.id).future);
      if (open != null) break;
      date = DateTime(date.year, date.month + 3, date.day);
      await careers.updateInGameDate(career.id, date);
      c.invalidate(openPoachProvider(career.id));
    }
    expect(open, isNotNull, reason: 'forty quarters bring an approach');
    expect(open!.rivalId, isNot(_sanMarino));

    final mine = await pool(_sanMarino);
    final target = mine.where((p) => p.id == open!.playerId).single;
    expect(target.age, lessThanOrEqualTo(Poaching.maxAge));
    expect(await messageKeys(), contains('poach:${target.id}'));
    final message =
        (await c.read(competitionRepositoryProvider).messages(career.id))
            .where((m) => m.category == poachCategory)
            .single;
    expect(poachPlayerIdOf(message.spec), target.id);
    expect(message.title, contains(target.name));

    // Settling again changes nothing while the deadline has not played out.
    final before = await markers();
    await service.settle(career.id);
    expect(await markers(), before);
  });

  test(
    'past the deadline he stays or switches, with word either way',
    () async {
      final target = (await pool(_sanMarino)).first;
      final since = career.inGameDate.subtract(
        const Duration(days: Poaching.maxOpenDays + 10),
      );
      await c.read(internationalRetirementRepositoryProvider).addMarkers(
        career.id,
        0,
        [Poaching.openKind(target.id, _italy, since)],
      );

      final switched = await c.read(poachingServiceProvider).settle(career.id);
      final cases = Poaching.parse(await markers());
      final outcome = cases[target.id]!.outcome;
      expect(outcome, isIn([PoachOutcome.stayed, PoachOutcome.switched]));
      expect(switched, outcome == PoachOutcome.switched);
      expect(await messageKeys(), contains('poachEnd:${target.id}'));
      final inPool = (await pool(_sanMarino)).any((p) => p.id == target.id);
      expect(inPool, outcome != PoachOutcome.switched);
      expect(await c.read(openPoachProvider(career.id).future), isNull);
    },
  );

  test('a promise is kept on record, for the open approach only', () async {
    final target = (await pool(_sanMarino)).first;
    await c.read(internationalRetirementRepositoryProvider).addMarkers(
      career.id,
      0,
      [Poaching.openKind(target.id, _italy, career.inGameDate)],
    );
    final service = c.read(poachingServiceProvider);
    await service.promiseMinutes(career.id, target.id + 1);
    expect(
      (await c.read(openPoachProvider(career.id).future))!.promised,
      isFalse,
    );
    await service.promiseMinutes(career.id, target.id);
    expect(
      (await c.read(openPoachProvider(career.id).future))!.promised,
      isTrue,
    );
  });

  test('an approach on a man no longer his lapses without a word', () async {
    final italian = (await pool(_italy)).first;
    await c.read(internationalRetirementRepositoryProvider).addMarkers(
      career.id,
      0,
      [Poaching.openKind(italian.id, 12, career.inGameDate)],
    );
    expect(await c.read(poachingServiceProvider).settle(career.id), isFalse);
    expect(
      Poaching.parse(await markers())[italian.id]!.outcome,
      PoachOutcome.lapsed,
    );
    expect(await messageKeys(), isNot(contains('poachEnd:${italian.id}')));
  });
}
