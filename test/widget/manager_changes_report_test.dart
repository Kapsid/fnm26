import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart' show Routes;
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/messages/manager_changes_report.dart';
import 'package:fnm/features/messages/message_popup.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/messages/message_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

import '../helpers/expect_whole.dart';
import '../helpers/test_database.dart';

/// The manager changes after a tournament: ONE message, a paged table like
/// the transfer report, every man a link to his page.
void main() {
  /// A long fictional name, and the widest reason a row can print: a
  /// poached man's destination.
  const longName = 'Bartholomew Wolkenstein-Haralambous';

  List<ManagerChangeRow> batch({int count = 14}) => [
    for (var i = 0; i < count; i++)
      (
        nationId: 100 + i,
        nationCode: 'CZE',
        nationName: 'Bosnia and Herzegovina',
        outgoingId: 1000 + i,
        outgoingName: longName,
        why: SpellEnd.values[i % SpellEnd.values.length],
        incomingId: i % 5 == 4 ? null : 2000 + i,
        incomingName: i % 5 == 4 ? '' : 'Ivo Marsk',
        toNationId: 300,
        toCode: 'SVK',
        toName: 'Central African Republic',
      ),
    (
      nationId: 99,
      nationCode: 'POL',
      nationName: 'Dalmir',
      outgoingId: null,
      outgoingName: '',
      why: null,
      incomingId: 2999,
      incomingName: 'Emil Sorvan',
      toNationId: null,
      toCode: '',
      toName: '',
    ),
  ];

  MessageItem message(List<ManagerChangeRow> rows) => (
    id: 1,
    category: 'manager',
    title: 'Manager changes',
    body: encodeManagerChanges(rows),
    spec: encodeMessageSpec(title: const MsgText(MsgKey.mgrChangesTitle)),
    year: 2030,
    read: false,
  );

  /// The message in a popup over a screen of [size], as the inbox and the
  /// hub show it.
  Future<void> pumpPopup(
    WidgetTester tester, {
    required Size size,
    required Locale locale,
    List<ManagerChangeRow>? rows,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: locale,
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showAppPopup<void>(
                  context: context,
                  builder: (_) =>
                      MessageSheet(message: message(rows ?? batch())),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  final sizes = {
    'phone 360x640': const Size(360, 640),
    'tablet 1024x768': const Size(1024, 768),
  };
  for (final MapEntry(key: device, value: size) in sizes.entries) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      final at = 'on a $device in ${locale.languageCode}';

      testWidgets('the changes are paged and nothing overflows, $at', (
        tester,
      ) async {
        await pumpPopup(tester, size: size, locale: locale);
        final l = lookupAppLocalizations(locale);
        expect(find.text(l.mgrChangesTitle), findsOneWidget);
        expectWhole(find.text(l.mgrChangesCount(15)), 'the count');
        expectWhole(find.text(l.transfersPageOf(1, 3)), 'the page count');
        expect(
          find.byIcon(Icons.east_rounded).evaluate().length,
          ManagerChangesTable.perPage,
        );
        expect(tester.takeException(), isNull);
        expectNothingCut(tester, 'the manager changes');

        // Through to the last page: the vacancy filled is there.
        for (var p = 0; p < 2; p++) {
          await tester.ensureVisible(find.text(l.transfersPageNext));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l.transfersPageNext));
          await tester.pumpAndSettle();
        }
        expectWhole(find.text(l.transfersPageOf(3, 3)), 'the page count');
        expect(find.text(l.mgrChangesAppointed), findsOneWidget);
        expect(tester.takeException(), isNull);
        expectNothingCut(tester, 'the manager changes');
      });
    }
  }

  testWidgets('each row says why the change happened', (tester) async {
    await pumpPopup(
      tester,
      size: const Size(360, 640),
      locale: const Locale('en'),
      rows: batch(count: 5),
    );
    final l = AppLocalizationsEn();
    expect(find.text(l.mgrEndSacked), findsOneWidget);
    expect(find.text(l.mgrEndResigned), findsOneWidget);
    expect(
      find.text(l.mgrChangesLeftFor('Central African Republic')),
      findsOneWidget,
    );
    expect(find.text(l.mgrEndRetired), findsOneWidget);
    expect(find.text(l.mgrEndContractEnd), findsOneWidget);
    // Row 5 has nobody in yet.
    expect(find.text(l.mgrChangesVacant), findsOneWidget);
  });

  group('in the hub', () {
    late AppDatabase db;
    late ProviderContainer container;
    late CompetitionRepository comp;
    const careerId = 1;

    setUp(() async {
      db = createTestDatabase();
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          messageServiceProvider.overrideWith(_NoNewsService.new),
        ],
      );
      comp = container.read(competitionRepositoryProvider);
      await container
          .read(careerRepositoryProvider)
          .create(
            managerName: 'M',
            nationId: 1,
            rngSeed: 1,
            startDate: DateTime(2026, 9),
          );
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    testWidgets('the summary pops once, and a manager opens his page over '
        'it', (tester) async {
      tester.view
        ..physicalSize = const Size(360, 640)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await comp.addTextMessage(
        l: AppLocalizationsEn(),
        careerId: careerId,
        dedupKey: 'mgr:wc:2030:all',
        category: 'manager',
        title: const MsgText(MsgKey.mgrChangesTitle),
        rawBody: encodeManagerChanges(batch()),
        year: 2030,
      );

      late WidgetRef capturedRef;
      final router = GoRouter(
        initialLocation: '/hub?careerId=$careerId',
        routes: [
          GoRoute(
            path: '/hub',
            builder: (context, state) => Consumer(
              builder: (context, ref, _) {
                capturedRef = ref;
                return const Scaffold(body: Text('host'));
              },
            ),
          ),
          GoRoute(
            path: Routes.worldManager,
            builder: (context, state) => Scaffold(
              appBar: AppBar(),
              body: Text(
                'manager ${state.uri.queryParameters['managerId']} '
                'of ${state.uri.queryParameters['careerId']}',
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();
      unawaited(
        showUnreadMessagePopups(
          tester.element(find.text('host')),
          capturedRef,
          careerId,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manager changes'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      await tester.tap(find.byKey(ManagerChangesTable.managerKey(2001)));
      await tester.pumpAndSettle();
      expect(find.text('manager 2001 of $careerId'), findsOneWidget);

      // Back: the run of news is where it was.
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('Manager changes'), findsOneWidget);
      await tester.ensureVisible(find.text('Done'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('Manager changes'), findsNothing);
      expect(await comp.unreadMessageCount(careerId), 0);
    });
  });
}

class _NoNewsService extends MessageService {
  // ignore: matching_super_parameters, the service keeps its ref private.
  _NoNewsService(super.ref);

  @override
  Future<void> sync(int careerId) async {}
}
