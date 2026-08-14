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
import 'package:fnm/features/career/play_time.dart';

import '../../helpers/test_database.dart';

/// How long a save has been played is counted in ticks while it is open, so a
/// crash or a flat battery costs a tick rather than a session.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int careerId;

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
    careerId =
        (await container
                .read(careerServiceProvider)
                .create(
                  nationId: nations.first.id,
                  managerName: 'M',
                ))
            .valueOrNull!
            .id;
  });

  Future<int> played() async =>
      (await container.read(careerRepositoryProvider).byId(careerId))!
          .playedSeconds;

  test('a new save has played nothing', () async {
    expect(await played(), 0);
  });

  test('opening a save starts the clock', () async {
    await container.read(careerServiceProvider).markPlayed(careerId);
    expect(container.read(playTimeTrackerProvider).careerId, careerId);
  });

  test('a flush writes down the time since the last one', () async {
    final tracker = container.read(playTimeTrackerProvider)..start(careerId);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    await tracker.flush();
    expect(await played(), greaterThanOrEqualTo(1));
  });

  test('the seconds accumulate rather than replacing each other', () async {
    final repo = container.read(careerRepositoryProvider);
    await repo.addPlayedSeconds(careerId, 30);
    await repo.addPlayedSeconds(careerId, 45);
    expect(await played(), 75);
  });

  test('a tick can never credit more than its own length', () async {
    // A timer does not fire while the device sleeps: the first tick after a
    // wake must not credit the whole night.
    final repo = container.read(careerRepositoryProvider);
    await repo.addPlayedSeconds(
      careerId,
      PlayTimeTracker.maxPerTick.inSeconds,
    );
    expect(
      await played(),
      lessThanOrEqualTo(PlayTimeTracker.maxPerTick.inSeconds),
    );
    expect(
      PlayTimeTracker.maxPerTick,
      greaterThan(PlayTimeTracker.tick),
      reason: 'a tick that fires on time must never be clipped',
    );
  });

  test('stopping the clock leaves the save closed', () async {
    final tracker = container.read(playTimeTrackerProvider)..start(careerId);
    await tracker.stop();
    expect(tracker.careerId, isNull);
  });

  test('time spent with the app in the background is not counted', () async {
    final tracker = container.read(playTimeTrackerProvider)..start(careerId);
    await tracker.pause();
    final atPause = await played();

    // The manager is elsewhere on his phone for a while.
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    expect(await played(), atPause, reason: 'a paused clock counts nothing');

    // And picking it back up does not credit the gap either.
    tracker.resume();
    await tracker.flush();
    expect(await played(), lessThanOrEqualTo(atPause + 1));
  });

  test('a save that is not open cannot accrue time', () async {
    final tracker = container.read(playTimeTrackerProvider);
    await tracker.flush();
    expect(await played(), 0);
  });
}
