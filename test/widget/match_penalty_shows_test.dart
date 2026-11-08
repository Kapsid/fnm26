import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_commentary.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/fixtures.dart';

/// The owner played ten of his own matches and saw no penalty at all. A
/// penalty given in one of the manager's matches must show in all three
/// places he can look: the Timeline, the 2D TV (its staging and its
/// commentary) and the match stats. A scored one already did (a goal marked
/// "(pen)"); a missed or saved one left no trace on the Timeline or in the
/// stats, only a shot more.
final _l = AppLocalizationsEn();

const _home = 1;
const _away = 2;

MatchTeam _team(int nationId, int rating) => MatchTeam(
  nationId: nationId,
  formation: Formation.f433,
  instructions: const TacticalInstructions(),
  xi: [
    for (var i = 0; i < 11; i++)
      player(
        id: nationId * 100 + i,
        nationId: nationId,
        name: 'Jan Taker$nationId$i',
        position: Formation.f433.positions[i],
        attributes: flatAttributes(rating),
      ),
  ],
);

final MatchTeam _homeTeam = _team(_home, 78);
final MatchTeam _awayTeam = _team(_away, 76);

/// The manager's own match as the live screen plays it: the opponent
/// managed by the AI.
MatchResult _play(int seed) => const MatchEngine().play(
  home: _homeTeam,
  away: _awayTeam,
  rng: SeededRng.forFixture(0x9E9A, seed),
  aiManagedNationIds: const {_away},
);

/// The first seed whose match has a penalty that [wanted] holds for.
(MatchResult, ShotMoment) _find(bool Function(ShotMoment s) wanted) {
  for (var seed = 0; seed < 400; seed++) {
    final r = _play(seed);
    for (final s in r.moments.whereType<ShotMoment>()) {
      if (s.origin == ShotOrigin.penalty && wanted(s)) return (r, s);
    }
  }
  throw StateError('no such penalty in 400 matches');
}

final Map<int, String> _names = {
  for (final p in [..._homeTeam.xi, ..._awayTeam.xi]) p.id: p.name,
};

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.binding.setSurfaceSize(const Size(400, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
  await tester.pumpAndSettle();
}

/// Everything reached: the screen at full time.
List<InPlayPenalty> _all(MatchResult r) => inPlayPenalties(
  r,
  names: _names,
  eventReached: (_) => true,
  momentReached: (_, _) => true,
);

Widget _timeline(MatchResult r) => MatchTimeline(
  events: r.events,
  penalties: _all(r),
  live: false,
  homeId: _home,
);

Widget _stats(MatchResult r) => MatchStatsPanel(
  result: r,
  homeCode: 'CZE',
  awayCode: 'POR',
  homeNationId: _home,
  ground: (
    stadium: 'Test Park',
    city: 'Brno',
    groundNationId: _home,
    capacity: 30000,
    attendance: 27000,
    soldOut: false,
  ),
  neutral: false,
  groundCode: 'CZE',
  minute: 90,
  fullTime: true,
  events: r.events,
  penalties: _all(r),
);

/// The 2D TV's commentary over the whole match.
List<String> _commentary(MatchResult r) {
  final pb = PitchPlayback.build(
    result: r,
    lineups: matchLineupsOf(home: _homeTeam, away: _awayTeam, result: r),
    speed: PitchSpeed.fast,
    seed: 7,
  );
  return pb.linesUpTo(_l, const Duration(hours: 1), _names, 7);
}

/// The 2D TV stages [s]: it sits in one of the script's windows.
bool _staged(MatchResult r, ShotMoment s) {
  final pb = PitchPlayback.build(
    result: r,
    lineups: matchLineupsOf(home: _homeTeam, away: _awayTeam, result: r),
    speed: PitchSpeed.fast,
    seed: 7,
  );
  return pb.script.windows.any((w) => w.moments.any((m) => identical(m, s)));
}

String _abbrev(String full) {
  final parts = full.split(' ');
  return '${parts.first[0]}. ${parts.last}';
}

void main() {
  testWidgets('a penalty saved or missed shows on the Timeline, in the stats '
      'and on the 2D TV', (tester) async {
    final (r, s) = _find((s) => s.outcome != ShotOutcome.goal);
    final taker = _names[s.shooterId]!;

    await _pump(tester, _timeline(r));
    expect(
      find.text(_l.matchShootoutKickMissed(_abbrev(taker))),
      findsOneWidget,
      reason: 'a penalty that did not go in is missing from the Timeline',
    );

    await _pump(tester, _stats(r));
    final label = find.text(_l.tacticsPenalties.toUpperCase());
    expect(label, findsOneWidget, reason: 'no penalty row in the stats');
    final row = find.ancestor(of: label, matching: find.byType(Row)).first;
    final figures = find
        .descendant(of: row, matching: find.byType(Text))
        .evaluate()
        .map((e) => (e.widget as Text).data)
        .toList();
    final home = s.teamNationId == _home;
    expect(figures.first, home ? '1' : '0');
    expect(figures.last, home ? '0' : '1');

    expect(_staged(r, s), isTrue, reason: 'the 2D TV never stages it');
    expect(
      _commentary(r),
      contains(pitchLine(_l, s, _names, 7, events: r.events)),
      reason: 'the 2D TV never says it',
    );
  });

  testWidgets('a penalty scored shows on the Timeline, in the stats and on '
      'the 2D TV', (tester) async {
    final (r, s) = _find((s) => s.outcome == ShotOutcome.goal);
    final taker = _names[s.shooterId]!;

    await _pump(tester, _timeline(r));
    expect(find.text('${_abbrev(taker)} (pen)'), findsOneWidget);
    // Shown once, as the goal: not a second time as a kick.
    expect(find.text(_l.matchShootoutKickMissed(_abbrev(taker))), findsNothing);

    await _pump(tester, _stats(r));
    expect(find.text(_l.tacticsPenalties.toUpperCase()), findsOneWidget);

    expect(_staged(r, s), isTrue, reason: 'the 2D TV never stages it');
    // The goal's own line names the taker.
    expect(
      _commentary(r).any((l) => l.contains(taker.split(' ').last)),
      isTrue,
    );
  });

  test('the clock gates them: nothing before the kick, all of it after', () {
    final (r, s) = _find((s) => s.outcome != ShotOutcome.goal);
    final before = inPlayPenalties(
      r,
      names: _names,
      eventReached: (_) => false,
      momentReached: (m, st) => (m, st) == (0, 0),
    );
    expect(before, isEmpty);
    final after = _all(r);
    final kick = after.singleWhere(
      (p) => p.minute == s.minute && p.stoppage == s.stoppage && !p.scored,
    );
    expect(kick.teamNationId, s.teamNationId);
    expect(kick.takerName, _names[s.shooterId]);
  });
}
