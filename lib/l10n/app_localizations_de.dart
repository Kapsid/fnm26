// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get matchPreviewTitle => 'SPIELVORSCHAU';

  @override
  String get matchKickOff => 'Anstoß';

  @override
  String get matchTactics => 'Taktik';

  @override
  String get matchYourXi => 'IHRE ELF';

  @override
  String get matchHeadToHead => 'DIREKTER VERGLEICH';

  @override
  String matchCouldNotLoad(String error) {
    return 'Spiel konnte nicht geladen werden.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Kein anstehendes Spiel.';

  @override
  String get matchUnknownNation => 'Unbekannt';

  @override
  String get matchH2hFirstMeeting => 'Erstes Aufeinandertreffen überhaupt';

  @override
  String get matchH2hYouLead => 'Sie führen im direkten Vergleich';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent hat die Nase vorn';
  }

  @override
  String get matchH2hEven => 'Ausgeglichene Bilanz';

  @override
  String matchH2hMet(int count) {
    return '$count Duelle';
  }

  @override
  String get matchH2hWon => 'Siege';

  @override
  String get matchH2hDrawn => 'Remis';

  @override
  String get matchH2hLost => 'Niederl.';

  @override
  String get matchDossierTitle => 'Scoutingbericht';

  @override
  String get matchDossierForm => 'FORM';

  @override
  String get matchDossierNoGames => 'Keine aktuellen Spiele';

  @override
  String get matchDossierKeyMen => 'SCHLÜSSELSPIELER';

  @override
  String get matchDossierHowTheyPlay => 'SPIELWEISE';

  @override
  String matchScoutFormation1(String formation) {
    return 'Meist laufen sie im $formation auf.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Ihre übliche Formation ist das $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Sie setzen meistens auf ein $formation.';
  }

  @override
  String get matchScoutStrengthPressing =>
      'Sie pressen hoch und jagen den Ball.';

  @override
  String get matchScoutStrengthDirect =>
      'Sie spielen direkt und bringen den Ball früh nach vorn.';

  @override
  String get matchScoutStrengthPossession =>
      'Sie halten den Ball gut und bauen geduldig auf.';

  @override
  String get matchScoutStrengthCounter =>
      'Sie lauern tief und kontern blitzschnell.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Sie verteidigen tief und sind schwer zu knacken.';

  @override
  String get matchScoutStrengthWide =>
      'Sie ziehen das Spiel breit und greifen über die Flügel an.';

  @override
  String get matchScoutStrengthAttacking =>
      'Sie übernehmen gern die Initiative und gehen auf den Gegner los.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Ihre Stürmer sind schnell und laufen gern in die Tiefe.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Ihr Mittelfeld lässt den Ball gut laufen.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Ihr Mittelfeld hat die Kraft, das ganze Spiel durchzulaufen.';

  @override
  String get matchScoutStrengthSetPieces =>
      'Bei Standards sind sie gefährlich.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Ihre Abwehr ist schnell, hinter sie zu kommen ist schwer.';

  @override
  String get matchScoutStrengthNone =>
      'In ihrem Spiel sticht nichts besonders heraus.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Ihre hohe Linie lässt Raum hinter der Abwehr für den langen Ball.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Hohes Pressing kann ihren langsamen Spielaufbau stören.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Geduld zahlt sich aus: Ein so tiefer Block lässt sich auseinandernehmen.';

  @override
  String get matchScoutWeakLongBall =>
      'Ziehen Sie Ihre Linie zurück, dann laufen ihre langen Bälle ins Leere.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Ihren Verteidigern fehlt Tempo, also schicken Sie Läufer in ihren Rücken.';

  @override
  String get matchScoutWeakAerial =>
      'Bei gegnerischen Standards wirken sie wackelig.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Ihr Mittelfeld tut sich schwer, sich aus dem Druck herauszuspielen.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Ihrem Mittelfeld fehlt die Kraft für ein dauerhaftes Pressing.';

  @override
  String get matchScoutWeakBluntAttack => 'Ihren Stürmern fehlt das Tempo.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Gegen Sie werden sie wohl die Initiative übernehmen.';

  @override
  String get matchScoutApproachEven =>
      'Gegen Sie wird es wohl ein enges, ausgeglichenes Spiel.';

  @override
  String get matchScoutApproachSitDeep =>
      'Gegen Sie werden sie wohl vorsichtig agieren und auf Konter lauern.';

  @override
  String get matchScoutLeaningAttacking =>
      'Aus der Ferne wirken sie wie eine offensive Mannschaft.';

  @override
  String get matchScoutLeaningCautious =>
      'Aus der Ferne wirken sie wie eine vorsichtige Mannschaft.';

  @override
  String get matchScoutLeaningUnclear =>
      'Aus der Ferne ist schwer zu sagen, wie sie spielen wollen.';

  @override
  String get matchScoutHireHint =>
      'Stellen Sie einen Chefscout ein, um zu erfahren, wie sie spielen.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Fortsetzen nicht möglich: $error';
  }

  @override
  String get matchSkipToFullTime => 'Zum Abpfiff springen';

  @override
  String get matchStatShots => 'Schüsse';

  @override
  String get matchStatGoals => 'Tore';

  @override
  String get matchStatYellowCards => 'Gelb';

  @override
  String get matchStatRedCards => 'Rot';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'ANG';

  @override
  String get matchSwingDef => 'ABW';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'WELTMEISTERSCHAFT $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'DIE ENDRUNDE IST DA';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'AUSRICHTER  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'AUSRICHTER STEHT NOCH NICHT FEST';

  @override
  String get matchHalfTime => 'HALBZEIT';

  @override
  String get matchContinue => 'Weiter';

  @override
  String get matchContinuing => 'Weiter…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktik · $used/$max Wechsel';
  }

  @override
  String matchTiredCount(int count) {
    return 'MÜDE ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIK';

  @override
  String get teamOverallOverTime => 'GESAMTSTÄRKE IM VERLAUF';

  @override
  String get teamOverall => 'Gesamt';

  @override
  String get teamTalkHeading => 'KABINENANSPRACHE';

  @override
  String get teamTalkPrompt => 'Geben Sie den Ton für die zweite Halbzeit vor.';

  @override
  String get teamTalkCalmLabel => 'Ruhe bewahren';

  @override
  String get teamTalkCalmBlurb =>
      'Das Team stabilisieren. Ein kleiner Schub überall.';

  @override
  String get teamTalkEncourageLabel => 'Ermutigen';

  @override
  String get teamTalkEncourageBlurb => 'Nach vorne spielen und auf Sieg gehen.';

  @override
  String get teamTalkDemandMoreLabel => 'Mehr fordern';

  @override
  String get teamTalkDemandMoreBlurb =>
      'Alles nach vorne werfen. Volle Attacke.';

  @override
  String get teamTalkPraiseLabel => 'Dicht machen';

  @override
  String get teamTalkPraiseBlurb => 'Kompakt bleiben und das Ergebnis halten.';

  @override
  String get teamTalkBelieveLabel => 'Glaubt an euch';

  @override
  String get teamTalkBelieveBlurb =>
      'Selbstvertrauen zeigen. Ein Schub an beiden Enden des Platzes.';

  @override
  String get teamTalkFocusLabel => 'Hellwach bleiben';

  @override
  String get teamTalkFocusBlurb =>
      'Volle Konzentration. Das Spiel kontrollieren.';

  @override
  String get teamTalkUrgencyLabel => 'Druck machen';

  @override
  String get teamTalkUrgencyBlurb =>
      'Jetzt alles reinwerfen. Volles Risiko, das öffnet Räume.';

  @override
  String get teamTalkReassureLabel => 'Kein Druck';

  @override
  String get teamTalkReassureBlurb =>
      'Die Nerven beruhigen und die Ordnung halten.';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonSomethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get commonCrashBox =>
      'Hier ist etwas schiefgelaufen.\nDetails unter Einstellungen → Diagnose.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Die Welt konnte nicht fortgesetzt werden: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnose';

  @override
  String get settingsDiagnosticsBlurb =>
      'Auf diesem Gerät aufgezeichnete Fehler. Es wird nichts gesendet.';

  @override
  String get settingsContactTitle => 'Kontakt';

  @override
  String get settingsContactCopied => 'Adresse kopiert.';

  @override
  String get settingsCommunityTitle => 'Community';

  @override
  String get settingsDiscordSubtitle => 'Tritt der Community bei';

  @override
  String get settingsLinkCopied => 'Link kopiert.';

  @override
  String get diagnosticsEmpty => 'Keine Fehler aufgezeichnet. So soll es sein.';

  @override
  String get diagnosticsCopy => 'Kopieren';

  @override
  String get diagnosticsCopied => 'Protokoll in die Zwischenablage kopiert.';

  @override
  String get diagnosticsClear => 'Leeren';

  @override
  String get navHub => 'Start';

  @override
  String get navSquad => 'Kader';

  @override
  String get navStandings => 'Tabellen';

  @override
  String get navCareers => 'Karriere';

  @override
  String get settingsTitle => 'EINSTELLUNGEN';

  @override
  String get settingsSoundHapticsTitle => 'Ton & Vibration';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibration und ein kurzer Ton bei Toren, Anstoß und Abpfiff.';

  @override
  String get settingsLanguageTitle => 'Sprache';

  @override
  String get settingsLanguageBlurb =>
      'Wählen Sie die App-Sprache oder folgen Sie Ihrem Gerät.';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsTextSizeTitle => 'Textgröße';

  @override
  String get settingsTextSizeBlurb =>
      'Vergrößern Sie den Text, wenn er schwer zu lesen ist.';

  @override
  String get settingsTextSizeNormal => 'Normal';

  @override
  String get settingsTextSizeLarge => 'Groß';

  @override
  String get settingsTextSizeLarger => 'Größer';

  @override
  String get matchPreviewAllMeetings => 'Alle Duelle';

  @override
  String get recordsMeetings => 'DUELLE';

  @override
  String get recordsLegends => 'LEGENDEN';

  @override
  String get recordsAllTimeXi => 'ALL-TIME-ELF';

  @override
  String get recordsHallOfFame => 'RUHMESHALLE';

  @override
  String get recordsAllTimeWorld => 'WELT ALLER ZEITEN';

  @override
  String get recordsAllTimeTopScorers => 'TORJÄGER ALLER ZEITEN';

  @override
  String get recordsMostCapped => 'REKORDNATIONALSPIELER';

  @override
  String get recordsMostWcStarts => 'MEISTE WM-EINSÄTZE';

  @override
  String get recordsMostTournaments => 'MEISTE TURNIERTEILNAHMEN';

  @override
  String get recordsRecordBook => 'REKORDBUCH';

  @override
  String get recordsHeadToHead => 'DIREKTER VERGLEICH';

  @override
  String get recordsFiercestRival => 'ERZRIVALE';

  @override
  String get recordsMostCaps => 'MEISTE LÄNDERSPIELE';

  @override
  String get recordsTopScorers => 'TORJÄGER';

  @override
  String get recordsMostAssists => 'MEISTE VORLAGEN';

  @override
  String get recordsYourRecord => 'IHRE BILANZ';

  @override
  String get callUpHome => 'HEIM';

  @override
  String get callUpAway => 'AUSW.';

  @override
  String get recordsHome => 'HEIM';

  @override
  String get recordsAway => 'AUSW.';

  @override
  String get recordsActive => 'AKTIV';

  @override
  String get recordsStillActive => 'Noch aktiv';

  @override
  String get recordsAvg => 'Ø';

  @override
  String get recordsSelect => 'Wählen';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Remis';

  @override
  String get recordsGoalsLabel => 'Tore';

  @override
  String get recordsBestFinish => 'Bestes Ergebnis';

  @override
  String get recordsNoFinalsYet => 'Noch keine Endrundenteilnahme';

  @override
  String get recordsLongestUnbeaten => 'Längste Serie ohne Niederlage';

  @override
  String get recordsBiggestWin => 'Höchster Sieg';

  @override
  String get recordsSeeAllMeetings => 'Alle Duelle anzeigen';

  @override
  String get recordsSaveNotFound => 'Spielstand nicht gefunden.';

  @override
  String get recordsNoMatches => 'Keine Treffer.';

  @override
  String get recordsSearchPlayerOrNation => 'Spieler oder Nation suchen';

  @override
  String get recordsSearchNation => 'Nation suchen';

  @override
  String get recordsPickTwoDifferent =>
      'Wählen Sie zwei verschiedene Nationen.';

  @override
  String get recordsPlayToBuildRecord =>
      'Bestreiten Sie einige Spiele, dann entsteht hier Ihre Bilanz gegen jeden Gegner.';

  @override
  String get recordsTapOpponent =>
      'Tippen Sie auf einen Gegner für alle Details.';

  @override
  String get recordsEdgeUpperHand => 'Sie haben die Oberhand';

  @override
  String get recordsEdgeTheirNumber => 'Die liegen Ihnen nicht';

  @override
  String get recordsEdgeEven => 'Ausgeglichene Bilanz';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Torjäger & Rekordspieler weltweit, jede Nation';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Vergleichen Sie die ewige Bilanz zweier Nationen';

  @override
  String get recordsLegendsSubtitle => 'All-Time-Elf & Ruhmeshalle';

  @override
  String get recordsUnitGoals => 'Tore';

  @override
  String get recordsUnitCaps => 'Spiele';

  @override
  String get recordsUnitStarts => 'Startelf';

  @override
  String get recordsUnitCups => 'Turniere';

  @override
  String get recordsUnitAssists => 'Vorlagen';

  @override
  String recordsCapsCount(int count) {
    return '$count Länderspiele';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count Tore';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count Vorlagen';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count× Spieler des Spiels';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count Spiele';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count Duelle';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Siege $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings Duelle · ${wins}S ${draws}U ${losses}N';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}S ${draws}U ${losses}N';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings Duelle · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a und $b sind in diesem Spielstand noch nie aufeinandergetroffen.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names vom Platz gestellt. Kein Ersatz möglich, Sie spielen in Unterzahl.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return '$required einsatzfähig nötig ($have fit)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Fehlt $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Fällt für den ganzen Lehrgang aus';

  @override
  String get rankingCentreOnMe => 'Zu meiner Nation';

  @override
  String get recordsAfterExtraTime => 'n. V.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b i. E.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played Spiele · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga gegen $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Laden fehlgeschlagen.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Legenden konnten nicht geladen werden.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Rekorde konnten nicht geladen werden.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Nationen konnten nicht geladen werden.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Ihre Bilanz konnte nicht geladen werden.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Bilanz konnte nicht geladen werden.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Noch keine Legenden. Spielen Sie einige Kampagnen, dann erscheinen hier die Größen von $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Die beste Elf, die $nation je aufbieten könnte.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Die Welt hat noch keine Geschichte. Spielen Sie einige Kampagnen, dann erscheinen hier die Größen aller Zeiten.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Bestreiten Sie einige Spiele, um die Geschichte von $nation zu schreiben.';
  }

  @override
  String get tacticsLineGk => 'TW';

  @override
  String get tacticsLineDef => 'ABW';

  @override
  String get tacticsLineMid => 'MF';

  @override
  String get tacticsLineFwd => 'STU';

  @override
  String get tacticsGoalkeepers => 'TORHÜTER';

  @override
  String get tacticsDefenders => 'ABWEHRSPIELER';

  @override
  String get tacticsMidfielders => 'MITTELFELDSPIELER';

  @override
  String get tacticsForwards => 'STÜRMER';

  @override
  String get tacticsCallUpsTitle => 'NOMINIERUNG';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Wählen Sie mindestens $min Spieler.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Kader konnte nicht geladen werden.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Kein Kader.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'KADER · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min. $min · Max. $max';
  }

  @override
  String get tacticsBestQuality => 'Beste Qualität';

  @override
  String get tacticsPreviousSquad => 'Letzter Kader';

  @override
  String get tacticsSquadLockedBack => 'Zurück (Kader fix)';

  @override
  String get tacticsConfirmSquad => 'Kader bestätigen';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Kader voll (max. $max)';
  }

  @override
  String get tacticsSquadLocked => 'KADER FESTGELEGT';

  @override
  String get tacticsNominationOpen =>
      'NOMINIERUNG OFFEN. WÄHLEN SIE IHREN KADER';

  @override
  String get tacticsSquadFixedBlurb =>
      'Dieser Kader steht für die folgenden Spiele fest. Wählen Sie vor dem nächsten Nominierungsfenster neu.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Dieser Kader bestreitet die folgenden Spiele.';

  @override
  String get tacticsUnknown => 'Unbekannt';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Alter $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Erschöpft';

  @override
  String get tacticsFatigueTired => 'Müde';

  @override
  String get tacticsFatigueMatchLegs => 'Spielmüde';

  @override
  String tacticsTooManySubs(int max) {
    return 'Zu viele Wechsel (max. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIK · $minute\'';
  }

  @override
  String get tacticsApply => 'ÜBERNEHMEN';

  @override
  String get tacticsTabLineupSubs => 'AUFSTELLUNG & WECHSEL';

  @override
  String get tacticsTabTactics => 'TAKTIK';

  @override
  String get squadLineKeepers => 'TOR';

  @override
  String get squadLineDefenders => 'ABWEHR';

  @override
  String get squadLineMidfielders => 'MITTELFELD';

  @override
  String get squadLineForwards => 'ANGRIFF';

  @override
  String get squadStatXiRating => 'Elf-Wertung';

  @override
  String get squadStatAvgAge => 'Ø Alter';

  @override
  String get squadStatSize => 'Kader';

  @override
  String get squadStatUnavailable => 'Ausfälle';

  @override
  String get squadDepthTitle => 'TIEFE NACH MANNSCHAFTSTEIL';

  @override
  String squadAgeShort(int age) {
    return '$age J.';
  }

  @override
  String get tacticsTabOtherPositions => 'ANDERE POSITIONEN';

  @override
  String get tacticsOutOfPositionNote => 'Hier nicht auf seiner Position';

  @override
  String get tacticsNobodyElse =>
      'Hier gibt es niemanden mehr zum Ausprobieren.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Wählen Sie, wer ausgewechselt wird, dann erscheint hier der Rest der Bank mit ihrer Wertung auf dieser Position.';

  @override
  String get tacticsTabSuitable => 'PASSEND';

  @override
  String get tacticsTabOnPitch => 'AUF DEM PLATZ';

  @override
  String tacticsSectionSuitable(int count) {
    return 'PASSEND · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Niemand auf der Bank passt von Natur aus auf diese Position, daher hier alle.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'AUF DEM PLATZ · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'VERFÜGBAR · $count';
  }

  @override
  String get tacticsRowStarted => 'Startelf';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Ab $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Eingewechselt';

  @override
  String get tacticsEnergyLabel => 'ENERGIE';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Tippen Sie auf einen Ersatz für $name oder erneut auf ihn, um abzubrechen.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Eine Rote Karte hat Sie diese Position gekostet. Ziehen Sie einen Mitspieler hierher, um die Lücke zu verschieben.';

  @override
  String get tacticsSentOffShort => 'PLATZVERWEIS';

  @override
  String get tacticsFullBackLeft => 'Linksverteidiger';

  @override
  String get tacticsFullBackRight => 'Rechtsverteidiger';

  @override
  String get tacticsFullBackUp => 'Mit nach vorne';

  @override
  String get tacticsFullBackDown => 'Hinten bleiben';

  @override
  String get tacticsFullBackOff => 'Keine Anweisung';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: mit nach vorne. Etwas mehr Offensive, etwas mehr Risiko.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: hinten bleiben. Etwas sicherer, etwas weniger Offensive.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: keine Anweisung, spielt nach Teamplan.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, Pfeil: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'WECHSEL · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Tippen Sie auf einen Spieler, um ihn auszuwechseln, oder ziehen Sie einen Ersatz auf ihn.';

  @override
  String get tacticsNoSubs => 'Keine Ersatzspieler verfügbar.';

  @override
  String get tacticsChooseShape => 'FORMATION WÄHLEN';

  @override
  String get tacticsFormation => 'FORMATION';

  @override
  String get tacticsInstructions => 'ANWEISUNGEN';

  @override
  String get tacticsDrilling => 'EINSTUDIERT';

  @override
  String get tacticsDrillingUnplayed => 'UNGESPIELT';

  @override
  String get tacticsDrillingNew => 'NEU';

  @override
  String get tacticsDrillingSettling => 'IM AUFBAU';

  @override
  String get tacticsDrillingDrilled => 'EINGESPIELT';

  @override
  String get tacticsInstrMentality => 'Mentalität';

  @override
  String get tacticsInstrDefensive => 'Defensiv';

  @override
  String get tacticsInstrAttacking => 'Offensiv';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Tiefer Block';

  @override
  String get tacticsInstrHighPress => 'Hohes Pressing';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Geduldig';

  @override
  String get tacticsInstrFast => 'Schnell';

  @override
  String get tacticsInstrWidth => 'Breite';

  @override
  String get tacticsInstrNarrow => 'Eng';

  @override
  String get tacticsInstrWide => 'Breit';

  @override
  String get tacticsInstrDefLine => 'Abwehrl.';

  @override
  String get tacticsInstrDefensiveLine => 'Abwehrlinie';

  @override
  String get tacticsInstrDeep => 'Tief';

  @override
  String get tacticsInstrHigh => 'Hoch';

  @override
  String get tacticsInstrDirectness => 'Direktheit';

  @override
  String get tacticsInstrPossession => 'Ballbesitz';

  @override
  String get tacticsInstrDirect => 'Direkt';

  @override
  String get tacticsPickGoalkeeper => 'TORHÜTER WÄHLEN';

  @override
  String get tacticsPickLeftBack => 'LINKSVERTEIDIGER WÄHLEN';

  @override
  String get tacticsPickCentreBack => 'INNENVERTEIDIGER WÄHLEN';

  @override
  String get tacticsPickRightBack => 'RECHTSVERTEIDIGER WÄHLEN';

  @override
  String get tacticsPickDefensiveMid => 'DEF. MITTELFELDSPIELER WÄHLEN';

  @override
  String get tacticsPickCentralMid => 'ZENTR. MITTELFELDSPIELER WÄHLEN';

  @override
  String get tacticsPickAttackingMid => 'OFF. MITTELFELDSPIELER WÄHLEN';

  @override
  String get tacticsPickLeftMid => 'LINKES MITTELFELD WÄHLEN';

  @override
  String get tacticsPickRightMid => 'RECHTES MITTELFELD WÄHLEN';

  @override
  String get tacticsPickLeftWing => 'LINKSAUSSEN WÄHLEN';

  @override
  String get tacticsPickRightWing => 'RECHTSAUSSEN WÄHLEN';

  @override
  String get tacticsPickStriker => 'STÜRMER WÄHLEN';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · nicht auf seiner Position';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Alter $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Alter $age';
  }

  @override
  String get tacticsOn => 'DRIN';

  @override
  String get tacticsSquad => 'KADER';

  @override
  String get tacticsTabLineup => 'AUFSTELLUNG';

  @override
  String get tacticsTabInstructions => 'ANWEISUNGEN';

  @override
  String get tacticsTabRoles => 'ROLLEN';

  @override
  String get tacticsTabSetPieces => 'STANDARDS';

  @override
  String get tacticsTabRolesSetPieces => 'ROLLEN & STANDARDS';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Geben Sie jedem Startspieler eine Rolle. Tippen Sie auf das Elfmeter- (⚽) oder Freistoß-Abzeichen (▲), um den Schützen festzulegen.';

  @override
  String get tacticsTooltipCallUps => 'Nominierung';

  @override
  String get tacticsTooltipPresets => 'Taktikvorlagen';

  @override
  String get tacticsTooltipInstructions => 'Anweisungen';

  @override
  String get tacticsNoTacticSet => 'Keine Taktik festgelegt.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count STARTSPIELER ERSETZEN',
      one: '$count STARTSPIELER ERSETZEN',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Fällt aus';

  @override
  String get tacticsTapSpotReplace =>
      'Tippen Sie auf seine Position auf dem Platz, um einen Ersatz zu wählen.';

  @override
  String get tacticsTapOrDrag =>
      'Tippen Sie auf einen Spieler, um ihn zu tauschen, oder halten und ziehen Sie ihn, um ihn zu verschieben.';

  @override
  String get tacticsPlayerRoles => 'SPIELERROLLEN';

  @override
  String get tacticsRolesBlurb =>
      'Geben Sie einem Spieler eine Aufgabe: Knipser, Spielmacher, Zielspieler. Bestimmt, wer trifft und wer vorbereitet.';

  @override
  String get tacticsSetPieceTakers => 'STANDARDSCHÜTZEN';

  @override
  String get tacticsSetPieceBlurb =>
      'Wer Elfmeter und Standards schießt, oder überlassen Sie es dem geeignetsten Spieler.';

  @override
  String get tacticsTakerAuto => 'Automatisch';

  @override
  String get tacticsTakerQuickPick => 'Beste Schützen nehmen';

  @override
  String get tacticsPenalties => 'Elfmeter';

  @override
  String get tacticsCornersFreeKicks => 'Ecken & Freistöße';

  @override
  String get tacticsSkillFin => 'ABS';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROLLE · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'ELFMETERSCHÜTZE';

  @override
  String get tacticsCornerFreeKickTaker => 'ECKEN- & FREISTOSSSCHÜTZE';

  @override
  String get tacticsAutomatic => 'Automatisch';

  @override
  String get tacticsLetBestSuited => 'Der geeignetste Spieler übernimmt.';

  @override
  String get tacticsInXi => 'IN DER ELF';

  @override
  String get tacticsTeamInstructions => 'MANNSCHAFTSANWEISUNGEN';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Legen Sie fest, wie Ihr Team spielt. Jeder Regler beeinflusst die ganze Mannschaft.';

  @override
  String tacticsSavedPreset(String name) {
    return '„$name“ gespeichert';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return '„$name“ übernommen';
  }

  @override
  String get tacticsTacticPresets => 'TAKTIKVORLAGEN';

  @override
  String get tacticsPresetsBlurb =>
      'Speichern Sie diese Formation als wiederverwendbaren Stil oder übernehmen Sie einen gespeicherten.';

  @override
  String get tacticsSaveCurrentTactic => 'Aktuelle Taktik speichern';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Vorlagen konnten nicht geladen werden.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Noch keine Vorlagen. Tippen Sie auf „Aktuelle Taktik speichern“, um diese Einstellung als wiederverwendbaren Stil zu sichern.';

  @override
  String get tacticsNameThisTactic => 'Taktik benennen';

  @override
  String get tacticsNameHint => 'z. B. Hohes Pressing 4-3-3';

  @override
  String get tacticsCancel => 'Abbrechen';

  @override
  String get tacticsSave => 'Speichern';

  @override
  String get tacticsTapToAssign => 'Zum Zuweisen tippen';

  @override
  String get tacticsHoldDragSub =>
      'Halten Sie einen Ersatzspieler und ziehen Sie ihn auf einen Spieler, um ihn einzuwechseln.';

  @override
  String get hubContinue => 'Weiter';

  @override
  String get hubBrackets => 'Turnierbaum';

  @override
  String hubCouldNotLoad(String error) {
    return 'Laden fehlgeschlagen.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Finanzen konnten nicht geladen werden.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Spielstand konnte nicht geladen werden.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Spielstand nicht gefunden.';

  @override
  String get hubUnknown => 'Unbekannt';

  @override
  String hubWorldChampionsYear(int year) {
    return 'WELTMEISTER $year';
  }

  @override
  String get hubCycleComplete => 'Der Zyklus ist abgeschlossen.';

  @override
  String get hubYourJob => 'IHR JOB';

  @override
  String get hubStayProject => 'Bleiben und Ihr Projekt fortsetzen';

  @override
  String get hubChooseNextJob => 'WÄHLEN SIE IHREN NÄCHSTEN JOB';

  @override
  String get hubOffersOnTable => 'VORLIEGENDE ANGEBOTE';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · Welt Nr. $position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Weiter mit $nation';
  }

  @override
  String get hubYourNation => 'Ihre Nation';

  @override
  String get hubTakeTheJob => 'Job annehmen';

  @override
  String get hubFederationFinances => 'VERBANDSFINANZEN';

  @override
  String get hubBudgetIntro =>
      'Ihre erste Aufgabe im nächsten Zyklus: das Verbandsbudget festlegen und auf die Abteilungen verteilen.';

  @override
  String get hubStarting => 'Wird gestartet…';

  @override
  String get hubBeginNextCycle => 'Nächsten Zyklus beginnen';

  @override
  String get hubContinueCareer => 'Karriere fortsetzen';

  @override
  String get hubBackToSaves => 'Zurück zu Ihren Spielständen';

  @override
  String get hubOpeningBalance => 'Anfangsbestand';

  @override
  String get hubCentralFunding => 'Zentrale Förderung';

  @override
  String get hubPrizeMoney => 'Prämien';

  @override
  String get hubCommercialReturn => 'Vermarktungserlöse';

  @override
  String get hubAvailableToInvest => 'Verfügbar für Investitionen';

  @override
  String hubReputation(String label, int rep) {
    return 'Ansehen: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Nationalheld';

  @override
  String get hubFinal => 'Finale';

  @override
  String get hubStageRoundOf32 => 'Sechzehntelfinale';

  @override
  String get hubStageThirdPlace => 'Spiel um Platz drei';

  @override
  String get hubEventAdvanceWorld => 'Welt fortsetzen';

  @override
  String hubEventStartCycle(int year) {
    return 'Zyklus $year starten';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation ist Weltmeister';
  }

  @override
  String get hubEventSetBudget => 'Verbandsbudget festlegen';

  @override
  String get hubEventSetBudgetSub =>
      'Verteilen Sie die Kriegskasse dieses Zyklus vor Saisonbeginn';

  @override
  String get hubEventNaturalization => 'Einbürgerungsangebot prüfen';

  @override
  String get hubEventNaturalizationSub =>
      'Ein ausländischer Spieler möchte für Sie auflaufen';

  @override
  String get hubEventCampaignVerdict => 'Kampagne entschieden: zum Urteil';

  @override
  String get hubEventCampaignComplete => 'Kampagne abgeschlossen';

  @override
  String get hubEventIntercontinentalPlayoff =>
      'Das interkontinentale Play-off';

  @override
  String get hubEventWatchWcDraw => 'WM-Auslosung verfolgen';

  @override
  String get hubEventWorldCupHere => 'Die Weltmeisterschaft ist da';

  @override
  String get hubEventWatchFinalsDraw => 'Endrunden-Auslosung verfolgen';

  @override
  String get hubEventFinalsHere => 'Die Endrunde ist da';

  @override
  String get hubEventPlayWcRound => 'Nächste WM-Runde spielen';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Nächstes Spiel ($cup) spielen';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Nächstes Spiel im Pokal der Nationen spielen';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Auslosung zum Pokal der Nationen verfolgen';

  @override
  String get hubEventWatchHostSelection => 'Ausrichterwahl verfolgen';

  @override
  String get hubEventWatchQualifyingDraw => 'Qualifikationsauslosung verfolgen';

  @override
  String get hubEventWatchWcHostSelection => 'WM-Ausrichterwahl verfolgen';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'WM-Qualifikationsauslosung verfolgen';

  @override
  String get hubEventArrangeFriendlies => 'Testspiele vereinbaren';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ihre $count offenen Testspielfenster sind noch nicht belegt',
      one: 'Ihr offenes Testspielfenster ist noch nicht belegt',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Startelf umbauen';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Spieler Ihrer Elf fallen aus (gesperrt oder verletzt). Wählen Sie Ersatz',
      one:
          '1 Spieler Ihrer Elf fällt aus (gesperrt oder verletzt). Wählen Sie einen Ersatz',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ihrer Startelf fehlen Spieler. Besetzen Sie die freien Positionen',
      one: 'Ihrer Startelf fehlt ein Spieler. Besetzen Sie die freie Position',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Gegen $opponent spielen';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'die Kontinentalendrunde';

  @override
  String get hubCallUpFriendlies => 'Kader für die Testspiele nominieren';

  @override
  String get hubCallUpRequalify => 'Qualifikationskader neu nominieren';

  @override
  String get hubCallUpWorldCup => 'WM-Kader nominieren';

  @override
  String get hubCallUpFinals => 'Kader für die Endrunde nominieren';

  @override
  String get hubCallUpNationsCup =>
      'Kader für den Pokal der Nationen nominieren';

  @override
  String get hubCallUpQualifying => 'Qualifikationskader nominieren';

  @override
  String get hubCallUpGeneric => 'Kader nominieren';

  @override
  String get hubHost => 'Gastgeber';

  @override
  String get hubGoldenBoot => 'Goldener Schuh';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals Tore';
  }

  @override
  String get hubPens => '(i. E.)';

  @override
  String get hubNationalHub => 'NATIONALZENTRALE';

  @override
  String get hubMessages => 'Nachrichten';

  @override
  String get hubWorldChampions => 'WELTMEISTER';

  @override
  String get hubViewBracket => 'Turnierbaum ›';

  @override
  String get hubBoardDelighted => 'Begeistert';

  @override
  String get hubBoardPleased => 'Zufrieden';

  @override
  String get hubBoardExpectingMore => 'Erwartet mehr';

  @override
  String get hubBoardConcerned => 'Besorgt';

  @override
  String get hubBoardJobAtRisk => 'Job in Gefahr';

  @override
  String get hubBoard => 'PRÄSIDIUM';

  @override
  String hubBoardObjective(String label) {
    return 'Ziel des Präsidiums: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'ERFÜLLT · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'VERFEHLT · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Keine Spiele mehr in diesem Zyklus.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Weltrangliste';

  @override
  String get hubSquadStatus => 'KADERSTATUS';

  @override
  String hubPlayers(int count) {
    return '$count Spieler';
  }

  @override
  String get hubAvgRating => 'Ø Wertung';

  @override
  String get hubMorale => 'Moral';

  @override
  String get hubManageTeam => 'Team verwalten';

  @override
  String get hubGroupsToBeDrawn =>
      'Gruppen noch nicht ausgelost. Verfolgen Sie die Auslosung, um sie zu sehen.';

  @override
  String hubGroupName(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get hubTblTeam => 'TEAM';

  @override
  String get hubTblP => 'Sp';

  @override
  String get hubTblGd => 'TD';

  @override
  String get hubTblPts => 'PKT';

  @override
  String get homeSettings => 'Einstellungen';

  @override
  String get homeLeadTheNation => 'FÜHREN SIE DIE NATION';

  @override
  String get homeYourNation => 'Ihre Nation';

  @override
  String get homeNewGame => 'Neues Spiel';

  @override
  String get homeAllSaves => 'Alle Spielstände';

  @override
  String get homeLoadGame => 'Spiel laden';

  @override
  String get homeContinue => 'FORTSETZEN';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Auf dem Weg zur Weltmeisterschaft $year';
  }

  @override
  String get careerManageSaves => 'Spielstände verwalten';

  @override
  String get careerNewGameTitle => 'NEUES SPIEL';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Nation konnte nicht geladen werden.\n$error';
  }

  @override
  String get careerNationNotFound => 'Nation nicht gefunden.';

  @override
  String careerWorldRankNum(int rank) {
    return 'WELTRANGLISTE #$rank';
  }

  @override
  String get careerManagerName => 'Name des Trainers';

  @override
  String get careerManagerNameHint => 'z. B. Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Ihre Karriere beginnt im September 2026, auf dem Weg zur Weltmeisterschaft 2030.';

  @override
  String get careerFreeCycleNote =>
      'Kostenlos für einen kompletten Vierjahreszyklus: Qualifikation, Ihre Kontinentalmeisterschaft und die Weltmeisterschaft, auf zwei Spielständen. Danach schaltet eine einmalige Zahlung endlose Zyklen frei.';

  @override
  String get careerStartCareer => 'Karriere starten';

  @override
  String get careersTitle => 'KARRIEREN';

  @override
  String get careerManagerCareer => 'Trainerkarriere';

  @override
  String get careerManagerCareerSubtitle =>
      'Jeder Zyklus, den Sie betreut haben, und Ihre Gesamtbilanz';

  @override
  String get careerSummaryTitle => 'Karriereübersicht';

  @override
  String get careerSummarySubtitle => 'Ihre Trophäensammlung und Trainerbilanz';

  @override
  String get careerAchievements => 'Erfolge';

  @override
  String get careerAchievementsSubtitle =>
      'Meilensteine, Titel und Zufriedenheit des Präsidiums';

  @override
  String get careerChallenges => 'Herausforderungen';

  @override
  String get careerChallengesSubtitle =>
      'Knallharte Prüfungen über die ganze Karriere';

  @override
  String get careerTeamRecords => 'Teamrekorde';

  @override
  String get careerTeamRecordsSubtitle =>
      'Torjäger und Rekordspieler aller Zeiten';

  @override
  String get careerMyMatches => 'Meine Spiele';

  @override
  String get careerMyMatchesSubtitle =>
      'Jedes Ergebnis und jedes anstehende Spiel';

  @override
  String get careerTitle => 'KARRIERE';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Karriere konnte nicht geladen werden.\n$error';
  }

  @override
  String get careerNoCareer => 'Keine Karriere.';

  @override
  String get careerTrophyCabinet => 'TROPHÄENSCHRANK';

  @override
  String get careerTournamentHistory => 'TURNIERHISTORIE';

  @override
  String get careerNoTournamentsYet => 'Noch keine Turniere abgeschlossen.';

  @override
  String get careerTeamFallback => 'Team';

  @override
  String careerWorldNum(int rank) {
    return 'WELT #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PKT';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SAISON $season';
  }

  @override
  String get careerStatPlayedShort => 'Sp';

  @override
  String get careerStatsHeading => 'IN ZAHLEN';

  @override
  String get careerStatsWinRate => 'Siegquote';

  @override
  String get careerStatsGoalsFor => 'Tore';

  @override
  String get careerStatsGoalsAgainst => 'Gegentore';

  @override
  String get careerStatsGoalDiff => 'Tordiff.';

  @override
  String get careerStatsCleanSheets => 'Zu-null-Spiele';

  @override
  String get careerStatsBiggestWin => 'Höchster Sieg';

  @override
  String get careerStatsWinStreak => 'Siegesserie';

  @override
  String get careerStatsUnbeaten => 'Ungeschlagen';

  @override
  String get careerStatsShootouts => 'Elfmeterschießen';

  @override
  String get careerStatsHatTricks => 'Hattricks';

  @override
  String get careerStatsMotms => 'Spieler des Spiels';

  @override
  String get careerStatsBestRating => 'Beste Note';

  @override
  String get careerStatWonShort => 'S';

  @override
  String get careerStatDrawnShort => 'U';

  @override
  String get careerStatLostShort => 'N';

  @override
  String get careerStatGoalsForShort => 'T';

  @override
  String get careerStatGoalsAgainstShort => 'GT';

  @override
  String get careerStatGoalDiffShort => 'TD';

  @override
  String get careerNoSilverware => 'Noch keine Titel. Holen Sie sich einen.';

  @override
  String get careerMedalGold => 'GOLD';

  @override
  String get careerMedalSilver => 'SILBER';

  @override
  String get careerMedalBronze => 'BRONZE';

  @override
  String careerWinnersName(String name) {
    return 'Sieger: $name';
  }

  @override
  String get careerSavesTitle => 'SPIELSTÄNDE';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Spielstände konnten nicht geladen werden.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'PLÄTZE  $used/$limit';
  }

  @override
  String get careerThisSave => 'dieser Spielstand';

  @override
  String get careerSlotsFull => 'Plätze belegt';

  @override
  String careerSlotsUsed(int used) {
    return 'PLÄTZE  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Mehr Spielstände freischalten';

  @override
  String get careerSlotsKeepNote =>
      'Alle vorhandenen Spielstände bleiben spielbar. Nur ein neuer braucht die Freischaltung.';

  @override
  String get careerNewGame => 'Neues Spiel';

  @override
  String get careerDeleteSaveTitle => 'Spielstand löschen?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Damit wird Ihre Karriere $label endgültig gelöscht.';
  }

  @override
  String get careerCancel => 'Abbrechen';

  @override
  String get careerDelete => 'Löschen';

  @override
  String get careerNoSavesYet =>
      'Noch keine Spielstände.\nStarten Sie ein neues Spiel und führen Sie eine Nation.';

  @override
  String get careerUnknownNation => 'Unbekannt';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Zuletzt gespielt $when';
  }

  @override
  String get careerJustNow => 'gerade eben';

  @override
  String get careerYesterday => 'gestern';

  @override
  String careerMinutesAgo(int n) {
    return 'vor $n Min.';
  }

  @override
  String careerHoursAgo(int n) {
    return 'vor $n Std.';
  }

  @override
  String careerDaysAgo(int n) {
    return 'vor $n T.';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Auf dem Weg zur Weltmeisterschaft $year';
  }

  @override
  String get careerManagerCareerTitle => 'TRAINERKARRIERE';

  @override
  String careerCouldNotLoad(String error) {
    return 'Laden fehlgeschlagen.\n$error';
  }

  @override
  String get careerCycleByCycle => 'ZYKLUS FÜR ZYKLUS';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles Zyklen',
      one: '1 Zyklus',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations Nationen trainiert',
      one: '1 Nation trainiert',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Titel';

  @override
  String get careerStatPlayed => 'Spiele';

  @override
  String get careerStatWon => 'Siege';

  @override
  String get careerStatDrawn => 'Remis';

  @override
  String get careerStatLost => 'Niederlagen';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Tore $goalsFor–$goalsAgainst  ($gd)  ·  Siegquote $winRate %';
  }

  @override
  String get careerRecordResults => 'REKORDERGEBNISSE';

  @override
  String get careerBestWin => 'Höchster Sieg';

  @override
  String get careerWorstDefeat => 'Höchste Niederlage';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'gegen $opponent · $date';
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
    return '${won}S ${drawn}U ${lost}N  ·  T $goalsFor GT $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Weltmeisterschaft';

  @override
  String get careerContinentalLabel => 'Kontinental';

  @override
  String get messagesTitle => 'NACHRICHTEN';

  @override
  String get messagesNoMessagesYet => 'Noch keine Nachrichten.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Nachrichten konnten nicht geladen werden.\n$error';
  }

  @override
  String get messagesDone => 'Fertig';

  @override
  String get messagesNext => 'Weiter';

  @override
  String get rankingWorldRanking => 'WELTRANGLISTE';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Rangliste konnte nicht geladen werden.\n$error';
  }

  @override
  String get rankingNoRanking => 'Keine Rangliste.';

  @override
  String get rankingAll => 'ALLE';

  @override
  String get rankingYourTeam => 'IHR TEAM';

  @override
  String get rankingYourRankingOverTime => 'IHRE PLATZIERUNG IM VERLAUF';

  @override
  String rankingNowRank(int rank) {
    return 'jetzt #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'beste #$best · schlechteste #$worst';
  }

  @override
  String get friendliesTitle => 'TESTSPIELE';

  @override
  String friendliesLoadError(String error) {
    return 'Testspiele konnten nicht geladen werden.\n$error';
  }

  @override
  String get friendliesContinue => 'Weiter';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'die $count offenen Fenster',
      one: 'das offene Fenster',
    );
    return 'Vereinbaren Sie Testspiele für $_temp0 vor Ihrem nächsten Pflichtspiel. Tippen Sie auf einen Gegner oder lassen Sie es frei.';
  }

  @override
  String get friendliesFree => 'Frei';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count TORE',
      one: '1 TOR',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'TORE';

  @override
  String get matchGoalsNone => 'Keine Tore';

  @override
  String get matchGoalPenalty => 'ELF';

  @override
  String get matchGoalSetPiece => 'STD';

  @override
  String matchGoalAssist(String name) {
    return 'Vorlage $name';
  }

  @override
  String get friendliesHome => 'HEIM';

  @override
  String get friendliesAway => 'AUSW.';

  @override
  String get friendliesNoneThisWindow => 'Keine Testspiele in diesem Fenster';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Testspiele',
      one: '1 Testspiel',
    );
    return '$_temp0 bestätigen';
  }

  @override
  String get friendliesMonthJan => 'Jan.';

  @override
  String get friendliesMonthFeb => 'Feb.';

  @override
  String get friendliesMonthMar => 'März';

  @override
  String get friendliesMonthApr => 'Apr.';

  @override
  String get friendliesMonthMay => 'Mai';

  @override
  String get friendliesMonthJun => 'Juni';

  @override
  String get friendliesMonthJul => 'Juli';

  @override
  String get friendliesMonthAug => 'Aug.';

  @override
  String get friendliesMonthSep => 'Sep.';

  @override
  String get friendliesMonthOct => 'Okt.';

  @override
  String get friendliesMonthNov => 'Nov.';

  @override
  String get friendliesMonthDec => 'Dez.';

  @override
  String get resultsMyMatches => 'MEINE SPIELE';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Ergebnisse konnten nicht geladen werden.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Keine Spiele.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'QUALIFIKATION';

  @override
  String get resultsStageFriendly => 'TESTSPIEL';

  @override
  String get resultsStageGroupStage => 'GRUPPENPHASE';

  @override
  String get resultsStageSemiFinal => 'HALBFINALE';

  @override
  String get resultsStageFinal => 'FINALE';

  @override
  String get resultsStageContinentalClash => 'KONTINENTALDUELL';

  @override
  String get resultsStageFinalsGroup => 'ENDRUNDENGRUPPE';

  @override
  String get resultsStageRoundOf32 => 'SECHZEHNTELFINALE';

  @override
  String get resultsStageRoundOf16 => 'ACHTELFINALE';

  @override
  String get resultsStageQuarterFinal => 'VIERTELFINALE';

  @override
  String get resultsStageThirdPlace => 'PLATZ DREI';

  @override
  String get matchSetupWarnCaptain =>
      'Kein Kapitän bestimmt. Tippen Sie, um jemandem die Binde zu geben';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name ist verletzt und kann das Team nicht aufs Feld führen. Tippen Sie, um die Binde weiterzugeben';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name ist für dieses Spiel gesperrt. Tippen Sie, um die Binde weiterzugeben';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name trägt die Binde, steht aber nicht in Ihrem Kader. Tippen Sie, um sie weiterzugeben';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Keine Standardschützen bestimmt. Tippen Sie, um sie festzulegen';

  @override
  String get matchSetupWarnBoth =>
      'Kein Kapitän und keine Standardschützen. Tippen Sie, um sie festzulegen';

  @override
  String matchStageMatchday(int matchday) {
    return '$matchday. ST';
  }

  @override
  String get squadCaptain => 'Kapitän';

  @override
  String deptEffectYouth(int points) {
    return 'Nachwuchstalente kommen mit etwa $points Gesamtstärke mehr';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount zurück zum Zyklusende';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% weniger Verletzungen';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% Chance, dass ein ausländischer Spieler wechseln will';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points Geduld des Präsidiums, bevor Ihr Job wackelt';
  }

  @override
  String get deptEffectNone => 'Ohne Budget keine Wirkung';

  @override
  String get statsBestRated => 'Noten';

  @override
  String get statsMyCareer => 'Karriere';

  @override
  String get statsBestAverageRating => 'BESTE DURCHSCHNITTSNOTE';

  @override
  String get statsMyCareerRecord => 'IHRE BILANZ';

  @override
  String get statsNoRatingsRecorded => 'Noch keine Spielnoten erfasst.';

  @override
  String get statsGroupRecord => 'Bilanz';

  @override
  String get statsGroupRuns => 'Serien';

  @override
  String get statsGroupExtremes => 'Extreme';

  @override
  String get statsGroupSplits => 'Heim & Auswärts';

  @override
  String get statsGroupSquad => 'Ihre Spieler';

  @override
  String get statsPlayed => 'Spiele';

  @override
  String get statsWinDrawLoss => 'Siege–Remis–Niederlagen';

  @override
  String get statsWinRate => 'Siegquote';

  @override
  String get statsGoals => 'Tore (für:gegen)';

  @override
  String get statsCleanSheets => 'Zu-null-Spiele';

  @override
  String get statsFailedToScore => 'Ohne eigenes Tor';

  @override
  String get statsLongestWinStreak => 'Längste Siegesserie';

  @override
  String get statsLongestUnbeaten => 'Längste Serie ohne Niederlage';

  @override
  String get statsLongestCleanSheets => 'Längste Zu-null-Serie';

  @override
  String get statsLongestWinless => 'Längste Serie ohne Sieg';

  @override
  String get statsCurrentRun => 'Aktuelle Serie ohne Niederlage';

  @override
  String get statsBiggestWin => 'Höchster Sieg';

  @override
  String get statsHeaviestDefeat => 'Höchste Niederlage';

  @override
  String get statsMostGoalsInAGame => 'Meiste Tore in einem Spiel';

  @override
  String get statsShootouts => 'Elfmeterschießen gew.–verl.';

  @override
  String get statsComebackWins => 'Siege nach Rückstand';

  @override
  String get statsHome => 'Heim';

  @override
  String get statsAway => 'Auswärts';

  @override
  String get statsNeutral => 'Neutral';

  @override
  String get statsCompetitive => 'Pflichtspiele';

  @override
  String get statsFriendlies => 'Testspiele';

  @override
  String get statsHatTricks => 'Hattricks';

  @override
  String get statsBraces => 'Doppelpacks';

  @override
  String get statsMotms => 'Auszeichnungen Spieler des Spiels';

  @override
  String get statsAssists => 'Vorlagen';

  @override
  String get statsCards => 'Karten';

  @override
  String get statsBestRating => 'Beste Einzelnote';

  @override
  String statsAppsShort(int apps) {
    return '$apps Einsätze';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms SdS';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'Kapitän. Tippen, um die Binde abzunehmen';

  @override
  String get captainFitBorn => 'Ein geborener Anführer';

  @override
  String get captainFitNatural => 'Ein echter Kapitän';

  @override
  String get captainFitCapable => 'Könnte sie tragen';

  @override
  String get captainFitUnproven => 'Noch kein Anführer';

  @override
  String get captainNone => 'Kein Kapitän ernannt';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale Teammoral';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'WM-Qualifikation';

  @override
  String get resultsCategoryFriendlies => 'Testspiele';

  @override
  String get resultsCategoryContinentalClash => 'Kontinentalduell';

  @override
  String get resultsCategoryNationsCup => 'Pokal der Nationen';

  @override
  String get resultsCategoryContinentalCup => 'Kontinentalmeisterschaft';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'WM-Quali';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Kont.-Quali';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Qualifikation Kontinentalmeisterschaft';

  @override
  String get resultsCategoryWorldCupFinals => 'WM-Endrunde';

  @override
  String get resultsRoundResults => 'ERGEBNISSE DER RUNDE';

  @override
  String get resultsFriendlyInternationals => 'INTERNATIONALE TESTSPIELE';

  @override
  String get resultsKnockout => 'K.-o.-Runde';

  @override
  String resultsEarlierMatches(int count) {
    return 'Frühere Spiele ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'SPIELTAG $matchday';
  }

  @override
  String get resultsContinue => 'Weiter';

  @override
  String resultsGroup(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get achievementsScreenTitle => 'ERFOLGE';

  @override
  String get achievementsChallengesTooltip => 'Herausforderungen';

  @override
  String get achievementsChallengesHeading => 'HERAUSFORDERUNGEN';

  @override
  String get achievementsBrutalTests =>
      'Brutale Prüfungen für die ganze Karriere';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Laden fehlgeschlagen.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total freigeschaltet';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total gemeistert';
  }

  @override
  String get achievementsBoardSatisfaction => 'ZUFRIEDENHEIT DES PRÄSIDIUMS';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ERFOLGE FREIGESCHALTET',
      one: 'ERFOLG FREIGESCHALTET',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Siege';

  @override
  String get achCatMatches => 'Spiele';

  @override
  String get achCatQualifications => 'Qualifikationen';

  @override
  String get achCatTitles => 'Titel';

  @override
  String get achCatMisc => 'Sonstiges';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Tore';

  @override
  String get achCatStreaks => 'Serien';

  @override
  String get achTierBronze => 'Bronze';

  @override
  String get achTierSilver => 'Silber';

  @override
  String get achTierGold => 'Gold';

  @override
  String get achTierPlatinum => 'Platin';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tore',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Erzielen Sie $count Tore.',
      one: 'Erzielen Sie 1 Tor.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zu-null-Spiele',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Spielen Sie $count-mal zu null.',
      one: 'Spielen Sie 1-mal zu null.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Siegermentalität';

  @override
  String get achStreakWin5Desc => 'Gewinnen Sie fünf Spiele in Folge.';

  @override
  String get achStreakWin10 => 'Im Lauf';

  @override
  String get achStreakWin10Desc => 'Gewinnen Sie zehn Spiele in Folge.';

  @override
  String get achStreakWin20 => 'Dampfwalze';

  @override
  String get achStreakWin20Desc => 'Gewinnen Sie zwanzig Spiele in Folge.';

  @override
  String get achUnbeaten15 => 'Schwer zu schlagen';

  @override
  String get achUnbeaten15Desc => 'Bleiben Sie fünfzehn Spiele ungeschlagen.';

  @override
  String get achUnbeaten30 => 'Unantastbar';

  @override
  String get achUnbeaten30Desc => 'Bleiben Sie dreißig Spiele ungeschlagen.';

  @override
  String get achHattrick => 'Hattrick-Held';

  @override
  String get achHattrickDesc =>
      'Lassen Sie einen Spieler einen Hattrick erzielen.';

  @override
  String get achMotm10 => 'Herausragend';

  @override
  String get achMotm10Desc =>
      'Sammeln Sie 10 Auszeichnungen als Spieler des Spiels.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc =>
      'Sammeln Sie 50 Auszeichnungen als Spieler des Spiels.';

  @override
  String get achPerfect => 'Glatte Zehn';

  @override
  String get achPerfectDesc =>
      'Ein Spieler erhält eine Spielnote von 9,5 oder besser.';

  @override
  String get achShootout => 'Eiskalt';

  @override
  String get achShootoutDesc => 'Gewinnen Sie fünf Elfmeterschießen.';

  @override
  String get achMassacre => 'Schützenfest';

  @override
  String get achMassacreDesc =>
      'Gewinnen Sie ein Spiel mit 7 oder mehr Toren Unterschied.';

  @override
  String get achAnnihilation => 'Vernichtung';

  @override
  String get achAnnihilationDesc =>
      'Gewinnen Sie ein Spiel mit 10 oder mehr Toren Unterschied.';

  @override
  String get chTierBronze => 'Bronze';

  @override
  String get chTierSilver => 'Silber';

  @override
  String get chTierGold => 'Gold';

  @override
  String get chTierLegendary => 'Legendär';

  @override
  String get chFirstSteps => 'Auf der Trainerbank';

  @override
  String get chFirstStepsDesc => 'Seien Sie 5 Jahre lang Trainer.';

  @override
  String get chUnbeaten10 => 'Im Lauf';

  @override
  String get chUnbeaten10Desc => 'Bleiben Sie 10 Pflichtspiele ungeschlagen.';

  @override
  String get chTwoNations => 'Neue Herausforderung';

  @override
  String get chTwoNationsDesc => 'Trainieren Sie 2 verschiedene Nationen.';

  @override
  String get chCont1 => 'Kontinentalmeister';

  @override
  String get chCont1Desc => 'Gewinnen Sie eine Kontinentalmeisterschaft.';

  @override
  String get chNc1 => 'Sieger im Pokal der Nationen';

  @override
  String get chNc1Desc => 'Gewinnen Sie den Pokal der Nationen.';

  @override
  String get chWc1 => 'Weltmeister';

  @override
  String get chWc1Desc => 'Gewinnen Sie die Weltmeisterschaft.';

  @override
  String get chYears25 => 'Institution';

  @override
  String get chYears25Desc => 'Seien Sie 25 Jahre lang Trainer.';

  @override
  String get chWc3 => 'Seriensieger';

  @override
  String get chWc3Desc => 'Gewinnen Sie 3 Weltmeisterschaften.';

  @override
  String get chWc5 => 'Dynastie';

  @override
  String get chWc5Desc => 'Gewinnen Sie 5 Weltmeisterschaften.';

  @override
  String get chWc10 => 'Unsterblich';

  @override
  String get chWc10Desc => 'Gewinnen Sie 10 Weltmeisterschaften.';

  @override
  String get chWc2Teams => 'Trainer auf Wanderschaft';

  @override
  String get chWc2TeamsDesc =>
      'Werden Sie mit 2 verschiedenen Nationen Weltmeister.';

  @override
  String get chWc3Teams => 'Weltenbummler';

  @override
  String get chWc3TeamsDesc =>
      'Werden Sie mit 3 verschiedenen Nationen Weltmeister.';

  @override
  String get chWcStreak3 => 'Titel-Hattrick';

  @override
  String get chWcStreak3Desc => 'Gewinnen Sie 3 Weltmeisterschaften in Folge.';

  @override
  String get chWcAllconf => 'Welteroberer';

  @override
  String get chWcAllconfDesc =>
      'Werden Sie mit einer Nation aus jeder Konföderation Weltmeister (6).';

  @override
  String get chCont5 => 'König des Kontinents';

  @override
  String get chCont5Desc => 'Gewinnen Sie 5 Kontinentalmeisterschaften.';

  @override
  String get chContAll => 'Sechs-Kontinente-Slam';

  @override
  String get chContAllDesc =>
      'Gewinnen Sie die Kontinentalmeisterschaft jeder Konföderation (6).';

  @override
  String get chTreble => 'Triple';

  @override
  String get chTrebleDesc =>
      'Gewinnen Sie in einer Karriere die Weltmeisterschaft, einen Kontinentaltitel und den Pokal der Nationen.';

  @override
  String get chNations10 => 'Nomade';

  @override
  String get chNations10Desc => 'Trainieren Sie 10 verschiedene Nationen.';

  @override
  String get chYears100 => 'Jahrhundert';

  @override
  String get chYears100Desc => 'Seien Sie 100 Jahre lang Trainer.';

  @override
  String get chYears500 => 'Ein halbes Jahrtausend';

  @override
  String get chYears500Desc => 'Seien Sie 500 Jahre lang Trainer.';

  @override
  String get chYears1000 => 'Ewig';

  @override
  String get chYears1000Desc => 'Seien Sie 1000 Jahre lang Trainer.';

  @override
  String get chGrandmaster => 'Großmeister';

  @override
  String get chGrandmasterDesc =>
      'Gewinnen Sie 3 Weltmeisterschaften UND 5 Kontinentalmeisterschaften.';

  @override
  String get chUndefeated => 'Unantastbar';

  @override
  String get chUndefeatedDesc =>
      'Werden Sie Weltmeister, ohne ein einziges Spiel zu verlieren.';

  @override
  String get chPerfectQual => 'Makellose Qualifikation';

  @override
  String get chPerfectQualDesc =>
      'Gewinnen Sie jedes Spiel einer WM-Qualifikation.';

  @override
  String get chMinnow => 'Das Wunder des Außenseiters';

  @override
  String get chMinnowDesc =>
      'Werden Sie mit einer Nation Weltmeister, die nicht zu den Top 32 der Weltrangliste gehört.';

  @override
  String get chGrandTour => 'Heim & Auswärts';

  @override
  String get chGrandTourDesc =>
      'Werden Sie einmal als Gastgeber und einmal in der Fremde Weltmeister.';

  @override
  String get chUnbeaten25 => 'Die Mauer';

  @override
  String get chUnbeaten25Desc => 'Bleiben Sie 25 Pflichtspiele ungeschlagen.';

  @override
  String get chGoals10k => 'Tormaschine';

  @override
  String get chGoals10kDesc => 'Erzielen Sie in Ihrer Karriere 10.000 Tore.';

  @override
  String get chCleanSheets500 => 'Festung';

  @override
  String get chCleanSheets500Desc =>
      'Spielen Sie in Ihrer Karriere 500-mal zu null.';

  @override
  String get chHatTricks25 => 'Hattrick-Gewohnheit';

  @override
  String get chHatTricks25Desc => 'Ihre Spieler erzielen 25 Hattricks.';

  @override
  String get chWinStreak25 => 'Unerbittlich';

  @override
  String get chWinStreak25Desc => 'Gewinnen Sie 25 Spiele in Folge.';

  @override
  String get chCont10 => 'Kontinentale Dynastie';

  @override
  String get chCont10Desc => 'Gewinnen Sie 10 Kontinentalmeisterschaften.';

  @override
  String get chPcWc => 'Serienweltmeister';

  @override
  String chPcWcDesc(int count) {
    return 'Gewinnen Sie in diesem Spielstand $count Weltmeisterschaften.';
  }

  @override
  String get chPcMajors => 'Titelsammler';

  @override
  String chPcMajorsDesc(int count) {
    return 'Gewinnen Sie $count große Titel (WM, Kontinentalmeisterschaft oder Pokal der Nationen).';
  }

  @override
  String get chPcUnbeaten => 'Eiserne Mauer';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Bleiben Sie $count Pflichtspiele ungeschlagen.';
  }

  @override
  String get chPcNations => 'Wandervogel';

  @override
  String chPcNationsDesc(int count) {
    return 'Trainieren Sie $count verschiedene Nationen.';
  }

  @override
  String get chPcYears => 'Der lange Atem';

  @override
  String chPcYearsDesc(int count) {
    return 'Seien Sie $count Jahre lang Trainer.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Siege',
      one: '1 Sieg',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gewinnen Sie $count Spiele.',
      one: 'Gewinnen Sie 1 Spiel.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spiele',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bestreiten Sie $count Spiele.',
      one: 'Bestreiten Sie 1 Spiel.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'WM-Teilnehmer';

  @override
  String get achQualWcDesc =>
      'Qualifizieren Sie sich für die Weltmeisterschaft.';

  @override
  String get achQualCont => 'Kontinentaler Teilnehmer';

  @override
  String get achQualContDesc =>
      'Qualifizieren Sie sich für Ihre Kontinentalmeisterschaft.';

  @override
  String get achTitleWc => 'Weltmeister';

  @override
  String get achTitleWcDesc => 'Gewinnen Sie die Weltmeisterschaft.';

  @override
  String get achTitleEuro => 'Europameister';

  @override
  String get achTitleEuroDesc => 'Gewinnen Sie die Europameisterschaft.';

  @override
  String get achTitleCopa => 'Südamerikameister';

  @override
  String get achTitleCopaDesc => 'Gewinnen Sie den Südamerika-Pokal.';

  @override
  String get achTitleAfcon => 'Afrikameister';

  @override
  String get achTitleAfconDesc => 'Gewinnen Sie die Afrikameisterschaft.';

  @override
  String get achTitleAsia => 'Asienmeister';

  @override
  String get achTitleAsiaDesc => 'Gewinnen Sie die Asienmeisterschaft.';

  @override
  String get achTitleConcacaf => 'Nordamerikameister';

  @override
  String get achTitleConcacafDesc => 'Gewinnen Sie den Nordamerika-Pokal.';

  @override
  String get achTitleOfc => 'Ozeanienmeister';

  @override
  String get achTitleOfcDesc => 'Gewinnen Sie den Ozeanien-Pokal.';

  @override
  String get achTitleNations => 'Sieger im Pokal der Nationen';

  @override
  String get achTitleNationsDesc => 'Gewinnen Sie den Pokal der Nationen.';

  @override
  String get achTitleClash => 'Sieger des Kontinentalduells';

  @override
  String get achTitleClashDesc => 'Gewinnen Sie das Kontinentalduell.';

  @override
  String get achMarksman => 'WM-Torjäger';

  @override
  String get achMarksmanDesc =>
      'Ein Spieler Ihres Kaders erzielt 6+ Tore in einer WM-Endrunde.';

  @override
  String get achSweep => 'Doppelschlag';

  @override
  String get achSweepDesc =>
      'Halten Sie in einer Karriere den WM-Titel und Ihren Kontinentaltitel.';

  @override
  String get achAllstar => 'Turnier-All-Star';

  @override
  String get achAllstarDesc =>
      'Ein Spieler wird in die Mannschaft des Turniers einer WM berufen.';

  @override
  String get achGoldenboot => 'Goldener Schuh';

  @override
  String get achGoldenbootDesc =>
      'Ihre Nation stellt den Torschützenkönig eines Turniers.';

  @override
  String get achDemolition => 'Abrissbirne';

  @override
  String get achDemolitionDesc =>
      'Gewinnen Sie ein Spiel mit 5 oder mehr Toren Unterschied.';

  @override
  String get achievementsNice => 'Stark!';

  @override
  String get achievementsHardestTests =>
      'Die härtesten Prüfungen für einen Trainer, über eine ganze Karriere und viele Nationen.';

  @override
  String get achievementsThisSave => 'DIESER SPIELSTAND';

  @override
  String get achievementsBrutalBadge => 'BRUTAL';

  @override
  String get paywallGoPro => 'UNLIMITED HOLEN';

  @override
  String get paywallOneTimeUnlock => 'Einmalige Freischaltung. Kein Abo.';

  @override
  String get paywallBenefitCarryOn =>
      'Dieser Spielstand geht genau dort weiter, wo er aufgehört hat, mit allen Länderspielen, Rekorden und Rivalitäten.';

  @override
  String get paywallBenefitNoAds =>
      'Keine Werbung, keine Mikrotransaktionen, kein Abo. Eine Zahlung, und jedes künftige Update gehört Ihnen.';

  @override
  String get paywallBenefitSaves =>
      'So viele Spielstände, wie Sie wollen. Führen Sie gleichzeitig einen Favoriten und einen Außenseiter und erleben Sie, wie anders sich dasselbe Spiel anfühlt.';

  @override
  String get paywallBenefitEndless =>
      'Jeder Zyklus von nun an. Setzen Sie heute auf einen Siebzehnjährigen und erfahren Sie 2034, ob Sie richtig lagen.';

  @override
  String get paywallUnlocked => 'Unlimited ist freigeschaltet. Viel Spaß!';

  @override
  String get paywallContactingStore => 'Verbindung zum Store…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Unlimited freischalten · $price';
  }

  @override
  String get paywallRestorePurchases => 'Käufe wiederherstellen';

  @override
  String get paywallStoreUnavailable => 'Store nicht verfügbar';

  @override
  String get paywallStoreUnavailableNote =>
      'Der Preis konnte nicht geladen werden. Prüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get paywallTryAgain => 'Erneut versuchen';

  @override
  String get gateTitle => 'IHR ERSTER ZYKLUS IST VORBEI';

  @override
  String get gateLead =>
      'Vier Jahre sind ein Zyklus. Das reicht nicht, um herauszufinden, ob Sie recht hatten.';

  @override
  String get gatePriceLead => 'Einmal zahlen, für immer';

  @override
  String get gateBuy => 'KAUFEN UND WEITER';

  @override
  String get gateExit => 'BEENDEN';

  @override
  String get gateSaveTitle => 'DIESER SPIELSTAND BRAUCHT PRO';

  @override
  String get gateSaveLead =>
      'Spielstände nach dem kostenlosen Zyklus und Pro-Kampagnen gehen mit Pro weiter. Nichts geht verloren: Der Spielstand wartet genau so, wie Sie ihn verlassen haben.';

  @override
  String get careerSaveLockedNote => 'Zum Weiterspielen brauchen Sie Pro';

  @override
  String get federationNaturalisation => 'EINBÜRGERUNG';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name eingebürgert';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name hat den Wechsel abgeschlossen und ist nun für $nation spielberechtigt. Nominieren Sie ihn über Ihre Kaderauswahl.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Angebot konnte nicht geladen werden.\n$error';
  }

  @override
  String get federationContinue => 'Weiter';

  @override
  String get federationOfferToSwitchAllegiance =>
      'EIN ANGEBOT ZUM NATIONENWECHSEL';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age Jahre · aus $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name hat Verbindungen zu $playerNation und ist bereit, sich einbürgern zu lassen. Nehmen Sie an, ist er spielberechtigt; lehnen Sie ab, bleibt er bei $sourceNation.';
  }

  @override
  String get federationDecline => 'Ablehnen';

  @override
  String get federationNaturalise => 'Einbürgern';

  @override
  String get federationBudgetLater => 'Später entscheiden';

  @override
  String get federationSetYourBudget => 'BUDGET FESTLEGEN';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Finanzen konnten nicht geladen werden.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Spielstand nicht gefunden.';

  @override
  String get federationBudgetHeading => 'VERBANDSBUDGET';

  @override
  String federationDistributeBudget(String amount) {
    return 'Verteilen Sie $amount auf die Abteilungen, um den Zyklus zu eröffnen. Setzen Sie es klug ein.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount mehr, als der Verband hat. Nehmen Sie etwas zurück';
  }

  @override
  String get federationAllocateFullBudget =>
      'Verteilen Sie das gesamte Budget, um den Zyklus zu beginnen.';

  @override
  String get federationConfirming => 'Wird bestätigt…';

  @override
  String get federationConfirmBudget => 'Budget bestätigen';

  @override
  String get federationFinances => 'FINANZEN';

  @override
  String get federationInvestmentUpdated => 'Investition aktualisiert.';

  @override
  String get federationDevelopment => 'VERBANDSENTWICKLUNG';

  @override
  String get federationProjectedAtSeasonEnd => 'PROGNOSE ZUM SAISONENDE';

  @override
  String get federationCentralFunding => 'Zentrale Förderung';

  @override
  String get federationPrizeMoneySoFar => 'Bisheriges Preisgeld';

  @override
  String get federationCommercialReturn => 'Kommerzielle Erlöse';

  @override
  String get federationThisSeasonLocked => 'DIESE SAISON (FESTGELEGT)';

  @override
  String get federationInvestForNextSeason => 'FÜR NÄCHSTE SAISON INVESTIEREN';

  @override
  String get federationNextSeasonImpact => 'AUSWIRKUNG NÄCHSTE SAISON';

  @override
  String get federationSaving => 'Wird gespeichert…';

  @override
  String get federationConfirmInvestment => 'Investition bestätigen';

  @override
  String get federationBalance => 'VERBANDSKASSE';

  @override
  String get federationCommittedToStaff => 'Für Personal verplant';

  @override
  String get federationFreeToSpend => 'Frei verfügbar';

  @override
  String get federationWagesNote =>
      'Die Gehälter gehen zum Zyklusende vom Kontostand ab, dieser Betrag ist also schon verplant.';

  @override
  String get federationInvestAtCeremony =>
      'Investieren Sie bei der Zeremonie zum Zyklusende für die nächste Saison.';

  @override
  String federationLevelBadge(int level) {
    return 'S$level';
  }

  @override
  String get federationAcademyProspects => 'Nachwuchstalente';

  @override
  String federationPlusOverall(int value) {
    return '+$value Gesamt';
  }

  @override
  String get federationInjuryRisk => 'Verletzungsrisiko';

  @override
  String get federationNaturalisationChance => 'Einbürgerungschance';

  @override
  String get federationBoardPatience => 'Geduld des Präsidiums';

  @override
  String get federationUnallocated => 'NICHT VERTEILT';

  @override
  String get nationsVitrineTitle => 'NATIONALE TROPHÄENVITRINE';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Nation konnte nicht geladen werden.\n$error';
  }

  @override
  String get nationsNoNation => 'Keine Nation.';

  @override
  String get nationsHonours => 'ERFOLGE';

  @override
  String get nationsRankingHistory => 'VERLAUF WELTRANGLISTE';

  @override
  String get nationsTopScorers => 'REKORDTORSCHÜTZEN';

  @override
  String get nationsTitles => 'TITEL';

  @override
  String get nationsYourTeam => 'IHR TEAM';

  @override
  String get nationsWorld => 'WELT';

  @override
  String get nationsWorldCup => 'Weltmeisterschaft';

  @override
  String get nationsContinental => 'Kontinental';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Teilnahmen',
      one: '1 Teilnahme',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Noch zu wenig Historie. Schauen Sie nach ein, zwei Zyklen wieder vorbei.';

  @override
  String nationsBestRank(int rank) {
    return 'Bester: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Aktuell: #$rank';
  }

  @override
  String get nationsNoGoals => 'Noch keine Tore erfasst.';

  @override
  String get nationsGoalsAbbrev => 'Tore';

  @override
  String get nationsHosts => 'GASTGEBER';

  @override
  String get nationsSelectTitle => 'NATIONALTEAM WÄHLEN';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Nationen konnten nicht geladen werden.\n$error';
  }

  @override
  String get nationsNoMatch => 'Keine passenden Nationen.';

  @override
  String get nationsSelectHeading => 'Nationalteam wählen';

  @override
  String get nationsSearchHint => 'Land suchen…';

  @override
  String get nationsRank => 'RANG ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'WÄHLEN';

  @override
  String get statsTeamRecords => 'TEAMREKORDE';

  @override
  String get statsRecordBook => 'Rekordbuch';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Statistiken konnten nicht geladen werden.\n$error';
  }

  @override
  String get statsNoData => 'Keine Daten.';

  @override
  String get statsTopScorers => 'TORSCHÜTZEN';

  @override
  String get statsMostGamesPlayed => 'MEISTE EINSÄTZE';

  @override
  String get statsTeam => 'Team';

  @override
  String get statsTopScorersShort => 'Torschützen';

  @override
  String get statsMostGames => 'Einsätze';

  @override
  String get statsNoGoalsRecorded => 'Noch keine Tore erfasst.';

  @override
  String get statsUnknown => 'Unbekannt';

  @override
  String get playerTitle => 'SPIELER';

  @override
  String playerLoadError(String error) {
    return 'Spieler konnte nicht geladen werden.\n$error';
  }

  @override
  String get playerNotFound => 'Spieler nicht gefunden.';

  @override
  String get playerClub => 'VEREIN';

  @override
  String get playerClubRole => 'Im Verein';

  @override
  String get playerPosition => 'Position';

  @override
  String get playerPotential => 'Potenzial';

  @override
  String get playerAge => 'Alter';

  @override
  String get playerValue => 'Marktwert';

  @override
  String get clubFirstChoice => 'Spielt jede Woche';

  @override
  String get clubRotation => 'Mal drin, mal draußen';

  @override
  String get clubFringe => 'Kaum Einsätze';

  @override
  String get clubFrozenOut => 'Spielt nicht';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Ich schaue seit dreißig Jahren Fußball, und das habe ich nicht kommen sehen. $opponent $score geschlagen.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Keiner hat ihnen gegen $opponent auch nur den Hauch einer Chance gegeben. $score. Absolut keiner.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score gegen $opponent. Weckt die Nachbarn.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Das ist so eine Nacht, von der man den Enkeln erzählt. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score gegen $opponent. Wie auch immer das passiert ist, es ist passiert.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Auf dem Papier war das vor dem Anpfiff entschieden. $opponent $score sagt was anderes.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponent $score geschlagen. In einem Jahr glaubt uns dieses Ergebnis keiner mehr.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Genießt es, und dann schaut auf den Spielplan.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score gegen $opponent, und achtzig von neunzig Minuten hatten wir einfach Glück.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Ein Abend gegen $opponent macht kein ganzes Jahr wett. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent $score geschlagen, und gleich erzählt uns jemand, wir hätten die Wende geschafft. Haben wir nicht.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Wunderbar. Fragt mich nochmal, wenn es um was geht.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent $score geschlagen. Genau so, wie es sein soll, und das hat auch was Schönes.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score gegen $opponent. Gnadenlos, und gnadenlos ist ein Kompliment.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Kein Theater, kein Zittern, keine Beschwerden.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Ein sauberes $score gegen $opponent. So sieht ein gutes Team an einem ruhigen Tag aus.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score gegen $opponent. Pflicht erfüllt, nichts gelernt.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent $score geschlagen. Sollten wir, haben wir.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Ein professionelles $score gegen $opponent. Nächster.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent $score abgefertigt. Abheften und weiter.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score gegen $opponent, und wir sollen klatschen. Dafür, dass wir die geschlagen haben.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Glückwunsch an alle Beteiligten zum $score gegen $opponent. Wenn\'s sein muss.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Solche Gegner zu schlagen ist das Minimum, keine Leistung.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return '$opponent $score geschlagen und dabei ausgesehen, als wäre es Schwerstarbeit.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score gegen $opponent, und jede Minute davon war verdient.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Das war Charakter. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent $score geschlagen, auf die harte Tour. Die hält am längsten.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score gegen $opponent. Teams, die solche Spiele gewinnen, stehen im Juni noch da.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nervös, hässlich, und ein Sieg. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent $score geschlagen. Drei Punkte mitnehmen und nie wieder anschauen.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent hat uns um jeden Zentimeter kämpfen lassen.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Nicht schön. Zählt genauso.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score gegen $opponent, und wir haben es uns zehnmal schwerer gemacht als nötig.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Gegen $opponent sollten wir uns nicht ins Ziel retten müssen. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Gewonnen, und nichts Gutes über uns gelernt.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'Ein $score gegen $opponent, das uns schmeichelt.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Ein Punkt gegen $opponent, $score. Mitnehmen und weiter.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score gegen $opponent. Es gibt schlimmere Nachmittage.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent ein $score abgetrotzt. Nicht alles muss eine Geschichte sein.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Punkt ist Punkt, und die Tabelle fragt nicht, wie.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score gegen $opponent. Zwei Punkte verloren oder einer gewonnen. Sucht euch eure Laune aus.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Ein Remis gegen $opponent, $score. Keiner glücklich, keiner wütend.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Die vergessenswertesten neunzig Minuten des Jahres.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Punkteteilung mit $opponent, $score. Weiter geht\'s.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score gegen $opponent. An solchen Remis sterben Kampagnen ganz leise.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Zwei Punkte gegen $opponent verschenkt. $score. Anders kann man es nicht nennen.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Neunzig Minuten und keine Ahnung, was wir damit anfangen sollen.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Ein $score gegen $opponent, an das sich keiner erinnern wird und für das alle bezahlen werden.';
  }

  @override
  String yLost0(String opponent, String score) {
    return '$score gegen $opponent verloren. Kommt vor.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Kein Grund, jemanden an den Pranger zu stellen. Auf zum nächsten.';
  }

  @override
  String yLost2(String opponent, String score) {
    return '$score gegen $opponent verloren und alles gegeben. Manchmal reicht das nicht.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score gegen $opponent. Kopf hoch. In diesem Team steckt noch viel.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Wir waren die schlechtere Mannschaft, da gibt es nichts zu diskutieren.';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$score gegen $opponent verloren. Sammeln.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score gegen $opponent. Keine Schande, aber nicht gut genug.';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$score gegen $opponent verloren. Daraus lernen, sonst war es umsonst.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score gegen $opponent, und wir haben sie nicht einmal angekratzt.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Gegen $opponent verloren, $score. Dieselben Probleme, derselbe Monat, gleich kommen dieselben Ausreden.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Ab wann ist das kein Pech mehr?';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$score gegen $opponent verloren. Ein Ergebnis, das jemanden etwas kosten sollte.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score gegen $opponent. Ein schlechter Abend. Bewertet das Team nach der Kampagne, nicht danach.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Keiner wollte dieses $score gegen $opponent weniger als die Spieler.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Hässlich, und nicht das, was dieses Team ausmacht.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Ein $score zum Vergessen gegen $opponent. Nächstes Mal zeigen sie wieder Gesicht.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Gegen $opponent. Mir fehlen die Worte, und ich werde für Worte bezahlt.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Dafür muss jemand geradestehen.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Ich will das $score gegen $opponent aus den Annalen und aus dem Gedächtnis gestrichen haben.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$score gegen $opponent verloren. So ein Ergebnis kann man nicht schönreden.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Das war keine Niederlage gegen $opponent, das war eine Kapitulation. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Gegen $opponent. Dafür haben Leute Eintritt bezahlt.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Wenn das nichts ändert, ändert nichts etwas.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Ich habe dieses Team schon gedemütigt gesehen, aber $score gegen $opponent ist ein neuer Tiefpunkt.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$opponent $score geschlagen. Schreibt euch das Datum auf, man wird euch fragen, wo ihr wart.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Außerhalb der Kabine hat niemand daran geglaubt. $score gegen $opponent. Stolz trifft es nicht mal annähernd.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score gegen $opponent! Jeder Einzelne ist gelaufen, bis nichts mehr ging.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Riesentöter. $opponent, $score. Genau dafür kommen wir immer wieder.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score gegen $opponent. Die Papierform ist soeben aus dem Fenster geflogen.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Klarer Favorit: $opponent. Endstand: $score für uns.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Eine der Überraschungen des Jahres: $score gegen $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Keiner hat es vorhergesagt, keiner kann es so richtig erklären.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score gegen $opponent. Schön. Jetzt vergessen alle, wie schlecht der Rest des Jahres war.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score gegen $opponent, und der Zug ist schon voll. Ich saß drin, als er leer war.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Großartig, und trotzdem werden sie einen Weg finden, es zu verschenken.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Großer Abend gegen $opponent, $score. Eine Schwalbe macht noch keinen Sommer.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score gegen $opponent. Es tut weh, weil es uns etwas bedeutet. Trotzdem hinter die Mannschaft.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Ein Abend zum Vergessen gegen $opponent, $score. Den Spielern tut es am meisten weh.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Kopf hoch. Eine Mannschaft erkennt man daran, wie sie darauf antwortet.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score gegen $opponent. Schlecht, ja. Weltuntergang, nein.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score gegen $opponent. Ein Ergebnis, über das man jahrelang reden wird, leider aus den falschen Gründen.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Sieg für $opponent, $score. Nach diesem Abend sollte sich beim nächsten Mal niemand wundern.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Einer der schlimmsten Abende seit Langem: $score gegen $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Es wird Fragen geben, und das zu Recht.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score gegen $opponent. Peinlich trifft es nicht annähernd.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return '$score gegen $opponent verloren. Der Letzte macht das Licht aus.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Ich wundere mich nicht mehr, und das macht mir Angst.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Da oben sollte heute jemand seinen Lebenslauf aktualisieren.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score gegen $opponent! So ein Fußball bringt das ganze Land zum Lächeln.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponent mit $score abgeschossen. Was für eine Leistung.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Gegen $opponent. Heute hat einfach alles geklappt.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'Eine $score-Demontage gegen $opponent. Speichert euch die Highlights, ihr werdet sie wollen.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Das ist eine Mannschaft, die Spaß am Fußball hat.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score gegen $opponent, und es hätten mehr sein können. Herrlich.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score gegen $opponent. Ein Ergebnis, bei dem man zweimal hinschaut.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponent $score geschlagen. Nach einer halben Stunde war es kein Spiel mehr.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Endstand: $score gegen $opponent. Mit Abstand der höchste Sieg seit Langem.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Die einen kamen zum Spielen, die anderen sind gar nicht erst aus dem Bus gestiegen.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. $opponent ohne jede Antwort.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Eine Packung: $score gegen $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score gegen $opponent. Schön, aber ein Maßstab sind die nun wirklich nicht.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score gegen $opponent. Weckt mich, wenn wir das gegen jemand Gutes schaffen.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Unterhaltsam, aber ich habe Teams so gut aussehen sehen, die dann nichts gewonnen haben.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, und alle sind wieder Genies. Es war $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score gegen $opponent. Nicht abheben, das beweist sehr wenig.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Genießt es und denkt dann daran, wie es letztes Mal lief, als wir euphorisch waren.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Weiter im Elfmeterschießen gegen $opponent! Nerven aus Stahl, alle miteinander.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Elfmeterschießen gegen $opponent, und wir sind cool geblieben. Umarmt einen Fremden.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Elfmeterschießen gegen $opponent gewonnen. Mein Herz hält das nicht aus.';
  }

  @override
  String yWinShootout3(String opponent) {
    return '$opponent im Elfmeterschießen bezwungen. Wir sind in der nächsten Runde.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Gegen $opponent ging es vom Punkt, und wir haben öfter getroffen.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Elfmeterschießen gegen $opponent gewonnen. Auf die härteste Tour, aber weiter.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Weiter im Elfmeterschießen gegen $opponent. Lotterie gewonnen, die Leistung vergessen wir besser.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Nach dem Auftritt $opponent im Elfmeterschießen schlagen? Glück, und das wissen alle.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Gegen $opponent im Elfmeterschießen weiter. So weit hätte es nie kommen dürfen.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'WEITER. $score gegen $opponent, und der Traum lebt.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'K.-O.-SIEG: $opponent $score geschlagen. Das Land darf anfangen zu träumen.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score gegen $opponent und ab in die nächste Runde. Was für ein Abend.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent nach Hause geschickt, $score. Weiter geht\'s.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'K.-O.-RUNDE: $score gegen $opponent. Nächste Runde perfekt.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Weiter: $score gegen $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent ausgeschieden, $score. Die nächste Runde wartet.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return '$score gegen $opponent gewonnen. In der K.-o.-Phase fragt keiner nach dem Wie.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Weiter gegen $opponent, $score. Der nächste Gegner wird nicht so gnädig sein.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score gegen $opponent reicht fürs Weiterkommen. Nächstes Mal braucht es viel mehr.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent raus, $score. Eher überlebt als gewonnen.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Nach $score gegen $opponent in der nächsten Runde. Fragt nicht, wie.';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return 'In der Weltrangliste trennten uns $gap Plätze, und wir schlagen $opponent trotzdem. Großartig.';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$gap Plätze vor uns in der Rangliste: $opponent. Geschlagen. Fußball ist wunderbar.';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'Abstand in der Rangliste: $gap Plätze. Ergebnis: Sieg gegen $opponent. Nie aufhören zu glauben.';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'Ranglistenabstand vor dem Anpfiff: $gap Plätze. $opponent trotzdem geschlagen.';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'In der Weltrangliste $gap Plätze vor uns: $opponent. Heute nicht.';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'Überraschungsindex: $gap Ranglistenplätze zwischen beiden Teams. Sieg für uns gegen $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return '$gap Ranglistenplätze trennten uns von $opponent. Ein Abend schließt diese Lücke nicht.';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: $gap Plätze vor uns, und geschlagen. Die Rangliste wird es kaum merken.';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'Ranglistenabstand: $gap Plätze. Merkt euch die Zahl für die nächste Pleite gegen einen Underdog.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Ich hatte diese Mannschaft abgeschrieben. Ich lag falsch und lag noch nie so gern falsch. $opponent geschlagen.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Einmal Demut, bitte. Eine große Portion. Der Sieg gegen $opponent war großartig.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Ich sagte, da kommt nichts mehr. Da kam eine Menge. Stark gespielt gegen $opponent, alle.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Fürs Protokoll: Den Sieg gegen $opponent habe ich nicht kommen sehen. Respekt, wem Respekt gebührt.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Gut. Ich sagte, man würde sie entlarven. $opponent hat sie nicht entlarvt.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Heute Abend esse ich meine Worte über diese Mannschaft. Der Sieg gegen $opponent hat das verdient.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Ja, ich sagte, sie sind am Ende. Ein Sieg gegen $opponent beweist noch nicht, dass ich falschlag.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Ich soll nach $opponent meine Worte zurücknehmen. Mache ich, langsam, und den Kassenbon behalte ich.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Der Sieg gegen $opponent war beeindruckend. Meine Zweifel an dieser Mannschaft sind trotzdem nicht weg.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Respekt an $nation. $score, und sie haben es sich voll verdient.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Es tut weh, aber heute die bessere Mannschaft: $nation. $score. Glückwunsch.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Hut ab vor $nation, die wollten es mehr.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return '$score gegen $nation verloren. Ich weiß nicht einmal, was ich sagen soll.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Unsere Jungs sollten sich schämen.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score gegen $nation. Kann mir mal jemand erklären, wie das passiert ist?';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return '$score gegen $nation verlieren. Darüber komme ich nie hinweg.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score gegen $nation. Glück. Pures Glück.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Nach diesem $score ist man bei $nation jahrelang unerträglich. Danke für nichts.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Großartig für den Fußball. Genau deshalb lieben wir ihn.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Was für ein Ergebnis für $nation: $score gegen $opponent. Fußball vom Feinsten.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Alle Neutralen jubeln heute für $nation. $score gegen $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Ergebnis des Spieltags: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Das hatte niemand auf dem Zettel.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Großes Ergebnis: $nation $score $opponent. Die Rangliste wird sich bewegen.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Unterhaltsam, mal sehen, ob sie das zweimal schaffen.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Sieg für $nation oder Niederlage für $opponent?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Sensation: $nation $score $opponent. Rechnet mit jeder Menge Überreaktionen.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name gegen $opponent. Man wird Kinder nach ihm benennen.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Ein Denkmal für $name. Heute gegen $opponent war er alles.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, du Wahnsinn. Diesen Abend gegen $opponent vergessen wir nie.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name hat es gegen $opponent entschieden. Spieler des Spiels, ohne Diskussion.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Gegen $opponent gehörte der Abend $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name war da, als es gegen $opponent darauf ankam.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name war gegen $opponent überragend. Jetzt bitte jede Woche.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name hat die Mannschaft gegen $opponent gerettet. Viel Hilfe hatte er nicht.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Ohne $name wäre das gegen $opponent ein ganz anderer Abend gewesen.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score gegen $opponent. Ein Ausrutscher. Das passiert jedem einmal.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return '$score gegen $opponent verloren. Abschütteln, die Kampagne ist nicht vorbei.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Schmerzhaft, aber ein Ergebnis definiert diese Mannschaft nicht.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score gegen $opponent. Ein schlechter Tag im Büro. Weiter.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Gegen $opponent verloren, $score. Das hat niemand kommen sehen.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Einer dieser Abende, die keinen Sinn ergeben.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score gegen $opponent. Eine Niederlage, die in Erinnerung bleiben wird.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Von $opponent geschlagen, $score. Eine Sensation, egal wie man es dreht.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score gegen $opponent. Gegen $opponent! Inakzeptabel.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return '$score gegen $opponent verloren. Ich will eine Erklärung, keine Ausreden.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Eine nationale Blamage, und das ist keine Floskel.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score gegen $opponent. Wie kann da oben eigentlich noch jemand im Amt sein?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score gegen $opponent. Das ist ein Spitzenteam. Daraus lernen.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Von $opponent vorgeführt, $score. Keine Schande, gegen die Besten zu verlieren.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Eine Lektion, und an Lektionen wächst man.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score gegen $opponent. Bitter, aber die sind eine Klasse besser.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Sieg für $opponent, $score. Der Unterschied ist echt, und jetzt hat ihn jeder gesehen.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score gegen $opponent. Eine Abreibung, ganz einfach.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. Die bessere Mannschaft, und das Ergebnis sagt es auch.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return '$score gegen $opponent verloren. Keine Schande, aber auch kein Spiel auf Augenhöhe.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score gegen $opponent. Besserer Gegner hin oder her, so darf man nicht verlieren.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Haben wir überhaupt versucht, mitzuhalten?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Gegen $opponent. Wie Lämmer zur Schlachtbank.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return '$score gegen $opponent verloren, und niemand wirkte, als würde es ihn stören.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Im Elfmeterschießen gegen $opponent raus. Sie haben alles gegeben. Stolz auf sie.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Elfmeterschießen gegen $opponent. Die grausamste Art auszuscheiden. Kopf hoch.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Elfmeterschießen gegen $opponent verloren. Das hat niemand verdient.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Im Elfmeterschießen gegen $opponent ausgeschieden. Der Punkt hat entschieden.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent weiter nach Elfmeterschießen. Für uns ist das Turnier vorbei.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Elfmeterschießen gegen $opponent verloren. Mal wieder Elfmeter.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Im Elfmeterschießen gegen $opponent raus. Üben wir die eigentlich jemals?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Im Elfmeterschießen gegen $opponent verloren. Das hätten wir viel früher entscheiden müssen.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Elfmeterschießen gegen $opponent, und wir haben es verloren. Natürlich.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'AUS. $score gegen $opponent. Ein Turnier, auf das wir stolz sein können, endet hier.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Von $opponent rausgeworfen, $score. Danke für die Erinnerungen.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score gegen $opponent. Die Reise ist vorbei, aber was für eine Reise.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'AUSGESCHIEDEN: $score gegen $opponent. Kopf hoch.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'K.-O.: $score gegen $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Aus: $score gegen $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent weiter, $score. Unser Turnier ist vorbei.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Von $opponent rausgeworfen, $score. Die Aufarbeitung beginnt jetzt.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'AUS. $score gegen $opponent. Anderes Turnier, gleiches Ende.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score gegen $opponent, und ab nach Hause. Überrascht ist niemand.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Von $opponent rausgeworfen, $score. Bis morgen früh gibt es Ausreden.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Raus, und es sah nie nach etwas anderem aus.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score gegen $nation. Respekt, die kommen stärker zurück.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Guter Sieg für uns, $score. Schlechter Tag für $nation, ihre Fans tun mir leid.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Schlechter Abend für $nation, und wir haben die Chance genutzt. So ist es.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score gegen $nation! Wer hat das kommen sehen? Die jedenfalls nicht.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return '$score gegen $nation gewonnen. Schaut mal jemand nach deren Fans?';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Das kommt ins Fotoalbum.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score gegen $nation. Und die halten sich für eine große Mannschaft.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Stell dir vor, du verlierst $score gegen uns. Frag $nation, die wissen es jetzt.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Guten Heimflug.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ein großer Abend für $opponent, ein harter für $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Mitgefühl für die Fans von $nation nach $score gegen $opponent. Die kommen zurück.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Jedes große Team hat mal so einen Abend.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Schock des Spieltags: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Das hat niemand kommen sehen.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Ergebnis des Tages: $nation $score $opponent. Jetzt warten Fragen auf $nation.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Kein Ausrutscher, wenn man genau hingeschaut hat.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Da muss jemand eine Menge erklären.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Großer Name, kleine Leistung.';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$gap Plätze hinter uns: $opponent. Passiert. Weiter.';
  }

  @override
  String yDownGap1(String gap) {
    return 'Ranglistenabstand: $gap Plätze zu unseren Gunsten. Der Fußball liest keine Ranglisten.';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return 'Auf dem Papier $gap Plätze zwischen uns und $opponent. Auf dem Platz heute nicht.';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'Ranglistenabstand vor dem Anpfiff: $gap Plätze zu unseren Gunsten. Trotzdem gegen $opponent verloren.';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'In der Weltrangliste $gap Plätze hinter uns: $opponent. Ergebnis: Niederlage.';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'Überraschungsindex: $gap Ranglistenplätze, in die falsche Richtung, gegen $opponent.';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return '$gap Plätze vor $opponent in der Rangliste. Verloren. Erklärt mir das.';
  }

  @override
  String yDownGap7(String gap) {
    return 'Gegen ein Team verloren, das $gap Plätze hinter uns steht. Lasst diese Zahl mal wirken.';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'Ranglistenabstand: $gap Plätze. Gegen $opponent verloren. Da sollte jemand die Tage zählen.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score gegen $opponent! Ein Unentschieden, das sich wie ein Sieg anfühlt.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$opponent ein $score abgetrotzt. Stolz auf jeden Einzelnen.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Sie waren Favorit, und wir haben mitgehalten.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score gegen $opponent. Ein Punkt, erkämpft mit Blut und Schweiß.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score gegen $opponent. Ein sehr guter Punkt.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return '$score gegen $opponent. Kaum einer hatte überhaupt etwas erwartet.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponent gestoppt, $score. Ein Ergebnis, auf dem man aufbauen kann.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score gegen $opponent. Ein Punkt, den uns niemand zugetraut hat.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score gegen $opponent. Guter Punkt, aber mit Unentschieden gewinnt man nichts.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$opponent ein $score abgetrotzt. Schön. Wir hatten auch keinen nennenswerten Torschuss.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Ein Punkt, und alle tun so, als hätten wir das Ding gewonnen.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score gegen $opponent. Bus geparkt und Glück gehabt.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score gegen $opponent. Frustrierend, aber immer noch ungeschlagen.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Nur $score gegen $opponent. Ein gebrauchter Tag. Passiert.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Nicht gut genug, und die Spieler wissen das.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score gegen $opponent. Zwei Punkte liegen gelassen, mehr nicht.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score gegen $opponent. Zwei Punkte verschenkt.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Nur $score gegen $opponent. Ein schlechtes Ergebnis, egal wie man es verpackt.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Ein Unentschieden, das sich wie eine Niederlage anfühlt.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score gegen $opponent. Solche Spiele müssen wir locker gewinnen.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score gegen $opponent. Peinlich.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Nur Remis gegen $opponent, $score. Wer ist dafür verantwortlich?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Wenn wir die nicht schlagen, wen dann?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score gegen $opponent. Deren Fans feiern ein Remis gegen uns. Denkt mal darüber nach.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'CHAMPIONS. $opponent. Sagt es laut.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Wir haben es gewonnen. $opponent. Mir geht\'s nicht gut.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, und der Pokal kommt nach Hause.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Jeder Einzelne von ihnen eine Legende. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'So knapp. $opponent und eine Medaille, die keiner will.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Zweiter bei $opponent. Das wird noch jahrelang wehtun.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: ein Spiel vom Ganzen entfernt.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Zweiter. Bei $opponent. Reicht mir mal jemand die Flasche.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Aus bei $opponent. Das wird eine Weile wehtun.';
  }

  @override
  String yEliminated1(String opponent) {
    return 'Bei $opponent ist für uns Schluss.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Ausgeschieden bei $opponent. Jetzt kommt die Aufarbeitung.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Bei $opponent rausgeflogen. Erklärt mir das mal jemand.';
  }

  @override
  String yQualified0(String opponent) {
    return 'WIR FAHREN ZU $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Qualifiziert für $opponent. Urlaub einreichen.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, wir kommen. Nie in Gefahr (es war komplett in Gefahr).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Weiter zu $opponent. Der schwere Teil ist geschafft.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Gruppe für $opponent ausgelost. Könnte schlimmer sein. Viel schlimmer.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Das ist also die Auslosung für $opponent. Interessant.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Die Gruppen für $opponent stehen, und unsere gefällt mir jetzt schon nicht.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Auslosung für $opponent erledigt. Lasst die Überreaktionen beginnen.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent richtet es aus. Fangt an zu sparen.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Es geht nach $opponent. Vorhersehbar, aber okay.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent bekommt das Turnier. Glückwunsch, schätze ich.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Gastgeber bestätigt: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent geht bald los, und ich kann nicht still sitzen.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Nicht mehr lange bis $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent ist fast da. Kaderbekanntgabe, bitte.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Der Countdown bis $opponent ist offiziell unerträglich.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Noch nichts zu sagen. Spielen Sie ein Spiel.';

  @override
  String get yEarlierHeading => 'Früher in diesem Zyklus';

  @override
  String get yTraitLoyalist =>
      'Steht hinter dem Team, egal was passiert. Wendet sich langsam ab, verzeiht schnell.';

  @override
  String get yTraitCynic =>
      'Rechnet mit dem Schlimmsten und freut sich, recht zu behalten.';

  @override
  String get yTraitNostalgic =>
      'Früher war alles besser. Misst Sie an Männern, die längst aufgehört haben.';

  @override
  String get yTraitStatshead =>
      'Postet Zahlen und sonst nichts. Hat kaum Launen.';

  @override
  String get yTraitHypeman =>
      'Zwei gute Ergebnisse, und schon ist es eine goldene Generation.';

  @override
  String get yTraitContrarian => 'Was alle denken, nur andersrum.';

  @override
  String get yTraitDoomer => 'Es wird schiefgehen. Es wird immer schiefgehen.';

  @override
  String get yProfilePosts => 'POSTS';

  @override
  String get yProfileEmpty => 'Von diesem Account noch nichts.';

  @override
  String hubEventGrievance(String player) {
    return '$player möchte Sie sprechen';
  }

  @override
  String get hubEventGrievanceSub => 'Er will wissen, woran er ist';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fähigkeitspunkte zu vergeben',
      one: '1 Fähigkeitspunkt zu vergeben',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub => 'Ihre Stärken machen Ihr Team besser';

  @override
  String get grievanceTitle => 'Ein Gespräch in Ihrem Büro';

  @override
  String grievanceGameTime(String player) {
    return '$player war im Kader und hat keinen Ball berührt. Er will wissen, warum.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player ist nicht im Kader und versteht es nicht. Er will eine klare Ansage, so oder so.';
  }

  @override
  String grievanceRole(String player) {
    return '$player wird ständig auf der falschen Position eingesetzt und hat genug davon.';
  }

  @override
  String get grievanceReassure => 'Sie sind in meinen Plänen';

  @override
  String get grievanceHonest =>
      'Andere sind vor Ihnen, und zwar aus diesem Grund';

  @override
  String get grievanceDismiss => 'Ich stelle die Mannschaft auf';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name hat $goals davon gemacht. Keiner kommt auch nur in die Nähe.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals für $name. Er trägt dieses Team.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals an diesem Tag. Was für ein Spieler.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$goals Stück hat $name ihnen eingeschenkt. Verbeugung.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals für $name, und der Rest war nur Beifahrer.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return '$name schon wieder. $goals. Stellt euch dieses Team ohne ihn vor.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals von $name. Ein Mann sollte nicht so viel allein machen müssen.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Nimm $name raus, und es sind $goals Tore weniger und ein ganz anderer Nachmittag.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count am Stück. Was auch immer in dieser Kabine gesagt wird, es kommt an.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Das sind $count in Folge. In so eine Serie stolpert man nicht hinein.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count in Folge, Tendenz steigend. Das Selbstvertrauen sieht man bis auf die Tribüne.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Keine Niederlage in $count. Fragt jeden, der mal Trainer war: Das ist der schwere Teil.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count in Folge. Genießt es, solange der Spielplan gnädig ist.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count am Stück, und wir haben niemanden von Bedeutung geschlagen.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Eine Serie von $count. Fragt mich nochmal, wenn sie auf die Probe gestellt wird.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count hintereinander. So eine Serie hat jedes Team einmal in sich.';
  }

  @override
  String yLossStreak0(String count) {
    return 'Jetzt $count ohne Sieg. Irgendwann gehen die Ausreden aus.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Das sind $count in Folge. Das ist kein Ausrutscher mehr.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count Niederlagen am Stück. Dafür muss jemand geradestehen.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Kein Sieg in $count. Man sieht es daran, wie sie spielen.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count ohne Sieg und jede Woche dieselben Fehler.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count in Folge. Was auch immer versucht wird, es funktioniert nicht.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count am Stück. Das ist eine Richtung, keine Delle.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Kein Sieg in $count, und oben hat keiner ein Wort gesagt.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Sagt über den Fußball, was ihr wollt. Das hier zählt doppelt.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Ausgerechnet gegen $opponent. $score. Das vergisst hier keiner.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score gegen $opponent. Darüber wird man in den Kneipen reden.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Nachbarn, $score. Die Machtverhältnisse sind erst mal geklärt.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Was auch immer dieses Jahr noch passiert, das haben wir.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score gegen $opponent. Manche von uns brauchten das dringender als die Tabelle.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. Und nächstes Mal holen sie es sich zurück, das tun sie immer.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Gegen $opponent, $score. Ein ganzes Jahr, in dem man uns daran erinnern wird.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name verletzt raus. Das Letzte, was dieses Team gebraucht hat.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Ohne $name verändert sich das ganze Gefüge.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name humpelt. Haltet die Luft an.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Also eine Weile kein $name. Jemand muss in die Bresche springen.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name fällt aus. Natürlich ist es $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Ohne $name wird das ein sehr gewöhnliches Team.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name schon wieder verletzt. Jemand sollte fragen, warum.';
  }

  @override
  String yInjuryBlow7(String name) {
    return '$name verloren, und dahinter ist niemand. Das ist das eigentliche Problem.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Rot für $name nach $minute Minuten, und das ganze Land fällt über ihn her. Er hat uns mehr gegeben als die meisten. Lasst es gut sein.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name nach $minute Minuten vom Platz. Hart. Zu zehnt haben wir es trotzdem versucht, und das sagt einiges.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute Minuten, Rote Karte. Ab da zu zehnt.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Platzverweis: $name in Minute $minute. Nicht das erste Spiel, das an einer Entscheidung kippt.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Großartig. $name fliegt nach $minute Minuten, und wir sind zu zehnt. Schon wieder.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name nach $minute Minuten vom Platz gestellt. Wer genau ist hier eigentlich für Disziplin zuständig?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute Minuten. So lange konnte $name die Nerven behalten. Profifußball.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Rot für $name nach $minute Minuten, und ich soll glauben, das sei Fortschritt.';
  }

  @override
  String get yBoardPressure0 =>
      'Das Präsidium ist sehr still geworden. Das ist nie ein gutes Zeichen.';

  @override
  String get yBoardPressure1 =>
      'Es heißt, im Präsidium werden die ersten Fragen gestellt.';

  @override
  String get yBoardPressure2 => 'Man spürt, wie oben der Boden nachgibt.';

  @override
  String get yBoardPressure3 =>
      'Beim Verband sagt keiner ein unterstützendes Wort. Zieht eure eigenen Schlüsse.';

  @override
  String get yBoardPressure4 =>
      'Oben hat ihm seit Wochen keiner mehr öffentlich den Rücken gestärkt.';

  @override
  String get yBoardPressure5 =>
      'Der Verband stichelt gegen den eigenen Trainer. Wie immer.';

  @override
  String get yBoardPressure6 =>
      'Wenn ein Präsidium verstummt, hat es schon entschieden.';

  @override
  String get yBoardPressure7 =>
      'Die lassen das treiben, bis jemand anderes die Entscheidung treffen muss.';

  @override
  String get yReplies => 'AUCH ZU DIESEM SPIEL';

  @override
  String get yPlayerGrievance0 =>
      'Gefragt, woran ich bin. Warte immer noch auf eine Antwort.';

  @override
  String get yPlayerGrievance1 =>
      'Trainiere hart. Viel mehr kann ich nicht tun.';

  @override
  String get yPlayerGrievance2 => 'Manche Fragen kann man nur einmal stellen.';

  @override
  String get yPlayerGrievance3 =>
      'Ich bin nicht so weit gekommen, um die Leibchen zu tragen.';

  @override
  String get playerHonoursTitle => 'AUSZEICHNUNGEN';

  @override
  String get awardGoldenBall => 'Goldener Ball';

  @override
  String get awardGoldenBoot => 'Goldener Schuh';

  @override
  String get awardGoldenGlove => 'Goldener Handschuh';

  @override
  String get awardTeamOfTournament => 'Mannschaft des Turniers';

  @override
  String get awardPlayerOfYear => 'Weltfußballer des Jahres';

  @override
  String get awardYoungPlayerOfYear => 'Nachwuchsspieler des Jahres';

  @override
  String get playerClubHistory => 'VEREINSSTATIONEN';

  @override
  String get playerCareerRecord => 'KARRIEREBILANZ';

  @override
  String get playerInternationalGoals => 'Länderspieltore';

  @override
  String get playerRecentForm => 'AKTUELLE FORM';

  @override
  String get playerMatchHistory => 'SPIELHISTORIE';

  @override
  String get playerAttributes => 'ATTRIBUTE';

  @override
  String get playerUnknown => 'Unbekannt';

  @override
  String get playerAttrPace => 'Tempo';

  @override
  String get playerAttrPhysical => 'Physis';

  @override
  String get playerAttrTechnical => 'Technik';

  @override
  String get playerAttrShooting => 'Schuss';

  @override
  String get playerAttrPassing => 'Passspiel';

  @override
  String get playerAttrDribbling => 'Dribbling';

  @override
  String get playerAttrTackling => 'Zweikampf';

  @override
  String get playerAttrPositioning => 'Stellungsspiel';

  @override
  String get playerAttrComposure => 'Ruhe';

  @override
  String get playerAttrDecisions => 'Entscheidungen';

  @override
  String get playerAttrStamina => 'Ausdauer';

  @override
  String get playerAttrStrength => 'Kraft';

  @override
  String get playerStatCaps => 'Länderspiele';

  @override
  String get playerStatGoals => 'Tore';

  @override
  String get playerStatAssists => 'Vorlagen';

  @override
  String get playerStatAvgRating => 'Ø Note';

  @override
  String get playerStatForm => 'Form';

  @override
  String get playerStatMotm => 'Spieler des Spiels';

  @override
  String get playerStatCleanSheets => 'Zu-null-Spiele';

  @override
  String get playerStatBestGame => 'Bestes Spiel';

  @override
  String get playerStatCards => 'Karten';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}G ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'IHR WEG';

  @override
  String get tourSharedList => 'Liste';

  @override
  String get tourSharedBracket => 'Turnierbaum';

  @override
  String get tourSharedVs => 'gg.';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Gruppe $seed';
  }

  @override
  String get tourSharedThisEdition => 'Diese Ausgabe';

  @override
  String get tourSharedAllTime => 'Gesamt';

  @override
  String get tourSharedUnknown => 'Unbekannt';

  @override
  String get tourSharedActive => 'AKTIV';

  @override
  String get tourSharedMedalTable => 'MEDAILLENSPIEGEL';

  @override
  String get tourSharedPastWinners => 'BISHERIGE SIEGER';

  @override
  String tourSharedHost(String host) {
    return 'Gastgeber: $host';
  }

  @override
  String get tourSharedBeat => 'schlug';

  @override
  String get tourSharedPens => ' (i. E.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Die Auszeichnungen werden vergeben, sobald das Turnier gespielt ist.';

  @override
  String get tourSharedGoldenBall => 'GOLDENER BALL';

  @override
  String get tourSharedPlayerOfTournament => 'Spieler des Turniers';

  @override
  String get tourSharedGoldenBoot => 'GOLDENER SCHUH';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tore',
      one: '1 Tor',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'GOLDENER HANDSCHUH';

  @override
  String get tourSharedTeamOfTournament => 'ELF DES TURNIERS';

  @override
  String get tourSharedStatsEmpty =>
      'Rekorde erscheinen, sobald der Wettbewerb etwas Geschichte hat.';

  @override
  String get tourSharedRecordScorer => 'REKORDTORSCHÜTZE';

  @override
  String get tourSharedStillActive => 'noch aktiv';

  @override
  String get tourSharedMostTitles => 'MEISTE TITEL';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Titel',
      one: '1 Titel',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'MEISTE FINALS';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Finals bestritten',
      one: '1 Finale bestritten',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'MEISTE EINSÄTZE';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spiele',
      one: '1 Spiel',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'MEISTE ENDRUNDEN';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Endrunden',
      one: '1 Endrunde',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'HÖCHSTER FINALSIEG';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tore',
      one: '1 Tor',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'noch aktiv';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Titel',
      one: '1 Titel',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Finals bestritten',
      one: '1 Finale bestritten',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spiele',
      one: '1 Spiel',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Endrunden',
      one: '1 Endrunde',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'EWIGE BESTENLISTE';

  @override
  String get tourStatsTabGames => 'Spiele';

  @override
  String get tourStatsTabCups => 'Turniere';

  @override
  String get tourStatsTabScorers => 'Torschützen';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'gg. $opponent · $year';
  }

  @override
  String get tourHolders => 'TITELVERTEIDIGER';

  @override
  String tourHoldersSince(int year) {
    return 'Sieger $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'EWIGE TORSCHÜTZENLISTE';

  @override
  String get tourSharedSummaryEmpty =>
      'Gastgeber und Stadien erscheinen, sobald diese Ausgabe ausgelost ist.';

  @override
  String get tourSharedHostHeading => 'GASTGEBER';

  @override
  String get tourSharedHostsHeading => 'GASTGEBER';

  @override
  String get tourSharedCoHostsHeading => 'CO-GASTGEBER';

  @override
  String get tourSharedVenues => 'SPIELORTE';

  @override
  String get tourSharedMascot => 'MASKOTTCHEN';

  @override
  String get tourSharedMatchBall => 'SPIELBALL';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity Plätze';
  }

  @override
  String get tourSharedCouldNotLoad => 'Laden fehlgeschlagen.';

  @override
  String get tourSharedHostTbc => 'GASTGEBER STEHT NOCH AUS';

  @override
  String get tourSharedFinalsAreHere => 'DIE ENDRUNDE IST DA';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'AUSGERICHTET VON  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Die Endrunde kann beginnen';

  @override
  String get tourSharedCompetitions => 'WETTBEWERBE';

  @override
  String get tourSharedWorldRanking => 'Weltrangliste';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Turniere konnten nicht geladen werden.';

  @override
  String get tourSharedPrestigeStage => 'GROSSE BÜHNE';

  @override
  String get tourSharedOverview => 'Übersicht';

  @override
  String get tourSharedWorldRankingTitle => 'Weltrangliste';

  @override
  String get tourSharedYourCompetitions => 'IHRE WETTBEWERBE';

  @override
  String get tourSharedOtherContinents => 'ANDERE KONTINENTE';

  @override
  String get tourSharedComingSoon => 'Turnier folgt in Kürze';

  @override
  String get tourSharedSoon => 'BALD';

  @override
  String get tourSharedNoQualifyingDraw => 'Keine Qualifikationsauslosung.';

  @override
  String get tourSharedOpenEnvelope => 'Umschlag öffnen';

  @override
  String tourSharedGroupName(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get tourSharedBall => 'Kugel';

  @override
  String get tourSharedPot => 'Topf';

  @override
  String get tourSharedAll => 'Alle';

  @override
  String get tourSharedTapDrawTeam => 'Tippen, um das nächste Team zu ziehen';

  @override
  String get tourSharedTapDrawPot => 'Tippen, um den nächsten Topf zu ziehen';

  @override
  String get tourSharedTapDrawAll =>
      'Tippen, um die ganze Auslosung aufzudecken';

  @override
  String get tourSharedContinue => 'Weiter';

  @override
  String get tourSharedPause => 'Pause';

  @override
  String get tourSharedPlay => 'Abspielen';

  @override
  String get tourSharedSkip => 'Überspringen';

  @override
  String tourSharedPotNumber(int number) {
    return 'TOPF $number';
  }

  @override
  String get tourSharedDrawComplete => 'AUSLOSUNG BEENDET';

  @override
  String get tourSharedDrawing => 'ZIEHUNG…';

  @override
  String get tourContChampionship => 'MEISTERSCHAFT';

  @override
  String get tourContTabSummary => 'ÜBERSICHT';

  @override
  String get tourContTabQualifying => 'QUALIFIKATION';

  @override
  String get tourContTabFinals => 'ENDRUNDE';

  @override
  String get tourContTabBracket => 'TURNIERBAUM';

  @override
  String get tourContTabAwards => 'PREISE';

  @override
  String get tourContTabScorers => 'TORSCHÜTZEN';

  @override
  String get tourContTabHistory => 'HISTORIE';

  @override
  String get tourContTabRecords => 'REKORDE';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Turnier konnte nicht geladen werden.\n$error';
  }

  @override
  String get tourContNoCupData => 'Keine Turnierdaten.';

  @override
  String get tourContUnknown => 'Unbekannt';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Die Qualifikationsgruppen werden bei der Zeremonie ausgelost. Verfolgen Sie sie auf dem Startbildschirm, um Ihre Gegner zu erfahren.';

  @override
  String get tourContQualSeeded =>
      'Ihre Nation ist direkt für die Endrunde gesetzt. Keine Qualifikation in diesem Zyklus.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name wird im Hintergrund simuliert. Die Ergebnisse erscheinen hier nach jeder Runde.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Die Gruppen der Endrunde werden bei der Zeremonie ausgelost. Verfolgen Sie sie auf dem Startbildschirm, um Ihre Gruppe zu erfahren.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Die Endrunde wird ausgelost, sobald die Qualifikation beendet ist.';

  @override
  String get tourContContestedBeforeWc =>
      'Die K.-o.-Runden werden vor der Weltmeisterschaft ausgetragen.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name: SIEGER';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name: Sieger';
  }

  @override
  String get tourContNoGoalsYet => 'Noch keine Tore.';

  @override
  String tourContGroupHeading(String name) {
    return 'GRUPPE $name';
  }

  @override
  String get tourContBestRunnersUp => 'BESTE ZWEITE';

  @override
  String tourContGroupDropdown(String name) {
    return 'Gruppe $name';
  }

  @override
  String get tourContMatches => 'SPIELE';

  @override
  String get tourContNoGroupsDrawn => 'Noch keine Gruppen ausgelost.';

  @override
  String get tourContQualifyingDraw => 'QUALI-AUSLOSUNG';

  @override
  String get tourContWorldQualifyingDraw => 'WM-QUALI-AUSLOSUNG';

  @override
  String get tourContFinalsDraw => 'ENDRUNDEN-AUSLOSUNG';

  @override
  String get tourContSeedingPots => 'LOSTÖPFE';

  @override
  String get tourContGroupDraw => 'GRUPPENAUSLOSUNG';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Auslosung konnte nicht geladen werden.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Die Auslosung ist noch nicht bereit.';

  @override
  String get tourContContinentalClash => 'KONTINENTAL-DUELL';

  @override
  String get tourContTabThisCycle => 'DIESER ZYKLUS';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Laden fehlgeschlagen.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Spielstand nicht gefunden.';

  @override
  String get tourContClashSoon =>
      'Das Kontinental-Duell wird ausgetragen, sobald beide Kontinentalmeister feststehen.';

  @override
  String get tourContTwoContinentsOneMatch => 'ZWEI KONTINENTE, EIN SPIEL';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name gewinnt das Duell';
  }

  @override
  String get tourContNoClashYet => 'Noch kein Kontinental-Duell gespielt.';

  @override
  String get tourContNationsCup => 'NATIONENPOKAL';

  @override
  String get tourContTabLeagues => 'LIGEN';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Laden fehlgeschlagen.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Noch keine Tore im Pokal der Nationen.';

  @override
  String get tourContNoNationsCupChampions =>
      'Noch kein Sieger im Pokal der Nationen.';

  @override
  String get tourContNationsCupOffSeason =>
      'Der Pokal der Nationen dieses Zyklus beginnt nach der Kontinental-Endrunde. Frühere Sieger finden Sie unter Historie.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Die Gruppen des Pokal der Nationen werden bei der Zeremonie ausgelost. Verfolgen Sie sie auf dem Startbildschirm, um Ihre Gegner zu erfahren.';

  @override
  String get tourContLeagueNoGroups =>
      'In dieser Liga keine Spiele in dieser Runde.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LIGA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LIGA $letter · IHRE LIGA';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Das Final Four bestreiten die Gruppensieger der Liga A nach der Gruppenphase.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Liga $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Liga $letter ★';
  }

  @override
  String get tourContSemiFinals => 'HALBFINALE';

  @override
  String get tourContFinal => 'FINALE';

  @override
  String get tourContNationsCupDraw => 'NATIONENPOKAL-AUSLOSUNG';

  @override
  String get tourContIntercontinentalPlayoff => 'INTERKONTINENTALES PLAY-OFF';

  @override
  String get tourContNoPlayoffThisCycle => 'Kein Play-off in diesem Zyklus.';

  @override
  String get tourContPlayoffIntro =>
      'Zwei WM-Plätze werden im K.-o.-Modus unter den besten Gescheiterten der Qualifikation vergeben.';

  @override
  String get tourContPlayoffThrough =>
      'Sie haben das Play-off überstanden. Sie fahren zur Weltmeisterschaft!';

  @override
  String get tourContPlayoffOut =>
      'Im Play-off gescheitert. Diesmal keine Weltmeisterschaft.';

  @override
  String get tourContContinue => 'Weiter';

  @override
  String get tourContPlayoffFinals => 'PLAY-OFF-FINALS';

  @override
  String get tourContPlayoffSeeded => 'Gesetzt (Freilos)';

  @override
  String get tourCupTabSummary => 'ÜBERSICHT';

  @override
  String get tourCupTabQualifying => 'QUALIFIKATION';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'Das interkontinentale Play-off wird ausgetragen, sobald die Qualifikation aller Konföderationen beendet ist.';

  @override
  String get tourCupTabFinals => 'ENDRUNDE';

  @override
  String get tourCupTabBracket => 'TURNIERBAUM';

  @override
  String get tourCupTabAwards => 'PREISE';

  @override
  String get tourCupTabScorers => 'TORSCHÜTZEN';

  @override
  String get tourCupTabHistory => 'HISTORIE';

  @override
  String get tourCupTabRecords => 'REKORDE';

  @override
  String get tourCupTitle => 'WELTMEISTERSCHAFT';

  @override
  String get tourCupNoData => 'Keine Turnierdaten.';

  @override
  String tourCupLoadError(String error) {
    return 'Turnier konnte nicht geladen werden.\n$error';
  }

  @override
  String get tourCupUnknown => 'Unbekannt';

  @override
  String get tourCupWorldChampions => 'WELTMEISTER';

  @override
  String get tourCupWorldChampionsTitle => 'Weltmeister';

  @override
  String get tourCupStillActive => 'Noch aktiv';

  @override
  String get tourCupAllTimeScorers => 'EWIGE TORSCHÜTZENLISTE';

  @override
  String get tourCupAllConfederations => 'Alle Konföderationen';

  @override
  String get tourCupBestRunnersUp => 'Beste Zweite';

  @override
  String get tourCupCompWorld => 'Weltmeisterschaft';

  @override
  String get tourCupCompEurope => 'Europameisterschaft';

  @override
  String get tourCupCompSAmerica => 'Südamerika-Pokal';

  @override
  String get tourCupDestRoundOf16 => 'das Achtelfinale';

  @override
  String get tourCupDestKnockouts => 'die K.-o.-Runde';

  @override
  String get tourCupDestFinals => 'die Endrunde';

  @override
  String get tourCupDestFinalsPlayoff => 'das Endrunden-Play-off';

  @override
  String get tourCupDestIntercontPlayoff => 'das interkontinentale Play-off';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Die Endrunde wird nach der Qualifikation ausgelost.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Die Gruppen werden noch ausgelost. Verfolgen Sie die WM-Auslosung auf dem Startbildschirm.';

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
    return 'Gastgeber: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Gastgeber: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Interkontinentales Play-off';

  @override
  String get tourCupKnockoutSoon =>
      'Der Turnierbaum beginnt nach der Gruppenphase.';

  @override
  String get tourCupMatches => 'SPIELE';

  @override
  String get tourCupMedalTable => 'MEDAILLENSPIEGEL';

  @override
  String get tourCupMostTitles => 'MEISTE TITEL';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles Titel in $editions Ausgaben';
  }

  @override
  String get tourCupNoGoals => 'Noch keine Tore.';

  @override
  String get tourCupNoGroups => 'Keine Gruppen ausgelost.';

  @override
  String get tourCupNoHistory => 'Noch keine Historie.';

  @override
  String get tourCupPastWinners => 'FRÜHERE SIEGER';

  @override
  String get tourCupPlayoffIntro =>
      'Zwei WM-Plätze werden im K.-o.-Modus unter den besten Gescheiterten der Qualifikation vergeben.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation spielt kein Play-off: Alle Plätze werden in den Qualifikationsgruppen vergeben.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Die Gruppen werden noch ausgelost. Verfolgen Sie die Qualifikationsauslosung auf dem Startbildschirm.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · Ihre';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (i.E.)';
  }

  @override
  String get tourCupSegAllTime => 'Ewig';

  @override
  String get tourCupSegFinals => 'Endrunde';

  @override
  String get tourCupSegQualifying => 'Quali';

  @override
  String get playerTraitsTitle => 'BEKANNT FÜR';

  @override
  String get traitBigGame => 'Mann für große Spiele';

  @override
  String get traitBigGameBlurb => 'Steigert sich in K.-o.-Spielen.';

  @override
  String get traitSetPiece => 'Standardspezialist';

  @override
  String get traitSetPieceBlurb =>
      'Bessere Hereingaben und mehr Tore nach Standards.';

  @override
  String get traitHothead => 'Hitzkopf';

  @override
  String get traitHotheadBlurb =>
      'Sieht deutlich mehr Karten als seine Mitspieler.';

  @override
  String get traitIronMan => 'Eisenmann';

  @override
  String get traitIronManBlurb => 'Verletzt sich selten und ermüdet langsamer.';

  @override
  String get traitWonderkid => 'Wunderkind';

  @override
  String get traitWonderkidBlurb =>
      'Jung, schon gut und verbessert sich noch rasant.';

  @override
  String get traitLeader => 'Führungsspieler';

  @override
  String get traitLeaderBlurb => 'Reißt jeden Mitspieler auf dem Platz mit.';

  @override
  String get traitPacey => 'Pfeilschnell';

  @override
  String get traitPaceyBlurb => 'Enormes Tempo, gefährlich in die Tiefe.';

  @override
  String get traitOldHead => 'Routinier';

  @override
  String get traitOldHeadBlurb =>
      'Ein Veteran, dessen Spielverständnis länger hält als seine Beine.';

  @override
  String get traitWasteful => 'Chancentod';

  @override
  String get traitWastefulBlurb => 'Vergibt zu viele gute Chancen.';

  @override
  String get objectiveWorldCup => 'Weltmeisterschaft';

  @override
  String get objectiveWinTournament => 'Titel holen';

  @override
  String get objectiveQualifyGeneric => 'Qualifikation';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Weltmeister werden';

  @override
  String get objectiveReachFinal => 'Finale erreichen';

  @override
  String get objectiveReachSemis => 'Halbfinale erreichen';

  @override
  String get objectiveReachQuarters => 'Viertelfinale erreichen';

  @override
  String get objectiveReachKnockouts => 'K.-o.-Runde erreichen';

  @override
  String get objectiveQualify => 'Für die WM qualifizieren';

  @override
  String get finishChampions => 'Sieger';

  @override
  String get finishRunnersUp => 'Finalist';

  @override
  String get finishSemiFinals => 'Halbfinale';

  @override
  String get finishQuarterFinals => 'Viertelfinale';

  @override
  String get finishRoundOf16 => 'Achtelfinale';

  @override
  String get finishGroupStage => 'Gruppenphase';

  @override
  String get objectiveQualifyingTopHalf =>
      'In der Qualifikation obere Tabellenhälfte';

  @override
  String get finishQualifyingTopHalf => 'Obere Hälfte der Qualigruppe';

  @override
  String get finishQualifyingBottomHalf => 'Untere Hälfte der Qualigruppe';

  @override
  String get objectiveNcWinIt => 'Pokal der Nationen gewinnen';

  @override
  String get objectiveNcReachFinal => 'Finale im Pokal der Nationen erreichen';

  @override
  String get objectiveNcFinalsFour => 'Final Four erreichen';

  @override
  String get objectiveNcWinGroup => 'Gruppensieg und Aufstieg';

  @override
  String get objectiveNcTopHalf => 'Obere Hälfte der Gruppe';

  @override
  String get objectiveNcSurvive => 'Abstieg vermeiden';

  @override
  String get objectiveNcOffTheBottom => 'Nicht Gruppenletzter werden';

  @override
  String get finishNcChampions => 'Sieger im Pokal der Nationen';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Gruppensieger';

  @override
  String get finishNcTopHalf => 'Obere Gruppenhälfte';

  @override
  String get finishNcStayedUp => 'Klassenerhalt';

  @override
  String get finishNcClearOfBottom => 'Nicht Gruppenletzter';

  @override
  String get finishNcBottom => 'Gruppenletzter';

  @override
  String get careerNationsCupLabel => 'Pokal der Nationen';

  @override
  String get squadDevPlayer => 'SPIELER';

  @override
  String get squadDevAge => 'ALTER';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'WERT';

  @override
  String get squadDevNew => 'NEU';

  @override
  String get squadDevRetired => 'ZURÜCKGETR.';

  @override
  String get squadDevEmpty => 'Ein ruhiges Jahr. Keine Veränderungen im Kader.';

  @override
  String get squadDevTierRegulars => 'STAMMKRÄFTE';

  @override
  String get squadDevTierFringe => 'ERWEITERTER KREIS';

  @override
  String get squadDevTierYouth => 'NACHWUCHS';

  @override
  String get boardObjectivesTitle => 'Ziele des Präsidiums';

  @override
  String get boardObjectivesConfidence => 'Vertrauen des Präsidiums';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds Runden besser als gefordert',
      one: 'eine Runde besser als gefordert',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds Runden zu früh raus',
      one: 'eine Runde zu früh raus',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'NOCH OFFEN';

  @override
  String boardObjectiveSoFar(String result) {
    return 'BISHER · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Das Präsidium hat für diesen Zyklus kein Ziel gesetzt.';

  @override
  String get tourContBestWinners => 'BESTE GRUPPENSIEGER';

  @override
  String get tourContBestThirds => 'BESTE GRUPPENDRITTE';

  @override
  String tourContBestPlaced(String position) {
    return 'BESTE $position. PLATZIERTE';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total Spieler';
  }

  @override
  String get matchSoldOut => 'AUSVERKAUFT';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance von $capacity Plätzen besetzt';
  }

  @override
  String get matchGroundTitle => 'SPIELORT';

  @override
  String get absenceInjured => 'Verletzt';

  @override
  String get absenceSuspended => 'Gesperrt';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Wochen',
      one: '1 Woche',
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
      other: '$countString Spiele',
      one: '1 Spiel',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Zurück gegen $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Elfmeter';

  @override
  String get penaltyOrderBlurb =>
      'Bestimmen Sie Ihre fünf Schützen in Reihenfolge. Tippen Sie auf einen Platz, um ihn zu ändern.';

  @override
  String penaltyOrderPick(int number) {
    return 'Schuss $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Wählen Sie, wer antritt. Der Balken zeigt seine Nervenstärke vom Punkt.';

  @override
  String get penaltyOrderConfirm => 'Los geht\'s';

  @override
  String get penaltyOrderCancel => 'Zurück';

  @override
  String get youthTitle => 'Nachwuchs';

  @override
  String get youthEmptyLevel => 'Auf dieser Stufe noch niemand.';

  @override
  String get youthReleased => 'Dieses Jahr aussortiert';

  @override
  String get u21Title => 'U21';

  @override
  String get u21Blurb =>
      'Die nächste Generation, bestes Talent zuerst. Hohle Sterne sind eine Schätzung der Scouts. Setzen Sie einen Spieler ein, um zu sehen, was wirklich in ihm steckt.';

  @override
  String get u21Empty =>
      'Derzeit niemand unter 21 im Spielerpool. Der nächste Jahrgang kommt mit dem neuen Zyklus.';

  @override
  String u21Breakout(int gain) {
    return '+$gain DIESES JAHR';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Alter $age · $caps Länderspiele';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Alter $age · ohne Länderspiel';
  }

  @override
  String get u21CallUps => 'Zur Nominierung';

  @override
  String get youthWatching => 'Beobachtet';

  @override
  String get youthWatchEmpty =>
      'Noch niemand markiert. Markieren Sie einen Jungen auf irgendeiner Stufe, und er erscheint hier, mit seiner Entwicklung seitdem.';

  @override
  String get youthWatchMark => 'Diesen Jungen beobachten';

  @override
  String get youthWatchUnmark => 'Nicht mehr beobachten';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Markiert mit $rating, im Alter von $age';
  }

  @override
  String get youthWatchSenior => 'In den A-Kader-Pool aufgerückt';

  @override
  String get youthWatchReleased => 'Von der Akademie aussortiert';

  @override
  String get youthWatchGone => 'Nicht mehr in der Pyramide';

  @override
  String get tacticsYouth => 'U21';

  @override
  String get pressSquad => 'Kader';

  @override
  String get pressBoard => 'Präsidium';

  @override
  String get pressNoEffect => 'Niemand misst dem viel Bedeutung bei';

  @override
  String get matchNeutralGround => 'NEUTRAL';

  @override
  String get matchExtraTimeAhead => 'VERLÄNGERUNG';

  @override
  String get matchExtraTimeHalf => 'VERLÄNGERUNG · HALBZEIT';

  @override
  String get matchClockFullTime => 'ABPFIFF';

  @override
  String get matchClockAfterExtraTime => 'NACH VERLÄNGERUNG';

  @override
  String get matchClockPenalties => 'ELFMETERSCHIESSEN';

  @override
  String get matchClockFullTimePenalties => 'ENDE · i.E.';

  @override
  String get hubEventPressConference => 'Vor die Presse treten';

  @override
  String get hubEventPressConferenceSub =>
      'Die Weltpresse will Sie vor Ihrem ersten Spiel sprechen';

  @override
  String get squadDevWonderkid => 'WUNDERKIND';

  @override
  String get tacticsPlaystyle => 'Spielstil';

  @override
  String get tacticsPlaystyleBlurb =>
      'Wählen Sie, wie Ihr Team spielt; die Regler unten justieren das fein.';

  @override
  String get tacticsPlaystyleCustom =>
      'Eigene Einstellungen. Kein benannter Stil passt zu diesen Reglern.';

  @override
  String get playstyleCustom => 'Eigener';

  @override
  String get playstyleBalanced => 'Ausgewogen';

  @override
  String get playstylePossession => 'Ballbesitz';

  @override
  String get playstyleGegenpress => 'Gegenpressing';

  @override
  String get playstyleCounter => 'Konter';

  @override
  String get playstyleDirect => 'Direkt';

  @override
  String get playstyleLowBlock => 'Tiefer Block';

  @override
  String get playstyleWingPlay => 'Flügelspiel';

  @override
  String get playstyleBalancedBlurb =>
      'Stabil in beiden Hälften, nichts übertrieben.';

  @override
  String get playstylePossessionBlurb =>
      'Den Ball halten, geduldig zirkulieren lassen, den Gegner einschnüren.';

  @override
  String get playstyleGegenpressBlurb =>
      'Den Ball sofort nach Verlust hoch im Feld zurückerobern.';

  @override
  String get playstyleCounterBlurb =>
      'Abwarten, kompakt stehen, dann blitzschnell umschalten.';

  @override
  String get playstyleDirectBlurb =>
      'Früh nach vorn und auf den zweiten Ball gehen.';

  @override
  String get playstyleLowBlockBlurb => 'Tief, eng und kaum zu knacken.';

  @override
  String get playstyleWingPlayBlurb =>
      'Das Feld breit machen, außen durchbrechen und flanken.';

  @override
  String get nationsRandomTeam => 'Zufallsteam';

  @override
  String get nationsFromTheBottom => 'Ganz unten anfangen';

  @override
  String get bottomStartTitle => 'Arbeitslos';

  @override
  String get bottomStartHeading => 'Drei Verbände wollen reden';

  @override
  String get bottomStartBlurb =>
      'Sie haben keinen Job und kein Ansehen. Nur diese Teams wollen es mit Ihnen versuchen. Nehmen Sie eines an und bauen Sie etwas aus dem Nichts auf.';

  @override
  String get bottomStartAccept => 'Annehmen';

  @override
  String get bottomStartBack => 'Zurück zum Menü';

  @override
  String bottomStartRankOf(int rank, int total) {
    return 'Platz $rank von $total weltweit';
  }

  @override
  String get campTitle => 'Teamquartier';

  @override
  String campBasedIn(String host) {
    return 'Quartier in $host';
  }

  @override
  String get campBlurb =>
      'Hier wohnt der Kader während des ganzen Turniers. Nach Turnierbeginn ist kein Wechsel mehr möglich, und es wirkt in jedem Spiel auf drei Dinge: wie frisch die Spieler ankommen, wie schnell Blessuren heilen und wie spritzig sie sind.';

  @override
  String get campEffectTravel => 'Frische Anreise';

  @override
  String get campEffectRecovery => 'Heilung';

  @override
  String get campEffectSharpness => 'Spritzigkeit';

  @override
  String get campTerrainCity => 'Stadtzentrum';

  @override
  String get campTerrainCoastal => 'Küstenresort';

  @override
  String get campTerrainMountain => 'Bergrefugium';

  @override
  String get campTerrainAltitude => 'Höhencamp';

  @override
  String get campTerrainNationalCentre => 'Leistungszentrum';

  @override
  String get campTerrainCityBlurb =>
      'Alles vor der Haustür und keine Anreise, aber keine Ruhe und kein Entkommen vor dem Trubel.';

  @override
  String get campTerrainCoastalBlurb =>
      'Ruhig, komfortabel und gut für die Stimmung; lange Busfahrten zu jedem Stadion.';

  @override
  String get campTerrainMountainBlurb =>
      'Kühle Luft und eine erstklassige medizinische Abteilung, die Blessuren schnell kuriert, weit weg vom Turnier.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Hartes Training, aber Beine, die bis tief ins Turnier halten.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Die eigene Anlage des Verbands: nichts Spektakuläres, nichts, was schiefgehen kann.';

  @override
  String get hubEventChooseCamp => 'Teamquartier wählen';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Wo der Kader in $host wohnen wird';
  }

  @override
  String get tacticsTabBench => 'Bank';

  @override
  String get squadSearchHint => 'Nach Name oder Verein suchen';

  @override
  String get squadFilterAll => 'Alle';

  @override
  String get squadFilterInSquad => 'Im Kader';

  @override
  String get squadFilterUncapped => 'Ohne Länderspiel';

  @override
  String get squadFilterUnavailable => 'Nicht verfügbar';

  @override
  String get squadLineAll => 'Alle Mannschaftsteile';

  @override
  String get squadSortBy => 'Sortieren';

  @override
  String get squadSortRating => 'Wertung';

  @override
  String get squadSortCaps => 'Länderspiele';

  @override
  String get squadSortGoals => 'Tore';

  @override
  String get squadSortAge => 'Alter';

  @override
  String get squadSortName => 'Name';

  @override
  String get squadLegendTitle => 'Was die Symbole bedeuten';

  @override
  String get squadLegendStarting => 'In Ihrer Startelf';

  @override
  String get squadLegendCalledUp => 'Nominiert, auf der Bank';

  @override
  String get squadLegendRatingUp => 'Wertung steigt dieses Jahr';

  @override
  String get squadLegendRatingDown => 'Wertung sinkt dieses Jahr';

  @override
  String get squadLegendInjured => 'Verletzt, nicht verfügbar';

  @override
  String get squadLegendSuspended => 'Gesperrt, nicht verfügbar';

  @override
  String get squadLegendTraits => 'BEKANNT FÜR';

  @override
  String squadShowingOf(int shown, int total) {
    return '$shown von $total Spielern';
  }

  @override
  String get squadNobodyMatches =>
      'Kein Spieler im Pool passt zu diesen Filtern.';

  @override
  String get squadStatPool => 'Pool';

  @override
  String get squadStatInSquad => 'Nominiert';

  @override
  String get squadMostCapped => 'Rekordnationalspieler';

  @override
  String get squadTopScorer => 'Toptorschütze';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps Länderspiele';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals Tore';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Sp.';

  @override
  String get squadGoalsShort => 'Tore';

  @override
  String get recordsRecordBookSubtitle =>
      'Länderspiele, Tore und die wichtigsten Teamrekorde';

  @override
  String get statsLegacy => 'VERMÄCHTNIS';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name wurde bereits ausgewechselt und kann nicht zurückkommen.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name wurde vom Platz gestellt und spielt nicht mehr mit.';
  }

  @override
  String get tacticsInjuredShort => 'VERLETZT';

  @override
  String get tacticsSuspendedShort => 'GESPERRT';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'Südamerika';

  @override
  String get confNorthAmerica => 'Nordamerika';

  @override
  String get confAfrica => 'Afrika';

  @override
  String get confAsia => 'Asien';

  @override
  String get confOceania => 'Ozeanien';

  @override
  String get compWorldCup => 'Weltmeisterschaft';

  @override
  String get compWorldCupFinals => 'WM-Endrunde';

  @override
  String get compWorldCupQualifying => 'WM-Qualifikation';

  @override
  String compQualifiers(String region) {
    return 'Qualifikation $region';
  }

  @override
  String get compFriendlies => 'Testspiele';

  @override
  String get compNationsCup => 'Pokal der Nationen';

  @override
  String get compContinentalClash => 'Kontinental-Duell';

  @override
  String get compIntercontinentalPlayoff => 'Interkontinentales Play-off';

  @override
  String get compContinentalChampionship => 'Kontinentalmeisterschaft';

  @override
  String get compEuropeanChampionship => 'Europameisterschaft';

  @override
  String get compSouthAmericaCup => 'Südamerika-Pokal';

  @override
  String get compAfricanChampionship => 'Afrikameisterschaft';

  @override
  String get compAsianChampionship => 'Asienmeisterschaft';

  @override
  String get compNorthAmericaCup => 'Nordamerika-Pokal';

  @override
  String get compOceaniaCup => 'Ozeanien-Pokal';

  @override
  String get msgANation => 'Eine Nation';

  @override
  String get msgAPlayer => 'Ein Spieler';

  @override
  String get msgAHostNation => 'ein Gastgeberland';

  @override
  String get msgCycleTitle1 => 'Ein neuer Zyklus beginnt';

  @override
  String msgCycleTitle2(int year) {
    return 'Der Weg nach $year beginnt';
  }

  @override
  String get msgCycleTitle3 => 'Eine neue Kampagne bricht an';

  @override
  String get msgCycleTitle4 => 'Zurück an die Arbeit';

  @override
  String msgCycleBody1(int year) {
    return 'Hier beginnt der Weg zur Weltmeisterschaft $year.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Ein neuer Zyklus. Das Ziel ist die Weltmeisterschaft $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Vier Jahre bis zur Weltmeisterschaft $year. Die Arbeit beginnt jetzt.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Die Kampagne $year beginnt heute.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup, Gastgeber: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host richtet die nächste $cup aus.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup: Qualifikationsauslosung';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Die Qualifikationsgruppen für $cup wurden ausgelost.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'WM $year, Gastgeber: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host richtet die Weltmeisterschaft $year aus.';
  }

  @override
  String get msgWcQualDrawTitle => 'WM-Qualifikationsauslosung';

  @override
  String get msgWcQualDrawBody =>
      'Die Gruppen der WM-Qualifikation wurden ausgelost.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup: Endrundenauslosung';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Die Endrundengruppen für $cup wurden ausgelost.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'WM-Endrundenauslosung';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Die Endrunde der Weltmeisterschaft $year wurde ausgelost.';
  }

  @override
  String get msgQualWcTitle1 => 'Ab zur Weltmeisterschaft';

  @override
  String get msgQualWcTitle2 => 'WM-Ticket gelöst';

  @override
  String get msgQualWcTitle3 => 'Wir fahren zur WM';

  @override
  String get msgQualWcTitle4 => 'Ticket gebucht';

  @override
  String msgQualWcBody1(int year) {
    return 'Sie haben sich für die Endrunde der Weltmeisterschaft $year qualifiziert.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Jetzt ist es offiziell: Ihre Nation ist bei der Weltmeisterschaft $year dabei.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Der Platz bei der Weltmeisterschaft $year ist gesichert.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Sie stehen in der Endrunde der Weltmeisterschaft $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Qualifiziert: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup gebucht';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Für $cup qualifiziert';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Sie haben sich für die Endrunde von $cup qualifiziert.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Ihre Nation hat ihren Platz bei $cup sicher.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Sie sind bei $cup dabei.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: SIEGER!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Sieger bei $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Sie haben $comp gewonnen!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp entschieden';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: Sieger gekürt';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp ist vergeben';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Ihre Nation gewinnt $comp $year und schlägt $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Sie haben $comp $year gewonnen und $loser$result bezwungen.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year gehört Ihnen. $loser geschlagen$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner gewinnt $comp $year und schlägt $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner holt den Titel bei $comp $year und besiegt $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' mit $home–$away im Finale';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' im Elfmeterschießen nach einem $home–$away im Finale';
  }

  @override
  String get msgWpotyTitle => 'Weltfußballer des Jahres';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) ist Weltfußballer des Jahres $year, einer Ihrer Spieler.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) ist Weltfußballer des Jahres $year.';
  }

  @override
  String get msgYpotTitle => 'Bester junger Spieler des Turniers';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age Jahre alt, ist bester junger Spieler des Turniers $year, einer Ihrer Spieler.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age Jahre alt, ist bester junger Spieler des Turniers $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Sie halten Platz $rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Keine Veränderung, weiter Platz $rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabil auf Platz $rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move Plätze',
      one: '1 Platz',
    );
    return 'Insgesamt $_temp0 nach oben, auf Platz $rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move Plätze',
      one: '1 Platz',
    );
    return 'Ein Sprung um $_temp0 bringt Sie auf Platz $rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move Plätze',
      one: '1 Platz',
    );
    return '$_temp0 nach oben, jetzt Platz $rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move Plätze',
      one: '1 Platz',
    );
    return 'Insgesamt $_temp0 nach unten, auf Platz $rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move Plätze',
      one: '1 Platz',
    );
    return 'Ein Absturz um $_temp0 wirft Sie auf Platz $rank zurück.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move Plätze',
      one: '1 Platz',
    );
    return '$_temp0 nach unten, jetzt Platz $rank.';
  }

  @override
  String get msgRankLeadYou => 'Sie sind die Nummer eins der Welt.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation ist die Nummer eins der Welt.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Weltrangliste · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Die Weltrangliste wurde aktualisiert. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Sprung auf #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Absturz auf #$rank';
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
      other: '$move Plätzen',
      one: '1 Platz',
    );
    return '$tournament hat die Weltrangliste verändert. $nation ging als #$from hinein und kam als #$to heraus, ein Plus von $_temp0.';
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
      other: '$move Plätzen',
      one: '1 Platz',
    );
    return '$tournament hat die Weltrangliste verändert. $nation ging als #$from hinein und kam als #$to heraus, ein Minus von $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Seit der WM-Auslosung';

  @override
  String get rankingSinceCycleStart => 'Seit Beginn der Kampagne';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from auf #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name erreicht $count Länderspiele';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name hat nun $count Länderspiele für Ihre Nation bestritten.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name erreicht $count Tore';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name hat $count Länderspieltore für Ihre Nation erzielt.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Kaderentwicklung · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Aus der Akademie aufgerückt · $year';
  }

  @override
  String get msgThroughNote =>
      'Das ist kein neuer Jahrgang. Es sind die Jungen, die mit elf kamen und nun in den A-Kader-Pool hineingewachsen sind.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Neue Gesichter · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Die Investitionen in die Akademie zahlen sich aus: Dieser Jahrgang ist stärker als er sonst gewesen wäre.';

  @override
  String get msgIntakeNoteStanding =>
      'Das Land schaut auf dieses Team: Weil es in der Weltrangliste klettert, entscheiden sich die besten Jungen für Fußball, und dieser Jahrgang ist dadurch stärker.';

  @override
  String get msgIntakeNoteBoth =>
      'Das Geld für die Akademie und der Aufstieg in der Weltrangliste zahlen sich beide aus: Dieser Jahrgang ist stärker als er sonst gewesen wäre.';

  @override
  String msgIntakeTitle(int year) {
    return 'Akademie-Jahrgang · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Ihr Kapitän $name tritt zurück';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name tritt aus der Nationalmannschaft zurück';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name hat mit $age seinen Rücktritt aus der Nationalmannschaft erklärt.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name hat mit $age seinen Rücktritt aus der Nationalmannschaft erklärt und verabschiedet sich mit $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Länderspielen',
      one: '1 Länderspiel',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Toren',
      one: '1 Tor',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Die Kapitänsbinde ist frei. Bestimmen Sie im Nominierungsbildschirm einen neuen Kapitän.';

  @override
  String msgHofTitle(String name) {
    return '$name in die Ruhmeshalle aufgenommen';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name wird in die Ruhmeshalle Ihrer Nation aufgenommen ($caps Länderspiele, $goals Tore). Zu sehen unter Legenden.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name gesperrt';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'die nächsten $matches Spiele',
      one: 'das nächste Spiel',
    );
    return '$name $how und ist für $_temp0 gesperrt. Er steht nicht zur Auswahl.';
  }

  @override
  String get hubBanHowSecondYellow => 'sah Gelb-Rot';

  @override
  String get hubBanHowViolent => 'sah wegen einer Tätlichkeit glatt Rot';

  @override
  String get hubBanHowRed => 'wurde vom Platz gestellt';

  @override
  String hubInjuryTitle(String name) {
    return '$name verletzt';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches Spiele',
      one: '1 Spiel',
    );
    return '$name hat sich verletzt und fällt für $_temp0 aus.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Vizemeister';

  @override
  String get hubRunnerUpTitle2 => 'So nah und doch so fern';

  @override
  String get hubRunnerUpTitle3 => 'Silbermedaillen';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Sie standen im Finale von $cup, verloren aber gegen $opponent. So knapp. Diesmal Silber.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Im Finale von $cup an $opponent gescheitert. Zweiter, quälend knapp.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Das Finale von $cup ging gegen $opponent verloren. Viel, worauf man stolz sein kann, aber nicht der Pokal.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Ausgeschieden';

  @override
  String get hubKnockedOutTitle2 => 'Endstation';

  @override
  String get hubKnockedOutTitle3 => 'Die Reise ist vorbei';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Sie sind bei $cup ausgeschieden, geschlagen von $opponent im $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent beendet Ihr Turnier $cup im $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Ihr Turnier $cup endet im $stage, geschlagen von $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Aus in der Gruppenphase';

  @override
  String get hubGroupExitTitle2 => 'In der Gruppenphase gescheitert';

  @override
  String get hubGroupExitTitle3 => 'Früher Feierabend';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Für Sie ist $cup nach der Gruppenphase vorbei. Es reichte nicht für die K.-o.-Runde.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Sie sind nicht aus der Gruppe gekommen. $cup endet hier für Sie.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Diesmal kein Platz in der K.-o.-Runde. $cup ist für Sie nach der Gruppenphase beendet.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Ziel erreicht: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Ziel verfehlt: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Das Ziel des Präsidiums bei $comp: $demand. Ihr Abschneiden: $finish. Das Präsidium hat, was es wollte.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Das Ziel des Präsidiums bei $comp: $demand. Ihr Abschneiden: $finish. Das bleibt hinter den Erwartungen zurück.';
  }

  @override
  String get newsWcMissTitle => 'WM-Traum geplatzt';

  @override
  String newsWcMissBody(int year) {
    return 'Sie haben die Weltmeisterschaft $year verpasst. Die Qualifikation reichte nicht. Noch vier Jahre.';
  }

  @override
  String get newsRecordScorerTitle => 'Ewiger Rekordtorschütze';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name ist mit $goals Toren nun der erfolgreichste Torschütze aller Zeiten.';
  }

  @override
  String get newsRecordCapsTitle => 'Rekordnationalspieler';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name ist mit $caps Einsätzen nun der Spieler mit den meisten Länderspielen aller Zeiten.';
  }

  @override
  String get newsARecordBreaker => 'Ein neuer Rekordhalter';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name wechselt zu $club';
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
    return '$name ($position, $rating) verlässt $fromClub und unterschreibt für $fee bei $destination.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Ablösefrei';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name würde zu $nation wechseln!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name will für $nation spielen';
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
    return '$name, $age Jahre, $position mit Wertung $rating, derzeit bei $fromNation, hat familiäre Bindungen zu $nation und ist offen für einen Wechsel. Öffnen Sie das Einbürgerungsangebot, um anzunehmen oder abzulehnen.';
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
    return '$name, $age Jahre, $position mit Wertung $rating, derzeit bei $fromNation, ist ein Star mit familiären Bindungen zu $nation und offen für einen Wechsel. Öffnen Sie das Einbürgerungsangebot, um anzunehmen oder abzulehnen.';
  }

  @override
  String get newsTheirNation => 'seiner Nation';

  @override
  String get newsYourNation => 'Ihrer Nation';

  @override
  String get tourStatusChampions => 'SIEGER';

  @override
  String get tourStatusFinals => 'ENDRUNDE';

  @override
  String get tourStatusQualifying => 'QUALIFIKATION';

  @override
  String get tourStatusUpcoming => 'DEMNÄCHST';

  @override
  String get tourStatusInProgress => 'LÄUFT';

  @override
  String get tourStatusComingSoon => 'IN KÜRZE';

  @override
  String get tourStatusDecided => 'ENTSCHIEDEN';

  @override
  String tourStatusLeague(String letter) {
    return 'LIGA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'WM-QUALI-AUSLOSUNG';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup: QUALI-AUSLOSUNG';
  }

  @override
  String get tourDrawWcHost => 'WM-GASTGEBER';

  @override
  String tourDrawContHost(String cup) {
    return '$cup: GASTGEBER';
  }

  @override
  String get tourDrawHostsReveal => 'Und die Gastgeber sind…';

  @override
  String get tourDrawHostReveal => 'Und der Gastgeber ist…';

  @override
  String get tourDrawHostCandidates => 'Die Kandidaten im Rennen:';

  @override
  String get tourKickoffContinentalCup => 'KONTINENTALPOKAL';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup verpasst';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Sie haben sich nicht für $cup qualifiziert. Diesmal reichte es nicht.';
  }

  @override
  String get potyLabelBest => 'Spieler des Jahres';

  @override
  String get potyLabelYoung => 'Bester junger Spieler des Jahres';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Vorlagen',
      one: '1 Vorlage',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Wertung $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Note $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Weltfußballer des Jahres $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name ist der beste Spieler der Welt in diesem Jahr.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name wird bester junger Spieler.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Ihre beobachteten Talente, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain Punkte',
      one: 'ein Punkt',
    );
    return '$name hat sich auf $rating gesteigert, $_temp0 mehr als im Vorjahr.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name rückt in die $band auf.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name feiert sein Debüt';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name hat mit $age sein erstes Länderspiel bestritten, Wertung $rating. Eines der Talente, die Sie beobachten.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Ballbesitz, Spielernoten und der Spieler des Spiels stehen erst mit dem Schlusspfiff fest.';

  @override
  String get matchPlayerRatings => 'SPIELERNOTEN';

  @override
  String get matchSubstitutions => 'WECHSEL';

  @override
  String get matchSubstitutes => 'ERSATZBANK';

  @override
  String get matchPlayerOfTheMatch => 'SPIELER DES SPIELS';

  @override
  String get matchGoalShout => 'TOR!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'ELFMETER $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: VERWANDELT';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: VERSCHOSSEN';
  }

  @override
  String get matchFeedKickOff => 'Anstoß!';

  @override
  String get matchFeedNoEvents => 'Noch keine Ereignisse.';

  @override
  String get tourVenues => 'SPIELORTE';

  @override
  String tourPot(int number) {
    return 'TOPF $number';
  }

  @override
  String get tourHostSelection => 'AUSRICHTERWAHL';

  @override
  String get tourCandidates => 'BEWERBER';

  @override
  String get tourJointBid => 'GEMEINSAME BEWERBUNG';

  @override
  String get tourGoldenGlove => 'GOLDENER HANDSCHUH';

  @override
  String get tourTeamOfTournament => 'ALL-STAR-TEAM';

  @override
  String get tourYourRun => 'IHR WEG';

  @override
  String get tourMedalTable => 'MEDAILLENSPIEGEL';

  @override
  String tourHostLine(String nation) {
    return 'Ausrichter: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Ausrichter: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Gruppe $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Gesetzt nach Weltrangliste. Finden Sie Ihre Nation vor der Auslosung.';

  @override
  String get tourWorldRanking => 'Weltrangliste';

  @override
  String get tourYourCompetitions => 'IHRE WETTBEWERBE';

  @override
  String get tourOtherContinents => 'ANDERE KONTINENTE';

  @override
  String get tourZoneGlobal => 'WELTWEIT';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'SÜDAMERIKA';

  @override
  String get tourZoneNorthAmerica => 'NORDAMERIKA';

  @override
  String get tourZoneAfrica => 'AFRIKA';

  @override
  String get tourZoneAsia => 'ASIEN';

  @override
  String get tourZoneOceania => 'OZEANIEN';

  @override
  String get tourZoneIntercontinental => 'INTERKONTINENTAL';

  @override
  String tourZoneLeague(String league) {
    return 'LIGA $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'AUSRICHTER  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Die besten $count ziehen ein in: $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name tritt zurück';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name ist mit $age Jahren und $caps Länderspielen aus der Nationalmannschaft zurückgetreten. Er wollte wissen, woran er ist, bekam keine Antwort und wartet nun nicht länger.';
  }

  @override
  String get pressHeadlineWent1 => 'Ein Trainer, der den Saal im Griff hat';

  @override
  String get pressHeadlineWent2 =>
      'Sie wollten Streit und bekamen einen Anführer';

  @override
  String get pressHeadlineWent3 => 'Klare Antworten, die sitzen';

  @override
  String get pressHeadlineMixed1 => 'Viel gesagt, wenig geklärt';

  @override
  String get pressHeadlineMixed2 => 'Für jeden etwas, für niemanden genug';

  @override
  String get pressHeadlineMixed3 =>
      'Eine Pressekonferenz, die Fragen offen lässt';

  @override
  String get pressHeadlineBadly1 => 'Ein bitterer Nachmittag vor den Kameras';

  @override
  String get pressHeadlineBadly2 => 'Die Stimmung kippte, und man sah es';

  @override
  String get pressHeadlineBadly3 =>
      'Antworten, die sich morgen noch schlechter lesen';

  @override
  String get pressHeadlineFlat1 => 'Nichts gesagt, nichts gewonnen';

  @override
  String get pressHeadlineFlat2 => 'Zehn Minuten, keine Neuigkeiten';

  @override
  String get pressHeadlineFlat3 => 'Eine leere Seite für den Sportteil';

  @override
  String get pressConferenceTitle => 'PRESSEKONFERENZ';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Frage $index von $total';
  }

  @override
  String get pressTomorrowsHeadline => 'MORGEN IM SPORTTEIL';

  @override
  String get pressLeaveRoom => 'SAAL VERLASSEN';

  @override
  String get pressRoomVerdictSquad => 'Kabine';

  @override
  String get pressRoomVerdictBoard => 'Präsidium';

  @override
  String get yReactionElation0 => 'keine anmerkungen. null. perfekt.';

  @override
  String get yReactionElation1 => 'Mir geht es nicht gut (positiv gemeint).';

  @override
  String get yReactionElation2 => 'wird eingerahmt. kommt übers sofa.';

  @override
  String get yReactionElation3 => 'wir sind sowas von zurück';

  @override
  String get yReactionElation4 => 'Screenshot für die Zweifler. Für alle.';

  @override
  String get yReactionElation5 =>
      'Ich werde damit zehn Jahre lang unerträglich sein.';

  @override
  String get yReactionElation6 => 'Genau. Deshalb schauen wir das.';

  @override
  String get yReactionElation7 => 'Solche Tage entschädigen für alle anderen.';

  @override
  String get yReactionElation8 => 'Wurde auch Zeit. Ehrlich, wurde Zeit.';

  @override
  String get yReactionElation9 =>
      'Schön. Jetzt nächste Woche nochmal, dann glaube ich es.';

  @override
  String get yReactionElation10 =>
      'Genießt den Abend, die finden schon einen Weg, das zu ruinieren.';

  @override
  String get yReactionElation11 =>
      'Ein guter Abend macht noch keine große Mannschaft.';

  @override
  String get yReactionRelief0 => 'Nicht schön, aber das nehme ich jedes Mal.';

  @override
  String get yReactionRelief1 => 'Irgendwie. Irgendwie!';

  @override
  String get yReactionRelief2 => 'Hässlich. Drei Punkte. Weiter.';

  @override
  String get yReactionRelief3 =>
      'Hässlich nehme ich den ganzen Tag, wenn Punkte dabei sind.';

  @override
  String get yReactionRelief4 => 'das hat mich zehn jahre gekostet';

  @override
  String get yReactionRelief5 => 'Keiner sagt was. Keiner verschreit es.';

  @override
  String get yReactionRelief6 => 'Puls: inakzeptabel.';

  @override
  String get yReactionRelief7 => 'Überlebt. Das ist das Wort. Überlebt.';

  @override
  String get yReactionRelief8 =>
      'Bei solchen Spielen sollten wir nicht erleichtert sein müssen.';

  @override
  String get yReactionRelief9 =>
      'Erleichtert, und etwas peinlich berührt, dass ich erleichtert bin.';

  @override
  String get yReactionRelief10 =>
      'Wenn wir so etwas bejubeln, haben wir ein Problem.';

  @override
  String get yReactionRelief11 =>
      'Durchmogeln wird zur Gewohnheit, und zwar zu einer schlechten.';

  @override
  String get yReactionFury0 => 'Nicht gut genug. Nicht annähernd.';

  @override
  String get yReactionFury1 => 'Kann mir das bitte jemand langsam erklären.';

  @override
  String get yReactionFury2 =>
      'Das war schwer anzusehen, und ich bin noch höflich.';

  @override
  String get yReactionFury3 => 'Enttäuscht. Richtig enttäuscht.';

  @override
  String get yReactionFury4 => 'Was für ein Zustand.';

  @override
  String get yReactionFury5 => 'Ich will Namen.';

  @override
  String get yReactionFury6 => 'App gelöscht. Donnerstag wieder installiert.';

  @override
  String get yReactionFury7 =>
      'Keiner da draußen sah aus, als würde er es wollen.';

  @override
  String get yReactionFury8 => 'Alle vier Jahre dasselbe. ALLE vier Jahre.';

  @override
  String get yReactionFury9 =>
      'Das ist keine Leistung, das ist eine Beleidigung.';

  @override
  String get yReactionFury10 =>
      'Leute opfern dafür Wochenenden und Geld. Denkt mal drüber nach.';

  @override
  String get yReactionFury11 =>
      'Ich habe diese Mannschaft jahrelang verteidigt. Heute nicht. Nicht nach dem.';

  @override
  String get yReactionDespair0 => 'tja.';

  @override
  String get yReactionDespair1 => 'Heute keine Witze. Nichts.';

  @override
  String get yReactionDespair2 => 'Ich geh spazieren. Lange.';

  @override
  String get yReactionDespair3 => 'Mir fallen keine Worte mehr dafür ein.';

  @override
  String get yReactionDespair4 => 'Weckt mich in vier Jahren.';

  @override
  String get yReactionDespair5 => 'das ist die dunkelste zeitlinie';

  @override
  String get yReactionDespair6 =>
      'Nicht mal mehr wütend. Das ist das Beunruhigende.';

  @override
  String get yReactionDespair7 => 'Das wird noch lange wehtun.';

  @override
  String get yReactionDespair8 =>
      'Ich weiß nicht mehr, was das ist, aber eine Fußballmannschaft ist es nicht.';

  @override
  String get yReactionDespair9 =>
      'Wir sind weiter weg als früher, und keiner sagt es.';

  @override
  String get yReactionDespair10 =>
      'Eine ganze Generation verschenkt, und dieselben Leute entscheiden, wie es weitergeht.';

  @override
  String get yReactionDespair11 =>
      'Hört auf, mir was von Prozess zu erzählen. Das führt nirgendwohin.';

  @override
  String get yReactionSmugness0 => 'Ganz leise, aber: hab ich doch gesagt.';

  @override
  String get yReactionSmugness1 => 'lesezeichen setzen';

  @override
  String get yReactionSmugness2 => 'Die Zweifler sind sehr still geworden.';

  @override
  String get yReactionSmugness3 => 'Nicht dass jemand mitzählt. Ich zähle mit.';

  @override
  String get yReactionSmugness4 => 'Hab ich im Januar gesagt. Schaut nach.';

  @override
  String get yReactionSmugness5 =>
      'Einige von euch schulden einigen von uns eine Entschuldigung.';

  @override
  String get yReactionSmugness6 => 'Abgelegt unter: hab ich als Erster gesagt.';

  @override
  String get yReactionSmugness7 =>
      'Kein Triumphgeheul. Ein bisschen Triumphgeheul.';

  @override
  String get yReactionSmugness8 =>
      'Wo sind jetzt all die Experten? Ernst gemeinte Frage.';

  @override
  String get yReactionSmugness9 =>
      'Ich möchte, dass jeder Einzelne von euch es mir nachspricht.';

  @override
  String get yReactionSmugness10 =>
      'Screenshot, ausgedruckt, gerahmt, an alle geschickt, die gelacht haben.';

  @override
  String get yReactionSmugness11 =>
      'Das bringe ich für den Rest meines Lebens zur Sprache, und ihr habt es verdient.';

  @override
  String get yReactionShrug0 => 'ist passiert. weiter.';

  @override
  String get yReactionShrug1 => 'Gut. Egal. Weiter.';

  @override
  String get yReactionShrug2 => 'Abgelegt unter \'Fußball\'.';

  @override
  String get yReactionShrug3 => 'Ehrlich, nichts hinzuzufügen.';

  @override
  String get yReactionShrug4 => 'keine gedanken, kopf leer';

  @override
  String get yReactionShrug5 => 'Weckt mich zum nächsten Spiel.';

  @override
  String get yReactionShrug6 => 'Neunzig Minuten, die ich nicht zurückbekomme.';

  @override
  String get yReactionShrug7 => 'Weder Fisch noch Fleisch, ehrlich gesagt.';

  @override
  String get yReactionShrug8 =>
      'Ich könnte nicht eine Sache nennen, die passiert ist.';

  @override
  String get yReactionShrug9 => 'Wieder so eins. Davon gibt es viele.';

  @override
  String get yReactionShrug10 => 'Alles gesehen und rein gar nichts gefühlt.';

  @override
  String get yReactionShrug11 =>
      'Wenn das nie wieder jemand erwähnt, ist mir das recht.';

  @override
  String get tourThirdsUneven =>
      'Die Gruppen sind unterschiedlich groß, daher werden die Ergebnisse gegen den Letzten jeder großen Gruppe gestrichen und jedes Team wird über gleich viele Spiele bewertet.';

  @override
  String get careerExportSave => 'Diesen Spielstand sichern';

  @override
  String get careerBackupAll => 'ALLE SPIELSTÄNDE SICHERN';

  @override
  String get careerBackupAllFailed =>
      'Die Sicherung konnte nicht geschrieben werden.';

  @override
  String get backupTitle => 'BACKUPS';

  @override
  String get backupBlurb =>
      'Alle Spielstände liegen in einer Datei auf diesem Handy, und nichts sichert sie von selbst, solange du unten nicht das automatische Backup einschaltest. Behalte eine Kopie in der Cloud, damit dich ein verlorenes Handy oder eine gelöschte App nicht deine Karriere kostet.';

  @override
  String get backupBlurbNoAuto =>
      'Alle Spielstände liegen in einer Datei auf diesem Handy, und nichts sichert sie von selbst. Behalte eine Kopie in der Cloud, damit dich ein verlorenes Handy oder eine gelöschte App nicht deine Karriere kostet.';

  @override
  String get backupExport => 'IN DER CLOUD SICHERN';

  @override
  String get backupExportSubject => 'FNM-Spielstände';

  @override
  String get backupRestore => 'AUS DATEI WIEDERHERSTELLEN';

  @override
  String get backupRestoreWarnTitle => 'Alle Spielstände ersetzen?';

  @override
  String get backupRestoreWarnBody =>
      'Beim Wiederherstellen werden alle Spielstände auf diesem Handy durch die aus der Datei ersetzt. Die App startet neu.';

  @override
  String get backupRestoreConfirm => 'ERSETZEN';

  @override
  String get backupCancel => 'ABBRECHEN';

  @override
  String get backupExported =>
      'Sicherung bereit. Wählen Sie einen Speicherort.';

  @override
  String get backupFailed => 'Die Sicherung konnte nicht geschrieben werden.';

  @override
  String get backupRejectedUnreadable =>
      'Diese Datei konnte nicht geöffnet werden.';

  @override
  String get backupRejectedNotFnm => 'Das ist kein FNM-Spielstand.';

  @override
  String get backupRejectedNewer =>
      'Dieser Spielstand stammt von einer neueren App-Version. Bitte zuerst aktualisieren.';

  @override
  String get backupRejectedTooOld =>
      'Dieser Spielstand ist zu alt für diese Version.';

  @override
  String get careerShare => 'Diese Karriere teilen';

  @override
  String get careerImport => 'KARRIERE IMPORTIEREN';

  @override
  String get careerShareSubject => 'Eine FNM-Karriere';

  @override
  String get careerImported => 'Karriere importiert.';

  @override
  String get careerImportFailedUnreadable =>
      'Diese Datei ist keine FNM-Karriere.';

  @override
  String get careerImportFailedNewer =>
      'Diese Karriere wurde mit einer neueren App-Version exportiert. Bitte zuerst aktualisieren.';

  @override
  String get careerImportFailedSlotsFull =>
      'Alle Speicherplätze sind belegt. Lösche einen Spielstand oder schalte unbegrenzte Spielstände frei.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Diese Karriere ist schon über den kostenlosen ersten Zyklus hinaus. Schalte das volle Spiel frei, um sie zu importieren.';

  @override
  String get careerImportFailedCampaignRun =>
      'Für diese Kampagne läuft bereits ein Versuch. Setze ihn fort oder brich ihn zuerst ab.';

  @override
  String get careerShareFailed =>
      'Die Karriere konnte nicht exportiert werden.';

  @override
  String get managerRename => 'Name ändern';

  @override
  String get managerRenameSave => 'Speichern';

  @override
  String get managerTitle => 'TRAINER';

  @override
  String get managerSkills => 'IHRE FÄHIGKEITEN';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Punkte zu vergeben',
      one: '1 Punkt zu vergeben',
      zero: 'Keine Punkte zu vergeben',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Zwei Punkte für jeden abgeschlossenen Zyklus, einer für jeden gewonnenen Titel.';

  @override
  String get managerSkillsScale =>
      'Jede Fähigkeit beginnt bei 5 und endet bei 20. Ein vergebener Punkt ist dauerhaft.';

  @override
  String get managerSkillManManagement => 'Menschenführung';

  @override
  String get managerSkillManManagementBlurb =>
      'Jeder Punkt lässt Ihre Worte an Presse und Spieler in der Kabine um 3 % stärker wirken.';

  @override
  String get managerSkillTactical => 'Taktik';

  @override
  String get managerSkillTacticalBlurb =>
      'Jeder Punkt lässt eine neue Formation 3 % schneller sitzen, ein Systemwechsel kostet also weniger Spiele.';

  @override
  String get managerSkillYouth => 'Nachwuchsförderung';

  @override
  String get managerSkillYouthBlurb =>
      'Jeder Punkt steigert das Talent aus Ihrer Akademie um 1 %, zusätzlich zu Ihrer Finanzierung.';

  @override
  String get managerSkillNegotiation => 'Verhandlung';

  @override
  String get managerSkillNegotiationBlurb =>
      'Jeder Punkt bringt 2 % mehr Geld vom Verband, in jedem Zyklus.';

  @override
  String get managerStaff => 'IHR STAB';

  @override
  String managerStaffWages(String amount) {
    return 'Gehälter: $amount pro Zyklus';
  }

  @override
  String get managerRoleAssistant => 'Co-Trainer';

  @override
  String get managerRoleAssistantBlurb =>
      'Leitet das Training: weniger Verletzungen und besserer Nachwuchs.';

  @override
  String get managerRoleScout => 'Chefscout';

  @override
  String get managerRoleScoutBlurb =>
      'Beurteilt Ihre Talente und den nächsten Gegner: genauere Sternebewertungen und ein Vorteil am Spieltag.';

  @override
  String get managerRoleFitness => 'Fitnesstrainer';

  @override
  String get managerRoleFitnessBlurb => 'Hält sie auf dem Platz.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent % weniger Verletzungen';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Nachwuchs +$points Gesamtstärke';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Bei Einstellung: $min % bis $max % weniger Verletzungen';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'und Nachwuchs +$minPoints bis +$maxPoints Gesamtstärke';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Bewertet $percent % der Talente exakt';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potenzial nach $caps Länderspielen bekannt',
      one: 'Potenzial nach 1 Länderspiel bekannt',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points Stärke durch Gegnerdossiers';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Bei Einstellung: $min % bis $max % exakte Bewertungen';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'und Potenzial $minCaps bis $maxCaps Länderspiele früher bekannt';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'und +$minPoints bis +$maxPoints Stärke in jedem Spiel';
  }

  @override
  String get staffEffectNone => 'Noch keine Wirkung auf Ihren Kader';

  @override
  String get staffVacant => 'Stelle unbesetzt';

  @override
  String get staffLeaveVacant => 'Stelle unbesetzt lassen';

  @override
  String get managerTierNone => 'Keiner';

  @override
  String get managerTierBasic => 'Einfach';

  @override
  String get managerTierGood => 'Gut';

  @override
  String get managerTierElite => 'Elite';

  @override
  String get managerFree => 'kostenlos';

  @override
  String get managerTraining => 'ZWISCHEN DEN LEHRGÄNGEN';

  @override
  String get managerTrainingBlurb =>
      'Woran der Kader arbeitet, wenn kein Spiel ansteht.';

  @override
  String get managerFocusBalanced => 'Ausgewogen';

  @override
  String get managerFocusBalancedBlurb => 'Von allem etwas.';

  @override
  String get managerFocusFitness => 'Fitness';

  @override
  String get managerFocusFitnessBlurb => 'Weniger Blessuren.';

  @override
  String get managerFocusCohesion => 'Eingespieltheit';

  @override
  String get managerFocusCohesionBlurb => 'Das System sitzt schneller.';

  @override
  String get managerFocusYouth => 'Nachwuchs';

  @override
  String get managerFocusYouthBlurb =>
      'Stunden mit den Jüngsten im Spielerpool.';

  @override
  String get tourOfferTitle => 'Zum ersten Mal hier?';

  @override
  String get tourOfferBody =>
      'Das ist ein großes Spiel. Möchten Sie einen kurzen Rundgang durch die wichtigsten Bildschirme? Er dauert eine Minute und lässt sich jederzeit in den Einstellungen neu starten.';

  @override
  String get tourOfferYes => 'Zeig es mir';

  @override
  String get tourOfferNo => 'Nein danke';

  @override
  String get tourBack => 'Zurück';

  @override
  String get tourNext => 'Weiter';

  @override
  String get tourDone => 'Fertig';

  @override
  String get tourSkip => 'Überspringen';

  @override
  String get tourHubTitle => 'Das ist das ganze Spiel';

  @override
  String get tourHubBody =>
      'Ein Knopf, der sich im Laufe des Zyklus ändert: eine Auslosung zum Zuschauen, ein Kader zum Nominieren, ein Spiel zum Spielen. Darüber stehen das Vertrauen des Präsidiums und die gesetzten Ziele.';

  @override
  String get tourBudgetTitle => 'Das Geld des Verbands';

  @override
  String get tourBudgetBody =>
      'Einmal pro Vierjahreszyklus verteilen Sie die Kasse auf die Abteilungen. Zuerst wird Ihr Stab bezahlt, ein Elite-Scout ist also eine Entscheidung gegen die Akademie, nicht zusätzlich zu ihr.';

  @override
  String get tourTacticsTitle => 'Wie die Mannschaft spielt';

  @override
  String get tourTacticsBody =>
      'Ihr System, Ihre Spielweise, Ihr Kapitän und wer die Standards schießt. Bleiben die letzten beiden offen, warnt Sie das Spiel vor dem Anpfiff, statt still für Sie zu wählen.';

  @override
  String get tourSquadTitle => 'Alle, die Sie nominieren können';

  @override
  String get tourSquadBody =>
      'Der ganze Spielerpool, nicht nur der Kader: wer in Form ist, wer angeschlagen ist, wer gesperrt ist und wer gerade aus der Akademie kommt.';

  @override
  String get tourCallUpsTitle => 'Einen Kader nominieren';

  @override
  String get tourCallUpsBody =>
      'Sie nominieren einen Kader pro Länderspielfenster, und er bestreitet alle Spiele dieses Fensters, genau wie bei einem echten Nationaltrainer. Verletzt sich jemand im Fenster, wird für Sie nachnominiert.';

  @override
  String get tourRecordsTitle => 'Ihre Karriere';

  @override
  String get tourRecordsBody =>
      'Alles, was Sie erreicht haben: die Spiele, die Mannschaftsrekorde, die Titel und jede Nation, die Sie trainiert haben.';

  @override
  String get tourCupsTitle => 'Der Rest der Welt';

  @override
  String get tourCupsBody =>
      'Jeder laufende Wettbewerb: Gruppen, Tabellen und K.-o.-Runden, auch die ohne Sie. Die Welt spielt weiter, ob Sie sich qualifiziert haben oder nicht.';

  @override
  String get settingsTourTitle => 'Tutorial wiederholen';

  @override
  String get settingsTourBlurb =>
      'Die wichtigsten Bildschirme noch einmal von vorn durchgehen.';

  @override
  String get tourBoardTitle => 'Wem Sie Rechenschaft schulden';

  @override
  String get tourBoardBody =>
      'Das Vertrauen des Präsidiums in Sie und die Ziele für diesen Zyklus. Verfehlen Sie die Vorgaben, sehen Sie es hier kommen.';

  @override
  String get tourStaffTitle => 'Die Leute um Sie herum';

  @override
  String get tourStaffBody =>
      'Ein Co-Trainer, ein Scout und ein Fitnesstrainer, namentlich eingestellt. Ihre Gehälter gehen vor den Abteilungen von diesem Budget ab, ein großartiger Scout ist also eine Entscheidung gegen die Akademie.';

  @override
  String get tourPlaystyleTitle => 'Ihre Spielweise';

  @override
  String get tourPlaystyleBody =>
      'Das System ist nur die halbe Taktik. Das hier ist die andere Hälfte: wie hoch Sie pressen, wie direkt Sie spielen, wie viel Sie riskieren.';

  @override
  String get settingsTourNoSave =>
      'Starten Sie zuerst eine Karriere. Der Rundgang führt durch Ihre eigenen Bildschirme.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Fremde Position · Alter $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Das Budget des nächsten Zyklus wird zu dessen Beginn auf einmal festgelegt. Bis dahin sehen Sie hier, was Ihr Geld gerade bewirkt.';

  @override
  String get federationBudgetAlreadySet =>
      'Für diesen Zyklus bereits festgelegt';

  @override
  String yFinalLooms0(String opponent) {
    return 'Im großen Spiel geht es gegen $opponent. Die ganze Woche wird über nichts anderes geredet.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Bestätigt: Nur noch $opponent steht zwischen uns und dem Ding. Vier Jahre für diesen Moment.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Also. $opponent. Keiner schläft, bis das vorbei ist.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Als Nächstes $opponent, alles andere kann warten. Was für eine Woche.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Schützen dem Trainerteam überlassen';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Unten markiert: Teams, die spielen wie $rivals, Ihre Gruppengegner in diesem Zyklus.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Transferfenster · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Zuletzt vor $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Ein kostenloser Vierjahreszyklus';

  @override
  String get settingsFreeScopeBlurb =>
      'Ein kompletter Zyklus (Qualifikation, Ihre Kontinentalmeisterschaft und die Weltmeisterschaft) mit zwei Spielständen, jede Nation der Welt, nichts zurückgehalten. Endlose Zyklen und unbegrenzte Spielstände kosten eine einmalige Zahlung, die alle künftigen Updates abdeckt.';

  @override
  String get settingsUnlockedTitle => 'Freigeschaltet';

  @override
  String get settingsUnlockedBlurb =>
      'Endlose Zyklen, unbegrenzte Spielstände und alle künftigen Updates. Vielen Dank.';

  @override
  String get settingsFromDeveloperTitle => 'Vom Entwickler';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager wird von einer einzigen Person entwickelt und langfristig weiter betreut. Es wird nie Werbung oder Mikrotransaktionen geben. Wenn Ihnen das Spiel gefällt, ziehen Sie bitte den Kauf der Vollversion in Betracht. Sie macht die weiteren Updates möglich.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager wird von einer einzigen Person entwickelt und langfristig weiter betreut. Es wird nie Werbung oder Mikrotransaktionen geben. Danke, dass Sie die Vollversion gekauft haben. Sie macht die weiteren Updates möglich.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Unten markiert: Teams, die spielen wie $rivals, gegen die Sie noch antreten müssen.';
  }

  @override
  String get friendliesCloseToYou =>
      'Unten markiert: die Teams, die Ihnen in der Weltrangliste am nächsten sind. Nach der Auslosung richten sich die Markierungen nach Ihrer Gruppe.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wechsel',
      one: '1 Wechsel',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Neuer';

  @override
  String get transfersOlder => 'Mehr';

  @override
  String get transfersPagePrevious => 'Zurück';

  @override
  String get transfersPageNext => 'Weiter';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Seite $page von $pages';
  }

  @override
  String get transfersMovedTo => 'Wechselt zu';

  @override
  String get transfersUnknownClub => 'Unbekannter Verein';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Das ist jetzt das $count. Mal gegen $opponent. Jemand führt Buch, und zwar die.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Schon wieder $opponent. $count Duelle, und wir haben sie immer noch nicht durchschaut.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Nummer $count gegen $opponent. Das ist kein Zufall mehr.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Wir haben $count Mal gegen $opponent gespielt und aus keinem Spiel was gelernt.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count Mal. Die wissen genau, was wir vorhaben.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Was auch immer $opponent gegen uns in der Hand hat, nach $count Duellen haben sie es immer noch.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Das ist jetzt das $count. Mal in letzter Zeit. Ab wann ist das einfach, wer wir sind?';
  }

  @override
  String ySameOldStory1(String count) {
    return 'Schon $count solche Nachmittage. Das ist ein Muster, keine Pechsträhne.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Genau dieses Spiel haben wir zuletzt $count Mal gesehen. Gleiches Drehbuch, gleiches Ende.';
  }

  @override
  String ySameOldStory3(String count) {
    return 'Die $count. Fassung derselben neunzig Minuten. Keiner repariert es.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count Mal. Wer das Muster jetzt nicht sieht, schaut nicht hin.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Dieselbe Geschichte, $count Mal. Die Ausreden sind schneller ausgegangen als die Niederlagen.';
  }

  @override
  String get yToldYouSo0 =>
      'Ich hab gesagt, dass das kommt, während alle am Feiern waren.';

  @override
  String get yToldYouSo1 =>
      'Zwei gute Wochen und wir waren wieder eine goldene Generation. Und jetzt das.';

  @override
  String get yToldYouSo2 =>
      'Die Leute, die mir letzten Monat gesagt haben, ich soll es genießen, sind still geworden.';

  @override
  String get yToldYouSo3 =>
      'Das bereitet mir keine Freude. Sehr wenig Freude. Ein bisschen.';

  @override
  String get yToldYouSo4 =>
      'Es war nie so gut, wie man euch erzählt hat, und das ist der Beweis.';

  @override
  String get yToldYouSo5 =>
      'Jedes Mal. Es heißt, diesmal ist alles anders, und jedes Mal ist es das nicht.';

  @override
  String get tacticsSubOffAlready => 'Bereits raus';

  @override
  String get tacticsSubInjured => 'Verletzt';

  @override
  String get tacticsSubSentOffMark => 'Vom Platz gestellt';

  @override
  String get tacticsSubNoneLeft => 'Keine Wechsel mehr';

  @override
  String get tacticsUndoLastChange => 'Letzten Wechsel zurücknehmen';

  @override
  String get matchStrengthTitle => 'WAS DIE MANNSCHAFT BEWEGT';

  @override
  String get strengthFactorFamiliarity => 'Eingespieltes System';

  @override
  String get strengthFactorFatigue => 'Müde Beine';

  @override
  String get strengthFactorClubForm => 'Vereinsform';

  @override
  String get strengthFactorMorale => 'Kabine';

  @override
  String get strengthFactorCaptain => 'Kapitän';

  @override
  String get strengthFactorStaff => 'Trainerstab';

  @override
  String get strengthFactorDossier => 'Scout-Dossier';

  @override
  String yDebut0(String name) {
    return '$name feiert sein Debüt. Merkt euch den Namen.';
  }

  @override
  String yDebut1(String name) {
    return 'Debüt für $name. Man sieht es ihm an, oder?';
  }

  @override
  String yDebut2(String name) {
    return '$name, erstes Länderspiel. Mal sehen, was er daraus macht.';
  }

  @override
  String yDebut3(String name) {
    return 'Debüt für $name. Der Kader brauchte irgendwo frische Beine.';
  }

  @override
  String yDebut4(String name) {
    return '$name bekommt ein Länderspiel. Davon haben wir in letzter Zeit viele verteilt.';
  }

  @override
  String yDebut5(String name) {
    return 'Debüt für $name. Noch einer, den wir bis zum Frühling vergessen haben.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name ist seit $count Spielen ohne Tor und macht auf dem Platz alles andere.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count Spiele ohne Tor für $name. Die kommen wieder im Dreierpack, war schon immer so.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count Spiele, keine Tore.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count Spiele ohne Tor für $name. Sollte man im Auge behalten.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count Spiele. Keine Tore. $name trifft nicht mal ein Scheunentor.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name hat seit $count Spielen nicht getroffen. Stellt buchstäblich irgendwen anders auf.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Als Nächstes $opponent. $count Duelle und es bedeutet immer noch alles.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'Schon $count Mal gegen $opponent. Her damit.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Als Nächstes $opponent. $count Mal gespielt.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Duell Nummer $count mit $opponent diese Woche.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Schon wieder $opponent. $count davon und nichts gelernt.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count Spiele gegen $opponent und sie schlagen uns immer noch. Wunderbar.';
  }

  @override
  String get positionGoalkeeper => 'Torwart';

  @override
  String get positionLeftBack => 'Linker Verteidiger';

  @override
  String get positionCentreBack => 'Innenverteidiger';

  @override
  String get positionRightBack => 'Rechter Verteidiger';

  @override
  String get positionDefensiveMid => 'Defensives Mittelfeld';

  @override
  String get positionCentralMid => 'Zentrales Mittelfeld';

  @override
  String get positionAttackingMid => 'Offensives Mittelfeld';

  @override
  String get positionLeftMid => 'Linkes Mittelfeld';

  @override
  String get positionRightMid => 'Rechtes Mittelfeld';

  @override
  String get positionLeftWing => 'Linksaußen';

  @override
  String get positionRightWing => 'Rechtsaußen';

  @override
  String get positionStriker => 'Stürmer';

  @override
  String get roleNone => 'Keine Rolle';

  @override
  String get roleTargetMan => 'Zielspieler';

  @override
  String get rolePoacher => 'Strafraumstürmer';

  @override
  String get rolePlaymaker => 'Spielmacher';

  @override
  String get roleBallWinner => 'Balleroberer';

  @override
  String get roleInvertedWinger => 'Inverser Flügel';

  @override
  String get roleBallPlayingDefender => 'Spielstarker Verteidiger';

  @override
  String get roleNoneBlurb => 'Spielt sein natürliches Spiel.';

  @override
  String get roleTargetManBlurb =>
      'Gewinnt Kopfbälle, legt ab. Vorlagen und Standards.';

  @override
  String get rolePoacherBlurb => 'Lauert im Strafraum. Deutlich mehr Tore.';

  @override
  String get rolePlaymakerBlurb => 'Kreiert Chancen. Viel mehr Vorlagen.';

  @override
  String get roleBallWinnerBlurb =>
      'Zerstört das Spiel, statt es abzuschließen.';

  @override
  String get roleInvertedWingerBlurb =>
      'Zieht nach innen zum Abschluss. Mehr Tore.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Baut das Spiel von hinten auf.';

  @override
  String get federationDeptYouth => 'Nachwuchsakademie';

  @override
  String get federationDeptCommercial => 'Vermarktung / PR';

  @override
  String get federationDeptMedical => 'Medizin & Sportwissenschaft';

  @override
  String get federationDeptNaturalisation => 'Einbürgerungsbüro';

  @override
  String get federationDeptBoardRelations => 'Präsidiumsbeziehungen';

  @override
  String get federationDeptYouthBlurb =>
      'Bessere Akademietalente debütieren im nächsten Zyklus für Ihre Nation.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsoring bringt am Ende des Zyklus zusätzliche Einnahmen.';

  @override
  String get federationDeptMedicalBlurb =>
      'Weniger Verletzungen. Ihr Kader bleibt den ganzen Zyklus verfügbar.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Mehr ausländische Spieler bieten an, für Ihre Nation zu spielen.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Das Präsidium beurteilt Ihre Ergebnisse geduldiger.';

  @override
  String get federationBuildingAcademy => 'Akademie';

  @override
  String get federationBuildingCommercial => 'Marketingzentrale';

  @override
  String get federationBuildingMedical => 'Medizinzentrum';

  @override
  String get federationBuildingScouting => 'Scoutingbüro';

  @override
  String get federationBuildingBoardroom => 'Sitzungssaal';

  @override
  String get moraleBuoyant => 'Euphorisch';

  @override
  String get moralePositive => 'Positiv';

  @override
  String get moraleSettled => 'Stabil';

  @override
  String get moraleUneasy => 'Unruhig';

  @override
  String get moraleRockBottom => 'Am Boden';

  @override
  String get matchTabTimeline => 'VERLAUF';

  @override
  String get matchTabStats => 'STATISTIK';

  @override
  String get matchTabLineups => 'AUFSTELLUNG';

  @override
  String get matchPenalty => 'ELFMETER';

  @override
  String get matchStateLevel => 'Alles ausgeglichen';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sie führen mit $count Toren',
      one: 'Sie führen mit einem Tor',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sie liegen mit $count Toren zurück',
      one: 'Sie liegen mit einem Tor zurück',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession % Ballbesitz';
  }

  @override
  String get boardVerdictSackedTitle => 'Das Präsidium hat Sie entlassen';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Ein desaströser Zyklus (Bewertung $rating %). Ihre Amtszeit endet hier. Nur kleinere Nationen werden es jetzt noch mit Ihnen versuchen.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Das Präsidium ist begeistert';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Ein herausragender Zyklus (Bewertung $rating %) nach $best. Größere Nationen sind interessiert, oder Sie bleiben und bauen weiter auf.';
  }

  @override
  String get boardVerdictSolidTitle => 'Ein solider Zyklus';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Das Präsidium ist zufrieden (Bewertung $rating %). Einige Nationen ähnlichen Kalibers würden Sie nehmen, aber es gibt keinen Druck zu wechseln.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Das Präsidium hat mehr erwartet';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Ein enttäuschender Zyklus (Bewertung $rating %). Sie behalten Ihren Job, aber Angebote wären ein Rückschritt.';
  }

  @override
  String get boardVerdictPressureTitle => 'Sie stehen unter echtem Druck';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Ein schwacher Zyklus (Bewertung $rating %). Sie überstehen ihn, aber für einen Neuanfang interessieren sich nur schwächere Nationen.';
  }

  @override
  String get boardVerdictHeroTitle => 'Die Nation steht hinter Ihnen';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles Zyklen',
      one: '1 Zyklus',
    );
    return ' $nation liebt Sie, ein Nationalheld nach $_temp0; Ihr Job ist sicher, solange Sie ihn wollen.';
  }

  @override
  String get boardVerdictTheNation => 'Die Nation';

  @override
  String get boardVerdictBestQuiet => 'einem ruhigen Zyklus';

  @override
  String get boardVerdictBestCycle => 'dem Zyklus';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'der Weltmeisterschaft: $placement';
  }

  @override
  String get finishThirdPlace => 'Dritter Platz';

  @override
  String get finishFourthPlace => 'Vierter Platz';

  @override
  String get finishDidNotQualify => 'Nicht qualifiziert';

  @override
  String get careerRepIconic => 'Legendär';

  @override
  String get careerRepRenowned => 'Renommiert';

  @override
  String get careerRepEstablished => 'Etabliert';

  @override
  String get careerRepRising => 'Aufstrebend';

  @override
  String get careerRepUnproven => 'Unerprobt';

  @override
  String get hubOfferStepUp => 'Aufstieg';

  @override
  String get hubOfferLateral => 'Gleichwertig';

  @override
  String get hubOfferRebuild => 'Neuaufbau';

  @override
  String careerNationsCupWon(String league) {
    return 'Liga $league · Sieger';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Liga $league · Finalist';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Liga $league · Halbfinalist';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Liga $league · Platz $position';
  }

  @override
  String tourRunInto(String round) {
    return 'Steht im $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Steht im Spiel um Platz drei';

  @override
  String tourRunThrough(String round) {
    return 'Im $round weitergekommen';
  }

  @override
  String tourRunOut(String round) {
    return 'Ausgeschieden im $round';
  }

  @override
  String get tourRunInGroup => 'In der Gruppenphase';

  @override
  String get tourRunGroupOut => 'In der Gruppenphase ausgeschieden';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Zyklus $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played Spiele  ·  ${won}S ${drawn}U ${lost}N';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Weltmeisterschaft: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Läuft noch';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Zur Pause 0:2 gegen $opponent und sie haben alles zurückgeholt. Das ist eine Mannschaft.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Zwei Tore hinten gegen $opponent, und am Ende war es egal. Das schaffen nicht viele.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Halbzeit: zwei Tore hinten gegen $opponent. Abpfiff: nicht mehr. Die zweite Hälfte war ein anderes Spiel.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Nach 0:2 gegen $opponent zurückgekommen. Was auch immer in der Pause gesagt wurde, sagt es jede Woche.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Gut, wir haben es gegen $opponent zurückgeholt. Jetzt erklärt mir bitte jemand die ersten 45 Minuten.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Zwei Tore hinten gegen $opponent und wir sollen begeistert sein. Repariert die erste Halbzeit.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Zur Pause 2:0 gegen $opponent und dann entglitten. Passiert auch besseren Teams.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Zwei Tore vor gegen $opponent und es ist uns entwischt. Langer Zyklus, noch viel Zeit.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Halbzeit: zwei Tore vorn gegen $opponent. Abpfiff: nichts dergleichen.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Eine 2:0-Führung gegen $opponent, verspielt in 45 Minuten.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return '2:0 vorn und verloren. Gegen $opponent. Dafür muss jemand geradestehen.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Zwei Tore vorn gegen $opponent und wir schaffen das hier. Jedes einzelne Mal.';
  }

  @override
  String get cycleBackupDone =>
      'Karriere im FNM-Ordner auf diesem Handy gesichert. Beim Deinstallieren der App wird sie gelöscht: Für eine Kopie an anderer Stelle nutzen Sie \"Diesen Spielstand sichern\" in der Spielstandsliste.';

  @override
  String get cycleBackupFailed =>
      'Die Karriere konnte diesmal nicht gesichert werden.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Ein unvergesslicher Abend gegen $opponent. Wie stolz sind Sie auf diese Mannschaft?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent kam mit Ihnen nicht klar. Ist das die Mannschaft, an die Sie immer geglaubt haben?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Ein großer Sieg gegen $opponent. Was hat heute den Unterschied gemacht?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent geschlagen, und zwar deutlich. Wo haben Sie das Spiel gewonnen?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Ein guter Sieg gegen $opponent. Ein guter Abend: Warum sollte irgendwer glauben, dass das anhält?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Ein schönes Ergebnis gegen $opponent. War das Ihr Plan, oder haben es sich die Spieler selbst erarbeitet?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Ein schwerer Abend gegen $opponent. Was sagen Sie den Spielern nach so einem Spiel?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Das hat gegen $opponent niemand kommen sehen. War es einfach einer dieser Abende?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Das war ein ernüchternder Abend gegen $opponent. Was ist schiefgelaufen?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent hat Sie auseinandergenommen. Ist dieser Kader gut genug?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Sie waren gegen $opponent überall einen Schritt zu spät. Wie konnte es so weit kommen?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent traf nach Belieben. Wo war heute der Plan?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Wieder eins verloren, diesmal gegen $opponent. Wie drehen Sie diese Serie?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Die Ergebnisse bleiben aus, und $opponent hat es noch schlimmer gemacht. Glauben Sie noch an diese Mannschaft?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Wieder kein Sieg, jetzt gegen $opponent, und das Präsidium schaut genau hin. Ist Ihr Job sicher?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Nach $opponent wird die Serie lang. Machen Sie sich Sorgen um Ihre Zukunft?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Jetzt auch noch $opponent. Ihr Vorgänger wurde nach so einer Serie entlassen. Warum sollten Sie sie überstehen?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Nach einem weiteren Abend wie gegen $opponent fordert jede Fan-Hotline Ihre Ablösung. Würden Sie zurücktreten, wenn das Präsidium Sie darum bittet?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Sie haben Ihren Job aufs Spiel gesetzt, und nach $opponent ist es nicht für Sie gelaufen. Wie geht es Ihnen?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Die drei Spiele sind vorbei, das letzte gegen $opponent. Sie haben sich die Prüfung selbst gestellt. Was halten Sie vom Urteil?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Sie sagten, wir sollen Sie an den nächsten drei Spielen messen. Nach $opponent haben wir das getan. Ist Ihr Job noch Ihrer?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Drei Spiele, das letzte gegen $opponent, und nicht das, was Sie versprochen haben. Haben Sie mit dem Präsidium über Ihre Zukunft gesprochen?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Sie haben sich die Prüfung selbst gestellt und sind gegen $opponent durchgefallen. Treten Sie zurück?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Ihre Worte, nicht unsere: Messen Sie mich an den nächsten drei. Nach $opponent: Warum sitzen Sie noch hier?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Sie wollen mehr von ihnen. Jemand Bestimmtes?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Sie haben die Messlatte hoch gelegt. Wer muss als Erster liefern?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Sie sagen, einige müssten sich hinterfragen. Wen meinen Sie?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Nicht gut genug, sagen Sie. Von wem sprechen Sie?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Sie bleiben vage. Nennen Sie Namen, oder liegt es am Ende an Ihnen?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Jede Woche ist jemand anderes schuld. Wer ist es diesmal?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Mutige Worte. Und wenn das nächste Spiel nicht nach Plan läuft?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Das Land wird Sie beim Wort nehmen. Was, wenn es nicht klappt?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'Und wenn Sie nicht gewinnen? Was dann?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Jetzt haben Sie es gesagt. Was passiert, wenn Sie falschliegen?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Wir haben in diesem Raum schon Versprechen gehört. Was schulden Sie den Fans, wenn auch dieses gebrochen wird?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Und wenn es nicht klappt, wie lautet dann die Ausrede?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Noch eine, wenn Sie mögen. Woran muss diese Mannschaft noch arbeiten?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Wenn sich der Staub gelegt hat: Was nehmen Sie von heute ins nächste Spiel mit?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Gehen wir etwas tiefer. Was muss sich vor dem nächsten Spiel verbessern?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Abseits des Ergebnisses: Ist dieser Kader da, wo Sie ihn haben wollen?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Viele Worte, wenig gesagt. Was ändert sich jetzt konkret?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Die Fans wollen eine klare Antwort. Ist diese Mannschaft gut genug, ja oder nein?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player war heute überragend. Wie weit kann er es bringen?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player ist heute in allen Schlagzeilen. Haben Sie das kommen sehen?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player stach heraus. Was haben Sie heute von ihm verlangt?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'War $player heute der Unterschied?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Ohne $player sieht das ganz anders aus. Ist das eine Mannschaft oder ein einzelner Spieler?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player war brillant. Ihr Verdienst oder seiner?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player hatte einen schweren Abend. Ist er angeschlagen?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player hatte nicht seinen Tag. Werden Sie ihn in den Arm nehmen?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player hatte heute Probleme. Behält er seinen Platz?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player wirkte nicht auf der Höhe. Was halten Sie von seinem Spiel?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player lief wieder nur mit. Warum stellen Sie ihn immer wieder auf?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Jeder sah, dass $player nicht bei der Sache war. Jeder außer der Bank?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Sie sagten, Sie würden das nächste Spiel gewinnen, und das haben Sie. Tut es gut, recht zu behalten?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Sie haben einen Sieg im nächsten Spiel versprochen und geliefert. Selbstvertrauen oder Großspurigkeit?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Sie sagten, Sie gewinnen das nächste Spiel, und das haben Sie. Glück, oder sollen wir jetzt anfangen zuzuhören?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Sie sagten uns, Sie würden dieses Spiel gewinnen. Es kam anders. Was ist schiefgelaufen?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Sie sagten, Sie gewinnen das nächste Spiel. Haben Sie nicht. Warum sollten wir dem nächsten Versprechen glauben?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Sie sagten, Sie gewinnen das nächste Spiel. Haben Sie nicht. Haben Ihre Worte in diesem Raum noch Gewicht?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Sie wollten an drei Spielen gemessen werden und haben bestanden. Fühlen Sie sich bestätigt?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Messen Sie mich an den nächsten drei, sagten Sie. Das haben wir, und die Ergebnisse kamen. Was hat Sie diese Prüfung gelehrt?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Sie haben sich drei Spiele gegeben und sie überstanden. War die Prüfung je wirklich schwer?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Sie wollten an drei Spielen gemessen werden. Sie liefen nicht für Sie. Was haben Sie gelernt?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Messen Sie mich an den nächsten drei, sagten Sie. Die drei sind vorbei, und der Vertrauensvorschuss auch. Was nun?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Sie haben sich die Prüfung gestellt und sind durchgefallen. Warum sollte Ihnen jetzt noch jemand glauben?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Sie haben $player unterstützt, als andere es nicht taten. Er hat geliefert. Ein Teil des Verdienstes Ihrer?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Sie haben auf $player gesetzt. Er hat geliefert. Glaube oder Wissen?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Sie haben auf $player gesetzt, und ausnahmsweise hat es sich ausgezahlt. Werden Sie beim nächsten Mal genauso sicher sein?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Sie haben zu $player gehalten, und es hat nicht funktioniert. Glauben Sie noch an ihn?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Sie haben auf $player gesetzt. Er hat es nicht zurückgezahlt. War das ein Fehler?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Ihr Urteilsvermögen oder Ihre Loyalität: Was hat bei $player versagt?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Sie waren hart zu $player, und die Spiele seither geben Ihnen recht. Verspüren Sie Genugtuung?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Sie haben $player öffentlich kritisiert, und er hat keine Antwort gefunden. Gibt es für ihn einen Weg zurück?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Sie haben $player im Regen stehen lassen, und er hat sich nicht erholt. Haben Sie ihn gebrochen?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Sie haben $player öffentlich kritisiert, und er hat Ihnen auf dem Platz geantwortet. War das von Anfang an die Idee?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Sie haben $player die Schuld gegeben, und seitdem ist er einer Ihrer Besten. Schulden Sie ihm eine Entschuldigung?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Sie haben $player unter den Bus geworfen, und seitdem ist er Ihr bester Spieler. Werden Sie sich entschuldigen?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Diese Spieler haben mir alles gegeben. Ich würde keinen einzigen eintauschen.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Niemand arbeitet härter als diese Mannschaft. Ich verteidige sie den ganzen Tag.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Von diesem Platz aus hören Sie kein schlechtes Wort über meine Spieler.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Die Spieler verdienen das Lob, nicht ich. Schreiben Sie über sie.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Das geht auf meine Kappe. Ich habe die Elf aufgestellt und eingestellt.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Urteilen Sie über mich, nicht über sie. Es ist meine Mannschaft und meine Verantwortung.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Wenn Sie einen Schuldigen suchen: Ich sitze direkt hier.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Die Verantwortung liegt bei mir. Lassen Sie die Spieler da raus.';

  @override
  String get pressReplyDemandMore1 =>
      'Ich will mehr. Einige wissen genau, was ich meine.';

  @override
  String get pressReplyDemandMore2 =>
      'Einsatz reicht auf diesem Niveau nicht. Ich will mehr, und das habe ich ihnen gesagt.';

  @override
  String get pressReplyDemandMore3 =>
      'Ich erwarte mehr von jedem Einzelnen, ab morgen.';

  @override
  String get pressReplyDemandMore4 =>
      'Einige müssen sich hinterfragen. Ich bin nicht zufrieden.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Wir gewinnen das nächste Spiel. Das können Sie aufschreiben.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Merken Sie sich meine Worte: Wir gewinnen das nächste Spiel.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Nächstes Spiel, wir gewinnen. Ich sage es hier, damit Sie mich daran messen können.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Ich bin mir dieser Mannschaft sicher. Wir gewinnen das nächste Spiel.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Messen Sie mich an den nächsten drei Spielen. Das ist fair.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Geben Sie mir drei Spiele. Wenn es dann nicht stimmt, urteilen Sie über mich.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Die nächsten drei zeigen, ob ich der Richtige bin. Nehmen Sie mich beim Wort.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Drei Spiele. Danach schreiben Sie über mich, was Sie wollen.';

  @override
  String get pressReplyDeflect1 =>
      'Wir denken von Spiel zu Spiel. Mehr gibt es nicht zu sagen.';

  @override
  String get pressReplyDeflect2 =>
      'Ich liefere Ihnen heute keine Schlagzeilen.';

  @override
  String get pressReplyDeflect3 => 'Nächstes Spiel. Nur daran denke ich.';

  @override
  String get pressReplyDeflect4 => 'Was ich denke, bleibt in der Kabine.';

  @override
  String get pressReplyTakeCredit1 =>
      'Ich habe es gesagt, weil ich daran geglaubt habe, und ich lag richtig.';

  @override
  String get pressReplyTakeCredit2 =>
      'Ich habe es richtig eingeschätzt. Dafür bin ich da.';

  @override
  String get pressReplyTakeCredit3 =>
      'Nennen Sie es Urteilsvermögen. Ich wusste, was ich sage.';

  @override
  String get pressReplyTakeCredit4 =>
      'Ich habe die Entscheidung getroffen, und sie ist aufgegangen. Das nehme ich gern.';

  @override
  String get pressReplyStandByIt1 =>
      'Ich habe gesagt, was ich glaubte. Dazu stehe ich.';

  @override
  String get pressReplyStandByIt2 => 'Ich nehme kein Wort davon zurück.';

  @override
  String get pressReplyStandByIt3 =>
      'Dieselbe Antwort wie damals. Ich habe es so gemeint, und tue es noch.';

  @override
  String get pressReplyStandByIt4 => 'Ich würde es morgen wieder sagen.';

  @override
  String get pressReplyAdmitMistake1 => 'Da lag ich falsch. Dazu stehe ich.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Gut, ich habe mich verschätzt. Daraus lerne ich.';

  @override
  String get pressReplyAdmitMistake3 =>
      'Ich lag falsch, und das kann ich auch sagen.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Die Entscheidung ging nicht auf, und sie war meine.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player hat meine volle Unterstützung. Er wird sich durchsetzen.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Ich glaube an $player, und er wird Ihnen zeigen, warum.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Von mir hören Sie kein schlechtes Wort über $player. Er wird liefern.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player bleibt in meinen Plänen. Achten Sie darauf, was er als Nächstes macht.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player hat uns heute im Stich gelassen, und er weiß es.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Ich habe von $player weit mehr erwartet. Darauf muss er eine Antwort finden.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player war nicht auf dem Niveau. Das sage ich auch öffentlich.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Das war nicht gut genug von $player, und das wird er von mir hören.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Offiziell: Sie gewinnen das nächste Spiel.';

  @override
  String get pressOnRecordJob =>
      'Offiziell: Man misst Sie an den nächsten drei.';

  @override
  String pressOnRecordBack(String player) {
    return 'Offiziell: Rückendeckung für $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Offiziell: $player hat Sie im Stich gelassen.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Er hat es gesagt, und es ist passiert. $nation hat einen Trainer, der meint, was er sagt.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Laut angekündigt, dann einfach gemacht. Genau den Mann hat $nation gebraucht.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: Er hat es vorhergesagt, und es kam so. Respekt.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Er hat sich festgelegt, und es hat gehalten. Punkt für ihn. $nation macht weiter.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Einmal lag er richtig. $nation, gewöhnt euch nicht dran.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Auch ein blindes Huhn findet mal ein Korn. $nation hatte diesmal Glück.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Er hat es gesagt und es hat nicht geklappt. Ich stehe trotzdem hinter ihm. $nation greift wieder an.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: Er hat mehr versprochen, als wir bekommen haben, aber mir ist ein Trainer lieber, der an sich glaubt.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: Er hat es öffentlich gesagt, und es ist nicht passiert. Das vergessen die Leute nicht.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Große Worte, nichts dahinter. $nation: Nächstes Mal weniger reden.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Er stand da und hat es uns gesagt. Dann das. $nation verdient mehr als Gerede.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Sein Wort ist jetzt nichts mehr wert. Schreib dir das auf, $nation.';
  }

  @override
  String get ncZoneNorth => 'Zone Nord';

  @override
  String get ncZoneWest => 'Zone West';

  @override
  String get ncZoneEast => 'Zone Ost';

  @override
  String get ncZoneCentralSouthern => 'Zone Zentral- und Südafrika';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Sieger';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Finalist';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Halbfinalist';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Achtelfinale';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Viertelfinalist';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · Platz $position';
  }

  @override
  String get objectiveNcFinalsEight => 'Das Viertelfinale erreichen';

  @override
  String get objectiveNcZoneWinGroup => 'Gruppensieg holen';

  @override
  String get finishNcFinalsEight => 'Viertelfinale';

  @override
  String get finishNcBottomHalf => 'Untere Tabellenhälfte der Gruppe';

  @override
  String get tourContTabZones => 'ZONEN';

  @override
  String get tourContTabFinalsEight => 'K.-O.-RUNDE';

  @override
  String get tourContFinalsEightSoon =>
      'Die K.-o.-Runde beginnt im November mit einem Achtelfinale: alle 14 Gruppensieger und die 2 besten Gruppenzweiten.';

  @override
  String get tourContQuarterFinals => 'VIERTELFINALE';

  @override
  String get tourContZoneAdvancement =>
      'Jeder Gruppensieger erreicht das Achtelfinale, dazu die 2 besten Gruppenzweiten. Niemand steigt ab.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Pokal der Nationen Nordamerikas';

  @override
  String get compAfricanNationsCup => 'Pokal der Nationen';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Den Pokal der Nationen Nordamerikas gewinnen';

  @override
  String get objectiveNcWinItAfrica => 'Den Pokal der Nationen gewinnen';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Das Finale im Pokal der Nationen Nordamerikas erreichen';

  @override
  String get objectiveNcReachFinalAfrica =>
      'Das Finale im Pokal der Nationen erreichen';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Sieger im Pokal der Nationen Nordamerikas';

  @override
  String get finishNcChampionsAfrica => 'Sieger im Pokal der Nationen';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Qualifikation: $competition. Das ganze Land glaubt an diese Mannschaft. Was ist Ihr Ziel?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Eine neue Qualifikation, $competition, und die Stimmung ist bestens. Wie weit kann diese Mannschaft kommen?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Die Qualifikation beginnt, $competition. Was ist das Ziel dieser Kampagne?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Die Qualifikation ist da, $competition. Wo sehen Sie diese Mannschaft am Ende?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Die Qualifikation beginnt, $competition, und viele zweifeln, dass Sie es schaffen. Was sagen Sie ihnen?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Wieder eine Qualifikation, $competition. Warum sollte jemand glauben, dass es diesmal anders wird?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Es geht los: $competition. Das ganze Land steht hinter Ihnen. Wie weit können Sie kommen?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Sie sind dabei: $competition. Die Fans träumen. Was ist das Ziel?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Diese Woche beginnt: $competition. Was wäre ein Erfolg?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Ihr erstes Spiel steht bevor, $competition. Nennen Sie uns ein Ziel.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Es geht los: $competition, und niemand erwartet viel. Worauf hoffen Sie wirklich?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Sie sind dabei: $competition, aber die Zweifel bleiben. Was ist Ihr Ziel?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'In Ihrer Gruppe: $rival. Macht Ihnen das Sorgen?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Die Auslosung bringt Ihnen $rival. Wie sehen Sie dieses Spiel?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival wirkt wie das stärkste Team Ihrer Gruppe. Der Favorit?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Was halten Sie von $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'In Ihrer Gruppe: $rival. Ehrlich, können Sie da mithalten?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Die meisten erwarten eine Niederlage gegen $rival. Irren sie sich?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player ist in Topform. Ist das sein Moment?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player ist in allen Schlagzeilen. Kann er diese Mannschaft tragen?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Wie sehr hängt diese Kampagne von $player ab?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Ist $player bereit, diese Mannschaft zu führen?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Wenn $player nicht in Form ist, hat diese Mannschaft dann überhaupt etwas?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player trägt viel auf seinen Schultern. Zu viel?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Wir kommen weiter, als irgendjemand erwartet.';

  @override
  String get pressReplyAimHigher2 =>
      'Ich will mehr, als der Verband verlangt, und ich sage das laut.';

  @override
  String get pressReplyMatchBrief1 =>
      'Wir kennen das Ziel und wir werden es erreichen.';

  @override
  String get pressReplyMatchBrief2 =>
      'Der Verband hat ein Ziel gesetzt. Wir liefern.';

  @override
  String get pressReplyPlayDown1 => 'Wir denken von Spiel zu Spiel.';

  @override
  String get pressReplyPlayDown2 =>
      'Keine großen Versprechen. Wir werden sehen, wo wir stehen.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Wir werden uns qualifizieren. Das können Sie aufschreiben.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Diese Mannschaft wird bei der Endrunde dabei sein.';

  @override
  String get pressReplyFearNobody1 => 'Wir fürchten niemanden.';

  @override
  String get pressReplyFearNobody2 => 'Die müssen auch gegen uns spielen.';

  @override
  String get pressReplyRespectRival1 =>
      'Sie sind Favorit, und wir respektieren sie.';

  @override
  String get pressReplyRespectRival2 =>
      'Eine sehr gute Mannschaft. Wir brauchen unser Bestes.';

  @override
  String get pressReplyTeamFirst1 =>
      'Es geht um die ganze Mannschaft, nicht um einen Spieler.';

  @override
  String get pressReplyTeamFirst2 => 'Niemand gewinnt das allein.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Offiziell: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Offiziell: keine Versprechen.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Sie haben vor der Kampagne ein Ziel genannt und es erreicht. Ihr stolzester Moment?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Sie haben gesagt, was Sie erreichen, und es geschafft. Gab es je Zweifel?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Sie haben Ihr Ziel erreicht. Glück, oder war das wirklich der Plan?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Sie haben ein Ziel genannt und es verfehlt. Was ist schiefgelaufen?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Sie haben mehr versprochen, als die Mannschaft geliefert hat. Bereuen Sie es?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Sie haben vor der Kampagne große Töne gespuckt und es nicht geschafft. Warum sollten wir Ihnen jetzt glauben?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Die Presse will Ihre Ziele hören: $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Stufe $level · $amount';
  }

  @override
  String get formOnFire => 'Glänzend in Form';

  @override
  String get formGood => 'In Form';

  @override
  String get formSteady => 'Konstant';

  @override
  String get formPoor => 'Außer Form';

  @override
  String get formCold => 'Völlig außer Form';

  @override
  String get playerFormTitle => 'FORM UND FITNESS';

  @override
  String playerFormAverage(String rating) {
    return 'Schnitt von $rating in den letzten Spielen';
  }

  @override
  String get playerFormNoGames => 'Zu wenige Spiele, um es zu beurteilen';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta auf seine Wertung im nächsten Spiel';
  }

  @override
  String get playerFormNoEffect =>
      'Keine Änderung seiner Wertung im nächsten Spiel';

  @override
  String get sideGroupHome => 'Übersicht';

  @override
  String get sideGroupTeam => 'Team';

  @override
  String get sideGroupCompetitions => 'Wettbewerbe';

  @override
  String get sideGroupFederation => 'Verband';

  @override
  String get sideGroupHistory => 'Geschichte';

  @override
  String get sideInbox => 'Posteingang';

  @override
  String get sideSquad => 'Kader';

  @override
  String get sideTactics => 'Taktik';

  @override
  String get sideMainMenu => 'Hauptmenü';

  @override
  String get sideCallUps => 'Nominierungen';

  @override
  String get sideTournaments => 'Turniere';

  @override
  String get sideRanking => 'Weltrangliste';

  @override
  String get sideResults => 'Ergebnisse';

  @override
  String get sideFinances => 'Finanzen';

  @override
  String get sideBoard => 'Vorstand';

  @override
  String get sideManager => 'Trainer & Stab';

  @override
  String get sideRecords => 'Rekorde';

  @override
  String get sideLegends => 'Legenden';

  @override
  String get sideHeadToHead => 'Direktvergleich';

  @override
  String get sideAchievements => 'Erfolge';

  @override
  String get sideCareer => 'Karriere';

  @override
  String get topBarNext => 'Nächstes';

  @override
  String get topBarDrawPending => 'Auslosung folgt';

  @override
  String get paneFullProfile => 'Vollständiges Profil';

  @override
  String get panePickPlayer =>
      'Wählen Sie einen Spieler, um seine Karte hier zu sehen';

  @override
  String get inboxPickMessage =>
      'Wählen Sie eine Nachricht, um sie hier zu lesen';

  @override
  String get inboxFilterAll => 'Alle';

  @override
  String get panelViewAll => 'Alle anzeigen';

  @override
  String get gridViewOverview => 'Übersicht';

  @override
  String get gridColCondition => 'Verfassung';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Rang';

  @override
  String get gridColMove => 'Veränderung';

  @override
  String get gridColNation => 'Nation';

  @override
  String get gridColRegion => 'Region';

  @override
  String get gridColPoints => 'Punkte';

  @override
  String get panePickNation =>
      'Wählen Sie eine Nation, um ihre Bilanz hier zu sehen';

  @override
  String get resultsCyclesTitle => 'Zyklen';

  @override
  String get tourDrawStart => 'Auslosung starten';

  @override
  String get tourDrawViewGroups => 'Gruppen ansehen';

  @override
  String get gridColCeiling => 'Potenzial';

  @override
  String get gridColYearGain => 'Zuwachs';

  @override
  String get gridColMarkedAt => 'Beim Markieren';

  @override
  String get budgetSetupTitle => 'Budget festlegen';

  @override
  String get budgetEffectsTitle => 'Was dieses Budget bringt';

  @override
  String get naturalisationTitle => 'Einbürgerung';

  @override
  String get yTrending => 'Im Trend';

  @override
  String get yVoices => 'Stimmen';

  @override
  String get yConversation => 'Unterhaltung';

  @override
  String get allTimeRecordsTitle => 'Ewige Weltrekorde';

  @override
  String get h2hMeetingsTitle => 'Alle Duelle';

  @override
  String get h2hPickOpponent =>
      'Wählen Sie einen Gegner, um hier alle Duelle zu sehen';

  @override
  String get savesTitle => 'Spielstände';

  @override
  String get gridColPlayer => 'Spieler';

  @override
  String get gridColPos => 'Pos.';

  @override
  String get gridColActive => 'Aktiv';

  @override
  String get gridColMotm => 'MVP';

  @override
  String get gridColAvg => 'Ø';

  @override
  String get gridColOpponent => 'Gegner';

  @override
  String get gridColStarts => 'Startelf';

  @override
  String get gridColTournaments => 'Turniere';

  @override
  String get gridColDate => 'Datum';

  @override
  String get gridColLastPlayed => 'Zuletzt gespielt';

  @override
  String get gridColManager => 'Trainer';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Nationalteams',
      one: '1 Nationalteam',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Nach Weltrangliste sortiert';

  @override
  String get nationsStrength => 'Stärke';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier von 5';
  }

  @override
  String get nationsSquadOverall => 'Kaderwertung';

  @override
  String get nationsOpeningBudget => 'Startbudget';

  @override
  String get nationsStarPlayer => 'Star des Teams';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Star $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return '$age Jahre';
  }

  @override
  String get nationsBoardExpects => 'Der Vorstand erwartet';

  @override
  String nationsManage(String nation) {
    return '$nation übernehmen';
  }

  @override
  String get nationsManagerNext =>
      'Als Nächstes geben Sie Ihrem Trainer einen Namen';

  @override
  String get playerPageTitle => 'Spieler';

  @override
  String get nationPageTitle => 'Nationalteam';

  @override
  String get friendliesYourGames => 'Ihre Testspiele';

  @override
  String hubEventInjuryCover(String player) {
    return 'Ersatz für den verletzten $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Fällt $matches Spiele aus',
      one: 'Fällt für das nächste Spiel aus',
    );
    return '$_temp0. Nominieren Sie jemanden nach oder spielen Sie ohne ihn weiter.';
  }

  @override
  String get injuryCoverTitle => 'NACHNOMINIERUNG';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) ist verletzt. Nominieren Sie einen beliebigen Spieler außerhalb des Kaders nach, auf jeder Position, oder behalten Sie ihn und spielen Sie weiter.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return '$player nachnominieren';
  }

  @override
  String injuryCoverKeep(String player) {
    return '$player behalten und weiterspielen';
  }

  @override
  String get injuryCoverPick => 'Ersatz wählen';

  @override
  String get injuryCoverNone => 'Außerhalb des Kaders ist niemand fit.';

  @override
  String get nationNowRanking => 'Weltrangliste';

  @override
  String get nationNowForm => 'Form';

  @override
  String get nationNowNoForm => 'Noch kein Spiel absolviert';

  @override
  String get nationNowNext => 'Nächstes Spiel';

  @override
  String get nationNowNoNext => 'Nichts angesetzt';

  @override
  String get nationNowSquad => 'Kader';

  @override
  String get nationNowAgainstYou => 'Gegen dich';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}S ${d}U ${l}N';
  }

  @override
  String get nationNowLastMeeting => 'Letztes Duell';

  @override
  String nationNowOverall(int value) {
    return 'Gesamt $value';
  }

  @override
  String get hubUpcoming => 'ANSTEHEND';

  @override
  String get hubFullSchedule => 'Gesamter Spielplan';

  @override
  String get scheduleTitle => 'Spielplan';

  @override
  String get scheduleToday => 'Heute';

  @override
  String get scheduleKnockoutPending => 'K.-o.-Phase, falls ihr weiterkommt';

  @override
  String get scheduleNextRoundPending => 'Nächste Runde';

  @override
  String scheduleFromDate(String date) {
    return 'Ab $date';
  }

  @override
  String get scheduleHomeShort => 'H';

  @override
  String get scheduleAwayShort => 'A';

  @override
  String get tacticsNoPresetsInMatch =>
      'Noch keine gespeicherten Taktiken. Speichere vor dem Spiel eine im Taktik-Bildschirm.';

  @override
  String get homeCampaigns => 'Kampagnen';

  @override
  String get homeContinueCampaign => 'KAMPAGNE FORTSETZEN';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Zyklus $cycle von $total';
  }

  @override
  String get campaignsTitle => 'Kampagnen';

  @override
  String get campaignTransplantTitle => 'Die Verpflanzung';

  @override
  String get campaignTransplantTwist =>
      'Acht von Italiens Besten wechseln zu San Marino';

  @override
  String get campaignTransplantGoal =>
      'Für die Europameisterschaft qualifizieren';

  @override
  String get campaignGrudgeTitle => 'Groll';

  @override
  String get campaignGrudgeTwist => 'Georgien und Albanien, zusammen gelost';

  @override
  String get campaignGrudgeGoal => 'In der Qualifikation vor Albanien landen';

  @override
  String get campaignTransplantIntro =>
      'San Marino hatte nie eine Qualifikation, die diesen Namen verdient. Dann nehmen acht von Italiens Besten den Pass und laufen auf. Sie haben einen Zyklus, um aus einer Kuriosität ein Team zu machen.';

  @override
  String get campaignGrudgeIntro =>
      'Georgien und Albanien wurden in dieselbe Qualifikationsgruppe gelost, und keiner vergibt eine Niederlage. Landen Sie vor Albanien und sehen Sie, wie weit es trägt.';

  @override
  String get campaignStars1Transplant => 'Qualifizieren';

  @override
  String get campaignStars2Transplant => 'K.-o.-Runde erreichen';

  @override
  String get campaignStars3Transplant => 'Die Europameisterschaft gewinnen';

  @override
  String get campaignStars1Grudge => 'Vor Albanien';

  @override
  String get campaignStars2Grudge => 'Und qualifizieren';

  @override
  String get campaignStars3Grudge => 'Und sie zweimal schlagen';

  @override
  String get campaignFree => 'Gratis';

  @override
  String get campaignStart => 'Starten';

  @override
  String get campaignPartOfUnlimited => 'Teil von Unlimited';

  @override
  String get campaignResume => 'Fortsetzen';

  @override
  String get campaignAbandon => 'Aufgeben';

  @override
  String get campaignAbandonConfirm =>
      'Diesen Durchlauf aufgeben? Der Fortschritt geht verloren, Ihr Stempel bleibt.';

  @override
  String get campaignMoveToSaves => 'In Spielstände verschieben';

  @override
  String get campaignCannotContinue =>
      'Die Welt dieser Kampagne ist zu weit von der echten entfernt, um sie als Karriere weiterzuspielen.';

  @override
  String get campaignMoveSlotsFull =>
      'Ihre Speicherplätze sind belegt. Geben Sie zuerst einen frei.';

  @override
  String get campaignStampConquered => 'Erobert';

  @override
  String get campaignStampFailed => 'Gescheitert';

  @override
  String get campaignDifficultyHard => 'Schwer';

  @override
  String get campaignDifficultyMedium => 'Mittel';

  @override
  String get campaignGoalLabel => 'Ziel';

  @override
  String get campaignStarsLabel => 'Sterne';

  @override
  String get campaignRunInProgress =>
      'Diese Kampagne hat bereits einen laufenden Durchlauf.';

  @override
  String get campaignVerdictWon => 'Erobert';

  @override
  String get campaignVerdictLost => 'Diesmal nicht';

  @override
  String get campaignVerdictContinue => 'Weiter';

  @override
  String campaignProgressQualifying(String position) {
    return 'Qualifikation: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Endrunde: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Der Lauf in Zahlen';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Gewonnene Duelle: $won von $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'other': '$n.',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Das beste Guinea';

  @override
  String get campaignGuineasTwist =>
      'Äquatorialguinea, das kleinste Guinea Afrikas, für zwei Zyklen';

  @override
  String get campaignGuineasGoal => 'Guinea und Guinea-Bissau schlagen';

  @override
  String get campaignGuineasIntro =>
      'Drei afrikanische Nationen tragen den Namen Guinea, und Äquatorialguinea ist das kleinste von ihnen. Sie haben zwei Zyklen, um Guinea und Guinea-Bissau je mindestens einmal zu schlagen. Danach zählt, wie weit Sie in der Afrikameisterschaft kommen. Papua-Neuguinea, das vierte Guinea, ist bereits für ein Freundschaftsspiel gebucht.';

  @override
  String get campaignStars1Guineas => 'Guinea und Guinea-Bissau schlagen';

  @override
  String get campaignStars2Guineas =>
      'Und sich für eine Afrikameisterschaft qualifizieren';

  @override
  String get campaignStars3Guineas =>
      'Und ein Viertelfinale der Afrikameisterschaft erreichen';

  @override
  String get campaignYoungFinnsTitle => 'Junge Finnen';

  @override
  String get campaignYoungFinnsTwist =>
      'Finnlands goldene Generation von Teenagern, für drei Zyklen';

  @override
  String get campaignYoungFinnsGoal =>
      'Für eine Weltmeisterschaft qualifizieren';

  @override
  String get campaignYoungFinnsIntro =>
      'Finnlands erfahrene Spieler sind zurückgetreten, und eine goldene Generation hat ihren Platz eingenommen: Jeder Spieler, den Sie berufen können, ist 18 oder jünger. Heute sind sie noch roh, aber sie haben das Talent, eine der besten Mannschaften der Welt zu werden, so wie Norwegens junge Generation. Sie haben drei Zyklen, um sie zu einer Weltmeisterschaft zu führen und dann die Europameisterschaft und die Weltmeisterschaft zu gewinnen.';

  @override
  String get campaignStars1YoungFinns =>
      'Für eine Weltmeisterschaft qualifizieren';

  @override
  String get campaignStars2YoungFinns => 'Die Europameisterschaft gewinnen';

  @override
  String get campaignStars3YoungFinns => 'Die Weltmeisterschaft gewinnen';

  @override
  String get campaignGreenlandTitle => 'Ein grönländisches Jahrhundert';

  @override
  String get campaignGreenlandTwist =>
      'Grönland nimmt San Marinos Platz in Europa ein, für hundert Jahre';

  @override
  String get campaignGreenlandGoal =>
      'Für eine Europameisterschaft qualifizieren';

  @override
  String get campaignGreenlandIntro =>
      'Grönland hat noch nie ein Pflichtländerspiel bestritten. In dieser Welt hat es San Marinos Platz in Europa eingenommen und startet ganz unten in der Weltrangliste: Amateurspieler, Kunstrasenplätze und eine Saison, eingezwängt zwischen den Schneefällen. Sie haben hundert Jahre, also fünfundzwanzig Zyklen, um eine Europameisterschaft zu erreichen, dann eine Weltmeisterschaft und, wenn Sie zu träumen wagen, eine davon zu gewinnen.';

  @override
  String get campaignStars1Greenland =>
      'Für eine Europameisterschaft qualifizieren';

  @override
  String get campaignStars2Greenland =>
      'Für eine Weltmeisterschaft qualifizieren';

  @override
  String get campaignStars3Greenland =>
      'Die Europameisterschaft oder die Weltmeisterschaft gewinnen';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Nicht qualifiziert';

  @override
  String get campaignCupOpen => 'Noch offen';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name glänzt für die $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Bericht aus der Akademie: $name fällt auf';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Herausragend in der $level: $name';
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
      other: '$count-mal',
      one: 'einmal',
    );
    return '$name traf im letzten Länderspielfenster $_temp0 für die $level gegen $opponent.';
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
      other: '$count Tore',
      one: 'Ein Tor',
    );
    return '$_temp0 von $name, als die $level in diesem Fenster auf $opponent traf.';
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
      other: '$count Toren',
      one: 'einem Tor',
    );
    return 'Die $level spielte gegen $opponent, und $name ging mit $_temp0 vom Platz.';
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
      other: '$count Tore',
      one: 'ein Tor',
    );
    return '$name bereitete für die $level gegen $opponent $_temp0 vor und lenkte das Spiel von der ersten bis zur letzten Minute.';
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
      other: '$count Vorlagen',
      one: 'eine Vorlage',
    );
    return 'Die $level traf in diesem Fenster auf $opponent, und $name zog die Fäden: $_temp0 und eine Leistung, über die das Trainerteam noch immer spricht.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name war überragend, als die $level gegen $opponent zu null spielte.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Zu null für die $level gegen $opponent, und das lag vor allem an $name.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name überzeugte für die $level gegen $opponent, und das Trainerteam bewertete seine Leistung mit $mark von zehn.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'Die $level spielte in diesem Fenster gegen $opponent, und die Trainer hoben $name hervor: $mark von zehn, die beste Note im Team.';
  }

  @override
  String get newsYouthDevReady1 =>
      'In dieser Form ist er schon gut genug, um für die A-Nationalmannschaft in Betracht zu kommen.';

  @override
  String get newsYouthDevReady2 =>
      'Das Trainerteam hält ihn schon jetzt für bereit für den Erwachsenenfußball. Die Entscheidung liegt bei Ihnen.';

  @override
  String get newsYouthDevClose1 =>
      'Er entwickelt sich gut und steht kurz vor dem Sprung in die A-Nationalmannschaft.';

  @override
  String get newsYouthDevClose2 =>
      'Zur A-Nationalmannschaft fehlt ihm nicht mehr viel, und eine weitere gute Saison könnte reichen.';

  @override
  String get newsYouthDevGrowing1 =>
      'Er entwickelt sich ordentlich, auch wenn die A-Nationalmannschaft noch einen oder zwei Schritte entfernt ist.';

  @override
  String get newsYouthDevGrowing2 =>
      'Bis zum A-Nationalspieler ist noch einiges zu tun, aber alles zeigt in die richtige Richtung.';

  @override
  String get newsYouthDevRaw1 =>
      'Er ist noch ungeschliffen und einige Jahre von der A-Nationalmannschaft entfernt, aber das Talent ist unübersehbar.';

  @override
  String get newsYouthDevRaw2 =>
      'Es ist noch früh, und die Akademie bittet um Geduld statt Schlagzeilen.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Seine Reichweite und seine Strafraumbeherrschung heben ihn ab.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Fangsicherheit und Spieleröffnung sind die besten, die die Akademie seit Jahren gesehen hat.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Seine Konzentration lässt nie nach, in der neunzigsten Minute ist er so wach wie in der ersten.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Sein Tempo und seine Kopfballstärke sind der Schlüssel zu seinem Spiel.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Er liest das Spiel weit über sein Alter hinaus und bleibt am Ball ruhig.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Er schaltet nie ab und sprintet auch in der letzten Minute noch zurück.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Er erobert Bälle mit echter Wucht und treibt sie sofort nach vorn.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Seine Spielübersicht und sein Passspektrum sind der Schlüssel zu seinem Spiel.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Seine Laufleistung ist enorm: Er beackert jeden Grashalm.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Mit Tempo in die Tiefe und Kopfballstärke ist er für jede Abwehr ein Problem.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Sein Abschluss und seine Bewegung im Strafraum sind der Schlüssel zu seinem Spiel.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Er presst das ganze Spiel über von vorn und lässt den Verteidigern keine Ruhe.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Von diesem Spiel gegen $opponent werden die Fans noch lange singen. Was haben Sie den Spielern nach dem Abpfiff gesagt?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Das war eine Ansage gegen $opponent. Wie viel davon kam vom Trainingsplatz?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Respekt für das Ergebnis gegen $opponent, aber solche Abende hatten wir schon. Was ist diesmal anders?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Jeder hat mal einen schlechten Abend, und das war einer gegen $opponent. Wie schnell können Sie das abhaken?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent war in allen Bereichen besser. Wo fangen Sie mit der Reparatur an?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Die Fans sind gegen $opponent schon vor dem Ende gegangen. Können Sie es ihnen verdenken?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Es ist eine schwere Phase, und $opponent hat es nicht leichter gemacht. Was treibt Sie an?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Wieder ein Spiel ohne Sieg, diesmal gegen $opponent. Wie lange kann das noch gehen, bevor das Präsidium handelt?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Jetzt auch noch $opponent. Ist in Ihrem Plan noch etwas übrig, oder ist es Zeit, Platz für einen anderen zu machen?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Was Sie auch schreiben, schreiben Sie es über die Spieler. Das haben sie sich verdient.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Ich habe eine Gruppe, die füreinander durchs Feuer geht. Das ist nicht nichts.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Ich treffe die Entscheidungen, also trifft die Kritik mich. Das gehört zum Job.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Schauen Sie zuerst auf den Trainer. Ich habe Fehler gemacht, und ich werde sie korrigieren.';

  @override
  String get pressReplyDemandMore5 =>
      'Gut ist hier nicht gut genug. Das habe ich ihnen ins Gesicht gesagt.';

  @override
  String get pressReplyDemandMore6 =>
      'Niemand in dieser Kabine hat einen Stammplatz sicher. Das wissen sie jetzt.';

  @override
  String get pressReplyDeflect5 =>
      'Sie können es auf drei Arten fragen. Die Antwort bleibt dieselbe.';

  @override
  String get pressReplyDeflect6 =>
      'Meine Gedanken behalte ich für die Spieler. Dafür haben Sie sicher Verständnis.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score gegen $opponent. Ruhiger, kontrollierter, erwachsener Fußball. So muss das.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$opponent $score geschlagen, ohne ins Schwitzen zu kommen. Wir werden richtig gut im Langweiligsein, und langweilig gewinnt Titel.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Drei Punkte, kein Drama, zurück an die Arbeit.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Ein routiniertes $score gegen $opponent. Keiner wird sich daran erinnern, und das muss auch keiner.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score gegen $opponent, und trotzdem mache ich mir irgendwie Sorgen.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$opponent $score geschlagen. Gegen eine echte Mannschaft wird so eine Leistung bestraft.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score gegen $opponent. Reingebissen, gelitten, gewonnen. Das ist eine Mannschaft.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$opponent $score geschlagen, nur mit Nervenstärke. Ich nehme eine Mannschaft, die sich weigert zu verlieren.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Bis zum Schluss eng, aber die Punkte gehören uns.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Ein knappes $score gegen $opponent. Viel war nicht dazwischen, und das ist Fußball.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score gegen $opponent. Ein glücklicher Abpraller in die andere Richtung, und wir führen eine ganz andere Diskussion.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Gegen $opponent gerade so über die Zeit gerettet, $score. Das sollte niemand eine Leistung nennen.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score gegen $opponent. Keine Niederlage, und manchmal ist genau das der Job.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Ein hart erkämpfter Punkt gegen $opponent, $score. Der Kampfgeist hat mir gefallen.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Leistungsgerechtes Remis, wie die alten Reporter sagten.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score gegen $opponent. Keine Seite hat genug für mehr getan.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score gegen $opponent. So ein Remis, das sich im Bus nach Hause wie eine Niederlage anfühlt.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return '$score gegen $opponent. Wir reden ständig von Fortschritt und machen ständig das hier.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score gegen $opponent. Tut weh, aber ich habe genug gesehen, um an diese Mannschaft zu glauben.';
  }

  @override
  String yLost13(String opponent, String score) {
    return '$score gegen $opponent verloren, und die waren gut. Anerkennen und weitermachen.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Eine Niederlage, ein paar Lehren, und das nächste Spiel kommt bald.';
  }

  @override
  String yLost15(String opponent, String score) {
    return '$score gegen $opponent verloren. Da gibt es wenig zu diskutieren.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score gegen $opponent. Dieselben Fehler wie letztes Mal, mit derselben Selbstsicherheit.';
  }

  @override
  String yLost17(String opponent, String score) {
    return '$score gegen $opponent verloren. Wenn dafür niemand geradestehen muss, was machen wir hier eigentlich?';
  }

  @override
  String get yReactionShrug12 =>
      'Passt schon. Nicht jeder Abend braucht ein Feuerwerk.';

  @override
  String get yReactionShrug13 => 'Punkte sind Punkte. Heute schlafe ich gut.';

  @override
  String get yReactionShrug14 => 'Gesehen. Keine Anmerkungen.';

  @override
  String get yReactionShrug15 => 'Irgendwo zwischen okay und okay.';

  @override
  String get yReactionShrug16 =>
      'Dafür habe ich den Stream bezahlt. Nie wieder (ich bin wieder da).';

  @override
  String get yReactionShrug17 => 'Neunzig Minuten fußballförmiges Nichts.';

  @override
  String get yReactionRelief12 =>
      'Ich atme wieder. Stolz, dass sie es über die Zeit gebracht haben.';

  @override
  String get yReactionRelief13 =>
      'Solche Siege schweißen eine Mannschaft zusammen. Hässlich ist schön.';

  @override
  String get yReactionRelief14 =>
      'Meine Fingernägel sind weg, die Punkte nicht.';

  @override
  String get yReactionRelief15 => 'Ein Abpfiff hat noch nie so gut geklungen.';

  @override
  String get yReactionRelief16 =>
      'Froh über den Sieg, besorgt darüber, wie er zustande kam.';

  @override
  String get yReactionRelief17 =>
      'Wir kommen immer wieder damit durch. Irgendwann nicht mehr.';

  @override
  String get yReactionFury12 =>
      'Ich liebe diese Mannschaft, und genau deshalb tut das so weh.';

  @override
  String get yReactionFury13 =>
      'Schlechter Abend. Beim nächsten Mal schulden sie uns was, und das wissen sie.';

  @override
  String get yReactionFury14 =>
      'Nach siebzig Minuten ausgeschaltet. Hätten sechzig sein sollen.';

  @override
  String get yReactionFury15 => 'Kein Kampf, keine Ideen, keine Ausreden.';

  @override
  String get yReactionFury16 =>
      'Jedes Mal dieselben Probleme, und niemand behebt irgendwas.';

  @override
  String get yReactionFury17 =>
      'Jemand beim Verband sollte sich das noch mal ansehen und es erklären.';

  @override
  String get backupShareHint =>
      'Erstellt eine Backup-Datei mit allen Spielständen. Wähle Google Drive, iCloud Drive oder Dateien zum Aufbewahren.';

  @override
  String backupLastAt(String date) {
    return 'Letztes Backup: $date';
  }

  @override
  String get backupNever => 'Noch kein Backup';

  @override
  String get backupRemindersTitle => 'Backup-Erinnerungen';

  @override
  String get backupRemindersBlurb =>
      'Eine Nachricht im Posteingang, wenn dein letztes Backup alt wird.';

  @override
  String get backupAutoICloudTitle => 'Automatisches iCloud-Backup';

  @override
  String get backupAutoDriveTitle => 'Automatisches Google-Drive-Backup';

  @override
  String get backupAutoBlurb =>
      'Sichert nach Spielen, am Ende eines Zyklus und wenn du die App verlässt. Behält die letzten zwei.';

  @override
  String get backupStatusUploading => 'Backup läuft.';

  @override
  String get backupStatusUploaded => 'Gesichert.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud ist aus. Melde dich in der Einstellungen-App bei iCloud an und schalte iCloud Drive ein.';

  @override
  String get backupStatusDriveSignedOut =>
      'Nicht angemeldet. Schalte den Schalter ein, um dich mit Google anzumelden.';

  @override
  String get backupStatusNotConfigured =>
      'In dieser Version der App noch nicht verfügbar.';

  @override
  String get backupStatusUnavailable =>
      'Die Cloud ist gerade nicht erreichbar. Es wird später erneut versucht.';

  @override
  String get backupStatusFailed =>
      'Das letzte automatische Backup hat nicht geklappt. Es wird später erneut versucht.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Angemeldet als $email';
  }

  @override
  String get backupDriveSignOut => 'ABMELDEN';

  @override
  String get backupDriveSignInFailed =>
      'Die Google-Anmeldung hat nicht geklappt. Versuche es später noch einmal.';

  @override
  String get backupRestoreICloud => 'AUS ICLOUD WIEDERHERSTELLEN';

  @override
  String get backupRestoreDrive => 'AUS GOOGLE DRIVE WIEDERHERSTELLEN';

  @override
  String get backupCrossPlatformHelp =>
      'Wechsel zwischen iPhone und Android? Sichere auf dem einen Handy in eine Datei und stelle auf dem anderen aus dieser Datei wieder her.';

  @override
  String get backupCloudListBlurb =>
      'Backups deiner Geräte in diesem Konto. Tippe auf eines, um es wiederherzustellen.';

  @override
  String get backupCloudListEmpty =>
      'Noch keine Backups gefunden. Ein neues Backup kann einige Minuten brauchen, bis es auf einem anderen Gerät ankommt.';

  @override
  String get backupCloudListFailed =>
      'Die Backups konnten nicht gelesen werden. Prüfe die Verbindung und versuche es erneut.';

  @override
  String get backupCloudThisDevice => 'Dieses Gerät';

  @override
  String backupCloudMore(int count) {
    return 'Weitere Spielstände: $count';
  }

  @override
  String get backupCloudNewer =>
      'Mit einer neueren App-Version erstellt. Bitte zuerst aktualisieren.';

  @override
  String get backupCloudDownloading => 'Backup wird geladen.';

  @override
  String get backupRestoreSafetyNote =>
      'Eine Kopie der Spielstände auf diesem Handy wird vorher auf diesem Handy aufbewahrt.';

  @override
  String get backupRejectedSafety =>
      'Von den aktuellen Spielständen konnte keine Kopie angelegt werden, daher wurde nichts ersetzt.';

  @override
  String get newsBackupReminderTitle => 'Zeit für ein Backup';

  @override
  String get newsBackupReminderBody =>
      'Deine Spielstände gibt es nur auf diesem Handy. Öffne die Einstellungen und tippe auf In der Cloud sichern, oder schalte dort das automatische Backup ein. Diese Erinnerungen lassen sich in den Einstellungen auch abschalten.';

  @override
  String get backupSafetyTitle => 'Kopien von vor einer Wiederherstellung';

  @override
  String get backupSafetyBlurb =>
      'Auf diesem Handy aufbewahrt, falls eine Wiederherstellung die falsche war. Die neuesten drei bleiben.';

  @override
  String get backupSafetyRestore => 'WIEDERHERSTELLEN';

  @override
  String get backupSafetyShare => 'TEILEN';

  @override
  String get backupCloudNoDetails => 'Die Details sind noch unterwegs.';

  @override
  String get tacticsLibraryTitle => 'TAKTIKBIBLIOTHEK';

  @override
  String get tacticsLibraryBlurb =>
      'Taktiken aus Ihrer Bibliothek lassen sich in jedem Spielstand laden, auch in neuen. Rollen und Standardschützen werden nach Position gespeichert, nicht nach Spieler.';

  @override
  String get tacticsSaveToLibrary => 'In Bibliothek speichern';

  @override
  String get tacticsLoadFromLibrary => 'Aus Bibliothek laden';

  @override
  String get tacticsLibraryEmpty =>
      'Ihre Bibliothek ist leer. Speichern Sie hier eine Taktik, dann können Sie sie in jedem Spielstand laden.';

  @override
  String tacticsLibrarySaved(String name) {
    return '„$name“ in der Bibliothek gespeichert';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return '„$name“ geladen';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Rollen oder Standardschützen passten nicht zu diesem Kader.',
      one: '1 Rolle oder Standardschütze passte nicht zu diesem Kader.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Umbenennen';

  @override
  String get tacticsLibraryRenameTitle => 'Taktik umbenennen';

  @override
  String get tacticsLibraryDelete => 'Löschen';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return '„$name“ löschen?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Sie verschwindet in allen Ihren Spielständen aus der Bibliothek.';

  @override
  String get tacticsLibraryNameTaken =>
      'In Ihrer Bibliothek gibt es schon eine Taktik mit diesem Namen.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Bibliothek konnte nicht geladen werden.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Bewerbung als Gastgeber: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Bewerbung';

  @override
  String get hostBidBlurb =>
      'Der Gastgeber wird unter den Kandidaten ausgelost. Eine Bewerbung gibt Ihrem Namen mehr Gewicht: Ihre Stadien bringen eine Grundchance, Geld erhöht sie, wobei jede weitere Million etwas weniger bewirkt. Das Geld ist ausgegeben, ob Sie gewinnen oder nicht.';

  @override
  String hostBidPrize(String amount) {
    return 'Gewinnen Sie, sind Sie Gastgeber, automatisch qualifiziert und erhalten einen einmaligen Zuschuss von $amount für das nächste Budget.';
  }

  @override
  String get hostBidChance => 'Chance auf den Zuschlag';

  @override
  String get hostBidBaseLabel => 'Stadien und Stellung';

  @override
  String get hostBidInvestLabel => 'Investition';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Obergrenze für $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Ihre Investition';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Freie Mittel: $amount';
  }

  @override
  String get hostBidSubmit => 'Bewerbung einreichen';

  @override
  String get hostBidDecline => 'Diesmal nicht';

  @override
  String get hostBidUnavailable => 'Diese Bewerbung ist nicht mehr möglich.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Zuschlag erhalten: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Wir richten das Turnier aus und sind als Gastgeber automatisch qualifiziert. Ein einmaliger Zuschuss von $amount liegt jetzt in der Verbandskasse, und Sie können ihn direkt vom Hub aus den Abteilungen dieses Zyklus zuteilen.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Bewerbung gescheitert: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Den Zuschlag erhielt: $hosts. Unsere Bewerbung reichte diesmal nicht, das eingesetzte Geld ist weg, aber der Verband hat sich gut präsentiert.';
  }

  @override
  String get hostBidGrantEvent => 'Ausrichterzuschuss verteilen';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Ausrichterzuschuss: $amount, die Sie jetzt den Abteilungen dieses Zyklus zuteilen können. Bereits Verteiltes bleibt; was übrig bleibt, bleibt in der Kasse.';
  }

  @override
  String get stadiumsTitle => 'Nationalstadien';

  @override
  String get stadiumsEntrySub => 'Ein Stadion ausbauen oder ein neues bauen';

  @override
  String get stadiumsBlurb =>
      'Die Stufe eines Stadions ist seine Größe: Stufe 1 unter 15.000 Plätzen, Stufe 2 ab 15.000, Stufe 3 ab 25.000, Stufe 4 ab 40.000, Stufe 5 ab 60.000. Jedes Stadion bringt zu Beginn jedes Zyklus eine kleine Einnahme, mehr für mehr Plätze, solange Ihre Fans sie füllen. Ein Ausbau bringt sofort Plätze und ab dem nächsten Zyklus etwas Ansehen; ein Rückbau senkt die Unterhaltskosten, erstattet aber nichts. Ihre Stadien entscheiden, für welche Turniere Sie sich bewerben dürfen.';

  @override
  String stadiumsIncome(String amount) {
    return 'Stadioneinnahmen: $amount pro Zyklus';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Ansehen durch Stadien: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Bauarbeiten werden zu Beginn eines Zyklus vergeben, bevor das Budget steht.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Kapazität: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Stufe $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Ausbauen: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Höchste Stufe';

  @override
  String stadiumsOpens(int year) {
    return 'Im Bau, Eröffnung $year';
  }

  @override
  String get stadiumsBuildTitle => 'Ein neues Stadion bauen';

  @override
  String get stadiumsBuildBody =>
      'Ziemlich teuer: ein neues Stadion in einer Stadt Ihrer Wahl, geöffnet ab Beginn des nächsten Zyklus.';

  @override
  String get stadiumsBuildCity => 'Stadt';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Bauen: $cost';
  }

  @override
  String get stadiumsBuilding => 'Es wird bereits ein Stadion gebaut.';

  @override
  String get stadiumsNoCity => 'Jede Stadt hat bereits ein neues Stadion.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return '$stadium für $cost auf Stufe $level ausbauen?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Für $cost ein neues Stadion in $city bauen?';
  }

  @override
  String get stadiumsConfirm => 'Bestätigen';

  @override
  String get stadiumsCancel => 'Abbrechen';

  @override
  String get stadiumsRefused =>
      'Der Auftrag ist nicht durchgegangen. Es wurde nichts berechnet.';

  @override
  String get stadiumsNameLabel => 'Stadionname';

  @override
  String get stadiumsNameHint =>
      'Leer lassen, um den vorgeschlagenen Namen zu behalten.';

  @override
  String get stadiumsRename => 'Stadion umbenennen';

  @override
  String get hostBidSectionTitle => 'Bewerbungen als Gastgeber';

  @override
  String get hostBidOpenSub =>
      'Freiwillig. Entscheiden Sie vor Beginn des neuen Zyklus.';

  @override
  String get hostBidDecidedAtRollover =>
      'Der Gastgeber wird zu Beginn des neuen Zyklus bekannt gegeben.';

  @override
  String get hostBidLodged =>
      'Bewerbung eingereicht. Der Gastgeber wird zu Beginn des neuen Zyklus bekannt gegeben.';

  @override
  String get hostBidDeclinedNote =>
      'Sie haben diesmal auf eine Bewerbung verzichtet.';

  @override
  String get hostBidOpensLater =>
      'Bewerbung möglich. Sie können sich am Ende dieses Zyklus bewerben.';

  @override
  String get hostBidNoFunds => 'Nicht genug freie Mittel für eine Bewerbung.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ihnen fehlen noch $count Stadien mit $seats+ Plätzen.',
      one: 'Ihnen fehlt noch 1 Stadion mit $seats+ Plätzen.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation hat die letzte Weltmeisterschaft ausgerichtet.';
  }

  @override
  String get hostBidRecentHost =>
      'Sie waren Gastgeber einer der letzten drei Ausgaben.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Bedingung: $grounds Stadien mit $minSeats+ Plätzen, davon $bigGrounds mit $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Wir richten das Turnier aus und sind als Gastgeber automatisch qualifiziert. Eine einmalige Förderung von $amount ist bereits in den Mitteln des Verbands, bereit für das Budget dieses Zyklus.';
  }

  @override
  String get hubStadiumIncome => 'Stadioneinnahmen';

  @override
  String get stadiumsDownsize => 'Verkleinern';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return '$stadium auf $seats Plätze verkleinern (Stufe $level)? Nichts wird erstattet, aber die Unterhaltskosten sinken.';
  }

  @override
  String get stadiumsResizedThisCycle => 'In diesem Zyklus umgebaut';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Bringt $amount pro Zyklus';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Bewerbung zurückgezogen: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Die Bewerbung galt für $nation, doch Sie beginnen den neuen Zyklus anderswo. Sie wurde zurückgezogen, nichts wurde abgebucht.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'Zum Ende des Zyklus reichten die Mittel des Verbands nicht mehr für den Einsatz. Die Bewerbung wurde zurückgezogen, nichts wurde abgebucht.';

  @override
  String get stadiumsViewMap => 'Karte';

  @override
  String get stadiumsViewList => 'Liste';

  @override
  String get stadiumsMapPickCity =>
      'Tippen Sie auf eine Stadt, um dort ein neues Stadion zu bauen.';

  @override
  String get stadiumsMapFit => 'Ganzes Land zeigen';

  @override
  String get campaignLegacyTitle => 'Das Vermächtnis vollenden';

  @override
  String get campaignLegacyTwist =>
      'Spanien, der amtierende Europameister, für einen Zyklus';

  @override
  String get campaignLegacyGoal => 'Den EM-Titel verteidigen';

  @override
  String get campaignLegacyIntro =>
      'Spanien ist amtierender Europameister, und die Zweifler halten den goldenen Lauf für eine Eintagsfliege. Du hast einen Zyklus, um das Gegenteil zu beweisen: Verteidige die Krone des Kontinents und greif dann nach der Welt. Hol dazu noch den Pokal der Nationen, und das Vermächtnis ist vollendet.';

  @override
  String get campaignStars1Legacy => 'Die Europameisterschaft gewinnen';

  @override
  String get campaignStars2Legacy => 'Dazu die Weltmeisterschaft';

  @override
  String get campaignStars3Legacy => 'Dazu den Pokal der Nationen';

  @override
  String get campaignSectionOneCycle => 'Ein Zyklus';

  @override
  String get campaignSectionShort => 'Ein paar Zyklen';

  @override
  String get campaignSectionLong => 'Langstrecke';

  @override
  String get campaignFilterAll => 'Alle';

  @override
  String get campaignFilterNew => 'Nicht gespielt';

  @override
  String get campaignFilterInProgress => 'Laufend';

  @override
  String get campaignFilterDone => 'Abgeschlossen';

  @override
  String get campaignFilterEmpty => 'Hier gibt es noch keine Kampagnen.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sterne',
      one: '1 Stern',
      zero: 'Keine Sterne',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles Zyklen',
      one: '1 Zyklus',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh =>
      ' Er tritt auf dem Höhepunkt ab, als Titelträger.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Das Verpassen der Endrunde war der letzte Tropfen.';

  @override
  String get msgIntlRetireNoteSurprise => ' Damit hat niemand gerechnet.';

  @override
  String get msgIntlRetireNoteRecord => ' Er geht als Rekordnationalspieler.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name tritt aus der Nationalmannschaft zurück';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) hat mit $age seinen Rücktritt aus der Nationalmannschaft erklärt.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name kehrt in die Nationalmannschaft zurück';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name steht mit $age wieder für eine Nominierung bereit.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Der Kader ist von Verletzungen geplagt, und er ist dem Ruf gefolgt.';

  @override
  String get msgIntlComebackNoteManager =>
      ' Der neue Trainer hat ihn umgestimmt.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name kehrt in die Nationalmannschaft zurück';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) steht mit $age wieder für eine Nominierung bereit.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Rücktritt aus der Nationalmannschaft, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Rückkehr in die Nationalmannschaft, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Danke, $name. Andere tragen das Trikot, er hat die Mannschaft getragen.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name beendet seine Länderspielkarriere. Das Ende einer Ära.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name hört auf. Ehrlich gesagt, ein Turnier zu spät.';
  }

  @override
  String yLegendRetires3(String name) {
    return '$name ist also fertig. Jetzt sollen die Jungen ran.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Höhe $altitudeString m: Der Gegner wird schneller müde';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Höhe $altitudeString m: Ihre Spieler werden schneller müde';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Höhe $altitudeString m: Beide Teams werden schneller müde';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Höhe $altitudeString m: Beide Teams sind daran gewöhnt';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Hitze: $tempString °C erwartet, die Kräfte schwinden früher';
  }

  @override
  String get matchConditionsAdvice =>
      'Wechseln Sie früh: Frische Beine zählen hier mehr';

  @override
  String get fanMoodFurious => 'wütend';

  @override
  String get fanMoodRestless => 'unruhig';

  @override
  String get fanMoodCalm => 'gelassen';

  @override
  String get fanMoodUpbeat => 'zuversichtlich';

  @override
  String get fanMoodEuphoric => 'euphorisch';

  @override
  String matchHomeFans(String mood) {
    return 'Heimfans: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Fans: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Stadioneinnahmen im nächsten Zyklus: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Zwanzig Jahre bei jedem Spiel dabei, heim wie auswärts. Die Dauerkarte verlängere ich erst, wenn sich etwas ändert.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Wir singen weiter für das Trikot. Aber das Banner in der Nordkurve hat heute gesagt, was wir alle denken.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Das halbe Stadion leer, und die andere Hälfte hat die ganze zweite Halbzeit #${manager}Raus gesungen.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Die Fanklubs reden über einen Boykott des nächsten Heimspiels. Man kann es ihnen kaum verdenken.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Raus. Nicht mal mehr wütend. Einfach durch.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Foto von heute Abend: Reihen leerer Sitze und ein Bettlaken mit #${manager}Raus. Mehr Spielbericht braucht es nicht.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Wieder ausverkauft. Die beste Mannschaft seit Jahren, und das ganze Land weiß es.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Das nächste Heimspiel war in elf Minuten ausverkauft. Dieses Team hat uns die Wochenenden zurückgegeben.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Kein Platz mehr frei fürs nächste Heimspiel. Der Verband zählt die Zuschauereinnahmen mit einem Lächeln.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Wieder ausverkauft. Man kann über die Taktik sagen, was man will: Die Leute wollen ins Stadion.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Ausverkauft, schön. Dieselben Leute haben die Truppe vor anderthalb Jahren noch ausgepfiffen.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Plötzlich ausverkauft, plötzlich lauter Experten. Wo wart ihr alle, als wir gegen niemanden gewinnen konnten?';
  }

  @override
  String get campaignsIntro =>
      'Kampagnen sind handgemachte Herausforderungen: eine feste Nation, eine Welt mit eigener Wendung und ein Ziel, das in einer festen Zahl von Zyklen erreicht werden muss. Jeder Durchlauf bleibt von Ihren Karrierespielständen getrennt, und je weiter Sie kommen, desto mehr Sterne gibt es, bis zu drei.';

  @override
  String hubEventScandal(String player) {
    return 'Skandal im Trainingslager: $player';
  }

  @override
  String get hubEventScandalSub => 'Nach Hause schicken oder behalten?';

  @override
  String get scandalTitle => 'SKANDAL IM TRAININGSLAGER';

  @override
  String scandalStoryParty(String player) {
    return '$player war auf einer Party, die bis zum Morgengrauen ging, und am Morgen des Treffpunkts waren die Fotos in jeder Zeitung.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player hat die Sperrstunde gebrochen und wurde in den frühen Morgenstunden bei der Rückkehr ins Hotel erwischt.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player wurde am Vorabend des Lehrgangs in einem Nachtclub fotografiert, und die Bilder sind überall.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player verbrachte die Nacht vor dem Lehrgang am Casinotisch, und ein Boulevardblatt hat die Fotos.';
  }

  @override
  String get scandalSendHome => 'Nach Hause schicken';

  @override
  String scandalSendHomeCover(String player) {
    return 'Heimschicken, $player nachnominieren';
  }

  @override
  String scandalKeep(String player) {
    return '$player behalten';
  }

  @override
  String get scandalKeepNote =>
      'Behalten: Moral etwa -4 und Präsidium etwa -3 bis zum Ende des Zyklus.';

  @override
  String get scandalSendHomeNote =>
      'Heimschicken: keine Folgen für Moral oder Präsidium, und Sie dürfen einen Ersatz nachnominieren.';

  @override
  String get scandalFinalsNote =>
      'Heimschicken: keine Folgen für Moral oder Präsidium, aber bei einer Endrunde darf ihn niemand ersetzen.';

  @override
  String get scandalPickCover => 'Ersatz nachnominieren (optional)';

  @override
  String newsScandalTitle(String player) {
    return 'Skandal im Trainingslager: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Jungs sind eben Jungs. $player feiert am Abend vor dem Lehrgang, und ich will ihn trotzdem auf dem Platz sehen. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player wurde Stunden vor dem Treffpunkt auf einer Party bis in den Morgen fotografiert. Der Verband ist informiert. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Party bis zum Morgen vor dem Lehrgang. $player, was hast du dir dabei gedacht? Unfassbar. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Nach der Sperrstunde zurück, okay, kann passieren. $player muss es nur auf dem Platz wiedergutmachen. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player nach der Sperrstunde bei der Rückkehr ins Teamhotel erwischt, Stunden vor dem Training. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Sperrstunde ist nicht kompliziert. $player hat nicht mal eine Nacht durchgehalten. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Dann war $player eben im Club. Fußballer haben auch ein Leben. Lasst ihn spielen. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Fotos zeigen $player am Vorabend des Lehrgangs in einem Nachtclub. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Clubfotos am Vorabend des Lehrgangs. $player hat das Trikot blamiert. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Eine Nacht im Casino ist kein Verbrechen. $player kriegt das hin. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player in der Nacht vor dem Treffpunkt am Casinotisch gesichtet. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Die ganze Nacht im Casino vor dem Lehrgang. $player hat mehr verspielt als Geld. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Richtige Entscheidung. Niemand ist größer als die Mannschaft, auch $player nicht.';
  }

  @override
  String yScandalSentHome1(String player) {
    return '$player heimzuschicken war die einzige Antwort. Respekt an den Trainer.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Disziplin ist Disziplin. $player kannte die Regeln.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Ein klares Signal an den Kader: $player sitzt im Flieger nach Hause.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Hart für $player. Eine Nacht unterwegs, und der Lehrgang ist vorbei?';
  }

  @override
  String yScandalSentHome5(String player) {
    return '$player heimzuschicken schwächt uns. Das bezahlen wir auf dem Platz.';
  }

  @override
  String yScandalKept0(String player) {
    return '$player zu behalten ist ein Risiko. Das sollte er auf dem Platz zurückzahlen.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Na gut, $player bleibt. Dann schuldet er allen eine Leistung.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Für $player gelten die Regeln also nicht. Gut zu wissen.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Sperrstunde ist jetzt wohl freiwillig. Fragt $player.';
  }

  @override
  String yScandalKept4(String player) {
    return '$player nach so etwas behalten? Dieser Kader ist ein Ferienlager.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Die ganze Nacht feiern und dann direkt in die Startelf. Tolles Signal, Trainer. $player freut sich bestimmt.';
  }

  @override
  String get yStreamerBreaks0 =>
      'BRUDER WURDE ERWISCHT 😭😭 IN DER NACHT VOR DEM LEHRGANG?? ICH HEULE 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'NEEE CHAT SCHAUT EUCH DAS AN 🤯🤯 BRUDER HAT DAS WIRKLICH VOR DEM LEHRGANG GEMACHT 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'WER HAT IHN RAUSGELASSEN?? WER HAT IHN RAUSGELASSEN 😭😭💀 DAS IST KINO 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'NACH HAUSE?? NACH HAUSE!!! 😭😭😭 DER TRAINER MACHT KEINE WITZE 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'BRUDER PACKT LIVE SEINE KOFFER 🤯🤯 TSCHÜSS BRUDER 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'NIEMALSSS DIE HABEN IHN HEIMGESCHICKT 💀💀 CHAT ICH ZITTERE 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'ER BLEIBT??? ER BLEIIIBT 🤯🤯 BRUDER IST UNANTASTBAR 😭🔥';

  @override
  String get yStreamerKept1 =>
      'DIE GANZE NACHT PARTY UND IMMER NOCH IM KADER 💀💀 DEN VERTRAG WILL ICH AUCH 😭😭';

  @override
  String get yStreamerKept2 =>
      'DER TRAINER SAGT ALLES OKAY 😭😭 BRUDER WAS 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'Ich habe nichts bezahlt, und der Betrag stimmt auch nicht';

  @override
  String get yCameoHavir0 => 'Die kleinen Fische sind davongeschwommen.';

  @override
  String get yCameoHavir1 =>
      'Wir haben die Netze ausgeworfen, die Fische waren woanders.';

  @override
  String get yCameoHavir2 =>
      'Ich habe es schon im September beim Gulasch gesagt.';

  @override
  String get yCameoHavir3 =>
      'Wer nicht rechtzeitig gefischt hat, soll jetzt nicht weinen.';

  @override
  String get yCameoHavir4 =>
      'Wir haben gespielt wie ein Wels auf dem Trockenen.';

  @override
  String get yCameoHavir5 =>
      'Der Wind weht, der Teich friert zu. So ist das eben.';

  @override
  String get yCameoHavir6 =>
      'Manchmal zieht man nur einen alten Stiefel heraus.';

  @override
  String get yCameoHavir7 =>
      'Zu meiner Zeit wäre man wenigstens auf ein Bier gegangen. Heute nicht mal das.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Einen Jungen wegen einer Nacht heimschicken? Das ist der Skandal, nicht die Party!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Die Jungs dürfen doch mal Spaß haben! Die heuchlerischen Medien gewinnen wieder.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Das ist eine Hexenjagd. Ein junger Mann geht einmal aus, und ihr hängt ihn auf.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Wer von den Journalisten nie auf einer Party war, werfe den ersten Stein. Schande!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Der Trainer hat sich vor dem Boulevard gefürchtet. Ich hätte den Jungen bis zum letzten Atemzug verteidigt!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Endlich ein Trainer mit Rückgrat! Er hat den Jungen behalten, und die Medien können heulen.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Die Jungs dürfen doch mal Spaß haben, oder? Bravo, Trainer!';

  @override
  String get yCameoLzimberskyKept2 =>
      'Die heuchlerischen Medien schreien, der Trainer bleibt hart. So macht man das!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Eine Nacht unterwegs, und die Presse will ihn steinigen. Der Trainer ist ein echter Mann!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Ich sage: Lasst die Jungs leben! Wer hart arbeitet, darf auch feiern. Daumen hoch.';

  @override
  String get yTraitStreamer =>
      'Streamt alles, in voller Lautstärke, in Großbuchstaben.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Spieler des Jahres $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Die Stimmen sind ausgezählt';

  @override
  String get potyCeremonyWatch => 'Zeremonie ansehen';

  @override
  String get potyCeremonySkipToList => 'Direkt zu den Top 5';

  @override
  String get potyCeremonySkip => 'Überspringen';

  @override
  String get potyCeremonyIntro =>
      'Die Stimmen sind ausgezählt. Das sind die fünf besten Spieler der Welt in diesem Jahr.';

  @override
  String potyCeremonyPlace(int place) {
    return 'Platz $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'Und der Spieler des Jahres ist ...';

  @override
  String get potyTop5Heading => 'Die Top 5 der Welt';

  @override
  String get potyYoungTop3Heading => 'Bester junger Spieler: die Top 3';

  @override
  String get potySeeTop5 => 'Top 5 ansehen';

  @override
  String get potyYourPlayer => 'Ihr Spieler';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zu-null-Spiele',
      one: '1 Zu-null-Spiel',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Vollständiges Briefing';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Bisher verdiente Sterne: $earned von $total';
  }

  @override
  String get campaignStarEarned => 'Bisher verdient';

  @override
  String get campaignStarNotYet => 'Noch nicht verdient';

  @override
  String get stadiumsEntrySubClosed =>
      'Sieh dir deine Stadien an. Bauarbeiten sind erst zu Beginn des nächsten Zyklus wieder möglich.';

  @override
  String get boardObjectiveNoBrief => 'Kein Ziel gesetzt';

  @override
  String get boardObjectiveNoBriefBody =>
      'Das Präsidium erwartet nicht, dass du dieses Endturnier erreichst. Es misst dich stattdessen an deinen Ergebnissen.';

  @override
  String get boardObjectiveAwaitingDraw => 'Ziel nach der Auslosung';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Das Präsidium setzt dieses Ziel, sobald die Gruppen ausgelost sind.';
}
