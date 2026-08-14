import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';

/// Maps Drift row classes to pure domain entities, keeping the domain layer
/// free of any persistence types. One place to change if storage shape evolves.

extension NationRowMapper on NationRow {
  /// Converts this persisted row into a domain [Nation].
  Nation toDomain() => Nation(
    id: id,
    name: name,
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
  );
}
