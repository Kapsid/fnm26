import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/features/career/career_providers.dart';
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
