import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'match_skip_shootout_test.dart' show levelKnockout;

/// A player playing quickly asked to see what a match is FOR: "I'd like to
/// see that it's a qualifier, or a World Championship semi-final. Sometimes I
/// don't notice how important the match is." The live screen's top bar names
/// the competition and the stage.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  Future<void> pump(WidgetTester tester) async {
    final c = ProviderContainer(
      overrides: [
        matchPreviewProvider(
          1,
        ).overrideWith((ref) async => levelKnockout(saveSeed: 42)),
        matchAttemptSaltProvider.overrideWithValue(() => 0),
        soundHapticsEnabledProvider.overrideWith((ref) => false),
      ],
    );
    addTearDown(c.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MatchScreen(careerId: 1),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('a semi-final says which competition and which round', (
    tester,
  ) async {
    await pump(tester);
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(
      find.text(
        '${l.resultsCategoryWorldCupFinals} · ${l.resultsStageSemiFinal}'
            .toUpperCase(),
      ),
      findsOneWidget,
    );
  });
}
