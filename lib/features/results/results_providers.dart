import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';

/// The player's own matches (qualifiers + finals), in date order.
class ResultsData {
  const ResultsData({
    required this.fixtures,
    required this.nations,
    required this.playerNationId,
  });

  /// The player's fixtures, chronological.
  final List<Fixture> fixtures;
  final Map<int, Nation> nations;
  final int playerNationId;
}

final AutoDisposeFutureProviderFamily<ResultsData?, int> resultsProvider =
    FutureProvider.autoDispose.family<ResultsData?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;

      final comp = ref.watch(competitionRepositoryProvider);
      final fixtures = await comp.fixturesForNation(careerId, career.nationId);

      // A competition's schedule stays hidden until the player has watched its
      // draw, so fixtures never appear before the balls come out of the pots.
      final cycle = career.cyclePointer;
      final watched = <String>{};
      for (final kind in const [
        worldCupQualDrawKind,
        continentalQualDrawKind,
        continentalFinalsDrawKind,
        worldCupDrawKind,
      ]) {
        if (await comp.hasWatchedDraw(careerId, cycle, kind)) watched.add(kind);
      }

      final visible = fixtures.where((f) {
        if (f.played) return true; // results already played are history
        final kind = drawKindForFixture(f);
        return kind == null || watched.contains(kind);
      }).toList();

      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };
      return ResultsData(
        fixtures: visible,
        nations: nations,
        playerNationId: career.nationId,
      );
    });
