import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/role_tilt.dart';

import '../../helpers/fixtures.dart';

/// 4-3-3 slots: 0 gk, 1 lb, 2 cb, 3 cb, 4 rb, 5 dm, 6 cm, 7 cm, 8 lw, 9 st,
/// 10 rw.
const _attacking = {
  6: PlayerRole.boxToBox,
  7: PlayerRole.playmaker,
  8: PlayerRole.invertedWinger,
  9: PlayerRole.poacher,
  10: PlayerRole.invertedWinger,
  5: PlayerRole.deepPlaymaker,
  1: PlayerRole.wingBack,
  4: PlayerRole.wingBack,
};

const _defensive = {
  1: PlayerRole.defensiveFullBack,
  2: PlayerRole.coveringDefender,
  3: PlayerRole.coveringDefender,
  4: PlayerRole.defensiveFullBack,
  5: PlayerRole.anchor,
  8: PlayerRole.defensiveWinger,
  10: PlayerRole.defensiveWinger,
};

PlayerAttributes _attrs(int p, int t, int s) =>
    PlayerAttributes(physical: p, technical: t, stamina: s);

MatchTeam _team(
  int nationId, {
  SlotRoles roles = SlotRoles.none,
  SlotArrows arrows = SlotArrows.none,
  PlayerAttributes Function(int slot)? attributes,
}) {
  final positions = Formation.f433.positions;
  return MatchTeam(
    nationId: nationId,
    formation: Formation.f433,
    instructions: const TacticalInstructions(),
    slotRoles: roles,
    arrows: arrows,
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
          attributes: attributes?.call(i) ?? _attrs(72, 72, 72),
        ),
    ],
  );
}

typedef _Tally = ({
  int shotsFor,
  int shotsAgainst,
  int goalsFor,
  int goalsAgainst,
});

_Tally _play({
  SlotRoles roles = SlotRoles.none,
  SlotArrows arrows = SlotArrows.none,
  PlayerAttributes Function(int slot)? attributes,
  int seeds = 1500,
}) {
  const engine = MatchEngine();
  var shotsFor = 0;
  var shotsAgainst = 0;
  var goalsFor = 0;
  var goalsAgainst = 0;
  for (var i = 0; i < seeds; i++) {
    for (final atHome in const [true, false]) {
      final a = _team(
        1,
        roles: roles,
        arrows: arrows,
        attributes: attributes,
      );
      final b = _team(2);
      final r = engine.play(
        home: atHome ? a : b,
        away: atHome ? b : a,
        rng: SeededRng.forFixture(0x501E, i),
        neutralVenue: true,
      );
      shotsFor += atHome ? r.homeShots : r.awayShots;
      shotsAgainst += atHome ? r.awayShots : r.homeShots;
      goalsFor += atHome ? r.homeScore : r.awayScore;
      goalsAgainst += atHome ? r.awayScore : r.homeScore;
    }
  }
  return (
    shotsFor: shotsFor,
    shotsAgainst: shotsAgainst,
    goalsFor: goalsFor,
    goalsAgainst: goalsAgainst,
  );
}

void main() {
  group('neutral plays exactly as before', () {
    test('no role, no arrow: the same match, seed for seed', () {
      const engine = MatchEngine();
      for (var i = 0; i < 40; i++) {
        final plain = engine.play(
          home: _team(1),
          away: _team(2),
          rng: SeededRng.forFixture(0xA11, i),
        );
        // A role the slot cannot play (a poacher in goal) and an arrow the
        // place does not offer (a keeper running forward) are ignored.
        final ignored = engine.play(
          home: _team(
            1,
            roles: const SlotRoles({0: PlayerRole.poacher}),
            arrows: const SlotArrows({0: MoveArrow.forward}),
          ),
          away: _team(2),
          rng: SeededRng.forFixture(0xA11, i),
        );
        expect(ignored.homeScore, plain.homeScore);
        expect(ignored.awayScore, plain.awayScore);
        expect(ignored.homeShots, plain.homeShots);
        expect(ignored.events.length, plain.events.length);
      }
    });

    test('a neutral side tilts nothing', () {
      expect(
        RoleTilt.of(
          xi: _team(1).xi,
          slots: Formation.f433.positions,
          roles: const [],
          arrows: const [],
        ).isNeutral,
        isTrue,
      );
      final skip = RoleTilt.skipEffect(TeamTilt.neutral);
      expect(skip.ratingDelta, 0);
      expect(skip.openness, 1);
    });
  });

  group('roles move the match the way they say, a little', () {
    final neutral = _play();

    test('attacking roles: more chances for, and more against', () {
      final t = _play(roles: const SlotRoles(_attacking));
      final forRatio = t.shotsFor / neutral.shotsFor;
      final againstRatio = t.shotsAgainst / neutral.shotsAgainst;
      final goalsRatio = t.goalsFor / neutral.goalsFor;
      // ignore: avoid_print
      print(
        'attacking roles: shots for x${forRatio.toStringAsFixed(3)}, '
        'against x${againstRatio.toStringAsFixed(3)}, '
        'goals for x${goalsRatio.toStringAsFixed(3)}',
      );
      expect(forRatio, inInclusiveRange(1.01, 1.12));
      expect(againstRatio, inInclusiveRange(1.0, 1.10));
      expect(goalsRatio, lessThan(1.15));
    });

    test('defensive roles: fewer chances against, and fewer for', () {
      final t = _play(roles: const SlotRoles(_defensive));
      final forRatio = t.shotsFor / neutral.shotsFor;
      final againstRatio = t.shotsAgainst / neutral.shotsAgainst;
      // ignore: avoid_print
      print(
        'defensive roles: shots for x${forRatio.toStringAsFixed(3)}, '
        'against x${againstRatio.toStringAsFixed(3)}',
      );
      expect(againstRatio, inInclusiveRange(0.88, 0.99));
      expect(forRatio, inInclusiveRange(0.90, 1.0));
    });

    test('a role that suits the man works better than one that does not', () {
      // The same attacking roles on two elevens of the same overall
      // quality: one whose strength is the technique those roles lean on,
      // one whose strength is running and power.
      PlayerAttributes technical(int _) => _attrs(66, 82, 68);
      PlayerAttributes physical(int _) => _attrs(82, 66, 68);
      final techBase = _play(attributes: technical, seeds: 1200);
      final techRoles = _play(
        attributes: technical,
        roles: const SlotRoles({
          7: PlayerRole.playmaker,
          8: PlayerRole.invertedWinger,
          9: PlayerRole.poacher,
          10: PlayerRole.invertedWinger,
          5: PlayerRole.deepPlaymaker,
        }),
        seeds: 1200,
      );
      final physBase = _play(attributes: physical, seeds: 1200);
      final physRoles = _play(
        attributes: physical,
        roles: const SlotRoles({
          7: PlayerRole.playmaker,
          8: PlayerRole.invertedWinger,
          9: PlayerRole.poacher,
          10: PlayerRole.invertedWinger,
          5: PlayerRole.deepPlaymaker,
        }),
        seeds: 1200,
      );
      double margin(_Tally t, _Tally base) =>
          (t.goalsFor - t.goalsAgainst - (base.goalsFor - base.goalsAgainst)) /
          (2 * 1200);
      final good = margin(techRoles, techBase);
      final poor = margin(physRoles, physBase);
      // ignore: avoid_print
      print(
        'goal margin per match from the roles: suited '
        '${good.toStringAsFixed(3)}, unsuited ${poor.toStringAsFixed(3)}',
      );
      expect(good, greaterThan(poor));
      expect(good, greaterThan(0));
      expect(poor, lessThan(0.02));
    });

    test('the fit reads the quality the role leans on', () {
      expect(
        PlayerRole.targetMan.fitOf(_attrs(85, 65, 70)),
        RoleFit.good,
      );
      expect(PlayerRole.targetMan.fitOf(_attrs(60, 85, 70)), RoleFit.poor);
      expect(PlayerRole.boxToBox.fitOf(_attrs(70, 70, 71)), RoleFit.fair);
      expect(PlayerRole.none.fitOf(_attrs(40, 90, 40)), RoleFit.good);
    });

    test('even every role at once stays within a few percent', () {
      // The clamp: no eleven of roles and arrows lifts a side's open-play
      // rate by more than 8% or cuts its opponent's by more than 8%.
      final all = RoleTilt.of(
        xi: _team(1, attributes: (_) => _attrs(60, 90, 90)).xi,
        slots: Formation.f433.positions,
        roles: [
          PlayerRole.sweeperKeeper,
          PlayerRole.wingBack,
          PlayerRole.ballPlayingDefender,
          PlayerRole.ballPlayingDefender,
          PlayerRole.wingBack,
          PlayerRole.deepPlaymaker,
          PlayerRole.boxToBox,
          PlayerRole.boxToBox,
          PlayerRole.invertedWinger,
          PlayerRole.poacher,
          PlayerRole.invertedWinger,
        ],
        arrows: List.filled(11, MoveArrow.forward),
      );
      expect(all.attack, lessThanOrEqualTo(RoleTilt.kMaxAttack));
      expect(all.cover, greaterThanOrEqualTo(-RoleTilt.kMaxCover));
      expect(
        RoleTilt.chanceLift(all, TeamTilt.neutral),
        lessThanOrEqualTo(1.08 + 1e-9),
      );
    });
  });

  group('arrows', () {
    final neutral = _play();

    test('forward runs: more chances at both ends', () {
      final t = _play(
        arrows: const SlotArrows({
          6: MoveArrow.forward,
          7: MoveArrow.forward,
          8: MoveArrow.forwardInside,
          10: MoveArrow.forwardInside,
        }),
      );
      final forRatio = t.shotsFor / neutral.shotsFor;
      final againstRatio = t.shotsAgainst / neutral.shotsAgainst;
      // ignore: avoid_print
      print(
        'forward arrows: shots for x${forRatio.toStringAsFixed(3)}, '
        'against x${againstRatio.toStringAsFixed(3)}',
      );
      expect(forRatio, inInclusiveRange(1.02, 1.10));
      expect(againstRatio, inInclusiveRange(1.02, 1.10));
    });

    test('sitting back: fewer chances at both ends', () {
      final t = _play(
        arrows: const SlotArrows({
          5: MoveArrow.back,
          6: MoveArrow.back,
          7: MoveArrow.back,
          9: MoveArrow.back,
        }),
      );
      final forRatio = t.shotsFor / neutral.shotsFor;
      final againstRatio = t.shotsAgainst / neutral.shotsAgainst;
      expect(forRatio, inInclusiveRange(0.92, 0.99));
      expect(againstRatio, inInclusiveRange(0.92, 0.99));
    });

    test('a full-back slot reads no arrow here: his is FullBackPushes', () {
      // An arrow stored on a full-back's slot is not his (the full-backs'
      // arrows live in [FullBackPushes]), so the engine ignores it.
      const engine = MatchEngine();
      for (var i = 0; i < 20; i++) {
        final plain = engine.play(
          home: _team(1),
          away: _team(2),
          rng: SeededRng.forFixture(0xFB1, i),
        );
        final stray = engine.play(
          home: _team(1, arrows: const SlotArrows({1: MoveArrow.forward})),
          away: _team(2),
          rng: SeededRng.forFixture(0xFB1, i),
        );
        expect(stray.homeScore, plain.homeScore);
        expect(stray.homeShots, plain.homeShots);
      }
    });

    test('an inside run makes him more of a scorer', () {
      final team = _team(
        1,
        arrows: const SlotArrows({8: MoveArrow.inside}),
      );
      expect(RoleTilt.arrowScorerWeight(MoveArrow.inside), greaterThan(1));
      expect(team.arrows.at(8, PlayerPosition.lw), MoveArrow.inside);
      expect(team.arrows.at(6, PlayerPosition.cm), MoveArrow.none);
    });
  });

  test('a skipped match feels the tilt too, in the same direction', () {
    final xi = _team(1).xi;
    final attacking = RoleTilt.of(
      xi: xi,
      slots: Formation.f433.positions,
      roles: [
        for (var i = 0; i < 11; i++) _attacking[i] ?? PlayerRole.none,
      ],
      arrows: const [],
    );
    final defensive = RoleTilt.of(
      xi: xi,
      slots: Formation.f433.positions,
      roles: [
        for (var i = 0; i < 11; i++) _defensive[i] ?? PlayerRole.none,
      ],
      arrows: const [],
    );
    final a = RoleTilt.skipEffect(attacking);
    final d = RoleTilt.skipEffect(defensive);
    expect(a.openness, greaterThan(1));
    expect(d.openness, lessThan(1));
    expect(a.ratingDelta.abs(), lessThan(1.5));
    expect(d.ratingDelta.abs(), lessThan(1.5));
  });
}
