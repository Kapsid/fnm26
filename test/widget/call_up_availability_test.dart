import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';
import 'package:fnm/features/tactics/nomination_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/test_database.dart';

/// A ban is served in MATCHES, and a call-up list covers more than one of them.
///
/// The screen used to ask `isAvailable` — "can he play the very next game" —
/// which is the question the XI picker asks, not the one a manager naming a
/// squad answers. A man serving one game of a three-match camp plays the other
/// two, so he belongs in the squad; only the man who misses every match of it
/// is a wasted place.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int careerId;
  late int nationId;

  Player p(int id, String name, PlayerPosition pos, int overall) => Player(
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

  /// Enough men to name a legal squad, with the two the tests care about
  /// sitting in the midfield: "One Game" carries a single-match ban, "Whole
  /// Camp" a three-match one.
  List<Player> pool() => [
    for (var i = 0; i < 3; i++)
      p(1 + i, 'Keeper $i', PlayerPosition.gk, 70 + i),
    for (var i = 0; i < 8; i++) p(11 + i, 'Back $i', PlayerPosition.cb, 70 + i),
    p(21, 'One Game', PlayerPosition.cm, 80),
    p(22, 'Whole Camp', PlayerPosition.cm, 79),
    for (var i = 0; i < 6; i++) p(23 + i, 'Mid $i', PlayerPosition.cm, 70 + i),
    for (var i = 0; i < 5; i++)
      p(31 + i, 'Forward $i', PlayerPosition.st, 70 + i),
  ];

  /// A camp of three matches: the window every test here is picked against.
  List<Fixture> threeMatches() => [
    for (var i = 0; i < 3; i++)
      Fixture(
        id: 100 + i,
        careerId: careerId,
        competitionId: 1,
        matchday: i + 1,
        date: DateTime(2026, 9, 5 + i * 4),
        homeNationId: nationId,
        awayNationId: nationId + 1,
      ),
  ];

  setUp(() async {
    db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    await container.read(seedLoaderProvider).ensureSeeded();
    nationId = nations.first.id;
    careerId =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nationId, managerName: 'M'))
            .valueOrNull!
            .id;
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> pumpCallUps(
    WidgetTester tester, {
    Map<int, PlayerAbsence> absences = const {},
    Set<int> draft = const {},
    List<Fixture>? matches,
    Locale locale = const Locale('en'),
    double width = 400,
  }) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = Size(width, 800);
    addTearDown(tester.view.reset);

    final scoped = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        squadDataProvider(careerId).overrideWith(
          (ref) async =>
              SquadData(pool: pool(), callUps: const {}, absences: absences),
        ),
        callUpDraftProvider.overrideWith((ref, arg) async => draft),
        nominationWindowProvider(careerId).overrideWith(
          (ref) async => (
            open: true,
            matches: matches ?? threeMatches(),
            nations: <int, Nation>{},
            playerNationId: nationId,
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
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CallUpScreen(careerId: careerId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Opens the midfield tab, where the two banned men sit. By index, not by
  /// label: the line headings are translated, and Czech does not spell them
  /// GK/DEF/MID/FWD.
  Future<void> openMidfield(WidgetTester tester) async {
    await tester.tap(find.byType(Tab).at(2));
    await tester.pumpAndSettle();
  }

  /// How many rows are ticked into the squad.
  int ticked(WidgetTester tester) =>
      find.byIcon(Icons.check_circle).evaluate().length;

  const oneGame = {21: PlayerAbsence(playerId: 21, banMatches: 1)};
  const wholeCamp = {22: PlayerAbsence(playerId: 22, banMatches: 3)};

  testWidgets('a one-game ban does not cost a player the whole camp', (
    tester,
  ) async {
    await pumpCallUps(tester, absences: oneGame);
    await openMidfield(tester);

    await tester.tap(find.text('One Game'));
    await tester.pumpAndSettle();

    expect(ticked(tester), 1, reason: 'he plays two of the three, so he goes');
    expect(find.text('SQUAD · 1/$kMaxSquadSize'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('his row says how much of THIS camp he misses', (tester) async {
    await pumpCallUps(tester, absences: oneGame);
    await openMidfield(tester);

    // One of the three matches, not "one game" in the abstract: the bare ban
    // length never said what it cost the squad being picked.
    expect(find.text('Misses 1/3'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('a man who misses every match of the camp cannot be named', (
    tester,
  ) async {
    await pumpCallUps(tester, absences: wholeCamp);
    await openMidfield(tester);

    await tester.tap(find.text('Whole Camp'));
    await tester.pumpAndSettle();

    expect(ticked(tester), 0, reason: 'he will not kick a ball in this camp');
    expect(find.text('SQUAD · 0/$kMaxSquadSize'), findsOneWidget);
    // And he is told why rather than left tapping a dead row.
    expect(find.text('Out for this whole call-up'), findsOneWidget);
    expect(find.text('Misses 3/3'), findsOneWidget);
  });

  testWidgets('the camp length decides it, not the ban length', (tester) async {
    // The same three-match ban against a one-match window: still unusable.
    // Against three matches he misses all three; against one, the one.
    await pumpCallUps(
      tester,
      absences: wholeCamp,
      matches: [threeMatches().first],
    );
    await openMidfield(tester);

    await tester.tap(find.text('Whole Camp'));
    await tester.pumpAndSettle();
    expect(ticked(tester), 0);
    // A single-match window has nothing to add: the badge already said it.
    expect(find.textContaining('Misses'), findsNothing);
  });

  testWidgets('the fit count gates on men who can play ONE of the matches', (
    tester,
  ) async {
    // Sixteen named, six of them serving a single game of the three. Only ten
    // can play the first match, which is what the screen used to count, and it
    // refused to let the squad be confirmed. All sixteen play at least one of
    // the three, so the squad is fieldable and the button is live.
    final banned = [11, 12, 13, 14, 15, 16];
    await pumpCallUps(
      tester,
      absences: {
        for (final id in banned) id: PlayerAbsence(playerId: id, banMatches: 1),
      },
      draft: {1, 2, 3, 11, 12, 13, 14, 15, 16, 17, 18, 21, 23, 24, 31, 32},
    );

    expect(find.text('SQUAD · 16/$kMaxSquadSize'), findsOneWidget);
    expect(
      find.textContaining('Need $kMinFitPlayers'),
      findsNothing,
      reason: 'sixteen men each play at least one of the three matches',
    );
    final confirm = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(confirm.onPressed, isNotNull);
  });

  testWidgets('a squad that truly cannot field an XI is still refused', (
    tester,
  ) async {
    // The gate has not been weakened: eleven men who can play SOMETHING is
    // still the floor, and fifteen of these sixteen miss the lot.
    final out = [1, 2, 3, 11, 12, 13, 14, 15, 16, 17, 18, 21, 23, 24, 31];
    await pumpCallUps(
      tester,
      absences: {
        for (final id in out) id: PlayerAbsence(playerId: id, banMatches: 3),
      },
      draft: {...out, 32},
    );

    expect(find.textContaining('Need $kMinFitPlayers'), findsOneWidget);
    final confirm = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(confirm.onPressed, isNull);
  });

  for (final width in [400.0, 360.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      testWidgets(
        'the absence line fits ${width.toInt()}px in ${locale.languageCode}',
        (tester) async {
          await pumpCallUps(
            tester,
            absences: {...oneGame, ...wholeCamp},
            locale: locale,
            width: width,
          );
          await openMidfield(tester);

          expect(
            tester.takeException(),
            isNull,
            reason: 'a call-up row must never run off a phone',
          );
        },
      );
    }
  }
}
