// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get matchPreviewTitle => 'MATCHFÖRHANDSTITT';

  @override
  String get matchKickOff => 'Avspark';

  @override
  String get matchTactics => 'Taktik';

  @override
  String get matchYourXi => 'DIN STARTELVA';

  @override
  String get matchHeadToHead => 'INBÖRDES MÖTEN';

  @override
  String matchCouldNotLoad(String error) {
    return 'Det gick inte att ladda matchen.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Ingen kommande match.';

  @override
  String get matchUnknownNation => 'Okänt';

  @override
  String get matchH2hFirstMeeting => 'Första mötet någonsin';

  @override
  String get matchH2hYouLead => 'Du leder inbördes';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent har övertaget';
  }

  @override
  String get matchH2hEven => 'Jämnt skägg';

  @override
  String matchH2hMet(int count) {
    return '$count möten';
  }

  @override
  String get matchH2hWon => 'Vunna';

  @override
  String get matchH2hDrawn => 'Oavgjorda';

  @override
  String get matchH2hLost => 'Förlorade';

  @override
  String get matchDossierTitle => 'Scoutrapport';

  @override
  String get matchDossierForm => 'FORM';

  @override
  String get matchDossierNoGames => 'Inga senaste matcher';

  @override
  String get matchDossierKeyMen => 'NYCKELSPELARE';

  @override
  String matchCouldNotContinue(String error) {
    return 'Det gick inte att fortsätta: $error';
  }

  @override
  String get matchSkipToFullTime => 'Hoppa till full tid';

  @override
  String get matchStatShots => 'Skott';

  @override
  String get matchStatGoals => 'Mål';

  @override
  String get matchStatYellowCards => 'Gula';

  @override
  String get matchStatRedCards => 'Röda';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'ANF';

  @override
  String get matchSwingDef => 'FÖR';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'VÄRLDSMÄSTERSKAPET $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'SLUTSPELET ÄR HÄR';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'VÄRD  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'VÄRD ÄNNU EJ BEKRÄFTAD';

  @override
  String get matchHalfTime => 'HALVLEK';

  @override
  String get matchContinue => 'Fortsätt';

  @override
  String get matchContinuing => 'Fortsätter…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktik · $used/$max byten';
  }

  @override
  String matchTiredCount(int count) {
    return 'TRÖTTA ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIK';

  @override
  String get teamOverallOverTime => 'HELHETSBETYG ÖVER TID';

  @override
  String get teamOverall => 'Helhetsbetyg';

  @override
  String get teamTalkHeading => 'LAGSAMTAL';

  @override
  String get teamTalkPrompt => 'Sätt tonen inför andra halvlek.';

  @override
  String get teamTalkCalmLabel => 'Lugna huvuden';

  @override
  String get teamTalkCalmBlurb =>
      'Stabilisera laget. En liten lyftning överallt.';

  @override
  String get teamTalkEncourageLabel => 'Uppmuntra';

  @override
  String get teamTalkEncourageBlurb => 'Pressa framåt och gå på matchen.';

  @override
  String get teamTalkDemandMoreLabel => 'Kräv mer';

  @override
  String get teamTalkDemandMoreBlurb => 'Kasta in allt. Attackera hårt.';

  @override
  String get teamTalkPraiseLabel => 'Håll tätt';

  @override
  String get teamTalkPraiseBlurb => 'Stå kompakta och försvara det ni har.';

  @override
  String get teamTalkBelieveLabel => 'Tro på er själva';

  @override
  String get teamTalkBelieveBlurb =>
      'Lita på er själva. En lyftning i båda ändar av planen.';

  @override
  String get teamTalkFocusLabel => 'Var skärpta';

  @override
  String get teamTalkFocusBlurb => 'Total koncentration. Lås matchen.';

  @override
  String get teamTalkUrgencyLabel => 'Känsla av brådska';

  @override
  String get teamTalkUrgencyBlurb =>
      'Jaga nu. Allt eller inget, och det lämnar luckor.';

  @override
  String get teamTalkReassureLabel => 'Ingen press';

  @override
  String get teamTalkReassureBlurb => 'Lugna nerverna och behåll formen.';

  @override
  String get commonRetry => 'Försök igen';

  @override
  String get commonSomethingWentWrong => 'Något gick fel';

  @override
  String get commonCrashBox =>
      'Något gick fel här.\nInställningar → Diagnostik har detaljerna.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Det gick inte att spela vidare i världen: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostik';

  @override
  String get settingsDiagnosticsBlurb =>
      'Fel som registrerats på den här enheten. Inget skickas någonstans.';

  @override
  String get settingsContactTitle => 'Kontakt';

  @override
  String get settingsContactCopied => 'Adressen kopierad.';

  @override
  String get settingsCommunityTitle => 'Community';

  @override
  String get settingsDiscordSubtitle => 'Häng med i communityn';

  @override
  String get settingsLinkCopied => 'Länken har kopierats.';

  @override
  String get diagnosticsEmpty => 'Inga fel registrerade. Så ska det vara.';

  @override
  String get diagnosticsCopy => 'Kopiera';

  @override
  String get diagnosticsCopied => 'Loggen kopierades till urklipp.';

  @override
  String get diagnosticsClear => 'Rensa';

  @override
  String get navHub => 'Startsida';

  @override
  String get navSquad => 'Trupp';

  @override
  String get navStandings => 'Tabeller';

  @override
  String get navCareers => 'Min karriär';

  @override
  String get settingsTitle => 'INSTÄLLNINGAR';

  @override
  String get settingsSoundHapticsTitle => 'Ljud och vibration';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibration och en kort ton vid mål, avspark och full tid.';

  @override
  String get settingsLanguageTitle => 'Språk';

  @override
  String get settingsLanguageBlurb =>
      'Välj appens språk, eller följ din enhet.';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get matchPreviewAllMeetings => 'Alla möten';

  @override
  String get recordsMeetings => 'MÖTEN';

  @override
  String get recordsLegends => 'LEGENDER';

  @override
  String get recordsAllTimeXi => 'TIDERNAS ELVA';

  @override
  String get recordsHallOfFame => 'HALL OF FAME';

  @override
  String get recordsAllTimeWorld => 'VÄRLDEN GENOM TIDERNA';

  @override
  String get recordsAllTimeTopScorers => 'ALLTIDA SKYTTEKUNGAR';

  @override
  String get recordsMostCapped => 'FLEST LANDSKAMPER';

  @override
  String get recordsMostWcStarts => 'FLEST STARTER I VM';

  @override
  String get recordsMostTournaments => 'FLEST TURNERINGAR';

  @override
  String get recordsRecordBook => 'REKORDBOK';

  @override
  String get recordsHeadToHead => 'INBÖRDES MÖTEN';

  @override
  String get recordsFiercestRival => 'VÄRSTA RIVALEN';

  @override
  String get recordsMostCaps => 'FLEST LANDSKAMPER';

  @override
  String get recordsTopScorers => 'SKYTTEKUNGAR';

  @override
  String get recordsMostAssists => 'FLEST ASSIST';

  @override
  String get recordsYourRecord => 'DITT FACIT';

  @override
  String get callUpHome => 'HEMMA';

  @override
  String get callUpAway => 'BORTA';

  @override
  String get recordsHome => 'HEMMA';

  @override
  String get recordsAway => 'BORTA';

  @override
  String get recordsActive => 'AKTIV';

  @override
  String get recordsStillActive => 'Fortfarande aktiv';

  @override
  String get recordsAvg => 'snitt';

  @override
  String get recordsSelect => 'Välj';

  @override
  String get recordsVs => 'mot';

  @override
  String get recordsDraws => 'Oavgjorda';

  @override
  String get recordsGoalsLabel => 'Mål';

  @override
  String get recordsBestFinish => 'Bästa placering';

  @override
  String get recordsNoFinalsYet => 'Inget slutspel ännu';

  @override
  String get recordsLongestUnbeaten => 'Längsta obesegrade svit';

  @override
  String get recordsBiggestWin => 'Största vinst';

  @override
  String get recordsSeeAllMeetings => 'Visa alla möten';

  @override
  String get recordsSaveNotFound => 'Sparfilen hittades inte.';

  @override
  String get recordsNoMatches => 'Inga träffar.';

  @override
  String get recordsSearchPlayerOrNation => 'Sök spelare eller land';

  @override
  String get recordsSearchNation => 'Sök land';

  @override
  String get recordsPickTwoDifferent => 'Välj två olika länder.';

  @override
  String get recordsPlayToBuildRecord =>
      'Spela några matcher så byggs ditt facit mot varje motståndare upp här.';

  @override
  String get recordsTapOpponent =>
      'Tryck på en motståndare för hela sammanställningen.';

  @override
  String get recordsEdgeUpperHand => 'Du har övertaget';

  @override
  String get recordsEdgeTheirNumber => 'De har ditt nummer';

  @override
  String get recordsEdgeEven => 'Jämnt skägg';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Skyttekungar och flest landskamper, alla länder';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Jämför två länders historik genom tiderna';

  @override
  String get recordsLegendsSubtitle => 'Tidernas elva och Hall of Fame';

  @override
  String get recordsUnitGoals => 'mål';

  @override
  String get recordsUnitCaps => 'landskamper';

  @override
  String get recordsUnitStarts => 'starter';

  @override
  String get recordsUnitCups => 'turneringar';

  @override
  String get recordsUnitAssists => 'assist';

  @override
  String recordsCapsCount(int count) {
    return '$count landskamper';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count mål';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count assist';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count × matchens bäste';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count matcher';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count möten';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code vinster';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings möten · ${wins}V ${draws}O ${losses}F';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}V ${draws}O ${losses}F';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings möten · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a och $b har aldrig mötts i den här sparfilen.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names utvisad. Ingen ersättare, så du spelar med en man mindre.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Behöver $required tillgängliga ($have friska)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Missar $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Borta under hela uttagningen';

  @override
  String get rankingCentreOnMe => 'Centrera på mitt land';

  @override
  String get recordsAfterExtraTime => 'e.f.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b str.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a mot $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played spelade · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga mot $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Det gick inte att ladda.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Det gick inte att ladda legenderna.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Det gick inte att ladda rekorden.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Det gick inte att ladda länderna.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Det gick inte att ladda ditt facit.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Det gick inte att ladda rekordet.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Inga legender ännu. Spela ut några kampanjer så dyker de största namnen i $nation upp här.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Det bästa laget $nation någonsin kunnat ställa upp.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Världen har ingen historia ännu. Spela ut några kampanjer så dyker de största genom tiderna upp här.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Spela några matcher för att börja skriva historien för $nation.';
  }

  @override
  String get tacticsLineGk => 'MV';

  @override
  String get tacticsLineDef => 'FÖ';

  @override
  String get tacticsLineMid => 'MF';

  @override
  String get tacticsLineFwd => 'AN';

  @override
  String get tacticsGoalkeepers => 'MÅLVAKTER';

  @override
  String get tacticsDefenders => 'FÖRSVARARE';

  @override
  String get tacticsMidfielders => 'MITTFÄLTARE';

  @override
  String get tacticsForwards => 'ANFALLARE';

  @override
  String get tacticsCallUpsTitle => 'UTTAGNING';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Välj minst $min spelare.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Det gick inte att ladda truppen.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Ingen trupp.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'TRUPP · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Max $max';
  }

  @override
  String get tacticsBestQuality => 'Bästa kvalitet';

  @override
  String get tacticsPreviousSquad => 'Förra truppen';

  @override
  String get tacticsSquadLockedBack => 'Tillbaka (trupp låst)';

  @override
  String get tacticsConfirmSquad => 'Bekräfta trupp';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Truppen är full (max $max)';
  }

  @override
  String get tacticsSquadLocked => 'TRUPPEN ÄR LÅST';

  @override
  String get tacticsNominationOpen => 'UTTAGNINGEN ÄR ÖPPEN. VÄLJ DIN TRUPP';

  @override
  String get tacticsSquadFixedBlurb =>
      'Den här truppen är fast för matcherna nedan. Gör ett nytt val före nästa uttagning.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Den här truppen spelar matcherna nedan.';

  @override
  String get tacticsUnknown => 'Okänt';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Ålder $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Utpumpad';

  @override
  String get tacticsFatigueTired => 'Trött';

  @override
  String get tacticsFatigueMatchLegs => 'Matchben';

  @override
  String tacticsTooManySubs(int max) {
    return 'För många byten (max $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIK · $minute\'';
  }

  @override
  String get tacticsApply => 'TILLÄMPA';

  @override
  String get tacticsTabLineupSubs => 'LAG OCH BYTEN';

  @override
  String get tacticsTabTactics => 'TAKTIK';

  @override
  String get squadLineKeepers => 'MÅLVAKTER';

  @override
  String get squadLineDefenders => 'FÖRSVAR';

  @override
  String get squadLineMidfielders => 'MITTFÄLT';

  @override
  String get squadLineForwards => 'ANFALL';

  @override
  String get squadStatXiRating => 'Elvans betyg';

  @override
  String get squadStatAvgAge => 'Snittålder';

  @override
  String get squadStatSize => 'Trupp';

  @override
  String get squadStatUnavailable => 'Borta';

  @override
  String get squadDepthTitle => 'DJUP PER LINJE';

  @override
  String squadAgeShort(int age) {
    return '$age år';
  }

  @override
  String get tacticsTabOtherPositions => 'ANDRA POSITIONER';

  @override
  String get tacticsOutOfPositionNote => 'Utanför position här';

  @override
  String get tacticsNobodyElse => 'Ingen annan att prova här.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Välj vem som går av så visas resten av bänken här, med betyget de skulle ha på den här positionen.';

  @override
  String get tacticsTabSuitable => 'LÄMPLIGA';

  @override
  String get tacticsTabOnPitch => 'PÅ PLAN';

  @override
  String tacticsSectionSuitable(int count) {
    return 'LÄMPLIGA · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Ingen på bänken passar naturligt på den här positionen, så här är alla.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'PÅ PLAN · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'TILLGÄNGLIGA · $count';
  }

  @override
  String get tacticsRowStarted => 'Startade';

  @override
  String tacticsRowCameOn(int minute) {
    return 'In på $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Bytt in';

  @override
  String get tacticsEnergyLabel => 'ENERGI';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Tryck på en ersättare för $name, eller tryck på spelaren igen för att avbryta.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Ett rött kort kostade dig den här platsen. Dra en lagkamrat hit för att flytta luckan.';

  @override
  String get tacticsSentOffShort => 'UTVISAD';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'BYTEN · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Tryck på en spelare på planen för att ta av honom, eller håll och dra en avbytare till honom.';

  @override
  String get tacticsNoSubs => 'Inga avbytare tillgängliga.';

  @override
  String get tacticsChooseShape => 'VÄLJ FORMATION';

  @override
  String get tacticsFormation => 'FORMATION';

  @override
  String get tacticsInstructions => 'INSTRUKTIONER';

  @override
  String get tacticsDrilling => 'INSPELNING';

  @override
  String get tacticsDrillingUnplayed => 'OSPELAD';

  @override
  String get tacticsDrillingNew => 'NY';

  @override
  String get tacticsDrillingSettling => 'SÄTTER SIG';

  @override
  String get tacticsDrillingDrilled => 'INSPELAD';

  @override
  String get tacticsInstrMentality => 'Mentalitet';

  @override
  String get tacticsInstrDefensive => 'Defensiv';

  @override
  String get tacticsInstrAttacking => 'Offensiv';

  @override
  String get tacticsInstrPressing => 'Press';

  @override
  String get tacticsInstrLowBlock => 'Lågt block';

  @override
  String get tacticsInstrHighPress => 'Hög press';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Tålmodigt';

  @override
  String get tacticsInstrFast => 'Snabbt';

  @override
  String get tacticsInstrWidth => 'Bredd';

  @override
  String get tacticsInstrNarrow => 'Smalt';

  @override
  String get tacticsInstrWide => 'Brett';

  @override
  String get tacticsInstrDefLine => 'Backlinje';

  @override
  String get tacticsInstrDefensiveLine => 'Backlinje';

  @override
  String get tacticsInstrDeep => 'Djup';

  @override
  String get tacticsInstrHigh => 'Hög';

  @override
  String get tacticsInstrDirectness => 'Direkthet';

  @override
  String get tacticsInstrPossession => 'Bollinnehav';

  @override
  String get tacticsInstrDirect => 'Direkt';

  @override
  String get tacticsPickGoalkeeper => 'VÄLJ MÅLVAKT';

  @override
  String get tacticsPickLeftBack => 'VÄLJ VÄNSTERBACK';

  @override
  String get tacticsPickCentreBack => 'VÄLJ MITTBACK';

  @override
  String get tacticsPickRightBack => 'VÄLJ HÖGERBACK';

  @override
  String get tacticsPickDefensiveMid => 'VÄLJ DEFENSIV MITTFÄLTARE';

  @override
  String get tacticsPickCentralMid => 'VÄLJ CENTRAL MF';

  @override
  String get tacticsPickAttackingMid => 'VÄLJ OFFENSIV MITTFÄLTARE';

  @override
  String get tacticsPickLeftMid => 'VÄLJ VÄNSTER MF';

  @override
  String get tacticsPickRightMid => 'VÄLJ HÖGER MF';

  @override
  String get tacticsPickLeftWing => 'VÄLJ VÄNSTERYTTER';

  @override
  String get tacticsPickRightWing => 'VÄLJ HÖGERYTTER';

  @override
  String get tacticsPickStriker => 'VÄLJ ANFALLARE';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · utanför position';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Ålder $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Ålder $age';
  }

  @override
  String get tacticsOn => 'PÅ';

  @override
  String get tacticsSquad => 'TRUPP';

  @override
  String get tacticsTabLineup => 'UPPSTÄLLNING';

  @override
  String get tacticsTabInstructions => 'INSTRUKTIONER';

  @override
  String get tacticsTabRoles => 'ROLLER';

  @override
  String get tacticsTabSetPieces => 'FASTA SITUATIONER';

  @override
  String get tacticsTabRolesSetPieces => 'ROLLER & FASTA';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Ge varje startspelare en roll. Tryck på straff- (⚽) eller frisparksmärket (▲) för att utse din utförare.';

  @override
  String get tacticsTooltipCallUps => 'Uttagning';

  @override
  String get tacticsTooltipPresets => 'Taktikmallar';

  @override
  String get tacticsTooltipInstructions => 'Instruktioner';

  @override
  String get tacticsNoTacticSet => 'Ingen taktik vald.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ERSÄTT $count STARTSPELARE',
      one: 'ERSÄTT $count STARTSPELARE',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Borta';

  @override
  String get tacticsTapSpotReplace =>
      'Tryck på platsen på planen för att välja en ersättare.';

  @override
  String get tacticsTapOrDrag =>
      'Tryck på en spelare för att byta ut honom, eller håll och dra för att flytta honom.';

  @override
  String get tacticsPlayerRoles => 'SPELARROLLER';

  @override
  String get tacticsRolesBlurb =>
      'Ge en spelare ett uppdrag: en målpoängare, en speluppläggare, en målspelare. Styr vem som gör mål och vem som skapar.';

  @override
  String get tacticsSetPieceTakers => 'UTFÖRARE';

  @override
  String get tacticsSetPieceBlurb =>
      'Vem som slår straffar och fasta situationer, eller låt den bäst lämpade göra det.';

  @override
  String get tacticsTakerAuto => 'Automatiskt';

  @override
  String get tacticsTakerQuickPick => 'Använd bästa utförarna';

  @override
  String get tacticsPenalties => 'Straffar';

  @override
  String get tacticsCornersFreeKicks => 'Hörnor och frisparkar';

  @override
  String get tacticsSkillFin => 'AVS';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROLL · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'STRAFFSKYTT';

  @override
  String get tacticsCornerFreeKickTaker => 'HÖRN- OCH FRISPARKSSKYTT';

  @override
  String get tacticsAutomatic => 'Automatiskt';

  @override
  String get tacticsLetBestSuited => 'Låt den bäst lämpade spelaren slå den.';

  @override
  String get tacticsInXi => 'I ELVAN';

  @override
  String get tacticsTeamInstructions => 'LAGINSTRUKTIONER';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Bestäm hur ditt lag spelar. Varje reglage påverkar hela laget.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Sparade “$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Tillämpade “$name”';
  }

  @override
  String get tacticsTacticPresets => 'TAKTIKMALLAR';

  @override
  String get tacticsPresetsBlurb =>
      'Spara den här formationen som en återanvändbar stil, eller tillämpa en du sparat tidigare.';

  @override
  String get tacticsSaveCurrentTactic => 'Spara nuvarande taktik';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Det gick inte att ladda mallarna.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Inga mallar ännu. Tryck på “Spara nuvarande taktik” för att spara upplägget som en återanvändbar stil.';

  @override
  String get tacticsNameThisTactic => 'Namnge taktiken';

  @override
  String get tacticsNameHint => 't.ex. Hög press 4-3-3';

  @override
  String get tacticsCancel => 'Avbryt';

  @override
  String get tacticsSave => 'Spara';

  @override
  String get tacticsTapToAssign => 'Tryck för att tilldela';

  @override
  String get tacticsHoldDragSub =>
      'Håll en avbytare och dra honom till en spelare för att byta in honom.';

  @override
  String get hubContinue => 'Fortsätt';

  @override
  String get hubBrackets => 'Turneringsträd';

  @override
  String hubCouldNotLoad(String error) {
    return 'Det gick inte att ladda.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Det gick inte att ladda ekonomin.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Det gick inte att ladda sparfilen.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Sparfilen hittades inte.';

  @override
  String get hubUnknown => 'Okänt';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year VÄRLDSMÄSTARE';
  }

  @override
  String get hubCycleComplete => 'Cykeln är avslutad.';

  @override
  String get hubYourJob => 'DITT UPPDRAG';

  @override
  String get hubStayProject => 'Stanna och fortsätt ditt projekt';

  @override
  String get hubChooseNextJob => 'VÄLJ DITT NÄSTA UPPDRAG';

  @override
  String get hubOffersOnTable => 'ERBJUDANDEN PÅ BORDET';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · plats $position i världen';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Fortsätt med $nation';
  }

  @override
  String get hubYourNation => 'ditt land';

  @override
  String get hubTakeTheJob => 'Ta jobbet';

  @override
  String get hubFederationFinances => 'FÖRBUNDETS EKONOMI';

  @override
  String get hubBudgetIntro =>
      'Ditt första uppdrag nästa cykel är att fastställa förbundsbudgeten och fördela den mellan avdelningarna.';

  @override
  String get hubStarting => 'Startar…';

  @override
  String get hubBeginNextCycle => 'Starta nästa cykel';

  @override
  String get hubContinueCareer => 'Fortsätt din karriär';

  @override
  String get hubBackToSaves => 'Tillbaka till dina sparfiler';

  @override
  String get hubOpeningBalance => 'Ingående saldo';

  @override
  String get hubCentralFunding => 'Centralt stöd';

  @override
  String get hubPrizeMoney => 'Prispengar';

  @override
  String get hubCommercialReturn => 'Kommersiell avkastning';

  @override
  String get hubAvailableToInvest => 'Tillgängligt att investera';

  @override
  String hubReputation(String label, int rep) {
    return 'Rykte: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Nationalhjälte';

  @override
  String get hubFinal => 'Final';

  @override
  String get hubStageRoundOf32 => 'Sextondelsfinal';

  @override
  String get hubStageThirdPlace => 'Bronsmatch';

  @override
  String get hubEventAdvanceWorld => 'Spela vidare i världen';

  @override
  String hubEventStartCycle(int year) {
    return 'Starta cykeln $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation är världsmästare';
  }

  @override
  String get hubEventSetBudget => 'Fastställ förbundsbudgeten';

  @override
  String get hubEventSetBudgetSub =>
      'Fördela cykelns krigskassa innan säsongen börjar';

  @override
  String get hubEventNaturalization => 'Granska naturaliseringserbjudande';

  @override
  String get hubEventNaturalizationSub =>
      'En utländsk spelare vill byta landslag till dig';

  @override
  String get hubEventCampaignVerdict => 'Kampanjen avgjord: se utlåtandet';

  @override
  String get hubEventCampaignComplete => 'Kampanjen slutförd';

  @override
  String get hubEventIntercontinentalPlayoff =>
      'Det interkontinentala play-offet';

  @override
  String get hubEventWatchWcDraw => 'Se lottningen till Världsmästerskapet';

  @override
  String get hubEventWorldCupHere => 'Världsmästerskapet är här';

  @override
  String get hubEventWatchFinalsDraw => 'Se lottningen till slutspelet';

  @override
  String get hubEventFinalsHere => 'Slutspelet är här';

  @override
  String get hubEventPlayWcRound => 'Spela nästa omgång i Världsmästerskapet';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Spela nästa match i $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch => 'Spela nästa match i Nations Cup';

  @override
  String get hubEventWatchNationsCupDraw => 'Se lottningen till Nations Cup';

  @override
  String get hubEventWatchHostSelection => 'Se värdvalet';

  @override
  String get hubEventWatchQualifyingDraw => 'Se kvallottningen';

  @override
  String get hubEventWatchWcHostSelection =>
      'Se värdvalet för Världsmästerskapet';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Se kvallottningen till Världsmästerskapet';

  @override
  String get hubEventArrangeFriendlies => 'Boka träningsmatcher';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du har inte fyllt dina $count lediga träningsmatchfönster än',
      one: 'Du har inte fyllt ditt lediga träningsmatchfönster än',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Forma om din startelva';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count i din startelva är borta (avstängda eller skadade). Välj ersättare',
      one:
          '1 i din startelva är borta (avstängd eller skadad). Välj en ersättare',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Din startelva är ofullständig. Fyll de lediga platserna',
      one: 'Din startelva är ofullständig. Fyll den lediga platsen',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Spela mot $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'kontinentalt slutspel';

  @override
  String get hubCallUpFriendlies => 'Ta ut truppen till träningsmatcherna';

  @override
  String get hubCallUpRequalify => 'Ta ut kvaltruppen på nytt';

  @override
  String get hubCallUpWorldCup => 'Ta ut din trupp till Världsmästerskapet';

  @override
  String get hubCallUpFinals => 'Ta ut truppen till slutspelet';

  @override
  String get hubCallUpNationsCup => 'Ta ut din trupp till Nations Cup';

  @override
  String get hubCallUpQualifying => 'Ta ut din kvaltrupp';

  @override
  String get hubCallUpGeneric => 'Ta ut din trupp';

  @override
  String get hubHost => 'Värd';

  @override
  String get hubGoldenBoot => 'Gyllene skon';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals mål';
  }

  @override
  String get hubPens => '(str.)';

  @override
  String get hubNationalHub => 'FÖRBUNDSKANSLIET';

  @override
  String get hubMessages => 'Meddelanden';

  @override
  String get hubWorldChampions => 'VÄRLDSMÄSTARE';

  @override
  String get hubViewBracket => 'Visa turneringsträd ›';

  @override
  String get hubBoardDelighted => 'Överlycklig';

  @override
  String get hubBoardPleased => 'Nöjd';

  @override
  String get hubBoardExpectingMore => 'Förväntar sig mer';

  @override
  String get hubBoardConcerned => 'Orolig';

  @override
  String get hubBoardJobAtRisk => 'Jobbet i fara';

  @override
  String get hubBoard => 'STYRELSE';

  @override
  String hubBoardObjective(String label) {
    return 'Styrelsens mål: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'UPPNÅTT · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'MISSAT · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Inga fler matcher den här cykeln.';

  @override
  String get hubVs => 'MOT';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Världsranking';

  @override
  String get hubSquadStatus => 'TRUPPSTATUS';

  @override
  String hubPlayers(int count) {
    return '$count spelare';
  }

  @override
  String get hubAvgRating => 'Snittbetyg';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Hantera laget';

  @override
  String get hubGroupsToBeDrawn =>
      'Grupperna ska lottas. Se lottningen för att avslöja dem.';

  @override
  String hubGroupName(String name) {
    return 'GRUPP $name';
  }

  @override
  String get hubTblTeam => 'LAG';

  @override
  String get hubTblP => 'S';

  @override
  String get hubTblGd => '+/-';

  @override
  String get hubTblPts => 'P';

  @override
  String get homeSettings => 'Inställningar';

  @override
  String get homeLeadTheNation => 'LED NATIONEN';

  @override
  String get homeYourNation => 'ditt land';

  @override
  String get homeNewGame => 'Nytt spel';

  @override
  String get homeAllSaves => 'Alla sparfiler';

  @override
  String get homeLoadGame => 'Ladda spel';

  @override
  String get homeContinue => 'FORTSÄTT';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Vägen till Världsmästerskapet $year';
  }

  @override
  String get careerManageSaves => 'Hantera sparfiler';

  @override
  String get careerNewGameTitle => 'NYTT SPEL';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Det gick inte att ladda landet.\n$error';
  }

  @override
  String get careerNationNotFound => 'Landet hittades inte.';

  @override
  String careerWorldRankNum(int rank) {
    return 'VÄRLDSRANKING #$rank';
  }

  @override
  String get careerManagerName => 'Förbundskaptenens namn';

  @override
  String get careerManagerNameHint => 't.ex. Sven-Göran Eriksson';

  @override
  String get careerBeginsBlurb =>
      'Din karriär börjar i september 2026, på vägen mot Världsmästerskapet 2030.';

  @override
  String get careerFreeCycleNote =>
      'Gratis i en hel fyraårscykel: kval, ditt kontinentala mästerskap och Världsmästerskapet, på två sparfiler. Därefter låser en enda betalning upp ändlösa cykler.';

  @override
  String get careerStartCareer => 'Starta karriären';

  @override
  String get careersTitle => 'KARRIÄRER';

  @override
  String get careerManagerCareer => 'Förbundskaptenskarriär';

  @override
  String get careerManagerCareerSubtitle =>
      'Varje cykel du lett och ditt samlade facit';

  @override
  String get careerSummaryTitle => 'Karriärsammanfattning';

  @override
  String get careerSummarySubtitle =>
      'Ditt troféskåp och ditt facit som förbundskapten';

  @override
  String get careerAchievements => 'Prestationer';

  @override
  String get careerAchievementsSubtitle =>
      'Milstolpar, titlar och styrelsens nöjdhet';

  @override
  String get careerChallenges => 'Utmaningar';

  @override
  String get careerChallengesSubtitle =>
      'Brutala prov som varar hela karriären';

  @override
  String get careerTeamRecords => 'Lagrekord';

  @override
  String get careerTeamRecordsSubtitle =>
      'Genom tiderna: flest mål och landskamper';

  @override
  String get careerMyMatches => 'Mina matcher';

  @override
  String get careerMyMatchesSubtitle => 'Varje resultat och kommande match';

  @override
  String get careerTitle => 'KARRIÄR';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Det gick inte att läsa in karriären.\n$error';
  }

  @override
  String get careerNoCareer => 'Ingen karriär.';

  @override
  String get careerTrophyCabinet => 'TROFÉSKÅP';

  @override
  String get careerTournamentHistory => 'TURNERINGSHISTORIK';

  @override
  String get careerNoTournamentsYet => 'Inga turneringar avslutade ännu.';

  @override
  String get careerTeamFallback => 'Lag';

  @override
  String careerWorldNum(int rank) {
    return 'VÄRLDEN #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points P';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SÄSONG $season';
  }

  @override
  String get careerStatPlayedShort => 'S';

  @override
  String get careerStatsHeading => 'I SIFFROR';

  @override
  String get careerStatsWinRate => 'Vinstandel';

  @override
  String get careerStatsGoalsFor => 'Gjorda mål';

  @override
  String get careerStatsGoalsAgainst => 'Insläppta mål';

  @override
  String get careerStatsGoalDiff => 'Målskillnad';

  @override
  String get careerStatsCleanSheets => 'Hållna nollor';

  @override
  String get careerStatsBiggestWin => 'Största vinst';

  @override
  String get careerStatsWinStreak => 'Vinstsvit';

  @override
  String get careerStatsUnbeaten => 'Obesegrad svit';

  @override
  String get careerStatsShootouts => 'Straffläggningar';

  @override
  String get careerStatsHatTricks => 'Hattricks';

  @override
  String get careerStatsMotms => 'Matchens bäste';

  @override
  String get careerStatsBestRating => 'Bästa betyg';

  @override
  String get careerStatWonShort => 'V';

  @override
  String get careerStatDrawnShort => 'O';

  @override
  String get careerStatLostShort => 'F';

  @override
  String get careerStatGoalsForShort => 'GM';

  @override
  String get careerStatGoalsAgainstShort => 'IM';

  @override
  String get careerStatGoalDiffShort => '+/-';

  @override
  String get careerNoSilverware => 'Inga pokaler ännu. Gå och vinn en.';

  @override
  String get careerMedalGold => 'GULD';

  @override
  String get careerMedalSilver => 'SILVER';

  @override
  String get careerMedalBronze => 'BRONS';

  @override
  String careerWinnersName(String name) {
    return 'Vinnare: $name';
  }

  @override
  String get careerSavesTitle => 'SPARFILER';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Det gick inte att läsa in sparfilerna.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'PLATSER  $used/$limit';
  }

  @override
  String get careerThisSave => 'denna sparfil';

  @override
  String get careerSlotsFull => 'Platserna är fulla';

  @override
  String careerSlotsUsed(int used) {
    return 'PLATSER  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Lås upp fler sparfiler';

  @override
  String get careerSlotsKeepNote =>
      'Alla sparfiler du redan har går att spela vidare. Bara en ny kräver upplåsning.';

  @override
  String get careerNewGame => 'Nytt spel';

  @override
  String get careerDeleteSaveTitle => 'Ta bort sparfilen?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Detta tar bort din karriär $label för alltid.';
  }

  @override
  String get careerCancel => 'Avbryt';

  @override
  String get careerDelete => 'Ta bort';

  @override
  String get careerNoSavesYet =>
      'Inga sparfiler ännu.\nStarta ett nytt spel för att leda ett land.';

  @override
  String get careerUnknownNation => 'Okänt';

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
    return 'Senast spelad $when';
  }

  @override
  String get careerJustNow => 'just nu';

  @override
  String get careerYesterday => 'igår';

  @override
  String careerMinutesAgo(int n) {
    return '$n min sedan';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n h sedan';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n d sedan';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Vägen mot Världsmästerskapet $year';
  }

  @override
  String get careerManagerCareerTitle => 'FÖRBUNDSKAPTENSKARRIÄR';

  @override
  String careerCouldNotLoad(String error) {
    return 'Det gick inte att läsa in.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CYKEL FÖR CYKEL';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cykler',
      one: '1 cykel',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations länder lett',
      one: '1 land lett',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Titlar';

  @override
  String get careerStatPlayed => 'Spelade';

  @override
  String get careerStatWon => 'Vunna';

  @override
  String get careerStatDrawn => 'Oavgjorda';

  @override
  String get careerStatLost => 'Förlorade';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Mål $goalsFor–$goalsAgainst  ($gd)  ·  Vinstandel $winRate%';
  }

  @override
  String get careerRecordResults => 'REKORDRESULTAT';

  @override
  String get careerBestWin => 'Bästa vinst';

  @override
  String get careerWorstDefeat => 'Värsta förlust';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'mot $opponent · $date';
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
    return '${won}V ${drawn}O ${lost}F  ·  GM $goalsFor IM $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Världsmästerskapet';

  @override
  String get careerContinentalLabel => 'Kontinental';

  @override
  String get messagesTitle => 'MEDDELANDEN';

  @override
  String get messagesNoMessagesYet => 'Inga meddelanden ännu.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Det gick inte att läsa in meddelandena.\n$error';
  }

  @override
  String get messagesDone => 'Klart';

  @override
  String get messagesNext => 'Nästa';

  @override
  String get rankingWorldRanking => 'VÄRLDSRANKING';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Det gick inte att läsa in rankingen.\n$error';
  }

  @override
  String get rankingNoRanking => 'Ingen ranking.';

  @override
  String get rankingAll => 'ALLA';

  @override
  String get rankingYourTeam => 'DITT LAG';

  @override
  String get rankingYourRankingOverTime => 'DIN RANKING ÖVER TID';

  @override
  String rankingNowRank(int rank) {
    return 'nu #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'bäst #$best · sämst #$worst';
  }

  @override
  String get friendliesTitle => 'TRÄNINGSMATCHER';

  @override
  String friendliesLoadError(String error) {
    return 'Det gick inte att läsa in träningsmatcherna.\n$error';
  }

  @override
  String get friendliesContinue => 'Fortsätt';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lediga fönster',
      one: '1 ledigt fönster',
    );
    return 'Boka träningsmatcher för $_temp0 före din nästa tävlingsmatch. Tryck på en motståndare, eller lämna det fritt.';
  }

  @override
  String get friendliesFree => 'Fritt';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count MÅL',
      one: '1 MÅL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'MÅL';

  @override
  String get matchGoalsNone => 'Inga mål';

  @override
  String get matchGoalPenalty => 'STR';

  @override
  String get matchGoalSetPiece => 'FAS';

  @override
  String matchGoalAssist(String name) {
    return 'assist $name';
  }

  @override
  String get friendliesHome => 'HEMMA';

  @override
  String get friendliesAway => 'BORTA';

  @override
  String get friendliesNoneThisWindow => 'Inga träningsmatcher i detta fönster';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count träningsmatcher',
      one: '1 träningsmatch',
    );
    return 'Bekräfta $_temp0';
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
  String get friendliesMonthMay => 'Maj';

  @override
  String get friendliesMonthJun => 'Jun';

  @override
  String get friendliesMonthJul => 'Jul';

  @override
  String get friendliesMonthAug => 'Aug';

  @override
  String get friendliesMonthSep => 'Sep';

  @override
  String get friendliesMonthOct => 'Okt';

  @override
  String get friendliesMonthNov => 'Nov';

  @override
  String get friendliesMonthDec => 'Dec';

  @override
  String get resultsMyMatches => 'MINA MATCHER';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Det gick inte att läsa in resultaten.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Inga matcher.';

  @override
  String get resultsVs => 'mot';

  @override
  String get resultsStageQualifier => 'KVALMATCH';

  @override
  String get resultsStageFriendly => 'TRÄNINGSMATCH';

  @override
  String get resultsStageGroupStage => 'GRUPPSPEL';

  @override
  String get resultsStageSemiFinal => 'SEMIFINAL';

  @override
  String get resultsStageFinal => 'FINAL';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'SLUTSPELSGRUPP';

  @override
  String get resultsStageRoundOf32 => 'SEXTONDELSFINAL';

  @override
  String get resultsStageRoundOf16 => 'ÅTTONDELSFINAL';

  @override
  String get resultsStageQuarterFinal => 'KVARTSFINAL';

  @override
  String get resultsStageThirdPlace => 'BRONSMATCH';

  @override
  String get matchSetupWarnCaptain =>
      'Ingen lagkapten utsedd. Tryck för att ge någon kaptensbindeln';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name är skadad och kan inte leda laget ut. Tryck för att lämna över bindeln';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name är avstängd i denna match. Tryck för att lämna över bindeln';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name har bindeln men finns inte i din trupp. Tryck för att lämna över den';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Inga som tar fasta situationer utsedda. Tryck för att välja vem som kliver fram';

  @override
  String get matchSetupWarnBoth =>
      'Ingen lagkapten och ingen som tar fasta situationer. Tryck för att välja';

  @override
  String matchStageMatchday(int matchday) {
    return 'OMG $matchday';
  }

  @override
  String get squadCaptain => 'Lagkapten';

  @override
  String deptEffectYouth(int points) {
    return 'Akademitalanger kommer ungefär $points i helhetsbetyg bättre';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount tillbaka vid cykelns slut';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% färre skador';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% chans att en utländsk spelare ber om att få byta';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points styrelsetålamod innan ditt jobb hotas';
  }

  @override
  String get deptEffectNone => 'Ingen effekt utan finansiering';

  @override
  String get statsBestRated => 'Betyg';

  @override
  String get statsMyCareer => 'Karriär';

  @override
  String get statsBestAverageRating => 'BÄSTA SNITTBETYG';

  @override
  String get statsMyCareerRecord => 'DITT FACIT';

  @override
  String get statsNoRatingsRecorded => 'Inga matchbetyg registrerade ännu.';

  @override
  String get statsGroupRecord => 'Facit';

  @override
  String get statsGroupRuns => 'Sviter';

  @override
  String get statsGroupExtremes => 'Ytterligheter';

  @override
  String get statsGroupSplits => 'Hemma och borta';

  @override
  String get statsGroupSquad => 'Dina spelare';

  @override
  String get statsPlayed => 'Spelade matcher';

  @override
  String get statsWinDrawLoss => 'Vunna–oavgjorda–förlorade';

  @override
  String get statsWinRate => 'Vinstandel';

  @override
  String get statsGoals => 'Mål gjorda:insläppta';

  @override
  String get statsCleanSheets => 'Hållna nollor';

  @override
  String get statsFailedToScore => 'Utan eget mål';

  @override
  String get statsLongestWinStreak => 'Längsta vinstsvit';

  @override
  String get statsLongestUnbeaten => 'Längsta obesegrade svit';

  @override
  String get statsLongestCleanSheets => 'Längsta svit utan insläppt mål';

  @override
  String get statsLongestWinless => 'Längsta svit utan vinst';

  @override
  String get statsCurrentRun => 'Nuvarande obesegrade svit';

  @override
  String get statsBiggestWin => 'Största vinst';

  @override
  String get statsHeaviestDefeat => 'Tyngsta förlust';

  @override
  String get statsMostGoalsInAGame => 'Flest mål i en match';

  @override
  String get statsShootouts => 'Straffläggningar vunna–förlorade';

  @override
  String get statsComebackWins => 'Vändningsvinster';

  @override
  String get statsHome => 'Hemma';

  @override
  String get statsAway => 'Borta';

  @override
  String get statsNeutral => 'Neutral plan';

  @override
  String get statsCompetitive => 'Tävling';

  @override
  String get statsFriendlies => 'Träningsmatcher';

  @override
  String get statsHatTricks => 'Hattricks';

  @override
  String get statsBraces => 'Dubbla mål';

  @override
  String get statsMotms => 'Utmärkelser som matchens bäste spelare';

  @override
  String get statsAssists => 'Assist';

  @override
  String get statsCards => 'Kort';

  @override
  String get statsBestRating => 'Bästa individuella betyg';

  @override
  String statsAppsShort(int apps) {
    return '$apps matcher';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MOTM';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent => 'Lagkapten. Tryck för att ta bort bindeln';

  @override
  String get captainFitBorn => 'En född ledare';

  @override
  String get captainFitNatural => 'En naturlig lagkapten';

  @override
  String get captainFitCapable => 'Kan bära den';

  @override
  String get captainFitUnproven => 'Ingen ledare ännu';

  @override
  String get captainNone => 'Ingen lagkapten utsedd';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale truppmoral';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'VM-kval';

  @override
  String get resultsCategoryFriendlies => 'Träningsmatcher';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Kontinental cup';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'VM-kval';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Kont.cup-kval';

  @override
  String get resultsCategoryContinentalQualifying => 'Kontinental cup, kval';

  @override
  String get resultsCategoryWorldCupFinals => 'VM-slutspel';

  @override
  String get resultsRoundResults => 'OMGÅNGENS RESULTAT';

  @override
  String get resultsFriendlyInternationals => 'TRÄNINGSLANDSKAMPER';

  @override
  String get resultsKnockout => 'Utslagsspel';

  @override
  String resultsEarlierMatches(int count) {
    return 'Tidigare matcher ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'OMGÅNG $matchday';
  }

  @override
  String get resultsContinue => 'Fortsätt';

  @override
  String resultsGroup(String name) {
    return 'GRUPP $name';
  }

  @override
  String get achievementsScreenTitle => 'PRESTATIONER';

  @override
  String get achievementsChallengesTooltip => 'Utmaningar';

  @override
  String get achievementsChallengesHeading => 'UTMANINGAR';

  @override
  String get achievementsBrutalTests => 'Brutala prov som varar hela karriären';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Det gick inte att läsa in.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total upplåsta';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total avklarade';
  }

  @override
  String get achievementsBoardSatisfaction => 'STYRELSENS NÖJDHET';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PRESTATIONER UPPLÅSTA',
      one: 'PRESTATION UPPLÅST',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Vinster';

  @override
  String get achCatMatches => 'Matcher';

  @override
  String get achCatQualifications => 'Kvalificeringar';

  @override
  String get achCatTitles => 'Titlar';

  @override
  String get achCatMisc => 'Övrigt';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Mål';

  @override
  String get achCatStreaks => 'Sviter';

  @override
  String get achTierBronze => 'Brons';

  @override
  String get achTierSilver => 'Silver';

  @override
  String get achTierGold => 'Guld';

  @override
  String get achTierPlatinum => 'Platina';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mål',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gör $count mål.',
      one: 'Gör 1 mål.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hållna nollor',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Håll $count nollor.',
      one: 'Håll 1 nolla.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Vinnarvana';

  @override
  String get achStreakWin5Desc => 'Vinn fem matcher i rad.';

  @override
  String get achStreakWin10 => 'Rullar på';

  @override
  String get achStreakWin10Desc => 'Vinn tio matcher i rad.';

  @override
  String get achStreakWin20 => 'Ångvält';

  @override
  String get achStreakWin20Desc => 'Vinn tjugo matcher i rad.';

  @override
  String get achUnbeaten15 => 'Svårslagna';

  @override
  String get achUnbeaten15Desc => 'Spela femton matcher utan förlust.';

  @override
  String get achUnbeaten30 => 'Oberörbara';

  @override
  String get achUnbeaten30Desc => 'Spela trettio matcher utan förlust.';

  @override
  String get achHattrick => 'Hattrickhjälte';

  @override
  String get achHattrickDesc => 'Låt en spelare göra ett hattrick.';

  @override
  String get achMotm10 => 'Utstickare';

  @override
  String get achMotm10Desc =>
      'Samla 10 utmärkelser som matchens bäste spelare.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc =>
      'Samla 50 utmärkelser som matchens bäste spelare.';

  @override
  String get achPerfect => 'Perfekt tia';

  @override
  String get achPerfectDesc => 'Låt en spelare få 9,5+ i matchbetyg.';

  @override
  String get achShootout => 'Is i ådrorna';

  @override
  String get achShootoutDesc => 'Vinn fem straffläggningar.';

  @override
  String get achMassacre => 'Massaker';

  @override
  String get achMassacreDesc => 'Vinn en match med 7 mål eller mer.';

  @override
  String get achAnnihilation => 'Utplåning';

  @override
  String get achAnnihilationDesc => 'Vinn en match med 10 mål eller mer.';

  @override
  String get chTierBronze => 'Brons';

  @override
  String get chTierSilver => 'Silver';

  @override
  String get chTierGold => 'Guld';

  @override
  String get chTierLegendary => 'Legendarisk';

  @override
  String get chFirstSteps => 'På tränarbänken';

  @override
  String get chFirstStepsDesc => 'Var förbundskapten i 5 år.';

  @override
  String get chUnbeaten10 => 'Rullar på';

  @override
  String get chUnbeaten10Desc => 'Spela 10 tävlingsmatcher utan förlust.';

  @override
  String get chTwoNations => 'Ny utmaning';

  @override
  String get chTwoNationsDesc => 'Led 2 olika länder.';

  @override
  String get chCont1 => 'Kontinentalmästare';

  @override
  String get chCont1Desc => 'Vinn ett kontinentalt mästerskap.';

  @override
  String get chNc1 => 'Nations Cup-vinnare';

  @override
  String get chNc1Desc => 'Vinn Nations Cup.';

  @override
  String get chWc1 => 'Världsmästare';

  @override
  String get chWc1Desc => 'Vinn Världsmästerskapet.';

  @override
  String get chYears25 => 'Etablissemanget';

  @override
  String get chYears25Desc => 'Var förbundskapten i 25 år.';

  @override
  String get chWc3 => 'Seriesegrare';

  @override
  String get chWc3Desc => 'Vinn Världsmästerskapet 3 gånger.';

  @override
  String get chWc5 => 'Dynasti';

  @override
  String get chWc5Desc => 'Vinn Världsmästerskapet 5 gånger.';

  @override
  String get chWc10 => 'Odödlig';

  @override
  String get chWc10Desc => 'Vinn Världsmästerskapet 10 gånger.';

  @override
  String get chWc2Teams => 'Redo att resa';

  @override
  String get chWc2TeamsDesc => 'Vinn Världsmästerskapet med 2 olika länder.';

  @override
  String get chWc3Teams => 'Globetrotter';

  @override
  String get chWc3TeamsDesc => 'Vinn Världsmästerskapet med 3 olika länder.';

  @override
  String get chWcStreak3 => 'Tre i rad';

  @override
  String get chWcStreak3Desc => 'Vinn Världsmästerskapet 3 gånger i rad.';

  @override
  String get chWcAllconf => 'Världserövrare';

  @override
  String get chWcAllconfDesc =>
      'Vinn Världsmästerskapet med ett land från varje kontinentalt förbund (6).';

  @override
  String get chCont5 => 'Kontinentens kung';

  @override
  String get chCont5Desc => 'Vinn 5 kontinentala mästerskap.';

  @override
  String get chContAll => 'Sex kontinenter';

  @override
  String get chContAllDesc =>
      'Vinn kontinentalmästerskapet i alla sex kontinentala förbund (6).';

  @override
  String get chTreble => 'Svep';

  @override
  String get chTrebleDesc =>
      'Vinn Världsmästerskapet, en kontinental titel och Nations Cup under en och samma karriär.';

  @override
  String get chNations10 => 'Nomad';

  @override
  String get chNations10Desc => 'Led 10 olika länder.';

  @override
  String get chYears100 => 'Sekelskifte';

  @override
  String get chYears100Desc => 'Var förbundskapten i 100 år.';

  @override
  String get chYears500 => 'Ett halvt årtusende';

  @override
  String get chYears500Desc => 'Var förbundskapten i 500 år.';

  @override
  String get chYears1000 => 'Evig';

  @override
  String get chYears1000Desc => 'Var förbundskapten i 1000 år.';

  @override
  String get chGrandmaster => 'Stormästare';

  @override
  String get chGrandmasterDesc =>
      'Vinn Världsmästerskapet 3 gånger OCH 5 kontinentala mästerskap.';

  @override
  String get chUndefeated => 'Oberörbar';

  @override
  String get chUndefeatedDesc =>
      'Vinn ett världsmästerskap utan att förlora en enda match.';

  @override
  String get chPerfectQual => 'Felfri väg';

  @override
  String get chPerfectQualDesc => 'Vinn varje match i ett VM-kval.';

  @override
  String get chMinnow => 'Småfiskens under';

  @override
  String get chMinnowDesc =>
      'Vinn Världsmästerskapet med ett land utanför världens 32 bästa.';

  @override
  String get chGrandTour => 'Hemma och borta';

  @override
  String get chGrandTourDesc =>
      'Vinn ett världsmästerskap som värd och ett på bortaplan.';

  @override
  String get chUnbeaten25 => 'Muren';

  @override
  String get chUnbeaten25Desc => 'Spela 25 tävlingsmatcher utan förlust.';

  @override
  String get chGoals10k => 'Målmaskin';

  @override
  String get chGoals10kDesc => 'Gör 10 000 mål under karriären.';

  @override
  String get chCleanSheets500 => 'Fästning';

  @override
  String get chCleanSheets500Desc => 'Håll 500 nollor under karriären.';

  @override
  String get chHatTricks25 => 'Hattrickvana';

  @override
  String get chHatTricks25Desc => 'Låt dina spelare göra 25 hattricks.';

  @override
  String get chWinStreak25 => 'Skoningslös';

  @override
  String get chWinStreak25Desc => 'Vinn 25 matcher i rad.';

  @override
  String get chCont10 => 'Kontinental dynasti';

  @override
  String get chCont10Desc => 'Vinn 10 kontinentala mästerskap.';

  @override
  String get chPcWc => 'Seriemästare';

  @override
  String chPcWcDesc(int count) {
    return 'Vinn $count världsmästerskap i denna sparfil.';
  }

  @override
  String get chPcMajors => 'Pokalsamlare';

  @override
  String chPcMajorsDesc(int count) {
    return 'Vinn $count stora troféer (Världsmästerskapet, kontinentalt mästerskap eller Nations Cup).';
  }

  @override
  String get chPcUnbeaten => 'Järnmuren';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Spela $count tävlingsmatcher utan förlust.';
  }

  @override
  String get chPcNations => 'Gesäll';

  @override
  String chPcNationsDesc(int count) {
    return 'Led $count olika länder.';
  }

  @override
  String get chPcYears => 'Långa loppet';

  @override
  String chPcYearsDesc(int count) {
    return 'Var förbundskapten i $count år.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vinster',
      one: '1 vinst',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vinn $count matcher.',
      one: 'Vinn 1 match.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matcher',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spela $count matcher.',
      one: 'Spela 1 match.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'VM-kvalificerade';

  @override
  String get achQualWcDesc => 'Kvalificera dig för Världsmästerskapet.';

  @override
  String get achQualCont => 'Kontinentalt kvalificerade';

  @override
  String get achQualContDesc =>
      'Kvalificera dig för ditt kontinentala mästerskap.';

  @override
  String get achTitleWc => 'Världsmästare';

  @override
  String get achTitleWcDesc => 'Vinn Världsmästerskapet.';

  @override
  String get achTitleEuro => 'Europamästare';

  @override
  String get achTitleEuroDesc => 'Vinn Europamästerskapet.';

  @override
  String get achTitleCopa => 'Sydamerikamästare';

  @override
  String get achTitleCopaDesc => 'Vinn Sydamerikacupen.';

  @override
  String get achTitleAfcon => 'Afrikamästare';

  @override
  String get achTitleAfconDesc => 'Vinn Afrikamästerskapet.';

  @override
  String get achTitleAsia => 'Asienmästare';

  @override
  String get achTitleAsiaDesc => 'Vinn Asienmästerskapet.';

  @override
  String get achTitleConcacaf => 'Nordamerikamästare';

  @override
  String get achTitleConcacafDesc => 'Vinn Nordamerikanska Nations Cup.';

  @override
  String get achTitleOfc => 'Oceanienmästare';

  @override
  String get achTitleOfcDesc => 'Vinn Oceaniencupen.';

  @override
  String get achTitleNations => 'Nations Cup-vinnare';

  @override
  String get achTitleNationsDesc => 'Vinn Nations Cup.';

  @override
  String get achTitleClash => 'Continental Clash-vinnare';

  @override
  String get achTitleClashDesc => 'Vinn Continental Clash.';

  @override
  String get achMarksman => 'VM-skytt';

  @override
  String get achMarksmanDesc =>
      'Låt en spelare i truppen göra 6+ mål i VM-slutspelet.';

  @override
  String get achSweep => 'Svep';

  @override
  String get achSweepDesc =>
      'Håll både Världsmästerskapet och din kontinentala titel under en och samma karriär.';

  @override
  String get achAllstar => 'Turneringens stjärna';

  @override
  String get achAllstarDesc =>
      'Få en spelare utsedd till Turneringens lag i ett världsmästerskap.';

  @override
  String get achGoldenboot => 'Gyllene skon';

  @override
  String get achGoldenbootDesc =>
      'Låt ditt land sluta som mästerskapets bästa målskytt.';

  @override
  String get achDemolition => 'Rivning';

  @override
  String get achDemolitionDesc => 'Vinn en match med 5 mål eller mer.';

  @override
  String get achievementsNice => 'Snyggt!';

  @override
  String get achievementsHardestTests =>
      'De hårdaste proven för en förbundskapten, genom en hel karriär och många länder.';

  @override
  String get achievementsThisSave => 'DENNA SPARFIL';

  @override
  String get achievementsBrutalBadge => 'BRUTAL';

  @override
  String get paywallGoPro => 'KÖR UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Engångsupplåsning. Ingen prenumeration.';

  @override
  String get paywallBenefitCarryOn =>
      'Den här sparfilen fortsätter precis där den slutade, med varje landskamp, rekord och rivalitet intakta.';

  @override
  String get paywallBenefitNoAds =>
      'Inga annonser, inga mikrotransaktioner, ingen prenumeration. En betalning, och varje framtida uppdatering är din.';

  @override
  String get paywallBenefitSaves =>
      'Så många sparfiler du vill. Led en favorit och en småfisk samtidigt, och se hur olika samma spel kan kännas.';

  @override
  String get paywallBenefitEndless =>
      'Varje cykel framöver. Välj en sjuttonåring idag och få veta år 2034 om du såg rätt.';

  @override
  String get paywallUnlocked => 'Unlimited är upplåst. Njut!';

  @override
  String get paywallContactingStore => 'Kontaktar butiken…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Lås upp Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Återställ köp';

  @override
  String get paywallStoreUnavailable => 'Butiken är inte tillgänglig';

  @override
  String get paywallStoreUnavailableNote =>
      'Priset kunde inte läsas in. Kontrollera anslutningen och försök igen.';

  @override
  String get paywallTryAgain => 'Försök igen';

  @override
  String get gateTitle => 'DIN FÖRSTA CYKEL ÄR SLUT';

  @override
  String get gateLead =>
      'Fyra år är en cykel. Det räcker inte för att ta reda på om du hade rätt.';

  @override
  String get gatePriceLead => 'En betalning, för alltid';

  @override
  String get gateBuy => 'KÖP OCH FORTSÄTT';

  @override
  String get gateExit => 'AVSLUTA';

  @override
  String get federationNaturalisation => 'NATURALISERING';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name naturaliserad';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name har slutfört bytet och kan nu spela för $nation. Ta ut spelaren i din trupputtagning.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Det gick inte att läsa in erbjudandet.\n$error';
  }

  @override
  String get federationContinue => 'Fortsätt';

  @override
  String get federationOfferToSwitchAllegiance =>
      'ETT ERBJUDANDE OM ATT BYTA LANDSLAG';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age år · från $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name har band till $playerNation och är villig att bli naturaliserad. Tacka ja så går spelaren att ta ut; tacka nej så stannar spelaren hos $sourceNation.';
  }

  @override
  String get federationDecline => 'Tacka nej';

  @override
  String get federationNaturalise => 'Naturalisera';

  @override
  String get federationBudgetLater => 'Bestäm senare';

  @override
  String get federationSetYourBudget => 'SÄTT DIN BUDGET';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Det gick inte att läsa in ekonomin.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Sparfilen hittades inte.';

  @override
  String get federationBudgetHeading => 'FÖRBUNDSBUDGET';

  @override
  String federationDistributeBudget(String amount) {
    return 'Fördela $amount på avdelningarna för att öppna cykeln. Använd pengarna klokt.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount mer än förbundet har. Ta tillbaka något';
  }

  @override
  String get federationAllocateFullBudget =>
      'Fördela hela budgeten för att starta cykeln.';

  @override
  String get federationConfirming => 'Bekräftar…';

  @override
  String get federationConfirmBudget => 'Bekräfta budget';

  @override
  String get federationFinances => 'EKONOMI';

  @override
  String get federationInvestmentUpdated => 'Investeringen uppdaterad.';

  @override
  String get federationDevelopment => 'FÖRBUNDETS UTVECKLING';

  @override
  String get federationProjectedAtSeasonEnd => 'PROGNOS VID SÄSONGSSLUT';

  @override
  String get federationCentralFunding => 'Centralt anslag';

  @override
  String get federationPrizeMoneySoFar => 'Prispengar hittills';

  @override
  String get federationCommercialReturn => 'Kommersiell avkastning';

  @override
  String get federationThisSeasonLocked => 'DENNA SÄSONG (LÅST)';

  @override
  String get federationInvestForNextSeason => 'INVESTERA FÖR NÄSTA SÄSONG';

  @override
  String get federationNextSeasonImpact => 'EFFEKT NÄSTA SÄSONG';

  @override
  String get federationSaving => 'Sparar…';

  @override
  String get federationConfirmInvestment => 'Bekräfta investering';

  @override
  String get federationBalance => 'FÖRBUNDETS SALDO';

  @override
  String get federationCommittedToStaff => 'Bundet till staben';

  @override
  String get federationFreeToSpend => 'Fritt att spendera';

  @override
  String get federationWagesNote =>
      'Lönerna dras från saldot vid cykelns slut, så den här summan är redan intecknad.';

  @override
  String get federationInvestAtCeremony =>
      'Investera för nästa säsong vid ceremonin i cykelns slut.';

  @override
  String federationLevelBadge(int level) {
    return 'N$level';
  }

  @override
  String get federationAcademyProspects => 'Akademitalanger';

  @override
  String federationPlusOverall(int value) {
    return '+$value helhetsbetyg';
  }

  @override
  String get federationInjuryRisk => 'Skaderisk';

  @override
  String get federationNaturalisationChance => 'Chans till naturalisering';

  @override
  String get federationBoardPatience => 'Styrelsens tålamod';

  @override
  String get federationUnallocated => 'OFÖRDELAT';

  @override
  String get nationsVitrineTitle => 'NATIONELL VITRIN';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Det gick inte att läsa in landet.\n$error';
  }

  @override
  String get nationsNoNation => 'Inget land.';

  @override
  String get nationsHonours => 'PRIS OCH TITLAR';

  @override
  String get nationsRankingHistory => 'VÄRLDSRANKINGHISTORIK';

  @override
  String get nationsTopScorers => 'MÅLSKYTTAR GENOM TIDERNA';

  @override
  String get nationsTitles => 'TITLAR';

  @override
  String get nationsYourTeam => 'DITT LAG';

  @override
  String get nationsWorld => 'VÄRLDEN';

  @override
  String get nationsWorldCup => 'Världsmästerskapet';

  @override
  String get nationsContinental => 'Kontinentalt';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deltaganden',
      one: '1 deltagande',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Ännu inte tillräckligt med historik. Kom tillbaka om en cykel eller två.';

  @override
  String nationsBestRank(int rank) {
    return 'Bäst: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Nu: #$rank';
  }

  @override
  String get nationsNoGoals => 'Inga mål registrerade ännu.';

  @override
  String get nationsGoalsAbbrev => 'mål';

  @override
  String get nationsHosts => 'VÄRD';

  @override
  String get nationsSelectTitle => 'VÄLJ LANDSLAG';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Det gick inte att läsa in länderna.\n$error';
  }

  @override
  String get nationsNoMatch => 'Inga länder matchar.';

  @override
  String get nationsNationalLevel => 'NATIONELL NIVÅ';

  @override
  String get nationsSelectHeading => 'Välj landslag';

  @override
  String get nationsSearchHint => 'Sök land…';

  @override
  String get nationsRank => 'PLATS ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'VÄLJ';

  @override
  String get statsTeamRecords => 'LAGREKORD';

  @override
  String get statsRecordBook => 'Rekordbok';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Det gick inte att läsa in statistiken.\n$error';
  }

  @override
  String get statsNoData => 'Inga data.';

  @override
  String get statsTopScorers => 'MÅLSKYTTAR';

  @override
  String get statsMostGamesPlayed => 'FLEST SPELADE MATCHER';

  @override
  String get statsTeam => 'Lag';

  @override
  String get statsTopScorersShort => 'Skyttar';

  @override
  String get statsMostGames => 'Flest matcher';

  @override
  String get statsNoGoalsRecorded => 'Inga mål registrerade ännu.';

  @override
  String get statsUnknown => 'Okänd';

  @override
  String get playerTitle => 'SPELARE';

  @override
  String playerLoadError(String error) {
    return 'Det gick inte att läsa in spelaren.\n$error';
  }

  @override
  String get playerNotFound => 'Spelaren hittades inte.';

  @override
  String get playerClub => 'KLUBB';

  @override
  String get playerClubRole => 'I sin klubb';

  @override
  String get playerPosition => 'Position';

  @override
  String get playerPotential => 'Potential';

  @override
  String get playerAge => 'Ålder';

  @override
  String get playerValue => 'Värde';

  @override
  String get clubFirstChoice => 'Spelar varje vecka';

  @override
  String get clubRotation => 'In och ut ur laget';

  @override
  String get clubFringe => 'Spelar knappt';

  @override
  String get clubFrozenOut => 'Spelar inte';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Jag har följt fotboll i trettio år och såg inte det där komma. $opponent besegrade $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Ingen gav dem en chans mot $opponent. $score. Absolut ingen.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score mot $opponent. Gå och väck grannarna.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Det där är en sådan kväll man berättar om för barnbarnen. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score mot $opponent. Hur det än gick till, så hände det.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'På pappret var det här avgjort innan det började. $opponent $score säger något annat.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Vann $score mot $opponent. Ingen kommer att tro på den siffran om ett år.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Njut av det, och titta sedan på spelschemat.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score mot $opponent, och vi hade tur i åttio av de nittio minuterna.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'En kväll mot $opponent ställer inte till rätta ett helt år. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Vann $score mot $opponent och nu får vi höra att vi har vänt trenden. Det har vi inte.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Underbart. Fråga mig igen när det gäller på riktigt.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Vann $score mot $opponent. Precis som det ska vara, och det finns en njutning i det.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score över $opponent. Skoningslöst, och skoningslöst är en komplimang.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Inget krångel, ingen oro, inget att klaga på.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'En stabil seger, $score, mot $opponent. Så ser ett bra lag ut en lugn dag.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score mot $opponent. Jobbet gjort, inget lärt.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Vann $score mot $opponent. Vi skulle det, och vi gjorde det.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'En proffsig seger, $score, över $opponent. Nästa.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent avfärdade med $score. Lägg det till handlingarna och gå vidare.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score mot $opponent och vi ska tydligen applådera. För att vi slog dem.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Bra jobbat av alla inblandade i $score-segern över $opponent, antar jag.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Att slå sådana lag är minimikravet, inte en prestation.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Vi slog $opponent med $score och såg tungrodda ut hela vägen.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score mot $opponent och varenda minut var förtjänad.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Det krävde karaktär. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Vann $score mot $opponent den hårda vägen, som är den som håller.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score mot $opponent. Lagen som vinner sådana här matcher står kvar i juni.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nervöst, fult och en seger. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Vann $score mot $opponent. Ta de tre poängen och se aldrig matchen igen.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent fick oss att slita för varje centimeter.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Inte snyggt. Räknas lika.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score mot $opponent och vi gjorde det tio gånger svårare än det var.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Vi ska inte behöva hänga på mot $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Vann, och fick inte veta något bra om oss själva.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'En seger, $score, mot $opponent som smickrade oss.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'En poäng mot $opponent, $score. Ta den och gå vidare.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score mot $opponent. Det finns sämre eftermiddagar än den här.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Höll $opponent till $score. Allt behöver inte bli en historia.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. En poäng är en poäng och tabellen frågar inte hur.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score mot $opponent. Två poäng tappade eller en vunnen. Välj humör.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Oavgjort mot $opponent, $score. Ingen är glad, ingen är rasande.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Årets mest bortglömda nittio minuter.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Delade poängen med $opponent, $score. Vi går vidare.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score mot $opponent. Såna här oavgjorda är hur kampanjer tyst dör.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Två poäng bortslängda mot $opponent. $score. Det finns inget annat att kalla det.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Vi hade nittio minuter och ingen aning om vad vi skulle göra med dem.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Ett $score mot $opponent som ingen kommer ihåg och alla kommer att få betala för.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Förlorade $score mot $opponent. Sånt händer.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Inget att hänga någon för. Vidare till nästa.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Förlust, $score, mot $opponent trots att vi gav allt. Vissa dagar räcker det inte.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score mot $opponent. Upp med huvudet. Det här laget har mycket kvar.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Vi var näst bäst och det finns inget att argumentera om.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Förlorade $score mot $opponent. Samla ihop er.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score mot $opponent. Ingen skam, men inte bra nog.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Förlorade $score mot $opponent. Lär er något av det, annars var det förgäves.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score mot $opponent och vi nådde dem inte ens.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Förlust mot $opponent, $score. Samma problem, samma månad, samma ursäkter på väg.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. När slutar det här vara otur?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Förlorade $score mot $opponent. Ett resultat som borde kosta någon något.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score mot $opponent. En dålig kväll. Döm laget efter hela kampanjen, inte efter det här.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Ingen ville ha den där förlusten, $score, mot $opponent mindre än spelarna själva.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Fult, och inte så det här laget är.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'En förlust, $score, mot $opponent att glömma. De kommer att ta sig i kragen nästa gång.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Mot $opponent. Jag har inga ord och jag får betalt för att ha ord.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Någon måste stå till svars för det där.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Jag vill ha $score-förlusten mot $opponent struken ur protokollet och ur minnet.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Förlorade $score mot $opponent. Det går inte att spinna en sådan siffra.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Det där var ingen förlust mot $opponent, det var en kapitulation. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Mot $opponent. Folk betalade pengar för att se det där.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Om inte det här ändrar något, gör ingenting det.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Jag har sett det här laget förnedras förut, men $score mot $opponent är en ny bottennotering.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'MÄSTARE. $opponent. Säg det högt.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Vi vann det. $opponent. Jag mår inte bra.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, och pokalen kommer hem.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Varenda en av dem en legend. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Så nära. $opponent och en medalj ingen vill ha.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Tvåa i $opponent. Det kommer att svida i åratal.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: en match från allt.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Tvåa. I $opponent. Skicka över flaskan.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Utslagna i $opponent. Det där kommer att göra ont ett tag.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent är där det tar slut för oss.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Utslagna i $opponent. Nu börjar uppgörelsen.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Utslagna i $opponent. Någon får förklara det där för mig.';
  }

  @override
  String yQualified0(String opponent) {
    return 'VI ÅKER TILL $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Kvalificerade för $opponent. Ta ledigt från jobbet.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, nu kommer vi. Aldrig i fara (det var helt och hållet i fara).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Vidare till $opponent. Det svåra är klart.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Grupperna lottade för $opponent. Kunde varit värre. Kunde varit mycket värre.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Så det blev den lottningen i $opponent. Intressant.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Grupperna för $opponent är klara och jag gillar redan inte vår.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Lottningen till $opponent är gjord. Låt överreaktionerna börja.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent arrangerar det. Börja spara.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Det går till $opponent. Väntat, men okej.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent får turneringen. Grattis till dem, antar jag.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Värdar bekräftade: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent börjar snart och jag kan inte sitta still.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Inte långt kvar till $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent är nästan här. Dags för truppen, tack.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Nedräkningen till $opponent är officiellt outhärdlig.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Inget att säga ännu. Spela en match.';

  @override
  String get yEarlierHeading => 'Tidigare i cykeln';

  @override
  String get yTraitLoyalist =>
      'Står bakom laget vad som än händer. Långsam att vända, snabb att förlåta.';

  @override
  String get yTraitCynic =>
      'Utgår från det värsta och blir överlycklig när det visar sig stämma.';

  @override
  String get yTraitNostalgic =>
      'Allt var bättre förr. Mäter dig mot män som slutat.';

  @override
  String get yTraitStatshead =>
      'Postar siffror och inget annat. Har knappt något humör.';

  @override
  String get yTraitHypeman =>
      'Två bra resultat och det är en gyllene generation.';

  @override
  String get yTraitContrarian => 'Vad rummet än tycker, tvärtom.';

  @override
  String get yTraitDoomer =>
      'Det kommer att gå fel. Det kommer alltid att gå fel.';

  @override
  String get yProfilePosts => 'INLÄGG';

  @override
  String get yProfileEmpty => 'Inget från det här kontot ännu.';

  @override
  String hubEventGrievance(String player) {
    return '$player vill växla ett ord';
  }

  @override
  String get hubEventGrievanceSub => 'Han vill veta var han står';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count färdighetspoäng att använda',
      one: '1 färdighetspoäng att använda',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub => 'Det du är bra på gör ditt lag bättre';

  @override
  String get grievanceTitle => 'Ett ord på ditt kontor';

  @override
  String grievanceGameTime(String player) {
    return '$player har varit med i truppen utan att ha rört en boll. Han vill veta varför.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player är inte med i truppen och förstår det inte. Han vill ha besked, åt det ena eller andra hållet.';
  }

  @override
  String grievanceRole(String player) {
    return '$player spelas hela tiden på fel position och har fått nog.';
  }

  @override
  String get grievanceReassure => 'Du finns i mina planer';

  @override
  String get grievanceHonest => 'Du ligger bakom andra, och här är varför';

  @override
  String get grievanceDismiss => 'Jag bestämmer laget';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name gjorde $goals av dem. Ingen annan är i närheten.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals för $name. Han bär det här laget.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals på dagen. Vilken spelare.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$name satte $goals på dem. Bocka och buga.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals för $name, och resten var passagerare.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '$name igen. $goals. Tänk dig det här laget utan honom.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals av $name. En man borde inte behöva göra så här mycket.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Ta bort $name och det blir $goals färre och en helt annan eftermiddag.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count i rad. Vad som än sägs i det omklädningsrummet, så går det fram.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Det är $count raka. Lag snubblar inte in i sviter som den här.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count i rad och det fortsätter. Självförtroendet syns från läktaren.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Obesegrade på $count. Fråga vem som helst som varit tränare: det är det svåra.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count i rad. Njut av det medan spelschemat är snällt.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count raka, och vi har inte slagit någon av betydelse.';
  }

  @override
  String yWinStreak6(String count) {
    return 'En svit på $count. Fråga mig igen när den testas.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count på raken. Varje lag har en sådan här i sig någon gång.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count matcher utan vinst nu. Någon gång tar ursäkterna slut.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Det är $count i rad borta. Det här är inte en tillfällighet längre.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count raka förluster. Någon måste stå till svars.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Ingen vinst på $count. Man ser det på hur de spelar.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count utan vinst och samma misstag varje vecka.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count i rad. Vad som än prövas, så fungerar det inte.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count raka. Det här är en riktning, inte en svacka.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Ingen vinst på $count, och ingen däruppe har sagt ett ord.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Säg vad ni vill om fotbollen. Den här räknas dubbelt.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Mot $opponent, av alla. $score. Ingen här kommer att glömma det.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score mot $opponent. Det är den de kommer att prata om på pubarna.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Mot grannen, $score. Skryträtten avgjord för ett tag.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Vad som än händer i år, så finns det här.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score mot $opponent. Vissa av oss behövde det mer än tabellen gjorde.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Och de tar tillbaka det nästa gång, det gör de alltid.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Mot $opponent, $score. Ett helt år av påminnelser om den här.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name utbytt skadad. Det var det sista det här laget behövde.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Att förlora $name ändrar formen på allting.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name haltar. Håll andan.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Ingen $name på ett tag, alltså. Någon måste kliva fram.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name ute. Givetvis är det $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Utan $name blir det här ett mycket vanligt lag.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name skadad igen. Någon borde fråga varför.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Förlorade $name, och det finns ingen bakom honom. Det är det verkliga problemet.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Rött kort för $name i minut $minute och hela landet vänder sig mot honom. Han har gett oss mer än de flesta. Låt det vara.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name utvisad efter $minute minuter. Hårt. Tio man och vi gav oss på det ändå, vilket säger något.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, minut $minute, rött kort. Tio man därifrån.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Utvisning: $name i minut $minute. Inte den första matchen som vänds av ett enda beslut.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Strålande. $name går i minut $minute och vi är nere i tio. Igen.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name utvisad efter $minute minuter. Vem är det egentligen som tränar disciplin här?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minuter. Så länge kunde $name behålla huvudet. Professionell fotboll.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Rött för $name i minut $minute, och jag ska tro att det här är framsteg.';
  }

  @override
  String get yBoardPressure0 =>
      'Styrelsen har blivit väldigt tyst. Det är aldrig ett bra tecken.';

  @override
  String get yBoardPressure1 =>
      'Det sägs att styrelserummet har börjat ställa frågor.';

  @override
  String get yBoardPressure2 => 'Man känner hur marken rör sig däruppe.';

  @override
  String get yBoardPressure3 =>
      'Ingen på förbundet säger något stöttande. Dra dina egna slutsatser.';

  @override
  String get yBoardPressure4 =>
      'Ingen däruppe har backat upp honom offentligt på flera veckor nu.';

  @override
  String get yBoardPressure5 =>
      'Förbundet läcker mot sin egen förbundskapten. Som vanligt.';

  @override
  String get yBoardPressure6 =>
      'När en styrelse blir tyst har de redan bestämt sig.';

  @override
  String get yBoardPressure7 =>
      'De låter det här driva tills det blir någon annans beslut.';

  @override
  String get yReplies => 'OCKSÅ OM DEN HÄR MATCHEN';

  @override
  String get yPlayerGrievance0 =>
      'Frågade var jag står. Väntar fortfarande på svar.';

  @override
  String get yPlayerGrievance1 => 'Tränar hårt. Mer kan jag inte göra.';

  @override
  String get yPlayerGrievance2 => 'Vissa frågor får man bara ställa en gång.';

  @override
  String get yPlayerGrievance3 => 'Jag kom inte hit för att bära västarna.';

  @override
  String get playerHonoursTitle => 'PRIS OCH TITLAR';

  @override
  String get awardGoldenBall => 'Gyllene bollen';

  @override
  String get awardGoldenBoot => 'Gyllene skon';

  @override
  String get awardGoldenGlove => 'Gyllene handsken';

  @override
  String get awardTeamOfTournament => 'Turneringens lag';

  @override
  String get awardPlayerOfYear => 'Årets världsspelare';

  @override
  String get awardYoungPlayerOfYear => 'Årets unga spelare';

  @override
  String get playerClubHistory => 'KLUBBHISTORIK';

  @override
  String get playerCareerRecord => 'KARRIÄRSTATISTIK';

  @override
  String get playerInternationalGoals => 'Landslagsmål';

  @override
  String get playerRecentForm => 'SENASTE FORM';

  @override
  String get playerMatchHistory => 'MATCHHISTORIK';

  @override
  String get playerAttributes => 'EGENSKAPER';

  @override
  String get playerUnknown => 'Okänd';

  @override
  String get playerAttrPace => 'Snabbhet';

  @override
  String get playerAttrPhysical => 'Fysik';

  @override
  String get playerAttrTechnical => 'Teknik';

  @override
  String get playerAttrShooting => 'Skott';

  @override
  String get playerAttrPassing => 'Passning';

  @override
  String get playerAttrDribbling => 'Dribbling';

  @override
  String get playerAttrTackling => 'Tackling';

  @override
  String get playerAttrPositioning => 'Positionering';

  @override
  String get playerAttrComposure => 'Lugn';

  @override
  String get playerAttrDecisions => 'Beslut';

  @override
  String get playerAttrStamina => 'Uthållighet';

  @override
  String get playerAttrStrength => 'Styrka';

  @override
  String get playerStatCaps => 'Landskamper';

  @override
  String get playerStatGoals => 'Mål';

  @override
  String get playerStatAssists => 'Assist';

  @override
  String get playerStatAvgRating => 'Snittbetyg';

  @override
  String get playerStatForm => 'Form';

  @override
  String get playerStatMotm => 'Matchens bäste';

  @override
  String get playerStatCleanSheets => 'Hållna nollor';

  @override
  String get playerStatBestGame => 'Bästa match';

  @override
  String get playerStatCards => 'Kort';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}G ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'DIN VÄG';

  @override
  String get tourSharedList => 'Lista';

  @override
  String get tourSharedBracket => 'Träd';

  @override
  String get tourSharedVs => 'mot';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Grupp $seed';
  }

  @override
  String get tourSharedThisEdition => 'Denna upplaga';

  @override
  String get tourSharedAllTime => 'Genom tiderna';

  @override
  String get tourSharedUnknown => 'Okänd';

  @override
  String get tourSharedActive => 'AKTIV';

  @override
  String get tourSharedMedalTable => 'MEDALJTABELL';

  @override
  String get tourSharedPastWinners => 'TIDIGARE VINNARE';

  @override
  String tourSharedHost(String host) {
    return 'Värd: $host';
  }

  @override
  String get tourSharedBeat => 'slog';

  @override
  String get tourSharedPens => ' (straffar)';

  @override
  String get tourSharedAwardsEmpty =>
      'Utmärkelserna avgörs när turneringen är färdigspelad.';

  @override
  String get tourSharedGoldenBall => 'GYLLENE BOLLEN';

  @override
  String get tourSharedPlayerOfTournament => 'Turneringens spelare';

  @override
  String get tourSharedGoldenBoot => 'GYLLENE SKON';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mål',
      one: '1 mål',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'GYLLENE HANDSKEN';

  @override
  String get tourSharedTeamOfTournament => 'TURNERINGENS LAG';

  @override
  String get tourSharedStatsEmpty =>
      'Rekord dyker upp när tävlingen har fått lite historia.';

  @override
  String get tourSharedRecordScorer => 'REKORDSKYTT';

  @override
  String get tourSharedStillActive => 'fortfarande aktiv';

  @override
  String get tourSharedMostTitles => 'FLEST TITLAR';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titlar',
      one: '1 titel',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'FLEST FINALER';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelade finaler',
      one: '1 spelad final',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'FLEST SPELADE MATCHER';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matcher',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'FLEST SLUTSPEL SPELADE';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slutspel',
      one: '1 slutspel',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'STÖRSTA FINALSEGER';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mål',
      one: '1 mål',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'fortfarande aktiv';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titlar',
      one: '1 titel',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelade finaler',
      one: '1 spelad final',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matcher',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slutspel',
      one: '1 slutspel',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'LEDARE GENOM TIDERNA';

  @override
  String get tourStatsTabGames => 'Matcher';

  @override
  String get tourStatsTabCups => 'Cuper';

  @override
  String get tourStatsTabScorers => 'Skyttar';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'mot $opponent · $year';
  }

  @override
  String get tourHolders => 'TITELFÖRSVARARE';

  @override
  String tourHoldersSince(int year) {
    return 'vann $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'MÅLSKYTTAR GENOM TIDERNA';

  @override
  String get tourSharedSummaryEmpty =>
      'Värden och dess arenor visas när den här upplagan har lottats.';

  @override
  String get tourSharedHostHeading => 'VÄRD';

  @override
  String get tourSharedHostsHeading => 'VÄRDAR';

  @override
  String get tourSharedCoHostsHeading => 'GEMENSAMMA VÄRDAR';

  @override
  String get tourSharedVenues => 'ARENOR';

  @override
  String get tourSharedMascot => 'MASKOT';

  @override
  String get tourSharedMatchBall => 'MATCHBOLL';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity platser';
  }

  @override
  String get tourSharedCouldNotLoad => 'Det gick inte att läsa in.';

  @override
  String get tourSharedHostTbc => 'VÄRD MEDDELAS SENARE';

  @override
  String get tourSharedFinalsAreHere => 'SLUTSPELET ÄR HÄR';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ARRANGERAS AV  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Låt slutspelet börja';

  @override
  String get tourSharedCompetitions => 'TÄVLINGAR';

  @override
  String get tourSharedWorldRanking => 'Världsranking';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Det gick inte att läsa in turneringarna.';

  @override
  String get tourSharedPrestigeStage => 'PRESTIGESCEN';

  @override
  String get tourSharedOverview => 'Översikt';

  @override
  String get tourSharedWorldRankingTitle => 'Världsranking';

  @override
  String get tourSharedYourCompetitions => 'DINA TÄVLINGAR';

  @override
  String get tourSharedOtherContinents => 'ANDRA KONTINENTER';

  @override
  String get tourSharedComingSoon => 'Turneringen kommer snart';

  @override
  String get tourSharedSoon => 'SNART';

  @override
  String get tourSharedNoQualifyingDraw => 'Ingen kvallottning.';

  @override
  String get tourSharedOpenEnvelope => 'Öppna kuvertet';

  @override
  String tourSharedGroupName(String name) {
    return 'GRUPP $name';
  }

  @override
  String get tourSharedBall => 'Boll';

  @override
  String get tourSharedPot => 'Pott';

  @override
  String get tourSharedAll => 'Alla';

  @override
  String get tourSharedTapDrawTeam => 'Tryck för att lotta nästa lag';

  @override
  String get tourSharedTapDrawPot => 'Tryck för att lotta nästa pott';

  @override
  String get tourSharedTapDrawAll => 'Tryck för att visa hela lottningen';

  @override
  String get tourSharedContinue => 'Fortsätt';

  @override
  String get tourSharedPause => 'Paus';

  @override
  String get tourSharedPlay => 'Spela';

  @override
  String get tourSharedSkip => 'Hoppa över';

  @override
  String tourSharedPotNumber(int number) {
    return 'POTT $number';
  }

  @override
  String get tourSharedDrawComplete => 'LOTTNING KLAR';

  @override
  String get tourSharedDrawing => 'LOTTAR…';

  @override
  String get tourContChampionship => 'MÄSTERSKAP';

  @override
  String get tourContTabSummary => 'SAMMANFATTNING';

  @override
  String get tourContTabQualifying => 'KVAL';

  @override
  String get tourContTabFinals => 'SLUTSPEL';

  @override
  String get tourContTabBracket => 'TRÄD';

  @override
  String get tourContTabAwards => 'PRISER';

  @override
  String get tourContTabScorers => 'SKYTTAR';

  @override
  String get tourContTabHistory => 'HISTORIA';

  @override
  String get tourContTabRecords => 'REKORD';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Det gick inte att läsa in cupen.\n$error';
  }

  @override
  String get tourContNoCupData => 'Inga cupdata.';

  @override
  String get tourContUnknown => 'Okänd';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Kvalgrupperna lottas vid ceremonin. Titta från startsidan för att se vilka du möter.';

  @override
  String get tourContQualSeeded =>
      'Ditt land är seedat direkt till slutspelet. Inget kval den här cykeln.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name simuleras i bakgrunden. Resultaten dyker upp här när varje omgång spelas.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Slutspelsgrupperna lottas vid ceremonin. Titta från startsidan för att se din grupp.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Slutspelslottningen sker när kvalet är klart.';

  @override
  String get tourContContestedBeforeWc =>
      'Utslagsomgångarna spelas före Världsmästerskapet.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name MÄSTARE';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Vinnare av $name';
  }

  @override
  String get tourContNoGoalsYet => 'Inga mål gjorda ännu.';

  @override
  String tourContGroupHeading(String name) {
    return 'GRUPP $name';
  }

  @override
  String get tourContBestRunnersUp => 'BÄSTA GRUPPTVÅOR';

  @override
  String tourContGroupDropdown(String name) {
    return 'Grupp $name';
  }

  @override
  String get tourContMatches => 'MATCHER';

  @override
  String get tourContNoGroupsDrawn => 'Inga grupper lottade ännu.';

  @override
  String get tourContQualifyingDraw => 'KVALLOTTNING';

  @override
  String get tourContWorldQualifyingDraw => 'VM-KVALLOTTNING';

  @override
  String get tourContFinalsDraw => 'SLUTSPELSLOTTNING';

  @override
  String get tourContSeedingPots => 'SEEDNINGSPOTTAR';

  @override
  String get tourContGroupDraw => 'GRUPPLOTTNING';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Det gick inte att läsa in lottningen.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Lottningen är inte klar ännu.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'DENNA CYKEL';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Det gick inte att läsa in.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Sparfilen hittades inte.';

  @override
  String get tourContClashSoon =>
      'Continental Clash spelas när båda kontinentala mästarna är klara.';

  @override
  String get tourContTwoContinentsOneMatch => 'TVÅ KONTINENTER, EN MATCH';

  @override
  String get tourContVersusShort => 'mot';

  @override
  String tourContWinTheClash(String name) {
    return '$name vinner Clash';
  }

  @override
  String get tourContNoClashYet => 'Ingen Continental Clash har spelats än.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'DIVISIONER';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Det gick inte att ladda.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Inga mål i Nations Cup har registrerats än.';

  @override
  String get tourContNoNationsCupChampions =>
      'Inga mästare i Nations Cup har korats än.';

  @override
  String get tourContNationsCupOffSeason =>
      'Den här cykelns Nations Cup börjar efter de kontinentala slutspelen. Tidigare vinnare finns under Historia.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Den här cykelns Nations Cup-grupper lottas vid ceremonin. Se den från startsidan för att få veta vilka du möter.';

  @override
  String get tourContLeagueNoGroups =>
      'Inga matcher i den här divisionen den här omgången.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'DIVISION $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'DIVISION $letter · DIN DIVISION';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Final Four spelas av A-divisionens gruppvinnare när gruppspelet är klart.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Division $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Division $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEMIFINALER';

  @override
  String get tourContFinal => 'FINAL';

  @override
  String get tourContNationsCupDraw => 'LOTTNING AV NATIONS CUP';

  @override
  String get tourContIntercontinentalPlayoff => 'INTERKONTINENTAL PLAY-OFF';

  @override
  String get tourContNoPlayoffThisCycle => 'Ingen play-off den här cykeln.';

  @override
  String get tourContPlayoffIntro =>
      'Två platser i Världsmästerskapet avgörs i en utslagsturnering mellan de bästa kvallagen som missade direktplats.';

  @override
  String get tourContPlayoffThrough =>
      'Du tog dig igenom play-offen. Du är med i Världsmästerskapet!';

  @override
  String get tourContPlayoffOut =>
      'Du föll i play-offen. Inget Världsmästerskap den här gången.';

  @override
  String get tourContContinue => 'Fortsätt';

  @override
  String get tourContPlayoffFinals => 'PLAY-OFF-FINALER';

  @override
  String get tourContPlayoffSeeded => 'Seedad (direkt in)';

  @override
  String get tourCupTabSummary => 'ÖVERSIKT';

  @override
  String get tourCupTabQualifying => 'KVAL';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'Den interkontinentala play-offen avgörs när kvalet i alla kontinentala förbund är klart.';

  @override
  String get tourCupTabFinals => 'SLUTSPEL';

  @override
  String get tourCupTabBracket => 'TRÄD';

  @override
  String get tourCupTabAwards => 'PRISER';

  @override
  String get tourCupTabScorers => 'SKYTTAR';

  @override
  String get tourCupTabHistory => 'HISTORIA';

  @override
  String get tourCupTabRecords => 'REKORD';

  @override
  String get tourCupTitle => 'VÄRLDSMÄSTERSKAPET';

  @override
  String get tourCupNoData => 'Inga cupdata.';

  @override
  String tourCupLoadError(String error) {
    return 'Det gick inte att ladda cupen.\n$error';
  }

  @override
  String get tourCupUnknown => 'Okänd';

  @override
  String get tourCupWorldChampions => 'VÄRLDSMÄSTARE';

  @override
  String get tourCupWorldChampionsTitle => 'Världsmästare';

  @override
  String get tourCupStillActive => 'Fortfarande aktiv';

  @override
  String get tourCupAllTimeScorers => 'MÅLSKYTTAR GENOM TIDERNA';

  @override
  String get tourCupAllConfederations => 'Alla kontinentala förbund';

  @override
  String get tourCupBestRunnersUp => 'Bästa tvåor';

  @override
  String get tourCupCompWorld => 'Världsmästerskapet';

  @override
  String get tourCupCompEurope => 'Europamästerskapet';

  @override
  String get tourCupCompSAmerica => 'Sydamerikacupen';

  @override
  String get tourCupDestRoundOf16 => 'åttondelsfinalerna';

  @override
  String get tourCupDestKnockouts => 'utslagsspelet';

  @override
  String get tourCupDestFinals => 'slutspelet';

  @override
  String get tourCupDestFinalsPlayoff => 'play-offen till slutspelet';

  @override
  String get tourCupDestIntercontPlayoff => 'den interkontinentala play-offen';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Slutspelet lottas när kvalet är slut.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Grupperna ska lottas. Se lottningen till Världsmästerskapet från startsidan för att avslöja dem.';

  @override
  String tourCupGroupName(String name) {
    return 'Grupp $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Grupp $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Värd: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Värdar: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Interkontinental play-off';

  @override
  String get tourCupKnockoutSoon => 'Träden börjar när gruppspelet är slut.';

  @override
  String get tourCupMatches => 'MATCHER';

  @override
  String get tourCupMedalTable => 'MEDALJTABELL';

  @override
  String get tourCupMostTitles => 'FLEST TITLAR';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles titlar på $editions turneringar';
  }

  @override
  String get tourCupNoGoals => 'Inga mål än.';

  @override
  String get tourCupNoGroups => 'Inga grupper lottade.';

  @override
  String get tourCupNoHistory => 'Ingen historia än.';

  @override
  String get tourCupPastWinners => 'TIDIGARE VINNARE';

  @override
  String get tourCupPlayoffIntro =>
      'Två platser i Världsmästerskapet avgörs i en utslagsturnering mellan de bästa kvallagen som missade direktplats.';

  @override
  String get tourCupQualDrawSoon =>
      'Grupperna ska lottas. Se kvallottningen från startsidan för att avslöja dem.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · din';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (straffar)';
  }

  @override
  String get tourCupSegAllTime => 'Genom tiderna';

  @override
  String get tourCupSegFinals => 'Slutspel';

  @override
  String get tourCupSegQualifying => 'Kval';

  @override
  String get playerTraitsTitle => 'KÄND FÖR';

  @override
  String get traitBigGame => 'Storspelare';

  @override
  String get traitBigGameBlurb => 'Höjer sig i utslagsmatcher.';

  @override
  String get traitSetPiece => 'Dödbollsspecialist';

  @override
  String get traitSetPieceBlurb =>
      'Bättre slag och fler mål på fasta situationer.';

  @override
  String get traitHothead => 'Hetsporre';

  @override
  String get traitHotheadBlurb => 'Får många fler kort än lagkamraterna.';

  @override
  String get traitIronMan => 'Järnman';

  @override
  String get traitIronManBlurb => 'Skadas sällan och tröttnar långsammare.';

  @override
  String get traitWonderkid => 'Underbarn';

  @override
  String get traitWonderkidBlurb => 'Ung, redan bra och förbättras snabbt.';

  @override
  String get traitLeader => 'Ledare';

  @override
  String get traitLeaderBlurb => 'Lyfter alla lagkamrater på planen.';

  @override
  String get traitPacey => 'Snabb';

  @override
  String get traitPaceyBlurb => 'Rasande fart, ett hot bakom backlinjen.';

  @override
  String get traitOldHead => 'Veteran';

  @override
  String get traitOldHeadBlurb =>
      'En veteran vars spelförståelse överlever benen.';

  @override
  String get traitWasteful => 'Slarvig';

  @override
  String get traitWastefulBlurb => 'Skjuter för många bra chanser utanför.';

  @override
  String get objectiveWorldCup => 'Världsmästerskapet';

  @override
  String get objectiveWinTournament => 'Vinn titeln';

  @override
  String get objectiveQualifyGeneric => 'Kvalificera dig';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Vinn Världsmästerskapet';

  @override
  String get objectiveReachFinal => 'Nå finalen';

  @override
  String get objectiveReachSemis => 'Nå semifinal';

  @override
  String get objectiveReachQuarters => 'Nå kvartsfinal';

  @override
  String get objectiveReachKnockouts => 'Nå utslagsspelet';

  @override
  String get objectiveQualify => 'Kvalificera dig för Världsmästerskapet';

  @override
  String get finishChampions => 'Mästare';

  @override
  String get finishRunnersUp => 'Tvåa';

  @override
  String get finishSemiFinals => 'Semifinal';

  @override
  String get finishQuarterFinals => 'Kvartsfinal';

  @override
  String get finishRoundOf16 => 'Åttondelsfinal';

  @override
  String get finishGroupStage => 'Gruppspel';

  @override
  String get objectiveQualifyingTopHalf => 'Sluta i övre halvan av kvalet';

  @override
  String get finishQualifyingTopHalf => 'Övre halvan av kvalgruppen';

  @override
  String get finishQualifyingBottomHalf => 'Nedre halvan av kvalgruppen';

  @override
  String get objectiveNcWinIt => 'Vinn Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Nå finalen i Nations Cup';

  @override
  String get objectiveNcFinalsFour => 'Nå Final Four';

  @override
  String get objectiveNcWinGroup => 'Vinn din grupp och gå upp';

  @override
  String get objectiveNcTopHalf => 'Sluta i övre halvan av din grupp';

  @override
  String get objectiveNcSurvive => 'Undvik nedflyttning';

  @override
  String get finishNcChampions => 'Vinnare av Nations Cup';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Gruppvinnare';

  @override
  String get finishNcTopHalf => 'Övre halvan av gruppen';

  @override
  String get finishNcStayedUp => 'Höll sig kvar';

  @override
  String get finishNcBottom => 'Sist i gruppen';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'SPELARE';

  @override
  String get squadDevAge => 'ÅLDER';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'BETYG';

  @override
  String get squadDevNew => 'NY';

  @override
  String get squadDevRetired => 'PENSIONERAD';

  @override
  String get squadDevEmpty => 'Ett lugnt år. Inga förändringar i truppen.';

  @override
  String get squadDevTierRegulars => 'STAMSPELARE';

  @override
  String get squadDevTierFringe => 'RESERVER';

  @override
  String get squadDevTierYouth => 'UNGDOM';

  @override
  String get boardObjectivesTitle => 'Styrelsens mål';

  @override
  String get boardObjectivesConfidence => 'Styrelsens förtroende';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rundor bättre än begärt',
      one: 'en runda bättre än begärt',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rundor för kort',
      one: 'en runda för kort',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ÅTERSTÅR ATT AVGÖRA';

  @override
  String boardObjectiveSoFar(String result) {
    return 'HITTILLS · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Styrelsen har inte satt något mål för den här cykeln.';

  @override
  String get tourContBestWinners => 'BÄSTA GRUPPVINNARE';

  @override
  String get tourContBestThirds => 'BÄSTA TREDJEPLACERADE';

  @override
  String tourContBestPlaced(String position) {
    return 'BÄSTA PLACERADE PÅ PLATS $position';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total spelare';
  }

  @override
  String get matchSoldOut => 'SLUTSÅLT';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance av $capacity platser fyllda';
  }

  @override
  String get matchGroundTitle => 'ARENA';

  @override
  String get absenceInjured => 'Skadad';

  @override
  String get absenceSuspended => 'Avstängd';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString veckor',
      one: '1 vecka',
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
      other: '$countString matcher',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Tillbaka mot $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Straffar';

  @override
  String get penaltyOrderBlurb =>
      'Utse dina fem straffskyttar i ordning. Tryck på en plats för att ändra.';

  @override
  String penaltyOrderPick(int number) {
    return 'Straff $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Välj vem som kliver fram. Stapeln visar spelarens nervstyrka på straffpunkten.';

  @override
  String get penaltyOrderConfirm => 'Kör på';

  @override
  String get penaltyOrderCancel => 'Tillbaka';

  @override
  String get youthTitle => 'Ungdom';

  @override
  String get youthEmptyLevel => 'Ingen på den här nivån än.';

  @override
  String get youthReleased => 'Släppta i år';

  @override
  String get u21Title => 'U21';

  @override
  String get u21Blurb =>
      'Nästa generation, bästa talang först. Tomma stjärnor är en scouts uppskattning. Ge spelaren en landskamp för att få veta vad han egentligen har.';

  @override
  String get u21Empty =>
      'Ingen under 21 i poolen just nu. Nästa kull kommer med den nya cykeln.';

  @override
  String u21Breakout(int gain) {
    return '+$gain I ÅR';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Ålder $age · $caps landskamper';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Ålder $age · ingen landskamp';
  }

  @override
  String get u21CallUps => 'Gå till uttagningen';

  @override
  String get youthWatching => 'Bevakas';

  @override
  String get youthWatchEmpty =>
      'Ingen markerad än. Markera en kille på valfri nivå så dyker han upp här, med vad han har blivit sedan dess.';

  @override
  String get youthWatchMark => 'Följ den här killen';

  @override
  String get youthWatchUnmark => 'Sluta följa honom';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Markerad vid $rating, $age år';
  }

  @override
  String get youthWatchSenior => 'Vidare till seniorpoolen';

  @override
  String get youthWatchReleased => 'Släppt av akademin';

  @override
  String get youthWatchGone => 'Finns inte längre i pyramiden';

  @override
  String get tacticsYouth => 'U21';

  @override
  String get pressSquad => 'Trupp';

  @override
  String get pressBoard => 'Styrelse';

  @override
  String get pressNoEffect => 'Ingen läser in så mycket i det';

  @override
  String get matchNeutralGround => 'NEUTRAL';

  @override
  String get matchExtraTimeAhead => 'FÖRLÄNGNING';

  @override
  String get matchExtraTimeHalf => 'FÖRLÄNGNING · HALVLEK';

  @override
  String get matchClockFullTime => 'FULL TID';

  @override
  String get matchClockAfterExtraTime => 'EFTER FÖRLÄNGNING';

  @override
  String get matchClockPenalties => 'STRAFFAR';

  @override
  String get matchClockFullTimePenalties => 'FULL TID · STRAFFAR';

  @override
  String get hubEventPressConference => 'Möt pressen';

  @override
  String get hubEventPressConferenceSub =>
      'Världens media vill ha ett ord före din första match';

  @override
  String get squadDevWonderkid => 'UNDERBARN';

  @override
  String get tacticsPlaystyle => 'Spelstil';

  @override
  String get tacticsPlaystyleBlurb =>
      'Välj hur laget spelar; reglagen nedanför finjusterar den.';

  @override
  String get tacticsPlaystyleCustom =>
      'Dina egna inställningar. Ingen namngiven stil matchar reglagen.';

  @override
  String get playstyleCustom => 'Egen';

  @override
  String get playstyleBalanced => 'Balanserad';

  @override
  String get playstylePossession => 'Bollinnehav';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Kontring';

  @override
  String get playstyleDirect => 'Direkt';

  @override
  String get playstyleLowBlock => 'Lågt block';

  @override
  String get playstyleWingPlay => 'Kantspel';

  @override
  String get playstyleBalancedBlurb =>
      'Stabilt i båda halvlekar, utan överdrifter.';

  @override
  String get playstylePossessionBlurb =>
      'Behåll bollen, spela tålmodigt, krymp planen.';

  @override
  String get playstyleGegenpressBlurb =>
      'Vinn tillbaka bollen direkt när den tappats, högt upp på planen.';

  @override
  String get playstyleCounterBlurb =>
      'Sitt djupt, håll ihop, slå sedan till i fart.';

  @override
  String get playstyleDirectBlurb => 'Fram tidigt och spela på andrabollen.';

  @override
  String get playstyleLowBlockBlurb =>
      'Djupt, smalt och mycket svårt att spela igenom.';

  @override
  String get playstyleWingPlayBlurb =>
      'Dra isär planen, ta dig runt ytterkanten och slå in bollen.';

  @override
  String get nationsRandomTeam => 'Slumpat lag';

  @override
  String get nationsFromTheBottom => 'Från botten';

  @override
  String get bottomStartTitle => 'Arbetslös';

  @override
  String get bottomStartHeading => 'Tre förbund vill prata';

  @override
  String get bottomStartBlurb =>
      'Du har inget jobb och inget rykte. Det här är de enda lagen som vågar satsa på dig. Ta ett och bygg något av ingenting.';

  @override
  String get bottomStartAccept => 'Tacka ja';

  @override
  String get bottomStartBack => 'Tillbaka till menyn';

  @override
  String bottomStartRankOf(int rank, int total) {
    return 'Plats $rank av $total i världen';
  }

  @override
  String get campTitle => 'Basläger';

  @override
  String campBasedIn(String host) {
    return 'Basläger i $host';
  }

  @override
  String get campBlurb =>
      'Där truppen bor under hela turneringen. Det kan inte ändras när spelet väl börjat, och det påverkar tre saker i varje match: hur fräscha spelarna kommer, hur snabbt en smäll läker och hur vassa de är.';

  @override
  String get campEffectTravel => 'Kommer fräscha';

  @override
  String get campEffectRecovery => 'Skador läker';

  @override
  String get campEffectSharpness => 'Matchskärpa';

  @override
  String get campTerrainCity => 'Stadskärna';

  @override
  String get campTerrainCoastal => 'Kustort';

  @override
  String get campTerrainMountain => 'Bergsretreat';

  @override
  String get campTerrainAltitude => 'Höghöjdsläger';

  @override
  String get campTerrainNationalCentre => 'Nationellt center';

  @override
  String get campTerrainCityBlurb =>
      'Allt runt hörnet och ingenstans att resa till, men ingen ro och ingen väg undan bruset.';

  @override
  String get campTerrainCoastalBlurb =>
      'Lugnt, bekvämt och bra för stämningen; en lång bussresa till varje arena.';

  @override
  String get campTerrainMountainBlurb =>
      'Sval luft och förstklassig sjukvård som får smällar att läka snabbt, långt från turneringen.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Tungt att träna i, men ben som håller långt in i turneringen.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Förbundets egna anläggningar: inget spektakulärt, inget som kan gå fel.';

  @override
  String get hubEventChooseCamp => 'Välj basläger';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Var truppen ska bo i $host';
  }

  @override
  String get tacticsTabBench => 'Bänk';

  @override
  String get squadSearchHint => 'Sök på namn eller klubb';

  @override
  String get squadFilterAll => 'Alla';

  @override
  String get squadFilterInSquad => 'I truppen';

  @override
  String get squadFilterUncapped => 'Utan landskamp';

  @override
  String get squadFilterUnavailable => 'Otillgängliga';

  @override
  String get squadLineAll => 'Alla lagdelar';

  @override
  String get squadSortBy => 'Sortera';

  @override
  String get squadSortRating => 'Betyg';

  @override
  String get squadSortCaps => 'Landskamper';

  @override
  String get squadSortGoals => 'Mål';

  @override
  String get squadSortAge => 'Ålder';

  @override
  String get squadSortName => 'Namn';

  @override
  String get squadLegendTitle => 'Vad märkena betyder';

  @override
  String get squadLegendStarting => 'I din startelva';

  @override
  String get squadLegendCalledUp => 'Uttagen, på bänken';

  @override
  String get squadLegendRatingUp => 'Betyget stiger i år';

  @override
  String get squadLegendRatingDown => 'Betyget sjunker i år';

  @override
  String get squadLegendInjured => 'Skadad, otillgänglig';

  @override
  String get squadLegendSuspended => 'Avstängd, otillgänglig';

  @override
  String get squadLegendTraits => 'KÄND FÖR';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Visar $shown av $total spelare';
  }

  @override
  String get squadNobodyMatches => 'Ingen i poolen matchar filtren.';

  @override
  String get squadStatPool => 'Pool';

  @override
  String get squadStatInSquad => 'Uttagna';

  @override
  String get squadMostCapped => 'Flest landskamper';

  @override
  String get squadTopScorer => 'Skyttekung';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps landskamper';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals mål';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Landsk.';

  @override
  String get squadGoalsShort => 'Mål';

  @override
  String get recordsRecordBookSubtitle =>
      'Landskamper, mål och lagets främsta rekord';

  @override
  String get statsLegacy => 'ARV';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name har redan bytts ut och kan inte komma in igen.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name har blivit utvisad och deltar inte mer.';
  }

  @override
  String get tacticsInjuredShort => 'SKADAD';

  @override
  String get tacticsSuspendedShort => 'AVSTÄNGD';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'Sydamerika';

  @override
  String get confNorthAmerica => 'Nordamerika';

  @override
  String get confAfrica => 'Afrika';

  @override
  String get confAsia => 'Asien';

  @override
  String get confOceania => 'Oceanien';

  @override
  String get compWorldCup => 'Världsmästerskapet';

  @override
  String get compWorldCupFinals => 'Världsmästerskapets slutspel';

  @override
  String get compWorldCupQualifying => 'VM-kval';

  @override
  String compQualifiers(String region) {
    return 'Kval i $region';
  }

  @override
  String get compFriendlies => 'Träningsmatcher';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Interkontinental play-off';

  @override
  String get compContinentalChampionship => 'Kontinentalmästerskapet';

  @override
  String get compEuropeanChampionship => 'Europamästerskapet';

  @override
  String get compSouthAmericaCup => 'Sydamerikacupen';

  @override
  String get compAfricanChampionship => 'Afrikamästerskapet';

  @override
  String get compAsianChampionship => 'Asienmästerskapet';

  @override
  String get compNorthAmericaCup => 'Nordamerikacupen';

  @override
  String get compOceaniaCup => 'Oceaniencupen';

  @override
  String get msgANation => 'Ett land';

  @override
  String get msgAPlayer => 'En spelare';

  @override
  String get msgAHostNation => 'ett värdland';

  @override
  String get msgCycleTitle1 => 'En ny cykel börjar';

  @override
  String msgCycleTitle2(int year) {
    return 'Vägen mot $year öppnas';
  }

  @override
  String get msgCycleTitle3 => 'En ny kampanj gryr';

  @override
  String get msgCycleTitle4 => 'Tillbaka till jobbet';

  @override
  String msgCycleBody1(int year) {
    return 'Vägen mot Världsmästerskapet $year börjar här.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'En ny cykel. Världsmästerskapet $year är målet.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Fyra år till Världsmästerskapet $year. Jobbet börjar nu.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Kampanjen $year börjar i dag.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Värd för $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host blir värd för nästa $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Kvallottning till $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Kvalgrupperna till $cup har lottats.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Värd för Världsmästerskapet $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host blir värd för Världsmästerskapet $year.';
  }

  @override
  String get msgWcQualDrawTitle => 'Kvallottning till Världsmästerskapet';

  @override
  String get msgWcQualDrawBody =>
      'Kvalgrupperna till Världsmästerskapet har lottats.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Slutspelslottning till $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Grupperna i slutspelet i $cup har lottats.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Slutspelslottning till Världsmästerskapet';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Lottningen till slutspelet i Världsmästerskapet $year är gjord.';
  }

  @override
  String get msgQualWcTitle1 => 'Vidare till Världsmästerskapet';

  @override
  String get msgQualWcTitle2 => 'Platsen i Världsmästerskapet säkrad';

  @override
  String get msgQualWcTitle3 => 'Vi åker till Världsmästerskapet';

  @override
  String get msgQualWcTitle4 => 'Biljetten löst';

  @override
  String msgQualWcBody1(int year) {
    return 'Du har kvalificerat dig för slutspelet i Världsmästerskapet $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Det är officiellt: ditt land är med i Världsmästerskapet $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'En plats i Världsmästerskapet $year är säkrad.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Du är vidare till slutspelet i Världsmästerskapet $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Vidare till $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Platsen i $cup säkrad';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Kvalificerade för $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Du har kvalificerat dig för slutspelet i $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Ditt land har säkrat sin plats i $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Du är vidare till $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: MÄSTARE!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Mästare i $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Du har vunnit $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp avgjort';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: mästarna korade';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp har en vinnare';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Ditt land är mästare i $comp $year efter seger över $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Du har vunnit $comp $year och fått bukt med $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year är ditt. $loser besegrades$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner vann $comp $year genom seger över $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner är mästare i $comp $year efter att ha slagit $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away i finalen';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' på straffar, efter en final som slutade $home–$away';
  }

  @override
  String get msgWpotyTitle => 'Årets världsspelare';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) utses till Årets världsspelare $year, en av dina.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) utses till Årets världsspelare $year.';
  }

  @override
  String get msgYpotTitle => 'Turneringens unga spelare';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age år, utses till turneringens unga spelare $year, en av dina.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age år, utses till turneringens unga spelare $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Du ligger kvar på #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Ingen förändring, fortfarande #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabilt på #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move placeringar',
      one: '1 placering',
    );
    return 'Upp $_temp0 totalt, till #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move placeringar',
      one: '1 placering',
    );
    return 'Ett kliv uppåt på $_temp0 tar dig till #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move placeringar',
      one: '1 placering',
    );
    return 'Upp $_temp0, nu #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move placeringar',
      one: '1 placering',
    );
    return 'Ner $_temp0 totalt, till #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move placeringar',
      one: '1 placering',
    );
    return 'Ett fall på $_temp0 släpper ner dig till #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move placeringar',
      one: '1 placering',
    );
    return 'Ner $_temp0, nu #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Du toppar världen.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation toppar världen.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Världsrankingen · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Världsrankingen har uppdaterats. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Ett kliv upp till #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Ett fall till #$rank';
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
      other: '$move placeringar',
      one: '1 placering',
    );
    return '$tournament har rört om i världsrankingen. $nation startade på #$from och slutade på #$to, en förbättring med $_temp0.';
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
      other: '$move placeringar',
      one: '1 placering',
    );
    return '$tournament har rört om i världsrankingen. $nation startade på #$from och slutade på #$to, ett fall på $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Sedan lottningen till Världsmästerskapet';

  @override
  String get rankingSinceCycleStart => 'Sedan kampanjen började';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from till #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name når $count landskamper';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name har nu gjort $count landskamper för ditt land.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name når $count mål';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name har gjort $count landslagsmål för ditt land.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Truppens utveckling · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Upp från akademin · $year';
  }

  @override
  String get msgThroughNote =>
      'Det här är ingen ny kull. Det är killarna som kom in som elvaåringar och nu har vuxit in i seniorpoolen.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Nya ansikten · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Satsningen på akademin syns: den här kullen kom in starkare än den annars hade gjort.';

  @override
  String get msgIntakeNoteStanding =>
      'Landet håller ögonen på det här laget: nu när laget klättrar i världsrankingen väljer de bästa killarna fotbollen, och den här kullen kom in starkare tack vare det.';

  @override
  String get msgIntakeNoteBoth =>
      'Pengarna till akademin och lagets klättring i världsrankingen syns båda: den här kullen kom in starkare än den annars hade gjort.';

  @override
  String msgIntakeTitle(int year) {
    return 'Akademikull · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Din lagkapten $name lägger av';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name lägger av i landslaget';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name har avslutat sin landslagskarriär, $age år gammal.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name har avslutat sin landslagskarriär, $age år gammal, och lämnar med $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count landskamper',
      one: '1 landskamp',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mål',
      one: '1 mål',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Kaptensbindeln är ledig. Utse en ny lagkapten på uttagningsskärmen.';

  @override
  String msgHofTitle(String name) {
    return '$name invald i Hall of Fame';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name går med i ditt lands Hall of Fame ($caps landskamper, $goals mål). Se spelaren under Legender.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name avstängd';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'de nästa $matches matcherna',
      one: 'nästa match',
    );
    return '$name $how och är avstängd i $_temp0. Spelaren kan inte tas ut.';
  }

  @override
  String get hubBanHowSecondYellow => 'blev utvisad för sitt andra gula kort';

  @override
  String get hubBanHowViolent => 'fick direkt rött kort för våldsamt spel';

  @override
  String get hubBanHowRed => 'blev utvisad';

  @override
  String hubInjuryTitle(String name) {
    return '$name skadad';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches matcher',
      one: '1 match',
    );
    return '$name fick en smäll och är borta i $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Tvåa';

  @override
  String get hubRunnerUpTitle2 => 'Så nära, men ändå så långt';

  @override
  String get hubRunnerUpTitle3 => 'Silvermedalj';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Du nådde finalen i $cup men förlorade mot $opponent. Så nära. Silver den här gången.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Slagna av $opponent i finalen i $cup. Tvåa, plågsamt nära.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Finalen i $cup gled dig ur händerna mot $opponent. Mycket att vara stolt över, men inte pokalen.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Utslagna';

  @override
  String get hubKnockedOutTitle2 => 'Vägs ände';

  @override
  String get hubKnockedOutTitle3 => 'Resan är över';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Du är utslagen ur $cup, besegrad av $opponent i $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent avslutar din $cup i $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Din $cup tar slut i $stage, besegrad av $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Utslagna i gruppspelet';

  @override
  String get hubGroupExitTitle2 => 'Ute i gruppspelet';

  @override
  String get hubGroupExitTitle3 => 'Tidig dusch';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Din $cup är över i gruppspelet. Det räckte inte till utslagsspelet.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Du tog dig inte ur gruppen. Din $cup slutar här.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Ingen plats i utslagsspelet den här gången. Din $cup är slut i gruppspelet.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Målet uppnått: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Målet missat: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Styrelsens mål i $comp: $demand. Du slutade: $finish. De fick det de bad om.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Styrelsens mål i $comp: $demand. Du slutade: $finish. Det är sämre än väntat.';
  }

  @override
  String get newsWcMissTitle => 'Drömmen om Världsmästerskapet är över';

  @override
  String newsWcMissBody(int year) {
    return 'Du tog dig inte till Världsmästerskapet $year. Kvalet räckte inte. Fyra år till.';
  }

  @override
  String get newsRecordScorerTitle => 'Historiens bästa målskytt';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name är nu spelets bäste målskytt genom tiderna med $goals mål.';
  }

  @override
  String get newsRecordCapsTitle => 'Flest landskamper';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name är nu spelets mest använda landslagsspelare med $caps landskamper.';
  }

  @override
  String get newsARecordBreaker => 'En ny rekordbrytare';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name går till $club';
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
    return '$name ($position, $rating) har lämnat $fromClub och skrivit på för $destination för $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club i $country';
  }

  @override
  String get newsTransferFree => 'Fri';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ $name kan byta till $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name vill spela för $nation';
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
    return '$name, en $age-årig $position med betyg $rating, som just nu representerar $fromNation, har släktband till $nation och kan tänka sig att byta. Öppna naturaliseringserbjudandet för att tacka ja eller nej.';
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
    return '$name, en $age-årig $position med betyg $rating, som just nu representerar $fromNation, är ett stjärnnamn med släktband till $nation och kan tänka sig att byta. Öppna naturaliseringserbjudandet för att tacka ja eller nej.';
  }

  @override
  String get newsTheirNation => 'deras land';

  @override
  String get newsYourNation => 'ditt land';

  @override
  String get tourStatusChampions => 'MÄSTARE';

  @override
  String get tourStatusFinals => 'SLUTSPEL';

  @override
  String get tourStatusQualifying => 'KVAL';

  @override
  String get tourStatusUpcoming => 'KOMMANDE';

  @override
  String get tourStatusInProgress => 'PÅGÅR';

  @override
  String get tourStatusComingSoon => 'SNART';

  @override
  String get tourStatusDecided => 'AVGJORT';

  @override
  String tourStatusLeague(String letter) {
    return 'DIVISION $letter';
  }

  @override
  String get tourDrawWcQualifying => 'LOTTNING AV VM-KVALET';

  @override
  String tourDrawContQualifying(String cup) {
    return 'KVALLOTTNING, $cup';
  }

  @override
  String get tourDrawWcHost => 'VÄRD FÖR VÄRLDSMÄSTERSKAPET';

  @override
  String tourDrawContHost(String cup) {
    return 'VÄRD FÖR $cup';
  }

  @override
  String get tourDrawHostsReveal => 'Och värdarna blir…';

  @override
  String get tourDrawHostReveal => 'Och värd blir…';

  @override
  String get tourDrawHostCandidates => 'Kandidaterna i startfältet:';

  @override
  String get tourKickoffContinentalCup => 'KONTINENTALCUP';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Missade $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Du kvalificerade dig inte för $cup. Kampanjen räckte inte hela vägen den här gången.';
  }

  @override
  String get potyLabelBest => 'Årets spelare';

  @override
  String get potyLabelYoung => 'Årets unga spelare';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assist',
      one: '1 assist',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Helhetsbetyg $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Matchbetyg $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Årets världsspelare $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name är världens bäste spelare i år.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name tar utmärkelsen som årets unga spelare.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Killarna du bevakar, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain poäng',
      one: 'en poäng',
    );
    return '$name har tagit ett kliv till $rating, $_temp0 upp från förra året.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name flyttas upp till $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name gör sin debut';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name har tagit sin första landskamp som $age-åring, med betyg $rating. En av killarna du bevakar.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Bollinnehav, spelarbetyg och matchens bäste spelare avgörs vid slutsignalen.';

  @override
  String get matchPlayerRatings => 'SPELARBETYG';

  @override
  String get matchSubstitutions => 'BYTEN';

  @override
  String get matchSubstitutes => 'AVBYTARE';

  @override
  String get matchPlayerOfTheMatch => 'MATCHENS BÄSTE SPELARE';

  @override
  String get matchGoalShout => 'MÅL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'STRAFFLÄGGNING $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: MÅL';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: MISS';
  }

  @override
  String get matchFeedKickOff => 'Avspark!';

  @override
  String get matchFeedNoEvents => 'Inga händelser än.';

  @override
  String get tourVenues => 'ARENOR';

  @override
  String tourPot(int number) {
    return 'POTT $number';
  }

  @override
  String get tourHostSelection => 'VAL AV VÄRD';

  @override
  String get tourCandidates => 'KANDIDATER';

  @override
  String get tourJointBid => 'GEMENSAM ANSÖKAN';

  @override
  String get tourGoldenGlove => 'GYLLENE HANDSKEN';

  @override
  String get tourTeamOfTournament => 'TURNERINGENS LAG';

  @override
  String get tourYourRun => 'DIN VÄG';

  @override
  String get tourMedalTable => 'MEDALJTABELL';

  @override
  String tourHostLine(String nation) {
    return 'Värd: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Värdar: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Grupp $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Seedade efter världsranking. Hitta ditt land före lottningen.';

  @override
  String get tourWorldRanking => 'Världsranking';

  @override
  String get tourYourCompetitions => 'DINA TÄVLINGAR';

  @override
  String get tourOtherContinents => 'ANDRA KONTINENTER';

  @override
  String get tourZoneGlobal => 'GLOBAL';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'SYDAMERIKA';

  @override
  String get tourZoneNorthAmerica => 'NORDAMERIKA';

  @override
  String get tourZoneAfrica => 'AFRIKA';

  @override
  String get tourZoneAsia => 'ASIEN';

  @override
  String get tourZoneOceania => 'OCEANIEN';

  @override
  String get tourZoneIntercontinental => 'INTERKONTINENTAL';

  @override
  String tourZoneLeague(String league) {
    return 'DIVISION $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'VÄRD  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'De $count bästa går vidare till $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name går sin väg';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name har lämnat landslaget som $age-åring, efter $caps landskamper. Han bad om besked om hur det låg till och fick inget, och han tänker inte vänta längre.';
  }

  @override
  String get pressHeadlineWent1 =>
      'En förbundskapten som har full kontroll över rummet';

  @override
  String get pressHeadlineWent2 => 'De kom för att bråka och fick en ledare';

  @override
  String get pressHeadlineWent3 => 'Raka svar, och de träffade rätt';

  @override
  String get pressHeadlineMixed1 => 'Mycket sagt, lite avgjort';

  @override
  String get pressHeadlineMixed2 => 'Något för alla, och inget för någon';

  @override
  String get pressHeadlineMixed3 =>
      'En presskonferens som lämnade frågorna öppna';

  @override
  String get pressHeadlineBadly1 => 'En svettig eftermiddag inför kamerorna';

  @override
  String get pressHeadlineBadly2 => 'Stämningen vände, och det syntes';

  @override
  String get pressHeadlineBadly3 =>
      'Svar som kommer att se sämre ut i morgon bitti';

  @override
  String get pressHeadlineFlat1 => 'Inget sagt, inget vunnet';

  @override
  String get pressHeadlineFlat2 => 'Tio minuter, inga nyheter';

  @override
  String get pressHeadlineFlat3 => 'Ett blankt blad till sportbilagan';

  @override
  String get pressConferenceTitle => 'PRESSKONFERENS';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Fråga $index av $total';
  }

  @override
  String get pressTomorrowsHeadline => 'MORGONDAGENS SPORTSIDA';

  @override
  String get pressLeaveRoom => 'LÄMNA RUMMET';

  @override
  String get pressRoomVerdictSquad => 'Omklädningsrummet';

  @override
  String get pressRoomVerdictBoard => 'Styrelsen';

  @override
  String get yReactionElation0 => 'inga anmärkningar. noll. perfekt.';

  @override
  String get yReactionElation1 => 'jag mår inte bra (på ett bra sätt).';

  @override
  String get yReactionElation2 =>
      'ramar in det här. ska hänga det över öppna spisen.';

  @override
  String get yReactionElation3 => 'nu är vi tillbaka';

  @override
  String get yReactionElation4 =>
      'Tar en skärmdump av det här åt tvivlarna. Alla.';

  @override
  String get yReactionElation5 =>
      'Jag kommer att vara outhärdlig över det här i tio år.';

  @override
  String get yReactionElation6 => 'Precis. Det är därför vi tittar.';

  @override
  String get yReactionElation7 => 'Såna här dagar betalar för alla de andra.';

  @override
  String get yReactionElation8 => 'Äntligen. På riktigt, äntligen.';

  @override
  String get yReactionElation9 =>
      'Bra. Gör om det nästa vecka så tror jag på det.';

  @override
  String get yReactionElation10 =>
      'Njut av i kväll, för det här gänget hittar ett sätt att förstöra det.';

  @override
  String get yReactionElation11 => 'En bra kväll gör ingen till ett storlag.';

  @override
  String get yReactionRelief0 => 'Inte snyggt, men jag tar det varje gång.';

  @override
  String get yReactionRelief1 => 'På något vis. På något vis!';

  @override
  String get yReactionRelief2 => 'Fult. Tre poäng. Vidare.';

  @override
  String get yReactionRelief3 => 'Jag tar fult hela dagarna om det ger poäng.';

  @override
  String get yReactionRelief4 => 'jag blev tio år yngre av det där';

  @override
  String get yReactionRelief5 => 'Ingen säger något. Ingen ska förhäxa det.';

  @override
  String get yReactionRelief6 => 'Puls: oacceptabel.';

  @override
  String get yReactionRelief7 => 'Vi överlevde. Det är ordet. Överlevde.';

  @override
  String get yReactionRelief8 =>
      'Vi borde inte behöva känna lättnad efter såna matcher.';

  @override
  String get yReactionRelief9 =>
      'Lättad, och lite generad över att vara lättad.';

  @override
  String get yReactionRelief10 =>
      'Om det där är nivån vi hurrar för har vi problem.';

  @override
  String get yReactionRelief11 =>
      'Att kravla sig vidare är en ovana, och inte en bra sådan.';

  @override
  String get yReactionFury0 => 'Inte bra nog. Inte i närheten.';

  @override
  String get yReactionFury1 => 'Någon får förklara det där för mig långsamt.';

  @override
  String get yReactionFury2 =>
      'Det var jobbigt att se på, och jag är ändå snäll.';

  @override
  String get yReactionFury3 => 'Besviken. Verkligen besviken.';

  @override
  String get yReactionFury4 => 'Vilket hopplöst tillstånd.';

  @override
  String get yReactionFury5 => 'Jag vill ha namn.';

  @override
  String get yReactionFury6 => 'Raderar appen. Installerar om på torsdag.';

  @override
  String get yReactionFury7 => 'Ingen därute såg ut att vilja det här.';

  @override
  String get yReactionFury8 => 'Vart fjärde år, samma sak. VARJE fjärde år.';

  @override
  String get yReactionFury9 =>
      'Det där är ingen prestation, det är en förolämpning.';

  @override
  String get yReactionFury10 =>
      'Folk offrar helger och pengar för det där. Tänk på det.';

  @override
  String get yReactionFury11 =>
      'Jag har försvarat det här laget i åratal. Inte i kväll. Inte efter det där.';

  @override
  String get yReactionDespair0 => 'ja. det var det.';

  @override
  String get yReactionDespair1 => 'Inga skämt i dag. Ingenting.';

  @override
  String get yReactionDespair2 => 'Ska ut och gå. En lång promenad.';

  @override
  String get yReactionDespair3 => 'Jag har slut på sätt att säga det här.';

  @override
  String get yReactionDespair4 => 'Väck mig om fyra år.';

  @override
  String get yReactionDespair5 => 'det här är den mörkaste tidslinjen';

  @override
  String get yReactionDespair6 =>
      'Jag är inte ens arg längre. Det är det oroande.';

  @override
  String get yReactionDespair7 => 'Den där kommer att svida länge.';

  @override
  String get yReactionDespair8 =>
      'Jag vet inte vad det här är längre, men det är inget fotbollslag.';

  @override
  String get yReactionDespair9 =>
      'Vi är längre ifrån än förut, och ingen vågar säga det.';

  @override
  String get yReactionDespair10 =>
      'En hel generation bortslösad, och samma människor bestämmer vad som händer härnäst.';

  @override
  String get yReactionDespair11 =>
      'Sluta tala om att det är en process. Den leder ingenstans.';

  @override
  String get yReactionSmugness0 => 'Tyst och lugnt, men: vad var det jag sa.';

  @override
  String get yReactionSmugness1 => 'bokmärk den här';

  @override
  String get yReactionSmugness2 => 'Tvivlarna har blivit väldigt tysta.';

  @override
  String get yReactionSmugness3 => 'Inte för att någon räknar. Jag räknar.';

  @override
  String get yReactionSmugness4 => 'Sa det i januari. Kolla tidslinjen.';

  @override
  String get yReactionSmugness5 =>
      'Några av er är skyldiga några av oss en ursäkt.';

  @override
  String get yReactionSmugness6 =>
      'Lägger det här under sådant jag nämnde först.';

  @override
  String get yReactionSmugness7 => 'Inget skadeglädjande. Lite skadeglädje.';

  @override
  String get yReactionSmugness8 => 'Var är alla experterna nu? Ärlig fråga.';

  @override
  String get yReactionSmugness9 =>
      'Jag vill att varenda en av er säger det till mig.';

  @override
  String get yReactionSmugness10 =>
      'Skärmdump, utskrift, inramning, skickad till dem som skrattade.';

  @override
  String get yReactionSmugness11 =>
      'Jag kommer att dra upp det här resten av livet, och ni har förtjänat det.';

  @override
  String get yReactionShrug0 => 'det hände. nästa.';

  @override
  String get yReactionShrug1 => 'Okej. Skit samma. Framåt.';

  @override
  String get yReactionShrug2 => 'Lägger den här under ”fotboll”.';

  @override
  String get yReactionShrug3 => 'Har verkligen inget att tillägga.';

  @override
  String get yReactionShrug4 => 'inga tankar, tomt i huvudet';

  @override
  String get yReactionShrug5 => 'Väck mig inför nästa.';

  @override
  String get yReactionShrug6 => 'Nittio minuter jag aldrig får tillbaka.';

  @override
  String get yReactionShrug7 => 'Varken fågel eller fisk, egentligen.';

  @override
  String get yReactionShrug8 => 'Kan inte berätta en enda sak som hände.';

  @override
  String get yReactionShrug9 => 'En sån till. Det finns många såna.';

  @override
  String get yReactionShrug10 => 'Jag såg hela och kände absolut ingenting.';

  @override
  String get yReactionShrug11 =>
      'Om ingen nämner det här igen är det okej för mig.';

  @override
  String get tourThirdsUneven =>
      'Grupperna är olika stora, så resultat mot den sista i varje stor grupp räknas bort och alla lag bedöms över lika många matcher.';

  @override
  String get careerExportSave => 'Säkerhetskopiera den här sparfilen';

  @override
  String get careerBackupAll => 'SÄKERHETSKOPIERA ALLA';

  @override
  String get careerBackupAllFailed => 'Kunde inte skriva säkerhetskopian.';

  @override
  String get backupTitle => 'SPARFILER';

  @override
  String get backupBlurb =>
      'Alla sparfiler ligger i en fil på den här telefonen, och ingenting säkerhetskopierar dem av sig självt. Exportera en kopia och spara den utanför telefonen, i Filer eller iCloud Drive, så att en förlorad telefon eller en raderad app inte kostar dig en karriär.';

  @override
  String get backupExport => 'EXPORTERA EN SÄKERHETSKOPIA';

  @override
  String get backupExportSubject => 'FNM-sparfiler';

  @override
  String get backupRestore => 'ÅTERSTÄLL FRÅN FIL';

  @override
  String get backupRestoreWarnTitle => 'Ersätta alla sparfiler?';

  @override
  String get backupRestoreWarnBody =>
      'Återställningen ersätter alla sparfiler på den här telefonen med de i filen. Appen startas om.';

  @override
  String get backupRestoreConfirm => 'ERSÄTT';

  @override
  String get backupCancel => 'AVBRYT';

  @override
  String get backupExported =>
      'Säkerhetskopian är klar. Välj var du vill spara den.';

  @override
  String get backupFailed => 'Kunde inte skriva säkerhetskopian.';

  @override
  String get backupRejectedUnreadable => 'Filen kunde inte öppnas.';

  @override
  String get backupRejectedNotFnm => 'Det är ingen FNM-sparfil.';

  @override
  String get backupRejectedNewer =>
      'Sparfilen skapades av en nyare version av appen. Uppdatera först.';

  @override
  String get backupRejectedTooOld =>
      'Sparfilen är för gammal för att återställas av den här versionen.';

  @override
  String get careerShare => 'Dela den här karriären';

  @override
  String get careerImport => 'IMPORTERA EN KARRIÄR';

  @override
  String get careerShareSubject => 'En FNM-karriär';

  @override
  String get careerImported => 'Karriären har importerats.';

  @override
  String get careerImportFailedUnreadable => 'Filen är ingen FNM-karriär.';

  @override
  String get careerImportFailedNewer =>
      'Karriären exporterades av en nyare version av appen. Uppdatera först.';

  @override
  String get careerImportFailedSlotsFull =>
      'Alla dina sparplatser är upptagna. Radera en sparfil för att få plats, eller lås upp obegränsat antal sparfiler.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Karriären har passerat den gratis första cykeln. Lås upp hela spelet för att ta in den.';

  @override
  String get careerImportFailedCampaignRun =>
      'Den kampanjen har redan en pågående omgång. Fortsätt eller avbryt den först.';

  @override
  String get careerShareFailed => 'Kunde inte exportera den karriären.';

  @override
  String get managerRename => 'Byt namn';

  @override
  String get managerRenameSave => 'Spara';

  @override
  String get managerTitle => 'FÖRBUNDSKAPTEN';

  @override
  String get managerSkills => 'DINA FÄRDIGHETER';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poäng att spendera',
      one: '1 poäng att spendera',
      zero: 'Inga poäng att spendera',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Två poäng för varje cykel du avslutar, en för varje titel du vinner.';

  @override
  String get managerSkillsScale =>
      'Varje färdighet börjar på 5 och slutar på 20. En poäng som spenderats är permanent.';

  @override
  String get managerSkillManManagement => 'Ledarskap';

  @override
  String get managerSkillManManagementBlurb =>
      'Varje poäng gör att det du säger till pressen och spelarna slår 3 % hårdare i omklädningsrummet.';

  @override
  String get managerSkillTactical => 'Taktik';

  @override
  String get managerSkillTacticalBlurb =>
      'Varje poäng får en ny formation att sätta sig 3 % snabbare, så ett formationsbyte kostar dig färre matcher.';

  @override
  String get managerSkillYouth => 'Ungdomsutveckling';

  @override
  String get managerSkillYouthBlurb =>
      'Varje poäng ger 1 % mer talang ur din akademi, utöver det du finansierar den med.';

  @override
  String get managerSkillNegotiation => 'Förhandling';

  @override
  String get managerSkillNegotiationBlurb =>
      'Varje poäng ger 2 % mer pengar från förbundet, varje cykel.';

  @override
  String get managerStaff => 'DIN STAB';

  @override
  String managerStaffWages(String amount) {
    return 'Löner: $amount per cykel';
  }

  @override
  String get managerRoleAssistant => 'Assisterande förbundskapten';

  @override
  String get managerRoleAssistantBlurb =>
      'Leder träningen: färre skador och bättre ungdomar som kommer fram.';

  @override
  String get managerRoleScout => 'Chefsscout';

  @override
  String get managerRoleScoutBlurb =>
      'Läser dina talanger och nästa motståndare: säkrare stjärnbetyg och en fördel på matchdagen.';

  @override
  String get managerRoleFitness => 'Fystränare';

  @override
  String get managerRoleFitnessBlurb => 'Håller dem på planen.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent % färre skador';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Ungdomar +$points helhetsbetyg';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Anställer du en: $min % till $max % färre skador';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'och ungdomar +$minPoints till +$maxPoints helhetsbetyg';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Läser $percent % av talangerna exakt';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potentialen känd efter $caps landskamper',
      one: 'Potentialen känd efter 1 landskamp',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points betyg från motståndardossierer';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Anställer du en: $min % till $max % exakta bedömningar';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'och potentialen känd $minCaps till $maxCaps landskamper tidigare';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'och +$minPoints till +$maxPoints betyg varje match';
  }

  @override
  String get staffEffectNone => 'Ingen effekt på din trupp än';

  @override
  String get staffVacant => 'Ingen på posten';

  @override
  String get staffLeaveVacant => 'Lämna posten tom';

  @override
  String get managerTierNone => 'Ingen';

  @override
  String get managerTierBasic => 'Enkel';

  @override
  String get managerTierGood => 'God';

  @override
  String get managerTierElite => 'Elit';

  @override
  String get managerFree => 'gratis';

  @override
  String get managerTraining => 'MELLAN SAMLINGARNA';

  @override
  String get managerTrainingBlurb =>
      'Vad truppen jobbar med när det inte finns någon match att spela.';

  @override
  String get managerFocusBalanced => 'Balanserad';

  @override
  String get managerFocusBalancedBlurb => 'Lite av varje.';

  @override
  String get managerFocusFitness => 'Kondition';

  @override
  String get managerFocusFitnessBlurb => 'Färre smällar.';

  @override
  String get managerFocusCohesion => 'Sammanhållning';

  @override
  String get managerFocusCohesionBlurb => 'Formationen sätter sig snabbare.';

  @override
  String get managerFocusYouth => 'Ungdom';

  @override
  String get managerFocusYouthBlurb => 'Timmar med de yngsta i spelartruppen.';

  @override
  String get tourOfferTitle => 'Första gången här?';

  @override
  String get tourOfferBody =>
      'Det här är ett stort spel. Vill du ha en snabb genomgång av de skärmar som spelar roll? Det tar en minut, och du kan starta den igen när som helst från Inställningar.';

  @override
  String get tourOfferYes => 'Visa mig runt';

  @override
  String get tourOfferNo => 'Nej tack';

  @override
  String get tourBack => 'Tillbaka';

  @override
  String get tourNext => 'Nästa';

  @override
  String get tourDone => 'Klar';

  @override
  String get tourSkip => 'Hoppa över';

  @override
  String get tourHubTitle => 'Det här är hela spelet';

  @override
  String get tourHubBody =>
      'En knapp som ändras allt eftersom cykeln går: en lottning att titta på, en trupp att ta ut, en match att spela. Ovanför den ser du styrelsens förtroende för dig och de mål de har satt.';

  @override
  String get tourBudgetTitle => 'Förbundets pengar';

  @override
  String get tourBudgetBody =>
      'En gång per fyraårscykel delar du krigskassan mellan avdelningarna. Din stab får lön först, så att anställa en elitscout är ett beslut du fattar på akademins bekostnad, inte vid sidan av den.';

  @override
  String get tourTacticsTitle => 'Hur laget spelar';

  @override
  String get tourTacticsBody =>
      'Din formation, ditt sätt att spela, din lagkapten och vem som tar de fasta situationerna. Lämnar du de två sista tomma varnar spelet dig före avspark i stället för att tyst välja åt dig.';

  @override
  String get tourSquadTitle => 'Alla du kan ta ut';

  @override
  String get tourSquadBody =>
      'Hela spelartruppen, inte bara landslagstruppen: vem som är i form, vem som dras med en skada, vem som är avstängd och vem som just kommit upp ur akademin.';

  @override
  String get tourCallUpsTitle => 'Ta ut en trupp';

  @override
  String get tourCallUpsBody =>
      'Du tar ut en trupp per landslagsfönster och den spelar varje match i fönstret, precis som en riktig förbundskapten gör. Blir någon skadad under fönstret kallas en ersättare in åt dig.';

  @override
  String get tourRecordsTitle => 'Din karriär';

  @override
  String get tourRecordsBody =>
      'Allt du har gjort: matcherna, lagrekorden, troféerna och varje land du har lett.';

  @override
  String get tourCupsTitle => 'Resten av världen';

  @override
  String get tourCupsBody =>
      'Varje tävling som pågår just nu: grupper, tabeller och utslagsspel, även de du inte är med i. Världen fortsätter spela oavsett om du kvalificerade dig eller inte.';

  @override
  String get settingsTourTitle => 'Visa guiden igen';

  @override
  String get settingsTourBlurb =>
      'Gå igenom de viktigaste skärmarna igen från början.';

  @override
  String get tourBoardTitle => 'Vem du svarar inför';

  @override
  String get tourBoardBody =>
      'Styrelsens förtroende för dig och de mål de har satt för den här cykeln. Missar du uppdraget är det här du ser det komma.';

  @override
  String get tourStaffTitle => 'Människorna runt dig';

  @override
  String get tourStaffBody =>
      'En assistent, en scout och en fystränare, anställda vid namn. Deras löner tas från den här budgeten före avdelningarna, så en riktigt bra scout är ett beslut på akademins bekostnad.';

  @override
  String get tourPlaystyleTitle => 'Ditt sätt att spela';

  @override
  String get tourPlaystyleBody =>
      'Formationen är bara halva taktiken. Det här är den andra halvan: hur högt du pressar, hur direkt du spelar, hur mycket du riskerar.';

  @override
  String get settingsTourNoSave =>
      'Starta en karriär först. Genomgången besöker dina egna skärmar.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Fel position · $age år';
  }

  @override
  String get federationNextCycleLocked =>
      'Nästa cykels budget bestäms i början av den cykeln, i ett svep. Fram till dess är det här vad dina pengar gör.';

  @override
  String get federationBudgetAlreadySet =>
      'Redan fastställd för den här cykeln';

  @override
  String yFinalLooms0(String opponent) {
    return 'Det blir $opponent i den stora matchen. Hela veckan kommer ingen att prata om något annat.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Bekräftat: $opponent står mellan oss och titeln. Fyra år för det här.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Okej. $opponent. Ingen sover förrän det här är över.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent härnäst, och allt annat kan vänta. Vilken vecka att vara vid liv.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Låt tränaren sköta utförarna';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Markerade nedan: lag som spelar som $rivals, de lag du möter i dina grupper den här cykeln.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Transferfönster · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Senast för $when sedan';
  }

  @override
  String get settingsFreeScopeTitle => 'En gratis fyraårscykel';

  @override
  String get settingsFreeScopeBlurb =>
      'En hel cykel (kval, din kontinentala mästerskapsturnering och Världsmästerskapet) på två sparplatser, alla länder i världen, inget undanhållet. Obegränsade cykler och obegränsat antal sparfiler köper du med en enda betalning, en gång, och den gäller för alla framtida uppdateringar.';

  @override
  String get settingsUnlockedTitle => 'Upplåst';

  @override
  String get settingsUnlockedBlurb =>
      'Obegränsade cykler, obegränsat antal sparfiler och alla framtida uppdateringar. Tack.';

  @override
  String get settingsFromDeveloperTitle => 'Från utvecklaren';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager görs av en enda person och kommer att få support långsiktigt. Det kommer aldrig att finnas reklam eller mikrotransaktioner. Om du gillar spelet, överväg att köpa hela versionen. Det är den som håller uppdateringarna igång.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager görs av en enda person och kommer att få support långsiktigt. Det kommer aldrig att finnas reklam eller mikrotransaktioner. Tack för att du köpte hela versionen. Det är den som håller uppdateringarna igång.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Markerade nedan: lag som spelar som $rivals, som du fortfarande har framför dig.';
  }

  @override
  String get friendliesCloseToYou =>
      'Markerade nedan: de lag som ligger närmast dig på världsrankingen. När du har lottats följer markeringarna din grupp.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count övergångar',
      one: '1 övergång',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Nyare';

  @override
  String get transfersOlder => 'Fler';

  @override
  String get transfersPagePrevious => 'Föregående';

  @override
  String get transfersPageNext => 'Nästa';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Sida $page av $pages';
  }

  @override
  String get transfersMovedTo => 'Gick till';

  @override
  String get transfersUnknownClub => 'Okänd klubb';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Nu är det $count gånger mot $opponent. Någon för räkning, och det är dem.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent igen. $count möten, och vi har fortfarande inte listat ut dem.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Nummer $count mot $opponent. Det här är inte en slump längre.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Vi har mött $opponent $count gånger och inte lärt oss något av någon av dem.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count gånger. De vet exakt vad vi tänker göra.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Vad det än är $opponent har på oss, $count möten in, så har de det kvar.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Det här har hänt $count gånger på sistone. När är det bara vad vi är?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count eftermiddagar som den här nu. Det är ett mönster, inte otur.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Vi har sett exakt den här matchen $count gånger nyligen. Samma manus, samma slut.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count versioner av samma nittio minuter nu. Ingen fixar det.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count gånger. Om du inte ser mönstret nu tittar du inte.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Samma historia, $count gånger om. Ursäkterna tog slut före resultaten.';
  }

  @override
  String get yToldYouSo0 =>
      'Jag sa att det här var på väg medan alla var upptagna med att fira.';

  @override
  String get yToldYouSo1 =>
      'Två bra veckor och vi var en gyllene generation igen. Och här är vi.';

  @override
  String get yToldYouSo2 =>
      'De som sa åt mig att njuta förra månaden har blivit tysta.';

  @override
  String get yToldYouSo3 =>
      'Jag njuter inte av det här. Väldigt lite. Lite grann.';

  @override
  String get yToldYouSo4 =>
      'Det var aldrig så bra som de sa, och det här är beviset.';

  @override
  String get yToldYouSo5 =>
      'Varje gång. Vi får höra att det är annorlunda, och varje gång är det inte det.';

  @override
  String get tacticsSubOffAlready => 'Redan utbytt';

  @override
  String get tacticsSubInjured => 'Skadad';

  @override
  String get tacticsSubSentOffMark => 'Utvisad';

  @override
  String get tacticsSubNoneLeft => 'Inga byten kvar';

  @override
  String get tacticsUndoLastChange => 'Ångra senaste ändring';

  @override
  String get matchStrengthTitle => 'VAD SOM PÅVERKAR LAGET';

  @override
  String get strengthFactorFamiliarity => 'Inövad formation';

  @override
  String get strengthFactorFatigue => 'Trötta ben';

  @override
  String get strengthFactorClubForm => 'Klubbform';

  @override
  String get strengthFactorMorale => 'Omklädningsrummet';

  @override
  String get strengthFactorCaptain => 'Lagkapten';

  @override
  String get strengthFactorStaff => 'Stabsrummet';

  @override
  String get strengthFactorDossier => 'Scoutens dossier';

  @override
  String yDebut0(String name) {
    return '$name gör sin första landskamp. Kom ihåg namnet.';
  }

  @override
  String yDebut1(String name) {
    return 'Debut för $name. Man ser det på honom, eller hur?';
  }

  @override
  String yDebut2(String name) {
    return '$name, första landskampen. Låt oss se vad han gör av den.';
  }

  @override
  String yDebut3(String name) {
    return 'Debut för $name. Truppen behövde fräscha ben någonstans.';
  }

  @override
  String yDebut4(String name) {
    return '$name får en landskamp. Vi har delat ut en hel del såna på sistone.';
  }

  @override
  String yDebut5(String name) {
    return 'En debut för $name. En till som vi har glömt till våren.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name har gått $count utan att göra mål och gör allt annat på planen.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count matcher utan mål för $name. De kommer i tretal, har alltid gjort.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count matcher, inga mål.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count utan mål för $name. Värt att hålla ett öga på.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count matcher. Inga mål. $name skulle inte träffa en ladugårdsvägg.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name har inte gjort mål på $count. Spela vem som helst annars.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '$opponent härnäst. $count möten och det betyder fortfarande allt.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count gånger mot $opponent nu. Kom igen.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '$opponent härnäst. Spelat $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Möte nummer $count med $opponent den här veckan.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent igen. $count såna här och vi har inte lärt oss något.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count matcher mot $opponent och de slår oss fortfarande. Underbart.';
  }

  @override
  String get positionGoalkeeper => 'Målvakt';

  @override
  String get positionLeftBack => 'Vänsterback';

  @override
  String get positionCentreBack => 'Mittback';

  @override
  String get positionRightBack => 'Högerback';

  @override
  String get positionDefensiveMid => 'Defensiv MF';

  @override
  String get positionCentralMid => 'Central MF';

  @override
  String get positionAttackingMid => 'Offensiv MF';

  @override
  String get positionLeftMid => 'Vänster MF';

  @override
  String get positionRightMid => 'Höger MF';

  @override
  String get positionLeftWing => 'Vänsterytter';

  @override
  String get positionRightWing => 'Högerytter';

  @override
  String get positionStriker => 'Anfallare';

  @override
  String get roleNone => 'Ingen roll';

  @override
  String get roleTargetMan => 'Målspelare';

  @override
  String get rolePoacher => 'Målräv';

  @override
  String get rolePlaymaker => 'Speluppläggare';

  @override
  String get roleBallWinner => 'Bollvinnare';

  @override
  String get roleInvertedWinger => 'Inverterad ytter';

  @override
  String get roleBallPlayingDefender => 'Spelskicklig försvarare';

  @override
  String get roleNoneBlurb => 'Spelar sitt naturliga spel.';

  @override
  String get roleTargetManBlurb =>
      'Vinner nickdueller, lägger av. Assist och fasta situationer.';

  @override
  String get rolePoacherBlurb => 'Lurar i straffområdet. Många fler mål.';

  @override
  String get rolePlaymakerBlurb => 'Skapar chanser. Många fler assist.';

  @override
  String get roleBallWinnerBlurb => 'Bryter spel snarare än avslutar det.';

  @override
  String get roleInvertedWingerBlurb => 'Skär inåt för att skjuta. Fler mål.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Startar anfall bakifrån.';

  @override
  String get federationDeptYouth => 'Ungdomsakademi';

  @override
  String get federationDeptCommercial => 'Kommersiellt / PR';

  @override
  String get federationDeptMedical => 'Medicin och idrottsvetenskap';

  @override
  String get federationDeptNaturalisation => 'Naturaliseringsbyrå';

  @override
  String get federationDeptBoardRelations => 'Styrelserelationer';

  @override
  String get federationDeptYouthBlurb =>
      'Bättre akademitalanger debuterar för ditt land nästa cykel.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsring ger extra intäkter i slutet av cykeln.';

  @override
  String get federationDeptMedicalBlurb =>
      'Färre skador. Din trupp är tillgänglig hela cykeln.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Fler utländska spelare erbjuder sig att byta till ditt land.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Styrelsen bedömer dina resultat med mer tålamod.';

  @override
  String get federationBuildingAcademy => 'Akademi';

  @override
  String get federationBuildingCommercial => 'Kommersiellt högkvarter';

  @override
  String get federationBuildingMedical => 'Medicinskt center';

  @override
  String get federationBuildingScouting => 'Scoutingkontor';

  @override
  String get federationBuildingBoardroom => 'Styrelserum';

  @override
  String get moraleBuoyant => 'På topp';

  @override
  String get moralePositive => 'Positiv';

  @override
  String get moraleSettled => 'Stabil';

  @override
  String get moraleUneasy => 'Orolig';

  @override
  String get moraleRockBottom => 'Botten';

  @override
  String get matchTabTimeline => 'FÖRLOPP';

  @override
  String get matchTabStats => 'STATISTIK';

  @override
  String get matchTabLineups => 'STARTELVOR';

  @override
  String get matchPenalty => 'STRAFF';

  @override
  String get matchStateLevel => 'Det är jämnt';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du leder med $count mål',
      one: 'Du leder med ett mål',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du ligger under med $count mål',
      one: 'Du ligger under med ett mål',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession % bollinnehav';
  }

  @override
  String get boardVerdictSackedTitle => 'Styrelsen har avskedat dig';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'En usel cykel (betyg $rating %). Din tid här är över. Bara mindre länder vill satsa på dig nu.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Styrelsen är överlycklig';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'En enastående cykel (betyg $rating %) efter $best. Större länder är intresserade, eller så stannar du och bygger vidare.';
  }

  @override
  String get boardVerdictSolidTitle => 'En stabil cykel';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Styrelsen är nöjd (betyg $rating %). Några länder av liknande dignitet skulle ta dig, men det finns ingen press att flytta.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Styrelsen väntade sig mer';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'En svag cykel (betyg $rating %). Du behåller jobbet, men alla erbjudanden är ett steg ner.';
  }

  @override
  String get boardVerdictPressureTitle => 'Du är under verklig press';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'En svag cykel (betyg $rating %). Du klarar dig kvar, men bara svagare länder är intresserade om du vill börja om.';
  }

  @override
  String get boardVerdictHeroTitle => 'Landet står bakom dig';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cyklar',
      one: '1 cykel',
    );
    return ' $nation älskar dig, en nationalhjälte efter $_temp0; ditt jobb är tryggt så länge du vill ha det.';
  }

  @override
  String get boardVerdictTheNation => 'Landet';

  @override
  String get boardVerdictBestQuiet => 'en lugn cykel';

  @override
  String get boardVerdictBestCycle => 'cykeln';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'VM: $placement';
  }

  @override
  String get finishThirdPlace => 'Trea';

  @override
  String get finishFourthPlace => 'Fyra';

  @override
  String get finishDidNotQualify => 'Missade kvalet';

  @override
  String get careerRepIconic => 'Ikonisk';

  @override
  String get careerRepRenowned => 'Ansedd';

  @override
  String get careerRepEstablished => 'Etablerad';

  @override
  String get careerRepRising => 'På uppgång';

  @override
  String get careerRepUnproven => 'Obeprövad';

  @override
  String get hubOfferStepUp => 'Ett kliv uppåt';

  @override
  String get hubOfferLateral => 'Sidledes flytt';

  @override
  String get hubOfferRebuild => 'Ett återuppbyggnadsjobb';

  @override
  String careerNationsCupWon(String league) {
    return 'Division $league · Mästare';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Division $league · Tvåa';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Division $league · Semifinalist';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Division $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Till $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Till bronsmatchen';

  @override
  String tourRunThrough(String round) {
    return 'Vidare från $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Utslagna i $round';
  }

  @override
  String get tourRunInGroup => 'Spelar gruppspel';

  @override
  String get tourRunGroupOut => 'Utslagna i gruppspelet';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Cykeln $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played spelade  ·  ${won}V ${drawn}O ${lost}F';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Världsmästerskapet: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Pågår fortfarande';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Två mål under mot $opponent i paus och de tog igen allt. Det är ett lag.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Två mål efter mot $opponent och på slutet spelade det ingen roll. Det klarar inte många lag.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Paus: två mål under mot $opponent. Full tid: inte längre. Andra halvlek var en helt annan match.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Vände från 0–2 mot $opponent. Vad som än sades i pausen, säg det varje vecka.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Okej, vi tog igen det mot $opponent. Nu kan någon förklara de första fyrtiofem minuterna.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Två mål under mot $opponent och vi ska vara glada. Fixa första halvlek.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Två mål upp mot $opponent i paus och det rann iväg. Det händer bättre lag.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Två mål före mot $opponent och det försvann. Lång cykel kvar, gott om tid.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Paus: två mål upp mot $opponent. Full tid: inte i närheten.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Två måls ledning mot $opponent, borta på under fyrtiofem minuter.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Två mål upp och vi tappade det. Mot $opponent. Någon får svara för det.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Två mål före mot $opponent och vi lyckades med det här. Varje gång.';
  }

  @override
  String get cycleBackupDone =>
      'Karriären är säkerhetskopierad till FNM-mappen på den här telefonen. Avinstallerar du appen försvinner den: för att behålla en kopia på annat håll, använd Säkerhetskopiera den här sparfilen på sparskärmen.';

  @override
  String get cycleBackupFailed =>
      'Det gick inte att säkerhetskopiera karriären den här gången.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'En kväll att minnas mot $opponent. Hur stolt är du över den här gruppen?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent hängde inte med. Är det här laget du alltid trott att du hade?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'En stor seger över $opponent. Vad gjorde skillnaden ikväll?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent besegrade, och ganska enkelt. Var vann ni matchen?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'En bra seger över $opponent. En bra kväll: varför ska någon tro att det håller i sig?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Ett fint resultat mot $opponent. Var det din plan, eller löste spelarna det själva?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'En tung kväll mot $opponent. Vad säger du till spelarna efter en sådan match?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Ingen såg det komma mot $opponent. Var det bara en sådan kväll?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Det var en nedslående kväll mot $opponent. Vad gick fel?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent spelade sönder er. Är den här truppen tillräckligt bra?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Ni var sämre på allt mot $opponent. Hur kunde du låta det bli så illa?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent gjorde mål som de ville. Var fanns planen ikväll?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Ännu en match som rinner iväg, den här gången mot $opponent. Hur vänder du den här svängen?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Resultaten har tagit slut, och $opponent gjorde det värre. Tror du fortfarande på den här gruppen?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Ingen seger igen, nu mot $opponent, och styrelsen håller koll. Är ditt jobb säkert?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Efter $opponent börjar serien bli lång. Oroar du dig för din framtid?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Nu $opponent också. Din företrädare fick sparken efter en sådan svit. Varför ska du klara dig?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Efter ännu en kväll som mot $opponent vill varenda telefonprogram se dig borta. Skulle du avgå om styrelsen bad dig?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Du satte ditt jobb på spel, och efter $opponent gick det inte din väg. Hur håller du ihop?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'De tre matcherna är över, den sista mot $opponent. Du satte provet själv. Vad tycker du om domen?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Du sa åt oss att döma dig efter de tre nästa. Efter $opponent har vi gjort det. Är jobbet fortfarande ditt?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Tre matcher, den sista mot $opponent, och inte vad du lovade. Har du pratat med styrelsen om din framtid?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Du satte provet själv och föll mot $opponent. Tänker du avgå?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Dina ord, inte våra: döm mig efter de tre nästa. Efter $opponent, varför sitter du kvar?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Du vill ha mer av dem. Någon särskild?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Du har lagt ribban högt. Vem måste kliva fram först?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Du säger att några av dem måste se sig själva i spegeln. Vem menar du?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Inte tillräckligt bra, säger du. Vem pratar du om?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Du håller det vagt. Tänker du nämna namn, eller landar det hos dig?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Varje vecka är det någon annans fel. Vems är det den här gången?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Modiga ord. Och om nästa match inte går din väg?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Landet kommer att hålla dig till det. Vad händer om det inte går ihop?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'Och om du inte vinner den? Vad då?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Nu har du sagt det. Vad händer om du har fel?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Vi har hört löften i det här rummet förut. Vad är du skyldig supportrarna om även det här brister?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Och när det inte händer, vad blir ursäkten då?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'En fråga till, om du orkar. Vad behöver den här gruppen fortfarande jobba på?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'När dammet har lagt sig, vad tar du med dig från ikväll till nästa match?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Vi går lite djupare. Vad måste bli bättre före nästa match?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Bortom resultatet: är den här truppen där du vill ha den?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Många ord, lite sagt. Vad förändras egentligen härifrån?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Supportrarna vill ha ett rakt svar. Är det här laget tillräckligt bra, ja eller nej?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player var enastående ikväll. Hur långt kan han nå?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player är i varenda rubrik ikväll. Såg du det komma?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player stack ut. Vad bad du honom om ikväll?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Var $player skillnaden ikväll?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Utan $player är det en annan historia. Är det här ett lag, eller en spelare?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player var lysande. Din förtjänst, eller hans?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player hade en tung kväll. Går han runt med en smäll?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player hade inte sin kväll. Tänker du lägga en arm om honom?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player kämpade ikväll. Behåller han sin plats?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player hängde inte med i tempot. Vad tyckte du om hans match?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player var passagerare igen. Varför fortsätter du plocka med honom?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Alla såg att $player inte var med. Alla utom bänken?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Du sa att ni skulle vinna nästa, och det gjorde ni. Känns det bra att ha haft rätt?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Du lovade seger i nästa match och levererade. Självförtroende, eller skryt?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Du sa att ni skulle vinna nästa, och det gjorde ni. Tur, eller ska vi börja lyssna?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Du sa att ni skulle vinna den. Det hände inte. Vad gick fel?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Du sa att ni skulle vinna nästa. Det gjorde ni inte. Varför ska vi tro på nästa löfte?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Du sa att ni skulle vinna nästa. Det gjorde ni inte. Betyder dina ord något alls i det här rummet?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Du bad om att bli bedömd efter tre matcher, och du klarade det. Upprättelse?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Döm mig efter de tre nästa, sa du. Det gjorde vi, och resultaten kom. Vad lärde du dig av provet?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Du gav dig själv tre matcher och tog dig igenom dem. Var provet någonsin så hårt?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Du bad om att bli bedömd efter tre matcher. De gick inte din väg. Vad har du lärt dig?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Du sa döm mig efter de tre nästa. De tre är över, och det är också förtroendet. Vad nu?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Du satte provet och föll. Varför ska någon lita på ditt ord nu?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Du backade $player när andra inte gjorde det. Han levererade. Går en del av äran till dig?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Du backade $player. Han levererade. Tro, eller kunskap?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Du backade $player, och för en gångs skull lönade det sig. Blir du lika säker nästa gång?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Du stod bakom $player, och det har inte funkat. Tror du fortfarande på honom?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Du backade $player. Han har inte betalat tillbaka. Var det ett misstag?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Ditt omdöme eller din lojalitet: vilket svek med $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Du var hård mot $player, och matcherna sedan dess har gett dig rätt. Någon tillfredsställelse i det?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Du pekade ut $player, och han har inte svarat. Finns det en väg tillbaka för honom?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Du hängde ut $player och han har inte kommit tillbaka. Knäckte du honom?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Du pekade ut $player, och han svarade dig på planen. Var det meningen hela tiden?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Du skyllde på $player, och sedan dess har han varit en av dina bästa. Är du skyldig honom en ursäkt?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Du kastade $player under bussen, och han har varit din bäste spelare sedan dess. Tänker du be om ursäkt?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'De här spelarna gav mig allt. Jag skulle inte byta en enda av dem.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Ingen jobbar hårdare än den här gruppen. Jag försvarar dem hela dagen.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Du får inte höra ett ord mot mina spelare från den här stolen.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Spelarna förtjänar äran, inte jag. Skriv om dem.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Det här ligger på mig. Jag tog ut laget och jag ställde upp det.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Döm mig, inte dem. Det är mitt lag och mitt ansvar.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Om ni vill ha någon att skylla på sitter jag här.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Ansvaret är mitt. Lämna spelarna utanför.';

  @override
  String get pressReplyDemandMore1 =>
      'Jag vill ha mer. Några av dem vet exakt vad jag menar.';

  @override
  String get pressReplyDemandMore2 =>
      'Kämpaglöd räcker inte på den här nivån. Jag vill ha mer, och jag har sagt det till dem.';

  @override
  String get pressReplyDemandMore3 =>
      'Jag förväntar mig mer av var och en av dem, från och med imorgon.';

  @override
  String get pressReplyDemandMore4 =>
      'Några av dem måste se sig själva i spegeln. Jag är inte nöjd.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Vi vinner nästa. Det kan ni skriva upp.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Notera mina ord: vi vinner nästa match.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Nästa match vinner vi. Jag säger det här så att ni kan hålla mig till det.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Jag är säker på det här laget. Vi vinner nästa match.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Döm mig efter de tre nästa matcherna. Det är rimligt.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Ge mig tre matcher. Om det inte sitter då, döm mig efter det.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'De tre nästa visar om jag är rätt man. Håll mig till det.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Tre matcher. Sedan kan ni skriva vad ni vill om mig.';

  @override
  String get pressReplyDeflect1 =>
      'Vi tar en match i taget. Mer har jag inte att tillägga.';

  @override
  String get pressReplyDeflect2 => 'Jag tänker inte skapa rubriker åt er idag.';

  @override
  String get pressReplyDeflect3 => 'Nästa match. Det är allt jag tänker på.';

  @override
  String get pressReplyDeflect4 =>
      'Det jag tycker stannar i omklädningsrummet.';

  @override
  String get pressReplyTakeCredit1 =>
      'Jag sa det för att jag trodde på det, och jag hade rätt.';

  @override
  String get pressReplyTakeCredit2 =>
      'Jag läste det rätt. Det är därför jag är här.';

  @override
  String get pressReplyTakeCredit3 =>
      'Kalla det omdöme. Jag visste vad jag sa.';

  @override
  String get pressReplyTakeCredit4 =>
      'Jag tog beslutet och det gick hem. Det tar jag åt mig.';

  @override
  String get pressReplyStandByIt1 => 'Jag sa vad jag trodde. Jag står för det.';

  @override
  String get pressReplyStandByIt2 => 'Jag tar inte tillbaka ett ord.';

  @override
  String get pressReplyStandByIt3 =>
      'Samma svar som då. Jag menade det, och det gör jag fortfarande.';

  @override
  String get pressReplyStandByIt4 => 'Jag skulle säga det igen imorgon.';

  @override
  String get pressReplyAdmitMistake1 => 'Där hade jag fel. Det står jag för.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Rättvist nog, jag bedömde det fel. Jag lär mig av det.';

  @override
  String get pressReplyAdmitMistake3 => 'Jag hade fel, och det kan jag säga.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Det beslutet funkade inte, och det var mitt.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player har mitt fulla stöd. Han kommer att blomma ut.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Jag tror på $player, och han kommer att visa er varför.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Du får inte höra ett ord mot $player från mig. Han kommer att leverera.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player finns kvar i mina planer. Se vad han gör härnäst.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player svek oss ikväll, och han vet om det.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Jag förväntade mig betydligt mer av $player. Det måste han svara på.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player nådde inte upp till nivån. Det säger jag öppet.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Det var inte bra nog av $player, och det får han höra av mig.';
  }

  @override
  String get pressOnRecordWinNext => 'Officiellt: du vinner nästa match.';

  @override
  String get pressOnRecordJob =>
      'Officiellt: du ska bedömas efter de tre nästa.';

  @override
  String pressOnRecordBack(String player) {
    return 'Officiellt: du backar $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Officiellt: $player svek dig.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Han sa det, och det hände. $nation har en förbundskapten som menar vad han säger.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Sa det högt, och gick sedan och gjorde det. Det är mannen $nation behövde.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: han förutspådde det, och det slog in. Rättvist nog.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Han sa det offentligt och det höll. Poäng till honom. $nation går vidare.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Han fick en rätt. $nation, vänj dig inte.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Även en stannad klocka visar rätt två gånger om dagen. $nation hade tur den här gången.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Han sa det och det gick inte hem. Fortfarande med honom. $nation kör igen.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: han lovade mer än vi fick, men jag tar hellre en förbundskapten som tror på sig själv.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: han sa det offentligt och det hände inte. Folk kommer ihåg.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Stora ord, inget bakom. $nation: nästa gång, säg mindre.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Han stod där och berättade för oss. Sedan det här. $nation förtjänar bättre än prat.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Hans ord är värdelösa nu. Skriv upp det, $nation.';
  }

  @override
  String get ncZoneNorth => 'Nordzonen';

  @override
  String get ncZoneWest => 'Västzonen';

  @override
  String get ncZoneEast => 'Östzonen';

  @override
  String get ncZoneCentralSouthern => 'Centrala och södra zonen';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Mästare';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Tvåa';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Semifinalist';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Åttondelsfinal';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Kvartsfinalist';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Nå kvartsfinal';

  @override
  String get objectiveNcZoneWinGroup => 'Vinn din grupp';

  @override
  String get finishNcFinalsEight => 'Kvartsfinal';

  @override
  String get finishNcBottomHalf => 'Nedre halvan av gruppen';

  @override
  String get tourContTabZones => 'ZONER';

  @override
  String get tourContTabFinalsEight => 'UTSLAGNING';

  @override
  String get tourContFinalsEightSoon =>
      'Utslagsspelet startar i november med en åttondelsfinal: alla 14 gruppvinnare och de 2 bästa tvåorna.';

  @override
  String get tourContQuarterFinals => 'KVARTSFINALER';

  @override
  String get tourContZoneAdvancement =>
      'Varje gruppvinnare går vidare till åttondelsfinal, tillsammans med de 2 bästa tvåorna. Ingen flyttas ned.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Nordamerikanska Nations Cup';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica => 'Vinn Nordamerikanska Nations Cup';

  @override
  String get objectiveNcWinItAfrica => 'Vinn Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Nå final i Nordamerikanska Nations Cup';

  @override
  String get objectiveNcReachFinalAfrica => 'Nå final i Nations Cup';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Vinnare av Nordamerikanska Nations Cup';

  @override
  String get finishNcChampionsAfrica => 'Vinnare av Nations Cup';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Kvalet till $competition startar nu, och landet tror på det här laget. Vad siktar du på?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Ett nytt kval till $competition, och stämningen är hög. Hur långt kan det här laget nå?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Kvalet till $competition börjar. Vad är målet för den här kampanjen?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Kvalet till $competition är här. Var ser du det här laget sluta?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Kvalet till $competition startar, och många tvivlar på att ni tar er dit. Vad säger du till dem?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Ännu ett kval till $competition. Varför ska någon tro att det här blir annorlunda?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition är här och hela landet står bakom er. Hur långt kan ni nå?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Ni är i $competition och supportrarna drömmer. Vad är målet?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition startar den här veckan. Vad skulle räknas som en framgång?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Er första match i $competition närmar sig. Sätt ett mål åt oss.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition är här och ingen förväntar sig mycket. Vad hoppas du egentligen på?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Ni är i $competition, men tvivlen har inte försvunnit. Vad är ditt mål?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival är i er grupp. Oroar de dig?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Lottningen la $rival i er väg. Hur ser du på den matchen?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival verkar vara gruppens starkaste lag. Är de favoriter?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Vad tycker du om $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival är i er grupp. Var ärlig, klarar ni dem?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'De flesta räknar med att $rival slår er. Har de fel?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player är i fin form. Är det här hans ögonblick?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player är i varenda rubrik. Kan han bära det här laget?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Hur mycket hänger den här kampanjen på $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Är $player redo att leda det här laget?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Om $player inte är på topp, har det här laget något att komma med?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player har mycket på sina axlar. För mycket?';
  }

  @override
  String get pressReplyAimHigher1 => 'Vi går längre än någon räknar med.';

  @override
  String get pressReplyAimHigher2 =>
      'Jag vill ha mer än förbundet bad om, och jag säger det högt.';

  @override
  String get pressReplyMatchBrief1 =>
      'Vi känner till målet och vi kommer att nå det.';

  @override
  String get pressReplyMatchBrief2 =>
      'Förbundet satte ett mål. Vi kommer att leverera.';

  @override
  String get pressReplyPlayDown1 => 'Vi tar det en match i taget.';

  @override
  String get pressReplyPlayDown2 => 'Inga stora löften. Vi får se var vi står.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Vi kommer att kvalificera oss. Det kan ni skriva upp.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Det här laget kommer att vara med i slutspelet.';

  @override
  String get pressReplyFearNobody1 => 'Vi fruktar ingen.';

  @override
  String get pressReplyFearNobody2 => 'De måste spela mot oss också.';

  @override
  String get pressReplyRespectRival1 =>
      'De är favoriter, och vi respekterar dem.';

  @override
  String get pressReplyRespectRival2 =>
      'Ett mycket bra lag. Vi kommer att behöva vårt bästa.';

  @override
  String get pressReplyTeamFirst1 =>
      'Det handlar om hela laget, inte en spelare.';

  @override
  String get pressReplyTeamFirst2 => 'Ingen vinner det här ensam.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Officiellt: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Officiellt: inga löften.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Du satte ett mål före kampanjen och nådde det. Är det ditt stoltaste ögonblick hittills?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Du sa vad du skulle uppnå, och det gjorde du. Var det någonsin osäkert?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Du nådde målet du satte. Tur, eller var det verkligen planen?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Du satte ett mål och kom till korta. Vad gick fel?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Du lovade mer än det här laget levererade. Ångrar du att du sa det?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Du pratade stort före kampanjen och kom till korta. Varför ska vi tro dig nu?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Pressen vill höra dina mål för $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Nivå $level · $amount';
  }

  @override
  String get formOnFire => 'Glödhet';

  @override
  String get formGood => 'I form';

  @override
  String get formSteady => 'Stabil';

  @override
  String get formPoor => 'Ur form';

  @override
  String get formCold => 'Iskall';

  @override
  String get playerFormTitle => 'FORM OCH KONDITION';

  @override
  String playerFormAverage(String rating) {
    return 'I snitt $rating i hans senaste matcher';
  }

  @override
  String get playerFormNoGames => 'För få senaste matcher för att bedöma';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta på hans betyg nästa match';
  }

  @override
  String get playerFormNoEffect => 'Ingen förändring av hans betyg nästa match';

  @override
  String get sideGroupHome => 'Hem';

  @override
  String get sideGroupTeam => 'Lag';

  @override
  String get sideGroupCompetitions => 'Tävlingar';

  @override
  String get sideGroupFederation => 'Förbund';

  @override
  String get sideGroupHistory => 'Historia';

  @override
  String get sideInbox => 'Inkorg';

  @override
  String get sideSquad => 'Trupp';

  @override
  String get sideTactics => 'Taktik';

  @override
  String get sideMainMenu => 'Huvudmeny';

  @override
  String get sideCallUps => 'Uttagningar';

  @override
  String get sideTournaments => 'Turneringar';

  @override
  String get sideRanking => 'Ranking';

  @override
  String get sideResults => 'Resultat';

  @override
  String get sideFinances => 'Ekonomi';

  @override
  String get sideBoard => 'Styrelse';

  @override
  String get sideManager => 'Förbundskapten och stab';

  @override
  String get sideRecords => 'Rekord';

  @override
  String get sideLegends => 'Legender';

  @override
  String get sideHeadToHead => 'Inbördes möten';

  @override
  String get sideAchievements => 'Prestationer';

  @override
  String get sideCareer => 'Karriär';

  @override
  String get topBarNext => 'Nästa';

  @override
  String get topBarDrawPending => 'Lottning återstår';

  @override
  String get paneFullProfile => 'Hela profilen';

  @override
  String get panePickPlayer => 'Välj en spelare för att se hans kort här';

  @override
  String get inboxPickMessage => 'Välj ett meddelande för att läsa det här';

  @override
  String get inboxFilterAll => 'Alla';

  @override
  String get panelViewAll => 'Visa alla';

  @override
  String get gridViewOverview => 'Översikt';

  @override
  String get gridColCondition => 'Kondition';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Rank';

  @override
  String get gridColMove => 'Rörelse';

  @override
  String get gridColNation => 'Land';

  @override
  String get gridColRegion => 'Region';

  @override
  String get gridColPoints => 'Poäng';

  @override
  String get panePickNation => 'Välj ett land för att se dess meriter här';

  @override
  String get resultsCyclesTitle => 'Cykler';

  @override
  String get tourDrawStart => 'Starta lottningen';

  @override
  String get tourDrawViewGroups => 'Visa grupperna';

  @override
  String get gridColCeiling => 'Tak';

  @override
  String get gridColYearGain => 'Ökning';

  @override
  String get gridColMarkedAt => 'Vid markering';

  @override
  String get budgetSetupTitle => 'Sätt din budget';

  @override
  String get budgetEffectsTitle => 'Vad budgeten ger';

  @override
  String get naturalisationTitle => 'Naturalisering';

  @override
  String get yTrending => 'Trendar';

  @override
  String get yVoices => 'Röster';

  @override
  String get yConversation => 'Samtal';

  @override
  String get allTimeRecordsTitle => 'Världsrekord genom tiderna';

  @override
  String get h2hMeetingsTitle => 'Alla möten';

  @override
  String get h2hPickOpponent => 'Välj en motståndare för att se alla möten här';

  @override
  String get savesTitle => 'Sparfiler';

  @override
  String get gridColPlayer => 'Spelare';

  @override
  String get gridColPos => 'Pos';

  @override
  String get gridColActive => 'Aktiv';

  @override
  String get gridColMotm => 'MOTM';

  @override
  String get gridColAvg => 'Snitt';

  @override
  String get gridColOpponent => 'Motståndare';

  @override
  String get gridColStarts => 'Start';

  @override
  String get gridColTournaments => 'Turneringar';

  @override
  String get gridColDate => 'Datum';

  @override
  String get gridColLastPlayed => 'Senast spelad';

  @override
  String get gridColManager => 'Förbundskapten';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count länder',
      one: '1 land',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Sorterat efter världsranking';

  @override
  String get nationsStrength => 'Styrka';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier av 5';
  }

  @override
  String get nationsSquadOverall => 'Truppens helhetsbetyg';

  @override
  String get nationsOpeningBudget => 'Startbudget';

  @override
  String get nationsStarPlayer => 'Stjärnspelare';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Stjärna $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Ålder $age';
  }

  @override
  String get nationsBoardExpects => 'Styrelsen förväntar sig';

  @override
  String nationsManage(String nation) {
    return 'Led $nation';
  }

  @override
  String get nationsManagerNext => 'Du namnger din förbundskapten härnäst';

  @override
  String get playerPageTitle => 'Spelare';

  @override
  String get nationPageTitle => 'Land';

  @override
  String get friendliesYourGames => 'Dina träningsmatcher';

  @override
  String hubEventInjuryCover(String player) {
    return 'Ersätt den skadade $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Borta i $matches matcher',
      one: 'Borta i nästa match',
    );
    return '$_temp0. Ta ut någon, eller spela vidare utan honom.';
  }

  @override
  String get injuryCoverTitle => 'ERSÄTTARE';

  @override
  String injuryCoverBanner(String player) {
    return '$player är skadad. Ta ut vem som helst utanför truppen, på vilken position som helst, eller behåll honom och spela vidare.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Ta ut $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Behåll $player och spela vidare';
  }

  @override
  String get injuryCoverPick => 'Välj en ersättare';

  @override
  String get injuryCoverNone => 'Ingen utanför truppen är fit nog att ansluta.';

  @override
  String get nationNowRanking => 'Världsranking';

  @override
  String get nationNowForm => 'Form';

  @override
  String get nationNowNoForm => 'Inga matcher spelade än';

  @override
  String get nationNowNext => 'Nästa match';

  @override
  String get nationNowNoNext => 'Inget inplanerat';

  @override
  String get nationNowSquad => 'Trupp';

  @override
  String get nationNowAgainstYou => 'Mot dig';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}V ${d}O ${l}F';
  }

  @override
  String get nationNowLastMeeting => 'Senaste mötet';

  @override
  String nationNowOverall(int value) {
    return 'Helhetsbetyg $value';
  }

  @override
  String get hubUpcoming => 'KOMMANDE';

  @override
  String get hubFullSchedule => 'Hela schemat';

  @override
  String get scheduleTitle => 'Schema';

  @override
  String get scheduleToday => 'Idag';

  @override
  String get scheduleKnockoutPending => 'Utslagsspel, om ni går vidare';

  @override
  String get scheduleNextRoundPending => 'Nästa omgång';

  @override
  String scheduleFromDate(String date) {
    return 'Från $date';
  }

  @override
  String get scheduleHomeShort => 'H';

  @override
  String get scheduleAwayShort => 'B';

  @override
  String get tacticsNoPresetsInMatch =>
      'Inga sparade taktiker än. Spara en från taktikskärmen före matchen.';

  @override
  String get homeCampaigns => 'Kampanjer';

  @override
  String get homeContinueCampaign => 'FORTSÄTT KAMPANJEN';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Cykel $cycle av $total';
  }

  @override
  String get campaignsTitle => 'Kampanjer';

  @override
  String get campaignTransplantTitle => 'Transplantationen';

  @override
  String get campaignTransplantTwist =>
      'Åtta av Italiens bästa byter landslag till San Marino';

  @override
  String get campaignTransplantGoal => 'Kvalificera dig för Europamästerskapet';

  @override
  String get campaignGrudgeTitle => 'Gammalt agg';

  @override
  String get campaignGrudgeTwist => 'Georgien och Albanien, lottade ihop';

  @override
  String get campaignGrudgeGoal => 'Sluta före Albanien i kvalet';

  @override
  String get campaignTransplantIntro =>
      'San Marino har aldrig haft ett kval värt namnet. Sedan tar åtta av Italiens bästa det nya passet och går in. Du har en cykel på dig att göra en kuriositet till ett lag.';

  @override
  String get campaignGrudgeIntro =>
      'Georgien och Albanien har lottats i samma kvalgrupp, och ingen av dem förlåter en förlust. Sluta före Albanien, och se sedan hur långt du kan bära det.';

  @override
  String get campaignStars1Transplant => 'Kvalificera dig';

  @override
  String get campaignStars2Transplant => 'Nå utslagsspelet';

  @override
  String get campaignStars3Transplant => 'Vinn Europamästerskapet';

  @override
  String get campaignStars1Grudge => 'Före Albanien';

  @override
  String get campaignStars2Grudge => 'Och kvalificera dig';

  @override
  String get campaignStars3Grudge => 'Och slå dem två gånger';

  @override
  String get campaignFree => 'Gratis';

  @override
  String get campaignStart => 'Starta';

  @override
  String get campaignPartOfUnlimited => 'Ingår i Unlimited';

  @override
  String get campaignResume => 'Fortsätt';

  @override
  String get campaignAbandon => 'Ge upp';

  @override
  String get campaignAbandonConfirm =>
      'Ge upp det här försöket? Dess framsteg går förlorade; din stämpel finns kvar.';

  @override
  String get campaignMoveToSaves => 'Flytta till sparfiler';

  @override
  String get campaignCannotContinue =>
      'Den här kampanjens värld har kommit för långt från den verkliga för att kunna fortsätta som karriär.';

  @override
  String get campaignMoveSlotsFull =>
      'Dina sparplatser är fulla. Frigör en först.';

  @override
  String get campaignStampConquered => 'Erövrad';

  @override
  String get campaignStampFailed => 'Misslyckad';

  @override
  String get campaignDifficultyHard => 'Svår';

  @override
  String get campaignDifficultyMedium => 'Medel';

  @override
  String get campaignGoalLabel => 'Mål';

  @override
  String get campaignStarsLabel => 'Stjärnor';

  @override
  String get campaignRunInProgress =>
      'Den här kampanjen har redan ett försök igång.';

  @override
  String get campaignVerdictWon => 'Erövrad';

  @override
  String get campaignVerdictLost => 'Inte den här gången';

  @override
  String get campaignVerdictContinue => 'Fortsätt';

  @override
  String campaignProgressQualifying(String position) {
    return 'Kval: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Slutspel: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Försöket i siffror';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Vunna möten: $won av $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1:a',
        'second': '2:a',
        'third': '3:e',
        'other': '$n:e',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Bäst bland Guineorna';

  @override
  String get campaignGuineasTwist =>
      'Ekvatorialguinea, Afrikas lägst rankade Guinea, i två cykler';

  @override
  String get campaignGuineasGoal => 'Slå Guinea och Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Tre afrikanska länder bär namnet Guinea, och Ekvatorialguinea är lägst rankat av dem. Du har två cykler på dig att slå Guinea och Guinea-Bissau minst en gång vardera, och sedan se hur långt du kan nå i Afrikamästerskapet. Papua Nya Guinea, den fjärde Guineon, är redan bokat för en träningsmatch.';

  @override
  String get campaignStars1Guineas => 'Slå Guinea och Guinea-Bissau';

  @override
  String get campaignStars2Guineas =>
      'Och kvalificera dig för ett Afrikamästerskap';

  @override
  String get campaignStars3Guineas =>
      'Och nå kvartsfinal i ett Afrikamästerskap';

  @override
  String get campaignYoungFinnsTitle => 'De unga finnarna';

  @override
  String get campaignYoungFinnsTwist =>
      'Finlands gyllene generation tonåringar, i tre cykler';

  @override
  String get campaignYoungFinnsGoal => 'Kvalificera dig för ett VM';

  @override
  String get campaignYoungFinnsIntro =>
      'Finlands seniorspelare har klivit åt sidan och en gyllene generation har tagit deras plats: varje spelare du kan välja är 18 år eller yngre. Än så länge är de ohyfsade, men de har talangen att bli ett av världens bästa lag, precis som Norges unga generation blev. Du har tre cykler på dig att ta dem till ett VM, och sedan vinna Europamästerskapet och Världsmästerskapet.';

  @override
  String get campaignStars1YoungFinns => 'Kvalificera dig för ett VM';

  @override
  String get campaignStars2YoungFinns => 'Vinn Europamästerskapet';

  @override
  String get campaignStars3YoungFinns => 'Vinn Världsmästerskapet';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Missade kvalet';

  @override
  String get campaignCupOpen => 'Återstår att avgöra';
}
