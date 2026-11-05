import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/shared/widgets/flag_disc.dart';
import 'package:fnm/shared/widgets/whole_text.dart';

import '../helpers/seeded_save.dart';

/// The seeded career, moved onto a world that renames its own nation and
/// the European Championship. No squads: every nation keeps its stored
/// players, so the save is the seeded one in all but the names.
///
/// [known]: the app has learnt the career runs on a world, as it does at
/// start-up ([ActiveWorldSync.prime]); a career it does not know of is
/// treated as a default one.
Future<SeededSave> _renamedSave(
  WidgetTester tester, {
  bool known = true,
}) async {
  final save = await seedSave(tester);
  await tester.runAsync(() async {
    final packs = save.container.read(worldPackRepositoryProvider);
    final packId = await packs.insert(
      WorldPack(
        uuid: 'labels',
        name: 'Burgers',
        author: '',
        formatVersion: kPackFormatVersion,
        madeWithVersion: '1.1.0',
        nations: {seededNationId: (name: 'Burgerland', code: 'BGL')},
        competitions: const {'European Championship': 'Euro Burger'},
      ),
      const {},
    );
    await packs.copyToCareer(packId, save.careerId);
    if (known) await save.container.read(activeWorldSyncProvider).prime();
  });
  return save;
}

String _realCode(SeededSave save) =>
    save.nations.firstWhere((n) => n.id == save.nationId).code;

void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  testWidgets('renamed code shows on the ranking row but the flag still uses '
      'the real code', (tester) async {
    final save = await _renamedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.ranking}?careerId=${save.careerId}',
    );
    expect(tester.takeException(), isNull);

    final row = find.byWidgetPredicate(
      (w) => w is WholeText && w.text == 'Burgerland',
    );
    expect(row, findsOneWidget);
    expect(tester.widget<WholeText>(row).shortText, 'BGL');
    final real = _realCode(save);
    expect(
      find.byWidgetPredicate((w) => w is FlagDisc && w.code == real),
      findsWidgets,
    );
    expect(
      find.byWidgetPredicate((w) => w is FlagDisc && w.code == 'BGL'),
      findsNothing,
    );
  });

  testWidgets('renamed nation shows in Czech too', (tester) async {
    final save = await _renamedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.ranking}?careerId=${save.careerId}',
      locale: const Locale('cs'),
    );
    expect(
      find.byWidgetPredicate((w) => w is WholeText && w.text == 'Burgerland'),
      findsOneWidget,
    );
  });

  testWidgets('renamed European Championship shows in the cup header', (
    tester,
  ) async {
    final save = await _renamedSave(tester);
    await watchContinentalQualifyingDraw(tester, save);
    await pumpRoute(
      tester,
      save,
      '${Routes.continental}?careerId=${save.careerId}'
      '&conf=${Confederation.europe.name}',
    );
    expect(tester.takeException(), isNull);
    expect(find.textContaining('EURO BURGER'), findsWidgets);
    expect(find.textContaining('EUROPEAN CHAMPIONSHIP'), findsNothing);
  });

  testWidgets('renamed code shows on the results rows', (tester) async {
    final save = await _renamedSave(tester);
    await watchContinentalQualifyingDraw(tester, save);
    await pumpRoute(
      tester,
      save,
      '${Routes.results}?careerId=${save.careerId}',
    );
    expect(tester.takeException(), isNull);
    expect(find.text('BGL'), findsWidgets);
    expect(find.text(_realCode(save)), findsNothing);
  });

  testWidgets('renamed European Championship names its qualifiers on the '
      'hub', (tester) async {
    final save = await _renamedSave(tester);
    await watchContinentalQualifyingDraw(tester, save);
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(tester.takeException(), isNull);
    expect(
      find.textContaining(
        enL.compQualifiers('Euro Burger').toUpperCase(),
      ),
      findsWidgets,
    );
    expect(
      find.textContaining('EUROPEAN CHAMPIONSHIP', findRichText: true),
      findsNothing,
    );
  });

  testWidgets('opening the menu resets the active world', (tester) async {
    final save = await _renamedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.ranking}?careerId=${save.careerId}',
    );
    expect(ActiveWorld.current.isDefault, isFalse);
    expect(ActiveWorld.current.nationName(seededNationId), 'Burgerland');
    expect(save.container.read(activeWorldProvider).isDefault, isFalse);

    save.container.read(routerProvider).go(Routes.home);
    await settle(tester);
    expect(ActiveWorld.current.isDefault, isTrue);
    expect(save.container.read(activeWorldProvider).isDefault, isTrue);
  });

  testWidgets('a career the app was not told of is read as a default one', (
    tester,
  ) async {
    final save = await _renamedSave(tester, known: false);
    await pumpRoute(
      tester,
      save,
      '${Routes.ranking}?careerId=${save.careerId}',
    );
    expect(ActiveWorld.current.isDefault, isTrue);
  });

  testWidgets('a career created on a world is known at once', (tester) async {
    final save = await seedSave(tester);
    late int careerId;
    await tester.runAsync(() async {
      final packs = save.container.read(worldPackRepositoryProvider);
      final packId = await packs.insert(
        WorldPack(
          uuid: 'created',
          name: 'Burgers',
          author: '',
          formatVersion: kPackFormatVersion,
          madeWithVersion: '1.1.0',
          nations: {seededNationId: (name: 'Burgerland', code: 'BGL')},
        ),
        const {},
      );
      careerId =
          (await save.container
                  .read(careerServiceProvider)
                  .create(
                    nationId: seededNationId,
                    managerName: 'N',
                    rngSeed: 7,
                    worldPackId: packId,
                  ))
              .valueOrNull!
              .id;
    });
    await pumpRoute(tester, save, '${Routes.ranking}?careerId=$careerId');
    expect(ActiveWorld.current.nationName(seededNationId), 'Burgerland');
  });

  testWidgets('a menu pushed over a career keeps its world', (tester) async {
    final save = await _renamedSave(tester);
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(ActiveWorld.current.isDefault, isFalse);
    final seen = <ActiveWorld>[];
    final sub = save.container.listen(
      activeWorldProvider,
      (_, w) => seen.add(w),
    );
    addTearDown(sub.close);

    final router = save.container.read(routerProvider);
    unawaited(router.push<void>(Routes.settings));
    await settle(tester);
    router.pop();
    await settle(tester);

    expect(seen.where((w) => w.isDefault), isEmpty);
    expect(save.container.read(activeWorldProvider).isDefault, isFalse);
  });

  testWidgets('a career screen pushed over a menu keeps its world', (
    tester,
  ) async {
    final save = await _renamedSave(tester);
    await pumpRoute(tester, save, Routes.saves);
    final router = save.container.read(routerProvider);
    unawaited(
      router.push<void>('${Routes.ranking}?careerId=${save.careerId}'),
    );
    await settle(tester);
    expect(ActiveWorld.current.nationName(seededNationId), 'Burgerland');
    router.pop();
    await settle(tester);
    expect(ActiveWorld.current.isDefault, isTrue);
  });

  testWidgets('a career opened before start-up learnt the worlds waits for '
      'them', (tester) async {
    final save = await _renamedSave(tester, known: false);
    // Start-up's read still running when the save is opened.
    await tester.runAsync(() async {
      unawaited(save.container.read(activeWorldSyncProvider).prime());
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.ranking}?careerId=${save.careerId}',
    );
    expect(ActiveWorld.current.nationName(seededNationId), 'Burgerland');
  });

  testWidgets('a default career leaves the world untouched', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.ranking}?careerId=${save.careerId}',
    );
    expect(ActiveWorld.current.isDefault, isTrue);
    final real = save.nations.firstWhere((n) => n.id == save.nationId);
    final row = find.byWidgetPredicate(
      (w) => w is WholeText && w.text == real.name,
    );
    expect(row, findsOneWidget);
    expect(tester.widget<WholeText>(row).shortText, real.code);
  });
}
