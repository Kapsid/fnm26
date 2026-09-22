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
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_database.dart';

/// The flash the manager reported: "after I finish a match, the next match
/// flashes up with the current score."
///
/// A match is played from the teamsheet it kicked off with. The live screen
/// holds the finished score in its own state and draws the flags, the names and
/// the ratings from [matchPreviewProvider] — which is a provider for the
/// player's NEXT fixture. The moment the result is committed, that provider
/// owes a different fixture, and the screen is STILL ON SCREEN: it is only
/// leaving through a route transition. Anything that repaints it then puts the
/// next opponent's flag beside a score that belongs to the match just played.
///
/// This test asserts on the frames THROUGH the commit, not on where the app
/// settles: the fault is one frame long and a settled-state check sails past it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  testWidgets('the finished match is not repainted with the next fixture', (
    tester,
  ) async {
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

    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(c.dispose);

    late int careerId;
    await tester.runAsync(() async {
      await c.read(seedLoaderProvider).ensureSeeded();
      careerId = (await c
              .read(careerServiceProvider)
              .create(
                nationId: nations.first.id,
                managerName: 'M',
                rngSeed: 20260922,
              ))
          .valueOrNull!
          .id;
    });

    // Warm the preview the way the pre-match screen does before kick-off, so
    // the live screen opens on it rather than on a spinner.
    final warm = c.listen(matchPreviewProvider(careerId), (_, _) {});
    await tester.runAsync(() => c.read(matchPreviewProvider(careerId).future));

    tester.view
      ..physicalSize = const Size(400, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = c.read(routerProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();

    /// The scoreline on the match header, as "h : a".
    String scoreOnScreen() {
      for (final e in find.byType(Text).evaluate()) {
        final t = (e.widget as Text).data;
        if (t != null && RegExp(r'^\d+ : \d+$').hasMatch(t)) return t;
      }
      return '(none)';
    }

    /// The two nation codes either side of that scoreline.
    List<String> headerCodes() {
      final out = <String>[];
      for (final e in find.byType(Text).evaluate()) {
        final t = (e.widget as Text).data;
        if (t != null && RegExp(r'^[A-Z]{3}$').hasMatch(t)) out.add(t);
        if (out.length == 2) break;
      }
      return out;
    }

    router.go('${Routes.match}?careerId=$careerId');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // The match screen owns the subscription from here, as the app has it.
    warm.close();
    final played = c.read(matchPreviewProvider(careerId)).valueOrNull!;

    // Watch it out to the final whistle.
    for (var i = 0; i < 500; i++) {
      await tester.pump(const Duration(milliseconds: 400));
      if (find.text('Continue').evaluate().isNotEmpty) break;
    }
    final fullTimeCodes = headerCodes();
    final fullTimeScore = scoreOnScreen();
    expect(
      find.text('Continue'),
      findsOneWidget,
      reason: 'the match must actually reach full time',
    );
    expect(fullTimeScore, isNot('(none)'), reason: 'with a score on screen');

    // The manager named a set-piece taker during the match — the in-match
    // editor's own write, and the one that reaches all the way back to the
    // preview: the takers store invalidates [setPieceTakersProvider], which
    // [matchPreviewProvider] watches, so the next fixture is recomputed from
    // the database underneath a screen that is still showing this one.
    await tester.runAsync(
      () => c
          .read(setPieceTakersStoreProvider)
          .setBoth(
            careerId,
            penalty: played.bench.first.id,
            deadBall: played.bench.last.id,
          ),
    );

    // Continue: the result is committed with the screen still up, exactly as
    // [_continue] does it, with frames drawn all the way through.
    var done = false;
    await tester.runAsync(() async {
      unawaited(
        c
            .read(seasonServiceProvider)
            .playPlayerMatch(careerId, played.fixture, played.result)
            .whenComplete(() => done = true),
      );
    });
    for (var i = 0; i < 600; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
      expect(
        headerCodes(),
        fullTimeCodes,
        reason: "frame $i put another fixture beside this match's score",
      );
      expect(scoreOnScreen(), fullTimeScore, reason: 'frame $i');
      if (done && i > 12) break;
    }
    expect(done, isTrue, reason: 'the commit must have finished');

    // And the test is not passing because nothing moved: the world DID move on
    // to another fixture underneath the screen that is still showing this one —
    // and the screen holds its own through THAT landing too.
    int? nextFixtureId;
    await tester.runAsync(() async {
      unawaited(
        c
            .read(matchPreviewProvider(careerId).future)
            .then((p) => nextFixtureId = p?.fixture.id),
      );
    });
    for (var i = 0; i < 600 && nextFixtureId == null; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
      expect(headerCodes(), fullTimeCodes, reason: 'refresh frame $i');
      expect(scoreOnScreen(), fullTimeScore, reason: 'refresh frame $i');
    }
    expect(
      nextFixtureId,
      isNot(played.fixture.id),
      reason: 'the next match must no longer be the one just played',
    );
    expect(nextFixtureId, isNotNull);
  }, timeout: const Timeout(Duration(minutes: 5)));
}
