import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/match/setup_warning.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// "No captain named" when one plainly is.
///
/// `captainProvider` returns null for two different situations — nobody was
/// ever given the armband, and the man who has it cannot play — and the
/// pre-match strip reported both with the same sentence. A captain of six
/// years who pulled a hamstring, or who was left out of the squad that a cycle
/// rollover re-picked for him, was announced as never having been named.
void main() {
  // squadSetupProvider reaches the set-piece takers, which live in
  // SharedPreferences — so the binding has to exist before any of this runs.
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  late AppDatabase db;
  late List<Nation> nations;
  late List<Player> players;

  ProviderContainer open() {
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

  setUp(() {
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
  });

  test('a named captain who cannot play is not reported as unnamed', () async {
    final c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;

    final pool = (await c.read(squadDataProvider(career.id).future))!.pool;
    final skipper = pool.first;
    await c.read(careerRepositoryProvider).setCaptain(career.id, skipper.id);

    // Name a squad he is NOT in — exactly what a rollover's re-pick can do.
    final without = pool.skip(1).take(kMinSquadSize).map((p) => p.id).toSet();
    expect(
      await c.read(squadServiceProvider).setCallUps(career.id, without),
      isTrue,
    );
    c
      ..invalidate(captainProvider)
      ..invalidate(careerByIdProvider)
      ..invalidate(squadDataProvider)
      ..invalidate(squadSetupProvider);

    final setup = await c.read(squadSetupProvider(career.id).future);
    expect(
      setup.captain,
      CaptainIssue.unavailable,
      reason: 'he IS named, he just cannot lead this one out',
    );
    expect(
      setup.captain,
      isNot(CaptainIssue.unnamed),
      reason: 'telling him nobody is captain reads as a lost setting',
    );
  });

  test('a save with nobody named at all still says so', () async {
    final c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    final setup = await c.read(squadSetupProvider(career.id).future);
    expect(setup.captain, CaptainIssue.unnamed);
  });

  test('a fit captain in the squad raises nothing', () async {
    final c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    final squad = (await c.read(squadDataProvider(career.id).future))!;
    // Somebody the auto-picked squad actually contains.
    final skipper = squad.pool.firstWhere((p) => squad.callUps.contains(p.id));
    await c.read(careerRepositoryProvider).setCaptain(career.id, skipper.id);
    c
      ..invalidate(captainProvider)
      ..invalidate(careerByIdProvider)
      ..invalidate(squadSetupProvider);

    expect(
      (await c.read(squadSetupProvider(career.id).future)).captain,
      isNull,
      reason: 'nothing is wrong with the armband',
    );
  });

  test('a captain left out of a named squad still loses the armband', () async {
    // The other half of the rule: once call-ups EXIST they are honoured, so
    // the fix must not turn the check off altogether.
    final c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    final pool = (await c.read(squadDataProvider(career.id).future))!.pool;
    final dropped = pool.first;
    final named = pool.skip(1).take(kMinSquadSize).map((p) => p.id).toSet();

    await c.read(careerRepositoryProvider).setCaptain(career.id, dropped.id);
    expect(
      await c.read(squadServiceProvider).setCallUps(career.id, named),
      isTrue,
    );
    c
      ..invalidate(captainProvider)
      ..invalidate(careerByIdProvider)
      ..invalidate(squadDataProvider);

    expect(
      await c.read(captainProvider(career.id).future),
      isNull,
      reason: 'a man who is not in the squad cannot lead it out',
    );
  });
}
