import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seeded_save.dart' show settle;
import '../helpers/test_database.dart';
import 'capture.dart';

void main() {
  testWidgets('smoke', (tester) async {
    await tester.runAsync(loadMaterialIcons);
    setPhone(tester);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final nations = (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
        .map((e) => Nation.fromJson(e as Map<String, Object?>)).toList();
    final players = (jsonDecode(File('assets/data/players.json').readAsStringSync()) as List)
        .map((e) => Player.fromJson(e as Map<String, Object?>)).toList();
    final cities = {
      for (final e in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync()) as Map<String, Object?>).entries)
        int.parse(e.key): (e.value! as List).cast<String>(),
    };
    final db = createTestDatabase();
    final c = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => true),
      matchAttemptSaltProvider.overrideWithValue(() => 0),
      seedSourceProvider.overrideWithValue(InMemorySeedSource(nationList: nations, playerList: players)),
      formFactorProvider.overrideWithValue(FormFactor.phone),
      countryCitiesProvider.overrideWith((ref) async => cities),
    ]);
    addTearDown(db.close);
    addTearDown(c.dispose);
    late int id;
    await tester.runAsync(() async {
      await c.read(seedLoaderProvider).ensureSeeded();
      id = (await c.read(careerServiceProvider).create(nationId: 14, managerName: 'Martin Urbanczyk', rngSeed: 7)).valueOrNull!.id;
    });
    await pumpApp(tester, c, '${Routes.hub}?careerId=$id');
    await settle(tester);
    await shoot(tester, 'smoke_hub');
    await tester.pumpWidget(const SizedBox());
  });
}
