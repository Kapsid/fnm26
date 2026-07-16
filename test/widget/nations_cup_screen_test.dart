import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_screen.dart';

import '../helpers/test_database.dart';

/// The Nations Cup screen's tabs.
///
/// It used to be a single list with no tabs at all, and its roll of honour was
/// rendered *only* when no groups existed — so the moment the cup kicked off,
/// past winners became unreachable. There were never any scorers.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int careerId;

  setUp(() async {
    db = createTestDatabase();
    final nations = (jsonDecode(
      File('assets/data/nations.json').readAsStringSync(),
    ) as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    await container.read(seedLoaderProvider).ensureSeeded();
    final player = nations
        .where((n) => n.confederation == Confederation.europe)
        .reduce((a, b) => a.ranking <= b.ranking ? a : b);
    careerId = (await container.read(careerServiceProvider).create(
          nationId: player.id,
          managerName: 'M',
        ))
        .valueOrNull!
        .id;
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(500, 900);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.theme,
          home: NationsCupScreen(careerId: careerId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('has the same tab scaffold as the other cups', (tester) async {
    await pumpScreen(tester);

    expect(find.text('LEAGUES'), findsOneWidget);
    expect(find.text('FINALS FOUR'), findsOneWidget);
    expect(find.text('SCORERS'), findsOneWidget);
    expect(find.text('HISTORY'), findsOneWidget);
  });

  testWidgets('history is reachable while the cup is running', (tester) async {
    await pumpScreen(tester);

    // The groups exist at the start of a cycle — which is exactly when the
    // roll of honour used to disappear.
    await tester.ensureVisible(find.text('HISTORY'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HISTORY'));
    await tester.pumpAndSettle();

    // Either the honour roll or its empty state, but never nothing at all.
    final hasHistory = find.text('PAST WINNERS').evaluate().isNotEmpty ||
        find.textContaining('champions crowned').evaluate().isNotEmpty;
    expect(hasHistory, isTrue, reason: 'history must be reachable in season');
  });

  testWidgets('the scorers tab exists and reports an empty chart',
      (tester) async {
    await pumpScreen(tester);

    await tester.ensureVisible(find.text('SCORERS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SCORERS'));
    await tester.pumpAndSettle();

    // No Nations Cup match has been played yet, so the chart is empty — but it
    // is now something the manager can look at, which it never was.
    expect(
      find.textContaining('No Nations Cup goals'),
      findsOneWidget,
    );
  });
}
