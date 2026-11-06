import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/display_spacing.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

import '../../helpers/pitch_match_lab.dart';

/// What a viewer sees as a pile-up: two shirts more than half on top of
/// each other.
const double _pileUp = 0.5;

/// Men meant to be in contact (a challenge on the ball, a moment's own men
/// at a save, block, foul or header) may come closer, never fully on top:
/// at least half a token apart.
const double _contact = 0.75;

String _kind(StagedWindow? w) {
  if (w == null) return 'open play';
  if (w.injury != null && w.moments.isEmpty) return 'injury';
  final m = w.moments.first;
  return switch (m) {
    ShotMoment(:final origin) => 'shot ${origin.name}',
    SetPieceMoment(:final kind) => kind.name,
    FoulMoment() => 'foul',
    OffsideMoment() => 'offside',
    SubMoment() => 'sub',
  };
}

/// Every pair on screen at [t] that overlaps more than allowed, as
/// (sanctioned, overlap): where the script has the men, or (with
/// [drawn]) where the view draws them.
Iterable<(bool, double)> _crowded(
  PitchScript s,
  double t, {
  bool drawn = true,
}) sync* {
  final f = s.sample(Duration(microseconds: (t * 1e6).round()));
  final at = drawn ? Declutter.frame(s, f, t) : f.players;
  final ids = at.keys.toList();
  for (var i = 0; i < ids.length; i++) {
    for (var j = i + 1; j < ids.length; j++) {
      final a = ids[i], b = ids[j];
      final ov = DisplaySpacing.overlap(at[a]!, at[b]!);
      if (ov <= _pileUp) continue;
      yield (Declutter.inContact(s, f, a, b, t), ov);
    }
  }
}

void main() {
  test(
    'a token covers about 5.8 m along the pitch, more across it far off',
    () {
      expect(DisplaySpacing.halfLength * 2, closeTo(5.84, 0.05));
      expect(
        DisplaySpacing.halfAcross(0),
        greaterThan(
          DisplaySpacing.halfAcross(PitchDims.width),
        ),
      );
      expect(
        DisplaySpacing.overlap(const Offset2(50, 30), const Offset2(50, 30)),
        1,
      );
      expect(
        DisplaySpacing.overlap(const Offset2(50, 30), const Offset2(57, 30)),
        0,
      );
    },
  );

  test('players stay visually distinct: under 2% of frames pile up', () {
    var frames = 0;
    var piled = 0;
    var rawPiled = 0;
    var contactTooClose = 0;
    final byKind = <String, int>{};
    final framesByKind = <String, int>{};
    for (var seed = 0; seed < 200; seed++) {
      final s = labScript(labMatch(seed), PitchSpeed.values[seed % 3], seed: seed);
      for (var t = s.start + 0.1; t < s.totalSeconds; t += 0.2) {
        frames++;
        final kind = _kind(s.windowAt(t));
        framesByKind[kind] = (framesByKind[kind] ?? 0) + 1;
        if (_crowded(s, t, drawn: false).any((c) => !c.$1)) rawPiled++;
        var bad = false;
        var tooClose = false;
        for (final (sanctioned, ov) in _crowded(s, t)) {
          if (!sanctioned) bad = true;
          if (sanctioned && ov > _contact) tooClose = true;
        }
        if (bad) {
          piled++;
          byKind[kind] = (byKind[kind] ?? 0) + 1;
        }
        if (tooClose) contactTooClose++;
      }
    }
    final share = piled / frames;
    final contact = contactTooClose / frames;
    final rows = byKind.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    debugPrint(
      'pile-ups as drawn: $piled of $frames frames '
      '(${(share * 100).toStringAsFixed(2)}%); contact closer than half a '
      'token: ${(contact * 100).toStringAsFixed(2)}%; where the script has '
      'them: ${(rawPiled / frames * 100).toStringAsFixed(2)}%\n'
      '${rows.map((e) => '  ${e.key}: ${e.value} of ${framesByKind[e.key]} '
          '(${(e.value / framesByKind[e.key]! * 100).toStringAsFixed(1)}%)').join('\n')}',
    );
    expect(share, lessThan(0.02));
    expect(contact, lessThan(0.02));
  });

  test('a drawn token eases aside, never jumps', () {
    // Frame to frame at 60 fps, how far a token's nudge (drawn place less
    // the man's place) moves, in tokens; cuts and restarts apart.
    var worst = 0.0;
    var sum = 0.0;
    var count = 0;
    final w = 2 * DisplaySpacing.halfLength;
    for (var seed = 0; seed < 12; seed++) {
      final s = labScript(labMatch(seed), PitchSpeed.values[seed % 3], seed: seed);
      Map<int, Offset2>? last;
      Map<int, Offset2>? lastRaw;
      for (var t = s.start + 0.1; t < s.totalSeconds; t += 1 / 60) {
        final f = s.sample(Duration(microseconds: (t * 1e6).round()));
        final drawn = Declutter.frame(s, f, t);
        final nearCut = [
          ...s.cuts,
          ...s.resets,
        ].any((c) => (c - t).abs() < 0.1);
        if (last != null && lastRaw != null && !nearCut) {
          for (final id in drawn.keys) {
            final a = last[id], ra = lastRaw[id];
            if (a == null || ra == null) continue;
            final n0 = a - ra;
            final n1 = drawn[id]! - f.players[id]!;
            final d = n1 - n0;
            final h = 2 * DisplaySpacing.halfAcross(f.players[id]!.y);
            final jump = math.max((d.x / w).abs(), (d.y / h).abs());
            worst = math.max(worst, jump);
            sum += jump;
            count++;
          }
        }
        last = drawn;
        lastRaw = f.players;
      }
    }
    debugPrint(
      'nudge change per frame: mean ${(sum / count).toStringAsFixed(4)}, '
      'worst ${worst.toStringAsFixed(3)} tokens',
    );
    expect(worst, lessThan(0.1));
  });
}
