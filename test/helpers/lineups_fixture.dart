import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import 'fixtures.dart';

/// Two line-ups mid-match with every band, every marker and a long name, for
/// the line-up rating tests and goldens.
const lineupsHome = 1;
const lineupsAway = 2;

const _homeNames = [
  'Tomas Vrba',
  'Jakub Kriz',
  'Ondrej Maly',
  'Maximilian Hohenberger-Steinbach',
  'Petr Novy',
  'Lukas Cerny',
  'Adam Holy',
  'Vaclav Hruby',
  'Filip Dusek',
  'Martin Kolar',
  'David Zeman',
];
const _awayNames = [
  'Arno Veldt',
  'Bram Koster',
  'Cas Linden',
  'Daan Vos',
  'Eli Brandt',
  'Finn Aalders',
  'Gijs Mol',
  'Hugo Smit',
  'Ivo Kamp',
  'Joep Rook',
  'Kees Baan',
];

List<Player> _xi(int nation, List<String> names) {
  final positions = Formation.f433.positions;
  return [
    for (var i = 0; i < 11; i++)
      player(
        id: nation * 100 + i,
        nationId: nation,
        name: names[i],
        position: positions[i],
      ),
  ];
}

final List<Player> lineupsHomeXi = _xi(lineupsHome, _homeNames);
final List<Player> lineupsAwayXi = _xi(lineupsAway, _awayNames);
final Player lineupsHomeSubOn = player(
  id: 150,
  nationId: lineupsHome,
  name: 'Roman Bily',
  position: PlayerPosition.st,
);
final Player lineupsAwaySubOn = player(
  id: 250,
  nationId: lineupsAway,
  name: 'Lars Dijk',
  position: PlayerPosition.cm,
);
final Player lineupsHomeBench = player(
  id: 151,
  nationId: lineupsHome,
  name: 'Karel Sedy',
  position: PlayerPosition.cb,
);

/// One mark per band edge and beyond, by XI slot.
const _homeMarks = [7.0, 6.0, 5.9, 6.9, 7.9, 8.0, 6.5, 9.1, 4.8, 7.4, 6.2];
const _awayMarks = [6.3, 5.5, 6.1, 6.4, 7.1, 6.6, 6.0, 5.8, 7.7, 6.8, 6.4];

/// The events the clock has reached: a brace with an assist, a booking, a
/// second booking, a straight red, a knock, and a substitution each side.
final List<MatchEvent> lineupsEvents = [
  MatchEvent(
    minute: 12,
    type: MatchEventType.goal,
    teamNationId: lineupsHome,
    playerId: lineupsHomeXi[7].id,
    playerName: lineupsHomeXi[7].name,
    assistPlayerId: lineupsHomeXi[5].id,
  ),
  MatchEvent(
    minute: 31,
    type: MatchEventType.yellowCard,
    teamNationId: lineupsHome,
    playerId: lineupsHomeXi[3].id,
    playerName: lineupsHomeXi[3].name,
  ),
  MatchEvent(
    minute: 40,
    type: MatchEventType.redCard,
    secondYellow: true,
    teamNationId: lineupsHome,
    playerId: lineupsHomeXi[8].id,
    playerName: lineupsHomeXi[8].name,
  ),
  MatchEvent(
    minute: 52,
    type: MatchEventType.goal,
    teamNationId: lineupsHome,
    playerId: lineupsHomeXi[7].id,
    playerName: lineupsHomeXi[7].name,
    assistPlayerId: lineupsHomeXi[5].id,
  ),
  MatchEvent(
    minute: 58,
    type: MatchEventType.redCard,
    teamNationId: lineupsAway,
    playerId: lineupsAwayXi[1].id,
    playerName: lineupsAwayXi[1].name,
  ),
  MatchEvent(
    minute: 60,
    type: MatchEventType.injury,
    teamNationId: lineupsAway,
    playerId: lineupsAwayXi[7].id,
    playerName: lineupsAwayXi[7].name,
  ),
  MatchEvent(
    minute: 63,
    type: MatchEventType.substitution,
    teamNationId: lineupsHome,
    playerId: lineupsHomeSubOn.id,
    playerName: lineupsHomeSubOn.name,
    secondaryPlayerId: lineupsHomeXi[10].id,
    secondaryName: lineupsHomeXi[10].name,
  ),
  MatchEvent(
    minute: 66,
    type: MatchEventType.substitution,
    teamNationId: lineupsAway,
    playerId: lineupsAwaySubOn.id,
    playerName: lineupsAwaySubOn.name,
    secondaryPlayerId: lineupsAwayXi[7].id,
    secondaryName: lineupsAwayXi[7].name,
  ),
  MatchEvent(
    minute: 71,
    type: MatchEventType.goal,
    teamNationId: lineupsAway,
    playerId: lineupsAwayXi[8].id,
    playerName: lineupsAwayXi[8].name,
  ),
];

/// Every mark: both elevens, plus the two who came on.
final Map<int, double> lineupsRatings = {
  for (var i = 0; i < 11; i++) lineupsHomeXi[i].id: _homeMarks[i],
  for (var i = 0; i < 11; i++) lineupsAwayXi[i].id: _awayMarks[i],
  lineupsHomeSubOn.id: 6.7,
  lineupsAwaySubOn.id: 6.1,
};

/// The line-ups as the match screen builds them: the manager's (home) eleven
/// as it stands, with the man taken off replaced; the opponent's as it
/// started.
MatchLineups buildLineups({bool fullTime = false}) => MatchLineups(
  home: [...lineupsHomeXi.take(10), lineupsHomeSubOn],
  away: lineupsAwayXi,
  homeCode: 'CZE',
  awayCode: 'NED',
  homeSubs: [lineupsEvents[6]],
  awaySubs: [lineupsEvents[7]],
  homeBench: [lineupsHomeSubOn, lineupsHomeBench],
  ratings: lineupsRatings,
  energy: {
    for (final p in [...lineupsHomeXi, lineupsHomeSubOn]) p.id: 100 - p.id % 37,
  },
  events: lineupsEvents,
  motmId: fullTime ? lineupsHomeXi[7].id : null,
  live: !fullTime,
);

/// Pumps [child] alone in the app's theme at [size].
Future<void> pumpThemed(WidgetTester tester, Widget child, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: RepaintBoundary(child: child)),
    ),
  );
  await tester.pump();
}
