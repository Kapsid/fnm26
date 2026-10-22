// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get matchPreviewTitle => 'KAMPOPTAKT';

  @override
  String get matchKickOff => 'Anspark';

  @override
  String get matchTactics => 'Taktik';

  @override
  String get matchYourXi => 'DIN STARTOPSTILLING';

  @override
  String get matchHeadToHead => 'OPGØRET MELLEM JER';

  @override
  String matchCouldNotLoad(String error) {
    return 'Kampen kunne ikke indlæses.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Ingen kommende kamp.';

  @override
  String get matchUnknownNation => 'Ukendt';

  @override
  String get matchH2hFirstMeeting => 'Første opgør nogensinde';

  @override
  String get matchH2hYouLead => 'Du fører i de indbyrdes opgør';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent har overtaget';
  }

  @override
  String get matchH2hEven => 'Lige op';

  @override
  String matchH2hMet(int count) {
    return '$count opgør';
  }

  @override
  String get matchH2hWon => 'Vundet';

  @override
  String get matchH2hDrawn => 'Uafgjort';

  @override
  String get matchH2hLost => 'Tabt';

  @override
  String get matchDossierTitle => 'Spejderrapport';

  @override
  String get matchDossierForm => 'FORM';

  @override
  String get matchDossierNoGames => 'Ingen seneste kampe';

  @override
  String get matchDossierKeyMen => 'NØGLESPILLERE';

  @override
  String matchCouldNotContinue(String error) {
    return 'Kunne ikke fortsætte: $error';
  }

  @override
  String get matchSkipToFullTime => 'Spol frem til slutfløjt';

  @override
  String get matchStatShots => 'Skud';

  @override
  String get matchStatGoals => 'Mål';

  @override
  String get matchStatYellowCards => 'Gule';

  @override
  String get matchStatRedCards => 'Røde';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'ANG';

  @override
  String get matchSwingDef => 'FOR';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'VERDENSMESTERSKABET $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'SLUTRUNDEN ER HER';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'VÆRT:  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'VÆRT ENDNU IKKE BEKRÆFTET';

  @override
  String get matchHalfTime => 'PAUSE';

  @override
  String get matchContinue => 'Fortsæt';

  @override
  String get matchContinuing => 'Fortsætter…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktik · $used/$max skift';
  }

  @override
  String matchTiredCount(int count) {
    return 'TRÆTTE ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIK';

  @override
  String get teamOverallOverTime => 'SAMLET STYRKE OVER TID';

  @override
  String get teamOverall => 'Samlet styrke';

  @override
  String get teamTalkHeading => 'HOLDTALE';

  @override
  String get teamTalkPrompt => 'Sæt tonen for anden halvleg.';

  @override
  String get teamTalkCalmLabel => 'Rolige hoveder';

  @override
  String get teamTalkCalmBlurb =>
      'Få holdet til at falde til ro. Et lille løft hele vejen rundt.';

  @override
  String get teamTalkEncourageLabel => 'Opmuntring';

  @override
  String get teamTalkEncourageBlurb => 'Pres frem og gå efter kampen.';

  @override
  String get teamTalkDemandMoreLabel => 'Kræv mere';

  @override
  String get teamTalkDemandMoreBlurb => 'Giv alt, hvad I har. Angrib hårdt.';

  @override
  String get teamTalkPraiseLabel => 'Hold tæt';

  @override
  String get teamTalkPraiseBlurb => 'Stå kompakt og forsvar det, I har.';

  @override
  String get teamTalkBelieveLabel => 'Tro på det';

  @override
  String get teamTalkBelieveBlurb =>
      'Tro på jer selv. Et løft i begge ender af banen.';

  @override
  String get teamTalkFocusLabel => 'Vær skarpe';

  @override
  String get teamTalkFocusBlurb => 'Fuld koncentration. Luk kampen ned.';

  @override
  String get teamTalkUrgencyLabel => 'Mere tempo';

  @override
  String get teamTalkUrgencyBlurb =>
      'Jag den nu. Alt på spil, og det efterlader huller.';

  @override
  String get teamTalkReassureLabel => 'Ingen pres';

  @override
  String get teamTalkReassureBlurb => 'Få ro på nerverne og hold formationen.';

  @override
  String get commonRetry => 'Prøv igen';

  @override
  String get commonSomethingWentWrong => 'Noget gik galt';

  @override
  String get commonCrashBox =>
      'Noget gik galt her.\nIndstillinger → Diagnostik har detaljerne.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Kunne ikke spole verden frem: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostik';

  @override
  String get settingsDiagnosticsBlurb =>
      'Fejl registreret på denne enhed. Intet sendes nogen steder hen.';

  @override
  String get settingsContactTitle => 'Kontakt';

  @override
  String get settingsContactCopied => 'Adresse kopieret.';

  @override
  String get settingsCommunityTitle => 'Fællesskab';

  @override
  String get settingsDiscordSubtitle => 'Bliv en del af fællesskabet';

  @override
  String get settingsLinkCopied => 'Link kopieret.';

  @override
  String get diagnosticsEmpty => 'Ingen fejl registreret. Det er meningen.';

  @override
  String get diagnosticsCopy => 'Kopiér';

  @override
  String get diagnosticsCopied => 'Loggen er kopieret til udklipsholderen.';

  @override
  String get diagnosticsClear => 'Ryd';

  @override
  String get navHub => 'Forside';

  @override
  String get navSquad => 'Trup';

  @override
  String get navStandings => 'Stilling';

  @override
  String get navCareers => 'Min karriere';

  @override
  String get settingsTitle => 'INDSTILLINGER';

  @override
  String get settingsSoundHapticsTitle => 'Lyd og vibration';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibration og en kort tone ved mål, anspark og slutfløjt.';

  @override
  String get settingsLanguageTitle => 'Sprog';

  @override
  String get settingsLanguageBlurb =>
      'Vælg appens sprog, eller følg din enhed.';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get matchPreviewAllMeetings => 'Alle opgør';

  @override
  String get recordsMeetings => 'OPGØR';

  @override
  String get recordsLegends => 'LEGENDER';

  @override
  String get recordsAllTimeXi => 'ALLE TIDERS HOLD';

  @override
  String get recordsHallOfFame => 'HALL OF FAME';

  @override
  String get recordsAllTimeWorld => 'ALLE TIDER, VERDEN';

  @override
  String get recordsAllTimeTopScorers => 'ALLE TIDERS TOPSCORERE';

  @override
  String get recordsMostCapped => 'FLEST LANDSKAMPE';

  @override
  String get recordsMostWcStarts => 'FLEST STARTER I VM';

  @override
  String get recordsMostTournaments => 'FLEST TURNERINGER';

  @override
  String get recordsRecordBook => 'REKORDBOG';

  @override
  String get recordsHeadToHead => 'OPGØRET MELLEM JER';

  @override
  String get recordsFiercestRival => 'STÆRKESTE RIVAL';

  @override
  String get recordsMostCaps => 'FLEST LANDSKAMPE';

  @override
  String get recordsTopScorers => 'TOPSCORERE';

  @override
  String get recordsMostAssists => 'FLEST ASSISTS';

  @override
  String get recordsYourRecord => 'DIN REKORD';

  @override
  String get callUpHome => 'HJEMME';

  @override
  String get callUpAway => 'UDE';

  @override
  String get recordsHome => 'HJEMME';

  @override
  String get recordsAway => 'UDE';

  @override
  String get recordsActive => 'AKTIV';

  @override
  String get recordsStillActive => 'Stadig aktiv';

  @override
  String get recordsAvg => 'gns.';

  @override
  String get recordsSelect => 'Vælg';

  @override
  String get recordsVs => 'mod';

  @override
  String get recordsDraws => 'Uafgjort';

  @override
  String get recordsGoalsLabel => 'Mål';

  @override
  String get recordsBestFinish => 'Bedste placering';

  @override
  String get recordsNoFinalsYet => 'Endnu ingen slutrunde';

  @override
  String get recordsLongestUnbeaten => 'Længste ubesejrede stime';

  @override
  String get recordsBiggestWin => 'Største sejr';

  @override
  String get recordsSeeAllMeetings => 'Se alle opgør';

  @override
  String get recordsSaveNotFound => 'Gemt spil ikke fundet.';

  @override
  String get recordsNoMatches => 'Ingen kampe.';

  @override
  String get recordsSearchPlayerOrNation => 'Søg spiller eller land';

  @override
  String get recordsSearchNation => 'Søg land';

  @override
  String get recordsPickTwoDifferent => 'Vælg to forskellige lande.';

  @override
  String get recordsPlayToBuildRecord =>
      'Spil nogle kampe, så bygges din rekord mod hver modstander op her.';

  @override
  String get recordsTapOpponent => 'Tryk på en modstander for hele opgørelsen.';

  @override
  String get recordsEdgeUpperHand => 'Du har overtaget';

  @override
  String get recordsEdgeTheirNumber => 'De har dit nummer';

  @override
  String get recordsEdgeEven => 'Lige op';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Globale scorere og flest landskampe, alle lande';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Sammenlign to landes rekord gennem tiderne';

  @override
  String get recordsLegendsSubtitle => 'Alle tiders hold og hall of fame';

  @override
  String get recordsUnitGoals => 'mål';

  @override
  String get recordsUnitCaps => 'landskampe';

  @override
  String get recordsUnitStarts => 'starter';

  @override
  String get recordsUnitCups => 'turneringer';

  @override
  String get recordsUnitAssists => 'assists';

  @override
  String recordsCapsCount(int count) {
    return '$count landskampe';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count mål';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count assists';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count KS';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count kampe';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count opgør';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code sejre';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings opgør · ${wins}V ${draws}U ${losses}T';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}V ${draws}U ${losses}T';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings opgør · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a og $b har aldrig mødt hinanden i dette gemte spil.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names er udvist. Ingen afløser, så I spiller én mand færre.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Kræver $required tilgængelige ($have raske)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Misser $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Ude hele udtagelsen';

  @override
  String get rankingCentreOnMe => 'Centrér på mit land';

  @override
  String get recordsAfterExtraTime => 'e.o.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b str.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a mod $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played spillet · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga mod $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Kunne ikke indlæses.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Legender kunne ikke indlæses.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Rekorder kunne ikke indlæses.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Lande kunne ikke indlæses.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Din rekord kunne ikke indlæses.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Rekorden kunne ikke indlæses.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Ingen legender endnu. Spil nogle kampagner færdige, så dukker de største navne for $nation op her.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Det bedste hold, $nation nogensinde har kunnet stille.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Verden har ingen historie endnu. Spil nogle kampagner færdige, så dukker alle tiders største navne op her.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Spil nogle kampe for at begynde at skrive historien for $nation.';
  }

  @override
  String get tacticsLineGk => 'MM';

  @override
  String get tacticsLineDef => 'FO';

  @override
  String get tacticsLineMid => 'MB';

  @override
  String get tacticsLineFwd => 'AN';

  @override
  String get tacticsGoalkeepers => 'MÅLMÆND';

  @override
  String get tacticsDefenders => 'FORSVARSSPILLERE';

  @override
  String get tacticsMidfielders => 'MIDTBANESPILLERE';

  @override
  String get tacticsForwards => 'ANGRIBERE';

  @override
  String get tacticsCallUpsTitle => 'UDTAGELSER';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Vælg mindst $min spillere.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Truppen kunne ikke indlæses.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Ingen trup.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'TRUP · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min. $min · Maks. $max';
  }

  @override
  String get tacticsBestQuality => 'Bedste kvalitet';

  @override
  String get tacticsPreviousSquad => 'Forrige trup';

  @override
  String get tacticsSquadLockedBack => 'Tilbage (trup låst)';

  @override
  String get tacticsConfirmSquad => 'Aflever truppen';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Truppen er fuld (maks. $max)';
  }

  @override
  String get tacticsSquadLocked => 'TRUP LÅST';

  @override
  String get tacticsNominationOpen => 'UDTAGELSEN ER ÅBEN. VÆLG DIN TRUP';

  @override
  String get tacticsSquadFixedBlurb =>
      'Truppen er fastlagt til kampene nedenfor. Vælg den igen inden næste udtagelsesvindue.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Denne trup spiller kampene nedenfor.';

  @override
  String get tacticsUnknown => 'Ukendt';

  @override
  String tacticsAgeValue(int age, String value) {
    return '$age år · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Udmattet';

  @override
  String get tacticsFatigueTired => 'Træt';

  @override
  String get tacticsFatigueMatchLegs => 'Kampben';

  @override
  String tacticsTooManySubs(int max) {
    return 'For mange udskiftninger (maks. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIK · $minute\'';
  }

  @override
  String get tacticsApply => 'BRUG';

  @override
  String get tacticsTabLineupSubs => 'OPSTILLING OG SKIFT';

  @override
  String get tacticsTabTactics => 'TAKTIK';

  @override
  String get squadLineKeepers => 'MÅLMÆND';

  @override
  String get squadLineDefenders => 'FORSVAR';

  @override
  String get squadLineMidfielders => 'MIDTBANE';

  @override
  String get squadLineForwards => 'ANGREB';

  @override
  String get squadStatXiRating => 'Holdstyrke';

  @override
  String get squadStatAvgAge => 'Gns. alder';

  @override
  String get squadStatSize => 'Trup';

  @override
  String get squadStatUnavailable => 'Ude';

  @override
  String get squadDepthTitle => 'DYBDE PR. LINJE';

  @override
  String squadAgeShort(int age) {
    return '$age år';
  }

  @override
  String get tacticsTabOtherPositions => 'ANDRE PLADSER';

  @override
  String get tacticsOutOfPositionNote => 'Ude af position her';

  @override
  String get tacticsNobodyElse => 'Ingen andre at prøve her.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Vælg, hvem der går af, så dukker resten af bænken op her, med hvad de ville spille pladsen til.';

  @override
  String get tacticsTabSuitable => 'EGNEDE';

  @override
  String get tacticsTabOnPitch => 'PÅ BANEN';

  @override
  String tacticsSectionSuitable(int count) {
    return 'EGNEDE · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Ingen på bænken passer naturligt til pladsen, så her er alle.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'PÅ BANEN · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'TILGÆNGELIGE · $count';
  }

  @override
  String get tacticsRowStarted => 'Startede';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Ind i $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Kom ind';

  @override
  String get tacticsEnergyLabel => 'ENERGI';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Tryk på en afløser for $name, eller tryk på ham igen for at fortryde.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Et rødt kort kostede dig denne plads. Træk en holdkammerat herhen for at flytte hullet.';

  @override
  String get tacticsSentOffShort => 'UDVIST';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'SKIFT · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Tryk på en mand på banen for at tage ham af, eller hold og træk en indskifter hen på ham.';

  @override
  String get tacticsNoSubs => 'Ingen indskiftere til rådighed.';

  @override
  String get tacticsChooseShape => 'VÆLG EN FORMATION';

  @override
  String get tacticsFormation => 'FORMATION';

  @override
  String get tacticsInstructions => 'INSTRUKSER';

  @override
  String get tacticsDrilling => 'INDØVELSE';

  @override
  String get tacticsDrillingUnplayed => 'UPRØVET';

  @override
  String get tacticsDrillingNew => 'NY';

  @override
  String get tacticsDrillingSettling => 'FALDER PÅ PLADS';

  @override
  String get tacticsDrillingDrilled => 'INDØVET';

  @override
  String get tacticsInstrMentality => 'Mentalitet';

  @override
  String get tacticsInstrDefensive => 'Defensiv';

  @override
  String get tacticsInstrAttacking => 'Offensiv';

  @override
  String get tacticsInstrPressing => 'Pres';

  @override
  String get tacticsInstrLowBlock => 'Lav blok';

  @override
  String get tacticsInstrHighPress => 'Højt pres';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Tålmodigt';

  @override
  String get tacticsInstrFast => 'Hurtigt';

  @override
  String get tacticsInstrWidth => 'Bredde';

  @override
  String get tacticsInstrNarrow => 'Smal';

  @override
  String get tacticsInstrWide => 'Bred';

  @override
  String get tacticsInstrDefLine => 'Forsvarslinje';

  @override
  String get tacticsInstrDefensiveLine => 'Forsvarslinje';

  @override
  String get tacticsInstrDeep => 'Dyb';

  @override
  String get tacticsInstrHigh => 'Høj';

  @override
  String get tacticsInstrDirectness => 'Direkte spil';

  @override
  String get tacticsInstrPossession => 'Boldbesiddelse';

  @override
  String get tacticsInstrDirect => 'Direkte';

  @override
  String get tacticsPickGoalkeeper => 'VÆLG MÅLMAND';

  @override
  String get tacticsPickLeftBack => 'VÆLG VENSTRE BACK';

  @override
  String get tacticsPickCentreBack => 'VÆLG MIDTERFORSVARER';

  @override
  String get tacticsPickRightBack => 'VÆLG HØJRE BACK';

  @override
  String get tacticsPickDefensiveMid => 'VÆLG DEFENSIV MIDTBANESPILLER';

  @override
  String get tacticsPickCentralMid => 'VÆLG CENTRAL MIDTBANESPILLER';

  @override
  String get tacticsPickAttackingMid => 'VÆLG OFFENSIV MIDTBANESPILLER';

  @override
  String get tacticsPickLeftMid => 'VÆLG VENSTRE MIDTBANESPILLER';

  @override
  String get tacticsPickRightMid => 'VÆLG HØJRE MIDTBANESPILLER';

  @override
  String get tacticsPickLeftWing => 'VÆLG VENSTRE FLØJ';

  @override
  String get tacticsPickRightWing => 'VÆLG HØJRE FLØJ';

  @override
  String get tacticsPickStriker => 'VÆLG ANGRIBER';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · ude af position';
  }

  @override
  String tacticsAgeOnly(int age) {
    return '$age år';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · $age år';
  }

  @override
  String get tacticsOn => 'PÅ';

  @override
  String get tacticsSquad => 'TRUP';

  @override
  String get tacticsTabLineup => 'OPSTILLING';

  @override
  String get tacticsTabInstructions => 'INSTRUKSER';

  @override
  String get tacticsTabRoles => 'ROLLER';

  @override
  String get tacticsTabSetPieces => 'DØDBOLDE';

  @override
  String get tacticsTabRolesSetPieces => 'ROLLER OG DØDBOLDE';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Giv hver startspiller en rolle. Tryk på straffespark (⚽) eller frispark (▲) for at udpege din skytte.';

  @override
  String get tacticsTooltipCallUps => 'Udtagelser';

  @override
  String get tacticsTooltipPresets => 'Taktikforslag';

  @override
  String get tacticsTooltipInstructions => 'Instrukser';

  @override
  String get tacticsNoTacticSet => 'Ingen taktik valgt.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ERSTAT $count STARTSPILLERE',
      one: 'ERSTAT $count STARTSPILLER',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Ude';

  @override
  String get tacticsTapSpotReplace =>
      'Tryk på hans plads på banen for at vælge en afløser.';

  @override
  String get tacticsTapOrDrag =>
      'Tryk på en spiller for at bytte ham ud, eller hold og træk for at flytte ham.';

  @override
  String get tacticsPlayerRoles => 'SPILLERROLLER';

  @override
  String get tacticsRolesBlurb =>
      'Giv en spiller en opgave: en målrøver, en spilfordeler, en targetspiller. Det præger, hvem der scorer, og hvem der skaber.';

  @override
  String get tacticsSetPieceTakers => 'DØDBOLDSSKYTTER';

  @override
  String get tacticsSetPieceBlurb =>
      'Hvem der tager straffespark og dødbolde, eller overlad det til den bedst egnede spiller.';

  @override
  String get tacticsTakerAuto => 'Automatisk';

  @override
  String get tacticsTakerQuickPick => 'Brug bedste skytter';

  @override
  String get tacticsPenalties => 'Straffespark';

  @override
  String get tacticsCornersFreeKicks => 'Hjørnespark og frispark';

  @override
  String get tacticsSkillFin => 'AFS';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROLLE · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'STRAFFESPARKSSKYTTE';

  @override
  String get tacticsCornerFreeKickTaker => 'HJØRNE- OG FRISPARKSSKYTTE';

  @override
  String get tacticsAutomatic => 'Automatisk';

  @override
  String get tacticsLetBestSuited => 'Lad den bedst egnede spiller tage det.';

  @override
  String get tacticsInXi => 'I STARTOPST.';

  @override
  String get tacticsTeamInstructions => 'HOLDINSTRUKSER';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Bestem, hvordan dit hold spiller. Hvert greb påvirker hele holdet.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Gemte “$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Brugte “$name”';
  }

  @override
  String get tacticsTacticPresets => 'TAKTIKFORSLAG';

  @override
  String get tacticsPresetsBlurb =>
      'Gem denne formation som en genbrugelig stil, eller brug en, du har gemt før.';

  @override
  String get tacticsSaveCurrentTactic => 'Gem nuværende taktik';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Taktikforslag kunne ikke indlæses.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Ingen taktikforslag endnu. Tryk på “Gem nuværende taktik” for at gemme denne opsætning som en genbrugelig stil.';

  @override
  String get tacticsNameThisTactic => 'Giv taktikken et navn';

  @override
  String get tacticsNameHint => 'fx Højt pres 4-3-3';

  @override
  String get tacticsCancel => 'Annuller';

  @override
  String get tacticsSave => 'Gem';

  @override
  String get tacticsTapToAssign => 'Tryk for at tildele';

  @override
  String get tacticsHoldDragSub =>
      'Hold en indskifter, og træk ham hen på en spiller for at sende ham på banen.';

  @override
  String get hubContinue => 'Fortsæt';

  @override
  String get hubBrackets => 'Turneringsskema';

  @override
  String hubCouldNotLoad(String error) {
    return 'Kunne ikke indlæses.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Økonomien kunne ikke indlæses.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Det gemte spil kunne ikke indlæses.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Gemt spil ikke fundet.';

  @override
  String get hubUnknown => 'Ukendt';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year VERDENSMESTRE';
  }

  @override
  String get hubCycleComplete => 'Cyklussen er fuldført.';

  @override
  String get hubYourJob => 'DIT JOB';

  @override
  String get hubStayProject => 'Bliv og fortsæt dit projekt';

  @override
  String get hubChooseNextJob => 'VÆLG DIT NÆSTE JOB';

  @override
  String get hubOffersOnTable => 'TILBUD PÅ BORDET';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · verden nr. $position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Fortsæt med $nation';
  }

  @override
  String get hubYourNation => 'dit land';

  @override
  String get hubTakeTheJob => 'Tag jobbet';

  @override
  String get hubFederationFinances => 'FORBUNDETS ØKONOMI';

  @override
  String get hubBudgetIntro =>
      'Dit første job i næste cyklus er at fastsætte forbundsbudgettet og fordele det på afdelingerne.';

  @override
  String get hubStarting => 'Starter…';

  @override
  String get hubBeginNextCycle => 'Begynd næste cyklus';

  @override
  String get hubContinueCareer => 'Fortsæt din karriere';

  @override
  String get hubBackToSaves => 'Tilbage til dine gemte spil';

  @override
  String get hubOpeningBalance => 'Primo saldo';

  @override
  String get hubCentralFunding => 'Central støtte';

  @override
  String get hubPrizeMoney => 'Præmiepenge';

  @override
  String get hubCommercialReturn => 'Kommercielt afkast';

  @override
  String get hubAvailableToInvest => 'Til rådighed at investere';

  @override
  String hubReputation(String label, int rep) {
    return 'Omdømme: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Nationalhelt';

  @override
  String get hubFinal => 'Finale';

  @override
  String get hubStageRoundOf32 => '1/16-finale';

  @override
  String get hubStageThirdPlace => 'Bronzekamp';

  @override
  String get hubEventAdvanceWorld => 'Spol verden frem';

  @override
  String hubEventStartCycle(int year) {
    return 'Start $year-cyklussen';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation er verdensmestre';
  }

  @override
  String get hubEventSetBudget => 'Fastsæt dit forbundsbudget';

  @override
  String get hubEventSetBudgetSub =>
      'Fordel cyklussens krigskasse, før sæsonen begynder';

  @override
  String get hubEventNaturalization => 'Gennemgå naturalisationstilbud';

  @override
  String get hubEventNaturalizationSub =>
      'En udenlandsk spiller vil skifte landsholdsfarver til dig';

  @override
  String get hubEventCampaignVerdict => 'Kampagnen er afgjort: se dommen';

  @override
  String get hubEventCampaignComplete => 'Kampagnen er fuldført';

  @override
  String get hubEventIntercontinentalPlayoff =>
      'Det interkontinentale play-off';

  @override
  String get hubEventWatchWcDraw => 'Se lodtrækningen til Verdensmesterskabet';

  @override
  String get hubEventWorldCupHere => 'Verdensmesterskabet er i gang';

  @override
  String get hubEventWatchFinalsDraw => 'Se lodtrækningen til slutrunden';

  @override
  String get hubEventFinalsHere => 'Slutrunden er her';

  @override
  String get hubEventPlayWcRound => 'Spil næste runde i Verdensmesterskabet';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Spil næste kamp i $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch => 'Spil næste Nations Cup-kamp';

  @override
  String get hubEventWatchNationsCupDraw => 'Se lodtrækningen til Nations Cup';

  @override
  String get hubEventWatchHostSelection => 'Se udvælgelsen af værtsland';

  @override
  String get hubEventWatchQualifyingDraw =>
      'Se lodtrækningen til kvalifikationen';

  @override
  String get hubEventWatchWcHostSelection =>
      'Se udvælgelsen af værtsland til Verdensmesterskabet';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Se lodtrækningen til VM-kvalifikationen';

  @override
  String get hubEventArrangeFriendlies => 'Arrangér venskabskampe';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du har ikke fyldt dine $count åbne venskabskampsvinduer endnu',
      one: 'Du har ikke fyldt dit åbne venskabskampsvindue endnu',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Omform din startopstilling';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count af din startopstilling er ude (suspenderet eller skadet). Vælg afløsere',
      one:
          '1 af din startopstilling er ude (suspenderet eller skadet). Vælg en afløser',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Din startopstilling er for kort. Fyld de ledige pladser',
      one: 'Din startopstilling er for kort. Fyld den ledige plads',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Spil mod $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'kontinentets slutrunde';

  @override
  String get hubCallUpFriendlies => 'Udtag din trup til venskabskampene';

  @override
  String get hubCallUpRequalify => 'Udtag din kvalifikationstrup igen';

  @override
  String get hubCallUpWorldCup => 'Udtag din trup til Verdensmesterskabet';

  @override
  String get hubCallUpFinals => 'Udtag din trup til slutrunden';

  @override
  String get hubCallUpNationsCup => 'Udtag din trup til Nations Cup';

  @override
  String get hubCallUpQualifying => 'Udtag din kvalifikationstrup';

  @override
  String get hubCallUpGeneric => 'Udtag din trup';

  @override
  String get hubHost => 'Vært';

  @override
  String get hubGoldenBoot => 'Den Gyldne Støvle';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals mål';
  }

  @override
  String get hubPens => '(str.)';

  @override
  String get hubNationalHub => 'FORBUNDSKONTORET';

  @override
  String get hubMessages => 'Beskeder';

  @override
  String get hubWorldChampions => 'VERDENSMESTRE';

  @override
  String get hubViewBracket => 'Se turneringsskema ›';

  @override
  String get hubBoardDelighted => 'Henrykt';

  @override
  String get hubBoardPleased => 'Tilfreds';

  @override
  String get hubBoardExpectingMore => 'Forventer mere';

  @override
  String get hubBoardConcerned => 'Bekymret';

  @override
  String get hubBoardJobAtRisk => 'Jobbet er i fare';

  @override
  String get hubBoard => 'BESTYRELSE';

  @override
  String hubBoardObjective(String label) {
    return 'Bestyrelsens mål: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'OPNÅET · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'MISLYKKET · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Ikke flere kampe i denne cyklus.';

  @override
  String get hubVs => 'MOD';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Verdensranglisten';

  @override
  String get hubSquadStatus => 'TRUPSTATUS';

  @override
  String hubPlayers(int count) {
    return '$count spillere';
  }

  @override
  String get hubAvgRating => 'Gns. karakter';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Styr holdet';

  @override
  String get hubGroupsToBeDrawn =>
      'Grupperne skal trækkes. Se lodtrækningen for at afsløre dem.';

  @override
  String hubGroupName(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get hubTblTeam => 'HOLD';

  @override
  String get hubTblP => 'K';

  @override
  String get hubTblGd => '+/-';

  @override
  String get hubTblPts => 'P';

  @override
  String get homeSettings => 'Indstillinger';

  @override
  String get homeLeadTheNation => 'LED LANDET';

  @override
  String get homeYourNation => 'dit land';

  @override
  String get homeNewGame => 'Nyt spil';

  @override
  String get homeAllSaves => 'Alle gemte spil';

  @override
  String get homeLoadGame => 'Indlæs spil';

  @override
  String get homeContinue => 'FORTSÆT';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Vejen til Verdensmesterskabet $year';
  }

  @override
  String get careerManageSaves => 'Administrér gemte spil';

  @override
  String get careerNewGameTitle => 'NYT SPIL';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Landet kunne ikke indlæses.\n$error';
  }

  @override
  String get careerNationNotFound => 'Land ikke fundet.';

  @override
  String careerWorldRankNum(int rank) {
    return 'VERDENSRANGLISTEN #$rank';
  }

  @override
  String get careerManagerName => 'Trænernavn';

  @override
  String get careerManagerNameHint => 'fx Morten Olsen';

  @override
  String get careerBeginsBlurb =>
      'Din karriere begynder i september 2026, på vejen mod VM i 2030.';

  @override
  String get careerFreeCycleNote =>
      'Gratis i en hel fireårig cyklus: kvalifikation, dit kontinentale mesterskab og VM, med to gemte spil. Derefter låser én betaling op for endeløse cyklusser.';

  @override
  String get careerStartCareer => 'Start karriere';

  @override
  String get careersTitle => 'KARRIERER';

  @override
  String get careerManagerCareer => 'Trænerkarriere';

  @override
  String get careerManagerCareerSubtitle =>
      'Hver cyklus du har ledet, og din samlede statistik';

  @override
  String get careerSummaryTitle => 'Karriereoversigt';

  @override
  String get careerSummarySubtitle => 'Dit pokalskab og din trænerstatistik';

  @override
  String get careerAchievements => 'Præstationer';

  @override
  String get careerAchievementsSubtitle =>
      'Milepæle, titler og bestyrelsens tilfredshed';

  @override
  String get careerChallenges => 'Udfordringer';

  @override
  String get careerChallengesSubtitle =>
      'Benhårde prøver gennem hele karrieren';

  @override
  String get careerTeamRecords => 'Holdrekorder';

  @override
  String get careerTeamRecordsSubtitle =>
      'Alle tiders topscorere og flest landskampe';

  @override
  String get careerMyMatches => 'Mine kampe';

  @override
  String get careerMyMatchesSubtitle => 'Alle resultater og kommende kampe';

  @override
  String get careerTitle => 'KARRIERE';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Karrieren kunne ikke indlæses.\n$error';
  }

  @override
  String get careerNoCareer => 'Ingen karriere.';

  @override
  String get careerTrophyCabinet => 'POKALSKAB';

  @override
  String get careerTournamentHistory => 'TURNERINGSHISTORIK';

  @override
  String get careerNoTournamentsYet => 'Ingen turneringer afsluttet endnu.';

  @override
  String get careerTeamFallback => 'Hold';

  @override
  String careerWorldNum(int rank) {
    return 'VERDEN #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points P';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SÆSON $season';
  }

  @override
  String get careerStatPlayedShort => 'K';

  @override
  String get careerStatsHeading => 'I TAL';

  @override
  String get careerStatsWinRate => 'Sejrsprocent';

  @override
  String get careerStatsGoalsFor => 'Scorede mål';

  @override
  String get careerStatsGoalsAgainst => 'Indkasserede mål';

  @override
  String get careerStatsGoalDiff => 'Målforskel';

  @override
  String get careerStatsCleanSheets => 'Clean sheets';

  @override
  String get careerStatsBiggestWin => 'Største sejr';

  @override
  String get careerStatsWinStreak => 'Sejrsstime';

  @override
  String get careerStatsUnbeaten => 'Ubesejret stime';

  @override
  String get careerStatsShootouts => 'Straffekonk.';

  @override
  String get careerStatsHatTricks => 'Hattricks';

  @override
  String get careerStatsMotms => 'Kampens spiller';

  @override
  String get careerStatsBestRating => 'Bedste karakter';

  @override
  String get careerStatWonShort => 'V';

  @override
  String get careerStatDrawnShort => 'U';

  @override
  String get careerStatLostShort => 'T';

  @override
  String get careerStatGoalsForShort => 'MF';

  @override
  String get careerStatGoalsAgainstShort => 'MI';

  @override
  String get careerStatGoalDiffShort => '+/-';

  @override
  String get careerNoSilverware => 'Ingen pokaler endnu. Gå ud og vind en.';

  @override
  String get careerMedalGold => 'GULD';

  @override
  String get careerMedalSilver => 'SØLV';

  @override
  String get careerMedalBronze => 'BRONZE';

  @override
  String careerWinnersName(String name) {
    return 'Vindere: $name';
  }

  @override
  String get careerSavesTitle => 'GEMTE SPIL';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Gemte spil kunne ikke indlæses.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'PLADSER  $used/$limit';
  }

  @override
  String get careerThisSave => 'dette spil';

  @override
  String get careerSlotsFull => 'Pladserne er fyldt';

  @override
  String careerSlotsUsed(int used) {
    return 'PLADSER  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Lås flere gemte spil op';

  @override
  String get careerSlotsKeepNote =>
      'Alle de gemte spil, du allerede har, kan stadig spilles. Kun et nyt kræver oplåsning.';

  @override
  String get careerNewGame => 'Nyt spil';

  @override
  String get careerDeleteSaveTitle => 'Slet gemt spil?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Din $label-karriere slettes permanent.';
  }

  @override
  String get careerCancel => 'Annuller';

  @override
  String get careerDelete => 'Slet';

  @override
  String get careerNoSavesYet =>
      'Ingen gemte spil endnu.\nStart et nyt spil for at lede et land.';

  @override
  String get careerUnknownNation => 'Ukendt';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours t $minutes min';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Sidst spillet $when';
  }

  @override
  String get careerJustNow => 'lige nu';

  @override
  String get careerYesterday => 'i går';

  @override
  String careerMinutesAgo(int n) {
    return '$n min. siden';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n t. siden';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n d. siden';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Vejen til VM $year';
  }

  @override
  String get careerManagerCareerTitle => 'TRÆNERKARRIERE';

  @override
  String careerCouldNotLoad(String error) {
    return 'Kunne ikke indlæses.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CYKLUS FOR CYKLUS';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cyklusser',
      one: '1 cyklus',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations lande ledet',
      one: '1 land ledet',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Titler';

  @override
  String get careerStatPlayed => 'Kampe';

  @override
  String get careerStatWon => 'Vundet';

  @override
  String get careerStatDrawn => 'Uafgjort';

  @override
  String get careerStatLost => 'Tabt';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Mål $goalsFor–$goalsAgainst  ($gd)  ·  Sejrsprocent $winRate %';
  }

  @override
  String get careerRecordResults => 'REKORDRESULTATER';

  @override
  String get careerBestWin => 'Bedste sejr';

  @override
  String get careerWorstDefeat => 'Værste nederlag';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'mod $opponent · $date';
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
    return '${won}V ${drawn}U ${lost}T  ·  MF $goalsFor MI $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Verdensmesterskabet';

  @override
  String get careerContinentalLabel => 'Kontinentalt';

  @override
  String get messagesTitle => 'BESKEDER';

  @override
  String get messagesNoMessagesYet => 'Ingen beskeder endnu.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Beskeder kunne ikke indlæses.\n$error';
  }

  @override
  String get messagesDone => 'Færdig';

  @override
  String get messagesNext => 'Næste';

  @override
  String get rankingWorldRanking => 'VERDENSRANGLISTEN';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Ranglisten kunne ikke indlæses.\n$error';
  }

  @override
  String get rankingNoRanking => 'Ingen rangliste.';

  @override
  String get rankingAll => 'ALLE';

  @override
  String get rankingYourTeam => 'DIT HOLD';

  @override
  String get rankingYourRankingOverTime => 'DIN PLACERING OVER TID';

  @override
  String rankingNowRank(int rank) {
    return 'nu #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'bedst #$best · dårligst #$worst';
  }

  @override
  String get friendliesTitle => 'VENSKABSKAMPE';

  @override
  String friendliesLoadError(String error) {
    return 'Venskabskampe kunne ikke indlæses.\n$error';
  }

  @override
  String get friendliesContinue => 'Fortsæt';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ledige vinduer',
      one: '1 ledigt vindue',
    );
    return 'Aftal opvarmningskampe i $_temp0 før din næste turneringskamp. Tryk på en modstander, eller lad den stå åben.';
  }

  @override
  String get friendliesFree => 'Åben';

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
  String get matchGoalsNone => 'Ingen mål';

  @override
  String get matchGoalPenalty => 'STR';

  @override
  String get matchGoalSetPiece => 'DØD';

  @override
  String matchGoalAssist(String name) {
    return 'assist $name';
  }

  @override
  String get friendliesHome => 'HJEMME';

  @override
  String get friendliesAway => 'UDE';

  @override
  String get friendliesNoneThisWindow => 'Ingen venskabskampe i dette vindue';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count venskabskampe',
      one: '1 venskabskamp',
    );
    return 'Bekræft $_temp0';
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
  String get resultsMyMatches => 'MINE KAMPE';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Resultater kunne ikke indlæses.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Ingen kampe.';

  @override
  String get resultsVs => 'mod';

  @override
  String get resultsStageQualifier => 'KVALKAMP';

  @override
  String get resultsStageFriendly => 'VENSKABSKAMP';

  @override
  String get resultsStageGroupStage => 'GRUPPESPIL';

  @override
  String get resultsStageSemiFinal => 'SEMIFINALE';

  @override
  String get resultsStageFinal => 'FINALE';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'SLUTRUNDEGRUPPE';

  @override
  String get resultsStageRoundOf32 => '1/16-FINALE';

  @override
  String get resultsStageRoundOf16 => 'OTTENDEDELSFINALE';

  @override
  String get resultsStageQuarterFinal => 'KVARTFINALE';

  @override
  String get resultsStageThirdPlace => 'BRONZEKAMP';

  @override
  String get matchSetupWarnCaptain =>
      'Ingen anfører udpeget. Tryk for at give nogen anførerbindet';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name er skadet og kan ikke føre holdet ind på banen. Tryk for at give bindet videre';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name er suspenderet i denne kamp. Tryk for at give bindet videre';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name har anførerbindet, men er ikke i din trup. Tryk for at give det videre';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Ingen dødboldsspecialister udpeget. Tryk for at vælge, hvem der tager dem';

  @override
  String get matchSetupWarnBoth =>
      'Ingen anfører og ingen dødboldsspecialister. Tryk for at udpege dem';

  @override
  String matchStageMatchday(int matchday) {
    return 'KR $matchday';
  }

  @override
  String get squadCaptain => 'Anfører';

  @override
  String deptEffectYouth(int points) {
    return 'Akademitalenter kommer omkring $points point højere i samlet styrke';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount tilbage ved cyklussens slutning';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent % færre skader';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent % chance for, at en udenlandsk spiller beder om at skifte';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points tålmodighed hos bestyrelsen, før dit job er i fare';
  }

  @override
  String get deptEffectNone => 'Ingen effekt uden midler';

  @override
  String get statsBestRated => 'Karakterer';

  @override
  String get statsMyCareer => 'Karriere';

  @override
  String get statsBestAverageRating => 'BEDSTE GENNEMSNITSKARAKTER';

  @override
  String get statsMyCareerRecord => 'DIN STATISTIK';

  @override
  String get statsNoRatingsRecorded =>
      'Ingen kampkarakterer registreret endnu.';

  @override
  String get statsGroupRecord => 'Statistik';

  @override
  String get statsGroupRuns => 'Stimer';

  @override
  String get statsGroupExtremes => 'Ekstremer';

  @override
  String get statsGroupSplits => 'Hjemme og ude';

  @override
  String get statsGroupSquad => 'Dine spillere';

  @override
  String get statsPlayed => 'Spillede kampe';

  @override
  String get statsWinDrawLoss => 'Vundet–uafgjort–tabt';

  @override
  String get statsWinRate => 'Sejrsprocent';

  @override
  String get statsGoals => 'Mål for:imod';

  @override
  String get statsCleanSheets => 'Clean sheets';

  @override
  String get statsFailedToScore => 'Uden scoring';

  @override
  String get statsLongestWinStreak => 'Længste sejrsstime';

  @override
  String get statsLongestUnbeaten => 'Længste ubesejrede stime';

  @override
  String get statsLongestCleanSheets => 'Længste stime med clean sheets';

  @override
  String get statsLongestWinless => 'Længste stime uden sejr';

  @override
  String get statsCurrentRun => 'Nuværende ubesejrede stime';

  @override
  String get statsBiggestWin => 'Største sejr';

  @override
  String get statsHeaviestDefeat => 'Største nederlag';

  @override
  String get statsMostGoalsInAGame => 'Flest mål i en kamp';

  @override
  String get statsShootouts => 'Straffesparkskonkurrencer vundet–tabt';

  @override
  String get statsComebackWins => 'Sejre efter underlegenhed';

  @override
  String get statsHome => 'Hjemme';

  @override
  String get statsAway => 'Ude';

  @override
  String get statsNeutral => 'Neutral bane';

  @override
  String get statsCompetitive => 'Turneringskampe';

  @override
  String get statsFriendlies => 'Venskabskampe';

  @override
  String get statsHatTricks => 'Hattricks';

  @override
  String get statsBraces => 'Dobbeltscoringer';

  @override
  String get statsMotms => 'Kampens spiller-udnævnelser';

  @override
  String get statsAssists => 'Assists';

  @override
  String get statsCards => 'Kort';

  @override
  String get statsBestRating => 'Bedste individuelle karakter';

  @override
  String statsAppsShort(int apps) {
    return '$apps kampe';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms KS';
  }

  @override
  String get captainArmband => 'A';

  @override
  String get captainCurrent => 'Anfører. Tryk for at fjerne anførerbindet';

  @override
  String get captainFitBorn => 'Født leder';

  @override
  String get captainFitNatural => 'Naturlig anfører';

  @override
  String get captainFitCapable => 'Kan bære bindet';

  @override
  String get captainFitUnproven => 'Ikke leder endnu';

  @override
  String get captainNone => 'Ingen anfører udpeget';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale truppens moral';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'VM-kvalifikation';

  @override
  String get resultsCategoryFriendlies => 'Venskabskampe';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Kontinentalt mesterskab';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'VM-kval.';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Kont. kval.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Kontinental kvalifikation';

  @override
  String get resultsCategoryWorldCupFinals => 'VM-slutrunde';

  @override
  String get resultsRoundResults => 'RUNDENS RESULTATER';

  @override
  String get resultsFriendlyInternationals => 'VENSKABSLANDSKAMPE';

  @override
  String get resultsKnockout => 'Slutspil';

  @override
  String resultsEarlierMatches(int count) {
    return 'Tidligere kampe ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'KAMPRUNDE $matchday';
  }

  @override
  String get resultsContinue => 'Fortsæt';

  @override
  String resultsGroup(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get achievementsScreenTitle => 'PRÆSTATIONER';

  @override
  String get achievementsChallengesTooltip => 'Udfordringer';

  @override
  String get achievementsChallengesHeading => 'UDFORDRINGER';

  @override
  String get achievementsBrutalTests => 'Benhårde prøver gennem hele karrieren';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Kunne ikke indlæses.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total låst op';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total besejret';
  }

  @override
  String get achievementsBoardSatisfaction => 'BESTYRELSENS TILFREDSHED';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PRÆSTATIONER LÅST OP',
      one: 'PRÆSTATION LÅST OP',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Sejre';

  @override
  String get achCatMatches => 'Kampe';

  @override
  String get achCatQualifications => 'Kvalifikationer';

  @override
  String get achCatTitles => 'Titler';

  @override
  String get achCatMisc => 'Diverse';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Mål';

  @override
  String get achCatStreaks => 'Stimer';

  @override
  String get achTierBronze => 'Bronze';

  @override
  String get achTierSilver => 'Sølv';

  @override
  String get achTierGold => 'Guld';

  @override
  String get achTierPlatinum => 'Platin';

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
      other: 'Score $count mål.',
      one: 'Score 1 mål.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clean sheets',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hold $count clean sheets.',
      one: 'Hold 1 clean sheet.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Vindervane';

  @override
  String get achStreakWin5Desc => 'Vind fem kampe i træk.';

  @override
  String get achStreakWin10 => 'På en rulle';

  @override
  String get achStreakWin10Desc => 'Vind ti kampe i træk.';

  @override
  String get achStreakWin20 => 'Damptromle';

  @override
  String get achStreakWin20Desc => 'Vind tyve kampe i træk.';

  @override
  String get achUnbeaten15 => 'Svær at slå';

  @override
  String get achUnbeaten15Desc => 'Gå femten kampe ubesejret.';

  @override
  String get achUnbeaten30 => 'Uovervindelig';

  @override
  String get achUnbeaten30Desc => 'Gå tredive kampe ubesejret.';

  @override
  String get achHattrick => 'Hattrickhelt';

  @override
  String get achHattrickDesc => 'Få en spiller til at score et hattrick.';

  @override
  String get achMotm10 => 'Skiller sig ud';

  @override
  String get achMotm10Desc => 'Hent 10 udnævnelser som kampens spiller.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc => 'Hent 50 udnævnelser som kampens spiller.';

  @override
  String get achPerfect => 'Perfekt ti\'er';

  @override
  String get achPerfectDesc =>
      'Få en spiller til at opnå en kampkarakter på 9,5 eller mere.';

  @override
  String get achShootout => 'Isvand i årerne';

  @override
  String get achShootoutDesc => 'Vind fem straffesparkskonkurrencer.';

  @override
  String get achMassacre => 'Massakre';

  @override
  String get achMassacreDesc => 'Vind en kamp med 7 mål eller mere.';

  @override
  String get achAnnihilation => 'Udslettelse';

  @override
  String get achAnnihilationDesc => 'Vind en kamp med 10 mål eller mere.';

  @override
  String get chTierBronze => 'Bronze';

  @override
  String get chTierSilver => 'Sølv';

  @override
  String get chTierGold => 'Guld';

  @override
  String get chTierLegendary => 'Legendarisk';

  @override
  String get chFirstSteps => 'I teknikerområdet';

  @override
  String get chFirstStepsDesc => 'Led holdet i 5 år.';

  @override
  String get chUnbeaten10 => 'På en rulle';

  @override
  String get chUnbeaten10Desc => 'Gå 10 turneringskampe ubesejret.';

  @override
  String get chTwoNations => 'Ny udfordring';

  @override
  String get chTwoNationsDesc => 'Led 2 forskellige lande.';

  @override
  String get chCont1 => 'Kontinentalmester';

  @override
  String get chCont1Desc => 'Vind et kontinentalt mesterskab.';

  @override
  String get chNc1 => 'Nations Cup-vinder';

  @override
  String get chNc1Desc => 'Vind Nations Cup.';

  @override
  String get chWc1 => 'Verdensmester';

  @override
  String get chWc1Desc => 'Vind Verdensmesterskabet.';

  @override
  String get chYears25 => 'Etablissementet';

  @override
  String get chYears25Desc => 'Led holdet i 25 år.';

  @override
  String get chWc3 => 'Seriesejrherre';

  @override
  String get chWc3Desc => 'Vind 3 verdensmesterskaber.';

  @override
  String get chWc5 => 'Dynasti';

  @override
  String get chWc5Desc => 'Vind 5 verdensmesterskaber.';

  @override
  String get chWc10 => 'Udødelig';

  @override
  String get chWc10Desc => 'Vind 10 verdensmesterskaber.';

  @override
  String get chWc2Teams => 'Støvler på, afsted';

  @override
  String get chWc2TeamsDesc =>
      'Vind Verdensmesterskabet med 2 forskellige lande.';

  @override
  String get chWc3Teams => 'Globetrotter';

  @override
  String get chWc3TeamsDesc =>
      'Vind Verdensmesterskabet med 3 forskellige lande.';

  @override
  String get chWcStreak3 => 'Tre i træk';

  @override
  String get chWcStreak3Desc => 'Vind 3 verdensmesterskaber i træk.';

  @override
  String get chWcAllconf => 'Verdenserobrer';

  @override
  String get chWcAllconfDesc =>
      'Vind Verdensmesterskabet med et land fra hvert kontinentalforbund (6).';

  @override
  String get chCont5 => 'Kontinentets konge';

  @override
  String get chCont5Desc => 'Vind 5 kontinentale mesterskaber.';

  @override
  String get chContAll => 'Seks-kontinenters-slam';

  @override
  String get chContAllDesc =>
      'Vind hvert kontinentalforbunds kontinentale mesterskab (6).';

  @override
  String get chTreble => 'Totalsejr';

  @override
  String get chTrebleDesc =>
      'Vind Verdensmesterskabet, en kontinental titel og Nations Cup i samme karriere.';

  @override
  String get chNations10 => 'Nomade';

  @override
  String get chNations10Desc => 'Led 10 forskellige lande.';

  @override
  String get chYears100 => 'Århundredet';

  @override
  String get chYears100Desc => 'Led holdet i 100 år.';

  @override
  String get chYears500 => 'Et halvt årtusinde';

  @override
  String get chYears500Desc => 'Led holdet i 500 år.';

  @override
  String get chYears1000 => 'Evig';

  @override
  String get chYears1000Desc => 'Led holdet i 1000 år.';

  @override
  String get chGrandmaster => 'Stormester';

  @override
  String get chGrandmasterDesc =>
      'Vind 3 verdensmesterskaber OG 5 kontinentale mesterskaber.';

  @override
  String get chUndefeated => 'Uovervindelig';

  @override
  String get chUndefeatedDesc =>
      'Vind et verdensmesterskab uden at tabe en eneste kamp.';

  @override
  String get chPerfectQual => 'Fejlfri passage';

  @override
  String get chPerfectQualDesc =>
      'Vind hver eneste kamp i en VM-kvalifikation.';

  @override
  String get chMinnow => 'Småfiskens mirakel';

  @override
  String get chMinnowDesc =>
      'Vind Verdensmesterskabet med et land, der er rangeret uden for verdens top 32.';

  @override
  String get chGrandTour => 'Ude og hjemme';

  @override
  String get chGrandTourDesc =>
      'Vind et verdensmesterskab som værtsland og et på udebane.';

  @override
  String get chUnbeaten25 => 'Muren';

  @override
  String get chUnbeaten25Desc => 'Gå 25 turneringskampe ubesejret.';

  @override
  String get chGoals10k => 'Målmaskine';

  @override
  String get chGoals10kDesc => 'Score 10.000 mål i karrieren.';

  @override
  String get chCleanSheets500 => 'Fæstning';

  @override
  String get chCleanSheets500Desc => 'Hold 500 clean sheets i karrieren.';

  @override
  String get chHatTricks25 => 'Hattrickvane';

  @override
  String get chHatTricks25Desc => 'Få dine spillere til at score 25 hattricks.';

  @override
  String get chWinStreak25 => 'Ubønhørlig';

  @override
  String get chWinStreak25Desc => 'Vind 25 kampe i træk.';

  @override
  String get chCont10 => 'Kontinentalt dynasti';

  @override
  String get chCont10Desc => 'Vind 10 kontinentale mesterskaber.';

  @override
  String get chPcWc => 'Seriemester';

  @override
  String chPcWcDesc(int count) {
    return 'Vind $count verdensmesterskaber i dette spil.';
  }

  @override
  String get chPcMajors => 'Pokalsamler';

  @override
  String chPcMajorsDesc(int count) {
    return 'Vind $count store titler (VM, kontinentalt mesterskab eller Nations Cup).';
  }

  @override
  String get chPcUnbeaten => 'Jernmur';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Gå $count turneringskampe ubesejret.';
  }

  @override
  String get chPcNations => 'Omrejsende';

  @override
  String chPcNationsDesc(int count) {
    return 'Led $count forskellige lande.';
  }

  @override
  String get chPcYears => 'Den lange vej';

  @override
  String chPcYearsDesc(int count) {
    return 'Led holdet i $count år.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sejre',
      one: '1 sejr',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vind $count kampe.',
      one: 'Vind 1 kamp.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kampe',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spil $count kampe.',
      one: 'Spil 1 kamp.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'VM-kvalificeret';

  @override
  String get achQualWcDesc => 'Kvalificér dig til Verdensmesterskabet.';

  @override
  String get achQualCont => 'Kontinentalt kvalificeret';

  @override
  String get achQualContDesc =>
      'Kvalificér dig til dit kontinentale mesterskab.';

  @override
  String get achTitleWc => 'Verdensmestre';

  @override
  String get achTitleWcDesc => 'Vind Verdensmesterskabet.';

  @override
  String get achTitleEuro => 'Europamestre';

  @override
  String get achTitleEuroDesc => 'Vind Europamesterskabet.';

  @override
  String get achTitleCopa => 'Sydamerikas mestre';

  @override
  String get achTitleCopaDesc => 'Vind Sydamerika Cup.';

  @override
  String get achTitleAfcon => 'Afrikamestre';

  @override
  String get achTitleAfconDesc => 'Vind Afrikamesterskabet.';

  @override
  String get achTitleAsia => 'Asienmestre';

  @override
  String get achTitleAsiaDesc => 'Vind Asienmesterskabet.';

  @override
  String get achTitleConcacaf => 'Nordamerikas mestre';

  @override
  String get achTitleConcacafDesc => 'Vind Nordamerika Nations Cup.';

  @override
  String get achTitleOfc => 'Oceaniens mestre';

  @override
  String get achTitleOfcDesc => 'Vind Oceanien Cup.';

  @override
  String get achTitleNations => 'Nations Cup-vindere';

  @override
  String get achTitleNationsDesc => 'Vind Nations Cup.';

  @override
  String get achTitleClash => 'Continental Clash-vindere';

  @override
  String get achTitleClashDesc => 'Vind Continental Clash.';

  @override
  String get achMarksman => 'VM-skytte';

  @override
  String get achMarksmanDesc =>
      'Få en trupspiller til at score 6 eller flere mål i en VM-slutrunde.';

  @override
  String get achSweep => 'Totalsejr';

  @override
  String get achSweepDesc =>
      'Hold både Verdensmesterskabet og din kontinentale titel i samme karriere.';

  @override
  String get achAllstar => 'Turneringens All-Star';

  @override
  String get achAllstarDesc =>
      'Få en spiller udtaget til Turneringens hold ved et VM.';

  @override
  String get achGoldenboot => 'Den Gyldne Støvle';

  @override
  String get achGoldenbootDesc =>
      'Få dit land til at slutte som topscorer i et mesterskab.';

  @override
  String get achDemolition => 'Nedrivning';

  @override
  String get achDemolitionDesc => 'Vind en kamp med 5 mål eller mere.';

  @override
  String get achievementsNice => 'Flot!';

  @override
  String get achievementsHardestTests =>
      'En trænerens hårdeste prøver, gennem en hel karriere og mange lande.';

  @override
  String get achievementsThisSave => 'DETTE SPIL';

  @override
  String get achievementsBrutalBadge => 'BENHÅRD';

  @override
  String get paywallGoPro => 'GÅ UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Engangsbetaling. Intet abonnement.';

  @override
  String get paywallBenefitCarryOn =>
      'Dette gemte spil fortsætter præcis, hvor det slap, med alle landskampe, rekorder og rivaliseringer intakte.';

  @override
  String get paywallBenefitNoAds =>
      'Ingen reklamer, ingen mikrotransaktioner, intet abonnement. Én betaling, og alle fremtidige opdateringer er dine.';

  @override
  String get paywallBenefitSaves =>
      'Så mange gemte spil, du vil. Led en storhed og en outsider på samme tid, og se, hvor forskelligt det samme spil føles.';

  @override
  String get paywallBenefitEndless =>
      'Hver eneste cyklus fra nu af. Vælg en sytten-årig i dag, og find ud af i 2034, om du så rigtigt.';

  @override
  String get paywallUnlocked => 'Unlimited er låst op. God fornøjelse!';

  @override
  String get paywallContactingStore => 'Kontakter butikken…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Lås Unlimited op · $price';
  }

  @override
  String get paywallRestorePurchases => 'Gendan køb';

  @override
  String get paywallStoreUnavailable => 'Butikken er utilgængelig';

  @override
  String get paywallStoreUnavailableNote =>
      'Prisen kunne ikke indlæses. Tjek din forbindelse, og prøv igen.';

  @override
  String get paywallTryAgain => 'Prøv igen';

  @override
  String get gateTitle => 'DIN FØRSTE CYKLUS ER SLUT';

  @override
  String get gateLead =>
      'Fire år er én cyklus. Det er ikke længe nok til at finde ud af, om du havde ret.';

  @override
  String get gatePriceLead => 'Én betaling, for evigt';

  @override
  String get gateBuy => 'KØB OG FORTSÆT';

  @override
  String get gateExit => 'LUK';

  @override
  String get federationNaturalisation => 'NATURALISATION';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name naturaliseret';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name har gennemført skiftet og kan nu spille for $nation. Udtag spilleren fra din trup.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Tilbuddet kunne ikke indlæses.\n$error';
  }

  @override
  String get federationContinue => 'Fortsæt';

  @override
  String get federationOfferToSwitchAllegiance =>
      'ET TILBUD OM AT SKIFTE LANDSHOLD';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age år · fra $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name har rødder i $playerNation og er villig til at blive naturaliseret. Siger du ja, kan spilleren udtages. Siger du nej, bliver spilleren hos $sourceNation.';
  }

  @override
  String get federationDecline => 'Afslå';

  @override
  String get federationNaturalise => 'Naturalisér';

  @override
  String get federationBudgetLater => 'Beslut senere';

  @override
  String get federationSetYourBudget => 'FASTSÆT DIT BUDGET';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Økonomien kunne ikke indlæses.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Gemt spil ikke fundet.';

  @override
  String get federationBudgetHeading => 'FORBUNDSBUDGET';

  @override
  String federationDistributeBudget(String amount) {
    return 'Fordel $amount på afdelingerne for at åbne cyklussen. Brug pengene med omtanke.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount mere, end forbundet har. Tag noget tilbage';
  }

  @override
  String get federationAllocateFullBudget =>
      'Fordel hele budgettet for at begynde cyklussen.';

  @override
  String get federationConfirming => 'Bekræfter…';

  @override
  String get federationConfirmBudget => 'Bekræft budget';

  @override
  String get federationFinances => 'ØKONOMI';

  @override
  String get federationInvestmentUpdated => 'Investering opdateret.';

  @override
  String get federationDevelopment => 'FORBUNDSUDVIKLING';

  @override
  String get federationProjectedAtSeasonEnd => 'FORVENTET VED SÆSONENS SLUT';

  @override
  String get federationCentralFunding => 'Central støtte';

  @override
  String get federationPrizeMoneySoFar => 'Præmiepenge indtil nu';

  @override
  String get federationCommercialReturn => 'Kommercielt afkast';

  @override
  String get federationThisSeasonLocked => 'DENNE SÆSON (LÅST)';

  @override
  String get federationInvestForNextSeason => 'INVESTÉR TIL NÆSTE SÆSON';

  @override
  String get federationNextSeasonImpact => 'EFFEKT NÆSTE SÆSON';

  @override
  String get federationSaving => 'Gemmer…';

  @override
  String get federationConfirmInvestment => 'Bekræft investering';

  @override
  String get federationBalance => 'FORBUNDETS SALDO';

  @override
  String get federationCommittedToStaff => 'Bundet til staben';

  @override
  String get federationFreeToSpend => 'Frit til rådighed';

  @override
  String get federationWagesNote =>
      'Lønnen trækkes fra saldoen ved cyklussens slutning, så dette beløb er allerede lovet væk.';

  @override
  String get federationInvestAtCeremony =>
      'Investér til næste sæson ved ceremonien i slutningen af cyklussen.';

  @override
  String federationLevelBadge(int level) {
    return 'L$level';
  }

  @override
  String get federationAcademyProspects => 'Akademitalenter';

  @override
  String federationPlusOverall(int value) {
    return '+$value samlet styrke';
  }

  @override
  String get federationInjuryRisk => 'Skadesrisiko';

  @override
  String get federationNaturalisationChance => 'Chance for naturalisation';

  @override
  String get federationBoardPatience => 'Bestyrelsens tålmodighed';

  @override
  String get federationUnallocated => 'UFORDELT';

  @override
  String get nationsVitrineTitle => 'TROFÆSKAB';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Landet kunne ikke indlæses.\n$error';
  }

  @override
  String get nationsNoNation => 'Intet land.';

  @override
  String get nationsHonours => 'HÆDER';

  @override
  String get nationsRankingHistory => 'HISTORIK PÅ VERDENSRANGLISTEN';

  @override
  String get nationsTopScorers => 'ALLE TIDERS TOPSCORERE';

  @override
  String get nationsTitles => 'TITLER';

  @override
  String get nationsYourTeam => 'DIT HOLD';

  @override
  String get nationsWorld => 'VERDEN';

  @override
  String get nationsWorldCup => 'Verdensmesterskabet';

  @override
  String get nationsContinental => 'Kontinental';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deltagelser',
      one: '1 deltagelse',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Endnu ikke nok historik. Kom tilbage om en cyklus eller to.';

  @override
  String nationsBestRank(int rank) {
    return 'Bedst: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Nu: #$rank';
  }

  @override
  String get nationsNoGoals => 'Ingen mål registreret endnu.';

  @override
  String get nationsGoalsAbbrev => 'mål';

  @override
  String get nationsHosts => 'VÆRT';

  @override
  String get nationsSelectTitle => 'VÆLG LANDSHOLD';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Lande kunne ikke indlæses.\n$error';
  }

  @override
  String get nationsNoMatch => 'Ingen lande passer.';

  @override
  String get nationsNationalLevel => 'LANDETS NIVEAU';

  @override
  String get nationsSelectHeading => 'Vælg landshold';

  @override
  String get nationsSearchHint => 'Søg efter land…';

  @override
  String get nationsRank => 'RANG ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'VÆLG';

  @override
  String get statsTeamRecords => 'HOLDREKORDER';

  @override
  String get statsRecordBook => 'Rekordbog';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Statistik kunne ikke indlæses.\n$error';
  }

  @override
  String get statsNoData => 'Ingen data.';

  @override
  String get statsTopScorers => 'TOPSCORERE';

  @override
  String get statsMostGamesPlayed => 'FLEST SPILLEDE KAMPE';

  @override
  String get statsTeam => 'Hold';

  @override
  String get statsTopScorersShort => 'Scorere';

  @override
  String get statsMostGames => 'Flest kampe';

  @override
  String get statsNoGoalsRecorded => 'Ingen mål registreret endnu.';

  @override
  String get statsUnknown => 'Ukendt';

  @override
  String get playerTitle => 'SPILLER';

  @override
  String playerLoadError(String error) {
    return 'Spilleren kunne ikke indlæses.\n$error';
  }

  @override
  String get playerNotFound => 'Spilleren blev ikke fundet.';

  @override
  String get playerClub => 'KLUB';

  @override
  String get playerClubRole => 'I sin klub';

  @override
  String get playerPosition => 'Position';

  @override
  String get playerPotential => 'Potentiale';

  @override
  String get playerAge => 'Alder';

  @override
  String get playerValue => 'Værdi';

  @override
  String get clubFirstChoice => 'Spiller hver uge';

  @override
  String get clubRotation => 'Ind og ud';

  @override
  String get clubFringe => 'Spiller næsten ikke';

  @override
  String get clubFrozenOut => 'Spiller ikke';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Jeg har set fodbold i tredive år, og det her så jeg ikke komme. $opponent slået $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Ingen gav dem en chance mod $opponent. $score. Absolut ingen.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score mod $opponent. Væk naboerne.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Det er sådan en aften, folk fortæller deres børnebørn om. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score mod $opponent. Uanset hvordan det skete, så skete det.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'På papiret var den afgjort, før den begyndte. $opponent $score siger noget andet.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Slog $opponent $score. Ingen vil tro på det resultat om et år.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Nyd det, og kig så på kampprogrammet.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score mod $opponent, og vi var heldige i firs af de halvfems minutter.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Én aften mod $opponent udsletter ikke et helt år. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Slog $opponent $score, og nu får vi at vide, at vi har vendt udviklingen. Det har vi ikke.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Dejligt. Spørg mig igen, når det gælder.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Slog $opponent $score. Præcis som det skal være, og der er en glæde i det.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score over $opponent. Hensynsløst, og det er et kompliment.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Ingen postyr, ingen frygt, ingen klager.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'En ren $score mod $opponent. Sådan ser et godt hold ud på en stille dag.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score mod $opponent. Opgaven løst, intet lært.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Slog $opponent $score. Det skulle vi, og det gjorde vi.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'En professionel $score over $opponent. Næste.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent er klaret, $score. Læg den væk og kom videre.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score mod $opponent, og vi skal åbenbart klappe. For at slå dem.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Godt gået til alle involverede i $score-sejren over $opponent, går jeg ud fra.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. At slå hold som dem er bunden, ikke bedriften.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Vi slog $opponent $score og så trætte ud undervejs.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score mod $opponent, og hvert minut var fortjent.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Det krævede karakter. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Slog $opponent $score på den hårde måde, som er den, der holder.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score mod $opponent. Hold, der vinder sådan nogle, er stadig med i juni.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nervøst, grimt og en sejr. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Slog $opponent $score. Tag de tre point og se den aldrig igen.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent fik os til at kæmpe for hver en centimeter.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Ikke kønt. Tæller det samme.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score mod $opponent, og vi gjorde det ti gange sværere, end det var.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Vi burde ikke have brug for at klamre os fast mod $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Vandt den og lærte intet godt om os selv.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'En $score, der smigrede os, mod $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Et point mod $opponent, $score. Tag det og kom videre.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score med $opponent. Der findes værre eftermiddage end denne.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Holdt $opponent til $score. Alt behøver ikke være en historie.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Et point er et point, og tabellen spørger ikke hvordan.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score med $opponent. To point tabt eller ét vundet. Vælg dit humør.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Uafgjort mod $opponent, $score. Ingen er glade, ingen er rasende.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Årets mest glemmelige halvfems minutter.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Delte point med $opponent, $score. Videre.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score mod $opponent. Sådan nogle kampe er måden, kampagner stille dør på.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'To point smidt væk mod $opponent. $score. Der er ikke andet at kalde det.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Vi havde halvfems minutter og ingen idé om, hvad vi skulle bruge dem til.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'En $score med $opponent, som ingen vil huske, og alle kommer til at betale for.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Slået $score af $opponent. Det sker.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Intet at hænge nogen for. Videre til næste.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Tabte $score til $opponent og gav alt. Nogle dage er det ikke nok.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score til $opponent. Hovedet højt. Dette hold har masser tilbage.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Vi var næstbedst, og det kan ikke diskuteres.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Tabte $score til $opponent. Saml jer.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score til $opponent. Ingen skandale, ikke godt nok.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Slået $score af $opponent. Lær noget af det, ellers var det spildt.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score til $opponent, og vi rørte dem ikke.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Tabte til $opponent, $score. Samme problemer, samme måned, samme undskyldninger på vej.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Hvornår holder det op med at være uheld?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Slået $score af $opponent. Det er et resultat, der bør koste nogen noget.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score til $opponent. Én dårlig aften. Døm holdet på kampagnen, ikke på den her.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Ingen ville have den $score mod $opponent mindre end spillerne.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Grimt, og ikke det, dette hold er.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'En $score at glemme mod $opponent. De tager sig sammen næste gang.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Til $opponent. Jeg har ingen ord, og jeg får penge for at have ord.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Nogen må stå til ansvar for det.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Jeg vil have den $score mod $opponent slettet fra rekordbogen og fra hukommelsen.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Slået $score af $opponent. Sådan et resultat kan ikke spindes.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Det var ikke et nederlag til $opponent, det var en overgivelse. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Mod $opponent. Folk betalte penge for at se det.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Hvis det ikke ændrer noget, gør intet.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Jeg har set dette hold ydmyget før, men $score af $opponent er en ny bund.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'MESTRE. $opponent. Sig det højt.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Vi vandt den. $opponent. Jeg er ikke okay.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, og pokalen kommer hjem.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Hver eneste af dem er en legende. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Så tæt på. $opponent og en medalje, ingen vil have.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Toer ved $opponent. Det kommer til at svie i årevis.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: én kamp fra alt.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Nummer to. Ved $opponent. Send flasken rundt.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Ude ved $opponent. Den kommer til at gøre ondt et stykke tid.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent er der, hvor det slutter for os.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Elimineret ved $opponent. Nu begynder efterforskningen.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Slået ud ved $opponent. Nogen må forklare mig det.';
  }

  @override
  String yQualified0(String opponent) {
    return 'VI SKAL TIL $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Kvalificeret til $opponent. Bestil fri fra arbejde.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, her kommer vi. Aldrig i tvivl (det var helt i tvivl).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Videre til $opponent. Den svære del er klaret.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Grupperne er trukket til $opponent. Kunne være værre. Kunne være meget værre.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Så det er lodtrækningen til $opponent. Interessant.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Grupperne til $opponent er ude, og jeg kan allerede ikke lide vores.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Lodtrækningen til $opponent er lavet. Lad overreaktionerne begynde.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent bliver vært. Begynd at spare op.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Den går til $opponent. Forudsigeligt, men fint.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent får turneringen. Tillykke til dem, formoder jeg.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Værter bekræftet: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent starter snart, og jeg kan ikke sidde stille.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Der er ikke længe til $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent er næsten her. Truppen, tak.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Nedtællingen til $opponent er officielt uudholdelig.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Intet at sige endnu. Spil en kamp.';

  @override
  String get yEarlierHeading => 'Tidligere i cyklussen';

  @override
  String get yTraitLoyalist =>
      'Bakker holdet op, uanset hvad. Langsom til at vende, hurtig til at tilgive.';

  @override
  String get yTraitCynic =>
      'Forventer det værste og er henrykt over at få ret.';

  @override
  String get yTraitNostalgic =>
      'Alt var bedre før. Måler dig op mod mænd, der er stoppet.';

  @override
  String get yTraitStatshead =>
      'Poster tallene og intet andet. Har knap nok et humør.';

  @override
  String get yTraitHypeman =>
      'To gode resultater, og det er en gylden generation.';

  @override
  String get yTraitContrarian => 'Hvad end rummet mener, det modsatte.';

  @override
  String get yTraitDoomer =>
      'Det kommer til at gå galt. Det kommer altid til at gå galt.';

  @override
  String get yProfilePosts => 'OPSLAG';

  @override
  String get yProfileEmpty => 'Intet fra denne konto endnu.';

  @override
  String hubEventGrievance(String player) {
    return '$player vil tale med dig';
  }

  @override
  String get hubEventGrievanceSub => 'Han vil vide, hvor han står';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count færdighedspoint at bruge',
      one: '1 færdighedspoint at bruge',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Det, du er god til, gør dit hold bedre';

  @override
  String get grievanceTitle => 'Et ord på dit kontor';

  @override
  String grievanceGameTime(String player) {
    return '$player har været i truppen og har ikke rørt en bold. Han vil vide, hvorfor.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player er ikke i truppen og kan ikke forstå det. Han vil have besked, uanset hvad den er.';
  }

  @override
  String grievanceRole(String player) {
    return '$player bliver ved med at blive spillet ude af position og har fået nok.';
  }

  @override
  String get grievanceReassure => 'Du indgår i mine planer';

  @override
  String get grievanceHonest =>
      'Du er bagud i forhold til andre, og her er hvorfor';

  @override
  String get grievanceDismiss => 'Jeg bestemmer holdet';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name lavede $goals af dem. Ingen andre er i nærheden.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals til $name. Han bærer dette hold.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals på dagen. Sikke en spiller.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$name satte $goals forbi dem. Tag en bukning.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals til $name, og resten var passagerer.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '$name igen. $goals. Forestil dig dette hold uden ham.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals fra $name. Én mand burde ikke skulle gøre så meget.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Tag $name ud af den, og det er $goals færre og en helt anden eftermiddag.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count i træk. Hvad end der bliver sagt i den omklædningsstue, så virker det.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Det er $count på stribe. Hold falder ikke tilfældigt ind i stimer som denne.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count i træk og stadig i gang. Selvtilliden kan ses fra tribunen.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Ingen nederlag i $count. Spørg enhver, der har trænet: det er den svære del.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count i træk. Nyd det, mens kampprogrammet er venligt.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count på stribe, og vi har ikke slået nogen af betydning.';
  }

  @override
  String yWinStreak6(String count) {
    return 'En stime på $count. Spørg mig igen, når den bliver testet.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count på stribe. Ethvert hold har sådan en i sig én gang.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count uden sejr nu. På et tidspunkt løber undskyldningerne tør.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Det er $count i træk væk. Det er ikke et udsving længere.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count nederlag i træk. Nogen må stå til ansvar.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Ingen sejre i $count. Man kan se det på, hvordan de spiller.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count uden sejr og de samme fejl hver uge.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count i træk. Hvad end der bliver prøvet, virker det ikke.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count på stribe. Det er en retning, ikke en dukkert.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Ingen sejre i $count, og ingen deroppe har sagt et ord.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Sig hvad du vil om fodbolden. Den her tæller dobbelt.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Mod $opponent, af alle. $score. Ingen her glemmer den.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score mod $opponent. Det er den, de vil tale om på værtshusene.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Naboerne, $score. Pralerettighederne er afgjort for en stund.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Hvad end der ellers sker i år, så er der det.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score mod $opponent. Nogle af os havde mere brug for den end tabellen.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Og de får den tilbage næste gang, det gør de altid.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Mod $opponent, $score. Et helt år med at blive mindet om den her.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name ude med skade. Det var det sidste, dette hold havde brug for.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'At miste $name ændrer formen på det hele.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name halter. Hold vejret.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Ingen $name i en rum tid, altså. Nogen må træde op.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name ude. Selvfølgelig er det $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Uden $name bliver det her et meget almindeligt hold.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name skadet igen. Nogen burde spørge hvorfor.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Mistede $name, og der er ingen bag ham. Det er det egentlige problem.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Rødt til $name efter $minute minutter, og hele landet vender sig mod ham. Han har givet os mere end de fleste. Lad ham være.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name af banen efter $minute minutter. Hårdt. Ti mand, og vi gav den stadig en chance, hvilket siger noget.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute minutter, rødt kort. Ti mand herfra.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Udvisning: $name efter $minute. Ikke den første kamp, der vender på én beslutning.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Genialt. $name går efter $minute minutter, og vi er nede på ti. Igen.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name udvist efter $minute minutter. Hvem træner egentlig disciplin her?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minutter. Så længe kunne $name bevare besindelsen. Professionel fodbold.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Rødt til $name efter $minute minutter, og jeg skal tro, at det er fremskridt.';
  }

  @override
  String get yBoardPressure0 =>
      'Bestyrelsen er blevet meget stille. Det er aldrig et godt tegn.';

  @override
  String get yBoardPressure1 =>
      'Der går rygter om, at bestyrelseslokalet er begyndt at stille spørgsmål.';

  @override
  String get yBoardPressure2 => 'Man kan mærke jorden skifte deroppe.';

  @override
  String get yBoardPressure3 =>
      'Ingen i forbundet siger noget støttende. Træk dine egne konklusioner.';

  @override
  String get yBoardPressure4 =>
      'Ingen deroppe har bakket ham op offentligt i ugevis nu.';

  @override
  String get yBoardPressure5 =>
      'Forbundet briefer imod sin egen landstræner. Som altid.';

  @override
  String get yBoardPressure6 =>
      'Når en bestyrelse bliver tavs, har de allerede besluttet sig.';

  @override
  String get yBoardPressure7 =>
      'De lader det drive, til det er en andens beslutning at tage.';

  @override
  String get yReplies => 'OGSÅ OM DENNE KAMP';

  @override
  String get yPlayerGrievance0 =>
      'Spurgte, hvor jeg står. Venter stadig på et svar.';

  @override
  String get yPlayerGrievance1 =>
      'Træner hårdt. Der er ikke meget andet, jeg kan gøre.';

  @override
  String get yPlayerGrievance2 =>
      'Nogle spørgsmål får man kun lov at stille én gang.';

  @override
  String get yPlayerGrievance3 =>
      'Jeg er ikke nået så langt for at bære veste.';

  @override
  String get playerHonoursTitle => 'HÆDER';

  @override
  String get awardGoldenBall => 'Den Gyldne Bold';

  @override
  String get awardGoldenBoot => 'Den Gyldne Støvle';

  @override
  String get awardGoldenGlove => 'Den Gyldne Handske';

  @override
  String get awardTeamOfTournament => 'Turneringens hold';

  @override
  String get awardPlayerOfYear => 'Årets verdensspiller';

  @override
  String get awardYoungPlayerOfYear => 'Årets unge spiller';

  @override
  String get playerClubHistory => 'KLUBHISTORIK';

  @override
  String get playerCareerRecord => 'KARRIEREREKORD';

  @override
  String get playerInternationalGoals => 'Landsholdsmål';

  @override
  String get playerRecentForm => 'SENESTE FORM';

  @override
  String get playerMatchHistory => 'KAMPHISTORIK';

  @override
  String get playerAttributes => 'EGENSKABER';

  @override
  String get playerUnknown => 'Ukendt';

  @override
  String get playerAttrPace => 'Fart';

  @override
  String get playerAttrPhysical => 'Fysik';

  @override
  String get playerAttrTechnical => 'Teknik';

  @override
  String get playerAttrShooting => 'Afslutning';

  @override
  String get playerAttrPassing => 'Pasninger';

  @override
  String get playerAttrDribbling => 'Dribling';

  @override
  String get playerAttrTackling => 'Tacklinger';

  @override
  String get playerAttrPositioning => 'Positionering';

  @override
  String get playerAttrComposure => 'Ro på bolden';

  @override
  String get playerAttrDecisions => 'Beslutninger';

  @override
  String get playerAttrStamina => 'Udholdenhed';

  @override
  String get playerAttrStrength => 'Styrke';

  @override
  String get playerStatCaps => 'Landskampe';

  @override
  String get playerStatGoals => 'Mål';

  @override
  String get playerStatAssists => 'Assists';

  @override
  String get playerStatAvgRating => 'Gns. karakter';

  @override
  String get playerStatForm => 'Form';

  @override
  String get playerStatMotm => 'Kampens spiller';

  @override
  String get playerStatCleanSheets => 'Clean sheets';

  @override
  String get playerStatBestGame => 'Bedste kamp';

  @override
  String get playerStatCards => 'Kort';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}G ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'DIN VEJ';

  @override
  String get tourSharedList => 'Liste';

  @override
  String get tourSharedBracket => 'Skema';

  @override
  String get tourSharedVs => 'mod';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Gruppe $seed';
  }

  @override
  String get tourSharedThisEdition => 'Denne udgave';

  @override
  String get tourSharedAllTime => 'Gennem tiderne';

  @override
  String get tourSharedUnknown => 'Ukendt';

  @override
  String get tourSharedActive => 'AKTIV';

  @override
  String get tourSharedMedalTable => 'MEDALJETABEL';

  @override
  String get tourSharedPastWinners => 'TIDLIGERE VINDERE';

  @override
  String tourSharedHost(String host) {
    return 'Vært: $host';
  }

  @override
  String get tourSharedBeat => 'slog';

  @override
  String get tourSharedPens => ' (str.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Priserne afgøres, når turneringen er spillet færdig.';

  @override
  String get tourSharedGoldenBall => 'DEN GYLDNE BOLD';

  @override
  String get tourSharedPlayerOfTournament => 'Turneringens spiller';

  @override
  String get tourSharedGoldenBoot => 'DEN GYLDNE STØVLE';

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
  String get tourSharedGoldenGlove => 'DEN GYLDNE HANDSKE';

  @override
  String get tourSharedTeamOfTournament => 'TURNERINGENS HOLD';

  @override
  String get tourSharedStatsEmpty =>
      'Rekorder dukker op, når turneringen har en vis historie.';

  @override
  String get tourSharedRecordScorer => 'REKORDSCORER';

  @override
  String get tourSharedStillActive => 'stadig aktiv';

  @override
  String get tourSharedMostTitles => 'FLEST TITLER';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titler',
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
      other: '$count spillede finaler',
      one: '1 spillet finale',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'FLEST SPILLEDE KAMPE';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kampe',
      one: '1 kamp',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'FLEST SLUTRUNDER';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slutrunder',
      one: '1 slutrunde',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'STØRSTE FINALESEJR';

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
  String get tourStatsStillActive => 'stadig aktiv';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titler',
      one: '1 titel',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spillede finaler',
      one: '1 spillet finale',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kampe',
      one: '1 kamp',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slutrunder',
      one: '1 slutrunde',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'ALLE TIDERS BEDSTE';

  @override
  String get tourStatsTabGames => 'Kampe';

  @override
  String get tourStatsTabCups => 'Turneringer';

  @override
  String get tourStatsTabScorers => 'Scorere';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'mod $opponent · $year';
  }

  @override
  String get tourHolders => 'TITELFORSVARERE';

  @override
  String tourHoldersSince(int year) {
    return 'vandt i $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'ALLE TIDERS TOPSCORERE';

  @override
  String get tourSharedSummaryEmpty =>
      'Værten og dens stadioner vises, når denne udgave er trukket.';

  @override
  String get tourSharedHostHeading => 'VÆRT';

  @override
  String get tourSharedHostsHeading => 'VÆRTER';

  @override
  String get tourSharedCoHostsHeading => 'FÆLLESVÆRTER';

  @override
  String get tourSharedVenues => 'STADIONER';

  @override
  String get tourSharedMascot => 'MASKOT';

  @override
  String get tourSharedMatchBall => 'KAMPBOLD';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity pladser';
  }

  @override
  String get tourSharedCouldNotLoad => 'Kunne ikke indlæses.';

  @override
  String get tourSharedHostTbc => 'VÆRT ENDNU IKKE BEKRÆFTET';

  @override
  String get tourSharedFinalsAreHere => 'SLUTRUNDEN ER HER';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'AFHOLDES AF  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Lad slutrunden begynde';

  @override
  String get tourSharedCompetitions => 'TURNERINGER';

  @override
  String get tourSharedWorldRanking => 'Verdensrangliste';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Turneringer kunne ikke indlæses.';

  @override
  String get tourSharedPrestigeStage => 'PRESTIGESCENEN';

  @override
  String get tourSharedOverview => 'Overblik';

  @override
  String get tourSharedWorldRankingTitle => 'Verdensrangliste';

  @override
  String get tourSharedYourCompetitions => 'DINE TURNERINGER';

  @override
  String get tourSharedOtherContinents => 'ANDRE KONTINENTER';

  @override
  String get tourSharedComingSoon => 'Turneringen kommer snart';

  @override
  String get tourSharedSoon => 'SNART';

  @override
  String get tourSharedNoQualifyingDraw => 'Ingen kvalifikationslodtrækning.';

  @override
  String get tourSharedOpenEnvelope => 'Åbn konvolutten';

  @override
  String tourSharedGroupName(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get tourSharedBall => 'Kugle';

  @override
  String get tourSharedPot => 'Pulje';

  @override
  String get tourSharedAll => 'Alle';

  @override
  String get tourSharedTapDrawTeam => 'Tryk for at trække næste hold';

  @override
  String get tourSharedTapDrawPot => 'Tryk for at trække næste pulje';

  @override
  String get tourSharedTapDrawAll => 'Tryk for at vise hele lodtrækningen';

  @override
  String get tourSharedContinue => 'Fortsæt';

  @override
  String get tourSharedPause => 'Pause';

  @override
  String get tourSharedPlay => 'Afspil';

  @override
  String get tourSharedSkip => 'Spring over';

  @override
  String tourSharedPotNumber(int number) {
    return 'PULJE $number';
  }

  @override
  String get tourSharedDrawComplete => 'LODTRÆKNING FÆRDIG';

  @override
  String get tourSharedDrawing => 'TRÆKKER…';

  @override
  String get tourContChampionship => 'MESTERSKAB';

  @override
  String get tourContTabSummary => 'OVERBLIK';

  @override
  String get tourContTabQualifying => 'KVALIFIKATION';

  @override
  String get tourContTabFinals => 'SLUTRUNDE';

  @override
  String get tourContTabBracket => 'SKEMA';

  @override
  String get tourContTabAwards => 'PRISER';

  @override
  String get tourContTabScorers => 'SCORERE';

  @override
  String get tourContTabHistory => 'HISTORIE';

  @override
  String get tourContTabRecords => 'REKORDER';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Turneringen kunne ikke indlæses.\n$error';
  }

  @override
  String get tourContNoCupData => 'Ingen turneringsdata.';

  @override
  String get tourContUnknown => 'Ukendt';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Kvalifikationsgrupperne trækkes ved ceremonien. Følg med fra forsiden for at se, hvem du møder.';

  @override
  String get tourContQualSeeded =>
      'Dit land er seedet direkte til slutrunden. Ingen kvalifikation i denne cyklus.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name simuleres i baggrunden. Resultaterne vises her, efterhånden som hver runde spilles.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Slutrundegrupperne trækkes ved ceremonien. Følg med fra forsiden for at se din gruppe.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Lodtrækningen til slutrunden finder sted, når kvalifikationen er afsluttet.';

  @override
  String get tourContContestedBeforeWc =>
      'Knockout-runderne spilles før Verdensmesterskabet.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name MESTRE';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name vindere';
  }

  @override
  String get tourContNoGoalsYet => 'Ingen mål scoret endnu.';

  @override
  String tourContGroupHeading(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get tourContBestRunnersUp => 'BEDSTE GRUPPETOERE';

  @override
  String tourContGroupDropdown(String name) {
    return 'Gruppe $name';
  }

  @override
  String get tourContMatches => 'KAMPE';

  @override
  String get tourContNoGroupsDrawn => 'Ingen grupper trukket endnu.';

  @override
  String get tourContQualifyingDraw => 'KVALIFIKATIONSLODTRÆKNING';

  @override
  String get tourContWorldQualifyingDraw => 'VM-KVALIFIKATIONSLODTRÆKNING';

  @override
  String get tourContFinalsDraw => 'SLUTRUNDELODTRÆKNING';

  @override
  String get tourContSeedingPots => 'SEEDINGPULJER';

  @override
  String get tourContGroupDraw => 'GRUPPELODTRÆKNING';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Lodtrækningen kunne ikke indlæses.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Lodtrækningen er ikke klar endnu.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'DENNE CYKLUS';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Kunne ikke indlæses.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Gemt spil ikke fundet.';

  @override
  String get tourContClashSoon =>
      'Continental Clash spilles, når begge kontinentale mestre er kendt.';

  @override
  String get tourContTwoContinentsOneMatch => 'TO KONTINENTER, ÉN KAMP';

  @override
  String get tourContVersusShort => 'mod';

  @override
  String tourContWinTheClash(String name) {
    return '$name vinder Clash';
  }

  @override
  String get tourContNoClashYet => 'Ingen Continental Clash er spillet endnu.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'DIVISIONER';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Kunne ikke indlæses.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Ingen Nations Cup-mål registreret endnu.';

  @override
  String get tourContNoNationsCupChampions =>
      'Ingen Nations Cup-mestre kåret endnu.';

  @override
  String get tourContNationsCupOffSeason =>
      'Denne cyklus\' Nations Cup begynder efter de kontinentale slutrunder. Tidligere vindere findes under Historik.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Denne cyklus\' Nations Cup-grupper lodtrækkes ved ceremonien. Se den fra forsiden for at finde ud af, hvem du møder.';

  @override
  String get tourContLeagueNoGroups =>
      'Ingen kampe i denne division i denne runde.';

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
      'Final Four spilles af A-divisionens gruppevindere, når gruppespillet er slut.';

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
  String get tourContFinal => 'FINALE';

  @override
  String get tourContNationsCupDraw => 'NATIONS CUP-LODTRÆKNING';

  @override
  String get tourContIntercontinentalPlayoff => 'INTERKONTINENTALT PLAY-OFF';

  @override
  String get tourContNoPlayoffThisCycle => 'Intet play-off i denne cyklus.';

  @override
  String get tourContPlayoffIntro =>
      'To VM-pladser afgøres i en knockoutrunde mellem de bedste toere fra kvalifikationen.';

  @override
  String get tourContPlayoffThrough =>
      'Du kom igennem play-offet. Du er med til Verdensmesterskabet!';

  @override
  String get tourContPlayoffOut =>
      'Du kom til kort i play-offet. Intet Verdensmesterskab denne gang.';

  @override
  String get tourContContinue => 'Fortsæt';

  @override
  String get tourContPlayoffFinals => 'PLAY-OFF-FINALER';

  @override
  String get tourContPlayoffSeeded => 'Seedet (fripas)';

  @override
  String get tourCupTabSummary => 'OVERSIGT';

  @override
  String get tourCupTabQualifying => 'KVALIFIKATION';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'Det interkontinentale play-off afgøres, når alle kontinentalforbundenes kvalifikation er færdig.';

  @override
  String get tourCupTabFinals => 'SLUTRUNDE';

  @override
  String get tourCupTabBracket => 'SKEMA';

  @override
  String get tourCupTabAwards => 'PRISER';

  @override
  String get tourCupTabScorers => 'SCORERE';

  @override
  String get tourCupTabHistory => 'HISTORIK';

  @override
  String get tourCupTabRecords => 'REKORDER';

  @override
  String get tourCupTitle => 'VERDENSMESTERSKABET';

  @override
  String get tourCupNoData => 'Ingen turneringsdata.';

  @override
  String tourCupLoadError(String error) {
    return 'Kunne ikke indlæse turneringen.\n$error';
  }

  @override
  String get tourCupUnknown => 'Ukendt';

  @override
  String get tourCupWorldChampions => 'VERDENSMESTRE';

  @override
  String get tourCupWorldChampionsTitle => 'Verdensmestre';

  @override
  String get tourCupStillActive => 'Stadig aktiv';

  @override
  String get tourCupAllTimeScorers => 'ALLE TIDERS TOPSCORERE';

  @override
  String get tourCupAllConfederations => 'Alle kontinentalforbund';

  @override
  String get tourCupBestRunnersUp => 'Bedste toere';

  @override
  String get tourCupCompWorld => 'Verdensmesterskabet';

  @override
  String get tourCupCompEurope => 'Europamesterskabet';

  @override
  String get tourCupCompSAmerica => 'Sydamerika Cup';

  @override
  String get tourCupDestRoundOf16 => 'ottendedelsfinalen';

  @override
  String get tourCupDestKnockouts => 'slutspillet';

  @override
  String get tourCupDestFinals => 'slutrunden';

  @override
  String get tourCupDestFinalsPlayoff => 'slutrundens play-off';

  @override
  String get tourCupDestIntercontPlayoff => 'det interkontinentale play-off';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Slutrunden lodtrækkes, når kvalifikationen er slut.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Grupperne skal lodtrækkes. Se VM-lodtrækningen fra forsiden for at afsløre dem.';

  @override
  String tourCupGroupName(String name) {
    return 'Gruppe $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Gruppe $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Værtsland: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Værter: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Interkontinentalt play-off';

  @override
  String get tourCupKnockoutSoon =>
      'Turneringsskemaet starter, når gruppespillet er slut.';

  @override
  String get tourCupMatches => 'KAMPE';

  @override
  String get tourCupMedalTable => 'MEDALJETABEL';

  @override
  String get tourCupMostTitles => 'FLEST TITLER';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles titler fra $editions turneringer';
  }

  @override
  String get tourCupNoGoals => 'Ingen mål endnu.';

  @override
  String get tourCupNoGroups => 'Ingen grupper lodtrukket.';

  @override
  String get tourCupNoHistory => 'Ingen historik endnu.';

  @override
  String get tourCupPastWinners => 'TIDLIGERE VINDERE';

  @override
  String get tourCupPlayoffIntro =>
      'To VM-pladser afgøres i en knockoutrunde mellem de bedste toere fra kvalifikationen.';

  @override
  String get tourCupQualDrawSoon =>
      'Grupperne skal lodtrækkes. Se kvalifikationens lodtrækning fra forsiden for at afsløre dem.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · din';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (str.)';
  }

  @override
  String get tourCupSegAllTime => 'Gennem tiderne';

  @override
  String get tourCupSegFinals => 'Slutrunde';

  @override
  String get tourCupSegQualifying => 'Kvalifikation';

  @override
  String get playerTraitsTitle => 'KENDT FOR';

  @override
  String get traitBigGame => 'Storkampsspiller';

  @override
  String get traitBigGameBlurb => 'Hæver niveauet i knockoutkampe.';

  @override
  String get traitSetPiece => 'Dødboldsspecialist';

  @override
  String get traitSetPieceBlurb =>
      'Bedre afleveringer og flere mål på dødbolde.';

  @override
  String get traitHothead => 'Hidsigprop';

  @override
  String get traitHotheadBlurb =>
      'Får langt flere kort end sine holdkammerater.';

  @override
  String get traitIronMan => 'Jernmand';

  @override
  String get traitIronManBlurb =>
      'Bliver sjældent skadet og bliver langsommere træt.';

  @override
  String get traitWonderkid => 'Vidunderbarn';

  @override
  String get traitWonderkidBlurb =>
      'Ung, allerede god og stadig i hastig udvikling.';

  @override
  String get traitLeader => 'Leder';

  @override
  String get traitLeaderBlurb => 'Løfter alle holdkammerater på banen.';

  @override
  String get traitPacey => 'Hurtig';

  @override
  String get traitPaceyBlurb => 'Svimlende fart, en trussel bag forsvaret.';

  @override
  String get traitOldHead => 'Garvet';

  @override
  String get traitOldHeadBlurb =>
      'En veteran, hvis spilforståelse holder længere end benene.';

  @override
  String get traitWasteful => 'Upræcis';

  @override
  String get traitWastefulBlurb => 'Brænder for mange gode chancer.';

  @override
  String get objectiveWorldCup => 'Verdensmesterskabet';

  @override
  String get objectiveWinTournament => 'Vind det';

  @override
  String get objectiveQualifyGeneric => 'Kvalificér dig';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Vind Verdensmesterskabet';

  @override
  String get objectiveReachFinal => 'Nå finalen';

  @override
  String get objectiveReachSemis => 'Nå semifinalen';

  @override
  String get objectiveReachQuarters => 'Nå kvartfinalen';

  @override
  String get objectiveReachKnockouts => 'Nå slutspillet';

  @override
  String get objectiveQualify => 'Kvalificér dig til Verdensmesterskabet';

  @override
  String get finishChampions => 'Mestre';

  @override
  String get finishRunnersUp => 'Toer';

  @override
  String get finishSemiFinals => 'Semifinale';

  @override
  String get finishQuarterFinals => 'Kvartfinale';

  @override
  String get finishRoundOf16 => 'Ottendedelsfinale';

  @override
  String get finishGroupStage => 'Gruppespil';

  @override
  String get objectiveQualifyingTopHalf =>
      'Slut i den øverste halvdel af kvalifikationen';

  @override
  String get finishQualifyingTopHalf =>
      'Øverste halvdel af kvalifikationsgruppen';

  @override
  String get finishQualifyingBottomHalf =>
      'Nederste halvdel af kvalifikationsgruppen';

  @override
  String get objectiveNcWinIt => 'Vind Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Nå Nations Cup-finalen';

  @override
  String get objectiveNcFinalsFour => 'Nå Final Four';

  @override
  String get objectiveNcWinGroup => 'Vind din gruppe og ryk op';

  @override
  String get objectiveNcTopHalf => 'Slut i den øverste halvdel af din gruppe';

  @override
  String get objectiveNcSurvive => 'Undgå nedrykning';

  @override
  String get finishNcChampions => 'Nations Cup-vindere';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Gruppevindere';

  @override
  String get finishNcTopHalf => 'Øverste halvdel af gruppen';

  @override
  String get finishNcStayedUp => 'Undgik nedrykning';

  @override
  String get finishNcBottom => 'Bunden af gruppen';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'SPILLER';

  @override
  String get squadDevAge => 'ALDER';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'KARAKTER';

  @override
  String get squadDevNew => 'NY';

  @override
  String get squadDevRetired => 'STOPPET';

  @override
  String get squadDevEmpty => 'Et roligt år. Ingen ændringer i truppen.';

  @override
  String get squadDevTierRegulars => 'FASTE';

  @override
  String get squadDevTierFringe => 'RANDEN';

  @override
  String get squadDevTierYouth => 'UNGDOM';

  @override
  String get boardObjectivesTitle => 'Bestyrelsens mål';

  @override
  String get boardObjectivesConfidence => 'Bestyrelsens tillid';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds runder bedre end krævet',
      one: 'en runde bedre end krævet',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds runder for kort',
      one: 'en runde for kort',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ENDNU IKKE AFGJORT';

  @override
  String boardObjectiveSoFar(String result) {
    return 'INDTIL VIDERE · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Bestyrelsen har ikke sat noget mål for denne cyklus.';

  @override
  String get tourContBestWinners => 'BEDSTE GRUPPEVINDERE';

  @override
  String get tourContBestThirds => 'BEDSTE TREERE';

  @override
  String tourContBestPlaced(String position) {
    return 'BEDSTE NR. $position';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total spillere';
  }

  @override
  String get matchSoldOut => 'UDSOLGT';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance af $capacity pladser fyldt';
  }

  @override
  String get matchGroundTitle => 'STADION';

  @override
  String get absenceInjured => 'Skadet';

  @override
  String get absenceSuspended => 'Suspenderet';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString uger',
      one: '1 uge',
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
      other: '$countString kampe',
      one: '1 kamp',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Tilbage til $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Straffespark';

  @override
  String get penaltyOrderBlurb =>
      'Navngiv dine fem skytter i rækkefølge. Tryk på en plads for at ændre den.';

  @override
  String penaltyOrderPick(int number) {
    return 'Spark $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Vælg, hvem der træder frem. Bjælken viser deres ro fra pletten.';

  @override
  String get penaltyOrderConfirm => 'Start';

  @override
  String get penaltyOrderCancel => 'Tilbage';

  @override
  String get youthTitle => 'Ungdom';

  @override
  String get youthEmptyLevel => 'Ingen på dette niveau endnu.';

  @override
  String get youthReleased => 'Frigivet i år';

  @override
  String get u21Title => 'U21';

  @override
  String get u21Blurb =>
      'Den næste generation, bedste talent først. Hule stjerner er et skøn fra en scout. Giv spilleren en landskamp for at finde ud af, hvad han virkelig kan.';

  @override
  String get u21Empty =>
      'Ingen under 21 i puljen lige nu. Næste indtag kommer med den nye cyklus.';

  @override
  String u21Breakout(int gain) {
    return '+$gain I ÅR';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Alder $age · $caps landskampe';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Alder $age · uden landskamp';
  }

  @override
  String get u21CallUps => 'Gå til udtagelser';

  @override
  String get youthWatching => 'Følger';

  @override
  String get youthWatchEmpty =>
      'Ingen markeret endnu. Markér en dreng på et vilkårligt niveau, så dukker han op her, med det, han er blevet til siden.';

  @override
  String get youthWatchMark => 'Følg denne dreng';

  @override
  String get youthWatchUnmark => 'Stop med at følge ham';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Markeret ved $rating, $age år';
  }

  @override
  String get youthWatchSenior => 'Videre til seniorpuljen';

  @override
  String get youthWatchReleased => 'Frigivet af akademiet';

  @override
  String get youthWatchGone => 'Ikke længere i pyramiden';

  @override
  String get tacticsYouth => 'U21';

  @override
  String get pressSquad => 'Trup';

  @override
  String get pressBoard => 'Bestyrelse';

  @override
  String get pressNoEffect => 'Ingen lægger vægt på det';

  @override
  String get matchNeutralGround => 'NEUTRAL';

  @override
  String get matchExtraTimeAhead => 'FORLÆNGET SPILLETID';

  @override
  String get matchExtraTimeHalf => 'FORLÆNGET SPILLETID · PAUSE';

  @override
  String get matchClockFullTime => 'SLUTFLØJT';

  @override
  String get matchClockAfterExtraTime => 'EFTER FORLÆNGET SPILLETID';

  @override
  String get matchClockPenalties => 'STRAFFESPARK';

  @override
  String get matchClockFullTimePenalties => 'SLUTFLØJT · STRAFFE';

  @override
  String get hubEventPressConference => 'Mød pressen';

  @override
  String get hubEventPressConferenceSub =>
      'Verdens medier vil tale med dig før din første kamp';

  @override
  String get squadDevWonderkid => 'VIDUNDERBARN';

  @override
  String get tacticsPlaystyle => 'Spillestil';

  @override
  String get tacticsPlaystyleBlurb =>
      'Vælg, hvordan holdet spiller; knapperne nedenfor finjusterer den.';

  @override
  String get tacticsPlaystyleCustom =>
      'Dine egne indstillinger. Ingen navngiven stil passer til disse knapper.';

  @override
  String get playstyleCustom => 'Tilpasset';

  @override
  String get playstyleBalanced => 'Balanceret';

  @override
  String get playstylePossession => 'Boldbesiddelse';

  @override
  String get playstyleGegenpress => 'Gegenpres';

  @override
  String get playstyleCounter => 'Kontraangreb';

  @override
  String get playstyleDirect => 'Direkte';

  @override
  String get playstyleLowBlock => 'Lav blok';

  @override
  String get playstyleWingPlay => 'Fløjspil';

  @override
  String get playstyleBalancedBlurb =>
      'Solid i begge halvdele, uden noget overdrevet.';

  @override
  String get playstylePossessionBlurb =>
      'Hold på bolden, spil tålmodigt og pres banen sammen.';

  @override
  String get playstyleGegenpressBlurb =>
      'Vind bolden tilbage i samme sekund, den mistes, højt oppe på banen.';

  @override
  String get playstyleCounterBlurb =>
      'Træk dig tilbage, hold formationen, og slå så til i fart.';

  @override
  String get playstyleDirectBlurb =>
      'Hurtigt fremad, og spil på den anden bold.';

  @override
  String get playstyleLowBlockBlurb =>
      'Dybt, smalt og meget svært at spille igennem.';

  @override
  String get playstyleWingPlayBlurb => 'Stræk banen, gå udenom og slå indlæg.';

  @override
  String get nationsRandomTeam => 'Tilfældigt hold';

  @override
  String get nationsFromTheBottom => 'Fra bunden';

  @override
  String get bottomStartTitle => 'Uden job';

  @override
  String get bottomStartHeading => 'Tre forbund vil tale med dig';

  @override
  String get bottomStartBlurb =>
      'Du har intet job og intet ry. Det er de eneste hold, der vil give dig en chance. Tag et og byg noget op fra ingenting.';

  @override
  String get bottomStartAccept => 'Tag det';

  @override
  String get bottomStartBack => 'Tilbage til menuen';

  @override
  String bottomStartRankOf(int rank, int total) {
    return 'Nr. $rank af $total i verden';
  }

  @override
  String get campTitle => 'Base camp';

  @override
  String campBasedIn(String host) {
    return 'Base i $host';
  }

  @override
  String get campBlurb =>
      'Hvor truppen bor under hele turneringen. Den kan ikke ændres, når spillet er gået i gang, og den påvirker tre ting i hver kamp: hvor friske spillerne ankommer, hvor hurtigt en skade heler, og hvor skarpe de er.';

  @override
  String get campEffectTravel => 'Ankom friske';

  @override
  String get campEffectRecovery => 'Skader heler';

  @override
  String get campEffectSharpness => 'Kampskarphed';

  @override
  String get campTerrainCity => 'Bymidte';

  @override
  String get campTerrainCoastal => 'Kystresort';

  @override
  String get campTerrainMountain => 'Bjergretræte';

  @override
  String get campTerrainAltitude => 'Højdelejr';

  @override
  String get campTerrainNationalCentre => 'Nationalt center';

  @override
  String get campTerrainCityBlurb =>
      'Alt lige uden for døren og intet at rejse til, men ingen ro og ingen flugt fra larmen.';

  @override
  String get campTerrainCoastalBlurb =>
      'Rolig, behagelig og god for humøret; en lang busrejse til hver stadion.';

  @override
  String get campTerrainMountainBlurb =>
      'Kold luft og en førsteklasses medicinsk opsætning, der får skader til at hele hurtigt, langt fra turneringen.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Hårdt at træne i, men giver ben, der holder langt ind i turneringen.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Forbundets egne faciliteter: intet opsigtsvækkende, intet der kan gå galt.';

  @override
  String get hubEventChooseCamp => 'Vælg base camp';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Hvor truppen skal bo i $host';
  }

  @override
  String get tacticsTabBench => 'Bænk';

  @override
  String get squadSearchHint => 'Søg på navn eller klub';

  @override
  String get squadFilterAll => 'Alle';

  @override
  String get squadFilterInSquad => 'I truppen';

  @override
  String get squadFilterUncapped => 'Uden landskamp';

  @override
  String get squadFilterUnavailable => 'Ikke tilgængelig';

  @override
  String get squadLineAll => 'Alle rækker';

  @override
  String get squadSortBy => 'Sortér';

  @override
  String get squadSortRating => 'Karakter';

  @override
  String get squadSortCaps => 'Landskampe';

  @override
  String get squadSortGoals => 'Mål';

  @override
  String get squadSortAge => 'Alder';

  @override
  String get squadSortName => 'Navn';

  @override
  String get squadLegendTitle => 'Hvad mærkerne betyder';

  @override
  String get squadLegendStarting => 'I din startopstilling';

  @override
  String get squadLegendCalledUp => 'Udtaget, på bænken';

  @override
  String get squadLegendRatingUp => 'Karakter stigende i år';

  @override
  String get squadLegendRatingDown => 'Karakter faldende i år';

  @override
  String get squadLegendInjured => 'Skadet, ikke tilgængelig';

  @override
  String get squadLegendSuspended => 'Suspenderet, ikke tilgængelig';

  @override
  String get squadLegendTraits => 'KENDT FOR';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Viser $shown af $total spillere';
  }

  @override
  String get squadNobodyMatches => 'Ingen i puljen passer til disse filtre.';

  @override
  String get squadStatPool => 'Pulje';

  @override
  String get squadStatInSquad => 'Udtaget';

  @override
  String get squadMostCapped => 'Flest landskampe';

  @override
  String get squadTopScorer => 'Topscorer';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps landskampe';
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
  String get squadCapsShort => 'LK';

  @override
  String get squadGoalsShort => 'Mål';

  @override
  String get recordsRecordBookSubtitle =>
      'Landskampe, mål og holdets vigtigste rekorder';

  @override
  String get statsLegacy => 'ARV';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name er allerede skiftet ud og kan ikke komme på igen.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name er blevet udvist og deltager ikke mere.';
  }

  @override
  String get tacticsInjuredShort => 'SKADET';

  @override
  String get tacticsSuspendedShort => 'SUSPENDERET';

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
  String get compWorldCup => 'Verdensmesterskabet';

  @override
  String get compWorldCupFinals => 'VM-slutrunden';

  @override
  String get compWorldCupQualifying => 'VM-kvalifikation';

  @override
  String compQualifiers(String region) {
    return '$region-kvalifikation';
  }

  @override
  String get compFriendlies => 'Venskabskampe';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Interkontinentalt play-off';

  @override
  String get compContinentalChampionship => 'Kontinentalmesterskab';

  @override
  String get compEuropeanChampionship => 'Europamesterskabet';

  @override
  String get compSouthAmericaCup => 'Sydamerika Cup';

  @override
  String get compAfricanChampionship => 'Afrikamesterskabet';

  @override
  String get compAsianChampionship => 'Asienmesterskabet';

  @override
  String get compNorthAmericaCup => 'Nordamerika Cup';

  @override
  String get compOceaniaCup => 'Oceanien Cup';

  @override
  String get msgANation => 'Et land';

  @override
  String get msgAPlayer => 'En spiller';

  @override
  String get msgAHostNation => 'et værtsland';

  @override
  String get msgCycleTitle1 => 'En ny cyklus begynder';

  @override
  String msgCycleTitle2(int year) {
    return 'Vejen mod $year åbner sig';
  }

  @override
  String get msgCycleTitle3 => 'En ny kampagne gryer';

  @override
  String get msgCycleTitle4 => 'Tilbage på arbejde';

  @override
  String msgCycleBody1(int year) {
    return 'Vejen mod VM $year starter her.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'En ny cyklus. Målet er VM $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Fire år til VM $year. Arbejdet starter nu.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Kampagnen for $year begynder i dag.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Vært for $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host bliver vært for næste $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Kvalifikationslodtrækning: $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Kvalifikationsgrupperne til $cup er lodtrukket.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Vært for VM $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host bliver vært for VM $year.';
  }

  @override
  String get msgWcQualDrawTitle => 'Lodtrækning til VM-kvalifikationen';

  @override
  String get msgWcQualDrawBody =>
      'Grupperne til VM-kvalifikationen er lodtrukket.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Slutrundelodtrækning: $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Slutrundegrupperne til $cup er lodtrukket.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'Lodtrækning til VM-slutrunden';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Lodtrækningen til VM-slutrunden $year er foretaget.';
  }

  @override
  String get msgQualWcTitle1 => 'Videre til Verdensmesterskabet';

  @override
  String get msgQualWcTitle2 => 'VM-billetten er i hus';

  @override
  String get msgQualWcTitle3 => 'Vi skal til Verdensmesterskabet';

  @override
  String get msgQualWcTitle4 => 'Billetten er stemplet';

  @override
  String msgQualWcBody1(int year) {
    return 'Du har kvalificeret dig til VM-slutrunden $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Det er officielt: dit land er med til VM $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'En plads ved VM $year er sikret.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Du er videre til VM-slutrunden $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Videre til $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup: billetten er i hus';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Kvalificeret til $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Du har kvalificeret dig til slutrunden i $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Dit land har sikret sig en plads ved $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Du er videre til $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return 'MESTRE I $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Mestre i $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Du har vundet $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp er afgjort';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: mestrene er kåret';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp er vundet';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Dit land er mestre i $comp $year efter sejr over $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Du har vundet $comp $year og besejret $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year er jeres. $loser er slået$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner vandt $comp $year og slog $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner er mestre i $comp $year efter sejr over $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away i finalen';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' på straffespark efter en finale på $home–$away';
  }

  @override
  String get msgWpotyTitle => 'Årets verdensspiller';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) er kåret som Årets verdensspiller $year, en af dine egne.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) er kåret som Årets verdensspiller $year.';
  }

  @override
  String get msgYpotTitle => 'Turneringens unge spiller';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age år, er kåret som Turneringens unge spiller $year, en af dine egne.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age år, er kåret som Turneringens unge spiller $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Du holder positionen som nr. $rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Ingen ændring, stadig nr. $rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabil som nr. $rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move pladser',
      one: '1 plads',
    );
    return 'Op $_temp0 i alt, til nr. $rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move pladser',
      one: '1 plads',
    );
    return 'En fremgang på $_temp0 løfter dig til nr. $rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move pladser',
      one: '1 plads',
    );
    return 'Op $_temp0, nu nr. $rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move pladser',
      one: '1 plads',
    );
    return 'Ned $_temp0 i alt, til nr. $rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move pladser',
      one: '1 plads',
    );
    return 'Et fald på $_temp0 sender dig ned på nr. $rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move pladser',
      one: '1 plads',
    );
    return 'Ned $_temp0, nu nr. $rank.';
  }

  @override
  String get msgRankLeadYou => 'Du topper verdensranglisten.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation topper verdensranglisten.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Verdensranglisten · nr. $rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Verdensranglisten er opdateret. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Et hop op til nr. $rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Et fald til nr. $rank';
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
      other: '$move pladser',
      one: '1 plads',
    );
    return '$tournament har rykket ved verdensranglisten. $nation startede som nr. $from og endte som nr. $to, en fremgang på $_temp0.';
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
      other: '$move pladser',
      one: '1 plads',
    );
    return '$tournament har rykket ved verdensranglisten. $nation startede som nr. $from og endte som nr. $to, et fald på $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Siden VM-lodtrækningen';

  @override
  String get rankingSinceCycleStart => 'Siden kampagnens start';

  @override
  String rankingMovedFromTo(int from, int now) {
    return 'Nr. $from til nr. $now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name når $count landskampe';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name har nu spillet $count landskampe for dit land.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name når $count mål';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name har nu scoret $count landsholdsmål for dit land.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Truppens udvikling · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Op fra akademiet · $year';
  }

  @override
  String get msgThroughNote =>
      'Det er ikke et nyt indtag. Det er drengene, der startede som 11-årige og nu er vokset ind i seniorpuljen.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Nye ansigter · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Akademiinvesteringen kan ses: dette indtag er kommet stærkere ind, end det ellers ville have gjort.';

  @override
  String get msgIntakeNoteStanding =>
      'Landet holder øje med dette hold: nu hvor holdet klatrer på verdensranglisten, vælger de bedste drenge fodbold, og dette indtag er kommet stærkere ind på grund af det.';

  @override
  String get msgIntakeNoteBoth =>
      'Både akademipengene og holdets klatring på verdensranglisten kan ses: dette indtag er kommet stærkere ind, end det ellers ville have gjort.';

  @override
  String msgIntakeTitle(int year) {
    return 'Akademiindtag · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Din anfører $name stopper';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name stopper på landsholdet';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name er stoppet på landsholdet som $age-årig.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name er stoppet på landsholdet som $age-årig og takker af med $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count landskampe',
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
      ' Anførerbindet er ledigt. Udpeg en ny anfører fra udtagelsesskærmen.';

  @override
  String msgHofTitle(String name) {
    return '$name optaget i Hall of Fame';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name kommer ind i dit lands Hall of Fame ($caps landskampe, $goals mål). Se dem under Legender.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name suspenderet';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'de næste $matches kampe',
      one: 'din næste kamp',
    );
    return '$name $how og er suspenderet i $_temp0. Spilleren kan ikke udtages.';
  }

  @override
  String get hubBanHowSecondYellow => 'blev udvist for to gule kort';

  @override
  String get hubBanHowViolent =>
      'blev vist direkte rødt kort for voldelig adfærd';

  @override
  String get hubBanHowRed => 'blev udvist';

  @override
  String hubInjuryTitle(String name) {
    return '$name skadet';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches kampe',
      one: '1 kamp',
    );
    return '$name fik en skade og er ude i $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Toer';

  @override
  String get hubRunnerUpTitle2 => 'Så tæt på, men alligevel så langt væk';

  @override
  String get hubRunnerUpTitle3 => 'Sølvmedaljer';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Du nåede finalen i $cup, men tabte til $opponent. Så tæt på. Sølv denne gang.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Slået af $opponent i finalen i $cup. Toer, pinefuldt tæt på.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Finalen i $cup gled væk mod $opponent. Der er meget at være stolt af, men ikke pokalen.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Slået ud';

  @override
  String get hubKnockedOutTitle2 => 'Enden på vejen';

  @override
  String get hubKnockedOutTitle3 => 'Rejsen er slut';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Du er ude af $cup, slået af $opponent ($stage).';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent sender dig ud af $cup ($stage).';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Din tur i $cup slutter her, slået af $opponent ($stage).';
  }

  @override
  String get hubGroupExitTitle1 => 'Ude i gruppespillet';

  @override
  String get hubGroupExitTitle2 => 'Færdig i gruppespillet';

  @override
  String get hubGroupExitTitle3 => 'Tidlig hjemrejse';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup er slut for dig i gruppespillet. Det rakte ikke til slutspillet.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Du kom ikke videre fra gruppen. $cup slutter her for dig.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Ingen plads i slutspillet denne gang. $cup er slut for dig i gruppespillet.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Mål nået: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Mål ikke nået: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Bestyrelsens mål ved $comp: $demand. Du endte som: $finish. De har fået, hvad de bad om.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Bestyrelsens mål ved $comp: $demand. Du endte som: $finish. Det er under det forventede.';
  }

  @override
  String get newsWcMissTitle => 'Drømmen om VM er slut';

  @override
  String newsWcMissBody(int year) {
    return 'Du kom ikke med til VM $year. Kvalifikationen rakte ikke. Fire år til.';
  }

  @override
  String get newsRecordScorerTitle => 'Alle tiders topscorer';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name er nu spillets bedste målscorer gennem tiderne med $goals mål.';
  }

  @override
  String get newsRecordCapsTitle => 'Flest landskampe';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name er nu spillets mest benyttede landsholdsspiller med $caps landskampe.';
  }

  @override
  String get newsARecordBreaker => 'En ny rekordholder';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name skifter til $club';
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
    return '$name ($position, $rating) har forladt $fromClub og skrevet under for $destination for $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club i $country';
  }

  @override
  String get newsTransferFree => 'Gratis';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ $name vil skifte til $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name vil spille for $nation';
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
    return '$name, en $age-årig $position med styrke $rating, der i dag spiller for $fromNation, har familiebånd til $nation og er åben for et skifte. Åbn naturalisationstilbuddet for at acceptere eller afslå.';
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
    return '$name, en $age-årig $position med styrke $rating, der i dag spiller for $fromNation, er et stort navn med familiebånd til $nation og er åben for et skifte. Åbn naturalisationstilbuddet for at acceptere eller afslå.';
  }

  @override
  String get newsTheirNation => 'deres land';

  @override
  String get newsYourNation => 'dit land';

  @override
  String get tourStatusChampions => 'MESTRE';

  @override
  String get tourStatusFinals => 'SLUTRUNDE';

  @override
  String get tourStatusQualifying => 'KVALIFIKATION';

  @override
  String get tourStatusUpcoming => 'KOMMER';

  @override
  String get tourStatusInProgress => 'I GANG';

  @override
  String get tourStatusComingSoon => 'SNART';

  @override
  String get tourStatusDecided => 'AFGJORT';

  @override
  String tourStatusLeague(String letter) {
    return 'DIVISION $letter';
  }

  @override
  String get tourDrawWcQualifying => 'LODTRÆKNING: VM-KVALIFIKATION';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup: KVALIFIKATIONSLODTRÆKNING';
  }

  @override
  String get tourDrawWcHost => 'VM: VÆRTSLAND';

  @override
  String tourDrawContHost(String cup) {
    return '$cup: VÆRTSLAND';
  }

  @override
  String get tourDrawHostsReveal => 'Og værterne bliver…';

  @override
  String get tourDrawHostReveal => 'Og værten bliver…';

  @override
  String get tourDrawHostCandidates => 'Kandidaterne i opløbet:';

  @override
  String get tourKickoffContinentalCup => 'KONTINENTAL CUP';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup gik forbi';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Du kvalificerede dig ikke til $cup. Kampagnen rakte ikke denne gang.';
  }

  @override
  String get potyLabelBest => 'Årets spiller';

  @override
  String get potyLabelYoung => 'Årets unge spiller';

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
    return 'Styrke $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Karakter $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Årets verdensspiller $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name er verdens bedste spiller i år.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name får prisen som årets unge spiller.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Drengene, du følger, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain point',
      one: 'et point',
    );
    return '$name har taget et spring til $rating, $_temp0 mere end sidste år.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name rykker op i aldersgruppen $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name fejrer debut';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name har fået sin første landskamp som $age-årig med styrke $rating. En af de drenge, du følger.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Boldbesiddelse, spillerkarakterer og kampens spiller afgøres ved slutfløjtet.';

  @override
  String get matchPlayerRatings => 'SPILLERKARAKTERER';

  @override
  String get matchSubstitutions => 'UDSKIFTNINGER';

  @override
  String get matchSubstitutes => 'UDSKIFTERE';

  @override
  String get matchPlayerOfTheMatch => 'KAMPENS SPILLER';

  @override
  String get matchGoalShout => 'MÅL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'STRAFFESPARK $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: MÅL';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: FEJL';
  }

  @override
  String get matchFeedKickOff => 'Anspark!';

  @override
  String get matchFeedNoEvents => 'Ingen begivenheder endnu.';

  @override
  String get tourVenues => 'STADIONER';

  @override
  String tourPot(int number) {
    return 'PULJE $number';
  }

  @override
  String get tourHostSelection => 'VALG AF VÆRT';

  @override
  String get tourCandidates => 'KANDIDATER';

  @override
  String get tourJointBid => 'FÆLLES BUD';

  @override
  String get tourGoldenGlove => 'DEN GYLDNE HANDSKE';

  @override
  String get tourTeamOfTournament => 'TURNERINGENS HOLD';

  @override
  String get tourYourRun => 'DIN VEJ';

  @override
  String get tourMedalTable => 'MEDALJETABEL';

  @override
  String tourHostLine(String nation) {
    return 'Vært: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Værter: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Gruppe $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Seedet efter verdensranglisten. Find dit land før lodtrækningen.';

  @override
  String get tourWorldRanking => 'Verdensrangliste';

  @override
  String get tourYourCompetitions => 'DINE TURNERINGER';

  @override
  String get tourOtherContinents => 'ANDRE KONTINENTER';

  @override
  String get tourZoneGlobal => 'GLOBALT';

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
    return 'VÆRT  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Top $count går videre til $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name vender ryggen til';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name er stoppet på landsholdet som $age-årig efter $caps landskampe. Han bad om at få at vide, hvor han stod, og fik intet svar, så han venter ikke længere.';
  }

  @override
  String get pressHeadlineWent1 => 'En træner, der styrer rummet';

  @override
  String get pressHeadlineWent2 => 'De kom efter ballade og fik en leder';

  @override
  String get pressHeadlineWent3 => 'Lige svar, og de ramte plet';

  @override
  String get pressHeadlineMixed1 => 'Meget sagt, lidt afklaret';

  @override
  String get pressHeadlineMixed2 => 'Lidt til alle og intet til nogen';

  @override
  String get pressHeadlineMixed3 => 'Et pressemøde, der lod spørgsmålene hænge';

  @override
  String get pressHeadlineBadly1 => 'En hård eftermiddag foran kameraerne';

  @override
  String get pressHeadlineBadly2 => 'Stemningen vendte, og det kunne ses';

  @override
  String get pressHeadlineBadly3 => 'Svar, der ser værre ud i morgen';

  @override
  String get pressHeadlineFlat1 => 'Intet sagt, intet vundet';

  @override
  String get pressHeadlineFlat2 => 'Ti minutter, ingen nyheder';

  @override
  String get pressHeadlineFlat3 => 'Et blankt ark til bagsiden';

  @override
  String get pressConferenceTitle => 'PRESSEMØDE';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Spørgsmål $index af $total';
  }

  @override
  String get pressTomorrowsHeadline => 'I MORGEN PÅ BAGSIDEN';

  @override
  String get pressLeaveRoom => 'FORLAD LOKALET';

  @override
  String get pressRoomVerdictSquad => 'Omklædningsrum';

  @override
  String get pressRoomVerdictBoard => 'Bestyrelse';

  @override
  String get yReactionElation0 => 'ingen kommentarer. ingen. perfekt.';

  @override
  String get yReactionElation1 => 'Jeg er syg (på den gode måde).';

  @override
  String get yReactionElation2 => 'indrammer den her. hænger den over kaminen.';

  @override
  String get yReactionElation3 => 'vi er så tilbage';

  @override
  String get yReactionElation4 =>
      'Tager screenshot til alle tvivlerne. Alle sammen.';

  @override
  String get yReactionElation5 =>
      'Jeg kommer til at være uudholdelig om det her i ti år.';

  @override
  String get yReactionElation6 => 'Ja. Det er derfor, vi ser fodbold.';

  @override
  String get yReactionElation7 => 'Dage som den her betaler for alle de andre.';

  @override
  String get yReactionElation8 => 'Det var på tide. Helt ærligt, på tide.';

  @override
  String get yReactionElation9 =>
      'Fedt. Gør det igen i næste uge, så tror jeg på det.';

  @override
  String get yReactionElation10 =>
      'Nyd i aften, for de her finder en måde at ødelægge det på.';

  @override
  String get yReactionElation11 =>
      'Én god aften gør ikke nogen til et stort hold.';

  @override
  String get yReactionRelief0 =>
      'Ikke kønt, men det tager jeg hver eneste gang.';

  @override
  String get yReactionRelief1 =>
      'På en eller anden måde. På en eller anden måde!';

  @override
  String get yReactionRelief2 => 'Grimt. Tre point. Videre.';

  @override
  String get yReactionRelief3 =>
      'Jeg tager grimt hele dagen, hvis der følger point med.';

  @override
  String get yReactionRelief4 => 'den tog ti år af mit liv';

  @override
  String get yReactionRelief5 => 'Ingen siger noget. Ingen forhekser det.';

  @override
  String get yReactionRelief6 => 'Puls: uacceptabel.';

  @override
  String get yReactionRelief7 => 'Overlevet. Det er ordet. Overlevet.';

  @override
  String get yReactionRelief8 =>
      'Vi burde ikke have brug for lettelse efter sådan nogle kampe.';

  @override
  String get yReactionRelief9 => 'Lettet, og lidt flov over at være lettet.';

  @override
  String get yReactionRelief10 =>
      'Hvis det er standarden, vi jubler over, er vi i problemer.';

  @override
  String get yReactionRelief11 =>
      'At snige sig igennem er blevet en vane, og ikke en god en.';

  @override
  String get yReactionFury0 => 'Ikke godt nok. Slet ikke.';

  @override
  String get yReactionFury1 => 'Nogen må forklare mig det der langsomt.';

  @override
  String get yReactionFury2 => 'Det var hårdt at se på, og jeg er høflig.';

  @override
  String get yReactionFury3 => 'Skuffet. Oprigtigt skuffet.';

  @override
  String get yReactionFury4 => 'Det her er under al kritik.';

  @override
  String get yReactionFury5 => 'Jeg vil have navne.';

  @override
  String get yReactionFury6 => 'Sletter appen. Installerer den igen torsdag.';

  @override
  String get yReactionFury7 => 'Ingen derude så ud, som om de ville det her.';

  @override
  String get yReactionFury8 => 'Hvert fjerde år, det samme. HVERT fjerde år.';

  @override
  String get yReactionFury9 =>
      'Det er ikke en præstation, det er en fornærmelse.';

  @override
  String get yReactionFury10 =>
      'Folk bruger weekender og penge på det her. Tænk over det.';

  @override
  String get yReactionFury11 =>
      'Jeg har forsvaret det her hold i årevis. Ikke i aften. Ikke efter det der.';

  @override
  String get yReactionDespair0 => 'nå.';

  @override
  String get yReactionDespair1 => 'Ingen jokes i dag. Ingenting.';

  @override
  String get yReactionDespair2 => 'Går en tur. En lang en.';

  @override
  String get yReactionDespair3 =>
      'Jeg er løbet tør for måder at sige det her på.';

  @override
  String get yReactionDespair4 => 'Væk mig om fire år.';

  @override
  String get yReactionDespair5 => 'det her er den mørkeste tidslinje';

  @override
  String get yReactionDespair6 =>
      'Ikke engang sur mere. Det er det bekymrende.';

  @override
  String get yReactionDespair7 => 'Den her kommer til at gøre ondt i lang tid.';

  @override
  String get yReactionDespair8 =>
      'Jeg ved ikke, hvad det her er længere, men det er ikke et fodboldhold.';

  @override
  String get yReactionDespair9 =>
      'Vi er længere væk, end vi var, og ingen vil sige det.';

  @override
  String get yReactionDespair10 =>
      'En hel generation spildt, og de samme mennesker bestemmer, hvad der sker nu.';

  @override
  String get yReactionDespair11 =>
      'Hold op med at sige, at det er en proces. Den fører ingen steder hen.';

  @override
  String get yReactionSmugness0 => 'Stille og roligt, men: hvad sagde jeg.';

  @override
  String get yReactionSmugness1 => 'gem den her';

  @override
  String get yReactionSmugness2 => 'Tvivlerne er blevet meget stille.';

  @override
  String get yReactionSmugness3 => 'Ikke at nogen tæller. Jeg tæller.';

  @override
  String get yReactionSmugness4 => 'Sagde det i januar. Tjek tidslinjen.';

  @override
  String get yReactionSmugness5 =>
      'Nogle af jer skylder nogle af os en undskyldning.';

  @override
  String get yReactionSmugness6 => 'Lægger den under ting, jeg nævnte først.';

  @override
  String get yReactionSmugness7 => 'Ingen skadefryd. En lille smule skadefryd.';

  @override
  String get yReactionSmugness8 =>
      'Hvor er alle eksperterne nu? Det er et ærligt spørgsmål.';

  @override
  String get yReactionSmugness9 =>
      'Jeg vil have, at hver eneste af jer siger det tilbage til mig.';

  @override
  String get yReactionSmugness10 =>
      'Screenshot, printet, indrammet og sendt til dem, der grinede.';

  @override
  String get yReactionSmugness11 =>
      'Jeg kommer til at tage den op resten af mit liv, og I har fortjent det.';

  @override
  String get yReactionShrug0 => 'det skete. næste.';

  @override
  String get yReactionShrug1 => 'Fint. Lige meget. Videre.';

  @override
  String get yReactionShrug2 => 'Lægger den under fodbold.';

  @override
  String get yReactionShrug3 => 'Har oprigtigt ikke noget at tilføje.';

  @override
  String get yReactionShrug4 => 'ingen tanker, tomt hoved';

  @override
  String get yReactionShrug5 => 'Væk mig til den næste.';

  @override
  String get yReactionShrug6 =>
      'Det er halvandet time, jeg aldrig får tilbage.';

  @override
  String get yReactionShrug7 => 'Hverken eller, egentlig.';

  @override
  String get yReactionShrug8 =>
      'Kan ikke fortælle dig en eneste ting, der skete.';

  @override
  String get yReactionShrug9 => 'Endnu en af dem. Der er mange af dem.';

  @override
  String get yReactionShrug10 => 'Jeg så det hele og følte absolut ingenting.';

  @override
  String get yReactionShrug11 =>
      'Hvis ingen nævner den her igen, er det fint med mig.';

  @override
  String get tourThirdsUneven =>
      'Grupperne er ujævne, så resultater mod hver stor gruppes bundhold udgår, og alle hold bedømmes på de samme kampe.';

  @override
  String get careerExportSave => 'Sikkerhedskopiér dette gemte spil';

  @override
  String get careerBackupAll => 'SIKKERHEDSKOPIÉR ALLE';

  @override
  String get careerBackupAllFailed => 'Sikkerhedskopien kunne ikke skrives.';

  @override
  String get backupTitle => 'GEMTE SPIL';

  @override
  String get backupBlurb =>
      'Alle gemte spil ligger i én fil på denne telefon, og intet sikkerhedskopierer dem af sig selv. Eksportér en kopi og gem den uden for telefonen, i Filer eller iCloud Drive, så en tabt telefon eller en slettet app ikke koster dig en karriere.';

  @override
  String get backupExport => 'EKSPORTÉR SIKKERHEDSKOPI';

  @override
  String get backupExportSubject => 'FNM gemte spil';

  @override
  String get backupRestore => 'GENDAN FRA FIL';

  @override
  String get backupRestoreWarnTitle => 'Erstat alle gemte spil?';

  @override
  String get backupRestoreWarnBody =>
      'Gendannelse erstatter alle gemte spil på denne telefon med dem i filen. Appen genstarter.';

  @override
  String get backupRestoreConfirm => 'ERSTAT';

  @override
  String get backupCancel => 'ANNULLER';

  @override
  String get backupExported =>
      'Sikkerhedskopien er klar. Vælg, hvor den skal gemmes.';

  @override
  String get backupFailed => 'Sikkerhedskopien kunne ikke skrives.';

  @override
  String get backupRejectedUnreadable => 'Filen kunne ikke åbnes.';

  @override
  String get backupRejectedNotFnm => 'Det er ikke et gemt FNM-spil.';

  @override
  String get backupRejectedNewer =>
      'Det gemte spil er lavet af en nyere version af appen. Opdatér først.';

  @override
  String get backupRejectedTooOld =>
      'Det gemte spil er for gammelt til at kunne gendannes af denne version.';

  @override
  String get careerShare => 'Del denne karriere';

  @override
  String get careerImport => 'IMPORTÉR EN KARRIERE';

  @override
  String get careerShareSubject => 'En FNM-karriere';

  @override
  String get careerImported => 'Karrieren er importeret.';

  @override
  String get careerImportFailedUnreadable => 'Filen er ikke en FNM-karriere.';

  @override
  String get careerImportFailedNewer =>
      'Karrieren er eksporteret af en nyere version af appen. Opdatér først.';

  @override
  String get careerImportFailedSlotsFull =>
      'Alle dine gemmepladser er i brug. Slet et gemt spil for at gøre plads, eller lås ubegrænsede gemte spil op.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Karrieren er forbi den gratis første cyklus. Lås det fulde spil op for at hente den ind.';

  @override
  String get careerImportFailedCampaignRun =>
      'Den kampagne har allerede et forløb i gang. Genoptag eller opgiv det først.';

  @override
  String get careerShareFailed => 'Karrieren kunne ikke eksporteres.';

  @override
  String get managerRename => 'Skift navn';

  @override
  String get managerRenameSave => 'Gem';

  @override
  String get managerTitle => 'TRÆNER';

  @override
  String get managerSkills => 'DINE EVNER';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count point at bruge',
      one: '1 point at bruge',
      zero: 'Ingen point at bruge',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'To point for hver cyklus, du gennemfører, og ét for hver titel, du vinder.';

  @override
  String get managerSkillsScale =>
      'Alle evner starter på 5 og stopper på 20. Et brugt point er permanent.';

  @override
  String get managerSkillManManagement => 'Mandsledelse';

  @override
  String get managerSkillManManagementBlurb =>
      'Hvert point får det, du siger til pressen og dine spillere, til at ramme 3 % hårdere i omklædningsrummet.';

  @override
  String get managerSkillTactical => 'Taktik';

  @override
  String get managerSkillTacticalBlurb =>
      'Hvert point får en ny formation til at sidde 3 % hurtigere, så et skifte af opstilling koster dig færre kampe.';

  @override
  String get managerSkillYouth => 'Ungdomsudvikling';

  @override
  String get managerSkillYouthBlurb =>
      'Hvert point giver 1 % mere talent fra dit akademi, oven i det, du finansierer det med.';

  @override
  String get managerSkillNegotiation => 'Forhandling';

  @override
  String get managerSkillNegotiationBlurb =>
      'Hvert point giver 2 % flere penge fra forbundet, hver cyklus.';

  @override
  String get managerStaff => 'DIN STAB';

  @override
  String managerStaffWages(String amount) {
    return 'Løn: $amount pr. cyklus';
  }

  @override
  String get managerRoleAssistant => 'Assistenttræner';

  @override
  String get managerRoleAssistantBlurb =>
      'Leder træningen: færre skader og bedre unge talenter.';

  @override
  String get managerRoleScout => 'Chefscout';

  @override
  String get managerRoleScoutBlurb =>
      'Læser dine talenter og din næste modstander: mere præcise stjernevurderinger og en fordel på kampdagen.';

  @override
  String get managerRoleFitness => 'Fysisk træner';

  @override
  String get managerRoleFitnessBlurb => 'Holder dem på banen.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent % færre skader';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Unge +$points i styrke';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Ansæt en: $min % til $max % færre skader';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'og unge +$minPoints til +$maxPoints i styrke';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Vurderer $percent % af talenterne helt rigtigt';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potentiale kendt efter $caps landskampe',
      one: 'Potentiale kendt efter 1 landskamp',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points i styrke fra modstanderdossierer';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Ansæt en: $min % til $max % rigtige vurderinger';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'og potentiale kendt $minCaps til $maxCaps landskampe tidligere';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'og +$minPoints til +$maxPoints i styrke hver kamp';
  }

  @override
  String get staffEffectNone => 'Ingen effekt på din trup endnu';

  @override
  String get staffVacant => 'Ingen i stillingen';

  @override
  String get staffLeaveVacant => 'Lad stillingen stå tom';

  @override
  String get managerTierNone => 'Ingen';

  @override
  String get managerTierBasic => 'Basis';

  @override
  String get managerTierGood => 'God';

  @override
  String get managerTierElite => 'Elite';

  @override
  String get managerFree => 'gratis';

  @override
  String get managerTraining => 'MELLEM KAMPPERIODER';

  @override
  String get managerTrainingBlurb =>
      'Hvad truppen arbejder med, når der ikke er nogen kamp at spille.';

  @override
  String get managerFocusBalanced => 'Balanceret';

  @override
  String get managerFocusBalancedBlurb => 'Lidt af hvert.';

  @override
  String get managerFocusFitness => 'Kondition';

  @override
  String get managerFocusFitnessBlurb => 'Færre skrammer.';

  @override
  String get managerFocusCohesion => 'Sammenhold';

  @override
  String get managerFocusCohesionBlurb => 'Formationen sidder hurtigere.';

  @override
  String get managerFocusYouth => 'Ungdom';

  @override
  String get managerFocusYouthBlurb => 'Timer med de yngste i puljen.';

  @override
  String get tourOfferTitle => 'Første gang her?';

  @override
  String get tourOfferBody =>
      'Det her er et stort spil. Vil du have en hurtig rundtur på de skærme, der betyder noget? Det tager et minut, og du kan starte den igen når som helst fra Indstillinger.';

  @override
  String get tourOfferYes => 'Vis mig rundt';

  @override
  String get tourOfferNo => 'Nej tak';

  @override
  String get tourBack => 'Tilbage';

  @override
  String get tourNext => 'Næste';

  @override
  String get tourDone => 'Færdig';

  @override
  String get tourSkip => 'Spring over';

  @override
  String get tourHubTitle => 'Det her er hele spillet';

  @override
  String get tourHubBody =>
      'Én knap, der ændrer sig, som cyklussen skrider frem: en lodtrækning at se, en trup at udtage, en kamp at spille. Over den ser du bestyrelsens tillid til dig og de mål, den har sat.';

  @override
  String get tourBudgetTitle => 'Forbundets penge';

  @override
  String get tourBudgetBody =>
      'Én gang hver fireårige cyklus fordeler du krigskassen mellem afdelingerne. Din stab får løn af den først, så at ansætte en elitescout er en beslutning, du træffer på bekostning af akademiet, ikke ved siden af det.';

  @override
  String get tourTacticsTitle => 'Sådan spiller holdet';

  @override
  String get tourTacticsBody =>
      'Din formation, din spillemåde, din anfører og hvem der tager dødboldene. Lader du de to sidste stå uvalgt, advarer spillet dig før anspark i stedet for stille og roligt at vælge for dig.';

  @override
  String get tourSquadTitle => 'Alle, du kan vælge';

  @override
  String get tourSquadBody =>
      'Hele puljen, ikke kun truppen: hvem der er i form, hvem der døjer med en skade, hvem der er udelukket, og hvem der lige er kommet op fra akademiet.';

  @override
  String get tourCallUpsTitle => 'At udtage en trup';

  @override
  String get tourCallUpsBody =>
      'Du udtager én trup pr. landsholdsperiode, og den spiller alle periodens kampe, præcis som en rigtig landstræner gør. En skade i perioden trækker en afløser ind for dig.';

  @override
  String get tourRecordsTitle => 'Din karriere';

  @override
  String get tourRecordsBody =>
      'Alt, hvad du har gjort: kampene, holdrekorderne, pokalerne og alle de lande, du har trænet.';

  @override
  String get tourCupsTitle => 'Resten af verden';

  @override
  String get tourCupsBody =>
      'Alle turneringer, der kører lige nu: grupper, stillinger og knockout, også dem, du ikke er med i. Verden spiller videre, uanset om du kvalificerede dig.';

  @override
  String get settingsTourTitle => 'Se introduktionen igen';

  @override
  String get settingsTourBlurb =>
      'Gennemgå de vigtigste skærme igen fra start.';

  @override
  String get tourBoardTitle => 'Hvem du svarer til';

  @override
  String get tourBoardBody =>
      'Bestyrelsens tillid til dig og de mål, den har sat for denne cyklus. Misser du kravet, er det her, du ser det komme.';

  @override
  String get tourStaffTitle => 'Folkene omkring dig';

  @override
  String get tourStaffBody =>
      'En assistent, en scout og en fysisk træner, ansat ved navn. Deres løn trækkes fra dette budget før afdelingerne, så en fremragende scout er en beslutning på bekostning af akademiet.';

  @override
  String get tourPlaystyleTitle => 'Din spillemåde';

  @override
  String get tourPlaystyleBody =>
      'Formationen er kun halvdelen af en taktik. Det her er den anden halvdel: hvor højt du presser, hvor direkte du spiller, hvor meget du risikerer.';

  @override
  String get settingsTourNoSave =>
      'Start først en karriere. Rundturen besøger dine egne skærme.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Ude af position · $age år';
  }

  @override
  String get federationNextCycleLocked =>
      'Næste cyklus\' budget fastlægges i ét hug ved starten af den cyklus. Indtil da er det her, hvad dine penge laver.';

  @override
  String get federationBudgetAlreadySet => 'Allerede fastlagt for denne cyklus';

  @override
  String yFinalLooms0(String opponent) {
    return 'Det bliver $opponent i den store en. Hele ugen er det eneste, nogen kommer til at tale om.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Bekræftet: $opponent står mellem os og den. Fire år for det her.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Okay. $opponent. Ingen sover, før det her er overstået.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent næste gang, og alt andet kan vente. Hvilken uge at være i live.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Overlad skytterne til træneren';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Markeret nedenfor: hold, der spiller som $rivals, de hold, du møder i dine grupper i denne cyklus.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Transfervindue · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Sidst for $when siden';
  }

  @override
  String get settingsFreeScopeTitle => 'Én gratis fireårig cyklus';

  @override
  String get settingsFreeScopeBlurb =>
      'En komplet cyklus (kvalifikation, dit kontinentale mesterskab og Verdensmesterskabet) på to gemte spil, alle lande i verden, intet holdt tilbage. Endeløse cyklusser og ubegrænsede gemte spil er en enkelt betaling, én gang, og den dækker alle fremtidige opdateringer.';

  @override
  String get settingsUnlockedTitle => 'Låst op';

  @override
  String get settingsUnlockedBlurb =>
      'Endeløse cyklusser, ubegrænsede gemte spil og alle fremtidige opdateringer. Tak.';

  @override
  String get settingsFromDeveloperTitle => 'Fra udvikleren';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager er lavet af én person og vil blive støttet på lang sigt. Der kommer aldrig reklamer eller mikrotransaktioner. Hvis du nyder spillet, så overvej at købe den fulde version. Det er det, der holder opdateringerne i gang.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager er lavet af én person og vil blive støttet på lang sigt. Der kommer aldrig reklamer eller mikrotransaktioner. Tak, fordi du købte den fulde version. Det er det, der holder opdateringerne i gang.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Markeret nedenfor: hold, der spiller som $rivals, som du stadig skal møde.';
  }

  @override
  String get friendliesCloseToYou =>
      'Markeret nedenfor: de hold, der ligger tættest på dig på verdensranglisten. Når du er lodtrukket, følger markeringerne din gruppe.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skifter',
      one: '1 skifte',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Nyere';

  @override
  String get transfersOlder => 'Mere';

  @override
  String get transfersPagePrevious => 'Forrige';

  @override
  String get transfersPageNext => 'Næste';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Side $page af $pages';
  }

  @override
  String get transfersMovedTo => 'Skiftede til';

  @override
  String get transfersUnknownClub => 'Ukendt klub';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Det er $count gange mod $opponent nu. Nogen fører regnskab, og det er dem.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent igen. $count opgør, og vi har stadig ikke regnet dem ud.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Nummer $count mod $opponent. Det er holdt op med at være tilfældigt.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Vi har mødt $opponent $count gange og lært intet af nogen af dem.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count gange. De ved præcis, hvad vi gør.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Uanset hvad $opponent har på os, har de det stadig efter $count opgør.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Det er $count gange, det er sket på det seneste. Hvornår er det bare, hvad vi er?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count eftermiddage som den her nu. Det er et mønster, ikke held.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Vi har set præcis den her kamp $count gange på det seneste. Samme manuskript, samme slutning.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count udgaver af de samme halvfems minutter nu. Ingen retter op på det.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count gange. Kan du ikke se mønsteret nu, kigger du ikke efter.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Samme historie, $count gange. Undskyldningerne er løbet tør før resultaterne.';
  }

  @override
  String get yToldYouSo0 =>
      'Jeg sagde, det her kom, mens alle havde travlt med at fejre.';

  @override
  String get yToldYouSo1 =>
      'To gode uger og vi var en gylden generation igen. Og her er vi.';

  @override
  String get yToldYouSo2 =>
      'Dem, der bad mig nyde det i sidste måned, er blevet stille.';

  @override
  String get yToldYouSo3 =>
      'Jeg får ingen glæde af det her. Meget lidt glæde. Lidt.';

  @override
  String get yToldYouSo4 =>
      'Det var aldrig så godt, som de sagde, og det her er beviset.';

  @override
  String get yToldYouSo5 =>
      'Hver gang. Vi får at vide, at det er anderledes, og hver gang er det ikke.';

  @override
  String get tacticsSubOffAlready => 'Allerede udskiftet';

  @override
  String get tacticsSubInjured => 'Skadet';

  @override
  String get tacticsSubSentOffMark => 'Udvist';

  @override
  String get tacticsSubNoneLeft => 'Ingen skift tilbage';

  @override
  String get tacticsUndoLastChange => 'Fortryd sidste ændring';

  @override
  String get matchStrengthTitle => 'HVAD FLYTTER HOLDET';

  @override
  String get strengthFactorFamiliarity => 'Indøvet formation';

  @override
  String get strengthFactorFatigue => 'Trætte ben';

  @override
  String get strengthFactorClubForm => 'Klubform';

  @override
  String get strengthFactorMorale => 'Omklædningsrum';

  @override
  String get strengthFactorCaptain => 'Anfører';

  @override
  String get strengthFactorStaff => 'Staben';

  @override
  String get strengthFactorDossier => 'Scoutens dossier';

  @override
  String yDebut0(String name) {
    return '$name får sin første landskamp. Husk navnet.';
  }

  @override
  String yDebut1(String name) {
    return 'Debut til $name. Man kan se det på ham, ikke?';
  }

  @override
  String yDebut2(String name) {
    return '$name, første landskamp. Lad os se, hvad han gør ved den.';
  }

  @override
  String yDebut3(String name) {
    return 'Debut til $name. Truppen havde brug for friske ben et sted.';
  }

  @override
  String yDebut4(String name) {
    return '$name får en landskamp. Vi har delt mange ud på det seneste.';
  }

  @override
  String yDebut5(String name) {
    return 'Debut til $name. Endnu en, vi har glemt til foråret.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name har $count kampe uden mål og gør alt andet på banen.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count kampe uden mål til $name. De kommer i tre, det har de altid gjort.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count kampe, ingen mål.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count uden mål til $name. Værd at holde øje med.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count kampe. Ingen mål. $name kunne ikke ramme en laden.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name har ikke scoret i $count. Spil bogstaveligt talt en anden i stedet.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '$opponent næste gang. $count opgør, og det betyder stadig alt.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count gange mod $opponent nu. Kom an.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '$opponent næste gang. Spillet $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Opgør nummer $count med $opponent i denne uge.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent igen. $count af dem, og vi har lært intet.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count kampe mod $opponent, og de slår os stadig. Fantastisk.';
  }

  @override
  String get positionGoalkeeper => 'Målmand';

  @override
  String get positionLeftBack => 'Venstre back';

  @override
  String get positionCentreBack => 'Midterforsvarer';

  @override
  String get positionRightBack => 'Højre back';

  @override
  String get positionDefensiveMid => 'Defensiv midtbane';

  @override
  String get positionCentralMid => 'Central midtbane';

  @override
  String get positionAttackingMid => 'Offensiv midtbane';

  @override
  String get positionLeftMid => 'Venstre midtbane';

  @override
  String get positionRightMid => 'Højre midtbane';

  @override
  String get positionLeftWing => 'Venstre fløj';

  @override
  String get positionRightWing => 'Højre fløj';

  @override
  String get positionStriker => 'Angriber';

  @override
  String get roleNone => 'Ingen rolle';

  @override
  String get roleTargetMan => 'Targetspiller';

  @override
  String get rolePoacher => 'Målrøver';

  @override
  String get rolePlaymaker => 'Spilfordeler';

  @override
  String get roleBallWinner => 'Boldvinder';

  @override
  String get roleInvertedWinger => 'Indvendig fløjspiller';

  @override
  String get roleBallPlayingDefender => 'Spilleskabende forsvarer';

  @override
  String get roleNoneBlurb => 'Spiller sit naturlige spil.';

  @override
  String get roleTargetManBlurb =>
      'Vinder hovedstød, afleverer videre. Assists og dødbolde.';

  @override
  String get rolePoacherBlurb => 'Lurer i feltet. Langt flere mål.';

  @override
  String get rolePlaymakerBlurb => 'Skaber chancer. Langt flere assists.';

  @override
  String get roleBallWinnerBlurb =>
      'Bryder spillet op frem for at afslutte det.';

  @override
  String get roleInvertedWingerBlurb => 'Skærer ind for at skyde. Flere mål.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Starter angreb bagfra.';

  @override
  String get federationDeptYouth => 'Ungdomsakademi';

  @override
  String get federationDeptCommercial => 'Kommerciel / PR';

  @override
  String get federationDeptMedical => 'Medicin og sportsvidenskab';

  @override
  String get federationDeptNaturalisation => 'Naturalisationskontor';

  @override
  String get federationDeptBoardRelations => 'Bestyrelsesrelationer';

  @override
  String get federationDeptYouthBlurb =>
      'Bedre akademitalenter debuterer for dit land næste cyklus.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsorater giver ekstra indtægter ved cyklussens slutning.';

  @override
  String get federationDeptMedicalBlurb =>
      'Færre skader. Din trup er tilgængelig hele cyklussen.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Flere udenlandske spillere tilbyder at skifte til dit land.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Bestyrelsen bedømmer dine resultater med mere tålmodighed.';

  @override
  String get federationBuildingAcademy => 'Akademi';

  @override
  String get federationBuildingCommercial => 'Kommerciel hovedsæde';

  @override
  String get federationBuildingMedical => 'Medicinsk center';

  @override
  String get federationBuildingScouting => 'Scoutkontor';

  @override
  String get federationBuildingBoardroom => 'Bestyrelseslokale';

  @override
  String get moraleBuoyant => 'Euforisk';

  @override
  String get moralePositive => 'Positiv';

  @override
  String get moraleSettled => 'Rolig';

  @override
  String get moraleUneasy => 'Urolig';

  @override
  String get moraleRockBottom => 'I bund';

  @override
  String get matchTabTimeline => 'FORLØB';

  @override
  String get matchTabStats => 'STATISTIK';

  @override
  String get matchTabLineups => 'OPSTILLINGER';

  @override
  String get matchPenalty => 'STRAFFESPARK';

  @override
  String get matchStateLevel => 'Det står lige';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du fører med $count mål',
      one: 'Du fører med et mål',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du er bagud med $count mål',
      one: 'Du er bagud med et mål',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession % boldbesiddelse';
  }

  @override
  String get boardVerdictSackedTitle => 'Bestyrelsen har fyret dig';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'En elendig cyklus (vurdering $rating %). Din tid ender her. Nu er det kun svagere lande, der vil give dig en chance.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Bestyrelsen er henrykt';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'En fremragende cyklus (vurdering $rating %) efter $best. Større lande er interesserede, eller du kan blive og bygge videre.';
  }

  @override
  String get boardVerdictSolidTitle => 'En solid cyklus';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Bestyrelsen er tilfreds (vurdering $rating %). Nogle få lande på samme niveau vil gerne have dig, men der er intet pres for at skifte.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Bestyrelsen forventede mere';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'En skuffende cyklus (vurdering $rating %). Du beholder jobbet, men alle tilbud er et skridt ned.';
  }

  @override
  String get boardVerdictPressureTitle => 'Du er under reelt pres';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'En svag cyklus (vurdering $rating %). Du overlever, men det er kun svagere lande, der er interesserede, hvis du vil starte forfra.';
  }

  @override
  String get boardVerdictHeroTitle => 'Nationen står last og brast med dig';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cyklusser',
      one: '1 cyklus',
    );
    return ' $nation elsker dig, en national helt efter $_temp0; dit job er sikkert, så længe du vil have det.';
  }

  @override
  String get boardVerdictTheNation => 'Nationen';

  @override
  String get boardVerdictBestQuiet => 'en rolig cyklus';

  @override
  String get boardVerdictBestCycle => 'cyklussen';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Verdensmesterskabet: $placement';
  }

  @override
  String get finishThirdPlace => 'Tredjeplads';

  @override
  String get finishFourthPlace => 'Fjerdeplads';

  @override
  String get finishDidNotQualify => 'Ikke kvalificeret';

  @override
  String get careerRepIconic => 'Ikonisk';

  @override
  String get careerRepRenowned => 'Anerkendt';

  @override
  String get careerRepEstablished => 'Etableret';

  @override
  String get careerRepRising => 'På vej op';

  @override
  String get careerRepUnproven => 'Uprøvet';

  @override
  String get hubOfferStepUp => 'Et skridt op';

  @override
  String get hubOfferLateral => 'Sidelæns skridt';

  @override
  String get hubOfferRebuild => 'Genopbygning';

  @override
  String careerNationsCupWon(String league) {
    return 'Division $league · Mestre';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Division $league · Toer';
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
    return 'Næste runde: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Ind i bronzekampen';

  @override
  String tourRunThrough(String round) {
    return 'Videre fra runden: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Slået ud i runden: $round';
  }

  @override
  String get tourRunInGroup => 'Kæmper i gruppespillet';

  @override
  String get tourRunGroupOut => 'Udgået i gruppespillet';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Cyklus $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played spillet  ·  ${won}V ${drawn}U ${lost}T';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Verdensmesterskabet: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Spilles stadig';

  @override
  String yTurnedItRound0(String opponent) {
    return 'To under mod $opponent i pausen, og de tog hver en tomme tilbage. Det er et hold.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'To bagud mod $opponent, og til sidst betød det ingenting. Det er der ikke mange hold, der kan.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Pause: to mål under mod $opponent. Slutfløjt: ikke længere. Anden halvleg var en helt anden kamp.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Vendte det fra 0-2 mod $opponent. Hvad end der blev sagt i pausen, så sig det hver uge.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Fint, vi fik det hjem mod $opponent. Nu må nogen forklare de første femogfyrre minutter.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'To under mod $opponent, og vi skal være henrykte. Ret første halvleg.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'To mål foran mod $opponent i pausen, og det smuldrede. Det sker for bedre hold.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'To mål foran mod $opponent, og det røg. Lang cyklus forude, masser af tid.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Pause: to mål foran mod $opponent. Slutfløjt: slet ikke noget i den retning.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'En føring på to mål mod $opponent, væk på under femogfyrre minutter.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'To foran, og vi smed det væk. Mod $opponent. Nogen skal stå til regnskab for det.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'To mål foran mod $opponent, og så gør vi det her. Hver eneste gang.';
  }

  @override
  String get cycleBackupDone =>
      'Karrieren er sikkerhedskopieret til FNM-mappen på denne telefon. Hvis du afinstallerer appen, forsvinder den: for at gemme en kopi andetsteds, brug Sikkerhedskopiér dette gemte spil på skærmen med gemte spil.';

  @override
  String get cycleBackupFailed =>
      'Karrieren kunne ikke sikkerhedskopieres denne gang.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'En aften at huske mod $opponent. Hvor stolt er du af den her gruppe?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent kunne ikke følge med. Er det her det hold, du altid har troet, at du havde?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'En stor sejr over $opponent. Hvad gjorde forskellen i aften?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent er slået, og det sikkert. Hvor vandt I den?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'En god sejr over $opponent. Det er én god aften: hvorfor skulle nogen tro, at det holder?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Et fint resultat mod $opponent. Var det din plan, eller regnede spillerne det selv ud?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'En hård aften mod $opponent. Hvad siger du til spillerne efter sådan en?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Ingen så det komme mod $opponent. Var det bare en af de aftener?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Det var en ydmygende aften mod $opponent. Hvad gik galt?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent tog jer fra hinanden. Er truppen god nok?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'I var for sene på alt mod $opponent. Hvordan lod du det gå så galt?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent scorede, som de ville. Hvor var planen i aften?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Endnu en slap af, denne gang mod $opponent. Hvordan vender du den her stime?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Resultaterne er udeblevet, og $opponent gjorde det værre. Tror du stadig på den her gruppe?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Igen ingen sejr, nu mod $opponent, og bestyrelsen holder øje. Er dit job sikkert?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Efter $opponent begynder stimen at blive lang. Er du bekymret for din fremtid?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Nu også $opponent. Din forgænger blev fyret efter en stime som den her. Hvorfor skulle du overleve den?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Efter endnu en aften som mod $opponent vil alle radioindslag have dig ud. Ville du gå af, hvis bestyrelsen bad dig om det?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Du satte dit job på spil, og efter $opponent gik det ikke din vej. Hvordan klarer du den?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'De tre kampe er spillet, den sidste mod $opponent. Du satte selv prøven. Hvad mener du om dommen?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Du sagde, vi skulle bedømme dig på de næste tre. Efter $opponent har vi gjort det. Er jobbet stadig dit?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Tre kampe, den sidste mod $opponent, og ikke det, du lovede. Har du talt med bestyrelsen om din fremtid?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Du satte selv prøven og dumpede den mod $opponent. Går du af?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Dine ord, ikke vores: bedøm mig på de næste tre. Efter $opponent, hvorfor sidder du der stadig?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Du forlanger mere af dem. Er der nogen bestemt?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Du har lagt overliggeren højt. Hvem skal træde frem først?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Du siger, at nogle af dem må se indad. Hvem mener du?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Ikke godt nok, siger du. Hvem taler du om?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Du holder det uklart. Nævner du navne, eller falder det tilbage på dig selv?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Hver uge er det en andens skyld. Hvis er den denne gang?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Modige ord. Og hvis den næste ikke går din vej?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Landet vil holde dig op på det. Hvad hvis det ikke lykkes?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'Og hvis du ikke vinder den? Hvad så?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Nu har du sagt det. Hvad sker der, hvis du tager fejl?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Vi har hørt løfter i det her lokale før. Hvad skylder du fansene, hvis også det her brister?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Og når det ikke sker, hvad bliver undskyldningen så?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Et spørgsmål mere, hvis du har overskud. Hvad skal den her gruppe stadig arbejde på?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Når støvet har lagt sig, hvad tager du med fra i aften til den næste kamp?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Lad os gå lidt dybere. Hvad skal forbedres før næste kamp?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Hvis man ser bort fra resultatet: er truppen der, hvor du vil have den?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Mange ord, ikke meget sagt. Hvad ændrer sig egentlig fra nu af?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Fansene vil have et ærligt svar. Er holdet godt nok, ja eller nej?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player var enestående i aften. Hvor langt kan han nå?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player er i alle overskrifter i aften. Så du det komme?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player stak ud. Hvad bad du ham om i aften?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Var $player forskellen i aften?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Uden $player er det en helt anden historie. Er det her et hold eller én spiller?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player var genial. Din fortjeneste eller hans?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player havde en hård aften. Går han rundt med en skade?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player havde ikke sin aften. Lægger du en arm om ham?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player havde det svært i aften. Beholder han sin plads?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player så ud til at være et skridt bagud. Hvad syntes du om hans kamp?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player var en passager igen. Hvorfor bliver du ved med at vælge ham?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Alle kunne se, at $player ikke var med. Alle undtagen bænken?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Du sagde, du ville vinde den næste, og det gjorde du. Føles det godt at få ret?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Du lovede sejr i den næste kamp og leverede. Selvtillid eller bravado?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Du sagde, du ville vinde den næste, og det gjorde du. Held, eller skal vi til at lytte?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Du fortalte os, at du ville vinde den kamp. Det skete ikke. Hvad gik galt?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Du sagde, du ville vinde den næste. Det gjorde du ikke. Hvorfor skulle vi tro på det næste løfte?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Du sagde, du ville vinde den næste. Det gjorde du ikke. Betyder dine ord overhovedet noget i det her lokale?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Du bad om at blive bedømt på tre kampe, og du bestod. Står du frikendt?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Bedøm mig på de næste tre, sagde du. Det gjorde vi, og resultaterne kom. Hvad lærte prøven dig?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Du gav dig selv tre kampe og kom igennem dem. Var prøven nogensinde så svær?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Du bad om at blive bedømt på tre kampe. De gik ikke din vej. Hvad har du lært?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Du sagde, bedøm mig på de næste tre. De tre er spillet, og tvivlen er væk med dem. Hvad nu?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Du satte selv prøven og dumpede den. Hvorfor skulle nogen tage dig på ordet nu?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Du bakkede $player op, da andre ikke ville. Han leverede. Er noget af æren din?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Du bakkede $player op. Han leverede. Tro eller viden?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Du bakkede $player op, og for en gangs skyld betalte det sig. Vil du være lige så sikker næste gang?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Du stod ved $player, og det er ikke gået godt. Tror du stadig på ham?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Du bakkede $player op. Han har ikke betalt det tilbage. Var det en fejl?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Dit skøn eller din loyalitet: hvilket af dem svigtede med $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Du var hård ved $player, og kampene siden har givet dig ret. Er der tilfredsstillelse i det?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Du pegede fingre ad $player, og han har ikke svaret. Er der vej tilbage for ham?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Du hængte $player ud, og han er ikke kommet sig. Knækkede du ham?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Du pegede fingre ad $player, og han svarede dig på banen. Var det planen hele tiden?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Du bebrejdede $player, og siden har han været en af dine bedste. Skylder du ham en undskyldning?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Du kastede $player for bussen, og han har været din bedste spiller siden. Vil du undskylde?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'De her spillere gav mig alt. Jeg ville ikke bytte en eneste af dem.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Ingen knokler hårdere end den her gruppe. Jeg forsvarer dem hele dagen.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Du hører ikke et ondt ord om mine spillere fra den her stol.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Spillerne fortjener æren, ikke mig. Skriv om dem.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Den ligger hos mig. Jeg valgte holdet, og jeg stillede det op.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Døm mig, ikke dem. Det er mit hold og mit ansvar.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Hvis I vil have nogen at give skylden, sidder jeg lige her.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Ansvaret er mit. Lad spillerne være uden for det.';

  @override
  String get pressReplyDemandMore1 =>
      'Jeg vil have mere. Nogle af dem ved præcis, hvad jeg mener.';

  @override
  String get pressReplyDemandMore2 =>
      'Indsats er ikke nok på dette niveau. Jeg vil have mere, og det har jeg sagt til dem.';

  @override
  String get pressReplyDemandMore3 =>
      'Jeg forventer mere af hver eneste af dem, fra i morgen.';

  @override
  String get pressReplyDemandMore4 =>
      'Nogle af dem må se indad. Jeg er ikke tilfreds.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Vi vinder den næste. Det kan I skrive ned.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Mærk mine ord: vi vinder den næste kamp.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Næste kamp vinder vi. Jeg siger det her, så I kan holde mig op på det.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Jeg er sikker på det her hold. Vi vinder den næste kamp.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Bedøm mig på de næste tre kampe. Det er rimeligt.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Giv mig tre kampe. Hvis det ikke er i orden inden da, så døm mig på det.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'De næste tre viser, om jeg er den rette. Hold mig op på det.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Tre kampe. Derefter kan I skrive, hvad I vil, om mig.';

  @override
  String get pressReplyDeflect1 =>
      'Vi tager én kamp ad gangen. Der er intet at tilføje.';

  @override
  String get pressReplyDeflect2 =>
      'Jeg vil ikke lave overskrifter til jer i dag.';

  @override
  String get pressReplyDeflect3 => 'Næste kamp. Det er alt, jeg tænker på.';

  @override
  String get pressReplyDeflect4 =>
      'Hvad jeg mener, bliver i omklædningsrummet.';

  @override
  String get pressReplyTakeCredit1 =>
      'Jeg sagde det, fordi jeg troede på det, og jeg havde ret.';

  @override
  String get pressReplyTakeCredit2 =>
      'Jeg læste det rigtigt. Det er det, jeg er her for.';

  @override
  String get pressReplyTakeCredit3 =>
      'Kald det dømmekraft. Jeg vidste, hvad jeg sagde.';

  @override
  String get pressReplyTakeCredit4 =>
      'Jeg tog beslutningen, og den holdt. Den tager jeg.';

  @override
  String get pressReplyStandByIt1 =>
      'Jeg sagde, hvad jeg mente. Jeg står ved det.';

  @override
  String get pressReplyStandByIt2 => 'Jeg tager ikke et ord af det tilbage.';

  @override
  String get pressReplyStandByIt3 =>
      'Samme svar som dengang. Jeg mente det, og det gør jeg stadig.';

  @override
  String get pressReplyStandByIt4 => 'Jeg ville sige det igen i morgen.';

  @override
  String get pressReplyAdmitMistake1 => 'Der tog jeg fejl. Jeg tager ansvaret.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Fair nok, jeg fejlvurderede det. Jeg lærer af det.';

  @override
  String get pressReplyAdmitMistake3 => 'Jeg tog fejl, og det kan jeg sige.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Den beslutning virkede ikke, og den var min.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player har min fulde opbakning. Han skal nok finde formen igen.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Jeg tror på $player, og han vil vise jer, hvorfor.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Du hører ikke et ondt ord om $player fra mig. Han leverer.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player bliver i mine planer. Se, hvad han gør næste gang.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player svigtede os i aften, og det ved han godt.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Jeg forventede langt mere af $player. Det må han svare på.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player var ikke på niveau. Det siger jeg offentligt.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Det var ikke godt nok af $player, og det får han at høre af mig.';
  }

  @override
  String get pressOnRecordWinNext => 'Til referat: du vinder den næste kamp.';

  @override
  String get pressOnRecordJob => 'Til referat: du bedømmes på de næste tre.';

  @override
  String pressOnRecordBack(String player) {
    return 'Til referat: du bakker $player op.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Til referat: $player svigtede dig.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Han sagde det, og det skete. $nation har en landstræner, der mener, hvad han siger.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Sagde det højt og gik så hen og gjorde det. Det er den mand, $nation havde brug for.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: han forudsagde det, og det skete. Fair nok.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Han sagde det til referat, og det holdt. Et point til ham. $nation går videre.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Han ramte rigtigt én gang. $nation, væn jer ikke til det.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Selv et stoppet ur har ret to gange i døgnet. $nation var heldige denne gang.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Han sagde det, og det lykkedes ikke. Jeg er stadig med ham. $nation går igen.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: han lovede mere, end vi fik, men jeg vil hellere have en landstræner, der tror på sig selv.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: han sagde det til referat, og det skete ikke. Folk husker det.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Store ord, intet bag dem. $nation: næste gang, sig mindre.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Han stod der og fortalte os det. Så det her. $nation fortjener bedre end snak.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Hans ord er intet værd nu. Skriv det ned, $nation.';
  }

  @override
  String get ncZoneNorth => 'Nordzonen';

  @override
  String get ncZoneWest => 'Vestzonen';

  @override
  String get ncZoneEast => 'Østzonen';

  @override
  String get ncZoneCentralSouthern => 'Central- og Sydzonen';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Mestre';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Toer';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Semifinalist';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Ottendedelsfinale';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Kvartfinalist';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Nå kvartfinalen';

  @override
  String get objectiveNcZoneWinGroup => 'Vind din gruppe';

  @override
  String get finishNcFinalsEight => 'Kvartfinale';

  @override
  String get finishNcBottomHalf => 'Nederste halvdel af gruppen';

  @override
  String get tourContTabZones => 'ZONER';

  @override
  String get tourContTabFinalsEight => 'KNOCKOUT';

  @override
  String get tourContFinalsEightSoon =>
      'Knockout-runderne starter i november med en ottendedelsfinale: alle 14 gruppevindere og de 2 bedste toere.';

  @override
  String get tourContQuarterFinals => 'KVARTFINALER';

  @override
  String get tourContZoneAdvancement =>
      'Hver gruppevinder går videre til ottendedelsfinalen sammen med de 2 bedste toere. Ingen rykker ned.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Nordamerika Nations Cup';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica => 'Vind Nordamerika Nations Cup';

  @override
  String get objectiveNcWinItAfrica => 'Vind Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Nå finalen i Nordamerika Nations Cup';

  @override
  String get objectiveNcReachFinalAfrica => 'Nå finalen i Nations Cup';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Vindere af Nordamerika Nations Cup';

  @override
  String get finishNcChampionsAfrica => 'Vindere af Nations Cup';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Kvalifikationen til $competition starter nu, og landet tror på det her hold. Hvad sigter du efter?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'En ny kvalifikationskampagne til $competition, og humøret er højt. Hvor langt kan holdet nå?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Kvalifikationen til $competition begynder. Hvad er målet for kampagnen?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Kvalifikationskampene til $competition er her. Hvor ser du holdet ende?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Kvalifikationen til $competition starter, og mange tvivler på, at du når frem. Hvad siger du til dem?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Endnu en kvalifikationskampagne til $competition. Hvorfor skulle nogen tro, at den her bliver anderledes?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition er her, og hele landet står bag dig. Hvor langt kan I nå?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'I er med til $competition, og fansene drømmer. Hvad er målet?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition starter i denne uge. Hvad ville tælle som en succes?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Jeres første kamp ved $competition nærmer sig. Sæt os et mål.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition er her, og ingen forventer meget. Hvad håber du egentlig på?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'I er med til $competition, men tvivlen er ikke forsvundet. Hvad er dit mål?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival er i din gruppe. Bekymrer de dig?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Lodtrækningen satte $rival i vejen for jer. Hvordan ser du den kamp?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival ser ud til at være det stærkeste hold i din gruppe. Er de favoritter?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Hvad mener du om $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival er i din gruppe. Vær ærlig, kan I klare dem?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'De fleste forventer, at $rival slår jer. Tager de fejl?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player er i fin form. Er det her hans øjeblik?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player er i alle overskrifter. Kan han bære holdet?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Hvor meget afhænger kampagnen af $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Er $player klar til at føre holdet an?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Hvis $player ikke er på sit bedste, har holdet så noget?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player har meget på sine skuldre. For meget?';
  }

  @override
  String get pressReplyAimHigher1 => 'Vi går længere, end nogen forventer.';

  @override
  String get pressReplyAimHigher2 =>
      'Jeg vil have mere, end forbundet har bedt om, og det siger jeg højt.';

  @override
  String get pressReplyMatchBrief1 => 'Vi kender målet, og vi når det.';

  @override
  String get pressReplyMatchBrief2 =>
      'Forbundet har sat et mål. Vi leverer det.';

  @override
  String get pressReplyPlayDown1 => 'Lad os tage én kamp ad gangen.';

  @override
  String get pressReplyPlayDown2 =>
      'Ingen store løfter. Vi må se, hvor vi står.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Vi kvalificerer os. Det kan I skrive ned.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Det her hold kommer med til slutrunden.';

  @override
  String get pressReplyFearNobody1 => 'Vi frygter ingen.';

  @override
  String get pressReplyFearNobody2 => 'De skal også spille mod os.';

  @override
  String get pressReplyRespectRival1 =>
      'De er favoritterne, og vi respekterer dem.';

  @override
  String get pressReplyRespectRival2 =>
      'Et rigtig godt hold. Vi får brug for vores bedste.';

  @override
  String get pressReplyTeamFirst1 =>
      'Det handler om hele holdet, ikke én spiller.';

  @override
  String get pressReplyTeamFirst2 => 'Ingen vinder det her alene.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Til referat: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Til referat: ingen løfter.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Du satte et mål før kampagnen, og du nåede det. Er det dit stolteste øjeblik hidtil?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Du sagde, hvad du ville opnå, og det gjorde du. Var det nogensinde i tvivl?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Du nåede det mål, du satte. Held, eller var det virkelig planen?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Du satte et mål og nåede det ikke. Hvad gik galt?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Du lovede mere, end holdet leverede. Fortryder du, at du sagde det?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Du talte stort før kampagnen og kom til kort. Hvorfor skulle vi tro på dig nu?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Pressen vil høre dine mål for $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Niveau $level · $amount';
  }

  @override
  String get formOnFire => 'Brandvarm';

  @override
  String get formGood => 'I form';

  @override
  String get formSteady => 'Stabil';

  @override
  String get formPoor => 'Ude af form';

  @override
  String get formCold => 'Iskold';

  @override
  String get playerFormTitle => 'FORM OG KONDITION';

  @override
  String playerFormAverage(String rating) {
    return 'Gennemsnit på $rating i hans seneste kampe';
  }

  @override
  String get playerFormNoGames => 'For få seneste kampe til at vurdere';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta på hans styrke i næste kamp';
  }

  @override
  String get playerFormNoEffect => 'Ingen ændring i hans styrke i næste kamp';

  @override
  String get sideGroupHome => 'Forside';

  @override
  String get sideGroupTeam => 'Hold';

  @override
  String get sideGroupCompetitions => 'Turneringer';

  @override
  String get sideGroupFederation => 'Forbund';

  @override
  String get sideGroupHistory => 'Historie';

  @override
  String get sideInbox => 'Indbakke';

  @override
  String get sideSquad => 'Trup';

  @override
  String get sideTactics => 'Taktik';

  @override
  String get sideMainMenu => 'Hovedmenu';

  @override
  String get sideCallUps => 'Udtagelser';

  @override
  String get sideTournaments => 'Turneringer';

  @override
  String get sideRanking => 'Rangliste';

  @override
  String get sideResults => 'Resultater';

  @override
  String get sideFinances => 'Økonomi';

  @override
  String get sideBoard => 'Bestyrelse';

  @override
  String get sideManager => 'Landstræner og stab';

  @override
  String get sideRecords => 'Rekorder';

  @override
  String get sideLegends => 'Legender';

  @override
  String get sideHeadToHead => 'Indbyrdes';

  @override
  String get sideAchievements => 'Præstationer';

  @override
  String get sideCareer => 'Karriere';

  @override
  String get topBarNext => 'Næste';

  @override
  String get topBarDrawPending => 'Lodtrækning følger';

  @override
  String get paneFullProfile => 'Fuld profil';

  @override
  String get panePickPlayer => 'Vælg en spiller for at se hans kort her';

  @override
  String get inboxPickMessage => 'Vælg en besked for at læse den her';

  @override
  String get inboxFilterAll => 'Alle';

  @override
  String get panelViewAll => 'Se alle';

  @override
  String get gridViewOverview => 'Overblik';

  @override
  String get gridColCondition => 'Kondition';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Plads';

  @override
  String get gridColMove => 'Ændring';

  @override
  String get gridColNation => 'Land';

  @override
  String get gridColRegion => 'Region';

  @override
  String get gridColPoints => 'Point';

  @override
  String get panePickNation => 'Vælg et land for at se dets rekord her';

  @override
  String get resultsCyclesTitle => 'Cyklusser';

  @override
  String get tourDrawStart => 'Start lodtrækningen';

  @override
  String get tourDrawViewGroups => 'Se grupper';

  @override
  String get gridColCeiling => 'Loft';

  @override
  String get gridColYearGain => 'Fremgang';

  @override
  String get gridColMarkedAt => 'Ved markering';

  @override
  String get budgetSetupTitle => 'Sæt dit budget';

  @override
  String get budgetEffectsTitle => 'Hvad budgettet giver';

  @override
  String get naturalisationTitle => 'Naturalisation';

  @override
  String get yTrending => 'Trender';

  @override
  String get yVoices => 'Stemmer';

  @override
  String get yConversation => 'Samtale';

  @override
  String get allTimeRecordsTitle => 'Verdensrekorder gennem tiden';

  @override
  String get h2hMeetingsTitle => 'Alle opgør';

  @override
  String get h2hPickOpponent => 'Vælg en modstander for at se alle opgør her';

  @override
  String get savesTitle => 'Gemte spil';

  @override
  String get gridColPlayer => 'Spiller';

  @override
  String get gridColPos => 'Pos';

  @override
  String get gridColActive => 'Aktiv';

  @override
  String get gridColMotm => 'KS';

  @override
  String get gridColAvg => 'Gns';

  @override
  String get gridColOpponent => 'Modstander';

  @override
  String get gridColStarts => 'Starter';

  @override
  String get gridColTournaments => 'Turneringer';

  @override
  String get gridColDate => 'Dato';

  @override
  String get gridColLastPlayed => 'Sidst spillet';

  @override
  String get gridColManager => 'Landstræner';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lande',
      one: '1 land',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Sorteret efter verdensrangliste';

  @override
  String get nationsStrength => 'Styrke';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier af 5';
  }

  @override
  String get nationsSquadOverall => 'Truppens styrke';

  @override
  String get nationsOpeningBudget => 'Startbudget';

  @override
  String get nationsStarPlayer => 'Stjernespiller';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Stjerne $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Alder $age';
  }

  @override
  String get nationsBoardExpects => 'Bestyrelsen forventer';

  @override
  String nationsManage(String nation) {
    return 'Led $nation';
  }

  @override
  String get nationsManagerNext => 'Du navngiver din landstræner næste gang';

  @override
  String get playerPageTitle => 'Spiller';

  @override
  String get nationPageTitle => 'Land';

  @override
  String get friendliesYourGames => 'Dine venskabskampe';

  @override
  String hubEventInjuryCover(String player) {
    return 'Erstat den skadede $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Ude i $matches kampe',
      one: 'Ude i næste kamp',
    );
    return '$_temp0. Udtag en anden, eller spil videre uden en erstatning.';
  }

  @override
  String get injuryCoverTitle => 'ERSTATNING';

  @override
  String injuryCoverBanner(String player) {
    return '$player er skadet. Udtag en vilkårlig spiller uden for truppen, på en hvilken som helst position, eller behold ham og spil videre.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Udtag $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Behold $player og spil videre';
  }

  @override
  String get injuryCoverPick => 'Vælg en erstatning';

  @override
  String get injuryCoverNone =>
      'Ingen uden for truppen er klar til at komme med.';

  @override
  String get nationNowRanking => 'Verdensrangliste';

  @override
  String get nationNowForm => 'Form';

  @override
  String get nationNowNoForm => 'Ingen kampe spillet endnu';

  @override
  String get nationNowNext => 'Næste kamp';

  @override
  String get nationNowNoNext => 'Intet planlagt';

  @override
  String get nationNowSquad => 'Trup';

  @override
  String get nationNowAgainstYou => 'Mod dig';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}V ${d}U ${l}T';
  }

  @override
  String get nationNowLastMeeting => 'Sidste opgør';

  @override
  String nationNowOverall(int value) {
    return 'Styrke $value';
  }

  @override
  String get hubUpcoming => 'KOMMENDE';

  @override
  String get hubFullSchedule => 'Hele programmet';

  @override
  String get scheduleTitle => 'Program';

  @override
  String get scheduleToday => 'I dag';

  @override
  String get scheduleKnockoutPending =>
      'Knockout-runder, hvis du kommer videre';

  @override
  String get scheduleNextRoundPending => 'Næste runde';

  @override
  String scheduleFromDate(String date) {
    return 'Fra $date';
  }

  @override
  String get scheduleHomeShort => 'H';

  @override
  String get scheduleAwayShort => 'U';

  @override
  String get tacticsNoPresetsInMatch =>
      'Ingen gemte taktikker endnu. Gem en fra taktikskærmen før kampen.';

  @override
  String get homeCampaigns => 'Kampagner';

  @override
  String get homeContinueCampaign => 'FORTSÆT KAMPAGNEN';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Cyklus $cycle af $total';
  }

  @override
  String get campaignsTitle => 'Kampagner';

  @override
  String get campaignTransplantTitle => 'Transplantatet';

  @override
  String get campaignTransplantTwist =>
      'Otte af Italiens bedste skifter til San Marino';

  @override
  String get campaignTransplantGoal => 'Kvalificér dig til Europamesterskabet';

  @override
  String get campaignGrudgeTitle => 'Nag';

  @override
  String get campaignGrudgeTwist => 'Georgien og Albanien, trukket sammen';

  @override
  String get campaignGrudgeGoal => 'Slut over Albanien i kvalifikationen';

  @override
  String get campaignTransplantIntro =>
      'San Marino har aldrig haft en kvalifikationskampagne, der fortjente navnet. Så tager otte af Italiens bedste passet og går ind ad døren. Du har én cyklus til at gøre en kuriositet til et hold.';

  @override
  String get campaignGrudgeIntro =>
      'Georgien og Albanien er trukket i samme kvalifikationsgruppe, og ingen af dem tilgiver et nederlag. Slut over Albanien, og se så, hvor langt du kan bære det.';

  @override
  String get campaignStars1Transplant => 'Kvalificér dig';

  @override
  String get campaignStars2Transplant => 'Nå knockout-runderne';

  @override
  String get campaignStars3Transplant => 'Vind Europamesterskabet';

  @override
  String get campaignStars1Grudge => 'Over Albanien';

  @override
  String get campaignStars2Grudge => 'Og kvalificér dig';

  @override
  String get campaignStars3Grudge => 'Og slå dem to gange';

  @override
  String get campaignFree => 'Gratis';

  @override
  String get campaignStart => 'Start';

  @override
  String get campaignPartOfUnlimited => 'En del af Unlimited';

  @override
  String get campaignResume => 'Fortsæt';

  @override
  String get campaignAbandon => 'Opgiv';

  @override
  String get campaignAbandonConfirm =>
      'Opgiv dette forsøg? Fremgangen går tabt, men dit stempel bevares.';

  @override
  String get campaignMoveToSaves => 'Flyt til gemte spil';

  @override
  String get campaignCannotContinue =>
      'Dette kampagne-univers ligger for langt fra det virkelige til, at det kan fortsætte som en karriere.';

  @override
  String get campaignMoveSlotsFull =>
      'Dine gemmepladser er fyldt. Frigør én først.';

  @override
  String get campaignStampConquered => 'Erobret';

  @override
  String get campaignStampFailed => 'Mislykket';

  @override
  String get campaignDifficultyHard => 'Svær';

  @override
  String get campaignDifficultyMedium => 'Middel';

  @override
  String get campaignGoalLabel => 'Mål';

  @override
  String get campaignStarsLabel => 'Stjerner';

  @override
  String get campaignRunInProgress =>
      'Denne kampagne har allerede et forsøg i gang.';

  @override
  String get campaignVerdictWon => 'Erobret';

  @override
  String get campaignVerdictLost => 'Ikke denne gang';

  @override
  String get campaignVerdictContinue => 'Fortsæt';

  @override
  String campaignProgressQualifying(String position) {
    return 'Kvalifikation: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Slutrunde: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Forsøget i tal';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Opgør vundet: $won af $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1.',
        'second': '2.',
        'third': '3.',
        'other': '$n.',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Bedst af Guineaerne';

  @override
  String get campaignGuineasTwist =>
      'Ækvatorialguinea, den lavest rangerede af Afrikas Guineaer, i to cyklusser';

  @override
  String get campaignGuineasGoal => 'Slå Guinea og Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Tre afrikanske lande bærer navnet Guinea, og Ækvatorialguinea er rangeret lavest af dem. Du har to cyklusser til at slå Guinea og Guinea-Bissau mindst én gang hver, og så se, hvor langt du kan nå i Afrikamesterskabet. Papua Ny Guinea, den fjerde Guinea, er allerede booket til en venskabskamp.';

  @override
  String get campaignStars1Guineas => 'Slå Guinea og Guinea-Bissau';

  @override
  String get campaignStars2Guineas =>
      'Og kvalificér dig til et Afrikamesterskab';

  @override
  String get campaignStars3Guineas =>
      'Og nå en kvartfinale i Afrikamesterskabet';

  @override
  String get campaignYoungFinnsTitle => 'De unge finner';

  @override
  String get campaignYoungFinnsTwist =>
      'Finlands gyldne generation af teenagere, i tre cyklusser';

  @override
  String get campaignYoungFinnsGoal => 'Kvalificér dig til et VM';

  @override
  String get campaignYoungFinnsIntro =>
      'Finlands seniorspillere har trådt til side, og en gylden generation har overtaget deres plads: alle de spillere, du kan vælge, er 18 år eller yngre. I dag er de rå, men de har talentet til at blive et af verdens bedste hold, ligesom Norges unge generation gjorde. Du har tre cyklusser til at føre dem til et VM og derefter vinde Europamesterskabet og Verdensmesterskabet.';

  @override
  String get campaignStars1YoungFinns => 'Kvalificér dig til et VM';

  @override
  String get campaignStars2YoungFinns => 'Vind Europamesterskabet';

  @override
  String get campaignStars3YoungFinns => 'Vind Verdensmesterskabet';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Ikke kvalificeret';

  @override
  String get campaignCupOpen => 'Afgøres senere';
}
