import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/formation_slots.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/domain/services/match/pitch/switched_layout.dart';

import '../../helpers/fixtures.dart';

const _engine = MatchEngine();

MatchTeam _team(
  int nation,
  int rating,
  Formation f,
  TacticalInstructions i, {
  SlotSwitches switches = SlotSwitches.none,
}) => MatchTeam(
  nationId: nation,
  formation: f,
  instructions: i,
  switches: switches,
  xi: [
    for (var k = 0; k < 11; k++)
      player(
        id: nation * 100 + k,
        nationId: nation,
        position: f.positions[k],
        attributes: flatAttributes(rating),
      ),
  ],
);

TacticalInstructions _dials(SeededRng r) => TacticalInstructions(
  mentality: r.rangeInt(10, 90),
  pressing: r.rangeInt(10, 90),
  tempo: r.rangeInt(10, 90),
  width: r.rangeInt(10, 90),
  defensiveLine: r.rangeInt(10, 90),
  directness: r.rangeInt(10, 90),
);

typedef _Match = ({
  MatchResult result,
  MatchLineups lineups,
  MatchTeam home,
  MatchTeam away,
  List<Substitution> subs,
  List<int> homeBench,
  List<int> awayBench,
});

/// A varied engine match: shapes, dials, strengths, subs and extra time all
/// move with [seed].
_Match _match(int seed) {
  final r = SeededRng(seed * 7919 + 13);
  const fs = Formation.values;
  final home = _team(1, r.rangeInt(62, 84), fs[seed % fs.length], _dials(r));
  final away = _team(
    2,
    r.rangeInt(62, 84),
    fs[(seed * 7 + 3) % fs.length],
    _dials(r),
  );
  final subs = <Substitution>[];
  final homeBench = <int>[];
  final awayBench = <int>[];
  for (var k = 0; k < 1 + seed % 3; k++) {
    final on = player(id: 150 + k, nationId: 1);
    homeBench.add(on.id);
    subs.add(
      Substitution(
        teamNationId: 1,
        minute: 50 + k * 12 + seed % 9,
        offId: 100 + 1 + (seed + k * 3) % 10,
        on: on,
      ),
    );
  }
  if (seed.isEven) {
    final on = player(id: 250, nationId: 2);
    awayBench.add(on.id);
    subs.add(
      Substitution(teamNationId: 2, minute: 46 + seed % 30, offId: 209, on: on),
    );
  }
  final result = _play(home, away, seed, subs: subs);
  return (
    result: result,
    lineups: matchLineupsOf(
      home: home,
      away: away,
      homeBench: homeBench,
      awayBench: awayBench,
      result: result,
    ),
    home: home,
    away: away,
    subs: subs,
    homeBench: homeBench,
    awayBench: awayBench,
  );
}

MatchResult _play(
  MatchTeam home,
  MatchTeam away,
  int seed, {
  List<Substitution> subs = const [],
  List<TacticalChange> changes = const [],
}) => _engine.play(
  home: home,
  away: away,
  rng: SeededRng.forFixture(0xF00D, seed),
  subs: subs,
  changes: changes,
  neutralVenue: true,
  bigMatch: true,
  extraTimeIfLevel: seed % 3 == 0,
);

PitchScript _script(_Match m, PitchSpeed speed, {int seed = 7}) =>
    StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, speed),
      seed: seed,
    );

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

bool _inWindow(PitchScript s, double t) =>
    s.windows.any((w) => t >= w.start && t < w.end);

/// Home share (0-100) of the time the ball is a side's, staged moments
/// included: at its man's feet, or on its way from him.
double _homeBallShare(PitchScript s) {
  var home = 0.0;
  var all = 0.0;
  for (final p in s.ballPhases) {
    final actor = switch (p) {
      CarryPhase(:final carrier) => carrier,
      FlightPhase(:final fromActor) => fromActor,
    };
    if (actor == null) continue;
    all += p.t1 - p.t0;
    if (s.actorList[actor].teamNationId == s.homeNationId) home += p.t1 - p.t0;
  }
  return 100 * home / all;
}

/// Screen seconds outside the staged windows.
double _quiet(PitchScript s) =>
    s.totalSeconds - s.windows.fold(0.0, (a, w) => a + w.end - w.start);

/// The least quiet time over which the story layer can steer the whole
/// match's ball-time split. The staged moments take 150-260 s of a match
/// and the ball in them is the moment's side's; below this much quiet time
/// there is not enough of it to even that out, however one-sided the quiet
/// spells are made.
const double _steerable = 40;

MatchResult _withPossession(MatchResult r, int possession) => MatchResult(
  homeScore: r.homeScore,
  awayScore: r.awayScore,
  events: r.events,
  homeShots: r.homeShots,
  awayShots: r.awayShots,
  homePossession: possession,
  stoppage: r.stoppage,
  momentumByMinute: r.momentumByMinute,
  homePlan: r.homePlan,
  awayPlan: r.awayPlan,
  extraTime: r.extraTime,
  moments: r.moments,
  routineRestarts: r.routineRestarts,
);

/// [nation]'s men on the pitch at [t], men walking off apart.
int _count(PitchScript s, double t, int nation) => s
    .sample(_at(t))
    .players
    .keys
    .where(
      (id) =>
          s.actorList[s.actorIndexOf(id)!].teamNationId == nation &&
          (s.departures[id] ?? double.infinity) > t,
    )
    .length;

/// How far [p] is from the nearest boundary line.
double _toBoundary(Offset2 p) => [
  p.x,
  PitchDims.length - p.x,
  p.y,
  PitchDims.width - p.y,
].reduce(math.min);

/// The last keyframe time [id] is on the pitch, from [from].
double _lastSeen(PitchScript s, int id, double from) {
  final i = s.actorIndexOf(id)!;
  var last = from;
  for (final f in s.keyframes) {
    if (f.t >= from && f.present(i)) last = f.t;
  }
  return last;
}

double _secs(Duration d) => d.inMicroseconds / 1e6;

void main() {
  test('a final carries a confetti cue at full time, no other match does', () {
    final m = _match(3);
    final plain = _script(m, PitchSpeed.values.first);
    expect(plain.confettiAt, isNull);
    final finalScript = StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, PitchSpeed.values.first),
      seed: 7,
      isFinal: true,
    );
    expect(finalScript.confettiAt, closeTo(finalScript.totalSeconds, 1e-6));
  });

  test('quiet time obeys every invariant over 50 seeded matches', () {
    var maxSpeed = 0.0;
    var minGap = double.infinity;
    var keeperMax = 0.0;
    final split = <String>[];
    var worstSplit = 0.0;
    var missSum = 0.0;
    var steered = 0;
    for (var seed = 0; seed < 50; seed++) {
      final m = _match(seed);
      final speed = PitchSpeed.values[seed % 3];
      final s = _script(m, speed, seed: seed);
      final problems = PitchScriptValidator.validate(s);
      expect(problems, isEmpty, reason: 'match $seed ($speed)');

      // The measured figures for the report.
      final frames = s.keyframes;
      for (var k = 0; k + 1 < frames.length; k++) {
        final a = frames[k];
        final b = frames[k + 1];
        final dt = b.t - a.t;
        if (dt <= 1e-9) continue;
        for (var i = 0; i < s.actorList.length; i++) {
          if (!a.present(i) || !b.present(i)) continue;
          maxSpeed = math.max(maxSpeed, a.at(i).distanceTo(b.at(i)) / dt);
          for (var j = i + 1; j < s.actorList.length; j++) {
            if (!a.present(j) || !b.present(j)) continue;
            minGap = math.min(
              minGap,
              PitchScriptValidator.closestApproach(
                a.at(i),
                b.at(i),
                a.at(j),
                b.at(j),
              ),
            );
          }
        }
        if (_inWindow(s, a.t)) continue;
        final minute = s.pacer.matchAt(_at(a.t)).minute;
        for (var i = 0; i < s.actorList.length; i++) {
          if (!a.keeper(i) || !a.present(i)) continue;
          final dir = attackDir(
            home: s.actorList[i].teamNationId == s.homeNationId,
            minute: minute,
          );
          keeperMax = math.max(keeperMax, xToDepth(a.xs[i], dir));
        }
      }
      final share = _homeBallShare(s);
      final off = (share - m.result.homePossession).abs();
      final q = _quiet(s);
      if (q >= _steerable) {
        worstSplit = math.max(worstSplit, off);
        missSum += off;
        steered++;
      }
      split.add(
        '${m.result.homePossession}->${share.toStringAsFixed(0)}'
        '(q${q.toStringAsFixed(0)})',
      );
    }
    // ignore: avoid_print
    print(
      'max player speed ${maxSpeed.toStringAsFixed(2)} m/s, '
      'min gap ${minGap.toStringAsFixed(2)} m, '
      'keeper max ${keeperMax.toStringAsFixed(1)} m, '
      'ball-time miss mean ${(missSum / steered).toStringAsFixed(1)} '
      'worst ${worstSplit.toStringAsFixed(1)} pts over $steered steerable\n'
      'possession -> home ball time: ${split.join(' ')}',
    );
    // The split follows possession wherever there is quiet time to steer
    // it; a match whose quiet time is cut into slivers between moments of
    // the same side leans toward that side (see the report).
    expect(missSum / steered, lessThanOrEqualTo(3));
    expect(worstSplit, lessThanOrEqualTo(10));
  });

  test('a red card leaves the side with 10 and the shape re-forms', () {
    _Match? found;
    MatchEvent? red;
    for (var seed = 0; seed < 400 && found == null; seed++) {
      final m = _match(seed);
      // A side's first man down, with nobody coming on after him: ten men.
      final down = <int>{};
      for (final e in m.result.events) {
        final team = e.teamNationId;
        if (e.type == MatchEventType.substitution) down.add(team);
        if (e.type == MatchEventType.injury) down.add(team);
        if (e.type == MatchEventType.redCard &&
            e.minute < 80 &&
            !down.contains(team) &&
            !m.result.events.any(
              (x) =>
                  x.teamNationId == team &&
                  x != e &&
                  x.minute >= e.minute &&
                  (x.type != MatchEventType.goal &&
                      x.type != MatchEventType.yellowCard),
            )) {
          found = m;
          red = e;
          break;
        }
        if (e.type == MatchEventType.redCard) down.add(team);
      }
    }
    expect(found, isNotNull, reason: 'no red card in 400 matches');
    final s = _script(found!, PitchSpeed.mid);
    expect(PitchScriptValidator.validate(s), isEmpty);
    final id = red!.playerId;
    final start = s.departures[id]!;
    expect(
      start,
      greaterThanOrEqualTo(_secs(s.pacer.screenAt(red.minute, red.stoppage))),
    );
    // He walks to the nearest boundary at a walk and leaves the picture
    // there, however long that takes.
    // (An interval that comes first takes him off with it.)
    final lastSeen = _lastSeen(s, id, start);
    if (!s.resets.contains(lastSeen)) {
      final p = s.sample(_at(lastSeen - 1e-5)).players[id]!;
      expect(_toBoundary(p), lessThanOrEqualTo(1));
      final from = s.sample(_at(start)).players[id]!;
      final walked = _toBoundary(from) - 1;
      expect(
        lastSeen - start,
        greaterThanOrEqualTo(walked / PitchScriptValidator.maxWalkSpeed - 0.5),
      );
    }
    expect(s.sample(_at(lastSeen + 0.3)).players.containsKey(id), isFalse);
    // Ten men from the moment he starts to go.
    final side = red.teamNationId;
    for (var t = start + 0.05; t < s.totalSeconds; t += 0.5) {
      expect(_count(s, t, side), lessThanOrEqualTo(10), reason: 't $t');
    }
    expect(_count(s, start + 0.05, side), 10);
    expect(_count(s, start - 0.05, side), 11);

    // The shape re-forms: a back four that loses a centre-half still covers
    // both flanks with the three left.
    final l = layoutOf(Formation.f442);
    final re = reformedSlots(l, 0, {0, 1, 3, 4, 5, 6, 7, 8, 9, 10});
    expect([re[1].$1, re[3].$1, re[4].$1], [0.12, 0.5, 0.88]);
    // ...and a lone striker left of two holds the middle.
    final re2 = reformedSlots(l, 0, {for (var i = 0; i < 10; i++) i});
    expect(re2[9].$1, 0.5);
  });

  test('a sub swaps the right player', () {
    final m = _match(4);
    final sub = m.result.events.firstWhere(
      (e) => e.type == MatchEventType.substitution && e.teamNationId == 1,
    );
    final offId = sub.secondaryPlayerId!;
    final onId = sub.playerId;
    final s = _script(m, PitchSpeed.slow);
    expect(PitchScriptValidator.validate(s), isEmpty);
    final leave = s.departures[offId]!;
    final enter = s.arrivals[onId]!;
    expect(leave, greaterThanOrEqualTo(_secs(s.pacer.screenAt(sub.minute, 0))));
    // He steps on as the man he replaces starts to walk off, without
    // waiting for him to reach the line.
    expect(enter, closeTo(leave, 1e-9));
    final before = s.sample(_at(leave - 0.1));
    expect(before.players.containsKey(offId), isTrue);
    expect(before.players.containsKey(onId), isFalse);
    final later = s.sample(_at(enter + 0.3));
    expect(later.players.containsKey(onId), isTrue);
    expect(_count(s, enter + 0.3, 1), 11);
    final gone = _lastSeen(s, offId, leave);
    expect(s.sample(_at(gone + 0.3)).players.containsKey(offId), isFalse);
    // On from the halfway line, benches' side.
    final first = later.players[onId]!;
    expect((first.x - PitchDims.length / 2).abs(), lessThan(6));
    expect(first.y, greaterThan(PitchDims.width - 4));
    // He wears a bench shirt and is no keeper.
    final actor = s.actorList[s.actorIndexOf(onId)!];
    expect(actor.shirt, greaterThanOrEqualTo(12));
    expect(actor.keeper, isFalse);
  });

  test('subs at half-time come and go in the interval', () {
    // Seed 0: the away side's planned change is at 46'.
    final m = _match(0);
    final sub = m.result.events.firstWhere(
      (e) => e.type == MatchEventType.substitution && e.teamNationId == 2,
    );
    expect(sub.minute, 46);
    final s = _script(m, PitchSpeed.mid);
    expect(PitchScriptValidator.validate(s), isEmpty);
    final interval = s.resets.first;
    expect(s.departures[sub.secondaryPlayerId], interval);
    expect(s.arrivals[sub.playerId], interval);
    final before = s.sample(_at(interval - 0.01)).players;
    final after = s.sample(_at(interval)).players;
    expect(before.containsKey(sub.secondaryPlayerId), isTrue);
    expect(before.containsKey(sub.playerId), isFalse);
    expect(after.containsKey(sub.secondaryPlayerId), isFalse);
    expect(after.containsKey(sub.playerId), isTrue);
  });

  test('an injury replaced a minute later at fast speed still comes on', () {
    final home = _team(1, 75, Formation.f442, const TacticalInstructions());
    final away = _team(2, 75, Formation.f433, const TacticalInstructions());
    final newcomer = player(id: 150, nationId: 1);
    var checked = 0;
    for (var seed = 0; seed < 300 && checked < 3; seed++) {
      final r0 = _play(home, away, seed);
      final injury = r0.events
          .where(
            (e) =>
                e.type == MatchEventType.injury &&
                e.teamNationId == 1 &&
                e.minute > 5 &&
                e.minute < 80 &&
                e.stoppage == 0,
          )
          .firstOrNull;
      if (injury == null) continue;
      final earlier = r0.events.any(
        (e) =>
            e.teamNationId == 1 &&
            e.minute <= injury.minute &&
            e != injury &&
            (e.type == MatchEventType.injury ||
                e.type == MatchEventType.redCard),
      );
      if (earlier) continue;
      final slot = home.xi.indexWhere((p) => p.id == injury.playerId);
      final change = TacticalChange(
        teamNationId: 1,
        minute: injury.minute + 1,
        formation: Formation.f442,
        instructions: const TacticalInstructions(),
        xi: [
          for (var k = 0; k < 11; k++) k == slot ? newcomer : home.xi[k],
        ],
      );
      final r = _play(home, away, seed, changes: [change]);
      final on = r.events.where(
        (e) => e.type == MatchEventType.substitution && e.playerId == 150,
      );
      if (on.isEmpty) continue;
      checked++;
      final lineups = matchLineupsOf(
        home: home,
        away: away,
        homeBench: const [150],
        result: r,
        changes: [change],
      );
      final s = StoryLayer.build(
        result: r,
        lineups: lineups,
        pacer: PitchPacer(r, PitchSpeed.fast),
        seed: seed,
      );
      expect(PitchScriptValidator.validate(s), isEmpty, reason: 'seed $seed');
      final enter = s.arrivals[150];
      expect(enter, isNotNull, reason: 'seed $seed: the newcomer never came');
      expect(
        s.sample(_at(enter! + 0.3)).players.containsKey(150),
        isTrue,
        reason: 'seed $seed',
      );
      // Back to eleven once he is on (unless somebody else has gone).
      final down = r.events.any(
        (e) =>
            e.teamNationId == 1 &&
            e.minute > injury.minute + 1 &&
            (e.type == MatchEventType.injury ||
                e.type == MatchEventType.redCard),
      );
      if (!down) expect(_count(s, enter + 0.3, 1), 11, reason: 'seed $seed');
    }
    expect(checked, 3, reason: 'too few injuries to test');
  });

  test('a formation change at 60\' redraws the shape from 60\'', () {
    final home = _team(1, 75, Formation.f532, const TacticalInstructions());
    final away = _team(2, 75, Formation.f433, const TacticalInstructions());
    final change = TacticalChange(
      teamNationId: 1,
      minute: 60,
      formation: Formation.f343,
      instructions: const TacticalInstructions(),
      xi: home.xi,
    );
    // Over three matches, so one match's run of play cannot hide it.
    var gain = 0.0;
    final seen = <String>[];
    for (var seed = 1; seed <= 3; seed++) {
      final r = _play(home, away, seed, changes: [change]);
      final lineups = matchLineupsOf(
        home: home,
        away: away,
        result: r,
        changes: [change],
      );
      // The story layer's own shape, every moment held still.
      final s = StoryLayer.build(
        result: r,
        lineups: lineups,
        pacer: PitchPacer(r, PitchSpeed.slow),
        seed: seed,
        stager: const NeutralHold(),
      );
      expect(PitchScriptValidator.validate(s), isEmpty);
      // Two men whose jobs the change moves up the pitch: 104 from centre-half
      // to left midfield, 108 from central midfield to the left wing. Their
      // depth over the side's average, over a quarter of an hour.
      double pushedUp(double from, double to) {
        var sum = 0.0;
        var n = 0;
        for (var t = from; t < to; t += 0.5) {
          if (_inWindow(s, t)) continue;
          final f = s.sample(_at(t));
          final minute = s.pacer.matchAt(_at(t)).minute;
          final dir = attackDir(home: true, minute: minute);
          double depth(int id) => xToDepth(f.players[id]!.x, dir);
          final outfield = [
            for (final id in f.players.keys)
              if (id < 200 && !f.keepers.contains(id)) depth(id),
          ];
          final mean = outfield.reduce((a, b) => a + b) / outfield.length;
          sum += (depth(104) + depth(108)) / 2 - mean;
          n++;
        }
        return sum / n;
      }

      final change60 = _secs(s.pacer.screenAt(60, 0));
      final before = pushedUp(_secs(s.pacer.screenAt(45, 0)), change60);
      final after = pushedUp(
        change60 + 6,
        _secs(s.pacer.screenAt(75, 0)),
      );
      gain += after - before;
      seen.add('${before.toStringAsFixed(1)} -> ${after.toStringAsFixed(1)}');
    }
    // A single match showed +6.3 here on the code before Task 14b, but the
    // same code averages +5.7 over these three (+6.3, +6.8, +4.1): one
    // match's run of play moves it a metre either way.
    expect(gain / 3, greaterThan(5), reason: seen.join(', '));
  });

  test('a keeper sent off leaves the nearest man in goal', () {
    final home = _team(1, 75, Formation.f442, const TacticalInstructions());
    final away = _team(2, 75, Formation.f433, const TacticalInstructions());
    const r = MatchResult(
      homeScore: 0,
      awayScore: 0,
      events: [
        MatchEvent(
          minute: 30,
          type: MatchEventType.redCard,
          teamNationId: 1,
          playerId: 100,
          playerName: 'Keeper',
        ),
      ],
      homeShots: 0,
      awayShots: 0,
      homePossession: 50,
    );
    final s = StoryLayer.build(
      result: r,
      lineups: matchLineupsOf(home: home, away: away),
      pacer: PitchPacer(r, PitchSpeed.mid),
      seed: 3,
    );
    expect(PitchScriptValidator.validate(s), isEmpty);
    final start = s.departures[100]!;
    expect(s.keepersAt(start - 0.1), contains(100));
    final later = s.sample(_at(start + 30));
    final home1 = later.keepers.where(
      (id) => s.actorList[s.actorIndexOf(id)!].teamNationId == 1,
    );
    expect(home1, hasLength(1));
    expect(home1.single, isNot(100));
    expect(later.players.containsKey(100), isFalse);
    // He keeps goal from his own line, not where he used to play.
    final minute = s.pacer.matchAt(_at(start + 30)).minute;
    final depth = xToDepth(
      later.players[home1.single]!.x,
      attackDir(home: true, minute: minute),
    );
    expect(depth, lessThan(25));
  });

  test('a keeper brought on takes over from the man minding goal', () {
    final home = _team(1, 75, Formation.f442, const TacticalInstructions());
    final away = _team(2, 75, Formation.f433, const TacticalInstructions());
    final backup = player(id: 150, nationId: 1, position: PlayerPosition.gk);
    final change = TacticalChange(
      teamNationId: 1,
      minute: 21,
      formation: Formation.f442,
      instructions: const TacticalInstructions(),
      xi: [backup, ...home.xi.skip(1)],
    );
    const r = MatchResult(
      homeScore: 0,
      awayScore: 0,
      events: [
        MatchEvent(
          minute: 20,
          type: MatchEventType.injury,
          teamNationId: 1,
          playerId: 100,
          playerName: 'Keeper',
        ),
        MatchEvent(
          minute: 21,
          type: MatchEventType.substitution,
          teamNationId: 1,
          playerId: 150,
          playerName: 'Backup',
        ),
      ],
      homeShots: 0,
      awayShots: 0,
      homePossession: 50,
    );
    final s = StoryLayer.build(
      result: r,
      lineups: matchLineupsOf(
        home: home,
        away: away,
        homeBench: const [150],
        changes: [change],
      ),
      pacer: PitchPacer(r, PitchSpeed.mid),
      seed: 4,
    );
    expect(PitchScriptValidator.validate(s), isEmpty);
    Set<int> homeKeepers(double t) => {
      for (final id in s.keepersAt(t))
        if (s.actorList[s.actorIndexOf(id)!].teamNationId == 1) id,
    };
    final injured = s.departures[100]!;
    final standIn = homeKeepers(injured + 1);
    expect(standIn, hasLength(1));
    expect(standIn.single, isNot(anyOf(100, 150)));
    final on = s.arrivals[150]!;
    // The stand-in minds goal until the keeper reaches his area.
    expect(homeKeepers(on + 0.3), standIn);
    double? takeover;
    for (final f in s.keyframes) {
      if (f.t > on && s.keepersAt(f.t).contains(150)) {
        takeover = f.t;
        break;
      }
    }
    expect(takeover, isNotNull, reason: 'the keeper never took over');
    final minute = s.pacer.matchAt(_at(takeover!)).minute;
    final at = s.sample(_at(takeover)).players[150]!;
    expect(
      xToDepth(at.x, attackDir(home: true, minute: minute)),
      lessThanOrEqualTo(16.5 + 1e-6),
    );
    expect(s.actorList[s.actorIndexOf(150)!].keeper, isTrue);
    // The stand-in is an outfielder again.
    expect(
      s.sample(_at(takeover + 0.3)).keepers,
      isNot(contains(standIn.single)),
    );
  });

  test('the same seed gives the same frames', () {
    final m = _match(11);
    final a = _script(m, PitchSpeed.mid, seed: 99);
    final b = _script(m, PitchSpeed.mid, seed: 99);
    final c = _script(m, PitchSpeed.mid, seed: 100);
    var differs = false;
    for (var t = 0.0; t < a.totalSeconds; t += 0.37) {
      final d = _at(t);
      final fa = a.sample(d);
      final fb = b.sample(d);
      expect(fb.players, fa.players);
      expect(fb.ball, fa.ball);
      expect(fb.ballHeight, fa.ballHeight);
      expect(fb.ballCarrierId, fa.ballCarrierId);
      expect(fb.camera, fa.camera);
      if (c.sample(d).ball != fa.ball) differs = true;
    }
    expect(differs, isTrue, reason: 'another seed tells another story');
  });

  test('possession 60% gives the home side about 60% of ball time (±7)', () {
    var checked = 0;
    for (var seed = 0; seed < 12; seed++) {
      final m = _match(seed);
      final r = _withPossession(m.result, 60);
      final s = StoryLayer.build(
        result: r,
        lineups: m.lineups,
        pacer: PitchPacer(r, PitchSpeed.values[seed % 3]),
        seed: seed,
      );
      if (_quiet(s) < _steerable) continue;
      checked++;
      expect(_homeBallShare(s), closeTo(60, 7), reason: 'match $seed');
    }
    expect(checked, greaterThanOrEqualTo(6));
  });

  test('a re-simulation resumes from the playhead with no jump', () {
    final m = _match(5);
    final first = _script(m, PitchSpeed.mid, seed: 5);
    final playhead = first.pacer.screenAt(60, 0, within: 0.4);
    final state = first.stateAt(playhead);
    // The manager makes a change at 61': the engine plays the match again.
    final subs = [
      ...m.subs,
      Substitution(
        teamNationId: 1,
        minute: 61,
        offId: 110,
        on: player(id: 160, nationId: 1),
      ),
    ];
    final r2 = _play(m.home, m.away, 5, subs: subs);
    final lineups = matchLineupsOf(
      home: m.home,
      away: m.away,
      homeBench: [...m.homeBench, 160],
      awayBench: m.awayBench,
      result: r2,
    );
    final pacer2 = PitchPacer(r2, PitchSpeed.mid);
    final second = StoryLayer.build(
      result: r2,
      lineups: lineups,
      pacer: pacer2,
      seed: 5,
      resumeFrom: state,
    );
    expect(
      second.start,
      closeTo(_secs(pacer2.screenAt(60, 0, within: 0.4)), 1e-6),
    );
    final seam = second.sample(_at(second.start));
    expect(seam.players.keys.toSet(), state.players.keys.toSet());
    for (final e in state.players.entries) {
      expect(seam.players[e.key]!.distanceTo(e.value), lessThan(1e-6));
    }
    expect(seam.ball.distanceTo(state.ball), lessThan(1e-6));
    expect(seam.ballCarrierId, state.carrierId);
    // Every speed and spacing rule holds across the seam and after it.
    expect(PitchScriptValidator.validate(second), isEmpty);
    expect(second.arrivals.containsKey(160), isTrue);
  });

  test('extra time swaps ends again after 105\'', () {
    expect(attackDir(home: true, minute: 100), 1);
    expect(attackDir(home: true, minute: 106), -1);
    for (var seed = 0; seed < 60; seed += 3) {
      final m = _match(seed);
      if (m.result.extraTime == null) continue;
      final s = _script(m, PitchSpeed.mid);
      expect(s.resets, hasLength(3));
      expect(s.resets.last, _secs(s.pacer.screenAt(106, 0)));
      expect(PitchScriptValidator.validate(s), isEmpty);
      return;
    }
    fail('no extra time in 20 matches');
  });

  test('slot switches draw where the tactics board draws them', () {
    const sw = SlotSwitches({5: PlayerPosition.cm});
    final team = _team(
      1,
      70,
      Formation.f433,
      const TacticalInstructions(),
      switches: sw,
    );
    expect(teamSideOf(team).switches, sw);
    final drawn = slotLayout(Formation.f433, sw, const TacticalInstructions());
    final board = switchedLayoutOf(Formation.f433, sw);
    for (var i = 0; i < 11; i++) {
      expect(drawn[i].$1, board[i].$1);
    }
    expect(drawn[5].$2, isNot(layoutOf(Formation.f433)[5].$2));
  });

  test('line-ups deal shirts: keeper 1, the XI by slot, the bench on', () {
    final home = _team(1, 70, Formation.f433, const TacticalInstructions());
    final away = _team(2, 70, Formation.f352, const TacticalInstructions());
    final l = matchLineupsOf(home: home, away: away, homeBench: [150, 151]);
    expect(l.home.xi.map((p) => p.shirt), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
    expect(l.away.formation, Formation.f352);
    expect(l.home.xi.first.playerId, 100);
    expect(l.home.bench, [150, 151]);
    expect(l.home.plan.formation, Formation.f433);
  });

  test('a live change maps each man to his formation slot', () {
    final home = _team(1, 70, Formation.f442, const TacticalInstructions());
    final c = lineupChangeOf(
      TacticalChange(
        teamNationId: 1,
        minute: 50,
        formation: Formation.f442,
        instructions: const TacticalInstructions(),
        xi: [home.xi[0], home.xi[2], home.xi[1]],
        slots: const [PlayerPosition.gk, PlayerPosition.lb, PlayerPosition.cb],
      ),
    );
    expect(c.xi, [100, 102, 101]);
    expect(c.slotOf, [0, 1, 2]);
  });

  test('every staged window hands over a carried ball', () {
    // The placeholder stager's promise; the real ones may leave the ball
    // lying for the next moment (a foul's free kick).
    final m = _match(3);
    final s = StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, PitchSpeed.fast),
      seed: 7,
      stager: const NeutralHold(),
    );
    expect(s.windows, isNotEmpty);
    for (final w in s.windows) {
      expect(w.end, greaterThan(w.start));
      expect(w.entry.carrierId, isNotNull, reason: 'window at ${w.start}');
      expect(w.exit.players.length, lessThanOrEqualTo(22));
    }
  });

  test('the validator names what it catches', () {
    const r = MatchResult(
      homeScore: 0,
      awayScore: 0,
      events: [],
      homeShots: 0,
      awayShots: 0,
      homePossession: 50,
    );
    final pacer = PitchPacer(r, PitchSpeed.mid);
    final total = pacer.total.inMicroseconds / 1e6;
    ScriptKeyframe frame(double t, List<(double, double)> at) => ScriptKeyframe(
      t: t,
      xs: Float64List.fromList([for (final p in at) p.$1]),
      ys: Float64List.fromList([for (final p in at) p.$2]),
      facing: Float64List(at.length),
      keepers: Uint8List.fromList([0, 0, 1]),
      cameraX: 52.5,
      zoom: 1,
    );
    final s = PitchScript(
      actorList: const [
        (playerId: 812, teamNationId: 1, shirt: 7, keeper: false),
        (playerId: 813, teamNationId: 1, shirt: 8, keeper: false),
        (playerId: 900, teamNationId: 2, shirt: 1, keeper: true),
      ],
      keyframes: [
        // The away keeper defends x 105 in the first half: x 85 is 20 m out,
        // x 79 is 26 m out.
        frame(0, [(40, 30), (50, 30.3), (85, 34)]),
        frame(1, [(54.2, 30), (50, 30.3), (79, 34)]),
        frame(total, [(54.2, 30), (50, 30.3), (79, 34)]),
      ],
      ballPhases: [CarryPhase(0, total, 1)],
      resets: const [],
      windows: const [],
      departures: const {},
      arrivals: const {},
      pacer: pacer,
      result: r,
      homeNationId: 1,
    );
    final found = PitchScriptValidator.validate(s);
    expect(found, contains('minute 1: player 812 moved 14.2 m/s'));
    expect(found.any((f) => f.contains('players 812 and 813')), isTrue);
    expect(found.any((f) => f.contains('keeper 900 26.0 m')), isTrue);
  });

  test('resuming mid walk-off keeps him heading for the nearest boundary', () {
    _Match? m;
    MatchEvent? injury;
    for (var seed = 0; seed < 200 && m == null; seed++) {
      final c = _match(seed);
      final e = c.result.events
          .where((e) => e.type == MatchEventType.injury && e.minute < 80)
          .firstOrNull;
      if (e != null) {
        m = c;
        injury = e;
      }
    }
    expect(m, isNotNull);
    final first = _script(m!, PitchSpeed.mid);
    final start = first.departures[injury!.playerId]!;
    final state = first.stateAt(_at(start + 1));
    expect(state.walking, contains(injury.playerId));
    final second = StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, PitchSpeed.mid),
      seed: 7,
      resumeFrom: state,
    );
    expect(PitchScriptValidator.validate(second), isEmpty);
    // Closer to the boundary every second until he is off.
    var last = _toBoundary(state.players[injury.playerId]!);
    final gone = _lastSeen(second, injury.playerId, second.start);
    expect(gone, greaterThan(second.start));
    for (var t = second.start + 1; t < gone; t += 1) {
      final now = _toBoundary(
        second.sample(_at(t)).players[injury.playerId]!,
      );
      expect(now, lessThan(last), reason: 't $t');
      last = now;
    }
    expect(
      _toBoundary(second.sample(_at(gone - 1e-5)).players[injury.playerId]!),
      lessThanOrEqualTo(1),
    );
  });

  test('a substitute named in a moment soon after is on the pitch for it', () {
    var found = 0;
    for (var seed = 0; seed < 400 && found < 2; seed++) {
      final m = _match(seed);
      for (final e in m.result.events) {
        if (e.type != MatchEventType.substitution) continue;
        final soon = m.result.moments.where((x) {
          if (x.minute < e.minute || x.minute > e.minute + 2) return false;
          final ids = switch (x) {
            ShotMoment(:final shooterId) => [shooterId],
            SetPieceMoment(:final takerId) => [takerId],
            FoulMoment(:final foulerId, :final fouledId) => [
              foulerId,
              fouledId,
            ],
            _ => const <int>[],
          };
          return ids.contains(e.playerId);
        });
        if (soon.isEmpty) continue;
        final s = _script(m, PitchSpeed.values[seed % 3], seed: seed);
        expect(PitchScriptValidator.validate(s), isEmpty, reason: '$seed');
        for (final w in s.windows) {
          if (!w.moments.any(soon.contains)) continue;
          expect(
            s.sample(_at(w.start)).players.containsKey(e.playerId),
            isTrue,
            reason: 'seed $seed',
          );
        }
        found++;
        break;
      }
    }
    expect(found, 2, reason: 'too few subs in moments to test');
  });

  test('a man sent in goal heads home through the next moment', () {
    final home = _team(1, 75, Formation.f442, const TacticalInstructions());
    final away = _team(2, 75, Formation.f433, const TacticalInstructions());
    const r = MatchResult(
      homeScore: 0,
      awayScore: 0,
      events: [
        MatchEvent(
          minute: 30,
          type: MatchEventType.redCard,
          teamNationId: 1,
          playerId: 100,
          playerName: 'Keeper',
        ),
        MatchEvent(
          minute: 31,
          type: MatchEventType.yellowCard,
          teamNationId: 2,
          playerId: 205,
          playerName: 'Five',
        ),
      ],
      homeShots: 0,
      awayShots: 0,
      homePossession: 50,
      moments: [
        FoulMoment(
          minute: 30,
          stoppage: 0,
          seq: 0,
          teamNationId: 2,
          foulerId: 100,
          fouledId: 209,
          zone: PitchZone.boxCentre,
          cardEventIndex: 0,
        ),
        FoulMoment(
          minute: 31,
          stoppage: 0,
          seq: 0,
          teamNationId: 1,
          foulerId: 205,
          fouledId: 106,
          zone: PitchZone.midfield,
          cardEventIndex: 1,
        ),
      ],
    );
    final s = StoryLayer.build(
      result: r,
      lineups: matchLineupsOf(home: home, away: away),
      pacer: PitchPacer(r, PitchSpeed.fast),
      seed: 8,
    );
    expect(PitchScriptValidator.validate(s), isEmpty);
    final during = s.windows.last.end - 0.01;
    expect(s.keepersAt(during).contains(100), isFalse);
    expect(s.keepersAt(during).where((id) => id < 200), hasLength(1));
  });

  test('a keeper stepping on at halfway heads for goal through a moment', () {
    final home = _team(1, 75, Formation.f442, const TacticalInstructions());
    final away = _team(2, 75, Formation.f433, const TacticalInstructions());
    final backup = player(id: 150, nationId: 1, position: PlayerPosition.gk);
    const r = MatchResult(
      homeScore: 0,
      awayScore: 0,
      events: [
        MatchEvent(
          minute: 20,
          type: MatchEventType.substitution,
          teamNationId: 1,
          playerId: 150,
          playerName: 'Backup',
          secondaryPlayerId: 100,
          secondaryName: 'Keeper',
        ),
        MatchEvent(
          minute: 21,
          type: MatchEventType.yellowCard,
          teamNationId: 2,
          playerId: 205,
          playerName: 'Five',
        ),
      ],
      homeShots: 0,
      awayShots: 0,
      homePossession: 50,
      moments: [
        FoulMoment(
          minute: 21,
          stoppage: 0,
          seq: 0,
          teamNationId: 1,
          foulerId: 205,
          fouledId: 106,
          zone: PitchZone.midfield,
          cardEventIndex: 1,
        ),
      ],
    );
    final s = StoryLayer.build(
      result: r,
      lineups: matchLineupsOf(
        home: home,
        away: away,
        homeBench: [backup.id],
      ),
      pacer: PitchPacer(r, PitchSpeed.fast),
      seed: 9,
    );
    expect(PitchScriptValidator.validate(s), isEmpty);
    expect(s.arrivals[150], isNotNull);
    expect(s.actorList[s.actorIndexOf(150)!].keeper, isTrue);
  });

  test('with little quiet time the quiet spells lean to the side owed', () {
    var checked = 0;
    var owedTotal = 0.0;
    var quietTotal = 0.0;
    for (var seed = 0; seed < 50; seed++) {
      final m = _match(seed);
      // The story layer's quiet spells, the moments held still.
      final s = StoryLayer.build(
        result: m.result,
        lineups: m.lineups,
        pacer: PitchPacer(m.result, PitchSpeed.values[seed % 3]),
        seed: seed,
        stager: const NeutralHold(),
      );
      if (_quiet(s) >= _steerable) continue;
      checked++;
      // Walk the match in order: at each instant of quiet time, is the ball
      // with the side that is owed ball time so far?
      final share = m.result.homePossession / 100;
      var home = 0.0;
      var away = 0.0;
      var owed = 0.0;
      var quiet = 0.0;
      const dt = 0.05;
      for (final p in s.ballPhases) {
        final actor = switch (p) {
          CarryPhase(:final carrier) => carrier,
          FlightPhase(:final fromActor) => fromActor,
        };
        if (actor == null) continue;
        final isHome = s.actorList[actor].teamNationId == s.homeNationId;
        for (var t = p.t0; t < p.t1; t += dt) {
          final step = math.min(dt, p.t1 - t);
          final homeOwed = share * (home + away) - home;
          if (!_inWindow(s, t) && homeOwed.abs() > 0.5) {
            quiet += step;
            if (isHome == homeOwed > 0) owed += step;
          }
          if (isHome) {
            home += step;
          } else {
            away += step;
          }
        }
      }
      expect(
        owed / quiet,
        greaterThanOrEqualTo(0.5),
        reason:
            'match $seed: owed side on the ball '
            '${(100 * owed / quiet).toStringAsFixed(0)}% of quiet time',
      );
      owedTotal += owed;
      quietTotal += quiet;
    }
    // ignore: avoid_print
    print(
      'below the gate: owed side on the ball '
      '${(100 * owedTotal / quietTotal).toStringAsFixed(0)}% of quiet time '
      'over $checked matches',
    );
    expect(checked, greaterThanOrEqualTo(5));
  });

  test('a staging context says how much ball time each side is owed', () {
    final m = _match(6);
    StagingContext? seen;
    StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, PitchSpeed.mid),
      seed: 6,
      stager: _Spy((c) => seen ??= c.entry.t > 60 ? c : null),
    );
    final c = seen!;
    expect(
      c.owedTo(1) + c.owedTo(2),
      closeTo(0, 1e-9),
      reason: 'what one side is owed the other has had',
    );
    final played = c.entry.homeBallTime + c.entry.awayBallTime;
    expect(
      c.owedTo(1),
      closeTo(
        m.result.homePossession / 100 * played - c.entry.homeBallTime,
        1e-9,
      ),
    );
  });
}

class _Spy implements MomentStager {
  _Spy(this.onStage);
  final void Function(StagingContext) onStage;

  @override
  StagedPlan stage(StagingContext context) {
    onStage(context);
    return const NeutralHold().stage(context);
  }
}
