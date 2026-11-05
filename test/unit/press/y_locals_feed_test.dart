import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/ui_language.dart' show uiLanguageCodeProvider;
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../../helpers/test_database.dart';

/// The WIRING of Y's local fans (the pure layer is `y_locals_test.dart`):
/// the feed names them from the manager's own nation's lists, in every
/// language, and never after one of his players.
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

  /// The local fans' posts: replies by an account whose surname is on
  /// [nationId]'s lists (no cast name has a space in it).
  List<YPost> localsOf(List<YPost> feed, int nationId) {
    final l = lists[nationId]!;
    final surnames = {...l.sur, ...l.surMore};
    return [
      for (final p in feed)
        if (p.displayName.contains(' ') &&
            surnames.contains(p.displayName.split(' ').last) &&
            p.template == YTemplate.reaction)
          p,
    ];
  }

  for (final language in ['en', 'cs', 'ja', 'vi']) {
    test(
      '$language: a Czech career has Czech fans under its results',
      () async {
        final c = open(language: language);
        final career = await played(c, czechia);
        final feed = (await c.read(yFeedProvider(career.id).future)).posts;
        final mine = localsOf(feed, czechia);
        expect(mine, isNotEmpty, reason: 'local fans post in $language too');
        final given = lists[czechia]!.firstMore.toSet();
        final pool = (await c.read(squadDataProvider(career.id).future))!.pool;
        final playerNames = {for (final p in pool) p.name};
        for (final p in mine) {
          expect(p.voice, YVoice.fan);
          expect(p.replyTo, isNotNull);
          final parts = p.displayName.split(' ');
          expect(given, contains(parts.sublist(0, parts.length - 1).join(' ')));
          expect(playerNames, isNot(contains(p.displayName)));
        }
      },
    );
  }

  test(
    'a Japanese career has Japanese fans, and the same ones twice',
    () async {
      final c = open();
      final career = await played(c, japan);
      final feed = (await c.read(yFeedProvider(career.id).future)).posts;
      final mine = localsOf(feed, japan);
      expect(mine, isNotEmpty);
      expect(localsOf(feed, czechia), isEmpty);
      final again = (await open().read(yFeedProvider(career.id).future)).posts;
      expect(
        localsOf(again, japan).map((p) => (p.key, p.handle, p.variant)),
        mine.map((p) => (p.key, p.handle, p.variant)),
      );
    },
  );
}
