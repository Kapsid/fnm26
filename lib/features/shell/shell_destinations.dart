import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The sidebar's headings, top to bottom.
enum ShellSection { home, team, competitions, federation, history }

enum ShellDestinationId {
  hub,
  inbox,
  y,
  squad,
  tactics,
  callUps,
  youth,
  tournaments,
  nationsCup,
  ranking,
  results,
  finances,
  board,
  manager,
  records,
  legends,
  headToHead,
  achievements,
  career,
}

/// One entry in the tablet sidebar.
///
/// Training camp and naturalization are deliberately absent: they are event
/// screens the Continue button opens when they are due, and have nothing to
/// show when opened cold.
class ShellDestination {
  const ShellDestination({
    required this.id,
    required this.section,
    required this.icon,
    required this.path,
    this.query = const {},
    this.alsoActiveOn = const {},
  });

  final ShellDestinationId id;
  final ShellSection section;
  final IconData icon;
  final String path;

  /// Extra query parameters that pick out this destination when two share a
  /// path (Squad is the tactics screen opened on its squad tab).
  final Map<String, String> query;

  /// Other screens that sit under this one, so it stays lit while they are up.
  final Set<String> alsoActiveOn;

  String location(int careerId) => Uri(
    path: path,
    queryParameters: {'careerId': '$careerId', ...query},
  ).toString();
}

const List<ShellDestination> shellDestinations = [
  ShellDestination(
    id: ShellDestinationId.hub,
    section: ShellSection.home,
    icon: Icons.grid_view,
    path: Routes.hub,
    alsoActiveOn: {Routes.matchPreview, Routes.roundResults},
  ),
  ShellDestination(
    id: ShellDestinationId.inbox,
    section: ShellSection.home,
    icon: Icons.mail_outline,
    path: Routes.messages,
  ),
  ShellDestination(
    id: ShellDestinationId.y,
    section: ShellSection.home,
    icon: Icons.tag,
    path: Routes.y,
  ),
  ShellDestination(
    id: ShellDestinationId.squad,
    section: ShellSection.team,
    icon: Icons.groups,
    path: Routes.tactics,
    query: {'tab': '3'},
  ),
  ShellDestination(
    id: ShellDestinationId.tactics,
    section: ShellSection.team,
    icon: Icons.sports_soccer,
    path: Routes.tactics,
  ),
  ShellDestination(
    id: ShellDestinationId.callUps,
    section: ShellSection.team,
    icon: Icons.how_to_reg,
    path: Routes.callUps,
  ),
  ShellDestination(
    id: ShellDestinationId.youth,
    section: ShellSection.team,
    icon: Icons.child_care,
    path: Routes.youth,
  ),
  ShellDestination(
    id: ShellDestinationId.tournaments,
    section: ShellSection.competitions,
    icon: Icons.emoji_events,
    path: Routes.tournaments,
    alsoActiveOn: {
      Routes.cup,
      Routes.continental,
      Routes.continentalClash,
      Routes.intercontinentalPlayoff,
    },
  ),
  ShellDestination(
    id: ShellDestinationId.nationsCup,
    section: ShellSection.competitions,
    icon: Icons.layers,
    path: Routes.nationsCup,
  ),
  ShellDestination(
    id: ShellDestinationId.ranking,
    section: ShellSection.competitions,
    icon: Icons.leaderboard,
    path: Routes.ranking,
  ),
  ShellDestination(
    id: ShellDestinationId.results,
    section: ShellSection.competitions,
    icon: Icons.scoreboard,
    path: Routes.results,
    alsoActiveOn: {Routes.friendlies},
  ),
  ShellDestination(
    id: ShellDestinationId.finances,
    section: ShellSection.federation,
    icon: Icons.account_balance,
    path: Routes.finances,
    alsoActiveOn: {Routes.budgetSetup},
  ),
  ShellDestination(
    id: ShellDestinationId.board,
    section: ShellSection.federation,
    icon: Icons.flag,
    path: Routes.boardObjectives,
  ),
  ShellDestination(
    id: ShellDestinationId.manager,
    section: ShellSection.federation,
    icon: Icons.badge_outlined,
    path: Routes.manager,
  ),
  ShellDestination(
    id: ShellDestinationId.records,
    section: ShellSection.history,
    icon: Icons.menu_book,
    path: Routes.records,
    alsoActiveOn: {Routes.allTimeRecords},
  ),
  ShellDestination(
    id: ShellDestinationId.legends,
    section: ShellSection.history,
    icon: Icons.star_outline,
    path: Routes.legends,
  ),
  ShellDestination(
    id: ShellDestinationId.headToHead,
    section: ShellSection.history,
    icon: Icons.compare_arrows,
    path: Routes.headToHead,
    alsoActiveOn: {Routes.h2hMeetings},
  ),
  ShellDestination(
    id: ShellDestinationId.achievements,
    section: ShellSection.history,
    icon: Icons.military_tech,
    path: Routes.achievements,
    alsoActiveOn: {Routes.challenges},
  ),
  ShellDestination(
    id: ShellDestinationId.career,
    section: ShellSection.history,
    icon: Icons.account_circle,
    path: Routes.careers,
    alsoActiveOn: {Routes.careerSummary, Routes.managerHistory},
  ),
];

/// The destination to highlight for [uri], or null for a screen that has no
/// home in the sidebar (a player page, a nation page).
ShellDestinationId? activeDestination(Uri uri) {
  final onPath = shellDestinations.where((d) => d.path == uri.path).toList();
  if (onPath.isNotEmpty) {
    // Prefer the destination whose extra query matches; otherwise the plain
    // one. `/tactics?tab=3` is Squad, any other `/tactics` is Tactics.
    for (final d in onPath) {
      if (d.query.isNotEmpty &&
          d.query.entries.every((e) => uri.queryParameters[e.key] == e.value)) {
        return d.id;
      }
    }
    return onPath
        .firstWhere((d) => d.query.isEmpty, orElse: () => onPath.first)
        .id;
  }
  for (final d in shellDestinations) {
    if (d.alsoActiveOn.contains(uri.path)) return d.id;
  }
  return null;
}

String shellSectionTitle(AppLocalizations l, ShellSection s) => switch (s) {
  ShellSection.home => l.sideGroupHome,
  ShellSection.team => l.sideGroupTeam,
  ShellSection.competitions => l.sideGroupCompetitions,
  ShellSection.federation => l.sideGroupFederation,
  ShellSection.history => l.sideGroupHistory,
};

String shellDestinationLabel(AppLocalizations l, ShellDestinationId id) =>
    switch (id) {
      ShellDestinationId.hub => l.navHub,
      ShellDestinationId.inbox => l.sideInbox,
      ShellDestinationId.y => l.navY,
      ShellDestinationId.squad => l.sideSquad,
      ShellDestinationId.tactics => l.sideTactics,
      ShellDestinationId.callUps => l.sideCallUps,
      ShellDestinationId.youth => l.youthTitle,
      ShellDestinationId.tournaments => l.sideTournaments,
      ShellDestinationId.nationsCup => l.resultsCategoryNationsCup,
      ShellDestinationId.ranking => l.sideRanking,
      ShellDestinationId.results => l.sideResults,
      ShellDestinationId.finances => l.sideFinances,
      ShellDestinationId.board => l.sideBoard,
      ShellDestinationId.manager => l.sideManager,
      ShellDestinationId.records => l.sideRecords,
      ShellDestinationId.legends => l.sideLegends,
      ShellDestinationId.headToHead => l.sideHeadToHead,
      ShellDestinationId.achievements => l.sideAchievements,
      ShellDestinationId.career => l.sideCareer,
    };
