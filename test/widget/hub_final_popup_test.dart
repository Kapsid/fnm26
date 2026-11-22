import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/round_popup.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

import '../helpers/seeded_save.dart';

/// The step that plays a tournament's final also ends it: the host's strip
/// leaves the phone hub and the list above the button shifts. Unkeyed, the
/// button was built anew mid-step and its results were never shown (a tester
/// stepped the Euro's final and saw nothing but the Nations Cup draw's
/// button). Keyed, as the hub keys it, it stays the same button.
class _Season implements SeasonService {
  _Season(this.onAdvance);

  final VoidCallback onAdvance;

  @override
  Future<void> advance(int careerId) async {
    onAdvance();
    // The world takes its time: the hub rebuilds before the step is done.
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('the final is shown though the step takes the strip above the '
      'button away', (tester) async {
    final banner = ValueNotifier(true);
    addTearDown(banner.dispose);
    const event = HubEvent(
      kind: HubEventKind.watchTournament,
      label: 'Play the next match',
      icon: Icons.fast_forward_rounded,
    );
    final save = await seedSave(
      tester,
      overrides: [
        nextEventProvider(kSeededCareerId).overrideWith((ref) async => event),
        seasonServiceProvider.overrideWith(
          (ref) => _Season(() => banner.value = false),
        ),
        latestRoundPopupProvider(kSeededCareerId).overrideWith(
          (ref) async => (
            competition: 'The Championship',
            stage: 'Final',
            fixtures: [
              Fixture(
                id: 1,
                careerId: kSeededCareerId,
                competitionId: 1,
                matchday: 1,
                date: DateTime(2028, 7, 8),
                homeNationId: seededNationId,
                awayNationId: seededNationId + 1,
                round: 'CFINAL',
                played: true,
                homeScore: 2,
                awayScore: 1,
              ),
            ],
            groupNames: const <int, String>{},
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ValueListenableBuilder<bool>(
              valueListenable: banner,
              builder: (context, shown, _) => ListView(
                children: [
                  if (shown) const SizedBox(height: 40, child: Text('Host')),
                  const SizedBox(height: 8),
                  // Keyed as the hub keys it (see HubScreen).
                  const HubEventButton(
                    key: ValueKey('hub.eventButton'),
                    careerId: kSeededCareerId,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => save.container.read(nextEventProvider(kSeededCareerId).future),
    );
    await tester.runAsync(
      () => save.container.read(hubDataProvider(kSeededCareerId).future),
    );
    await tester.pump();
    await tester.tap(find.byType(PrimaryButton));
    for (var i = 0; i < 20 && find.byType(Dialog).evaluate().isEmpty; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.text('Host'), findsNothing);
    expect(find.byType(Dialog), findsOneWidget);
  });
}
