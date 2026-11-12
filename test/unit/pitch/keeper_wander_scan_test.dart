/// The keeper-wander scan: seeded matches run through the Pitch view's
/// staging (no UI), every keeper's position sampled over the whole picture,
/// and a frame flagged wherever a keeper stands further than 35% of the
/// pitch's length from his own goal line.
///
/// "A keeper" is whoever holds a side's keeper slot (the man in the keeper's
/// shirt) and every goalkeeper by trade while he is on the pitch, with no
/// exemptions: a substitute keeper steps on level with his own area, and
/// there is no keeper going up for a late corner in the picture. (The
/// shoot-out is staged on its own, see `shootout_staging_test.dart`.)
///
/// The matches cover what a keeper's day can bring: plain matches, a keeper
/// substituted for a keeper, live changes of shape (with and without named
/// places), extra time, and scripts resumed from mid-match at a new speed,
/// as the match screen does after every change.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pitch_match_lab.dart';

/// How far from his own goal line a keeper may stand: 35% of the length.
const double _reach = 0.35 * PitchDims.length;

const double _sampleEvery = 0.1;

const int _seeds = 120;

/// The substitute keeper's id in a keeper-for-keeper match.
const int _subKeeper = 160;

typedef _Case = ({
  MatchResult result,
  MatchLineups lineups,
  Set<int> goalkeepers,
  String label,
});

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

int _gkSlot(Formation f) => f.positions.indexOf(PlayerPosition.gk);

/// Match [seed] of the scan: plain, a keeper substituted for a keeper, or a
/// live change of shape (seed % 4: 0, 1, 2 and 3, the last naming places).
_Case _case(int seed) {
  final r = SeededRng(seed * 31 + 5);
  const fs = Formation.values;
  final hf = fs[seed % fs.length];
  final af = fs[(seed * 7 + 3) % fs.length];
  final home = labTeam(1, r.rangeInt(62, 84), hf, labDials(r));
  final away = labTeam(2, r.rangeInt(62, 84), af, labDials(r));
  final goalkeepers = {home.xi[_gkSlot(hf)].id, away.xi[_gkSlot(af)].id};
  final subs = <Substitution>[];
  final changes = <TacticalChange>[];
  final homeBench = <int>[];
  var label = 'plain';
  switch (seed % 4) {
    case 1:
      final on = player(
        id: _subKeeper,
        nationId: 1,
        position: PlayerPosition.gk,
      );
      goalkeepers.add(on.id);
      homeBench.add(on.id);
      subs.add(
        Substitution(
          teamNationId: 1,
          minute: 40 + seed % 40,
          offId: home.xi[_gkSlot(hf)].id,
          on: on,
        ),
      );
      label = 'keeper for keeper';
    case 2 || 3:
      final to = fs[(seed * 3 + 1) % fs.length];
      final keeper = home.xi[_gkSlot(hf)];
      final outfield = [
        for (var k = 0; k < 11; k++)
          if (k != _gkSlot(hf)) home.xi[k],
      ];
      var o = 0;
      final xi = <Player>[
        for (final p in to.positions)
          if (p == PlayerPosition.gk) keeper else outfield[o++],
      ];
      changes.add(
        TacticalChange(
          teamNationId: 1,
          minute: 30 + seed % 50,
          formation: to,
          instructions: labDials(r),
          xi: xi,
          slots: seed % 4 == 3 ? to.positions : null,
        ),
      );
      label = 'live change ${hf.name} -> ${to.name}';
  }
  final result = labEngine.play(
    home: home,
    away: away,
    rng: SeededRng.forFixture(0xC0DE, seed),
    subs: subs,
    changes: changes,
    neutralVenue: seed.isEven,
    bigMatch: true,
    extraTimeIfLevel: seed % 3 == 0,
  );
  return (
    result: result,
    lineups: matchLineupsOf(
      home: home,
      away: away,
      homeBench: homeBench,
      result: result,
      changes: changes,
    ),
    goalkeepers: goalkeepers,
    label: 'seed $seed, $label',
  );
}

PitchScript _build(_Case c, PitchSpeed speed, int seed, [ScriptState? from]) =>
    StoryLayer.build(
      result: c.result,
      lineups: c.lineups,
      pacer: PitchPacer(c.result, speed),
      seed: seed,
      resumeFrom: from,
    );

/// The scripts the scan reads for [seed]: the match told from kick-off, and
/// twice resumed from it at another speed.
List<(PitchScript, String)> _scripts(_Case c, int seed) {
  final s0 = _build(c, PitchSpeed.values[seed % 3], seed);
  return [
    (s0, c.label),
    for (var r = 1; r <= 2; r++)
      (
        _build(
          c,
          PitchSpeed.values[(seed + r) % 3],
          seed,
          s0.stateAt(_at(s0.totalSeconds * (0.2 + 0.35 * r))),
        ),
        '${c.label}, resumed ${20 + 35 * r}% in',
      ),
  ];
}

/// Every keeper frame in [s], and the ones beyond [_reach].
({int frames, List<String> wanders}) _scan(
  PitchScript s,
  Set<int> goalkeepers,
  String label,
) {
  var frames = 0;
  final wanders = <String>[];
  for (var t = s.start; t < s.totalSeconds; t += _sampleEvery) {
    final f = s.sample(_at(t));
    final minute = s.pacer.matchAt(_at(t)).minute;
    for (final id in {...f.keepers, ...goalkeepers}) {
      final pos = f.players[id];
      final off = s.departures[id];
      if (pos == null || (off != null && off <= t)) continue;
      frames++;
      final team = s.actorList[s.actorIndexOf(id)!].teamNationId;
      final dir = attackDir(home: team == s.homeNationId, minute: minute);
      final depth = xToDepth(pos.x, dir);
      if (depth <= _reach) continue;
      final w = s.windowAt(t);
      final what = w == null
          ? 'open play'
          : w.injury != null
          ? 'an injury'
          : w.moments.map((m) => m.runtimeType).join(' + ');
      wanders.add(
        '$label, ${s.minuteLabel(t)} (t ${t.toStringAsFixed(1)}): '
        '${f.keepers.contains(id) ? 'keeper' : 'goalkeeper out of goal'} '
        '$id ${depth.toStringAsFixed(1)} m out, in $what',
      );
    }
  }
  return (frames: frames, wanders: wanders);
}

void main() {
  test('no keeper wanders upfield: $_seeds seeded matches, three tellings '
      'each, every keeper sampled every ${_sampleEvery}s', () {
    var frames = 0;
    final wanders = <String>[];
    for (var seed = 0; seed < _seeds; seed++) {
      final c = _case(seed);
      for (final (s, label) in _scripts(c, seed)) {
        final r = _scan(s, c.goalkeepers, label);
        frames += r.frames;
        wanders.addAll(r.wanders);
      }
    }
    expect(frames, greaterThan(500000), reason: 'the scan barely ran');
    expect(
      wanders,
      isEmpty,
      reason:
          '${wanders.length} of $frames keeper frames beyond '
          '${_reach.toStringAsFixed(1)} m; the first:\n'
          '${wanders.take(12).join('\n')}',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  group('a keeper substituted for a keeper', () {
    // The scan's keeper-for-keeper matches: seed % 4 == 1.
    final seeds = [for (var s = 1; s < 40; s += 4) s];

    test('keeps goal from the moment he steps on, to the end, and the man '
        'who minded it meanwhile is an outfielder again', () {
      for (final seed in seeds) {
        final c = _case(seed);
        final s = _build(c, PitchSpeed.values[seed % 3], seed);
        final on = s.arrivals[_subKeeper];
        expect(on, isNotNull, reason: c.label);
        expect(
          s.keepersAt(on! + 0.5).where((id) => id ~/ 100 == 1),
          [_subKeeper],
          reason: '${c.label}: one home keeper, the one who came on',
        );
        for (var t = on + 1; t < s.totalSeconds; t += 5) {
          expect(s.keepersAt(t), contains(_subKeeper), reason: c.label);
        }
        // On from the touchline level with his own area, and into his goal.
        double depthAt(double t) => xToDepth(
          s.sample(_at(t)).players[_subKeeper]!.x,
          attackDir(home: true, minute: s.pacer.matchAt(_at(t)).minute),
        );
        expect(depthAt(on + 0.5), lessThan(16.5), reason: c.label);
        final later = s.sample(_at(on + 10)).players[_subKeeper]!;
        expect(
          (later.y - PitchDims.width / 2).abs(),
          lessThan(20),
          reason: '${c.label}: still on the touchline 10 s later',
        );
      }
    });

    test('is still the keeper in a script resumed after he came on', () {
      for (final seed in seeds) {
        final c = _case(seed);
        final s0 = _build(c, PitchSpeed.values[seed % 3], seed);
        final on = s0.arrivals[_subKeeper]!;
        final at = on + (s0.totalSeconds - on) * 0.5;
        final s = _build(
          c,
          PitchSpeed.values[(seed + 1) % 3],
          seed,
          s0.stateAt(_at(at)),
        );
        expect(s0.keepersAt(at), contains(_subKeeper), reason: c.label);
        for (var t = s.start; t < s.totalSeconds; t += 2) {
          expect(s.keepersAt(t), contains(_subKeeper), reason: c.label);
        }
      }
    });

    test("is never one of a set piece's men upfield", () {
      for (final seed in seeds) {
        final c = _case(seed);
        final s = _build(c, PitchSpeed.values[seed % 3], seed);
        final on = s.arrivals[_subKeeper]!;
        for (final w in s.windows) {
          if (w.start < on || w.moments.isEmpty) continue;
          if (w.moments.first is! SetPieceMoment) continue;
          final mid = (w.start + w.end) / 2;
          final dir = attackDir(
            home: true,
            minute: s.pacer.matchAt(_at(mid)).minute,
          );
          final p = s.sample(_at(mid)).players[_subKeeper]!;
          expect(xToDepth(p.x, dir), lessThan(_reach), reason: c.label);
        }
      }
    });

    test('obeys every invariant of the picture', () {
      for (final seed in seeds) {
        final c = _case(seed);
        final s = _build(c, PitchSpeed.values[seed % 3], seed);
        expect(PitchScriptValidator.validate(s), isEmpty, reason: c.label);
      }
    });
  });
}
