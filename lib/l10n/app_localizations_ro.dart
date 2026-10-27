// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get matchPreviewTitle => 'PREVIZUALIZARE MECI';

  @override
  String get matchKickOff => 'Start';

  @override
  String get matchTactics => 'Tactică';

  @override
  String get matchYourXi => 'PRIMUL 11';

  @override
  String get matchHeadToHead => 'MECIURI DIRECTE';

  @override
  String matchCouldNotLoad(String error) {
    return 'Meciul nu a putut fi încărcat.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Niciun meci programat.';

  @override
  String get matchUnknownNation => 'Necunoscut';

  @override
  String get matchH2hFirstMeeting => 'Prima întâlnire din istorie';

  @override
  String get matchH2hYouLead => 'Conduceți la meciuri directe';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Avantaj $opponent';
  }

  @override
  String get matchH2hEven => 'Egalitate perfectă';

  @override
  String matchH2hMet(int count) {
    return 'Întâlniri: $count';
  }

  @override
  String get matchH2hWon => 'Victorii';

  @override
  String get matchH2hDrawn => 'Egaluri';

  @override
  String get matchH2hLost => 'Înfrângeri';

  @override
  String get matchDossierTitle => 'Raport de scouting';

  @override
  String get matchDossierForm => 'FORMĂ';

  @override
  String get matchDossierNoGames => 'Niciun meci recent';

  @override
  String get matchDossierKeyMen => 'OAMENI-CHEIE';

  @override
  String get matchDossierHowTheyPlay => 'CUM JOACĂ';

  @override
  String matchScoutFormation1(String formation) {
    return 'De obicei se așază într-un $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Sistemul lor obișnuit este $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Tind să joace într-un $formation.';
  }

  @override
  String get matchScoutStrengthPressing => 'Presează sus și vânează mingea.';

  @override
  String get matchScoutStrengthDirect =>
      'Joacă direct și trimit mingea repede în față.';

  @override
  String get matchScoutStrengthPossession =>
      'Păstrează bine mingea și construiesc cu răbdare.';

  @override
  String get matchScoutStrengthCounter =>
      'Stau retrași și ies rapid pe contraatac.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Se apără jos și sunt greu de străpuns.';

  @override
  String get matchScoutStrengthWide => 'Lărgesc terenul și atacă pe flancuri.';

  @override
  String get matchScoutStrengthAttacking =>
      'Le place să preia inițiativa în fața adversarului.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Atacanții lor sunt rapizi și adoră să atace spațiul din spate.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Mijlocul lor pasează foarte bine.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Mijlocașii lor au plămâni să alerge tot meciul.';

  @override
  String get matchScoutStrengthSetPieces => 'Sunt periculoși la faze fixe.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Linia lor defensivă e rapidă și greu de depășit.';

  @override
  String get matchScoutStrengthNone =>
      'Nimic din jocul lor nu iese cu adevărat în evidență.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Linia lor înaltă lasă spațiu în spate pentru o minge peste apărare.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Un pressing înalt le poate deranja construcția lentă.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Aveți răbdare: un bloc jos ca al lor poate fi desfăcut.';

  @override
  String get matchScoutWeakLongBall =>
      'Retrageți linia mai jos și mingile lor lungi nu vor avea unde să ajungă.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Fundașilor lor le lipsește viteza, așa că trimiteți oameni în spatele lor.';

  @override
  String get matchScoutWeakAerial => 'Par nesiguri când se apără la faze fixe.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Mijlocul lor are probleme să iasă cu pase de sub presiune.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Mijlocașilor lor le lipsesc plămânii pentru un pressing susținut.';

  @override
  String get matchScoutWeakBluntAttack => 'Atacanților lor le lipsește viteza.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Împotriva dvs., așteptați-vă să preia inițiativa.';

  @override
  String get matchScoutApproachEven =>
      'Împotriva dvs., așteptați-vă la un meci strâns și echilibrat.';

  @override
  String get matchScoutApproachSitDeep =>
      'Împotriva dvs., așteptați-vă să fie prudenți și să caute contraatacul.';

  @override
  String get matchScoutLeaningAttacking =>
      'Văzută de departe, pare o echipă ofensivă.';

  @override
  String get matchScoutLeaningCautious =>
      'Văzută de departe, pare o echipă prudentă.';

  @override
  String get matchScoutLeaningUnclear =>
      'De departe, e greu de spus cum le place să joace.';

  @override
  String get matchScoutHireHint =>
      'Angajați un scouter-șef ca să aflați cum joacă.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Nu s-a putut continua: $error';
  }

  @override
  String get matchSkipToFullTime => 'Sari la final';

  @override
  String get matchStatShots => 'Șuturi';

  @override
  String get matchStatGoals => 'Goluri';

  @override
  String get matchStatYellowCards => 'Galbene';

  @override
  String get matchStatRedCards => 'Roșii';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'ATC';

  @override
  String get matchSwingDef => 'APĂ';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'CAMPIONATUL MONDIAL $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'TURNEUL FINAL A SOSIT';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'GAZDĂ:  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'GAZDĂ NECONFIRMATĂ';

  @override
  String get matchHalfTime => 'PAUZĂ';

  @override
  String get matchContinue => 'Continuați';

  @override
  String get matchContinuing => 'Se continuă…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Tactică · $used/$max schimbări';
  }

  @override
  String matchTiredCount(int count) {
    return 'OBOSIȚI ×$count';
  }

  @override
  String get matchTacticsLabel => 'TACTICĂ';

  @override
  String get teamOverallOverTime => 'VALOARE GENERALĂ ÎN TIMP';

  @override
  String get teamOverall => 'General';

  @override
  String get teamTalkHeading => 'DISCURS';

  @override
  String get teamTalkPrompt => 'Dați tonul pentru repriza a doua.';

  @override
  String get teamTalkCalmLabel => 'Calm';

  @override
  String get teamTalkCalmBlurb => 'Liniștiți echipa. Un mic plus peste tot.';

  @override
  String get teamTalkEncourageLabel => 'Încurajare';

  @override
  String get teamTalkEncourageBlurb => 'Ieșiți în față și căutați victoria.';

  @override
  String get teamTalkDemandMoreLabel => 'Cereți mai mult';

  @override
  String get teamTalkDemandMoreBlurb => 'Totul pentru gol. Atac dezlănțuit.';

  @override
  String get teamTalkPraiseLabel => 'Strângeți rândurile';

  @override
  String get teamTalkPraiseBlurb => 'Rămâneți compacți și protejați ce aveți.';

  @override
  String get teamTalkBelieveLabel => 'Credeți';

  @override
  String get teamTalkBelieveBlurb =>
      'Aveți încredere în voi. Un plus în ambele careuri.';

  @override
  String get teamTalkFocusLabel => 'Concentrare';

  @override
  String get teamTalkFocusBlurb => 'Concentrare totală. Închideți meciul.';

  @override
  String get teamTalkUrgencyLabel => 'Urgență';

  @override
  String get teamTalkUrgencyBlurb =>
      'Acum sau niciodată. Totul în atac, cu riscul golurilor în spate.';

  @override
  String get teamTalkReassureLabel => 'Fără presiune';

  @override
  String get teamTalkReassureBlurb => 'Calmați emoțiile și păstrați așezarea.';

  @override
  String get commonRetry => 'Reîncercați';

  @override
  String get commonSomethingWentWrong => 'Ceva nu a mers bine';

  @override
  String get commonCrashBox =>
      'Ceva nu a mers bine aici.\nDetaliile sunt în Setări → Diagnosticare.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Lumea nu a putut avansa: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnosticare';

  @override
  String get settingsDiagnosticsBlurb =>
      'Erori înregistrate pe acest dispozitiv. Nu se trimite nimic nicăieri.';

  @override
  String get settingsContactTitle => 'Contact';

  @override
  String get settingsContactCopied => 'Adresă copiată.';

  @override
  String get settingsCommunityTitle => 'Comunitate';

  @override
  String get settingsDiscordSubtitle => 'Intrați în comunitate';

  @override
  String get settingsLinkCopied => 'Link copiat.';

  @override
  String get diagnosticsEmpty => 'Nicio eroare înregistrată. Așa și trebuie.';

  @override
  String get diagnosticsCopy => 'Copiați';

  @override
  String get diagnosticsCopied => 'Jurnal copiat în clipboard.';

  @override
  String get diagnosticsClear => 'Ștergeți';

  @override
  String get navHub => 'Centru';

  @override
  String get navSquad => 'Lot';

  @override
  String get navStandings => 'Clasamente';

  @override
  String get navCareers => 'Cariera mea';

  @override
  String get settingsTitle => 'SETĂRI';

  @override
  String get settingsSoundHapticsTitle => 'Sunet și vibrații';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibrație și un scurt semnal la goluri, la start și la final.';

  @override
  String get settingsLanguageTitle => 'Limbă';

  @override
  String get settingsLanguageBlurb =>
      'Alegeți limba aplicației sau folosiți limba dispozitivului.';

  @override
  String get settingsLanguageSystem => 'Sistem';

  @override
  String get settingsTextSizeTitle => 'Mărime text';

  @override
  String get settingsTextSizeBlurb => 'Măriți textul dacă se citește greu.';

  @override
  String get settingsTextSizeNormal => 'Normal';

  @override
  String get settingsTextSizeLarge => 'Mare';

  @override
  String get settingsTextSizeLarger => 'Foarte mare';

  @override
  String get matchPreviewAllMeetings => 'Toate întâlnirile';

  @override
  String get recordsMeetings => 'ÎNTÂLNIRI';

  @override
  String get recordsLegends => 'LEGENDE';

  @override
  String get recordsAllTimeXi => 'ECHIPA ISTORIEI';

  @override
  String get recordsHallOfFame => 'GALERIA FAIMEI';

  @override
  String get recordsAllTimeWorld => 'ISTORIA MONDIALĂ';

  @override
  String get recordsAllTimeTopScorers => 'GOLGHETERII ALL-TIME';

  @override
  String get recordsMostCapped => 'TOP SELECȚII';

  @override
  String get recordsMostWcStarts => 'TITULARIZĂRI LA CM';

  @override
  String get recordsMostTournaments => 'CELE MAI MULTE TURNEE JUCATE';

  @override
  String get recordsRecordBook => 'CARTEA RECORDURILOR';

  @override
  String get recordsHeadToHead => 'MECIURI DIRECTE';

  @override
  String get recordsFiercestRival => 'MARELE RIVAL';

  @override
  String get recordsMostCaps => 'TOP SELECȚII';

  @override
  String get recordsTopScorers => 'GOLGHETERI';

  @override
  String get recordsMostAssists => 'TOP PASE DECISIVE';

  @override
  String get recordsYourRecord => 'BILANȚUL DVS.';

  @override
  String get callUpHome => 'ACASĂ';

  @override
  String get callUpAway => 'DEPLASARE';

  @override
  String get recordsHome => 'GAZDE';

  @override
  String get recordsAway => 'OASPEȚI';

  @override
  String get recordsActive => 'ACTIV';

  @override
  String get recordsStillActive => 'Încă activ';

  @override
  String get recordsAvg => 'medie';

  @override
  String get recordsSelect => 'Alegeți';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Egaluri';

  @override
  String get recordsGoalsLabel => 'Goluri';

  @override
  String get recordsBestFinish => 'Cel mai bun loc';

  @override
  String get recordsNoFinalsYet => 'Nicio prezență la turneul final';

  @override
  String get recordsLongestUnbeaten => 'Serie fără înfrângere';

  @override
  String get recordsBiggestWin => 'Cea mai mare victorie';

  @override
  String get recordsSeeAllMeetings => 'Vedeți toate întâlnirile';

  @override
  String get recordsSaveNotFound => 'Salvarea nu a fost găsită.';

  @override
  String get recordsNoMatches => 'Niciun rezultat.';

  @override
  String get recordsSearchPlayerOrNation => 'Căutați jucător sau națiune';

  @override
  String get recordsSearchNation => 'Căutați națiune';

  @override
  String get recordsPickTwoDifferent => 'Alegeți două națiuni diferite.';

  @override
  String get recordsPlayToBuildRecord =>
      'Jucați câteva meciuri și bilanțul cu fiecare adversar va apărea aici.';

  @override
  String get recordsTapOpponent =>
      'Atingeți un adversar pentru detalii complete.';

  @override
  String get recordsEdgeUpperHand => 'Aveți avantajul';

  @override
  String get recordsEdgeTheirNumber => 'V-au luat măsura';

  @override
  String get recordsEdgeEven => 'Egalitate perfectă';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Golgheteri și recordmeni la selecții, toate națiunile';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Comparați bilanțul istoric al oricăror două națiuni';

  @override
  String get recordsLegendsSubtitle => 'Echipa istoriei și galeria faimei';

  @override
  String get recordsUnitGoals => 'goluri';

  @override
  String get recordsUnitCaps => 'selecții';

  @override
  String get recordsUnitStarts => 'titularizări';

  @override
  String get recordsUnitCups => 'turnee';

  @override
  String get recordsUnitAssists => 'pase decisive';

  @override
  String recordsCapsCount(int count) {
    return 'Selecții: $count';
  }

  @override
  String recordsGoalsCount(int count) {
    return 'Goluri: $count';
  }

  @override
  String recordsAssistsCount(int count) {
    return 'Pase decisive: $count';
  }

  @override
  String recordsMotmCount(int count) {
    return 'Omul meciului: $count';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count meciuri';
  }

  @override
  String recordsMeetingsCount(int count) {
    return 'Întâlniri: $count';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Victorii $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings întâlniri · ${wins}V ${draws}E $lossesÎ';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}V ${draws}E $lossesÎ';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings întâlniri · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a și $b nu s-au întâlnit niciodată în această salvare.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Eliminat(i): $names. Nu pot fi înlocuiți, așa că jucați în inferioritate.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Necesari $required disponibili ($have apți)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Absent $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Indisponibil pentru toată convocarea';

  @override
  String get rankingCentreOnMe => 'Centrați pe națiunea mea';

  @override
  String get recordsAfterExtraTime => 'd.p.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b d.l.d.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played jucate · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga cu $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Nu s-a putut încărca.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Legendele nu au putut fi încărcate.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Recordurile nu au putut fi încărcate.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Națiunile nu au putut fi încărcate.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Bilanțul dvs. nu a putut fi încărcat.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Bilanțul nu a putut fi încărcat.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Încă nu există legende. Jucați câteva campanii și marii jucători ai echipei $nation vor apărea aici.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Cea mai bună echipă pe care $nation ar putea-o alinia vreodată.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Lumea nu are încă istorie. Jucați câteva campanii și marii jucători ai tuturor timpurilor vor apărea aici.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Jucați câteva meciuri ca să începeți să scrieți istoria echipei $nation.';
  }

  @override
  String get tacticsLineGk => 'POR';

  @override
  String get tacticsLineDef => 'FUN';

  @override
  String get tacticsLineMid => 'MIJ';

  @override
  String get tacticsLineFwd => 'ATA';

  @override
  String get tacticsGoalkeepers => 'PORTARI';

  @override
  String get tacticsDefenders => 'FUNDAȘI';

  @override
  String get tacticsMidfielders => 'MIJLOCAȘI';

  @override
  String get tacticsForwards => 'ATACANȚI';

  @override
  String get tacticsCallUpsTitle => 'CONVOCĂRI';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Alegeți cel puțin $min jucători.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Lotul nu a putut fi încărcat.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Niciun lot.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'LOT · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Max $max';
  }

  @override
  String get tacticsBestQuality => 'Cei mai buni';

  @override
  String get tacticsPreviousSquad => 'Lotul anterior';

  @override
  String get tacticsSquadLockedBack => 'Înapoi (lot blocat)';

  @override
  String get tacticsConfirmSquad => 'Confirmați lotul';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Lot complet (max. $max)';
  }

  @override
  String get tacticsSquadLocked => 'LOT BLOCAT';

  @override
  String get tacticsNominationOpen => 'CONVOCĂRI DESCHISE. ALEGEȚI LOTUL';

  @override
  String get tacticsSquadFixedBlurb =>
      'Acest lot este fixat pentru meciurile de mai jos. Alegeți din nou înainte de următoarea fereastră de convocări.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Acest lot va juca meciurile de mai jos.';

  @override
  String get tacticsUnknown => 'Necunoscut';

  @override
  String tacticsAgeValue(int age, String value) {
    return '$age ani · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Epuizat';

  @override
  String get tacticsFatigueTired => 'Obosit';

  @override
  String get tacticsFatigueMatchLegs => 'Ritm de joc';

  @override
  String tacticsTooManySubs(int max) {
    return 'Prea multe schimbări (max. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TACTICĂ · $minute\'';
  }

  @override
  String get tacticsApply => 'APLICAȚI';

  @override
  String get tacticsTabLineupSubs => 'PRIMUL 11 ȘI REZERVE';

  @override
  String get tacticsTabTactics => 'TACTICĂ';

  @override
  String get squadLineKeepers => 'PORTARI';

  @override
  String get squadLineDefenders => 'APĂRARE';

  @override
  String get squadLineMidfielders => 'MIJLOC';

  @override
  String get squadLineForwards => 'ATAC';

  @override
  String get squadStatXiRating => 'Valoare 11';

  @override
  String get squadStatAvgAge => 'Vârstă medie';

  @override
  String get squadStatSize => 'Lot';

  @override
  String get squadStatUnavailable => 'Indisponibili';

  @override
  String get squadDepthTitle => 'ADÂNCIME PE LINII';

  @override
  String squadAgeShort(int age) {
    return '$age ani';
  }

  @override
  String get tacticsTabOtherPositions => 'ALTE POSTURI';

  @override
  String get tacticsOutOfPositionNote => 'Nu e postul lui';

  @override
  String get tacticsNobodyElse => 'Nu mai e nimeni de încercat aici.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Alegeți cine iese, iar restul rezervelor apar aici, cu valoarea pe care ar avea-o pe acest post.';

  @override
  String get tacticsTabSuitable => 'POTRIVIȚI';

  @override
  String get tacticsTabOnPitch => 'PE TEREN';

  @override
  String tacticsSectionSuitable(int count) {
    return 'POTRIVIȚI · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Nicio rezervă nu se potrivește natural pe acest post, așa că iată toată banca.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'PE TEREN · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'DISPONIBILI · $count';
  }

  @override
  String get tacticsRowStarted => 'Titular';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Intrat în min. $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Intrat';

  @override
  String get tacticsEnergyLabel => 'ENERGIE';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Atingeți un înlocuitor pentru $name sau atingeți-l din nou ca să anulați.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Un cartonaș roșu v-a costat acest post. Trageți un coechipier aici ca să mutați golul din așezare.';

  @override
  String get tacticsSentOffShort => 'ELIMINAT';

  @override
  String get tacticsFullBackLeft => 'Fundaș stânga';

  @override
  String get tacticsFullBackRight => 'Fundaș dreapta';

  @override
  String get tacticsFullBackUp => 'Urcă în atac';

  @override
  String get tacticsFullBackDown => 'Rămâne în spate';

  @override
  String get tacticsFullBackOff => 'Fără instrucțiune';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: urcă în atac. Puțin mai mult atac, puțin mai mult risc.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: rămâne în spate. Puțin mai sigur, puțin mai puțin atac.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: fără instrucțiune, joacă după planul echipei.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, săgeată: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'SCHIMBĂRI · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Atingeți un jucător de pe teren ca să-l scoateți sau țineți apăsat și trageți o rezervă peste el.';

  @override
  String get tacticsNoSubs => 'Nicio rezervă disponibilă.';

  @override
  String get tacticsChooseShape => 'ALEGEȚI SISTEMUL';

  @override
  String get tacticsFormation => 'SISTEM';

  @override
  String get tacticsInstructions => 'INSTRUCȚIUNI';

  @override
  String get tacticsDrilling => 'AUTOMATISME';

  @override
  String get tacticsDrillingUnplayed => 'NEJUCAT';

  @override
  String get tacticsDrillingNew => 'NOU';

  @override
  String get tacticsDrillingSettling => 'ÎN ASIMILARE';

  @override
  String get tacticsDrillingDrilled => 'ASIMILAT';

  @override
  String get tacticsInstrMentality => 'Mentalitate';

  @override
  String get tacticsInstrDefensive => 'Defensivă';

  @override
  String get tacticsInstrAttacking => 'Ofensivă';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Bloc jos';

  @override
  String get tacticsInstrHighPress => 'Pressing înalt';

  @override
  String get tacticsInstrTempo => 'Ritm';

  @override
  String get tacticsInstrPatient => 'Răbdător';

  @override
  String get tacticsInstrFast => 'Rapid';

  @override
  String get tacticsInstrWidth => 'Lățime';

  @override
  String get tacticsInstrNarrow => 'Îngust';

  @override
  String get tacticsInstrWide => 'Larg';

  @override
  String get tacticsInstrDefLine => 'Linie def.';

  @override
  String get tacticsInstrDefensiveLine => 'Linia defensivă';

  @override
  String get tacticsInstrDeep => 'Jos';

  @override
  String get tacticsInstrHigh => 'Sus';

  @override
  String get tacticsInstrDirectness => 'Joc direct';

  @override
  String get tacticsInstrPossession => 'Posesie';

  @override
  String get tacticsInstrDirect => 'Direct';

  @override
  String get tacticsPickGoalkeeper => 'ALEGEȚI PORTARUL';

  @override
  String get tacticsPickLeftBack => 'ALEGEȚI FUNDAȘUL STÂNGA';

  @override
  String get tacticsPickCentreBack => 'ALEGEȚI FUNDAȘUL CENTRAL';

  @override
  String get tacticsPickRightBack => 'ALEGEȚI FUNDAȘUL DREAPTA';

  @override
  String get tacticsPickDefensiveMid => 'ALEGEȚI MIJLOCAȘUL DEFENSIV';

  @override
  String get tacticsPickCentralMid => 'ALEGEȚI MIJLOCAȘUL CENTRAL';

  @override
  String get tacticsPickAttackingMid => 'ALEGEȚI MIJLOCAȘUL OFENSIV';

  @override
  String get tacticsPickLeftMid => 'ALEGEȚI MIJLOCAȘUL STÂNGA';

  @override
  String get tacticsPickRightMid => 'ALEGEȚI MIJLOCAȘUL DREAPTA';

  @override
  String get tacticsPickLeftWing => 'ALEGEȚI EXTREMA STÂNGA';

  @override
  String get tacticsPickRightWing => 'ALEGEȚI EXTREMA DREAPTA';

  @override
  String get tacticsPickStriker => 'ALEGEȚI ATACANTUL';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · nu e postul lui';
  }

  @override
  String tacticsAgeOnly(int age) {
    return '$age ani';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · $age ani';
  }

  @override
  String get tacticsOn => 'PE TEREN';

  @override
  String get tacticsSquad => 'LOT';

  @override
  String get tacticsTabLineup => 'PRIMUL 11';

  @override
  String get tacticsTabInstructions => 'INSTRUCȚIUNI';

  @override
  String get tacticsTabRoles => 'ROLURI';

  @override
  String get tacticsTabSetPieces => 'FAZE FIXE';

  @override
  String get tacticsTabRolesSetPieces => 'ROLURI ȘI FAZE FIXE';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Dați fiecărui titular un rol. Atingeți insigna de penalty (⚽) sau lovitură liberă (▲) ca să alegeți executantul.';

  @override
  String get tacticsTooltipCallUps => 'Convocări';

  @override
  String get tacticsTooltipPresets => 'Tactici salvate';

  @override
  String get tacticsTooltipInstructions => 'Instrucțiuni';

  @override
  String get tacticsNoTacticSet => 'Nicio tactică setată.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ÎNLOCUIȚI $count DE TITULARI',
      few: 'ÎNLOCUIȚI $count TITULARI',
      one: 'ÎNLOCUIȚI $count TITULAR',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Indisponibil';

  @override
  String get tacticsTapSpotReplace =>
      'Atingeți postul lui pe teren ca să alegeți un înlocuitor.';

  @override
  String get tacticsTapOrDrag =>
      'Atingeți un jucător ca să-l schimbați sau țineți apăsat și trageți ca să-l mutați.';

  @override
  String get tacticsPlayerRoles => 'ROLURILE JUCĂTORILOR';

  @override
  String get tacticsRolesBlurb =>
      'Dați-i unui jucător o sarcină: vârf de careu, playmaker, pivot. Influențează cine marchează și cine creează.';

  @override
  String get tacticsSetPieceTakers => 'EXECUTANȚI FAZE FIXE';

  @override
  String get tacticsSetPieceBlurb =>
      'Cine bate penalty-urile și fazele fixe, sau lăsați jucătorul cel mai potrivit.';

  @override
  String get tacticsTakerAuto => 'Automat';

  @override
  String get tacticsTakerQuickPick => 'Cei mai buni executanți';

  @override
  String get tacticsPenalties => 'Penalty-uri';

  @override
  String get tacticsCornersFreeKicks => 'Cornere și lovituri libere';

  @override
  String get tacticsSkillFin => 'FIN';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROL · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'EXECUTANT PENALTY';

  @override
  String get tacticsCornerFreeKickTaker =>
      'EXECUTANT CORNERE ȘI LOVITURI LIBERE';

  @override
  String get tacticsAutomatic => 'Automat';

  @override
  String get tacticsLetBestSuited =>
      'Lăsați jucătorul cel mai potrivit să execute.';

  @override
  String get tacticsInXi => 'ÎN 11';

  @override
  String get tacticsTeamInstructions => 'INSTRUCȚIUNI DE ECHIPĂ';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Stabiliți cum joacă echipa. Fiecare reglaj influențează toată echipa.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Salvat „$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Aplicat „$name”';
  }

  @override
  String get tacticsTacticPresets => 'TACTICI SALVATE';

  @override
  String get tacticsPresetsBlurb =>
      'Salvați acest sistem ca stil reutilizabil sau aplicați unul salvat anterior.';

  @override
  String get tacticsSaveCurrentTactic => 'Salvați tactica actuală';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Tacticile salvate nu au putut fi încărcate.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Încă nicio tactică salvată. Atingeți „Salvați tactica actuală” ca să păstrați această configurație ca stil reutilizabil.';

  @override
  String get tacticsNameThisTactic => 'Denumiți tactica';

  @override
  String get tacticsNameHint => 'ex. Pressing înalt 4-3-3';

  @override
  String get tacticsCancel => 'Anulați';

  @override
  String get tacticsSave => 'Salvați';

  @override
  String get tacticsTapToAssign => 'Atingeți pentru a atribui';

  @override
  String get tacticsHoldDragSub =>
      'Țineți apăsat pe o rezervă, apoi trageți-o peste un jucător ca s-o introduceți.';

  @override
  String get hubContinue => 'Continuați';

  @override
  String get hubBrackets => 'Tablouri';

  @override
  String hubCouldNotLoad(String error) {
    return 'Nu s-a putut încărca.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Finanțele nu au putut fi încărcate.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Salvarea nu a putut fi încărcată.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Salvarea nu a fost găsită.';

  @override
  String get hubUnknown => 'Necunoscut';

  @override
  String hubWorldChampionsYear(int year) {
    return 'CAMPIOANA MONDIALĂ $year';
  }

  @override
  String get hubCycleComplete => 'Ciclul s-a încheiat.';

  @override
  String get hubYourJob => 'POSTUL DVS.';

  @override
  String get hubStayProject => 'Rămâneți și continuați proiectul';

  @override
  String get hubChooseNextJob => 'ALEGEȚI URMĂTORUL POST';

  @override
  String get hubOffersOnTable => 'OFERTE PE MASĂ';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · locul $position mondial';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Continuați cu $nation';
  }

  @override
  String get hubYourNation => 'națiunea dvs.';

  @override
  String get hubTakeTheJob => 'Acceptați postul';

  @override
  String get hubFederationFinances => 'FINANȚELE FEDERAȚIEI';

  @override
  String get hubBudgetIntro =>
      'Prima sarcină din ciclul următor este să stabiliți bugetul federației și să-l împărțiți pe departamente.';

  @override
  String get hubStarting => 'Se pornește…';

  @override
  String get hubBeginNextCycle => 'Începeți ciclul următor';

  @override
  String get hubContinueCareer => 'Continuați cariera';

  @override
  String get hubBackToSaves => 'Înapoi la salvări';

  @override
  String get hubOpeningBalance => 'Sold inițial';

  @override
  String get hubCentralFunding => 'Finanțare centrală';

  @override
  String get hubPrizeMoney => 'Premii';

  @override
  String get hubCommercialReturn => 'Venituri comerciale';

  @override
  String get hubAvailableToInvest => 'Disponibil pentru investiții';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputație: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Erou național';

  @override
  String get hubFinal => 'Finală';

  @override
  String get hubStageRoundOf32 => 'Șaisprezecimi';

  @override
  String get hubStageThirdPlace => 'Finala mică';

  @override
  String get hubEventAdvanceWorld => 'Avansați lumea';

  @override
  String hubEventStartCycle(int year) {
    return 'Începeți ciclul $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Campioana mondială: $nation';
  }

  @override
  String get hubEventSetBudget => 'Stabiliți bugetul federației';

  @override
  String get hubEventSetBudgetSub =>
      'Împărțiți fondurile ciclului înainte de începerea sezonului';

  @override
  String get hubEventNaturalization => 'Analizați oferta de naturalizare';

  @override
  String get hubEventNaturalizationSub =>
      'Un jucător străin vrea să joace pentru dvs.';

  @override
  String get hubEventCampaignVerdict => 'Campanie decisă: vedeți verdictul';

  @override
  String get hubEventCampaignComplete => 'Campanie încheiată';

  @override
  String get hubEventIntercontinentalPlayoff => 'Barajul intercontinental';

  @override
  String get hubEventWatchWcDraw =>
      'Urmăriți tragerea la sorți a Campionatului Mondial';

  @override
  String get hubEventWorldCupHere => 'A sosit Campionatul Mondial';

  @override
  String get hubEventWatchFinalsDraw =>
      'Urmăriți tragerea la sorți a turneului final';

  @override
  String get hubEventFinalsHere => 'A sosit turneul final';

  @override
  String get hubEventPlayWcRound =>
      'Jucați următoarea rundă a Campionatului Mondial';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Jucați următorul meci: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Jucați următorul meci din Cupa Națiunilor';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Urmăriți tragerea la sorți a Cupei Națiunilor';

  @override
  String get hubEventWatchHostSelection => 'Urmăriți alegerea gazdei';

  @override
  String get hubEventWatchQualifyingDraw =>
      'Urmăriți tragerea la sorți a preliminariilor';

  @override
  String get hubEventWatchWcHostSelection =>
      'Urmăriți alegerea gazdei Campionatului Mondial';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Urmăriți tragerea la sorți a preliminariilor Campionatului Mondial';

  @override
  String get hubEventArrangeFriendlies => 'Programați amicale';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Nu ați completat încă cele $count de ferestre libere pentru amicale',
      few: 'Nu ați completat încă cele $count ferestre libere pentru amicale',
      one: 'Nu ați completat încă fereastra liberă pentru amicale',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Refaceți primul 11';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count de jucători din primul 11 lipsesc (suspendați sau accidentați). Alegeți-le înlocuitorii',
      few:
          '$count jucători din primul 11 lipsesc (suspendați sau accidentați). Alegeți-le înlocuitorii',
      one:
          '1 jucător din primul 11 lipsește (suspendat sau accidentat). Alegeți-i înlocuitorul',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Primul 11 e incomplet. Completați posturile libere',
      one: 'Primul 11 e incomplet. Completați postul liber',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Jucați cu $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'turneul final continental';

  @override
  String get hubCallUpFriendlies => 'Alegeți lotul pentru amicale';

  @override
  String get hubCallUpRequalify => 'Alegeți din nou lotul pentru preliminarii';

  @override
  String get hubCallUpWorldCup => 'Alegeți lotul pentru Campionatul Mondial';

  @override
  String get hubCallUpFinals => 'Alegeți lotul pentru turneul final';

  @override
  String get hubCallUpNationsCup => 'Alegeți lotul pentru Cupa Națiunilor';

  @override
  String get hubCallUpQualifying => 'Alegeți lotul pentru preliminarii';

  @override
  String get hubCallUpGeneric => 'Alegeți lotul';

  @override
  String get hubHost => 'Gazdă';

  @override
  String get hubGoldenBoot => 'Gheata de Aur';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · goluri: $goals';
  }

  @override
  String get hubPens => '(d.l.d.)';

  @override
  String get hubNationalHub => 'CENTRUL NAȚIONAL';

  @override
  String get hubMessages => 'Mesaje';

  @override
  String get hubWorldChampions => 'CAMPIOANA MONDIALĂ';

  @override
  String get hubViewBracket => 'Vedeți tabloul ›';

  @override
  String get hubBoardDelighted => 'Încântată';

  @override
  String get hubBoardPleased => 'Mulțumită';

  @override
  String get hubBoardExpectingMore => 'Așteaptă mai mult';

  @override
  String get hubBoardConcerned => 'Îngrijorată';

  @override
  String get hubBoardJobAtRisk => 'Post în pericol';

  @override
  String get hubBoard => 'FEDERAȚIA';

  @override
  String hubBoardObjective(String label) {
    return 'Obiectivul federației: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'ATINS · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'RATAT · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Nu mai sunt meciuri în acest ciclu.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Clasamentul mondial';

  @override
  String get hubSquadStatus => 'STAREA LOTULUI';

  @override
  String hubPlayers(int count) {
    return 'Jucători: $count';
  }

  @override
  String get hubAvgRating => 'Valoare medie';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Gestionați echipa';

  @override
  String get hubGroupsToBeDrawn =>
      'Grupele nu au fost trase la sorți. Urmăriți tragerea ca să le aflați.';

  @override
  String hubGroupName(String name) {
    return 'GRUPA $name';
  }

  @override
  String get hubTblTeam => 'ECHIPA';

  @override
  String get hubTblP => 'M';

  @override
  String get hubTblGd => 'GV';

  @override
  String get hubTblPts => 'PCT';

  @override
  String get homeSettings => 'Setări';

  @override
  String get homeLeadTheNation => 'CONDUCEȚI NAȚIUNEA';

  @override
  String get homeYourNation => 'națiunea dvs.';

  @override
  String get homeNewGame => 'Joc nou';

  @override
  String get homeAllSaves => 'Toate salvările';

  @override
  String get homeLoadGame => 'Încărcați jocul';

  @override
  String get homeContinue => 'CONTINUAȚI';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Drumul spre Campionatul Mondial $year';
  }

  @override
  String get careerManageSaves => 'Gestionați salvările';

  @override
  String get careerNewGameTitle => 'JOC NOU';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Națiunea nu a putut fi încărcată.\n$error';
  }

  @override
  String get careerNationNotFound => 'Națiunea nu a fost găsită.';

  @override
  String careerWorldRankNum(int rank) {
    return 'LOCUL #$rank MONDIAL';
  }

  @override
  String get careerManagerName => 'Numele selecționerului';

  @override
  String get careerManagerNameHint => 'ex. Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Cariera dvs. începe în septembrie 2026, pe drumul spre Campionatul Mondial 2030.';

  @override
  String get careerFreeCycleNote =>
      'Gratuit pentru un ciclu complet de patru ani: preliminariile, campionatul continental și Campionatul Mondial, pe două salvări. După aceea, o singură plată deblochează cicluri nelimitate.';

  @override
  String get careerStartCareer => 'Începeți cariera';

  @override
  String get careersTitle => 'CARIERE';

  @override
  String get careerManagerCareer => 'Cariera de selecționer';

  @override
  String get careerManagerCareerSubtitle =>
      'Fiecare ciclu condus și bilanțul general';

  @override
  String get careerSummaryTitle => 'Rezumatul carierei';

  @override
  String get careerSummarySubtitle =>
      'Vitrina cu trofee și bilanțul de selecționer';

  @override
  String get careerAchievements => 'Realizări';

  @override
  String get careerAchievementsSubtitle =>
      'Repere, titluri și mulțumirea federației';

  @override
  String get careerChallenges => 'Provocări';

  @override
  String get careerChallengesSubtitle => 'Teste dure, pe toată durata carierei';

  @override
  String get careerTeamRecords => 'Recordurile echipei';

  @override
  String get careerTeamRecordsSubtitle =>
      'Golgheterii și recordmenii la selecții';

  @override
  String get careerMyMatches => 'Meciurile mele';

  @override
  String get careerMyMatchesSubtitle =>
      'Toate rezultatele și meciurile viitoare';

  @override
  String get careerTitle => 'CARIERĂ';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Cariera nu a putut fi încărcată.\n$error';
  }

  @override
  String get careerNoCareer => 'Nicio carieră.';

  @override
  String get careerTrophyCabinet => 'VITRINA CU TROFEE';

  @override
  String get careerTournamentHistory => 'ISTORICUL TURNEELOR';

  @override
  String get careerNoTournamentsYet => 'Niciun turneu încheiat încă.';

  @override
  String get careerTeamFallback => 'Echipă';

  @override
  String careerWorldNum(int rank) {
    return 'MONDIAL #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PCT';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SEZONUL $season';
  }

  @override
  String get careerStatPlayedShort => 'M';

  @override
  String get careerStatsHeading => 'ÎN CIFRE';

  @override
  String get careerStatsWinRate => 'Procent victorii';

  @override
  String get careerStatsGoalsFor => 'Goluri marcate';

  @override
  String get careerStatsGoalsAgainst => 'Goluri primite';

  @override
  String get careerStatsGoalDiff => 'Golaveraj';

  @override
  String get careerStatsCleanSheets => 'Fără gol primit';

  @override
  String get careerStatsBiggestWin => 'Cea mai mare victorie';

  @override
  String get careerStatsWinStreak => 'Serie de victorii';

  @override
  String get careerStatsUnbeaten => 'Serie fără înfrângere';

  @override
  String get careerStatsShootouts => 'Departajări';

  @override
  String get careerStatsHatTricks => 'Hat-trickuri';

  @override
  String get careerStatsMotms => 'Omul meciului';

  @override
  String get careerStatsBestRating => 'Cea mai bună notă';

  @override
  String get careerStatWonShort => 'V';

  @override
  String get careerStatDrawnShort => 'E';

  @override
  String get careerStatLostShort => 'Î';

  @override
  String get careerStatGoalsForShort => 'GM';

  @override
  String get careerStatGoalsAgainstShort => 'GP';

  @override
  String get careerStatGoalDiffShort => 'GV';

  @override
  String get careerNoSilverware =>
      'Niciun trofeu încă. Mergeți și câștigați unul.';

  @override
  String get careerMedalGold => 'AUR';

  @override
  String get careerMedalSilver => 'ARGINT';

  @override
  String get careerMedalBronze => 'BRONZ';

  @override
  String careerWinnersName(String name) {
    return 'Câștigătoare: $name';
  }

  @override
  String get careerSavesTitle => 'SALVĂRI';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Salvările nu au putut fi încărcate.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'SLOTURI  $used/$limit';
  }

  @override
  String get careerThisSave => 'această salvare';

  @override
  String get careerSlotsFull => 'Sloturi pline';

  @override
  String careerSlotsUsed(int used) {
    return 'SLOTURI  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Deblocați mai multe salvări';

  @override
  String get careerSlotsKeepNote =>
      'Toate salvările existente rămân jucabile. Doar una nouă necesită deblocarea.';

  @override
  String get careerNewGame => 'Joc nou';

  @override
  String get careerDeleteSaveTitle => 'Ștergeți salvarea?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Aceasta șterge definitiv cariera $label.';
  }

  @override
  String get careerCancel => 'Anulați';

  @override
  String get careerDelete => 'Ștergeți';

  @override
  String get careerNoSavesYet =>
      'Nicio salvare încă.\nÎncepeți un joc nou ca să conduceți o națiune.';

  @override
  String get careerUnknownNation => 'Necunoscut';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Jucat ultima dată $when';
  }

  @override
  String get careerJustNow => 'chiar acum';

  @override
  String get careerYesterday => 'ieri';

  @override
  String careerMinutesAgo(int n) {
    return 'acum $n min';
  }

  @override
  String careerHoursAgo(int n) {
    return 'acum $n h';
  }

  @override
  String careerDaysAgo(int n) {
    return 'acum $n z';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Drumul spre Campionatul Mondial $year';
  }

  @override
  String get careerManagerCareerTitle => 'CARIERA DE SELECȚIONER';

  @override
  String careerCouldNotLoad(String error) {
    return 'Nu s-a putut încărca.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CICLU CU CICLU';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles de cicluri',
      few: '$cycles cicluri',
      one: '1 ciclu',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations de națiuni conduse',
      few: '$nations națiuni conduse',
      one: '1 națiune condusă',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Titluri';

  @override
  String get careerStatPlayed => 'Jucate';

  @override
  String get careerStatWon => 'Victorii';

  @override
  String get careerStatDrawn => 'Egaluri';

  @override
  String get careerStatLost => 'Înfrângeri';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Goluri $goalsFor–$goalsAgainst  ($gd)  ·  Victorii $winRate%';
  }

  @override
  String get careerRecordResults => 'REZULTATE RECORD';

  @override
  String get careerBestWin => 'Cea mai mare victorie';

  @override
  String get careerWorstDefeat => 'Cea mai grea înfrângere';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'cu $opponent · $date';
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
    return '${won}V ${drawn}E $lostÎ  ·  GM $goalsFor GP $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Campionatul Mondial';

  @override
  String get careerContinentalLabel => 'Continental';

  @override
  String get messagesTitle => 'MESAJE';

  @override
  String get messagesNoMessagesYet => 'Niciun mesaj încă.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Mesajele nu au putut fi încărcate.\n$error';
  }

  @override
  String get messagesDone => 'Gata';

  @override
  String get messagesNext => 'Următorul';

  @override
  String get rankingWorldRanking => 'CLASAMENTUL MONDIAL';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Clasamentul nu a putut fi încărcat.\n$error';
  }

  @override
  String get rankingNoRanking => 'Niciun clasament.';

  @override
  String get rankingAll => 'TOATE';

  @override
  String get rankingYourTeam => 'ECHIPA DVS.';

  @override
  String get rankingYourRankingOverTime => 'EVOLUȚIA ÎN CLASAMENT';

  @override
  String rankingNowRank(int rank) {
    return 'acum #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'cel mai bun #$best · cel mai slab #$worst';
  }

  @override
  String get friendliesTitle => 'AMICALE';

  @override
  String friendliesLoadError(String error) {
    return 'Amicalele nu au putut fi încărcate.\n$error';
  }

  @override
  String get friendliesContinue => 'Continuați';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cele $count de ferestre libere',
      few: 'cele $count ferestre libere',
      one: 'fereastra liberă',
    );
    return 'Programați meciuri de pregătire pentru $_temp0 dinaintea următorului meci oficial. Atingeți un adversar sau lăsați liber.';
  }

  @override
  String get friendliesFree => 'Liber';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count DE GOLURI',
      few: '$count GOLURI',
      one: '1 GOL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'GOLURI';

  @override
  String get matchGoalsNone => 'Niciun gol';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'FAZĂ';

  @override
  String matchGoalAssist(String name) {
    return 'pasă $name';
  }

  @override
  String get friendliesHome => 'ACASĂ';

  @override
  String get friendliesAway => 'DEPLASARE';

  @override
  String get friendliesNoneThisWindow => 'Fără amicale în această fereastră';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Confirmați $count de amicale',
      few: 'Confirmați $count amicale',
      one: 'Confirmați 1 amical',
    );
    return '$_temp0';
  }

  @override
  String get friendliesMonthJan => 'ian.';

  @override
  String get friendliesMonthFeb => 'feb.';

  @override
  String get friendliesMonthMar => 'mar.';

  @override
  String get friendliesMonthApr => 'apr.';

  @override
  String get friendliesMonthMay => 'mai';

  @override
  String get friendliesMonthJun => 'iun.';

  @override
  String get friendliesMonthJul => 'iul.';

  @override
  String get friendliesMonthAug => 'aug.';

  @override
  String get friendliesMonthSep => 'sept.';

  @override
  String get friendliesMonthOct => 'oct.';

  @override
  String get friendliesMonthNov => 'nov.';

  @override
  String get friendliesMonthDec => 'dec.';

  @override
  String get resultsMyMatches => 'MECIURILE MELE';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Rezultatele nu au putut fi încărcate.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Niciun meci.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'PRELIMINARII';

  @override
  String get resultsStageFriendly => 'AMICAL';

  @override
  String get resultsStageGroupStage => 'FAZA GRUPELOR';

  @override
  String get resultsStageSemiFinal => 'SEMIFINALĂ';

  @override
  String get resultsStageFinal => 'FINALĂ';

  @override
  String get resultsStageContinentalClash => 'DUELUL CONTINENTELOR';

  @override
  String get resultsStageFinalsGroup => 'GRUPĂ TURNEU FINAL';

  @override
  String get resultsStageRoundOf32 => 'ȘAISPREZECIMI';

  @override
  String get resultsStageRoundOf16 => 'OPTIMI';

  @override
  String get resultsStageQuarterFinal => 'SFERTURI';

  @override
  String get resultsStageThirdPlace => 'FINALA MICĂ';

  @override
  String get matchSetupWarnCaptain =>
      'Niciun căpitan numit. Atingeți ca să dați cuiva banderola';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name este accidentat și nu poate conduce echipa în acest meci. Atingeți ca să predați banderola';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name este suspendat pentru acest meci. Atingeți ca să predați banderola';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name are banderola, dar nu este în lot. Atingeți ca s-o predați';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Niciun executant la faze fixe. Atingeți ca să alegeți';

  @override
  String get matchSetupWarnBoth =>
      'Niciun căpitan și niciun executant la faze fixe. Atingeți ca să-i setați';

  @override
  String matchStageMatchday(int matchday) {
    return 'Et. $matchday';
  }

  @override
  String get squadCaptain => 'Căpitan';

  @override
  String deptEffectYouth(int points) {
    return 'Tinerii din academie vin cu aproximativ $points puncte mai buni';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount înapoi la finalul ciclului';
  }

  @override
  String deptEffectMedical(int percent) {
    return 'Cu $percent% mai puține accidentări';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% șanse ca un jucător străin să ceară schimbarea';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points răbdare a federației înainte ca postul să fie în pericol';
  }

  @override
  String get deptEffectNone => 'Niciun efect fără finanțare';

  @override
  String get statsBestRated => 'Note';

  @override
  String get statsMyCareer => 'Carieră';

  @override
  String get statsBestAverageRating => 'CEA MAI BUNĂ NOTĂ MEDIE';

  @override
  String get statsMyCareerRecord => 'BILANȚUL DVS.';

  @override
  String get statsNoRatingsRecorded => 'Nicio notă de meci înregistrată încă.';

  @override
  String get statsGroupRecord => 'Bilanț';

  @override
  String get statsGroupRuns => 'Serii';

  @override
  String get statsGroupExtremes => 'Extreme';

  @override
  String get statsGroupSplits => 'Acasă și deplasare';

  @override
  String get statsGroupSquad => 'Jucătorii dvs.';

  @override
  String get statsPlayed => 'Meciuri jucate';

  @override
  String get statsWinDrawLoss => 'Victorii–egaluri–înfrângeri';

  @override
  String get statsWinRate => 'Procent victorii';

  @override
  String get statsGoals => 'Goluri marcate:primite';

  @override
  String get statsCleanSheets => 'Meciuri fără gol primit';

  @override
  String get statsFailedToScore => 'Meciuri fără gol marcat';

  @override
  String get statsLongestWinStreak => 'Cea mai lungă serie de victorii';

  @override
  String get statsLongestUnbeaten => 'Cea mai lungă serie fără înfrângere';

  @override
  String get statsLongestCleanSheets => 'Cea mai lungă serie fără gol primit';

  @override
  String get statsLongestWinless => 'Cea mai lungă serie fără victorie';

  @override
  String get statsCurrentRun => 'Seria actuală fără înfrângere';

  @override
  String get statsBiggestWin => 'Cea mai mare victorie';

  @override
  String get statsHeaviestDefeat => 'Cea mai grea înfrângere';

  @override
  String get statsMostGoalsInAGame => 'Cele mai multe goluri într-un meci';

  @override
  String get statsShootouts => 'Departajări câștigate–pierdute';

  @override
  String get statsComebackWins => 'Victorii după ce ați fost conduși';

  @override
  String get statsHome => 'Acasă';

  @override
  String get statsAway => 'Deplasare';

  @override
  String get statsNeutral => 'Teren neutru';

  @override
  String get statsCompetitive => 'Oficiale';

  @override
  String get statsFriendlies => 'Amicale';

  @override
  String get statsHatTricks => 'Hat-trickuri';

  @override
  String get statsBraces => 'Duble';

  @override
  String get statsMotms => 'Titluri de omul meciului';

  @override
  String get statsAssists => 'Pase decisive';

  @override
  String get statsCards => 'Cartonașe';

  @override
  String get statsBestRating => 'Cea mai bună notă individuală';

  @override
  String statsAppsShort(int apps) {
    return '$apps meciuri';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms× omul meciului';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'Căpitan. Atingeți ca să luați banderola';

  @override
  String get captainFitBorn => 'Lider înnăscut';

  @override
  String get captainFitNatural => 'Căpitan natural';

  @override
  String get captainFitCapable => 'Ar putea s-o poarte';

  @override
  String get captainFitUnproven => 'Încă nu e lider';

  @override
  String get captainNone => 'Niciun căpitan numit';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale moralul lotului';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Preliminariile Campionatului Mondial';

  @override
  String get resultsCategoryFriendlies => 'Amicale';

  @override
  String get resultsCategoryContinentalClash => 'Duelul Continentelor';

  @override
  String get resultsCategoryNationsCup => 'Cupa Națiunilor';

  @override
  String get resultsCategoryContinentalCup => 'Cupa Continentală';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Prel. CM';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Prel. Cupa Cont.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Preliminariile Cupei Continentale';

  @override
  String get resultsCategoryWorldCupFinals =>
      'Turneul final al Campionatului Mondial';

  @override
  String get resultsRoundResults => 'REZULTATELE RUNDEI';

  @override
  String get resultsFriendlyInternationals => 'AMICALE INTERNAȚIONALE';

  @override
  String get resultsKnockout => 'Eliminatorii';

  @override
  String resultsEarlierMatches(int count) {
    return 'Meciuri anterioare ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'ETAPA $matchday';
  }

  @override
  String get resultsContinue => 'Continuați';

  @override
  String resultsGroup(String name) {
    return 'GRUPA $name';
  }

  @override
  String get achievementsScreenTitle => 'REALIZĂRI';

  @override
  String get achievementsChallengesTooltip => 'Provocări';

  @override
  String get achievementsChallengesHeading => 'PROVOCĂRI';

  @override
  String get achievementsBrutalTests => 'Teste dure pe toată cariera';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Nu s-a putut încărca.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total deblocate';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total cucerite';
  }

  @override
  String get achievementsBoardSatisfaction => 'MULȚUMIREA FEDERAȚIEI';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count DE REALIZĂRI DEBLOCATE',
      few: '$count REALIZĂRI DEBLOCATE',
      one: 'REALIZARE DEBLOCATĂ',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Victorii';

  @override
  String get achCatMatches => 'Meciuri';

  @override
  String get achCatQualifications => 'Calificări';

  @override
  String get achCatTitles => 'Titluri';

  @override
  String get achCatMisc => 'Diverse';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Goluri';

  @override
  String get achCatStreaks => 'Serii';

  @override
  String get achTierBronze => 'Bronz';

  @override
  String get achTierSilver => 'Argint';

  @override
  String get achTierGold => 'Aur';

  @override
  String get achTierPlatinum => 'Platină';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de goluri',
      few: '$count goluri',
      one: '$count gol',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Marcați $count de goluri.',
      few: 'Marcați $count goluri.',
      one: 'Marcați 1 gol.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de meciuri fără gol primit',
      few: '$count meciuri fără gol primit',
      one: '$count meci fără gol primit',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Încheiați $count de meciuri fără gol primit.',
      few: 'Încheiați $count meciuri fără gol primit.',
      one: 'Încheiați 1 meci fără gol primit.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Obișnuința victoriei';

  @override
  String get achStreakWin5Desc => 'Câștigați cinci meciuri la rând.';

  @override
  String get achStreakWin10 => 'Pe val';

  @override
  String get achStreakWin10Desc => 'Câștigați zece meciuri la rând.';

  @override
  String get achStreakWin20 => 'Tăvălugul';

  @override
  String get achStreakWin20Desc => 'Câștigați douăzeci de meciuri la rând.';

  @override
  String get achUnbeaten15 => 'Greu de învins';

  @override
  String get achUnbeaten15Desc => 'Rămâneți neînvinși cincisprezece meciuri.';

  @override
  String get achUnbeaten30 => 'De neatins';

  @override
  String get achUnbeaten30Desc => 'Rămâneți neînvinși treizeci de meciuri.';

  @override
  String get achHattrick => 'Eroul hat-trickului';

  @override
  String get achHattrickDesc => 'Un jucător de-al dvs. reușește un hat-trick.';

  @override
  String get achMotm10 => 'Remarcat';

  @override
  String get achMotm10Desc => 'Strângeți 10 titluri de omul meciului.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc => 'Strângeți 50 de titluri de omul meciului.';

  @override
  String get achPerfect => 'Nota zece';

  @override
  String get achPerfectDesc =>
      'Un jucător primește o notă de 9,5+ într-un meci.';

  @override
  String get achShootout => 'Sânge rece';

  @override
  String get achShootoutDesc => 'Câștigați cinci loterii ale penalty-urilor.';

  @override
  String get achMassacre => 'Masacru';

  @override
  String get achMassacreDesc =>
      'Câștigați un meci la 7 goluri diferență sau mai mult.';

  @override
  String get achAnnihilation => 'Anihilare';

  @override
  String get achAnnihilationDesc =>
      'Câștigați un meci la 10 goluri diferență sau mai mult.';

  @override
  String get chTierBronze => 'Bronz';

  @override
  String get chTierSilver => 'Argint';

  @override
  String get chTierGold => 'Aur';

  @override
  String get chTierLegendary => 'Legendar';

  @override
  String get chFirstSteps => 'Pe bancă';

  @override
  String get chFirstStepsDesc => 'Antrenați timp de 5 ani.';

  @override
  String get chUnbeaten10 => 'Pe val';

  @override
  String get chUnbeaten10Desc => 'Rămâneți neînvinși 10 meciuri oficiale.';

  @override
  String get chTwoNations => 'O nouă provocare';

  @override
  String get chTwoNationsDesc => 'Conduceți 2 națiuni diferite.';

  @override
  String get chCont1 => 'Campion continental';

  @override
  String get chCont1Desc => 'Câștigați un campionat continental.';

  @override
  String get chNc1 => 'Câștigătorul Cupei Națiunilor';

  @override
  String get chNc1Desc => 'Câștigați Cupa Națiunilor.';

  @override
  String get chWc1 => 'Campion mondial';

  @override
  String get chWc1Desc => 'Câștigați Campionatul Mondial.';

  @override
  String get chYears25 => 'Instituție';

  @override
  String get chYears25Desc => 'Antrenați timp de 25 de ani.';

  @override
  String get chWc3 => 'Câștigător în serie';

  @override
  String get chWc3Desc => 'Câștigați 3 Campionate Mondiale.';

  @override
  String get chWc5 => 'Dinastie';

  @override
  String get chWc5Desc => 'Câștigați 5 Campionate Mondiale.';

  @override
  String get chWc10 => 'Nemuritor';

  @override
  String get chWc10Desc => 'Câștigați 10 Campionate Mondiale.';

  @override
  String get chWc2Teams => 'Cu ghetele în bagaj';

  @override
  String get chWc2TeamsDesc =>
      'Câștigați Campionatul Mondial cu 2 națiuni diferite.';

  @override
  String get chWc3Teams => 'Globetrotter';

  @override
  String get chWc3TeamsDesc =>
      'Câștigați Campionatul Mondial cu 3 națiuni diferite.';

  @override
  String get chWcStreak3 => 'Triplă consecutivă';

  @override
  String get chWcStreak3Desc => 'Câștigați 3 Campionate Mondiale la rând.';

  @override
  String get chWcAllconf => 'Cuceritorul lumii';

  @override
  String get chWcAllconfDesc =>
      'Câștigați Campionatul Mondial cu o națiune din fiecare confederație (6).';

  @override
  String get chCont5 => 'Regele continentului';

  @override
  String get chCont5Desc => 'Câștigați 5 campionate continentale.';

  @override
  String get chContAll => 'Marele șlem al celor șase continente';

  @override
  String get chContAllDesc =>
      'Câștigați campionatul continental al fiecărei confederații (6).';

  @override
  String get chTreble => 'Tripla perfectă';

  @override
  String get chTrebleDesc =>
      'Câștigați Campionatul Mondial, un titlu continental și Cupa Națiunilor într-o singură carieră.';

  @override
  String get chNations10 => 'Nomad';

  @override
  String get chNations10Desc => 'Conduceți 10 națiuni diferite.';

  @override
  String get chYears100 => 'Secol';

  @override
  String get chYears100Desc => 'Antrenați timp de 100 de ani.';

  @override
  String get chYears500 => 'Jumătate de mileniu';

  @override
  String get chYears500Desc => 'Antrenați timp de 500 de ani.';

  @override
  String get chYears1000 => 'Etern';

  @override
  String get chYears1000Desc => 'Antrenați timp de 1000 de ani.';

  @override
  String get chGrandmaster => 'Mare maestru';

  @override
  String get chGrandmasterDesc =>
      'Câștigați 3 Campionate Mondiale ȘI 5 campionate continentale.';

  @override
  String get chUndefeated => 'De neatins';

  @override
  String get chUndefeatedDesc =>
      'Câștigați un Campionat Mondial fără să pierdeți niciun meci.';

  @override
  String get chPerfectQual => 'Parcurs fără greș';

  @override
  String get chPerfectQualDesc =>
      'Câștigați toate meciurile unei campanii de preliminarii pentru Campionatul Mondial.';

  @override
  String get chMinnow => 'Miracolul cenușăresei';

  @override
  String get chMinnowDesc =>
      'Câștigați Campionatul Mondial cu o națiune clasată în afara primelor 32 din lume.';

  @override
  String get chGrandTour => 'Acasă și în deplasare';

  @override
  String get chGrandTourDesc =>
      'Câștigați un Campionat Mondial ca gazdă și unul departe de casă.';

  @override
  String get chUnbeaten25 => 'Zidul';

  @override
  String get chUnbeaten25Desc => 'Rămâneți neînvinși 25 de meciuri oficiale.';

  @override
  String get chGoals10k => 'Mașinărie de goluri';

  @override
  String get chGoals10kDesc => 'Marcați 10.000 de goluri în carieră.';

  @override
  String get chCleanSheets500 => 'Fortăreața';

  @override
  String get chCleanSheets500Desc =>
      'Încheiați 500 de meciuri fără gol primit în carieră.';

  @override
  String get chHatTricks25 => 'Obsesia hat-trickului';

  @override
  String get chHatTricks25Desc => 'Jucătorii dvs. reușesc 25 de hat-trickuri.';

  @override
  String get chWinStreak25 => 'Neîndurător';

  @override
  String get chWinStreak25Desc => 'Câștigați 25 de meciuri la rând.';

  @override
  String get chCont10 => 'Dinastie continentală';

  @override
  String get chCont10Desc => 'Câștigați 10 campionate continentale.';

  @override
  String get chPcWc => 'Campion în serie';

  @override
  String chPcWcDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Câștigați Campionatul Mondial de $count ori în această salvare.',
      one: 'Câștigați Campionatul Mondial o dată în această salvare.',
    );
    return '$_temp0';
  }

  @override
  String get chPcMajors => 'Colecționar de trofee';

  @override
  String chPcMajorsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Câștigați $count de trofee majore (Campionatul Mondial, campionatul continental sau Cupa Națiunilor).',
      few:
          'Câștigați $count trofee majore (Campionatul Mondial, campionatul continental sau Cupa Națiunilor).',
      one:
          'Câștigați 1 trofeu major (Campionatul Mondial, campionatul continental sau Cupa Națiunilor).',
    );
    return '$_temp0';
  }

  @override
  String get chPcUnbeaten => 'Zid de fier';

  @override
  String chPcUnbeatenDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rămâneți neînvinși $count de meciuri oficiale.',
      few: 'Rămâneți neînvinși $count meciuri oficiale.',
      one: 'Rămâneți neînvinși 1 meci oficial.',
    );
    return '$_temp0';
  }

  @override
  String get chPcNations => 'Globetrotter';

  @override
  String chPcNationsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Conduceți $count de națiuni diferite.',
      few: 'Conduceți $count națiuni diferite.',
      one: 'Conduceți 1 națiune.',
    );
    return '$_temp0';
  }

  @override
  String get chPcYears => 'Cursa lungă';

  @override
  String chPcYearsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Antrenați timp de $count de ani.',
      few: 'Antrenați timp de $count ani.',
      one: 'Antrenați timp de 1 an.',
    );
    return '$_temp0';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de victorii',
      few: '$count victorii',
      one: '1 victorie',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Câștigați $count de meciuri.',
      few: 'Câștigați $count meciuri.',
      one: 'Câștigați 1 meci.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de meciuri',
      few: '$count meciuri',
      one: '$count meci',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jucați $count de meciuri.',
      few: 'Jucați $count meciuri.',
      one: 'Jucați 1 meci.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Calificat la Campionatul Mondial';

  @override
  String get achQualWcDesc => 'Calificați-vă la Campionatul Mondial.';

  @override
  String get achQualCont => 'Calificat la turneul continental';

  @override
  String get achQualContDesc => 'Calificați-vă la campionatul continental.';

  @override
  String get achTitleWc => 'Campioni mondiali';

  @override
  String get achTitleWcDesc => 'Câștigați Campionatul Mondial.';

  @override
  String get achTitleEuro => 'Campioni europeni';

  @override
  String get achTitleEuroDesc => 'Câștigați Campionatul European.';

  @override
  String get achTitleCopa => 'Campionii Americii de Sud';

  @override
  String get achTitleCopaDesc => 'Câștigați Cupa Americii de Sud.';

  @override
  String get achTitleAfcon => 'Campionii Africii';

  @override
  String get achTitleAfconDesc => 'Câștigați Campionatul African.';

  @override
  String get achTitleAsia => 'Campionii Asiei';

  @override
  String get achTitleAsiaDesc => 'Câștigați Campionatul Asiatic.';

  @override
  String get achTitleConcacaf => 'Campionii Americii de Nord';

  @override
  String get achTitleConcacafDesc => 'Câștigați Cupa Americii de Nord.';

  @override
  String get achTitleOfc => 'Campionii Oceaniei';

  @override
  String get achTitleOfcDesc => 'Câștigați Cupa Oceaniei.';

  @override
  String get achTitleNations => 'Câștigătorii Cupei Națiunilor';

  @override
  String get achTitleNationsDesc => 'Câștigați Cupa Națiunilor.';

  @override
  String get achTitleClash => 'Câștigătorii Duelului Continentelor';

  @override
  String get achTitleClashDesc => 'Câștigați Duelul Continentelor.';

  @override
  String get achMarksman => 'Tunarul Campionatului Mondial';

  @override
  String get achMarksmanDesc =>
      'Un jucător din lot marchează 6+ goluri la turneul final al Campionatului Mondial.';

  @override
  String get achSweep => 'Tripla perfectă';

  @override
  String get achSweepDesc =>
      'Dețineți Campionatul Mondial și titlul continental într-o singură carieră.';

  @override
  String get achAllstar => 'În echipa turneului';

  @override
  String get achAllstarDesc =>
      'Un jucător de-al dvs. e inclus în echipa turneului la un Campionat Mondial.';

  @override
  String get achGoldenboot => 'Gheata de Aur';

  @override
  String get achGoldenbootDesc =>
      'Un jucător al națiunii dvs. încheie un turneu ca golgheter.';

  @override
  String get achDemolition => 'Demolare';

  @override
  String get achDemolitionDesc =>
      'Câștigați un meci la 5 goluri diferență sau mai mult.';

  @override
  String get achievementsNice => 'Super!';

  @override
  String get achievementsHardestTests =>
      'Cele mai grele teste pentru un selecționer, de-a lungul unei cariere întregi și al multor națiuni.';

  @override
  String get achievementsThisSave => 'ACEASTĂ SALVARE';

  @override
  String get achievementsBrutalBadge => 'DUR';

  @override
  String get paywallGoPro => 'TRECEȚI LA UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Deblocare unică. Fără abonament.';

  @override
  String get paywallBenefitCarryOn =>
      'Această salvare continuă exact de unde s-a oprit, cu toate selecțiile, recordurile și rivalitățile intacte.';

  @override
  String get paywallBenefitNoAds =>
      'Fără reclame, fără microtranzacții, fără abonament. O singură plată și toate actualizările viitoare sunt ale dvs.';

  @override
  String get paywallBenefitSaves =>
      'Câte salvări doriți. Conduceți simultan o favorită și o cenușăreasă și descoperiți cât de diferit se joacă același joc.';

  @override
  String get paywallBenefitEndless =>
      'Toate ciclurile de acum înainte. Alegeți azi un puști de șaptesprezece ani și aflați în 2034 dacă ați avut dreptate.';

  @override
  String get paywallUnlocked => 'Unlimited este deblocat. Distracție plăcută!';

  @override
  String get paywallContactingStore => 'Se contactează magazinul…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Deblocați Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Restaurați achizițiile';

  @override
  String get paywallStoreUnavailable => 'Magazin indisponibil';

  @override
  String get paywallStoreUnavailableNote =>
      'Prețul nu a putut fi încărcat. Verificați conexiunea și încercați din nou.';

  @override
  String get paywallTryAgain => 'Încercați din nou';

  @override
  String get gateTitle => 'PRIMUL CICLU S-A ÎNCHEIAT';

  @override
  String get gateLead =>
      'Patru ani înseamnă un ciclu. Nu e destul ca să aflați dacă ați avut dreptate.';

  @override
  String get gatePriceLead => 'O singură plată, pentru totdeauna';

  @override
  String get gateBuy => 'CUMPĂRAȚI ȘI CONTINUAȚI';

  @override
  String get gateExit => 'IEȘIȚI';

  @override
  String get gateSaveTitle => 'ACEASTĂ SALVARE NECESITĂ PRO';

  @override
  String get gateSaveLead =>
      'Salvările trecute de ciclul gratuit și campaniile Pro continuă cu Pro. Nu se pierde nimic: salvarea vă așteaptă exact cum ați lăsat-o.';

  @override
  String get careerSaveLockedNote =>
      'Aveți nevoie de Pro pentru a continua această salvare';

  @override
  String get federationNaturalisation => 'NATURALIZARE';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name a fost naturalizat';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name a finalizat schimbarea și este acum eligibil pentru $nation. Îl puteți convoca din selecția lotului.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Oferta nu a putut fi încărcată.\n$error';
  }

  @override
  String get federationContinue => 'Continuați';

  @override
  String get federationOfferToSwitchAllegiance =>
      'O OFERTĂ DE SCHIMBARE A NAȚIONALEI';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age ani · din $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name are legături cu $playerNation și este dispus să fie naturalizat. Acceptați și poate fi convocat; refuzați și rămâne la $sourceNation.';
  }

  @override
  String get federationDecline => 'Refuzați';

  @override
  String get federationNaturalise => 'Naturalizați';

  @override
  String get federationBudgetLater => 'Decideți mai târziu';

  @override
  String get federationSetYourBudget => 'STABILIȚI BUGETUL';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Finanțele nu au putut fi încărcate.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Salvarea nu a fost găsită.';

  @override
  String get federationBudgetHeading => 'BUGETUL FEDERAȚIEI';

  @override
  String federationDistributeBudget(String amount) {
    return 'Împărțiți $amount între departamente ca să deschideți ciclul. Cheltuiți cu înțelepciune.';
  }

  @override
  String federationOverBudget(String amount) {
    return 'Cu $amount mai mult decât are federația. Retrageți o parte';
  }

  @override
  String get federationAllocateFullBudget =>
      'Alocați tot bugetul ca să începeți ciclul.';

  @override
  String get federationConfirming => 'Se confirmă…';

  @override
  String get federationConfirmBudget => 'Confirmați bugetul';

  @override
  String get federationFinances => 'FINANȚE';

  @override
  String get federationInvestmentUpdated => 'Investiție actualizată.';

  @override
  String get federationDevelopment => 'DEZVOLTAREA FEDERAȚIEI';

  @override
  String get federationProjectedAtSeasonEnd => 'ESTIMAT LA FINAL DE SEZON';

  @override
  String get federationCentralFunding => 'Finanțare centrală';

  @override
  String get federationPrizeMoneySoFar => 'Premii până acum';

  @override
  String get federationCommercialReturn => 'Venituri comerciale';

  @override
  String get federationThisSeasonLocked => 'SEZONUL ACESTA (BLOCAT)';

  @override
  String get federationInvestForNextSeason => 'INVESTIȚI PENTRU SEZONUL VIITOR';

  @override
  String get federationNextSeasonImpact => 'IMPACT ÎN SEZONUL VIITOR';

  @override
  String get federationSaving => 'Se salvează…';

  @override
  String get federationConfirmInvestment => 'Confirmați investiția';

  @override
  String get federationBalance => 'SOLDUL FEDERAȚIEI';

  @override
  String get federationCommittedToStaff => 'Angajat pentru staff';

  @override
  String get federationFreeToSpend => 'Disponibil';

  @override
  String get federationWagesNote =>
      'Salariile se scad din sold la finalul ciclului, deci această sumă este deja rezervată.';

  @override
  String get federationInvestAtCeremony =>
      'Investiți pentru sezonul viitor la ceremonia de final de ciclu.';

  @override
  String federationLevelBadge(int level) {
    return 'N$level';
  }

  @override
  String get federationAcademyProspects => 'Tinerii academiei';

  @override
  String federationPlusOverall(int value) {
    return '+$value general';
  }

  @override
  String get federationInjuryRisk => 'Risc de accidentare';

  @override
  String get federationNaturalisationChance => 'Șansă de naturalizare';

  @override
  String get federationBoardPatience => 'Răbdarea federației';

  @override
  String get federationUnallocated => 'NEALOCAT';

  @override
  String get nationsVitrineTitle => 'VITRINA NAȚIONALĂ';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Națiunea nu a putut fi încărcată.\n$error';
  }

  @override
  String get nationsNoNation => 'Nicio națiune.';

  @override
  String get nationsHonours => 'PALMARES';

  @override
  String get nationsRankingHistory => 'ISTORICUL ÎN CLASAMENTUL MONDIAL';

  @override
  String get nationsTopScorers => 'GOLGHETERII ALL-TIME';

  @override
  String get nationsTitles => 'TITLURI';

  @override
  String get nationsYourTeam => 'ECHIPA DVS.';

  @override
  String get nationsWorld => 'LUME';

  @override
  String get nationsWorldCup => 'Campionatul Mondial';

  @override
  String get nationsContinental => 'Continental';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de participări',
      few: '$count participări',
      one: '1 participare',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Încă nu există destul istoric. Reveniți după un ciclu sau două.';

  @override
  String nationsBestRank(int rank) {
    return 'Cel mai bun: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Acum: #$rank';
  }

  @override
  String get nationsNoGoals => 'Niciun gol înregistrat încă.';

  @override
  String get nationsGoalsAbbrev => 'gol.';

  @override
  String get nationsHosts => 'GAZDĂ';

  @override
  String get nationsSelectTitle => 'ALEGEȚI ECHIPA NAȚIONALĂ';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Națiunile nu au putut fi încărcate.\n$error';
  }

  @override
  String get nationsNoMatch => 'Nicio națiune găsită.';

  @override
  String get nationsSelectHeading => 'Alegeți echipa națională';

  @override
  String get nationsSearchHint => 'Căutați țara…';

  @override
  String get nationsRank => 'LOC ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'ALEGEȚI';

  @override
  String get statsTeamRecords => 'RECORDURILE ECHIPEI';

  @override
  String get statsRecordBook => 'Cartea recordurilor';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Statisticile nu au putut fi încărcate.\n$error';
  }

  @override
  String get statsNoData => 'Nicio dată.';

  @override
  String get statsTopScorers => 'GOLGHETERI';

  @override
  String get statsMostGamesPlayed => 'CELE MAI MULTE MECIURI';

  @override
  String get statsTeam => 'Echipă';

  @override
  String get statsTopScorersShort => 'Marcatori';

  @override
  String get statsMostGames => 'Meciuri';

  @override
  String get statsNoGoalsRecorded => 'Niciun gol înregistrat încă.';

  @override
  String get statsUnknown => 'Necunoscut';

  @override
  String get playerTitle => 'JUCĂTOR';

  @override
  String playerLoadError(String error) {
    return 'Jucătorul nu a putut fi încărcat.\n$error';
  }

  @override
  String get playerNotFound => 'Jucătorul nu a fost găsit.';

  @override
  String get playerClub => 'CLUB';

  @override
  String get playerClubRole => 'La club';

  @override
  String get playerPosition => 'Post';

  @override
  String get playerPotential => 'Potențial';

  @override
  String get playerAge => 'Vârstă';

  @override
  String get playerValue => 'Valoare';

  @override
  String get clubFirstChoice => 'Joacă în fiecare săptămână';

  @override
  String get clubRotation => 'Când da, când nu';

  @override
  String get clubFringe => 'Joacă foarte puțin';

  @override
  String get clubFrozenOut => 'Nu joacă';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Mă uit la fotbal de treizeci de ani și n-am văzut asta venind. $score cu $opponent.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Nimeni nu le dădea vreo șansă cu $opponent. $score. Absolut nimeni.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score cu $opponent. Duceți-vă și treziți vecinii.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'E genul de seară pe care o povestești nepoților. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score cu $opponent. Cum s-a întâmplat, nu contează, s-a întâmplat.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Pe hârtie, meciul era pierdut înainte să înceapă. $opponent $score spune altceva.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Victorie cu $opponent, $score. Peste un an nimeni nu va crede scorul ăsta.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Bucurați-vă, apoi uitați-vă la program.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score cu $opponent, și am avut noroc optzeci de minute din nouăzeci.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'O seară cu $opponent nu șterge un an întreg. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Am bătut $opponent cu $score și acum o să ni se spună că am trecut un prag. Nu l-am trecut.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Minunat. Mai întrebați-mă când contează.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Victorie cu $opponent, $score. Exact cum trebuia, și asta are farmecul ei.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score cu $opponent. Necruțători, și e un compliment.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Fără agitație, fără emoții, fără reproșuri.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Un $score curat cu $opponent. Așa arată o echipă bună într-o zi liniștită.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score cu $opponent. Treaba făcută, nimic învățat.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Victorie cu $opponent, $score. Trebuia să câștigăm și am câștigat.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Un $score profesionist cu $opponent. Următorul.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$score cu $opponent. La dosar și mergem mai departe.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score cu $opponent și ar trebui să aplaudăm. Pentru că i-am bătut pe ei.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Felicitări tuturor celor implicați în acel $score cu $opponent, presupun.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Să bați asemenea echipe e minimul, nu o performanță.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Am bătut $opponent cu $score și ne-am chinuit s-o facem.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score cu $opponent și fiecare minut a fost muncit.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Asta a cerut caracter. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Victorie cu $opponent, $score, pe calea grea, care e și cea care rămâne.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score cu $opponent. Echipele care câștigă astfel de meciuri sunt cele încă în picioare în iunie.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Cu emoții, urât, dar victorie. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Victorie cu $opponent, $score. Luați cele trei puncte și nu-l mai revedeți niciodată.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent ne-a pus să muncim pentru fiecare centimetru.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Nu frumos. Contează la fel.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score cu $opponent și ne-am complicat de zece ori mai mult decât era cazul.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'N-ar trebui să ne agățăm de rezultat cu $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Am câștigat și n-am aflat nimic bun despre noi.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'Un $score care ne-a flatat cu $opponent.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Un punct cu $opponent, $score. Îl luăm și mergem mai departe.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score cu $opponent. Există și după-amiezi mai rele.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Am ținut $opponent la $score. Nu totul trebuie să fie o poveste.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Un punct e un punct, iar clasamentul nu întreabă cum.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score cu $opponent. Două puncte pierdute sau unul câștigat. Alegeți-vă starea.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Egal cu $opponent, $score. Nimeni nu e fericit, nimeni nu e furios.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Cele mai uitabile nouăzeci de minute ale anului.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Am împărțit punctele cu $opponent, $score. Mergem mai departe.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score cu $opponent. Așa mor încet campaniile, din egaluri ca ăsta.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Două puncte aruncate cu $opponent. $score. Nu-i pot spune altfel.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Am avut nouăzeci de minute și nicio idee ce să facem cu ele.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Un $score cu $opponent pe care nimeni nu-l va ține minte și pe care toți îl vor plăti.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Învinși cu $score de $opponent. Se întâmplă.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Nimeni nu trebuie spânzurat. Mergem la următorul.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Am pierdut cu $score în fața echipei $opponent și am dat tot. Uneori nu e destul.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score cu $opponent. Capul sus. Echipa asta mai are multe de dat.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Am fost inferiori și nu există discuție.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Am pierdut cu $score în fața echipei $opponent. Ne regrupăm.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score cu $opponent. Nu e o rușine, dar nici destul.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Învinși cu $score de $opponent. Învățăm ceva de aici sau a fost degeaba.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score cu $opponent și nici nu i-am atins.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Am pierdut cu $opponent, $score. Aceleași probleme, aceeași lună, aceleași scuze pe drum.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Când încetează asta să mai fie ghinion?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Învinși cu $score de $opponent. Un rezultat care ar trebui să coste pe cineva.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score cu $opponent. O seară proastă. Judecați echipa după campanie, nu după asta.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Nimeni nu și-a dorit mai puțin acel $score cu $opponent decât jucătorii.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Urât, și nu asta e echipa noastră.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Un $score de uitat cu $opponent. Data viitoare vor răspunde.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Cu $opponent. Nu am cuvinte și sunt plătit să am cuvinte.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Cineva trebuie să dea socoteală pentru asta.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Vreau ca acel $score cu $opponent să fie șters din statistici și din memorie.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Învinși cu $score de $opponent. Un asemenea scor nu poate fi îndulcit.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'N-a fost o înfrângere cu $opponent, a fost o capitulare. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Cu $opponent. Oamenii au plătit bilet ca să vadă asta.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Dacă asta nu schimbă ceva, nimic nu va schimba.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Am mai văzut echipa asta umilită, dar $score cu $opponent e un nou minim.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return 'Victorie cu $score contra echipei $opponent. Notați data, o să fiți întrebați unde erați.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'În afara vestiarului nu credea nimeni. $score cu $opponent. Mândru e prea puțin spus.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score cu $opponent! Fiecare a alergat până n-a mai rămas nimic.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Ucigași de giganți. $opponent, $score. De asta venim mereu.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score cu $opponent. Pronosticurile tocmai au zburat pe fereastră.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Mare favorită: $opponent. Scor final: $score pentru noi.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Una dintre surprizele anului: $score cu $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Nimeni n-a prevăzut asta și nimeni nu știe s-o explice.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score cu $opponent. Minunat. Acum toată lumea o să uite cât de prost a fost restul anului.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score cu $opponent și trenul e deja plin. Eu eram în el când era gol.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Excelent, și tot vor găsi o cale să irosească asta.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Seară mare cu $opponent, $score. O rândunică nu aduce primăvara.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score cu $opponent. Doare pentru că ne pasă. Susțineți-i oricum.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'O seară de uitat cu $opponent, $score. Pe jucători îi doare cel mai tare.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Capul sus. O echipă se judecă după cum răspunde la asta.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score cu $opponent. Rău, da. Sfârșitul lumii, nu.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score cu $opponent. Un rezultat despre care se va vorbi ani de zile, din motive greșite.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Victorie pentru $opponent, $score. După asta, nimeni să nu se mai mire data viitoare.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Una dintre cele mai proaste seri din ultima vreme: $score cu $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Vor fi întrebări, și pe bună dreptate.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score cu $opponent. Rușinos e prea puțin spus.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Înfrângere cu $score în fața echipei $opponent. Ultimul să stingă lumina.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Nu mă mai mir, și asta mă sperie.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Cineva de sus ar trebui să-și actualizeze CV-ul în seara asta.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score cu $opponent! Un asemenea fotbal face toată țara să zâmbească.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return 'Echipa $opponent spulberată, $score. Ce prestație.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Cu $opponent. În seara asta a ieșit tot.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'O demolare cu $score a echipei $opponent. Păstrați rezumatul, o să-l vreți.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Asta e o echipă care se bucură de fotbalul ei.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score cu $opponent, și puteau fi mai multe. Splendid.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score cu $opponent. Un scor la care te uiți de două ori.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return 'Victorie cu $score contra echipei $opponent. După prima jumătate de oră n-a mai fost meci.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Scor final: $score cu $opponent. De departe cea mai mare victorie din ultima vreme.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. O echipă a venit să joace, cealaltă nici n-a coborât din autocar.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. Echipa $opponent n-a avut răspuns la nimic.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Bătaie: $score cu $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score cu $opponent. Frumos, dar nu ei sunt etalonul.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score cu $opponent. Treziți-mă când facem asta cu cineva bun.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Distractiv, dar am văzut echipe strălucind așa și necâștigând nimic.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score și toată lumea e iar genială. Adversarul a fost $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score cu $opponent. Fără euforie, asta dovedește foarte puțin.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Bucurați-vă, apoi amintiți-vă cum s-a terminat ultima dată când ne-am entuziasmat.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Calificare la penalty-uri cu $opponent! Nervi de oțel, toți.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Penalty-uri cu $opponent, și ne-am ținut nervii. Îmbrățișați un necunoscut.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Loviturile de departajare câștigate cu $opponent. Inima mea nu rezistă.';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'Victorie la penalty-uri cu $opponent. Mergem în runda următoare.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Cu $opponent s-a decis de la punctul cu var, iar noi am marcat mai multe.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Penalty-uri câștigate cu $opponent. Pe drumul cel mai greu, dar mergem mai departe.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Calificare la penalty-uri cu $opponent. Loteria câștigată, jocul uitat.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Să bați echipa $opponent la penalty-uri după un asemenea joc? Noroc, și toată lumea știe.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Mai departe cu $opponent la penalty-uri. Nu trebuia să se ajungă acolo.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'CALIFICAȚI. $score cu $opponent, iar visul trăiește.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'VICTORIE ÎN ELIMINATORII: $score cu $opponent. Țara poate începe să creadă.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score cu $opponent și în runda următoare. Ce seară.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return 'Echipa $opponent pleacă acasă, $score. Înainte.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'ELIMINATORII: $score cu $opponent. Runda următoare e sigură.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Calificați: $score cu $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return 'Echipa $opponent eliminată, $score. Ne așteaptă runda următoare.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Victorie cu $score contra echipei $opponent. În eliminatorii nimeni nu întreabă cum.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Calificați cu $opponent, $score. Următorul adversar nu va fi la fel de amabil.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score cu $opponent ajunge pentru calificare. Data viitoare va trebui mult mai mult.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return 'Echipa $opponent afară, $score. Mai mult am supraviețuit decât am câștigat.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'În runda următoare după $score cu $opponent. Nu întrebați cum.';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return 'Ne despărțeau $gap locuri în clasament și tot am învins echipa $opponent. Magnific.';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent: cu $gap locuri peste noi. Învinsă totuși. Fotbalul e minunat.';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'Diferență în clasament: $gap. Rezultat: victorie cu $opponent. Nu încetați niciodată să credeți.';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'Diferență în clasament înainte de start: $gap. Echipa $opponent învinsă oricum.';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'În clasamentul mondial, echipa $opponent era cu $gap locuri peste noi. Nu în seara asta.';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'Indicele surprizei: $gap locuri în clasament între echipe. Victorie pentru noi cu $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return '$gap locuri în clasament ne despărțeau de echipa $opponent. O seară nu închide diferența.';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: cu $gap locuri mai sus, și învinsă. Clasamentul abia va observa.';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'Diferență în clasament: $gap. Țineți minte numărul data viitoare când pierdem cu o echipă mică.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Am scris că echipa asta e terminată. M-am înșelat și n-am fost niciodată mai fericit că m-am înșelat. Victorie cu $opponent.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'O porție de modestie, vă rog. Mare. Victoria cu $opponent a fost magnifică.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Am zis că nu mai au nimic de dat. Au avut destul. Bravo tuturor, cu $opponent.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Pentru consemnare: victoria asta cu $opponent n-am văzut-o venind. Respect.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Bine. Am zis că vor fi demascați. Echipa $opponent n-a reușit.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Diseară îmi înghit vorbele despre echipa asta. Victoria cu $opponent o merită.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Da, am zis că s-a terminat cu ei. O victorie cu $opponent încă nu dovedește că m-am înșelat.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Mi se cere să-mi înghit vorbele după meciul cu $opponent. O fac, încet, și păstrez bonul.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Victoria cu $opponent a impresionat. Îndoielile mele despre echipa asta au rămas.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Jos pălăria pentru echipa $nation. $score, și meritat de la început până la sfârșit.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Doare s-o spun, dar în seara asta mai bună a fost echipa $nation. $score. Felicitări.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Respect pentru echipa $nation, și-au dorit mai mult.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Înfrângere cu $score în fața echipei $nation. Nici nu știu ce să zic.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Alor noștri ar trebui să le fie rușine.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score cu $nation. Să-mi explice cineva cum s-a întâmplat asta.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Să pierzi cu $score în fața echipei $nation. N-o să trec niciodată peste asta.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score cu $nation. Noroc. Noroc curat.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'După acest $score, fanii echipei $nation vor fi insuportabili ani de zile. Mulțumesc pentru nimic.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Minunat pentru fotbal. De asta îl iubim.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Ce rezultat: $nation $score $opponent. Fotbal la cel mai înalt nivel.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Toți neutrii țin în seara asta cu echipa $nation. $score cu $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Rezultatul etapei: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nimeni nu avea asta pe bilet.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Rezultat mare: $nation $score $opponent. Clasamentul se va mișca.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Distractiv, să vedem dacă pot repeta.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. A câștigat una sau a pierdut cealaltă?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Bombă: $nation $score $opponent. Așteptați-vă la o mulțime de reacții exagerate.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name cu $opponent. Copiii vor primi numele lui.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'O statuie pentru $name. În seara asta, cu $opponent, a fost totul.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, ce jucător. Țineți minte seara asta cu $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name a decis meciul cu $opponent. Omul meciului, fără discuție.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Cu $opponent, seara a fost a lui $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name a apărut când trebuia, cu $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name a fost strălucit cu $opponent. Acum în fiecare săptămână.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name a salvat echipa cu $opponent. Ceilalți au ajutat puțin.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Fără $name, seara cu $opponent ar fi fost cu totul alta.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score cu $opponent. Un accident. Se întâmplă oricui o dată.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Înfrângere cu $score în fața echipei $opponent. Scuturați-vă, campania nu s-a terminat.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Doare, dar un rezultat nu definește echipa asta.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score cu $opponent. O zi proastă la birou. Mai departe.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Înfrângere cu $opponent, $score. Nimeni n-a văzut asta venind.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Una dintre serile alea care n-au niciun sens.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score cu $opponent. O înfrângere care va rămâne în memorie.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Învinși de $opponent, $score. O surpriză, oricum ai privi-o.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score cu $opponent. Cu un asemenea adversar! Inacceptabil.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Înfrângere cu $score în fața echipei $opponent. Vreau explicații, nu scuze.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. O rușine națională, și nu e o figură de stil.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score cu $opponent. Cum mai stă cineva de sus pe scaun?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score cu $opponent. E o echipă de top. Învățăm.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Depășiți clar de $opponent, $score. Nu e rușine să pierzi cu cei mai buni.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. O lecție, iar din lecții crești.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score cu $opponent. Doare, dar sunt cu o treaptă mai sus.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Victorie pentru $opponent, $score. Diferența e reală, și acum a văzut-o toată lumea.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score cu $opponent. O bătaie, simplu.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. Echipa mai bună, și scorul o spune.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Înfrângere cu $score în fața echipei $opponent. Nu e o rușine, dar nici meci n-a fost.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score cu $opponent. Adversar mai bun sau nu, așa nu se pierde.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Am încercat măcar să concurăm?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Cu $opponent. Ca mieii la tăiere.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Înfrângere cu $score în fața echipei $opponent, și nimeni nu părea deranjat.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Eliminați la penalty-uri de $opponent. Au dat tot. Mândru de ei.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Penalty-uri cu $opponent. Cel mai crud mod de a pleca. Capul sus.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Loviturile de departajare pierdute cu $opponent. Nimeni nu merita asta.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Eliminați la penalty-uri de $opponent. A decis punctul cu var.';
  }

  @override
  String yLostShootout4(String opponent) {
    return 'Echipa $opponent trece mai departe la penalty-uri. Turneul nostru se termină aici.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Penalty-uri pierdute cu $opponent. Iar penalty-uri.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Eliminați la penalty-uri de $opponent. Le exersăm vreodată?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Înfrângere la penalty-uri cu $opponent. Trebuia să închidem meciul mult mai devreme.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Penalty-uri cu $opponent, și le-am pierdut. Bineînțeles.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ELIMINAȚI. $score cu $opponent. Un drum de care putem fi mândri se termină aici.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Eliminați de $opponent, $score. Mulțumim pentru amintiri.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score cu $opponent. Călătoria s-a încheiat, dar ce călătorie.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'AFARĂ: $score cu $opponent. Capul sus.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'FINAL DE DRUM: $score cu $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Afară: $score cu $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return 'Echipa $opponent merge mai departe, $score. Turneul nostru s-a încheiat.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Eliminați de $opponent, $score. Începe autopsia.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'ELIMINAȚI. $score cu $opponent. Alt turneu, același final.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score cu $opponent, și acasă. Nimeni nu e surprins.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Eliminați de $opponent, $score. Până dimineață vin și scuzele.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Afară, și n-a părut niciodată că se va termina altfel.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score cu $nation. Respect, se vor întoarce mai puternici.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Victorie bună pentru noi, $score. Zi proastă pentru echipa $nation, îmi pare rău de fanii lor.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Seară proastă pentru echipa $nation, iar noi am profitat. Așa e fotbalul.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score cu $nation! Cine se aștepta? Ei nu.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Victorie cu $score contra echipei $nation. Să verifice cineva cum le e fanilor.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Asta intră în albumul de familie.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score cu $nation. Și se cred o echipă mare.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Imaginează-ți să pierzi cu $score cu noi. Întreabă echipa $nation, acum știu.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Zbor plăcut spre casă.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Seară mare pentru unii, grea pentru alții.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Putere fanilor echipei $nation după $score cu $opponent. Se vor ridica.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Orice echipă mare are o asemenea seară.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Șocul etapei: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nimeni n-a văzut asta venind.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Rezultatul zilei: $nation $score $opponent. Acum urmează întrebările.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nu e o întâmplare, dacă ați urmărit.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Cineva de acolo va avea multe de explicat.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nume mare, prestație mică.';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent: cu $gap locuri sub noi. Se întâmplă. Mai departe.';
  }

  @override
  String yDownGap1(String gap) {
    return 'Diferență în clasament: $gap în favoarea noastră. Fotbalul nu citește clasamente.';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return 'Pe hârtie, $gap locuri între noi și echipa $opponent. Nu și pe teren, în seara asta.';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'Diferență în clasament înainte de start: $gap în favoarea noastră. Înfrângere cu $opponent oricum.';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'În clasamentul mondial, echipa $opponent era cu $gap locuri sub noi. Rezultat: înfrângere.';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'Indicele surprizei: $gap locuri în clasament, în direcția greșită, cu $opponent.';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return 'Cu $gap locuri peste echipa $opponent în clasament. Înfrângere. Explicați asta.';
  }

  @override
  String yDownGap7(String gap) {
    return 'Înfrângere cu o echipă aflată cu $gap locuri sub noi. Lăsați numărul ăsta să se așeze.';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'Diferență în clasament: $gap. Înfrângere cu $opponent. Cineva ar trebui să înceapă să numere zilele.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score cu $opponent! O remiză cu gust de victorie.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score cu $opponent. Mândru de fiecare dintre ei.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Ei erau favoriți și le-am ținut piept.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score cu $opponent. Un punct smuls cu sânge și sudoare.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score cu $opponent. Un punct foarte bun.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Remiză $score cu $opponent. Puțini se așteptau la ceva.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return 'Echipa $opponent oprită, $score. Un rezultat pe care se poate construi.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score cu $opponent. Un punct pe care nu ni-l dădea nimeni.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score cu $opponent. Punct bun, dar cu remize nu câștigi nimic.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score cu $opponent. Frumos. N-am avut nici măcar un șut ca lumea.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Un punct, și toată lumea se poartă de parcă am câștigat trofeul.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score cu $opponent. Am parcat autocarul și am avut noroc.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score cu $opponent. Frustrant, dar încă neînvinși.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Doar $score cu $opponent. O zi proastă. Se întâmplă.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Nu e destul, și jucătorii știu asta.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score cu $opponent. Două puncte pierdute, nimic mai mult.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score cu $opponent. Două puncte aruncate.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Doar $score cu $opponent. Un rezultat prost, oricum l-ai împacheta.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. O remiză cu gust de înfrângere.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score cu $opponent. Asemenea meciuri trebuie câștigate lejer.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score cu $opponent. Rușinos.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Doar remiză cu $opponent, $score. Cine răspunde pentru asta?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Dacă nu-i batem pe ei, pe cine batem?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score cu $opponent. Fanii lor sărbătoresc o remiză cu noi. Gândiți-vă la asta.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'CAMPIONI. $opponent. Spuneți-o cu voce tare.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Am câștigat. $opponent. Nu sunt bine.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, și trofeul vine acasă.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Fiecare dintre ei, o legendă. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Atât de aproape. $opponent și o medalie pe care n-o vrea nimeni.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Locul doi la $opponent. O să ne doară ani de zile.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: la un meci de tot.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Locul doi. La $opponent. Dați-mi sticla, vă rog.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Eliminați la $opponent. O să doară o vreme.';
  }

  @override
  String yEliminated1(String opponent) {
    return 'La $opponent se termină drumul nostru.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Eliminați la $opponent. Acum urmează ancheta.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Scoși din competiție la $opponent. Să-mi explice cineva.';
  }

  @override
  String yQualified0(String opponent) {
    return 'MERGEM LA $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Calificați la $opponent. Cereți-vă concediu.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, venim! N-a fost niciodată în dubiu (a fost complet în dubiu).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Calificați la $opponent. Partea grea s-a terminat.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Grupele pentru $opponent au fost trase. Putea fi mai rău. Mult mai rău.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Deci asta e tragerea pentru $opponent. Interesant.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Au ieșit grupele pentru $opponent și deja nu-mi place a noastră.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Tragerea pentru $opponent s-a făcut. Să înceapă exagerările.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Gazda va fi $opponent. Începeți să strângeți bani.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Merge la $opponent. Previzibil, dar în regulă.';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'Turneul l-a primit $opponent. Felicitări lor, presupun.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Gazdă confirmată: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent începe curând și nu pot sta locului.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Nu mai e mult până la $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent e aproape. Anunțați lotul, vă rog.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Numărătoarea inversă până la $opponent e oficial insuportabilă.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Nimic de spus încă. Jucați un meci.';

  @override
  String get yEarlierHeading => 'Mai devreme în acest ciclu';

  @override
  String get yTraitLoyalist =>
      'Susține echipa orice ar fi. Se întoarce greu, iartă repede.';

  @override
  String get yTraitCynic =>
      'Se așteaptă la ce e mai rău și e încântat când are dreptate.';

  @override
  String get yTraitNostalgic =>
      'Totul era mai bun înainte. Vă compară cu oameni care s-au retras de mult.';

  @override
  String get yTraitStatshead =>
      'Postează cifrele și atât. Aproape că n-are stări.';

  @override
  String get yTraitHypeman => 'Două rezultate bune și gata, generație de aur.';

  @override
  String get yTraitContrarian => 'Orice crede toată lumea, el crede opusul.';

  @override
  String get yTraitDoomer => 'O să iasă prost. Iese mereu prost.';

  @override
  String get yProfilePosts => 'POSTĂRI';

  @override
  String get yProfileEmpty => 'Nimic de la acest cont încă.';

  @override
  String hubEventGrievance(String player) {
    return '$player vrea să vorbească cu dvs.';
  }

  @override
  String get hubEventGrievanceSub => 'Vrea să știe care e situația lui';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de puncte de abilitate de cheltuit',
      few: '$count puncte de abilitate de cheltuit',
      one: '1 punct de abilitate de cheltuit',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub => 'Ce faceți bine face echipa mai bună';

  @override
  String get grievanceTitle => 'O discuție în birou';

  @override
  String grievanceGameTime(String player) {
    return '$player a fost în lot și n-a atins mingea. Vrea să știe de ce.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player nu e în lot și nu înțelege de ce. Vrea un răspuns clar, într-un fel sau altul.';
  }

  @override
  String grievanceRole(String player) {
    return '$player e folosit mereu pe alt post și s-a săturat.';
  }

  @override
  String get grievanceReassure => 'Faci parte din planurile mele';

  @override
  String get grievanceHonest => 'Alții sunt înaintea ta, și iată de ce';

  @override
  String get grievanceDismiss => 'Eu fac echipa';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name a dat $goals dintre ele. Nimeni nu se apropie.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals pentru $name. El duce echipa asta în spate.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals azi. Ce jucător.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$goals le-a băgat $name. Jos pălăria.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals pentru $name, iar restul au fost pasageri.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Iar $name. $goals. Imaginați-vă echipa asta fără el.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals de la $name. Un singur om n-ar trebui să facă atât.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Scoateți-l pe $name din ecuație și sunt $goals goluri mai puțin și o cu totul altă după-amiază.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count la rând. Orice se spune în vestiarul ăla, prinde.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Asta înseamnă $count consecutive. Echipele nu dau peste asemenea serii din întâmplare.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count la rând și seria continuă. Încrederea se vede din tribune.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Nicio înfrângere în ultimele $count. Întrebați orice antrenor: asta e partea grea.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count la rând. Bucurați-vă cât timp programul e blând.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count consecutive, și n-am bătut pe nimeni important.';
  }

  @override
  String yWinStreak6(String count) {
    return 'O serie de $count. Mai întrebați-mă când va fi testată.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count la rând. Orice echipă are o dată o asemenea serie în ea.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count meciuri fără victorie. La un moment dat, scuzele se termină.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Asta înseamnă $count la rând pierdute. Nu mai e un accident.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count înfrângeri la rând. Cineva trebuie să dea socoteală.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Nicio victorie în ultimele $count. Se vede în felul în care joacă.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count fără victorie și aceleași greșeli în fiecare săptămână.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count la rând. Orice se încearcă, nu merge.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count consecutive. E o direcție, nu o pasă proastă.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Nicio victorie în ultimele $count, și nimeni de sus n-a zis un cuvânt.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Spuneți ce vreți despre fotbal. Ăsta contează dublu.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Tocmai cu $opponent. $score. Nimeni de aici nu va uita.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score cu $opponent. Despre ăsta se va vorbi prin cârciumi.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Vecinii, $score. Dreptul la laudă e lămurit pentru o vreme.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Orice s-ar mai întâmpla anul ăsta, rămâne asta.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score cu $opponent. Unii dintre noi aveam mai mare nevoie de asta decât clasamentul.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Și și-o vor lua înapoi data viitoare, mereu o fac.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Cu $opponent, $score. Un an întreg în care ni se va aminti de ăsta.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name iese accidentat. Ultimul lucru de care avea nevoie echipa asta.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Pierderea lui $name schimbă totul.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name șchiopătează. Țineți-vă respirația.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Deci fără $name o vreme. Cineva trebuie să facă un pas în față.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name indisponibil. Bineînțeles că e $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Fără $name, asta devine o echipă foarte obișnuită.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name iar accidentat. Cineva ar trebui să întrebe de ce.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'L-am pierdut pe $name și nu e nimeni în spatele lui. Asta e adevărata problemă.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Roșu pentru $name în minutul $minute și toată țara sare pe el. Ne-a dat mai mult decât majoritatea. Lăsați-l.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name eliminat în minutul $minute. Dur. În zece oameni și tot am încercat, și asta spune ceva.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, minutul $minute, cartonaș roșu. În zece de acolo încolo.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Eliminare: $name în minutul $minute. Nu e primul meci care se întoarce după o singură decizie.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Minunat. $name pleacă în minutul $minute și rămânem în zece. Iar.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name eliminat în minutul $minute. Cine se ocupă exact de disciplină pe aici?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return 'Până în minutul $minute. Atât și-a putut păstra $name calmul. Fotbal profesionist.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Roșu pentru $name în minutul $minute, și ar trebui să cred că asta e progres.';
  }

  @override
  String get yBoardPressure0 =>
      'Federația a amuțit. Nu e niciodată un semn bun.';

  @override
  String get yBoardPressure1 =>
      'Se zice că la federație au început întrebările.';

  @override
  String get yBoardPressure2 =>
      'Se simte cum se mișcă pământul sus, la conducere.';

  @override
  String get yBoardPressure3 =>
      'Nimeni de la federație nu spune nimic de susținere. Trageți singuri concluziile.';

  @override
  String get yBoardPressure4 =>
      'Nimeni de sus nu l-a mai susținut public de săptămâni bune.';

  @override
  String get yBoardPressure5 =>
      'Federația lucrează pe la spate împotriva propriului selecționer. Ca de obicei.';

  @override
  String get yBoardPressure6 => 'Când o conducere tace, a decis deja.';

  @override
  String get yBoardPressure7 =>
      'O să lase lucrurile să meargă de la sine până când decizia va fi a altcuiva.';

  @override
  String get yReplies => 'TOT DESPRE ACEST MECI';

  @override
  String get yPlayerGrievance0 =>
      'Am întrebat care e situația mea. Încă aștept un răspuns.';

  @override
  String get yPlayerGrievance1 =>
      'Mă antrenez din greu. Nu prea pot face altceva.';

  @override
  String get yPlayerGrievance2 =>
      'Unele întrebări le poți pune o singură dată.';

  @override
  String get yPlayerGrievance3 => 'N-am ajuns până aici ca să car vestele.';

  @override
  String get playerHonoursTitle => 'PALMARES';

  @override
  String get awardGoldenBall => 'Balonul de Aur';

  @override
  String get awardGoldenBoot => 'Gheata de Aur';

  @override
  String get awardGoldenGlove => 'Mănușa de Aur';

  @override
  String get awardTeamOfTournament => 'Echipa turneului';

  @override
  String get awardPlayerOfYear => 'Jucătorul mondial al anului';

  @override
  String get awardYoungPlayerOfYear => 'Tânărul jucător al anului';

  @override
  String get playerClubHistory => 'ISTORIC LA CLUBURI';

  @override
  String get playerCareerRecord => 'BILANȚUL CARIEREI';

  @override
  String get playerInternationalGoals => 'Goluri la națională';

  @override
  String get playerRecentForm => 'FORMA RECENTĂ';

  @override
  String get playerMatchHistory => 'ISTORIC MECIURI';

  @override
  String get playerAttributes => 'ATRIBUTE';

  @override
  String get playerUnknown => 'Necunoscut';

  @override
  String get playerAttrPace => 'Viteză';

  @override
  String get playerAttrPhysical => 'Fizic';

  @override
  String get playerAttrTechnical => 'Tehnică';

  @override
  String get playerAttrShooting => 'Șut';

  @override
  String get playerAttrPassing => 'Pase';

  @override
  String get playerAttrDribbling => 'Dribling';

  @override
  String get playerAttrTackling => 'Deposedare';

  @override
  String get playerAttrPositioning => 'Plasament';

  @override
  String get playerAttrComposure => 'Calm';

  @override
  String get playerAttrDecisions => 'Decizii';

  @override
  String get playerAttrStamina => 'Rezistență';

  @override
  String get playerAttrStrength => 'Forță';

  @override
  String get playerStatCaps => 'Selecții';

  @override
  String get playerStatGoals => 'Goluri';

  @override
  String get playerStatAssists => 'Pase decisive';

  @override
  String get playerStatAvgRating => 'Notă medie';

  @override
  String get playerStatForm => 'Formă';

  @override
  String get playerStatMotm => 'Omul meciului';

  @override
  String get playerStatCleanSheets => 'Fără gol primit';

  @override
  String get playerStatBestGame => 'Cel mai bun meci';

  @override
  String get playerStatCards => 'Cartonașe';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}G ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'PARCURSUL DVS.';

  @override
  String get tourSharedList => 'Listă';

  @override
  String get tourSharedBracket => 'Tablou';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Grupa $seed';
  }

  @override
  String get tourSharedThisEdition => 'Această ediție';

  @override
  String get tourSharedAllTime => 'Din toate timpurile';

  @override
  String get tourSharedUnknown => 'Necunoscut';

  @override
  String get tourSharedActive => 'ACTIV';

  @override
  String get tourSharedMedalTable => 'CLASAMENTUL MEDALIILOR';

  @override
  String get tourSharedPastWinners => 'CÂȘTIGĂTORI ANTERIORI';

  @override
  String tourSharedHost(String host) {
    return 'Gazdă: $host';
  }

  @override
  String get tourSharedBeat => 'a învins';

  @override
  String get tourSharedPens => ' (d.l.d.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Premiile se decid după ce turneul se încheie.';

  @override
  String get tourSharedGoldenBall => 'BALONUL DE AUR';

  @override
  String get tourSharedPlayerOfTournament => 'Jucătorul turneului';

  @override
  String get tourSharedGoldenBoot => 'GHEATA DE AUR';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de goluri',
      few: '$count goluri',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'MĂNUȘA DE AUR';

  @override
  String get tourSharedTeamOfTournament => 'ECHIPA TURNEULUI';

  @override
  String get tourSharedStatsEmpty =>
      'Recordurile apar după ce competiția are puțin istoric.';

  @override
  String get tourSharedRecordScorer => 'GOLGHETER RECORD';

  @override
  String get tourSharedStillActive => 'încă activ';

  @override
  String get tourSharedMostTitles => 'CELE MAI MULTE TITLURI';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de titluri',
      few: '$count titluri',
      one: '1 titlu',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'CELE MAI MULTE FINALE';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de finale jucate',
      few: '$count finale jucate',
      one: '1 finală jucată',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'CELE MAI MULTE MECIURI';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de meciuri',
      few: '$count meciuri',
      one: '1 meci',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'CELE MAI MULTE TURNEE FINALE';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de turnee finale',
      few: '$count turnee finale',
      one: '1 turneu final',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'CEA MAI MARE VICTORIE ÎN FINALĂ';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de goluri',
      few: '$count goluri',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'încă activ';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de titluri',
      few: '$count titluri',
      one: '1 titlu',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de finale jucate',
      few: '$count finale jucate',
      one: '1 finală jucată',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de meciuri',
      few: '$count meciuri',
      one: '1 meci',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de turnee finale',
      few: '$count turnee finale',
      one: '1 turneu final',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'LIDERII ALL-TIME';

  @override
  String get tourStatsTabGames => 'Meciuri';

  @override
  String get tourStatsTabCups => 'Ediții';

  @override
  String get tourStatsTabScorers => 'Marcatori';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'cu $opponent · $year';
  }

  @override
  String get tourHolders => 'DEȚINĂTOARE';

  @override
  String tourHoldersSince(int year) {
    return 'câștigat în $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'GOLGHETERII ALL-TIME';

  @override
  String get tourSharedSummaryEmpty =>
      'Gazda și stadioanele apar după tragerea la sorți a acestei ediții.';

  @override
  String get tourSharedHostHeading => 'GAZDĂ';

  @override
  String get tourSharedHostsHeading => 'GAZDE';

  @override
  String get tourSharedCoHostsHeading => 'CO-GAZDE';

  @override
  String get tourSharedVenues => 'STADIOANE';

  @override
  String get tourSharedMascot => 'MASCOTĂ';

  @override
  String get tourSharedMatchBall => 'MINGEA OFICIALĂ';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity locuri';
  }

  @override
  String get tourSharedCouldNotLoad => 'Nu s-a putut încărca.';

  @override
  String get tourSharedHostTbc => 'GAZDĂ NECONFIRMATĂ';

  @override
  String get tourSharedFinalsAreHere => 'TURNEUL FINAL A SOSIT';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'GAZDĂ:  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Să înceapă turneul final';

  @override
  String get tourSharedCompetitions => 'COMPETIȚII';

  @override
  String get tourSharedWorldRanking => 'Clasamentul mondial';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Turneele nu au putut fi încărcate.';

  @override
  String get tourSharedPrestigeStage => 'SCENA PRESTIGIULUI';

  @override
  String get tourSharedOverview => 'Privire de ansamblu';

  @override
  String get tourSharedWorldRankingTitle => 'Clasamentul mondial';

  @override
  String get tourSharedYourCompetitions => 'COMPETIȚIILE DVS.';

  @override
  String get tourSharedOtherContinents => 'ALTE CONTINENTE';

  @override
  String get tourSharedComingSoon => 'Turneul vine în curând';

  @override
  String get tourSharedSoon => 'CURÂND';

  @override
  String get tourSharedNoQualifyingDraw =>
      'Nicio tragere la sorți pentru preliminarii.';

  @override
  String get tourSharedOpenEnvelope => 'Deschideți plicul';

  @override
  String tourSharedGroupName(String name) {
    return 'GRUPA $name';
  }

  @override
  String get tourSharedBall => 'Bilă';

  @override
  String get tourSharedPot => 'Urnă';

  @override
  String get tourSharedAll => 'Tot';

  @override
  String get tourSharedTapDrawTeam =>
      'Atingeți ca să extrageți următoarea echipă';

  @override
  String get tourSharedTapDrawPot => 'Atingeți ca să extrageți următoarea urnă';

  @override
  String get tourSharedTapDrawAll => 'Atingeți ca să dezvăluiți toată tragerea';

  @override
  String get tourSharedContinue => 'Continuați';

  @override
  String get tourSharedPause => 'Pauză';

  @override
  String get tourSharedPlay => 'Redare';

  @override
  String get tourSharedSkip => 'Săriți';

  @override
  String tourSharedPotNumber(int number) {
    return 'URNA $number';
  }

  @override
  String get tourSharedDrawComplete => 'TRAGERE ÎNCHEIATĂ';

  @override
  String get tourSharedDrawing => 'SE EXTRAGE…';

  @override
  String get tourContChampionship => 'CAMPIONAT';

  @override
  String get tourContTabSummary => 'REZUMAT';

  @override
  String get tourContTabQualifying => 'PRELIMINARII';

  @override
  String get tourContTabFinals => 'TURNEU FINAL';

  @override
  String get tourContTabBracket => 'TABLOU';

  @override
  String get tourContTabAwards => 'PREMII';

  @override
  String get tourContTabScorers => 'MARCATORI';

  @override
  String get tourContTabHistory => 'ISTORIE';

  @override
  String get tourContTabRecords => 'RECORDURI';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Cupa nu a putut fi încărcată.\n$error';
  }

  @override
  String get tourContNoCupData => 'Nicio dată despre cupă.';

  @override
  String get tourContUnknown => 'Necunoscut';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Grupele preliminariilor se trag la sorți la ceremonie. Urmăriți din Centru ca să vedeți cu cine jucați.';

  @override
  String get tourContQualSeeded =>
      'Națiunea dvs. e calificată direct la turneul final. Fără preliminarii în acest ciclu.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name este simulat în fundal. Rezultatele apar aici pe măsură ce se joacă fiecare rundă.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Grupele turneului final se trag la sorți la ceremonie. Urmăriți din Centru ca să vă vedeți grupa.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Tragerea la sorți a turneului final are loc după încheierea preliminariilor.';

  @override
  String get tourContContestedBeforeWc =>
      'Fazele eliminatorii se joacă înaintea Campionatului Mondial.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name · CAMPIOANE';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name · câștigătoare';
  }

  @override
  String get tourContNoGoalsYet => 'Niciun gol marcat încă.';

  @override
  String tourContGroupHeading(String name) {
    return 'GRUPA $name';
  }

  @override
  String get tourContBestRunnersUp => 'CELE MAI BUNE LOCURI DOI';

  @override
  String tourContGroupDropdown(String name) {
    return 'Grupa $name';
  }

  @override
  String get tourContMatches => 'MECIURI';

  @override
  String get tourContNoGroupsDrawn => 'Nicio grupă trasă la sorți încă.';

  @override
  String get tourContQualifyingDraw => 'TRAGEREA PRELIMINARIILOR';

  @override
  String get tourContWorldQualifyingDraw => 'TRAGEREA PRELIMINARIILOR MONDIALE';

  @override
  String get tourContFinalsDraw => 'TRAGEREA TURNEULUI FINAL';

  @override
  String get tourContSeedingPots => 'URNE VALORICE';

  @override
  String get tourContGroupDraw => 'TRAGEREA GRUPELOR';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Tragerea la sorți nu a putut fi încărcată.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Tragerea la sorți nu este gata încă.';

  @override
  String get tourContContinentalClash => 'DUELUL CONTINENTELOR';

  @override
  String get tourContTabThisCycle => 'ACEST CICLU';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Nu s-a putut încărca.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Salvarea nu a fost găsită.';

  @override
  String get tourContClashSoon =>
      'Duelul Continentelor se joacă după ce ambele campioane continentale sunt cunoscute.';

  @override
  String get tourContTwoContinentsOneMatch => 'DOUĂ CONTINENTE, UN MECI';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name câștigă Duelul';
  }

  @override
  String get tourContNoClashYet => 'Niciun Duel al Continentelor jucat încă.';

  @override
  String get tourContNationsCup => 'CUPA NAȚIUNILOR';

  @override
  String get tourContTabLeagues => 'LIGI';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Nu s-a putut încărca.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Niciun gol în Cupa Națiunilor înregistrat încă.';

  @override
  String get tourContNoNationsCupChampions =>
      'Nicio campioană a Cupei Națiunilor încoronată încă.';

  @override
  String get tourContNationsCupOffSeason =>
      'Cupa Națiunilor din acest ciclu începe după turneul final continental. Câștigătoarele anterioare sunt la Istorie.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Grupele Cupei Națiunilor din acest ciclu se trag la sorți la ceremonie. Urmăriți din Centru ca să vedeți cu cine jucați.';

  @override
  String get tourContLeagueNoGroups =>
      'Niciun meci în această ligă în runda aceasta.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LIGA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LIGA $letter · LIGA DVS.';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Final Four se dispută între câștigătoarele grupelor din Liga A, după faza grupelor.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Liga $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Liga $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEMIFINALE';

  @override
  String get tourContFinal => 'FINALA';

  @override
  String get tourContNationsCupDraw => 'TRAGEREA CUPEI NAȚIUNILOR';

  @override
  String get tourContIntercontinentalPlayoff => 'BARAJ INTERCONTINENTAL';

  @override
  String get tourContNoPlayoffThisCycle => 'Niciun baraj în acest ciclu.';

  @override
  String get tourContPlayoffIntro =>
      'Două locuri la Campionatul Mondial decise printr-un turneu eliminatoriu între cele mai bune echipe necalificate.';

  @override
  String get tourContPlayoffThrough =>
      'Ați trecut de baraj. Mergeți la Campionatul Mondial!';

  @override
  String get tourContPlayoffOut =>
      'Ați ratat barajul. Fără Campionat Mondial de data asta.';

  @override
  String get tourContContinue => 'Continuați';

  @override
  String get tourContPlayoffFinals => 'FINALELE BARAJULUI';

  @override
  String get tourContPlayoffSeeded => 'Cap de serie (calificată direct)';

  @override
  String get tourCupTabSummary => 'REZUMAT';

  @override
  String get tourCupTabQualifying => 'PRELIMINARII';

  @override
  String get tourCupTabPlayoff => 'BARAJ';

  @override
  String get tourCupPlayoffSoon =>
      'Barajul intercontinental se decide după încheierea preliminariilor din fiecare confederație.';

  @override
  String get tourCupTabFinals => 'TURNEU FINAL';

  @override
  String get tourCupTabBracket => 'TABLOU';

  @override
  String get tourCupTabAwards => 'PREMII';

  @override
  String get tourCupTabScorers => 'MARCATORI';

  @override
  String get tourCupTabHistory => 'ISTORIE';

  @override
  String get tourCupTabRecords => 'RECORDURI';

  @override
  String get tourCupTitle => 'CAMPIONATUL MONDIAL';

  @override
  String get tourCupNoData => 'Nicio dată despre cupă.';

  @override
  String tourCupLoadError(String error) {
    return 'Cupa nu a putut fi încărcată.\n$error';
  }

  @override
  String get tourCupUnknown => 'Necunoscut';

  @override
  String get tourCupWorldChampions => 'CAMPIOANA MONDIALĂ';

  @override
  String get tourCupWorldChampionsTitle => 'Campioanele mondiale';

  @override
  String get tourCupStillActive => 'Încă activ';

  @override
  String get tourCupAllTimeScorers => 'GOLGHETERII ALL-TIME';

  @override
  String get tourCupAllConfederations => 'Toate confederațiile';

  @override
  String get tourCupBestRunnersUp => 'Cele mai bune locuri doi';

  @override
  String get tourCupCompWorld => 'Campionatul Mondial';

  @override
  String get tourCupCompEurope => 'Campionatul European';

  @override
  String get tourCupCompSAmerica => 'Cupa Americii de Sud';

  @override
  String get tourCupDestRoundOf16 => 'optimi';

  @override
  String get tourCupDestKnockouts => 'eliminatorii';

  @override
  String get tourCupDestFinals => 'turneul final';

  @override
  String get tourCupDestFinalsPlayoff => 'barajul turneului final';

  @override
  String get tourCupDestIntercontPlayoff => 'barajul intercontinental';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Tragerea turneului final are loc după încheierea preliminariilor.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Grupele nu au fost trase încă. Urmăriți tragerea Campionatului Mondial din Centru ca să le aflați.';

  @override
  String tourCupGroupName(String name) {
    return 'Grupa $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Grupa $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Gazdă: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Gazde: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Baraj intercontinental';

  @override
  String get tourCupKnockoutSoon =>
      'Tabloul începe după încheierea fazei grupelor.';

  @override
  String get tourCupMatches => 'MECIURI';

  @override
  String get tourCupMedalTable => 'CLASAMENTUL MEDALIILOR';

  @override
  String get tourCupMostTitles => 'CELE MAI MULTE TITLURI';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    String _temp0 = intl.Intl.pluralLogic(
      titles,
      locale: localeName,
      other: '$titles de titluri',
      few: '$titles titluri',
      one: '1 titlu',
    );
    String _temp1 = intl.Intl.pluralLogic(
      editions,
      locale: localeName,
      other: '$editions de ediții',
      few: '$editions ediții',
      one: '1 ediție',
    );
    return '$nation: $_temp0 din $_temp1';
  }

  @override
  String get tourCupNoGoals => 'Niciun gol încă.';

  @override
  String get tourCupNoGroups => 'Nicio grupă trasă la sorți.';

  @override
  String get tourCupNoHistory => 'Niciun istoric încă.';

  @override
  String get tourCupPastWinners => 'CÂȘTIGĂTORI ANTERIORI';

  @override
  String get tourCupPlayoffIntro =>
      'Două locuri la Campionatul Mondial decise printr-un turneu eliminatoriu între cele mai bune echipe necalificate.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation nu are baraj: toate locurile se decid în grupele preliminare.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Grupele nu au fost trase încă. Urmăriți tragerea preliminariilor din Centru ca să le aflați.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · a dvs.';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (d.l.d.)';
  }

  @override
  String get tourCupSegAllTime => 'Din toate timpurile';

  @override
  String get tourCupSegFinals => 'Turneu final';

  @override
  String get tourCupSegQualifying => 'Preliminarii';

  @override
  String get playerTraitsTitle => 'CUNOSCUT PENTRU';

  @override
  String get traitBigGame => 'Jucător de meciuri mari';

  @override
  String get traitBigGameBlurb => 'Crește în meciurile eliminatorii.';

  @override
  String get traitSetPiece => 'Specialist la faze fixe';

  @override
  String get traitSetPieceBlurb =>
      'Centrări mai bune și mai multe goluri din faze fixe.';

  @override
  String get traitHothead => 'Impulsiv';

  @override
  String get traitHotheadBlurb =>
      'Primește mult mai multe cartonașe decât coechipierii.';

  @override
  String get traitIronMan => 'Omul de fier';

  @override
  String get traitIronManBlurb => 'Se accidentează rar și obosește mai încet.';

  @override
  String get traitWonderkid => 'Copil-minune';

  @override
  String get traitWonderkidBlurb => 'Tânăr, deja bun și încă în progres rapid.';

  @override
  String get traitLeader => 'Lider';

  @override
  String get traitLeaderBlurb => 'Îi ridică pe toți coechipierii de pe teren.';

  @override
  String get traitPacey => 'Rapid';

  @override
  String get traitPaceyBlurb =>
      'Viteză amețitoare, o amenințare în spatele apărării.';

  @override
  String get traitOldHead => 'Veteran';

  @override
  String get traitOldHeadBlurb =>
      'Un veteran a cărui citire a jocului rezistă mai mult decât picioarele.';

  @override
  String get traitWasteful => 'Risipitor';

  @override
  String get traitWastefulBlurb => 'Ratează prea multe ocazii bune.';

  @override
  String get objectiveWorldCup => 'Campionatul Mondial';

  @override
  String get objectiveWinTournament => 'Câștigarea turneului';

  @override
  String get objectiveQualifyGeneric => 'Calificarea';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Câștigarea Campionatului Mondial';

  @override
  String get objectiveReachFinal => 'Atingerea finalei';

  @override
  String get objectiveReachSemis => 'Atingerea semifinalelor';

  @override
  String get objectiveReachQuarters => 'Atingerea sferturilor';

  @override
  String get objectiveReachKnockouts => 'Atingerea fazei eliminatorii';

  @override
  String get objectiveQualify => 'Calificarea la Campionatul Mondial';

  @override
  String get finishChampions => 'Campioni';

  @override
  String get finishRunnersUp => 'Locul doi';

  @override
  String get finishSemiFinals => 'Semifinale';

  @override
  String get finishQuarterFinals => 'Sferturi';

  @override
  String get finishRoundOf16 => 'Optimi';

  @override
  String get finishGroupStage => 'Faza grupelor';

  @override
  String get objectiveQualifyingTopHalf =>
      'Prima jumătate a grupei preliminare';

  @override
  String get finishQualifyingTopHalf => 'Prima jumătate a grupei preliminare';

  @override
  String get finishQualifyingBottomHalf =>
      'A doua jumătate a grupei preliminare';

  @override
  String get objectiveNcWinIt => 'Câștigarea Cupei Națiunilor';

  @override
  String get objectiveNcReachFinal => 'Atingerea finalei Cupei Națiunilor';

  @override
  String get objectiveNcFinalsFour => 'Atingerea Final Four';

  @override
  String get objectiveNcWinGroup => 'Câștigarea grupei și promovarea';

  @override
  String get objectiveNcTopHalf => 'Prima jumătate a grupei';

  @override
  String get objectiveNcSurvive => 'Evitarea retrogradării';

  @override
  String get objectiveNcOffTheBottom => 'Evitarea ultimului loc în grupă';

  @override
  String get finishNcChampions => 'Câștigătoarea Cupei Națiunilor';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Câștigătoarea grupei';

  @override
  String get finishNcTopHalf => 'Prima jumătate a grupei';

  @override
  String get finishNcStayedUp => 'Evitată retrogradarea';

  @override
  String get finishNcClearOfBottom => 'Evitat ultimul loc în grupă';

  @override
  String get finishNcBottom => 'Ultimul loc în grupă';

  @override
  String get careerNationsCupLabel => 'Cupa Națiunilor';

  @override
  String get squadDevPlayer => 'JUCĂTOR';

  @override
  String get squadDevAge => 'VÂRSTĂ';

  @override
  String get squadDevPosition => 'POST';

  @override
  String get squadDevChange => 'VALOARE';

  @override
  String get squadDevNew => 'NOU';

  @override
  String get squadDevRetired => 'RETRAS';

  @override
  String get squadDevEmpty => 'Un an liniștit. Nicio schimbare în lot.';

  @override
  String get squadDevTierRegulars => 'TITULARI';

  @override
  String get squadDevTierFringe => 'LA LIMITĂ';

  @override
  String get squadDevTierYouth => 'TINERET';

  @override
  String get boardObjectivesTitle => 'Obiectivele federației';

  @override
  String get boardObjectivesConfidence => 'Încrederea federației';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'cu $rounds de runde mai bine decât s-a cerut',
      few: 'cu $rounds runde mai bine decât s-a cerut',
      one: 'cu o rundă mai bine decât s-a cerut',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'la $rounds de runde distanță',
      few: 'la $rounds runde distanță',
      one: 'la o rundă distanță',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ÎNCĂ NEDECIS';

  @override
  String boardObjectiveSoFar(String result) {
    return 'PÂNĂ ACUM · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Federația nu a stabilit niciun obiectiv pentru acest ciclu.';

  @override
  String get tourContBestWinners => 'CELE MAI BUNE CÂȘTIGĂTOARE DE GRUPĂ';

  @override
  String get tourContBestThirds => 'CELE MAI BUNE LOCURI TREI';

  @override
  String tourContBestPlaced(String position) {
    return 'CELE MAI BUNE DE PE LOCUL $position';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total jucători';
  }

  @override
  String get matchSoldOut => 'SOLD OUT';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance din $capacity locuri ocupate';
  }

  @override
  String get matchGroundTitle => 'STADION';

  @override
  String get absenceInjured => 'Accidentat';

  @override
  String get absenceSuspended => 'Suspendat';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString de săptămâni',
      few: '$countString săptămâni',
      one: '1 săptămână',
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
      other: '$countString de meciuri',
      few: '$countString meciuri',
      one: '1 meci',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Revine pentru meciul cu $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Penalty-uri';

  @override
  String get penaltyOrderBlurb =>
      'Numiți cei cinci executanți, în ordine. Atingeți un loc ca să-l schimbați.';

  @override
  String penaltyOrderPick(int number) {
    return 'Lovitura $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Alegeți cine execută. Bara arată calmul lor de la punctul cu var.';

  @override
  String get penaltyOrderConfirm => 'Începem';

  @override
  String get penaltyOrderCancel => 'Înapoi';

  @override
  String get youthTitle => 'Tineret';

  @override
  String get youthEmptyLevel => 'Nimeni la acest nivel încă.';

  @override
  String get youthReleased => 'Lăsați liberi anul acesta';

  @override
  String get u21Title => 'Sub 21 de ani';

  @override
  String get u21Blurb =>
      'Următoarea generație, cel mai bun talent primul. Stelele goale sunt o estimare a scouterului. Convocați un jucător ca să aflați ce poate cu adevărat.';

  @override
  String get u21Empty =>
      'Niciun jucător sub 21 de ani în rezervor acum. Următoarea generație vine odată cu noul ciclu.';

  @override
  String u21Breakout(int gain) {
    return '+$gain ANUL ACESTA';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return '$age ani · $caps selecții';
  }

  @override
  String u21AgeUncapped(int age) {
    return '$age ani · neselecționat';
  }

  @override
  String get u21CallUps => 'Mergeți la convocări';

  @override
  String get youthWatching => 'Urmăriți';

  @override
  String get youthWatchEmpty =>
      'Niciun jucător marcat încă. Marcați un băiat de la orice nivel și va apărea aici, cu ce a devenit între timp.';

  @override
  String get youthWatchMark => 'Urmăriți acest băiat';

  @override
  String get youthWatchUnmark => 'Nu-l mai urmăriți';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Marcat la $rating, la $age ani';
  }

  @override
  String get youthWatchSenior => 'A ajuns la seniori';

  @override
  String get youthWatchReleased => 'Lăsat liber de academie';

  @override
  String get youthWatchGone => 'Nu mai e în piramidă';

  @override
  String get tacticsYouth => 'Sub 21 de ani';

  @override
  String get pressSquad => 'Lot';

  @override
  String get pressBoard => 'Federație';

  @override
  String get pressNoEffect => 'Nimeni nu dă prea mare importanță';

  @override
  String get matchNeutralGround => 'NEUTRU';

  @override
  String get matchExtraTimeAhead => 'PRELUNGIRI';

  @override
  String get matchExtraTimeHalf => 'PRELUNGIRI · PAUZĂ';

  @override
  String get matchClockFullTime => 'FINAL';

  @override
  String get matchClockAfterExtraTime => 'DUPĂ PRELUNGIRI';

  @override
  String get matchClockPenalties => 'PENALTY-URI';

  @override
  String get matchClockFullTimePenalties => 'FINAL · PENALTY-URI';

  @override
  String get hubEventPressConference => 'Înfruntați presa';

  @override
  String get hubEventPressConferenceSub =>
      'Presa internațională vrea o declarație înaintea primului meci';

  @override
  String get squadDevWonderkid => 'COPIL-MINUNE';

  @override
  String get tacticsPlaystyle => 'Stil de joc';

  @override
  String get tacticsPlaystyleBlurb =>
      'Alegeți cum joacă echipa; reglajele de mai jos îl ajustează.';

  @override
  String get tacticsPlaystyleCustom =>
      'Setările dvs. Niciun stil cu nume nu se potrivește acestor reglaje.';

  @override
  String get playstyleCustom => 'Personalizat';

  @override
  String get playstyleBalanced => 'Echilibrat';

  @override
  String get playstylePossession => 'Posesie';

  @override
  String get playstyleGegenpress => 'Gegenpressing';

  @override
  String get playstyleCounter => 'Contraatac';

  @override
  String get playstyleDirect => 'Direct';

  @override
  String get playstyleLowBlock => 'Bloc jos';

  @override
  String get playstyleWingPlay => 'Joc pe flancuri';

  @override
  String get playstyleBalancedBlurb =>
      'Solid în ambele jumătăți, fără exagerări.';

  @override
  String get playstylePossessionBlurb =>
      'Păstrați mingea, circulați-o cu răbdare, strângeți terenul.';

  @override
  String get playstyleGegenpressBlurb =>
      'Recuperați mingea imediat ce ați pierdut-o, sus pe teren.';

  @override
  String get playstyleCounterBlurb =>
      'Stați retrași, compacți, apoi ieșiți rapid.';

  @override
  String get playstyleDirectBlurb =>
      'Mingea repede în față și jocul pe a doua minge.';

  @override
  String get playstyleLowBlockBlurb =>
      'Jos, strâns și foarte greu de străpuns.';

  @override
  String get playstyleWingPlayBlurb =>
      'Lărgiți terenul, treceți pe exterior și centrați.';

  @override
  String get nationsRandomTeam => 'Echipă aleatorie';

  @override
  String get nationsFromTheBottom => 'De jos în sus';

  @override
  String get bottomStartTitle => 'Fără loc de muncă';

  @override
  String get bottomStartHeading => 'Trei federații vor să discute';

  @override
  String get bottomStartBlurb =>
      'Nu aveți post și nici reputație. Acestea sunt singurele echipe dispuse să riște cu dvs. Alegeți una și construiți ceva din nimic.';

  @override
  String get bottomStartAccept => 'Acceptați';

  @override
  String get bottomStartBack => 'Înapoi la meniu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return 'Locul $rank din $total în lume';
  }

  @override
  String get campTitle => 'Cantonament';

  @override
  String campBasedIn(String host) {
    return 'Cu baza în $host';
  }

  @override
  String get campBlurb =>
      'Locul unde lotul stă tot turneul. Nu poate fi schimbat după începerea jocurilor și contează la fiecare meci în trei privințe: cât de odihniți ajung jucătorii, cât de repede se vindecă o lovitură și cât de bine pregătiți sunt.';

  @override
  String get campEffectTravel => 'Prospețime';

  @override
  String get campEffectRecovery => 'Recuperare';

  @override
  String get campEffectSharpness => 'Ritm de joc';

  @override
  String get campTerrainCity => 'Centrul orașului';

  @override
  String get campTerrainCoastal => 'Stațiune pe litoral';

  @override
  String get campTerrainMountain => 'Refugiu montan';

  @override
  String get campTerrainAltitude => 'Cantonament la altitudine';

  @override
  String get campTerrainNationalCentre => 'Centrul național';

  @override
  String get campTerrainCityBlurb =>
      'Totul la îndemână și nimic de călătorit, dar fără liniște și fără scăpare de zgomot.';

  @override
  String get campTerrainCoastalBlurb =>
      'Calm, confortabil și bun pentru moral; un drum lung cu autocarul până la fiecare stadion.';

  @override
  String get campTerrainMountainBlurb =>
      'Aer răcoros și o echipă medicală de top care pune repede pe picioare jucătorii, departe de turneu.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Antrenamente grele și picioare care rezistă până târziu în turneu.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Bazele proprii ale federației: nimic spectaculos, nimic care să meargă prost.';

  @override
  String get hubEventChooseCamp => 'Alegeți cantonamentul';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Unde va sta lotul în $host';
  }

  @override
  String get tacticsTabBench => 'Rezerve';

  @override
  String get squadSearchHint => 'Căutați după nume sau club';

  @override
  String get squadFilterAll => 'Toți';

  @override
  String get squadFilterInSquad => 'În lot';

  @override
  String get squadFilterUncapped => 'Neselecționați';

  @override
  String get squadFilterUnavailable => 'Indisponibili';

  @override
  String get squadLineAll => 'Toate liniile';

  @override
  String get squadSortBy => 'Sortare';

  @override
  String get squadSortRating => 'Valoare';

  @override
  String get squadSortCaps => 'Selecții';

  @override
  String get squadSortGoals => 'Goluri';

  @override
  String get squadSortAge => 'Vârstă';

  @override
  String get squadSortName => 'Nume';

  @override
  String get squadLegendTitle => 'Ce înseamnă semnele';

  @override
  String get squadLegendStarting => 'În primul 11';

  @override
  String get squadLegendCalledUp => 'Convocat, pe bancă';

  @override
  String get squadLegendRatingUp => 'Valoare în creștere anul acesta';

  @override
  String get squadLegendRatingDown => 'Valoare în scădere anul acesta';

  @override
  String get squadLegendInjured => 'Accidentat, indisponibil';

  @override
  String get squadLegendSuspended => 'Suspendat, indisponibil';

  @override
  String get squadLegendTraits => 'CUNOSCUT PENTRU';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Se afișează $shown din $total jucători';
  }

  @override
  String get squadNobodyMatches =>
      'Niciun jucător nu corespunde acestor filtre.';

  @override
  String get squadStatPool => 'Rezervor';

  @override
  String get squadStatInSquad => 'Convocați';

  @override
  String get squadMostCapped => 'Cele mai multe selecții';

  @override
  String get squadTopScorer => 'Golgheter';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps selecții';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals goluri';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Sel.';

  @override
  String get squadGoalsShort => 'Gol.';

  @override
  String get recordsRecordBookSubtitle =>
      'Selecții, goluri și marile recorduri ale echipei';

  @override
  String get statsLegacy => 'MOȘTENIRE';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name a fost deja înlocuit și nu mai poate reveni.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name a fost eliminat și nu mai participă la joc.';
  }

  @override
  String get tacticsInjuredShort => 'ACCIDENTAT';

  @override
  String get tacticsSuspendedShort => 'SUSPENDAT';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'America de Sud';

  @override
  String get confNorthAmerica => 'America de Nord';

  @override
  String get confAfrica => 'Africa';

  @override
  String get confAsia => 'Asia';

  @override
  String get confOceania => 'Oceania';

  @override
  String get compWorldCup => 'Campionatul Mondial';

  @override
  String get compWorldCupFinals => 'Turneul final al Campionatului Mondial';

  @override
  String get compWorldCupQualifying => 'Preliminariile Campionatului Mondial';

  @override
  String compQualifiers(String region) {
    return 'Preliminarii $region';
  }

  @override
  String get compFriendlies => 'Amicale';

  @override
  String get compNationsCup => 'Cupa Națiunilor';

  @override
  String get compContinentalClash => 'Duelul Continentelor';

  @override
  String get compIntercontinentalPlayoff => 'Barajul intercontinental';

  @override
  String get compContinentalChampionship => 'Campionatul continental';

  @override
  String get compEuropeanChampionship => 'Campionatul European';

  @override
  String get compSouthAmericaCup => 'Cupa Americii de Sud';

  @override
  String get compAfricanChampionship => 'Campionatul African';

  @override
  String get compAsianChampionship => 'Campionatul Asiatic';

  @override
  String get compNorthAmericaCup => 'Cupa Americii de Nord';

  @override
  String get compOceaniaCup => 'Cupa Oceaniei';

  @override
  String get msgANation => 'O națiune';

  @override
  String get msgAPlayer => 'Un jucător';

  @override
  String get msgAHostNation => 'o națiune gazdă';

  @override
  String get msgCycleTitle1 => 'Începe un nou ciclu';

  @override
  String msgCycleTitle2(int year) {
    return 'Se deschide drumul spre $year';
  }

  @override
  String get msgCycleTitle3 => 'Începe o nouă campanie';

  @override
  String get msgCycleTitle4 => 'Înapoi la treabă';

  @override
  String msgCycleBody1(int year) {
    return 'Drumul spre Campionatul Mondial $year începe aici.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Un nou ciclu. Ținta este Campionatul Mondial $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Patru ani până la Campionatul Mondial $year. Munca începe acum.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Campania $year începe astăzi.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup, gazdă: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return 'Gazda următoarei ediții $cup: $host.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup: tragerea preliminariilor';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Grupele preliminare pentru $cup au fost trase la sorți.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Gazda Campionatului Mondial $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host va găzdui Campionatul Mondial $year.';
  }

  @override
  String get msgWcQualDrawTitle =>
      'Tragerea preliminariilor Campionatului Mondial';

  @override
  String get msgWcQualDrawBody =>
      'Grupele preliminariilor Campionatului Mondial au fost trase la sorți.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup: tragerea turneului final';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return '$cup: grupele turneului final au fost trase la sorți.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Tragerea turneului final al Campionatului Mondial';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'A avut loc tragerea la sorți a turneului final al Campionatului Mondial $year.';
  }

  @override
  String get msgQualWcTitle1 => 'Calificați la Campionatul Mondial';

  @override
  String get msgQualWcTitle2 => 'Biletul pentru Campionatul Mondial e rezervat';

  @override
  String get msgQualWcTitle3 => 'Mergem la Campionatul Mondial';

  @override
  String get msgQualWcTitle4 => 'Biletul e în buzunar';

  @override
  String msgQualWcBody1(int year) {
    return 'V-ați calificat la turneul final al Campionatului Mondial $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'E oficial: națiunea dvs. va fi la Campionatul Mondial $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Locul la Campionatul Mondial $year este asigurat.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Sunteți la turneul final al Campionatului Mondial $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Calificați: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup: bilet rezervat';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Calificați la $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'V-ați calificat la turneul final: $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Națiunea dvs. și-a asigurat locul la $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Mergeți la $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return 'CAMPIONI: $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Campioni: $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Ați câștigat $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: s-a decis';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: campioana a fost încoronată';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp: trofeul și-a găsit stăpânul';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Națiunea dvs. a câștigat $comp $year, învingând $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Ați câștigat $comp $year, trecând de $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return 'Trofeul e al dvs.: $comp $year, după ce ați trecut de $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner a câștigat $comp $year, învingând $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner este campioana ediției $comp $year, după ce a trecut de $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' cu $home–$away în finală';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' la penalty-uri, după $home–$away în finală';
  }

  @override
  String get msgWpotyTitle => 'Jucătorul mondial al anului';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) este jucătorul mondial al anului $year, unul dintre jucătorii dvs.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) este jucătorul mondial al anului $year.';
  }

  @override
  String get msgYpotTitle => 'Tânărul jucător al turneului';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age ani, este tânărul jucător al turneului în $year, unul dintre jucătorii dvs.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age ani, este tânărul jucător al turneului în $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Rămâneți pe locul #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Nicio schimbare, tot #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabili pe #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move de locuri',
      few: '$move locuri',
      one: '1 loc',
    );
    return 'Urcare de $_temp0 în total, până pe #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move de locuri',
      few: '$move locuri',
      one: '1 loc',
    );
    return 'Un salt de $_temp0 vă duce pe #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move de locuri',
      few: '$move locuri',
      one: '1 loc',
    );
    return 'Urcare de $_temp0, acum #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move de locuri',
      few: '$move locuri',
      one: '1 loc',
    );
    return 'Coborâre de $_temp0 în total, până pe #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move de locuri',
      few: '$move locuri',
      one: '1 loc',
    );
    return 'O cădere de $_temp0 vă trimite pe #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move de locuri',
      few: '$move locuri',
      one: '1 loc',
    );
    return 'Coborâre de $_temp0, acum #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Sunteți pe primul loc în lume.';

  @override
  String msgRankLeadOther(String nation) {
    return 'Lider mondial: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Clasamentul mondial · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Clasamentul mondial a fost actualizat. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Urcare pe #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Cădere pe #$rank';
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
      other: '$move de locuri',
      few: '$move locuri',
      one: '1 loc',
    );
    return '$tournament a schimbat clasamentul mondial. $nation a intrat de pe #$from și a ieșit pe #$to, o urcare de $_temp0.';
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
      other: '$move de locuri',
      few: '$move locuri',
      one: '1 loc',
    );
    return '$tournament a schimbat clasamentul mondial. $nation a intrat de pe #$from și a ieșit pe #$to, o cădere de $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'De la tragerea Campionatului Mondial';

  @override
  String get rankingSinceCycleStart => 'De la începutul campaniei';

  @override
  String rankingMovedFromTo(int from, int now) {
    return 'De pe #$from pe #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de selecții',
      few: '$count selecții',
      one: '1 selecție',
    );
    return '$name ajunge la $_temp0';
  }

  @override
  String msgCapsBody(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de meciuri',
      few: '$count meciuri',
      one: '1 meci',
    );
    return '$name are acum $_temp0 pentru națiunea dvs.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de goluri',
      few: '$count goluri',
      one: '1 gol',
    );
    return '$name ajunge la $_temp0';
  }

  @override
  String msgGoalsBody(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de goluri',
      few: '$count goluri',
      one: '1 gol',
    );
    return '$name a marcat $_temp0 la națională pentru țara dvs.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Evoluția lotului · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Promovați din academie · $year';
  }

  @override
  String get msgThroughNote =>
      'Nu sunt o generație nouă. Sunt băieții care au intrat la unsprezece ani și acum au crescut până la seniori.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Fețe noi · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Investiția în academie se vede: această generație a venit mai puternică decât ar fi venit altfel.';

  @override
  String get msgIntakeNoteStanding =>
      'Țara urmărește echipa: cu naționala urcând în clasamentul mondial, cei mai buni băieți aleg fotbalul, iar această generație a venit mai puternică.';

  @override
  String get msgIntakeNoteBoth =>
      'Banii puși în academie și urcarea echipei în clasamentul mondial se văd amândouă: această generație a venit mai puternică decât ar fi venit altfel.';

  @override
  String msgIntakeTitle(int year) {
    return 'Generația academiei · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Căpitanul $name se retrage';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name se retrage de la națională';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name s-a retras de la echipa națională la $age ani.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name s-a retras de la echipa națională la $age ani, încheind cu $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de selecții',
      few: '$count selecții',
      one: '1 selecție',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de goluri',
      few: '$count goluri',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Banderola este liberă. Numiți un nou căpitan din ecranul de convocări.';

  @override
  String msgHofTitle(String name) {
    return '$name intră în Galeria Faimei';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name intră în Galeria Faimei națiunii dvs. (selecții: $caps, goluri: $goals). Îl găsiți la Legende.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name suspendat';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'pentru următoarele $matches de meciuri',
      few: 'pentru următoarele $matches meciuri',
      one: 'pentru următorul meci',
    );
    return '$name $how și este suspendat $_temp0. Nu va putea fi selecționat.';
  }

  @override
  String get hubBanHowSecondYellow => 'a fost eliminat după al doilea galben';

  @override
  String get hubBanHowViolent =>
      'a primit roșu direct pentru comportament violent';

  @override
  String get hubBanHowRed => 'a fost eliminat';

  @override
  String hubInjuryTitle(String name) {
    return '$name accidentat';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches de meciuri',
      few: '$matches meciuri',
      one: '1 meci',
    );
    return '$name s-a accidentat și lipsește $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Locul doi';

  @override
  String get hubRunnerUpTitle2 => 'Atât de aproape și totuși atât de departe';

  @override
  String get hubRunnerUpTitle3 => 'Medalii de argint';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Ați ajuns în finală la $cup, dar ați pierdut cu $opponent. Atât de aproape. Argint de data asta.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Învinși de $opponent în finală, la $cup. Locul doi, dureros de aproape.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Finala de la $cup v-a scăpat printre degete în fața echipei $opponent. Multe motive de mândrie, dar nu trofeul.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Eliminați';

  @override
  String get hubKnockedOutTitle2 => 'Capăt de drum';

  @override
  String get hubKnockedOutTitle3 => 'Călătoria s-a încheiat';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Ați fost eliminați din $cup de $opponent. Faza: $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent vă oprește drumul în $cup. Faza: $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup se încheie pentru dvs. în faza: $stage, după înfrângerea cu $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Eliminați în grupe';

  @override
  String get hubGroupExitTitle2 => 'Afară din faza grupelor';

  @override
  String get hubGroupExitTitle3 => 'Plecare devreme acasă';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup s-a terminat pentru dvs. în faza grupelor. N-a fost destul pentru eliminatorii.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'N-ați reușit să ieșiți din grupă. $cup se termină aici.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Niciun loc în eliminatorii de data asta. $cup se încheie pentru dvs. în faza grupelor.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Obiectiv atins: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Obiectiv ratat: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Ținta federației la $comp: $demand. Rezultatul dvs.: $finish. Au primit ce au cerut.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Ținta federației la $comp: $demand. Rezultatul dvs.: $finish. Sub așteptări.';
  }

  @override
  String get newsWcMissTitle => 'Visul Campionatului Mondial s-a spulberat';

  @override
  String newsWcMissBody(int year) {
    return 'Nu v-ați calificat la Campionatul Mondial $year. Campania de preliminarii nu a fost suficientă. Încă patru ani.';
  }

  @override
  String get newsRecordScorerTitle => 'Golgheterul tuturor timpurilor';

  @override
  String newsRecordScorerBody(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals de goluri',
      few: '$goals goluri',
      one: '1 gol',
    );
    return '$name este acum golgheterul all-time al jocului, cu $_temp0.';
  }

  @override
  String get newsRecordCapsTitle => 'Recordmanul la selecții';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name este acum jucătorul cu cele mai multe selecții din joc: $caps.';
  }

  @override
  String get newsARecordBreaker => 'Un nou recordman';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name semnează cu $club';
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
    return '$name ($position, $rating) a plecat de la $fromClub și a semnat cu $destination pentru $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club din $country';
  }

  @override
  String get newsTransferFree => 'Gratuit';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name ar trece la $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name vrea să joace pentru $nation';
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
    return '$name, $position de $age ani, cu valoarea $rating, în prezent la $fromNation, are legături de familie cu $nation și e deschis la schimbare. Deschideți oferta de naturalizare ca s-o acceptați sau s-o refuzați.';
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
    return '$name, $position de $age ani, cu valoarea $rating, în prezent la $fromNation, este un nume mare cu legături de familie cu $nation și e deschis la schimbare. Deschideți oferta de naturalizare ca s-o acceptați sau s-o refuzați.';
  }

  @override
  String get newsTheirNation => 'națiunea lui';

  @override
  String get newsYourNation => 'națiunea dvs.';

  @override
  String get tourStatusChampions => 'CAMPIONI';

  @override
  String get tourStatusFinals => 'TURNEU FINAL';

  @override
  String get tourStatusQualifying => 'PRELIMINARII';

  @override
  String get tourStatusUpcoming => 'URMEAZĂ';

  @override
  String get tourStatusInProgress => 'ÎN DESFĂȘURARE';

  @override
  String get tourStatusComingSoon => 'ÎN CURÂND';

  @override
  String get tourStatusDecided => 'DECIS';

  @override
  String tourStatusLeague(String letter) {
    return 'LIGA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'TRAGEREA PRELIMINARIILOR CM';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup: TRAGEREA PRELIMINARIILOR';
  }

  @override
  String get tourDrawWcHost => 'GAZDA CAMPIONATULUI MONDIAL';

  @override
  String tourDrawContHost(String cup) {
    return '$cup: GAZDA';
  }

  @override
  String get tourDrawHostsReveal => 'Iar gazdele vor fi…';

  @override
  String get tourDrawHostReveal => 'Iar gazda va fi…';

  @override
  String get tourDrawHostCandidates => 'Candidatele rămase în cursă:';

  @override
  String get tourKickoffContinentalCup => 'CUPA CONTINENTALĂ';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup: calificare ratată';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Nu v-ați calificat la $cup. Campania nu a fost suficientă de data asta.';
  }

  @override
  String get potyLabelBest => 'Jucătorul anului';

  @override
  String get potyLabelYoung => 'Tânărul jucător al anului';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de pase decisive',
      few: '$count pase decisive',
      one: '1 pasă decisivă',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Valoare $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Notă $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Jucătorul mondial al anului $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name este cel mai bun jucător din lume anul acesta.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name primește premiul pentru tânărul jucător.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Băieții pe care îi urmăriți, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain de puncte',
      few: '$gain puncte',
      one: 'un punct',
    );
    return '$name a urcat la $rating, cu $_temp0 peste anul trecut.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name urcă la $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name debutează';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name a obținut prima selecție la $age ani, cu valoarea $rating. Unul dintre băieții pe care îi urmăriți.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Posesia, notele jucătorilor și omul meciului se stabilesc la fluierul final.';

  @override
  String get matchPlayerRatings => 'NOTELE JUCĂTORILOR';

  @override
  String get matchSubstitutions => 'SCHIMBĂRI';

  @override
  String get matchSubstitutes => 'REZERVE';

  @override
  String get matchPlayerOfTheMatch => 'OMUL MECIULUI';

  @override
  String get matchGoalShout => 'GOL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'PENALTY-URI $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: GOL';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: RATAT';
  }

  @override
  String get matchFeedKickOff => 'Lovitura de start!';

  @override
  String get matchFeedNoEvents => 'Niciun eveniment încă.';

  @override
  String get tourVenues => 'STADIOANE';

  @override
  String tourPot(int number) {
    return 'URNA $number';
  }

  @override
  String get tourHostSelection => 'ALEGEREA GAZDEI';

  @override
  String get tourCandidates => 'CANDIDATE';

  @override
  String get tourJointBid => 'CANDIDATURĂ COMUNĂ';

  @override
  String get tourGoldenGlove => 'MĂNUȘA DE AUR';

  @override
  String get tourTeamOfTournament => 'ECHIPA TURNEULUI';

  @override
  String get tourYourRun => 'PARCURSUL DVS.';

  @override
  String get tourMedalTable => 'CLASAMENTUL MEDALIILOR';

  @override
  String tourHostLine(String nation) {
    return 'Gazdă: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Gazde: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Grupa $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Capii de serie după clasamentul mondial. Găsiți-vă națiunea înainte de tragere.';

  @override
  String get tourWorldRanking => 'Clasamentul mondial';

  @override
  String get tourYourCompetitions => 'COMPETIȚIILE DVS.';

  @override
  String get tourOtherContinents => 'ALTE CONTINENTE';

  @override
  String get tourZoneGlobal => 'GLOBAL';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'AM. DE SUD';

  @override
  String get tourZoneNorthAmerica => 'AM. DE NORD';

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
    return 'LIGA $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'GAZDĂ:  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Primele $count merg în $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name pleacă';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name s-a retras de la echipa națională la $age ani, cu $caps selecții. A cerut să i se spună care e situația lui, nu i s-a spus, și nu mai așteaptă.';
  }

  @override
  String get pressHeadlineWent1 => 'Un selecționer care stăpânește sala';

  @override
  String get pressHeadlineWent2 => 'Au venit după scandal și au găsit un lider';

  @override
  String get pressHeadlineWent3 => 'Răspunsuri directe, care au convins';

  @override
  String get pressHeadlineMixed1 => 'S-a vorbit mult, s-a lămurit puțin';

  @override
  String get pressHeadlineMixed2 =>
      'Câte ceva pentru toată lumea și nimic pentru nimeni';

  @override
  String get pressHeadlineMixed3 =>
      'O conferință care a lăsat întrebările deschise';

  @override
  String get pressHeadlineBadly1 => 'O după-amiază dureroasă în fața camerelor';

  @override
  String get pressHeadlineBadly2 =>
      'Sala s-a întors împotriva lui și s-a văzut';

  @override
  String get pressHeadlineBadly3 =>
      'Răspunsuri care vor suna și mai rău mâine-dimineață';

  @override
  String get pressHeadlineFlat1 => 'Nimic spus, nimic câștigat';

  @override
  String get pressHeadlineFlat2 => 'Zece minute, nicio știre';

  @override
  String get pressHeadlineFlat3 => 'O pagină goală pentru ziarele de sport';

  @override
  String get pressConferenceTitle => 'CONFERINȚĂ DE PRESĂ';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Întrebarea $index din $total';
  }

  @override
  String get pressTomorrowsHeadline => 'TITLUL DE MÂINE';

  @override
  String get pressLeaveRoom => 'PĂRĂSIȚI SALA';

  @override
  String get pressRoomVerdictSquad => 'Vestiar';

  @override
  String get pressRoomVerdictBoard => 'Federație';

  @override
  String get yReactionElation0 => 'nimic de comentat. nimic. perfect.';

  @override
  String get yReactionElation1 => 'Nu-mi revin (în sensul bun).';

  @override
  String get yReactionElation2 => 'înrămez asta. o pun deasupra șemineului.';

  @override
  String get yReactionElation3 => 'ne-am întors, oameni buni';

  @override
  String get yReactionElation4 =>
      'Fac captură de ecran pentru sceptici. Pentru toți.';

  @override
  String get yReactionElation5 => 'O să fiu insuportabil cu asta un deceniu.';

  @override
  String get yReactionElation6 => 'Gata. De asta ne uităm.';

  @override
  String get yReactionElation7 => 'Zile ca asta le plătesc pe celelalte.';

  @override
  String get yReactionElation8 => 'Era și timpul. Sincer, era timpul.';

  @override
  String get yReactionElation9 =>
      'Super. Acum mai faceți o dată săptămâna viitoare și o să cred.';

  @override
  String get yReactionElation10 =>
      'Bucurați-vă în seara asta, pentru că ăștia vor găsi o cale s-o strice.';

  @override
  String get yReactionElation11 =>
      'O seară bună nu face pe nimeni o echipă mare.';

  @override
  String get yReactionRelief0 => 'Nu frumos, dar o iau de fiecare dată.';

  @override
  String get yReactionRelief1 => 'Cumva. Cumva!';

  @override
  String get yReactionRelief2 => 'Urât. Trei puncte. Mai departe.';

  @override
  String get yReactionRelief3 => 'Accept urâtul oricând dacă vine cu puncte.';

  @override
  String get yReactionRelief4 => 'asta mi-a luat zece ani din viață';

  @override
  String get yReactionRelief5 => 'Nimeni să nu zică nimic. Să nu-l deochem.';

  @override
  String get yReactionRelief6 => 'Puls: inacceptabil.';

  @override
  String get yReactionRelief7 =>
      'Am supraviețuit. Ăsta e cuvântul. Supraviețuit.';

  @override
  String get yReactionRelief8 =>
      'N-ar trebui să răsuflăm ușurați după asemenea meciuri.';

  @override
  String get yReactionRelief9 => 'Ușurat, și puțin rușinat că sunt ușurat.';

  @override
  String get yReactionRelief10 =>
      'Dacă asta e ștacheta pe care o aplaudăm, avem probleme.';

  @override
  String get yReactionRelief11 =>
      'Să treci la limită e un obicei, și nu unul bun.';

  @override
  String get yReactionFury0 => 'Nu e destul de bine. Nici pe departe.';

  @override
  String get yReactionFury1 => 'Să-mi explice cineva asta, rar.';

  @override
  String get yReactionFury2 => 'A fost greu de privit și sunt politicos.';

  @override
  String get yReactionFury3 => 'Dezamăgit. Sincer dezamăgit.';

  @override
  String get yReactionFury4 => 'În ce hal am ajuns.';

  @override
  String get yReactionFury5 => 'Vreau nume.';

  @override
  String get yReactionFury6 => 'Șterg aplicația. O reinstalez joi.';

  @override
  String get yReactionFury7 => 'Nimeni de pe teren n-a părut că-și dorește.';

  @override
  String get yReactionFury8 =>
      'La fiecare patru ani, același lucru. LA FIECARE patru ani.';

  @override
  String get yReactionFury9 => 'Asta nu e un joc, e o insultă.';

  @override
  String get yReactionFury10 =>
      'Oamenii renunță la weekenduri și la bani pentru asta. Gândiți-vă.';

  @override
  String get yReactionFury11 =>
      'Am apărat echipa asta ani de zile. Nu în seara asta. Nu după asta.';

  @override
  String get yReactionDespair0 => 'ei bine.';

  @override
  String get yReactionDespair1 => 'Fără glume azi. Nimic.';

  @override
  String get yReactionDespair2 => 'Mă duc la o plimbare. Una lungă.';

  @override
  String get yReactionDespair3 => 'Nu mai am cum să spun asta.';

  @override
  String get yReactionDespair4 => 'Treziți-mă peste patru ani.';

  @override
  String get yReactionDespair5 => 'asta e cea mai neagră variantă a realității';

  @override
  String get yReactionDespair6 =>
      'Nici măcar nu mai sunt furios. Asta e partea îngrijorătoare.';

  @override
  String get yReactionDespair7 => 'Asta o să doară mult timp.';

  @override
  String get yReactionDespair8 =>
      'Nu mai știu ce e asta, dar nu e o echipă de fotbal.';

  @override
  String get yReactionDespair9 =>
      'Suntem mai departe decât eram și nimeni n-o s-o spună.';

  @override
  String get yReactionDespair10 =>
      'O generație întreagă irosită, și aceiași oameni decid ce urmează.';

  @override
  String get yReactionDespair11 =>
      'Nu-mi mai spuneți că e un proces. Nu duce nicăieri.';

  @override
  String get yReactionSmugness0 => 'Discret, dar: v-am zis.';

  @override
  String get yReactionSmugness1 => 'salvați-l pe ăsta';

  @override
  String get yReactionSmugness2 => 'Scepticii au tăcut brusc.';

  @override
  String get yReactionSmugness3 => 'Nu că ar ține cineva socoteala. Eu o țin.';

  @override
  String get yReactionSmugness4 => 'Am zis-o din ianuarie. Verificați.';

  @override
  String get yReactionSmugness5 =>
      'Unii dintre voi ne datorați unora dintre noi niște scuze.';

  @override
  String get yReactionSmugness6 =>
      'Trec asta la lucruri pe care le-am spus primul.';

  @override
  String get yReactionSmugness7 => 'Fără triumfalism. Puțin triumfalism.';

  @override
  String get yReactionSmugness8 =>
      'Unde sunt acum toți experții? Întrebare sinceră.';

  @override
  String get yReactionSmugness9 =>
      'Aș vrea ca fiecare dintre voi să mi-o repete.';

  @override
  String get yReactionSmugness10 =>
      'Captură de ecran, printată, înrămată, trimisă celor care au râs.';

  @override
  String get yReactionSmugness11 =>
      'O să aduc asta în discuție tot restul vieții și ați meritat-o.';

  @override
  String get yReactionShrug0 => 's-a întâmplat. următorul.';

  @override
  String get yReactionShrug1 => 'Bine. Fie. Mai departe.';

  @override
  String get yReactionShrug2 => 'Trec asta la capitolul „fotbal”.';

  @override
  String get yReactionShrug3 => 'Sincer, nimic de adăugat.';

  @override
  String get yReactionShrug4 => 'niciun gând, cap gol';

  @override
  String get yReactionShrug5 => 'Treziți-mă la următorul.';

  @override
  String get yReactionShrug6 =>
      'Nouăzeci de minute pe care nu le mai primesc înapoi.';

  @override
  String get yReactionShrug7 => 'Nici în căruță, nici în teleguță, sincer.';

  @override
  String get yReactionShrug8 =>
      'N-aș putea să vă spun nimic din ce s-a întâmplat.';

  @override
  String get yReactionShrug9 => 'Încă unul de-ăsta. Sunt mulți de-ăștia.';

  @override
  String get yReactionShrug10 =>
      'M-am uitat la tot și n-am simțit absolut nimic.';

  @override
  String get yReactionShrug11 =>
      'Dacă nimeni nu mai pomenește de asta, pe mine mă aranjează.';

  @override
  String get tourThirdsUneven =>
      'Grupele sunt inegale, așa că rezultatele cu ultima clasată din fiecare grupă mare nu se iau în calcul și toate echipele sunt judecate pe același număr de meciuri.';

  @override
  String get careerExportSave => 'Faceți backup acestei salvări';

  @override
  String get careerBackupAll => 'BACKUP PENTRU TOATE SALVĂRILE';

  @override
  String get careerBackupAllFailed => 'Backupul nu a putut fi scris.';

  @override
  String get backupTitle => 'BACKUPURI';

  @override
  String get backupBlurb =>
      'Toate salvările stau într-un singur fișier pe acest telefon și nimic nu le salvează automat dacă nu activați backupul automat de mai jos. Păstrați o copie în cloud, ca un telefon pierdut sau o aplicație ștearsă să nu vă coste o carieră.';

  @override
  String get backupBlurbNoAuto =>
      'Toate salvările stau într-un singur fișier pe acest telefon și nimic nu le salvează automat. Păstrați o copie în cloud, ca un telefon pierdut sau o aplicație ștearsă să nu vă coste o carieră.';

  @override
  String get backupExport => 'BACKUP ÎN CLOUD';

  @override
  String get backupExportSubject => 'Salvări FNM';

  @override
  String get backupRestore => 'RESTAURAȚI DINTR-UN FIȘIER';

  @override
  String get backupRestoreWarnTitle => 'Înlocuiți toate salvările?';

  @override
  String get backupRestoreWarnBody =>
      'Restaurarea înlocuiește toate salvările de pe acest telefon cu cele din fișier. Aplicația va reporni.';

  @override
  String get backupRestoreConfirm => 'ÎNLOCUIȚI';

  @override
  String get backupCancel => 'ANULAȚI';

  @override
  String get backupExported => 'Backup gata. Alegeți unde să-l păstrați.';

  @override
  String get backupFailed => 'Backupul nu a putut fi scris.';

  @override
  String get backupRejectedUnreadable => 'Fișierul nu a putut fi deschis.';

  @override
  String get backupRejectedNotFnm => 'Nu este o salvare FNM.';

  @override
  String get backupRejectedNewer =>
      'Salvarea a fost făcută cu o versiune mai nouă a aplicației. Actualizați mai întâi.';

  @override
  String get backupRejectedTooOld =>
      'Salvarea este prea veche pentru a fi restaurată de această versiune.';

  @override
  String get careerShare => 'Partajați această carieră';

  @override
  String get careerImport => 'IMPORTAȚI O CARIERĂ';

  @override
  String get careerShareSubject => 'O carieră FNM';

  @override
  String get careerImported => 'Carieră importată.';

  @override
  String get careerImportFailedUnreadable => 'Fișierul nu este o carieră FNM.';

  @override
  String get careerImportFailedNewer =>
      'Cariera a fost exportată cu o versiune mai nouă a aplicației. Actualizați mai întâi.';

  @override
  String get careerImportFailedSlotsFull =>
      'Toate sloturile de salvare sunt ocupate. Ștergeți o salvare ca să faceți loc sau deblocați salvările nelimitate.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Această carieră a trecut de primul ciclu gratuit. Deblocați jocul complet ca s-o importați.';

  @override
  String get careerImportFailedCampaignRun =>
      'Această campanie are deja o încercare în desfășurare. Reluați-o sau abandonați-o mai întâi.';

  @override
  String get careerShareFailed => 'Cariera nu a putut fi exportată.';

  @override
  String get managerRename => 'Schimbați numele';

  @override
  String get managerRenameSave => 'Salvați';

  @override
  String get managerTitle => 'SELECȚIONER';

  @override
  String get managerSkills => 'ABILITĂȚILE DVS.';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de puncte de cheltuit',
      few: '$count puncte de cheltuit',
      one: '1 punct de cheltuit',
      zero: 'Niciun punct de cheltuit',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Două puncte pentru fiecare ciclu încheiat, unul pentru fiecare trofeu câștigat.';

  @override
  String get managerSkillsScale =>
      'Fiecare abilitate începe de la 5 și se oprește la 20. Un punct cheltuit este permanent.';

  @override
  String get managerSkillManManagement => 'Managementul oamenilor';

  @override
  String get managerSkillManManagementBlurb =>
      'Fiecare punct face ca ce le spuneți presei și jucătorilor să aibă cu 3% mai mult efect în vestiar.';

  @override
  String get managerSkillTactical => 'Tactică';

  @override
  String get managerSkillTacticalBlurb =>
      'Fiecare punct asimilează un sistem nou cu 3% mai repede, așa că schimbarea așezării vă costă mai puține meciuri.';

  @override
  String get managerSkillYouth => 'Dezvoltarea tinerilor';

  @override
  String get managerSkillYouthBlurb =>
      'Fiecare punct adaugă 1% la talentul care iese din academie, pe lângă finanțarea pe care o primește.';

  @override
  String get managerSkillNegotiation => 'Negociere';

  @override
  String get managerSkillNegotiationBlurb =>
      'Fiecare punct înseamnă cu 2% mai mulți bani de la federație, în fiecare ciclu.';

  @override
  String get managerStaff => 'STAFFUL DVS.';

  @override
  String managerStaffWages(String amount) {
    return 'Salarii: $amount pe ciclu';
  }

  @override
  String get managerRoleAssistant => 'Antrenor secund';

  @override
  String get managerRoleAssistantBlurb =>
      'Conduce antrenamentele: mai puține accidentări și tineri mai buni care apar.';

  @override
  String get managerRoleScout => 'Scouter-șef';

  @override
  String get managerRoleScoutBlurb =>
      'Evaluează tinerii și următorul adversar: stele mai exacte și un avantaj în ziua meciului.';

  @override
  String get managerRoleFitness => 'Preparator fizic';

  @override
  String get managerRoleFitnessBlurb => 'Îi ține pe teren.';

  @override
  String staffEffectInjury(int percent) {
    return 'Cu $percent% mai puține accidentări';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Tinerii +$points general';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Dacă angajați unul: cu $min% până la $max% mai puține accidentări';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'și tinerii +$minPoints până la +$maxPoints general';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Evaluează exact $percent% dintre tineri';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potențial cunoscut după $caps de selecții',
      few: 'Potențial cunoscut după $caps selecții',
      one: 'Potențial cunoscut după 1 selecție',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points valoare din dosarele adversarilor';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Dacă angajați unul: $min% până la $max% evaluări exacte';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'și potențialul aflat cu $minCaps până la $maxCaps selecții mai devreme';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'și +$minPoints până la +$maxPoints valoare la fiecare meci';
  }

  @override
  String get staffEffectNone => 'Încă niciun efect asupra lotului';

  @override
  String get staffVacant => 'Post neocupat';

  @override
  String get staffLeaveVacant => 'Lăsați postul liber';

  @override
  String get managerTierNone => 'Niciunul';

  @override
  String get managerTierBasic => 'De bază';

  @override
  String get managerTierGood => 'Bun';

  @override
  String get managerTierElite => 'De elită';

  @override
  String get managerFree => 'gratuit';

  @override
  String get managerTraining => 'ÎNTRE FERESTRE';

  @override
  String get managerTrainingBlurb =>
      'La ce lucrează lotul când nu e niciun meci de jucat.';

  @override
  String get managerFocusBalanced => 'Echilibrat';

  @override
  String get managerFocusBalancedBlurb => 'Câte puțin din toate.';

  @override
  String get managerFocusFitness => 'Condiție fizică';

  @override
  String get managerFocusFitnessBlurb => 'Mai puține lovituri.';

  @override
  String get managerFocusCohesion => 'Coeziune';

  @override
  String get managerFocusCohesionBlurb => 'Sistemul se asimilează mai repede.';

  @override
  String get managerFocusYouth => 'Tineret';

  @override
  String get managerFocusYouthBlurb =>
      'Ore petrecute cu cei mai tineri din rezervor.';

  @override
  String get tourOfferTitle => 'Prima dată aici?';

  @override
  String get tourOfferBody =>
      'E un joc mare. Doriți o scurtă prezentare a ecranelor importante? Durează un minut și o puteți reporni oricând din Setări.';

  @override
  String get tourOfferYes => 'Arătați-mi';

  @override
  String get tourOfferNo => 'Nu, mulțumesc';

  @override
  String get tourBack => 'Înapoi';

  @override
  String get tourNext => 'Următorul';

  @override
  String get tourDone => 'Gata';

  @override
  String get tourSkip => 'Săriți';

  @override
  String get tourHubTitle => 'Acesta este tot jocul';

  @override
  String get tourHubBody =>
      'Un singur buton, care se schimbă pe măsură ce avansează ciclul: o tragere la sorți de urmărit, un lot de ales, un meci de jucat. Deasupra lui stau încrederea federației în dvs. și obiectivele stabilite.';

  @override
  String get tourBudgetTitle => 'Banii federației';

  @override
  String get tourBudgetBody =>
      'O dată la fiecare ciclu de patru ani împărțiți fondurile între departamente. Staffului i se plătește mai întâi din ele, așa că angajarea unui scouter de elită e o decizie luată în detrimentul academiei, nu alături de ea.';

  @override
  String get tourTacticsTitle => 'Cum joacă echipa';

  @override
  String get tourTacticsBody =>
      'Sistemul, stilul de joc, căpitanul și executanții fazelor fixe. Lăsați ultimele două nesetate și jocul vă va avertiza înainte de start, în loc să aleagă în tăcere pentru dvs.';

  @override
  String get tourSquadTitle => 'Toți cei pe care îi puteți alege';

  @override
  String get tourSquadBody =>
      'Tot rezervorul, nu doar lotul: cine e în formă, cine are o problemă medicală, cine e suspendat și cine tocmai a ieșit din academie.';

  @override
  String get tourCallUpsTitle => 'Alegerea lotului';

  @override
  String get tourCallUpsBody =>
      'Alegeți un lot pentru fiecare fereastră internațională și el joacă toate meciurile acelei ferestre, exact ca la un selecționer real. O accidentare în timpul ferestrei aduce automat un înlocuitor.';

  @override
  String get tourRecordsTitle => 'Cariera dvs.';

  @override
  String get tourRecordsBody =>
      'Tot ce ați făcut: meciurile, recordurile echipei, trofeele și fiecare națiune pe care ați condus-o.';

  @override
  String get tourCupsTitle => 'Restul lumii';

  @override
  String get tourCupsBody =>
      'Toate competițiile în desfășurare: grupe, clasamente și eliminatorii, inclusiv cele la care nu participați. Lumea joacă mai departe, indiferent dacă v-ați calificat sau nu.';

  @override
  String get settingsTourTitle => 'Reluați tutorialul';

  @override
  String get settingsTourBlurb =>
      'Parcurgeți din nou ecranele principale de la început.';

  @override
  String get tourBoardTitle => 'În fața cui răspundeți';

  @override
  String get tourBoardBody =>
      'Încrederea federației în dvs. și obiectivele stabilite pentru acest ciclu. Dacă ratați cerințele, aici veți vedea primele semne.';

  @override
  String get tourStaffTitle => 'Oamenii din jurul dvs.';

  @override
  String get tourStaffBody =>
      'Un antrenor secund, un scouter și un preparator fizic, angajați pe nume. Salariile lor se plătesc din acest buget înaintea departamentelor, așa că un scouter excelent e o decizie în detrimentul academiei.';

  @override
  String get tourPlaystyleTitle => 'Stilul dvs. de joc';

  @override
  String get tourPlaystyleBody =>
      'Sistemul e doar jumătate din tactică. Aceasta e cealaltă jumătate: cât de sus presați, cât de direct jucați, cât riscați.';

  @override
  String get settingsTourNoSave =>
      'Începeți mai întâi o carieră. Prezentarea trece prin propriile ecrane.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Nu e postul lui · $age ani';
  }

  @override
  String get federationNextCycleLocked =>
      'Bugetul ciclului următor se stabilește la începutul acelui ciclu, dintr-o dată. Până atunci, iată ce fac banii dvs.';

  @override
  String get federationBudgetAlreadySet => 'Deja stabilit pentru acest ciclu';

  @override
  String yFinalLooms0(String opponent) {
    return '$opponent în marele meci. Toată săptămâna nu se va vorbi despre altceva.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Confirmat: doar $opponent ne mai desparte de trofeu. Patru ani pentru asta.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Gata. $opponent. Nimeni nu doarme până nu se termină.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Urmează $opponent, și orice altceva poate aștepta. Ce săptămână să fii în viață.';
  }

  @override
  String get matchSetupLeaveToCoach =>
      'Lăsați executanții în grija antrenorului';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Marcate mai jos: echipe care joacă precum $rivals, adversarele din grupele dvs. în acest ciclu.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Perioada de transferuri · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Ultima dată acum $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Un ciclu gratuit de patru ani';

  @override
  String get settingsFreeScopeBlurb =>
      'Un ciclu complet (preliminariile, campionatul continental și Campionatul Mondial) pe două salvări, toate națiunile lumii, nimic ascuns. Ciclurile nelimitate și salvările nelimitate costă o singură plată, o dată, care acoperă toate actualizările viitoare.';

  @override
  String get settingsUnlockedTitle => 'Deblocat';

  @override
  String get settingsUnlockedBlurb =>
      'Cicluri nelimitate, salvări nelimitate și toate actualizările viitoare. Vă mulțumim.';

  @override
  String get settingsFromDeveloperTitle => 'De la dezvoltator';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager este făcut de o singură persoană și va fi susținut pe termen lung. Nu vor exista niciodată reclame sau microtranzacții. Dacă vă place jocul, vă rog să luați în considerare cumpărarea versiunii complete. Asta face ca actualizările să continue.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager este făcut de o singură persoană și va fi susținut pe termen lung. Nu vor exista niciodată reclame sau microtranzacții. Vă mulțumesc că ați cumpărat versiunea completă. Asta face ca actualizările să continue.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Marcate mai jos: echipe care joacă precum $rivals, pe care încă trebuie să le înfruntați.';
  }

  @override
  String get friendliesCloseToYou =>
      'Marcate mai jos: echipele cele mai apropiate de dvs. în clasamentul mondial. După tragerea la sorți, marcajele vă urmează grupa.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de transferuri',
      few: '$count transferuri',
      one: '1 transfer',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Mai noi';

  @override
  String get transfersOlder => 'Mai multe';

  @override
  String get transfersPagePrevious => 'Anterior';

  @override
  String get transfersPageNext => 'Următor';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Pagina $page din $pages';
  }

  @override
  String get transfersMovedTo => 'Transferat la';

  @override
  String get transfersUnknownClub => 'Club necunoscut';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Întâlnirea numărul $count cu $opponent. Cineva ține scorul, și aceia sunt ei.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Iar $opponent. Întâlniri: $count, și tot nu i-am descifrat.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Întâlnirea cu numărul $count cu $opponent. Nu mai e o coincidență.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Am jucat cu $opponent de $count ori și n-am învățat nimic din niciuna.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, de $count ori. Știu exact ce urmează să facem.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Orice ar avea $opponent împotriva noastră, după atâtea întâlniri ($count), încă au.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'S-a întâmplat de $count ori în ultima vreme. Când devine pur și simplu ce suntem?';
  }

  @override
  String ySameOldStory1(String count) {
    return 'De $count ori o după-amiază ca asta. E un tipar, nu ghinion.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Am văzut exact meciul ăsta de $count ori recent. Același scenariu, același final.';
  }

  @override
  String ySameOldStory3(String count) {
    return 'Aceleași nouăzeci de minute, pentru a $count-a oară. Nimeni nu repară nimic.';
  }

  @override
  String ySameOldStory4(String count) {
    return 'De $count ori. Dacă nici acum nu vedeți tiparul, nu vă uitați.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Aceeași poveste, de $count ori. Scuzele s-au terminat înaintea rezultatelor.';
  }

  @override
  String get yToldYouSo0 =>
      'Am spus că vine asta în timp ce toată lumea era ocupată să sărbătorească.';

  @override
  String get yToldYouSo1 =>
      'Două săptămâni bune și iar eram generație de aur. Și uite unde suntem.';

  @override
  String get yToldYouSo2 =>
      'Cei care luna trecută îmi spuneau să mă bucur au tăcut.';

  @override
  String get yToldYouSo3 =>
      'Nu-mi face nicio plăcere. Foarte puțină plăcere. Ceva.';

  @override
  String get yToldYouSo4 =>
      'N-a fost niciodată atât de bine cum vi s-a spus, și asta e dovada.';

  @override
  String get yToldYouSo5 =>
      'De fiecare dată. Ni se spune că acum e altfel, și de fiecare dată nu e.';

  @override
  String get tacticsSubOffAlready => 'Deja înlocuit';

  @override
  String get tacticsSubInjured => 'Accidentat';

  @override
  String get tacticsSubSentOffMark => 'Eliminat';

  @override
  String get tacticsSubNoneLeft => 'Fără schimbări rămase';

  @override
  String get tacticsUndoLastChange => 'Anulați ultima schimbare';

  @override
  String get matchStrengthTitle => 'CE INFLUENȚEAZĂ ECHIPA';

  @override
  String get strengthFactorFamiliarity => 'Sistem asimilat';

  @override
  String get strengthFactorFatigue => 'Oboseală';

  @override
  String get strengthFactorClubForm => 'Forma la club';

  @override
  String get strengthFactorMorale => 'Vestiar';

  @override
  String get strengthFactorCaptain => 'Căpitan';

  @override
  String get strengthFactorStaff => 'Staff';

  @override
  String get strengthFactorDossier => 'Dosarul scouterului';

  @override
  String yDebut0(String name) {
    return '$name primește prima selecție. Țineți minte numele.';
  }

  @override
  String yDebut1(String name) {
    return 'Debut pentru $name. Se vede la el, nu-i așa?';
  }

  @override
  String yDebut2(String name) {
    return '$name, prima selecție. Să vedem ce face cu ea.';
  }

  @override
  String yDebut3(String name) {
    return 'Debut pentru $name. Lotul avea nevoie de prospețime undeva.';
  }

  @override
  String yDebut4(String name) {
    return '$name primește o selecție. Am dat multe din astea în ultima vreme.';
  }

  @override
  String yDebut5(String name) {
    return 'Debut pentru $name. Încă unul pe care îl vom uita până la primăvară.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name n-a mai marcat de $count meciuri și face orice altceva pe teren.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count meciuri fără gol pentru $name. Golurile vin câte trei, mereu a fost așa.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count meciuri, niciun gol.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count meciuri fără gol pentru $name. Merită urmărit.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count meciuri. Niciun gol. $name n-ar nimeri nici poarta unui hambar.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name n-a mai marcat de $count meciuri. Băgați pe oricine altcineva.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Urmează $opponent. Întâlniri: $count, și încă înseamnă totul.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'De $count ori cu $opponent până acum. Să vină.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Urmează $opponent. Meciuri directe: $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Întâlnirea cu numărul $count cu $opponent, săptămâna asta.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Iar $opponent. De $count ori, și n-am învățat nimic.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return 'De $count ori cu $opponent și tot ne bat. Minunat.';
  }

  @override
  String get positionGoalkeeper => 'Portar';

  @override
  String get positionLeftBack => 'Fundaș stânga';

  @override
  String get positionCentreBack => 'Fundaș central';

  @override
  String get positionRightBack => 'Fundaș dreapta';

  @override
  String get positionDefensiveMid => 'Mijlocaș defensiv';

  @override
  String get positionCentralMid => 'Mijlocaș central';

  @override
  String get positionAttackingMid => 'Mijlocaș ofensiv';

  @override
  String get positionLeftMid => 'Mijlocaș stânga';

  @override
  String get positionRightMid => 'Mijlocaș dreapta';

  @override
  String get positionLeftWing => 'Extremă stânga';

  @override
  String get positionRightWing => 'Extremă dreapta';

  @override
  String get positionStriker => 'Atacant';

  @override
  String get roleNone => 'Fără rol';

  @override
  String get roleTargetMan => 'Pivot';

  @override
  String get rolePoacher => 'Vârf de careu';

  @override
  String get rolePlaymaker => 'Playmaker';

  @override
  String get roleBallWinner => 'Recuperator';

  @override
  String get roleInvertedWinger => 'Extremă inversă';

  @override
  String get roleBallPlayingDefender => 'Fundaș constructor';

  @override
  String get roleNoneBlurb => 'Își joacă jocul natural.';

  @override
  String get roleTargetManBlurb =>
      'Câștigă duelurile aeriene, pasează mai departe. Pase decisive și faze fixe.';

  @override
  String get rolePoacherBlurb => 'Pândește în careu. Mult mai multe goluri.';

  @override
  String get rolePlaymakerBlurb =>
      'Creează ocazii. Mult mai multe pase decisive.';

  @override
  String get roleBallWinnerBlurb =>
      'Mai degrabă distruge jocul decât îl finalizează.';

  @override
  String get roleInvertedWingerBlurb =>
      'Intră spre centru ca să șuteze. Mai multe goluri.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Inițiază atacurile din spate.';

  @override
  String get federationDeptYouth => 'Academia de juniori';

  @override
  String get federationDeptCommercial => 'Comercial / PR';

  @override
  String get federationDeptMedical => 'Medical și știința sportului';

  @override
  String get federationDeptNaturalisation => 'Biroul de naturalizări';

  @override
  String get federationDeptBoardRelations => 'Relația cu conducerea';

  @override
  String get federationDeptYouthBlurb =>
      'Tineri mai buni din academie debutează la națională în ciclul următor.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsorizările aduc venituri în plus la finalul ciclului.';

  @override
  String get federationDeptMedicalBlurb =>
      'Mai puține accidentări. Lotul rămâne disponibil tot ciclul.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Mai mulți jucători străini se oferă să joace pentru națiunea dvs.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Conducerea vă judecă rezultatele cu mai multă răbdare.';

  @override
  String get federationBuildingAcademy => 'Academie';

  @override
  String get federationBuildingCommercial => 'Sediul comercial';

  @override
  String get federationBuildingMedical => 'Centrul medical';

  @override
  String get federationBuildingScouting => 'Biroul de scouting';

  @override
  String get federationBuildingBoardroom => 'Sala consiliului';

  @override
  String get moraleBuoyant => 'Euforic';

  @override
  String get moralePositive => 'Pozitiv';

  @override
  String get moraleSettled => 'Stabil';

  @override
  String get moraleUneasy => 'Neliniștit';

  @override
  String get moraleRockBottom => 'La pământ';

  @override
  String get matchTabTimeline => 'DESFĂȘURARE';

  @override
  String get matchTabStats => 'STATISTICI';

  @override
  String get matchTabLineups => 'FORMAȚII';

  @override
  String get matchPenalty => 'PENALTY';

  @override
  String get matchStateLevel => 'E egalitate';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Conduceți la $count de goluri',
      few: 'Conduceți la $count goluri',
      one: 'Conduceți la un gol',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sunteți conduși la $count de goluri',
      few: 'Sunteți conduși la $count goluri',
      one: 'Sunteți conduși la un gol',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% posesie';
  }

  @override
  String get boardVerdictSackedTitle => 'Federația v-a demis';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Un ciclu dezastruos (evaluare $rating%). Mandatul dvs. se încheie aici. Doar națiuni mai mici vor mai risca acum cu dvs.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Federația este încântată';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Un ciclu remarcabil (evaluare $rating%) după $best. Națiuni mai mari sunt interesate, sau puteți rămâne să construiți.';
  }

  @override
  String get boardVerdictSolidTitle => 'Un ciclu solid';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Federația este mulțumită (evaluare $rating%). Câteva națiuni de nivel similar v-ar lua, dar nu e nicio presiune să plecați.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Federația aștepta mai mult';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Un ciclu dezamăgitor (evaluare $rating%). Vă păstrați postul, dar orice ofertă ar fi un pas înapoi.';
  }

  @override
  String get boardVerdictPressureTitle => 'Sunteți sub mare presiune';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Un ciclu slab (evaluare $rating%). Rezistați, dar doar națiuni mai slabe sunt interesate dacă vreți un nou început.';
  }

  @override
  String get boardVerdictHeroTitle => 'Națiunea e alături de dvs.';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles de cicluri',
      few: '$cycles cicluri',
      one: '1 ciclu',
    );
    return ' Pentru $nation sunteți un idol, erou național după $_temp0; postul e al dvs. cât timp îl doriți.';
  }

  @override
  String get boardVerdictTheNation => 'Națiunea';

  @override
  String get boardVerdictBestQuiet => 'un ciclu liniștit';

  @override
  String get boardVerdictBestCycle => 'acest ciclu';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Campionatul Mondial: $placement';
  }

  @override
  String get finishThirdPlace => 'Locul trei';

  @override
  String get finishFourthPlace => 'Locul patru';

  @override
  String get finishDidNotQualify => 'Necalificată';

  @override
  String get careerRepIconic => 'Iconic';

  @override
  String get careerRepRenowned => 'Renumit';

  @override
  String get careerRepEstablished => 'Consacrat';

  @override
  String get careerRepRising => 'În ascensiune';

  @override
  String get careerRepUnproven => 'Nedovedit';

  @override
  String get hubOfferStepUp => 'Pas înainte';

  @override
  String get hubOfferLateral => 'Mutare laterală';

  @override
  String get hubOfferRebuild => 'Reconstrucție';

  @override
  String careerNationsCupWon(String league) {
    return 'Liga $league · Campioni';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Liga $league · Locul doi';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Liga $league · Semifinalistă';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Liga $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Urmează: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Urmează: finala mică';

  @override
  String tourRunThrough(String round) {
    return 'Trecuți de faza: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Eliminați în faza: $round';
  }

  @override
  String get tourRunInGroup => 'În faza grupelor';

  @override
  String get tourRunGroupOut => 'Eliminați în faza grupelor';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Ciclul $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played jucate  ·  ${won}V ${drawn}E $lostÎ';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Campionatul Mondial: $finish';
  }

  @override
  String get resultsCycleUnderway => 'În desfășurare';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Conduși cu două goluri de $opponent la pauză și au recuperat tot. Asta e o echipă.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Două goluri în urmă cu $opponent și până la final n-a mai contat. Puține echipe fac asta.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Pauză: două goluri în urmă cu $opponent. Final: nu. Repriza a doua a fost alt meci.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Am revenit de la 0–2 cu $opponent. Orice s-a spus la pauză, spuneți-o în fiecare săptămână.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Bine, am recuperat cu $opponent. Acum să-mi explice cineva primele patruzeci și cinci de minute.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Conduși cu două goluri de $opponent și ar trebui să fim încântați. Reparați prima repriză.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Două goluri avans cu $opponent la pauză și ne-a scăpat. Li se întâmplă și echipelor mai bune.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Două goluri în fața echipei $opponent și ne-a scăpat. Ciclul e lung, e timp destul.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Pauză: două goluri avans cu $opponent. Final: nici pe departe.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Un avantaj de două goluri cu $opponent, dispărut în patruzeci și cinci de minute.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Două goluri avans și am pierdut. Cu $opponent. Cineva trebuie să răspundă.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Două goluri avans cu $opponent și am reușit asta. De fiecare dată.';
  }

  @override
  String get cycleBackupDone =>
      'Cariera a fost salvată în dosarul FNM de pe acest telefon. Dezinstalarea aplicației o șterge: pentru o copie în altă parte, folosiți „Faceți backup acestei salvări” din ecranul salvărilor.';

  @override
  String get cycleBackupFailed => 'Backupul carierei nu a reușit de data asta.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'O seară de neuitat cu $opponent. Cât de mândru sunteți de acest grup?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent nu v-a putut ține piept. Este aceasta echipa în care ați crezut mereu?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'O victorie mare cu $opponent. Ce a făcut diferența în seara asta?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'Victorie cu $opponent, și încă una clară. Unde ați câștigat meciul?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'O victorie bună cu $opponent. O seară bună: de ce ar crede cineva că va dura?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Un rezultat frumos cu $opponent. A fost planul dvs. sau s-au descurcat jucătorii singuri?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'O seară grea cu $opponent. Ce le spuneți jucătorilor după un asemenea meci?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Nimeni nu se aștepta la asta cu $opponent. A fost doar una dintre acele seri?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'A fost o seară umilitoare cu $opponent. Ce n-a mers?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent v-a făcut praf. E lotul acesta destul de bun?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Ați fost depășiți la toate capitolele de $opponent. Cum ați lăsat lucrurile să ajungă atât de rău?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent a marcat după bunul plac. Unde a fost planul în seara asta?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Încă un meci scăpat, de data asta cu $opponent. Cum întoarceți această serie?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Rezultatele au secat, iar meciul cu $opponent a înrăutățit lucrurile. Mai credeți în acest grup?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Iar fără victorie, acum cu $opponent, iar federația urmărește. Vă este postul în siguranță?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'După meciul cu $opponent, seria devine lungă. Sunteți îngrijorat pentru viitorul dvs.?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Acum și $opponent. Predecesorul dvs. a fost demis după o serie ca asta. De ce ați supraviețui dvs.?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'După încă o seară ca aceea cu $opponent, toate emisiunile cu ascultătorii vă vor plecarea. Ați demisiona dacă v-ar cere federația?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'V-ați pus postul în joc, iar după meciul cu $opponent lucrurile nu v-au ieșit. Cum rezistați?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Cele trei meciuri s-au terminat, ultimul cu $opponent. Testul l-ați stabilit chiar dvs. Ce credeți despre verdict?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Ne-ați spus să vă judecăm după următoarele trei. După meciul cu $opponent, am făcut-o. Mai e postul al dvs.?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Trei meciuri, ultimul cu $opponent, și nu ce ați promis. Ați vorbit cu federația despre viitorul dvs.?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Ați stabilit singur testul și l-ați picat cu $opponent. Veți demisiona?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Cuvintele dvs., nu ale noastre: judecați-mă după următoarele trei. După meciul cu $opponent, de ce mai stați pe scaunul acela?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Vreți mai mult de la ei. Pe cineva anume?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Ați pus ștacheta sus. Cine trebuie să facă primul pasul în față?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Spuneți că unii trebuie să se uite la ei înșiși. La cine vă referiți?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Nu e destul de bine, spuneți. Despre cine vorbiți?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Rămâneți vag. Dați nume sau ajunge totul tot la dvs.?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'În fiecare săptămână e vina altcuiva. A cui e de data asta?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Cuvinte curajoase. Și dacă următorul meci nu vă iese?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Țara vă va ține de cuvânt. Ce se întâmplă dacă nu iese?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'Și dacă nu-l câștigați? Atunci ce?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Ați spus-o. Ce se întâmplă dacă vă înșelați?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Am mai auzit promisiuni în sala asta. Ce le datorați suporterilor dacă și aceasta se încalcă?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Și când nu se va întâmpla, care va fi scuza?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Încă una, dacă mai aveți putere. La ce mai trebuie să lucreze acest grup?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Când se așază praful, ce luați din seara asta pentru meciul următor?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Să mergem puțin mai în profunzime. Ce trebuie îmbunătățit înaintea meciului următor?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Dincolo de scor: este lotul acolo unde îl vreți?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Multe cuvinte, puțin conținut. Ce se schimbă concret de acum?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Suporterii vor un răspuns direct. E echipa asta destul de bună, da sau nu?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player a fost excepțional în seara asta. Cât de departe poate ajunge?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player e în toate titlurile în seara asta. V-ați așteptat?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player s-a remarcat. Ce i-ați cerut în seara asta?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '$player a făcut diferența în seara asta?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Fără $player era altă poveste. E o echipă sau un singur jucător?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player a fost genial. Meritul dvs. sau al lui?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player a avut o seară grea. Are vreo problemă medicală?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player n-a avut seara lui. Îl veți susține?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player s-a chinuit în seara asta. Își păstrează locul?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player a părut fără ritm. Ce părere aveți despre jocul lui?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player a fost iar pasager. De ce tot îl alegeți?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Toată lumea a văzut că $player n-a fost în apele lui. Toată lumea, în afară de bancă?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Ați spus că veți câștiga următorul meci și ați făcut-o. E plăcut să aveți dreptate?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Ați promis o victorie în meciul următor și ați livrat-o. Încredere sau bravadă?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Ați spus că veți câștiga următorul meci și ați făcut-o. Noroc, sau ar trebui să începem să vă ascultăm?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Ne-ați spus că veți câștiga acel meci. Nu s-a întâmplat. Ce n-a mers?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Ați spus că veți câștiga următorul meci. N-ați reușit. De ce să credem următoarea promisiune?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Ați spus că veți câștiga următorul meci. N-ați reușit. Mai înseamnă ceva cuvintele dvs. în sala asta?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Ați cerut să fiți judecat după trei meciuri și ați trecut testul. Vă simțiți răzbunat?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Judecați-mă după următoarele trei, ați spus. Am făcut-o și rezultatele au venit. Ce v-a învățat acest test?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'V-ați dat trei meciuri și ați trecut de ele. A fost testul vreodată chiar atât de greu?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Ați cerut să fiți judecat după trei meciuri. Nu v-au ieșit. Ce ați învățat?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Ați spus să vă judecăm după următoarele trei. Cele trei au trecut, și odată cu ele și prezumția de bună-credință. Ce urmează?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Ați stabilit testul și l-ați picat. De ce v-ar mai crede cineva pe cuvânt acum?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'L-ați susținut pe $player când alții n-au făcut-o. A livrat. O parte din merit e a dvs.?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'L-ați susținut pe $player. A livrat. Credință sau cunoaștere?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'L-ați susținut pe $player și, pentru o dată, a meritat. Veți fi la fel de sigur data viitoare?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'L-ați susținut pe $player și n-a mers. Încă mai credeți în el?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'L-ați susținut pe $player. Nu v-a răsplătit. A fost o greșeală?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Judecata sau loialitatea dvs.: care a cedat în cazul lui $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Ați fost dur cu $player, iar meciurile de atunci v-au dat dreptate. Vă aduce vreo satisfacție?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'L-ați criticat public pe $player, iar el n-a răspuns. Mai are cale de întoarcere?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'L-ați lăsat pe $player în bătaia vântului și nu și-a revenit. L-ați distrus?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'L-ați criticat public pe $player, iar el v-a răspuns pe teren. Asta a fost ideea de la început?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'L-ați învinovățit pe $player, iar de atunci a fost unul dintre cei mai buni. Îi datorați scuze?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'L-ați aruncat pe $player în fața lupilor, iar de atunci e cel mai bun jucător al dvs. Îi veți cere scuze?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Acești jucători mi-au dat totul. N-aș schimba niciunul.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Nimeni nu muncește mai mult decât acest grup. Îi voi apăra oricând.';

  @override
  String get pressReplyCreditPlayers3 =>
      'De pe scaunul acesta nu veți auzi niciun cuvânt împotriva jucătorilor mei.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Meritul e al jucătorilor, nu al meu. Scrieți despre ei.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Asta e vina mea. Eu am ales echipa și eu am așezat-o.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Judecați-mă pe mine, nu pe ei. E echipa mea și responsabilitatea mea.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Dacă vreți un vinovat, stau chiar aici.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Responsabilitatea e a mea. Lăsați jucătorii în pace.';

  @override
  String get pressReplyDemandMore1 =>
      'Vreau mai mult. Unii știu exact la ce mă refer.';

  @override
  String get pressReplyDemandMore2 =>
      'Efortul nu ajunge la acest nivel. Vreau mai mult și le-am spus-o.';

  @override
  String get pressReplyDemandMore3 =>
      'Aștept mai mult de la fiecare dintre ei, începând de mâine.';

  @override
  String get pressReplyDemandMore4 =>
      'Unii trebuie să se uite la ei înșiși. Nu sunt mulțumit.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Vom câștiga următorul meci. Puteți nota asta.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Țineți minte ce vă spun: câștigăm meciul următor.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Meciul următor îl câștigăm. O spun aici ca să mă puteți trage la răspundere.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Am încredere în această echipă. Câștigăm meciul următor.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Judecați-mă după următoarele trei meciuri. E corect.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Dați-mi trei meciuri. Dacă lucrurile nu se îndreaptă până atunci, judecați-mă.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Următoarele trei vor arăta dacă sunt omul potrivit. Țineți-mă de cuvânt.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Trei meciuri. Apoi scrieți ce vreți despre mine.';

  @override
  String get pressReplyDeflect1 => 'Luăm meci cu meci. Nimic de adăugat.';

  @override
  String get pressReplyDeflect2 => 'Nu vă dau titluri astăzi.';

  @override
  String get pressReplyDeflect3 => 'Meciul următor. Doar la asta mă gândesc.';

  @override
  String get pressReplyDeflect4 => 'Ce cred eu rămâne în vestiar.';

  @override
  String get pressReplyTakeCredit1 =>
      'Am spus-o pentru că am crezut-o, și am avut dreptate.';

  @override
  String get pressReplyTakeCredit2 =>
      'Am citit corect situația. De asta sunt aici.';

  @override
  String get pressReplyTakeCredit3 => 'Spuneți-i judecată. Știam ce spun.';

  @override
  String get pressReplyTakeCredit4 =>
      'Am luat decizia și a ieșit. Accept asta.';

  @override
  String get pressReplyStandByIt1 =>
      'Am spus ce credeam. Îmi mențin cuvintele.';

  @override
  String get pressReplyStandByIt2 => 'Nu retrag niciun cuvânt.';

  @override
  String get pressReplyStandByIt3 =>
      'Același răspuns ca atunci. Am vorbit serios și încă o fac.';

  @override
  String get pressReplyStandByIt4 => 'Aș spune-o din nou și mâine.';

  @override
  String get pressReplyAdmitMistake1 => 'Am greșit cu asta. Îmi asum.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Corect, am judecat greșit. Voi învăța din asta.';

  @override
  String get pressReplyAdmitMistake3 => 'Am greșit și o pot recunoaște.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Decizia aceea n-a funcționat, și a fost a mea.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player are tot sprijinul meu. Își va reveni.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Cred în $player și vă va arăta de ce.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'De la mine nu veți auzi niciun cuvânt împotriva lui $player. Va livra.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player rămâne în planurile mele. Urmăriți ce face în continuare.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player ne-a dezamăgit în seara asta și știe asta.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Mă așteptam la mult mai mult de la $player. Trebuie să dea un răspuns.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player n-a fost la nivelul cerut. O spun public.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'N-a fost destul de bine din partea lui $player și va auzi asta de la mine.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Declarație oficială: veți câștiga meciul următor.';

  @override
  String get pressOnRecordJob =>
      'Declarație oficială: judecați după următoarele trei.';

  @override
  String pressOnRecordBack(String player) {
    return 'Declarație oficială: sprijin pentru $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Declarație oficială: $player v-a dezamăgit.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'A spus-o și s-a întâmplat. $nation are un selecționer care se ține de cuvânt.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'A spus-o cu voce tare, apoi a făcut-o. Ăsta e omul de care avea nevoie $nation.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: a anticipat și s-a adeverit. Corect.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'A spus-o oficial și s-a confirmat. Unul pentru el. $nation merge mai departe.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'A nimerit una. $nation, nu vă obișnuiți.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Și un ceas stricat arată ora exactă de două ori pe zi. $nation a avut noroc de data asta.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'A spus-o și n-a ieșit. Tot îl susțin. $nation o ia de la capăt.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: a promis mai mult decât am primit, dar prefer un selecționer care crede în el.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: a spus-o oficial și nu s-a întâmplat. Lumea va ține minte.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Vorbe mari, nimic în spate. $nation: data viitoare, mai puține vorbe.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'A stat acolo și ne-a spus. Apoi asta. $nation merită mai mult decât vorbe.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Cuvântul lui nu mai valorează nimic. Notați asta, $nation.';
  }

  @override
  String get ncZoneNorth => 'Zona de Nord';

  @override
  String get ncZoneWest => 'Zona de Vest';

  @override
  String get ncZoneEast => 'Zona de Est';

  @override
  String get ncZoneCentralSouthern => 'Zona Centrală și de Sud';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Campioni';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Locul doi';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Semifinalistă';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Optimi';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Sfertfinalistă';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Atingerea sferturilor';

  @override
  String get objectiveNcZoneWinGroup => 'Câștigarea grupei';

  @override
  String get finishNcFinalsEight => 'Sferturi';

  @override
  String get finishNcBottomHalf => 'A doua jumătate a grupei';

  @override
  String get tourContTabZones => 'ZONE';

  @override
  String get tourContTabFinalsEight => 'ELIMINATORII';

  @override
  String get tourContFinalsEightSoon =>
      'Eliminatoriile încep în noiembrie cu optimile: toate cele 14 câștigătoare de grupă și cele mai bune 2 locuri doi.';

  @override
  String get tourContQuarterFinals => 'SFERTURI';

  @override
  String get tourContZoneAdvancement =>
      'Fiecare câștigătoare de grupă merge în optimi, alături de cele mai bune 2 locuri doi. Nimeni nu retrogradează.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Cupa Națiunilor Americii de Nord';

  @override
  String get compAfricanNationsCup => 'Cupa Națiunilor';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Câștigarea Cupei Națiunilor Americii de Nord';

  @override
  String get objectiveNcWinItAfrica => 'Câștigarea Cupei Națiunilor';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Atingerea finalei Cupei Națiunilor Americii de Nord';

  @override
  String get objectiveNcReachFinalAfrica =>
      'Atingerea finalei Cupei Națiunilor';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Câștigătoarea Cupei Națiunilor Americii de Nord';

  @override
  String get finishNcChampionsAfrica => 'Câștigătoarea Cupei Națiunilor';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Preliminariile pentru $competition încep acum, iar țara crede în această echipă. Ce vă propuneți?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'O nouă campanie de preliminarii pentru $competition, iar moralul e ridicat. Cât de departe poate ajunge echipa?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Încep preliminariile pentru $competition. Care e ținta acestei campanii?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Au sosit preliminariile pentru $competition. Unde vedeți echipa la final?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Încep preliminariile pentru $competition și mulți se îndoiesc că veți ajunge acolo. Ce le transmiteți?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Încă o campanie de preliminarii pentru $competition. De ce ar crede cineva că va fi altfel?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'A sosit $competition și toată țara e în spatele dvs. Cât de departe puteți ajunge?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Sunteți la $competition și fanii visează. Care e obiectivul?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition începe săptămâna aceasta. Ce ar însemna un succes?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Primul meci la $competition se apropie. Dați-ne o țintă.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'A sosit $competition și nimeni nu se așteaptă la mare lucru. Ce sperați de fapt?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Sunteți la $competition, dar îndoielile n-au dispărut. Care e ținta dvs.?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival e în grupa dvs. Vă îngrijorează?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Tragerea la sorți v-a pus în cale $rival. Cum vedeți acel meci?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival pare cea mai puternică echipă din grupa dvs. E favorită?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Ce părere aveți despre $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival e în grupa dvs. Sincer, îi puteți ține piept?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Majoritatea se așteaptă ca $rival să vă învingă. Se înșală?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player e într-o formă excelentă. E momentul lui?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player e în toate titlurile. Poate duce echipa în spate?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Cât depinde această campanie de $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'E $player pregătit să conducă această echipă?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Dacă $player nu e la cel mai bun nivel, mai are echipa ceva?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player are multe pe umeri. Prea multe?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Vom merge mai departe decât se așteaptă oricine.';

  @override
  String get pressReplyAimHigher2 =>
      'Vreau mai mult decât a cerut federația și o spun cu voce tare.';

  @override
  String get pressReplyMatchBrief1 => 'Știm ținta și o vom atinge.';

  @override
  String get pressReplyMatchBrief2 =>
      'Federația a stabilit o țintă. O vom îndeplini.';

  @override
  String get pressReplyPlayDown1 => 'Să luăm meci cu meci.';

  @override
  String get pressReplyPlayDown2 =>
      'Fără promisiuni mari. Vom vedea unde suntem.';

  @override
  String get pressReplyPromiseQualify1 => 'Ne vom califica. Puteți nota asta.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Această echipă va fi la turneul final.';

  @override
  String get pressReplyFearNobody1 => 'Nu ne temem de nimeni.';

  @override
  String get pressReplyFearNobody2 => 'Și ei trebuie să joace cu noi.';

  @override
  String get pressReplyRespectRival1 => 'Ei sunt favoriții și îi respectăm.';

  @override
  String get pressReplyRespectRival2 =>
      'O echipă foarte bună. Vom avea nevoie de ce avem mai bun.';

  @override
  String get pressReplyTeamFirst1 =>
      'E vorba de toată echipa, nu de un singur jucător.';

  @override
  String get pressReplyTeamFirst2 => 'Nimeni nu câștigă singur.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Declarație oficială: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Declarație oficială: fără promisiuni.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Ați stabilit o țintă înaintea campaniei și ați atins-o. E cel mai mândru moment de până acum?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Ați spus ce veți realiza și ați realizat. A fost vreodată în dubiu?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Ați atins ținta pe care v-ați propus-o. Noroc, sau chiar a fost planul?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Ați stabilit o țintă și n-ați atins-o. Ce n-a mers?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Ați promis mai mult decât a oferit echipa. Regretați că ați spus-o?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Ați vorbit mult înaintea campaniei și n-ați atins ținta. De ce v-am crede acum?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Presa vrea să vă afle obiectivele pentru $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Nivelul $level · $amount';
  }

  @override
  String get formOnFire => 'În flăcări';

  @override
  String get formGood => 'În formă';

  @override
  String get formSteady => 'Constant';

  @override
  String get formPoor => 'Fără formă';

  @override
  String get formCold => 'Rece ca gheața';

  @override
  String get playerFormTitle => 'FORMĂ ȘI CONDIȚIE';

  @override
  String playerFormAverage(String rating) {
    return 'Medie de $rating în ultimele meciuri';
  }

  @override
  String get playerFormNoGames =>
      'Prea puține meciuri recente pentru o evaluare';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta la valoare în meciul următor';
  }

  @override
  String get playerFormNoEffect =>
      'Nicio schimbare de valoare în meciul următor';

  @override
  String get sideGroupHome => 'Acasă';

  @override
  String get sideGroupTeam => 'Echipă';

  @override
  String get sideGroupCompetitions => 'Competiții';

  @override
  String get sideGroupFederation => 'Federație';

  @override
  String get sideGroupHistory => 'Istorie';

  @override
  String get sideInbox => 'Mesaje';

  @override
  String get sideSquad => 'Lot';

  @override
  String get sideTactics => 'Tactică';

  @override
  String get sideMainMenu => 'Meniu principal';

  @override
  String get sideCallUps => 'Convocări';

  @override
  String get sideTournaments => 'Turnee';

  @override
  String get sideRanking => 'Clasament';

  @override
  String get sideResults => 'Rezultate';

  @override
  String get sideFinances => 'Finanțe';

  @override
  String get sideBoard => 'Federație';

  @override
  String get sideManager => 'Selecționer și staff';

  @override
  String get sideRecords => 'Recorduri';

  @override
  String get sideLegends => 'Legende';

  @override
  String get sideHeadToHead => 'Meciuri directe';

  @override
  String get sideAchievements => 'Realizări';

  @override
  String get sideCareer => 'Carieră';

  @override
  String get topBarNext => 'Următorul';

  @override
  String get topBarDrawPending => 'Urmează tragerea';

  @override
  String get paneFullProfile => 'Profil complet';

  @override
  String get panePickPlayer => 'Alegeți un jucător ca să-i vedeți fișa aici';

  @override
  String get inboxPickMessage => 'Alegeți un mesaj ca să-l citiți aici';

  @override
  String get inboxFilterAll => 'Toate';

  @override
  String get panelViewAll => 'Vedeți tot';

  @override
  String get gridViewOverview => 'Privire generală';

  @override
  String get gridColCondition => 'Condiție';

  @override
  String get gridColStatus => 'Stare';

  @override
  String get gridColRank => 'Loc';

  @override
  String get gridColMove => 'Evoluție';

  @override
  String get gridColNation => 'Națiune';

  @override
  String get gridColRegion => 'Regiune';

  @override
  String get gridColPoints => 'Puncte';

  @override
  String get panePickNation => 'Alegeți o națiune ca să-i vedeți bilanțul aici';

  @override
  String get resultsCyclesTitle => 'Cicluri';

  @override
  String get tourDrawStart => 'Începeți tragerea';

  @override
  String get tourDrawViewGroups => 'Vedeți grupele';

  @override
  String get gridColCeiling => 'Plafon';

  @override
  String get gridColYearGain => 'Progres';

  @override
  String get gridColMarkedAt => 'La marcare';

  @override
  String get budgetSetupTitle => 'Stabiliți bugetul';

  @override
  String get budgetEffectsTitle => 'Ce cumpără acest buget';

  @override
  String get naturalisationTitle => 'Naturalizare';

  @override
  String get yTrending => 'În tendințe';

  @override
  String get yVoices => 'Voci';

  @override
  String get yConversation => 'Conversație';

  @override
  String get allTimeRecordsTitle => 'Recorduri mondiale all-time';

  @override
  String get h2hMeetingsTitle => 'Toate întâlnirile';

  @override
  String get h2hPickOpponent =>
      'Alegeți un adversar ca să vedeți aici toate întâlnirile';

  @override
  String get savesTitle => 'Salvări';

  @override
  String get gridColPlayer => 'Jucător';

  @override
  String get gridColPos => 'Post';

  @override
  String get gridColActive => 'Activ';

  @override
  String get gridColMotm => 'OM';

  @override
  String get gridColAvg => 'Medie';

  @override
  String get gridColOpponent => 'Adversar';

  @override
  String get gridColStarts => 'Titular';

  @override
  String get gridColTournaments => 'Turnee';

  @override
  String get gridColDate => 'Dată';

  @override
  String get gridColLastPlayed => 'Ultima dată';

  @override
  String get gridColManager => 'Selecționer';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de națiuni',
      few: '$count națiuni',
      one: '1 națiune',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Sortate după clasamentul mondial';

  @override
  String get nationsStrength => 'Forță';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier din 5';
  }

  @override
  String get nationsSquadOverall => 'Valoarea lotului';

  @override
  String get nationsOpeningBudget => 'Buget inițial';

  @override
  String get nationsStarPlayer => 'Vedeta echipei';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Vedetă $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return '$age ani';
  }

  @override
  String get nationsBoardExpects => 'Federația așteaptă';

  @override
  String nationsManage(String nation) {
    return 'Preluați $nation';
  }

  @override
  String get nationsManagerNext => 'Urmează să alegeți numele selecționerului';

  @override
  String get playerPageTitle => 'Jucător';

  @override
  String get nationPageTitle => 'Națiune';

  @override
  String get friendliesYourGames => 'Amicalele dvs.';

  @override
  String hubEventInjuryCover(String player) {
    return 'Înlocuiți accidentatul: $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Indisponibil $matches de meciuri',
      few: 'Indisponibil $matches meciuri',
      one: 'Indisponibil pentru meciul următor',
    );
    return '$_temp0. Convocați pe cineva sau continuați fără el.';
  }

  @override
  String get injuryCoverTitle => 'ÎNLOCUITOR';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) este accidentat. Convocați pe oricine din afara lotului, pe orice post, sau păstrați-l și continuați.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Convocați-l pe $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Păstrați-l pe $player și continuați';
  }

  @override
  String get injuryCoverPick => 'Alegeți un înlocuitor';

  @override
  String get injuryCoverNone => 'Nimeni din afara lotului nu e apt să vină.';

  @override
  String get nationNowRanking => 'Clasamentul mondial';

  @override
  String get nationNowForm => 'Formă';

  @override
  String get nationNowNoForm => 'Niciun meci jucat încă';

  @override
  String get nationNowNext => 'Meciul următor';

  @override
  String get nationNowNoNext => 'Nimic programat';

  @override
  String get nationNowSquad => 'Lot';

  @override
  String get nationNowAgainstYou => 'Împotriva dvs.';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}V ${d}E $lÎ';
  }

  @override
  String get nationNowLastMeeting => 'Ultima întâlnire';

  @override
  String nationNowOverall(int value) {
    return 'General $value';
  }

  @override
  String get hubUpcoming => 'URMĂTOARELE MECIURI';

  @override
  String get hubFullSchedule => 'Programul complet';

  @override
  String get scheduleTitle => 'Program';

  @override
  String get scheduleToday => 'Azi';

  @override
  String get scheduleKnockoutPending => 'Eliminatorii, dacă vă calificați';

  @override
  String get scheduleNextRoundPending => 'Runda următoare';

  @override
  String scheduleFromDate(String date) {
    return 'De la $date';
  }

  @override
  String get scheduleHomeShort => 'A';

  @override
  String get scheduleAwayShort => 'D';

  @override
  String get tacticsNoPresetsInMatch =>
      'Încă nicio tactică salvată. Salvați una din ecranul Tactică înainte de meci.';

  @override
  String get homeCampaigns => 'Campanii';

  @override
  String get homeContinueCampaign => 'CONTINUAȚI CAMPANIA';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Ciclul $cycle din $total';
  }

  @override
  String get campaignsTitle => 'Campanii';

  @override
  String get campaignTransplantTitle => 'Transplantul';

  @override
  String get campaignTransplantTwist =>
      'Opt dintre cei mai buni italieni trec la San Marino';

  @override
  String get campaignTransplantGoal => 'Calificarea la Campionatul European';

  @override
  String get campaignGrudgeTitle => 'Ranchiună';

  @override
  String get campaignGrudgeTwist => 'Georgia și Albania, în aceeași grupă';

  @override
  String get campaignGrudgeGoal => 'Terminați preliminariile înaintea Albaniei';

  @override
  String get campaignTransplantIntro =>
      'San Marino n-a avut niciodată o campanie de preliminarii demnă de acest nume. Apoi opt dintre cei mai buni italieni primesc pașaportul și intră în echipă. Aveți un ciclu ca să transformați o curiozitate într-o echipă.';

  @override
  String get campaignGrudgeIntro =>
      'Georgia și Albania au fost trase în aceeași grupă preliminară și niciuna nu va ierta o înfrângere. Terminați înaintea Albaniei, apoi vedeți cât de departe puteți duce echipa.';

  @override
  String get campaignStars1Transplant => 'Calificarea';

  @override
  String get campaignStars2Transplant => 'Atingerea eliminatoriilor';

  @override
  String get campaignStars3Transplant => 'Câștigarea Campionatului European';

  @override
  String get campaignStars1Grudge => 'Înaintea Albaniei';

  @override
  String get campaignStars2Grudge => 'Și calificarea';

  @override
  String get campaignStars3Grudge => 'Și două victorii cu ea';

  @override
  String get campaignFree => 'Gratuit';

  @override
  String get campaignStart => 'Start';

  @override
  String get campaignPartOfUnlimited => 'Parte din Unlimited';

  @override
  String get campaignResume => 'Reluați';

  @override
  String get campaignAbandon => 'Abandonați';

  @override
  String get campaignAbandonConfirm =>
      'Abandonați această încercare? Progresul se pierde; ștampila rămâne.';

  @override
  String get campaignMoveToSaves => 'Mutați la salvări';

  @override
  String get campaignCannotContinue =>
      'Lumea acestei campanii este prea departe de cea reală ca să continue ca o carieră.';

  @override
  String get campaignMoveSlotsFull =>
      'Sloturile de salvare sunt pline. Eliberați unul mai întâi.';

  @override
  String get campaignStampConquered => 'Cucerită';

  @override
  String get campaignStampFailed => 'Eșuată';

  @override
  String get campaignDifficultyHard => 'Grea';

  @override
  String get campaignDifficultyMedium => 'Medie';

  @override
  String get campaignGoalLabel => 'Obiectiv';

  @override
  String get campaignStarsLabel => 'Stele';

  @override
  String get campaignRunInProgress =>
      'Această campanie are deja o încercare în desfășurare.';

  @override
  String get campaignVerdictWon => 'Cucerită';

  @override
  String get campaignVerdictLost => 'Nu de data asta';

  @override
  String get campaignVerdictContinue => 'Continuați';

  @override
  String campaignProgressQualifying(String position) {
    return 'Preliminarii: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Turneu final: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Încercarea în cifre';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Întâlniri câștigate: $won din $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': 'locul 1',
        'second': 'locul 2',
        'third': 'locul 3',
        'other': 'locul $n',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Cea mai bună Guinee';

  @override
  String get campaignGuineasTwist =>
      'Guineea Ecuatorială, cea mai mică dintre Guineele Africii, timp de două cicluri';

  @override
  String get campaignGuineasGoal => 'Învingeți Guineea și Guineea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Trei națiuni africane poartă numele Guineea, iar Guineea Ecuatorială e cea mai mică dintre ele. Aveți două cicluri ca să învingeți măcar o dată Guineea și Guineea-Bissau, apoi să vedeți cât de departe puteți ajunge la Campionatul African. Papua-Noua Guinee, a patra Guinee, e deja programată pentru un amical.';

  @override
  String get campaignStars1Guineas => 'Învingeți Guineea și Guineea-Bissau';

  @override
  String get campaignStars2Guineas => 'Și calificarea la un Campionat African';

  @override
  String get campaignStars3Guineas => 'Și sferturile unui Campionat African';

  @override
  String get campaignYoungFinnsTitle => 'Tinerii finlandezi';

  @override
  String get campaignYoungFinnsTwist =>
      'Generația de aur de adolescenți a Finlandei, timp de trei cicluri';

  @override
  String get campaignYoungFinnsGoal => 'Calificarea la un Campionat Mondial';

  @override
  String get campaignYoungFinnsIntro =>
      'Seniorii Finlandei s-au retras, iar locul lor l-a luat o generație de aur: fiecare jucător pe care îl puteți alege are cel mult 18 ani. Necizelați azi, au talentul să devină una dintre cele mai bune echipe din lume, la fel ca tânăra generație a Norvegiei. Aveți trei cicluri ca să-i duceți la un Campionat Mondial, apoi să câștigați Campionatul European și Campionatul Mondial.';

  @override
  String get campaignStars1YoungFinns => 'Calificarea la un Campionat Mondial';

  @override
  String get campaignStars2YoungFinns => 'Câștigarea Campionatului European';

  @override
  String get campaignStars3YoungFinns => 'Câștigarea Campionatului Mondial';

  @override
  String get campaignGreenlandTitle => 'Un secol de Groenlanda';

  @override
  String get campaignGreenlandTwist =>
      'Groenlanda ia locul San Marinoului în Europa, pentru o sută de ani';

  @override
  String get campaignGreenlandGoal => 'Calificarea la un Campionat European';

  @override
  String get campaignGreenlandIntro =>
      'Groenlanda n-a jucat niciodată un meci internațional oficial. În această lume a luat locul San Marinoului în Europa și pornește de pe ultimul loc din clasamentul mondial: jucători amatori, terenuri sintetice și un sezon strâns între ninsori. Aveți o sută de ani, douăzeci și cinci de cicluri, ca să ajungeți la un Campionat European, apoi la un Campionat Mondial și, dacă îndrăzniți să visați, să câștigați unul dintre ele.';

  @override
  String get campaignStars1Greenland => 'Calificarea la un Campionat European';

  @override
  String get campaignStars2Greenland => 'Calificarea la un Campionat Mondial';

  @override
  String get campaignStars3Greenland =>
      'Câștigarea Campionatului European sau Mondial';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Necalificată';

  @override
  String get campaignCupOpen => 'De decis';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name strălucește la $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Raport de la academie: $name iese în evidență';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Remarcatul de la $level: $name';
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
      other: 'de $count de ori',
      few: 'de $count ori',
      one: 'o dată',
    );
    return '$name a marcat $_temp0 pentru $level cu $opponent în ultima fereastră internațională.';
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
      other: '$count de goluri',
      few: '$count goluri',
      one: 'Un gol',
    );
    return '$_temp0 pentru $name în meciul echipei $level cu $opponent din această fereastră.';
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
      other: '$count de goluri',
      few: '$count goluri',
      one: 'un gol',
    );
    return '$level a jucat cu $opponent, iar $name a plecat cu $_temp0 în cont.';
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
      other: 'de $count de ori',
      few: 'de $count ori',
      one: 'o dată',
    );
    return '$name a pasat decisiv $_temp0 pentru $level cu $opponent și a dirijat jocul de la început până la sfârșit.';
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
      other: '$count de pase decisive',
      few: '$count pase decisive',
      one: 'o pasă decisivă',
    );
    return '$level a întâlnit $opponent în această fereastră, iar $name a tras sforile: $_temp0 și un joc despre care staff-ul încă vorbește.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name a fost excepțional, iar $level n-a primit gol cu $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return '$level n-a primit gol cu $opponent, iar $name a fost motivul principal.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name a impresionat pentru $level cu $opponent, iar staff-ul i-a dat nota $mark din zece.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$level a jucat cu $opponent în această fereastră, iar antrenorii l-au remarcat pe $name: nota $mark din zece, cea mai mare din echipă.';
  }

  @override
  String get newsYouthDevReady1 =>
      'În forma asta, e deja suficient de bun ca să fie luat în calcul pentru lotul de seniori.';

  @override
  String get newsYouthDevReady2 =>
      'Staff-ul crede că e pregătit pentru fotbalul de seniori acum. Decizia vă aparține.';

  @override
  String get newsYouthDevClose1 =>
      'Progresează bine și e aproape de lotul de seniori.';

  @override
  String get newsYouthDevClose2 =>
      'Nu e departe de lotul de seniori, iar încă un sezon bun ar putea fi suficient.';

  @override
  String get newsYouthDevGrowing1 =>
      'Se dezvoltă frumos, deși lotul de seniori e încă la un pas sau doi distanță.';

  @override
  String get newsYouthDevGrowing2 =>
      'Mai e de muncă până să devină internațional de seniori, dar totul merge în direcția bună.';

  @override
  String get newsYouthDevRaw1 =>
      'E încă necizelat și la câțiva ani de lotul de seniori, dar talentul se vede clar.';

  @override
  String get newsYouthDevRaw2 =>
      'E devreme, iar staff-ul academiei cere răbdare, nu titluri în presă.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Anvergura și autoritatea în careu sunt ce îl deosebesc.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Prinderea mingii și relansarea sunt cele mai bune văzute la academie în ultimii ani.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Concentrarea lui nu scade niciodată: e la fel de atent în minutul nouăzeci ca în primul.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Viteza și jocul aerian sunt esențiale în jocul lui.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Citește jocul mult peste vârsta lui și e calm cu mingea la picior.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Nu se deconectează niciodată și încă sprintează înapoi în ultimul minut.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Recuperează mingea cu forță și o duce în față.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Viziunea și gama de pase sunt esențiale în jocul lui.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Are un motor remarcabil: acoperă fiecare fir de iarbă.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Viteza în spatele apărării și forța în jocul aerian îl fac un coșmar pentru orice defensivă.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Finalizarea și mișcarea în careu sunt esențiale în jocul lui.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Presează din față tot meciul și nu le dă fundașilor nicio clipă de liniște.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Fanii vor cânta mult timp despre meciul cu $opponent. Ce le-ați spus jucătorilor la fluierul final?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'A fost o declarație de forță cu $opponent. Cât din asta a venit de la antrenamente?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Felicitări pentru rezultatul cu $opponent, dar am mai văzut asemenea seri. Ce e diferit de data asta?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Oricine are o seară proastă, iar aceea cu $opponent a fost una. Cât de repede o puteți lăsa în urmă?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent v-a depășit la toate capitolele. De unde începeți reparațiile?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Suporterii plecau înainte de final la meciul cu $opponent. Îi puteți condamna?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'A fost o perioadă grea, iar meciul cu $opponent n-a ușurat-o deloc. Ce vă ține în picioare?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Încă un meci fără victorie, de data asta cu $opponent. Cât poate continua așa până când federația va acționa?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Acum și $opponent. Mai e ceva în planul dvs. sau e timpul să faceți loc altcuiva?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Orice scrieți, scrieți despre jucători. Au meritat-o.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Am un grup care ar trece prin ziduri unii pentru alții. Asta nu e puțin lucru.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Eu iau deciziile, deci critica vine la mine. Asta e meseria.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Uitați-vă întâi la selecționer. Am greșit unele lucruri și le voi îndrepta.';

  @override
  String get pressReplyDemandMore5 =>
      'Bine nu e destul aici. Le-am spus-o în față.';

  @override
  String get pressReplyDemandMore6 =>
      'Nimeni din vestiar nu are locul garantat. Acum știu asta.';

  @override
  String get pressReplyDeflect5 =>
      'Puteți pune întrebarea în trei feluri. Veți primi același răspuns.';

  @override
  String get pressReplyDeflect6 =>
      'Gândurile mele le păstrez pentru jucători. Veți înțelege.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score cu $opponent. Fotbal calm, controlat, matur. Așa da.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return 'Victorie cu $opponent, $score, fără să transpirăm. Echipa asta devine bună la plictiseală, iar plictiseala câștigă trofee.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Trei puncte, fără dramă, înapoi la treabă.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Un $score de rutină cu $opponent. Nimeni nu și-l va aminti și nici nu trebuie.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score cu $opponent și cumva tot am rămas îngrijorat.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return 'Victorie cu $opponent, $score. Cu o echipă adevărată, un asemenea joc se plătește.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score cu $opponent. Ne-am încleștat, am suferit, am câștigat. Asta e o echipă.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return 'Victorie cu $opponent, $score, doar din nervi. Accept oricând o echipă care refuză să piardă.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. S-a decis pe muchie de cuțit, dar punctele sunt ale noastre.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Un $score la limită cu $opponent. Nu prea mare diferență, asta e fotbalul.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score cu $opponent. O singură săritură norocoasă în partea cealaltă și am purta o cu totul altă discuție.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Ne-am agățat de rezultat cu $opponent, $score. Nimeni n-ar trebui să numească asta un joc bun.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score cu $opponent. Nu e înfrângere, și uneori asta e treaba.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Un punct muncit cu $opponent, $score. Mi-a plăcut lupta din noi.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Egalitate perfectă, cum ziceau comentatorii de altădată.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score cu $opponent. Niciuna n-a făcut destul ca să merite mai mult.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score cu $opponent. Genul de egal care se simte ca o înfrângere în autocar, la întoarcere.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Egal, $score, cu $opponent. Tot vorbim de progres și tot facem asta.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score cu $opponent. Doare, dar am văzut destul ca să cred în echipa asta.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Învinși cu $score de $opponent, și au fost buni. Respect, și o luăm de la capăt.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. O înfrângere, câteva lecții și următorul meci vine curând.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Am pierdut cu $score în fața echipei $opponent. Greu de contestat.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score cu $opponent. Aceleași greșeli ca data trecută, făcute cu aceeași siguranță.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Învinși cu $score de $opponent. Dacă nimeni nu răspunde pentru asta, ce facem aici?';
  }

  @override
  String get yReactionShrug12 =>
      'Pentru mine e în regulă. Nu orice seară are nevoie de artificii.';

  @override
  String get yReactionShrug13 =>
      'Punctele sunt puncte. Dorm liniștit la noapte.';

  @override
  String get yReactionShrug14 => 'L-am văzut. N-am comentarii.';

  @override
  String get yReactionShrug15 => 'Undeva între bine și bine.';

  @override
  String get yReactionShrug16 =>
      'Am plătit streamul pentru asta. Niciodată (mă întorc).';

  @override
  String get yReactionShrug17 =>
      'Nouăzeci de minute de nimic în formă de fotbal.';

  @override
  String get yReactionRelief12 =>
      'Respir din nou. Mândru de ei că au rezistat.';

  @override
  String get yReactionRelief13 =>
      'Astea sunt victoriile care construiesc o echipă. Urâtul e frumos.';

  @override
  String get yReactionRelief14 => 'Unghiile s-au dus, dar punctele au rămas.';

  @override
  String get yReactionRelief15 =>
      'Fluierul final n-a sunat niciodată atât de bine.';

  @override
  String get yReactionRelief16 =>
      'Mă bucur că am câștigat, mă îngrijorează cum am câștigat.';

  @override
  String get yReactionRelief17 =>
      'Tot scăpăm basma curată. Într-o zi n-o să mai scăpăm.';

  @override
  String get yReactionFury12 => 'Iubesc echipa asta și tocmai de aceea doare.';

  @override
  String get yReactionFury13 =>
      'Seară proastă. Ne datorează una data viitoare și știu asta.';

  @override
  String get yReactionFury14 =>
      'Am închis după șaptezeci de minute. Trebuia după șaizeci.';

  @override
  String get yReactionFury15 => 'Fără luptă, fără idei, fără scuze.';

  @override
  String get yReactionFury16 =>
      'Aceleași probleme de fiecare dată și nimeni nu repară nimic.';

  @override
  String get yReactionFury17 =>
      'Cineva de la federație trebuie să revadă asta și să explice.';

  @override
  String get backupShareHint =>
      'Creează un singur fișier de backup cu toate salvările. Alegeți Google Drive, iCloud Drive sau Fișiere ca să-l păstrați.';

  @override
  String backupLastAt(String date) {
    return 'Ultimul backup: $date';
  }

  @override
  String get backupNever => 'Niciun backup încă';

  @override
  String get backupRemindersTitle => 'Mementouri pentru backup';

  @override
  String get backupRemindersBlurb =>
      'O notă în mesaje când ultimul backup se învechește.';

  @override
  String get backupAutoICloudTitle => 'Backup automat în iCloud';

  @override
  String get backupAutoDriveTitle => 'Backup automat în Google Drive';

  @override
  String get backupAutoBlurb =>
      'Face backup după meciuri, la finalul unui ciclu și când ieșiți din aplicație. Le păstrează pe ultimele două.';

  @override
  String get backupStatusUploading => 'Se face backup acum.';

  @override
  String get backupStatusUploaded => 'Backup realizat.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud este dezactivat. Conectați-vă la iCloud și activați iCloud Drive din aplicația Configurări.';

  @override
  String get backupStatusDriveSignedOut =>
      'Nu sunteți conectat. Activați comutatorul ca să vă conectați cu Google.';

  @override
  String get backupStatusNotConfigured =>
      'Încă indisponibil în această versiune a aplicației.';

  @override
  String get backupStatusUnavailable =>
      'Cloudul nu poate fi accesat acum. Se va reîncerca mai târziu.';

  @override
  String get backupStatusFailed =>
      'Ultimul backup automat nu a reușit. Se va reîncerca mai târziu.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Conectat ca $email';
  }

  @override
  String get backupDriveSignOut => 'DECONECTARE';

  @override
  String get backupDriveSignInFailed =>
      'Conectarea cu Google nu a reușit. Încercați din nou mai târziu.';

  @override
  String get backupRestoreICloud => 'RESTAURAȚI DIN ICLOUD';

  @override
  String get backupRestoreDrive => 'RESTAURAȚI DIN GOOGLE DRIVE';

  @override
  String get backupCrossPlatformHelp =>
      'Treceți între iPhone și Android? Faceți backup într-un fișier pe un telefon, apoi restaurați din acel fișier pe celălalt.';

  @override
  String get backupCloudListBlurb =>
      'Backupuri de pe dispozitivele dvs. din acest cont. Atingeți unul ca să-l restaurați.';

  @override
  String get backupCloudListEmpty =>
      'Niciun backup găsit încă. Un backup nou poate avea nevoie de câteva minute ca să ajungă pe alt dispozitiv.';

  @override
  String get backupCloudListFailed =>
      'Backupurile nu au putut fi citite. Verificați conexiunea și încercați din nou.';

  @override
  String get backupCloudThisDevice => 'Acest dispozitiv';

  @override
  String backupCloudMore(int count) {
    return 'Alte salvări: $count';
  }

  @override
  String get backupCloudNewer =>
      'Creat cu o versiune mai nouă a aplicației. Actualizați mai întâi.';

  @override
  String get backupCloudDownloading => 'Se descarcă backupul.';

  @override
  String get backupRestoreSafetyNote =>
      'Mai întâi se păstrează pe acest telefon o copie a salvărilor actuale.';

  @override
  String get backupRejectedSafety =>
      'Nu s-a putut păstra o copie a salvărilor actuale, așa că nu s-a înlocuit nimic.';

  @override
  String get newsBackupReminderTitle => 'E timpul pentru un backup';

  @override
  String get newsBackupReminderBody =>
      'Salvările dvs. există doar pe acest telefon. Deschideți Setări și atingeți Backup în cloud sau activați acolo backupul automat. Aceste mementouri pot fi dezactivate tot din Setări.';

  @override
  String get backupSafetyTitle => 'Copii dinaintea unei restaurări';

  @override
  String get backupSafetyBlurb =>
      'Păstrate pe acest telefon în cazul în care o restaurare a fost greșită. Se păstrează cele mai noi trei.';

  @override
  String get backupSafetyRestore => 'RESTAURAȚI';

  @override
  String get backupSafetyShare => 'PARTAJAȚI';

  @override
  String get backupCloudNoDetails => 'Detaliile sunt încă pe drum.';

  @override
  String get tacticsLibraryTitle => 'BIBLIOTECA DE TACTICI';

  @override
  String get tacticsLibraryBlurb =>
      'Tacticile din bibliotecă pot fi încărcate în orice salvare, inclusiv în cele noi. Rolurile și executanții fazelor fixe se păstrează pe posturi, nu pe jucători.';

  @override
  String get tacticsSaveToLibrary => 'Salvați în bibliotecă';

  @override
  String get tacticsLoadFromLibrary => 'Încărcați din bibliotecă';

  @override
  String get tacticsLibraryEmpty =>
      'Biblioteca e goală. Salvați aici o tactică și o puteți încărca în orice salvare.';

  @override
  String tacticsLibrarySaved(String name) {
    return '„$name” a fost salvată în bibliotecă';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'S-a încărcat „$name”';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count de roluri sau executanți de faze fixe nu s-au potrivit acestui lot.',
      few:
          '$count roluri sau executanți de faze fixe nu s-au potrivit acestui lot.',
      one: '1 rol sau executant de faze fixe nu s-a potrivit acestui lot.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Redenumiți';

  @override
  String get tacticsLibraryRenameTitle => 'Redenumiți tactica';

  @override
  String get tacticsLibraryDelete => 'Ștergeți';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Ștergeți „$name”?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Va dispărea din bibliotecă în toate salvările dvs.';

  @override
  String get tacticsLibraryNameTaken =>
      'Biblioteca are deja o tactică cu acest nume.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Biblioteca nu a putut fi încărcată.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Candidatură de găzduire: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Candidatură de găzduire';

  @override
  String get hostBidBlurb =>
      'Gazda este aleasă prin tragere la sorți dintre candidați. O candidatură vă dă mai multă greutate: stadioanele vă oferă o șansă de pornire, iar banii o măresc, fiecare milion în plus contând puțin mai puțin. Banii se cheltuiesc indiferent dacă câștigați sau nu.';

  @override
  String hostBidPrize(String amount) {
    return 'Dacă câștigați, găzduiți turneul, vă calificați automat și primiți o subvenție unică de $amount pentru următorul buget.';
  }

  @override
  String get hostBidChance => 'Șansa de a găzdui';

  @override
  String get hostBidBaseLabel => 'Stadioane și statut';

  @override
  String get hostBidInvestLabel => 'Investiție';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Plafon pentru $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Investiția dumneavoastră';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Fonduri disponibile: $amount';
  }

  @override
  String get hostBidSubmit => 'Depuneți candidatura';

  @override
  String get hostBidDecline => 'Nu de data aceasta';

  @override
  String get hostBidUnavailable => 'Această candidatură nu mai este deschisă.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Candidatură câștigată: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Vom găzdui turneul și ne calificăm automat ca gazdă. O subvenție unică de $amount se află acum în fondurile federației și o puteți repartiza departamentelor din acest ciclu direct din Centru.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Candidatură pierdută: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Gazda aleasă: $hosts. Candidatura noastră nu a fost suficientă de data aceasta, iar banii cheltuiți s-au dus, dar federația și-a susținut cauza.';
  }

  @override
  String get hostBidGrantEvent => 'Repartizați subvenția de găzduire';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Subvenție de găzduire: $amount de adăugat acum departamentelor din acest ciclu. Ce ați stabilit deja rămâne, iar restul rămâne în bancă.';
  }

  @override
  String get stadiumsTitle => 'Stadioane naționale';

  @override
  String get stadiumsEntrySub =>
      'Modernizați un stadion sau construiți unul nou';

  @override
  String get stadiumsBlurb =>
      'Nivelul unui stadion este mărimea sa: nivelul 1 sub 15.000 de locuri, nivelul 2 de la 15.000, nivelul 3 de la 25.000, nivelul 4 de la 40.000, nivelul 5 de la 60.000. Fiecare stadion aduce un mic venit la începutul fiecărui ciclu, mai mult cu cât are mai multe locuri, cât timp suporterii le umplu. O modernizare adaugă locuri imediat și puțină reputație din ciclul următor; o reducere taie întreținerea, dar nu rambursează nimic. Stadioanele dvs. decid pentru ce turnee puteți candida.';

  @override
  String stadiumsIncome(String amount) {
    return 'Venit din stadioane: $amount pe ciclu';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Reputație din stadioane: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Lucrările se comandă la începutul ciclului, înainte de stabilirea bugetului.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Capacitate: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Nivelul $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Modernizare: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Nivel maxim';

  @override
  String stadiumsOpens(int year) {
    return 'În construcție, se deschide în $year';
  }

  @override
  String get stadiumsBuildTitle => 'Construiți un stadion nou';

  @override
  String get stadiumsBuildBody =>
      'Destul de scump: un stadion nou în orașul ales, deschis de la începutul ciclului următor.';

  @override
  String get stadiumsBuildCity => 'Oraș';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Construcție: $cost';
  }

  @override
  String get stadiumsBuilding => 'Un stadion este deja în construcție.';

  @override
  String get stadiumsNoCity => 'Fiecare oraș are deja un stadion nou.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Modernizați $stadium la nivelul $level pentru $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Construiți un stadion nou în $city pentru $cost?';
  }

  @override
  String get stadiumsConfirm => 'Confirmați';

  @override
  String get stadiumsCancel => 'Anulați';

  @override
  String get stadiumsRefused =>
      'Comanda nu a fost acceptată. Nu s-a plătit nimic.';

  @override
  String get stadiumsNameLabel => 'Numele stadionului';

  @override
  String get stadiumsNameHint =>
      'Lăsați câmpul gol pentru a păstra numele propus.';

  @override
  String get stadiumsRename => 'Redenumește stadionul';

  @override
  String get hostBidSectionTitle => 'Candidaturi de găzduire';

  @override
  String get hostBidOpenSub =>
      'Opțional. Decideți înainte să înceapă noul ciclu.';

  @override
  String get hostBidDecidedAtRollover =>
      'Gazda este anunțată la începutul noului ciclu.';

  @override
  String get hostBidLodged =>
      'Candidatură depusă. Gazda este anunțată la începutul noului ciclu.';

  @override
  String get hostBidDeclinedNote => 'De data aceasta ați ales să nu candidați.';

  @override
  String get hostBidOpensLater =>
      'Eligibil. Puteți candida la sfârșitul acestui ciclu.';

  @override
  String get hostBidNoFunds =>
      'Nu sunt destule fonduri disponibile pentru candidatură.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Stadioane de $seats+ locuri care vă lipsesc: $count.',
      one: 'Vă mai trebuie 1 stadion de $seats+ locuri.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return 'Ultimul Campionat Mondial a fost găzduit de: $confederation.';
  }

  @override
  String get hostBidRecentHost =>
      'Ați găzduit una dintre ultimele trei ediții.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Cerință: stadioane de $minSeats+ locuri: $grounds, dintre care de $bigSeats+: $bigGrounds.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Vom găzdui turneul și ne calificăm automat ca gazdă. O finanțare unică de $amount este deja în fondurile federației, gata pentru bugetul acestui ciclu.';
  }

  @override
  String get hubStadiumIncome => 'Venituri din stadioane';

  @override
  String get stadiumsDownsize => 'Reduceți';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Reduceți $stadium la $seats locuri (nivelul $level)? Nu se rambursează nimic, dar întreținerea scade.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Reamenajat în acest ciclu';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Aduce $amount pe ciclu';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Candidatură retrasă: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Candidatura a fost depusă pentru echipa $nation, dar începeți noul ciclu în altă parte. A fost retrasă și nu s-a perceput nimic.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'La închiderea ciclului, fondurile federației nu mai acopereau miza. Candidatura a fost retrasă și nu s-a perceput nimic.';

  @override
  String get stadiumsViewMap => 'Hartă';

  @override
  String get stadiumsViewList => 'Listă';

  @override
  String get stadiumsMapPickCity =>
      'Atingeți un oraș pentru a construi acolo un stadion nou.';

  @override
  String get stadiumsMapFit => 'Arată toată țara';

  @override
  String get campaignLegacyTitle => 'Desăvârșește moștenirea';

  @override
  String get campaignLegacyTwist =>
      'Spania, campioana europeană en titre, pentru un ciclu';

  @override
  String get campaignLegacyGoal => 'Apără titlul european';

  @override
  String get campaignLegacyIntro =>
      'Spania este campioana europeană en titre, iar scepticii spun că perioada de aur a fost o întâmplare. Ai un ciclu ca să dovedești contrariul: apără coroana continentului, apoi pornește după lume. Adaugă și Cupa Națiunilor, iar moștenirea va fi desăvârșită.';

  @override
  String get campaignStars1Legacy => 'Câștigarea Campionatului European';

  @override
  String get campaignStars2Legacy => 'Și a Campionatului Mondial';

  @override
  String get campaignStars3Legacy => 'Și a Cupei Națiunilor';

  @override
  String get campaignSectionOneCycle => 'Un ciclu';

  @override
  String get campaignSectionShort => 'Câteva cicluri';

  @override
  String get campaignSectionLong => 'Pe termen lung';

  @override
  String get campaignFilterAll => 'Toate';

  @override
  String get campaignFilterNew => 'Nejucate';

  @override
  String get campaignFilterInProgress => 'În desfășurare';

  @override
  String get campaignFilterDone => 'Încheiate';

  @override
  String get campaignFilterEmpty => 'Încă nu există campanii aici.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de stele',
      few: '$count stele',
      one: '1 stea',
      zero: 'Nicio stea',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles de cicluri',
      few: '$cycles cicluri',
      one: '1 ciclu',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Pleacă în vârf, ca un campion.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Ratarea turneului final a fost picătura care a umplut paharul.';

  @override
  String get msgIntlRetireNoteSurprise => ' Nimeni nu se aștepta.';

  @override
  String get msgIntlRetireNoteRecord =>
      ' Pleacă drept recordman al echipei naționale.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name se retrage de la națională';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) și-a anunțat retragerea de la echipa națională la $age ani.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name revine la națională';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name este din nou disponibil pentru convocare, la $age ani.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Cu lotul decimat de accidentări, a răspuns la apel.';

  @override
  String get msgIntlComebackNoteManager => ' Noul selecționer l-a convins.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name revine la națională';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) este din nou disponibil pentru convocare, la $age ani.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Retras de la națională, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Revenit la națională, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Mulțumim, $name. Unii poartă tricoul, el a dus echipa în spate.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name pune punct carierei la națională. Sfârșitul unei ere.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name se retrage. Sincer, cu un turneu prea târziu.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Deci $name a terminat. E timpul să le dăm o șansă tinerilor.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitudine $altitudeString m: adversarul va obosi mai repede';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitudine $altitudeString m: jucătorii dvs. vor obosi mai repede';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitudine $altitudeString m: ambele echipe vor obosi mai repede';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitudine $altitudeString m: ambele echipe sunt obișnuite';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Caniculă: se așteaptă $tempString°C, picioarele vor ceda mai devreme';
  }

  @override
  String get matchConditionsAdvice =>
      'Plănuiți schimbările din timp: aici picioarele odihnite contează mai mult';

  @override
  String get fanMoodFurious => 'furioși';

  @override
  String get fanMoodRestless => 'neliniștiți';

  @override
  String get fanMoodCalm => 'liniștiți';

  @override
  String get fanMoodUpbeat => 'optimiști';

  @override
  String get fanMoodEuphoric => 'euforici';

  @override
  String matchHomeFans(String mood) {
    return 'Suporterii de acasă: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Suporterii: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Venituri din stadioane în ciclul următor: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Douăzeci de ani după națională, acasă și în deplasare. Nu-mi reînnoiesc abonamentul până nu se schimbă ceva.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Vom cânta în continuare pentru tricou. Dar banerul din peluza nord a spus în seara asta ce gândim toți.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Jumătate de stadion gol, iar cealaltă jumătate a scandat toată repriza a doua #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Grupările de suporteri vorbesc despre boicotarea următorului meci de acasă. Greu să le reproșezi.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Nici măcar nu mai sunt furios. Pur și simplu gata.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Poză din seara asta: rânduri de scaune goale și un cearșaf pe care scrie #${manager}Out. Asta e cronica meciului.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Din nou casa închisă. Cea mai bună națională din ultimii ani, și toată țara știe asta.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Biletele la următorul meci de acasă s-au epuizat în unsprezece minute. Echipa asta ne-a dat înapoi weekendurile.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Niciun loc liber la următorul meci de acasă. Federația va număra încasările zâmbind.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Încă o casă închisă. Spuneți ce vreți despre tactică, oamenii vor să fie pe stadionul acela.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Casa închisă, bine. Aceiași oameni fluierau echipa asta acum un an și jumătate.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Brusc casa închisă, brusc toți experți. Unde erați când nu puteam bate pe nimeni?';
  }

  @override
  String get campaignsIntro =>
      'Campaniile sunt provocări create special: o națională stabilită, o lume cu propria ei întorsătură și un obiectiv de atins într-un număr fix de cicluri. Fiecare încercare rămâne separată de carierele salvate, iar cu cât ajungi mai departe, cu atât câștigi mai multe stele, până la trei.';

  @override
  String hubEventScandal(String player) {
    return 'Scandal în cantonament: $player';
  }

  @override
  String get hubEventScandalSub => 'Îl trimiteți acasă sau îl păstrați?';

  @override
  String get scandalTitle => 'SCANDAL';

  @override
  String scandalStoryParty(String player) {
    return '$player a fost la o petrecere care a ținut până în zori, iar fotografiile au apărut în toate ziarele în dimineața în care s-a strâns lotul.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player a încălcat ora de stingere și a fost prins întorcându-se la hotel spre dimineață.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player a fost fotografiat într-un club de noapte în ajunul cantonamentului, iar pozele sunt peste tot.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player și-a petrecut noaptea dinaintea cantonamentului la o masă de cazino, iar un tabloid are fotografiile.';
  }

  @override
  String get scandalSendHome => 'Trimiteți-l acasă';

  @override
  String scandalSendHomeCover(String player) {
    return 'Acasă, convocați: $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Păstrați: $player';
  }

  @override
  String get scandalKeepNote =>
      'Dacă rămâne: moral aproximativ -4 și federație aproximativ -3 până la finalul ciclului.';

  @override
  String get scandalSendHomeNote =>
      'Dacă îl trimiteți acasă: niciun cost pentru moral sau federație, și puteți convoca un înlocuitor.';

  @override
  String get scandalFinalsNote =>
      'Dacă îl trimiteți acasă: niciun cost pentru moral sau federație, dar la un turneu final nimeni nu îl poate înlocui.';

  @override
  String get scandalPickCover => 'Convocați un înlocuitor (opțional)';

  @override
  String newsScandalTitle(String player) {
    return 'Scandal în cantonament: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Sunt tineri. $player la petrecere în seara dinaintea cantonamentului, și tot îl vreau pe teren. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player, fotografiat la o petrecere până dimineața, cu câteva ore înainte de reunirea lotului. Federația a fost anunțată. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Petrecere până dimineața înainte de cantonament. $player, la ce te gândeai? Incredibil. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'S-a întors după ora de stingere, bine, se întâmplă. $player trebuie doar să repare totul pe teren. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player, prins întorcându-se la hotelul echipei după ora de stingere, cu câteva ore înainte de antrenament. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Ora de stingere nu e complicată. $player n-a rezistat nici măcar o noapte. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Și ce dacă $player a fost în club? Și fotbaliștii au o viață. Lăsați-l să joace. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Fotografii cu $player într-un club de noapte, în ajunul cantonamentului naționalei. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Poze din club în ajunul cantonamentului. $player a făcut de rușine tricoul. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'O noapte la cazino nu e o crimă. $player o să fie bine. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player, văzut la o masă de cazino în noaptea dinaintea reunirii lotului. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Toată noaptea la cazino înainte de cantonament. $player a pariat mai mult decât bani. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Decizie corectă. Nimeni nu e mai presus de echipă, nici măcar $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Trimiterea acasă era singurul răspuns. $player și-a făcut-o singur. Respect pentru selecționer.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Disciplina e disciplină. $player cunoștea regulile.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Un mesaj clar pentru vestiar: $player e în avionul spre casă.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Dur. $player iese o seară și cantonamentul s-a terminat pentru el?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Trimiterea acasă ne slăbește. $player pleacă, iar noi plătim pe teren.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Păstrarea lui e un pariu. $player ar face bine să-l plătească pe teren.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Bine, $player rămâne. Atunci le datorează tuturor un meci mare.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Deci regulile nu se aplică tuturor. $player e excepția. Bine de știut.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Ora de stingere e opțională acum, se pare. Întrebați: $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Rămâne după așa ceva? $player și ceilalți sunt în tabără de vacanță.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Petrecere toată noaptea, apoi direct titular. Frumos mesaj, mister. $player e sigur încântat.';
  }

  @override
  String get yStreamerBreaks0 =>
      'FRATELE A FOST PRINS 😭😭 ÎN NOAPTEA DINAINTEA CANTONAMENTULUI?? PLÂNG 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'NUUU CHAT UITAȚI-VĂ LA ASTA 🤯🤯 FRATELE CHIAR A FĂCUT-O ÎNAINTE DE CANTONAMENT 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'CINE L-A LĂSAT AFARĂ?? CINE L-A LĂSAT 😭😭💀 ĂSTA E CINEMA 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'ACASĂ?? ACASĂ!!! 😭😭😭 MISTER NU GLUMEȘTE 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'FRATELE ÎȘI FACE BAGAJELE ÎN DIRECT 🤯🤯 PA FRATE 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'NU SE POATEEE L-AU TRIMIS ACASĂ 💀💀 CHAT TREMUR 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'RĂMÂNE??? RĂMÂNEEE 🤯🤯 FRATELE E DE NEATINS 😭🔥';

  @override
  String get yStreamerKept1 =>
      'PETRECERE TOATĂ NOAPTEA ȘI ÎNCĂ ÎN LOT 💀💀 VREAU ȘI EU CONTRACTUL ĂLA 😭😭';

  @override
  String get yStreamerKept2 => 'MISTER ZICE CĂ E OK 😭😭 FRATE CE 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'N-am plătit nimic, și nici suma aia nu se potrivește';

  @override
  String get yCameoHavir0 => 'Peștișorii au înotat departe.';

  @override
  String get yCameoHavir1 => 'Am aruncat plasele, peștii erau în altă parte.';

  @override
  String get yCameoHavir2 => 'Am zis-o încă din septembrie, la un gulaș.';

  @override
  String get yCameoHavir3 => 'Cine n-a pescuit la timp să nu plângă acum.';

  @override
  String get yCameoHavir4 => 'Am jucat ca un somn pe uscat.';

  @override
  String get yCameoHavir5 => 'Bate vântul, îngheață iazul. Așa merg lucrurile.';

  @override
  String get yCameoHavir6 => 'Sunt zile când scoți doar o cizmă veche.';

  @override
  String get yCameoHavir7 =>
      'Pe vremea mea măcar mergeam la o bere. Acum nici atât.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Să trimiți un puști acasă pentru o seară? Ăsta e scandalul, nu petrecerea!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Băieții au și ei dreptul să se distreze! Presa ipocrită a câștigat din nou.';

  @override
  String get yCameoLzimberskyHome2 =>
      'E o vânătoare de vrăjitoare. Un tânăr iese o seară și voi îl spânzurați.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Ziaristul care n-a fost niciodată la o petrecere să arunce primul piatra. Rușine!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Selecționerul s-a speriat de tabloide. Eu l-aș fi apărat pe puști până la ultima suflare!';

  @override
  String get yCameoLzimberskyKept0 =>
      'În sfârșit un selecționer cu coloană vertebrală! L-a păstrat pe puști, iar presa să plângă.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Băieții au și ei dreptul să se distreze, nu? Bravo, mister!';

  @override
  String get yCameoLzimberskyKept2 =>
      'Presa ipocrită urlă, selecționerul ține linia. Așa se face!';

  @override
  String get yCameoLzimberskyKept3 =>
      'O seară în oraș și presa vrea să-l lapideze. Selecționerul e un bărbat adevărat!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Eu zic: lăsați băieții să trăiască! Cine muncește din greu are dreptul să se și distreze. Like.';

  @override
  String get yTraitStreamer =>
      'Transmite totul în direct, la volum maxim, cu majuscule.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Jucătorul anului $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Voturile au fost numărate';

  @override
  String get potyCeremonyWatch => 'Urmăriți ceremonia';

  @override
  String get potyCeremonySkipToList => 'Direct la top 5';

  @override
  String get potyCeremonySkip => 'Săriți';

  @override
  String get potyCeremonyIntro =>
      'Voturile au fost numărate. Aceștia sunt cei mai buni cinci jucători ai lumii în acest an.';

  @override
  String potyCeremonyPlace(int place) {
    return 'Locul $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'Iar Jucătorul anului este...';

  @override
  String get potyTop5Heading => 'Top 5 mondial';

  @override
  String get potyYoungTop3Heading => 'Tânărul jucător al anului: top 3';

  @override
  String get potySeeTop5 => 'Vedeți top 5';

  @override
  String get potyYourPlayer => 'Jucătorul dvs.';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de meciuri fără gol primit',
      few: '$count meciuri fără gol primit',
      one: '1 meci fără gol primit',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Briefing complet';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Stele câștigate până acum: $earned din $total';
  }

  @override
  String get campaignStarEarned => 'Câștigată până acum';

  @override
  String get campaignStarNotYet => 'Încă necâștigată';

  @override
  String get stadiumsEntrySubClosed =>
      'Vezi-ți stadioanele. Lucrările se redeschid la începutul ciclului următor.';

  @override
  String get boardObjectiveNoBrief => 'Niciun obiectiv stabilit';

  @override
  String get boardObjectiveNoBriefBody =>
      'Federația nu se așteaptă să ajungi la acest turneu final. Te va judeca după rezultate.';

  @override
  String get boardObjectiveAwaitingDraw => 'Obiectiv după tragerea la sorți';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Federația stabilește acest obiectiv după tragerea la sorți a grupelor.';
}
