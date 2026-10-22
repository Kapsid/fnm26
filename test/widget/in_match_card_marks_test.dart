import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/card_status.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/shared/widgets/card_mark.dart';

import '../helpers/in_match_editor.dart';
import '../helpers/seeded_save.dart';

/// A booked man carries his card into every list a substitution is made from.
///
/// The manager's report: a card showed on the formation page, "but when I go
/// to do a substitution, it doesn't show next to the player name, so I end up
/// going back to the formation/tactic screen to see which players have cards".
/// The question behind half of all substitutions — who is one tackle from
/// being sent off — had to be answered on another screen.
void main() {
  // Starter3 (slot 2, a centre-back) and Bench12 (a central midfielder) are
  // on a yellow; nobody else is.
  const cards = {3: MatchCard.yellow, 12: MatchCard.yellow};

  /// The card marks inside the nearest [T] that holds [name].
  Finder marksBy<T extends Widget>(String name) => find.descendant(
    of: find.ancestor(of: find.text(name), matching: find.byType(T)).first,
    matching: find.byType(CardMark),
  );

  Future<void> showPitchTab(WidgetTester tester, {Finder? within}) async {
    final chip = within == null
        ? find.text(enL.tacticsTabOnPitch)
        : find.descendant(
            of: within,
            matching: find.text(enL.tacticsTabOnPitch),
          );
    await tester.ensureVisible(chip.first);
    await tester.pumpAndSettle();
    await tester.tap(chip.first);
    await tester.pumpAndSettle();
  }

  group('on a phone', () {
    testWidgets('the pitch disc of a booked man wears the card', (
      tester,
    ) async {
      await openEditor(
        tester,
        size: const Size(400, 2600),
        cardsByPlayer: cards,
      );
      final mark = find.byKey(const ValueKey('pitchCard2'));
      expect(mark, findsOneWidget);
      expect(find.byKey(const ValueKey('pitchCard3')), findsNothing);
      // On HIS ball, not on a neighbour's.
      final disc = tester.getRect(find.byKey(const ValueKey('pitchDisc2')));
      expect(tester.getRect(mark).overlaps(disc), isTrue);
    });

    testWidgets('the bench and on-pitch lists name the booked', (
      tester,
    ) async {
      await openEditor(
        tester,
        size: const Size(400, 2600),
        cardsByPlayer: cards,
      );
      expect(marksBy<SubDragRow>('Bench12'), findsOneWidget);
      expect(marksBy<SubDragRow>('Bench13'), findsNothing);
      await showPitchTab(tester);
      expect(marksBy<Row>('Starter3'), findsOneWidget);
      expect(marksBy<Row>('Starter4'), findsNothing);
    });

    testWidgets('the slot picker names the booked', (tester) async {
      await openEditor(
        tester,
        size: const Size(400, 2600),
        cardsByPlayer: cards,
      );
      // A central-midfield place, so the bench midfielders are its shortlist.
      await tester.tap(find.byKey(const ValueKey('pitchDisc6')));
      await tester.pumpAndSettle();
      final sheet = find.byType(BottomSheet);
      expect(sheet, findsOneWidget);
      Finder inSheet(String name) => find.descendant(
        of: find
            .ancestor(
              of: find.descendant(of: sheet, matching: find.text(name)),
              matching: find.byType(ListTile),
            )
            .first,
        matching: find.byType(CardMark),
      );
      expect(inSheet('Bench12'), findsOneWidget);
      expect(inSheet('Bench13'), findsNothing);
      await showPitchTab(tester, within: sheet);
      expect(inSheet('Starter3'), findsOneWidget);
      expect(inSheet('Starter4'), findsNothing);
    });
  });

  testWidgets('on a tablet the pitch and the lists beside it agree', (
    tester,
  ) async {
    await openEditor(
      tester,
      size: kTabletSize,
      tabletLayout: true,
      cardsByPlayer: cards,
    );
    expect(find.byKey(const ValueKey('pitchCard2')), findsOneWidget);
    expect(marksBy<SubDragRow>('Bench12'), findsOneWidget);
    expect(marksBy<SubDragRow>('Bench13'), findsNothing);
    await showPitchTab(tester);
    expect(marksBy<Row>('Starter3'), findsOneWidget);
    expect(marksBy<Row>('Starter4'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
