import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/features/match/score_bug_theme.dart';
import 'package:fnm/features/share/cabinet_share_card.dart';
import 'package:fnm/features/share/match_share_card.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Where a fixture belongs, as the match card heads it: the competition's
/// name exactly as the match screen's banner names it ([MatchStage.category]), the round (or null) and its trophy's key (see [Trophies]; or null).
({String competition, String? round, String? trophy}) shareOccasion(
  AppLocalizations l,
  Fixture f,
  Confederation? conf,
) {
  final round = f.round;
  final cont = conf ?? Confederation.europe;
  String? stage(String r) => MatchStage.stage(l, r);
  return switch (round) {
    null => (
      competition: MatchStage.category(l, round),
      round: l.matchStageMatchday(f.matchday),
      trophy: null,
    ),
    'FRIENDLY' => (
      competition: l.resultsStageFriendly,
      round: null,
      trophy: null,
    ),
    'FFINAL' => (
      competition: l.compContinentalClash,
      round: null,
      trophy: 'continentalclash',
    ),
    'POSF' || 'POFINAL' => (
      competition: l.compIntercontinentalPlayoff,
      round: round == 'POFINAL' ? l.resultsStageFinal : l.resultsStageSemiFinal,
      trophy: null,
    ),
    'CQ' => (
      competition: MatchStage.category(l, round),
      round: l.matchStageMatchday(f.matchday),
      trophy: null,
    ),
    'NL' || 'NGROUP' => (
      competition: MatchStage.category(l, round),
      round: null,
      trophy: 'nationscup',
    ),
    _ when round.startsWith('N') => (
      competition: MatchStage.category(l, round),
      round: stage(round),
      trophy: 'nationscup',
    ),
    'CGROUP' => (
      competition: MatchStage.category(l, round),
      round: l.resultsStageGroupStage,
      trophy: cont.name,
    ),
    _ when round.startsWith('C') => (
      competition: MatchStage.category(l, round),
      round: stage(round),
      trophy: cont.name,
    ),
    'GROUP' => (
      competition: MatchStage.category(l, round),
      round: l.resultsStageFinalsGroup,
      trophy: 'world',
    ),
    _ => (
      competition: MatchStage.category(l, round),
      round: stage(round),
      trophy: 'world',
    ),
  };
}

/// The match card for a finished match: the manager's own, at full time.
///
/// [outcome] is the knockout's extra time and shootout, when there was one:
/// the card shows the LEVEL score and the shootout beside it, not the extra
/// goal the stored result credits the winner with.
MatchShareData matchShareData(
  BuildContext context, {
  required Fixture fixture,
  required Map<int, Nation> nations,
  required MatchResult result,
  required MatchGround ground,
  required Confederation? confederation,
  required ActiveWorld world,
  KnockoutOutcome? outcome,
}) {
  final l = AppLocalizations.of(context);
  final homeId = fixture.homeNationId;
  final awayId = fixture.awayNationId;
  ShareSide side(int id, int goals) {
    final n = nations[id];
    return ShareSide(
      name: n?.name ?? '',
      code: n?.code ?? '',
      color: AppColors.hex(n?.primaryColor ?? '#8E9195'),
      goals: goals,
    );
  }

  final (home, away) = outcome == null
      ? (result.homeScore, result.awayScore)
      : (outcome.homeScore, outcome.awayScore);
  final shootout = outcome?.wentToShootout ?? false;
  final occasion = shareOccasion(l, fixture, confederation);
  final star = result.manOfTheMatch;
  return MatchShareData(
    home: side(homeId, home),
    away: side(awayId, away),
    competition: occasion.competition,
    round: occasion.round,
    trophyAsset: switch (occasion.trophy) {
      final key? => Trophies.assetForKey(key),
      null => null,
    },
    trophyImage: switch (occasion.trophy) {
      final key? => world.trophy(key),
      null => null,
    },
    dateLabel: AppDate.dayMonthYear(context, fixture.date),
    venue: [
      ground.stadium,
      ground.city,
    ].where((s) => s.trim().isNotEmpty).join(', '),
    plateTheme: ScoreBugTheme.forRound(fixture.round, confederation),
    extraTime: outcome != null,
    homePens: shootout ? outcome!.homePens : null,
    awayPens: shootout ? outcome!.awayPens : null,
    goals: [
      for (final e in result.events)
        if (e.type == MatchEventType.goal)
          ShareGoal(
            scorer: e.playerName,
            minute: e.minute,
            stoppage: e.stoppage,
            home: e.teamNationId == homeId,
            penalty: e.penalty,
            ownGoal: e.ownGoal,
          ),
    ],
    star: star == null
        ? null
        : ShareStar(
            name: star.playerName,
            code: nations[star.teamNationId]?.code ?? '',
            rating: star.rating,
          ),
    homePossession: result.homePossession,
    homeShots: result.homeShots,
    awayShots: result.awayShots,
  );
}

/// The manager's trophy cabinet as the share card shows it, or null when he
/// has not won anything yet (there is nothing to share).
///
/// [world] is the career's world: a custom one's own trophy pictures are
/// drawn, as the in-game cabinet draws them.
CabinetShareData? cabinetShareData(
  AppLocalizations l,
  ManagerHistory h,
  ActiveWorld world,
) {
  final trophies = <ShareTrophy>[
    for (final t in Trophies.cabinet)
      if (h.trophyWins.where((w) => w.key == t.key).toList() case final wins
          when wins.isNotEmpty)
        ShareTrophy(
          label: competitionLabel(l, t.label),
          asset: t.asset,
          image: world.trophy(t.key),
          wins: [
            for (final w in wins) (year: w.year, code: w.nation?.code ?? ''),
          ],
        ),
  ];
  if (trophies.isEmpty) return null;
  // Cycles are newest first, so the current side leads.
  final nations = <ShareNation>[];
  for (final c in h.cycles) {
    final n = c.nation;
    if (n == null || nations.any((x) => x.code == n.code)) continue;
    nations.add((code: n.code, name: n.name));
  }
  return CabinetShareData(
    managerName: h.managerName,
    nations: nations,
    trophies: trophies,
    record: (played: h.played, won: h.won, drawn: h.drawn, lost: h.lost),
  );
}

/// Every flag a card draws, for warming before it is captured.
Iterable<String> matchShareFlags(MatchShareData d) => {
  d.home.code,
  d.away.code,
  ?d.star?.code,
};

/// Every custom trophy picture a card draws, for warming before capture.
Iterable<Uint8List> matchShareImages(MatchShareData d) => [?d.trophyImage];

Iterable<Uint8List> cabinetShareImages(CabinetShareData d) => [
  for (final t in d.trophies) ?t.image,
];

Iterable<String> cabinetShareFlags(CabinetShareData d) => {
  for (final n in d.nations) n.code,
  for (final t in d.trophies) ...t.codes,
};
