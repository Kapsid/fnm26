import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';

/// Everything the Continental Clash screen shows: this cycle's one-off match
/// (once both continental champions are known) and the full roll of honour.
typedef ContinentalClashData = ({
  Fixture? tie,
  Map<int, Nation> nations,
  int playerNationId,
  List<Honour> honours,
});

final AutoDisposeFutureProviderFamily<ContinentalClashData?, int>
continentalClashProvider = FutureProvider.autoDispose
    .family<ContinentalClashData?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final comp = ref.watch(competitionRepositoryProvider);

      final ties = await comp.fixturesByRound(
        careerId,
        'FFINAL',
        kind: CompetitionKind.finalissima,
      );
      final honours = (await comp.honours(
        careerId,
      )).where((h) => h.competition == 'Continental Clash').toList();
      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };
      return (
        tie: ties.firstOrNull,
        nations: nations,
        playerNationId: career.nationId,
        honours: honours,
      );
    });
