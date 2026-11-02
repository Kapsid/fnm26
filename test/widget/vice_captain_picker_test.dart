import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';

import '../helpers/seeded_save.dart';

/// Naming a vice-captain from the tactics screen, the way the captain is
/// named: tap the post, pick a man from the sheet.
void main() {
  testWidgets('the 1st vice-captain is named from the armband card, and '
      'making him captain empties his old post', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=2',
    );
    expect(tester.takeException(), isNull);
    expect(find.text(enL.viceCaptainFirst.toUpperCase()), findsOneWidget);
    expect(find.text(enL.viceCaptainSecond.toUpperCase()), findsOneWidget);
    expect(find.text(enL.viceCaptainNone), findsNWidgets(2));

    Future<Career> career() async => (await tester.runAsync(
      () => save.container.read(careerRepositoryProvider).byId(save.careerId),
    ))!;

    // The 1st vice post: the sheet explains it, then the first man listed.
    await tester.tap(find.text(enL.viceCaptainNone).first);
    await settle(tester);
    expect(find.text(enL.viceCaptainHint), findsOneWidget);
    final sheet = find.ancestor(
      of: find.text(enL.viceCaptainHint),
      matching: find.byType(ListView),
    );
    final first = find
        .descendant(of: sheet, matching: find.byType(ListTile))
        .first;
    final name = tester
        .widget<Text>(
          find.descendant(of: first, matching: find.byType(Text)).at(1),
        )
        .data!;
    await tester.tap(first);
    await settle(tester);

    var saved = await career();
    expect(saved.viceCaptain1PlayerId, isNotNull);
    expect(saved.captainPlayerId, isNull);
    expect(find.text(enL.viceCaptainNone), findsOneWidget);
    expect(find.textContaining(name), findsWidgets);

    // The same man made captain: one post per man, so the 1st vice post
    // empties.
    await tester.tap(find.text(enL.captainNone));
    await settle(tester);
    final captainSheet = find.ancestor(
      of: find.text(enL.squadCaptain.toUpperCase()).last,
      matching: find.byType(ListView),
    );
    await tester.tap(
      find.descendant(
        of: captainSheet,
        matching: find.widgetWithText(ListTile, name),
      ),
    );
    await settle(tester);

    saved = await career();
    expect(saved.captainPlayerId, isNotNull);
    expect(saved.viceCaptain1PlayerId, isNull);
    expect(find.text(enL.viceCaptainNone), findsNWidgets(2));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
