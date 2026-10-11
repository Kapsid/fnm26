import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _qualifying(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.qualifyingDraw}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Future<void> _skip(WidgetTester tester) async {
  await tester.tap(find.text(enL.tourSharedSkip));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

/// The landscape stage: full screen (no shell, no phone frame), pots left of
/// the groups.
void _isStage(WidgetTester tester) {
  expect(tester.takeException(), isNull);
  expect(find.byKey(DrawCeremony.landscapeKey), findsOneWidget);
  expect(find.byType(FullScreenPhoneFrame), findsNothing);
  expect(find.byType(TabletSidebar), findsNothing);
  // The first group's card, whatever the draw named it.
  final groups = tester.widget<DrawCeremony>(find.byType(DrawCeremony)).groups;
  expect(
    tester.getCenter(find.text(enL.tourPot(1))).dx,
    lessThan(
      tester
          .getCenter(find.text(enL.tourSharedGroupName(groups.first.name)))
          .dx,
    ),
  );
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the qualifying draw on a landscape stage, $size', (
      tester,
    ) async {
      await _qualifying(tester, size);
      _isStage(tester);
      await _skip(tester);
      expect(tester.takeException(), isNull);
      expect(find.text(enL.tourSharedDrawComplete), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('the continental draw on a landscape stage, $size', (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          continentalDrawProvider((
            careerId: kSeededCareerId,
            confederation: Confederation.europe,
          )).overrideWith((ref) async => fakeContinentalDraw(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.continentalDraw}?careerId=${save.careerId}'
        '&conf=${Confederation.europe.name}',
        size: size,
      );
      _isStage(tester);
      await _skip(tester);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('the Nations Cup draw on a landscape stage, $size', (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          nationsCupDrawProvider(
            kSeededCareerId,
          ).overrideWith((ref) async => fakeNationsCupDraw(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.nationsCupDraw}?careerId=${save.careerId}',
        size: size,
      );
      _isStage(tester);
      await _skip(tester);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('the landscape stage draws exactly the stored groups '
      '(Review Focus 1)', (tester) async {
    final save = await _qualifying(tester, kTabletSize);
    final ceremony = tester.widget<DrawCeremony>(find.byType(DrawCeremony));
    expect(ceremony.landscape, isTrue);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    late List<FinalsGroupTable> stored;
    await tester.runAsync(() async {
      stored = await save.container
          .read(competitionRepositoryProvider)
          .tournamentGroupTables(
            save.careerId,
            CompetitionKind.continentalQualifying,
            confederation: me.confederation,
          );
    });
    expect(
      stored,
      isNotEmpty,
      reason:
          'the seeded save opens on a drawn continental qualifying campaign',
    );
    expect(
      {for (final g in ceremony.groups) g.name: g.nationIds.toSet()},
      {
        for (final t in stored)
          t.name: {for (final s in t.standings) s.nationId},
      },
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a window crossing 1000 mid-draw keeps the draw where it was '
      '(Review Focus 2)', (tester) async {
    await _qualifying(tester, kTabletSize);
    final before = tester.state<DrawCeremonyState>(find.byType(DrawCeremony));
    // Two balls by hand (a tap pauses the autoplay, so nothing else moves).
    await tester.tap(find.byType(GridView));
    await tester.pump();
    await tester.tap(find.byType(GridView));
    await tester.pump();
    expect(before.revealed, 2);

    tester.view.physicalSize = const Size(700, 810);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
    expect(find.byKey(DrawCeremony.landscapeKey), findsNothing);
    final narrow = tester.state<DrawCeremonyState>(find.byType(DrawCeremony));
    expect(identical(narrow, before), isTrue, reason: 'the draw restarted');
    expect(narrow.revealed, 2);

    tester.view.physicalSize = kTabletSize;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(DrawCeremony.landscapeKey), findsOneWidget);
    expect(
      identical(
        tester.state<DrawCeremonyState>(find.byType(DrawCeremony)),
        before,
      ),
      isTrue,
    );
    expect(before.revealed, 2);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Continue after the landscape draw goes back to the hub', (
    tester,
  ) async {
    final save = await _qualifying(tester, kTabletSize);
    await _skip(tester);
    await tester.tap(
      find.widgetWithText(PrimaryButton, enL.tourSharedContinue),
    );
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.hub,
    );
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets("the manager's ball sits on the same line as the others in its "
      'pot', (tester) async {
    final save = await _qualifying(tester, kTabletSize);
    final code = save.nations.firstWhere((n) => n.id == save.nationId).code;
    // The labelled pill's flag, out in a pot (the stage is still empty).
    final pill = find.byWidgetPredicate(
      (w) => w is FlagDisc && w.code == code && w.highlighted,
    );
    expect(pill, findsOneWidget);
    final pot = find.ancestor(of: pill, matching: find.byType(Wrap)).first;
    final others = find.descendant(
      of: pot,
      matching: find.byWidgetPredicate((w) => w is FlagDisc && !w.highlighted),
    );
    expect(others, findsWidgets);
    final mine = tester.getCenter(pill).dy;
    final theirs = tester.getCenter(others.first).dy;
    expect(mine, closeTo(theirs, 0.5));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("the manager's row in a group card is the height of every other "
      'row, its flag and name on the same line', (tester) async {
    final save = await _qualifying(tester, kTabletSize);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    final mine = find.descendant(
      of: find.byType(GridView),
      matching: find.text(me.name),
    );
    // Ball by ball (a tap pauses the autoplay) until the manager's nation
    // has been drawn and placed.
    for (var i = 0; i < 300 && mine.evaluate().isEmpty; i++) {
      await tester.tap(find.byType(GridView));
      await tester.pump();
    }
    await tester.pump(const Duration(milliseconds: 400));
    expect(mine, findsOneWidget);

    // A group card's slot rows: the Expanded children of its column, as
    // wide as the column (the name's own Expanded is narrower).
    Rect slotOf(Finder name) {
      final column = tester.getRect(
        find.ancestor(of: name, matching: find.byType(Column)).first,
      );
      return find
          .ancestor(of: name, matching: find.byType(Expanded))
          .evaluate()
          .map((e) => tester.getRect(find.byWidget(e.widget)))
          .firstWhere((r) => (r.width - column.width).abs() < 0.5);
    }

    final other = save.nations.firstWhere(
      (n) =>
          n.id != me.id &&
          find
              .descendant(
                of: find.byType(GridView),
                matching: find.text(n.name),
              )
              .evaluate()
              .isNotEmpty,
    );
    final theirs = find.descendant(
      of: find.byType(GridView),
      matching: find.text(other.name),
    );
    final mySlot = slotOf(mine);
    final theirSlot = slotOf(theirs);
    expect(mySlot.height, closeTo(theirSlot.height, 0.01));
    // The name and the flag sit at the same height within the slot.
    expect(
      tester.getRect(mine).top - mySlot.top,
      closeTo(tester.getRect(theirs).top - theirSlot.top, 0.01),
    );
    Finder flagIn(Finder name) => find.descendant(
      of: find.ancestor(of: name, matching: find.byType(Row)).first,
      matching: find.byType(FlagDisc),
    );
    expect(
      tester.getCenter(flagIn(mine)).dy - mySlot.top,
      closeTo(tester.getCenter(flagIn(theirs)).dy - theirSlot.top, 0.01),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
