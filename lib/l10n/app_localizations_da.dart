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
  String get matchDossierHowTheyPlay => 'SÅDAN SPILLER DE';

  @override
  String matchScoutFormation1(String formation) {
    return 'De stiller som regel op i en $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Deres sædvanlige formation er en $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'De plejer at stille op i en $formation.';
  }

  @override
  String get matchScoutStrengthPressing => 'De presser højt og jagter bolden.';

  @override
  String get matchScoutStrengthDirect =>
      'De spiller direkte og får hurtigt bolden frem.';

  @override
  String get matchScoutStrengthPossession =>
      'De holder godt på bolden og bygger tålmodigt op.';

  @override
  String get matchScoutStrengthCounter => 'De ligger dybt og kontrer hurtigt.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'De forsvarer dybt og er svære at bryde ned.';

  @override
  String get matchScoutStrengthWide =>
      'De gør banen bred og angriber ude på kanterne.';

  @override
  String get matchScoutStrengthAttacking =>
      'De tager gerne initiativet og går på modstanderen.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Deres angribere er hurtige og elsker at løbe i dybden.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Deres midtbane spiller bolden godt rundt.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Deres midtbane kan løbe hele kampen.';

  @override
  String get matchScoutStrengthSetPieces => 'De er farlige på dødbolde.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Deres forsvarskæde er hurtig og svær at komme bag om.';

  @override
  String get matchScoutStrengthNone =>
      'Intet i deres spil skiller sig rigtig ud.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Deres høje forsvarslinje efterlader plads i ryggen til en lang bold.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Et højt pres kan forstyrre deres langsomme opspil.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Vær tålmodig: en lav blok som deres kan spilles i stykker.';

  @override
  String get matchScoutWeakLongBall =>
      'Træk din forsvarslinje længere tilbage, så har deres lange bolde ingen steder at gå hen.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Deres forsvarere mangler fart, så send løbere bag om dem.';

  @override
  String get matchScoutWeakAerial =>
      'De virker usikre, når de forsvarer dødbolde.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Deres midtbane har svært ved at spille sig ud af pres.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Deres midtbane mangler benene til at holde et pres.';

  @override
  String get matchScoutWeakBluntAttack => 'Deres angribere mangler fart.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Mod dig kan du forvente, at de tager initiativet.';

  @override
  String get matchScoutApproachEven =>
      'Mod dig kan du forvente en tæt og lige kamp.';

  @override
  String get matchScoutApproachSitDeep =>
      'Mod dig kan du forvente, at de er forsigtige og venter på kontraen.';

  @override
  String get matchScoutLeaningAttacking =>
      'På afstand ligner de et offensivt hold.';

  @override
  String get matchScoutLeaningCautious =>
      'På afstand ligner de et forsigtigt hold.';

  @override
  String get matchScoutLeaningUnclear =>
      'På afstand er det svært at sige, hvordan de helst vil spille.';

  @override
  String get matchScoutHireHint =>
      'Ansæt en chefscout for at finde ud af, hvordan de spiller.';

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
  String matchHalfTimeScore(int home, int away) {
    return 'Halvleg $home : $away';
  }

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
  String get settingsTextSizeTitle => 'Tekststørrelse';

  @override
  String get settingsTextSizeBlurb =>
      'Gør teksten større, hvis den er svær at læse.';

  @override
  String get settingsTextSizeNormal => 'Normal';

  @override
  String get settingsTextSizeLarge => 'Stor';

  @override
  String get settingsTextSizeLarger => 'Større';

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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count landskampe',
      one: '1 landskamp',
    );
    return '$_temp0';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count mål';
  }

  @override
  String recordsAssistsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assists',
      one: '1 assist',
    );
    return '$_temp0';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count KS';
  }

  @override
  String recordsMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kampe',
      one: '1 kamp',
    );
    return '$_temp0';
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
  String get tacticsFullBackLeft => 'Venstre back';

  @override
  String get tacticsFullBackRight => 'Højre back';

  @override
  String get tacticsFullBackUp => 'Gå med frem';

  @override
  String get tacticsFullBackDown => 'Bliv hjemme';

  @override
  String get tacticsFullBackOff => 'Ingen instruks';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: gå med frem. Lidt mere angreb, lidt mere risiko.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: bliv hjemme. Lidt sikrere, lidt mindre angreb.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: ingen instruks, spiller efter holdets plan.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, pil: $state';
  }

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
  String get tacticsThrowIns => 'Indkast';

  @override
  String get tacticsThrowInStyle => 'Indkaststil';

  @override
  String get tacticsThrowInLong => 'Lange indkast';

  @override
  String get tacticsThrowInNeutral => 'Neutral';

  @override
  String get tacticsThrowInDefensive => 'Sikre indkast';

  @override
  String get tacticsThrowInLongBlurb =>
      'Indkast nær feltet går ind i feltet. Lidt mere fare, især med en stærk kaster og høje angribere, men bolden tabes lidt oftere.';

  @override
  String get tacticsThrowInNeutralBlurb =>
      'Indkast som spillet tillader. Intet ændres.';

  @override
  String get tacticsThrowInDefensiveBlurb =>
      'Hvert indkast kort og sikkert. Færre boldtab at blive kontret på, og lidt færre chancer.';

  @override
  String get matchGoalLongThrow => 'LANGT INDKAST';

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
  String homeNextFixture(String match, String when) {
    return 'Næste: $match, $when';
  }

  @override
  String homeCycleComplete(int year) {
    return 'VM $year er slut. Nu venter bestyrelsens dom.';
  }

  @override
  String homeFollowingFinals(int year) {
    return 'VM $year fra tribunen';
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
    String _temp0 = intl.Intl.pluralLogic(
      apps,
      locale: localeName,
      other: '$apps kampe',
      one: '1 kamp',
    );
    return '$_temp0';
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
  String get viceCaptainFirst => '1. viceanfører';

  @override
  String get viceCaptainSecond => '2. viceanfører';

  @override
  String get viceCaptainNone => 'Ingen viceanfører udpeget';

  @override
  String get viceCaptainHint =>
      'Bærer anførerbindet, når anføreren ikke kan spille.';

  @override
  String captainStandIn(String vice, String captain) {
    return 'Viceanfører $vice fører holdet ud; anfører $captain kan ikke spille';
  }

  @override
  String captainStandInUnnamed(String vice) {
    return 'Viceanfører $vice fører holdet ud';
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
    return 'Vind $count store titler (VM, kontinentalt mesterskab, Nations Cup eller Continental Clash).';
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
  String get gateSaveTitle => 'DETTE SPIL KRÆVER PRO';

  @override
  String get gateSaveLead =>
      'Spil efter den gratis cyklus og Pro-kampagner fortsætter med Pro. Intet går tabt: spillet venter præcis, som du forlod det.';

  @override
  String get careerSaveLockedNote => 'Pro kræves for at fortsætte dette spil';

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
  String get statsMostGamesShort => 'Kampe';

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
  String yWinUpset12(String opponent, String score) {
    return '$opponent slået med $score. Skriv datoen ned, folk vil spørge, hvor I var.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Uden for omklædningsrummet troede ingen på det. $score mod $opponent. Stolt dækker det ikke.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score mod $opponent! Alle løb, til der ikke var mere tilbage.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Kæmpedræbere. $opponent, $score. Det er derfor, vi altid kommer igen.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score mod $opponent. Forhåndstipsene fløj lige ud ad vinduet.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Storfavorit: $opponent. Slutresultat: $score til os.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'En af årets overraskelser: $score mod $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Ingen forudså det, og ingen kan rigtig forklare det.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score mod $opponent. Dejligt. Nu glemmer alle, hvor dårlig resten af året var.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score mod $opponent, og vognen er allerede fuld. Jeg sad i den, da den var tom.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Fremragende, og de finder alligevel en måde at smide det væk på.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Stor aften mod $opponent, $score. Én svale gør ingen sommer.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score mod $opponent. Det gør ondt, fordi vi bryder os om det. Bak dem op alligevel.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'En aften at glemme mod $opponent, $score. Spillerne har det værst af alle.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Hovedet højt. Et hold bedømmes på, hvordan det svarer på det her.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score mod $opponent. Dårligt, ja. Verdens undergang, nej.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score mod $opponent. Et resultat, der vil blive talt om i årevis, af de forkerte grunde.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Sejr til $opponent, $score. Efter det her bør ingen blive overrasket næste gang.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'En af de værste aftener i lang tid: $score mod $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Der vil blive stillet spørgsmål, og med rette.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score mod $opponent. Pinligt er en underdrivelse.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Nederlag på $score mod $opponent. Den sidste slukker lyset.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Jeg bliver ikke overrasket længere, og det skræmmer mig.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Nogen deroppe bør opdatere sit CV i aften.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score mod $opponent! Sådan fodbold får hele landet til at smile.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponent kørt over, $score. Sikken en præstation.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Mod $opponent. Alt lykkedes i aften.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'En $score-nedsabling af $opponent. Gem højdepunkterne, I vil have dem senere.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Det er et hold, der nyder sin fodbold.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score mod $opponent, og det kunne være blevet flere. Pragtfuldt.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score mod $opponent. Et resultat, man kigger på to gange.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponent slået med $score. Ingen kamp efter den første halve time.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Slutresultat: $score mod $opponent. Klart den største sejr i lang tid.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Det ene hold kom for at spille, det andet steg aldrig ud af bussen.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. $opponent havde ikke svar på noget.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Store bank: $score mod $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score mod $opponent. Hyggeligt, men de er næppe målestokken.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score mod $opponent. Væk mig, når vi gør det mod nogen gode.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Sjovt, men jeg har set hold skinne sådan og ikke vinde noget.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, og alle er genier igen. Det var $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score mod $opponent. Slap af, det beviser meget lidt.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Nyd det, og husk så, hvordan det gik sidst, vi blev begejstrede.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Videre efter straffespark mod $opponent! Nerver af stål, hver og en.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Straffespark mod $opponent, og vi holdt hovedet koldt. Kram en fremmed.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Straffesparkskonkurrencen vundet mod $opponent. Mit hjerte kan ikke klare det her.';
  }

  @override
  String yWinShootout3(String opponent) {
    return '$opponent slået efter straffespark. Videre til næste runde.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Mod $opponent blev det afgjort fra pletten, og vi scorede flest.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Straffespark vundet mod $opponent. Den sværeste vej, men videre.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Videre efter straffespark mod $opponent. Lotteriet vundet, præstationen glemt.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Slå $opponent på straffespark efter det der? Held, og det ved alle.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Videre mod $opponent efter straffespark. Det burde aldrig have været nødvendigt.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'VIDERE. $score mod $opponent, og drømmen lever.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'KNOCKOUTSEJR: $opponent slået med $score. Landet kan begynde at tro.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score mod $opponent og videre til næste runde. Sikken en aften.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent sendt hjem, $score. Fremad.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'KNOCKOUT: $score mod $opponent. Næste runde sikret.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Videre: $score mod $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent slået ud, $score. Næste runde venter.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Vandt $score mod $opponent. I knockoutrunderne spørger ingen hvordan.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Videre mod $opponent, $score. Næste modstander bliver ikke lige så venlig.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score mod $opponent er nok til at gå videre. Næste gang kræver det meget mere.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent ude, $score. Mere overlevet end vundet.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Videre til næste runde efter $score mod $opponent. Spørg ikke hvordan.';
  }

  @override
  String yUpsetGap0(String opponent, int gap) {
    return '$gap pladser skilte os på ranglisten, og alligevel slog vi $opponent. Storslået.';
  }

  @override
  String yUpsetGap1(String opponent, int gap) {
    return '$opponent: $gap pladser foran os. Slået. Fodbold er vidunderligt.';
  }

  @override
  String yUpsetGap2(String opponent, int gap) {
    return 'Ranglisteforskel: $gap pladser. Resultat: sejr mod $opponent. Hold aldrig op med at tro.';
  }

  @override
  String yUpsetGap3(String opponent, int gap) {
    return 'Ranglisteforskel før kampstart: $gap pladser. $opponent slået alligevel.';
  }

  @override
  String yUpsetGap4(String opponent, int gap) {
    return 'På verdensranglisten lå $opponent $gap pladser foran os. Ikke i aften.';
  }

  @override
  String yUpsetGap5(String opponent, int gap) {
    return 'Overraskelsesindeks: $gap ranglistepladser mellem holdene. Sejr til os mod $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, int gap) {
    return '$gap ranglistepladser skilte os fra $opponent. Én aften lukker ikke det hul.';
  }

  @override
  String yUpsetGap7(String opponent, int gap) {
    return '$opponent: $gap pladser foran, og slået. Ranglisten opdager det knap.';
  }

  @override
  String yUpsetGap8(int gap) {
    return 'Ranglisteforskel: $gap pladser. Husk det tal, næste gang vi taber til en lille nation.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Jeg havde afskrevet det her hold. Jeg tog fejl, og jeg har aldrig været gladere for at tage fejl. $opponent slået.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'En portion ydmyghed, tak. En stor. Sejren mod $opponent var storslået.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Jeg sagde, de ikke havde mere at give. De havde masser. Godt spillet mod $opponent, alle sammen.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'For en ordens skyld: den sejr mod $opponent så jeg ikke komme. Ære være dem.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Fint. Jeg sagde, de ville blive afsløret. $opponent afslørede dem ikke.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'I aften æder jeg mine ord om det her hold. Sejren mod $opponent fortjener det.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Ja, jeg sagde, de var færdige. Én sejr mod $opponent beviser ikke, at jeg tog fejl endnu.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Jeg skal åbenbart æde mine ord efter $opponent. Det gør jeg, langsomt, og kvitteringen gemmer jeg.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Sejren mod $opponent var imponerende. Min tvivl om det her hold er der stadig.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Respekt til $nation. $score, og fortjent fra start til slut.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Det gør ondt at sige det, men bedst i aften var $nation. $score. Tillykke.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Hatten af for $nation, de ville det mere.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Nederlag på $score mod $nation. Jeg ved ikke engang, hvad jeg skal sige.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Vores burde skamme sig.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score mod $nation. Kan nogen forklare mig, hvordan det skete?';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'At tabe $score til $nation. Det kommer jeg aldrig over.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score mod $nation. Held. Rent held.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Efter den $score bliver de i $nation ulidelige i årevis. Tak for ingenting.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Skønt for fodbolden. Det er derfor, vi elsker den.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Sikket et resultat for $nation: $score mod $opponent. Fodbold, når det er bedst.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Alle neutrale holder med $nation i aften. $score mod $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Rundens resultat: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Det havde ingen på kuponen.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Stort resultat: $nation $score $opponent. Ranglisten kommer til at rykke sig.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Sjovt, lad os se, om de kan gøre det igen.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Vandt $nation, eller tabte $opponent?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Bombe: $nation $score $opponent. Forvent masser af overreaktioner.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name mod $opponent. De kommer til at opkalde børn efter ham.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'En statue til $name. I aften mod $opponent var han alt.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, sikken en spiller. Husk denne aften mod $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name afgjorde det mod $opponent. Kampens spiller, ingen diskussion.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Mod $opponent tilhørte aftenen $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name trådte frem, da det gjaldt mod $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name var fremragende mod $opponent. Nu hver uge, tak.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name reddede holdet mod $opponent. De andre hjalp ikke meget.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Uden $name var det blevet en helt anden aften mod $opponent.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score mod $opponent. Et uheld. Det sker for alle én gang.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Nederlag på $score mod $opponent. Ryst det af jer, kampagnen er ikke slut.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Smertefuldt, men ét resultat definerer ikke det her hold.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score mod $opponent. En dårlig dag på kontoret. Videre.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Nederlag mod $opponent, $score. Ingen så det komme.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. En af de aftener, der ikke giver mening.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score mod $opponent. Et nederlag, der vil blive husket.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Slået af $opponent, $score. En sensation, uanset hvordan man ser på det.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score mod $opponent. Mod $opponent! Uacceptabelt.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Nederlag på $score mod $opponent. Jeg vil have forklaringer, ikke undskyldninger.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. En national skandale, og det er ikke en talemåde.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score mod $opponent. Hvordan sidder nogen deroppe stadig i jobbet?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score mod $opponent. Det er et tophold. Lær af det.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Udspillet af $opponent, $score. Ingen skam at tabe til de bedste.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. En lektie, og af lektier vokser man.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score mod $opponent. Smertefuldt, men de er et niveau højere.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Sejr til $opponent, $score. Forskellen er ægte, og nu har alle set den.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score mod $opponent. Klø, hverken mere eller mindre.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. Det bedste hold, og resultatet siger det.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Nederlag på $score mod $opponent. Ingen skam, men heller ingen kamp.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score mod $opponent. Bedre modstander eller ej, sådan må man ikke tabe.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Prøvede vi overhovedet at konkurrere?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Mod $opponent. Lam til slagtebænken.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Nederlag på $score mod $opponent, og ingen så ud til at tage sig af det.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Ude efter straffespark mod $opponent. De gav alt. Stolt af dem.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Straffespark mod $opponent. Den grusomste måde at ryge ud på. Hovedet højt.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Straffesparkskonkurrencen tabt mod $opponent. Ingen fortjente det.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Ude efter straffespark mod $opponent. Pletten afgjorde det.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent videre efter straffespark. Vores turnering slutter der.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Straffespark tabt mod $opponent. Straffespark igen.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Ude efter straffespark mod $opponent. Træner vi dem overhovedet?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Nederlag mod $opponent efter straffespark. Vi burde have afgjort det længe før.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Straffespark mod $opponent, og vi tabte. Selvfølgelig.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'UDE. $score mod $opponent. En rejse at være stolt af slutter her.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Slået ud af $opponent, $score. Tak for minderne.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score mod $opponent. Rejsen er slut, men sikken en rejse.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'SLÅET UD: $score mod $opponent. Hovedet højt.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'SLUT: $score mod $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Ude: $score mod $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent går videre, $score. Vores turnering er slut.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Slået ud af $opponent, $score. Obduktionen begynder nu.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'UDE. $score mod $opponent. En anden turnering, samme slutning.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score mod $opponent, og hjem igen. Ingen er overraskede.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Slået ud af $opponent, $score. Forvent undskyldninger inden i morgen tidlig.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Ude, og det så aldrig ud til at ende anderledes.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score mod $nation. Respekt, de kommer stærkere tilbage.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'God sejr til os, $score. Dårlig dag for $nation, jeg har ondt af deres fans.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Dårlig aften for $nation, og vi greb chancen. Sådan er det.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score mod $nation! Hvem så det komme? Ikke dem.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Vandt $score mod $nation. Kan nogen tjekke, hvordan deres fans har det?';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Den ryger direkte i fotoalbummet.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score mod $nation. Og de tror, de er et stort hold.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Tænk at tabe $score til os. Spørg $nation, de ved det nu.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. God tur hjem.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. En stor aften for $opponent, en tung en for $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Tanker til fansene i $nation efter $score mod $opponent. De kommer igen.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Alle store hold har sådan en aften.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Rundens chok: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ingen så det komme.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Dagens resultat: $nation $score $opponent. Nu venter der spørgsmål til $nation.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ikke et enkeltstående tilfælde, hvis man har fulgt med.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nogen der har meget at forklare.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Stort navn, lille præstation.';
  }

  @override
  String yDownGap0(String opponent, int gap) {
    return '$opponent: $gap pladser bag os. Det sker. Videre.';
  }

  @override
  String yDownGap1(int gap) {
    return 'Ranglisteforskel: $gap pladser i vores favør. Fodbold læser ikke ranglister.';
  }

  @override
  String yDownGap2(String opponent, int gap) {
    return '$gap pladser mellem os og $opponent på papiret. Ikke på banen i aften.';
  }

  @override
  String yDownGap3(String opponent, int gap) {
    return 'Ranglisteforskel før kampstart: $gap pladser i vores favør. Nederlag mod $opponent alligevel.';
  }

  @override
  String yDownGap4(String opponent, int gap) {
    return 'På verdensranglisten lå $opponent $gap pladser bag os. Resultat: nederlag.';
  }

  @override
  String yDownGap5(String opponent, int gap) {
    return 'Overraskelsesindeks: $gap ranglistepladser, den forkerte vej, mod $opponent.';
  }

  @override
  String yDownGap6(String opponent, int gap) {
    return '$gap pladser foran $opponent på ranglisten. Nederlag. Forklar det.';
  }

  @override
  String yDownGap7(int gap) {
    return 'Nederlag mod et hold $gap pladser bag os. Lad det tal synke ind.';
  }

  @override
  String yDownGap8(String opponent, int gap) {
    return 'Ranglisteforskel: $gap pladser. Nederlag mod $opponent. Nogen bør begynde at tælle dage.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score mod $opponent! Uafgjort, der føles som en sejr.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score mod $opponent. Stolt af hver og en.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. De var favoritter, og vi kunne følge med.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score mod $opponent. Et point vundet med blod og sved.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score mod $opponent. Et rigtig godt point.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Uafgjort $score mod $opponent. Få havde forventet noget som helst.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponent stoppet, $score. Et resultat at bygge videre på.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score mod $opponent. Et point, ingen gav os.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score mod $opponent. Godt point, men man vinder intet på uafgjorte kampe.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score mod $opponent. Fint. Vi havde heller ikke ét rigtigt skud.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Ét point, og alle opfører sig, som om vi vandt pokalen.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score mod $opponent. Vi parkerede bussen og var heldige.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score mod $opponent. Frustrerende, men stadig ubesejrede.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Kun $score mod $opponent. En dårlig dag. Det sker.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Ikke godt nok, og spillerne ved det.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score mod $opponent. To tabte point, ikke mere.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score mod $opponent. To point smidt væk.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Kun $score mod $opponent. Et dårligt resultat, uanset indpakning.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Uafgjort, der føles som et nederlag.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score mod $opponent. Den slags kampe skal vi vinde sikkert.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score mod $opponent. Pinligt.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Kun uafgjort mod $opponent, $score. Hvem har ansvaret for det her?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Hvis vi ikke kan slå dem, hvem kan vi så slå?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score mod $opponent. Deres fans fejrer uafgjort mod os. Tænk over det.';
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
  String yScorerStar0(String name, int goals) {
    return '$name lavede $goals af dem. Ingen andre er i nærheden.';
  }

  @override
  String yScorerStar1(String name, int goals) {
    return '$goals til $name. Han bærer dette hold.';
  }

  @override
  String yScorerStar2(String name, int goals) {
    return '$name: $goals på dagen. Sikke en spiller.';
  }

  @override
  String yScorerStar3(String name, int goals) {
    return '$name satte $goals forbi dem. Tag en bukning.';
  }

  @override
  String yScorerStar4(String name, int goals) {
    return '$goals til $name, og resten var passagerer.';
  }

  @override
  String yScorerStar5(String name, int goals) {
    return '$name igen. $goals. Forestil dig dette hold uden ham.';
  }

  @override
  String yScorerStar6(String name, int goals) {
    return '$goals fra $name. Én mand burde ikke skulle gøre så meget.';
  }

  @override
  String yScorerStar7(String name, int goals) {
    return 'Tag $name ud af den, og det er $goals færre og en helt anden eftermiddag.';
  }

  @override
  String yWinStreak0(int count) {
    return '$count i træk. Hvad end der bliver sagt i den omklædningsstue, så virker det.';
  }

  @override
  String yWinStreak1(int count) {
    return 'Det er $count på stribe. Hold falder ikke tilfældigt ind i stimer som denne.';
  }

  @override
  String yWinStreak2(int count) {
    return '$count i træk og stadig i gang. Selvtilliden kan ses fra tribunen.';
  }

  @override
  String yWinStreak3(int count) {
    return 'Ingen nederlag i $count. Spørg enhver, der har trænet: det er den svære del.';
  }

  @override
  String yWinStreak4(int count) {
    return '$count i træk. Nyd det, mens kampprogrammet er venligt.';
  }

  @override
  String yWinStreak5(int count) {
    return '$count på stribe, og vi har ikke slået nogen af betydning.';
  }

  @override
  String yWinStreak6(int count) {
    return 'En stime på $count. Spørg mig igen, når den bliver testet.';
  }

  @override
  String yWinStreak7(int count) {
    return '$count på stribe. Ethvert hold har sådan en i sig én gang.';
  }

  @override
  String yLossStreak0(int count) {
    return '$count uden sejr nu. På et tidspunkt løber undskyldningerne tør.';
  }

  @override
  String yLossStreak1(int count) {
    return 'Det er $count i træk væk. Det er ikke et udsving længere.';
  }

  @override
  String yLossStreak2(int count) {
    return '$count nederlag i træk. Nogen må stå til ansvar.';
  }

  @override
  String yLossStreak3(int count) {
    return 'Ingen sejre i $count. Man kan se det på, hvordan de spiller.';
  }

  @override
  String yLossStreak4(int count) {
    return '$count uden sejr og de samme fejl hver uge.';
  }

  @override
  String yLossStreak5(int count) {
    return '$count i træk. Hvad end der bliver prøvet, virker det ikke.';
  }

  @override
  String yLossStreak6(int count) {
    return '$count på stribe. Det er en retning, ikke en dukkert.';
  }

  @override
  String yLossStreak7(int count) {
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
    String _temp0 = intl.Intl.pluralLogic(
      titles,
      locale: localeName,
      other: '$titles titler',
      one: '1 titel',
    );
    String _temp1 = intl.Intl.pluralLogic(
      editions,
      locale: localeName,
      other: '$editions turneringer',
      one: '1 turnering',
    );
    return '$nation: $_temp0 fra $_temp1';
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
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation spiller ikke play-off: alle pladser afgøres i kvalifikationsgrupperne.';
  }

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
  String get objectiveQualifyingChallenge =>
      'Kæmp om en plads, mindst den øverste halvdel af kvalifikationen';

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
  String get objectiveNcOffTheBottom => 'Undgå sidstepladsen i din gruppe';

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
  String get finishNcClearOfBottom => 'Ikke i bunden af gruppen';

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
  String squadDevPageOf(String page, String pages, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total spillere',
      one: '1 spiller',
    );
    return '$page/$pages · $_temp0';
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
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps landskampe',
      one: '1 landskamp',
    );
    return 'Alder $age · $_temp0';
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
      'Verdens medier vil tale med dig før din næste kamp';

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
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps landskampe',
      one: '1 landskamp',
    );
    return '$name · $_temp0';
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
    return '$name vil skifte til $nation!';
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
  String get matchLineupsViewPitch => 'Bane';

  @override
  String get matchLineupsViewList => 'Liste';

  @override
  String get matchLineupsCameOn => 'Skiftet ind';

  @override
  String get matchConditionsKickOff => 'Kampstart';

  @override
  String get matchWeatherClear => 'Klart';

  @override
  String get matchWeatherRain => 'Let regn';

  @override
  String get matchWeatherSnow => 'Sne';

  @override
  String get matchWeatherHaze => 'Dis';

  @override
  String get matchWeatherHeavyRain => 'Kraftig regn';

  @override
  String get matchWeatherThunderstorm => 'Tordenvejr';

  @override
  String get matchWeatherFog => 'Tåge';

  @override
  String get matchWeatherWindy => 'Blæsende';

  @override
  String get matchWeatherDustStorm => 'Sandstorm';

  @override
  String get matchWeatherFrostyNight => 'Frostklar nat';

  @override
  String get matchPlayerOfTheMatch => 'KAMPENS SPILLER';

  @override
  String get ratingPlayerOfTheMatch => 'Kampens spiller';

  @override
  String ratingSemantics(String rating) {
    return 'Karakter $rating';
  }

  @override
  String get matchAverageRating => 'Gennemsnitskarakter';

  @override
  String get matchLiveRatingsNote =>
      'Karaktererne følger kampen indtil nu og er endelige ved slutfløjtet.';

  @override
  String get matchGoalShout => 'MÅL!';

  @override
  String get matchRedCardShout => 'RØDT KORT';

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
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps landskampe',
      one: '1 landskamp',
    );
    return '$name er stoppet på landsholdet som $age-årig efter $_temp0. Han bad om at få at vide, hvor han stod, og fik intet svar, så han venter ikke længere.';
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
  String get backupTitle => 'SIKKERHEDSKOPIER';

  @override
  String get backupBlurb =>
      'Alle gemte spil ligger i én fil på denne telefon, og intet tager kopi af dem af sig selv, medmindre du slår automatisk sikkerhedskopi til nedenfor. Hav en kopi i skyen, så en mistet telefon eller en slettet app ikke koster dig en karriere.';

  @override
  String get backupBlurbNoAuto =>
      'Alle gemte spil ligger i én fil på denne telefon, og intet tager kopi af dem af sig selv. Hav en kopi i skyen, så en mistet telefon eller en slettet app ikke koster dig en karriere.';

  @override
  String get backupExport => 'SIKKERHEDSKOPIER TIL SKYEN';

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
  String yAgainstThemAgain0(String opponent, int count) {
    return 'Det er $count gange mod $opponent nu. Nogen fører regnskab, og det er dem.';
  }

  @override
  String yAgainstThemAgain1(String opponent, int count) {
    return '$opponent igen. $count opgør, og vi har stadig ikke regnet dem ud.';
  }

  @override
  String yAgainstThemAgain2(String opponent, int count) {
    return 'Nummer $count mod $opponent. Det er holdt op med at være tilfældigt.';
  }

  @override
  String yAgainstThemAgain3(String opponent, int count) {
    return 'Vi har mødt $opponent $count gange og lært intet af nogen af dem.';
  }

  @override
  String yAgainstThemAgain4(String opponent, int count) {
    return '$opponent, $count gange. De ved præcis, hvad vi gør.';
  }

  @override
  String yAgainstThemAgain5(String opponent, int count) {
    return 'Uanset hvad $opponent har på os, har de det stadig efter $count opgør.';
  }

  @override
  String ySameOldStory0(int count) {
    return 'Det er $count gange, det er sket på det seneste. Hvornår er det bare, hvad vi er?';
  }

  @override
  String ySameOldStory1(int count) {
    return '$count eftermiddage som den her nu. Det er et mønster, ikke held.';
  }

  @override
  String ySameOldStory2(int count) {
    return 'Vi har set præcis den her kamp $count gange på det seneste. Samme manuskript, samme slutning.';
  }

  @override
  String ySameOldStory3(int count) {
    return '$count udgaver af de samme halvfems minutter nu. Ingen retter op på det.';
  }

  @override
  String ySameOldStory4(int count) {
    return '$count gange. Kan du ikke se mønsteret nu, kigger du ikke efter.';
  }

  @override
  String ySameOldStory5(int count) {
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
  String yDrought0(String name, int count) {
    return '$name har $count kampe uden mål og gør alt andet på banen.';
  }

  @override
  String yDrought1(String name, int count) {
    return '$count kampe uden mål til $name. De kommer i tre, det har de altid gjort.';
  }

  @override
  String yDrought2(String name, int count) {
    return '$name: $count kampe, ingen mål.';
  }

  @override
  String yDrought3(String name, int count) {
    return '$count uden mål til $name. Værd at holde øje med.';
  }

  @override
  String yDrought4(String name, int count) {
    return '$count kampe. Ingen mål. $name kunne ikke ramme en laden.';
  }

  @override
  String yDrought5(String name, int count) {
    return '$name har ikke scoret i $count. Spil bogstaveligt talt en anden i stedet.';
  }

  @override
  String yRivalryLooms0(String opponent, int count) {
    return '$opponent næste gang. $count opgør, og det betyder stadig alt.';
  }

  @override
  String yRivalryLooms1(String opponent, int count) {
    return '$count gange mod $opponent nu. Kom an.';
  }

  @override
  String yRivalryLooms2(String opponent, int count) {
    return '$opponent næste gang. Spillet $count.';
  }

  @override
  String yRivalryLooms3(String opponent, int count) {
    return 'Opgør nummer $count med $opponent i denne uge.';
  }

  @override
  String yRivalryLooms4(String opponent, int count) {
    return '$opponent igen. $count af dem, og vi har lært intet.';
  }

  @override
  String yRivalryLooms5(String opponent, int count) {
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
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) er skadet. Udtag en vilkårlig spiller uden for truppen, på en hvilken som helst position, eller behold ham og spil videre.';
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
      'Ækvatorialguinea, den mindste af Afrikas Guineaer, i to cyklusser';

  @override
  String get campaignGuineasGoal => 'Slå Guinea og Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Tre afrikanske lande bærer navnet Guinea, og Ækvatorialguinea er det mindste af dem. Du har to cyklusser til at slå Guinea og Guinea-Bissau mindst én gang hver, og så se, hvor langt du kan nå i Afrikamesterskabet. Papua Ny Guinea, den fjerde Guinea, er allerede booket til en venskabskamp.';

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
  String get campaignGreenlandTitle => 'Et grønlandsk århundrede';

  @override
  String get campaignGreenlandTwist =>
      'Grønland tager San Marinos plads i Europa, i hundrede år';

  @override
  String get campaignGreenlandGoal => 'Kvalificér dig til et Europamesterskab';

  @override
  String get campaignGreenlandIntro =>
      'Grønland har aldrig spillet en tællende landskamp. I denne verden har de taget San Marinos plads i Europa, og de starter helt i bunden af verdensranglisten: amatørspillere, kunstgræsbaner og en sæson klemt inde mellem snefaldene. Du har hundrede år, femogtyve cyklusser, til at nå et Europamesterskab, derefter et Verdensmesterskab og, hvis du tør drømme, vinde et af dem.';

  @override
  String get campaignStars1Greenland =>
      'Kvalificér dig til et Europamesterskab';

  @override
  String get campaignStars2Greenland => 'Kvalificér dig til et VM';

  @override
  String get campaignStars3Greenland =>
      'Vind Europamesterskabet eller Verdensmesterskabet';

  @override
  String get campaignZanzibarTitle => 'Zanzibar rejser sig';

  @override
  String get campaignZanzibarTwist =>
      'Zanzibar tager Tchads plads i Afrika, i hundrede år';

  @override
  String get campaignZanzibarGoal => 'Kvalificér dig til et Afrikamesterskab';

  @override
  String get campaignZanzibarIntro =>
      'Zanzibar har sit eget fodboldforbund og sit eget landshold, men ingen plads i afrikansk fodbold eller i verdensfodbolden. I denne verden har de taget Tchads plads i Afrika, og de starter nær bunden af verdensranglisten: øspillere, små stadioner og monsunens hede. Du har hundrede år, femogtyve cyklusser, til at nå et Afrikamesterskab, derefter et Verdensmesterskab og, hvis du tør drømme, vinde Verdensmesterskabet.';

  @override
  String get campaignStars1Zanzibar => 'Kvalificér dig til et Afrikamesterskab';

  @override
  String get campaignStars2Zanzibar => 'Kvalificér dig til et VM';

  @override
  String get campaignStars3Zanzibar => 'Vind Verdensmesterskabet';

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

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name skinner på $level-landsholdet';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Akademirapport: $name skiller sig ud';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Bedst på $level-landsholdet: $name';
  }

  @override
  String newsYouthGoals1(
    String name,
    String level,
    String opponent,
    int count,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gange',
      one: 'én gang',
    );
    return '$name fandt nettet $_temp0 for $level-landsholdet mod $opponent i den seneste landsholdspause.';
  }

  @override
  String newsYouthGoals2(
    String name,
    String level,
    String opponent,
    int count,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mål',
      one: 'Et mål',
    );
    return '$_temp0 af $name, da $level-landsholdet mødte $opponent i denne landsholdspause.';
  }

  @override
  String newsYouthGoals3(
    String name,
    String level,
    String opponent,
    int count,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mål',
      one: 'et mål',
    );
    return '$level-landsholdet mødte $opponent, og $name forlod banen med $_temp0 på kontoen.';
  }

  @override
  String newsYouthAssists1(
    String name,
    String level,
    String opponent,
    int count,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mål',
      one: 'et mål',
    );
    return '$name lagde op til $_temp0 for $level-landsholdet mod $opponent og styrede spillet fra start til slut.';
  }

  @override
  String newsYouthAssists2(
    String name,
    String level,
    String opponent,
    int count,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assists',
      one: 'én assist',
    );
    return '$level-landsholdet mødte $opponent i denne landsholdspause, og det var $name, der trak i trådene: $_temp0 og en præstation, som trænerteamet stadig taler om.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name var fremragende, da $level-landsholdet holdt buret rent mod $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Rent bur for $level-landsholdet mod $opponent, og $name var den største grund.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name imponerede for $level-landsholdet mod $opponent, og trænerteamet gav hans præstation $mark ud af ti.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$level-landsholdet spillede mod $opponent i denne landsholdspause, og trænerne fremhævede $name: $mark ud af ti, holdets højeste karakter.';
  }

  @override
  String get newsYouthDevReady1 =>
      'I denne form er han allerede god nok til at komme i betragtning til A-landsholdet.';

  @override
  String get newsYouthDevReady2 =>
      'Trænerteamet mener, at han er klar til seniorfodbold allerede nu. Valget er dit.';

  @override
  String get newsYouthDevClose1 =>
      'Han udvikler sig godt og er tæt på at bryde igennem på A-landsholdet.';

  @override
  String get newsYouthDevClose2 =>
      'Han er ikke langt fra A-landsholdet, og én god sæson mere kan være nok.';

  @override
  String get newsYouthDevGrowing1 =>
      'Han udvikler sig fint, selvom A-landsholdet stadig er et trin eller to væk.';

  @override
  String get newsYouthDevGrowing2 =>
      'Der er arbejde tilbage, før han bliver A-landsholdsspiller, men alt peger i den rigtige retning.';

  @override
  String get newsYouthDevRaw1 =>
      'Han er stadig rå og nogle år fra A-landsholdet, men talentet er tydeligt.';

  @override
  String get newsYouthDevRaw2 =>
      'Det er tidligt, og akademiets trænere beder om tålmodighed frem for overskrifter.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Hans rækkevidde og kontrol over feltet er det, der adskiller ham.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Hans greb og udspil er det bedste, akademiet har set i årevis.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Hans koncentration svigter aldrig: han er lige så skarp i halvfemsindstyvende minut som i det første.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Hans fart og hovedspil er nøglen til hans spil.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Han læser spillet langt over sin alder og er rolig på bolden.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Han slapper aldrig af og spurter stadig hjem i sidste minut.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Han vinder bolden med ægte kraft og driver fremad med den.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Hans overblik og afleveringsregister er nøglen til hans spil.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Hans motor er enestående: han dækker hvert græsstrå.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Hans fart i dybden og styrke i luften gør ham til et problem for ethvert forsvar.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Hans afslutninger og bevægelser i feltet er nøglen til hans spil.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Han presser højt hele kampen og giver aldrig forsvarerne et øjebliks ro.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Fansene kommer til at synge om kampen mod $opponent længe. Hvad sagde du til spillerne ved slutfløjtet?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Det var en markering mod $opponent. Hvor meget af det kom fra træningsbanen?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Ros for resultatet mod $opponent, men den slags aftener har vi set før. Hvad er anderledes denne gang?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Alle har en dårlig aften, og det her var en mod $opponent. Hvor hurtigt kan du lægge den bag dig?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent var bedre i alle kæder. Hvor begynder du at reparere?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Fansene gik før tid mod $opponent. Kan du bebrejde dem det?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Det har været en hård periode, og $opponent gjorde det ikke lettere. Hvad holder dig oppe?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Endnu en kamp uden sejr, denne gang mod $opponent. Hvor længe kan det fortsætte, før bestyrelsen griber ind?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Nu også $opponent. Er der noget tilbage i din plan, eller er det tid til at give plads til en anden?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Uanset hvad I skriver, så skriv det om spillerne. Det har de fortjent.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Jeg har en gruppe, der ville gå gennem ild for hinanden. Det er ikke ingenting.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Jeg træffer beslutningerne, så kritikken skal gå til mig. Det er jobbet.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Kig på landstræneren først. Jeg har lavet fejl, og jeg retter dem.';

  @override
  String get pressReplyDemandMore5 =>
      'Godt er ikke godt nok her. Det har jeg sagt til dem lige op i ansigtet.';

  @override
  String get pressReplyDemandMore6 =>
      'Ingen i det omklædningsrum har en garanteret plads. Det ved de nu.';

  @override
  String get pressReplyDeflect5 =>
      'I kan spørge på tre forskellige måder. Svaret bliver det samme.';

  @override
  String get pressReplyDeflect6 =>
      'Mine tanker beholder jeg til spillerne. Det forstår I.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score mod $opponent. Roligt, kontrolleret, voksent fodbold. Dejligt at se.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return 'Slog $opponent $score uden at svede. Holdet bliver godt til kedeligt, og kedeligt vinder titler.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Tre point, intet drama, tilbage til arbejdet.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Rutinepræget $score mod $opponent. Ingen vil huske det, og ingen behøver.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score mod $opponent, og alligevel er jeg på en eller anden måde bekymret.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return 'Slog $opponent $score. Mod et rigtigt hold bliver den præstation straffet.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score mod $opponent. Bed tænderne sammen, led, vandt. Det er et hold.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return 'Slog $opponent $score på ren vilje. Jeg tager gerne et hold, der nægter at tabe.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Det gik helt til sidste fløjt, men pointene er vores.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Knebne $score mod $opponent. Ikke meget imellem, og sådan er fodbold.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score mod $opponent. Ét heldigt hop den anden vej, og vi havde haft en helt anden samtale.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Hang lige akkurat på mod $opponent, $score. Ingen bør kalde det en præstation.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score mod $opponent. Ikke et nederlag, og nogle dage er det præcis jobbet.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Et hårdt tilkæmpet point mod $opponent, $score. Jeg kunne lide kampgejsten.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Retfærdig pointdeling, som de gamle kommentatorer plejede at sige.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score mod $opponent. Ingen af holdene gjorde nok til at fortjene mere.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score mod $opponent. Den slags uafgjort, der føles som et nederlag i bussen hjem.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Uafgjort $score mod $opponent. Vi taler hele tiden om fremskridt og gør hele tiden det her.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score mod $opponent. Det gør ondt, men jeg så nok til at tro på det her hold.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Tabte $score til $opponent, og de var gode. Anerkend det og kør på igen.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Et nederlag, et par lektier og næste kamp snart.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Nederlag $score til $opponent. Svært at sige imod.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score mod $opponent. De samme fejl som sidst, begået med den samme selvsikkerhed.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Tabte $score til $opponent. Hvis ingen skal stå til ansvar for det, hvad laver vi så?';
  }

  @override
  String get yReactionShrug12 =>
      'Fint med mig. Ikke hver aften behøver fyrværkeri.';

  @override
  String get yReactionShrug13 => 'Point er point. Sover godt i nat.';

  @override
  String get yReactionShrug14 => 'Set. Ingen kommentarer.';

  @override
  String get yReactionShrug15 => 'Et sted mellem fint og fint.';

  @override
  String get yReactionShrug16 =>
      'Betalte for streamingen til det her. Aldrig igen (jeg kommer tilbage).';

  @override
  String get yReactionShrug17 => 'Halvfems minutters fodboldformet ingenting.';

  @override
  String get yReactionRelief12 =>
      'Trækker vejret igen. Stolt af, at de holdt ud.';

  @override
  String get yReactionRelief13 =>
      'Det er den slags sejre, der bygger et hold. Grimt er smukt.';

  @override
  String get yReactionRelief14 => 'Neglene er væk, men pointene er her.';

  @override
  String get yReactionRelief15 => 'Et slutfløjt har aldrig lydt så godt.';

  @override
  String get yReactionRelief16 =>
      'Glad for, at vi vandt, bekymret for hvordan.';

  @override
  String get yReactionRelief17 =>
      'Vi slipper af sted med det igen og igen. En dag gør vi ikke.';

  @override
  String get yReactionFury12 =>
      'Jeg elsker det her hold, og det er netop derfor, det gør ondt.';

  @override
  String get yReactionFury13 =>
      'Dårlig aften. Næste gang skylder de os en, og det ved de.';

  @override
  String get yReactionFury14 =>
      'Slukkede efter halvfjerds minutter. Burde have været tres.';

  @override
  String get yReactionFury15 =>
      'Ingen kamp, ingen idéer, ingen undskyldninger.';

  @override
  String get yReactionFury16 =>
      'De samme problemer hver gang, og ingen løser noget.';

  @override
  String get yReactionFury17 =>
      'Nogen i forbundet må se det her igen og forklare det.';

  @override
  String get backupShareHint =>
      'Laver én sikkerhedskopi af alle gemte spil. Vælg Google Drev, iCloud Drive eller Filer til at gemme den.';

  @override
  String backupLastAt(String date) {
    return 'Seneste sikkerhedskopi: $date';
  }

  @override
  String get backupNever => 'Ingen sikkerhedskopi endnu';

  @override
  String get backupRemindersTitle => 'Påmindelser om sikkerhedskopi';

  @override
  String get backupRemindersBlurb =>
      'En besked i indbakken, når din seneste sikkerhedskopi begynder at blive gammel.';

  @override
  String get backupAutoICloudTitle => 'Automatisk sikkerhedskopi til iCloud';

  @override
  String get backupAutoDriveTitle =>
      'Automatisk sikkerhedskopi til Google Drev';

  @override
  String get backupAutoBlurb =>
      'Tager kopi efter kampe, ved slutningen af en cyklus og når du forlader appen. Beholder de to seneste.';

  @override
  String get backupStatusUploading => 'Tager sikkerhedskopi nu.';

  @override
  String get backupStatusUploaded => 'Sikkerhedskopieret.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud er slået fra. Log ind på iCloud, og slå iCloud Drive til i appen Indstillinger.';

  @override
  String get backupStatusDriveSignedOut =>
      'Ikke logget ind. Slå kontakten til for at logge ind med Google.';

  @override
  String get backupStatusNotConfigured =>
      'Ikke tilgængelig i denne version af appen endnu.';

  @override
  String get backupStatusUnavailable =>
      'Skyen kan ikke nås lige nu. Der prøves igen senere.';

  @override
  String get backupStatusFailed =>
      'Den seneste automatiske sikkerhedskopi gik ikke igennem. Der prøves igen senere.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Logget ind som $email';
  }

  @override
  String get backupDriveSignOut => 'LOG UD';

  @override
  String get backupDriveSignInFailed =>
      'Login med Google virkede ikke. Prøv igen senere.';

  @override
  String get backupRestoreICloud => 'GENDAN FRA ICLOUD';

  @override
  String get backupRestoreDrive => 'GENDAN FRA GOOGLE DREV';

  @override
  String get backupCrossPlatformHelp =>
      'Skifter du mellem iPhone og Android? Tag en sikkerhedskopi til en fil på den ene telefon, og gendan fra den fil på den anden.';

  @override
  String get backupCloudListBlurb =>
      'Sikkerhedskopier fra dine enheder på denne konto. Tryk på en for at gendanne den.';

  @override
  String get backupCloudListEmpty =>
      'Ingen sikkerhedskopier fundet endnu. En ny kan være et par minutter om at nå en anden enhed.';

  @override
  String get backupCloudListFailed =>
      'Sikkerhedskopierne kunne ikke læses. Tjek forbindelsen, og prøv igen.';

  @override
  String get backupCloudThisDevice => 'Denne enhed';

  @override
  String backupCloudMore(int count) {
    return 'Flere gemte spil: $count';
  }

  @override
  String get backupCloudNewer =>
      'Lavet med en nyere version af appen. Opdater først.';

  @override
  String get backupCloudDownloading => 'Henter sikkerhedskopien.';

  @override
  String get backupRestoreSafetyNote =>
      'Først gemmes en kopi af telefonens gemte spil på denne telefon.';

  @override
  String get backupRejectedSafety =>
      'Der kunne ikke gemmes en kopi af de nuværende gemte spil, så intet blev erstattet.';

  @override
  String get newsBackupReminderTitle => 'Tid til en sikkerhedskopi';

  @override
  String get newsBackupReminderBody =>
      'Dine gemte spil findes kun på denne telefon. Åbn Indstillinger, og tryk på Sikkerhedskopier til skyen, eller slå automatisk sikkerhedskopi til der. Disse påmindelser kan også slås fra i Indstillinger.';

  @override
  String get backupSafetyTitle => 'Kopier fra før en gendannelse';

  @override
  String get backupSafetyBlurb =>
      'Gemt på denne telefon, hvis en gendannelse var den forkerte. De tre nyeste beholdes.';

  @override
  String get backupSafetyRestore => 'GENDAN';

  @override
  String get backupSafetyShare => 'DEL';

  @override
  String get saveUpgradeFailedTitle => 'Dit gemte spil kunne ikke opdateres';

  @override
  String get saveUpgradeFailedBody =>
      'Dit gemte spil kunne ikke opdateres. Intet er slettet, og en kopi fra før opdateringen er gemt på denne telefon.';

  @override
  String get saveUpgradeRestoreButton => 'Gendan kopien fra før opdateringen';

  @override
  String get saveUpgradeRestoreFailed =>
      'Kopien kunne ikke gendannes. Dit gemte spil er uændret.';

  @override
  String get saveOpenFailedTitle => 'Dine gemte spil kunne ikke åbnes';

  @override
  String get saveOpenFailedBody =>
      'Dine gemte spil kunne ikke åbnes. Intet er slettet. Prøv igen om lidt.';

  @override
  String get backupCloudNoDetails => 'Detaljerne er stadig på vej.';

  @override
  String get tacticsLibraryTitle => 'TAKTIKBIBLIOTEK';

  @override
  String get tacticsLibraryBlurb =>
      'Taktikker i dit bibliotek kan indlæses i ethvert gemt spil, også nye. Roller og dødboldsskytter gemmes efter position, ikke efter spiller.';

  @override
  String get tacticsSaveToLibrary => 'Gem i biblioteket';

  @override
  String get tacticsLoadFromLibrary => 'Indlæs fra biblioteket';

  @override
  String get tacticsLibraryEmpty =>
      'Dit bibliotek er tomt. Gem en taktik her, så kan du indlæse den i alle dine gemte spil.';

  @override
  String tacticsLibrarySaved(String name) {
    return 'Gemte “$name” i biblioteket';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Indlæste “$name”';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count roller eller dødboldsskytter passede ikke til denne trup.',
      one: '1 rolle eller dødboldsskytte passede ikke til denne trup.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Omdøb';

  @override
  String get tacticsLibraryRenameTitle => 'Omdøb taktik';

  @override
  String get tacticsLibraryDelete => 'Slet';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Slet “$name”?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Den forsvinder fra biblioteket i alle dine gemte spil.';

  @override
  String get tacticsLibraryNameTaken =>
      'Dit bibliotek har allerede en taktik med det navn.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Biblioteket kunne ikke indlæses.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Ansøgning om værtskab: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Værtsansøgning';

  @override
  String get hostBidBlurb =>
      'Værtslandet trækkes blandt kandidaterne. En ansøgning giver dit navn mere vægt: dine stadioner giver en startchance, og penge øger den, selv om hver ekstra million tæller lidt mindre. Pengene er brugt, uanset om du vinder eller ej.';

  @override
  String hostBidPrize(String amount) {
    return 'Vinder du, bliver du vært, kvalificerer dig automatisk og får et engangstilskud på $amount til næste budget.';
  }

  @override
  String get hostBidChance => 'Chance for værtskab';

  @override
  String get hostBidBaseLabel => 'Stadioner og placering';

  @override
  String get hostBidInvestLabel => 'Investering';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Loft for $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Din investering';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Frie midler: $amount';
  }

  @override
  String get hostBidSubmit => 'Indsend ansøgning';

  @override
  String get hostBidDecline => 'Ikke denne gang';

  @override
  String get hostBidUnavailable => 'Denne ansøgning er ikke længere åben.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Ansøgningen vandt: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Vi bliver vært for turneringen og er som vært automatisk kvalificeret. Et engangstilskud på $amount ligger nu i forbundets kasse, og du kan fordele det på denne cyklus\' afdelinger direkte fra hovedskærmen.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Ansøgningen tabte: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Værtskabet gik til: $hosts. Vores ansøgning slog ikke til denne gang, og pengene er tabt, men forbundet gjorde sit.';
  }

  @override
  String get hostBidGrantEvent => 'Fordel værtstilskuddet';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Værtstilskud: $amount, som du kan lægge oven i denne cyklus\' afdelinger nu. Det, du allerede har fordelt, bliver stående, og resten bliver i kassen.';
  }

  @override
  String get stadiumsTitle => 'Nationalstadioner';

  @override
  String get stadiumsEntrySub => 'Udbyg et stadion, eller byg et nyt';

  @override
  String get stadiumsBlurb =>
      'Et stadions niveau er dets størrelse: niveau 1 under 15.000 pladser, niveau 2 fra 15.000, niveau 3 fra 25.000, niveau 4 fra 40.000, niveau 5 fra 60.000. Hvert stadion giver en lille indtægt ved starten af hver cyklus, mere jo flere pladser, så længe publikum fylder dem. En udbygning giver flere pladser med det samme og lidt omdømme fra næste cyklus; en nedbygning skærer i vedligeholdelsen, men refunderer intet. Dine stadioner afgør, hvilke turneringer du må søge værtskab for.';

  @override
  String stadiumsIncome(String amount) {
    return 'Stadionindtægter: $amount pr. cyklus';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Omdømme fra stadioner: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Byggeri bestilles ved starten af en cyklus, før budgettet er lagt.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Kapacitet: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Niveau $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Udbyg: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Højeste niveau';

  @override
  String stadiumsOpens(int year) {
    return 'Under opførelse, åbner i $year';
  }

  @override
  String get stadiumsBuildTitle => 'Byg et nyt stadion';

  @override
  String get stadiumsBuildBody =>
      'Ret dyrt: et nyt stadion i den by, du vælger, åbent fra starten af næste cyklus.';

  @override
  String get stadiumsBuildCity => 'By';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Byg: $cost';
  }

  @override
  String get stadiumsBuilding => 'Der er allerede et stadion under opførelse.';

  @override
  String get stadiumsNoCity => 'Hver by har allerede et nyt stadion.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Udbygge $stadium til niveau $level for $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Bygge et nyt stadion i $city for $cost?';
  }

  @override
  String get stadiumsConfirm => 'Bekræft';

  @override
  String get stadiumsCancel => 'Annuller';

  @override
  String get stadiumsRefused =>
      'Bestillingen gik ikke igennem. Der blev ikke trukket noget.';

  @override
  String get stadiumsNameLabel => 'Stadionnavn';

  @override
  String get stadiumsNameHint =>
      'Lad feltet stå tomt for at beholde det foreslåede navn.';

  @override
  String get stadiumsRename => 'Omdøb stadion';

  @override
  String get hostBidSectionTitle => 'Ansøgninger om værtskab';

  @override
  String get hostBidOpenSub =>
      'Valgfrit. Beslut dig, før den nye cyklus begynder.';

  @override
  String get hostBidDecidedAtRollover =>
      'Værtslandet offentliggøres, når den nye cyklus begynder.';

  @override
  String get hostBidLodged =>
      'Ansøgning indsendt. Værtslandet offentliggøres, når den nye cyklus begynder.';

  @override
  String get hostBidDeclinedNote => 'Du valgte ikke at søge denne gang.';

  @override
  String get hostBidOpensLater =>
      'Kvalificeret. Du kan søge ved slutningen af denne cyklus.';

  @override
  String get hostBidNoFunds => 'Ikke nok frie midler til at søge.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du mangler $count stadioner mere med $seats+ pladser.',
      one: 'Du mangler 1 stadion mere med $seats+ pladser.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation var vært for det seneste Verdensmesterskab.';
  }

  @override
  String get hostBidRecentHost =>
      'Du var vært for en af de tre seneste udgaver.';

  @override
  String get hostBidBelowBar =>
      'Dine stadioner lever ikke op til turneringens krav.';

  @override
  String get hostBidRulesPending =>
      'Om du kan søge, bliver klart, når værterne for denne cyklus er offentliggjort.';

  @override
  String get hostBidBackToBack =>
      'Du er vært for turneringen lige før denne. Ingen nation er vært for to turneringer i træk.';

  @override
  String get hostBidOneOnly =>
      'Du har allerede søgt om den anden turnering. Ingen nation er vært for to turneringer i træk, så du kan kun søge om én.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Krav: $grounds stadioner med $minSeats+ pladser, heraf $bigGrounds med $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Vi bliver værter for turneringen og er automatisk kvalificeret som værtsland. Et engangstilskud på $amount er allerede i forbundets midler, klar til denne cyklus\' budget.';
  }

  @override
  String get hubStadiumIncome => 'Stadionindtægter';

  @override
  String get stadiumsDownsize => 'Byg ned';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Bygge $stadium ned til $seats pladser (niveau $level)? Intet refunderes, men vedligeholdelsen falder.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Ombygget i denne cyklus';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Giver $amount pr. cyklus';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Ansøgning trukket: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Ansøgningen gjaldt $nation, men du begynder den nye cyklus et andet sted. Den er trukket tilbage, og intet er trukket fra kontoen.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'Da cyklussen sluttede, dækkede forbundets midler ikke længere indsatsen. Ansøgningen er trukket tilbage, og intet er trukket fra kontoen.';

  @override
  String get stadiumsViewMap => 'Kort';

  @override
  String get stadiumsViewList => 'Liste';

  @override
  String get stadiumsMapPickCity =>
      'Tryk på en by for at bygge et nyt stadion der.';

  @override
  String get stadiumsMapFit => 'Vis hele landet';

  @override
  String get campaignLegacyTitle => 'Fuldend arven';

  @override
  String get campaignLegacyTwist =>
      'Spanien, regerende europamestre, i én cyklus';

  @override
  String get campaignLegacyGoal => 'Forsvar EM-titlen';

  @override
  String get campaignLegacyIntro =>
      'Spanien er regerende europamestre, og tvivlerne kalder guldperioden et engangsfænomen. Du har én cyklus til at bevise det modsatte: forsvar kontinentets krone, og gå så efter verden. Læg Nations Cup oveni, så er arven fuldendt.';

  @override
  String get campaignStars1Legacy => 'Vind Europamesterskabet';

  @override
  String get campaignStars2Legacy => 'Og Verdensmesterskabet';

  @override
  String get campaignStars3Legacy => 'Og Nations Cup';

  @override
  String get campaignSectionOneCycle => 'Én cyklus';

  @override
  String get campaignSectionShort => 'Nogle cyklusser';

  @override
  String get campaignSectionLong => 'Det lange seje træk';

  @override
  String get campaignFilterAll => 'Alle';

  @override
  String get campaignFilterNew => 'Ikke spillet';

  @override
  String get campaignFilterInProgress => 'I gang';

  @override
  String get campaignFilterDone => 'Gennemført';

  @override
  String get campaignFilterEmpty => 'Her er ingen kampagner endnu.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stjerner',
      one: '1 stjerne',
      zero: 'Ingen stjerner',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cyklusser',
      one: '1 cyklus',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Han stopper på toppen, som mester.';

  @override
  String get msgIntlRetireNoteMissed => ' At misse slutrunden blev dråben.';

  @override
  String get msgIntlRetireNoteSurprise => ' Ingen så det komme.';

  @override
  String get msgIntlRetireNoteRecord =>
      ' Han går som landsholdets rekordindehaver.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name stopper på landsholdet';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) har meddelt, at han stopper på landsholdet som $age-årig.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name gør comeback på landsholdet';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name er igen til rådighed for udtagelse som $age-årig.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Med en trup hærget af skader har han svaret på kaldet.';

  @override
  String get msgIntlComebackNoteManager =>
      ' Den nye landstræner fik ham til at skifte mening.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name gør comeback på landsholdet';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) er igen til rådighed for udtagelse som $age-årig.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Stoppede på landsholdet, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Comeback på landsholdet, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Tak, $name. Nogle bærer trøjen, han bar holdet.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name stopper på landsholdet. En æra er slut.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name stopper. En slutrunde for sent, hvis vi skal være ærlige.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Så $name er færdig. Tid til at give de unge en chance.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Højde $altitudeString m: modstanderen bliver hurtigere træt';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Højde $altitudeString m: dine spillere bliver hurtigere trætte';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Højde $altitudeString m: begge hold bliver hurtigere trætte';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Højde $altitudeString m: begge hold er vant til det';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Varme: $tempString °C ventet, kræfterne slipper op tidligere';
  }

  @override
  String get matchConditionsAdvice =>
      'Planlæg udskiftningerne tidligt: friske ben tæller mere her';

  @override
  String get fanMoodFurious => 'rasende';

  @override
  String get fanMoodRestless => 'urolige';

  @override
  String get fanMoodCalm => 'rolige';

  @override
  String get fanMoodUpbeat => 'optimistiske';

  @override
  String get fanMoodEuphoric => 'euforiske';

  @override
  String matchHomeFans(String mood) {
    return 'Hjemmefansene: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Fansene: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Stadionindtægter næste cyklus: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Tyve år efter landsholdet, hjemme og ude. Jeg fornyer ikke mit sæsonkort, før noget ændrer sig.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Vi bliver ved med at synge for trøjen. Men banneret på nordtribunen sagde i aften det, vi alle tænker.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Halvt stadion tomt, og den anden halvdel brugte anden halvleg på at synge #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Fanklubberne taler om at boykotte næste hjemmekamp. Svært at bebrejde dem.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Ikke engang vred længere. Bare færdig.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Billede fra i aften: rækker af tomme sæder og ét lagen med #${manager}Out. Det er kamprapporten.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Udsolgt igen. Det bedste landshold i årevis, og hele landet ved det.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Næste hjemmekamp blev udsolgt på elleve minutter. Det her hold har givet os weekenderne tilbage.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Ikke én ledig plads til næste hjemmekamp. Forbundet tæller billetindtægterne med et smil.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Udsolgt igen. Sig hvad I vil om taktikken, folk vil være på det stadion.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Udsolgt, fint. De samme mennesker buhede ad holdet for halvandet år siden.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Pludselig udsolgt, pludselig eksperter allesammen. Hvor var alle, da vi ikke kunne slå nogen?';
  }

  @override
  String get campaignsIntro =>
      'Kampagner er håndlavede udfordringer: en bestemt nation, en verden med sit eget twist og et mål, der skal nås inden for et fast antal cyklusser. Hvert forsøg holdes adskilt fra dine gemte karrierer, og jo længere du når, jo flere stjerner får du, op til tre.';

  @override
  String hubEventScandal(String player) {
    return 'Skandale på samlingen: $player';
  }

  @override
  String get hubEventScandalSub => 'Sende ham hjem eller beholde ham?';

  @override
  String get scandalTitle => 'SKANDALE';

  @override
  String scandalStoryParty(String player) {
    return '$player var til en fest, der varede til daggry, og billederne var i alle aviser den morgen, truppen samledes.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player brød udgangsforbuddet og blev taget i at komme tilbage til hotellet midt om natten.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player blev fotograferet på en natklub aftenen før samlingen, og billederne er overalt.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player tilbragte natten før samlingen ved et kasinobord, og et sladderblad har billederne.';
  }

  @override
  String get scandalSendHome => 'Send ham hjem';

  @override
  String scandalSendHomeCover(String player) {
    return 'Send hjem, indkald $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Behold $player';
  }

  @override
  String get scandalKeepNote =>
      'Behold ham: moral cirka -4 og bestyrelsen cirka -3 resten af cyklussen.';

  @override
  String get scandalSendHomeNote =>
      'Send ham hjem: ingen omkostning for moral eller bestyrelse, og du må indkalde en erstatning.';

  @override
  String get scandalFinalsNote =>
      'Send ham hjem: ingen omkostning for moral eller bestyrelse, men ved en slutrunde kan ingen erstatte ham.';

  @override
  String get scandalPickCover => 'Indkald en erstatning (valgfrit)';

  @override
  String newsScandalTitle(String player) {
    return 'Skandale på samlingen: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Drenge er drenge. $player til fest aftenen før samlingen, og jeg vil stadig se ham på banen. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player fotograferet til en fest hele natten, timer før truppen samledes. Forbundet er orienteret. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Fest hele natten før samlingen. $player, hvad tænkte du på? Utroligt. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Tilbage efter udgangsforbuddet, okay, det sker. $player skal bare gøre det godt igen på banen. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player taget i at komme tilbage til holdets hotel efter udgangsforbuddet, timer før træningen. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Udgangsforbud er ikke svært. $player kunne ikke klare én eneste nat. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Så $player var på klub. Fodboldspillere har også et liv. Lad ham spille. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Billeder viser $player på en natklub aftenen før landsholdssamlingen. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Klubbilleder aftenen før samlingen. $player har bragt skam over trøjen. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'En nat på kasinoet er ingen forbrydelse. Det går fint med $player. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player set ved et kasinobord natten før truppen samledes. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Hele natten på kasinoet før samlingen. $player spillede mere end penge væk. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Rigtig beslutning. Ingen er større end holdet, heller ikke $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'At sende $player hjem var det eneste svar. Respekt til landstræneren.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Disciplin er disciplin. $player kendte reglerne.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Et klart signal til truppen: $player sidder i flyet hjem.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Hårdt for $player. Én aften i byen, og samlingen er slut?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'At sende $player hjem svækker os. Det kommer vi til at betale for på banen.';
  }

  @override
  String yScandalKept0(String player) {
    return 'At beholde $player er et væddemål. Han må betale det tilbage på banen.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Fint, $player bliver. Så skylder han alle en storkamp.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Så reglerne gælder ikke for $player. Godt at vide.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Udgangsforbuddet er åbenbart frivilligt nu. Spørg $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Beholde $player efter det? Den her trup er en sommerlejr.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Fest hele natten og så lige ind i startopstillingen. Flot signal, træner. $player er sikkert henrykt.';
  }

  @override
  String get yStreamerBreaks0 =>
      'BROR BLEV TAGET 😭😭 NATTEN FØR SAMLINGEN?? JEG GRÆDER 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'NEJJJ CHAT SE LIGE HER 🤯🤯 BROR GJORDE DET SERIØST FØR SAMLINGEN 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'HVEM LUKKEDE HAM UD?? HVEM LUKKEDE HAM UD 😭😭💀 DET HER ER BIOGRAF 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'HJEM?? HJEM!!! 😭😭😭 TRÆNEREN LAVER IKKE SJOV 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'BROR PAKKER KUFFERTERNE LIVE 🤯🤯 FARVEL BROR 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'ALDRIGGG DE SENDTE HAM HJEM 💀💀 CHAT JEG RYSTER 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'HAN BLIVER??? HAN BLIVERRR 🤯🤯 BROR ER URØRLIG 😭🔥';

  @override
  String get yStreamerKept1 =>
      'FEST HELE NATTEN OG STADIG I TRUPPEN 💀💀 JEG VIL HAVE DEN KONTRAKT 😭😭';

  @override
  String get yStreamerKept2 =>
      'TRÆNEREN SIGER DET ER FINT 😭😭 BROR HVAD 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'Jeg har ikke betalt noget, og det beløb passer heller ikke';

  @override
  String get yCameoHavir0 => 'De små fisk er svømmet deres vej.';

  @override
  String get yCameoHavir1 =>
      'Vi kastede nettene ud, fiskene var et andet sted.';

  @override
  String get yCameoHavir2 =>
      'Jeg sagde det allerede i september, over en gullasch.';

  @override
  String get yCameoHavir3 =>
      'Den, der ikke fiskede i tide, skal ikke græde nu.';

  @override
  String get yCameoHavir4 => 'Vi spillede som en malle på tørt land.';

  @override
  String get yCameoHavir5 => 'Vinden blæser, dammen fryser. Sådan er det bare.';

  @override
  String get yCameoHavir6 => 'Nogle dage trækker man kun en gammel støvle op.';

  @override
  String get yCameoHavir7 =>
      'I min tid gik man i det mindste ud og fik en øl. Nu ikke engang det.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Sende en knægt hjem for én aften? Det er skandalen, ikke festen!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Drengene må da godt more sig lidt! De hykleriske medier vinder igen.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Det her er en heksejagt. En ung fyr går ud én aften, og I hænger ham.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Den journalist, der aldrig har været til fest, kan kaste den første sten. Skammeligt!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Landstræneren blev bange for sladderbladene. Jeg ville have forsvaret knægten til mit sidste åndedrag!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Endelig en landstræner med rygrad! Han beholdt knægten, og medierne kan græde.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Drengene må da godt more sig lidt, ikke? Bravo, træner!';

  @override
  String get yCameoLzimberskyKept2 =>
      'De hykleriske medier skriger, landstræneren står fast. Sådan gør man!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Én aften i byen, og pressen vil stene ham. Landstræneren er en rigtig mand!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Jeg siger: lad drengene leve! Den, der knokler, må også feste. Tommel op.';

  @override
  String get yCameoMarena => 'Det her kunne selv jeg træne.';

  @override
  String get yCameoKralik =>
      'Hvad havde du regnet med hehehe, køb vores ZeroZero';

  @override
  String get yCameoPosuk0 => 'SVAGT';

  @override
  String get yCameoPosuk1 => 'ÅH NEJJ';

  @override
  String get yCameoPosuk2 => 'Nogen der vil med på værtshus?';

  @override
  String get yTraitStreamer => 'Streamer alt, med fuld volumen, med versaler.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Årets spiller $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Stemmerne er talt op';

  @override
  String get potyCeremonyWatch => 'Se showet';

  @override
  String get potyCeremonySkipToList => 'Spring til top 5';

  @override
  String get potyCeremonySkip => 'Spring over';

  @override
  String get potyCeremonyIntro =>
      'Stemmerne er talt op. Her er årets fem bedste spillere i verden.';

  @override
  String potyCeremonyPlace(int place) {
    return 'Nr. $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'Og årets spiller er...';

  @override
  String get potyTop5Heading => 'Verdens top 5';

  @override
  String get potyYoungTop3Heading => 'Årets unge spiller: top 3';

  @override
  String get potySeeTop5 => 'Se top 5';

  @override
  String get potyYourPlayer => 'Din spiller';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clean sheets',
      one: '1 clean sheet',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Fuld briefing';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Stjerner indtil videre: $earned af $total';
  }

  @override
  String get campaignStarEarned => 'Taget indtil videre';

  @override
  String get campaignStarNotYet => 'Ikke taget endnu';

  @override
  String get stadiumsEntrySubClosed =>
      'Se dine stadioner. Arbejder kan bestilles igen i starten af næste cyklus.';

  @override
  String get boardObjectiveNoBrief => 'Intet mål sat';

  @override
  String get boardObjectiveNoBriefBody =>
      'Bestyrelsen forventer ikke, at I når denne slutrunde. Den bedømmer dig i stedet på resultaterne.';

  @override
  String get boardObjectiveAwaitingDraw => 'Mål efter lodtrækningen';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Bestyrelsen sætter dette mål, når grupperne er trukket.';

  @override
  String tourThirdsNextAdvance(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'De næste $count går videre til $destination',
      one: 'Det næste hold går videre til $destination',
    );
    return '$_temp0';
  }

  @override
  String yWinEuphoric0(String opponent, String score) {
    return 'Sikke en aften. Ikke engang i vores vildeste drømme havde vi forestillet os det her. $score mod $opponent!';
  }

  @override
  String yWinEuphoric1(String opponent, String score) {
    return '$score mod $opponent. Knib mig. Vil nogen ikke nok knibe mig?';
  }

  @override
  String yWinEuphoric2(String opponent, String score) {
    return 'Jeg græder på tribunen. $score mod $opponent. Jeg elsker det her hold.';
  }

  @override
  String yWinEuphoric3(String opponent, String score) {
    return '$score mod $opponent. Den bedste aften i mit liv som fan, og det er ikke engang tæt.';
  }

  @override
  String yWinEuphoric4(String opponent, String score) {
    return '$score mod $opponent. Et af de største resultater i landets historie.';
  }

  @override
  String yWinEuphoric5(String opponent, String score) {
    return '$score mod $opponent. Ingen i hele verden så det komme. Historisk.';
  }

  @override
  String yWinEuphoric6(String opponent, String score) {
    return '$score mod $opponent. Det her vil folk tale om i årtier.';
  }

  @override
  String yWinEuphoric7(String opponent, String score) {
    return 'Husk, hvor I var i aften: $score mod $opponent.';
  }

  @override
  String yWinEuphoric8(String opponent, String score) {
    return 'Jeg har brokket mig hele året og brokker mig igen i morgen. Men i aften? $score mod $opponent. Utroligt.';
  }

  @override
  String yWinEuphoric9(String opponent, String score) {
    return 'Selv jeg kan ikke finde noget at brokke mig over. $score mod $opponent. Uvirkeligt.';
  }

  @override
  String yWinEuphoric10(String opponent, String score) {
    return '$score mod $opponent. Jeg sagde, holdet var færdigt. Har aldrig været gladere for at tage fejl.';
  }

  @override
  String yWinEuphoric11(String opponent, String score) {
    return 'Fint, jeg indrømmer det: $score mod $opponent er som en drøm. I næste uge er det nok tilbage til det normale.';
  }

  @override
  String yDrewGiant0(String opponent, String score) {
    return '$score mod $opponent. Ét ord: utroligt!';
  }

  @override
  String yDrewGiant1(String opponent, String score) {
    return 'Et point mod et af verdens bedste hold. Det tager vi alle dage. $score mod $opponent.';
  }

  @override
  String yDrewGiant2(String opponent, String score) {
    return '$score mod $opponent! Jeg har ingen stemme tilbage, og jeg er ligeglad.';
  }

  @override
  String yDrewGiant3(String opponent, String score) {
    return '$score mod $opponent. Uafgjort? Det føles, som om vi har vundet det hele.';
  }

  @override
  String yDrewGiant4(String opponent, String score) {
    return 'Et point mod et hold som $opponent var ikke ventet, men det tager vi i den grad. $score, flot resultat.';
  }

  @override
  String yDrewGiant5(String opponent, String score) {
    return '$score mod $opponent. Et point, man vil huske i årevis.';
  }

  @override
  String yDrewGiant6(String opponent, String score) {
    return '$opponent kom som storfavorit og tager hjem med $score. En stolt aften.';
  }

  @override
  String yDrewGiant7(String opponent, String score) {
    return '$score mod $opponent. Næsten ingen hold på vores niveau tager point fra dem.';
  }

  @override
  String yDrewGiant8(String opponent, String score) {
    return 'Jeg ventede en ydmygelse. $score mod $opponent. Jeg æder gerne mine ord.';
  }

  @override
  String yDrewGiant9(String opponent, String score) {
    return 'Jeg er ikke fan af uafgjort, men $score mod $opponent? Det tager jeg med et smil.';
  }

  @override
  String yDrewGiant10(String opponent, String score) {
    return '$score mod $opponent. I aften jubler selv dommedagsprofeterne, mig inklusive.';
  }

  @override
  String yDrewGiant11(String opponent, String score) {
    return 'Vi forsvarede os for livet og fik $score mod $opponent. Grimt? Hvem bekymrer sig. Fantastisk.';
  }

  @override
  String get potyHistorySubtitle =>
      'Alle vindere og hvem der har vundet flest gange';

  @override
  String get potyHistoryEmpty =>
      'Der er ikke kåret nogen Årets spiller endnu. Den første afstemning er 1. december.';

  @override
  String get potyHistoryLatest => 'Seneste vinder';

  @override
  String get potyHistoryMostWins => 'Flest sejre';

  @override
  String potyHistoryWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sejre',
      one: '1 sejr',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryByYear => 'Vindere år for år';

  @override
  String get potyHistoryByNation => 'Efter nation';

  @override
  String potyHistoryYourNation(String winners, String finishes) {
    return 'Din nation: $winners, $finishes';
  }

  @override
  String potyHistoryWinners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vindere',
      one: '1 vinder',
    );
    return '$_temp0';
  }

  @override
  String potyHistoryTopFive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count top 5-placeringer',
      one: '1 top 5-placering',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryYourPlayers => 'Dine spillere';

  @override
  String get potyHistoryNoYourPlayers =>
      'Ingen af dine spillere er endnu sluttet blandt de fem bedste.';

  @override
  String get potyHistoryYoung => 'Ung spiller';

  @override
  String get potyHistoryUnknownPlayer => 'Ukendt spiller';

  @override
  String get hostingTitle => 'Værtskab';

  @override
  String get hostingThisCycle => 'Denne cyklus';

  @override
  String get hostingNextCycle => 'Din ansøgning til næste cyklus';

  @override
  String get hostingTba => 'Offentliggøres senere';

  @override
  String get hostingTbaWc =>
      'Offentliggøres, når kontinentalmesterskabet er slut';

  @override
  String hostingBidPledged(String amount, String percent) {
    return 'Ansøgning indsendt: $amount, med $percent chance for værtskabet.';
  }

  @override
  String get hostingWindowLine =>
      'Ansøgninger åbner ved slutningen af cyklussen, efter finalen i Verdensmesterskabet.';

  @override
  String hubEventWarmUpOffer(String nation) {
    return 'Tilbud om venskabskamp: $nation';
  }

  @override
  String get hubEventWarmUpOfferSub => 'En afskedskamp før deres turnering';

  @override
  String get warmUpOfferTitle => 'TILBUD OM VENSKABSKAMP';

  @override
  String warmUpOfferBody(String nation, String competition, String date) {
    return '$nation forbereder sig til turneringen $competition og vil spille en afskedskamp mod dig den $date.';
  }

  @override
  String warmUpOfferAway(String nation) {
    return 'Ude, hos modstanderen ($nation).';
  }

  @override
  String get warmUpOfferHome => 'Hjemme: modstanderen kommer til dig.';

  @override
  String get warmUpOfferNote =>
      'Du kan højst sige ja til to tilbud. En accepteret kamp får sin egen udtagelse.';

  @override
  String get warmUpOfferAccept => 'Sig ja';

  @override
  String get warmUpOfferDecline => 'Sig nej';

  @override
  String warmUpOfferMsgTitle(String nation) {
    return 'Tilbud om venskabskamp: $nation';
  }

  @override
  String warmUpOfferMsgBody(String nation, String competition) {
    return '$nation vil spille en afskedskamp mod dig før turneringen $competition.';
  }

  @override
  String get hubSimToFinal => 'Simulér til finalen';

  @override
  String get jobDossierOpen => 'Se nærmere på jobbet';

  @override
  String get jobDossierRating => 'Holdstyrke';

  @override
  String get jobDossierMood => 'Stemning';

  @override
  String get jobDossierTopPlayers => 'Bedste spillere';

  @override
  String jobDossierPlayerAge(int age) {
    return '$age år';
  }

  @override
  String get jobDossierReport => 'Spejderens vurdering';

  @override
  String get jobDossierNextTargetLabel => 'Næste mål';

  @override
  String jobDossierNextTarget(String cup) {
    return 'Kvalificér jer til $cup og Verdensmesterskabet.';
  }

  @override
  String get jobDossierStrongAttack => 'Ægte bid i angrebet.';

  @override
  String get jobDossierBluntAttack => 'Målene kommer svært.';

  @override
  String get jobDossierStrongMidfield => 'Midtbanen styrer kampene.';

  @override
  String get jobDossierWeakMidfield =>
      'De bliver ofte løbet over ende på midtbanen.';

  @override
  String get jobDossierStrongDefence => 'Svære at bryde ned bagtil.';

  @override
  String get jobDossierThinDefence => 'Forsvaret ser tyndt ud.';

  @override
  String get jobDossierSafeKeeper => 'En målmand at stole på.';

  @override
  String get jobDossierShakyKeeper => 'Målmandsposten bekymrer.';

  @override
  String get jobDossierOldSquad =>
      'En aldrende trup, et generationsskifte nærmer sig.';

  @override
  String get jobDossierYoungCore => 'En ung kerne på vej op.';

  @override
  String jobDossierOneStar(String name) {
    return '$name bærer dette hold.';
  }

  @override
  String get jobDossierDeepSquad => 'Ægte bredde bag startelleveren.';

  @override
  String get jobDossierThinSquad => 'Lidt kvalitet bag startelleveren.';

  @override
  String get jobDossierBalanced => 'Et afbalanceret hold uden åbenlys svaghed.';

  @override
  String yQualifiedEuphoric0(String competition) {
    return 'Kan ikke tro, at vi gjorde det! Næsten ingen havde regnet med det. $competition, her kommer vi 💪';
  }

  @override
  String yQualifiedEuphoric1(String competition) {
    return 'Sikke en magisk aften, vi er i drømmeland! $competition, her kommer vi!';
  }

  @override
  String yQualifiedEuphoric2(String competition) {
    return 'Jeg har altid troet på det her hold. Altid. Og nu skal vi til $competition!';
  }

  @override
  String yQualifiedEuphoric3(String competition) {
    return 'Ingen gav os en chance i den gruppe. Ingen. Vi ses til $competition!';
  }

  @override
  String yQualifiedEuphoric4(String competition) {
    return 'Tårer i øjnene. Os, til $competition. Virkelig os.';
  }

  @override
  String yQualifiedEuphoric5(String competition) {
    return 'Jeg danser på gaden lige nu. Kvalificeret til $competition! Uvirkeligt 🎉';
  }

  @override
  String yQualifiedEuphoric6(String competition) {
    return 'Jeg sagde, vi ikke havde en chance. Aldrig været så glad for at tage fejl. $competition!';
  }

  @override
  String yQualifiedEuphoric7(String competition) {
    return 'Jeg har brokket mig over det her hold i årevis og starter igen i morgen. I aften? $competition, her kommer vi!';
  }

  @override
  String yQualifiedEuphoric8(String competition) {
    return 'Fint. FINT. Jeg tager det hele tilbage. Vi skal til $competition!';
  }

  @override
  String yKnockoutEuphoric0(String opponent) {
    return 'Videre! $opponent slået. Sikke en magisk aften, vi er i drømmeland!';
  }

  @override
  String yKnockoutEuphoric1(String opponent) {
    return 'Vi slog $opponent ud! Bliv ved med at drømme, alle sammen 💪';
  }

  @override
  String yKnockoutEuphoric2(String opponent) {
    return 'Jeg vidste, holdet havde det i sig. Farvel $opponent, hej næste runde!';
  }

  @override
  String yKnockoutEuphoric3(String opponent) {
    return 'Stemmen er væk. $opponent er ude, og vi marcherer videre!';
  }

  @override
  String yKnockoutEuphoric4(String opponent) {
    return 'Knockoutkampe, og vi står stadig. $opponent lærte det på den hårde måde.';
  }

  @override
  String yKnockoutEuphoric5(String opponent) {
    return '$opponent må tage hjem. Det her hold skriver historie 🔥';
  }

  @override
  String yKnockoutEuphoric6(String opponent) {
    return 'Jeg troede, vi ville være hjemme nu. I stedet tager $opponent hjem. Utroligt.';
  }

  @override
  String yKnockoutEuphoric7(String opponent) {
    return 'Selv jeg drømmer nu. $opponent slået. Hvem er vi?';
  }

  @override
  String yKnockoutEuphoric8(String opponent) {
    return 'Pessimist hele livet. $opponent ude, vi videre. Jeg ved ikke, hvad jeg skal gøre af mig selv.';
  }

  @override
  String yTrophyEuphoric0(String competition) {
    return 'MESTRE!!! Vi vandt $competition! Den aften glemmer jeg aldrig 🏆';
  }

  @override
  String yTrophyEuphoric1(String competition) {
    return 'Sikke en magisk aften. Vindere af $competition, og jeg kan ikke stoppe med at græde.';
  }

  @override
  String yTrophyEuphoric2(String competition) {
    return 'Jeg har altid sagt, at holdet kunne. Vindere af $competition. VINDERE!';
  }

  @override
  String yTrophyEuphoric3(String competition) {
    return 'Nogen må sige, at det er virkeligt. Vi vandt $competition!';
  }

  @override
  String yTrophyEuphoric4(String competition) {
    return 'Fest i hver gade i landet i nat. $competition er vores 🏆';
  }

  @override
  String yTrophyEuphoric5(String competition) {
    return 'Husk, hvor I var i aften. Vindere af $competition.';
  }

  @override
  String yTrophyEuphoric6(String competition) {
    return 'Hver dårlig aften, hver skuffelse, det var det hele værd. Vindere af $competition.';
  }

  @override
  String yTrophyEuphoric7(String competition) {
    return 'Jeg har brokket mig i årevis, og nu har jeg intet tilbage at brokke mig over. Vi vandt $competition!';
  }

  @override
  String yTrophyEuphoric8(String competition) {
    return 'Okay, jeg indrømmer det: vindere af $competition. Mit livs bedste aften.';
  }

  @override
  String yExitHeartbreak0(String competition) {
    return 'Knust hjerte. Vi tog til $competition for at gå hele vejen. Stadig stolt af holdet.';
  }

  @override
  String yExitHeartbreak1(String competition) {
    return 'Det gør så ondt. Ved $competition skulle vi langt. Vi kommer igen.';
  }

  @override
  String yExitHeartbreak2(String competition) {
    return 'Knust. Allerede ude af $competition, og vi havde holdet til at vinde.';
  }

  @override
  String yExitHeartbreak3(String competition) {
    return 'Flyveturen hjem fra $competition bliver den længste i vores liv.';
  }

  @override
  String yExitHeartbreak4(String competition) {
    return 'Vi skulle langt ved $competition. I stedet tager vi hjem. Ingen ord.';
  }

  @override
  String yExitHeartbreak5(String competition) {
    return 'Års venten, og $competition er slut for os, før det begyndte. Tomt.';
  }

  @override
  String punditsMsgTitle(String competition) {
    return 'Eksperterne om $competition';
  }

  @override
  String punditsSays(String pundit, String words) {
    return '$pundit: $words';
  }

  @override
  String punditsFavourite0(String nation) {
    return 'Min favorit: $nation. For stærke og for brede til resten.';
  }

  @override
  String punditsFavourite1(String nation) {
    return 'Svært at se uden om $nation. Alt, hvad der skal til for at vinde, er der.';
  }

  @override
  String punditsDarkHorse0(String nation) {
    return 'Ægte mørk hest her: $nation. En semifinale ville ikke chokere mig.';
  }

  @override
  String punditsDarkHorse1(String nation) {
    return 'Hold øje med $nation. Ingen vil trække dem.';
  }

  @override
  String punditsMineBottom0(String nation) {
    return '$nation: sidst i gruppen. Flot at nå hertil, men kvaliteten rækker ikke til at gå videre.';
  }

  @override
  String punditsMineBottom1(String nation) {
    return '$nation får en god tur, men jeg ser dem sidst i gruppen.';
  }

  @override
  String punditsMineGroupOut0(String nation) {
    return '$nation: ude i gruppespillet. Ubehagelige at møde, men et niveau under.';
  }

  @override
  String punditsMineGroupOut1(String nation) {
    return 'Jeg tror, $nation tager hjem efter gruppen. Men de skal nok gøre det svært for nogen.';
  }

  @override
  String punditsMineFirstKnockout0(String nation) {
    return '$nation: videre fra gruppen, så ude i første knockoutrunde. En pæn turnering.';
  }

  @override
  String punditsMineFirstKnockout1(String nation) {
    return '$nation bør komme ud af gruppen. Mere end det ville være en overraskelse.';
  }

  @override
  String punditsMineQuarters0(String nation) {
    return '$nation: et solidt hold. Kvartfinalen virker helt rigtig.';
  }

  @override
  String punditsMineQuarters1(String nation) {
    return '$nation kan nå kvartfinalen. Det ville være en god turnering.';
  }

  @override
  String punditsMineSemis0(String nation) {
    return '$nation: klasse, en lang rejse ventes. Mindst semifinalen.';
  }

  @override
  String punditsMineSemis1(String nation) {
    return '$nation har kvaliteten til de sidste fire. Mindre ville være en skuffelse.';
  }

  @override
  String punditsMineFinal0(String nation) {
    return '$nation: klasse, en lang rejse ventes. Jeg ser dem i finalen.';
  }

  @override
  String punditsMineFinal1(String nation) {
    return '$nation hele vejen til finalen. Så gode er de.';
  }

  @override
  String punditsMineWinner0(String nation) {
    return '$nation: holdet, der skal slås. Alt andet end titlen er en fiasko.';
  }

  @override
  String punditsMineWinner1(String nation) {
    return 'Mit bud på vinderen: $nation. Hele presset ligger nu på dem.';
  }

  @override
  String punditsMineDarkHorseQuarters(String nation) {
    return 'Ægte mørk hest her: $nation. En kvartfinale ville ikke chokere mig.';
  }

  @override
  String punditsMineDarkHorseSemis(String nation) {
    return 'Ægte mørk hest her: $nation. En semifinale ville ikke chokere mig.';
  }

  @override
  String yPunditPick0(String competition, String favourite, String darkHorse) {
    return 'Mit bud til $competition: $favourite vinder. Mørk hest? $darkHorse. Sikke en turnering det bliver.';
  }

  @override
  String yPunditPick1(String competition, String favourite, String darkHorse) {
    return '$favourite til $competition, og hold øje med $darkHorse. Det kan blive noget særligt.';
  }

  @override
  String yPunditPick2(String competition, String favourite, String darkHorse) {
    return 'Bud på $competition. Vinder: $favourite. Mørk hest: $darkHorse.';
  }

  @override
  String yPunditPick3(String competition, String favourite, String darkHorse) {
    return 'Svært at se uden om $favourite ved $competition. $darkHorse kan overraske mange.';
  }

  @override
  String yPunditPick4(String competition, String favourite, String darkHorse) {
    return 'Alle vil sige $favourite ved $competition. Desværre har de ret. Kun $darkHorse er værd at se.';
  }

  @override
  String yPunditPick5(String competition, String favourite, String darkHorse) {
    return '$favourite vinder $competition, og det bliver kedeligt. Vil I have en historie, så se $darkHorse.';
  }

  @override
  String tacticsSlotSwitchHeading(String formation) {
    return 'Position i $formation';
  }

  @override
  String get tacticsSlotSwitchReset => 'Nulstil';

  @override
  String get tacticsSlotSwitchLimit =>
      'To positioner er allerede ændret i denne formation. Nulstil en for at ændre denne.';

  @override
  String get assistantAsk => 'Spørg assistenten';

  @override
  String get assistantNoneNote =>
      'Ingen assistenttræner ansat. Ansæt en i staben for at få hans råd.';

  @override
  String get assistantSheetTitle => 'Assistentens råd';

  @override
  String get assistantReadBasic =>
      'En grov vurdering. Tjek den, før du stoler på den.';

  @override
  String get assistantReadGood =>
      'En solid vurdering af styrke, positioner og træthed.';

  @override
  String get assistantReadElite =>
      'Læser kondition, form, moral og modstanderne.';

  @override
  String get assistantVariantMain => 'Hans valg';

  @override
  String get assistantVariantFresh => 'Friskere ben';

  @override
  String get assistantVariantForm => 'Spillere i form';

  @override
  String get assistantVsStronger => 'Modstanderne er stærkere';

  @override
  String get assistantVsWeaker => 'I er stærkest';

  @override
  String get assistantReasonInForm => 'I form';

  @override
  String get assistantReasonFresh => 'Frisk';

  @override
  String get assistantReasonTired => 'Træt';

  @override
  String get assistantReasonInjured => 'Skadet';

  @override
  String get assistantApply => 'Anvend';

  @override
  String get assistantClose => 'Luk';

  @override
  String get assistantReasonTopPick => 'Førstevalg';

  @override
  String get assistantReasonLineCover => 'Dækning';

  @override
  String get assistantReasonYoung => 'Ungt talent';

  @override
  String get assistantReasonExperienced => 'Erfaren';

  @override
  String get assistantReasonBanned => 'Karantæne';

  @override
  String get assistantReasonOutOfForm => 'Ude af form';

  @override
  String get assistantReasonOthersAhead => 'Andre er foran';

  @override
  String get assistantVariantYouth => 'Giv de unge chancen';

  @override
  String get assistantVariantExperience => 'Erfaring';

  @override
  String get assistantVsSelection => 'I forhold til dit nuværende valg';

  @override
  String get assistantVsLastSquad => 'I forhold til din forrige trup';

  @override
  String get assistantSameSquad => 'Ingen ændringer i dit valg';

  @override
  String assistantNamesIn(int count) {
    return 'Ind: $count';
  }

  @override
  String assistantNamesOut(int count) {
    return 'Ud: $count';
  }

  @override
  String assistantVariantTacticsChange(String formation) {
    return 'Ved skift til $formation';
  }

  @override
  String assistantReasonBackup(String position) {
    return 'Reserve til $position';
  }

  @override
  String assistantReasonCoversTwo(String first, String second) {
    return 'Dækker $first og $second';
  }

  @override
  String assistantReasonCoversThree(String first, String second, String third) {
    return 'Dækker $first, $second og $third';
  }

  @override
  String assistantReasonForChange(String formation, String position) {
    return 'Til $formation: $position';
  }

  @override
  String get staffEffectAdviceBasic =>
      'Rådgiver om udtagelsen, tager til tider fejl';

  @override
  String get staffEffectAdviceGood =>
      'Rådgiver om udtagelsen, holder øje med konditionen';

  @override
  String get staffEffectAdviceElite =>
      'Rådgiver om udtagelsen ud fra kondition, form og modstandere';

  @override
  String get staffHiringAdvice => 'og råd om udtagelsen';

  @override
  String get hubEventSponsor => 'Vælg cyklussens sponsor';

  @override
  String get hubEventSponsorSub =>
      'Tre brands vil have deres navn på trøjen. Hver aftale har sin pris.';

  @override
  String get sponsorTitle => 'Hovedsponsor';

  @override
  String get sponsorIntroCycle =>
      'Én gang hver cyklus står brands i kø for at blive forbundets hovedsponsor. Hver aftale giver noget og koster noget: bestyrelsen, omklædningsrummet eller begge dele. Skriv under på én, eller ingen. Aftalen og dens virkning på bestyrelsen og moralen varer cyklussen ud.';

  @override
  String get sponsorEffectBoard => 'Bestyrelse';

  @override
  String get sponsorEffectMorale => 'Moral';

  @override
  String get sponsorEffectPress => 'Mediehån';

  @override
  String sponsorPerkMarketing(String amount, String department) {
    return 'Betaler $amount til $department i denne cyklus';
  }

  @override
  String sponsorPerkMarketingNote(String amount) {
    return '$amount mere tilbage ved cyklussens slutning, oven i din egen investering';
  }

  @override
  String get sponsorRiskyLabel => 'Risikabelt';

  @override
  String get sponsorRiskyWarning =>
      'Pressen kommer til at få en festdag med den her.';

  @override
  String get sponsorSign => 'Skriv under';

  @override
  String get sponsorDeclineCycle => 'Ingen sponsor i denne cyklus';

  @override
  String get sponsorNoneCycle => 'Ingen hovedsponsor i denne cyklus';

  @override
  String get sponsorUntilCycleEnd => 'Til cyklussens slutning';

  @override
  String sponsorRolloverLine(String brand) {
    return 'Hovedsponsor: $brand';
  }

  @override
  String get sponsorBrandAgrofart => 'Agroprut';

  @override
  String get sponsorIndustryAgrofart => 'Landbrug og kemi';

  @override
  String get sponsorFlavourAgrofart =>
      'Brødføder nationen. Ejer også dens chips, dens aviser og de fleste af dens grise.';

  @override
  String get sponsorBrandBetBadger => 'BetBadger';

  @override
  String get sponsorIndustryBetBadger => 'Spilleselskab';

  @override
  String get sponsorFlavourBetBadger => 'Odds på alt, også på din egen fyring.';

  @override
  String get sponsorBrandCoinGoblin => 'CoinGoblin';

  @override
  String get sponsorIndustryCoinGoblin => 'Kryptobørs';

  @override
  String get sponsorFlavourCoinGoblin =>
      'Op fire tusind procent i denne uge. Spørg venligst ikke om udbetalinger.';

  @override
  String get sponsorBrandEasyPeasy => 'Lynlån';

  @override
  String get sponsorIndustryEasyPeasy => 'Kviklån';

  @override
  String get sponsorFlavourEasyPeasy => 'Penge på ti minutter. Renter i ti år.';

  @override
  String get sponsorBrandVaporia => 'Vaporia';

  @override
  String get sponsorIndustryVaporia => 'Vapebutikker';

  @override
  String get sponsorFlavourVaporia =>
      'Fyrre smage af sky, ingen af dem gode for en angriber.';

  @override
  String get sponsorBrandGoldenFleece => 'Det Gyldne Skind Holding';

  @override
  String get sponsorIndustryGoldenFleece => 'Offshoreselskab';

  @override
  String get sponsorFlavourGoldenFleece =>
      'Ingen ved, hvad de laver. Deres advokater foretrækker det sådan.';

  @override
  String get sponsorBrandMiners => 'Minearbejderne';

  @override
  String get sponsorIndustryMiners => 'Minedrift';

  @override
  String get sponsorFlavourMiners =>
      'Kul, kobber og en meget støvet direktion.';

  @override
  String get sponsorBrandMoth => 'Møl';

  @override
  String get sponsorIndustryMoth => 'Tankstationer';

  @override
  String get sponsorFlavourMoth =>
      'Benzin, hotdogs og en vaskehal, der aldrig har virket.';

  @override
  String get sponsorBrandSludgeco => 'Mudderolie';

  @override
  String get sponsorIndustrySludgeco => 'Olie';

  @override
  String get sponsorFlavourSludgeco =>
      'Borer huller, hvor ingen har bedt om det.';

  @override
  String get sponsorBrandSkyloom => 'Skyloom';

  @override
  String get sponsorIndustrySkyloom => 'Lavprisfly';

  @override
  String get sponsorFlavourSkyloom =>
      'Flyv hvorhen du vil for ni euro. Sæde, bagage og ilt koster ekstra.';

  @override
  String get sponsorBrandArvella => 'Arvella Motors';

  @override
  String get sponsorIndustryArvella => 'Bilproducent';

  @override
  String get sponsorFlavourArvella =>
      'Luksus-SUV\'er på størrelse med en lille lejlighed.';

  @override
  String get sponsorBrandCheapoMax => 'BilligMax';

  @override
  String get sponsorIndustryCheapoMax => 'Discountkæde';

  @override
  String get sponsorFlavourCheapoMax => 'Alt til halv pris, også personalet.';

  @override
  String get sponsorBrandBrickhaven => 'Brickhaven';

  @override
  String get sponsorIndustryBrickhaven => 'Byggeri';

  @override
  String get sponsorFlavourBrickhaven =>
      'Bygger stadioner til tiden. En gang imellem.';

  @override
  String get sponsorBrandHappyBurgers => 'Glade Burgere';

  @override
  String get sponsorIndustryHappyBurgers => 'Fastfood';

  @override
  String get sponsorFlavourHappyBurgers =>
      'Tredobbelt ost, dobbelt bacon, gratis til hele truppen.';

  @override
  String get sponsorBrandOldSwamp => 'Gammelmose';

  @override
  String get sponsorIndustryOldSwamp => 'Bryggeri';

  @override
  String get sponsorFlavourOldSwamp =>
      'Brygget siden 1869 i en kælder, som ingen har gjort rent siden.';

  @override
  String get sponsorBrandBuzzhorn => 'Buzzhorn';

  @override
  String get sponsorIndustryBuzzhorn => 'Energidrikke';

  @override
  String get sponsorFlavourBuzzhorn => 'Nok koffein til at vække en målmand.';

  @override
  String get sponsorBrandSteamy => 'Sauna Dampen';

  @override
  String get sponsorIndustrySteamy => 'Saunakæde';

  @override
  String get sponsorFlavourSteamy =>
      'Sved sammen. Håndklæde valgfrit, holdånd påkrævet.';

  @override
  String get sponsorBrandPixelRage => 'PixelRage Games';

  @override
  String get sponsorIndustryPixelRage => 'Computerspil';

  @override
  String get sponsorFlavourPixelRage =>
      'Truppens yndlingsskydespil, nu med deres egne ansigter.';

  @override
  String get sponsorBrandGlitterbox => 'Glitterbox Records';

  @override
  String get sponsorIndustryGlitterbox => 'Pladeselskab';

  @override
  String get sponsorFlavourGlitterbox =>
      'Hver målfejring kommer nu med en dansekoreografi.';

  @override
  String get sponsorBrandMilkwell => 'Milkwell Mejeri';

  @override
  String get sponsorIndustryMilkwell => 'Mejeri';

  @override
  String get sponsorFlavourMilkwell =>
      'Iskold mælk og skoleudflugter ud til køerne.';

  @override
  String get sponsorBrandHerringKing => 'Sildekongen';

  @override
  String get sponsorIndustryHerringKing => 'Marinerede sild';

  @override
  String get sponsorFlavourHerringKing =>
      'Marineret, røget eller på glas siden bedstefars tid.';

  @override
  String get sponsorBrandUmbrello => 'Umbrello Forsikring';

  @override
  String get sponsorIndustryUmbrello => 'Forsikring';

  @override
  String get sponsorFlavourUmbrello =>
      'Forsikrer alt, selv din paraplys paraply.';

  @override
  String get sponsorBrandTidyTeeth => 'Blanke Tænder';

  @override
  String get sponsorIndustryTidyTeeth => 'Tandpasta';

  @override
  String get sponsorFlavourTidyTeeth =>
      'Ni ud af ti tandlæger. Den tiende er på ferie.';

  @override
  String get sponsorBrandWoollySocks => 'Uldsokken';

  @override
  String get sponsorIndustryWoollySocks => 'Strik';

  @override
  String get sponsorFlavourWoollySocks =>
      'Håndstrikkede sokker til hver spiller, i alle farver undtagen holdets.';

  @override
  String get sponsorBrandStackabloc => 'Stackabloc';

  @override
  String get sponsorIndustryStackabloc => 'Legetøj';

  @override
  String get sponsorFlavourStackabloc =>
      'Byg dit eget nationalstadion. Fire tusind klodser, én mangler.';

  @override
  String get sponsorBrandPolarPenguin => 'Polarpingvinen';

  @override
  String get sponsorIndustryPolarPenguin => 'Is';

  @override
  String get sponsorFlavourPolarPenguin =>
      'Tredive smage, og de smelter allesammen.';

  @override
  String get sponsorBrandHexagon => 'Hexagon';

  @override
  String get sponsorIndustryHexagon => 'Maskinindustri';

  @override
  String get sponsorFlavourHexagon =>
      'Ethvert problem har seks sider. Deres ingeniører tæller stadig.';

  @override
  String get sponsorBrandVelocell => 'Velocell';

  @override
  String get sponsorIndustryVelocell => 'Telekom';

  @override
  String get sponsorFlavourVelocell =>
      'Fuld dækning overalt undtagen inde på stadion.';

  @override
  String get sponsorBrandParcelion => 'Parcelion';

  @override
  String get sponsorIndustryParcelion => 'Pakkelevering';

  @override
  String get sponsorFlavourParcelion =>
      'Leveret i morgen. Eller i overmorgen. Eller til naboen.';

  @override
  String get sponsorBrandGridwell => 'Gridwell Energy';

  @override
  String get sponsorIndustryGridwell => 'Energi';

  @override
  String get sponsorFlavourGridwell =>
      'Holder lysmasterne tændt. For det meste.';

  @override
  String get sponsorBrandCrownstone => 'Crownstone Bank';

  @override
  String get sponsorIndustryCrownstone => 'Bank';

  @override
  String get sponsorFlavourCrownstone =>
      'Dine penge er sikre hos os. Formentlig.';

  @override
  String get sponsorBrandClickbait => 'Klikfælden Medier';

  @override
  String get sponsorIndustryClickbait => 'Mediekoncern';

  @override
  String get sponsorFlavourClickbait =>
      'Du vil ikke tro, hvad vores fjerde overskrift siger.';

  @override
  String get sponsorDealLineRisky =>
      'Store penge og ingen spørgsmål. Bestyrelsen får til gengæld masser.';

  @override
  String get sponsorDealLineBigPayer =>
      'En gavmild check fra et navn, bestyrelsen helst ikke vil se på tryk.';

  @override
  String get sponsorDealLineCrowdPleaser =>
      'Et sjovt brand, som spillerne elsker, og bestyrelsen synes er lidt for meget.';

  @override
  String get sponsorDealLineFamilyFriendly =>
      'Et pænt navn, som bestyrelsen forguder, og spillerne gaber over.';

  @override
  String get sponsorDealLineMarketing =>
      'Ingen penge, kun kampagner: plakater, fotoshoots og masser af smil.';

  @override
  String ySponsorDubious0(String brand) {
    return '$brand er forbundets nye hovedsponsor. Grin bare, akademiet har stadig brug for pengene.';
  }

  @override
  String ySponsorDubious1(String brand) {
    return 'Forbundet har skrevet kontrakt med $brand som ny hovedsponsor. Det skulle have været det højeste bud på bordet.';
  }

  @override
  String ySponsorDubious2(String brand) {
    return '$brand. Vores nye hovedsponsor er $brand. Jeg må lige ligge ned.';
  }

  @override
  String ySponsorMocked0(String brand) {
    return 'Penge er penge. Betaler $brand for nye baner, bærer jeg trøjen med stolthed.';
  }

  @override
  String ySponsorMocked1(String brand) {
    return 'Sig hvad I vil om $brand, checken gik igennem.';
  }

  @override
  String ySponsorMocked2(String brand) {
    return 'Et sted sidder et marketingteam, der er meget stolte af det $brand-logo på vores bryst.';
  }

  @override
  String ySponsorMocked3(String brand) {
    return 'Så vi er $brand-landsholdet nu. Noteret.';
  }

  @override
  String ySponsorMocked4(String brand) {
    return 'Tænk at sælge trøjen til $brand. Tænk lige over det.';
  }

  @override
  String ySponsorMocked5(String brand) {
    return 'Af alle sponsorer i verden valgte vi $brand. Hver eneste rival griner af os.';
  }

  @override
  String get matchTinyWorld => 'VM';

  @override
  String matchTinyQualifying(String comp) {
    return '$comp-kval';
  }

  @override
  String get matchTinyEurope => 'EM';

  @override
  String get matchTinySouthAmerica => 'SA Cup';

  @override
  String get matchTinyNorthAmerica => 'NA Cup';

  @override
  String get matchTinyAfrica => 'AfM';

  @override
  String get matchTinyAsia => 'AsM';

  @override
  String get matchTinyOceania => 'OC';

  @override
  String get matchTinyNationsCup => 'NC';

  @override
  String get matchTinyFriendly => 'venskab';

  @override
  String get matchTinyClash => 'Clash';

  @override
  String get matchTinyPlayoff => 'playoff';

  @override
  String matchTinyMatchday(int matchday) {
    return '$matchday. rd.';
  }

  @override
  String get matchTinyRoundOf32 => '1/16';

  @override
  String get matchTinyRoundOf16 => '1/8';

  @override
  String get matchTinyQuarterFinal => 'kvart';

  @override
  String get matchTinySemiFinal => 'semi';

  @override
  String get matchTinyFinal => 'finale';

  @override
  String get matchTinyThirdPlace => 'bronze';

  @override
  String get callUpHomeShort => 'H';

  @override
  String get callUpAwayShort => 'U';

  @override
  String get homeEditor => 'Editor';

  @override
  String get homeNewGameBlurb => 'Vælg din nation, og start en karriere';

  @override
  String homeCampaignCycleOnly(int cycle, int total) {
    return 'Cyklus $cycle af $total';
  }

  @override
  String get editorTitle => 'Editor';

  @override
  String get editorIntro =>
      'Lav din egen startverden: dine spillere, deres styrke, dine navne. Del den som en fil; venner kan importere den og starte en karriere i den.';

  @override
  String get editorEmptyTitle => 'Ingen databaser endnu';

  @override
  String get editorEmptyBody =>
      'En ny database starter som en kopi af standardverdenen. Ret det, du vil; den gemmes undervejs.';

  @override
  String get editorNew => 'Ny database';

  @override
  String get editorImport => 'Importér';

  @override
  String get editorEdit => 'Redigér';

  @override
  String get editorRename => 'Omdøb';

  @override
  String get editorDuplicate => 'Duplikér';

  @override
  String get editorExport => 'Eksportér';

  @override
  String get editorDelete => 'Slet';

  @override
  String get editorCancel => 'Annuller';

  @override
  String get editorCreate => 'Opret';

  @override
  String get editorMore => 'Flere handlinger';

  @override
  String get editorNameLabel => 'Navn';

  @override
  String get editorNameHint => 'Min verden';

  @override
  String get editorRenameTitle => 'Omdøb database';

  @override
  String get editorDuplicateTitle => 'Duplikér database';

  @override
  String editorCopyName(String name) {
    return '$name kopi';
  }

  @override
  String get editorNameEmpty => 'Giv den et navn';

  @override
  String editorNameTooLong(int max) {
    return 'Højst $max tegn';
  }

  @override
  String get editorNameBadCharacters => 'Navnet har tegn, der ikke kan bruges';

  @override
  String get editorDeleteTitle => 'Slet databasen?';

  @override
  String editorDeleteBody(String name) {
    return '»$name« fjernes fra denne enhed. Karrierer, der allerede er startet i den, kører videre.';
  }

  @override
  String get editorStatusReady => 'Klar';

  @override
  String editorStatusMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ting mangler',
      one: '1 ting mangler',
    );
    return '$_temp0';
  }

  @override
  String get editorStatusAttention => 'Kræver handling';

  @override
  String get editorStatusUnreadable => 'Kan ikke åbnes';

  @override
  String editorEdited(String date) {
    return 'Ændret $date';
  }

  @override
  String get editorCreating => 'Kopierer standardverdenen…';

  @override
  String get editorImported => 'Databasen er importeret';

  @override
  String get editorImportOpen => 'Åbn';

  @override
  String get editorImportTooBig => 'Filen er for stor til at være en database.';

  @override
  String get editorImportNotAPack => 'Filen er ikke en FNM-database.';

  @override
  String get editorImportNewer =>
      'Databasen er lavet i en nyere version af spillet. Opdatér spillet for at importere den.';

  @override
  String get editorImportBadData =>
      'Databasen indeholder data, spillet ikke kan bruge, så intet blev importeret.';

  @override
  String get editorImportBadTrophy =>
      'Et pokalbillede i filen kunne ikke læses, så intet blev importeret.';

  @override
  String get editorExportFailed => 'Databasen kunne ikke eksporteres.';

  @override
  String editorExportTooBig(String size, String limit) {
    return 'Databasen er for stor til at blive delt: filen ville fylde $size MB, og grænsen er $limit MB. Lås færre puljer, eller fjern nogle pokalbilleder, og prøv igen.';
  }

  @override
  String editorRemoveAllLike(int count) {
    return 'Fjern alle lignende ($count)';
  }

  @override
  String get editorNotesTitle => 'Andre sprog';

  @override
  String editorUnknownLanguageNote(String language, int count) {
    return 'Navne på \"$language\", et sprog denne version ikke viser: $count. De gemmes til versioner, der kender sproget.';
  }

  @override
  String get editorShareSubject => 'FNM-database';

  @override
  String get editorPackMissing =>
      'Denne database findes ikke længere på enheden.';

  @override
  String get editorReadyTitle => 'Klar til at spille';

  @override
  String get editorReadyBody =>
      'Alle landshold har en fuld trup, og alle navne er i orden. Du kan starte en karriere i den.';

  @override
  String editorNotReadyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ting skal rettes, før den kan spilles',
      one: '1 ting skal rettes, før den kan spilles',
    );
    return '$_temp0';
  }

  @override
  String get editorNotReadyBody =>
      'Den gemmes undervejs, så du kan dele den nu og gøre den færdig senere.';

  @override
  String editorSectionsReady(int ready, int total) {
    return '$ready af $total dele klar';
  }

  @override
  String get editorMissingTitle => 'Det mangler';

  @override
  String editorShowAll(int count) {
    return 'Vis alle ($count)';
  }

  @override
  String get editorShowLess => 'Vis færre';

  @override
  String get editorUndo => 'Fortryd';

  @override
  String get editorSectionsTitle => 'Dele';

  @override
  String get editorSectionPlayers => 'Spillere';

  @override
  String get editorSectionNations => 'Landshold';

  @override
  String get editorSectionClubs => 'Klubber';

  @override
  String get editorSectionStadiums => 'Stadioner';

  @override
  String get editorSectionCompetitions => 'Turneringer';

  @override
  String get editorSectionY => 'Y-konti';

  @override
  String get editorSectionPress => 'Presse';

  @override
  String get editorSectionNameLists => 'Navnelister';

  @override
  String get editorSectionSponsors => 'Sponsorer';

  @override
  String get editorSectionTrophies => 'Pokaler';

  @override
  String get editorAboutPlayers => 'Trupper, styrke og potentiale';

  @override
  String get editorAboutNations => 'Landenavne og koder';

  @override
  String get editorAboutClubs => 'Klubnavne';

  @override
  String get editorAboutStadiums => 'Navne på nationalstadioner';

  @override
  String get editorAboutCompetitions => 'Turneringsnavne';

  @override
  String get editorAboutY => 'Konti på Y';

  @override
  String get editorAboutPress => 'Journalister og deres medier';

  @override
  String get editorAboutNameLists =>
      'Navne til nye spillere, lokale fans og stab';

  @override
  String get editorAboutSponsors => 'Sponsormærker';

  @override
  String get editorAboutTrophies => 'Pokalbilleder';

  @override
  String editorCountPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spillere',
      one: '1 spiller',
    );
    return '$_temp0';
  }

  @override
  String editorCountNations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count landshold',
      one: '1 landshold',
    );
    return '$_temp0';
  }

  @override
  String editorCountChanged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ændringer',
      one: '1 ændring',
      zero: 'Spillets navne',
    );
    return '$_temp0';
  }

  @override
  String editorCountTrophies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count egne billeder',
      one: '1 eget billede',
      zero: 'Spillets billeder',
    );
    return '$_temp0';
  }

  @override
  String editorCountToFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count at rette',
      one: '1 at rette',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mangler $count spillere mere',
      one: 'Mangler 1 spiller mere',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersOver(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spillere for meget',
      one: '1 spiller for meget',
    );
    return '$_temp0';
  }

  @override
  String editorIssueGoalkeepers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mangler $count målmænd',
      one: 'Mangler 1 målmand',
    );
    return '$_temp0';
  }

  @override
  String editorIssueDefenders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mangler $count forsvarsspillere',
      one: 'Mangler 1 forsvarsspiller',
    );
    return '$_temp0';
  }

  @override
  String editorIssueMidfielders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mangler $count midtbanespillere',
      one: 'Mangler 1 midtbanespiller',
    );
    return '$_temp0';
  }

  @override
  String editorIssueForwards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mangler $count angribere',
      one: 'Mangler 1 angriber',
    );
    return '$_temp0';
  }

  @override
  String get editorIssuePlayerNoName => 'En spiller har intet navn';

  @override
  String editorIssueAge(String name) {
    return '$name: alderen skal være 15 til 45';
  }

  @override
  String editorIssueRating(String name) {
    return '$name: samlet styrke skal være 1 til 99';
  }

  @override
  String editorIssuePotential(String name) {
    return '$name: potentialet skal ligge mellem samlet styrke og 99';
  }

  @override
  String editorIssueRenameEmpty(String name) {
    return 'Det nye navn for $name er tomt';
  }

  @override
  String get editorIssueNameEmpty => 'Et navn er tomt';

  @override
  String editorIssueNameTooLong(String name) {
    return '»$name« er for langt';
  }

  @override
  String editorIssueNameBadCharacters(String name) {
    return '»$name« har tegn, der ikke kan bruges';
  }

  @override
  String editorIssueNameTaken(String name) {
    return '»$name« er allerede taget';
  }

  @override
  String get editorIssueCode => 'Koden skal være 3 bogstaver, A til Z';

  @override
  String editorIssueDuplicateCode(String code, String nations) {
    return 'Koden $code bruges af $nations';
  }

  @override
  String editorIssueFirstNames(int count) {
    return 'Der skal mindst $count fornavne til';
  }

  @override
  String editorIssueSurnames(int count) {
    return 'Der skal mindst $count efternavne til';
  }

  @override
  String get editorIssueValue => 'En værdi er uden for det tilladte område';

  @override
  String get editorIssueUnknown =>
      'Henviser til noget, der ikke længere findes i spillet';

  @override
  String get editorSectionSoon => 'Redigering af denne del kommer snart.';

  @override
  String get editorNewFailed => 'Databasen kunne ikke oprettes. Prøv igen.';

  @override
  String get editorPickFailed => 'Filen kunne ikke åbnes.';

  @override
  String get editorRenameFailed => 'Databasen kunne ikke omdøbes.';

  @override
  String get editorDuplicateFailed => 'Databasen kunne ikke kopieres.';

  @override
  String get editorNationsSearch => 'Søg landshold';

  @override
  String get editorFilterAll => 'Alle';

  @override
  String get editorNationsNone => 'Intet landshold passer til søgningen.';

  @override
  String get editorNationSquadReady => 'Truppen er klar';

  @override
  String get editorSquadAdd => 'Tilføj spiller';

  @override
  String editorSquadFull(int max) {
    return 'En trup kan højst have $max spillere.';
  }

  @override
  String editorSquadRemoved(String name) {
    return '$name fjernet fra truppen';
  }

  @override
  String get editorPlayerUnnamed => 'Spiller uden navn';

  @override
  String get editorSquadDuplicate =>
      'En anden spiller i truppen har samme navn.';

  @override
  String get editorSquadEmpty => 'Ingen spillere endnu. Tilføj den første.';

  @override
  String get editorSquadReady => 'Truppen er klar til at spille.';

  @override
  String get editorSquadFill => 'Udfyld manglende spillere';

  @override
  String get editorSquadFillAbout =>
      'Tilføjer nationens egne genererede spillere, de stærkeste først, til truppen har den størrelse og de positioner, en karriere kræver.';

  @override
  String editorSquadFilled(int count) {
    return 'Spillere tilføjet: $count';
  }

  @override
  String get editorCommunityTitle =>
      'Fans deler deres databaser på vores Discord';

  @override
  String get editorCommunityAbout =>
      'Delt af fællesskabet. Vi hoster eller kontrollerer ikke disse databaser.';

  @override
  String editorSquadRules(int min, int max, int gk, int def, int mid, int fwd) {
    return '$min til $max spillere, heraf mindst $gk målmænd, $def forsvarsspillere, $mid midtbanespillere og $fwd angribere.';
  }

  @override
  String get editorShortGk => 'MM';

  @override
  String get editorShortDef => 'FO';

  @override
  String get editorShortMid => 'MB';

  @override
  String get editorShortFwd => 'AN';

  @override
  String editorPlayerAgeShort(int age) {
    return '$age år';
  }

  @override
  String get editorPlayerName => 'Navn';

  @override
  String get editorPlayerNameHint => 'Skriv hans navn';

  @override
  String get editorPlayerNameNeeded => 'Der skal et navn til.';

  @override
  String get editorPlayerNameBad => 'Fjern de usædvanlige tegn.';

  @override
  String get editorPlayerAge => 'Alder';

  @override
  String get editorPlayerPosition => 'Position';

  @override
  String get editorPlayerClub => 'Klub';

  @override
  String get editorPlayerFreeAgent => 'Klubløs';

  @override
  String get editorPlayerClubSearch => 'Søg klubber';

  @override
  String get editorPlayerClubNone => 'Ingen klub passer til søgningen.';

  @override
  String get editorPlayerClubPick => 'Vælg en klub';

  @override
  String get editorPlayerOverall => 'Samlet styrke';

  @override
  String get editorPlayerType => 'Spillertype';

  @override
  String get editorPlayerPotential => 'Potentiale';

  @override
  String get editorPlayerPotentialAbout =>
      'Det højeste niveau, han kan nå, hvis han udvikler sig godt. Aldrig under hans samlede styrke.';

  @override
  String get editorPlayerQualities => 'Det, spillet gemmer';

  @override
  String get editorTypeBalanced => 'Alsidig';

  @override
  String get editorTypeAthlete => 'Atlet';

  @override
  String get editorTypeTechnician => 'Tekniker';

  @override
  String get editorTypeEngine => 'Motor';

  @override
  String get editorTypeBalancedAbout => 'Jævn i fysik, teknik og udholdenhed.';

  @override
  String get editorTypeAthleteAbout => 'Stærk og hurtig, lidt svagere teknisk.';

  @override
  String get editorTypeTechnicianAbout => 'Dygtig med bolden, mindre fysisk.';

  @override
  String get editorTypeEngineAbout => 'Løber hele dagen, stabil i alt andet.';

  @override
  String get editorPlayerLess => 'Én mindre';

  @override
  String get editorPlayerMore => 'Én mere';

  @override
  String get editorPlayerRemove => 'Fjern fra truppen';

  @override
  String get editorPlayerGone => 'Denne spiller er ikke længere i truppen.';

  @override
  String get editorNationGone => 'Dette landshold findes ikke i databasen.';

  @override
  String get editorPickPlayer => 'Vælg en spiller at redigere.';

  @override
  String get editorPlayerClubAuto => 'Spillet vælger';

  @override
  String get editorPlayerClubAutoAbout =>
      'Spillet placerer ham i en klub, der passer til hans niveau.';

  @override
  String get editorNamesSearch => 'Søg navne';

  @override
  String get editorNamesSearchClubs => 'Søg klubber eller lande';

  @override
  String get editorNamesSearchStadiums => 'Søg stadioner, byer eller lande';

  @override
  String get editorNamesSearchNations => 'Søg lande eller koder';

  @override
  String get editorNamesNone => 'Intet passer til søgningen.';

  @override
  String get editorNamesEveryLanguage =>
      'Et eget navn vises på alle sprog, medmindre du giver et sprog sit eget navn.';

  @override
  String editorNamesGameName(String name) {
    return 'Spillets navn: $name';
  }

  @override
  String get editorNamesReset => 'Nulstil til original';

  @override
  String get editorNamesDone => 'Færdig';

  @override
  String get editorNamesKeepHint =>
      'Lad feltet stå tomt for at beholde spillets navn.';

  @override
  String get editorNamesCode => 'Kode';

  @override
  String get editorNamesCodeHelp =>
      '3 bogstaver, A til Z, som intet andet land bruger.';

  @override
  String editorNamesCodeTaken(String code, String nation) {
    return '$code bruges allerede af $nation.';
  }

  @override
  String get editorNamesTaken => 'En anden konto har allerede dette navn.';

  @override
  String get editorLanguageTitle => 'Navne på hvilket sprog';

  @override
  String get editorLanguageAll => 'Alle sprog';

  @override
  String get editorLanguageAllShort => 'Alle';

  @override
  String get editorLanguageNote =>
      'Kun editoren skifter sprog. Spillet bliver på sit eget sprog.';

  @override
  String editorLanguageEditing(String language) {
    return 'Navne på $language. Lad et felt stå tomt for at bruge hovednavnet.';
  }

  @override
  String get editorLanguageSame => 'Ens på alle sprog';

  @override
  String editorLanguageMainName(String name) {
    return 'Hovednavn: $name';
  }

  @override
  String get editorLanguageKeepHint =>
      'Lad feltet stå tomt for at bruge hovednavnet.';

  @override
  String get editorLanguageClear => 'Brug hovednavnet';

  @override
  String get editorLanguageFull =>
      'Databasen har ikke plads til flere navne pr. sprog.';

  @override
  String get editorPlayerDelete => 'Slet spiller';

  @override
  String get editorPlayerAdvanced => 'Avanceret';

  @override
  String get editorPlayerAdvancedAbout =>
      'Indstil hans fysik, teknik og udholdenhed hver for sig.';

  @override
  String get editorPlayerAdvancedOverall => 'Samlet styrke ud fra disse';

  @override
  String get editorPlayerTraits => 'Kendt for';

  @override
  String get editorPlayerTraitsRandom => 'Tilfældig';

  @override
  String get editorPlayerTraitsRandomAbout =>
      'Hver karriere trækker hans egenskaber, som spillet altid har gjort.';

  @override
  String get editorPlayerTraitsNone => 'Ingen egenskaber, i alle karrierer.';

  @override
  String editorPlayerTraitsPicked(int max) {
    return 'Disse egenskaber i alle karrierer. Vælg op til $max.';
  }

  @override
  String editorPlayerTraitsMax(int max) {
    return 'En spiller har højst $max egenskaber. Fravælg én først.';
  }

  @override
  String editorPlayerTraitUnknown(String trait) {
    return '$trait (ukendt for denne version)';
  }

  @override
  String editorIssueInLanguage(String issue, String language) {
    return '$issue ($language)';
  }

  @override
  String get editorTabSquad => 'Trup';

  @override
  String get editorTabPool => 'Pulje';

  @override
  String get editorPoolGenerated => 'Lavet af spillet';

  @override
  String get editorPoolGeneratedAbout =>
      'Hver karriere trækker denne pulje på ny, som spillet altid har gjort. Din første ændring låser den præcis, som den vises her, i alle karrierer.';

  @override
  String get editorPoolFixed => 'Din pulje';

  @override
  String get editorPoolFixedAbout =>
      'Hver karriere starter med præcis disse spillere.';

  @override
  String get editorPoolReset => 'Tilbage til spillets';

  @override
  String get editorPoolResetTitle => 'Tilbage til spillets pulje?';

  @override
  String get editorPoolResetBody =>
      'Dine ændringer i denne pulje kasseres, og hver karriere laver den igen.';

  @override
  String editorPoolMax(int max) {
    return 'Op til $max';
  }

  @override
  String editorPoolFull(int max) {
    return 'En pulje kan højst have $max spillere.';
  }

  @override
  String editorPoolRemoved(String name) {
    return '$name fjernet fra puljen';
  }

  @override
  String get editorPoolRemove => 'Fjern fra puljen';

  @override
  String get editorPoolPlayerGone => 'Denne spiller er ikke længere i puljen.';

  @override
  String get editorPoolDuplicate => 'En anden spiller i puljen har samme navn.';

  @override
  String get editorPoolEmpty => 'Ingen spillere i puljen. Tilføj den første.';

  @override
  String get editorPoolLoadFailed => 'Spillets pulje kunne ikke læses.';

  @override
  String editorPlayerTraitsUnknownDropped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ukendte egenskaber fjernet',
      one: '1 ukendt egenskab fjernet',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedTag => 'Tilføjet';

  @override
  String get editorAddedGroup => 'Tilføjet';

  @override
  String get editorAddedGameGroup => 'I spillet';

  @override
  String get editorAddClub => 'Tilføj klub';

  @override
  String get editorAddSponsor => 'Tilføj sponsor';

  @override
  String get editorAddY => 'Tilføj konto';

  @override
  String get editorAddedAdd => 'Tilføj';

  @override
  String get editorAddedDelete => 'Slet';

  @override
  String editorAddedRemoved(String name) {
    return '$name slettet';
  }

  @override
  String editorAddedClubsFull(int max) {
    return 'En database kan højst tilføje $max klubber.';
  }

  @override
  String editorAddedSponsorsFull(int max) {
    return 'En database kan højst tilføje $max sponsorer.';
  }

  @override
  String editorAddedYFull(int max) {
    return 'En database kan højst tilføje $max konti.';
  }

  @override
  String get editorAddedGone => 'Dette findes ikke længere i databasen.';

  @override
  String get editorAddedNameNeeded => 'Giv den et navn';

  @override
  String get editorAddedCountry => 'Land';

  @override
  String get editorAddedCountryPick => 'Vælg et land';

  @override
  String editorAddedNoLeague(String country) {
    return '$country har ingen liga eller byer i spillet, så denne klub får kun de spillere, du selv placerer der.';
  }

  @override
  String editorAddedClubTaken(String country) {
    return '$country har allerede en klub med dette navn.';
  }

  @override
  String get editorAddedClubGameName =>
      'En klub i spillet hedder allerede sådan.';

  @override
  String editorAddedClubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count spillere fra denne database spiller her. Slet klubben, så placerer spillet dem.',
      one:
          '1 spiller fra denne database spiller her. Slet klubben, så placerer spillet ham.',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedDeal => 'Aftaletype';

  @override
  String get editorDealBigPayer => 'Storbetaler';

  @override
  String get editorDealCrowdPleaser => 'Spillerfavorit';

  @override
  String get editorDealFamilyFriendly => 'Familievenlig';

  @override
  String get editorDealMarketing => 'Markedsføring';

  @override
  String get editorAddedIndustry => 'Branche';

  @override
  String get editorAddedIndustryPick => 'Vælg en branche';

  @override
  String get editorAddedDescription => 'Beskrivelse (valgfri)';

  @override
  String get editorAddedDescriptionHelp =>
      'Står feltet tomt, bruger tilbuddet aftaletypens sædvanlige linje.';

  @override
  String get editorAddedVoice => 'Kontotype';

  @override
  String get editorYVoiceFan => 'Fan';

  @override
  String get editorYVoicePundit => 'Ekspert';

  @override
  String get editorYVoiceMeme => 'Meme';

  @override
  String get editorYVoiceStats => 'Statistik';

  @override
  String get editorYVoiceRival => 'Rival';

  @override
  String get editorYVoiceExpro => 'Eks-prof';

  @override
  String get editorYVoiceNeutral => 'Neutral';

  @override
  String get editorYVoiceFanAbout =>
      'En af dine egne fans. Begejstret, rasende, vægelsindet.';

  @override
  String get editorYVoicePunditAbout =>
      'En afdæmpet stemme, der dukker op gennem hele karrieren.';

  @override
  String get editorYVoiceMemeAbout =>
      'Siger intet brugbart og bliver læst først.';

  @override
  String get editorYVoiceStatsAbout => 'Poster tal og intet andet.';

  @override
  String get editorYVoiceRivalAbout => 'Nyder din modgang.';

  @override
  String get editorYVoiceExproAbout =>
      'En tidligere landsholdsspiller med en klumme og nul tålmodighed.';

  @override
  String get editorYVoiceNeutralAbout =>
      'Følger al fodbold og dukker kun op, når noget stort sker.';

  @override
  String get editorAddedPostsIn => 'Skriver i';

  @override
  String get editorAddedAllNations => 'Alle landshold';

  @override
  String get editorAddedSearch => 'Søg';

  @override
  String editorCountAdded(int count) {
    return '$count tilføjet';
  }

  @override
  String get editorNamesOutlet => 'Medie';

  @override
  String get editorNamesFirstNames => 'Fornavne';

  @override
  String get editorNamesSurnames => 'Efternavne';

  @override
  String editorNamesFirstCount(int count, int min) {
    return '$count / $min fornavne';
  }

  @override
  String editorNamesSurCount(int count, int min) {
    return '$count / $min efternavne';
  }

  @override
  String editorNamesListsHelp(int min) {
    return 'Adskil navnene med kommaer eller nye linjer. Hver liste skal have mindst $min. De bruges til nye spillere, lokale fans og stab.';
  }

  @override
  String editorNamesListCounts(int first, int sur) {
    return '$first fornavne, $sur efternavne';
  }

  @override
  String editorNamesMainStadium(String city) {
    return 'Hovedstadion i $city';
  }

  @override
  String get editorNamesChanged => 'Ændret';

  @override
  String get editorNamesPick => 'Vælg et navn at redigere.';

  @override
  String get editorNamesStadiumsNote =>
      'Kun de nationalstadioner, der står her, kan omdøbes: hovedstadionet i hver by.';

  @override
  String get editorTrophiesIntro =>
      'Tryk på en pokal for at give den dit eget billede. En PNG med gennemsigtig baggrund ser bedst ud.';

  @override
  String get editorTrophyCustom => 'Eget';

  @override
  String get editorTrophyDefault => 'Spillets billede';

  @override
  String get editorTrophyChoose => 'Vælg et billede';

  @override
  String get editorTrophyReplace => 'Vælg et andet billede';

  @override
  String get editorTrophyReset => 'Tilbage til standard';

  @override
  String get editorTrophyResetTitle => 'Brug spillets billede?';

  @override
  String get editorTrophyResetBody =>
      'Dit billede til denne pokal fjernes. Fortryd kan ikke hente det tilbage.';

  @override
  String get editorTrophyResetConfirm => 'Fjern billedet';

  @override
  String get editorTrophyUnusable =>
      'Billedet kan ikke bruges. Vælg en PNG eller JPEG på højst 4096 pixels per side.';

  @override
  String get editorTrophyOpening => 'Åbner billedet';

  @override
  String get editorTrophyPreparing => 'Gør pokalen klar';

  @override
  String get editorTrophyFrameTitle => 'Indram pokalen';

  @override
  String get editorTrophyFrameHint =>
      'Træk for at flytte, og knib for at zoome. Det, der er inden for rammen, bliver pokalen.';

  @override
  String get editorTrophyFit => 'Tilpas';

  @override
  String get editorTrophyPreview => 'Eksempel';

  @override
  String get editorTrophyPreviewTitle => 'Sådan kommer den til at se ud';

  @override
  String get editorTrophyAdjust => 'Justér';

  @override
  String get editorTrophyUse => 'Brug billedet';

  @override
  String get editorTrophyRectangle =>
      'Billedet har ingen gennemsigtig baggrund, så spillet viser det som et rektangel.';

  @override
  String get editorTrophyRectangleShort => 'Vises som rektangel';

  @override
  String get editorTrophySaved => 'Pokalbilledet er gemt.';

  @override
  String get editorTrophyRemoved => 'Spillets billede er tilbage.';

  @override
  String get editorTrophySaveFailed => 'Billedet kunne ikke gemmes. Prøv igen.';

  @override
  String get editorSaveFailed =>
      'Dine seneste ændringer kunne ikke gemmes. Prøver igen.';

  @override
  String get editorTrophyPick => 'Vælg en pokal for at skifte dens billede.';

  @override
  String editorTrophySize(int width, int height) {
    return 'Gemmes i $width x $height pixels';
  }

  @override
  String editorIssueUnknownEntry(String name) {
    return '$name findes ikke længere i spillet';
  }

  @override
  String get editorAttentionBody =>
      'Noget i denne database passer ikke til denne version af spillet: et navnesammenfald, eller noget, en spilopdatering har fjernet. Ret eller fjern hver post nedenfor, så kan den starte en karriere igen.';

  @override
  String get editorRemove => 'Fjern';

  @override
  String worldChip(String name) {
    return 'Verden: $name';
  }

  @override
  String get worldDefault => 'Standard';

  @override
  String get worldDefaultAbout => 'Spillets egen verden';

  @override
  String get worldSheetTitle => 'Vælg en verden';

  @override
  String get worldSheetBlurb =>
      'Databaser, du har lavet eller åbnet i Editoren. Kun komplette kan starte en karriere.';

  @override
  String get worldPackGone =>
      'Databasen findes ikke længere på enheden. Karrieren blev ikke startet.';

  @override
  String get worldStarting => 'Gør din verden klar';

  @override
  String get settingsDefaultWorldTitle => 'Standardverden';

  @override
  String get settingsDefaultWorldBlurb =>
      'Den verden, Nyt spil starter i. Du kan stadig ændre den for hver karriere.';

  @override
  String get worldPackNotReady =>
      'Den database kan ikke længere starte en karriere. Ret den i Editoren, eller vælg en anden verden.';

  @override
  String pitchComShotGoal1(String player) {
    return 'MÅL! $player finder nettet!';
  }

  @override
  String pitchComShotGoal2(String player) {
    return '$player skyder den ind! MÅL!';
  }

  @override
  String pitchComShotGoal3(String player) {
    return 'MÅL! Iskold afslutning fra $player.';
  }

  @override
  String pitchComShotSaved1(String player, String keeper) {
    return '$player skyder, men $keeper redder.';
  }

  @override
  String pitchComShotSaved2(String player) {
    return '$player prøver, men målmanden er på plads.';
  }

  @override
  String pitchComShotSaved3(String player, String keeper) {
    return '$player flår den afsted, $keeper fejer den væk!';
  }

  @override
  String pitchComShotWide1(String player) {
    return '$player skyder forbi.';
  }

  @override
  String pitchComShotWide2(String player) {
    return 'Forbi målet af $player.';
  }

  @override
  String pitchComShotWide3(String player) {
    return '$player skyder lige forbi stolpen.';
  }

  @override
  String pitchComShotBlocked1(String player) {
    return '$player skyder, men skuddet bliver blokeret.';
  }

  @override
  String pitchComShotBlocked2(String player) {
    return 'Blokeret! $player finder ingen vej igennem.';
  }

  @override
  String pitchComShotBlocked3(String player) {
    return '$player skyder, men en forsvarer kaster sig ind imellem.';
  }

  @override
  String pitchComShotWoodwork1(String player) {
    return 'Stolpe! $player er uheldig.';
  }

  @override
  String pitchComShotWoodwork2(String player) {
    return '$player rammer træværket!';
  }

  @override
  String pitchComShotWoodwork3(String player) {
    return 'Overligger! $player stoppes af overliggeren.';
  }

  @override
  String pitchComHeaderGoal1(String player) {
    return 'MÅL! $player header den ind!';
  }

  @override
  String pitchComHeaderGoal2(String player) {
    return '$player stiger højest og scorer! MÅL!';
  }

  @override
  String pitchComHeaderGoal3(String player) {
    return 'MÅL! Kraftfuldt hovedstød af $player.';
  }

  @override
  String pitchComHeaderSaved1(String player, String keeper) {
    return '$player header, $keeper redder.';
  }

  @override
  String pitchComHeaderSaved2(String player) {
    return 'Hovedstød af $player, men målmanden holder den.';
  }

  @override
  String pitchComHeaderSaved3(String player, String keeper) {
    return 'Hovedstød af $player, $keeper fejer den væk.';
  }

  @override
  String pitchComHeaderWide1(String player) {
    return '$player header forbi.';
  }

  @override
  String pitchComHeaderWide2(String player) {
    return 'Hovedstød af $player, men forbi målet.';
  }

  @override
  String pitchComHeaderWide3(String player) {
    return '$player kan ikke få hovedstødet ned.';
  }

  @override
  String pitchComHeaderBlocked1(String player) {
    return '$player header, men det bliver blokeret.';
  }

  @override
  String pitchComHeaderBlocked2(String player) {
    return '$player header mod mål, men forsvaret blokerer.';
  }

  @override
  String pitchComHeaderBlocked3(String player) {
    return 'Blokeret! $player når bolden, men en forsvarer står i vejen.';
  }

  @override
  String pitchComHeaderWoodwork1(String player) {
    return '$player header i overliggeren!';
  }

  @override
  String pitchComHeaderWoodwork2(String player) {
    return 'Stolpe! Hovedstødet af $player kommer tilbage i spil.';
  }

  @override
  String pitchComHeaderWoodwork3(String player) {
    return 'Træværket! $player får målet til at ryste med et hovedstød.';
  }

  @override
  String pitchComSetPieceGoal1(String player) {
    return 'MÅL! $player er der til sidst i angrebet!';
  }

  @override
  String pitchComSetPieceGoal2(String player, String other) {
    return 'MÅL! $other slår ind og $player scorer!';
  }

  @override
  String pitchComSetPieceGoal3(String player) {
    return 'På dødbold scorer $player! MÅL!';
  }

  @override
  String pitchComSetPieceSaved1(String player, String keeper) {
    return '$player når bolden, men $keeper redder.';
  }

  @override
  String pitchComSetPieceSaved2(String player) {
    return '$player rører bolden, målmanden tager den.';
  }

  @override
  String pitchComSetPieceSaved3(String player, String keeper) {
    return '$player afslutter, $keeper er opmærksom.';
  }

  @override
  String pitchComSetPieceWide1(String player) {
    return '$player når til afslutning, men forbi.';
  }

  @override
  String pitchComSetPieceWide2(String player) {
    return '$player når indlægget, men forbi målet.';
  }

  @override
  String pitchComSetPieceWide3(String player) {
    return 'Over overliggeren af $player.';
  }

  @override
  String pitchComSetPieceBlocked1(String player) {
    return '$player når bolden, men det bliver blokeret.';
  }

  @override
  String pitchComSetPieceBlocked2(String player) {
    return 'Rod i feltet! $player bliver blokeret.';
  }

  @override
  String pitchComSetPieceBlocked3(String player) {
    return '$player prøver at skubbe den over stregen, men forsvaret renser.';
  }

  @override
  String pitchComSetPieceWoodwork1(String player) {
    return '$player afslutter og rammer stolpen!';
  }

  @override
  String pitchComSetPieceWoodwork2(String player) {
    return 'Overligger! $player er tæt på at score på dødbold.';
  }

  @override
  String pitchComSetPieceWoodwork3(String player) {
    return 'Træværket! $player så tæt på efter indlægget.';
  }

  @override
  String pitchComDirectFreeKickGoal1(String player) {
    return 'MÅL! $player lægger frisparket over muren!';
  }

  @override
  String pitchComDirectFreeKickGoal2(String player) {
    return 'Sikke et frispark! $player finder skæringspunktet!';
  }

  @override
  String pitchComDirectFreeKickGoal3(String player) {
    return 'MÅL! $player overlister målmanden på frispark.';
  }

  @override
  String pitchComDirectFreeKickSaved1(String player, String keeper) {
    return '$player skyder direkte mod mål, $keeper redder.';
  }

  @override
  String pitchComDirectFreeKickSaved2(String player) {
    return 'Frisparket fra $player bliver fejet væk.';
  }

  @override
  String pitchComDirectFreeKickSaved3(String player, String keeper) {
    return 'Flot redning! Frispark af $player, $keeper stopper det.';
  }

  @override
  String pitchComDirectFreeKickWide1(String player) {
    return 'Frisparket fra $player går over.';
  }

  @override
  String pitchComDirectFreeKickWide2(String player) {
    return '$player prøver direkte, men forbi.';
  }

  @override
  String pitchComDirectFreeKickWide3(String player) {
    return '$player rammer ikke målet på frispark.';
  }

  @override
  String pitchComDirectFreeKickBlocked1(String player) {
    return 'Frisparket fra $player ender i muren.';
  }

  @override
  String pitchComDirectFreeKickBlocked2(String player) {
    return 'Ind i muren af $player.';
  }

  @override
  String pitchComDirectFreeKickBlocked3(String player) {
    return 'Muren holder mod $player.';
  }

  @override
  String pitchComDirectFreeKickWoodwork1(String player) {
    return '$player rammer overliggeren med frisparket!';
  }

  @override
  String pitchComDirectFreeKickWoodwork2(String player) {
    return 'Stolpe! Frispark af $player, bolden kommer tilbage.';
  }

  @override
  String pitchComDirectFreeKickWoodwork3(String player) {
    return 'Træværket redder målmanden! $player er uheldig.';
  }

  @override
  String pitchComPenaltyGoal1(String player) {
    return 'MÅL! $player sender målmanden den forkerte vej.';
  }

  @override
  String pitchComPenaltyGoal2(String player) {
    return '$player tager tilløb og scorer! MÅL!';
  }

  @override
  String pitchComPenaltyGoal3(String player) {
    return 'MÅL! $player sætter straffesparket iskoldt ind.';
  }

  @override
  String pitchComPenaltySaved1(String player, String keeper) {
    return 'Reddet! Straffespark af $player, $keeper stopper det!';
  }

  @override
  String pitchComPenaltySaved2(String player) {
    return '$player tager tilløb... og målmanden redder!';
  }

  @override
  String pitchComPenaltySaved3(String player, String keeper) {
    return 'Straffespark af $player, $keeper gætter rigtigt og redder!';
  }

  @override
  String pitchComPenaltyMissed1(String player) {
    return '$player brænder straffesparket!';
  }

  @override
  String pitchComPenaltyMissed2(String player) {
    return 'Forbi! Straffesparket fra $player går lige forbi stolpen.';
  }

  @override
  String pitchComPenaltyMissed3(String player) {
    return 'Over! $player sparker straffesparket op i det blå.';
  }

  @override
  String pitchComPenaltyWoodwork1(String player) {
    return 'Straffespark af $player i stolpen!';
  }

  @override
  String pitchComPenaltyWoodwork2(String player) {
    return 'Overligger! Straffesparket fra $player går ikke ind.';
  }

  @override
  String pitchComPenaltyWoodwork3(String player) {
    return 'Træværket! $player kan ikke tro det.';
  }

  @override
  String pitchComPenaltyAwarded1(String player) {
    return 'Straffespark! $player fældes i feltet.';
  }

  @override
  String pitchComPenaltyAwarded2(String player, String other) {
    return 'Dommeren peger på pletten! Forseelse af $other mod $player.';
  }

  @override
  String pitchComPenaltyAwarded3(String player, String other) {
    return 'Straffespark dømt! $other fælder $player i feltet.';
  }

  @override
  String pitchComPenaltyAwardedYellow1(String player, String other) {
    return 'Straffespark! $player går ned og $other får gult.';
  }

  @override
  String pitchComPenaltyAwardedYellow2(String player, String other) {
    return 'Straffespark, og gult kort til $other efter forseelsen mod $player.';
  }

  @override
  String pitchComPenaltyAwardedYellow3(String player, String other) {
    return 'Straffespark og kort! $other fælder $player i feltet.';
  }

  @override
  String pitchComPenaltyAwardedRed1(String player, String other) {
    return 'Straffespark og rødt! $player går ned, $other bliver udvist.';
  }

  @override
  String pitchComPenaltyAwardedRed2(String player, String other) {
    return 'Straffespark, og $other bliver udvist for forseelsen mod $player!';
  }

  @override
  String pitchComPenaltyAwardedRed3(String player, String other) {
    return 'Rødt og straffespark! $other stopper $player alene mod målet.';
  }

  @override
  String pitchComCorner1(String player) {
    return 'Hjørnespark. Tages af $player.';
  }

  @override
  String pitchComCorner2(String player) {
    return '$player slår hjørnesparket ind.';
  }

  @override
  String pitchComCorner3(String player) {
    return 'Hjørnespark, $player gør sig klar.';
  }

  @override
  String pitchComFreeKick1(String player) {
    return 'Frispark. Tages af $player.';
  }

  @override
  String pitchComFreeKick2(String player) {
    return 'Frispark på farlig position. $player stiller sig op.';
  }

  @override
  String pitchComFreeKick3(String player) {
    return '$player gør sig klar til frisparket.';
  }

  @override
  String pitchComLongThrow1(String player) {
    return 'Langt indkast! $player kaster bolden ind i feltet.';
  }

  @override
  String pitchComLongThrow2(String player) {
    return '$player med et langt indkast ind i feltet.';
  }

  @override
  String pitchComLongThrow3(String player) {
    return 'Her kommer det lange indkast af $player.';
  }

  @override
  String pitchComFoulYellow1(String player) {
    return 'Gult kort til $player.';
  }

  @override
  String pitchComFoulYellow2(String player, String other) {
    return '$player får gult for en forseelse mod $other.';
  }

  @override
  String pitchComFoulYellow3(String player, String other) {
    return 'Sen tackling mod $other, og $player får gult.';
  }

  @override
  String pitchComFoulSecondYellow1(String player) {
    return 'Andet gule kort! $player bliver udvist.';
  }

  @override
  String pitchComFoulSecondYellow2(String player) {
    return '$player får endnu et gult og bliver udvist.';
  }

  @override
  String pitchComFoulSecondYellow3(String player) {
    return 'Andet gule kort til $player, altså rødt.';
  }

  @override
  String pitchComFoulRed1(String player) {
    return 'Rødt kort! $player bliver udvist.';
  }

  @override
  String pitchComFoulRed2(String player, String other) {
    return 'Direkte rødt til $player efter forseelsen mod $other!';
  }

  @override
  String pitchComFoulRed3(String player) {
    return '$player får rødt og må forlade banen.';
  }

  @override
  String pitchComOffside1(String player) {
    return 'Offside. $player løb for tidligt.';
  }

  @override
  String pitchComOffside2(String player) {
    return 'Flaget går op for $player.';
  }

  @override
  String pitchComOffside3(String player) {
    return '$player er fanget offside.';
  }

  @override
  String pitchComSub1(String player, String other) {
    return 'Udskiftning: $player ind, $other ud.';
  }

  @override
  String pitchComSub2(String player, String other) {
    return '$other giver plads til $player.';
  }

  @override
  String pitchComSub3(String player, String other) {
    return '$player kommer ind for $other.';
  }

  @override
  String pitchComSubFill1(String player) {
    return '$player kommer ind.';
  }

  @override
  String pitchComSubFill2(String player) {
    return 'Udskiftning: $player er på banen.';
  }

  @override
  String pitchComSubFill3(String player) {
    return '$player går ind på banen.';
  }

  @override
  String pitchComInjury1(String player) {
    return '$player ligger ned og skal behandles.';
  }

  @override
  String pitchComInjury2(String player) {
    return 'Bekymring, $player har fået et slag.';
  }

  @override
  String pitchComInjury3(String player) {
    return 'Skadesbekymring for $player.';
  }

  @override
  String pitchComGoalScore(String line, int home, int away) {
    return '$line $home–$away';
  }

  @override
  String get pitchComSomeone => 'Spiller';

  @override
  String pitchComPenaltyAwardedSecondYellow1(String player, String other) {
    return 'Straffespark og andet gult! $other bliver udvist for forseelsen mod $player.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow2(String player, String other) {
    return 'Straffespark! $player går ned og $other får andet gule kort.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow3(String player, String other) {
    return 'Straffespark! $other fælder $player og får endnu et gult, altså rødt.';
  }

  @override
  String get matchViewChooseTitle => 'Hvordan vil du følge kampen?';

  @override
  String get matchViewChooseHint =>
      'Dit valg gælder også i næste kamp. Du kan skifte når som helst.';

  @override
  String get matchViewPitch => '2D TV';

  @override
  String get matchViewPitchBlurb => 'Følg spillerne på banen';

  @override
  String get matchViewTimeline => 'Forløb';

  @override
  String get matchViewTimelineBlurb => 'Følg kampen begivenhed for begivenhed';

  @override
  String get matchViewSwitchToPitch => 'Se i 2D TV-tilstand';

  @override
  String get matchViewSwitchToTimeline => 'Se forløbet';

  @override
  String get matchTabCommentary => 'KOMMENTARER';

  @override
  String get matchSubShout => 'UDSKIFTNING';

  @override
  String matchSubOff(String name) {
    return 'Ud: $name';
  }

  @override
  String matchSubOn(String name) {
    return 'Ind: $name';
  }

  @override
  String get editorFilterToFix => 'Skal rettes';

  @override
  String get editorNothingToFix => 'Intet skal rettes her.';

  @override
  String get editorPromoteTooltip => 'Flyt til truppen';

  @override
  String editorPromoted(String name) {
    return '$name flyttet til truppen';
  }

  @override
  String get editorPromoteFullTitle => 'Truppen er fuld';

  @override
  String editorPromoteFullBody(int max) {
    return 'En trup har højst $max spillere. Vælg den spiller, der går tilbage til puljen i hans sted.';
  }

  @override
  String get editorTrophyGallery => 'Vælg blandt dine billeder';

  @override
  String get editorTrophyFile => 'Vælg en fil';

  @override
  String clubStrengthOf(int stars) {
    return 'Klubbens styrke: $stars ud af 5';
  }

  @override
  String get editorClubStrength => 'Styrke';

  @override
  String get editorClubStrengthDefault => 'Standard';

  @override
  String editorClubStrengthHelp(int stars) {
    return 'Bedre spillere går til stærkere klubber. Standard: $stars ud af 5 ud fra ligaen.';
  }

  @override
  String mgrNewsSacked(String nation, String name) {
    return '$nation fyrer $name';
  }

  @override
  String mgrNewsResigned(String nation, String name) {
    return '$nation: $name går af';
  }

  @override
  String mgrNewsPoached(String nation, String name) {
    return '$nation: $name forlader for et andet landshold';
  }

  @override
  String mgrNewsRetired(String nation, String name) {
    return '$nation: $name stopper som træner';
  }

  @override
  String mgrNewsContractEnd(String nation, String name) {
    return '$nation: $name går, når kontrakten udløber';
  }

  @override
  String mgrNewsReplacedByPlayer(String nation, String name) {
    return '$nation: $name giver plads til dig';
  }

  @override
  String mgrNewsAppointed(String nation, String name) {
    return '$nation ansætter $name';
  }

  @override
  String mgrNewsAppointedBody(String nation, String name) {
    return '$name overtager $nation.';
  }

  @override
  String pressBeatOpposingManager(String manager) {
    return 'Du og $manager har en historie. Har du noget at sige om ham?';
  }

  @override
  String get pressAnswerHitBackAtManager =>
      'Han skal bekymre sig om sit eget hold.';

  @override
  String get pressAnswerRespectManager => 'Jeg har stor respekt for ham.';

  @override
  String yMgrTie1(String manager) {
    return '$manager på den anden bænk næste gang. Der er en historie med vores træner, og jeg kan ikke vente.';
  }

  @override
  String yMgrTie2(String manager) {
    return 'Næste gang sidder $manager på den anden bænk. Han og vores landstræner har kendt hinanden længe.';
  }

  @override
  String yMgrTie3(String manager) {
    return '$manager igen. Vores træner skulle helst ikke gøre det til en personlig sag.';
  }

  @override
  String yMgrTie4(String manager) {
    return 'Nu går det løs. $manager ved sidelinjen, og vores træner prøver at vinde en fejde i stedet for en kamp.';
  }

  @override
  String get mgrRowLabel => 'Landstræner';

  @override
  String mgrRowDetail(int age, String date) {
    return '$age år, siden $date';
  }

  @override
  String mgrRecordWdl(int won, int drawn, int lost) {
    return '$won S, $drawn U, $lost T';
  }

  @override
  String mgrRowRecord(String record) {
    return 'Under ham: $record';
  }

  @override
  String get mgrTieNeutral => 'Ingen historie';

  @override
  String get mgrTieRespect => 'Respekt';

  @override
  String get mgrTieRival => 'Rival';

  @override
  String get mgrTieGrudge => 'Nag';

  @override
  String get mgrTieSuccessor => 'Efterfølger';

  @override
  String get mgrTieProtege => 'Protegé';

  @override
  String get mgrTieFormerPlayer => 'Tidligere spiller';

  @override
  String get mgrEndSacked => 'Fyret';

  @override
  String get mgrEndResigned => 'Gik af';

  @override
  String get mgrEndPoached => 'Forlod for et andet landshold';

  @override
  String get mgrEndRetired => 'Stoppede som træner';

  @override
  String get mgrEndContractEnd => 'Kontrakten udløb';

  @override
  String get mgrEndReplacedByPlayer => 'Erstattet af dig';

  @override
  String get mgrProfileSpells => 'Karriere';

  @override
  String mgrProfileSpellNow(String nation, String from) {
    return '$nation, siden $from';
  }

  @override
  String mgrProfileSpellRange(String nation, String from, String to) {
    return '$nation, $from til $to';
  }

  @override
  String mgrProfileSpellEnded(String range, String reason) {
    return '$range, $reason';
  }

  @override
  String get mgrProfileRecordVsYou => 'Resultater mod dig';

  @override
  String get mgrProfileNoMeetings => 'I har endnu ikke mødt hinanden';

  @override
  String get mgrProfileReputation => 'Omdømme';

  @override
  String get mgrProfileAge => 'Alder';

  @override
  String get mgrProfileAppointed => 'Ansat';

  @override
  String get mgrProfileStyle => 'Stil';

  @override
  String get mgrProfileTie => 'Mellem jer';

  @override
  String mgrPreviewLine(String name) {
    return 'Deres landstræner: $name';
  }

  @override
  String mgrDossierStyle(String style) {
    return 'Landstrænerens stil: $style';
  }

  @override
  String mgrDossierRecord(String record) {
    return 'Dine resultater mod ham: $record';
  }

  @override
  String get mgrStylePossession => 'Boldbesiddelse';

  @override
  String get mgrStyleHighPress => 'Højt pres';

  @override
  String get mgrStyleDefensive => 'Defensiv';

  @override
  String get mgrStyleDirect => 'Direkte';

  @override
  String get mgrStyleCounter => 'Kontra';

  @override
  String get mgrStyleFlair => 'Teknisk';

  @override
  String get mgrStylePhysical => 'Fysisk';

  @override
  String get mgrStyleBalanced => 'Balanceret';

  @override
  String get mgrListTitle => 'Landstrænere';

  @override
  String get mgrListCurrent => 'Nuværende';

  @override
  String get mgrListRecentMoves => 'Seneste skift';

  @override
  String get mgrListFilterAll => 'Alle';

  @override
  String get mgrListSortReputation => 'Omdømme';

  @override
  String get mgrListSortName => 'Navn';

  @override
  String get mgrListEmptyMoves => 'Ingen ændringer de seneste to år.';

  @override
  String get mgrListEmptyCurrent =>
      'Landstrænere vises efter næste sæsonskifte.';

  @override
  String get editorSectionManagers => 'Landstrænere';

  @override
  String get editorAboutManagers => 'Hvem der leder hvert landshold fra start';

  @override
  String get editorManagersHint => 'Vælges, når en karriere starter';

  @override
  String get editorManagerName => 'Trænerens navn';

  @override
  String get editorManagerNationality => 'Nationalitet';

  @override
  String editorIssueManagerName(int max) {
    return 'Træneren skal have et navn på 1 til $max tegn, som spillet kan vise';
  }

  @override
  String get editorIssueManagerNationality =>
      'Vælg en nationalitet til træneren fra listen';

  @override
  String get shareButton => 'Del';

  @override
  String get shareSheetTitle => 'Del som billede';

  @override
  String get shareFormatSquare => 'Kvadrat';

  @override
  String get shareFormatStory => 'Story';

  @override
  String get shareFailed => 'Billedet kunne ikke oprettes.';

  @override
  String get shareSaveToPhotos => 'Gem i billeder';

  @override
  String get shareSavedToPhotos => 'Gemt i billeder';

  @override
  String get sharePhotosDenied =>
      'FNM har ikke lov til at tilføje til dine billeder. Du kan tillade det i Indstillinger.';

  @override
  String get editorCountryAll => 'Alle lande';

  @override
  String get editorCountryFilterTitle => 'Filtrer efter land';

  @override
  String get shareCabinetBig => 'Del mine trofæer';

  @override
  String yExitProud0(String competition) {
    return 'Et uventet eventyr ved $competition og et flot resultat til sidst. Stolt af drengene.';
  }

  @override
  String yExitProud1(String competition) {
    return 'Ingen gav os en chance ved $competition. Vi nåede længere, end nogen turde drømme om. Tak, drenge.';
  }

  @override
  String yExitProud2(String competition) {
    return 'Ude af $competition, men sikke en tur. Dette hold fik hele landet til at tro. Stolt.';
  }

  @override
  String yExitProud3(String competition) {
    return 'Havde ikke regnet med, at vi kom ud af gruppen ved $competition. Alt derefter var bonus. Fremad og opad.';
  }

  @override
  String yExitProud4(String competition) {
    return 'Vi tog til $competition i håb om et point eller to og kom hjem efter at have spillet knockoutkampe. God turnering.';
  }

  @override
  String yExitProud5(String competition) {
    return 'Længere end forhåndsvurderingerne sagde ved $competition. Det er et skridt fremad, helt enkelt.';
  }

  @override
  String yExitProud6(String competition) {
    return 'Ude af $competition, og det svider lidt. Men ærligt talt: ingen havde set os nå så langt.';
  }

  @override
  String yExitProud7(String competition) {
    return 'Okay, vi er ude af $competition. Stadig mere, end vi har klaret i årevis. Det tager jeg.';
  }

  @override
  String yExitProud8(String competition) {
    return 'Intet trofæ fra $competition, og det var der aldrig udsigt til. Et godt løb er et godt løb. Gør det igen nu.';
  }

  @override
  String get yReactionPride0 => 'Stolt af hver eneste en.';

  @override
  String get yReactionPride1 => 'Sikke et løb. Tak, drenge.';

  @override
  String get yReactionPride2 => 'Ingen havde ventet det her. Husk det.';

  @override
  String get yReactionPride3 => 'Fremad og opad.';

  @override
  String get yReactionPride4 => 'Det hele er bonus. Nyd det.';

  @override
  String get yReactionPride5 => 'Bedre end nogen forudsagde. God turnering.';

  @override
  String get yReactionPride6 => 'Ude, men uden skam. Fair nok.';

  @override
  String get yReactionPride7 =>
      'Det bedste hold gik videre. Vi gjorde os alligevel ære.';

  @override
  String get yReactionPride8 =>
      'Lad os ikke blive for begejstrede. Men ja, et godt løb.';

  @override
  String yExitAccepted0(String competition) {
    return 'Ude af $competition, cirka hvor vi altid ville ende. Stolt af, at de prøvede.';
  }

  @override
  String yExitAccepted1(String competition) {
    return '$competition er slut for os. Vi gav de store hold kamp. Hovedet højt, drenge.';
  }

  @override
  String yExitAccepted2(String competition) {
    return 'Ude af $competition. På papiret var det her altid den sandsynlige slutning. Lær af det og prøv igen.';
  }

  @override
  String yExitAccepted3(String competition) {
    return 'Vores $competition slutter, hvor ranglisten sagde. Ingen skam i det.';
  }

  @override
  String yExitAccepted4(String competition) {
    return 'Ude af $competition, som de fleste af os ventede. Ingen katastrofe, men heller intet chok.';
  }

  @override
  String yExitAccepted5(String competition) {
    return '$competition var et skridt for langt for denne trup. Forskellen er reel. Tid til at lukke den.';
  }

  @override
  String get yReactionAcceptance0 => 'Gav alt. Mere kan man ikke forlange.';

  @override
  String get yReactionAcceptance1 => 'Hovedet højt. Vi kommer igen.';

  @override
  String get yReactionAcceptance2 =>
      'Det gør ondt, men de gjorde os ikke til skamme.';

  @override
  String get yReactionAcceptance3 => 'Nogenlunde som ventet, ærligt talt.';

  @override
  String get yReactionAcceptance4 =>
      'De bedre hold gik videre. Sådan er fodbold.';

  @override
  String get yReactionAcceptance5 => 'Skuffet, ikke vred.';

  @override
  String get yReactionAcceptance6 => 'Lidt fladt, ærligt talt. Men ingen chok.';

  @override
  String get yReactionAcceptance7 => 'Vi er der ikke endnu. Det ved alle.';

  @override
  String get yReactionAcceptance8 =>
      'Samme niveau som sidst. Der skal et skridt op i næste cyklus.';

  @override
  String get sponsorIndustryExtraSportswear => 'Sportstøj';

  @override
  String get sponsorIndustryExtraAirline => 'Traditionelt flyselskab';

  @override
  String get sponsorIndustryExtraRailway => 'Jernbane';

  @override
  String get sponsorIndustryExtraHotels => 'Hotelkæde';

  @override
  String get sponsorIndustryExtraCoffee => 'Kaffekæde';

  @override
  String get sponsorIndustryExtraChocolate => 'Chokolade';

  @override
  String get sponsorIndustryExtraMineralWater => 'Mineralvand';

  @override
  String get sponsorIndustryExtraPharmacy => 'Apotekskæde';

  @override
  String get sponsorIndustryExtraFashion => 'Mode';

  @override
  String get sponsorIndustryExtraWatches => 'Urmager';

  @override
  String get sponsorIndustryExtraElectronics => 'Elektronik';

  @override
  String get sponsorIndustryExtraSoftware => 'Software';

  @override
  String get sponsorIndustryExtraStreaming => 'Streamingtjeneste';

  @override
  String get sponsorIndustryExtraSocialNetwork => 'Socialt netværk';

  @override
  String get sponsorIndustryExtraFurniture => 'Møbler';

  @override
  String get sponsorIndustryExtraTyres => 'Dæk';

  @override
  String get sponsorIndustryExtraShipping => 'Rederi';

  @override
  String get sponsorIndustryExtraLottery => 'Lotteri';

  @override
  String get sponsorIndustryExtraTourism => 'Turistråd';

  @override
  String get sponsorIndustryExtraCosmetics => 'Kosmetik';

  @override
  String get sponsorIndustryExtraPetFood => 'Dyrefoder';

  @override
  String get sponsorIndustryExtraBakery => 'Bageri';

  @override
  String get sponsorIndustryExtraSupermarket => 'Supermarked';

  @override
  String get sponsorIndustryExtraSportsNutrition => 'Sportsernæring';

  @override
  String get sponsorIndustryExtraWine => 'Vin';

  @override
  String get sponsorIndustryExtraTea => 'Te';

  @override
  String get sponsorIndustryExtraRealEstate => 'Ejendomme';

  @override
  String get sponsorIndustryExtraFitness => 'Fitnesscentre';

  @override
  String get sponsorIndustryExtraNewspaper => 'Avis';
}
