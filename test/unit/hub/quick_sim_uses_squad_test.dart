import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// A match the manager skipped is still played by HIS team.
///
/// Quick-simming used to field the nation's best available 4-3-3 for every side
/// in the world, the manager's own included — so a man he never called up, and
/// an eleven he never named, played his match for him the moment he pressed
/// skip. Skipping is a choice about watching, not about how his side plays.
void main() {
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

  test('a skipped match fields the squad and XI the manager named', () async {
    final c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    final comp = c.read(competitionRepositoryProvider);
    final next = (await comp.nextFixtureForNation(career.id, career.nationId))!;

    final pool =
        (await c
            .read(playerRepositoryProvider)
            .byNation(career.nationId, saveSeed: career.rngSeed))
          ..sort((a, b) {
            final byOverall = b.overall.compareTo(a.overall);
            return byOverall != 0 ? byOverall : a.id.compareTo(b.id);
          });
    // The nation's best player is left out of the squad entirely, and the XI is
    // the eleven WORST men in it — an eleven no automatic selection would ever
    // produce, so nothing about this line-up can be arrived at by accident.
    final leftAtHome = pool.first;
    final squad = pool.skip(1).toList();
    final xi = squad.reversed.take(11).toList();

    await c.read(squadRepositoryProvider).setCallUps(career.id, {
      for (final p in squad) p.id,
    });
    await c
        .read(tacticsRepositoryProvider)
        .saveTactic(
          career.id,
          Tactic(
            formation: Formation.f442,
            lineup: [for (final p in xi) p.id],
          ),
        );

    // Skip: the world (his own fixture included) is quick-simmed up to it.
    await c.read(seasonServiceProvider).advance(career.id);
    final played = (await db.select(db.fixtures).get()).firstWhere(
      (f) => f.id == next.id,
    );
    expect(
      played.played,
      isTrue,
      reason: 'the skipped fixture must actually have been played',
    );

    final appeared = {
      for (final r in await db.select(db.appearances).get())
        if (r.nationId == career.nationId) r.playerId,
    };
    expect(
      appeared,
      isNot(contains(leftAtHome.id)),
      reason: 'a man he never called up cannot play for him',
    );
    for (final p in xi) {
      expect(
        appeared,
        contains(p.id),
        reason: 'the eleven he named must be the eleven that played',
      );
    }
  });
}
