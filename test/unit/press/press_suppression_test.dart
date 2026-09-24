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
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/press_providers.dart';

import '../../helpers/test_database.dart';

/// A conference that contradicts itself.
///
/// Reported by a playtester: "som druhý v skupine a postupil som ale novinári
/// sa ma pýtajú kedy rezignujem" — second in the group, through, and being
/// asked when he is resigning. Both stories were true of the same fortnight:
/// [PressTopic.qualified] read the finals draw, [PressTopic.underPressure]
/// read three competitive games without a WIN, and two draws on the way to
/// qualifying are two games without a win. Nothing connected them, so the room
/// asked whichever the draw landed on.
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
    required String name,
    required CompetitionKind kind,
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
    'qualifying second with draws is not asked when he will resign',
    () async {
      final save = await aSave();
      final base = save.career.inGameDate;
      // Opponents of roughly this side's own standing, so the draws read as
      // par: neither an overachieving run nor a crisis, which would put a
      // third story in the room and make the draw prove less.
      final opponents = nations
          .where((n) => n.confederation == Confederation.oceania)
          .where((n) => n.id != save.me)
          .take(4)
          .toList();
      expect(opponents.length, 4, reason: 'need four qualifying opponents');

      final quali = await aCompetition(
        save.db,
        save.career.id,
        name: 'World Championship Qualifying',
        kind: CompetitionKind.worldCupQualifying,
      );
      // Second in the group: four competitive games, all drawn, all inside
      // the window the press still read. That is [Press.askWindowDays] worth
      // of football without a win.
      for (var i = 0; i < opponents.length; i++) {
        await aFixture(
          save.db,
          save.career.id,
          quali,
          date: base.subtract(Duration(days: 20 - i * 5)),
          home: save.me,
          away: opponents[i].id,
          matchday: i + 1,
          homeScore: 1,
          awayScore: 1,
        );
      }

      // …and the place at the finals that came with it: a group match of his
      // own, months away and unplayed.
      final finals = await aCompetition(
        save.db,
        save.career.id,
        name: 'World Championship Finals',
        kind: CompetitionKind.worldCupFinals,
      );
      await aFixture(
        save.db,
        save.career.id,
        finals,
        date: base.add(const Duration(days: 60)),
        home: save.me,
        away: opponents.first.id,
        round: 'GROUP',
      );

      // The question is DRAWN from the live stories (see [Press.storyPool]),
      // and the draw is seeded by the date. One reading would pass half the
      // time on luck alone, so every day of a week is asked.
      for (var day = 0; day < 8; day++) {
        await (save.db.update(
          save.db.careers,
        )..where((c) => c.id.equals(save.career.id))).write(
          CareersCompanion(inGameDate: Value(base.add(Duration(days: day)))),
        );
        save.container.invalidate(pressQuestionProvider);
        final q = await save.container.read(
          pressQuestionProvider(save.career.id).future,
        );
        expect(
          q?.topic,
          isNot(anyOf(PressTopic.underPressure, PressTopic.crisis)),
          reason:
              'through to the finals and still asked about resigning '
              '(day $day, ${q?.key})',
        );
      }
    },
  );

  test('a booked place still leaves the press something to ask', () async {
    // The other half of the fix: silencing is not muting. The conference must
    // still happen — it is the resignation question that goes, not the room.
    final save = await aSave();
    final now = save.career.inGameDate;
    final opponents = nations
        .where((n) => n.confederation == Confederation.oceania)
        .where((n) => n.id != save.me)
        .take(3)
        .toList();
    final quali = await aCompetition(
      save.db,
      save.career.id,
      name: 'World Championship Qualifying',
      kind: CompetitionKind.worldCupQualifying,
    );
    for (var i = 0; i < opponents.length; i++) {
      await aFixture(
        save.db,
        save.career.id,
        quali,
        date: now.subtract(Duration(days: 15 - i * 5)),
        home: save.me,
        away: opponents[i].id,
        matchday: i + 1,
        homeScore: 1,
        awayScore: 1,
      );
    }
    final finals = await aCompetition(
      save.db,
      save.career.id,
      name: 'World Championship Finals',
      kind: CompetitionKind.worldCupFinals,
    );
    await aFixture(
      save.db,
      save.career.id,
      finals,
      date: now.add(const Duration(days: 60)),
      home: save.me,
      away: opponents.first.id,
      round: 'GROUP',
    );

    final q = await save.container.read(
      pressQuestionProvider(save.career.id).future,
    );
    expect(q, isNotNull, reason: 'the room went silent instead of moving on');
    expect(q!.topic, PressTopic.qualified);
  });

  group('the precedence table', () {
    PressQuestion q(PressTopic topic) => (
      key: '${Press.keyPrefixOf(topic)}:1',
      topic: topic,
      subject: const PressSubjectTeam(),
      subjectNationId: null,
      options: Press.optionsFor(topic),
    );

    test('a booked place silences the sack, the crisis and the miss', () {
      final left = Press.unsilenced([
        q(PressTopic.underPressure),
        q(PressTopic.crisis),
        q(PressTopic.missedOut),
        q(PressTopic.qualified),
      ]).map((c) => c.topic);
      expect(left, [PressTopic.qualified]);
    });

    test('a trophy silences the sack, the crisis and the lucky win', () {
      final left = Press.unsilenced([
        q(PressTopic.underPressure),
        q(PressTopic.crisis),
        q(PressTopic.luckyWin),
        q(PressTopic.triumph),
      ]).map((c) => c.topic);
      expect(left, [PressTopic.triumph]);
    });

    test('a rout silences only the lucky win', () {
      final left = Press.unsilenced([
        q(PressTopic.luckyWin),
        q(PressTopic.heavyDefeat),
        q(PressTopic.bigWin),
      ]).map((c) => c.topic);
      expect(left, [PressTopic.heavyDefeat, PressTopic.bigWin]);
    });

    test('a silenced story cannot silence anything itself', () {
      // A trophy silences the crisis; the crisis silences nothing, but were
      // the table walked transitively a muted row could still take a story
      // down with it. The pass is over LIVE topics only.
      final left = Press.unsilenced([
        q(PressTopic.luckyWin),
        q(PressTopic.triumph),
        q(PressTopic.bigWin),
      ]).map((c) => c.topic);
      expect(left, [PressTopic.triumph, PressTopic.bigWin]);
    });

    test('nothing is silenced when no louder story is live', () {
      final all = [
        for (final topic in PressTopic.values)
          if (!Press.silences.keys.contains(topic)) q(topic),
      ];
      expect(Press.unsilenced(all).length, all.length);
    });

    test('the pick never returns a silenced story', () {
      final candidates = [
        q(PressTopic.underPressure),
        q(PressTopic.qualified),
      ];
      for (var seed = 0; seed < 40; seed++) {
        expect(Press.pick(candidates, seed: seed)?.topic, PressTopic.qualified);
      }
    });

    test('a silenced story is not a fallback when everything is stale', () {
      // The freshness rule falls back to the whole list when every candidate
      // has just been asked about. That fallback must not resurrect a story
      // the table has already ruled out.
      final candidates = [
        q(PressTopic.underPressure),
        q(PressTopic.qualified),
      ];
      for (var seed = 0; seed < 40; seed++) {
        expect(
          Press.pick(
            candidates,
            recentTopics: const {
              PressTopic.underPressure,
              PressTopic.qualified,
            },
            seed: seed,
          )?.topic,
          PressTopic.qualified,
        );
      }
    });
  });
}
