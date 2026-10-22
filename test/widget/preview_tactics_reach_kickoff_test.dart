import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_database.dart';

/// "Doing tactics on the match preview screen doesn't reflect on the match
/// once you played it, it only updates for the next match."
///
/// The preview screen holds [matchPreviewProvider] open, and the live match
/// plays whatever preview it is handed first and keeps it. Two ways the old
/// teamsheet reached the kick-off: a tactics change that never refreshed the
/// preview at all (the set-up warning's way into tactics), and a refresh still
/// running when Kick off was pressed, during which the provider goes on
/// handing out the previous preview.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer c;
  late int careerId;

  Future<void> setUpSave(
    Future<T?> Function<T>(Future<T> Function() fn) run,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        matchAttemptSaltProvider.overrideWithValue(() => 0),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(c.dispose);
    await run(() async {
      await c.read(seedLoaderProvider).ensureSeeded();
      careerId =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: nations.first.id,
                    managerName: 'M',
                    rngSeed: 20260922,
                  ))
              .valueOrNull!
              .id;
    });
  }

  Set<int> fieldedXi(MatchPreview p) => {
    for (final pl in (p.playerIsHome ? p.homeTeam : p.awayTeam).xi) pl.id,
  };

  test('a tactics change reaches the preview by itself', () async {
    await setUpSave(<T>(fn) => fn());
    // Held open, as the preview screen holds it.
    final open = c.listen(matchPreviewProvider(careerId), (_, _) {});
    addTearDown(open.close);
    final before = (await c.read(matchPreviewProvider(careerId).future))!;

    final current = await c.read(currentFormationProvider(careerId).future);
    final other = current == Formation.f532 ? Formation.f433 : Formation.f532;
    // No manual refresh afterwards: the write itself must do it.
    await c.read(tacticServiceProvider).setFormation(careerId, other);
    final after = (await c.read(matchPreviewProvider(careerId).future))!;

    expect(
      fieldedXi(after),
      isNot(fieldedXi(before)),
      reason: 'the match must field the XI the new shape picked',
    );
  });

  testWidgets('the live match never kicks off from a refreshing preview', (
    tester,
  ) async {
    await setUpSave(tester.runAsync);
    final real = (await tester.runAsync(
      () => c.read(matchPreviewProvider(careerId).future),
    ))!;

    // The preview, refreshed by hand: the first answer comes at once, the
    // refresh only when the test says so.
    final refresh = Completer<MatchPreview?>();
    var calls = 0;
    final screen = ProviderContainer(
      parent: c,
      overrides: [
        matchPreviewProvider.overrideWith(
          (ref, id) => calls++ == 0 ? Future.value(real) : refresh.future,
        ),
      ],
    );
    addTearDown(screen.dispose);
    final open = screen.listen(matchPreviewProvider(careerId), (_, _) {});
    addTearDown(open.close);
    await tester.runAsync(
      () => screen.read(matchPreviewProvider(careerId).future),
    );
    // The router opens on the home screen, which reads the campaign runs for
    // its "continue campaign" card: load and hold them outside the fake clock,
    // as the saves already are, or their database read is left pending.
    final runs = screen.listen(campaignRunsProvider, (_, _) {});
    addTearDown(runs.close);
    await tester.runAsync(() => screen.read(campaignRunsProvider.future));

    tester.view
      ..physicalSize = const Size(400, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final router = screen.read(routerProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: screen,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();

    // Back from tactics, the preview is refreshed, and Kick off is pressed
    // before the new one has been worked out.
    screen.invalidate(matchPreviewProvider(careerId));
    router.go('${Routes.match}?careerId=$careerId');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(screen.read(matchPreviewProvider(careerId)).isRefreshing, isTrue);

    expect(tester.takeException(), isNull);
    expect(
      find.byType(MatchScoreboard),
      findsNothing,
      reason: 'the match must wait for the refreshed teamsheet',
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // And plays once it is ready.
    refresh.complete(real);
    for (var i = 0; i < 40; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 50));
      if (find.byType(MatchScoreboard).evaluate().isNotEmpty) break;
    }
    expect(tester.takeException(), isNull);
    expect(find.byType(MatchScoreboard), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
