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
  String get matchStatGoals => 'Goals';

  @override
  String get matchStatYellowCards => 'Yellows';

  @override
  String get matchStatRedCards => 'Reds';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'ATK';

  @override
  String get matchSwingDef => 'DEF';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'WORLD CHAMPIONSHIP $year';
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
  String get matchContinuing => 'Continuing…';

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
  String get settingsContactTitle => 'Contact';

  @override
  String get settingsContactCopied => 'Address copied.';

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
  String get matchPreviewAllMeetings => 'All meetings';

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
  String get recordsMostWcStarts => 'MOST WORLD CHAMPIONSHIP STARTS';

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
  String get callUpHome => 'HOME';

  @override
  String get callUpAway => 'AWAY';

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
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Misses $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Out for this whole call-up';

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
  String get tacticsTabOtherPositions => 'OTHER PLACES';

  @override
  String get tacticsOutOfPositionNote => 'Out of position here';

  @override
  String get tacticsNobodyElse => 'Nobody else to try here.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Choose who comes off and the rest of the bench appears here, with what they would play this place at.';

  @override
  String get tacticsTabSuitable => 'SUITABLE';

  @override
  String get tacticsTabOnPitch => 'ON THE PITCH';

  @override
  String tacticsSectionSuitable(int count) {
    return 'SUITABLE · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Nobody on the bench naturally suits this place, so here is everybody.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'ON THE PITCH · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'AVAILABLE · $count';
  }

  @override
  String get tacticsRowStarted => 'Started';

  @override
  String tacticsRowCameOn(int minute) {
    return 'On at $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Came on';

  @override
  String get tacticsEnergyLabel => 'ENERGY';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Tap a replacement for $name, or tap him again to cancel.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'A red card cost you this place. Drag a team-mate here to move the gap.';

  @override
  String get tacticsSentOffShort => 'SENT OFF';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'SUBS · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Tap a man on the pitch to take him off, or hold and drag a sub onto him.';

  @override
  String get tacticsNoSubs => 'No substitutes available.';

  @override
  String get tacticsChooseShape => 'CHOOSE A SHAPE';

  @override
  String get tacticsFormation => 'FORMATION';

  @override
  String get tacticsInstructions => 'INSTRUCTIONS';

  @override
  String get tacticsDrilling => 'DRILLING';

  @override
  String get tacticsDrillingUnplayed => 'UNPLAYED';

  @override
  String get tacticsDrillingNew => 'NEW';

  @override
  String get tacticsDrillingSettling => 'SETTLING';

  @override
  String get tacticsDrillingDrilled => 'DRILLED';

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
  String get tacticsPickGoalkeeper => 'PICK GOALKEEPER';

  @override
  String get tacticsPickLeftBack => 'PICK LEFT BACK';

  @override
  String get tacticsPickCentreBack => 'PICK CENTRE BACK';

  @override
  String get tacticsPickRightBack => 'PICK RIGHT BACK';

  @override
  String get tacticsPickDefensiveMid => 'PICK DEFENSIVE MID';

  @override
  String get tacticsPickCentralMid => 'PICK CENTRAL MID';

  @override
  String get tacticsPickAttackingMid => 'PICK ATTACKING MID';

  @override
  String get tacticsPickLeftMid => 'PICK LEFT MID';

  @override
  String get tacticsPickRightMid => 'PICK RIGHT MID';

  @override
  String get tacticsPickLeftWing => 'PICK LEFT WING';

  @override
  String get tacticsPickRightWing => 'PICK RIGHT WING';

  @override
  String get tacticsPickStriker => 'PICK STRIKER';

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
  String get tacticsTakerAuto => 'Automatic';

  @override
  String get tacticsTakerQuickPick => 'Use best takers';

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
  String get hubContinueCareer => 'Continue your career';

  @override
  String get hubBackToSaves => 'Back to your saves';

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
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'World ranking';

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
      'Free for one full four-year cycle: qualifying, your continental championship and the World Championship, on two saves. After that, one payment unlocks endless cycles.';

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
  String get careerChallenges => 'Challenges';

  @override
  String get careerChallengesSubtitle => 'Brutal career-long tests to take on';

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
  String get careerThisSave => 'this save';

  @override
  String get careerSlotsFull => 'Slots full';

  @override
  String careerSlotsUsed(int used) {
    return 'SLOTS  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Unlock more saves';

  @override
  String get careerSlotsKeepNote =>
      'Every save you already have stays playable. Only a new one needs the unlock.';

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
    return '${minutes}m';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '${hours}h ${minutes}m';
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
  String resultsEarlierMatches(int count) {
    return 'Earlier matches ($count)';
  }

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
  String get achQualWcDesc => 'Qualify for the World Championship.';

  @override
  String get achQualCont => 'Continental Qualifier';

  @override
  String get achQualContDesc => 'Qualify for your continental championship.';

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
  String get paywallGoPro => 'GO UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'One-time unlock. No subscription.';

  @override
  String get paywallBenefitCarryOn =>
      'This save carries on exactly where it stopped, with every cap, record and rivalry intact.';

  @override
  String get paywallBenefitNoAds =>
      'No ads, no microtransactions, no subscription. One payment, and every future update is yours.';

  @override
  String get paywallBenefitSaves =>
      'As many saves as you want. Run a favourite and a minnow at once, and find out how differently the same game reads.';

  @override
  String get paywallBenefitEndless =>
      'Every cycle from here on. Pick a seventeen-year-old today and learn in 2034 whether you saw it.';

  @override
  String get paywallUnlocked => 'Unlimited is unlocked. Enjoy!';

  @override
  String get paywallContactingStore => 'Contacting the store…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Unlock Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Restore purchases';

  @override
  String get paywallStoreUnavailable => 'Store unavailable';

  @override
  String get paywallStoreUnavailableNote =>
      'The price could not be loaded. Check your connection and try again.';

  @override
  String get paywallTryAgain => 'Try again';

  @override
  String get gateTitle => 'YOUR FIRST CYCLE IS OVER';

  @override
  String get gateLead =>
      'Four years is one cycle. It is not long enough to find out whether you were right.';

  @override
  String get gatePriceLead => 'One payment, forever';

  @override
  String get gateBuy => 'BUY AND CONTINUE';

  @override
  String get gateExit => 'EXIT';

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
    return 'Out at $opponent. That one will hurt for a while.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent is where it ends for us.';
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
  String get yEarlierHeading => 'Earlier this cycle';

  @override
  String get yTraitLoyalist =>
      'Backs the side whatever happens. Slow to turn, quick to forgive.';

  @override
  String get yTraitCynic =>
      'Assumes the worst and is delighted to be proved right.';

  @override
  String get yTraitNostalgic =>
      'Everything was better before. Measures you against men who retired.';

  @override
  String get yTraitStatshead =>
      'Posts the numbers and nothing else. Barely has a mood.';

  @override
  String get yTraitHypeman => 'Two good results and it is a golden generation.';

  @override
  String get yTraitContrarian => 'Whatever the room thinks, the opposite.';

  @override
  String get yTraitDoomer =>
      'It is going to go wrong. It is always going to go wrong.';

  @override
  String get yProfilePosts => 'POSTS';

  @override
  String get yProfileEmpty => 'Nothing from this account yet.';

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
  String ySentOff0(String name, String minute) {
    return 'Red for $name on $minute minutes and the whole country turns on him. He has given us more than most. Leave it.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name off after $minute minutes. Harsh. Ten men and we still had a go, which tells you something.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute minutes, red card. Ten men from there.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Sending off: $name on $minute. Not the first match to turn on one decision.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Brilliant. $name walks on $minute minutes and we are down to ten. Again.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name sent off after $minute minutes. Who exactly is coaching discipline around here?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minutes. That is how long $name could keep his head. Professional football.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'A red for $name on $minute minutes, and I am supposed to believe this is progress.';
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
  String get tourContWorldQualifyingDraw => 'WORLD QUALIFYING DRAW';

  @override
  String get tourContFinalsDraw => 'FINALS DRAW';

  @override
  String get tourContSeedingPots => 'SEEDING POTS';

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
  String get tourContLeagueNoGroups => 'No matches in this league this round.';

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
  String get tourCupDestRoundOf16 => 'the Round of 16';

  @override
  String get tourCupDestKnockouts => 'the knockouts';

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
  String get objectiveQualifyingTopHalf =>
      'Finish in the top half of qualifying';

  @override
  String get finishQualifyingTopHalf => 'Top half of the qualifying group';

  @override
  String get finishQualifyingBottomHalf =>
      'Bottom half of the qualifying group';

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
  String get squadDevTierRegulars => 'REGULARS';

  @override
  String get squadDevTierFringe => 'FRINGE';

  @override
  String get squadDevTierYouth => 'YOUTH';

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
    return '$page/$pages · $total players';
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
  String get youthWatching => 'Watching';

  @override
  String get youthWatchEmpty =>
      'Nobody marked yet. Mark a boy on any level and he turns up here, with what he has become since.';

  @override
  String get youthWatchMark => 'Follow this boy';

  @override
  String get youthWatchUnmark => 'Stop following him';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Marked at $rating, aged $age';
  }

  @override
  String get youthWatchSenior => 'Through to the senior pool';

  @override
  String get youthWatchReleased => 'Released by the academy';

  @override
  String get youthWatchGone => 'No longer in the pyramid';

  @override
  String get tacticsYouth => 'Under-21s';

  @override
  String get pressSquad => 'Squad';

  @override
  String get pressBoard => 'Board';

  @override
  String get pressNoEffect => 'Nobody reads much into it';

  @override
  String get matchNeutralGround => 'NEUTRAL';

  @override
  String get matchExtraTimeAhead => 'EXTRA TIME';

  @override
  String get matchExtraTimeHalf => 'EXTRA TIME · HALF TIME';

  @override
  String get matchClockFullTime => 'FULL TIME';

  @override
  String get matchClockAfterExtraTime => 'AFTER EXTRA TIME';

  @override
  String get matchClockPenalties => 'PENALTIES';

  @override
  String get matchClockFullTimePenalties => 'FULL TIME · PENALTIES';

  @override
  String get hubEventPressConference => 'Face the press';

  @override
  String get hubEventPressConferenceSub =>
      'The world’s media want a word before your first match';

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
  String get squadLegendTitle => 'What the marks mean';

  @override
  String get squadLegendStarting => 'In your starting eleven';

  @override
  String get squadLegendCalledUp => 'Called up, on the bench';

  @override
  String get squadLegendRatingUp => 'Rating rising this year';

  @override
  String get squadLegendRatingDown => 'Rating falling this year';

  @override
  String get squadLegendInjured => 'Injured, unavailable';

  @override
  String get squadLegendSuspended => 'Suspended, unavailable';

  @override
  String get squadLegendTraits => 'KNOWN FOR';

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
  String get recordsRecordBookSubtitle =>
      'Caps, goals and the team\'s headline records';

  @override
  String get statsLegacy => 'LEGACY';

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
    return 'Up $_temp0 in all, to #$rank.';
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
    return 'Down $_temp0 in all, to #$rank.';
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
  String msgRankJumpTitleUp(int rank) {
    return 'A climb to #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'A slide to #$rank';
  }

  @override
  String msgRankJumpBodyUp(
    String tournament,
    String nation,
    int from,
    int to,
    int move,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places',
      one: '1 place',
    );
    return '$tournament has moved the world ranking. $nation went in #$from and came out #$to, a climb of $_temp0.';
  }

  @override
  String msgRankJumpBodyDown(
    String tournament,
    String nation,
    int from,
    int to,
    int move,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move places',
      one: '1 place',
    );
    return '$tournament has moved the world ranking. $nation went in #$from and came out #$to, a slide of $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Since the World Championship draw';

  @override
  String get rankingSinceCycleStart => 'Since the campaign began';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from to #$now';
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
  String get msgIntakeNoteAcademy =>
      'The academy investment is showing: this intake arrived stronger than it would have.';

  @override
  String get msgIntakeNoteStanding =>
      'The country is watching this team: with the side climbing the world ranking, the best boys are picking football, and this intake arrived stronger for it.';

  @override
  String get msgIntakeNoteBoth =>
      'The academy money and the side\'s rise up the world ranking are both showing: this intake arrived stronger than it would have.';

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
  String get newsTransferFree => 'Free';

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
  String get tourDrawWcQualifying => 'WORLD QUALIFYING DRAW';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup QUALIFYING DRAW';
  }

  @override
  String get tourDrawWcHost => 'WORLD CHAMPIONSHIP HOST';

  @override
  String tourDrawContHost(String cup) {
    return '$cup HOST';
  }

  @override
  String get tourDrawHostsReveal => 'And the hosts will be…';

  @override
  String get tourDrawHostReveal => 'And the host will be…';

  @override
  String get tourDrawHostCandidates => 'The candidates in the running:';

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
  String get potyLabelBest => 'Player of the Year';

  @override
  String get potyLabelYoung => 'Young Player of the Year';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assists',
      one: '1 assist',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Rating $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Marked $value';
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
  String newsWatchTitle(int year) {
    return 'The boys you are watching, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain points',
      one: 'a point',
    );
    return '$name has kicked on to $rating, $_temp0 up on last year.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name moves up to the ${band}s.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name makes his debut';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name has won his first cap at $age, rated $rating. One of the boys you are watching.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Possession, player ratings and the man of the match are settled at the final whistle.';

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
  String matchShootoutKickScored(String name) {
    return '$name: SCORED';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: MISSED';
  }

  @override
  String get matchFeedKickOff => 'Kick-off!';

  @override
  String get matchFeedNoEvents => 'No events yet.';

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
  String get tourZoneGlobal => 'GLOBAL';

  @override
  String get tourZoneEurope => 'EUROPE';

  @override
  String get tourZoneSouthAmerica => 'S. AMERICA';

  @override
  String get tourZoneNorthAmerica => 'N. AMERICA';

  @override
  String get tourZoneAfrica => 'AFRICA';

  @override
  String get tourZoneAsia => 'ASIA';

  @override
  String get tourZoneOceania => 'OCEANIA';

  @override
  String get tourZoneIntercontinental => 'INTERCONTINENTAL';

  @override
  String tourZoneLeague(String league) {
    return 'LEAGUE $league';
  }

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
  String get yReactionDespair7 => 'That one is going to sting for a long time.';

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
  String get careerExportSave => 'Back up this save';

  @override
  String get careerBackupAll => 'BACK UP ALL SAVES';

  @override
  String get careerBackupAllFailed => 'Could not write the backup.';

  @override
  String get backupTitle => 'SAVES';

  @override
  String get backupBlurb =>
      'Every save lives in one file on this phone, and nothing backs it up on its own. Export a copy and keep it somewhere off the phone, in Files or iCloud Drive, so a lost phone or a deleted app does not cost you a career.';

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
  String get careerImportFailedSlotsFull =>
      'All your save slots are in use. Delete a save to make room, or unlock unlimited saves.';

  @override
  String get careerImportFailedNeedsPremium =>
      'That career is past the free first cycle. Unlock the full game to take it in.';

  @override
  String get careerShareFailed => 'Could not export that career.';

  @override
  String get managerRename => 'Change name';

  @override
  String get managerRenameSave => 'Save';

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
      'Runs the training: fewer injuries, and better youngsters coming through.';

  @override
  String get managerRoleScout => 'Chief Scout';

  @override
  String get managerRoleScoutBlurb =>
      'Reads your prospects and your next opponent: truer star ratings, and an edge on matchday.';

  @override
  String get managerRoleFitness => 'Fitness Coach';

  @override
  String get managerRoleFitnessBlurb => 'Keeps them on the pitch.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% fewer injuries';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Youngsters +$points overall';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Hiring one: $min% to $max% fewer injuries';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'and youngsters +$minPoints to +$maxPoints overall';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Reads $percent% of prospects exactly';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potential known after $caps caps',
      one: 'Potential known after 1 cap',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points rating from opponent dossiers';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Hiring one: $min% to $max% of reads exact';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'and potential known $minCaps to $maxCaps caps sooner';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'and +$minPoints to +$maxPoints rating every match';
  }

  @override
  String get staffEffectNone => 'No effect on your squad yet';

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
  String get matchSetupLeaveToCoach => 'Leave the takers to the coach';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Marked below: sides who play like $rivals, the teams you meet in your groups this cycle.';
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
      'A complete cycle (qualifying, your continental championship and the World Championship) on two saves, every nation in the world, nothing held back. Endless cycles and unlimited saves are a single payment, once, and it covers every future update.';

  @override
  String get settingsUnlockedTitle => 'Unlocked';

  @override
  String get settingsUnlockedBlurb =>
      'Endless cycles, unlimited saves and every future update. Thank you.';

  @override
  String get settingsFromDeveloperTitle => 'From the developer';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager is made by one person and will be supported for the long term. There will never be ads or microtransactions. If you enjoy the game, please consider buying the full version. It is what keeps the updates coming.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager is made by one person and will be supported for the long term. There will never be ads or microtransactions. Thank you for buying the full version. It is what keeps the updates coming.';

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
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Newer';

  @override
  String get transfersOlder => 'More';

  @override
  String get transfersPagePrevious => 'Previous';

  @override
  String get transfersPageNext => 'Next';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get transfersMovedTo => 'Moved to';

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
    return 'That is $count times this has happened lately. At what point is it just what we are?';
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
    return '$count versions of the same ninety minutes now. Nobody is fixing it.';
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
  String get tacticsSubOffAlready => 'Already off';

  @override
  String get tacticsSubInjured => 'Injured';

  @override
  String get tacticsSubSentOffMark => 'Sent off';

  @override
  String get tacticsSubNoneLeft => 'No changes left';

  @override
  String get tacticsUndoLastChange => 'Undo last change';

  @override
  String get matchStrengthTitle => 'WHAT IS MOVING THE SIDE';

  @override
  String get strengthFactorFamiliarity => 'Drilled shape';

  @override
  String get strengthFactorFatigue => 'Tired legs';

  @override
  String get strengthFactorClubForm => 'Club form';

  @override
  String get strengthFactorMorale => 'Dressing room';

  @override
  String get strengthFactorCaptain => 'Captain';

  @override
  String get strengthFactorStaff => 'Staff room';

  @override
  String get strengthFactorDossier => 'Scout\'s dossier';

  @override
  String yDebut0(String name) {
    return '$name gets his first cap. Remember the name.';
  }

  @override
  String yDebut1(String name) {
    return 'A debut for $name. You can see it in him, can you not?';
  }

  @override
  String yDebut2(String name) {
    return '$name, first cap. Let us see what he does with it.';
  }

  @override
  String yDebut3(String name) {
    return 'Debut for $name. The squad needed fresh legs somewhere.';
  }

  @override
  String yDebut4(String name) {
    return '$name handed a cap. We have handed out a lot of those lately.';
  }

  @override
  String yDebut5(String name) {
    return 'A debut for $name. Another one we will have forgotten by spring.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name has gone $count without scoring and is doing everything else on the pitch.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count games without a goal for $name. They come in threes, always have.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count games, no goals.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count without a goal for $name. Worth keeping an eye on.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count games. No goals. $name could not hit a barn door.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name has not scored in $count. Play literally anybody else.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '$opponent next. $count meetings and it still means everything.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count times against $opponent now. Bring it on.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '$opponent next. Played $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Meeting number $count with $opponent this week.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent again. $count of these and we have learned nothing.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count games against $opponent and they still beat us. Wonderful.';
  }

  @override
  String get positionGoalkeeper => 'Goalkeeper';

  @override
  String get positionLeftBack => 'Left Back';

  @override
  String get positionCentreBack => 'Centre Back';

  @override
  String get positionRightBack => 'Right Back';

  @override
  String get positionDefensiveMid => 'Defensive Mid';

  @override
  String get positionCentralMid => 'Central Mid';

  @override
  String get positionAttackingMid => 'Attacking Mid';

  @override
  String get positionLeftMid => 'Left Mid';

  @override
  String get positionRightMid => 'Right Mid';

  @override
  String get positionLeftWing => 'Left Wing';

  @override
  String get positionRightWing => 'Right Wing';

  @override
  String get positionStriker => 'Striker';

  @override
  String get roleNone => 'No role';

  @override
  String get roleTargetMan => 'Target man';

  @override
  String get rolePoacher => 'Poacher';

  @override
  String get rolePlaymaker => 'Playmaker';

  @override
  String get roleBallWinner => 'Ball winner';

  @override
  String get roleInvertedWinger => 'Inverted winger';

  @override
  String get roleBallPlayingDefender => 'Ball-playing defender';

  @override
  String get roleNoneBlurb => 'Plays their natural game.';

  @override
  String get roleTargetManBlurb =>
      'Wins headers, lays it off. Assists and set pieces.';

  @override
  String get rolePoacherBlurb => 'Lurks in the box. Many more goals.';

  @override
  String get rolePlaymakerBlurb => 'Creates chances. Far more assists.';

  @override
  String get roleBallWinnerBlurb => 'Breaks up play rather than finishing it.';

  @override
  String get roleInvertedWingerBlurb => 'Cuts inside to shoot. More goals.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Starts moves from the back.';

  @override
  String get federationDeptYouth => 'Youth Academy';

  @override
  String get federationDeptCommercial => 'Commercial / PR';

  @override
  String get federationDeptMedical => 'Medical & Sports Science';

  @override
  String get federationDeptNaturalisation => 'Naturalisation Office';

  @override
  String get federationDeptBoardRelations => 'Board Relations';

  @override
  String get federationDeptYouthBlurb =>
      'Better academy prospects debut for your nation next cycle.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsorship brings extra income at the end of the cycle.';

  @override
  String get federationDeptMedicalBlurb =>
      'Fewer injuries. Your squad stays available all cycle.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'More foreign players offer to switch to your nation.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'The board judges your results more patiently.';

  @override
  String get federationBuildingAcademy => 'Academy';

  @override
  String get federationBuildingCommercial => 'Commercial HQ';

  @override
  String get federationBuildingMedical => 'Medical Centre';

  @override
  String get federationBuildingScouting => 'Scouting Office';

  @override
  String get federationBuildingBoardroom => 'Boardroom';

  @override
  String get moraleBuoyant => 'Buoyant';

  @override
  String get moralePositive => 'Positive';

  @override
  String get moraleSettled => 'Settled';

  @override
  String get moraleUneasy => 'Uneasy';

  @override
  String get moraleRockBottom => 'Rock bottom';

  @override
  String get matchTabTimeline => 'TIMELINE';

  @override
  String get matchTabStats => 'STATS';

  @override
  String get matchTabLineups => 'LINEUPS';

  @override
  String get matchPenalty => 'PENALTY';

  @override
  String get matchStateLevel => 'It’s all square';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You lead by $count goals',
      one: 'You lead by a goal',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You trail by $count goals',
      one: 'You trail by a goal',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% possession';
  }

  @override
  String get boardVerdictSackedTitle => 'The board has dismissed you';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'A dismal cycle (rating $rating%). Your reign ends here. Only lesser nations will take a chance on you now.';
  }

  @override
  String get boardVerdictDelightedTitle => 'The board is delighted';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'An outstanding cycle (rating $rating%) after $best. Bigger nations are interested, or you can stay and build.';
  }

  @override
  String get boardVerdictSolidTitle => 'A solid cycle';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'The board is content (rating $rating%). A few nations of similar standing would take you, but there is no pressure to move.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'The board expected more';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'A disappointing cycle (rating $rating%). You keep your job, but any offers are a step down.';
  }

  @override
  String get boardVerdictPressureTitle => 'You are under real pressure';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'A poor cycle (rating $rating%). You survive, but only weaker nations are interested if you fancy a fresh start.';
  }

  @override
  String get boardVerdictHeroTitle => 'The nation stands by you';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cycles',
      one: '1 cycle',
    );
    return ' $nation adore you, a national hero after $_temp0; your job is safe for as long as you want it.';
  }

  @override
  String get boardVerdictTheNation => 'The nation';

  @override
  String get boardVerdictBestQuiet => 'a quiet cycle';

  @override
  String get boardVerdictBestCycle => 'the cycle';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'the World Championship: $placement';
  }

  @override
  String get finishThirdPlace => 'Third place';

  @override
  String get finishFourthPlace => 'Fourth place';

  @override
  String get finishDidNotQualify => 'Did not qualify';

  @override
  String get careerRepIconic => 'Iconic';

  @override
  String get careerRepRenowned => 'Renowned';

  @override
  String get careerRepEstablished => 'Established';

  @override
  String get careerRepRising => 'Up-and-coming';

  @override
  String get careerRepUnproven => 'Unproven';

  @override
  String get hubOfferStepUp => 'Step up';

  @override
  String get hubOfferLateral => 'Lateral move';

  @override
  String get hubOfferRebuild => 'A rebuild';

  @override
  String careerNationsCupWon(String league) {
    return 'League $league · Champions';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'League $league · Runners-up';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'League $league · Semi-finalist';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'League $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Into the $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Into the third-place play-off';

  @override
  String tourRunThrough(String round) {
    return 'Through from the $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Knocked out in the $round';
  }

  @override
  String get tourRunInGroup => 'Contesting the group stage';

  @override
  String get tourRunGroupOut => 'Eliminated in the group stage';

  @override
  String resultsCycleTitle(int year, String nation) {
    return '$year cycle · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played played  ·  ${won}W ${drawn}D ${lost}L';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'World Championship: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Still being played';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Two down to $opponent at the break and they got every bit of it back. That is a team.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Two behind against $opponent and by the end it did not matter. Not many sides do that.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Half time: two goals down to $opponent. Full time: not. The second half was a different match.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Came from two down against $opponent. Whatever was said at the break, say it every week.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Fine, we got it back against $opponent. Now somebody explain the first forty-five minutes.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Two down to $opponent and we are supposed to be delighted. Fix the first half.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Two up on $opponent at the break and it slipped away. It happens to better sides.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Two goals in front of $opponent and it got away. Long cycle ahead, plenty of time.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Half time: two goals up on $opponent. Full time: nothing like it.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'A two-goal lead against $opponent, gone inside forty-five minutes.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Two up and we lost it. To $opponent. Somebody answers for that.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Two goals in front against $opponent and we managed this. Every single time.';
  }

  @override
  String get cycleBackupDone =>
      'Career backed up to the FNM folder on this phone. Uninstalling the app removes it: to keep a copy elsewhere, use Back up this save on the saves screen.';

  @override
  String get cycleBackupFailed => 'Could not back up the career this time.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'A night to remember against $opponent. How proud are you of this group?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent could not live with you. Is this the side you always believed you had?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'A big win over $opponent. What made the difference tonight?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent beaten, and comfortably. Where did you win it?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'A good win over $opponent. One good night: why should anyone believe it will last?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'A fine result against $opponent. Was that your plan, or did the players work it out themselves?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'A hard night against $opponent. What do you say to the players after one like that?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Nobody saw that coming against $opponent. Was it just one of those nights?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'That was a chastening night against $opponent. What went wrong?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent took you apart. Is this squad good enough?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'You were second to everything against $opponent. How did you let it get that bad?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent scored at will. Where was the plan tonight?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Another one gets away, this time against $opponent. How do you turn this run around?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'The results have dried up, and $opponent made it worse. Do you still believe in this group?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'No win again, now against $opponent, and the board are watching. Is your job safe?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'After $opponent, the run is getting long. Are you worried about your future?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return '$opponent now as well. Your predecessor was sacked on a run like this. Why should you survive it?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'After another night like $opponent, every phone-in wants you out. Would you step down if the board asked?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'You put your job on the line, and after $opponent it has not gone your way. How are you holding up?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'The three matches are done, the last against $opponent. You set the test yourself. What do you make of the verdict?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'You told us to judge you on the next three. After $opponent, we have. Is your job still yours?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Three matches, the last against $opponent, and not what you promised. Have you spoken to the board about your future?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'You set the test yourself and failed it against $opponent. Are you going to resign?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Your words, not ours: judge me on the next three. After $opponent, why are you still sitting there?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'You want more from them. Anyone in particular?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'You have set the bar high. Who has to step up first?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'You say some of them have to look at themselves. Who do you mean?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Not good enough, you say. Who are you talking about?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'You keep it vague. Will you name names, or does it come back to you?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Every week it is somebody else\'s fault. Whose is it this time?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Brave words. And if the next one does not go your way?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'The country will hold you to that. What if it does not come off?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'And if you don\'t win it? What then?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'You\'ve said it now. What happens if you\'re wrong?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'We have heard promises in this room before. What do you owe the supporters if this one breaks too?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'And when it doesn\'t happen, what will the excuse be?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'One more, if you have it in you. What does this group still need to work on?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'When the dust settles, what do you take from tonight into the next match?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Let\'s go a little deeper. What has to improve before the next match?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Looking past the scoreline: is this squad where you want it?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Plenty of words, not much said. What actually changes from here?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'The supporters want a straight answer. Is this team good enough, yes or no?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player was outstanding tonight. How far can he go?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player is in every headline tonight. Did you see that coming?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player stood out. What did you ask of him tonight?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Was $player the difference tonight?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Without $player that is a different story. Is this a team, or one player?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player was brilliant. Your doing, or his?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player had a hard night. Is he carrying a knock?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player did not have his night. Will you put an arm round him?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player struggled tonight. Does he keep his place?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player looked off the pace. What did you make of his game?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player was a passenger again. Why do you keep picking him?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Everyone could see $player was not at it. Everyone except the bench?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'You said you would win the next one, and you did. Does it feel good to be right?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'You promised a win in the next match and delivered it. Confidence, or bravado?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'You said you would win the next one, and you did. Luck, or are we meant to start listening?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'You told us you would win that one. It did not happen. What went wrong?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'You said you\'d win the next one. You didn\'t. Why should we believe the next promise?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'You said you\'d win the next one. You didn\'t. Do your words still mean anything in this room?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'You asked to be judged on three matches, and you passed. Vindicated?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Judge me on the next three, you said. We did, and the results came. What did that test teach you?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'You gave yourself three matches and got through them. Was the test ever that hard?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'You asked to be judged on three matches. They did not go your way. What have you learned?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'You said judge me on the next three. The three are gone, and so is the benefit of the doubt. What now?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'You set the test and failed it. Why should anyone take your word now?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'You backed $player when others would not. He delivered. Some of the credit yours?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'You backed $player. He delivered. Faith, or knowledge?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'You backed $player, and for once it paid off. Will you be that sure next time?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'You stood by $player, and it has not worked out. Do you still believe in him?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'You backed $player. He has not repaid it. Was that a mistake?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Your judgement or your loyalty: which one failed with $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'You were hard on $player, and the matches since have proved you right. Any satisfaction in that?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'You called $player out, and he has not answered. Is there a way back for him?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'You hung $player out to dry and he has not recovered. Did you break him?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'You called $player out, and he answered you on the pitch. Was that the idea all along?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'You blamed $player, and since then he has been one of your best. Do you owe him an apology?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'You threw $player under the bus, and he has been your best player since. Will you apologise?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'These players gave me everything. I would not swap a single one of them.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Nobody works harder than this group. I\'ll defend them all day.';

  @override
  String get pressReplyCreditPlayers3 =>
      'You won\'t hear a word against my players from this seat.';

  @override
  String get pressReplyCreditPlayers4 =>
      'The players deserve the credit, not me. Write about them.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'That one is on me. I picked the side and I set them up.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Judge me, not them. It\'s my team and my responsibility.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'If you want somebody to blame, I\'m sitting right here.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'The responsibility is mine. Leave the players out of it.';

  @override
  String get pressReplyDemandMore1 =>
      'I want more. Some of them know exactly what I mean.';

  @override
  String get pressReplyDemandMore2 =>
      'Effort isn\'t enough at this level. I want more, and I\'ve told them so.';

  @override
  String get pressReplyDemandMore3 =>
      'I expect more from every one of them, starting tomorrow.';

  @override
  String get pressReplyDemandMore4 =>
      'Some of them have to look at themselves. I\'m not satisfied.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'We will win the next one. You can write that down.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Mark my words: we win the next match.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Next game, we win. I\'m saying it here so you can hold me to it.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'I\'m sure of this team. We win the next match.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Judge me on the next three matches. That\'s fair.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Give me three games. If it isn\'t right by then, judge me on it.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'The next three will show whether I\'m the right man. Hold me to that.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Three matches. Then write whatever you like about me.';

  @override
  String get pressReplyDeflect1 =>
      'We take it one game at a time. Nothing more to add.';

  @override
  String get pressReplyDeflect2 =>
      'I\'m not going to make headlines for you today.';

  @override
  String get pressReplyDeflect3 =>
      'Next game. That\'s all I\'m thinking about.';

  @override
  String get pressReplyDeflect4 => 'What I think stays in the dressing room.';

  @override
  String get pressReplyTakeCredit1 =>
      'I said it because I believed it, and I was right.';

  @override
  String get pressReplyTakeCredit2 =>
      'I read it correctly. That\'s what I\'m here for.';

  @override
  String get pressReplyTakeCredit3 =>
      'Call it judgement. I knew what I was saying.';

  @override
  String get pressReplyTakeCredit4 =>
      'I made the call and it came off. I\'ll take that.';

  @override
  String get pressReplyStandByIt1 => 'I said what I believed. I stand by it.';

  @override
  String get pressReplyStandByIt2 => 'I don\'t take back a word of it.';

  @override
  String get pressReplyStandByIt3 =>
      'Same answer as then. I meant it, and I still do.';

  @override
  String get pressReplyStandByIt4 => 'I\'d say it again tomorrow.';

  @override
  String get pressReplyAdmitMistake1 => 'I got that one wrong. I\'ll own it.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Fair enough, I misjudged it. I\'ll learn from it.';

  @override
  String get pressReplyAdmitMistake3 => 'I was wrong, and I can say so.';

  @override
  String get pressReplyAdmitMistake4 =>
      'That call didn\'t work, and it was mine.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player has my full backing. He\'ll come good.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'I believe in $player, and he\'ll show you why.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'You won\'t hear a word against $player from me. He\'ll deliver.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player stays in my plans. Watch what he does next.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player let us down tonight, and he knows it.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'I expected far more from $player. He has to answer that.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player wasn\'t at the level. I\'ll say that publicly.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'That wasn\'t good enough from $player, and he\'ll hear it from me.';
  }

  @override
  String get pressOnRecordWinNext =>
      'On the record: you will win the next match.';

  @override
  String get pressOnRecordJob => 'On the record: judge you on the next three.';

  @override
  String pressOnRecordBack(String player) {
    return 'On the record: backing $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'On the record: $player let you down.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'He said it, and it happened. $nation has a manager who means what he says.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Said it out loud, then went and did it. That is the man $nation needed.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: he called it, and it came true. Fair enough.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'He put it on the record and it held. One for him. $nation moves on.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'He got one right. $nation, do not get used to it.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Even a stopped clock is right twice a day. $nation got lucky this time.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'He said it and it did not come off. Still with him. $nation goes again.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: he promised more than we got, but I would rather a manager who backs himself.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: he said it on the record and it did not happen. People will remember.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Big words, nothing behind them. $nation: next time, say less.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'He stood there and told us. Then this. $nation deserves better than talk.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'His word is worth nothing now. Write it down, $nation.';
  }

  @override
  String get ncZoneNorth => 'North Zone';

  @override
  String get ncZoneWest => 'West Zone';

  @override
  String get ncZoneEast => 'East Zone';

  @override
  String get ncZoneCentralSouthern => 'Central and Southern Zone';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Champions';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Runners-up';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Semi-finalist';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Round of 16';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Quarter-finalist';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Reach the quarter-finals';

  @override
  String get objectiveNcZoneWinGroup => 'Win your group';

  @override
  String get finishNcFinalsEight => 'Quarter-finals';

  @override
  String get finishNcBottomHalf => 'Bottom half of the group';

  @override
  String get tourContTabZones => 'ZONES';

  @override
  String get tourContTabFinalsEight => 'KNOCKOUTS';

  @override
  String get tourContFinalsEightSoon =>
      'The knockouts start in November with a Round of 16: all 14 group winners and the 2 best runners-up.';

  @override
  String get tourContQuarterFinals => 'QUARTER-FINALS';

  @override
  String get tourContZoneAdvancement =>
      'Every group winner goes through to the Round of 16, joined by the 2 best runners-up. Nobody is relegated.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'North America Nations Cup';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Win the North America Nations Cup';

  @override
  String get objectiveNcWinItAfrica => 'Win the Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Reach the North America Nations Cup final';

  @override
  String get objectiveNcReachFinalAfrica => 'Reach the Nations Cup final';

  @override
  String get finishNcChampionsNorthAmerica =>
      'North America Nations Cup winners';

  @override
  String get finishNcChampionsAfrica => 'Nations Cup winners';

  @override
  String pressAimQualWarm1(String competition) {
    return '$competition qualifying starts now, and the country believes in this side. What are you aiming for?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'A new $competition qualifying campaign, and spirits are high. How far can this team go?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return '$competition qualifying begins. What is the target for this campaign?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'The $competition qualifiers are here. Where do you see this side finishing?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return '$competition qualifying starts, and plenty of people doubt you will get there. What do you say to them?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Another $competition qualifying campaign. Why should anyone believe this one will be different?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'The $competition is here and the whole country is behind you. How far can you go?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'You are at the $competition and the fans are dreaming. What is the aim?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'The $competition starts this week. What would count as a success?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Your first game at the $competition is close. Set us a target.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'The $competition is here and nobody expects much. What are you really hoping for?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'You are at the $competition, but the doubts have not gone away. What is your target?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival are in your group. Do they worry you?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'The draw put $rival in your way. How do you see that game?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival look the strongest side in your group. Are they the favourites?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'What do you make of $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival are in your group. Be honest, can you live with them?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Most people expect $rival to beat you. Are they wrong?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player is in fine form. Is this his moment?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player is in every headline. Can he carry this side?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'How much does this campaign depend on $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Is $player ready to lead this team?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'If $player is not at his best, does this side have anything?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player has a lot on his shoulders. Too much?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'We are going further than anyone expects.';

  @override
  String get pressReplyAimHigher2 =>
      'I want more than the federation asked for, and I will say it out loud.';

  @override
  String get pressReplyMatchBrief1 =>
      'We know the target and we will reach it.';

  @override
  String get pressReplyMatchBrief2 =>
      'The federation set a target. We will deliver it.';

  @override
  String get pressReplyPlayDown1 => 'Let us take it one game at a time.';

  @override
  String get pressReplyPlayDown2 =>
      'No big promises. We will see where we are.';

  @override
  String get pressReplyPromiseQualify1 =>
      'We will qualify. You can write that down.';

  @override
  String get pressReplyPromiseQualify2 => 'This side will be at the finals.';

  @override
  String get pressReplyFearNobody1 => 'We fear nobody.';

  @override
  String get pressReplyFearNobody2 => 'They have to play us too.';

  @override
  String get pressReplyRespectRival1 =>
      'They are the favourites, and we respect them.';

  @override
  String get pressReplyRespectRival2 =>
      'A very good side. We will need our best.';

  @override
  String get pressReplyTeamFirst1 =>
      'It is about the whole team, not one player.';

  @override
  String get pressReplyTeamFirst2 => 'Nobody wins this alone.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'On the record: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'On the record: no promises.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'You set a target before the campaign and you hit it. Is that your proudest moment yet?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'You said what you would achieve, and you did. Was it ever in doubt?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'You hit the target you set. Lucky, or was it really the plan?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'You set a target and fell short. What went wrong?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'You promised more than this side delivered. Do you regret saying it?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'You talked big before the campaign and fell short. Why should we believe you now?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'The press want to hear your aims for the $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Level $level · $amount';
  }

  @override
  String get formOnFire => 'On fire';

  @override
  String get formGood => 'In form';

  @override
  String get formSteady => 'Steady';

  @override
  String get formPoor => 'Out of form';

  @override
  String get formCold => 'Ice cold';

  @override
  String get playerFormTitle => 'FORM AND FITNESS';

  @override
  String playerFormAverage(String rating) {
    return 'Averaging $rating in his recent games';
  }

  @override
  String get playerFormNoGames => 'Not enough recent games to judge';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta to his rating next match';
  }

  @override
  String get playerFormNoEffect => 'No change to his rating next match';

  @override
  String get sideGroupHome => 'Home';

  @override
  String get sideGroupTeam => 'Team';

  @override
  String get sideGroupCompetitions => 'Competitions';

  @override
  String get sideGroupFederation => 'Federation';

  @override
  String get sideGroupHistory => 'History';

  @override
  String get sideInbox => 'Inbox';

  @override
  String get sideSquad => 'Squad';

  @override
  String get sideTactics => 'Tactics';

  @override
  String get sideMainMenu => 'Main menu';

  @override
  String get sideCallUps => 'Call-ups';

  @override
  String get sideTournaments => 'Tournaments';

  @override
  String get sideRanking => 'Ranking';

  @override
  String get sideResults => 'Results';

  @override
  String get sideFinances => 'Finances';

  @override
  String get sideBoard => 'Board';

  @override
  String get sideManager => 'Manager & staff';

  @override
  String get sideRecords => 'Records';

  @override
  String get sideLegends => 'Legends';

  @override
  String get sideHeadToHead => 'Head to head';

  @override
  String get sideAchievements => 'Achievements';

  @override
  String get sideCareer => 'Career';

  @override
  String get topBarNext => 'Next';

  @override
  String get topBarDrawPending => 'Draw to come';

  @override
  String get paneFullProfile => 'Full profile';

  @override
  String get panePickPlayer => 'Pick a player to see his card here';

  @override
  String get inboxPickMessage => 'Pick a message to read it here';

  @override
  String get inboxFilterAll => 'All';

  @override
  String get panelViewAll => 'View all';

  @override
  String get gridViewOverview => 'Overview';

  @override
  String get gridColCondition => 'Condition';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Rank';

  @override
  String get gridColMove => 'Move';

  @override
  String get gridColNation => 'Nation';

  @override
  String get gridColRegion => 'Region';

  @override
  String get gridColPoints => 'Points';

  @override
  String get panePickNation => 'Pick a nation to see its record here';

  @override
  String get resultsCyclesTitle => 'Cycles';

  @override
  String get tourDrawStart => 'Start the draw';

  @override
  String get tourDrawViewGroups => 'View groups';

  @override
  String get gridColCeiling => 'Ceiling';

  @override
  String get gridColYearGain => 'Gain';

  @override
  String get gridColMarkedAt => 'When marked';

  @override
  String get budgetSetupTitle => 'Set your budget';

  @override
  String get budgetEffectsTitle => 'What this budget buys';

  @override
  String get naturalisationTitle => 'Naturalisation';

  @override
  String get yTrending => 'Trending';

  @override
  String get yVoices => 'Voices';

  @override
  String get yConversation => 'Conversation';

  @override
  String get allTimeRecordsTitle => 'All-time world records';

  @override
  String get h2hMeetingsTitle => 'Every meeting';

  @override
  String get h2hPickOpponent => 'Pick an opponent to see every meeting here';

  @override
  String get savesTitle => 'Saves';

  @override
  String get gridColPlayer => 'Player';

  @override
  String get gridColPos => 'Pos';

  @override
  String get gridColActive => 'Active';

  @override
  String get gridColMotm => 'MOTM';

  @override
  String get gridColAvg => 'Avg';

  @override
  String get gridColOpponent => 'Opponent';

  @override
  String get gridColStarts => 'Starts';

  @override
  String get gridColTournaments => 'Tournaments';

  @override
  String get gridColDate => 'Date';

  @override
  String get gridColLastPlayed => 'Last played';

  @override
  String get gridColManager => 'Manager';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nations',
      one: '1 nation',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Sorted by world rank';

  @override
  String get nationsStrength => 'Strength';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier of 5';
  }

  @override
  String get nationsSquadOverall => 'Squad overall';

  @override
  String get nationsOpeningBudget => 'Opening budget';

  @override
  String get nationsStarPlayer => 'Star player';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Star $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Age $age';
  }

  @override
  String get nationsBoardExpects => 'The board expects';

  @override
  String nationsManage(String nation) {
    return 'Manage $nation';
  }

  @override
  String get nationsManagerNext => 'You name your manager next';

  @override
  String get playerPageTitle => 'Player';

  @override
  String get nationPageTitle => 'Nation';

  @override
  String get friendliesYourGames => 'Your friendlies';
}
