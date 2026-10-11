import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_database.dart';

/// The walk through and the news popups take turns on the hub.
///
/// Reported from an Android playtest: on a new save the news popped up while
/// the "first time here?" offer was up, and with the tour accepted a news
/// dialog could sit under the tour's scrim, over the very control being lit,
/// untappable. News now waits for the offer to be answered and for the tour
/// to end, and none of it is lost or marked read while it waits.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  const careerId = 1;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = createTestDatabase();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        // The news is filed by hand below; the real generator would add its
        // own and change what pops.
        messageServiceProvider.overrideWith(_NoNewsService.new),
        // The dashboard body is not the subject: the popups are driven from
        // the hub's build before it, and "save not found" is enough screen.
        hubDataProvider.overrideWith((ref, id) async => null),
        yUnreadCountProvider.overrideWith((ref, id) async => 0),
        // The badge count straight off the table, without the inbox's seeding
        // of a whole world first.
        unreadMessagesProvider.overrideWith(
          (ref, id) =>
              ref.watch(competitionRepositoryProvider).unreadMessageCount(id),
        ),
      ],
    );
    await container
        .read(careerRepositoryProvider)
        .create(
          managerName: 'M',
          nationId: 1,
          rngSeed: 1,
          startDate: DateTime(2026, 9),
        );
    await container
        .read(competitionRepositoryProvider)
        .addMessage(
          careerId: careerId,
          dedupKey: 'welcome',
          category: 'ranking',
          title: 'Welcome news',
          body: 'Body of the welcome news',
          year: 2026,
        );
    // A manager who has never been asked.
    container.read(tourOfferedProvider.notifier).state = false;
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> pumpHub(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HubScreen(careerId: careerId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<int> unread() => container
      .read(competitionRepositoryProvider)
      .unreadMessageCount(careerId);

  testWidgets('the offer comes first, alone; declining it lets the news pop', (
    tester,
  ) async {
    await pumpHub(tester);

    expect(find.text('First time here?'), findsOneWidget);
    expect(find.text('Welcome news'), findsNothing);
    expect(await unread(), 1, reason: 'waiting news is not marked read');

    await tester.tap(find.text('No thanks'));
    await tester.pumpAndSettle();

    expect(find.text('First time here?'), findsNothing);
    expect(find.text('Welcome news'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome news'), findsNothing);
    expect(await unread(), 0);
  });

  testWidgets('news waits out the whole tour, then pops once', (tester) async {
    await pumpHub(tester);

    await tester.tap(find.text('Show me around'));
    await tester.pumpAndSettle();

    expect(container.read(tourStepProvider), 0);
    expect(find.text('Welcome news'), findsNothing);
    expect(await unread(), 1);

    // Stepping through does not let it out either.
    container.read(tourStepProvider.notifier).state = 3;
    await tester.pumpAndSettle();
    expect(find.text('Welcome news'), findsNothing);

    // Finished (or skipped): now it goes.
    container.read(tourStepProvider.notifier).state = null;
    await tester.pumpAndSettle();
    expect(find.text('Welcome news'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Once: no second round of the same news, and no second offer.
    expect(find.text('Welcome news'), findsNothing);
    expect(find.text('First time here?'), findsNothing);
    expect(await unread(), 0);
  });
  // Reported from the same playtest: "NÁRODNÍ CENTRÁLA" wrapped in the app
  // bar. The title shares the bar with a back button and four actions, and
  // the phone had its system font enlarged.
  for (final width in [360.0, 412.0]) {
    for (final locale in ['en', 'cs']) {
      testWidgets('the hub title is one line at $width in $locale, font x1.3', (
        tester,
      ) async {
        container.read(tourOfferedProvider.notifier).state = true;
        await container
            .read(competitionRepositoryProvider)
            .markMessagesRead(careerId);
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              locale: Locale(locale),
              theme: AppTheme.theme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.3)),
                child: child!,
              ),
              home: const HubScreen(careerId: careerId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final title = locale == 'cs' ? 'NÁRODNÍ CENTRÁLA' : 'NATIONAL HUB';
        final finder = find.text(title);
        expect(finder, findsOneWidget);
        expect(tester.takeException(), isNull);

        // One line: labelMedium is 20 high, x1.3. A wrap doubles it.
        final paragraph = tester.renderObject<RenderParagraph>(finder);
        expect(paragraph.size.height, lessThanOrEqualTo(20 * 1.3 + 0.5));
        expect(paragraph.didExceedMaxLines, isFalse);

        // And what is drawn sits inside the toolbar, clear of the back
        // button and the actions on either side.
        final drawn = tester.getRect(finder);
        final bar = tester.getRect(find.byType(AppBar));
        expect(drawn.top, greaterThanOrEqualTo(bar.top));
        expect(drawn.bottom, lessThanOrEqualTo(bar.bottom));
        final back = tester.getRect(find.byIcon(Icons.arrow_back));
        final mail = tester.getRect(find.byIcon(Icons.mail_outline));
        expect(drawn.left, greaterThanOrEqualTo(back.right));
        expect(drawn.right, lessThanOrEqualTo(mail.left));
      });
    }
  }
}

class _NoNewsService extends MessageService {
  _NoNewsService(super.ref);

  @override
  Future<void> sync(int careerId) async {}
}
