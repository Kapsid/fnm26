import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/domain/services/match/venue.dart';
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';

/// The ONE place that decides where a fixture is played, for the match
/// screen and for a skipped or background match alike.
///
/// Where the ground is decides its altitude and heat ([MatchConditions]), and
/// so the result. Two paths that each picked their own ground once put a
/// skipped tie in Toluca and the shown one in Monterrey. Everything that
/// moves the ground is read here: the fixture's venue (a neutral finals at
/// the host), the nation's real cities, the estate a manager's nation hosts
/// a finals in, and the national stadium his own works have made.
///
/// [homeStrength], [awayStrength] and [moodFill] only size the crowd; they
/// never move the ground.
///
/// [memo] lets a batch of background fixtures share the work that does not
/// change within it (the tournaments' hosts, the host estate, his national
/// ground); the answer is the same with or without it.
Future<MatchGround> resolveMatchGround(
  Ref ref, {
  required Career career,
  required Fixture fixture,
  required List<Nation> nations,
  MatchVenue? venue,
  int homeStrength = 70,
  int awayStrength = 70,
  double moodFill = 0,
  MatchGroundMemo? memo,
}) async {
  final v =
      venue ??
      venueForFixture(
        fixture: fixture,
        nations: nations,
        seed: career.rngSeed,
        cycle: career.cyclePointer,
        hostsMemo: memo?._hosts,
      );
  final cities = await loadCountryCities(ref);
  // A finals the manager's nation hosts is staged in the estate the career
  // has made of its grounds (built Arena Novas, resized grounds).
  Future<Map<int, List<Venue>>> estates() =>
      hostEstatesFor(ref, career.id, v.tournamentHostIds);
  final hostEstates = !v.neutral
      ? const <int, List<Venue>>{}
      : memo == null
      ? await estates()
      : await (memo._estates[v.tournamentHostIds.join(',')] ??= estates());
  // His own nation's home games are played in the national stadium of that
  // estate. Nobody else's estate is ever touched.
  final home = !v.neutral && fixture.homeNationId == career.nationId
      ? await (memo == null
            ? managerNationalGround(ref, career)
            : memo._home ??= managerNationalGround(ref, career))
      : null;
  return Attendance.forFixture(
    fixture: fixture,
    neutral: v.neutral,
    tournamentHostIds: v.tournamentHostIds,
    venueCount: VenueGenerator.countForField(
      tournamentFieldSize(fixture: fixture, nations: nations),
    ),
    citiesByNation: cities,
    seed: career.rngSeed,
    homeStrength: homeStrength,
    awayStrength: awayStrength,
    homeGrounds: {
      if (home != null)
        career.nationId: (
          venue: home.venue,
          fillBonus: NationalStadiums.fillBonus(home.upgrades),
        ),
    },
    hostEstates: hostEstates,
    moodFill: moodFill,
  );
}

/// What one batch of [resolveMatchGround] calls may share: built per batch
/// of background fixtures (for one career, inside one step, so nothing it
/// holds can change under it) and then dropped.
class MatchGroundMemo {
  final Map<Object, List<int>> _hosts = {};
  final Map<String, Future<Map<int, List<Venue>>>> _estates = {};
  Future<NationalStadium?>? _home;
}

/// The conditions of [fixture] at [ground]: its altitude and the heat of
/// its month, and what they cost each side.
MatchConditions conditionsAt(Fixture fixture, MatchGround ground) =>
    MatchConditions.at(
      groundNationId: ground.groundNationId,
      city: ground.city,
      month: fixture.date.month,
      homeNationId: fixture.homeNationId,
      awayNationId: fixture.awayNationId,
    );

/// The ground the manager's nation plays its home games in, or null when it
/// has no open ground.
///
/// Once the career has done ANY stadium work for it, the biggest open ground
/// of the estate, as it always was: the federation's investment is what the
/// national team plays in. An untouched estate is the static one, so it plays
/// where every AI nation does: its national team's home city, or its biggest
/// ground. A nation that plays up in the mountains (Quito, Bogotá, Addis
/// Ababa; see `MatchClimate.homeCityOf`) stays there whatever is built: the
/// thin air is its edge, and a seat upgrade elsewhere must not cost it.
Future<NationalStadium?> managerNationalGround(Ref ref, Career career) async {
  final grounds = await careerStadiumsFor(ref, career.id, career.nationId);
  if (grounds.isEmpty) return null;
  final works = await stadiumWorks(
    ref.read(competitionRepositoryProvider),
    career.id,
  );
  return nationalGroundOf(
    grounds,
    career.nationId,
    worked: works.any((w) => w.nationId == career.nationId),
  );
}

/// Of [grounds] (biggest first): the first in the national team's home city
/// when the estate is untouched, or whenever that city is at altitude (an
/// acclimatised nation always plays up there); else the biggest. With no
/// ground left in the home city, the biggest.
NationalStadium nationalGroundOf(
  List<NationalStadium> grounds,
  int nationId, {
  required bool worked,
}) {
  final atAltitude =
      MatchClimate.acclimatisedAltitude(nationId) >= MatchClimate.altitudeFloor;
  if (!worked || atAltitude) {
    final city = MatchClimate.homeCityOf(nationId);
    for (final g in grounds) {
      if (g.city == city) return g;
    }
  }
  return grounds.first;
}

/// Each nation's real cities. A failed load is not cached as "no cities":
/// the provider is reset and read once more, and a second failure is thrown
/// to the caller (the bundled asset missing is a bug to surface, not a
/// world quietly played at sea level).
Future<Map<int, List<String>>> loadCountryCities(Ref ref) async {
  try {
    return await ref.read(countryCitiesProvider.future);
  } on Object {
    ref.invalidate(countryCitiesProvider);
    return ref.read(countryCitiesProvider.future);
  }
}
