// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get matchPreviewTitle => 'MECCSELŐZETES';

  @override
  String get matchKickOff => 'Kezdőrúgás';

  @override
  String get matchTactics => 'Taktika';

  @override
  String get matchYourXi => 'A KEZDŐCSAPATOD';

  @override
  String get matchHeadToHead => 'EGYMÁS ELLEN';

  @override
  String matchCouldNotLoad(String error) {
    return 'Nem sikerült betölteni a meccset.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Nincs soron következő meccs.';

  @override
  String get matchUnknownNation => 'Ismeretlen';

  @override
  String get matchH2hFirstMeeting => 'Első egymás elleni mérkőzés';

  @override
  String get matchH2hYouLead => 'Te vezetsz az egymás elleni mérlegben';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Előnyben: $opponent';
  }

  @override
  String get matchH2hEven => 'Kiegyenlített mérleg';

  @override
  String matchH2hMet(int count) {
    return '$count találkozó';
  }

  @override
  String get matchH2hWon => 'Nyert';

  @override
  String get matchH2hDrawn => 'Döntetlen';

  @override
  String get matchH2hLost => 'Vesztett';

  @override
  String get matchDossierTitle => 'Megfigyelői jelentés';

  @override
  String get matchDossierForm => 'FORMA';

  @override
  String get matchDossierNoGames => 'Nincs friss mérkőzés';

  @override
  String get matchDossierKeyMen => 'KULCSEMBEREK';

  @override
  String get matchDossierHowTheyPlay => 'JÁTÉKSTÍLUS';

  @override
  String matchScoutFormation1(String formation) {
    return 'Általában $formation felállásban játszanak.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'A megszokott felállásuk a $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Többnyire $formation felállásra építenek.';
  }

  @override
  String get matchScoutStrengthPressing =>
      'Magasan letámadnak, és vadásznak a labdára.';

  @override
  String get matchScoutStrengthDirect =>
      'Direkt futballt játszanak, és hamar előre juttatják a labdát.';

  @override
  String get matchScoutStrengthPossession =>
      'Jól tartják a labdát, és türelmesen építkeznek.';

  @override
  String get matchScoutStrengthCounter =>
      'Visszahúzódnak, és villámgyorsan kontráznak.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Mélyen védekeznek, és nehéz feltörni őket.';

  @override
  String get matchScoutStrengthWide =>
      'Szélesre húzzák a játékot, és a szárnyakon támadnak.';

  @override
  String get matchScoutStrengthAttacking =>
      'Szeretik magukhoz ragadni a kezdeményezést, és nekimenni az ellenfélnek.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'A támadóik gyorsak, és imádnak a védők mögé futni.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'A középpályájuk jól járatja a labdát.';

  @override
  String get matchScoutStrengthHardRunning =>
      'A középpályásaik az egész meccsen bírják a futást.';

  @override
  String get matchScoutStrengthSetPieces => 'Pontrúgásokból veszélyesek.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'A védelmük gyors, nehéz mögéjük kerülni.';

  @override
  String get matchScoutStrengthNone =>
      'A játékukban semmi sem emelkedik ki igazán.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'A magasan álló védelmük mögött hely marad egy hosszú labdának.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'A magas letámadás megzavarhatja a lassú építkezésüket.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Légy türelmes: egy ilyen mély blokkot szét lehet szedni.';

  @override
  String get matchScoutWeakLongBall =>
      'Húzd hátrébb a védelmedet, és a hosszú labdáik nem találnak teret.';

  @override
  String get matchScoutWeakSlowDefence =>
      'A védőik lassúak, ezért küldj futókat mögéjük.';

  @override
  String get matchScoutWeakAerial =>
      'Bizonytalannak tűnnek, amikor pontrúgást kell védekezniük.';

  @override
  String get matchScoutWeakPoorPassing =>
      'A középpályájuk nehezen passzolja ki magát a nyomásból.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'A középpályásaikból hiányzik az erő a letámadás fenntartásához.';

  @override
  String get matchScoutWeakBluntAttack => 'A támadóik lassúak.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Ellened várhatóan ők veszik kezükbe a kezdeményezést.';

  @override
  String get matchScoutApproachEven =>
      'Ellened szoros, kiegyenlített meccsre számíts.';

  @override
  String get matchScoutApproachSitDeep =>
      'Ellened várhatóan óvatosan játszanak, és a kontrára várnak.';

  @override
  String get matchScoutLeaningAttacking =>
      'Messziről nézve támadó szellemű csapatnak tűnnek.';

  @override
  String get matchScoutLeaningCautious =>
      'Messziről nézve óvatos csapatnak tűnnek.';

  @override
  String get matchScoutLeaningUnclear =>
      'Messziről nehéz megmondani, hogyan szeretnek játszani.';

  @override
  String get matchScoutHireHint =>
      'Szerződtess vezető megfigyelőt, hogy megtudd, hogyan játszanak.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Nem sikerült folytatni: $error';
  }

  @override
  String get matchSkipToFullTime => 'Ugrás a lefújásig';

  @override
  String get matchStatShots => 'Lövések';

  @override
  String get matchStatGoals => 'Gólok';

  @override
  String get matchStatYellowCards => 'Sárgák';

  @override
  String get matchStatRedCards => 'Pirosak';

  @override
  String get matchMomentum => 'LENDÜLET';

  @override
  String get matchSwingAtk => 'TÁM';

  @override
  String get matchSwingDef => 'VÉD';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'VILÁGBAJNOKSÁG $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'ITT A DÖNTŐ TORNÁJA';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'RENDEZŐ:  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'A RENDEZŐ MÉG NEM DŐLT EL';

  @override
  String get matchHalfTime => 'FÉLIDŐ';

  @override
  String get matchContinue => 'Tovább';

  @override
  String get matchContinuing => 'Folytatás…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktika · $used/$max csere';
  }

  @override
  String matchTiredCount(int count) {
    return 'FÁRADT ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIKA';

  @override
  String get teamOverallOverTime => 'ÖSSZÉRTÉKELÉS IDŐBEN';

  @override
  String get teamOverall => 'Összértékelés';

  @override
  String get teamTalkHeading => 'CSAPATBESZÉD';

  @override
  String get teamTalkPrompt => 'Add meg a második félidő alaphangját.';

  @override
  String get teamTalkCalmLabel => 'Hideg fej';

  @override
  String get teamTalkCalmBlurb =>
      'Nyugtasd meg a csapatot. Kis általános lendület.';

  @override
  String get teamTalkEncourageLabel => 'Bátorítás';

  @override
  String get teamTalkEncourageBlurb => 'Előre! Menjetek a győzelemre.';

  @override
  String get teamTalkDemandMoreLabel => 'Követelj többet';

  @override
  String get teamTalkDemandMoreBlurb =>
      'Dobjatok be mindent. Támadjatok keményen.';

  @override
  String get teamTalkPraiseLabel => 'Tartsátok szorosan';

  @override
  String get teamTalkPraiseBlurb => 'Maradjatok kompaktak, védjétek az előnyt.';

  @override
  String get teamTalkBelieveLabel => 'Higgyetek magatokban';

  @override
  String get teamTalkBelieveBlurb =>
      'Bízzatok magatokban. Lendület mindkét kapunál.';

  @override
  String get teamTalkFocusLabel => 'Maradjatok résen';

  @override
  String get teamTalkFocusBlurb =>
      'Teljes koncentráció. Zárjátok le a meccset.';

  @override
  String get teamTalkUrgencyLabel => 'Sürgetés';

  @override
  String get teamTalkUrgencyBlurb =>
      'Hajtsatok most. Mindent bele, de lyukak maradnak hátul.';

  @override
  String get teamTalkReassureLabel => 'Semmi nyomás';

  @override
  String get teamTalkReassureBlurb =>
      'Oldjátok a görcsöt, tartsátok a felállást.';

  @override
  String get commonRetry => 'Újra';

  @override
  String get commonSomethingWentWrong => 'Valami elromlott';

  @override
  String get commonCrashBox =>
      'Itt valami elromlott.\nA Beállítások → Diagnosztika részletezi.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Nem sikerült léptetni a világot: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnosztika';

  @override
  String get settingsDiagnosticsBlurb =>
      'Az ezen az eszközön rögzített hibák. Semmi sem kerül elküldésre.';

  @override
  String get settingsContactTitle => 'Kapcsolat';

  @override
  String get settingsContactCopied => 'Cím kimásolva.';

  @override
  String get settingsCommunityTitle => 'Közösség';

  @override
  String get settingsDiscordSubtitle => 'Csatlakozz a közösséghez';

  @override
  String get settingsLinkCopied => 'Link kimásolva.';

  @override
  String get diagnosticsEmpty => 'Nincs rögzített hiba. Ez a cél.';

  @override
  String get diagnosticsCopy => 'Másolás';

  @override
  String get diagnosticsCopied => 'A napló a vágólapra került.';

  @override
  String get diagnosticsClear => 'Törlés';

  @override
  String get navHub => 'Főoldal';

  @override
  String get navSquad => 'Keret';

  @override
  String get navStandings => 'Tabella';

  @override
  String get navCareers => 'Karrierem';

  @override
  String get settingsTitle => 'BEÁLLÍTÁSOK';

  @override
  String get settingsSoundHapticsTitle => 'Hang és rezgés';

  @override
  String get settingsSoundHapticsBlurb =>
      'Rezgés és rövid hang gólnál, kezdőrúgásnál és lefújáskor.';

  @override
  String get settingsLanguageTitle => 'Nyelv';

  @override
  String get settingsLanguageBlurb =>
      'Válaszd ki az app nyelvét, vagy kövesd az eszközét.';

  @override
  String get settingsLanguageSystem => 'Rendszer';

  @override
  String get settingsTextSizeTitle => 'Szövegméret';

  @override
  String get settingsTextSizeBlurb =>
      'Nagyítsa a szöveget, ha nehezen olvasható.';

  @override
  String get settingsTextSizeNormal => 'Normál';

  @override
  String get settingsTextSizeLarge => 'Nagy';

  @override
  String get settingsTextSizeLarger => 'Nagyobb';

  @override
  String get matchPreviewAllMeetings => 'Összes találkozó';

  @override
  String get recordsMeetings => 'TALÁLKOZÓK';

  @override
  String get recordsLegends => 'LEGENDÁK';

  @override
  String get recordsAllTimeXi => 'MINDEN IDŐK CSAPATA';

  @override
  String get recordsHallOfFame => 'HALL OF FAME';

  @override
  String get recordsAllTimeWorld => 'MINDEN IDŐK, VILÁG';

  @override
  String get recordsAllTimeTopScorers => 'MINDEN IDŐK GÓLKIRÁLYAI';

  @override
  String get recordsMostCapped => 'LEGTÖBB VÁLOGATOTTSÁG';

  @override
  String get recordsMostWcStarts => 'LEGTÖBB VB-KEZDÉS';

  @override
  String get recordsMostTournaments => 'LEGTÖBB TORNA';

  @override
  String get recordsRecordBook => 'REKORDOK KÖNYVE';

  @override
  String get recordsHeadToHead => 'EGYMÁS ELLEN';

  @override
  String get recordsFiercestRival => 'LEGKEMÉNYEBB RIVÁLIS';

  @override
  String get recordsMostCaps => 'LEGTÖBB VÁLOGATOTTSÁG';

  @override
  String get recordsTopScorers => 'GÓLKIRÁLYOK';

  @override
  String get recordsMostAssists => 'LEGTÖBB GÓLPASSZ';

  @override
  String get recordsYourRecord => 'A TE MÉRLEGED';

  @override
  String get callUpHome => 'HAZAI';

  @override
  String get callUpAway => 'VENDÉG';

  @override
  String get recordsHome => 'HAZAI';

  @override
  String get recordsAway => 'VENDÉG';

  @override
  String get recordsActive => 'AKTÍV';

  @override
  String get recordsStillActive => 'Még aktív';

  @override
  String get recordsAvg => 'átl.';

  @override
  String get recordsSelect => 'Válassz';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Döntetlen';

  @override
  String get recordsGoalsLabel => 'Gólok';

  @override
  String get recordsBestFinish => 'Legjobb helyezés';

  @override
  String get recordsNoFinalsYet => 'Még nem jutott döntő tornára';

  @override
  String get recordsLongestUnbeaten => 'Leghosszabb veretlenség';

  @override
  String get recordsBiggestWin => 'Legnagyobb győzelem';

  @override
  String get recordsSeeAllMeetings => 'Összes találkozó';

  @override
  String get recordsSaveNotFound => 'A mentés nem található.';

  @override
  String get recordsNoMatches => 'Nincs találat.';

  @override
  String get recordsSearchPlayerOrNation => 'Játékos vagy ország keresése';

  @override
  String get recordsSearchNation => 'Ország keresése';

  @override
  String get recordsPickTwoDifferent => 'Válassz két különböző országot.';

  @override
  String get recordsPlayToBuildRecord =>
      'Játssz néhány meccset, és itt épül fel a mérleged minden ellenféllel szemben.';

  @override
  String get recordsTapOpponent =>
      'Koppints egy ellenfélre a teljes részletezésért.';

  @override
  String get recordsEdgeUpperHand => 'Te vagy fölényben';

  @override
  String get recordsEdgeTheirNumber => 'Ők a mumusod';

  @override
  String get recordsEdgeEven => 'Kiegyenlített mérleg';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Globális góllövők és válogatottsági rekorderek, minden ország';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Hasonlíts össze bármely két ország örökmérlegét';

  @override
  String get recordsLegendsSubtitle => 'Minden idők csapata és Hall of Fame';

  @override
  String get recordsUnitGoals => 'gól';

  @override
  String get recordsUnitCaps => 'válogatottság';

  @override
  String get recordsUnitStarts => 'kezdés';

  @override
  String get recordsUnitCups => 'torna';

  @override
  String get recordsUnitAssists => 'gólpassz';

  @override
  String recordsCapsCount(int count) {
    return '$count válogatottság';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count gól';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count gólpassz';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count ME';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count mérkőzés';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count találkozó';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code győzelmei';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings találkozó · ${wins}GY ${draws}D ${losses}V';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}GY ${draws}D ${losses}V';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings találkozó · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a és $b még nem találkozott ebben a mentésben.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Kiállítva: $names. Nincs csere, így emberhátrányban játszol.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Kell $required elérhető játékos ($have egészséges)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Kihagy: $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Az egész meghívás alatt kiesett';

  @override
  String get rankingCentreOnMe => 'Az én országomra';

  @override
  String get recordsAfterExtraTime => 'h. u.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b 11-esekkel';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played mérkőzés · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga, ellenfél: $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Nem sikerült betölteni.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Nem sikerült betölteni a legendákat.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Nem sikerült betölteni a rekordokat.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Nem sikerült betölteni az országokat.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Nem sikerült betölteni a mérlegedet.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Nem sikerült betölteni a mérleget.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Még nincsenek legendák. Játssz le néhány kampányt, és itt jelennek meg $nation nagyjai.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'A valaha kiállítható legjobb csapat: $nation.';
  }

  @override
  String get recordsNoWorldHistory =>
      'A világnak még nincs története. Játssz le néhány kampányt, és itt jelennek meg a minden idők legnagyjai.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Játssz néhány meccset, hogy megkezdődjön $nation történetének megírása.';
  }

  @override
  String get tacticsLineGk => 'K';

  @override
  String get tacticsLineDef => 'V';

  @override
  String get tacticsLineMid => 'KP';

  @override
  String get tacticsLineFwd => 'CS';

  @override
  String get tacticsGoalkeepers => 'KAPUSOK';

  @override
  String get tacticsDefenders => 'VÉDŐK';

  @override
  String get tacticsMidfielders => 'KÖZÉPPÁLYÁSOK';

  @override
  String get tacticsForwards => 'CSATÁROK';

  @override
  String get tacticsCallUpsTitle => 'MEGHÍVÓK';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Legalább $min játékost válassz.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Nem sikerült betölteni a keretet.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Nincs keret.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'KERET · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min. $min · Max. $max';
  }

  @override
  String get tacticsBestQuality => 'Legjobb minőség';

  @override
  String get tacticsPreviousSquad => 'Előző keret';

  @override
  String get tacticsSquadLockedBack => 'Vissza (keret zárolva)';

  @override
  String get tacticsConfirmSquad => 'Keret beadása';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Betelt a keret (max. $max)';
  }

  @override
  String get tacticsSquadLocked => 'KERET ZÁROLVA';

  @override
  String get tacticsNominationOpen => 'NYITOTT A KERETLEADÁS. VÁLASSZ KERETET';

  @override
  String get tacticsSquadFixedBlurb =>
      'Ez a keret rögzített az alábbi meccsekre. A következő keretleadás előtt válassz újra.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Ez a keret játssza az alábbi meccseket.';

  @override
  String get tacticsUnknown => 'Ismeretlen';

  @override
  String tacticsAgeValue(int age, String value) {
    return '$age éves · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Kimerült';

  @override
  String get tacticsFatigueTired => 'Fáradt';

  @override
  String get tacticsFatigueMatchLegs => 'Meccsfáradtság';

  @override
  String tacticsTooManySubs(int max) {
    return 'Túl sok csere (max. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIKA · $minute\'';
  }

  @override
  String get tacticsApply => 'ALKALMAZ';

  @override
  String get tacticsTabLineupSubs => 'FELÁLLÁS ÉS CSERÉK';

  @override
  String get tacticsTabTactics => 'TAKTIKA';

  @override
  String get squadLineKeepers => 'KAPUSOK';

  @override
  String get squadLineDefenders => 'VÉDELEM';

  @override
  String get squadLineMidfielders => 'KÖZÉPPÁLYA';

  @override
  String get squadLineForwards => 'TÁMADÁS';

  @override
  String get squadStatXiRating => 'Kezdő értékelése';

  @override
  String get squadStatAvgAge => 'Átl. kor';

  @override
  String get squadStatSize => 'Keret';

  @override
  String get squadStatUnavailable => 'Kiesett';

  @override
  String get squadDepthTitle => 'MÉLYSÉG SORONKÉNT';

  @override
  String squadAgeShort(int age) {
    return '$age é.';
  }

  @override
  String get tacticsTabOtherPositions => 'MÁS POSZTOK';

  @override
  String get tacticsOutOfPositionNote => 'Itt nem a posztján van';

  @override
  String get tacticsNobodyElse => 'Itt már senki más nem jöhet szóba.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Válaszd ki, ki megy le, és itt jelenik meg a pad többi tagja azzal az értékeléssel, amellyel ezt a posztot játszanák.';

  @override
  String get tacticsTabSuitable => 'MEGFELELŐ';

  @override
  String get tacticsTabOnPitch => 'A PÁLYÁN';

  @override
  String tacticsSectionSuitable(int count) {
    return 'MEGFELELŐ · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'A padon senki sem való természetesen erre a posztra, ezért itt mindenki szerepel.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'A PÁLYÁN · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'ELÉRHETŐ · $count';
  }

  @override
  String get tacticsRowStarted => 'Kezdő';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Beállt: $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Beállt';

  @override
  String get tacticsEnergyLabel => 'ENERGIA';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Koppints a cserére ($name helyére), vagy koppints rá még egyszer a visszavonáshoz.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'A piros lap miatt elveszett ez a hely. Húzz ide egy csapattársat, hogy áthelyezd a lyukat.';

  @override
  String get tacticsSentOffShort => 'KIÁLLÍTVA';

  @override
  String get tacticsFullBackLeft => 'Bal hátvéd';

  @override
  String get tacticsFullBackRight => 'Jobb hátvéd';

  @override
  String get tacticsFullBackUp => 'Felfut';

  @override
  String get tacticsFullBackDown => 'Hátul marad';

  @override
  String get tacticsFullBackOff => 'Nincs utasítás';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: felfut. Kicsit több támadás, kicsit több kockázat.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: hátul marad. Kicsit biztonságosabb, kicsit kevesebb támadás.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: nincs utasítás, a csapat terve szerint játszik.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, nyíl: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'CSERÉK · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Koppints egy pályán lévő játékosra a lecseréléséhez, vagy tartsd nyomva és húzz rá egy cserejátékost.';

  @override
  String get tacticsNoSubs => 'Nincs elérhető cserejátékos.';

  @override
  String get tacticsChooseShape => 'VÁLASSZ FELÁLLÁST';

  @override
  String get tacticsFormation => 'FELÁLLÁS';

  @override
  String get tacticsInstructions => 'UTASÍTÁSOK';

  @override
  String get tacticsDrilling => 'GYAKORLOTTSÁG';

  @override
  String get tacticsDrillingUnplayed => 'NEM JÁTSZOTT';

  @override
  String get tacticsDrillingNew => 'ÚJ';

  @override
  String get tacticsDrillingSettling => 'BEÁLLÓBAN';

  @override
  String get tacticsDrillingDrilled => 'BEGYAKOROLT';

  @override
  String get tacticsInstrMentality => 'Mentalitás';

  @override
  String get tacticsInstrDefensive => 'Védekező';

  @override
  String get tacticsInstrAttacking => 'Támadó';

  @override
  String get tacticsInstrPressing => 'Letámadás';

  @override
  String get tacticsInstrLowBlock => 'Mély blokk';

  @override
  String get tacticsInstrHighPress => 'Magas letámadás';

  @override
  String get tacticsInstrTempo => 'Tempó';

  @override
  String get tacticsInstrPatient => 'Türelmes';

  @override
  String get tacticsInstrFast => 'Gyors';

  @override
  String get tacticsInstrWidth => 'Szélesség';

  @override
  String get tacticsInstrNarrow => 'Szűk';

  @override
  String get tacticsInstrWide => 'Széles';

  @override
  String get tacticsInstrDefLine => 'Véd. vonal';

  @override
  String get tacticsInstrDefensiveLine => 'Védővonal';

  @override
  String get tacticsInstrDeep => 'Mély';

  @override
  String get tacticsInstrHigh => 'Magas';

  @override
  String get tacticsInstrDirectness => 'Direktség';

  @override
  String get tacticsInstrPossession => 'Labdabirtoklás';

  @override
  String get tacticsInstrDirect => 'Direkt';

  @override
  String get tacticsPickGoalkeeper => 'VÁLASSZ KAPUST';

  @override
  String get tacticsPickLeftBack => 'VÁLASSZ BAL OLDALI VÉDŐT';

  @override
  String get tacticsPickCentreBack => 'VÁLASSZ BELSŐ VÉDŐT';

  @override
  String get tacticsPickRightBack => 'VÁLASSZ JOBB OLDALI VÉDŐT';

  @override
  String get tacticsPickDefensiveMid => 'VÁLASSZ VÉDEKEZŐ KÖZÉPPÁLYÁST';

  @override
  String get tacticsPickCentralMid => 'VÁLASSZ KÖZÉPSŐ KÖZÉPPÁLYÁST';

  @override
  String get tacticsPickAttackingMid => 'VÁLASSZ TÁMADÓ KÖZÉPPÁLYÁST';

  @override
  String get tacticsPickLeftMid => 'VÁLASSZ BAL KÖZÉPPÁLYÁST';

  @override
  String get tacticsPickRightMid => 'VÁLASSZ JOBB KÖZÉPPÁLYÁST';

  @override
  String get tacticsPickLeftWing => 'VÁLASSZ BAL SZÉLSŐT';

  @override
  String get tacticsPickRightWing => 'VÁLASSZ JOBB SZÉLSŐT';

  @override
  String get tacticsPickStriker => 'VÁLASSZ CSATÁRT';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · nem a posztján';
  }

  @override
  String tacticsAgeOnly(int age) {
    return '$age éves';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · $age éves';
  }

  @override
  String get tacticsOn => 'PÁLYÁN';

  @override
  String get tacticsSquad => 'KERET';

  @override
  String get tacticsTabLineup => 'FELÁLLÁS';

  @override
  String get tacticsTabInstructions => 'UTASÍTÁSOK';

  @override
  String get tacticsTabRoles => 'SZEREPEK';

  @override
  String get tacticsTabSetPieces => 'PONTRÚGÁSOK';

  @override
  String get tacticsTabRolesSetPieces => 'SZEREPEK ÉS PONTRÚGÁSOK';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Adj minden kezdőnek szerepet. Koppints a tizenegyes (⚽) vagy szabadrúgás (▲) jelvényre a rúgó kijelöléséhez.';

  @override
  String get tacticsTooltipCallUps => 'Meghívók';

  @override
  String get tacticsTooltipPresets => 'Taktikai sablonok';

  @override
  String get tacticsTooltipInstructions => 'Utasítások';

  @override
  String get tacticsNoTacticSet => 'Nincs beállított taktika.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'CSERÉLJ LE $count KEZDŐT',
      one: 'CSERÉLJ LE $count KEZDŐT',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Kiesett';

  @override
  String get tacticsTapSpotReplace =>
      'Koppints a helyére a pályán a csere kiválasztásához.';

  @override
  String get tacticsTapOrDrag =>
      'Koppints egy játékosra a lecseréléséhez, vagy tartsd nyomva és húzd át máshová.';

  @override
  String get tacticsPlayerRoles => 'JÁTÉKOSSZEREPEK';

  @override
  String get tacticsRolesBlurb =>
      'Adj a játékosnak feladatot: gólvadász, irányító, targetman. Ez alakítja, ki szerez gólt és ki készít elő.';

  @override
  String get tacticsSetPieceTakers => 'PONTRÚGÓK';

  @override
  String get tacticsSetPieceBlurb =>
      'Ki rúgja a tizenegyest és a pontrúgásokat, vagy bízd a legalkalmasabbra.';

  @override
  String get tacticsTakerAuto => 'Automatikus';

  @override
  String get tacticsTakerQuickPick => 'Legjobb rúgók';

  @override
  String get tacticsPenalties => 'Tizenegyesek';

  @override
  String get tacticsCornersFreeKicks => 'Szögletek és szabadrúgások';

  @override
  String get tacticsSkillFin => 'BEF';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'SZEREP · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'TIZENEGYES-RÚGÓ';

  @override
  String get tacticsCornerFreeKickTaker => 'SZÖGLET- ÉS SZABADRÚGÁS-RÚGÓ';

  @override
  String get tacticsAutomatic => 'Automatikus';

  @override
  String get tacticsLetBestSuited => 'A legalkalmasabb játékos rúgja.';

  @override
  String get tacticsInXi => 'KEZDŐBEN';

  @override
  String get tacticsTeamInstructions => 'CSAPATUTASÍTÁSOK';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Add meg, hogyan játsszon a csapatod. Minden tárcsa az egész csapatot befolyásolja.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Mentve: „$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Alkalmazva: „$name”';
  }

  @override
  String get tacticsTacticPresets => 'TAKTIKAI SABLONOK';

  @override
  String get tacticsPresetsBlurb =>
      'Mentsd el ezt a felállást újrahasználható stílusként, vagy alkalmazz egy korábban mentettet.';

  @override
  String get tacticsSaveCurrentTactic => 'Jelenlegi taktika mentése';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Nem sikerült betölteni a sablonokat.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Még nincs sablon. Koppints a „Jelenlegi taktika mentése” gombra, hogy újrahasználható stílusként eltárold ezt a beállítást.';

  @override
  String get tacticsNameThisTactic => 'Nevezd el a taktikát';

  @override
  String get tacticsNameHint => 'pl. Magas letámadás 4-3-3';

  @override
  String get tacticsCancel => 'Mégse';

  @override
  String get tacticsSave => 'Mentés';

  @override
  String get tacticsTapToAssign => 'Koppints a kijelöléshez';

  @override
  String get tacticsHoldDragSub =>
      'Tartsd nyomva a cserejátékost, majd húzd egy játékosra, hogy beálljon helyette.';

  @override
  String get hubContinue => 'Tovább';

  @override
  String get hubBrackets => 'Ágrajz';

  @override
  String hubCouldNotLoad(String error) {
    return 'Nem sikerült betölteni.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Nem sikerült betölteni a pénzügyeket.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Nem sikerült betölteni a mentést.\n$error';
  }

  @override
  String get hubSaveNotFound => 'A mentés nem található.';

  @override
  String get hubUnknown => 'Ismeretlen';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year VILÁGBAJNOKAI';
  }

  @override
  String get hubCycleComplete => 'A ciklus véget ért.';

  @override
  String get hubYourJob => 'A MUNKÁD';

  @override
  String get hubStayProject => 'Maradsz, és folytatod a projektet';

  @override
  String get hubChooseNextJob => 'VÁLASZD KI A KÖVETKEZŐ MUNKÁD';

  @override
  String get hubOffersOnTable => 'AJÁNLATOK AZ ASZTALON';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · világ #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Folytatás: $nation';
  }

  @override
  String get hubYourNation => 'az országod';

  @override
  String get hubTakeTheJob => 'Elvállalom';

  @override
  String get hubFederationFinances => 'SZÖVETSÉGI PÉNZÜGYEK';

  @override
  String get hubBudgetIntro =>
      'A következő ciklus első feladata a szövetségi költségvetés megadása és felosztása a részlegek között.';

  @override
  String get hubStarting => 'Indítás…';

  @override
  String get hubBeginNextCycle => 'Következő ciklus indítása';

  @override
  String get hubContinueCareer => 'Karrier folytatása';

  @override
  String get hubBackToSaves => 'Vissza a mentésekhez';

  @override
  String get hubOpeningBalance => 'Nyitó egyenleg';

  @override
  String get hubCentralFunding => 'Központi támogatás';

  @override
  String get hubPrizeMoney => 'Pénzdíj';

  @override
  String get hubCommercialReturn => 'Kereskedelmi hozam';

  @override
  String get hubAvailableToInvest => 'Befektethető összeg';

  @override
  String hubReputation(String label, int rep) {
    return 'Hírnév: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Nemzeti hős';

  @override
  String get hubFinal => 'Döntő';

  @override
  String get hubStageRoundOf32 => 'Legjobb 32';

  @override
  String get hubStageThirdPlace => 'Bronzmérkőzés';

  @override
  String get hubEventAdvanceWorld => 'A világ léptetése';

  @override
  String hubEventStartCycle(int year) {
    return '$year ciklus indítása';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Világbajnok: $nation';
  }

  @override
  String get hubEventSetBudget => 'Add meg a szövetségi költségvetést';

  @override
  String get hubEventSetBudgetSub =>
      'Oszd fel a ciklus keretét a szezon kezdete előtt';

  @override
  String get hubEventNaturalization => 'Honosítási ajánlat elbírálása';

  @override
  String get hubEventNaturalizationSub =>
      'Egy külföldi játékos a te válogatottadban szeretne játszani';

  @override
  String get hubEventCampaignVerdict =>
      'A kampány lezárult: lásd az értékelést';

  @override
  String get hubEventCampaignComplete => 'Kampány befejezve';

  @override
  String get hubEventIntercontinentalPlayoff =>
      'A kontinensek közötti pótselejtező';

  @override
  String get hubEventWatchWcDraw =>
      'A világbajnokság sorsolásának megtekintése';

  @override
  String get hubEventWorldCupHere => 'Itt a világbajnokság';

  @override
  String get hubEventWatchFinalsDraw => 'A döntő tornájának sorsolása';

  @override
  String get hubEventFinalsHere => 'Itt a döntő tornája';

  @override
  String get hubEventPlayWcRound => 'A világbajnokság következő fordulója';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Következő meccs: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch => 'A Nations Cup következő meccse';

  @override
  String get hubEventWatchNationsCupDraw =>
      'A Nations Cup sorsolásának megtekintése';

  @override
  String get hubEventWatchHostSelection =>
      'A rendező kiválasztásának megtekintése';

  @override
  String get hubEventWatchQualifyingDraw => 'A selejtezősorsolás megtekintése';

  @override
  String get hubEventWatchWcHostSelection =>
      'A vb-rendező kiválasztásának megtekintése';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'A vb-selejtezők sorsolásának megtekintése';

  @override
  String get hubEventArrangeFriendlies => 'Barátságos meccsek szervezése';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Még nem töltötted fel mind a(z) $count nyitott barátságos időpontot',
      one: 'Még nem töltötted fel a nyitott barátságos időpontot',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Alakítsd át a kezdőcsapatot';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'A kezdők közül $count kiesett (eltiltva vagy sérült). Válassz helyettük másokat',
      one:
          'A kezdők közül 1 kiesett (eltiltva vagy sérült). Válassz helyette másikat',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hiányos a kezdőcsapat. Töltsd fel az üres helyeket ($count)',
      one: 'Hiányos a kezdőcsapat. Töltsd fel az üres helyet ($count)',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Ellenfél: $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'a kontinentális döntő';

  @override
  String get hubCallUpFriendlies => 'Add le a keretet a barátságos meccsekre';

  @override
  String get hubCallUpRequalify => 'Add le újra a selejtezőkeretet';

  @override
  String get hubCallUpWorldCup => 'Add le a világbajnoki keretet';

  @override
  String get hubCallUpFinals => 'Add le a keretet a döntő tornájára';

  @override
  String get hubCallUpNationsCup => 'Add le a Nations Cup-keretet';

  @override
  String get hubCallUpQualifying => 'Add le a selejtezőkeretet';

  @override
  String get hubCallUpGeneric => 'Add le a keretet';

  @override
  String get hubHost => 'Rendező';

  @override
  String get hubGoldenBoot => 'Aranycipő';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals gól';
  }

  @override
  String get hubPens => '(11-esekkel)';

  @override
  String get hubNationalHub => 'SZÖVETSÉGI IRODA';

  @override
  String get hubMessages => 'Üzenetek';

  @override
  String get hubWorldChampions => 'VILÁGBAJNOKOK';

  @override
  String get hubViewBracket => 'Ágrajz megtekintése ›';

  @override
  String get hubBoardDelighted => 'Elragadtatva';

  @override
  String get hubBoardPleased => 'Elégedett';

  @override
  String get hubBoardExpectingMore => 'Többet vár';

  @override
  String get hubBoardConcerned => 'Aggódik';

  @override
  String get hubBoardJobAtRisk => 'Veszélyben a munkád';

  @override
  String get hubBoard => 'VEZETŐSÉG';

  @override
  String hubBoardObjective(String label) {
    return 'Vezetőségi cél: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'TELJESÍTVE · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'NEM TELJESÜLT · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Ebben a ciklusban nincs több mérkőzés.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Világranglista';

  @override
  String get hubSquadStatus => 'KERET ÁLLAPOTA';

  @override
  String hubPlayers(int count) {
    return '$count játékos';
  }

  @override
  String get hubAvgRating => 'Átl. értékelés';

  @override
  String get hubMorale => 'Morál';

  @override
  String get hubManageTeam => 'Csapatkezelés';

  @override
  String get hubGroupsToBeDrawn =>
      'A csoportok még nincsenek kisorsolva. Nézd meg a sorsolást a felfedésükhöz.';

  @override
  String hubGroupName(String name) {
    return '$name CSOPORT';
  }

  @override
  String get hubTblTeam => 'CSAPAT';

  @override
  String get hubTblP => 'M';

  @override
  String get hubTblGd => '+/-';

  @override
  String get hubTblPts => 'P';

  @override
  String get homeSettings => 'Beállítások';

  @override
  String get homeLeadTheNation => 'VEZESD AZ ORSZÁGOT';

  @override
  String get homeYourNation => 'az országod';

  @override
  String get homeNewGame => 'Új játék';

  @override
  String get homeAllSaves => 'Összes mentés';

  @override
  String get homeLoadGame => 'Játék betöltése';

  @override
  String get homeContinue => 'FOLYTATÁS';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Út a $year. évi világbajnokságra';
  }

  @override
  String get careerManageSaves => 'Mentések kezelése';

  @override
  String get careerNewGameTitle => 'ÚJ JÁTÉK';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Nem sikerült betölteni az országot.\n$error';
  }

  @override
  String get careerNationNotFound => 'Az ország nem található.';

  @override
  String careerWorldRankNum(int rank) {
    return 'VILÁGRANGLISTA #$rank';
  }

  @override
  String get careerManagerName => 'Kapitány neve';

  @override
  String get careerManagerNameHint => 'pl. Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'A karriered 2026 szeptemberében indul, a 2030-as világbajnokság felé vezető úton.';

  @override
  String get careerFreeCycleNote =>
      'Egy teljes négyéves cikluson át ingyenes: selejtezők, a kontinentális bajnokságod és a világbajnokság, két mentéssel. Utána egyetlen vásárlással feloldhatod a végtelen ciklusokat.';

  @override
  String get careerStartCareer => 'Karrier indítása';

  @override
  String get careersTitle => 'KARRIEREK';

  @override
  String get careerManagerCareer => 'Kapitányi karrier';

  @override
  String get careerManagerCareerSubtitle =>
      'Minden ciklus, amit irányítottál, és az összesített mérleged';

  @override
  String get careerSummaryTitle => 'Karrier-összegzés';

  @override
  String get careerSummarySubtitle => 'A trófeatermed és a kapitányi mérleged';

  @override
  String get careerAchievements => 'Eredmények';

  @override
  String get careerAchievementsSubtitle =>
      'Mérföldkövek, címek és a vezetőség elégedettsége';

  @override
  String get careerChallenges => 'Kihívások';

  @override
  String get careerChallengesSubtitle =>
      'Kíméletlen, egész karriert átfogó próbák';

  @override
  String get careerTeamRecords => 'Csapatrekordok';

  @override
  String get careerTeamRecordsSubtitle =>
      'Minden idők gólkirályai és legtöbbszörös válogatottjai';

  @override
  String get careerMyMatches => 'Mérkőzéseim';

  @override
  String get careerMyMatchesSubtitle =>
      'Minden eredmény és soron következő mérkőzés';

  @override
  String get careerTitle => 'KARRIER';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'A karrier nem tölthető be.\n$error';
  }

  @override
  String get careerNoCareer => 'Nincs karrier.';

  @override
  String get careerTrophyCabinet => 'TRÓFEATEREM';

  @override
  String get careerTournamentHistory => 'TORNATÖRTÉNET';

  @override
  String get careerNoTournamentsYet => 'Még nem fejeződött be torna.';

  @override
  String get careerTeamFallback => 'Csapat';

  @override
  String careerWorldNum(int rank) {
    return 'VILÁG #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PONT';
  }

  @override
  String careerSeasonNum(int season) {
    return '$season. SZEZON';
  }

  @override
  String get careerStatPlayedShort => 'M';

  @override
  String get careerStatsHeading => 'SZÁMOKBAN';

  @override
  String get careerStatsWinRate => 'Győzelmi arány';

  @override
  String get careerStatsGoalsFor => 'Lőtt gól';

  @override
  String get careerStatsGoalsAgainst => 'Kapott gól';

  @override
  String get careerStatsGoalDiff => 'Gólkülönbség';

  @override
  String get careerStatsCleanSheets => 'Kapott gól nélkül';

  @override
  String get careerStatsBiggestWin => 'Legnagyobb győzelem';

  @override
  String get careerStatsWinStreak => 'Győzelmi sorozat';

  @override
  String get careerStatsUnbeaten => 'Veretlenségi sorozat';

  @override
  String get careerStatsShootouts => 'Tizenegyespárbaj';

  @override
  String get careerStatsHatTricks => 'Mesterhármasok';

  @override
  String get careerStatsMotms => 'A mérkőzés embere';

  @override
  String get careerStatsBestRating => 'Legjobb értékelés';

  @override
  String get careerStatWonShort => 'GY';

  @override
  String get careerStatDrawnShort => 'D';

  @override
  String get careerStatLostShort => 'V';

  @override
  String get careerStatGoalsForShort => 'LG';

  @override
  String get careerStatGoalsAgainstShort => 'KG';

  @override
  String get careerStatGoalDiffShort => 'GK';

  @override
  String get careerNoSilverware => 'Még nincs trófea. Szerezz egyet!';

  @override
  String get careerMedalGold => 'ARANY';

  @override
  String get careerMedalSilver => 'EZÜST';

  @override
  String get careerMedalBronze => 'BRONZ';

  @override
  String careerWinnersName(String name) {
    return 'Győztes: $name';
  }

  @override
  String get careerSavesTitle => 'MENTÉSEK';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'A mentések nem tölthetők be.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'HELYEK  $used/$limit';
  }

  @override
  String get careerThisSave => 'ez a mentés';

  @override
  String get careerSlotsFull => 'Betelt a hely';

  @override
  String careerSlotsUsed(int used) {
    return 'HELYEK  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Több mentés feloldása';

  @override
  String get careerSlotsKeepNote =>
      'Minden meglévő mentésed játszható marad. Csak egy újhoz kell a feloldás.';

  @override
  String get careerNewGame => 'Új játék';

  @override
  String get careerDeleteSaveTitle => 'Törlöd a mentést?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Ez véglegesen törli ezt a karriert: $label.';
  }

  @override
  String get careerCancel => 'Mégse';

  @override
  String get careerDelete => 'Törlés';

  @override
  String get careerNoSavesYet =>
      'Még nincs mentés.\nIndíts új játékot, és irányíts egy válogatottat.';

  @override
  String get careerUnknownNation => 'Ismeretlen';

  @override
  String careerPlayedMinutes(int minutes) {
    return '${minutes}p';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hoursó ${minutes}p';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Utoljára játszva: $when';
  }

  @override
  String get careerJustNow => 'épp az imént';

  @override
  String get careerYesterday => 'tegnap';

  @override
  String careerMinutesAgo(int n) {
    return '$n perce';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n órája';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n napja';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Úton a $year. évi világbajnokság felé';
  }

  @override
  String get careerManagerCareerTitle => 'KAPITÁNYI KARRIER';

  @override
  String careerCouldNotLoad(String error) {
    return 'Nem tölthető be.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CIKLUSONKÉNT';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles ciklus',
      one: '1 ciklus',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations irányított ország',
      one: '1 irányított ország',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Címek';

  @override
  String get careerStatPlayed => 'Lejátszott';

  @override
  String get careerStatWon => 'Győzelem';

  @override
  String get careerStatDrawn => 'Döntetlen';

  @override
  String get careerStatLost => 'Vereség';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Gólok $goalsFor–$goalsAgainst  ($gd)  ·  Győzelmi arány $winRate%';
  }

  @override
  String get careerRecordResults => 'REKORDEREDMÉNYEK';

  @override
  String get careerBestWin => 'Legnagyobb győzelem';

  @override
  String get careerWorstDefeat => 'Legsúlyosabb vereség';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'ellen: $opponent · $date';
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
    return '${won}GY ${drawn}D ${lost}V  ·  LG $goalsFor KG $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Világbajnokság';

  @override
  String get careerContinentalLabel => 'Kontinentális';

  @override
  String get messagesTitle => 'ÜZENETEK';

  @override
  String get messagesNoMessagesYet => 'Még nincs üzenet.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Az üzenetek nem tölthetők be.\n$error';
  }

  @override
  String get messagesDone => 'Kész';

  @override
  String get messagesNext => 'Következő';

  @override
  String get rankingWorldRanking => 'VILÁGRANGLISTA';

  @override
  String rankingCouldNotLoad(String error) {
    return 'A ranglista nem tölthető be.\n$error';
  }

  @override
  String get rankingNoRanking => 'Nincs ranglista.';

  @override
  String get rankingAll => 'MIND';

  @override
  String get rankingYourTeam => 'A TE CSAPATOD';

  @override
  String get rankingYourRankingOverTime => 'A RANGLISTAHELYEZÉSED IDŐBEN';

  @override
  String rankingNowRank(int rank) {
    return 'most #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'legjobb #$best · legrosszabb #$worst';
  }

  @override
  String get friendliesTitle => 'BARÁTSÁGOS MECCSEK';

  @override
  String friendliesLoadError(String error) {
    return 'A barátságos meccsek nem tölthetők be.\n$error';
  }

  @override
  String get friendliesContinue => 'Tovább';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szabad időpontra',
      one: '1 szabad időpontra',
    );
    return 'Szervezz felkészülési meccseket a következő éles mérkőzésed előtti $_temp0. Koppints egy ellenfélre, vagy hagyd szabadon.';
  }

  @override
  String get friendliesFree => 'Szabad';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count GÓL',
      one: '1 GÓL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'GÓLOK';

  @override
  String get matchGoalsNone => 'Nincs gól';

  @override
  String get matchGoalPenalty => '11-ES';

  @override
  String get matchGoalSetPiece => 'RÚGÁS';

  @override
  String matchGoalAssist(String name) {
    return 'gólpassz: $name';
  }

  @override
  String get friendliesHome => 'HAZAI';

  @override
  String get friendliesAway => 'IDEGEN';

  @override
  String get friendliesNoneThisWindow => 'Nincs barátságos ebben az időpontban';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count barátságos',
      one: '1 barátságos',
    );
    return '$_temp0 megerősítése';
  }

  @override
  String get friendliesMonthJan => 'jan.';

  @override
  String get friendliesMonthFeb => 'febr.';

  @override
  String get friendliesMonthMar => 'márc.';

  @override
  String get friendliesMonthApr => 'ápr.';

  @override
  String get friendliesMonthMay => 'máj.';

  @override
  String get friendliesMonthJun => 'jún.';

  @override
  String get friendliesMonthJul => 'júl.';

  @override
  String get friendliesMonthAug => 'aug.';

  @override
  String get friendliesMonthSep => 'szept.';

  @override
  String get friendliesMonthOct => 'okt.';

  @override
  String get friendliesMonthNov => 'nov.';

  @override
  String get friendliesMonthDec => 'dec.';

  @override
  String get resultsMyMatches => 'MÉRKŐZÉSEIM';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Az eredmények nem tölthetők be.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Nincs mérkőzés.';

  @override
  String get resultsVs => '–';

  @override
  String get resultsStageQualifier => 'SELEJTEZŐ';

  @override
  String get resultsStageFriendly => 'BARÁTSÁGOS';

  @override
  String get resultsStageGroupStage => 'CSOPORTKÖR';

  @override
  String get resultsStageSemiFinal => 'ELŐDÖNTŐ';

  @override
  String get resultsStageFinal => 'DÖNTŐ';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'DÖNTŐ CSOPORTJA';

  @override
  String get resultsStageRoundOf32 => 'LEGJOBB 32';

  @override
  String get resultsStageRoundOf16 => 'NYOLCADDÖNTŐ';

  @override
  String get resultsStageQuarterFinal => 'NEGYEDDÖNTŐ';

  @override
  String get resultsStageThirdPlace => 'A 3. HELYÉRT';

  @override
  String get matchSetupWarnCaptain =>
      'Nincs kinevezett csapatkapitány. Koppints, és add át valakinek a karszalagot';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name sérült, nem vezetheti ki a csapatot. Koppints, és add tovább a karszalagot';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name eltiltva, ezt a meccset kihagyja. Koppints, és add tovább a karszalagot';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name viseli a karszalagot, de nincs a keretedben. Koppints, és add tovább';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Nincsenek kinevezett pontrúgás-végrehajtók. Koppints, és válaszd ki, ki lép oda';

  @override
  String get matchSetupWarnBoth =>
      'Nincs csapatkapitány és nincsenek pontrúgás-végrehajtók. Koppints a beállításukhoz';

  @override
  String matchStageMatchday(int matchday) {
    return '$matchday. FORDULÓ';
  }

  @override
  String get squadCaptain => 'Csapatkapitány';

  @override
  String deptEffectYouth(int points) {
    return 'Az akadémiai tehetségek nagyjából $points ponttal jobb összértékeléssel érkeznek';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount visszatér a ciklus végén';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent%-kal kevesebb sérülés';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% az esélye, hogy egy külföldi játékos átigazolna hozzád';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points vezetőségi türelem, mielőtt az állásod veszélybe kerül';
  }

  @override
  String get deptEffectNone => 'Finanszírozás nélkül nincs hatása';

  @override
  String get statsBestRated => 'Értékelések';

  @override
  String get statsMyCareer => 'Karrier';

  @override
  String get statsBestAverageRating => 'LEGJOBB ÁTLAGÉRTÉKELÉS';

  @override
  String get statsMyCareerRecord => 'A MÉRLEGED';

  @override
  String get statsNoRatingsRecorded => 'Még nincs rögzített mérkőzésértékelés.';

  @override
  String get statsGroupRecord => 'Mérleg';

  @override
  String get statsGroupRuns => 'Sorozatok';

  @override
  String get statsGroupExtremes => 'Szélsőségek';

  @override
  String get statsGroupSplits => 'Hazai és idegen';

  @override
  String get statsGroupSquad => 'A játékosaid';

  @override
  String get statsPlayed => 'Lejátszott mérkőzések';

  @override
  String get statsWinDrawLoss => 'Győzelem–döntetlen–vereség';

  @override
  String get statsWinRate => 'Győzelmi arány';

  @override
  String get statsGoals => 'Lőtt:kapott gól';

  @override
  String get statsCleanSheets => 'Kapott gól nélkül';

  @override
  String get statsFailedToScore => 'Gól nélkül maradt';

  @override
  String get statsLongestWinStreak => 'Leghosszabb győzelmi sorozat';

  @override
  String get statsLongestUnbeaten => 'Leghosszabb veretlenségi sorozat';

  @override
  String get statsLongestCleanSheets =>
      'Leghosszabb kapott gól nélküli sorozat';

  @override
  String get statsLongestWinless => 'Leghosszabb győzelem nélküli sorozat';

  @override
  String get statsCurrentRun => 'Jelenlegi veretlenségi sorozat';

  @override
  String get statsBiggestWin => 'Legnagyobb győzelem';

  @override
  String get statsHeaviestDefeat => 'Legsúlyosabb vereség';

  @override
  String get statsMostGoalsInAGame => 'Legtöbb gól egy meccsen';

  @override
  String get statsShootouts => 'Tizenegyespárbaj: nyert–vesztett';

  @override
  String get statsComebackWins => 'Hátrányból nyert meccsek';

  @override
  String get statsHome => 'Hazai';

  @override
  String get statsAway => 'Idegen';

  @override
  String get statsNeutral => 'Semleges';

  @override
  String get statsCompetitive => 'Éles';

  @override
  String get statsFriendlies => 'Barátságos';

  @override
  String get statsHatTricks => 'Mesterhármasok';

  @override
  String get statsBraces => 'Duplák';

  @override
  String get statsMotms => '„A mérkőzés embere” díjak';

  @override
  String get statsAssists => 'Gólpasszok';

  @override
  String get statsCards => 'Lapok';

  @override
  String get statsBestRating => 'Legjobb egyéni értékelés';

  @override
  String statsAppsShort(int apps) {
    return '$apps mérk.';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms ME';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent =>
      'Csapatkapitány. Koppints a karszalag elvételéhez';

  @override
  String get captainFitBorn => 'Született vezér';

  @override
  String get captainFitNatural => 'Természetes kapitány';

  @override
  String get captainFitCapable => 'Viselhetné';

  @override
  String get captainFitUnproven => 'Még nem vezér';

  @override
  String get captainNone => 'Nincs kinevezett kapitány';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale keretmorál';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'Világbajnoki selejtezők';

  @override
  String get resultsCategoryFriendlies => 'Barátságos mérkőzések';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Kontinentális kupa';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Vb-selej.';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Kont. selej.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Kontinentális kupa selejtezői';

  @override
  String get resultsCategoryWorldCupFinals => 'Világbajnoki döntő';

  @override
  String get resultsRoundResults => 'FORDULÓ EREDMÉNYEI';

  @override
  String get resultsFriendlyInternationals => 'BARÁTSÁGOS VÁLOGATOTT MECCSEK';

  @override
  String get resultsKnockout => 'Egyenes kieséses szakasz';

  @override
  String resultsEarlierMatches(int count) {
    return 'Korábbi mérkőzések ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return '$matchday. FORDULÓ';
  }

  @override
  String get resultsContinue => 'Tovább';

  @override
  String resultsGroup(String name) {
    return '$name CSOPORT';
  }

  @override
  String get achievementsScreenTitle => 'EREDMÉNYEK';

  @override
  String get achievementsChallengesTooltip => 'Kihívások';

  @override
  String get achievementsChallengesHeading => 'KIHÍVÁSOK';

  @override
  String get achievementsBrutalTests =>
      'Kíméletlen, egész karriert átfogó próbák';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Nem tölthető be.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total feloldva';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total teljesítve';
  }

  @override
  String get achievementsBoardSatisfaction => 'VEZETŐSÉGI ELÉGEDETTSÉG';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count EREDMÉNY FELOLDVA',
      one: 'EREDMÉNY FELOLDVA',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Győzelmek';

  @override
  String get achCatMatches => 'Mérkőzések';

  @override
  String get achCatQualifications => 'Kvalifikációk';

  @override
  String get achCatTitles => 'Címek';

  @override
  String get achCatMisc => 'Egyéb';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Gólok';

  @override
  String get achCatStreaks => 'Sorozatok';

  @override
  String get achTierBronze => 'Bronz';

  @override
  String get achTierSilver => 'Ezüst';

  @override
  String get achTierGold => 'Arany';

  @override
  String get achTierPlatinum => 'Platina';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gól',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Szerezz $count gólt.',
      one: 'Szerezz 1 gólt.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kapott gól nélküli meccs',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Őrizd tisztán a kapudat $count meccsen.',
      one: 'Őrizd tisztán a kapudat 1 meccsen.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Győzelmi megszokás';

  @override
  String get achStreakWin5Desc => 'Nyerj meg öt mérkőzést egymás után.';

  @override
  String get achStreakWin10 => 'Szárnyalás';

  @override
  String get achStreakWin10Desc => 'Nyerj meg tíz mérkőzést egymás után.';

  @override
  String get achStreakWin20 => 'Megállíthatatlan';

  @override
  String get achStreakWin20Desc => 'Nyerj meg húsz mérkőzést egymás után.';

  @override
  String get achUnbeaten15 => 'Nehezen legyőzhető';

  @override
  String get achUnbeaten15Desc => 'Maradj veretlen tizenöt mérkőzésen át.';

  @override
  String get achUnbeaten30 => 'Érinthetetlen';

  @override
  String get achUnbeaten30Desc => 'Maradj veretlen harminc mérkőzésen át.';

  @override
  String get achHattrick => 'Mesterhármas-hős';

  @override
  String get achHattrickDesc => 'Egy játékosod szerezzen mesterhármast.';

  @override
  String get achMotm10 => 'Kiemelkedő';

  @override
  String get achMotm10Desc => 'Szerezz 10 „a mérkőzés embere” címet.';

  @override
  String get achMotm50 => 'Talizmán';

  @override
  String get achMotm50Desc => 'Szerezz 50 „a mérkőzés embere” címet.';

  @override
  String get achPerfect => 'Tökéletes tízes';

  @override
  String get achPerfectDesc =>
      'Egy játékosod érjen el 9,5 feletti mérkőzésértékelést.';

  @override
  String get achShootout => 'Jéghideg idegek';

  @override
  String get achShootoutDesc => 'Nyerj meg öt tizenegyespárbajt.';

  @override
  String get achMassacre => 'Mészárlás';

  @override
  String get achMassacreDesc => 'Nyerj meg egy meccset 7 vagy több góllal.';

  @override
  String get achAnnihilation => 'Megsemmisítés';

  @override
  String get achAnnihilationDesc =>
      'Nyerj meg egy meccset 10 vagy több góllal.';

  @override
  String get chTierBronze => 'Bronz';

  @override
  String get chTierSilver => 'Ezüst';

  @override
  String get chTierGold => 'Arany';

  @override
  String get chTierLegendary => 'Legendás';

  @override
  String get chFirstSteps => 'A kispadon';

  @override
  String get chFirstStepsDesc => 'Irányíts 5 évig.';

  @override
  String get chUnbeaten10 => 'Szárnyalás';

  @override
  String get chUnbeaten10Desc => 'Maradj veretlen 10 éles mérkőzésen át.';

  @override
  String get chTwoNations => 'Új kihívás';

  @override
  String get chTwoNationsDesc => 'Irányíts 2 különböző országot.';

  @override
  String get chCont1 => 'Kontinentális bajnok';

  @override
  String get chCont1Desc => 'Nyerj kontinentális bajnokságot.';

  @override
  String get chNc1 => 'Nations Cup-győztes';

  @override
  String get chNc1Desc => 'Nyerd meg a Nations Cupot.';

  @override
  String get chWc1 => 'Világbajnok';

  @override
  String get chWc1Desc => 'Nyerd meg a világbajnokságot.';

  @override
  String get chYears25 => 'Intézmény';

  @override
  String get chYears25Desc => 'Irányíts 25 évig.';

  @override
  String get chWc3 => 'Sorozatgyőztes';

  @override
  String get chWc3Desc => 'Nyerj 3 világbajnokságot.';

  @override
  String get chWc5 => 'Dinasztia';

  @override
  String get chWc5Desc => 'Nyerj 5 világbajnokságot.';

  @override
  String get chWc10 => 'Halhatatlan';

  @override
  String get chWc10Desc => 'Nyerj 10 világbajnokságot.';

  @override
  String get chWc2Teams => 'Bárhová elmegyek';

  @override
  String get chWc2TeamsDesc => 'Nyerj világbajnokságot 2 különböző országgal.';

  @override
  String get chWc3Teams => 'Világutazó';

  @override
  String get chWc3TeamsDesc => 'Nyerj világbajnokságot 3 különböző országgal.';

  @override
  String get chWcStreak3 => 'Triplázás';

  @override
  String get chWcStreak3Desc => 'Nyerj 3 világbajnokságot egymás után.';

  @override
  String get chWcAllconf => 'Világhódító';

  @override
  String get chWcAllconfDesc =>
      'Nyerj világbajnokságot mind a hat kontinentális szövetség egy-egy országával (6).';

  @override
  String get chCont5 => 'Kontinentális király';

  @override
  String get chCont5Desc => 'Nyerj 5 kontinentális bajnokságot.';

  @override
  String get chContAll => 'Hatkontinenses grand slam';

  @override
  String get chContAllDesc =>
      'Nyerd meg mindegyik kontinentális szövetség bajnokságát (6).';

  @override
  String get chTreble => 'Tarolás';

  @override
  String get chTrebleDesc =>
      'Nyerd meg a világbajnokságot, egy kontinentális címet és a Nations Cupot egyetlen karrierben.';

  @override
  String get chNations10 => 'Nomád';

  @override
  String get chNations10Desc => 'Irányíts 10 különböző országot.';

  @override
  String get chYears100 => 'Évszázad';

  @override
  String get chYears100Desc => 'Irányíts 100 évig.';

  @override
  String get chYears500 => 'Fél évezred';

  @override
  String get chYears500Desc => 'Irányíts 500 évig.';

  @override
  String get chYears1000 => 'Örökkévaló';

  @override
  String get chYears1000Desc => 'Irányíts 1000 évig.';

  @override
  String get chGrandmaster => 'Nagymester';

  @override
  String get chGrandmasterDesc =>
      'Nyerj 3 világbajnokságot ÉS 5 kontinentális bajnokságot.';

  @override
  String get chUndefeated => 'Érinthetetlen';

  @override
  String get chUndefeatedDesc =>
      'Nyerj világbajnokságot egyetlen vereség nélkül.';

  @override
  String get chPerfectQual => 'Hibátlan menetelés';

  @override
  String get chPerfectQualDesc =>
      'Nyerd meg egy vb-selejtezősorozat minden mérkőzését.';

  @override
  String get chMinnow => 'Kisemberek csodája';

  @override
  String get chMinnowDesc =>
      'Nyerj világbajnokságot egy olyan országgal, amely a világranglista első 32 helyén kívül áll.';

  @override
  String get chGrandTour => 'Itthon és idegenben';

  @override
  String get chGrandTourDesc =>
      'Nyerj világbajnokságot házigazdaként, és egyet idegenben is.';

  @override
  String get chUnbeaten25 => 'A Fal';

  @override
  String get chUnbeaten25Desc => 'Maradj veretlen 25 éles mérkőzésen át.';

  @override
  String get chGoals10k => 'Gólgép';

  @override
  String get chGoals10kDesc => 'Szerezz 10 000 gólt a karriered során.';

  @override
  String get chCleanSheets500 => 'Erődítmény';

  @override
  String get chCleanSheets500Desc =>
      'Őrizd tisztán a kapudat 500 meccsen a karriered során.';

  @override
  String get chHatTricks25 => 'Mesterhármas-szenvedély';

  @override
  String get chHatTricks25Desc => 'A játékosaid szerezzenek 25 mesterhármast.';

  @override
  String get chWinStreak25 => 'Kérlelhetetlen';

  @override
  String get chWinStreak25Desc => 'Nyerj meg 25 mérkőzést egymás után.';

  @override
  String get chCont10 => 'Kontinentális dinasztia';

  @override
  String get chCont10Desc => 'Nyerj 10 kontinentális bajnokságot.';

  @override
  String get chPcWc => 'Sorozatbajnok';

  @override
  String chPcWcDesc(int count) {
    return 'Nyerj $count világbajnokságot ezen a mentésen.';
  }

  @override
  String get chPcMajors => 'Trófeagyűjtő';

  @override
  String chPcMajorsDesc(int count) {
    return 'Nyerj $count jelentős trófeát (világbajnokság, kontinentális bajnokság vagy Nations Cup).';
  }

  @override
  String get chPcUnbeaten => 'Vasfal';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Maradj veretlen $count éles mérkőzésen át.';
  }

  @override
  String get chPcNations => 'Vándorkapitány';

  @override
  String chPcNationsDesc(int count) {
    return 'Irányíts $count különböző országot.';
  }

  @override
  String get chPcYears => 'A hosszú menet';

  @override
  String chPcYearsDesc(int count) {
    return 'Irányíts $count évig.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count győzelem',
      one: '1 győzelem',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nyerj meg $count mérkőzést.',
      one: 'Nyerj meg 1 mérkőzést.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mérkőzés',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Játssz $count mérkőzést.',
      one: 'Játssz 1 mérkőzést.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Vb-résztvevő';

  @override
  String get achQualWcDesc => 'Kvalifikáld magad a világbajnokságra.';

  @override
  String get achQualCont => 'Kontinentális résztvevő';

  @override
  String get achQualContDesc =>
      'Kvalifikáld magad a kontinentális bajnokságodra.';

  @override
  String get achTitleWc => 'Világbajnokok';

  @override
  String get achTitleWcDesc => 'Nyerd meg a világbajnokságot.';

  @override
  String get achTitleEuro => 'Európa-bajnokok';

  @override
  String get achTitleEuroDesc => 'Nyerd meg az Európa-bajnokságot.';

  @override
  String get achTitleCopa => 'Dél-amerikai bajnokok';

  @override
  String get achTitleCopaDesc => 'Nyerd meg a Dél-amerikai Kupát.';

  @override
  String get achTitleAfcon => 'Afrika-bajnokok';

  @override
  String get achTitleAfconDesc => 'Nyerd meg az Afrika-bajnokságot.';

  @override
  String get achTitleAsia => 'Ázsia-bajnokok';

  @override
  String get achTitleAsiaDesc => 'Nyerd meg az Ázsia-bajnokságot.';

  @override
  String get achTitleConcacaf => 'Észak-amerikai bajnokok';

  @override
  String get achTitleConcacafDesc => 'Nyerd meg az Észak-amerikai Kupát.';

  @override
  String get achTitleOfc => 'Óceániai bajnokok';

  @override
  String get achTitleOfcDesc => 'Nyerd meg az Óceániai Kupát.';

  @override
  String get achTitleNations => 'Nations Cup-győztesek';

  @override
  String get achTitleNationsDesc => 'Nyerd meg a Nations Cupot.';

  @override
  String get achTitleClash => 'Continental Clash-győztesek';

  @override
  String get achTitleClashDesc => 'Nyerd meg a Continental Clasht.';

  @override
  String get achMarksman => 'Vb-gólvadász';

  @override
  String get achMarksmanDesc =>
      'Egy keretbeli játékosod szerezzen 6 vagy több gólt egy vb-döntő tornán.';

  @override
  String get achSweep => 'Tarolás';

  @override
  String get achSweepDesc =>
      'Birtokold a világbajnoki és a kontinentális címet egyetlen karrierben.';

  @override
  String get achAllstar => 'A torna csillaga';

  @override
  String get achAllstarDesc =>
      'Egy játékosod kerüljön be egy vb A torna csapatába.';

  @override
  String get achGoldenboot => 'Aranycipő';

  @override
  String get achGoldenbootDesc =>
      'Országod játékosa legyen egy bajnokság gólkirálya.';

  @override
  String get achDemolition => 'Szétverés';

  @override
  String get achDemolitionDesc => 'Nyerj meg egy meccset 5 vagy több góllal.';

  @override
  String get achievementsNice => 'Szép!';

  @override
  String get achievementsHardestTests =>
      'Egy kapitány legnehezebb próbái, egész karrieren át és sok országgal.';

  @override
  String get achievementsThisSave => 'EZ A MENTÉS';

  @override
  String get achievementsBrutalBadge => 'KÍMÉLETLEN';

  @override
  String get paywallGoPro => 'VÁLTS UNLIMITEDRE';

  @override
  String get paywallOneTimeUnlock => 'Egyszeri feloldás. Nincs előfizetés.';

  @override
  String get paywallBenefitCarryOn =>
      'Ez a mentés pontosan onnan folytatódik, ahol megállt, minden válogatottsággal, rekorddal és rivalizálással együtt.';

  @override
  String get paywallBenefitNoAds =>
      'Nincs reklám, nincs mikrotranzakció, nincs előfizetés. Egyetlen fizetés, és minden jövőbeli frissítés a tiéd.';

  @override
  String get paywallBenefitSaves =>
      'Annyi mentés, amennyit csak akarsz. Irányíts egyszerre egy esélyest és egy kisországot, és nézd meg, mennyire másképp olvasódik ugyanaz a játék.';

  @override
  String get paywallBenefitEndless =>
      'Minden ciklus innentől. Válassz ma egy tizenhét évest, és 2034-ben megtudod, jól láttad-e.';

  @override
  String get paywallUnlocked => 'Az Unlimited fel van oldva. Jó szórakozást!';

  @override
  String get paywallContactingStore => 'Kapcsolódás az áruházhoz…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Unlimited feloldása · $price';
  }

  @override
  String get paywallRestorePurchases => 'Vásárlások visszaállítása';

  @override
  String get paywallStoreUnavailable => 'Az áruház nem érhető el';

  @override
  String get paywallStoreUnavailableNote =>
      'Az árat nem sikerült betölteni. Ellenőrizd a kapcsolatot, és próbáld újra.';

  @override
  String get paywallTryAgain => 'Próbáld újra';

  @override
  String get gateTitle => 'AZ ELSŐ CIKLUSOD VÉGET ÉRT';

  @override
  String get gateLead =>
      'Négy év egy ciklus. Ez nem elég ahhoz, hogy kiderüljön, igazad volt-e.';

  @override
  String get gatePriceLead => 'Egyetlen fizetés, örökre';

  @override
  String get gateBuy => 'VÁSÁRLÁS ÉS FOLYTATÁS';

  @override
  String get gateExit => 'KILÉPÉS';

  @override
  String get gateSaveTitle => 'EHHEZ A MENTÉSHEZ PRO KELL';

  @override
  String get gateSaveLead =>
      'Az ingyenes cikluson túli mentések és a Pro kampányok Pro-val folytatódnak. Semmi sem vész el: a mentés pontosan úgy vár, ahogy hagytad.';

  @override
  String get careerSaveLockedNote => 'A mentés folytatásához Pro kell';

  @override
  String get federationNaturalisation => 'HONOSÍTÁS';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name honosítva';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name befejezte az átállást. Új válogatottja: $nation. Hívd meg a keretválasztásnál.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Az ajánlat nem tölthető be.\n$error';
  }

  @override
  String get federationContinue => 'Tovább';

  @override
  String get federationOfferToSwitchAllegiance => 'AJÁNLAT A VÁLTÁSRA';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · $age éves · $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name kötődik a következő országhoz: $playerNation, és hajlandó honosítást kérni. Ha elfogadod, válogatható lesz; ha elutasítod, marad a jelenlegi válogatottjában ($sourceNation).';
  }

  @override
  String get federationDecline => 'Elutasítás';

  @override
  String get federationNaturalise => 'Honosítás';

  @override
  String get federationBudgetLater => 'Később döntök';

  @override
  String get federationSetYourBudget => 'ÁLLÍTSD BE A KÖLTSÉGVETÉST';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'A pénzügyek nem tölthetők be.\n$error';
  }

  @override
  String get federationSaveNotFound => 'A mentés nem található.';

  @override
  String get federationBudgetHeading => 'SZÖVETSÉGI KÖLTSÉGVETÉS';

  @override
  String federationDistributeBudget(String amount) {
    return 'Oszd szét a részlegek között a ciklus megnyitásához: $amount. Költs okosan.';
  }

  @override
  String federationOverBudget(String amount) {
    return 'Túllépés: $amount a szövetség keretén felül. Végy vissza valamennyit';
  }

  @override
  String get federationAllocateFullBudget =>
      'Told szét a teljes költségvetést a ciklus megkezdéséhez.';

  @override
  String get federationConfirming => 'Megerősítés…';

  @override
  String get federationConfirmBudget => 'Költségvetés jóváhagyása';

  @override
  String get federationFinances => 'PÉNZÜGYEK';

  @override
  String get federationInvestmentUpdated => 'Befektetés frissítve.';

  @override
  String get federationDevelopment => 'SZÖVETSÉGI FEJLESZTÉS';

  @override
  String get federationProjectedAtSeasonEnd => 'VÁRHATÓ A SZEZON VÉGÉN';

  @override
  String get federationCentralFunding => 'Központi támogatás';

  @override
  String get federationPrizeMoneySoFar => 'Eddigi pénzdíj';

  @override
  String get federationCommercialReturn => 'Kereskedelmi hozam';

  @override
  String get federationThisSeasonLocked => 'EZ A SZEZON (ZÁROLT)';

  @override
  String get federationInvestForNextSeason => 'BEFEKTETÉS A KÖVETKEZŐ SZEZONRA';

  @override
  String get federationNextSeasonImpact => 'HATÁS A KÖVETKEZŐ SZEZONRA';

  @override
  String get federationSaving => 'Mentés…';

  @override
  String get federationConfirmInvestment => 'Befektetés jóváhagyása';

  @override
  String get federationBalance => 'SZÖVETSÉGI EGYENLEG';

  @override
  String get federationCommittedToStaff => 'Stábra félretéve';

  @override
  String get federationFreeToSpend => 'Szabadon költhető';

  @override
  String get federationWagesNote =>
      'A fizetések a ciklus végén levonódnak az egyenlegből, így ez az összeg már foglalt.';

  @override
  String get federationInvestAtCeremony =>
      'A következő szezonra a ciklus végi ünnepségen fektethetsz be.';

  @override
  String federationLevelBadge(int level) {
    return 'Sz$level';
  }

  @override
  String get federationAcademyProspects => 'Akadémiai tehetségek';

  @override
  String federationPlusOverall(int value) {
    return '+$value összértékelés';
  }

  @override
  String get federationInjuryRisk => 'Sérülésveszély';

  @override
  String get federationNaturalisationChance => 'Honosítási esély';

  @override
  String get federationBoardPatience => 'Vezetőségi türelem';

  @override
  String get federationUnallocated => 'ELOSZTATLAN';

  @override
  String get nationsVitrineTitle => 'NEMZETI VITRIN';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Az ország nem tölthető be.\n$error';
  }

  @override
  String get nationsNoNation => 'Nincs ország.';

  @override
  String get nationsHonours => 'ELISMERÉSEK';

  @override
  String get nationsRankingHistory => 'VILÁGRANGLISTA-TÖRTÉNET';

  @override
  String get nationsTopScorers => 'MINDEN IDŐK GÓLKIRÁLYAI';

  @override
  String get nationsTitles => 'CÍMEK';

  @override
  String get nationsYourTeam => 'A TE CSAPATOD';

  @override
  String get nationsWorld => 'VILÁG';

  @override
  String get nationsWorldCup => 'Világbajnokság';

  @override
  String get nationsContinental => 'Kontinentális';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szereplés',
      one: '1 szereplés',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Még kevés az előzmény. Nézz vissza egy-két ciklus múlva.';

  @override
  String nationsBestRank(int rank) {
    return 'Legjobb: $rank.';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Most: $rank.';
  }

  @override
  String get nationsNoGoals => 'Még nincs rögzített gól.';

  @override
  String get nationsGoalsAbbrev => 'gól';

  @override
  String get nationsHosts => 'RENDEZŐK';

  @override
  String get nationsSelectTitle => 'VÁLASSZ VÁLOGATOTTAT';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Az országok nem tölthetők be.\n$error';
  }

  @override
  String get nationsNoMatch => 'Nincs találat.';

  @override
  String get nationsSelectHeading => 'Válassz válogatottat';

  @override
  String get nationsSearchHint => 'Ország keresése…';

  @override
  String get nationsRank => 'HELY ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'VÁLASZT';

  @override
  String get statsTeamRecords => 'CSAPATREKORDOK';

  @override
  String get statsRecordBook => 'Rekordok könyve';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'A statisztikák nem tölthetők be.\n$error';
  }

  @override
  String get statsNoData => 'Nincs adat.';

  @override
  String get statsTopScorers => 'GÓLKIRÁLYOK';

  @override
  String get statsMostGamesPlayed => 'LEGTÖBB MECCS';

  @override
  String get statsTeam => 'Csapat';

  @override
  String get statsTopScorersShort => 'Gólszerzők';

  @override
  String get statsMostGames => 'Legtöbb meccs';

  @override
  String get statsNoGoalsRecorded => 'Még nincs rögzített gól.';

  @override
  String get statsUnknown => 'Ismeretlen';

  @override
  String get playerTitle => 'JÁTÉKOS';

  @override
  String playerLoadError(String error) {
    return 'A játékos nem tölthető be.\n$error';
  }

  @override
  String get playerNotFound => 'A játékos nem található.';

  @override
  String get playerClub => 'KLUB';

  @override
  String get playerClubRole => 'A klubjában';

  @override
  String get playerPosition => 'Poszt';

  @override
  String get playerPotential => 'Potenciál';

  @override
  String get playerAge => 'Kor';

  @override
  String get playerValue => 'Érték';

  @override
  String get clubFirstChoice => 'Minden héten játszik';

  @override
  String get clubRotation => 'Hol játszik, hol nem';

  @override
  String get clubFringe => 'Alig játszik';

  @override
  String get clubFrozenOut => 'Nem játszik';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Harminc éve nézek focit, de erre nem számítottam. $opponent ellen $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Senki sem adott esélyt nekik $opponent ellen. $score. Egyetlen lélek sem.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score $opponent ellen. Mehet a harangozás, keltsük fel a szomszédokat.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Az unokáknak is mesélni fogják ezt az estét. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score $opponent ellen. Hogy hogyan, azt nem tudom, de megtörtént.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Papíron ennek már a kezdés előtt vége volt. $opponent $score mást mond.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponent ellen $score. Egy év múlva senki sem hiszi majd el ezt az eredményt.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Élvezzétek ki, aztán nézzétek meg a sorsolást.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score $opponent ellen, és a kilencvenből nyolcvan percig a szerencsénkre támaszkodtunk.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Egy este $opponent ellen nem törli el az egész évet. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent ellen $score, és most megint azt fogják mondani, hogy fordult a kocka. Nem fordult.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Szép, szép. Kérdezz meg újra, ha számít is valamit.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent ellen $score. Pontosan így kell, és ennek van egy különös örömje.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score $opponent ellen. Könyörtelen, és ez dicséret.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Se felhajtás, se ijedelem, se panasz.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Rendes $score $opponent ellen. Így néz ki egy jó csapat egy nyugodt napon.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score $opponent ellen. Munka kipipálva, tanulság nulla.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent ellen $score. Nyernünk kellett, és nyertünk.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Profi $score $opponent ellen. Jöhet a következő.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent elintézve, $score. Irattárba vele, tovább.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score $opponent ellen, és ezért most tapsolnunk kéne. Amiért legyőztük őket.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Gratulálok mindenkinek a meccshez: $opponent ellen $score, gondolom.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Az ilyen csapatok legyőzése a minimum, nem a teljesítmény.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return '$opponent ellen $score, de nehézkesen játszottunk.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score $opponent ellen, és minden percét megdolgoztuk.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Ehhez jellem kellett. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent ellen $score, a nehezebb úton, és az a tartós út.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score $opponent ellen. Aki az ilyeneket megnyeri, az még júniusban is talpon lesz.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Idegesítő, csúnya, de győzelem. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent ellen $score. Vidd el a három pontot, és soha többé ne nézd vissza.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent minden centiért megdolgoztatott minket.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Nem szép. Ugyanannyit ér.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score $opponent ellen, és tízszer nehezebbé tettük, mint kellett volna.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Nem kéne ennyire kapaszkodnunk $opponent ellen. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Megnyertük, de semmi jót nem tanultunk magunkról.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$opponent ellen $score, ami hízelgett nekünk.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Egy pont $opponent ellen, $score. Vigyük, és lépjünk tovább.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score $opponent ellen. Voltak már rosszabb délutánok is.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent ellen $score, megfogtuk őket. Nem kell mindennek történetnek lennie.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. A pont az pont, a tabella nem kérdezi, hogyan.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score $opponent ellen. Két pont elveszett vagy egy megszerzett. Döntsd el a hangulatod.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Döntetlen $opponent ellen, $score. Senki sem boldog, senki sem dühös.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Az év legfelejthetőbb kilencven perce.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Osztoztunk a pontokon $opponent ellen, $score. Megyünk tovább.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score $opponent ellen. Az ilyen döntetlenekbe csendben belehal egy szezon.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Két pont elúszott $opponent ellen. $score. Másképp nem nevezhető.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Kilencven percünk volt, és fogalmunk sem volt, mit kezdjünk vele.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$opponent ellen $score, amire senki sem fog emlékezni, de mindenki megfizeti az árát.';
  }

  @override
  String yLost0(String opponent, String score) {
    return '$opponent ellen kikaptunk, $score. Megesik.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Senkit sem kell felakasztani érte. Jöhet a következő.';
  }

  @override
  String yLost2(String opponent, String score) {
    return '$opponent ellen $score a vége, pedig mindent beleadtunk. Vannak napok, amikor ez kevés.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score $opponent ellen. Fel a fejjel. Ebben a csapatban még sok van.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Ők voltak a jobbak, és ebben nincs vita.';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$opponent ellen $score a vége. Összeszedjük magunkat.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score $opponent ellen. Nem szégyen, de nem elég jó.';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$opponent ellen kikaptunk, $score. Tanuljunk belőle, különben kárba veszett.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score $opponent ellen, és egy ujjal sem értünk hozzájuk.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Vereség $opponent ellen, $score. Ugyanazok a hibák, ugyanaz a hónap, jönnek az ugyanolyan kifogások.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Mikor szűnik meg ez rossz szerencse lenni?';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$opponent ellen kikaptunk, $score. Ez az az eredmény, aminek ára kell, hogy legyen valakinek.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score $opponent ellen. Egy rossz este. A csapatot a szezon alapján ítéld meg, ne ez alapján.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return '$opponent ellen $score. Senki sem akarta ezt kevésbé, mint a játékosok.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Csúnya, és nem ez a csapat igazi arca.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Felejtős $score $opponent ellen. Legközelebb kiállnak magukért.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. $opponent ellen. Nincs szavam, pedig szavakért fizetnek.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Valakinek felelnie kell ezért.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Töröljék a jegyzőkönyvből és az emlékezetből is: $opponent $score.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$opponent ellen kikaptunk, $score. Egy ilyen eredményt nem lehet szépíteni.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Ez nem vereség volt $opponent ellen, hanem megadás. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. $opponent ellen. Az emberek pénzt fizettek, hogy ezt végignézzék.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Ha ezután sem változik semmi, akkor soha.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Láttam már megalázva ezt a csapatot, de ez új mélypont: $opponent $score.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$score $opponent ellen. Írjátok fel a dátumot, kérdezni fogják, hol voltatok.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Az öltözőn kívül senki sem hitt benne. $score $opponent ellen. A büszke szó kevés.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score $opponent ellen! Mindenki addig futott, amíg bírta.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Óriásölők. $opponent, $score. Ezért jövünk mindig újra.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score $opponent ellen. Az esélylatolgatás most repült ki az ablakon.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Toronymagas esélyes: $opponent. Végeredmény: $score nekünk.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Az év egyik meglepetése: $score $opponent ellen.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Senki sem jósolta meg, és senki sem tudja igazán megmagyarázni.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score $opponent ellen. Gyönyörű. Most mindenki elfelejti, milyen rossz volt az év többi része.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score $opponent ellen, és a vonat már tele van. Én akkor is ültem rajta, amikor üres volt.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Remek, és mégis megtalálják a módját, hogy elpazarolják.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Nagy este $opponent ellen, $score. Egy fecske nem csinál nyarat.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score $opponent ellen. Fáj, mert számít nekünk. Álljunk mögéjük így is.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Felejthető este $opponent ellen, $score. A játékosoknak fáj a legjobban.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Fel a fejjel. Egy csapatot az minősít, hogyan válaszol erre.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score $opponent ellen. Rossz, igen. Világvége, nem.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score $opponent ellen. Évekig beszélnek majd erről az eredményről, rossz okokból.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Győzelem: $opponent, $score. Ezek után senki ne lepődjön meg legközelebb.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Az egyik legrosszabb este hosszú idő óta: $score $opponent ellen.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Lesznek kérdések, és jogosan.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score $opponent ellen. A kínos szó enyhe.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return '$score vereség $opponent ellen. Az utolsó kapcsolja le a villanyt.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Már meg sem lepődöm, és ez megijeszt.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Valakinek odafent ma este érdemes frissítenie az önéletrajzát.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score $opponent ellen! Az ilyen foci az egész országot mosolyra fakasztja.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return 'Kiütéses győzelem $opponent ellen, $score. Micsoda teljesítmény.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. $opponent ellen. Ma este minden sikerült.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return '$score arányú lemosás $opponent ellen. Mentsétek el az összefoglalót, kelleni fog.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Ez egy csapat, amely élvezi a játékot.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score $opponent ellen, és lehetett volna több is. Csodálatos.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score $opponent ellen. Olyan eredmény, amire kétszer is ránéz az ember.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$score győzelem $opponent ellen. Az első félóra után nem volt meccs.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Végeredmény: $score $opponent ellen. Messze a legnagyobb győzelem hosszú idő óta.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Az egyik csapat játszani jött, a másik le sem szállt a buszról.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. $opponent: semmire nem volt válasz.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Kiütés: $score $opponent ellen.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score $opponent ellen. Szép, de ők aligha a mérce.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score $opponent ellen. Ébresszetek fel, ha ezt egy jó csapattal tesszük.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Szórakoztató, de láttam már csapatokat így ragyogni és semmit sem nyerni.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, és megint mindenki zseni. $opponent volt az ellenfél.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score $opponent ellen. Csak semmi elszállás, ez nagyon keveset bizonyít.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Élvezzétek, aztán emlékezzetek, hogyan végződött legutóbb, amikor fellelkesültünk.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Továbbjutás tizenegyesekkel $opponent ellen! Acélidegek, mindenkinél.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Tizenegyesek $opponent ellen, és bírtuk idegekkel. Öleljetek meg egy idegent.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Megnyert büntetőpárbaj $opponent ellen. A szívem ezt nem bírja.';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'Győzelem tizenegyesekkel $opponent ellen. Irány a következő kör.';
  }

  @override
  String yWinShootout4(String opponent) {
    return '$opponent ellen a büntetőpontról dőlt el, és mi rúgtunk többet.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Megnyert tizenegyespárbaj $opponent ellen. A legnehezebb úton, de tovább.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Továbbjutás tizenegyesekkel $opponent ellen. Lottó megnyerve, a játékot felejtsük el.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Ilyen játék után tizenegyesekkel nyerni $opponent ellen? Szerencse, és ezt mindenki tudja.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Továbbjutás $opponent ellen tizenegyesekkel. Odáig sem kellett volna eljutni.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'TOVÁBB. $score $opponent ellen, és az álom él.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'EGYENES KIESÉSES GYŐZELEM: $score $opponent ellen. Az ország elkezdhet hinni.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score $opponent ellen, és irány a következő kör. Micsoda este.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return 'Hazautazik: $opponent, $score. Előre.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'EGYENES KIESÉS: $score $opponent ellen. A következő kör megvan.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Tovább: $score $opponent ellen.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return 'Kiesett: $opponent, $score. Vár a következő kör.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return '$score győzelem $opponent ellen. Egyenes kiesésben senki sem kérdezi, hogyan.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Tovább $opponent ellen, $score. A következő ellenfél nem lesz ilyen kedves.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score $opponent ellen, ez elég a továbbjutáshoz. Legközelebb sokkal több kell.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return 'Kiesett: $opponent, $score. Inkább túléltük, mint megnyertük.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'A következő körben $score után $opponent ellen. Ne kérdezzétek, hogyan.';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return '$gap hely volt köztünk a rangsorban, és mégis nyertünk $opponent ellen. Csodálatos.';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent: $gap hellyel előttünk. Mégis nyertünk. A foci csodálatos.';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'Rangsorkülönbség: $gap. Eredmény: győzelem $opponent ellen. Soha ne hagyjátok abba a hitet.';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'Rangsorkülönbség a kezdőrúgás előtt: $gap. Győzelem $opponent ellen így is.';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'A világranglistán $opponent $gap hellyel előttünk állt. Ma este nem.';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'Meglepetésindex: $gap rangsorhely a két csapat között. Győzelem nekünk $opponent ellen.';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return '$gap rangsorhely választott el minket ettől az ellenféltől: $opponent. Egy este nem tünteti el a különbséget.';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: $gap hellyel előttünk, és kikapott. A rangsor alig veszi észre.';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'Rangsorkülönbség: $gap. Jegyezzétek meg ezt a számot, amikor legközelebb kikapunk egy kiscsapattól.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Leírtam ezt a csapatot. Tévedtem, és még sosem örültem ennyire a tévedésemnek. Győzelem $opponent ellen.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Egy adag alázatot kérek. Nagyot. A győzelem $opponent ellen csodálatos volt.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Azt mondtam, nincs bennük semmi. Volt bennük bőven. Szép volt $opponent ellen, mindenki.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'A jegyzőkönyv kedvéért: ezt a győzelmet $opponent ellen nem láttam jönni. Le a kalappal.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Rendben. Azt mondtam, lebuknak. $opponent ellen nem buktak le.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Ma este megeszem a szavaimat erről a csapatról. A győzelem $opponent ellen megérdemli.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Igen, azt mondtam, végük. Egy győzelem $opponent ellen még nem bizonyítja, hogy tévedtem.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Azt mondják, egyem meg a szavaimat $opponent után. Megeszem, lassan, a blokkot pedig megtartom.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'A győzelem $opponent ellen lenyűgöző volt. A kételyeim ezzel a csapattal kapcsolatban megmaradtak.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Le a kalappal: $nation. $score, és teljesen megérdemelten.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Fáj kimondani, de ma este jobb volt: $nation. $score. Gratulálok.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Kalapot emelek: $nation. Ők jobban akarták.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return '$score vereség $nation ellen. Azt sem tudom, mit mondjak.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. A mieinknek szégyellniük kellene magukat.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score $nation ellen. Valaki magyarázza el, hogyan történt ez.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return '$score vereség $nation ellen. Ezt soha nem heverem ki.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score $nation ellen. Szerencse. Tiszta szerencse.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return '$score után a szurkolóik ($nation) évekig elviselhetetlenek lesznek. Köszönöm a semmit.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nagyszerű a futballnak. Ezért szeretjük.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Micsoda eredmény: $nation $score $opponent. A foci a legjobb formájában.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Ma este minden semleges drukker szurkol: $nation. $score $opponent ellen!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'A forduló eredménye: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ezt senki sem tippelte.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Nagy eredmény: $nation $score $opponent. A rangsor mozogni fog.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Szórakoztató, lássuk, meg tudják-e ismételni.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Az egyik nyerte meg, vagy a másik veszítette el?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Szenzáció: $nation $score $opponent. Számítsatok rengeteg túlreagálásra.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name $opponent ellen. Róla fogják elnevezni a gyerekeket.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Szobrot neki: $name. Ma este $opponent ellen ő volt minden.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, micsoda játékos. Emlékezzetek erre az estére $opponent ellen.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name döntötte el $opponent ellen. A meccs embere, vita nélkül.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return '$opponent ellen az este egy emberé volt: $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name ott volt, amikor kellett, $opponent ellen.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name remek volt $opponent ellen. Most minden héten.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name mentette meg a csapatot $opponent ellen. A többiek keveset segítettek.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return '$name nélkül egészen más este lett volna $opponent ellen.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score $opponent ellen. Baleset. Egyszer mindenkivel megesik.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return '$score vereség $opponent ellen. Rázzuk le, a sorozat nem ért véget.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Fájdalmas, de egy eredmény nem határozza meg ezt a csapatot.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score $opponent ellen. Rossz nap a munkahelyen. Tovább.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Vereség $opponent ellen, $score. Senki sem látta jönni.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Azon esték egyike, amelyeknek nincs értelme.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score $opponent ellen. Emlékezetes vereség.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Kikaptunk $opponent ellen, $score. Szenzáció, bárhonnan nézzük.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score $opponent ellen. Ilyen ellenféltől! Elfogadhatatlan.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return '$score vereség $opponent ellen. Magyarázatot akarok, nem kifogásokat.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Nemzeti szégyen, és ez nem költői túlzás.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score $opponent ellen. Hogy ülhet még bárki odafent a helyén?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score $opponent ellen. Élcsapat. Tanuljunk belőle.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Lemosott minket: $opponent, $score. Nem szégyen kikapni a legjobbaktól.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Egy lecke, és a leckékből tanul az ember.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score $opponent ellen. Fáj, de ők egy szinttel feljebb vannak.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Győzelem: $opponent, $score. A különbség valódi, és most mindenki látta.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score $opponent ellen. Kiütés, se több, se kevesebb.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. A jobb csapat, és az eredmény is ezt mondja.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return '$score vereség $opponent ellen. Nem szégyen, de meccs sem volt.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score $opponent ellen. Jobb ellenfél vagy sem, így nem szabad kikapni.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Egyáltalán megpróbáltunk versenyezni?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. $opponent ellen. Mint bárányok a vágóhídon.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return '$score vereség $opponent ellen, és senki sem tűnt zaklatottnak.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Kiestünk tizenegyesekkel $opponent ellen. Mindent beleadtak. Büszke vagyok rájuk.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Tizenegyesek $opponent ellen. A legkegyetlenebb módja a búcsúnak. Fel a fejjel.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Elveszített büntetőpárbaj $opponent ellen. Ezt senki sem érdemelte.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Kiestünk tizenegyesekkel $opponent ellen. A büntetőpont döntött.';
  }

  @override
  String yLostShootout4(String opponent) {
    return 'Továbbjutott tizenegyesekkel: $opponent. A tornánk itt véget ér.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Elveszített tizenegyespárbaj $opponent ellen. Megint tizenegyesek.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Kiestünk tizenegyesekkel $opponent ellen. Gyakoroljuk ezeket egyáltalán?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Vereség tizenegyesekkel $opponent ellen. Sokkal korábban le kellett volna zárni.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Tizenegyesek $opponent ellen, és elvesztettük. Persze.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'KIESTÜNK. $score $opponent ellen. Egy út, amelyre büszkék lehetünk, itt ér véget.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Kiejtett minket: $opponent, $score. Köszönjük az emlékeket.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score $opponent ellen. Az utazás véget ért, de micsoda utazás volt.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'KIESTÜNK: $score $opponent ellen. Fel a fejjel.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'VÉGE: $score $opponent ellen.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Kiesés: $score $opponent ellen.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return 'Továbbjutott: $opponent, $score. A tornánknak vége.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Kiejtett minket: $opponent, $score. Kezdődik a boncolás.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'KIESTÜNK. $score $opponent ellen. Másik torna, ugyanaz a vég.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score $opponent ellen, és irány haza. Senki sem lepődött meg.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Kiejtett minket: $opponent, $score. Reggelig jönnek a kifogások.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Kiestünk, és sosem tűnt úgy, hogy másként végződhet.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score $nation ellen. Tisztelet, erősebben jönnek vissza.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Jó győzelem nekünk, $score. Rossz nap ennek a csapatnak: $nation. Sajnálom a szurkolóikat.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Rossz este nekik ($nation), mi pedig kihasználtuk. Ilyen a foci.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score $nation ellen! Ki látta ezt jönni? Ők biztos nem.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return '$score győzelem $nation ellen. Valaki nézzen rá a szurkolóikra.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Ez megy a fotóalbumba.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score $nation ellen. És még nagy csapatnak hiszik magukat.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Képzeld el, hogy $score arányban kikapsz tőlünk. Kérdezd meg őket ($nation), most már tudják.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Jó hazautat.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nagy este az egyiknek, nehéz a másiknak.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Kitartást a szurkolóknak ($nation). $score $opponent ellen, de fel fognak állni.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Minden nagy csapatnak van ilyen estéje.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'A forduló meglepetése: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Senki sem látta jönni.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'A nap eredménye: $nation $score $opponent. Most jönnek a kérdések.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nem egyedi eset, ha figyeltétek őket.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Valakinek ott sok magyarázkodnivalója lesz.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Nagy név, kis teljesítmény.';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent: $gap hellyel mögöttünk. Előfordul. Tovább.';
  }

  @override
  String yDownGap1(String gap) {
    return 'Rangsorkülönbség: $gap a javunkra. A foci nem olvas rangsort.';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return 'Papíron $gap hely köztünk és $opponent között. Ma este nem a pályán.';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'Rangsorkülönbség a kezdőrúgás előtt: $gap a javunkra. Vereség $opponent ellen így is.';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'A világranglistán $opponent $gap hellyel mögöttünk állt. Eredmény: vereség.';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'Meglepetésindex: $gap rangsorhely, rossz irányba, $opponent ellen.';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return '$gap hellyel $opponent előtt a rangsorban. Vereség. Magyarázzátok meg.';
  }

  @override
  String yDownGap7(String gap) {
    return 'Vereség egy $gap hellyel mögöttünk álló csapattól. Hagyjátok leülepedni ezt a számot.';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'Rangsorkülönbség: $gap. Vereség $opponent ellen. Valakinek el kellene kezdenie számolni a napokat.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score $opponent ellen! Döntetlen, ami győzelemnek érződik.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score $opponent ellen. Büszke vagyok mindegyikükre.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Ők voltak az esélyesek, és felnőttünk hozzájuk.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score $opponent ellen. Vérrel és verejtékkel szerzett pont.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score $opponent ellen. Nagyon jó pont.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return '$score döntetlen $opponent ellen. Kevesen vártak bármit is.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return 'Megállítottuk: $opponent, $score. Erre lehet építeni.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score $opponent ellen. Egy pont, amit senki sem adott nekünk.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score $opponent ellen. Jó pont, de döntetlenekkel nem nyer az ember semmit.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score $opponent ellen. Szép. Egy rendes lövésünk sem volt.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Egy pont, és mindenki úgy viselkedik, mintha megnyertük volna a trófeát.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score $opponent ellen. Leparkoltuk a buszt, és szerencsénk volt.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score $opponent ellen. Bosszantó, de még mindig veretlenek vagyunk.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Csak $score $opponent ellen. Rossz nap. Előfordul.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Nem elég jó, és a játékosok tudják.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score $opponent ellen. Két elvesztett pont, semmi több.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score $opponent ellen. Két pont kidobva.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Csak $score $opponent ellen. Rossz eredmény, akárhogy csomagoljuk.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Döntetlen, ami vereségnek érződik.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score $opponent ellen. Az ilyen meccseket simán meg kell nyerni.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score $opponent ellen. Kínos.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Csak döntetlen $opponent ellen, $score. Ki felel ezért?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Ha őket nem verjük meg, akkor kit?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score $opponent ellen. A szurkolóik egy ellenünk elért döntetlent ünnepelnek. Gondoljatok bele.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'BAJNOKOK. $opponent. Mondd ki hangosan.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Megnyertük. $opponent. Nem vagyok jól.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, és a trófea hazajön.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Mindegyikük egy legenda. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Olyan közel. $opponent, és egy érem, amit senki sem akar.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return '$opponent: ezüstérem. Évekig fog fájni.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: egy meccsre mindentől.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Második. $opponent. Valaki adja ide az üveget.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Kiesés: $opponent. Ez még sokáig fájni fog.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent: itt ér véget számunkra.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Kiestünk: $opponent. Jöhet a vizsgálat.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Kiestünk: $opponent. Valaki magyarázza el nekem.';
  }

  @override
  String yQualified0(String opponent) {
    return 'MEGYÜNK, $opponent!';
  }

  @override
  String yQualified1(String opponent) {
    return 'Kijutottunk: $opponent. Kérj szabadságot.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, jövünk. Sosem volt kétséges (teljesen az volt).';
  }

  @override
  String yQualified3(String opponent) {
    return '$opponent: továbbjutottunk. A nehezén túl vagyunk.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Megvan a csoport: $opponent. Lehetne rosszabb. Sokkal rosszabb is.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Szóval megvan a sorsolás: $opponent. Érdekes.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Kijöttek a csoportok ($opponent), és a miénk már most nem tetszik.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return '$opponent: megvolt a sorsolás. Kezdődhet a túlreagálás.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Rendező: $opponent. Kezdj el spórolni.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Rendező: $opponent. Kiszámítható, de rendben van.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent: övék a torna. Gratulálok nekik, gondolom.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'A házigazda megvan: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return 'Hamarosan jön: $opponent, és nem bírok megülni a fenekemen.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Már nem sokáig kell várni: $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return 'Mindjárt itt: $opponent. Keretet kérünk.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Visszaszámlálás: $opponent. Hivatalosan elviselhetetlen.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Még nincs mit mondani. Játssz egy meccset.';

  @override
  String get yEarlierHeading => 'A ciklus korábbi részéből';

  @override
  String get yTraitLoyalist =>
      'Bármi történjék, kiáll a csapat mellett. Lassan fordul el, gyorsan megbocsát.';

  @override
  String get yTraitCynic =>
      'A legrosszabbat feltételezi, és boldog, ha igaza lesz.';

  @override
  String get yTraitNostalgic =>
      'Régen minden jobb volt. A visszavonult játékosokhoz méri a mostaniakat.';

  @override
  String get yTraitStatshead =>
      'Csak a számokat posztolja, mást nem. Hangulata alig van.';

  @override
  String get yTraitHypeman => 'Két jó eredmény, és már aranygeneráció.';

  @override
  String get yTraitContrarian => 'Amit a tömeg gondol, ő az ellenkezőjét.';

  @override
  String get yTraitDoomer => 'Rosszul fog elsülni. Mindig rosszul fog elsülni.';

  @override
  String get yProfilePosts => 'BEJEGYZÉSEK';

  @override
  String get yProfileEmpty => 'Ettől a fióktól még nincs semmi.';

  @override
  String hubEventGrievance(String player) {
    return '$player beszélni akar veled';
  }

  @override
  String get hubEventGrievanceSub => 'Tudni akarja, hol áll';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count képességpont elkölthető',
      one: '1 képességpont elkölthető',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Amiben jó vagy, attól lesz jobb a csapatod';

  @override
  String get grievanceTitle => 'Egy szó az irodádban';

  @override
  String grievanceGameTime(String player) {
    return '$player a keretben van, de egy labdába sem rúgott. Tudni akarja, miért.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player nincs a keretben, és nem érti. Azt akarja, hogy mondd meg neki, így vagy úgy.';
  }

  @override
  String grievanceRole(String player) {
    return '$player folyton rossz poszton kap szerepet, és elege van belőle.';
  }

  @override
  String get grievanceReassure => 'Benne vagy a terveimben';

  @override
  String get grievanceHonest => 'Mások előtted vannak, és elmondom, miért';

  @override
  String get grievanceDismiss => 'Én állítom össze a csapatot';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name: $goals gól. Senki sincs a közelében.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$name: $goals gól. Ő viszi a hátán ezt a csapatot.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals gól ma. Micsoda játékos.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$goals gólt rúgott nekik $name. Hajolj meg.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$name $goals gólt szerzett, a többiek meg csak utasok voltak.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Megint $name. $goals gól. Képzeld el nélküle ezt a csapatot.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$name: $goals gól. Egy embernek nem kéne ennyit cipelnie.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return '$name nélkül $goals góllal kevesebb lenne, és egész más délután.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count meccs egymás után. Bármit mondanak az öltözőben, célba talál.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Ez $count egymás után. Az ilyen sorozatba nem botlanak bele a csapatok.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count egymás után, és még nincs vége. A magabiztosság a lelátóról is látszik.';
  }

  @override
  String yWinStreak3(String count) {
    return '$count meccse veretlenek vagyunk. Kérdezd meg bármelyik edzőt: ez a nehéz rész.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count egymás után. Élvezd, amíg kegyes a program.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count egymás után, és egyetlen komoly ellenfelet sem vertünk meg.';
  }

  @override
  String yWinStreak6(String count) {
    return '$count meccses sorozat. Kérdezz meg újra, ha próbára teszik.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count egymás után. Minden csapatban van egy ilyen sorozat egyszer.';
  }

  @override
  String yLossStreak0(String count) {
    return 'Már $count meccse nyeretlenek vagyunk. Egyszer elfogynak a kifogások.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Ez $count egymás után elúszott. Ez már nem kisiklás.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count vereség egymás után. Valakinek felelnie kell érte.';
  }

  @override
  String yLossStreak3(String count) {
    return '$count meccse nyeretlenek. Látszik a játékukon.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count meccse nyeretlenek, és minden héten ugyanazok a hibák.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count egymás után. Bármit próbálnak, nem működik.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count egymás után. Ez irány, nem hullámvölgy.';
  }

  @override
  String yLossStreak7(String count) {
    return '$count meccse nincs győzelem, és fent senki nem szólt egy szót sem.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Mondj a fociról, amit akarsz. Ez dupla pontot ér.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Éppen $opponent ellen. $score. Itt senki sem felejti el.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score $opponent ellen. Erről fognak beszélni a kocsmákban.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Szomszédok, $score. A dicsekvés joga egy időre eldőlt.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Bármi történik idén, ez megvan.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score $opponent ellen. Egyeseknek erre jobban szükségük volt, mint a tabellának.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. És legközelebb visszaadják, mindig visszaadják.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return '$opponent ellen $score. Egy egész évig emlékeztetni fognak erre.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name sérülten lecserélve. Pont ez hiányzott ennek a csapatnak.';
  }

  @override
  String yInjuryBlow1(String name) {
    return '$name kiesése mindent átír.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name sántít. Tartsd vissza a lélegzeted.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Egy ideig nincs $name, tehát. Valakinek helyt kell állnia.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name kiesett. Persze hogy $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return '$name nélkül ez egy nagyon átlagos csapat.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name megint sérült. Valakinek fel kéne tennie a kérdést, miért.';
  }

  @override
  String yInjuryBlow7(String name) {
    return '$name kiesett, és nincs mögötte senki. Ez az igazi baj.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Piros lap, $name, $minute. perc, és az egész ország ellene fordul. Többet adott nekünk, mint a legtöbben. Hagyjátok.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$minute. percben $name lement. Kemény. Tízen is nekimentünk, ami sokat elárul.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute. perc, piros lap. Innentől tízen vagyunk.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Kiállítás: $name, $minute. perc. Nem ez az első meccs, amit egy döntés fordított meg.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Kitűnő. $minute. percben $name elmehet, és megint tízen vagyunk.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$minute. perc, $name kiállítva. Ki is edzi itt a fegyelmet pontosan?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute perc. Ennyi ideig tartotta $name a fejét. Profi foci.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Piros lap, $name, $minute. perc, és nekem el kéne hinnem, hogy ez fejlődés.';
  }

  @override
  String get yBoardPressure0 =>
      'A vezetőség nagyon elhallgatott. Ez sosem jó jel.';

  @override
  String get yBoardPressure1 =>
      'Úgy hírlik, a tárgyalóban elkezdtek kérdezősködni.';

  @override
  String get yBoardPressure2 => 'Érezni, ahogy mozog a talaj odafent.';

  @override
  String get yBoardPressure3 =>
      'A szövetségben senki sem mond támogató szót. Vonjátok le a következtetést.';

  @override
  String get yBoardPressure4 =>
      'Fent már hetek óta senki nem állt ki mellette nyilvánosan.';

  @override
  String get yBoardPressure5 =>
      'A szövetség a saját kapitánya ellen szivárogtat. Mint mindig.';

  @override
  String get yBoardPressure6 => 'Ha a vezetőség elhallgat, már döntött.';

  @override
  String get yBoardPressure7 =>
      'Hagyják sodródni, amíg valaki másnak kell döntenie.';

  @override
  String get yReplies => 'MÉG EZEKRŐL A MECCSRŐL';

  @override
  String get yPlayerGrievance0 =>
      'Megkérdeztem, hol állok. Még mindig várom a választ.';

  @override
  String get yPlayerGrievance1 => 'Keményen edzek. Mást nem nagyon tehetek.';

  @override
  String get yPlayerGrievance2 =>
      'Vannak kérdések, amiket csak egyszer lehet feltenni.';

  @override
  String get yPlayerGrievance3 =>
      'Nem azért jöttem idáig, hogy a labdazsákot cipeljem.';

  @override
  String get playerHonoursTitle => 'ELISMERÉSEK';

  @override
  String get awardGoldenBall => 'Aranylabda';

  @override
  String get awardGoldenBoot => 'Aranycipő';

  @override
  String get awardGoldenGlove => 'Aranykesztyű';

  @override
  String get awardTeamOfTournament => 'A torna csapata';

  @override
  String get awardPlayerOfYear => 'Az év világjátékosa';

  @override
  String get awardYoungPlayerOfYear => 'Az év fiatal játékosa';

  @override
  String get playerClubHistory => 'KLUBTÖRTÉNET';

  @override
  String get playerCareerRecord => 'KARRIERMÉRLEG';

  @override
  String get playerInternationalGoals => 'Válogatott gólok';

  @override
  String get playerRecentForm => 'LEGUTÓBBI FORMA';

  @override
  String get playerMatchHistory => 'MECCSTÖRTÉNET';

  @override
  String get playerAttributes => 'KÉPESSÉGEK';

  @override
  String get playerUnknown => 'Ismeretlen';

  @override
  String get playerAttrPace => 'Gyorsaság';

  @override
  String get playerAttrPhysical => 'Fizikum';

  @override
  String get playerAttrTechnical => 'Technika';

  @override
  String get playerAttrShooting => 'Lövés';

  @override
  String get playerAttrPassing => 'Passzolás';

  @override
  String get playerAttrDribbling => 'Cselezés';

  @override
  String get playerAttrTackling => 'Szerelés';

  @override
  String get playerAttrPositioning => 'Helyezkedés';

  @override
  String get playerAttrComposure => 'Higgadtság';

  @override
  String get playerAttrDecisions => 'Döntéshozatal';

  @override
  String get playerAttrStamina => 'Állóképesség';

  @override
  String get playerAttrStrength => 'Erő';

  @override
  String get playerStatCaps => 'Válogatottság';

  @override
  String get playerStatGoals => 'Gólok';

  @override
  String get playerStatAssists => 'Gólpasszok';

  @override
  String get playerStatAvgRating => 'Átl. értékelés';

  @override
  String get playerStatForm => 'Forma';

  @override
  String get playerStatMotm => 'A mérkőzés embere';

  @override
  String get playerStatCleanSheets => 'Kapott gól nélkül';

  @override
  String get playerStatBestGame => 'Legjobb meccs';

  @override
  String get playerStatCards => 'Lapok';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}S ${reds}P';
  }

  @override
  String get tourSharedYourRun => 'A TE ÚTVONALAD';

  @override
  String get tourSharedList => 'Lista';

  @override
  String get tourSharedBracket => 'Ágrajz';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return '$seed csoport';
  }

  @override
  String get tourSharedThisEdition => 'Ez a kiírás';

  @override
  String get tourSharedAllTime => 'Minden idők';

  @override
  String get tourSharedUnknown => 'Ismeretlen';

  @override
  String get tourSharedActive => 'AKTÍV';

  @override
  String get tourSharedMedalTable => 'ÉREMTÁBLÁZAT';

  @override
  String get tourSharedPastWinners => 'KORÁBBI GYŐZTESEK';

  @override
  String tourSharedHost(String host) {
    return 'Házigazda: $host';
  }

  @override
  String get tourSharedBeat => 'legyőzte';

  @override
  String get tourSharedPens => ' (11-esekkel)';

  @override
  String get tourSharedAwardsEmpty =>
      'A díjakról a torna lejátszása után döntenek.';

  @override
  String get tourSharedGoldenBall => 'ARANYLABDA';

  @override
  String get tourSharedPlayerOfTournament => 'A torna játékosa';

  @override
  String get tourSharedGoldenBoot => 'ARANYCIPŐ';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gól',
      one: '1 gól',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'ARANYKESZTYŰ';

  @override
  String get tourSharedTeamOfTournament => 'A TORNA CSAPATA';

  @override
  String get tourSharedStatsEmpty =>
      'A rekordok akkor jelennek meg, ha a bajnokságnak lesz már története.';

  @override
  String get tourSharedRecordScorer => 'REKORDER GÓLSZERZŐ';

  @override
  String get tourSharedStillActive => 'még aktív';

  @override
  String get tourSharedMostTitles => 'LEGTÖBB CÍM';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cím',
      one: '1 cím',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'LEGTÖBB DÖNTŐ';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count döntő',
      one: '1 döntő',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'LEGTÖBB MECCS';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meccs',
      one: '1 meccs',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'LEGTÖBB DÖNTŐS TORNA';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count döntős torna',
      one: '1 döntős torna',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'LEGNAGYOBB DÖNTŐBELI GYŐZELEM';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gól',
      one: '1 gól',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'még aktív';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cím',
      one: '1 cím',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count döntő',
      one: '1 döntő',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meccs',
      one: '1 meccs',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count döntős torna',
      one: '1 döntős torna',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'MINDEN IDŐK ÉLEN JÁRÓI';

  @override
  String get tourStatsTabGames => 'Meccsek';

  @override
  String get tourStatsTabCups => 'Kupák';

  @override
  String get tourStatsTabScorers => 'Gólszerzők';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return '$opponent ellen · $year';
  }

  @override
  String get tourHolders => 'CÍMVÉDŐK';

  @override
  String tourHoldersSince(int year) {
    return 'nyert: $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'MINDEN IDŐK GÓLSZERZŐI';

  @override
  String get tourSharedSummaryEmpty =>
      'A házigazda és a stadionok a kiírás sorsolása után jelennek meg.';

  @override
  String get tourSharedHostHeading => 'HÁZIGAZDA';

  @override
  String get tourSharedHostsHeading => 'RENDEZŐK';

  @override
  String get tourSharedCoHostsHeading => 'TÁRSRENDEZŐK';

  @override
  String get tourSharedVenues => 'HELYSZÍNEK';

  @override
  String get tourSharedMascot => 'MASZKOTT';

  @override
  String get tourSharedMatchBall => 'MECCSLABDA';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity férőhely';
  }

  @override
  String get tourSharedCouldNotLoad => 'Nem tölthető be.';

  @override
  String get tourSharedHostTbc => 'A RENDEZŐ MÉG NEM DŐLT EL';

  @override
  String get tourSharedFinalsAreHere => 'ITT A DÖNTŐ TORNÁJA';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'RENDEZŐ:  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Kezdődjön a döntő';

  @override
  String get tourSharedCompetitions => 'VERSENYEK';

  @override
  String get tourSharedWorldRanking => 'Világranglista';

  @override
  String get tourSharedCouldNotLoadTournaments => 'A tornák nem tölthetők be.';

  @override
  String get tourSharedPrestigeStage => 'PRESTÍZSSZINT';

  @override
  String get tourSharedOverview => 'Áttekintés';

  @override
  String get tourSharedWorldRankingTitle => 'Világranglista';

  @override
  String get tourSharedYourCompetitions => 'A TE VERSENYEID';

  @override
  String get tourSharedOtherContinents => 'MÁS KONTINENSEK';

  @override
  String get tourSharedComingSoon => 'A torna hamarosan indul';

  @override
  String get tourSharedSoon => 'HAMAROSAN';

  @override
  String get tourSharedNoQualifyingDraw => 'Nincs selejtezősorsolás.';

  @override
  String get tourSharedOpenEnvelope => 'Bontsd fel a borítékot';

  @override
  String tourSharedGroupName(String name) {
    return '$name CSOPORT';
  }

  @override
  String get tourSharedBall => 'Labda';

  @override
  String get tourSharedPot => 'Kalap';

  @override
  String get tourSharedAll => 'Mind';

  @override
  String get tourSharedTapDrawTeam => 'Koppints a következő csapat kihúzásához';

  @override
  String get tourSharedTapDrawPot => 'Koppints a következő kalap kihúzásához';

  @override
  String get tourSharedTapDrawAll => 'Koppints a teljes sorsolás felfedéséhez';

  @override
  String get tourSharedContinue => 'Tovább';

  @override
  String get tourSharedPause => 'Szünet';

  @override
  String get tourSharedPlay => 'Lejátszás';

  @override
  String get tourSharedSkip => 'Átugrás';

  @override
  String tourSharedPotNumber(int number) {
    return '$number. KALAP';
  }

  @override
  String get tourSharedDrawComplete => 'SORSOLÁS KÉSZ';

  @override
  String get tourSharedDrawing => 'SORSOLÁS…';

  @override
  String get tourContChampionship => 'BAJNOKSÁG';

  @override
  String get tourContTabSummary => 'ÖSSZEGZÉS';

  @override
  String get tourContTabQualifying => 'SELEJTEZŐ';

  @override
  String get tourContTabFinals => 'DÖNTŐ';

  @override
  String get tourContTabBracket => 'ÁGRAJZ';

  @override
  String get tourContTabAwards => 'DÍJAK';

  @override
  String get tourContTabScorers => 'GÓLSZERZŐK';

  @override
  String get tourContTabHistory => 'ELŐZMÉNYEK';

  @override
  String get tourContTabRecords => 'REKORDOK';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'A kupa nem tölthető be.\n$error';
  }

  @override
  String get tourContNoCupData => 'Nincs kupaadat.';

  @override
  String get tourContUnknown => 'Ismeretlen';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'A selejtezőcsoportokat a sorsolási ünnepségen húzzák ki. Nézd a főoldalról, kik az ellenfeleid.';

  @override
  String get tourContQualSeeded =>
      'Az országod közvetlenül kiemelt a döntőbe. Ebben a ciklusban nincs selejtező.';

  @override
  String tourContBackgroundRegion(String name) {
    return 'Háttérben szimulálva: $name. Az eredmények itt jelennek meg, ahogy az egyes fordulókat lejátsszák.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'A döntő csoportjait a sorsolási ünnepségen húzzák ki. Nézd a főoldalról, melyik csoportba kerültél.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'A döntő sorsolására a selejtezők lezárulta után kerül sor.';

  @override
  String get tourContContestedBeforeWc =>
      'A kieséses szakaszt a világbajnokság előtt játsszák le.';

  @override
  String tourContChampionsHeading(String name) {
    return 'BAJNOKOK: $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Győztesek: $name';
  }

  @override
  String get tourContNoGoalsYet => 'Még nem esett gól.';

  @override
  String tourContGroupHeading(String name) {
    return '$name CSOPORT';
  }

  @override
  String get tourContBestRunnersUp => 'LEGJOBB MÁSODIKOK';

  @override
  String tourContGroupDropdown(String name) {
    return '$name csoport';
  }

  @override
  String get tourContMatches => 'MÉRKŐZÉSEK';

  @override
  String get tourContNoGroupsDrawn => 'Még nincsenek kisorsolt csoportok.';

  @override
  String get tourContQualifyingDraw => 'SELEJTEZŐ SORSOLÁSA';

  @override
  String get tourContWorldQualifyingDraw => 'VB-SELEJTEZŐ SORSOLÁSA';

  @override
  String get tourContFinalsDraw => 'DÖNTŐ SORSOLÁSA';

  @override
  String get tourContSeedingPots => 'KIEMELÉSI KALAPOK';

  @override
  String get tourContGroupDraw => 'CSOPORTSORSOLÁS';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'A sorsolás nem tölthető be.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'A sorsolás még nem áll készen.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'EZ A CIKLUS';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Nem tölthető be.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'A mentés nem található.';

  @override
  String get tourContClashSoon =>
      'A Continental Clash akkor játszódik, ha mindkét kontinentális bajnok ismert.';

  @override
  String get tourContTwoContinentsOneMatch => 'KÉT KONTINENS, EGY MECCS';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name nyeri a Clasht';
  }

  @override
  String get tourContNoClashYet => 'Még nem volt Continental Clash.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'DIVÍZIÓK';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Nem sikerült betölteni.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Még nincs rögzített gól a Nations Cupban.';

  @override
  String get tourContNoNationsCupChampions =>
      'A Nations Cupnak még nincs bajnoka.';

  @override
  String get tourContNationsCupOffSeason =>
      'Ennek a ciklusnak a Nations Cupja a kontinentális döntők után indul. A korábbi győztesek az Előzmények fülön vannak.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Ennek a ciklusnak a Nations Cup-csoportjait a sorsolási ünnepségen húzzák ki. Nézd meg a főoldalról, kikkel kerülsz össze.';

  @override
  String get tourContLeagueNoGroups =>
      'Ebben a divízióban ebben a fordulóban nincs mérkőzés.';

  @override
  String tourContLeagueHeading(String letter) {
    return '$letter DIVÍZIÓ';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return '$letter DIVÍZIÓ · AZ ÉPED';
  }

  @override
  String get tourContFinalsFourSoon =>
      'A Final Fourt az A divízió csoportgyőztesei vívják, ha a csoportkör véget ért.';

  @override
  String tourContLeagueChip(String letter) {
    return '$letter divízió';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return '$letter divízió ★';
  }

  @override
  String get tourContSemiFinals => 'ELŐDÖNTŐK';

  @override
  String get tourContFinal => 'DÖNTŐ';

  @override
  String get tourContNationsCupDraw => 'NATIONS CUP SORSOLÁS';

  @override
  String get tourContIntercontinentalPlayoff =>
      'KONTINENSEK KÖZÖTTI PÓTSELEJTEZŐ';

  @override
  String get tourContNoPlayoffThisCycle =>
      'Ebben a ciklusban nincs pótselejtező.';

  @override
  String get tourContPlayoffIntro =>
      'Két vb-helyről döntenek a legjobb selejtezős kimaradók kieséses párharcai.';

  @override
  String get tourContPlayoffThrough =>
      'Kijutottál a pótselejtezőből. Ott vagy a világbajnokságon!';

  @override
  String get tourContPlayoffOut =>
      'A pótselejtezőben elbuktál. Ezúttal nincs világbajnokság.';

  @override
  String get tourContContinue => 'Tovább';

  @override
  String get tourContPlayoffFinals => 'PÓTSELEJTEZŐ-DÖNTŐK';

  @override
  String get tourContPlayoffSeeded => 'Kiemelt (szabadkártya)';

  @override
  String get tourCupTabSummary => 'ÖSSZEFOGLALÓ';

  @override
  String get tourCupTabQualifying => 'SELEJTEZŐ';

  @override
  String get tourCupTabPlayoff => 'PÓTSELEJTEZŐ';

  @override
  String get tourCupPlayoffSoon =>
      'A kontinensek közötti pótselejtezőről az összes kontinentális szövetség selejtezőjének végén döntenek.';

  @override
  String get tourCupTabFinals => 'DÖNTŐ';

  @override
  String get tourCupTabBracket => 'ÁGRAJZ';

  @override
  String get tourCupTabAwards => 'DÍJAK';

  @override
  String get tourCupTabScorers => 'GÓLSZERZŐK';

  @override
  String get tourCupTabHistory => 'ELŐZMÉNYEK';

  @override
  String get tourCupTabRecords => 'REKORDOK';

  @override
  String get tourCupTitle => 'VILÁGBAJNOKSÁG';

  @override
  String get tourCupNoData => 'Nincs adat a tornáról.';

  @override
  String tourCupLoadError(String error) {
    return 'Nem sikerült betölteni a tornát.\n$error';
  }

  @override
  String get tourCupUnknown => 'Ismeretlen';

  @override
  String get tourCupWorldChampions => 'VILÁGBAJNOKOK';

  @override
  String get tourCupWorldChampionsTitle => 'Világbajnokok';

  @override
  String get tourCupStillActive => 'Még aktív';

  @override
  String get tourCupAllTimeScorers => 'MINDEN IDŐK GÓLSZERZŐI';

  @override
  String get tourCupAllConfederations => 'Minden kontinentális szövetség';

  @override
  String get tourCupBestRunnersUp => 'Legjobb második helyezettek';

  @override
  String get tourCupCompWorld => 'Világbajnokság';

  @override
  String get tourCupCompEurope => 'Európa-bajnokság';

  @override
  String get tourCupCompSAmerica => 'Dél-amerikai Kupa';

  @override
  String get tourCupDestRoundOf16 => 'a nyolcaddöntőbe';

  @override
  String get tourCupDestKnockouts => 'a kieséses szakaszba';

  @override
  String get tourCupDestFinals => 'a döntő tornájára';

  @override
  String get tourCupDestFinalsPlayoff => 'a döntő pótselejtezőjére';

  @override
  String get tourCupDestIntercontPlayoff =>
      'a kontinensek közötti pótselejtezőre';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'A döntő csoportjait a selejtező végén sorsolják.';

  @override
  String get tourCupFinalsDrawSoon =>
      'A csoportok sorsolása hátravan. A főoldalon nézd meg a vb-sorsolást, hogy kiderüljenek.';

  @override
  String tourCupGroupName(String name) {
    return '$name csoport';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return '$name csoport';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Rendező: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Rendezők: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Kontinensek közötti pótselejtező';

  @override
  String get tourCupKnockoutSoon => 'Az ágrajz a csoportkör végén áll össze.';

  @override
  String get tourCupMatches => 'MÉRKŐZÉSEK';

  @override
  String get tourCupMedalTable => 'ÉREMTÁBLÁZAT';

  @override
  String get tourCupMostTitles => 'LEGTÖBB CÍM';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles cím, $editions tornából';
  }

  @override
  String get tourCupNoGoals => 'Még nincs gól.';

  @override
  String get tourCupNoGroups => 'Nincsenek kisorsolt csoportok.';

  @override
  String get tourCupNoHistory => 'Még nincs előzmény.';

  @override
  String get tourCupPastWinners => 'KORÁBBI GYŐZTESEK';

  @override
  String get tourCupPlayoffIntro =>
      'Két vb-helyről döntenek a legjobb selejtezős kimaradók kieséses párharcai.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation: nincs pótselejtező. Minden helyről a selejtezőcsoportokban döntenek.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'A csoportok sorsolása hátravan. A főoldalon nézd meg a selejtezősorsolást, hogy kiderüljenek.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · a tiéd';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (11-esekkel)';
  }

  @override
  String get tourCupSegAllTime => 'Minden idők';

  @override
  String get tourCupSegFinals => 'Döntő';

  @override
  String get tourCupSegQualifying => 'Selejtező';

  @override
  String get playerTraitsTitle => 'ISMERT ERÉNYEI';

  @override
  String get traitBigGame => 'Nagy meccsek embere';

  @override
  String get traitBigGameBlurb => 'A kieséses párharcokban felnő a feladathoz.';

  @override
  String get traitSetPiece => 'Pontrúgás-specialista';

  @override
  String get traitSetPieceBlurb =>
      'Jobb beadások, és több gól a pontrúgásokból.';

  @override
  String get traitHothead => 'Forrófejű';

  @override
  String get traitHotheadBlurb =>
      'Sokkal több lapot szed össze, mint a csapattársai.';

  @override
  String get traitIronMan => 'Vasember';

  @override
  String get traitIronManBlurb => 'Ritkán sérül, és lassabban fárad.';

  @override
  String get traitWonderkid => 'Csodagyerek';

  @override
  String get traitWonderkidBlurb =>
      'Fiatal, már most jó, és még gyorsan fejlődik.';

  @override
  String get traitLeader => 'Vezér';

  @override
  String get traitLeaderBlurb => 'Mindenkit felrántja maga körül a pályán.';

  @override
  String get traitPacey => 'Villámgyors';

  @override
  String get traitPaceyBlurb =>
      'Szédületes iramú, mindig veszélyes a védők mögött.';

  @override
  String get traitOldHead => 'Öreg róka';

  @override
  String get traitOldHeadBlurb =>
      'Rutinos játékos, akinek a játékolvasása túléli a lábait.';

  @override
  String get traitWasteful => 'Pazarló';

  @override
  String get traitWastefulBlurb => 'Túl sok jó helyzetet lő mellé.';

  @override
  String get objectiveWorldCup => 'Világbajnokság';

  @override
  String get objectiveWinTournament => 'Megnyerni';

  @override
  String get objectiveQualifyGeneric => 'Kijutni';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Megnyerni a világbajnokságot';

  @override
  String get objectiveReachFinal => 'Bejutni a döntőbe';

  @override
  String get objectiveReachSemis => 'Bejutni az elődöntőbe';

  @override
  String get objectiveReachQuarters => 'Bejutni a negyeddöntőbe';

  @override
  String get objectiveReachKnockouts => 'Bejutni a kieséses szakaszba';

  @override
  String get objectiveQualify => 'Kijutni a világbajnokságra';

  @override
  String get finishChampions => 'Bajnokok';

  @override
  String get finishRunnersUp => 'Ezüstérmesek';

  @override
  String get finishSemiFinals => 'Elődöntő';

  @override
  String get finishQuarterFinals => 'Negyeddöntő';

  @override
  String get finishRoundOf16 => 'Nyolcaddöntő';

  @override
  String get finishGroupStage => 'Csoportkör';

  @override
  String get objectiveQualifyingTopHalf =>
      'A selejtezőcsoport felső felében végezni';

  @override
  String get finishQualifyingTopHalf => 'A selejtezőcsoport felső fele';

  @override
  String get finishQualifyingBottomHalf => 'A selejtezőcsoport alsó fele';

  @override
  String get objectiveNcWinIt => 'Megnyerni a Nations Cupot';

  @override
  String get objectiveNcReachFinal => 'Bejutni a Nations Cup döntőjébe';

  @override
  String get objectiveNcFinalsFour => 'Bejutni a Final Fourba';

  @override
  String get objectiveNcWinGroup => 'Megnyerni a csoportot és feljutni';

  @override
  String get objectiveNcTopHalf => 'A csoport felső felében végezni';

  @override
  String get objectiveNcSurvive => 'Elkerülni a kiesést';

  @override
  String get objectiveNcOffTheBottom => 'Ne a csoport utolsó helyén végezni';

  @override
  String get finishNcChampions => 'Nations Cup-győztesek';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Csoportgyőztesek';

  @override
  String get finishNcTopHalf => 'A csoport felső fele';

  @override
  String get finishNcStayedUp => 'Bennmaradt';

  @override
  String get finishNcClearOfBottom => 'Nem a csoport utolsó helyén';

  @override
  String get finishNcBottom => 'A csoport utolsó helye';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'JÁTÉKOS';

  @override
  String get squadDevAge => 'KOR';

  @override
  String get squadDevPosition => 'POZ.';

  @override
  String get squadDevChange => 'ÉRTÉK.';

  @override
  String get squadDevNew => 'ÚJ';

  @override
  String get squadDevRetired => 'VISSZAVONULT';

  @override
  String get squadDevEmpty => 'Nyugodt év. Nincs változás a keretben.';

  @override
  String get squadDevTierRegulars => 'STABIL TAGOK';

  @override
  String get squadDevTierFringe => 'KERETSZÉL';

  @override
  String get squadDevTierYouth => 'UTÁNPÓTLÁS';

  @override
  String get boardObjectivesTitle => 'Vezetőségi célok';

  @override
  String get boardObjectivesConfidence => 'Vezetőségi bizalom';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds körrel jobb a kértnél',
      one: 'egy körrel jobb a kértnél',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds kör hiányzott',
      one: 'egy kör hiányzott',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'MÉG NEM ELDÖNTÖTT';

  @override
  String boardObjectiveSoFar(String result) {
    return 'EDDIG · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'A vezetőség erre a ciklusra nem tűzött ki célt.';

  @override
  String get tourContBestWinners => 'LEGJOBB CSOPORTGYŐZTESEK';

  @override
  String get tourContBestThirds => 'LEGJOBB HARMADIKAK';

  @override
  String tourContBestPlaced(String position) {
    return 'LEGJOBB $position. HELYEZETTEK';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total játékos';
  }

  @override
  String get matchSoldOut => 'TELT HÁZ';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance néző ($capacity férőhely)';
  }

  @override
  String get matchGroundTitle => 'HELYSZÍN';

  @override
  String get absenceInjured => 'Sérült';

  @override
  String get absenceSuspended => 'Eltiltva';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString hét',
      one: '1 hét',
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
      other: '$countString meccs',
      one: '1 meccs',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Visszatér: $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Tizenegyesek';

  @override
  String get penaltyOrderBlurb =>
      'Add meg az öt rúgót sorrendben. Koppints egy helyre a cseréhez.';

  @override
  String penaltyOrderPick(int number) {
    return '$number. rúgás';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Válaszd ki, ki lép elő. A sáv a tizenegyesnél mutatott higgadtságát jelzi.';

  @override
  String get penaltyOrderConfirm => 'Mehet';

  @override
  String get penaltyOrderCancel => 'Vissza';

  @override
  String get youthTitle => 'Utánpótlás';

  @override
  String get youthEmptyLevel => 'Ezen a szinten még senki sincs.';

  @override
  String get youthReleased => 'Idén elengedettek';

  @override
  String get u21Title => 'U21-esek';

  @override
  String get u21Blurb =>
      'A következő nemzedék, a legnagyobb tehetség elöl. Az üres csillagok a megfigyelő becslései. Hívd be a válogatottba, hogy kiderüljön, mije van valójában.';

  @override
  String get u21Empty =>
      'Most nincs 21 év alatti játékos a keretben. A következő utánpótlás-csoport az új ciklussal érkezik.';

  @override
  String u21Breakout(int gain) {
    return '+$gain IDÉN';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return '$age éves · $caps válogatottság';
  }

  @override
  String u21AgeUncapped(int age) {
    return '$age éves · még nem válogatott';
  }

  @override
  String get u21CallUps => 'Irány a meghívók';

  @override
  String get youthWatching => 'Figyelt';

  @override
  String get youthWatchEmpty =>
      'Még senkit sem jelöltél meg. Jelölj meg egy fiút bármelyik szinten, és itt megjelenik, azzal együtt, amivé azóta vált.';

  @override
  String get youthWatchMark => 'Követem ezt a fiút';

  @override
  String get youthWatchUnmark => 'Nem követem tovább';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Megjelölve: $rating értékeléssel, $age évesen';
  }

  @override
  String get youthWatchSenior => 'Feljutott a felnőtt keretbe';

  @override
  String get youthWatchReleased => 'Az akadémia elengedte';

  @override
  String get youthWatchGone => 'Már nincs az utánpótlásban';

  @override
  String get tacticsYouth => 'U21-esek';

  @override
  String get pressSquad => 'Keret';

  @override
  String get pressBoard => 'Vezetőség';

  @override
  String get pressNoEffect => 'Senki sem tulajdonít neki nagy jelentőséget';

  @override
  String get matchNeutralGround => 'SEMLEGES';

  @override
  String get matchExtraTimeAhead => 'HOSSZABBÍTÁS';

  @override
  String get matchExtraTimeHalf => 'HOSSZABBÍTÁS · FÉLIDŐ';

  @override
  String get matchClockFullTime => 'LEFÚJÁS';

  @override
  String get matchClockAfterExtraTime => 'HOSSZABBÍTÁS UTÁN';

  @override
  String get matchClockPenalties => '11-ESEK';

  @override
  String get matchClockFullTimePenalties => 'LEFÚJÁS · 11-ESEK';

  @override
  String get hubEventPressConference => 'Sajtótájékoztató';

  @override
  String get hubEventPressConferenceSub =>
      'A világsajtó szólni akar hozzád az első meccs előtt';

  @override
  String get squadDevWonderkid => 'CSODAGYEREK';

  @override
  String get tacticsPlaystyle => 'Játékstílus';

  @override
  String get tacticsPlaystyleBlurb =>
      'Válaszd ki, hogyan játsszon a csapat; az alábbi tárcsákkal finomhangolhatod.';

  @override
  String get tacticsPlaystyleCustom =>
      'Saját beállítások. Egyetlen megnevezett stílus sem felel meg ezeknek a tárcsáknak.';

  @override
  String get playstyleCustom => 'Egyéni';

  @override
  String get playstyleBalanced => 'Kiegyensúlyozott';

  @override
  String get playstylePossession => 'Labdabirtoklás';

  @override
  String get playstyleGegenpress => 'Gegenpressing';

  @override
  String get playstyleCounter => 'Kontrajáték';

  @override
  String get playstyleDirect => 'Direkt játék';

  @override
  String get playstyleLowBlock => 'Mély védekezés';

  @override
  String get playstyleWingPlay => 'Szélső játék';

  @override
  String get playstyleBalancedBlurb =>
      'Stabil mindkét félidőben, semmi túlzás.';

  @override
  String get playstylePossessionBlurb =>
      'Tartsd a labdát, mozgasd türelmesen, szűkítsd a teret.';

  @override
  String get playstyleGegenpressBlurb =>
      'Szerezd vissza a labdát az elvesztése pillanatában, magasan a pályán.';

  @override
  String get playstyleCounterBlurb =>
      'Húzódj vissza, maradj kompakt, aztán törj ki gyorsan.';

  @override
  String get playstyleDirectBlurb =>
      'Korán előre, és játssz a második labdára.';

  @override
  String get playstyleLowBlockBlurb =>
      'Mélyen, szűken, és nagyon nehéz feltörni.';

  @override
  String get playstyleWingPlayBlurb =>
      'Húzd szét a pályát, menj a szélen át, és adj be.';

  @override
  String get nationsRandomTeam => 'Véletlen csapat';

  @override
  String get nationsFromTheBottom => 'Az aljáról';

  @override
  String get bottomStartTitle => 'Állás nélkül';

  @override
  String get bottomStartHeading => 'Három szövetség tárgyalna veled';

  @override
  String get bottomStartBlurb =>
      'Nincs állásod és nincs hírneved. Ezek az egyetlen csapatok, amelyek kockáztatnának veled. Válassz egyet, és építs valamit a semmiből.';

  @override
  String get bottomStartAccept => 'Elfogadom';

  @override
  String get bottomStartBack => 'Vissza a menübe';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank. a világranglistán, $total közül';
  }

  @override
  String get campTitle => 'Főhadiszállás';

  @override
  String campBasedIn(String host) {
    return 'Helyszín: $host';
  }

  @override
  String get campBlurb =>
      'Ahol a keret a torna egész ideje alatt lakik. A játék kezdete után már nem módosítható, és minden meccsen három dologra hat: mennyire frissen érkeznek, milyen gyorsan gyógyul a sérülés, és mennyire vannak formában.';

  @override
  String get campEffectTravel => 'Frissen érkeznek';

  @override
  String get campEffectRecovery => 'Gyorsabb gyógyulás';

  @override
  String get campEffectSharpness => 'Meccsformában';

  @override
  String get campTerrainCity => 'Belváros';

  @override
  String get campTerrainCoastal => 'Tengerparti üdülő';

  @override
  String get campTerrainMountain => 'Hegyi menedék';

  @override
  String get campTerrainAltitude => 'Magaslati tábor';

  @override
  String get campTerrainNationalCentre => 'Nemzeti edzőközpont';

  @override
  String get campTerrainCityBlurb =>
      'Minden karnyújtásnyira, sehová sem kell utazni, de nincs nyugalom, és nem lehet elmenekülni a zaj elől.';

  @override
  String get campTerrainCoastalBlurb =>
      'Nyugodt, kényelmes és jót tesz a hangulatnak; hosszú buszút minden stadionhoz.';

  @override
  String get campTerrainMountainBlurb =>
      'Hűvös levegő és elsőrangú orvosi háttér, amely gyorsan rendbe hozza az ütődéseket, messze a torna helyszíneitől.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Nehéz itt edzeni, de a lábak a torna mélyén is bírják.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'A szövetség saját létesítményei: semmi különös, de semmi sem romolhat el.';

  @override
  String get hubEventChooseCamp => 'Főhadiszállás kiválasztása';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Hol lakik majd a keret: $host';
  }

  @override
  String get tacticsTabBench => 'Cserepad';

  @override
  String get squadSearchHint => 'Keresés névre vagy klubra';

  @override
  String get squadFilterAll => 'Mindenki';

  @override
  String get squadFilterInSquad => 'A keretben';

  @override
  String get squadFilterUncapped => 'Nem válogatott';

  @override
  String get squadFilterUnavailable => 'Nem elérhető';

  @override
  String get squadLineAll => 'Minden poszt';

  @override
  String get squadSortBy => 'Rendezés';

  @override
  String get squadSortRating => 'Értékelés';

  @override
  String get squadSortCaps => 'Válogatottság';

  @override
  String get squadSortGoals => 'Gólok';

  @override
  String get squadSortAge => 'Kor';

  @override
  String get squadSortName => 'Név';

  @override
  String get squadLegendTitle => 'Mit jelentenek a jelek';

  @override
  String get squadLegendStarting => 'A kezdőcsapatodban';

  @override
  String get squadLegendCalledUp => 'Meghívva, a cserepadon';

  @override
  String get squadLegendRatingUp => 'Idén emelkedő értékelés';

  @override
  String get squadLegendRatingDown => 'Idén csökkenő értékelés';

  @override
  String get squadLegendInjured => 'Sérült, nem elérhető';

  @override
  String get squadLegendSuspended => 'Eltiltva, nem elérhető';

  @override
  String get squadLegendTraits => 'ISMERT ERÉNYEI';

  @override
  String squadShowingOf(int shown, int total) {
    return '$shown játékos látszik $total közül';
  }

  @override
  String get squadNobodyMatches =>
      'A keretben senki sem felel meg ezeknek a szűrőknek.';

  @override
  String get squadStatPool => 'Keret';

  @override
  String get squadStatInSquad => 'Meghívva';

  @override
  String get squadMostCapped => 'Legtöbb válogatottság';

  @override
  String get squadTopScorer => 'Gólkirály';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps válogatottság';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals gól';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Vál.';

  @override
  String get squadGoalsShort => 'Gól';

  @override
  String get recordsRecordBookSubtitle =>
      'Válogatottságok, gólok és a csapat fő rekordjai';

  @override
  String get statsLegacy => 'ÖRÖKSÉG';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name már lekerült a pályáról, nem térhet vissza.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name ki lett állítva, a továbbiakban nem vehet részt a meccsen.';
  }

  @override
  String get tacticsInjuredShort => 'SÉRÜLT';

  @override
  String get tacticsSuspendedShort => 'ELTILTVA';

  @override
  String get confEurope => 'Európa';

  @override
  String get confSouthAmerica => 'Dél-Amerika';

  @override
  String get confNorthAmerica => 'Észak-Amerika';

  @override
  String get confAfrica => 'Afrika';

  @override
  String get confAsia => 'Ázsia';

  @override
  String get confOceania => 'Óceánia';

  @override
  String get compWorldCup => 'Világbajnokság';

  @override
  String get compWorldCupFinals => 'Világbajnokság, döntő';

  @override
  String get compWorldCupQualifying => 'Világbajnoki selejtező';

  @override
  String compQualifiers(String region) {
    return '$region: selejtező';
  }

  @override
  String get compFriendlies => 'Barátságos mérkőzések';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Kontinensek közötti pótselejtező';

  @override
  String get compContinentalChampionship => 'Kontinentális bajnokság';

  @override
  String get compEuropeanChampionship => 'Európa-bajnokság';

  @override
  String get compSouthAmericaCup => 'Dél-amerikai Kupa';

  @override
  String get compAfricanChampionship => 'Afrika-bajnokság';

  @override
  String get compAsianChampionship => 'Ázsia-bajnokság';

  @override
  String get compNorthAmericaCup => 'Észak-amerikai Kupa';

  @override
  String get compOceaniaCup => 'Óceániai Kupa';

  @override
  String get msgANation => 'Egy ország';

  @override
  String get msgAPlayer => 'Egy játékos';

  @override
  String get msgAHostNation => 'egy rendező ország';

  @override
  String get msgCycleTitle1 => 'Új ciklus kezdődik';

  @override
  String msgCycleTitle2(int year) {
    return 'Megnyílik az út $year felé';
  }

  @override
  String get msgCycleTitle3 => 'Új kampány hajnala';

  @override
  String get msgCycleTitle4 => 'Vissza a munkához';

  @override
  String msgCycleBody1(int year) {
    return 'Itt kezdődik az út a $year. évi világbajnokság felé.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Új ciklus. A cél: a $year. évi világbajnokság.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Négy év a $year. évi világbajnokságig. A munka most kezdődik.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Ma elindul a $year. évi kampány.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup, rendező: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host rendezi a következő tornát ($cup).';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup: selejtezősorsolás';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Kisorsolták a selejtezőcsoportokat ($cup).';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return '$year. évi világbajnokság, rendező: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host rendezi a $year. évi világbajnokságot.';
  }

  @override
  String get msgWcQualDrawTitle => 'Világbajnoki selejtezősorsolás';

  @override
  String get msgWcQualDrawBody =>
      'Kisorsolták a világbajnoki selejtezőcsoportokat.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup: döntősorsolás';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Kisorsolták a döntő csoportjait ($cup).';
  }

  @override
  String get msgWcFinalsDrawTitle => 'Világbajnoki döntősorsolás';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Lezajlott a $year. évi világbajnokság döntőjének sorsolása.';
  }

  @override
  String get msgQualWcTitle1 => 'Kijutottatok a világbajnokságra';

  @override
  String get msgQualWcTitle2 => 'Biztos a világbajnoki hely';

  @override
  String get msgQualWcTitle3 => 'Megyünk a világbajnokságra';

  @override
  String get msgQualWcTitle4 => 'Megvan a jegy';

  @override
  String msgQualWcBody1(int year) {
    return 'Kijutottál a $year. évi világbajnokság döntőjére.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Hivatalos: az országod ott lesz a $year. évi világbajnokságon.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Megvan a hely a $year. évi világbajnokságon.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Bejutottál a $year. évi világbajnokság döntőjébe.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Kijutottatok: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Biztos a hely: $cup';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Kvalifikáltatok: $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Kijutottál a döntőre ($cup).';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Az országod biztosította a helyét ($cup).';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Bejutottál a tornára ($cup).';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: BAJNOKOK!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return '$comp: bajnokok vagytok!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return '$comp: megnyerted!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return 'Eldőlt: $comp';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'Megvan a bajnok: $comp';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return 'Megvan a győztes: $comp';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Az országod a bajnok ($comp, $year). Legyőzött ellenfél: $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Megnyerted a tornát ($comp, $year). Legyőzött ellenfél: $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return 'Tiéd a trófea ($comp, $year). Legyőzve: $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner nyerte a tornát ($comp, $year). Legyőzött ellenfél: $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner a bajnok ($comp, $year). Legyőzve: $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' ($home–$away a döntőben)';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' (tizenegyesekkel, $home–$away után)';
  }

  @override
  String get msgWpotyTitle => 'Az év világjátékosa';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) lett $year világjátékosa, és ő a tiéd.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) lett $year világjátékosa.';
  }

  @override
  String get msgYpotTitle => 'A torna legjobb fiatal játékosa';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age évesen lett $year legjobb fiatal játékosa a tornán, és ő a tiéd.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age évesen lett $year legjobb fiatal játékosa a tornán.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Marad a helyezés: $rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Nincs változás, továbbra is $rank. hely.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabil: $rank. hely.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move hellyel',
      one: '1 hellyel',
    );
    return 'Összesen $_temp0 léptél előre. Új helyezés: $rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move hely',
      one: '1 hely',
    );
    return '$_temp0 javulás: új helyezés $rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move hellyel',
      one: '1 hellyel',
    );
    return '$_temp0 följebb, most $rank. helyen.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move hellyel',
      one: '1 hellyel',
    );
    return 'Összesen $_temp0 estél vissza. Új helyezés: $rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move hely',
      one: '1 hely',
    );
    return '$_temp0 csúszás: új helyezés $rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move hellyel',
      one: '1 hellyel',
    );
    return '$_temp0 lejjebb, most $rank. helyen.';
  }

  @override
  String get msgRankLeadYou => 'Te vagy a világ élén.';

  @override
  String msgRankLeadOther(String nation) {
    return 'Az élen: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Világranglista · $rank. hely';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Frissült a világranglista. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Előrelépés: $rank. hely';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Visszaesés: $rank. hely';
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
      other: '$move helyet',
      one: '1 helyet',
    );
    return 'A torna megmozgatta a világranglistát ($tournament). Csapat: $nation. Kezdéskor $from. hely, a végén $to. hely, azaz $_temp0 lépett előre.';
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
      other: '$move helyet',
      one: '1 helyet',
    );
    return 'A torna megmozgatta a világranglistát ($tournament). Csapat: $nation. Kezdéskor $from. hely, a végén $to. hely, azaz $_temp0 esett vissza.';
  }

  @override
  String get rankingSinceWcDraw => 'A világbajnoki sorsolás óta';

  @override
  String get rankingSinceCycleStart => 'A kampány kezdete óta';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '$from. helyről $now. helyre';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name: $count válogatottság';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name immár $count alkalommal lépett pályára az országodért.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name: $count gól';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name eddig $count gólt szerzett a válogatottban az országodért.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Keretfejlődés · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Az akadémiáról érkeztek · $year';
  }

  @override
  String get msgThroughNote =>
      'Ők nem új utánpótlás-csoport. Tizenegy évesen kerültek be, és mostanra nőttek be a felnőtt keretbe.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Új arcok · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Meglátszik az akadémiai beruházás: ez a csoport erősebben érkezett, mint egyébként érkezett volna.';

  @override
  String get msgIntakeNoteStanding =>
      'Az ország figyeli ezt a csapatot: ahogy a válogatott feljebb lép a világranglistán, a legjobb fiúk a focit választják, és ez a csoport ettől erősebben érkezett.';

  @override
  String get msgIntakeNoteBoth =>
      'Az akadémiai pénz és a válogatott világranglista-beli előretörése is meglátszik: ez a csoport erősebben érkezett, mint egyébként érkezett volna.';

  @override
  String msgIntakeTitle(int year) {
    return 'Akadémiai utánpótlás · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Visszavonul a csapatkapitányod, $name';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name visszavonul a válogatottságtól';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name $age évesen visszavonult a válogatottságtól.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name $age évesen visszavonult a válogatottságtól, pályafutása mérlege: $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count válogatottság',
      one: '1 válogatottság',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gól',
      one: '1 gól',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' A karszalag gazdátlan. Nevezz ki új csapatkapitányt a meghívók képernyőn.';

  @override
  String msgHofTitle(String name) {
    return '$name bekerült a Hall of Fame-be';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name csatlakozik az országod Hall of Fame-jéhez ($caps válogatottság, $goals gól). Megtalálod a Legendák között.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name eltiltva';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'a következő $matches meccsről',
      one: 'a következő meccsedről',
    );
    return '$name $how, ezért eltiltották $_temp0. Nem választható.';
  }

  @override
  String get hubBanHowSecondYellow => 'második sárga lap miatt kiállították';

  @override
  String get hubBanHowViolent => 'egyenes piros lapot kapott durvaságért';

  @override
  String get hubBanHowRed => 'kiállították';

  @override
  String hubInjuryTitle(String name) {
    return '$name megsérült';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches meccsről',
      one: '1 meccsről',
    );
    return '$name megsérült, és $_temp0 kiesik.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Ezüstérmesek';

  @override
  String get hubRunnerUpTitle2 => 'Olyan közel, mégis olyan messze';

  @override
  String get hubRunnerUpTitle3 => 'Ezüstérem';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Bejutottál a döntőbe ($cup), de $opponent legyőzött. Annyira közel, de most ezüst jutott.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return '$opponent legyőzött a döntőben ($cup). Ezüstérem, kínzóan közel.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Elúszott a döntő ($cup) $opponent ellen. Sokra lehetsz büszke, csak a trófea hiányzik.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Kiestetek';

  @override
  String get hubKnockedOutTitle2 => 'Itt a vége';

  @override
  String get hubKnockedOutTitle3 => 'Vége az útnak';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Kiestél a tornáról ($cup), $opponent legyőzött. Szakasz: $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent véget vetett a tornádnak ($cup). Szakasz: $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Véget ért a tornád ($cup). Szakasz: $stage, $opponent győzött.';
  }

  @override
  String get hubGroupExitTitle1 => 'Búcsú a csoportkörben';

  @override
  String get hubGroupExitTitle2 => 'Kiestetek a csoportkörben';

  @override
  String get hubGroupExitTitle3 => 'Korai zuhany';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Vége a tornának a csoportkörben: $cup. Nem volt elég a kieséses szakaszhoz.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Nem sikerült kijutnod a csoportból. Itt ér véget a tornád: $cup.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Most nem jutottál a kieséses szakaszba. A csoportkörben véget ért a tornád ($cup).';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Cél teljesítve: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Cél elbukva: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'A vezetőség célja a tornán ($comp): $demand. Eredményed: $finish. Megkapták, amit kértek.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'A vezetőség célja a tornán ($comp): $demand. Eredményed: $finish. Ez elmarad a várttól.';
  }

  @override
  String get newsWcMissTitle => 'Vége a világbajnoki álomnak';

  @override
  String newsWcMissBody(int year) {
    return 'Nem jutottál ki a $year. évi világbajnokságra. A selejtező kevés volt. Még négy év.';
  }

  @override
  String get newsRecordScorerTitle => 'Minden idők gólkirálya';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name lett a játék minden idők legeredményesebb gólszerzője $goals góllal.';
  }

  @override
  String get newsRecordCapsTitle => 'A legtöbbször válogatott játékos';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name lett a játék legtöbbször válogatott játékosa $caps szereplésével.';
  }

  @override
  String get newsARecordBreaker => 'Új rekorder';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name új csapata: $club';
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
    return '$name ($position, $rating) átigazolt. Honnan: $fromClub. Hová: $destination. Díj: $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Ingyen';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name válogatottat váltana. Új csapata: $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name játszani szeretne. Válogatott: $nation';
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
    return '$name, $age éves $position, értékelése $rating. Jelenlegi válogatottja: $fromNation. Családi kötődés: $nation, és nyitott a váltásra. A honosítási ajánlatban elfogadhatod vagy elutasíthatod.';
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
    return '$name, $age éves $position, értékelése $rating. Jelenlegi válogatottja: $fromNation. Sztárnév, családi kötődés: $nation, és nyitott a váltásra. A honosítási ajánlatban elfogadhatod vagy elutasíthatod.';
  }

  @override
  String get newsTheirNation => 'egy másik ország';

  @override
  String get newsYourNation => 'az országod';

  @override
  String get tourStatusChampions => 'BAJNOK';

  @override
  String get tourStatusFinals => 'DÖNTŐ';

  @override
  String get tourStatusQualifying => 'SELEJTEZŐ';

  @override
  String get tourStatusUpcoming => 'KÖVETKEZŐ';

  @override
  String get tourStatusInProgress => 'FOLYAMATBAN';

  @override
  String get tourStatusComingSoon => 'HAMAROSAN';

  @override
  String get tourStatusDecided => 'LEZÁRULT';

  @override
  String tourStatusLeague(String letter) {
    return '$letter DIVÍZIÓ';
  }

  @override
  String get tourDrawWcQualifying => 'VB-SELEJTEZŐ SORSOLÁSA';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup: SELEJTEZŐ SORSOLÁSA';
  }

  @override
  String get tourDrawWcHost => 'VILÁGBAJNOKSÁG RENDEZŐJE';

  @override
  String tourDrawContHost(String cup) {
    return '$cup: RENDEZŐ';
  }

  @override
  String get tourDrawHostsReveal => 'És a rendezők…';

  @override
  String get tourDrawHostReveal => 'És a rendező…';

  @override
  String get tourDrawHostCandidates => 'A jelöltek:';

  @override
  String get tourKickoffContinentalCup => 'KONTINENTÁLIS KUPA';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Lemaradás: $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Nem jutottál ki erre a tornára: $cup. Ezúttal kevés volt a kampány.';
  }

  @override
  String get potyLabelBest => 'Az év játékosa';

  @override
  String get potyLabelYoung => 'Az év fiatal játékosa';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gólpassz',
      one: '1 gólpassz',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Értékelés: $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Átlagjegy: $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Az év világjátékosa, $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name idén a világ legjobb játékosa.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name kapja a legjobb fiatalnak járó díjat.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'A megfigyelt fiatalok, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain ponttal',
      one: '1 ponttal',
    );
    return '$name sokat fejlődött: értékelése $rating, $_temp0 több a tavalyinál.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name korosztályt lépett: $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name bemutatkozott';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name $age évesen megszerezte első válogatottságát, értékelése $rating. Egyike a megfigyelt fiataloknak.';
  }

  @override
  String get matchStatsAtFullTime =>
      'A labdabirtoklás, a játékosértékelések és a mérkőzés embere a lefújáskor dől el.';

  @override
  String get matchPlayerRatings => 'JÁTÉKOSÉRTÉKELÉSEK';

  @override
  String get matchSubstitutions => 'CSERÉK';

  @override
  String get matchSubstitutes => 'CSEREJÁTÉKOSOK';

  @override
  String get matchPlayerOfTheMatch => 'A MÉRKŐZÉS EMBERE';

  @override
  String get matchGoalShout => 'GÓL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'TIZENEGYESEK $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: GÓL';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: KIHAGYTA';
  }

  @override
  String get matchFeedKickOff => 'Kezdőrúgás!';

  @override
  String get matchFeedNoEvents => 'Még nem történt semmi.';

  @override
  String get tourVenues => 'HELYSZÍNEK';

  @override
  String tourPot(int number) {
    return '$number. KALAP';
  }

  @override
  String get tourHostSelection => 'RENDEZŐ KIVÁLASZTÁSA';

  @override
  String get tourCandidates => 'JELÖLTEK';

  @override
  String get tourJointBid => 'KÖZÖS PÁLYÁZAT';

  @override
  String get tourGoldenGlove => 'ARANYKESZTYŰ';

  @override
  String get tourTeamOfTournament => 'A TORNA CSAPATA';

  @override
  String get tourYourRun => 'A TE UTAD';

  @override
  String get tourMedalTable => 'ÉREMTÁBLÁZAT';

  @override
  String tourHostLine(String nation) {
    return 'Rendező: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Rendezők: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return '$name csoport';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'A világranglista alapján kiemelve. Keresd meg az országodat a sorsolás előtt.';

  @override
  String get tourWorldRanking => 'Világranglista';

  @override
  String get tourYourCompetitions => 'A TE VERSENYEID';

  @override
  String get tourOtherContinents => 'MÁS KONTINENSEK';

  @override
  String get tourZoneGlobal => 'VILÁG';

  @override
  String get tourZoneEurope => 'EURÓPA';

  @override
  String get tourZoneSouthAmerica => 'D.-AMERIKA';

  @override
  String get tourZoneNorthAmerica => 'É.-AMERIKA';

  @override
  String get tourZoneAfrica => 'AFRIKA';

  @override
  String get tourZoneAsia => 'ÁZSIA';

  @override
  String get tourZoneOceania => 'ÓCEÁNIA';

  @override
  String get tourZoneIntercontinental => 'KONTINENSEK KÖZÖTT';

  @override
  String tourZoneLeague(String league) {
    return '$league DIVÍZIÓ';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'RENDEZŐ:  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Az első $count továbbjut $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name búcsúzik';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name $age évesen, $caps válogatottság után visszavonult a nemzetközi futballtól. Azt kérte, tudhassa, hol áll, de nem kapott választ, és nem vár tovább.';
  }

  @override
  String get pressHeadlineWent1 => 'Egy kapitány, aki uralja a termet';

  @override
  String get pressHeadlineWent2 => 'Balhéért jöttek, vezetőt kaptak';

  @override
  String get pressHeadlineWent3 => 'Egyenes válaszok, és célba értek';

  @override
  String get pressHeadlineMixed1 => 'Sok szó esett, kevés dőlt el';

  @override
  String get pressHeadlineMixed2 =>
      'Mindenkinek jutott valami, és senkinek semmi';

  @override
  String get pressHeadlineMixed3 =>
      'Sajtótájékoztató, amely nyitva hagyta a kérdéseket';

  @override
  String get pressHeadlineBadly1 => 'Kemény délután a kamerák előtt';

  @override
  String get pressHeadlineBadly2 =>
      'A terem ellene fordult, és meg is látszott';

  @override
  String get pressHeadlineBadly3 =>
      'Válaszok, amelyek reggelre még rosszabbul hangzanak';

  @override
  String get pressHeadlineFlat1 =>
      'Semmi nem hangzott el, semmi nem lett belőle';

  @override
  String get pressHeadlineFlat2 => 'Tíz perc, hír nulla';

  @override
  String get pressHeadlineFlat3 => 'Üres lap a hátsó oldalra';

  @override
  String get pressConferenceTitle => 'SAJTÓTÁJÉKOZTATÓ';

  @override
  String pressQuestionOf(int index, int total) {
    return '$index. kérdés, összesen $total';
  }

  @override
  String get pressTomorrowsHeadline => 'HOLNAPI CÍMLAP';

  @override
  String get pressLeaveRoom => 'KILÉPÉS A TEREMBŐL';

  @override
  String get pressRoomVerdictSquad => 'Öltöző';

  @override
  String get pressRoomVerdictBoard => 'Vezetőség';

  @override
  String get yReactionElation0 => 'nincs megjegyzés. egy sem. tökéletes.';

  @override
  String get yReactionElation1 => 'Rosszul vagyok (jó értelemben).';

  @override
  String get yReactionElation2 => 'bekeretezem. a kandalló fölé kerül.';

  @override
  String get yReactionElation3 => 'újra itt vagyunk';

  @override
  String get yReactionElation4 => 'Képernyőfotó a kétkedőknek. Mindegyiknek.';

  @override
  String get yReactionElation5 => 'Egy évtizedig elviselhetetlen leszek ettől.';

  @override
  String get yReactionElation6 => 'Na igen. Ezért nézzük.';

  @override
  String get yReactionElation7 => 'Az ilyen napok kifizetik a többit.';

  @override
  String get yReactionElation8 => 'Már ideje volt. Tényleg, már ideje volt.';

  @override
  String get yReactionElation9 =>
      'Szuper. Most csináljátok meg jövő héten is, és elhiszem.';

  @override
  String get yReactionElation10 =>
      'Élvezd ma este, mert ezek megtalálják a módját, hogy elrontsák.';

  @override
  String get yReactionElation11 =>
      'Egy jó este még nem csinál nagy csapatot senkiből.';

  @override
  String get yReactionRelief0 => 'Nem szép, de bármikor elfogadom.';

  @override
  String get yReactionRelief1 => 'Valahogy. Valahogy!';

  @override
  String get yReactionRelief2 => 'Csúnya. Három pont. Menjünk tovább.';

  @override
  String get yReactionRelief3 =>
      'Egész nap vállalom a csúnyát, ha pont jár érte.';

  @override
  String get yReactionRelief4 => 'tíz évet vett le az életemből';

  @override
  String get yReactionRelief5 => 'Senki ne szóljon. Senki ne kiabálja el.';

  @override
  String get yReactionRelief6 => 'Pulzus: elfogadhatatlan.';

  @override
  String get yReactionRelief7 => 'Túléltük. Ez a szó. Túléltük.';

  @override
  String get yReactionRelief8 =>
      'Nem kellene megkönnyebbülnünk az ilyen meccsek után.';

  @override
  String get yReactionRelief9 => 'Megkönnyebbültem, és kicsit szégyellem is.';

  @override
  String get yReactionRelief10 =>
      'Ha ez az a szint, amit ünneplünk, bajban vagyunk.';

  @override
  String get yReactionRelief11 =>
      'A szerencsés továbbjutás szokás, és nem jó szokás.';

  @override
  String get yReactionFury0 => 'Ez kevés. Közel sem elég.';

  @override
  String get yReactionFury1 => 'Valaki magyarázza el ezt nekem lassan.';

  @override
  String get yReactionFury2 => 'Ezt nehéz nézni, és még udvarias vagyok.';

  @override
  String get yReactionFury3 => 'Csalódott vagyok. Őszintén csalódott.';

  @override
  String get yReactionFury4 => 'Ez egy teljes katasztrófa.';

  @override
  String get yReactionFury5 => 'Neveket kérek.';

  @override
  String get yReactionFury6 => 'Törlöm az appot. Csütörtökön újra felteszem.';

  @override
  String get yReactionFury7 => 'Odakint senkin nem látszott, hogy akarja.';

  @override
  String get yReactionFury8 => 'Négyévente ugyanez. MINDEN négy évben.';

  @override
  String get yReactionFury9 => 'Ez nem teljesítmény, hanem sértés.';

  @override
  String get yReactionFury10 =>
      'Az emberek hétvégét és pénzt áldoznak erre. Gondoljatok bele.';

  @override
  String get yReactionFury11 =>
      'Évek óta védem ezt a csapatot. Ma este nem. Ezek után nem.';

  @override
  String get yReactionDespair0 => 'na.';

  @override
  String get yReactionDespair1 => 'Ma nincs vicc. Semmi.';

  @override
  String get yReactionDespair2 => 'Sétálok egyet. Egy hosszút.';

  @override
  String get yReactionDespair3 => 'Elfogytak a szavaim.';

  @override
  String get yReactionDespair4 => 'Négy év múlva ébresszetek.';

  @override
  String get yReactionDespair5 => 'ez a legsötétebb idővonal';

  @override
  String get yReactionDespair6 => 'Már mérges sem vagyok. Ez az aggasztó.';

  @override
  String get yReactionDespair7 => 'Ez még sokáig fájni fog.';

  @override
  String get yReactionDespair8 => 'Nem tudom, mi ez már, de focicsapat nem.';

  @override
  String get yReactionDespair9 =>
      'Messzebb vagyunk, mint voltunk, és ezt senki nem meri kimondani.';

  @override
  String get yReactionDespair10 =>
      'Egy egész generáció kárba ment, és ugyanazok döntenek a folytatásról.';

  @override
  String get yReactionDespair11 =>
      'Ne mondjátok többet, hogy ez egy folyamat. Nem visz sehová.';

  @override
  String get yReactionSmugness0 => 'Csendben, de: megmondtam.';

  @override
  String get yReactionSmugness1 => 'jelöljétek meg ezt a meccset';

  @override
  String get yReactionSmugness2 => 'A kétkedők nagyon elcsendesedtek.';

  @override
  String get yReactionSmugness3 => 'Nem mintha bárki számolná. Én számolom.';

  @override
  String get yReactionSmugness4 =>
      'Januárban megmondtam. Nézzétek vissza az idővonalat.';

  @override
  String get yReactionSmugness5 =>
      'Néhányan tartoztok nekünk egy bocsánatkéréssel.';

  @override
  String get yReactionSmugness6 =>
      'Ezt a fiókot úgy címkézem: amit én mondtam előbb.';

  @override
  String get yReactionSmugness7 => 'Nincs ujjongás. Egy kis ujjongás.';

  @override
  String get yReactionSmugness8 =>
      'Hol vannak most a szakértők? Őszinte kérdés.';

  @override
  String get yReactionSmugness9 =>
      'Azt akarom, hogy mind mondjátok vissza nekem.';

  @override
  String get yReactionSmugness10 =>
      'Képernyőfotó, kinyomtatva, bekeretezve, elküldve azoknak, akik nevettek.';

  @override
  String get yReactionSmugness11 =>
      'Ezt életem végéig emlegetni fogom, és kiérdemeltétek.';

  @override
  String get yReactionShrug0 => 'megtörtént. következő.';

  @override
  String get yReactionShrug1 => 'Jó. Mindegy. Tovább.';

  @override
  String get yReactionShrug2 => 'Ezt a \'foci\' rovatba teszem.';

  @override
  String get yReactionShrug3 => 'Tényleg nincs mit hozzátenni.';

  @override
  String get yReactionShrug4 => 'nincs gondolat, üres fej';

  @override
  String get yReactionShrug5 => 'Szóljatok a következőnél.';

  @override
  String get yReactionShrug6 => 'Kilencven perc, amit nem kapok vissza.';

  @override
  String get yReactionShrug7 => 'Se ide, se oda, őszintén.';

  @override
  String get yReactionShrug8 =>
      'Egyetlen dolgot sem tudnék mondani, ami történt.';

  @override
  String get yReactionShrug9 => 'Megint egy ilyen. Sok van belőlük.';

  @override
  String get yReactionShrug10 =>
      'Az egészet végignéztem, és semmit nem éreztem.';

  @override
  String get yReactionShrug11 => 'Ha erről senki nem beszél többet, nekem jó.';

  @override
  String get tourThirdsUneven =>
      'A csoportok különböző méretűek, ezért a nagyobb csoportok utolsó csapata elleni eredmények kiesnek, és minden csapatot ugyanannyi meccs alapján értékelünk.';

  @override
  String get careerExportSave => 'Mentés exportálása';

  @override
  String get careerBackupAll => 'MINDEN MENTÉS EXPORTÁLÁSA';

  @override
  String get careerBackupAllFailed =>
      'Nem sikerült megírni a biztonsági mentést.';

  @override
  String get backupTitle => 'BIZTONSÁGI MENTÉSEK';

  @override
  String get backupBlurb =>
      'Minden mentés egyetlen fájlban van ezen a telefonon, és semmi sem menti őket magától, hacsak lent be nem kapcsolod az automatikus mentést. Tarts másolatot a felhőben, hogy egy elveszett telefon vagy törölt alkalmazás ne kerüljön egy karrierbe.';

  @override
  String get backupBlurbNoAuto =>
      'Minden mentés egyetlen fájlban van ezen a telefonon, és semmi sem menti őket magától. Tarts másolatot a felhőben, hogy egy elveszett telefon vagy törölt alkalmazás ne kerüljön egy karrierbe.';

  @override
  String get backupExport => 'MENTÉS A FELHŐBE';

  @override
  String get backupExportSubject => 'FNM mentések';

  @override
  String get backupRestore => 'VISSZAÁLLÍTÁS FÁJLBÓL';

  @override
  String get backupRestoreWarnTitle => 'Lecseréled az összes mentést?';

  @override
  String get backupRestoreWarnBody =>
      'A visszaállítás a telefon összes mentését lecseréli a fájlban lévőkre. Az app újraindul.';

  @override
  String get backupRestoreConfirm => 'CSERE';

  @override
  String get backupCancel => 'MÉGSE';

  @override
  String get backupExported =>
      'A biztonsági mentés kész. Válaszd ki, hová mented.';

  @override
  String get backupFailed => 'Nem sikerült megírni a biztonsági mentést.';

  @override
  String get backupRejectedUnreadable => 'Ezt a fájlt nem lehetett megnyitni.';

  @override
  String get backupRejectedNotFnm => 'Ez nem FNM mentés.';

  @override
  String get backupRejectedNewer =>
      'Ezt a mentést az app újabb verziója készítette. Előbb frissíts.';

  @override
  String get backupRejectedTooOld =>
      'Ez a mentés túl régi, ez a verzió nem tudja visszaállítani.';

  @override
  String get careerShare => 'Karrier megosztása';

  @override
  String get careerImport => 'KARRIER IMPORTÁLÁSA';

  @override
  String get careerShareSubject => 'Egy FNM karrier';

  @override
  String get careerImported => 'Karrier importálva.';

  @override
  String get careerImportFailedUnreadable => 'Ez a fájl nem FNM karrier.';

  @override
  String get careerImportFailedNewer =>
      'Ezt a karriert az app újabb verziója exportálta. Előbb frissíts.';

  @override
  String get careerImportFailedSlotsFull =>
      'Minden mentési helyed foglalt. Törölj egy mentést, hogy legyen hely, vagy oldd fel a korlátlan mentést.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Ez a karrier túl van az ingyenes első cikluson. Oldd fel a teljes játékot, hogy behozhasd.';

  @override
  String get careerImportFailedCampaignRun =>
      'Ebben a kampányban már van folyamatban lévő játék. Folytasd vagy dobd el előbb.';

  @override
  String get careerShareFailed => 'Nem sikerült exportálni a karriert.';

  @override
  String get managerRename => 'Név módosítása';

  @override
  String get managerRenameSave => 'Mentés';

  @override
  String get managerTitle => 'SZÖVETSÉGI KAPITÁNY';

  @override
  String get managerSkills => 'KÉPESSÉGEID';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elkölthető pont',
      one: '1 elkölthető pont',
      zero: 'Nincs elkölthető pont',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Két pont jár minden befejezett ciklusért, egy minden megnyert trófeáért.';

  @override
  String get managerSkillsScale =>
      'Minden képesség 5-ről indul, és 20-nál áll meg. Az elköltött pont végleges.';

  @override
  String get managerSkillManManagement => 'Emberkezelés';

  @override
  String get managerSkillManManagementBlurb =>
      'Minden pont 3%-kal nagyobb súlyt ad annak, amit a sajtónak és a játékosaidnak mondasz az öltözőben.';

  @override
  String get managerSkillTactical => 'Taktika';

  @override
  String get managerSkillTacticalBlurb =>
      'Minden pont 3%-kal gyorsabban építi be az új felállást, így a formaváltás kevesebb meccsbe kerül.';

  @override
  String get managerSkillYouth => 'Utánpótlás-nevelés';

  @override
  String get managerSkillYouthBlurb =>
      'Minden pont 1%-kal növeli az akadémiádról kikerülő tehetséget, azon felül, amit a finanszírozással elérsz.';

  @override
  String get managerSkillNegotiation => 'Tárgyalás';

  @override
  String get managerSkillNegotiationBlurb =>
      'Minden pont 2%-kal több pénzt hoz a szövetségtől, minden ciklusban.';

  @override
  String get managerStaff => 'A STÁBOD';

  @override
  String managerStaffWages(String amount) {
    return 'Bérek: $amount / ciklus';
  }

  @override
  String get managerRoleAssistant => 'Másodedző';

  @override
  String get managerRoleAssistantBlurb =>
      'Az edzéseket vezeti: kevesebb sérülés, jobb fiatalok jönnek fel.';

  @override
  String get managerRoleScout => 'Vezető megfigyelő';

  @override
  String get managerRoleScoutBlurb =>
      'Felméri a tehetségeket és a következő ellenfelet: igazabb sztárértékelések, és előny a meccsnapon.';

  @override
  String get managerRoleFitness => 'Erőnléti edző';

  @override
  String get managerRoleFitnessBlurb => 'Pályán tartja őket.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent%-kal kevesebb sérülés';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Fiatalok +$points összértékelés';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Felvétellel: $min% és $max% közötti sérülés-csökkenés';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'és fiatalok +$minPoints és +$maxPoints közötti összértékelés';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'A tehetségek $percent%-át pontosan méri fel';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'A potenciál $caps válogatottság után ismert',
      one: 'A potenciál 1 válogatottság után ismert',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points értékelés az ellenfél-dossziékból';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Felvétellel: a felmérések $min% és $max% közötti része pontos';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'és a potenciál $minCaps és $maxCaps válogatottsággal korábban ismert';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'és +$minPoints és +$maxPoints közötti értékelés minden meccsen';
  }

  @override
  String get staffEffectNone => 'Még nincs hatása a keretedre';

  @override
  String get staffVacant => 'Senki nincs a poszton';

  @override
  String get staffLeaveVacant => 'Hagyd üresen a posztot';

  @override
  String get managerTierNone => 'Nincs';

  @override
  String get managerTierBasic => 'Alap';

  @override
  String get managerTierGood => 'Jó';

  @override
  String get managerTierElite => 'Elit';

  @override
  String get managerFree => 'ingyen';

  @override
  String get managerTraining => 'AZ ABLAKOK KÖZÖTT';

  @override
  String get managerTrainingBlurb =>
      'Amin a keret dolgozik, amikor nincs mérkőzés.';

  @override
  String get managerFocusBalanced => 'Kiegyensúlyozott';

  @override
  String get managerFocusBalancedBlurb => 'Egy kicsit mindenből.';

  @override
  String get managerFocusFitness => 'Erőnlét';

  @override
  String get managerFocusFitnessBlurb => 'Kevesebb sérülés.';

  @override
  String get managerFocusCohesion => 'Összhang';

  @override
  String get managerFocusCohesionBlurb => 'A felállás gyorsabban beépül.';

  @override
  String get managerFocusYouth => 'Utánpótlás';

  @override
  String get managerFocusYouthBlurb => 'Órák a keret legfiatalabbjaival.';

  @override
  String get tourOfferTitle => 'Először jársz itt?';

  @override
  String get tourOfferBody =>
      'Ez egy nagy játék. Szeretnél egy gyors körutat a fontos képernyőkön? Egy percet vesz igénybe, és bármikor újraindíthatod a Beállításokból.';

  @override
  String get tourOfferYes => 'Mutasd meg';

  @override
  String get tourOfferNo => 'Köszönöm, nem';

  @override
  String get tourBack => 'Vissza';

  @override
  String get tourNext => 'Tovább';

  @override
  String get tourDone => 'Kész';

  @override
  String get tourSkip => 'Kihagyás';

  @override
  String get tourHubTitle => 'Ez az egész játék';

  @override
  String get tourHubBody =>
      'Egy gomb, ami a ciklus haladtával változik: egy sorsolás, amit megnézel, egy keret, amit összeállítasz, egy meccs, amit lejátszol. Fölötte a vezetőség bizalma és a kitűzött célok.';

  @override
  String get tourBudgetTitle => 'A szövetség pénze';

  @override
  String get tourBudgetBody =>
      'A négyéves ciklusokban egyszer osztod szét a pénzt a részlegek között. A stábod fizetése ebből megy először, így egy elit megfigyelő felvétele az akadémia ellen szól, nem mellette.';

  @override
  String get tourTacticsTitle => 'Hogyan játszik a csapat';

  @override
  String get tourTacticsBody =>
      'A felállásod, a játékstílusod, a csapatkapitányod és az, hogy ki végzi el a pontrúgásokat. Ha az utolsó kettőt üresen hagyod, a játék a kezdés előtt figyelmeztet, nem választ csendben helyetted.';

  @override
  String get tourSquadTitle => 'Mindenki, akit kiválaszthatsz';

  @override
  String get tourSquadBody =>
      'A teljes játékoskeret, nem csak a válogatott: ki van formában, ki sérült, ki van eltiltva, és ki került most fel az akadémiáról.';

  @override
  String get tourCallUpsTitle => 'Keret összeállítása';

  @override
  String get tourCallUpsBody =>
      'Minden nemzetközi ablakra egy keretet állítasz össze, és az játssza az ablak minden meccsét, pont mint egy valódi szövetségi kapitánynál. Ha valaki megsérül az ablakban, a játék pótlót hív be helyette.';

  @override
  String get tourRecordsTitle => 'A karriered';

  @override
  String get tourRecordsBody =>
      'Minden, amit elértél: a mérkőzések, a csapatrekordok, a trófeák, és minden ország, amelyet irányítottál.';

  @override
  String get tourCupsTitle => 'A világ többi része';

  @override
  String get tourCupsBody =>
      'Minden jelenleg futó verseny: csoportok, tabellák és kieséses szakaszok, azokat is beleértve, amelyekben nem veszel részt. A világ akkor is játszik, ha te nem jutottál ki.';

  @override
  String get settingsTourTitle => 'Bemutató újrajátszása';

  @override
  String get settingsTourBlurb =>
      'Járd végig újra az elejétől a fontos képernyőket.';

  @override
  String get tourBoardTitle => 'Kinek felelsz';

  @override
  String get tourBoardBody =>
      'A vezetőség bizalma, és a célok, amelyeket erre a ciklusra kitűztek. Ha elmarad a teljesítés, itt látod előre.';

  @override
  String get tourStaffTitle => 'A körülötted lévők';

  @override
  String get tourStaffBody =>
      'Egy másodedző, egy megfigyelő és egy erőnléti edző, név szerint felvéve. A béreik ebből a költségvetésből mennek a részlegek előtt, így egy nagyszerű megfigyelő az akadémia ellen szól.';

  @override
  String get tourPlaystyleTitle => 'A játékstílusod';

  @override
  String get tourPlaystyleBody =>
      'A felállás csak fél taktika. Ez a másik fele: milyen magasan letámadsz, mennyire vagy direkt, mennyit kockáztatsz.';

  @override
  String get settingsTourNoSave =>
      'Előbb indíts egy karriert. A bemutató a saját képernyőidet járja be.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Nem a posztján · $age éves';
  }

  @override
  String get federationNextCycleLocked =>
      'A következő ciklus költségvetését a ciklus elején, egyben határozod meg. Addig ez mutatja, mire megy a pénzed.';

  @override
  String get federationBudgetAlreadySet => 'Erre a ciklusra már beállítva';

  @override
  String yFinalLooms0(String opponent) {
    return '$opponent lesz az ellenfél a nagy napon. Egész héten csak erről lesz szó.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Megvan: $opponent áll köztünk és a cél között. Négy év ezért.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Jól van. $opponent. Senki nem alszik, amíg ez le nem zajlik.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Jön $opponent, minden más várhat. Micsoda hét ez.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Bízd az edzőre a végrehajtókat';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Megjelölve: akik úgy játszanak, mint $rivals, azok a csapatok, amelyekkel ebben a ciklusban a csoportodban találkozol.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Átigazolási időszak · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Utoljára $when ezelőtt';
  }

  @override
  String get settingsFreeScopeTitle => 'Egy ingyenes négyéves ciklus';

  @override
  String get settingsFreeScopeBlurb =>
      'Egy teljes ciklus (selejtezők, a kontinentális bajnokságod és a világbajnokság) két mentésen, a világ minden országával, semmit nem visszatartva. A végtelen ciklusok és a korlátlan mentés egyetlen, egyszeri fizetés, és minden jövőbeli frissítést tartalmaz.';

  @override
  String get settingsUnlockedTitle => 'Feloldva';

  @override
  String get settingsUnlockedBlurb =>
      'Végtelen ciklusok, korlátlan mentés és minden jövőbeli frissítés. Köszönöm.';

  @override
  String get settingsFromDeveloperTitle => 'A fejlesztőtől';

  @override
  String get settingsFromDeveloperBlurb =>
      'A Football Nations Managert egyetlen ember készíti, és hosszú távon is frissíteni fogja. Soha nem lesz benne hirdetés vagy mikrotranzakció. Ha élvezed a játékot, kérlek, fontold meg a teljes verzió megvásárlását. Ez tartja életben a frissítéseket.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'A Football Nations Managert egyetlen ember készíti, és hosszú távon is frissíteni fogja. Soha nem lesz benne hirdetés vagy mikrotranzakció. Köszönöm, hogy megvetted a teljes verziót. Ez tartja életben a frissítéseket.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Megjelölve: akik úgy játszanak, mint $rivals, és még szembe kell nézned velük.';
  }

  @override
  String get friendliesCloseToYou =>
      'Megjelölve: a világranglistán hozzád legközelebb álló csapatok. A sorsolás után a jelölések a csoportodat követik.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count átigazolás',
      one: '1 átigazolás',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Újabb';

  @override
  String get transfersOlder => 'Több';

  @override
  String get transfersPagePrevious => 'Előző';

  @override
  String get transfersPageNext => 'Következő';

  @override
  String transfersPageOf(int page, int pages) {
    return '$page. oldal / $pages';
  }

  @override
  String get transfersMovedTo => 'Átigazolt ide';

  @override
  String get transfersUnknownClub => 'Ismeretlen klub';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Ez már $count. alkalom $opponent ellen. Valaki vezeti az állást, és ők azok.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Megint $opponent. $count találkozó, és még mindig nem jöttünk rájuk.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return '$count. meccs $opponent ellen. Ez már nem véletlen.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return '$count-szor játszottunk $opponent ellen, és egyikből sem tanultunk semmit.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent ellen $count. alkalom. Pontosan tudják, mit fogunk csinálni.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Bármi is van náluk ellenünk, $count találkozó után ($opponent) még mindig megvan.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Ez már $count. alkalom mostanában. Mikortól ez egyszerűen mi vagyunk?';
  }

  @override
  String ySameOldStory1(String count) {
    return 'Már $count ilyen délután. Ez minta, nem szerencsesorozat.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Ugyanezt a meccset láttuk $count-szor mostanában. Ugyanaz a forgatókönyv, ugyanaz a vége.';
  }

  @override
  String ySameOldStory3(String count) {
    return 'Már $count verziója ugyanannak a kilencven percnek. Senki nem javítja.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count-szor. Ha eddig nem látod a mintát, nem is nézed.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Ugyanaz a történet, $count-szor. A kifogások előbb fogytak el, mint az eredmények.';
  }

  @override
  String get yToldYouSo0 => 'Megmondtam, hogy ez jön, amíg mindenki ünnepelt.';

  @override
  String get yToldYouSo1 =>
      'Két jó hét, és megint aranygeneráció lettünk. És nézd, hol tartunk.';

  @override
  String get yToldYouSo2 =>
      'Akik múlt hónapban azt mondták, élvezzem, nagyon elhallgattak.';

  @override
  String get yToldYouSo3 => 'Nem örülök neki. Nagyon kevéssé. Egy kicsit.';

  @override
  String get yToldYouSo4 =>
      'Soha nem volt olyan jó, mint ahogy mondták, és ez a bizonyíték.';

  @override
  String get yToldYouSo5 =>
      'Mindig ugyanez. Azt mondják, most más, és mindig kiderül, hogy nem.';

  @override
  String get tacticsSubOffAlready => 'Már lecserélték';

  @override
  String get tacticsSubInjured => 'Sérült';

  @override
  String get tacticsSubSentOffMark => 'Kiállítva';

  @override
  String get tacticsSubNoneLeft => 'Nincs több csere';

  @override
  String get tacticsUndoLastChange => 'Utolsó csere visszavonása';

  @override
  String get matchStrengthTitle => 'MI MOZGATJA A CSAPATOT';

  @override
  String get strengthFactorFamiliarity => 'Begyakorolt felállás';

  @override
  String get strengthFactorFatigue => 'Fáradt láb';

  @override
  String get strengthFactorClubForm => 'Klubforma';

  @override
  String get strengthFactorMorale => 'Öltöző';

  @override
  String get strengthFactorCaptain => 'Csapatkapitány';

  @override
  String get strengthFactorStaff => 'Stáb';

  @override
  String get strengthFactorDossier => 'Megfigyelői dosszié';

  @override
  String yDebut0(String name) {
    return '$name megszerezte az első válogatottságát. Jegyezd meg a nevet.';
  }

  @override
  String yDebut1(String name) {
    return '$name bemutatkozik. Már látszik rajta, nem?';
  }

  @override
  String yDebut2(String name) {
    return '$name, első válogatottság. Lássuk, mit kezd vele.';
  }

  @override
  String yDebut3(String name) {
    return '$name bemutatkozik. A keretnek valahol friss láb kellett.';
  }

  @override
  String yDebut4(String name) {
    return '$name megkapta a meghívót. Mostanában sokat osztogattunk belőlük.';
  }

  @override
  String yDebut5(String name) {
    return '$name bemutatkozik. Még egy, akit tavaszra elfelejtünk.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name már $count meccsen nem szerzett gólt, de mindent mást megcsinál a pályán.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$name: $count meccs gól nélkül. Hármasával jönnek, mindig is így volt.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count meccs, nulla gól.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$name: $count meccs gól nélkül. Érdemes szemmel tartani.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count meccs. Nulla gól. $name egy istállóajtót sem találna el.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name $count meccsen nem talált be. Játsszon bárki más.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Jön $opponent. $count találkozó, és még mindig minden ezen múlik.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'Már $count-szor játszunk $opponent ellen. Jöjjön.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Jön $opponent. $count meccs volt.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Ezen a héten a(z) $count. találkozó jön $opponent ellen.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Megint $opponent. $count ilyen volt, és semmit nem tanultunk.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count meccs $opponent ellen, és még mindig megvernek minket. Csodás.';
  }

  @override
  String get positionGoalkeeper => 'Kapus';

  @override
  String get positionLeftBack => 'Bal oldali védő';

  @override
  String get positionCentreBack => 'Belső védő';

  @override
  String get positionRightBack => 'Jobb oldali védő';

  @override
  String get positionDefensiveMid => 'Védekező középpályás';

  @override
  String get positionCentralMid => 'Középpályás';

  @override
  String get positionAttackingMid => 'Támadó középpályás';

  @override
  String get positionLeftMid => 'Bal oldali középpályás';

  @override
  String get positionRightMid => 'Jobb oldali középpályás';

  @override
  String get positionLeftWing => 'Bal szélső';

  @override
  String get positionRightWing => 'Jobb szélső';

  @override
  String get positionStriker => 'Csatár';

  @override
  String get roleNone => 'Nincs szerep';

  @override
  String get roleTargetMan => 'Támadó cél';

  @override
  String get rolePoacher => 'Gólvadász';

  @override
  String get rolePlaymaker => 'Irányító';

  @override
  String get roleBallWinner => 'Labdaszerző';

  @override
  String get roleInvertedWinger => 'Befelé húzódó szélső';

  @override
  String get roleBallPlayingDefender => 'Játékos védő';

  @override
  String get roleNoneBlurb => 'A természetes játékát játssza.';

  @override
  String get roleTargetManBlurb =>
      'Fejesekben erős, továbbadja a labdát. Gólpasszok és pontrúgások.';

  @override
  String get rolePoacherBlurb =>
      'A tizenhatoson belül leskelődik. Sokkal több gól.';

  @override
  String get rolePlaymakerBlurb => 'Helyzeteket teremt. Sokkal több gólpassz.';

  @override
  String get roleBallWinnerBlurb => 'Megbontja a játékot, nem befejezi.';

  @override
  String get roleInvertedWingerBlurb => 'Befelé húz, hogy lőjön. Több gól.';

  @override
  String get roleBallPlayingDefenderBlurb =>
      'A hátsó sorból építi a támadásokat.';

  @override
  String get federationDeptYouth => 'Utánpótlás-akadémia';

  @override
  String get federationDeptCommercial => 'Kereskedelem / PR';

  @override
  String get federationDeptMedical => 'Orvosi és sporttudományi részleg';

  @override
  String get federationDeptNaturalisation => 'Honosítási iroda';

  @override
  String get federationDeptBoardRelations => 'Vezetőségi kapcsolatok';

  @override
  String get federationDeptYouthBlurb =>
      'Jobb akadémiai tehetségek mutatkoznak be a válogatottban a következő ciklusban.';

  @override
  String get federationDeptCommercialBlurb =>
      'A szponzorok a ciklus végén extra bevételt hoznak.';

  @override
  String get federationDeptMedicalBlurb =>
      'Kevesebb sérülés. A keret az egész ciklusban bevethető marad.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Több külföldi játékos ajánlkozik, hogy hozzád váltson.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'A vezetőség türelmesebben ítéli meg az eredményeidet.';

  @override
  String get federationBuildingAcademy => 'Akadémia';

  @override
  String get federationBuildingCommercial => 'Kereskedelmi központ';

  @override
  String get federationBuildingMedical => 'Orvosi központ';

  @override
  String get federationBuildingScouting => 'Megfigyelői iroda';

  @override
  String get federationBuildingBoardroom => 'Tárgyaló';

  @override
  String get moraleBuoyant => 'Remek';

  @override
  String get moralePositive => 'Pozitív';

  @override
  String get moraleSettled => 'Kiegyensúlyozott';

  @override
  String get moraleUneasy => 'Nyugtalan';

  @override
  String get moraleRockBottom => 'Mélypont';

  @override
  String get matchTabTimeline => 'IDŐVONAL';

  @override
  String get matchTabStats => 'STATISZTIKA';

  @override
  String get matchTabLineups => 'FELÁLLÁSOK';

  @override
  String get matchPenalty => 'TIZENEGYES';

  @override
  String get matchStateLevel => 'Döntetlen az állás';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gól az előnyöd',
      one: 'Egy gól az előnyöd',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gól a hátrányod',
      one: 'Egy gól a hátrányod',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% labdabirtoklás';
  }

  @override
  String get boardVerdictSackedTitle => 'A vezetőség elbocsátott';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Siralmas ciklus (értékelés: $rating%). A megbízatásod véget ért. Most már csak gyengébb országok vállalnak kockázatot veled.';
  }

  @override
  String get boardVerdictDelightedTitle => 'A vezetőség el van ragadtatva';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Kiemelkedő ciklus (értékelés: $rating%), $best után. Nagyobb országok érdeklődnek, vagy maradhatsz és építkezhetsz.';
  }

  @override
  String get boardVerdictSolidTitle => 'Szilárd ciklus';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'A vezetőség elégedett (értékelés: $rating%). Néhány hasonló súlyú ország elvállalna, de nincs nyomás, hogy távozz.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'A vezetőség többet várt';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Csalódást keltő ciklus (értékelés: $rating%). Megtartod az állásod, de minden ajánlat visszalépés lenne.';
  }

  @override
  String get boardVerdictPressureTitle => 'Valódi nyomás alatt állsz';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Gyenge ciklus (értékelés: $rating%). Megúszod, de ha új kezdetre vágysz, csak a gyengébb országok érdeklődnek irántad.';
  }

  @override
  String get boardVerdictHeroTitle => 'Az ország melletted áll';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles ciklus',
      one: '1 ciklus',
    );
    return ' $nation imád téged, nemzeti hős vagy $_temp0 után; az állásod biztos, ameddig csak akarod.';
  }

  @override
  String get boardVerdictTheNation => 'Az ország';

  @override
  String get boardVerdictBestQuiet => 'egy nyugodt ciklus';

  @override
  String get boardVerdictBestCycle => 'a ciklus';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'a világbajnokság ($placement)';
  }

  @override
  String get finishThirdPlace => 'Harmadik hely';

  @override
  String get finishFourthPlace => 'Negyedik hely';

  @override
  String get finishDidNotQualify => 'Nem jutott ki';

  @override
  String get careerRepIconic => 'Ikonikus';

  @override
  String get careerRepRenowned => 'Elismert';

  @override
  String get careerRepEstablished => 'Bejáratott';

  @override
  String get careerRepRising => 'Feltörekvő';

  @override
  String get careerRepUnproven => 'Bizonyítatlan';

  @override
  String get hubOfferStepUp => 'Előrelépés';

  @override
  String get hubOfferLateral => 'Oldalirányú váltás';

  @override
  String get hubOfferRebuild => 'Újjáépítés';

  @override
  String careerNationsCupWon(String league) {
    return '$league divízió · Bajnokok';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return '$league divízió · Ezüstérmesek';
  }

  @override
  String careerNationsCupSemi(String league) {
    return '$league divízió · Elődöntős';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return '$league divízió · $position.';
  }

  @override
  String tourRunInto(String round) {
    return 'Következik: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Következik a bronzmérkőzés';

  @override
  String tourRunThrough(String round) {
    return 'Továbbjutás: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Kiesés: $round';
  }

  @override
  String get tourRunInGroup => 'Csoportkör folyamatban';

  @override
  String get tourRunGroupOut => 'Kiesés a csoportkörben';

  @override
  String resultsCycleTitle(int year, String nation) {
    return '$year ciklus · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played mérkőzés  ·  ${won}GY ${drawn}D ${lost}V';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Világbajnokság: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Még tart';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Két gól hátrány $opponent ellen a szünetben, és mindent ledolgoztak. Ez egy csapat.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Két gólos hátrány $opponent ellen, a végén pedig már nem számított. Kevés csapat csinálja ezt utánuk.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Félidő: két gól hátrány $opponent ellen. Lefújás: már nem. A második félidő egész más meccs volt.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Két gólról fordítottunk $opponent ellen. Bármit mondtak a szünetben, mondják minden héten.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Jó, ledolgoztuk $opponent ellen. Most valaki magyarázza el az első negyvenöt percet.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Két gól hátrány $opponent ellen, és ennek örülnünk kellene? Hozzátok rendbe az első félidőt.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Két gólos előny $opponent ellen a szünetben, és elúszott. Jobb csapatokkal is megesik.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Két góllal vezettünk $opponent ellen, és kicsúszott a kezünkből. Hosszú ciklus áll előttünk, van idő.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Félidő: két góllal vezetünk $opponent ellen. Lefújás: ennek már nyoma sincs.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Kétgólos előny $opponent ellen, negyvenöt perc alatt elpárolgott.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Két góllal vezettünk, és elbuktuk. $opponent ellen. Valakinek felelnie kell ezért.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Két góllal vezetünk $opponent ellen, és ezt hoztuk ki belőle. Minden egyes alkalommal.';
  }

  @override
  String get cycleBackupDone =>
      'A karrier elmentve a telefon FNM mappájába. Az alkalmazás törlésekor ez is elvész: ha máshol is meg akarod őrizni, használd a mentések képernyőn a „Biztonsági mentés erről a mentésről” lehetőséget.';

  @override
  String get cycleBackupFailed => 'Most nem sikerült elmenteni a karriert.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Felejthetetlen este $opponent ellen. Mennyire büszke erre a csapatra?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent nem bírta a tempót. Ez az a csapat, amelyben mindig hitt?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Nagy győzelem $opponent ellen. Mi döntött ma este?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent legyőzve, kényelmesen. Hol nyerték meg a meccset?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Szép győzelem $opponent ellen. Egyetlen jó este: miért hinné bárki, hogy ez tartós lesz?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Jó eredmény $opponent ellen. Ez volt a terve, vagy a játékosok maguk jöttek rá?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Nehéz este $opponent ellen. Mit mond a játékosoknak egy ilyen után?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Ezt senki sem látta jönni $opponent ellen. Csak egy ilyen este volt?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Kijózanító este volt $opponent ellen. Mi ment félre?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent szétszedte Önöket. Elég jó ez a keret?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Mindenben lemaradtak $opponent ellen. Hogyan hagyta, hogy idáig fajuljon?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent annyi gólt lőtt, amennyit akart. Hol volt ma este a terv?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Megint elúszott egy meccs, ezúttal $opponent ellen. Hogyan fordítja meg ezt a sorozatot?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Elapadtak az eredmények, és $opponent még rontott is rajta. Még mindig hisz ebben a csapatban?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Megint nincs győzelem, most $opponent ellen, és a vezetőség figyel. Biztos az állása?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return '$opponent után már hosszú a sorozat. Aggódik a jövője miatt?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Most még $opponent is. Az elődjét kirúgták egy ilyen sorozat miatt. Önnek miért kellene megúsznia?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Az újabb este után, $opponent ellen, minden rádiós műsor a távozását követeli. Lemondana, ha a vezetőség kérné?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Az állását tette fel, és $opponent ellen nem úgy alakult, ahogy szerette volna. Hogy viseli?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Letelt a három meccs, az utolsó $opponent ellen volt. A tesztet Ön maga szabta. Mit szól az ítélethez?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Azt mondta, a következő három alapján ítéljék meg. $opponent után megtettük. Még az Öné az állás?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Három meccs, az utolsó $opponent ellen, és nem az, amit ígért. Beszélt már a vezetőséggel a jövőjéről?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Maga szabta a tesztet, és $opponent ellen megbukott. Lemond?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Az Ön szavai, nem a miénk: a következő három alapján ítéljék meg. $opponent után miért ül még mindig ott?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Többet vár tőlük. Van valaki konkrétan?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Magasra tette a lécet. Kinek kell elsőként felnőnie a feladathoz?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Azt mondja, néhányuknak magukba kell nézniük. Kikre gondol?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Nem volt elég jó, mondja. Kiről beszél?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Mindig homályosan fogalmaz. Neveket is mond, vagy ez magára száll vissza?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Minden héten más a hibás. Ezúttal ki?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Bátor szavak. És ha a következő nem úgy alakul, ahogy szeretné?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Az ország számon fogja kérni Önön. Mi lesz, ha nem jön össze?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'És ha nem nyerik meg? Akkor mi lesz?';

  @override
  String get pressBeatIfYouDontNeutral2 => 'Kimondta. Mi történik, ha téved?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Már hallottunk ígéreteket ebben a teremben. Mivel tartozik a szurkolóknak, ha ez is megbukik?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'És ha nem lesz belőle semmi, mi lesz a kifogás?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Még egy kérdés, ha bírja. Min kell még dolgoznia ennek a csapatnak?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Ha lecsillapodnak a kedélyek, mit visz magával a mai estéből a következő meccsre?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Menjünk egy kicsit mélyebbre. Min kell javítani a következő meccsig?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Az eredményen túl: ott tart ez a csapat, ahol szeretné?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Sok szó, kevés mondanivaló. Mi változik valójában ezután?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'A szurkolók egyenes választ várnak. Elég jó ez a csapat, igen vagy nem?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player kiváló volt ma este. Meddig juthat?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player minden címlapon ott van ma este. Számított erre?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player kiemelkedett. Mit kért tőle ma este?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return '$player döntött ma este?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return '$player nélkül egészen más a történet. Ez csapat, vagy egyetlen játékos?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player zseniális volt. Ez az Ön érdeme, vagy az övé?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player nehéz estét zárt. Fáj valamije?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player nem az ő estéjét kapta. Megnyugtatja valahogy?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player küszködött ma este. Megtartja a helyét?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player lemaradt a tempóról. Mit gondolt a játékáról?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player megint csak utas volt. Miért állítja be folyton?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Mindenki látta, hogy $player nincs formában. Mindenki, kivéve a cserepadot?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Azt mondta, megnyerik a következőt, és meg is nyerték. Jó érzés, hogy igaza lett?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Győzelmet ígért a következő meccsre, és meg is hozta. Magabiztosság vagy fenyegetőzés?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Azt mondta, megnyerik a következőt, és megnyerték. Szerencse, vagy mostantól komolyan vegyük a szavait?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Azt mondta, megnyerik azt a meccset. Nem sikerült. Mi ment félre?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Azt mondta, megnyerik a következőt. Nem nyerték meg. Miért higgyünk a következő ígéretének?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Azt mondta, megnyerik a következőt. Nem nyerték. Számít még valamit a szava ebben a teremben?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Három meccs alapján kérte az ítéletet, és megfelelt. Igazolva érzi magát?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Ítéljenek meg a következő három alapján, mondta. Megtettük, és jöttek az eredmények. Mit tanított Önnek ez a teszt?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Három meccset adott magának, és átvészelte. Volt valaha is ilyen nehéz a teszt?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Három meccs alapján kérte az ítéletet. Nem úgy alakultak, ahogy szeretett volna. Mit tanult?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Azt mondta, a következő három alapján ítéljék meg. A három meccs elmúlt, és vele együtt a bizalmi előleg is. Most mi lesz?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Maga szabta a tesztet, és megbukott. Miért venné bárki komolyan a szavát?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Kiállt $player mellett, amikor mások nem. Beváltotta. A dicsőség egy része az Öné?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Kiállt $player mellett. Beváltotta. Hit vagy tudás?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Kiállt $player mellett, és most az egyszer megérte. Legközelebb is ilyen biztos lesz?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Kitartott $player mellett, de nem jött be. Még mindig hisz benne?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Kiállt $player mellett. Nem hálálta meg. Hiba volt?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Az ítélőképessége vagy a hűsége: melyik csődöt mondott $player esetében?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Keményen bánt $player játékossal, és azóta a meccsek igazat adtak Önnek. Van ebben némi elégtétel?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Megkritizálta $player játékost, és nem válaszolt. Van számára visszaút?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Kiakasztotta $player játékost, és azóta sem tért magához. Ön törte össze?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Megkritizálta $player játékost, és ő a pályán válaszolt. Ez volt a terv végig?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return '$player játékost hibáztatta, és azóta az egyik legjobbja. Tartozik neki egy bocsánatkéréssel?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Cserben hagyta $player játékost, és azóta ő a legjobb embere. Bocsánatot kér?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Ezek a játékosok mindent megadtak nekem. Egyiküket sem cserélném el.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Senki sem dolgozik keményebben ennél a csapatnál. Egész nap védeni fogom őket.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Erről a székről egy rossz szót sem hallanak a játékosaimra.';

  @override
  String get pressReplyCreditPlayers4 =>
      'A játékosoké az érdem, nem az enyém. Róluk írjanak.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Ez az én hibám. Én választottam ki a csapatot, és én állítottam fel.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Engem ítéljenek meg, ne őket. Az én csapatom, az én felelősségem.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Ha valakit hibáztatni akarnak, itt ülök.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'A felelősség az enyém. A játékosokat hagyják ki ebből.';

  @override
  String get pressReplyDemandMore1 =>
      'Többet akarok. Páran pontosan tudják, mire gondolok.';

  @override
  String get pressReplyDemandMore2 =>
      'Ezen a szinten az erőfeszítés nem elég. Többet akarok, és meg is mondtam nekik.';

  @override
  String get pressReplyDemandMore3 =>
      'Mindegyiküktől többet várok, holnaptól kezdve.';

  @override
  String get pressReplyDemandMore4 =>
      'Néhányuknak magukba kell nézniük. Nem vagyok elégedett.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Megnyerjük a következőt. Le is írhatják.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Jegyezzék meg a szavaimat: megnyerjük a következő meccset.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'A következő meccsen nyerünk. Azért mondom itt, hogy számon kérhessenek rajta.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Biztos vagyok ebben a csapatban. Megnyerjük a következő meccset.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'A következő három meccs alapján ítéljenek meg. Ez tisztességes.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Adjanak három meccset. Ha addigra nincs rendben, ítéljenek meg érte.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'A következő három megmutatja, én vagyok-e a megfelelő ember. Kérjék számon rajtam.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Három meccs. Utána azt írnak rólam, amit akarnak.';

  @override
  String get pressReplyDeflect1 =>
      'Egyik meccs a másik után. Többet nem tennék hozzá.';

  @override
  String get pressReplyDeflect2 =>
      'Ma nem fogok címlapot szolgáltatni Önöknek.';

  @override
  String get pressReplyDeflect3 => 'A következő meccs. Csak arra gondolok.';

  @override
  String get pressReplyDeflect4 => 'Amit gondolok, az az öltözőben marad.';

  @override
  String get pressReplyTakeCredit1 =>
      'Azért mondtam, mert hittem benne, és igazam lett.';

  @override
  String get pressReplyTakeCredit2 =>
      'Jól olvastam a helyzetet. Ezért vagyok itt.';

  @override
  String get pressReplyTakeCredit3 =>
      'Nevezzék ítélőképességnek. Tudtam, mit mondok.';

  @override
  String get pressReplyTakeCredit4 =>
      'Meghoztam a döntést, és bejött. Ezt elkönyvelem.';

  @override
  String get pressReplyStandByIt1 =>
      'Azt mondtam, amit gondoltam. Kiállok mellette.';

  @override
  String get pressReplyStandByIt2 => 'Egy szavamat sem vonom vissza.';

  @override
  String get pressReplyStandByIt3 =>
      'Ugyanaz a válaszom, mint akkor. Komolyan gondoltam, és most is komolyan gondolom.';

  @override
  String get pressReplyStandByIt4 => 'Holnap is ugyanezt mondanám.';

  @override
  String get pressReplyAdmitMistake1 => 'Ezt rosszul gondoltam. Vállalom.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Jogos, rosszul ítéltem meg. Tanulok belőle.';

  @override
  String get pressReplyAdmitMistake3 => 'Tévedtem, és ki merem mondani.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Ez a döntés nem jött be, és az enyém volt.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player teljes támogatásomat élvezi. Be fog érni.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Hiszek $player játékosban, és meg fogja mutatni, miért.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return '$player játékosra tőlem egy rossz szót sem hallanak. Teljesíteni fog.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player benne marad a terveimben. Nézzék meg, mit tesz legközelebb.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player cserben hagyott minket ma este, és ő is tudja.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Sokkal többet vártam $player játékostól. Erre válaszolnia kell.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player nem volt a szintjén. Ezt nyilvánosan is kimondom.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Ez nem volt elég jó $player részéről, és ezt tőlem is hallani fogja.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Hivatalosan: megnyeritek a következő meccset.';

  @override
  String get pressOnRecordJob =>
      'Hivatalosan: a következő három meccs alapján ítélnek meg.';

  @override
  String pressOnRecordBack(String player) {
    return 'Hivatalosan: kiállsz $player mellett.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Hivatalosan: $player cserben hagyott.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Kimondta, és megtörtént. $nation kapitánya komolyan gondolja, amit mond.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Hangosan kimondta, aztán meg is csinálta. Ilyen emberre volt szüksége $nation csapatának.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: megmondta, és bejött. Rendben van.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Nyilvánosan vállalta, és tartotta magát. Egy pont neki. $nation megy tovább.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Egyszer eltalálta. $nation, ne szokj hozzá.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Még az elromlott óra is naponta kétszer pontos. $nation most szerencsés volt.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Kimondta, és nem jött össze. Még mellette állok. $nation újra nekifut.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: többet ígért, mint amennyit kaptunk, de inkább legyen olyan kapitány, aki bízik magában.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: nyilvánosan kimondta, és nem történt meg. Az emberek emlékezni fognak.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Nagy szavak, semmi mögöttük. $nation: legközelebb mondj kevesebbet.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Kiállt és elmondta nekünk. Aztán jött ez. $nation többet érdemel a locsogásnál.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'A szavának most már semmi értéke. Írd fel magadnak, $nation.';
  }

  @override
  String get ncZoneNorth => 'Északi zóna';

  @override
  String get ncZoneWest => 'Nyugati zóna';

  @override
  String get ncZoneEast => 'Keleti zóna';

  @override
  String get ncZoneCentralSouthern => 'Közép- és Dél-afrikai zóna';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Bajnokok';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Ezüstérmesek';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Elődöntős';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Nyolcaddöntő';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Negyeddöntős';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · $position.';
  }

  @override
  String get objectiveNcFinalsEight => 'Jutni a negyeddöntőbe';

  @override
  String get objectiveNcZoneWinGroup => 'Megnyerni a csoportot';

  @override
  String get finishNcFinalsEight => 'Negyeddöntő';

  @override
  String get finishNcBottomHalf => 'A csoport alsó fele';

  @override
  String get tourContTabZones => 'ZÓNÁK';

  @override
  String get tourContTabFinalsEight => 'KIESÉSES SZAKASZ';

  @override
  String get tourContFinalsEightSoon =>
      'A kieséses szakasz novemberben kezdődik nyolcaddöntővel: mind a 14 csoportgyőztes és a 2 legjobb második.';

  @override
  String get tourContQuarterFinals => 'NEGYEDDÖNTŐK';

  @override
  String get tourContZoneAdvancement =>
      'Minden csoportgyőztes továbbjut a nyolcaddöntőbe, a 2 legjobb másodikkal együtt. Senki sem esik ki.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Észak-amerikai Nemzetek Kupája';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Megnyerni az Észak-amerikai Nemzetek Kupáját';

  @override
  String get objectiveNcWinItAfrica => 'Megnyerni a Nations Cupot';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Jutni az Észak-amerikai Nemzetek Kupájának döntőjébe';

  @override
  String get objectiveNcReachFinalAfrica => 'Jutni a Nations Cup döntőjébe';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Az Észak-amerikai Nemzetek Kupájának győztese';

  @override
  String get finishNcChampionsAfrica => 'A Nations Cup győztese';

  @override
  String pressAimQualWarm1(String competition) {
    return '$competition: kezdődik a selejtező, és az ország hisz ebben a csapatban. Mi a célja?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return '$competition: új selejtezősorozat indul, és magasan van a hangulat. Meddig juthat ez a csapat?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return '$competition: kezdődik a selejtező. Mi a cél ebben a sorozatban?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return '$competition: itt a selejtező. Hol látja végezni ezt a csapatot?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return '$competition: kezdődik a selejtező, és sokan kétlik, hogy kijutnak. Mit mond nekik?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return '$competition: újabb selejtezősorozat. Miért hinné bárki, hogy ez más lesz?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Itt a $competition, és az egész ország Önök mögött áll. Meddig juthatnak?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return '$competition: ott vannak, és a szurkolók álmodoznak. Mi a cél?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Ezen a héten kezdődik a $competition. Mi számítana sikernek?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Közel az első meccsük a tornán ($competition). Tűzzön ki nekünk célt.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Itt a $competition, és senki sem vár tőlük sokat. Valójában mit remél?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return '$competition: ott vannak, de a kétségek nem múltak el. Mi a célja?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival ugyanabban a csoportban van Önökkel. Aggasztja a csapat?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'A sorsolás $rival csapatát az útjukba állította. Hogy látja azt a meccset?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival tűnik a legerősebbnek a csoportjukban. Ők a favoritok?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Mit gondol a következő csapatról: $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival ugyanabban a csoportban van Önökkel. Legyen őszinte: fel tudják venni velük a versenyt?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Sokan azt várják, hogy $rival legyőzi Önöket. Tévednek?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player remek formában van. Eljött az ő ideje?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player minden címlapon ott van. El tudja vinni a hátán ezt a csapatot?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Mennyire függ ez a sorozat $player játékostól?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Készen áll $player arra, hogy vezesse a csapatot?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Ha $player nincs csúcsformában, van még bármi ebben a csapatban?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player vállán nagy teher van. Túl nagy?';
  }

  @override
  String get pressReplyAimHigher1 => 'Tovább megyünk, mint bárki gondolná.';

  @override
  String get pressReplyAimHigher2 =>
      'Többet akarok, mint amennyit a szövetség kért, és ezt hangosan ki is mondom.';

  @override
  String get pressReplyMatchBrief1 => 'Ismerjük a célt, és el is érjük.';

  @override
  String get pressReplyMatchBrief2 =>
      'A szövetség kitűzött egy célt. Teljesíteni fogjuk.';

  @override
  String get pressReplyPlayDown1 => 'Menjünk meccsről meccsre.';

  @override
  String get pressReplyPlayDown2 =>
      'Nagy ígéretek nélkül. Meglátjuk, hol tartunk.';

  @override
  String get pressReplyPromiseQualify1 => 'Kijutunk. Le is írhatják.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Ez a csapat ott lesz a döntő tornáján.';

  @override
  String get pressReplyFearNobody1 => 'Mi senkitől sem félünk.';

  @override
  String get pressReplyFearNobody2 => 'Nekik is ellenünk kell játszaniuk.';

  @override
  String get pressReplyRespectRival1 => 'Ők a favoritok, és tiszteljük őket.';

  @override
  String get pressReplyRespectRival2 =>
      'Nagyon jó csapat. A legjobbunkat kell nyújtanunk.';

  @override
  String get pressReplyTeamFirst1 =>
      'Az egész csapatról szól, nem egyetlen játékosról.';

  @override
  String get pressReplyTeamFirst2 => 'Ezt senki sem nyeri meg egyedül.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Hivatalosan: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Hivatalosan: nincsenek ígéretek.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'A sorozat előtt célt tűzött ki, és teljesítette. Ez az eddigi legbüszkébb pillanata?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Megmondta, mit ér el, és el is érte. Kétséges volt valaha?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Elérte a kitűzött célt. Szerencse, vagy tényleg ez volt a terv?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Célt tűzött ki, és nem érte el. Mi ment félre?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Többet ígért, mint amennyit ez a csapat teljesített. Megbánta, hogy kimondta?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'A sorozat előtt nagyot mondott, aztán elmaradtak. Miért higgyünk most Önnek?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'A sajtó a céljaidat várja: $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return '$level. szint · $amount';
  }

  @override
  String get formOnFire => 'Lángol';

  @override
  String get formGood => 'Formában';

  @override
  String get formSteady => 'Egyenletes';

  @override
  String get formPoor => 'Formán kívül';

  @override
  String get formCold => 'Jéghideg';

  @override
  String get playerFormTitle => 'FORMA ÉS ERŐNLÉT';

  @override
  String playerFormAverage(String rating) {
    return 'Átlagosan $rating az utóbbi meccsein';
  }

  @override
  String get playerFormNoGames => 'Túl kevés friss meccs az ítélethez';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta az értékeléséhez a következő meccsen';
  }

  @override
  String get playerFormNoEffect =>
      'Nem változik az értékelése a következő meccsen';

  @override
  String get sideGroupHome => 'Főoldal';

  @override
  String get sideGroupTeam => 'Csapat';

  @override
  String get sideGroupCompetitions => 'Versenyek';

  @override
  String get sideGroupFederation => 'Szövetség';

  @override
  String get sideGroupHistory => 'Történelem';

  @override
  String get sideInbox => 'Postaláda';

  @override
  String get sideSquad => 'Keret';

  @override
  String get sideTactics => 'Taktika';

  @override
  String get sideMainMenu => 'Főmenü';

  @override
  String get sideCallUps => 'Meghívók';

  @override
  String get sideTournaments => 'Tornák';

  @override
  String get sideRanking => 'Ranglista';

  @override
  String get sideResults => 'Eredmények';

  @override
  String get sideFinances => 'Pénzügyek';

  @override
  String get sideBoard => 'Vezetőség';

  @override
  String get sideManager => 'Kapitány és stáb';

  @override
  String get sideRecords => 'Rekordok';

  @override
  String get sideLegends => 'Legendák';

  @override
  String get sideHeadToHead => 'Egymás ellen';

  @override
  String get sideAchievements => 'Eredmények';

  @override
  String get sideCareer => 'Karrier';

  @override
  String get topBarNext => 'Következő';

  @override
  String get topBarDrawPending => 'Sorsolás hamarosan';

  @override
  String get paneFullProfile => 'Teljes profil';

  @override
  String get panePickPlayer => 'Válassz egy játékost, hogy itt lásd a lapját';

  @override
  String get inboxPickMessage => 'Válassz egy üzenetet, hogy itt elolvasd';

  @override
  String get inboxFilterAll => 'Mind';

  @override
  String get panelViewAll => 'Összes';

  @override
  String get gridViewOverview => 'Áttekintés';

  @override
  String get gridColCondition => 'Erőnlét';

  @override
  String get gridColStatus => 'Állapot';

  @override
  String get gridColRank => 'Hely';

  @override
  String get gridColMove => 'Változás';

  @override
  String get gridColNation => 'Ország';

  @override
  String get gridColRegion => 'Régió';

  @override
  String get gridColPoints => 'Pont';

  @override
  String get panePickNation => 'Válassz egy országot, hogy itt lásd a mérlegét';

  @override
  String get resultsCyclesTitle => 'Ciklusok';

  @override
  String get tourDrawStart => 'Sorsolás indítása';

  @override
  String get tourDrawViewGroups => 'Csoportok megtekintése';

  @override
  String get gridColCeiling => 'Plafon';

  @override
  String get gridColYearGain => 'Fejlődés';

  @override
  String get gridColMarkedAt => 'Felvételkor';

  @override
  String get budgetSetupTitle => 'Állítsd be a költségvetést';

  @override
  String get budgetEffectsTitle => 'Mit vesz ez a költségvetés';

  @override
  String get naturalisationTitle => 'Honosítás';

  @override
  String get yTrending => 'Felkapott';

  @override
  String get yVoices => 'Hangok';

  @override
  String get yConversation => 'Beszélgetés';

  @override
  String get allTimeRecordsTitle => 'Minden idők világrekordjai';

  @override
  String get h2hMeetingsTitle => 'Minden összecsapás';

  @override
  String get h2hPickOpponent =>
      'Válassz ellenfelet, hogy itt lásd az összes összecsapást';

  @override
  String get savesTitle => 'Mentések';

  @override
  String get gridColPlayer => 'Játékos';

  @override
  String get gridColPos => 'Poszt';

  @override
  String get gridColActive => 'Aktív';

  @override
  String get gridColMotm => 'ME';

  @override
  String get gridColAvg => 'Átl.';

  @override
  String get gridColOpponent => 'Ellenfél';

  @override
  String get gridColStarts => 'Kezdő';

  @override
  String get gridColTournaments => 'Tornák';

  @override
  String get gridColDate => 'Dátum';

  @override
  String get gridColLastPlayed => 'Utoljára játszva';

  @override
  String get gridColManager => 'Kapitány';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ország',
      one: '1 ország',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Világranglista szerint rendezve';

  @override
  String get nationsStrength => 'Erő';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier / 5';
  }

  @override
  String get nationsSquadOverall => 'Keret összértékelése';

  @override
  String get nationsOpeningBudget => 'Nyitó költségvetés';

  @override
  String get nationsStarPlayer => 'Sztárjátékos';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Sztár $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return '$age éves';
  }

  @override
  String get nationsBoardExpects => 'A vezetőség elvárása';

  @override
  String nationsManage(String nation) {
    return 'Irányítás: $nation';
  }

  @override
  String get nationsManagerNext =>
      'A kapitány nevét a következő lépésben adod meg';

  @override
  String get playerPageTitle => 'Játékos';

  @override
  String get nationPageTitle => 'Ország';

  @override
  String get friendliesYourGames => 'Barátságos meccseid';

  @override
  String hubEventInjuryCover(String player) {
    return 'Sérült játékos pótlása: $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches meccset kihagy',
      one: 'A következő meccset kihagyja',
    );
    return '$_temp0. Hívj be valakit, vagy játssz tovább nélküle.';
  }

  @override
  String get injuryCoverTitle => 'PÓTLÁS';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) sérült. Hívj be bárkit a keretből kimaradtak közül, bármely posztra, vagy tartsd meg, és játssz tovább.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Behívás: $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return '$player marad, játsszunk tovább';
  }

  @override
  String get injuryCoverPick => 'Válassz pótlót';

  @override
  String get injuryCoverNone =>
      'A kereten kívül senki sem alkalmas a csatlakozásra.';

  @override
  String get nationNowRanking => 'Világranglista';

  @override
  String get nationNowForm => 'Forma';

  @override
  String get nationNowNoForm => 'Még nem játszott meccset';

  @override
  String get nationNowNext => 'Következő meccs';

  @override
  String get nationNowNoNext => 'Nincs betervezve semmi';

  @override
  String get nationNowSquad => 'Keret';

  @override
  String get nationNowAgainstYou => 'Veled szemben';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}GY ${d}D ${l}V';
  }

  @override
  String get nationNowLastMeeting => 'Utolsó összecsapás';

  @override
  String nationNowOverall(int value) {
    return 'Összértékelés: $value';
  }

  @override
  String get hubUpcoming => 'KÖVETKEZŐ MECCSEK';

  @override
  String get hubFullSchedule => 'Teljes menetrend';

  @override
  String get scheduleTitle => 'Menetrend';

  @override
  String get scheduleToday => 'Ma';

  @override
  String get scheduleKnockoutPending => 'Kieséses szakasz, ha továbbjutsz';

  @override
  String get scheduleNextRoundPending => 'Következő kör';

  @override
  String scheduleFromDate(String date) {
    return 'Innentől: $date';
  }

  @override
  String get scheduleHomeShort => 'H';

  @override
  String get scheduleAwayShort => 'I';

  @override
  String get tacticsNoPresetsInMatch =>
      'Még nincs mentett taktika. Mentsd el az egyiket a Taktika képernyőn a meccs előtt.';

  @override
  String get homeCampaigns => 'Kampányok';

  @override
  String get homeContinueCampaign => 'KAMPÁNY FOLYTATÁSA';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · $cycle. ciklus / $total';
  }

  @override
  String get campaignsTitle => 'Kampányok';

  @override
  String get campaignTransplantTitle => 'Az átültetés';

  @override
  String get campaignTransplantTwist =>
      'Olaszország nyolc legjobbja San Marinóra vált';

  @override
  String get campaignTransplantGoal => 'Kijutni az Európa-bajnokságra';

  @override
  String get campaignGrudgeTitle => 'Régi harag';

  @override
  String get campaignGrudgeTwist => 'Grúzia és Albánia egy csoportba sorsolva';

  @override
  String get campaignGrudgeGoal => 'Albánia előtt végezni a selejtezőben';

  @override
  String get campaignTransplantIntro =>
      'San Marinónak még sosem volt említésre méltó selejtezője. Aztán nyolc olasz sztár felveszi az útlevelet, és besétál. Egy ciklusod van, hogy a különlegességből csapatot formálj.';

  @override
  String get campaignGrudgeIntro =>
      'Grúziát és Albániát ugyanabba a selejtezőcsoportba sorsolták, és egyik sem bocsát meg egy vereséget. Végezz Albánia előtt, aztán nézd meg, meddig viheted.';

  @override
  String get campaignStars1Transplant => 'Kijutás';

  @override
  String get campaignStars2Transplant => 'Bejutni a kieséses szakaszba';

  @override
  String get campaignStars3Transplant => 'Megnyerni az Európa-bajnokságot';

  @override
  String get campaignStars1Grudge => 'Albánia előtt';

  @override
  String get campaignStars2Grudge => 'És kijutás';

  @override
  String get campaignStars3Grudge => 'És kétszer legyőzni őket';

  @override
  String get campaignFree => 'Ingyenes';

  @override
  String get campaignStart => 'Indítás';

  @override
  String get campaignPartOfUnlimited => 'Az Unlimited része';

  @override
  String get campaignResume => 'Folytatás';

  @override
  String get campaignAbandon => 'Feladás';

  @override
  String get campaignAbandonConfirm =>
      'Feladod ezt a menetet? Az előrehaladás elvész; a bélyegged megmarad.';

  @override
  String get campaignMoveToSaves => 'Áthelyezés a mentésekhez';

  @override
  String get campaignCannotContinue =>
      'Ennek a kampánynak a világa túl messze van a valóditól ahhoz, hogy karrierként folytatódjon.';

  @override
  String get campaignMoveSlotsFull =>
      'Betelt a mentési helyed. Szabadíts fel egyet.';

  @override
  String get campaignStampConquered => 'Teljesítve';

  @override
  String get campaignStampFailed => 'Elbukva';

  @override
  String get campaignDifficultyHard => 'Nehéz';

  @override
  String get campaignDifficultyMedium => 'Közepes';

  @override
  String get campaignGoalLabel => 'Cél';

  @override
  String get campaignStarsLabel => 'Csillagok';

  @override
  String get campaignRunInProgress =>
      'Ennek a kampánynak már van folyamatban lévő menete.';

  @override
  String get campaignVerdictWon => 'Teljesítve';

  @override
  String get campaignVerdictLost => 'Most nem sikerült';

  @override
  String get campaignVerdictContinue => 'Tovább';

  @override
  String campaignProgressQualifying(String position) {
    return 'Selejtező: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Döntő tornája: $stage';
  }

  @override
  String get campaignRunInNumbers => 'A menet számokban';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Megnyert összecsapások: $won / $played';
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
  String get campaignGuineasTitle => 'A Guineák legjobbja';

  @override
  String get campaignGuineasTwist =>
      'Egyenlítői-Guinea, Afrika Guineái közül a legkisebb, két cikluson át';

  @override
  String get campaignGuineasGoal => 'Legyőzni Guineát és Guinea-Bissaut';

  @override
  String get campaignGuineasIntro =>
      'Három afrikai ország viseli a Guinea nevet, és közülük Egyenlítői-Guinea a legkisebb. Két ciklusod van, hogy legalább egyszer-egyszer legyőzd Guineát és Guinea-Bissaut, aztán nézd meg, meddig juthatsz az Afrika-bajnokságon. Pápua Új-Guinea, a negyedik Guinea, már be van jegyezve egy barátságos meccsre.';

  @override
  String get campaignStars1Guineas => 'Legyőzni Guineát és Guinea-Bissaut';

  @override
  String get campaignStars2Guineas => 'És kijutni egy Afrika-bajnokságra';

  @override
  String get campaignStars3Guineas =>
      'És eljutni egy Afrika-bajnokság negyeddöntőjébe';

  @override
  String get campaignYoungFinnsTitle => 'Fiatal finnek';

  @override
  String get campaignYoungFinnsTwist =>
      'Finnország tinédzserekből álló aranygenerációja, három cikluson át';

  @override
  String get campaignYoungFinnsGoal => 'Kijutni egy világbajnokságra';

  @override
  String get campaignYoungFinnsIntro =>
      'Finnország felnőtt játékosai félreálltak, és egy aranygeneráció foglalta el a helyüket: minden játékos, akit kiválaszthatsz, legfeljebb 18 éves. Egyelőre nyersek, de megvan bennük a tehetség, hogy a világ egyik legjobb válogatottjává váljanak, ahogy Norvégia fiatal generációja is azzá vált. Három ciklusod van, hogy kivezesd őket egy világbajnokságra, aztán megnyerd az Európa-bajnokságot és a világbajnokságot.';

  @override
  String get campaignStars1YoungFinns => 'Kijutni egy világbajnokságra';

  @override
  String get campaignStars2YoungFinns => 'Megnyerni az Európa-bajnokságot';

  @override
  String get campaignStars3YoungFinns => 'Megnyerni a világbajnokságot';

  @override
  String get campaignGreenlandTitle => 'Egy grönlandi évszázad';

  @override
  String get campaignGreenlandTwist =>
      'Grönland száz évre átveszi San Marino helyét Európában';

  @override
  String get campaignGreenlandGoal => 'Kijutni egy Európa-bajnokságra';

  @override
  String get campaignGreenlandIntro =>
      'Grönland még sosem játszott tétmérkőzést válogatott szinten. Ebben a világban átvette San Marino helyét Európában, és a világranglista legaljáról indul: amatőr játékosok, műfüves pályák és a havazások közé szorult szezon. Száz éved, huszonöt ciklusod van, hogy kijuss egy Európa-bajnokságra, aztán egy világbajnokságra, és ha mersz álmodni, megnyerd valamelyiket.';

  @override
  String get campaignStars1Greenland => 'Kijutni egy Európa-bajnokságra';

  @override
  String get campaignStars2Greenland => 'Kijutni egy világbajnokságra';

  @override
  String get campaignStars3Greenland =>
      'Megnyerni az Európa-bajnokságot vagy a világbajnokságot';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Nem jutott ki';

  @override
  String get campaignCupOpen => 'Még eldöntetlen';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name ragyogott az $level válogatottban';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Akadémiai jelentés: $name felhívta magára a figyelmet';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Az $level válogatott kiemelkedő játékosa: $name';
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
      other: '$count alkalommal',
      one: 'egyszer',
    );
    return '$name $_temp0 volt eredményes az $level válogatottban $opponent ellen a legutóbbi válogatott időszakban.';
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
      other: '$count gól',
      one: 'Egy gól',
    );
    return '$_temp0 született $name révén, amikor az $level válogatott ebben az időszakban $opponent ellen lépett pályára.';
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
      other: '$count góllal',
      one: 'egy góllal',
    );
    return 'Az $level válogatott $opponent ellen játszott, $name pedig $_temp0 hagyta el a pályát.';
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
      other: '$count gólt',
      one: 'egy gólt',
    );
    return '$name $_temp0 készített elő az $level válogatottban $opponent ellen, és az elejétől a végéig irányította a játékot.';
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
      other: '$count gólpassz',
      one: 'egy gólpassz',
    );
    return 'Az $level válogatott ebben az időszakban $opponent ellen játszott, a szálakat pedig $name mozgatta: $_temp0 és egy olyan teljesítmény, amelyről a stáb még mindig beszél.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name kiemelkedő volt, amikor az $level válogatott kapott gól nélkül zárt $opponent ellen.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Kapott gól nélküli meccs az $level válogatottnak $opponent ellen, és ebben a legnagyobb része $name játékosnak volt.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name lenyűgözött az $level válogatottban $opponent ellen, a stáb tízből $mark pontra értékelte a játékát.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'Az $level válogatott ebben az időszakban $opponent ellen játszott, és az edzők egy nevet emeltek ki, $name: tízből $mark, a csapat legjobb osztályzata.';
  }

  @override
  String get newsYouthDevReady1 =>
      'Ebben a formában már elég jó ahhoz, hogy számításba jöjjön a felnőtt válogatottnál.';

  @override
  String get newsYouthDevReady2 =>
      'A stáb szerint már most készen áll a felnőtt futballra. A döntés a szövetségi kapitányé.';

  @override
  String get newsYouthDevClose1 =>
      'Jól fejlődik, és közel áll ahhoz, hogy bekerüljön a felnőtt válogatottba.';

  @override
  String get newsYouthDevClose2 =>
      'Nincs már messze a felnőtt válogatottól, és egy újabb jó idény elég lehet.';

  @override
  String get newsYouthDevGrowing1 =>
      'Szépen fejlődik, bár a felnőtt válogatott még egy-két lépésre van.';

  @override
  String get newsYouthDevGrowing2 =>
      'Van még munka, mielőtt felnőtt válogatott lesz belőle, de minden jó irányba mutat.';

  @override
  String get newsYouthDevRaw1 =>
      'Még nyers, és néhány évre van a felnőtt válogatottól, de a tehetsége szembetűnő.';

  @override
  String get newsYouthDevRaw2 =>
      'Még korai, és az akadémia edzői türelmet kérnek, nem főcímeket.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'A vetődési hatótávolsága és a tizenhatoson belüli uralma emeli ki a többiek közül.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'A labdafogása és a kidobásai a legjobbak, amelyeket az akadémia évek óta látott.';

  @override
  String get newsYouthStrengthGkStamina =>
      'A koncentrációja sosem lankad: a kilencvenedik percben is olyan éles, mint az elsőben.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'A gyorsasága és a fejjátéka a játéka kulcsa.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'A korát messze meghaladóan olvassa a játékot, és nyugodt a labdával.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Sosem kapcsol ki, és az utolsó percben is sprintel vissza.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Valódi erővel szerzi vissza a labdát, és azonnal előre viszi.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'A játékintelligenciája és a passzrepertoárja a játéka kulcsa.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Hihetetlen a motorja: a pálya minden fűszálát bejárja.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'A mélységi gyorsasága és a levegőben mutatott ereje minden védelemnek gondot okoz.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'A befejezései és a mozgása a tizenhatoson belül a játéka kulcsa.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Egész meccsen elölről letámad, és egy pillanatnyi nyugalmat sem hagy a védőknek.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'A szurkolók még sokáig énekelnek majd erről a meccsről $opponent ellen. Mit mondott a játékosoknak a lefújás után?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Ez erős üzenet volt $opponent ellen. Mennyi származott ebből az edzőpályáról?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Elismerés az eredményért $opponent ellen, de ilyen estéket már láttunk. Mi más ezúttal?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Mindenkinek van rossz estéje, és ez egy ilyen volt $opponent ellen. Milyen gyorsan tudja maga mögött hagyni?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent minden csapatrészben jobb volt. Hol kezdi a javítást?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'A szurkolók már a vége előtt távoztak $opponent ellen. Hibáztathatja őket?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Nehéz időszak ez, és $opponent ellen sem lett könnyebb. Mi tartja Önt talpon?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Újabb meccs győzelem nélkül, ezúttal $opponent ellen. Meddig tarthat még ez, mielőtt a vezetőség lép?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Most még $opponent ellen is. Maradt még valami a tervében, vagy ideje átadni a helyét valaki másnak?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Bármit írnak, a játékosokról írják. Ezt kiérdemelték.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Olyan csapatom van, amely tűzbe menne egymásért. Ez nem kevés.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Én hozom a döntéseket, így a kritika engem illet. Ez a munka része.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Először a szövetségi kapitányra nézzenek. Hibáztam, és helyre fogom hozni.';

  @override
  String get pressReplyDemandMore5 =>
      'Itt a jó nem elég jó. Ezt a szemükbe mondtam.';

  @override
  String get pressReplyDemandMore6 =>
      'Abban az öltözőben senkinek sincs biztos helye. Most már tudják.';

  @override
  String get pressReplyDeflect5 =>
      'Háromféleképpen is megkérdezhetik. A válasz ugyanaz lesz.';

  @override
  String get pressReplyDeflect6 =>
      'A gondolataimat a játékosoknak tartogatom. Biztosan megértik.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score $opponent ellen. Nyugodt, kontrollált, felnőtt futball. Öröm nézni.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$score $opponent ellen, izzadás nélkül. Ez a csapat kezd jó lenni az unalmasban, és az unalmas nyer trófeákat.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Három pont, semmi dráma, vissza a munkához.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Rutinszerű $score $opponent ellen. Senki sem fog emlékezni rá, és nem is kell.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score $opponent ellen, és valahogy mégis aggódom.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$score $opponent ellen. Egy igazi csapat ellen egy ilyen teljesítményt megbüntetnek.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score $opponent ellen. Összeszorított fog, szenvedés, győzelem. Ez egy csapat.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$score $opponent ellen, pusztán idegből. Én egy olyan csapatot választok, amely nem hajlandó kikapni.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Az utolsó másodpercig tartott, de a pontok a mieink.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Szoros $score $opponent ellen. Nem sok volt benne, és ez a futball.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score $opponent ellen. Egy szerencsés pattanás a másik irányba, és egészen másról beszélnénk.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Épp hogy kihúztuk $opponent ellen, $score. Senki ne nevezze ezt teljesítménynek.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score $opponent ellen. Nem vereség, és néha pont ez a feladat.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Keservesen kiharcolt pont $opponent ellen, $score. Tetszett a küzdeni akarás.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Igazságos pontosztozkodás, ahogy a régi kommentátorok mondták.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score $opponent ellen. Egyik csapat sem tett eleget, hogy többet érdemeljen.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score $opponent ellen. Az a fajta döntetlen, ami a hazaúton a buszon vereségnek érződik.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return '$score $opponent ellen, döntetlen. Folyton fejlődésről beszélünk, és folyton ezt csináljuk.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score $opponent ellen. Fáj, de eleget láttam ahhoz, hogy higgyek ebben a csapatban.';
  }

  @override
  String yLost13(String opponent, String score) {
    return '$opponent ellen kikaptunk, $score, és jók voltak. Elismerni és újra nekifutni.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Egy vereség, néhány tanulság, és hamarosan a következő meccs.';
  }

  @override
  String yLost15(String opponent, String score) {
    return '$score vereség $opponent ellen. Nehéz vitatkozni vele.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score $opponent ellen. Ugyanazok a hibák, mint legutóbb, ugyanazzal a magabiztossággal.';
  }

  @override
  String yLost17(String opponent, String score) {
    return '$opponent ellen kikaptunk, $score. Ha ezért senki sem felel, akkor mit csinálunk itt?';
  }

  @override
  String get yReactionShrug12 =>
      'Nekem jó így. Nem kell minden este tűzijáték.';

  @override
  String get yReactionShrug13 => 'A pont az pont. Ma éjjel jól alszom.';

  @override
  String get yReactionShrug14 => 'Láttam. Nincs megjegyzésem.';

  @override
  String get yReactionShrug15 => 'Valahol a rendben és a rendben között.';

  @override
  String get yReactionShrug16 =>
      'Ezért fizettem a streamért. Soha többet (visszajövök).';

  @override
  String get yReactionShrug17 => 'Kilencven perc futball alakú semmi.';

  @override
  String get yReactionRelief12 =>
      'Újra kapok levegőt. Büszke vagyok, hogy kitartottak.';

  @override
  String get yReactionRelief13 =>
      'Az ilyen győzelmek építenek csapatot. A csúnya szép.';

  @override
  String get yReactionRelief14 => 'A körmeim elfogytak, a pontok nem.';

  @override
  String get yReactionRelief15 => 'Lefújás még sosem hangzott ilyen jól.';

  @override
  String get yReactionRelief16 =>
      'Örülök, hogy nyertünk, aggódom, hogy hogyan.';

  @override
  String get yReactionRelief17 => 'Mindig megússzuk. Egyszer nem fogjuk.';

  @override
  String get yReactionFury12 =>
      'Szeretem ezt a csapatot, és pont ezért fáj ennyire.';

  @override
  String get yReactionFury13 =>
      'Rossz este. Legközelebb tartoznak nekünk eggyel, és ezt tudják.';

  @override
  String get yReactionFury14 =>
      'Hetven percnél kikapcsoltam. Hatvannál kellett volna.';

  @override
  String get yReactionFury15 => 'Se küzdelem, se ötlet, se kifogás.';

  @override
  String get yReactionFury16 =>
      'Mindig ugyanazok a gondok, és senki nem javít meg semmit.';

  @override
  String get yReactionFury17 =>
      'Valakinek a szövetségnél újra meg kellene néznie ezt, és elmagyaráznia.';

  @override
  String get backupShareHint =>
      'Egy biztonsági mentés fájlt készít az összes mentésből. Megőrzéshez válaszd a Google Drive-ot, az iCloud Drive-ot vagy a Fájlokat.';

  @override
  String backupLastAt(String date) {
    return 'Utolsó biztonsági mentés: $date';
  }

  @override
  String get backupNever => 'Még nincs biztonsági mentés';

  @override
  String get backupRemindersTitle => 'Emlékeztetők a mentésre';

  @override
  String get backupRemindersBlurb =>
      'Üzenet a postafiókodba, amikor az utolsó biztonsági mentés kezd régi lenni.';

  @override
  String get backupAutoICloudTitle => 'Automatikus iCloud-mentés';

  @override
  String get backupAutoDriveTitle => 'Automatikus Google Drive-mentés';

  @override
  String get backupAutoBlurb =>
      'Ment a meccsek után, a ciklus végén és amikor kilépsz az alkalmazásból. A legutóbbi kettőt tartja meg.';

  @override
  String get backupStatusUploading => 'Mentés folyamatban.';

  @override
  String get backupStatusUploaded => 'Elmentve.';

  @override
  String get backupStatusICloudSignedOut =>
      'Az iCloud ki van kapcsolva. Jelentkezz be az iCloudba, és kapcsold be az iCloud Drive-ot a Beállítások alkalmazásban.';

  @override
  String get backupStatusDriveSignedOut =>
      'Nem vagy bejelentkezve. Kapcsold be a kapcsolót a Google-bejelentkezéshez.';

  @override
  String get backupStatusNotConfigured =>
      'Az alkalmazás ezen verziójában még nem érhető el.';

  @override
  String get backupStatusUnavailable =>
      'A felhő most nem érhető el. Később újra próbálkozik.';

  @override
  String get backupStatusFailed =>
      'Az utolsó automatikus mentés nem sikerült. Később újra próbálkozik.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Bejelentkezve: $email';
  }

  @override
  String get backupDriveSignOut => 'KIJELENTKEZÉS';

  @override
  String get backupDriveSignInFailed =>
      'A Google-bejelentkezés nem sikerült. Próbáld újra később.';

  @override
  String get backupRestoreICloud => 'VISSZAÁLLÍTÁS ICLOUDBÓL';

  @override
  String get backupRestoreDrive => 'VISSZAÁLLÍTÁS GOOGLE DRIVE-BÓL';

  @override
  String get backupCrossPlatformHelp =>
      'iPhone és Android között váltasz? Az egyik telefonon ments fájlba, a másikon pedig állítsd vissza abból a fájlból.';

  @override
  String get backupCloudListBlurb =>
      'Az eszközeid biztonsági mentései ezen a fiókon. Koppints egyre a visszaállításhoz.';

  @override
  String get backupCloudListEmpty =>
      'Még nincs biztonsági mentés. Egy új mentés néhány perc alatt ér el egy másik eszközre.';

  @override
  String get backupCloudListFailed =>
      'A mentéseket nem sikerült beolvasni. Ellenőrizd a kapcsolatot, és próbáld újra.';

  @override
  String get backupCloudThisDevice => 'Ez az eszköz';

  @override
  String backupCloudMore(int count) {
    return 'További mentések: $count';
  }

  @override
  String get backupCloudNewer =>
      'Az alkalmazás újabb verziójával készült. Előbb frissíts.';

  @override
  String get backupCloudDownloading => 'A mentés letöltése.';

  @override
  String get backupRestoreSafetyNote =>
      'Előbb a telefon jelenlegi mentéseiről másolat marad ezen a telefonon.';

  @override
  String get backupRejectedSafety =>
      'Nem sikerült másolatot tartani a jelenlegi mentésekről, ezért semmi nem lett lecserélve.';

  @override
  String get newsBackupReminderTitle => 'Ideje menteni';

  @override
  String get newsBackupReminderBody =>
      'A mentéseid csak ezen a telefonon vannak. Nyisd meg a Beállításokat, és koppints a Mentés a felhőbe gombra, vagy kapcsold be ott az automatikus mentést. Ezek az emlékeztetők a Beállításokban ki is kapcsolhatók.';

  @override
  String get backupSafetyTitle => 'Visszaállítás előtti másolatok';

  @override
  String get backupSafetyBlurb =>
      'Ezen a telefonon maradnak arra az esetre, ha a visszaállítás tévedés volt. A legújabb három marad meg.';

  @override
  String get backupSafetyRestore => 'VISSZAÁLLÍTÁS';

  @override
  String get backupSafetyShare => 'MEGOSZTÁS';

  @override
  String get backupCloudNoDetails => 'A részletek még úton vannak.';

  @override
  String get tacticsLibraryTitle => 'TAKTIKAI KÖNYVTÁR';

  @override
  String get tacticsLibraryBlurb =>
      'A könyvtáradban lévő taktikákat bármelyik mentésbe betöltheted, az újakba is. A szerepek és a pontrúgás-végrehajtók poszt szerint mentődnek, nem játékos szerint.';

  @override
  String get tacticsSaveToLibrary => 'Mentés a könyvtárba';

  @override
  String get tacticsLoadFromLibrary => 'Betöltés a könyvtárból';

  @override
  String get tacticsLibraryEmpty =>
      'A könyvtárad üres. Ments ide egy taktikát, és bármelyik mentésben betöltheted.';

  @override
  String tacticsLibrarySaved(String name) {
    return '„$name” mentve a könyvtárba';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Betöltve: „$name”';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count szerep vagy pontrúgás-végrehajtó nem illett ehhez a kerethez.',
      one: '1 szerep vagy pontrúgás-végrehajtó nem illett ehhez a kerethez.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Átnevezés';

  @override
  String get tacticsLibraryRenameTitle => 'Taktika átnevezése';

  @override
  String get tacticsLibraryDelete => 'Törlés';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Törlöd: „$name”?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Minden mentésedben eltűnik a könyvtárból.';

  @override
  String get tacticsLibraryNameTaken =>
      'Már van ilyen nevű taktika a könyvtáradban.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Nem sikerült betölteni a könyvtárat.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Rendezési pályázat: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Rendezési pályázat';

  @override
  String get hostBidBlurb =>
      'A rendezőt sorsolással választják ki a pályázók közül. A pályázat nagyobb súlyt ad a nevednek: a stadionjaid kiinduló esélyt adnak, a pénz pedig növeli ezt, bár minden további millió valamivel kevesebbet ér. A pénz elkel, akár nyersz, akár nem.';

  @override
  String hostBidPrize(String amount) {
    return 'Ha nyersz, te rendezel, automatikusan kijutsz, és egyszeri $amount támogatást kapsz a következő költségvetésre.';
  }

  @override
  String get hostBidChance => 'Esély a rendezésre';

  @override
  String get hostBidBaseLabel => 'Stadionok és helyezés';

  @override
  String get hostBidInvestLabel => 'Befektetés';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Felső határ, $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'A befektetésed';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Szabad keret: $amount';
  }

  @override
  String get hostBidSubmit => 'Pályázat beadása';

  @override
  String get hostBidDecline => 'Most nem';

  @override
  String get hostBidUnavailable => 'Ez a pályázat már nem nyitott.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Nyertes pályázat: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Mi rendezzük a tornát, és rendezőként automatikusan ott leszünk. Az egyszeri $amount támogatás már a szövetség kasszájában van, és a főképernyőről azonnal feloszthatod e ciklus részlegei között.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Vesztes pályázat: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'A rendezés jogát elnyerte: $hosts. A pályázatunk ezúttal kevés volt, a ráfordított pénz elveszett, de a szövetség megmutatta magát.';
  }

  @override
  String get hostBidGrantEvent => 'Rendezői támogatás felosztása';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Rendezői támogatás: $amount, amelyet most hozzáadhatsz e ciklus részlegeihez. A már felosztott rész marad, a maradék a kasszában marad.';
  }

  @override
  String get stadiumsTitle => 'Nemzeti stadionok';

  @override
  String get stadiumsEntrySub => 'Fejlessz egy stadiont, vagy építs újat';

  @override
  String get stadiumsBlurb =>
      'Egy stadion szintje a mérete: 1. szint 15 000 hely alatt, 2. szint 15 000-től, 3. szint 25 000-től, 4. szint 40 000-től, 5. szint 60 000-től. Minden stadion kis bevételt hoz minden ciklus elején, több hellyel többet, amíg a szurkolók megtöltik. A bővítés azonnal helyeket ad, a következő ciklustól egy kis hírnevet is; a szűkítés csökkenti a fenntartást, de semmit sem térít vissza. A stadionjaid döntik el, mely tornák rendezésére pályázhatsz.';

  @override
  String stadiumsIncome(String amount) {
    return 'Stadionbevétel: ciklusonként $amount';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Hírnév a stadionokból: +$points';
  }

  @override
  String get stadiumsClosed =>
      'A munkákat a ciklus elején lehet megrendelni, a költségvetés beállítása előtt.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Befogadóképesség: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Szint: $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Fejlesztés: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Legmagasabb szint';

  @override
  String stadiumsOpens(int year) {
    return 'Épül, nyitás: $year';
  }

  @override
  String get stadiumsBuildTitle => 'Új stadion építése';

  @override
  String get stadiumsBuildBody =>
      'Elég drága: új stadion az általad választott városban, a következő ciklus elejétől használható.';

  @override
  String get stadiumsBuildCity => 'Város';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Építés: $cost';
  }

  @override
  String get stadiumsBuilding => 'Már épül egy stadion.';

  @override
  String get stadiumsNoCity => 'Már minden városban van új stadion.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Fejlesztés $level. szintre $cost összegért? Stadion: $stadium';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Építesz új stadiont $cost összegért? Város: $city';
  }

  @override
  String get stadiumsConfirm => 'Megerősítés';

  @override
  String get stadiumsCancel => 'Mégse';

  @override
  String get stadiumsRefused =>
      'A megrendelés nem ment át. Semmit nem vontak le.';

  @override
  String get stadiumsNameLabel => 'A stadion neve';

  @override
  String get stadiumsNameHint => 'Hagyja üresen, és a javasolt név marad.';

  @override
  String get stadiumsRename => 'Stadion átnevezése';

  @override
  String get hostBidSectionTitle => 'Rendezési pályázatok';

  @override
  String get hostBidOpenSub =>
      'Nem kötelező. Az új ciklus kezdete előtt dönts.';

  @override
  String get hostBidDecidedAtRollover =>
      'A rendezőt az új ciklus kezdetén hirdetik ki.';

  @override
  String get hostBidLodged =>
      'Pályázat beadva. A rendezőt az új ciklus kezdetén hirdetik ki.';

  @override
  String get hostBidDeclinedNote => 'Ezúttal úgy döntöttél, hogy nem pályázol.';

  @override
  String get hostBidOpensLater =>
      'Megfelelsz a feltételeknek. A ciklus végén pályázhatsz.';

  @override
  String get hostBidNoFunds => 'Nincs elég szabad keret a pályázathoz.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Még $count legalább $seats férőhelyes stadion kell.',
      one: 'Még 1 legalább $seats férőhelyes stadion kell.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return 'Az előző világbajnokságot ez a szövetség rendezte: $confederation.';
  }

  @override
  String get hostBidRecentHost =>
      'A legutóbbi három torna egyikét te rendezted.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Feltétel: $grounds stadion legalább $minSeats hellyel, ebből $bigGrounds legalább $bigSeats hellyel.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Mi rendezzük a tornát, és rendezőként automatikusan ott vagyunk. A $amount egyszeri támogatás már a szövetség keretében van, készen a ciklus költségvetésére.';
  }

  @override
  String get hubStadiumIncome => 'Stadionbevétel';

  @override
  String get stadiumsDownsize => 'Szűkítés';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Szűkíted ezt: $stadium, $seats helyre ($level. szint)? Semmit sem kapsz vissza, de csökken a fenntartás.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Ebben a ciklusban átépítve';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Ciklusonként $amount bevétel';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Visszavont pályázat: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'A pályázat ennek a csapatnak szólt: $nation, de az új ciklust máshol kezded. Visszavontuk, és semmit sem terheltünk.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'A ciklus zárásakor a szövetség kerete már nem fedezte a tétet. A pályázatot visszavontuk, és semmit sem terheltünk.';

  @override
  String get stadiumsViewMap => 'Térkép';

  @override
  String get stadiumsViewList => 'Lista';

  @override
  String get stadiumsMapPickCity =>
      'Koppints egy városra, hogy ott új stadiont építs.';

  @override
  String get stadiumsMapFit => 'Egész ország megjelenítése';

  @override
  String get campaignLegacyTitle => 'Az örökség beteljesítése';

  @override
  String get campaignLegacyTwist =>
      'Spanyolország, a regnáló Európa-bajnok, egy cikluson át';

  @override
  String get campaignLegacyGoal => 'Az Európa-bajnoki cím megvédése';

  @override
  String get campaignLegacyIntro =>
      'Spanyolország a regnáló Európa-bajnok, a kétkedők szerint azonban az aranykor csak egyszeri csoda volt. Egy ciklusod van, hogy bebizonyítsd az ellenkezőjét: védd meg a kontinens trónját, aztán indulj a világért. Tedd hozzá a Nations Cupot is, és beteljesül az örökség.';

  @override
  String get campaignStars1Legacy => 'Megnyerni az Európa-bajnokságot';

  @override
  String get campaignStars2Legacy => 'És a világbajnokságot';

  @override
  String get campaignStars3Legacy => 'És a Nations Cupot';

  @override
  String get campaignSectionOneCycle => 'Egy ciklus';

  @override
  String get campaignSectionShort => 'Néhány ciklus';

  @override
  String get campaignSectionLong => 'Hosszú táv';

  @override
  String get campaignFilterAll => 'Mind';

  @override
  String get campaignFilterNew => 'Nem játszott';

  @override
  String get campaignFilterInProgress => 'Folyamatban';

  @override
  String get campaignFilterDone => 'Teljesített';

  @override
  String get campaignFilterEmpty => 'Itt még nincsenek kampányok.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count csillag',
      zero: 'Nincs csillag',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles ciklus',
      one: '1 ciklus',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' A csúcson, bajnokként búcsúzik.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' A torna lemaradása volt az utolsó csepp a pohárban.';

  @override
  String get msgIntlRetireNoteSurprise => ' Senki sem számított rá.';

  @override
  String get msgIntlRetireNoteRecord =>
      ' A válogatott csúcstartójaként távozik.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name visszavonul a válogatottságtól';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) $age évesen bejelentette visszavonulását a válogatottságtól.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name visszatér a válogatottba';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name $age évesen ismét behívható.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' A sérülésektől megtizedelt keret hívására igent mondott.';

  @override
  String get msgIntlComebackNoteManager =>
      ' Az új szövetségi kapitány meggyőzte.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name visszatér a válogatottba';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) $age évesen ismét behívható.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Visszavonult a válogatottságtól, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Visszatért a válogatottba, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Köszönjük, $name. Van, aki csak viseli a mezt, ő vitte a csapatot.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name befejezi válogatott pályafutását. Egy korszak vége.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name visszavonul. Őszintén szólva egy tornával később a kelleténél.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Szóval $name végzett. Jöjjenek a fiatalok.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Magasság $altitudeString m: az ellenfél hamarabb elfárad';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Magasság $altitudeString m: a játékosaid hamarabb elfáradnak';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Magasság $altitudeString m: mindkét csapat hamarabb elfárad';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Magasság $altitudeString m: mindkét csapat hozzászokott';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Hőség: $tempString °C várható, az erő hamarabb elfogy';
  }

  @override
  String get matchConditionsAdvice =>
      'Tervezd meg korán a cseréket: itt a friss láb többet ér';

  @override
  String get fanMoodFurious => 'dühösek';

  @override
  String get fanMoodRestless => 'nyugtalanok';

  @override
  String get fanMoodCalm => 'nyugodtak';

  @override
  String get fanMoodUpbeat => 'bizakodók';

  @override
  String get fanMoodEuphoric => 'eufórikusak';

  @override
  String matchHomeFans(String mood) {
    return 'Hazai szurkolók: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Szurkolók: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Stadionbevétel a következő ciklusban: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Húsz éve járok a válogatott után itthon és idegenben. Addig nem hosszabbítom meg a bérletemet, amíg valami nem változik.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Továbbra is énekelni fogunk a mezért. De az északi kanyar molinója ma este kimondta, amit mindannyian gondolunk.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Fél stadion üres, a másik fele pedig az egész második félidőben azt skandálta: #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'A szurkolói csoportok a következő hazai meccs bojkottjáról beszélnek. Nehéz hibáztatni őket.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Már nem is vagyok dühös. Egyszerűen elég.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Fotó ma estéről: sorokban üres székek és egy lepedő, rajta: #${manager}Out. Ez a meccsbeszámoló.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Megint telt ház. Évek óta a legjobb válogatott, és ezt az egész ország tudja.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'A következő hazai meccsre tizenegy perc alatt elkeltek a jegyek. Ez a csapat visszaadta a hétvégéinket.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Egyetlen szabad hely sincs a következő hazai meccsre. A szövetség mosolyogva számolja a jegybevételt.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Újabb telt ház. Mondjatok, amit akartok a taktikáról, az emberek ott akarnak lenni a stadionban.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Telt ház, rendben. Ugyanezek az emberek másfél éve még kifütyülték ezt a csapatot.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Hirtelen telt ház, hirtelen mindenki szakértő. Hol voltatok, amikor senkit sem tudtunk megverni?';
  }

  @override
  String get campaignsIntro =>
      'A kampányok kézzel összeállított kihívások: adott válogatott, egy saját fordulattal bíró világ és egy cél, amelyet meghatározott számú ciklus alatt kell elérni. Minden menet külön fut a mentett karrierjeidtől, és minél messzebb jutsz, annál több csillagot kapsz, legfeljebb hármat.';

  @override
  String hubEventScandal(String player) {
    return 'Botrány az edzőtáborban: $player';
  }

  @override
  String get hubEventScandalSub => 'Hazaküldöd, vagy megtartod?';

  @override
  String get scandalTitle => 'BOTRÁNY';

  @override
  String scandalStoryParty(String player) {
    return '$player hajnalig tartó buliban volt, és azon a reggelen, amikor a keret összegyűlt, minden újságban ott voltak a fotók.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player megszegte a takarodót, és hajnalban rajtakapták, ahogy visszaosont a szállodába.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player egy éjszakai klubban bukott le az edzőtábor előestéjén, és a fotók mindenhol ott vannak.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player egy kaszinóasztalnál töltötte az edzőtábor előtti éjszakát, és egy bulvárlapnál ott vannak a fotók.';
  }

  @override
  String get scandalSendHome => 'Hazaküldés';

  @override
  String scandalSendHomeCover(String player) {
    return 'Haza, behívás: $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Marad: $player';
  }

  @override
  String get scandalKeepNote =>
      'Ha marad: morál nagyjából -4 és vezetőség nagyjából -3 a ciklus végéig.';

  @override
  String get scandalSendHomeNote =>
      'Ha hazaküldöd: a morál és a vezetőség nem sínyli meg, és behívhatsz helyette valakit.';

  @override
  String get scandalFinalsNote =>
      'Ha hazaküldöd: a morál és a vezetőség nem sínyli meg, de egy döntős tornán senki sem pótolhatja.';

  @override
  String get scandalPickCover => 'Pótlás behívása (nem kötelező)';

  @override
  String newsScandalTitle(String player) {
    return 'Botrány az edzőtáborban: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Fiatalok, na. $player bulizott az edzőtábor előtti este, de én akkor is a pályán akarom látni. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player egész éjszakás bulin tűnt fel, órákkal a keret összegyűlése előtt. A szövetséget tájékoztatták. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Egész éjszakás buli az edzőtábor előtt. $player, mire gondoltál? Hihetetlen. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Takarodó után ért vissza, előfordul. $player hozza helyre a pályán. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player lebukott, amikor takarodó után tért vissza a csapatszállodába, órákkal az edzés előtt. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'A takarodó nem bonyolult dolog. $player egy éjszakát sem bírt ki. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Szóval $player klubban volt. A focistáknak is van életük. Hadd játsszon. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Fotók mutatják, hogy $player egy éjszakai klubban volt a válogatott edzőtáborának előestéjén. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Klubfotók az edzőtábor előestéjén. $player szégyent hozott a mezre. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Egy éjszaka a kaszinóban nem bűn. $player rendben lesz. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player egy kaszinóasztalnál tűnt fel a keret összegyűlése előtti éjjel. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Egész éjjel kaszinó az edzőtábor előtt. $player többet tett fel, mint pénzt. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Helyes döntés. Senki sem nagyobb a csapatnál, $player sem.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'A hazaküldés volt az egyetlen válasz. $player megkapta, amit kért. Respekt a kapitánynak.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'A fegyelem az fegyelem. $player ismerte a szabályokat.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Világos üzenet a keretnek: $player már a hazafelé tartó gépen ül.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Kemény. $player egyszer elmegy este, és vége neki a tábornak?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'A hazaküldés gyengít minket. $player nélkül a pályán fizetünk meg érte.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Megtartani őt kockázat. $player törlessze a pályán.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Jó, $player marad. Akkor mindenkinek tartozik egy nagy meccsel.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Szóval rá nem vonatkoznak a szabályok. $player kivétel. Jó tudni.';
  }

  @override
  String yScandalKept3(String player) {
    return 'A takarodó mostantól önkéntes, úgy tűnik. Kérdezzétek meg: $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Ezek után marad? $player és a többiek nyaralótáborban vannak.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Egész éjjel buli, aztán egyenesen a kezdőbe. Remek üzenet, mester. $player biztosan boldog.';
  }

  @override
  String get yStreamerBreaks0 =>
      'TESÓT ELKAPTÁK 😭😭 A TÁBOR ELŐTTI ÉJJEL?? SÍROK 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'NEEE CHAT NÉZZÉTEK EZT 🤯🤯 TESÓ TÉNYLEG MEGCSINÁLTA A TÁBOR ELŐTT 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'KI ENGEDTE KI?? KI ENGEDTE KI 😭😭💀 EZ MOZI 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'HAZA?? HAZAAA!!! 😭😭😭 A MESTER NEM VICCEL 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'TESÓ ÉLŐBEN PAKOLJA A BŐRÖNDJÉT 🤯🤯 SZIA TESÓ 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'AZ NEM LEHETTT HAZAKÜLDTÉK 💀💀 CHAT REMEGEK 🔥🔥🔥';

  @override
  String get yStreamerKept0 => 'MARAD??? MARAAAD 🤯🤯 TESÓ ÉRINTHETETLEN 😭🔥';

  @override
  String get yStreamerKept1 =>
      'EGÉSZ ÉJJEL BULI ÉS MÉG MINDIG A KERETBEN 💀💀 KELL NEKEM AZ A SZERZŐDÉS 😭😭';

  @override
  String get yStreamerKept2 =>
      'A MESTER AZT MONDJA MINDEN OKÉ 😭😭 TESÓ MI 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'Semmit sem fizettem, és az az összeg sem stimmel';

  @override
  String get yCameoHavir0 => 'A kis halak elúsztak.';

  @override
  String get yCameoHavir1 => 'Kivetettük a hálót, a halak máshol voltak.';

  @override
  String get yCameoHavir2 =>
      'Már szeptemberben megmondtam, egy gulyás mellett.';

  @override
  String get yCameoHavir3 => 'Aki nem halászott időben, most ne sírjon.';

  @override
  String get yCameoHavir4 => 'Úgy játszottunk, mint a harcsa a szárazon.';

  @override
  String get yCameoHavir5 => 'Fúj a szél, befagy a tó. Így megy ez.';

  @override
  String get yCameoHavir6 => 'Van, hogy csak egy régi csizmát húz ki az ember.';

  @override
  String get yCameoHavir7 =>
      'Az én időmben legalább elmentünk egy sörre. Most már az sem.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Egy fiút hazaküldeni egy este miatt? Ez a botrány, nem a buli!';

  @override
  String get yCameoLzimberskyHome1 =>
      'A fiúk csak szórakozhatnak egy kicsit! A képmutató média megint nyert.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Ez boszorkányüldözés. Egy fiatal egyszer elmegy este, és ti felakasztjátok.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Az az újságíró, aki sosem volt buliban, vesse rá az első követ. Szégyen!';

  @override
  String get yCameoLzimberskyHome4 =>
      'A kapitány megijedt a bulvártól. Én az utolsó leheletemig védtem volna a fiút!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Végre egy kapitány, akinek gerince van! Megtartotta a fiút, a média meg sírhat.';

  @override
  String get yCameoLzimberskyKept1 =>
      'A fiúk csak szórakozhatnak egy kicsit, nem? Bravó, mester!';

  @override
  String get yCameoLzimberskyKept2 =>
      'A képmutató média ordít, a kapitány kitart. Így kell ezt csinálni!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Egy este kint, és a sajtó meg akarja kövezni. A kapitány igazi férfi!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Én azt mondom: hagyjátok élni a fiúkat! Aki keményen dolgozik, az bulizhat is. Fel a hüvelykujjat.';

  @override
  String get yTraitStreamer =>
      'Mindent élőben közvetít, teljes hangerőn, csupa nagybetűvel.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Az év játékosa, $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Megszámolták a szavazatokat';

  @override
  String get potyCeremonyWatch => 'Gála megtekintése';

  @override
  String get potyCeremonySkipToList => 'Ugrás az első ötre';

  @override
  String get potyCeremonySkip => 'Kihagyás';

  @override
  String get potyCeremonyIntro =>
      'Megszámolták a szavazatokat. Íme, az idei év öt legjobb játékosa a világon.';

  @override
  String potyCeremonyPlace(int place) {
    return '$place. hely';
  }

  @override
  String get potyCeremonyWinnerIs => 'Az év játékosa pedig...';

  @override
  String get potyTop5Heading => 'A világ legjobb öt játékosa';

  @override
  String get potyYoungTop3Heading => 'Az év fiatal játékosa: az első három';

  @override
  String get potySeeTop5 => 'Az első öt megtekintése';

  @override
  String get potyYourPlayer => 'A te játékosod';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kapott gól nélküli meccs',
      one: '1 kapott gól nélküli meccs',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Teljes eligazítás';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Eddig megszerzett csillagok: $earned/$total';
  }

  @override
  String get campaignStarEarned => 'Eddig megszerezve';

  @override
  String get campaignStarNotYet => 'Még nincs meg';

  @override
  String get stadiumsEntrySubClosed =>
      'Nézd meg a stadionjaidat. Építkezést a következő ciklus elején rendelhetsz újra.';

  @override
  String get boardObjectiveNoBrief => 'Nincs kitűzött cél';

  @override
  String get boardObjectiveNoBriefBody =>
      'A vezetőség nem várja, hogy kijuss erre a tornára. Ehelyett az eredményeid alapján ítél meg.';

  @override
  String get boardObjectiveAwaitingDraw => 'Cél a sorsolás után';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'A vezetőség a csoportsorsolás után tűzi ki ezt a célt.';
}
