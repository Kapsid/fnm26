import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../../helpers/test_database.dart';

/// The press open the match report.
///
/// Every topic before these four read the scoreboard: a conference was the
/// same conference with a different number in it, which is what "the press is
/// too general" meant. These read what HAPPENED — a man sent off, a man hurt,
/// twelve yards, the last ten minutes — and each has to fire when it should
/// and stay quiet when it should not.
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
    return (db: db, container: container, career: career, me: nation.id);
  }

  Future<int> aCompetition(AppDatabase db, int careerId) => db
      .into(db.competitions)
      .insert(
        CompetitionsCompanion.insert(
          careerId: careerId,
          name: 'World Championship Qualifying',
          kind: const Value(CompetitionKind.worldCupQualifying),
          confederation: Confederation.oceania,
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
    required int homeScore,
    required int awayScore,
    String? round,
    int? homePenalties,
    int? awayPenalties,
  }) => db
      .into(db.fixtures)
      .insert(
        FixturesCompanion.insert(
          careerId: careerId,
          competitionId: competitionId,
          matchday: 1,
          date: date,
          homeNationId: home,
          awayNationId: away,
          round: Value(round),
          homeScore: Value(homeScore),
          awayScore: Value(awayScore),
          played: const Value(true),
          homePenalties: Value(homePenalties),
          awayPenalties: Value(awayPenalties),
        ),
      );

  /// One of the manager's own players, so a question can name him.
  int aPlayerOf(int nationId) =>
      players.firstWhere((p) => p.nationId == nationId).id;

  test('a red card in the last match is asked about by name', () async {
    final save = await aSave();
    final now = save.career.inGameDate;
    final opponent = nations.firstWhere((n) => n.id != save.me);
    final comp = save.container.read(competitionRepositoryProvider);
    final competition = await aCompetition(save.db, save.career.id);
    final fixture = await aFixture(
      save.db,
      save.career.id,
      competition,
      date: now.subtract(const Duration(days: 4)),
      home: save.me,
      away: opponent.id,
      homeScore: 1,
      awayScore: 1,
    );
    final man = aPlayerOf(save.me);
    await comp.recordIncidents(save.career.id, fixture, [
      (
        careerId: save.career.id,
        fixtureId: fixture,
        nationId: save.me,
        playerId: man,
        minute: 34,
        type: MatchEventType.redCard,
        secondYellow: true,
      ),
    ]);

    final q = await save.container.read(
      pressQuestionProvider(save.career.id).future,
    );
    expect(q?.topic, PressTopic.sendingOff);
    final subject = q!.subject;
    expect(subject, isA<PressSubjectIncident>());
    subject as PressSubjectIncident;
    expect(subject.minute, 34);
    expect(subject.playerId, man);
    expect(
      subject.name,
      isNotEmpty,
      reason: 'a question that cannot name him is the generality this ends',
    );
  });

  test('a clean match draws no sending-off question', () async {
    final save = await aSave();
    final now = save.career.inGameDate;
    final opponent = nations.firstWhere((n) => n.id != save.me);
    final competition = await aCompetition(save.db, save.career.id);
    await aFixture(
      save.db,
      save.career.id,
      competition,
      date: now.subtract(const Duration(days: 4)),
      home: save.me,
      away: opponent.id,
      homeScore: 1,
      awayScore: 1,
    );

    final q = await save.container.read(
      pressQuestionProvider(save.career.id).future,
    );
    expect(q?.topic, isNot(PressTopic.sendingOff));
  });

  test('a red card two matches ago is stale', () async {
    final save = await aSave();
    final now = save.career.inGameDate;
    final others = nations.where((n) => n.id != save.me).take(2).toList();
    final comp = save.container.read(competitionRepositoryProvider);
    final competition = await aCompetition(save.db, save.career.id);
    final old = await aFixture(
      save.db,
      save.career.id,
      competition,
      date: now.subtract(const Duration(days: 20)),
      home: save.me,
      away: others[0].id,
      homeScore: 1,
      awayScore: 1,
    );
    await aFixture(
      save.db,
      save.career.id,
      competition,
      date: now.subtract(const Duration(days: 4)),
      home: save.me,
      away: others[1].id,
      homeScore: 1,
      awayScore: 1,
    );
    await comp.recordIncidents(save.career.id, old, [
      (
        careerId: save.career.id,
        fixtureId: old,
        nationId: save.me,
        playerId: aPlayerOf(save.me),
        minute: 34,
        type: MatchEventType.redCard,
        secondYellow: false,
      ),
    ]);

    final q = await save.container.read(
      pressQuestionProvider(save.career.id).future,
    );
    expect(
      q?.topic,
      isNot(PressTopic.sendingOff),
      reason: 'the room has a newer match to ask about',
    );
  });

  group('a knock', () {
    Future<PressQuestion?> hurt({
      required int caps,
      required bool finalsSoon,
    }) async {
      final save = await aSave();
      final now = save.career.inGameDate;
      final opponent = nations.firstWhere((n) => n.id != save.me);
      final comp = save.container.read(competitionRepositoryProvider);
      final competition = await aCompetition(save.db, save.career.id);
      final fixture = await aFixture(
        save.db,
        save.career.id,
        competition,
        date: now.subtract(const Duration(days: 4)),
        home: save.me,
        away: opponent.id,
        homeScore: 1,
        awayScore: 1,
      );
      final man = aPlayerOf(save.me);
      // Appearances are counted one match at a time, exactly as a career
      // accumulates them.
      for (var i = 0; i < caps; i++) {
        await comp.recordAppearances(save.career.id, save.me, [man]);
      }
      await comp.recordIncidents(save.career.id, fixture, [
        (
          careerId: save.career.id,
          fixtureId: fixture,
          nationId: save.me,
          playerId: man,
          minute: 61,
          type: MatchEventType.injury,
          secondYellow: false,
        ),
      ]);
      if (finalsSoon) {
        final finals = await save.db
            .into(save.db.competitions)
            .insert(
              CompetitionsCompanion.insert(
                careerId: save.career.id,
                name: 'World Championship Finals',
                kind: const Value(CompetitionKind.worldCupFinals),
                confederation: Confederation.oceania,
                cycle: const Value(0),
              ),
            );
        await save.db
            .into(save.db.fixtures)
            .insert(
              FixturesCompanion.insert(
                careerId: save.career.id,
                competitionId: finals,
                matchday: 1,
                date: now.add(const Duration(days: 20)),
                homeNationId: save.me,
                awayNationId: opponent.id,
                round: const Value('GROUP'),
              ),
            );
      }
      return save.container.read(
        pressQuestionProvider(save.career.id).future,
      );
    }

    test('to a regular is a question', () async {
      final q = await hurt(caps: 8, finalsSoon: false);
      expect(q?.topic, PressTopic.injuryBlow);
      expect((q!.subject as PressSubjectIncident).name, isNotEmpty);
    });

    test('to a man nobody has heard of is not', () async {
      final q = await hurt(caps: 0, finalsSoon: false);
      expect(q?.topic, isNot(PressTopic.injuryBlow));
    });

    test('to a squad man is a question once a tournament is close', () async {
      final q = await hurt(caps: 1, finalsSoon: true);
      expect(q?.topic, PressTopic.injuryBlow);
    });
  });

  test('a tie settled on penalties is asked about', () async {
    final save = await aSave();
    final now = save.career.inGameDate;
    final opponent = nations.firstWhere((n) => n.id != save.me);
    final competition = await save.db
        .into(save.db.competitions)
        .insert(
          CompetitionsCompanion.insert(
            careerId: save.career.id,
            name: 'World Championship Finals',
            kind: const Value(CompetitionKind.worldCupFinals),
            confederation: Confederation.oceania,
            cycle: const Value(0),
          ),
        );
    await aFixture(
      save.db,
      save.career.id,
      competition,
      date: now.subtract(const Duration(days: 4)),
      home: save.me,
      away: opponent.id,
      homeScore: 1,
      awayScore: 1,
      round: 'QF',
      homePenalties: 4,
      awayPenalties: 3,
    );

    final q = await save.container.read(
      pressQuestionProvider(save.career.id).future,
    );
    expect(q?.topic, PressTopic.shootoutFate);
    expect(q!.subject, isA<PressSubjectOpponent>());
    expect((q.subject as PressSubjectOpponent).nationId, opponent.id);
  });

  group('a late goal', () {
    /// A match won 2-1 with the goals at [minutes], each credited to us when
    /// its entry says so.
    Future<PressQuestion?> withGoals(
      List<({int minute, bool ours})> goals, {
      required int scored,
      required int conceded,
    }) async {
      final save = await aSave();
      final now = save.career.inGameDate;
      final opponent = nations.firstWhere((n) => n.id != save.me);
      final comp = save.container.read(competitionRepositoryProvider);
      final competition = await aCompetition(save.db, save.career.id);
      final fixture = await aFixture(
        save.db,
        save.career.id,
        competition,
        date: now.subtract(const Duration(days: 4)),
        home: save.me,
        away: opponent.id,
        homeScore: scored,
        awayScore: conceded,
      );
      final mine = aPlayerOf(save.me);
      final theirs = aPlayerOf(opponent.id);
      await comp.recordGoals([
        for (final g in goals)
          (
            careerId: save.career.id,
            competitionId: competition,
            fixtureId: fixture,
            nationId: g.ours ? save.me : opponent.id,
            playerId: g.ours ? mine : theirs,
            minute: g.minute,
          ),
      ]);
      return save.container.read(
        pressQuestionProvider(save.career.id).future,
      );
    }

    test('that wins it is a question about the man who scored', () async {
      final q = await withGoals(
        const [
          (minute: 20, ours: false),
          (minute: 88, ours: true),
          (minute: 90, ours: true),
        ],
        scored: 2,
        conceded: 1,
      );
      expect(q?.topic, PressTopic.lateDrama);
      final subject = q!.subject as PressSubjectIncident;
      expect(subject.minute, 90);
      expect(subject.ours, isTrue);
    });

    test('that loses it is the same question the other way up', () async {
      final q = await withGoals(
        const [
          (minute: 12, ours: true),
          (minute: 85, ours: false),
          (minute: 89, ours: false),
        ],
        scored: 1,
        conceded: 2,
      );
      expect(q?.topic, PressTopic.lateDrama);
      final subject = q!.subject as PressSubjectIncident;
      expect(subject.minute, 89);
      expect(subject.ours, isFalse);
    });

    test('that changed nothing is not drama', () async {
      // Three-nil up, and a fourth in the last minute. Nothing turned.
      final q = await withGoals(
        const [
          (minute: 10, ours: true),
          (minute: 30, ours: true),
          (minute: 50, ours: true),
          (minute: 88, ours: true),
        ],
        scored: 4,
        conceded: 0,
      );
      expect(q?.topic, isNot(PressTopic.lateDrama));
    });

    test('in the first hour is not late', () async {
      final q = await withGoals(
        const [
          (minute: 20, ours: false),
          (minute: 55, ours: true),
          (minute: 58, ours: true),
        ],
        scored: 2,
        conceded: 1,
      );
      expect(q?.topic, isNot(PressTopic.lateDrama));
    });
  });

  test('the country posts about the same red card', () async {
    // The other half of one incident. [YFeed.forIncident] has its own unit
    // test; this is the wiring, which is the half that has been missing
    // before — the feed's one-off events had full copy, their own tests and
    // no caller anywhere in the app.
    final save = await aSave();
    final now = save.career.inGameDate;
    final opponent = nations.firstWhere((n) => n.id != save.me);
    final comp = save.container.read(competitionRepositoryProvider);
    final competition = await aCompetition(save.db, save.career.id);
    final fixture = await aFixture(
      save.db,
      save.career.id,
      competition,
      date: now.subtract(const Duration(days: 4)),
      home: save.me,
      away: opponent.id,
      homeScore: 0,
      awayScore: 2,
    );
    final man = aPlayerOf(save.me);
    await comp.recordIncidents(save.career.id, fixture, [
      (
        careerId: save.career.id,
        fixtureId: fixture,
        nationId: save.me,
        playerId: man,
        minute: 34,
        type: MatchEventType.redCard,
        secondYellow: false,
      ),
    ]);

    final feed = await save.container.read(
      yFeedProvider(save.career.id).future,
    );
    final sentOff = feed.posts
        .where((p) => p.template == YTemplate.sentOff)
        .toList();
    expect(
      sentOff,
      isNotEmpty,
      reason: 'the feed never mentioned that the side finished with ten',
    );
    expect(sentOff.first.args.last, '34');
    final name =
        (await save.container
                .read(playerRepositoryProvider)
                .byId(man, agingYears: 0, saveSeed: save.career.rngSeed))!
            .name;
    expect(sentOff.first.args.first, name);
  });

  test('the match leads the conference, not the run of form', () {
    // The ordering the spec asks for, at the level it is decided: with an
    // incident live, the generic team question is filler and does not lead.
    PressQuestion q(PressTopic topic, PressSubject subject) => (
      key: '${Press.keyPrefixOf(topic)}:1',
      topic: topic,
      subject: subject,
      subjectNationId: null,
      options: Press.optionsFor(topic),
    );
    final candidates = [
      q(PressTopic.underPressure, const PressSubjectTeam()),
      q(PressTopic.unbeatenRun, const PressSubjectTeam()),
      q(
        PressTopic.sendingOff,
        const PressSubjectIncident(
          type: MatchEventType.redCard,
          minute: 34,
          name: 'Hayes',
        ),
      ),
    ];
    for (var seed = 0; seed < 40; seed++) {
      expect(Press.pick(candidates, seed: seed)?.topic, PressTopic.sendingOff);
    }
  });
}
