import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';

/// The seed's nations, straight from disk.
final List<Nation> seedNations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

/// The seed's players, expanded into the deep pool the app stores.
final List<Player> seedPlayers = PoolGenerator.expand(
  (jsonDecode(File('assets/data/players.json').readAsStringSync()) as List)
      .map((e) => Player.fromJson(e as Map<String, Object?>))
      .toList(),
  namesByNation: {
    for (final e
        in (jsonDecode(
                  File('assets/data/country_names.json').readAsStringSync(),
                )
                as Map<String, Object?>)
            .entries)
      int.parse(e.key): (
        first: ((e.value! as Map)['first'] as List).cast<String>(),
        sur: ((e.value! as Map)['sur'] as List).cast<String>(),
      ),
  },
);

/// A container over [db] seeded from the real data; with [dormant], the
/// source also supplies Greenland the way `AssetSeedSource` does.
ProviderContainer greenlandContainer(AppDatabase db, {bool dormant = true}) =>
    ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: seedNations,
            playerList: seedPlayers,
            dormantNations: dormant ? DormantNations.all : const [],
            dormantPlayers: dormant ? greenlandPool() : const [],
          ),
        ),
      ],
    );
