import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/club_history_providers.dart';

import '../../helpers/test_database.dart';

/// "Some players still cycle between two random clubs": a player's club was
/// read off every season's rating, and a rating sitting on the edge of a
/// band or a tier flipped him between the same two clubs window after
/// window, A, B, A, B, on one unbroken deal. And "a retired player still
/// does transfers": his club went on being drawn for every season of the
/// save after his career ended.
///
/// Under the 1.1.4 rule (`clubSettledKind`) a club is read off the season
/// its deal was signed, a new deal avoids his former clubs but for the odd
/// homecoming, and a retired man's club stays the one he finished at. A
/// career from before it keeps every season it has shown.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late List<Nation> nations;
  late List<Player> players;

  /// An app on [db], as a fresh launch opens it.
  ProviderContainer app() {
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

  /// How many seasons of the save to walk: long enough for most of a pool
  /// to sign three or four deals, and for its veterans to retire.
  const years = 20;

  setUp(() async {
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
    container = app();
    await container.read(seedLoaderProvider).ensureSeeded();
  });

  Future<Career> newCareer() async =>
      (await container
              .read(careerServiceProvider)
              .create(
                nationId: nations.first.id,
                managerName: 'M',
                rngSeed: 42,
              ))
          .valueOrNull!;

  /// Everyone who is in one of [codes]' pools at some point of the walk.
  Future<Set<int>> idsOf(Career career, List<String> codes) async {
    final repo = container.read(playerRepositoryProvider);
    return {
      for (final n in nations.where((n) => codes.contains(n.code)))
        for (var y = 0; y <= years; y += 4)
          for (final p in await repo.byNation(
            n.id,
            agingYears: y,
            saveSeed: career.rngSeed,
            careerId: career.id,
          ))
            p.id,
    };
  }

  /// [id]'s club, season by season, as the history card walks it (null for
  /// a season he does not exist in).
  Future<List<String?>> clubsOf(Career career, int id) async {
    final repo = container.read(playerRepositoryProvider);
    return [
      for (var y = 0; y <= years; y++)
        switch (await repo.byId(
          id,
          agingYears: y,
          saveSeed: career.rngSeed,
          careerId: career.id,
        )) {
          null => null,
          final p => '${p.club}|${p.clubCountry}',
        },
    ];
  }

  test('nobody alternates between two clubs, and returns are rare', () async {
    final career = await newCareer();
    final ids = await idsOf(career, const ['CZE', 'ENG', 'BRA', 'JPN']);
    expect(ids.length, greaterThan(400));
    var withReturn = 0;
    var moves = 0;
    for (final id in ids) {
      final repo = container.read(playerRepositoryProvider);
      final spells = <String>[];
      for (var y = 0; y <= years; y++) {
        final p = await repo.byId(
          id,
          agingYears: y,
          saveSeed: career.rngSeed,
          careerId: career.id,
        );
        if (p == null) continue;
        if (PlayerLifecycle.hasRetiredAt(p.id, p.age, y)) break;
        final key = '${p.club}|${p.clubCountry}';
        if (spells.isEmpty || spells.last != key) spells.add(key);
      }
      moves += spells.length - 1;
      var returned = false;
      for (var i = 2; i < spells.length; i++) {
        // The bug: A, B, A, B.
        if (i >= 3) {
          expect(
            [spells[i - 1], spells[i]],
            isNot([spells[i - 3], spells[i - 2]]),
            reason: 'player $id alternates: ${spells.join(' > ')}',
          );
        }
        if (spells.sublist(0, i - 1).contains(spells[i])) returned = true;
      }
      if (returned) withReturn++;
    }
    expect(moves, greaterThan(ids.length), reason: 'too few moves to read');
    // Measured on this save: 18 of 803 players (2%) ever go back to a club
    // they left, in twenty seasons; before the rule it was 105 (13%), 44 of
    // them strictly alternating. A homecoming is real football; a habit is
    // not.
    expect(
      withReturn / ids.length,
      lessThan(0.05),
      reason: '$withReturn of ${ids.length} players returned to a club',
    );
  }, timeout: const Timeout(Duration(minutes: 10)));

  test('a retired player makes no more moves', () async {
    final career = await newCareer();
    // Twenty seasons on, so the card and its end read that far.
    await container
        .read(careerRepositoryProvider)
        .updateInGameDate(career.id, DateTime(2046, 3));
    final repo = container.read(playerRepositoryProvider);
    var retired = 0;
    for (final id in await idsOf(career, const ['CZE', 'BRA'])) {
      final p = await repo.byId(
        id,
        agingYears: years,
        saveSeed: career.rngSeed,
        careerId: career.id,
      );
      if (p == null) continue;
      final last = PlayerLifecycle.lastPlayingSeason(p.id, p.age, years);
      // Retired during the walk, not before it.
      if (last == null || last == 0) continue;
      retired++;
      final clubs = await clubsOf(career, id);
      for (var y = last + 1; y <= years; y++) {
        expect(
          clubs[y],
          clubs[last],
          reason: 'player $id retired after season $last and moved in $y',
        );
      }
      // And his card ends where his career did.
      final spells = await container.read(
        clubHistoryProvider((careerId: career.id, playerId: id)).future,
      );
      expect(
        spells.last.toYear,
        lessThanOrEqualTo(CareerService.cycleStart.year + last),
      );
      expect(
        await container.read(
          clubCareerEndProvider((careerId: career.id, playerId: id)).future,
        ),
        CareerService.cycleStart.year + last + 1,
      );
    }
    expect(retired, greaterThan(10), reason: 'nobody retired to check');
  }, timeout: const Timeout(Duration(minutes: 10)));

  test('an older save keeps every season it has shown', () async {
    final career = await newCareer();
    // A career from before the rule: no mark, standing in its sixth season.
    await (db.delete(db.drawsWatched)..where(
          (t) => t.careerId.equals(career.id) & t.kind.equals(clubSettledKind),
        ))
        .go();
    await container
        .read(careerRepositoryProvider)
        .updateInGameDate(career.id, DateTime(2032, 3));
    // Read by a fresh app, as an upgraded build opens an old save.
    container = app();
    final now = CareerService.agingYears(
      (await container.read(careerRepositoryProvider).byId(career.id))!,
    );
    expect(now, 6);
    final ids = (await idsOf(career, const ['CZE'])).toList();
    final before = {for (final id in ids) id: await clubsOf(career, id)};

    // Opened by 1.1.4: stamped from the next season on, once.
    // (what opening it, CareerService.markPlayed, and every step of its
    // clock ask).
    await container.read(careerServiceProvider).settleClubs(career.id);
    await container
        .read(careerRepositoryProvider)
        .updateInGameDate(career.id, DateTime(2036, 3));
    await container.read(careerServiceProvider).settleClubs(career.id);
    final marks =
        await (db.select(db.drawsWatched)..where(
              (t) =>
                  t.careerId.equals(career.id) & t.kind.equals(clubSettledKind),
            ))
            .get();
    expect([for (final m in marks) m.cycle], [now + 1]);

    for (final id in ids) {
      final after = await clubsOf(career, id);
      final was = before[id]!;
      // Every season up to the one it stood in reads as it did; a retired
      // man's seasons after his career ended are the only exception, as
      // they are the other bug.
      for (var y = 0; y <= now; y++) {
        if (was[y] == null) continue;
        final p = await container
            .read(playerRepositoryProvider)
            .byId(
              id,
              agingYears: y,
              saveSeed: career.rngSeed,
              careerId: career.id,
            );
        if (PlayerLifecycle.hasRetiredAt(p!.id, p.age, y)) continue;
        expect(after[y], was[y], reason: 'player $id, season $y');
      }
    }
  }, timeout: const Timeout(Duration(minutes: 10)));

  test('a club is read off the season its deal was signed', () {
    for (var id = 1; id <= 300; id++) {
      for (var age = 18; age < 34; age++) {
        final signed = ClubService.contractAt(
          id,
          age,
          settledAge: age - 10,
        ).joined;
        // Ten seasons in, a career settled from day one.
        expect(
          ClubService.clubSeason(id, age, 10, 0),
          max(0, 10 - (age - signed)),
        );
        // Settled only from season 8: never read before it.
        expect(
          ClubService.clubSeason(id, age, 10, 8),
          greaterThanOrEqualTo(8),
        );
        // A season before the mark reads itself.
        expect(ClubService.clubSeason(id, age, 7, 8), 7);
      }
      // A boy is read off his first season at the academy.
      expect(
        ClubService.clubSeason(id, 15, 10, 0),
        10 - (15 - PlayerLifecycle.intakeAge),
      );
    }
  });

  test('a retired career ends on its last playing season', () {
    for (var id = 1; id <= 300; id++) {
      final r = PlayerLifecycle.retirementAgeFor(id);
      // Thirty at day one: still playing in season 2, retired by 12.
      expect(PlayerLifecycle.lastPlayingSeason(id, 32, 2), isNull);
      final last = PlayerLifecycle.lastPlayingSeason(id, 30 + 14, 14);
      expect(last, isNotNull);
      expect(
        PlayerLifecycle.hasRetiredAt(id, 30 + last!, last),
        isFalse,
        reason: 'retirement age $r',
      );
      expect(PlayerLifecycle.hasRetiredAt(id, 30 + last + 1, last + 1), isTrue);
    }
  });
}
