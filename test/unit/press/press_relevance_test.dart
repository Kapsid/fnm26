import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/press_providers.dart';

import '../../helpers/test_database.dart';

/// The press conference used to ask two kinds of question a reporter never
/// would: one about a tournament the nation never entered, and one about a
/// defeat the side had already played twice since. Both read as "nelogické
/// tiskovky" — illogical press conferences — and both are about relevance
/// rather than wording.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<Nation> nations;
  late List<Player> players;

  setUpAll(() {
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

  /// A fresh save managing New Zealand: ranked well outside the top twenty (so
  /// no ranking-peak question fires), in a confederation whose cup has not
  /// been drawn yet, and with no fixtures of its own until this test writes
  /// them.
  Future<({AppDatabase db, ProviderContainer container, Career career, int me})>
  aSave() async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final container = ProviderContainer(
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
    final nation = nations.firstWhere((n) => n.code == 'NZL');
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nation.id, managerName: 'M'))
            .valueOrNull!;
    return (
      db: db,
      container: container,
      career: career,
      me: nation.id,
    );
  }

  Future<int> aCompetition(
    AppDatabase db,
    int careerId, {
    required String name,
    required CompetitionKind kind,
    required Confederation confederation,
  }) => db
      .into(db.competitions)
      .insert(
        CompetitionsCompanion.insert(
          careerId: careerId,
          name: name,
          kind: Value(kind),
          confederation: confederation,
          cycle: const Value(0),
        ),
      );

  Future<int> aFixture(
    AppDatabase db,
    int careerId,
    int competitionId, {
    required DateTime date,
    required int home,
    required int away,
    String? round,
    int matchday = 1,
    int? homeScore,
    int? awayScore,
  }) => db
      .into(db.fixtures)
      .insert(
        FixturesCompanion.insert(
          careerId: careerId,
          competitionId: competitionId,
          matchday: matchday,
          date: date,
          homeNationId: home,
          awayNationId: away,
          round: Value(round),
          homeScore: Value(homeScore),
          awayScore: Value(awayScore),
          played: Value(homeScore != null),
        ),
      );

  test(
    'a tournament the nation has no fixture in is not a press question',
    () async {
      final save = await aSave();
      final comp = save.container.read(competitionRepositoryProvider);
      final now = save.career.inGameDate;

      // A continental cup on the other side of the world: New Zealand has no
      // fixture in it, has never had one, and yet the roll of honour credits
      // it with the trophy. That is exactly the shape of a seeded or
      // world-simmed record, and it used to be put to the manager as his own.
      final others = nations
          .where((n) => n.confederation == Confederation.southAmerica)
          .take(4)
          .toList();
      final cup = (await comp.competitionNames(save.career.id)).entries
          .firstWhere((e) => e.value == 'South America Cup')
          .key;
      await comp.recordHonour(
        careerId: save.career.id,
        year: now.year,
        competition: 'South America Cup',
        championId: save.me,
        runnerUpId: others.first.id,
      );
      // Its semi-final has been played and its next group game is a fortnight
      // away — the two situations that produce an elimination question and a
      // tournament preview for the sides that ARE in it.
      await aFixture(
        save.db,
        save.career.id,
        cup,
        date: now.subtract(const Duration(days: 10)),
        home: others[0].id,
        away: others[1].id,
        round: 'CSF',
        homeScore: 2,
        awayScore: 0,
      );
      await aFixture(
        save.db,
        save.career.id,
        cup,
        date: now.add(const Duration(days: 14)),
        home: others[2].id,
        away: others[3].id,
        round: 'CGROUP',
      );
      // One friendly of his own, so this is a manager who has taken charge of
      // a match — the day-one guard is a different rule and not what is under
      // test here.
      final friendlies = await aCompetition(
        save.db,
        save.career.id,
        name: 'Friendlies',
        kind: CompetitionKind.friendly,
        confederation: Confederation.oceania,
      );
      await aFixture(
        save.db,
        save.career.id,
        friendlies,
        date: now.subtract(const Duration(days: 12)),
        home: save.me,
        away: others.first.id,
        round: 'FRIENDLY',
        homeScore: 1,
        awayScore: 1,
      );

      final q = await save.container.read(
        pressQuestionProvider(save.career.id).future,
      );
      expect(
        q?.topic,
        isNot(
          anyOf(
            PressTopic.triumph,
            PressTopic.elimination,
            PressTopic.tournamentPreview,
          ),
        ),
        reason:
            'asked about a tournament the nation never entered '
            '(${q?.key})',
      );
    },
  );

  test('a defeat two competitive matches ago is no longer news', () async {
    final save = await aSave();
    final now = save.career.inGameDate;
    final opponents = nations
        .where((n) => n.id != save.me)
        .take(3)
        .toList();
    final quali = await aCompetition(
      save.db,
      save.career.id,
      name: 'World Championship Qualifying',
      kind: CompetitionKind.worldCupQualifying,
      confederation: Confederation.oceania,
    );
    // Beaten 3-0 twenty-five days ago: well inside [Press.askWindowDays]…
    final defeat = await aFixture(
      save.db,
      save.career.id,
      quali,
      date: now.subtract(const Duration(days: 25)),
      home: save.me,
      away: opponents[0].id,
      homeScore: 0,
      awayScore: 3,
    );
    // …and two competitive matches have been played since.
    await aFixture(
      save.db,
      save.career.id,
      quali,
      date: now.subtract(const Duration(days: 16)),
      home: save.me,
      away: opponents[1].id,
      homeScore: 2,
      awayScore: 0,
    );
    await aFixture(
      save.db,
      save.career.id,
      quali,
      date: now.subtract(const Duration(days: 6)),
      home: save.me,
      away: opponents[2].id,
      homeScore: 2,
      awayScore: 0,
    );

    final q = await save.container.read(
      pressQuestionProvider(save.career.id).future,
    );
    expect(q?.key, isNot('defeat:$defeat'));
    expect(
      q?.topic,
      isNot(PressTopic.heavyDefeat),
      reason: 'still being asked about a defeat two matches ago',
    );
  });

  test('a defeat with nothing played since is still news', () async {
    final save = await aSave();
    final now = save.career.inGameDate;
    final opponent = nations.firstWhere((n) => n.id != save.me);
    final quali = await aCompetition(
      save.db,
      save.career.id,
      name: 'World Championship Qualifying',
      kind: CompetitionKind.worldCupQualifying,
      confederation: Confederation.oceania,
    );
    final defeat = await aFixture(
      save.db,
      save.career.id,
      quali,
      date: now.subtract(const Duration(days: 25)),
      home: save.me,
      away: opponent.id,
      homeScore: 0,
      awayScore: 3,
    );

    final q = await save.container.read(
      pressQuestionProvider(save.career.id).future,
    );
    expect(q?.topic, PressTopic.heavyDefeat);
    expect(q?.key, 'defeat:$defeat');
  });
}
