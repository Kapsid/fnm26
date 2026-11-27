import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/pitch_plan.dart';

/// Each role's natural run ([PlayerRoleX.run]), the one the tactics pitch
/// draws dashed from his disc, and how a set arrow replaces it.
void main() {
  test('every role has its own natural run', () {
    const expected = <PlayerRole, RoleRun>{
      PlayerRole.none: RoleRun.none,
      PlayerRole.lineKeeper: RoleRun.hold,
      PlayerRole.sweeperKeeper: RoleRun.stepUp,
      PlayerRole.stopper: RoleRun.stepUp,
      PlayerRole.ballPlayingDefender: RoleRun.forward,
      PlayerRole.coveringDefender: RoleRun.dropDeep,
      PlayerRole.defensiveFullBack: RoleRun.hold,
      PlayerRole.wingBack: RoleRun.upTheFlank,
      PlayerRole.invertedFullBack: RoleRun.tuckInside,
      PlayerRole.anchor: RoleRun.hold,
      PlayerRole.deepPlaymaker: RoleRun.dropDeep,
      PlayerRole.ballWinner: RoleRun.stepUp,
      PlayerRole.boxToBox: RoleRun.upAndBack,
      PlayerRole.playmaker: RoleRun.roam,
      PlayerRole.shadowStriker: RoleRun.forward,
      PlayerRole.touchlineWinger: RoleRun.hugLine,
      PlayerRole.invertedWinger: RoleRun.cutInside,
      PlayerRole.defensiveWinger: RoleRun.trackBack,
      PlayerRole.targetMan: RoleRun.hold,
      PlayerRole.poacher: RoleRun.forward,
      PlayerRole.falseNine: RoleRun.dropDeep,
      PlayerRole.pressingForward: RoleRun.stepUp,
    };
    // A new role has to be given a run here too.
    expect(expected.keys.toSet(), PlayerRole.values.toSet());
    for (final r in PlayerRole.values) {
      expect(r.run, expected[r], reason: r.name);
      if (r != PlayerRole.none) {
        expect(r.run, isNot(RoleRun.none), reason: '${r.name} draws a run');
        expect(r.run.reach, greaterThan(0), reason: r.name);
      }
    }
  });

  group('the way each run goes', () {
    test('an inverted winger cuts inside, from either flank', () {
      final (lx, ly) = PlayerRole.invertedWinger.run.vector(-1);
      final (rx, ry) = PlayerRole.invertedWinger.run.vector(1);
      expect(lx, greaterThan(0.5), reason: 'left winger goes right, inside');
      expect(rx, lessThan(-0.5), reason: 'right winger goes left, inside');
      expect(ly, lessThan(-0.5));
      expect(ry, lessThan(-0.5));
    });

    test('a wing-back goes straight up his flank, further than a run', () {
      final (lx, ly) = PlayerRole.wingBack.run.vector(-1);
      final (rx, _) = PlayerRole.wingBack.run.vector(1);
      // Straight up, a touch outside: round the man ahead of him.
      expect(ly, lessThan(-0.95));
      expect(lx, inInclusiveRange(-0.3, 0));
      expect(rx, inInclusiveRange(0, 0.3));
      expect(PlayerRole.wingBack.run.reach, greaterThan(1));
    });

    test('a touchline winger stays wide, an inverted full-back tucks in', () {
      expect(PlayerRole.touchlineWinger.run.vector(-1).$1, lessThan(0));
      expect(PlayerRole.touchlineWinger.run.vector(1).$1, greaterThan(0));
      expect(PlayerRole.invertedFullBack.run.vector(-1).$1, greaterThan(0.8));
      expect(PlayerRole.invertedFullBack.run.vector(1).$1, lessThan(-0.8));
    });

    test('a box-to-box man goes up and back, a playmaker side to side', () {
      expect(PlayerRole.boxToBox.run.twoWay, isTrue);
      expect(PlayerRole.boxToBox.run.vector(0), (0, -1));
      expect(PlayerRole.playmaker.run.twoWay, isTrue);
      expect(PlayerRole.playmaker.run.vector(0), (1, 0));
    });

    test('a false 9 and a deep playmaker drop, a defensive winger tracks '
        'back', () {
      for (final r in [
        PlayerRole.falseNine,
        PlayerRole.deepPlaymaker,
        PlayerRole.coveringDefender,
        PlayerRole.defensiveWinger,
      ]) {
        expect(r.run.vector(0).$2, greaterThan(0), reason: r.name);
      }
    });

    test('the ones who stay are a short pin with no way to go', () {
      for (final r in [
        PlayerRole.anchor,
        PlayerRole.targetMan,
        PlayerRole.lineKeeper,
        PlayerRole.defensiveFullBack,
      ]) {
        expect(r.run, RoleRun.hold, reason: r.name);
        expect(r.run.vector(0), (0, 0));
        expect(r.run.reach, lessThan(0.5));
      }
    });

    test('every run that moves has a unit direction', () {
      for (final run in RoleRun.values) {
        if (run == RoleRun.none || run == RoleRun.hold) continue;
        for (final flank in [-1, 0, 1]) {
          final (x, y) = run.vector(flank);
          expect(x * x + y * y, closeTo(1, 1e-9), reason: '$run $flank');
        }
      }
    });
  });

  group('a set arrow and the role run', () {
    test('with no arrow the role run shows', () {
      expect(
        pitchRunOf(PlayerRole.invertedWinger, MoveArrow.none),
        const PitchRun.role(RoleRun.cutInside),
      );
      expect(pitchRunOf(PlayerRole.none, MoveArrow.none).isNone, isTrue);
    });

    test('a set arrow replaces it, and taking it off brings it back', () {
      var t = Tactic(
        formation: Formation.f433,
        lineup: [for (var i = 0; i < 11; i++) 100 + i],
      ).withRole(10, PlayerRole.touchlineWinger);
      PitchRun shown() => pitchRunOf(t.roleAt(10), t.arrowAt(10));
      expect(shown(), const PitchRun.role(RoleRun.hugLine));
      t = t.withArrow(10, MoveArrow.forwardInside);
      expect(shown(), const PitchRun.manual(MoveArrow.forwardInside));
      expect(shown().isManual, isTrue);
      t = t.withArrow(10, MoveArrow.none);
      expect(shown(), const PitchRun.role(RoleRun.hugLine));
    });

    test("a full-back's push replaces his role's run the same way", () {
      var t = Tactic(
        formation: Formation.f433,
        lineup: [for (var i = 0; i < 11; i++) 100 + i],
      ).withRole(1, PlayerRole.wingBack);
      PitchRun shown() => pitchRunOf(t.roleAt(1), t.arrowAt(1));
      expect(shown(), const PitchRun.role(RoleRun.upTheFlank));
      t = t.withArrow(1, MoveArrow.back);
      expect(shown(), const PitchRun.manual(MoveArrow.back));
      t = t.withArrow(1, MoveArrow.none);
      expect(shown(), const PitchRun.role(RoleRun.upTheFlank));
    });

    test('the role run never becomes an arrow the engine reads', () {
      final t = Tactic(
        formation: Formation.f433,
        lineup: [for (var i = 0; i < 11; i++) 100 + i],
      ).withRole(8, PlayerRole.invertedWinger);
      expect(t.arrowAt(8), MoveArrow.none);
      expect(t.arrows.bySlot, isEmpty);
    });
  });
}
