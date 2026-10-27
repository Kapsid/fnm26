// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get matchPreviewTitle => 'PRE-PARTITA';

  @override
  String get matchKickOff => 'Calcio d\'inizio';

  @override
  String get matchTactics => 'Tattica';

  @override
  String get matchYourXi => 'I TUOI 11';

  @override
  String get matchHeadToHead => 'PRECEDENTI';

  @override
  String matchCouldNotLoad(String error) {
    return 'Impossibile caricare la partita.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Nessuna partita in programma.';

  @override
  String get matchUnknownNation => 'Sconosciuta';

  @override
  String get matchH2hFirstMeeting => 'Primo confronto di sempre';

  @override
  String get matchH2hYouLead => 'Sei avanti nei precedenti';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent: avanti nei precedenti';
  }

  @override
  String get matchH2hEven => 'Bilancio in parità';

  @override
  String matchH2hMet(int count) {
    return '$count sfide';
  }

  @override
  String get matchH2hWon => 'Vinte';

  @override
  String get matchH2hDrawn => 'Pari';

  @override
  String get matchH2hLost => 'Perse';

  @override
  String get matchDossierTitle => 'Rapporto osservatori';

  @override
  String get matchDossierForm => 'FORMA';

  @override
  String get matchDossierNoGames => 'Nessuna partita recente';

  @override
  String get matchDossierKeyMen => 'UOMINI CHIAVE';

  @override
  String get matchDossierHowTheyPlay => 'COME GIOCANO';

  @override
  String matchScoutFormation1(String formation) {
    return 'Di solito si schierano con il $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Il loro modulo abituale è il $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Tendono a disporsi con il $formation.';
  }

  @override
  String get matchScoutStrengthPressing =>
      'Pressano alto e vanno a caccia del pallone.';

  @override
  String get matchScoutStrengthDirect =>
      'Giocano in modo diretto e portano presto palla in avanti.';

  @override
  String get matchScoutStrengthPossession =>
      'Tengono bene palla e costruiscono con pazienza.';

  @override
  String get matchScoutStrengthCounter =>
      'Aspettano bassi e ripartono veloci in contropiede.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Difendono bassi e sono difficili da scardinare.';

  @override
  String get matchScoutStrengthWide =>
      'Allargano il campo e attaccano sulle fasce.';

  @override
  String get matchScoutStrengthAttacking =>
      'Amano fare la partita e aggredire l\'avversario.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'I loro attaccanti sono veloci e amano attaccare la profondità.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Il loro centrocampo fa girare bene la palla.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Il loro centrocampo ha gambe per correre tutta la partita.';

  @override
  String get matchScoutStrengthSetPieces =>
      'Sono pericolosi sulle palle inattive.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'La loro difesa è veloce e difficile da attaccare alle spalle.';

  @override
  String get matchScoutStrengthNone =>
      'Nel loro gioco non spicca nulla di particolare.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'La loro linea alta lascia spazio alle spalle per un lancio lungo.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Un pressing alto può mettere in difficoltà la loro lenta costruzione.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Serve pazienza: un blocco basso come il loro si può scardinare.';

  @override
  String get matchScoutWeakLongBall =>
      'Abbassa la linea e i loro lanci lunghi non troveranno spazio.';

  @override
  String get matchScoutWeakSlowDefence =>
      'I loro difensori sono lenti: attacca la profondità alle loro spalle.';

  @override
  String get matchScoutWeakAerial =>
      'Sembrano insicuri quando difendono sulle palle inattive.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Il loro centrocampo fatica a uscire dalla pressione palla a terra.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Al loro centrocampo mancano le gambe per sostenere un pressing.';

  @override
  String get matchScoutWeakBluntAttack => 'I loro attaccanti non sono veloci.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Contro di te, aspettati che prendano l\'iniziativa.';

  @override
  String get matchScoutApproachEven =>
      'Contro di te, aspettati una partita tirata ed equilibrata.';

  @override
  String get matchScoutApproachSitDeep =>
      'Contro di te, aspettati che stiano accorti e cerchino la ripartenza.';

  @override
  String get matchScoutLeaningAttacking =>
      'Da lontano sembrano una squadra offensiva.';

  @override
  String get matchScoutLeaningCautious =>
      'Da lontano sembrano una squadra prudente.';

  @override
  String get matchScoutLeaningUnclear =>
      'Da lontano è difficile capire come amino giocare.';

  @override
  String get matchScoutHireHint =>
      'Ingaggia un capo osservatore per scoprire come giocano.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Impossibile continuare: $error';
  }

  @override
  String get matchSkipToFullTime => 'Vai al fischio finale';

  @override
  String get matchStatShots => 'Tiri';

  @override
  String get matchStatGoals => 'Gol';

  @override
  String get matchStatYellowCards => 'Gialli';

  @override
  String get matchStatRedCards => 'Rossi';

  @override
  String get matchMomentum => 'INERZIA';

  @override
  String get matchSwingAtk => 'ATT';

  @override
  String get matchSwingDef => 'DIF';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'CAMPIONATO DEL MONDO $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'LA FASE FINALE È QUI';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'PAESE OSPITANTE  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'PAESE OSPITANTE DA DEFINIRE';

  @override
  String get matchHalfTime => 'INTERVALLO';

  @override
  String get matchContinue => 'Continua';

  @override
  String get matchContinuing => 'Si riprende…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Tattica · $used/$max cambi';
  }

  @override
  String matchTiredCount(int count) {
    return 'STANCHI ×$count';
  }

  @override
  String get matchTacticsLabel => 'TATTICA';

  @override
  String get teamOverallOverTime => 'VALORE NEL TEMPO';

  @override
  String get teamOverall => 'Valore';

  @override
  String get teamTalkHeading => 'DISCORSO ALLA SQUADRA';

  @override
  String get teamTalkPrompt => 'Dai il tono al secondo tempo.';

  @override
  String get teamTalkCalmLabel => 'Calma e testa';

  @override
  String get teamTalkCalmBlurb =>
      'Dai sicurezza alla squadra. Una piccola spinta in tutto.';

  @override
  String get teamTalkEncourageLabel => 'Incoraggia';

  @override
  String get teamTalkEncourageBlurb =>
      'Spingete e andate a prendervi la partita.';

  @override
  String get teamTalkDemandMoreLabel => 'Pretendi di più';

  @override
  String get teamTalkDemandMoreBlurb =>
      'Tutti all\'attacco. Attaccate con forza.';

  @override
  String get teamTalkPraiseLabel => 'Restate compatti';

  @override
  String get teamTalkPraiseBlurb =>
      'Squadra corta, difendete quello che avete.';

  @override
  String get teamTalkBelieveLabel => 'Crederci';

  @override
  String get teamTalkBelieveBlurb =>
      'Abbiate fiducia in voi. Una spinta in entrambe le metà campo.';

  @override
  String get teamTalkFocusLabel => 'Testa sulla partita';

  @override
  String get teamTalkFocusBlurb =>
      'Concentrazione totale. Chiudete la partita.';

  @override
  String get teamTalkUrgencyLabel => 'Senso d\'urgenza';

  @override
  String get teamTalkUrgencyBlurb =>
      'Andate a prenderla adesso. Tutto per tutto, ma si lasciano spazi.';

  @override
  String get teamTalkReassureLabel => 'Nessuna pressione';

  @override
  String get teamTalkReassureBlurb =>
      'Calmate i nervi e mantenete la disposizione.';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonSomethingWentWrong => 'Qualcosa è andato storto';

  @override
  String get commonCrashBox =>
      'Qualcosa è andato storto.\nImpostazioni → Diagnostica ha i dettagli.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Impossibile far avanzare il mondo: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostica';

  @override
  String get settingsDiagnosticsBlurb =>
      'Errori registrati su questo dispositivo. Non viene inviato nulla.';

  @override
  String get settingsContactTitle => 'Contatti';

  @override
  String get settingsContactCopied => 'Indirizzo copiato.';

  @override
  String get settingsCommunityTitle => 'Community';

  @override
  String get settingsDiscordSubtitle => 'Unisciti alla community';

  @override
  String get settingsLinkCopied => 'Link copiato.';

  @override
  String get diagnosticsEmpty =>
      'Nessun errore registrato. Ed è così che deve essere.';

  @override
  String get diagnosticsCopy => 'Copia';

  @override
  String get diagnosticsCopied => 'Log copiato negli appunti.';

  @override
  String get diagnosticsClear => 'Cancella';

  @override
  String get navHub => 'Home';

  @override
  String get navSquad => 'Rosa';

  @override
  String get navStandings => 'Classifiche';

  @override
  String get navCareers => 'Carriera';

  @override
  String get settingsTitle => 'IMPOSTAZIONI';

  @override
  String get settingsSoundHapticsTitle => 'Suoni e vibrazione';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibrazione e un breve suono su gol, calcio d\'inizio e fischio finale.';

  @override
  String get settingsLanguageTitle => 'Lingua';

  @override
  String get settingsLanguageBlurb =>
      'Scegli la lingua dell\'app o usa quella del dispositivo.';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsTextSizeTitle => 'Dimensione testo';

  @override
  String get settingsTextSizeBlurb =>
      'Ingrandisci il testo se è difficile da leggere.';

  @override
  String get settingsTextSizeNormal => 'Normale';

  @override
  String get settingsTextSizeLarge => 'Grande';

  @override
  String get settingsTextSizeLarger => 'Più grande';

  @override
  String get matchPreviewAllMeetings => 'Tutti i precedenti';

  @override
  String get recordsMeetings => 'PRECEDENTI';

  @override
  String get recordsLegends => 'LEGGENDE';

  @override
  String get recordsAllTimeXi => 'TOP 11 DI SEMPRE';

  @override
  String get recordsHallOfFame => 'HALL OF FAME';

  @override
  String get recordsAllTimeWorld => 'MONDO, DI SEMPRE';

  @override
  String get recordsAllTimeTopScorers => 'MIGLIORI MARCATORI DI SEMPRE';

  @override
  String get recordsMostCapped => 'PIÙ PRESENZE';

  @override
  String get recordsMostWcStarts => 'PIÙ PRESENZE NELLE FASI FINALI';

  @override
  String get recordsMostTournaments => 'PIÙ TORNEI DISPUTATI';

  @override
  String get recordsRecordBook => 'ALBO DEI RECORD';

  @override
  String get recordsHeadToHead => 'PRECEDENTI';

  @override
  String get recordsFiercestRival => 'RIVALE PIÙ OSTICO';

  @override
  String get recordsMostCaps => 'PIÙ PRESENZE';

  @override
  String get recordsTopScorers => 'MARCATORI';

  @override
  String get recordsMostAssists => 'PIÙ ASSIST';

  @override
  String get recordsYourRecord => 'IL TUO BILANCIO';

  @override
  String get callUpHome => 'CASA';

  @override
  String get callUpAway => 'TRASFERTA';

  @override
  String get recordsHome => 'CASA';

  @override
  String get recordsAway => 'TRASFERTA';

  @override
  String get recordsActive => 'IN ATTIVITÀ';

  @override
  String get recordsStillActive => 'Ancora in attività';

  @override
  String get recordsAvg => 'media';

  @override
  String get recordsSelect => 'Scegli';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Pareggi';

  @override
  String get recordsGoalsLabel => 'Gol';

  @override
  String get recordsBestFinish => 'Miglior risultato';

  @override
  String get recordsNoFinalsYet => 'Nessuna fase finale disputata';

  @override
  String get recordsLongestUnbeaten => 'Striscia d\'imbattibilità';

  @override
  String get recordsBiggestWin => 'Vittoria più larga';

  @override
  String get recordsSeeAllMeetings => 'Vedi tutti i precedenti';

  @override
  String get recordsSaveNotFound => 'Salvataggio non trovato.';

  @override
  String get recordsNoMatches => 'Nessuna partita.';

  @override
  String get recordsSearchPlayerOrNation => 'Cerca giocatore o nazionale';

  @override
  String get recordsSearchNation => 'Cerca nazionale';

  @override
  String get recordsPickTwoDifferent => 'Scegli due nazionali diverse.';

  @override
  String get recordsPlayToBuildRecord =>
      'Gioca qualche partita e qui si costruirà il tuo bilancio contro ogni avversario.';

  @override
  String get recordsTapOpponent =>
      'Tocca un avversario per il dettaglio completo.';

  @override
  String get recordsEdgeUpperHand => 'Sei in vantaggio';

  @override
  String get recordsEdgeTheirNumber => 'Sono la tua bestia nera';

  @override
  String get recordsEdgeEven => 'Bilancio in parità';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Marcatori e presenze di sempre, tutte le nazionali';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Confronta i precedenti di due nazionali qualsiasi';

  @override
  String get recordsLegendsSubtitle => 'Top 11 di sempre e Hall of Fame';

  @override
  String get recordsUnitGoals => 'gol';

  @override
  String get recordsUnitCaps => 'presenze';

  @override
  String get recordsUnitStarts => 'da titolare';

  @override
  String get recordsUnitCups => 'tornei';

  @override
  String get recordsUnitAssists => 'assist';

  @override
  String recordsCapsCount(int count) {
    return '$count presenze';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count gol';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count assist';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MVP';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count partite';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count precedenti';
  }

  @override
  String recordsCodeWins(String code) {
    return 'vittorie $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings precedenti · ${wins}V ${draws}N ${losses}P';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}V ${draws}N ${losses}P';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings precedenti · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a e $b non si sono mai affrontate in questo salvataggio.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Espulsi: $names. Nessun sostituto, giochi in inferiorità numerica.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Ne servono $required disponibili ($have in forma)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Salta $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Fuori per tutto il raduno';

  @override
  String get rankingCentreOnMe => 'Centra sulla mia nazionale';

  @override
  String get recordsAfterExtraTime => 'd.t.s.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b ai rigori';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played giocate · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga vs $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Impossibile caricare.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Impossibile caricare le leggende.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Impossibile caricare i record.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Impossibile caricare le nazionali.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Impossibile caricare il tuo bilancio.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Impossibile caricare il bilancio.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Ancora nessuna leggenda. Gioca qualche campagna e qui emergeranno i grandi di $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'La squadra più forte che $nation potrebbe mai schierare.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Il mondo non ha ancora una storia. Gioca qualche campagna e qui appariranno i più grandi di sempre.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Gioca qualche partita per iniziare a scrivere la storia di $nation.';
  }

  @override
  String get tacticsLineGk => 'POR';

  @override
  String get tacticsLineDef => 'DIF';

  @override
  String get tacticsLineMid => 'CEN';

  @override
  String get tacticsLineFwd => 'ATT';

  @override
  String get tacticsGoalkeepers => 'PORTIERI';

  @override
  String get tacticsDefenders => 'DIFENSORI';

  @override
  String get tacticsMidfielders => 'CENTROCAMPISTI';

  @override
  String get tacticsForwards => 'ATTACCANTI';

  @override
  String get tacticsCallUpsTitle => 'CONVOCAZIONI';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Scegli almeno $min giocatori.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Impossibile caricare la rosa.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Nessuna rosa.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'ROSA · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Max $max';
  }

  @override
  String get tacticsBestQuality => 'I migliori';

  @override
  String get tacticsPreviousSquad => 'Rosa precedente';

  @override
  String get tacticsSquadLockedBack => 'Indietro (rosa bloccata)';

  @override
  String get tacticsConfirmSquad => 'Conferma la rosa';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Rosa completa (max $max)';
  }

  @override
  String get tacticsSquadLocked => 'ROSA BLOCCATA';

  @override
  String get tacticsNominationOpen => 'CONVOCAZIONI APERTE. SCEGLI LA ROSA';

  @override
  String get tacticsSquadFixedBlurb =>
      'Questa rosa è fissata per le partite qui sotto. Riscegli prima della prossima finestra di convocazioni.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Questa rosa giocherà le partite qui sotto.';

  @override
  String get tacticsUnknown => 'Sconosciuto';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Età $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Sfinito';

  @override
  String get tacticsFatigueTired => 'Stanco';

  @override
  String get tacticsFatigueMatchLegs => 'Ritmo partita';

  @override
  String tacticsTooManySubs(int max) {
    return 'Troppe sostituzioni (max $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TATTICA · $minute\'';
  }

  @override
  String get tacticsApply => 'APPLICA';

  @override
  String get tacticsTabLineupSubs => 'FORMAZIONE E CAMBI';

  @override
  String get tacticsTabTactics => 'TATTICA';

  @override
  String get squadLineKeepers => 'PORTIERI';

  @override
  String get squadLineDefenders => 'DIFESA';

  @override
  String get squadLineMidfielders => 'CENTROCAMPO';

  @override
  String get squadLineForwards => 'ATTACCO';

  @override
  String get squadStatXiRating => 'Valore 11';

  @override
  String get squadStatAvgAge => 'Età media';

  @override
  String get squadStatSize => 'Rosa';

  @override
  String get squadStatUnavailable => 'Fuori';

  @override
  String get squadDepthTitle => 'PROFONDITÀ PER REPARTO';

  @override
  String squadAgeShort(int age) {
    return '$age a.';
  }

  @override
  String get tacticsTabOtherPositions => 'ALTRI RUOLI';

  @override
  String get tacticsOutOfPositionNote => 'Fuori ruolo qui';

  @override
  String get tacticsNobodyElse => 'Nessun altro da provare qui.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Scegli chi esce e qui apparirà il resto della panchina, con il rendimento che avrebbe in questo ruolo.';

  @override
  String get tacticsTabSuitable => 'ADATTI';

  @override
  String get tacticsTabOnPitch => 'IN CAMPO';

  @override
  String tacticsSectionSuitable(int count) {
    return 'ADATTI · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Nessuno in panchina è naturale in questo ruolo, quindi ecco tutti.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'IN CAMPO · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'DISPONIBILI · $count';
  }

  @override
  String get tacticsRowStarted => 'Titolare';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Entrato al $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Entrato';

  @override
  String get tacticsEnergyLabel => 'ENERGIA';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Tocca un sostituto per $name, o toccalo di nuovo per annullare.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Hai perso questo posto per un cartellino rosso. Trascina qui un compagno per spostare il buco.';

  @override
  String get tacticsSentOffShort => 'ESPULSO';

  @override
  String get tacticsFullBackLeft => 'Terzino sinistro';

  @override
  String get tacticsFullBackRight => 'Terzino destro';

  @override
  String get tacticsFullBackUp => 'Spingere';

  @override
  String get tacticsFullBackDown => 'Restare dietro';

  @override
  String get tacticsFullBackOff => 'Nessuna istruzione';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: spingere. Un po\' più di attacco, un po\' più di rischio.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: restare dietro. Un po\' più sicuro, un po\' meno attacco.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: nessuna istruzione, segue il piano di squadra.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, freccia: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'CAMBI · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Tocca un giocatore in campo per toglierlo, o tieni premuto e trascina un panchinaro su di lui.';

  @override
  String get tacticsNoSubs => 'Nessun sostituto disponibile.';

  @override
  String get tacticsChooseShape => 'SCEGLI UN MODULO';

  @override
  String get tacticsFormation => 'MODULO';

  @override
  String get tacticsInstructions => 'ISTRUZIONI';

  @override
  String get tacticsDrilling => 'ASSIMILAZIONE';

  @override
  String get tacticsDrillingUnplayed => 'MAI USATO';

  @override
  String get tacticsDrillingNew => 'NUOVO';

  @override
  String get tacticsDrillingSettling => 'IN RODAGGIO';

  @override
  String get tacticsDrillingDrilled => 'ASSIMILATO';

  @override
  String get tacticsInstrMentality => 'Mentalità';

  @override
  String get tacticsInstrDefensive => 'Difensiva';

  @override
  String get tacticsInstrAttacking => 'Offensiva';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Blocco basso';

  @override
  String get tacticsInstrHighPress => 'Pressing alto';

  @override
  String get tacticsInstrTempo => 'Ritmo';

  @override
  String get tacticsInstrPatient => 'Paziente';

  @override
  String get tacticsInstrFast => 'Veloce';

  @override
  String get tacticsInstrWidth => 'Ampiezza';

  @override
  String get tacticsInstrNarrow => 'Stretta';

  @override
  String get tacticsInstrWide => 'Larga';

  @override
  String get tacticsInstrDefLine => 'Linea dif.';

  @override
  String get tacticsInstrDefensiveLine => 'Linea difensiva';

  @override
  String get tacticsInstrDeep => 'Bassa';

  @override
  String get tacticsInstrHigh => 'Alta';

  @override
  String get tacticsInstrDirectness => 'Verticalità';

  @override
  String get tacticsInstrPossession => 'Possesso';

  @override
  String get tacticsInstrDirect => 'Diretto';

  @override
  String get tacticsPickGoalkeeper => 'SCEGLI IL PORTIERE';

  @override
  String get tacticsPickLeftBack => 'SCEGLI IL TERZINO SX';

  @override
  String get tacticsPickCentreBack => 'SCEGLI IL CENTRALE';

  @override
  String get tacticsPickRightBack => 'SCEGLI IL TERZINO DX';

  @override
  String get tacticsPickDefensiveMid => 'SCEGLI IL MEDIANO';

  @override
  String get tacticsPickCentralMid => 'SCEGLI IL CENTROCAMPISTA';

  @override
  String get tacticsPickAttackingMid => 'SCEGLI IL TREQUARTISTA';

  @override
  String get tacticsPickLeftMid => 'SCEGLI L\'ESTERNO SX';

  @override
  String get tacticsPickRightMid => 'SCEGLI L\'ESTERNO DX';

  @override
  String get tacticsPickLeftWing => 'SCEGLI L\'ALA SX';

  @override
  String get tacticsPickRightWing => 'SCEGLI L\'ALA DX';

  @override
  String get tacticsPickStriker => 'SCEGLI LA PUNTA';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · fuori ruolo';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Età $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Età $age';
  }

  @override
  String get tacticsOn => 'DENTRO';

  @override
  String get tacticsSquad => 'ROSA';

  @override
  String get tacticsTabLineup => 'FORMAZIONE';

  @override
  String get tacticsTabInstructions => 'ISTRUZIONI';

  @override
  String get tacticsTabRoles => 'COMPITI';

  @override
  String get tacticsTabSetPieces => 'PALLE INATTIVE';

  @override
  String get tacticsTabRolesSetPieces => 'COMPITI E PALLE INATTIVE';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Dai un compito a ogni titolare. Tocca il badge rigore (⚽) o punizione (▲) per scegliere il tiratore.';

  @override
  String get tacticsTooltipCallUps => 'Convocazioni';

  @override
  String get tacticsTooltipPresets => 'Tattiche salvate';

  @override
  String get tacticsTooltipInstructions => 'Istruzioni';

  @override
  String get tacticsNoTacticSet => 'Nessuna tattica impostata.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'SOSTITUISCI $count TITOLARI',
      one: 'SOSTITUISCI $count TITOLARE',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Fuori';

  @override
  String get tacticsTapSpotReplace =>
      'Tocca la sua posizione in campo per scegliere un sostituto.';

  @override
  String get tacticsTapOrDrag =>
      'Tocca un giocatore per sostituirlo, o tieni premuto e trascinalo per spostarlo.';

  @override
  String get tacticsPlayerRoles => 'COMPITI DEI GIOCATORI';

  @override
  String get tacticsRolesBlurb =>
      'Dai un compito a un giocatore: rapinatore d\'area, regista, punta di peso. Decide chi segna e chi crea.';

  @override
  String get tacticsSetPieceTakers => 'TIRATORI PALLE INATTIVE';

  @override
  String get tacticsSetPieceBlurb =>
      'Chi batte rigori e palle inattive, oppure lascia fare al più adatto.';

  @override
  String get tacticsTakerAuto => 'Automatico';

  @override
  String get tacticsTakerQuickPick => 'Usa i migliori tiratori';

  @override
  String get tacticsPenalties => 'Rigori';

  @override
  String get tacticsCornersFreeKicks => 'Angoli e punizioni';

  @override
  String get tacticsSkillFin => 'TIR';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'COMPITO · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'RIGORISTA';

  @override
  String get tacticsCornerFreeKickTaker => 'TIRATORE DI ANGOLI E PUNIZIONI';

  @override
  String get tacticsAutomatic => 'Automatico';

  @override
  String get tacticsLetBestSuited => 'Lascia battere al giocatore più adatto.';

  @override
  String get tacticsInXi => 'NEGLI 11';

  @override
  String get tacticsTeamInstructions => 'ISTRUZIONI DI SQUADRA';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Decidi come gioca la tua squadra. Ogni regolazione influisce su tutta la squadra.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Salvata “$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Applicata “$name”';
  }

  @override
  String get tacticsTacticPresets => 'TATTICHE SALVATE';

  @override
  String get tacticsPresetsBlurb =>
      'Salva questo assetto come stile riutilizzabile, o applicane uno salvato prima.';

  @override
  String get tacticsSaveCurrentTactic => 'Salva la tattica attuale';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Impossibile caricare le tattiche salvate.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Nessuna tattica salvata. Tocca “Salva la tattica attuale” per conservare questo assetto come stile riutilizzabile.';

  @override
  String get tacticsNameThisTactic => 'Dai un nome alla tattica';

  @override
  String get tacticsNameHint => 'es. Pressing alto 4-3-3';

  @override
  String get tacticsCancel => 'Annulla';

  @override
  String get tacticsSave => 'Salva';

  @override
  String get tacticsTapToAssign => 'Tocca per assegnare';

  @override
  String get tacticsHoldDragSub =>
      'Tieni premuto un panchinaro, poi trascinalo su un giocatore per farlo entrare.';

  @override
  String get hubContinue => 'Continua';

  @override
  String get hubBrackets => 'Tabelloni';

  @override
  String hubCouldNotLoad(String error) {
    return 'Impossibile caricare.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Impossibile caricare le finanze.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Impossibile caricare il salvataggio.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Salvataggio non trovato.';

  @override
  String get hubUnknown => 'Sconosciuto';

  @override
  String hubWorldChampionsYear(int year) {
    return 'CAMPIONI DEL MONDO $year';
  }

  @override
  String get hubCycleComplete => 'Il ciclo è concluso.';

  @override
  String get hubYourJob => 'IL TUO INCARICO';

  @override
  String get hubStayProject => 'Resta e porta avanti il tuo progetto';

  @override
  String get hubChooseNextJob => 'SCEGLI IL PROSSIMO INCARICO';

  @override
  String get hubOffersOnTable => 'OFFERTE SUL TAVOLO';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · n. $position al mondo';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Continua con $nation';
  }

  @override
  String get hubYourNation => 'la tua nazionale';

  @override
  String get hubTakeTheJob => 'Accetta l\'incarico';

  @override
  String get hubFederationFinances => 'FINANZE DELLA FEDERAZIONE';

  @override
  String get hubBudgetIntro =>
      'Il tuo primo compito nel prossimo ciclo è fissare il budget della federazione e dividerlo tra i reparti.';

  @override
  String get hubStarting => 'Avvio…';

  @override
  String get hubBeginNextCycle => 'Inizia il prossimo ciclo';

  @override
  String get hubContinueCareer => 'Continua la carriera';

  @override
  String get hubBackToSaves => 'Torna ai salvataggi';

  @override
  String get hubOpeningBalance => 'Saldo iniziale';

  @override
  String get hubCentralFunding => 'Fondi centrali';

  @override
  String get hubPrizeMoney => 'Premi';

  @override
  String get hubCommercialReturn => 'Ricavi commerciali';

  @override
  String get hubAvailableToInvest => 'Disponibile da investire';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputazione: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Eroe nazionale';

  @override
  String get hubFinal => 'Finale';

  @override
  String get hubStageRoundOf32 => 'Sedicesimi';

  @override
  String get hubStageThirdPlace => 'Finale per il terzo posto';

  @override
  String get hubEventAdvanceWorld => 'Fai avanzare il mondo';

  @override
  String hubEventStartCycle(int year) {
    return 'Inizia il ciclo $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation: campioni del mondo';
  }

  @override
  String get hubEventSetBudget => 'Fissa il budget della federazione';

  @override
  String get hubEventSetBudgetSub =>
      'Distribuisci il tesoretto del ciclo prima dell\'inizio della stagione';

  @override
  String get hubEventNaturalization => 'Valuta un\'offerta di naturalizzazione';

  @override
  String get hubEventNaturalizationSub =>
      'Un giocatore straniero vuole giocare per te';

  @override
  String get hubEventCampaignVerdict => 'Campagna decisa: scopri il verdetto';

  @override
  String get hubEventCampaignComplete => 'Campagna completata';

  @override
  String get hubEventIntercontinentalPlayoff =>
      'Lo spareggio intercontinentale';

  @override
  String get hubEventWatchWcDraw =>
      'Guarda il sorteggio del Campionato del mondo';

  @override
  String get hubEventWorldCupHere => 'È arrivato il Campionato del mondo';

  @override
  String get hubEventWatchFinalsDraw => 'Guarda il sorteggio della fase finale';

  @override
  String get hubEventFinalsHere => 'È arrivata la fase finale';

  @override
  String get hubEventPlayWcRound =>
      'Gioca il prossimo turno del Campionato del mondo';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Gioca la prossima partita: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Gioca la prossima partita di Coppa delle Nazioni';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Guarda il sorteggio della Coppa delle Nazioni';

  @override
  String get hubEventWatchHostSelection =>
      'Guarda la scelta del paese ospitante';

  @override
  String get hubEventWatchQualifyingDraw =>
      'Guarda il sorteggio delle qualificazioni';

  @override
  String get hubEventWatchWcHostSelection =>
      'Guarda la scelta del paese ospitante del Campionato del mondo';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Guarda il sorteggio delle qualificazioni al Campionato del mondo';

  @override
  String get hubEventArrangeFriendlies => 'Organizza amichevoli';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Non hai ancora riempito le tue $count finestre libere per le amichevoli',
      one: 'Non hai ancora riempito la tua finestra libera per le amichevoli',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Rimodella il tuo 11 titolare';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count dei tuoi 11 sono fuori (squalificati o infortunati). Scegli i sostituti',
      one:
          '1 dei tuoi 11 è fuori (squalificato o infortunato). Scegli il sostituto',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il tuo 11 titolare è incompleto. Copri i posti vuoti',
      one: 'Il tuo 11 titolare è incompleto. Copri il posto vuoto',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Gioca contro $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'la fase finale continentale';

  @override
  String get hubCallUpFriendlies => 'Convoca la rosa per le amichevoli';

  @override
  String get hubCallUpRequalify => 'Riconvoca la rosa per le qualificazioni';

  @override
  String get hubCallUpWorldCup => 'Convoca la rosa per il Campionato del mondo';

  @override
  String get hubCallUpFinals => 'Convoca la rosa per la fase finale';

  @override
  String get hubCallUpNationsCup =>
      'Convoca la rosa per la Coppa delle Nazioni';

  @override
  String get hubCallUpQualifying => 'Convoca la rosa per le qualificazioni';

  @override
  String get hubCallUpGeneric => 'Convoca la rosa';

  @override
  String get hubHost => 'Paese ospitante';

  @override
  String get hubGoldenBoot => 'Scarpa d\'oro';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals gol';
  }

  @override
  String get hubPens => '(rig.)';

  @override
  String get hubNationalHub => 'CENTRO NAZIONALE';

  @override
  String get hubMessages => 'Messaggi';

  @override
  String get hubWorldChampions => 'CAMPIONI DEL MONDO';

  @override
  String get hubViewBracket => 'Vedi tabellone ›';

  @override
  String get hubBoardDelighted => 'Entusiasta';

  @override
  String get hubBoardPleased => 'Soddisfatta';

  @override
  String get hubBoardExpectingMore => 'Si aspetta di più';

  @override
  String get hubBoardConcerned => 'Preoccupata';

  @override
  String get hubBoardJobAtRisk => 'Panchina a rischio';

  @override
  String get hubBoard => 'FEDERAZIONE';

  @override
  String hubBoardObjective(String label) {
    return 'Obiettivo della federazione: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'RAGGIUNTO · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'MANCATO · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Nessun\'altra partita in questo ciclo.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Ranking mondiale';

  @override
  String get hubSquadStatus => 'STATO DELLA ROSA';

  @override
  String hubPlayers(int count) {
    return '$count giocatori';
  }

  @override
  String get hubAvgRating => 'Valore medio';

  @override
  String get hubMorale => 'Morale';

  @override
  String get hubManageTeam => 'Gestisci squadra';

  @override
  String get hubGroupsToBeDrawn =>
      'Gironi da sorteggiare. Guarda il sorteggio per scoprirli.';

  @override
  String hubGroupName(String name) {
    return 'GIRONE $name';
  }

  @override
  String get hubTblTeam => 'SQUADRA';

  @override
  String get hubTblP => 'G';

  @override
  String get hubTblGd => 'DR';

  @override
  String get hubTblPts => 'PT';

  @override
  String get homeSettings => 'Impostazioni';

  @override
  String get homeLeadTheNation => 'GUIDA LA NAZIONALE';

  @override
  String get homeYourNation => 'la tua nazionale';

  @override
  String get homeNewGame => 'Nuova partita';

  @override
  String get homeAllSaves => 'Tutti i salvataggi';

  @override
  String get homeLoadGame => 'Carica partita';

  @override
  String get homeContinue => 'CONTINUA';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Verso il Campionato del mondo $year';
  }

  @override
  String get careerManageSaves => 'Gestisci salvataggi';

  @override
  String get careerNewGameTitle => 'NUOVA PARTITA';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Impossibile caricare la nazionale.\n$error';
  }

  @override
  String get careerNationNotFound => 'Nazionale non trovata.';

  @override
  String careerWorldRankNum(int rank) {
    return 'RANKING MONDIALE #$rank';
  }

  @override
  String get careerManagerName => 'Nome del CT';

  @override
  String get careerManagerNameHint => 'es. Enzo Bearzot';

  @override
  String get careerBeginsBlurb =>
      'La tua carriera inizia a settembre 2026, sulla strada verso il Campionato del mondo 2030.';

  @override
  String get careerFreeCycleNote =>
      'Gratis per un intero ciclo di quattro anni: qualificazioni, campionato continentale e Campionato del mondo, su due salvataggi. Dopo, un solo pagamento sblocca i cicli infiniti.';

  @override
  String get careerStartCareer => 'Inizia la carriera';

  @override
  String get careersTitle => 'CARRIERE';

  @override
  String get careerManagerCareer => 'Carriera da CT';

  @override
  String get careerManagerCareerSubtitle =>
      'Tutti i cicli che hai guidato e il tuo bilancio complessivo';

  @override
  String get careerSummaryTitle => 'Riepilogo carriera';

  @override
  String get careerSummarySubtitle => 'La tua bacheca e il tuo bilancio da CT';

  @override
  String get careerAchievements => 'Traguardi';

  @override
  String get careerAchievementsSubtitle =>
      'Tappe, titoli e soddisfazione della federazione';

  @override
  String get careerChallenges => 'Sfide';

  @override
  String get careerChallengesSubtitle =>
      'Prove durissime che durano tutta la carriera';

  @override
  String get careerTeamRecords => 'Record di squadra';

  @override
  String get careerTeamRecordsSubtitle =>
      'Migliori marcatori e presenze di sempre';

  @override
  String get careerMyMatches => 'Le mie partite';

  @override
  String get careerMyMatchesSubtitle =>
      'Tutti i risultati e le prossime partite';

  @override
  String get careerTitle => 'CARRIERA';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Impossibile caricare la carriera.\n$error';
  }

  @override
  String get careerNoCareer => 'Nessuna carriera.';

  @override
  String get careerTrophyCabinet => 'BACHECA';

  @override
  String get careerTournamentHistory => 'STORICO DEI TORNEI';

  @override
  String get careerNoTournamentsYet => 'Ancora nessun torneo completato.';

  @override
  String get careerTeamFallback => 'Squadra';

  @override
  String careerWorldNum(int rank) {
    return 'N. $rank AL MONDO';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PT';
  }

  @override
  String careerSeasonNum(int season) {
    return 'STAGIONE $season';
  }

  @override
  String get careerStatPlayedShort => 'G';

  @override
  String get careerStatsHeading => 'I NUMERI';

  @override
  String get careerStatsWinRate => '% vittorie';

  @override
  String get careerStatsGoalsFor => 'Gol fatti';

  @override
  String get careerStatsGoalsAgainst => 'Gol subiti';

  @override
  String get careerStatsGoalDiff => 'Diff. reti';

  @override
  String get careerStatsCleanSheets => 'Porta inviolata';

  @override
  String get careerStatsBiggestWin => 'Vittoria più larga';

  @override
  String get careerStatsWinStreak => 'Serie di vittorie';

  @override
  String get careerStatsUnbeaten => 'Serie utile';

  @override
  String get careerStatsShootouts => 'Rigori';

  @override
  String get careerStatsHatTricks => 'Triplette';

  @override
  String get careerStatsMotms => 'Migliore in campo';

  @override
  String get careerStatsBestRating => 'Miglior voto';

  @override
  String get careerStatWonShort => 'V';

  @override
  String get careerStatDrawnShort => 'N';

  @override
  String get careerStatLostShort => 'P';

  @override
  String get careerStatGoalsForShort => 'GF';

  @override
  String get careerStatGoalsAgainstShort => 'GS';

  @override
  String get careerStatGoalDiffShort => 'DR';

  @override
  String get careerNoSilverware => 'Ancora nessun trofeo. Vai a vincerne uno.';

  @override
  String get careerMedalGold => 'ORO';

  @override
  String get careerMedalSilver => 'ARGENTO';

  @override
  String get careerMedalBronze => 'BRONZO';

  @override
  String careerWinnersName(String name) {
    return 'Vincitore: $name';
  }

  @override
  String get careerSavesTitle => 'SALVATAGGI';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Impossibile caricare i salvataggi.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'SLOT  $used/$limit';
  }

  @override
  String get careerThisSave => 'questo salvataggio';

  @override
  String get careerSlotsFull => 'Slot pieni';

  @override
  String careerSlotsUsed(int used) {
    return 'SLOT  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Sblocca altri salvataggi';

  @override
  String get careerSlotsKeepNote =>
      'Tutti i salvataggi che hai restano giocabili. Solo uno nuovo richiede lo sblocco.';

  @override
  String get careerNewGame => 'Nuova partita';

  @override
  String get careerDeleteSaveTitle => 'Eliminare il salvataggio?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Questo elimina per sempre la tua carriera $label.';
  }

  @override
  String get careerCancel => 'Annulla';

  @override
  String get careerDelete => 'Elimina';

  @override
  String get careerNoSavesYet =>
      'Ancora nessun salvataggio.\nInizia una nuova partita per guidare una nazionale.';

  @override
  String get careerUnknownNation => 'Sconosciuta';

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
    return 'Ultima partita $when';
  }

  @override
  String get careerJustNow => 'adesso';

  @override
  String get careerYesterday => 'ieri';

  @override
  String careerMinutesAgo(int n) {
    return '$n min fa';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n h fa';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n g fa';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Verso il Campionato del mondo $year';
  }

  @override
  String get careerManagerCareerTitle => 'CARRIERA DA CT';

  @override
  String careerCouldNotLoad(String error) {
    return 'Impossibile caricare.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CICLO PER CICLO';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cicli',
      one: '1 ciclo',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations nazionali guidate',
      one: '1 nazionale guidata',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Titoli';

  @override
  String get careerStatPlayed => 'Giocate';

  @override
  String get careerStatWon => 'Vinte';

  @override
  String get careerStatDrawn => 'Pari';

  @override
  String get careerStatLost => 'Perse';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Gol $goalsFor–$goalsAgainst  ($gd)  ·  Vittorie $winRate%';
  }

  @override
  String get careerRecordResults => 'RISULTATI RECORD';

  @override
  String get careerBestWin => 'Vittoria migliore';

  @override
  String get careerWorstDefeat => 'Sconfitta peggiore';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'vs $opponent · $date';
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
    return '${won}V ${drawn}N ${lost}P  ·  GF $goalsFor GS $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Campionato del mondo';

  @override
  String get careerContinentalLabel => 'Continentale';

  @override
  String get messagesTitle => 'MESSAGGI';

  @override
  String get messagesNoMessagesYet => 'Ancora nessun messaggio.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Impossibile caricare i messaggi.\n$error';
  }

  @override
  String get messagesDone => 'Fatto';

  @override
  String get messagesNext => 'Avanti';

  @override
  String get rankingWorldRanking => 'RANKING MONDIALE';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Impossibile caricare il ranking.\n$error';
  }

  @override
  String get rankingNoRanking => 'Nessun ranking.';

  @override
  String get rankingAll => 'TUTTE';

  @override
  String get rankingYourTeam => 'LA TUA SQUADRA';

  @override
  String get rankingYourRankingOverTime => 'IL TUO RANKING NEL TEMPO';

  @override
  String rankingNowRank(int rank) {
    return 'ora #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'migliore #$best · peggiore #$worst';
  }

  @override
  String get friendliesTitle => 'AMICHEVOLI';

  @override
  String friendliesLoadError(String error) {
    return 'Impossibile caricare le amichevoli.\n$error';
  }

  @override
  String get friendliesContinue => 'Continua';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finestre libere',
      one: '1 finestra libera',
    );
    return 'Organizza test per $_temp0 prima della prossima partita ufficiale. Tocca un avversario o lascia libero.';
  }

  @override
  String get friendliesFree => 'Libero';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count GOL',
      one: '1 GOL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'GOL';

  @override
  String get matchGoalsNone => 'Nessun gol';

  @override
  String get matchGoalPenalty => 'RIG';

  @override
  String get matchGoalSetPiece => 'P.I.';

  @override
  String matchGoalAssist(String name) {
    return 'assist $name';
  }

  @override
  String get friendliesHome => 'CASA';

  @override
  String get friendliesAway => 'TRASFERTA';

  @override
  String get friendliesNoneThisWindow =>
      'Nessuna amichevole in questa finestra';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amichevoli',
      one: '1 amichevole',
    );
    return 'Conferma $_temp0';
  }

  @override
  String get friendliesMonthJan => 'Gen';

  @override
  String get friendliesMonthFeb => 'Feb';

  @override
  String get friendliesMonthMar => 'Mar';

  @override
  String get friendliesMonthApr => 'Apr';

  @override
  String get friendliesMonthMay => 'Mag';

  @override
  String get friendliesMonthJun => 'Giu';

  @override
  String get friendliesMonthJul => 'Lug';

  @override
  String get friendliesMonthAug => 'Ago';

  @override
  String get friendliesMonthSep => 'Set';

  @override
  String get friendliesMonthOct => 'Ott';

  @override
  String get friendliesMonthNov => 'Nov';

  @override
  String get friendliesMonthDec => 'Dic';

  @override
  String get resultsMyMatches => 'LE MIE PARTITE';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Impossibile caricare i risultati.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Nessuna partita.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'QUALIFICAZIONI';

  @override
  String get resultsStageFriendly => 'AMICHEVOLE';

  @override
  String get resultsStageGroupStage => 'FASE A GIRONI';

  @override
  String get resultsStageSemiFinal => 'SEMIFINALE';

  @override
  String get resultsStageFinal => 'FINALE';

  @override
  String get resultsStageContinentalClash => 'SFIDA CONTINENTALE';

  @override
  String get resultsStageFinalsGroup => 'GIRONE FINALE';

  @override
  String get resultsStageRoundOf32 => 'SEDICESIMI';

  @override
  String get resultsStageRoundOf16 => 'OTTAVI';

  @override
  String get resultsStageQuarterFinal => 'QUARTI DI FINALE';

  @override
  String get resultsStageThirdPlace => 'TERZO POSTO';

  @override
  String get matchSetupWarnCaptain =>
      'Nessun capitano scelto. Tocca per dare la fascia a qualcuno';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name è infortunato e non può guidare la squadra. Tocca per passare la fascia';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name è squalificato per questa partita. Tocca per passare la fascia';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name ha la fascia ma non è nella tua rosa. Tocca per passarla';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Nessun tiratore scelto per le palle inattive. Tocca per scegliere chi va sul pallone';

  @override
  String get matchSetupWarnBoth =>
      'Nessun capitano e nessun tiratore scelto. Tocca per impostarli';

  @override
  String matchStageMatchday(int matchday) {
    return 'G$matchday';
  }

  @override
  String get squadCaptain => 'Capitano';

  @override
  String deptEffectYouth(int points) {
    return 'I giovani del vivaio arrivano con circa $points di valore in più';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount di ritorno a fine ciclo';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% di infortuni in meno';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% di probabilità che uno straniero chieda di passare a te';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points di pazienza della federazione prima che la panchina sia a rischio';
  }

  @override
  String get deptEffectNone => 'Nessun effetto senza fondi';

  @override
  String get statsBestRated => 'Voti';

  @override
  String get statsMyCareer => 'Carriera';

  @override
  String get statsBestAverageRating => 'MIGLIOR MEDIA VOTO';

  @override
  String get statsMyCareerRecord => 'IL TUO BILANCIO';

  @override
  String get statsNoRatingsRecorded => 'Ancora nessun voto registrato.';

  @override
  String get statsGroupRecord => 'Bilancio';

  @override
  String get statsGroupRuns => 'Serie';

  @override
  String get statsGroupExtremes => 'Estremi';

  @override
  String get statsGroupSplits => 'Casa e trasferta';

  @override
  String get statsGroupSquad => 'I tuoi giocatori';

  @override
  String get statsPlayed => 'Partite giocate';

  @override
  String get statsWinDrawLoss => 'Vinte-pari-perse';

  @override
  String get statsWinRate => '% vittorie';

  @override
  String get statsGoals => 'Gol fatti:subiti';

  @override
  String get statsCleanSheets => 'Porta inviolata';

  @override
  String get statsFailedToScore => 'Senza segnare';

  @override
  String get statsLongestWinStreak => 'Serie di vittorie più lunga';

  @override
  String get statsLongestUnbeaten => 'Serie utile più lunga';

  @override
  String get statsLongestCleanSheets => 'Serie più lunga a porta inviolata';

  @override
  String get statsLongestWinless => 'Serie più lunga senza vittorie';

  @override
  String get statsCurrentRun => 'Serie utile attuale';

  @override
  String get statsBiggestWin => 'Vittoria più larga';

  @override
  String get statsHeaviestDefeat => 'Sconfitta più pesante';

  @override
  String get statsMostGoalsInAGame => 'Più gol in una partita';

  @override
  String get statsShootouts => 'Rigori vinti-persi';

  @override
  String get statsComebackWins => 'Vittorie in rimonta';

  @override
  String get statsHome => 'Casa';

  @override
  String get statsAway => 'Trasferta';

  @override
  String get statsNeutral => 'Campo neutro';

  @override
  String get statsCompetitive => 'Ufficiali';

  @override
  String get statsFriendlies => 'Amichevoli';

  @override
  String get statsHatTricks => 'Triplette';

  @override
  String get statsBraces => 'Doppiette';

  @override
  String get statsMotms => 'Premi di migliore in campo';

  @override
  String get statsAssists => 'Assist';

  @override
  String get statsCards => 'Cartellini';

  @override
  String get statsBestRating => 'Miglior voto individuale';

  @override
  String statsAppsShort(int apps) {
    return '$apps pres.';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MVP';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'Capitano. Tocca per togliere la fascia';

  @override
  String get captainFitBorn => 'Un leader nato';

  @override
  String get captainFitNatural => 'Un capitano naturale';

  @override
  String get captainFitCapable => 'Potrebbe indossarla';

  @override
  String get captainFitUnproven => 'Non ancora un leader';

  @override
  String get captainNone => 'Nessun capitano scelto';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale morale della rosa';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Qualificazioni al Campionato del mondo';

  @override
  String get resultsCategoryFriendlies => 'Amichevoli';

  @override
  String get resultsCategoryContinentalClash => 'Sfida continentale';

  @override
  String get resultsCategoryNationsCup => 'Coppa delle Nazioni';

  @override
  String get resultsCategoryContinentalCup => 'Coppa continentale';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Qual. Mondo';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Qual. Continentali';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Qualificazioni alla Coppa continentale';

  @override
  String get resultsCategoryWorldCupFinals =>
      'Fase finale del Campionato del mondo';

  @override
  String get resultsRoundResults => 'RISULTATI DEL TURNO';

  @override
  String get resultsFriendlyInternationals => 'AMICHEVOLI INTERNAZIONALI';

  @override
  String get resultsKnockout => 'Eliminazione diretta';

  @override
  String resultsEarlierMatches(int count) {
    return 'Partite precedenti ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'GIORNATA $matchday';
  }

  @override
  String get resultsContinue => 'Continua';

  @override
  String resultsGroup(String name) {
    return 'GIRONE $name';
  }

  @override
  String get achievementsScreenTitle => 'TRAGUARDI';

  @override
  String get achievementsChallengesTooltip => 'Sfide';

  @override
  String get achievementsChallengesHeading => 'SFIDE';

  @override
  String get achievementsBrutalTests => 'Prove durissime per tutta la carriera';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Impossibile caricare.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total sbloccati';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total superate';
  }

  @override
  String get achievementsBoardSatisfaction => 'SODDISFAZIONE DELLA FEDERAZIONE';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count TRAGUARDI SBLOCCATI',
      one: 'TRAGUARDO SBLOCCATO',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Vittorie';

  @override
  String get achCatMatches => 'Partite';

  @override
  String get achCatQualifications => 'Qualificazioni';

  @override
  String get achCatTitles => 'Titoli';

  @override
  String get achCatMisc => 'Varie';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Gol';

  @override
  String get achCatStreaks => 'Serie';

  @override
  String get achTierBronze => 'Bronzo';

  @override
  String get achTierSilver => 'Argento';

  @override
  String get achTierGold => 'Oro';

  @override
  String get achTierPlatinum => 'Platino';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol',
      one: '$count gol',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Segna $count gol.',
      one: 'Segna 1 gol.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count porte inviolate',
      one: '$count porta inviolata',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chiudi $count partite a porta inviolata.',
      one: 'Chiudi 1 partita a porta inviolata.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Vizio della vittoria';

  @override
  String get achStreakWin5Desc => 'Vinci cinque partite di fila.';

  @override
  String get achStreakWin10 => 'Lanciati';

  @override
  String get achStreakWin10Desc => 'Vinci dieci partite di fila.';

  @override
  String get achStreakWin20 => 'Schiacciasassi';

  @override
  String get achStreakWin20Desc => 'Vinci venti partite di fila.';

  @override
  String get achUnbeaten15 => 'Duri a morire';

  @override
  String get achUnbeaten15Desc => 'Resta imbattuto per quindici partite.';

  @override
  String get achUnbeaten30 => 'Intoccabili';

  @override
  String get achUnbeaten30Desc => 'Resta imbattuto per trenta partite.';

  @override
  String get achHattrick => 'Eroe della tripletta';

  @override
  String get achHattrickDesc => 'Fai segnare una tripletta a un giocatore.';

  @override
  String get achMotm10 => 'Protagonista';

  @override
  String get achMotm10Desc => 'Colleziona 10 premi di migliore in campo.';

  @override
  String get achMotm50 => 'Talismano';

  @override
  String get achMotm50Desc => 'Colleziona 50 premi di migliore in campo.';

  @override
  String get achPerfect => 'Dieci e lode';

  @override
  String get achPerfectDesc =>
      'Fai ottenere a un giocatore un voto di 9.5 o più.';

  @override
  String get achShootout => 'Sangue freddo';

  @override
  String get achShootoutDesc => 'Vinci cinque serie di rigori.';

  @override
  String get achMassacre => 'Massacro';

  @override
  String get achMassacreDesc => 'Vinci una partita con 7 o più gol di scarto.';

  @override
  String get achAnnihilation => 'Annientamento';

  @override
  String get achAnnihilationDesc =>
      'Vinci una partita con 10 o più gol di scarto.';

  @override
  String get chTierBronze => 'Bronzo';

  @override
  String get chTierSilver => 'Argento';

  @override
  String get chTierGold => 'Oro';

  @override
  String get chTierLegendary => 'Leggendaria';

  @override
  String get chFirstSteps => 'In panchina';

  @override
  String get chFirstStepsDesc => 'Allena per 5 anni.';

  @override
  String get chUnbeaten10 => 'Lanciati';

  @override
  String get chUnbeaten10Desc => 'Resta imbattuto per 10 partite ufficiali.';

  @override
  String get chTwoNations => 'Nuova sfida';

  @override
  String get chTwoNationsDesc => 'Guida 2 nazionali diverse.';

  @override
  String get chCont1 => 'Campione continentale';

  @override
  String get chCont1Desc => 'Vinci un campionato continentale.';

  @override
  String get chNc1 => 'Vincitore della Coppa delle Nazioni';

  @override
  String get chNc1Desc => 'Vinci la Coppa delle Nazioni.';

  @override
  String get chWc1 => 'Campione del mondo';

  @override
  String get chWc1Desc => 'Vinci il Campionato del mondo.';

  @override
  String get chYears25 => 'Istituzione';

  @override
  String get chYears25Desc => 'Allena per 25 anni.';

  @override
  String get chWc3 => 'Vincente seriale';

  @override
  String get chWc3Desc => 'Vinci 3 Campionati del mondo.';

  @override
  String get chWc5 => 'Dinastia';

  @override
  String get chWc5Desc => 'Vinci 5 Campionati del mondo.';

  @override
  String get chWc10 => 'Immortale';

  @override
  String get chWc10Desc => 'Vinci 10 Campionati del mondo.';

  @override
  String get chWc2Teams => 'Valigia sempre pronta';

  @override
  String get chWc2TeamsDesc =>
      'Vinci il Campionato del mondo con 2 nazionali diverse.';

  @override
  String get chWc3Teams => 'Giramondo';

  @override
  String get chWc3TeamsDesc =>
      'Vinci il Campionato del mondo con 3 nazionali diverse.';

  @override
  String get chWcStreak3 => 'Tris consecutivo';

  @override
  String get chWcStreak3Desc => 'Vinci 3 Campionati del mondo di fila.';

  @override
  String get chWcAllconf => 'Conquistatore del mondo';

  @override
  String get chWcAllconfDesc =>
      'Vinci il Campionato del mondo con una nazionale di ogni confederazione (6).';

  @override
  String get chCont5 => 'Re del continente';

  @override
  String get chCont5Desc => 'Vinci 5 campionati continentali.';

  @override
  String get chContAll => 'Slam dei sei continenti';

  @override
  String get chContAllDesc =>
      'Vinci il campionato continentale di ogni confederazione (6).';

  @override
  String get chTreble => 'Tutto in bacheca';

  @override
  String get chTrebleDesc =>
      'Vinci il Campionato del mondo, un titolo continentale e la Coppa delle Nazioni in una sola carriera.';

  @override
  String get chNations10 => 'Nomade';

  @override
  String get chNations10Desc => 'Guida 10 nazionali diverse.';

  @override
  String get chYears100 => 'Secolo';

  @override
  String get chYears100Desc => 'Allena per 100 anni.';

  @override
  String get chYears500 => 'Mezzo millennio';

  @override
  String get chYears500Desc => 'Allena per 500 anni.';

  @override
  String get chYears1000 => 'Eterno';

  @override
  String get chYears1000Desc => 'Allena per 1000 anni.';

  @override
  String get chGrandmaster => 'Gran maestro';

  @override
  String get chGrandmasterDesc =>
      'Vinci 3 Campionati del mondo E 5 campionati continentali.';

  @override
  String get chUndefeated => 'Intoccabile';

  @override
  String get chUndefeatedDesc =>
      'Vinci un Campionato del mondo senza perdere neanche una partita.';

  @override
  String get chPerfectQual => 'Cammino perfetto';

  @override
  String get chPerfectQualDesc =>
      'Vinci tutte le partite di un girone di qualificazione al Campionato del mondo.';

  @override
  String get chMinnow => 'Miracolo della piccola';

  @override
  String get chMinnowDesc =>
      'Vinci il Campionato del mondo con una nazionale fuori dalle prime 32 del ranking.';

  @override
  String get chGrandTour => 'Casa e trasferta';

  @override
  String get chGrandTourDesc =>
      'Vinci un Campionato del mondo da paese ospitante e uno lontano da casa.';

  @override
  String get chUnbeaten25 => 'Il muro';

  @override
  String get chUnbeaten25Desc => 'Resta imbattuto per 25 partite ufficiali.';

  @override
  String get chGoals10k => 'Macchina da gol';

  @override
  String get chGoals10kDesc => 'Segna 10.000 gol in carriera.';

  @override
  String get chCleanSheets500 => 'Fortezza';

  @override
  String get chCleanSheets500Desc =>
      'Chiudi 500 partite a porta inviolata in carriera.';

  @override
  String get chHatTricks25 => 'Vizio della tripletta';

  @override
  String get chHatTricks25Desc => 'Fai segnare 25 triplette ai tuoi giocatori.';

  @override
  String get chWinStreak25 => 'Implacabile';

  @override
  String get chWinStreak25Desc => 'Vinci 25 partite di fila.';

  @override
  String get chCont10 => 'Dinastia continentale';

  @override
  String get chCont10Desc => 'Vinci 10 campionati continentali.';

  @override
  String get chPcWc => 'Campione seriale';

  @override
  String chPcWcDesc(int count) {
    return 'Vinci $count Campionati del mondo in questo salvataggio.';
  }

  @override
  String get chPcMajors => 'Collezionista di trofei';

  @override
  String chPcMajorsDesc(int count) {
    return 'Vinci $count trofei importanti (Campionato del mondo, continentale o Coppa delle Nazioni).';
  }

  @override
  String get chPcUnbeaten => 'Muro di ferro';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Resta imbattuto per $count partite ufficiali.';
  }

  @override
  String get chPcNations => 'Girovago';

  @override
  String chPcNationsDesc(int count) {
    return 'Guida $count nazionali diverse.';
  }

  @override
  String get chPcYears => 'Sulla lunga distanza';

  @override
  String chPcYearsDesc(int count) {
    return 'Allena per $count anni.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vittorie',
      one: '1 vittoria',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vinci $count partite.',
      one: 'Vinci 1 partita.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partite',
      one: '$count partita',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gioca $count partite.',
      one: 'Gioca 1 partita.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Qualificato al Campionato del mondo';

  @override
  String get achQualWcDesc => 'Qualificati al Campionato del mondo.';

  @override
  String get achQualCont => 'Qualificato al continentale';

  @override
  String get achQualContDesc => 'Qualificati al tuo campionato continentale.';

  @override
  String get achTitleWc => 'Campioni del mondo';

  @override
  String get achTitleWcDesc => 'Vinci il Campionato del mondo.';

  @override
  String get achTitleEuro => 'Campioni d\'Europa';

  @override
  String get achTitleEuroDesc => 'Vinci il Campionato europeo.';

  @override
  String get achTitleCopa => 'Campioni del Sud America';

  @override
  String get achTitleCopaDesc => 'Vinci la Coppa del Sud America.';

  @override
  String get achTitleAfcon => 'Campioni d\'Africa';

  @override
  String get achTitleAfconDesc => 'Vinci il Campionato africano.';

  @override
  String get achTitleAsia => 'Campioni d\'Asia';

  @override
  String get achTitleAsiaDesc => 'Vinci il Campionato asiatico.';

  @override
  String get achTitleConcacaf => 'Campioni del Nord America';

  @override
  String get achTitleConcacafDesc => 'Vinci la Coppa del Nord America.';

  @override
  String get achTitleOfc => 'Campioni d\'Oceania';

  @override
  String get achTitleOfcDesc => 'Vinci la Coppa d\'Oceania.';

  @override
  String get achTitleNations => 'Vincitori della Coppa delle Nazioni';

  @override
  String get achTitleNationsDesc => 'Vinci la Coppa delle Nazioni.';

  @override
  String get achTitleClash => 'Vincitori della Sfida continentale';

  @override
  String get achTitleClashDesc => 'Vinci la Sfida continentale.';

  @override
  String get achMarksman => 'Cecchino del Campionato del mondo';

  @override
  String get achMarksmanDesc =>
      'Fai segnare a un giocatore della rosa almeno 6 gol nella fase finale del Campionato del mondo.';

  @override
  String get achSweep => 'Tutto in bacheca';

  @override
  String get achSweepDesc =>
      'Conquista il Campionato del mondo e il titolo continentale in una sola carriera.';

  @override
  String get achAllstar => 'All-Star del torneo';

  @override
  String get achAllstarDesc =>
      'Fai entrare un giocatore nella squadra ideale di un Campionato del mondo.';

  @override
  String get achGoldenboot => 'Scarpa d\'oro';

  @override
  String get achGoldenbootDesc =>
      'Porta un tuo giocatore a chiudere da capocannoniere di un torneo.';

  @override
  String get achDemolition => 'Demolizione';

  @override
  String get achDemolitionDesc =>
      'Vinci una partita con 5 o più gol di scarto.';

  @override
  String get achievementsNice => 'Grande!';

  @override
  String get achievementsHardestTests =>
      'Le prove più dure per un CT, lungo un\'intera carriera e tante nazionali.';

  @override
  String get achievementsThisSave => 'QUESTO SALVATAGGIO';

  @override
  String get achievementsBrutalBadge => 'DURISSIMA';

  @override
  String get paywallGoPro => 'PASSA A ILLIMITATO';

  @override
  String get paywallOneTimeUnlock => 'Sblocco una tantum. Nessun abbonamento.';

  @override
  String get paywallBenefitCarryOn =>
      'Questo salvataggio riprende esattamente da dove si era fermato, con ogni presenza, record e rivalità intatti.';

  @override
  String get paywallBenefitNoAds =>
      'Niente pubblicità, niente microtransazioni, niente abbonamento. Un solo pagamento e ogni aggiornamento futuro è tuo.';

  @override
  String get paywallBenefitSaves =>
      'Tutti i salvataggi che vuoi. Guida una favorita e una piccola insieme, e scopri quanto diversamente si legge lo stesso gioco.';

  @override
  String get paywallBenefitEndless =>
      'Tutti i cicli da qui in avanti. Scegli un diciassettenne oggi e scopri nel 2034 se ci avevi visto giusto.';

  @override
  String get paywallUnlocked => 'Illimitato è sbloccato. Buon divertimento!';

  @override
  String get paywallContactingStore => 'Connessione allo store…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Sblocca Illimitato · $price';
  }

  @override
  String get paywallRestorePurchases => 'Ripristina acquisti';

  @override
  String get paywallStoreUnavailable => 'Store non disponibile';

  @override
  String get paywallStoreUnavailableNote =>
      'Impossibile caricare il prezzo. Controlla la connessione e riprova.';

  @override
  String get paywallTryAgain => 'Riprova';

  @override
  String get gateTitle => 'IL TUO PRIMO CICLO È FINITO';

  @override
  String get gateLead =>
      'Quattro anni sono un ciclo. Non bastano per scoprire se avevi ragione.';

  @override
  String get gatePriceLead => 'Un pagamento, per sempre';

  @override
  String get gateBuy => 'ACQUISTA E CONTINUA';

  @override
  String get gateExit => 'ESCI';

  @override
  String get gateSaveTitle => 'QUESTO SALVATAGGIO RICHIEDE PRO';

  @override
  String get gateSaveLead =>
      'I salvataggi oltre il ciclo gratuito e le campagne Pro continuano con Pro. Non si perde nulla: il salvataggio ti aspetta esattamente come l’hai lasciato.';

  @override
  String get careerSaveLockedNote =>
      'Serve Pro per continuare questo salvataggio';

  @override
  String get federationNaturalisation => 'NATURALIZZAZIONE';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name naturalizzato';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name ha completato il cambio ed è ora convocabile per $nation. Chiamalo dalla selezione della rosa.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Impossibile caricare l\'offerta.\n$error';
  }

  @override
  String get federationContinue => 'Continua';

  @override
  String get federationOfferToSwitchAllegiance =>
      'UN\'OFFERTA PER CAMBIARE NAZIONALE';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · età $age · da $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name ha legami con $playerNation ed è disposto a essere naturalizzato. Accetta e potrà essere convocato; rifiuta e resterà con $sourceNation.';
  }

  @override
  String get federationDecline => 'Rifiuta';

  @override
  String get federationNaturalise => 'Naturalizza';

  @override
  String get federationBudgetLater => 'Decidi dopo';

  @override
  String get federationSetYourBudget => 'FISSA IL BUDGET';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Impossibile caricare le finanze.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Salvataggio non trovato.';

  @override
  String get federationBudgetHeading => 'BUDGET DELLA FEDERAZIONE';

  @override
  String federationDistributeBudget(String amount) {
    return 'Distribuisci $amount tra i reparti per aprire il ciclo. Spendi con giudizio.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount più di quanto ha la federazione. Togli qualcosa';
  }

  @override
  String get federationAllocateFullBudget =>
      'Assegna tutto il budget per iniziare il ciclo.';

  @override
  String get federationConfirming => 'Conferma in corso…';

  @override
  String get federationConfirmBudget => 'Conferma il budget';

  @override
  String get federationFinances => 'FINANZE';

  @override
  String get federationInvestmentUpdated => 'Investimento aggiornato.';

  @override
  String get federationDevelopment => 'SVILUPPO DELLA FEDERAZIONE';

  @override
  String get federationProjectedAtSeasonEnd => 'PREVISIONE A FINE STAGIONE';

  @override
  String get federationCentralFunding => 'Fondi centrali';

  @override
  String get federationPrizeMoneySoFar => 'Premi finora';

  @override
  String get federationCommercialReturn => 'Ricavi commerciali';

  @override
  String get federationThisSeasonLocked => 'QUESTA STAGIONE (BLOCCATA)';

  @override
  String get federationInvestForNextSeason =>
      'INVESTI PER LA PROSSIMA STAGIONE';

  @override
  String get federationNextSeasonImpact => 'EFFETTO SULLA PROSSIMA STAGIONE';

  @override
  String get federationSaving => 'Salvataggio…';

  @override
  String get federationConfirmInvestment => 'Conferma l\'investimento';

  @override
  String get federationBalance => 'SALDO DELLA FEDERAZIONE';

  @override
  String get federationCommittedToStaff => 'Impegnato per lo staff';

  @override
  String get federationFreeToSpend => 'Libero da spendere';

  @override
  String get federationWagesNote =>
      'Gli stipendi escono dal saldo a fine ciclo, quindi questa cifra è già impegnata.';

  @override
  String get federationInvestAtCeremony =>
      'Investi per la prossima stagione alla cerimonia di fine ciclo.';

  @override
  String federationLevelBadge(int level) {
    return 'L$level';
  }

  @override
  String get federationAcademyProspects => 'Giovani del vivaio';

  @override
  String federationPlusOverall(int value) {
    return '+$value di valore';
  }

  @override
  String get federationInjuryRisk => 'Rischio infortuni';

  @override
  String get federationNaturalisationChance =>
      'Probabilità di naturalizzazione';

  @override
  String get federationBoardPatience => 'Pazienza della federazione';

  @override
  String get federationUnallocated => 'NON ASSEGNATO';

  @override
  String get nationsVitrineTitle => 'VETRINA NAZIONALE';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Impossibile caricare la nazionale.\n$error';
  }

  @override
  String get nationsNoNation => 'Nessuna nazionale.';

  @override
  String get nationsHonours => 'PALMARÈS';

  @override
  String get nationsRankingHistory => 'STORICO DEL RANKING MONDIALE';

  @override
  String get nationsTopScorers => 'MIGLIORI MARCATORI DI SEMPRE';

  @override
  String get nationsTitles => 'TITOLI';

  @override
  String get nationsYourTeam => 'LA TUA SQUADRA';

  @override
  String get nationsWorld => 'MONDO';

  @override
  String get nationsWorldCup => 'Campionato del mondo';

  @override
  String get nationsContinental => 'Continentale';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partecipazioni',
      one: '1 partecipazione',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Non c\'è ancora abbastanza storia. Ricontrolla tra un ciclo o due.';

  @override
  String nationsBestRank(int rank) {
    return 'Migliore: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Ora: #$rank';
  }

  @override
  String get nationsNoGoals => 'Ancora nessun gol registrato.';

  @override
  String get nationsGoalsAbbrev => 'gol';

  @override
  String get nationsHosts => 'OSPITANTE';

  @override
  String get nationsSelectTitle => 'SCEGLI LA NAZIONALE';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Impossibile caricare le nazionali.\n$error';
  }

  @override
  String get nationsNoMatch => 'Nessuna nazionale trovata.';

  @override
  String get nationsSelectHeading => 'Scegli la nazionale';

  @override
  String get nationsSearchHint => 'Cerca paese…';

  @override
  String get nationsRank => 'RANKING ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'SCEGLI';

  @override
  String get statsTeamRecords => 'RECORD DI SQUADRA';

  @override
  String get statsRecordBook => 'Albo dei record';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Impossibile caricare le statistiche.\n$error';
  }

  @override
  String get statsNoData => 'Nessun dato.';

  @override
  String get statsTopScorers => 'MIGLIORI MARCATORI';

  @override
  String get statsMostGamesPlayed => 'PIÙ PARTITE GIOCATE';

  @override
  String get statsTeam => 'Squadra';

  @override
  String get statsTopScorersShort => 'Marcatori';

  @override
  String get statsMostGames => 'Più partite';

  @override
  String get statsNoGoalsRecorded => 'Ancora nessun gol registrato.';

  @override
  String get statsUnknown => 'Sconosciuto';

  @override
  String get playerTitle => 'GIOCATORE';

  @override
  String playerLoadError(String error) {
    return 'Impossibile caricare il giocatore.\n$error';
  }

  @override
  String get playerNotFound => 'Giocatore non trovato.';

  @override
  String get playerClub => 'CLUB';

  @override
  String get playerClubRole => 'Nel suo club';

  @override
  String get playerPosition => 'Ruolo';

  @override
  String get playerPotential => 'Potenziale';

  @override
  String get playerAge => 'Età';

  @override
  String get playerValue => 'Valore';

  @override
  String get clubFirstChoice => 'Titolare fisso';

  @override
  String get clubRotation => 'A rotazione';

  @override
  String get clubFringe => 'Gioca poco';

  @override
  String get clubFrozenOut => 'Fuori squadra';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Guardo calcio da trent\'anni e questa non l\'avevo vista arrivare. $opponent ko, $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Nessuno ci dava una chance contro $opponent. $score. Proprio nessuno.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score contro $opponent. Andate a svegliare i vicini.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Questa è una di quelle notti che si raccontano ai nipoti. $opponent, $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score contro $opponent. Non so come sia successo, ma è successo.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Sulla carta era finita prima di cominciare. $opponent, $score: la carta si sbagliava.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponent ko, $score. Tra un anno nessuno ci crederà.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent, $score. Godetevela, poi guardate il calendario.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score contro $opponent, e per ottanta minuti su novanta ci è andata di lusso.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Una notte contro $opponent non cancella un anno. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent ko, $score, e adesso ci diranno che abbiamo svoltato. Non è così.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent, $score. Bellissimo. Richiedetemelo quando conta davvero.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent ko, $score. Esattamente come doveva andare, e c\'è un piacere anche in questo.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score contro $opponent. Spietati, e spietati è un complimento.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent, $score. Niente storie, niente spaventi, niente lamentele.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Un ordinato $score contro $opponent. Ecco com\'è una buona squadra in una giornata tranquilla.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score contro $opponent. Compito fatto, niente imparato.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent ko, $score. Dovevamo farlo, e l\'abbiamo fatto.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Un $score da professionisti su $opponent. Avanti la prossima.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return 'Pratica $opponent chiusa, $score. Archiviamo e andiamo avanti.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score contro $opponent e dovremmo pure applaudire. Per averli battuti.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Complimenti a tutti per il $score contro $opponent, immagino.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent, $score. Battere squadre così è il minimo, non un traguardo.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Abbiamo battuto $opponent $score e abbiamo faticato pure a farlo.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score contro $opponent e ogni minuto ce lo siamo sudato.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Ci voleva carattere. $opponent, $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent ko, $score, nel modo più duro, che è quello che resta.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score contro $opponent. Chi vince partite così è ancora in piedi a giugno.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nervosa, brutta, ma vinta. $opponent, $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent ko, $score. Prendiamo i tre punti e non riguardiamola mai più.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent ci ha fatto sudare ogni centimetro.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent, $score. Non bella. Vale uguale.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score contro $opponent e ce la siamo complicata dieci volte più del necessario.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Non dovremmo soffrire così contro $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent, $score. Vinta, e non abbiamo imparato niente di buono su di noi.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'Un $score contro $opponent che ci lusinga.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Un punto contro $opponent, $score. Prendiamolo e andiamo avanti.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score con $opponent. Ci sono pomeriggi peggiori.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Pari $score con $opponent. Non tutto deve essere una storia.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent, $score. Un punto è un punto e la classifica non chiede come.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score con $opponent. Due punti persi o uno guadagnato. Scegliete voi l\'umore.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Pari contro $opponent, $score. Nessuno contento, nessuno furioso.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent, $score. I novanta minuti più dimenticabili dell\'anno.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Pari e patta con $opponent, $score. Si va avanti.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score contro $opponent. È con pareggi così che le campagne muoiono in silenzio.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Due punti buttati contro $opponent. $score. Non c\'è altro modo di dirlo.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent, $score. Avevamo novanta minuti e nessuna idea di cosa farne.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Un $score con $opponent che nessuno ricorderà e che tutti pagheranno.';
  }

  @override
  String yLost0(String opponent, String score) {
    return '$opponent ci batte $score. Succede.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent, $score. Niente per cui crocifiggere qualcuno. Pensiamo alla prossima.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Persa $score contro $opponent dando tutto. Certi giorni non basta.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score contro $opponent. Testa alta. Questa squadra ha ancora tanto da dare.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent, $score. Siamo stati inferiori e non si discute.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Persa $score contro $opponent. Ricompattiamoci.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score contro $opponent. Non una vergogna, ma non abbastanza.';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$opponent ci batte $score. Impariamo qualcosa, o è stato tempo perso.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score contro $opponent e non li abbiamo nemmeno sfiorati.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Persa contro $opponent, $score. Stessi problemi, stesso mese, stesse scuse in arrivo.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent, $score. Quand\'è che smette di essere sfortuna?';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$opponent ci batte $score. Un risultato che dovrebbe costare qualcosa a qualcuno.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score contro $opponent. Una brutta serata. Giudicate la squadra sulla campagna, non su questo.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Nessuno voleva quel $score contro $opponent meno dei giocatori.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent, $score. Brutta, e non è questa la vera squadra.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Un $score da dimenticare contro $opponent. La prossima volta risponderanno.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Contro $opponent. Non ho parole, e mi pagano per averne.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent, $score. Qualcuno dovrà risponderne.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Voglio quel $score contro $opponent cancellato dagli annali e dalla memoria.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$opponent ci batte $score. Non c\'è modo di addolcire un risultato così.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Non è stata una sconfitta contro $opponent, è stata una resa. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Contro $opponent. C\'è gente che ha pagato per vedere questo.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent, $score. Se questo non cambia qualcosa, niente lo farà.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Ho già visto questa squadra umiliata, ma $score contro $opponent è un nuovo fondo.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return 'Vittoria $score contro $opponent. Segnatevi la data, vi chiederanno dov\'eravate.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Fuori dallo spogliatoio non ci credeva nessuno. $score contro $opponent. Orgoglio è dire poco.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score contro $opponent! Hanno corso tutti finché ne avevano.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Ammazzagiganti. $opponent, $score. Ecco perché continuiamo a esserci, sempre.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score contro $opponent. I pronostici sono appena volati dalla finestra.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Grande favorita: $opponent. Risultato finale: $score per noi.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Una delle sorprese dell\'anno: $score contro $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Nessuno l\'aveva previsto e nessuno sa spiegarlo davvero.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score contro $opponent. Bellissimo. Ora tutti dimenticheranno com\'è andato il resto dell\'anno.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score contro $opponent e il carro è già pieno. Io c\'ero quando era vuoto.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Fantastico, e troveranno comunque il modo di sprecarlo.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Grande serata contro $opponent, $score. Una rondine non fa primavera.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score contro $opponent. Fa male perché ci teniamo. Sosteniamoli lo stesso.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Una serata da dimenticare contro $opponent, $score. Ai giocatori fa più male che a chiunque.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Testa alta. Una squadra si giudica da come risponde a questo.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score contro $opponent. Brutto, sì. La fine del mondo, no.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score contro $opponent. Un risultato di cui si parlerà per anni, per i motivi sbagliati.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Vittoria di $opponent, $score. Dopo questa, nessuno si stupisca la prossima volta.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Una delle serate peggiori da molto tempo: $score contro $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Ci saranno domande, ed è giusto così.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score contro $opponent. Imbarazzante è un eufemismo.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Sconfitta $score contro $opponent. L\'ultimo che esce spenga la luce.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Non mi sorprendo più, e questo mi spaventa.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Qualcuno ai piani alti dovrebbe aggiornare il curriculum stasera.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score contro $opponent! Un calcio così fa sorridere tutto il Paese.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return 'Lezione di calcio a $opponent, $score. Che prestazione.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Contro $opponent. Stasera è riuscito tutto.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'Una demolizione per $score contro $opponent. Salvatevi gli highlights, li vorrete.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Questa è una squadra che si diverte a giocare.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score contro $opponent, e potevano essere di più. Splendido.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score contro $opponent. Un risultato che fa guardare due volte.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return 'Vittoria $score contro $opponent. Partita finita dopo mezz\'ora.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Risultato finale: $score contro $opponent. Di gran lunga la vittoria più larga da tempo.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Una squadra è venuta a giocare, l\'altra non è nemmeno scesa dal pullman.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. Nessuna risposta da $opponent, su niente.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Una goleada: $score contro $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score contro $opponent. Bello, ma non sono esattamente il metro di paragone.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score contro $opponent. Svegliatemi quando lo faremo a qualcuno di forte.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Divertente, ma ho visto squadre brillare così e non vincere niente.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, e sono tutti di nuovo dei geni. Era $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score contro $opponent. Niente voli pindarici, dimostra ben poco.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Godetevela, poi ricordate com\'è finita l\'ultima volta che ci siamo esaltati.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Passiamo ai rigori contro $opponent! Nervi d\'acciaio, tutti quanti.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Rigori contro $opponent, e abbiamo tenuto i nervi saldi. Abbracciate uno sconosciuto.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Lotteria dei rigori vinta contro $opponent. Il mio cuore non regge.';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'Vittoria ai rigori contro $opponent. Al turno successivo.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Contro $opponent si è deciso dal dischetto, e ne abbiamo segnati di più.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Rigori vinti contro $opponent. Nel modo più difficile, ma passiamo.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Passiamo ai rigori contro $opponent. Lotteria vinta, prestazione da dimenticare.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Battere $opponent ai rigori dopo una partita così? Fortuna, e lo sanno tutti.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Passiamo contro $opponent ai rigori. Non avremmo mai dovuto arrivarci.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'QUALIFICATI. $score contro $opponent, e il sogno continua.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'VITTORIA A ELIMINAZIONE DIRETTA: $score contro $opponent. Il Paese può cominciare a crederci.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score contro $opponent e si va al turno successivo. Che serata.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return 'A casa $opponent, $score. Avanti.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'ELIMINAZIONE DIRETTA: $score contro $opponent. Turno successivo confermato.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Qualificati: $score contro $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return 'Fuori $opponent, $score. Ci aspetta il turno successivo.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Vittoria $score contro $opponent. A eliminazione diretta nessuno chiede come.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Passiamo contro $opponent, $score. Il prossimo avversario non sarà così gentile.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return 'Il $score contro $opponent basta per passare. La prossima volta servirà molto di più.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return 'Fuori $opponent, $score. Più sopravvissuti che vincitori.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Al turno successivo dopo il $score contro $opponent. Non chiedete come.';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return '$gap posizioni di distanza nel ranking, e abbiamo battuto $opponent lo stesso. Magnifico.';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent: $gap posizioni sopra di noi. E li abbiamo battuti. Il calcio è meraviglioso.';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'Distanza nel ranking: $gap posizioni. Risultato: vittoria contro $opponent. Non smettete mai di crederci.';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'Distanza nel ranking prima del calcio d\'inizio: $gap posizioni. Vittoria contro $opponent comunque.';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'Nel ranking mondiale $opponent era $gap posizioni sopra di noi. Non stasera.';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'Indice di sorpresa: $gap posizioni di ranking tra le due. Vittoria nostra contro $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return '$gap posizioni di ranking ci separavano da $opponent. Una serata non colma il divario.';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: $gap posizioni sopra, eppure ha perso. Il ranking se ne accorgerà appena.';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'Distanza nel ranking: $gap posizioni. Ricordate questo numero la prossima volta che perdiamo con una piccola.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Avevo dato per finita questa squadra. Mi sbagliavo, e non sono mai stato così felice di sbagliarmi. Vittoria contro $opponent.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Una porzione di umiltà, grazie. Abbondante. La vittoria contro $opponent è stata magnifica.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Avevo detto che non avevano più niente. Avevano tantissimo. Bravi tutti contro $opponent.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Per la cronaca, quella vittoria contro $opponent non l\'avevo vista arrivare. Onore al merito.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Va bene. Avevo detto che sarebbero stati smascherati. Con $opponent non è successo.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Stasera mi rimangio le parole su questa squadra. Battere $opponent se lo merita.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Sì, avevo detto che erano finiti. Una vittoria contro $opponent non mi dà ancora torto.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Mi dicono di rimangiarmi le parole dopo $opponent. Lo farò, lentamente, e tengo lo scontrino.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Battere $opponent è stato notevole. I miei dubbi su questa squadra restano tutti.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Complimenti a $nation. $score, e se lo sono meritato fino in fondo.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Fa male dirlo, ma stasera la squadra migliore era $nation. $score. Complimenti.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Tanto di cappello a $nation, l\'hanno voluta di più.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Sconfitta $score contro $nation. Non so nemmeno cosa dire.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. I nostri dovrebbero vergognarsi.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score contro $nation. Qualcuno mi spieghi com\'è successo.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Perdere $score contro $nation. Non me lo toglierò mai dalla testa.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score contro $nation. Fortuna. Pura fortuna.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Dopo questo $score, i tifosi di $nation saranno insopportabili per anni. Grazie di niente.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Splendido per il calcio. Ecco perché lo amiamo.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Che risultato per $nation: $score contro $opponent. Il calcio al suo meglio.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Stasera tutti i neutrali tifano $nation. $score contro $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Risultato della giornata: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Non l\'aveva in schedina nessuno.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Grande risultato: $nation $score $opponent. Il ranking si muoverà.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Divertente, vediamo se ci riescono di nuovo.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ha vinto $nation o ha perso $opponent?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Colpaccio: $nation $score $opponent. Aspettatevi reazioni esagerate.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name contro $opponent. Daranno il suo nome ai bambini.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Una statua per $name. Stasera contro $opponent è stato tutto.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, che giocatore. Ricordatevi questa serata contro $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name l\'ha decisa contro $opponent. Migliore in campo, senza discussioni.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Contro $opponent la serata è stata di $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name si è fatto trovare pronto quando contava, contro $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name è stato straordinario contro $opponent. Ora ogni settimana.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name ha salvato la squadra contro $opponent. Gli altri hanno aiutato poco.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Senza $name, la serata contro $opponent sarebbe stata tutta un\'altra cosa.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score contro $opponent. Un incidente. Capita a tutti, una volta.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Sconfitta $score contro $opponent. Scrollatevela di dosso, la campagna non è finita.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Fa male, ma un risultato non definisce questa squadra.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score contro $opponent. Una brutta giornata in ufficio. Avanti.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Sconfitta contro $opponent, $score. Nessuno se l\'aspettava.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Una di quelle serate che non hanno senso.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score contro $opponent. Una sconfitta che verrà ricordata.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Battuti da $opponent, $score. Una sorpresa comunque la si guardi.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score contro $opponent. Contro $opponent! Inaccettabile.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Sconfitta $score contro $opponent. Voglio spiegazioni, non scuse.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Una vergogna nazionale, e non è un modo di dire.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score contro $opponent. Come fa qualcuno ai piani alti a essere ancora al suo posto?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score contro $opponent. È una squadra di vertice. Impariamo.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Surclassati da $opponent, $score. Nessuna vergogna a perdere contro i migliori.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Una lezione, e con le lezioni si cresce.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score contro $opponent. Fa male, ma sono un gradino sopra.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Vittoria di $opponent, $score. Il divario è reale, e ora l\'hanno visto tutti.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score contro $opponent. Una lezione severa, punto.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. La squadra migliore, e il risultato lo dice.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Sconfitta $score contro $opponent. Non un disonore, ma nemmeno una partita.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score contro $opponent. Avversario migliore o no, non si perde così.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Abbiamo almeno provato a competere?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Contro $opponent. Agnelli al macello.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Battuti $score da $opponent, e nessuno sembrava preoccuparsene.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Fuori ai rigori contro $opponent. Hanno dato tutto. Orgoglioso di loro.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Rigori contro $opponent. Il modo più crudele di uscire. Testa alta.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Lotteria dei rigori persa contro $opponent. Nessuno se lo meritava.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Fuori ai rigori contro $opponent. Ha deciso il dischetto.';
  }

  @override
  String yLostShootout4(String opponent) {
    return 'Passa $opponent ai rigori. Il nostro torneo finisce qui.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Rigori persi contro $opponent. Ancora i rigori.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Fuori ai rigori contro $opponent. Li proviamo mai in allenamento?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Battuti da $opponent ai rigori. Andava chiusa molto prima.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Rigori contro $opponent, e li abbiamo persi. Ovviamente.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ELIMINATI. $score contro $opponent. Un cammino di cui andare fieri finisce qui.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Eliminati da $opponent, $score. Grazie per i ricordi.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score contro $opponent. Il viaggio è finito, ma che viaggio.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'FUORI: $score contro $opponent. Testa alta.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'ELIMINATI: $score contro $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Fuori: $score contro $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return 'Passa $opponent, $score. Il nostro torneo è finito.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Eliminati da $opponent, $score. Comincia il processo.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'FUORI. $score contro $opponent. Un altro torneo, lo stesso finale.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score contro $opponent, e tutti a casa. Nessuno è sorpreso.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Eliminati da $opponent, $score. Aspettatevi scuse entro domattina.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Fuori, e non è mai sembrato che potesse finire diversamente.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score contro $nation. Rispetto, torneranno più forti.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Bella vittoria nostra, $score. Brutta giornata per $nation, mi dispiace per i loro tifosi.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Brutta serata per $nation, e noi abbiamo colto l\'occasione. È il calcio.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score contro $nation! Chi se l\'aspettava? Non loro.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Vittoria $score contro $nation. Qualcuno vada a vedere come stanno i loro tifosi.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Questa va nell\'album di famiglia.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score contro $nation. E si credono una grande squadra.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Immagina perdere $score contro di noi. Chiedi a $nation, ora lo sanno.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Buon volo di ritorno.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Grande serata per $opponent, dura per $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Un pensiero ai tifosi di $nation dopo il $score contro $opponent. Si rialzeranno.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ogni grande squadra ha una serata così.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Colpaccio della giornata: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nessuno se l\'aspettava.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Risultato del giorno: $nation $score $opponent. Ora tocca a $nation dare risposte.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Non è un caso isolato, se avete seguito.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Qualcuno lì avrà molto da spiegare.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Grande nome, piccola prestazione.';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent: $gap posizioni sotto di noi. Succede. Avanti.';
  }

  @override
  String yDownGap1(String gap) {
    return 'Distanza nel ranking: $gap posizioni a nostro favore. Il calcio non legge le classifiche.';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return '$gap posizioni tra noi e $opponent sulla carta. Non in campo, stasera.';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'Distanza nel ranking prima del calcio d\'inizio: $gap posizioni a favore. Sconfitta contro $opponent comunque.';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'Nel ranking mondiale $opponent era $gap posizioni sotto di noi. Risultato: sconfitta.';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'Indice di sorpresa: $gap posizioni di ranking, al contrario, contro $opponent.';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return '$gap posizioni sopra $opponent nel ranking. Sconfitta. Spiegatemelo.';
  }

  @override
  String yDownGap7(String gap) {
    return 'Sconfitta contro una squadra $gap posizioni sotto di noi. Lasciate che quel numero vi entri in testa.';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'Distanza nel ranking: $gap posizioni. Sconfitta contro $opponent. Qualcuno dovrebbe contare i giorni.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score contro $opponent! Un pareggio che sa di vittoria.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score contro $opponent. Orgoglioso di ognuno di loro.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Erano i favoriti e abbiamo tenuto testa.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score con $opponent. Un punto sudato col sangue.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score contro $opponent. Un ottimo punto.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Pareggio $score con $opponent. In pochi si aspettavano qualcosa.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return 'Pari con $opponent, $score. Un risultato su cui costruire.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score contro $opponent. Un punto che nessuno ci dava.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score con $opponent. Buon punto, ma con i pareggi non si vince niente.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score contro $opponent. Bello. Non abbiamo nemmeno tirato in porta sul serio.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Un punto, e tutti fanno come se avessimo vinto il trofeo.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score contro $opponent. Pullman davanti alla porta e tanta fortuna.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score con $opponent. Frustrante, ma ancora imbattuti.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Solo $score con $opponent. Giornata storta. Capita.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Non basta, e i giocatori lo sanno.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score contro $opponent. Due punti persi, niente di più.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score con $opponent. Due punti buttati.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Solo $score con $opponent. Un brutto risultato, comunque lo si giri.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Un pareggio che sa di sconfitta.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score contro $opponent. Queste partite vanno vinte senza problemi.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score con $opponent. Imbarazzante.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Solo un pareggio con $opponent, $score. Chi ne è responsabile?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Se non battiamo loro, chi battiamo?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score con $opponent. I loro tifosi festeggiano un pareggio contro di noi. Pensateci.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'CAMPIONI. $opponent. Ditelo ad alta voce.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'L\'abbiamo vinto. $opponent. Non sto bene.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent: il trofeo torna a casa.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Leggende, tutti quanti. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Così vicini. $opponent e una medaglia che nessuno vuole.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return '$opponent: secondi. Brucerà per anni.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: a una partita da tutto.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Secondi. $opponent. Passatemi la bottiglia.';
  }

  @override
  String yEliminated0(String opponent) {
    return '$opponent: fuori. Questa farà male per un po\'.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent: per noi finisce qui.';
  }

  @override
  String yEliminated2(String opponent) {
    return '$opponent: eliminati. Ora il processo.';
  }

  @override
  String yEliminated3(String opponent) {
    return '$opponent: fuori. Qualcuno me lo spieghi.';
  }

  @override
  String yQualified0(String opponent) {
    return '$opponent: ARRIVIAMO.';
  }

  @override
  String yQualified1(String opponent) {
    return '$opponent: qualificati. Prendete le ferie.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, arriviamo. Mai stati in dubbio (lo eravamo del tutto).';
  }

  @override
  String yQualified3(String opponent) {
    return '$opponent: qualificati. La parte difficile è fatta.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return '$opponent: girone sorteggiato. Poteva andare peggio. Molto peggio.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return '$opponent: ecco il sorteggio. Interessante.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return '$opponent: usciti i gironi, e il nostro già non mi piace.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return '$opponent: sorteggio fatto. Che le esagerazioni abbiano inizio.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent lo ospiterà. Cominciate a risparmiare.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Lo ospiterà $opponent. Prevedibile, ma va bene.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent si prende il torneo. Complimenti, immagino.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Paese ospitante confermato: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent inizia a breve e non riesco a stare fermo.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return '$opponent: manca poco.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent è quasi qui. Le convocazioni, per favore.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return '$opponent: il conto alla rovescia è ufficialmente insopportabile.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Ancora niente da dire. Gioca una partita.';

  @override
  String get yEarlierHeading => 'Prima in questo ciclo';

  @override
  String get yTraitLoyalist =>
      'Sostiene la squadra qualunque cosa succeda. Lento a voltarsi, rapido a perdonare.';

  @override
  String get yTraitCynic =>
      'Pensa sempre al peggio ed è felice quando ha ragione.';

  @override
  String get yTraitNostalgic =>
      'Prima era tutto meglio. Ti paragona a gente che ha smesso da anni.';

  @override
  String get yTraitStatshead =>
      'Posta i numeri e nient\'altro. Quasi senza umore.';

  @override
  String get yTraitHypeman =>
      'Due buoni risultati ed è subito generazione d\'oro.';

  @override
  String get yTraitContrarian =>
      'Qualunque cosa pensi la sala, lui pensa il contrario.';

  @override
  String get yTraitDoomer => 'Andrà male. Andrà sempre male.';

  @override
  String get yProfilePosts => 'POST';

  @override
  String get yProfileEmpty => 'Ancora niente da questo account.';

  @override
  String hubEventGrievance(String player) {
    return '$player vuole parlarti';
  }

  @override
  String get hubEventGrievanceSub => 'Vuole sapere a che punto è';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punti abilità da spendere',
      one: '1 punto abilità da spendere',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Ciò in cui sei bravo rende migliore la tua squadra';

  @override
  String get grievanceTitle => 'Due parole in ufficio';

  @override
  String grievanceGameTime(String player) {
    return '$player è stato in rosa senza toccare palla. Vuole sapere perché.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player non è in rosa e non se lo spiega. Vuole una risposta, in un senso o nell\'altro.';
  }

  @override
  String grievanceRole(String player) {
    return '$player continua a giocare fuori ruolo e ne ha abbastanza.';
  }

  @override
  String get grievanceReassure => 'Sei nei miei piani';

  @override
  String get grievanceHonest => 'Sei dietro ad altri, ed ecco perché';

  @override
  String get grievanceDismiss => 'La squadra la faccio io';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name ne ha fatti $goals. Nessun altro si avvicina.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals per $name. Si sta caricando la squadra sulle spalle.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals oggi. Che giocatore.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return 'Gliene ha rifilati $goals, $name. Inchino.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals per $name, e gli altri erano passeggeri.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Ancora $name. $goals. Immaginate questa squadra senza di lui.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals di $name. Un uomo solo non dovrebbe fare così tanto.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Togli $name e sono $goals gol in meno e un pomeriggio molto diverso.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count di fila. Qualunque cosa si dica in quello spogliatoio, sta funzionando.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Fanno $count di fila. Serie così non arrivano per caso.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count di fila e si continua. La fiducia si vede dagli spalti.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Nessuna sconfitta in $count. Chiedete a chiunque abbia allenato: questa è la parte difficile.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count di fila. Godetevela finché il calendario è gentile.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count di fila, e non abbiamo battuto nessuno che conti.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Una serie di $count. Riparliamone quando verrà messa alla prova.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count di fila. Ogni squadra ne ha una così, prima o poi.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count senza vittorie ormai. Prima o poi le scuse finiscono.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Fanno $count di fila andate male. Non è più un passaggio a vuoto.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count sconfitte di fila. Qualcuno dovrà risponderne.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Nessuna vittoria in $count. Si vede da come giocano.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count senza vittorie e gli stessi errori ogni settimana.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count di fila. Qualunque cosa stiano provando, non funziona.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count di fila. Questa è una direzione, non un calo.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Nessuna vittoria in $count, e ai piani alti nessuno ha detto una parola.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent, $score. Dite quello che volete del gioco. Questa vale doppio.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Contro $opponent, proprio contro di loro. $score. Nessuno qui lo dimenticherà.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score contro $opponent. Questa è quella di cui si parlerà al bar.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'I vicini, $score. Sfottò sistemati per un bel po\'.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent, $score. Qualunque cosa succeda quest\'anno, almeno questa c\'è.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score contro $opponent. Ad alcuni di noi serviva più che alla classifica.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent, $score. E la prossima volta si rifaranno, lo fanno sempre.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Contro $opponent, $score. Un anno intero a sentircelo rinfacciare.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name fuori per infortunio. L\'ultima cosa che serviva a questa squadra.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Perdere $name cambia tutto l\'assetto.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name zoppica. Trattenete il fiato.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Niente $name per un po\', quindi. Qualcuno deve farsi avanti.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name fuori. Ovviamente proprio $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Senza $name questa diventa una squadra molto normale.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name di nuovo infortunato. Qualcuno dovrebbe chiedersi perché.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Perso $name, e dietro di lui non c\'è nessuno. Questo è il vero problema.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Rosso a $name al $minute\' e tutto il paese gli si rivolta contro. Ci ha dato più di tanti altri. Lasciatelo stare.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name fuori dopo $minute minuti. Severo. In dieci e ci abbiamo comunque provato, e questo dice qualcosa.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute\', cartellino rosso. In dieci da lì in poi.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Espulso: $name al $minute\'. Non è la prima partita che gira su una sola decisione.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Fantastico. $name se ne va al $minute\' e restiamo in dieci. Di nuovo.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name espulso dopo $minute minuti. Chi è che allena la disciplina qui?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minuti. Tanto è durata la testa di $name. Calcio professionistico.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Un rosso a $name al $minute\', e dovrei credere che sia un progresso.';
  }

  @override
  String get yBoardPressure0 =>
      'In federazione sono diventati molto silenziosi. Mai un buon segno.';

  @override
  String get yBoardPressure1 =>
      'Si dice che ai piani alti abbiano cominciato a fare domande.';

  @override
  String get yBoardPressure2 =>
      'Si sente il terreno che si muove ai piani alti.';

  @override
  String get yBoardPressure3 =>
      'Nessuno in federazione dice niente a sostegno. Traete le vostre conclusioni.';

  @override
  String get yBoardPressure4 =>
      'Da settimane nessuno ai piani alti lo difende in pubblico.';

  @override
  String get yBoardPressure5 =>
      'La federazione rema contro il suo stesso CT. Come sempre.';

  @override
  String get yBoardPressure6 => 'Quando la dirigenza tace, ha già deciso.';

  @override
  String get yBoardPressure7 =>
      'Lasceranno andare le cose finché la decisione non toccherà a qualcun altro.';

  @override
  String get yReplies => 'ANCHE SU QUESTA PARTITA';

  @override
  String get yPlayerGrievance0 =>
      'Ho chiesto a che punto sono. Aspetto ancora una risposta.';

  @override
  String get yPlayerGrievance1 => 'Mi alleno duro. Non posso fare molto altro.';

  @override
  String get yPlayerGrievance2 => 'Certe domande puoi farle una volta sola.';

  @override
  String get yPlayerGrievance3 =>
      'Non sono arrivato fin qui per portare le pettorine.';

  @override
  String get playerHonoursTitle => 'PALMARÈS';

  @override
  String get awardGoldenBall => 'Pallone d\'oro';

  @override
  String get awardGoldenBoot => 'Scarpa d\'oro';

  @override
  String get awardGoldenGlove => 'Guanto d\'oro';

  @override
  String get awardTeamOfTournament => 'Squadra del torneo';

  @override
  String get awardPlayerOfYear => 'Giocatore mondiale dell\'anno';

  @override
  String get awardYoungPlayerOfYear => 'Giovane dell\'anno';

  @override
  String get playerClubHistory => 'STORICO DEI CLUB';

  @override
  String get playerCareerRecord => 'CARRIERA';

  @override
  String get playerInternationalGoals => 'Gol in nazionale';

  @override
  String get playerRecentForm => 'FORMA RECENTE';

  @override
  String get playerMatchHistory => 'STORICO PARTITE';

  @override
  String get playerAttributes => 'ATTRIBUTI';

  @override
  String get playerUnknown => 'Sconosciuto';

  @override
  String get playerAttrPace => 'Velocità';

  @override
  String get playerAttrPhysical => 'Fisico';

  @override
  String get playerAttrTechnical => 'Tecnica';

  @override
  String get playerAttrShooting => 'Tiro';

  @override
  String get playerAttrPassing => 'Passaggio';

  @override
  String get playerAttrDribbling => 'Dribbling';

  @override
  String get playerAttrTackling => 'Contrasto';

  @override
  String get playerAttrPositioning => 'Posizione';

  @override
  String get playerAttrComposure => 'Freddezza';

  @override
  String get playerAttrDecisions => 'Decisioni';

  @override
  String get playerAttrStamina => 'Resistenza';

  @override
  String get playerAttrStrength => 'Forza';

  @override
  String get playerStatCaps => 'Presenze';

  @override
  String get playerStatGoals => 'Gol';

  @override
  String get playerStatAssists => 'Assist';

  @override
  String get playerStatAvgRating => 'Media voto';

  @override
  String get playerStatForm => 'Forma';

  @override
  String get playerStatMotm => 'Migliore in campo';

  @override
  String get playerStatCleanSheets => 'Porta inviolata';

  @override
  String get playerStatBestGame => 'Miglior partita';

  @override
  String get playerStatCards => 'Cartellini';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}G ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'IL TUO CAMMINO';

  @override
  String get tourSharedList => 'Elenco';

  @override
  String get tourSharedBracket => 'Tabellone';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Girone $seed';
  }

  @override
  String get tourSharedThisEdition => 'Questa edizione';

  @override
  String get tourSharedAllTime => 'Di sempre';

  @override
  String get tourSharedUnknown => 'Sconosciuto';

  @override
  String get tourSharedActive => 'IN ATTIVITÀ';

  @override
  String get tourSharedMedalTable => 'MEDAGLIERE';

  @override
  String get tourSharedPastWinners => 'ALBO D\'ORO';

  @override
  String tourSharedHost(String host) {
    return 'Paese ospitante: $host';
  }

  @override
  String get tourSharedBeat => 'batte';

  @override
  String get tourSharedPens => ' (rig.)';

  @override
  String get tourSharedAwardsEmpty =>
      'I premi vengono assegnati a torneo concluso.';

  @override
  String get tourSharedGoldenBall => 'PALLONE D\'ORO';

  @override
  String get tourSharedPlayerOfTournament => 'Miglior giocatore del torneo';

  @override
  String get tourSharedGoldenBoot => 'SCARPA D\'ORO';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'GUANTO D\'ORO';

  @override
  String get tourSharedTeamOfTournament => 'SQUADRA DEL TORNEO';

  @override
  String get tourSharedStatsEmpty =>
      'I record compaiono quando la competizione avrà un po\' di storia.';

  @override
  String get tourSharedRecordScorer => 'MARCATORE RECORD';

  @override
  String get tourSharedStillActive => 'ancora in attività';

  @override
  String get tourSharedMostTitles => 'PIÙ TITOLI';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titoli',
      one: '1 titolo',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'PIÙ FINALI';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finali disputate',
      one: '1 finale disputata',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'PIÙ PARTITE GIOCATE';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partite',
      one: '1 partita',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'PIÙ FASI FINALI DISPUTATE';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fasi finali',
      one: '1 fase finale',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'FINALE VINTA CON PIÙ SCARTO';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'ancora in attività';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titoli',
      one: '1 titolo',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finali disputate',
      one: '1 finale disputata',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partite',
      one: '1 partita',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fasi finali',
      one: '1 fase finale',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'LEADER DI SEMPRE';

  @override
  String get tourStatsTabGames => 'Partite';

  @override
  String get tourStatsTabCups => 'Titoli';

  @override
  String get tourStatsTabScorers => 'Marcatori';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'vs $opponent · $year';
  }

  @override
  String get tourHolders => 'DETENTORI';

  @override
  String tourHoldersSince(int year) {
    return 'vinto nel $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'MARCATORI DI SEMPRE';

  @override
  String get tourSharedSummaryEmpty =>
      'Il paese ospitante e i suoi stadi compaiono quando questa edizione viene sorteggiata.';

  @override
  String get tourSharedHostHeading => 'PAESE OSPITANTE';

  @override
  String get tourSharedHostsHeading => 'PAESI OSPITANTI';

  @override
  String get tourSharedCoHostsHeading => 'CO-ORGANIZZATORI';

  @override
  String get tourSharedVenues => 'STADI';

  @override
  String get tourSharedMascot => 'MASCOTTE';

  @override
  String get tourSharedMatchBall => 'PALLONE UFFICIALE';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity posti';
  }

  @override
  String get tourSharedCouldNotLoad => 'Impossibile caricare.';

  @override
  String get tourSharedHostTbc => 'PAESE OSPITANTE DA DEFINIRE';

  @override
  String get tourSharedFinalsAreHere => 'LA FASE FINALE È QUI';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'PAESE OSPITANTE  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Che la fase finale abbia inizio';

  @override
  String get tourSharedCompetitions => 'COMPETIZIONI';

  @override
  String get tourSharedWorldRanking => 'Ranking mondiale';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Impossibile caricare i tornei.';

  @override
  String get tourSharedPrestigeStage => 'PALCOSCENICO DI PRESTIGIO';

  @override
  String get tourSharedOverview => 'Panoramica';

  @override
  String get tourSharedWorldRankingTitle => 'Ranking mondiale';

  @override
  String get tourSharedYourCompetitions => 'LE TUE COMPETIZIONI';

  @override
  String get tourSharedOtherContinents => 'ALTRI CONTINENTI';

  @override
  String get tourSharedComingSoon => 'Torneo in arrivo';

  @override
  String get tourSharedSoon => 'PRESTO';

  @override
  String get tourSharedNoQualifyingDraw =>
      'Nessun sorteggio di qualificazione.';

  @override
  String get tourSharedOpenEnvelope => 'Apri la busta';

  @override
  String tourSharedGroupName(String name) {
    return 'GIRONE $name';
  }

  @override
  String get tourSharedBall => 'Pallina';

  @override
  String get tourSharedPot => 'Fascia';

  @override
  String get tourSharedAll => 'Tutto';

  @override
  String get tourSharedTapDrawTeam => 'Tocca per estrarre la prossima squadra';

  @override
  String get tourSharedTapDrawPot => 'Tocca per estrarre la prossima fascia';

  @override
  String get tourSharedTapDrawAll => 'Tocca per svelare tutto il sorteggio';

  @override
  String get tourSharedContinue => 'Continua';

  @override
  String get tourSharedPause => 'Pausa';

  @override
  String get tourSharedPlay => 'Avvia';

  @override
  String get tourSharedSkip => 'Salta';

  @override
  String tourSharedPotNumber(int number) {
    return 'FASCIA $number';
  }

  @override
  String get tourSharedDrawComplete => 'SORTEGGIO COMPLETATO';

  @override
  String get tourSharedDrawing => 'SORTEGGIO IN CORSO…';

  @override
  String get tourContChampionship => 'CAMPIONATO';

  @override
  String get tourContTabSummary => 'RIEPILOGO';

  @override
  String get tourContTabQualifying => 'QUALIFICAZIONI';

  @override
  String get tourContTabFinals => 'FASE FINALE';

  @override
  String get tourContTabBracket => 'TABELLONE';

  @override
  String get tourContTabAwards => 'PREMI';

  @override
  String get tourContTabScorers => 'MARCATORI';

  @override
  String get tourContTabHistory => 'STORIA';

  @override
  String get tourContTabRecords => 'RECORD';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Impossibile caricare il torneo.\n$error';
  }

  @override
  String get tourContNoCupData => 'Nessun dato sul torneo.';

  @override
  String get tourContUnknown => 'Sconosciuto';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'I gironi di qualificazione vengono sorteggiati alla cerimonia. Guardala dalla home per scoprire chi affronterai.';

  @override
  String get tourContQualSeeded =>
      'La tua nazionale è ammessa direttamente alla fase finale. Niente qualificazioni in questo ciclo.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name viene simulato in background. I risultati compaiono qui man mano che si gioca ogni turno.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'I gironi della fase finale vengono sorteggiati alla cerimonia. Guardala dalla home per scoprire il tuo girone.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Il sorteggio della fase finale si tiene al termine delle qualificazioni.';

  @override
  String get tourContContestedBeforeWc =>
      'La fase a eliminazione diretta si gioca prima del Campionato del mondo.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name: CAMPIONI';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name: vincitori';
  }

  @override
  String get tourContNoGoalsYet => 'Ancora nessun gol segnato.';

  @override
  String tourContGroupHeading(String name) {
    return 'GIRONE $name';
  }

  @override
  String get tourContBestRunnersUp => 'MIGLIORI SECONDE';

  @override
  String tourContGroupDropdown(String name) {
    return 'Girone $name';
  }

  @override
  String get tourContMatches => 'PARTITE';

  @override
  String get tourContNoGroupsDrawn => 'Ancora nessun girone sorteggiato.';

  @override
  String get tourContQualifyingDraw => 'SORTEGGIO DELLE QUALIFICAZIONI';

  @override
  String get tourContWorldQualifyingDraw =>
      'SORTEGGIO QUALIFICAZIONI AL CAMPIONATO DEL MONDO';

  @override
  String get tourContFinalsDraw => 'SORTEGGIO DELLA FASE FINALE';

  @override
  String get tourContSeedingPots => 'FASCE';

  @override
  String get tourContGroupDraw => 'SORTEGGIO DEI GIRONI';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Impossibile caricare il sorteggio.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Il sorteggio non è ancora pronto.';

  @override
  String get tourContContinentalClash => 'SFIDA CONTINENTALE';

  @override
  String get tourContTabThisCycle => 'QUESTO CICLO';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Impossibile caricare.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Salvataggio non trovato.';

  @override
  String get tourContClashSoon =>
      'La Sfida continentale si gioca quando sono noti entrambi i campioni continentali.';

  @override
  String get tourContTwoContinentsOneMatch => 'DUE CONTINENTI, UNA PARTITA';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name vince la Sfida';
  }

  @override
  String get tourContNoClashYet => 'Ancora nessuna Sfida continentale giocata.';

  @override
  String get tourContNationsCup => 'COPPA DELLE NAZIONI';

  @override
  String get tourContTabLeagues => 'LEGHE';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Impossibile caricare.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Ancora nessun gol registrato in Coppa delle Nazioni.';

  @override
  String get tourContNoNationsCupChampions =>
      'Ancora nessun vincitore della Coppa delle Nazioni.';

  @override
  String get tourContNationsCupOffSeason =>
      'La Coppa delle Nazioni di questo ciclo inizia dopo le fasi finali continentali. I vincitori passati sono in Storia.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'I gironi della Coppa delle Nazioni di questo ciclo vengono sorteggiati alla cerimonia. Guardala dalla home per scoprire chi affronterai.';

  @override
  String get tourContLeagueNoGroups =>
      'Nessuna partita in questa lega in questo turno.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LEGA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LEGA $letter · LA TUA LEGA';
  }

  @override
  String get tourContFinalsFourSoon =>
      'La Final Four se la giocano le vincitrici dei gironi della Lega A, a fase a gironi conclusa.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Lega $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Lega $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEMIFINALI';

  @override
  String get tourContFinal => 'FINALE';

  @override
  String get tourContNationsCupDraw => 'SORTEGGIO DELLA COPPA DELLE NAZIONI';

  @override
  String get tourContIntercontinentalPlayoff => 'SPAREGGIO INTERCONTINENTALE';

  @override
  String get tourContNoPlayoffThisCycle => 'Nessuno spareggio in questo ciclo.';

  @override
  String get tourContPlayoffIntro =>
      'Due posti al Campionato del mondo decisi a eliminazione diretta tra le migliori escluse delle qualificazioni.';

  @override
  String get tourContPlayoffThrough =>
      'Hai superato lo spareggio. Sei al Campionato del mondo!';

  @override
  String get tourContPlayoffOut =>
      'Ti sei fermato allo spareggio. Niente Campionato del mondo stavolta.';

  @override
  String get tourContContinue => 'Continua';

  @override
  String get tourContPlayoffFinals => 'FINALI DELLO SPAREGGIO';

  @override
  String get tourContPlayoffSeeded => 'Testa di serie (riposo)';

  @override
  String get tourCupTabSummary => 'RIEPILOGO';

  @override
  String get tourCupTabQualifying => 'QUALIFICAZIONI';

  @override
  String get tourCupTabPlayoff => 'SPAREGGIO';

  @override
  String get tourCupPlayoffSoon =>
      'Lo spareggio intercontinentale si decide quando tutte le confederazioni hanno concluso le qualificazioni.';

  @override
  String get tourCupTabFinals => 'FASE FINALE';

  @override
  String get tourCupTabBracket => 'TABELLONE';

  @override
  String get tourCupTabAwards => 'PREMI';

  @override
  String get tourCupTabScorers => 'MARCATORI';

  @override
  String get tourCupTabHistory => 'STORIA';

  @override
  String get tourCupTabRecords => 'RECORD';

  @override
  String get tourCupTitle => 'CAMPIONATO DEL MONDO';

  @override
  String get tourCupNoData => 'Nessun dato sul torneo.';

  @override
  String tourCupLoadError(String error) {
    return 'Impossibile caricare il torneo.\n$error';
  }

  @override
  String get tourCupUnknown => 'Sconosciuto';

  @override
  String get tourCupWorldChampions => 'CAMPIONI DEL MONDO';

  @override
  String get tourCupWorldChampionsTitle => 'Campioni del mondo';

  @override
  String get tourCupStillActive => 'Ancora in attività';

  @override
  String get tourCupAllTimeScorers => 'MARCATORI DI SEMPRE';

  @override
  String get tourCupAllConfederations => 'Tutte le confederazioni';

  @override
  String get tourCupBestRunnersUp => 'Migliori seconde';

  @override
  String get tourCupCompWorld => 'Campionato del mondo';

  @override
  String get tourCupCompEurope => 'Campionato europeo';

  @override
  String get tourCupCompSAmerica => 'Coppa del Sud America';

  @override
  String get tourCupDestRoundOf16 => 'gli ottavi di finale';

  @override
  String get tourCupDestKnockouts => 'la fase a eliminazione diretta';

  @override
  String get tourCupDestFinals => 'la fase finale';

  @override
  String get tourCupDestFinalsPlayoff => 'lo spareggio per la fase finale';

  @override
  String get tourCupDestIntercontPlayoff => 'lo spareggio intercontinentale';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'La fase finale viene sorteggiata al termine delle qualificazioni.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Gironi da sorteggiare. Guarda il sorteggio del Campionato del mondo dalla home per scoprirli.';

  @override
  String tourCupGroupName(String name) {
    return 'Girone $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Girone $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Paese ospitante: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Paesi ospitanti: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Spareggio intercontinentale';

  @override
  String get tourCupKnockoutSoon =>
      'Il tabellone inizia al termine della fase a gironi.';

  @override
  String get tourCupMatches => 'PARTITE';

  @override
  String get tourCupMedalTable => 'MEDAGLIERE';

  @override
  String get tourCupMostTitles => 'PIÙ TITOLI';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles titoli in $editions edizioni';
  }

  @override
  String get tourCupNoGoals => 'Ancora nessun gol.';

  @override
  String get tourCupNoGroups => 'Nessun girone sorteggiato.';

  @override
  String get tourCupNoHistory => 'Ancora nessuna storia.';

  @override
  String get tourCupPastWinners => 'ALBO D\'ORO';

  @override
  String get tourCupPlayoffIntro =>
      'Due posti al Campionato del mondo decisi a eliminazione diretta tra le migliori escluse delle qualificazioni.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation non gioca lo spareggio: tutti i suoi posti si decidono nei gironi di qualificazione.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Gironi da sorteggiare. Guarda il sorteggio delle qualificazioni dalla home per scoprirli.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · la tua';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (rig.)';
  }

  @override
  String get tourCupSegAllTime => 'Di sempre';

  @override
  String get tourCupSegFinals => 'Fase finale';

  @override
  String get tourCupSegQualifying => 'Qualificazioni';

  @override
  String get playerTraitsTitle => 'CARATTERISTICHE';

  @override
  String get traitBigGame => 'Uomo dei grandi match';

  @override
  String get traitBigGameBlurb =>
      'Alza il livello nelle partite a eliminazione diretta.';

  @override
  String get traitSetPiece => 'Specialista da palla inattiva';

  @override
  String get traitSetPieceBlurb =>
      'Battute migliori e più gol da palla inattiva.';

  @override
  String get traitHothead => 'Testa calda';

  @override
  String get traitHotheadBlurb => 'Prende molti più cartellini dei compagni.';

  @override
  String get traitIronMan => 'Uomo di ferro';

  @override
  String get traitIronManBlurb =>
      'Si fa male di rado e si stanca più lentamente.';

  @override
  String get traitWonderkid => 'Baby fenomeno';

  @override
  String get traitWonderkidBlurb =>
      'Giovane, già bravo e ancora in rapida crescita.';

  @override
  String get traitLeader => 'Leader';

  @override
  String get traitLeaderBlurb => 'Trascina ogni compagno in campo.';

  @override
  String get traitPacey => 'Veloce';

  @override
  String get traitPaceyBlurb =>
      'Velocità bruciante, una minaccia in profondità.';

  @override
  String get traitOldHead => 'Vecchia volpe';

  @override
  String get traitOldHeadBlurb =>
      'Un veterano la cui lettura del gioco sopravvive alle sue gambe.';

  @override
  String get traitWasteful => 'Sprecone';

  @override
  String get traitWastefulBlurb => 'Spreca troppe occasioni buone.';

  @override
  String get objectiveWorldCup => 'Campionato del mondo';

  @override
  String get objectiveWinTournament => 'Vincerlo';

  @override
  String get objectiveQualifyGeneric => 'Qualificarsi';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Vincere il Campionato del mondo';

  @override
  String get objectiveReachFinal => 'Arrivare in finale';

  @override
  String get objectiveReachSemis => 'Arrivare in semifinale';

  @override
  String get objectiveReachQuarters => 'Arrivare ai quarti di finale';

  @override
  String get objectiveReachKnockouts =>
      'Arrivare alla fase a eliminazione diretta';

  @override
  String get objectiveQualify => 'Qualificarsi al Campionato del mondo';

  @override
  String get finishChampions => 'Campioni';

  @override
  String get finishRunnersUp => 'Secondi';

  @override
  String get finishSemiFinals => 'Semifinale';

  @override
  String get finishQuarterFinals => 'Quarti di finale';

  @override
  String get finishRoundOf16 => 'Ottavi di finale';

  @override
  String get finishGroupStage => 'Fase a gironi';

  @override
  String get objectiveQualifyingTopHalf =>
      'Chiudere nella metà alta del girone di qualificazione';

  @override
  String get finishQualifyingTopHalf =>
      'Metà alta del girone di qualificazione';

  @override
  String get finishQualifyingBottomHalf =>
      'Metà bassa del girone di qualificazione';

  @override
  String get objectiveNcWinIt => 'Vincere la Coppa delle Nazioni';

  @override
  String get objectiveNcReachFinal =>
      'Arrivare in finale di Coppa delle Nazioni';

  @override
  String get objectiveNcFinalsFour => 'Arrivare alla Final Four';

  @override
  String get objectiveNcWinGroup => 'Vincere il girone e salire';

  @override
  String get objectiveNcTopHalf => 'Chiudere nella metà alta del girone';

  @override
  String get objectiveNcSurvive => 'Evitare la retrocessione';

  @override
  String get objectiveNcOffTheBottom => 'Non chiudere ultimi nel girone';

  @override
  String get finishNcChampions => 'Vincitori della Coppa delle Nazioni';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Primi nel girone';

  @override
  String get finishNcTopHalf => 'Metà alta del girone';

  @override
  String get finishNcStayedUp => 'Salvezza';

  @override
  String get finishNcClearOfBottom => 'Non ultimi nel girone';

  @override
  String get finishNcBottom => 'Ultimi nel girone';

  @override
  String get careerNationsCupLabel => 'Coppa delle Nazioni';

  @override
  String get squadDevPlayer => 'GIOCATORE';

  @override
  String get squadDevAge => 'ETÀ';

  @override
  String get squadDevPosition => 'RUOLO';

  @override
  String get squadDevChange => 'VALORE';

  @override
  String get squadDevNew => 'NUOVO';

  @override
  String get squadDevRetired => 'RITIRATO';

  @override
  String get squadDevEmpty =>
      'Un anno tranquillo. Nessun cambiamento nella rosa.';

  @override
  String get squadDevTierRegulars => 'TITOLARI';

  @override
  String get squadDevTierFringe => 'RISERVE';

  @override
  String get squadDevTierYouth => 'GIOVANI';

  @override
  String get boardObjectivesTitle => 'Obiettivi della federazione';

  @override
  String get boardObjectivesConfidence => 'Fiducia della federazione';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds turni meglio del richiesto',
      one: 'un turno meglio del richiesto',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'a $rounds turni dall\'obiettivo',
      one: 'a un turno dall\'obiettivo',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'ANCORA DA DECIDERE';

  @override
  String boardObjectiveSoFar(String result) {
    return 'FINORA · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'La federazione non ha fissato un obiettivo per questo ciclo.';

  @override
  String get tourContBestWinners => 'MIGLIORI PRIME DEI GIRONI';

  @override
  String get tourContBestThirds => 'MIGLIORI TERZE';

  @override
  String tourContBestPlaced(String position) {
    return 'MIGLIORI CLASSIFICATE AL $position° POSTO';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total giocatori';
  }

  @override
  String get matchSoldOut => 'TUTTO ESAURITO';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance posti occupati su $capacity';
  }

  @override
  String get matchGroundTitle => 'STADIO';

  @override
  String get absenceInjured => 'Infortunato';

  @override
  String get absenceSuspended => 'Squalificato';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString settimane',
      one: '1 settimana',
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
      other: '$countString partite',
      one: '1 partita',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Rientra contro $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Rigori';

  @override
  String get penaltyOrderBlurb =>
      'Scegli i tuoi cinque rigoristi, in ordine. Tocca una casella per cambiarla.';

  @override
  String penaltyOrderPick(int number) {
    return 'Rigore $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Scegli chi va sul dischetto. La barra indica la freddezza dagli undici metri.';

  @override
  String get penaltyOrderConfirm => 'Si tira';

  @override
  String get penaltyOrderCancel => 'Indietro';

  @override
  String get youthTitle => 'Giovanili';

  @override
  String get youthEmptyLevel => 'Ancora nessuno a questo livello.';

  @override
  String get youthReleased => 'Svincolati quest\'anno';

  @override
  String get u21Title => 'Under 21';

  @override
  String get u21Blurb =>
      'La prossima generazione, a partire dal miglior prospetto. Le stelle vuote sono una stima degli osservatori. Fai esordire un giocatore per scoprire cosa vale davvero.';

  @override
  String get u21Empty =>
      'Nessun under 21 nel bacino in questo momento. I nuovi arrivano con il nuovo ciclo.';

  @override
  String u21Breakout(int gain) {
    return '+$gain QUEST\'ANNO';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Età $age · $caps presenze';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Età $age · mai convocato';
  }

  @override
  String get u21CallUps => 'Vai alle convocazioni';

  @override
  String get youthWatching => 'Osservati';

  @override
  String get youthWatchEmpty =>
      'Ancora nessuno segnato. Segna un ragazzo a qualsiasi livello e comparirà qui, con quello che è diventato nel frattempo.';

  @override
  String get youthWatchMark => 'Segui questo ragazzo';

  @override
  String get youthWatchUnmark => 'Smetti di seguirlo';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Segnato a $rating, a $age anni';
  }

  @override
  String get youthWatchSenior => 'Approdato al bacino della nazionale maggiore';

  @override
  String get youthWatchReleased => 'Svincolato dal vivaio';

  @override
  String get youthWatchGone => 'Non è più nella piramide';

  @override
  String get tacticsYouth => 'Under 21';

  @override
  String get pressSquad => 'Rosa';

  @override
  String get pressBoard => 'Federazione';

  @override
  String get pressNoEffect => 'Nessuno ci dà troppo peso';

  @override
  String get matchNeutralGround => 'CAMPO NEUTRO';

  @override
  String get matchExtraTimeAhead => 'SUPPLEMENTARI';

  @override
  String get matchExtraTimeHalf => 'SUPPLEMENTARI · INTERVALLO';

  @override
  String get matchClockFullTime => 'FINALE';

  @override
  String get matchClockAfterExtraTime => 'DOPO I SUPPLEMENTARI';

  @override
  String get matchClockPenalties => 'RIGORI';

  @override
  String get matchClockFullTimePenalties => 'FINALE · RIGORI';

  @override
  String get hubEventPressConference => 'Affronta la stampa';

  @override
  String get hubEventPressConferenceSub =>
      'I media di tutto il mondo vogliono parlarti prima della prima partita';

  @override
  String get squadDevWonderkid => 'BABY FENOMENO';

  @override
  String get tacticsPlaystyle => 'Stile di gioco';

  @override
  String get tacticsPlaystyleBlurb =>
      'Scegli come gioca la squadra; le regolazioni qui sotto la rifiniscono.';

  @override
  String get tacticsPlaystyleCustom =>
      'Impostazioni tue. Nessuno stile predefinito corrisponde a queste regolazioni.';

  @override
  String get playstyleCustom => 'Personalizzato';

  @override
  String get playstyleBalanced => 'Equilibrato';

  @override
  String get playstylePossession => 'Possesso palla';

  @override
  String get playstyleGegenpress => 'Gegenpressing';

  @override
  String get playstyleCounter => 'Contropiede';

  @override
  String get playstyleDirect => 'Verticale';

  @override
  String get playstyleLowBlock => 'Blocco basso';

  @override
  String get playstyleWingPlay => 'Gioco sulle fasce';

  @override
  String get playstyleBalancedBlurb =>
      'Solida in entrambe le metà campo, senza eccessi.';

  @override
  String get playstylePossessionBlurb =>
      'Tieni palla, falla girare con pazienza, schiaccia l\'avversario.';

  @override
  String get playstyleGegenpressBlurb =>
      'Riconquistala appena persa, alta nel campo.';

  @override
  String get playstyleCounterBlurb =>
      'Aspetta, resta compatta, poi riparti veloce.';

  @override
  String get playstyleDirectBlurb =>
      'Palla avanti presto e gioca sulle seconde palle.';

  @override
  String get playstyleLowBlockBlurb =>
      'Bassa, stretta e durissima da scardinare.';

  @override
  String get playstyleWingPlayBlurb =>
      'Allarga il campo, vai sul fondo e crossa.';

  @override
  String get nationsRandomTeam => 'Squadra casuale';

  @override
  String get nationsFromTheBottom => 'Dal basso';

  @override
  String get bottomStartTitle => 'Disoccupato';

  @override
  String get bottomStartHeading => 'Tre federazioni vogliono parlarti';

  @override
  String get bottomStartBlurb =>
      'Non hai un lavoro né una reputazione. Queste sono le uniche nazionali disposte a scommettere su di te. Scegline una e costruisci qualcosa dal nulla.';

  @override
  String get bottomStartAccept => 'Accetta';

  @override
  String get bottomStartBack => 'Torna al menu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank su $total al mondo';
  }

  @override
  String get campTitle => 'Ritiro';

  @override
  String campBasedIn(String host) {
    return 'Ritiro in $host';
  }

  @override
  String get campBlurb =>
      'Dove vive la rosa per tutto il torneo. Non si può cambiare una volta iniziato, e influisce su tre cose in ogni partita: quanto arrivano freschi, quanto velocemente guarisce una botta e quanto sono brillanti.';

  @override
  String get campEffectTravel => 'Arrivo fresco';

  @override
  String get campEffectRecovery => 'Guarigione infortuni';

  @override
  String get campEffectSharpness => 'Brillantezza';

  @override
  String get campTerrainCity => 'Centro città';

  @override
  String get campTerrainCoastal => 'Località di mare';

  @override
  String get campTerrainMountain => 'Ritiro in montagna';

  @override
  String get campTerrainAltitude => 'Ritiro in altura';

  @override
  String get campTerrainNationalCentre => 'Centro federale';

  @override
  String get campTerrainCityBlurb =>
      'Tutto a portata di mano e nessun viaggio, ma niente pace e nessuna fuga dal rumore.';

  @override
  String get campTerrainCoastalBlurb =>
      'Calmo, comodo e buono per l\'umore; un lungo viaggio in pullman verso ogni stadio.';

  @override
  String get campTerrainMountainBlurb =>
      'Aria fresca e uno staff medico di prim\'ordine che rimette in piedi in fretta, lontano dal torneo.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Duro per allenarsi, ma gambe che reggono fino in fondo al torneo.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Le strutture della federazione: niente di spettacolare, niente che possa andare storto.';

  @override
  String get hubEventChooseCamp => 'Scegli il ritiro';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Dove alloggerà la rosa in $host';
  }

  @override
  String get tacticsTabBench => 'Panchina';

  @override
  String get squadSearchHint => 'Cerca per nome o club';

  @override
  String get squadFilterAll => 'Tutti';

  @override
  String get squadFilterInSquad => 'In rosa';

  @override
  String get squadFilterUncapped => 'Mai convocati';

  @override
  String get squadFilterUnavailable => 'Indisponibili';

  @override
  String get squadLineAll => 'Tutti i reparti';

  @override
  String get squadSortBy => 'Ordina';

  @override
  String get squadSortRating => 'Valore';

  @override
  String get squadSortCaps => 'Presenze';

  @override
  String get squadSortGoals => 'Gol';

  @override
  String get squadSortAge => 'Età';

  @override
  String get squadSortName => 'Nome';

  @override
  String get squadLegendTitle => 'Cosa significano i simboli';

  @override
  String get squadLegendStarting => 'Nel tuo 11 titolare';

  @override
  String get squadLegendCalledUp => 'Convocato, in panchina';

  @override
  String get squadLegendRatingUp => 'Valore in crescita quest\'anno';

  @override
  String get squadLegendRatingDown => 'Valore in calo quest\'anno';

  @override
  String get squadLegendInjured => 'Infortunato, indisponibile';

  @override
  String get squadLegendSuspended => 'Squalificato, indisponibile';

  @override
  String get squadLegendTraits => 'CARATTERISTICHE';

  @override
  String squadShowingOf(int shown, int total) {
    return '$shown di $total giocatori';
  }

  @override
  String get squadNobodyMatches =>
      'Nessuno nel bacino corrisponde a questi filtri.';

  @override
  String get squadStatPool => 'Bacino';

  @override
  String get squadStatInSquad => 'Convocati';

  @override
  String get squadMostCapped => 'Più presenze';

  @override
  String get squadTopScorer => 'Miglior marcatore';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps presenze';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals gol';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Pres.';

  @override
  String get squadGoalsShort => 'Gol';

  @override
  String get recordsRecordBookSubtitle =>
      'Presenze, gol e i principali record della squadra';

  @override
  String get statsLegacy => 'EREDITÀ';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name è già stato sostituito e non può rientrare.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name è stato espulso e non può più giocare.';
  }

  @override
  String get tacticsInjuredShort => 'INFORTUNATO';

  @override
  String get tacticsSuspendedShort => 'SQUALIFICATO';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'Sud America';

  @override
  String get confNorthAmerica => 'Nord America';

  @override
  String get confAfrica => 'Africa';

  @override
  String get confAsia => 'Asia';

  @override
  String get confOceania => 'Oceania';

  @override
  String get compWorldCup => 'Campionato del mondo';

  @override
  String get compWorldCupFinals => 'Fase finale del Campionato del mondo';

  @override
  String get compWorldCupQualifying => 'Qualificazioni al Campionato del mondo';

  @override
  String compQualifiers(String region) {
    return 'Qualificazioni $region';
  }

  @override
  String get compFriendlies => 'Amichevoli';

  @override
  String get compNationsCup => 'Coppa delle Nazioni';

  @override
  String get compContinentalClash => 'Sfida continentale';

  @override
  String get compIntercontinentalPlayoff => 'Spareggio intercontinentale';

  @override
  String get compContinentalChampionship => 'Campionato continentale';

  @override
  String get compEuropeanChampionship => 'Campionato europeo';

  @override
  String get compSouthAmericaCup => 'Coppa del Sud America';

  @override
  String get compAfricanChampionship => 'Campionato africano';

  @override
  String get compAsianChampionship => 'Campionato asiatico';

  @override
  String get compNorthAmericaCup => 'Coppa del Nord America';

  @override
  String get compOceaniaCup => 'Coppa d\'Oceania';

  @override
  String get msgANation => 'Una nazionale';

  @override
  String get msgAPlayer => 'Un giocatore';

  @override
  String get msgAHostNation => 'un paese ospitante';

  @override
  String get msgCycleTitle1 => 'Inizia un nuovo ciclo';

  @override
  String msgCycleTitle2(int year) {
    return 'Si apre la strada verso il $year';
  }

  @override
  String get msgCycleTitle3 => 'Nasce una nuova campagna';

  @override
  String get msgCycleTitle4 => 'Al lavoro';

  @override
  String msgCycleBody1(int year) {
    return 'La strada verso il Campionato del mondo $year parte da qui.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Un nuovo ciclo. L\'obiettivo è il Campionato del mondo $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Quattro anni al Campionato del mondo $year. Il lavoro inizia ora.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'La campagna verso il $year inizia oggi.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup, paese ospitante: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host ospiterà la prossima edizione: $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup: sorteggio delle qualificazioni';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return '$cup: sorteggiati i gironi di qualificazione.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Campionato del mondo $year, paese ospitante: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host ospiterà il Campionato del mondo $year.';
  }

  @override
  String get msgWcQualDrawTitle =>
      'Sorteggio delle qualificazioni al Campionato del mondo';

  @override
  String get msgWcQualDrawBody =>
      'Sorteggiati i gironi di qualificazione al Campionato del mondo.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup: sorteggio della fase finale';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return '$cup: sorteggiati i gironi della fase finale.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Sorteggio della fase finale del Campionato del mondo';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Effettuato il sorteggio della fase finale del Campionato del mondo $year.';
  }

  @override
  String get msgQualWcTitle1 => 'Qualificati al Campionato del mondo';

  @override
  String get msgQualWcTitle2 => 'Campionato del mondo in tasca';

  @override
  String get msgQualWcTitle3 => 'Andiamo al Campionato del mondo';

  @override
  String get msgQualWcTitle4 => 'Biglietto staccato';

  @override
  String msgQualWcBody1(int year) {
    return 'Ti sei qualificato alla fase finale del Campionato del mondo $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'È ufficiale: la tua nazionale sarà al Campionato del mondo $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Un posto al Campionato del mondo $year è assicurato.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Sei qualificato alla fase finale del Campionato del mondo $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Qualificati: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup: in tasca';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Qualificati: $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Ti sei qualificato alla fase finale: $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'La tua nazionale ha conquistato il suo posto: $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Sei qualificato: $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: CAMPIONI!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return '$comp: siamo campioni!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return '$comp: l\'hai vinto!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: verdetto emesso';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: incoronati i campioni';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp: assegnato il titolo';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return '$comp $year: la tua nazionale è campione, battendo $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return '$comp $year: l\'hai vinto, superando $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year: è tuo, contro $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year: vince $winner, battendo $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year: $winner campione, superando $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away in finale';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' ai rigori, dopo il $home–$away della finale';
  }

  @override
  String get msgWpotyTitle => 'Giocatore mondiale dell\'anno';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) è il giocatore mondiale dell\'anno $year, ed è uno dei tuoi.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) è il giocatore mondiale dell\'anno $year.';
  }

  @override
  String get msgYpotTitle => 'Miglior giovane del torneo';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age anni, è il miglior giovane del torneo $year, ed è uno dei tuoi.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age anni, è il miglior giovane del torneo $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Resti al #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Nessun cambiamento, sempre #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabile al #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posizioni',
      one: '1 posizione',
    );
    return 'Su di $_temp0 in tutto, al #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posizioni',
      one: '1 posizione',
    );
    return 'Una risalita di $_temp0 ti porta al #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posizioni',
      one: '1 posizione',
    );
    return 'Su di $_temp0, ora #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posizioni',
      one: '1 posizione',
    );
    return 'Giù di $_temp0 in tutto, al #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posizioni',
      one: '1 posizione',
    );
    return 'Una discesa di $_temp0 ti porta al #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move posizioni',
      one: '1 posizione',
    );
    return 'Giù di $_temp0, ora #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Sei in vetta al mondo.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation è in vetta al mondo.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Ranking mondiale · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Il ranking mondiale è stato aggiornato. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Risalita al #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Discesa al #$rank';
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
      other: '$move posizioni',
      one: '1 posizione',
    );
    return '$tournament ha mosso il ranking mondiale. $nation: dal #$from al #$to, una risalita di $_temp0.';
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
      other: '$move posizioni',
      one: '1 posizione',
    );
    return '$tournament ha mosso il ranking mondiale. $nation: dal #$from al #$to, una discesa di $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Dal sorteggio del Campionato del mondo';

  @override
  String get rankingSinceCycleStart => 'Dall\'inizio della campagna';

  @override
  String rankingMovedFromTo(int from, int now) {
    return 'Da #$from a #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name raggiunge $count presenze';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name ha ora $count presenze con la tua nazionale.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name raggiunge $count gol';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name ha segnato $count gol in nazionale per te.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Sviluppo della rosa · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Promossi dal vivaio · $year';
  }

  @override
  String get msgThroughNote =>
      'Non sono nuovi arrivi. Sono i ragazzi entrati a undici anni e ora cresciuti fino al bacino della nazionale maggiore.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Volti nuovi · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'L\'investimento nel vivaio si vede: questa leva è arrivata più forte di quanto sarebbe stata.';

  @override
  String get msgIntakeNoteStanding =>
      'Il paese segue questa squadra: con la nazionale che risale il ranking, i ragazzi migliori scelgono il calcio, e questa leva è arrivata più forte.';

  @override
  String get msgIntakeNoteBoth =>
      'Si vedono sia i soldi nel vivaio sia la risalita nel ranking: questa leva è arrivata più forte di quanto sarebbe stata.';

  @override
  String msgIntakeTitle(int year) {
    return 'Nuova leva del vivaio · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Il tuo capitano $name si ritira';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name lascia la nazionale';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name ha lasciato la nazionale a $age anni.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name ha lasciato la nazionale a $age anni, chiudendo con $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count presenze',
      one: '1 presenza',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gol',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' La fascia è libera. Scegli un nuovo capitano dalla schermata delle convocazioni.';

  @override
  String msgHofTitle(String name) {
    return '$name entra nella Hall of Fame';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name entra nella Hall of Fame della tua nazionale ($caps presenze, $goals gol). Lo trovi in Leggende.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name squalificato';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'le prossime $matches partite',
      one: 'la prossima partita',
    );
    return '$name $how e salterà $_temp0. Non sarà convocabile.';
  }

  @override
  String get hubBanHowSecondYellow => 'è stato espulso per doppia ammonizione';

  @override
  String get hubBanHowViolent =>
      'ha preso un rosso diretto per condotta violenta';

  @override
  String get hubBanHowRed => 'è stato espulso';

  @override
  String hubInjuryTitle(String name) {
    return '$name infortunato';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches partite',
      one: '1 partita',
    );
    return '$name ha preso una botta e starà fuori per $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Secondi';

  @override
  String get hubRunnerUpTitle2 => 'Così vicini, così lontani';

  @override
  String get hubRunnerUpTitle3 => 'Medaglia d\'argento';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return '$cup: sei arrivato in finale ma hai perso contro $opponent. Così vicino. Argento stavolta.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return '$cup: battuto in finale da $opponent. Secondo posto, a un soffio.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return '$cup: la finale ti è sfuggita contro $opponent. Tanto di cui essere orgogliosi, ma non il trofeo.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Eliminati';

  @override
  String get hubKnockedOutTitle2 => 'Fine della corsa';

  @override
  String get hubKnockedOutTitle3 => 'Il viaggio è finito';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return '$cup: sei fuori, battuto da $opponent ($stage).';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$cup: $opponent ti elimina ($stage).';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup: la tua corsa finisce qui ($stage), battuto da $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Fuori ai gironi';

  @override
  String get hubGroupExitTitle2 => 'Eliminati nella fase a gironi';

  @override
  String get hubGroupExitTitle3 => 'Tutti a casa presto';

  @override
  String hubGroupExitBody1(String cup) {
    return '$cup: finisce nella fase a gironi. Non abbastanza per la fase a eliminazione diretta.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Non hai passato il girone. $cup: finisce qui.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Niente fase a eliminazione diretta stavolta. $cup: fuori ai gironi.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Obiettivo raggiunto: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Obiettivo mancato: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'L\'obiettivo della federazione per $comp: $demand. Hai chiuso: $finish. Hanno ottenuto ciò che chiedevano.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'L\'obiettivo della federazione per $comp: $demand. Hai chiuso: $finish. Meno di quanto ci si aspettava.';
  }

  @override
  String get newsWcMissTitle => 'Sogno Campionato del mondo finito';

  @override
  String newsWcMissBody(int year) {
    return 'Non sei al Campionato del mondo $year. Le qualificazioni sono andate male. Altri quattro anni.';
  }

  @override
  String get newsRecordScorerTitle => 'Miglior marcatore di sempre';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name è ora il miglior marcatore di sempre con $goals gol.';
  }

  @override
  String get newsRecordCapsTitle => 'Recordman di presenze';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name è ora il giocatore con più presenze di sempre: $caps.';
  }

  @override
  String get newsARecordBreaker => 'Un nuovo recordman';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name passa a $club';
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
    return '$name ($position, $rating) ha lasciato $fromClub per firmare con $destination per $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Parametro zero';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name giocherebbe per $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name vuole giocare per $nation';
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
    return '$name, $position di $age anni con valore $rating, ora con $fromNation, ha legami familiari con $nation ed è disposto a cambiare. Apri l\'offerta di naturalizzazione per accettare o rifiutare.';
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
    return '$name, $position di $age anni con valore $rating, ora con $fromNation, è una stella con legami familiari con $nation ed è disposto a cambiare. Apri l\'offerta di naturalizzazione per accettare o rifiutare.';
  }

  @override
  String get newsTheirNation => 'la sua nazionale';

  @override
  String get newsYourNation => 'la tua nazionale';

  @override
  String get tourStatusChampions => 'CAMPIONI';

  @override
  String get tourStatusFinals => 'FASE FINALE';

  @override
  String get tourStatusQualifying => 'QUALIFICAZIONI';

  @override
  String get tourStatusUpcoming => 'IN ARRIVO';

  @override
  String get tourStatusInProgress => 'IN CORSO';

  @override
  String get tourStatusComingSoon => 'PRESTO';

  @override
  String get tourStatusDecided => 'CONCLUSO';

  @override
  String tourStatusLeague(String letter) {
    return 'LEGA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'SORTEGGIO QUALIFICAZIONI';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup: SORTEGGIO QUALIFICAZIONI';
  }

  @override
  String get tourDrawWcHost => 'PAESE OSPITANTE DEL CAMPIONATO DEL MONDO';

  @override
  String tourDrawContHost(String cup) {
    return '$cup: PAESE OSPITANTE';
  }

  @override
  String get tourDrawHostsReveal => 'E i paesi ospitanti saranno…';

  @override
  String get tourDrawHostReveal => 'E il paese ospitante sarà…';

  @override
  String get tourDrawHostCandidates => 'Le candidate in corsa:';

  @override
  String get tourKickoffContinentalCup => 'COPPA CONTINENTALE';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup: mancata';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Non ti sei qualificato: $cup. Stavolta la campagna non è bastata.';
  }

  @override
  String get potyLabelBest => 'Giocatore dell\'anno';

  @override
  String get potyLabelYoung => 'Giovane dell\'anno';

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
    return 'Valore $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Voto $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Giocatore mondiale dell\'anno $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name è il miglior giocatore del mondo quest\'anno.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name vince il premio di miglior giovane.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'I ragazzi che stai seguendo, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain punti',
      one: 'un punto',
    );
    return '$name è salito a $rating, $_temp0 in più dell\'anno scorso.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name sale nella fascia dei $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name esordisce';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name ha fatto il suo esordio a $age anni, con valore $rating. Uno dei ragazzi che stai seguendo.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Possesso, voti e migliore in campo si decidono al fischio finale.';

  @override
  String get matchPlayerRatings => 'PAGELLE';

  @override
  String get matchSubstitutions => 'SOSTITUZIONI';

  @override
  String get matchSubstitutes => 'PANCHINA';

  @override
  String get matchPlayerOfTheMatch => 'MIGLIORE IN CAMPO';

  @override
  String get matchGoalShout => 'GOL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'RIGORI $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: SEGNATO';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: SBAGLIATO';
  }

  @override
  String get matchFeedKickOff => 'Calcio d\'inizio!';

  @override
  String get matchFeedNoEvents => 'Ancora nessun evento.';

  @override
  String get tourVenues => 'STADI';

  @override
  String tourPot(int number) {
    return 'FASCIA $number';
  }

  @override
  String get tourHostSelection => 'SCELTA DEL PAESE OSPITANTE';

  @override
  String get tourCandidates => 'CANDIDATE';

  @override
  String get tourJointBid => 'CANDIDATURA CONGIUNTA';

  @override
  String get tourGoldenGlove => 'GUANTO D\'ORO';

  @override
  String get tourTeamOfTournament => 'SQUADRA DEL TORNEO';

  @override
  String get tourYourRun => 'IL TUO CAMMINO';

  @override
  String get tourMedalTable => 'MEDAGLIERE';

  @override
  String tourHostLine(String nation) {
    return 'Paese ospitante: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Paesi ospitanti: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Girone $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Teste di serie in base al ranking mondiale. Trova la tua nazionale prima del sorteggio.';

  @override
  String get tourWorldRanking => 'Ranking mondiale';

  @override
  String get tourYourCompetitions => 'LE TUE COMPETIZIONI';

  @override
  String get tourOtherContinents => 'ALTRI CONTINENTI';

  @override
  String get tourZoneGlobal => 'GLOBALE';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'SUD AMERICA';

  @override
  String get tourZoneNorthAmerica => 'NORD AMERICA';

  @override
  String get tourZoneAfrica => 'AFRICA';

  @override
  String get tourZoneAsia => 'ASIA';

  @override
  String get tourZoneOceania => 'OCEANIA';

  @override
  String get tourZoneIntercontinental => 'INTERCONTINENTALE';

  @override
  String tourZoneLeague(String league) {
    return 'LEGA $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'PAESE OSPITANTE  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Le prime $count passano: $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name se ne va';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name ha lasciato la nazionale a $age anni, con $caps presenze. Aveva chiesto di sapere a che punto fosse, non ha avuto risposta, e non aspetta più.';
  }

  @override
  String get pressHeadlineWent1 => 'Un CT padrone della sala';

  @override
  String get pressHeadlineWent2 =>
      'Cercavano la polemica, hanno trovato un leader';

  @override
  String get pressHeadlineWent3 =>
      'Risposte dirette, e hanno colpito nel segno';

  @override
  String get pressHeadlineMixed1 => 'Tante parole, poco di concreto';

  @override
  String get pressHeadlineMixed2 => 'Qualcosa per tutti, niente per nessuno';

  @override
  String get pressHeadlineMixed3 =>
      'Una conferenza che ha lasciato aperte le domande';

  @override
  String get pressHeadlineBadly1 =>
      'Un pomeriggio difficile davanti alle telecamere';

  @override
  String get pressHeadlineBadly2 => 'La sala si è rivoltata, e si è visto';

  @override
  String get pressHeadlineBadly3 => 'Risposte che domattina suoneranno peggio';

  @override
  String get pressHeadlineFlat1 => 'Niente detto, niente guadagnato';

  @override
  String get pressHeadlineFlat2 => 'Dieci minuti, nessuna notizia';

  @override
  String get pressHeadlineFlat3 => 'Una pagina bianca per i giornali di domani';

  @override
  String get pressConferenceTitle => 'CONFERENZA STAMPA';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Domanda $index di $total';
  }

  @override
  String get pressTomorrowsHeadline => 'IL TITOLO DI DOMANI';

  @override
  String get pressLeaveRoom => 'LASCIA LA SALA';

  @override
  String get pressRoomVerdictSquad => 'Spogliatoio';

  @override
  String get pressRoomVerdictBoard => 'Federazione';

  @override
  String get yReactionElation0 => 'niente da dire. niente. perfetto.';

  @override
  String get yReactionElation1 => 'Sto male (in senso buono).';

  @override
  String get yReactionElation2 => 'me la incornicio. sopra il camino.';

  @override
  String get yReactionElation3 => 'siamo tornati';

  @override
  String get yReactionElation4 => 'Screenshot per chi dubitava. Tutti quanti.';

  @override
  String get yReactionElation5 =>
      'Sarò insopportabile su questa cosa per dieci anni.';

  @override
  String get yReactionElation6 => 'Ecco. È per questo che guardiamo.';

  @override
  String get yReactionElation7 => 'Giornate così ripagano tutte le altre.';

  @override
  String get yReactionElation8 => 'Era ora. Davvero, era ora.';

  @override
  String get yReactionElation9 =>
      'Bene. Ora rifatelo la settimana prossima e ci crederò.';

  @override
  String get yReactionElation10 =>
      'Godetevi stasera, perché questi troveranno il modo di rovinare tutto.';

  @override
  String get yReactionElation11 =>
      'Una bella serata non fa di nessuno una grande squadra.';

  @override
  String get yReactionRelief0 => 'Non bella, ma la prendo sempre e comunque.';

  @override
  String get yReactionRelief1 => 'Non so come. Non so come!';

  @override
  String get yReactionRelief2 => 'Brutta. Tre punti. Avanti.';

  @override
  String get yReactionRelief3 => 'Brutta tutti i giorni, se porta punti.';

  @override
  String get yReactionRelief4 => 'mi ha tolto dieci anni di vita';

  @override
  String get yReactionRelief5 => 'Nessuno parli. Nessuno porti sfiga.';

  @override
  String get yReactionRelief6 => 'Battito cardiaco: inaccettabile.';

  @override
  String get yReactionRelief7 =>
      'Sopravvissuti. È questa la parola. Sopravvissuti.';

  @override
  String get yReactionRelief8 =>
      'Non dovremmo sentirci sollevati per partite così.';

  @override
  String get yReactionRelief9 => 'Sollevato, e un po\' imbarazzato di esserlo.';

  @override
  String get yReactionRelief10 =>
      'Se questo è il livello che applaudiamo, siamo nei guai.';

  @override
  String get yReactionRelief11 =>
      'Passare per il rotto della cuffia è un\'abitudine, e non è buona.';

  @override
  String get yReactionFury0 => 'Non basta. Neanche lontanamente.';

  @override
  String get yReactionFury1 => 'Qualcuno me lo spieghi piano piano.';

  @override
  String get yReactionFury2 => 'Difficile da guardare, e sono gentile.';

  @override
  String get yReactionFury3 => 'Deluso. Sinceramente deluso.';

  @override
  String get yReactionFury4 => 'Ma guarda in che stato siamo.';

  @override
  String get yReactionFury5 => 'Voglio i nomi.';

  @override
  String get yReactionFury6 => 'Disinstallo l\'app. La reinstallo giovedì.';

  @override
  String get yReactionFury7 => 'Là fuori nessuno sembrava averne voglia.';

  @override
  String get yReactionFury8 =>
      'Ogni quattro anni, sempre uguale. OGNI quattro anni.';

  @override
  String get yReactionFury9 => 'Questa non è una prestazione, è un insulto.';

  @override
  String get yReactionFury10 =>
      'La gente rinuncia a weekend e soldi per questo. Pensateci.';

  @override
  String get yReactionFury11 =>
      'Ho difeso questa squadra per anni. Non stasera. Non dopo questo.';

  @override
  String get yReactionDespair0 => 'vabbè.';

  @override
  String get yReactionDespair1 => 'Niente battute oggi. Niente.';

  @override
  String get yReactionDespair2 => 'Vado a fare una passeggiata. Lunga.';

  @override
  String get yReactionDespair3 => 'Ho finito i modi per dirlo.';

  @override
  String get yReactionDespair4 => 'Svegliatemi tra quattro anni.';

  @override
  String get yReactionDespair5 => 'questa è la linea temporale peggiore';

  @override
  String get yReactionDespair6 =>
      'Non sono più neanche arrabbiato. È questo che preoccupa.';

  @override
  String get yReactionDespair7 => 'Questa brucerà a lungo.';

  @override
  String get yReactionDespair8 =>
      'Non so più cosa sia questa, ma non è una squadra di calcio.';

  @override
  String get yReactionDespair9 =>
      'Siamo più lontani di prima, e nessuno lo dirà.';

  @override
  String get yReactionDespair10 =>
      'Un\'intera generazione sprecata e a decidere il futuro sono sempre gli stessi.';

  @override
  String get yReactionDespair11 =>
      'Smettetela di dirmi che è un percorso. Non sta andando da nessuna parte.';

  @override
  String get yReactionSmugness0 => 'Sottovoce, ma: ve l\'avevo detto.';

  @override
  String get yReactionSmugness1 => 'salvatevi questo post';

  @override
  String get yReactionSmugness2 => 'Chi dubitava si è fatto molto silenzioso.';

  @override
  String get yReactionSmugness3 =>
      'Non che qualcuno tenga il conto. Io lo tengo.';

  @override
  String get yReactionSmugness4 => 'L\'avevo detto a gennaio. Controllate.';

  @override
  String get yReactionSmugness5 =>
      'Alcuni di voi devono delle scuse ad alcuni di noi.';

  @override
  String get yReactionSmugness6 =>
      'Archivio sotto: cose che ho detto per primo.';

  @override
  String get yReactionSmugness7 => 'Niente gongolare. Solo un pochino.';

  @override
  String get yReactionSmugness8 =>
      'Dove sono finiti tutti gli esperti? Domanda sincera.';

  @override
  String get yReactionSmugness9 => 'Vorrei che ognuno di voi me lo ripetesse.';

  @override
  String get yReactionSmugness10 =>
      'Screenshot, stampato, incorniciato, spedito a chi rideva.';

  @override
  String get yReactionSmugness11 =>
      'Ve lo rinfaccerò per il resto della mia vita e ve lo siete meritati.';

  @override
  String get yReactionShrug0 => 'è successo. avanti.';

  @override
  String get yReactionShrug1 => 'Va bene. Fa niente. Avanti.';

  @override
  String get yReactionShrug2 => 'Archivio questa sotto \'calcio\'.';

  @override
  String get yReactionShrug3 => 'Davvero niente da aggiungere.';

  @override
  String get yReactionShrug4 => 'nessun pensiero, testa vuota';

  @override
  String get yReactionShrug5 => 'Svegliatemi per la prossima.';

  @override
  String get yReactionShrug6 => 'Novanta minuti che non mi ridarà nessuno.';

  @override
  String get yReactionShrug7 => 'Né carne né pesce, davvero.';

  @override
  String get yReactionShrug8 => 'Non saprei dirvi una sola cosa successa.';

  @override
  String get yReactionShrug9 => 'Un\'altra di quelle. Ce ne sono tante.';

  @override
  String get yReactionShrug10 =>
      'L\'ho guardata tutta e non ho provato niente.';

  @override
  String get yReactionShrug11 => 'Se nessuno ne parla più, a me va benissimo.';

  @override
  String get tourThirdsUneven =>
      'I gironi sono di dimensioni diverse, quindi i risultati contro l\'ultima di ogni girone più grande vengono scartati e ogni squadra è giudicata sullo stesso numero di partite.';

  @override
  String get careerExportSave => 'Backup del salvataggio';

  @override
  String get careerBackupAll => 'BACKUP DI TUTTI I SALVATAGGI';

  @override
  String get careerBackupAllFailed => 'Impossibile scrivere il backup.';

  @override
  String get backupTitle => 'BACKUP';

  @override
  String get backupBlurb =>
      'Tutti i salvataggi stanno in un solo file su questo telefono e niente li copia da solo, a meno che tu non attivi qui sotto il backup automatico. Tieni una copia nel cloud, così un telefono perso o un\'app eliminata non ti costano una carriera.';

  @override
  String get backupBlurbNoAuto =>
      'Tutti i salvataggi stanno in un solo file su questo telefono e niente li copia da solo. Tieni una copia nel cloud, così un telefono perso o un\'app eliminata non ti costano una carriera.';

  @override
  String get backupExport => 'BACKUP NEL CLOUD';

  @override
  String get backupExportSubject => 'Salvataggi FNM';

  @override
  String get backupRestore => 'RIPRISTINA DA FILE';

  @override
  String get backupRestoreWarnTitle => 'Sostituire tutti i salvataggi?';

  @override
  String get backupRestoreWarnBody =>
      'Il ripristino sostituisce tutti i salvataggi su questo telefono con quelli del file. L\'app si riavvierà.';

  @override
  String get backupRestoreConfirm => 'SOSTITUISCI';

  @override
  String get backupCancel => 'ANNULLA';

  @override
  String get backupExported => 'Backup pronto. Scegli dove conservarlo.';

  @override
  String get backupFailed => 'Impossibile scrivere il backup.';

  @override
  String get backupRejectedUnreadable => 'Impossibile aprire quel file.';

  @override
  String get backupRejectedNotFnm => 'Non è un salvataggio di FNM.';

  @override
  String get backupRejectedNewer =>
      'Quel salvataggio è stato creato da una versione più recente dell\'app. Aggiorna prima.';

  @override
  String get backupRejectedTooOld =>
      'Quel salvataggio è troppo vecchio per essere ripristinato da questa versione.';

  @override
  String get careerShare => 'Condividi questa carriera';

  @override
  String get careerImport => 'IMPORTA UNA CARRIERA';

  @override
  String get careerShareSubject => 'Una carriera FNM';

  @override
  String get careerImported => 'Carriera importata.';

  @override
  String get careerImportFailedUnreadable =>
      'Quel file non è una carriera FNM.';

  @override
  String get careerImportFailedNewer =>
      'Quella carriera è stata esportata da una versione più recente dell\'app. Aggiorna prima.';

  @override
  String get careerImportFailedSlotsFull =>
      'Tutti gli slot di salvataggio sono occupati. Elimina un salvataggio o sblocca i salvataggi illimitati.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Quella carriera ha già superato il primo ciclo gratuito. Sblocca il gioco completo per importarla.';

  @override
  String get careerImportFailedCampaignRun =>
      'Questa campagna ha già una partita in corso. Riprendila o abbandonala prima.';

  @override
  String get careerShareFailed => 'Impossibile esportare quella carriera.';

  @override
  String get managerRename => 'Cambia nome';

  @override
  String get managerRenameSave => 'Salva';

  @override
  String get managerTitle => 'CT';

  @override
  String get managerSkills => 'LE TUE ABILITÀ';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punti da spendere',
      one: '1 punto da spendere',
      zero: 'Nessun punto da spendere',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Due punti per ogni ciclo completato, uno per ogni trofeo vinto.';

  @override
  String get managerSkillsScale =>
      'Ogni abilità parte da 5 e arriva a 20. Un punto speso è permanente.';

  @override
  String get managerSkillManManagement => 'Gestione del gruppo';

  @override
  String get managerSkillManManagementBlurb =>
      'Ogni punto fa arrivare del 3% più forte allo spogliatoio ciò che dici alla stampa e ai giocatori.';

  @override
  String get managerSkillTactical => 'Tattica';

  @override
  String get managerSkillTacticalBlurb =>
      'Ogni punto fa assimilare un nuovo modulo il 3% più in fretta, così cambiare assetto ti costa meno partite.';

  @override
  String get managerSkillYouth => 'Sviluppo giovani';

  @override
  String get managerSkillYouthBlurb =>
      'Ogni punto aggiunge l\'1% al talento che esce dal tuo vivaio, oltre a quanto ci investi.';

  @override
  String get managerSkillNegotiation => 'Negoziazione';

  @override
  String get managerSkillNegotiationBlurb =>
      'Ogni punto vale il 2% di soldi in più dalla federazione, a ogni ciclo.';

  @override
  String get managerStaff => 'IL TUO STAFF';

  @override
  String managerStaffWages(String amount) {
    return 'Stipendi: $amount per ciclo';
  }

  @override
  String get managerRoleAssistant => 'Vice allenatore';

  @override
  String get managerRoleAssistantBlurb =>
      'Guida gli allenamenti: meno infortuni e giovani migliori in arrivo.';

  @override
  String get managerRoleScout => 'Capo osservatore';

  @override
  String get managerRoleScoutBlurb =>
      'Studia i tuoi prospetti e il prossimo avversario: stelle più accurate e un vantaggio nel giorno della partita.';

  @override
  String get managerRoleFitness => 'Preparatore atletico';

  @override
  String get managerRoleFitnessBlurb => 'Li tiene in campo.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% di infortuni in meno';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Giovani +$points di valore';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Assumendone uno: dal $min% al $max% di infortuni in meno';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'e giovani da +$minPoints a +$maxPoints di valore';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Valuta esattamente il $percent% dei prospetti';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potenziale noto dopo $caps presenze',
      one: 'Potenziale noto dopo 1 presenza',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points di valore dai dossier sugli avversari';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Assumendone uno: dal $min% al $max% di valutazioni esatte';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'e potenziale noto da $minCaps a $maxCaps presenze prima';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'e da +$minPoints a +$maxPoints di valore in ogni partita';
  }

  @override
  String get staffEffectNone => 'Ancora nessun effetto sulla rosa';

  @override
  String get staffVacant => 'Posto vacante';

  @override
  String get staffLeaveVacant => 'Lascia il posto vacante';

  @override
  String get managerTierNone => 'Nessuno';

  @override
  String get managerTierBasic => 'Base';

  @override
  String get managerTierGood => 'Buono';

  @override
  String get managerTierElite => 'Élite';

  @override
  String get managerFree => 'gratis';

  @override
  String get managerTraining => 'TRA UNA FINESTRA E L\'ALTRA';

  @override
  String get managerTrainingBlurb =>
      'Su cosa lavora la rosa quando non ci sono partite.';

  @override
  String get managerFocusBalanced => 'Equilibrato';

  @override
  String get managerFocusBalancedBlurb => 'Un po\' di tutto.';

  @override
  String get managerFocusFitness => 'Condizione';

  @override
  String get managerFocusFitnessBlurb => 'Meno acciacchi.';

  @override
  String get managerFocusCohesion => 'Intesa';

  @override
  String get managerFocusCohesionBlurb =>
      'L\'assetto si assimila più in fretta.';

  @override
  String get managerFocusYouth => 'Giovani';

  @override
  String get managerFocusYouthBlurb => 'Ore con i più giovani del bacino.';

  @override
  String get tourOfferTitle => 'Prima volta qui?';

  @override
  String get tourOfferBody =>
      'È un gioco grande. Vuoi un giro veloce tra le schermate che contano? Ci vuole un minuto, e puoi ripeterlo quando vuoi dalle Impostazioni.';

  @override
  String get tourOfferYes => 'Fammi fare un giro';

  @override
  String get tourOfferNo => 'No, grazie';

  @override
  String get tourBack => 'Indietro';

  @override
  String get tourNext => 'Avanti';

  @override
  String get tourDone => 'Fatto';

  @override
  String get tourSkip => 'Salta';

  @override
  String get tourHubTitle => 'Questo è tutto il gioco';

  @override
  String get tourHubBody =>
      'Un solo pulsante, che cambia man mano che il ciclo avanza: un sorteggio da guardare, una rosa da convocare, una partita da giocare. Sopra ci sono la fiducia della federazione in te e gli obiettivi che ti ha fissato.';

  @override
  String get tourBudgetTitle => 'I soldi della federazione';

  @override
  String get tourBudgetBody =>
      'Una volta per ogni ciclo di quattro anni dividi il tesoretto tra i reparti. Il tuo staff viene pagato per primo, quindi assumere un osservatore d\'élite è una scelta che fai a scapito del vivaio, non in aggiunta.';

  @override
  String get tourTacticsTitle => 'Come gioca la squadra';

  @override
  String get tourTacticsBody =>
      'Il modulo, lo stile di gioco, il capitano e chi batte le palle inattive. Se lasci vuoti gli ultimi due, il gioco ti avvisa prima del calcio d\'inizio invece di scegliere al posto tuo in silenzio.';

  @override
  String get tourSquadTitle => 'Tutti quelli che puoi scegliere';

  @override
  String get tourSquadBody =>
      'Tutto il bacino, non solo la rosa: chi è in forma, chi ha un acciacco, chi è squalificato e chi è appena uscito dal vivaio.';

  @override
  String get tourCallUpsTitle => 'Convocare una rosa';

  @override
  String get tourCallUpsBody =>
      'Convochi una rosa per ogni finestra internazionale e gioca tutte le partite di quella finestra, esattamente come un vero CT. Un infortunio durante la finestra porta un sostituto al posto tuo.';

  @override
  String get tourRecordsTitle => 'La tua carriera';

  @override
  String get tourRecordsBody =>
      'Tutto quello che hai fatto: le partite, i record di squadra, i trofei e ogni nazionale che hai guidato.';

  @override
  String get tourCupsTitle => 'Il resto del mondo';

  @override
  String get tourCupsBody =>
      'Tutte le competizioni in corso: gironi, classifiche e fasi a eliminazione, comprese quelle in cui non ci sei. Il mondo continua a giocare che tu sia qualificato o no.';

  @override
  String get settingsTourTitle => 'Rivedi il tutorial';

  @override
  String get settingsTourBlurb =>
      'Ripercorri le schermate principali dall\'inizio.';

  @override
  String get tourBoardTitle => 'A chi rispondi';

  @override
  String get tourBoardBody =>
      'La fiducia della federazione in te e gli obiettivi fissati per questo ciclo. Se manchi il mandato, è qui che lo vedrai arrivare.';

  @override
  String get tourStaffTitle => 'Le persone intorno a te';

  @override
  String get tourStaffBody =>
      'Un vice, un osservatore e un preparatore atletico, assunti per nome. I loro stipendi escono da questo budget prima dei reparti, quindi un grande osservatore è una scelta a scapito del vivaio.';

  @override
  String get tourPlaystyleTitle => 'Il tuo modo di giocare';

  @override
  String get tourPlaystyleBody =>
      'Il modulo è solo metà di una tattica. Questa è l\'altra metà: quanto alto pressi, quanto sei verticale, quanto rischi.';

  @override
  String get settingsTourNoSave =>
      'Prima inizia una carriera. Il giro visita le tue schermate.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Fuori ruolo · Età $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Il budget del prossimo ciclo si fissa all\'inizio di quel ciclo, in una volta sola. Fino ad allora, ecco cosa stanno facendo i tuoi soldi.';

  @override
  String get federationBudgetAlreadySet => 'Già fissato per questo ciclo';

  @override
  String yFinalLooms0(String opponent) {
    return 'In finale c\'è $opponent. Per tutta la settimana non si parlerà d\'altro.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Confermato: tra noi e il trofeo c\'è $opponent. Quattro anni per questo.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Bene. $opponent. Nessuno dorme finché non è finita.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Ora $opponent, e tutto il resto può aspettare. Che settimana.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Lascia scegliere i tiratori allo staff';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Segnate qui sotto: squadre che giocano come $rivals, le avversarie dei tuoi gironi in questo ciclo.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Calciomercato · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Ultima volta $when fa';
  }

  @override
  String get settingsFreeScopeTitle => 'Un ciclo di quattro anni gratis';

  @override
  String get settingsFreeScopeBlurb =>
      'Un ciclo completo (qualificazioni, campionato continentale e Campionato del mondo) su due salvataggi, con tutte le nazionali del mondo, senza limitazioni. Cicli infiniti e salvataggi illimitati costano un unico pagamento, una volta sola, che copre tutti gli aggiornamenti futuri.';

  @override
  String get settingsUnlockedTitle => 'Sbloccato';

  @override
  String get settingsUnlockedBlurb =>
      'Cicli infiniti, salvataggi illimitati e tutti gli aggiornamenti futuri. Grazie.';

  @override
  String get settingsFromDeveloperTitle => 'Dallo sviluppatore';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager è realizzato da una sola persona e sarà supportato a lungo termine. Non ci saranno mai pubblicità né microtransazioni. Se il gioco ti piace, valuta di acquistare la versione completa. È ciò che fa arrivare gli aggiornamenti.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager è realizzato da una sola persona e sarà supportato a lungo termine. Non ci saranno mai pubblicità né microtransazioni. Grazie per aver acquistato la versione completa. È ciò che fa arrivare gli aggiornamenti.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Segnate qui sotto: squadre che giocano come $rivals, che devi ancora affrontare.';
  }

  @override
  String get friendliesCloseToYou =>
      'Segnate qui sotto: le squadre più vicine a te nel ranking mondiale. Dopo il sorteggio, i segni seguono il tuo girone.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trasferimenti',
      one: '1 trasferimento',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Più recenti';

  @override
  String get transfersOlder => 'Altri';

  @override
  String get transfersPagePrevious => 'Precedente';

  @override
  String get transfersPageNext => 'Successiva';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Pagina $page di $pages';
  }

  @override
  String get transfersMovedTo => 'Passato a';

  @override
  String get transfersUnknownClub => 'Club sconosciuto';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Fanno $count volte contro $opponent ormai. Qualcuno tiene il conto, e sono loro.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Di nuovo $opponent. $count precedenti, e ancora non li abbiamo capiti.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Sfida numero $count contro $opponent. Non è più una coincidenza.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Abbiamo giocato contro $opponent $count volte e non abbiamo imparato niente da nessuna.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count volte. Sanno esattamente cosa faremo.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Qualunque cosa abbia $opponent contro di noi, dopo $count sfide ce l\'ha ancora.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'È la $countª volta che succede ultimamente. Quand\'è che diventa semplicemente quello che siamo?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count pomeriggi così ormai. È uno schema, non sfortuna.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Abbiamo visto questa stessa partita $count volte di recente. Stesso copione, stesso finale.';
  }

  @override
  String ySameOldStory3(String count) {
    return 'La $countª versione degli stessi novanta minuti. Nessuno ci mette mano.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count volte. Se ancora non vedi lo schema, non stai guardando.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Stessa storia, $count volte. Sono finite prima le scuse dei risultati.';
  }

  @override
  String get yToldYouSo0 =>
      'Avevo detto che sarebbe successo mentre tutti erano impegnati a festeggiare.';

  @override
  String get yToldYouSo1 =>
      'Due belle settimane ed eravamo di nuovo una generazione d\'oro. Ed eccoci qua.';

  @override
  String get yToldYouSo2 =>
      'Quelli che il mese scorso mi dicevano di godermela sono diventati silenziosi.';

  @override
  String get yToldYouSo3 =>
      'Non ci provo nessun piacere. Pochissimo piacere. Un po\'.';

  @override
  String get yToldYouSo4 =>
      'Non è mai stato bello come vi raccontavano, e questa è la prova.';

  @override
  String get yToldYouSo5 =>
      'Ogni volta. Ci dicono che stavolta è diverso, e ogni volta non lo è.';

  @override
  String get tacticsSubOffAlready => 'Già uscito';

  @override
  String get tacticsSubInjured => 'Infortunato';

  @override
  String get tacticsSubSentOffMark => 'Espulso';

  @override
  String get tacticsSubNoneLeft => 'Cambi esauriti';

  @override
  String get tacticsUndoLastChange => 'Annulla l\'ultima modifica';

  @override
  String get matchStrengthTitle => 'COSA INFLUISCE SULLA SQUADRA';

  @override
  String get strengthFactorFamiliarity => 'Assetto assimilato';

  @override
  String get strengthFactorFatigue => 'Gambe stanche';

  @override
  String get strengthFactorClubForm => 'Forma nei club';

  @override
  String get strengthFactorMorale => 'Spogliatoio';

  @override
  String get strengthFactorCaptain => 'Capitano';

  @override
  String get strengthFactorStaff => 'Staff';

  @override
  String get strengthFactorDossier => 'Dossier dell\'osservatore';

  @override
  String yDebut0(String name) {
    return '$name alla prima presenza. Ricordatevi questo nome.';
  }

  @override
  String yDebut1(String name) {
    return 'Esordio per $name. Si vede che ha qualcosa, no?';
  }

  @override
  String yDebut2(String name) {
    return '$name, prima presenza. Vediamo cosa ne fa.';
  }

  @override
  String yDebut3(String name) {
    return 'Esordio per $name. Alla rosa servivano gambe fresche da qualche parte.';
  }

  @override
  String yDebut4(String name) {
    return 'Una presenza regalata a $name. Ne abbiamo regalate parecchie ultimamente.';
  }

  @override
  String yDebut5(String name) {
    return 'Esordio per $name. Un altro che avremo dimenticato entro la primavera.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name è a secco da $count partite e fa tutto il resto in campo.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count partite senza gol per $name. Poi arrivano a grappoli, è sempre stato così.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count partite, zero gol.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count partite senza gol per $name. Da tenere d\'occhio.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count partite. Zero gol. $name non prenderebbe una porta da due metri.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name non segna da $count partite. Fate giocare chiunque altro.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Ora $opponent. $count precedenti e conta ancora tutto.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count volte contro $opponent ormai. Fatevi sotto.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Ora $opponent. $count precedenti.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Sfida numero $count con $opponent questa settimana.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Di nuovo $opponent. $count sfide così e non abbiamo imparato niente.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count partite contro $opponent e ci battono ancora. Splendido.';
  }

  @override
  String get positionGoalkeeper => 'Portiere';

  @override
  String get positionLeftBack => 'Terzino sinistro';

  @override
  String get positionCentreBack => 'Difensore centrale';

  @override
  String get positionRightBack => 'Terzino destro';

  @override
  String get positionDefensiveMid => 'Mediano';

  @override
  String get positionCentralMid => 'Centrocampista';

  @override
  String get positionAttackingMid => 'Trequartista';

  @override
  String get positionLeftMid => 'Esterno sinistro';

  @override
  String get positionRightMid => 'Esterno destro';

  @override
  String get positionLeftWing => 'Ala sinistra';

  @override
  String get positionRightWing => 'Ala destra';

  @override
  String get positionStriker => 'Punta';

  @override
  String get roleNone => 'Nessun compito';

  @override
  String get roleTargetMan => 'Punta di peso';

  @override
  String get rolePoacher => 'Rapinatore d\'area';

  @override
  String get rolePlaymaker => 'Regista';

  @override
  String get roleBallWinner => 'Incontrista';

  @override
  String get roleInvertedWinger => 'Ala a piede invertito';

  @override
  String get roleBallPlayingDefender => 'Difensore impostatore';

  @override
  String get roleNoneBlurb => 'Gioca il suo gioco naturale.';

  @override
  String get roleTargetManBlurb =>
      'Vince i colpi di testa, la appoggia. Assist e palle inattive.';

  @override
  String get rolePoacherBlurb => 'Si apposta in area. Molti più gol.';

  @override
  String get rolePlaymakerBlurb => 'Crea occasioni. Molti più assist.';

  @override
  String get roleBallWinnerBlurb => 'Spezza il gioco invece di finalizzarlo.';

  @override
  String get roleInvertedWingerBlurb => 'Si accentra per tirare. Più gol.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Avvia l\'azione da dietro.';

  @override
  String get federationDeptYouth => 'Settore giovanile';

  @override
  String get federationDeptCommercial => 'Commerciale / PR';

  @override
  String get federationDeptMedical => 'Medicina e scienze motorie';

  @override
  String get federationDeptNaturalisation => 'Ufficio naturalizzazioni';

  @override
  String get federationDeptBoardRelations => 'Rapporti istituzionali';

  @override
  String get federationDeptYouthBlurb =>
      'Prospetti del vivaio migliori esordiscono per la tua nazionale nel prossimo ciclo.';

  @override
  String get federationDeptCommercialBlurb =>
      'Gli sponsor portano entrate extra a fine ciclo.';

  @override
  String get federationDeptMedicalBlurb =>
      'Meno infortuni. La tua rosa resta disponibile per tutto il ciclo.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Più giocatori stranieri si offrono di passare alla tua nazionale.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'La federazione giudica i tuoi risultati con più pazienza.';

  @override
  String get federationBuildingAcademy => 'Vivaio';

  @override
  String get federationBuildingCommercial => 'Sede commerciale';

  @override
  String get federationBuildingMedical => 'Centro medico';

  @override
  String get federationBuildingScouting => 'Ufficio osservatori';

  @override
  String get federationBuildingBoardroom => 'Sala del consiglio';

  @override
  String get moraleBuoyant => 'Euforico';

  @override
  String get moralePositive => 'Positivo';

  @override
  String get moraleSettled => 'Sereno';

  @override
  String get moraleUneasy => 'Inquieto';

  @override
  String get moraleRockBottom => 'A terra';

  @override
  String get matchTabTimeline => 'CRONACA';

  @override
  String get matchTabStats => 'STATISTICHE';

  @override
  String get matchTabLineups => 'FORMAZIONI';

  @override
  String get matchPenalty => 'RIGORE';

  @override
  String get matchStateLevel => 'Siamo in parità';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sei avanti di $count gol',
      one: 'Sei avanti di un gol',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sei sotto di $count gol',
      one: 'Sei sotto di un gol',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% di possesso';
  }

  @override
  String get boardVerdictSackedTitle => 'La federazione ti ha esonerato';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Un ciclo disastroso (valutazione $rating%). La tua gestione finisce qui. Ora solo nazionali minori ti daranno una possibilità.';
  }

  @override
  String get boardVerdictDelightedTitle => 'La federazione è entusiasta';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Un ciclo eccezionale (valutazione $rating%) dopo $best. Nazionali più grandi sono interessate, oppure puoi restare e costruire.';
  }

  @override
  String get boardVerdictSolidTitle => 'Un ciclo solido';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'La federazione è soddisfatta (valutazione $rating%). Alcune nazionali di pari livello ti prenderebbero, ma non c\'è fretta di cambiare.';
  }

  @override
  String get boardVerdictExpectedMoreTitle =>
      'La federazione si aspettava di più';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Un ciclo deludente (valutazione $rating%). Mantieni il posto, ma le offerte sono un passo indietro.';
  }

  @override
  String get boardVerdictPressureTitle => 'Sei davvero sotto pressione';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Un ciclo scarso (valutazione $rating%). Sopravvivi, ma solo nazionali più deboli sono interessate se vuoi ripartire da zero.';
  }

  @override
  String get boardVerdictHeroTitle => 'Il paese è con te';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cicli',
      one: '1 ciclo',
    );
    return ' $nation ti adora: sei un eroe nazionale dopo $_temp0; il posto è tuo finché lo vorrai.';
  }

  @override
  String get boardVerdictTheNation => 'Il paese';

  @override
  String get boardVerdictBestQuiet => 'un ciclo tranquillo';

  @override
  String get boardVerdictBestCycle => 'il ciclo';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'il Campionato del mondo: $placement';
  }

  @override
  String get finishThirdPlace => 'Terzo posto';

  @override
  String get finishFourthPlace => 'Quarto posto';

  @override
  String get finishDidNotQualify => 'Mancata qualificazione';

  @override
  String get careerRepIconic => 'Leggendaria';

  @override
  String get careerRepRenowned => 'Rinomata';

  @override
  String get careerRepEstablished => 'Affermata';

  @override
  String get careerRepRising => 'In ascesa';

  @override
  String get careerRepUnproven => 'Da dimostrare';

  @override
  String get hubOfferStepUp => 'Salto di qualità';

  @override
  String get hubOfferLateral => 'Passo laterale';

  @override
  String get hubOfferRebuild => 'Una ricostruzione';

  @override
  String careerNationsCupWon(String league) {
    return 'Lega $league · Campioni';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Lega $league · Secondi';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Lega $league · Semifinalisti';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Lega $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Approdo: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'In finale per il terzo posto';

  @override
  String tourRunThrough(String round) {
    return 'Superato il turno: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Eliminati: $round';
  }

  @override
  String get tourRunInGroup => 'In corsa nella fase a gironi';

  @override
  String get tourRunGroupOut => 'Eliminati nella fase a gironi';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Ciclo $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played giocate  ·  ${won}V ${drawn}N ${lost}P';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Campionato del mondo: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Ancora in corso';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Sotto di due con $opponent all\'intervallo e l\'abbiamo ripresa tutta. Questa è una squadra.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Sotto di due contro $opponent e alla fine non contava più. Non lo fanno in molti.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Intervallo: sotto di due gol con $opponent. Fischio finale: no. Il secondo tempo era un\'altra partita.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Rimontati due gol a $opponent. Qualunque cosa sia stata detta all\'intervallo, ditela ogni settimana.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Va bene, l\'abbiamo ripresa con $opponent. Ora qualcuno mi spieghi il primo tempo.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Sotto di due con $opponent e dovremmo essere felici. Sistemate il primo tempo.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Avanti di due con $opponent all\'intervallo, e ci è sfuggita. Succede anche a squadre migliori.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Due gol avanti contro $opponent e l\'abbiamo persa. Il ciclo è lungo, c\'è tempo.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Intervallo: due gol avanti con $opponent. Fischio finale: tutt\'altra storia.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Un vantaggio di due gol contro $opponent, sparito in quarantacinque minuti.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Avanti di due e l\'abbiamo persa. Contro $opponent. Qualcuno ne risponderà.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Due gol avanti contro $opponent e siamo riusciti a fare questo. Ogni singola volta.';
  }

  @override
  String get cycleBackupDone =>
      'Carriera salvata nella cartella FNM su questo telefono. Disinstallando l\'app viene cancellata: per tenerne una copia altrove, usa Backup del salvataggio nella schermata dei salvataggi.';

  @override
  String get cycleBackupFailed =>
      'Impossibile fare il backup della carriera stavolta.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Una notte da ricordare contro $opponent. Quanto è orgoglioso di questo gruppo?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent non ha retto il confronto. È la squadra che ha sempre pensato di avere?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Una grande vittoria contro $opponent. Cosa ha fatto la differenza stasera?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'Contro $opponent una vittoria netta. Dove l\'avete vinta?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Una bella vittoria contro $opponent. Una bella serata: perché qualcuno dovrebbe credere che durerà?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Un ottimo risultato contro $opponent. Era il suo piano, o i giocatori ci sono arrivati da soli?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Una serata dura contro $opponent. Cosa si dice ai giocatori dopo una partita così?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Nessuno se l\'aspettava contro $opponent. È stata solo una di quelle serate?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Una serata che fa riflettere contro $opponent. Cosa è andato storto?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent vi ha fatto a pezzi. Questa rosa è all\'altezza?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Siete arrivati secondi su ogni pallone contro $opponent. Come ha potuto lasciare che finisse così male?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent ha segnato quando voleva. Dov\'era il piano stasera?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Un\'altra che sfugge, stavolta contro $opponent. Come si inverte questa tendenza?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'I risultati non arrivano, e $opponent ha peggiorato le cose. Crede ancora in questo gruppo?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Ancora nessuna vittoria, ora contro $opponent, e la federazione osserva. Il suo posto è al sicuro?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Dopo $opponent, la serie negativa si allunga. È preoccupato per il suo futuro?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Ora anche $opponent. Il suo predecessore è stato esonerato per una serie così. Perché lei dovrebbe sopravvivere?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Dopo un\'altra serata come quella contro $opponent, tutte le radio chiedono la sua testa. Si dimetterebbe se la federazione glielo chiedesse?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Ha messo in gioco il suo posto, e dopo $opponent non è andata come voleva. Come sta?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Le tre partite sono finite, l\'ultima contro $opponent. La prova se l\'è data lei. Cosa pensa del verdetto?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Ci aveva detto di giudicarla sulle prossime tre. Dopo $opponent, l\'abbiamo fatto. Il posto è ancora suo?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Tre partite, l\'ultima contro $opponent, e non ciò che aveva promesso. Ha parlato con la federazione del suo futuro?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'La prova se l\'è data lei e l\'ha fallita contro $opponent. Si dimetterà?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Parole sue, non nostre: giudicatemi sulle prossime tre. Dopo $opponent, perché è ancora seduto lì?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Vuole di più da loro. Qualcuno in particolare?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Ha alzato l\'asticella. Chi deve farsi avanti per primo?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Dice che alcuni devono guardarsi dentro. A chi si riferisce?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Non abbastanza, dice. Di chi sta parlando?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Resta sul vago. Farà dei nomi, o la colpa ricade su di lei?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Ogni settimana è colpa di qualcun altro. Di chi stavolta?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Parole coraggiose. E se la prossima non va come vuole?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Il paese la terrà a quelle parole. E se non dovesse andare?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'E se non la vince? Poi cosa?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Ormai l\'ha detto. Cosa succede se si sbaglia?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'In questa sala abbiamo già sentito promesse. Cosa deve ai tifosi se anche questa salta?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'E quando non succederà, quale sarà la scusa?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Un\'ultima, se se la sente. Su cosa deve ancora lavorare questo gruppo?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Quando si sarà calmato tutto, cosa si porta di stasera nella prossima partita?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Andiamo un po\' più a fondo. Cosa deve migliorare prima della prossima partita?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Al di là del risultato: questa rosa è dove la vuole?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Tante parole, poca sostanza. Cosa cambia concretamente da qui?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'I tifosi vogliono una risposta chiara. Questa squadra è all\'altezza, sì o no?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player è stato straordinario stasera. Fin dove può arrivare?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player è in tutti i titoli stasera. Se l\'aspettava?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player si è distinto. Cosa gli aveva chiesto stasera?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'È stato $player a fare la differenza stasera?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Senza $player è un\'altra storia. È una squadra, o un giocatore solo?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player è stato brillante. Merito suo o del giocatore?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player ha passato una serata difficile. Ha qualche acciacco?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player non era in serata. Gli starà vicino?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player ha faticato stasera. Mantiene il posto?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player è sembrato fuori ritmo. Cosa pensa della sua partita?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player è stato di nuovo un passeggero. Perché continua a sceglierlo?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Tutti hanno visto che $player non c\'era. Tutti tranne la panchina?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Aveva detto che avrebbe vinto la prossima, e l\'ha fatto. È bello avere ragione?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Aveva promesso una vittoria nella partita successiva e l\'ha ottenuta. Fiducia o spavalderia?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Aveva detto che avrebbe vinto la prossima, e l\'ha fatto. Fortuna, o dobbiamo iniziare ad ascoltarla?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Ci aveva detto che l\'avrebbe vinta. Non è successo. Cosa è andato storto?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Aveva detto che avrebbe vinto la prossima. Non è andata così. Perché dovremmo credere alla prossima promessa?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Aveva detto che avrebbe vinto la prossima. Non è andata così. Le sue parole valgono ancora qualcosa in questa sala?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Aveva chiesto di essere giudicato su tre partite, e ha superato la prova. Si sente ripagato?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Giudicatemi sulle prossime tre, aveva detto. L\'abbiamo fatto, e i risultati sono arrivati. Cosa le ha insegnato quella prova?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Si era dato tre partite e le ha superate. Era davvero una prova così difficile?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Aveva chiesto di essere giudicato su tre partite. Non sono andate come voleva. Cosa ha imparato?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Aveva detto: giudicatemi sulle prossime tre. Le tre sono passate, e con loro il beneficio del dubbio. E ora?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'La prova se l\'è data lei e l\'ha fallita. Perché qualcuno dovrebbe crederle ora?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Ha sostenuto $player quando altri non lo facevano. Ha risposto presente. Un po\' di merito è suo?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Ha sostenuto $player. Ha risposto presente. Fede o conoscenza?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Ha sostenuto $player, e per una volta ha pagato. Sarà così sicuro anche la prossima volta?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'È rimasto al fianco di $player, e non ha funzionato. Crede ancora in lui?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Ha sostenuto $player. Non l\'ha ripagata. È stato un errore?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Il suo giudizio o la sua lealtà: cosa ha fallito con $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'È stato duro con $player, e le partite successive le hanno dato ragione. Qualche soddisfazione?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Ha criticato $player, e lui non ha risposto. C\'è una via del ritorno per lui?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Ha messo $player alla gogna e non si è più ripreso. L\'ha distrutto?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Ha criticato $player, e lui le ha risposto sul campo. Era questa l\'idea fin dall\'inizio?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Ha dato la colpa a $player, e da allora è stato uno dei suoi migliori. Gli deve delle scuse?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Ha gettato $player in pasto ai leoni, e da allora è stato il suo miglior giocatore. Si scuserà?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Questi giocatori mi hanno dato tutto. Non ne cambierei nemmeno uno.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Nessuno lavora più duro di questo gruppo. Li difenderò sempre.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Da questa sedia non sentirete una parola contro i miei giocatori.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Il merito è dei giocatori, non mio. Scrivete di loro.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Questa è colpa mia. Ho scelto io la squadra e l\'ho schierata io.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Giudicate me, non loro. La squadra è mia, e la responsabilità anche.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Se cercate un colpevole, sono seduto proprio qui.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'La responsabilità è mia. Lasciate stare i giocatori.';

  @override
  String get pressReplyDemandMore1 =>
      'Voglio di più. Alcuni sanno esattamente cosa intendo.';

  @override
  String get pressReplyDemandMore2 =>
      'L\'impegno non basta a questo livello. Voglio di più, e gliel\'ho detto.';

  @override
  String get pressReplyDemandMore3 =>
      'Mi aspetto di più da ognuno di loro, a partire da domani.';

  @override
  String get pressReplyDemandMore4 =>
      'Alcuni devono guardarsi dentro. Non sono soddisfatto.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Vinceremo la prossima. Potete scriverlo.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Ricordatevi le mie parole: vinciamo la prossima partita.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'La prossima la vinciamo. Lo dico qui, così potete tenermi a queste parole.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Sono sicuro di questa squadra. Vinciamo la prossima.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Giudicatemi sulle prossime tre partite. È giusto così.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Datemi tre partite. Se non va ancora bene, giudicatemi su quelle.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Le prossime tre diranno se sono l\'uomo giusto. Tenetemi a questo.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Tre partite. Poi scrivete di me quello che volete.';

  @override
  String get pressReplyDeflect1 =>
      'Pensiamo una partita alla volta. Nient\'altro da aggiungere.';

  @override
  String get pressReplyDeflect2 => 'Oggi non vi darò titoli.';

  @override
  String get pressReplyDeflect3 =>
      'La prossima partita. È l\'unica cosa a cui penso.';

  @override
  String get pressReplyDeflect4 => 'Quello che penso resta nello spogliatoio.';

  @override
  String get pressReplyTakeCredit1 =>
      'L\'ho detto perché ci credevo, e avevo ragione.';

  @override
  String get pressReplyTakeCredit2 =>
      'L\'ho letta bene. È per questo che sono qui.';

  @override
  String get pressReplyTakeCredit3 =>
      'Chiamatelo intuito. Sapevo cosa stavo dicendo.';

  @override
  String get pressReplyTakeCredit4 =>
      'Ho fatto una scelta e ha funzionato. Me la prendo.';

  @override
  String get pressReplyStandByIt1 =>
      'Ho detto quello in cui credevo. Lo confermo.';

  @override
  String get pressReplyStandByIt2 => 'Non ritiro una sola parola.';

  @override
  String get pressReplyStandByIt3 =>
      'Stessa risposta di allora. Lo pensavo, e lo penso ancora.';

  @override
  String get pressReplyStandByIt4 => 'Lo ridirei domani.';

  @override
  String get pressReplyAdmitMistake1 =>
      'Su quella ho sbagliato. Me ne prendo la responsabilità.';

  @override
  String get pressReplyAdmitMistake2 =>
      'D\'accordo, ho valutato male. Ne farò tesoro.';

  @override
  String get pressReplyAdmitMistake3 => 'Avevo torto, e posso dirlo.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Quella scelta non ha funzionato, ed era mia.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player ha tutta la mia fiducia. Si riprenderà.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Credo in $player, e vi mostrerà perché.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Da me non sentirete una parola contro $player. Risponderà presente.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player resta nei miei piani. Guardate cosa farà ora.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player ci ha deluso stasera, e lo sa.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Mi aspettavo molto di più da $player. Deve darmi una risposta.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player non è stato all\'altezza. Lo dico pubblicamente.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Non è stato abbastanza da parte di $player, e glielo dirò io.';
  }

  @override
  String get pressOnRecordWinNext => 'Agli atti: vincerai la prossima partita.';

  @override
  String get pressOnRecordJob => 'Agli atti: giudicarti sulle prossime tre.';

  @override
  String pressOnRecordBack(String player) {
    return 'Agli atti: fiducia a $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Agli atti: $player ti ha deluso.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'L\'ha detto, ed è successo. $nation ha un CT che mantiene la parola.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'L\'ha detto ad alta voce, poi l\'ha fatto. È l\'uomo di cui aveva bisogno $nation.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: l\'aveva previsto, e si è avverato. Niente da dire.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'L\'ha messo agli atti e ha tenuto. Punto per lui. $nation va avanti.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Una giusta l\'ha detta. $nation, non abituarti.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Anche un orologio fermo segna l\'ora giusta due volte al giorno. $nation: stavolta è andata bene.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'L\'ha detto e non è andata. Sono ancora con lui. $nation riparte.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: ha promesso più di quanto abbiamo avuto, ma preferisco un CT che crede in sé stesso.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: l\'ha detto pubblicamente e non è successo. La gente se lo ricorderà.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Paroloni, e niente dietro. $nation: la prossima volta, parla meno.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Si è messo lì e ce l\'ha detto. Poi questo. $nation merita più dei discorsi.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'La sua parola ormai non vale niente. Segnatelo, $nation.';
  }

  @override
  String get ncZoneNorth => 'Zona Nord';

  @override
  String get ncZoneWest => 'Zona Ovest';

  @override
  String get ncZoneEast => 'Zona Est';

  @override
  String get ncZoneCentralSouthern => 'Zona Centro-Sud';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Campioni';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Secondi';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Semifinalisti';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Ottavi di finale';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Quartofinalisti';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Arrivare ai quarti di finale';

  @override
  String get objectiveNcZoneWinGroup => 'Vincere il girone';

  @override
  String get finishNcFinalsEight => 'Quarti di finale';

  @override
  String get finishNcBottomHalf => 'Metà bassa del girone';

  @override
  String get tourContTabZones => 'ZONE';

  @override
  String get tourContTabFinalsEight => 'FASE FINALE';

  @override
  String get tourContFinalsEightSoon =>
      'La fase finale parte a novembre con gli ottavi di finale: tutte le 14 vincitrici dei gironi e le 2 migliori seconde.';

  @override
  String get tourContQuarterFinals => 'QUARTI DI FINALE';

  @override
  String get tourContZoneAdvancement =>
      'Tutte le vincitrici dei gironi vanno agli ottavi di finale, insieme alle 2 migliori seconde. Nessuna retrocessione.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup =>
      'Coppa delle Nazioni del Nord America';

  @override
  String get compAfricanNationsCup => 'Coppa delle Nazioni';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Vincere la Coppa delle Nazioni del Nord America';

  @override
  String get objectiveNcWinItAfrica => 'Vincere la Coppa delle Nazioni';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Arrivare in finale di Coppa delle Nazioni del Nord America';

  @override
  String get objectiveNcReachFinalAfrica =>
      'Arrivare in finale di Coppa delle Nazioni';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Vincitori della Coppa delle Nazioni del Nord America';

  @override
  String get finishNcChampionsAfrica => 'Vincitori della Coppa delle Nazioni';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Qualificazioni: $competition. Tutto il paese crede in questa squadra. Dove vuoi arrivare?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Nuove qualificazioni, $competition, e il morale è alto. Fin dove può arrivare questa squadra?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Iniziano le qualificazioni, $competition. Qual è l’obiettivo di questa campagna?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Le qualificazioni sono arrivate, $competition. Dove vedi questa squadra alla fine?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Iniziano le qualificazioni, $competition, e in tanti dubitano che ce la farai. Cosa rispondi?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Altre qualificazioni, $competition. Perché dovremmo credere che questa volta sarà diverso?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Ci siamo: $competition. Tutto il paese è con te. Fin dove puoi arrivare?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Ci sei: $competition. I tifosi sognano. Qual è l’obiettivo?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Questa settimana si parte: $competition. Cosa sarebbe un successo?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'La tua prima partita si avvicina, $competition. Dacci un obiettivo.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Ci siamo: $competition, e nessuno si aspetta molto. Cosa speri davvero?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Ci sei: $competition, ma i dubbi restano. Qual è il tuo obiettivo?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'Nel tuo girone c’è $rival. Ti preoccupa?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Il sorteggio ti mette di fronte $rival. Come vedi quella partita?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival sembra la squadra più forte del girone. È la favorita?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Che idea ti sei fatto di $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'Nel tuo girone c’è $rival. Sii onesto, puoi starle dietro?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Quasi tutti si aspettano che $rival vi batta. Si sbagliano?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player è in gran forma. È il suo momento?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player è su tutti i titoli. Può trascinare questa squadra?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Quanto dipende questa campagna da $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return '$player è pronto a guidare questa squadra?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Se $player non è al meglio, questa squadra ha qualcos’altro?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player ha molto sulle spalle. Troppo?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Arriveremo più lontano di quanto tutti si aspettino.';

  @override
  String get pressReplyAimHigher2 =>
      'Voglio più di quanto chieda la federazione, e lo dico ad alta voce.';

  @override
  String get pressReplyMatchBrief1 =>
      'Conosciamo l’obiettivo e lo raggiungeremo.';

  @override
  String get pressReplyMatchBrief2 =>
      'La federazione ha fissato un obiettivo. Lo centreremo.';

  @override
  String get pressReplyPlayDown1 => 'Pensiamo a una partita alla volta.';

  @override
  String get pressReplyPlayDown2 =>
      'Nessuna grande promessa. Vedremo dove saremo.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Ci qualificheremo. Potete scriverlo.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Questa squadra sarà alla fase finale.';

  @override
  String get pressReplyFearNobody1 => 'Non temiamo nessuno.';

  @override
  String get pressReplyFearNobody2 =>
      'Anche loro devono giocare contro di noi.';

  @override
  String get pressReplyRespectRival1 => 'Sono i favoriti, e li rispettiamo.';

  @override
  String get pressReplyRespectRival2 =>
      'Un’ottima squadra. Servirà il nostro meglio.';

  @override
  String get pressReplyTeamFirst1 =>
      'Conta tutta la squadra, non un solo giocatore.';

  @override
  String get pressReplyTeamFirst2 => 'Nessuno vince da solo.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Agli atti: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Agli atti: nessuna promessa.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Avevi fissato un obiettivo prima della campagna e l’hai centrato. Il momento di cui vai più fiero?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Avevi detto cosa avresti ottenuto, e ci sei riuscito. Hai mai avuto dubbi?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Hai centrato il tuo obiettivo. Fortuna, o era davvero il piano?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Avevi fissato un obiettivo e l’hai mancato. Cosa non ha funzionato?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Avevi promesso più di quanto la squadra abbia dato. Ti penti di averlo detto?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Prima della campagna avevi parlato in grande e hai fallito. Perché dovremmo crederti ora?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'La stampa vuole sapere i tuoi obiettivi: $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Livello $level · $amount';
  }

  @override
  String get formOnFire => 'In stato di grazia';

  @override
  String get formGood => 'In forma';

  @override
  String get formSteady => 'Regolare';

  @override
  String get formPoor => 'Fuori forma';

  @override
  String get formCold => 'In crisi nera';

  @override
  String get playerFormTitle => 'FORMA E CONDIZIONE';

  @override
  String playerFormAverage(String rating) {
    return 'Media di $rating nelle ultime partite';
  }

  @override
  String get playerFormNoGames => 'Troppe poche partite recenti per giudicare';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta alla sua valutazione nella prossima partita';
  }

  @override
  String get playerFormNoEffect => 'Nessuna variazione nella prossima partita';

  @override
  String get sideGroupHome => 'Home';

  @override
  String get sideGroupTeam => 'Squadra';

  @override
  String get sideGroupCompetitions => 'Competizioni';

  @override
  String get sideGroupFederation => 'Federazione';

  @override
  String get sideGroupHistory => 'Storia';

  @override
  String get sideInbox => 'Posta';

  @override
  String get sideSquad => 'Rosa';

  @override
  String get sideTactics => 'Tattica';

  @override
  String get sideMainMenu => 'Menu principale';

  @override
  String get sideCallUps => 'Convocazioni';

  @override
  String get sideTournaments => 'Tornei';

  @override
  String get sideRanking => 'Ranking';

  @override
  String get sideResults => 'Risultati';

  @override
  String get sideFinances => 'Finanze';

  @override
  String get sideBoard => 'Dirigenza';

  @override
  String get sideManager => 'Allenatore e staff';

  @override
  String get sideRecords => 'Record';

  @override
  String get sideLegends => 'Leggende';

  @override
  String get sideHeadToHead => 'Scontri diretti';

  @override
  String get sideAchievements => 'Obiettivi';

  @override
  String get sideCareer => 'Carriera';

  @override
  String get topBarNext => 'Prossima';

  @override
  String get topBarDrawPending => 'Sorteggio in arrivo';

  @override
  String get paneFullProfile => 'Profilo completo';

  @override
  String get panePickPlayer =>
      'Scegli un giocatore per vedere qui la sua scheda';

  @override
  String get inboxPickMessage => 'Scegli un messaggio per leggerlo qui';

  @override
  String get inboxFilterAll => 'Tutti';

  @override
  String get panelViewAll => 'Vedi tutto';

  @override
  String get gridViewOverview => 'Panoramica';

  @override
  String get gridColCondition => 'Condizione';

  @override
  String get gridColStatus => 'Stato';

  @override
  String get gridColRank => 'Posizione';

  @override
  String get gridColMove => 'Variazione';

  @override
  String get gridColNation => 'Nazionale';

  @override
  String get gridColRegion => 'Regione';

  @override
  String get gridColPoints => 'Punti';

  @override
  String get panePickNation =>
      'Scegli una nazionale per vedere qui il suo palmarès';

  @override
  String get resultsCyclesTitle => 'Cicli';

  @override
  String get tourDrawStart => 'Avvia il sorteggio';

  @override
  String get tourDrawViewGroups => 'Vedi i gironi';

  @override
  String get gridColCeiling => 'Potenziale';

  @override
  String get gridColYearGain => 'Crescita';

  @override
  String get gridColMarkedAt => 'Alla segnalazione';

  @override
  String get budgetSetupTitle => 'Imposta il budget';

  @override
  String get budgetEffectsTitle => 'Cosa compra questo budget';

  @override
  String get naturalisationTitle => 'Naturalizzazione';

  @override
  String get yTrending => 'Di tendenza';

  @override
  String get yVoices => 'Voci';

  @override
  String get yConversation => 'Conversazione';

  @override
  String get allTimeRecordsTitle => 'Record mondiali di sempre';

  @override
  String get h2hMeetingsTitle => 'Tutti i precedenti';

  @override
  String get h2hPickOpponent =>
      'Scegli un avversario per vedere qui tutti i precedenti';

  @override
  String get savesTitle => 'Salvataggi';

  @override
  String get gridColPlayer => 'Giocatore';

  @override
  String get gridColPos => 'Ruolo';

  @override
  String get gridColActive => 'In attività';

  @override
  String get gridColMotm => 'MVP';

  @override
  String get gridColAvg => 'Media';

  @override
  String get gridColOpponent => 'Avversario';

  @override
  String get gridColStarts => 'Da titolare';

  @override
  String get gridColTournaments => 'Tornei';

  @override
  String get gridColDate => 'Data';

  @override
  String get gridColLastPlayed => 'Ultima partita';

  @override
  String get gridColManager => 'Allenatore';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nazionali',
      one: '1 nazionale',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Ordinate per ranking mondiale';

  @override
  String get nationsStrength => 'Forza';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier su 5';
  }

  @override
  String get nationsSquadOverall => 'Valore della rosa';

  @override
  String get nationsOpeningBudget => 'Budget iniziale';

  @override
  String get nationsStarPlayer => 'Stella della squadra';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Stella $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return '$age anni';
  }

  @override
  String get nationsBoardExpects => 'La dirigenza si aspetta';

  @override
  String nationsManage(String nation) {
    return 'Prendi le redini ($nation)';
  }

  @override
  String get nationsManagerNext =>
      'Subito dopo scegli il nome dell\'allenatore';

  @override
  String get playerPageTitle => 'Giocatore';

  @override
  String get nationPageTitle => 'Nazionale';

  @override
  String get friendliesYourGames => 'Le tue amichevoli';

  @override
  String hubEventInjuryCover(String player) {
    return 'Sostituisci l\'infortunato $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Salta $matches partite',
      one: 'Salta la prossima partita',
    );
    return '$_temp0. Convoca un altro o continua senza di lui.';
  }

  @override
  String get injuryCoverTitle => 'SOSTITUTO';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) è infortunato. Convoca chiunque fuori dalla rosa, in qualsiasi ruolo, oppure tienilo e continua.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Convoca $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Tieni $player e continua';
  }

  @override
  String get injuryCoverPick => 'Scegli un sostituto';

  @override
  String get injuryCoverNone => 'Nessuno fuori dalla rosa è disponibile.';

  @override
  String get nationNowRanking => 'Ranking mondiale';

  @override
  String get nationNowForm => 'Forma';

  @override
  String get nationNowNoForm => 'Nessuna partita giocata';

  @override
  String get nationNowNext => 'Prossima partita';

  @override
  String get nationNowNoNext => 'Niente in programma';

  @override
  String get nationNowSquad => 'Rosa';

  @override
  String get nationNowAgainstYou => 'Contro di te';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}V ${d}N ${l}P';
  }

  @override
  String get nationNowLastMeeting => 'Ultimo incontro';

  @override
  String nationNowOverall(int value) {
    return 'Media $value';
  }

  @override
  String get hubUpcoming => 'IN ARRIVO';

  @override
  String get hubFullSchedule => 'Calendario completo';

  @override
  String get scheduleTitle => 'Calendario';

  @override
  String get scheduleToday => 'Oggi';

  @override
  String get scheduleKnockoutPending =>
      'Fase a eliminazione diretta, se passate';

  @override
  String get scheduleNextRoundPending => 'Turno successivo';

  @override
  String scheduleFromDate(String date) {
    return 'Dal $date';
  }

  @override
  String get scheduleHomeShort => 'C';

  @override
  String get scheduleAwayShort => 'T';

  @override
  String get tacticsNoPresetsInMatch =>
      'Nessuna tattica salvata per ora. Salvane una dalla schermata Tattica prima della partita.';

  @override
  String get homeCampaigns => 'Campagne';

  @override
  String get homeContinueCampaign => 'CONTINUA LA CAMPAGNA';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Ciclo $cycle di $total';
  }

  @override
  String get campaignsTitle => 'Campagne';

  @override
  String get campaignTransplantTitle => 'Il Trapianto';

  @override
  String get campaignTransplantTwist =>
      'Otto dei migliori d\'Italia cambiano bandiera per San Marino';

  @override
  String get campaignTransplantGoal => 'Qualificarsi per il Campionato Europeo';

  @override
  String get campaignGrudgeTitle => 'Rancore';

  @override
  String get campaignGrudgeTwist => 'Georgia e Albania, sorteggiate insieme';

  @override
  String get campaignGrudgeGoal =>
      'Finire sopra l\'Albania nelle qualificazioni';

  @override
  String get campaignTransplantIntro =>
      'San Marino non ha mai avuto una qualificazione degna di questo nome. Poi otto dei migliori d\'Italia prendono il passaporto ed entrano in campo. Hai un ciclo per trasformare una curiosità in una squadra.';

  @override
  String get campaignGrudgeIntro =>
      'Georgia e Albania sono finite nello stesso girone di qualificazione, e nessuna perdona una sconfitta. Finisci sopra l\'Albania e vedi fin dove arrivi.';

  @override
  String get campaignStars1Transplant => 'Qualificarsi';

  @override
  String get campaignStars2Transplant =>
      'Raggiungere la fase a eliminazione diretta';

  @override
  String get campaignStars3Transplant => 'Vincere il Campionato Europeo';

  @override
  String get campaignStars1Grudge => 'Sopra l\'Albania';

  @override
  String get campaignStars2Grudge => 'E qualificarsi';

  @override
  String get campaignStars3Grudge => 'E batterla due volte';

  @override
  String get campaignFree => 'Gratis';

  @override
  String get campaignStart => 'Inizia';

  @override
  String get campaignPartOfUnlimited => 'Incluso in Illimitato';

  @override
  String get campaignResume => 'Riprendi';

  @override
  String get campaignAbandon => 'Abbandona';

  @override
  String get campaignAbandonConfirm =>
      'Abbandonare questa partita? I progressi vanno persi; il tuo timbro resta.';

  @override
  String get campaignMoveToSaves => 'Sposta nei salvataggi';

  @override
  String get campaignCannotContinue =>
      'Il mondo di questa campagna è troppo lontano da quello reale per proseguire come carriera.';

  @override
  String get campaignMoveSlotsFull =>
      'I tuoi slot di salvataggio sono pieni. Liberane uno prima.';

  @override
  String get campaignStampConquered => 'Conquistata';

  @override
  String get campaignStampFailed => 'Fallita';

  @override
  String get campaignDifficultyHard => 'Difficile';

  @override
  String get campaignDifficultyMedium => 'Media';

  @override
  String get campaignGoalLabel => 'Obiettivo';

  @override
  String get campaignStarsLabel => 'Stelle';

  @override
  String get campaignRunInProgress =>
      'Questa campagna ha già una partita in corso.';

  @override
  String get campaignVerdictWon => 'Conquistata';

  @override
  String get campaignVerdictLost => 'Non stavolta';

  @override
  String get campaignVerdictContinue => 'Continua';

  @override
  String campaignProgressQualifying(String position) {
    return 'Qualificazioni: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Fase finale: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Il percorso in numeri';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Sfide vinte: $won su $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'other': '$nº',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'La migliore Guinea';

  @override
  String get campaignGuineasTwist =>
      'La Guinea Equatoriale, la più piccola delle Guinee africane, per due cicli';

  @override
  String get campaignGuineasGoal => 'Battere la Guinea e la Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Tre nazioni africane portano il nome Guinea, e la Guinea Equatoriale è la più piccola. Hai due cicli per battere almeno una volta la Guinea e la Guinea-Bissau, poi vedere fin dove arrivi nel Campionato africano. La Papua Nuova Guinea, la quarta Guinea, è già in calendario per un\'amichevole.';

  @override
  String get campaignStars1Guineas => 'Battere la Guinea e la Guinea-Bissau';

  @override
  String get campaignStars2Guineas =>
      'E qualificarsi per un Campionato africano';

  @override
  String get campaignStars3Guineas =>
      'E raggiungere i quarti di finale di un Campionato africano';

  @override
  String get campaignYoungFinnsTitle => 'Giovani finlandesi';

  @override
  String get campaignYoungFinnsTwist =>
      'La generazione d\'oro di adolescenti della Finlandia, per tre cicli';

  @override
  String get campaignYoungFinnsGoal =>
      'Qualificarsi per un Campionato del mondo';

  @override
  String get campaignYoungFinnsIntro =>
      'I senatori della Finlandia si sono fatti da parte e una generazione d\'oro ha preso il loro posto: ogni giocatore che puoi convocare ha 18 anni o meno. Oggi sono ancora acerbi, ma hanno il talento per diventare una delle migliori nazionali del mondo, come ha fatto la giovane generazione della Norvegia. Hai tre cicli per portarli a un Campionato del mondo, poi vincere il Campionato europeo e il Campionato del mondo.';

  @override
  String get campaignStars1YoungFinns =>
      'Qualificarsi per un Campionato del mondo';

  @override
  String get campaignStars2YoungFinns => 'Vincere il Campionato europeo';

  @override
  String get campaignStars3YoungFinns => 'Vincere il Campionato del mondo';

  @override
  String get campaignGreenlandTitle => 'Un secolo groenlandese';

  @override
  String get campaignGreenlandTwist =>
      'La Groenlandia prende il posto di San Marino in Europa, per cento anni';

  @override
  String get campaignGreenlandGoal => 'Qualificarsi per un Campionato europeo';

  @override
  String get campaignGreenlandIntro =>
      'La Groenlandia non ha mai giocato una partita internazionale ufficiale. In questo mondo ha preso il posto di San Marino in Europa e parte dall\'ultimo gradino del ranking mondiale: giocatori dilettanti, campi in sintetico e una stagione stretta tra una nevicata e l\'altra. Hai cento anni, venticinque cicli, per arrivare a un Campionato europeo, poi a un Campionato del mondo e, se osi sognare, vincerne uno.';

  @override
  String get campaignStars1Greenland =>
      'Qualificarsi per un Campionato europeo';

  @override
  String get campaignStars2Greenland =>
      'Qualificarsi per un Campionato del mondo';

  @override
  String get campaignStars3Greenland =>
      'Vincere il Campionato europeo o il Campionato del mondo';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Non qualificata';

  @override
  String get campaignCupOpen => 'Da decidere';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name brilla con la nazionale $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Rapporto dal vivaio: $name si fa notare';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Il migliore della $level: $name';
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
      other: '$count volte',
      one: 'una volta',
    );
    return '$name è andato a segno $_temp0 con la $level contro $opponent nell\'ultima finestra internazionale.';
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
      other: '$count gol',
      one: 'Un gol',
    );
    return '$_temp0 di $name nella partita della $level contro $opponent in questa finestra.';
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
      other: '$count gol',
      one: 'un gol',
    );
    return 'La $level ha affrontato $opponent, e $name se n\'è andato con $_temp0 a referto.';
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
      other: '$count assist',
      one: 'un assist',
    );
    return '$name ha servito $_temp0 con la $level contro $opponent e ha diretto la partita dall\'inizio alla fine.';
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
      other: '$count assist',
      one: 'un assist',
    );
    return 'La $level ha incontrato $opponent in questa finestra, e a tirare le fila c\'era $name: $_temp0 e una prestazione di cui lo staff parla ancora.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name è stato eccezionale nella partita in cui la $level non ha subito gol contro $opponent.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Porta inviolata per la $level contro $opponent, e il merito è in gran parte di $name.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name ha impressionato con la $level contro $opponent, e lo staff gli ha dato $mark su dieci.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'La $level ha giocato contro $opponent in questa finestra, e i tecnici hanno indicato $name: $mark su dieci, il voto più alto della squadra.';
  }

  @override
  String get newsYouthDevReady1 =>
      'Con questo rendimento è già abbastanza bravo per entrare nei pensieri della nazionale maggiore.';

  @override
  String get newsYouthDevReady2 =>
      'Lo staff crede che sia già pronto per il calcio dei grandi. La scelta è tua.';

  @override
  String get newsYouthDevClose1 =>
      'Sta crescendo bene ed è vicino al salto in nazionale maggiore.';

  @override
  String get newsYouthDevClose2 =>
      'Non gli manca molto per la nazionale maggiore, e un\'altra buona stagione potrebbe bastare.';

  @override
  String get newsYouthDevGrowing1 =>
      'Si sta sviluppando bene, anche se alla nazionale maggiore mancano ancora un paio di passi.';

  @override
  String get newsYouthDevGrowing2 =>
      'C\'è ancora lavoro da fare prima che diventi un nazionale maggiore, ma tutto va nella direzione giusta.';

  @override
  String get newsYouthDevRaw1 =>
      'È ancora acerbo e a qualche anno dalla nazionale maggiore, ma il talento si vede.';

  @override
  String get newsYouthDevRaw2 =>
      'È presto, e i tecnici del vivaio chiedono pazienza, non titoli.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'L\'apertura alare e il dominio dell\'area sono ciò che lo distingue.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'La presa e il gioco con i piedi sono i migliori che il vivaio abbia visto da anni.';

  @override
  String get newsYouthStrengthGkStamina =>
      'La sua concentrazione non cala mai: al novantesimo è lucido come al primo minuto.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Velocità e gioco aereo sono la chiave del suo calcio.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Legge il gioco molto oltre la sua età ed è tranquillo palla al piede.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Non stacca mai la spina e all\'ultimo minuto rientra ancora di corsa.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Recupera palloni con vera potenza e li porta subito in avanti.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Visione e varietà di passaggi sono la chiave del suo calcio.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Ha un motore incredibile: copre ogni filo d\'erba.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Velocità in profondità e forza nel gioco aereo lo rendono un problema per qualsiasi difesa.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Finalizzazione e movimenti in area sono la chiave del suo calcio.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Pressa dal primo all\'ultimo minuto e non lascia respiro ai difensori.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'I tifosi canteranno a lungo di questa partita contro $opponent. Cosa ha detto ai giocatori al fischio finale?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'È stato un messaggio forte contro $opponent. Quanto è nato in allenamento?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Complimenti per il risultato contro $opponent, ma serate così le abbiamo già viste. Cosa c\'è di diverso questa volta?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Tutti hanno una serata storta, e questa contro $opponent lo è stata. Quanto in fretta riuscirà a voltare pagina?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent è stato migliore in ogni reparto. Da dove comincia per rimediare?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'I tifosi se ne andavano prima della fine contro $opponent. Può dare loro torto?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'È un periodo difficile, e $opponent non l\'ha reso più facile. Cosa la spinge ad andare avanti?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Un\'altra partita senza vittoria, stavolta contro $opponent. Quanto può durare prima che la federazione intervenga?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Anche $opponent. È rimasto qualcosa nel suo piano, o è ora di lasciare il posto a qualcun altro?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Qualunque cosa scriviate, scrivetela sui giocatori. Se lo sono meritato.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Ho un gruppo che si butterebbe nel fuoco l\'uno per l\'altro. Non è poco.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Le decisioni le prendo io, quindi le critiche spettano a me. È il mestiere.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Guardate prima il commissario tecnico. Ho sbagliato alcune cose e le sistemerò.';

  @override
  String get pressReplyDemandMore5 =>
      'Qui bene non basta. Gliel\'ho detto in faccia.';

  @override
  String get pressReplyDemandMore6 =>
      'Nessuno in quello spogliatoio ha il posto garantito. Adesso lo sanno.';

  @override
  String get pressReplyDeflect5 =>
      'Potete chiederlo in tre modi diversi. La risposta sarà la stessa.';

  @override
  String get pressReplyDeflect6 =>
      'I miei pensieri li tengo per i giocatori. Capirete.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score contro $opponent. Calcio calmo, controllato, maturo. Che bello.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return 'Battuto $opponent $score senza sudare. Questa squadra sta diventando brava a essere noiosa, e la noia vince i trofei.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Tre punti, zero drammi, e si torna al lavoro.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Un $score di routine contro $opponent. Nessuno se lo ricorderà e nessuno ne ha bisogno.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score contro $opponent e in qualche modo sono comunque preoccupato.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return 'Battuto $opponent $score. Contro una squadra vera, una prestazione così si paga.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score contro $opponent. Denti stretti, sofferenza, vittoria. Questa è una squadra.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return 'Battuto $opponent $score solo di nervi. Mi tengo una squadra che si rifiuta di perdere.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Fino all\'ultimo secondo, ma i punti sono nostri.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Un $score di misura contro $opponent. Poca differenza, ed è il calcio.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score contro $opponent. Un rimbalzo fortunato dall\'altra parte e staremmo facendo tutt\'altro discorso.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Abbiamo resistito a fatica contro $opponent, $score. Nessuno la chiami prestazione.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score con $opponent. Non è una sconfitta, e certi giorni il lavoro è questo.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Un punto sudato contro $opponent, $score. Mi è piaciuta la grinta.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Punti divisi, come dicevano i telecronisti di una volta.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score con $opponent. Nessuna delle due ha fatto abbastanza per meritare di più.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score con $opponent. Uno di quei pareggi che sul pullman del ritorno sanno di sconfitta.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Pari $score con $opponent. Continuiamo a parlare di progressi e continuiamo a fare questo.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score contro $opponent. Fa male, ma ho visto abbastanza per credere in questa squadra.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Battuti $score da $opponent, ed erano bravi. Riconoscerlo e ripartire.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Una sconfitta, qualche lezione, e la prossima partita presto.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Persa $score contro $opponent. Poco da discutere.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score contro $opponent. Gli stessi errori dell\'ultima volta, fatti con la stessa sicurezza.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Battuti $score da $opponent. Se nessuno deve risponderne, cosa stiamo facendo?';
  }

  @override
  String get yReactionShrug12 =>
      'A me va bene. Non tutte le sere servono i fuochi d\'artificio.';

  @override
  String get yReactionShrug13 => 'I punti sono punti. Stanotte dormo bene.';

  @override
  String get yReactionShrug14 => 'Visto. Nessun commento.';

  @override
  String get yReactionShrug15 => 'A metà tra normale e normale.';

  @override
  String get yReactionShrug16 =>
      'Ho pagato lo streaming per questo. Mai più (tornerò).';

  @override
  String get yReactionShrug17 => 'Novanta minuti di nulla a forma di calcio.';

  @override
  String get yReactionRelief12 =>
      'Respiro di nuovo. Orgoglioso che abbiano tenuto.';

  @override
  String get yReactionRelief13 =>
      'Sono queste le vittorie che fanno una squadra. Il brutto è bello.';

  @override
  String get yReactionRelief14 => 'Le unghie non ci sono più, i punti sì.';

  @override
  String get yReactionRelief15 => 'Mai un fischio finale è suonato così bene.';

  @override
  String get yReactionRelief16 =>
      'Contento di aver vinto, preoccupato per come.';

  @override
  String get yReactionRelief17 =>
      'Continuiamo a cavarcela. Un giorno non andrà così.';

  @override
  String get yReactionFury12 =>
      'Amo questa squadra, ed è proprio per questo che fa male.';

  @override
  String get yReactionFury13 =>
      'Serata storta. La prossima ce ne devono una, e lo sanno.';

  @override
  String get yReactionFury14 =>
      'Spento al settantesimo. Dovevo farlo al sessantesimo.';

  @override
  String get yReactionFury15 => 'Niente lotta, niente idee, niente scuse.';

  @override
  String get yReactionFury16 =>
      'Sempre gli stessi problemi, e nessuno risolve niente.';

  @override
  String get yReactionFury17 =>
      'Qualcuno in federazione deve rivedere questa partita e spiegarcela.';

  @override
  String get backupShareHint =>
      'Crea un file di backup con tutti i salvataggi. Scegli Google Drive, iCloud Drive o File per conservarlo.';

  @override
  String backupLastAt(String date) {
    return 'Ultimo backup: $date';
  }

  @override
  String get backupNever => 'Ancora nessun backup';

  @override
  String get backupRemindersTitle => 'Promemoria di backup';

  @override
  String get backupRemindersBlurb =>
      'Un messaggio nella posta quando l\'ultimo backup inizia a essere vecchio.';

  @override
  String get backupAutoICloudTitle => 'Backup automatico su iCloud';

  @override
  String get backupAutoDriveTitle => 'Backup automatico su Google Drive';

  @override
  String get backupAutoBlurb =>
      'Esegue il backup dopo le partite, a fine ciclo e quando esci dall\'app. Tiene gli ultimi due.';

  @override
  String get backupStatusUploading => 'Backup in corso.';

  @override
  String get backupStatusUploaded => 'Backup eseguito.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud è spento. Accedi a iCloud e attiva iCloud Drive nell\'app Impostazioni.';

  @override
  String get backupStatusDriveSignedOut =>
      'Accesso non effettuato. Attiva l\'interruttore per accedere con Google.';

  @override
  String get backupStatusNotConfigured =>
      'Non ancora disponibile in questa versione dell\'app.';

  @override
  String get backupStatusUnavailable =>
      'Il cloud non è raggiungibile ora. Riproverà più tardi.';

  @override
  String get backupStatusFailed =>
      'L\'ultimo backup automatico non è andato a buon fine. Riproverà più tardi.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Accesso come $email';
  }

  @override
  String get backupDriveSignOut => 'ESCI';

  @override
  String get backupDriveSignInFailed =>
      'L\'accesso con Google non è riuscito. Riprova più tardi.';

  @override
  String get backupRestoreICloud => 'RIPRISTINA DA ICLOUD';

  @override
  String get backupRestoreDrive => 'RIPRISTINA DA GOOGLE DRIVE';

  @override
  String get backupCrossPlatformHelp =>
      'Passi da iPhone ad Android o viceversa? Fai il backup su file in un telefono e ripristina da quel file sull\'altro.';

  @override
  String get backupCloudListBlurb =>
      'I backup dei tuoi dispositivi su questo account. Toccane uno per ripristinarlo.';

  @override
  String get backupCloudListEmpty =>
      'Nessun backup trovato. Un nuovo backup può impiegare qualche minuto ad arrivare su un altro dispositivo.';

  @override
  String get backupCloudListFailed =>
      'Impossibile leggere i backup. Controlla la connessione e riprova.';

  @override
  String get backupCloudThisDevice => 'Questo dispositivo';

  @override
  String backupCloudMore(int count) {
    return 'Altri salvataggi: $count';
  }

  @override
  String get backupCloudNewer =>
      'Creato da una versione più recente dell\'app. Aggiorna prima.';

  @override
  String get backupCloudDownloading => 'Recupero del backup.';

  @override
  String get backupRestoreSafetyNote =>
      'Prima viene conservata su questo telefono una copia dei salvataggi attuali.';

  @override
  String get backupRejectedSafety =>
      'Impossibile conservare una copia dei salvataggi attuali, quindi non è stato sostituito nulla.';

  @override
  String get newsBackupReminderTitle => 'È ora di un backup';

  @override
  String get newsBackupReminderBody =>
      'I tuoi salvataggi sono solo su questo telefono. Apri Impostazioni e tocca Backup nel cloud, oppure attiva lì il backup automatico. Questi promemoria si possono anche disattivare nelle Impostazioni.';

  @override
  String get backupSafetyTitle => 'Copie di prima di un ripristino';

  @override
  String get backupSafetyBlurb =>
      'Conservate su questo telefono nel caso un ripristino fosse sbagliato. Si tengono le tre più recenti.';

  @override
  String get backupSafetyRestore => 'RIPRISTINA';

  @override
  String get backupSafetyShare => 'CONDIVIDI';

  @override
  String get backupCloudNoDetails => 'I dettagli sono ancora in arrivo.';

  @override
  String get tacticsLibraryTitle => 'LIBRERIA TATTICHE';

  @override
  String get tacticsLibraryBlurb =>
      'Le tattiche della tua libreria si possono caricare in qualsiasi salvataggio, anche nuovo. Compiti e battitori dei calci piazzati sono salvati per ruolo in campo, non per giocatore.';

  @override
  String get tacticsSaveToLibrary => 'Salva in libreria';

  @override
  String get tacticsLoadFromLibrary => 'Carica dalla libreria';

  @override
  String get tacticsLibraryEmpty =>
      'La tua libreria è vuota. Salva qui una tattica e potrai caricarla in qualsiasi salvataggio.';

  @override
  String tacticsLibrarySaved(String name) {
    return '“$name” salvata in libreria';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Caricata “$name”';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count compiti o battitori non si adattavano a questa rosa.',
      one: '1 compito o battitore non si adattava a questa rosa.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Rinomina';

  @override
  String get tacticsLibraryRenameTitle => 'Rinomina tattica';

  @override
  String get tacticsLibraryDelete => 'Elimina';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Eliminare “$name”?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Sparirà dalla libreria in tutti i tuoi salvataggi.';

  @override
  String get tacticsLibraryNameTaken =>
      'Nella tua libreria c\'è già una tattica con questo nome.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Impossibile caricare la libreria.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Candidatura per ospitare: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Candidatura';

  @override
  String get hostBidBlurb =>
      'Il paese ospitante viene sorteggiato tra i candidati. Una candidatura dà più peso al tuo nome: i tuoi stadi ti danno una probabilità di partenza e il denaro la aumenta, anche se ogni milione in più conta un po\' meno. Il denaro è speso, che tu vinca o no.';

  @override
  String hostBidPrize(String amount) {
    return 'Se vinci, ospiti il torneo, ti qualifichi automaticamente e ricevi un contributo unico di $amount per il prossimo budget.';
  }

  @override
  String get hostBidChance => 'Probabilità di ospitare';

  @override
  String get hostBidBaseLabel => 'Stadi e prestigio';

  @override
  String get hostBidInvestLabel => 'Investimento';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Tetto per $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Il tuo investimento';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Fondi liberi: $amount';
  }

  @override
  String get hostBidSubmit => 'Presenta la candidatura';

  @override
  String get hostBidDecline => 'Non questa volta';

  @override
  String get hostBidUnavailable => 'Questa candidatura non è più aperta.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Candidatura vinta: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Ospiteremo il torneo e, come paese ospitante, siamo qualificati automaticamente. Un contributo unico di $amount è ora nelle casse della federazione e puoi assegnarlo ai reparti di questo ciclo direttamente dalla schermata principale.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Candidatura persa: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Il torneo è stato assegnato a: $hosts. Questa volta la nostra candidatura non è bastata e il denaro investito è perso, ma la federazione ha fatto valere le sue ragioni.';
  }

  @override
  String get hostBidGrantEvent => 'Assegna il contributo per l\'organizzazione';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Contributo per l\'organizzazione: $amount da aggiungere subito ai reparti di questo ciclo. Quanto già assegnato resta, il resto rimane in cassa.';
  }

  @override
  String get stadiumsTitle => 'Stadi nazionali';

  @override
  String get stadiumsEntrySub => 'Migliora uno stadio o costruiscine uno nuovo';

  @override
  String get stadiumsBlurb =>
      'Il livello di uno stadio è la sua capienza: livello 1 sotto i 15.000 posti, livello 2 da 15.000, livello 3 da 25.000, livello 4 da 40.000, livello 5 da 60.000. Ogni stadio rende una piccola entrata all\'inizio di ogni ciclo, di più con più posti, finché i tuoi tifosi li riempiono. Un ampliamento aggiunge posti subito e un po\' di reputazione dal ciclo successivo; un ridimensionamento taglia i costi di gestione ma non rimborsa nulla. I tuoi stadi decidono per quali tornei puoi candidarti.';

  @override
  String stadiumsIncome(String amount) {
    return 'Entrate dagli stadi: $amount a ciclo';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Reputazione dagli stadi: +$points';
  }

  @override
  String get stadiumsClosed =>
      'I lavori si ordinano all\'inizio di un ciclo, prima di fissare il budget.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Capienza: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Livello $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Migliora: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Livello massimo';

  @override
  String stadiumsOpens(int year) {
    return 'In costruzione, apre nel $year';
  }

  @override
  String get stadiumsBuildTitle => 'Costruisci un nuovo stadio';

  @override
  String get stadiumsBuildBody =>
      'Piuttosto costoso: un nuovo stadio nella città che scegli, aperto dall\'inizio del prossimo ciclo.';

  @override
  String get stadiumsBuildCity => 'Città';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Costruisci: $cost';
  }

  @override
  String get stadiumsBuilding => 'Uno stadio è già in costruzione.';

  @override
  String get stadiumsNoCity => 'Ogni città ha già un nuovo stadio.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Migliorare $stadium al livello $level per $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Costruire un nuovo stadio a $city per $cost?';
  }

  @override
  String get stadiumsConfirm => 'Conferma';

  @override
  String get stadiumsCancel => 'Annulla';

  @override
  String get stadiumsRefused =>
      'L\'ordine non è andato a buon fine. Non è stato addebitato nulla.';

  @override
  String get stadiumsNameLabel => 'Nome dello stadio';

  @override
  String get stadiumsNameHint => 'Lascia vuoto per tenere il nome proposto.';

  @override
  String get stadiumsRename => 'Rinomina lo stadio';

  @override
  String get hostBidSectionTitle => 'Candidature per ospitare';

  @override
  String get hostBidOpenSub =>
      'Facoltativo. Decidi prima che inizi il nuovo ciclo.';

  @override
  String get hostBidDecidedAtRollover =>
      'Il paese ospitante viene annunciato all\'inizio del nuovo ciclo.';

  @override
  String get hostBidLodged =>
      'Candidatura presentata. Il paese ospitante viene annunciato all\'inizio del nuovo ciclo.';

  @override
  String get hostBidDeclinedNote =>
      'Questa volta hai scelto di non candidarti.';

  @override
  String get hostBidOpensLater =>
      'Requisiti soddisfatti. Potrai candidarti alla fine di questo ciclo.';

  @override
  String get hostBidNoFunds => 'Fondi liberi insufficienti per candidarsi.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ti mancano ancora $count stadi da $seats+ posti.',
      one: 'Ti manca ancora 1 stadio da $seats+ posti.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation ha ospitato l\'ultimo Campionato del mondo.';
  }

  @override
  String get hostBidRecentHost => 'Hai ospitato una delle ultime tre edizioni.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Requisito: $grounds stadi da $minSeats+ posti, di cui $bigGrounds da $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Ospiteremo il torneo e siamo qualificati di diritto come paese ospitante. Un contributo una tantum di $amount è già nei fondi della federazione, pronto per il budget di questo ciclo.';
  }

  @override
  String get hubStadiumIncome => 'Entrate degli stadi';

  @override
  String get stadiumsDownsize => 'Ridimensiona';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Ridimensionare $stadium a $seats posti (livello $level)? Non viene rimborsato nulla, ma i costi di gestione calano.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Ristrutturato in questo ciclo';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Rende $amount a ciclo';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Candidatura ritirata: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'La candidatura era per $nation, ma inizi il nuovo ciclo altrove. È stata ritirata e non è stato addebitato nulla.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'Alla chiusura del ciclo i fondi della federazione non coprivano più la puntata. La candidatura è stata ritirata e non è stato addebitato nulla.';

  @override
  String get stadiumsViewMap => 'Mappa';

  @override
  String get stadiumsViewList => 'Elenco';

  @override
  String get stadiumsMapPickCity =>
      'Tocca una città per costruirci un nuovo stadio.';

  @override
  String get stadiumsMapFit => 'Mostra tutto il paese';

  @override
  String get campaignLegacyTitle => 'Completare l’eredità';

  @override
  String get campaignLegacyTwist =>
      'La Spagna, campione d’Europa in carica, per un ciclo';

  @override
  String get campaignLegacyGoal => 'Difendere il titolo europeo';

  @override
  String get campaignLegacyIntro =>
      'La Spagna è campione d’Europa in carica e gli scettici parlano di un exploit irripetibile. Hai un ciclo per dimostrare il contrario: difendi la corona continentale, poi punta al mondo. Aggiungi la Coppa delle Nazioni e l’eredità sarà completa.';

  @override
  String get campaignStars1Legacy => 'Vincere il Campionato europeo';

  @override
  String get campaignStars2Legacy => 'E il Campionato del mondo';

  @override
  String get campaignStars3Legacy => 'E la Coppa delle Nazioni';

  @override
  String get campaignSectionOneCycle => 'Un ciclo';

  @override
  String get campaignSectionShort => 'Pochi cicli';

  @override
  String get campaignSectionLong => 'Lungo corso';

  @override
  String get campaignFilterAll => 'Tutte';

  @override
  String get campaignFilterNew => 'Mai giocate';

  @override
  String get campaignFilterInProgress => 'In corso';

  @override
  String get campaignFilterDone => 'Completate';

  @override
  String get campaignFilterEmpty => 'Ancora nessuna campagna qui.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stelle',
      one: '1 stella',
      zero: 'Nessuna stella',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cicli',
      one: '1 ciclo',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Se ne va al top, da campione.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Mancare la fase finale è stata la goccia che ha fatto traboccare il vaso.';

  @override
  String get msgIntlRetireNoteSurprise => ' Nessuno se lo aspettava.';

  @override
  String get msgIntlRetireNoteRecord =>
      ' Lascia da primatista della nazionale.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name lascia la nazionale';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) ha annunciato l\'addio alla nazionale a $age anni.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name torna in nazionale';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name è di nuovo convocabile, a $age anni.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Con la squadra decimata dagli infortuni, ha risposto alla chiamata.';

  @override
  String get msgIntlComebackNoteManager => ' Il nuovo CT lo ha convinto.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name torna in nazionale';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) è di nuovo convocabile, a $age anni.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Ritirato dalla nazionale, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Tornato in nazionale, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Grazie, $name. C\'è chi indossa la maglia e chi se la carica sulle spalle.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name chiude con la nazionale. Finisce un\'epoca.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name si ritira. Un torneo troppo tardi, a dirla tutta.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Quindi $name ha chiuso. Spazio ai giovani.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitudine $altitudeString m: gli avversari si stancheranno prima';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitudine $altitudeString m: i tuoi giocatori si stancheranno prima';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitudine $altitudeString m: entrambe le squadre si stancheranno prima';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Altitudine $altitudeString m: entrambe le squadre ci sono abituate';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Caldo: previsti $tempString °C, le gambe cederanno prima';
  }

  @override
  String get matchConditionsAdvice =>
      'Pianifica presto i cambi: qui le gambe fresche contano di più';

  @override
  String get fanMoodFurious => 'furiosi';

  @override
  String get fanMoodRestless => 'inquieti';

  @override
  String get fanMoodCalm => 'tranquilli';

  @override
  String get fanMoodUpbeat => 'fiduciosi';

  @override
  String get fanMoodEuphoric => 'euforici';

  @override
  String matchHomeFans(String mood) {
    return 'Tifosi di casa: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Tifosi: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Incassi degli stadi nel prossimo ciclo: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Vent\'anni a seguire la Nazionale in casa e in trasferta. Non rinnovo l\'abbonamento finché qualcosa non cambia.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Continueremo a cantare per la maglia. Ma lo striscione in curva nord stasera ha detto quello che pensiamo tutti.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Mezzo stadio vuoto, e l\'altra metà ha passato il secondo tempo a cantare #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'I gruppi organizzati parlano di boicottare la prossima partita in casa. Difficile dargli torto.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Non sono nemmeno più arrabbiato. Basta.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Foto di stasera: file di seggiolini vuoti e un lenzuolo con scritto #${manager}Out. Questa è la cronaca.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Di nuovo tutto esaurito. La miglior Nazionale da anni, e tutto il paese lo sa.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'La prossima partita in casa è andata esaurita in undici minuti. Questa squadra ci ha ridato i weekend.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Nemmeno un posto libero per la prossima in casa. La federazione conterà l\'incasso col sorriso.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Un altro tutto esaurito. Dite quel che volete della tattica: la gente vuole esserci.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Tutto esaurito, va bene. Gli stessi che fischiavano questa squadra un anno e mezzo fa.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'All\'improvviso tutto esaurito, all\'improvviso tutti esperti. Dov\'eravate quando non battevamo nessuno?';
  }

  @override
  String get campaignsIntro =>
      'Le campagne sono sfide costruite a mano: una nazionale fissa, un mondo con il suo colpo di scena e un obiettivo da raggiungere in un numero fisso di cicli. Ogni partita resta separata dalle tue carriere salvate, e più vai avanti, più stelle guadagni, fino a tre.';

  @override
  String hubEventScandal(String player) {
    return 'Scandalo in ritiro: $player';
  }

  @override
  String get hubEventScandalSub => 'Mandarlo a casa o tenerlo?';

  @override
  String get scandalTitle => 'SCANDALO IN RITIRO';

  @override
  String scandalStoryParty(String player) {
    return '$player era a una festa andata avanti fino all\'alba, e la mattina del raduno le foto erano su tutti i giornali.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player ha violato il coprifuoco ed è stato sorpreso a rientrare in albergo nel cuore della notte.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player è stato fotografato in discoteca alla vigilia del raduno, e le immagini sono ovunque.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player ha passato la notte prima del raduno al tavolo di un casinò, e un tabloid ha le foto.';
  }

  @override
  String get scandalSendHome => 'Mandalo a casa';

  @override
  String scandalSendHomeCover(String player) {
    return 'A casa, convoca $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Tieni $player';
  }

  @override
  String get scandalKeepNote =>
      'Se resta: morale circa -4 e federazione circa -3 fino alla fine del ciclo.';

  @override
  String get scandalSendHomeNote =>
      'Se lo mandi a casa: nessun costo per il morale o la federazione, e puoi convocare un sostituto.';

  @override
  String get scandalFinalsNote =>
      'Se lo mandi a casa: nessun costo per il morale o la federazione, ma in una fase finale nessuno può sostituirlo.';

  @override
  String get scandalPickCover => 'Convoca un sostituto (facoltativo)';

  @override
  String newsScandalTitle(String player) {
    return 'Scandalo in ritiro: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Sono ragazzi. $player a una festa la sera prima del raduno, e io lo voglio comunque in campo. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player fotografato a una festa fino all\'alba poche ore prima del raduno. La federazione è stata informata. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Festa fino all\'alba prima del raduno. $player, ma cosa ti è passato per la testa? Incredibile. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Rientrato dopo il coprifuoco, va bene, capita. $player deve solo rimediare in campo. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player sorpreso a rientrare nell\'albergo della squadra dopo il coprifuoco, poche ore prima dell\'allenamento. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Il coprifuoco non è complicato. $player non ha retto nemmeno una notte. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'E va bene, $player era in discoteca. Anche i calciatori hanno una vita. Fatelo giocare. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Alcune foto mostrano $player in discoteca alla vigilia del raduno della nazionale. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Foto in discoteca alla vigilia del raduno. $player ha fatto vergognare la maglia. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Una notte al casinò non è un reato. $player se la caverà. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player avvistato al tavolo di un casinò la notte prima del raduno. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Tutta la notte al casinò prima del raduno. $player si è giocato più dei soldi. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Decisione giusta. Nessuno è più grande della squadra, nemmeno $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Mandare a casa $player era l\'unica risposta. Rispetto per il ct.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'La disciplina è la disciplina. $player conosceva le regole.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Un messaggio chiaro al gruppo: $player è sull\'aereo per casa.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Dura per $player. Una serata fuori e il ritiro è finito?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Mandare a casa $player ci indebolisce. Lo pagheremo in campo.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Tenere $player è una scommessa. Farà bene a ripagarla in campo.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Va bene, $player resta. Allora deve a tutti una grande partita.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Quindi le regole non valgono per $player. Buono a sapersi.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Il coprifuoco ormai è facoltativo, a quanto pare. Chiedete a $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Tenere $player dopo questo? Questa nazionale è un villaggio vacanze.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Festa tutta la notte e poi dritto tra i titolari. Bel messaggio, mister. $player sarà contentissimo.';
  }

  @override
  String get yStreamerBreaks0 =>
      'IL FRATELLO È STATO BECCATO 😭😭 LA NOTTE PRIMA DEL RADUNO?? STO PIANGENDO 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'NOOO CHAT GUARDATE QUA 🤯🤯 IL FRATELLO L\'HA FATTO DAVVERO PRIMA DEL RADUNO 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'CHI L\'HA FATTO USCIRE?? CHI L\'HA FATTO USCIRE 😭😭💀 QUESTO È CINEMA 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'A CASA?? A CASA!!! 😭😭😭 IL MISTER NON SCHERZA 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'IL FRATELLO FA LE VALIGIE IN DIRETTA 🤯🤯 CIAO FRATELLO 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'NON CI CREDOOO L\'HANNO MANDATO A CASA 💀💀 CHAT STO TREMANDO 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'RESTA??? RESTAAA 🤯🤯 IL FRATELLO È INTOCCABILE 😭🔥';

  @override
  String get yStreamerKept1 =>
      'FESTA TUTTA LA NOTTE E ANCORA IN SQUADRA 💀💀 VOGLIO QUEL CONTRATTO 😭😭';

  @override
  String get yStreamerKept2 =>
      'IL MISTER DICE CHE VA TUTTO BENE 😭😭 FRATELLO COSA 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'Non ho pagato niente, e quella cifra non torna nemmeno';

  @override
  String get yCameoHavir0 => 'I pesciolini se ne sono andati a nuoto.';

  @override
  String get yCameoHavir1 => 'Abbiamo gettato le reti, i pesci erano altrove.';

  @override
  String get yCameoHavir2 =>
      'L\'avevo detto già a settembre, davanti a un gulasch.';

  @override
  String get yCameoHavir3 => 'Chi non ha pescato in tempo, ora non pianga.';

  @override
  String get yCameoHavir4 =>
      'Abbiamo giocato come un pesce siluro all\'asciutto.';

  @override
  String get yCameoHavir5 =>
      'Soffia il vento, gela lo stagno. Così va il mondo.';

  @override
  String get yCameoHavir6 => 'Certi giorni tiri su solo un vecchio stivale.';

  @override
  String get yCameoHavir7 =>
      'Ai miei tempi almeno si andava a bere una birra. Adesso nemmeno quello.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Mandare a casa un ragazzo per una sera? Lo scandalo è questo, non la festa!';

  @override
  String get yCameoLzimberskyHome1 =>
      'I ragazzi avranno pure il diritto di divertirsi! I media ipocriti vincono ancora.';

  @override
  String get yCameoLzimberskyHome2 =>
      'È una caccia alle streghe. Un ragazzo esce una sera e lo impiccate.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Il giornalista che non è mai andato a una festa scagli la prima pietra. Vergogna!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Il ct ha avuto paura dei tabloid. Io il ragazzo l\'avrei difeso fino all\'ultimo respiro!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Finalmente un ct con la spina dorsale! Ha tenuto il ragazzo e i media possono piangere.';

  @override
  String get yCameoLzimberskyKept1 =>
      'I ragazzi avranno pure il diritto di divertirsi, no? Bravo, mister!';

  @override
  String get yCameoLzimberskyKept2 =>
      'I media ipocriti urlano, il ct tiene duro. Così si fa!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Una sera fuori e la stampa vuole lapidarlo. Il ct è un vero uomo!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Io dico: lasciate vivere i ragazzi! Chi lavora sodo può anche divertirsi. Pollice in su.';

  @override
  String get yTraitStreamer =>
      'Trasmette tutto in diretta, a tutto volume, in maiuscolo.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Giocatore dell\'anno $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'I voti sono stati contati';

  @override
  String get potyCeremonyWatch => 'Guarda la cerimonia';

  @override
  String get potyCeremonySkipToList => 'Vai alla top 5';

  @override
  String get potyCeremonySkip => 'Salta';

  @override
  String get potyCeremonyIntro =>
      'I voti sono stati contati. Ecco i cinque migliori giocatori del mondo di quest\'anno.';

  @override
  String potyCeremonyPlace(int place) {
    return '$place° posto';
  }

  @override
  String get potyCeremonyWinnerIs => 'E il Giocatore dell\'anno è...';

  @override
  String get potyTop5Heading => 'La top 5 del mondo';

  @override
  String get potyYoungTop3Heading => 'Giovane dell\'anno: top 3';

  @override
  String get potySeeTop5 => 'Vedi la top 5';

  @override
  String get potyYourPlayer => 'Il tuo giocatore';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count porte inviolate',
      one: '1 porta inviolata',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Brief completo';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Stelle ottenute finora: $earned su $total';
  }

  @override
  String get campaignStarEarned => 'Ottenuta finora';

  @override
  String get campaignStarNotYet => 'Non ancora ottenuta';

  @override
  String get stadiumsEntrySubClosed =>
      'Guarda i tuoi stadi. I lavori riaprono all\'inizio del prossimo ciclo.';

  @override
  String get boardObjectiveNoBrief => 'Nessun obiettivo fissato';

  @override
  String get boardObjectiveNoBriefBody =>
      'La federazione non si aspetta che tu arrivi a questa fase finale. Ti giudicherà invece sui risultati.';

  @override
  String get boardObjectiveAwaitingDraw => 'Obiettivo dopo il sorteggio';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'La federazione fisserà questo obiettivo dopo il sorteggio dei gironi.';
}
