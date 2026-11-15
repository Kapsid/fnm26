import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/domain/services/competition/confed_playoffs.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

/// Makes now the draws a calendar2 cycle makes later in the season (see
/// `SeasonCycle._calendar2Draws`), with the very inputs it uses for a
/// career's first cycle, so a test can read a run's stored qualifying
/// groups or its second Nations Cup without playing up to them.

/// Europe's qualifying for the continental finals, as drawn at the end of
/// the first Nations Cup's league phase. Its groups are those every cycle
/// before calendar2 drew on its first day; only the dates differ.
Future<void> drawEuroQualifyingNow(ProviderContainer c, int careerId) async {
  final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
  final comp = c.read(competitionRepositoryProvider);
  if (await comp.hasTournament(
    careerId,
    CompetitionKind.continentalQualifying,
    confederation: Confederation.europe,
  )) {
    return;
  }
  await CareerService.buildEuroQualifying(
    comp: comp,
    nations: await c.read(nationRepositoryProvider).forCareer(careerId),
    careerId: careerId,
    rngSeed: career.rngSeed,
    cycle: career.cyclePointer,
    wcYear: CareerService.worldCupYear(career.cyclePointer),
  );
  await comp.markDrawWatched(careerId, career.cyclePointer, 'cal2:euroQual');
}

/// Europe's second Nations Cup (the one the board and the campaigns read),
/// on the ladder as it stands.
Future<void> drawSecondNationsCupNow(ProviderContainer c, int careerId) async {
  final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
  final comp = c.read(competitionRepositoryProvider);
  const europe = Confederation.europe;
  if (await comp.hasTournament(
    careerId,
    CompetitionKind.nationsLeague,
    confederation: europe,
    edition: Calendar2.secondEdition,
  )) {
    return;
  }
  final wcYear = CareerService.worldCupYear(career.cyclePointer);
  await CareerService.buildNationsCup(
    comp: comp,
    nations: await c.read(nationRepositoryProvider).forCareer(careerId),
    careerId: careerId,
    rngSeed: career.rngSeed,
    cycle: career.cyclePointer,
    confederation: europe,
    leagueYear: Calendar2.nationsCupLeagueYear(
      wcYear,
      europe,
      Calendar2.secondEdition,
      calendar2: true,
    ),
    nationsCupTiers: await c
        .read(careerRepositoryProvider)
        .nationsCupTiers(careerId),
    edition: Calendar2.secondEdition,
  );
  await comp.unmarkDrawWatched(
    careerId,
    career.cyclePointer,
    nationsCupDrawKind,
  );
}

/// Every confederation's World Championship qualifying, drawn now on the
/// career's seed and the static ranking, and marked as made so the season
/// does not draw it again.
Future<void> drawWcQualifyingNow(ProviderContainer c, int careerId) async {
  final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
  final comp = c.read(competitionRepositoryProvider);
  if (await comp.hasTournament(
    careerId,
    CompetitionKind.worldCupQualifying,
    confederation: Confederation.europe,
  )) {
    return;
  }
  await CareerService.buildWorldCupQualifying(
    comp: comp,
    nations: await c.read(nationRepositoryProvider).forCareer(careerId),
    careerId: careerId,
    nationId: career.nationId,
    rngSeed: career.rngSeed,
    cycle: career.cyclePointer,
    wcYear: CareerService.worldCupYear(career.cyclePointer),
  );
  for (final kind in const ['cal2:wcqSouthAmerica', 'cal2:wcq']) {
    await comp.markDrawWatched(careerId, career.cyclePointer, kind);
  }
}

/// Plays Africa's, Asia's and Oceania's World Championship qualifying
/// play-off steps (calendar2, see `ConfedPlayoffs`) by hand, the
/// better-ranked side winning 2-0 every match, one progression pass at a
/// time, until the World Championship's draws are made. For a test whose
/// qualifying is already played out.
Future<void> playConfedStepsNow(ProviderContainer c, int careerId) async {
  final comp = c.read(competitionRepositoryProvider);
  final season = c.read(seasonServiceProvider);
  final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
  final rank = {
    for (final n in await c.read(nationRepositoryProvider).forCareer(careerId))
      n.id: n.ranking,
  };
  for (var pass = 0; pass < 12; pass++) {
    await season.progressForTest(careerId);
    if ((await comp.drawSlots(
      careerId,
      career.cyclePointer,
      CompetitionKind.worldCupFinals,
    )).isNotEmpty) {
      return;
    }
    for (final conf in ConfedPlayoffs.confederations) {
      for (final round in ConfedPlayoffs.rounds) {
        for (final f in await comp.fixturesByRound(
          careerId,
          round,
          kind: ConfedPlayoffs.kind,
          confederation: conf,
        )) {
          if (f.played) continue;
          final homeWins = rank[f.homeNationId]! < rank[f.awayNationId]!;
          await comp.recordResult(
            fixtureId: f.id,
            homeScore: homeWins ? 2 : 0,
            awayScore: homeWins ? 0 : 2,
          );
        }
      }
    }
  }
}
