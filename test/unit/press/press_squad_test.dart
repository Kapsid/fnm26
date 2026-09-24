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
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../../helpers/test_database.dart';

/// The press read the team sheet.
///
/// [SquadStories] and [OpponentStories] decide WHETHER each of these is a
/// question, and are tested one rule at a time in `squad_stories_test.dart`.
/// This is the other half: that a save with a first cap in it actually reaches
/// the conference with the man's name attached, and that the country posts
/// about the same boy. Batch 1's lesson was that a rule with no caller is
/// worth nothing, and [YFeed.forEvent] sat unused for a whole release.
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

  Future<int> aCompetition(
    AppDatabase db,
    int careerId, {
    String name = 'World Championship Qualifying',
    CompetitionKind kind = CompetitionKind.worldCupQualifying,
  }) => db
      .into(db.competitions)
      .insert(
        CompetitionsCompanion.insert(
          careerId: careerId,
          name: name,
          kind: Value(kind),
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
    int? homeScore,
    int? awayScore,
    String? round,
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
          played: Value(homeScore != null),
        ),
      );

  int aPlayerOf(int nationId) =>
      players.firstWhere((p) => p.nationId == nationId).id;

  group('a first cap', () {
    /// A save whose last match was played by [caps]-capped [man].
    Future<({ProviderContainer container, Career career, int man})> withDebut({
      required int caps,
      bool rated = true,
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
        homeScore: 2,
        awayScore: 1,
      );
      final man = aPlayerOf(save.me);
      for (var i = 0; i < caps; i++) {
        await comp.recordAppearances(save.career.id, save.me, [man]);
      }
      if (rated) {
        await comp.recordPlayerMatchStats(save.career.id, fixture, [
          (
            playerId: man,
            nationId: save.me,
            rating: 6.8,
            goals: 0,
            assists: 0,
            cleanSheet: false,
            motm: false,
            yellows: 0,
            reds: 0,
          ),
        ]);
      }
      return (
        container: save.container,
        career: save.career,
        man: man,
      );
    }

    test('is asked about, and the question names him', () async {
      final save = await withDebut(caps: 1);
      final q = await save.container.read(
        pressQuestionProvider(save.career.id).future,
      );
      expect(q?.topic, PressTopic.debutant);
      final subject = q!.subject;
      expect(subject, isA<PressSubjectPlayer>());
      subject as PressSubjectPlayer;
      expect(subject.playerId, save.man);
      expect(
        subject.name,
        isNotEmpty,
        reason: 'a question that cannot name him has not moved at all',
      );
      expect(
        subject.count,
        greaterThan(0),
        reason: 'the age is the figure this question says out loud',
      );
    });

    test('is not asked about on a second cap', () async {
      final save = await withDebut(caps: 2);
      final q = await save.container.read(
        pressQuestionProvider(save.career.id).future,
      );
      expect(q?.topic, isNot(PressTopic.debutant));
    });

    test('is not asked about for a man who did not play', () async {
      // One cap on the ledger, no line in the match just gone. The rating rows
      // are what say who was actually out there.
      final save = await withDebut(caps: 1, rated: false);
      final q = await save.container.read(
        pressQuestionProvider(save.career.id).future,
      );
      expect(q?.topic, isNot(PressTopic.debutant));
    });

    test('and the country posts about the same boy', () async {
      final save = await withDebut(caps: 1);
      final feed = await save.container.read(
        yFeedProvider(save.career.id).future,
      );
      final debut = feed.posts
          .where((p) => p.template == YTemplate.debut)
          .toList();
      expect(
        debut,
        isNotEmpty,
        reason: 'the feed never mentioned that somebody had won a first cap',
      );
      final name =
          (await save.container
                  .read(playerRepositoryProvider)
                  .byId(
                    save.man,
                    agingYears: 0,
                    saveSeed: save.career.rngSeed,
                  ))!
              .name;
      expect(debut.first.args.first, name);
    });
  });

  group('the next opponent', () {
    /// A save that has played [meetings] against one nation and has another
    /// match against them to come. [decoyMeetings] go to a third nation, which
    /// is how a test chooses who the fiercest rival is.
    Future<({ProviderContainer container, Career career, int them})> withNext({
      required List<int> meetings,
      int decoyMeetings = 0,
      String? lastRound,
    }) async {
      final save = await aSave();
      final now = save.career.inGameDate;
      final others = nations.where((n) => n.id != save.me).take(2).toList();
      final them = others[0];
      final decoy = others[1];
      final competition = await aCompetition(save.db, save.career.id);
      final finals = await aCompetition(
        save.db,
        save.career.id,
        name: 'World Championship Finals',
        kind: CompetitionKind.worldCupFinals,
      );
      // Oldest first, so the last entry is the most recent meeting.
      for (var i = 0; i < meetings.length; i++) {
        final result = meetings[i];
        final last = i == meetings.length - 1;
        await aFixture(
          save.db,
          save.career.id,
          last && lastRound != null ? finals : competition,
          date: now.subtract(Duration(days: 400 - i * 40)),
          home: save.me,
          away: them.id,
          homeScore: result > 0 ? 2 : 1,
          awayScore: result > 0 ? 1 : (result == 0 ? 1 : 2),
          round: last ? lastRound : null,
        );
      }
      for (var i = 0; i < decoyMeetings; i++) {
        await aFixture(
          save.db,
          save.career.id,
          competition,
          date: now.subtract(Duration(days: 800 - i * 40)),
          home: save.me,
          away: decoy.id,
          homeScore: 1,
          awayScore: 1,
        );
      }
      await aFixture(
        save.db,
        save.career.id,
        competition,
        date: now.add(const Duration(days: 20)),
        home: save.me,
        away: them.id,
      );
      return (
        container: save.container,
        career: save.career,
        them: them.id,
      );
    }

    test('is a rivalry when you have played them most', () async {
      // Four meetings, alternating, so there is no run to ask about instead.
      final save = await withNext(meetings: const [1, -1, 1, -1]);
      final q = await save.container.read(
        pressQuestionProvider(save.career.id).future,
      );
      expect(q?.topic, PressTopic.rivalryNext);
      final subject = q!.subject as PressSubjectOpponent;
      expect(subject.nationId, save.them);
      expect(subject.count, 4);
      expect(
        q.subjectNationId,
        save.them,
        reason: 'without this the sheet has no name to put in the sentence',
      );
    });

    test('is a run when the record against them is one-sided', () async {
      // Beaten by them four times running, and the fiercest rival is a
      // different nation, so the run is the only opponent story live.
      final save = await withNext(
        meetings: const [-1, -1, -1, -1],
        decoyMeetings: 6,
      );
      final q = await save.container.read(
        pressQuestionProvider(save.career.id).future,
      );
      expect(q?.topic, PressTopic.headToHeadRun);
      final subject = q!.subject as PressSubjectOpponent;
      expect(subject.count, 4);
      expect(
        subject.favourable,
        isFalse,
        reason: 'four defeats must not be asked about as a proud record',
      );
    });

    test('is a grudge when they put you out', () async {
      // Three meetings, so they are not yet a rivalry, and the last was a
      // quarter-final they won.
      final save = await withNext(
        meetings: const [1, 1, -1],
        lastRound: 'QF',
      );
      final q = await save.container.read(
        pressQuestionProvider(save.career.id).future,
      );
      expect(q?.topic, PressTopic.revengeMatch);
      expect((q!.subject as PressSubjectOpponent).nationId, save.them);
    });

    test('is nothing at all when you have only just met them', () async {
      final save = await withNext(meetings: const [1]);
      final q = await save.container.read(
        pressQuestionProvider(save.career.id).future,
      );
      expect(
        q?.topic,
        isNot(
          anyOf(
            PressTopic.rivalryNext,
            PressTopic.headToHeadRun,
            PressTopic.revengeMatch,
          ),
        ),
      );
    });
  });
}
