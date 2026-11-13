import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/manager/manager_age.dart';
import 'package:fnm/features/career/new_game_screen.dart';
import 'package:fnm/features/manager/manager_age_widgets.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The manager's own age on screen (release 1.1.2): asked beside his name at
/// New Game, asked once on the hub of a save from before ages, and shown on
/// his page.
void main() {
  Future<int?> birthYear(WidgetTester tester, SeededSave save) async {
    int? year;
    await tester.runAsync(() async {
      year =
          (await save.container
                  .read(careerRepositoryProvider)
                  .byId(save.careerId))!
              .managerBirthYear;
    });
    return year;
  }

  bool startEnabled(WidgetTester tester) =>
      tester
          .widget<PrimaryButton>(find.byKey(NewGameScreen.startKey))
          .onPressed !=
      null;

  for (final (label, size, formFactor) in [
    ('phone', kPhoneSize, FormFactor.phone),
    ('tablet', kTabletSize, FormFactor.tablet),
  ]) {
    testWidgets('$label: New Game asks the age beside the name, 45 to start', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: formFactor);
      await pumpRoute(
        tester,
        save,
        '${Routes.newGame}?nationId=${rivalNation.id}',
        size: size,
      );
      final field = find.descendant(
        of: find.byKey(ManagerAgeField.fieldKey),
        matching: find.byType(TextField),
      );
      expect(field, findsOneWidget);
      expect(tester.widget<TextField>(field).controller!.text, '45');
      expect(startEnabled(tester), isTrue);

      // Out of range: said under the field, and Start waits.
      await tester.enterText(field, '29');
      await tester.pump();
      expect(find.text(enL.managerAgeRange(30, 75)), findsOneWidget);
      expect(startEnabled(tester), isFalse);
      await tester.enterText(field, '');
      await tester.pump();
      expect(startEnabled(tester), isFalse);

      await tester.enterText(field, '75');
      await tester.pump();
      expect(find.text(enL.managerAgeRange(30, 75)), findsNothing);
      expect(startEnabled(tester), isTrue);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a new career is never asked for an age on the hub', (
    tester,
  ) async {
    final save = await seedSave(tester);
    expect(await birthYear(tester, save), 2026 - seededManagerAge);
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(find.byKey(ManagerAgeQuestionCard.cardKey), findsNothing);
  });

  for (final (label, size, formFactor) in [
    ('phone', kPhoneSize, FormFactor.phone),
    ('tablet', kTabletSize, FormFactor.tablet),
  ]) {
    testWidgets('$label: an old save is asked once, and Skip puts it away', (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: formFactor,
        withoutManagerAge: true,
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.hub}?careerId=${save.careerId}',
        size: size,
      );
      // The tour offer pops on a new save's first hub: answer it first.
      if (find.text(enL.tourOfferNo).evaluate().isNotEmpty) {
        await tester.tap(find.text(enL.tourOfferNo));
        await settle(tester);
      }
      final card = find.byKey(ManagerAgeQuestionCard.cardKey);
      await tester.scrollUntilVisible(
        card,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(find.text(enL.managerAgePromptTitle), findsOneWidget);
      await tester.tap(find.byKey(ManagerAgeQuestionCard.skipKey));
      await settle(tester);
      expect(card, findsNothing);
      expect(await birthYear(tester, save), isNull);
      // Never again, on this or any later visit.
      bool asked = true;
      await tester.runAsync(() async {
        asked = await save.container.read(
          managerAgeQuestionProvider(save.careerId).future,
        );
      });
      expect(asked, isFalse);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('an answer is stored and the card goes', (tester) async {
    final save = await seedSave(tester, withoutManagerAge: true);
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    if (find.text(enL.tourOfferNo).evaluate().isNotEmpty) {
      await tester.tap(find.text(enL.tourOfferNo));
      await settle(tester);
    }
    final card = find.byKey(ManagerAgeQuestionCard.cardKey);
    await tester.scrollUntilVisible(
      card,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(ManagerAgeQuestionCard.setKey));
    await settle(tester);
    final field = find.descendant(
      of: find.byKey(ManagerAgeField.fieldKey),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, '58');
    await tester.pump();
    await tester.tap(find.byKey(ManagerAgeQuestionCard.saveKey));
    await settle(tester);
    expect(card, findsNothing);
    final career = await tester.runAsync(
      () => save.container.read(careerRepositoryProvider).byId(save.careerId),
    );
    expect(managerAgeOf(career!), 58);
    expect(tester.takeException(), isNull);
  });

  Future<SeededSave> openManagerPage(
    WidgetTester tester, {
    int? birthYearOverride,
  }) async {
    final save = await seedSave(
      tester,
      overrides: [
        // See manager_rename_phone_test: nothing on the page watches morale.
        moraleProvider(kSeededCareerId).overrideWith((ref) async => 50),
      ],
    );
    if (birthYearOverride != null) {
      await tester.runAsync(
        () => save.container
            .read(careerRepositoryProvider)
            .setManagerBirthYear(save.careerId, birthYearOverride),
      );
    }
    await pumpRoute(
      tester,
      save,
      '${Routes.manager}?careerId=${save.careerId}',
    );
    return save;
  }

  testWidgets('his page shows his age, and the board never retires him', (
    tester,
  ) async {
    await openManagerPage(tester);
    expect(find.text(enL.tacticsAgeOnly(seededManagerAge)), findsOneWidget);
    expect(find.text(enL.managerSuccession), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('at 70 the board asks about succession, as flavour', (
    tester,
  ) async {
    await openManagerPage(
      tester,
      birthYearOverride: 2026 - ManagerAge.successionAge,
    );
    expect(
      find.text(enL.tacticsAgeOnly(ManagerAge.successionAge)),
      findsOneWidget,
    );
    expect(find.text(enL.managerSuccession), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
