import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';

/// The player's own matches (qualifiers + finals), in date order.
class ResultsData {
  const ResultsData({
    required this.fixtures,
    required this.nations,
    required this.playerNationId,
    this.cyclePointer = 0,
    this.nationByCycle = const {},
  });

  /// The player's fixtures, chronological.
  final List<Fixture> fixtures;
  final Map<int, Nation> nations;
  final int playerNationId;

  /// The cycle being played now. Everything before it is history and is folded
  /// away; this one is the section that opens.
  final int cyclePointer;

  /// Which nation the manager led in each cycle, `0 … cyclePointer`. A career
  /// can cross several nations, and a cycle's record is the record of the side
  /// he had at the time.
  final Map<int, int> nationByCycle;
}

/// Which cycle a match belongs to, for a career currently in [cyclePointer].
///
/// The windows are the ones the career history uses — August to August, so the
/// World Championship in the summer closes the cycle it belongs to rather than
/// opening the next one. Both ends are CLAMPED, and the top end matters: the
/// qualifiers for the next cycle are on the calendar months before the
/// rollover that starts it, and a fixture the manager can already see on his
/// list has to sit somewhere. It sits in the cycle he is living through, which
/// is also the truth of it — nothing has closed yet.
int cycleOfDate(DateTime date, int cyclePointer) {
  final months =
      (date.year - CareerService.cycleStart.year) * 12 + (date.month - 8);
  final cycle = months ~/ 48;
  return cycle.clamp(0, cyclePointer);
}

final AutoDisposeFutureProviderFamily<ResultsData?, int> resultsProvider =
    FutureProvider.autoDispose.family<ResultsData?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final careerRepo = ref.watch(careerRepositoryProvider);
      final career = await careerRepo.byId(careerId);
      if (career == null) return null;

      final comp = ref.watch(competitionRepositoryProvider);

      // Which side the manager had in each cycle. `stints` records only the
      // moves, so a cycle it says nothing about was served at the nation he is
      // at now — the same reading the career history takes.
      final stints = await careerRepo.stints(careerId);
      final nationByCycle = {
        for (var c = 0; c <= career.cyclePointer; c++)
          c: stints[c] ?? career.nationId,
      };

      // HIS matches, not one nation's. The list used to be the current
      // nation's whole fixture history, so a manager who had moved on was
      // shown four years of matches he had nothing to do with and none of the
      // ones he had actually taken charge of.
      final byNation = <int, List<Fixture>>{};
      final fixtures = <Fixture>[];
      for (final entry in nationByCycle.entries) {
        final all =
            byNation[entry.value] ??= await comp.fixturesForNation(
              careerId,
              entry.value,
            );
        fixtures.addAll(
          all.where(
            (f) => cycleOfDate(f.date, career.cyclePointer) == entry.key,
          ),
        );
      }

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
        cyclePointer: career.cyclePointer,
        nationByCycle: nationByCycle,
      );
    });
