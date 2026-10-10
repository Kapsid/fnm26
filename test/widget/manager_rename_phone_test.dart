import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';

import '../helpers/seeded_save.dart';

/// The phone's rename dialog: it owns its text controller now (it used to be
/// disposed while the dialog was still closing), so pin what it does.
Future<SeededSave> _open(WidgetTester tester) async {
  final save = await seedSave(
    tester,
    overrides: [
      // ManagerService invalidates morale, which nothing on this page
      // watches, so nothing rebuilds it.
      // Test-only, no app change: in riverpod 2.6.1 (async_notifier/base.dart
      // 461-466) an invalidated FutureProvider element that is never rebuilt
      // before the container is disposed has its future completed a second
      // time on that dispose ("Bad state: Future already completed"). A value
      // with no awaits is never left in that state. Revisit at the Riverpod 3
      // upgrade.
      moraleProvider(kSeededCareerId).overrideWith((ref) async => 50),
    ],
  );
  await pumpRoute(tester, save, '${Routes.manager}?careerId=${save.careerId}');
  return save;
}

Future<String> _name(WidgetTester tester, SeededSave save) async {
  late String name;
  await tester.runAsync(() async {
    name =
        (await save.container
                .read(careerRepositoryProvider)
                .byId(save.careerId))!
            .managerName;
  });
  return name;
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.tap(find.byTooltip(enL.managerRename));
  await settle(tester);
  expect(find.byType(AlertDialog), findsOneWidget);
  await tester.enterText(find.byType(TextField), text);
}

void main() {
  testWidgets('Save writes the name and shows it', (tester) async {
    final save = await _open(tester);
    expect(await _name(tester, save), isNot('Vera'));
    expect(find.text('Vera'), findsNothing);
    await _type(tester, 'Vera');
    await tester.tap(find.text(enL.managerRenameSave));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(await _name(tester, save), 'Vera');
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Vera'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Cancel leaves the name as it was', (tester) async {
    final save = await _open(tester);
    final before = await _name(tester, save);
    expect(before, isNot('Vera'));
    await _type(tester, 'Vera');
    await tester.tap(find.text(enL.careerCancel));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(await _name(tester, save), before);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Vera'), findsNothing);
    expect(find.text(before), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the keyboard done key saves too', (tester) async {
    final save = await _open(tester);
    expect(await _name(tester, save), isNot('Vera'));
    await _type(tester, 'Vera');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(await _name(tester, save), 'Vera');
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Vera'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
