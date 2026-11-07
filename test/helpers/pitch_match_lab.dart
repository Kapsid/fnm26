/// The 200-match lab the staging audits run on: varied real-engine
/// matches (shapes, dials, strengths, subs, long throws, extra time), the
/// same ones `moment_staging_test.dart` judges.
library;

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

import 'fixtures.dart';

const labEngine = MatchEngine();

MatchTeam labTeam(
  int nation,
  int rating,
  Formation f,
  TacticalInstructions i, {
  ThrowInStyle throwIn = ThrowInStyle.neutral,
}) => MatchTeam(
  nationId: nation,
  formation: f,
  instructions: i,
  throwInStyle: throwIn,
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

TacticalInstructions labDials(SeededRng r) => TacticalInstructions(
  mentality: r.rangeInt(10, 90),
  pressing: r.rangeInt(10, 90),
  tempo: r.rangeInt(10, 90),
  width: r.rangeInt(10, 90),
  defensiveLine: r.rangeInt(10, 90),
  directness: r.rangeInt(10, 90),
);

typedef LabMatch = ({MatchResult result, MatchLineups lineups});

/// A varied engine match: shapes, dials, strengths, subs, long throws and
/// extra time all move with [seed].
LabMatch labMatch(int seed) {
  final r = SeededRng(seed * 7919 + 13);
  const fs = Formation.values;
  final home = labTeam(
    1,
    r.rangeInt(62, 84),
    fs[seed % fs.length],
    labDials(r),
    throwIn: seed % 4 == 1 ? ThrowInStyle.long : ThrowInStyle.neutral,
  );
  final away = labTeam(
    2,
    r.rangeInt(62, 84),
    fs[(seed * 7 + 3) % fs.length],
    labDials(r),
    throwIn: seed % 5 == 2 ? ThrowInStyle.long : ThrowInStyle.neutral,
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
  final result = labEngine.play(
    home: home,
    away: away,
    rng: SeededRng.forFixture(0xB0A7, seed),
    subs: subs,
    neutralVenue: true,
    bigMatch: true,
    extraTimeIfLevel: seed % 3 == 0,
  );
  return (
    result: result,
    lineups: matchLineupsOf(
      home: home,
      away: away,
      homeBench: homeBench,
      awayBench: awayBench,
      result: result,
    ),
  );
}

PitchScript labScript(LabMatch m, PitchSpeed speed, {int seed = 7}) =>
    StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, speed),
      seed: seed,
    );
