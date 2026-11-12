import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/settings/settings_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seeded_save.dart';

/// The Settings stadium sound: off until turned on, its volume slider shown
/// only then, both remembered; on the phone and the tablet, and still whole
/// at the largest text.
void main() {
  Future<SeededSave> open(
    WidgetTester tester, {
    required FormFactor formFactor,
    required Size size,
    bool largest = false,
  }) async {
    final save = await seedSave(
      tester,
      formFactor: formFactor,
      overrides: [stadiumSoundAvailableProvider.overrideWithValue(true)],
    );
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = save.container.read(routerProvider)..go(Routes.settings);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          builder: (context, child) => largest
              // The phone's own largest scale under the app's Larger: the
              // product is capped at kMaxAppTextScale.
              ? MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2)),
                  child: AppTextScale(size: TextSize.larger, child: child!),
                )
              : child!,
        ),
      ),
    );
    await settle(tester);
    return save;
  }

  Future<SharedPreferences> prefs(WidgetTester tester) async {
    late SharedPreferences p;
    await tester.runAsync(() async {
      p = await SharedPreferences.getInstance();
    });
    return p;
  }

  final toggle = find.byKey(MatchSoundCard.toggleKey);
  final slider = find.byKey(MatchSoundCard.volumeKey);

  for (final (name, formFactor, size) in [
    ('phone', FormFactor.phone, kPhoneSize),
    ('tablet', FormFactor.tablet, kTabletSize),
  ]) {
    testWidgets('$name: off by default; on shows the volume; remembered', (
      tester,
    ) async {
      final save = await open(tester, formFactor: formFactor, size: size);
      expect(save.container.read(matchSoundEnabledProvider), isFalse);
      expect(find.text(enL.settingsMatchSoundTitle), findsOneWidget);
      expect(slider, findsNothing, reason: 'no volume while it is off');

      await tester.ensureVisible(toggle);
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(save.container.read(matchSoundEnabledProvider), isTrue);
      expect(slider, findsOneWidget);
      expect(find.text(enL.settingsMatchSoundVolume), findsOneWidget);
      expect((await prefs(tester)).getBool('settings.matchSound'), isTrue);

      // All the way down: the slider's left end.
      await tester.ensureVisible(slider);
      final r = tester.getRect(slider);
      await tester.dragFrom(
        r.centerLeft + const Offset(30, 0),
        Offset(-r.width, 0),
      );
      await tester.pumpAndSettle();
      expect(save.container.read(matchSoundVolumeProvider), 0);
      expect((await prefs(tester)).getDouble('settings.matchSoundVolume'), 0);

      await tester.ensureVisible(toggle);
      await tester.pumpAndSettle();
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(slider, findsNothing);
      expect((await prefs(tester)).getBool('settings.matchSound'), isFalse);
    });

    testWidgets('$name: whole at the largest text, on', (tester) async {
      final save = await open(
        tester,
        formFactor: formFactor,
        size: size,
        largest: true,
      );
      save.container.read(matchSoundEnabledProvider.notifier).state = true;
      await tester.pumpAndSettle();
      await tester.ensureVisible(slider);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(slider, findsOneWidget);
    });
  }

  testWidgets('the stored choice is read back at start', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'settings.matchSound': true,
      'settings.matchSoundVolume': 0.25,
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              return TextButton(
                onPressed: () => loadSettings(ref),
                child: const Text('load'),
              );
            },
          ),
        ),
      ),
    );
    expect(container.read(matchSoundEnabledProvider), isFalse);
    await tester.tap(find.text('load'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    expect(container.read(matchSoundEnabledProvider), isTrue);
    expect(container.read(matchSoundVolumeProvider), 0.25);
  });
}
