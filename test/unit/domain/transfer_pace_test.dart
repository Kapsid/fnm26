@Tags(['slow'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/club/transfer_window.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

// How many internationals change club in a year, read the way the transfer
// window reads it (`TransferWindow.moves` over the nation's pool a year
// apart), in a career created now. A real football world moves roughly 15 to
// 25% of its internationals a year. The pace is the clubs' own; whether the
// manager is TOLD is transfer_windows_story_test.

const List<String> _codes = [
  'BRA', 'ENG', 'FRA', 'GER', 'ESP', 'MEX', 'JPN', 'NGA', 'CZE', 'NOR', //
  'USA', 'MAR', 'ARG', 'KOR', 'SEN', 'POL', 'ECU', 'AUS', 'TUN', 'SCO',
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a share of every pool moves club each year', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final base =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    final namesRaw =
        jsonDecode(File('assets/data/country_names.json').readAsStringSync())
            as Map<String, Object?>;
    final players = PoolGenerator.expand(
      base,
      namesByNation: {
        for (final e in namesRaw.entries)
          int.parse(e.key): (
            first: ((e.value! as Map)['first'] as List).cast<String>(),
            sur: ((e.value! as Map)['sur'] as List).cast<String>(),
          ),
      },
    );
    final db = createTestDatabase();
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
    addTearDown(db.close);
    await c.read(seedLoaderProvider).ensureSeeded();
    final byCode = {for (final n in nations) n.code: n};
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: byCode['NOR']!.id,
                  managerName: 'M',
                  rngSeed: 4242,
                ))
            .valueOrNull!;
    final repo = c.read(playerRepositoryProvider);

    const years = 12;
    var squadMoves = 0;
    var squadSeen = 0;
    var abroad = 0;
    final perWindow = <int>[];
    for (final code in _codes) {
      final id = byCode[code]!.id;
      Future<List<Player>> poolAt(int y) => repo.byNation(
        id,
        agingYears: y,
        saveSeed: career.rngSeed,
        careerId: career.id,
      );
      var before = await poolAt(0);
      for (var y = 1; y <= years; y++) {
        final after = await poolAt(y);
        final moves = TransferWindow.moves(before, after);
        perWindow.add(moves.length);
        final moved = {for (final m in moves) m.now.id: m.was};
        final was = {for (final p in before) p.id};
        // The internationals: the nation's best 26 this year.
        final squad =
            (after.where((p) => was.contains(p.id)).toList()
                  ..sort((a, b) => b.overall.compareTo(a.overall)))
                .take(26);
        for (final p in squad) {
          squadSeen++;
          if (moved[p.id] case final w?) {
            squadMoves++;
            if (w.clubCountry != p.clubCountry) abroad++;
          }
        }
        before = after;
      }
    }
    perWindow.sort();
    final share = squadMoves / squadSeen;
    // A measurement: the numbers are the point of running it.
    // ignore: avoid_print
    print(
      'internationals moving club a year: ${(100 * share).toStringAsFixed(1)}%'
      ' (${(100 * abroad / squadMoves).round()}% between countries); '
      'moves per window: median ${perWindow[perWindow.length ~/ 2]}, '
      'max ${perWindow.last}',
    );
    expect(share, inInclusiveRange(0.15, 0.25));
    // A window reads as a report, not a flood.
    expect(perWindow[perWindow.length ~/ 2], lessThanOrEqualTo(25));
  });
}
