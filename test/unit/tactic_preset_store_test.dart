import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactic_preset_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Saving and deleting through the store used to throw a
/// CircularDependencyError in debug builds, because the list provider watched
/// the store that invalidates it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('save then delete refresh the presets provider', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final sub = c.listen(tacticPresetsProvider(1), (_, _) {});
    addTearDown(sub.close);
    expect(await c.read(tacticPresetsProvider(1).future), isEmpty);

    final store = c.read(tacticPresetStoreProvider);
    await store.save(
      1,
      const TacticPreset(
        name: 'Chase it',
        formation: Formation.f424,
        instructions: TacticalInstructions(mentality: 85),
      ),
    );
    final saved = await c.read(tacticPresetsProvider(1).future);
    expect(saved.map((p) => p.name), ['Chase it']);

    await store.delete(1, 'chase it');
    expect(await c.read(tacticPresetsProvider(1).future), isEmpty);
  });
}
