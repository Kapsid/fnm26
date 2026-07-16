import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';
import 'package:fnm/features/tournaments/nations_cup_screen.dart';

import '../helpers/test_database.dart';

/// A tournament screen should open where the tournament actually is.
///
/// DefaultTabController reads initialIndex once, in initState — and the first
/// build has no data — so a naive initialIndex would be pinned to 0 forever.
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

  testWidgets('the Nations Cup opens on its live stage', (tester) async {
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

    // The groups are live at the start of a cycle, so LEAGUES is the stage —
    // and the tab must be resolved AFTER the data arrives, not before.
    final controller = DefaultTabController.of(
      tester.element(find.byType(TabBarView)),
    );
    expect(controller.index, 0, reason: 'the group stage is live');

    // The landing tab is real content, not a placeholder.
    expect(find.textContaining('LEAGUE'), findsWidgets);
  });

  testWidgets("another confederation's cup opens on its history",
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(500, 900);
    addTearDown(tester.view.reset);

    // A discriminating case: the landing tab here is 4, not the 0 a naive
    // initialIndex would give. Only the player's own region is played out, so
    // every other tab of a foreign cup is a placeholder.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.theme,
          home: ContinentalDetailScreen(
            careerId: careerId,
            confederation: Confederation.asia,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final controller = DefaultTabController.of(
      tester.element(find.byType(TabBarView)),
    );
    expect(
      controller.index,
      4,
      reason: "a foreign cup's only real content is its history",
    );
  });
}
