import 'dart:async';

import 'package:flutter/material.dart';
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
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
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
}
