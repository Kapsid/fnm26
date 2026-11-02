import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/seeded_save.dart' show realNations, realPlayers;
import '../../helpers/test_database.dart';

/// Changing a place within the formation through the tactic service: stored,
/// limited to two, and reset by any change of shape.
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
    await c.read(tacticServiceProvider).setFormation(career, Formation.f433);
  });
  tearDown(() async {
    c.dispose();
    await db.close();
  });

  Future<Tactic> stored() async =>
      (await c.read(tacticsRepositoryProvider).tacticForCareer(career))!;

  test('a 4-3-3 CM switched to DM is stored, the XI untouched', () async {
    final before = await stored();
    final ok = await c
        .read(tacticServiceProvider)
        .setSlotPosition(career, 6, PlayerPosition.dm);
    expect(ok, isTrue);
    final after = await stored();
    expect(after.formation, Formation.f433);
    expect(after.positions[6], PlayerPosition.dm);
    expect(after.lineup, before.lineup);
  });

  test('the third change is refused; resetting one makes room', () async {
    final service = c.read(tacticServiceProvider);
    expect(await service.setSlotPosition(career, 6, PlayerPosition.dm), isTrue);
    expect(await service.setSlotPosition(career, 7, PlayerPosition.am), isTrue);
    expect(
      await service.setSlotPosition(career, 9, PlayerPosition.am),
      isFalse,
    );
    expect((await stored()).switches.count, 2);
    expect(await service.setSlotPosition(career, 7, null), isTrue);
    expect(await service.setSlotPosition(career, 9, PlayerPosition.am), isTrue);
    expect((await stored()).switches.bySlot, {
      6: PlayerPosition.dm,
      9: PlayerPosition.am,
    });
  });

  test('picking or dragging to a new formation resets the switches', () async {
    final service = c.read(tacticServiceProvider);
    await service.setSlotPosition(career, 6, PlayerPosition.dm);
    await service.setFormation(career, Formation.f442);
    expect((await stored()).switches, SlotSwitches.none);

    await service.setFormation(career, Formation.f433);
    await service.setSlotPosition(career, 6, PlayerPosition.dm);
    await service.reshapeFormation(career, Formation.f4231);
    expect((await stored()).switches, SlotSwitches.none);
  });

  test('a library tactic brings its own switches, an old one none', () async {
    final service = c.read(tacticServiceProvider);
    await service.setSlotPosition(career, 7, PlayerPosition.am);
    await service.applyLibraryTactic(
      career,
      const LibraryTactic(
        name: 'Holding',
        formation: Formation.f433,
        instructions: TacticalInstructions(),
        switches: SlotSwitches({6: PlayerPosition.dm}),
      ),
    );
    expect((await stored()).switches.bySlot, {6: PlayerPosition.dm});
    await service.applyLibraryTactic(
      career,
      const LibraryTactic(
        name: 'Plain',
        formation: Formation.f433,
        instructions: TacticalInstructions(),
      ),
    );
    expect((await stored()).switches, SlotSwitches.none);
  });
}
