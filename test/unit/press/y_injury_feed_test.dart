import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/ui_language.dart' show uiLanguageCodeProvider;
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../../helpers/test_database.dart';

/// Tester, 1.0.9: "Keep seeing the same player injured after every game on
/// the Y comments. 'No Graeme Duarte for a while', not in my side." The
/// world simulation injures every nation's men, and the feed took the first
/// injured man of the whole world.
void main() {
  late AppDatabase db;
  late List<Nation> nations;
  late List<Player> players;
  late Map<int, NameLists> lists;

  const czechia = 12;
  const japan = 170;

  ProviderContainer open({String language = 'en'}) {
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        uiLanguageCodeProvider.overrideWithValue(language),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: nations,
            playerList: players,
            nameListMap: lists,
          ),
        ),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() async {
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
    final classic =
        jsonDecode(File('assets/data/country_names.json').readAsStringSync())
            as Map<String, Object?>;
    final more =
        jsonDecode(
              File('assets/data/country_names_more.json').readAsStringSync(),
            )
            as Map<String, Object?>;
    List<String> read(Object? m, String key) =>
        (((m as Map?)?[key] as List?) ?? const []).cast<String>();
    lists = {
      for (final id in [czechia, japan])
        id: (
          first: read(classic['$id'], 'first'),
          firstMore: read(more['$id'], 'firstMore'),
          sur: read(classic['$id'], 'sur'),
          surLate: read(classic['$id'], 'surLate'),
          surMore: read(more['$id'], 'surMore'),
        ),
    };
    await open().read(seedLoaderProvider).ensureSeeded();
  });

  /// A career for [nationId] with its first eight fixtures played.
  Future<Career> played(ProviderContainer c, int nationId) async {
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nationId, managerName: 'M', rngSeed: 20301))
            .valueOrNull!;
    final comp = c.read(competitionRepositoryProvider);
    final fixtures = (await comp.fixturesForNation(career.id, nationId))
      ..sort((a, b) => a.date.compareTo(b.date));
    var i = 0;
    for (final f in fixtures.take(8)) {
      final home = f.homeNationId == nationId;
      // A spread of results, so ordinary and big nights both turn up.
      final (us, them) = [(2, 1), (0, 0), (0, 3), (4, 0)][i++ % 4];
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: home ? us : them,
        awayScore: home ? them : us,
      );
    }
    return career;
  }

  test('the injury post names only his own men', () async {
    final c = open();
    final career = await played(c, czechia);
    Future<Player> first(int nationId) async =>
        (await c
                .read(playerRepositoryProvider)
                .byNation(
                  nationId,
                  agingYears: CareerService.agingYears(career),
                  saveSeed: career.rngSeed,
                  careerId: career.id,
                ))
            .first;
    final foreigner = await first(japan);
    await c.read(absenceRepositoryProvider).replace(career.id, [
      PlayerAbsence(playerId: foreigner.id, injuryMatches: 9),
    ]);
    List<YPost> blows(List<YPost> feed) => [
      for (final p in feed)
        if (p.template == YTemplate.injuryBlow) p,
    ];
    var feed = (await c.read(yFeedProvider(career.id).future)).posts;
    expect(
      blows(feed).where((p) => p.args.contains(foreigner.name)),
      isEmpty,
      reason: 'a Japanese man is no Czech injury',
    );

    // One of his own hurt as well: he is the one the post is about.
    final own = await first(czechia);
    await c.read(absenceRepositoryProvider).replace(career.id, [
      PlayerAbsence(playerId: foreigner.id, injuryMatches: 9),
      PlayerAbsence(playerId: own.id, injuryMatches: 3),
    ]);
    c.invalidate(yFeedProvider);
    feed = (await c.read(yFeedProvider(career.id).future)).posts;
    for (final p in blows(feed)) {
      expect(p.args, [own.name]);
    }
  });
}
