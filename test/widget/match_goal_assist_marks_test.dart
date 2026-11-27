import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/card_status.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/player_match_marks.dart';
import 'package:fnm/shared/widgets/rating_badge.dart';

import '../helpers/fixtures.dart';
import '../helpers/in_match_editor.dart';
import '../helpers/seeded_save.dart';

/// "Also on after match (and live too) show goal and assist icons (ball icon
/// is now cut on after match fix it too)."
///
/// A brace with an assist, a second assist by the man who came on, a booking:
/// every list of the match, live and at full time, shows the ball and the
/// handshake, on a 390pt phone, at text scale 1 and 1.3, with a long name.
/// The ball used to be cut on the full-time pitch: its chip started a couple
/// of points left of its node, whose Stack clips.
const _longName = 'Alexandros Papadopoulos-Konstantinidis';
const _phone = Size(390, 844);

const _names = [
  'Tomas Vrba', 'Jakub Kriz', 'Ondrej Maly', 'Petr Novy', 'Lukas Cerny', //
  'Adam Holy', 'Vaclav Hruby', 'Filip Dusek', 'Martin Kolar', _longName,
  'David Zeman',
];

final _xi = [
  for (var i = 0; i < 11; i++)
    player(
      id: 100 + i,
      nationId: 1,
      name: _names[i],
      position: Formation.f433.positions[i],
    ),
];
final _awayXi = [
  for (var i = 0; i < 11; i++)
    player(
      id: 200 + i,
      nationId: 2,
      name: 'Away Man $i',
      position: Formation.f433.positions[i],
    ),
];
final _sub = player(
  id: 150,
  nationId: 1,
  name: 'Roman Bily',
  position: PlayerPosition.st,
);
final _scorer = _xi[9];
final _assister = _xi[6];
final _booked = _xi[3];

final _events = [
  MatchEvent(
    minute: 12,
    type: MatchEventType.goal,
    teamNationId: 1,
    playerId: _scorer.id,
    playerName: _scorer.name,
    assistPlayerId: _assister.id,
  ),
  MatchEvent(
    minute: 31,
    type: MatchEventType.yellowCard,
    teamNationId: 1,
    playerId: _booked.id,
    playerName: _booked.name,
  ),
  MatchEvent(
    minute: 63,
    type: MatchEventType.substitution,
    teamNationId: 1,
    playerId: _sub.id,
    playerName: _sub.name,
    secondaryPlayerId: _xi[10].id,
    secondaryName: _xi[10].name,
  ),
  MatchEvent(
    minute: 70,
    type: MatchEventType.goal,
    teamNationId: 1,
    playerId: _scorer.id,
    playerName: _scorer.name,
    assistPlayerId: _sub.id,
  ),
];

final _ratings = {
  for (final p in [..._xi, ..._awayXi]) p.id: 6.0 + p.id % 7 / 3,
  _sub.id: 7.1,
};

MatchLineups _list({required bool live}) => MatchLineups(
  home: [..._xi.take(10), _sub],
  away: _awayXi,
  homeCode: 'CZE',
  awayCode: 'NED',
  homeSubs: [_events[2]],
  homeBench: [_sub],
  ratings: _ratings,
  energy: {
    for (final p in [..._xi, _sub]) p.id: 64,
  },
  events: _events,
  motmId: live ? null : _scorer.id,
  live: live,
);

MatchTeam _team(int nation, List<Player> xi) => MatchTeam(
  nationId: nation,
  formation: Formation.f433,
  instructions: const TacticalInstructions(),
  xi: xi,
);

MatchFullTimeLineups _ftLineups() => MatchFullTimeLineups(
  home: (
    nationId: 1,
    code: 'CZE',
    team: _team(1, _xi),
    cameOn: [_sub],
    kit: null,
    cards: cardStatusFor(_events, nationId: 1, upToMinute: 200),
    goals: goalsByPlayerOf(_events, nationId: 1),
    ownGoals: ownGoalsByPlayerOf(_events, nationId: 1),
  ),
  away: (
    nationId: 2,
    code: 'NED',
    team: _team(2, _awayXi),
    cameOn: const <Player>[],
    kit: null,
    cards: const <int, MatchCard>{},
    goals: const <int, int>{},
    ownGoals: const <int, int>{},
  ),
  ratings: _ratings,
  motmId: _scorer.id,
  playerNationId: 1,
  list: _list(live: false),
  assists: assistsByPlayerOf(_events),
);

MatchStatsPanel _ratingsPanel() => MatchStatsPanel(
  result: MatchResult(
    homeScore: 2,
    awayScore: 0,
    events: _events,
    homeShots: 9,
    awayShots: 3,
    homePossession: 55,
    ratings: [
      for (final p in [..._xi, _sub, ..._awayXi])
        PlayerRating(
          playerId: p.id,
          playerName: p.name,
          teamNationId: p.nationId,
          rating: _ratings[p.id]!,
          position: p.position,
        ),
    ],
  ),
  homeCode: 'CZE',
  awayCode: 'NED',
  homeNationId: 1,
  ground: (
    stadium: 'Stadion',
    city: 'Prague',
    groundNationId: 1,
    capacity: 20000,
    attendance: 18000,
    soldOut: false,
  ),
  neutral: false,
  groundCode: 'CZE',
  minute: 90,
  fullTime: true,
  events: _events,
  showGround: false,
);

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  double scale = 1,
}) async {
  tester.view
    ..physicalSize = _phone * 2
    ..devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.theme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (c, w) => MediaQuery(
        data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
        child: w!,
      ),
      home: Scaffold(body: child),
    ),
  );
  await tester.pumpAndSettle();
}

/// [mark] lies wholly inside [row] and on the screen.
void _inside(WidgetTester tester, Finder mark, Finder row, String why) {
  final m = tester.getRect(mark);
  final r = tester.getRect(row);
  expect(m.width, greaterThan(0), reason: why);
  expect(
    m.left >= r.left - 0.01 &&
        m.top >= r.top - 0.01 &&
        m.right <= r.right + 0.01 &&
        m.bottom <= r.bottom + 0.01,
    isTrue,
    reason: '$why: $m outside $r',
  );
  expect(m.right, lessThanOrEqualTo(_phone.width), reason: why);
}

/// Every rating badge whole on screen.
void _badgesOnScreen(WidgetTester tester) {
  for (final e in find.byType(RatingBadge).evaluate()) {
    final box = e.renderObject! as RenderBox;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    expect(rect.right, lessThanOrEqualTo(_phone.width + 0.01), reason: '$rect');
  }
}

/// The goal icon's own box, under its mark.
Finder _ball(int id) => find.descendant(
  of: find.byKey(PlayerMatchMarks.goalKey(id)),
  matching: find.byIcon(Icons.sports_soccer),
);

void main() {
  test("own goals are never the culprit's goals, nor anybody's assist", () {
    final t = playerMatchTally([
      MatchEvent(
        minute: 5,
        type: MatchEventType.goal,
        teamNationId: 2,
        playerId: _booked.id,
        playerName: _booked.name,
        ownGoal: true,
        assistPlayerId: _assister.id,
      ),
    ], _booked.id);
    expect((t.goals, t.ownGoals), (0, 1));
    expect(assistsByPlayerOf(_events), {_assister.id: 1, _sub.id: 1});
  });

  for (final scale in [1.0, 1.3]) {
    group('text scale $scale', () {
      testWidgets('live line-ups: ball and handshake, nothing cut', (
        tester,
      ) async {
        await _pump(tester, _list(live: true), scale: scale);
        expect(tester.takeException(), isNull);
        final row = find.byKey(MatchLineups.rowKey(_scorer.id));
        expect(
          find.descendant(of: row, matching: find.text('2')),
          findsOneWidget,
        );
        _inside(tester, _ball(_scorer.id), row, "the scorer's ball");
        _inside(
          tester,
          find.byKey(PlayerMatchMarks.assistKey(_assister.id)),
          find.byKey(MatchLineups.rowKey(_assister.id)),
          'the assist',
        );
        expect(
          find.byKey(PlayerMatchMarks.assistKey(_sub.id)),
          findsOneWidget,
        );
        expect(find.byKey(PlayerMatchMarks.cardKey(_booked.id)), findsOne);
        // The long name gives way, not the marks or the badge.
        final name = tester.getRect(
          find.descendant(of: row, matching: find.text(_longName)),
        );
        expect(
          name.right,
          lessThanOrEqualTo(tester.getRect(_ball(_scorer.id)).left),
        );
        _badgesOnScreen(tester);
      });

      testWidgets('full-time ratings: ball and handshake beside the name', (
        tester,
      ) async {
        await _pump(tester, _ratingsPanel(), scale: scale);
        await tester.scrollUntilVisible(
          find.text(_longName),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        Finder rowOf(String name) =>
            find.ancestor(of: find.text(name), matching: find.byType(Row)).last;
        _inside(tester, _ball(_scorer.id), rowOf(_longName), 'ball');
        _inside(
          tester,
          find.byKey(PlayerMatchMarks.assistKey(_assister.id)),
          rowOf(_assister.name),
          'assist',
        );
        expect(
          find.byKey(PlayerMatchMarks.assistKey(_sub.id)),
          findsOneWidget,
        );
        _badgesOnScreen(tester);
      });

      testWidgets("full-time pitch: the scorer's ball is whole, the assist "
          "and the substitute's assist shown", (tester) async {
        await _pump(tester, _ftLineups(), scale: scale);
        expect(tester.takeException(), isNull);
        final slot = _xi.indexOf(_scorer);
        final chip = find.byKey(ValueKey('pitchGoals$slot'));
        final node = find
            .ancestor(of: chip, matching: find.byType(Stack))
            .first;
        _inside(tester, chip, node, 'the goal chip in its node');
        _inside(
          tester,
          find.descendant(of: chip, matching: find.byIcon(Icons.sports_soccer)),
          chip,
          'the ball in its chip',
        );
        final helper = find.byKey(
          ValueKey('pitchGoals${_xi.indexOf(_assister)}'),
        );
        _inside(
          tester,
          find.descendant(
            of: helper,
            matching: find.byIcon(Icons.handshake_rounded),
          ),
          find.ancestor(of: helper, matching: find.byType(Stack)).first,
          'the assist on the pitch',
        );
        // The substitute's chip under the pitch.
        final cameOn = find.byKey(MatchFullTimeLineups.cameOnKey(_sub.id));
        await tester.ensureVisible(cameOn);
        await tester.pumpAndSettle();
        _inside(
          tester,
          find.byKey(PlayerMatchMarks.assistKey(_sub.id)),
          cameOn,
          "the substitute's assist",
        );
        // And the list behind the toggle.
        await tester.tap(find.byKey(MatchFullTimeLineups.listToggleKey));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        _inside(
          tester,
          _ball(_scorer.id),
          find.byKey(MatchLineups.rowKey(_scorer.id)),
          "the full-time list's ball",
        );
        _badgesOnScreen(tester);
      });

      testWidgets('in-match tactics: ON THE PITCH shows goals and assists', (
        tester,
      ) async {
        final squad = [
          for (var i = 0; i < 11; i++)
            player(
              id: i + 1,
              nationId: 1,
              name: _names[i],
              position: Formation.f442.positions[i],
            ),
          for (var i = 12; i <= 16; i++)
            player(id: i, nationId: 1, name: 'Bench$i'),
        ];
        await openEditor(
          tester,
          size: _phone,
          players: squad,
          textScale: scale,
          events: [
            for (var g = 0; g < 2; g++)
              MatchEvent(
                minute: 20 + g,
                type: MatchEventType.goal,
                teamNationId: 1,
                playerId: 10,
                playerName: _longName,
                assistPlayerId: 7,
              ),
          ],
          cardsByPlayer: const {4: MatchCard.yellow},
          ratingByPlayer: {for (var i = 1; i <= 11; i++) i: 6.0 + i / 5},
        );
        final chip = find.text(enL.tacticsTabOnPitch);
        await tester.ensureVisible(chip.first);
        await tester.pumpAndSettle();
        await tester.tap(chip.first);
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(PlayerMatchMarks.goalKey(10)));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final row = find
            .ancestor(
              of: find.byKey(PlayerMatchMarks.goalKey(10)),
              matching: find.byType(InkWell),
            )
            .first;
        _inside(tester, _ball(10), row, 'the ball in the on-pitch row');
        expect(
          find.descendant(
            of: find.byKey(PlayerMatchMarks.goalKey(10)),
            matching: find.text('2'),
          ),
          findsOneWidget,
        );
        final helper = find.byKey(PlayerMatchMarks.assistKey(7));
        _inside(
          tester,
          helper,
          find.ancestor(of: helper, matching: find.byType(InkWell)).first,
          'the assist in the on-pitch row',
        );
        _badgesOnScreen(tester);
      });
    });
  }
}
