import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// The pitch's drag-and-drop: hold a player briefly, drag them onto another
/// slot. The hold is what beats the surrounding ListView's scroll gesture.
/// How far apart two balls must stay, as a multiple of their own diameter.
///
/// A shade over 1.0 would only mean "not overlapping", which still reads as
/// one blob on the pitch. The tightest pair in the whole matrix (4-1-4-1 at
/// 320pt, a high line) measures 1.1026 — so the balls are drawn at very nearly
/// the largest size this bar allows and there is no room left in the width
/// dial. An earlier note here claimed 1.134, which was measured before the
/// layouts moved and cost an afternoon: whatever a disc needs, it has to be
/// found INSIDE the circle. If a change pushes below the bar, the answer is to
/// open the spacing, not to lower it.
const double _minBallClearance = 1.10;

/// The pitch wrapped the way the real screens wrap it.
///
/// This matters far more than it looks. `AspectRatio` only applies when ONE
/// axis is loose, and both the tactics screen and the in-match sheet put the
/// pitch inside a scroll view, which is what leaves the height loose. Dropped
/// straight into a Scaffold body it gets tight constraints on both axes,
/// silently ignores the aspect ratio and renders nearly twice as tall — which
/// inflates every vertical gap and hides exactly the crowding these tests
/// exist to catch. They passed for a while against a pitch the app never draws.
Widget pitchAsTheAppLaysItOut(Widget pitch) => ListView(
  children: [AspectRatio(aspectRatio: 3 / 4, child: pitch)],
);

void main() {
  // A full XI, one player per slot, ids 100..110.
  final formation = Formation.f442;
  final lineup = [for (var i = 0; i < 11; i++) 100 + i];
  final byId = <int, Player>{
    for (var i = 0; i < 11; i++)
      100 + i: player(
        id: 100 + i,
        nationId: 1,
        name: 'P$i',
        position: formation.positions[i],
      ),
  };

  Widget harness({
    required void Function(int, int) onSwap,
    void Function(int, int)? onBenchIn,
    void Function(int, double)? onMoveToSpace,
  }) {
    // The pitch lives inside a ListView in the real screen — that scroll view
    // is exactly what the drag gesture has to win the arena against.
    return ListView(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: TacticsPitch(
            formation: formation,
            instructions: const TacticalInstructions(),
            lineup: lineup,
            byId: byId,
            onTapSlot: (_) {},
            onSwap: onSwap,
            onBenchIn: onBenchIn ?? (_, __) {},
            onMoveToSpace: onMoveToSpace,
          ),
        ),
      ],
    );
  }

  group('the name under a node', () {
    /// A name is rendered with zero-width spaces between its letters so a long
    /// surname can wrap inside the ball, so it cannot be found by plain text.
    Finder findName(String text) => find.byWidgetPredicate(
      (w) => w is Text && w.data?.replaceAll('\u200B', '') == text,
      description: 'name "$text"',
    );

    /// The pitch with a chosen set of names in the XI, on the NARROWEST phone
    /// width the app supports — the case where a node has least room and the
    /// old label ran across the player standing next to it.
    Future<void> pumpNames(WidgetTester tester, List<String> names) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 900);
      addTearDown(tester.view.reset);
      final squad = <int, Player>{
        for (var i = 0; i < 11; i++)
          100 + i: player(
            id: 100 + i,
            nationId: 1,
            name: i < names.length ? names[i] : 'A Player$i',
            position: formation.positions[i],
          ),
      };
      await tester.pumpApp(
        pitchAsTheAppLaysItOut(
          TacticsPitch(
            formation: formation,
            instructions: const TacticalInstructions(),
            lineup: lineup,
            byId: squad,
            onTapSlot: (_) {},
            onSwap: (_, __) {},
            onBenchIn: (_, __) {},
          ),
        ),
      );
    }

    /// Every name drawn on the pitch, as it READS.
    ///
    /// A long surname may arrive shortened, so a test that wants to know what
    /// became of one cannot look it up by the name it started as.
    List<String> pitchNames(WidgetTester tester) => [
      for (final t in tester.widgetList<Text>(find.byType(Text)))
        if (t.data case final d?)
          if (d == d.toUpperCase() && d.length > 2) d.replaceAll('\u200b', ''),
    ];

    testWidgets('is the surname alone when nobody shares it', (tester) async {
      await pumpNames(tester, ['Cristiano Ronaldo']);
      expect(findName('RONALDO'), findsOneWidget);
      expect(findName('C. RONALDO'), findsNothing);
    });

    testWidgets('takes its initial back only when a team-mate shares the '
        'surname', (tester) async {
      await pumpNames(tester, ['Jan Novak', 'Petr Novak', 'Ivan Silva']);
      expect(findName('J. NOVAK'), findsOneWidget);
      expect(findName('P. NOVAK'), findsOneWidget);
      // The man nobody shares a name with keeps his surname clean.
      expect(findName('SILVA'), findsOneWidget);
    });

    testWidgets('spells the first name out when the initial does not divide '
        'them either', (tester) async {
      await pumpNames(tester, ['Jan Novak', 'Josef Novak']);
      expect(findName('JAN NOVAK'), findsOneWidget);
      expect(findName('JOSEF NOVAK'), findsOneWidget);
    });

    testWidgets('is never broken in the middle of itself', (tester) async {
      // The manager's report, in his own words: "zalamující se jména v
      // sestavě". Every surname over eight letters arrived split across two
      // or three lines, mid-syllable — LEWANDO / WSKI — because the name was
      // drawn with an invisible break opportunity between every letter so it
      // could wrap rather than be cut. A name in three pieces is not a name.
      //
      // What it does instead: one line, stepped down in size, and when even
      // the floor will not hold it, written SHORTER by its ending. The three
      // longest surnames in the seed data, on the narrowest phone.
      await pumpNames(tester, [
        'Koto Rakotoharimalala',
        'Sione Falepapalangi',
        'Bidzina Tkeshelashvili',
      ]);
      for (final surname in const [
        'RAKOTOHARIMALALA',
        'FALEPAPALANGI',
        'TKESHELASHVILI',
      ]) {
        final drawn = pitchNames(tester).firstWhere(
          (n) => surname.startsWith(n.replaceAll('.', '')),
          orElse: () => fail('$surname is not on the pitch in any form'),
        );
        expectOneLine(findName(drawn), 'the name "$drawn" on the pitch');
        expect(
          drawn.endsWith('.') || drawn == surname,
          isTrue,
          reason:
              '"$drawn" is neither the whole surname nor a shortened one: a '
              'name that gives something up has to say so',
        );
      }
      for (final t in tester.widgetList<Text>(find.byType(Text))) {
        expect(
          t.overflow,
          isNot(TextOverflow.ellipsis),
          reason: 'a name on the pitch must be shortened, never clipped',
        );
      }
    });

    testWidgets('never grows wider than its own slot of the pitch', (
      tester,
    ) async {
      // A node wider than the gap between two players is the whole original
      // complaint: the label writes across the next man's disc.
      await pumpNames(tester, ['Koto Rakotoharimalala']);
      final drawn = pitchNames(
        tester,
      ).firstWhere((n) => 'RAKOTOHARIMALALA'.startsWith(n.replaceAll('.', '')));
      final label = tester.getRect(findName(drawn));
      // A node is 0.16 of the pitch, and on this 320pt surface the pitch is
      // the full width — so no label may be wider than that share of it.
      expect(label.width, lessThanOrEqualTo(320 * 0.16));
    });

    testWidgets('nothing a node draws ever lands on another player\'s ball', (
      tester,
    ) async {
      // The manager's complaint, in his own words: "if balls are close
      // together, the name is overflowing other circles."
      //
      // A name below a disc reaches DOWN into the row underneath, so it is not
      // enough to check names against names — this checks every node's whole
      // painted extent against every other node's disc. It is the reason the
      // name now lives inside the ball.
      //
      // Walked over EVERY formation at BOTH ends of both dials: the tight case
      // is the counter-intuitive one (a narrow team pulls the eleven
      // together), and checking only the wide end is how a label that
      // overlapped by 3pt shipped once already.
      // Several pitch widths, not one: sizes are a fraction of the width but
      // the vertical insets are not perfectly scale-free, so a rule that holds
      // on a small phone can still fail on a large one. It did — an absolute
      // gutter used to eat the clear air as the screen grew.
      for (final pitchWidth in [320.0, 402.0, 430.0]) {
        for (final shape in Formation.values) {
          for (final width in [0, 50, 100]) {
            for (final line in [0, 50, 100]) {
              tester.view.devicePixelRatio = 1;
              // Tall enough to hold a whole 4:3 pitch, so nothing is
              // clipped and every node has a real rectangle.
              tester.view.physicalSize = Size(
                pitchWidth,
                pitchWidth * 4 / 3 + 200,
              );
              addTearDown(tester.view.reset);
              final squad = <int, Player>{
                for (var i = 0; i < 11; i++)
                  100 + i: player(
                    id: 100 + i,
                    nationId: 1,
                    // The longest surname in the seed data on all eleven, so
                    // every label is under maximum pressure at once.
                    name: 'Koto Rakotoharimalala$i',
                    position: shape.positions[i],
                  ),
              };
              await tester.pumpApp(
                pitchAsTheAppLaysItOut(
                  TacticsPitch(
                    formation: shape,
                    instructions: TacticalInstructions(
                      width: width,
                      defensiveLine: line,
                    ),
                    lineup: lineup,
                    byId: squad,
                    // Energy on, so the second rim badge is in play too.
                    energyByPlayer: {for (var i = 0; i < 11; i++) 100 + i: 60},
                    onTapSlot: (_) {},
                    onSwap: (_, __) {},
                    onBenchIn: (_, __) {},
                  ),
                ),
              );
              final discs = [
                for (var i = 0; i < 11; i++)
                  tester.getRect(find.byKey(ValueKey('pitchDisc$i'))),
              ];
              final labels = [
                for (var i = 0; i < 11; i++)
                  tester.getRect(find.byKey(ValueKey('pitchName$i'))),
              ];
              for (var a = 0; a < 11; a++) {
                for (var b = 0; b < 11; b++) {
                  if (a == b) continue;
                  expect(
                    labels[a].overlaps(discs[b]),
                    isFalse,
                    reason:
                        '${shape.label} width=$width line=$line: '
                        "player $a's name is written across player $b's ball",
                  );
                  // And the balls themselves keep their distance. This is what
                  // bounds how large they can be drawn: they are sized right up
                  // against the closest two players ever stand, so without this
                  // the next "make them bigger" quietly makes them touch.
                  //
                  // Measured between CENTRES against the diameter, not as
                  // overlapping rectangles: two discs set diagonally have
                  // overlapping bounding boxes long before the circles inside
                  // them meet, and failing on that would cap the balls well
                  // below the size there is actually room for.
                  //
                  // The bar is real CLEAR AIR, not merely "not touching": two
                  // balls a point apart read as one blob, and the whole point of
                  // the exercise is a pitch you can take in at a glance.
                  final apart = (discs[a].center - discs[b].center).distance;
                  expect(
                    apart,
                    greaterThanOrEqualTo(discs[a].width * _minBallClearance),
                    reason:
                        '${shape.label} at ${pitchWidth.toInt()}pt, '
                        'width=$width line=$line: '
                        "player $a's ball crowds player $b's",
                  );
                }
              }
            }
          }
        }
      }
    });
  });

  /// The eleven at the widths a phone really is, in both languages.
  ///
  /// The names are data and do not translate, but the pitch around them does
  /// — the position badges, the instruction pills — and Czech is the longer
  /// language in every one of them.
  group('the eleven at phone widths', () {
    /// A worst-case XI: the longest surnames the seed pools hold, one name
    /// with spaces in it, and two short ones that must come out untouched.
    const surnames = [
      'Rakotoharimalala',
      'Tkeshelashvili',
      'Falepapalangi',
      'Papastathopoulos',
      'Schweinsteiger',
      'Lewandowski',
      'van der Berg',
      'Oyarzabal',
      'Zielinski',
      'Novak',
      'Sery',
    ];

    /// The smallest a name may be drawn at: [_nameFontSize] times the floor
    /// the widget keeps, less a rounding hair.
    const floorSize = 11.5 * 0.62 - 0.01;

    for (final width in [400.0, 360.0]) {
      for (final locale in [const Locale('en'), const Locale('cs')]) {
        testWidgets(
          'every name holds together at ${width.toInt()}px in '
          '${locale.languageCode}',
          (tester) async {
            tester.view
              ..devicePixelRatio = 1
              ..physicalSize = Size(width, 900);
            addTearDown(tester.view.reset);
            final squad = <int, Player>{
              for (var i = 0; i < 11; i++)
                100 + i: player(
                  id: 100 + i,
                  nationId: 1,
                  name: 'Q$i ${surnames[i]}',
                  position: formation.positions[i],
                ),
            };
            await tester.pumpApp(
              pitchAsTheAppLaysItOut(
                TacticsPitch(
                  formation: formation,
                  instructions: const TacticalInstructions(),
                  lineup: lineup,
                  byId: squad,
                  onTapSlot: (_) {},
                  onSwap: (_, __) {},
                  onBenchIn: (_, __) {},
                ),
              ),
              locale: locale,
            );
            await tester.pumpAndSettle();
            expectLocale(
              tester,
              find.byType(TacticsPitch),
              locale.languageCode,
            );
            expectNothingCut(tester, 'the pitch in ${locale.languageCode}');

            // Every name: one line, no smaller than the floor, and either the
            // whole surname or a beginning of it with a full stop to say so.
            var seen = 0;
            for (final text in tester.widgetList<Text>(find.byType(Text))) {
              final drawn = text.data;
              if (drawn == null) continue;
              final surname = surnames
                  .map((s) => s.split(' ').last.toUpperCase())
                  .where((s) => s.startsWith(drawn.replaceAll('.', '')))
                  .firstOrNull;
              if (surname == null) continue;
              seen++;
              expectOneLine(find.byWidget(text), 'the name "$drawn"');
              expect(
                text.style!.fontSize,
                greaterThanOrEqualTo(floorSize),
                reason: '"$drawn" is drawn too small to read',
              );
              expect(
                drawn == surname || drawn.endsWith('.'),
                isTrue,
                reason:
                    '"$drawn" is neither the whole of "$surname" nor a '
                    'shortened form that admits it',
              );
            }
            expect(
              seen,
              11,
              reason: 'all eleven names should be on the pitch, found $seen',
            );
          },
        );
      }
    }
  });

  /// A phone-sized surface tall enough for the whole 3:4 pitch, so every slot
  /// is on screen and hit-testable.
  void sizeSurface(WidgetTester tester) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(420, 900);
    addTearDown(tester.view.reset);
  }

  test('the drag hold is shorter than a full long-press', () {
    // The framework default (500ms) reads as an unresponsive scroll: the page
    // moves and the player never lifts. These tests hold for exactly
    // kDragHoldDelay, so reverting to the default would fail them.
    expect(kDragHoldDelay, lessThan(kLongPressTimeout));
    expect(kDragHoldDelay, greaterThan(kPressTimeout));
  });

  testWidgets('holding briefly then dragging onto another slot swaps them', (
    tester,
  ) async {
    sizeSurface(tester);
    final swaps = <(int, int)>[];
    await tester.pumpApp(harness(onSwap: (a, b) => swaps.add((a, b))));
    await tester.pumpAndSettle();

    // Two players in the same line, so the drag resolves to a plain swap.
    final from = tester.getCenter(find.byKey(const ValueKey('pitchDisc2')));
    final to = tester.getCenter(find.byKey(const ValueKey('pitchDisc3')));

    final gesture = await tester.startGesture(from);
    // Hold still past the drag delay so the drag beats the ListView's scroll.
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 50));
    await gesture.moveTo(to);
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(swaps, isNotEmpty, reason: 'the drag should have reported a swap');
    expect(swaps.single, (2, 3));
  });

  testWidgets('dragging a player across lines reshapes rather than swapping', (
    tester,
  ) async {
    sizeSurface(tester);
    final swaps = <(int, int)>[];
    await tester.pumpApp(harness(onSwap: (a, b) => swaps.add((a, b))));
    await tester.pumpAndSettle();

    // A defender onto a forward: different lines, so the screen resolves this
    // through resolveDrag (swap or reshape) — either way it must report.
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const ValueKey('pitchDisc2'))),
    );
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 50));
    await gesture.moveTo(
      tester.getCenter(find.byKey(const ValueKey('pitchDisc9'))),
    );
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(swaps.single, (2, 9));
  });

  testWidgets('a bench player can be dragged onto the pitch', (tester) async {
    sizeSurface(tester);
    final subs = <(int, int)>[];
    final bench = player(id: 200, nationId: 1, name: 'Sub One');
    // SubDragRow uses a ListTile, which needs the Material the real screen's
    // Scaffold provides.
    await tester.pumpApp(
      Scaffold(
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: TacticsPitch(
                formation: formation,
                instructions: const TacticalInstructions(),
                lineup: lineup,
                byId: byId,
                onTapSlot: (_) {},
                onSwap: (_, __) {},
                onBenchIn: (slot, id) => subs.add((slot, id)),
              ),
            ),
            SubDragRow(player: bench),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Sub One')),
    );
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 50));
    await gesture.moveTo(
      tester.getCenter(find.byKey(const ValueKey('pitchDisc9'))),
    );
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(subs.single, (
      9,
      200,
    ), reason: 'the sub replaces the dragged-on slot');
  });

  testWidgets('dragging without holding first scrolls instead of swapping', (
    tester,
  ) async {
    sizeSurface(tester);
    final swaps = <(int, int)>[];
    await tester.pumpApp(harness(onSwap: (a, b) => swaps.add((a, b))));
    await tester.pumpAndSettle();

    // The hold is what disambiguates a player move from a list scroll, so an
    // immediate drag must scroll and leave the XI alone.
    await tester.drag(
      find.byKey(const ValueKey('pitchDisc2')),
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();

    expect(
      swaps,
      isEmpty,
      reason: 'an immediate drag is a scroll, not a player move',
    );
  });

  testWidgets('dropping a player in open space reports where he landed', (
    tester,
  ) async {
    sizeSurface(tester);
    int? movedSlot;
    double? movedY;
    await tester.pumpApp(
      harness(
        onSwap: (_, __) {},
        onMoveToSpace: (slot, dropY) {
          movedSlot = slot;
          movedY = dropY;
        },
      ),
    );
    await tester.pumpAndSettle();

    final pitch = tester.getRect(find.byType(TacticsPitch));
    // Pick a midfielder up and release him high up the pitch, in the space
    // wide of the forwards rather than on top of one.
    // P5 is a midfielder in 4-4-2 — the same naming the other drag tests use.
    final start = tester.getCenter(find.byKey(const ValueKey('pitchDisc5')));
    final gesture = await tester.startGesture(start);
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 40));
    await gesture.moveTo(
      Offset(pitch.left + pitch.width * 0.08, pitch.top + pitch.height * 0.10),
    );
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(movedSlot, isNotNull, reason: 'the space drop was never reported');
    expect(movedY, isNotNull);
    expect(movedY, lessThan(0.35), reason: 'dropped high up the pitch');
  });
}
