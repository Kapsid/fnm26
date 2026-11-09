import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

/// Everything a match decided, as one string: scores, events, moments,
/// the per-minute series, ratings and energy. Two results with the same
/// fingerprint played the same match.
String _fingerprint(MatchResult r) => jsonEncode({
  'score': '${r.homeScore}-${r.awayScore}',
  'et': r.extraTime == null
      ? null
      : '${r.extraTime!.homeScore}-${r.extraTime!.awayScore}',
  'stoppage': r.stoppage,
  'possession': r.homePossession,
  'shots': '${r.homeShots}-${r.awayShots}',
  'xg': '${r.homeXg.toStringAsFixed(9)}-${r.awayXg.toStringAsFixed(9)}',
  'events': [
    for (final e in r.events)
      [
        e.minute,
        e.stoppage,
        e.type.name,
        e.teamNationId,
        e.playerId,
        e.secondaryPlayerId ?? '',
        e.assistPlayerId ?? '',
        e.penalty,
        e.setPiece,
        e.longThrow,
        e.secondYellow,
      ].join('|'),
  ],
  'moments': [for (final m in r.moments) m.toString()],
  'restarts': r.routineRestarts,
  'momentum': [for (final v in r.momentumByMinute) v.toStringAsFixed(9)],
  'ratings': [
    for (final p in r.ratings) '${p.playerId}:${p.rating.toStringAsFixed(6)}',
  ],
  'energy':
      (r.energyByPlayer.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key)))
          .map((e) => '${e.key}:${e.value}')
          .toList(),
});

/// FNV-1a over [s]: a short, stable digest to pin a fingerprint with.
String _digest(String s) {
  var h = 0x811C9DC5;
  for (final c in utf8.encode(s)) {
    h ^= c;
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  return h.toRadixString(16).padLeft(8, '0');
}

MatchResult _play(int i, {required bool managed, bool extraTime = false}) =>
    const MatchEngine().play(
      home: ratedTeam(1, 80),
      away: ratedTeam(2, 66),
      rng: SeededRng.forFixture(0x14B, i),
      aiManagedNationIds: managed ? const {2} : const {},
      neutralVenue: extraTime,
      extraTimeIfLevel: extraTime,
    );

void main() {
  test('the same seed plays the same match as before the log existed', () {
    // Digests captured on the engine before `instructionLog` was added
    // (feature/pitch-view at 81b69486). Recording the AI's instruction
    // drift must change nothing the engine decides. Re-pinned when the
    // penalty rate rose (0.095 to 0.105 of finished chances, 2026-11-07),
    // an intended outcome change; again when it rose to 0.175 with a home
    // lean (2026-11-08).
    final parts = StringBuffer();
    for (var i = 0; i < 40; i++) {
      parts
        ..write(_fingerprint(_play(i, managed: true)))
        ..write(_fingerprint(_play(i, managed: false)))
        ..write(_fingerprint(_play(i, managed: true, extraTime: true)));
    }
    expect(_digest(parts.toString()), _before);
  });

  test('a managed side logs each instruction change, minute by minute', () {
    var logged = 0;
    for (var i = 0; i < 40; i++) {
      final r = _play(i, managed: true);
      var last = ratedTeam(2, 66).instructions;
      var lastMinute = 0;
      for (final e in r.instructionLog) {
        expect(e.teamNationId, 2);
        expect(e.minute, greaterThanOrEqualTo(lastMinute));
        expect(e.instr, isNot(last), reason: 'a log entry changes something');
        last = e.instr;
        lastMinute = e.minute;
        logged++;
      }
      // Nobody manages a side that is not named: no log.
      expect(_play(i, managed: false).instructionLog, isEmpty);
    }
    expect(logged, greaterThan(0));
  });
}

const _before = 'ed728d0c';
