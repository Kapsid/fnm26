// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get matchPreviewTitle => 'MATCH PREVIEW';

  @override
  String get matchKickOff => 'Kick off';

  @override
  String get matchTactics => 'Tactics';

  @override
  String get matchYourXi => 'YOUR XI';

  @override
  String get matchHeadToHead => 'HEAD TO HEAD';

  @override
  String matchCouldNotLoad(String error) {
    return 'Could not load match.\n$error';
  }

  @override
  String get matchNoUpcoming => 'No upcoming match.';

  @override
  String get matchUnknownNation => 'Unknown';

  @override
  String get matchH2hFirstMeeting => 'First-ever meeting';

  @override
  String get matchH2hYouLead => 'You lead the head-to-head';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent have the edge';
  }

  @override
  String get matchH2hEven => 'Honours even';

  @override
  String matchH2hMet(int count) {
    return '$count met';
  }

  @override
  String get matchH2hWon => 'Won';

  @override
  String get matchH2hDrawn => 'Drawn';

  @override
  String get matchH2hLost => 'Lost';

  @override
  String get matchDossierTitle => 'Scouting report';

  @override
  String get matchDossierForm => 'FORM';

  @override
  String get matchDossierNoGames => 'No recent games';

  @override
  String get matchDossierKeyMen => 'KEY MEN';

  @override
  String matchCouldNotContinue(String error) {
    return 'Could not continue: $error';
  }

  @override
  String get matchSkipToFullTime => 'Skip to full time';

  @override
  String get matchStatShots => 'Shots';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'ATK';

  @override
  String get matchSwingDef => 'DEF';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'WORLD CUP $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'THE FINALS ARE HERE';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'HOSTED BY  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'HOST TO BE CONFIRMED';

  @override
  String get matchHalfTime => 'HALF TIME';

  @override
  String get matchContinue => 'Continue';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Tactics · $used/$max subs';
  }

  @override
  String matchTiredCount(int count) {
    return 'TIRED ×$count';
  }

  @override
  String get matchTacticsLabel => 'TACTICS';

  @override
  String get teamOverallOverTime => 'OVERALL OVER TIME';

  @override
  String get teamOverall => 'Overall';

  @override
  String get matchSecondYellow => 'Second yellow';

  @override
  String get matchStraightRed => 'Red card';

  @override
  String get teamTalkHeading => 'TEAM TALK';

  @override
  String get teamTalkPrompt => 'Set the tone for the second half.';

  @override
  String get teamTalkCalmLabel => 'Calm heads';

  @override
  String get teamTalkCalmBlurb => 'Steady the side — a small all-round lift.';

  @override
  String get teamTalkEncourageLabel => 'Encourage';

  @override
  String get teamTalkEncourageBlurb => 'Push forward and go for the game.';

  @override
  String get teamTalkDemandMoreLabel => 'Demand more';

  @override
  String get teamTalkDemandMoreBlurb => 'Throw everything at it — attack hard.';

  @override
  String get teamTalkPraiseLabel => 'Keep it tight';

  @override
  String get teamTalkPraiseBlurb => 'Stay compact and protect what you have.';

  @override
  String get teamTalkBelieveLabel => 'Believe';

  @override
  String get teamTalkBelieveBlurb =>
      'Back yourselves — lift both ends of the pitch.';

  @override
  String get teamTalkFocusLabel => 'Stay switched on';

  @override
  String get teamTalkFocusBlurb => 'Total concentration — lock the game down.';

  @override
  String get teamTalkUrgencyLabel => 'Sense of urgency';

  @override
  String get teamTalkUrgencyBlurb =>
      'Chase it down now — go all-out, leave gaps.';

  @override
  String get teamTalkReassureLabel => 'No pressure';

  @override
  String get teamTalkReassureBlurb => 'Settle the nerves and keep your shape.';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSomethingWentWrong => 'Something went wrong';

  @override
  String get commonCrashBox =>
      'Something went wrong here.\nSettings → Diagnostics has the details.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Could not advance the world: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostics';

  @override
  String get settingsDiagnosticsBlurb =>
      'Errors recorded on this device. Nothing is sent anywhere.';

  @override
  String get diagnosticsEmpty => 'No errors recorded. That\'s the idea.';

  @override
  String get diagnosticsCopy => 'Copy';

  @override
  String get diagnosticsCopied => 'Log copied to the clipboard.';

  @override
  String get diagnosticsClear => 'Clear';

  @override
  String get navHub => 'Hub';

  @override
  String get navSquad => 'Squad';

  @override
  String get navStandings => 'Standings';

  @override
  String get navCareers => 'Careers';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsSoundHapticsTitle => 'Sound & haptics';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibration and a short tone on goals, kick-off and full time.';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageBlurb =>
      'Choose the app language, or follow your device.';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageCzech => 'Čeština';

  @override
  String get recordsMeetings => 'MEETINGS';

  @override
  String get recordsLegends => 'LEGENDS';

  @override
  String get recordsAllTimeXi => 'ALL-TIME XI';

  @override
  String get recordsHallOfFame => 'HALL OF FAME';

  @override
  String get recordsAllTimeWorld => 'ALL-TIME WORLD';

  @override
  String get recordsAllTimeTopScorers => 'ALL-TIME TOP SCORERS';

  @override
  String get recordsMostCapped => 'MOST CAPPED';

  @override
  String get recordsMostWcStarts => 'MOST WORLD CUP STARTS';

  @override
  String get recordsMostTournaments => 'MOST TOURNAMENTS ATTENDED';

  @override
  String get recordsRecordBook => 'RECORD BOOK';

  @override
  String get recordsHeadToHead => 'HEAD TO HEAD';

  @override
  String get recordsFiercestRival => 'FIERCEST RIVAL';

  @override
  String get recordsMostCaps => 'MOST CAPS';

  @override
  String get recordsTopScorers => 'TOP SCORERS';

  @override
  String get recordsMostAssists => 'MOST ASSISTS';

  @override
  String get recordsYourRecord => 'YOUR RECORD';

  @override
  String get recordsHome => 'HOME';

  @override
  String get recordsAway => 'AWAY';

  @override
  String get recordsActive => 'ACTIVE';

  @override
  String get recordsStillActive => 'Still active';

  @override
  String get recordsAvg => 'avg';

  @override
  String get recordsSelect => 'Select';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Draws';

  @override
  String get recordsGoalsLabel => 'Goals';

  @override
  String get recordsBestFinish => 'Best finish';

  @override
  String get recordsLongestUnbeaten => 'Longest unbeaten';

  @override
  String get recordsBiggestWin => 'Biggest win';

  @override
  String get recordsSeeAllMeetings => 'See all meetings';

  @override
  String get recordsSaveNotFound => 'Save not found.';

  @override
  String get recordsNoMatches => 'No matches.';

  @override
  String get recordsSearchPlayerOrNation => 'Search player or nation';

  @override
  String get recordsSearchNation => 'Search nation';

  @override
  String get recordsPickTwoDifferent => 'Pick two different nations.';

  @override
  String get recordsPlayToBuildRecord =>
      'Play some matches and your record against each opponent will build here.';

  @override
  String get recordsTapOpponent => 'Tap an opponent for the full breakdown.';

  @override
  String get recordsEdgeUpperHand => 'You hold the upper hand';

  @override
  String get recordsEdgeTheirNumber => 'They have your number';

  @override
  String get recordsEdgeEven => 'Honours even';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Global scorers & most-capped, every nation';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Compare any two nations’ all-time record';

  @override
  String get recordsLegendsSubtitle => 'All-time XI & hall of fame';

  @override
  String get recordsUnitGoals => 'goals';

  @override
  String get recordsUnitCaps => 'caps';

  @override
  String get recordsUnitStarts => 'starts';

  @override
  String get recordsUnitCups => 'cups';

  @override
  String get recordsUnitAssists => 'assists';

  @override
  String recordsCapsCount(int count) {
    return '$count caps';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count goals';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count assists';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MOTM';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count matches';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count meetings';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code wins';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings meetings · ${wins}W ${draws}D ${losses}L';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}W ${draws}D ${losses}L';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings meetings · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a and $b have never met in this save.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names sent off — no replacement, you play a man down.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Need $required available ($have fit)';
  }

  @override
  String get rankingCentreOnMe => 'Centre on my nation';

  @override
  String get recordsAfterExtraTime => 'a.e.t.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b pens';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played played · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga v $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Could not load.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Could not load legends.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Could not load records.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Could not load nations.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Could not load your record.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Could not load record.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'No legends yet. Play out some campaigns and $nation’s greats will emerge here.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'The greatest side $nation could ever field.';
  }

  @override
  String get recordsNoWorldHistory =>
      'The world has no history yet. Play out some campaigns and the all-time greats will appear here.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Play some matches to start writing $nation’s history.';
  }

  @override
  String get tacticsLineGk => 'GK';

  @override
  String get tacticsLineDef => 'DEF';

  @override
  String get tacticsLineMid => 'MID';

  @override
  String get tacticsLineFwd => 'FWD';

  @override
  String get tacticsGoalkeepers => 'GOALKEEPERS';

  @override
  String get tacticsDefenders => 'DEFENDERS';

  @override
  String get tacticsMidfielders => 'MIDFIELDERS';

  @override
  String get tacticsForwards => 'FORWARDS';

  @override
  String get tacticsCallUpsTitle => 'CALL-UPS';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Pick at least $min players.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Could not load squad.\n$error';
  }

  @override
  String get tacticsNoSquad => 'No squad.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'SQUAD · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Max $max';
  }

  @override
  String get tacticsBestQuality => 'Best quality';

  @override
  String get tacticsPreviousSquad => 'Previous squad';

  @override
  String get tacticsSquadLockedBack => 'Squad locked — back';

  @override
  String get tacticsConfirmSquad => 'Confirm squad';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Squad full — max $max';
  }

  @override
  String get tacticsSquadLocked => 'SQUAD LOCKED';

  @override
  String get tacticsNominationOpen => 'NOMINATION OPEN — PICK YOUR SQUAD';

  @override
  String get tacticsSquadFixedBlurb =>
      'This squad is fixed for the matches below. Re-select before the next nomination window.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'This squad will play the matches below.';

  @override
  String get tacticsUnknown => 'Unknown';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Age $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Exhausted';

  @override
  String get tacticsFatigueTired => 'Tired';

  @override
  String get tacticsFatigueMatchLegs => 'Match legs';

  @override
  String tacticsTooManySubs(int max) {
    return 'Too many substitutions (max $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TACTICS · $minute\'';
  }

  @override
  String get tacticsApply => 'APPLY';

  @override
  String get tacticsTabLineupSubs => 'LINEUP & SUBS';

  @override
  String get tacticsTabTactics => 'TACTICS';

  @override
  String get squadLineKeepers => 'KEEPERS';

  @override
  String get squadLineDefenders => 'DEFENCE';

  @override
  String get squadLineMidfielders => 'MIDFIELD';

  @override
  String get squadLineForwards => 'ATTACK';

  @override
  String get squadStatXiRating => 'XI rating';

  @override
  String get squadStatAvgAge => 'Avg age';

  @override
  String get squadStatSize => 'Squad';

  @override
  String get squadStatUnavailable => 'Out';

  @override
  String get squadDepthTitle => 'DEPTH BY LINE';

  @override
  String squadAgeShort(int age) {
    return '${age}y';
  }

  @override
  String tacticsSubstitutesCount(int count) {
    return 'SUBSTITUTES · $count';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'SUBS · $used/$max';
  }

  @override
  String get tacticsDragSubOn => 'Drag a sub onto a player to bring them on.';

  @override
  String get tacticsNoSubs => 'No substitutes available.';

  @override
  String get tacticsFormation => 'FORMATION';

  @override
  String get tacticsInstructions => 'INSTRUCTIONS';

  @override
  String get matchInstructionsLocked =>
      'Set before kick-off. You can change shape and make substitutions, but not rewrite your approach mid-match.';

  @override
  String get tacticsInstrMentality => 'Mentality';

  @override
  String get tacticsInstrDefensive => 'Defensive';

  @override
  String get tacticsInstrAttacking => 'Attacking';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Low block';

  @override
  String get tacticsInstrHighPress => 'High press';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Patient';

  @override
  String get tacticsInstrFast => 'Fast';

  @override
  String get tacticsInstrWidth => 'Width';

  @override
  String get tacticsInstrNarrow => 'Narrow';

  @override
  String get tacticsInstrWide => 'Wide';

  @override
  String get tacticsInstrDefLine => 'Def. line';

  @override
  String get tacticsInstrDefensiveLine => 'Defensive line';

  @override
  String get tacticsInstrDeep => 'Deep';

  @override
  String get tacticsInstrHigh => 'High';

  @override
  String get tacticsInstrDirectness => 'Directness';

  @override
  String get tacticsInstrPossession => 'Possession';

  @override
  String get tacticsInstrDirect => 'Direct';

  @override
  String tacticsPickRole(String role) {
    return 'PICK $role';
  }

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · out of position';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Age $age';
  }

  @override
  String get tacticsOn => 'ON';

  @override
  String get tacticsInjuredReplace => 'INJURED — REPLACE';

  @override
  String get tacticsSuspendedReplace => 'SUSPENDED — REPLACE';

  @override
  String get tacticsSquad => 'SQUAD';

  @override
  String get tacticsTabLineup => 'LINEUP';

  @override
  String get tacticsTabRoles => 'ROLES';

  @override
  String get tacticsTabSetPieces => 'SET PIECES';

  @override
  String get tacticsTabRolesSetPieces => 'ROLES & SET PIECES';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Give each starter a role. Tap the penalty (⚽) or free-kick (▲) badge to set your taker.';

  @override
  String get tacticsTooltipCallUps => 'Call-ups';

  @override
  String get tacticsTooltipPresets => 'Tactic presets';

  @override
  String get tacticsTooltipInstructions => 'Instructions';

  @override
  String get tacticsNoTacticSet => 'No tactic set.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'REPLACE $count STARTERS',
      one: 'REPLACE $count STARTER',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name — $reason';
  }

  @override
  String get tacticsOut => 'Out';

  @override
  String get tacticsTapSpotReplace =>
      'Tap their spot on the pitch to pick a replacement.';

  @override
  String get tacticsTapOrDrag =>
      'Tap a player to swap them out, or hold and drag one to move them.';

  @override
  String get tacticsPlayerRoles => 'PLAYER ROLES';

  @override
  String get tacticsRolesBlurb =>
      'Give a player a job: a poacher, a playmaker, a target man. Shapes who scores and who creates.';

  @override
  String get tacticsSetPieceTakers => 'SET-PIECE TAKERS';

  @override
  String get tacticsSetPieceBlurb =>
      'Who takes penalties and dead balls, or leave it to the best-suited player.';

  @override
  String get tacticsPenalties => 'Penalties';

  @override
  String get tacticsCornersFreeKicks => 'Corners & free-kicks';

  @override
  String get tacticsSkillFin => 'FIN';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROLE · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'PENALTY TAKER';

  @override
  String get tacticsCornerFreeKickTaker => 'CORNER & FREE-KICK TAKER';

  @override
  String get tacticsAutomatic => 'Automatic';

  @override
  String get tacticsLetBestSuited => 'Let the best-suited player take it.';

  @override
  String get tacticsInXi => 'IN XI';

  @override
  String get tacticsTeamInstructions => 'TEAM INSTRUCTIONS';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Set how your side plays. Each dial nudges the whole team.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Saved “$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Applied “$name”';
  }

  @override
  String get tacticsTacticPresets => 'TACTIC PRESETS';

  @override
  String get tacticsPresetsBlurb =>
      'Save this shape as a reusable style, or apply one you saved earlier.';

  @override
  String get tacticsSaveCurrentTactic => 'Save current tactic';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Could not load presets.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'No presets yet. Tap “Save current tactic” to store this setup as a reusable style.';

  @override
  String get tacticsNameThisTactic => 'Name this tactic';

  @override
  String get tacticsNameHint => 'e.g. High press 4-3-3';

  @override
  String get tacticsCancel => 'Cancel';

  @override
  String get tacticsSave => 'Save';

  @override
  String get tacticsTapToAssign => 'Tap to assign';

  @override
  String get tacticsHoldDragSub =>
      'Hold a sub, then drag them onto a player to bring them on.';

  @override
  String tacticsUnavailableCount(int count) {
    return 'UNAVAILABLE · $count';
  }

  @override
  String get hubContinue => 'Continue';

  @override
  String get hubBrackets => 'Brackets';

  @override
  String hubCouldNotLoad(String error) {
    return 'Could not load.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Could not load finances.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Could not load save.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Save not found.';

  @override
  String get hubUnknown => 'Unknown';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year WORLD CHAMPIONS';
  }

  @override
  String get hubCycleComplete => 'The cycle is complete.';

  @override
  String get hubYourJob => 'YOUR JOB';

  @override
  String get hubStayProject => 'Stay and continue your project';

  @override
  String get hubChooseNextJob => 'CHOOSE YOUR NEXT JOB';

  @override
  String get hubOffersOnTable => 'OFFERS ON THE TABLE';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · world #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Continue with $nation';
  }

  @override
  String get hubYourNation => 'your nation';

  @override
  String get hubTakeTheJob => 'Take the job';

  @override
  String get hubFederationFinances => 'FEDERATION FINANCES';

  @override
  String get hubBudgetIntro =>
      'Your first job next cycle is to set the federation budget and split it across the departments.';

  @override
  String get hubStarting => 'Starting…';

  @override
  String get hubBeginNextCycle => 'Begin next cycle';

  @override
  String get hubOpeningBalance => 'Opening balance';

  @override
  String get hubCentralFunding => 'Central funding';

  @override
  String get hubPrizeMoney => 'Prize money';

  @override
  String get hubCommercialReturn => 'Commercial return';

  @override
  String get hubAvailableToInvest => 'Available to invest';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputation: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'National hero';

  @override
  String get hubFinal => 'Final';

  @override
  String get hubStageRoundOf32 => 'Round of 32';

  @override
  String get hubStageThirdPlace => 'Third-place play-off';

  @override
  String get hubEventAdvanceWorld => 'Advance the world';

  @override
  String hubEventStartCycle(int year) {
    return 'Start $year cycle';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation are World Champions';
  }

  @override
  String get hubEventSetBudget => 'Set your federation budget';

  @override
  String get hubEventSetBudgetSub =>
      'Allocate this cycle’s war chest before the season begins';

  @override
  String get hubEventNaturalization => 'Review naturalisation offer';

  @override
  String get hubEventNaturalizationSub =>
      'A foreign player wants to switch allegiance to you';

  @override
  String get hubEventIntercontinentalPlayoff => 'The intercontinental play-off';

  @override
  String get hubEventWatchWcDraw => 'Watch the World Cup draw';

  @override
  String get hubEventWorldCupHere => 'The World Cup is here';

  @override
  String get hubEventWatchFinalsDraw => 'Watch the finals draw';

  @override
  String get hubEventFinalsHere => 'The finals are here';

  @override
  String get hubEventPlayWcRound => 'Play the next World Cup round';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Play the next $cup match';
  }

  @override
  String get hubEventPlayNationsCupMatch => 'Play the next Nations Cup match';

  @override
  String get hubEventWatchNationsCupDraw => 'Watch the Nations Cup draw';

  @override
  String get hubEventWatchHostSelection => 'Watch the host selection';

  @override
  String get hubEventWatchQualifyingDraw => 'Watch the qualifying draw';

  @override
  String get hubEventWatchWcHostSelection =>
      'Watch the World Cup host selection';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Watch the World Cup qualifying draw';

  @override
  String get hubEventArrangeFriendlies => 'Arrange friendlies';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You haven’t filled your $count open friendly windows yet',
      one: 'You haven’t filled your open friendly window yet',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Reshape your starting XI';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count of your XI are out (suspended or injured) — pick their replacements',
      one:
          '1 of your XI is out (suspended or injured) — pick their replacement',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your starting XI is short — fill the open slots',
      one: 'Your starting XI is short — fill the open slot',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Play $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'the continental finals';

  @override
  String get hubCallUpFriendlies => 'Name your squad for the friendlies';

  @override
  String get hubCallUpRequalify => 'Re-name your qualifying squad';

  @override
  String get hubCallUpWorldCup => 'Name your World Cup squad';

  @override
  String get hubCallUpFinals => 'Name your squad for the finals';

  @override
  String get hubCallUpNationsCup => 'Name your Nations Cup squad';

  @override
  String get hubCallUpQualifying => 'Name your qualifying squad';

  @override
  String get hubCallUpGeneric => 'Name your squad';

  @override
  String get hubHost => 'Host';

  @override
  String get hubGoldenBoot => 'Golden Boot';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals goals';
  }

  @override
  String get hubPens => '(pens)';

  @override
  String get hubNationalHub => 'NATIONAL HUB';

  @override
  String get hubMessages => 'Messages';

  @override
  String get hubWorldChampions => 'WORLD CHAMPIONS';

  @override
  String get hubViewBracket => 'View bracket ›';

  @override
  String get hubBoardDelighted => 'Delighted';

  @override
  String get hubBoardPleased => 'Pleased';

  @override
  String get hubBoardExpectingMore => 'Expecting more';

  @override
  String get hubBoardConcerned => 'Concerned';

  @override
  String get hubBoardJobAtRisk => 'Job at risk';

  @override
  String get hubBoard => 'BOARD';

  @override
  String hubBoardObjective(String label) {
    return 'Board objective: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'MET · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'MISSED · $result';
  }

  @override
  String get hubNoMoreFixtures => 'No more fixtures this cycle.';

  @override
  String get hubNextMatch => 'NEXT MATCH';

  @override
  String get hubVs => 'VS';

  @override
  String get hubSquadStatus => 'SQUAD STATUS';

  @override
  String hubPlayers(int count) {
    return '$count players';
  }

  @override
  String get hubAvgRating => 'Avg rating';

  @override
  String get hubMorale => 'Morale';

  @override
  String get hubManageTeam => 'Manage Team';

  @override
  String get hubGroupsToBeDrawn =>
      'Groups to be drawn — watch the draw to reveal them.';

  @override
  String hubGroupName(String name) {
    return 'GROUP $name';
  }

  @override
  String get hubTblTeam => 'TEAM';

  @override
  String get hubTblP => 'P';

  @override
  String get hubTblGd => 'GD';

  @override
  String get hubTblPts => 'PTS';

  @override
  String get homeSettings => 'Settings';

  @override
  String get homeLeadTheNation => 'LEAD THE NATION';

  @override
  String get homeYourNation => 'your nation';

  @override
  String get homeNewGame => 'New Game';

  @override
  String get homeAllSaves => 'All saves';

  @override
  String get homeLoadGame => 'Load game';

  @override
  String get homeContinue => 'CONTINUE';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Road to the $year World Cup';
  }

  @override
  String get careerManageSaves => 'Manage saves';

  @override
  String get careerNewGameTitle => 'NEW GAME';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Could not load nation.\n$error';
  }

  @override
  String get careerNationNotFound => 'Nation not found.';

  @override
  String careerWorldRankNum(int rank) {
    return 'WORLD RANK #$rank';
  }

  @override
  String get careerManagerName => 'Manager name';

  @override
  String get careerManagerNameHint => 'e.g. Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Your career begins in September 2026, on the road to the 2030 World Cup.';

  @override
  String get careerStartCareer => 'Start Career';

  @override
  String get careersTitle => 'CAREERS';

  @override
  String get careerManagerCareer => 'Manager career';

  @override
  String get careerManagerCareerSubtitle =>
      'Every cycle you\'ve managed and your overall record';

  @override
  String get careerSummaryTitle => 'Career summary';

  @override
  String get careerSummarySubtitle => 'Your trophy cabinet and manager record';

  @override
  String get careerAchievements => 'Achievements';

  @override
  String get careerAchievementsSubtitle =>
      'Milestones, titles and board satisfaction';

  @override
  String get careerTeamRecords => 'Team records';

  @override
  String get careerTeamRecordsSubtitle =>
      'All-time top scorers and appearances';

  @override
  String get careerMyMatches => 'My matches';

  @override
  String get careerMyMatchesSubtitle => 'Every result and upcoming fixture';

  @override
  String get careerTitle => 'CAREER';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Could not load career.\n$error';
  }

  @override
  String get careerNoCareer => 'No career.';

  @override
  String get careerTrophyCabinet => 'TROPHY CABINET';

  @override
  String get careerTournamentHistory => 'TOURNAMENT HISTORY';

  @override
  String get careerNoTournamentsYet => 'No tournaments completed yet.';

  @override
  String get careerTeamFallback => 'Team';

  @override
  String careerWorldNum(int rank) {
    return 'WORLD #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PTS';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SEASON $season';
  }

  @override
  String get careerStatPlayedShort => 'P';

  @override
  String get careerStatsHeading => 'BY THE NUMBERS';

  @override
  String get careerStatsWinRate => 'Win rate';

  @override
  String get careerStatsGoalsFor => 'Goals for';

  @override
  String get careerStatsGoalsAgainst => 'Goals against';

  @override
  String get careerStatsGoalDiff => 'Goal diff.';

  @override
  String get careerStatsCleanSheets => 'Clean sheets';

  @override
  String get careerStatsBiggestWin => 'Biggest win';

  @override
  String get careerStatsWinStreak => 'Win streak';

  @override
  String get careerStatsUnbeaten => 'Unbeaten run';

  @override
  String get careerStatsShootouts => 'Shootouts';

  @override
  String get careerStatsHatTricks => 'Hat-tricks';

  @override
  String get careerStatsMotms => 'Man of the match';

  @override
  String get careerStatsBestRating => 'Best rating';

  @override
  String get careerStatWonShort => 'W';

  @override
  String get careerStatDrawnShort => 'D';

  @override
  String get careerStatLostShort => 'L';

  @override
  String get careerStatGoalsForShort => 'GF';

  @override
  String get careerStatGoalsAgainstShort => 'GA';

  @override
  String get careerStatGoalDiffShort => 'GD';

  @override
  String get careerNoSilverware => 'No silverware yet — go win one.';

  @override
  String get careerMedalGold => 'GOLD';

  @override
  String get careerMedalSilver => 'SILVER';

  @override
  String get careerMedalBronze => 'BRONZE';

  @override
  String careerWinnersName(String name) {
    return 'Winners: $name';
  }

  @override
  String get careerSavesTitle => 'SAVES';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Could not load saves.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'SLOTS  $used/$limit';
  }

  @override
  String get careerProUpTo5 => 'Pro: up to 5';

  @override
  String get careerThisSave => 'this save';

  @override
  String get careerSlotsFull => 'Slots full';

  @override
  String get careerSlotsFullGoPro => 'Slots full — go Pro for 5';

  @override
  String get careerNewGame => 'New Game';

  @override
  String get careerDeleteSaveTitle => 'Delete save?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'This permanently deletes your $label career.';
  }

  @override
  String get careerCancel => 'Cancel';

  @override
  String get careerDelete => 'Delete';

  @override
  String get careerNoSavesYet =>
      'No saves yet.\nStart a new game to lead a nation.';

  @override
  String get careerUnknownNation => 'Unknown';

  @override
  String careerPlayedMinutes(int minutes) {
    return 'Played ${minutes}m';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return 'Played ${hours}h ${minutes}m';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Last played $when';
  }

  @override
  String get careerJustNow => 'just now';

  @override
  String get careerYesterday => 'yesterday';

  @override
  String careerMinutesAgo(int n) {
    return '${n}m ago';
  }

  @override
  String careerHoursAgo(int n) {
    return '${n}h ago';
  }

  @override
  String careerDaysAgo(int n) {
    return '${n}d ago';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Road to the $year World Cup';
  }

  @override
  String get careerManagerCareerTitle => 'MANAGER CAREER';

  @override
  String careerCouldNotLoad(String error) {
    return 'Could not load.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CYCLE BY CYCLE';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cycles',
      one: '1 cycle',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations nations led',
      one: '1 nation led',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Titles';

  @override
  String get careerStatPlayed => 'Played';

  @override
  String get careerStatWon => 'Won';

  @override
  String get careerStatDrawn => 'Drawn';

  @override
  String get careerStatLost => 'Lost';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Goals $goalsFor–$goalsAgainst  ($gd)  ·  Win rate $winRate%';
  }

  @override
  String get careerRecordResults => 'RECORD RESULTS';

  @override
  String get careerBestWin => 'Best win';

  @override
  String get careerWorstDefeat => 'Worst defeat';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'v $opponent · $date';
  }

  @override
  String careerCycleRecordLine(
    int won,
    int drawn,
    int lost,
    int goalsFor,
    int goalsAgainst,
    String gd,
  ) {
    return '${won}W ${drawn}D ${lost}L  ·  GF $goalsFor GA $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'World Cup';

  @override
  String get careerContinentalLabel => 'Continental';

  @override
  String get messagesTitle => 'MESSAGES';

  @override
  String get messagesNoMessagesYet => 'No messages yet.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Could not load messages.\n$error';
  }

  @override
  String get messagesDone => 'Done';

  @override
  String get messagesNext => 'Next';

  @override
  String get rankingWorldRanking => 'WORLD RANKING';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Could not load ranking.\n$error';
  }

  @override
  String get rankingNoRanking => 'No ranking.';

  @override
  String get rankingAll => 'ALL';

  @override
  String get rankingYourTeam => 'YOUR TEAM';

  @override
  String get rankingYourRankingOverTime => 'YOUR RANKING OVER TIME';

  @override
  String rankingNowRank(int rank) {
    return 'now #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'best #$best · worst #$worst';
  }

  @override
  String get friendliesTitle => 'FRIENDLIES';

  @override
  String friendliesLoadError(String error) {
    return 'Could not load friendlies.\n$error';
  }

  @override
  String get friendliesContinue => 'Continue';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open windows',
      one: '1 open window',
    );
    return 'Arrange warm-ups for the $_temp0 before your next competitive match. Tap an opponent, or leave it free.';
  }

  @override
  String get friendliesFree => 'Free';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count GOALS',
      one: '1 GOAL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'GOALS';

  @override
  String get matchGoalsNone => 'No goals';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'SET';

  @override
  String matchGoalAssist(String name) {
    return 'assist $name';
  }

  @override
  String get friendliesHome => 'HOME';

  @override
  String get friendliesAway => 'AWAY';

  @override
  String get friendliesNoneThisWindow => 'No friendlies this window';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friendlies',
      one: '1 friendly',
    );
    return 'Confirm $_temp0';
  }

  @override
  String get friendliesMonthJan => 'Jan';

  @override
  String get friendliesMonthFeb => 'Feb';

  @override
  String get friendliesMonthMar => 'Mar';

  @override
  String get friendliesMonthApr => 'Apr';

  @override
  String get friendliesMonthMay => 'May';

  @override
  String get friendliesMonthJun => 'Jun';

  @override
  String get friendliesMonthJul => 'Jul';

  @override
  String get friendliesMonthAug => 'Aug';

  @override
  String get friendliesMonthSep => 'Sep';

  @override
  String get friendliesMonthOct => 'Oct';

  @override
  String get friendliesMonthNov => 'Nov';

  @override
  String get friendliesMonthDec => 'Dec';

  @override
  String get resultsMyMatches => 'MY MATCHES';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Could not load results.\n$error';
  }

  @override
  String get resultsNoFixtures => 'No fixtures.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'QUALIFIER';

  @override
  String get resultsStageFriendly => 'FRIENDLY';

  @override
  String get resultsStageGroupStage => 'GROUP STAGE';

  @override
  String get resultsStageSemiFinal => 'SEMI-FINAL';

  @override
  String get resultsStageFinal => 'FINAL';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'FINALS GROUP';

  @override
  String get resultsStageRoundOf32 => 'ROUND OF 32';

  @override
  String get resultsStageRoundOf16 => 'ROUND OF 16';

  @override
  String get resultsStageQuarterFinal => 'QUARTER-FINAL';

  @override
  String get resultsStageThirdPlace => 'THIRD PLACE';

  @override
  String matchStageMatchday(int matchday) {
    return 'MD $matchday';
  }

  @override
  String get squadCaptain => 'Captain';

  @override
  String deptEffectYouth(int points) {
    return 'Academy prospects arrive about $points overall better';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount back at the cycle\'s close';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% fewer injuries';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% chance a foreign player asks to switch';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points board patience before your job is at risk';
  }

  @override
  String get deptEffectNone => 'No effect while unfunded';

  @override
  String get statsBestRated => 'Ratings';

  @override
  String get statsMyCareer => 'Career';

  @override
  String get statsBestAverageRating => 'BEST AVERAGE RATING';

  @override
  String get statsMyCareerRecord => 'YOUR RECORD';

  @override
  String get statsNoRatingsRecorded => 'No match ratings recorded yet.';

  @override
  String get statsGroupRecord => 'Record';

  @override
  String get statsGroupRuns => 'Runs';

  @override
  String get statsGroupExtremes => 'Extremes';

  @override
  String get statsGroupSplits => 'Home & away';

  @override
  String get statsGroupSquad => 'Your players';

  @override
  String get statsPlayed => 'Matches played';

  @override
  String get statsWinDrawLoss => 'Won–drawn–lost';

  @override
  String get statsWinRate => 'Win rate';

  @override
  String get statsGoals => 'Goals for:against';

  @override
  String get statsCleanSheets => 'Clean sheets';

  @override
  String get statsFailedToScore => 'Failed to score';

  @override
  String get statsLongestWinStreak => 'Longest winning run';

  @override
  String get statsLongestUnbeaten => 'Longest unbeaten run';

  @override
  String get statsLongestCleanSheets => 'Longest clean-sheet run';

  @override
  String get statsLongestWinless => 'Longest winless run';

  @override
  String get statsCurrentRun => 'Current unbeaten run';

  @override
  String get statsBiggestWin => 'Biggest win';

  @override
  String get statsHeaviestDefeat => 'Heaviest defeat';

  @override
  String get statsMostGoalsInAGame => 'Most goals in a match';

  @override
  String get statsShootouts => 'Shootouts won–lost';

  @override
  String get statsComebackWins => 'Wins from behind';

  @override
  String get statsHome => 'Home';

  @override
  String get statsAway => 'Away';

  @override
  String get statsNeutral => 'Neutral';

  @override
  String get statsCompetitive => 'Competitive';

  @override
  String get statsFriendlies => 'Friendlies';

  @override
  String get statsHatTricks => 'Hat-tricks';

  @override
  String get statsBraces => 'Braces';

  @override
  String get statsMotms => 'Man-of-the-match awards';

  @override
  String get statsAssists => 'Assists';

  @override
  String get statsCards => 'Cards';

  @override
  String get statsBestRating => 'Best individual rating';

  @override
  String statsAppsShort(int apps) {
    return '$apps apps';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MOTM';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'Captain — tap to remove the armband';

  @override
  String get captainFitBorn => 'A born leader';

  @override
  String get captainFitNatural => 'A natural captain';

  @override
  String get captainFitCapable => 'Could wear it';

  @override
  String get captainFitUnproven => 'Not a leader yet';

  @override
  String get captainNone => 'No captain named';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale squad morale';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'World Cup Qualifying';

  @override
  String get resultsCategoryFriendlies => 'Friendlies';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Continental Cup';

  @override
  String get resultsCategoryWorldCupFinals => 'World Cup Finals';

  @override
  String get resultsRoundResults => 'ROUND RESULTS';

  @override
  String get resultsFriendlyInternationals => 'FRIENDLY INTERNATIONALS';

  @override
  String get resultsKnockout => 'Knockout';

  @override
  String resultsMatchday(int matchday) {
    return 'MATCHDAY $matchday';
  }

  @override
  String get resultsContinue => 'Continue';

  @override
  String resultsGroup(String name) {
    return 'GROUP $name';
  }

  @override
  String get achievementsScreenTitle => 'ACHIEVEMENTS';

  @override
  String get achievementsChallengesTooltip => 'Challenges';

  @override
  String get achievementsChallengesHeading => 'CHALLENGES';

  @override
  String get achievementsBrutalTests => 'Brutal career-long tests';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Could not load.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total unlocked';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total conquered';
  }

  @override
  String get achievementsBoardSatisfaction => 'BOARD SATISFACTION';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ACHIEVEMENTS UNLOCKED',
      one: 'ACHIEVEMENT UNLOCKED',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Wins';

  @override
  String get achCatMatches => 'Matches';

  @override
  String get achCatQualifications => 'Qualifications';

  @override
  String get achCatTitles => 'Titles';

  @override
  String get achCatMisc => 'Misc';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Goals';

  @override
  String get achCatStreaks => 'Streaks';

  @override
  String get achTierBronze => 'Bronze';

  @override
  String get achTierSilver => 'Silver';

  @override
  String get achTierGold => 'Gold';

  @override
  String get achTierPlatinum => 'Platinum';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Goals',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Score $count goals.',
      one: 'Score 1 goal.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Clean Sheets',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Keep $count clean sheets.',
      one: 'Keep 1 clean sheet.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Winning Habit';

  @override
  String get achStreakWin5Desc => 'Win five matches in a row.';

  @override
  String get achStreakWin10 => 'On a Roll';

  @override
  String get achStreakWin10Desc => 'Win ten matches in a row.';

  @override
  String get achStreakWin20 => 'Juggernaut';

  @override
  String get achStreakWin20Desc => 'Win twenty matches in a row.';

  @override
  String get achUnbeaten15 => 'Hard to Beat';

  @override
  String get achUnbeaten15Desc => 'Go fifteen matches unbeaten.';

  @override
  String get achUnbeaten30 => 'Untouchable';

  @override
  String get achUnbeaten30Desc => 'Go thirty matches unbeaten.';

  @override
  String get achHattrick => 'Hat-trick Hero';

  @override
  String get achHattrickDesc => 'Have a player score a hat-trick.';

  @override
  String get achMotm10 => 'Standout';

  @override
  String get achMotm10Desc => 'Collect 10 man-of-the-match awards.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc => 'Collect 50 man-of-the-match awards.';

  @override
  String get achPerfect => 'Perfect Ten';

  @override
  String get achPerfectDesc => 'Have a player earn a 9.5+ match rating.';

  @override
  String get achShootout => 'Ice in the Veins';

  @override
  String get achShootoutDesc => 'Win five penalty shootouts.';

  @override
  String get achMassacre => 'Massacre';

  @override
  String get achMassacreDesc => 'Win a match by 7 goals or more.';

  @override
  String get achAnnihilation => 'Annihilation';

  @override
  String get achAnnihilationDesc => 'Win a match by 10 goals or more.';

  @override
  String get chTierBronze => 'Bronze';

  @override
  String get chTierSilver => 'Silver';

  @override
  String get chTierGold => 'Gold';

  @override
  String get chTierLegendary => 'Legendary';

  @override
  String get chFirstSteps => 'In the Dugout';

  @override
  String get chFirstStepsDesc => 'Manage for 5 years.';

  @override
  String get chUnbeaten10 => 'On a Roll';

  @override
  String get chUnbeaten10Desc => 'Go 10 competitive matches unbeaten.';

  @override
  String get chTwoNations => 'Fresh Challenge';

  @override
  String get chTwoNationsDesc => 'Manage 2 different nations.';

  @override
  String get chCont1 => 'Continental Champion';

  @override
  String get chCont1Desc => 'Win a continental championship.';

  @override
  String get chNc1 => 'Nations Cup Winner';

  @override
  String get chNc1Desc => 'Win the Nations Cup.';

  @override
  String get chWc1 => 'World Champion';

  @override
  String get chWc1Desc => 'Win the World Cup.';

  @override
  String get chYears25 => 'Establishment';

  @override
  String get chYears25Desc => 'Manage for 25 years.';

  @override
  String get chWc3 => 'Serial Winner';

  @override
  String get chWc3Desc => 'Win 3 World Cups.';

  @override
  String get chWc5 => 'Dynasty';

  @override
  String get chWc5Desc => 'Win 5 World Cups.';

  @override
  String get chWc10 => 'Immortal';

  @override
  String get chWc10Desc => 'Win 10 World Cups.';

  @override
  String get chWc2Teams => 'Have Boots, Will Travel';

  @override
  String get chWc2TeamsDesc => 'Win the World Cup with 2 different nations.';

  @override
  String get chWc3Teams => 'Globetrotter';

  @override
  String get chWc3TeamsDesc => 'Win the World Cup with 3 different nations.';

  @override
  String get chWcStreak3 => 'Three-Peat';

  @override
  String get chWcStreak3Desc => 'Win 3 World Cups in a row.';

  @override
  String get chWcAllconf => 'World Conqueror';

  @override
  String get chWcAllconfDesc =>
      'Win the World Cup with a nation from every confederation (6).';

  @override
  String get chCont5 => 'Continental King';

  @override
  String get chCont5Desc => 'Win 5 continental championships.';

  @override
  String get chContAll => 'Six-Continent Slam';

  @override
  String get chContAllDesc =>
      'Win every confederation’s continental championship (6).';

  @override
  String get chTreble => 'Clean Sweep';

  @override
  String get chTrebleDesc =>
      'Win the World Cup, a continental title and the Nations Cup in one career.';

  @override
  String get chNations10 => 'Nomad';

  @override
  String get chNations10Desc => 'Manage 10 different nations.';

  @override
  String get chYears100 => 'Century';

  @override
  String get chYears100Desc => 'Manage for 100 years.';

  @override
  String get chYears500 => 'Half a Millennium';

  @override
  String get chYears500Desc => 'Manage for 500 years.';

  @override
  String get chYears1000 => 'Eternal';

  @override
  String get chYears1000Desc => 'Manage for 1000 years.';

  @override
  String get chGrandmaster => 'Grandmaster';

  @override
  String get chGrandmasterDesc =>
      'Win 3 World Cups AND 5 continental championships.';

  @override
  String get chUndefeated => 'Untouchable';

  @override
  String get chUndefeatedDesc =>
      'Win a World Cup without losing a single match.';

  @override
  String get chPerfectQual => 'Flawless Passage';

  @override
  String get chPerfectQualDesc =>
      'Win every match of a World Cup qualifying campaign.';

  @override
  String get chMinnow => 'Minnow Miracle';

  @override
  String get chMinnowDesc =>
      'Win the World Cup with a nation ranked outside the world top 32.';

  @override
  String get chGrandTour => 'Home & Away';

  @override
  String get chGrandTourDesc =>
      'Win a World Cup as hosts and win one away from home.';

  @override
  String get chUnbeaten25 => 'The Wall';

  @override
  String get chUnbeaten25Desc => 'Go 25 competitive matches unbeaten.';

  @override
  String get chGoals10k => 'Goal Machine';

  @override
  String get chGoals10kDesc => 'Score 10,000 career goals.';

  @override
  String get chCleanSheets500 => 'Fortress';

  @override
  String get chCleanSheets500Desc => 'Keep 500 career clean sheets.';

  @override
  String get chHatTricks25 => 'Hat-trick Habit';

  @override
  String get chHatTricks25Desc => 'Have your players score 25 hat-tricks.';

  @override
  String get chWinStreak25 => 'Relentless';

  @override
  String get chWinStreak25Desc => 'Win 25 matches in a row.';

  @override
  String get chCont10 => 'Continental Dynasty';

  @override
  String get chCont10Desc => 'Win 10 continental championships.';

  @override
  String get chPcWc => 'Serial Champion';

  @override
  String chPcWcDesc(int count) {
    return 'Win $count World Cups this save.';
  }

  @override
  String get chPcMajors => 'Silverware Collector';

  @override
  String chPcMajorsDesc(int count) {
    return 'Win $count major trophies (World Cup, continental or Nations Cup).';
  }

  @override
  String get chPcUnbeaten => 'Iron Wall';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Go $count competitive matches unbeaten.';
  }

  @override
  String get chPcNations => 'Journeyman';

  @override
  String chPcNationsDesc(int count) {
    return 'Manage $count different nations.';
  }

  @override
  String get chPcYears => 'The Long Haul';

  @override
  String chPcYearsDesc(int count) {
    return 'Manage for $count years.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wins',
      one: '1 Win',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Win $count matches.',
      one: 'Win 1 match.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Matches',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Play $count matches.',
      one: 'Play 1 match.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'World Championship Qualifier';

  @override
  String get achQualWcDesc => 'Reach the World Championship finals.';

  @override
  String get achQualCont => 'Continental Qualifier';

  @override
  String get achQualContDesc => 'Reach your continental championship finals.';

  @override
  String get achTitleWc => 'World Champions';

  @override
  String get achTitleWcDesc => 'Win the World Championship.';

  @override
  String get achTitleEuro => 'European Champions';

  @override
  String get achTitleEuroDesc => 'Win the European Championship.';

  @override
  String get achTitleCopa => 'South America Champions';

  @override
  String get achTitleCopaDesc => 'Win the South America Cup.';

  @override
  String get achTitleAfcon => 'African Champions';

  @override
  String get achTitleAfconDesc => 'Win the African Championship.';

  @override
  String get achTitleAsia => 'Asian Champions';

  @override
  String get achTitleAsiaDesc => 'Win the Asian Championship.';

  @override
  String get achTitleConcacaf => 'North America Champions';

  @override
  String get achTitleConcacafDesc => 'Win the North America Cup.';

  @override
  String get achTitleOfc => 'Oceania Champions';

  @override
  String get achTitleOfcDesc => 'Win the Oceania Cup.';

  @override
  String get achTitleNations => 'Nations Cup Winners';

  @override
  String get achTitleNationsDesc => 'Win the Nations Cup.';

  @override
  String get achTitleClash => 'Continental Clash Winners';

  @override
  String get achTitleClashDesc => 'Win the Continental Clash.';

  @override
  String get achMarksman => 'World Championship Marksman';

  @override
  String get achMarksmanDesc =>
      'Have a squad player score 6+ World Championship finals goals.';

  @override
  String get achSweep => 'Clean Sweep';

  @override
  String get achSweepDesc =>
      'Hold the World Championship and your continental title in one career.';

  @override
  String get achAllstar => 'Tournament All-Star';

  @override
  String get achAllstarDesc =>
      'Have a player named in a World Championship Team of the Tournament.';

  @override
  String get achGoldenboot => 'Golden Boot';

  @override
  String get achGoldenbootDesc =>
      'Have your nation finish as a championship top scorer.';

  @override
  String get achDemolition => 'Demolition';

  @override
  String get achDemolitionDesc => 'Win a match by 5 goals or more.';

  @override
  String get achievementsNice => 'Nice!';

  @override
  String get achievementsHardestTests =>
      'The hardest tests of a manager, across a whole career and many nations.';

  @override
  String get achievementsThisSave => 'THIS SAVE';

  @override
  String get achievementsBrutalBadge => 'BRUTAL';

  @override
  String get paywallGoPro => 'GO PRO';

  @override
  String get paywallOneTimeUnlock => 'One-time unlock. No subscription.';

  @override
  String get paywallBenefitEveryNation => 'Manage every nation in the world';

  @override
  String get paywallBenefitSaveSlots => 'Five save slots instead of two';

  @override
  String get paywallBenefitEndless => 'Endless careers, forever';

  @override
  String get paywallUnlocked => 'Premium is unlocked — enjoy!';

  @override
  String get paywallContactingStore => 'Contacting the store…';

  @override
  String get paywallUnlockPro => 'Unlock Pro';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Unlock Pro · $price';
  }

  @override
  String get paywallRestorePurchases => 'Restore purchases';

  @override
  String get federationNaturalisation => 'NATURALISATION';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name naturalised';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name has completed the switch and is now eligible for $nation. Call them up from your squad selection.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Could not load offer.\n$error';
  }

  @override
  String get federationContinue => 'Continue';

  @override
  String get federationOfferToSwitchAllegiance =>
      'AN OFFER TO SWITCH ALLEGIANCE';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · age $age · from $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name has ties to $playerNation and is willing to be naturalised. Accept and they can be selected; decline and they stay with $sourceNation.';
  }

  @override
  String get federationDecline => 'Decline';

  @override
  String get federationNaturalise => 'Naturalise';

  @override
  String get federationSetYourBudget => 'SET YOUR BUDGET';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Could not load finances.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Save not found.';

  @override
  String get federationBudgetHeading => 'FEDERATION BUDGET';

  @override
  String federationDistributeBudget(String amount) {
    return 'Distribute $amount across the departments to open the cycle. Spend it wisely.';
  }

  @override
  String get federationAllocateFullBudget =>
      'Allocate the full budget to begin the cycle.';

  @override
  String get federationConfirming => 'Confirming…';

  @override
  String get federationConfirmBudget => 'Confirm budget';

  @override
  String get federationFinances => 'FINANCES';

  @override
  String get federationInvestmentUpdated => 'Investment updated.';

  @override
  String get federationDevelopment => 'FEDERATION DEVELOPMENT';

  @override
  String get federationProjectedAtSeasonEnd => 'PROJECTED AT SEASON END';

  @override
  String get federationCentralFunding => 'Central funding';

  @override
  String get federationPrizeMoneySoFar => 'Prize money so far';

  @override
  String get federationCommercialReturn => 'Commercial return';

  @override
  String get federationThisSeasonLocked => 'THIS SEASON (LOCKED)';

  @override
  String get federationInvestForNextSeason => 'INVEST FOR NEXT SEASON';

  @override
  String get federationNextSeasonImpact => 'NEXT SEASON IMPACT';

  @override
  String get federationSaving => 'Saving…';

  @override
  String get federationConfirmInvestment => 'Confirm investment';

  @override
  String get federationBalance => 'FEDERATION BALANCE';

  @override
  String get federationInvestAtCeremony =>
      'Invest for next season at the end-of-cycle ceremony.';

  @override
  String federationLevelBadge(int level) {
    return 'L$level';
  }

  @override
  String get federationAcademyProspects => 'Academy prospects';

  @override
  String federationPlusOverall(int value) {
    return '+$value overall';
  }

  @override
  String get federationInjuryRisk => 'Injury risk';

  @override
  String get federationNaturalisationChance => 'Naturalisation chance';

  @override
  String get federationBoardPatience => 'Board patience';

  @override
  String get federationUnallocated => 'UNALLOCATED';

  @override
  String get nationsVitrineTitle => 'NATIONAL VITRINE';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Could not load nation.\n$error';
  }

  @override
  String get nationsNoNation => 'No nation.';

  @override
  String get nationsHonours => 'HONOURS';

  @override
  String get nationsRankingHistory => 'WORLD RANKING HISTORY';

  @override
  String get nationsTopScorers => 'ALL-TIME TOP SCORERS';

  @override
  String get nationsTitles => 'TITLES';

  @override
  String get nationsYourTeam => 'YOUR TEAM';

  @override
  String get nationsWorld => 'WORLD';

  @override
  String get nationsWorldCup => 'World Cup';

  @override
  String get nationsContinental => 'Continental';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appearances',
      one: '1 appearance',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Not enough history yet — check back after a cycle or two.';

  @override
  String nationsBestRank(int rank) {
    return 'Best: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Now: #$rank';
  }

  @override
  String get nationsNoGoals => 'No goals recorded yet.';

  @override
  String get nationsGoalsAbbrev => 'gls';

  @override
  String get nationsHosts => 'HOSTS';

  @override
  String get nationsSelectTitle => 'SELECT NATIONAL TEAM';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Could not load nations.\n$error';
  }

  @override
  String get nationsNoMatch => 'No nations match.';

  @override
  String get nationsNationalLevel => 'NATIONAL LEVEL';

  @override
  String get nationsSelectHeading => 'Select National Team';

  @override
  String get nationsSearchHint => 'Search country…';

  @override
  String get nationsRank => 'RANK ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'SELECT';

  @override
  String get nationsNavCareer => 'Career';

  @override
  String get nationsNavTactics => 'Tactics';

  @override
  String get nationsNavNations => 'Nations';

  @override
  String get nationsNavSettings => 'Settings';

  @override
  String get statsTeamRecords => 'TEAM RECORDS';

  @override
  String get statsRecordBook => 'Record book';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Could not load stats.\n$error';
  }

  @override
  String get statsNoData => 'No data.';

  @override
  String get statsTopScorers => 'TOP SCORERS';

  @override
  String get statsMostGamesPlayed => 'MOST GAMES PLAYED';

  @override
  String get statsTeam => 'Team';

  @override
  String get statsTopScorersShort => 'Scorers';

  @override
  String get statsMostGames => 'Most games';

  @override
  String get statsNoGoalsRecorded => 'No goals recorded yet.';

  @override
  String get statsUnknown => 'Unknown';

  @override
  String get playerTitle => 'PLAYER';

  @override
  String playerLoadError(String error) {
    return 'Could not load player.\n$error';
  }

  @override
  String get playerNotFound => 'Player not found.';

  @override
  String get playerClub => 'CLUB';

  @override
  String get playerPosition => 'Position';

  @override
  String get playerPotential => 'Potential';

  @override
  String get playerAge => 'Age';

  @override
  String get playerValue => 'Value';

  @override
  String get clubFirstChoice => 'Plays every week';

  @override
  String get clubRotation => 'In and out';

  @override
  String get clubFringe => 'Barely playing';

  @override
  String get clubFrozenOut => 'Not playing';

  @override
  String yWinUpset0(String opponent, String score) {
    return 'I have watched football for thirty years and I did not see that coming. $opponent beaten $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Nobody gave them a prayer against $opponent. $score. Absolutely nobody.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score against $opponent. Go and wake the neighbours.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'That is the kind of night people describe to their grandchildren. $opponent $score.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$score against $opponent. Job done, nothing learned.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return 'Beat $opponent $score. We were supposed to, and we did.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return 'A professional $score over $opponent. Next.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return '$opponent dispatched $score. File it and move on.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score against $opponent and every minute of it earned.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Nervy, ugly, and a win. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Beat $opponent $score. Take the three points and never watch it again.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score. $opponent made us work for every inch of that.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return '$score with $opponent. Two points dropped or one gained — pick your mood.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return 'A draw against $opponent, $score. Nobody is happy, nobody is furious.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent $score. The most forgettable ninety minutes of the year.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return 'Shared the spoils with $opponent, $score. On we go.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Beaten $score by $opponent. It happens.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. We were second best and there is no argument.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Lost $score to $opponent. Regroup.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score to $opponent. Not a disgrace, not good enough.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score. To $opponent. I have no words and I am paid to have words.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'That was not a defeat to $opponent, it was a surrender. $score.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Somebody has to answer for that.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'I want the $score against $opponent struck from the record and from memory.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'CHAMPIONS. $opponent. Say it out loud.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'We won it. $opponent. I am not okay.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent — and the trophy is coming home.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Every single one of them a legend. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'So close. $opponent and a medal nobody wants.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Runners-up at $opponent. It will sting for years.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: one match from everything.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Second. At $opponent. Somebody pass the bottle.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Out at $opponent. Same script, different year.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent is where it ends. Again.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Eliminated at $opponent. Now the inquest.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Knocked out at $opponent. Somebody explain that to me.';
  }

  @override
  String yQualified0(String opponent) {
    return 'WE ARE GOING TO $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Qualified for $opponent. Book the time off work.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, here we come. Never in doubt (it was entirely in doubt).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Through to $opponent. That is the hard part done.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Group drawn for $opponent. Could be worse. Could be a lot worse.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'So that is the $opponent draw. Interesting.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'The $opponent groups are out and I already do not like ours.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return '$opponent draw made. Let the overreaction begin.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent will host it. Start saving.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'It is going to $opponent. Predictable, but fine.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent gets the tournament. Congratulations to them, I suppose.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Hosts confirmed: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent starts soon and I cannot sit still.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Not long now until $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent is nearly here. Squad announcement, please.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Countdown to $opponent is officially unbearable.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Nothing to say yet. Play a match.';

  @override
  String hubEventGrievance(String player) {
    return '$player wants a word';
  }

  @override
  String get hubEventGrievanceSub => 'He wants to know where he stands';

  @override
  String get grievanceTitle => 'A word in your office';

  @override
  String grievanceGameTime(String player) {
    return '$player has been in the squad and has not kicked a ball. He wants to know why.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player is not in the squad and cannot understand it. He wants telling, one way or the other.';
  }

  @override
  String grievanceRole(String player) {
    return '$player keeps being played out of position and has had enough of it.';
  }

  @override
  String get grievanceReassure => 'You are in my plans';

  @override
  String get grievanceHonest => 'You are behind others, and here is why';

  @override
  String get grievanceDismiss => 'I pick the team';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name got $goals of them. Nobody else is close.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals for $name. He is carrying this side.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals on the day. Some player.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return 'Put $goals past them, did $name. Take a bow.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count on the bounce. Whatever is being said in that dressing room, it is landing.';
  }

  @override
  String yWinStreak1(String count) {
    return 'That is $count straight. Sides do not stumble into runs like this.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count in a row and counting. The confidence is visible from the stands.';
  }

  @override
  String yWinStreak3(String count) {
    return 'No defeats in $count. Ask anyone who has managed — that is the hard part.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count without a win now. At some point the excuses run out.';
  }

  @override
  String yLossStreak1(String count) {
    return 'That is $count in a row gone. This is not a blip any more.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count straight defeats. Somebody has to answer for it.';
  }

  @override
  String yLossStreak3(String count) {
    return 'No wins in $count. You can see it in how they play.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Say what you like about the football — this one counts double.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Against $opponent, of all of them. $score. Nobody here will forget it.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score against $opponent. That is the one they will talk about in the pubs.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Neighbours, $score. Bragging rights settled for a while.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name off injured. That is the last thing this side needed.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Losing $name changes the shape of everything.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name limping. Hold your breath.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'No $name for a while, then. Somebody has to step up.';
  }

  @override
  String get yBoardPressure0 =>
      'The board have gone very quiet. That is never a good sign.';

  @override
  String get yBoardPressure1 =>
      'Word is the boardroom has started asking questions.';

  @override
  String get yBoardPressure2 => 'You can feel the ground shifting upstairs.';

  @override
  String get yBoardPressure3 =>
      'Nobody at the federation is saying anything supportive. Draw your own conclusions.';

  @override
  String get yReplies => 'ALSO ABOUT THIS MATCH';

  @override
  String get yPlayerGrievance0 =>
      'Asked where I stand. Still waiting on an answer.';

  @override
  String get yPlayerGrievance1 => 'Training hard. Not much else I can do.';

  @override
  String get yPlayerGrievance2 => 'Some questions you only get to ask once.';

  @override
  String get yPlayerGrievance3 => 'I did not come this far to carry the bibs.';

  @override
  String get playerHonoursTitle => 'HONOURS';

  @override
  String get awardGoldenBall => 'Golden Ball';

  @override
  String get awardGoldenBoot => 'Golden Boot';

  @override
  String get awardGoldenGlove => 'Golden Glove';

  @override
  String get awardTeamOfTournament => 'Team of the Tournament';

  @override
  String get awardPlayerOfYear => 'World Player of the Year';

  @override
  String get awardYoungPlayerOfYear => 'Young Player of the Year';

  @override
  String get playerClubHistory => 'CLUB HISTORY';

  @override
  String get playerCareerRecord => 'CAREER RECORD';

  @override
  String get playerInternationalGoals => 'International goals';

  @override
  String get playerRecentForm => 'RECENT FORM';

  @override
  String get playerMatchHistory => 'MATCH HISTORY';

  @override
  String get playerAttributes => 'ATTRIBUTES';

  @override
  String get playerUnknown => 'Unknown';

  @override
  String get playerAttrPace => 'Pace';

  @override
  String get playerAttrPhysical => 'Physical';

  @override
  String get playerAttrTechnical => 'Technical';

  @override
  String get playerAttrShooting => 'Shooting';

  @override
  String get playerAttrPassing => 'Passing';

  @override
  String get playerAttrDribbling => 'Dribbling';

  @override
  String get playerAttrTackling => 'Tackling';

  @override
  String get playerAttrPositioning => 'Positioning';

  @override
  String get playerAttrComposure => 'Composure';

  @override
  String get playerAttrDecisions => 'Decisions';

  @override
  String get playerAttrStamina => 'Stamina';

  @override
  String get playerAttrStrength => 'Strength';

  @override
  String get playerStatCaps => 'Caps';

  @override
  String get playerStatGoals => 'Goals';

  @override
  String get playerStatAssists => 'Assists';

  @override
  String get playerStatAvgRating => 'Avg rating';

  @override
  String get playerStatForm => 'Form';

  @override
  String get playerStatMotm => 'Player of Match';

  @override
  String get playerStatCleanSheets => 'Clean sheets';

  @override
  String get playerStatBestGame => 'Best game';

  @override
  String get playerStatCards => 'Cards';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}Y ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'YOUR RUN';

  @override
  String get tourSharedList => 'List';

  @override
  String get tourSharedBracket => 'Bracket';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Group $seed';
  }

  @override
  String get tourSharedThisEdition => 'This edition';

  @override
  String get tourSharedAllTime => 'All-time';

  @override
  String get tourSharedUnknown => 'Unknown';

  @override
  String get tourSharedActive => 'ACTIVE';

  @override
  String get tourSharedMedalTable => 'MEDAL TABLE';

  @override
  String get tourSharedPastWinners => 'PAST WINNERS';

  @override
  String tourSharedHost(String host) {
    return 'Host: $host';
  }

  @override
  String get tourSharedBeat => 'beat';

  @override
  String get tourSharedPens => ' (pens)';

  @override
  String get tourSharedAwardsEmpty =>
      'The awards are decided once the tournament is played out.';

  @override
  String get tourSharedGoldenBall => 'GOLDEN BALL';

  @override
  String get tourSharedPlayerOfTournament => 'Player of the Tournament';

  @override
  String get tourSharedGoldenBoot => 'GOLDEN BOOT';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goals',
      one: '1 goal',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'GOLDEN GLOVE';

  @override
  String get tourSharedTeamOfTournament => 'TEAM OF THE TOURNAMENT';

  @override
  String get tourSharedStatsEmpty =>
      'Records appear once the competition has some history.';

  @override
  String get tourSharedRecordScorer => 'RECORD SCORER';

  @override
  String get tourSharedStillActive => 'still active';

  @override
  String get tourSharedMostTitles => 'MOST TITLES';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titles',
      one: '1 title',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'MOST FINALS';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finals contested',
      one: '1 final contested',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'MOST GAMES PLAYED';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'MOST FINALS PLAYED';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finals tournaments',
      one: '1 finals tournament',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'BIGGEST FINAL WIN';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goals',
      one: '1 goal',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'still active';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titles',
      one: '1 title',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finals contested',
      one: '1 final contested',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finals tournaments',
      one: '1 finals tournament',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'ALL-TIME LEADERS';

  @override
  String get tourStatsTabGames => 'Games';

  @override
  String get tourStatsTabCups => 'Cups';

  @override
  String get tourStatsTabScorers => 'Scorers';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'v $opponent · $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'ALL-TIME SCORERS';

  @override
  String get tourSharedSummaryEmpty =>
      'The host and its stadiums appear once this edition is drawn.';

  @override
  String get tourSharedHostHeading => 'HOST';

  @override
  String get tourSharedHostsHeading => 'HOSTS';

  @override
  String get tourSharedCoHostsHeading => 'CO-HOSTS';

  @override
  String get tourSharedVenues => 'VENUES';

  @override
  String get tourSharedMascot => 'MASCOT';

  @override
  String get tourSharedMatchBall => 'MATCH BALL';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity seats';
  }

  @override
  String get tourSharedCouldNotLoad => 'Could not load.';

  @override
  String get tourSharedHostTbc => 'HOST TO BE CONFIRMED';

  @override
  String get tourSharedFinalsAreHere => 'THE FINALS ARE HERE';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'HOSTED BY  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Let the finals begin';

  @override
  String get tourSharedCompetitions => 'COMPETITIONS';

  @override
  String get tourSharedWorldRanking => 'World ranking';

  @override
  String get tourSharedCouldNotLoadTournaments => 'Could not load tournaments.';

  @override
  String get tourSharedPrestigeStage => 'PRESTIGE STAGE';

  @override
  String get tourSharedOverview => 'Overview';

  @override
  String get tourSharedWorldRankingTitle => 'World Ranking';

  @override
  String get tourSharedYourCompetitions => 'YOUR COMPETITIONS';

  @override
  String get tourSharedOtherContinents => 'OTHER CONTINENTS';

  @override
  String get tourSharedComingSoon => 'Tournament coming soon';

  @override
  String get tourSharedSoon => 'SOON';

  @override
  String get tourSharedNoQualifyingDraw => 'No qualifying draw.';

  @override
  String get tourSharedOpenEnvelope => 'Open the envelope';

  @override
  String tourSharedGroupName(String name) {
    return 'GROUP $name';
  }

  @override
  String get tourSharedBall => 'Ball';

  @override
  String get tourSharedPot => 'Pot';

  @override
  String get tourSharedAll => 'All';

  @override
  String get tourSharedTapDrawTeam => 'Tap to draw the next team';

  @override
  String get tourSharedTapDrawPot => 'Tap to draw the next pot';

  @override
  String get tourSharedTapDrawAll => 'Tap to reveal the whole draw';

  @override
  String get tourSharedContinue => 'Continue';

  @override
  String get tourSharedPause => 'Pause';

  @override
  String get tourSharedPlay => 'Play';

  @override
  String get tourSharedSkip => 'Skip';

  @override
  String tourSharedPotNumber(int number) {
    return 'POT $number';
  }

  @override
  String get tourSharedDrawComplete => 'DRAW COMPLETE';

  @override
  String get tourSharedDrawing => 'DRAWING…';

  @override
  String get tourContChampionship => 'CHAMPIONSHIP';

  @override
  String get tourContTabSummary => 'SUMMARY';

  @override
  String get tourContTabQualifying => 'QUALIFYING';

  @override
  String get tourContTabFinals => 'FINALS';

  @override
  String get tourContTabBracket => 'BRACKET';

  @override
  String get tourContTabAwards => 'AWARDS';

  @override
  String get tourContTabScorers => 'SCORERS';

  @override
  String get tourContTabHistory => 'HISTORY';

  @override
  String get tourContTabRecords => 'RECORDS';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Could not load cup.\n$error';
  }

  @override
  String get tourContNoCupData => 'No cup data.';

  @override
  String get tourContUnknown => 'Unknown';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'The qualifying groups are drawn at the ceremony. Watch from the hub to see who you face.';

  @override
  String get tourContQualSeeded =>
      'Your nation is seeded straight into the finals. No qualifying this cycle.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name is simulated in the background. Results appear here as each round is played.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'The finals groups are drawn at the ceremony. Watch from the hub to see your group.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'The finals draw takes place once qualifying is complete.';

  @override
  String get tourContContestedBeforeWc =>
      'The knockout rounds are played out before the World Cup.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name CHAMPIONS';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name winners';
  }

  @override
  String get tourContNoGoalsYet => 'No goals scored yet.';

  @override
  String tourContGroupHeading(String name) {
    return 'GROUP $name';
  }

  @override
  String get tourContBestRunnersUp => 'BEST RUNNERS-UP';

  @override
  String tourContGroupDropdown(String name) {
    return 'Group $name';
  }

  @override
  String get tourContMatches => 'MATCHES';

  @override
  String get tourContNoGroupsDrawn => 'No groups drawn yet.';

  @override
  String get tourContQualifyingDraw => 'QUALIFYING DRAW';

  @override
  String get tourContGroupDraw => 'GROUP DRAW';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Could not load draw.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'The draw is not ready yet.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'THIS CYCLE';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Could not load.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Save not found.';

  @override
  String get tourContClashSoon =>
      'The Continental Clash is played once both continental champions are known.';

  @override
  String get tourContTwoContinentsOneMatch => 'TWO CONTINENTS, ONE MATCH';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name win the Clash';
  }

  @override
  String get tourContNoClashYet => 'No Continental Clash played yet.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'LEAGUES';

  @override
  String get tourContTabFinalsFour => 'FINALS FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Could not load.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals => 'No Nations Cup goals recorded yet.';

  @override
  String get tourContNoNationsCupChampions =>
      'No Nations Cup champions crowned yet.';

  @override
  String get tourContNationsCupOffSeason =>
      'This cycle’s Nations Cup begins after the continental finals. Past winners are under History.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'This cycle’s Nations Cup groups are drawn at the ceremony. Watch from the hub to see who you face.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LEAGUE $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LEAGUE $letter · YOUR LEAGUE';
  }

  @override
  String get tourContFinalsFourSoon =>
      'The Finals Four is contested by League A’s group winners once the group stage is done.';

  @override
  String tourContLeagueChip(String letter) {
    return 'League $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'League $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEMI-FINALS';

  @override
  String get tourContFinal => 'FINAL';

  @override
  String get tourContNationsCupDraw => 'NATIONS CUP DRAW';

  @override
  String get tourContIntercontinentalPlayoff => 'INTERCONTINENTAL PLAY-OFF';

  @override
  String get tourContNoPlayoffThisCycle => 'No play-off this cycle.';

  @override
  String get tourContPlayoffIntro =>
      'Two World Cup places decided across a knockout of the best qualifying also-rans.';

  @override
  String get tourContPlayoffThrough =>
      'You came through the play-off — you\'re at the World Cup!';

  @override
  String get tourContPlayoffOut =>
      'You fell short in the play-off — no World Cup this time.';

  @override
  String get tourContContinue => 'Continue';

  @override
  String get tourContPlayoffFinals => 'PLAY-OFF FINALS';

  @override
  String get tourContPlayoffSeeded => 'Seeded — bye';

  @override
  String get tourCupTabSummary => 'SUMMARY';

  @override
  String get tourCupTabQualifying => 'QUALIFYING';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'The intercontinental play-off is decided once every confederation\'s qualifying is complete.';

  @override
  String get tourCupTabFinals => 'FINALS';

  @override
  String get tourCupTabBracket => 'BRACKET';

  @override
  String get tourCupTabAwards => 'AWARDS';

  @override
  String get tourCupTabScorers => 'SCORERS';

  @override
  String get tourCupTabHistory => 'HISTORY';

  @override
  String get tourCupTabRecords => 'RECORDS';

  @override
  String get tourCupTitle => 'WORLD CHAMPIONSHIP';

  @override
  String get tourCupNoData => 'No cup data.';

  @override
  String tourCupLoadError(String error) {
    return 'Could not load cup.\n$error';
  }

  @override
  String get tourCupUnknown => 'Unknown';

  @override
  String get tourCupWorldChampions => 'WORLD CHAMPIONS';

  @override
  String get tourCupWorldChampionsTitle => 'World Champions';

  @override
  String get tourCupActive => 'ACTIVE';

  @override
  String get tourCupStillActive => 'Still active';

  @override
  String get tourCupAllTimeScorers => 'ALL-TIME SCORERS';

  @override
  String get tourCupAllConfederations => 'All confederations';

  @override
  String get tourCupBestRunnersUp => 'Best runners-up';

  @override
  String get tourCupCompWorld => 'World Cup';

  @override
  String get tourCupCompEurope => 'European Championship';

  @override
  String get tourCupCompSAmerica => 'South America Cup';

  @override
  String get tourCupDestFinals => 'the finals';

  @override
  String get tourCupDestFinalsPlayoff => 'the finals play-off';

  @override
  String get tourCupDestIntercontPlayoff => 'the intercontinental play-off';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'The finals are drawn once qualifying ends.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Groups to be drawn — watch the World Cup draw from the hub to reveal them.';

  @override
  String tourCupGroupName(String name) {
    return 'Group $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Group $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Hosted by $host';
  }

  @override
  String get tourCupIntercontPlayoff => 'Intercontinental play-off';

  @override
  String get tourCupKnockoutSoon =>
      'The bracket begins once the group stage ends.';

  @override
  String get tourCupMatches => 'MATCHES';

  @override
  String get tourCupMedalTable => 'MEDAL TABLE';

  @override
  String get tourCupMostTitles => 'MOST TITLES';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation — $titles titles from $editions editions';
  }

  @override
  String get tourCupNoGoals => 'No goals yet.';

  @override
  String get tourCupNoGroups => 'No groups drawn.';

  @override
  String get tourCupNoHistory => 'No history yet.';

  @override
  String get tourCupPastWinners => 'PAST WINNERS';

  @override
  String get tourCupPlayoffIntro =>
      'Two World Cup places decided across a knockout of the best qualifying also-rans.';

  @override
  String get tourCupQualDrawSoon =>
      'Groups to be drawn — watch the qualifying draw from the hub to reveal them.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · yours';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (pens)';
  }

  @override
  String get tourCupSegAllTime => 'All-time';

  @override
  String get tourCupSegFinals => 'Finals';

  @override
  String get tourCupSegQualifying => 'Qualifying';

  @override
  String get playerTraitsTitle => 'KNOWN FOR';

  @override
  String get traitBigGame => 'Big-game player';

  @override
  String get traitBigGameBlurb => 'Raises his game in knockout ties.';

  @override
  String get traitSetPiece => 'Set-piece specialist';

  @override
  String get traitSetPieceBlurb =>
      'Better delivery — more goals from dead balls.';

  @override
  String get traitHothead => 'Hothead';

  @override
  String get traitHotheadBlurb =>
      'Picks up far more cards than his team-mates.';

  @override
  String get traitIronMan => 'Iron man';

  @override
  String get traitIronManBlurb => 'Rarely gets hurt and tires more slowly.';

  @override
  String get traitWonderkid => 'Wonderkid';

  @override
  String get traitWonderkidBlurb =>
      'Young, already good, and still improving fast.';

  @override
  String get traitLeader => 'Leader';

  @override
  String get traitLeaderBlurb => 'Lifts every team-mate on the pitch.';

  @override
  String get traitPacey => 'Pacey';

  @override
  String get traitPaceyBlurb => 'Blistering pace — a threat in behind.';

  @override
  String get traitOldHead => 'Old head';

  @override
  String get traitOldHeadBlurb =>
      'A veteran whose reading of the game outlasts his legs.';

  @override
  String get traitWasteful => 'Wasteful';

  @override
  String get traitWastefulBlurb => 'Puts too many good chances wide.';

  @override
  String get objectiveWorldCup => 'World Cup';

  @override
  String get objectiveWinTournament => 'Win it';

  @override
  String get objectiveQualifyGeneric => 'Qualify';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Win the World Cup';

  @override
  String get objectiveReachFinal => 'Reach the final';

  @override
  String get objectiveReachSemis => 'Reach the semi-finals';

  @override
  String get objectiveReachQuarters => 'Reach the quarter-finals';

  @override
  String get objectiveReachKnockouts => 'Reach the knockout rounds';

  @override
  String get objectiveQualify => 'Qualify for the World Cup';

  @override
  String get finishChampions => 'Champions';

  @override
  String get finishRunnersUp => 'Runners-up';

  @override
  String get finishSemiFinals => 'Semi-finals';

  @override
  String get finishQuarterFinals => 'Quarter-finals';

  @override
  String get finishRoundOf16 => 'Round of 16';

  @override
  String get finishGroupStage => 'Group stage';

  @override
  String get finishDidNotQualify => 'Did not qualify';

  @override
  String get objectiveAvoidBottom => 'Avoid finishing bottom in qualifying';

  @override
  String get finishBottomOfQualifyingGroup => 'Bottom of the qualifying group';

  @override
  String get objectiveNcWinIt => 'Win the Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Reach the Nations Cup final';

  @override
  String get objectiveNcFinalsFour => 'Reach the Finals Four';

  @override
  String get objectiveNcWinGroup => 'Win your group and go up';

  @override
  String get objectiveNcTopHalf => 'Finish in the top half of your group';

  @override
  String get objectiveNcSurvive => 'Avoid relegation';

  @override
  String get finishNcChampions => 'Nations Cup winners';

  @override
  String get finishNcFinalsFour => 'Finals Four';

  @override
  String get finishNcGroupWinners => 'Group winners';

  @override
  String get finishNcTopHalf => 'Top half of the group';

  @override
  String get finishNcStayedUp => 'Stayed up';

  @override
  String get finishNcBottom => 'Bottom of the group';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'PLAYER';

  @override
  String get squadDevAge => 'AGE';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'RATING';

  @override
  String get squadDevNew => 'NEW';

  @override
  String get squadDevRetired => 'RETIRED';

  @override
  String get squadDevEmpty => 'A settled year. No changes across the squad.';

  @override
  String get boardObjectivesTitle => 'Board objectives';

  @override
  String get boardObjectivesConfidence => 'Board confidence';

  @override
  String get boardObjectivesPending => 'STILL TO BE DECIDED';

  @override
  String boardObjectiveSoFar(String result) {
    return 'SO FAR · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'The board has not set an objective for this cycle.';

  @override
  String get tourContBestWinners => 'BEST GROUP WINNERS';

  @override
  String get tourContBestThirds => 'BEST THIRD-PLACED';

  @override
  String tourContBestPlaced(String position) {
    return 'BEST ${position}TH-PLACED';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return 'Page $page of $pages · $total players';
  }

  @override
  String get matchSoldOut => 'SOLD OUT';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance of $capacity seats filled';
  }

  @override
  String get matchGroundTitle => 'VENUE';

  @override
  String get absenceInjured => 'Injured';

  @override
  String get absenceSuspended => 'Suspended';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String absenceGames(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString games',
      one: '1 game',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Back for $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Penalties';

  @override
  String get penaltyOrderBlurb =>
      'Name your five takers, in order. Tap a slot to change it.';

  @override
  String penaltyOrderPick(int number) {
    return 'Kick $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Pick who steps up. The bar is their composure from the spot.';

  @override
  String get penaltyOrderConfirm => 'Take them';

  @override
  String get penaltyOrderCancel => 'Back';

  @override
  String get youthTitle => 'Youth';

  @override
  String get youthEmptyLevel => 'Nobody at this level yet.';

  @override
  String get youthReleased => 'Released this year';

  @override
  String get u21Title => 'Under-21s';

  @override
  String get u21Blurb =>
      'The next generation, best prospect first. Hollow stars are a scout\'s estimate — cap a player to find out what he really has.';

  @override
  String get u21Empty =>
      'Nobody under 21 in the pool right now. The next intake arrives with the new cycle.';

  @override
  String u21Breakout(int gain) {
    return '+$gain THIS YEAR';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Age $age · $caps caps';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Age $age · uncapped';
  }

  @override
  String get u21CallUps => 'Go to call-ups';

  @override
  String get tacticsYouth => 'Under-21s';

  @override
  String get pressTitle => 'Press conference';

  @override
  String get pressCardTitle => 'The press are waiting';

  @override
  String get pressCardSub =>
      'One question. What you say moves the dressing room and the board.';

  @override
  String get pressTheOpposition => 'the opposition';

  @override
  String get pressSquad => 'Squad';

  @override
  String get pressBoard => 'Board';

  @override
  String get pressNoEffect => 'Nobody reads much into it';

  @override
  String pressAskHeavyDefeat(String opponent) {
    return 'That was a chastening night against $opponent. What went wrong?';
  }

  @override
  String pressAskElimination(String opponent) {
    return 'Beaten by $opponent, and the tournament is over. How do you explain it?';
  }

  @override
  String get pressAskUnderPressure =>
      'Three games without a win, and the board are watching. Are you still the right man?';

  @override
  String get pressAskPreview =>
      'The tournament starts here. How far does this squad go?';

  @override
  String get pressAskTriumph =>
      'Champions. Where does this rank, and what comes next?';

  @override
  String get pressAnswerBackPlayers =>
      'These players gave me everything. I would not swap a single one of them.';

  @override
  String get pressAnswerTakeBlame =>
      'That one is on me. I picked the side and I set them up.';

  @override
  String get pressAnswerDemandMore =>
      'Not good enough. Some of them have to look at themselves.';

  @override
  String get pressAnswerRaiseBar =>
      'We are here to win it. Anything less is a failure.';

  @override
  String get pressAnswerPlayDown =>
      'We take it one game at a time. Nothing more to add.';

  @override
  String get matchNeutralGround => 'NEUTRAL';

  @override
  String get matchExtraTimeAhead => 'EXTRA TIME';

  @override
  String get matchExtraTimeHalf => 'EXTRA TIME · HALF TIME';

  @override
  String get hubEventPressConference => 'Face the press';

  @override
  String get hubEventPressConferenceSub =>
      'The world’s media want a word before your first match';

  @override
  String pressAskOpening(String opponent) {
    return 'The tournament is open and you start against $opponent. What are you telling the country?';
  }

  @override
  String get squadDevWonderkid => 'WONDERKID';

  @override
  String get tacticsPlaystyle => 'Playing style';

  @override
  String get tacticsPlaystyleBlurb =>
      'Pick how the side plays; the dials below fine-tune it.';

  @override
  String get tacticsPlaystyleCustom =>
      'Your own settings — no named style matches these dials.';

  @override
  String get playstyleCustom => 'Custom';

  @override
  String get playstyleBalanced => 'Balanced';

  @override
  String get playstylePossession => 'Possession';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Counter-attack';

  @override
  String get playstyleDirect => 'Direct';

  @override
  String get playstyleLowBlock => 'Low block';

  @override
  String get playstyleWingPlay => 'Wing play';

  @override
  String get playstyleBalancedBlurb =>
      'Solid in both halves, with nothing overdone.';

  @override
  String get playstylePossessionBlurb =>
      'Keep the ball, move it patiently, squeeze the pitch.';

  @override
  String get playstyleGegenpressBlurb =>
      'Win it back the second it is lost, high up the pitch.';

  @override
  String get playstyleCounterBlurb =>
      'Sit off, stay compact, then break at speed.';

  @override
  String get playstyleDirectBlurb =>
      'Forward early and play for the second ball.';

  @override
  String get playstyleLowBlockBlurb =>
      'Deep, narrow and very hard to break down.';

  @override
  String get playstyleWingPlayBlurb =>
      'Stretch the pitch, get round the outside and cross.';

  @override
  String get nationsRandomTeam => 'Random team';

  @override
  String get nationsFromTheBottom => 'From the bottom';

  @override
  String get bottomStartTitle => 'Out of work';

  @override
  String get bottomStartHeading => 'Three federations want to talk';

  @override
  String get bottomStartBlurb =>
      'You have no job and no reputation. These are the only sides willing to take a chance on you — take one and build something from nothing.';

  @override
  String get bottomStartAccept => 'Take it';

  @override
  String get bottomStartBack => 'Back to menu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank of $total in the world';
  }

  @override
  String get campTitle => 'Base camp';

  @override
  String campBasedIn(String host) {
    return 'Based in $host';
  }

  @override
  String get campBlurb =>
      'Where the squad lives for the tournament. Each base trades one preparation for another.';

  @override
  String get campEffectTravel => 'Travel';

  @override
  String get campEffectRecovery => 'Recovery';

  @override
  String get campEffectSharpness => 'Sharpness';

  @override
  String get campTerrainCity => 'City centre';

  @override
  String get campTerrainCoastal => 'Coastal resort';

  @override
  String get campTerrainMountain => 'Mountain retreat';

  @override
  String get campTerrainAltitude => 'Altitude camp';

  @override
  String get campTerrainNationalCentre => 'National centre';

  @override
  String get campTerrainCityBlurb =>
      'Everything on the doorstep and nothing to travel to — but no peace, and no escape from the noise.';

  @override
  String get campTerrainCoastalBlurb =>
      'Calm, comfortable and good for the mood; a long coach ride to every ground.';

  @override
  String get campTerrainMountainBlurb =>
      'Cool air and a first-rate medical set-up that turns knocks round quickly, a long way from the tournament.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Hard work to train in, and legs that last deep into the tournament.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'The federation\'s own facilities: nothing spectacular, nothing to go wrong.';

  @override
  String get hubEventChooseCamp => 'Choose the base camp';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Where the squad will be based in $host';
  }

  @override
  String get tacticsTabBench => 'Bench';

  @override
  String get squadSearchHint => 'Search by name or club';

  @override
  String get squadFilterAll => 'Everyone';

  @override
  String get squadFilterInSquad => 'In the squad';

  @override
  String get squadFilterUncapped => 'Uncapped';

  @override
  String get squadFilterUnavailable => 'Unavailable';

  @override
  String get squadLineAll => 'All lines';

  @override
  String get squadSortBy => 'Sort';

  @override
  String get squadSortRating => 'Rating';

  @override
  String get squadSortCaps => 'Caps';

  @override
  String get squadSortGoals => 'Goals';

  @override
  String get squadSortAge => 'Age';

  @override
  String get squadSortName => 'Name';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Showing $shown of $total players';
  }

  @override
  String get squadNobodyMatches => 'Nobody in the pool matches those filters.';

  @override
  String get squadStatPool => 'Pool';

  @override
  String get squadStatInSquad => 'Called up';

  @override
  String get squadMostCapped => 'Most capped';

  @override
  String get squadTopScorer => 'Top scorer';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps caps';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals goals';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Caps';

  @override
  String get squadGoalsShort => 'Gls';

  @override
  String pressAskHeavyDefeat2(String opponent) {
    return 'Four goals conceded against $opponent. Where does a night like that leave you?';
  }

  @override
  String pressAskHeavyDefeat3(String opponent) {
    return '$opponent took you apart. Is this squad good enough?';
  }

  @override
  String pressAskElimination2(String opponent) {
    return '$opponent end it. Four years of work, gone in ninety minutes — talk us through it.';
  }

  @override
  String pressAskElimination3(String opponent) {
    return 'Out to $opponent. Was that as far as this team was ever going?';
  }

  @override
  String get pressAskUnderPressure2 =>
      'The results have dried up and your name is in every column. Worried?';

  @override
  String get pressAskUnderPressure3 =>
      'No wins, no goals, no answers. What do you say to the supporters?';

  @override
  String get pressAskPreview2 => 'Everyone wants a prediction. Give us yours.';

  @override
  String get pressAskPreview3 =>
      'Realistically — group stage, quarters, or more than that?';

  @override
  String pressAskOpening2(String opponent) {
    return 'The whole country is watching and $opponent are first up. Your message?';
  }

  @override
  String pressAskOpening3(String opponent) {
    return 'It starts against $opponent. How do you want this side to be remembered?';
  }

  @override
  String get pressAskTriumph2 =>
      'You\'ve won it. Does it feel like the end of something, or the start?';

  @override
  String get pressAskTriumph3 =>
      'Champions at last. Who does this one belong to?';

  @override
  String pressAskBigWin(String opponent) {
    return 'Three clear against $opponent. Is this side finally clicking?';
  }

  @override
  String pressAskBigWin2(String opponent) {
    return 'You took $opponent apart. How good was that?';
  }

  @override
  String pressAskBigWin3(String opponent) {
    return 'A statement result against $opponent. Should the rest of them be worried?';
  }

  @override
  String get pressAskQualified =>
      'You\'re through. What does qualifying mean to this group?';

  @override
  String get pressAskQualified2 =>
      'The place is booked. Job done, or is the job just starting?';

  @override
  String get pressAskQualified3 =>
      'Qualification secured — now what is this squad actually capable of?';

  @override
  String get pressAskMissedOut =>
      'No tournament this time. How did it come to this?';

  @override
  String get pressAskMissedOut3 =>
      'Watching it on television. What do you say to a country that expected better?';

  @override
  String get pressAskMissedOut2 =>
      'The campaign is over and you\'re not in it. Who is accountable?';

  @override
  String get pressAskUnbeaten =>
      'Unbeaten for months now. How long can this go on?';

  @override
  String get pressAskUnbeaten2 =>
      'Nobody has laid a glove on you all season. What\'s behind the run?';

  @override
  String get pressAskUnbeaten3 =>
      'The run keeps going. Is this the best side you\'ve had?';

  @override
  String get pressAskNewJob => 'Day one. What are you promising this country?';

  @override
  String get pressAskNewJob2 => 'New job, new squad. What changes first?';

  @override
  String get pressAskNewJob3 =>
      'You\'ve taken the job. Why this one, and why now?';

  @override
  String get pressAskRankingPeak =>
      'A record world ranking. Does the table flatter this team?';

  @override
  String get pressAskRankingPeak2 =>
      'Never been ranked this high. Is this side genuinely among the best?';

  @override
  String get pressAskRankingPeak3 =>
      'Top of the pile on paper. Does that put a target on your back?';

  @override
  String get pressAnswerBackPlayers2 =>
      'Nobody works harder than this group. I\'ll defend them all day.';

  @override
  String get pressAnswerBackPlayers3 =>
      'You won\'t hear a word against my players from this seat.';

  @override
  String get pressAnswerTakeBlame2 =>
      'Judge me, not them. It\'s my team and my responsibility.';

  @override
  String get pressAnswerTakeBlame3 =>
      'If you want somebody to blame, I\'m sitting right here.';

  @override
  String get pressAnswerDemandMore2 =>
      'Standards slipped. Some of them know exactly what I mean.';

  @override
  String get pressAnswerDemandMore3 =>
      'Effort isn\'t enough at this level. I want more, and I\'ve told them so.';

  @override
  String get pressAnswerRaiseBar2 =>
      'No hiding from it — we expect to lift the trophy.';

  @override
  String get pressAnswerRaiseBar3 =>
      'Second place is not what this country sent us here for.';

  @override
  String get pressAnswerPlayDown2 =>
      'I\'m not going to make headlines for you today.';

  @override
  String get pressAnswerPlayDown3 =>
      'Next game. That\'s all I\'m thinking about.';

  @override
  String get recordsRecordBookSubtitle =>
      'Caps, goals and the team\'s headline records';

  @override
  String get statsLegacy => 'LEGACY';

  @override
  String pressAskHeavyDefeat4(String opponent) {
    return 'That was hard to watch. Did $opponent simply want it more?';
  }

  @override
  String pressAskHeavyDefeat5(String opponent) {
    return 'You were second to everything against $opponent. Fitness or attitude?';
  }

  @override
  String pressAskHeavyDefeat6(String opponent) {
    return '$opponent scored at will. Who is responsible for that defence?';
  }

  @override
  String pressAskHeavyDefeat7(String opponent) {
    return 'A result like that against $opponent follows a manager around. How do you come back from it?';
  }

  @override
  String pressAskHeavyDefeat8(String opponent) {
    return 'You were booed off after $opponent. Do you blame them?';
  }

  @override
  String pressAskElimination4(String opponent) {
    return '$opponent knocked you out. When did you know it had gone?';
  }

  @override
  String pressAskElimination5(String opponent) {
    return 'Another tournament, another early flight home, and $opponent did it. Why?';
  }

  @override
  String pressAskElimination6(String opponent) {
    return 'Out to $opponent. Is this squad short of quality or short of nerve?';
  }

  @override
  String pressAskElimination7(String opponent) {
    return '$opponent are through and you are not. What do you say in that dressing room?';
  }

  @override
  String pressAskElimination8(String opponent) {
    return 'Beaten by $opponent when it mattered. Does that define your time here?';
  }

  @override
  String get pressAskUnderPressure4 =>
      'The bookmakers have you favourite to go. Does that reach you?';

  @override
  String get pressAskUnderPressure5 =>
      'Your predecessor was sacked on a run like this. What makes you different?';

  @override
  String get pressAskUnderPressure6 =>
      'The board have said nothing publicly. Is silence support?';

  @override
  String get pressAskUnderPressure7 =>
      'Every phone-in wants a new manager. Have you lost the country?';

  @override
  String get pressAskUnderPressure8 =>
      'How many more games do you think you have?';

  @override
  String get pressAskPreview4 =>
      'Who is the team to beat, and are you in that conversation?';

  @override
  String get pressAskPreview5 =>
      'Nobody outside this room fancies you. Does that suit you?';

  @override
  String get pressAskPreview6 =>
      'What would make this a successful tournament — honestly?';

  @override
  String get pressAskPreview7 =>
      'Your group looks kind. Is anything less than qualification unacceptable?';

  @override
  String get pressAskPreview8 =>
      'This is the youngest squad you have taken to a finals. Gamble or plan?';

  @override
  String pressAskOpening4(String opponent) {
    return 'First game, $opponent, and everyone is nervous. How do you settle a side?';
  }

  @override
  String pressAskOpening5(String opponent) {
    return 'You have waited two years for this. Does the plan change now $opponent are in front of you?';
  }

  @override
  String pressAskOpening6(String opponent) {
    return '$opponent to open. Win it and the whole tournament looks different — do you tell them that?';
  }

  @override
  String pressAskOpening7(String opponent) {
    return 'The country has stopped for this. Is $opponent a good draw or a bad one?';
  }

  @override
  String pressAskOpening8(String opponent) {
    return 'Opening night against $opponent. What is the one thing you cannot allow?';
  }

  @override
  String get pressAskTriumph4 => 'You have made history. Has it landed yet?';

  @override
  String get pressAskTriumph5 =>
      'The trophy is in the room. Who did you think of first?';

  @override
  String get pressAskTriumph6 =>
      'A generation will remember this side. What should they remember about it?';

  @override
  String get pressAskTriumph7 =>
      'You were written off in this very room. Enjoying the moment?';

  @override
  String get pressAskTriumph8 => 'Is this the peak, or can this team win more?';

  @override
  String pressAskBigWin4(String opponent) {
    return '$opponent had no answer to that. The plan or the players?';
  }

  @override
  String pressAskBigWin5(String opponent) {
    return 'The best performance of your reign — and against $opponent?';
  }

  @override
  String pressAskBigWin6(String opponent) {
    return 'You could have had more against $opponent. Do you ask for ruthlessness or take the win?';
  }

  @override
  String pressAskBigWin7(String opponent) {
    return 'A scoreline like that against $opponent raises expectations. Comfortable with that?';
  }

  @override
  String pressAskBigWin8(String opponent) {
    return '$opponent never laid a glove on you. Is this side finally what you wanted?';
  }

  @override
  String get pressAskQualified4 => 'Job done. Was it ever in doubt?';

  @override
  String get pressAskQualified5 =>
      'You are through. Does the campaign tell you how far you can go?';

  @override
  String get pressAskQualified6 =>
      'A place at the finals — relief or satisfaction?';

  @override
  String get pressAskQualified7 =>
      'You qualified with games to spare. What are the rest of them for?';

  @override
  String get pressAskQualified8 =>
      'Now the hard part. Is this squad ready for a tournament?';

  @override
  String get pressAskMissedOut4 =>
      'No tournament this time. A squad problem or a coaching one?';

  @override
  String get pressAskMissedOut5 =>
      'Two years of work and nothing to show. Do you still believe in this group?';

  @override
  String get pressAskMissedOut6 =>
      'The country will not see its team at a finals. What do you owe them?';

  @override
  String get pressAskMissedOut7 => 'Was there one night that cost you?';

  @override
  String get pressAskMissedOut8 =>
      'Do you expect to still be in this job next season?';

  @override
  String get pressAskUnbeaten4 =>
      'Nobody has beaten you in a year. Are you thinking about records?';

  @override
  String get pressAskUnbeaten5 =>
      'The run is the story now. Is it a burden yet?';

  @override
  String get pressAskUnbeaten6 =>
      'Sides set up not to lose to you. Does that make it harder?';

  @override
  String get pressAskUnbeaten7 =>
      'When it ends — and it will — how do you want it to end?';

  @override
  String get pressAskUnbeaten8 =>
      'Unbeaten, but how many of those were convincing?';

  @override
  String get pressAskNewJob4 =>
      'You inherit a squad in transition. Where do you start?';

  @override
  String get pressAskNewJob5 => 'What does this team look like in two years?';

  @override
  String get pressAskNewJob6 =>
      'You turned down other offers for this one. Why?';

  @override
  String get pressAskNewJob7 =>
      'Some of these players were not picked by you. Does anyone start with a clean slate?';

  @override
  String get pressAskNewJob8 => 'What has this country been getting wrong?';

  @override
  String get pressAskRankingPeak4 =>
      'Top of the pile on paper. Does a ranking mean anything to you?';

  @override
  String get pressAskRankingPeak5 =>
      'The highest this nation has ever been. Whose achievement is that?';

  @override
  String get pressAskRankingPeak6 =>
      'You are ranked above sides with far more history. Fair?';

  @override
  String get pressAskRankingPeak7 =>
      'The numbers say you are among the best. Do the trophies?';

  @override
  String get pressAskRankingPeak8 =>
      'A record ranking and no trophy yet. Does that sit uneasily?';

  @override
  String get pressAnswerBackPlayers4 =>
      'I\'ll take the questions. They\'ll take the credit — that\'s how it works here.';

  @override
  String get pressAnswerBackPlayers5 =>
      'This group has never let me down. Not once.';

  @override
  String get pressAnswerBackPlayers6 =>
      'They\'re hurting more than anyone. I\'m not adding to it.';

  @override
  String get pressAnswerTakeBlame4 =>
      'That\'s on the staff and it\'s on me. Nobody else.';

  @override
  String get pressAnswerTakeBlame5 =>
      'I picked it, I set it up, I got it wrong.';

  @override
  String get pressAnswerTakeBlame6 =>
      'Point it at me. That\'s what I\'m paid for.';

  @override
  String get pressAnswerDemandMore4 =>
      'Some of them are a long way short of what this shirt asks.';

  @override
  String get pressAnswerDemandMore5 =>
      'I\'ve told them privately and I\'ll say it here: it isn\'t good enough.';

  @override
  String get pressAnswerDemandMore6 =>
      'Places are open. Everyone in that dressing room knows it.';

  @override
  String get pressAnswerRaiseBar4 =>
      'We came here to win it. I\'m not going to pretend otherwise.';

  @override
  String get pressAnswerRaiseBar5 =>
      'Anything but the trophy and we\'ll have wasted this.';

  @override
  String get pressAnswerRaiseBar6 =>
      'I\'d rather be judged on winning than praised for trying.';

  @override
  String get pressAnswerPlayDown4 =>
      'I\'ll keep my thoughts in the dressing room.';

  @override
  String get pressAnswerPlayDown5 =>
      'You\'ve seen the game. Your read is as good as mine.';

  @override
  String get pressAnswerPlayDown6 =>
      'Nothing I say tonight changes the result.';
}
