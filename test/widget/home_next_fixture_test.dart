import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/home/home_next_line_providers.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../helpers/seeded_save.dart';

/// The home's continue cards say what comes next for the save: the manager's
/// next fixture when he has one, and otherwise where the cycle stands. They
/// used to read "Road to the {year} World Championship" whatever the save was
/// doing, even with that World Championship already played.
void main() {
  const small = Size(360, 640);

  HomeNextLine line({
    Fixture? next,
    bool drawWatched = true,
    bool decided = false,
    bool hasFinals = false,
  }) => (
    next: next,
    homeName: 'Czechia',
    awayName: 'Norway',
    drawWatched: drawWatched,
    decided: decided,
    hasFinals: hasFinals,
  );

  final fixture = Fixture(
    id: 9,
    careerId: kSeededCareerId,
    competitionId: 1,
    matchday: 5,
    date: DateTime(2027, 9, 10),
    homeNationId: 1,
    awayNationId: 2,
  );

  String cardText(WidgetTester tester, Key card) => tester
      .widgetList<Text>(
        find.descendant(of: find.byKey(card), matching: find.byType(Text)),
      )
      .map((t) => t.data ?? '')
      .join('\n');

  Future<String> text(
    WidgetTester tester,
    HomeNextLine l, {
    bool tablet = false,
  }) async {
    final save = await seedSave(
      tester,
      formFactor: tablet ? FormFactor.tablet : FormFactor.phone,
      overrides: [
        homeNextLineProvider(kSeededCareerId).overrideWith((ref) async => l),
      ],
    );
    await pumpRoute(
      tester,
      save,
      Routes.home,
      size: tablet ? kTabletSize : small,
    );
    expect(tester.takeException(), isNull);
    final t = cardText(
      tester,
      tablet ? HomeScreen.tabletLayoutKey : HomeScreen.heroKey,
    );
    await tester.pumpWidget(const SizedBox());
    return t;
  }

  testWidgets('the next fixture, opponent and all', (tester) async {
    final t = await text(tester, line(next: fixture));
    expect(t, contains('Next: '));
    expect(t, contains('Norway'));
    expect(t, isNot(contains('Road to')));
  });

  testWidgets('the opponent stays hidden until the draw is watched', (
    tester,
  ) async {
    final t = await text(tester, line(next: fixture, drawWatched: false));
    expect(t, contains('Draw to come'));
    expect(t, isNot(contains('Norway')));
  });

  testWidgets('no fixture and the World Championship played: the verdict', (
    tester,
  ) async {
    final t = await text(tester, line(decided: true, hasFinals: true));
    expect(t, isNot(contains('Road to')));
    expect(t, contains('is over'));
  });

  testWidgets('no fixture while the finals run without him: watching', (
    tester,
  ) async {
    final t = await text(tester, line(hasFinals: true));
    expect(t, contains('Following the'));
  });

  testWidgets('no fixture and no finals yet: the road to them', (
    tester,
  ) async {
    final t = await text(tester, line());
    expect(t, contains('Road to the'));
  });

  testWidgets('the tablet card says the same', (tester) async {
    final t = await text(tester, line(next: fixture), tablet: true);
    expect(t, contains('Next: '));
    expect(t, contains('Norway'));
  });

  // The review's catch: the card used to watch the hub's whole load (squad
  // pool, group tables, host berths), started the moment a manager taps
  // Continue and thrown away on navigation. It reads its own few rows now.
  testWidgets('a real save: the line from its own reads, never the hub', (
    tester,
  ) async {
    var hubBuilds = 0;
    final save = await seedSave(
      tester,
      overrides: [
        hubDataProvider(kSeededCareerId).overrideWith((ref) async {
          hubBuilds++;
          return null;
        }),
      ],
    );
    final watch = Stopwatch()..start();
    late HomeNextLine? read;
    await tester.runAsync(() async {
      read = await save.container.read(
        homeNextLineProvider(kSeededCareerId).future,
      );
    });
    watch.stop();
    expect(read, isNotNull);
    expect(read!.next, isNotNull, reason: 'a new save has a fixture ahead');
    // A handful of indexed reads on a fresh save, not a pool build.
    expect(watch.elapsedMilliseconds, lessThan(2000));
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(tester.takeException(), isNull);
    expect(cardText(tester, HomeScreen.heroKey), contains('Next: '));
    expect(hubBuilds, 0);
    await tester.pumpWidget(const SizedBox());
  });
}
