import 'package:flutter/widgets.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/features/match/score_bug_theme.dart';
import 'package:fnm/features/share/cabinet_share_card.dart';
import 'package:fnm/features/share/match_share_card.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Where a fixture belongs, as the match card heads it: the competition's
/// name, the round (or null) and the trophy artwork (or null).
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
      competition: l.compWorldCupQualifying,
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
      trophy: Trophies.continentalClash,
    ),
    'POSF' || 'POFINAL' => (
      competition: l.compIntercontinentalPlayoff,
      round: round == 'POFINAL' ? l.resultsStageFinal : l.resultsStageSemiFinal,
      trophy: null,
    ),
    'CQ' => (
      competition: l.compQualifiers(continentalCupLabel(l, cont)),
      round: l.matchStageMatchday(f.matchday),
      trophy: null,
    ),
    'NL' || 'NGROUP' => (
      competition: competitionLabel(
        l,
        NationsCups.forConfederation(cont)?.name ?? 'Nations Cup',
      ),
      round: null,
      trophy: Trophies.nationsCup,
    ),
    _ when round.startsWith('N') => (
      competition: competitionLabel(
        l,
        NationsCups.forConfederation(cont)?.name ?? 'Nations Cup',
      ),
      round: stage(round),
      trophy: Trophies.nationsCup,
    ),
    'CGROUP' => (
      competition: continentalCupLabel(l, cont),
      round: l.resultsStageGroupStage,
      trophy: Trophies.forConfederation(cont),
    ),
    _ when round.startsWith('C') => (
      competition: continentalCupLabel(l, cont),
      round: stage(round),
      trophy: Trophies.forConfederation(cont),
    ),
    'GROUP' => (
      competition: competitionLabel(l, 'World Championship'),
      round: l.resultsStageFinalsGroup,
      trophy: Trophies.worldCup,
    ),
    _ => (
      competition: competitionLabel(l, 'World Championship'),
      round: stage(round),
      trophy: Trophies.worldCup,
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
    trophyAsset: occasion.trophy,
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
CabinetShareData? cabinetShareData(AppLocalizations l, ManagerHistory h) {
  final trophies = <ShareTrophy>[
    for (final t in Trophies.cabinet)
      if (h.trophyWins.where((w) => w.key == t.key).toList() case final wins
          when wins.isNotEmpty)
        ShareTrophy(
          label: competitionLabel(l, t.label),
          asset: t.asset,
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
  );
}

/// Every flag a card draws, for warming before it is captured.
Iterable<String> matchShareFlags(MatchShareData d) => {
  d.home.code,
  d.away.code,
  ?d.star?.code,
};

Iterable<String> cabinetShareFlags(CabinetShareData d) => {
  for (final n in d.nations) n.code,
  for (final t in d.trophies) ...t.codes,
};
