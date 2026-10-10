import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/features/federation/staff_card.dart';
import 'package:fnm/features/manager/manager_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tactics/condition_providers.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  int points = 0,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      if (points > 0) managerWithPoints(points),
      // ManagerService invalidates morale, which nothing on this page
      // watches. In debug, riverpod 2.6's invalidate mounts it; the real one
      // is auto-disposed between its awaits, watches more providers after
      // that, and the teardown disposes it twice ("Future already
      // completed"). A value with no awaits cannot outlive its disposal. See
      // phone_guard_y_test.dart.
      moraleProvider(kSeededCareerId).overrideWith((ref) async => 50),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.manager}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Future<Career> _career(WidgetTester tester, SeededSave save) async {
  late Career career;
  await tester.runAsync(() async {
    career = (await save.container
        .read(careerRepositoryProvider)
        .byId(save.careerId))!;
  });
  return career;
}

/// The + of each skill row, in the phone's order: man-management, tactical,
/// youth development, negotiation.
Finder _raise(int skill) => find
    .descendant(
      of: find.byKey(ManagerScreen.skillsKey),
      matching: find.widgetWithIcon(IconButton, Icons.add_circle),
    )
    .at(skill);

void main() {
  for (final size in kTabletSizes) {
    testWidgets('skills on the left, name and staff on the right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(ManagerScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final skills = tester.getRect(find.byKey(ManagerScreen.skillsKey));
      final staff = tester.getRect(find.byType(StaffCard));
      expect(staff.left, greaterThan(skills.right));
      expect(find.text(enL.managerSkills), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('two points raise two skills by one each, then no more', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize, points: 2);
    final before = await _career(tester, save);
    expect(find.text(enL.managerPointsAvailable(2)), findsOneWidget);
    await tester.tap(_raise(1));
    await settle(tester);
    await tester.tap(_raise(2));
    await settle(tester);
    final after = await _career(tester, save);
    expect(after.skillTactical, before.skillTactical + 1);
    expect(after.skillYouthDevelopment, before.skillYouthDevelopment + 1);
    expect(after.skillManManagement, before.skillManManagement);
    expect(after.skillNegotiation, before.skillNegotiation);
    expect(find.text(enL.managerPointsAvailable(0)), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      expect(tester.widget<IconButton>(_raise(i)).onPressed, isNull);
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the pencil renames the manager', (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byTooltip(enL.managerRename));
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'Vera');
    await tester.tap(find.text(enL.managerRenameSave));
    await settle(tester);
    expect((await _career(tester, save)).managerName, 'Vera');
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Vera'), findsWidgets);
    await tester.pumpWidget(const SizedBox());
  });
}
