import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/features/tactics/slot_switch_strip.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';

/// Changing a place within the formation from the pitch: a TAP on a slot
/// opens its picker with the position chips at its head; a long press still
/// drags, and never opens anything.
void main() {
  const formation = Formation.f433;

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

  late InMatchTacticsResult? result;

  Future<AppLocalizations> open(
    WidgetTester tester, {
    SlotSwitches switches = SlotSwitches.none,
    double width = 400,
    Locale locale = const Locale('en'),
  }) async {
    result = null;
    await tester.binding.setSurfaceSize(Size(width, 2600));
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
                  onPressed: () async => result = await showInMatchTactics(
                    inner,
                    minute: 60,
                    formation: formation,
                    lineup: [for (var i = 1; i <= 11; i++) i],
                    instructions: const TacticalInstructions(),
                    switches: switches,
                    pool: squad(),
                    startingIds: {for (var i = 1; i <= 11; i++) i},
                    maxSubs: 5,
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

  Finder disc(int slot) => find.byKey(ValueKey('pitchDisc$slot'));
  String badge(WidgetTester tester, int slot) => tester
      .widget<Text>(
        find.descendant(
          of: find.byKey(ValueKey('pitchPos$slot')),
          matching: find.byType(Text),
        ),
      )
      .data!;

  Future<void> apply(WidgetTester tester, AppLocalizations l) async {
    await tester.tap(find.text(l.tacticsApply));
    await tester.pumpAndSettle();
  }

  testWidgets('tap a 4-3-3 CM, pick DM: the slot plays DM, shape unchanged', (
    tester,
  ) async {
    final l = await open(tester);
    expect(badge(tester, 6), 'CM');
    await tester.tap(disc(6));
    await tester.pumpAndSettle();
    expect(find.text(l.tacticsSlotSwitchHeading('4-3-3')), findsOneWidget);
    await tester.tap(find.byKey(SlotSwitchKeys.choice(PlayerPosition.dm)));
    await tester.pumpAndSettle();
    // The sheet has closed and the pitch says what the slot now is.
    expect(find.byType(SlotSwitchStrip), findsNothing);
    expect(badge(tester, 6), 'DM');

    await apply(tester, l);
    expect(result!.formation, formation);
    expect(result!.switches.bySlot, {6: PlayerPosition.dm});
    expect(result!.positions[6], PlayerPosition.dm);
    expect(result!.lineup, [for (var i = 1; i <= 11; i++) i]);
  });

  for (final code in ['fi', 'de', 'cs', 'hu']) {
    testWidgets('the chips fit a 320 phone in $code', (tester) async {
      await open(
        tester,
        width: 320,
        locale: Locale(code),
        switches: const SlotSwitches({
          6: PlayerPosition.dm,
          7: PlayerPosition.am,
        }),
      );
      // A switched slot (reset shown) and a slot over the limit (note shown).
      for (final slot in [6, 9]) {
        await tester.tap(disc(slot));
        await tester.pumpAndSettle();
        expect(find.byType(SlotSwitchStrip), findsOneWidget);
        expect(tester.takeException(), isNull, reason: 'slot $slot');
        // The strip's own copy; the editor's app bar is not this test's.
        expectWhole(
          find.descendant(
            of: find.byType(SlotSwitchStrip),
            matching: find.byType(RichText),
          ),
          'slot $slot chips',
        );
        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle();
      }
    });
  }

  testWidgets('a slot with nothing to switch to shows no chips', (
    tester,
  ) async {
    await open(tester);
    await tester.tap(disc(2)); // a centre-back
    await tester.pumpAndSettle();
    expect(find.byKey(SlotSwitchKeys.choice(PlayerPosition.cb)), findsNothing);
  });

  testWidgets('the limit is two, and the sheet says so', (tester) async {
    final l = await open(
      tester,
      switches: const SlotSwitches({
        6: PlayerPosition.dm,
        7: PlayerPosition.am,
      }),
    );
    await tester.tap(disc(9)); // the striker
    await tester.pumpAndSettle();
    expect(find.byKey(SlotSwitchKeys.limit), findsOneWidget);
    expect(find.text(l.tacticsSlotSwitchLimit), findsOneWidget);
    await tester.tap(find.byKey(SlotSwitchKeys.choice(PlayerPosition.am)));
    await tester.pumpAndSettle();
    expect(badge(tester, 9), 'ST', reason: 'a third switch is refused');

    // A switched slot offers its reset, which brings back the room.
    await tester.tapAt(const Offset(5, 5)); // dismiss
    await tester.pumpAndSettle();
    await tester.tap(disc(7));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SlotSwitchKeys.reset));
    await tester.pumpAndSettle();
    expect(badge(tester, 7), 'CM');
    await apply(tester, l);
    expect(result!.switches.bySlot, {6: PlayerPosition.dm});
  });

  testWidgets('a long press still drags: the swap lands, no sheet opens', (
    tester,
  ) async {
    final l = await open(
      tester,
      switches: const SlotSwitches({6: PlayerPosition.dm}),
    );
    final gesture = await tester.startGesture(tester.getCenter(disc(6)));
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(disc(7)));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.byType(SlotSwitchStrip), findsNothing);
    // The players swapped; the places did not move with them.
    expect(badge(tester, 6), 'DM');
    await apply(tester, l);
    expect(result!.lineup[6], 8);
    expect(result!.lineup[7], 7);
    expect(result!.switches.bySlot, {6: PlayerPosition.dm});
  });

  testWidgets('a drag that reshapes the side resets the switches', (
    tester,
  ) async {
    final l = await open(
      tester,
      switches: const SlotSwitches({7: PlayerPosition.am}),
    );
    // The striker dragged onto a midfielder: a new line count, so a new
    // formation, and a new structure has no use for the old switches.
    final gesture = await tester.startGesture(tester.getCenter(disc(9)));
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(disc(6)));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    await apply(tester, l);
    expect(result!.formation, isNot(formation));
    expect(result!.switches, SlotSwitches.none);
  });
}
