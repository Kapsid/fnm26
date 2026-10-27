import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_post_detail.dart';
import 'package:fnm/features/y/y_profile_sheet.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/features/y/y_trends.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'y_tablet_layout.dart';

/// The words for a post.
///
/// EXHAUSTIVE on purpose — no default branch. A `_ => \'\'` fallback would turn a
/// missing string into an invisible bug: the post renders as an empty row and
/// nobody notices for a year. The widget test walks every (template, variant)
/// pair, and a hole here fails it loudly.
String yPostBody(AppLocalizations l, YPost p) {
  final a0 = p.args.isNotEmpty ? p.args[0] : '';
  final a1 = p.args.length > 1 ? p.args[1] : '';
  final a2 = p.args.length > 2 ? p.args[2] : '';
  return switch ((p.template, p.variant)) {
    (YTemplate.winUpset, final v) when v < YFeed.bigVariantCount => _deepened(
      v,
      [
        l.yWinUpset0(a0, a1),
        l.yWinUpset1(a0, a1),
        l.yWinUpset2(a0, a1),
        l.yWinUpset3(a0, a1),
        l.yWinUpset4(a0, a1),
        l.yWinUpset5(a0, a1),
        l.yWinUpset6(a0, a1),
        l.yWinUpset7(a0, a1),
        l.yWinUpset8(a0, a1),
        l.yWinUpset9(a0, a1),
        l.yWinUpset10(a0, a1),
        l.yWinUpset11(a0, a1),
        l.yWinUpset12(a0, a1),
        l.yWinUpset13(a0, a1),
        l.yWinUpset14(a0, a1),
        l.yWinUpset15(a0, a1),
        l.yWinUpset16(a0, a1),
        l.yWinUpset17(a0, a1),
        l.yWinUpset18(a0, a1),
        l.yWinUpset19(a0, a1),
        l.yWinUpset20(a0, a1),
        l.yWinUpset21(a0, a1),
        l.yWinUpset22(a0, a1),
        l.yWinUpset23(a0, a1),
      ],
    ),
    (YTemplate.lostBadly, final v) when v < YFeed.bigVariantCount => _deepened(
      v,
      [
        l.yLostBadly0(a0, a1),
        l.yLostBadly1(a0, a1),
        l.yLostBadly2(a0, a1),
        l.yLostBadly3(a0, a1),
        l.yLostBadly4(a0, a1),
        l.yLostBadly5(a0, a1),
        l.yLostBadly6(a0, a1),
        l.yLostBadly7(a0, a1),
        l.yLostBadly8(a0, a1),
        l.yLostBadly9(a0, a1),
        l.yLostBadly10(a0, a1),
        l.yLostBadly11(a0, a1),
        l.yLostBadly12(a0, a1),
        l.yLostBadly13(a0, a1),
        l.yLostBadly14(a0, a1),
        l.yLostBadly15(a0, a1),
        l.yLostBadly16(a0, a1),
        l.yLostBadly17(a0, a1),
        l.yLostBadly18(a0, a1),
        l.yLostBadly19(a0, a1),
        l.yLostBadly20(a0, a1),
        l.yLostBadly21(a0, a1),
        l.yLostBadly22(a0, a1),
        l.yLostBadly23(a0, a1),
      ],
    ),
    (YTemplate.winRout, final v) when v < YFeed.everyMatchVariantCount => [
      l.yWinRout0(a0, a1),
      l.yWinRout1(a0, a1),
      l.yWinRout2(a0, a1),
      l.yWinRout3(a0, a1),
      l.yWinRout4(a0, a1),
      l.yWinRout5(a0, a1),
      l.yWinRout6(a0, a1),
      l.yWinRout7(a0, a1),
      l.yWinRout8(a0, a1),
      l.yWinRout9(a0, a1),
      l.yWinRout10(a0, a1),
      l.yWinRout11(a0, a1),
      l.yWinRout12(a0, a1),
      l.yWinRout13(a0, a1),
      l.yWinRout14(a0, a1),
      l.yWinRout15(a0, a1),
      l.yWinRout16(a0, a1),
      l.yWinRout17(a0, a1),
    ][v],
    (YTemplate.winShootout, final v) when v < YFeed.extraVariantCount => [
      l.yWinShootout0(a0),
      l.yWinShootout1(a0),
      l.yWinShootout2(a0),
      l.yWinShootout3(a0),
      l.yWinShootout4(a0),
      l.yWinShootout5(a0),
      l.yWinShootout6(a0),
      l.yWinShootout7(a0),
      l.yWinShootout8(a0),
    ][v],
    (YTemplate.knockoutWin, final v) when v < YFeed.bigMidVariantCount => [
      l.yKnockoutWin0(a0, a1),
      l.yKnockoutWin1(a0, a1),
      l.yKnockoutWin2(a0, a1),
      l.yKnockoutWin3(a0, a1),
      l.yKnockoutWin4(a0, a1),
      l.yKnockoutWin5(a0, a1),
      l.yKnockoutWin6(a0, a1),
      l.yKnockoutWin7(a0, a1),
      l.yKnockoutWin8(a0, a1),
      l.yKnockoutWin9(a0, a1),
      l.yKnockoutWin10(a0, a1),
      l.yKnockoutWin11(a0, a1),
    ][v],
    (YTemplate.upsetGap, final v) when v < YFeed.extraVariantCount => [
      l.yUpsetGap0(a0, a1),
      l.yUpsetGap1(a0, a1),
      l.yUpsetGap2(a0, a1),
      l.yUpsetGap3(a0, a1),
      l.yUpsetGap4(a0, a1),
      l.yUpsetGap5(a0, a1),
      l.yUpsetGap6(a0, a1),
      l.yUpsetGap7(a0, a1),
      l.yUpsetGap8(a1),
    ][v],
    (YTemplate.eatWords, final v) when v < YFeed.extraVariantCount => [
      l.yEatWords0(a0),
      l.yEatWords1(a0),
      l.yEatWords2(a0),
      l.yEatWords3(a0),
      l.yEatWords4(a0),
      l.yEatWords5(a0),
      l.yEatWords6(a0),
      l.yEatWords7(a0),
      l.yEatWords8(a0),
    ][v],
    (YTemplate.awayFansWin, final v) when v < YFeed.extraVariantCount => [
      l.yAwayFansWin0(a0, a1),
      l.yAwayFansWin1(a0, a1),
      l.yAwayFansWin2(a0, a1),
      l.yAwayFansWin3(a0, a1),
      l.yAwayFansWin4(a0, a1),
      l.yAwayFansWin5(a0, a1),
      l.yAwayFansWin6(a0, a1),
      l.yAwayFansWin7(a0, a1),
      l.yAwayFansWin8(a0, a1),
    ][v],
    (YTemplate.neutralWin, final v) when v < YFeed.extraVariantCount => [
      l.yNeutralWin0(a0, a1, a2),
      l.yNeutralWin1(a0, a1, a2),
      l.yNeutralWin2(a0, a1, a2),
      l.yNeutralWin3(a0, a1, a2),
      l.yNeutralWin4(a0, a1, a2),
      l.yNeutralWin5(a0, a1, a2),
      l.yNeutralWin6(a0, a1, a2),
      l.yNeutralWin7(a0, a1, a2),
      l.yNeutralWin8(a0, a1, a2),
    ][v],
    (YTemplate.scorerHero, final v) when v < YFeed.extraVariantCount => [
      l.yScorerHero0(a0, a1),
      l.yScorerHero1(a0, a1),
      l.yScorerHero2(a0, a1),
      l.yScorerHero3(a0, a1),
      l.yScorerHero4(a0, a1),
      l.yScorerHero5(a0, a1),
      l.yScorerHero6(a0, a1),
      l.yScorerHero7(a0, a1),
      l.yScorerHero8(a0, a1),
    ][v],
    (YTemplate.lostShock, final v) when v < YFeed.bigMidVariantCount => [
      l.yLostShock0(a0, a1),
      l.yLostShock1(a0, a1),
      l.yLostShock2(a0, a1),
      l.yLostShock3(a0, a1),
      l.yLostShock4(a0, a1),
      l.yLostShock5(a0, a1),
      l.yLostShock6(a0, a1),
      l.yLostShock7(a0, a1),
      l.yLostShock8(a0, a1),
      l.yLostShock9(a0, a1),
      l.yLostShock10(a0, a1),
      l.yLostShock11(a0, a1),
    ][v],
    (YTemplate.lostRout, final v) when v < YFeed.bigMidVariantCount => [
      l.yLostRout0(a0, a1),
      l.yLostRout1(a0, a1),
      l.yLostRout2(a0, a1),
      l.yLostRout3(a0, a1),
      l.yLostRout4(a0, a1),
      l.yLostRout5(a0, a1),
      l.yLostRout6(a0, a1),
      l.yLostRout7(a0, a1),
      l.yLostRout8(a0, a1),
      l.yLostRout9(a0, a1),
      l.yLostRout10(a0, a1),
      l.yLostRout11(a0, a1),
    ][v],
    (YTemplate.lostShootout, final v) when v < YFeed.extraVariantCount => [
      l.yLostShootout0(a0),
      l.yLostShootout1(a0),
      l.yLostShootout2(a0),
      l.yLostShootout3(a0),
      l.yLostShootout4(a0),
      l.yLostShootout5(a0),
      l.yLostShootout6(a0),
      l.yLostShootout7(a0),
      l.yLostShootout8(a0),
    ][v],
    (YTemplate.knockoutLoss, final v) when v < YFeed.bigMidVariantCount => [
      l.yKnockoutLoss0(a0, a1),
      l.yKnockoutLoss1(a0, a1),
      l.yKnockoutLoss2(a0, a1),
      l.yKnockoutLoss3(a0, a1),
      l.yKnockoutLoss4(a0, a1),
      l.yKnockoutLoss5(a0, a1),
      l.yKnockoutLoss6(a0, a1),
      l.yKnockoutLoss7(a0, a1),
      l.yKnockoutLoss8(a0, a1),
      l.yKnockoutLoss9(a0, a1),
      l.yKnockoutLoss10(a0, a1),
      l.yKnockoutLoss11(a0, a1),
    ][v],
    (YTemplate.awayFansGloat, final v) when v < YFeed.extraVariantCount => [
      l.yAwayFansGloat0(a0, a1),
      l.yAwayFansGloat1(a0, a1),
      l.yAwayFansGloat2(a0, a1),
      l.yAwayFansGloat3(a0, a1),
      l.yAwayFansGloat4(a0, a1),
      l.yAwayFansGloat5(a0, a1),
      l.yAwayFansGloat6(a0, a1),
      l.yAwayFansGloat7(a0, a1),
      l.yAwayFansGloat8(a0, a1),
    ][v],
    (YTemplate.neutralLoss, final v) when v < YFeed.extraVariantCount => [
      l.yNeutralLoss0(a0, a1, a2),
      l.yNeutralLoss1(a0, a1, a2),
      l.yNeutralLoss2(a0, a1, a2),
      l.yNeutralLoss3(a0, a1, a2),
      l.yNeutralLoss4(a0, a1, a2),
      l.yNeutralLoss5(a0, a1, a2),
      l.yNeutralLoss6(a0, a1, a2),
      l.yNeutralLoss7(a0, a1, a2),
      l.yNeutralLoss8(a0, a1, a2),
    ][v],
    (YTemplate.downGap, final v) when v < YFeed.extraVariantCount => [
      l.yDownGap0(a0, a1),
      l.yDownGap1(a1),
      l.yDownGap2(a0, a1),
      l.yDownGap3(a0, a1),
      l.yDownGap4(a0, a1),
      l.yDownGap5(a0, a1),
      l.yDownGap6(a0, a1),
      l.yDownGap7(a1),
      l.yDownGap8(a0, a1),
    ][v],
    (YTemplate.drewHeroic, final v) when v < YFeed.bigMidVariantCount => [
      l.yDrewHeroic0(a0, a1),
      l.yDrewHeroic1(a0, a1),
      l.yDrewHeroic2(a0, a1),
      l.yDrewHeroic3(a0, a1),
      l.yDrewHeroic4(a0, a1),
      l.yDrewHeroic5(a0, a1),
      l.yDrewHeroic6(a0, a1),
      l.yDrewHeroic7(a0, a1),
      l.yDrewHeroic8(a0, a1),
      l.yDrewHeroic9(a0, a1),
      l.yDrewHeroic10(a0, a1),
      l.yDrewHeroic11(a0, a1),
    ][v],
    (YTemplate.drewShame, final v) when v < YFeed.bigMidVariantCount => [
      l.yDrewShame0(a0, a1),
      l.yDrewShame1(a0, a1),
      l.yDrewShame2(a0, a1),
      l.yDrewShame3(a0, a1),
      l.yDrewShame4(a0, a1),
      l.yDrewShame5(a0, a1),
      l.yDrewShame6(a0, a1),
      l.yDrewShame7(a0, a1),
      l.yDrewShame8(a0, a1),
      l.yDrewShame9(a0, a1),
      l.yDrewShame10(a0, a1),
      l.yDrewShame11(a0, a1),
    ][v],
    (YTemplate.winRoutine, final v) when v < YFeed.everyMatchVariantCount =>
      _deepened(v, [
        l.yWinRoutine0(a0, a1),
        l.yWinRoutine1(a0, a1),
        l.yWinRoutine2(a0, a1),
        l.yWinRoutine3(a0, a1),
        l.yWinRoutine4(a0, a1),
        l.yWinRoutine5(a0, a1),
        l.yWinRoutine6(a0, a1),
        l.yWinRoutine7(a0, a1),
        l.yWinRoutine8(a0, a1),
        l.yWinRoutine9(a0, a1),
        l.yWinRoutine10(a0, a1),
        l.yWinRoutine11(a0, a1),
        l.yWinRoutine12(a0, a1),
        l.yWinRoutine13(a0, a1),
        l.yWinRoutine14(a0, a1),
        l.yWinRoutine15(a0, a1),
        l.yWinRoutine16(a0, a1),
        l.yWinRoutine17(a0, a1),
      ]),
    (YTemplate.winTight, final v) when v < YFeed.everyMatchVariantCount =>
      _deepened(v, [
        l.yWinTight0(a0, a1),
        l.yWinTight1(a0, a1),
        l.yWinTight2(a0, a1),
        l.yWinTight3(a0, a1),
        l.yWinTight4(a0, a1),
        l.yWinTight5(a0, a1),
        l.yWinTight6(a0, a1),
        l.yWinTight7(a0, a1),
        l.yWinTight8(a0, a1),
        l.yWinTight9(a0, a1),
        l.yWinTight10(a0, a1),
        l.yWinTight11(a0, a1),
        l.yWinTight12(a0, a1),
        l.yWinTight13(a0, a1),
        l.yWinTight14(a0, a1),
        l.yWinTight15(a0, a1),
        l.yWinTight16(a0, a1),
        l.yWinTight17(a0, a1),
      ]),
    (YTemplate.drew, final v) when v < YFeed.everyMatchVariantCount =>
      _deepened(v, [
        l.yDrew0(a0, a1),
        l.yDrew1(a0, a1),
        l.yDrew2(a0, a1),
        l.yDrew3(a0, a1),
        l.yDrew4(a0, a1),
        l.yDrew5(a0, a1),
        l.yDrew6(a0, a1),
        l.yDrew7(a0, a1),
        l.yDrew8(a0, a1),
        l.yDrew9(a0, a1),
        l.yDrew10(a0, a1),
        l.yDrew11(a0, a1),
        l.yDrew12(a0, a1),
        l.yDrew13(a0, a1),
        l.yDrew14(a0, a1),
        l.yDrew15(a0, a1),
        l.yDrew16(a0, a1),
        l.yDrew17(a0, a1),
      ]),
    (YTemplate.lost, final v) when v < YFeed.everyMatchVariantCount =>
      _deepened(v, [
        l.yLost0(a0, a1),
        l.yLost1(a0, a1),
        l.yLost2(a0, a1),
        l.yLost3(a0, a1),
        l.yLost4(a0, a1),
        l.yLost5(a0, a1),
        l.yLost6(a0, a1),
        l.yLost7(a0, a1),
        l.yLost8(a0, a1),
        l.yLost9(a0, a1),
        l.yLost10(a0, a1),
        l.yLost11(a0, a1),
        l.yLost12(a0, a1),
        l.yLost13(a0, a1),
        l.yLost14(a0, a1),
        l.yLost15(a0, a1),
        l.yLost16(a0, a1),
        l.yLost17(a0, a1),
      ]),
    (YTemplate.trophy, 0) => l.yTrophy0(a0),
    (YTemplate.trophy, 1) => l.yTrophy1(a0),
    (YTemplate.trophy, 2) => l.yTrophy2(a0),
    (YTemplate.trophy, 3) => l.yTrophy3(a0),
    (YTemplate.runnerUp, 0) => l.yRunnerUp0(a0),
    (YTemplate.runnerUp, 1) => l.yRunnerUp1(a0),
    (YTemplate.runnerUp, 2) => l.yRunnerUp2(a0),
    (YTemplate.runnerUp, 3) => l.yRunnerUp3(a0),
    (YTemplate.eliminated, 0) => l.yEliminated0(a0),
    (YTemplate.eliminated, 1) => l.yEliminated1(a0),
    (YTemplate.eliminated, 2) => l.yEliminated2(a0),
    (YTemplate.eliminated, 3) => l.yEliminated3(a0),
    (YTemplate.qualified, 0) => l.yQualified0(a0),
    (YTemplate.qualified, 1) => l.yQualified1(a0),
    (YTemplate.qualified, 2) => l.yQualified2(a0),
    (YTemplate.qualified, 3) => l.yQualified3(a0),
    (YTemplate.groupDrawn, 0) => l.yGroupDrawn0(a0),
    (YTemplate.groupDrawn, 1) => l.yGroupDrawn1(a0),
    (YTemplate.groupDrawn, 2) => l.yGroupDrawn2(a0),
    (YTemplate.groupDrawn, 3) => l.yGroupDrawn3(a0),
    (YTemplate.hostNamed, 0) => l.yHostNamed0(a0),
    (YTemplate.hostNamed, 1) => l.yHostNamed1(a0),
    (YTemplate.hostNamed, 2) => l.yHostNamed2(a0),
    (YTemplate.hostNamed, 3) => l.yHostNamed3(a0),
    (YTemplate.tournamentSoon, 0) => l.yTournamentSoon0(a0),
    (YTemplate.tournamentSoon, 1) => l.yTournamentSoon1(a0),
    (YTemplate.tournamentSoon, 2) => l.yTournamentSoon2(a0),
    (YTemplate.tournamentSoon, 3) => l.yTournamentSoon3(a0),
    (YTemplate.finalLooms, 0) => l.yFinalLooms0(a0),
    (YTemplate.finalLooms, 1) => l.yFinalLooms1(a0),
    (YTemplate.finalLooms, 2) => l.yFinalLooms2(a0),
    (YTemplate.finalLooms, 3) => l.yFinalLooms3(a0),
    (YTemplate.playerGrievance, 0) => l.yPlayerGrievance0,
    (YTemplate.playerGrievance, 1) => l.yPlayerGrievance1,
    (YTemplate.playerGrievance, 2) => l.yPlayerGrievance2,
    (YTemplate.playerGrievance, 3) => l.yPlayerGrievance3,
    (YTemplate.legendRetires, 0) => l.yLegendRetires0(a0),
    (YTemplate.legendRetires, 1) => l.yLegendRetires1(a0),
    (YTemplate.legendRetires, 2) => l.yLegendRetires2(a0),
    (YTemplate.legendRetires, 3) => l.yLegendRetires3(a0),
    (YTemplate.scorerStar, 0) => l.yScorerStar0(a0, a1),
    (YTemplate.scorerStar, 1) => l.yScorerStar1(a0, a1),
    (YTemplate.scorerStar, 2) => l.yScorerStar2(a0, a1),
    (YTemplate.scorerStar, 3) => l.yScorerStar3(a0, a1),
    (YTemplate.scorerStar, 4) => l.yScorerStar4(a0, a1),
    (YTemplate.scorerStar, 5) => l.yScorerStar5(a0, a1),
    (YTemplate.scorerStar, 6) => l.yScorerStar6(a0, a1),
    (YTemplate.scorerStar, 7) => l.yScorerStar7(a0, a1),
    (YTemplate.winStreak, 0) => l.yWinStreak0(a0),
    (YTemplate.winStreak, 1) => l.yWinStreak1(a0),
    (YTemplate.winStreak, 2) => l.yWinStreak2(a0),
    (YTemplate.winStreak, 3) => l.yWinStreak3(a0),
    (YTemplate.winStreak, 4) => l.yWinStreak4(a0),
    (YTemplate.winStreak, 5) => l.yWinStreak5(a0),
    (YTemplate.winStreak, 6) => l.yWinStreak6(a0),
    (YTemplate.winStreak, 7) => l.yWinStreak7(a0),
    (YTemplate.lossStreak, 0) => l.yLossStreak0(a0),
    (YTemplate.lossStreak, 1) => l.yLossStreak1(a0),
    (YTemplate.lossStreak, 2) => l.yLossStreak2(a0),
    (YTemplate.lossStreak, 3) => l.yLossStreak3(a0),
    (YTemplate.lossStreak, 4) => l.yLossStreak4(a0),
    (YTemplate.lossStreak, 5) => l.yLossStreak5(a0),
    (YTemplate.lossStreak, 6) => l.yLossStreak6(a0),
    (YTemplate.lossStreak, 7) => l.yLossStreak7(a0),
    (YTemplate.rivalry, 0) => l.yRivalry0(a0, a1),
    (YTemplate.rivalry, 1) => l.yRivalry1(a0, a1),
    (YTemplate.rivalry, 2) => l.yRivalry2(a0, a1),
    (YTemplate.rivalry, 3) => l.yRivalry3(a0, a1),
    (YTemplate.rivalry, 4) => l.yRivalry4(a0, a1),
    (YTemplate.rivalry, 5) => l.yRivalry5(a0, a1),
    (YTemplate.rivalry, 6) => l.yRivalry6(a0, a1),
    (YTemplate.rivalry, 7) => l.yRivalry7(a0, a1),
    (YTemplate.injuryBlow, 0) => l.yInjuryBlow0(a0),
    (YTemplate.injuryBlow, 1) => l.yInjuryBlow1(a0),
    (YTemplate.injuryBlow, 2) => l.yInjuryBlow2(a0),
    (YTemplate.injuryBlow, 3) => l.yInjuryBlow3(a0),
    (YTemplate.injuryBlow, 4) => l.yInjuryBlow4(a0),
    (YTemplate.injuryBlow, 5) => l.yInjuryBlow5(a0),
    (YTemplate.injuryBlow, 6) => l.yInjuryBlow6(a0),
    (YTemplate.injuryBlow, 7) => l.yInjuryBlow7(a0),
    (YTemplate.sentOff, 0) => l.ySentOff0(a0, a1),
    (YTemplate.sentOff, 1) => l.ySentOff1(a0, a1),
    (YTemplate.sentOff, 2) => l.ySentOff2(a0, a1),
    (YTemplate.sentOff, 3) => l.ySentOff3(a0, a1),
    (YTemplate.sentOff, 4) => l.ySentOff4(a0, a1),
    (YTemplate.sentOff, 5) => l.ySentOff5(a0, a1),
    (YTemplate.sentOff, 6) => l.ySentOff6(a0, a1),
    (YTemplate.sentOff, 7) => l.ySentOff7(a0, a1),
    // The two whose Czech is not a translation of its English: see the copy's
    // own note. Nothing here knows that; it asks for wording n and prints what
    // the language hands back.
    (YTemplate.turnedItRound, 0) => l.yTurnedItRound0(a0),
    (YTemplate.turnedItRound, 1) => l.yTurnedItRound1(a0),
    (YTemplate.turnedItRound, 2) => l.yTurnedItRound2(a0),
    (YTemplate.turnedItRound, 3) => l.yTurnedItRound3(a0),
    (YTemplate.turnedItRound, 4) => l.yTurnedItRound4(a0),
    (YTemplate.turnedItRound, 5) => l.yTurnedItRound5(a0),
    (YTemplate.threwItAway, 0) => l.yThrewItAway0(a0),
    (YTemplate.threwItAway, 1) => l.yThrewItAway1(a0),
    (YTemplate.threwItAway, 2) => l.yThrewItAway2(a0),
    (YTemplate.threwItAway, 3) => l.yThrewItAway3(a0),
    (YTemplate.threwItAway, 4) => l.yThrewItAway4(a0),
    (YTemplate.threwItAway, 5) => l.yThrewItAway5(a0),
    (YTemplate.boardPressure, 0) => l.yBoardPressure0,
    (YTemplate.boardPressure, 1) => l.yBoardPressure1,
    (YTemplate.boardPressure, 2) => l.yBoardPressure2,
    (YTemplate.boardPressure, 3) => l.yBoardPressure3,
    (YTemplate.boardPressure, 4) => l.yBoardPressure4,
    (YTemplate.boardPressure, 5) => l.yBoardPressure5,
    (YTemplate.boardPressure, 6) => l.yBoardPressure6,
    (YTemplate.boardPressure, 7) => l.yBoardPressure7,
    (YTemplate.statementKept, 0) => l.yStatementKept0(a0),
    (YTemplate.statementKept, 1) => l.yStatementKept1(a0),
    (YTemplate.statementKept, 2) => l.yStatementKept2(a0),
    (YTemplate.statementKept, 3) => l.yStatementKept3(a0),
    (YTemplate.statementKept, 4) => l.yStatementKept4(a0),
    (YTemplate.statementKept, 5) => l.yStatementKept5(a0),
    (YTemplate.statementBroken, 0) => l.yStatementBroken0(a0),
    (YTemplate.statementBroken, 1) => l.yStatementBroken1(a0),
    (YTemplate.statementBroken, 2) => l.yStatementBroken2(a0),
    (YTemplate.statementBroken, 3) => l.yStatementBroken3(a0),
    (YTemplate.statementBroken, 4) => l.yStatementBroken4(a0),
    (YTemplate.statementBroken, 5) => l.yStatementBroken5(a0),
    (YTemplate.debut, 0) => l.yDebut0(a0),
    (YTemplate.debut, 1) => l.yDebut1(a0),
    (YTemplate.debut, 2) => l.yDebut2(a0),
    (YTemplate.debut, 3) => l.yDebut3(a0),
    (YTemplate.debut, 4) => l.yDebut4(a0),
    (YTemplate.debut, 5) => l.yDebut5(a0),
    (YTemplate.drought, 0) => l.yDrought0(a0, a1),
    (YTemplate.drought, 1) => l.yDrought1(a0, a1),
    (YTemplate.drought, 2) => l.yDrought2(a0, a1),
    (YTemplate.drought, 3) => l.yDrought3(a0, a1),
    (YTemplate.drought, 4) => l.yDrought4(a0, a1),
    (YTemplate.drought, 5) => l.yDrought5(a0, a1),
    (YTemplate.rivalryLooms, 0) => l.yRivalryLooms0(a0, a1),
    (YTemplate.rivalryLooms, 1) => l.yRivalryLooms1(a0, a1),
    (YTemplate.rivalryLooms, 2) => l.yRivalryLooms2(a0, a1),
    (YTemplate.rivalryLooms, 3) => l.yRivalryLooms3(a0, a1),
    (YTemplate.rivalryLooms, 4) => l.yRivalryLooms4(a0, a1),
    (YTemplate.rivalryLooms, 5) => l.yRivalryLooms5(a0, a1),
    // A reply's words come from its MOOD, not from what happened — one set of
    (YTemplate.againstThemAgain, 0) => l.yAgainstThemAgain0(a0, a1),
    (YTemplate.againstThemAgain, 1) => l.yAgainstThemAgain1(a0, a1),
    (YTemplate.againstThemAgain, 2) => l.yAgainstThemAgain2(a0, a1),
    (YTemplate.againstThemAgain, 3) => l.yAgainstThemAgain3(a0, a1),
    (YTemplate.againstThemAgain, 4) => l.yAgainstThemAgain4(a0, a1),
    (YTemplate.againstThemAgain, 5) => l.yAgainstThemAgain5(a0, a1),
    (YTemplate.sameOldStory, 0) => l.ySameOldStory0(a0),
    (YTemplate.sameOldStory, 1) => l.ySameOldStory1(a0),
    (YTemplate.sameOldStory, 2) => l.ySameOldStory2(a0),
    (YTemplate.sameOldStory, 3) => l.ySameOldStory3(a0),
    (YTemplate.sameOldStory, 4) => l.ySameOldStory4(a0),
    (YTemplate.sameOldStory, 5) => l.ySameOldStory5(a0),
    (YTemplate.toldYouSo, 0) => l.yToldYouSo0,
    (YTemplate.toldYouSo, 1) => l.yToldYouSo1,
    (YTemplate.toldYouSo, 2) => l.yToldYouSo2,
    (YTemplate.toldYouSo, 3) => l.yToldYouSo3,
    (YTemplate.toldYouSo, 4) => l.yToldYouSo4,
    (YTemplate.toldYouSo, 5) => l.yToldYouSo5,
    (YTemplate.fansProtest, 0) => l.yFansProtest0(a0, a1),
    (YTemplate.fansProtest, 1) => l.yFansProtest1(a0, a1),
    (YTemplate.fansProtest, 2) => l.yFansProtest2(a0, a1),
    (YTemplate.fansProtest, 3) => l.yFansProtest3(a0, a1),
    (YTemplate.fansProtest, 4) => l.yFansProtest4(a0, a1),
    (YTemplate.fansProtest, 5) => l.yFansProtest5(a0, a1),
    (YTemplate.fansSellOut, 0) => l.yFansSellOut0(a0),
    (YTemplate.fansSellOut, 1) => l.yFansSellOut1(a0),
    (YTemplate.fansSellOut, 2) => l.yFansSellOut2(a0),
    (YTemplate.fansSellOut, 3) => l.yFansSellOut3(a0),
    (YTemplate.fansSellOut, 4) => l.yFansSellOut4(a0),
    (YTemplate.fansSellOut, 5) => l.yFansSellOut5(a0),
    (YTemplate.scandalParty, 0) => l.yScandalParty0(a0, a1),
    (YTemplate.scandalParty, 1) => l.yScandalParty1(a0, a1),
    (YTemplate.scandalParty, 2) => l.yScandalParty2(a0, a1),
    (YTemplate.scandalCurfew, 0) => l.yScandalCurfew0(a0, a1),
    (YTemplate.scandalCurfew, 1) => l.yScandalCurfew1(a0, a1),
    (YTemplate.scandalCurfew, 2) => l.yScandalCurfew2(a0, a1),
    (YTemplate.scandalNightclub, 0) => l.yScandalNightclub0(a0, a1),
    (YTemplate.scandalNightclub, 1) => l.yScandalNightclub1(a0, a1),
    (YTemplate.scandalNightclub, 2) => l.yScandalNightclub2(a0, a1),
    (YTemplate.scandalCasino, 0) => l.yScandalCasino0(a0, a1),
    (YTemplate.scandalCasino, 1) => l.yScandalCasino1(a0, a1),
    (YTemplate.scandalCasino, 2) => l.yScandalCasino2(a0, a1),
    (YTemplate.scandalSentHome, 0) => l.yScandalSentHome0(a0),
    (YTemplate.scandalSentHome, 1) => l.yScandalSentHome1(a0),
    (YTemplate.scandalSentHome, 2) => l.yScandalSentHome2(a0),
    (YTemplate.scandalSentHome, 3) => l.yScandalSentHome3(a0),
    (YTemplate.scandalSentHome, 4) => l.yScandalSentHome4(a0),
    (YTemplate.scandalSentHome, 5) => l.yScandalSentHome5(a0),
    (YTemplate.scandalKept, 0) => l.yScandalKept0(a0),
    (YTemplate.scandalKept, 1) => l.yScandalKept1(a0),
    (YTemplate.scandalKept, 2) => l.yScandalKept2(a0),
    (YTemplate.scandalKept, 3) => l.yScandalKept3(a0),
    (YTemplate.scandalKept, 4) => l.yScandalKept4(a0),
    (YTemplate.scandalKept, 5) => l.yScandalKept5(a0),
    (YTemplate.streamerBreaks, 0) => l.yStreamerBreaks0,
    (YTemplate.streamerBreaks, 1) => l.yStreamerBreaks1,
    (YTemplate.streamerBreaks, 2) => l.yStreamerBreaks2,
    (YTemplate.streamerSentHome, 0) => l.yStreamerSentHome0,
    (YTemplate.streamerSentHome, 1) => l.yStreamerSentHome1,
    (YTemplate.streamerSentHome, 2) => l.yStreamerSentHome2,
    (YTemplate.streamerKept, 0) => l.yStreamerKept0,
    (YTemplate.streamerKept, 1) => l.yStreamerKept1,
    (YTemplate.streamerKept, 2) => l.yStreamerKept2,
    (YTemplate.cameoUjfaloci, 0) => l.yCameoUjfaloci,
    (YTemplate.cameoHavir, 0) => l.yCameoHavir0,
    (YTemplate.cameoHavir, 1) => l.yCameoHavir1,
    (YTemplate.cameoHavir, 2) => l.yCameoHavir2,
    (YTemplate.cameoHavir, 3) => l.yCameoHavir3,
    (YTemplate.cameoHavir, 4) => l.yCameoHavir4,
    (YTemplate.cameoHavir, 5) => l.yCameoHavir5,
    (YTemplate.cameoHavir, 6) => l.yCameoHavir6,
    (YTemplate.cameoHavir, 7) => l.yCameoHavir7,
    (YTemplate.cameoLzimberskyHome, 0) => l.yCameoLzimberskyHome0,
    (YTemplate.cameoLzimberskyHome, 1) => l.yCameoLzimberskyHome1,
    (YTemplate.cameoLzimberskyHome, 2) => l.yCameoLzimberskyHome2,
    (YTemplate.cameoLzimberskyHome, 3) => l.yCameoLzimberskyHome3,
    (YTemplate.cameoLzimberskyHome, 4) => l.yCameoLzimberskyHome4,
    (YTemplate.cameoLzimberskyKept, 0) => l.yCameoLzimberskyKept0,
    (YTemplate.cameoLzimberskyKept, 1) => l.yCameoLzimberskyKept1,
    (YTemplate.cameoLzimberskyKept, 2) => l.yCameoLzimberskyKept2,
    (YTemplate.cameoLzimberskyKept, 3) => l.yCameoLzimberskyKept3,
    (YTemplate.cameoLzimberskyKept, 4) => l.yCameoLzimberskyKept4,
    // six answers every event in the game (see [YMood]).
    (YTemplate.reaction, _) => _reactionBody(l, p),
    // Unreachable: a variant is always inside its own template's range —
    // see [YFeed.variantsFor], which a unit test pins.
    _ => throw ArgumentError('no words for ${p.template} v${p.variant}'),
  };
}

/// The words for a reply, by mood and variant.
String _reactionBody(AppLocalizations l, YPost p) {
  final options = switch (p.mood ?? YMood.shrug) {
    YMood.elation => [
      l.yReactionElation0,
      l.yReactionElation1,
      l.yReactionElation2,
      l.yReactionElation3,
      l.yReactionElation4,
      l.yReactionElation5,
      l.yReactionElation6,
      l.yReactionElation7,
      l.yReactionElation8,
      l.yReactionElation9,
      l.yReactionElation10,
      l.yReactionElation11,
    ],
    YMood.relief => [
      l.yReactionRelief0,
      l.yReactionRelief1,
      l.yReactionRelief2,
      l.yReactionRelief3,
      l.yReactionRelief4,
      l.yReactionRelief5,
      l.yReactionRelief6,
      l.yReactionRelief7,
      l.yReactionRelief8,
      l.yReactionRelief9,
      l.yReactionRelief10,
      l.yReactionRelief11,
      l.yReactionRelief12,
      l.yReactionRelief13,
      l.yReactionRelief14,
      l.yReactionRelief15,
      l.yReactionRelief16,
      l.yReactionRelief17,
    ],
    YMood.fury => [
      l.yReactionFury0,
      l.yReactionFury1,
      l.yReactionFury2,
      l.yReactionFury3,
      l.yReactionFury4,
      l.yReactionFury5,
      l.yReactionFury6,
      l.yReactionFury7,
      l.yReactionFury8,
      l.yReactionFury9,
      l.yReactionFury10,
      l.yReactionFury11,
      l.yReactionFury12,
      l.yReactionFury13,
      l.yReactionFury14,
      l.yReactionFury15,
      l.yReactionFury16,
      l.yReactionFury17,
    ],
    YMood.despair => [
      l.yReactionDespair0,
      l.yReactionDespair1,
      l.yReactionDespair2,
      l.yReactionDespair3,
      l.yReactionDespair4,
      l.yReactionDespair5,
      l.yReactionDespair6,
      l.yReactionDespair7,
      l.yReactionDespair8,
      l.yReactionDespair9,
      l.yReactionDespair10,
      l.yReactionDespair11,
    ],
    YMood.smugness => [
      l.yReactionSmugness0,
      l.yReactionSmugness1,
      l.yReactionSmugness2,
      l.yReactionSmugness3,
      l.yReactionSmugness4,
      l.yReactionSmugness5,
      l.yReactionSmugness6,
      l.yReactionSmugness7,
      l.yReactionSmugness8,
      l.yReactionSmugness9,
      l.yReactionSmugness10,
      l.yReactionSmugness11,
    ],
    YMood.shrug => [
      l.yReactionShrug0,
      l.yReactionShrug1,
      l.yReactionShrug2,
      l.yReactionShrug3,
      l.yReactionShrug4,
      l.yReactionShrug5,
      l.yReactionShrug6,
      l.yReactionShrug7,
      l.yReactionShrug8,
      l.yReactionShrug9,
      l.yReactionShrug10,
      l.yReactionShrug11,
      l.yReactionShrug12,
      l.yReactionShrug13,
      l.yReactionShrug14,
      l.yReactionShrug15,
      l.yReactionShrug16,
      l.yReactionShrug17,
    ],
  };
  final mood = p.mood ?? YMood.shrug;
  return options[YCast.arbSlot(
    variant: p.variant % YFeed.reactionVariantsFor(mood),
    original: YFeed.reactionVariantCount,
    total: options.length,
  )];
}

/// A deepened template's wording for banded [variant]: [words] are in ARB
/// order, the original twelve first (see [YCast.arbSlot]).
String _deepened(int variant, List<String> words) =>
    words[YCast.arbSlot(
      variant: variant,
      original: YFeed.deepVariantCount,
      total: words.length,
    )];

/// Y — where the world talks about you.
///
/// Read-only. The manager already has a voice at press conferences, with real
/// consequences; this is the place he is talked ABOUT.
class YScreen extends ConsumerStatefulWidget {
  const YScreen({required this.careerId, super.key});

  final int careerId;

  static const Key tabletLayoutKey = Key('y.tabletLayout');
  static const Key trendingKey = Key('y.trending');
  static const Key voicesKey = Key('y.voices');
  static const Key sideThreadKey = Key('y.side.thread');
  static const Key sideProfileKey = Key('y.side.profile');
  static const Key sideCloseKey = Key('y.side.close');

  @override
  ConsumerState<YScreen> createState() => _YScreenState();
}

class _YScreenState extends ConsumerState<YScreen> {
  /// The feed last stamped read, so a rebuild does not keep writing the same
  /// watermark. A NEW feed is stamped again: on a tablet the sim runs under
  /// this screen, and posts that arrive while it is on show have been seen.
  YTimeline? _markedFeed;

  @override
  Widget build(BuildContext context) {
    final careerId = widget.careerId;
    final l = AppLocalizations.of(context);
    final async = ref.watch(yFeedProvider(careerId));
    // Opening the feed IS reading it: the badge counts what has been said
    // since, not what has been tapped.
    final shown = async.valueOrNull;
    if (shown != null && !identical(shown, _markedFeed)) {
      _markedFeed = shown;
      unawaited(ref.read(yReadServiceProvider).markRead(careerId));
    }
    if (TabletShellScope.isActive(context)) {
      return _YTabletLayout(
        feedAsync: async,
        onBack: () => context.canPop()
            ? context.pop()
            : context.go('${Routes.hub}?careerId=$careerId'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(l.yTitle, style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (feed) {
          if (feed.posts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.yEmpty,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          return YFeedList(feed: feed);
        },
      ),
    );
  }
}

/// The feed itself.
///
/// Its own widget so the seam heading can be tested without a save behind it:
/// what this draws is entirely decided by the [YTimeline] handed to it.
class YFeedList extends StatelessWidget {
  const YFeedList({
    required this.feed,
    this.onOpenPost,
    this.onOpenAccount,
    super.key,
  });

  final YTimeline feed;

  /// Opens a post; null pushes its page (the phone).
  final void Function(YPost post)? onOpenPost;

  /// Opens whoever wrote a post; null pushes the profile page (the phone).
  final void Function(YPost post)? onOpenAccount;

  @override
  Widget build(BuildContext context) {
    final posts = feed.posts;
    final seam = feed.reserveFrom;
    // One extra row for the heading, and only when there is a reserve to head.
    // A feed short enough to fit inside the recency window draws no heading at
    // all rather than an empty one.
    final rows = posts.length + (seam == null ? 0 : 1);
    return ListView.builder(
      // No page padding: a feed runs edge to edge and each row carries its own
      // margins, so the hairlines between conversations reach the sides of the
      // screen the way they do in a timeline.
      padding: EdgeInsets.zero,
      itemCount: rows,
      itemBuilder: (context, row) {
        if (seam != null && row == seam) return const _YEarlierHeading();
        // Everything below the heading has shifted down by its row.
        final i = seam != null && row > seam ? row - 1 : row;
        return YPostTile(
          post: posts[i],
          // A rule ABOVE each new conversation, and none inside one: a post
          // and its replies are one thing being talked about, and a line
          // through the middle of them read as unrelated posts. The heading
          // draws its own, so the post directly under it needs none.
          topRule: i > 0 && posts[i].replyTo == null && row != (seam ?? -1) + 1,
          // A post is the start of a conversation, not a dead line of text:
          // opening it shows everyone who said something about the same match.
          onTap: () => onOpenPost != null
              ? onOpenPost!(posts[i])
              : Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => YPostDetail(post: posts[i], all: posts),
                  ),
                ),
          onAccountTap: () => onOpenAccount != null
              ? onOpenAccount!(posts[i])
              : Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => YProfileSheet(
                      persona: YFeed.personaOf(posts[i]),
                      all: posts,
                    ),
                  ),
                ),
        );
      },
    );
  }
}

/// The seam between the recent feed and the tournaments kept back from earlier
/// in the cycle.
///
/// Without it the feed simply jumps back in time partway down — from this
/// spring to a summer two years ago, with no date headers anywhere to explain
/// it — and the manager who went looking for the continental championship
/// found something that read like a fault rather than like older news.
class _YEarlierHeading extends StatelessWidget {
  const _YEarlierHeading();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant),
          bottom: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: AppSpacing.sm,
      ),
      // A plain [Text], not a [WholeText]: this is a fixed heading in two
      // known languages, and a widget that quietly scales itself down to fit
      // would hide a copy change that no longer does — the width test reads
      // `didExceedMaxLines`, which only a real Text can fail.
      child: Text(
        l.yEarlierHeading,
        maxLines: 1,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// One post in the feed. Public so the detail view — and the tests — can use
/// the same row rather than a second, subtly different one.
///
/// A FLAT ROW, not a card. Every post used to sit in its own raised, rounded
/// box with a gap under it, which is the shape of a list of separate notices —
/// a noticeboard. A feed is a single column of voices divided by hairlines,
/// with replies hanging off the post they answer on a visible rail, and that
/// difference is most of what makes one read as a conversation and the other
/// as an inbox.
class YPostTile extends StatelessWidget {
  const YPostTile({
    required this.post,
    this.onTap,
    this.onAccountTap,
    this.topRule = false,
    super.key,
  });

  final YPost post;
  final VoidCallback? onTap;

  /// Tapping the avatar or the name opens whoever wrote this, rather than
  /// what they wrote. Null leaves the account inert, which is what the
  /// profile's own list of posts wants: it is already that account.
  final VoidCallback? onAccountTap;

  /// Whether a hairline is drawn above this row — true for the first post of
  /// each conversation, so the rules separate stories rather than sentences.
  final bool topRule;

  Color get _tint => switch (post.voice) {
    YVoice.pundit => AppColors.primary,
    YVoice.fan => AppColors.positive,
    YVoice.rival => AppColors.error,
    YVoice.stats || YVoice.breaking => AppColors.onSurfaceVariant,
    YVoice.player => AppColors.warning,
    YVoice.meme => AppColors.tertiary,
    YVoice.expro => AppColors.error,
    YVoice.neutral => AppColors.ratingGood,
    YVoice.away => AppColors.playoff,
    YVoice.streamer => AppColors.tertiary,
    YVoice.cameo => AppColors.warning,
  };

  /// How the name is written, which is the only sign the manager gets that it
  /// can be opened.
  ///
  /// [AppColors.primary] is this app's one interactive tint: it is on every
  /// back arrow, every action icon and every selected state, so a name in it
  /// reads as something you can press without inventing a link convention
  /// this app has nowhere else. A name that opens nothing is written in the
  /// ordinary colour, because an affordance that lies is worse than none: the
  /// profile lists its own posts, and there is nothing behind those names.
  TextStyle get _nameStyle => onAccountTap == null
      ? AppTypography.labelMedium
      : AppTypography.labelMedium.copyWith(color: AppColors.primary);

  /// Whether this post answers another one, in which case it is drawn stepped
  /// in under it rather than as a story of its own — the thread has to LOOK
  /// like a thread or the replies read as unrelated non-sequiturs.
  bool get _isReply => post.replyTo != null;

  /// The avatar. Smaller for a reply, which is what puts the parent visually
  /// above its answers without indenting the text off the screen.
  double get _avatarSize => _isReply ? 28 : 40;

  /// How far a reply is stepped in from the edge.
  static const double _replyIndent = 22;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: topRule
              ? const BorderSide(color: AppColors.outlineVariant)
              : BorderSide.none,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // The rail a reply hangs off, drawn FULL HEIGHT down the gutter it
            // is indented by. Positioned rather than laid out beside the
            // avatar: a rail that has to stretch to the row's height cannot be
            // an Expanded inside a Row aligned to the top — the column it
            // would sit in has no height to expand into. Consecutive replies
            // each draw their own segment, so a thread of three is one
            // unbroken line.
            if (_isReply)
              const Positioned(
                top: 0,
                bottom: 0,
                left: AppSpacing.marginMobile + _replyIndent / 2 - 1,
                width: 2,
                child: ColoredBox(color: AppColors.outlineVariant),
              ),
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.marginMobile + (_isReply ? _replyIndent : 0),
                right: AppSpacing.marginMobile,
                top: _isReply ? 6 : AppSpacing.sm,
                bottom: _isReply ? 6 : AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Account(
                    onTap: onAccountTap,
                    child: Container(
                      width: _avatarSize,
                      height: _avatarSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _tint.withValues(alpha: 0.16),
                      ),
                      child: Text(
                        post.displayName.characters.first,
                        style: AppTypography.labelMedium.copyWith(color: _tint),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name, handle and date on ONE line, in that order —
                        // the date sat right-aligned at the far edge before,
                        // which put a column of dates down the side of the
                        // feed and read as a table of records rather than as
                        // people talking.
                        Row(
                          children: [
                            // The name and the handle open the ACCOUNT; the
                            // rest of the row opens the post. Tapping a name
                            // in a feed has meant "who is this" for twenty
                            // years, and this feed has a cast worth asking
                            // about.
                            //
                            // ONE target, not two. Two gestures around two
                            // words left a pair of glyph-sized hit boxes with
                            // a dead gap between them; wrapping the pair and
                            // padding it out gives a finger something to land
                            // on, and [HitTestBehavior.opaque] means the
                            // padding counts.
                            Flexible(
                              child: _Account(
                                onTap: onAccountTap,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.xs,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: WholeText(
                                          post.displayName,
                                          maxLines: 1,
                                          style: _nameStyle,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Flexible(
                                        child: WholeText(
                                          post.handle,
                                          maxLines: 1,
                                          style: AppTypography.labelSmall
                                              .copyWith(
                                                color:
                                                    AppColors.onSurfaceVariant,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              ' · ${AppDate.dayMonthShortYear(context, post.date)}',
                              maxLines: 1,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          yPostBody(l, post),
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Whatever part of a row identifies the account, made tappable.
///
/// A plain [GestureDetector] rather than an [InkWell]: the whole tile is
/// already an InkWell, and a second one nested inside it would paint a ripple
/// over the name at the same time as the row's own. The gesture still wins the
/// tap, which is the part that matters. A null [onTap] leaves the child
/// exactly as it was, so a profile listing its own posts offers no way to open
/// itself again.
class _Account extends StatelessWidget {
  const _Account({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => onTap == null
      ? child
      : GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: child,
        );
}
