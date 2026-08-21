import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/nation/nation_names.dart';

/// Maps Drift row classes to pure domain entities, keeping the domain layer
/// free of any persistence types. One place to change if storage shape evolves.

extension NationRowMapper on NationRow {
  /// Converts this persisted row into a domain [Nation], with its name written
  /// for [languageCode] — the stored name is the canonical English one, and a
  /// Czech save should not read as a list of English countries.
  Nation toDomain({String languageCode = 'en'}) => Nation(
    id: id,
    name: NationNames.display(code, name, languageCode),
    englishName: name,
    code: code,
    confederation: confederation,
    ranking: ranking,
    isFreeDemo: isFreeDemo,
    primaryColor: primaryColor,
    secondaryColor: secondaryColor,
  );
}

extension PlayerRowMapper on PlayerRow {
  /// Converts this persisted row into a domain [Player].
  Player toDomain() => Player(
    id: id,
    nationId: nationId,
    name: name,
    age: age,
    position: position,
    attributes: PlayerAttributes(
      physical: physical,
      technical: technical,
      stamina: stamina,
    ),
    club: club,
  );
}

extension FixtureRowMapper on FixtureRow {
  /// Converts this persisted row into a domain [Fixture].
  Fixture toDomain() => Fixture(
    id: id,
    careerId: careerId,
    competitionId: competitionId,
    groupId: groupId,
    matchday: matchday,
    date: date,
    homeNationId: homeNationId,
    awayNationId: awayNationId,
    homeScore: homeScore,
    awayScore: awayScore,
    round: round,
    played: played,
    afterExtraTime: afterExtraTime,
    homePenalties: homePenalties,
    awayPenalties: awayPenalties,
  );
}

extension CareerRowMapper on CareerRow {
  /// Converts this persisted row into a domain [Career].
  Career toDomain() => Career(
    id: id,
    managerName: managerName,
    nationId: nationId,
    rngSeed: rngSeed,
    createdAt: createdAt,
    inGameDate: inGameDate,
    cyclePointer: cyclePointer,
    lastPlayedAt: lastPlayedAt,
    budget: budget,
    captainPlayerId: captainPlayerId,
    yReadAt: yReadAt,
    playedSeconds: playedSeconds,
    skillManManagement: skillManManagement,
    skillTactical: skillTactical,
    skillYouthDevelopment: skillYouthDevelopment,
    skillNegotiation: skillNegotiation,
    staffAssistant:
        StaffTier.values[staffAssistant.clamp(
          0,
          StaffTier.values.length - 1,
        )],
    staffScout:
        StaffTier.values[staffScout.clamp(
          0,
          StaffTier.values.length - 1,
        )],
    staffFitnessCoach:
        StaffTier.values[staffFitnessCoach.clamp(
          0,
          StaffTier.values.length - 1,
        )],
    staffAssistantId: staffAssistantId,
    staffScoutId: staffScoutId,
    staffFitnessCoachId: staffFitnessCoachId,
    lastCycleBoard: lastCycleBoard,
  );
}
