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
    return '$count møter';
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
  String get settingsLanguageTitle => 'Språk';

  @override
  String get settingsLanguageBlurb => 'Velg appspråk, eller følg enheten din.';

  @override
  String get settingsLanguageSystem => 'System';

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
    return '$count kampens spiller';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count kamper';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count møter';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code seiere';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings møter · ${wins}S ${draws}U ${losses}T';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}S ${draws}U ${losses}T';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings møter · $record · $edge';
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
  String get hubGoldenBoot => 'Gullskoen';

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
  String get careerManagerNameHint => 'f.eks. Alex Ferguson';

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
    return '$apps kamper';
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
    return 'Vinn $count store troféer (Verdensmesterskapet, kontinentalt mesterskap eller Nations Cup).';
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
  String get achGoldenboot => 'Gullskoen';

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
      'Ingen reklame, ingen mikrotransaksjoner, ikke noe abonnement. Én betaling, og alle fremtidige oppdateringer er dine.';

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
  String get nationsNationalLevel => 'NASJONALT NIVÅ';

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
  String yScorerStar0(String name, String goals) {
    return '$name satte $goals av dem. Ingen andre er i nærheten.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals for $name. Han bærer dette laget.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals i dag. For en spiller.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$name satte $goals forbi dem. Bukk for publikum.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals for $name, og resten var passasjerer.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '$name igjen. $goals. Tenk deg dette laget uten ham.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals fra $name. Én mann burde ikke måtte gjøre så mye.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Ta bort $name, og det er $goals færre og en helt annen ettermiddag.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count på rad. Uansett hva som sies i garderoben, så virker det.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Det er $count strake. Lag snubler ikke inn i rekker som dette.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count på rad og det fortsetter. Selvtilliten synes fra tribunen.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Ubeseiret i $count. Spør hvem som helst som har vært trener: det er det vanskelige.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count på rad. Nyt det mens kampprogrammet er snilt.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count strake, og vi har ikke slått noen av betydning.';
  }

  @override
  String yWinStreak6(String count) {
    return 'En rekke på $count. Spør meg igjen når den blir testet.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count på rad. Alle lag har en slik rekke i seg en gang.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count uten seier nå. Til slutt går unnskyldningene tomme.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Det er $count tap på rad. Dette er ikke et blaff lenger.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count strake tap. Noen må stå til ansvar.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Ingen seier på $count. Du ser det på måten de spiller.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count uten seier og de samme feilene hver uke.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count på rad. Uansett hva som prøves, virker det ikke.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count strake. Dette er en retning, ikke en nedtur.';
  }

  @override
  String yLossStreak7(String count) {
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
  String get awardGoldenBall => 'Gullballen';

  @override
  String get awardGoldenBoot => 'Gullskoen';

  @override
  String get awardGoldenGlove => 'Gullhansken';

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
  String get tourSharedGoldenBall => 'GULLBALLEN';

  @override
  String get tourSharedPlayerOfTournament => 'Turneringens spiller';

  @override
  String get tourSharedGoldenBoot => 'GULLSKOEN';

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
  String get tourSharedGoldenGlove => 'GULLHANSKEN';

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
    return '$nation: $titles titler fra $editions turneringer';
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
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total spillere';
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
    return 'Alder $age · $caps landskamper';
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
      'Verdenspressen vil ha et ord før din første kamp';

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
  String get squadLegendRatingUp => 'Karakteren stiger i år';

  @override
  String get squadLegendRatingDown => 'Karakteren faller i år';

  @override
  String get squadLegendInjured => 'Skadet, utilgjengelig';

  @override
  String get squadLegendSuspended => 'Suspendert, utilgjengelig';

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
    return '⭐ $name vil bytte til $nation!';
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
  String get matchPlayerOfTheMatch => 'KAMPENS SPILLER';

  @override
  String get matchGoalShout => 'MÅL!';

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
  String get tourGoldenGlove => 'GULLHANSKEN';

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
    return '$name har lagt opp på landslaget som $age-åring, med $caps landskamper. Han ba om beskjed om hvor han sto, fikk ingen, og orker ikke vente lenger.';
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
  String get backupTitle => 'LAGRINGER';

  @override
  String get backupBlurb =>
      'Alle lagringer ligger i én fil på denne telefonen, og ingenting sikkerhetskopierer den av seg selv. Eksporter en kopi og ta vare på den utenfor telefonen, i Filer eller iCloud Drive, så en mistet telefon eller en slettet app ikke koster deg en karriere.';

  @override
  String get backupExport => 'EKSPORTER SIKKERHETSKOPI';

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
      'En hel syklus (kvalifisering, ditt kontinentale mesterskap og Verdensmesterskapet) på to lagringer, alle land i verden, ingenting holdt tilbake. Endeløse sykluser og ubegrensede lagringer er én enkelt betaling, én gang, og dekker alle fremtidige oppdateringer.';

  @override
  String get settingsUnlockedTitle => 'Låst opp';

  @override
  String get settingsUnlockedBlurb =>
      'Endeløse sykluser, ubegrensede lagringer og alle fremtidige oppdateringer. Takk.';

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
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Det er $count ganger mot $opponent nå. Noen fører regnskap, og det er dem.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent igjen. $count møter, og vi har fortsatt ikke knekt dem.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Nummer $count mot $opponent. Dette er ikke tilfeldig lenger.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Vi har spilt mot $opponent $count ganger og lært ingenting av noen av dem.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count ganger. De vet nøyaktig hva vi kommer til å gjøre.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Hva enn $opponent har på oss, $count møter inn, har de det fortsatt.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Dette har skjedd $count ganger i det siste. Når er det bare sånn vi er?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count ettermiddager som dette nå. Det er et mønster, ikke flaks.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Vi har sett akkurat denne kampen $count ganger i det siste. Samme manus, samme slutt.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count versjoner av de samme nitti minuttene nå. Ingen fikser det.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count ganger. Ser du ikke mønsteret nå, så ser du ikke etter.';
  }

  @override
  String ySameOldStory5(String count) {
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
  String yDrought0(String name, String count) {
    return '$name har gått $count uten å score og gjør alt annet på banen.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count kamper uten mål for $name. De kommer i bunter, det har de alltid gjort.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count kamper, ingen mål.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count uten mål for $name. Verdt å holde et øye med.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count kamper. Ingen mål. $name kunne ikke truffet en låvevegg.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name har ikke scoret på $count. Spill bokstavelig talt hvem som helst andre.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '$opponent neste. $count møter og det betyr fortsatt alt.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count ganger mot $opponent nå. Kom an.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '$opponent neste. Spilt $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Møte nummer $count med $opponent denne uken.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent igjen. $count av disse og vi har ikke lært noe.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
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
  String injuryCoverBanner(String player) {
    return '$player er skadet. Ta ut hvem som helst utenfor troppen, på hvilken som helst posisjon, eller behold ham og spill videre.';
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
      'Ekvatorial-Guinea, den lavest rangerte av Afrikas Guineaer, i to sykluser';

  @override
  String get campaignGuineasGoal => 'Slå Guinea og Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Tre afrikanske land bærer navnet Guinea, og Ekvatorial-Guinea er rangert lavest av dem. Du har to sykluser på å slå Guinea og Guinea-Bissau minst én gang hver, og så se hvor langt du kan gå i Afrikamesterskapet. Papua Ny-Guinea, den fjerde Guineaen, er allerede booket til en treningskamp.';

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
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Kvalifiserte seg ikke';

  @override
  String get campaignCupOpen => 'Avgjøres senere';
}
