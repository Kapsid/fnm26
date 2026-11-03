import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

const int _italy = 26;
const int _sanMarino = 45;

/// Owner, 1.0.9: "the press asks about a player but the name is left out:
/// 'If  is not at his best, does the side have anything?'". The preview's
/// key man is the best of the called-up squad, naturalised men included; the
/// names were read from the nation's own players only.
void main() {
  test('a naturalised key man is named in the press conference', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    List<T> load<T>(String f, T Function(Map<String, Object?>) from) =>
        (jsonDecode(File('assets/data/$f').readAsStringSync()) as List)
            .map((e) => from(e as Map<String, Object?>))
            .toList();
    final c = ProviderContainer(
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
    final Career career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: _sanMarino, managerName: 'M', rngSeed: 7))
            .valueOrNull!;
    final star =
        (await c
                .read(playerRepositoryProvider)
                .byNation(
                  _italy,
                  agingYears: CareerService.agingYears(career),
                  saveSeed: career.rngSeed,
                  careerId: career.id,
                ))
            .first;
    final repo = c.read(careerRepositoryProvider);
    await repo.addNaturalizationOffer(
      careerId: career.id,
      playerId: star.id,
      sourceNationId: _italy,
      cycle: 0,
    );
    await repo.setNaturalizationStatus(career.id, star.id, 'accepted');

    // The nation's own players never held him: that read alone was the bug.
    final own = await c
        .read(playerRepositoryProvider)
        .byNation(
          _sanMarino,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
          careerId: career.id,
          minAge: 15,
        );
    expect(own.any((p) => p.id == star.id), isFalse);
    final names = await c.read(conferenceServiceProvider).namesFor(career, {
      star.id,
    });
    expect(names[star.id], star.name);
  });
}
