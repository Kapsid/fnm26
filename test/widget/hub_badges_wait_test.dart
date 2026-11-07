import 'dart:async';

import 'package:flutter/material.dart';
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

/// Opening a save: the hub's own data is asked for alone, and the badges
/// (the whole inbox and the whole Y feed, the two biggest reads of a long
/// save) only once it is in. Asked for together, the database answered
/// them in turn and the hub sat on its spinner until every badge was
/// counted: the lag on Continue.
void main() {
  testWidgets('the badges are counted only once the hub data is in', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final AppDatabase db = createTestDatabase();
    addTearDown(db.close);
    final hub = Completer<HubData?>();
    var messagesAsked = 0;
    var yAsked = 0;
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        hubDataProvider.overrideWith((ref, id) => hub.future),
        unreadMessagesProvider.overrideWith((ref, id) async {
          messagesAsked++;
          return 0;
        }),
        yUnreadCountProvider.overrideWith((ref, id) async {
          yAsked++;
          return 0;
        }),
      ],
    );
    addTearDown(container.dispose);
    // Asked before: no offer of a walk through over the hub.
    container.read(tourOfferedProvider.notifier).state = true;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HubScreen(careerId: 1),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(messagesAsked, 0);
    expect(yAsked, 0);

    hub.complete(null);
    await tester.pump();
    await tester.pump();
    expect(messagesAsked, 1);
    expect(yAsked, 1);
  });
}
