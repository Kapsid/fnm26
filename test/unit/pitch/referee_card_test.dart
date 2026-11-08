import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/referee_card.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

import '../../helpers/fixtures.dart';

/// The referee's sending-off on the 2D TV: read off the script's own cues,
/// the same every time, and never a card before the foul.

const _engine = MatchEngine();

MatchTeam _team(int nation, int rating, TacticalInstructions i) => MatchTeam(
  nationId: nation,
  formation: Formation.f433,
  instructions: i,
  xi: [
    for (var k = 0; k < 11; k++)
      player(
        id: nation * 100 + k,
        nationId: nation,
        position: Formation.f433.positions[k],
        attributes: flatAttributes(rating),
      ),
  ],
);

/// An engine match for [seed], with hard pressing on both sides so cards
/// come along often enough to find.
({MatchResult result, MatchLineups lineups}) _match(int seed) {
  final r = SeededRng(seed * 7919 + 13);
  TacticalInstructions dials() => TacticalInstructions(
    mentality: r.rangeInt(10, 90),
    pressing: r.rangeInt(70, 99),
    tempo: r.rangeInt(10, 90),
  );
  final home = _team(1, r.rangeInt(62, 84), dials());
  final away = _team(2, r.rangeInt(62, 84), dials());
  final result = _engine.play(
    home: home,
    away: away,
    rng: SeededRng.forFixture(0xCA4D, seed),
    neutralVenue: true,
  );
  return (
    result: result,
    lineups: matchLineupsOf(home: home, away: away, result: result),
  );
}

PitchScript _script(
  ({MatchResult result, MatchLineups lineups}) m,
  PitchSpeed speed,
  int seed,
) => StoryLayer.build(
  result: m.result,
  lineups: m.lineups,
  pacer: PitchPacer(m.result, speed),
  seed: seed,
);

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

/// Seeded matches with a red card the picture stages, with their scripts.
final List<(int, PitchScript)> _reds = () {
  final out = <(int, PitchScript)>[];
  for (var seed = 0; seed < 400 && out.length < 12; seed++) {
    final m = _match(seed);
    if (!m.result.events.any((e) => e.type == MatchEventType.redCard)) {
      continue;
    }
    out.add((seed, _script(m, PitchSpeed.values[seed % 3], seed)));
  }
  return out;
}();

void main() {
  test('found sending-offs to stage, straight reds and second yellows', () {
    expect(_reds.length, greaterThanOrEqualTo(6));
  });

  test('every staged red card gets one referee, on its own card cue', () {
    for (final (seed, s) in _reds) {
      final shows = RefereeCardShow.of(s);
      final cues = [
        for (final w in s.windows)
          for (final c in w.cues)
            if (c.kind == PitchCueKind.redCard) c,
      ];
      expect(shows, hasLength(cues.length), reason: 'match $seed');
      for (final (i, show) in shows.indexed) {
        expect(show.cardAt, cues[i].t, reason: 'match $seed');
        expect(show.playerId, cues[i].playerId, reason: 'match $seed');
      }
    }
  });

  test('he runs in, holds the red up for most of two seconds by the man, '
      'and jogs off', () {
    for (final (seed, s) in _reds) {
      for (final show in RefereeCardShow.of(s)) {
        final why = 'match $seed, card at ${show.cardAt}';
        expect(show.frameAt(show.start - 0.01), isNull, reason: why);
        expect(show.frameAt(show.until), isNull, reason: why);
        // Not there yet at the start, faded in, running.
        final first = show.frameAt(show.start)!;
        expect(first.alpha, lessThan(0.05), reason: why);
        expect(show.start, lessThan(show.cardAt), reason: why);
        expect(first.card, isNull, reason: why);
        // At his spot, the red at full stretch from its cue...
        final up = show.frameAt(show.cardAt + RefereeCardShow.lift)!;
        expect(up.card, RefereeCard.red, reason: why);
        expect(up.raise, closeTo(1, 1e-6), reason: why);
        expect(up.at, show.spot, reason: why);
        // ...a couple of metres from the man he is sending off.
        final man = s.sample(_at(show.cardAt)).players[show.playerId]!;
        expect(
          show.spot.distanceTo(man),
          lessThan(RefereeCardShow.standOff + 0.01),
          reason: why,
        );
        // Every point of his run is on the pitch.
        for (var t = show.start; t < show.until; t += 0.05) {
          final f = show.frameAt(t)!;
          expect(f.at.x, inInclusiveRange(0, PitchDims.length), reason: why);
          expect(f.at.y, inInclusiveRange(0, PitchDims.width), reason: why);
        }
        // Held up for the whole hold unless a cut takes the picture away.
        final full = show.cardAt + RefereeCardShow.hold;
        if (show.until > full) {
          final held = show.frameAt(full - 0.01)!;
          expect(held.card, RefereeCard.red, reason: why);
          expect(held.raise, closeTo(1, 1e-6), reason: why);
          final gone = show.frameAt(show.until - 0.01);
          expect(gone?.card, isNull, reason: why);
          expect(gone?.alpha ?? 0, lessThan(0.1), reason: why);
        }
      }
    }
  });

  test('a second booking shows the yellow first, never before the foul', () {
    var seconds = 0;
    for (final (seed, s) in _reds) {
      for (final show in RefereeCardShow.of(s)) {
        final w = s.windows.firstWhere(
          (w) => w.cues.any(
            (c) => c.kind == PitchCueKind.redCard && c.t == show.cardAt,
          ),
        );
        final foul = w.cues.firstWhere((c) => c.kind == PitchCueKind.foul).t;
        final m = w.moments.first as FoulMoment;
        final e = s.result.events[m.cardEventIndex!];
        // The first card up comes after the whistle.
        double? firstCard;
        for (var t = show.start; t < show.until; t += 0.01) {
          if (show.frameAt(t)?.card != null) {
            firstCard = t;
            break;
          }
        }
        expect(firstCard, isNotNull, reason: 'match $seed');
        expect(firstCard, greaterThanOrEqualTo(foul), reason: 'match $seed');
        if (!show.yellowFirst) continue;
        expect(e.secondYellow, isTrue);
        seconds++;
        final yellow = show.frameAt(
          show.cardAt - RefereeCardShow.yellowLead + RefereeCardShow.lift,
        )!;
        expect(yellow.card, RefereeCard.yellow, reason: 'match $seed');
        expect(yellow.raise, closeTo(1, 1e-6), reason: 'match $seed');
      }
    }
    expect(seconds, greaterThan(0), reason: 'no second yellow staged');
  });

  test('the same script, the same referee', () {
    final (seed, s) = _reds.first;
    final again = _script(
      _match(seed),
      PitchSpeed.values[seed % 3],
      seed,
    );
    final a = RefereeCardShow.of(s);
    final b = RefereeCardShow.of(again);
    expect(b.length, a.length);
    for (var i = 0; i < a.length; i++) {
      expect(b[i].spot, a[i].spot);
      expect(b[i].from, a[i].from);
      expect(b[i].until, a[i].until);
      for (var t = a[i].start; t < a[i].until; t += 0.1) {
        expect(b[i].frameAt(t), a[i].frameAt(t));
      }
    }
  });

  test('the man sent off walks while the card is still up', () {
    for (final (seed, s) in _reds) {
      for (final show in RefereeCardShow.of(s)) {
        final walk = s.departures[show.playerId];
        expect(walk, isNotNull, reason: 'match $seed');
        expect(walk, greaterThan(show.cardAt), reason: 'match $seed');
        expect(
          walk,
          lessThan(show.cardAt + RefereeCardShow.hold),
          reason: 'match $seed',
        );
      }
    }
  });

  test('a match with no red card has no referee', () {
    for (var seed = 0; seed < 40; seed++) {
      final m = _match(seed);
      if (m.result.events.any((e) => e.type == MatchEventType.redCard)) {
        continue;
      }
      expect(RefereeCardShow.of(_script(m, PitchSpeed.mid, seed)), isEmpty);
      return;
    }
  });
}
