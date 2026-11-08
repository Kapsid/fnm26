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
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../../helpers/test_database.dart';

/// Tester, 1.0.9: "Keep seeing the same player injured after every game on
/// the Y comments. 'No Graeme Duarte for a while', not in my side." The
/// world simulation injures every nation's men, and the feed took the first
/// injured man of the whole world. 1.0.9 narrowed it to his own nation, but
/// the post still read the absence table "now" and hung it on the newest
/// result, so a long-term absentee came back after every match. An injury is
/// now posted from the match it happened in, once.
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

  List<YPost> blows(List<YPost> feed) => [
    for (final p in feed)
      if (p.template == YTemplate.injuryBlow) p,
  ];

  Future<List<Player>> squadOf(
    ProviderContainer c,
    Career career,
    int nationId,
  ) => c
      .read(playerRepositoryProvider)
      .byNation(
        nationId,
        agingYears: CareerService.agingYears(career),
        saveSeed: career.rngSeed,
        careerId: career.id,
      );

  test('a long injury on the books is not posted after every match', () async {
    // Existing saves: an absence row with months left and no match behind
    // it in this feed. It used to be hung on whatever result was newest, so
    // it came back after every game.
    final c = open();
    final career = await played(c, czechia);
    final own = (await squadOf(c, career, czechia)).first;
    final foreigner = (await squadOf(c, career, japan)).first;
    await c.read(absenceRepositoryProvider).replace(career.id, [
      PlayerAbsence(playerId: own.id, injuryMatches: 30),
      PlayerAbsence(playerId: foreigner.id, injuryMatches: 30),
    ]);
    final feed = (await c.read(yFeedProvider(career.id).future)).posts;
    expect(blows(feed), isEmpty);
  });

  test('an injury is posted once, on the match it happened in, and only '
      'for his own men', () async {
    final c = open();
    final career = await played(c, czechia);
    final comp = c.read(competitionRepositoryProvider);
    final fixtures = (await comp.fixturesForNation(career.id, czechia))
      ..sort((a, b) => a.date.compareTo(b.date));
    final hurtIn = fixtures[2];
    final opponent = hurtIn.homeNationId == czechia
        ? hurtIn.awayNationId
        : hurtIn.homeNationId;
    final own = (await squadOf(c, career, czechia)).first;
    final theirs = (await squadOf(c, career, opponent)).first;
    final faraway = (await squadOf(c, career, japan)).first;
    IncidentRecord knock(int fixtureId, int nationId, int playerId) => (
      careerId: career.id,
      fixtureId: fixtureId,
      nationId: nationId,
      playerId: playerId,
      minute: 30,
      type: MatchEventType.injury,
      secondYellow: false,
    );
    await comp.recordIncidents(career.id, hurtIn.id, [
      knock(hurtIn.id, czechia, own.id),
      knock(hurtIn.id, opponent, theirs.id),
    ]);
    // A Japanese man hurt somewhere in the world simulation.
    final elsewhere = (await comp.fixturesForNation(career.id, japan)).first;
    await comp.recordIncidents(career.id, elsewhere.id, [
      knock(elsewhere.id, japan, faraway.id),
    ]);
    // And still out, months on: the absence table must not re-post him.
    await c.read(absenceRepositoryProvider).replace(career.id, [
      PlayerAbsence(playerId: own.id, injuryMatches: 30),
      PlayerAbsence(playerId: faraway.id, injuryMatches: 30),
    ]);

    final feed = (await c.read(yFeedProvider(career.id).future)).posts;
    final posted = blows(feed);
    expect(posted, hasLength(1), reason: 'once, not after every match');
    expect(posted.single.args.first, own.name);
    expect(posted.single.date, hurtIn.date);
    for (final p in feed) {
      expect(p.args, isNot(contains(faraway.name)));
    }
  });
}
