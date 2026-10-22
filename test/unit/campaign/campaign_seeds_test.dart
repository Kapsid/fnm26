import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

List<T> _load<T>(String f, T Function(Map<String, Object?>) from) =>
    (jsonDecode(File('assets/data/$f').readAsStringSync()) as List)
        .map((e) => from(e as Map<String, Object?>))
        .toList();

/// The European qualifying draw of cycle 0 for [seed], rebuilt exactly as
/// `CareerService.buildCalendar` does it (the fourth test pins it to the real
/// thing, so a change there breaks this helper loudly).
List<List<int>> euroQualifyingGroups(int seed, List<Nation> nations) =>
    qualifyingGroups(seed, nations, Confederation.europe);

/// [euroQualifyingGroups] for any qualifying confederation.
List<List<int>> qualifyingGroups(
  int seed,
  List<Nation> nations,
  Confederation confederation,
) {
  final members =
      nations.where((n) => n.confederation == confederation).toList()
        ..sort((a, b) => a.ranking.compareTo(b.ranking));
  final field = {
    for (final n in WorldCupHosts.continentalQualifiers(
      confederation: confederation,
      cycle: 0,
      seed: seed,
      nations: nations,
    ))
      n.id,
  };
  final cq = const ScheduleGenerator().generate(
    confederation: confederation,
    nations: members.where((n) => field.contains(n.id)).toList(),
    rngSeed: seed ^ 0 ^ 0xCAFE,
    start: DateTime(2026, 9),
    groupSize: 6,
    windows: (
      start: DateTime(2026, 9),
      deadline: DateTime(2027, 6, 30),
      seed: seed ^ 0xCAFE ^ 0xF1D0,
      fillAll: false,
    ),
  );
  return [for (final g in cq.groups) g.nationIds];
}

void main() {
  final nations = _load('nations.json', Nation.fromJson);

  test('no campaign nation or rival hosts the European Championship', () {
    for (final c in Campaigns.all) {
      final hosts = WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: 0,
        seed: c.rngSeed,
        nations: nations,
      );
      expect(hosts, isNot(contains(c.nationId)), reason: c.id);
      if (c.rivalNationId case final rival?) {
        expect(hosts, isNot(contains(rival)), reason: '${c.id} rival');
      }
    }
  });

  test('Best of Guineas: Equatorial Guinea hosts neither cycle\'s African '
      'Championship', () {
    const def = Campaigns.guineas;
    for (var cycle = 0; cycle < def.cycles; cycle++) {
      final hosts = WorldCupHosts.continentalHostsFor(
        confederation: Confederation.africa,
        cycle: cycle,
        seed: def.rngSeed,
        nations: nations,
      );
      expect(hosts, isNot(contains(def.nationId)), reason: 'cycle $cycle');
    }
  });

  test('Young Finns: Finland hosts neither the World nor the European '
      'Championship in any of its three cycles', () {
    const def = Campaigns.youngFinns;
    expect(def.cycles, 3);
    for (var cycle = 0; cycle < def.cycles; cycle++) {
      final world = WorldCupHosts.hostsFor(
        year: CareerService.worldCupYear(cycle),
        nations: nations,
        seed: def.rngSeed,
      );
      final euro = WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: cycle,
        seed: def.rngSeed,
        nations: nations,
      );
      expect(world, isNot(contains(def.nationId)), reason: 'cycle $cycle');
      expect(euro, isNot(contains(def.nationId)), reason: 'cycle $cycle');
      // So Finland plays the qualifying campaign every cycle.
      expect(
        WorldCupHosts.continentalQualifiers(
          confederation: Confederation.europe,
          cycle: cycle,
          seed: def.rngSeed,
          nations: nations,
        ).map((n) => n.id),
        contains(def.nationId),
        reason: 'cycle $cycle',
      );
    }
  });

  test('Best of Guineas draws Guinea-Bissau into Equatorial Guinea\'s '
      'qualifying group', () {
    const def = Campaigns.guineas;
    final groups = qualifyingGroups(
      def.rngSeed,
      nations,
      Confederation.africa,
    );
    expect(
      groups.where((g) => g.contains(116) && g.contains(124)),
      hasLength(1),
    );
  });

  test('Grudge draws Georgia and Albania into the same qualifying group', () {
    final groups = euroQualifyingGroups(Campaigns.grudge.rngSeed, nations);
    expect(groups.where((g) => g.contains(19) && g.contains(1)), hasLength(1));
  });

  test('Transplant: San Marino is in the qualifying draw', () {
    expect(
      euroQualifyingGroups(
        Campaigns.transplant.rngSeed,
        nations,
      ).expand((g) => g),
      contains(45),
    );
  });

  test('the helper matches the draw a real career stores', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: nations,
            playerList: _load('players.json', Player.fromJson),
          ),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: 19,
                  managerName: 'M',
                  rngSeed: Campaigns.grudge.rngSeed,
                ))
            .valueOrNull!;
    final tables = await c
        .read(competitionRepositoryProvider)
        .tournamentGroupTables(
          career.id,
          CompetitionKind.continentalQualifying,
          confederation: Confederation.europe,
        );
    final stored = [
      for (final t in tables) [for (final s in t.standings) s.nationId]..sort(),
    ];
    expect(
      stored.where((g) => g.contains(19) && g.contains(1)),
      hasLength(1),
    );
    final rebuilt = [
      for (final g in euroQualifyingGroups(Campaigns.grudge.rngSeed, nations))
        [...g]..sort(),
    ];
    expect(
      stored.map((g) => g.join(',')).toSet(),
      rebuilt.map((g) => g.join(',')).toSet(),
    );
  });

  test('Best of Guineas: a real career stores the shared group', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: nations,
            playerList: _load('players.json', Player.fromJson),
          ),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    const def = Campaigns.guineas;
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: def.nationId,
                  managerName: 'M',
                  rngSeed: def.rngSeed,
                ))
            .valueOrNull!;
    final tables = await c
        .read(competitionRepositoryProvider)
        .tournamentGroupTables(
          career.id,
          CompetitionKind.continentalQualifying,
          confederation: Confederation.africa,
        );
    final stored = [
      for (final t in tables) [for (final s in t.standings) s.nationId]..sort(),
    ];
    expect(
      stored.where((g) => g.contains(116) && g.contains(124)),
      hasLength(1),
    );
    final rebuilt = [
      for (final g in qualifyingGroups(
        def.rngSeed,
        nations,
        Confederation.africa,
      ))
        [...g]..sort(),
    ];
    expect(
      stored.map((g) => g.join(',')).toSet(),
      rebuilt.map((g) => g.join(',')).toSet(),
    );
  });
}
