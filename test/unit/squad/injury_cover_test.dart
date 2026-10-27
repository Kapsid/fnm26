import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/squad/injury_cover_providers.dart';
import 'package:fnm/features/squad/injury_cover_screen.dart';
import 'package:fnm/features/tactics/nomination_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// "If someone is injured during an international window I should get an
/// option to call someone else, any position."
void main() {
  late ProviderContainer c;
  late int careerId;
  late int nationId;
  late List<Fixture> window;
  late List<int> squad;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    List<T> load<T>(String f, T Function(Map<String, Object?>) from) =>
        (jsonDecode(File('assets/data/$f').readAsStringSync()) as List)
            .map((e) => from(e as Map<String, Object?>))
            .toList();
    final nations = load('nations.json', Nation.fromJson);
    final players = load('players.json', Player.fromJson);
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final europe =
        nations.where((n) => n.confederation == Confederation.europe).toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking));
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: europe[10].id, managerName: 'M', rngSeed: 7))
            .valueOrNull!;
    careerId = career.id;
    nationId = career.nationId;

    // The first window of the qualifying campaign with two matches or more.
    final fixtures =
        (await c
              .read(competitionRepositoryProvider)
              .cycleFixturesForNation(careerId, nationId))
          ..sort((a, b) => a.date.compareTo(b.date));
    final byMonth = <(int, int), List<Fixture>>{};
    for (final f in fixtures.where((f) => f.round == 'CQ')) {
      (byMonth[(f.date.year, f.date.month)] ??= []).add(f);
    }
    window = byMonth.values.firstWhere((w) => w.length >= 2);

    // A named squad of 23.
    final pool = await c
        .read(playerRepositoryProvider)
        .byNation(nationId, saveSeed: career.rngSeed, careerId: career.id);
    squad = [for (final p in pool.take(23)) p.id];
    await c.read(squadRepositoryProvider).setCallUps(careerId, squad.toSet());
  });

  /// Plays every match before the window, then the window's first one, with
  /// [victim] hurt in it (or banned, when [ban]).
  Future<void> hurt(int victim, {bool ban = false}) async {
    final comp = c.read(competitionRepositoryProvider);
    final all = await comp.cycleFixturesForNation(careerId, nationId);
    for (final f in all.where((f) => f.date.isBefore(window.first.date))) {
      await comp.recordResult(fixtureId: f.id, homeScore: 1, awayScore: 0);
    }
    final first = window.first;
    await comp.recordResult(fixtureId: first.id, homeScore: 1, awayScore: 0);
    await comp.recordIncidents(careerId, first.id, [
      (
        careerId: careerId,
        fixtureId: first.id,
        nationId: nationId,
        playerId: victim,
        minute: 30,
        type: ban ? MatchEventType.redCard : MatchEventType.injury,
        secondYellow: false,
      ),
    ]);
    await c.read(absenceRepositoryProvider).replace(careerId, [
      PlayerAbsence(
        playerId: victim,
        injuryMatches: ban ? 0 : 2,
        banMatches: ban ? 1 : 0,
      ),
    ]);
  }

  Future<InjuryCover?> pending() {
    c.invalidate(pendingInjuryCoverProvider(careerId));
    return c.read(pendingInjuryCoverProvider(careerId).future);
  }

  test('an injury mid-window offers a replacement', () async {
    await hurt(squad[3]);
    final cover = await pending();
    expect(cover, isNotNull);
    expect(cover!.playerId, squad[3]);
    expect(cover.matchesOut, 2);
    expect(cover.playerName, isNotEmpty);
  });

  test('a ban offers none', () async {
    await hurt(squad[3], ban: true);
    expect(await pending(), isNull);
  });

  test('replacing him swaps the squad and empties only his XI slot', () async {
    final victim = squad[0];
    await hurt(victim);
    final tactics = c.read(tacticsRepositoryProvider);
    final before = (await tactics.tacticForCareer(careerId))!;
    // Put him in the XI if the default eleven left him out.
    final lineup = [...before.lineup];
    if (!lineup.contains(victim)) lineup[1] = victim;
    await tactics.saveTactic(careerId, before.copyWith(lineup: lineup));

    final pool = await c
        .read(playerRepositoryProvider)
        .byNation(nationId, saveSeed: 7);
    final incoming = pool.firstWhere((p) => !squad.contains(p.id)).id;
    await c
        .read(squadServiceProvider)
        .replaceInjured(careerId, outId: victim, inId: incoming);

    final callUps = await c.read(squadRepositoryProvider).callUps(careerId);
    expect(callUps, contains(incoming));
    expect(callUps, isNot(contains(victim)));
    expect(callUps, hasLength(23));
    final after = (await tactics.tacticForCareer(careerId))!;
    final slot = lineup.indexOf(victim);
    expect(after.lineup[slot], isNull);
    for (var i = 0; i < 11; i++) {
      if (i != slot) expect(after.lineup[i], lineup[i]);
    }
    // He is no longer in the squad, so there is nothing left to answer.
    expect(await pending(), isNull);
  });

  test('keeping him is an answer too', () async {
    await hurt(squad[3]);
    final cover = (await pending())!;
    final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
    await c
        .read(competitionRepositoryProvider)
        .markDrawWatched(
          careerId,
          career.cyclePointer,
          injuryCoverKey(cover.fixtureId, cover.playerId),
        );
    expect(await pending(), isNull);
  });

  // "When you are subbing out the player who was injured, show his position."
  group('the screen names the position being filled', () {
    Player man(int id, String name, PlayerPosition pos, int overall) => Player(
      id: id,
      nationId: 1,
      name: name,
      position: pos,
      age: 25,
      club: 'Club $id',
      attributes: PlayerAttributes(
        physical: overall,
        technical: overall,
        stamina: overall,
      ),
    );

    Future<void> pumpCover(
      WidgetTester tester, {
      double width = 360,
      double scale = 1,
    }) async {
      tester.view
        ..devicePixelRatio = 1
        ..physicalSize = Size(width, 800);
      addTearDown(tester.view.reset);
      final scoped = ProviderContainer(
        overrides: [
          pendingInjuryCoverProvider(1).overrideWith(
            (ref) async => (
              playerId: 1,
              playerName: 'Hurt Back',
              fixtureId: 9,
              matchesOut: 2,
            ),
          ),
          squadDataProvider(1).overrideWith(
            (ref) async => SquadData(
              pool: [
                man(1, 'Hurt Back', PlayerPosition.cb, 77),
                man(2, 'Same Spot', PlayerPosition.cb, 70),
                man(3, 'Other Spot', PlayerPosition.st, 72),
              ],
              callUps: const {1},
              absences: const {},
            ),
          ),
          nominationWindowProvider(1).overrideWith(
            (ref) async => (
              open: false,
              matches: const <Fixture>[],
              nations: <int, Nation>{},
              playerNationId: 1,
            ),
          ),
        ],
      );
      addTearDown(scoped.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: scoped,
          child: MaterialApp(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: const InjuryCoverScreen(careerId: 1),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    TacticalChip chipIn(WidgetTester tester, Finder row) => tester.widget(
      find.descendant(of: row, matching: find.byType(TacticalChip)),
    );

    testWidgets('an injury: preview, banner and same-position marking', (
      tester,
    ) async {
      await pumpCover(tester, scale: 1.4);
      final tile = find.byKey(const Key('injuryCover.outTile'));
      expect(tile, findsOneWidget);
      expect(
        find.descendant(of: tile, matching: find.text('Hurt Back')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: tile, matching: find.text('Centre Back')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: tile, matching: find.text('77')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: tile,
          matching: find.byIcon(Icons.medical_services),
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Hurt Back (Centre Back) is injured'),
        findsOneWidget,
      );
      expect(
        chipIn(
          tester,
          find
              .ancestor(of: find.text('Same Spot'), matching: find.byType(Row))
              .first,
        ).emphasized,
        isTrue,
      );
      expect(
        chipIn(
          tester,
          find
              .ancestor(of: find.text('Other Spot'), matching: find.byType(Row))
              .first,
        ).emphasized,
        isFalse,
      );
      // Nobody is hidden.
      expect(find.text('Other Spot'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
