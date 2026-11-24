import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/player/poaching.dart';
import 'package:fnm/features/messages/message_sheet.dart';
import 'package:fnm/features/messages/poach_actions.dart';
import 'package:fnm/features/squad/poaching_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';
import 'package:go_router/go_router.dart';

const int _careerId = 5;
const int _playerId = 901;

/// The approach message as the inbox stores it: meaning, with the player's
/// id riding along in the title.
MessageItem _message() {
  const title = MsgText(MsgKey.msgPoachTitle, ['Rivalia', 'Jan Novak', 901]);
  const body = MsgText(MsgKey.msgPoachBody, [
    'Rivalia',
    'Jan Novak',
    20,
    'ST',
    'Homeland',
    2,
  ]);
  final l = AppLocalizationsEn();
  return (
    id: 1,
    category: poachCategory,
    title: renderMsgPart(l, title),
    body: renderMsgPart(l, body),
    spec: encodeMessageSpec(title: title, body: body),
    year: 2027,
    read: false,
  );
}

PoachCase _open({int playerId = _playerId, bool promised = false}) => (
  playerId: playerId,
  rivalId: 2,
  since: DateTime(2027),
  promised: promised,
  outcome: null,
);

class _FakePoaching extends PoachingService {
  _FakePoaching(super._ref);

  final List<int> promised = [];

  @override
  Future<void> promiseMinutes(int careerId, int playerId) async {
    promised.add(playerId);
  }
}

void main() {
  final en = AppLocalizationsEn();

  /// The sheet on a route that carries the career, as the inbox opens it.
  Future<void> pumpSheet(WidgetTester tester, {PoachCase? open}) async {
    final router = GoRouter(
      initialLocation: '/messages?careerId=$_careerId',
      routes: [
        GoRoute(
          path: '/messages',
          builder: (_, _) => Scaffold(body: MessageSheet(message: _message())),
        ),
        GoRoute(
          path: '/call-ups',
          builder: (_, _) => const Scaffold(body: Text('call-ups screen')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          openPoachProvider.overrideWith((ref, careerId) async => open),
          poachingServiceProvider.overrideWith(
            _FakePoaching.new,
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('names the player, the rival and the deadline', (tester) async {
    await pumpSheet(tester, open: _open());
    expect(find.text(en.msgPoachTitle('Rivalia', 'Jan Novak')), findsOneWidget);
    expect(
      find.text(
        en.msgPoachBody('Rivalia', 'Jan Novak', 20, 'ST', 'Homeland', 2),
      ),
      findsOneWidget,
    );
    expect(find.byKey(PoachActions.promiseKey), findsOneWidget);
    expect(find.byKey(PoachActions.callUpsKey), findsOneWidget);
    expect(find.text(en.poachPromiseHint), findsOneWidget);
  });

  testWidgets('promising him minutes goes to the service', (tester) async {
    await pumpSheet(tester, open: _open());
    await tester.tap(find.byKey(PoachActions.promiseKey));
    await tester.pump();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MessageSheet)),
    );
    final fake = container.read(poachingServiceProvider) as _FakePoaching;
    expect(fake.promised, [_playerId]);
  });

  testWidgets('once promised the button says so and is spent', (tester) async {
    await pumpSheet(tester, open: _open(promised: true));
    expect(find.text(en.poachPromisedLabel), findsOneWidget);
    final button = tester.widget<ButtonStyleButton>(
      find.byKey(PoachActions.promiseKey),
    );
    expect(button.onPressed, isNull);
    expect(find.text(en.poachPromiseHint), findsNothing);
  });

  testWidgets('the call-ups button opens the call-up screen', (tester) async {
    await pumpSheet(tester, open: _open());
    await tester.tap(find.byKey(PoachActions.callUpsKey));
    await tester.pumpAndSettle();
    expect(find.text('call-ups screen'), findsOneWidget);
  });

  testWidgets('a settled approach keeps its words and loses its buttons', (
    tester,
  ) async {
    await pumpSheet(tester);
    expect(find.text(en.msgPoachTitle('Rivalia', 'Jan Novak')), findsOneWidget);
    expect(find.byKey(PoachActions.promiseKey), findsNothing);
    await pumpSheet(tester, open: _open(playerId: _playerId + 1));
    expect(
      find.byKey(PoachActions.promiseKey),
      findsNothing,
      reason: "another man's approach is not this message's",
    );
  });
}
