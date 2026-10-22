import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/features/tactics/tactic_preset_providers.dart';
import 'package:fnm/features/tactics/tactic_preset_tile.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seeded_save.dart';
import 'match_skip_shootout_test.dart' show levelKnockout;

/// The live match screen hands the save's presets to the in-match editor, so
/// they are reachable during play and at every break, not only before kick-off.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('the match screen offers the save presets', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.view
      ..physicalSize = const Size(400, 2600)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final c = ProviderContainer(
      overrides: [
        matchPreviewProvider(
          1,
        ).overrideWith((ref) async => levelKnockout(saveSeed: 42)),
        soundHapticsEnabledProvider.overrideWith((ref) => false),
        matchAttemptSaltProvider.overrideWithValue(() => 0),
      ],
    );
    addTearDown(c.dispose);
    await c
        .read(tacticPresetStoreProvider)
        .save(
          1,
          const TacticPreset(
            name: 'Chase it',
            formation: Formation.f424,
            instructions: TacticalInstructions(mentality: 85),
          ),
        );
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

    Future<void> openEditor() async {
      await tester.tap(find.byType(MatchTacticsPillContent));
      await tester.pumpAndSettle();
    }

    await openEditor();
    await tester.tap(find.byKey(InMatchTacticsKeys.presetsButton));
    await tester.pumpAndSettle();
    expect(find.byType(TacticPresetTile), findsOneWidget);
    await tester.tap(find.text('Chase it'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(enL.tacticsApply));
    await tester.pumpAndSettle();

    // Reopened, the editor carries the preset's shape: it went through
    // _applyTactics like any manual change.
    await openEditor();
    final pitch = tester.widget<TacticsPitch>(find.byType(TacticsPitch).last);
    expect(pitch.formation, Formation.f424);
  });
}
