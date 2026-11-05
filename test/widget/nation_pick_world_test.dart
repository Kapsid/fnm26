import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/world_pack/pack_ranking.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/new_game_screen.dart';
import 'package:fnm/features/career/unemployed_start_screen.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/world_pack/world_choice.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

/// A complete squad of [rating] in every attribute.
List<PackPlayer> _squadAt(int rating) => [
  for (final p in testSquad())
    PackPlayer(
      id: p.id,
      name: p.name,
      age: p.age,
      position: p.position,
      attributes: PlayerAttributes(
        physical: rating,
        technical: rating,
        stamina: rating,
      ),
      potential: rating,
    ),
];

Future<T> _read<T>(
  WidgetTester tester,
  ProviderContainer c,
  Future<T> Function() read,
) async {
  late T value;
  await tester.runAsync(() async => value = await read());
  return value;
}

void main() {
  testWidgets('a pack that renames Czechia to Bohemia at 90 shows Bohemia, '
      'finds it by search, rates it 90 and ranks it as the career will', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final cze = nationIdOf('CZE');
    final id = await insertPack(
      tester,
      c,
      testPack(
        'Bohemian',
        squads: {cze: _squadAt(90)},
      ).copyWith(nations: {cze: (name: 'Bohemia', code: 'BOH')}),
    );
    chooseNewGameWorld(c, id);
    // Kept alive for the reads below.
    c.listen(newGameNationsProvider(id), (_, _) {});
    c.listen(newGameStrengthsProvider(id), (_, _) {});
    c.listen(newGameStarPlayersProvider(id), (_, _) {});

    await pumpEditorRoute(tester, c, Routes.nations);
    await pumpUntilFound(tester, find.text('Bohemia'));
    expect(find.text('Czechia'), findsNothing);

    // Search finds it under its world's name.
    await tester.enterText(find.byType(TextField).first, 'bohem');
    await settle(tester);
    expect(find.text('Bohemia'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'czech');
    await settle(tester);
    expect(find.text('Bohemia'), findsNothing);
    expect(find.text('Czechia'), findsNothing);

    // Its strength and star are the pack squad's.
    final strengths = await _read(
      tester,
      c,
      () => c.read(newGameStrengthsProvider(id).future),
    );
    expect(strengths[cze]!.overall, 90);
    expect(strengths[cze]!.tier, 5);
    expect(strengths[cze]!.best.overall, 90);
    final stars = await _read(
      tester,
      c,
      () => c.read(newGameStarPlayersProvider(id).future),
    );
    expect(stars[cze]!.overall, 90);
    expect(stars[cze]!.name, startsWith('Player '));

    // Its rank is the one the career starts on.
    final base = await _read(tester, c, () => c.read(nationsProvider.future));
    final pack = await _read(
      tester,
      c,
      () => c.read(worldPackRepositoryProvider).load(id),
    );
    final service = c.read(worldPackServiceProvider);
    final ranks = PackRanking.startingRanks(
      baseRanks: {for (final n in base) n.id: n.ranking},
      defaultStrength: await _read(tester, c, service.defaultStrength),
      packStrength: PackRanking.squadStrengths(pack!.squads),
    );
    final nations = await _read(
      tester,
      c,
      () => c.read(newGameNationsProvider(id).future),
    );
    expect({for (final n in nations) n.id: n.ranking}, ranks);
    final bohemia = nations.firstWhere((n) => n.id == cze);
    expect(bohemia.name, 'Bohemia');
    expect(bohemia.ranking, lessThan(10));
    // Listed best first by those ranks.
    expect(
      [for (final n in nations) n.ranking],
      [for (final n in nations) n.ranking]..sort(),
    );

    // New Game names and ranks it the same way.
    c.read(routerProvider).go('${Routes.newGame}?nationId=$cze');
    await pumpUntilFound(tester, find.byType(NewGameScreen));
    await pumpUntilFound(tester, find.text('Bohemia'));
    expect(
      find.text(enL.careerWorldRankNum(bohemia.ranking)),
      findsOneWidget,
    );
  });

  testWidgets('From the bottom offers the bottom of the pack ranking', (
    tester,
  ) async {
    final fra = nationIdOf('FRA');
    final c = await editorContainer(tester);
    // France at 5 in everything: the bottom of the world by the pack.
    final id = await insertPack(
      tester,
      c,
      testPack('Fallen', squads: {fra: _squadAt(5)}),
    );
    chooseNewGameWorld(c, id);
    c.listen(newGameNationsProvider(id), (_, _) {});
    final nations = await _read(
      tester,
      c,
      () => c.read(newGameNationsProvider(id).future),
    );
    expect(nations.last.id, fra);

    // A seed whose three offers include France, drawn as the screen draws
    // them: from the bottom half of the ranking.
    List<Nation> offers(List<Nation> all, int seed) {
      final sorted = all.toList()
        ..sort((a, b) => a.ranking.compareTo(b.ranking));
      final pool = sorted.sublist((sorted.length * 0.5).floor());
      return SeededRng(seed).shuffled(pool).take(3).toList();
    }

    final seed = List.generate(
      500,
      (i) => i,
    ).firstWhere((s) => offers(nations, s).any((n) => n.id == fra));

    final picked = ProviderContainer(
      parent: c,
      overrides: [unemployedOfferSeedProvider.overrideWithValue(seed)],
    );
    addTearDown(picked.dispose);
    await pumpEditorRoute(tester, picked, Routes.startFromBottom);
    await pumpUntilFound(tester, find.text('France'));
    expect(
      find.text(enL.bottomStartRankOf(nations.last.ranking, nations.length)),
      findsOneWidget,
    );

    // On the game's own world France is nowhere near the bottom.
    chooseNewGameWorld(picked, null);
    await settle(tester);
    expect(find.text('France'), findsNothing);
    // Let the screen go before its container does.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('Default is the game world exactly', (tester) async {
    final c = await editorContainer(tester);
    await insertPack(
      tester,
      c,
      testPack(
        'Other',
        squads: {nationIdOf('CZE'): _squadAt(90)},
      ).copyWith(nations: {nationIdOf('CZE'): (name: 'Bohemia', code: 'BOH')}),
    );
    c
      ..listen(newGameNationsProvider(null), (_, _) {})
      ..listen(newGameStrengthsProvider(null), (_, _) {})
      ..listen(newGameStarPlayersProvider(null), (_, _) {});
    expect(
      await _read(tester, c, () => c.read(newGameNationsProvider(null).future)),
      await _read(tester, c, () => c.read(nationsProvider.future)),
    );
    expect(
      await _read(
        tester,
        c,
        () => c.read(newGameStrengthsProvider(null).future),
      ),
      await _read(tester, c, () => c.read(nationStrengthsProvider.future)),
    );
    expect(
      await _read(
        tester,
        c,
        () => c.read(newGameStarPlayersProvider(null).future),
      ),
      await _read(tester, c, () => c.read(starPlayersProvider.future)),
    );

    await pumpEditorRoute(tester, c, Routes.nations);
    await tester.enterText(find.byType(TextField).first, 'czech');
    await settle(tester);
    expect(find.text('Czechia'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'bohem');
    await settle(tester);
    expect(find.text('Bohemia'), findsNothing);
  });
}
