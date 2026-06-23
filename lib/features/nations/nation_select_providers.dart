import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';

/// All nations (seeding the database first if needed), ordered by ranking.
final nationsProvider = FutureProvider<List<Nation>>((ref) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  return ref.watch(nationRepositoryProvider).all();
});

/// The highest-overall ("star") player for each nation, keyed by nation id.
final starPlayersProvider = FutureProvider<Map<int, Player>>((ref) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final players = await ref.watch(playerRepositoryProvider).all();
  final byNation = <int, Player>{};
  for (final p in players) {
    final current = byNation[p.nationId];
    if (current == null || p.overall > current.overall) {
      byNation[p.nationId] = p;
    }
  }
  return byNation;
});

/// The continental tab currently selected on the nation-select screen.
final selectedConfederationProvider =
    StateProvider<Confederation>((_) => Confederation.europe);

/// The current search query on the nation-select screen.
final nationSearchProvider = StateProvider<String>((_) => '');
