import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/squad/captaincy.dart';
import 'package:fnm/features/match/setup_warning.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// Vice-captains: named once, they take the armband in order whenever the
/// captain cannot play, so the manager does not have to move it every match.
void main() {
  const captainId = 1;
  const vice1Id = 2;
  const vice2Id = 3;
  const takerId = 4;

  Player player(int id) => Player(
    id: id,
    nationId: 1,
    name: 'Player $id',
    position: PlayerPosition.cm,
    age: 30,
    club: 'Club',
    attributes: const PlayerAttributes(
      physical: 80,
      technical: 80,
      stamina: 80,
    ),
  );

  final everyone = {captainId, vice1Id, vice2Id, takerId};

  ProviderContainer open({
    int? captain = captainId,
    int? vice1 = vice1Id,
    int? vice2 = vice2Id,
    Set<int>? callUps,
    Map<int, PlayerAbsence> absences = const {},
    Set<int>? pool,
  }) {
    final repo = _FakeCareers()
      ..career = Career(
        id: 1,
        managerName: 'M',
        nationId: 1,
        rngSeed: 1,
        createdAt: DateTime(2030),
        inGameDate: DateTime(2030, 6),
        captainPlayerId: captain,
        viceCaptain1PlayerId: vice1,
        viceCaptain2PlayerId: vice2,
      );
    final c = ProviderContainer(
      overrides: [
        careerRepositoryProvider.overrideWithValue(repo),
        squadDataProvider(1).overrideWith(
          (ref) async => SquadData(
            pool: [for (final id in pool ?? everyone) player(id)],
            callUps: callUps ?? everyone,
            absences: absences,
          ),
        ),
        setPieceAutoAcceptedProvider(1).overrideWith((ref) async => false),
        setPieceTakersProvider(
          1,
        ).overrideWith((ref) async => (penalty: takerId, deadBall: takerId)),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<Armband> armband(ProviderContainer c) =>
      c.read(armbandProvider(1).future);

  group('who leads the side out', () {
    test('the captain, when he can play', () async {
      final c = open();
      final a = await armband(c);
      expect(a.role, ArmbandRole.captain);
      expect(a.leader?.id, captainId);
      expect((await c.read(captainProvider(1).future))?.id, captainId);
    });

    test('captain injured: the 1st vice-captain', () async {
      final c = open(
        absences: const {
          captainId: PlayerAbsence(playerId: captainId, injuryMatches: 3),
        },
      );
      final a = await armband(c);
      expect(a.role, ArmbandRole.vice1);
      expect(a.leader?.id, vice1Id);
      expect(a.captain?.id, captainId, reason: 'still named, just out');
      expect(
        (await c.read(captainProvider(1).future))?.id,
        vice1Id,
        reason: 'every effect of the armband follows the man wearing it',
      );
      expect(
        await c.read(captainMoraleProvider(1).future),
        Captaincy.moraleBonus(player(vice1Id), saveSeed: 1),
      );
    });

    test('captain dropped and 1st vice banned: the 2nd', () async {
      final c = open(
        callUps: {vice1Id, vice2Id, takerId},
        absences: const {
          vice1Id: PlayerAbsence(playerId: vice1Id, banMatches: 1),
        },
      );
      final a = await armband(c);
      expect(a.role, ArmbandRole.vice2);
      expect(a.leader?.id, vice2Id);
    });

    test('nobody named can play: nobody', () async {
      final c = open(callUps: {takerId});
      final a = await armband(c);
      expect(a.role, isNull);
      expect(a.leader, isNull);
      expect(await c.read(captainProvider(1).future), isNull);
      expect(await c.read(captainMoraleProvider(1).future), 0);
    });

    test('a vice-captain gone from the pool is skipped, not trusted', () async {
      final c = open(
        pool: {captainId, vice2Id, takerId},
        callUps: {vice1Id, vice2Id, takerId},
      );
      final a = await armband(c);
      expect(a.vice1, isNull);
      expect(a.leader?.id, vice2Id);
    });

    test('no vices named: as before, the captain or nobody', () async {
      final c = open(vice1: null, vice2: null, callUps: {takerId});
      expect((await armband(c)).leader, isNull);
    });
  });

  group('the pre-match strip', () {
    test('a captain out with a vice covering says nothing', () async {
      final c = open(
        absences: const {
          captainId: PlayerAbsence(playerId: captainId, injuryMatches: 2),
        },
      );
      final setup = await c.read(squadSetupProvider(1).future);
      expect(setup.captain, isNull);
    });

    test('a captain out with no vice covering still warns', () async {
      final c = open(
        callUps: {captainId, takerId},
        absences: const {
          captainId: PlayerAbsence(playerId: captainId, injuryMatches: 2),
        },
      );
      final setup = await c.read(squadSetupProvider(1).future);
      expect(setup.captain, CaptainIssue.injured);
      expect(setup.captainName, 'Player $captainId');
    });
  });

  group('one post per man', () {
    const named = (captain: 1, vice1: 2, vice2: 3);

    test('naming the 1st vice captain empties his old post', () {
      expect(
        Captaincy.assign(named, ArmbandRole.captain, 2),
        (captain: 2, vice1: null, vice2: 3),
      );
    });

    test('naming the captain 2nd vice empties the captaincy', () {
      expect(
        Captaincy.assign(named, ArmbandRole.vice2, 1),
        (captain: null, vice1: 2, vice2: 1),
      );
    });

    test('null empties only the post asked for', () {
      expect(
        Captaincy.assign(named, ArmbandRole.vice1, null),
        (captain: 1, vice1: null, vice2: 3),
      );
    });

    test('a retiring vice-captain leaves his post empty', () async {
      final repo = _FakeCareers()
        ..career = Career(
          id: 1,
          managerName: 'M',
          nationId: 1,
          rngSeed: 1,
          createdAt: DateTime(2030),
          inGameDate: DateTime(2030, 6),
          captainPlayerId: 1,
          viceCaptain1PlayerId: 2,
          viceCaptain2PlayerId: 3,
        );
      expect(await releaseArmband(repo, 1, 2), isTrue);
      expect(repo.career.captainPlayerId, 1);
      expect(repo.career.viceCaptain1PlayerId, isNull);
      expect(repo.career.viceCaptain2PlayerId, 3);
      expect(await releaseArmband(repo, 1, 99), isFalse);
    });
  });

  test('the stand-in line names both men', () async {
    final c = open(
      absences: const {
        captainId: PlayerAbsence(playerId: captainId, banMatches: 1),
      },
    );
    final a = await armband(c);
    expect(
      armbandStandIn(AppLocalizationsEn(), a),
      'Vice-captain Player 2 leads out; captain Player 1 unavailable',
    );
    expect(
      armbandStandIn(AppLocalizationsCs(), a),
      'Tým vyvede zástupce kapitána Player 2, kapitán Player 1 nemůže hrát',
    );
    expect(armbandStandIn(AppLocalizationsEn(), await armband(open())), isNull);
  });
}

class _FakeCareers implements CareerRepository {
  late Career career;

  @override
  Future<Career?> byId(int id) async => career;

  @override
  Future<void> setLeadership(
    int id, {
    required int? captain,
    required int? vice1,
    required int? vice2,
  }) async {
    career = career.copyWith(
      captainPlayerId: captain,
      viceCaptain1PlayerId: vice1,
      viceCaptain2PlayerId: vice2,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not faked');
}
