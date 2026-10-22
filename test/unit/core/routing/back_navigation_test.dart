import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/routing/back_navigation.dart';
import 'package:go_router/go_router.dart';

BackAction _at(String location) => systemBackAction(Uri.parse(location));

void main() {
  group('systemBackAction', () {
    test('home closes the app', () {
      expect(_at(Routes.home), isA<ExitApp>());
    });

    test('out-of-save screens lead to their parent', () {
      expect(_at(Routes.settings), const GoBackTo(Routes.home));
      expect(_at(Routes.diagnostics), const GoBackTo(Routes.settings));
      expect(
        _at('${Routes.newGame}?nationId=4'),
        const GoBackTo(Routes.nations),
      );
    });

    test('the campaign screens match their AppBar arrows', () {
      expect(
        _at('${Routes.campaignBrief}?id=grudge'),
        const GoBackTo(Routes.campaigns),
      );
      expect(_at(Routes.campaigns), const GoBackTo(Routes.home));
    });

    test('the hub leaves the save for home', () {
      expect(_at('${Routes.hub}?careerId=7'), const GoBackTo(Routes.home));
    });

    test('in-save screens keep the careerId', () {
      expect(
        _at('${Routes.tactics}?careerId=7'),
        const GoBackTo('${Routes.hub}?careerId=7'),
      );
      expect(
        _at('${Routes.achievements}?careerId=7'),
        const GoBackTo('${Routes.careers}?careerId=7'),
      );
      expect(
        _at('${Routes.nationVitrine}?careerId=7&nationId=3'),
        const GoBackTo('${Routes.ranking}?careerId=7'),
      );
      expect(
        _at('${Routes.continental}?careerId=7&conf=uefa'),
        const GoBackTo('${Routes.tournaments}?careerId=7'),
      );
    });

    test('call-ups split like the screen exit', () {
      expect(
        _at('${Routes.callUps}?careerId=7'),
        const GoBackTo('${Routes.tactics}?careerId=7'),
      );
      expect(
        _at('${Routes.callUps}?careerId=7&event=callUp'),
        const GoBackTo('${Routes.hub}?careerId=7'),
      );
    });

    test('event screens hold', () {
      expect(_at('${Routes.match}?careerId=7'), isA<StayPut>());
      expect(_at('${Routes.finalsDraw}?careerId=7'), isA<StayPut>());
      expect(_at('${Routes.cycleRollover}?careerId=7'), isA<StayPut>());
    });
  });

  group('SystemBackHandler', () {
    late GoRouter router;
    late SystemBackHandler handler;

    Widget page(String name) => Scaffold(body: Text(name));

    Future<void> pump(
      WidgetTester tester, {
      String initial = Routes.home,
    }) async {
      router = GoRouter(
        initialLocation: initial,
        routes: [
          GoRoute(path: Routes.home, builder: (_, _) => page('home')),
          GoRoute(path: Routes.settings, builder: (_, _) => page('settings')),
          GoRoute(path: Routes.diagnostics, builder: (_, _) => page('diag')),
          GoRoute(path: Routes.hub, builder: (_, _) => page('hub')),
          GoRoute(path: Routes.tactics, builder: (_, _) => page('tactics')),
          GoRoute(
            path: Routes.match,
            builder: (_, _) => PopScope(canPop: false, child: page('match')),
          ),
        ],
      );
      handler = SystemBackHandler(router)..attach();
      addTearDown(handler.dispose);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          onNavigationNotification: handler.onNavigationNotification,
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<bool> back(WidgetTester tester) async {
      final handled = await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      return handled;
    }

    testWidgets('a gone-to screen goes to its parent, not out of the app', (
      tester,
    ) async {
      await pump(tester, initial: '${Routes.tactics}?careerId=7');
      expect(await back(tester), isTrue);
      expect(find.text('hub'), findsOneWidget);
      expect(await back(tester), isTrue);
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('a pushed screen still pops', (tester) async {
      await pump(tester, initial: Routes.settings);
      unawaited(router.push(Routes.diagnostics));
      await tester.pumpAndSettle();
      await back(tester);
      expect(find.text('settings'), findsOneWidget);
    });

    testWidgets('an open dialog closes first', (tester) async {
      await pump(tester, initial: Routes.settings);
      unawaited(
        showDialog<void>(
          context: tester.element(find.text('settings')),
          builder: (_) => const Text('dialog'),
        ),
      );
      await tester.pumpAndSettle();
      await back(tester);
      expect(find.text('dialog'), findsNothing);
      expect(find.text('settings'), findsOneWidget);
    });

    testWidgets('a PopScope screen keeps its veto', (tester) async {
      await pump(tester, initial: '${Routes.match}?careerId=7');
      expect(await back(tester), isTrue);
      expect(find.text('match'), findsOneWidget);
    });

    testWidgets('home lets the app close', (tester) async {
      await pump(tester);
      expect(await back(tester), isFalse);
    });
  });

  // Android 16 runs predictive back for an app targeting API 36: the press
  // only reaches Flutter while the framework has told the platform it handles
  // back. Flutter's own report is "the navigator can pop", which after a
  // `context.go` is false on almost every screen, so Android sent the app home
  // and the handler above never heard the press.
  group('the platform is told the app handles back', () {
    late GoRouter router;
    late List<bool> reported;

    Future<void> pump(WidgetTester tester, String initial) async {
      reported = [];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'SystemNavigator.setFrameworkHandlesBack') {
            reported.add(call.arguments as bool);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      router = GoRouter(
        initialLocation: initial,
        routes: [
          for (final path in [
            Routes.home,
            Routes.hub,
            Routes.tactics,
            Routes.finalsDraw,
          ])
            GoRoute(path: path, builder: (_, _) => Text(path)),
        ],
      );
      final handler = SystemBackHandler(router)..attach();
      addTearDown(handler.dispose);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          onNavigationNotification: handler.onNavigationNotification,
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('on a gone-to screen with nothing to pop', (tester) async {
      await pump(tester, '${Routes.tactics}?careerId=7');
      expect(reported.last, isTrue);
    });

    testWidgets('on the hub, whose back leaves the save', (tester) async {
      await pump(tester, '${Routes.hub}?careerId=7');
      expect(reported.last, isTrue);
    });

    testWidgets('on an event screen that swallows the press', (tester) async {
      await pump(tester, '${Routes.finalsDraw}?careerId=7');
      expect(reported.last, isTrue);
    });

    testWidgets('not on home, which closes the app', (tester) async {
      await pump(tester, '${Routes.hub}?careerId=7');
      router.go(Routes.home);
      await tester.pumpAndSettle();
      expect(reported.last, isFalse);
    });

    testWidgets('again after a go that only changes the query', (
      tester,
    ) async {
      await pump(tester, Routes.home);
      expect(reported.last, isFalse);
      router.go('${Routes.hub}?careerId=7');
      await tester.pumpAndSettle();
      expect(reported.last, isTrue);
    });
  });
}
