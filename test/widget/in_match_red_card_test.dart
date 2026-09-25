import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';

/// What a red card costs.
///
/// The manager's report: "mal som vyluceného hraca a povolilo mi na jeho
/// miesto dat nahradnika a stale som hral v 11" — he had a man sent off, was
/// allowed to put a substitute in his place, and carried on with eleven. The
/// sheet vacated the sent-off man's slot, an empty slot means "put somebody
/// here" everywhere else on that pitch, and [_subsUsed] deliberately does not
/// count a sending-off as a change: the replacement was free in both senses
/// and the red card cost nothing at all.
///
/// The place is dead for the rest of the match. These hold every way into it
/// shut, and hold the hole itself visible, because an empty slot that refuses
/// a tap without saying why is the same misreading one step later.
void main() {
  const formation = Formation.f442;

  /// Eleven starters (ids 1..11, each in his slot's own position) and five
  /// substitutes (ids 12..16).
  List<Player> squad() => [
    for (var i = 0; i < 11; i++)
      player(
        id: i + 1,
        nationId: 1,
        name: 'Starter${i + 1}',
        position: formation.positions[i],
      ),
    for (var i = 12; i <= 16; i++) player(id: i, nationId: 1, name: 'Bench$i'),
  ];

  /// Opens the real editor over a launcher, the way the match screen does.
  ///
  /// The surface is tall on purpose: a drag test has to reach a bench row and
  /// a pitch disc in one gesture, and both must be laid out to be dragged
  /// between.
  ///
  /// The locale goes on the MaterialApp, NOT on a `Localizations.override`
  /// around the launcher: the editor is a route pushed under the root
  /// Navigator, so an override there never reaches it.
  Future<AppLocalizations> openSheet(
    WidgetTester tester, {
    Set<int> sentOffIds = const {},
    double width = 400,
    double height = 2600,
    Locale locale = const Locale('en'),
  }) async {
    // setSurfaceSize, not tester.view.physicalSize. The editor is a PUSHED
    // ROUTE, and a probe showed its layout coming out identical at 320 and at
    // 430 with physicalSize set: these width cases were not constraining the
    // sheet at all, which is how a tab strip that painted its counter over
    // its second tab passed them. The surface size does reach it.
    await tester.binding.setSurfaceSize(Size(width, height));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (inner) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showInMatchTactics(
                    inner,
                    minute: 60,
                    formation: formation,
                    lineup: [for (var i = 1; i <= 11; i++) i],
                    instructions: const TacticalInstructions(),
                    pool: squad(),
                    startingIds: {for (var i = 1; i <= 11; i++) i},
                    maxSubs: 5,
                    sentOffIds: sentOffIds,
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return AppLocalizations.delegate.load(locale);
  }

  /// Holds, then drags [from] onto [to] — the gesture the pitch asks for, with
  /// the brief hold that tells a drag from a scroll.
  Future<void> dragOnto(WidgetTester tester, Finder from, Finder to) async {
    final gesture = await tester.startGesture(tester.getCenter(from));
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(to));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
  }

  Finder disc(int slot) => find.byKey(ValueKey('pitchDisc$slot'));

  testWidgets('the place a sending-off took is drawn as a hole, not a gap', (
    tester,
  ) async {
    // Starter11 walks: his slot is the last one in a 4-4-2.
    final l = await openSheet(tester, sentOffIds: {11});

    expect(
      find.text(l.tacticsSentOffShort),
      findsOneWidget,
      reason: 'the empty spot must say why it is empty, on the pitch itself',
    );
    expect(
      find.text('10/11'),
      findsOneWidget,
      reason: 'the side is playing with ten',
    );
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('tapping the hole refuses instead of offering a replacement', (
    tester,
  ) async {
    final l = await openSheet(tester, sentOffIds: {11});

    await tester.tap(disc(10));
    await tester.pumpAndSettle();

    expect(
      find.text(
        l.tacticsPickRole(
          positionName(l, formation.positions[10]).toUpperCase(),
        ),
      ),
      findsNothing,
      reason: 'the slot picker must not open on a place the side has lost',
    );
    expect(find.text(l.tacticsSlotLostToRedCard), findsOneWidget);
  });

  testWidgets('a substitute cannot be dragged into the hole', (tester) async {
    final l = await openSheet(tester, sentOffIds: {11});

    await dragOnto(tester, find.text('Bench12'), disc(10));

    expect(
      find.text('10/11'),
      findsOneWidget,
      reason: 'the bench filled the hole and the side was eleven again',
    );
    expect(find.text(l.tacticsSubsUsed(0, 5)), findsOneWidget);
    expect(find.text(l.tacticsSentOffShort), findsOneWidget);
  });

  testWidgets('a team-mate cannot be moved into the hole either', (
    tester,
  ) async {
    // Sideways into the empty place is the same eleven-man side under another
    // shape, and it leaves the hole somewhere else instead of closing it.
    final l = await openSheet(tester, sentOffIds: {11});

    await dragOnto(tester, disc(9), disc(10));

    expect(find.text('10/11'), findsOneWidget);
    expect(find.text(l.tacticsSentOffShort), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Text && w.data == 'STARTER10',
        description: 'the pitch name STARTER10',
      ),
      findsOneWidget,
      reason: 'the man dragged at must still be standing where he was',
    );
  });

  testWidgets('two red cards leave two holes, not one', (tester) async {
    final l = await openSheet(tester, sentOffIds: {10, 11});

    expect(find.text(l.tacticsSentOffShort), findsNWidgets(2));
    expect(find.text('9/11'), findsOneWidget);

    // And neither of them takes a substitute.
    await dragOnto(tester, find.text('Bench12'), disc(10));
    await dragOnto(tester, find.text('Bench12'), disc(9));

    expect(find.text('9/11'), findsOneWidget);
    expect(find.text(l.tacticsSubsUsed(0, 5)), findsOneWidget);
  });

  testWidgets('the sent-off man is named as sent off, not as taken off', (
    tester,
  ) async {
    // He is off the pitch and he is a starter, which is how he used to end up
    // reported as "already taken off" — a different rule with a different
    // consequence, and the one that tells the manager whether the place can be
    // filled at all.
    //
    // He is no longer named in a LIST: the greyed pile of used men went when
    // the squad became two tabs. He is named in the note under the pitch, and
    // the hole he left is barred on the pitch itself, which are the two
    // places that were always the point.
    final l = await openSheet(tester, sentOffIds: {11});

    expect(find.textContaining(l.tacticsSentOffShort), findsWidgets);
    expect(find.text(l.tacticsSubOffAlready), findsNothing);
    expect(
      find.text('Starter11'),
      findsNothing,
      reason: 'a sent-off man is not offered as a substitute',
    );
    expectNothingCut(tester);
  });

  for (final width in <double>[320, 360, 400]) {
    for (final locale in const [Locale('en'), Locale('cs')]) {
      testWidgets(
        'the hole and its note fit ${width.toInt()}px in '
        '${locale.languageCode}',
        (tester) async {
          final l = await openSheet(
            tester,
            sentOffIds: {11},
            width: width,
            locale: locale,
          );

          // The sheet really is in this language. It is a pushed route, so an
          // override around the launcher would never have reached it.
          expectLocale(
            tester,
            find.text(l.tacticsSentOffShort),
            locale.languageCode,
          );
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);
          expectWhole(
            find.text('10/11'),
            'the on-pitch count',
          );
          expectWhole(
            find.textContaining(l.tacticsSentOffShort).first,
            'the sent-off note',
          );

          // And the refusal itself, which is the longest of the new strings.
          await tester.tap(disc(10));
          await tester.pumpAndSettle();
          expectNothingCut(tester);
          expectWhole(
            find.text(l.tacticsSlotLostToRedCard),
            'the refusal on a lost place',
          );
        },
      );
    }
  }
}
