import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';

import '../../helpers/fixtures.dart';

/// A 4-3-3 whose men differ, so the automatic picks are real choices.
List<Player> _xi(int nationId, int base) {
  final positions = Formation.f433.positions;
  return [
    for (var i = 0; i < 11; i++)
      player(
        id: nationId * 100 + i,
        nationId: nationId,
        position: positions[i],
        attributes: PlayerAttributes(
          physical: base - 6 + (i * 7) % 13,
          technical: base - 8 + (i * 5) % 17,
          stamina: base - 4 + (i * 3) % 9,
        ),
      ),
  ];
}

/// Everything a match produced that a set-piece taker could touch: every
/// event and every moment, in order.
String _fingerprint(MatchResult r) {
  final b = StringBuffer('${r.homeScore}-${r.awayScore}|');
  for (final e in r.events) {
    b.write(
      '${e.minute}+${e.stoppage}:${e.type.name}:${e.teamNationId}:'
      '${e.playerId}:${e.assistPlayerId}:${e.penalty}:${e.setPiece};',
    );
  }
  for (final m in r.moments) {
    b.write('${m.runtimeType}@${m.minute}+${m.stoppage}#${m.seq}:');
    switch (m) {
      case SetPieceMoment():
        b.write('${m.kind.name}/${m.takerId}/${m.left}/${m.zone.name}');
      case ShotMoment():
        b.write('${m.shooterId}/${m.outcome.name}/${m.xg.toStringAsFixed(4)}');
      default:
        b.write(m.teamNationId);
    }
    b.write(';');
  }
  return b.toString();
}

/// FNV-1a over [s], so the expected value fits on one line.
int _hash(String s) {
  var h = 0x811C9DC5;
  for (final c in s.codeUnits) {
    h = ((h ^ c) * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

/// The manager keeping ONE taker per duty (the old pair) must play every match
/// exactly as before ordered takers existed: same goals, same scorers, same
/// moments. The expected hash was recorded on the engine before the change
/// (ddbd37f3) and must never move for this input.
void main() {
  const engine = MatchEngine();

  test('single takers play exactly as before ordered takers', () {
    var all = 0;
    for (var seed = 0; seed < 120; seed++) {
      final homeXi = _xi(1, 74);
      final awayXi = _xi(2, 72);
      // A named penalty man and a different dead-ball man, the dead-ball man
      // subbed off on the hour in half the matches so the fallback plays too.
      final penalty = homeXi[9].id;
      final deadBall = homeXi[7].id;
      final home = MatchTeam(
        nationId: 1,
        xi: homeXi,
        instructions: const TacticalInstructions(),
        penaltyTakerId: penalty,
        deadBallTakerId: deadBall,
        throwInStyle: seed.isEven ? ThrowInStyle.long : ThrowInStyle.neutral,
      );
      final away = MatchTeam(
        nationId: 2,
        xi: awayXi,
        instructions: const TacticalInstructions(),
      );
      final r = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(seed, 7),
        subs: seed.isOdd
            ? [
                Substitution(
                  teamNationId: 1,
                  minute: 60,
                  offId: deadBall,
                  on: player(
                    id: 199,
                    nationId: 1,
                    position: PlayerPosition.cm,
                    attributes: const PlayerAttributes(
                      physical: 70,
                      technical: 90,
                      stamina: 70,
                    ),
                  ),
                ),
              ]
            : const [],
      );
      all = _hash('$all|${_fingerprint(r)}');
    }
    expect(all, _expected);
  });
}

const int _expected = 3767986824;
