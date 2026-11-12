// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get matchPreviewTitle => 'KAMPFORHÅNDSVISNING';

  @override
  String get matchKickOff => 'Avspark';

  @override
  String get matchTactics => 'Taktikk';

  @override
  String get matchYourXi => 'DIN STARTELLEVER';

  @override
  String get matchHeadToHead => 'INNBYRDES OPPGJØR';

  @override
  String matchCouldNotLoad(String error) {
    return 'Kunne ikke laste kampen.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Ingen kommende kamp.';

  @override
  String get matchUnknownNation => 'Ukjent';

  @override
  String get matchH2hFirstMeeting => 'Første møte noensinne';

  @override
  String get matchH2hYouLead => 'Du leder innbyrdes';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent har overtaket';
  }

  @override
  String get matchH2hEven => 'Likt oppgjør';

  @override
  String matchH2hMet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count møter',
      one: '1 møte',
    );
    return '$_temp0';
  }

  @override
  String get matchH2hWon => 'Seier';

  @override
  String get matchH2hDrawn => 'Uavgjort';

  @override
  String get matchH2hLost => 'Tap';

  @override
  String get matchDossierTitle => 'Speiderrapport';

  @override
  String get matchDossierForm => 'FORM';

  @override
  String get matchDossierNoGames => 'Ingen nylige kamper';

  @override
  String get matchDossierKeyMen => 'NØKKELSPILLERE';

  @override
  String get matchDossierHowTheyPlay => 'SLIK SPILLER DE';

  @override
  String matchScoutFormation1(String formation) {
    return 'De stiller vanligvis opp i $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Den vanlige formasjonen deres er $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'De pleier å stille i $formation.';
  }

  @override
  String get matchScoutStrengthPressing => 'De presser høyt og jager ballen.';

  @override
  String get matchScoutStrengthDirect =>
      'De spiller direkte og får ballen fort framover.';

  @override
  String get matchScoutStrengthPossession =>
      'De holder godt på ballen og bygger tålmodig.';

  @override
  String get matchScoutStrengthCounter => 'De ligger lavt og kontrer raskt.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'De forsvarer dypt og er vanskelige å bryte ned.';

  @override
  String get matchScoutStrengthWide =>
      'De gjør banen bred og angriper på kantene.';

  @override
  String get matchScoutStrengthAttacking =>
      'De liker å ta initiativet og gå på motstanderen.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Spissene deres er raske og elsker å løpe i bakrom.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Midtbanen deres sender ballen godt.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Midtbanen deres orker å løpe hele kampen.';

  @override
  String get matchScoutStrengthSetPieces => 'De er farlige på dødballer.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Forsvarsrekka deres er rask og vanskelig å komme bak.';

  @override
  String get matchScoutStrengthNone =>
      'Ingenting i spillet deres skiller seg virkelig ut.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Den høye forsvarslinja deres gir rom i bakrom for en lang ball.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Høyt press kan forstyrre den trege oppbyggingen deres.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Vær tålmodig: en lav blokk som deres kan spilles i stykker.';

  @override
  String get matchScoutWeakLongBall =>
      'Senk forsvarslinja di, så har de lange ballene deres ingen steder å gå.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Forsvarerne deres mangler fart, så send løpere i bakrom.';

  @override
  String get matchScoutWeakAerial =>
      'De virker usikre når de forsvarer dødballer.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Midtbanen deres sliter med å spille seg ut av press.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Midtbanen deres mangler beina til å holde presset oppe.';

  @override
  String get matchScoutWeakBluntAttack => 'Spissene deres mangler fart.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Mot deg kan du vente at de tar initiativet.';

  @override
  String get matchScoutApproachEven =>
      'Mot deg kan du vente en jevn og tett kamp.';

  @override
  String get matchScoutApproachSitDeep =>
      'Mot deg kan du vente at de er forsiktige og ser etter kontringer.';

  @override
  String get matchScoutLeaningAttacking =>
      'På avstand ser de ut som et offensivt lag.';

  @override
  String get matchScoutLeaningCautious =>
      'På avstand ser de ut som et forsiktig lag.';

  @override
  String get matchScoutLeaningUnclear =>
      'På avstand er det vanskelig å si hvordan de liker å spille.';

  @override
  String get matchScoutHireHint =>
      'Ansett en sjefsscout for å finne ut hvordan de spiller.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Kunne ikke fortsette: $error';
  }

  @override
  String get matchSkipToFullTime => 'Hopp til full tid';

  @override
  String get matchStatShots => 'Skudd';

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
    return 'VERDENSMESTERSKAPET $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'SLUTTSPILLET ER HER';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'ARRANGERT AV  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'VERT BEKREFTES SENERE';

  @override
  String get matchHalfTime => 'PAUSE';

  @override
  String matchHalfTimeScore(int home, int away) {
    return 'Pause $home : $away';
  }

  @override
  String get matchContinue => 'Fortsett';

  @override
  String get matchContinuing => 'Fortsetter…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktikk · $used/$max bytter';
  }

  @override
  String matchTiredCount(int count) {
    return 'TRETTE ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIKK';

  @override
  String get teamOverallOverTime => 'HELHETSVURDERING OVER TID';

  @override
  String get teamOverall => 'Helhetsvurdering';

  @override
  String get teamTalkHeading => 'LAGSAMTALE';

  @override
  String get teamTalkPrompt => 'Sett tonen for andre omgang.';

  @override
  String get teamTalkCalmLabel => 'Kjølig hode';

  @override
  String get teamTalkCalmBlurb =>
      'Demp uroen i laget. Et lite løft over hele linja.';

  @override
  String get teamTalkEncourageLabel => 'Oppmuntre';

  @override
  String get teamTalkEncourageBlurb => 'Press frem og gå for kampen.';

  @override
  String get teamTalkDemandMoreLabel => 'Krev mer';

  @override
  String get teamTalkDemandMoreBlurb => 'Kast alt inn. Angrip hardt.';

  @override
  String get teamTalkPraiseLabel => 'Hold tett';

  @override
  String get teamTalkPraiseBlurb => 'Stå kompakt og forsvar det dere har.';

  @override
  String get teamTalkBelieveLabel => 'Tro på det';

  @override
  String get teamTalkBelieveBlurb =>
      'Tro på dere selv. Et løft i begge ender av banen.';

  @override
  String get teamTalkFocusLabel => 'Vær skjerpet';

  @override
  String get teamTalkFocusBlurb => 'Full konsentrasjon. Lås kampen.';

  @override
  String get teamTalkUrgencyLabel => 'Hast';

  @override
  String get teamTalkUrgencyBlurb => 'Jag nå. Alt inn, men det gir rom bak.';

  @override
  String get teamTalkReassureLabel => 'Ingen press';

  @override
  String get teamTalkReassureBlurb => 'Roe nervene og hold formasjonen.';

  @override
  String get commonRetry => 'Prøv igjen';

  @override
  String get commonSomethingWentWrong => 'Noe gikk galt';

  @override
  String get commonCrashBox =>
      'Noe gikk galt her.\nInnstillinger → Diagnostikk har detaljene.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Kunne ikke føre verden videre: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostikk';

  @override
  String get settingsDiagnosticsBlurb =>
      'Feil registrert på denne enheten. Ingenting sendes noe sted.';

  @override
  String get settingsContactTitle => 'Kontakt';

  @override
  String get settingsContactCopied => 'Adressen er kopiert.';

  @override
  String get settingsCommunityTitle => 'Fellesskap';

  @override
  String get settingsDiscordSubtitle => 'Bli med i fellesskapet';

  @override
  String get settingsLinkCopied => 'Lenken er kopiert.';

  @override
  String get diagnosticsEmpty => 'Ingen feil registrert. Det er poenget.';

  @override
  String get diagnosticsCopy => 'Kopier';

  @override
  String get diagnosticsCopied => 'Loggen er kopiert til utklippstavlen.';

  @override
  String get diagnosticsClear => 'Tøm';

  @override
  String get navHub => 'Hjem';

  @override
  String get navSquad => 'Tropp';

  @override
  String get navStandings => 'Tabeller';

  @override
  String get navCareers => 'Min karriere';

  @override
  String get settingsTitle => 'INNSTILLINGER';

  @override
  String get settingsSoundHapticsTitle => 'Lyd og vibrasjon';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibrasjon og en kort tone ved mål, avspark og full tid.';

  @override
  String get settingsMatchSoundTitle => 'Stadionlyd';

  @override
  String get settingsMatchSoundBlurb =>
      'Publikum og dommerens fløyte under kampene.';

  @override
  String get settingsMatchSoundVolume => 'Volum';

  @override
  String get settingsLanguageTitle => 'Språk';

  @override
  String get settingsLanguageBlurb => 'Velg appspråk, eller følg enheten din.';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsTextSizeTitle => 'Tekststørrelse';

  @override
  String get settingsTextSizeBlurb =>
      'Gjør teksten større hvis den er vanskelig å lese.';

  @override
  String get settingsTextSizeNormal => 'Normal';

  @override
  String get settingsTextSizeLarge => 'Stor';

  @override
  String get settingsTextSizeLarger => 'Større';

  @override
  String get matchPreviewAllMeetings => 'Alle møter';

  @override
  String get recordsMeetings => 'MØTER';

  @override
  String get recordsLegends => 'LEGENDER';

  @override
  String get recordsAllTimeXi => 'ALLTIDSLAGET';

  @override
  String get recordsHallOfFame => 'HALL OF FAME';

  @override
  String get recordsAllTimeWorld => 'ALLTIDSREKORDER, VERDEN';

  @override
  String get recordsAllTimeTopScorers => 'TIDENES TOPPSCORERE';

  @override
  String get recordsMostCapped => 'FLEST LANDSKAMPER';

  @override
  String get recordsMostWcStarts => 'FLEST STARTER I VM';

  @override
  String get recordsMostTournaments => 'FLEST TURNERINGER';

  @override
  String get recordsRecordBook => 'REKORDBOK';

  @override
  String get recordsHeadToHead => 'INNBYRDES OPPGJØR';

  @override
  String get recordsFiercestRival => 'STØRSTE RIVAL';

  @override
  String get recordsMostCaps => 'FLEST LANDSKAMPER';

  @override
  String get recordsTopScorers => 'TOPPSCORERE';

  @override
  String get recordsMostAssists => 'FLEST ASSIST';

  @override
  String get recordsYourRecord => 'DIN REKORD';

  @override
  String get callUpHome => 'HJEMME';

  @override
  String get callUpAway => 'BORTE';

  @override
  String get recordsHome => 'HJEMME';

  @override
  String get recordsAway => 'BORTE';

  @override
  String get recordsActive => 'AKTIV';

  @override
  String get recordsStillActive => 'Fortsatt aktiv';

  @override
  String get recordsAvg => 'snitt';

  @override
  String get recordsSelect => 'Velg';

  @override
  String get recordsVs => 'mot';

  @override
  String get recordsDraws => 'Uavgjort';

  @override
  String get recordsGoalsLabel => 'Mål';

  @override
  String get recordsBestFinish => 'Beste plassering';

  @override
  String get recordsNoFinalsYet => 'Ingen sluttspilldeltakelse ennå';

  @override
  String get recordsLongestUnbeaten => 'Lengste ubeseirede rekke';

  @override
  String get recordsBiggestWin => 'Største seier';

  @override
  String get recordsSeeAllMeetings => 'Se alle møter';

  @override
  String get recordsSaveNotFound => 'Fant ikke lagringen.';

  @override
  String get recordsNoMatches => 'Ingen treff.';

  @override
  String get recordsSearchPlayerOrNation => 'Søk etter spiller eller land';

  @override
  String get recordsSearchNation => 'Søk etter land';

  @override
  String get recordsPickTwoDifferent => 'Velg to ulike land.';

  @override
  String get recordsPlayToBuildRecord =>
      'Spill noen kamper, så bygges rekorden din mot hver motstander opp her.';

  @override
  String get recordsTapOpponent =>
      'Trykk på en motstander for hele oversikten.';

  @override
  String get recordsEdgeUpperHand => 'Du har overtaket';

  @override
  String get recordsEdgeTheirNumber => 'De har taket på deg';

  @override
  String get recordsEdgeEven => 'Likt oppgjør';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Globale målscorere og flest landskamper, alle land';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Sammenlign alltidsrekorden til to land';

  @override
  String get recordsLegendsSubtitle => 'Alltidslaget og hall of fame';

  @override
  String get recordsUnitGoals => 'mål';

  @override
  String get recordsUnitCaps => 'landskamper';

  @override
  String get recordsUnitStarts => 'starter';

  @override
  String get recordsUnitCups => 'turneringer';

  @override
  String get recordsUnitAssists => 'assist';

  @override
  String recordsCapsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count landskamper',
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
    return '$count assist';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count kampens spiller';
  }

  @override
  String recordsMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kamper',
      one: '1 kamp',
    );
    return '$_temp0';
  }

  @override
  String recordsMeetingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count møter',
      one: '1 møte',
    );
    return '$_temp0';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code seiere';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings møter',
      one: '1 møte',
    );
    return '$_temp0 · ${wins}S ${draws}U ${losses}T';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}S ${draws}U ${losses}T';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings møter',
      one: '1 møte',
    );
    return '$_temp0 · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a og $b har aldri møtt hverandre i denne lagringen.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names utvist. Ingen erstatter, så dere spiller med en mann mindre.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Trenger $required tilgjengelige ($have friske)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Går glipp av $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Ute i hele dette uttaket';

  @override
  String get rankingCentreOnMe => 'Gå til mitt land';

  @override
  String get recordsAfterExtraTime => 'e.o.';

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
    return '$played spilt · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga mot $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Kunne ikke laste.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Kunne ikke laste legender.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Kunne ikke laste rekorder.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Kunne ikke laste land.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Kunne ikke laste rekorden din.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Kunne ikke laste rekorden.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Ingen legender ennå. Spill noen kampanjer, så dukker de store navnene fra $nation opp her.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Det beste laget $nation noen gang kunne stilt.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Verden har ingen historie ennå. Spill noen kampanjer, så dukker alle tiders store navn opp her.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Spill noen kamper for å begynne å skrive historien til $nation.';
  }

  @override
  String get tacticsLineGk => 'MV';

  @override
  String get tacticsLineDef => 'FO';

  @override
  String get tacticsLineMid => 'MB';

  @override
  String get tacticsLineFwd => 'AN';

  @override
  String get tacticsGoalkeepers => 'KEEPERE';

  @override
  String get tacticsDefenders => 'FORSVARERE';

  @override
  String get tacticsMidfielders => 'MIDTBANESPILLERE';

  @override
  String get tacticsForwards => 'ANGRIPERE';

  @override
  String get tacticsCallUpsTitle => 'UTTAK';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Velg minst $min spillere.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Kunne ikke laste troppen.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Ingen tropp.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'TROPP · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Maks $max';
  }

  @override
  String get tacticsBestQuality => 'Best kvalitet';

  @override
  String get tacticsPreviousSquad => 'Forrige tropp';

  @override
  String get tacticsSquadLockedBack => 'Tilbake (tropp låst)';

  @override
  String get tacticsConfirmSquad => 'Offentliggjør troppen';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Troppen er full (maks $max)';
  }

  @override
  String get tacticsSquadLocked => 'TROPP LÅST';

  @override
  String get tacticsNominationOpen => 'UTTAKET ER ÅPENT. VELG TROPPEN DIN';

  @override
  String get tacticsSquadFixedBlurb =>
      'Denne troppen er låst for kampene under. Velg på nytt før neste uttaksvindu.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Denne troppen skal spille kampene under.';

  @override
  String get tacticsUnknown => 'Ukjent';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Alder $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Utslitt';

  @override
  String get tacticsFatigueTired => 'Sliten';

  @override
  String get tacticsFatigueMatchLegs => 'Kamptunge ben';

  @override
  String tacticsTooManySubs(int max) {
    return 'For mange bytter (maks $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIKK · $minute\'';
  }

  @override
  String get tacticsApply => 'BRUK';

  @override
  String get tacticsTabLineupSubs => 'LAGUTTAK OG BYTTER';

  @override
  String get tacticsTabTactics => 'TAKTIKK';

  @override
  String get squadLineKeepers => 'KEEPERE';

  @override
  String get squadLineDefenders => 'FORSVAR';

  @override
  String get squadLineMidfielders => 'MIDTBANE';

  @override
  String get squadLineForwards => 'ANGREP';

  @override
  String get squadStatXiRating => 'Elleverkarakter';

  @override
  String get squadStatAvgAge => 'Snittalder';

  @override
  String get squadStatSize => 'Tropp';

  @override
  String get squadStatUnavailable => 'Ute';

  @override
  String get squadDepthTitle => 'BREDDE PER LINJE';

  @override
  String squadAgeShort(int age) {
    return '$age år';
  }

  @override
  String get tacticsTabOtherPositions => 'ANDRE PLASSER';

  @override
  String get tacticsOutOfPositionNote => 'Ute av posisjon her';

  @override
  String get tacticsNobodyElse => 'Ingen andre å prøve her.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Velg hvem som går av, så vises resten av benken her, med karakteren de ville fått på denne plassen.';

  @override
  String get tacticsTabSuitable => 'EGNET';

  @override
  String get tacticsTabOnPitch => 'PÅ BANEN';

  @override
  String tacticsSectionSuitable(int count) {
    return 'EGNET · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Ingen på benken passer naturlig på denne plassen, så her er alle.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'PÅ BANEN · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'TILGJENGELIG · $count';
  }

  @override
  String get tacticsRowStarted => 'Startet';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Inn i $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Byttet inn';

  @override
  String get tacticsEnergyLabel => 'ENERGI';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Trykk på en erstatter for $name, eller trykk på ham igjen for å avbryte.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Et rødt kort kostet deg denne plassen. Dra en lagkamerat hit for å flytte hullet.';

  @override
  String get tacticsSentOffShort => 'UTVIST';

  @override
  String get tacticsFullBackLeft => 'Venstreback';

  @override
  String get tacticsFullBackRight => 'Høyreback';

  @override
  String get tacticsFullBackUp => 'Gå med fram';

  @override
  String get tacticsFullBackDown => 'Bli hjemme';

  @override
  String get tacticsFullBackOff => 'Ingen instruks';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: gå med fram. Litt mer angrep, litt mer risiko.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: bli hjemme. Litt tryggere, litt mindre angrep.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: ingen instruks, spiller etter lagets plan.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, pil: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'BYTTER · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Trykk på en spiller på banen for å ta ham av, eller hold og dra en innbytter over ham.';

  @override
  String get tacticsNoSubs => 'Ingen innbyttere tilgjengelig.';

  @override
  String get tacticsChooseShape => 'VELG FORMASJON';

  @override
  String get tacticsFormation => 'FORMASJON';

  @override
  String get tacticsInstructions => 'INSTRUKSER';

  @override
  String get tacticsDrilling => 'INNØVING';

  @override
  String get tacticsDrillingUnplayed => 'UPRØVD';

  @override
  String get tacticsDrillingNew => 'NY';

  @override
  String get tacticsDrillingSettling => 'SETTER SEG';

  @override
  String get tacticsDrillingDrilled => 'INNØVD';

  @override
  String get tacticsInstrMentality => 'Mentalitet';

  @override
  String get tacticsInstrDefensive => 'Defensiv';

  @override
  String get tacticsInstrAttacking => 'Offensiv';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Lav blokk';

  @override
  String get tacticsInstrHighPress => 'Høy press';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Tålmodig';

  @override
  String get tacticsInstrFast => 'Raskt';

  @override
  String get tacticsInstrWidth => 'Bredde';

  @override
  String get tacticsInstrNarrow => 'Smal';

  @override
  String get tacticsInstrWide => 'Bred';

  @override
  String get tacticsInstrDefLine => 'Forsv.linje';

  @override
  String get tacticsInstrDefensiveLine => 'Forsvarslinje';

  @override
  String get tacticsInstrDeep => 'Lav';

  @override
  String get tacticsInstrHigh => 'Høy';

  @override
  String get tacticsInstrDirectness => 'Direktespill';

  @override
  String get tacticsInstrPossession => 'Ballbesittelse';

  @override
  String get tacticsInstrDirect => 'Direkte';

  @override
  String get tacticsPickGoalkeeper => 'VELG KEEPER';

  @override
  String get tacticsPickLeftBack => 'VELG VENSTREBACK';

  @override
  String get tacticsPickCentreBack => 'VELG MIDTSTOPPER';

  @override
  String get tacticsPickRightBack => 'VELG HØYREBACK';

  @override
  String get tacticsPickDefensiveMid => 'VELG DEFENSIV MIDTBANE';

  @override
  String get tacticsPickCentralMid => 'VELG SENTRAL MIDTBANE';

  @override
  String get tacticsPickAttackingMid => 'VELG OFFENSIV MIDTBANE';

  @override
  String get tacticsPickLeftMid => 'VELG VENSTRE MIDTBANE';

  @override
  String get tacticsPickRightMid => 'VELG HØYRE MIDTBANE';

  @override
  String get tacticsPickLeftWing => 'VELG VENSTRE KANT';

  @override
  String get tacticsPickRightWing => 'VELG HØYRE KANT';

  @override
  String get tacticsPickStriker => 'VELG SPISS';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · ute av posisjon';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Alder $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Alder $age';
  }

  @override
  String get tacticsOn => 'PÅ';

  @override
  String get tacticsSquad => 'TROPP';

  @override
  String get tacticsTabLineup => 'LAGUTTAK';

  @override
  String get tacticsTabInstructions => 'INSTRUKSER';

  @override
  String get tacticsTabRoles => 'ROLLER';

  @override
  String get tacticsTabSetPieces => 'DØDBALLER';

  @override
  String get tacticsTabRolesSetPieces => 'ROLLER OG DØDBALLER';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Gi hver startspiller en rolle. Trykk på straffe- (⚽) eller frisparkmerket (▲) for å velge utfører.';

  @override
  String get tacticsTooltipCallUps => 'Uttak';

  @override
  String get tacticsTooltipPresets => 'Taktikkmaler';

  @override
  String get tacticsTooltipInstructions => 'Instrukser';

  @override
  String get tacticsNoTacticSet => 'Ingen taktikk valgt.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ERSTATT $count STARTSPILLERE',
      one: 'ERSTATT $count STARTSPILLER',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Ute';

  @override
  String get tacticsTapSpotReplace =>
      'Trykk på plassen deres på banen for å velge en erstatter.';

  @override
  String get tacticsTapOrDrag =>
      'Trykk på en spiller for å bytte ham ut, eller hold og dra for å flytte ham.';

  @override
  String get tacticsPlayerRoles => 'SPILLERROLLER';

  @override
  String get tacticsRolesBlurb =>
      'Gi en spiller en jobb: en målrev, en regissør, en targetspiss. Påvirker hvem som scorer og hvem som skaper.';

  @override
  String get tacticsSetPieceTakers => 'DØDBALLUTFØRERE';

  @override
  String get tacticsSetPieceBlurb =>
      'Hvem som tar straffer og dødballer, eller overlat det til den best egnede spilleren.';

  @override
  String get tacticsTakerAuto => 'Automatisk';

  @override
  String get tacticsTakerQuickPick => 'Bruk beste utførere';

  @override
  String get tacticsPenalties => 'Straffer';

  @override
  String get tacticsCornersFreeKicks => 'Hjørnespark og frispark';

  @override
  String get tacticsThrowIns => 'Innkast';

  @override
  String get tacticsThrowInStyle => 'Innkaststil';

  @override
  String get tacticsThrowInLong => 'Lange innkast';

  @override
  String get tacticsThrowInNeutral => 'Nøytral';

  @override
  String get tacticsThrowInDefensive => 'Sikre innkast';

  @override
  String get tacticsThrowInLongBlurb =>
      'Innkast nær feltet går inn i feltet. Litt mer fare, særlig med en sterk kaster og høye angripere, men ballen mistes litt oftere.';

  @override
  String get tacticsThrowInNeutralBlurb =>
      'Innkast slik spillet tillater. Ingenting endres.';

  @override
  String get tacticsThrowInDefensiveBlurb =>
      'Hvert innkast kort og sikkert. Færre balltap å bli kontret på, og litt færre sjanser.';

  @override
  String get matchGoalLongThrow => 'LANGT INNKAST';

  @override
  String get tacticsSkillFin => 'AVS';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROLLE · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'STRAFFEUTFØRER';

  @override
  String get tacticsCornerFreeKickTaker => 'HJØRNE- OG FRISPARKUTFØRER';

  @override
  String get tacticsAutomatic => 'Automatisk';

  @override
  String get tacticsLetBestSuited => 'La den best egnede spilleren ta det.';

  @override
  String get tacticsInXi => 'I ELLEVER';

  @override
  String get tacticsTeamInstructions => 'LAGINSTRUKSER';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Bestem hvordan laget spiller. Hver knapp justerer hele laget.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Lagret «$name»';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Brukte «$name»';
  }

  @override
  String get tacticsTacticPresets => 'TAKTIKKMALER';

  @override
  String get tacticsPresetsBlurb =>
      'Lagre denne formasjonen som en gjenbrukbar stil, eller bruk en du har lagret tidligere.';

  @override
  String get tacticsSaveCurrentTactic => 'Lagre gjeldende taktikk';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Kunne ikke laste malene.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Ingen maler ennå. Trykk på «Lagre gjeldende taktikk» for å lagre oppsettet som en gjenbrukbar stil.';

  @override
  String get tacticsNameThisTactic => 'Gi taktikken et navn';

  @override
  String get tacticsNameHint => 'f.eks. Høy press 4-3-3';

  @override
  String get tacticsCancel => 'Avbryt';

  @override
  String get tacticsSave => 'Lagre';

  @override
  String get tacticsTapToAssign => 'Trykk for å tildele';

  @override
  String get tacticsHoldDragSub =>
      'Hold en innbytter, og dra ham over en spiller for å sette ham inn.';

  @override
  String get hubContinue => 'Fortsett';

  @override
  String get hubBrackets => 'Turneringstrær';

  @override
  String hubCouldNotLoad(String error) {
    return 'Kunne ikke laste.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Kunne ikke laste økonomien.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Kunne ikke laste lagringen.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Fant ikke lagringen.';

  @override
  String get hubUnknown => 'Ukjent';

  @override
  String hubWorldChampionsYear(int year) {
    return 'VERDENSMESTERE $year';
  }

  @override
  String get hubCycleComplete => 'Syklusen er fullført.';

  @override
  String get hubYourJob => 'JOBBEN DIN';

  @override
  String get hubStayProject => 'Bli og fortsett prosjektet ditt';

  @override
  String get hubChooseNextJob => 'VELG NESTE JOBB';

  @override
  String get hubOffersOnTable => 'TILBUD PÅ BORDET';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · verden #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Fortsett med $nation';
  }

  @override
  String get hubYourNation => 'landet ditt';

  @override
  String get hubTakeTheJob => 'Ta jobben';

  @override
  String get hubFederationFinances => 'FORBUNDSØKONOMI';

  @override
  String get hubBudgetIntro =>
      'Din første jobb neste syklus er å fastsette forbundsbudsjettet og fordele det på avdelingene.';

  @override
  String get hubStarting => 'Starter…';

  @override
  String get hubBeginNextCycle => 'Start neste syklus';

  @override
  String get hubContinueCareer => 'Fortsett karrieren din';

  @override
  String get hubBackToSaves => 'Tilbake til lagringene dine';

  @override
  String get hubOpeningBalance => 'Inngående saldo';

  @override
  String get hubCentralFunding => 'Sentral støtte';

  @override
  String get hubPrizeMoney => 'Premiepenger';

  @override
  String get hubCommercialReturn => 'Kommersiell avkastning';

  @override
  String get hubAvailableToInvest => 'Tilgjengelig å investere';

  @override
  String hubReputation(String label, int rep) {
    return 'Omdømme: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Nasjonalhelt';

  @override
  String get hubFinal => 'Finale';

  @override
  String get hubStageRoundOf32 => '32-delsfinale';

  @override
  String get hubStageThirdPlace => 'Bronsefinale';

  @override
  String get hubEventAdvanceWorld => 'Før verden videre';

  @override
  String hubEventStartCycle(int year) {
    return 'Start syklusen for $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation er verdensmestere';
  }

  @override
  String get hubEventSetBudget => 'Fastsett forbundsbudsjettet';

  @override
  String get hubEventSetBudgetSub =>
      'Fordel syklusens krigskasse før sesongen starter';

  @override
  String get hubEventNaturalization => 'Vurder naturaliseringstilbud';

  @override
  String get hubEventNaturalizationSub =>
      'En utenlandsk spiller vil bytte landslag til deg';

  @override
  String get hubEventCampaignVerdict => 'Kampanjen er avgjort: se dommen';

  @override
  String get hubEventCampaignComplete => 'Kampanjen er fullført';

  @override
  String get hubEventIntercontinentalPlayoff =>
      'Det interkontinentale playoffet';

  @override
  String get hubEventWatchWcDraw => 'Se trekningen til Verdensmesterskapet';

  @override
  String get hubEventWorldCupHere => 'Verdensmesterskapet er her';

  @override
  String get hubEventWatchFinalsDraw => 'Se sluttspilltrekningen';

  @override
  String get hubEventFinalsHere => 'Sluttspillet er her';

  @override
  String get hubEventPlayWcRound => 'Spill neste runde i Verdensmesterskapet';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Spill neste kamp i $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch => 'Spill neste kamp i Nations Cup';

  @override
  String get hubEventWatchNationsCupDraw => 'Se trekningen til Nations Cup';

  @override
  String get hubEventWatchHostSelection => 'Se valget av vert';

  @override
  String get hubEventWatchQualifyingDraw => 'Se kvalifiseringstrekningen';

  @override
  String get hubEventWatchWcHostSelection =>
      'Se valget av vert for Verdensmesterskapet';

  @override
  String get hubEventWatchWcQualifyingDraw => 'Se VM-kvalifiseringstrekningen';

  @override
  String get hubEventArrangeFriendlies => 'Sett opp treningskamper';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du har ikke fylt de $count åpne vinduene for treningskamper ennå',
      one: 'Du har ikke fylt det åpne vinduet for treningskamper ennå',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Omform startelleveren';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count i startelleveren din er ute (suspendert eller skadet). Velg erstattere',
      one:
          '1 i startelleveren din er ute (suspendert eller skadet). Velg erstatter',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Startelleveren din er ikke full. Fyll de åpne plassene',
      one: 'Startelleveren din er ikke full. Fyll den åpne plassen',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Spill mot $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback =>
      'det kontinentale sluttspillet';

  @override
  String get hubCallUpFriendlies => 'Ta ut troppen til treningskampene';

  @override
  String get hubCallUpRequalify => 'Ta ut kvalifiseringstroppen på nytt';

  @override
  String get hubCallUpWorldCup => 'Ta ut troppen til Verdensmesterskapet';

  @override
  String get hubCallUpFinals => 'Ta ut troppen til sluttspillet';

  @override
  String get hubCallUpNationsCup => 'Ta ut troppen til Nations Cup';

  @override
  String get hubCallUpQualifying => 'Ta ut kvalifiseringstroppen';

  @override
  String get hubCallUpGeneric => 'Ta ut troppen';

  @override
  String get hubHost => 'Vert';

  @override
  String get hubGoldenBoot => 'Toppscorer';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals mål';
  }

  @override
  String get hubPens => '(str.)';

  @override
  String get hubNationalHub => 'FORBUNDSKONTORET';

  @override
  String get hubMessages => 'Meldinger';

  @override
  String get hubWorldChampions => 'VERDENSMESTERE';

  @override
  String get hubViewBracket => 'Se turneringstreet ›';

  @override
  String get hubBoardDelighted => 'Henrykt';

  @override
  String get hubBoardPleased => 'Fornøyd';

  @override
  String get hubBoardExpectingMore => 'Forventer mer';

  @override
  String get hubBoardConcerned => 'Bekymret';

  @override
  String get hubBoardJobAtRisk => 'Jobben i fare';

  @override
  String get hubBoard => 'STYRET';

  @override
  String get hubFunds => 'MIDLER';

  @override
  String hubBoardObjective(String label) {
    return 'Styrets mål: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'OPPNÅDD · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'IKKE NÅDD · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Ingen flere kamper i denne syklusen.';

  @override
  String get hubVs => 'MOT';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Verdensrankingen';

  @override
  String get hubSquadStatus => 'TROPPSTATUS';

  @override
  String hubPlayers(int count) {
    return '$count spillere';
  }

  @override
  String get hubAvgRating => 'Snittkarakter';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Styr laget';

  @override
  String get hubGroupsToBeDrawn =>
      'Gruppene skal trekkes. Se trekningen for å avsløre dem.';

  @override
  String hubGroupName(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get hubTblTeam => 'LAG';

  @override
  String get hubTblP => 'K';

  @override
  String get hubTblGd => '+/-';

  @override
  String get hubTblPts => 'P';

  @override
  String get homeSettings => 'Innstillinger';

  @override
  String get homeLeadTheNation => 'LED LANDET';

  @override
  String get homeYourNation => 'landet ditt';

  @override
  String get homeNewGame => 'Nytt spill';

  @override
  String get homeAllSaves => 'Alle lagringer';

  @override
  String get homeLoadGame => 'Last inn spill';

  @override
  String get homeContinue => 'FORTSETT';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Veien til Verdensmesterskapet $year';
  }

  @override
  String get careerManageSaves => 'Administrer lagringer';

  @override
  String get careerNewGameTitle => 'NYTT SPILL';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Kunne ikke laste landet.\n$error';
  }

  @override
  String get careerNationNotFound => 'Fant ikke landet.';

  @override
  String careerWorldRankNum(int rank) {
    return 'VERDENSRANKING #$rank';
  }

  @override
  String get careerManagerName => 'Navn på landslagssjef';

  @override
  String get careerManagerNameHint => 'f.eks. Martin';

  @override
  String get careerBeginsBlurb =>
      'Karrieren din starter i september 2026, på veien mot Verdensmesterskapet 2030.';

  @override
  String get careerFreeCycleNote =>
      'Gratis i én full fireårssyklus: kvalifisering, kontinentalt mesterskap og Verdensmesterskapet, på to lagringer. Etter det låser én betaling opp endeløse sykluser.';

  @override
  String get careerStartCareer => 'Start karrieren';

  @override
  String get careersTitle => 'KARRIERER';

  @override
  String get careerManagerCareer => 'Trenerkarriere';

  @override
  String get careerManagerCareerSubtitle =>
      'Hver syklus du har ledet og din samlede statistikk';

  @override
  String get careerSummaryTitle => 'Karrieresammendrag';

  @override
  String get careerSummarySubtitle => 'Pokalskapet ditt og trenerrekorden';

  @override
  String get careerAchievements => 'Prestasjoner';

  @override
  String get careerAchievementsSubtitle =>
      'Milepæler, titler og styrets tilfredshet';

  @override
  String get careerChallenges => 'Utfordringer';

  @override
  String get careerChallengesSubtitle =>
      'Brutale tester gjennom hele karrieren';

  @override
  String get careerTeamRecords => 'Lagrekorder';

  @override
  String get careerTeamRecordsSubtitle =>
      'Tidenes toppscorere og flest landskamper';

  @override
  String get careerMyMatches => 'Mine kamper';

  @override
  String get careerMyMatchesSubtitle => 'Alle resultater og kommende kamper';

  @override
  String get careerTitle => 'KARRIERE';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Kunne ikke laste karrieren.\n$error';
  }

  @override
  String get careerNoCareer => 'Ingen karriere.';

  @override
  String get careerTrophyCabinet => 'POKALSKAP';

  @override
  String get careerTournamentHistory => 'TURNERINGSHISTORIE';

  @override
  String get careerNoTournamentsYet => 'Ingen turneringer fullført ennå.';

  @override
  String get careerTeamFallback => 'Lag';

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
    return 'SESONG $season';
  }

  @override
  String get careerStatPlayedShort => 'K';

  @override
  String get careerStatsHeading => 'I TALL';

  @override
  String get careerStatsWinRate => 'Seiersandel';

  @override
  String get careerStatsGoalsFor => 'Scorede mål';

  @override
  String get careerStatsGoalsAgainst => 'Innsluppne mål';

  @override
  String get careerStatsGoalDiff => 'Målforskjell';

  @override
  String get careerStatsCleanSheets => 'Holdt nullen';

  @override
  String get careerStatsBiggestWin => 'Største seier';

  @override
  String get careerStatsWinStreak => 'Seiersrekke';

  @override
  String get careerStatsUnbeaten => 'Ubeseiret rekke';

  @override
  String get careerStatsShootouts => 'Straffekonk.';

  @override
  String get careerStatsHatTricks => 'Hat tricks';

  @override
  String get careerStatsMotms => 'Kampens spiller';

  @override
  String get careerStatsBestRating => 'Beste karakter';

  @override
  String get careerStatWonShort => 'S';

  @override
  String get careerStatDrawnShort => 'U';

  @override
  String get careerStatLostShort => 'T';

  @override
  String get careerStatGoalsForShort => 'MS';

  @override
  String get careerStatGoalsAgainstShort => 'MI';

  @override
  String get careerStatGoalDiffShort => '+/-';

  @override
  String get careerNoSilverware => 'Ingen pokaler ennå. Gå og vinn en.';

  @override
  String get careerMedalGold => 'GULL';

  @override
  String get careerMedalSilver => 'SØLV';

  @override
  String get careerMedalBronze => 'BRONSE';

  @override
  String careerWinnersName(String name) {
    return 'Vinnere: $name';
  }

  @override
  String get careerSavesTitle => 'LAGRINGER';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Kunne ikke laste lagringene.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'PLASSER  $used/$limit';
  }

  @override
  String get careerThisSave => 'denne lagringen';

  @override
  String get careerSlotsFull => 'Alle plasser er brukt';

  @override
  String careerSlotsUsed(int used) {
    return 'PLASSER  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Lås opp flere lagringer';

  @override
  String get careerSlotsKeepNote =>
      'Alle lagringene du allerede har, kan fortsatt spilles. Bare en ny krever opplåsing.';

  @override
  String get careerNewGame => 'Nytt spill';

  @override
  String get careerDeleteSaveTitle => 'Slette lagringen?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Dette sletter karrieren din med $label for godt.';
  }

  @override
  String get careerCancel => 'Avbryt';

  @override
  String get careerDelete => 'Slett';

  @override
  String get careerNoSavesYet =>
      'Ingen lagringer ennå.\nStart et nytt spill for å lede et land.';

  @override
  String get careerUnknownNation => 'Ukjent';

  @override
  String careerPlayedMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '${hours}t ${minutes}m';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Sist spilt $when';
  }

  @override
  String get careerJustNow => 'nå nettopp';

  @override
  String get careerYesterday => 'i går';

  @override
  String careerMinutesAgo(int n) {
    return 'for $n min siden';
  }

  @override
  String careerHoursAgo(int n) {
    return 'for $n t siden';
  }

  @override
  String careerDaysAgo(int n) {
    return 'for $n d siden';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Veien til Verdensmesterskapet $year';
  }

  @override
  String homeNextFixture(String match, String when) {
    return 'Neste: $match, $when';
  }

  @override
  String homeCycleComplete(int year) {
    return 'Verdensmesterskapet $year er over. Nå venter styrets dom.';
  }

  @override
  String homeFollowingFinals(int year) {
    return 'Verdensmesterskapet $year fra tribunen';
  }

  @override
  String get careerManagerCareerTitle => 'TRENERKARRIERE';

  @override
  String careerCouldNotLoad(String error) {
    return 'Kunne ikke laste.\n$error';
  }

  @override
  String get careerCycleByCycle => 'SYKLUS FOR SYKLUS';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles sykluser',
      one: '1 syklus',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations land ledet',
      one: '1 land ledet',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Titler';

  @override
  String get careerStatPlayed => 'Kamper';

  @override
  String get careerStatWon => 'Seiere';

  @override
  String get careerStatDrawn => 'Uavgjort';

  @override
  String get careerStatLost => 'Tap';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Mål $goalsFor–$goalsAgainst  ($gd)  ·  Seiersandel $winRate %';
  }

  @override
  String get careerRecordResults => 'REKORDRESULTATER';

  @override
  String get careerBestWin => 'Beste seier';

  @override
  String get careerWorstDefeat => 'Verste tap';

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
    return '${won}S ${drawn}U ${lost}T  ·  MS $goalsFor MI $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Verdensmesterskapet';

  @override
  String get careerContinentalLabel => 'Kontinentalt';

  @override
  String get messagesTitle => 'MELDINGER';

  @override
  String get messagesNoMessagesYet => 'Ingen meldinger ennå.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Kunne ikke laste meldingene.\n$error';
  }

  @override
  String get messagesDone => 'Ferdig';

  @override
  String get messagesNext => 'Neste';

  @override
  String get rankingWorldRanking => 'VERDENSRANKING';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Kunne ikke laste rankingen.\n$error';
  }

  @override
  String get rankingNoRanking => 'Ingen ranking.';

  @override
  String get rankingAll => 'ALLE';

  @override
  String get rankingYourTeam => 'DITT LAG';

  @override
  String get rankingYourRankingOverTime => 'RANKINGEN DIN OVER TID';

  @override
  String rankingNowRank(int rank) {
    return 'nå #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'best #$best · dårligst #$worst';
  }

  @override
  String get friendliesTitle => 'TRENINGSKAMPER';

  @override
  String friendliesLoadError(String error) {
    return 'Kunne ikke laste treningskampene.\n$error';
  }

  @override
  String get friendliesContinue => 'Fortsett';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ledige vinduer',
      one: '1 ledig vindu',
    );
    return 'Sett opp oppvarmingskamper for $_temp0 før neste kamp om poeng. Trykk på en motstander, eller la den stå åpen.';
  }

  @override
  String get friendliesFree => 'Ledig';

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
  String get matchGoalSetPiece => 'DØDB';

  @override
  String matchGoalAssist(String name) {
    return 'assist $name';
  }

  @override
  String get friendliesHome => 'HJEMME';

  @override
  String get friendliesAway => 'BORTE';

  @override
  String get friendliesNoneThisWindow => 'Ingen treningskamper i dette vinduet';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count treningskamper',
      one: '1 treningskamp',
    );
    return 'Bekreft $_temp0';
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
  String get friendliesMonthMay => 'Mai';

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
  String get friendliesMonthDec => 'Des';

  @override
  String get resultsMyMatches => 'MINE KAMPER';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Kunne ikke laste resultatene.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Ingen kamper.';

  @override
  String get resultsVs => 'mot';

  @override
  String get resultsStageQualifier => 'KVALIKKAMP';

  @override
  String get resultsStageFriendly => 'TRENINGSKAMP';

  @override
  String get resultsStageGroupStage => 'GRUPPESPILL';

  @override
  String get resultsStageSemiFinal => 'SEMIFINALE';

  @override
  String get resultsStageFinal => 'FINALE';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'SLUTTSPILLGRUPPE';

  @override
  String get resultsStageRoundOf32 => '32-DELSFINALE';

  @override
  String get resultsStageRoundOf16 => 'ÅTTEDELSFINALE';

  @override
  String get resultsStageQuarterFinal => 'KVARTFINALE';

  @override
  String get resultsStageThirdPlace => 'BRONSEFINALE';

  @override
  String get matchSetupWarnCaptain =>
      'Ingen kaptein utpekt. Trykk for å gi noen kapteinsbindet';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name er skadet og kan ikke lede laget ut denne gangen. Trykk for å gi bindet videre';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name er suspendert i denne kampen. Trykk for å gi bindet videre';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name har kapteinsbindet, men er ikke med i troppen din. Trykk for å gi det videre';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Ingen dødballutførere utpekt. Trykk for å velge hvem som tar ansvar';

  @override
  String get matchSetupWarnBoth =>
      'Ingen kaptein og ingen dødballutførere. Trykk for å velge dem';

  @override
  String matchStageMatchday(int matchday) {
    return 'KR $matchday';
  }

  @override
  String get squadCaptain => 'Kaptein';

  @override
  String deptEffectYouth(int points) {
    return 'Akademitalentene kommer omtrent $points høyere i helhetsvurdering';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount tilbake når syklusen er over';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent % færre skader';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent % sjanse for at en utenlandsk spiller ber om å bytte';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points tålmodighet hos styret før jobben din er i fare';
  }

  @override
  String get deptEffectNone => 'Ingen effekt uten finansiering';

  @override
  String get statsBestRated => 'Karakterer';

  @override
  String get statsMyCareer => 'Karriere';

  @override
  String get statsBestAverageRating => 'BESTE SNITTKARAKTER';

  @override
  String get statsMyCareerRecord => 'REKORDEN DIN';

  @override
  String get statsNoRatingsRecorded => 'Ingen kampkarakterer registrert ennå.';

  @override
  String get statsGroupRecord => 'Rekord';

  @override
  String get statsGroupRuns => 'Rekker';

  @override
  String get statsGroupExtremes => 'Ytterpunkter';

  @override
  String get statsGroupSplits => 'Hjemme og borte';

  @override
  String get statsGroupSquad => 'Spillerne dine';

  @override
  String get statsPlayed => 'Spilte kamper';

  @override
  String get statsWinDrawLoss => 'Seier–uavgjort–tap';

  @override
  String get statsWinRate => 'Seiersandel';

  @override
  String get statsGoals => 'Scorede:innsluppne mål';

  @override
  String get statsCleanSheets => 'Holdt nullen';

  @override
  String get statsFailedToScore => 'Uten scoring';

  @override
  String get statsLongestWinStreak => 'Lengste seiersrekke';

  @override
  String get statsLongestUnbeaten => 'Lengste ubeseirede rekke';

  @override
  String get statsLongestCleanSheets => 'Lengste rekke uten innsluppet mål';

  @override
  String get statsLongestWinless => 'Lengste rekke uten seier';

  @override
  String get statsCurrentRun => 'Nåværende ubeseirede rekke';

  @override
  String get statsBiggestWin => 'Største seier';

  @override
  String get statsHeaviestDefeat => 'Tyngste tap';

  @override
  String get statsMostGoalsInAGame => 'Flest mål i en kamp';

  @override
  String get statsShootouts => 'Straffekonk. vunnet–tapt';

  @override
  String get statsComebackWins => 'Seiere etter underlegg';

  @override
  String get statsHome => 'Hjemme';

  @override
  String get statsAway => 'Borte';

  @override
  String get statsNeutral => 'Nøytral';

  @override
  String get statsCompetitive => 'Offisielle kamper';

  @override
  String get statsFriendlies => 'Treningskamper';

  @override
  String get statsHatTricks => 'Hat tricks';

  @override
  String get statsBraces => 'Dobbeltscoringer';

  @override
  String get statsMotms => 'Utmerkelser som kampens spiller';

  @override
  String get statsAssists => 'Assist';

  @override
  String get statsCards => 'Kort';

  @override
  String get statsBestRating => 'Beste individuelle karakter';

  @override
  String statsAppsShort(int apps) {
    String _temp0 = intl.Intl.pluralLogic(
      apps,
      locale: localeName,
      other: '$apps kamper',
      one: '1 kamp',
    );
    return '$_temp0';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms KS';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent => 'Kaptein. Trykk for å ta bort bindet';

  @override
  String get captainFitBorn => 'En født leder';

  @override
  String get captainFitNatural => 'En naturlig kaptein';

  @override
  String get captainFitCapable => 'Kan bære det';

  @override
  String get captainFitUnproven => 'Ikke leder ennå';

  @override
  String get captainNone => 'Ingen kaptein utpekt';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale troppsmoral';
  }

  @override
  String get viceCaptainFirst => '1. visekaptein';

  @override
  String get viceCaptainSecond => '2. visekaptein';

  @override
  String get viceCaptainNone => 'Ingen visekaptein utnevnt';

  @override
  String get viceCaptainHint =>
      'Tar kapteinsbindet når kapteinen ikke kan spille.';

  @override
  String captainStandIn(String vice, String captain) {
    return 'Visekaptein $vice leder laget ut; kaptein $captain kan ikke spille';
  }

  @override
  String captainStandInUnnamed(String vice) {
    return 'Visekaptein $vice leder laget ut';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'VM-kvalifisering';

  @override
  String get resultsCategoryFriendlies => 'Treningskamper';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Kontinentalcup';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'VM-kval.';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Kont.-kval.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Kontinentalcup-kvalifisering';

  @override
  String get resultsCategoryWorldCupFinals => 'VM-sluttspill';

  @override
  String get resultsRoundResults => 'RUNDERESULTATER';

  @override
  String get resultsFriendlyInternationals => 'TRENINGSLANDSKAMPER';

  @override
  String get resultsKnockout => 'Utslagsrunde';

  @override
  String resultsEarlierMatches(int count) {
    return 'Tidligere kamper ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'KAMPRUNDE $matchday';
  }

  @override
  String get resultsContinue => 'Fortsett';

  @override
  String resultsGroup(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get achievementsScreenTitle => 'PRESTASJONER';

  @override
  String get achievementsChallengesTooltip => 'Utfordringer';

  @override
  String get achievementsChallengesHeading => 'UTFORDRINGER';

  @override
  String get achievementsBrutalTests => 'Brutale tester gjennom hele karrieren';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Kunne ikke laste.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total opplåst';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total erobret';
  }

  @override
  String get achievementsBoardSatisfaction => 'STYRETS TILFREDSHET';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PRESTASJONER OPPLÅST',
      one: 'PRESTASJON OPPLÅST',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Seiere';

  @override
  String get achCatMatches => 'Kamper';

  @override
  String get achCatQualifications => 'Kvalifiseringer';

  @override
  String get achCatTitles => 'Titler';

  @override
  String get achCatMisc => 'Diverse';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Mål';

  @override
  String get achCatStreaks => 'Rekker';

  @override
  String get achTierBronze => 'Bronse';

  @override
  String get achTierSilver => 'Sølv';

  @override
  String get achTierGold => 'Gull';

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
      other: '$count nullkamper',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hold nullen $count ganger.',
      one: 'Hold nullen 1 gang.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Seiersvane';

  @override
  String get achStreakWin5Desc => 'Vinn fem kamper på rad.';

  @override
  String get achStreakWin10 => 'På en rull';

  @override
  String get achStreakWin10Desc => 'Vinn ti kamper på rad.';

  @override
  String get achStreakWin20 => 'Veivalsen';

  @override
  String get achStreakWin20Desc => 'Vinn tjue kamper på rad.';

  @override
  String get achUnbeaten15 => 'Vanskelig å slå';

  @override
  String get achUnbeaten15Desc => 'Gå femten kamper uten tap.';

  @override
  String get achUnbeaten30 => 'Urørlig';

  @override
  String get achUnbeaten30Desc => 'Gå tretti kamper uten tap.';

  @override
  String get achHattrick => 'Hat trick-helt';

  @override
  String get achHattrickDesc => 'La en spiller score hat trick.';

  @override
  String get achMotm10 => 'Skiller seg ut';

  @override
  String get achMotm10Desc => 'Samle 10 utmerkelser som kampens spiller.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc => 'Samle 50 utmerkelser som kampens spiller.';

  @override
  String get achPerfect => 'Perfekt tier';

  @override
  String get achPerfectDesc => 'La en spiller få 9,5+ i kampkarakter.';

  @override
  String get achShootout => 'Is i magen';

  @override
  String get achShootoutDesc => 'Vinn fem straffesparkkonkurranser.';

  @override
  String get achMassacre => 'Massakre';

  @override
  String get achMassacreDesc => 'Vinn en kamp med 7 mål eller mer.';

  @override
  String get achAnnihilation => 'Utslettelse';

  @override
  String get achAnnihilationDesc => 'Vinn en kamp med 10 mål eller mer.';

  @override
  String get chTierBronze => 'Bronse';

  @override
  String get chTierSilver => 'Sølv';

  @override
  String get chTierGold => 'Gull';

  @override
  String get chTierLegendary => 'Legendarisk';

  @override
  String get chFirstSteps => 'I trenerboksen';

  @override
  String get chFirstStepsDesc => 'Vær landslagssjef i 5 år.';

  @override
  String get chUnbeaten10 => 'På en rull';

  @override
  String get chUnbeaten10Desc => 'Gå 10 offisielle kamper uten tap.';

  @override
  String get chTwoNations => 'Ny utfordring';

  @override
  String get chTwoNationsDesc => 'Led 2 ulike land.';

  @override
  String get chCont1 => 'Kontinentalmester';

  @override
  String get chCont1Desc => 'Vinn et kontinentalt mesterskap.';

  @override
  String get chNc1 => 'Nations Cup-vinner';

  @override
  String get chNc1Desc => 'Vinn Nations Cup.';

  @override
  String get chWc1 => 'Verdensmester';

  @override
  String get chWc1Desc => 'Vinn Verdensmesterskapet.';

  @override
  String get chYears25 => 'Institusjonen';

  @override
  String get chYears25Desc => 'Vær landslagssjef i 25 år.';

  @override
  String get chWc3 => 'Seriesegrer';

  @override
  String get chWc3Desc => 'Vinn Verdensmesterskapet 3 ganger.';

  @override
  String get chWc5 => 'Dynasti';

  @override
  String get chWc5Desc => 'Vinn Verdensmesterskapet 5 ganger.';

  @override
  String get chWc10 => 'Udødelig';

  @override
  String get chWc10Desc => 'Vinn Verdensmesterskapet 10 ganger.';

  @override
  String get chWc2Teams => 'Klar for nye eventyr';

  @override
  String get chWc2TeamsDesc => 'Vinn Verdensmesterskapet med 2 ulike land.';

  @override
  String get chWc3Teams => 'Globetrotter';

  @override
  String get chWc3TeamsDesc => 'Vinn Verdensmesterskapet med 3 ulike land.';

  @override
  String get chWcStreak3 => 'Tre på rad';

  @override
  String get chWcStreak3Desc => 'Vinn Verdensmesterskapet 3 ganger på rad.';

  @override
  String get chWcAllconf => 'Verdenserobrer';

  @override
  String get chWcAllconfDesc =>
      'Vinn Verdensmesterskapet med et land fra hvert kontinentale forbund (6).';

  @override
  String get chCont5 => 'Kontinentkonge';

  @override
  String get chCont5Desc => 'Vinn 5 kontinentale mesterskap.';

  @override
  String get chContAll => 'Seks kontinenter';

  @override
  String get chContAllDesc =>
      'Vinn det kontinentale mesterskapet i alle de seks kontinentale forbundene (6).';

  @override
  String get chTreble => 'Rent bord';

  @override
  String get chTrebleDesc =>
      'Vinn Verdensmesterskapet, en kontinental tittel og Nations Cup i løpet av én karriere.';

  @override
  String get chNations10 => 'Nomade';

  @override
  String get chNations10Desc => 'Led 10 ulike land.';

  @override
  String get chYears100 => 'Århundret';

  @override
  String get chYears100Desc => 'Vær landslagssjef i 100 år.';

  @override
  String get chYears500 => 'Et halvt årtusen';

  @override
  String get chYears500Desc => 'Vær landslagssjef i 500 år.';

  @override
  String get chYears1000 => 'Evig';

  @override
  String get chYears1000Desc => 'Vær landslagssjef i 1000 år.';

  @override
  String get chGrandmaster => 'Stormester';

  @override
  String get chGrandmasterDesc =>
      'Vinn Verdensmesterskapet 3 ganger OG 5 kontinentale mesterskap.';

  @override
  String get chUndefeated => 'Urørlig';

  @override
  String get chUndefeatedDesc =>
      'Vinn et Verdensmesterskap uten å tape en eneste kamp.';

  @override
  String get chPerfectQual => 'Feilfri vei';

  @override
  String get chPerfectQualDesc =>
      'Vinn hver eneste kamp i en VM-kvalifisering.';

  @override
  String get chMinnow => 'Smålagsmirakelet';

  @override
  String get chMinnowDesc =>
      'Vinn Verdensmesterskapet med et land som er rangert utenfor verdens topp 32.';

  @override
  String get chGrandTour => 'Hjemme og borte';

  @override
  String get chGrandTourDesc =>
      'Vinn et Verdensmesterskap som vertsnasjon og et til borte.';

  @override
  String get chUnbeaten25 => 'Muren';

  @override
  String get chUnbeaten25Desc => 'Gå 25 offisielle kamper uten tap.';

  @override
  String get chGoals10k => 'Målmaskin';

  @override
  String get chGoals10kDesc => 'Score 10 000 mål i karrieren.';

  @override
  String get chCleanSheets500 => 'Festning';

  @override
  String get chCleanSheets500Desc => 'Hold nullen 500 ganger i karrieren.';

  @override
  String get chHatTricks25 => 'Hat trick-vane';

  @override
  String get chHatTricks25Desc => 'La spillerne dine score 25 hat tricks.';

  @override
  String get chWinStreak25 => 'Ustoppelig';

  @override
  String get chWinStreak25Desc => 'Vinn 25 kamper på rad.';

  @override
  String get chCont10 => 'Kontinentalt dynasti';

  @override
  String get chCont10Desc => 'Vinn 10 kontinentale mesterskap.';

  @override
  String get chPcWc => 'Seriemester';

  @override
  String chPcWcDesc(int count) {
    return 'Vinn Verdensmesterskapet $count ganger i denne lagringen.';
  }

  @override
  String get chPcMajors => 'Pokalsamler';

  @override
  String chPcMajorsDesc(int count) {
    return 'Vinn $count store troféer (Verdensmesterskapet, kontinentalt mesterskap, Nations Cup eller Continental Clash).';
  }

  @override
  String get chPcUnbeaten => 'Jernmuren';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Gå $count offisielle kamper uten tap.';
  }

  @override
  String get chPcNations => 'Omreisende';

  @override
  String chPcNationsDesc(int count) {
    return 'Led $count ulike land.';
  }

  @override
  String get chPcYears => 'Den lange veien';

  @override
  String chPcYearsDesc(int count) {
    return 'Vær landslagssjef i $count år.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seiere',
      one: '1 seier',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vinn $count kamper.',
      one: 'Vinn 1 kamp.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kamper',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spill $count kamper.',
      one: 'Spill 1 kamp.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'VM-kvalifisert';

  @override
  String get achQualWcDesc => 'Kvalifiser deg til Verdensmesterskapet.';

  @override
  String get achQualCont => 'Kontinentalt kvalifisert';

  @override
  String get achQualContDesc =>
      'Kvalifiser deg til ditt kontinentale mesterskap.';

  @override
  String get achTitleWc => 'Verdensmestere';

  @override
  String get achTitleWcDesc => 'Vinn Verdensmesterskapet.';

  @override
  String get achTitleEuro => 'Europamestere';

  @override
  String get achTitleEuroDesc => 'Vinn Europamesterskapet.';

  @override
  String get achTitleCopa => 'Sør-Amerika-mestere';

  @override
  String get achTitleCopaDesc => 'Vinn Sør-Amerika-cupen.';

  @override
  String get achTitleAfcon => 'Afrikamestere';

  @override
  String get achTitleAfconDesc => 'Vinn Afrikamesterskapet.';

  @override
  String get achTitleAsia => 'Asiamestere';

  @override
  String get achTitleAsiaDesc => 'Vinn Asiamesterskapet.';

  @override
  String get achTitleConcacaf => 'Nord-Amerika-mestere';

  @override
  String get achTitleConcacafDesc => 'Vinn Nord-Amerika-cupen.';

  @override
  String get achTitleOfc => 'Oseania-mestere';

  @override
  String get achTitleOfcDesc => 'Vinn Oseania-cupen.';

  @override
  String get achTitleNations => 'Nations Cup-vinnere';

  @override
  String get achTitleNationsDesc => 'Vinn Nations Cup.';

  @override
  String get achTitleClash => 'Continental Clash-vinnere';

  @override
  String get achTitleClashDesc => 'Vinn Continental Clash.';

  @override
  String get achMarksman => 'VM-skarpskytter';

  @override
  String get achMarksmanDesc =>
      'La en troppsspiller score 6+ mål i VM-sluttspillet.';

  @override
  String get achSweep => 'Rent bord';

  @override
  String get achSweepDesc =>
      'Vinn både Verdensmesterskapet og den kontinentale tittelen i løpet av én karriere.';

  @override
  String get achAllstar => 'Turneringens stjerne';

  @override
  String get achAllstarDesc =>
      'La en spiller bli tatt ut på Turneringens lag i Verdensmesterskapet.';

  @override
  String get achGoldenboot => 'Toppscorer';

  @override
  String get achGoldenbootDesc =>
      'La landet ditt ende som toppscorer i et mesterskap.';

  @override
  String get achDemolition => 'Rivingsjobb';

  @override
  String get achDemolitionDesc => 'Vinn en kamp med 5 mål eller mer.';

  @override
  String get achievementsNice => 'Flott!';

  @override
  String get achievementsHardestTests =>
      'De tøffeste testene for en landslagssjef, gjennom en hel karriere og mange land.';

  @override
  String get achievementsThisSave => 'DENNE LAGRINGEN';

  @override
  String get achievementsBrutalBadge => 'BRUTAL';

  @override
  String get paywallGoPro => 'GÅ UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Engangsopplåsing. Ingen abonnement.';

  @override
  String get paywallBenefitCarryOn =>
      'Denne lagringen fortsetter nøyaktig der den stoppet, med alle landskamper, rekorder og rivaliseringer intakte.';

  @override
  String get paywallBenefitNoAds =>
      'Ingen reklame, ingen mikrotransaksjoner, ikke noe abonnement. Én betaling, oppdateringer inkludert.';

  @override
  String get paywallBenefitSaves =>
      'Så mange lagringer du vil. Led en favoritt og et smålag samtidig, og se hvor ulikt det samme spillet oppleves.';

  @override
  String get paywallBenefitEndless =>
      'Hver eneste syklus fra nå av. Velg en sytten år gammel spiller i dag, og finn ut i 2034 om du så rett.';

  @override
  String get paywallUnlocked => 'Unlimited er låst opp. Kos deg!';

  @override
  String get paywallContactingStore => 'Kontakter butikken…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Lås opp Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Gjenopprett kjøp';

  @override
  String get paywallStoreUnavailable => 'Butikken er utilgjengelig';

  @override
  String get paywallStoreUnavailableNote =>
      'Prisen kunne ikke lastes. Sjekk tilkoblingen og prøv igjen.';

  @override
  String get paywallTryAgain => 'Prøv igjen';

  @override
  String get gateTitle => 'DEN FØRSTE SYKLUSEN DIN ER OVER';

  @override
  String get gateLead =>
      'Fire år er én syklus. Det er ikke nok til å finne ut om du hadde rett.';

  @override
  String get gatePriceLead => 'Én betaling, for alltid';

  @override
  String get gateBuy => 'KJØP OG FORTSETT';

  @override
  String get gateExit => 'AVSLUTT';

  @override
  String get gateSaveTitle => 'DENNE LAGRINGEN KREVER PRO';

  @override
  String get gateSaveLead =>
      'Lagringer etter den gratis syklusen og Pro-kampanjer fortsetter med Pro. Ingenting går tapt: lagringen venter akkurat slik du forlot den.';

  @override
  String get careerSaveLockedNote =>
      'Pro kreves for å fortsette denne lagringen';

  @override
  String get federationNaturalisation => 'NATURALISERING';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name naturalisert';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name har fullført byttet og kan nå velges for $nation. Ta spilleren ut fra troppsvalget ditt.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Kunne ikke laste tilbudet.\n$error';
  }

  @override
  String get federationContinue => 'Fortsett';

  @override
  String get federationOfferToSwitchAllegiance =>
      'ET TILBUD OM Å BYTTE LANDSLAG';

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
    return '$name har bånd til $playerNation og er villig til å bli naturalisert. Si ja, så kan spilleren velges; si nei, så blir spilleren hos $sourceNation.';
  }

  @override
  String get federationDecline => 'Avslå';

  @override
  String get federationNaturalise => 'Naturaliser';

  @override
  String get federationBudgetLater => 'Avgjør senere';

  @override
  String get federationSetYourBudget => 'SETT BUDSJETTET';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Kunne ikke laste økonomien.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Fant ikke lagringen.';

  @override
  String get federationBudgetHeading => 'FORBUNDSBUDSJETT';

  @override
  String federationDistributeBudget(String amount) {
    return 'Fordel $amount på avdelingene for å åpne syklusen. Bruk pengene med omhu.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount mer enn forbundet har. Ta noe tilbake';
  }

  @override
  String get federationAllocateFullBudget =>
      'Fordel hele budsjettet for å starte syklusen.';

  @override
  String get federationConfirming => 'Bekrefter…';

  @override
  String get federationConfirmBudget => 'Bekreft budsjett';

  @override
  String get federationFinances => 'ØKONOMI';

  @override
  String get federationInvestmentUpdated => 'Investeringen er oppdatert.';

  @override
  String get federationDevelopment => 'FORBUNDSUTVIKLING';

  @override
  String get federationProjectedAtSeasonEnd => 'PROGNOSE VED SESONGSLUTT';

  @override
  String get federationCentralFunding => 'Sentral støtte';

  @override
  String get federationPrizeMoneySoFar => 'Premiepenger hittil';

  @override
  String get federationCommercialReturn => 'Kommersiell avkastning';

  @override
  String get federationThisSeasonLocked => 'DENNE SESONGEN (LÅST)';

  @override
  String get federationInvestForNextSeason => 'INVESTER FOR NESTE SESONG';

  @override
  String get federationNextSeasonImpact => 'EFFEKT NESTE SESONG';

  @override
  String get federationSaving => 'Lagrer…';

  @override
  String get federationConfirmInvestment => 'Bekreft investering';

  @override
  String get federationBalance => 'FORBUNDETS SALDO';

  @override
  String get federationCommittedToStaff => 'Bundet til staben';

  @override
  String get federationFreeToSpend => 'Tilgjengelig';

  @override
  String get federationWagesNote =>
      'Lønningene trekkes fra saldoen ved syklusens slutt, så dette beløpet er allerede disponert.';

  @override
  String get federationInvestAtCeremony =>
      'Invester for neste sesong på seremonien ved syklusens slutt.';

  @override
  String federationLevelBadge(int level) {
    return 'N$level';
  }

  @override
  String get federationAcademyProspects => 'Akademitalenter';

  @override
  String federationPlusOverall(int value) {
    return '+$value helhetsvurdering';
  }

  @override
  String get federationInjuryRisk => 'Skaderisiko';

  @override
  String get federationNaturalisationChance => 'Sjanse for naturalisering';

  @override
  String get federationBoardPatience => 'Styrets tålmodighet';

  @override
  String get federationUnallocated => 'IKKE FORDELT';

  @override
  String get nationsVitrineTitle => 'POKALSKAP';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Kunne ikke laste landet.\n$error';
  }

  @override
  String get nationsNoNation => 'Ingen land.';

  @override
  String get nationsHonours => 'HEDERSPRISER';

  @override
  String get nationsRankingHistory => 'HISTORIKK VERDENSRANKING';

  @override
  String get nationsTopScorers => 'TIDENES TOPPSCORERE';

  @override
  String get nationsTitles => 'TITLER';

  @override
  String get nationsYourTeam => 'DITT LAG';

  @override
  String get nationsWorld => 'VERDEN';

  @override
  String get nationsWorldCup => 'Verdensmesterskapet';

  @override
  String get nationsContinental => 'Kontinental';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deltakelser',
      one: '1 deltakelse',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Ikke nok historikk ennå. Kom tilbake om en syklus eller to.';

  @override
  String nationsBestRank(int rank) {
    return 'Best: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Nå: #$rank';
  }

  @override
  String get nationsNoGoals => 'Ingen mål registrert ennå.';

  @override
  String get nationsGoalsAbbrev => 'mål';

  @override
  String get nationsHosts => 'VERTSKAP';

  @override
  String get nationsSelectTitle => 'VELG LANDSLAG';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Kunne ikke laste land.\n$error';
  }

  @override
  String get nationsNoMatch => 'Ingen land passer.';

  @override
  String get nationsSelectHeading => 'Velg landslag';

  @override
  String get nationsSearchHint => 'Søk etter land…';

  @override
  String get nationsRank => 'PLASS ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'VELG';

  @override
  String get statsTeamRecords => 'LAGREKORDER';

  @override
  String get statsRecordBook => 'Rekordbok';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Kunne ikke laste statistikk.\n$error';
  }

  @override
  String get statsNoData => 'Ingen data.';

  @override
  String get statsTopScorers => 'TOPPSCORERE';

  @override
  String get statsMostGamesPlayed => 'FLEST KAMPER';

  @override
  String get statsTeam => 'Lag';

  @override
  String get statsTopScorersShort => 'Scorere';

  @override
  String get statsMostGames => 'Flest kamper';

  @override
  String get statsMostGamesShort => 'Kamper';

  @override
  String get statsNoGoalsRecorded => 'Ingen mål registrert ennå.';

  @override
  String get statsUnknown => 'Ukjent';

  @override
  String get playerTitle => 'SPILLER';

  @override
  String playerLoadError(String error) {
    return 'Kunne ikke laste spilleren.\n$error';
  }

  @override
  String get playerNotFound => 'Fant ikke spilleren.';

  @override
  String get playerClub => 'KLUBB';

  @override
  String get playerClubRole => 'I klubben';

  @override
  String get playerPosition => 'Posisjon';

  @override
  String get playerPotential => 'Potensial';

  @override
  String get playerAge => 'Alder';

  @override
  String get playerValue => 'Verdi';

  @override
  String get clubFirstChoice => 'Spiller hver uke';

  @override
  String get clubRotation => 'Inn og ut';

  @override
  String get clubFringe => 'Spiller knapt';

  @override
  String get clubFrozenOut => 'Spiller ikke';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Jeg har sett fotball i tretti år, og dette så jeg aldri komme. $opponent slått $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Ingen ga dem en sjanse mot $opponent. $score. Absolutt ingen.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score mot $opponent. Gå og vekk naboene.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Dette er kvelden folk forteller barnebarna om. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score mot $opponent. Hvordan det enn skjedde, så skjedde det.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'På papiret var dette over før det startet. $opponent $score sier noe annet.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Slo $opponent $score. Ingen kommer til å tro på den stillingen om et år.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Nyt det, og se så på kampprogrammet.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score mot $opponent, og vi hadde flaks i åtti av nitti minutter.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Én kveld mot $opponent visker ikke ut et helt år. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Slo $opponent $score, og nå får vi høre at vi har snudd en trend. Det har vi ikke.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Fantastisk. Spør meg igjen når det gjelder.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Slo $opponent $score. Akkurat slik det skal være, og det er en glede i det.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score over $opponent. Hensynsløst, og hensynsløst er et kompliment.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Ingen oppstyr, ingen redsel, ingen klager.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'En ryddig $score mot $opponent. Slik ser et godt lag ut på en rolig dag.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score mot $opponent. Jobben gjort, ingenting lært.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Slo $opponent $score. Det var forventet, og det gjorde vi.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'En profesjonell $score over $opponent. Neste.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent avfeid $score. Legg det bak deg og gå videre.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score mot $opponent, og vi skal applaudere. For å slå dem.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Godt jobbet av alle involverte i $score-seieren over $opponent, antar jeg.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Å slå lag som det er minstekravet, ikke prestasjonen.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Vi slo $opponent $score og så tunge ut mens vi gjorde det.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score mot $opponent, og hvert minutt fortjent.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Det krevde karakter. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Slo $opponent $score på den harde måten, som er den som varer.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score mot $opponent. Lagene som vinner slike kamper står fortsatt i juni.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nervøst, stygt og en seier. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Slo $opponent $score. Ta de tre poengene og se aldri kampen igjen.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent fikk oss til å jobbe for hver centimeter.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Ikke pent. Teller likevel like mye.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score mot $opponent, og vi gjorde det ti ganger vanskeligere enn nødvendig.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Vi burde ikke slite slik mot $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Vant den, men lærte ikke noe godt om oss selv.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'En $score som smigret oss mot $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Ett poeng mot $opponent, $score. Ta det og gå videre.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score mot $opponent. Det finnes verre ettermiddager enn dette.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Holdt $opponent til $score. Alt trenger ikke å bli en historie.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Ett poeng er ett poeng, og tabellen spør ikke hvordan.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score mot $opponent. To poeng tapt eller ett vunnet. Velg humør.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Uavgjort mot $opponent, $score. Ingen er fornøyde, ingen er rasende.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Årets mest glemmelige nitti minutter.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Delte poengene med $opponent, $score. Videre.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score mot $opponent. Slik uavgjort er måten kampanjer dør i det stille på.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'To poeng kastet bort mot $opponent. $score. Det finnes ikke noe annet ord for det.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Vi hadde nitti minutter og ingen anelse om hva vi skulle gjøre med dem.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'En $score mot $opponent som ingen kommer til å huske, og alle kommer til å betale for.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Slått $score av $opponent. Det skjer.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Ingenting å henge noen for. Videre til neste.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Tapte $score mot $opponent og ga alt. Noen dager er ikke det nok.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score mot $opponent. Hodet høyt. Dette laget har mye igjen.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Vi var klart dårligere, og det er ingenting å diskutere.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Tapte $score mot $opponent. Samle dere.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score mot $opponent. Ingen skam, men ikke godt nok.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Slått $score av $opponent. Lær noe av det, ellers var det bortkastet.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score mot $opponent, og vi rørte dem ikke.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Tapte mot $opponent, $score. Samme problemer, samme måned, samme unnskyldninger på vei.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Når slutter dette å være uflaks?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Slått $score av $opponent. Et resultat som bør koste noen noe.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score mot $opponent. En dårlig kveld. Døm laget etter kampanjen, ikke etter dette.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Ingen ønsket det $score-tapet mot $opponent mindre enn spillerne selv.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Stygt, og ikke slik dette laget er.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'En $score å glemme mot $opponent. De skal stille opp neste gang.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Mot $opponent. Jeg har ingen ord, og jeg får betalt for å ha ord.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Noen må stå til ansvar for det.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Jeg vil ha $score mot $opponent strøket fra protokollen og fra hukommelsen.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Slått $score av $opponent. Det går ikke an å pynte på en slik stilling.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Dette var ikke et tap mot $opponent, det var en kapitulasjon. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Mot $opponent. Folk betalte penger for å se det.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Hvis ikke dette endrer noe, gjør ingenting det.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Jeg har sett dette laget ydmyket før, men $score mot $opponent er en ny bunn.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$opponent slått med $score. Skriv ned datoen, folk kommer til å spørre hvor dere var.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Utenfor garderoben trodde ingen på det. $score mot $opponent. Stolt dekker det ikke.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score mot $opponent! Alle løp til det ikke var noe igjen.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Kjempedreper. $opponent, $score. Det er derfor vi alltid kommer tilbake.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score mot $opponent. Tipsene fløy nettopp ut av vinduet.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Storfavoritt: $opponent. Sluttresultat: $score til oss.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'En av årets største overraskelser: $score mot $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Ingen spådde det, og ingen klarer helt å forklare det.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score mot $opponent. Herlig. Nå glemmer alle hvor dårlig resten av året var.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score mot $opponent, og toget er allerede fullt. Jeg satt på da det var tomt.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Strålende, og de finner likevel en måte å kaste det bort på.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Stor kveld mot $opponent, $score. Én svale gjør ingen sommer.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score mot $opponent. Det gjør vondt fordi vi bryr oss. Støtt dem likevel.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'En kveld å glemme mot $opponent, $score. Spillerne har det verst av alle.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Hodet høyt. Et lag bedømmes etter hvordan det svarer på dette.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score mot $opponent. Dårlig, ja. Verdens undergang, nei.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score mot $opponent. Et resultat det vil bli snakket om i årevis, av feil grunner.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Seier til $opponent, $score. Etter dette bør ingen bli overrasket neste gang.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'En av de verste kveldene på lenge: $score mot $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Det kommer spørsmål, og med god grunn.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score mot $opponent. Pinlig er en underdrivelse.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Tap med $score mot $opponent. Siste mann slukker lyset.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Jeg blir ikke overrasket lenger, og det skremmer meg.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Noen der oppe bør oppdatere CV-en sin i kveld.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score mot $opponent! Sånn fotball får hele landet til å smile.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponent utspilt, $score. For en innsats.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Mot $opponent. Alt lyktes i kveld.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'En $score-demolering av $opponent. Ta vare på høydepunktene, dere vil ha dem senere.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Det er et lag som koser seg med fotballen.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score mot $opponent, og det kunne blitt flere. Nydelig.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score mot $opponent. Et resultat man ser på to ganger.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponent slått med $score. Ingen kamp etter den første halvtimen.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Sluttresultat: $score mot $opponent. Klart største seier på lenge.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Det ene laget kom for å spille, det andre gikk aldri av bussen.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. $opponent hadde ikke svar på noe.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Kjempejuling: $score mot $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score mot $opponent. Hyggelig, men de er knapt målestokken.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score mot $opponent. Vekk meg når vi gjør det mot noen gode.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Gøy, men jeg har sett lag glitre sånn og ikke vinne noe.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, og alle er genier igjen. Det var $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score mot $opponent. Ro ned, det beviser veldig lite.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Nyt det, og husk så hvordan det gikk sist vi ble giret.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Videre på straffer mot $opponent! Nerver av stål, hver eneste en.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Straffer mot $opponent, og vi holdt nervene. Klem en fremmed.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Straffekonkurransen vunnet mot $opponent. Hjertet mitt tåler ikke dette.';
  }

  @override
  String yWinShootout3(String opponent) {
    return '$opponent slått på straffer. Videre til neste runde.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Mot $opponent ble det avgjort fra straffemerket, og vi scoret flest.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Straffekonkurranse vunnet mot $opponent. Den tyngste veien, men videre.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Videre på straffer mot $opponent. Lotteriet vunnet, prestasjonen glemt.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Slå $opponent på straffer etter det der? Flaks, og alle vet det.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Videre mot $opponent på straffer. Det burde aldri vært nødvendig.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'VIDERE. $score mot $opponent, og drømmen lever.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'UTSLAGSSEIER: $opponent slått med $score. Landet kan begynne å tro.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score mot $opponent og videre til neste runde. For en kveld.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent sendt hjem, $score. Fremover.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'UTSLAGSKAMP: $score mot $opponent. Neste runde klar.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Videre: $score mot $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent slått ut, $score. Neste runde venter.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Vant $score mot $opponent. I utslagsrunder spør ingen hvordan.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Videre mot $opponent, $score. Neste motstander blir ikke like snill.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score mot $opponent holder for å gå videre. Neste gang kreves mye mer.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent ute, $score. Mer overlevd enn vunnet.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Videre til neste runde etter $score mot $opponent. Ikke spør hvordan.';
  }

  @override
  String yUpsetGap0(String opponent, int gap) {
    return '$gap plasser skilte oss på rankingen, og likevel slo vi $opponent. Magnifikt.';
  }

  @override
  String yUpsetGap1(String opponent, int gap) {
    return '$opponent: $gap plasser foran oss. Slått. Fotball er fantastisk.';
  }

  @override
  String yUpsetGap2(String opponent, int gap) {
    return 'Rankingforskjell: $gap plasser. Resultat: seier mot $opponent. Slutt aldri å tro.';
  }

  @override
  String yUpsetGap3(String opponent, int gap) {
    return 'Rankingforskjell før avspark: $gap plasser. $opponent slått likevel.';
  }

  @override
  String yUpsetGap4(String opponent, int gap) {
    return 'På verdensrankingen lå $opponent $gap plasser foran oss. Ikke i kveld.';
  }

  @override
  String yUpsetGap5(String opponent, int gap) {
    return 'Overraskelsesindeks: $gap rankingplasser mellom lagene. Seier til oss mot $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, int gap) {
    return '$gap rankingplasser skilte oss fra $opponent. Én kveld tetter ikke det gapet.';
  }

  @override
  String yUpsetGap7(String opponent, int gap) {
    return '$opponent: $gap plasser foran, og slått. Rankingen merker det knapt.';
  }

  @override
  String yUpsetGap8(int gap) {
    return 'Rankingforskjell: $gap plasser. Husk det tallet neste gang vi taper mot en småfisk.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Jeg hadde avskrevet dette laget. Jeg tok feil, og jeg har aldri vært gladere for å ta feil. $opponent slått.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'En porsjon ydmykhet, takk. En stor en. Seieren mot $opponent var magnifik.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Jeg sa de ikke hadde noe igjen. De hadde masse. Godt spilt mot $opponent, alle sammen.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'For ordens skyld: den seieren mot $opponent så jeg ikke komme. Ære være dem.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Greit. Jeg sa de ville bli avslørt. $opponent avslørte dem ikke.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'I kveld spiser jeg mine egne ord om dette laget. Seieren mot $opponent fortjener det.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Ja, jeg sa de var ferdige. Én seier mot $opponent beviser ikke at jeg tok feil ennå.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Jeg skal visst spise mine egne ord etter $opponent. Det gjør jeg, sakte, og kvitteringen tar jeg vare på.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Seieren mot $opponent var imponerende. Tvilen min på dette laget er der fortsatt.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Respekt til $nation. $score, og fortjent fra start til slutt.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Det gjør vondt å si det, men best i kveld var $nation. $score. Gratulerer.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Hatten av for $nation, de ville det mer.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Tap med $score mot $nation. Jeg vet ikke engang hva jeg skal si.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Våre burde skamme seg.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score mot $nation. Kan noen forklare meg hvordan det skjedde?';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Tape $score mot $nation. Dette kommer jeg aldri over.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score mot $nation. Flaks. Ren flaks.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Etter den $score blir de i $nation uutholdelige i årevis. Takk for ingenting.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Herlig for fotballen. Det er derfor vi elsker den.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'For et resultat for $nation: $score mot $opponent. Fotball på sitt beste.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Alle nøytrale heier på $nation i kveld. $score mot $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Rundens resultat: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Det hadde ingen på kupongen.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Stort resultat: $nation $score $opponent. Rankingen kommer til å flytte seg.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Gøy, vi får se om de klarer det igjen.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Vant $nation, eller tapte $opponent?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Bombe: $nation $score $opponent. Regn med mange overreaksjoner.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name mot $opponent. De kommer til å kalle opp barn etter ham.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'En statue til $name. I kveld mot $opponent var han alt.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, for en spiller. Husk denne kvelden mot $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name avgjorde mot $opponent. Banens beste, ingen diskusjon.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Mot $opponent tilhørte kvelden $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name steg frem da det gjaldt mot $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name var strålende mot $opponent. Nå hver uke, takk.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name reddet laget mot $opponent. De andre hjalp lite.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Uten $name hadde det blitt en helt annen kveld mot $opponent.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score mot $opponent. Et uhell. Det skjer med alle én gang.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Tap med $score mot $opponent. Rist det av dere, kampanjen er ikke over.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Vondt, men ett resultat definerer ikke dette laget.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score mot $opponent. En dårlig dag på jobben. Videre.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Tap mot $opponent, $score. Ingen så det komme.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. En av de kveldene som ikke gir mening.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score mot $opponent. Et tap som vil bli husket.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Slått av $opponent, $score. En sensasjon uansett hvordan man ser det.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score mot $opponent. Mot $opponent! Uakseptabelt.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Tap med $score mot $opponent. Jeg vil ha forklaringer, ikke unnskyldninger.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. En nasjonal skam, og det er ingen overdrivelse.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score mot $opponent. Hvordan sitter noen der oppe fortsatt i jobben?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score mot $opponent. Det er et topplag. Lær av det.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Utspilt av $opponent, $score. Ingen skam å tape mot de beste.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. En lekse, og av lekser vokser man.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score mot $opponent. Vondt, men de er et nivå over.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Seier til $opponent, $score. Forskjellen er ekte, og nå har alle sett den.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score mot $opponent. Juling, rett og slett.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. Det beste laget, og resultatet sier det.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Tap med $score mot $opponent. Ingen skam, men ingen kamp heller.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score mot $opponent. Bedre motstander eller ikke, sånn skal man ikke tape.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Prøvde vi i det hele tatt å konkurrere?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Mot $opponent. Lam til slakt.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Tap med $score mot $opponent, og ingen så ut til å bry seg.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Ute på straffer mot $opponent. De ga alt. Stolt av dem.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Straffer mot $opponent. Den grusomste måten å ryke ut på. Hodet høyt.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Straffekonkurransen tapt mot $opponent. Ingen fortjente det.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Ute på straffer mot $opponent. Straffemerket avgjorde.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent videre på straffer. Turneringen vår slutter der.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Straffekonkurranse tapt mot $opponent. Straffer igjen.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Ute på straffer mot $opponent. Trener vi i det hele tatt på dem?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Tap mot $opponent på straffer. Vi burde ha avgjort lenge før.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Straffer mot $opponent, og vi tapte. Selvfølgelig.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'UTE. $score mot $opponent. En reise å være stolt av slutter her.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Slått ut av $opponent, $score. Takk for minnene.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score mot $opponent. Reisen er over, men for en reise.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'SLÅTT UT: $score mot $opponent. Hodet høyt.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'SLUTT: $score mot $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Ute: $score mot $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent går videre, $score. Turneringen vår er over.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Slått ut av $opponent, $score. Obduksjonen begynner nå.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'UTE. $score mot $opponent. En annen turnering, samme slutt.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score mot $opponent, og hjem igjen. Ingen er overrasket.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Slått ut av $opponent, $score. Regn med unnskyldninger innen i morgen tidlig.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Ute, og det så aldri ut til å ende på noen annen måte.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score mot $nation. Respekt, de kommer sterkere tilbake.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'God seier for oss, $score. Dårlig dag for $nation, jeg føler med fansen deres.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Dårlig kveld for $nation, og vi grep sjansen. Sånn er det.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score mot $nation! Hvem så det komme? Ikke de.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Vant $score mot $nation. Kan noen sjekke hvordan fansen deres har det?';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Den går rett i fotoalbumet.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score mot $nation. Og de tror de er et storlag.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Tenk å tape $score mot oss. Spør $nation, de vet det nå.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. God tur hjem.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. En stor kveld for $opponent, en tung en for $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Tanker til fansen i $nation etter $score mot $opponent. De kommer igjen.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Alle storlag har en sånn kveld.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Rundens sjokk: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ingen så det komme.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Dagens resultat: $nation $score $opponent. Nå venter spørsmål for $nation.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ikke et engangstilfelle, hvis man har fulgt med.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Noen der har mye å forklare.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Stort navn, liten innsats.';
  }

  @override
  String yDownGap0(String opponent, int gap) {
    return '$opponent: $gap plasser bak oss. Det skjer. Videre.';
  }

  @override
  String yDownGap1(int gap) {
    return 'Rankingforskjell: $gap plasser i vår favør. Fotballen leser ikke rankinger.';
  }

  @override
  String yDownGap2(String opponent, int gap) {
    return '$gap plasser mellom oss og $opponent på papiret. Ikke på banen i kveld.';
  }

  @override
  String yDownGap3(String opponent, int gap) {
    return 'Rankingforskjell før avspark: $gap plasser i vår favør. Tap mot $opponent likevel.';
  }

  @override
  String yDownGap4(String opponent, int gap) {
    return 'På verdensrankingen lå $opponent $gap plasser bak oss. Resultat: tap.';
  }

  @override
  String yDownGap5(String opponent, int gap) {
    return 'Overraskelsesindeks: $gap rankingplasser, feil vei, mot $opponent.';
  }

  @override
  String yDownGap6(String opponent, int gap) {
    return '$gap plasser foran $opponent på rankingen. Tap. Forklar det.';
  }

  @override
  String yDownGap7(int gap) {
    return 'Tap mot et lag $gap plasser bak oss. La det tallet synke inn.';
  }

  @override
  String yDownGap8(String opponent, int gap) {
    return 'Rankingforskjell: $gap plasser. Tap mot $opponent. Noen bør begynne å telle dager.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score mot $opponent! Et uavgjort resultat som føles som seier.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score mot $opponent. Stolt av hver eneste en.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. De var favoritter, og vi holdt følge.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score mot $opponent. Et poeng vunnet med blod og svette.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score mot $opponent. Et veldig godt poeng.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Uavgjort $score mot $opponent. Få ventet noe som helst.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponent stoppet, $score. Et resultat å bygge videre på.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score mot $opponent. Et poeng ingen ga oss.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score mot $opponent. Godt poeng, men man vinner ingenting på uavgjort.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score mot $opponent. Fint. Vi hadde heller ikke ett eneste skikkelig skudd.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Ett poeng, og alle oppfører seg som om vi vant pokalen.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score mot $opponent. Vi parkerte bussen og hadde flaks.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score mot $opponent. Frustrerende, men fortsatt ubeseiret.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Bare $score mot $opponent. En dårlig dag. Det skjer.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Ikke godt nok, og spillerne vet det.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score mot $opponent. To tapte poeng, ikke noe mer.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score mot $opponent. To poeng kastet bort.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Bare $score mot $opponent. Et dårlig resultat, uansett innpakning.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Et uavgjort resultat som føles som tap.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score mot $opponent. Sånne kamper skal vi vinne komfortabelt.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score mot $opponent. Pinlig.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Bare uavgjort mot $opponent, $score. Hvem har ansvaret for dette?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Hvis vi ikke slår dem, hvem slår vi da?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score mot $opponent. Fansen deres feirer uavgjort mot oss. Tenk på det.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'MESTERE. $opponent. Si det høyt.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Vi vant den. $opponent. Jeg er ikke ved siden av meg selv.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, og pokalen kommer hjem.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Hver eneste en av dem en legende. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Så nær. $opponent og en medalje ingen vil ha.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Sølv i $opponent. Det kommer til å svi i årevis.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: én kamp unna alt.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Toer. I $opponent. Noen gir meg flasken.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Ute av $opponent. Den kommer til å svi en stund.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent er der det slutter for oss.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Eliminert i $opponent. Nå begynner granskingen.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Slått ut av $opponent. Noen må forklare meg det.';
  }

  @override
  String yQualified0(String opponent) {
    return 'VI SKAL TIL $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Kvalifisert til $opponent. Ta fri fra jobben.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, her kommer vi. Aldri tvil (det var full tvil).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Videre til $opponent. Det vanskeligste er gjort.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Gruppene er trukket for $opponent. Kunne vært verre. Kunne vært mye verre.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Så det er trekningen til $opponent. Interessant.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Gruppene til $opponent er ute, og jeg liker allerede ikke vår.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Trekningen til $opponent er gjort. La overreaksjonene begynne.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent blir vert. Begynn å spare.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Den går til $opponent. Forutsigbart, men greit.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent får turneringen. Gratulerer til dem, antar jeg.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Vertskap bekreftet: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent starter snart, og jeg klarer ikke sitte i ro.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Det er ikke lenge til $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent er nesten her. Troppsuttak, takk.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Nedtellingen til $opponent er offisielt uutholdelig.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Ingenting å si ennå. Spill en kamp.';

  @override
  String get yEarlierHeading => 'Tidligere i syklusen';

  @override
  String get yTraitLoyalist =>
      'Støtter laget uansett. Treg til å snu, rask til å tilgi.';

  @override
  String get yTraitCynic =>
      'Forventer det verste og er henrykt over å få rett.';

  @override
  String get yTraitNostalgic =>
      'Alt var bedre før. Måler deg mot menn som har lagt opp.';

  @override
  String get yTraitStatshead =>
      'Legger ut tallene og ingenting annet. Har knapt noe humør.';

  @override
  String get yTraitHypeman => 'To gode resultater og det er en gullgenerasjon.';

  @override
  String get yTraitContrarian => 'Uansett hva alle andre mener, det motsatte.';

  @override
  String get yTraitDoomer =>
      'Det kommer til å gå galt. Det kommer alltid til å gå galt.';

  @override
  String get yProfilePosts => 'INNLEGG';

  @override
  String get yProfileEmpty => 'Ingenting fra denne kontoen ennå.';

  @override
  String hubEventGrievance(String player) {
    return '$player vil snakke med deg';
  }

  @override
  String get hubEventGrievanceSub => 'Han vil vite hvor han står';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ferdighetspoeng å bruke',
      one: '1 ferdighetspoeng å bruke',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Det du er god på gjør laget ditt bedre';

  @override
  String get grievanceTitle => 'Et ord på kontoret';

  @override
  String grievanceGameTime(String player) {
    return '$player har vært med i troppen uten å røre ballen. Han vil vite hvorfor.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player er ikke med i troppen og forstår det ikke. Han vil ha beskjed, uansett hva svaret er.';
  }

  @override
  String grievanceRole(String player) {
    return '$player blir stadig spilt ut av posisjon og har fått nok.';
  }

  @override
  String get grievanceReassure => 'Du er med i planene mine';

  @override
  String get grievanceHonest => 'Du er bak andre, og her er hvorfor';

  @override
  String get grievanceDismiss => 'Jeg tar ut laget';

  @override
  String yScorerStar0(String name, int goals) {
    return '$name satte $goals av dem. Ingen andre er i nærheten.';
  }

  @override
  String yScorerStar1(String name, int goals) {
    return '$goals for $name. Han bærer dette laget.';
  }

  @override
  String yScorerStar2(String name, int goals) {
    return '$name: $goals i dag. For en spiller.';
  }

  @override
  String yScorerStar3(String name, int goals) {
    return '$name satte $goals forbi dem. Bukk for publikum.';
  }

  @override
  String yScorerStar4(String name, int goals) {
    return '$goals for $name, og resten var passasjerer.';
  }

  @override
  String yScorerStar5(String name, int goals) {
    return '$name igjen. $goals. Tenk deg dette laget uten ham.';
  }

  @override
  String yScorerStar6(String name, int goals) {
    return '$goals fra $name. Én mann burde ikke måtte gjøre så mye.';
  }

  @override
  String yScorerStar7(String name, int goals) {
    return 'Ta bort $name, og det er $goals færre og en helt annen ettermiddag.';
  }

  @override
  String yWinStreak0(int count) {
    return '$count på rad. Uansett hva som sies i garderoben, så virker det.';
  }

  @override
  String yWinStreak1(int count) {
    return 'Det er $count strake. Lag snubler ikke inn i rekker som dette.';
  }

  @override
  String yWinStreak2(int count) {
    return '$count på rad og det fortsetter. Selvtilliten synes fra tribunen.';
  }

  @override
  String yWinStreak3(int count) {
    return 'Ubeseiret i $count. Spør hvem som helst som har vært trener: det er det vanskelige.';
  }

  @override
  String yWinStreak4(int count) {
    return '$count på rad. Nyt det mens kampprogrammet er snilt.';
  }

  @override
  String yWinStreak5(int count) {
    return '$count strake, og vi har ikke slått noen av betydning.';
  }

  @override
  String yWinStreak6(int count) {
    return 'En rekke på $count. Spør meg igjen når den blir testet.';
  }

  @override
  String yWinStreak7(int count) {
    return '$count på rad. Alle lag har en slik rekke i seg en gang.';
  }

  @override
  String yLossStreak0(int count) {
    return '$count uten seier nå. Til slutt går unnskyldningene tomme.';
  }

  @override
  String yLossStreak1(int count) {
    return 'Det er $count tap på rad. Dette er ikke et blaff lenger.';
  }

  @override
  String yLossStreak2(int count) {
    return '$count strake tap. Noen må stå til ansvar.';
  }

  @override
  String yLossStreak3(int count) {
    return 'Ingen seier på $count. Du ser det på måten de spiller.';
  }

  @override
  String yLossStreak4(int count) {
    return '$count uten seier og de samme feilene hver uke.';
  }

  @override
  String yLossStreak5(int count) {
    return '$count på rad. Uansett hva som prøves, virker det ikke.';
  }

  @override
  String yLossStreak6(int count) {
    return '$count strake. Dette er en retning, ikke en nedtur.';
  }

  @override
  String yLossStreak7(int count) {
    return 'Ingen seier på $count, og ingen i toppen har sagt et ord.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Si hva du vil om fotballen. Denne teller dobbelt.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Mot $opponent, av alle. $score. Ingen her kommer til å glemme det.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score mot $opponent. Den er det de kommer til å snakke om på pubene.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Naboer, $score. Retten til å skryte er avgjort for en stund.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Uansett hva annet som skjer i år, har vi dette.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score mot $opponent. Noen av oss trengte den mer enn tabellen gjorde.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Og de tar den tilbake neste gang, det gjør de alltid.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Mot $opponent, $score. Et helt år med påminnelser om denne.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name ut skadet. Det var det siste dette laget trengte.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Å miste $name endrer formen på alt.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name halter. Hold pusten.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Ingen $name på en stund, altså. Noen må ta ansvar.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name ute. Selvfølgelig er det $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Uten $name blir dette et helt vanlig lag.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name skadet igjen. Noen burde spørre hvorfor.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Mistet $name, og det er ingen bak ham. Det er det egentlige problemet.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Rødt til $name etter $minute minutter, og hele landet snur seg mot ham. Han har gitt oss mer enn de fleste. La det ligge.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name av etter $minute minutter. Hardt. Ti mann og vi tok likevel et tak, og det sier noe.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute minutter, rødt kort. Ti mann herfra.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Utvisning: $name etter $minute. Ikke den første kampen som snur på én avgjørelse.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Strålende. $name går etter $minute minutter og vi er nede på ti. Igjen.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name utvist etter $minute minutter. Hvem er det egentlig som trener disiplin her?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minutter. Så lenge klarte $name å holde hodet kaldt. Profesjonell fotball.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Rødt til $name etter $minute minutter, og jeg skal tro at dette er framgang.';
  }

  @override
  String get yBoardPressure0 =>
      'Styret har blitt veldig stille. Det er aldri et godt tegn.';

  @override
  String get yBoardPressure1 =>
      'Ryktene sier at styrerommet har begynt å stille spørsmål.';

  @override
  String get yBoardPressure2 => 'Du kjenner at bakken beveger seg i toppen.';

  @override
  String get yBoardPressure3 =>
      'Ingen i forbundet sier noe støttende. Trekk dine egne slutninger.';

  @override
  String get yBoardPressure4 =>
      'Ingen i toppen har støttet ham offentlig på flere uker nå.';

  @override
  String get yBoardPressure5 =>
      'Forbundet snakker ned sin egen landslagssjef. Som alltid.';

  @override
  String get yBoardPressure6 =>
      'Når et styre blir stille, har de allerede bestemt seg.';

  @override
  String get yBoardPressure7 =>
      'De lar dette drive til det er noen andres avgjørelse å ta.';

  @override
  String get yReplies => 'OGSÅ OM DENNE KAMPEN';

  @override
  String get yPlayerGrievance0 =>
      'Spurte hvor jeg står. Venter fortsatt på svar.';

  @override
  String get yPlayerGrievance1 => 'Trener hardt. Mer kan jeg ikke gjøre.';

  @override
  String get yPlayerGrievance2 => 'Noen spørsmål får man bare stille én gang.';

  @override
  String get yPlayerGrievance3 => 'Jeg kom ikke så langt for å bære vestene.';

  @override
  String get playerHonoursTitle => 'HEDERSPRISER';

  @override
  String get awardGoldenBall => 'Beste spiller';

  @override
  String get awardGoldenBoot => 'Toppscorer';

  @override
  String get awardGoldenGlove => 'Beste keeper';

  @override
  String get awardTeamOfTournament => 'Turneringens lag';

  @override
  String get awardPlayerOfYear => 'Årets verdensspiller';

  @override
  String get awardYoungPlayerOfYear => 'Årets unge spiller';

  @override
  String get playerClubHistory => 'KLUBBHISTORIKK';

  @override
  String get playerCareerRecord => 'KARRIEREREKORD';

  @override
  String get playerInternationalGoals => 'Landslagsmål';

  @override
  String get playerRecentForm => 'SISTE FORM';

  @override
  String get playerMatchHistory => 'KAMPHISTORIKK';

  @override
  String get playerAttributes => 'EGENSKAPER';

  @override
  String get playerUnknown => 'Ukjent';

  @override
  String get playerAttrPace => 'Fart';

  @override
  String get playerAttrPhysical => 'Fysikk';

  @override
  String get playerAttrTechnical => 'Teknikk';

  @override
  String get playerAttrShooting => 'Skudd';

  @override
  String get playerAttrPassing => 'Pasninger';

  @override
  String get playerAttrDribbling => 'Dribling';

  @override
  String get playerAttrTackling => 'Taklinger';

  @override
  String get playerAttrPositioning => 'Posisjonering';

  @override
  String get playerAttrComposure => 'Ro på ballen';

  @override
  String get playerAttrDecisions => 'Beslutninger';

  @override
  String get playerAttrStamina => 'Utholdenhet';

  @override
  String get playerAttrStrength => 'Styrke';

  @override
  String get playerStatCaps => 'Landskamper';

  @override
  String get playerStatGoals => 'Mål';

  @override
  String get playerStatAssists => 'Assist';

  @override
  String get playerStatAvgRating => 'Snittkarakter';

  @override
  String get playerStatForm => 'Form';

  @override
  String get playerStatMotm => 'Kampens spiller';

  @override
  String get playerStatCleanSheets => 'Holdt nullen';

  @override
  String get playerStatBestGame => 'Beste kamp';

  @override
  String get playerStatCards => 'Kort';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}G ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'DIN VEI';

  @override
  String get tourSharedList => 'Liste';

  @override
  String get tourSharedBracket => 'Turneringstre';

  @override
  String get tourSharedVs => 'mot';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Gruppe $seed';
  }

  @override
  String get tourSharedThisEdition => 'Denne utgaven';

  @override
  String get tourSharedAllTime => 'Gjennom tidene';

  @override
  String get tourSharedUnknown => 'Ukjent';

  @override
  String get tourSharedActive => 'AKTIV';

  @override
  String get tourSharedMedalTable => 'MEDALJETABELL';

  @override
  String get tourSharedPastWinners => 'TIDLIGERE VINNERE';

  @override
  String tourSharedHost(String host) {
    return 'Vert: $host';
  }

  @override
  String get tourSharedBeat => 'slo';

  @override
  String get tourSharedPens => ' (str.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Prisene avgjøres når turneringen er spilt ferdig.';

  @override
  String get tourSharedGoldenBall => 'BESTE SPILLER';

  @override
  String get tourSharedPlayerOfTournament => 'Turneringens spiller';

  @override
  String get tourSharedGoldenBoot => 'TOPPSCORER';

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
  String get tourSharedGoldenGlove => 'BESTE KEEPER';

  @override
  String get tourSharedTeamOfTournament => 'TURNERINGENS LAG';

  @override
  String get tourSharedStatsEmpty =>
      'Rekorder vises når konkurransen har litt historie.';

  @override
  String get tourSharedRecordScorer => 'REKORDSCORER';

  @override
  String get tourSharedStillActive => 'fortsatt aktiv';

  @override
  String get tourSharedMostTitles => 'FLEST TITLER';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titler',
      one: '1 tittel',
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
      other: '$count spilte finaler',
      one: '1 spilt finale',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'FLEST KAMPER';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kamper',
      one: '1 kamp',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'FLEST SLUTTSPILL';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sluttspill',
      one: '1 sluttspill',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'STØRSTE FINALESEIER';

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
  String get tourStatsStillActive => 'fortsatt aktiv';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titler',
      one: '1 tittel',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spilte finaler',
      one: '1 spilt finale',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kamper',
      one: '1 kamp',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sluttspill',
      one: '1 sluttspill',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'TIDENES LEDERE';

  @override
  String get tourStatsTabGames => 'Kamper';

  @override
  String get tourStatsTabCups => 'Turneringer';

  @override
  String get tourStatsTabScorers => 'Scorere';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'mot $opponent · $year';
  }

  @override
  String get tourHolders => 'TITTELHAVERE';

  @override
  String tourHoldersSince(int year) {
    return 'vant i $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'TIDENES SCORERE';

  @override
  String get tourSharedSummaryEmpty =>
      'Verten og stadionene vises når denne utgaven er trukket.';

  @override
  String get tourSharedHostHeading => 'VERT';

  @override
  String get tourSharedHostsHeading => 'VERTER';

  @override
  String get tourSharedCoHostsHeading => 'FELLESVERTER';

  @override
  String get tourSharedVenues => 'STADIONER';

  @override
  String get tourSharedMascot => 'MASKOT';

  @override
  String get tourSharedMatchBall => 'KAMPBALL';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity plasser';
  }

  @override
  String get tourSharedCouldNotLoad => 'Kunne ikke laste.';

  @override
  String get tourSharedHostTbc => 'VERT BEKREFTES SENERE';

  @override
  String get tourSharedFinalsAreHere => 'SLUTTSPILLET ER HER';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ARRANGERT AV  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'La sluttspillet begynne';

  @override
  String get tourSharedCompetitions => 'TURNERINGER';

  @override
  String get tourSharedWorldRanking => 'Verdensrankingen';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Kunne ikke laste turneringer.';

  @override
  String get tourSharedPrestigeStage => 'PRESTISJESCENEN';

  @override
  String get tourSharedOverview => 'Oversikt';

  @override
  String get tourSharedWorldRankingTitle => 'Verdensrankingen';

  @override
  String get tourSharedYourCompetitions => 'DINE TURNERINGER';

  @override
  String get tourSharedOtherContinents => 'ANDRE KONTINENTER';

  @override
  String get tourSharedComingSoon => 'Turneringen kommer snart';

  @override
  String get tourSharedSoon => 'SNART';

  @override
  String get tourSharedNoQualifyingDraw => 'Ingen kvalifiseringstrekning.';

  @override
  String get tourSharedOpenEnvelope => 'Åpne konvolutten';

  @override
  String tourSharedGroupName(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get tourSharedBall => 'Ball';

  @override
  String get tourSharedPot => 'Pott';

  @override
  String get tourSharedAll => 'Alle';

  @override
  String get tourSharedTapDrawTeam => 'Trykk for å trekke neste lag';

  @override
  String get tourSharedTapDrawPot => 'Trykk for å trekke neste pott';

  @override
  String get tourSharedTapDrawAll => 'Trykk for å vise hele trekningen';

  @override
  String get tourSharedContinue => 'Fortsett';

  @override
  String get tourSharedPause => 'Pause';

  @override
  String get tourSharedPlay => 'Spill av';

  @override
  String get tourSharedSkip => 'Hopp over';

  @override
  String tourSharedPotNumber(int number) {
    return 'POTT $number';
  }

  @override
  String get tourSharedDrawComplete => 'TREKNING FERDIG';

  @override
  String get tourSharedDrawing => 'TREKKER…';

  @override
  String get tourContChampionship => 'MESTERSKAP';

  @override
  String get tourContTabSummary => 'OPPSUMMERING';

  @override
  String get tourContTabQualifying => 'KVALIFISERING';

  @override
  String get tourContTabFinals => 'SLUTTSPILL';

  @override
  String get tourContTabBracket => 'TURNERINGSTRE';

  @override
  String get tourContTabAwards => 'PRISER';

  @override
  String get tourContTabScorers => 'SCORERE';

  @override
  String get tourContTabHistory => 'HISTORIKK';

  @override
  String get tourContTabRecords => 'REKORDER';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Kunne ikke laste cupen.\n$error';
  }

  @override
  String get tourContNoCupData => 'Ingen cupdata.';

  @override
  String get tourContUnknown => 'Ukjent';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Kvalifiseringsgruppene trekkes på seremonien. Se den fra Hjem for å se hvem du møter.';

  @override
  String get tourContQualSeeded =>
      'Landet ditt er seedet rett inn i sluttspillet. Ingen kvalifisering denne syklusen.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name simuleres i bakgrunnen. Resultatene vises her etter hvert som hver runde spilles.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Sluttspillgruppene trekkes på seremonien. Se den fra Hjem for å se gruppen din.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Trekningen til sluttspillet skjer når kvalifiseringen er ferdig.';

  @override
  String get tourContContestedBeforeWc =>
      'Utslagsrundene spilles før Verdensmesterskapet.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name-MESTERE';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name-vinnere';
  }

  @override
  String get tourContNoGoalsYet => 'Ingen mål scoret ennå.';

  @override
  String tourContGroupHeading(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get tourContBestRunnersUp => 'BESTE TOERE';

  @override
  String tourContGroupDropdown(String name) {
    return 'Gruppe $name';
  }

  @override
  String get tourContMatches => 'KAMPER';

  @override
  String get tourContNoGroupsDrawn => 'Ingen grupper trukket ennå.';

  @override
  String get tourContQualifyingDraw => 'KVALIFISERINGSTREKNING';

  @override
  String get tourContWorldQualifyingDraw => 'VM-KVALIFISERINGSTREKNING';

  @override
  String get tourContFinalsDraw => 'SLUTTSPILLTREKNING';

  @override
  String get tourContSeedingPots => 'SEEDINGPOTTER';

  @override
  String get tourContGroupDraw => 'GRUPPETREKNING';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Kunne ikke laste trekningen.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Trekningen er ikke klar ennå.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'DENNE SYKLUSEN';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Kunne ikke laste.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Fant ikke lagringen.';

  @override
  String get tourContClashSoon =>
      'Continental Clash spilles når begge kontinentale mestere er klare.';

  @override
  String get tourContTwoContinentsOneMatch => 'TO KONTINENTER, ÉN KAMP';

  @override
  String get tourContVersusShort => 'mot';

  @override
  String tourContWinTheClash(String name) {
    return '$name vinner Clash';
  }

  @override
  String get tourContNoClashYet => 'Ingen Continental Clash er spilt ennå.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'DIVISJONER';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Kunne ikke laste.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Ingen mål i Nations Cup er registrert ennå.';

  @override
  String get tourContNoNationsCupChampions =>
      'Ingen Nations Cup-mestere er kåret ennå.';

  @override
  String get tourContNationsCupOffSeason =>
      'Nations Cup for denne syklusen starter etter de kontinentale sluttspillene. Tidligere vinnere finner du under Historikk.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Gruppene i Nations Cup for denne syklusen trekkes i seremonien. Se trekningen fra Hjem for å se hvem du møter.';

  @override
  String get tourContLeagueNoGroups =>
      'Ingen kamper i denne divisjonen denne runden.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'DIVISJON $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'DIVISJON $letter · DIN DIVISJON';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Final Four spilles av gruppevinnerne i divisjon A når gruppespillet er ferdig.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Divisjon $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Divisjon $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEMIFINALER';

  @override
  String get tourContFinal => 'FINALE';

  @override
  String get tourContNationsCupDraw => 'TREKNING NATIONS CUP';

  @override
  String get tourContIntercontinentalPlayoff => 'INTERKONTINENTAL PLAYOFF';

  @override
  String get tourContNoPlayoffThisCycle => 'Ingen playoff denne syklusen.';

  @override
  String get tourContPlayoffIntro =>
      'To plasser i Verdensmesterskapet avgjøres i en utslagsturnering mellom de beste av de nest beste i kvalifiseringen.';

  @override
  String get tourContPlayoffThrough =>
      'Du kom deg gjennom playoffen. Du skal til Verdensmesterskapet!';

  @override
  String get tourContPlayoffOut =>
      'Du røk ut i playoffen. Ikke noe Verdensmesterskap denne gangen.';

  @override
  String get tourContContinue => 'Fortsett';

  @override
  String get tourContPlayoffFinals => 'PLAYOFF-FINALER';

  @override
  String get tourContPlayoffSeeded => 'Seedet (walkover)';

  @override
  String get tourCupTabSummary => 'OPPSUMMERING';

  @override
  String get tourCupTabQualifying => 'KVALIFISERING';

  @override
  String get tourCupTabPlayoff => 'PLAYOFF';

  @override
  String get tourCupPlayoffSoon =>
      'Den interkontinentale playoffen avgjøres når kvalifiseringen i alle kontinentale forbund er ferdig.';

  @override
  String get tourCupTabFinals => 'SLUTTSPILL';

  @override
  String get tourCupTabBracket => 'TURNERINGSTRE';

  @override
  String get tourCupTabAwards => 'PRISER';

  @override
  String get tourCupTabScorers => 'SCORERE';

  @override
  String get tourCupTabHistory => 'HISTORIKK';

  @override
  String get tourCupTabRecords => 'REKORDER';

  @override
  String get tourCupTitle => 'VERDENSMESTERSKAPET';

  @override
  String get tourCupNoData => 'Ingen cupdata.';

  @override
  String tourCupLoadError(String error) {
    return 'Kunne ikke laste cupen.\n$error';
  }

  @override
  String get tourCupUnknown => 'Ukjent';

  @override
  String get tourCupWorldChampions => 'VERDENSMESTERE';

  @override
  String get tourCupWorldChampionsTitle => 'Verdensmestere';

  @override
  String get tourCupStillActive => 'Fortsatt aktiv';

  @override
  String get tourCupAllTimeScorers => 'SCORERE GJENNOM TIDENE';

  @override
  String get tourCupAllConfederations => 'Alle kontinentale forbund';

  @override
  String get tourCupBestRunnersUp => 'Beste toere';

  @override
  String get tourCupCompWorld => 'Verdensmesterskapet';

  @override
  String get tourCupCompEurope => 'Europamesterskapet';

  @override
  String get tourCupCompSAmerica => 'Sør-Amerika-cupen';

  @override
  String get tourCupDestRoundOf16 => 'åttedelsfinalen';

  @override
  String get tourCupDestKnockouts => 'utslagsrundene';

  @override
  String get tourCupDestFinals => 'sluttspillet';

  @override
  String get tourCupDestFinalsPlayoff => 'sluttspill-playoffen';

  @override
  String get tourCupDestIntercontPlayoff => 'den interkontinentale playoffen';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Sluttspillet trekkes når kvalifiseringen er over.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Gruppene trekkes snart. Se trekningen til Verdensmesterskapet fra Hjem for å avsløre dem.';

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
    return 'Arrangert av $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Arrangert av $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Interkontinental playoff';

  @override
  String get tourCupKnockoutSoon =>
      'Turneringstreet starter når gruppespillet er over.';

  @override
  String get tourCupMatches => 'KAMPER';

  @override
  String get tourCupMedalTable => 'MEDALJETABELL';

  @override
  String get tourCupMostTitles => 'FLEST TITLER';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    String _temp0 = intl.Intl.pluralLogic(
      titles,
      locale: localeName,
      other: '$titles titler',
      one: '1 tittel',
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
  String get tourCupNoGoals => 'Ingen mål ennå.';

  @override
  String get tourCupNoGroups => 'Ingen grupper er trukket.';

  @override
  String get tourCupNoHistory => 'Ingen historikk ennå.';

  @override
  String get tourCupPastWinners => 'TIDLIGERE VINNERE';

  @override
  String get tourCupPlayoffIntro =>
      'To plasser i Verdensmesterskapet avgjøres i en utslagsturnering mellom de beste av de nest beste i kvalifiseringen.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation spiller ikke playoff: alle plassene avgjøres i kvalifiseringsgruppene.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Gruppene trekkes snart. Se kvalifiseringstrekningen fra Hjem for å avsløre dem.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · din';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (str.)';
  }

  @override
  String get tourCupSegAllTime => 'Gjennom tidene';

  @override
  String get tourCupSegFinals => 'Sluttspill';

  @override
  String get tourCupSegQualifying => 'Kvalifisering';

  @override
  String get playerTraitsTitle => 'KJENT FOR';

  @override
  String get traitBigGame => 'Storkampspiller';

  @override
  String get traitBigGameBlurb => 'Hever seg i utslagskamper.';

  @override
  String get traitSetPiece => 'Dødballspesialist';

  @override
  String get traitSetPieceBlurb => 'Bedre innlegg og flere mål på dødballer.';

  @override
  String get traitHothead => 'Hissigpropp';

  @override
  String get traitHotheadBlurb => 'Får langt flere kort enn lagkameratene.';

  @override
  String get traitIronMan => 'Jernmann';

  @override
  String get traitIronManBlurb =>
      'Blir sjelden skadet og går tom for krefter senere.';

  @override
  String get traitWonderkid => 'Vidunderbarn';

  @override
  String get traitWonderkidBlurb => 'Ung, allerede god og i rask utvikling.';

  @override
  String get traitLeader => 'Leder';

  @override
  String get traitLeaderBlurb => 'Løfter alle lagkameratene på banen.';

  @override
  String get traitPacey => 'Rask';

  @override
  String get traitPaceyBlurb =>
      'Svimlende fart, en trussel i ryggen på forsvaret.';

  @override
  String get traitOldHead => 'Rutinert';

  @override
  String get traitOldHeadBlurb =>
      'En veteran hvis spillforståelse varer lenger enn bena.';

  @override
  String get traitWasteful => 'Sløsete';

  @override
  String get traitWastefulBlurb => 'Setter for mange store sjanser utenfor.';

  @override
  String get objectiveWorldCup => 'Verdensmesterskapet';

  @override
  String get objectiveWinTournament => 'Vinn det';

  @override
  String get objectiveQualifyGeneric => 'Kvalifiser deg';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Vinn Verdensmesterskapet';

  @override
  String get objectiveReachFinal => 'Nå finalen';

  @override
  String get objectiveReachSemis => 'Nå semifinalen';

  @override
  String get objectiveReachQuarters => 'Nå kvartfinalen';

  @override
  String get objectiveReachKnockouts => 'Nå utslagsrundene';

  @override
  String get objectiveQualify => 'Kvalifiser deg til Verdensmesterskapet';

  @override
  String get finishChampions => 'Mestere';

  @override
  String get finishRunnersUp => 'Toere';

  @override
  String get finishSemiFinals => 'Semifinale';

  @override
  String get finishQuarterFinals => 'Kvartfinale';

  @override
  String get finishRoundOf16 => 'Åttedelsfinale';

  @override
  String get finishGroupStage => 'Gruppespill';

  @override
  String get objectiveQualifyingTopHalf =>
      'Bli i øvre halvdel av kvalifiseringen';

  @override
  String get objectiveQualifyingChallenge =>
      'Kjemp om en plass, minst øvre halvdel av kvalifiseringen';

  @override
  String get finishQualifyingTopHalf => 'Øvre halvdel av kvalifiseringsgruppen';

  @override
  String get finishQualifyingBottomHalf =>
      'Nedre halvdel av kvalifiseringsgruppen';

  @override
  String get objectiveNcWinIt => 'Vinn Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Nå finalen i Nations Cup';

  @override
  String get objectiveNcFinalsFour => 'Nå Final Four';

  @override
  String get objectiveNcWinGroup => 'Vinn gruppen og rykk opp';

  @override
  String get objectiveNcTopHalf => 'Bli i øvre halvdel av gruppen';

  @override
  String get objectiveNcSurvive => 'Unngå nedrykk';

  @override
  String get objectiveNcOffTheBottom => 'Unngå sisteplassen i gruppen';

  @override
  String get finishNcChampions => 'Nations Cup-vinnere';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Gruppevinnere';

  @override
  String get finishNcTopHalf => 'Øvre halvdel av gruppen';

  @override
  String get finishNcStayedUp => 'Berget plassen';

  @override
  String get finishNcClearOfBottom => 'Ikke sist i gruppen';

  @override
  String get finishNcBottom => 'Sist i gruppen';

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
  String get squadDevRetired => 'AVSLUTTET';

  @override
  String get squadDevEmpty => 'Et rolig år. Ingen endringer i troppen.';

  @override
  String get squadDevTierRegulars => 'FASTE';

  @override
  String get squadDevTierFringe => 'UTENFOR';

  @override
  String get squadDevTierYouth => 'UNGDOM';

  @override
  String get boardObjectivesTitle => 'Styrets mål';

  @override
  String get boardObjectivesConfidence => 'Styrets tillit';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds runder bedre enn krevd',
      one: 'én runde bedre enn krevd',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds runder for kort',
      one: 'én runde for kort',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'IKKE AVGJORT ENNÅ';

  @override
  String boardObjectiveSoFar(String result) {
    return 'HITTIL · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Styret har ikke satt noe mål for denne syklusen.';

  @override
  String get tourContBestWinners => 'BESTE GRUPPEVINNERE';

  @override
  String get tourContBestThirds => 'BESTE TREERE';

  @override
  String tourContBestPlaced(String position) {
    return 'BESTE $position.-PLASSERTE';
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
  String get matchSoldOut => 'UTSOLGT';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance av $capacity plasser fylt';
  }

  @override
  String get matchGroundTitle => 'ARENA';

  @override
  String get absenceInjured => 'Skadet';

  @override
  String get absenceSuspended => 'Suspendert';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString uker',
      one: '1 uke',
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
      other: '$countString kamper',
      one: '1 kamp',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Tilbake til kampen mot $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Straffer';

  @override
  String get penaltyOrderBlurb =>
      'Velg de fem skytterne, i rekkefølge. Trykk på en plass for å endre.';

  @override
  String penaltyOrderPick(int number) {
    return 'Spark $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Velg hvem som tar den. Streken viser roen på straffemerket.';

  @override
  String get penaltyOrderConfirm => 'Bekreft';

  @override
  String get penaltyOrderCancel => 'Tilbake';

  @override
  String get youthTitle => 'Ungdom';

  @override
  String get youthEmptyLevel => 'Ingen på dette nivået ennå.';

  @override
  String get youthReleased => 'Sluppet i år';

  @override
  String get u21Title => 'U21';

  @override
  String get u21Blurb =>
      'Neste generasjon, beste talent først. Tomme stjerner er et anslag fra speideren. Gi en spiller landskamp for å finne ut hva han virkelig har.';

  @override
  String get u21Empty =>
      'Ingen under 21 i spillerpoolen akkurat nå. Neste kull kommer med den nye syklusen.';

  @override
  String u21Breakout(int gain) {
    return '+$gain I ÅR';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps landskamper',
      one: '1 landskamp',
    );
    return 'Alder $age · $_temp0';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Alder $age · uten landskamp';
  }

  @override
  String get u21CallUps => 'Gå til uttak';

  @override
  String get youthWatching => 'Følger';

  @override
  String get youthWatchEmpty =>
      'Ingen markert ennå. Marker en gutt på et hvilket som helst nivå, så dukker han opp her, med det han har blitt siden.';

  @override
  String get youthWatchMark => 'Følg denne gutten';

  @override
  String get youthWatchUnmark => 'Slutt å følge ham';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Markert på $rating, $age år';
  }

  @override
  String get youthWatchSenior => 'Videre til seniorpoolen';

  @override
  String get youthWatchReleased => 'Sluppet av akademiet';

  @override
  String get youthWatchGone => 'Ikke lenger i pyramiden';

  @override
  String get tacticsYouth => 'U21';

  @override
  String get pressSquad => 'Tropp';

  @override
  String get pressBoard => 'Styre';

  @override
  String get pressNoEffect => 'Ingen leser mye inn i det';

  @override
  String get matchNeutralGround => 'NØYTRAL';

  @override
  String get matchExtraTimeAhead => 'EKSTRAOMGANGER';

  @override
  String get matchExtraTimeHalf => 'EKSTRAOMGANGER · PAUSE';

  @override
  String get matchClockFullTime => 'FULL TID';

  @override
  String get matchClockAfterExtraTime => 'ETTER EKSTRAOMGANGER';

  @override
  String get matchClockPenalties => 'STRAFFER';

  @override
  String get matchClockFullTimePenalties => 'FULL TID · STRAFFER';

  @override
  String get hubEventPressConference => 'Møt pressen';

  @override
  String get hubEventPressConferenceSub =>
      'Verdenspressen vil ha et ord før din neste kamp';

  @override
  String get squadDevWonderkid => 'VIDUNDERBARN';

  @override
  String get tacticsPlaystyle => 'Spillestil';

  @override
  String get tacticsPlaystyleBlurb =>
      'Velg hvordan laget spiller; knappene under finjusterer den.';

  @override
  String get tacticsPlaystyleCustom =>
      'Dine egne innstillinger. Ingen navngitt stil passer med disse knappene.';

  @override
  String get playstyleCustom => 'Egendefinert';

  @override
  String get playstyleBalanced => 'Balansert';

  @override
  String get playstylePossession => 'Ballbesittelse';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Kontring';

  @override
  String get playstyleDirect => 'Direkte';

  @override
  String get playstyleLowBlock => 'Lav blokk';

  @override
  String get playstyleWingPlay => 'Kantspill';

  @override
  String get playstyleBalancedBlurb =>
      'Solid i begge halvdeler, uten noe overdrevet.';

  @override
  String get playstylePossessionBlurb =>
      'Hold ballen, flytt den tålmodig, press banen sammen.';

  @override
  String get playstyleGegenpressBlurb =>
      'Vinn den tilbake i det øyeblikket den er tapt, høyt oppe på banen.';

  @override
  String get playstyleCounterBlurb =>
      'Trekk deg tilbake, hold formasjonen, og slå så til i fart.';

  @override
  String get playstyleDirectBlurb =>
      'Spill fremover tidlig og jakt andreballen.';

  @override
  String get playstyleLowBlockBlurb =>
      'Dypt, smalt og svært vanskelig å spille seg gjennom.';

  @override
  String get playstyleWingPlayBlurb =>
      'Strekk banen, gå utenpå og slå innlegg.';

  @override
  String get nationsRandomTeam => 'Tilfeldig lag';

  @override
  String get nationsFromTheBottom => 'Fra bunnen';

  @override
  String get bottomStartTitle => 'Uten jobb';

  @override
  String get bottomStartHeading => 'Tre forbund vil snakke med deg';

  @override
  String get bottomStartBlurb =>
      'Du har ingen jobb og ingen omdømme. Dette er de eneste lagene som tør å satse på deg. Velg ett og bygg noe av ingenting.';

  @override
  String get bottomStartAccept => 'Ta imot';

  @override
  String get bottomStartBack => 'Tilbake til menyen';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank av $total i verden';
  }

  @override
  String get campTitle => 'Basecamp';

  @override
  String campBasedIn(String host) {
    return 'Base i $host';
  }

  @override
  String get campBlurb =>
      'Der troppen bor gjennom hele turneringen. Det kan ikke endres når spillet har startet, og det påvirker tre ting i hver kamp: hvor uthvilte de kommer, hvor raskt en smell gror og hvor skarpe de er.';

  @override
  String get campEffectTravel => 'Kommer uthvilte';

  @override
  String get campEffectRecovery => 'Skader gror';

  @override
  String get campEffectSharpness => 'Kampskarphet';

  @override
  String get campTerrainCity => 'Sentrum';

  @override
  String get campTerrainCoastal => 'Kystdestinasjon';

  @override
  String get campTerrainMountain => 'Fjellretrett';

  @override
  String get campTerrainAltitude => 'Høydecamp';

  @override
  String get campTerrainNationalCentre => 'Nasjonalt senter';

  @override
  String get campTerrainCityBlurb =>
      'Alt rett utenfor døra og ingenting å reise til, men ingen ro og ingen fluktvei fra bråket.';

  @override
  String get campTerrainCoastalBlurb =>
      'Rolig, komfortabelt og bra for humøret; lang bussreise til hver arena.';

  @override
  String get campTerrainMountainBlurb =>
      'Kjølig luft og et førsteklasses medisinsk apparat som får skader til å gro raskt, langt unna turneringen.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Hardt å trene i, men gir bein som holder langt ut i turneringen.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Forbundets egne anlegg: ikke noe spektakulært, men heller ikke noe som kan gå galt.';

  @override
  String get hubEventChooseCamp => 'Velg basecamp';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Hvor troppen skal ha base i $host';
  }

  @override
  String get tacticsTabBench => 'Benk';

  @override
  String get squadSearchHint => 'Søk etter navn eller klubb';

  @override
  String get squadFilterAll => 'Alle';

  @override
  String get squadFilterInSquad => 'I troppen';

  @override
  String get squadFilterUncapped => 'Uten landskamp';

  @override
  String get squadFilterUnavailable => 'Utilgjengelige';

  @override
  String get squadLineAll => 'Alle linjer';

  @override
  String get squadSortBy => 'Sorter';

  @override
  String get squadSortRating => 'Karakter';

  @override
  String get squadSortCaps => 'Landskamper';

  @override
  String get squadSortGoals => 'Mål';

  @override
  String get squadSortAge => 'Alder';

  @override
  String get squadSortName => 'Navn';

  @override
  String get squadLegendTitle => 'Hva merkene betyr';

  @override
  String get squadLegendStarting => 'I startelleveren din';

  @override
  String get squadLegendCalledUp => 'Tatt ut, på benken';

  @override
  String get squadLegendInjured => 'Skadet, utilgjengelig';

  @override
  String get squadLegendSuspended => 'Suspendert, utilgjengelig';

  @override
  String get squadLegendTired =>
      'Sliten (gul) eller utslitt (rød): gi ham en kamp hvile';

  @override
  String get squadLegendShift =>
      'Hans egen endring i vurdering neste kamp (form, fysikk, klubb)';

  @override
  String get squadLegendTraits => 'KJENT FOR';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Viser $shown av $total spillere';
  }

  @override
  String get squadNobodyMatches => 'Ingen i poolen passer til disse filtrene.';

  @override
  String get squadStatPool => 'Pool';

  @override
  String get squadStatInSquad => 'Tatt ut';

  @override
  String get squadMostCapped => 'Flest landskamper';

  @override
  String get squadTopScorer => 'Toppscorer';

  @override
  String squadCapsValue(String name, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps landskamper',
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
      'Landskamper, mål og lagets viktigste rekorder';

  @override
  String get statsLegacy => 'ARV';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name er allerede byttet ut og kan ikke komme inn igjen.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name er utvist og deltar ikke mer.';
  }

  @override
  String get tacticsInjuredShort => 'SKADET';

  @override
  String get tacticsSuspendedShort => 'SUSPENDERT';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'Sør-Amerika';

  @override
  String get confNorthAmerica => 'Nord-Amerika';

  @override
  String get confAfrica => 'Afrika';

  @override
  String get confAsia => 'Asia';

  @override
  String get confOceania => 'Oseania';

  @override
  String get compWorldCup => 'Verdensmesterskapet';

  @override
  String get compWorldCupFinals => 'Sluttspillet i Verdensmesterskapet';

  @override
  String get compWorldCupQualifying => 'VM-kvalifisering';

  @override
  String compQualifiers(String region) {
    return 'Kvalifisering $region';
  }

  @override
  String get compFriendlies => 'Treningskamper';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Interkontinental playoff';

  @override
  String get compContinentalChampionship => 'Kontinentalmesterskapet';

  @override
  String get compEuropeanChampionship => 'Europamesterskapet';

  @override
  String get compSouthAmericaCup => 'Sør-Amerika-cupen';

  @override
  String get compAfricanChampionship => 'Afrikamesterskapet';

  @override
  String get compAsianChampionship => 'Asiamesterskapet';

  @override
  String get compNorthAmericaCup => 'Nord-Amerika-cupen';

  @override
  String get compOceaniaCup => 'Oseania-cupen';

  @override
  String get msgANation => 'Et land';

  @override
  String get msgAPlayer => 'En spiller';

  @override
  String get msgAHostNation => 'et vertsland';

  @override
  String get msgCycleTitle1 => 'En ny syklus begynner';

  @override
  String msgCycleTitle2(int year) {
    return 'Veien til $year åpner seg';
  }

  @override
  String get msgCycleTitle3 => 'En ny kampanje gryr';

  @override
  String get msgCycleTitle4 => 'Tilbake på jobb';

  @override
  String msgCycleBody1(int year) {
    return 'Veien til Verdensmesterskapet $year starter her.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'En ny syklus. Verdensmesterskapet $year er målet.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Fire år til Verdensmesterskapet $year. Arbeidet starter nå.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Kampanjen for $year begynner i dag.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Vert for $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host blir vert for neste $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Kvalifiseringstrekning $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Kvalifiseringsgruppene til $cup er trukket.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Vert for Verdensmesterskapet $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host blir vert for Verdensmesterskapet $year.';
  }

  @override
  String get msgWcQualDrawTitle =>
      'Kvalifiseringstrekning til Verdensmesterskapet';

  @override
  String get msgWcQualDrawBody =>
      'Kvalifiseringsgruppene til Verdensmesterskapet er trukket.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Sluttspilltrekning $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Sluttspillgruppene i $cup er trukket.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Sluttspilltrekning til Verdensmesterskapet';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Trekningen til sluttspillet i Verdensmesterskapet $year er gjort.';
  }

  @override
  String get msgQualWcTitle1 => 'Videre til Verdensmesterskapet';

  @override
  String get msgQualWcTitle2 => 'Plass i Verdensmesterskapet sikret';

  @override
  String get msgQualWcTitle3 => 'Vi skal til Verdensmesterskapet';

  @override
  String get msgQualWcTitle4 => 'Billetten er løst';

  @override
  String msgQualWcBody1(int year) {
    return 'Du har kvalifisert deg til sluttspillet i Verdensmesterskapet $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Det er offisielt: landet ditt er med i Verdensmesterskapet $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'En plass i Verdensmesterskapet $year er sikret.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Du er videre til sluttspillet i Verdensmesterskapet $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Videre til $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Plass i $cup sikret';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Kvalifisert til $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Du har kvalifisert deg til sluttspillet i $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Landet ditt har sikret seg en plass i $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Du er videre til $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: MESTERE!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Mestere i $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Du har vunnet $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp avgjort';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'Mesterne i $comp er kåret';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp er vunnet';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Landet ditt er mester i $comp $year etter å ha slått $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Du har vunnet $comp $year og sendt $loser hjem$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year er din. $loser slått$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner vant $comp $year og slo $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner er mester i $comp $year etter å ha slått $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' med $home–$away i finalen';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' på straffer, etter $home–$away i finalen';
  }

  @override
  String get msgWpotyTitle => 'Årets verdensspiller';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) er kåret til årets verdensspiller $year, en av dine.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) er kåret til årets verdensspiller $year.';
  }

  @override
  String get msgYpotTitle => 'Turneringens unge spiller';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age år, er kåret til turneringens unge spiller $year, en av dine.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age år, er kåret til turneringens unge spiller $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Du holder plassen som nr. $rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Ingen endring, fortsatt nr. $rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabilt som nr. $rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plasser',
      one: '1 plass',
    );
    return 'Opp $_temp0 totalt, til nr. $rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plasser',
      one: '1 plass',
    );
    return 'Et byks på $_temp0 løfter deg til nr. $rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plasser',
      one: '1 plass',
    );
    return 'Opp $_temp0, nå nr. $rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plasser',
      one: '1 plass',
    );
    return 'Ned $_temp0 totalt, til nr. $rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plasser',
      one: '1 plass',
    );
    return 'Et fall på $_temp0 sender deg ned til nr. $rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plasser',
      one: '1 plass',
    );
    return 'Ned $_temp0, nå nr. $rank.';
  }

  @override
  String get msgRankLeadYou => 'Du troner øverst i verden.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation troner øverst i verden.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Verdensrankingen · nr. $rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Verdensrankingen er oppdatert. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Et byks til nr. $rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Et fall til nr. $rank';
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
      other: '$move plasser',
      one: '1 plass',
    );
    return '$tournament har flyttet verdensrankingen. $nation startet som nr. $from og endte som nr. $to, en forbedring på $_temp0.';
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
      other: '$move plasser',
      one: '1 plass',
    );
    return '$tournament har flyttet verdensrankingen. $nation startet som nr. $from og endte som nr. $to, et fall på $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Siden trekningen til Verdensmesterskapet';

  @override
  String get rankingSinceCycleStart => 'Siden kampanjen begynte';

  @override
  String rankingMovedFromTo(int from, int now) {
    return 'nr. $from til nr. $now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name når $count landskamper';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name har nå spilt $count landskamper for landet ditt.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name når $count mål';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name har nå scoret $count landslagsmål for landet ditt.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Troppsutvikling · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Opp fra akademiet · $year';
  }

  @override
  String get msgThroughNote =>
      'Dette er ikke et nytt kull. Det er guttene som kom inn som elleveåringer og nå har vokst inn i seniorpoolen.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Nye fjes · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Satsingen på akademiet merkes: dette kullet kom sterkere enn det ellers ville gjort.';

  @override
  String get msgIntakeNoteStanding =>
      'Landet følger med på dette laget: nå som laget stiger på verdensrankingen, velger de beste guttene fotball, og dette kullet kom sterkere på grunn av det.';

  @override
  String get msgIntakeNoteBoth =>
      'Akademipengene og lagets stigning på verdensrankingen merkes begge: dette kullet kom sterkere enn det ellers ville gjort.';

  @override
  String msgIntakeTitle(int year) {
    return 'Akademikull · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Kapteinen din, $name, legger opp';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name legger opp på landslaget';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name har lagt opp på landslaget som $age-åring.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name har lagt opp på landslaget som $age-åring, og avslutter med $tally.';
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
      ' Kapteinsbindet er ledig. Utnevn en ny kaptein fra uttaksskjermen.';

  @override
  String msgHofTitle(String name) {
    return '$name tatt opp i Hall of Fame';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name blir med i landets Hall of Fame ($caps landskamper, $goals mål). Se dem under Legender.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name suspendert';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'de neste $matches kampene',
      one: 'din neste kamp',
    );
    return '$name $how og er utestengt i $_temp0. Spilleren er ikke tilgjengelig for uttak.';
  }

  @override
  String get hubBanHowSecondYellow => 'ble utvist for to gule kort';

  @override
  String get hubBanHowViolent => 'fikk direkte rødt for voldelig opptreden';

  @override
  String get hubBanHowRed => 'ble utvist';

  @override
  String hubInjuryTitle(String name) {
    return '$name skadet';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches kamper',
      one: '1 kamp',
    );
    return '$name fikk en smell og er ute i $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Toere';

  @override
  String get hubRunnerUpTitle2 => 'Så nær, men så langt unna';

  @override
  String get hubRunnerUpTitle3 => 'Sølvmedalje';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Du nådde finalen i $cup, men tapte mot $opponent. Så nær. Sølv denne gangen.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Slått av $opponent i finalen i $cup. Toere, smertefullt nær.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Finalen i $cup gled unna mot $opponent. Mye å være stolt av, men ikke pokalen.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Slått ut';

  @override
  String get hubKnockedOutTitle2 => 'Enden på veien';

  @override
  String get hubKnockedOutTitle3 => 'Reisen er over';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Du er ute av $cup, slått av $opponent i $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent avslutter $cup for deg i $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup er over i $stage, slått av $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Ute i gruppespillet';

  @override
  String get hubGroupExitTitle2 => 'Borte etter gruppespillet';

  @override
  String get hubGroupExitTitle3 => 'Tidlig i dusjen';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup er over etter gruppespillet. Det holdt ikke til utslagsrundene.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Du kom deg ikke videre fra gruppen. $cup slutter her.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Ingen plass i utslagsrundene denne gangen. $cup er over etter gruppespillet.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Mål nådd: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Mål ikke nådd: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Styrets mål i $comp: $demand. Du endte som: $finish. De har fått det de ba om.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Styrets mål i $comp: $demand. Du endte som: $finish. Det er under forventningene.';
  }

  @override
  String get newsWcMissTitle => 'Drømmen om Verdensmesterskapet er over';

  @override
  String newsWcMissBody(int year) {
    return 'Du kom ikke til Verdensmesterskapet $year. Kvalifiseringen holdt ikke. Fire nye år.';
  }

  @override
  String get newsRecordScorerTitle => 'Toppscorer gjennom tidene';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name er nå spillets meste målscorer gjennom tidene med $goals mål.';
  }

  @override
  String get newsRecordCapsTitle => 'Flest landskamper';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name er nå spillets mestspilte landslagsspiller med $caps landskamper.';
  }

  @override
  String get newsARecordBreaker => 'En ny rekordbryter';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name går til $club';
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
    return '$name ($position, $rating) har forlatt $fromClub og signert for $destination for $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club i $country';
  }

  @override
  String get newsTransferFree => 'Gratis';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name vil bytte til $nation!';
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
    return '$name, en $age år gammel $position med karakter $rating som nå spiller for $fromNation, har familiebånd til $nation og er åpen for å bytte. Åpne naturaliseringstilbudet for å godta eller avslå.';
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
    return '$name, en $age år gammel $position med karakter $rating som nå spiller for $fromNation, er et stjernenavn med familiebånd til $nation og er åpen for å bytte. Åpne naturaliseringstilbudet for å godta eller avslå.';
  }

  @override
  String get newsTheirNation => 'landet deres';

  @override
  String get newsYourNation => 'landet ditt';

  @override
  String get tourStatusChampions => 'MESTERE';

  @override
  String get tourStatusFinals => 'SLUTTSPILL';

  @override
  String get tourStatusQualifying => 'KVALIFISERING';

  @override
  String get tourStatusUpcoming => 'KOMMER';

  @override
  String get tourStatusInProgress => 'PÅGÅR';

  @override
  String get tourStatusComingSoon => 'SNART';

  @override
  String get tourStatusDecided => 'AVGJORT';

  @override
  String tourStatusLeague(String letter) {
    return 'DIVISJON $letter';
  }

  @override
  String get tourDrawWcQualifying => 'VM-KVALIFISERINGSTREKNING';

  @override
  String tourDrawContQualifying(String cup) {
    return 'KVALIFISERINGSTREKNING $cup';
  }

  @override
  String get tourDrawWcHost => 'VM-VERT';

  @override
  String tourDrawContHost(String cup) {
    return 'VERT FOR $cup';
  }

  @override
  String get tourDrawHostsReveal => 'Og vertene blir …';

  @override
  String get tourDrawHostReveal => 'Og verten blir …';

  @override
  String get tourDrawHostCandidates => 'Kandidatene som er med i kampen:';

  @override
  String get tourKickoffContinentalCup => 'KONTINENTALCUP';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Gikk glipp av $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Du kvalifiserte deg ikke til $cup. Kampanjen holdt ikke denne gangen.';
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
      other: '$count assist',
      one: '1 assist',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Helhet $value';
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
    return '$name er verdens beste spiller i år.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name får prisen for årets unge spiller.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Guttene du følger med på, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain poeng',
      one: 'ett poeng',
    );
    return '$name har tatt et steg opp til $rating, $_temp0 mer enn i fjor.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name rykker opp til $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name debuterer';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name har tatt sin første landskamp som $age-åring, med karakter $rating. En av guttene du følger med på.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Ballbesittelse, spillerkarakterer og kampens spiller avgjøres ved sluttsignalet.';

  @override
  String get matchPlayerRatings => 'SPILLERKARAKTERER';

  @override
  String get matchSubstitutions => 'BYTTER';

  @override
  String get matchSubstitutes => 'RESERVER';

  @override
  String get matchLineupsViewPitch => 'Bane';

  @override
  String get matchLineupsViewList => 'Liste';

  @override
  String get matchLineupsCameOn => 'Byttet inn';

  @override
  String get matchConditionsKickOff => 'Avspark';

  @override
  String get matchWeatherClear => 'Klart';

  @override
  String get matchWeatherRain => 'Lett regn';

  @override
  String get matchWeatherSnow => 'Snø';

  @override
  String get matchWeatherHaze => 'Dis';

  @override
  String get matchWeatherHeavyRain => 'Kraftig regn';

  @override
  String get matchWeatherThunderstorm => 'Tordenvær';

  @override
  String get matchWeatherFog => 'Tåke';

  @override
  String get matchWeatherWindy => 'Kraftig vind';

  @override
  String get matchWeatherDustStorm => 'Sandstorm';

  @override
  String get matchWeatherFrostyNight => 'Frostnatt';

  @override
  String get matchPlayerOfTheMatch => 'KAMPENS SPILLER';

  @override
  String get ratingPlayerOfTheMatch => 'Kampens spiller';

  @override
  String ratingSemantics(String rating) {
    return 'Karakter $rating';
  }

  @override
  String get matchAverageRating => 'Snittkarakter';

  @override
  String get matchLiveRatingsNote =>
      'Karakterene følger kampen så langt og er endelige ved sluttsignalet.';

  @override
  String get matchGoalShout => 'MÅL!';

  @override
  String get matchRedCardShout => 'RØDT KORT';

  @override
  String matchShootoutScore(int home, int away) {
    return 'STRAFFER $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: SCORET';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: MISTET';
  }

  @override
  String get matchFeedKickOff => 'Avspark!';

  @override
  String get matchFeedNoEvents => 'Ingen hendelser ennå.';

  @override
  String get tourVenues => 'STADIONER';

  @override
  String tourPot(int number) {
    return 'POTT $number';
  }

  @override
  String get tourHostSelection => 'VALG AV VERT';

  @override
  String get tourCandidates => 'KANDIDATER';

  @override
  String get tourJointBid => 'FELLES BUD';

  @override
  String get tourGoldenGlove => 'BESTE KEEPER';

  @override
  String get tourTeamOfTournament => 'TURNERINGENS LAG';

  @override
  String get tourYourRun => 'DIN VEI';

  @override
  String get tourMedalTable => 'MEDALJETABELL';

  @override
  String tourHostLine(String nation) {
    return 'Vert: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Verter: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Gruppe $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Seedet etter verdensrankingen. Finn landet ditt før trekningen.';

  @override
  String get tourWorldRanking => 'Verdensrankingen';

  @override
  String get tourYourCompetitions => 'DINE TURNERINGER';

  @override
  String get tourOtherContinents => 'ANDRE KONTINENTER';

  @override
  String get tourZoneGlobal => 'VERDEN';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'S-AMERIKA';

  @override
  String get tourZoneNorthAmerica => 'N-AMERIKA';

  @override
  String get tourZoneAfrica => 'AFRIKA';

  @override
  String get tourZoneAsia => 'ASIA';

  @override
  String get tourZoneOceania => 'OSEANIA';

  @override
  String get tourZoneIntercontinental => 'INTERKONTINENTAL';

  @override
  String tourZoneLeague(String league) {
    return 'DIVISJON $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'ARRANGERT AV  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Topp $count går videre til $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name gir seg';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps landskamper',
      one: '1 landskamp',
    );
    return '$name har lagt opp på landslaget som $age-åring, med $_temp0. Han ba om beskjed om hvor han sto, fikk ingen, og orker ikke vente lenger.';
  }

  @override
  String get pressHeadlineWent1 => 'En trener som styrer rommet';

  @override
  String get pressHeadlineWent2 => 'De kom for å få bråk og møtte en leder';

  @override
  String get pressHeadlineWent3 => 'Rake svar, og de traff';

  @override
  String get pressHeadlineMixed1 => 'Mye sagt, lite avklart';

  @override
  String get pressHeadlineMixed2 => 'Noe for alle, og ingenting for noen';

  @override
  String get pressHeadlineMixed3 =>
      'En pressekonferanse som lot spørsmålene stå åpne';

  @override
  String get pressHeadlineBadly1 => 'En brutal ettermiddag foran kameraene';

  @override
  String get pressHeadlineBadly2 => 'Stemningen snudde, og det var tydelig';

  @override
  String get pressHeadlineBadly3 =>
      'Svar som vil høres verre ut i morgen tidlig';

  @override
  String get pressHeadlineFlat1 => 'Ingenting sagt, ingenting vunnet';

  @override
  String get pressHeadlineFlat2 => 'Ti minutter, ingen nyheter';

  @override
  String get pressHeadlineFlat3 => 'Et blankt ark til baksiden';

  @override
  String get pressConferenceTitle => 'PRESSEKONFERANSE';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Spørsmål $index av $total';
  }

  @override
  String get pressTomorrowsHeadline => 'MORGENDAGENS BAKSIDE';

  @override
  String get pressLeaveRoom => 'FORLAT ROMMET';

  @override
  String get pressRoomVerdictSquad => 'Garderoben';

  @override
  String get pressRoomVerdictBoard => 'Styret';

  @override
  String get yReactionElation0 => 'ingen merknader. ingen. perfekt.';

  @override
  String get yReactionElation1 => 'Jeg er ikke frisk (positivt).';

  @override
  String get yReactionElation2 => 'rammer dette inn. henger det over peisen.';

  @override
  String get yReactionElation3 => 'vi er så tilbake';

  @override
  String get yReactionElation4 =>
      'Tar skjermbilde av dette til alle tvilerne. Hver eneste en.';

  @override
  String get yReactionElation5 =>
      'Jeg kommer til å være uutholdelig om dette i et tiår.';

  @override
  String get yReactionElation6 => 'Der ja. Det er derfor vi ser på.';

  @override
  String get yReactionElation7 => 'Dager som dette gjør opp for de andre.';

  @override
  String get yReactionElation8 => 'På tide. Helt ærlig, på tide.';

  @override
  String get yReactionElation9 =>
      'Flott. Gjør det igjen neste uke, så tror jeg på det.';

  @override
  String get yReactionElation10 =>
      'Nyt kvelden, for gjengen der finner en måte å ødelegge det på.';

  @override
  String get yReactionElation11 => 'En god kveld gjør ingen til et godt lag.';

  @override
  String get yReactionRelief0 => 'Ikke pent, men det tar jeg hver eneste gang.';

  @override
  String get yReactionRelief1 => 'På et vis. På et vis!';

  @override
  String get yReactionRelief2 => 'Stygt. Tre poeng. Videre.';

  @override
  String get yReactionRelief3 => 'Jeg tar stygt hele dagen hvis det gir poeng.';

  @override
  String get yReactionRelief4 => 'det tok ti år av livet mitt';

  @override
  String get yReactionRelief5 => 'Ingen snakker. Ingen jinxer det.';

  @override
  String get yReactionRelief6 => 'Puls: uakseptabel.';

  @override
  String get yReactionRelief7 => 'Overlevd. Det er ordet. Overlevd.';

  @override
  String get yReactionRelief8 =>
      'Vi burde ikke trenge å puste ut etter kamper som det.';

  @override
  String get yReactionRelief9 => 'Letta, og litt flau over å være letta.';

  @override
  String get yReactionRelief10 =>
      'Hvis det er standarden vi jubler for, har vi et problem.';

  @override
  String get yReactionRelief11 =>
      'Å snike seg igjennom er en vane, og ikke en god en.';

  @override
  String get yReactionFury0 => 'Ikke godt nok. Ikke i nærheten.';

  @override
  String get yReactionFury1 => 'Noen må forklare meg dette sakte.';

  @override
  String get yReactionFury2 => 'Det er tungt å se på, og jeg er høflig.';

  @override
  String get yReactionFury3 => 'Skuffet. Oppriktig skuffet.';

  @override
  String get yReactionFury4 => 'Helt håpløst.';

  @override
  String get yReactionFury5 => 'Jeg vil ha navn.';

  @override
  String get yReactionFury6 => 'Sletter appen. Installerer den igjen torsdag.';

  @override
  String get yReactionFury7 => 'Ingen der ute så ut som de ville det.';

  @override
  String get yReactionFury8 => 'Hvert fjerde år, det samme. HVERT fjerde år.';

  @override
  String get yReactionFury9 =>
      'Det er ikke en prestasjon, det er en fornærmelse.';

  @override
  String get yReactionFury10 =>
      'Folk ofrer helger og penger for dette. Tenk på det.';

  @override
  String get yReactionFury11 =>
      'Jeg har forsvart dette laget i årevis. Ikke i kveld. Ikke etter det der.';

  @override
  String get yReactionDespair0 => 'vel.';

  @override
  String get yReactionDespair1 => 'Ingen vitser i dag. Ingenting.';

  @override
  String get yReactionDespair2 => 'Går en tur. En lang en.';

  @override
  String get yReactionDespair3 => 'Jeg har gått tom for måter å si dette på.';

  @override
  String get yReactionDespair4 => 'Vekk meg om fire år.';

  @override
  String get yReactionDespair5 => 'dette er den mørkeste tidslinjen';

  @override
  String get yReactionDespair6 =>
      'Ikke engang sint lenger. Det er det urovekkende.';

  @override
  String get yReactionDespair7 => 'Den kommer til å svi lenge.';

  @override
  String get yReactionDespair8 =>
      'Jeg vet ikke hva dette er lenger, men det er ikke et fotballag.';

  @override
  String get yReactionDespair9 =>
      'Vi er lenger unna enn før, og ingen vil si det.';

  @override
  String get yReactionDespair10 =>
      'En hel generasjon bortkastet, og de samme folkene bestemmer hva som skjer videre.';

  @override
  String get yReactionDespair11 =>
      'Slutt å si at det er en prosess. Den går ingen vei.';

  @override
  String get yReactionSmugness0 => 'Stille, men: sa det jo.';

  @override
  String get yReactionSmugness1 => 'bokmerk denne';

  @override
  String get yReactionSmugness2 => 'Tvilerne har blitt veldig stille.';

  @override
  String get yReactionSmugness3 => 'Ikke at noen teller. Jeg teller.';

  @override
  String get yReactionSmugness4 => 'Sa det i januar. Sjekk tidslinjen.';

  @override
  String get yReactionSmugness5 =>
      'Noen av dere skylder noen av oss en unnskyldning.';

  @override
  String get yReactionSmugness6 => 'Legger denne under ting jeg sa først.';

  @override
  String get yReactionSmugness7 => 'Ingen skadefryd. Litt skadefryd.';

  @override
  String get yReactionSmugness8 => 'Hvor er alle ekspertene nå? Ærlig talt.';

  @override
  String get yReactionSmugness9 =>
      'Jeg vil at hver eneste en av dere sier det tilbake til meg.';

  @override
  String get yReactionSmugness10 =>
      'Skjermbilde, printet, innrammet, sendt til de som lo.';

  @override
  String get yReactionSmugness11 =>
      'Jeg kommer til å dra dette opp resten av livet, og dere har fortjent det.';

  @override
  String get yReactionShrug0 => 'det skjedde. neste.';

  @override
  String get yReactionShrug1 => 'Greit. Samme det. Videre.';

  @override
  String get yReactionShrug2 => 'Legger denne under «fotball».';

  @override
  String get yReactionShrug3 => 'Har ærlig talt ingenting å tilføye.';

  @override
  String get yReactionShrug4 => 'ingen tanker, hodet tomt';

  @override
  String get yReactionShrug5 => 'Vekk meg til neste.';

  @override
  String get yReactionShrug6 => 'Nitti minutter jeg aldri får tilbake.';

  @override
  String get yReactionShrug7 => 'Hverken eller, egentlig.';

  @override
  String get yReactionShrug8 =>
      'Kunne ikke fortalt deg én eneste ting som skjedde.';

  @override
  String get yReactionShrug9 => 'En til av den typen. Det er mange av dem.';

  @override
  String get yReactionShrug10 => 'Jeg så hele greia og kjente ingenting.';

  @override
  String get yReactionShrug11 =>
      'Hvis ingen nevner dette igjen, er det helt greit for meg.';

  @override
  String get tourThirdsUneven =>
      'Gruppene er ulike store, så resultater mot bunnlaget i hver stor gruppe strykes, og alle lag vurderes over like mange kamper.';

  @override
  String get careerExportSave => 'Sikkerhetskopier denne lagringen';

  @override
  String get careerBackupAll => 'SIKKERHETSKOPIER ALLE';

  @override
  String get careerBackupAllFailed => 'Kunne ikke skrive sikkerhetskopien.';

  @override
  String get backupTitle => 'SIKKERHETSKOPIER';

  @override
  String get backupBlurb =>
      'Alle lagrede spill ligger i én fil på denne telefonen, og ingenting tar kopi av dem av seg selv med mindre du slår på automatisk sikkerhetskopi nedenfor. Ha en kopi i skyen, så en mistet telefon eller en slettet app ikke koster deg en karriere.';

  @override
  String get backupBlurbNoAuto =>
      'Alle lagrede spill ligger i én fil på denne telefonen, og ingenting tar kopi av dem av seg selv. Ha en kopi i skyen, så en mistet telefon eller en slettet app ikke koster deg en karriere.';

  @override
  String get backupExport => 'SIKKERHETSKOPIER TIL SKYEN';

  @override
  String get backupExportSubject => 'FNM-lagringer';

  @override
  String get backupRestore => 'GJENOPPRETT FRA FIL';

  @override
  String get backupRestoreWarnTitle => 'Erstatte alle lagringer?';

  @override
  String get backupRestoreWarnBody =>
      'Gjenoppretting erstatter alle lagringer på denne telefonen med de i filen. Appen starter på nytt.';

  @override
  String get backupRestoreConfirm => 'ERSTATT';

  @override
  String get backupCancel => 'AVBRYT';

  @override
  String get backupExported =>
      'Sikkerhetskopien er klar. Velg hvor du vil ta vare på den.';

  @override
  String get backupFailed => 'Kunne ikke skrive sikkerhetskopien.';

  @override
  String get backupRejectedUnreadable => 'Filen kunne ikke åpnes.';

  @override
  String get backupRejectedNotFnm => 'Dette er ikke en FNM-lagring.';

  @override
  String get backupRejectedNewer =>
      'Lagringen er laget med en nyere versjon av appen. Oppdater først.';

  @override
  String get backupRejectedTooOld =>
      'Lagringen er for gammel til å gjenopprettes av denne versjonen.';

  @override
  String get careerShare => 'Del denne karrieren';

  @override
  String get careerImport => 'IMPORTER EN KARRIERE';

  @override
  String get careerShareSubject => 'En FNM-karriere';

  @override
  String get careerImported => 'Karrieren er importert.';

  @override
  String get careerImportFailedUnreadable => 'Filen er ikke en FNM-karriere.';

  @override
  String get careerImportFailedNewer =>
      'Karrieren er eksportert fra en nyere versjon av appen. Oppdater først.';

  @override
  String get careerImportFailedSlotsFull =>
      'Alle lagringsplassene dine er i bruk. Slett en lagring for å få plass, eller lås opp ubegrenset med lagringer.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Karrieren er forbi den gratis første syklusen. Lås opp hele spillet for å ta den inn.';

  @override
  String get careerImportFailedCampaignRun =>
      'Den kampanjen har allerede en løpende karriere. Fortsett eller gi opp den først.';

  @override
  String get careerShareFailed => 'Kunne ikke eksportere karrieren.';

  @override
  String get managerRename => 'Endre navn';

  @override
  String get managerRenameSave => 'Lagre';

  @override
  String get managerTitle => 'TRENER';

  @override
  String get managerSkills => 'FERDIGHETENE DINE';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poeng å bruke',
      one: '1 poeng å bruke',
      zero: 'Ingen poeng å bruke',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'To poeng for hver syklus du fullfører, ett for hver tittel du vinner.';

  @override
  String get managerSkillsScale =>
      'Alle ferdigheter starter på 5 og stopper på 20. Et brukt poeng er permanent.';

  @override
  String get managerSkillManManagement => 'Menneskeledelse';

  @override
  String get managerSkillManManagementBlurb =>
      'Hvert poeng gjør at det du sier til pressen og spillerne treffer 3 % hardere i garderoben.';

  @override
  String get managerSkillTactical => 'Taktikk';

  @override
  String get managerSkillTacticalBlurb =>
      'Hvert poeng får en ny formasjon til å sitte 3 % raskere, så formasjonsbytter koster deg færre kamper.';

  @override
  String get managerSkillYouth => 'Ungdomsutvikling';

  @override
  String get managerSkillYouthBlurb =>
      'Hvert poeng gir 1 % mer talent ut av akademiet ditt, på toppen av det du finansierer det med.';

  @override
  String get managerSkillNegotiation => 'Forhandling';

  @override
  String get managerSkillNegotiationBlurb =>
      'Hvert poeng gir 2 % mer penger fra forbundet, hver syklus.';

  @override
  String get managerStaff => 'STABEN DIN';

  @override
  String managerStaffWages(String amount) {
    return 'Lønn: $amount per syklus';
  }

  @override
  String get managerRoleAssistant => 'Assistenttrener';

  @override
  String get managerRoleAssistantBlurb =>
      'Leder treningen: færre skader og bedre unggutter som kommer opp.';

  @override
  String get managerRoleScout => 'Sjefsscout';

  @override
  String get managerRoleScoutBlurb =>
      'Leser talentene dine og neste motstander: sannere stjernekarakterer og en fordel på kampdagen.';

  @override
  String get managerRoleFitness => 'Fysisk trener';

  @override
  String get managerRoleFitnessBlurb => 'Holder dem på banen.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent % færre skader';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Unggutter +$points i styrke';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Ansetter du en: $min % til $max % færre skader';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'og unggutter +$minPoints til +$maxPoints i styrke';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Leser $percent % av talentene riktig';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potensial kjent etter $caps landskamper',
      one: 'Potensial kjent etter 1 landskamp',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points karakter fra motstanderdossierer';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Ansetter du en: $min % til $max % av vurderingene riktige';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'og potensial kjent $minCaps til $maxCaps landskamper tidligere';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'og +$minPoints til +$maxPoints karakter hver kamp';
  }

  @override
  String get staffEffectNone => 'Ingen effekt på troppen ennå';

  @override
  String get staffVacant => 'Ingen i stillingen';

  @override
  String get staffLeaveVacant => 'La stillingen stå tom';

  @override
  String get managerTierNone => 'Ingen';

  @override
  String get managerTierBasic => 'Enkel';

  @override
  String get managerTierGood => 'God';

  @override
  String get managerTierElite => 'Elite';

  @override
  String get managerFree => 'gratis';

  @override
  String get managerTraining => 'MELLOM UTTAKENE';

  @override
  String get managerTrainingBlurb =>
      'Det troppen jobber med når det ikke er kamp.';

  @override
  String get managerFocusBalanced => 'Balansert';

  @override
  String get managerFocusBalancedBlurb => 'Litt av alt.';

  @override
  String get managerFocusFitness => 'Kondisjon';

  @override
  String get managerFocusFitnessBlurb => 'Færre smeller.';

  @override
  String get managerFocusCohesion => 'Samspill';

  @override
  String get managerFocusCohesionBlurb => 'Formasjonen sitter raskere.';

  @override
  String get managerFocusYouth => 'Ungdom';

  @override
  String get managerFocusYouthBlurb => 'Timer med de yngste i spillerpuljen.';

  @override
  String get tourOfferTitle => 'Første gang her?';

  @override
  String get tourOfferBody =>
      'Dette er et stort spill. Vil du ha en rask omvisning i skjermbildene som betyr noe? Det tar et minutt, og du kan starte den igjen når som helst fra innstillingene.';

  @override
  String get tourOfferYes => 'Vis meg rundt';

  @override
  String get tourOfferNo => 'Nei takk';

  @override
  String get tourBack => 'Tilbake';

  @override
  String get tourNext => 'Neste';

  @override
  String get tourDone => 'Ferdig';

  @override
  String get tourSkip => 'Hopp over';

  @override
  String get tourHubTitle => 'Dette er hele spillet';

  @override
  String get tourHubBody =>
      'Én knapp, og den endrer seg underveis i syklusen: en trekning å se, en tropp å ta ut, en kamp å spille. Over den ser du styrets tillit til deg og målene de har satt.';

  @override
  String get tourBudgetTitle => 'Forbundets penger';

  @override
  String get tourBudgetBody =>
      'Én gang hver fireårssyklus fordeler du krigskassen mellom avdelingene. Staben din lønnes først, så å ansette en elite-scout er et valg du tar mot akademiet, ikke ved siden av det.';

  @override
  String get tourTacticsTitle => 'Hvordan laget spiller';

  @override
  String get tourTacticsBody =>
      'Formasjonen din, spillestilen din, kapteinen din og hvem som tar dødballene. La de to siste stå uvalgt, så advarer spillet deg før avspark i stedet for å velge stille for deg.';

  @override
  String get tourSquadTitle => 'Alle du kan velge';

  @override
  String get tourSquadBody =>
      'Hele spillerpuljen, ikke bare troppen: hvem som er i form, hvem som har en smell, hvem som er utestengt og hvem som nettopp har kommet opp fra akademiet.';

  @override
  String get tourCallUpsTitle => 'Ta ut en tropp';

  @override
  String get tourCallUpsBody =>
      'Du tar ut én tropp per landslagssamling, og den spiller alle kampene i samlingen, akkurat som en ekte landslagssjef gjør. En skade i samlingen henter inn en erstatter for deg.';

  @override
  String get tourRecordsTitle => 'Karrieren din';

  @override
  String get tourRecordsBody =>
      'Alt du har gjort: kampene, lagrekordene, titlene og hvert land du har ledet.';

  @override
  String get tourCupsTitle => 'Resten av verden';

  @override
  String get tourCupsBody =>
      'Alle turneringer som pågår akkurat nå: grupper, tabeller og utslagskamper, også de du ikke er med i. Verden spiller videre uansett om du kvalifiserte deg eller ikke.';

  @override
  String get settingsTourTitle => 'Se veiledningen igjen';

  @override
  String get settingsTourBlurb =>
      'Gå gjennom de viktigste skjermbildene igjen fra start.';

  @override
  String get tourBoardTitle => 'Hvem du svarer til';

  @override
  String get tourBoardBody =>
      'Styrets tillit til deg og målene de har satt for denne syklusen. Bommer du på oppdraget, ser du det komme her.';

  @override
  String get tourStaffTitle => 'Menneskene rundt deg';

  @override
  String get tourStaffBody =>
      'En assistent, en scout og en fysisk trener, ansatt ved navn. Lønnen deres tas fra dette budsjettet før avdelingene, så en strålende scout er et valg mot akademiet.';

  @override
  String get tourPlaystyleTitle => 'Spillestilen din';

  @override
  String get tourPlaystyleBody =>
      'Formasjonen er bare halve taktikken. Dette er den andre halvparten: hvor høyt du presser, hvor direkte du spiller, hvor mye du risikerer.';

  @override
  String get settingsTourNoSave =>
      'Start en karriere først. Omvisningen går innom dine egne skjermbilder.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Ute av posisjon · $age år';
  }

  @override
  String get federationNextCycleLocked =>
      'Budsjettet for neste syklus settes ved starten av den, i ett strekk. Til da er dette det pengene dine gjør.';

  @override
  String get federationBudgetAlreadySet => 'Allerede satt for denne syklusen';

  @override
  String yFinalLooms0(String opponent) {
    return 'Det blir $opponent i den store. Hele uken kommer alle til å snakke om ingenting annet.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Bekreftet: $opponent står mellom oss og pokalen. Fire år for dette.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Greit. $opponent. Ingen får sove før dette er over.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent neste, og alt annet kan vente. For en uke å leve i.';
  }

  @override
  String get matchSetupLeaveToCoach => 'La treneren velge spesialistene';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Markert under: lag som spiller som $rivals, lagene du møter i gruppene dine denne syklusen.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Overgangsvindu · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Sist for $when siden';
  }

  @override
  String get settingsFreeScopeTitle => 'Én gratis fireårssyklus';

  @override
  String get settingsFreeScopeBlurb =>
      'En hel syklus (kvalifisering, ditt kontinentale mesterskap og Verdensmesterskapet) på to lagringer, alle land i verden, ingenting holdt tilbake. Endeløse sykluser og ubegrensede lagringer er én enkelt betaling, én gang, med oppdateringer inkludert.';

  @override
  String get settingsUnlockedTitle => 'Låst opp';

  @override
  String get settingsUnlockedBlurb =>
      'Endeløse sykluser, ubegrensede lagringer, oppdateringer inkludert. Takk.';

  @override
  String get settingsFromDeveloperTitle => 'Fra utvikleren';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager er laget av én person og vil bli støttet i lang tid fremover. Det blir aldri reklame eller mikrotransaksjoner. Hvis du liker spillet, vurder å kjøpe hele versjonen. Det er det som holder oppdateringene i gang.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager er laget av én person og vil bli støttet i lang tid fremover. Det blir aldri reklame eller mikrotransaksjoner. Takk for at du kjøpte hele versjonen. Det er det som holder oppdateringene i gang.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Markert under: lag som spiller som $rivals, som du fortsatt skal møte.';
  }

  @override
  String get friendliesCloseToYou =>
      'Markert under: lagene som ligger nærmest deg på verdensrankingen. Når du er trukket, følger markeringene gruppen din.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count overganger',
      one: '1 overgang',
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
  String get transfersOlder => 'Flere';

  @override
  String get transfersPagePrevious => 'Forrige';

  @override
  String get transfersPageNext => 'Neste';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Side $page av $pages';
  }

  @override
  String get transfersMovedTo => 'Gikk til';

  @override
  String get transfersUnknownClub => 'Ukjent klubb';

  @override
  String yAgainstThemAgain0(String opponent, int count) {
    return 'Det er $count ganger mot $opponent nå. Noen fører regnskap, og det er dem.';
  }

  @override
  String yAgainstThemAgain1(String opponent, int count) {
    return '$opponent igjen. $count møter, og vi har fortsatt ikke knekt dem.';
  }

  @override
  String yAgainstThemAgain2(String opponent, int count) {
    return 'Nummer $count mot $opponent. Dette er ikke tilfeldig lenger.';
  }

  @override
  String yAgainstThemAgain3(String opponent, int count) {
    return 'Vi har spilt mot $opponent $count ganger og lært ingenting av noen av dem.';
  }

  @override
  String yAgainstThemAgain4(String opponent, int count) {
    return '$opponent, $count ganger. De vet nøyaktig hva vi kommer til å gjøre.';
  }

  @override
  String yAgainstThemAgain5(String opponent, int count) {
    return 'Hva enn $opponent har på oss, $count møter inn, har de det fortsatt.';
  }

  @override
  String ySameOldStory0(int count) {
    return 'Dette har skjedd $count ganger i det siste. Når er det bare sånn vi er?';
  }

  @override
  String ySameOldStory1(int count) {
    return '$count ettermiddager som dette nå. Det er et mønster, ikke flaks.';
  }

  @override
  String ySameOldStory2(int count) {
    return 'Vi har sett akkurat denne kampen $count ganger i det siste. Samme manus, samme slutt.';
  }

  @override
  String ySameOldStory3(int count) {
    return '$count versjoner av de samme nitti minuttene nå. Ingen fikser det.';
  }

  @override
  String ySameOldStory4(int count) {
    return '$count ganger. Ser du ikke mønsteret nå, så ser du ikke etter.';
  }

  @override
  String ySameOldStory5(int count) {
    return 'Samme historie, $count ganger. Unnskyldningene tok slutt før resultatene gjorde det.';
  }

  @override
  String get yToldYouSo0 =>
      'Jeg sa at dette kom mens alle var opptatt med å feire.';

  @override
  String get yToldYouSo1 =>
      'To gode uker og vi var en gullgenerasjon igjen. Og her er vi.';

  @override
  String get yToldYouSo2 =>
      'De som ba meg nyte det forrige måned har blitt stille.';

  @override
  String get yToldYouSo3 =>
      'Jeg tar ingen glede av dette. Svært lite glede. Litt.';

  @override
  String get yToldYouSo4 =>
      'Det var aldri så bra som de sa, og dette er beviset.';

  @override
  String get yToldYouSo5 =>
      'Hver gang. Vi får høre at det er annerledes, og hver gang er det ikke det.';

  @override
  String get tacticsSubOffAlready => 'Allerede byttet ut';

  @override
  String get tacticsSubInjured => 'Skadet';

  @override
  String get tacticsSubSentOffMark => 'Utvist';

  @override
  String get tacticsSubNoneLeft => 'Ingen bytter igjen';

  @override
  String get tacticsUndoLastChange => 'Angre siste bytte';

  @override
  String get matchStrengthTitle => 'HVA SOM PÅVIRKER LAGET';

  @override
  String get strengthFactorFamiliarity => 'Innøvd formasjon';

  @override
  String get strengthFactorFatigue => 'Tunge bein';

  @override
  String get strengthFactorClubForm => 'Klubbform';

  @override
  String get strengthFactorMorale => 'Garderoben';

  @override
  String get strengthFactorCaptain => 'Kaptein';

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
    return 'Debut for $name. Man ser det på ham, ikke sant?';
  }

  @override
  String yDebut2(String name) {
    return '$name, første landskamp. La oss se hva han gjør med den.';
  }

  @override
  String yDebut3(String name) {
    return 'Debut for $name. Troppen trengte friske bein et sted.';
  }

  @override
  String yDebut4(String name) {
    return '$name får en landskamp. Vi har delt ut mange av dem i det siste.';
  }

  @override
  String yDebut5(String name) {
    return 'Debut for $name. Enda en vi har glemt til våren.';
  }

  @override
  String yDrought0(String name, int count) {
    return '$name har gått $count uten å score og gjør alt annet på banen.';
  }

  @override
  String yDrought1(String name, int count) {
    return '$count kamper uten mål for $name. De kommer i bunter, det har de alltid gjort.';
  }

  @override
  String yDrought2(String name, int count) {
    return '$name: $count kamper, ingen mål.';
  }

  @override
  String yDrought3(String name, int count) {
    return '$count uten mål for $name. Verdt å holde et øye med.';
  }

  @override
  String yDrought4(String name, int count) {
    return '$count kamper. Ingen mål. $name kunne ikke truffet en låvevegg.';
  }

  @override
  String yDrought5(String name, int count) {
    return '$name har ikke scoret på $count. Spill bokstavelig talt hvem som helst andre.';
  }

  @override
  String yRivalryLooms0(String opponent, int count) {
    return '$opponent neste. $count møter og det betyr fortsatt alt.';
  }

  @override
  String yRivalryLooms1(String opponent, int count) {
    return '$count ganger mot $opponent nå. Kom an.';
  }

  @override
  String yRivalryLooms2(String opponent, int count) {
    return '$opponent neste. Spilt $count.';
  }

  @override
  String yRivalryLooms3(String opponent, int count) {
    return 'Møte nummer $count med $opponent denne uken.';
  }

  @override
  String yRivalryLooms4(String opponent, int count) {
    return '$opponent igjen. $count av disse og vi har ikke lært noe.';
  }

  @override
  String yRivalryLooms5(String opponent, int count) {
    return '$count kamper mot $opponent og de slår oss fortsatt. Fantastisk.';
  }

  @override
  String get positionGoalkeeper => 'Keeper';

  @override
  String get positionLeftBack => 'Venstreback';

  @override
  String get positionCentreBack => 'Midtstopper';

  @override
  String get positionRightBack => 'Høyreback';

  @override
  String get positionDefensiveMid => 'Defensiv midtbane';

  @override
  String get positionCentralMid => 'Sentral midtbane';

  @override
  String get positionAttackingMid => 'Offensiv midtbane';

  @override
  String get positionLeftMid => 'Venstre midtbane';

  @override
  String get positionRightMid => 'Høyre midtbane';

  @override
  String get positionLeftWing => 'Venstre kant';

  @override
  String get positionRightWing => 'Høyre kant';

  @override
  String get positionStriker => 'Spiss';

  @override
  String get roleNone => 'Ingen rolle';

  @override
  String get roleTargetMan => 'Targetspiss';

  @override
  String get rolePoacher => 'Måljeger';

  @override
  String get rolePlaymaker => 'Playmaker';

  @override
  String get roleBallWinner => 'Ballvinner';

  @override
  String get roleInvertedWinger => 'Invertert kant';

  @override
  String get roleBallPlayingDefender => 'Ballspillende forsvarer';

  @override
  String get roleNoneBlurb => 'Spiller sitt naturlige spill.';

  @override
  String get roleTargetManBlurb =>
      'Vinner hodedueller, legger av. Assist og dødballer.';

  @override
  String get rolePoacherBlurb => 'Lurer i boksen. Mange flere mål.';

  @override
  String get rolePlaymakerBlurb => 'Skaper sjanser. Langt flere assist.';

  @override
  String get roleBallWinnerBlurb =>
      'Bryter opp spillet i stedet for å avslutte det.';

  @override
  String get roleInvertedWingerBlurb => 'Skjærer inn for å skyte. Flere mål.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Starter angrep bakfra.';

  @override
  String get federationDeptYouth => 'Ungdomsakademi';

  @override
  String get federationDeptCommercial => 'Kommersiell / PR';

  @override
  String get federationDeptMedical => 'Medisin og idrettsvitenskap';

  @override
  String get federationDeptNaturalisation => 'Naturaliseringskontor';

  @override
  String get federationDeptBoardRelations => 'Styrerelasjoner';

  @override
  String get federationDeptYouthBlurb =>
      'Bedre akademitalenter debuterer for landet ditt neste syklus.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsorer gir ekstra inntekter på slutten av syklusen.';

  @override
  String get federationDeptMedicalBlurb =>
      'Færre skader. Troppen din er tilgjengelig hele syklusen.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Flere utenlandske spillere tilbyr seg å bytte til landet ditt.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Styret vurderer resultatene dine med mer tålmodighet.';

  @override
  String get federationBuildingAcademy => 'Akademi';

  @override
  String get federationBuildingCommercial => 'Kommersielt hovedkontor';

  @override
  String get federationBuildingMedical => 'Medisinsk senter';

  @override
  String get federationBuildingScouting => 'Speiderkontor';

  @override
  String get federationBuildingBoardroom => 'Styrerom';

  @override
  String get moraleBuoyant => 'Oppløftet';

  @override
  String get moralePositive => 'Positiv';

  @override
  String get moraleSettled => 'Rolig';

  @override
  String get moraleUneasy => 'Urolig';

  @override
  String get moraleRockBottom => 'Bunnen';

  @override
  String get matchTabTimeline => 'FORLØP';

  @override
  String get matchTabStats => 'STATISTIKK';

  @override
  String get matchTabLineups => 'OPPSTILLINGER';

  @override
  String get matchPenalty => 'STRAFFE';

  @override
  String get matchStateLevel => 'Det er uavgjort';

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
    return '$possession % ballbesittelse';
  }

  @override
  String get boardVerdictSackedTitle => 'Styret har avskjediget deg';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'En elendig syklus (vurdering $rating %). Perioden din slutter her. Bare svakere land tar en sjanse på deg nå.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Styret er henrykt';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'En enestående syklus (vurdering $rating %) etter $best. Større land er interessert, eller du kan bli og bygge videre.';
  }

  @override
  String get boardVerdictSolidTitle => 'En solid syklus';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Styret er fornøyd (vurdering $rating %). Noen få land på samme nivå ville tatt deg, men det er ikke noe press for å dra.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Styret forventet mer';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'En skuffende syklus (vurdering $rating %). Du beholder jobben, men alle tilbud er et steg ned.';
  }

  @override
  String get boardVerdictPressureTitle => 'Du er under reelt press';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'En dårlig syklus (vurdering $rating %). Du overlever, men bare svakere land er interessert hvis du vil starte på nytt.';
  }

  @override
  String get boardVerdictHeroTitle => 'Nasjonen står bak deg';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles sykluser',
      one: '1 syklus',
    );
    return ' $nation elsker deg, en nasjonalhelt etter $_temp0; jobben din er trygg så lenge du vil ha den.';
  }

  @override
  String get boardVerdictTheNation => 'Nasjonen';

  @override
  String get boardVerdictBestQuiet => 'en rolig syklus';

  @override
  String get boardVerdictBestCycle => 'syklusen';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Verdensmesterskapet: $placement';
  }

  @override
  String get finishThirdPlace => 'Tredjeplass';

  @override
  String get finishFourthPlace => 'Fjerdeplass';

  @override
  String get finishDidNotQualify => 'Kvalifiserte seg ikke';

  @override
  String get careerRepIconic => 'Ikonisk';

  @override
  String get careerRepRenowned => 'Anerkjent';

  @override
  String get careerRepEstablished => 'Etablert';

  @override
  String get careerRepRising => 'På vei opp';

  @override
  String get careerRepUnproven => 'Uprøvd';

  @override
  String get hubOfferStepUp => 'Et steg opp';

  @override
  String get hubOfferLateral => 'Sidesteg';

  @override
  String get hubOfferRebuild => 'En gjenoppbygging';

  @override
  String careerNationsCupWon(String league) {
    return 'Divisjon $league · Mestere';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Divisjon $league · Sølvvinnere';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Divisjon $league · Semifinalist';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Divisjon $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Inn i $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Inn i bronsefinalen';

  @override
  String tourRunThrough(String round) {
    return 'Videre fra $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Slått ut i $round';
  }

  @override
  String get tourRunInGroup => 'Kjemper i gruppespillet';

  @override
  String get tourRunGroupOut => 'Slått ut i gruppespillet';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Syklus $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played spilt  ·  ${won}S ${drawn}U ${lost}T';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Verdensmesterskapet: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Spilles fortsatt';

  @override
  String yTurnedItRound0(String opponent) {
    return 'To mål bak mot $opponent til pause, og de tok alt igjen. Det er et lag.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'To bak mot $opponent, og til slutt spilte det ingen rolle. Det er ikke mange lag som får det til.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Pause: to mål bak mot $opponent. Full tid: ikke det. Andre omgang var en helt annen kamp.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Kom tilbake fra 0–2 mot $opponent. Hva enn som ble sagt i pausen, si det hver uke.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Greit, vi tok det igjen mot $opponent. Nå kan noen forklare de første førtifem minuttene.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'To bak mot $opponent, og vi skal være fornøyde. Fiks første omgang.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'To opp mot $opponent til pause, og det glapp. Det skjer med bedre lag.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'To mål foran mot $opponent, og det rant ut i sanden. Lang syklus foran oss, god tid.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Pause: to mål opp mot $opponent. Full tid: langt derfra.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'En ledelse på to mål mot $opponent, borte på under førtifem minutter.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'To opp, og vi mistet det. Mot $opponent. Noen må svare for det.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'To mål foran mot $opponent, og vi klarte dette. Hver eneste gang.';
  }

  @override
  String get cycleBackupDone =>
      'Karrieren er sikkerhetskopiert til FNM-mappen på denne telefonen. Avinstallerer du appen, forsvinner den: for å ta vare på en kopi andre steder, bruk Sikkerhetskopier denne lagringen på lagringsskjermen.';

  @override
  String get cycleBackupFailed =>
      'Klarte ikke å sikkerhetskopiere karrieren denne gangen.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'En kveld å huske mot $opponent. Hvor stolt er du av denne gruppen?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent hang ikke med. Er dette laget du alltid trodde du hadde?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'En stor seier over $opponent. Hva utgjorde forskjellen i kveld?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent slått, og det klart. Hvor vant dere den?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'En god seier over $opponent. Én god kveld: hvorfor skal noen tro at det varer?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Et fint resultat mot $opponent. Var det planen din, eller fant spillerne ut av det selv?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'En tøff kveld mot $opponent. Hva sier du til spillerne etter en sånn kamp?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Ingen så det komme mot $opponent. Var det bare en sånn kveld?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Det var en ydmykende kveld mot $opponent. Hva gikk galt?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent spilte dere sønder og sammen. Er denne troppen god nok?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Dere var et steg bak på alt mot $opponent. Hvordan lot du det bli så ille?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent scoret etter forgodtbefinnende. Hvor var planen i kveld?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Enda en som glapp, denne gangen mot $opponent. Hvordan snur du denne rekken?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Resultatene har tørket inn, og $opponent gjorde det verre. Tror du fortsatt på denne gruppen?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Ingen seier igjen, nå mot $opponent, og styret følger med. Er jobben din trygg?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Etter $opponent begynner rekken å bli lang. Er du bekymret for fremtiden din?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Nå $opponent også. Forgjengeren din ble sparket på en rekke som denne. Hvorfor skal du overleve den?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Etter enda en kveld som mot $opponent vil hver eneste radiodebatt ha deg ut. Ville du gått av hvis styret ba om det?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Du satte jobben på spill, og etter $opponent gikk det ikke din vei. Hvordan holder du ut?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'De tre kampene er ferdige, den siste mot $opponent. Du satte testen selv. Hva mener du om dommen?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Du ba oss dømme deg på de neste tre. Etter $opponent har vi gjort det. Er jobben fortsatt din?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Tre kamper, den siste mot $opponent, og ikke det du lovet. Har du snakket med styret om fremtiden din?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Du satte testen selv og strøk mot $opponent. Kommer du til å gå av?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Dine ord, ikke våre: døm meg på de neste tre. Etter $opponent, hvorfor sitter du fortsatt der?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Du vil ha mer fra dem. Noen spesielle?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Du har lagt listen høyt. Hvem må ta steget først?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Du sier at noen av dem må se på seg selv. Hvem mener du?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Ikke god nok, sier du. Hvem snakker du om?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Du holder det vagt. Vil du navngi noen, eller faller det tilbake på deg?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Hver uke er det noen andres skyld. Hvem sin er den denne gangen?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Modige ord. Og hvis den neste ikke går veien din?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Landet kommer til å holde deg til det. Hva hvis det ikke går i boks?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'Og hvis du ikke vinner den? Hva da?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Nå har du sagt det. Hva skjer hvis du tar feil?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Vi har hørt løfter i dette rommet før. Hva skylder du supporterne hvis også dette brytes?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Og når det ikke skjer, hva blir unnskyldningen?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Ett til, hvis du orker. Hva må denne gruppen fortsatt jobbe med?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Når støvet har lagt seg, hva tar du med deg fra i kveld inn i neste kamp?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'La oss gå litt dypere. Hva må bli bedre før neste kamp?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Hvis vi ser forbi resultatet: er troppen der du vil ha den?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Mange ord, lite sagt. Hva endrer seg egentlig herfra?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Supporterne vil ha et rett svar. Er dette laget godt nok, ja eller nei?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player var enestående i kveld. Hvor langt kan han komme?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player er i alle overskrifter i kveld. Så du det komme?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player utmerket seg. Hva ba du ham om i kveld?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Var $player forskjellen i kveld?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Uten $player er det en annen historie. Er dette et lag, eller én spiller?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player var strålende. Din fortjeneste, eller hans?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player hadde en tøff kveld. Har han en skade?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player fikk ikke sin kveld. Kommer du til å legge en arm rundt ham?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player slet i kveld. Beholder han plassen?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player så ut til å ligge etter tempoet. Hva syntes du om kampen hans?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player var en passasjer igjen. Hvorfor fortsetter du å velge ham?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Alle kunne se at $player ikke var på hugget. Alle unntatt benken?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Du sa du skulle vinne den neste, og det gjorde du. Føles det godt å ha rett?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Du lovet seier i neste kamp og leverte. Selvtillit eller bravade?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Du sa du skulle vinne den neste, og det gjorde du. Flaks, eller skal vi begynne å lytte?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Du sa at du skulle vinne den kampen. Det skjedde ikke. Hva gikk galt?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Du sa du skulle vinne den neste. Det gjorde du ikke. Hvorfor skal vi tro på det neste løftet?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Du sa du skulle vinne den neste. Det gjorde du ikke. Betyr ordene dine noe i dette rommet lenger?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Du ba om å bli dømt på tre kamper, og du besto. Rettferdiggjort?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Døm meg på de neste tre, sa du. Det gjorde vi, og resultatene kom. Hva lærte du av den testen?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Du ga deg selv tre kamper og kom deg gjennom dem. Var testen noen gang så vanskelig?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Du ba om å bli dømt på tre kamper. De gikk ikke din vei. Hva har du lært?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Du sa døm meg på de neste tre. De tre er over, og tvilen kommer ikke deg til gode lenger. Hva nå?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Du satte testen og strøk. Hvorfor skal noen ta deg på ordet nå?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Du støttet $player da andre ikke ville. Han leverte. Noe av æren din?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Du støttet $player. Han leverte. Tro, eller kunnskap?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Du støttet $player, og for en gangs skyld lønte det seg. Blir du like sikker neste gang?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Du sto bak $player, og det har ikke gått opp. Tror du fortsatt på ham?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Du støttet $player. Han har ikke betalt tilbake. Var det en feil?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Din dømmekraft eller din lojalitet: hva sviktet med $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Du var hard mot $player, og kampene siden har gitt deg rett. Noen tilfredsstillelse i det?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Du felte $player offentlig, og han har ikke svart. Finnes det en vei tilbake for ham?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Du hengte ut $player, og han har ikke kommet seg. Knekte du ham?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Du felte $player, og han svarte på banen. Var det planen hele tiden?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Du ga $player skylden, og siden har han vært en av dine beste. Skylder du ham en unnskyldning?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Du kastet $player under bussen, og han har vært din beste spiller siden. Kommer du til å be om unnskyldning?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Disse spillerne ga meg alt. Jeg ville ikke byttet bort en eneste en.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Ingen jobber hardere enn denne gruppen. Jeg forsvarer dem hele dagen.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Du får ikke høre et ondt ord om spillerne mine fra denne stolen.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Spillerne fortjener æren, ikke jeg. Skriv om dem.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Den er min. Jeg tok ut laget, og jeg stilte dem opp.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Døm meg, ikke dem. Det er mitt lag og mitt ansvar.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Hvis du vil ha noen å skylde på, sitter jeg rett her.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Ansvaret er mitt. La spillerne være utenfor.';

  @override
  String get pressReplyDemandMore1 =>
      'Jeg vil ha mer. Noen av dem vet nøyaktig hva jeg mener.';

  @override
  String get pressReplyDemandMore2 =>
      'Innsats er ikke nok på dette nivået. Jeg vil ha mer, og jeg har sagt det til dem.';

  @override
  String get pressReplyDemandMore3 =>
      'Jeg forventer mer av hver eneste en av dem, fra i morgen.';

  @override
  String get pressReplyDemandMore4 =>
      'Noen av dem må se på seg selv. Jeg er ikke fornøyd.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Vi vinner den neste. Du kan skrive det ned.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Merk mine ord: vi vinner neste kamp.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Neste kamp vinner vi. Jeg sier det her så dere kan holde meg til det.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Jeg er sikker på dette laget. Vi vinner neste kamp.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Døm meg på de neste tre kampene. Det er rimelig.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Gi meg tre kamper. Er det ikke på plass innen da, døm meg på det.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'De neste tre viser om jeg er rett mann. Hold meg til det.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Tre kamper. Så kan dere skrive hva dere vil om meg.';

  @override
  String get pressReplyDeflect1 =>
      'Vi tar én kamp av gangen. Ikke mer å tilføye.';

  @override
  String get pressReplyDeflect2 =>
      'Jeg skal ikke lage overskrifter for dere i dag.';

  @override
  String get pressReplyDeflect3 => 'Neste kamp. Det er alt jeg tenker på.';

  @override
  String get pressReplyDeflect4 => 'Det jeg mener, blir i garderoben.';

  @override
  String get pressReplyTakeCredit1 =>
      'Jeg sa det fordi jeg trodde på det, og jeg hadde rett.';

  @override
  String get pressReplyTakeCredit2 =>
      'Jeg leste det riktig. Det er det jeg er her for.';

  @override
  String get pressReplyTakeCredit3 =>
      'Kall det dømmekraft. Jeg visste hva jeg sa.';

  @override
  String get pressReplyTakeCredit4 =>
      'Jeg tok avgjørelsen, og den gikk i boks. Det tar jeg.';

  @override
  String get pressReplyStandByIt1 =>
      'Jeg sa det jeg trodde på. Jeg står ved det.';

  @override
  String get pressReplyStandByIt2 => 'Jeg tar ikke tilbake et eneste ord.';

  @override
  String get pressReplyStandByIt3 =>
      'Samme svar som da. Jeg mente det, og det gjør jeg fortsatt.';

  @override
  String get pressReplyStandByIt4 => 'Jeg ville sagt det igjen i morgen.';

  @override
  String get pressReplyAdmitMistake1 => 'Der tok jeg feil. Det står jeg for.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Greit nok, jeg bommet. Jeg lærer av det.';

  @override
  String get pressReplyAdmitMistake3 => 'Jeg tok feil, og det kan jeg si.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Den avgjørelsen fungerte ikke, og den var min.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player har min fulle støtte. Han kommer til å blomstre.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Jeg tror på $player, og han skal vise dere hvorfor.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Du får ikke høre et ondt ord om $player fra meg. Han kommer til å levere.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player er fortsatt i planene mine. Følg med på hva han gjør neste gang.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player sviktet oss i kveld, og det vet han.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Jeg forventet langt mer av $player. Det må han svare for.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player var ikke på nivå. Det sier jeg offentlig.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Det var ikke bra nok fra $player, og det får han høre av meg.';
  }

  @override
  String get pressOnRecordWinNext => 'For protokollen: du vinner neste kamp.';

  @override
  String get pressOnRecordJob => 'For protokollen: døm deg på de neste tre.';

  @override
  String pressOnRecordBack(String player) {
    return 'For protokollen: du støtter $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'For protokollen: $player sviktet deg.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Han sa det, og det skjedde. $nation har en trener som mener det han sier.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Sa det høyt, og gjorde det så. Det er mannen $nation trengte.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: han spådde det, og det ble sant. Fair nok.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Han satte det på protokollen, og det holdt. Ett poeng til ham. $nation går videre.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Han fikk én riktig. $nation, ikke bli vant til det.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Selv en stoppet klokke har rett to ganger i døgnet. $nation var heldige denne gangen.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Han sa det, og det gikk ikke i boks. Jeg er fortsatt med ham. $nation går på igjen.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: han lovet mer enn vi fikk, men jeg vil heller ha en trener som tror på seg selv.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: han sa det for protokollen, og det skjedde ikke. Folk kommer til å huske det.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Store ord, ingenting bak. $nation: neste gang, si mindre.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Han sto der og fortalte oss det. Så dette. $nation fortjener bedre enn snakk.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Ordet hans er ingenting verdt nå. Skriv det ned, $nation.';
  }

  @override
  String get ncZoneNorth => 'Nordsonen';

  @override
  String get ncZoneWest => 'Vestsonen';

  @override
  String get ncZoneEast => 'Østsonen';

  @override
  String get ncZoneCentralSouthern => 'Sentral- og Sørsonen';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Mestere';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Sølvvinnere';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Semifinalist';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Åttedelsfinale';
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
  String get objectiveNcZoneWinGroup => 'Vinn gruppen din';

  @override
  String get finishNcFinalsEight => 'Kvartfinale';

  @override
  String get finishNcBottomHalf => 'Nedre halvdel av gruppen';

  @override
  String get tourContTabZones => 'SONER';

  @override
  String get tourContTabFinalsEight => 'UTSLAGSRUNDER';

  @override
  String get tourContFinalsEightSoon =>
      'Utslagsrundene starter i november med åttedelsfinaler: alle 14 gruppevinnerne og de 2 beste toerne.';

  @override
  String get tourContQuarterFinals => 'KVARTFINALER';

  @override
  String get tourContZoneAdvancement =>
      'Hver gruppevinner går videre til åttedelsfinalen, sammen med de 2 beste toerne. Ingen rykker ned.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Nations Cup for Nord-Amerika';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Vinn Nations Cup for Nord-Amerika';

  @override
  String get objectiveNcWinItAfrica => 'Vinn Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Nå finalen i Nations Cup for Nord-Amerika';

  @override
  String get objectiveNcReachFinalAfrica => 'Nå finalen i Nations Cup';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Vinnere av Nations Cup for Nord-Amerika';

  @override
  String get finishNcChampionsAfrica => 'Vinnere av Nations Cup';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Kvalifiseringen til $competition starter nå, og landet tror på dette laget. Hva sikter du mot?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'En ny kvalifiseringskampanje til $competition, og stemningen er høy. Hvor langt kan dette laget gå?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Kvalifiseringen til $competition begynner. Hva er målet for denne kampanjen?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Kvalifiseringen til $competition er her. Hvor ser du dette laget ende?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Kvalifiseringen til $competition starter, og mange tviler på at dere kommer dit. Hva sier du til dem?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Enda en kvalifiseringskampanje til $competition. Hvorfor skal noen tro at denne blir annerledes?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition er her, og hele landet står bak deg. Hvor langt kan dere gå?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Dere er i $competition, og supporterne drømmer. Hva er målet?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition starter denne uken. Hva ville regnes som en suksess?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Første kamp i $competition nærmer seg. Gi oss et mål.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition er her, og ingen forventer mye. Hva håper du egentlig på?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Dere er i $competition, men tvilen har ikke forsvunnet. Hva er målet ditt?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival er i gruppen din. Bekymrer de deg?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Trekningen satte $rival i veien for dere. Hvordan ser du på den kampen?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival ser ut som det sterkeste laget i gruppen din. Er de favoritter?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Hva synes du om $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival er i gruppen din. Vær ærlig, kan dere henge med dem?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'De fleste forventer at $rival slår dere. Tar de feil?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player er i fin form. Er dette hans øyeblikk?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player er i alle overskrifter. Kan han bære dette laget?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Hvor mye avhenger denne kampanjen av $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Er $player klar til å lede dette laget?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Hvis $player ikke er på sitt beste, har dette laget noe å tilby?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player har mye på skuldrene. For mye?';
  }

  @override
  String get pressReplyAimHigher1 => 'Vi går lenger enn noen forventer.';

  @override
  String get pressReplyAimHigher2 =>
      'Jeg vil ha mer enn forbundet ba om, og det sier jeg høyt.';

  @override
  String get pressReplyMatchBrief1 =>
      'Vi kjenner målet og vi kommer til å nå det.';

  @override
  String get pressReplyMatchBrief2 =>
      'Forbundet satte et mål. Vi skal levere det.';

  @override
  String get pressReplyPlayDown1 => 'La oss ta det én kamp av gangen.';

  @override
  String get pressReplyPlayDown2 =>
      'Ingen store løfter. Vi får se hvor vi står.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Vi kvalifiserer oss. Du kan skrive det ned.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Dette laget kommer til å være i sluttspillet.';

  @override
  String get pressReplyFearNobody1 => 'Vi frykter ingen.';

  @override
  String get pressReplyFearNobody2 => 'De må spille mot oss også.';

  @override
  String get pressReplyRespectRival1 =>
      'De er favorittene, og vi respekterer dem.';

  @override
  String get pressReplyRespectRival2 =>
      'Et veldig godt lag. Vi trenger vårt beste.';

  @override
  String get pressReplyTeamFirst1 =>
      'Det handler om hele laget, ikke én spiller.';

  @override
  String get pressReplyTeamFirst2 => 'Ingen vinner dette alene.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'For protokollen: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'For protokollen: ingen løfter.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Du satte et mål før kampanjen og du nådde det. Er det ditt stolteste øyeblikk så langt?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Du sa hva du ville oppnå, og du gjorde det. Var det noen gang i tvil?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Du nådde målet du satte. Flaks, eller var det virkelig planen?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Du satte et mål og kom til kort. Hva gikk galt?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Du lovet mer enn dette laget leverte. Angrer du på at du sa det?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Du snakket stort før kampanjen og kom til kort. Hvorfor skal vi tro på deg nå?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Pressen vil høre målene dine for $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Nivå $level · $amount';
  }

  @override
  String get formOnFire => 'I storform';

  @override
  String get formGood => 'I form';

  @override
  String get formSteady => 'Stabil';

  @override
  String get formPoor => 'Ute av form';

  @override
  String get formCold => 'Iskald';

  @override
  String get playerFormTitle => 'FORM OG KONDISJON';

  @override
  String playerFormAverage(String rating) {
    return 'Snitt på $rating i de siste kampene';
  }

  @override
  String get playerFormNoGames => 'Ikke nok nylige kamper til å vurdere';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta på karakteren hans i neste kamp';
  }

  @override
  String get playerFormNoEffect =>
      'Ingen endring i karakteren hans i neste kamp';

  @override
  String playerFormSquadShare(String delta) {
    return 'Inkludert $delta som hele troppen deler (moral, base)';
  }

  @override
  String get sideGroupHome => 'Hjem';

  @override
  String get sideGroupTeam => 'Lag';

  @override
  String get sideGroupCompetitions => 'Konkurranser';

  @override
  String get sideGroupFederation => 'Forbund';

  @override
  String get sideGroupHistory => 'Historikk';

  @override
  String get sideInbox => 'Innboks';

  @override
  String get sideSquad => 'Tropp';

  @override
  String get sideTactics => 'Taktikk';

  @override
  String get sideMainMenu => 'Hovedmeny';

  @override
  String get sideCallUps => 'Uttak';

  @override
  String get sideTournaments => 'Turneringer';

  @override
  String get sideRanking => 'Rangering';

  @override
  String get sideResults => 'Resultater';

  @override
  String get sideFinances => 'Økonomi';

  @override
  String get sideBoard => 'Styre';

  @override
  String get sideManager => 'Trener og stab';

  @override
  String get sideRecords => 'Rekorder';

  @override
  String get sideLegends => 'Legender';

  @override
  String get sideHeadToHead => 'Innbyrdes';

  @override
  String get sideAchievements => 'Prestasjoner';

  @override
  String get sideCareer => 'Karriere';

  @override
  String get topBarNext => 'Neste';

  @override
  String get topBarDrawPending => 'Trekning kommer';

  @override
  String get paneFullProfile => 'Full profil';

  @override
  String get panePickPlayer => 'Velg en spiller for å se kortet hans her';

  @override
  String get inboxPickMessage => 'Velg en melding for å lese den her';

  @override
  String get inboxFilterAll => 'Alle';

  @override
  String get panelViewAll => 'Se alle';

  @override
  String get gridViewOverview => 'Oversikt';

  @override
  String get gridColCondition => 'Kondisjon';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Rangering';

  @override
  String get gridColMove => 'Endring';

  @override
  String get gridColNation => 'Land';

  @override
  String get gridColRegion => 'Region';

  @override
  String get gridColPoints => 'Poeng';

  @override
  String get panePickNation => 'Velg et land for å se rekorden her';

  @override
  String get resultsCyclesTitle => 'Sykluser';

  @override
  String get tourDrawStart => 'Start trekningen';

  @override
  String get tourDrawViewGroups => 'Se grupper';

  @override
  String get gridColCeiling => 'Potensial';

  @override
  String get gridColYearGain => 'Vekst';

  @override
  String get gridColMarkedAt => 'Ved merking';

  @override
  String get budgetSetupTitle => 'Sett opp budsjettet';

  @override
  String get budgetEffectsTitle => 'Hva dette budsjettet gir';

  @override
  String get naturalisationTitle => 'Naturalisering';

  @override
  String get yTrending => 'Trender';

  @override
  String get yVoices => 'Stemmer';

  @override
  String get yConversation => 'Samtale';

  @override
  String get allTimeRecordsTitle => 'Verdensrekorder gjennom alle tider';

  @override
  String get h2hMeetingsTitle => 'Alle oppgjør';

  @override
  String get h2hPickOpponent => 'Velg en motstander for å se alle oppgjør her';

  @override
  String get savesTitle => 'Lagringer';

  @override
  String get gridColPlayer => 'Spiller';

  @override
  String get gridColPos => 'Pos';

  @override
  String get gridColActive => 'Aktiv';

  @override
  String get gridColMotm => 'KS';

  @override
  String get gridColAvg => 'Snitt';

  @override
  String get gridColOpponent => 'Motstander';

  @override
  String get gridColStarts => 'Start';

  @override
  String get gridColTournaments => 'Turneringer';

  @override
  String get gridColDate => 'Dato';

  @override
  String get gridColLastPlayed => 'Sist spilt';

  @override
  String get gridColManager => 'Trener';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count land',
      one: '1 land',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Sortert etter verdensrankingen';

  @override
  String get nationsStrength => 'Styrke';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier av 5';
  }

  @override
  String get nationsSquadOverall => 'Tropp, helhet';

  @override
  String get nationsOpeningBudget => 'Startbudsjett';

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
  String get nationsBoardExpects => 'Styret forventer';

  @override
  String nationsManage(String nation) {
    return 'Led $nation';
  }

  @override
  String get nationsManagerNext => 'Du velger trener neste';

  @override
  String get playerPageTitle => 'Spiller';

  @override
  String get nationPageTitle => 'Land';

  @override
  String get friendliesYourGames => 'Dine treningskamper';

  @override
  String hubEventInjuryCover(String player) {
    return 'Erstatt den skadde spilleren $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Ute $matches kamper',
      one: 'Ute neste kamp',
    );
    return '$_temp0. Ta ut noen, eller spill videre uten ham.';
  }

  @override
  String get injuryCoverTitle => 'ERSTATNING';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) er skadet. Ta ut hvem som helst utenfor troppen, på hvilken som helst posisjon, eller behold ham og spill videre.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Ta ut $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Behold $player og spill videre';
  }

  @override
  String get injuryCoverPick => 'Velg en erstatter';

  @override
  String get injuryCoverNone =>
      'Ingen utenfor troppen er friske nok til å bli med.';

  @override
  String get nationNowRanking => 'Verdensrankingen';

  @override
  String get nationNowForm => 'Form';

  @override
  String get nationNowNoForm => 'Ingen kamper spilt ennå';

  @override
  String get nationNowNext => 'Neste kamp';

  @override
  String get nationNowNoNext => 'Ingenting planlagt';

  @override
  String get nationNowSquad => 'Tropp';

  @override
  String get nationNowAgainstYou => 'Mot deg';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}S ${d}U ${l}T';
  }

  @override
  String get nationNowLastMeeting => 'Siste oppgjør';

  @override
  String nationNowOverall(int value) {
    return 'Helhet $value';
  }

  @override
  String get hubUpcoming => 'KOMMENDE';

  @override
  String get hubFullSchedule => 'Hele kampprogrammet';

  @override
  String get scheduleTitle => 'Kampprogram';

  @override
  String get scheduleToday => 'I dag';

  @override
  String get scheduleKnockoutPending => 'Utslagsrunde, hvis du går videre';

  @override
  String get scheduleNextRoundPending => 'Neste runde';

  @override
  String scheduleFromDate(String date) {
    return 'Fra $date';
  }

  @override
  String get scheduleHomeShort => 'H';

  @override
  String get scheduleAwayShort => 'B';

  @override
  String get tacticsNoPresetsInMatch =>
      'Ingen lagrede taktikker ennå. Lagre en fra Taktikk-skjermen før kampen.';

  @override
  String get homeCampaigns => 'Kampanjer';

  @override
  String get homeContinueCampaign => 'FORTSETT KAMPANJEN';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Syklus $cycle av $total';
  }

  @override
  String get campaignsTitle => 'Kampanjer';

  @override
  String get campaignTransplantTitle => 'Transplantasjonen';

  @override
  String get campaignTransplantTwist =>
      'Åtte av Italias beste bytter landslag til San Marino';

  @override
  String get campaignTransplantGoal => 'Kvalifiser deg til Europamesterskapet';

  @override
  String get campaignGrudgeTitle => 'Nag';

  @override
  String get campaignGrudgeTwist => 'Georgia og Albania, trukket sammen';

  @override
  String get campaignGrudgeGoal => 'Kom foran Albania i kvalifiseringen';

  @override
  String get campaignTransplantIntro =>
      'San Marino har aldri hatt en kvalifiseringskampanje som fortjener navnet. Så tar åtte av Italias beste imot passet og marsjerer inn. Du har én syklus på å gjøre en kuriositet til et lag.';

  @override
  String get campaignGrudgeIntro =>
      'Georgia og Albania er trukket i samme kvalifiseringsgruppe, og ingen av dem tilgir et nederlag. Kom foran Albania, og se så hvor langt du kan ta det.';

  @override
  String get campaignStars1Transplant => 'Kvalifiser deg';

  @override
  String get campaignStars2Transplant => 'Nå utslagsrundene';

  @override
  String get campaignStars3Transplant => 'Vinn Europamesterskapet';

  @override
  String get campaignStars1Grudge => 'Foran Albania';

  @override
  String get campaignStars2Grudge => 'Og kvalifiser deg';

  @override
  String get campaignStars3Grudge => 'Og slå dem to ganger';

  @override
  String get campaignFree => 'Gratis';

  @override
  String get campaignStart => 'Start';

  @override
  String get campaignPartOfUnlimited => 'Del av Unlimited';

  @override
  String get campaignResume => 'Fortsett';

  @override
  String get campaignAbandon => 'Gi opp';

  @override
  String get campaignAbandonConfirm =>
      'Gi opp dette forsøket? Fremgangen går tapt; stempelet ditt beholdes.';

  @override
  String get campaignMoveToSaves => 'Flytt til lagringer';

  @override
  String get campaignCannotContinue =>
      'Verdenen i denne kampanjen er for langt fra den virkelige til at du kan fortsette som karriere.';

  @override
  String get campaignMoveSlotsFull =>
      'Lagringsplassene dine er fulle. Frigjør en først.';

  @override
  String get campaignStampConquered => 'Erobret';

  @override
  String get campaignStampFailed => 'Mislyktes';

  @override
  String get campaignDifficultyHard => 'Vanskelig';

  @override
  String get campaignDifficultyMedium => 'Middels';

  @override
  String get campaignGoalLabel => 'Mål';

  @override
  String get campaignStarsLabel => 'Stjerner';

  @override
  String get campaignRunInProgress =>
      'Denne kampanjen har allerede et forsøk i gang.';

  @override
  String get campaignVerdictWon => 'Erobret';

  @override
  String get campaignVerdictLost => 'Ikke denne gangen';

  @override
  String get campaignVerdictContinue => 'Fortsett';

  @override
  String campaignProgressQualifying(String position) {
    return 'Kvalifisering: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Sluttspill: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Forsøket i tall';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Oppgjør vunnet: $won av $played';
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
  String get campaignGuineasTitle => 'Best av Guineaene';

  @override
  String get campaignGuineasTwist =>
      'Ekvatorial-Guinea, den minste av Afrikas Guineaer, i to sykluser';

  @override
  String get campaignGuineasGoal => 'Slå Guinea og Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Tre afrikanske land bærer navnet Guinea, og Ekvatorial-Guinea er det minste av dem. Du har to sykluser på å slå Guinea og Guinea-Bissau minst én gang hver, og så se hvor langt du kan gå i Afrikamesterskapet. Papua Ny-Guinea, den fjerde Guineaen, er allerede booket til en treningskamp.';

  @override
  String get campaignStars1Guineas => 'Slå Guinea og Guinea-Bissau';

  @override
  String get campaignStars2Guineas =>
      'Og kvalifiser deg til et Afrikamesterskap';

  @override
  String get campaignStars3Guineas =>
      'Og nå kvartfinalen i et Afrikamesterskap';

  @override
  String get campaignYoungFinnsTitle => 'De unge finnene';

  @override
  String get campaignYoungFinnsTwist =>
      'Finlands gylne generasjon tenåringer, i tre sykluser';

  @override
  String get campaignYoungFinnsGoal => 'Kvalifiser deg til et VM';

  @override
  String get campaignYoungFinnsIntro =>
      'Finlands seniorspillere har tatt et skritt til side, og en gylden generasjon har tatt plassen deres: alle spillerne du kan velge er 18 år eller yngre. Foreløpig er de rå, men de har talentet til å bli ett av verdens beste lag, akkurat som Norges unge generasjon ble. Du har tre sykluser på å føre dem til et VM, og deretter vinne Europamesterskapet og Verdensmesterskapet.';

  @override
  String get campaignStars1YoungFinns => 'Kvalifiser deg til et VM';

  @override
  String get campaignStars2YoungFinns => 'Vinn Europamesterskapet';

  @override
  String get campaignStars3YoungFinns => 'Vinn Verdensmesterskapet';

  @override
  String get campaignGreenlandTitle => 'Et grønlandsk århundre';

  @override
  String get campaignGreenlandTwist =>
      'Grønland tar San Marinos plass i Europa, i hundre år';

  @override
  String get campaignGreenlandGoal => 'Kvalifiser deg til et Europamesterskap';

  @override
  String get campaignGreenlandIntro =>
      'Grønland har aldri spilt en tellende landskamp. I denne verdenen har de tatt San Marinos plass i Europa, og de starter helt nederst på verdensrankingen: amatørspillere, kunstgressbaner og en sesong klemt inn mellom snøfallene. Du har hundre år, tjuefem sykluser, på å nå et Europamesterskap, så et Verdensmesterskap og, om du tør å drømme, vinne ett av dem.';

  @override
  String get campaignStars1Greenland =>
      'Kvalifiser deg til et Europamesterskap';

  @override
  String get campaignStars2Greenland => 'Kvalifiser deg til et VM';

  @override
  String get campaignStars3Greenland =>
      'Vinn Europamesterskapet eller Verdensmesterskapet';

  @override
  String get campaignZanzibarTitle => 'Zanzibar reiser seg';

  @override
  String get campaignZanzibarTwist =>
      'Zanzibar tar Tsjads plass i Afrika, i hundre år';

  @override
  String get campaignZanzibarGoal => 'Kvalifiser deg til et Afrikamesterskap';

  @override
  String get campaignZanzibarIntro =>
      'Zanzibar har sitt eget fotballforbund og sitt eget landslag, men ingen plass i afrikansk fotball eller i verdensfotballen. I denne verdenen har de tatt Tsjads plass i Afrika, og de starter nær bunnen av verdensrankingen: øyspillere, små stadioner og monsunens hete. Du har hundre år, tjuefem sykluser, på å nå et Afrikamesterskap, så et Verdensmesterskap og, om du tør å drømme, vinne Verdensmesterskapet.';

  @override
  String get campaignStars1Zanzibar => 'Kvalifiser deg til et Afrikamesterskap';

  @override
  String get campaignStars2Zanzibar => 'Kvalifiser deg til et VM';

  @override
  String get campaignStars3Zanzibar => 'Vinn Verdensmesterskapet';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Kvalifiserte seg ikke';

  @override
  String get campaignCupOpen => 'Avgjøres senere';

  @override
  String campaignWorldRenames(String nation) {
    return 'Denne databasen gir nytt navn til en nasjon kampanjen er bygget rundt: $nation.';
  }

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name glitrer for $level-landslaget';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Akademirapport: $name skiller seg ut';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Best på $level-landslaget: $name';
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
      other: '$count ganger',
      one: 'én gang',
    );
    return '$name fant nettmaskene $_temp0 for $level-landslaget mot $opponent i det siste landskampvinduet.';
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
      one: 'Ett mål',
    );
    return '$_temp0 av $name da $level-landslaget møtte $opponent i dette vinduet.';
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
      one: 'ett mål',
    );
    return '$level-landslaget møtte $opponent, og $name forlot banen med $_temp0 på kontoen.';
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
      one: 'ett mål',
    );
    return '$name la opp til $_temp0 for $level-landslaget mot $opponent og styrte spillet fra start til slutt.';
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
      other: '$count målgivende',
      one: 'én målgivende',
    );
    return '$level-landslaget møtte $opponent i dette vinduet, og det var $name som trakk i trådene: $_temp0 og en innsats som støtteapparatet fortsatt snakker om.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name var strålende da $level-landslaget holdt nullen mot $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Nullen holdt for $level-landslaget mot $opponent, og $name var den største grunnen.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name imponerte for $level-landslaget mot $opponent, og støtteapparatet ga innsatsen hans $mark av ti.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$level-landslaget spilte mot $opponent i dette vinduet, og trenerne trakk fram $name: $mark av ti, lagets høyeste karakter.';
  }

  @override
  String get newsYouthDevReady1 =>
      'I denne formen er han allerede god nok til å bli vurdert for A-landslaget.';

  @override
  String get newsYouthDevReady2 =>
      'Støtteapparatet mener han er klar for seniorfotball allerede nå. Valget er ditt.';

  @override
  String get newsYouthDevClose1 =>
      'Han utvikler seg godt og er nær et gjennombrudd på A-landslaget.';

  @override
  String get newsYouthDevClose2 =>
      'Han er ikke langt unna A-landslaget, og én god sesong til kan holde.';

  @override
  String get newsYouthDevGrowing1 =>
      'Han utvikler seg fint, selv om A-landslaget fortsatt er et steg eller to unna.';

  @override
  String get newsYouthDevGrowing2 =>
      'Det gjenstår arbeid før han blir A-landslagsspiller, men alt peker i riktig retning.';

  @override
  String get newsYouthDevRaw1 =>
      'Han er fortsatt rå og noen år unna A-landslaget, men talentet er tydelig.';

  @override
  String get newsYouthDevRaw2 =>
      'Det er tidlig, og akademiens trenere ber om tålmodighet framfor overskrifter.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Rekkevidden og kontrollen over sekstenmeteren er det som skiller ham ut.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Grepet og utspillet hans er det beste akademiet har sett på mange år.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Konsentrasjonen svikter aldri: han er like skarp i nittiende minutt som i det første.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Farten og hodespillet er nøkkelen til spillet hans.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Han leser spillet langt over alderen sin og er rolig med ballen.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Han kobler aldri ut og spurter fortsatt hjem i siste minutt.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Han vinner ballen med ekte kraft og driver framover med den.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Spilloversikten og pasningsregisteret er nøkkelen til spillet hans.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Motoren hans er enestående: han dekker hvert gresstrå.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Farten i bakrom og styrken i lufta gjør ham til et problem for ethvert forsvar.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Avslutningene og bevegelsene i sekstenmeteren er nøkkelen til spillet hans.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Han presser høyt hele kampen og gir aldri forsvarerne et øyeblikks ro.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Fansen kommer til å synge om kampen mot $opponent lenge. Hva sa du til spillerne ved sluttsignalet?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Det var en markering mot $opponent. Hvor mye av det kom fra treningsfeltet?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Ros for resultatet mot $opponent, men slike kvelder har vi sett før. Hva er annerledes denne gangen?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Alle har en dårlig kveld, og dette var en mot $opponent. Hvor raskt kan du legge den bak deg?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent var bedre i alle lagdeler. Hvor begynner du å reparere?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Supporterne gikk før slutt mot $opponent. Kan du klandre dem?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Det har vært en tung periode, og $opponent gjorde det ikke lettere. Hva holder deg gående?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Nok en kamp uten seier, denne gangen mot $opponent. Hvor lenge kan dette pågå før styret griper inn?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Nå også $opponent. Er det noe igjen i planen din, eller er det på tide å gi plass til noen andre?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Uansett hva dere skriver, skriv det om spillerne. Det har de fortjent.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Jeg har en gruppe som ville gått gjennom ild for hverandre. Det er ikke lite.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Jeg tar avgjørelsene, så kritikken skal til meg. Det er jobben.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Se på landslagssjefen først. Jeg har gjort feil, og jeg skal rette dem opp.';

  @override
  String get pressReplyDemandMore5 =>
      'Bra er ikke bra nok her. Det har jeg sagt til dem rett i ansiktet.';

  @override
  String get pressReplyDemandMore6 =>
      'Ingen i den garderoben har en garantert plass. Det vet de nå.';

  @override
  String get pressReplyDeflect5 =>
      'Dere kan spørre på tre forskjellige måter. Svaret blir det samme.';

  @override
  String get pressReplyDeflect6 =>
      'Tankene mine holder jeg for spillerne. Det forstår dere.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score mot $opponent. Rolig, kontrollert, voksen fotball. Deilig å se.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return 'Slo $opponent $score uten å svette. Laget blir godt på kjedelig, og kjedelig vinner titler.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Tre poeng, null drama, tilbake til jobben.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Rutinemessig $score mot $opponent. Ingen kommer til å huske det, og ingen trenger det.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score mot $opponent, og likevel er jeg bekymret på et vis.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return 'Slo $opponent $score. Mot et ordentlig lag blir den innsatsen straffet.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score mot $opponent. Bet tenna sammen, led, vant. Det er et lag.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return 'Slo $opponent $score på ren vilje. Jeg tar gjerne et lag som nekter å tape.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Det gikk helt til slutt, men poengene er våre.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Knappe $score mot $opponent. Lite som skilte, og sånn er fotball.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score mot $opponent. Én heldig sprett den andre veien, og vi hadde hatt en helt annen samtale.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Hang så vidt med mot $opponent, $score. Ingen bør kalle det en prestasjon.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score mot $opponent. Ikke tap, og noen dager er det akkurat det som er jobben.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Et hardt tilkjempet poeng mot $opponent, $score. Jeg likte kampviljen.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Rettferdig poengdeling, som de gamle kommentatorene pleide å si.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score mot $opponent. Ingen av lagene gjorde nok til å fortjene mer.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score mot $opponent. Den typen uavgjort som føles som et tap på bussen hjem.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Uavgjort $score mot $opponent. Vi snakker hele tiden om framgang og gjør hele tiden dette.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score mot $opponent. Det svir, men jeg så nok til å tro på dette laget.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Tapte $score mot $opponent, og de var gode. Anerkjenn det og kjør på igjen.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Et tap, noen lærdommer og neste kamp snart.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Tap $score mot $opponent. Vanskelig å si imot.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score mot $opponent. De samme feilene som sist, gjort med den samme selvsikkerheten.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Tapte $score mot $opponent. Hvis ingen må svare for det, hva holder vi på med?';
  }

  @override
  String get yReactionShrug12 =>
      'Greit for meg. Ikke hver kveld trenger fyrverkeri.';

  @override
  String get yReactionShrug13 => 'Poeng er poeng. Sover godt i natt.';

  @override
  String get yReactionShrug14 => 'Sett. Ingen kommentarer.';

  @override
  String get yReactionShrug15 => 'Et sted mellom greit og greit.';

  @override
  String get yReactionShrug16 =>
      'Betalte for strømmen for dette. Aldri igjen (jeg kommer tilbake).';

  @override
  String get yReactionShrug17 => 'Nitti minutter med fotballformet ingenting.';

  @override
  String get yReactionRelief12 => 'Puster igjen. Stolt av at de holdt ut.';

  @override
  String get yReactionRelief13 =>
      'Det er slike seire som bygger et lag. Stygt er vakkert.';

  @override
  String get yReactionRelief14 => 'Neglene er borte, men ikke poengene.';

  @override
  String get yReactionRelief15 => 'Et sluttsignal har aldri hørtes så bra ut.';

  @override
  String get yReactionRelief16 => 'Glad for at vi vant, bekymret for hvordan.';

  @override
  String get yReactionRelief17 =>
      'Vi slipper unna gang på gang. En dag gjør vi ikke det.';

  @override
  String get yReactionFury12 =>
      'Jeg elsker dette laget, og det er nettopp derfor det gjør vondt.';

  @override
  String get yReactionFury13 =>
      'Dårlig kveld. Neste gang skylder de oss en, og det vet de.';

  @override
  String get yReactionFury14 =>
      'Skrudde av etter sytti minutter. Burde vært seksti.';

  @override
  String get yReactionFury15 =>
      'Ingen kamp, ingen ideer, ingen unnskyldninger.';

  @override
  String get yReactionFury16 =>
      'De samme problemene hver gang, og ingen fikser noe.';

  @override
  String get yReactionFury17 =>
      'Noen i forbundet må se dette om igjen og forklare det.';

  @override
  String get backupShareHint =>
      'Lager én sikkerhetskopi av alle lagrede spill. Velg Google Disk, iCloud Drive eller Filer for å ta vare på den.';

  @override
  String backupLastAt(String date) {
    return 'Siste sikkerhetskopi: $date';
  }

  @override
  String get backupNever => 'Ingen sikkerhetskopi ennå';

  @override
  String get backupRemindersTitle => 'Påminnelser om sikkerhetskopi';

  @override
  String get backupRemindersBlurb =>
      'En melding i innboksen når den siste sikkerhetskopien begynner å bli gammel.';

  @override
  String get backupAutoICloudTitle => 'Automatisk sikkerhetskopi til iCloud';

  @override
  String get backupAutoDriveTitle =>
      'Automatisk sikkerhetskopi til Google Disk';

  @override
  String get backupAutoBlurb =>
      'Tar kopi etter kamper, på slutten av en syklus og når du forlater appen. Beholder de to siste.';

  @override
  String get backupStatusUploading => 'Tar sikkerhetskopi nå.';

  @override
  String get backupStatusUploaded => 'Sikkerhetskopiert.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud er av. Logg på iCloud og slå på iCloud Drive i Innstillinger-appen.';

  @override
  String get backupStatusDriveSignedOut =>
      'Ikke pålogget. Slå på bryteren for å logge på med Google.';

  @override
  String get backupStatusNotConfigured =>
      'Ikke tilgjengelig i denne versjonen av appen ennå.';

  @override
  String get backupStatusUnavailable =>
      'Skyen kan ikke nås akkurat nå. Det prøves igjen senere.';

  @override
  String get backupStatusFailed =>
      'Den siste automatiske sikkerhetskopien gikk ikke gjennom. Det prøves igjen senere.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Pålogget som $email';
  }

  @override
  String get backupDriveSignOut => 'LOGG UT';

  @override
  String get backupDriveSignInFailed =>
      'Pålogging med Google fungerte ikke. Prøv igjen senere.';

  @override
  String get backupRestoreICloud => 'GJENOPPRETT FRA ICLOUD';

  @override
  String get backupRestoreDrive => 'GJENOPPRETT FRA GOOGLE DISK';

  @override
  String get backupCrossPlatformHelp =>
      'Bytter du mellom iPhone og Android? Ta sikkerhetskopi til en fil på den ene telefonen, og gjenopprett fra den filen på den andre.';

  @override
  String get backupCloudListBlurb =>
      'Sikkerhetskopier fra enhetene dine på denne kontoen. Trykk på en for å gjenopprette den.';

  @override
  String get backupCloudListEmpty =>
      'Ingen sikkerhetskopier funnet ennå. En ny kan bruke noen minutter på å nå en annen enhet.';

  @override
  String get backupCloudListFailed =>
      'Kunne ikke lese sikkerhetskopiene. Sjekk tilkoblingen og prøv igjen.';

  @override
  String get backupCloudThisDevice => 'Denne enheten';

  @override
  String backupCloudMore(int count) {
    return 'Flere lagrede spill: $count';
  }

  @override
  String get backupCloudNewer =>
      'Laget med en nyere versjon av appen. Oppdater først.';

  @override
  String get backupCloudDownloading => 'Henter sikkerhetskopien.';

  @override
  String get backupRestoreSafetyNote =>
      'Først tas det vare på en kopi av telefonens lagrede spill på denne telefonen.';

  @override
  String get backupRejectedSafety =>
      'Kunne ikke ta vare på en kopi av de nåværende lagrede spillene, så ingenting ble erstattet.';

  @override
  String get newsBackupReminderTitle => 'Tid for sikkerhetskopi';

  @override
  String get newsBackupReminderBody =>
      'De lagrede spillene dine finnes bare på denne telefonen. Åpne Innstillinger og trykk på Sikkerhetskopier til skyen, eller slå på automatisk sikkerhetskopi der. Disse påminnelsene kan også slås av i Innstillinger.';

  @override
  String get backupSafetyTitle => 'Kopier fra før en gjenoppretting';

  @override
  String get backupSafetyBlurb =>
      'Tas vare på på denne telefonen i tilfelle en gjenoppretting var feil. De tre nyeste beholdes.';

  @override
  String get backupSafetyRestore => 'GJENOPPRETT';

  @override
  String get backupSafetyShare => 'DEL';

  @override
  String get saveUpgradeFailedTitle =>
      'Det lagrede spillet kunne ikke oppdateres';

  @override
  String get saveUpgradeFailedBody =>
      'Det lagrede spillet ditt kunne ikke oppdateres. Ingenting er slettet, og en kopi fra før oppdateringen er tatt vare på på denne telefonen.';

  @override
  String get saveUpgradeRestoreButton =>
      'Gjenopprett kopien fra før oppdateringen';

  @override
  String get saveUpgradeRestoreFailed =>
      'Kopien kunne ikke gjenopprettes. Det lagrede spillet ble latt være som det var.';

  @override
  String get saveOpenFailedTitle => 'De lagrede spillene kunne ikke åpnes';

  @override
  String get saveOpenFailedBody =>
      'De lagrede spillene dine kunne ikke åpnes. Ingenting er slettet. Prøv igjen om litt.';

  @override
  String get backupCloudNoDetails => 'Detaljene er fortsatt på vei.';

  @override
  String get tacticsLibraryTitle => 'TAKTIKKBIBLIOTEK';

  @override
  String get tacticsLibraryBlurb =>
      'Taktikker i biblioteket ditt kan lastes inn i hvilken som helst lagring, også nye. Roller og dødballskyttere lagres etter posisjon, ikke etter spiller.';

  @override
  String get tacticsSaveToLibrary => 'Lagre i biblioteket';

  @override
  String get tacticsLoadFromLibrary => 'Last inn fra biblioteket';

  @override
  String get tacticsLibraryEmpty =>
      'Biblioteket ditt er tomt. Lagre en taktikk her, så kan du laste den inn i alle lagringer.';

  @override
  String tacticsLibrarySaved(String name) {
    return 'Lagret «$name» i biblioteket';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Lastet inn «$name»';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count roller eller dødballskyttere passet ikke i denne troppen.',
      one: '1 rolle eller dødballskytter passet ikke i denne troppen.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Gi nytt navn';

  @override
  String get tacticsLibraryRenameTitle => 'Gi taktikken nytt navn';

  @override
  String get tacticsLibraryDelete => 'Slett';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Slette «$name»?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Den forsvinner fra biblioteket i alle lagringene dine.';

  @override
  String get tacticsLibraryNameTaken =>
      'Biblioteket ditt har allerede en taktikk med det navnet.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Kunne ikke laste inn biblioteket.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Søknad om vertskap: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Vertskapssøknad';

  @override
  String get hostBidBlurb =>
      'Vertslandet trekkes blant kandidatene. En søknad gir navnet ditt større tyngde: stadionene dine gir en startsjanse, og penger øker den, selv om hver ekstra million teller litt mindre. Pengene er brukt enten du vinner eller ikke.';

  @override
  String hostBidPrize(String amount) {
    return 'Vinner du, blir du vert, kvalifiserer deg automatisk og får et engangstilskudd på $amount til neste budsjett.';
  }

  @override
  String get hostBidChance => 'Sjanse for vertskap';

  @override
  String get hostBidBaseLabel => 'Stadioner og posisjon';

  @override
  String get hostBidInvestLabel => 'Investering';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Tak for $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Din investering';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Frie midler: $amount';
  }

  @override
  String get hostBidSubmit => 'Send inn søknad';

  @override
  String get hostBidDecline => 'Ikke denne gangen';

  @override
  String get hostBidUnavailable => 'Denne søknaden er ikke lenger åpen.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Søknaden vant: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Vi blir vert for turneringen og er som vert automatisk kvalifisert. Et engangstilskudd på $amount ligger nå i forbundets kasse, og du kan fordele det på denne syklusens avdelinger rett fra hovedskjermen.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Søknaden tapte: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Vertskapet gikk til: $hosts. Søknaden vår holdt ikke denne gangen, og pengene vi brukte er borte, men forbundet gjorde sitt.';
  }

  @override
  String get hostBidGrantEvent => 'Fordel vertskapstilskuddet';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Vertskapstilskudd: $amount som du kan legge til denne syklusens avdelinger nå. Det du allerede har fordelt blir stående, og det som er igjen blir i kassen.';
  }

  @override
  String get stadiumsTitle => 'Nasjonalarenaer';

  @override
  String get stadiumsEntrySub => 'Bygg ut et stadion eller bygg et nytt';

  @override
  String get stadiumsBlurb =>
      'En arenas nivå er størrelsen: nivå 1 under 15 000 plasser, nivå 2 fra 15 000, nivå 3 fra 25 000, nivå 4 fra 40 000, nivå 5 fra 60 000. Hver arena gir en liten inntekt ved starten av hver syklus, mer jo flere plasser, så lenge publikum fyller dem. En utbygging gir flere plasser med en gang og litt omdømme fra neste syklus; en nedbygging kutter vedlikeholdet, men gir ingenting tilbake. Arenaene dine avgjør hvilke turneringer du kan søke vertskap for.';

  @override
  String stadiumsIncome(String amount) {
    return 'Stadioninntekter: $amount per syklus';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Omdømme fra stadioner: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Arbeider bestilles ved starten av en syklus, før budsjettet er satt.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Kapasitet: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Nivå $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Bygg ut: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Høyeste nivå';

  @override
  String stadiumsOpens(int year) {
    return 'Under bygging, åpner i $year';
  }

  @override
  String get stadiumsBuildTitle => 'Bygg et nytt stadion';

  @override
  String get stadiumsBuildBody =>
      'Ganske dyrt: et nytt stadion i byen du velger, åpent fra starten av neste syklus.';

  @override
  String get stadiumsBuildCity => 'By';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Bygg: $cost';
  }

  @override
  String get stadiumsBuilding => 'Et stadion er allerede under bygging.';

  @override
  String get stadiumsNoCity => 'Hver by har allerede et nytt stadion.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Bygge ut $stadium til nivå $level for $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Bygge et nytt stadion i $city for $cost?';
  }

  @override
  String get stadiumsConfirm => 'Bekreft';

  @override
  String get stadiumsCancel => 'Avbryt';

  @override
  String get stadiumsRefused =>
      'Bestillingen gikk ikke gjennom. Ingenting ble trukket.';

  @override
  String get stadiumsNameLabel => 'Stadionnavn';

  @override
  String get stadiumsNameHint =>
      'La feltet stå tomt for å beholde det foreslåtte navnet.';

  @override
  String get stadiumsRename => 'Gi stadion nytt navn';

  @override
  String get hostBidSectionTitle => 'Søknader om vertskap';

  @override
  String get hostBidOpenSub =>
      'Valgfritt. Bestem deg før den nye syklusen begynner.';

  @override
  String get hostBidDecidedAtRollover =>
      'Vertslandet kunngjøres når den nye syklusen begynner.';

  @override
  String get hostBidLodged =>
      'Søknad levert. Vertslandet kunngjøres når den nye syklusen begynner.';

  @override
  String get hostBidDeclinedNote => 'Du valgte å ikke søke denne gangen.';

  @override
  String get hostBidOpensLater =>
      'Kvalifisert. Du kan søke på slutten av denne syklusen.';

  @override
  String get hostBidNoFunds => 'Ikke nok frie midler til å søke.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du trenger $count arenaer til med $seats+ plasser.',
      one: 'Du trenger 1 arena til med $seats+ plasser.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation var vert for det siste Verdensmesterskapet.';
  }

  @override
  String get hostBidRecentHost =>
      'Du var vert for en av de tre siste utgavene.';

  @override
  String get hostBidBelowBar =>
      'Stadionene dine oppfyller ikke kravene til denne turneringen.';

  @override
  String get hostBidRulesPending =>
      'Om du kan søke, blir klart når vertene for denne syklusen er kunngjort.';

  @override
  String get hostBidBackToBack =>
      'Du er vert for turneringen rett før denne. Ingen nasjon er vert for to turneringer på rad.';

  @override
  String get hostBidOneOnly =>
      'Du har allerede søkt om den andre turneringen. Ingen nasjon er vert for to turneringer på rad, så du kan bare søke om én.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Krav: $grounds arenaer med $minSeats+ plasser, $bigGrounds av dem med $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Vi blir vertskap for turneringen og er automatisk kvalifisert som vertsland. En engangsstøtte på $amount er allerede i forbundets midler, klar for budsjettet denne syklusen.';
  }

  @override
  String get hubStadiumIncome => 'Arenainntekter';

  @override
  String get stadiumsDownsize => 'Bygg ned';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Bygge ned $stadium til $seats plasser (nivå $level)? Ingenting refunderes, men vedlikeholdet går ned.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Bygd om denne syklusen';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Gir $amount per syklus';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Søknad trukket: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Søknaden gjaldt $nation, men du starter den nye syklusen et annet sted. Den er trukket, og ingenting er belastet.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'Da syklusen ble avsluttet, dekket ikke forbundets midler lenger innsatsen. Søknaden er trukket, og ingenting er belastet.';

  @override
  String get stadiumsViewMap => 'Kart';

  @override
  String get stadiumsViewList => 'Liste';

  @override
  String get stadiumsMapPickCity =>
      'Trykk på en by for å bygge et nytt stadion der.';

  @override
  String get stadiumsMapFit => 'Vis hele landet';

  @override
  String get campaignLegacyTitle => 'Fullfør arven';

  @override
  String get campaignLegacyTwist =>
      'Spania, regjerende europamester, i én syklus';

  @override
  String get campaignLegacyGoal => 'Forsvar EM-tittelen';

  @override
  String get campaignLegacyIntro =>
      'Spania er regjerende europamester, og tvilerne kaller gullperioden en engangsforeteelse. Du har én syklus på deg til å bevise det motsatte: forsvar kontinentets krone, og gå så for verden. Legg til Nations Cup, så er arven fullført.';

  @override
  String get campaignStars1Legacy => 'Vinn Europamesterskapet';

  @override
  String get campaignStars2Legacy => 'Og Verdensmesterskapet';

  @override
  String get campaignStars3Legacy => 'Og Nations Cup';

  @override
  String get campaignSectionOneCycle => 'Én syklus';

  @override
  String get campaignSectionShort => 'Noen sykluser';

  @override
  String get campaignSectionLong => 'Det lange løpet';

  @override
  String get campaignFilterAll => 'Alle';

  @override
  String get campaignFilterNew => 'Ikke spilt';

  @override
  String get campaignFilterInProgress => 'Pågår';

  @override
  String get campaignFilterDone => 'Fullført';

  @override
  String get campaignFilterEmpty => 'Her er det ingen kampanjer ennå.';

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
      other: '$cycles sykluser',
      one: '1 syklus',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Han gir seg på topp, som mester.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Å gå glipp av sluttspillet ble dråpen.';

  @override
  String get msgIntlRetireNoteSurprise => ' Ingen så det komme.';

  @override
  String get msgIntlRetireNoteRecord =>
      ' Han går som landslagets rekordholder.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name legger opp på landslaget';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) har kunngjort at han legger opp på landslaget, $age år gammel.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name gjør comeback på landslaget';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name er tilgjengelig for uttak igjen, $age år gammel.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Med troppen herjet av skader har han svart på kallet.';

  @override
  String get msgIntlComebackNoteManager =>
      ' Den nye landslagssjefen fikk ham til å snu.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name gjør comeback på landslaget';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) er tilgjengelig for uttak igjen, $age år gammel.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'La opp på landslaget, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Comeback på landslaget, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Takk, $name. Noen bærer drakta, han bar laget.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name avslutter landslagskarrieren. En æra er over.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name gir seg. Én turnering for sent, for å være ærlig.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Så $name er ferdig. På tide å slippe til de unge.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Høyde $altitudeString moh.: motstanderen blir fortere sliten';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Høyde $altitudeString moh.: spillerne dine blir fortere slitne';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Høyde $altitudeString moh.: begge lag blir fortere slitne';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Høyde $altitudeString moh.: begge lag er vant til det';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Varme: $tempString °C ventet, kreftene tar slutt tidligere';
  }

  @override
  String get matchConditionsAdvice =>
      'Planlegg byttene tidlig: friske bein teller mer her';

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
    return 'Hjemmefansen: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Supporterne: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Stadioninntekter neste syklus: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Tjue år etter landslaget, hjemme og borte. Jeg fornyer ikke sesongkortet før noe endrer seg.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Vi fortsetter å synge for drakta. Men banneret på nordtribunen sa i kveld det vi alle tenker.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Halve stadion tomt, og den andre halvdelen brukte andre omgang på å synge #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Supporterklubbene snakker om å boikotte neste hjemmekamp. Vanskelig å klandre dem.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Ikke engang sint lenger. Bare ferdig.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Bilde fra i kveld: rader med tomme seter og ett laken med #${manager}Out. Det er kamprapporten.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Utsolgt igjen. Det beste landslaget på mange år, og hele landet vet det.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Neste hjemmekamp ble utsolgt på elleve minutter. Dette laget har gitt oss helgene tilbake.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Ikke ett ledig sete til neste hjemmekamp. Forbundet teller billettinntektene med et smil.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Utsolgt igjen. Si hva dere vil om taktikken, folk vil være på det stadionet.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Utsolgt, greit. De samme folkene buet på dette laget for halvannet år siden.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Plutselig utsolgt, plutselig eksperter alle sammen. Hvor var alle da vi ikke klarte å slå noen?';
  }

  @override
  String get campaignsIntro =>
      'Kampanjer er håndlagde utfordringer: en bestemt nasjon, en verden med sin egen vri og et mål som skal nås innen et fast antall sykluser. Hvert forsøk holdes atskilt fra de lagrede karrierene dine, og jo lenger du kommer, desto flere stjerner får du, opptil tre.';

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
    return '$player var på en fest som varte til daggry, og bildene sto i alle avisene samme morgen som troppen samlet seg.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player brøt portforbudet og ble tatt da han kom tilbake til hotellet midt på natten.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player ble fotografert på en nattklubb kvelden før samlingen, og bildene er overalt.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player tilbrakte natten før samlingen ved et kasinobord, og en løssalgsavis har bildene.';
  }

  @override
  String get scandalSendHome => 'Send ham hjem';

  @override
  String scandalSendHomeCover(String player) {
    return 'Send hjem, kall inn $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Behold $player';
  }

  @override
  String get scandalKeepNote =>
      'Behold ham: moral omtrent -4 og styret omtrent -3 resten av syklusen.';

  @override
  String get scandalSendHomeNote =>
      'Send ham hjem: ingen kostnad for moral eller styret, og du kan kalle inn en erstatter.';

  @override
  String get scandalFinalsNote =>
      'Send ham hjem: ingen kostnad for moral eller styret, men i et sluttspill kan ingen erstatte ham.';

  @override
  String get scandalPickCover => 'Kall inn en erstatter (valgfritt)';

  @override
  String newsScandalTitle(String player) {
    return 'Skandale på samlingen: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Gutter er gutter. $player på fest kvelden før samlingen, og jeg vil fortsatt ha ham på banen. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player fotografert på en fest som varte hele natten, timer før troppen samlet seg. Forbundet er orientert. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Fest hele natten før samlingen. $player, hva tenkte du på? Utrolig. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Tilbake etter portforbudet, ok, det skjer. $player må bare gjøre det godt igjen på banen. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player tatt på vei tilbake til lagets hotell etter portforbudet, timer før treningen. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Portforbud er ikke vanskelig. $player klarte ikke én eneste natt. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Så $player var på klubb. Fotballspillere har et liv de også. La ham spille. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Bilder viser $player på en nattklubb kvelden før landslagssamlingen. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Klubbilder kvelden før samlingen. $player har brakt skam over drakta. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'En natt på kasinoet er ingen forbrytelse. Det går fint med $player. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player sett ved et kasinobord natten før troppen samlet seg. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Hele natten på kasinoet før samlingen. $player spilte bort mer enn penger. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Riktig avgjørelse. Ingen er større enn laget, heller ikke $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Å sende $player hjem var det eneste svaret. Respekt til landslagssjefen.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Disiplin er disiplin. $player kjente reglene.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Et tydelig signal til troppen: $player sitter på flyet hjem.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Hardt for $player. Én kveld ute, og samlingen er over?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Å sende $player hjem svekker oss. Det får vi betale for på banen.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Å beholde $player er et sjansespill. Han får betale det tilbake på banen.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Greit, $player blir. Da skylder han alle en storkamp.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Så reglene gjelder ikke for $player. Godt å vite.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Portforbudet er visst frivillig nå. Spør $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Beholde $player etter det der? Denne troppen er en ferieleir.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Fest hele natten og så rett inn i startelleveren. Flott signal, trener. $player er sikkert strålende fornøyd.';
  }

  @override
  String get yStreamerBreaks0 =>
      'BROREN BLE TATT 😭😭 NATTA FØR SAMLINGEN?? JEG GRÅTER 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'NEIII CHAT SE PÅ DETTE 🤯🤯 BROREN GJORDE DET FAKTISK FØR SAMLINGEN 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'HVEM SLAPP HAM UT?? HVEM SLAPP HAM UT 😭😭💀 DETTE ER KINO 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'HJEM?? HJEM!!! 😭😭😭 TRENEREN TULLER IKKE 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'BROREN PAKKER KOFFERTENE LIVE 🤯🤯 HADET BROR 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'ALDRIIII DE SENDTE HAM HJEM 💀💀 CHAT JEG SKJELVER 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'HAN BLIR??? HAN BLIRRR 🤯🤯 BROREN ER URØRLIG 😭🔥';

  @override
  String get yStreamerKept1 =>
      'FEST HELE NATTA OG FORTSATT I TROPPEN 💀💀 JEG VIL HA DEN KONTRAKTEN 😭😭';

  @override
  String get yStreamerKept2 =>
      'TRENEREN SIER DET ER GREIT 😭😭 BROR HVA 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'Jeg har ikke betalt noe, og det beløpet stemmer heller ikke';

  @override
  String get yCameoHavir0 => 'De små fiskene har svømt sin vei.';

  @override
  String get yCameoHavir1 => 'Vi kastet ut garnet, fisken var et annet sted.';

  @override
  String get yCameoHavir2 => 'Jeg sa det allerede i september, over en gulasj.';

  @override
  String get yCameoHavir3 => 'Den som ikke fisket i tide, skal ikke gråte nå.';

  @override
  String get yCameoHavir4 => 'Vi spilte som en malle på tørt land.';

  @override
  String get yCameoHavir5 => 'Vinden blåser, dammen fryser. Sånn er det bare.';

  @override
  String get yCameoHavir6 => 'Noen dager drar man bare opp en gammel støvel.';

  @override
  String get yCameoHavir7 =>
      'På min tid gikk man i det minste ut på en øl. Nå ikke engang det.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Sende en gutt hjem for én kveld? Det er skandalen, ikke festen!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Guttene må da få ha det litt gøy! De hyklerske mediene vinner igjen.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Dette er en heksejakt. En ung gutt går ut én kveld, og dere henger ham.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Den journalisten som aldri har vært på fest, får kaste den første steinen. Skammelig!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Landslagssjefen ble redd for løssalgspressen. Jeg ville forsvart gutten til mitt siste åndedrag!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Endelig en landslagssjef med ryggrad! Han beholdt gutten, og mediene kan gråte.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Guttene må da få ha det litt gøy, ikke sant? Bravo, trener!';

  @override
  String get yCameoLzimberskyKept2 =>
      'De hyklerske mediene skriker, landslagssjefen står fast. Sånn gjør man det!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Én kveld ute, og pressen vil steine ham. Landslagssjefen er en ekte kar!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Jeg sier: la guttene leve! Den som jobber hardt, får også feste. Tommel opp.';

  @override
  String get yCameoMarena => 'Dette kunne til og med jeg trent.';

  @override
  String get yCameoKralik =>
      'Hva hadde du ventet deg hehehe, kjøp vår ZeroZero';

  @override
  String get yCameoPosuk0 => 'SVAKT';

  @override
  String get yCameoPosuk1 => 'HERREGUDD';

  @override
  String get yCameoPosuk2 => 'Noen som blir med på puben?';

  @override
  String get yTraitStreamer =>
      'Strømmer alt, på full guffe, med store bokstaver.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Årets spiller $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Stemmene er telt';

  @override
  String get potyCeremonyWatch => 'Se utdelingen';

  @override
  String get potyCeremonySkipToList => 'Hopp til topp 5';

  @override
  String get potyCeremonySkip => 'Hopp over';

  @override
  String get potyCeremonyIntro =>
      'Stemmene er telt. Dette er årets fem beste spillere i verden.';

  @override
  String potyCeremonyPlace(int place) {
    return 'Plass $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'Og årets spiller er...';

  @override
  String get potyTop5Heading => 'Verdens topp 5';

  @override
  String get potyYoungTop3Heading => 'Årets unge spiller: topp 3';

  @override
  String get potySeeTop5 => 'Se topp 5';

  @override
  String get potyYourPlayer => 'Din spiller';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count holdt null',
      one: '1 holdt null',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Full orientering';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Stjerner så langt: $earned av $total';
  }

  @override
  String get campaignStarEarned => 'Tatt så langt';

  @override
  String get campaignStarNotYet => 'Ikke tatt ennå';

  @override
  String get stadiumsEntrySubClosed =>
      'Se stadionene dine. Arbeider kan bestilles igjen i starten av neste syklus.';

  @override
  String get boardObjectiveNoBrief => 'Ikke noe mål satt';

  @override
  String get boardObjectiveNoBriefBody =>
      'Styret venter ikke at dere når dette sluttspillet. Det vurderer deg heller ut fra resultatene.';

  @override
  String get boardObjectiveAwaitingDraw => 'Mål etter trekningen';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Styret setter dette målet når gruppene er trukket.';

  @override
  String tourThirdsNextAdvance(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'De neste $count går videre til $destination',
      one: 'Det neste laget går videre til $destination',
    );
    return '$_temp0';
  }

  @override
  String yWinEuphoric0(String opponent, String score) {
    return 'For en kveld. Ikke engang i våre villeste drømmer hadde vi sett for oss dette. $score mot $opponent!';
  }

  @override
  String yWinEuphoric1(String opponent, String score) {
    return '$score mot $opponent. Klyp meg. Kan noen være så snill å klype meg?';
  }

  @override
  String yWinEuphoric2(String opponent, String score) {
    return 'Jeg gråter på tribunen. $score mot $opponent. Jeg elsker dette laget.';
  }

  @override
  String yWinEuphoric3(String opponent, String score) {
    return '$score mot $opponent. Den beste kvelden i mitt supporterliv, med god margin.';
  }

  @override
  String yWinEuphoric4(String opponent, String score) {
    return '$score mot $opponent. Et av de største resultatene i landets historie.';
  }

  @override
  String yWinEuphoric5(String opponent, String score) {
    return '$score mot $opponent. Ingen i hele verden så dette komme. Historisk.';
  }

  @override
  String yWinEuphoric6(String opponent, String score) {
    return '$score mot $opponent. Dette kommer folk til å snakke om i tiår.';
  }

  @override
  String yWinEuphoric7(String opponent, String score) {
    return 'Husk hvor dere var i kveld: $score mot $opponent.';
  }

  @override
  String yWinEuphoric8(String opponent, String score) {
    return 'Jeg har klaget hele året og klager igjen i morgen. Men i kveld? $score mot $opponent. Utrolig.';
  }

  @override
  String yWinEuphoric9(String opponent, String score) {
    return 'Selv jeg finner ingenting å klage på. $score mot $opponent. Uvirkelig.';
  }

  @override
  String yWinEuphoric10(String opponent, String score) {
    return '$score mot $opponent. Jeg sa at laget var ferdig. Har aldri vært gladere for å ta feil.';
  }

  @override
  String yWinEuphoric11(String opponent, String score) {
    return 'Greit, jeg innrømmer det: $score mot $opponent er som en drøm. Neste uke er det vel som vanlig igjen.';
  }

  @override
  String yDrewGiant0(String opponent, String score) {
    return '$score mot $opponent. Ett ord: utrolig!';
  }

  @override
  String yDrewGiant1(String opponent, String score) {
    return 'Ett poeng mot et av verdens beste lag. Det tar vi alle dager. $score mot $opponent.';
  }

  @override
  String yDrewGiant2(String opponent, String score) {
    return '$score mot $opponent! Stemmen er borte, og jeg bryr meg ikke.';
  }

  @override
  String yDrewGiant3(String opponent, String score) {
    return '$score mot $opponent. Uavgjort? Det føles som vi vant alt.';
  }

  @override
  String yDrewGiant4(String opponent, String score) {
    return 'Et poeng mot et lag som $opponent var ikke ventet, men det tar vi gjerne. $score, et sterkt resultat.';
  }

  @override
  String yDrewGiant5(String opponent, String score) {
    return '$score mot $opponent. Et poeng folk vil huske i årevis.';
  }

  @override
  String yDrewGiant6(String opponent, String score) {
    return '$opponent kom som storfavoritt og reiser hjem med $score. En stolt kveld.';
  }

  @override
  String yDrewGiant7(String opponent, String score) {
    return '$score mot $opponent. Nesten ingen lag på vårt nivå tar poeng mot dem.';
  }

  @override
  String yDrewGiant8(String opponent, String score) {
    return 'Jeg ventet juling. $score mot $opponent. Jeg spiser gjerne i meg ordene mine.';
  }

  @override
  String yDrewGiant9(String opponent, String score) {
    return 'Jeg liker ikke uavgjort, men $score mot $opponent? Det tar jeg med et smil.';
  }

  @override
  String yDrewGiant10(String opponent, String score) {
    return '$score mot $opponent. I kveld jubler til og med dommedagsprofetene, meg inkludert.';
  }

  @override
  String yDrewGiant11(String opponent, String score) {
    return 'Vi forsvarte oss for livet og tok $score mot $opponent. Stygt? Hvem bryr seg. Strålende.';
  }

  @override
  String get potyHistorySubtitle =>
      'Alle vinnerne og hvem som har vunnet flest ganger';

  @override
  String get potyHistoryEmpty =>
      'Ingen Årets spiller er kåret ennå. Den første avstemningen er 1. desember.';

  @override
  String get potyHistoryLatest => 'Siste vinner';

  @override
  String get potyHistoryMostWins => 'Flest seire';

  @override
  String potyHistoryWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seire',
      one: '1 seier',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryByYear => 'Vinnere per år';

  @override
  String get potyHistoryByNation => 'Per nasjon';

  @override
  String potyHistoryYourNation(String winners, String finishes) {
    return 'Din nasjon: $winners, $finishes';
  }

  @override
  String potyHistoryWinners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vinnere',
      one: '1 vinner',
    );
    return '$_temp0';
  }

  @override
  String potyHistoryTopFive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count topp 5-plasseringer',
      one: '1 topp 5-plassering',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryYourPlayers => 'Dine spillere';

  @override
  String get potyHistoryNoYourPlayers =>
      'Ingen av spillerne dine har endt blant de fem beste ennå.';

  @override
  String get potyHistoryYoung => 'Ung spiller';

  @override
  String get potyHistoryUnknownPlayer => 'Ukjent spiller';

  @override
  String get hostingTitle => 'Vertskap';

  @override
  String get hostingThisCycle => 'Denne syklusen';

  @override
  String get hostingNextCycle => 'Din søknad for neste syklus';

  @override
  String get hostingTba => 'Kunngjøres senere';

  @override
  String get hostingTbaWc => 'Kunngjøres når kontinentalmesterskapet er over';

  @override
  String hostingBidPledged(String amount, String percent) {
    return 'Søknad levert: $amount, med $percent sjanse for vertskap.';
  }

  @override
  String get hostingWindowLine =>
      'Søknader åpner på slutten av syklusen, etter finalen i Verdensmesterskapet.';

  @override
  String hubEventWarmUpOffer(String nation) {
    return 'Tilbud om treningskamp: $nation';
  }

  @override
  String get hubEventWarmUpOfferSub => 'En avskjedskamp før turneringen deres';

  @override
  String get warmUpOfferTitle => 'TILBUD OM TRENINGSKAMP';

  @override
  String warmUpOfferBody(String nation, String competition, String date) {
    return '$nation forbereder seg til turneringen $competition og vil spille en avskjedskamp mot deg $date.';
  }

  @override
  String warmUpOfferAway(String nation) {
    return 'Borte, hos motstanderen ($nation).';
  }

  @override
  String get warmUpOfferHome => 'Hjemme: motstanderen kommer til deg.';

  @override
  String get warmUpOfferNote =>
      'Du kan takke ja til høyst to tilbud. En akseptert kamp får sitt eget uttak.';

  @override
  String get warmUpOfferAccept => 'Takk ja';

  @override
  String get warmUpOfferDecline => 'Takk nei';

  @override
  String warmUpOfferMsgTitle(String nation) {
    return 'Tilbud om treningskamp: $nation';
  }

  @override
  String warmUpOfferMsgBody(String nation, String competition) {
    return '$nation vil spille en avskjedskamp mot deg før turneringen $competition.';
  }

  @override
  String get hubSimToFinal => 'Simuler til finalen';

  @override
  String get jobDossierOpen => 'Vurder jobben';

  @override
  String get jobDossierRating => 'Lagstyrke';

  @override
  String get jobDossierMood => 'Stemning';

  @override
  String get jobDossierTopPlayers => 'Beste spillere';

  @override
  String jobDossierPlayerAge(int age) {
    return '$age år';
  }

  @override
  String get jobDossierReport => 'Speiderens vurdering';

  @override
  String get jobDossierNextTargetLabel => 'Neste mål';

  @override
  String jobDossierNextTarget(String cup) {
    return 'Kvalifiser for $cup og Verdensmesterskapet.';
  }

  @override
  String get jobDossierStrongAttack => 'Ekte brodd fremover.';

  @override
  String get jobDossierBluntAttack => 'Målene kommer tungt.';

  @override
  String get jobDossierStrongMidfield => 'Midtbanen styrer kampene.';

  @override
  String get jobDossierWeakMidfield => 'De blir ofte overkjørt på midten.';

  @override
  String get jobDossierStrongDefence => 'Vanskelige å bryte ned bakover.';

  @override
  String get jobDossierThinDefence => 'Forsvaret ser tynt ut.';

  @override
  String get jobDossierSafeKeeper => 'En keeper å stole på.';

  @override
  String get jobDossierShakyKeeper => 'Keeperplassen bekymrer.';

  @override
  String get jobDossierOldSquad => 'En aldrende tropp, en ny start nærmer seg.';

  @override
  String get jobDossierYoungCore => 'En ung kjerne på vei opp.';

  @override
  String jobDossierOneStar(String name) {
    return '$name bærer dette laget.';
  }

  @override
  String get jobDossierDeepSquad => 'Ekte bredde bak startelleveren.';

  @override
  String get jobDossierThinSquad => 'Lite kvalitet bak startelleveren.';

  @override
  String get jobDossierBalanced => 'Et balansert lag uten åpenbar svakhet.';

  @override
  String yQualifiedEuphoric0(String competition) {
    return 'Kan ikke tro at vi klarte det! Nesten ingen trodde på dette. $competition, her kommer vi 💪';
  }

  @override
  String yQualifiedEuphoric1(String competition) {
    return 'For en magisk kveld, vi er i drømmeland! $competition, her kommer vi!';
  }

  @override
  String yQualifiedEuphoric2(String competition) {
    return 'Jeg har alltid trodd på dette laget. Alltid. Og nå skal vi til $competition!';
  }

  @override
  String yQualifiedEuphoric3(String competition) {
    return 'Ingen ga oss en sjanse i den gruppa. Ingen. Vi ses i $competition!';
  }

  @override
  String yQualifiedEuphoric4(String competition) {
    return 'Tårer i øynene. Vi, i $competition. Faktisk oss.';
  }

  @override
  String yQualifiedEuphoric5(String competition) {
    return 'Jeg danser i gata akkurat nå. Kvalifisert til $competition! Uvirkelig 🎉';
  }

  @override
  String yQualifiedEuphoric6(String competition) {
    return 'Jeg sa at vi ikke hadde sjanse. Aldri vært så glad for å ta feil. $competition!';
  }

  @override
  String yQualifiedEuphoric7(String competition) {
    return 'Jeg har klaget på dette laget i årevis og begynner igjen i morgen. I kveld? $competition, her kommer vi!';
  }

  @override
  String yQualifiedEuphoric8(String competition) {
    return 'Greit. GREIT. Jeg tar alt tilbake. Vi skal til $competition!';
  }

  @override
  String yKnockoutEuphoric0(String opponent) {
    return 'Videre! $opponent slått. For en magisk kveld, vi er i drømmeland!';
  }

  @override
  String yKnockoutEuphoric1(String opponent) {
    return 'Vi slo ut $opponent! Fortsett å drømme, alle sammen 💪';
  }

  @override
  String yKnockoutEuphoric2(String opponent) {
    return 'Jeg visste at laget hadde det i seg. Ha det, $opponent, hei neste runde!';
  }

  @override
  String yKnockoutEuphoric3(String opponent) {
    return 'Stemmen er borte. $opponent er ute, og vi marsjerer videre!';
  }

  @override
  String yKnockoutEuphoric4(String opponent) {
    return 'Utslagskamper, og vi står fortsatt. $opponent fikk lære det på den harde måten.';
  }

  @override
  String yKnockoutEuphoric5(String opponent) {
    return '$opponent må reise hjem. Dette laget skriver historie 🔥';
  }

  @override
  String yKnockoutEuphoric6(String opponent) {
    return 'Jeg trodde vi skulle være hjemme nå. I stedet reiser $opponent hjem. Utrolig.';
  }

  @override
  String yKnockoutEuphoric7(String opponent) {
    return 'Selv jeg drømmer nå. $opponent slått. Hvem er vi?';
  }

  @override
  String yKnockoutEuphoric8(String opponent) {
    return 'Pessimist hele livet. $opponent ute, vi videre. Vet ikke hva jeg skal gjøre med meg selv.';
  }

  @override
  String yTrophyEuphoric0(String competition) {
    return 'MESTRE!!! Vi vant $competition! Denne kvelden glemmer jeg aldri 🏆';
  }

  @override
  String yTrophyEuphoric1(String competition) {
    return 'For en magisk kveld. Vinnere av $competition, og jeg klarer ikke å slutte å gråte.';
  }

  @override
  String yTrophyEuphoric2(String competition) {
    return 'Jeg har alltid sagt at laget kunne. Vinnere av $competition. VINNERE!';
  }

  @override
  String yTrophyEuphoric3(String competition) {
    return 'Noen må si at dette er ekte. Vi vant $competition!';
  }

  @override
  String yTrophyEuphoric4(String competition) {
    return 'Fest i hver gate i landet i natt. $competition er vårt 🏆';
  }

  @override
  String yTrophyEuphoric5(String competition) {
    return 'Husk hvor dere var i kveld. Vinnere av $competition.';
  }

  @override
  String yTrophyEuphoric6(String competition) {
    return 'Hver dårlige kveld, hver skuffelse, det var verdt det. Vinnere av $competition.';
  }

  @override
  String yTrophyEuphoric7(String competition) {
    return 'Jeg har klaget i årevis, og nå har jeg ingenting igjen å klage på. Vi vant $competition!';
  }

  @override
  String yTrophyEuphoric8(String competition) {
    return 'Greit, jeg innrømmer det: vinnere av $competition. Mitt livs beste kveld.';
  }

  @override
  String yExitHeartbreak0(String competition) {
    return 'Knust hjerte. Vi dro til $competition for å gå hele veien. Fortsatt stolt av laget.';
  }

  @override
  String yExitHeartbreak1(String competition) {
    return 'Det gjør så vondt. I $competition skulle vi langt. Vi kommer igjen.';
  }

  @override
  String yExitHeartbreak2(String competition) {
    return 'Knust. Allerede ute av $competition, og vi hadde laget til å vinne.';
  }

  @override
  String yExitHeartbreak3(String competition) {
    return 'Flyturen hjem fra $competition blir den lengste i livene våre.';
  }

  @override
  String yExitHeartbreak4(String competition) {
    return 'Vi skulle langt i $competition. I stedet drar vi hjem. Ingen ord.';
  }

  @override
  String yExitHeartbreak5(String competition) {
    return 'År med venting, og $competition er over for oss før det startet. Tomt.';
  }

  @override
  String punditsMsgTitle(String competition) {
    return 'Ekspertene om $competition';
  }

  @override
  String punditsSays(String pundit, String words) {
    return '$pundit: $words';
  }

  @override
  String punditsFavourite0(String nation) {
    return 'Min favoritt: $nation. For sterke og for brede for resten.';
  }

  @override
  String punditsFavourite1(String nation) {
    return 'Vanskelig å se forbi $nation. Alt som trengs for å vinne er der.';
  }

  @override
  String punditsDarkHorse0(String nation) {
    return 'Ekte mørk hest her: $nation. En semifinale ville ikke sjokkert meg.';
  }

  @override
  String punditsDarkHorse1(String nation) {
    return 'Følg med på $nation. Ingen vil trekke dem.';
  }

  @override
  String punditsMineBottom0(String nation) {
    return '$nation: sist i gruppa. Godt gjort å komme hit, men kvaliteten holder ikke til å gå videre.';
  }

  @override
  String punditsMineBottom1(String nation) {
    return '$nation kommer til å nyte turen, men jeg ser dem sist i gruppa.';
  }

  @override
  String punditsMineGroupOut0(String nation) {
    return '$nation: ute i gruppespillet. Ubehagelige å møte, men et nivå under.';
  }

  @override
  String punditsMineGroupOut1(String nation) {
    return 'Jeg tror $nation reiser hjem etter gruppa. Men de skal gjøre det vanskelig for noen.';
  }

  @override
  String punditsMineFirstKnockout0(String nation) {
    return '$nation: videre fra gruppa, så ute i første utslagsrunde. En grei turnering.';
  }

  @override
  String punditsMineFirstKnockout1(String nation) {
    return '$nation bør komme seg ut av gruppa. Mer enn det ville vært en overraskelse.';
  }

  @override
  String punditsMineQuarters0(String nation) {
    return '$nation: et solid lag. Kvartfinale virker helt riktig.';
  }

  @override
  String punditsMineQuarters1(String nation) {
    return '$nation kan nå kvartfinalen. Det ville vært en god turnering.';
  }

  @override
  String punditsMineSemis0(String nation) {
    return '$nation: klasse, en lang reise ventes. Minst semifinale.';
  }

  @override
  String punditsMineSemis1(String nation) {
    return '$nation har kvaliteten for de fire siste. Mindre ville vært en skuffelse.';
  }

  @override
  String punditsMineFinal0(String nation) {
    return '$nation: klasse, en lang reise ventes. Jeg ser dem i finalen.';
  }

  @override
  String punditsMineFinal1(String nation) {
    return '$nation hele veien til finalen. Så gode er de.';
  }

  @override
  String punditsMineWinner0(String nation) {
    return '$nation: laget å slå. Alt annet enn tittelen er et nederlag.';
  }

  @override
  String punditsMineWinner1(String nation) {
    return 'Mitt tips til vinner: $nation. Alt presset ligger nå på dem.';
  }

  @override
  String punditsMineDarkHorseQuarters(String nation) {
    return 'Ekte mørk hest her: $nation. En kvartfinale ville ikke sjokkert meg.';
  }

  @override
  String punditsMineDarkHorseSemis(String nation) {
    return 'Ekte mørk hest her: $nation. En semifinale ville ikke sjokkert meg.';
  }

  @override
  String yPunditPick0(String competition, String favourite, String darkHorse) {
    return 'Mitt tips for $competition: $favourite vinner. Mørk hest? $darkHorse. For en turnering det blir.';
  }

  @override
  String yPunditPick1(String competition, String favourite, String darkHorse) {
    return '$favourite i $competition, og følg med på $darkHorse. Dette kan bli spesielt.';
  }

  @override
  String yPunditPick2(String competition, String favourite, String darkHorse) {
    return 'Tips for $competition. Vinner: $favourite. Mørk hest: $darkHorse.';
  }

  @override
  String yPunditPick3(String competition, String favourite, String darkHorse) {
    return 'Vanskelig å se forbi $favourite i $competition. $darkHorse kan overraske mange.';
  }

  @override
  String yPunditPick4(String competition, String favourite, String darkHorse) {
    return 'Alle vil si $favourite i $competition. Dessverre har de rett. Bare $darkHorse er verdt å se på.';
  }

  @override
  String yPunditPick5(String competition, String favourite, String darkHorse) {
    return '$favourite vinner $competition, og det blir kjedelig. Vil dere ha en historie, se på $darkHorse.';
  }

  @override
  String tacticsSlotSwitchHeading(String formation) {
    return 'Posisjon i $formation';
  }

  @override
  String get tacticsSlotSwitchReset => 'Tilbakestill';

  @override
  String get tacticsSlotSwitchLimit =>
      'To posisjoner er allerede endret i denne formasjonen. Tilbakestill en for å endre denne.';

  @override
  String get assistantAsk => 'Spør assistenten';

  @override
  String get assistantNoneNote =>
      'Ingen assistenttrener ansatt. Ansett en i staben for å få rådene hans.';

  @override
  String get assistantSheetTitle => 'Assistentens råd';

  @override
  String get assistantReadBasic =>
      'En grov vurdering. Sjekk den før du stoler på den.';

  @override
  String get assistantReadGood =>
      'En solid vurdering av styrke, posisjoner og slitasje.';

  @override
  String get assistantReadElite =>
      'Leser kondisjon, form, moral og motstanderne.';

  @override
  String get assistantVariantMain => 'Hans valg';

  @override
  String get assistantVariantFresh => 'Friskere bein';

  @override
  String get assistantVariantForm => 'Spillere i form';

  @override
  String get assistantVsStronger => 'Motstanderne er sterkere';

  @override
  String get assistantVsWeaker => 'Dere er sterkest';

  @override
  String get assistantReasonInForm => 'I form';

  @override
  String get assistantReasonFresh => 'Uthvilt';

  @override
  String get assistantReasonTired => 'Sliten';

  @override
  String get assistantReasonInjured => 'Skadet';

  @override
  String get assistantApply => 'Bruk';

  @override
  String get assistantClose => 'Lukk';

  @override
  String get assistantReasonTopPick => 'Førstevalg';

  @override
  String get assistantReasonLineCover => 'Dekning';

  @override
  String get assistantReasonYoung => 'Ungt talent';

  @override
  String get assistantReasonExperienced => 'Erfaren';

  @override
  String get assistantReasonBanned => 'Utestengt';

  @override
  String get assistantReasonOutOfForm => 'Ute av form';

  @override
  String get assistantReasonOthersAhead => 'Andre er foran';

  @override
  String get assistantVariantYouth => 'Gi de unge sjansen';

  @override
  String get assistantVariantExperience => 'Erfaring';

  @override
  String get assistantVsSelection => 'Mot ditt nåværende valg';

  @override
  String get assistantVsLastSquad => 'Mot forrige tropp';

  @override
  String get assistantSameSquad => 'Ingen endringer i valget ditt';

  @override
  String assistantNamesIn(int count) {
    return 'Inn: $count';
  }

  @override
  String assistantNamesOut(int count) {
    return 'Ut: $count';
  }

  @override
  String assistantVariantTacticsChange(String formation) {
    return 'Ved bytte til $formation';
  }

  @override
  String assistantReasonBackup(String position) {
    return 'Reserve for $position';
  }

  @override
  String assistantReasonCoversTwo(String first, String second) {
    return 'Dekker $first og $second';
  }

  @override
  String assistantReasonCoversThree(String first, String second, String third) {
    return 'Dekker $first, $second og $third';
  }

  @override
  String assistantReasonForChange(String formation, String position) {
    return 'Til $formation: $position';
  }

  @override
  String get staffEffectAdviceBasic => 'Gir råd om uttaket, tar av og til feil';

  @override
  String get staffEffectAdviceGood =>
      'Gir råd om uttaket, følger med på kondisjonen';

  @override
  String get staffEffectAdviceElite =>
      'Gir råd om uttaket ut fra kondisjon, form og motstandere';

  @override
  String get staffHiringAdvice => 'og råd om uttaket';

  @override
  String get hubEventSponsor => 'Velg syklusens sponsor';

  @override
  String get hubEventSponsorSub =>
      'Tre merkevarer vil ha navnet sitt på drakten. Hver avtale har sin pris.';

  @override
  String get sponsorTitle => 'Hovedsponsor';

  @override
  String get sponsorIntroCycle =>
      'Én gang hver syklus står merkevarer i kø for å bli forbundets hovedsponsor. Hver avtale gir noe og koster noe: styret, garderoben eller begge deler. Signer én, eller ingen. Avtalen og virkningen på styret og moralen varer syklusen ut.';

  @override
  String get sponsorEffectBoard => 'Styre';

  @override
  String get sponsorEffectMorale => 'Moral';

  @override
  String get sponsorEffectPress => 'Mediehån';

  @override
  String sponsorPerkMarketing(String amount, String department) {
    return 'Betaler $amount til $department denne syklusen';
  }

  @override
  String sponsorPerkMarketingNote(String amount) {
    return '$amount mer tilbake ved syklusens slutt, i tillegg til din egen investering';
  }

  @override
  String get sponsorRiskyLabel => 'Risikabelt';

  @override
  String get sponsorRiskyWarning => 'Pressen kommer til å kose seg med denne.';

  @override
  String get sponsorSign => 'Signer';

  @override
  String get sponsorDeclineCycle => 'Ingen sponsor denne syklusen';

  @override
  String get sponsorNoneCycle => 'Ingen hovedsponsor denne syklusen';

  @override
  String get sponsorUntilCycleEnd => 'Til slutten av syklusen';

  @override
  String sponsorRolloverLine(String brand) {
    return 'Hovedsponsor: $brand';
  }

  @override
  String get sponsorBrandAgrofart => 'Agrofis';

  @override
  String get sponsorIndustryAgrofart => 'Landbruk og kjemi';

  @override
  String get sponsorFlavourAgrofart =>
      'Brødfør nasjonen. Eier også potetgullet, avisene og de fleste grisene.';

  @override
  String get sponsorBrandBetBadger => 'BetBadger';

  @override
  String get sponsorIndustryBetBadger => 'Spillselskap';

  @override
  String get sponsorFlavourBetBadger =>
      'Odds på alt, også på din egen sparken.';

  @override
  String get sponsorBrandCoinGoblin => 'CoinGoblin';

  @override
  String get sponsorIndustryCoinGoblin => 'Kryptobørs';

  @override
  String get sponsorFlavourCoinGoblin =>
      'Opp fire tusen prosent denne uka. Ikke spør om uttak.';

  @override
  String get sponsorBrandEasyPeasy => 'Kjapplån';

  @override
  String get sponsorIndustryEasyPeasy => 'Smålån';

  @override
  String get sponsorFlavourEasyPeasy =>
      'Penger på ti minutter. Renter i ti år.';

  @override
  String get sponsorBrandVaporia => 'Vaporia';

  @override
  String get sponsorIndustryVaporia => 'Vapebutikker';

  @override
  String get sponsorFlavourVaporia =>
      'Førti smaker av sky, ingen av dem bra for en spiss.';

  @override
  String get sponsorBrandGoldenFleece => 'Det Gylne Skinn Holding';

  @override
  String get sponsorIndustryGoldenFleece => 'Offshoreselskap';

  @override
  String get sponsorFlavourGoldenFleece =>
      'Ingen vet hva de driver med. Advokatene deres liker det sånn.';

  @override
  String get sponsorBrandMiners => 'Gruvearbeiderne';

  @override
  String get sponsorIndustryMiners => 'Gruvedrift';

  @override
  String get sponsorFlavourMiners => 'Kull, kobber og et svært støvete styre.';

  @override
  String get sponsorBrandDragonfly => 'Øyenstikker';

  @override
  String get sponsorIndustryDragonfly => 'Bensinstasjoner';

  @override
  String get sponsorFlavourDragonfly =>
      'Bensin, pølser og en vaskehall som aldri har virket.';

  @override
  String get sponsorBrandSludgeco => 'Søleolje';

  @override
  String get sponsorIndustrySludgeco => 'Olje';

  @override
  String get sponsorFlavourSludgeco => 'Borer hull der ingen har bedt om det.';

  @override
  String get sponsorBrandSkyloom => 'Skyloom';

  @override
  String get sponsorIndustrySkyloom => 'Lavprisfly';

  @override
  String get sponsorFlavourSkyloom =>
      'Fly hvor som helst for ni euro. Sete, bagasje og oksygen kommer i tillegg.';

  @override
  String get sponsorBrandArvella => 'Arvella Motors';

  @override
  String get sponsorIndustryArvella => 'Bilprodusent';

  @override
  String get sponsorFlavourArvella =>
      'Luksus-SUV-er på størrelse med en liten leilighet.';

  @override
  String get sponsorBrandCheapoMax => 'BilligMax';

  @override
  String get sponsorIndustryCheapoMax => 'Lavpriskjede';

  @override
  String get sponsorFlavourCheapoMax => 'Alt til halv pris, også de ansatte.';

  @override
  String get sponsorBrandBrickhaven => 'Brickhaven';

  @override
  String get sponsorIndustryBrickhaven => 'Bygg og anlegg';

  @override
  String get sponsorFlavourBrickhaven => 'Bygger stadioner i tide. Av og til.';

  @override
  String get sponsorBrandHappyBurgers => 'Glade Burgere';

  @override
  String get sponsorIndustryHappyBurgers => 'Hurtigmat';

  @override
  String get sponsorFlavourHappyBurgers =>
      'Trippel ost, dobbel bacon, gratis for hele troppen.';

  @override
  String get sponsorBrandOldSwamp => 'Gammelmyr';

  @override
  String get sponsorIndustryOldSwamp => 'Bryggeri';

  @override
  String get sponsorFlavourOldSwamp =>
      'Brygget i en kjeller ingen noen gang har vasket.';

  @override
  String get sponsorBrandBuzzhorn => 'Buzzhorn';

  @override
  String get sponsorIndustryBuzzhorn => 'Energidrikker';

  @override
  String get sponsorFlavourBuzzhorn => 'Nok koffein til å vekke en keeper.';

  @override
  String get sponsorBrandSteamy => 'Dampbadstua';

  @override
  String get sponsorIndustrySteamy => 'Badstukjede';

  @override
  String get sponsorFlavourSteamy =>
      'Svett sammen. Håndkle valgfritt, lagånd påkrevd.';

  @override
  String get sponsorBrandPixelRage => 'PixelRage Games';

  @override
  String get sponsorIndustryPixelRage => 'Dataspill';

  @override
  String get sponsorFlavourPixelRage =>
      'Troppens favorittskytespill, nå med deres egne ansikter.';

  @override
  String get sponsorBrandGlitterbox => 'Glitterbox Records';

  @override
  String get sponsorIndustryGlitterbox => 'Plateselskap';

  @override
  String get sponsorFlavourGlitterbox =>
      'Hver målfeiring kommer nå med en danserutine.';

  @override
  String get sponsorBrandMilkwell => 'Milkwell Meieri';

  @override
  String get sponsorIndustryMilkwell => 'Meieri';

  @override
  String get sponsorFlavourMilkwell =>
      'Iskald melk og skoleturer for å hilse på kuene.';

  @override
  String get sponsorBrandHerringKing => 'Sildekongen';

  @override
  String get sponsorIndustryHerringKing => 'Sild';

  @override
  String get sponsorFlavourHerringKing =>
      'Syltet, røkt eller på glass siden bestefars tid.';

  @override
  String get sponsorBrandUmbrello => 'Umbrello Forsikring';

  @override
  String get sponsorIndustryUmbrello => 'Forsikring';

  @override
  String get sponsorFlavourUmbrello =>
      'Forsikrer alt, til og med paraplyens paraply.';

  @override
  String get sponsorBrandTidyTeeth => 'Blanke Tenner';

  @override
  String get sponsorIndustryTidyTeeth => 'Tannkrem';

  @override
  String get sponsorFlavourTidyTeeth =>
      'Ni av ti tannleger. Den tiende er på ferie.';

  @override
  String get sponsorBrandWoollySocks => 'Ullsokken';

  @override
  String get sponsorIndustryWoollySocks => 'Strikkevarer';

  @override
  String get sponsorFlavourWoollySocks =>
      'Håndstrikkede sokker til hver spiller, i alle farger unntatt lagets.';

  @override
  String get sponsorBrandStackabloc => 'Stackabloc';

  @override
  String get sponsorIndustryStackabloc => 'Leker';

  @override
  String get sponsorFlavourStackabloc =>
      'Bygg ditt eget nasjonalstadion. Fire tusen biter, én mangler.';

  @override
  String get sponsorBrandPolarPenguin => 'Polarpingvinen';

  @override
  String get sponsorIndustryPolarPenguin => 'Iskrem';

  @override
  String get sponsorFlavourPolarPenguin => 'Tretti smaker, alle smelter.';

  @override
  String get sponsorBrandBoltworth => 'Boltworth';

  @override
  String get sponsorIndustryBoltworth => 'Maskinindustri';

  @override
  String get sponsorFlavourBoltworth =>
      'En bolt for hvert problem. Ingeniørene deres leter fortsatt etter mutteren.';

  @override
  String get sponsorBrandVelocell => 'Velocell';

  @override
  String get sponsorIndustryVelocell => 'Telekom';

  @override
  String get sponsorFlavourVelocell =>
      'Full dekning overalt, bortsett fra inne på stadion.';

  @override
  String get sponsorBrandParcelion => 'Parcelion';

  @override
  String get sponsorIndustryParcelion => 'Pakkelevering';

  @override
  String get sponsorFlavourParcelion =>
      'Levert i morgen. Eller i overmorgen. Eller til naboen.';

  @override
  String get sponsorBrandGridwell => 'Gridwell Energy';

  @override
  String get sponsorIndustryGridwell => 'Energi';

  @override
  String get sponsorFlavourGridwell => 'Holder flomlyset på. Stort sett.';

  @override
  String get sponsorBrandCrownstone => 'Crownstone Bank';

  @override
  String get sponsorIndustryCrownstone => 'Bank';

  @override
  String get sponsorFlavourCrownstone =>
      'Pengene dine er trygge hos oss. Sannsynligvis.';

  @override
  String get sponsorBrandClickbait => 'Klikkagn Media';

  @override
  String get sponsorIndustryClickbait => 'Mediekonsern';

  @override
  String get sponsorFlavourClickbait =>
      'Du vil ikke tro hva vår fjerde overskrift sier.';

  @override
  String get sponsorDealLineRisky =>
      'Store penger og ingen spørsmål. Styret kommer til å ha mange.';

  @override
  String get sponsorDealLineBigPayer =>
      'En raus sjekk fra et navn styret helst ikke vil sette på trykk.';

  @override
  String get sponsorDealLineCrowdPleaser =>
      'Et morsomt merke som spillerne elsker og styret synes er i overkant.';

  @override
  String get sponsorDealLineFamilyFriendly =>
      'Et skikkelig navn som styret elsker og spillerne gjesper av.';

  @override
  String get sponsorDealLineMarketing =>
      'Ingen penger, bare kampanjer: plakater, fotoshoots og mye smil.';

  @override
  String ySponsorDubious0(String brand) {
    return '$brand er forbundets nye hovedsponsor. Le dere, akademiet trenger pengene uansett.';
  }

  @override
  String ySponsorDubious1(String brand) {
    return 'Forbundet har signert $brand som ny hovedsponsor. Det skal ha vært det høyeste budet på bordet.';
  }

  @override
  String ySponsorDubious2(String brand) {
    return '$brand. Vår nye hovedsponsor er $brand. Jeg må legge meg ned.';
  }

  @override
  String ySponsorMocked0(String brand) {
    return 'Penger er penger. Betaler $brand nye baner, bærer jeg drakta med stolthet.';
  }

  @override
  String ySponsorMocked1(String brand) {
    return 'Si hva dere vil om $brand, sjekken gikk gjennom.';
  }

  @override
  String ySponsorMocked2(String brand) {
    return 'Et sted sitter et markedsføringsteam som er veldig stolt av den $brand-logoen på brystet vårt.';
  }

  @override
  String ySponsorMocked3(String brand) {
    return 'Så vi er $brand-landslaget nå. Notert.';
  }

  @override
  String ySponsorMocked4(String brand) {
    return 'Tenk å selge drakta til $brand. Bare tenk.';
  }

  @override
  String ySponsorMocked5(String brand) {
    return 'Av alle sponsorer i verden valgte vi $brand. Hver eneste rival ler av oss.';
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
  String get matchTinySouthAmerica => 'SA-cup';

  @override
  String get matchTinyNorthAmerica => 'NA-cup';

  @override
  String get matchTinyAfrica => 'AfM';

  @override
  String get matchTinyAsia => 'AsM';

  @override
  String get matchTinyOceania => 'OC';

  @override
  String get matchTinyNationsCup => 'NC';

  @override
  String get matchTinyFriendly => 'trening';

  @override
  String get matchTinyClash => 'Clash';

  @override
  String get matchTinyPlayoff => 'playoff';

  @override
  String matchTinyMatchday(int matchday) {
    return '$matchday. runde';
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
  String get matchTinyThirdPlace => 'bronse';

  @override
  String get callUpHomeShort => 'H';

  @override
  String get callUpAwayShort => 'B';

  @override
  String get homeEditor => 'Editor';

  @override
  String get homeNewGameBlurb => 'Velg nasjonen din og start en karriere';

  @override
  String homeCampaignCycleOnly(int cycle, int total) {
    return 'Syklus $cycle av $total';
  }

  @override
  String get editorTitle => 'Editor';

  @override
  String get editorIntro =>
      'Lag din egen startverden: dine spillere, vurderingene deres, dine navn. Del den som en fil; venner kan importere den og starte en karriere i den.';

  @override
  String get editorEmptyTitle => 'Ingen databaser ennå';

  @override
  String get editorEmptyBody =>
      'En ny database starter som en kopi av standardverdenen. Endre det du vil; den lagres underveis.';

  @override
  String get editorNew => 'Ny database';

  @override
  String get editorImport => 'Importer';

  @override
  String get editorEdit => 'Rediger';

  @override
  String get editorRename => 'Gi nytt navn';

  @override
  String get editorDuplicate => 'Dupliser';

  @override
  String get editorExport => 'Eksporter';

  @override
  String get editorDelete => 'Slett';

  @override
  String get editorCancel => 'Avbryt';

  @override
  String get editorCreate => 'Opprett';

  @override
  String get editorMore => 'Flere handlinger';

  @override
  String get editorNameLabel => 'Navn';

  @override
  String get editorNameHint => 'Min verden';

  @override
  String get editorRenameTitle => 'Gi databasen nytt navn';

  @override
  String get editorDuplicateTitle => 'Dupliser database';

  @override
  String editorCopyName(String name) {
    return '$name kopi';
  }

  @override
  String get editorNameEmpty => 'Gi den et navn';

  @override
  String editorNameTooLong(int max) {
    return 'Maks $max tegn';
  }

  @override
  String get editorNameBadCharacters => 'Navnet har tegn som ikke kan brukes';

  @override
  String get editorDeleteTitle => 'Slette databasen?';

  @override
  String editorDeleteBody(String name) {
    return '«$name» fjernes fra denne enheten. Karrierer som allerede er startet i den, fortsetter å fungere.';
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
  String get editorStatusAttention => 'Trenger tilsyn';

  @override
  String get editorStatusUnreadable => 'Kan ikke åpnes';

  @override
  String editorEdited(String date) {
    return 'Endret $date';
  }

  @override
  String get editorCreating => 'Kopierer standardverdenen…';

  @override
  String get editorImported => 'Databasen er importert';

  @override
  String get editorImportOpen => 'Åpne';

  @override
  String get editorImportTooBig => 'Filen er for stor til å være en database.';

  @override
  String get editorImportNotAPack => 'Filen er ikke en FNM-database.';

  @override
  String get editorImportNewer =>
      'Databasen ble laget i en nyere versjon av spillet. Oppdater spillet for å importere den.';

  @override
  String get editorImportBadData =>
      'Databasen inneholder data spillet ikke kan bruke, så ingenting ble importert.';

  @override
  String get editorImportBadTrophy =>
      'Et pokalbilde i filen kunne ikke leses, så ingenting ble importert.';

  @override
  String get editorExportFailed => 'Databasen kunne ikke eksporteres.';

  @override
  String editorExportTooBig(String size, String limit) {
    return 'Databasen er for stor til å deles: filen ville blitt $size MB, og grensen er $limit MB. Lås færre pooler eller fjern noen pokalbilder, og prøv igjen.';
  }

  @override
  String editorRemoveAllLike(int count) {
    return 'Fjern alle like ($count)';
  }

  @override
  String get editorNotesTitle => 'Andre språk';

  @override
  String editorUnknownLanguageNote(String language, int count) {
    return 'Navn på «$language», et språk denne versjonen ikke viser: $count. De beholdes for versjoner som kan språket.';
  }

  @override
  String get editorShareSubject => 'FNM-database';

  @override
  String get editorPackMissing =>
      'Denne databasen finnes ikke lenger på enheten.';

  @override
  String get editorReadyTitle => 'Klar til å spille';

  @override
  String get editorReadyBody =>
      'Alle landslag har full tropp, og alle navn er i orden. Du kan starte en karriere i den.';

  @override
  String editorNotReadyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ting må fikses før den kan spilles',
      one: '1 ting må fikses før den kan spilles',
    );
    return '$_temp0';
  }

  @override
  String get editorNotReadyBody =>
      'Den lagres underveis, så du kan dele den nå og gjøre den ferdig senere.';

  @override
  String editorSectionsReady(int ready, int total) {
    return '$ready av $total deler klare';
  }

  @override
  String get editorMissingTitle => 'Dette mangler';

  @override
  String editorShowAll(int count) {
    return 'Vis alle ($count)';
  }

  @override
  String get editorShowLess => 'Vis færre';

  @override
  String get editorUndo => 'Angre';

  @override
  String get editorSectionsTitle => 'Deler';

  @override
  String get editorSectionPlayers => 'Spillere';

  @override
  String get editorSectionNations => 'Landslag';

  @override
  String get editorSectionClubs => 'Klubber';

  @override
  String get editorSectionStadiums => 'Stadioner';

  @override
  String get editorSectionCompetitions => 'Konkurranser';

  @override
  String get editorSectionY => 'Y-kontoer';

  @override
  String get editorSectionPress => 'Presse';

  @override
  String get editorSectionNameLists => 'Navnelister';

  @override
  String get editorSectionSponsors => 'Sponsorer';

  @override
  String get editorSectionTrophies => 'Pokaler';

  @override
  String get editorAboutPlayers => 'Tropper, vurderinger og potensial';

  @override
  String get editorAboutNations => 'Landsnavn og koder';

  @override
  String get editorAboutClubs => 'Klubbnavn';

  @override
  String get editorAboutStadiums => 'Navn på nasjonalstadioner';

  @override
  String get editorAboutCompetitions => 'Konkurransenavn';

  @override
  String get editorAboutY => 'Kontoer på Y';

  @override
  String get editorAboutPress => 'Journalister og mediene deres';

  @override
  String get editorAboutNameLists =>
      'Navn til nye spillere, lokale fans og støtteapparat';

  @override
  String get editorAboutSponsors => 'Sponsormerker';

  @override
  String get editorAboutTrophies => 'Pokalbilder';

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
      other: '$count landslag',
      one: '1 landslag',
    );
    return '$_temp0';
  }

  @override
  String editorCountChanged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count endringer',
      one: '1 endring',
      zero: 'Spillets navn',
    );
    return '$_temp0';
  }

  @override
  String editorCountTrophies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count egne bilder',
      one: '1 eget bilde',
      zero: 'Spillets bilder',
    );
    return '$_temp0';
  }

  @override
  String editorCountToFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count å fikse',
      one: '1 å fikse',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spillere til trengs',
      one: '1 spiller til trengs',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersOver(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spillere for mye',
      one: '1 spiller for mye',
    );
    return '$_temp0';
  }

  @override
  String editorIssueGoalkeepers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count keepere trengs',
      one: '1 keeper trengs',
    );
    return '$_temp0';
  }

  @override
  String editorIssueDefenders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count forsvarere trengs',
      one: '1 forsvarer trengs',
    );
    return '$_temp0';
  }

  @override
  String editorIssueMidfielders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count midtbanespillere trengs',
      one: '1 midtbanespiller trengs',
    );
    return '$_temp0';
  }

  @override
  String editorIssueForwards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spisser trengs',
      one: '1 spiss trengs',
    );
    return '$_temp0';
  }

  @override
  String get editorIssuePlayerNoName => 'En spiller mangler navn';

  @override
  String editorIssueAge(String name) {
    return '$name: alderen må være 15 til 45';
  }

  @override
  String editorIssueRating(String name) {
    return '$name: helhetsvurderingen må være 1 til 99';
  }

  @override
  String editorIssuePotential(String name) {
    return '$name: potensialet må være mellom helhetsvurderingen og 99';
  }

  @override
  String editorIssueRenameEmpty(String name) {
    return 'Det nye navnet på $name er tomt';
  }

  @override
  String get editorIssueNameEmpty => 'Et navn er tomt';

  @override
  String editorIssueNameTooLong(String name) {
    return '«$name» er for langt';
  }

  @override
  String editorIssueNameBadCharacters(String name) {
    return '«$name» har tegn som ikke kan brukes';
  }

  @override
  String editorIssueNameTaken(String name) {
    return '«$name» er allerede tatt';
  }

  @override
  String get editorIssueCode => 'Koden må være 3 bokstaver, A til Z';

  @override
  String editorIssueDuplicateCode(String code, String nations) {
    return 'Koden $code brukes av $nations';
  }

  @override
  String editorIssueFirstNames(int count) {
    return 'Minst $count fornavn trengs';
  }

  @override
  String editorIssueSurnames(int count) {
    return 'Minst $count etternavn trengs';
  }

  @override
  String get editorIssueValue => 'En verdi er utenfor gyldig område';

  @override
  String get editorIssueUnknown =>
      'Viser til noe som ikke lenger finnes i spillet';

  @override
  String get editorSectionSoon => 'Redigering av denne delen kommer snart.';

  @override
  String get editorNewFailed => 'Databasen kunne ikke opprettes. Prøv igjen.';

  @override
  String get editorPickFailed => 'Filen kunne ikke åpnes.';

  @override
  String get editorRenameFailed => 'Databasen kunne ikke få nytt navn.';

  @override
  String get editorDuplicateFailed => 'Databasen kunne ikke kopieres.';

  @override
  String get editorNationsSearch => 'Søk etter landslag';

  @override
  String get editorFilterAll => 'Alle';

  @override
  String get editorNationsNone => 'Ingen landslag passer med søket.';

  @override
  String get editorNationSquadReady => 'Troppen er klar';

  @override
  String get editorSquadAdd => 'Legg til spiller';

  @override
  String editorSquadFull(int max) {
    return 'En tropp kan ha maks $max spillere.';
  }

  @override
  String editorSquadRemoved(String name) {
    return '$name fjernet fra troppen';
  }

  @override
  String get editorPlayerUnnamed => 'Spiller uten navn';

  @override
  String get editorSquadDuplicate =>
      'En annen spiller i troppen har samme navn.';

  @override
  String get editorSquadEmpty => 'Ingen spillere ennå. Legg til den første.';

  @override
  String get editorSquadReady => 'Troppen er klar til å spille.';

  @override
  String get editorSquadFill => 'Fyll inn manglende spillere';

  @override
  String get editorSquadFillAbout =>
      'Legger til nasjonens egne genererte spillere, de sterkeste først, til troppen har den størrelsen og de posisjonene en karriere krever.';

  @override
  String editorSquadFilled(int count) {
    return 'Spillere lagt til: $count';
  }

  @override
  String get editorCommunityTitle =>
      'Fans deler databasene sine på Discorden vår';

  @override
  String get editorCommunityAbout =>
      'Delt av fellesskapet. Vi hoster eller kontrollerer ikke disse databasene.';

  @override
  String editorSquadRules(int min, int max, int gk, int def, int mid, int fwd) {
    return '$min til $max spillere, med minst $gk keepere, $def forsvarere, $mid midtbanespillere og $fwd spisser.';
  }

  @override
  String get editorShortGk => 'MV';

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
  String get editorPlayerNameHint => 'Skriv navnet hans';

  @override
  String get editorPlayerNameNeeded => 'Navn må fylles ut.';

  @override
  String get editorPlayerNameBad => 'Fjern de uvanlige tegnene.';

  @override
  String get editorPlayerAge => 'Alder';

  @override
  String get editorPlayerPosition => 'Posisjon';

  @override
  String get editorPlayerClub => 'Klubb';

  @override
  String get editorPlayerFreeAgent => 'Klubbløs';

  @override
  String get editorPlayerClubSearch => 'Søk etter klubber';

  @override
  String get editorPlayerClubNone => 'Ingen klubb passer med søket.';

  @override
  String get editorPlayerClubPick => 'Velg en klubb';

  @override
  String get editorPlayerOverall => 'Helhetsvurdering';

  @override
  String get editorPlayerType => 'Spillertype';

  @override
  String get editorPlayerPotential => 'Potensial';

  @override
  String get editorPlayerPotentialAbout =>
      'Toppen han kan nå hvis han utvikler seg godt. Aldri under helhetsvurderingen.';

  @override
  String get editorPlayerQualities => 'Det spillet lagrer';

  @override
  String get editorTypeBalanced => 'Balansert';

  @override
  String get editorTypeAthlete => 'Atlet';

  @override
  String get editorTypeTechnician => 'Tekniker';

  @override
  String get editorTypeEngine => 'Motor';

  @override
  String get editorTypeBalancedAbout =>
      'Jevn i fysikk, teknikk og utholdenhet.';

  @override
  String get editorTypeAthleteAbout => 'Sterk og rask, litt svakere teknisk.';

  @override
  String get editorTypeTechnicianAbout => 'Dyktig med ballen, mindre fysisk.';

  @override
  String get editorTypeEngineAbout => 'Løper hele dagen, stødig i alt annet.';

  @override
  String get editorPlayerLess => 'Én mindre';

  @override
  String get editorPlayerMore => 'Én til';

  @override
  String get editorPlayerRemove => 'Fjern fra troppen';

  @override
  String get editorPlayerGone => 'Denne spilleren er ikke lenger i troppen.';

  @override
  String get editorNationGone => 'Dette landslaget finnes ikke i databasen.';

  @override
  String get editorPickPlayer => 'Velg en spiller å redigere.';

  @override
  String get editorPlayerClubAuto => 'Spillet velger';

  @override
  String get editorPlayerClubAutoAbout =>
      'Spillet plasserer ham i en klubb som passer nivået hans.';

  @override
  String get editorNamesSearch => 'Søk etter navn';

  @override
  String get editorNamesSearchClubs => 'Søk etter klubber eller land';

  @override
  String get editorNamesSearchStadiums =>
      'Søk etter stadioner, byer eller land';

  @override
  String get editorNamesSearchNations => 'Søk etter land eller koder';

  @override
  String get editorNamesNone => 'Ingenting passer med søket.';

  @override
  String get editorNamesEveryLanguage =>
      'Et eget navn vises på alle språk, med mindre du gir et språk sitt eget navn.';

  @override
  String editorNamesGameName(String name) {
    return 'Spillets navn: $name';
  }

  @override
  String get editorNamesReset => 'Tilbakestill til original';

  @override
  String get editorNamesDone => 'Ferdig';

  @override
  String get editorNamesKeepHint =>
      'La feltet stå tomt for å beholde spillets navn.';

  @override
  String get editorNamesCode => 'Kode';

  @override
  String get editorNamesCodeHelp =>
      '3 bokstaver, A til Z, som ingen andre land bruker.';

  @override
  String editorNamesCodeTaken(String code, String nation) {
    return '$code brukes allerede av $nation.';
  }

  @override
  String get editorNamesTaken => 'En annen konto har allerede dette navnet.';

  @override
  String get editorLanguageTitle => 'Navn på hvilket språk';

  @override
  String get editorLanguageAll => 'Alle språk';

  @override
  String get editorLanguageAllShort => 'Alle';

  @override
  String get editorLanguageNote =>
      'Bare editoren bytter språk. Spillet beholder sitt eget språk.';

  @override
  String editorLanguageEditing(String language) {
    return 'Navn på $language. La et felt stå tomt for å bruke hovednavnet.';
  }

  @override
  String get editorLanguageSame => 'Likt på alle språk';

  @override
  String editorLanguageMainName(String name) {
    return 'Hovednavn: $name';
  }

  @override
  String get editorLanguageKeepHint =>
      'La feltet stå tomt for å bruke hovednavnet.';

  @override
  String get editorLanguageClear => 'Bruk hovednavnet';

  @override
  String get editorLanguageFull =>
      'Databasen har ikke plass til flere navn per språk.';

  @override
  String get editorPlayerDelete => 'Slett spiller';

  @override
  String get editorPlayerAdvanced => 'Avansert';

  @override
  String get editorPlayerAdvancedAbout =>
      'Still inn fysikk, teknikk og utholdenhet hver for seg.';

  @override
  String get editorPlayerAdvancedOverall => 'Helhetsvurdering av disse';

  @override
  String get editorPlayerTraits => 'Kjent for';

  @override
  String get editorPlayerTraitsRandom => 'Tilfeldig';

  @override
  String get editorPlayerTraitsRandomAbout =>
      'Hver karriere trekker egenskapene hans, slik spillet alltid har gjort.';

  @override
  String get editorPlayerTraitsNone => 'Ingen egenskaper, i hver karriere.';

  @override
  String editorPlayerTraitsPicked(int max) {
    return 'Disse egenskapene i hver karriere. Velg opptil $max.';
  }

  @override
  String editorPlayerTraitsMax(int max) {
    return 'En spiller har maks $max egenskaper. Fjern én først.';
  }

  @override
  String editorPlayerTraitUnknown(String trait) {
    return '$trait (ukjent for denne versjonen)';
  }

  @override
  String editorIssueInLanguage(String issue, String language) {
    return '$issue ($language)';
  }

  @override
  String get editorTabSquad => 'Tropp';

  @override
  String get editorTabPool => 'Pool';

  @override
  String get editorPoolGenerated => 'Laget av spillet';

  @override
  String get editorPoolGeneratedAbout =>
      'Hver karriere trekker denne poolen på nytt, slik spillet alltid har gjort. Din første endring låser den akkurat slik den vises her, i hver karriere.';

  @override
  String get editorPoolFixed => 'Din pool';

  @override
  String get editorPoolFixedAbout =>
      'Hver karriere starter med nøyaktig disse spillerne.';

  @override
  String get editorPoolReset => 'Tilbake til spillets';

  @override
  String get editorPoolResetTitle => 'Tilbake til spillets pool?';

  @override
  String get editorPoolResetBody =>
      'Endringene dine i denne poolen forkastes, og hver karriere lager den på nytt.';

  @override
  String editorPoolMax(int max) {
    return 'Opptil $max';
  }

  @override
  String editorPoolFull(int max) {
    return 'En pool kan ha maks $max spillere.';
  }

  @override
  String editorPoolRemoved(String name) {
    return '$name fjernet fra poolen';
  }

  @override
  String get editorPoolRemove => 'Fjern fra poolen';

  @override
  String get editorPoolPlayerGone => 'Denne spilleren er ikke lenger i poolen.';

  @override
  String get editorPoolDuplicate => 'En annen spiller i poolen har samme navn.';

  @override
  String get editorPoolEmpty => 'Ingen spillere i poolen. Legg til den første.';

  @override
  String get editorPoolLoadFailed => 'Spillets pool kunne ikke leses.';

  @override
  String editorPlayerTraitsUnknownDropped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ukjente egenskaper fjernet',
      one: '1 ukjent egenskap fjernet',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedTag => 'Lagt til';

  @override
  String get editorAddedGroup => 'Lagt til';

  @override
  String get editorAddedGameGroup => 'I spillet';

  @override
  String get editorAddClub => 'Legg til klubb';

  @override
  String get editorAddSponsor => 'Legg til sponsor';

  @override
  String get editorAddY => 'Legg til konto';

  @override
  String get editorAddedAdd => 'Legg til';

  @override
  String get editorAddedDelete => 'Slett';

  @override
  String editorAddedRemoved(String name) {
    return '$name slettet';
  }

  @override
  String editorAddedClubsFull(int max) {
    return 'En database kan legge til maks $max klubber.';
  }

  @override
  String editorAddedSponsorsFull(int max) {
    return 'En database kan legge til maks $max sponsorer.';
  }

  @override
  String editorAddedYFull(int max) {
    return 'En database kan legge til maks $max kontoer.';
  }

  @override
  String get editorAddReporter => 'Legg til journalist';

  @override
  String get editorAddStadium => 'Legg til stadion';

  @override
  String editorAddedReportersFull(int max) {
    return 'En database kan legge til maks $max journalister.';
  }

  @override
  String editorAddedStadiumsFull(int max) {
    return 'En database kan legge til maks $max stadioner.';
  }

  @override
  String get editorAddedCity => 'By';

  @override
  String get editorAddedCityHelp =>
      'Hvilken som helst by går fint. En by spillet ikke kjenner, får landets utseende og ligger ved havnivå.';

  @override
  String get editorAddedCapacity => 'Plasser';

  @override
  String editorAddedCapacityRange(int min, int max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return '$minString til $maxString plasser';
  }

  @override
  String editorAddedStadiumTaken(String country) {
    return '$country har allerede et tillagt stadion med dette navnet.';
  }

  @override
  String get editorAddedFieldNeeded => 'Fyll ut dette';

  @override
  String get editorAddedReporterAbout =>
      'Er med i pressesalen i karrierer på denne databasen og stiller spørsmål på pressekonferanser.';

  @override
  String get editorAddedStadiumAbout =>
      'Er vertskap for en del av landslagets hjemmekamper i karrierer på denne databasen. Sluttspill blir på spillets egne stadioner.';

  @override
  String get editorAddedGone => 'Dette finnes ikke lenger i databasen.';

  @override
  String get editorAddedNameNeeded => 'Gi den et navn';

  @override
  String get editorAddedCountry => 'Land';

  @override
  String get editorAddedCountryPick => 'Velg et land';

  @override
  String editorAddedNoLeague(String country) {
    return '$country har ingen liga eller byer i spillet, så denne klubben får bare spillerne du selv plasserer der.';
  }

  @override
  String editorAddedClubTaken(String country) {
    return '$country har allerede en klubb med dette navnet.';
  }

  @override
  String get editorAddedClubGameName =>
      'En klubb i spillet heter allerede dette.';

  @override
  String editorAddedClubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count spillere fra denne databasen spiller her. Slett klubben, så plasserer spillet dem.',
      one:
          '1 spiller fra denne databasen spiller her. Slett klubben, så plasserer spillet ham.',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedDeal => 'Avtaletype';

  @override
  String get editorDealBigPayer => 'Storbetaler';

  @override
  String get editorDealCrowdPleaser => 'Spillerfavoritt';

  @override
  String get editorDealFamilyFriendly => 'Familievennlig';

  @override
  String get editorDealMarketing => 'Markedsføring';

  @override
  String get editorAddedIndustry => 'Bransje';

  @override
  String get editorAddedIndustryPick => 'Velg en bransje';

  @override
  String get editorHandleLabel => 'Brukernavn';

  @override
  String get editorHandleHelp =>
      'Bokstaver, sifre og understreker. La feltet stå tomt for å følge navnet.';

  @override
  String get editorHandleBadCharacters =>
      'Bruk bare bokstavene A til Z, sifre og understreker';

  @override
  String get editorHandleTaken =>
      'En annen konto har allerede dette brukernavnet.';

  @override
  String get editorAddedDescription => 'Beskrivelse (valgfritt)';

  @override
  String get editorAddedDescriptionHelp =>
      'Står feltet tomt, bruker tilbudet den vanlige linjen for avtaletypen.';

  @override
  String get editorAddedVoice => 'Kontotype';

  @override
  String get editorYVoiceFan => 'Supporter';

  @override
  String get editorYVoicePundit => 'Ekspert';

  @override
  String get editorYVoiceMeme => 'Meme';

  @override
  String get editorYVoiceStats => 'Statistikk';

  @override
  String get editorYVoiceRival => 'Rival';

  @override
  String get editorYVoiceExpro => 'Eks-proff';

  @override
  String get editorYVoiceNeutral => 'Nøytral';

  @override
  String get editorYVoiceFanAbout =>
      'En av dine egne supportere. Begeistret, rasende, ustadig.';

  @override
  String get editorYVoicePunditAbout =>
      'En behersket stemme som dukker opp gjennom hele karrieren.';

  @override
  String get editorYVoiceMemeAbout =>
      'Sier ingenting nyttig og blir lest først.';

  @override
  String get editorYVoiceStatsAbout => 'Poster tall og ingenting annet.';

  @override
  String get editorYVoiceRivalAbout => 'Nyter motgangen din.';

  @override
  String get editorYVoiceExproAbout =>
      'En tidligere landslagsspiller med en spalte og null tålmodighet.';

  @override
  String get editorYVoiceNeutralAbout =>
      'Følger all fotball og dukker bare opp når noe stort skjer.';

  @override
  String get editorAddedPostsIn => 'Skriver i';

  @override
  String get editorAddedAllNations => 'Alle landslag';

  @override
  String get editorAddedSearch => 'Søk';

  @override
  String editorCountAdded(int count) {
    return '$count lagt til';
  }

  @override
  String get editorNamesOutlet => 'Medium';

  @override
  String get editorNamesFirstNames => 'Fornavn';

  @override
  String get editorNamesSurnames => 'Etternavn';

  @override
  String editorNamesFirstCount(int count, int min) {
    return '$count / $min fornavn';
  }

  @override
  String editorNamesSurCount(int count, int min) {
    return '$count / $min etternavn';
  }

  @override
  String editorNamesListsHelp(int min) {
    return 'Skill navnene med komma eller nye linjer. Hver liste trenger minst $min. De gis til nye spillere, lokale fans og støtteapparat.';
  }

  @override
  String editorNamesListCounts(int first, int sur) {
    return '$first fornavn, $sur etternavn';
  }

  @override
  String editorNamesMainStadium(String city) {
    return 'Hovedstadion i $city';
  }

  @override
  String get editorNamesChanged => 'Endret';

  @override
  String get editorNamesPick => 'Velg et navn å redigere.';

  @override
  String get editorNamesStadiumsNote =>
      'Bare nasjonalstadionene som står her, kan få nytt navn: hovedstadionet i hver by.';

  @override
  String get editorTrophiesIntro =>
      'Trykk på en pokal for å gi den ditt eget bilde. En PNG med gjennomsiktig bakgrunn ser best ut.';

  @override
  String get editorTrophyCustom => 'Egen';

  @override
  String get editorTrophyDefault => 'Spillets bilde';

  @override
  String get editorTrophyChoose => 'Velg et bilde';

  @override
  String get editorTrophyReplace => 'Velg et annet bilde';

  @override
  String get editorTrophyReset => 'Tilbake til standard';

  @override
  String get editorTrophyResetTitle => 'Bruke spillets bilde?';

  @override
  String get editorTrophyResetBody =>
      'Bildet ditt for denne pokalen fjernes. Angre kan ikke hente det tilbake.';

  @override
  String get editorTrophyResetConfirm => 'Fjern bildet';

  @override
  String get editorTrophyUnusable =>
      'Dette bildet kan ikke brukes. Velg en PNG eller JPEG på maks 4096 piksler per side.';

  @override
  String get editorTrophyOpening => 'Åpner bildet';

  @override
  String get editorTrophyPreparing => 'Gjør klar pokalen';

  @override
  String get editorTrophyFrameTitle => 'Ramme inn pokalen';

  @override
  String get editorTrophyFrameHint =>
      'Dra for å flytte og knip for å zoome. Det som er innenfor rammen, blir pokalen.';

  @override
  String get editorTrophyFit => 'Tilpass';

  @override
  String get editorTrophyPreview => 'Forhåndsvis';

  @override
  String get editorTrophyPreviewTitle => 'Slik blir det';

  @override
  String get editorTrophyAdjust => 'Juster';

  @override
  String get editorTrophyUse => 'Bruk bildet';

  @override
  String get editorTrophyRectangle =>
      'Bildet har ingen gjennomsiktig bakgrunn, så spillet viser det som et rektangel.';

  @override
  String get editorTrophyRectangleShort => 'Vises som rektangel';

  @override
  String get editorTrophySaved => 'Pokalbildet er lagret.';

  @override
  String get editorTrophyRemoved => 'Spillets bilde er tilbake.';

  @override
  String get editorTrophySaveFailed => 'Bildet kunne ikke lagres. Prøv igjen.';

  @override
  String get editorSaveFailed =>
      'De siste endringene kunne ikke lagres. Prøver igjen.';

  @override
  String get editorTrophyPick => 'Velg en pokal for å bytte bildet.';

  @override
  String editorTrophySize(int width, int height) {
    return 'Lagres i $width x $height piksler';
  }

  @override
  String editorIssueUnknownEntry(String name) {
    return '$name finnes ikke lenger i spillet';
  }

  @override
  String get editorAttentionBody =>
      'Noe i denne databasen passer ikke med denne versjonen av spillet: et navnesammenfall, eller noe en spilloppdatering fjernet. Rett eller fjern hver oppføring nedenfor, så kan den starte en karriere igjen.';

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
  String get worldSheetTitle => 'Velg en verden';

  @override
  String get worldSheetBlurb =>
      'Databaser du har laget eller åpnet i Editoren. Bare komplette kan starte en karriere.';

  @override
  String get worldPackGone =>
      'Databasen finnes ikke lenger på enheten. Karrieren ble ikke startet.';

  @override
  String get worldStarting => 'Gjør klar verdenen din';

  @override
  String get settingsDefaultWorldTitle => 'Standardverden';

  @override
  String get settingsDefaultWorldBlurb =>
      'Verdenen Nytt spill starter i. Du kan fortsatt endre den for hver karriere.';

  @override
  String get worldPackNotReady =>
      'Den databasen kan ikke lenger starte en karriere. Fiks den i Editoren, eller velg en annen verden.';

  @override
  String pitchComShotGoal1(String player) {
    return 'MÅL! $player finner nettet!';
  }

  @override
  String pitchComShotGoal2(String player) {
    return '$player skyter den inn! MÅL!';
  }

  @override
  String pitchComShotGoal3(String player) {
    return 'MÅL! Iskald avslutning fra $player.';
  }

  @override
  String pitchComReboundGoal1(String player, String other) {
    return '$other skyter, keeperen returnerer, og $player følger opp! MÅL!';
  }

  @override
  String pitchComReboundGoal2(String player, String other) {
    return '$other blir stoppet, men $player slår til på returen! MÅL!';
  }

  @override
  String pitchComReboundGoal3(String player, String other) {
    return 'MÅL! $other tvinger keeperen til redning, og $player setter returen i nettet!';
  }

  @override
  String pitchComReboundOwn1(String player) {
    return 'Reddet, men $player følger opp! MÅL!';
  }

  @override
  String pitchComReboundOwn2(String player, String keeper) {
    return '$keeper parerer, men $player er først på returen! MÅL!';
  }

  @override
  String pitchComReboundOwn3(String player) {
    return 'MÅL! Parert, og $player er kjappest på returen!';
  }

  @override
  String pitchComShotSaved1(String player, String keeper) {
    return '$player skyter, men $keeper redder.';
  }

  @override
  String pitchComShotSaved2(String player) {
    return '$player prøver, men keeperen er på plass.';
  }

  @override
  String pitchComShotSaved3(String player, String keeper) {
    return '$player drar til, $keeper slår den unna!';
  }

  @override
  String pitchComShotWide1(String player) {
    return '$player skyter utenfor.';
  }

  @override
  String pitchComShotWide2(String player) {
    return 'Utenfor mål av $player.';
  }

  @override
  String pitchComShotWide3(String player) {
    return '$player skyter like utenfor stolpen.';
  }

  @override
  String pitchComShotBlocked1(String player) {
    return '$player skyter, men skuddet blir blokkert.';
  }

  @override
  String pitchComShotBlocked2(String player) {
    return 'Blokkert! $player finner ingen vei gjennom.';
  }

  @override
  String pitchComShotBlocked3(String player) {
    return '$player skyter, men en forsvarer kaster seg imellom.';
  }

  @override
  String pitchComShotWoodwork1(String player) {
    return 'Stolpe! $player er uheldig.';
  }

  @override
  String pitchComShotWoodwork2(String player) {
    return '$player treffer tregrensen!';
  }

  @override
  String pitchComShotWoodwork3(String player) {
    return 'Tverrligger! $player stoppes av list og stolpe.';
  }

  @override
  String pitchComHeaderGoal1(String player) {
    return 'MÅL! $player nikker den inn!';
  }

  @override
  String pitchComHeaderGoal2(String player) {
    return '$player hopper høyest og scorer! MÅL!';
  }

  @override
  String pitchComHeaderGoal3(String player) {
    return 'MÅL! Kraftig hodestøt av $player.';
  }

  @override
  String pitchComHeaderSaved1(String player, String keeper) {
    return '$player nikker, $keeper redder.';
  }

  @override
  String pitchComHeaderSaved2(String player) {
    return 'Hodestøt av $player, men keeperen holder.';
  }

  @override
  String pitchComHeaderSaved3(String player, String keeper) {
    return 'Hodestøt av $player, $keeper slår den unna.';
  }

  @override
  String pitchComHeaderWide1(String player) {
    return '$player nikker utenfor.';
  }

  @override
  String pitchComHeaderWide2(String player) {
    return 'Hodestøt av $player, men utenfor.';
  }

  @override
  String pitchComHeaderWide3(String player) {
    return '$player får ikke ned hodestøtet.';
  }

  @override
  String pitchComHeaderBlocked1(String player) {
    return '$player nikker, men det blir blokkert.';
  }

  @override
  String pitchComHeaderBlocked2(String player) {
    return '$player nikker mot mål, men forsvaret blokkerer.';
  }

  @override
  String pitchComHeaderBlocked3(String player) {
    return 'Blokkert! $player når ballen, men en forsvarer står i veien.';
  }

  @override
  String pitchComHeaderWoodwork1(String player) {
    return '$player nikker i tverrliggeren!';
  }

  @override
  String pitchComHeaderWoodwork2(String player) {
    return 'Stolpe! Hodestøtet fra $player spretter tilbake i spill.';
  }

  @override
  String pitchComHeaderWoodwork3(String player) {
    return 'Tregrensen! $player får målet til å riste med et hodestøt.';
  }

  @override
  String pitchComSetPieceGoal1(String player) {
    return 'MÅL! $player er der på slutten av angrepet!';
  }

  @override
  String pitchComSetPieceGoal2(String player, String other) {
    return 'MÅL! $other slår inn og $player scorer!';
  }

  @override
  String pitchComSetPieceGoal3(String player) {
    return 'På dødball scorer $player! MÅL!';
  }

  @override
  String pitchComSetPieceSaved1(String player, String keeper) {
    return '$player når ballen, men $keeper redder.';
  }

  @override
  String pitchComSetPieceSaved2(String player) {
    return '$player tar på ballen, keeperen sikrer den.';
  }

  @override
  String pitchComSetPieceSaved3(String player, String keeper) {
    return '$player avslutter, $keeper er våken.';
  }

  @override
  String pitchComSetPieceWide1(String player) {
    return '$player kommer til avslutning, men utenfor.';
  }

  @override
  String pitchComSetPieceWide2(String player) {
    return '$player når innlegget, men utenfor mål.';
  }

  @override
  String pitchComSetPieceWide3(String player) {
    return 'Over tverrliggeren av $player.';
  }

  @override
  String pitchComSetPieceBlocked1(String player) {
    return '$player når ballen, men det blir blokkert.';
  }

  @override
  String pitchComSetPieceBlocked2(String player) {
    return 'Kaos i boksen! $player blir blokkert.';
  }

  @override
  String pitchComSetPieceBlocked3(String player) {
    return '$player prøver å presse den inn, men forsvaret klarerer.';
  }

  @override
  String pitchComSetPieceWoodwork1(String player) {
    return '$player avslutter og treffer stolpen!';
  }

  @override
  String pitchComSetPieceWoodwork2(String player) {
    return 'Tverrligger! $player nær ved å score på dødball.';
  }

  @override
  String pitchComSetPieceWoodwork3(String player) {
    return 'Tregrensen! $player så nær etter innlegget.';
  }

  @override
  String pitchComDirectFreeKickGoal1(String player) {
    return 'MÅL! $player legger frisparket over muren!';
  }

  @override
  String pitchComDirectFreeKickGoal2(String player) {
    return 'For et frispark! $player finner krysset!';
  }

  @override
  String pitchComDirectFreeKickGoal3(String player) {
    return 'MÅL! $player lurer keeperen på frispark.';
  }

  @override
  String pitchComDirectFreeKickSaved1(String player, String keeper) {
    return '$player skyter direkte mot mål, $keeper redder.';
  }

  @override
  String pitchComDirectFreeKickSaved2(String player) {
    return 'Frisparket fra $player blir slått unna.';
  }

  @override
  String pitchComDirectFreeKickSaved3(String player, String keeper) {
    return 'Flott redning! Frispark av $player, $keeper stopper det.';
  }

  @override
  String pitchComDirectFreeKickWide1(String player) {
    return 'Frisparket fra $player går over.';
  }

  @override
  String pitchComDirectFreeKickWide2(String player) {
    return '$player prøver direkte, men utenfor.';
  }

  @override
  String pitchComDirectFreeKickWide3(String player) {
    return '$player treffer ikke mål på frispark.';
  }

  @override
  String pitchComDirectFreeKickBlocked1(String player) {
    return 'Frisparket fra $player ender i muren.';
  }

  @override
  String pitchComDirectFreeKickBlocked2(String player) {
    return 'Rett i muren av $player.';
  }

  @override
  String pitchComDirectFreeKickBlocked3(String player) {
    return 'Muren holder mot $player.';
  }

  @override
  String pitchComDirectFreeKickWoodwork1(String player) {
    return '$player treffer tverrliggeren med frisparket!';
  }

  @override
  String pitchComDirectFreeKickWoodwork2(String player) {
    return 'Stolpe! Frispark av $player, ballen spretter tilbake.';
  }

  @override
  String pitchComDirectFreeKickWoodwork3(String player) {
    return 'Tregrensen redder keeperen! $player er uheldig.';
  }

  @override
  String pitchComPenaltyGoal1(String player) {
    return 'MÅL! $player sender keeperen feil vei.';
  }

  @override
  String pitchComPenaltyGoal2(String player) {
    return '$player tar tilløp og scorer! MÅL!';
  }

  @override
  String pitchComPenaltyGoal3(String player) {
    return 'MÅL! $player setter straffen iskaldt.';
  }

  @override
  String pitchComPenaltySaved1(String player, String keeper) {
    return 'Reddet! Straffe av $player, $keeper stopper den!';
  }

  @override
  String pitchComPenaltySaved2(String player) {
    return '$player tar tilløp... og keeperen redder!';
  }

  @override
  String pitchComPenaltySaved3(String player, String keeper) {
    return 'Straffe av $player, $keeper gjetter riktig og redder!';
  }

  @override
  String pitchComPenaltyMissed1(String player) {
    return '$player bommer på straffen!';
  }

  @override
  String pitchComPenaltyMissed2(String player) {
    return 'Utenfor! Straffen fra $player går like utenfor stolpen.';
  }

  @override
  String pitchComPenaltyMissed3(String player) {
    return 'Over! $player sparker straffen til værs.';
  }

  @override
  String pitchComPenaltyWoodwork1(String player) {
    return 'Straffe av $player i stolpen!';
  }

  @override
  String pitchComPenaltyWoodwork2(String player) {
    return 'Tverrligger! Straffen fra $player går ikke inn.';
  }

  @override
  String pitchComPenaltyWoodwork3(String player) {
    return 'Tregrensen! $player kan ikke tro det.';
  }

  @override
  String pitchComPenaltyAwarded1(String player) {
    return 'Straffe! $player felles i boksen.';
  }

  @override
  String pitchComPenaltyAwarded2(String player, String other) {
    return 'Dommeren peker på straffemerket! Forseelse av $other mot $player.';
  }

  @override
  String pitchComPenaltyAwarded3(String player, String other) {
    return 'Straffe dømt! $other feller $player i boksen.';
  }

  @override
  String pitchComPenaltyAwardedYellow1(String player, String other) {
    return 'Straffe! $player går i bakken og $other får gult.';
  }

  @override
  String pitchComPenaltyAwardedYellow2(String player, String other) {
    return 'Straffe, og gult kort til $other etter forseelsen mot $player.';
  }

  @override
  String pitchComPenaltyAwardedYellow3(String player, String other) {
    return 'Straffe og kort! $other feller $player i boksen.';
  }

  @override
  String pitchComPenaltyAwardedRed1(String player, String other) {
    return 'Straffe og rødt! $player går i bakken, $other blir utvist.';
  }

  @override
  String pitchComPenaltyAwardedRed2(String player, String other) {
    return 'Straffe, og $other utvises for forseelsen mot $player!';
  }

  @override
  String pitchComPenaltyAwardedRed3(String player, String other) {
    return 'Rødt og straffe! $other stopper $player alene mot mål.';
  }

  @override
  String pitchComCorner1(String player) {
    return 'Hjørnespark. Tas av $player.';
  }

  @override
  String pitchComCorner2(String player) {
    return '$player slår hjørnesparket inn.';
  }

  @override
  String pitchComCorner3(String player) {
    return 'Hjørnespark, $player gjør seg klar.';
  }

  @override
  String pitchComFreeKick1(String player) {
    return 'Frispark. Tas av $player.';
  }

  @override
  String pitchComFreeKick2(String player) {
    return 'Frispark i farlig posisjon. $player stiller seg opp.';
  }

  @override
  String pitchComFreeKick3(String player) {
    return '$player gjør seg klar til frisparket.';
  }

  @override
  String pitchComLongThrow1(String player) {
    return 'Langt innkast! $player kaster ballen inn i boksen.';
  }

  @override
  String pitchComLongThrow2(String player) {
    return '$player med et langt innkast inn i boksen.';
  }

  @override
  String pitchComLongThrow3(String player) {
    return 'Her kommer det lange innkastet fra $player.';
  }

  @override
  String pitchComFoulYellow1(String player) {
    return 'Gult kort til $player.';
  }

  @override
  String pitchComFoulYellow2(String player, String other) {
    return '$player får gult for en forseelse mot $other.';
  }

  @override
  String pitchComFoulYellow3(String player, String other) {
    return 'Sen takling på $other, og $player får gult.';
  }

  @override
  String pitchComFoulSecondYellow1(String player) {
    return 'Andre gule kort! $player blir utvist.';
  }

  @override
  String pitchComFoulSecondYellow2(String player) {
    return '$player får nok et gult og blir utvist.';
  }

  @override
  String pitchComFoulSecondYellow3(String player) {
    return 'Andre gule kort til $player, altså rødt.';
  }

  @override
  String pitchComFoulRed1(String player) {
    return 'Rødt kort! $player blir utvist.';
  }

  @override
  String pitchComFoulRed2(String player, String other) {
    return 'Direkte rødt til $player etter forseelsen mot $other!';
  }

  @override
  String pitchComFoulRed3(String player) {
    return '$player får rødt og må forlate banen.';
  }

  @override
  String pitchComOffside1(String player) {
    return 'Offside. $player løp for tidlig.';
  }

  @override
  String pitchComOffside2(String player) {
    return 'Flagget går opp for $player.';
  }

  @override
  String pitchComOffside3(String player) {
    return '$player er offside.';
  }

  @override
  String pitchComSub1(String player, String other) {
    return 'Bytte: $player inn, $other ut.';
  }

  @override
  String pitchComSub2(String player, String other) {
    return '$other gir plassen til $player.';
  }

  @override
  String pitchComSub3(String player, String other) {
    return '$player kommer inn for $other.';
  }

  @override
  String pitchComSubFill1(String player) {
    return '$player kommer inn.';
  }

  @override
  String pitchComSubFill2(String player) {
    return 'Bytte: $player er på banen.';
  }

  @override
  String pitchComSubFill3(String player) {
    return '$player entrer banen.';
  }

  @override
  String pitchComInjury1(String player) {
    return '$player ligger nede og trenger behandling.';
  }

  @override
  String pitchComInjury2(String player) {
    return 'Bekymring, $player har fått en smell.';
  }

  @override
  String pitchComInjury3(String player) {
    return 'Skadebekymring for $player.';
  }

  @override
  String pitchComGoalScore(String line, int home, int away) {
    return '$line $home–$away';
  }

  @override
  String get pitchComSomeone => 'Spiller';

  @override
  String pitchComPenaltyAwardedSecondYellow1(String player, String other) {
    return 'Straffe og andre gule! $other blir utvist for forseelsen mot $player.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow2(String player, String other) {
    return 'Straffe! $player går i bakken og $other får andre gule kort.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow3(String player, String other) {
    return 'Straffe! $other feller $player og får nok et gult, altså rødt.';
  }

  @override
  String get matchViewChooseTitle => 'Hvordan vil du følge kampen?';

  @override
  String get matchViewChooseHint =>
      'Valget ditt gjelder også neste kamp. Du kan bytte når som helst.';

  @override
  String get matchViewPitch => '2D TV';

  @override
  String get matchViewPitchBlurb => 'Følg spillerne på banen';

  @override
  String get matchViewTimeline => 'Forløp';

  @override
  String get matchViewTimelineBlurb => 'Følg kampen hendelse for hendelse';

  @override
  String get matchViewSwitchToPitch => 'Se i 2D TV-modus';

  @override
  String get matchViewSwitchToTimeline => 'Se forløpet';

  @override
  String get matchTabCommentary => 'KOMMENTARER';

  @override
  String get matchSubShout => 'BYTTE';

  @override
  String matchSubOff(String name) {
    return 'Ut: $name';
  }

  @override
  String matchSubOn(String name) {
    return 'Inn: $name';
  }

  @override
  String get editorFilterToFix => 'Må rettes';

  @override
  String get editorNothingToFix => 'Ingenting må rettes her.';

  @override
  String get editorPromoteTooltip => 'Flytt til troppen';

  @override
  String editorPromoted(String name) {
    return '$name flyttet til troppen';
  }

  @override
  String get editorPromoteFullTitle => 'Troppen er full';

  @override
  String editorPromoteFullBody(int max) {
    return 'En tropp har høyst $max spillere. Velg spilleren som går tilbake til puljen i hans sted.';
  }

  @override
  String get editorTrophyGallery => 'Velg fra bildene dine';

  @override
  String get editorTrophyFile => 'Velg en fil';

  @override
  String clubStrengthOf(int stars) {
    return 'Klubbstyrke: $stars av 5';
  }

  @override
  String get editorClubStrength => 'Styrke';

  @override
  String get editorClubStrengthDefault => 'Standard';

  @override
  String editorClubStrengthHelp(int stars) {
    return 'Bedre spillere går til sterkere klubber. Standard: $stars av 5, ut fra ligaen.';
  }

  @override
  String mgrNewsSacked(String nation, String name) {
    return '$nation sparker $name';
  }

  @override
  String mgrNewsResigned(String nation, String name) {
    return '$nation: $name går av';
  }

  @override
  String mgrNewsPoached(String nation, String name) {
    return '$nation: $name forlater for et annet landslag';
  }

  @override
  String mgrNewsRetired(String nation, String name) {
    return '$nation: $name legger opp som trener';
  }

  @override
  String mgrNewsContractEnd(String nation, String name) {
    return '$nation: $name går når kontrakten løper ut';
  }

  @override
  String mgrNewsReplacedByPlayer(String nation, String name) {
    return '$nation: $name gir plassen til deg';
  }

  @override
  String mgrNewsAppointed(String nation, String name) {
    return '$nation ansetter $name';
  }

  @override
  String mgrNewsAppointedBody(String nation, String name) {
    return '$name overtar $nation.';
  }

  @override
  String pressBeatOpposingManager(String manager) {
    return 'Du og $manager har en historie. Har du noe å si om ham?';
  }

  @override
  String get pressAnswerHitBackAtManager =>
      'Han bør bekymre seg for sitt eget lag.';

  @override
  String get pressAnswerRespectManager => 'Jeg har stor respekt for ham.';

  @override
  String yMgrTie1(String manager) {
    return '$manager på den andre benken neste gang. Det er en historie med sjefen vår, og jeg gleder meg.';
  }

  @override
  String yMgrTie2(String manager) {
    return 'Neste ut er $manager på den andre benken. Han og landslagstreneren vår har kjent hverandre en stund.';
  }

  @override
  String yMgrTie3(String manager) {
    return '$manager igjen. Sjefen vår bør ikke gjøre dette til en personlig sak.';
  }

  @override
  String yMgrTie4(String manager) {
    return 'Nå går det løs. $manager langs sidelinjen, og sjefen vår prøver å vinne en feide i stedet for en kamp.';
  }

  @override
  String get mgrRowLabel => 'Landslagstrener';

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
  String get mgrTieSuccessor => 'Etterfølger';

  @override
  String get mgrTieProtege => 'Skyddsling';

  @override
  String get mgrTieFormerPlayer => 'Tidligere spiller';

  @override
  String get mgrEndSacked => 'Sparket';

  @override
  String get mgrEndResigned => 'Gikk av';

  @override
  String get mgrEndPoached => 'Forlot for et annet landslag';

  @override
  String get mgrEndRetired => 'La opp som trener';

  @override
  String get mgrEndContractEnd => 'Kontrakten gikk ut';

  @override
  String get mgrEndReplacedByPlayer => 'Erstattet av deg';

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
  String get mgrProfileRecordVsYou => 'Hans resultater mot deg';

  @override
  String get mgrProfileNoMeetings => 'Dere har ikke møttes ennå';

  @override
  String get mgrProfileReputation => 'Omdømme';

  @override
  String get mgrProfileAge => 'Alder';

  @override
  String get mgrProfileAppointed => 'Ansatt';

  @override
  String get mgrProfileStyle => 'Stil';

  @override
  String get mgrProfileTie => 'Mellom dere';

  @override
  String mgrPreviewLine(String name) {
    return 'Deres landslagstrener: $name';
  }

  @override
  String mgrDossierStyle(String style) {
    return 'Landslagstrenerens stil: $style';
  }

  @override
  String mgrDossierRecord(String record) {
    return 'Dine resultater mot ham: $record';
  }

  @override
  String get mgrStylePossession => 'Ballbesittelse';

  @override
  String get mgrStyleHighPress => 'Høyt press';

  @override
  String get mgrStyleDefensive => 'Defensiv';

  @override
  String get mgrStyleDirect => 'Direkte';

  @override
  String get mgrStyleCounter => 'Kontring';

  @override
  String get mgrStyleFlair => 'Teknisk';

  @override
  String get mgrStylePhysical => 'Fysisk';

  @override
  String get mgrStyleBalanced => 'Balansert';

  @override
  String get mgrListTitle => 'Landslagstrenere';

  @override
  String get mgrListCurrent => 'Nåværende';

  @override
  String get mgrListRecentMoves => 'Siste endringer';

  @override
  String get mgrListFilterAll => 'Alle';

  @override
  String get mgrListSortReputation => 'Omdømme';

  @override
  String get mgrListSortName => 'Navn';

  @override
  String get mgrListEmptyMoves => 'Ingen endringer de siste to årene.';

  @override
  String get mgrListEmptyCurrent =>
      'Landslagstrenere vises etter neste sesongskifte.';

  @override
  String get editorSectionManagers => 'Landslagstrenere';

  @override
  String get editorAboutManagers => 'Hvem som leder hvert landslag fra start';

  @override
  String get editorManagersHint => 'Velges når en karriere starter';

  @override
  String get editorManagerName => 'Trenerens navn';

  @override
  String get editorManagerNationality => 'Nasjonalitet';

  @override
  String editorIssueManagerName(int max) {
    return 'Treneren trenger et navn på 1 til $max tegn som spillet kan vise';
  }

  @override
  String get editorIssueManagerNationality =>
      'Velg en nasjonalitet for treneren fra listen';

  @override
  String get shareButton => 'Del';

  @override
  String get shareSheetTitle => 'Del som bilde';

  @override
  String get shareFormatSquare => 'Kvadrat';

  @override
  String get shareFormatStory => 'Story';

  @override
  String get shareFailed => 'Bildet kunne ikke lages.';

  @override
  String get shareSaveToPhotos => 'Lagre i bilder';

  @override
  String get shareSavedToPhotos => 'Lagret i bilder';

  @override
  String get sharePhotosDenied =>
      'FNM har ikke tilgang til å legge til i bildene dine. Du kan tillate det i Innstillinger.';

  @override
  String get editorCountryAll => 'Alle land';

  @override
  String get editorCountryFilterTitle => 'Filtrer etter land';

  @override
  String get shareCabinetBig => 'Del troféene mine';

  @override
  String yExitProud0(String competition) {
    return 'Et uventet eventyr i $competition og et flott resultat til slutt. Stolt av gutta.';
  }

  @override
  String yExitProud1(String competition) {
    return 'Ingen ga oss en sjanse i $competition. Vi kom lenger enn noen turte å drømme om. Takk, gutter.';
  }

  @override
  String yExitProud2(String competition) {
    return 'Ute av $competition, men for en reise. Dette laget fikk hele landet til å tro. Stolt.';
  }

  @override
  String yExitProud3(String competition) {
    return 'Trodde ikke vi skulle komme oss ut av gruppen i $competition. Alt etter det var bonus. Fremover og oppover.';
  }

  @override
  String yExitProud4(String competition) {
    return 'Vi dro til $competition i håp om et poeng eller to og kom hjem etter å ha spilt sluttspill. God turnering.';
  }

  @override
  String yExitProud5(String competition) {
    return 'Lenger enn tippingen sa i $competition. Det er et steg fremover, rett og slett.';
  }

  @override
  String yExitProud6(String competition) {
    return 'Ute av $competition, og det svir litt. Men ærlig talt: ingen trodde vi skulle komme så langt.';
  }

  @override
  String yExitProud7(String competition) {
    return 'Greit, vi er ute av $competition. Likevel mer enn vi har fått til på flere år. Jeg tar det.';
  }

  @override
  String yExitProud8(String competition) {
    return 'Ingen pokal fra $competition, og det ble det aldri heller. Et godt løp er et godt løp. Gjør det igjen nå.';
  }

  @override
  String get yReactionPride0 => 'Stolt av hver eneste en.';

  @override
  String get yReactionPride1 => 'For et løp. Takk, gutter.';

  @override
  String get yReactionPride2 => 'Ingen ventet dette. Husk det.';

  @override
  String get yReactionPride3 => 'Fremover og oppover.';

  @override
  String get yReactionPride4 => 'Alt er bonus. Nyt det.';

  @override
  String get yReactionPride5 => 'Bedre enn noen spådde. God turnering.';

  @override
  String get yReactionPride6 => 'Ute, men ikke ydmyket. Greit nok.';

  @override
  String get yReactionPride7 =>
      'Det beste laget gikk videre. Vi gjorde oss ære likevel.';

  @override
  String get yReactionPride8 =>
      'La oss ikke bli for ivrige. Men ja, et godt løp.';

  @override
  String yExitAccepted0(String competition) {
    return 'Ute av $competition, omtrent der vi alltid skulle ende. Stolt av at de prøvde.';
  }

  @override
  String yExitAccepted1(String competition) {
    return '$competition er over for oss. Vi ga de store lagene kamp. Hodet høyt, gutter.';
  }

  @override
  String yExitAccepted2(String competition) {
    return 'Ute av $competition. På papiret var dette alltid den sannsynlige slutten. Lær av det og prøv igjen.';
  }

  @override
  String yExitAccepted3(String competition) {
    return 'Vårt $competition slutter der rankingen sa det ville. Ingen skam i det.';
  }

  @override
  String yExitAccepted4(String competition) {
    return 'Ute av $competition, som de fleste av oss ventet. Ingen katastrofe, men intet sjokk heller.';
  }

  @override
  String yExitAccepted5(String competition) {
    return '$competition var et steg for langt for denne troppen. Avstanden er reell. På tide å tette den.';
  }

  @override
  String get yReactionAcceptance0 => 'Ga alt. Mer kan man ikke be om.';

  @override
  String get yReactionAcceptance1 => 'Hodet høyt. Vi kommer tilbake.';

  @override
  String get yReactionAcceptance2 =>
      'Det gjør vondt, men de gjorde oss ikke til skamme.';

  @override
  String get yReactionAcceptance3 => 'Omtrent som ventet, ærlig talt.';

  @override
  String get yReactionAcceptance4 =>
      'De bedre lagene gikk videre. Sånn er fotball.';

  @override
  String get yReactionAcceptance5 => 'Skuffet, ikke sint.';

  @override
  String get yReactionAcceptance6 => 'Litt flatt, ærlig talt. Men ingen sjokk.';

  @override
  String get yReactionAcceptance7 => 'Vi er ikke der ennå. Det vet alle.';

  @override
  String get yReactionAcceptance8 =>
      'Samme nivå som sist. Trenger et steg opp neste syklus.';

  @override
  String get sponsorIndustryExtraSportswear => 'Sportsklær';

  @override
  String get sponsorIndustryExtraAirline => 'Fullservice flyselskap';

  @override
  String get sponsorIndustryExtraRailway => 'Jernbane';

  @override
  String get sponsorIndustryExtraHotels => 'Hotellkjede';

  @override
  String get sponsorIndustryExtraCoffee => 'Kaffekjede';

  @override
  String get sponsorIndustryExtraChocolate => 'Sjokolade';

  @override
  String get sponsorIndustryExtraMineralWater => 'Mineralvann';

  @override
  String get sponsorIndustryExtraPharmacy => 'Apotekkjede';

  @override
  String get sponsorIndustryExtraFashion => 'Mote';

  @override
  String get sponsorIndustryExtraWatches => 'Urmaker';

  @override
  String get sponsorIndustryExtraElectronics => 'Elektronikk';

  @override
  String get sponsorIndustryExtraSoftware => 'Programvare';

  @override
  String get sponsorIndustryExtraStreaming => 'Strømmetjeneste';

  @override
  String get sponsorIndustryExtraSocialNetwork => 'Sosialt nettverk';

  @override
  String get sponsorIndustryExtraFurniture => 'Møbler';

  @override
  String get sponsorIndustryExtraTyres => 'Dekk';

  @override
  String get sponsorIndustryExtraShipping => 'Rederi';

  @override
  String get sponsorIndustryExtraLottery => 'Lotteri';

  @override
  String get sponsorIndustryExtraTourism => 'Turistråd';

  @override
  String get sponsorIndustryExtraCosmetics => 'Kosmetikk';

  @override
  String get sponsorIndustryExtraPetFood => 'Dyremat';

  @override
  String get sponsorIndustryExtraBakery => 'Bakeri';

  @override
  String get sponsorIndustryExtraSupermarket => 'Supermarked';

  @override
  String get sponsorIndustryExtraSportsNutrition => 'Sportsernæring';

  @override
  String get sponsorIndustryExtraWine => 'Vin';

  @override
  String get sponsorIndustryExtraTea => 'Te';

  @override
  String get sponsorIndustryExtraRealEstate => 'Eiendom';

  @override
  String get sponsorIndustryExtraFitness => 'Treningssentre';

  @override
  String get sponsorIndustryExtraNewspaper => 'Avis';

  @override
  String mgrDetailCurrentJob(String nation) {
    return 'Nåværende jobb: $nation';
  }

  @override
  String get mgrDetailFree => 'Uten jobb';

  @override
  String get mgrDetailMatches => 'Kamper';

  @override
  String get mgrDetailTrophies => 'Titler';

  @override
  String get mgrDetailWinRate => 'Seiersprosent';

  @override
  String get mgrDetailRecord => 'Resultater';

  @override
  String get mgrDetailNationsLed => 'Landslag ledet';

  @override
  String get mgrDetailInCharge => 'I jobben';

  @override
  String get mgrDetailNoSpells => 'Har ikke ledet noe landslag ennå.';

  @override
  String get mgrDetailNotFound => 'Fant ikke landslagstreneren.';

  @override
  String get mgrDetailBackground => 'Bakgrunn';

  @override
  String get mgrOriginFresh => 'Yrkestrener';

  @override
  String get mgrOriginExAssistant => 'Tidligere assistenttrener';

  @override
  String mgrNewsSeeManager(String name) {
    return 'Profil: $name';
  }

  @override
  String get mgrChangesTitle => 'Trenerbytter';

  @override
  String mgrChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bytter',
      one: '1 bytte',
    );
    return '$_temp0';
  }

  @override
  String mgrChangesLeftFor(String nation) {
    return 'Ny jobb: $nation';
  }

  @override
  String get mgrChangesAppointed => 'Ansatt';

  @override
  String get mgrChangesVacant => 'Ledig';

  @override
  String get editorNameNotAllowed => 'Dette navnet er ikke tillatt.';

  @override
  String editorIssueNameNotAllowed(String name) {
    return '«$name» er ikke tillatt';
  }

  @override
  String get matchWeatherPlaysHeavyRain =>
      'Kraftig regn: skudd og innlegg mindre presise, flere skli';

  @override
  String get matchWeatherPlaysStorm =>
      'Tordenvær: skudd og innlegg mindre presise, flere skli';

  @override
  String get matchWeatherPlaysSnow =>
      'Snø: tregere spill, pasninger litt vanskeligere';

  @override
  String get matchWeatherPlaysFrost =>
      'Frossen bane: tregere spill, pasninger litt vanskeligere';

  @override
  String get matchWeatherPlaysGale =>
      'Sterk vind: lange baller og innlegg uberegnelige, langskudd vanskeligere';

  @override
  String get matchWeatherPlaysFog => 'Tåke: langskudd vanskeligere';

  @override
  String get matchWeatherPlaysHaze =>
      'Varmedis: varmere enn vanlig, beina gir seg tidligere';

  @override
  String get pitchComKickOffHeavyRain =>
      'Vi er i gang i kraftig regn. Ballen kommer til å skli på dette underlaget.';

  @override
  String get pitchComKickOffStorm =>
      'Avspark i tordenvær. Fotfestet blir lumsk.';

  @override
  String get pitchComKickOffSnow =>
      'Vi er i gang i snøen. Dette blir en treg og forsiktig kamp.';

  @override
  String get pitchComKickOffFrost =>
      'En frostkald kveld og en hard bane. Pasningsspillet blir ikke lett.';

  @override
  String get pitchComKickOffGale =>
      'Avspark i sterk vind. Lange baller kommer til å drive av gårde.';

  @override
  String get pitchComKickOffFog =>
      'Avspark i tett tåke. Ingen kommer til å score lett fra distanse.';

  @override
  String get pitchComKickOffHaze =>
      'Avspark i varmedisen. Beina blir tidlig slitne i dag.';

  @override
  String get matchOwnGoal => 'SELVMÅL';

  @override
  String get matchGoalOwnGoal => 'SM';

  @override
  String pitchComOwnGoal1(String defender) {
    return 'Selvmål! $defender styrer ballen i eget nett.';
  }

  @override
  String pitchComOwnGoal2(String defender, String shooter) {
    return 'Forsøket til $shooter tar en uheldig retningsendring på $defender og går inn.';
  }

  @override
  String pitchComOwnGoal3(String defender) {
    return 'Katastrofe for $defender, som overlister sin egen keeper.';
  }

  @override
  String pitchComBigSave1(String keeper, String player) {
    return 'For en redning! $keeper stopper $player på kort hold.';
  }

  @override
  String pitchComBigSave2(String keeper) {
    return 'Strålende redning av $keeper!';
  }

  @override
  String pitchComBigSave3(String keeper, String player) {
    return '$player så ut til å score, men $keeper redder på et vis.';
  }

  @override
  String matchTimelineWoodwork(String name) {
    return '$name traff treverket';
  }

  @override
  String matchTimelineBigSave(String name) {
    return 'Stor redning av $name';
  }

  @override
  String get matchChartXg => 'xG gjennom kampen';

  @override
  String get matchChartMomentum => 'Hvem som dominerte';

  @override
  String get editorDemoteTooltip => 'Flytt til poolen';

  @override
  String editorDemoted(String name) {
    return '$name flyttet til poolen';
  }

  @override
  String get profileTabOverview => 'Oversikt';

  @override
  String get profileTabStats => 'Statistikk';

  @override
  String get profileTabCareer => 'Karriere';

  @override
  String get profileTabVsYou => 'Mot deg';

  @override
  String get playerStatFitness => 'Kondisjon';

  @override
  String get settingsAboutProtected =>
      'Spillet, koden og innholdet er beskyttet av opphavsrett.';

  @override
  String get matchTabPlayer => 'SPILLER';

  @override
  String get matchTabStadium => 'STADION';

  @override
  String get matchTabSummary => 'OPPSUMMERING';

  @override
  String get matchPotmNone => 'Ingen banens beste ble kåret i denne kampen.';

  @override
  String get matchPotmHisMatch => 'Hans kamp';

  @override
  String get matchPotmBeforeMatch => 'Før denne kampen';

  @override
  String get matchStatMinutes => 'Minutter';

  @override
  String get matchStatSaves => 'Redninger';

  @override
  String get matchStatOnTarget => 'På mål';

  @override
  String get matchStadiumCapacity => 'Kapasitet';

  @override
  String get matchStadiumAttendance => 'Tilskuere';

  @override
  String get matchStadiumFull => 'Fyllingsgrad';

  @override
  String matchStadiumHomeOf(String nation) {
    return 'Hjemmebane: $nation';
  }

  @override
  String get matchStadiumNeutral => 'Nøytral bane';

  @override
  String get matchStadiumBuilt => 'Bygget av forbundet ditt';

  @override
  String get matchStadiumEnlarged => 'Utvidet av forbundet ditt';

  @override
  String get matchStadiumWorks => 'Det pågår arbeid på stadion';

  @override
  String get matchStadiumConditions => 'Forhold';

  @override
  String editorWebTitle(String address) {
    return 'Rediger på en datamaskin: $address';
  }

  @override
  String get editorWebAbout =>
      'Eksporter databasen din, åpne den i nettleseren, last den ned igjen og importer den her.';

  @override
  String get editorWebAnother => 'Et annet alternativ';

  @override
  String get editorMerge => 'Slå sammen en annen database';

  @override
  String get editorMergeAbout => 'Hent det noen andre har endret i sin kopi.';

  @override
  String get editorHistory => 'Historikk';

  @override
  String get editorHistoryAbout =>
      'Lagrede versjoner av denne databasen. Gå tilbake til hvilken som helst av dem.';

  @override
  String get editorMergeFromTitle => 'Slå sammen fra';

  @override
  String get editorMergeFromFile => 'En databasefil';

  @override
  String get editorMergeFromFileAbout =>
      'Velg en .fnmdb-fil som noen har delt med deg.';

  @override
  String get editorMergeFromDevice => 'På denne enheten';

  @override
  String get editorMergeComparing => 'Sammenligner databasene';

  @override
  String get editorMergeNothing =>
      'Ingenting å slå sammen. Databasen din har allerede alle endringene fra den andre.';

  @override
  String get editorMergeFailed => 'Databasene kunne ikke slås sammen.';

  @override
  String editorMergeReviewTitle(String name) {
    return 'Endringer fra $name';
  }

  @override
  String editorMergeFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count endringer å gå gjennom',
      one: '1 endring å gå gjennom',
    );
    return '$_temp0';
  }

  @override
  String editorMergeConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count konflikter',
      one: '1 konflikt',
      zero: 'Ingen konflikter',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeConflictsOnly => 'Bare konflikter';

  @override
  String get editorMergeNoConflicts =>
      'Ingen konflikter. Hver endring er ny for databasen din.';

  @override
  String get editorMergeAll => 'Alle';

  @override
  String get editorMergeNone => 'Ingen';

  @override
  String editorMergeTake(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ta $count endringer',
      one: 'Ta 1 endring',
      zero: 'Ta ingen endringer',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeApply => 'Bruk';

  @override
  String get editorMergeYours => 'Din';

  @override
  String get editorMergeTheirs => 'Deres';

  @override
  String get editorMergeNew => 'Ny';

  @override
  String get editorMergeConflict => 'Konflikt';

  @override
  String get editorMergeGameValue => 'Som i spillet';

  @override
  String get editorMergeNotHere => 'Ikke i denne databasen';

  @override
  String editorMergeSquadOf(String nation) {
    return 'Troppen til $nation';
  }

  @override
  String editorMergePoolOf(String nation) {
    return 'Poolen til $nation';
  }

  @override
  String get editorMergePlace => 'Flytter';

  @override
  String editorMergeNames(int first, int sur) {
    return '$first fornavn, $sur etternavn';
  }

  @override
  String editorMerged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count endringer slått sammen',
      one: '1 endring slått sammen',
    );
    return '$_temp0';
  }

  @override
  String get editorMergeTabOverview => 'Oversikt';

  @override
  String get editorMergeTabNames => 'Navn';

  @override
  String get editorMergeTabPress => 'Presse og Y';

  @override
  String get editorMergeEveryChange => 'Alle endringer';

  @override
  String editorMergeNewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nye',
      one: '1 ny',
      zero: 'Ingenting nytt',
    );
    return '$_temp0';
  }

  @override
  String get editorHistorySave => 'Lagre versjon';

  @override
  String get editorHistorySaveTitle => 'Lagre denne versjonen';

  @override
  String get editorHistoryNameHint => 'Navn (valgfritt)';

  @override
  String get editorHistorySaved => 'Versjon lagret';

  @override
  String get editorHistoryEmpty =>
      'Ingen lagrede versjoner ennå. Én lagres før hver sammenslåing og gjenoppretting, og når du kommer tilbake til denne databasen etter en pause.';

  @override
  String get editorHistoryKeep =>
      'De siste 30 automatiske versjonene beholdes. Versjoner du lagrer selv, blir værende til du sletter dem.';

  @override
  String get editorHistorySession => 'Redigeringen startet';

  @override
  String editorHistoryBeforeMerge(String name) {
    return 'Før sammenslåing av $name';
  }

  @override
  String get editorHistoryBeforeRestore => 'Før gjenoppretting';

  @override
  String get editorHistoryManual => 'Lagret versjon';

  @override
  String get editorHistoryAuto => 'Automatisk';

  @override
  String editorHistoryDiff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count forskjeller fra nå',
      one: '1 forskjell fra nå',
      zero: 'Samme som nå',
    );
    return '$_temp0';
  }

  @override
  String get editorHistoryRestore => 'Gjenopprett';

  @override
  String get editorHistoryRestoreTitle => 'Gjenopprette denne versjonen?';

  @override
  String get editorHistoryRestoreBody =>
      'Databasen går tilbake til denne versjonen. Dens nåværende tilstand lagres først i historikken.';

  @override
  String get editorHistoryRestored => 'Versjon gjenopprettet';

  @override
  String get editorHistoryFailed => 'Det virket ikke. Prøv igjen.';

  @override
  String get editorHistoryRenameTitle => 'Gi versjonen nytt navn';

  @override
  String get editorHistoryDeleteTitle => 'Slette denne versjonen?';

  @override
  String get editorHistoryDeleteBody =>
      'Den fjernes fra historikken. Selve databasen endres ikke.';

  @override
  String get financesTabDepartments => 'Avdelinger';

  @override
  String get financesTabFacilities => 'Anlegg';

  @override
  String get financesInvestedSoFar => 'Investert så langt';
}
