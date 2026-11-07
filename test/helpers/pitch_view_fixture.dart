import 'dart:convert';
import 'dart:io';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/domain/services/match/stadium/away_fan_share.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/features/match/pitch/match_dressing.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

import 'fixtures.dart';

/// A nation straight from the game's data.
Nation pitchNation(String code) {
  final all =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
          .cast<Map<String, Object?>>();
  final n = all.firstWhere((m) => m['code'] == code);
  return Nation(
    id: n['id']! as int,
    name: n['name']! as String,
    code: code,
    confederation: Confederation.values.byName(n['confederation']! as String),
    ranking: n['ranking']! as int,
    primaryColor: n['primaryColor']! as String,
    secondaryColor: n['secondaryColor']! as String,
  );
}

const List<String> _surnames = [
  'NOVOTNY', 'KRAL', 'DVORAK', 'HAVEL', 'SOUKUP', 'BENES', 'MAREK', //
  'FIALA', 'KUCERA', 'POSPISIL', 'HORAK', 'FERREIRA', 'SANTOS', 'COSTA',
  'MENDES', 'LOPES', 'RIBEIRO', 'MARTINS', 'SOUSA', 'CARVALHO', 'PINTO',
  'GOMES', 'TEIXEIRA', 'MOREIRA',
];

typedef PitchMatchFixture = ({
  PitchScript script,
  Map<int, String> names,
  Nation home,
  Nation away,
});

/// A real engine match between [homeCode] and [awayCode], staged for the
/// Pitch view at [speed], with a surname for everybody.
PitchMatchFixture pitchMatch({
  int seed = 3,
  String homeCode = 'CZE',
  String awayCode = 'POR',
  PitchSpeed speed = PitchSpeed.mid,
  bool isFinal = false,
}) {
  final home = pitchNation(homeCode);
  final away = pitchNation(awayCode);
  final names = <int, String>{};
  MatchTeam team(Nation n, Formation f, int rating) {
    final xi = [
      for (var k = 0; k < 11; k++)
        player(
          id: n.id * 100 + k,
          nationId: n.id,
          position: f.positions[k],
          attributes: flatAttributes(rating),
        ),
    ];
    for (final p in xi) {
      names[p.id] = _surnames[(p.id * 7 + seed) % _surnames.length];
    }
    return MatchTeam(
      nationId: n.id,
      formation: f,
      instructions: const TacticalInstructions(),
      xi: xi,
    );
  }

  final h = team(home, Formation.f433, 78);
  final a = team(away, Formation.f4231, 76);
  final sub = player(id: home.id * 100 + 50, nationId: home.id);
  names[sub.id] = 'BARTOS';
  final result = const MatchEngine().play(
    home: h,
    away: a,
    rng: SeededRng.forFixture(0xC0DE, seed),
    subs: [
      Substitution(
        teamNationId: home.id,
        minute: 62,
        offId: home.id * 100 + 9,
        on: sub,
      ),
    ],
  );
  final script = StoryLayer.build(
    result: result,
    lineups: matchLineupsOf(
      home: h,
      away: a,
      homeBench: [sub.id],
      awayBench: const [],
      result: result,
    ),
    pacer: PitchPacer(result, speed),
    seed: seed,
    isFinal: isFinal,
  );
  return (script: script, names: names, home: home, away: away);
}

/// The ground for [m]: a 30,000 two-tier bowl in Brno on a September
/// evening, so the light runs from day into dusk across the match.
PitchStadium pitchStadiumFor(
  PitchMatchFixture m, {
  int capacity = 30000,
  String city = 'Brno',
  DateTime? date,
  KickOffTime kickOff = const KickOffTime(18, 30),
  MatchDressing dressing = MatchDressing.none,
}) => PitchStadium.forMatch(
  ground: (
    stadium: 'Mock Mid Arena',
    city: city,
    groundNationId: m.home.id,
    capacity: capacity,
    attendance: (capacity * 0.9).round(),
    soldOut: false,
  ),
  home: m.home,
  away: m.away,
  awayShare: AwayFanShare.estimate(
    home: m.home,
    away: m.away,
    neutral: false,
    tournament: dressing.dressed,
    distanceKm: AwayFanShare.proxyDistanceKm(m.home, m.away),
  ),
  date: date ?? DateTime(2026, 9, 10),
  kickOff: kickOff,
  dressing: dressing,
);
