import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/seeded_save.dart' show realNations, realPlayers;
import '../../helpers/test_database.dart';

/// The full-back arrow through the tactic service: quick taps all land, and
/// a preset with no arrows leaves the manager's alone.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late ProviderContainer c;
  late int career;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    db = createTestDatabase();
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: realNations, playerList: realPlayers),
        ),
      ],
    );
    await c.read(seedLoaderProvider).ensureSeeded();
    career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: realNations.firstWhere((n) => n.code == 'ESP').id,
                  managerName: 'M',
                  rngSeed: 7,
                ))
            .valueOrNull!
            .id;
  });
  tearDown(() async {
    c.dispose();
    await db.close();
  });

  Future<FullBackPushes> stored() async =>
      (await c.read(tacticsRepositoryProvider).tacticForCareer(career))!
          .fullBacks;

  test('two quick taps both land: neutral, up, down', () async {
    final service = c.read(tacticServiceProvider);
    // Fired together, as two fast taps are: neither awaits the other.
    final first = service.cycleFullBack(career, FullBackSide.left);
    final second = service.cycleFullBack(career, FullBackSide.left);
    expect(await first, FullBackPush.up);
    expect(await second, FullBackPush.down);
    expect((await stored()).left, FullBackPush.down);
  });

  test('a preset with no arrows keeps the current ones', () async {
    final service = c.read(tacticServiceProvider);
    await service.setFullBack(career, FullBackSide.right, FullBackPush.up);
    await service.applyPreset(
      career,
      Formation.f442,
      const TacticalInstructions(),
    );
    expect((await stored()).right, FullBackPush.up);
    await service.applyPreset(
      career,
      Formation.f442,
      const TacticalInstructions(),
      fullBacks: const FullBackPushes(left: FullBackPush.down),
    );
    expect(await stored(), const FullBackPushes(left: FullBackPush.down));
  });
}
