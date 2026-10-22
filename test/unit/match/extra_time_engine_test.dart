import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

/// The live engine's opt-in extra time: with `extraTimeIfLevel` set, a level
/// match plays on through minutes 91-120 after its stoppage. The ninety (and
/// its stoppage) must be untouched by the flag, so every knockout path that
/// keys off "level after ninety" reads the same score either way.

const _engine = MatchEngine();

MatchResult _play(
  int seed, {
  bool extraTime = false,
  List<Substitution> subs = const [],
  List<TacticalChange> changes = const [],
}) => _engine.play(
  home: ratedTeam(1, 75),
  away: ratedTeam(2, 75),
  rng: SeededRng.forFixture(0xE7, seed),
  neutralVenue: true,
  bigMatch: true,
  subs: subs,
  changes: changes,
  extraTimeIfLevel: extraTime,
);

/// A comparable fingerprint of an event (MatchEvent has no value equality).
String _sig(MatchEvent e) =>
    '${e.minute}+${e.stoppage} ${e.type.name} ${e.teamNationId} '
    '${e.playerId} ${e.secondaryName} ${e.assistPlayerId} ${e.setPiece}';

List<String> _regulation(MatchResult r) => [
  for (final e in r.events)
    if (e.minute <= 90) _sig(e),
];

int _etGoals(MatchResult r, int nationId) => r.events
    .where(
      (e) =>
          e.type == MatchEventType.goal &&
          e.teamNationId == nationId &&
          e.minute > 90,
    )
    .length;

/// Seeds whose ninety ends level (regulation is flag-independent).
Iterable<int> _levelSeeds(int n) sync* {
  for (var seed = 0; seed < n; seed++) {
    final r = _play(seed);
    if (r.homeScore == r.awayScore) yield seed;
  }
}

void main() {
  test('regulation is identical with or without the flag', () {
    for (var seed = 0; seed < 300; seed++) {
      final off = _play(seed);
      final on = _play(seed, extraTime: true);
      expect(on.homeScore, off.homeScore, reason: 'seed $seed');
      expect(on.awayScore, off.awayScore, reason: 'seed $seed');
      expect(on.stoppage, off.stoppage, reason: 'seed $seed');
      expect(_regulation(on), _regulation(off), reason: 'seed $seed');
    }
  });

  test('extra time only when level', () {
    var played = 0;
    for (var seed = 0; seed < 300; seed++) {
      final off = _play(seed);
      final on = _play(seed, extraTime: true);
      expect(off.extraTime, isNull, reason: 'seed $seed');
      expect(
        on.extraTime != null,
        on.homeScore == on.awayScore,
        reason: 'seed $seed',
      );
      if (on.extraTime != null) played++;
    }
    expect(played, greaterThan(0));
  });

  test('extra-time goals carry minutes 91-120 and sum to the totals', () {
    var etGoals = 0;
    for (final seed in _levelSeeds(300)) {
      final r = _play(seed, extraTime: true);
      final et = r.extraTime!;
      for (final e in r.events.where((e) => e.minute > 90)) {
        expect(e.minute, inInclusiveRange(91, 120));
        expect(e.stoppage, 0);
      }
      expect(_etGoals(r, 1), et.homeScore - r.homeScore, reason: 'seed $seed');
      expect(_etGoals(r, 2), et.awayScore - r.awayScore, reason: 'seed $seed');
      etGoals += _etGoals(r, 1) + _etGoals(r, 2);
    }
    expect(etGoals, greaterThan(0));
  });

  test('a change at minute 91 bites in extra time only', () {
    final home = ratedTeam(1, 75);
    final allOut = TacticalChange(
      teamNationId: 1,
      minute: 91,
      formation: Formation.f433,
      instructions: const TacticalInstructions(
        mentality: 100,
        tempo: 100,
        pressing: 100,
      ),
      xi: home.xi,
    );
    var withChange = 0;
    var without = 0;
    for (final seed in _levelSeeds(1200).take(400)) {
      final plain = _play(seed, extraTime: true);
      final changed = _play(seed, extraTime: true, changes: [allOut]);
      expect(changed.homeScore, plain.homeScore, reason: 'seed $seed');
      expect(changed.awayScore, plain.awayScore, reason: 'seed $seed');
      expect(_regulation(changed), _regulation(plain), reason: 'seed $seed');
      withChange += _etGoals(changed, 1);
      without += _etGoals(plain, 1);
    }
    expect(withChange, greaterThan(without));
  });

  test('a substitution at 91 brings the player on', () {
    final seed = _levelSeeds(300).first;
    final fresh = player(id: 199, nationId: 1, name: 'Fresh Legs');
    final r = _play(
      seed,
      extraTime: true,
      subs: [Substitution(teamNationId: 1, minute: 91, offId: 109, on: fresh)],
    );
    final sub = r.events.singleWhere(
      (e) => e.type == MatchEventType.substitution && e.playerId == 199,
    );
    expect(sub.minute, 91);
    expect(r.ratings.any((p) => p.playerId == 199), isTrue);
  });

  test('series run to 120 when extra time is played', () {
    final seed = _levelSeeds(300).first;
    final et = _play(seed, extraTime: true);
    for (final s in [
      et.homeXgByMinute,
      et.awayXgByMinute,
      et.homeShotsByMinute,
      et.awayShotsByMinute,
      et.momentumByMinute,
    ]) {
      expect(s.length, 121);
    }
    expect(_play(seed).homeXgByMinute.length, 91);
    // The ninety's points are the same either way.
    expect(
      et.homeXgByMinute.sublist(0, 91),
      _play(seed).homeXgByMinute,
    );
  });

  test('the chance factor is the calibrated value', () {
    // Set by extra_time_calibration_test.dart; change both together.
    expect(MatchEngine.extraTimeChanceFactor, 1.1);
  });
}
