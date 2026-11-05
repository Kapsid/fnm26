import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

/// A free agent is stored as [ClubService.freeAgent] (English); every screen
/// prints it in the manager's language.
void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  testWidgets('a free agent from a database reads in Czech in a cs career', (
    tester,
  ) async {
    final save = await seedSave(tester);
    late int playerId;
    await tester.runAsync(() async {
      final players = save.container.read(playerRepositoryProvider);
      final core = [
        for (final p in await players.byNation(
          seededNationId,
          saveSeed: save.career.rngSeed,
        ))
          if (p.id < PoolGenerator.firstFringeId) p,
      ];
      playerId = core.first.id;
      final packs = save.container.read(worldPackRepositoryProvider);
      final packId = await packs.insert(
        WorldPack(
          uuid: 'free-agent',
          name: 'Free',
          author: '',
          formatVersion: kPackFormatVersion,
          madeWithVersion: '1.1.0',
          squads: {
            seededNationId: [
              for (final p in core)
                PackPlayer(
                  id: p.id,
                  name: p.name,
                  age: p.age,
                  position: p.position,
                  attributes: p.attributes,
                  potential: p.overall,
                  club: p.id == playerId ? ClubService.freeAgent : p.club,
                  clubCountry: p.id == playerId
                      ? null
                      : p.clubCountry.isEmpty
                      ? null
                      : p.clubCountry,
                ),
            ],
          },
        ),
        const {},
      );
      await packs.copyToCareer(packId, save.careerId);
      await save.container.read(activeWorldSyncProvider).prime();
    });
    // The repository remembers each career's world from its first read; the
    // seeded career was read before it moved onto this one.
    save.container.invalidate(playerRepositoryProvider);

    await pumpRoute(
      tester,
      save,
      '${Routes.player}?careerId=${save.careerId}&playerId=$playerId',
      locale: const Locale('cs'),
    );
    expect(tester.takeException(), isNull);
    final cs = lookupAppLocalizations(const Locale('cs'));
    // The club row and the club history both say it in Czech.
    expect(find.text(cs.editorPlayerFreeAgent), findsNWidgets(2));
    expect(find.text(ClubService.freeAgent), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
