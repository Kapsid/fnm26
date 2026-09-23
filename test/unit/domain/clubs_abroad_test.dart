import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../helpers/test_database.dart';

/// Where a nation's players ply their trade. Retention is measured data per
/// country ([Clubs.homeRetention]), not a formula off league strength — France
/// is a top league that exports its whole team, Mexico a mid one that keeps
/// everybody, and no tier ordering expresses both.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late Map<String, int> idByCode;

  setUp(() async {
    db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    idByCode = {for (final n in nations) n.code.toLowerCase(): n.id};
    final players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
  });

  /// The nation's strongest twenty-three, as they would be named.
  Future<List<Player>> squadOf(String code) async {
    final pool =
        await container
              .read(playerRepositoryProvider)
              .byNation(idByCode[code]!, saveSeed: 9)
          ..sort((a, b) => b.overall.compareTo(a.overall));
    return pool.take(23).toList();
  }

  test(
    'a strong exporting nation sends most of its best players abroad',
    () async {
      final squad = await squadOf('bra');
      final abroad = squad.where((p) => p.clubCountry != 'bra').length;
      expect(abroad / squad.length, greaterThan(0.6));
    },
  );

  test('France exports too — a top league is not a retentive one', () async {
    final squad = await squadOf('fra');
    final abroad = squad.where((p) => p.clubCountry != 'fra').length;
    expect(abroad / squad.length, greaterThan(0.5));
  });

  test('a strong-domestic nation still keeps most of its own', () async {
    // The guard: loosening retention must not empty England's own league.
    final squad = await squadOf('eng');
    final home = squad.where((p) => p.clubCountry == 'eng').length;
    expect(home / squad.length, greaterThan(0.5));
  });

  test('a mid-tier league that keeps its players still does', () async {
    final squad = await squadOf('mex');
    final home = squad.where((p) => p.clubCountry == 'mex').length;
    expect(home / squad.length, greaterThan(0.5));
  });

  group('the transfer feed names a move abroad', () {
    final en = lookupAppLocalizations(const Locale('en'));
    test('a move across a border names the country', () {
      expect(
        transferDestination(
          en,
          club: 'Madrid White',
          toCountryName: 'Spain',
          crossedBorder: true,
        ),
        'Madrid White in Spain',
      );
    });

    test('a move across town does not', () {
      expect(
        transferDestination(
          en,
          club: 'Man Blue',
          toCountryName: 'England',
          crossedBorder: false,
        ),
        'Man Blue',
      );
    });

    test('an unknown country is simply left unsaid', () {
      expect(
        transferDestination(
          en,
          club: 'Somewhere',
          toCountryName: null,
          crossedBorder: true,
        ),
        'Somewhere',
      );
    });
  });
}
