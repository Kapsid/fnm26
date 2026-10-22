import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/schedule_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

void main() {
  late ProviderContainer c;
  late int careerId;
  late int cycle;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    List<T> load<T>(String f, T Function(Map<String, Object?>) from) =>
        (jsonDecode(File('assets/data/$f').readAsStringSync()) as List)
            .map((e) => from(e as Map<String, Object?>))
            .toList();
    final nations = load('nations.json', Nation.fromJson);
    final players = load('players.json', Player.fromJson);
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final europe =
        nations.where((n) => n.confederation == Confederation.europe).toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking));
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: europe[10].id, managerName: 'M', rngSeed: 7))
            .valueOrNull!;
    careerId = career.id;
    cycle = career.cyclePointer;
  });

  Future<ScheduleData> reread() async {
    c.invalidate(hubDataProvider(careerId));
    final d = await c.read(scheduleProvider(careerId).future);
    return d!;
  }

  test('blocks cover the cycle and current is the first window', () async {
    final d = (await c.read(scheduleProvider(careerId).future))!;
    expect(d.blocks, isNotEmpty);
    expect(d.currentIndex, 0);
  });

  test('recording the first window moves current on', () async {
    final d0 = (await c.read(scheduleProvider(careerId).future))!;
    final comp = c.read(competitionRepositoryProvider);
    for (final f in d0.blocks[0].fixtures) {
      await comp.recordResult(fixtureId: f.id, homeScore: 1, awayScore: 0);
    }
    c.invalidate(hubDataProvider(careerId));
    final d = (await c.read(scheduleProvider(careerId).future))!;
    expect(d.currentIndex, 1);
  });

  test('a qualifier is hidden until its draw is watched', () async {
    final d = (await c.read(scheduleProvider(careerId).future))!;
    final q = d.blocks
        .expand((b) => b.fixtures)
        .firstWhere(
          (f) => f.round == 'CQ',
        );
    expect(opponentKnown(d, q), isFalse);
    await c
        .read(competitionRepositoryProvider)
        .markDrawWatched(careerId, cycle, continentalQualDrawKind);
    expect(opponentKnown(await reread(), q), isTrue);
  });
}
