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
  String get teamTalkHeading => 'TEAM TALK';

  @override
  String get teamTalkPrompt => 'Set the tone for the second half.';

  @override
  String get teamTalkCalmLabel => 'Calm heads';

  @override
  String get teamTalkCalmBlurb => 'Steady the side. A small all-round lift.';

  @override
  String get teamTalkEncourageLabel => 'Encourage';

  @override
  String get teamTalkEncourageBlurb => 'Push forward and go for the game.';

  @override
  String get teamTalkDemandMoreLabel => 'Demand more';

  @override
  String get teamTalkDemandMoreBlurb => 'Throw everything at it. Attack hard.';

  @override
  String get teamTalkPraiseLabel => 'Keep it tight';

  @override
  String get teamTalkPraiseBlurb => 'Stay compact and protect what you have.';

  @override
  String get teamTalkBelieveLabel => 'Believe';

  @override
  String get teamTalkBelieveBlurb =>
      'Back yourselves. A lift at both ends of the pitch.';

  @override
  String get teamTalkFocusLabel => 'Stay switched on';

  @override
  String get teamTalkFocusBlurb => 'Total concentration. Lock the game down.';

  @override
  String get teamTalkUrgencyLabel => 'Sense of urgency';

  @override
  String get teamTalkUrgencyBlurb =>
      'Chase it down now. All-out, and it leaves gaps.';

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
  String get navCareers => 'My Career';

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
  String get recordsNoFinalsYet => 'No finals appearance yet';

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
    return '$names sent off. No replacement, so you play a man down.';
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
  String get tacticsSquadLockedBack => 'Back (squad locked)';

  @override
  String get tacticsConfirmSquad => 'Confirm squad';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Squad full (max $max)';
  }

  @override
  String get tacticsSquadLocked => 'SQUAD LOCKED';

  @override
  String get tacticsNominationOpen => 'NOMINATION OPEN. PICK YOUR SQUAD';

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
  String get tacticsChooseShape => 'CHOOSE A SHAPE';

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
  String tacticsAgeOnly(int age) {
    return 'Age $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Age $age';
  }

  @override
  String get tacticsOn => 'ON';

  @override
  String get tacticsSquad => 'SQUAD';

  @override
  String get tacticsTabLineup => 'LINEUP';

  @override
  String get tacticsTabInstructions => 'INSTRUCTIONS';

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
    return '$name: $reason';
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
  String get hubEventWatchWcDraw => 'Watch the World Championship draw';

  @override
  String get hubEventWorldCupHere => 'The World Championship is here';

  @override
  String get hubEventWatchFinalsDraw => 'Watch the finals draw';

  @override
  String get hubEventFinalsHere => 'The finals are here';

  @override
  String get hubEventPlayWcRound => 'Play the next World Championship round';

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
      'Watch the World Championship host selection';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Watch the World Championship qualifying draw';

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
          '$count of your XI are out (suspended or injured). Pick their replacements',
      one: '1 of your XI is out (suspended or injured). Pick their replacement',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your starting XI is short. Fill the open slots',
      one: 'Your starting XI is short. Fill the open slot',
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
  String get hubCallUpWorldCup => 'Name your World Championship squad';

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
      'Groups to be drawn. Watch the draw to reveal them.';

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
    return '$date · Road to the $year World Championship';
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
      'Your career begins in September 2026, on the road to the 2030 World Championship.';

  @override
  String get careerFreeCycleNote =>
      'The first full cycle is free: qualifying, your continental championship and the World Championship. Carrying on afterwards, and extra save slots, unlock once for €12.99.';

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
  String get careerNoSilverware => 'No silverware yet. Go win one.';

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
  String get careerProUpTo5 => 'Pro: up to 10';

  @override
  String get careerThisSave => 'this save';

  @override
  String get careerSlotsFull => 'Slots full';

  @override
  String get careerSlotsFullGoPro => 'Slots full. Go Pro for 10';

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
    return 'Road to the $year World Championship';
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
  String get careerWorldCupLabel => 'World Championship';

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
  String get matchSetupWarnCaptain =>
      'No captain named. Tap to give somebody the armband';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name is injured and cannot lead this one out. Tap to hand the armband on';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name is suspended for this one. Tap to hand the armband on';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name has the armband but is not in your squad. Tap to hand it on';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'No set-piece takers named. Tap to choose who steps up';

  @override
  String get matchSetupWarnBoth =>
      'No captain and no set-piece takers. Tap to set them';

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
  String get captainCurrent => 'Captain. Tap to remove the armband';

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
  String get resultsCategoryWorldCupQualifying =>
      'World Championship Qualifying';

  @override
  String get resultsCategoryFriendlies => 'Friendlies';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Continental Cup';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'World Champ. Q';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Continental Cup Q';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Continental Cup Qualifying';

  @override
  String get resultsCategoryWorldCupFinals => 'World Championship Finals';

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
  String get chWc1Desc => 'Win the World Championship.';

  @override
  String get chYears25 => 'Establishment';

  @override
  String get chYears25Desc => 'Manage for 25 years.';

  @override
  String get chWc3 => 'Serial Winner';

  @override
  String get chWc3Desc => 'Win 3 World Championships.';

  @override
  String get chWc5 => 'Dynasty';

  @override
  String get chWc5Desc => 'Win 5 World Championships.';

  @override
  String get chWc10 => 'Immortal';

  @override
  String get chWc10Desc => 'Win 10 World Championships.';

  @override
  String get chWc2Teams => 'Have Boots, Will Travel';

  @override
  String get chWc2TeamsDesc =>
      'Win the World Championship with 2 different nations.';

  @override
  String get chWc3Teams => 'Globetrotter';

  @override
  String get chWc3TeamsDesc =>
      'Win the World Championship with 3 different nations.';

  @override
  String get chWcStreak3 => 'Three-Peat';

  @override
  String get chWcStreak3Desc => 'Win 3 World Championships in a row.';

  @override
  String get chWcAllconf => 'World Conqueror';

  @override
  String get chWcAllconfDesc =>
      'Win the World Championship with a nation from every confederation (6).';

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
      'Win the World Championship, a continental title and the Nations Cup in one career.';

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
      'Win 3 World Championships AND 5 continental championships.';

  @override
  String get chUndefeated => 'Untouchable';

  @override
  String get chUndefeatedDesc =>
      'Win a World Championship without losing a single match.';

  @override
  String get chPerfectQual => 'Flawless Passage';

  @override
  String get chPerfectQualDesc =>
      'Win every match of a World Championship qualifying campaign.';

  @override
  String get chMinnow => 'Minnow Miracle';

  @override
  String get chMinnowDesc =>
      'Win the World Championship with a nation ranked outside the world top 32.';

  @override
  String get chGrandTour => 'Home & Away';

  @override
  String get chGrandTourDesc =>
      'Win a World Championship as hosts and win one away from home.';

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
    return 'Win $count World Championships this save.';
  }

  @override
  String get chPcMajors => 'Silverware Collector';

  @override
  String chPcMajorsDesc(int count) {
    return 'Win $count major trophies (World Championship, continental or Nations Cup).';
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
  String get paywallBenefitSaveSlots => '10 save slots instead of 3';

  @override
  String get paywallBenefitEndless => 'Unlimited careers, forever';

  @override
  String get paywallUnlocked => 'Premium is unlocked. Enjoy!';

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
  String get federationBudgetLater => 'Decide later';

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
  String federationOverBudget(String amount) {
    return '$amount more than the federation has. Take some back';
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
  String get federationCommittedToStaff => 'Committed to staff';

  @override
  String get federationFreeToSpend => 'Free to spend';

  @override
  String get federationWagesNote =>
      'Wages come off the balance at the end of the cycle, so this much is spoken for.';

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
  String get nationsWorldCup => 'World Championship';

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
      'Not enough history yet. Check back after a cycle or two.';

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
  String get playerClubRole => 'At his club';

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
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

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
  String yWinUpset4(String opponent, String score) {
    return '$score against $opponent. However that happened, it happened.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'On paper this was over before it started. $opponent $score says otherwise.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Beat $opponent $score. Nobody will believe that scoreline in a year.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Enjoy it, then look at the fixture list.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score against $opponent, and we rode our luck for eighty of the ninety.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'One night against $opponent does not undo a year. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Beat $opponent $score and now we will be told we have turned a corner. We have not.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Wonderful. Ask me again when it matters.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Beat $opponent $score. Exactly as it should be, and there is a pleasure in that.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score over $opponent. Ruthless, and ruthless is a compliment.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. No fuss, no scare, no complaints.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'A tidy $score against $opponent. This is what a good side looks like on a quiet day.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score against $opponent. Job done, nothing learned.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Beat $opponent $score. We were supposed to, and we did.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'A professional $score over $opponent. Next.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent dispatched $score. File it and move on.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score against $opponent and we are supposed to applaud. For beating them.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Well done to everyone involved in the $score over $opponent, I suppose.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Beating sides like that is the floor, not the achievement.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'We beat $opponent $score and looked laboured doing it.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score against $opponent and every minute of it earned.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'That took character. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Beat $opponent $score the hard way, which is the way that lasts.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score against $opponent. Sides that win these are the sides still standing in June.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nervy, ugly, and a win. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Beat $opponent $score. Take the three points and never watch it again.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent made us work for every inch of that.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Not pretty. Counts the same.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score against $opponent and we made it ten times harder than it was.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'We should not be hanging on against $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Won it, and learned nothing good about ourselves.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'A $score that flattered us against $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'A point against $opponent, $score. Take it and move on.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score with $opponent. There are worse afternoons than this.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Held $opponent to $score. Not everything has to be a story.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. A point is a point and the table does not ask how.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score with $opponent. Two points dropped or one gained. Pick your mood.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'A draw against $opponent, $score. Nobody is happy, nobody is furious.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. The most forgettable ninety minutes of the year.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Shared the spoils with $opponent, $score. On we go.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score against $opponent. Draws like this are how campaigns quietly die.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Two points thrown away against $opponent. $score. Nothing else to call it.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. We had ninety minutes and no idea what to do with them.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'A $score with $opponent that nobody will remember and everybody will pay for.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Beaten $score by $opponent. It happens.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Nothing to hang anybody for. On to the next.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Lost $score to $opponent and gave everything. Some days that is not enough.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score to $opponent. Heads up. This side has plenty left.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. We were second best and there is no argument.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Lost $score to $opponent. Regroup.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score to $opponent. Not a disgrace, not good enough.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Beaten $score by $opponent. Learn something from it or it was wasted.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score to $opponent and we did not lay a glove on them.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Lost to $opponent, $score. Same problems, same month, same excuses coming.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. At what point does this stop being bad luck?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Beaten $score by $opponent. That is a result that should cost somebody something.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score to $opponent. One bad night. Judge the side on the campaign, not this.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Nobody wanted that $score against $opponent less than the players did.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Ugly, and not who this team is.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'A $score to forget against $opponent. They will front up next time.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. To $opponent. I have no words and I am paid to have words.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Somebody has to answer for that.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'I want the $score against $opponent struck from the record and from memory.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Beaten $score by $opponent. There is no spinning a scoreline like that.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'That was not a defeat to $opponent, it was a surrender. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Against $opponent. People paid money to watch that.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. If that does not change something, nothing will.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'I have seen this side humiliated before, but $score by $opponent is a new floor.';
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
    return '$opponent, and the trophy is coming home.';
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
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skill points to spend',
      one: '1 skill point to spend',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'What you are good at makes your side better';

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
  String yScorerStar4(String name, String goals) {
    return '$goals for $name, and the rest of them were passengers.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '$name again. $goals. Imagine this side without him.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals from $name. One man should not have to do this much.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Take $name out of that and it is $goals fewer and a very different afternoon.';
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
    return 'No defeats in $count. Ask anyone who has managed: that is the hard part.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count in a row. Enjoy it while the fixtures are kind.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count straight, and we have beaten nobody of consequence.';
  }

  @override
  String yWinStreak6(String count) {
    return 'A run of $count. Ask me again when it is tested.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count on the trot. Every side has one of these in them once.';
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
  String yLossStreak4(String count) {
    return '$count without a win and the same mistakes every week.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count in a row. Whatever is being tried, it is not working.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count straight. This is a direction, not a dip.';
  }

  @override
  String yLossStreak7(String count) {
    return 'No wins in $count, and nobody upstairs has said a word.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Say what you like about the football. This one counts double.';
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
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Whatever else happens this year, there is that.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score against $opponent. Some of us needed that more than the table did.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. And they will have it back next time, they always do.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Against $opponent, $score. A whole year of being reminded about this one.';
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
  String yInjuryBlow4(String name) {
    return '$name out. Of course it is $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Without $name this becomes a very ordinary team.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name injured again. Somebody should be asking why.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Lost $name, and there is nobody behind him. That is the real problem.';
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
  String get yBoardPressure4 =>
      'Nobody upstairs has backed him in public for weeks now.';

  @override
  String get yBoardPressure5 =>
      'The federation is briefing against its own manager. Same as always.';

  @override
  String get yBoardPressure6 =>
      'When a board goes silent, they have already decided.';

  @override
  String get yBoardPressure7 =>
      'They will let this drift until it is somebody else’s decision to make.';

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
  String get tourHolders => 'HOLDERS';

  @override
  String tourHoldersSince(int year) {
    return 'won in $year';
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
      'The knockout rounds are played out before the World Championship.';

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
      'Two World Championship places decided across a knockout of the best qualifying also-rans.';

  @override
  String get tourContPlayoffThrough =>
      'You came through the play-off. You\'re at the World Championship!';

  @override
  String get tourContPlayoffOut =>
      'You fell short in the play-off. No World Championship this time.';

  @override
  String get tourContContinue => 'Continue';

  @override
  String get tourContPlayoffFinals => 'PLAY-OFF FINALS';

  @override
  String get tourContPlayoffSeeded => 'Seeded (bye)';

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
  String get tourCupStillActive => 'Still active';

  @override
  String get tourCupAllTimeScorers => 'ALL-TIME SCORERS';

  @override
  String get tourCupAllConfederations => 'All confederations';

  @override
  String get tourCupBestRunnersUp => 'Best runners-up';

  @override
  String get tourCupCompWorld => 'World Championship';

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
      'Groups to be drawn. Watch the World Championship draw from the hub to reveal them.';

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
  String tourCupHostLabelMulti(String hosts) {
    return 'Hosted by $hosts';
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
    return '$nation: $titles titles from $editions editions';
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
      'Two World Championship places decided across a knockout of the best qualifying also-rans.';

  @override
  String get tourCupQualDrawSoon =>
      'Groups to be drawn. Watch the qualifying draw from the hub to reveal them.';

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
      'Better delivery, and more goals from dead balls.';

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
  String get traitPaceyBlurb => 'Blistering pace, a threat in behind.';

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
  String get objectiveWorldCup => 'World Championship';

  @override
  String get objectiveWinTournament => 'Win it';

  @override
  String get objectiveQualifyGeneric => 'Qualify';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Win the World Championship';

  @override
  String get objectiveReachFinal => 'Reach the final';

  @override
  String get objectiveReachSemis => 'Reach the semi-finals';

  @override
  String get objectiveReachQuarters => 'Reach the quarter-finals';

  @override
  String get objectiveReachKnockouts => 'Reach the knockout rounds';

  @override
  String get objectiveQualify => 'Qualify for the World Championship';

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
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rounds better than asked',
      one: 'a round better than asked',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rounds short',
      one: 'a round short',
    );
    return '$result: $_temp0';
  }

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
      'The next generation, best prospect first. Hollow stars are a scout\'s estimate. Cap a player to find out what he really has.';

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
      'Your own settings. No named style matches these dials.';

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
      'You have no job and no reputation. These are the only sides willing to take a chance on you. Take one and build something from nothing.';

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
      'Where the squad lives for the whole tournament. It cannot be changed once play starts, and it works on three things every match: how fresh they arrive, how fast a knock heals, and how sharp they are.';

  @override
  String get campEffectTravel => 'Arrive fresh';

  @override
  String get campEffectRecovery => 'Injuries heal';

  @override
  String get campEffectSharpness => 'Match sharpness';

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
      'Everything on the doorstep and nothing to travel to, but no peace and no escape from the noise.';

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
    return '$opponent end it. Four years of work, gone in ninety minutes. Talk us through it.';
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
      'Realistically: group stage, quarters, or more than that?';

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
      'Qualification secured. Now what is this squad actually capable of?';

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
      'No hiding from it. We expect to lift the trophy.';

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
      'What would make this a successful tournament, honestly?';

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
    return '$opponent to open. Win it and the whole tournament looks different. Do you tell them that?';
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
    return 'The best performance of your reign, and against $opponent?';
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
      'A place at the finals: relief or satisfaction?';

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
      'When it ends, and it will, how do you want it to end?';

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
      'I\'ll take the questions. They\'ll take the credit. That\'s how it works here.';

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

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name has already been taken off and cannot come back on.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name has been sent off and takes no further part.';
  }

  @override
  String get tacticsInjuredShort => 'INJURED';

  @override
  String get tacticsSuspendedShort => 'SUSPENDED';

  @override
  String get confEurope => 'Europe';

  @override
  String get confSouthAmerica => 'South America';

  @override
  String get confNorthAmerica => 'North America';

  @override
  String get confAfrica => 'Africa';

  @override
  String get confAsia => 'Asia';

  @override
  String get confOceania => 'Oceania';

  @override
  String get compWorldCup => 'World Championship';

  @override
  String get compWorldCupFinals => 'World Championship Finals';

  @override
  String get compWorldCupQualifying => 'World Championship Qualifying';

  @override
  String compQualifiers(String region) {
    return '$region Qualifiers';
  }

  @override
  String get compFriendlies => 'Friendlies';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Intercontinental Play-off';

  @override
  String get compContinentalChampionship => 'Continental Championship';

  @override
  String get compEuropeanChampionship => 'European Championship';

  @override
  String get compSouthAmericaCup => 'South America Cup';

  @override
  String get compAfricanChampionship => 'African Championship';

  @override
  String get compAsianChampionship => 'Asian Championship';

  @override
  String get compNorthAmericaCup => 'North America Cup';

  @override
  String get compOceaniaCup => 'Oceania Cup';

  @override
  String get msgANation => 'A nation';

  @override
  String get msgAPlayer => 'A player';

  @override
  String get msgAHostNation => 'a host nation';

  @override
  String get msgCycleTitle1 => 'A new cycle begins';

  @override
  String msgCycleTitle2(int year) {
    return 'The road to $year opens';
  }

  @override
  String get msgCycleTitle3 => 'A fresh campaign dawns';

  @override
  String get msgCycleTitle4 => 'Back to work';

  @override
  String msgCycleBody1(int year) {
    return 'The road to the $year World Championship starts here.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'A new cycle. The $year World Championship is the target.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Four years to the $year World Championship. Work starts now.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'The $year campaign begins today.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup host: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host will host the next $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup qualifying draw';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'The $cup qualifying groups have been drawn.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return '$year World Championship host: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host will host the $year World Championship.';
  }

  @override
  String get msgWcQualDrawTitle => 'World Championship qualifying draw';

  @override
  String get msgWcQualDrawBody =>
      'The World Championship qualifying groups have been drawn.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup finals draw';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'The $cup finals groups have been drawn.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'World Championship finals draw';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'The $year World Championship finals draw has been made.';
  }

  @override
  String get msgQualWcTitle1 => 'Through to the World Championship';

  @override
  String get msgQualWcTitle2 => 'World Championship booked';

  @override
  String get msgQualWcTitle3 => 'We\'re going to the World Championship';

  @override
  String get msgQualWcTitle4 => 'Ticket punched';

  @override
  String msgQualWcBody1(int year) {
    return 'You have qualified for the $year World Championship finals.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'It\'s official: your nation is at the $year World Championship.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'A place at the $year World Championship is secured.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'You\'re through to the $year World Championship finals.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Through to $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup booked';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Qualified for $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'You have qualified for the $cup finals.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Your nation has sealed its place at $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'You\'re through to $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp CHAMPIONS!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Champions of the $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'You\'ve won the $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp decided';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp champions crowned';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return 'The $comp is won';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Your nation are the $year $comp champions, beating $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'You\'ve won the $year $comp, seeing off $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return 'The $year $comp is yours. $loser beaten$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner won the $year $comp, beating $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner are the $year $comp champions, defeating $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away in the final';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' on penalties, after a $home–$away final';
  }

  @override
  String get msgWpotyTitle => 'World Player of the Year';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) is named $year World Player of the Year, one of yours.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) is named $year World Player of the Year.';
  }

  @override
  String get msgYpotTitle => 'Young Player of the Tournament';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), aged $age, is named $year Young Player of the Tournament, one of yours.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), aged $age, is named $year Young Player of the Tournament.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'You hold at #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'No change, still #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Steady at #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places',
      one: '1 place',
    );
    return 'Up $_temp0 this cycle, to #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places',
      one: '1 place',
    );
    return 'A climb of $_temp0 lifts you to #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places',
      one: '1 place',
    );
    return 'Up $_temp0, now #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places',
      one: '1 place',
    );
    return 'Down $_temp0 this cycle, to #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places',
      one: '1 place',
    );
    return 'A slide of $_temp0 drops you to #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places',
      one: '1 place',
    );
    return 'Down $_temp0, now #$rank.';
  }

  @override
  String get msgRankLeadYou => 'You top the world.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation top the world.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'World ranking · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'The world ranking has been updated. $lead $movement';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name reaches $count caps';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name has now made $count appearances for your nation.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name reaches $count goals';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name has scored $count international goals for your nation.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Squad development · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Through from the academy · $year';
  }

  @override
  String get msgThroughNote =>
      'These are not a new intake. They are the boys who came in at eleven and have now grown into the senior pool.';

  @override
  String msgNewFacesTitle(int year) {
    return 'New faces · $year';
  }

  @override
  String msgIntakeTitle(int year) {
    return 'Academy intake · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Your captain $name retires';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name retires from internationals';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name has retired from international football at $age.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name has retired from international football at $age, bowing out with $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caps',
      one: '1 cap',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goals',
      one: '1 goal',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' The armband is vacant. Name a new captain from the call-up screen.';

  @override
  String msgHofTitle(String name) {
    return '$name inducted into the Hall of Fame';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name joins your nation’s Hall of Fame ($caps caps, $goals goals). See them in Legends.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name suspended';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'the next $matches matches',
      one: 'your next match',
    );
    return '$name $how and is banned for $_temp0. They will be unavailable for selection.';
  }

  @override
  String get hubBanHowSecondYellow => 'was sent off for a second booking';

  @override
  String get hubBanHowViolent => 'was shown a straight red for violent conduct';

  @override
  String get hubBanHowRed => 'was sent off';

  @override
  String hubInjuryTitle(String name) {
    return '$name injured';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches matches',
      one: '1 match',
    );
    return '$name picked up a knock and is out for $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Runners-up';

  @override
  String get hubRunnerUpTitle2 => 'So near, yet so far';

  @override
  String get hubRunnerUpTitle3 => 'Silver medals';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'You reached the $cup final but lost to $opponent. So close. Silver this time.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Beaten by $opponent in the $cup final. Runners-up, agonisingly close.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'The $cup final slipped away against $opponent. So much to be proud of, but not the trophy.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Knocked out';

  @override
  String get hubKnockedOutTitle2 => 'The end of the road';

  @override
  String get hubKnockedOutTitle3 => 'Journey over';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'You\'re out of the $cup, beaten by $opponent in the $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent end your $cup in the $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Your $cup ends in the $stage, beaten by $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Group stage exit';

  @override
  String get hubGroupExitTitle2 => 'Out at the group stage';

  @override
  String get hubGroupExitTitle3 => 'Early bath';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Your $cup is over at the group stage. Not enough to reach the knockouts.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'You failed to get out of the group. Your $cup ends here.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'No knockout place this time. Your $cup is done at the group stage.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Objective met: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Objective missed: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'The board\'s target at the $comp: $demand. You finished: $finish. They have what they asked for.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'The board\'s target at the $comp: $demand. You finished: $finish. That is short of what was expected.';
  }

  @override
  String get newsWcMissTitle => 'World Championship dream over';

  @override
  String newsWcMissBody(int year) {
    return 'You didn\'t make the $year World Championship. The qualifying campaign fell short. Four more years.';
  }

  @override
  String get newsRecordScorerTitle => 'All-time top scorer';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name is now the game\'s all-time leading goalscorer with $goals goals.';
  }

  @override
  String get newsRecordCapsTitle => 'Most-capped player';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name is now the game\'s most-capped player with $caps appearances.';
  }

  @override
  String get newsARecordBreaker => 'A new record-breaker';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name joins $club';
  }

  @override
  String newsTransferBody(
    String name,
    String position,
    String fromClub,
    String destination,
    String fee,
    int rating,
  ) {
    return '$name ($position, $rating) has left $fromClub to sign for $destination for $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club in $country';
  }

  @override
  String get newsTransferFree => 'a free transfer';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ $name would switch to $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name wants to play for $nation';
  }

  @override
  String newsNatzBody(
    String name,
    String position,
    String fromNation,
    String nation,
    int age,
    int rating,
  ) {
    return '$name, a $age-year-old $position rated $rating currently with $fromNation, has family ties to $nation and is open to switching. Open the Naturalisation offer to accept or decline.';
  }

  @override
  String newsNatzBodyStar(
    String name,
    String position,
    String fromNation,
    String nation,
    int age,
    int rating,
  ) {
    return '$name, a $age-year-old $position rated $rating currently with $fromNation, is a star name who has family ties to $nation and is open to switching. Open the Naturalisation offer to accept or decline.';
  }

  @override
  String get newsTheirNation => 'their nation';

  @override
  String get newsYourNation => 'your nation';

  @override
  String get tourStatusChampions => 'CHAMPIONS';

  @override
  String get tourStatusFinals => 'FINALS';

  @override
  String get tourStatusQualifying => 'QUALIFYING';

  @override
  String get tourStatusUpcoming => 'UPCOMING';

  @override
  String get tourStatusInProgress => 'IN PROGRESS';

  @override
  String get tourStatusComingSoon => 'COMING SOON';

  @override
  String get tourStatusDecided => 'DECIDED';

  @override
  String tourStatusLeague(String letter) {
    return 'LEAGUE $letter';
  }

  @override
  String get tourDrawWcQualifying => 'WORLD CUP QUALIFYING DRAW';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup QUALIFYING DRAW';
  }

  @override
  String get tourDrawWcHost => 'WORLD CUP HOST';

  @override
  String tourDrawContHost(String cup) {
    return '$cup HOST';
  }

  @override
  String get tourKickoffContinentalCup => 'CONTINENTAL CUP';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup missed';
  }

  @override
  String newsContMissBody(String cup) {
    return 'You didn\'t qualify for $cup. The campaign came up short this time.';
  }

  @override
  String newsPotyTitle(int year) {
    return 'World Player of the Year $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name is the best player in the world this year.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name takes the young player\'s award.';
  }

  @override
  String get matchTopBarTitle => 'MATCH';

  @override
  String get matchStatsAtFullTime => 'Stats available at full time.';

  @override
  String get matchPlayerRatings => 'PLAYER RATINGS';

  @override
  String get matchSubstitutions => 'SUBSTITUTIONS';

  @override
  String get matchSubstitutes => 'SUBSTITUTES';

  @override
  String get matchPlayerOfTheMatch => 'PLAYER OF THE MATCH';

  @override
  String get matchGoalShout => 'GOAL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'SHOOTOUT $home–$away';
  }

  @override
  String get tourVenues => 'VENUES';

  @override
  String tourPot(int number) {
    return 'POT $number';
  }

  @override
  String get tourHostSelection => 'HOST SELECTION';

  @override
  String get tourCandidates => 'CANDIDATES';

  @override
  String get tourJointBid => 'JOINT BID';

  @override
  String get tourGoldenGlove => 'GOLDEN GLOVE';

  @override
  String get tourTeamOfTournament => 'TEAM OF THE TOURNAMENT';

  @override
  String get tourYourRun => 'YOUR RUN';

  @override
  String get tourMedalTable => 'MEDAL TABLE';

  @override
  String tourHostLine(String nation) {
    return 'Host: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Hosts: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Group $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Seeded by world ranking. Spot your nation before the draw.';

  @override
  String get tourWorldRanking => 'World Ranking';

  @override
  String get tourYourCompetitions => 'YOUR COMPETITIONS';

  @override
  String get tourOtherContinents => 'OTHER CONTINENTS';

  @override
  String tourHostedBy(String hosts) {
    return 'HOSTED BY  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Top $count advance to $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name walks away';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name has retired from international football at $age, with $caps caps. He asked to be told where he stood and was not, and he is not waiting any longer.';
  }

  @override
  String get pressProbeAccountability1 =>
      'You\'ve backed them again. Is nobody in that dressing room accountable?';

  @override
  String get pressProbeAccountability2 =>
      'That\'s the players defended. Who actually answers for a night like that?';

  @override
  String get pressProbeAccountability3 =>
      'Loyalty is easy from up there. Does anyone pay a price?';

  @override
  String get pressProbeAccountability4 =>
      'If it\'s never the players, we\'re left with one name. Yours.';

  @override
  String get pressProbeYourFuture1 =>
      'You\'ve taken it on yourself. Should we be asking about your future?';

  @override
  String get pressProbeYourFuture2 =>
      'Falling on your sword is noble. Is the job still yours?';

  @override
  String get pressProbeYourFuture3 =>
      'You keep saying it\'s you. At what point is that a resignation?';

  @override
  String get pressProbeYourFuture4 =>
      'The board are listening too. Are you sure you want that on record?';

  @override
  String get pressProbeDressingRoom1 =>
      'Strong words in public. Have you lost that dressing room?';

  @override
  String get pressProbeDressingRoom2 =>
      'You\'ve just told the country they\'re not good enough. How does that help?';

  @override
  String get pressProbeDressingRoom3 =>
      'Demanding it here rather than in there. Is that leadership?';

  @override
  String get pressProbeDressingRoom4 =>
      'Players read this too. What do they hear tomorrow morning?';

  @override
  String get pressProbeExpectation1 =>
      'You\'ve raised the bar in public. Is that not a hostage to fortune?';

  @override
  String get pressProbeExpectation2 =>
      'Big promise. What happens the day you don\'t deliver it?';

  @override
  String get pressProbeExpectation3 =>
      'Every manager before you said the same and packed a bag. Why are you different?';

  @override
  String get pressProbeExpectation4 =>
      'You\'ve set the target. Will you resign if you miss it?';

  @override
  String get pressProbeSubstance1 =>
      'With respect, that\'s not an answer. Give us something.';

  @override
  String get pressProbeSubstance2 =>
      'The country wants to hear from you. Anything at all?';

  @override
  String get pressProbeSubstance3 =>
      'You can keep saying nothing. We\'ll keep printing it.';

  @override
  String get pressProbeSubstance4 =>
      'One straight sentence. What do you actually think?';

  @override
  String get pressProbeSelection1 =>
      'Same names, same shape, same result. Why does that team keep getting picked?';

  @override
  String get pressProbeSelection2 =>
      'There are players in form watching this on television. Explain the selection.';

  @override
  String get pressProbeSelection3 =>
      'Is the XI picked on merit, or on reputation?';

  @override
  String get pressProbeSelection4 =>
      'Tactically, we all saw the problem. Did you?';

  @override
  String get pressProbeTheFans1 =>
      'Thousands travelled for that. What do you say to them tonight?';

  @override
  String get pressProbeTheFans2 =>
      'The supporters have stuck with this team for years. What are you giving them?';

  @override
  String get pressProbeTheFans3 =>
      'They sing your name or they don\'t. Which is it going to be?';

  @override
  String get pressProbeTheFans4 => 'Message to the people back home. Go on.';

  @override
  String get pressProbeBigPicture1 =>
      'Step back for me. Where is this nation actually going?';

  @override
  String get pressProbeBigPicture2 =>
      'From the outside, nothing has changed here in years. Has it?';

  @override
  String get pressProbeBigPicture3 =>
      'In four years\' time, what does this side look like?';

  @override
  String get pressProbeBigPicture4 =>
      'Is this a project, or is it just the next match?';

  @override
  String get pressNeedleBackPlayers => 'You always back them. We\'ve heard it.';

  @override
  String get pressNeedleTakeBlame => 'It\'s always your fault, apparently.';

  @override
  String get pressNeedleDemandMore => 'More demands. Again.';

  @override
  String get pressNeedleRaiseBar => 'Another promise for the file.';

  @override
  String get pressNeedlePlayDown => 'You never give us anything.';

  @override
  String get pressHeadlineWent1 => 'A manager in charge of the room';

  @override
  String get pressHeadlineWent2 => 'They came for a row and got a leader';

  @override
  String get pressHeadlineWent3 => 'Straight answers, and they landed';

  @override
  String get pressHeadlineMixed1 => 'Plenty said, little settled';

  @override
  String get pressHeadlineMixed2 =>
      'Something for everyone, and nothing for anyone';

  @override
  String get pressHeadlineMixed3 => 'A conference that left the questions open';

  @override
  String get pressHeadlineBadly1 =>
      'A bruising afternoon in front of the cameras';

  @override
  String get pressHeadlineBadly2 => 'The room turned, and it showed';

  @override
  String get pressHeadlineBadly3 =>
      'Answers that will read worse in the morning';

  @override
  String get pressHeadlineFlat1 => 'Nothing said, nothing gained';

  @override
  String get pressHeadlineFlat2 => 'Ten minutes, no news';

  @override
  String get pressHeadlineFlat3 => 'A blank page for the back page';

  @override
  String get pressConferenceTitle => 'PRESS CONFERENCE';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Question $index of $total';
  }

  @override
  String get pressTomorrowsHeadline => 'TOMORROW\'S BACK PAGE';

  @override
  String get pressLeaveRoom => 'LEAVE THE ROOM';

  @override
  String get pressRoomVerdictSquad => 'Dressing room';

  @override
  String get pressRoomVerdictBoard => 'Board';

  @override
  String get yReactionElation0 => 'no notes. none. perfect.';

  @override
  String get yReactionElation1 => 'I am unwell (good).';

  @override
  String get yReactionElation2 =>
      'framing this. putting it above the fireplace.';

  @override
  String get yReactionElation3 => 'we are so back';

  @override
  String get yReactionElation4 =>
      'Screenshotting this for the doubters. All of them.';

  @override
  String get yReactionElation5 =>
      'I\'m going to be insufferable about this for a decade.';

  @override
  String get yReactionElation6 => 'Right. That is why we watch.';

  @override
  String get yReactionElation7 => 'Days like this pay for the other ones.';

  @override
  String get yReactionElation8 => 'About time. Genuinely, about time.';

  @override
  String get yReactionElation9 =>
      'Great. Now do it again next week and I will believe it.';

  @override
  String get yReactionElation10 =>
      'Enjoy tonight, because this lot will find a way to ruin it.';

  @override
  String get yReactionElation11 =>
      'One good night does not make anybody a great side.';

  @override
  String get yReactionRelief0 =>
      'Not pretty, but I\'ll take it every single time.';

  @override
  String get yReactionRelief1 => 'Somehow. Somehow!';

  @override
  String get yReactionRelief2 => 'Ugly. Three points. Moving on.';

  @override
  String get yReactionRelief3 =>
      'I will take ugly all day if it comes with points.';

  @override
  String get yReactionRelief4 => 'that took ten years off me';

  @override
  String get yReactionRelief5 => 'Nobody speak. Nobody jinx it.';

  @override
  String get yReactionRelief6 => 'Heart rate: unacceptable.';

  @override
  String get yReactionRelief7 => 'Survived. That is the word. Survived.';

  @override
  String get yReactionRelief8 =>
      'We should not need relief from games like that.';

  @override
  String get yReactionRelief9 =>
      'Relieved, and a bit embarrassed about being relieved.';

  @override
  String get yReactionRelief10 =>
      'If that is the standard we are cheering, we are in trouble.';

  @override
  String get yReactionRelief11 =>
      'Scraping through is a habit, and it is not a good one.';

  @override
  String get yReactionFury0 => 'Not good enough. Not remotely.';

  @override
  String get yReactionFury1 => 'Somebody explain that to me slowly.';

  @override
  String get yReactionFury2 => 'That is a hard watch and I am being polite.';

  @override
  String get yReactionFury3 => 'Disappointed. Genuinely disappointed.';

  @override
  String get yReactionFury4 => 'Absolute state of this.';

  @override
  String get yReactionFury5 => 'I want names.';

  @override
  String get yReactionFury6 => 'Deleting the app. Reinstalling Thursday.';

  @override
  String get yReactionFury7 => 'Nobody out there looked like they wanted it.';

  @override
  String get yReactionFury8 => 'Every four years, the same. EVERY four years.';

  @override
  String get yReactionFury9 => 'That is not a performance, it is an insult.';

  @override
  String get yReactionFury10 =>
      'People give up weekends and money for that. Think about it.';

  @override
  String get yReactionFury11 =>
      'I have defended this side for years. Not tonight. Not after that.';

  @override
  String get yReactionDespair0 => 'well.';

  @override
  String get yReactionDespair1 => 'No jokes today. Nothing.';

  @override
  String get yReactionDespair2 => 'Going for a walk. A long one.';

  @override
  String get yReactionDespair3 => 'I have run out of ways to say this.';

  @override
  String get yReactionDespair4 => 'Wake me in four years.';

  @override
  String get yReactionDespair5 => 'this is the darkest timeline';

  @override
  String get yReactionDespair6 =>
      'Not even angry any more. That is the worrying part.';

  @override
  String get yReactionDespair7 => 'Same feeling, different year.';

  @override
  String get yReactionDespair8 =>
      'I do not know what this is any more, but it is not a football team.';

  @override
  String get yReactionDespair9 =>
      'We are further away than we were, and nobody will say it.';

  @override
  String get yReactionDespair10 =>
      'A whole generation wasted and the same people decide what happens next.';

  @override
  String get yReactionDespair11 =>
      'Stop telling me it is a process. It is not going anywhere.';

  @override
  String get yReactionSmugness0 => 'Quietly, but: told you.';

  @override
  String get yReactionSmugness1 => 'bookmark this one';

  @override
  String get yReactionSmugness2 => 'The doubters have gone very quiet.';

  @override
  String get yReactionSmugness3 =>
      'Not that anybody\'s counting. I\'m counting.';

  @override
  String get yReactionSmugness4 => 'Said it in January. Check the timeline.';

  @override
  String get yReactionSmugness5 => 'Some of you owe some of us an apology.';

  @override
  String get yReactionSmugness6 =>
      'Filing this under things I mentioned first.';

  @override
  String get yReactionSmugness7 => 'No gloating. A little gloating.';

  @override
  String get yReactionSmugness8 =>
      'Where are all the experts now? Genuine question.';

  @override
  String get yReactionSmugness9 =>
      'I would like every single one of you to say it back to me.';

  @override
  String get yReactionSmugness10 =>
      'Screenshot, printed, framed, sent to the people who laughed.';

  @override
  String get yReactionSmugness11 =>
      'I will be bringing this up for the rest of my life and you have earned it.';

  @override
  String get yReactionShrug0 => 'it happened. next.';

  @override
  String get yReactionShrug1 => 'Fine. Whatever. Onwards.';

  @override
  String get yReactionShrug2 => 'Filing this one under \'football\'.';

  @override
  String get yReactionShrug3 => 'Genuinely nothing to add.';

  @override
  String get yReactionShrug4 => 'no thoughts, head empty';

  @override
  String get yReactionShrug5 => 'Wake me for the next one.';

  @override
  String get yReactionShrug6 => 'That is ninety minutes I am not getting back.';

  @override
  String get yReactionShrug7 => 'Neither here nor there, really.';

  @override
  String get yReactionShrug8 =>
      'Could not tell you a single thing that happened.';

  @override
  String get yReactionShrug9 =>
      'Another one of those. There are a lot of those.';

  @override
  String get yReactionShrug10 => 'I watched all of it and felt nothing at all.';

  @override
  String get yReactionShrug11 =>
      'If nobody mentions this again, that is fine by me.';

  @override
  String get tourThirdsUneven =>
      'Groups are uneven, so results against each big group\'s bottom side are dropped and every team is judged over the same games.';

  @override
  String get gateTitle => 'YOUR FIRST CYCLE IS OVER';

  @override
  String get gateLead =>
      'Four years, and nothing was held back. Carry this save on for one payment.';

  @override
  String get gateBenefitEndless => 'Every cycle from here on';

  @override
  String get gateBenefitNations => 'Every nation in the world';

  @override
  String get gateBenefitOffline => 'No subscription, no ads, no account';

  @override
  String get gatePriceLead => 'One payment, forever';

  @override
  String get gatePrice => '€12.99';

  @override
  String get gateBuy => 'BUY AND CONTINUE';

  @override
  String get gateExit => 'EXIT';

  @override
  String get gateNotChargedYet =>
      'Not connected to payment yet. This button just continues.';

  @override
  String get backupTitle => 'SAVES';

  @override
  String get backupBlurb =>
      'Every save lives in one file on this phone. Export a copy so a lost or reinstalled phone does not cost you a career.';

  @override
  String get backupExport => 'EXPORT A BACKUP';

  @override
  String get backupExportSubject => 'FNM saves';

  @override
  String get backupRestore => 'RESTORE FROM A FILE';

  @override
  String get backupRestoreWarnTitle => 'Replace every save?';

  @override
  String get backupRestoreWarnBody =>
      'Restoring replaces every save on this phone with the ones in the file. The app will restart.';

  @override
  String get backupRestoreConfirm => 'REPLACE';

  @override
  String get backupCancel => 'CANCEL';

  @override
  String get backupExported => 'Backup ready. Choose where to keep it.';

  @override
  String get backupFailed => 'Could not write the backup.';

  @override
  String get backupRejectedUnreadable => 'That file could not be opened.';

  @override
  String get backupRejectedNotFnm => 'That is not an FNM save.';

  @override
  String get backupRejectedNewer =>
      'That save was made by a newer version of the app. Update first.';

  @override
  String get backupRejectedTooOld =>
      'That save is too old to be restored by this version.';

  @override
  String get careerShare => 'Share this career';

  @override
  String get careerImport => 'IMPORT A CAREER';

  @override
  String get careerShareSubject => 'An FNM career';

  @override
  String get careerImported => 'Career imported.';

  @override
  String get careerImportFailedUnreadable => 'That file is not an FNM career.';

  @override
  String get careerImportFailedNewer =>
      'That career was exported by a newer version of the app. Update first.';

  @override
  String get careerShareFailed => 'Could not export that career.';

  @override
  String get managerTitle => 'MANAGER';

  @override
  String get managerSkills => 'YOUR SKILLS';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points to spend',
      one: '1 point to spend',
      zero: 'No points to spend',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Two points for every cycle you complete, one for every trophy you win.';

  @override
  String get managerSkillsScale =>
      'Every skill starts at 5 and stops at 20. A point spent is permanent.';

  @override
  String get managerSkillManManagement => 'Man Management';

  @override
  String get managerSkillManManagementBlurb =>
      'Each point makes what you say to the press and to your players land 3% harder in the dressing room.';

  @override
  String get managerSkillTactical => 'Tactical';

  @override
  String get managerSkillTacticalBlurb =>
      'Each point beds a new formation in 3% faster, so changing shape costs you fewer matches.';

  @override
  String get managerSkillYouth => 'Youth Development';

  @override
  String get managerSkillYouthBlurb =>
      'Each point adds 1% to the talent coming out of your academy, on top of what you fund it with.';

  @override
  String get managerSkillNegotiation => 'Negotiation';

  @override
  String get managerSkillNegotiationBlurb =>
      'Each point is 2% more money out of the federation, every cycle.';

  @override
  String get managerStaff => 'YOUR STAFF';

  @override
  String managerStaffWages(String amount) {
    return 'Wages: $amount per cycle';
  }

  @override
  String get managerRoleAssistant => 'Assistant Manager';

  @override
  String get managerRoleAssistantBlurb =>
      'Runs the training. Everything you focus on, he does more of.';

  @override
  String get managerRoleScout => 'Chief Scout';

  @override
  String get managerRoleScoutBlurb =>
      'Tells you what a young player will become, sooner.';

  @override
  String get managerRoleFitness => 'Fitness Coach';

  @override
  String get managerRoleFitnessBlurb => 'Keeps them on the pitch.';

  @override
  String get staffVacant => 'Nobody in the job';

  @override
  String get staffLeaveVacant => 'Leave the job empty';

  @override
  String get managerTierNone => 'None';

  @override
  String get managerTierBasic => 'Basic';

  @override
  String get managerTierGood => 'Good';

  @override
  String get managerTierElite => 'Elite';

  @override
  String get managerFree => 'free';

  @override
  String get managerTraining => 'BETWEEN WINDOWS';

  @override
  String get managerTrainingBlurb =>
      'What the squad works on when there is no match to play.';

  @override
  String get managerFocusBalanced => 'Balanced';

  @override
  String get managerFocusBalancedBlurb => 'A bit of everything.';

  @override
  String get managerFocusFitness => 'Fitness';

  @override
  String get managerFocusFitnessBlurb => 'Fewer knocks.';

  @override
  String get managerFocusCohesion => 'Cohesion';

  @override
  String get managerFocusCohesionBlurb => 'The shape beds in faster.';

  @override
  String get managerFocusYouth => 'Youth';

  @override
  String get managerFocusYouthBlurb => 'Hours with the youngest in the pool.';

  @override
  String get tourOfferTitle => 'First time here?';

  @override
  String get tourOfferBody =>
      'This is a big game. Want a quick walk through the screens that matter? It takes a minute, and you can start it again any time from Settings.';

  @override
  String get tourOfferYes => 'Show me around';

  @override
  String get tourOfferNo => 'No thanks';

  @override
  String get tourBack => 'Back';

  @override
  String get tourNext => 'Next';

  @override
  String get tourDone => 'Done';

  @override
  String get tourSkip => 'Skip';

  @override
  String get tourHubTitle => 'This is the whole game';

  @override
  String get tourHubBody =>
      'One button, and it changes as the cycle moves: a draw to watch, a squad to name, a match to play. Above it sit the board\'s confidence in you and the objectives they have set.';

  @override
  String get tourBudgetTitle => 'The federation\'s money';

  @override
  String get tourBudgetBody =>
      'Once every four-year cycle you split the war chest between the departments. Your staff are paid out of it first, so hiring an elite scout is a decision you make against the academy, not alongside it.';

  @override
  String get tourTacticsTitle => 'How the side plays';

  @override
  String get tourTacticsBody =>
      'Your shape, your way of playing, your captain and who takes the set pieces. Leave the last two unset and the game will warn you before kick-off rather than quietly picking for you.';

  @override
  String get tourSquadTitle => 'Everyone you can pick';

  @override
  String get tourSquadBody =>
      'The whole pool, not just the squad: who is in form, who is carrying a knock, who is banned, and who has just come through the academy.';

  @override
  String get tourCallUpsTitle => 'Naming a squad';

  @override
  String get tourCallUpsBody =>
      'You name one squad per international window and it plays every match of that window, exactly as a real manager does. An injury inside the window pulls in a replacement for you.';

  @override
  String get tourRecordsTitle => 'Your career';

  @override
  String get tourRecordsBody =>
      'Everything you have done: the matches, the team records, the trophies, and every nation you have managed.';

  @override
  String get tourCupsTitle => 'The rest of the world';

  @override
  String get tourCupsBody =>
      'Every competition running right now: groups, standings and knockouts, including the ones you are not in. The world keeps playing whether or not you qualified.';

  @override
  String get settingsTourTitle => 'Replay the tutorial';

  @override
  String get settingsTourBlurb =>
      'Walk through the key screens again from the start.';

  @override
  String get tourBoardTitle => 'Who you answer to';

  @override
  String get tourBoardBody =>
      'The board\'s confidence in you, and the objectives they have set for this cycle. Miss the brief and this is where you will see it coming.';

  @override
  String get tourStaffTitle => 'The people around you';

  @override
  String get tourStaffBody =>
      'An assistant, a scout and a fitness coach, hired by name. Their wages come out of this budget before the departments do, so a great scout is a decision against the academy.';

  @override
  String get tourPlaystyleTitle => 'Your way of playing';

  @override
  String get tourPlaystyleBody =>
      'The shape is only half a tactic. This is the other half: how high you press, how direct you are, how much you risk.';

  @override
  String get settingsTourNoSave =>
      'Start a career first. The walk through visits your own screens.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Out of position · Age $age';
  }

  @override
  String get federationNextCycleLocked =>
      'The next cycle\'s budget is set at the start of that cycle, in one go. Until then this is what your money is doing.';

  @override
  String get federationBudgetAlreadySet => 'Already set for this cycle';

  @override
  String yFinalLooms0(String opponent) {
    return 'It\'s $opponent for the big one. All week, this is all anybody is going to talk about.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Confirmed: $opponent stand between us and it. Four years for this.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Right. $opponent. Nobody sleeps until this is over.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent next, and everything else can wait. What a week to be alive.';
  }

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Marked below: sides who play like $rivals, who you have drawn.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Transfer window · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Last $when ago';
  }

  @override
  String get settingsFreeScopeTitle => 'One free four-year cycle';

  @override
  String get settingsFreeScopeBlurb =>
      'A complete cycle (qualifying, your continental championship and the World Championship) with nothing held back. Carrying a save on past it is a single payment, once, and it covers every save and every future update.';

  @override
  String get settingsUnlockedTitle => 'Unlocked';

  @override
  String get settingsUnlockedBlurb =>
      'Unlimited careers, every nation, ten save slots and every future update. Thank you.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Marked below: sides who play like $rivals, who you still have to face.';
  }

  @override
  String get friendliesCloseToYou =>
      'Marked below: the sides closest to you in the world ranking. Once you are drawn, the marks follow your group.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count moves',
      one: '1 move',
    );
    return '$_temp0';
  }

  @override
  String transfersRange(int from, int to, int total) {
    return '$from–$to of $total';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Newer';

  @override
  String get transfersOlder => 'More';

  @override
  String get transfersUnknownClub => 'Unknown club';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'That is $count times against $opponent now. Somebody is keeping score, and it is them.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent again. $count meetings, and we still have not worked them out.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Number $count against $opponent. This has stopped being a coincidence.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'We have played $opponent $count times and learned nothing from any of them.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count times. They know exactly what we are going to do.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Whatever $opponent have on us, $count meetings in, they still have it.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'That is the ${count}th time this has happened lately. At what point is it just what we are?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count afternoons like this now. It is a pattern, not a run of luck.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'We have seen this exact game $count times recently. Same script, same ending.';
  }

  @override
  String ySameOldStory3(String count) {
    return 'The ${count}th version of the same ninety minutes. Nobody is fixing it.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count times. If you cannot see the pattern by now you are not looking.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Same story, $count times over. The excuses have run out before the results did.';
  }

  @override
  String get yToldYouSo0 =>
      'I said this was coming while everybody was busy celebrating.';

  @override
  String get yToldYouSo1 =>
      'Two good weeks and we were a golden generation again. And here we are.';

  @override
  String get yToldYouSo2 =>
      'The people telling me to enjoy it last month have gone quiet.';

  @override
  String get yToldYouSo3 =>
      'I take no pleasure in this. Very little pleasure. Some.';

  @override
  String get yToldYouSo4 =>
      'It was never as good as they told you, and this is the proof.';

  @override
  String get yToldYouSo5 =>
      'Every time. We are told it is different, and every time it is not.';

  @override
  String get pressAskAbove =>
      'Nobody expected this side to be where it is. Is it real, or is it a good few months?';

  @override
  String get pressAskAbove2 =>
      'You are getting results against sides ranked well above you. How?';

  @override
  String get pressAskAbove3 =>
      'Every neutral has you overachieving. Does that description annoy you?';

  @override
  String get pressAskAbove4 =>
      'This squad is punching above its weight. What happens when it stops?';

  @override
  String get pressAskAbove5 =>
      'You keep beating teams you have no business beating. What have you found?';

  @override
  String get pressAskAbove6 =>
      'People are starting to take this seriously. Are you?';

  @override
  String get pressAskAbove7 =>
      'Is this side better than the ranking says, or are you catching people out?';

  @override
  String get pressAskAbove8 => 'How long can a group like this keep this up?';

  @override
  String get pressAskFlattered =>
      'You are winning without convincing anybody. Does that worry you?';

  @override
  String get pressAskFlattered2 =>
      'Another narrow one against a side you should be beating comfortably. Why is it so hard?';

  @override
  String get pressAskFlattered3 =>
      'Three points, and not much else. Is that enough for you?';

  @override
  String get pressAskFlattered4 => 'You got away with that. Would you agree?';

  @override
  String get pressAskFlattered5 =>
      'The results are there and the performances are not. Which one are you judging yourself on?';

  @override
  String get pressAskFlattered6 =>
      'Sides that ride their luck this often usually run out of it. Are you worried?';

  @override
  String get pressAskFlattered7 =>
      'That was hard work for what it was. What is missing?';

  @override
  String get pressAskFlattered8 =>
      'Do you care how you win, or only that you win?';

  @override
  String get pressAskCrisis =>
      'Bad results and a board that has stopped defending you. How bad is it?';

  @override
  String get pressAskCrisis2 =>
      'Nobody upstairs will say your name. Do you still have their backing?';

  @override
  String get pressAskCrisis3 =>
      'The results are poor and the silence from above is loud. What now?';

  @override
  String get pressAskCrisis4 =>
      'This has gone past a bad run. Do you accept that?';

  @override
  String get pressAskCrisis5 =>
      'You are losing the room and the boardroom at the same time. Which worries you more?';

  @override
  String get pressAskCrisis6 => 'Is there a point at which you would walk?';

  @override
  String get pressAskCrisis7 =>
      'What do you say to people who think this has run its course?';

  @override
  String get pressAskCrisis8 =>
      'Give us one reason to believe this turns around.';
}
