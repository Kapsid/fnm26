import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../helpers/fixtures.dart';
import '../helpers/seeded_save.dart';

/// The Bento home's continue card says what comes next for the save: the
/// manager's next fixture when he has one, and otherwise where the cycle
/// stands. It used to read "Road to the {year} World Championship" whatever
/// the save was doing, even with that World Championship already played.
void main() {
  const small = Size(360, 640);

  HubData hub({
    Fixture? next,
    bool drawWatched = true,
    int? champion,
    bool hasFinals = false,
  }) => HubData(
    career: Career(
      id: kSeededCareerId,
      managerName: 'M',
      nationId: 1,
      rngSeed: 1,
      createdAt: DateTime(2026),
      inGameDate: DateTime(2027, 9, 7),
    ),
    group: null,
    next: next,
    fixtures: const [],
    nations: {
      1: nation(id: 1, name: 'Czechia'),
      2: nation(id: 2, name: 'Norway'),
    },
    squadSize: 23,
    squadRating: 75,
    championNationId: champion,
    hasFinals: hasFinals,
    nextDrawWatched: drawWatched,
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

  Future<String> line(WidgetTester tester, HubData h) async {
    final save = await seedSave(
      tester,
      overrides: [
        hubDataProvider(kSeededCareerId).overrideWith((ref) async => h),
      ],
    );
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(tester.takeException(), isNull);
    final texts = tester
        .widgetList<Text>(
          find.descendant(
            of: find.byKey(HomeScreen.heroKey),
            matching: find.byType(Text),
          ),
        )
        .map((t) => t.data ?? '')
        .join('\n');
    await tester.pumpWidget(const SizedBox());
    return texts;
  }

  testWidgets('the next fixture, opponent and all', (tester) async {
    final text = await line(tester, hub(next: fixture));
    expect(text, contains('Next: '));
    expect(text, contains('Norway'));
    expect(text, isNot(contains('Road to')));
  });

  testWidgets('the opponent stays hidden until the draw is watched', (
    tester,
  ) async {
    final text = await line(tester, hub(next: fixture, drawWatched: false));
    expect(text, contains('Draw to come'));
    expect(text, isNot(contains('Norway')));
  });

  testWidgets('no fixture and the World Championship played: the verdict', (
    tester,
  ) async {
    final text = await line(tester, hub(champion: 2, hasFinals: true));
    expect(text, isNot(contains('Road to')));
    expect(text, contains('is over'));
  });

  testWidgets('no fixture while the finals run without him: watching', (
    tester,
  ) async {
    final text = await line(tester, hub(hasFinals: true));
    expect(text, contains('Following the'));
  });

  testWidgets('no fixture and no finals yet: the road to them', (
    tester,
  ) async {
    final text = await line(tester, hub());
    expect(text, contains('Road to the'));
  });
}
