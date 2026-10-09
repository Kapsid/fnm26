import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

HubData _hub({required bool drawWatched}) => HubData(
  career: Career(
    id: 1,
    managerName: 'M',
    nationId: 1,
    rngSeed: 1,
    createdAt: DateTime(2026),
    inGameDate: DateTime(2027, 9, 7),
  ),
  group: null,
  next: Fixture(
    id: 9,
    careerId: 1,
    competitionId: 1,
    matchday: 5,
    date: DateTime(2027, 9, 10),
    homeNationId: 1,
    awayNationId: 2,
  ),
  fixtures: const [],
  nations: {
    1: nation(id: 1, name: 'Czechia'),
    2: nation(id: 2, name: 'Norway'),
  },
  squadSize: 23,
  squadRating: 75,
  championNationId: null,
  hasFinals: false,
  nextDrawWatched: drawWatched,
);

Future<void> _pump(WidgetTester tester, HubData hub, {int unread = 0}) async {
  tester.view.physicalSize = const Size(1194, 834);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    const Scaffold(body: TabletTopBar(careerId: 1)),
    overrides: [
      hubDataProvider(1).overrideWith((ref) async => hub),
      unreadMessagesProvider(1).overrideWith((ref) async => unread),
      nextEventProvider(1).overrideWith(
        (ref) async => const HubEvent(
          kind: HubEventKind.advance,
          label: 'Continue',
          icon: Icons.play_arrow_rounded,
        ),
      ),
    ],
  );
  await tester.pump();
}

void main() {
  testWidgets('shows the nation, the next fixture and Continue', (tester) async {
    await _pump(tester, _hub(drawWatched: true), unread: 3);
    expect(find.text('Czechia'), findsWidgets);
    expect(find.textContaining('Norway'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the opponent hidden until the draw is watched', (
    tester,
  ) async {
    await _pump(tester, _hub(drawWatched: false));
    expect(find.textContaining('Norway'), findsNothing);
    expect(find.textContaining('Draw to come'), findsOneWidget);
  });

  test('the unread badge caps at 99+', () {
    expect(unreadBadgeLabel(7), '7');
    expect(unreadBadgeLabel(99), '99');
    expect(unreadBadgeLabel(100), '99+');
  });

  testWidgets('a long name and a narrow bar give way instead of overflowing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(760, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final hub = _hub(drawWatched: true);
    final longName = HubData(
      career: hub.career,
      group: null,
      next: hub.next,
      fixtures: const [],
      nations: {
        1: nation(id: 1, name: 'Saint Vincent and the Grenadines'),
        2: nation(id: 2, name: 'Bosnia and Herzegovina'),
      },
      squadSize: 23,
      squadRating: 75,
      championNationId: null,
      hasFinals: false,
    );
    await tester.pumpApp(
      const Scaffold(body: TabletTopBar(careerId: 1)),
      overrides: [
        hubDataProvider(1).overrideWith((ref) async => longName),
        unreadMessagesProvider(1).overrideWith((ref) async => 150),
        nextEventProvider(1).overrideWith(
          (ref) async => const HubEvent(
            kind: HubEventKind.advance,
            label: 'Continue',
            icon: Icons.play_arrow_rounded,
          ),
        ),
      ],
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('99+'), findsOneWidget);
    expect(find.textContaining('Bosnia', findRichText: true), findsOneWidget);
  });
}
