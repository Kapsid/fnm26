// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get matchPreviewTitle => 'NÁHLED ZÁPASU';

  @override
  String get matchKickOff => 'Výkop';

  @override
  String get matchTactics => 'Taktika';

  @override
  String get matchYourXi => 'VAŠE SESTAVA';

  @override
  String get matchHeadToHead => 'VZÁJEMNÉ ZÁPASY';

  @override
  String matchCouldNotLoad(String error) {
    return 'Zápas se nepodařilo načíst.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Žádný nadcházející zápas.';

  @override
  String get matchUnknownNation => 'Neznámý';

  @override
  String get matchH2hFirstMeeting => 'První vzájemný zápas';

  @override
  String get matchH2hYouLead => 'Vedete ve vzájemných zápasech';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Navrch má $opponent';
  }

  @override
  String get matchH2hEven => 'Vyrovnaná bilance';

  @override
  String matchH2hMet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$_temp0';
  }

  @override
  String get matchH2hWon => 'Výhry';

  @override
  String get matchH2hDrawn => 'Remízy';

  @override
  String get matchH2hLost => 'Prohry';

  @override
  String get matchDossierTitle => 'Zpráva skautů';

  @override
  String get matchDossierForm => 'FORMA';

  @override
  String get matchDossierNoGames => 'Žádné nedávné zápasy';

  @override
  String get matchDossierKeyMen => 'KLÍČOVÍ HRÁČI';

  @override
  String get matchDossierHowTheyPlay => 'JAK HRAJÍ';

  @override
  String matchScoutFormation1(String formation) {
    return 'Obvykle nastupují v rozestavení $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Jejich obvyklé rozestavení je $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Nejčastěji volí rozestavení $formation.';
  }

  @override
  String get matchScoutStrengthPressing => 'Napadají vysoko a honí míč.';

  @override
  String get matchScoutStrengthDirect =>
      'Hrají přímočaře a míč posílají brzy dopředu.';

  @override
  String get matchScoutStrengthPossession =>
      'Dobře drží míč a trpělivě kombinují.';

  @override
  String get matchScoutStrengthCounter =>
      'Stahují se a rychle vyrážejí do protiútoků.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Brání hluboko a těžko se přes ně hledá cesta.';

  @override
  String get matchScoutStrengthWide => 'Roztahují hru a útočí po křídlech.';

  @override
  String get matchScoutStrengthAttacking =>
      'Rádi přebírají iniciativu a jdou soupeři po krku.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Jejich útočníci jsou rychlí a rádi nabíhají za obranu.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Jejich záloha dobře kombinuje.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Jejich záloha vydrží běhat celý zápas.';

  @override
  String get matchScoutStrengthSetPieces =>
      'Ze standardních situací jsou nebezpeční.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Jejich obrana je rychlá a těžko se za ni dostává.';

  @override
  String get matchScoutStrengthNone => 'V jejich hře nic zvlášť nevyčnívá.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Jejich vysoká obrana nechává za zády prostor pro dlouhý míč.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Vysoký presink dokáže rozhodit jejich pomalou rozehrávku.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Chce to trpělivost: takhle hluboký blok se dá rozebrat.';

  @override
  String get matchScoutWeakLongBall =>
      'Stáhněte obranu hlouběji a jejich dlouhé míče nebudou mít kam letět.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Jejich obráncům chybí rychlost, posílejte hráče za jejich záda.';

  @override
  String get matchScoutWeakAerial =>
      'Při bránění standardních situací působí nejistě.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Jejich záloha se pod tlakem těžko vymaňuje přihrávkami.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Jejich záloze chybí síly, aby dlouho vydržela napadat.';

  @override
  String get matchScoutWeakBluntAttack => 'Jejich útočníkům chybí rychlost.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Proti vám počítejte s tím, že převezmou iniciativu.';

  @override
  String get matchScoutApproachEven =>
      'Proti vám počítejte s vyrovnaným a těsným zápasem.';

  @override
  String get matchScoutApproachSitDeep =>
      'Proti vám počítejte s opatrnou hrou a čekáním na brejk.';

  @override
  String get matchScoutLeaningAttacking =>
      'Zdálky působí jako útočně laděný tým.';

  @override
  String get matchScoutLeaningCautious => 'Zdálky působí jako opatrný tým.';

  @override
  String get matchScoutLeaningUnclear =>
      'Zdálky se těžko odhaduje, jak rádi hrají.';

  @override
  String get matchScoutHireHint =>
      'Najměte hlavního skauta a zjistíte, jak hrají.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Nelze pokračovat: $error';
  }

  @override
  String get matchSkipToFullTime => 'Přeskočit do konce';

  @override
  String get matchStatShots => 'Střely';

  @override
  String get matchStatGoals => 'Góly';

  @override
  String get matchStatYellowCards => 'Žluté';

  @override
  String get matchStatRedCards => 'Červené';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'ÚT';

  @override
  String get matchSwingDef => 'OBR';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'MISTROVSTVÍ SVĚTA $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'FINÁLOVÝ TURNAJ ZAČÍNÁ';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'POŘÁDÁ  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'POŘADATEL BUDE POTVRZEN';

  @override
  String get matchHalfTime => 'POLOČAS';

  @override
  String matchHalfTimeScore(int home, int away) {
    return 'Poločas $home : $away';
  }

  @override
  String get matchContinue => 'Pokračovat';

  @override
  String get matchContinuing => 'Ukládám…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktika · $used/$max střídání';
  }

  @override
  String matchTiredCount(int count) {
    return 'ÚNAVA ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIKA';

  @override
  String get teamOverallOverTime => 'VÝVOJ HODNOCENÍ TÝMU';

  @override
  String get teamOverall => 'Celkově';

  @override
  String get teamTalkHeading => 'PORADA TÝMU';

  @override
  String get teamTalkPrompt => 'Nastavte tón pro druhý poločas.';

  @override
  String get teamTalkCalmLabel => 'Chladné hlavy';

  @override
  String get teamTalkCalmBlurb => 'Uklidněte tým. Mírné celkové zlepšení.';

  @override
  String get teamTalkEncourageLabel => 'Povzbuzení';

  @override
  String get teamTalkEncourageBlurb => 'Zatlačte dopředu a jděte si pro zápas.';

  @override
  String get teamTalkDemandMoreLabel => 'Žádejte víc';

  @override
  String get teamTalkDemandMoreBlurb => 'Vsaďte vše na útok. Zaútočte naplno.';

  @override
  String get teamTalkPraiseLabel => 'Držte to vzadu';

  @override
  String get teamTalkPraiseBlurb => 'Zůstaňte kompaktní a udržte si náskok.';

  @override
  String get teamTalkBelieveLabel => 'Věřte si';

  @override
  String get teamTalkBelieveBlurb =>
      'Věřte si. Zlepšení na obou koncích hřiště.';

  @override
  String get teamTalkFocusLabel => 'Zůstaňte koncentrovaní';

  @override
  String get teamTalkFocusBlurb => 'Naprostá koncentrace. Zamkněte zápas.';

  @override
  String get teamTalkUrgencyLabel => 'Pocit naléhavosti';

  @override
  String get teamTalkUrgencyBlurb =>
      'Hned to dožeňte. Vše dopředu, otevřete obranu.';

  @override
  String get teamTalkReassureLabel => 'Žádný tlak';

  @override
  String get teamTalkReassureBlurb => 'Uklidněte nervy a držte rozestavení.';

  @override
  String get commonRetry => 'Zkusit znovu';

  @override
  String get commonSomethingWentWrong => 'Něco se pokazilo';

  @override
  String get commonCrashBox =>
      'Tady se něco pokazilo.\nPodrobnosti najdete v Nastavení → Diagnostika.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Svět se nepodařilo posunout: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostika';

  @override
  String get settingsDiagnosticsBlurb =>
      'Chyby zaznamenané v tomto zařízení. Nikam se neodesílají.';

  @override
  String get settingsContactTitle => 'Kontakt';

  @override
  String get settingsContactCopied => 'Adresa zkopírována.';

  @override
  String get settingsCommunityTitle => 'Komunita';

  @override
  String get settingsDiscordSubtitle => 'Připojte se ke komunitě';

  @override
  String get settingsLinkCopied => 'Odkaz zkopírován.';

  @override
  String get diagnosticsEmpty => 'Žádné chyby. Přesně tak to má být.';

  @override
  String get diagnosticsCopy => 'Kopírovat';

  @override
  String get diagnosticsCopied => 'Záznam zkopírován do schránky.';

  @override
  String get diagnosticsClear => 'Vymazat';

  @override
  String get navHub => 'Rozcestník';

  @override
  String get navSquad => 'Tým';

  @override
  String get navStandings => 'Tabulky';

  @override
  String get navCareers => 'Kariéra';

  @override
  String get settingsTitle => 'NASTAVENÍ';

  @override
  String get settingsSoundHapticsTitle => 'Zvuk a vibrace';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibrace a krátký tón při gólech, výkopu a konci zápasu.';

  @override
  String get settingsLanguageTitle => 'Jazyk';

  @override
  String get settingsLanguageBlurb =>
      'Vyberte jazyk aplikace, nebo použijte jazyk zařízení.';

  @override
  String get settingsLanguageSystem => 'Systém';

  @override
  String get settingsTextSizeTitle => 'Velikost textu';

  @override
  String get settingsTextSizeBlurb => 'Zvětšete text, pokud se špatně čte.';

  @override
  String get settingsTextSizeNormal => 'Normální';

  @override
  String get settingsTextSizeLarge => 'Velký';

  @override
  String get settingsTextSizeLarger => 'Větší';

  @override
  String get matchPreviewAllMeetings => 'Všechna utkání';

  @override
  String get recordsMeetings => 'ZÁPASY';

  @override
  String get recordsLegends => 'LEGENDY';

  @override
  String get recordsAllTimeXi => 'JEDENÁCTKA HISTORIE';

  @override
  String get recordsHallOfFame => 'SÍŇ SLÁVY';

  @override
  String get recordsAllTimeWorld => 'SVĚTOVÉ REKORDY';

  @override
  String get recordsAllTimeTopScorers => 'NEJLEPŠÍ STŘELCI HISTORIE';

  @override
  String get recordsMostCapped => 'NEJVÍCE STARTŮ';

  @override
  String get recordsMostWcStarts => 'NEJVÍCE STARTŮ NA MS';

  @override
  String get recordsMostTournaments => 'NEJVÍCE ODEHRANÝCH TURNAJŮ';

  @override
  String get recordsRecordBook => 'KNIHA REKORDŮ';

  @override
  String get recordsHeadToHead => 'VZÁJEMNÉ ZÁPASY';

  @override
  String get recordsFiercestRival => 'NEJVĚTŠÍ RIVAL';

  @override
  String get recordsMostCaps => 'NEJVÍCE STARTŮ';

  @override
  String get recordsTopScorers => 'NEJLEPŠÍ STŘELCI';

  @override
  String get recordsMostAssists => 'NEJVÍCE ASISTENCÍ';

  @override
  String get recordsYourRecord => 'VAŠE BILANCE';

  @override
  String get callUpHome => 'DOMA';

  @override
  String get callUpAway => 'VENKU';

  @override
  String get recordsHome => 'DOMA';

  @override
  String get recordsAway => 'VENKU';

  @override
  String get recordsActive => 'AKTIVNÍ';

  @override
  String get recordsStillActive => 'Stále aktivní';

  @override
  String get recordsAvg => 'prům.';

  @override
  String get recordsSelect => 'Vybrat';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Remízy';

  @override
  String get recordsGoalsLabel => 'Góly';

  @override
  String get recordsBestFinish => 'Nejlepší umístění';

  @override
  String get recordsNoFinalsYet => 'Zatím žádná účast na závěrečném turnaji';

  @override
  String get recordsLongestUnbeaten => 'Nejdelší neporazitelnost';

  @override
  String get recordsBiggestWin => 'Nejvyšší výhra';

  @override
  String get recordsSeeAllMeetings => 'Zobrazit všechny zápasy';

  @override
  String get recordsSaveNotFound => 'Uložená hra nenalezena.';

  @override
  String get recordsNoMatches => 'Žádné výsledky.';

  @override
  String get recordsSearchPlayerOrNation => 'Hledat hráče nebo zemi';

  @override
  String get recordsSearchNation => 'Hledat zemi';

  @override
  String get recordsPickTwoDifferent => 'Vyberte dvě různé země.';

  @override
  String get recordsPlayToBuildRecord =>
      'Odehrajte nějaké zápasy a vaše bilance proti jednotlivým soupeřům se zde postupně objeví.';

  @override
  String get recordsTapOpponent => 'Klepněte na soupeře pro úplný přehled.';

  @override
  String get recordsEdgeUpperHand => 'Máte navrch';

  @override
  String get recordsEdgeTheirNumber => 'Mají nad vámi navrch';

  @override
  String get recordsEdgeEven => 'Vyrovnaná bilance';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Světoví střelci a nejvíce startů, všechny země';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Porovnejte historickou bilanci dvou zemí';

  @override
  String get recordsLegendsSubtitle => 'Jedenáctka historie a síň slávy';

  @override
  String get recordsUnitGoals => 'gólů';

  @override
  String get recordsUnitCaps => 'startů';

  @override
  String get recordsUnitStarts => 'startů';

  @override
  String get recordsUnitCups => 'turnajů';

  @override
  String get recordsUnitAssists => 'asistencí';

  @override
  String recordsCapsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count startů',
      few: '$count starty',
      one: '1 start',
    );
    return '$_temp0';
  }

  @override
  String recordsGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gólů',
      few: '$count góly',
      one: '1 gól',
    );
    return '$_temp0';
  }

  @override
  String recordsAssistsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count asistencí',
      few: '$count asistence',
      one: '1 asistence',
    );
    return '$_temp0';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MOTM';
  }

  @override
  String recordsMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$_temp0';
  }

  @override
  String recordsMeetingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$_temp0';
  }

  @override
  String recordsCodeWins(String code) {
    return 'výhry $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings zápasů',
      few: '$meetings zápasy',
      one: '1 zápas',
    );
    return '$_temp0 · ${wins}V ${draws}R ${losses}P';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}V ${draws}R ${losses}P';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings zápasů',
      few: '$meetings zápasy',
      one: '1 zápas',
    );
    return '$_temp0 · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a a $b se v této hře nikdy nepotkali.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names vyloučen. Bez náhrady, hrajete v oslabení.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Potřeba $required k dispozici ($have fit)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Chybí $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Chybí v celé této nominaci';

  @override
  String get rankingCentreOnMe => 'Vycentrovat na můj tým';

  @override
  String get recordsAfterExtraTime => 'po prodl.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b na pen.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played odehráno · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga s $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Nepodařilo se načíst.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Nepodařilo se načíst legendy.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Nepodařilo se načíst rekordy.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Nepodařilo se načíst země.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Nepodařilo se načíst vaši bilanci.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Nepodařilo se načíst bilanci.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Zatím žádné legendy. Odehrajte několik kampaní a objeví se zde velikáni týmu $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Nejlepší sestava, jakou kdy $nation mohl postavit.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Svět zatím nemá žádnou historii. Odehrajte několik kampaní a objeví se zde největší legendy.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Odehrajte nějaké zápasy a začněte psát historii týmu $nation.';
  }

  @override
  String get tacticsLineGk => 'BR';

  @override
  String get tacticsLineDef => 'OBR';

  @override
  String get tacticsLineMid => 'ZÁL';

  @override
  String get tacticsLineFwd => 'ÚT';

  @override
  String get tacticsGoalkeepers => 'BRANKÁŘI';

  @override
  String get tacticsDefenders => 'OBRÁNCI';

  @override
  String get tacticsMidfielders => 'ZÁLOŽNÍCI';

  @override
  String get tacticsForwards => 'ÚTOČNÍCI';

  @override
  String get tacticsCallUpsTitle => 'NOMINACE';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    String _temp0 = intl.Intl.pluralLogic(
      min,
      locale: localeName,
      other: '$min hráčů',
      few: '$min hráče',
      one: '1 hráče',
    );
    return 'Vyberte alespoň $_temp0.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Nepodařilo se načíst kádr.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Žádný kádr.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'KÁDR · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Max $max';
  }

  @override
  String get tacticsBestQuality => 'Nejlepší kvalita';

  @override
  String get tacticsPreviousSquad => 'Předchozí kádr';

  @override
  String get tacticsSquadLockedBack => 'Zpět (kádr uzamčen)';

  @override
  String get tacticsConfirmSquad => 'Potvrdit kádr';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Kádr je plný (max $max)';
  }

  @override
  String get tacticsSquadLocked => 'KÁDR UZAMČEN';

  @override
  String get tacticsNominationOpen => 'NOMINACE OTEVŘENA. VYBERTE KÁDR';

  @override
  String get tacticsSquadFixedBlurb =>
      'Tento kádr je pevně daný pro zápasy níže. Znovu jej vyberte před dalším nominačním oknem.';

  @override
  String get tacticsSquadWillPlayBlurb => 'Tento kádr odehraje zápasy níže.';

  @override
  String get tacticsUnknown => 'Neznámý';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Věk $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Vyčerpaný';

  @override
  String get tacticsFatigueTired => 'Unavený';

  @override
  String get tacticsFatigueMatchLegs => 'Rozehraný';

  @override
  String tacticsTooManySubs(int max) {
    return 'Příliš mnoho střídání (max $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIKA · $minute\'';
  }

  @override
  String get tacticsApply => 'POUŽÍT';

  @override
  String get tacticsTabLineupSubs => 'SESTAVA A STŘÍDÁNÍ';

  @override
  String get tacticsTabTactics => 'TAKTIKA';

  @override
  String get squadLineKeepers => 'BRANKÁŘI';

  @override
  String get squadLineDefenders => 'OBRANA';

  @override
  String get squadLineMidfielders => 'ZÁLOHA';

  @override
  String get squadLineForwards => 'ÚTOK';

  @override
  String get squadStatXiRating => 'Hodnocení XI';

  @override
  String get squadStatAvgAge => 'Prům. věk';

  @override
  String get squadStatSize => 'Kádr';

  @override
  String get squadStatUnavailable => 'Mimo hru';

  @override
  String get squadDepthTitle => 'ŠÍŘE KÁDRU PO ŘADÁCH';

  @override
  String squadAgeShort(int age) {
    return '$age let';
  }

  @override
  String get tacticsTabOtherPositions => 'JINÉ POSTY';

  @override
  String get tacticsOutOfPositionNote => 'Mimo svou pozici';

  @override
  String get tacticsNobodyElse => 'Nikdo další, koho tu zkusit.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Vyberte, kdo jde dolů, a objeví se tu zbytek lavičky i s ratingem, na kterém by tuhle pozici hráli.';

  @override
  String get tacticsTabSuitable => 'VHODNÍ';

  @override
  String get tacticsTabOnPitch => 'NA HŘIŠTI';

  @override
  String tacticsSectionSuitable(int count) {
    return 'VHODNÍ · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Na tuto pozici se přirozeně nehodí nikdo z lavičky, takže jsou tu všichni.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'NA HŘIŠTI · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'K DISPOZICI · $count';
  }

  @override
  String get tacticsRowStarted => 'Od začátku';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Na hřišti od $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Střídal';

  @override
  String get tacticsEnergyLabel => 'KONDICE';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Klepněte na náhradu za hráče $name, nebo volbu zrušte dalším klepnutím na něj.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Za červenou kartu jste přišli o toto místo. Přetáhněte sem spoluhráče a mezera se přesune.';

  @override
  String get tacticsSentOffShort => 'VYLOUČEN';

  @override
  String get tacticsFullBackLeft => 'Levý obránce';

  @override
  String get tacticsFullBackRight => 'Pravý obránce';

  @override
  String get tacticsFullBackUp => 'Podporovat útok';

  @override
  String get tacticsFullBackDown => 'Držet pozici';

  @override
  String get tacticsFullBackOff => 'Bez pokynu';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: podporovat útok. O něco víc útoku, o něco víc rizika.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: držet pozici. O něco bezpečnější, o něco méně útoku.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: bez pokynu, hraje podle týmového plánu.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, šipka: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'STŘÍDÁNÍ · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Klepnutím na hráče na hřišti ho pošlete ven, nebo podržte náhradníka a přetáhněte ho na něj.';

  @override
  String get tacticsNoSubs => 'Žádní náhradníci k dispozici.';

  @override
  String get tacticsChooseShape => 'VYBERTE ROZESTAVENÍ';

  @override
  String get tacticsFormation => 'ROZESTAVENÍ';

  @override
  String get tacticsInstructions => 'POKYNY';

  @override
  String get tacticsDrilling => 'SEHRANOST';

  @override
  String get tacticsDrillingUnplayed => 'NEHRANÉ';

  @override
  String get tacticsDrillingNew => 'NOVÉ';

  @override
  String get tacticsDrillingSettling => 'SEHRÁVÁ SE';

  @override
  String get tacticsDrillingDrilled => 'SEHRANÉ';

  @override
  String get tacticsInstrMentality => 'Mentalita';

  @override
  String get tacticsInstrDefensive => 'Defenzivní';

  @override
  String get tacticsInstrAttacking => 'Ofenzivní';

  @override
  String get tacticsInstrPressing => 'Presink';

  @override
  String get tacticsInstrLowBlock => 'Nízký blok';

  @override
  String get tacticsInstrHighPress => 'Vysoký presink';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Trpělivé';

  @override
  String get tacticsInstrFast => 'Rychlé';

  @override
  String get tacticsInstrWidth => 'Šířka';

  @override
  String get tacticsInstrNarrow => 'Úzká';

  @override
  String get tacticsInstrWide => 'Široká';

  @override
  String get tacticsInstrDefLine => 'Obr. linie';

  @override
  String get tacticsInstrDefensiveLine => 'Obranná linie';

  @override
  String get tacticsInstrDeep => 'Hluboká';

  @override
  String get tacticsInstrHigh => 'Vysoká';

  @override
  String get tacticsInstrDirectness => 'Přímočarost';

  @override
  String get tacticsInstrPossession => 'Držení míče';

  @override
  String get tacticsInstrDirect => 'Přímá hra';

  @override
  String get tacticsPickGoalkeeper => 'VYBERTE BRANKÁŘE';

  @override
  String get tacticsPickLeftBack => 'VYBERTE LEVÉHO OBRÁNCE';

  @override
  String get tacticsPickCentreBack => 'VYBERTE STŘEDNÍHO OBRÁNCE';

  @override
  String get tacticsPickRightBack => 'VYBERTE PRAVÉHO OBRÁNCE';

  @override
  String get tacticsPickDefensiveMid => 'VYBERTE DEFENZIVNÍHO ZÁLOŽNÍKA';

  @override
  String get tacticsPickCentralMid => 'VYBERTE STŘEDNÍHO ZÁLOŽNÍKA';

  @override
  String get tacticsPickAttackingMid => 'VYBERTE OFENZIVNÍHO ZÁLOŽNÍKA';

  @override
  String get tacticsPickLeftMid => 'VYBERTE LEVÉHO ZÁLOŽNÍKA';

  @override
  String get tacticsPickRightMid => 'VYBERTE PRAVÉHO ZÁLOŽNÍKA';

  @override
  String get tacticsPickLeftWing => 'VYBERTE LEVÉ KŘÍDLO';

  @override
  String get tacticsPickRightWing => 'VYBERTE PRAVÉ KŘÍDLO';

  @override
  String get tacticsPickStriker => 'VYBERTE ÚTOČNÍKA';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · mimo pozici';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Věk $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Věk $age';
  }

  @override
  String get tacticsOn => 'HRAJE';

  @override
  String get tacticsSquad => 'KÁDR';

  @override
  String get tacticsTabLineup => 'SESTAVA';

  @override
  String get tacticsTabInstructions => 'POKYNY';

  @override
  String get tacticsTabRoles => 'ROLE';

  @override
  String get tacticsTabSetPieces => 'STANDARDNÍ SITUACE';

  @override
  String get tacticsTabRolesSetPieces => 'ROLE A STANDARDKY';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Přiřaďte každému hráči roli. Klepnutím na odznak penalty (⚽) nebo přímého kopu (▲) určete vykonavatele.';

  @override
  String get tacticsTooltipCallUps => 'Nominace';

  @override
  String get tacticsTooltipPresets => 'Uložené taktiky';

  @override
  String get tacticsTooltipInstructions => 'Pokyny';

  @override
  String get tacticsNoTacticSet => 'Žádná taktika není nastavena.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'NAHRAĎTE $count HRÁČŮ V SESTAVĚ',
      many: 'NAHRAĎTE $count HRÁČE V SESTAVĚ',
      few: 'NAHRAĎTE $count HRÁČE V SESTAVĚ',
      one: 'NAHRAĎTE $count HRÁČE V SESTAVĚ',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Nehraje';

  @override
  String get tacticsTapSpotReplace =>
      'Klepněte na jeho místo na hřišti a vyberte náhradu.';

  @override
  String get tacticsTapOrDrag =>
      'Klepnutím hráče vyměníte, podržením a tažením ho přesunete.';

  @override
  String get tacticsPlayerRoles => 'ROLE HRÁČŮ';

  @override
  String get tacticsRolesBlurb =>
      'Dejte hráči úkol: lovec gólů, rozehrávač, cílový hrot. Ovlivňuje, kdo střílí a kdo tvoří.';

  @override
  String get tacticsSetPieceTakers => 'EXEKUTOŘI STANDARDEK';

  @override
  String get tacticsSetPieceBlurb =>
      'Kdo kope penalty a standardky, nebo to nechte na nejvhodnějším hráči.';

  @override
  String get tacticsTakerAuto => 'Automaticky';

  @override
  String get tacticsTakerQuickPick => 'Vybrat nejlepší';

  @override
  String get tacticsPenalties => 'Penalty';

  @override
  String get tacticsCornersFreeKicks => 'Rohy a volné kopy';

  @override
  String get tacticsThrowIns => 'Auty';

  @override
  String get tacticsThrowInStyle => 'Styl autů';

  @override
  String get tacticsThrowInLong => 'Dlouhé auty';

  @override
  String get tacticsThrowInNeutral => 'Neutrální';

  @override
  String get tacticsThrowInDefensive => 'Bezpečné auty';

  @override
  String get tacticsThrowInLongBlurb =>
      'Auty blízko vápna letí do vápna. O něco víc nebezpečí, hlavně se silným exekutorem a vysokými útočníky, ale o míč přijdete o něco častěji.';

  @override
  String get tacticsThrowInNeutralBlurb => 'Auty podle situace. Nic se nemění.';

  @override
  String get tacticsThrowInDefensiveBlurb =>
      'Každý aut krátce a bezpečně. Méně ztrát, ze kterých soupeř brejkuje, a o něco méně šancí.';

  @override
  String get matchGoalLongThrow => 'DLOUHÝ AUT';

  @override
  String get tacticsSkillFin => 'ZAK';

  @override
  String get tacticsSkillPas => 'PŘI';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROLE · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'EXEKUTOR PENALT';

  @override
  String get tacticsCornerFreeKickTaker => 'EXEKUTOR ROHŮ A VOLNÝCH KOPŮ';

  @override
  String get tacticsAutomatic => 'Automaticky';

  @override
  String get tacticsLetBestSuited => 'Nechte to na nejvhodnějším hráči.';

  @override
  String get tacticsInXi => 'V SESTAVĚ';

  @override
  String get tacticsTeamInstructions => 'TÝMOVÉ POKYNY';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Nastavte, jak váš tým hraje. Každý posuvník ovlivní celý tým.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Uloženo „$name“';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Použito „$name“';
  }

  @override
  String get tacticsTacticPresets => 'ULOŽENÉ TAKTIKY';

  @override
  String get tacticsPresetsBlurb =>
      'Uložte toto rozestavení jako znovupoužitelný styl, nebo použijte dříve uložený.';

  @override
  String get tacticsSaveCurrentTactic => 'Uložit aktuální taktiku';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Nepodařilo se načíst uložené taktiky.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Zatím žádné uložené taktiky. Klepnutím na „Uložit aktuální taktiku“ uložíte toto nastavení jako znovupoužitelný styl.';

  @override
  String get tacticsNameThisTactic => 'Pojmenujte taktiku';

  @override
  String get tacticsNameHint => 'např. Vysoký presink 4-3-3';

  @override
  String get tacticsCancel => 'Zrušit';

  @override
  String get tacticsSave => 'Uložit';

  @override
  String get tacticsTapToAssign => 'Klepnutím přiřadit';

  @override
  String get tacticsHoldDragSub =>
      'Podržte náhradníka a přetáhněte ho na hráče, kterého chcete vystřídat.';

  @override
  String get hubContinue => 'Pokračovat';

  @override
  String get hubBrackets => 'Pavouk';

  @override
  String hubCouldNotLoad(String error) {
    return 'Nepodařilo se načíst.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Nepodařilo se načíst finance.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Nepodařilo se načíst uloženou hru.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Uložená hra nenalezena.';

  @override
  String get hubUnknown => 'Neznámý';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year MISTŘI SVĚTA';
  }

  @override
  String get hubCycleComplete => 'Cyklus je u konce.';

  @override
  String get hubYourJob => 'VAŠE MÍSTO';

  @override
  String get hubStayProject => 'Zůstaňte a pokračujte ve svém projektu';

  @override
  String get hubChooseNextJob => 'VYBERTE SI DALŠÍ ANGAŽMÁ';

  @override
  String get hubOffersOnTable => 'NABÍDKY NA STOLE';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · #$position na světě';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Pokračovat s $nation';
  }

  @override
  String get hubYourNation => 'vaším národem';

  @override
  String get hubTakeTheJob => 'Přijmout nabídku';

  @override
  String get hubFederationFinances => 'FINANCE SVAZU';

  @override
  String get hubBudgetIntro =>
      'Vaším prvním úkolem v příštím cyklu bude sestavit rozpočet svazu a rozdělit ho mezi jednotlivé úseky.';

  @override
  String get hubStarting => 'Spouštění…';

  @override
  String get hubBeginNextCycle => 'Zahájit další cyklus';

  @override
  String get hubContinueCareer => 'Pokračovat v kariéře';

  @override
  String get hubBackToSaves => 'Zpět na uložené hry';

  @override
  String get hubOpeningBalance => 'Počáteční zůstatek';

  @override
  String get hubCentralFunding => 'Centrální dotace';

  @override
  String get hubPrizeMoney => 'Prémie';

  @override
  String get hubCommercialReturn => 'Komerční příjmy';

  @override
  String get hubAvailableToInvest => 'K dispozici k investování';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputace: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Národní hrdina';

  @override
  String get hubFinal => 'Finále';

  @override
  String get hubStageRoundOf32 => 'Šestnáctifinále';

  @override
  String get hubStageThirdPlace => 'O 3. místo';

  @override
  String get hubEventAdvanceWorld => 'Posunout svět dál';

  @override
  String hubEventStartCycle(int year) {
    return 'Zahájit cyklus $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation jsou mistři světa';
  }

  @override
  String get hubEventSetBudget => 'Nastavte rozpočet federace';

  @override
  String get hubEventSetBudgetSub =>
      'Rozdělte prostředky tohoto cyklu před začátkem sezóny';

  @override
  String get hubEventNaturalization => 'Posoudit nabídku naturalizace';

  @override
  String get hubEventNaturalizationSub =>
      'Zahraniční hráč chce přejít do vaší reprezentace';

  @override
  String get hubEventCampaignVerdict =>
      'Kampaň je rozhodnuta: podívejte se na verdikt';

  @override
  String get hubEventCampaignComplete => 'Kampaň dokončena';

  @override
  String get hubEventIntercontinentalPlayoff => 'Mezikontinentální baráž';

  @override
  String get hubEventWatchWcDraw => 'Sledovat los mistrovství světa';

  @override
  String get hubEventWorldCupHere => 'Mistrovství světa je tady';

  @override
  String get hubEventWatchFinalsDraw => 'Sledovat los závěrečného turnaje';

  @override
  String get hubEventFinalsHere => 'Závěrečný turnaj je tady';

  @override
  String get hubEventPlayWcRound => 'Odehrát další kolo MS';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Odehrát další zápas: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch => 'Odehrát další zápas Poháru národů';

  @override
  String get hubEventWatchNationsCupDraw => 'Sledovat los Poháru národů';

  @override
  String get hubEventWatchHostSelection => 'Sledovat volbu pořadatele';

  @override
  String get hubEventWatchQualifyingDraw => 'Sledovat kvalifikační los';

  @override
  String get hubEventWatchWcHostSelection => 'Sledovat volbu pořadatele MS';

  @override
  String get hubEventWatchWcQualifyingDraw => 'Sledovat kvalifikační los MS';

  @override
  String get hubEventArrangeFriendlies => 'Domluvit přátelské zápasy';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Zatím jste nevyužili svých $count volných oken pro přátelské zápasy',
      few: 'Zatím jste nevyužili svá $count volná okna pro přátelské zápasy',
      one: 'Zatím jste nevyužili své volné okno pro přátelský zápas',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Upravte základní sestavu';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count hráčů základní sestavy chybí (trest nebo zranění). Vyberte náhrady',
      few:
          '$count hráči základní sestavy chybí (trest nebo zranění). Vyberte náhrady',
      one:
          '1 hráč základní sestavy chybí (trest nebo zranění). Vyberte náhradu',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Základní sestava není kompletní. Obsaďte volná místa',
      one: 'Základní sestava není kompletní. Obsaďte volné místo',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Hrát proti $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'kontinentální šampionát';

  @override
  String get hubCallUpFriendlies => 'Nominujte tým na přátelské zápasy';

  @override
  String get hubCallUpRequalify => 'Znovu nominujte kvalifikační tým';

  @override
  String get hubCallUpWorldCup => 'Nominujte tým na MS';

  @override
  String get hubCallUpFinals => 'Nominujte tým na závěrečný turnaj';

  @override
  String get hubCallUpNationsCup => 'Nominujte tým na Pohár národů';

  @override
  String get hubCallUpQualifying => 'Nominujte kvalifikační tým';

  @override
  String get hubCallUpGeneric => 'Nominujte tým';

  @override
  String get hubHost => 'Pořadatel';

  @override
  String get hubGoldenBoot => 'Zlatá kopačka';

  @override
  String hubGoldenBootValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals gólů',
      few: '$goals góly',
      one: '1 gól',
    );
    return '$name · $_temp0';
  }

  @override
  String get hubPens => '(pen.)';

  @override
  String get hubNationalHub => 'NÁRODNÍ CENTRÁLA';

  @override
  String get hubMessages => 'Zprávy';

  @override
  String get hubWorldChampions => 'MISTŘI SVĚTA';

  @override
  String get hubViewBracket => 'Zobrazit pavouka ›';

  @override
  String get hubBoardDelighted => 'Nadšené';

  @override
  String get hubBoardPleased => 'Spokojené';

  @override
  String get hubBoardExpectingMore => 'Očekává víc';

  @override
  String get hubBoardConcerned => 'Znepokojené';

  @override
  String get hubBoardJobAtRisk => 'Místo v ohrožení';

  @override
  String get hubBoard => 'VEDENÍ';

  @override
  String hubBoardObjective(String label) {
    return 'Cíl vedení: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'SPLNĚNO · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'NESPLNĚNO · $result';
  }

  @override
  String get hubNoMoreFixtures => 'V tomto cyklu už nejsou žádné zápasy.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Světový žebříček';

  @override
  String get hubSquadStatus => 'STAV KÁDRU';

  @override
  String hubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hráčů',
      few: '$count hráči',
      one: '1 hráč',
    );
    return '$_temp0';
  }

  @override
  String get hubAvgRating => 'Prům. hodnocení';

  @override
  String get hubMorale => 'Morálka';

  @override
  String get hubManageTeam => 'Spravovat tým';

  @override
  String get hubGroupsToBeDrawn =>
      'Skupiny budou vylosovány. Sledujte losování a odhalte je.';

  @override
  String hubGroupName(String name) {
    return 'SKUPINA $name';
  }

  @override
  String get hubTblTeam => 'TÝM';

  @override
  String get hubTblP => 'Z';

  @override
  String get hubTblGd => 'GD';

  @override
  String get hubTblPts => 'B';

  @override
  String get homeSettings => 'Nastavení';

  @override
  String get homeLeadTheNation => 'VEĎTE NÁROD';

  @override
  String get homeYourNation => 'váš národ';

  @override
  String get homeNewGame => 'Nová hra';

  @override
  String get homeAllSaves => 'Všechny uložené hry';

  @override
  String get homeLoadGame => 'Načíst hru';

  @override
  String get homeContinue => 'POKRAČOVAT';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Cesta na MS $year';
  }

  @override
  String get careerManageSaves => 'Spravovat uložení';

  @override
  String get careerNewGameTitle => 'NOVÁ HRA';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Reprezentaci se nepodařilo načíst.\n$error';
  }

  @override
  String get careerNationNotFound => 'Reprezentace nenalezena.';

  @override
  String careerWorldRankNum(int rank) {
    return 'SVĚTOVÉ POŘADÍ #$rank';
  }

  @override
  String get careerManagerName => 'Jméno trenéra';

  @override
  String get careerManagerNameHint => 'např. Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Vaše kariéra začíná v září 2026, na cestě na mistrovství světa 2030.';

  @override
  String get careerFreeCycleNote =>
      'Zdarma na jeden celý čtyřletý cyklus: kvalifikace, váš kontinentální šampionát i mistrovství světa, na dvou uložených hrách. Potom jedna platba odemkne nekonečné cykly.';

  @override
  String get careerStartCareer => 'Začít kariéru';

  @override
  String get careersTitle => 'KARIÉRY';

  @override
  String get careerManagerCareer => 'Trenérská kariéra';

  @override
  String get careerManagerCareerSubtitle =>
      'Přehled všech vašich cyklů a celková bilance';

  @override
  String get careerSummaryTitle => 'Přehled kariéry';

  @override
  String get careerSummarySubtitle => 'Vaše sbírka trofejí a trenérská bilance';

  @override
  String get careerAchievements => 'Úspěchy';

  @override
  String get careerAchievementsSubtitle =>
      'Milníky, tituly a spokojenost vedení';

  @override
  String get careerChallenges => 'Výzvy';

  @override
  String get careerChallengesSubtitle => 'Nelítostné zkoušky na celou kariéru';

  @override
  String get careerTeamRecords => 'Týmové rekordy';

  @override
  String get careerTeamRecordsSubtitle =>
      'Historicky nejlepší střelci a počty startů';

  @override
  String get careerMyMatches => 'Moje zápasy';

  @override
  String get careerMyMatchesSubtitle =>
      'Všechny výsledky a nadcházející zápasy';

  @override
  String get careerTitle => 'KARIÉRA';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Kariéru se nepodařilo načíst.\n$error';
  }

  @override
  String get careerNoCareer => 'Žádná kariéra.';

  @override
  String get careerTrophyCabinet => 'SBÍRKA TROFEJÍ';

  @override
  String get careerTournamentHistory => 'HISTORIE TURNAJŮ';

  @override
  String get careerNoTournamentsYet => 'Zatím žádné dokončené turnaje.';

  @override
  String get careerTeamFallback => 'Tým';

  @override
  String careerWorldNum(int rank) {
    return 'SVĚT #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points B';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SEZÓNA $season';
  }

  @override
  String get careerStatPlayedShort => 'Z';

  @override
  String get careerStatsHeading => 'V ČÍSLECH';

  @override
  String get careerStatsWinRate => 'Úspěšnost';

  @override
  String get careerStatsGoalsFor => 'Vstřelené góly';

  @override
  String get careerStatsGoalsAgainst => 'Obdržené góly';

  @override
  String get careerStatsGoalDiff => 'Rozdíl skóre';

  @override
  String get careerStatsCleanSheets => 'Čistá konta';

  @override
  String get careerStatsBiggestWin => 'Nejvyšší výhra';

  @override
  String get careerStatsWinStreak => 'Série výher';

  @override
  String get careerStatsUnbeaten => 'Neprohraná série';

  @override
  String get careerStatsShootouts => 'Penaltové rozstřely';

  @override
  String get careerStatsHatTricks => 'Hattricky';

  @override
  String get careerStatsMotms => 'Muž zápasu';

  @override
  String get careerStatsBestRating => 'Nejlepší známka';

  @override
  String get careerStatWonShort => 'V';

  @override
  String get careerStatDrawnShort => 'R';

  @override
  String get careerStatLostShort => 'P';

  @override
  String get careerStatGoalsForShort => 'VG';

  @override
  String get careerStatGoalsAgainstShort => 'OG';

  @override
  String get careerStatGoalDiffShort => 'RS';

  @override
  String get careerNoSilverware => 'Zatím žádné trofeje. Běžte nějakou získat.';

  @override
  String get careerMedalGold => 'ZLATO';

  @override
  String get careerMedalSilver => 'STŘÍBRO';

  @override
  String get careerMedalBronze => 'BRONZ';

  @override
  String careerWinnersName(String name) {
    return 'Vítěz: $name';
  }

  @override
  String get careerSavesTitle => 'ULOŽENÉ HRY';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Uložené hry se nepodařilo načíst.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'POZICE  $used/$limit';
  }

  @override
  String get careerThisSave => 'toto uložení';

  @override
  String get careerSlotsFull => 'Pozice plné';

  @override
  String careerSlotsUsed(int used) {
    return 'POZICE  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Odemknout více pozic';

  @override
  String get careerSlotsKeepNote =>
      'Každé uložení, které už máte, zůstává hratelné. Odemčení potřebuje jen nové.';

  @override
  String get careerNewGame => 'Nová hra';

  @override
  String get careerDeleteSaveTitle => 'Smazat uloženou hru?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Tímto trvale smažete vaši kariéru ($label).';
  }

  @override
  String get careerCancel => 'Zrušit';

  @override
  String get careerDelete => 'Smazat';

  @override
  String get careerNoSavesYet =>
      'Zatím žádné uložené hry.\nZačněte novou hru a veďte reprezentaci.';

  @override
  String get careerUnknownNation => 'Neznámý';

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
    return 'Naposledy hráno $when';
  }

  @override
  String get careerJustNow => 'právě teď';

  @override
  String get careerYesterday => 'včera';

  @override
  String careerMinutesAgo(int n) {
    return 'před $n min';
  }

  @override
  String careerHoursAgo(int n) {
    return 'před $n h';
  }

  @override
  String careerDaysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'před $n dny',
      one: 'před 1 dnem',
    );
    return '$_temp0';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Cesta na MS $year';
  }

  @override
  String homeNextFixture(String match, String when) {
    return 'Další: $match, $when';
  }

  @override
  String homeCycleComplete(int year) {
    return 'Mistrovství světa $year skončilo. Na řadě je verdikt vedení.';
  }

  @override
  String homeFollowingFinals(int year) {
    return 'MS $year z tribuny';
  }

  @override
  String get careerManagerCareerTitle => 'TRENÉRSKÁ KARIÉRA';

  @override
  String careerCouldNotLoad(String error) {
    return 'Načtení se nezdařilo.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CYKLUS PO CYKLU';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cyklů',
      few: '$cycles cykly',
      one: '1 cyklus',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: 'vedeno $nations reprezentací',
      few: 'vedeny $nations reprezentace',
      one: 'vedena 1 reprezentace',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Tituly';

  @override
  String get careerStatPlayed => 'Odehrané';

  @override
  String get careerStatWon => 'Výhry';

  @override
  String get careerStatDrawn => 'Remízy';

  @override
  String get careerStatLost => 'Prohry';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Góly $goalsFor–$goalsAgainst  ($gd)  ·  Úspěšnost $winRate%';
  }

  @override
  String get careerRecordResults => 'REKORDNÍ VÝSLEDKY';

  @override
  String get careerBestWin => 'Nejvyšší výhra';

  @override
  String get careerWorstDefeat => 'Nejhorší porážka';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'proti $opponent · $date';
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
    return '${won}V ${drawn}R ${lost}P  ·  VG $goalsFor OG $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Mistrovství světa';

  @override
  String get careerContinentalLabel => 'Kontinentální';

  @override
  String get messagesTitle => 'ZPRÁVY';

  @override
  String get messagesNoMessagesYet => 'Zatím žádné zprávy.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Nepodařilo se načíst zprávy.\n$error';
  }

  @override
  String get messagesDone => 'Hotovo';

  @override
  String get messagesNext => 'Další';

  @override
  String get rankingWorldRanking => 'SVĚTOVÝ ŽEBŘÍČEK';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Nepodařilo se načíst žebříček.\n$error';
  }

  @override
  String get rankingNoRanking => 'Žádný žebříček.';

  @override
  String get rankingAll => 'VŠE';

  @override
  String get rankingYourTeam => 'VÁŠ TÝM';

  @override
  String get rankingYourRankingOverTime => 'VÁŠ ŽEBŘÍČEK V ČASE';

  @override
  String rankingNowRank(int rank) {
    return 'nyní #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'nejlepší #$best · nejhorší #$worst';
  }

  @override
  String get friendliesTitle => 'PŘÁTELSKÉ ZÁPASY';

  @override
  String friendliesLoadError(String error) {
    return 'Přátelské zápasy se nepodařilo načíst.\n$error';
  }

  @override
  String get friendliesContinue => 'Pokračovat';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count volných oken',
      few: '$count volná okna',
      one: '1 volné okno',
    );
    return 'Naplánujte přípravu na $_temp0 před dalším soutěžním zápasem. Klepněte na soupeře, nebo okno nechte volné.';
  }

  @override
  String get friendliesFree => 'Volné';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count GÓLŮ',
      few: '$count GÓLY',
      one: '1 GÓL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'GÓLY';

  @override
  String get matchGoalsNone => 'Bez gólu';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'SK';

  @override
  String matchGoalAssist(String name) {
    return 'asistence $name';
  }

  @override
  String get friendliesHome => 'DOMA';

  @override
  String get friendliesAway => 'VENKU';

  @override
  String get friendliesNoneThisWindow => 'Žádné přátelské zápasy';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count přátelských zápasů',
      few: '$count přátelské zápasy',
      one: '1 přátelský zápas',
    );
    return 'Potvrdit $_temp0';
  }

  @override
  String get friendliesMonthJan => 'led';

  @override
  String get friendliesMonthFeb => 'úno';

  @override
  String get friendliesMonthMar => 'bře';

  @override
  String get friendliesMonthApr => 'dub';

  @override
  String get friendliesMonthMay => 'kvě';

  @override
  String get friendliesMonthJun => 'čvn';

  @override
  String get friendliesMonthJul => 'čvc';

  @override
  String get friendliesMonthAug => 'srp';

  @override
  String get friendliesMonthSep => 'zář';

  @override
  String get friendliesMonthOct => 'říj';

  @override
  String get friendliesMonthNov => 'lis';

  @override
  String get friendliesMonthDec => 'pro';

  @override
  String get resultsMyMatches => 'MOJE ZÁPASY';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Nepodařilo se načíst výsledky.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Žádné zápasy.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'KVALIFIKACE';

  @override
  String get resultsStageFriendly => 'PŘÁTELSKÝ ZÁPAS';

  @override
  String get resultsStageGroupStage => 'SKUPINOVÁ FÁZE';

  @override
  String get resultsStageSemiFinal => 'SEMIFINÁLE';

  @override
  String get resultsStageFinal => 'FINÁLE';

  @override
  String get resultsStageContinentalClash => 'SOUBOJ KONTINENTŮ';

  @override
  String get resultsStageFinalsGroup => 'SKUPINA FINÁLOVÉHO TURNAJE';

  @override
  String get resultsStageRoundOf32 => 'ŠESTNÁCTIFINÁLE';

  @override
  String get resultsStageRoundOf16 => 'OSMIFINÁLE';

  @override
  String get resultsStageQuarterFinal => 'ČTVRTFINÁLE';

  @override
  String get resultsStageThirdPlace => 'O TŘETÍ MÍSTO';

  @override
  String get matchSetupWarnCaptain =>
      'Není určen kapitán. Klepnutím mu dáte pásku';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name je zraněný a tenhle zápas nepovede. Klepnutím předáte pásku dál';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name má na tenhle zápas stop. Klepnutím předáte pásku dál';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name má pásku, ale není v nominaci. Klepnutím ji předáte dál';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Nejsou určeni exekutoři standardek. Klepnutím je vyberete';

  @override
  String get matchSetupWarnBoth =>
      'Není kapitán ani exekutoři standardek. Klepnutím to nastavíte';

  @override
  String matchStageMatchday(int matchday) {
    return '$matchday. kolo';
  }

  @override
  String get squadCaptain => 'Kapitán';

  @override
  String deptEffectYouth(int points) {
    return 'Talenti z akademie přijdou zhruba o $points lepší';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount zpět na konci cyklu';
  }

  @override
  String deptEffectMedical(int percent) {
    return 'O $percent % méně zranění';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% šance, že se ozve cizí hráč';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points trpělivosti vedení, než půjde o vaše místo';
  }

  @override
  String get deptEffectNone => 'Bez financování nemá žádný efekt';

  @override
  String get statsBestRated => 'Známky';

  @override
  String get statsMyCareer => 'Kariéra';

  @override
  String get statsBestAverageRating => 'NEJLEPŠÍ PRŮMĚRNÁ ZNÁMKA';

  @override
  String get statsMyCareerRecord => 'VAŠE BILANCE';

  @override
  String get statsNoRatingsRecorded => 'Zatím nejsou zaznamenané žádné známky.';

  @override
  String get statsGroupRecord => 'Bilance';

  @override
  String get statsGroupRuns => 'Série';

  @override
  String get statsGroupExtremes => 'Extrémy';

  @override
  String get statsGroupSplits => 'Doma a venku';

  @override
  String get statsGroupSquad => 'Vaši hráči';

  @override
  String get statsPlayed => 'Odehrané zápasy';

  @override
  String get statsWinDrawLoss => 'Výhry–remízy–prohry';

  @override
  String get statsWinRate => 'Úspěšnost';

  @override
  String get statsGoals => 'Vstřelené:obdržené';

  @override
  String get statsCleanSheets => 'Čistá konta';

  @override
  String get statsFailedToScore => 'Bez vstřelené branky';

  @override
  String get statsLongestWinStreak => 'Nejdelší série výher';

  @override
  String get statsLongestUnbeaten => 'Nejdelší neporazitelnost';

  @override
  String get statsLongestCleanSheets => 'Nejdelší série čistých kont';

  @override
  String get statsLongestWinless => 'Nejdelší série bez výhry';

  @override
  String get statsCurrentRun => 'Aktuální neporazitelnost';

  @override
  String get statsBiggestWin => 'Nejvyšší výhra';

  @override
  String get statsHeaviestDefeat => 'Nejvyšší prohra';

  @override
  String get statsMostGoalsInAGame => 'Nejvíc gólů v zápase';

  @override
  String get statsShootouts => 'Penalty výhry–prohry';

  @override
  String get statsComebackWins => 'Otočené zápasy';

  @override
  String get statsHome => 'Doma';

  @override
  String get statsAway => 'Venku';

  @override
  String get statsNeutral => 'Neutrální půda';

  @override
  String get statsCompetitive => 'Soutěžní';

  @override
  String get statsFriendlies => 'Přátelské';

  @override
  String get statsHatTricks => 'Hattricky';

  @override
  String get statsBraces => 'Dvougólové zápasy';

  @override
  String get statsMotms => 'Ocenění pro muže zápasu';

  @override
  String get statsAssists => 'Asistence';

  @override
  String get statsCards => 'Karty';

  @override
  String get statsBestRating => 'Nejlepší individuální známka';

  @override
  String statsAppsShort(int apps) {
    String _temp0 = intl.Intl.pluralLogic(
      apps,
      locale: localeName,
      other: '$apps startů',
      few: '$apps starty',
      one: '1 start',
    );
    return '$_temp0';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms× MVP';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent => 'Kapitán. Klepnutím pásku sejmete';

  @override
  String get captainFitBorn => 'Rozený vůdce';

  @override
  String get captainFitNatural => 'Přirozený kapitán';

  @override
  String get captainFitCapable => 'Pásku by unesl';

  @override
  String get captainFitUnproven => 'Zatím ne vůdce';

  @override
  String get captainNone => 'Kapitán nebyl jmenován';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale morálky týmu';
  }

  @override
  String get viceCaptainFirst => '1. zástupce';

  @override
  String get viceCaptainSecond => '2. zástupce';

  @override
  String get viceCaptainNone => 'Zástupce nebyl jmenován';

  @override
  String get viceCaptainHint =>
      'Převezme kapitánskou pásku, když kapitán nemůže hrát.';

  @override
  String captainStandIn(String vice, String captain) {
    return 'Tým vyvede zástupce kapitána $vice, kapitán $captain nemůže hrát';
  }

  @override
  String captainStandInUnnamed(String vice) {
    return 'Tým vyvede zástupce kapitána $vice';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'Kvalifikace na MS';

  @override
  String get resultsCategoryFriendlies => 'Přátelské zápasy';

  @override
  String get resultsCategoryContinentalClash => 'Souboj kontinentů';

  @override
  String get resultsCategoryNationsCup => 'Pohár národů';

  @override
  String get resultsCategoryContinentalCup => 'Kontinentální pohár';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'MS Q';

  @override
  String get resultsCategoryContinentalQualifyingShort =>
      'Kontinentální pohár Q';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Kvalifikace kontinentálního poháru';

  @override
  String get resultsCategoryWorldCupFinals => 'Mistrovství světa';

  @override
  String get resultsRoundResults => 'VÝSLEDKY KOLA';

  @override
  String get resultsFriendlyInternationals => 'PŘÁTELSKÉ REPREZENTAČNÍ ZÁPASY';

  @override
  String get resultsKnockout => 'Vyřazovací fáze';

  @override
  String resultsEarlierMatches(int count) {
    return 'Starší zápasy ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return '$matchday. KOLO';
  }

  @override
  String get resultsContinue => 'Pokračovat';

  @override
  String resultsGroup(String name) {
    return 'SKUPINA $name';
  }

  @override
  String get achievementsScreenTitle => 'ÚSPĚCHY';

  @override
  String get achievementsChallengesTooltip => 'Výzvy';

  @override
  String get achievementsChallengesHeading => 'VÝZVY';

  @override
  String get achievementsBrutalTests => 'Nelítostné zkoušky na celou kariéru';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Nepodařilo se načíst.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total odemčeno';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total zdoláno';
  }

  @override
  String get achievementsBoardSatisfaction => 'SPOKOJENOST VEDENÍ';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ÚSPĚCHŮ ODEMČENO',
      many: '$count ÚSPĚCHŮ ODEMČENO',
      few: '$count ÚSPĚCHY ODEMČENY',
      one: 'ÚSPĚCH ODEMČEN',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Výhry';

  @override
  String get achCatMatches => 'Zápasy';

  @override
  String get achCatQualifications => 'Kvalifikace';

  @override
  String get achCatTitles => 'Tituly';

  @override
  String get achCatMisc => 'Různé';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Góly';

  @override
  String get achCatStreaks => 'Série';

  @override
  String get achTierBronze => 'Bronz';

  @override
  String get achTierSilver => 'Stříbro';

  @override
  String get achTierGold => 'Zlato';

  @override
  String get achTierPlatinum => 'Platina';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gólů',
      few: '$count góly',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vstřelte $count gólů.',
      few: 'Vstřelte $count góly.',
      one: 'Vstřelte 1 gól.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count čistých kont',
      few: '$count čistá konta',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Udržte $count čistých kont.',
      few: 'Udržte $count čistá konta.',
      one: 'Udržte 1 čisté konto.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Vítězný návyk';

  @override
  String get achStreakWin5Desc => 'Vyhrajte pět zápasů v řadě.';

  @override
  String get achStreakWin10 => 'Ve formě';

  @override
  String get achStreakWin10Desc => 'Vyhrajte deset zápasů v řadě.';

  @override
  String get achStreakWin20 => 'Válec';

  @override
  String get achStreakWin20Desc => 'Vyhrajte dvacet zápasů v řadě.';

  @override
  String get achUnbeaten15 => 'Těžko k poražení';

  @override
  String get achUnbeaten15Desc => 'Zůstaňte patnáct zápasů neporažení.';

  @override
  String get achUnbeaten30 => 'Nedotknutelní';

  @override
  String get achUnbeaten30Desc => 'Zůstaňte třicet zápasů neporažení.';

  @override
  String get achHattrick => 'Hattrickový hrdina';

  @override
  String get achHattrickDesc => 'Nechte hráče vstřelit hattrick.';

  @override
  String get achMotm10 => 'Výrazná postava';

  @override
  String get achMotm10Desc => 'Získejte 10 ocenění muže zápasu.';

  @override
  String get achMotm50 => 'Vůdčí osobnost';

  @override
  String get achMotm50Desc => 'Získejte 50 ocenění muže zápasu.';

  @override
  String get achPerfect => 'Perfektní desítka';

  @override
  String get achPerfectDesc => 'Nechte hráče získat známku 9,5 a vyšší.';

  @override
  String get achShootout => 'Ledový klid';

  @override
  String get achShootoutDesc => 'Vyhrajte pět penaltových rozstřelů.';

  @override
  String get achMassacre => 'Masakr';

  @override
  String get achMassacreDesc => 'Vyhrajte zápas o 7 a více gólů.';

  @override
  String get achAnnihilation => 'Zničení';

  @override
  String get achAnnihilationDesc => 'Vyhrajte zápas o 10 a více gólů.';

  @override
  String get chTierBronze => 'Bronz';

  @override
  String get chTierSilver => 'Stříbro';

  @override
  String get chTierGold => 'Zlato';

  @override
  String get chTierLegendary => 'Legendární';

  @override
  String get chFirstSteps => 'Na lavičce';

  @override
  String get chFirstStepsDesc => 'Trénujte 5 let.';

  @override
  String get chUnbeaten10 => 'Ve formě';

  @override
  String get chUnbeaten10Desc => 'Zůstaňte 10 soutěžních zápasů neporažení.';

  @override
  String get chTwoNations => 'Nová výzva';

  @override
  String get chTwoNationsDesc => 'Veďte 2 různé reprezentace.';

  @override
  String get chCont1 => 'Kontinentální šampion';

  @override
  String get chCont1Desc => 'Vyhrajte kontinentální šampionát.';

  @override
  String get chNc1 => 'Vítěz Poháru národů';

  @override
  String get chNc1Desc => 'Vyhrajte Pohár národů.';

  @override
  String get chWc1 => 'Mistr světa';

  @override
  String get chWc1Desc => 'Vyhrajte mistrovství světa.';

  @override
  String get chYears25 => 'Zavedená značka';

  @override
  String get chYears25Desc => 'Trénujte 25 let.';

  @override
  String get chWc3 => 'Sériový vítěz';

  @override
  String get chWc3Desc => 'Vyhrajte 3 mistrovství světa.';

  @override
  String get chWc5 => 'Dynastie';

  @override
  String get chWc5Desc => 'Vyhrajte 5 mistrovství světa.';

  @override
  String get chWc10 => 'Nesmrtelný';

  @override
  String get chWc10Desc => 'Vyhrajte 10 mistrovství světa.';

  @override
  String get chWc2Teams => 'S kufry na cestách';

  @override
  String get chWc2TeamsDesc =>
      'Vyhrajte mistrovství světa se 2 různými reprezentacemi.';

  @override
  String get chWc3Teams => 'Světoběžník';

  @override
  String get chWc3TeamsDesc =>
      'Vyhrajte mistrovství světa se 3 různými reprezentacemi.';

  @override
  String get chWcStreak3 => 'Tři v řadě';

  @override
  String get chWcStreak3Desc => 'Vyhrajte 3 mistrovství světa v řadě.';

  @override
  String get chWcAllconf => 'Dobyvatel světa';

  @override
  String get chWcAllconfDesc =>
      'Vyhrajte mistrovství světa s reprezentací z každé konfederace (6).';

  @override
  String get chCont5 => 'Kontinentální král';

  @override
  String get chCont5Desc => 'Vyhrajte 5 kontinentálních šampionátů.';

  @override
  String get chContAll => 'Slam šesti kontinentů';

  @override
  String get chContAllDesc =>
      'Vyhrajte kontinentální šampionát každé konfederace (6).';

  @override
  String get chTreble => 'Kompletní úklid';

  @override
  String get chTrebleDesc =>
      'Vyhrajte mistrovství světa, kontinentální titul a Pohár národů v jedné kariéře.';

  @override
  String get chNations10 => 'Nomád';

  @override
  String get chNations10Desc => 'Veďte 10 různých reprezentací.';

  @override
  String get chYears100 => 'Století';

  @override
  String get chYears100Desc => 'Trénujte 100 let.';

  @override
  String get chYears500 => 'Půl tisíciletí';

  @override
  String get chYears500Desc => 'Trénujte 500 let.';

  @override
  String get chYears1000 => 'Věčný';

  @override
  String get chYears1000Desc => 'Trénujte 1000 let.';

  @override
  String get chGrandmaster => 'Velmistr';

  @override
  String get chGrandmasterDesc =>
      'Vyhrajte 3 mistrovství světa A 5 kontinentálních šampionátů.';

  @override
  String get chUndefeated => 'Nedotknutelný';

  @override
  String get chUndefeatedDesc =>
      'Vyhrajte mistrovství světa bez jediné porážky.';

  @override
  String get chPerfectQual => 'Bezchybný postup';

  @override
  String get chPerfectQualDesc =>
      'Vyhrajte každý zápas kvalifikační kampaně na mistrovství světa.';

  @override
  String get chMinnow => 'Zázrak outsidera';

  @override
  String get chMinnowDesc =>
      'Vyhrajte mistrovství světa s reprezentací mimo světovou top 32.';

  @override
  String get chGrandTour => 'Doma i venku';

  @override
  String get chGrandTourDesc =>
      'Vyhrajte mistrovství světa jako pořadatel a jedno i mimo domov.';

  @override
  String get chUnbeaten25 => 'Zeď';

  @override
  String get chUnbeaten25Desc => 'Zůstaňte 25 soutěžních zápasů neporažení.';

  @override
  String get chGoals10k => 'Gólostroj';

  @override
  String get chGoals10kDesc => 'Vstřelte 10 000 gólů za kariéru.';

  @override
  String get chCleanSheets500 => 'Pevnost';

  @override
  String get chCleanSheets500Desc => 'Udržte 500 čistých kont za kariéru.';

  @override
  String get chHatTricks25 => 'Hattrickový zvyk';

  @override
  String get chHatTricks25Desc => 'Nechte své hráče vstřelit 25 hattricků.';

  @override
  String get chWinStreak25 => 'Neúprosný';

  @override
  String get chWinStreak25Desc => 'Vyhrajte 25 zápasů v řadě.';

  @override
  String get chCont10 => 'Kontinentální dynastie';

  @override
  String get chCont10Desc => 'Vyhrajte 10 kontinentálních šampionátů.';

  @override
  String get chPcWc => 'Sériový šampion';

  @override
  String chPcWcDesc(int count) {
    return 'Vyhrajte v této hře $count mistrovství světa.';
  }

  @override
  String get chPcMajors => 'Sběratel trofejí';

  @override
  String chPcMajorsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vyhrajte $count velkých trofejí',
      few: 'Vyhrajte $count velké trofeje',
      one: 'Vyhrajte 1 velkou trofej',
    );
    return '$_temp0 (mistrovství světa, kontinentální, Pohár národů nebo Souboj kontinentů).';
  }

  @override
  String get chPcUnbeaten => 'Železná zeď';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Zůstaňte $count soutěžních zápasů neporažení.';
  }

  @override
  String get chPcNations => 'Kočovník';

  @override
  String chPcNationsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Veďte $count různých reprezentací.',
      few: 'Veďte $count různé reprezentace.',
      one: 'Veďte 1 reprezentaci.',
    );
    return '$_temp0';
  }

  @override
  String get chPcYears => 'Běh na dlouhou trať';

  @override
  String chPcYearsDesc(int count) {
    return 'Trénujte $count let.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count výher',
      few: '$count výhry',
      one: '1 výhra',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vyhrajte $count zápasů.',
      few: 'Vyhrajte $count zápasy.',
      one: 'Vyhrajte 1 zápas.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odehrajte $count zápasů.',
      few: 'Odehrajte $count zápasy.',
      one: 'Odehrajte 1 zápas.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Účast na MS';

  @override
  String get achQualWcDesc => 'Postupte na mistrovství světa.';

  @override
  String get achQualCont => 'Účast na kontinentálním šampionátu';

  @override
  String get achQualContDesc => 'Postupte na svůj kontinentální šampionát.';

  @override
  String get achTitleWc => 'Mistři světa';

  @override
  String get achTitleWcDesc => 'Vyhrajte mistrovství světa.';

  @override
  String get achTitleEuro => 'Mistři Evropy';

  @override
  String get achTitleEuroDesc => 'Vyhrajte mistrovství Evropy.';

  @override
  String get achTitleCopa => 'Mistři Jižní Ameriky';

  @override
  String get achTitleCopaDesc => 'Vyhrajte Pohár Jižní Ameriky.';

  @override
  String get achTitleAfcon => 'Mistři Afriky';

  @override
  String get achTitleAfconDesc => 'Vyhrajte mistrovství Afriky.';

  @override
  String get achTitleAsia => 'Mistři Asie';

  @override
  String get achTitleAsiaDesc => 'Vyhrajte mistrovství Asie.';

  @override
  String get achTitleConcacaf => 'Mistři Severní Ameriky';

  @override
  String get achTitleConcacafDesc => 'Vyhrajte Pohár Severní Ameriky.';

  @override
  String get achTitleOfc => 'Mistři Oceánie';

  @override
  String get achTitleOfcDesc => 'Vyhrajte Pohár Oceánie.';

  @override
  String get achTitleNations => 'Vítězové Poháru národů';

  @override
  String get achTitleNationsDesc => 'Vyhrajte Pohár národů.';

  @override
  String get achTitleClash => 'Vítězové Kontinentálního souboje';

  @override
  String get achTitleClashDesc => 'Vyhrajte Kontinentální souboj.';

  @override
  String get achMarksman => 'Kanonýr MS';

  @override
  String get achMarksmanDesc =>
      'Nechte hráče základního výběru nastřílet 6+ gólů na závěrečném turnaji MS.';

  @override
  String get achSweep => 'Kompletní úklid';

  @override
  String get achSweepDesc =>
      'Držte titul mistrů světa i kontinentální titul v jedné kariéře.';

  @override
  String get achAllstar => 'Hvězda turnaje';

  @override
  String get achAllstarDesc =>
      'Nechte hráče zvolit do all-stars týmu mistrovství světa.';

  @override
  String get achGoldenboot => 'Zlatá kopačka';

  @override
  String get achGoldenbootDesc =>
      'Nechte svou reprezentaci stát se nejlepším střelcem šampionátu.';

  @override
  String get achDemolition => 'Demolice';

  @override
  String get achDemolitionDesc => 'Vyhrajte zápas o 5 a více gólů.';

  @override
  String get achievementsNice => 'Paráda!';

  @override
  String get achievementsHardestTests =>
      'Nejtěžší zkoušky trenéra, napříč celou kariérou a mnoha zeměmi.';

  @override
  String get achievementsThisSave => 'TATO HRA';

  @override
  String get achievementsBrutalBadge => 'BRUTÁLNÍ';

  @override
  String get paywallGoPro => 'NEOMEZENÉ FNM';

  @override
  String get paywallOneTimeUnlock => 'Jednorázové odemčení. Žádné předplatné.';

  @override
  String get paywallBenefitCarryOn =>
      'Tahle hra pokračuje přesně tam, kde skončila, se všemi starty, rekordy i rivalitami.';

  @override
  String get paywallBenefitNoAds =>
      'Žádné reklamy, žádné mikrotransakce, žádné předplatné. Jedna platba a všechny budoucí aktualizace jsou vaše.';

  @override
  String get paywallBenefitSaves =>
      'Zkoušejte klidně 10 různých kariér. Favorita i outsidera najednou, a uvidíte, jak jinak se stejná hra hraje.';

  @override
  String get paywallBenefitEndless =>
      'Nekonečná hra. Nasaďte dnes sedmnáctiletého a v roce 2034 se dozvíte, jestli jste to viděl dobře.';

  @override
  String get paywallUnlocked => 'Neomezené FNM je odemčené. Užijte si ho!';

  @override
  String get paywallContactingStore => 'Kontaktuji obchod…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Odemknout neomezené FNM · $price';
  }

  @override
  String get paywallRestorePurchases => 'Obnovit nákupy';

  @override
  String get paywallStoreUnavailable => 'Obchod není dostupný';

  @override
  String get paywallStoreUnavailableNote =>
      'Cenu se nepodařilo načíst. Zkontrolujte připojení a zkuste to znovu.';

  @override
  String get paywallTryAgain => 'Zkusit znovu';

  @override
  String get gateTitle => 'PRVNÍ CYKLUS KONČÍ';

  @override
  String get gateLead =>
      'Čtyři roky jsou jeden cyklus. To není dost dlouho na to, abyste zjistil, jestli jste měl pravdu.';

  @override
  String get gatePriceLead => 'Jedna platba, navždy';

  @override
  String get gateBuy => 'KOUPIT A POKRAČOVAT';

  @override
  String get gateExit => 'ODEJÍT';

  @override
  String get gateSaveTitle => 'TATO HRA VYŽADUJE PRO';

  @override
  String get gateSaveLead =>
      'Hry za bezplatným cyklem a Pro kampaně pokračují s Pro. Nic se neztratí: hra na vás počká přesně tak, jak jste ji opustil.';

  @override
  String get careerSaveLockedNote => 'K pokračování v této hře potřebujete Pro';

  @override
  String get federationNaturalisation => 'NATURALIZACE';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name naturalizován';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name dokončil změnu reprezentace a je nyní k dispozici za $nation. Povolejte ho ve své nominaci.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Nabídku se nepodařilo načíst.\n$error';
  }

  @override
  String get federationContinue => 'Pokračovat';

  @override
  String get federationOfferToSwitchAllegiance =>
      'NABÍDKA KE ZMĚNĚ REPREZENTACE';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · věk $age · z $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name má vazby na $playerNation a je ochoten se nechat naturalizovat. Přijměte a bude k dispozici pro nominaci; odmítněte a zůstane u reprezentace $sourceNation.';
  }

  @override
  String get federationDecline => 'Odmítnout';

  @override
  String get federationNaturalise => 'Naturalizovat';

  @override
  String get federationBudgetLater => 'Rozhodnout později';

  @override
  String get federationSetYourBudget => 'NASTAVTE ROZPOČET';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Finance se nepodařilo načíst.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Uložená hra nenalezena.';

  @override
  String get federationBudgetHeading => 'ROZPOČET FEDERACE';

  @override
  String federationDistributeBudget(String amount) {
    return 'Rozdělte $amount mezi jednotlivá oddělení a zahajte cyklus. Utraťte je moudře.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount nad rámec rozpočtu. Část je potřeba vrátit';
  }

  @override
  String get federationAllocateFullBudget =>
      'Rozdělte celý rozpočet, abyste mohli zahájit cyklus.';

  @override
  String get federationConfirming => 'Potvrzuji…';

  @override
  String get federationConfirmBudget => 'Potvrdit rozpočet';

  @override
  String get federationFinances => 'FINANCE';

  @override
  String get federationInvestmentUpdated => 'Investice aktualizována.';

  @override
  String get federationDevelopment => 'ROZVOJ FEDERACE';

  @override
  String get federationProjectedAtSeasonEnd => 'ODHAD NA KONCI SEZÓNY';

  @override
  String get federationCentralFunding => 'Centrální dotace';

  @override
  String get federationPrizeMoneySoFar => 'Dosavadní prémie';

  @override
  String get federationCommercialReturn => 'Komerční výnos';

  @override
  String get federationThisSeasonLocked => 'TATO SEZÓNA (UZAMČENO)';

  @override
  String get federationInvestForNextSeason => 'INVESTICE PRO PŘÍŠTÍ SEZÓNU';

  @override
  String get federationNextSeasonImpact => 'DOPAD NA PŘÍŠTÍ SEZÓNU';

  @override
  String get federationSaving => 'Ukládám…';

  @override
  String get federationConfirmInvestment => 'Potvrdit investici';

  @override
  String get federationBalance => 'ZŮSTATEK FEDERACE';

  @override
  String get federationCommittedToStaff => 'Slíbeno realizačnímu týmu';

  @override
  String get federationFreeToSpend => 'Volné k utracení';

  @override
  String get federationWagesNote =>
      'Mzdy se z rozpočtu strhnou na konci cyklu, takže tato část je už zadaná.';

  @override
  String get federationInvestAtCeremony =>
      'Investujte pro příští sezónu při ceremonii na konci cyklu.';

  @override
  String federationLevelBadge(int level) {
    return 'Ú$level';
  }

  @override
  String get federationAcademyProspects => 'Talenty z akademie';

  @override
  String federationPlusOverall(int value) {
    return '+$value celkově';
  }

  @override
  String get federationInjuryRisk => 'Riziko zranění';

  @override
  String get federationNaturalisationChance => 'Šance na naturalizaci';

  @override
  String get federationBoardPatience => 'Trpělivost vedení';

  @override
  String get federationUnallocated => 'NEROZDĚLENO';

  @override
  String get nationsVitrineTitle => 'VITRÍNA REPREZENTACE';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Nepodařilo se načíst zemi.\n$error';
  }

  @override
  String get nationsNoNation => 'Žádná země.';

  @override
  String get nationsHonours => 'TROFEJE';

  @override
  String get nationsRankingHistory => 'HISTORIE SVĚTOVÉHO ŽEBŘÍČKU';

  @override
  String get nationsTopScorers => 'NEJLEPŠÍ STŘELCI HISTORIE';

  @override
  String get nationsTitles => 'TITULY';

  @override
  String get nationsYourTeam => 'VÁŠ TÝM';

  @override
  String get nationsWorld => 'SVĚT';

  @override
  String get nationsWorldCup => 'Mistrovství světa';

  @override
  String get nationsContinental => 'Kontinentální';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count účastí',
      few: '$count účasti',
      one: '1 účast',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Zatím není dost historie. Vraťte se po jednom či dvou cyklech.';

  @override
  String nationsBestRank(int rank) {
    return 'Nejlepší: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Nyní: #$rank';
  }

  @override
  String get nationsNoGoals => 'Zatím nebyly zaznamenány žádné góly.';

  @override
  String get nationsGoalsAbbrev => 'gólů';

  @override
  String get nationsHosts => 'POŘADATEL';

  @override
  String get nationsSelectTitle => 'VYBERTE REPREZENTACI';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Nepodařilo se načíst země.\n$error';
  }

  @override
  String get nationsNoMatch => 'Žádné země nevyhovují.';

  @override
  String get nationsSelectHeading => 'Vyberte reprezentaci';

  @override
  String get nationsSearchHint => 'Hledat zemi…';

  @override
  String get nationsRank => 'POŘADÍ ';

  @override
  String get nationsPremium => 'PRÉMIUM';

  @override
  String get nationsSelect => 'VYBRAT';

  @override
  String get statsTeamRecords => 'REKORDY TÝMU';

  @override
  String get statsRecordBook => 'Kniha rekordů';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Statistiky se nepodařilo načíst.\n$error';
  }

  @override
  String get statsNoData => 'Žádná data.';

  @override
  String get statsTopScorers => 'NEJLEPŠÍ STŘELCI';

  @override
  String get statsMostGamesPlayed => 'NEJVÍCE ODEHRANÝCH ZÁPASŮ';

  @override
  String get statsTeam => 'Tým';

  @override
  String get statsTopScorersShort => 'Střelci';

  @override
  String get statsMostGames => 'Nejvíce zápasů';

  @override
  String get statsMostGamesShort => 'Zápasy';

  @override
  String get statsNoGoalsRecorded => 'Zatím nebyly zaznamenány žádné góly.';

  @override
  String get statsUnknown => 'Neznámý';

  @override
  String get playerTitle => 'HRÁČ';

  @override
  String playerLoadError(String error) {
    return 'Hráče se nepodařilo načíst.\n$error';
  }

  @override
  String get playerNotFound => 'Hráč nenalezen.';

  @override
  String get playerClub => 'KLUB';

  @override
  String get playerClubRole => 'V klubu';

  @override
  String get playerPosition => 'Pozice';

  @override
  String get playerPotential => 'Potenciál';

  @override
  String get playerAge => 'Věk';

  @override
  String get playerValue => 'Hodnota';

  @override
  String get clubFirstChoice => 'Hraje pravidelně';

  @override
  String get clubRotation => 'Střídavě';

  @override
  String get clubFringe => 'Hraje málo';

  @override
  String get clubFrozenOut => 'Nehraje';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Sleduju fotbal třicet let a tohle jsem nečekal. $opponent poražen $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Nikdo jim proti $opponent nedával šanci. $score.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score proti $opponent. Vzbuďte sousedy, slavíme.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Na takový večer se vzpomíná celý život. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score proti $opponent. Nezajímá mě jak, je to tam!';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Na papíře bylo hotovo už před výkopem. $opponent $score říká něco jiného.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Porazili jsme $opponent $score. Za rok tomu výsledku nikdo neuvěří.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Užijte si to!';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score proti $opponent, sice jsme měli 80 minut štěstí, ale na to se historie ptát nebude.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Jeden večer proti $opponent nesmaže celý rok. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Porazili jsme $opponent $score a teď nám budou tvrdit, jak je vše růžové. Není.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Nádhera.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Porazili jsme $opponent $score. Přesně jak to má být, haha.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score nad $opponent. Bez slitování, ty cype!';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Žádné drama, žádné obavy ani výhrady, jen spokojenost.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Čistých $score proti $opponent. Takhle vypadá dobrý tým v jeho silný den.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score proti $opponent. Splněná povinnost, nic víc.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Porazili jsme $opponent $score. Přesně jak se čekalo.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Bezproblémové $score nad $opponent. Dál.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent odbyt $score. Zaznamenejte to a pokračujem.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score proti $opponent a my máme tleskat? Za výhru nad nimi?!';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Gratulace všem zúčastněným ke $score nad $opponent, no..';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Porážet takové týmy je bare minimum, ne úspěch.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Porazili jsme $opponent $score a vypadalo to těžkopádně.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score proti $opponent. Každá minuta vydřená.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Tohle vyžadovalo charakter. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Porazili jsme $opponent $score po těžkém, a proto cenném, průběhu,-';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score proti $opponent. Týmy, které tohle vyhrávají, jsou v červnu ještě ve hře.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nervózní, ošklivé, ale vítězné. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Porazili jsme $opponent $score. Nechci to už nikdy vidět, ale body beru.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent nás nechal dřít o každý centimetr.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Nebylo to hezké, ale to nevadí.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score proti $opponent a udělali jsme si to desetkrát těžší.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Proti $opponent bychom neměli viset na vlásku. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Vyhráli jsme, ale o sobě se nedozvěděli nic dobrého.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$score, které nám proti $opponent lichotí jako výsledek.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Bod proti $opponent, $score. Ber a jeď dál a nekomentuj!';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score s $opponent. Bývají i horší večery.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Udrželi jsme s $opponent $score. Ne všechno musí být super příběh.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Bod je bod.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score s $opponent. Ztracené dva body, nebo získaný jeden. Vyber si.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Remíza s $opponent, $score. Nikdo není šťastný ani smutný.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Nejzapomenutelnějších devadesát minut roku.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Dělili jsme se s $opponent, $score. Jedeme dál.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score proti $opponent. Takové remízy nás okrádají o dlouhodobé šance.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Dva body zahozené proti $opponent. $score. Jinak se to nazvat nedá.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Měli jsme devadesát minut a nevěděli, co s nimi. Meh';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$score s $opponent, který si nikdo nezapamatuje a všichni ho berou.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Prohra $score s $opponent. Stává se.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Není potřeba se věšet. Jedeme dál.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Prohráli jsme $score s $opponent a nechali tam všechno. Někdy to prostě nestačí.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score s $opponent. Hlavu vzhůru. Tenhle tým má toho v zásobě dost.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Byli jsme horší a není o čem.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Prohráli jsme $score s $opponent. Budeme zpět.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score s $opponent. Žádná ostuda, ale bylo to málo.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Prohra $score s $opponent. Poučme se, nebo to bylo k ničemu.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score s $opponent a ani jsme se jich nedotkli.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Prohra s $opponent, $score. Stejné chyby a stejné výmluvy.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Odkdy tohle přestává být jen smůla?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Prohra $score s $opponent. Takový výsledek by měl někoho něco stát. Třeba místo.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score s $opponent. Nj, jeden špatný večer. Soudit se má celá soutěž, nejen tohle.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Nikdo si $score proti $opponent nepřál míň než sami hráči.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Ošklivé a nehodné tohoto týmu.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$score na zapomenutí proti $opponent. Příště čelem vpřed.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. S $opponent. Nemám slov a to jsem placený za slova. #yInflu';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Někdo se za to bude zodpovídat.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Chci $score proti $opponent vyškrtnout ze zápisu i z paměti.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Prohra $score s $opponent. Takový výsledek se okecat nedá.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'To nebyla jen prohra s $opponent, to byla kapitulace. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. S $opponent. Lidé si za to koupili lístky!';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Jestli tohle něco nezmění, nezmění to už nikdy nic.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Viděl jsem tenhle tým ponížený už dřív, ale $score s $opponent je nové dno.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return 'Soupeř $opponent poražen $score. Zapište si datum, lidi se budou ptát, kde jste byli.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Mimo kabinu tomu nevěřil nikdo. $score proti týmu $opponent. Hrdost to ani nevystihuje.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score proti týmu $opponent! Každý z nich běhal, dokud mu zbyly síly.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Obr padl. $opponent, $score. Proto na fotbal chodíme pořád dokola.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score proti týmu $opponent. Papírové předpoklady právě letěly z okna.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Jasným favoritem byl soupeř $opponent. Konečný stav: $score pro nás.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Jedno z překvapení roku: $score proti týmu $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Nikdo to nečekal a nikdo to pořádně nevysvětlí.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score proti týmu $opponent. Krása. Teď sledujte, jak všichni zapomenou na zbytek roku.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return 'Výhra $score nad týmem $opponent a rozjetý vlak je plný. Já tu byl, když byl prázdný.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Skvělé, a stejně najdou způsob, jak to promrhat.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Velký večer proti týmu $opponent, $score. Jedna vlaštovka jaro nedělá.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score s týmem $opponent. Bolí to, protože nám na tom záleží. Stejně za nimi stojíme.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Večer, na který je lepší zapomenout: $score s týmem $opponent. Hráče to bolí nejvíc.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Hlavy vzhůru. Tým se pozná podle toho, jak na tohle odpoví.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score s týmem $opponent. Špatné, ano. Konec světa, ne.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score s týmem $opponent. O tomhle výsledku se bude mluvit roky, a ne v dobrém.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Soupeř $opponent vyhrál $score. Po tomhle by nás příště nemělo nic překvapit.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Jeden z nejhorších večerů za dlouhou dobu: $score s týmem $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Padnou otázky, a právem.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score s týmem $opponent. Ostuda je slabé slovo.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Prohra $score s týmem $opponent. Kdo odchází poslední, ať zhasne.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Přestalo mě to překvapovat, a to mě děsí.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Někdo nahoře by si dnes večer měl aktualizovat životopis.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score proti týmu $opponent! Takový fotbal rozesměje celou zemi.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return 'Soupeř $opponent rozdrcen $score. To byl ale výkon.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Proti týmu $opponent. Dnes vyšlo úplně všechno.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'Demolice $score, soupeř $opponent. Uložte si sestřih, budete ho chtít.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Tohle je tým, který si fotbal užívá.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score proti týmu $opponent a mohlo to být víc. Nádhera.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score proti týmu $opponent. Výsledek, na který se lidi podívají dvakrát.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return 'Soupeř $opponent poražen $score. Po půlhodině nebylo o čem.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Konečný stav: $score proti týmu $opponent. Bez debat nejvyšší výhra za dlouhou dobu.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Jeden tým přijel hrát, druhý ani nevystoupil z autobusu.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. Soupeř $opponent neměl odpověď vůbec na nic.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Výprask: $score proti týmu $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score proti týmu $opponent. Hezké, ale měřítko to zrovna není.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return 'Výhra $score nad týmem $opponent. Vzbuďte mě, až to uděláme někomu pořádnému.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Zábava, ale viděl jsem týmy vypadat takhle dobře a nevyhrát nic.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score a všichni jsou zase géniové. Byl to soupeř $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score proti týmu $opponent. Nenechte se unést, moc to nedokazuje.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Užijte si to a pak si vzpomeňte, jak to dopadlo minule, když jsme se nadchli.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Postup na penalty přes tým $opponent! Nervy z oceli, všichni do jednoho.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Penalty proti týmu $opponent a my to ustáli. Obejměte cizího člověka.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Rozstřel proti týmu $opponent vyhrán. Moje srdce tohle nedá.';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'Soupeř $opponent poražen na penalty. Postupujeme dál.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Proti týmu $opponent rozhodovaly penalty a my jich dali víc.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Rozstřel proti týmu $opponent zvládnut. Tou nejtěžší cestou, ale postup.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Postup na penalty přes tým $opponent. Loterie vyšla, na výkon se zapomene.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Po takovém výkonu porazit tým $opponent na penalty? Kliku jsme měli a všichni to vědí.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Přes tým $opponent na penalty. Vůbec jsme je neměli potřebovat.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'POSTUP. $score proti týmu $opponent a sen žije dál.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'VÝHRA VE VYŘAZOVACÍ FÁZI: soupeř $opponent poražen $score. Země může začít věřit.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score proti týmu $opponent a jdeme do dalšího kola. To byl večer.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return 'Soupeř $opponent jede domů, $score. Vpřed.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'VYŘAZOVACÍ FÁZE: $score proti týmu $opponent. Další kolo potvrzeno.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Postup: $score proti týmu $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return 'Soupeř $opponent vyřazen, $score. Čeká další kolo.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Výhra $score proti týmu $opponent. Ve vyřazovacích bojích se neptá jak.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Postup přes tým $opponent, $score. Další soupeř tak shovívavý nebude.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score proti týmu $opponent na postup stačí. Příště to bude chtít mnohem víc.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return 'Soupeř $opponent venku, $score. Spíš přežito než vyhráno.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Do dalšího kola po $score proti týmu $opponent. Neptejte se jak.';
  }

  @override
  String yUpsetGap0(String opponent, int gap) {
    return 'V žebříčku nás dělilo $gap míst, a stejně jsme porazili tým $opponent. Nádhera.';
  }

  @override
  String yUpsetGap1(String opponent, int gap) {
    return 'Soupeř $opponent byl v žebříčku o $gap míst výš. Poražen. Fotbal je krásný.';
  }

  @override
  String yUpsetGap2(String opponent, int gap) {
    return 'Rozdíl v žebříčku: $gap. Výsledek: porazili jsme tým $opponent. Nikdy nepřestávejte věřit.';
  }

  @override
  String yUpsetGap3(String opponent, int gap) {
    return 'Rozdíl v žebříčku před výkopem: $gap. Soupeř $opponent stejně poražen.';
  }

  @override
  String yUpsetGap4(String opponent, int gap) {
    return 'Soupeř $opponent byl ve světovém žebříčku o $gap míst před námi. Dnes ne.';
  }

  @override
  String yUpsetGap5(String opponent, int gap) {
    return 'Index překvapení: rozdíl $gap míst v žebříčku. Výhra nad týmem $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, int gap) {
    return 'Od týmu $opponent nás v žebříčku dělilo $gap míst. Jeden večer ten rozdíl nesmaže.';
  }

  @override
  String yUpsetGap7(String opponent, int gap) {
    return '$opponent: o $gap míst výš a poražen. Žebříček si toho skoro nevšimne.';
  }

  @override
  String yUpsetGap8(int gap) {
    return 'Rozdíl v žebříčku: $gap. Pamatujte si to číslo, až zase prohrajeme s outsiderem.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Odepsal jsem je. Mýlil jsem se a nikdy jsem se nemýlil raději. Soupeř $opponent poražen.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Jednu porci pokory, prosím. Velkou. Ta výhra nad týmem $opponent byla skvělá.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Tvrdil jsem, že už nemají co dát. Měli toho dost. Proti týmu $opponent dobře zahráno, všichni.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Pro pořádek: výhru nad týmem $opponent jsem nečekal. Klobouk dolů.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Dobře. Říkal jsem, že se na ně přijde. Soupeř $opponent na ně nepřišel.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Dnes večer budu jíst svá slova o tomhle týmu. Výhra nad týmem $opponent si to zaslouží.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Ano, říkal jsem, že jsou vyřízení. Jedna výhra nad týmem $opponent mi ještě nedokazuje omyl.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Prý mám po zápase s týmem $opponent spolknout svá slova. Spolknu, pomalu, a účtenku si nechám.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Výhra nad týmem $opponent byla působivá. Moje pochybnosti o tomhle týmu nikam nezmizely.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Klobouk dolů před týmem $nation. $score a zasloužili si to do posledního kousku.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Bolí to říct, ale tým $nation byl dnes lepší. $score. Gratulujeme.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Smekáme před týmem $nation, chtěli to víc.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Prohra $score s týmem $nation. Ani nevím, co na to říct.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Naši by se měli stydět.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score s týmem $nation. Ať mi někdo vysvětlí, jak se to stalo.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Prohrát $score s týmem $nation. Z tohohle se nevzpamatuju.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score s týmem $nation. Štěstí. Čisté štěstí.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Fanoušci týmu $nation budou po tom $score roky k nevydržení. Díky za nic.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Skvělé pro fotbal. Proto ho milujeme.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Jaký výsledek pro tým $nation: $score proti týmu $opponent. Fotbal v nejlepší podobě.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Všichni nestranní dnes fandí týmu $nation. $score proti týmu $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Výsledek kola: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Tohle neměl na tiketu nikdo.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Velký výsledek: $nation $score $opponent. Žebříček se pohne.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Zábava, ale uvidíme, jestli to zvládnou podruhé.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Vyhrál tým $nation, nebo prohrál tým $opponent?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Senzace: $nation $score $opponent. Čekejte spoustu přehnaných reakcí.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name proti týmu $opponent. Budou po něm pojmenovávat děti.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Sochu pro hráče $name. Dnes proti týmu $opponent byl vším.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, ty jsi zlatý. Na tenhle večer proti týmu $opponent se nezapomene.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name rozhodl zápas proti týmu $opponent. Hráč zápasu, bez debat.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Proti týmu $opponent patřil večer jedinému muži: $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name se ukázal, když na tom záleželo, proti týmu $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name byl proti týmu $opponent skvělý. Teď to dělat každý týden.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name zachránil tým proti soupeři $opponent. Ostatní moc nepomohli.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Bez hráče $name by to proti týmu $opponent byl úplně jiný večer.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score s týmem $opponent. Výsledek z říše divů. Jednou se to stane každému.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Prohra $score s týmem $opponent. Oklepat se, kampaň nekončí.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Bolí to, ale jeden výsledek tenhle tým nedefinuje.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score s týmem $opponent. Špatný den v práci. Jedeme dál.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Prohra s týmem $opponent, $score. Tohle nikdo nečekal.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Jeden z těch večerů, které nedávají smysl.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score s týmem $opponent. Porážka, na kterou se bude vzpomínat.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Poraženi týmem $opponent, $score. Šok, ať se na to díváte jakkoli.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score s týmem $opponent. S týmem $opponent! Nepřijatelné.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Prohra $score s týmem $opponent. Chci vysvětlení, ne výmluvy.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Národní ostuda, a to není řečnický obrat.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score s týmem $opponent. Jak je možné, že ti nahoře pořád sedí na svých místech?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score s týmem $opponent. Je to špičkový tým. Poučme se.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Soupeř $opponent nás přehrál, $score. Prohrát s nejlepšími není ostuda.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Lekce, a z lekcí se roste.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score s týmem $opponent. Bolí to, ale jsou o třídu výš.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Soupeř $opponent vyhrál $score. Rozdíl je skutečný a teď ho viděli všichni.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score s týmem $opponent. Výprask, nic víc, nic míň.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. Lepší tým, a výsledek to říká.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Prohra $score s týmem $opponent. Žádná ostuda, ale ani žádný souboj.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score s týmem $opponent. Lepší soupeř nebo ne, takhle prohrávat nikdo nemá.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Snažili jsme se vůbec hrát?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. S týmem $opponent. Jako ovce na porážku.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Prohra $score s týmem $opponent a nikdo nevypadal, že by ho to trápilo.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Konec na penalty proti týmu $opponent. Dali do toho všechno. Jsem na ně hrdý.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Penalty proti týmu $opponent. Nejkrutější způsob, jak vypadnout. Hlavy vzhůru.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Rozstřel proti týmu $opponent prohrán. Tohle si nezasloužil nikdo.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Konec na penalty proti týmu $opponent. Rozhodl rozstřel.';
  }

  @override
  String yLostShootout4(String opponent) {
    return 'Soupeř $opponent postupuje na penalty. Náš turnaj tím končí.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Rozstřel proti týmu $opponent prohrán. Zase penalty.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Konec na penalty proti týmu $opponent. Trénujeme je vůbec někdy?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Prohra s týmem $opponent na penalty. Měli jsme to rozhodnout dávno předtím.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Penalty proti týmu $opponent a prohráli jsme je. Jak jinak.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'KONEC. $score s týmem $opponent. Tažení, na které můžeme být hrdí, končí tady.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Vyřazeni týmem $opponent, $score. Díky za ty vzpomínky.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score s týmem $opponent. Cesta skončila, ale jaká to byla cesta.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'VYŘAZENI: $score s týmem $opponent. Hlavy vzhůru.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'VYPADLI JSME: $score s týmem $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Konec: $score s týmem $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return 'Soupeř $opponent postupuje, $score. Náš turnaj skončil.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Vyřazeni týmem $opponent, $score. Pitva začíná.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'KONEC. $score s týmem $opponent. Další turnaj, stejný konec.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score s týmem $opponent a jedeme domů. Nikoho to nepřekvapuje.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Vyřazeni týmem $opponent, $score. Do rána čekejte výmluvy.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Konec, a nikdy to nevypadalo na nic jiného.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score proti týmu $nation. Respekt, vrátí se silnější.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Dobrá výhra, $score. Špatný den pro tým $nation, jejich fanoušků je mi líto.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Tým $nation měl špatný večer a my využili šanci. Tak to je.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score proti týmu $nation! Kdo to čekal? Oni ne.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Výhra $score nad týmem $nation. Ať se někdo podívá, jak jsou na tom jejich fanoušci.';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Tohle jde do rodinného alba.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score proti týmu $nation. A to se považují za velký tým.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Představte si prohrát s námi $score. Zeptejte se týmu $nation, už to vědí.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Šťastnou cestu domů.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Velký večer pro tým $opponent, těžký pro tým $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Fanoušků týmu $nation je po $score proti týmu $opponent líto. Oni se zvednou.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Takový večer zažije každý velký tým.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Šok kola: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Tohle nečekal nikdo.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Výsledek dne: $nation $score $opponent. Tým $nation teď čekají otázky.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Žádná náhoda, pokud to sledujete.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Někdo tam bude mít hodně co vysvětlovat.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Velké jméno, malý výkon.';
  }

  @override
  String yDownGap0(String opponent, int gap) {
    return 'Soupeř $opponent byl o $gap míst za námi. Stává se. Jedeme dál.';
  }

  @override
  String yDownGap1(int gap) {
    return 'Rozdíl v žebříčku: $gap v náš prospěch. Fotbal žebříčky nečte.';
  }

  @override
  String yDownGap2(String opponent, int gap) {
    return 'Na papíře nás od týmu $opponent dělilo $gap míst. Na hřišti dnes ne.';
  }

  @override
  String yDownGap3(String opponent, int gap) {
    return 'Rozdíl v žebříčku před výkopem: $gap v náš prospěch. S týmem $opponent jsme stejně prohráli.';
  }

  @override
  String yDownGap4(String opponent, int gap) {
    return 'Soupeř $opponent byl ve světovém žebříčku o $gap míst pod námi. Výsledek: porážka.';
  }

  @override
  String yDownGap5(String opponent, int gap) {
    return 'Index překvapení: rozdíl $gap míst v žebříčku, jenže obráceně. Soupeř $opponent.';
  }

  @override
  String yDownGap6(String opponent, int gap) {
    return 'V žebříčku o $gap míst nad týmem $opponent. Prohra. Vysvětlete to.';
  }

  @override
  String yDownGap7(int gap) {
    return 'Prohra s týmem, který je o $gap míst pod námi. Nechte to číslo chvíli působit.';
  }

  @override
  String yDownGap8(String opponent, int gap) {
    return 'Rozdíl v žebříčku: $gap. Prohra s týmem $opponent. Někdo by si měl začít počítat dny.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score s týmem $opponent! Remíza, která chutná jako výhra.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return 'Remíza $score s týmem $opponent. Jsem hrdý na každého z nich.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Byli favorité a my jim stačili.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score s týmem $opponent. Bod vydřený krví a potem.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score s týmem $opponent. Hodně cenný bod.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Remíza $score s týmem $opponent. Málokdo čekal vůbec něco.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return 'Soupeř $opponent zastaven, $score. Výsledek, na kterém se dá stavět.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score s týmem $opponent. Bod, který nám nikdo nedával.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score s týmem $opponent. Dobrý bod, ale remízami se nic nevyhraje.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return 'Remíza $score s týmem $opponent. Hezké. Taky jsme neměli jedinou pořádnou střelu.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Jeden bod a všichni se chovají, jako bychom něco vyhráli.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score s týmem $opponent. Zaparkovali jsme autobus a měli kliku.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score s týmem $opponent. Frustrující, ale pořád bez porážky.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Jen $score s týmem $opponent. Den blbec. Stává se.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Málo, a hráči to vědí.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score s týmem $opponent. Dva ztracené body, nic víc.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score s týmem $opponent. Dva body zahozené.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Jen $score s týmem $opponent. Špatný výsledek, ať ho obléknete jakkoli.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Remíza, která chutná jako porážka.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score s týmem $opponent. Tohle bychom měli vyhrávat s přehledem.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score s týmem $opponent. Ostuda.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Jen remíza s týmem $opponent, $score. Kdo za tohle může?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Když neporazíme je, koho tedy porazíme?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score s týmem $opponent. Jejich fanoušci slaví remízu s námi. Zamyslete se nad tím.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'MISTŘI. $opponent. Řekni to nahlas.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'PŘEPIŠTE DĚJINY. $opponent. Nejsem v pořádku.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, a pohár jede s nám domů.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Každý z nich legenda. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Tak blízko. $opponent a medaile, kterou nikdo nechce. Ble..';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Druzí na $opponent. Tohle bude bolet roky.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: jeden zápas od všeho.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Druhé místo. Na $opponent. Podejte mi někdo flašku';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Konec na $opponent. Tohle bude chvíli bolet.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent je místo, kde to pro nás končí.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Vyřazeni na $opponent. A teď důsledky.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Vypadli jsme na $opponent. Ať mi to někdo vysvětlí.';
  }

  @override
  String yQualified0(String opponent) {
    return 'JEDEME NA $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Postup na $opponent. Zařiďte si dovolenou z práce.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, let\'s go. Nikdy jsme nepochybovali (pochybovali jsme pořád).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Jdeme na $opponent. To těžké je za námi.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Skupina pro $opponent je venku. Mohlo být hůř. Mnohem hůř.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Tak takhle dopadl los na $opponent. Zajímavé.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Skupiny na $opponent jsou vylosovány a ta naše se mi nelíbí.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Los na $opponent hotov. Ať začnou ty kecy.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Pořádá $opponent. Začněte šetřit prachy.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Jede se do $opponent. Předvídatelné, ale nevadí.';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'Turnaj získává $opponent. Gratuluji jim, asi?';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Pořadatel potvrzen: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent začíná brzy a já už se nemůžu dočkat.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Už to nebude dlouho trvat do $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent se blíží. Nominaci, prosím!';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Odpočet do $opponent je oficiálně nesnesitelný.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Zatím není o čem. Hrej zápas.';

  @override
  String get yEarlierHeading => 'Dříve v tomto cyklu';

  @override
  String get yTraitLoyalist =>
      'Chrání tým za každé situace. Rychle obrací list.';

  @override
  String get yTraitCynic =>
      'Člověk čeká to nejhorší a je nadšený, když má pravdu.';

  @override
  String get yTraitNostalgic =>
      'Dřív bylo všechno lepší. Když ještě hrál Diego.';

  @override
  String get yTraitStatshead =>
      'Píše čísla a nic jiného. Dobrou náladu nikdy nemá.';

  @override
  String get yTraitHypeman => 'Dvě dobrá utkání a je to zlatá generace.';

  @override
  String get yTraitContrarian => 'Ať si většina myslí cokoli, on je proti.';

  @override
  String get yTraitDoomer => 'Dopadne to špatně. Vždycky to dopadne špatně.';

  @override
  String get yProfilePosts => 'PŘÍSPĚVKY';

  @override
  String get yProfileEmpty => 'Od tohoto účtu zatím nic.';

  @override
  String hubEventGrievance(String player) {
    return '$player si chce promluvit';
  }

  @override
  String get hubEventGrievanceSub => 'Chce vědět, na čem je';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodů dovedností k rozdělení',
      few: '$count body dovedností k rozdělení',
      one: '1 bod dovedností k rozdělení',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'To, v čem jste dobří, dělá váš tým lepším';

  @override
  String get grievanceTitle => 'Slovo v kanceláři';

  @override
  String grievanceGameTime(String player) {
    return '$player je v nominaci a nekopl do míče. Chce vědět proč.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player není v nominaci a nechápe to. Chce to slyšet, tak či tak.';
  }

  @override
  String grievanceRole(String player) {
    return '$player hraje pořád mimo svůj post a má toho dost.';
  }

  @override
  String get grievanceReassure => 'Počítám s tebou';

  @override
  String get grievanceHonest => 'Jsi za ostatními, a tady je proč';

  @override
  String get grievanceDismiss => 'Sestavu určuji já';

  @override
  String yScorerStar0(String name, int goals) {
    return '$name z toho dal $goals. Nikdo jiný se ani nepřibližuje.';
  }

  @override
  String yScorerStar1(String name, int goals) {
    return '$goals pro hráče $name. Táhne celý tým.';
  }

  @override
  String yScorerStar2(String name, int goals) {
    return '$name: $goals za zápas. To je fotbalista.';
  }

  @override
  String yScorerStar3(String name, int goals) {
    return '$goals jim nasázel $name. Klobouk dolů.';
  }

  @override
  String yScorerStar4(String name, int goals) {
    return '$goals pro hráče $name, ostatní se vezli.';
  }

  @override
  String yScorerStar5(String name, int goals) {
    return 'Zase $name. $goals. Představte si ten tým bez něj.';
  }

  @override
  String yScorerStar6(String name, int goals) {
    return '$goals od hráče $name. Jeden člověk by toho neměl mít tolik na starost.';
  }

  @override
  String yScorerStar7(String name, int goals) {
    return 'Vezměte odtud $name a je to o $goals míň a úplně jiné odpoledne.';
  }

  @override
  String yWinStreak0(int count) {
    return '$count v řadě. Ať se v kabině říká cokoli, funguje to.';
  }

  @override
  String yWinStreak1(int count) {
    return 'Jsou to $count za sebou. Do takové série se tým nedostane náhodou.';
  }

  @override
  String yWinStreak2(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count výher',
      few: '$count výhry',
      one: '1 výhra',
    );
    return '$_temp0 v řadě a pokračuje se. Sebevědomí je vidět až na tribunu.';
  }

  @override
  String yWinStreak3(int count) {
    return 'Ani jedna prohra v $count zápasech. Zeptejte se kohokoli, kdo trénoval: tohle je to fakt těžké.';
  }

  @override
  String yWinStreak4(int count) {
    return '$count v řadě. Užijte si to, dokud je los milosrdný.';
  }

  @override
  String yWinStreak5(int count) {
    return '$count za sebou a neporazili jsme nikoho podstatného.';
  }

  @override
  String yWinStreak6(int count) {
    return 'Série $count zápasů. Zeptejte se mě, až přijde pořádná zkouška.';
  }

  @override
  String yWinStreak7(int count) {
    return '$count v řadě. Tohle se jednou povede každému týmu.';
  }

  @override
  String yLossStreak0(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return 'Už $_temp0 bez výhry. Výmluvy jednou dojdou.';
  }

  @override
  String yLossStreak1(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'To je $count proher v řadě.',
      few: 'To jsou $count prohry v řadě.',
      one: 'To je 1 prohra v řadě.',
    );
    return '$_temp0 Tohle už není výkyv.';
  }

  @override
  String yLossStreak2(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count porážek',
      few: '$count porážky',
      one: '1 porážka',
    );
    return '$_temp0 za sebou. Někdo se z toho bude zpovídat.';
  }

  @override
  String yLossStreak3(int count) {
    return 'Žádná výhra v $count zápasech. Je na nich deka.';
  }

  @override
  String yLossStreak4(int count) {
    return '$count bez výhry a každý týden stejné chyby.';
  }

  @override
  String yLossStreak5(int count) {
    return '$count v řadě. Ať se zkouší cokoli, nefunguje to.';
  }

  @override
  String yLossStreak6(int count) {
    return '$count za sebou. Tohle je směr, ne výkyv.';
  }

  @override
  String yLossStreak7(int count) {
    return 'Žádná výhra v $count zápasech a ze svazu ani slovo.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Říkejte si o tom fotbale co chcete. Tenhle počítá dvakrát.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Zrovna proti týmu $opponent. $score. Tady na to nikdo nezapomene.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score proti týmu $opponent. O tomhle se bude mluvit v hospodách.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Sousedé, $score. Právo se chlubit je na nějakou dobu rozdané.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Ať se letos stane cokoli, tohle už nikdo nesmaže.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score proti týmu $opponent. Někteří z nás to potřebovali jako sůl.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. A příště nám to vrátí, jako vždy.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Proti týmu $opponent, $score. Celý rok nám to budou připomínat.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name odstoupil zraněný. To bylo poslední, co tenhle tým potřeboval. Ach jo';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Ztráta hráče $name mění celé rozestavení.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name kulhá. Zadržte dech.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Chvíli tedy bez hráče $name. Někdo to musí vzít na sebe.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name je mimo. No jasně že $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Bez hráče $name je z toho hodně obyčejný tým.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name je zase zraněný. Někdo by se měl ptát proč. Ségra má narozky?';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Přišli jsme o hráče $name a za ním nikdo není. To je ten skutečný problém.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return '$name dostal červenou v $minute. minutě a celá země se na něj sesypala. Odmakal pro náš dres víc než většina ostatních. Nechte ho být.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name šel v $minute. minutě ze hřiště. Přísné. V deseti jsme se pořád rvali, to o tom týmu něco říká.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute. minuta, červená karta. Kapříci uplavali.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Vyloučení: $name v $minute. minutě. Není to první zápas, který otočí jedno rozhodnutí.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Skvělé. $name jde v $minute. minutě ze hřiště a hrajeme v deseti. Kapříci uplavali.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name vyloučen po $minute. minutě. Kdo tady vlastně učí hráče disciplíně?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return 'Do $minute. minuty $name udržel nervy. Profesionální fotbal.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return '$name dostal v $minute. minutě červenou a já mám věřit, že je to pokrok.';
  }

  @override
  String get yBoardPressure0 =>
      'Vedení podezřele ztichlo. To nikdy nevěstí nic dobrého.';

  @override
  String get yBoardPressure1 => 'Prý se v kancelářích začaly klást otázky. ';

  @override
  String get yBoardPressure2 => 'Je cítit, že se na svazu něco hýbe.';

  @override
  String get yBoardPressure3 =>
      'Nikdo ve svazu neřekne jediné podporující slovo. Vyvoďte si z toho své.';

  @override
  String get yBoardPressure4 => 'Nahoře ho na veřejnosti nepodpořili už týdny.';

  @override
  String get yBoardPressure5 =>
      'Svaz podává informace proti vlastnímu trenérovi. Jako vždycky.';

  @override
  String get yBoardPressure6 => 'Když vedení ztichne, už je rozhodnuto.';

  @override
  String get yBoardPressure7 =>
      'Nechají to plavat, dokud to nebude rozhodnutí někoho jiného.';

  @override
  String get yReplies => 'TAKÉ K TOMUTO ZÁPASU';

  @override
  String get yPlayerGrievance0 =>
      'Zeptal jsem se, na čem jsem. Pořád čekám na odpověď.';

  @override
  String get yPlayerGrievance1 => 'Trénuju naplno. Víc dělat nemůžu.';

  @override
  String get yPlayerGrievance2 => 'Na některé otázky se ptáš jen jednou.';

  @override
  String get yPlayerGrievance3 =>
      'Nedošel jsem takhle daleko, abych nosil rozlišováky.';

  @override
  String get playerHonoursTitle => 'TROFEJE';

  @override
  String get awardGoldenBall => 'Zlatý míč';

  @override
  String get awardGoldenBoot => 'Zlatá kopačka';

  @override
  String get awardGoldenGlove => 'Zlatá rukavice';

  @override
  String get awardTeamOfTournament => 'Sestava turnaje';

  @override
  String get awardPlayerOfYear => 'Nejlepší hráč světa';

  @override
  String get awardYoungPlayerOfYear => 'Nejlepší mladý hráč';

  @override
  String get playerClubHistory => 'KLUBOVÁ HISTORIE';

  @override
  String get playerCareerRecord => 'KARIÉRNÍ BILANCE';

  @override
  String get playerInternationalGoals => 'Góly za reprezentaci';

  @override
  String get playerRecentForm => 'AKTUÁLNÍ FORMA';

  @override
  String get playerMatchHistory => 'HISTORIE ZÁPASŮ';

  @override
  String get playerAttributes => 'ATRIBUTY';

  @override
  String get playerUnknown => 'Neznámý';

  @override
  String get playerAttrPace => 'Rychlost';

  @override
  String get playerAttrPhysical => 'Fyzička';

  @override
  String get playerAttrTechnical => 'Technika';

  @override
  String get playerAttrShooting => 'Střelba';

  @override
  String get playerAttrPassing => 'Přihrávky';

  @override
  String get playerAttrDribbling => 'Dribling';

  @override
  String get playerAttrTackling => 'Odebírání';

  @override
  String get playerAttrPositioning => 'Postavení';

  @override
  String get playerAttrComposure => 'Klid';

  @override
  String get playerAttrDecisions => 'Rozhodování';

  @override
  String get playerAttrStamina => 'Výdrž';

  @override
  String get playerAttrStrength => 'Síla';

  @override
  String get playerStatCaps => 'Starty';

  @override
  String get playerStatGoals => 'Góly';

  @override
  String get playerStatAssists => 'Asistence';

  @override
  String get playerStatAvgRating => 'Prům. známka';

  @override
  String get playerStatForm => 'Forma';

  @override
  String get playerStatMotm => 'Hráč zápasu';

  @override
  String get playerStatCleanSheets => 'Čistá konta';

  @override
  String get playerStatBestGame => 'Nejlepší zápas';

  @override
  String get playerStatCards => 'Karty';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '$yellowsŽ $redsČ';
  }

  @override
  String get tourSharedYourRun => 'VAŠE CESTA';

  @override
  String get tourSharedList => 'Seznam';

  @override
  String get tourSharedBracket => 'Pavouk';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Skupina $seed';
  }

  @override
  String get tourSharedThisEdition => 'Tento ročník';

  @override
  String get tourSharedAllTime => 'Historie';

  @override
  String get tourSharedUnknown => 'Neznámý';

  @override
  String get tourSharedActive => 'AKTIVNÍ';

  @override
  String get tourSharedMedalTable => 'MEDAILOVÉ POŘADÍ';

  @override
  String get tourSharedPastWinners => 'MINULÍ VÍTĚZOVÉ';

  @override
  String tourSharedHost(String host) {
    return 'Pořadatel: $host';
  }

  @override
  String get tourSharedBeat => 'porazil';

  @override
  String get tourSharedPens => ' (pen.)';

  @override
  String get tourSharedAwardsEmpty => 'Ocenění se udělují po odehrání turnaje.';

  @override
  String get tourSharedGoldenBall => 'ZLATÝ MÍČ';

  @override
  String get tourSharedPlayerOfTournament => 'Hráč turnaje';

  @override
  String get tourSharedGoldenBoot => 'ZLATÁ KOPAČKA';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gólů',
      many: '$count gólu',
      few: '$count góly',
      one: '1 gól',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'ZLATÁ RUKAVICE';

  @override
  String get tourSharedTeamOfTournament => 'JEDENÁCTKA TURNAJE';

  @override
  String get tourSharedStatsEmpty =>
      'Rekordy se objeví, jakmile má soutěž nějakou historii.';

  @override
  String get tourSharedRecordScorer => 'REKORDNÍ STŘELEC';

  @override
  String get tourSharedStillActive => 'stále aktivní';

  @override
  String get tourSharedMostTitles => 'NEJVÍCE TITULŮ';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titulů',
      many: '$count titulu',
      few: '$count tituly',
      one: '1 titul',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'NEJVÍCE FINÁLE';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count odehraných finále',
      many: '$count odehraného finále',
      few: '$count odehraná finále',
      one: '1 odehrané finále',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'NEJVÍCE ODEHRANÝCH ZÁPASŮ';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      many: '$count zápasu',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'NEJVÍCE ODEHRANÝCH TURNAJŮ';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finálových turnajů',
      many: '$count finálového turnaje',
      few: '$count finálové turnaje',
      one: '1 finálový turnaj',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'NEJVYŠŠÍ VÝHRA VE FINÁLE';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gólů',
      few: '$count góly',
      one: '1 gól',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'stále aktivní';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titulů',
      few: '$count tituly',
      one: '1 titul',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finále',
      one: '1 finále',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnajů',
      few: '$count turnaje',
      one: '1 turnaj',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'HISTORICKÉ TABULKY';

  @override
  String get tourStatsTabGames => 'Zápasy';

  @override
  String get tourStatsTabCups => 'Turnaje';

  @override
  String get tourStatsTabScorers => 'Střelci';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 's $opponent · $year';
  }

  @override
  String get tourHolders => 'OBHÁJCE';

  @override
  String tourHoldersSince(int year) {
    return 'od $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'NEJLEPŠÍ STŘELCI HISTORIE';

  @override
  String get tourSharedSummaryEmpty =>
      'Pořadatel a jeho stadiony se objeví po vylosování ročníku.';

  @override
  String get tourSharedHostHeading => 'POŘADATEL';

  @override
  String get tourSharedHostsHeading => 'POŘADATELÉ';

  @override
  String get tourSharedCoHostsHeading => 'SPOLUPOŘADATELÉ';

  @override
  String get tourSharedVenues => 'STADIONY';

  @override
  String get tourSharedMascot => 'MASKOT';

  @override
  String get tourSharedMatchBall => 'MÍČ TURNAJE';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity míst';
  }

  @override
  String get tourSharedCouldNotLoad => 'Nepodařilo se načíst.';

  @override
  String get tourSharedHostTbc => 'POŘADATEL BUDE POTVRZEN';

  @override
  String get tourSharedFinalsAreHere => 'FINÁLOVÝ TURNAJ ZAČÍNÁ';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'POŘÁDÁ  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Ať finále začne';

  @override
  String get tourSharedCompetitions => 'SOUTĚŽE';

  @override
  String get tourSharedWorldRanking => 'Světový žebříček';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Nepodařilo se načíst turnaje.';

  @override
  String get tourSharedPrestigeStage => 'PRESTIŽNÍ FÁZE';

  @override
  String get tourSharedOverview => 'Přehled';

  @override
  String get tourSharedWorldRankingTitle => 'Světový žebříček';

  @override
  String get tourSharedYourCompetitions => 'VAŠE SOUTĚŽE';

  @override
  String get tourSharedOtherContinents => 'OSTATNÍ KONTINENTY';

  @override
  String get tourSharedComingSoon => 'Turnaj již brzy';

  @override
  String get tourSharedSoon => 'BRZY';

  @override
  String get tourSharedNoQualifyingDraw => 'Žádný kvalifikační los.';

  @override
  String get tourSharedOpenEnvelope => 'Otevřít obálku';

  @override
  String tourSharedGroupName(String name) {
    return 'SKUPINA $name';
  }

  @override
  String get tourSharedBall => 'Míč';

  @override
  String get tourSharedPot => 'Koš';

  @override
  String get tourSharedAll => 'Vše';

  @override
  String get tourSharedTapDrawTeam => 'Klepnutím vylosujete další tým';

  @override
  String get tourSharedTapDrawPot => 'Klepnutím vylosujete další koš';

  @override
  String get tourSharedTapDrawAll => 'Klepnutím odhalíte celý los';

  @override
  String get tourSharedContinue => 'Pokračovat';

  @override
  String get tourSharedPause => 'Pozastavit';

  @override
  String get tourSharedPlay => 'Přehrát';

  @override
  String get tourSharedSkip => 'Přeskočit';

  @override
  String tourSharedPotNumber(int number) {
    return 'KOŠ $number';
  }

  @override
  String get tourSharedDrawComplete => 'LOS DOKONČEN';

  @override
  String get tourSharedDrawing => 'LOSOVÁNÍ…';

  @override
  String get tourContChampionship => 'ŠAMPIONÁT';

  @override
  String get tourContTabSummary => 'PŘEHLED';

  @override
  String get tourContTabQualifying => 'KVALIFIKACE';

  @override
  String get tourContTabFinals => 'FINÁLOVÝ TURNAJ';

  @override
  String get tourContTabBracket => 'PAVOUK';

  @override
  String get tourContTabAwards => 'OCENĚNÍ';

  @override
  String get tourContTabScorers => 'STŘELCI';

  @override
  String get tourContTabHistory => 'HISTORIE';

  @override
  String get tourContTabRecords => 'REKORDY';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Nepodařilo se načíst pohár.\n$error';
  }

  @override
  String get tourContNoCupData => 'Žádná data o poháru.';

  @override
  String get tourContUnknown => 'Neznámý';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Kvalifikační skupiny se losují při ceremoniálu. Sledujte z rozcestníku, koho dostanete.';

  @override
  String get tourContQualSeeded =>
      'Váš národ postupuje přímo do finálového turnaje. V tomto cyklu se nehraje kvalifikace.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name se simuluje na pozadí. Výsledky se zde objeví po odehrání každého kola.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Skupiny finálového turnaje se losují při ceremoniálu. Sledujte z rozcestníku svou skupinu.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Los finálového turnaje proběhne po skončení kvalifikace.';

  @override
  String get tourContContestedBeforeWc =>
      'Vyřazovací fáze se odehraje před mistrovstvím světa.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name: ŠAMPIONI';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'vítězové soutěže $name';
  }

  @override
  String get tourContNoGoalsYet => 'Zatím nepadl žádný gól.';

  @override
  String tourContGroupHeading(String name) {
    return 'SKUPINA $name';
  }

  @override
  String get tourContBestRunnersUp => 'NEJLEPŠÍ DRUHÁ MÍSTA';

  @override
  String tourContGroupDropdown(String name) {
    return 'Skupina $name';
  }

  @override
  String get tourContMatches => 'ZÁPASY';

  @override
  String get tourContNoGroupsDrawn => 'Zatím nebyly vylosovány žádné skupiny.';

  @override
  String get tourContQualifyingDraw => 'LOS KVALIFIKACE';

  @override
  String get tourContWorldQualifyingDraw => 'LOS SVĚTOVÉ KVALIFIKACE';

  @override
  String get tourContFinalsDraw => 'LOS FINÁLOVÉHO TURNAJE';

  @override
  String get tourContSeedingPots => 'NASAZOVACÍ KOŠE';

  @override
  String get tourContGroupDraw => 'LOS SKUPIN';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Nepodařilo se načíst los.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Los zatím není připraven.';

  @override
  String get tourContContinentalClash => 'SOUBOJ KONTINENTŮ';

  @override
  String get tourContTabThisCycle => 'TENTO CYKLUS';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Nepodařilo se načíst.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Uložená hra nenalezena.';

  @override
  String get tourContClashSoon =>
      'Souboj kontinentů se hraje, jakmile jsou známi oba kontinentální šampioni.';

  @override
  String get tourContTwoContinentsOneMatch => 'DVA KONTINENTY, JEDEN ZÁPAS';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name vyhrává Souboj kontinentů';
  }

  @override
  String get tourContNoClashYet =>
      'Zatím se neodehrál žádný Souboj kontinentů.';

  @override
  String get tourContNationsCup => 'POHÁR NÁRODŮ';

  @override
  String get tourContTabLeagues => 'LIGY';

  @override
  String get tourContTabFinalsFour => 'FINÁLOVÁ ČTYŘKA';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Nepodařilo se načíst.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Zatím nebyly zaznamenány žádné góly Poháru národů.';

  @override
  String get tourContNoNationsCupChampions =>
      'Zatím nebyl korunován žádný vítěz Poháru národů.';

  @override
  String get tourContNationsCupOffSeason =>
      'Pohár národů tohoto cyklu začíná po kontinentálních šampionátech. Dřívější vítězové jsou v sekci Historie.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Skupiny Poháru národů se v tomto cyklu losují při ceremoniálu. Sledujte z rozcestníku, koho dostanete.';

  @override
  String get tourContLeagueNoGroups => 'V této lize se toto kolo nehraje.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LIGA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LIGA $letter · VAŠE LIGA';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Finálovou čtyřku hrají vítězové skupin Ligy A po skončení skupinové fáze.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Liga $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Liga $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEMIFINÁLE';

  @override
  String get tourContFinal => 'FINÁLE';

  @override
  String get tourContNationsCupDraw => 'LOS POHÁRU NÁRODŮ';

  @override
  String get tourContIntercontinentalPlayoff => 'MEZIKONTINENTÁLNÍ BARÁŽ';

  @override
  String get tourContNoPlayoffThisCycle => 'V tomto cyklu se baráž nehraje.';

  @override
  String get tourContPlayoffIntro =>
      'O dvě místa na mistrovství světa rozhodne vyřazovací pavouk nejlepších týmů, které v kvalifikaci těsně nepostoupily.';

  @override
  String get tourContPlayoffThrough =>
      'Prošli jste baráží. Jedete na mistrovství světa!';

  @override
  String get tourContPlayoffOut =>
      'V baráži jste nestačili. Mistrovství světa tentokrát nebude.';

  @override
  String get tourContContinue => 'Pokračovat';

  @override
  String get tourContPlayoffFinals => 'FINÁLE BARÁŽE';

  @override
  String get tourContPlayoffSeeded => 'Nasazen (volný los)';

  @override
  String get tourCupTabSummary => 'PŘEHLED';

  @override
  String get tourCupTabQualifying => 'KVALIFIKACE';

  @override
  String get tourCupTabPlayoff => 'BARÁŽ';

  @override
  String get tourCupPlayoffSoon =>
      'Mezikontinentální baráž se rozhodne, jakmile skončí kvalifikace ve všech konfederacích.';

  @override
  String get tourCupTabFinals => 'FINÁLOVÝ TURNAJ';

  @override
  String get tourCupTabBracket => 'PAVOUK';

  @override
  String get tourCupTabAwards => 'OCENĚNÍ';

  @override
  String get tourCupTabScorers => 'STŘELCI';

  @override
  String get tourCupTabHistory => 'HISTORIE';

  @override
  String get tourCupTabRecords => 'REKORDY';

  @override
  String get tourCupTitle => 'MISTROVSTVÍ SVĚTA';

  @override
  String get tourCupNoData => 'Žádná data o turnaji.';

  @override
  String tourCupLoadError(String error) {
    return 'Nepodařilo se načíst turnaj.\n$error';
  }

  @override
  String get tourCupUnknown => 'Neznámý';

  @override
  String get tourCupWorldChampions => 'MISTŘI SVĚTA';

  @override
  String get tourCupWorldChampionsTitle => 'Mistři světa';

  @override
  String get tourCupStillActive => 'Stále aktivní';

  @override
  String get tourCupAllTimeScorers => 'STŘELCI HISTORIE';

  @override
  String get tourCupAllConfederations => 'Všechny konfederace';

  @override
  String get tourCupBestRunnersUp => 'Nejlepší týmy na druhých místech';

  @override
  String get tourCupCompWorld => 'Mistrovství světa';

  @override
  String get tourCupCompEurope => 'Mistrovství Evropy';

  @override
  String get tourCupCompSAmerica => 'Pohár Jižní Ameriky';

  @override
  String get tourCupDestRoundOf16 => 'osmifinále';

  @override
  String get tourCupDestKnockouts => 'vyřazovací části';

  @override
  String get tourCupDestFinals => 'finálového turnaje';

  @override
  String get tourCupDestFinalsPlayoff => 'finálové baráže';

  @override
  String get tourCupDestIntercontPlayoff => 'mezikontinentální baráže';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Finálový turnaj se losuje po skončení kvalifikace.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Skupiny budou vylosovány. Sledujte los MS z rozcestníku.';

  @override
  String tourCupGroupName(String name) {
    return 'Skupina $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Skupina $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Pořádá $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Pořádají $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Mezikontinentální baráž';

  @override
  String get tourCupKnockoutSoon => 'Pavouk začíná po skončení skupinové fáze.';

  @override
  String get tourCupMatches => 'ZÁPASY';

  @override
  String get tourCupMedalTable => 'MEDAILOVÉ POŘADÍ';

  @override
  String get tourCupMostTitles => 'NEJVÍCE TITULŮ';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    String _temp0 = intl.Intl.pluralLogic(
      titles,
      locale: localeName,
      other: '$titles titulů',
      few: '$titles tituly',
      one: '1 titul',
    );
    String _temp1 = intl.Intl.pluralLogic(
      editions,
      locale: localeName,
      other: '$editions ročníků',
      few: '$editions ročníky',
      one: '1 ročník',
    );
    return '$nation: $_temp0 za $_temp1';
  }

  @override
  String get tourCupNoGoals => 'Zatím žádné góly.';

  @override
  String get tourCupNoGroups => 'Žádné skupiny nebyly vylosovány.';

  @override
  String get tourCupNoHistory => 'Zatím žádná historie.';

  @override
  String get tourCupPastWinners => 'MINULÍ VÍTĚZOVÉ';

  @override
  String get tourCupPlayoffIntro =>
      'Dvě místa na MS se rozhodnou v play-off nejlepších týmů z kvalifikace.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation nehraje baráž: o všech jejích místech rozhodnou kvalifikační skupiny.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Skupiny budou vylosovány. Sledujte los kvalifikace z rozcestníku.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · vaše';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (pen.)';
  }

  @override
  String get tourCupSegAllTime => 'Historie';

  @override
  String get tourCupSegFinals => 'Finálový turnaj';

  @override
  String get tourCupSegQualifying => 'Kvalifikace';

  @override
  String get playerTraitsTitle => 'ZNÁMÝ PRO';

  @override
  String get traitBigGame => 'Hráč na velké zápasy';

  @override
  String get traitBigGameBlurb => 'Ve vyřazovacích zápasech zvedne svou hru.';

  @override
  String get traitSetPiece => 'Specialista na standardky';

  @override
  String get traitSetPieceBlurb => 'Lepší centry a více gólů ze standardek.';

  @override
  String get traitHothead => 'Vznětlivý';

  @override
  String get traitHotheadBlurb => 'Sbírá výrazně více karet než spoluhráči.';

  @override
  String get traitIronMan => 'Železný muž';

  @override
  String get traitIronManBlurb => 'Málokdy se zraní a pomaleji se unaví.';

  @override
  String get traitWonderkid => 'Zázračné dítě';

  @override
  String get traitWonderkidBlurb => 'Mladý, už dobrý a rychle se zlepšuje.';

  @override
  String get traitLeader => 'Vůdce';

  @override
  String get traitLeaderBlurb => 'Zvedá výkon všech spoluhráčů na hřišti.';

  @override
  String get traitPacey => 'Rychlík';

  @override
  String get traitPaceyBlurb => 'Extrémní rychlost, hrozba za obranou.';

  @override
  String get traitOldHead => 'Zkušený matador';

  @override
  String get traitOldHeadBlurb => 'Veterán, jehož čtení hry přežilo jeho nohy.';

  @override
  String get traitWasteful => 'Zahazovač';

  @override
  String get traitWastefulBlurb => 'Zahazuje příliš mnoho dobrých šancí.';

  @override
  String get objectiveWorldCup => 'Mistrovství světa';

  @override
  String get objectiveWinTournament => 'Vyhrát turnaj';

  @override
  String get objectiveQualifyGeneric => 'Postoupit na turnaj';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Vyhrát mistrovství světa';

  @override
  String get objectiveReachFinal => 'Postoupit do finále';

  @override
  String get objectiveReachSemis => 'Postoupit do semifinále';

  @override
  String get objectiveReachQuarters => 'Postoupit do čtvrtfinále';

  @override
  String get objectiveReachKnockouts => 'Postoupit do vyřazovací fáze';

  @override
  String get objectiveQualify => 'Postoupit na mistrovství světa';

  @override
  String get finishChampions => 'Mistři';

  @override
  String get finishRunnersUp => 'Finalisté';

  @override
  String get finishSemiFinals => 'Semifinále';

  @override
  String get finishQuarterFinals => 'Čtvrtfinále';

  @override
  String get finishRoundOf16 => 'Osmifinále';

  @override
  String get finishGroupStage => 'Skupinová fáze';

  @override
  String get objectiveQualifyingTopHalf =>
      'Skončit v horní polovině kvalifikační skupiny';

  @override
  String get objectiveQualifyingChallenge =>
      'Bojovat o postup, minimálně horní polovina kvalifikační skupiny';

  @override
  String get finishQualifyingTopHalf => 'Horní polovina kvalifikační skupiny';

  @override
  String get finishQualifyingBottomHalf =>
      'Spodní polovina kvalifikační skupiny';

  @override
  String get objectiveNcWinIt => 'Vyhrát Pohár národů';

  @override
  String get objectiveNcReachFinal => 'Postoupit do finále Poháru národů';

  @override
  String get objectiveNcFinalsFour => 'Postoupit do Final Four';

  @override
  String get objectiveNcWinGroup => 'Vyhrát skupinu a postoupit výš';

  @override
  String get objectiveNcTopHalf => 'Skončit v horní polovině skupiny';

  @override
  String get objectiveNcSurvive => 'Vyhnout se sestupu';

  @override
  String get objectiveNcOffTheBottom => 'Neskončit ve skupině poslední';

  @override
  String get finishNcChampions => 'Vítězové Poháru národů';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Vítězové skupiny';

  @override
  String get finishNcTopHalf => 'Horní polovina skupiny';

  @override
  String get finishNcStayedUp => 'Udrželi se';

  @override
  String get finishNcClearOfBottom => 'Ne poslední ve skupině';

  @override
  String get finishNcBottom => 'Poslední ve skupině';

  @override
  String get careerNationsCupLabel => 'Pohár národů';

  @override
  String get squadDevPlayer => 'HRÁČ';

  @override
  String get squadDevAge => 'VĚK';

  @override
  String get squadDevPosition => 'POST';

  @override
  String get squadDevChange => 'RATING';

  @override
  String get squadDevNew => 'NOVÝ';

  @override
  String get squadDevRetired => 'KONEC';

  @override
  String get squadDevEmpty => 'Klidný rok. V kádru beze změn.';

  @override
  String get squadDevTierRegulars => 'ZÁKLADNÍ KÁDR';

  @override
  String get squadDevTierFringe => 'ŠIRŠÍ KÁDR';

  @override
  String get squadDevTierYouth => 'MLÁDEŽ';

  @override
  String get boardObjectivesTitle => 'Cíle vedení';

  @override
  String get boardObjectivesConfidence => 'Důvěra vedení';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'o $rounds kol lepší, než se čekalo',
      few: 'o $rounds kola lepší, než se čekalo',
      one: 'o kolo lepší, než se čekalo',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'o $rounds kol méně',
      few: 'o $rounds kola méně',
      one: 'o kolo méně',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'JEŠTĚ SE ROZHODNE';

  @override
  String boardObjectiveSoFar(String result) {
    return 'ZATÍM · $result';
  }

  @override
  String get boardObjectivesEmpty => 'Vedení pro tento cyklus nestanovilo cíl.';

  @override
  String get tourContBestWinners => 'NEJLEPŠÍ VÍTĚZOVÉ SKUPIN';

  @override
  String get tourContBestThirds => 'NEJLEPŠÍ TŘETÍ';

  @override
  String tourContBestPlaced(String position) {
    return 'NEJLEPŠÍ NA $position. MÍSTĚ';
  }

  @override
  String squadDevPageOf(String page, String pages, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total hráčů',
      few: '$total hráči',
      one: '1 hráč',
    );
    return '$page/$pages · $_temp0';
  }

  @override
  String get matchSoldOut => 'VYPRODÁNO';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance z $capacity míst zaplněno';
  }

  @override
  String get matchGroundTitle => 'STADION';

  @override
  String get absenceInjured => 'Zraněn';

  @override
  String get absenceSuspended => 'Stop';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString týdnů',
      few: '$countString týdny',
      one: '1 týden',
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
      other: '$countString zápasů',
      few: '$countString zápasy',
      one: '1 zápas',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Zpět na zápas s $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Penalty';

  @override
  String get penaltyOrderBlurb =>
      'Určete pět exekutorů v pořadí. Klepnutím pozici změníte.';

  @override
  String penaltyOrderPick(int number) {
    return '$number. penalta';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Vyberte, kdo půjde. Pruh ukazuje klid na puntíku.';

  @override
  String get penaltyOrderConfirm => 'Jdeme na to';

  @override
  String get penaltyOrderCancel => 'Zpět';

  @override
  String get youthTitle => 'Mládež';

  @override
  String get youthEmptyLevel => 'Na této úrovni zatím nikdo není.';

  @override
  String get youthReleased => 'Letos uvolněni';

  @override
  String get u21Title => 'Do 21 let';

  @override
  String get u21Blurb =>
      'Nová generace, nejlepší talenty nahoře. Prázdné hvězdy jsou odhad skauta. Teprve start v reprezentaci ukáže pravdu.';

  @override
  String get u21Empty =>
      'V kádru teď není nikdo do 21 let. Další ročník přijde s novým cyklem.';

  @override
  String u21Breakout(int gain) {
    return '+$gain ZA ROK';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps startů',
      few: '$caps starty',
      one: '1 start',
    );
    return 'Věk $age · $_temp0';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Věk $age · bez startu';
  }

  @override
  String get u21CallUps => 'Na nominaci';

  @override
  String get youthWatching => 'Sledovaní';

  @override
  String get youthWatchEmpty =>
      'Zatím nikdo. Označte kluka na kterékoli úrovni a objeví se tady, i s tím, co z něj od té doby vyrostlo.';

  @override
  String get youthWatchMark => 'Začít sledovat';

  @override
  String get youthWatchUnmark => 'Přestat sledovat';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Označen na $rating ve věku $age';
  }

  @override
  String get youthWatchSenior => 'Prošel do A-kádru';

  @override
  String get youthWatchReleased => 'Akademie ho uvolnila';

  @override
  String get youthWatchGone => 'Už není v akademii';

  @override
  String get tacticsYouth => 'Do 21 let';

  @override
  String get pressSquad => 'Kabina';

  @override
  String get pressBoard => 'Vedení';

  @override
  String get pressNoEffect => 'Nikdo v tom nic nehledá';

  @override
  String get matchNeutralGround => 'NEUTRÁLNÍ';

  @override
  String get matchExtraTimeAhead => 'PRODLOUŽENÍ';

  @override
  String get matchExtraTimeHalf => 'PRODLOUŽENÍ · POLOČAS';

  @override
  String get matchClockFullTime => 'KONEC';

  @override
  String get matchClockAfterExtraTime => 'PO PRODLOUŽENÍ';

  @override
  String get matchClockPenalties => 'PENALTY';

  @override
  String get matchClockFullTimePenalties => 'KONEC · PENALTY';

  @override
  String get hubEventPressConference => 'Předstoupit před novináře';

  @override
  String get hubEventPressConferenceSub =>
      'Světová média chtějí slovo před dalším zápasem';

  @override
  String get squadDevWonderkid => 'TALENT';

  @override
  String get tacticsPlaystyle => 'Herní styl';

  @override
  String get tacticsPlaystyleBlurb =>
      'Vyberte, jak tým hraje; posuvníky níže styl doladí.';

  @override
  String get tacticsPlaystyleCustom =>
      'Vlastní nastavení. Žádný pojmenovaný styl neodpovídá.';

  @override
  String get playstyleCustom => 'Vlastní';

  @override
  String get playstyleBalanced => 'Vyvážený';

  @override
  String get playstylePossession => 'Držení míče';

  @override
  String get playstyleGegenpress => 'Gegenpressing';

  @override
  String get playstyleCounter => 'Brejky';

  @override
  String get playstyleDirect => 'Přímočarý';

  @override
  String get playstyleLowBlock => 'Nízký blok';

  @override
  String get playstyleWingPlay => 'Hra po křídlech';

  @override
  String get playstyleBalancedBlurb =>
      'Pevní v obou polovinách, nic přehnaného.';

  @override
  String get playstylePossessionBlurb =>
      'Držte míč, trpělivě jej rozehrávejte, stlačte hřiště.';

  @override
  String get playstyleGegenpressBlurb =>
      'Získejte míč hned po ztrátě, vysoko na hřišti.';

  @override
  String get playstyleCounterBlurb =>
      'Zatáhněte se, buďte kompaktní a vyrážejte rychle.';

  @override
  String get playstyleDirectBlurb => 'Rychle dopředu a hra na druhé míče.';

  @override
  String get playstyleLowBlockBlurb => 'Hluboko, úzce a téměř neprostupně.';

  @override
  String get playstyleWingPlayBlurb =>
      'Roztáhněte hřiště, obejděte to po stranách a centrujte.';

  @override
  String get nationsRandomTeam => 'Náhodný tým';

  @override
  String get nationsFromTheBottom => 'Od úplného dna';

  @override
  String get bottomStartTitle => 'Bez angažmá';

  @override
  String get bottomStartHeading => 'Tři federace mají zájem';

  @override
  String get bottomStartBlurb =>
      'Nemáte práci ani jméno. Tohle jsou jediné země, kde se o vás zajímají. Vezměte jednu z nabídek a vybudujte něco z ničeho.';

  @override
  String get bottomStartAccept => 'Beru';

  @override
  String get bottomStartBack => 'Zpět do nabídky';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank. z $total na světě';
  }

  @override
  String get campTitle => 'Základní tábor';

  @override
  String campBasedIn(String host) {
    return 'Sídlo v zemi $host';
  }

  @override
  String get campBlurb =>
      'Kde tým bydlí po celý turnaj. Po začátku už to nejde změnit a působí to na tři věci v každém zápase: jak svěží přijedou, jak rychle se hojí zranění a jak jsou sehraní.';

  @override
  String get campEffectTravel => 'Svěžest na zápas';

  @override
  String get campEffectRecovery => 'Hojení zranění';

  @override
  String get campEffectSharpness => 'Sehranost';

  @override
  String get campTerrainCity => 'Centrum města';

  @override
  String get campTerrainCoastal => 'Letovisko u moře';

  @override
  String get campTerrainMountain => 'Horské útočiště';

  @override
  String get campTerrainAltitude => 'Výškový kemp';

  @override
  String get campTerrainNationalCentre => 'Národní centrum';

  @override
  String get campTerrainCityBlurb =>
      'Vše po ruce a nikam se necestuje, ale žádný klid a žádný únik před ruchem.';

  @override
  String get campTerrainCoastalBlurb =>
      'Klid, pohodlí a dobrá nálada; ke každému stadionu dlouhá cesta autobusem.';

  @override
  String get campTerrainMountainBlurb =>
      'Chladný vzduch a špičkové zdravotní zázemí, které rychle vyřeší zranění, ale daleko od turnaje.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Náročné tréninky a nohy, které vydrží až do konce turnaje.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Vlastní zázemí federace: nic okázalého, nic, co by se pokazilo.';

  @override
  String get hubEventChooseCamp => 'Vybrat základní tábor';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Kde bude tým sídlit v zemi $host';
  }

  @override
  String get tacticsTabBench => 'Lavička';

  @override
  String get squadSearchHint => 'Jméno nebo klub';

  @override
  String get squadFilterAll => 'Všichni';

  @override
  String get squadFilterInSquad => 'V nominaci';

  @override
  String get squadFilterUncapped => 'Bez startu';

  @override
  String get squadFilterUnavailable => 'Nedostupní';

  @override
  String get squadLineAll => 'Všechny řady';

  @override
  String get squadSortBy => 'Řadit';

  @override
  String get squadSortRating => 'Hodnocení';

  @override
  String get squadSortCaps => 'Starty';

  @override
  String get squadSortGoals => 'Góly';

  @override
  String get squadSortAge => 'Věk';

  @override
  String get squadSortName => 'Jméno';

  @override
  String get squadLegendTitle => 'Co znamenají značky';

  @override
  String get squadLegendStarting => 'V základní sestavě';

  @override
  String get squadLegendCalledUp => 'V nominaci, na lavičce';

  @override
  String get squadLegendRatingUp => 'Rating letos roste';

  @override
  String get squadLegendRatingDown => 'Rating letos klesá';

  @override
  String get squadLegendInjured => 'Zraněný, nemůže hrát';

  @override
  String get squadLegendSuspended => 'Trest, nemůže hrát';

  @override
  String get squadLegendTraits => 'ZNÁMÝ PRO';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Zobrazeno $shown z $total hráčů';
  }

  @override
  String get squadNobodyMatches => 'Danému filtru neodpovídá nikdo.';

  @override
  String get squadStatPool => 'Kádr';

  @override
  String get squadStatInSquad => 'Nominováno';

  @override
  String get squadMostCapped => 'Nejvíc startů';

  @override
  String get squadTopScorer => 'Nejlepší střelec';

  @override
  String squadCapsValue(String name, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps startů',
      few: '$caps starty',
      one: '1 start',
    );
    return '$name · $_temp0';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals gólů',
      few: '$goals góly',
      one: '1 gól',
    );
    return '$name · $_temp0';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Star';

  @override
  String get squadGoalsShort => 'Gól';

  @override
  String get recordsRecordBookSubtitle => 'Starty, góly a klubové rekordy týmu';

  @override
  String get statsLegacy => 'ODKAZ';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name už byl vystřídán a zpátky na hřiště nemůže.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name byl vyloučen a do hry už nezasáhne.';
  }

  @override
  String get tacticsInjuredShort => 'ZRANĚN';

  @override
  String get tacticsSuspendedShort => 'STOPKA';

  @override
  String get confEurope => 'Evropa';

  @override
  String get confSouthAmerica => 'Jižní Amerika';

  @override
  String get confNorthAmerica => 'Severní Amerika';

  @override
  String get confAfrica => 'Afrika';

  @override
  String get confAsia => 'Asie';

  @override
  String get confOceania => 'Oceánie';

  @override
  String get compWorldCup => 'Mistrovství světa';

  @override
  String get compWorldCupFinals => 'Finálový turnaj šampionátu';

  @override
  String get compWorldCupQualifying => 'Kvalifikace: Mistrovství světa';

  @override
  String compQualifiers(String region) {
    return 'Kvalifikace: $region';
  }

  @override
  String get compFriendlies => 'Přátelská utkání';

  @override
  String get compNationsCup => 'Pohár národů';

  @override
  String get compContinentalClash => 'Souboj kontinentů';

  @override
  String get compIntercontinentalPlayoff => 'Mezikontinentální baráž';

  @override
  String get compContinentalChampionship => 'Kontinentální šampionát';

  @override
  String get compEuropeanChampionship => 'Evropský šampionát';

  @override
  String get compSouthAmericaCup => 'Pohár Jižní Ameriky';

  @override
  String get compAfricanChampionship => 'Africký šampionát';

  @override
  String get compAsianChampionship => 'Asijský šampionát';

  @override
  String get compNorthAmericaCup => 'Pohár Severní Ameriky';

  @override
  String get compOceaniaCup => 'Pohár Oceánie';

  @override
  String get msgANation => 'Národní tým';

  @override
  String get msgAPlayer => 'Hráč';

  @override
  String get msgAHostNation => 'pořadatel';

  @override
  String get msgCycleTitle1 => 'Začíná nový cyklus';

  @override
  String msgCycleTitle2(int year) {
    return 'Cesta na MS $year začíná';
  }

  @override
  String get msgCycleTitle3 => 'Svítá nová kampaň';

  @override
  String get msgCycleTitle4 => 'Zpátky do práce';

  @override
  String msgCycleBody1(int year) {
    return 'Cesta na mistrovství světa $year začíná tady.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Nový cyklus. Cílem je mistrovství světa $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Čtyři roky do MS $year. Práce začíná teď.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Kampaň $year začíná dnes.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Pořadatel $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host bude hostit příští $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Los kvalifikace: $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Kvalifikační skupiny turnaje $cup jsou vylosovány.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Pořadatel MS $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host bude hostit mistrovství světa $year.';
  }

  @override
  String get msgWcQualDrawTitle => 'Los kvalifikace MS';

  @override
  String get msgWcQualDrawBody => 'Kvalifikační skupiny MS jsou vylosovány.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Los turnaje $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Skupiny turnaje $cup jsou vylosovány.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'Los MS';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Los mistrovství světa $year je hotový.';
  }

  @override
  String get msgQualWcTitle1 => 'Jedeme na mistrovství světa';

  @override
  String get msgQualWcTitle2 => 'Místo na MS je zajištěné';

  @override
  String get msgQualWcTitle3 => 'Jedeme na MS';

  @override
  String get msgQualWcTitle4 => 'Letenka je orazítkovaná';

  @override
  String msgQualWcBody1(int year) {
    return 'Postoupili jste na mistrovství světa $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Je to oficiální: váš tým je na MS $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Místo na mistrovství světa $year je jisté.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Jste na závěrečném turnaji MS $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Postup na $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup je zajištěné';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Kvalifikace na $cup zvládnuta';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Postoupili jste na turnaj $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Váš tým si zajistil místo na turnaji $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Jste na turnaji $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: JSME MISTŘI!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Mistři turnaje $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Vyhráli jste $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp zná vítěze';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'Mistr turnaje $comp je znám';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp má svého vítěze';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Váš tým je mistrem turnaje $comp $year po výhře nad $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Vyhráli jste $comp $year, $loser nestačilo$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year je vaše. $loser poraženo$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner vyhrálo $comp $year po výhře nad $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner je mistrem turnaje $comp $year, ve finále porazilo $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home:$away ve finále';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' na penalty po remíze $home:$away ve finále';
  }

  @override
  String get msgWpotyTitle => 'Světový hráč roku';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) je světovým hráčem roku $year, a je váš.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) je světovým hráčem roku $year.';
  }

  @override
  String get msgYpotTitle => 'Nejlepší mladý hráč turnaje';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age let, je nejlepším mladým hráčem turnaje $year, a je váš.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age let, je nejlepším mladým hráčem turnaje $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Držíte se na #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Beze změny, stále #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabilně na #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move míst',
      few: '$move místa',
      one: '1 místo',
    );
    return 'Celkem postup o $_temp0, na #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move míst',
      few: '$move místa',
      one: '1 místo',
    );
    return 'Skok o $_temp0 vás posouvá na #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move míst',
      few: '$move místa',
      one: '1 místo',
    );
    return 'Nahoru o $_temp0, teď #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move míst',
      few: '$move místa',
      one: '1 místo',
    );
    return 'Celkem pád o $_temp0, na #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move míst',
      few: '$move místa',
      one: '1 místo',
    );
    return 'Propad o $_temp0 vás sráží na #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move míst',
      few: '$move místa',
      one: '1 místo',
    );
    return 'Dolů o $_temp0, teď #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Vedete světový žebříček.';

  @override
  String msgRankLeadOther(String nation) {
    return 'V čele světa je $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Světový žebříček · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Světový žebříček byl aktualizován. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Skok na #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Propad na #$rank';
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
      other: '$move míst',
      few: '$move místa',
      one: '1 místo',
    );
    return '$tournament zamíchalo světovým žebříčkem. $nation do něj šli z #$from a vycházejí na #$to, tedy skok o $_temp0.';
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
      other: '$move míst',
      few: '$move místa',
      one: '1 místo',
    );
    return '$tournament zamíchalo světovým žebříčkem. $nation do něj šli z #$from a vycházejí na #$to, tedy propad o $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Od losu mistrovství světa';

  @override
  String get rankingSinceCycleStart => 'Od začátku kampaně';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from na #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count startů',
      few: '$count starty',
      one: '1 start',
    );
    return '$name má $_temp0';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name nastoupil za váš tým už ${count}krát.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gólů',
      few: '$count góly',
      one: '1 gól',
    );
    return '$name má $_temp0';
  }

  @override
  String msgGoalsBody(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reprezentačních gólů',
      few: '$count reprezentační góly',
      one: '1 reprezentační gól',
    );
    return '$name vstřelil za váš tým $_temp0.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Vývoj kádru · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Z akademie do áčka · $year';
  }

  @override
  String get msgThroughNote =>
      'Nejde o nový nábor. Jsou to kluci, kteří přišli v jedenácti a teď dorostli do seniorského kádru.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Nové tváře · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Investice do akademie se projevuje: tenhle nábor přišel silnější, než by přišel.';

  @override
  String get msgIntakeNoteStanding =>
      'Země tenhle tým sleduje: jak reprezentace stoupá světovým žebříčkem, nejlepší kluci si vybírají fotbal a nábor je díky tomu silnější.';

  @override
  String get msgIntakeNoteBoth =>
      'Peníze do akademie i vzestup reprezentace ve světovém žebříčku se oboje projevují: tenhle nábor přišel silnější, než by přišel.';

  @override
  String msgIntakeTitle(int year) {
    return 'Nábor akademie · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Kapitán $name končí';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name končí v reprezentaci';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name ukončil reprezentační kariéru ve $age letech.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name ukončil reprezentační kariéru ve $age letech s bilancí $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count startů',
      few: '$count starty',
      one: '1 start',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gólů',
      few: '$count góly',
      one: '1 gól',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Kapitánská páska je volná. Nového kapitána jmenujte na obrazovce nominace.';

  @override
  String msgHofTitle(String name) {
    return '$name uveden do Síně slávy';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps startů',
      few: '$caps starty',
      one: '1 start',
    );
    String _temp1 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals gólů',
      few: '$goals góly',
      one: '1 gól',
    );
    return '$name vstupuje do Síně slávy vašeho týmu ($_temp0, $_temp1). Najdete ho mezi Legendami.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name má stopku';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'příštích $matches zápasů',
      few: 'příští $matches zápasy',
      one: 'příští zápas',
    );
    return '$name $how a má stop na $_temp0. Nebude k dispozici.';
  }

  @override
  String get hubBanHowSecondYellow => 'byl vyloučen po druhé žluté kartě';

  @override
  String get hubBanHowViolent => 'dostal přímou červenou za surovou hru';

  @override
  String get hubBanHowRed => 'byl vyloučen';

  @override
  String hubInjuryTitle(String name) {
    return '$name je zraněný';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches zápasů',
      few: '$matches zápasy',
      one: '1 zápas',
    );
    return '$name se zranil a chybí $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Stříbro';

  @override
  String get hubRunnerUpTitle2 => 'Tak blízko a přece daleko';

  @override
  String get hubRunnerUpTitle3 => 'Stříbrné medaile';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Došli jste ve finále turnaje $cup, ale $opponent bylo lepší. Tak blízko. Tentokrát stříbro.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Ve finále turnaje $cup vás porazilo $opponent. Stříbro, k zbláznění blízko.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Finále turnaje $cup vám proti $opponent uteklo. Je na co být hrdý, jen ta trofej chybí.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Konec turnaje';

  @override
  String get hubKnockedOutTitle2 => 'Cesta končí';

  @override
  String get hubKnockedOutTitle3 => 'Dojeli jsme';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Končíte na turnaji $cup, v $stage vás vyřadilo $opponent.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent vám ukončilo turnaj $cup v $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Váš turnaj $cup končí v $stage, porazilo vás $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Konec ve skupině';

  @override
  String get hubGroupExitTitle2 => 'Vypadli jsme ve skupině';

  @override
  String get hubGroupExitTitle3 => 'Brzký konec';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Váš turnaj $cup končí už ve skupině. Na vyřazovací boje to nestačilo.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Ze skupiny jste nepostoupili. Turnaj $cup pro vás končí.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Vyřazovací fáze tentokrát nebude. Turnaj $cup končí ve skupině.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Cíl splněn: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Cíl nesplněn: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Cíl vedení na turnaji $comp: $demand. Vaše umístění: $finish. Vedení má, oč žádalo.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Cíl vedení na turnaji $comp: $demand. Vaše umístění: $finish. To je pod očekávání.';
  }

  @override
  String get newsWcMissTitle => 'Sen o mistrovství světa končí';

  @override
  String newsWcMissBody(int year) {
    return 'Na mistrovství světa $year jedete jen jako diváci. Kvalifikace nevyšla. Další čtyři roky.';
  }

  @override
  String get newsRecordScorerTitle => 'Nejlepší střelec historie';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name je nejlepším střelcem historie s $goals góly.';
  }

  @override
  String get newsRecordCapsTitle => 'Rekordman v počtu startů';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name je rekordmanem v počtu startů s $caps zápasy.';
  }

  @override
  String get newsARecordBreaker => 'Nový rekordman';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name přestupuje do $club';
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
    return '$name ($position, $rating) opouští $fromClub a míří do $destination za $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Zdarma';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name by přestoupil do reprezentace $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name chce hrát za $nation';
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
    return '$name, ${age}letý $position s ratingem $rating, momentálně reprezentuje $fromNation. Má rodinné vazby na $nation a je ochoten přestoupit. Nabídku naturalizace přijměte nebo odmítněte v menu.';
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
    return '$name, ${age}letý $position s ratingem $rating, momentálně reprezentuje $fromNation. Je to hvězda, má rodinné vazby na $nation a je ochoten přestoupit. Nabídku naturalizace přijměte nebo odmítněte v menu.';
  }

  @override
  String get newsTheirNation => 'jejich reprezentace';

  @override
  String get newsYourNation => 'vaše reprezentace';

  @override
  String get tourStatusChampions => 'MISTŘI';

  @override
  String get tourStatusFinals => 'ZÁVĚREČNÝ TURNAJ';

  @override
  String get tourStatusQualifying => 'KVALIFIKACE';

  @override
  String get tourStatusUpcoming => 'PŘIPRAVUJE SE';

  @override
  String get tourStatusInProgress => 'PROBÍHÁ';

  @override
  String get tourStatusComingSoon => 'BRZY';

  @override
  String get tourStatusDecided => 'ROZHODNUTO';

  @override
  String tourStatusLeague(String letter) {
    return 'LIGA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'LOS KVALIFIKACE MS';

  @override
  String tourDrawContQualifying(String cup) {
    return 'LOS KVALIFIKACE: $cup';
  }

  @override
  String get tourDrawWcHost => 'POŘADATEL MS';

  @override
  String tourDrawContHost(String cup) {
    return 'POŘADATEL: $cup';
  }

  @override
  String get tourDrawHostsReveal => 'A pořadateli budou…';

  @override
  String get tourDrawHostReveal => 'A pořadatelem bude…';

  @override
  String get tourDrawHostCandidates => 'Kandidáti ve hře:';

  @override
  String get tourKickoffContinentalCup => 'KONTINENTÁLNÍ POHÁR';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup bez nás';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Na turnaj $cup jste nepostoupili. Kvalifikace tentokrát nevyšla.';
  }

  @override
  String get potyLabelBest => 'Hráč roku';

  @override
  String get potyLabelYoung => 'Mladý hráč roku';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count asistencí',
      few: '$count asistence',
      one: '1 asistence',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Rating $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Známka $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Světový hráč roku $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name je letos nejlepším hráčem světa.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' Cenu pro nejlepšího mladého hráče bere $name.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Kluci, které sledujete, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: 'o $gain bodů',
      few: 'o $gain body',
      one: 'o bod',
    );
    return '$name se posunul na $rating, $_temp0 výš než loni.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name postupuje do kategorie $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name debutoval';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name si v $age letech připsal první start v reprezentaci, rating $rating. Jeden z kluků, které sledujete.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Držení míče, známky hráčů a hráč zápasu budou známy až po závěrečném hvizdu.';

  @override
  String get matchPlayerRatings => 'ZNÁMKY HRÁČŮ';

  @override
  String get matchSubstitutions => 'STŘÍDÁNÍ';

  @override
  String get matchSubstitutes => 'NÁHRADNÍCI';

  @override
  String get matchLineupsViewPitch => 'Hřiště';

  @override
  String get matchLineupsViewList => 'Seznam';

  @override
  String get matchLineupsCameOn => 'Přišli z lavičky';

  @override
  String get matchConditionsKickOff => 'Výkop';

  @override
  String get matchWeatherClear => 'Jasno';

  @override
  String get matchWeatherRain => 'Slabý déšť';

  @override
  String get matchWeatherSnow => 'Sníh';

  @override
  String get matchWeatherHaze => 'Opar';

  @override
  String get matchWeatherHeavyRain => 'Silný déšť';

  @override
  String get matchWeatherThunderstorm => 'Bouřka';

  @override
  String get matchWeatherFog => 'Mlha';

  @override
  String get matchWeatherWindy => 'Větrno';

  @override
  String get matchWeatherDustStorm => 'Prachová bouře';

  @override
  String get matchWeatherFrostyNight => 'Mrazivá noc';

  @override
  String get matchPlayerOfTheMatch => 'HRÁČ ZÁPASU';

  @override
  String get ratingPlayerOfTheMatch => 'Hráč zápasu';

  @override
  String ratingSemantics(String rating) {
    return 'Známka $rating';
  }

  @override
  String get matchAverageRating => 'Průměrná známka';

  @override
  String get matchLiveRatingsNote =>
      'Známky sledují dosavadní průběh zápasu a platí až po závěrečném hvizdu.';

  @override
  String get matchGoalShout => 'GÓL!';

  @override
  String get matchRedCardShout => 'ČERVENÁ KARTA';

  @override
  String matchShootoutScore(int home, int away) {
    return 'PENALTY $home:$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: PROMĚNIL';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: NEPROMĚNIL';
  }

  @override
  String get matchFeedKickOff => 'Výkop!';

  @override
  String get matchFeedNoEvents => 'Zatím žádné události.';

  @override
  String get tourVenues => 'STADIONY';

  @override
  String tourPot(int number) {
    return 'KOŠ $number';
  }

  @override
  String get tourHostSelection => 'VOLBA POŘADATELE';

  @override
  String get tourCandidates => 'KANDIDÁTI';

  @override
  String get tourJointBid => 'SPOLEČNÁ KANDIDATURA';

  @override
  String get tourGoldenGlove => 'ZLATÁ RUKAVICE';

  @override
  String get tourTeamOfTournament => 'NEJLEPŠÍ JEDENÁCTKA TURNAJE';

  @override
  String get tourYourRun => 'VAŠE CESTA';

  @override
  String get tourMedalTable => 'MEDAILOVÉ POŘADÍ';

  @override
  String tourHostLine(String nation) {
    return 'Pořadatel: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Pořadatelé: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Skupina $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Nasazení podle světového žebříčku. Najděte svůj tým, než začne los.';

  @override
  String get tourWorldRanking => 'Světový žebříček';

  @override
  String get tourYourCompetitions => 'VAŠE SOUTĚŽE';

  @override
  String get tourOtherContinents => 'OSTATNÍ KONTINENTY';

  @override
  String get tourZoneGlobal => 'SVĚT';

  @override
  String get tourZoneEurope => 'EVROPA';

  @override
  String get tourZoneSouthAmerica => 'J. AMERIKA';

  @override
  String get tourZoneNorthAmerica => 'S. AMERIKA';

  @override
  String get tourZoneAfrica => 'AFRIKA';

  @override
  String get tourZoneAsia => 'ASIE';

  @override
  String get tourZoneOceania => 'OCEÁNIE';

  @override
  String get tourZoneIntercontinental => 'MEZI KONTINENTY';

  @override
  String tourZoneLeague(String league) {
    return 'LIGA $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'POŘÁDÁ  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Nejlepších $count postupuje do $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name končí v reprezentaci';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps starty',
      one: '1 startem',
    );
    return '$name ukončil reprezentační kariéru ve $age letech s $_temp0. Chtěl vědět, na čem je, odpovědi se nedočkal, a déle už nečekal.';
  }

  @override
  String get pressHeadlineWent1 => 'Trenér, který má situaci pevně v rukou';

  @override
  String get pressHeadlineWent2 => 'Přišli si pro hádku, odešli s vůdcem';

  @override
  String get pressHeadlineWent3 => 'Jasné odpovědi, a sedly';

  @override
  String get pressHeadlineMixed1 => 'Řečeno hodně, vyřešeno málo';

  @override
  String get pressHeadlineMixed2 => 'Něco pro každého, a nic pro nikoho';

  @override
  String get pressHeadlineMixed3 =>
      'Tisková konference, po které otázky zůstaly';

  @override
  String get pressHeadlineBadly1 => 'Perná hodina před kamerami';

  @override
  String get pressHeadlineBadly2 => 'Sál se otočil proti němu, a bylo to vidět';

  @override
  String get pressHeadlineBadly3 => 'Odpovědi, které ráno vyzní ještě hůř';

  @override
  String get pressHeadlineFlat1 => 'Nic neřečeno, nic nezískáno';

  @override
  String get pressHeadlineFlat2 => 'Deset minut, žádná zpráva';

  @override
  String get pressHeadlineFlat3 => 'Prázdná stránka pro zadní stranu';

  @override
  String get pressConferenceTitle => 'TISKOVÁ KONFERENCE';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Otázka $index z $total';
  }

  @override
  String get pressTomorrowsHeadline => 'ZÍTŘEJŠÍ TITULEK';

  @override
  String get pressLeaveRoom => 'ODEJÍT ZE SÁLU';

  @override
  String get pressRoomVerdictSquad => 'Kabina';

  @override
  String get pressRoomVerdictBoard => 'Vedení';

  @override
  String get yReactionElation0 => 'bez připomínek. žádných. dokonalé.';

  @override
  String get yReactionElation1 => 'je mi zle (v dobrém).';

  @override
  String get yReactionElation2 => 'dávám to do rámečku. nad krb.';

  @override
  String get yReactionElation3 => 'jsme zpátky ve hře';

  @override
  String get yReactionElation4 =>
      'screenshot pro všechny pochybovače. Pro všechny.';

  @override
  String get yReactionElation5 => 'budu s tím otravovat příštích deset let.';

  @override
  String get yReactionElation6 => 'Tak. Přesně proto se to sleduje.';

  @override
  String get yReactionElation7 => 'Takové dny zaplatí všechny ostatní.';

  @override
  String get yReactionElation8 => 'Konečně. Fakt konečně.';

  @override
  String get yReactionElation9 => 'Super. Zopakujte to za týden a uvěřím tomu.';

  @override
  String get yReactionElation10 =>
      'Užijte si dnešek, tihle si najdou způsob, jak to pokazit.';

  @override
  String get yReactionElation11 =>
      'Jeden dobrý večer z nikoho nedělá velký tým.';

  @override
  String get yReactionRelief0 => 'Krása to nebyla, ale beru to vždycky.';

  @override
  String get yReactionRelief1 => 'Nějak. Prostě nějak!';

  @override
  String get yReactionRelief2 => 'Ošklivé. Body doma. Jedeme dál.';

  @override
  String get yReactionRelief3 => 'Beru ošklivý výkon, když k tomu jsou body.';

  @override
  String get yReactionRelief4 => 'tohle mě stálo deset let života';

  @override
  String get yReactionRelief5 => 'Nikdo nic neříkejte. Ať to nezakřiknete.';

  @override
  String get yReactionRelief6 => 'Tep: nepřijatelný.';

  @override
  String get yReactionRelief7 => 'Přežili jsme. Přesně tak. Přežili.';

  @override
  String get yReactionRelief8 =>
      'Z takových zápasů bychom si neměli oddechovat.';

  @override
  String get yReactionRelief9 => 'Ulevilo se mi a stydím se za to.';

  @override
  String get yReactionRelief10 => 'Jestli tleskáme tomuhle, je zle.';

  @override
  String get yReactionRelief11 => 'Protloukat se je zvyk, a špatný.';

  @override
  String get yReactionFury0 => 'Málo. Ani zdaleka to nestačí.';

  @override
  String get yReactionFury1 => 'Ať mi to někdo vysvětlí. Pomalu.';

  @override
  String get yReactionFury2 =>
      'Tohle se špatně sleduje a to jsem ještě slušný.';

  @override
  String get yReactionFury3 => 'Zklamání. Opravdové zklamání.';

  @override
  String get yReactionFury4 => 'Tohle je fakt bída.';

  @override
  String get yReactionFury5 => 'Chci jména.';

  @override
  String get yReactionFury6 => 'Mažu aplikaci. Ve čtvrtek ji stáhnu zas.';

  @override
  String get yReactionFury7 => 'Nikdo tam nevypadal, že by o to stál.';

  @override
  String get yReactionFury8 => 'Každé čtyři roky to samé. KAŽDÉ čtyři roky.';

  @override
  String get yReactionFury9 => 'To nebyl výkon, to byla urážka.';

  @override
  String get yReactionFury10 =>
      'Lidé kvůli tomu obětují víkendy a peníze. Vzpamatujte se.';

  @override
  String get yReactionFury11 =>
      'Bránil jsem tenhle tým roky. Dneska ne. Po tomhle ne.';

  @override
  String get yReactionDespair0 => 'tak.';

  @override
  String get yReactionDespair1 => 'Dneska bez vtipů. Vůbec nic.';

  @override
  String get yReactionDespair2 => 'Jdu se projít. Na dlouho.';

  @override
  String get yReactionDespair3 => 'Došla mi slova.';

  @override
  String get yReactionDespair4 => 'Vzbuďte mě za čtyři roky.';

  @override
  String get yReactionDespair5 => 'tohle je ta nejhorší verze reality';

  @override
  String get yReactionDespair6 => 'Už ani vztek. To je na tom to nejhorší.';

  @override
  String get yReactionDespair7 => 'Tohle bude bolet ještě hodně dlouho.';

  @override
  String get yReactionDespair8 => 'Nevím, co to je, ale fotbalový tým to není.';

  @override
  String get yReactionDespair9 =>
      'Jsme dál než dřív a nikdo to nahlas neřekne.';

  @override
  String get yReactionDespair10 =>
      'Promarněná generace a rozhodovat budou ti samí lidé.';

  @override
  String get yReactionDespair11 =>
      'Neříkejte mi, že je to proces. Nikam to nevede.';

  @override
  String get yReactionSmugness0 => 'Potichu, ale: říkal jsem to.';

  @override
  String get yReactionSmugness1 => 'tohle si uložte';

  @override
  String get yReactionSmugness2 => 'Pochybovači nějak ztichli.';

  @override
  String get yReactionSmugness3 => 'Ne že by to někdo počítal. Já to počítám.';

  @override
  String get yReactionSmugness4 => 'Říkal jsem to v lednu. Zkontrolujte si to.';

  @override
  String get yReactionSmugness5 => 'Někteří z vás nám dluží omluvu.';

  @override
  String get yReactionSmugness6 => 'Zakládám do složky „říkal jsem to první“.';

  @override
  String get yReactionSmugness7 => 'Žádné vytahování. Trochu vytahování.';

  @override
  String get yReactionSmugness8 =>
      'Kde jsou teď všichni odborníci? Vážná otázka.';

  @override
  String get yReactionSmugness9 => 'Chci to od každého z vás slyšet nahlas.';

  @override
  String get yReactionSmugness10 =>
      'Screenshot, vytisknout, zarámovat, poslat těm, co se smáli.';

  @override
  String get yReactionSmugness11 =>
      'Budu to připomínat do konce života a zasloužíte si to.';

  @override
  String get yReactionShrug0 => 'stalo se. jedeme dál.';

  @override
  String get yReactionShrug1 => 'Dobře. Nevadí. Dál.';

  @override
  String get yReactionShrug2 => 'Zařazuju do složky „fotbal“.';

  @override
  String get yReactionShrug3 => 'Vážně nemám co dodat.';

  @override
  String get yReactionShrug4 => 'žádné myšlenky, prázdno';

  @override
  String get yReactionShrug5 => 'Vzbuďte mě na další.';

  @override
  String get yReactionShrug6 =>
      'To je devadesát minut, co už mi nikdo nevrátí.';

  @override
  String get yReactionShrug7 => 'Ani ryba, ani rak.';

  @override
  String get yReactionShrug8 => 'Neuměl bych říct jedinou věc, co se stalo.';

  @override
  String get yReactionShrug9 => 'Zase jeden z těch. Těch je hodně.';

  @override
  String get yReactionShrug10 => 'Viděl jsem to celé a necítil vůbec nic.';

  @override
  String get yReactionShrug11 => 'Jestli to už nikdo nezmíní, budu jen rád.';

  @override
  String get tourThirdsUneven =>
      'Skupiny nejsou stejně velké, takže výsledky proti poslednímu týmu větších skupin se nezapočítávají a všechny týmy se hodnotí podle stejného počtu zápasů.';

  @override
  String get careerExportSave => 'Zálohovat tuto hru';

  @override
  String get careerBackupAll => 'ZÁLOHOVAT VŠECHNY HRY';

  @override
  String get careerBackupAllFailed => 'Zálohu se nepodařilo vytvořit.';

  @override
  String get backupTitle => 'ZÁLOHY';

  @override
  String get backupBlurb =>
      'Všechny uložené hry jsou v jednom souboru v tomto telefonu a nic je samo nezálohuje, dokud níže nezapnete automatickou zálohu. Mějte kopii v cloudu, aby vás ztráta telefonu nebo smazání aplikace nestála kariéru.';

  @override
  String get backupBlurbNoAuto =>
      'Všechny uložené hry jsou v jednom souboru v tomto telefonu a nic je samo nezálohuje. Mějte kopii v cloudu, aby vás ztráta telefonu nebo smazání aplikace nestála kariéru.';

  @override
  String get backupExport => 'ZÁLOHOVAT DO CLOUDU';

  @override
  String get backupExportSubject => 'Uložené hry FNM';

  @override
  String get backupRestore => 'OBNOVIT ZE SOUBORU';

  @override
  String get backupRestoreWarnTitle => 'Nahradit všechny uložené hry?';

  @override
  String get backupRestoreWarnBody =>
      'Obnovení nahradí všechny uložené hry v tomto telefonu těmi ze souboru. Aplikace se restartuje.';

  @override
  String get backupRestoreConfirm => 'NAHRADIT';

  @override
  String get backupCancel => 'ZRUŠIT';

  @override
  String get backupExported => 'Záloha je připravená. Vyberte, kam ji uložit.';

  @override
  String get backupFailed => 'Zálohu se nepodařilo vytvořit.';

  @override
  String get backupRejectedUnreadable => 'Tento soubor nelze otevřít.';

  @override
  String get backupRejectedNotFnm => 'Tohle není uložená hra FNM.';

  @override
  String get backupRejectedNewer =>
      'Tato záloha pochází z novější verze aplikace. Nejprve aplikaci aktualizujte.';

  @override
  String get backupRejectedTooOld =>
      'Tato záloha je příliš stará, tato verze ji nedokáže obnovit.';

  @override
  String get careerShare => 'Sdílet tuto kariéru';

  @override
  String get careerImport => 'IMPORTOVAT KARIÉRU';

  @override
  String get careerShareSubject => 'Kariéra ve FNM';

  @override
  String get careerImported => 'Kariéra byla importována.';

  @override
  String get careerImportFailedUnreadable => 'Tento soubor není kariéra FNM.';

  @override
  String get careerImportFailedNewer =>
      'Tato kariéra byla exportována novější verzí aplikace. Nejprve aplikaci aktualizujte.';

  @override
  String get careerImportFailedSlotsFull =>
      'Všechny sloty pro uložení jsou obsazené. Smažte nějakou hru, nebo si odemkněte neomezené ukládání.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Tato kariéra už je za prvním bezplatným cyklem. Pro import si odemkněte plnou hru.';

  @override
  String get careerImportFailedCampaignRun =>
      'Tato kampaň už má rozehraný pokus. Nejprve v něm pokračujte, nebo ho zrušte.';

  @override
  String get careerShareFailed => 'Kariéru se nepodařilo exportovat.';

  @override
  String get managerRename => 'Změnit jméno';

  @override
  String get managerRenameSave => 'Uložit';

  @override
  String get managerTitle => 'TRENÉR';

  @override
  String get managerSkills => 'VAŠE SCHOPNOSTI';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodů k rozdělení',
      few: '$count body k rozdělení',
      one: '1 bod k rozdělení',
      zero: 'Žádné body k rozdělení',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Dva body za každý dokončený cyklus, jeden za každou vyhranou trofej.';

  @override
  String get managerSkillsScale =>
      'Každá dovednost začíná na 5 a končí na 20. Vložený bod je trvalý.';

  @override
  String get managerSkillManManagement => 'Vedení lidí';

  @override
  String get managerSkillManManagementBlurb =>
      'Každý bod zvýší o 3 %, jak silně na kabinu působí to, co řeknete novinářům i hráčům.';

  @override
  String get managerSkillTactical => 'Taktika';

  @override
  String get managerSkillTacticalBlurb =>
      'Každý bod o 3 % zrychlí zažití nové formace, takže změna rozestavení stojí méně zápasů.';

  @override
  String get managerSkillYouth => 'Práce s mládeží';

  @override
  String get managerSkillYouthBlurb =>
      'Každý bod přidá 1 % k talentu vycházejícímu z akademie, nad rámec toho, co do ní vložíte.';

  @override
  String get managerSkillNegotiation => 'Vyjednávání';

  @override
  String get managerSkillNegotiationBlurb =>
      'Každý bod znamená o 2 % více peněz od federace, každý cyklus.';

  @override
  String get managerStaff => 'VÁŠ REALIZAČNÍ TÝM';

  @override
  String managerStaffWages(String amount) {
    return 'Mzdy: $amount za cyklus';
  }

  @override
  String get managerRoleAssistant => 'Asistent trenéra';

  @override
  String get managerRoleAssistantBlurb =>
      'Vede tréninky: méně zranění a lepší mladí hráči.';

  @override
  String get managerRoleScout => 'Hlavní skaut';

  @override
  String get managerRoleScoutBlurb =>
      'Hodnotí vaše talenty i příštího soupeře: přesnější hvězdičky a výhoda v den zápasu.';

  @override
  String get managerRoleFitness => 'Kondiční trenér';

  @override
  String get managerRoleFitnessBlurb => 'Udrží hráče na hřišti.';

  @override
  String staffEffectInjury(int percent) {
    return 'O $percent % méně zranění';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Mladíci +$points na celkovém';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Po najmutí: o $min až $max % méně zranění';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'a mladíci +$minPoints až +$maxPoints na celkovém';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Přesně odhadne $percent % talentů';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potenciál jasný po $caps startech',
      few: 'Potenciál jasný po $caps startech',
      one: 'Potenciál jasný po 1 startu',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points k síle díky rozboru soupeře';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Po najmutí: přesně odhadne $min až $max % talentů';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    String _temp0 = intl.Intl.pluralLogic(
      maxCaps,
      locale: localeName,
      other: '$maxCaps startů',
      few: '$maxCaps starty',
      one: '1 start',
    );
    return 'a potenciál jasný o $minCaps až $_temp0 dřív';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'a +$minPoints až +$maxPoints k síle v každém zápase';
  }

  @override
  String get staffEffectNone => 'Na tým zatím nemá žádný vliv';

  @override
  String get staffVacant => 'Místo je neobsazené';

  @override
  String get staffLeaveVacant => 'Nechat místo neobsazené';

  @override
  String get managerTierNone => 'Nikdo';

  @override
  String get managerTierBasic => 'Základní';

  @override
  String get managerTierGood => 'Dobrý';

  @override
  String get managerTierElite => 'Špičkový';

  @override
  String get managerFree => 'zdarma';

  @override
  String get managerTraining => 'MEZI SRAZY';

  @override
  String get managerTrainingBlurb =>
      'Na čem tým pracuje, když se zrovna nehraje.';

  @override
  String get managerFocusBalanced => 'Vyvážený';

  @override
  String get managerFocusBalancedBlurb => 'Od každého něco.';

  @override
  String get managerFocusFitness => 'Kondice';

  @override
  String get managerFocusFitnessBlurb => 'Méně zranění.';

  @override
  String get managerFocusCohesion => 'Sehranost';

  @override
  String get managerFocusCohesionBlurb => 'Rozestavení si sedne rychleji.';

  @override
  String get managerFocusYouth => 'Mládež';

  @override
  String get managerFocusYouthBlurb => 'Hodiny s nejmladšími hráči.';

  @override
  String get tourOfferTitle => 'Poprvé tady?';

  @override
  String get tourOfferBody =>
      'Tahle hra toho umí hodně. Chcete rychle provést obrazovkami, na kterých záleží? Zabere to minutu a kdykoli to můžete spustit znovu v Nastavení.';

  @override
  String get tourOfferYes => 'Proveďte mě';

  @override
  String get tourOfferNo => 'Teď ne';

  @override
  String get tourBack => 'Zpět';

  @override
  String get tourNext => 'Dál';

  @override
  String get tourDone => 'Hotovo';

  @override
  String get tourSkip => 'Přeskočit';

  @override
  String get tourHubTitle => 'Tohle je celá hra';

  @override
  String get tourHubBody =>
      'Jedno tlačítko, které se mění podle toho, kde je cyklus: los k vidění, nominace, zápas. Nad ním je důvěra vedení a cíle, které vám dalo.';

  @override
  String get tourBudgetTitle => 'Peníze federace';

  @override
  String get tourBudgetBody =>
      'Jednou za čtyřletý cyklus rozdělíte rozpočet mezi oddělení. Nejdřív se z něj platí štáb, takže špičkový skaut je rozhodnutí proti akademii, ne vedle ní.';

  @override
  String get tourTacticsTitle => 'Jak tým hraje';

  @override
  String get tourTacticsBody =>
      'Rozestavení, styl hry, kapitán a exekutoři standardek. Poslední dvě věci nemusíte nastavit. Hra vás před výkopem upozorní, místo aby za vás tiše vybrala.';

  @override
  String get tourSquadTitle => 'Všichni, koho můžete vzít';

  @override
  String get tourSquadBody =>
      'Celý kádr, ne jen nominace: kdo je ve formě, kdo se doléčuje, kdo má stopku a kdo právě prošel akademií.';

  @override
  String get tourCallUpsTitle => 'Nominace';

  @override
  String get tourCallUpsBody =>
      'Nominujete jednou na reprezentační okno a ta soupiska odehraje všechny zápasy okna, přesně jako skutečný trenér. Zranění uvnitř okna za vás doplní náhradník.';

  @override
  String get tourRecordsTitle => 'Vaše kariéra';

  @override
  String get tourRecordsBody =>
      'Všechno, co jste dokázali: zápasy, týmové rekordy, trofeje a každý národ, který jste vedli.';

  @override
  String get tourCupsTitle => 'Zbytek světa';

  @override
  String get tourCupsBody =>
      'Všechny soutěže, které právě běží: skupiny, tabulky i vyřazovací fáze, včetně těch, kde nejste. Svět hraje dál, ať jste postoupili nebo ne.';

  @override
  String get settingsTourTitle => 'Spustit tutoriál znovu';

  @override
  String get settingsTourBlurb =>
      'Znovu si projděte klíčové obrazovky od začátku.';

  @override
  String get tourBoardTitle => 'Komu se zodpovídáte';

  @override
  String get tourBoardBody =>
      'Důvěra vedení a cíle, které vám na tenhle cyklus dalo. Když je neplníte, poznáte to právě tady.';

  @override
  String get tourStaffTitle => 'Lidé kolem vás';

  @override
  String get tourStaffBody =>
      'Asistent, skaut a kondiční trenér, každý jmenovitě. Jejich mzdy se platí z tohohle rozpočtu dřív než oddělení, takže špičkový skaut je rozhodnutí proti akademii.';

  @override
  String get tourPlaystyleTitle => 'Jak chcete hrát';

  @override
  String get tourPlaystyleBody =>
      'Rozestavení je jen půlka taktiky. Tohle je ta druhá: jak vysoko napadáte, jak přímočaře hrajete, kolik riskujete.';

  @override
  String get settingsTourNoSave =>
      'Nejdřív si založte kariéru. Průvodce prochází vaše vlastní obrazovky.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Mimo pozici · Věk $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Rozpočet na další cyklus se rozděluje na jeho začátku, najednou. Do té doby tady vidíte, co vaše peníze dělají.';

  @override
  String get federationBudgetAlreadySet => 'Pro tenhle cyklus už je rozdělený';

  @override
  String yFinalLooms0(String opponent) {
    return 'Je to $opponent a jde se o všechno. Celý týden se nebude mluvit o ničem jiném.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Potvrzeno: mezi námi a tím stojí $opponent. Čtyři roky kvůli tomuhle.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Tak jo. $opponent. Dokud tohle neskončí, nikdo nespí.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Další je $opponent a všechno ostatní počká. To je týden.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Nechat vykonavatele na trenérovi';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Označené jsou týmy podobné soupeřům, kteří vás v tomto cyklu čekají ve skupinách: $rivals.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Přestupní okno · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Naposledy před $when';
  }

  @override
  String get settingsFreeScopeTitle => 'Jeden čtyřletý cyklus zdarma';

  @override
  String get settingsFreeScopeBlurb =>
      'Celý cyklus (kvalifikace, kontinentální šampionát i mistrovství světa) na dvou uložených hrách, všechny země světa, nic není zamčené. Nekonečné cykly a neomezený počet uložených her jsou jednorázová platba, jednou, a platí i pro všechny budoucí aktualizace.';

  @override
  String get settingsUnlockedTitle => 'Odemčeno';

  @override
  String get settingsUnlockedBlurb =>
      'Nekonečné cykly, neomezená uložení a všechny budoucí aktualizace. Děkujeme.';

  @override
  String get settingsFromDeveloperTitle => 'Od vývojáře';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager vytváří jeden člověk a hra bude dlouhodobě podporována. Nikdy v ní nebudou reklamy ani mikrotransakce. Pokud vás hra baví, zvažte prosím koupi plné verze. Díky ní můžou přicházet další aktualizace.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager vytváří jeden člověk a hra bude dlouhodobě podporována. Nikdy v ní nebudou reklamy ani mikrotransakce. Děkuji, že jste si koupili plnou verzi. Díky ní můžou přicházet další aktualizace.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Označené jsou týmy podobné soupeřům, kteří vás ještě čekají: $rivals.';
  }

  @override
  String get friendliesCloseToYou =>
      'Označené jsou týmy nejblíž vám ve světovém žebříčku. Až vás vylosují, budou označovány podle vaší skupiny.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count přestupů',
      few: '$count přestupy',
      one: '1 přestup',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Novější';

  @override
  String get transfersOlder => 'Další';

  @override
  String get transfersPagePrevious => 'Předchozí';

  @override
  String get transfersPageNext => 'Další';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Stránka $page z $pages';
  }

  @override
  String get transfersMovedTo => 'Přestup do';

  @override
  String get transfersUnknownClub => 'Neznámý klub';

  @override
  String yAgainstThemAgain0(String opponent, int count) {
    return 'To už je $count. proti $opponent. Někdo si to počítá, a jsou to oni.';
  }

  @override
  String yAgainstThemAgain1(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return 'Zase $opponent. $_temp0 a pořád na ně nemáme recept.';
  }

  @override
  String yAgainstThemAgain2(String opponent, int count) {
    return 'Číslo $count proti $opponent. Tohle už není náhoda.';
  }

  @override
  String yAgainstThemAgain3(String opponent, int count) {
    return 'Hráli jsme s $opponent ${count}krát a ani jednou jsme se nepoučili.';
  }

  @override
  String yAgainstThemAgain4(String opponent, int count) {
    return '$opponent, ${count}krát. Přesně vědí, co uděláme.';
  }

  @override
  String yAgainstThemAgain5(String opponent, int count) {
    return 'Ať na nás $opponent má cokoli, po $count zápasech to má pořád.';
  }

  @override
  String ySameOldStory0(int count) {
    return 'To je poslední dobou už po $count. Odkdy to prostě nejsme my?';
  }

  @override
  String ySameOldStory1(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count takových odpolední',
      few: '$count taková odpoledne',
      one: '1 takové odpoledne',
    );
    return 'Už $_temp0. To je vzorec, ne smůla.';
  }

  @override
  String ySameOldStory2(int count) {
    return 'Přesně tenhle zápas jsme viděli ${count}krát. Stejný scénář, stejný konec.';
  }

  @override
  String ySameOldStory3(int count) {
    return '$count. verze těch samých devadesáti minut. Nikdo to neřeší.';
  }

  @override
  String ySameOldStory4(int count) {
    return '${count}krát. Kdo v tom po tomhle nevidí systém, nedívá se.';
  }

  @override
  String ySameOldStory5(int count) {
    return 'Stejný příběh, ${count}krát. Výmluvy došly dřív než výsledky.';
  }

  @override
  String get yToldYouSo0 =>
      'Říkal jsem, že to přijde, zatímco všichni slavili.';

  @override
  String get yToldYouSo1 =>
      'Dva dobré týdny a byli jsme zase zlatá generace. A jsme tady.';

  @override
  String get yToldYouSo2 =>
      'Ti, co mi minulý měsíc říkali, ať si to užívám, ztichli.';

  @override
  String get yToldYouSo3 => 'Nemám z toho radost. Skoro žádnou. Trochu.';

  @override
  String get yToldYouSo4 =>
      'Nikdy to nebylo tak dobré, jak vám tvrdili, a tohle je důkaz.';

  @override
  String get yToldYouSo5 =>
      'Pokaždé. Tvrdí nám, že teď je to jiné, a pokaždé není.';

  @override
  String get tacticsSubOffAlready => 'Už vystřídán';

  @override
  String get tacticsSubInjured => 'Zraněný';

  @override
  String get tacticsSubSentOffMark => 'Vyloučen';

  @override
  String get tacticsSubNoneLeft => 'Došla střídání';

  @override
  String get tacticsUndoLastChange => 'Vrátit změnu';

  @override
  String get matchStrengthTitle => 'CO OVLIVŇUJE TÝM';

  @override
  String get strengthFactorFamiliarity => 'Nacvičené rozestavení';

  @override
  String get strengthFactorFatigue => 'Únava';

  @override
  String get strengthFactorClubForm => 'Forma v klubu';

  @override
  String get strengthFactorMorale => 'Nálada v kabině';

  @override
  String get strengthFactorCaptain => 'Kapitán';

  @override
  String get strengthFactorStaff => 'Realizační tým';

  @override
  String get strengthFactorDossier => 'Rozbor soupeře';

  @override
  String yDebut0(String name) {
    return '$name má první start za národní tým. Zapamatujte si to jméno.';
  }

  @override
  String yDebut1(String name) {
    return 'Debut pro hráče $name. Je to na něm vidět, ne?';
  }

  @override
  String yDebut2(String name) {
    return '$name, první start. Uvidíme, co s tím udělá.';
  }

  @override
  String yDebut3(String name) {
    return 'Debut pro hráče $name. Kádr někde potřeboval čerstvé nohy.';
  }

  @override
  String yDebut4(String name) {
    return '$name dostal start. Těch jsme v poslední době rozdali hodně.';
  }

  @override
  String yDebut5(String name) {
    return 'Debut pro hráče $name. Další, na kterého do jara zapomeneme.';
  }

  @override
  String yDrought0(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$name nedal gól $_temp0, ale všechno ostatní na hřišti odvádí.';
  }

  @override
  String yDrought1(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$_temp0 bez gólu pro hráče $name. Přijdou naráz, vždycky to tak bylo.';
  }

  @override
  String yDrought2(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$name: $_temp0, žádný gól.';
  }

  @override
  String yDrought3(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$_temp0 bez gólu pro hráče $name. Stojí za to to sledovat.';
  }

  @override
  String yDrought4(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$_temp0. Ani gól. $name by netrefil ani vrata od stodoly.';
  }

  @override
  String yDrought5(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$name nedal gól $_temp0. Postavte tam klidně kohokoliv jiného.';
  }

  @override
  String yRivalryLooms0(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vzájemných zápasů',
      few: '$count vzájemné zápasy',
      one: '1 vzájemný zápas',
    );
    return 'Příště $opponent. $_temp0 a pořád je to všechno.';
  }

  @override
  String yRivalryLooms1(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return 'Už $_temp0 proti soupeři $opponent. Ať to začne.';
  }

  @override
  String yRivalryLooms2(String opponent, int count) {
    return 'Příště $opponent. Odehráno $count.';
  }

  @override
  String yRivalryLooms3(String opponent, int count) {
    return 'Tenhle týden $count. vzájemný zápas se soupeřem $opponent.';
  }

  @override
  String yRivalryLooms4(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count takových zápasů',
      few: '$count takové zápasy',
      one: '1 takový zápas',
    );
    return 'Zase $opponent. $_temp0 a nenaučili jsme se nic.';
  }

  @override
  String yRivalryLooms5(String opponent, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zápasů',
      few: '$count zápasy',
      one: '1 zápas',
    );
    return '$_temp0 proti soupeři $opponent a pořád nás poráží. Nádhera.';
  }

  @override
  String get positionGoalkeeper => 'Brankář';

  @override
  String get positionLeftBack => 'Levý obránce';

  @override
  String get positionCentreBack => 'Střední obránce';

  @override
  String get positionRightBack => 'Pravý obránce';

  @override
  String get positionDefensiveMid => 'Defenzivní záložník';

  @override
  String get positionCentralMid => 'Střední záložník';

  @override
  String get positionAttackingMid => 'Ofenzivní záložník';

  @override
  String get positionLeftMid => 'Levý záložník';

  @override
  String get positionRightMid => 'Pravý záložník';

  @override
  String get positionLeftWing => 'Levé křídlo';

  @override
  String get positionRightWing => 'Pravé křídlo';

  @override
  String get positionStriker => 'Útočník';

  @override
  String get roleNone => 'Bez role';

  @override
  String get roleTargetMan => 'Hrotový útočník';

  @override
  String get rolePoacher => 'Lovec gólů';

  @override
  String get rolePlaymaker => 'Tvůrce hry';

  @override
  String get roleBallWinner => 'Ničitel';

  @override
  String get roleInvertedWinger => 'Obrácený křídelník';

  @override
  String get roleBallPlayingDefender => 'Rozehrávající obránce';

  @override
  String get roleNoneBlurb => 'Hraje svou přirozenou hru.';

  @override
  String get roleTargetManBlurb =>
      'Vyhrává hlavičkové duely a nahrává. Asistence a standardky.';

  @override
  String get rolePoacherBlurb => 'Číhá ve vápně. Výrazně víc gólů.';

  @override
  String get rolePlaymakerBlurb => 'Vytváří šance. Výrazně víc asistencí.';

  @override
  String get roleBallWinnerBlurb =>
      'Rozbíjí hru soupeře, místo aby zakončoval.';

  @override
  String get roleInvertedWingerBlurb =>
      'Zatahuje do středu a střílí. Víc gólů.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Rozehrává akce od zadních řad.';

  @override
  String get federationDeptYouth => 'Mládežnická akademie';

  @override
  String get federationDeptCommercial => 'Marketing a PR';

  @override
  String get federationDeptMedical => 'Lékařský a vědecký úsek';

  @override
  String get federationDeptNaturalisation => 'Naturalizační odbor';

  @override
  String get federationDeptBoardRelations => 'Vztahy s vedením';

  @override
  String get federationDeptYouthBlurb =>
      'V dalším cyklu budou z akademie přicházet lepší talenty.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponzoři přinesou na konci cyklu další příjmy.';

  @override
  String get federationDeptMedicalBlurb =>
      'Méně zranění. Kádr zůstane k dispozici celý cyklus.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Víc hráčů ze zahraničí nabídne přestup pod vaši vlajku.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Vedení hodnotí vaše výsledky trpělivěji.';

  @override
  String get federationBuildingAcademy => 'Akademie';

  @override
  String get federationBuildingCommercial => 'Marketingové centrum';

  @override
  String get federationBuildingMedical => 'Lékařské centrum';

  @override
  String get federationBuildingScouting => 'Skautské oddělení';

  @override
  String get federationBuildingBoardroom => 'Zasedací sál';

  @override
  String get moraleBuoyant => 'Výborná';

  @override
  String get moralePositive => 'Dobrá';

  @override
  String get moraleSettled => 'Vyrovnaná';

  @override
  String get moraleUneasy => 'Nejistá';

  @override
  String get moraleRockBottom => 'Na dně';

  @override
  String get matchTabTimeline => 'PRŮBĚH';

  @override
  String get matchTabStats => 'STATISTIKY';

  @override
  String get matchTabLineups => 'SESTAVY';

  @override
  String get matchPenalty => 'PENALTA';

  @override
  String get matchStateLevel => 'Je to vyrovnané';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vedete o $count gólů',
      few: 'Vedete o $count góly',
      one: 'Vedete o gól',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prohráváte o $count gólů',
      few: 'Prohráváte o $count góly',
      one: 'Prohráváte o gól',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession % držení míče';
  }

  @override
  String get boardVerdictSackedTitle => 'Vedení vás odvolalo';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Zoufalý cyklus (hodnocení $rating %). Vaše vláda tady končí. Šanci vám teď dají jen slabší země.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Vedení je nadšené';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Vynikající cyklus (hodnocení $rating %) a k tomu $best. Zájem mají větší země, nebo můžete zůstat a stavět dál.';
  }

  @override
  String get boardVerdictSolidTitle => 'Solidní cyklus';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Vedení je spokojené (hodnocení $rating %). Vzaly by vás země podobné velikosti, ale nikdo vás nikam netlačí.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Vedení čekalo víc';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Zklamání (hodnocení $rating %). Místo si držíte, ale nabídky jsou jen o stupeň níž.';
  }

  @override
  String get boardVerdictPressureTitle => 'Jste pod skutečným tlakem';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Slabý cyklus (hodnocení $rating %). Přežíváte, ale pokud chcete začít jinde, zájem mají jen slabší země.';
  }

  @override
  String get boardVerdictHeroTitle => 'Národ stojí za vámi';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cyklech',
      few: '$cycles cyklech',
      one: '1 cyklu',
    );
    return ' $nation vás zbožňuje, po $_temp0 jste národní hrdina a místo máte tak dlouho, jak budete chtít.';
  }

  @override
  String get boardVerdictTheNation => 'Národ';

  @override
  String get boardVerdictBestQuiet => 'tichý cyklus';

  @override
  String get boardVerdictBestCycle => 'tenhle cyklus';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'mistrovství světa: $placement';
  }

  @override
  String get finishThirdPlace => 'Třetí místo';

  @override
  String get finishFourthPlace => 'Čtvrté místo';

  @override
  String get finishDidNotQualify => 'Neprošli kvalifikací';

  @override
  String get careerRepIconic => 'Legenda';

  @override
  String get careerRepRenowned => 'Zvučné jméno';

  @override
  String get careerRepEstablished => 'Zavedený kouč';

  @override
  String get careerRepRising => 'Nadějný kouč';

  @override
  String get careerRepUnproven => 'Neokoukaný';

  @override
  String get hubOfferStepUp => 'Krok vzhůru';

  @override
  String get hubOfferLateral => 'Srovnatelná nabídka';

  @override
  String get hubOfferRebuild => 'Práce od základů';

  @override
  String careerNationsCupWon(String league) {
    return 'Liga $league · vítězové';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Liga $league · finalisté';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Liga $league · semifinále';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Liga $league · $position. místo';
  }

  @override
  String tourRunInto(String round) {
    return 'Postup do $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Postup do boje o třetí místo';

  @override
  String tourRunThrough(String round) {
    return 'Postup přes $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Vyřazeni po $round';
  }

  @override
  String get tourRunInGroup => 'Hrají skupinu';

  @override
  String get tourRunGroupOut => 'Vyřazeni ve skupině';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Cyklus $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    String _temp0 = intl.Intl.pluralLogic(
      played,
      locale: localeName,
      other: '$played zápasů',
      few: '$played zápasy',
      one: '1 zápas',
    );
    return '$_temp0  ·  ${won}V ${drawn}R ${lost}P';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Mistrovství světa: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Ještě se hraje';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Csaplárova past v přímém přenosu. Dvě branky pro $opponent a pak už byla druhá půle jen naše. Tomu se říká mužstvo.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'O dvě zpět proti týmu $opponent a nakonec z toho něco bylo. Csaplárovu past umí nastavit jen někdo.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Poločas: o dvě prohráváme s $opponent. Konec: ne. Učebnicová Csaplárova past.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Klasická Csaplárova past proti týmu $opponent. Co padlo v šatně, ať padne každý týden.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Dobře, s $opponent jsme to otočili. Csaplárova past je hezká věc, ale prvních pětačtyřicet minut ať někdo vysvětlí.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Dvě branky k dobru pro $opponent a my máme být nadšení. Csaplárovu past se hrát každý týden nedá.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Do Csaplárovy pasti jsme si dnes vlezli sami. Dvě branky k dobru proti týmu $opponent a je z toho tohle. Stává se i lepším.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Vedli jsme o dvě a nic z toho. Csaplárovu past umí nastavit i $opponent.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Poločas: o dvě vedeme nad $opponent. Konec: nic z toho. Csaplárova past v obráceném gardu.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Dvě branky proti týmu $opponent pryč za pětačtyřicet minut. Csaplárova past, jen z druhé strany.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Csaplárova past pro pokročilé: nastavíš ji a spadneš do ní sám. Dvě branky proti týmu $opponent a nakonec nic.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'O dvě jsme vedli. S $opponent. Csaplárovu past jsme nastavili soupeři a spadli do ní sami.';
  }

  @override
  String get cycleBackupDone =>
      'Kariéra je zálohovaná ve složce FNM v tomto telefonu. Odinstalováním aplikace se smaže: kopii jinam uložíte přes Zálohovat tuto hru v seznamu uložených her.';

  @override
  String get cycleBackupFailed => 'Kariéru se tentokrát nepodařilo zálohovat.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Večer na zapamatování proti soupeři $opponent. Jak moc jste na tuhle partu hrdý?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return 'Soupeř $opponent na vás vůbec nestačil. Je tohle ten tým, ve který jste vždycky věřil?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Velká výhra nad soupeřem $opponent. Co dnes rozhodlo?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'Soupeř $opponent poražen, a s přehledem. Kde jste ten zápas vyhráli?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Pěkná výhra nad soupeřem $opponent. Jeden dobrý večer: proč by měl někdo věřit, že to vydrží?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Povedený výsledek proti soupeři $opponent. Byl to váš plán, nebo si na to hráči přišli sami?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Těžký večer proti soupeři $opponent. Co hráčům po takovém zápase řeknete?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Tohle proti soupeři $opponent nikdo nečekal. Byl to jen jeden z těch večerů?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Se soupeřem $opponent to byl výprask. Co se stalo?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return 'Soupeř $opponent vás rozebral. Je tenhle tým dost dobrý?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Se soupeřem $opponent jste byli ve všem druzí. Jak jste to mohl nechat zajít tak daleko?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return 'Soupeř $opponent dával góly, kdy chtěl. Kde byl dnes váš plán?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Další zápas bez výhry, tentokrát proti soupeři $opponent. Jak tu sérii otočíte?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Výsledky nejdou a soupeř $opponent to jen zhoršil. Věříte téhle partě pořád?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Zase bez výhry, teď proti soupeři $opponent, a vedení se dívá. Je vaše místo v bezpečí?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Po zápase se soupeřem $opponent se ta série natahuje. Bojíte se o svou budoucnost?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Teď i soupeř $opponent. Váš předchůdce po podobné sérii dostal padáka. Proč byste to měl přežít vy?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Po dalším večeru, jako byl ten se soupeřem $opponent, vás chce každá debata pryč. Odstoupil byste, kdyby o to vedení požádalo?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Dal jste v sázku své místo a po zápase se soupeřem $opponent to nevyšlo. Jak to nesete?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Tři zápasy jsou za vámi, poslední proti soupeři $opponent. Zkoušku jste si dal sám. Jak ten verdikt čtete?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Řekl jste, ať vás soudíme podle dalších tří zápasů. Po zápase se soupeřem $opponent jsme to udělali. Máte své místo ještě jisté?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Tři zápasy, poslední proti soupeři $opponent, a ne to, co jste sliboval. Mluvil jste s vedením o své budoucnosti?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Zkoušku jste si dal sám a proti soupeři $opponent jste ji neudělal. Odstoupíte?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Vaše slova, ne naše: suďte mě podle dalších tří. Po zápase se soupeřem $opponent se ptáme: proč tu ještě sedíte?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Chcete od nich víc. Myslíte někoho konkrétního?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Laťku jste nasadil vysoko. Kdo musí přidat jako první?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Říkáte, že se někteří musí podívat do zrcadla. Koho myslíte?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Říkáte, že to nestačí. O kom mluvíte?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Mluvíte obecně. Řeknete jména, nebo to padá na vás?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Každý týden je to vina někoho jiného. Čí je tentokrát?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Odvážná slova. A když ten další zápas nevyjde?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Země vás za slovo vezme. Co když to nevyjde?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'A když to nevyhrajete? Co pak?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Teď už jste to řekl. Co se stane, když se spletete?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Sliby jsme v téhle místnosti už slyšeli. Co dlužíte fanouškům, jestli nevyjde ani tenhle?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'A až to nevyjde, jaká bude výmluva?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Ještě jedna, jestli můžete. Na čem musí tahle parta ještě zapracovat?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Až opadnou emoce: co si z dneška berete do dalšího zápasu?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Pojďme trochu hlouběji. Co se musí zlepšit do dalšího zápasu?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Mimo výsledek: je tenhle kádr tam, kde ho chcete mít?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Spousta slov, málo obsahu. Co se od teď doopravdy změní?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Fanoušci chtějí přímou odpověď. Je tenhle tým dost dobrý, ano, nebo ne?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player byl dnes vynikající. Kam až to může dotáhnout?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player je dnes v každém titulku. Čekal jste to od něj?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player vyčníval. Co jste po něm dnes chtěl?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Rozhodl dnes zápas $player?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Bez hráče $player by to byl jiný příběh. Je tohle tým, nebo jeden hráč?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player byl skvělý. Vaše zásluha, nebo jeho?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player měl těžký večer. Netrápí ho nějaké zranění?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player dnes neměl svůj den. Podržíte ho?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player se dnes trápil. Udrží si místo v sestavě?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player nestačil tempu. Jak jste viděl jeho výkon?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player byl zase jen pasažér. Proč ho pořád stavíte?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Všichni viděli, že $player nebyl ve hře. Všichni kromě lavičky?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Řekl jste, že další zápas vyhrajete, a vyhráli jste. Je příjemné mít pravdu?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Slíbil jste výhru v dalším zápase a splnil jste to. Sebevědomí, nebo chvástání?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Řekl jste, že další zápas vyhrajete, a vyšlo to. Štěstí, nebo vás máme začít poslouchat?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Říkal jste, že ten zápas vyhrajete. Nevyšlo to. Co se pokazilo?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Řekl jste, že další zápas vyhrajete. Nevyhráli jste. Proč bychom měli věřit dalšímu slibu?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Řekl jste, že další zápas vyhrajete. Nevyhráli jste. Znamenají vaše slova v téhle místnosti ještě něco?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Chtěl jste, ať vás soudíme podle tří zápasů, a obstál jste. Cítíte zadostiučinění?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Suďte mě podle dalších tří, řekl jste. Soudili jsme a výsledky přišly. Co vám ta zkouška dala?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Dal jste si tři zápasy a prošel jste. Byla ta zkouška vůbec těžká?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Chtěl jste, ať vás soudíme podle tří zápasů. Nevyšly. Co jste se naučil?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Řekl jste: suďte mě podle dalších tří. Ty tři jsou pryč a s nimi i shovívavost. Co teď?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Zkoušku jste si dal sám a neudělal jste ji. Proč by vám teď měl kdokoli věřit?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Postavil jste se za hráče $player, když jiní ne. Splatil vám to. Je to i vaše zásluha?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Za hráče $player jste se postavil. Splatil vám to. Víra, nebo znalost?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Vsadil jste na hráče $player a pro jednou to vyšlo. Budete si příště stejně jistý?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Stál jste za hráčem $player a nevyšlo to. Věříte mu pořád?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Postavil jste se za hráče $player. Nesplatil vám to. Byla to chyba?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Úsudek, nebo věrnost: co z toho u hráče $player selhalo?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Na hráče $player jste byl tvrdý a zápasy od té doby vám daly za pravdu. Těší vás to?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Hráče $player jste veřejně zkritizoval a on neodpověděl. Má ještě cestu zpátky?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Hráče $player jste veřejně potopil a od té doby se nezvedl. Zlomil jste ho?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Hráče $player jste zkritizoval a on vám odpověděl na hřišti. Byl to od začátku záměr?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Hodil jste to na hráče $player a od té doby patří k vašim nejlepším. Dlužíte mu omluvu?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Hodil jste hráče $player přes palubu a od té doby je vaším nejlepším mužem na hřišti. Omluvíte se mu?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Tihle hráči mi dali všechno. Nevyměnil bych ani jednoho.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Nikdo nemaká víc než tahle parta. Budu je bránit pořád.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Ode mě na svoje hráče křivé slovo neuslyšíte.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Zásluhy patří hráčům, ne mně. Pište o nich.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Tohle jde za mnou. Sestavu jsem vybral já.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Suďte mě, ne je. Je to můj tým a moje zodpovědnost.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Jestli hledáte viníka, sedí přímo tady.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Zodpovědnost je moje. Hráče z toho vynechte.';

  @override
  String get pressReplyDemandMore1 =>
      'Chci víc. Někteří přesně vědí, koho myslím.';

  @override
  String get pressReplyDemandMore2 =>
      'Na téhle úrovni nestačí snaha. Chci víc a řekl jsem jim to.';

  @override
  String get pressReplyDemandMore3 =>
      'Od každého z nich čekám víc, a to od zítřka.';

  @override
  String get pressReplyDemandMore4 =>
      'Někteří se musí podívat do zrcadla. Spokojený nejsem.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Další zápas vyhrajeme. Klidně si to napište.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Pamatujte si to: příští zápas vyhrajeme.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Příště vyhrajeme. Říkám to tady, abyste mě mohli chytit za slovo.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Tomuhle týmu věřím. Další zápas vyhrajeme.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Suďte mě podle dalších tří zápasů. To je fér.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Dejte mi tři zápasy. Jestli to do té doby nebude ono, suďte mě.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Další tři zápasy ukážou, jestli jsem ten pravý. Držte mě za slovo.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Tři zápasy. Pak si o mně pište, co chcete.';

  @override
  String get pressReplyDeflect1 => 'Jdeme zápas od zápasu. Víc k tomu neřeknu.';

  @override
  String get pressReplyDeflect2 => 'Titulek vám dneska nedám.';

  @override
  String get pressReplyDeflect3 => 'Další zápas. Na nic jiného nemyslím.';

  @override
  String get pressReplyDeflect4 => 'Co si myslím, si nechám pro kabinu.';

  @override
  String get pressReplyTakeCredit1 =>
      'Řekl jsem to, protože jsem tomu věřil, a měl jsem pravdu.';

  @override
  String get pressReplyTakeCredit2 =>
      'Odhadl jsem to správně. Od toho tu jsem.';

  @override
  String get pressReplyTakeCredit3 =>
      'Říkejte tomu úsudek. Věděl jsem, co říkám.';

  @override
  String get pressReplyTakeCredit4 =>
      'Rozhodl jsem se a vyšlo to. To si vezmu.';

  @override
  String get pressReplyStandByIt1 => 'Řekl jsem, čemu věřím. Stojím si za tím.';

  @override
  String get pressReplyStandByIt2 => 'Neberu zpátky ani slovo.';

  @override
  String get pressReplyStandByIt3 =>
      'Stejná odpověď jako tehdy. Myslel jsem to vážně a pořád myslím.';

  @override
  String get pressReplyStandByIt4 => 'Řekl bych to znovu i zítra.';

  @override
  String get pressReplyAdmitMistake1 =>
      'Tohle jsem odhadl špatně. Beru to na sebe.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Dobře, spletl jsem se. Poučím se z toho.';

  @override
  String get pressReplyAdmitMistake3 => 'Mýlil jsem se a umím to přiznat.';

  @override
  String get pressReplyAdmitMistake4 => 'Tohle rozhodnutí nevyšlo a bylo moje.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player má moji plnou podporu. Ještě se ukáže.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return '$player má moji důvěru a ukáže vám proč.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Na hráče $player ode mě křivé slovo neuslyšíte. Ještě to ukáže.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player zůstává v mých plánech. Sledujte, co předvede.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player nás dnes zklamal a ví to.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Od hráče $player jsem čekal mnohem víc. Musí na to odpovědět.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player nebyl na úrovni. Říkám to veřejně.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Tohle od hráče $player nestačilo a ode mě to uslyší.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Řečeno do záznamu: další zápas vyhrajete.';

  @override
  String get pressOnRecordJob =>
      'Řečeno do záznamu: necháte se soudit podle dalších tří zápasů.';

  @override
  String pressOnRecordBack(String player) {
    return 'Řečeno do záznamu: stojíte za hráčem $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Řečeno do záznamu: $player vás zklamal.';
  }

  @override
  String yStatementKept0(String nation) {
    return '$nation: řekl to a tým to splnil. Tomuhle trenérovi věřím.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Řekl to nahlas a pak to dotáhl. Přesně takového trenéra $nation potřebuje.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: slíbil to a vyšlo to. Uznávám.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Řekl to do záznamu a platilo to. Bod pro něj. $nation jede dál.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Jednou se trefil. $nation: nezvykejte si.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'I slepé kuře najde zrno. $nation: tentokrát to vyšlo, příště uvidíme.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Řekl to a nevyšlo to. Pořád za ním stojím. $nation to zvedne.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: slíbil víc, než přišlo, ale radši trenér, co si věří, než ten, co mlčí.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: řekl to veřejně a nestalo se to. To se nezapomíná.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Velká slova, nic za nimi. $nation: příště míň mluvit.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Stál tam a sliboval. A pak tohle. $nation si zaslouží víc než řeči.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Jeho slovo už nemá žádnou cenu. $nation: zapište si to.';
  }

  @override
  String get ncZoneNorth => 'Severní zóna';

  @override
  String get ncZoneWest => 'Západní zóna';

  @override
  String get ncZoneEast => 'Východní zóna';

  @override
  String get ncZoneCentralSouthern => 'Střední a jižní zóna';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · vítězové';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · finalisté';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · semifinále';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · osmifinále';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · čtvrtfinále';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · $position. místo';
  }

  @override
  String get objectiveNcFinalsEight => 'Postoupit do čtvrtfinále';

  @override
  String get objectiveNcZoneWinGroup => 'Vyhrát skupinu';

  @override
  String get finishNcFinalsEight => 'Čtvrtfinále';

  @override
  String get finishNcBottomHalf => 'Dolní polovina skupiny';

  @override
  String get tourContTabZones => 'ZÓNY';

  @override
  String get tourContTabFinalsEight => 'VYŘAZOVACÍ FÁZE';

  @override
  String get tourContFinalsEightSoon =>
      'Vyřazovací fáze začíná v listopadu osmifinále: hraje všech 14 vítězů skupin a 2 nejlepší týmy z druhých míst.';

  @override
  String get tourContQuarterFinals => 'ČTVRTFINÁLE';

  @override
  String get tourContZoneAdvancement =>
      'Všichni vítězové skupin postupují do osmifinále, k nim 2 nejlepší týmy z druhých míst. Nikdo nesestupuje.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Pohár národů Severní Ameriky';

  @override
  String get compAfricanNationsCup => 'Pohár národů';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Vyhrát Pohár národů Severní Ameriky';

  @override
  String get objectiveNcWinItAfrica => 'Vyhrát Pohár národů';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Postoupit do finále Poháru národů Severní Ameriky';

  @override
  String get objectiveNcReachFinalAfrica => 'Postoupit do finále Poháru národů';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Vítězové Poháru národů Severní Ameriky';

  @override
  String get finishNcChampionsAfrica => 'Vítězové Poháru národů';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Kvalifikace: $competition. Celá země tomuhle týmu věří. Kam míříte?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Nová kvalifikace, $competition, a nálada je skvělá. Jak daleko může tenhle tým dojít?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Začíná kvalifikace, $competition. Jaký je cíl této kampaně?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Kvalifikace je tady, $competition. Kde tenhle tým vidíte na konci?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Začíná kvalifikace, $competition, a spousta lidí pochybuje, že postoupíte. Co jim vzkážete?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Další kvalifikace, $competition. Proč by měl někdo věřit, že tahle bude jiná?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition je tady a celá země stojí za vámi. Jak daleko můžete dojít?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Jste tam: $competition. Fanoušci sní. Jaký je cíl?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Tento týden začíná $competition. Co by pro vás byl úspěch?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'První zápas se blíží, $competition. Dejte nám cíl.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition je tady a nikdo moc nečeká. V co doopravdy doufáte?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Jste tam: $competition, ale pochybnosti nezmizely. Jaký je váš cíl?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'Ve skupině máte soupeře $rival. Dělá vám to starosti?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Los vám do cesty postavil soupeře $rival. Jak ten zápas vidíte?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return 'Soupeř $rival vypadá jako nejsilnější tým vaší skupiny. Je to favorit?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Co říkáte na soupeře $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'Ve skupině máte soupeře $rival. Upřímně, stačíte na ně?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Většina lidí čeká, že vás soupeř $rival porazí. Mýlí se?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player je ve skvělé formě. Je tohle jeho chvíle?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player je ve všech titulcích. Unese tenhle tým?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Jak moc tahle kampaň stojí na hráči $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Je $player připravený vést tenhle tým?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Když $player nebude ve formě, má tenhle tým vůbec něco?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player má na bedrech hodně. Není to moc?';
  }

  @override
  String get pressReplyAimHigher1 => 'Dojdeme dál, než kdokoli čeká.';

  @override
  String get pressReplyAimHigher2 =>
      'Chci víc, než po nás chce svaz, a říkám to nahlas.';

  @override
  String get pressReplyMatchBrief1 => 'Známe cíl a splníme ho.';

  @override
  String get pressReplyMatchBrief2 => 'Svaz nám dal cíl. Splníme ho.';

  @override
  String get pressReplyPlayDown1 => 'Jdeme zápas od zápasu.';

  @override
  String get pressReplyPlayDown2 => 'Žádné velké sliby. Uvidíme, kde budeme.';

  @override
  String get pressReplyPromiseQualify1 => 'Postoupíme. To si můžete napsat.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Tenhle tým bude na závěrečném turnaji.';

  @override
  String get pressReplyFearNobody1 => 'Nebojíme se nikoho.';

  @override
  String get pressReplyFearNobody2 => 'Oni musí hrát proti nám taky.';

  @override
  String get pressReplyRespectRival1 => 'Jsou favorit a máme k nim respekt.';

  @override
  String get pressReplyRespectRival2 =>
      'Velmi dobrý tým. Budeme potřebovat to nejlepší.';

  @override
  String get pressReplyTeamFirst1 => 'Jde o celý tým, ne o jednoho hráče.';

  @override
  String get pressReplyTeamFirst2 => 'Sám tohle nikdo nevyhraje.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Řečeno do záznamu: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Řečeno do záznamu: žádné sliby.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Před kampaní jste si dal cíl a splnil jste ho. Je to zatím vaše nejhrdější chvíle?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Řekl jste, čeho dosáhnete, a dosáhl jste toho. Pochyboval jste někdy?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Cíl, který jste si dal, jste splnil. Štěstí, nebo to byl opravdu plán?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Dal jste si cíl a nesplnil jste ho. Co se pokazilo?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Slíbil jste víc, než tým dokázal. Litujete toho?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Před kampaní jste mluvil velká slova a nedotáhl jste to. Proč bychom vám teď měli věřit?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Novináři chtějí slyšet vaše cíle: $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Úroveň $level · $amount';
  }

  @override
  String get formOnFire => 'V ohromné formě';

  @override
  String get formGood => 'Ve formě';

  @override
  String get formSteady => 'Stabilní';

  @override
  String get formPoor => 'Bez formy';

  @override
  String get formCold => 'Úplně bez formy';

  @override
  String get playerFormTitle => 'FORMA A KONDICE';

  @override
  String playerFormAverage(String rating) {
    return 'Průměrná známka $rating v posledních zápasech';
  }

  @override
  String get playerFormNoGames => 'Málo nedávných zápasů na posouzení';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta k hodnocení v příštím zápase';
  }

  @override
  String get playerFormNoEffect => 'Hodnocení v příštím zápase beze změny';

  @override
  String get sideGroupHome => 'Hlavní';

  @override
  String get sideGroupTeam => 'Tým';

  @override
  String get sideGroupCompetitions => 'Soutěže';

  @override
  String get sideGroupFederation => 'Svaz';

  @override
  String get sideGroupHistory => 'Historie';

  @override
  String get sideInbox => 'Pošta';

  @override
  String get sideSquad => 'Kádr';

  @override
  String get sideTactics => 'Taktika';

  @override
  String get sideMainMenu => 'Hlavní nabídka';

  @override
  String get sideCallUps => 'Nominace';

  @override
  String get sideTournaments => 'Turnaje';

  @override
  String get sideRanking => 'Žebříček';

  @override
  String get sideResults => 'Výsledky';

  @override
  String get sideFinances => 'Finance';

  @override
  String get sideBoard => 'Vedení';

  @override
  String get sideManager => 'Trenér a štáb';

  @override
  String get sideRecords => 'Rekordy';

  @override
  String get sideLegends => 'Legendy';

  @override
  String get sideHeadToHead => 'Vzájemné zápasy';

  @override
  String get sideAchievements => 'Úspěchy';

  @override
  String get sideCareer => 'Kariéra';

  @override
  String get topBarNext => 'Další';

  @override
  String get topBarDrawPending => 'Čeká se na los';

  @override
  String get paneFullProfile => 'Celý profil';

  @override
  String get panePickPlayer => 'Vyberte hráče a jeho karta se ukáže tady';

  @override
  String get inboxPickMessage => 'Vyberte zprávu a přečtěte si ji tady';

  @override
  String get inboxFilterAll => 'Vše';

  @override
  String get panelViewAll => 'Zobrazit vše';

  @override
  String get gridViewOverview => 'Přehled';

  @override
  String get gridColCondition => 'Kondice';

  @override
  String get gridColStatus => 'Stav';

  @override
  String get gridColRank => 'Pořadí';

  @override
  String get gridColMove => 'Posun';

  @override
  String get gridColNation => 'Reprezentace';

  @override
  String get gridColRegion => 'Region';

  @override
  String get gridColPoints => 'Body';

  @override
  String get panePickNation =>
      'Vyberte reprezentaci a její historie se ukáže tady';

  @override
  String get resultsCyclesTitle => 'Cykly';

  @override
  String get tourDrawStart => 'Zahájit los';

  @override
  String get tourDrawViewGroups => 'Zobrazit skupiny';

  @override
  String get gridColCeiling => 'Strop';

  @override
  String get gridColYearGain => 'Zlepšení';

  @override
  String get gridColMarkedAt => 'Při označení';

  @override
  String get budgetSetupTitle => 'Rozdělte rozpočet';

  @override
  String get budgetEffectsTitle => 'Co za tento rozpočet získáte';

  @override
  String get naturalisationTitle => 'Naturalizace';

  @override
  String get yTrending => 'Právě se řeší';

  @override
  String get yVoices => 'Hlasy';

  @override
  String get yConversation => 'Konverzace';

  @override
  String get allTimeRecordsTitle => 'Světové rekordy všech dob';

  @override
  String get h2hMeetingsTitle => 'Všechna vzájemná utkání';

  @override
  String get h2hPickOpponent =>
      'Vyberte soupeře a uvidíte tu všechna vzájemná utkání';

  @override
  String get savesTitle => 'Uložené hry';

  @override
  String get gridColPlayer => 'Hráč';

  @override
  String get gridColPos => 'Post';

  @override
  String get gridColActive => 'Aktivní';

  @override
  String get gridColMotm => 'MOTM';

  @override
  String get gridColAvg => 'Prům.';

  @override
  String get gridColOpponent => 'Soupeř';

  @override
  String get gridColStarts => 'Starty';

  @override
  String get gridColTournaments => 'Turnaje';

  @override
  String get gridColDate => 'Datum';

  @override
  String get gridColLastPlayed => 'Naposledy hráno';

  @override
  String get gridColManager => 'Trenér';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reprezentací',
      few: '$count reprezentace',
      one: '1 reprezentace',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Seřazeno podle světového žebříčku';

  @override
  String get nationsStrength => 'Síla';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier z 5';
  }

  @override
  String get nationsSquadOverall => 'Hodnocení kádru';

  @override
  String get nationsOpeningBudget => 'Počáteční rozpočet';

  @override
  String get nationsStarPlayer => 'Hvězda týmu';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Hvězda $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Věk $age';
  }

  @override
  String get nationsBoardExpects => 'Vedení očekává';

  @override
  String nationsManage(String nation) {
    return 'Převzít tým ($nation)';
  }

  @override
  String get nationsManagerNext => 'Jméno trenéra zadáte v dalším kroku';

  @override
  String get playerPageTitle => 'Hráč';

  @override
  String get nationPageTitle => 'Reprezentace';

  @override
  String get friendliesYourGames => 'Vaše přátelská utkání';

  @override
  String hubEventInjuryCover(String player) {
    return 'Náhrada za zraněného: $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Vynechá $matches zápasů',
      few: 'Vynechá $matches zápasy',
      one: 'Vynechá příští zápas',
    );
    return '$_temp0. Povolejte náhradu, nebo hrajte bez něj.';
  }

  @override
  String get injuryCoverTitle => 'NÁHRADNÍK';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) je zraněný. Povolejte kohokoli mimo kádr, na jakýkoli post, nebo ho ponechte a hrajte dál.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Povolat: $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Ponechat hráče $player a hrát dál';
  }

  @override
  String get injuryCoverPick => 'Vyberte náhradu';

  @override
  String get injuryCoverNone =>
      'Mimo kádr není nikdo zdravý, kdo by mohl nastoupit.';

  @override
  String get nationNowRanking => 'Světový žebříček';

  @override
  String get nationNowForm => 'Forma';

  @override
  String get nationNowNoForm => 'Zatím žádný odehraný zápas';

  @override
  String get nationNowNext => 'Další zápas';

  @override
  String get nationNowNoNext => 'Nic v plánu';

  @override
  String get nationNowSquad => 'Kádr';

  @override
  String get nationNowAgainstYou => 'Proti vám';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}V ${d}R ${l}P';
  }

  @override
  String get nationNowLastMeeting => 'Poslední zápas';

  @override
  String nationNowOverall(int value) {
    return 'Celkově $value';
  }

  @override
  String get hubUpcoming => 'NADCHÁZEJÍCÍ';

  @override
  String get hubFullSchedule => 'Celý program';

  @override
  String get scheduleTitle => 'Program zápasů';

  @override
  String get scheduleToday => 'Dnes';

  @override
  String get scheduleKnockoutPending => 'Vyřazovací fáze, pokud postoupíte';

  @override
  String get scheduleNextRoundPending => 'Další kolo';

  @override
  String scheduleFromDate(String date) {
    return 'Od: $date';
  }

  @override
  String get scheduleHomeShort => 'D';

  @override
  String get scheduleAwayShort => 'V';

  @override
  String get tacticsNoPresetsInMatch =>
      'Zatím žádné uložené taktiky. Uložte si nějakou na obrazovce Taktika před zápasem.';

  @override
  String get homeCampaigns => 'Kampaně';

  @override
  String get homeContinueCampaign => 'POKRAČOVAT V KAMPANI';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Cyklus $cycle ze $total';
  }

  @override
  String get campaignsTitle => 'Kampaně';

  @override
  String get campaignTransplantTitle => 'Transplantace';

  @override
  String get campaignTransplantTwist =>
      'Osm nejlepších Italů přijímá sanmarinské občanství';

  @override
  String get campaignTransplantGoal => 'Postoupit na mistrovství Evropy';

  @override
  String get campaignGrudgeTitle => 'Zášť';

  @override
  String get campaignGrudgeTwist => 'Gruzie a Albánie, losem svedené dohromady';

  @override
  String get campaignGrudgeGoal =>
      'V kvalifikaci obsadit lepší místo než Albánie';

  @override
  String get campaignTransplantIntro =>
      'San Marino vyhrává jen velmi vzácně, ale co se stane, když se pár top Italů zbaví svého pasu a připojí se k tomuto trpaslíkovi? Máte jeden cyklus na to to zjistit.';

  @override
  String get campaignGrudgeIntro =>
      'Gruzie a Albánie byly vylosovány do stejné kvalifikační skupiny a ani jedna strana nechce podlehnout té druhé. Skončete před soupeřem a pak uvidíte, kam až to dotáhnete.';

  @override
  String get campaignStars1Transplant => 'Postoupit';

  @override
  String get campaignStars2Transplant => 'Dostat se do vyřazovací fáze';

  @override
  String get campaignStars3Transplant => 'Vyhrát mistrovství Evropy';

  @override
  String get campaignStars1Grudge => 'Lepší než Albánie';

  @override
  String get campaignStars2Grudge => 'A postup';

  @override
  String get campaignStars3Grudge => 'A dvakrát je porazit';

  @override
  String get campaignFree => 'Zdarma';

  @override
  String get campaignStart => 'Začít';

  @override
  String get campaignPartOfUnlimited => 'Součást neomezeného FNM';

  @override
  String get campaignResume => 'Pokračovat';

  @override
  String get campaignAbandon => 'Opustit';

  @override
  String get campaignAbandonConfirm =>
      'Opustit tento průběh? Jeho postup se ztratí, razítko zůstane.';

  @override
  String get campaignMoveToSaves => 'Přesunout do uložených her';

  @override
  String get campaignCannotContinue =>
      'Svět této kampaně je příliš daleko od skutečného, než aby se v něm dalo pokračovat jako v kariéře.';

  @override
  String get campaignMoveSlotsFull =>
      'Sloty pro uložené hry jsou plné. Nejdřív jeden uvolněte.';

  @override
  String get campaignStampConquered => 'Zdoláno';

  @override
  String get campaignStampFailed => 'Nezdar';

  @override
  String get campaignDifficultyHard => 'Těžká';

  @override
  String get campaignDifficultyMedium => 'Střední';

  @override
  String get campaignGoalLabel => 'Cíl';

  @override
  String get campaignStarsLabel => 'Hvězdy';

  @override
  String get campaignRunInProgress => 'Tato kampaň už má rozehraný průběh.';

  @override
  String get campaignVerdictWon => 'Splněno';

  @override
  String get campaignVerdictLost => 'Tentokrát ne';

  @override
  String get campaignVerdictContinue => 'Pokračovat';

  @override
  String campaignProgressQualifying(String position) {
    return 'Kvalifikace: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Finále: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Průběh v číslech';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Vyhrané vzájemné zápasy: $won z $played';
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
  String get campaignGuineasTitle => 'Nejlepší Guinea';

  @override
  String get campaignGuineasTwist =>
      'Rovníková Guinea, nejmenší africká Guinea, na dva cykly';

  @override
  String get campaignGuineasGoal => 'Porazit Guineu i Guineu-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Jméno Guinea nesou tři africké země a Rovníková Guinea je z nich nejmenší. Máte dva cykly, abyste aspoň jednou porazili Guineu i Guineu-Bissau. Pak uvidíte, kam až to dotáhnete na Africkém šampionátu. Papua-Nová Guinea, ta čtvrtá Guinea, už s vámi má domluvený přátelský zápas.';

  @override
  String get campaignStars1Guineas => 'Porazit Guineu i Guineu-Bissau';

  @override
  String get campaignStars2Guineas => 'A postoupit na Africký šampionát';

  @override
  String get campaignStars3Guineas =>
      'A dojít do čtvrtfinále Afrického šampionátu';

  @override
  String get campaignYoungFinnsTitle => 'Mladí Finové';

  @override
  String get campaignYoungFinnsTwist =>
      'Zlatá generace finských teenagerů na tři cykly';

  @override
  String get campaignYoungFinnsGoal => 'Postoupit na mistrovství světa';

  @override
  String get campaignYoungFinnsIntro =>
      'Zkušení hráči Finska ustoupili stranou a jejich místo zaujala zlatá generace: každému hráči, kterého můžete povolat, je nejvýš 18 let. Dnes jsou ještě nevyzrálí, ale mají talent stát se jedním z nejlepších týmů světa, jako se to povedlo mladé generaci Norska. Máte tři cykly na to, abyste je dovedli na mistrovství světa a pak vyhráli mistrovství Evropy i mistrovství světa.';

  @override
  String get campaignStars1YoungFinns => 'Postoupit na mistrovství světa';

  @override
  String get campaignStars2YoungFinns => 'Vyhrát mistrovství Evropy';

  @override
  String get campaignStars3YoungFinns => 'Vyhrát mistrovství světa';

  @override
  String get campaignGreenlandTitle => 'Grónské století';

  @override
  String get campaignGreenlandTwist =>
      'Grónsko zaujímá místo San Marina v Evropě, na sto let';

  @override
  String get campaignGreenlandGoal => 'Postoupit na mistrovství Evropy';

  @override
  String get campaignGreenlandIntro =>
      'Grónsko nikdy nehrálo soutěžní mezistátní zápas. V tomto světě zaujalo místo San Marina v Evropě a začíná úplně na dně světového žebříčku: amatérští hráči, umělé trávníky a sezona vtěsnaná mezi sněhy. Máte sto let, tedy pětadvacet cyklů, abyste se dostali na mistrovství Evropy, pak na mistrovství světa a, pokud si troufnete snít, jedno z nich vyhráli.';

  @override
  String get campaignStars1Greenland => 'Postoupit na mistrovství Evropy';

  @override
  String get campaignStars2Greenland => 'Postoupit na mistrovství světa';

  @override
  String get campaignStars3Greenland => 'Vyhrát mistrovství Evropy nebo světa';

  @override
  String get campaignZanzibarTitle => 'Vzestup Zanzibaru';

  @override
  String get campaignZanzibarTwist =>
      'Zanzibar zaujímá místo Čadu v Africe, na sto let';

  @override
  String get campaignZanzibarGoal => 'Postoupit na Africký šampionát';

  @override
  String get campaignZanzibarIntro =>
      'Zanzibar má vlastní fotbalový svaz i vlastní reprezentaci, ale v africkém ani světovém fotbale nemá místo. V tomto světě zaujal místo Čadu v Africe a začíná blízko dna světového žebříčku: ostrovní hráči, malé stadiony a monzunové vedro. Máte sto let, tedy pětadvacet cyklů, abyste se dostali na Africký šampionát, pak na mistrovství světa a, pokud si troufnete snít, mistrovství světa vyhráli.';

  @override
  String get campaignStars1Zanzibar => 'Postoupit na Africký šampionát';

  @override
  String get campaignStars2Zanzibar => 'Postoupit na mistrovství světa';

  @override
  String get campaignStars3Zanzibar => 'Vyhrát mistrovství světa';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Nepostup';

  @override
  String get campaignCupOpen => 'Zatím nerozhodnuto';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name zazářil ve výběru $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Zpráva z akademie: $name upoutal pozornost';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Hvězda výběru $level: $name';
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
      other: '${count}krát',
      few: '${count}krát',
      one: 'jednou',
    );
    return '$name se v posledním reprezentačním termínu $_temp0 trefil za výběr $level. Soupeř: $opponent.';
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
      other: '$count gólů',
      few: '$count góly',
      one: 'gól',
    );
    return '$name vstřelil za výběr $level $_temp0. Soupeřem byl v tomto termínu tým $opponent.';
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
      other: '$count gólů',
      few: '$count góly',
      one: 'gól',
    );
    return 'Výběr $level se utkal se soupeřem $opponent a $name si připsal $_temp0.';
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
      other: '$count gólů',
      few: '$count góly',
      one: 'gól',
    );
    return '$name připravil za výběr $level $_temp0 a od začátku do konce řídil hru. Soupeř: $opponent.';
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
      other: '$count asistencí',
      few: '$count asistence',
      one: 'jedna asistence',
    );
    return 'Výběr $level se v tomto termínu utkal se soupeřem $opponent a nitky tahal $name: $_temp0 a výkon, o kterém trenéři pořád mluví.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name byl vynikající, když výběr $level udržel proti soupeři $opponent čisté konto.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Čisté konto výběru $level proti soupeři $opponent, a $name na něm měl největší podíl.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name zaujal ve výběru $level proti soupeři $opponent a trenéři jeho výkon ohodnotili známkou $mark z deseti.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'Výběr $level hrál v tomto termínu se soupeřem $opponent a trenéři vyzdvihli jedno jméno, $name: $mark z deseti, nejlepší známka v týmu.';
  }

  @override
  String get newsYouthDevReady1 =>
      'V této formě už je dost dobrý na to, abyste o něm uvažovali pro A-tým.';

  @override
  String get newsYouthDevReady2 =>
      'Trenéři věří, že je na seniorský fotbal připravený už teď. Rozhodnutí je na vás.';

  @override
  String get newsYouthDevClose1 =>
      'Dobře se vyvíjí a má blízko k průniku do seniorské reprezentace.';

  @override
  String get newsYouthDevClose2 =>
      'Do A-týmu mu už moc nechybí a jedna povedená sezona by mohla stačit.';

  @override
  String get newsYouthDevGrowing1 =>
      'Pěkně se rozvíjí, i když do A-týmu mu ještě krok nebo dva chybí.';

  @override
  String get newsYouthDevGrowing2 =>
      'Než z něj bude seniorský reprezentant, čeká ho ještě práce, ale všechno ukazuje správným směrem.';

  @override
  String get newsYouthDevRaw1 =>
      'Je ještě nehotový a od A-týmu ho dělí několik let, ale talent je zřejmý.';

  @override
  String get newsYouthDevRaw2 =>
      'Je to teprve začátek a trenéři z akademie žádají spíš trpělivost než titulky.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Odlišuje ho dosah a to, jak velí svému vápnu.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Chytání a rozehrávku má nejlepší, jaké akademie za poslední roky viděla.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Koncentrace mu nikdy nepoleví a v devadesáté minutě je stejně ostrý jako v první.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Klíčem k jeho hře jsou rychlost a síla ve vzduchu.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Čte hru daleko nad svůj věk a s míčem je klidný.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Nikdy nevypne a i v poslední minutě sprintuje zpátky.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Míče získává s opravdovou silou a hned s nimi táhne dopředu.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Klíčem k jeho hře jsou přehled a rozsah přihrávek.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Má neuvěřitelnou fyzičku: oběhá každé stéblo trávy.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Rychlostí do uliček a silou ve vzduchu trápí každou obranu.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Klíčem k jeho hře jsou zakončení a pohyb ve vápně.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Celý zápas presuje od první linie a obráncům nedá ani chvilku klidu.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Na zápas se soupeřem $opponent budou fanoušci ještě dlouho vzpomínat. Co jste hráčům řekl po závěrečném hvizdu?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Proti soupeři $opponent to bylo jasné prohlášení. Kolik z toho vzniklo na tréninku?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Uznání za výsledek proti soupeři $opponent, ale takové večery jsme už zažili. Co je tentokrát jinak?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Špatný večer má každý a tohle byl jeden takový proti soupeři $opponent. Jak rychle to dokážete hodit za hlavu?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return 'Soupeř $opponent byl lepší ve všech ohledech. Kde začnete s opravami?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Fanoušci odcházeli ze stadionu ještě před koncem zápasu se soupeřem $opponent. Můžete se jim divit?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Je to těžké období a soupeř $opponent ho nijak neulehčil. Co vás drží nad vodou?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Další zápas bez výhry, tentokrát proti soupeři $opponent. Jak dlouho to ještě může trvat, než vedení zasáhne?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Teď i soupeř $opponent. Zbývá ve vašem plánu ještě něco, nebo je čas uvolnit místo někomu jinému?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Ať napíšete cokoli, pište to o hráčích. Zaslouží si to.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Mám partu, která by jeden za druhého skočila do ohně. To není málo.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Rozhoduju já, takže kritika patří mně. Taková je to práce.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Nejdřív se podívejte na trenéra. Něco jsem pokazil a dám to do pořádku.';

  @override
  String get pressReplyDemandMore5 =>
      'Dobrý výkon tady nestačí. Řekl jsem jim to do očí.';

  @override
  String get pressReplyDemandMore6 =>
      'Nikdo v kabině nemá místo v sestavě jisté. Teď už to vědí.';

  @override
  String get pressReplyDeflect5 =>
      'Můžete se zeptat třikrát jinak. Odpověď bude pořád stejná.';

  @override
  String get pressReplyDeflect6 =>
      'Své myšlenky si nechám pro hráče. Jistě to pochopíte.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$opponent $score. Klidný, vyzrálý fotbal pod kontrolou. Takhle se mi to líbí.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$score a ani jsme se nezapotili, soupeř $opponent neměl šanci. Nuda vyhrává tituly.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Tři body, žádné drama, zpátky do práce.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Rutinní $score, soupeř $opponent. Nikdo si to nebude pamatovat a nikdo nemusí.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$opponent $score a já mám i tak obavy.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$score, soupeř $opponent. Proti pořádnému týmu by nás za takový výkon potrestali.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$opponent $score. Zakousli jsme se, trpěli a vyhráli. Tohle je tým.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$score jen na nervy, soupeř $opponent. Tým, který odmítá prohrát, beru.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Rozhodlo se až v závěru, ale body jsou naše.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Těsné $score, soupeř $opponent. Moc v tom nebylo, ale to je fotbal.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$opponent $score. Jeden šťastný odskok na druhou stranu a teď bychom se bavili úplně jinak.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return '$score, soupeř $opponent, a doklepali jsme to jen tak tak. Tomu nikdo neříkejte výkon.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$opponent $score. Není to prohra a někdy je to přesně ono.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Vybojovaný bod, soupeř $opponent, $score. Ta bojovnost se mi líbila.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Spravedlivá dělba bodů, jak říkávali staří komentátoři.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score, soupeř $opponent. Ani jeden tým neudělal dost na víc.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score, soupeř $opponent. Remíza, která v autobuse domů chutná jako prohra.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return '$opponent $score. Pořád mluvíme o pokroku a pořád hrajeme tohle.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$opponent $score. Bolí to, ale viděl jsem dost na to, abych tomuhle týmu věřil.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Prohra $score a soupeř $opponent byl dobrý. Uznat a jít dál.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Porážka, pár ponaučení a další zápas brzy.';
  }

  @override
  String yLost15(String opponent, String score) {
    return '$score, soupeř $opponent. Těžko se s tím hádat.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$opponent $score. Stejné chyby jako minule, se stejnou sebejistotou.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Prohra $score, soupeř $opponent. Jestli za to nikdo neponese odpovědnost, co tu vlastně děláme?';
  }

  @override
  String get yReactionShrug12 =>
      'Mně to stačí. Ne každý večer musí být ohňostroj.';

  @override
  String get yReactionShrug13 => 'Body jsou body. Dneska se vyspím dobře.';

  @override
  String get yReactionShrug14 => 'Viděl jsem. Bez poznámek.';

  @override
  String get yReactionShrug15 => 'Někde mezi v pohodě a v pohodě.';

  @override
  String get yReactionShrug16 =>
      'Kvůli tomuhle jsem si platil stream. Už nikdy (zase přijdu).';

  @override
  String get yReactionShrug17 =>
      'Devadesát minut něčeho, co se fotbalu jen podobalo.';

  @override
  String get yReactionRelief12 =>
      'Zase dýchám. Jsem na ně hrdý, že to udrželi.';

  @override
  String get yReactionRelief13 =>
      'Takové výhry stmelují tým. Ošklivé je krásné.';

  @override
  String get yReactionRelief14 => 'Nehty jsou pryč, ale body ne.';

  @override
  String get yReactionRelief15 => 'Závěrečný hvizd nikdy nezněl líp.';

  @override
  String get yReactionRelief16 =>
      'Jsem rád, že jsme vyhráli, ale bojím se toho, jak.';

  @override
  String get yReactionRelief17 => 'Pořád nám to prochází. Jednou nebude.';

  @override
  String get yReactionFury12 => 'Tenhle tým miluju, a právě proto to tak bolí.';

  @override
  String get yReactionFury13 => 'Špatný večer. Příště nám to dluží a vědí to.';

  @override
  String get yReactionFury14 =>
      'V sedmdesáté minutě jsem to vypnul. Měl jsem v šedesáté.';

  @override
  String get yReactionFury15 => 'Žádný boj, žádné nápady, žádné výmluvy.';

  @override
  String get yReactionFury16 => 'Pokaždé stejné problémy a nikdo nic neopraví.';

  @override
  String get yReactionFury17 =>
      'Někdo na svazu by si to měl pustit znovu a vysvětlit nám to.';

  @override
  String get backupShareHint =>
      'Vytvoří jeden soubor se všemi uloženými hrami. Uložte ho na Disk Google, iCloud Drive nebo do Souborů.';

  @override
  String backupLastAt(String date) {
    return 'Poslední záloha: $date';
  }

  @override
  String get backupNever => 'Zatím žádná záloha';

  @override
  String get backupRemindersTitle => 'Připomínky zálohy';

  @override
  String get backupRemindersBlurb =>
      'Zpráva ve schránce, když je poslední záloha už stará.';

  @override
  String get backupAutoICloudTitle => 'Automatická záloha na iCloud';

  @override
  String get backupAutoDriveTitle => 'Automatická záloha na Disk Google';

  @override
  String get backupAutoBlurb =>
      'Zálohuje po zápasech, na konci cyklu a když aplikaci opustíte. Ponechá poslední dvě zálohy.';

  @override
  String get backupStatusUploading => 'Probíhá záloha.';

  @override
  String get backupStatusUploaded => 'Zálohováno.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud je vypnutý. V aplikaci Nastavení se přihlaste k iCloudu a zapněte iCloud Drive.';

  @override
  String get backupStatusDriveSignedOut =>
      'Nejste přihlášeni. Zapnutím přepínače se přihlásíte přes Google.';

  @override
  String get backupStatusNotConfigured =>
      'V této verzi aplikace zatím není k dispozici.';

  @override
  String get backupStatusUnavailable =>
      'Cloud teď není dostupný. Zkusí to znovu později.';

  @override
  String get backupStatusFailed =>
      'Poslední automatická záloha se nepovedla. Zkusí to znovu později.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Přihlášeno jako $email';
  }

  @override
  String get backupDriveSignOut => 'ODHLÁSIT';

  @override
  String get backupDriveSignInFailed =>
      'Přihlášení přes Google se nepovedlo. Zkuste to později.';

  @override
  String get backupRestoreICloud => 'OBNOVIT Z ICLOUDU';

  @override
  String get backupRestoreDrive => 'OBNOVIT Z DISKU GOOGLE';

  @override
  String get backupCrossPlatformHelp =>
      'Přecházíte mezi iPhonem a Androidem? Na jednom telefonu zálohujte do souboru a na druhém z něj obnovte.';

  @override
  String get backupCloudListBlurb =>
      'Zálohy z vašich zařízení na tomto účtu. Klepnutím zálohu obnovíte.';

  @override
  String get backupCloudListEmpty =>
      'Zatím žádné zálohy. Nová záloha může do jiného zařízení dorazit až za pár minut.';

  @override
  String get backupCloudListFailed =>
      'Zálohy se nepodařilo načíst. Zkontrolujte připojení a zkuste to znovu.';

  @override
  String get backupCloudThisDevice => 'Toto zařízení';

  @override
  String backupCloudMore(int count) {
    return 'Další uložené hry: $count';
  }

  @override
  String get backupCloudNewer =>
      'Vytvořeno novější verzí aplikace. Nejdřív aktualizujte.';

  @override
  String get backupCloudDownloading => 'Stahuji zálohu.';

  @override
  String get backupRestoreSafetyNote =>
      'Kopie uložených her z tohoto telefonu se nejdřív uschová v tomto telefonu.';

  @override
  String get backupRejectedSafety =>
      'Kopii současných uložených her se nepodařilo uschovat, takže se nic nenahradilo.';

  @override
  String get newsBackupReminderTitle => 'Čas na zálohu';

  @override
  String get newsBackupReminderBody =>
      'Vaše uložené hry jsou jen v tomto telefonu. Otevřete Nastavení a klepněte na Zálohovat do cloudu, nebo tam zapněte automatickou zálohu. Tyto připomínky lze v Nastavení také vypnout.';

  @override
  String get backupSafetyTitle => 'Kopie z doby před obnovou';

  @override
  String get backupSafetyBlurb =>
      'Uschované v tomto telefonu pro případ, že obnova byla omyl. Ponechají se tři nejnovější.';

  @override
  String get backupSafetyRestore => 'OBNOVIT';

  @override
  String get backupSafetyShare => 'SDÍLET';

  @override
  String get saveUpgradeFailedTitle =>
      'Uloženou hru se nepodařilo aktualizovat';

  @override
  String get saveUpgradeFailedBody =>
      'Uloženou hru se nepodařilo aktualizovat. Nic nebylo smazáno a kopie z doby před aktualizací zůstala v tomto telefonu.';

  @override
  String get saveUpgradeRestoreButton =>
      'Obnovit kopii z doby před aktualizací';

  @override
  String get saveUpgradeRestoreFailed =>
      'Kopii se nepodařilo obnovit. Uložená hra zůstala, jak byla.';

  @override
  String get saveOpenFailedTitle => 'Uložené hry se nepodařilo otevřít';

  @override
  String get saveOpenFailedBody =>
      'Uložené hry se nepodařilo otevřít. Nic nebylo smazáno. Zkuste to za chvíli znovu.';

  @override
  String get backupCloudNoDetails => 'Podrobnosti jsou ještě na cestě.';

  @override
  String get tacticsLibraryTitle => 'KNIHOVNA TAKTIK';

  @override
  String get tacticsLibraryBlurb =>
      'Taktiky z knihovny můžete načíst v jakékoli uložené hře, i v nové. Role a exekutoři standardek se ukládají podle pozice, ne podle hráče.';

  @override
  String get tacticsSaveToLibrary => 'Uložit do knihovny';

  @override
  String get tacticsLoadFromLibrary => 'Načíst z knihovny';

  @override
  String get tacticsLibraryEmpty =>
      'Knihovna je prázdná. Uložte do ní taktiku a budete ji moct načíst v každé uložené hře.';

  @override
  String tacticsLibrarySaved(String name) {
    return 'Uloženo do knihovny: „$name“';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Načteno „$name“';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count rolí nebo exekutorů standardek nešlo v tomto kádru obsadit.',
      few: '$count role nebo exekutory standardek nešlo v tomto kádru obsadit.',
      one: '1 roli nebo exekutora standardek nešlo v tomto kádru obsadit.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Přejmenovat';

  @override
  String get tacticsLibraryRenameTitle => 'Přejmenovat taktiku';

  @override
  String get tacticsLibraryDelete => 'Smazat';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Smazat „$name“?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Zmizí z knihovny ve všech vašich uložených hrách.';

  @override
  String get tacticsLibraryNameTaken =>
      'Taktika s tímto názvem už v knihovně je.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Knihovnu se nepodařilo načíst.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Kandidatura na pořadatelství: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Kandidatura';

  @override
  String get hostBidBlurb =>
      'Pořadatele určí los mezi kandidáty. Kandidatura dá vašemu jménu větší váhu: stadiony vám zajistí výchozí šanci a peníze ji zvýší, přičemž každý další milion přidá o něco méně. Peníze jsou utracené, ať uspějete, nebo ne.';

  @override
  String hostBidPrize(String amount) {
    return 'Když vyhrajete, budete pořádat, postoupíte automaticky a dostanete jednorázový příspěvek $amount do příštího rozpočtu.';
  }

  @override
  String get hostBidChance => 'Šance na pořadatelství';

  @override
  String get hostBidBaseLabel => 'Stadiony a postavení';

  @override
  String get hostBidInvestLabel => 'Investice';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Strop pro $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Vaše investice';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Volné prostředky: $amount';
  }

  @override
  String get hostBidSubmit => 'Podat kandidaturu';

  @override
  String get hostBidDecline => 'Tentokrát ne';

  @override
  String get hostBidUnavailable => 'Tato kandidatura už není otevřená.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Kandidatura uspěla: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Turnaj budeme pořádat a jako pořadatelé postupujeme automaticky. Jednorázový příspěvek $amount je už ve fondech svazu a z centra ho můžete rovnou rozdělit do oddělení v tomto cyklu.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Kandidatura neuspěla: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Pořadatelství získali: $hosts. Naše kandidatura tentokrát nestačila a peníze do ní vložené jsou pryč, ale svaz se ukázal.';
  }

  @override
  String get hostBidGrantEvent => 'Rozdělit pořadatelský příspěvek';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Pořadatelský příspěvek: $amount můžete hned přidat do oddělení v tomto cyklu. Co už je rozděleno, zůstává; co zbude, zůstane v pokladně.';
  }

  @override
  String get stadiumsTitle => 'Národní stadiony';

  @override
  String get stadiumsEntrySub => 'Vylepšete stadion, nebo postavte nový';

  @override
  String get stadiumsBlurb =>
      'Úroveň stadionu odpovídá jeho velikosti: úroveň 1 pod 15 000 míst, úroveň 2 od 15 000, úroveň 3 od 25 000, úroveň 4 od 40 000, úroveň 5 od 60 000. Každý stadion na začátku cyklu vydělá malý příjem, víc za víc míst, dokud je fanoušci zaplní. Vylepšení přidá místa hned a od dalšího cyklu i trochu reputace; zmenšení sníží provozní náklady, ale nic se nevrací. Na vašich stadionech závisí, o které turnaje se můžete ucházet.';

  @override
  String stadiumsIncome(String amount) {
    return 'Příjem ze stadionů: $amount za cyklus';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Reputace ze stadionů: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Stavební práce se objednávají na začátku cyklu, než rozdělíte rozpočet.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Kapacita: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Úroveň $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Vylepšit: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Nejvyšší úroveň';

  @override
  String stadiumsOpens(int year) {
    return 'Ve výstavbě, otevře se v roce $year';
  }

  @override
  String get stadiumsBuildTitle => 'Postavit nový stadion';

  @override
  String get stadiumsBuildBody =>
      'Docela drahé: nový stadion ve městě podle vašeho výběru, otevřený od začátku příštího cyklu.';

  @override
  String get stadiumsBuildCity => 'Město';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Postavit: $cost';
  }

  @override
  String get stadiumsBuilding => 'Jeden stadion už se staví.';

  @override
  String get stadiumsNoCity => 'Každé město už má nový stadion.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Vylepšit $stadium na úroveň $level za $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Postavit nový stadion za $cost? Město: $city';
  }

  @override
  String get stadiumsConfirm => 'Potvrdit';

  @override
  String get stadiumsCancel => 'Zrušit';

  @override
  String get stadiumsRefused => 'Objednávka neprošla. Nic se nezaplatilo.';

  @override
  String get stadiumsNameLabel => 'Název stadionu';

  @override
  String get stadiumsNameHint =>
      'Když pole necháte prázdné, zůstane navržený název.';

  @override
  String get stadiumsRename => 'Přejmenovat stadion';

  @override
  String get hostBidSectionTitle => 'Kandidatury na pořadatelství';

  @override
  String get hostBidOpenSub =>
      'Nepovinné. Rozhodněte před začátkem nového cyklu.';

  @override
  String get hostBidDecidedAtRollover =>
      'Pořadatel bude oznámen se začátkem nového cyklu.';

  @override
  String get hostBidLodged =>
      'Kandidatura podána. Pořadatel bude oznámen se začátkem nového cyklu.';

  @override
  String get hostBidDeclinedNote => 'Tentokrát jste se rozhodli nekandidovat.';

  @override
  String get hostBidOpensLater =>
      'Splňujete podmínky. Kandidovat můžete na konci tohoto cyklu.';

  @override
  String get hostBidNoFunds => 'Na kandidaturu nemáte dost volných prostředků.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chybějící stadiony s kapacitou $seats+ míst: $count.',
      one: 'Chybí vám ještě 1 stadion s kapacitou $seats+ míst.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation pořádala minulé Mistrovství světa.';
  }

  @override
  String get hostBidRecentHost =>
      'Pořádali jste jeden z posledních tří ročníků.';

  @override
  String get hostBidBelowBar =>
      'Vaše stadiony nesplňují požadavky tohoto turnaje.';

  @override
  String get hostBidRulesPending =>
      'Zda můžete kandidovat, bude jasné, až budou oznámeni pořadatelé tohoto cyklu.';

  @override
  String get hostBidBackToBack =>
      'Pořádáte turnaj bezprostředně před tímto. Žádná země nepořádá dva turnaje po sobě.';

  @override
  String get hostBidOneOnly =>
      'Už jste kandidovali na druhý turnaj. Žádná země nepořádá dva turnaje po sobě, proto můžete kandidovat jen na jeden.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Podmínka: stadiony s kapacitou $minSeats+ míst: $grounds, z toho $bigSeats+ míst: $bigGrounds.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Turnaj uspořádáme a jako pořadatel máme jistou účast. Jednorázová dotace $amount už je v prostředcích svazu a čeká na rozpočet tohoto cyklu.';
  }

  @override
  String get hubStadiumIncome => 'Příjmy ze stadionů';

  @override
  String get stadiumsDownsize => 'Zmenšit';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Zmenšit $stadium na $seats míst (úroveň $level)? Nic se nevrací, ale klesnou náklady na provoz.';
  }

  @override
  String get stadiumsResizedThisCycle => 'V tomto cyklu už přestavěn';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Vydělá $amount za cyklus';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Kandidatura stažena: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Kandidatura byla podána za tým $nation, ale nový cyklus začínáte jinde. Byla stažena a nic se nestrhlo.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'Na konci cyklu už prostředky svazu na vklad nestačily. Kandidatura byla stažena a nic se nestrhlo.';

  @override
  String get stadiumsViewMap => 'Mapa';

  @override
  String get stadiumsViewList => 'Seznam';

  @override
  String get stadiumsMapPickCity =>
      'Klepněte na město, kde chcete postavit nový stadion.';

  @override
  String get stadiumsMapFit => 'Zobrazit celou zemi';

  @override
  String get campaignLegacyTitle => 'Dokonat odkaz';

  @override
  String get campaignLegacyTwist =>
      'Španělsko, úřadující mistři Evropy, na jeden cyklus';

  @override
  String get campaignLegacyGoal => 'Obhájit evropský titul';

  @override
  String get campaignLegacyIntro =>
      'Španělsko je úřadujícím mistrem Evropy a pochybovači tvrdí, že zlatá éra byla jen náhoda. Máte jeden cyklus na to, abyste dokázali opak: obhajte kontinentální korunu a pak se vydejte pro svět. Přidejte Pohár národů a odkaz bude dokonán.';

  @override
  String get campaignStars1Legacy => 'Vyhrát mistrovství Evropy';

  @override
  String get campaignStars2Legacy => 'A k tomu mistrovství světa';

  @override
  String get campaignStars3Legacy => 'A k tomu Pohár národů';

  @override
  String get campaignSectionOneCycle => 'Jeden cyklus';

  @override
  String get campaignSectionShort => 'Pár cyklů';

  @override
  String get campaignSectionLong => 'Na dlouhou trať';

  @override
  String get campaignFilterAll => 'Vše';

  @override
  String get campaignFilterNew => 'Nehrané';

  @override
  String get campaignFilterInProgress => 'Rozehrané';

  @override
  String get campaignFilterDone => 'Dokončené';

  @override
  String get campaignFilterEmpty => 'Tady zatím žádné kampaně nejsou.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hvězd',
      few: '$count hvězdy',
      one: '1 hvězda',
      zero: 'Bez hvězd',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cyklů',
      few: '$cycles cykly',
      one: '1 cyklus',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Odchází na vrcholu, jako šampion.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Nepostup na závěrečný turnaj byl poslední kapkou.';

  @override
  String get msgIntlRetireNoteSurprise => ' Nikdo to nečekal.';

  @override
  String get msgIntlRetireNoteRecord => ' Odchází jako národní rekordman.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name končí v reprezentaci';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) oznámil ve $age letech konec reprezentační kariéry.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name se vrací do reprezentace';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name je ve $age letech znovu k dispozici pro nominaci.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Kádr sužují zranění a on vyslyšel volání.';

  @override
  String get msgIntlComebackNoteManager => ' Nový trenér ho přemluvil.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name se vrací do reprezentace';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) je ve $age letech znovu k dispozici pro nominaci.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Ukončil reprezentační kariéru, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Návrat do reprezentace, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Díky, $name. Někdo dres jen nosí, on ho nesl.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name končí v reprezentaci. Konec jedné éry.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name končí. Upřímně, o turnaj později, než měl.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Takže $name končí. Ať to teď zkusí mladí.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Nadmořská výška $altitudeString m: soupeř se unaví rychleji';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Nadmořská výška $altitudeString m: vaši hráči se unaví rychleji';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Nadmořská výška $altitudeString m: oba týmy se unaví rychleji';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Nadmořská výška $altitudeString m: oba týmy jsou na ni zvyklé';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Vedro: očekává se $tempString °C, síly dojdou dřív';
  }

  @override
  String get matchConditionsAdvice =>
      'Střídejte včas: čerstvé nohy tu znamenají víc';

  @override
  String get fanMoodFurious => 'rozzuření';

  @override
  String get fanMoodRestless => 'nervózní';

  @override
  String get fanMoodCalm => 'klidní';

  @override
  String get fanMoodUpbeat => 'spokojení';

  @override
  String get fanMoodEuphoric => 'v euforii';

  @override
  String matchHomeFans(String mood) {
    return 'Domácí fanoušci: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Fanoušci: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Příjem ze stadionů v příštím cyklu: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Dvacet let jezdím za reprezentací doma i venku. Permanentku si neprodloužím, dokud se něco nezmění.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Za dres budeme zpívat dál. Ale ten transparent na severní tribuně dnes řekl, co si myslíme všichni.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Půlka stadionu prázdná a ta druhá půlka celý druhý poločas skandovala #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Fanouškovské skupiny mluví o bojkotu příštího domácího zápasu. Těžko se jim divit.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Už ani nejsem naštvaný. Prostě konec.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Fotka z dnešního večera: řady prázdných sedaček a jedno prostěradlo s nápisem #${manager}Out. Lepší reportáž nebude.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Zase vyprodáno. Nejlepší reprezentace za poslední roky a celá země to ví.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Příští domácí zápas byl vyprodaný za jedenáct minut. Tenhle tým nám vrátil víkendy.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Na příští domácí zápas není jediné volné místo. Svaz bude počítat vstupné s úsměvem.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Další vyprodaný zápas. Říkejte si o taktice, co chcete, lidi na ten stadion chtějí.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Vyprodáno, dobře. Ti samí lidi na ně před rokem a půl pískali.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Najednou vyprodáno, najednou samí odborníci. Kde jste všichni byli, když jsme nedokázali porazit nikoho?';
  }

  @override
  String get campaignsIntro =>
      'Kampaně jsou připravené výzvy: daný národ, svět s vlastním zvratem a cíl, kterého je třeba dosáhnout v pevném počtu cyklů. Každý průběh se hraje odděleně od uložených kariér a čím dál se dostanete, tím víc hvězd získáte, až tři.';

  @override
  String hubEventScandal(String player) {
    return 'Skandál v kempu: $player';
  }

  @override
  String get hubEventScandalSub => 'Poslat ho domů, nebo si ho nechat?';

  @override
  String get scandalTitle => 'SKANDÁL V KEMPU';

  @override
  String scandalStoryParty(String player) {
    return '$player byl na večírku, který skončil až za svítání, a ráno, kdy se kádr sešel, byly fotky ve všech novinách.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player porušil večerku a přistihli ho, jak se nad ránem vrací do hotelu.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player byl v předvečer srazu vyfocen v nočním klubu a fotky jsou všude.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player strávil noc před srazem u kasinového stolu a bulvár má fotky.';
  }

  @override
  String get scandalSendHome => 'Poslat ho domů';

  @override
  String scandalSendHomeCover(String player) {
    return 'Poslat domů, povolat: $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Ponechat hráče $player';
  }

  @override
  String get scandalKeepNote =>
      'Ponecháte-li ho: morálka kádru zhruba -4 a vedení zhruba -3 do konce cyklu.';

  @override
  String get scandalSendHomeNote =>
      'Pošlete-li ho domů: morálka ani vedení neutrpí a můžete povolat náhradu.';

  @override
  String get scandalFinalsNote =>
      'Pošlete-li ho domů: morálka ani vedení neutrpí, ale na závěrečném turnaji ho nikdo nenahradí.';

  @override
  String get scandalPickCover => 'Povolat náhradu (nepovinné)';

  @override
  String newsScandalTitle(String player) {
    return 'Skandál v kempu: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Kluci jsou kluci. $player na večírku den před srazem, a stejně ho chci vidět na hřišti. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player vyfocen na celonoční párty pár hodin před srazem reprezentace. Svaz o tom ví. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Celonoční párty před srazem. $player, co sis myslel? Neuvěřitelné. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Po večerce, no jo, stává se. $player to musí napravit na hřišti. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player přistižen při návratu do týmového hotelu po večerce, pár hodin před tréninkem. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Večerka není složitá věc. $player nevydržel ani jednu noc. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Tak byl $player v klubu. Fotbalisti mají taky život. Nechte ho hrát. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Fotky ukazují hráče $player v nočním klubu v předvečer reprezentačního srazu. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Fotky z klubu v předvečer srazu. $player udělal dresu ostudu. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Noc v kasinu není zločin. $player to zvládne. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player spatřen u kasinového stolu noc před srazem reprezentace. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Celou noc v kasinu před srazem. $player prohrál víc než peníze. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Správné rozhodnutí. Nikdo není víc než tým, ani $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Poslat hráče $player domů byla jediná odpověď. Klobouk dolů před trenérem.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Disciplína je disciplína. $player pravidla znal.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Jasný vzkaz kabině: $player jede domů.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Tvrdé na hráče $player. Jedna noc venku a končí mu sraz?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Poslat hráče $player domů nás oslabí. Na hřišti to zaplatíme.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Ponechat hráče $player je sázka. Ať ji na hřišti splatí.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Dobře, $player zůstává. Pak všem dluží výkon.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Takže na hráče $player pravidla neplatí. Dobré vědět.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Večerka je teď zřejmě dobrovolná. Viz $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Po tomhle si hráče $player nechat? Z kádru je rekreační tábor.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Celou noc pařit a pak rovnou do základu. Skvělý vzkaz, trenére. $player má radost.';
  }

  @override
  String get yStreamerBreaks0 =>
      'BRÁCHO NACHYTALI HO 😭😭 NOC PŘED SRAZEM?? BREČÍM 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'NEEE CHATE KOUKEJTE NA TOHLE 🤯🤯 BRÁCHA TO FAKT UDĚLAL PŘED SRAZEM 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'KDO HO PUSTIL VEN?? KDO HO PUSTIL 😭😭💀 TOHLE JE KINO 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'DOMŮ?? POSLALI HO DOMŮŮŮ 😭😭😭 TRENÉR SE NEPÁRÁ 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'BRÁCHA SI BALÍ KUFRY NAŽIVO 🤯🤯 SBOHEM BRÁCHO 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'TO NENÍ MOŽNÝÝÝ OPRAVDU HO POSLALI DOMŮ 💀💀 CHATE JÁ SE KLEPU 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'ZŮSTÁVÁ??? ZŮSTÁVÁÁÁ 🤯🤯 BRÁCHA JE NEDOTKNUTELNEJ 😭🔥';

  @override
  String get yStreamerKept1 =>
      'CELOU NOC PAŘBA A POŘÁD V KÁDRU 💀💀 TU SMLOUVU CHCI TAKY 😭😭';

  @override
  String get yStreamerKept2 =>
      'TRENÉR ŘEKL, ŽE JE TO V POHODĚ 😭😭 BRÁCHO CO 🤯🤯🤯';

  @override
  String get yCameoUjfaloci => 'Nic jsem neplatil a ta částka taky nesouhlasí';

  @override
  String get yCameoHavir0 => 'Kapříci uplavali.';

  @override
  String get yCameoHavir1 => 'Sítě jsme natáhli, ryby byly jinde.';

  @override
  String get yCameoHavir2 => 'Já to říkal už v září u guláše.';

  @override
  String get yCameoHavir3 => 'Kdo včas nevylovil, ať teď nebrečí.';

  @override
  String get yCameoHavir4 => 'Hráli jsme jako sumec na suchu.';

  @override
  String get yCameoHavir5 => 'Vítr fouká, rybník zamrzá. Tak už to chodí.';

  @override
  String get yCameoHavir6 => 'Holt někdy vytáhnete jen starou holínku.';

  @override
  String get yCameoHavir7 =>
      'Za mých časů se šlo aspoň na pivo. Teď ani to ne.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Poslat kluka domů kvůli jedné noci? To je ten skandál, ne nějaká párty!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Kluci se snad můžou trochu pobavit! Pokrytecká média zase vyhrála.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Hon na čarodějnice. Mladej si jednou vyrazí a hned ho věšíte.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Kdo z novinářů nikdy nebyl na večírku, ať hodí kamenem. Hanba!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Trenér se lekl bulváru. Já bych kluka bránil do posledního dechu!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Konečně trenér s páteří! Nechal kluka v kádru a média ať brečí.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Kluci se snad můžou trochu pobavit, ne? Bravo, trenére!';

  @override
  String get yCameoLzimberskyKept2 =>
      'Pokrytecká média řvou, trenér drží lajnu. Tak se to dělá!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Jedna noc venku a novináři by ho nejradši ukamenovali. Trenér je chlap!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Já říkám: nechte kluky žít! Kdo maká, ten se může i bavit. Palec nahoru.';

  @override
  String get yCameoMarena => 'To bych mohla trénovat i já';

  @override
  String get yCameoKralik => 'Tak cos čekal hehehe, kupuj naše ZeroZero';

  @override
  String get yCameoPosuk0 => 'SLABOTA';

  @override
  String get yCameoPosuk1 => 'TY CIWE';

  @override
  String get yCameoPosuk2 => 'Nekdo do knajpy?';

  @override
  String get yTraitStreamer => 'Streamuje všechno, naplno a velkými písmeny.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Hráč roku $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Hlasy jsou sečteny';

  @override
  String get potyCeremonyWatch => 'Sledovat ceremoniál';

  @override
  String get potyCeremonySkipToList => 'Přeskočit na první pětku';

  @override
  String get potyCeremonySkip => 'Přeskočit';

  @override
  String get potyCeremonyIntro =>
      'Hlasy jsou sečteny. Toto je pět nejlepších hráčů světa za letošní rok.';

  @override
  String potyCeremonyPlace(int place) {
    return '$place. místo';
  }

  @override
  String get potyCeremonyWinnerIs => 'A hráčem roku se stává...';

  @override
  String get potyTop5Heading => 'Světová první pětka';

  @override
  String get potyYoungTop3Heading => 'Mladý hráč roku: první trojka';

  @override
  String get potySeeTop5 => 'Zobrazit první pětku';

  @override
  String get potyYourPlayer => 'Váš hráč';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count čistých kont',
      few: '$count čistá konta',
      one: '1 čisté konto',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Celé zadání';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Zatím získané hvězdy: $earned z $total';
  }

  @override
  String get campaignStarEarned => 'Zatím získáno';

  @override
  String get campaignStarNotYet => 'Zatím nezískáno';

  @override
  String get stadiumsEntrySubClosed =>
      'Prohlédněte si své stadiony. Stavební práce lze znovu objednat na začátku dalšího cyklu.';

  @override
  String get boardObjectiveNoBrief => 'Bez stanoveného cíle';

  @override
  String get boardObjectiveNoBriefBody =>
      'Vedení od vás postup na tento závěrečný turnaj nečeká. Bude vás místo toho hodnotit podle výsledků.';

  @override
  String get boardObjectiveAwaitingDraw => 'Cíl až po losování';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Vedení tento cíl stanoví, jakmile se vylosují skupiny.';

  @override
  String tourThirdsNextAdvance(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dalších $count týmů jde do $destination',
      few: 'Další $count týmy jdou do $destination',
      one: 'Další tým jde do $destination',
    );
    return '$_temp0';
  }

  @override
  String yWinEuphoric0(String opponent, String score) {
    return 'Neuvěřitelný večer. Tohle by nás nenapadlo ani v nejdivočejších snech. $score proti $opponent!';
  }

  @override
  String yWinEuphoric1(String opponent, String score) {
    return '$score proti $opponent. Štípněte mě. Prosím, ať mě někdo štípne.';
  }

  @override
  String yWinEuphoric2(String opponent, String score) {
    return 'Brečím na tribuně. $score proti $opponent. Tenhle tým miluju.';
  }

  @override
  String yWinEuphoric3(String opponent, String score) {
    return '$score proti $opponent. Nejlepší večer mého fanouškovského života, a s přehledem.';
  }

  @override
  String yWinEuphoric4(String opponent, String score) {
    return '$score proti $opponent. Jeden z největších výsledků v dějinách téhle země.';
  }

  @override
  String yWinEuphoric5(String opponent, String score) {
    return '$score proti $opponent. Tohle nečekal nikdo na světě. Historie.';
  }

  @override
  String yWinEuphoric6(String opponent, String score) {
    return '$score proti $opponent. O tomhle se bude mluvit ještě desítky let.';
  }

  @override
  String yWinEuphoric7(String opponent, String score) {
    return 'Zapamatujte si, kde jste dnes byli: $score proti $opponent.';
  }

  @override
  String yWinEuphoric8(String opponent, String score) {
    return 'Celý rok jsem remcal a zítra budu zase. Ale dnes? $score proti $opponent. Neuvěřitelné.';
  }

  @override
  String yWinEuphoric9(String opponent, String score) {
    return 'Ani já nenacházím, na co si stěžovat. $score proti $opponent. Šílenost.';
  }

  @override
  String yWinEuphoric10(String opponent, String score) {
    return '$score proti $opponent. Říkal jsem, že tenhle tým je odepsaný. Ještě nikdy jsem se tak rád nemýlil.';
  }

  @override
  String yWinEuphoric11(String opponent, String score) {
    return 'Dobře, přiznávám: $score proti $opponent je jako ze snu. Příští týden asi zase postaru.';
  }

  @override
  String yDrewGiant0(String opponent, String score) {
    return '$score proti $opponent. Jedním slovem: neuvěřitelné!';
  }

  @override
  String yDrewGiant1(String opponent, String score) {
    return 'Bod proti jednomu z nejlepších týmů světa. Ten bereme všemi deseti. $score proti $opponent.';
  }

  @override
  String yDrewGiant2(String opponent, String score) {
    return 'Remíza $score s týmem $opponent! Nemám hlas a je mi to jedno.';
  }

  @override
  String yDrewGiant3(String opponent, String score) {
    return '$score proti $opponent. Remíza? Připadá mi to, jako bychom vyhráli všechno.';
  }

  @override
  String yDrewGiant4(String opponent, String score) {
    return 'Bod proti týmu, jako je $opponent, se nečekal, ale rozhodně ho bereme. $score, skvělý výsledek.';
  }

  @override
  String yDrewGiant5(String opponent, String score) {
    return '$score proti $opponent. Bod, na který se bude vzpomínat roky.';
  }

  @override
  String yDrewGiant6(String opponent, String score) {
    return '$opponent přijel jako jasný favorit a odjel s výsledkem $score. Hrdý večer.';
  }

  @override
  String yDrewGiant7(String opponent, String score) {
    return '$score proti $opponent. Týmy naší úrovně jim body skoro nikdy neseberou.';
  }

  @override
  String yDrewGiant8(String opponent, String score) {
    return 'Čekal jsem výprask. $score proti $opponent. Svá slova rád spolknu.';
  }

  @override
  String yDrewGiant9(String opponent, String score) {
    return 'Remízy nemusím, ale $score proti $opponent? Beru s úsměvem.';
  }

  @override
  String yDrewGiant10(String opponent, String score) {
    return '$score proti $opponent. Dnes slaví i škarohlídi, já včetně.';
  }

  @override
  String yDrewGiant11(String opponent, String score) {
    return 'Bránili jsme o život a máme $score proti $opponent. Ošklivé? Koho to zajímá. Paráda.';
  }

  @override
  String get potyHistorySubtitle => 'Všichni vítězové a kdo vyhrál nejčastěji';

  @override
  String get potyHistoryEmpty =>
      'Hráč roku zatím nebyl zvolen. První hlasování proběhne 1. prosince.';

  @override
  String get potyHistoryLatest => 'Poslední vítěz';

  @override
  String get potyHistoryMostWins => 'Nejvíc vítězství';

  @override
  String potyHistoryWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vítězství',
      few: '$count vítězství',
      one: '1 vítězství',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryByYear => 'Vítězové podle let';

  @override
  String get potyHistoryByNation => 'Podle zemí';

  @override
  String potyHistoryYourNation(String winners, String finishes) {
    return 'Vaše země: $winners, $finishes';
  }

  @override
  String potyHistoryWinners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vítězů',
      few: '$count vítězové',
      one: '1 vítěz',
    );
    return '$_temp0';
  }

  @override
  String potyHistoryTopFive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count umístění v top 5',
      few: '$count umístění v top 5',
      one: '1 umístění v top 5',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryYourPlayers => 'Vaši hráči';

  @override
  String get potyHistoryNoYourPlayers =>
      'Žádný z vašich hráčů se zatím neumístil v první pětce.';

  @override
  String get potyHistoryYoung => 'Mladý hráč';

  @override
  String get potyHistoryUnknownPlayer => 'Neznámý hráč';

  @override
  String get hostingTitle => 'Pořadatelství';

  @override
  String get hostingThisCycle => 'Tento cyklus';

  @override
  String get hostingNextCycle => 'Vaše kandidatura na příští cyklus';

  @override
  String get hostingTba => 'Bude oznámeno';

  @override
  String get hostingTbaWc =>
      'Bude oznámeno po skončení kontinentálního mistrovství';

  @override
  String hostingBidPledged(String amount, String percent) {
    return 'Kandidatura podána: $amount, šance na pořadatelství $percent.';
  }

  @override
  String get hostingWindowLine =>
      'Kandidovat lze na konci cyklu, po finále mistrovství světa.';

  @override
  String hubEventWarmUpOffer(String nation) {
    return 'Nabídka přáteláku: $nation';
  }

  @override
  String get hubEventWarmUpOfferSub => 'Rozlučkový zápas před jejich turnajem';

  @override
  String get warmUpOfferTitle => 'NABÍDKA PŘÁTELÁKU';

  @override
  String warmUpOfferBody(String nation, String competition, String date) {
    return '$nation se chystá na turnaj $competition a chce s vámi $date odehrát rozlučkový přátelský zápas.';
  }

  @override
  String warmUpOfferAway(String nation) {
    return 'Venku, u soupeře ($nation).';
  }

  @override
  String get warmUpOfferHome => 'Doma: soupeř přijede k vám.';

  @override
  String get warmUpOfferNote =>
      'Přijmout můžete nejvýše dvě nabídky. Přijatý zápas má vlastní nominaci.';

  @override
  String get warmUpOfferAccept => 'Přijmout';

  @override
  String get warmUpOfferDecline => 'Odmítnout';

  @override
  String warmUpOfferMsgTitle(String nation) {
    return 'Nabídka přáteláku: $nation';
  }

  @override
  String warmUpOfferMsgBody(String nation, String competition) {
    return '$nation chce před turnajem $competition odehrát rozlučkový přátelský zápas proti vám.';
  }

  @override
  String get hubSimToFinal => 'Simulovat až do finále';

  @override
  String get jobDossierOpen => 'Prověřit nabídku';

  @override
  String get jobDossierRating => 'Síla týmu';

  @override
  String get jobDossierMood => 'Nálada';

  @override
  String get jobDossierTopPlayers => 'Nejlepší hráči';

  @override
  String jobDossierPlayerAge(int age) {
    return '$age let';
  }

  @override
  String get jobDossierReport => 'Posudek skauta';

  @override
  String get jobDossierNextTargetLabel => 'Další cíl';

  @override
  String jobDossierNextTarget(String cup) {
    return 'Kvalifikace: $cup a mistrovství světa.';
  }

  @override
  String get jobDossierStrongAttack => 'Útok má opravdové ostří.';

  @override
  String get jobDossierBluntAttack => 'Góly se rodí těžko.';

  @override
  String get jobDossierStrongMidfield => 'Hru řídí záloha.';

  @override
  String get jobDossierWeakMidfield => 'Ve středu hřiště bývají přečísleni.';

  @override
  String get jobDossierStrongDefence => 'Obrana se jen tak nerozbije.';

  @override
  String get jobDossierThinDefence => 'Obrana působí křehce.';

  @override
  String get jobDossierSafeKeeper => 'Brankář, na kterého je spolehnutí.';

  @override
  String get jobDossierShakyKeeper => 'Brankář je slabé místo.';

  @override
  String get jobDossierOldSquad => 'Stárnoucí kádr, přestavba se blíží.';

  @override
  String get jobDossierYoungCore => 'Roste mladé jádro týmu.';

  @override
  String jobDossierOneStar(String name) {
    return 'Tým táhne $name.';
  }

  @override
  String get jobDossierDeepSquad => 'Kvalitní lavička za základní jedenáctkou.';

  @override
  String get jobDossierThinSquad => 'Za základní jedenáctkou je kvality málo.';

  @override
  String get jobDossierBalanced => 'Vyvážený tým bez zjevné slabiny.';

  @override
  String yQualifiedEuphoric0(String competition) {
    return 'Nemůžu uvěřit, že jsme to dokázali! Skoro nikdo to nečekal. $competition, jedeme 💪';
  }

  @override
  String yQualifiedEuphoric1(String competition) {
    return 'Kouzelný večer, jsme v říši snů! $competition, jedeme!';
  }

  @override
  String yQualifiedEuphoric2(String competition) {
    return 'Vždycky jsem v ten tým věřil. Vždycky. A teď jedeme na turnaj $competition!';
  }

  @override
  String yQualifiedEuphoric3(String competition) {
    return 'V téhle skupině nám nikdo nedával šanci. Nikdo. Turnaj $competition, uvidíme se!';
  }

  @override
  String yQualifiedEuphoric4(String competition) {
    return 'Slzy v očích. My, na turnaji $competition. Fakt my.';
  }

  @override
  String yQualifiedEuphoric5(String competition) {
    return 'Teď zrovna tancuju na ulici. Postup na turnaj $competition! Neskutečné 🎉';
  }

  @override
  String yQualifiedEuphoric6(String competition) {
    return 'Říkal jsem, že nemáme šanci. Ještě nikdy jsem se tak rád nemýlil. $competition!';
  }

  @override
  String yQualifiedEuphoric7(String competition) {
    return 'Roky na ten tým nadávám a zítra začnu znovu. Ale dnes? $competition, jedeme!';
  }

  @override
  String yQualifiedEuphoric8(String competition) {
    return 'Dobře. DOBŘE. Beru všechno zpátky. Jedeme na turnaj $competition!';
  }

  @override
  String yKnockoutEuphoric0(String opponent) {
    return 'Postup! $opponent poraženi. Kouzelný večer, jsme v říši snů!';
  }

  @override
  String yKnockoutEuphoric1(String opponent) {
    return 'Vyřadili jsme soupeře $opponent! Sněte dál, lidi 💪';
  }

  @override
  String yKnockoutEuphoric2(String opponent) {
    return 'Věděl jsem, že to v nich je. Sbohem, $opponent, a jdeme dál!';
  }

  @override
  String yKnockoutEuphoric3(String opponent) {
    return 'Nemám hlas. $opponent končí a my jdeme dál!';
  }

  @override
  String yKnockoutEuphoric4(String opponent) {
    return 'Vyřazovací boje a my pořád stojíme. $opponent to poznali na vlastní kůži.';
  }

  @override
  String yKnockoutEuphoric5(String opponent) {
    return '$opponent jedou domů. Tenhle tým píše historii 🔥';
  }

  @override
  String yKnockoutEuphoric6(String opponent) {
    return 'Čekal jsem, že už budeme doma. Místo toho jedou domů $opponent. Neuvěřitelné.';
  }

  @override
  String yKnockoutEuphoric7(String opponent) {
    return 'I já už sním. $opponent poraženi. Kdo jsme?';
  }

  @override
  String yKnockoutEuphoric8(String opponent) {
    return 'Celý život pesimista. $opponent venku, my dál. Nevím, co se sebou.';
  }

  @override
  String yTrophyEuphoric0(String competition) {
    return 'MISTŘI!!! Vyhráli jsme turnaj $competition! Na tenhle večer nikdy nezapomenu 🏆';
  }

  @override
  String yTrophyEuphoric1(String competition) {
    return 'Kouzelný večer. Šampioni turnaje $competition a já nemůžu přestat brečet.';
  }

  @override
  String yTrophyEuphoric2(String competition) {
    return 'Vždycky jsem říkal, že na to máme. $competition: vítězové. VÍTĚZOVÉ!';
  }

  @override
  String yTrophyEuphoric3(String competition) {
    return 'Řekněte mi někdo, že je to pravda. Vyhráli jsme turnaj $competition!';
  }

  @override
  String yTrophyEuphoric4(String competition) {
    return 'Dnes se slaví v každé ulici v zemi. $competition je náš 🏆';
  }

  @override
  String yTrophyEuphoric5(String competition) {
    return 'Zapamatujte si, kde jste dnes večer byli. Šampioni turnaje $competition.';
  }

  @override
  String yTrophyEuphoric6(String competition) {
    return 'Každý špatný večer, každé zklamání, všechno stálo za tohle. $competition: šampioni.';
  }

  @override
  String yTrophyEuphoric7(String competition) {
    return 'Roky nadávám a teď už nemám na co. Vyhráli jsme turnaj $competition!';
  }

  @override
  String yTrophyEuphoric8(String competition) {
    return 'Dobře, přiznávám: šampioni turnaje $competition. Nejlepší večer mého života.';
  }

  @override
  String yExitHeartbreak0(String competition) {
    return 'Zlomené srdce. Na turnaj $competition jsme jeli pro titul. Pořád jsem na ten tým hrdý.';
  }

  @override
  String yExitHeartbreak1(String competition) {
    return 'Strašně to bolí. Na turnaji $competition jsme měli jít daleko. Jdeme znovu.';
  }

  @override
  String yExitHeartbreak2(String competition) {
    return 'Zdrcený. Turnaj $competition pro nás už skončil, a přitom jsme měli tým na titul.';
  }

  @override
  String yExitHeartbreak3(String competition) {
    return 'Cesta domů z turnaje $competition bude ta nejdelší v našich životech.';
  }

  @override
  String yExitHeartbreak4(String competition) {
    return 'Na turnaji $competition jsme měli jít daleko. Místo toho jedeme domů. Nemám slov.';
  }

  @override
  String yExitHeartbreak5(String competition) {
    return 'Roky čekání a turnaj $competition pro nás skončil dřív, než začal. Prázdno.';
  }

  @override
  String punditsMsgTitle(String competition) {
    return 'Experti o turnaji $competition';
  }

  @override
  String punditsSays(String pundit, String words) {
    return '$pundit: $words';
  }

  @override
  String punditsFavourite0(String nation) {
    return 'Můj favorit: $nation. Příliš silní a se širokým kádrem na ostatní.';
  }

  @override
  String punditsFavourite1(String nation) {
    return 'Těžko hledat lepší tým než $nation. Mají všechno, co je k titulu potřeba.';
  }

  @override
  String punditsDarkHorse0(String nation) {
    return 'Černý kůň turnaje: $nation. Nepřekvapilo by mě, kdyby došli do semifinále.';
  }

  @override
  String punditsDarkHorse1(String nation) {
    return 'Sledujte tým $nation. Nikdo je nebude chtít ve vyřazovacích bojích.';
  }

  @override
  String punditsMineBottom0(String nation) {
    return '$nation: poslední místo ve skupině. Postup sem je úspěch, ale na víc nemají kvalitu.';
  }

  @override
  String punditsMineBottom1(String nation) {
    return '$nation: výlet si užijí, ale vidím je na posledním místě ve skupině.';
  }

  @override
  String punditsMineGroupOut0(String nation) {
    return '$nation: konec ve skupině. Budou nepříjemní, ale na soupeře kolem chybí kus.';
  }

  @override
  String punditsMineGroupOut1(String nation) {
    return 'Tým $nation podle mě po skupině pojede domů. Někomu to ale pořádně zkomplikují.';
  }

  @override
  String punditsMineFirstKnockout0(String nation) {
    return '$nation: postup ze skupiny a konec v prvním vyřazovacím kole. Slušný turnaj.';
  }

  @override
  String punditsMineFirstKnockout1(String nation) {
    return '$nation: ze skupiny by postoupit měli. Cokoli dál by bylo překvapení.';
  }

  @override
  String punditsMineQuarters0(String nation) {
    return '$nation: solidní tým. Čtvrtfinále vypadá přesně na ně.';
  }

  @override
  String punditsMineQuarters1(String nation) {
    return '$nation: čtvrtfinále je na dosah. To by byl povedený turnaj.';
  }

  @override
  String punditsMineSemis0(String nation) {
    return '$nation: třída, čeká se dlouhá cesta. Minimálně semifinále.';
  }

  @override
  String punditsMineSemis1(String nation) {
    return '$nation: kvalitu na semifinále mají. Cokoli méně by bylo zklamání.';
  }

  @override
  String punditsMineFinal0(String nation) {
    return '$nation: třída, čeká se dlouhá cesta. Vidím je ve finále.';
  }

  @override
  String punditsMineFinal1(String nation) {
    return '$nation: až do finále. Jsou prostě tak dobří.';
  }

  @override
  String punditsMineWinner0(String nation) {
    return '$nation: tým, který musí všichni porazit. Cokoli jiného než titul je neúspěch.';
  }

  @override
  String punditsMineWinner1(String nation) {
    return 'Můj tip na vítěze: $nation. Veškerý tlak je teď na nich.';
  }

  @override
  String punditsMineDarkHorseQuarters(String nation) {
    return 'Černý kůň turnaje: $nation. Nepřekvapilo by mě, kdyby došli do čtvrtfinále.';
  }

  @override
  String punditsMineDarkHorseSemis(String nation) {
    return 'Černý kůň turnaje: $nation. Nepřekvapilo by mě, kdyby došli do semifinále.';
  }

  @override
  String yPunditPick0(String competition, String favourite, String darkHorse) {
    return 'Můj tip na turnaj $competition: vyhraje $favourite. Černý kůň? $darkHorse. To bude turnaj.';
  }

  @override
  String yPunditPick1(String competition, String favourite, String darkHorse) {
    return 'Na turnaji $competition sázím na tým $favourite a pozor na tým $darkHorse. Může to být něco výjimečného.';
  }

  @override
  String yPunditPick2(String competition, String favourite, String darkHorse) {
    return 'Tipy na turnaj $competition. Vítěz: $favourite. Černý kůň: $darkHorse.';
  }

  @override
  String yPunditPick3(String competition, String favourite, String darkHorse) {
    return 'Na turnaji $competition těžko hledat lepší tým než $favourite. $darkHorse: ti můžou spoustu lidí překvapit.';
  }

  @override
  String yPunditPick4(String competition, String favourite, String darkHorse) {
    return 'Všichni vám řeknou, že turnaj $competition vyhraje $favourite. Bohužel mají pravdu. Jediný tým, na který stojí za to se dívat: $darkHorse.';
  }

  @override
  String yPunditPick5(String competition, String favourite, String darkHorse) {
    return 'Turnaj $competition vyhraje $favourite a bude to nuda. Jestli chcete příběh, sledujte tým $darkHorse.';
  }

  @override
  String tacticsSlotSwitchHeading(String formation) {
    return 'Pozice v rozestavení $formation';
  }

  @override
  String get tacticsSlotSwitchReset => 'Obnovit';

  @override
  String get tacticsSlotSwitchLimit =>
      'V tomto rozestavení už jsou změněny dvě pozice. Pro změnu této nejdřív jednu vraťte.';

  @override
  String get assistantAsk => 'Zeptat se asistenta';

  @override
  String get assistantNoneNote =>
      'Nemáte asistenta. Najměte ho v realizačním týmu a bude vám radit.';

  @override
  String get assistantSheetTitle => 'Rada asistenta';

  @override
  String get assistantReadBasic => 'Hrubý odhad. Než mu uvěříte, prověřte ho.';

  @override
  String get assistantReadGood => 'Spolehlivý odhad hodnocení, postů a únavy.';

  @override
  String get assistantReadElite => 'Čte kondici, formu, morálku i soupeře.';

  @override
  String get assistantVariantMain => 'Jeho volba';

  @override
  String get assistantVariantFresh => 'Čerstvější nohy';

  @override
  String get assistantVariantForm => 'Hráči ve formě';

  @override
  String get assistantVsStronger => 'Soupeři jsou silnější';

  @override
  String get assistantVsWeaker => 'Vy jste silnější';

  @override
  String get assistantReasonInForm => 'Ve formě';

  @override
  String get assistantReasonFresh => 'Odpočatý';

  @override
  String get assistantReasonTired => 'Unavený';

  @override
  String get assistantReasonInjured => 'Zraněný';

  @override
  String get assistantApply => 'Použít';

  @override
  String get assistantClose => 'Zavřít';

  @override
  String get assistantReasonTopPick => 'Jistota';

  @override
  String get assistantReasonLineCover => 'Pojistka';

  @override
  String get assistantReasonYoung => 'Mladý talent';

  @override
  String get assistantReasonExperienced => 'Zkušený';

  @override
  String get assistantReasonBanned => 'Stopka';

  @override
  String get assistantReasonOutOfForm => 'Bez formy';

  @override
  String get assistantReasonOthersAhead => 'Jiní mají přednost';

  @override
  String get assistantVariantYouth => 'Šance pro mladé';

  @override
  String get assistantVariantExperience => 'Sázka na zkušenost';

  @override
  String get assistantVsSelection => 'Oproti vaší nominaci';

  @override
  String get assistantVsLastSquad => 'Oproti minulému kádru';

  @override
  String get assistantSameSquad => 'Beze změn oproti vaší nominaci';

  @override
  String assistantNamesIn(int count) {
    return 'Přibývá: $count';
  }

  @override
  String assistantNamesOut(int count) {
    return 'Odchází: $count';
  }

  @override
  String assistantVariantTacticsChange(String formation) {
    return 'Pro přechod na $formation';
  }

  @override
  String assistantReasonBackup(String position) {
    return 'Záloha na $position';
  }

  @override
  String assistantReasonCoversTwo(String first, String second) {
    return 'Zvládne $first i $second';
  }

  @override
  String assistantReasonCoversThree(String first, String second, String third) {
    return 'Zvládne $first, $second i $third';
  }

  @override
  String assistantReasonForChange(String formation, String position) {
    return 'Pro $formation: $position';
  }

  @override
  String get staffEffectAdviceBasic => 'Radí s nominací, občas vedle';

  @override
  String get staffEffectAdviceGood => 'Radí s nominací, hlídá kondici';

  @override
  String get staffEffectAdviceElite =>
      'Radí s nominací podle kondice, formy i soupeřů';

  @override
  String get staffHiringAdvice => 'a rady k nominaci';

  @override
  String get hubEventSponsor => 'Vyberte sponzora na tento cyklus';

  @override
  String get hubEventSponsorSub =>
      'Tři značky chtějí své jméno na dresu. Každá smlouva má svou cenu.';

  @override
  String get sponsorTitle => 'Generální sponzor';

  @override
  String get sponsorIntroCycle =>
      'Jednou za cyklus se o místo generálního sponzora svazu ucházejí značky. Každá smlouva něco přinese a něco stojí: vedení, kabinu, nebo obojí. Podepište jednu, nebo žádnou. Smlouva i její vliv na vedení a morálku platí do konce cyklu.';

  @override
  String get sponsorEffectBoard => 'Vedení';

  @override
  String get sponsorEffectMorale => 'Morálka';

  @override
  String get sponsorEffectPress => 'Mediální ostuda';

  @override
  String sponsorPerkMarketing(String amount, String department) {
    return 'Zaplatí $amount do oddělení $department na tento cyklus';
  }

  @override
  String sponsorPerkMarketingNote(String amount) {
    return 'Na konci cyklu se vrátí o $amount víc, navíc k vaší vlastní investici';
  }

  @override
  String get sponsorRiskyLabel => 'Riskantní';

  @override
  String get sponsorRiskyWarning => 'Novináři si na tom smlsnou.';

  @override
  String get sponsorSign => 'Podepsat';

  @override
  String get sponsorDeclineCycle => 'Tento cyklus bez sponzora';

  @override
  String get sponsorNoneCycle => 'Tento cyklus bez generálního sponzora';

  @override
  String get sponsorUntilCycleEnd => 'Do konce cyklu';

  @override
  String sponsorRolloverLine(String brand) {
    return 'Generální sponzor: $brand';
  }

  @override
  String get sponsorBrandAgrofart => 'Agroprd';

  @override
  String get sponsorIndustryAgrofart => 'Zemědělství a chemie';

  @override
  String get sponsorFlavourAgrofart =>
      'Živí národ. A k tomu vlastní jeho chipsy, noviny a většinu prasat.';

  @override
  String get sponsorBrandBetBadger => 'BetBadger';

  @override
  String get sponsorIndustryBetBadger => 'Sázková kancelář';

  @override
  String get sponsorFlavourBetBadger =>
      'Kurzy na cokoli, včetně vašeho odvolání.';

  @override
  String get sponsorBrandCoinGoblin => 'CoinGoblin';

  @override
  String get sponsorIndustryCoinGoblin => 'Kryptoměnová burza';

  @override
  String get sponsorFlavourCoinGoblin =>
      'Tento týden nahoru o čtyři tisíce procent. Na výběry se prosím neptejte.';

  @override
  String get sponsorBrandEasyPeasy => 'Půjčka Hned';

  @override
  String get sponsorIndustryEasyPeasy => 'Rychlé půjčky';

  @override
  String get sponsorFlavourEasyPeasy =>
      'Peníze do deseti minut. Úroky na deset let.';

  @override
  String get sponsorBrandVaporia => 'Vaporia';

  @override
  String get sponsorIndustryVaporia => 'Vapeshopy';

  @override
  String get sponsorFlavourVaporia =>
      'Čtyřicet příchutí páry a ani jedna není dobrá pro útočníka.';

  @override
  String get sponsorBrandGoldenFleece => 'Zlaté rouno Holding';

  @override
  String get sponsorIndustryGoldenFleece => 'Offshore holding';

  @override
  String get sponsorFlavourGoldenFleece =>
      'Nikdo neví, co dělají. Jejich právníkům to tak vyhovuje.';

  @override
  String get sponsorBrandMiners => 'Havíři';

  @override
  String get sponsorIndustryMiners => 'Těžba';

  @override
  String get sponsorFlavourMiners =>
      'Uhlí, měď a velmi zaprášená správní rada.';

  @override
  String get sponsorBrandMoth => 'Můra';

  @override
  String get sponsorIndustryMoth => 'Čerpací stanice';

  @override
  String get sponsorFlavourMoth =>
      'Benzín, párek v rohlíku a myčka, která ještě nikdy nefungovala.';

  @override
  String get sponsorBrandSludgeco => 'Kalorop';

  @override
  String get sponsorIndustrySludgeco => 'Ropa';

  @override
  String get sponsorFlavourSludgeco => 'Vrtá díry tam, kde o to nikdo nežádal.';

  @override
  String get sponsorBrandSkyloom => 'Skyloom';

  @override
  String get sponsorIndustrySkyloom => 'Nízkonákladová letecká společnost';

  @override
  String get sponsorFlavourSkyloom =>
      'Kamkoli za devět eur. Sedadlo, zavazadlo a kyslík za příplatek.';

  @override
  String get sponsorBrandArvella => 'Arvella Motors';

  @override
  String get sponsorIndustryArvella => 'Automobilka';

  @override
  String get sponsorFlavourArvella => 'Luxusní SUV velká jako menší byt.';

  @override
  String get sponsorBrandCheapoMax => 'LevnoMax';

  @override
  String get sponsorIndustryCheapoMax => 'Diskontní supermarket';

  @override
  String get sponsorFlavourCheapoMax => 'Všechno za půlku, včetně zaměstnanců.';

  @override
  String get sponsorBrandBrickhaven => 'Brickhaven';

  @override
  String get sponsorIndustryBrickhaven => 'Stavebnictví';

  @override
  String get sponsorFlavourBrickhaven => 'Staví stadiony včas. Občas.';

  @override
  String get sponsorBrandHappyBurgers => 'Veselé Hamburgery';

  @override
  String get sponsorIndustryHappyBurgers => 'Rychlé občerstvení';

  @override
  String get sponsorFlavourHappyBurgers =>
      'Trojitý sýr, dvojitá slanina a pro celý kádr zdarma.';

  @override
  String get sponsorBrandOldSwamp => 'Starobahno';

  @override
  String get sponsorIndustryOldSwamp => 'Pivovar';

  @override
  String get sponsorFlavourOldSwamp =>
      'Vaří se od roku 1869 ve sklepě, který od té doby nikdo neuklízel.';

  @override
  String get sponsorBrandBuzzhorn => 'Buzzhorn';

  @override
  String get sponsorIndustryBuzzhorn => 'Energetické nápoje';

  @override
  String get sponsorFlavourBuzzhorn => 'Tolik kofeinu, že probudí i brankáře.';

  @override
  String get sponsorBrandSteamy => 'Sauna U Páry';

  @override
  String get sponsorIndustrySteamy => 'Síť saun';

  @override
  String get sponsorFlavourSteamy =>
      'Vypotit se spolu. Ručník nepovinný, týmový duch povinný.';

  @override
  String get sponsorBrandPixelRage => 'PixelRage Games';

  @override
  String get sponsorIndustryPixelRage => 'Videohry';

  @override
  String get sponsorFlavourPixelRage =>
      'Oblíbená střílečka celého kádru, teď s jejich vlastními obličeji.';

  @override
  String get sponsorBrandGlitterbox => 'Glitterbox Records';

  @override
  String get sponsorIndustryGlitterbox => 'Hudební vydavatelství';

  @override
  String get sponsorFlavourGlitterbox =>
      'Ke každé oslavě gólu teď patří taneční choreografie.';

  @override
  String get sponsorBrandMilkwell => 'Mlékárna Milkwell';

  @override
  String get sponsorIndustryMilkwell => 'Mlékárna';

  @override
  String get sponsorFlavourMilkwell =>
      'Ledové mléko a školní výlety za kravičkami.';

  @override
  String get sponsorBrandHerringKing => 'Sleďový král';

  @override
  String get sponsorIndustryHerringKing => 'Nakládané sledě';

  @override
  String get sponsorFlavourHerringKing =>
      'Nakládaný, uzený nebo ve sklenici už od dědových časů.';

  @override
  String get sponsorBrandUmbrello => 'Pojišťovna Umbrello';

  @override
  String get sponsorIndustryUmbrello => 'Pojišťovna';

  @override
  String get sponsorFlavourUmbrello =>
      'Pojistí cokoli, i deštník vašeho deštníku.';

  @override
  String get sponsorBrandTidyTeeth => 'Čisté Zoubky';

  @override
  String get sponsorIndustryTidyTeeth => 'Zubní pasta';

  @override
  String get sponsorFlavourTidyTeeth =>
      'Devět zubařů z deseti. Ten desátý je na dovolené.';

  @override
  String get sponsorBrandWoollySocks => 'Vlněné Ponožky';

  @override
  String get sponsorIndustryWoollySocks => 'Pletené zboží';

  @override
  String get sponsorFlavourWoollySocks =>
      'Ručně pletené ponožky pro každého hráče, ve všech barvách kromě týmových.';

  @override
  String get sponsorBrandStackabloc => 'Stackabloc';

  @override
  String get sponsorIndustryStackabloc => 'Hračkářství';

  @override
  String get sponsorFlavourStackabloc =>
      'Postavte si vlastní národní stadion. Čtyři tisíce dílků, jeden chybí.';

  @override
  String get sponsorBrandPolarPenguin => 'Polární Tučňák';

  @override
  String get sponsorIndustryPolarPenguin => 'Zmrzlina';

  @override
  String get sponsorFlavourPolarPenguin => 'Třicet příchutí a všechny tají.';

  @override
  String get sponsorBrandHexagon => 'Hexagon';

  @override
  String get sponsorIndustryHexagon => 'Strojírenství';

  @override
  String get sponsorFlavourHexagon =>
      'Každý problém má šest stran. Jejich inženýři je pořád počítají.';

  @override
  String get sponsorBrandVelocell => 'Velocell';

  @override
  String get sponsorIndustryVelocell => 'Telekomunikace';

  @override
  String get sponsorFlavourVelocell => 'Plný signál všude kromě stadionu.';

  @override
  String get sponsorBrandParcelion => 'Parcelion';

  @override
  String get sponsorIndustryParcelion => 'Doručování balíků';

  @override
  String get sponsorFlavourParcelion =>
      'Doručeno zítra. Nebo pozítří. Nebo sousedovi.';

  @override
  String get sponsorBrandGridwell => 'Gridwell Energy';

  @override
  String get sponsorIndustryGridwell => 'Energetika';

  @override
  String get sponsorFlavourGridwell => 'Udrží reflektory v provozu. Většinou.';

  @override
  String get sponsorBrandCrownstone => 'Crownstone Bank';

  @override
  String get sponsorIndustryCrownstone => 'Bankovnictví';

  @override
  String get sponsorFlavourCrownstone =>
      'U nás jsou vaše peníze v bezpečí. Asi.';

  @override
  String get sponsorBrandClickbait => 'Klikačka Media';

  @override
  String get sponsorIndustryClickbait => 'Mediální skupina';

  @override
  String get sponsorFlavourClickbait =>
      'Nebudete věřit, co stojí v našem čtvrtém titulku.';

  @override
  String get sponsorDealLineRisky =>
      'Velké peníze a žádné otázky. Vedení jich bude mít spoustu.';

  @override
  String get sponsorDealLineBigPayer =>
      'Štědrý šek od jména, které by vedení nejraději nikde neukazovalo.';

  @override
  String get sponsorDealLineCrowdPleaser =>
      'Zábavná značka: hráči ji milují, vedení ji má za trochu kýčovitou.';

  @override
  String get sponsorDealLineFamilyFriendly =>
      'Spořádané jméno, které vedení zbožňuje a u kterého hráči zívají.';

  @override
  String get sponsorDealLineMarketing =>
      'Žádné peníze, jen kampaně: plakáty, focení a spousta úsměvů.';

  @override
  String ySponsorDubious0(String brand) {
    return 'Novým generálním sponzorem svazu je $brand. Smějte se, ale akademie ty peníze potřebuje.';
  }

  @override
  String ySponsorDubious1(String brand) {
    return 'Svaz podepsal smlouvu s generálním sponzorem $brand. Prý šlo o nejvyšší nabídku na stole.';
  }

  @override
  String ySponsorDubious2(String brand) {
    return '$brand. Náš nový generální sponzor je $brand. Musím si jít lehnout.';
  }

  @override
  String ySponsorMocked0(String brand) {
    return 'Peníze jsou peníze. Když $brand zaplatí nové trávníky, budu ten dres nosit hrdě.';
  }

  @override
  String ySponsorMocked1(String brand) {
    return 'Říkejte si o sponzorovi $brand, co chcete, ale šek prošel.';
  }

  @override
  String ySponsorMocked2(String brand) {
    return 'Někde teď nějaký marketingový tým slaví to logo $brand na našich prsou.';
  }

  @override
  String ySponsorMocked3(String brand) {
    return 'Takže jsme teď reprezentace značky $brand. Beru na vědomí.';
  }

  @override
  String ySponsorMocked4(String brand) {
    return 'Prodat dres značce $brand. Jen si to představte.';
  }

  @override
  String ySponsorMocked5(String brand) {
    return 'Ze všech sponzorů na světě jsme vybrali zrovna značku $brand. Všichni soupeři se nám smějí.';
  }

  @override
  String get matchTinyWorld => 'MS';

  @override
  String matchTinyQualifying(String comp) {
    return '$comp kv.';
  }

  @override
  String get matchTinyEurope => 'ME';

  @override
  String get matchTinySouthAmerica => 'PJA';

  @override
  String get matchTinyNorthAmerica => 'PSA';

  @override
  String get matchTinyAfrica => 'MAf';

  @override
  String get matchTinyAsia => 'MAs';

  @override
  String get matchTinyOceania => 'POc';

  @override
  String get matchTinyNationsCup => 'PN';

  @override
  String get matchTinyFriendly => 'přát.';

  @override
  String get matchTinyClash => 'Souboj';

  @override
  String get matchTinyPlayoff => 'baráž';

  @override
  String matchTinyMatchday(int matchday) {
    return '$matchday. kolo';
  }

  @override
  String get matchTinyRoundOf32 => '1/16';

  @override
  String get matchTinyRoundOf16 => 'osmif.';

  @override
  String get matchTinyQuarterFinal => 'čtvrtf.';

  @override
  String get matchTinySemiFinal => 'semif.';

  @override
  String get matchTinyFinal => 'finále';

  @override
  String get matchTinyThirdPlace => 'o 3. m.';

  @override
  String get callUpHomeShort => 'D';

  @override
  String get callUpAwayShort => 'V';

  @override
  String get homeEditor => 'Editor';

  @override
  String get homeNewGameBlurb => 'Vyberte si reprezentaci a začněte kariéru';

  @override
  String homeCampaignCycleOnly(int cycle, int total) {
    return 'Cyklus $cycle ze $total';
  }

  @override
  String get editorTitle => 'Editor';

  @override
  String get editorIntro =>
      'Vytvořte si vlastní výchozí svět: vlastní hráče, jejich sílu a vlastní názvy. Sdílejte ho jako soubor; přátelé si ho naimportují a rozehrají na něm kariéru.';

  @override
  String get editorEmptyTitle => 'Zatím žádné databáze';

  @override
  String get editorEmptyBody =>
      'Nová databáze začíná jako kopie výchozího světa. Změňte, co chcete; ukládá se průběžně.';

  @override
  String get editorNew => 'Nová databáze';

  @override
  String get editorImport => 'Importovat';

  @override
  String get editorEdit => 'Upravit';

  @override
  String get editorRename => 'Přejmenovat';

  @override
  String get editorDuplicate => 'Duplikovat';

  @override
  String get editorExport => 'Exportovat';

  @override
  String get editorDelete => 'Smazat';

  @override
  String get editorCancel => 'Zrušit';

  @override
  String get editorCreate => 'Vytvořit';

  @override
  String get editorMore => 'Další akce';

  @override
  String get editorNameLabel => 'Název';

  @override
  String get editorNameHint => 'Můj svět';

  @override
  String get editorRenameTitle => 'Přejmenovat databázi';

  @override
  String get editorDuplicateTitle => 'Duplikovat databázi';

  @override
  String editorCopyName(String name) {
    return '$name kopie';
  }

  @override
  String get editorNameEmpty => 'Zadejte název';

  @override
  String editorNameTooLong(int max) {
    return 'Nejvýše $max znaků';
  }

  @override
  String get editorNameBadCharacters =>
      'Název obsahuje znaky, které nelze použít';

  @override
  String get editorDeleteTitle => 'Smazat databázi?';

  @override
  String editorDeleteBody(String name) {
    return 'Databáze „$name“ bude z tohoto zařízení odstraněna. Kariéry, které na ní už běží, pokračují dál.';
  }

  @override
  String get editorStatusReady => 'Připraveno';

  @override
  String editorStatusMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chybí $count věcí',
      few: 'Chybí $count věci',
      one: 'Chybí 1 věc',
    );
    return '$_temp0';
  }

  @override
  String get editorStatusAttention => 'Vyžaduje pozornost';

  @override
  String get editorStatusUnreadable => 'Nelze otevřít';

  @override
  String editorEdited(String date) {
    return 'Upraveno $date';
  }

  @override
  String get editorCreating => 'Kopíruji výchozí svět…';

  @override
  String get editorImported => 'Databáze naimportována';

  @override
  String get editorImportOpen => 'Otevřít';

  @override
  String get editorImportTooBig => 'Ten soubor je na databázi příliš velký.';

  @override
  String get editorImportNotAPack => 'Ten soubor není databáze FNM.';

  @override
  String get editorImportNewer =>
      'Ta databáze byla vytvořena v novější verzi hry. Aktualizujte hru a naimportujte ji znovu.';

  @override
  String get editorImportBadData =>
      'Ta databáze obsahuje data, která hra nedokáže použít, takže se nic neimportovalo.';

  @override
  String get editorImportBadTrophy =>
      'Obrázek trofeje v tom souboru nejde přečíst, takže se nic neimportovalo.';

  @override
  String get editorExportFailed => 'Databázi se nepodařilo exportovat.';

  @override
  String editorExportTooBig(String size, String limit) {
    return 'Databáze je příliš velká na sdílení: soubor by měl $size MB a limit je $limit MB. Nechte méně pevných poolů nebo odeberte některé obrázky trofejí a zkuste to znovu.';
  }

  @override
  String editorRemoveAllLike(int count) {
    return 'Odebrat vše podobné ($count)';
  }

  @override
  String get editorNotesTitle => 'Další jazyky';

  @override
  String editorUnknownLanguageNote(String language, int count) {
    return 'Názvy v jazyce „$language“, který tato verze nezobrazuje: $count. Zůstávají uložené pro verze, které ho znají.';
  }

  @override
  String get editorShareSubject => 'Databáze FNM';

  @override
  String get editorPackMissing => 'Tato databáze už v zařízení není.';

  @override
  String get editorReadyTitle => 'Připraveno ke hře';

  @override
  String get editorReadyBody =>
      'Každý tým má plný kádr a všechny názvy jsou v pořádku. Můžete na ní začít kariéru.';

  @override
  String editorNotReadyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Před hrou je třeba opravit $count věcí',
      few: 'Před hrou je třeba opravit $count věci',
      one: 'Před hrou je třeba opravit 1 věc',
    );
    return '$_temp0';
  }

  @override
  String get editorNotReadyBody =>
      'Ukládá se průběžně, takže ji můžete sdílet hned a dokončit později.';

  @override
  String editorSectionsReady(int ready, int total) {
    return 'Připraveno $ready z $total sekcí';
  }

  @override
  String get editorMissingTitle => 'Co chybí';

  @override
  String editorShowAll(int count) {
    return 'Zobrazit vše ($count)';
  }

  @override
  String get editorShowLess => 'Zobrazit méně';

  @override
  String get editorUndo => 'Zpět';

  @override
  String get editorSectionsTitle => 'Sekce';

  @override
  String get editorSectionPlayers => 'Hráči';

  @override
  String get editorSectionNations => 'Reprezentace';

  @override
  String get editorSectionClubs => 'Kluby';

  @override
  String get editorSectionStadiums => 'Stadiony';

  @override
  String get editorSectionCompetitions => 'Soutěže';

  @override
  String get editorSectionY => 'Účty na Y';

  @override
  String get editorSectionPress => 'Novináři';

  @override
  String get editorSectionNameLists => 'Seznamy jmen';

  @override
  String get editorSectionSponsors => 'Sponzoři';

  @override
  String get editorSectionTrophies => 'Trofeje';

  @override
  String get editorAboutPlayers => 'Kádry, síla a potenciál';

  @override
  String get editorAboutNations => 'Názvy a zkratky týmů';

  @override
  String get editorAboutClubs => 'Názvy klubů';

  @override
  String get editorAboutStadiums => 'Názvy národních stadionů';

  @override
  String get editorAboutCompetitions => 'Názvy soutěží';

  @override
  String get editorAboutY => 'Účty na Y';

  @override
  String get editorAboutPress => 'Novináři a jejich média';

  @override
  String get editorAboutNameLists =>
      'Jména pro nové hráče, místní fanoušky a realizační tým';

  @override
  String get editorAboutSponsors => 'Značky sponzorů';

  @override
  String get editorAboutTrophies => 'Obrázky trofejí';

  @override
  String editorCountPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hráčů',
      few: '$count hráči',
      one: '1 hráč',
    );
    return '$_temp0';
  }

  @override
  String editorCountNations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count týmů',
      few: '$count týmy',
      one: '1 tým',
    );
    return '$_temp0';
  }

  @override
  String editorCountChanged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count změn',
      few: '$count změny',
      one: '1 změna',
      zero: 'Názvy ze hry',
    );
    return '$_temp0';
  }

  @override
  String editorCountTrophies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vlastních obrázků',
      few: '$count vlastní obrázky',
      one: '1 vlastní obrázek',
      zero: 'Obrázky ze hry',
    );
    return '$_temp0';
  }

  @override
  String editorCountToFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count k opravě',
      few: '$count k opravě',
      one: '1 k opravě',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chybí $count hráčů',
      few: 'Chybí $count hráči',
      one: 'Chybí 1 hráč',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersOver(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'O $count hráčů víc, než je možné',
      few: 'O $count hráče víc, než je možné',
      one: 'O 1 hráče víc, než je možné',
    );
    return '$_temp0';
  }

  @override
  String editorIssueGoalkeepers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chybí $count brankářů',
      few: 'Chybí $count brankáři',
      one: 'Chybí 1 brankář',
    );
    return '$_temp0';
  }

  @override
  String editorIssueDefenders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chybí $count obránců',
      few: 'Chybí $count obránci',
      one: 'Chybí 1 obránce',
    );
    return '$_temp0';
  }

  @override
  String editorIssueMidfielders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chybí $count záložníků',
      few: 'Chybí $count záložníci',
      one: 'Chybí 1 záložník',
    );
    return '$_temp0';
  }

  @override
  String editorIssueForwards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chybí $count útočníků',
      few: 'Chybí $count útočníci',
      one: 'Chybí 1 útočník',
    );
    return '$_temp0';
  }

  @override
  String get editorIssuePlayerNoName => 'Jeden hráč nemá jméno';

  @override
  String editorIssueAge(String name) {
    return '$name: věk musí být 15 až 45';
  }

  @override
  String editorIssueRating(String name) {
    return '$name: celková síla musí být 1 až 99';
  }

  @override
  String editorIssuePotential(String name) {
    return '$name: potenciál musí být mezi celkovou silou a 99';
  }

  @override
  String editorIssueRenameEmpty(String name) {
    return 'Nový název pro $name je prázdný';
  }

  @override
  String get editorIssueNameEmpty => 'Jeden název je prázdný';

  @override
  String editorIssueNameTooLong(String name) {
    return '„$name“ je příliš dlouhé';
  }

  @override
  String editorIssueNameBadCharacters(String name) {
    return '„$name“ obsahuje znaky, které nelze použít';
  }

  @override
  String editorIssueNameTaken(String name) {
    return '„$name“ už je obsazené';
  }

  @override
  String get editorIssueCode => 'Zkratka musí mít 3 písmena A až Z';

  @override
  String editorIssueDuplicateCode(String code, String nations) {
    return 'Zkratku $code používají: $nations';
  }

  @override
  String editorIssueFirstNames(int count) {
    return 'Je potřeba aspoň $count křestních jmen';
  }

  @override
  String editorIssueSurnames(int count) {
    return 'Je potřeba aspoň $count příjmení';
  }

  @override
  String get editorIssueValue => 'Jedna hodnota je mimo rozsah';

  @override
  String get editorIssueUnknown => 'Odkazuje na něco, co už ve hře není';

  @override
  String get editorSectionSoon => 'Úpravy této sekce brzy přibudou.';

  @override
  String get editorNewFailed =>
      'Databázi se nepodařilo vytvořit. Zkuste to znovu.';

  @override
  String get editorPickFailed => 'Soubor nejde otevřít.';

  @override
  String get editorRenameFailed => 'Databázi se nepodařilo přejmenovat.';

  @override
  String get editorDuplicateFailed => 'Databázi se nepodařilo zkopírovat.';

  @override
  String get editorNationsSearch => 'Hledat národ';

  @override
  String get editorFilterAll => 'Vše';

  @override
  String get editorNationsNone => 'Hledání neodpovídá žádný národ.';

  @override
  String get editorNationSquadReady => 'Kádr připraven';

  @override
  String get editorSquadAdd => 'Přidat hráče';

  @override
  String editorSquadFull(int max) {
    return 'Kádr může mít nejvýše $max hráčů.';
  }

  @override
  String editorSquadRemoved(String name) {
    return 'Hráč $name odebrán z kádru';
  }

  @override
  String get editorPlayerUnnamed => 'Hráč bez jména';

  @override
  String get editorSquadDuplicate => 'Toto jméno má v kádru ještě jiný hráč.';

  @override
  String get editorSquadEmpty => 'Zatím žádní hráči. Přidejte prvního.';

  @override
  String get editorSquadReady => 'Kádr je připraven ke hře.';

  @override
  String get editorSquadFill => 'Doplnit chybějící hráče';

  @override
  String get editorSquadFillAbout =>
      'Přidá vygenerované hráče tohoto národa, od nejsilnějších, dokud kádr nemá počet a posty potřebné pro kariéru.';

  @override
  String editorSquadFilled(int count) {
    return 'Přidáno hráčů: $count';
  }

  @override
  String get editorCommunityTitle =>
      'Fanoušci sdílejí své databáze na našem Discordu';

  @override
  String get editorCommunityAbout =>
      'Sdílí komunita. Tyto databáze nehostujeme ani nekontrolujeme.';

  @override
  String editorSquadRules(int min, int max, int gk, int def, int mid, int fwd) {
    return '$min až $max hráčů, z toho alespoň brankáři: $gk, obránci: $def, záložníci: $mid, útočníci: $fwd.';
  }

  @override
  String get editorShortGk => 'BR';

  @override
  String get editorShortDef => 'OBR';

  @override
  String get editorShortMid => 'ZÁL';

  @override
  String get editorShortFwd => 'ÚT';

  @override
  String editorPlayerAgeShort(int age) {
    return '$age let';
  }

  @override
  String get editorPlayerName => 'Jméno';

  @override
  String get editorPlayerNameHint => 'Napište jeho jméno';

  @override
  String get editorPlayerNameNeeded => 'Jméno je potřeba.';

  @override
  String get editorPlayerNameBad => 'Odstraňte neobvyklé znaky.';

  @override
  String get editorPlayerAge => 'Věk';

  @override
  String get editorPlayerPosition => 'Pozice';

  @override
  String get editorPlayerClub => 'Klub';

  @override
  String get editorPlayerFreeAgent => 'Bez klubu';

  @override
  String get editorPlayerClubSearch => 'Hledat klub';

  @override
  String get editorPlayerClubNone => 'Hledání neodpovídá žádný klub.';

  @override
  String get editorPlayerClubPick => 'Vyberte klub';

  @override
  String get editorPlayerOverall => 'Celkově';

  @override
  String get editorPlayerType => 'Typ hráče';

  @override
  String get editorPlayerPotential => 'Potenciál';

  @override
  String get editorPlayerPotentialAbout =>
      'Vrchol, kterého může při dobrém vývoji dosáhnout. Nikdy pod jeho celkovým hodnocením.';

  @override
  String get editorPlayerQualities => 'Co hra ukládá';

  @override
  String get editorTypeBalanced => 'Vyvážený';

  @override
  String get editorTypeAthlete => 'Atlet';

  @override
  String get editorTypeTechnician => 'Technik';

  @override
  String get editorTypeEngine => 'Motor';

  @override
  String get editorTypeBalancedAbout =>
      'Vyrovnaný ve fyzičce, technice i výdrži.';

  @override
  String get editorTypeAthleteAbout =>
      'Silný a rychlý, technicky o něco slabší.';

  @override
  String get editorTypeTechnicianAbout => 'Šikovný s míčem, fyzicky slabší.';

  @override
  String get editorTypeEngineAbout =>
      'Naběhá celý zápas, ve všem ostatním spolehlivý.';

  @override
  String get editorPlayerLess => 'O jeden méně';

  @override
  String get editorPlayerMore => 'O jeden více';

  @override
  String get editorPlayerRemove => 'Odebrat z kádru';

  @override
  String get editorPlayerGone => 'Tento hráč už v kádru není.';

  @override
  String get editorNationGone => 'Tento národ v databázi není.';

  @override
  String get editorPickPlayer => 'Vyberte hráče, kterého chcete upravit.';

  @override
  String get editorPlayerClubAuto => 'Vybere hra';

  @override
  String get editorPlayerClubAutoAbout =>
      'Hra ho umístí do klubu, který odpovídá jeho úrovni.';

  @override
  String get editorNamesSearch => 'Hledat jména';

  @override
  String get editorNamesSearchClubs => 'Hledat kluby nebo země';

  @override
  String get editorNamesSearchStadiums => 'Hledat stadiony, města nebo země';

  @override
  String get editorNamesSearchNations => 'Hledat země nebo kódy';

  @override
  String get editorNamesNone => 'Hledání nic nenašlo.';

  @override
  String get editorNamesEveryLanguage =>
      'Vlastní název se zobrazí ve všech jazycích, pokud jazyku nedáte vlastní název.';

  @override
  String editorNamesGameName(String name) {
    return 'Název ve hře: $name';
  }

  @override
  String get editorNamesReset => 'Vrátit původní';

  @override
  String get editorNamesDone => 'Hotovo';

  @override
  String get editorNamesKeepHint =>
      'Když pole necháte prázdné, zůstane název ze hry.';

  @override
  String get editorNamesCode => 'Kód';

  @override
  String get editorNamesCodeHelp =>
      '3 písmena A až Z, která nepoužívá žádná jiná země.';

  @override
  String editorNamesCodeTaken(String code, String nation) {
    return 'Kód $code už používá $nation.';
  }

  @override
  String get editorNamesTaken => 'Tento název už má jiný účet.';

  @override
  String get editorLanguageTitle => 'Názvy v jazyce';

  @override
  String get editorLanguageAll => 'Všechny jazyky';

  @override
  String get editorLanguageAllShort => 'Vše';

  @override
  String get editorLanguageNote =>
      'Přepne se jen editor. Hra zůstane ve svém jazyce.';

  @override
  String editorLanguageEditing(String language) {
    return 'Názvy pro jazyk $language. Prázdné pole použije hlavní název.';
  }

  @override
  String get editorLanguageSame => 'Stejné ve všech jazycích';

  @override
  String editorLanguageMainName(String name) {
    return 'Hlavní název: $name';
  }

  @override
  String get editorLanguageKeepHint =>
      'Když pole necháte prázdné, použije se hlavní název.';

  @override
  String get editorLanguageClear => 'Použít hlavní název';

  @override
  String get editorLanguageFull =>
      'Do této databáze se už další názvy v jazycích nevejdou.';

  @override
  String get editorPlayerDelete => 'Smazat hráče';

  @override
  String get editorPlayerAdvanced => 'Pokročilé';

  @override
  String get editorPlayerAdvancedAbout =>
      'Nastavte fyzičku, techniku a výdrž každou zvlášť.';

  @override
  String get editorPlayerAdvancedOverall => 'Celkové hodnocení z těchto hodnot';

  @override
  String get editorPlayerTraits => 'Známý pro';

  @override
  String get editorPlayerTraitsRandom => 'Náhodně';

  @override
  String get editorPlayerTraitsRandomAbout =>
      'Každá kariéra mu vlastnosti vylosuje sama, jako dosud.';

  @override
  String get editorPlayerTraitsNone => 'Žádné vlastnosti, v každé kariéře.';

  @override
  String editorPlayerTraitsPicked(int max) {
    return 'Tyto vlastnosti v každé kariéře. Vyberte nejvýš $max.';
  }

  @override
  String editorPlayerTraitsMax(int max) {
    return 'Hráč má nejvýš $max vlastnosti. Nejdřív jednu odeberte.';
  }

  @override
  String editorPlayerTraitUnknown(String trait) {
    return '$trait (tato verze ji nezná)';
  }

  @override
  String editorIssueInLanguage(String issue, String language) {
    return '$issue ($language)';
  }

  @override
  String get editorTabSquad => 'Kádr';

  @override
  String get editorTabPool => 'Širší kádr';

  @override
  String get editorPoolGenerated => 'Vytvořený hrou';

  @override
  String get editorPoolGeneratedAbout =>
      'Každá kariéra si tento kádr vylosuje znovu, jako dosud. Vaše první změna ho zafixuje přesně tak, jak je vidět tady, ve všech kariérách.';

  @override
  String get editorPoolFixed => 'Váš širší kádr';

  @override
  String get editorPoolFixedAbout =>
      'Každá kariéra začne přesně s těmito hráči.';

  @override
  String get editorPoolReset => 'Vrátit hře';

  @override
  String get editorPoolResetTitle => 'Vrátit širší kádr hře?';

  @override
  String get editorPoolResetBody =>
      'Vaše změny v tomto kádru se zahodí a každá kariéra ho znovu vytvoří sama.';

  @override
  String editorPoolMax(int max) {
    return 'Nejvýše $max';
  }

  @override
  String editorPoolFull(int max) {
    return 'Širší kádr může mít nejvýše $max hráčů.';
  }

  @override
  String editorPoolRemoved(String name) {
    return 'Hráč $name odebrán ze širšího kádru';
  }

  @override
  String get editorPoolRemove => 'Odebrat ze širšího kádru';

  @override
  String get editorPoolPlayerGone => 'Tento hráč už v širším kádru není.';

  @override
  String get editorPoolDuplicate =>
      'Toto jméno má v širším kádru ještě jiný hráč.';

  @override
  String get editorPoolEmpty =>
      'V širším kádru nejsou žádní hráči. Přidejte prvního.';

  @override
  String get editorPoolLoadFailed => 'Kádr hry se nepodařilo načíst.';

  @override
  String editorPlayerTraitsUnknownDropped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odebráno $count neznámých vlastností',
      few: 'Odebrány $count neznámé vlastnosti',
      one: 'Odebrána 1 neznámá vlastnost',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedTag => 'Přidáno';

  @override
  String get editorAddedGroup => 'Přidané';

  @override
  String get editorAddedGameGroup => 'Ve hře';

  @override
  String get editorAddClub => 'Přidat klub';

  @override
  String get editorAddSponsor => 'Přidat sponzora';

  @override
  String get editorAddY => 'Přidat účet';

  @override
  String get editorAddedAdd => 'Přidat';

  @override
  String get editorAddedDelete => 'Smazat';

  @override
  String editorAddedRemoved(String name) {
    return 'Smazáno: $name';
  }

  @override
  String editorAddedClubsFull(int max) {
    return 'Databáze může přidat nejvýše $max klubů.';
  }

  @override
  String editorAddedSponsorsFull(int max) {
    return 'Databáze může přidat nejvýše $max sponzorů.';
  }

  @override
  String editorAddedYFull(int max) {
    return 'Databáze může přidat nejvýše $max účtů.';
  }

  @override
  String get editorAddedGone => 'Toto už v databázi není.';

  @override
  String get editorAddedNameNeeded => 'Zadejte název';

  @override
  String get editorAddedCountry => 'Země';

  @override
  String get editorAddedCountryPick => 'Vyberte zemi';

  @override
  String editorAddedNoLeague(String country) {
    return 'Země $country nemá ve hře ligu ani města, takže tento klub dostane jen hráče, které do něj sami umístíte.';
  }

  @override
  String editorAddedClubTaken(String country) {
    return 'Země $country už klub s tímto názvem má.';
  }

  @override
  String get editorAddedClubGameName => 'Tento název už nese klub ve hře.';

  @override
  String editorAddedClubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Hraje zde $count hráčů této databáze. Po smazání klubu je umístí hra.',
      few:
          'Hrají zde $count hráči této databáze. Po smazání klubu je umístí hra.',
      one: 'Hraje zde 1 hráč této databáze. Po smazání klubu ho umístí hra.',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedDeal => 'Typ smlouvy';

  @override
  String get editorDealBigPayer => 'Štědrý plátce';

  @override
  String get editorDealCrowdPleaser => 'Oblíbenec kabiny';

  @override
  String get editorDealFamilyFriendly => 'Rodinný';

  @override
  String get editorDealMarketing => 'Marketing';

  @override
  String get editorAddedIndustry => 'Obor';

  @override
  String get editorAddedIndustryPick => 'Vyberte obor';

  @override
  String get editorAddedDescription => 'Popis (nepovinný)';

  @override
  String get editorAddedDescriptionHelp =>
      'Když zůstane prázdný, nabídka použije obvyklý text typu smlouvy.';

  @override
  String get editorAddedVoice => 'Typ účtu';

  @override
  String get editorYVoiceFan => 'Fanoušek';

  @override
  String get editorYVoicePundit => 'Expert';

  @override
  String get editorYVoiceMeme => 'Memy';

  @override
  String get editorYVoiceStats => 'Statistiky';

  @override
  String get editorYVoiceRival => 'Rival';

  @override
  String get editorYVoiceExpro => 'Bývalý profík';

  @override
  String get editorYVoiceNeutral => 'Neutrál';

  @override
  String get editorYVoiceFanAbout =>
      'Jeden z vašich fanoušků. Nadšený, zuřivý, vrtkavý.';

  @override
  String get editorYVoicePunditAbout =>
      'Rozvážný hlas, který se ozývá celou kariéru.';

  @override
  String get editorYVoiceMemeAbout =>
      'Neřekne nic užitečného a všichni ho čtou první.';

  @override
  String get editorYVoiceStatsAbout => 'Píše čísla a nic jiného.';

  @override
  String get editorYVoiceRivalAbout => 'Užívá si vaše nezdary.';

  @override
  String get editorYVoiceExproAbout =>
      'Bývalý reprezentant se sloupkem a bez trpělivosti.';

  @override
  String get editorYVoiceNeutralAbout =>
      'Sleduje všechen fotbal a ozve se, jen když se stane něco velkého.';

  @override
  String get editorAddedPostsIn => 'Píše v';

  @override
  String get editorAddedAllNations => 'Všechny země';

  @override
  String get editorAddedSearch => 'Hledat';

  @override
  String editorCountAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count přidaných',
      few: '$count přidané',
      one: '1 přidaný',
    );
    return '$_temp0';
  }

  @override
  String get editorNamesOutlet => 'Médium';

  @override
  String get editorNamesFirstNames => 'Křestní jména';

  @override
  String get editorNamesSurnames => 'Příjmení';

  @override
  String editorNamesFirstCount(int count, int min) {
    return '$count / $min křestních jmen';
  }

  @override
  String editorNamesSurCount(int count, int min) {
    return '$count / $min příjmení';
  }

  @override
  String editorNamesListsHelp(int min) {
    return 'Jména oddělte čárkami nebo novými řádky. Každý seznam potřebuje aspoň $min jmen. Dostanou je noví hráči, místní fanoušci a realizační tým.';
  }

  @override
  String editorNamesListCounts(int first, int sur) {
    return '$first křestních jmen, $sur příjmení';
  }

  @override
  String editorNamesMainStadium(String city) {
    return 'Hlavní stadion ve městě $city';
  }

  @override
  String get editorNamesChanged => 'Změněno';

  @override
  String get editorNamesPick => 'Vyberte jméno, které chcete upravit.';

  @override
  String get editorNamesStadiumsNote =>
      'Přejmenovat lze jen národní stadiony uvedené zde: hlavní stadion každého města.';

  @override
  String get editorTrophiesIntro =>
      'Klepněte na trofej a dejte jí vlastní obrázek. Nejlépe vypadá PNG s průhledným pozadím.';

  @override
  String get editorTrophyCustom => 'Vlastní';

  @override
  String get editorTrophyDefault => 'Obrázek ze hry';

  @override
  String get editorTrophyChoose => 'Vybrat obrázek';

  @override
  String get editorTrophyReplace => 'Vybrat jiný obrázek';

  @override
  String get editorTrophyReset => 'Zpět na výchozí';

  @override
  String get editorTrophyResetTitle => 'Použít obrázek ze hry?';

  @override
  String get editorTrophyResetBody =>
      'Váš obrázek této trofeje bude odstraněn. Tlačítkem Zpět ho nevrátíte.';

  @override
  String get editorTrophyResetConfirm => 'Odstranit obrázek';

  @override
  String get editorTrophyUnusable =>
      'Tento obrázek nelze použít. Vyberte PNG nebo JPEG s nejvýše 4096 pixely na každé straně.';

  @override
  String get editorTrophyOpening => 'Otevírám obrázek';

  @override
  String get editorTrophyPreparing => 'Připravuji trofej';

  @override
  String get editorTrophyFrameTitle => 'Umístěte trofej';

  @override
  String get editorTrophyFrameHint =>
      'Tažením obrázek posunete, roztažením prstů přiblížíte. Co je uvnitř rámečku, bude trofej.';

  @override
  String get editorTrophyFit => 'Celý obrázek';

  @override
  String get editorTrophyPreview => 'Náhled';

  @override
  String get editorTrophyPreviewTitle => 'Jak bude vypadat';

  @override
  String get editorTrophyAdjust => 'Upravit';

  @override
  String get editorTrophyUse => 'Použít obrázek';

  @override
  String get editorTrophyRectangle =>
      'Tento obrázek nemá průhledné pozadí, takže se ve hře zobrazí jako obdélník.';

  @override
  String get editorTrophyRectangleShort => 'Zobrazí se jako obdélník';

  @override
  String get editorTrophySaved => 'Obrázek trofeje uložen.';

  @override
  String get editorTrophyRemoved => 'Obrázek ze hry je zpět.';

  @override
  String get editorTrophySaveFailed =>
      'Obrázek se nepodařilo uložit. Zkuste to znovu.';

  @override
  String get editorSaveFailed =>
      'Poslední změny se nepodařilo uložit. Zkoušíme to znovu.';

  @override
  String get editorTrophyPick => 'Vyberte trofej a změňte její obrázek.';

  @override
  String editorTrophySize(int width, int height) {
    return 'Uloží se v rozměru $width x $height pixelů';
  }

  @override
  String editorIssueUnknownEntry(String name) {
    return '$name už ve hře není';
  }

  @override
  String get editorAttentionBody =>
      'Něco v této databázi nesedí s touto verzí hry: shoda názvů, nebo něco, co aktualizace hry odebrala. Opravte nebo odeberte každou položku níže a půjde na ní znovu začít kariéru.';

  @override
  String get editorRemove => 'Odebrat';

  @override
  String worldChip(String name) {
    return 'Svět: $name';
  }

  @override
  String get worldDefault => 'Výchozí';

  @override
  String get worldDefaultAbout => 'Vlastní svět hry';

  @override
  String get worldSheetTitle => 'Vyberte svět';

  @override
  String get worldSheetBlurb =>
      'Databáze, které jste vytvořili nebo otevřeli v Editoru. Kariéru lze začít jen na úplné.';

  @override
  String get worldPackGone =>
      'Tato databáze už v zařízení není. Kariéra nebyla zahájena.';

  @override
  String get worldStarting => 'Připravujeme váš svět';

  @override
  String get settingsDefaultWorldTitle => 'Výchozí svět';

  @override
  String get settingsDefaultWorldBlurb =>
      'Svět, na kterém začíná nová hra. Pro každou kariéru ho můžete změnit.';

  @override
  String get worldPackNotReady =>
      'Na této databázi už nelze začít kariéru. Opravte ji v Editoru, nebo vyberte jiný svět.';

  @override
  String pitchComShotGoal1(String player) {
    return 'GÓL! $player se trefuje!';
  }

  @override
  String pitchComShotGoal2(String player) {
    return '$player pálí a je to tam! GÓL!';
  }

  @override
  String pitchComShotGoal3(String player) {
    return 'GÓL! $player zakončuje chladnokrevně.';
  }

  @override
  String pitchComShotSaved1(String player, String keeper) {
    return '$player střílí, ale $keeper chytá.';
  }

  @override
  String pitchComShotSaved2(String player) {
    return '$player to zkouší, brankář je ale na místě.';
  }

  @override
  String pitchComShotSaved3(String player, String keeper) {
    return '$player pálí, $keeper vyráží!';
  }

  @override
  String pitchComShotWide1(String player) {
    return '$player střílí vedle.';
  }

  @override
  String pitchComShotWide2(String player) {
    return '$player míří mimo bránu.';
  }

  @override
  String pitchComShotWide3(String player) {
    return '$player to posílá těsně kolem tyče.';
  }

  @override
  String pitchComShotBlocked1(String player) {
    return '$player střílí, ale do bloku.';
  }

  @override
  String pitchComShotBlocked2(String player) {
    return 'Zblokováno! $player se přes obranu nedostává.';
  }

  @override
  String pitchComShotBlocked3(String player) {
    return '$player pálí, obránce ale střelu zastavuje.';
  }

  @override
  String pitchComShotWoodwork1(String player) {
    return 'Tyč! $player nemá štěstí.';
  }

  @override
  String pitchComShotWoodwork2(String player) {
    return '$player trefuje tyč!';
  }

  @override
  String pitchComShotWoodwork3(String player) {
    return 'Břevno! $player má smůlu.';
  }

  @override
  String pitchComHeaderGoal1(String player) {
    return 'GÓL! $player hlavou skóruje!';
  }

  @override
  String pitchComHeaderGoal2(String player) {
    return '$player vyskakuje nejvýš a hlavičkou skóruje!';
  }

  @override
  String pitchComHeaderGoal3(String player) {
    return 'GÓL! $player se prosazuje tvrdou hlavičkou.';
  }

  @override
  String pitchComHeaderSaved1(String player, String keeper) {
    return '$player hlavičkuje, $keeper chytá.';
  }

  @override
  String pitchComHeaderSaved2(String player) {
    return '$player hlavičkuje, brankář ale drží.';
  }

  @override
  String pitchComHeaderSaved3(String player, String keeper) {
    return '$player to zkouší hlavou, $keeper vyráží.';
  }

  @override
  String pitchComHeaderWide1(String player) {
    return '$player hlavičkuje vedle.';
  }

  @override
  String pitchComHeaderWide2(String player) {
    return '$player hlavou mimo bránu.';
  }

  @override
  String pitchComHeaderWide3(String player) {
    return '$player posílá hlavičku nad.';
  }

  @override
  String pitchComHeaderBlocked1(String player) {
    return '$player hlavičkuje, ale do bloku.';
  }

  @override
  String pitchComHeaderBlocked2(String player) {
    return '$player míří hlavou, obrana ale blokuje.';
  }

  @override
  String pitchComHeaderBlocked3(String player) {
    return 'Zblokováno! $player se dostává k hlavičce, obránce ale stojí v cestě.';
  }

  @override
  String pitchComHeaderWoodwork1(String player) {
    return '$player hlavičkuje do břevna!';
  }

  @override
  String pitchComHeaderWoodwork2(String player) {
    return 'Tyč! $player hlavičkuje a míč se odráží zpět do pole.';
  }

  @override
  String pitchComHeaderWoodwork3(String player) {
    return '$player hlavou otřásá břevnem!';
  }

  @override
  String pitchComSetPieceGoal1(String player) {
    return 'GÓL! $player si na míč naskakuje!';
  }

  @override
  String pitchComSetPieceGoal2(String player, String other) {
    return 'GÓL! $other centruje a $player skóruje!';
  }

  @override
  String pitchComSetPieceGoal3(String player) {
    return 'Ze standardky skóruje $player! GÓL!';
  }

  @override
  String pitchComSetPieceSaved1(String player, String keeper) {
    return '$player se k míči dostává, $keeper ale chytá.';
  }

  @override
  String pitchComSetPieceSaved2(String player) {
    return '$player míč tečuje, brankář ho sbírá.';
  }

  @override
  String pitchComSetPieceSaved3(String player, String keeper) {
    return '$player zakončuje, $keeper je ale pozorný.';
  }

  @override
  String pitchComSetPieceWide1(String player) {
    return '$player se dostává k zakončení, ale mimo.';
  }

  @override
  String pitchComSetPieceWide2(String player) {
    return '$player si na centr naskakuje, ale mine.';
  }

  @override
  String pitchComSetPieceWide3(String player) {
    return '$player posílá míč nad branku.';
  }

  @override
  String pitchComSetPieceBlocked1(String player) {
    return '$player zakončuje, ale do bloku.';
  }

  @override
  String pitchComSetPieceBlocked2(String player) {
    return 'Skrumáž ve vápně! $player pálí, ale do obránce.';
  }

  @override
  String pitchComSetPieceBlocked3(String player) {
    return '$player se snaží míč dotlačit, obrana ale odvrací.';
  }

  @override
  String pitchComSetPieceWoodwork1(String player) {
    return '$player zakončuje a trefuje tyč!';
  }

  @override
  String pitchComSetPieceWoodwork2(String player) {
    return 'Břevno! $player málem skóruje ze standardky.';
  }

  @override
  String pitchComSetPieceWoodwork3(String player) {
    return 'Tyč! $player po centru gól jen o chlup nedává.';
  }

  @override
  String pitchComDirectFreeKickGoal1(String player) {
    return 'GÓL! $player obstřeluje zeď a skóruje!';
  }

  @override
  String pitchComDirectFreeKickGoal2(String player) {
    return 'Jaký přímý kop! $player trefuje šibenici!';
  }

  @override
  String pitchComDirectFreeKickGoal3(String player) {
    return 'GÓL! $player z přímého kopu překonává brankáře.';
  }

  @override
  String pitchComDirectFreeKickSaved1(String player, String keeper) {
    return '$player to zkouší přímo, $keeper chytá.';
  }

  @override
  String pitchComDirectFreeKickSaved2(String player) {
    return '$player pálí z přímého kopu, brankář vyráží.';
  }

  @override
  String pitchComDirectFreeKickSaved3(String player, String keeper) {
    return 'Skvělý zákrok! $player pálí, $keeper přímý kop zneškodňuje.';
  }

  @override
  String pitchComDirectFreeKickWide1(String player) {
    return '$player posílá přímý kop nad.';
  }

  @override
  String pitchComDirectFreeKickWide2(String player) {
    return '$player míří přímo, ale vedle.';
  }

  @override
  String pitchComDirectFreeKickWide3(String player) {
    return '$player přímým kopem netrefuje bránu.';
  }

  @override
  String pitchComDirectFreeKickBlocked1(String player) {
    return '$player trefuje zeď.';
  }

  @override
  String pitchComDirectFreeKickBlocked2(String player) {
    return '$player pálí do zdi.';
  }

  @override
  String pitchComDirectFreeKickBlocked3(String player) {
    return 'Zeď drží, $player se přes ni nedostává.';
  }

  @override
  String pitchComDirectFreeKickWoodwork1(String player) {
    return '$player z přímého kopu trefuje břevno!';
  }

  @override
  String pitchComDirectFreeKickWoodwork2(String player) {
    return 'Tyč! $player pálí z přímého kopu a míč se odráží.';
  }

  @override
  String pitchComDirectFreeKickWoodwork3(String player) {
    return 'Brankáře zachraňuje břevno, $player má smůlu.';
  }

  @override
  String pitchComPenaltyGoal1(String player) {
    return 'GÓL! $player posílá brankáře na druhou stranu.';
  }

  @override
  String pitchComPenaltyGoal2(String player) {
    return '$player se rozbíhá a proměňuje! GÓL!';
  }

  @override
  String pitchComPenaltyGoal3(String player) {
    return 'GÓL! $player penaltu bezpečně proměňuje.';
  }

  @override
  String pitchComPenaltySaved1(String player, String keeper) {
    return 'Zákrok! $player kope, $keeper penaltu likviduje!';
  }

  @override
  String pitchComPenaltySaved2(String player) {
    return '$player se rozbíhá... a brankář chytá!';
  }

  @override
  String pitchComPenaltySaved3(String player, String keeper) {
    return '$player kope a $keeper vystihuje směr!';
  }

  @override
  String pitchComPenaltyMissed1(String player) {
    return '$player penaltu neproměňuje!';
  }

  @override
  String pitchComPenaltyMissed2(String player) {
    return 'Vedle! $player posílá penaltu kolem tyče.';
  }

  @override
  String pitchComPenaltyMissed3(String player) {
    return 'Nad! $player penaltu přestřeluje.';
  }

  @override
  String pitchComPenaltyWoodwork1(String player) {
    return '$player z penalty trefuje tyč!';
  }

  @override
  String pitchComPenaltyWoodwork2(String player) {
    return 'Břevno! $player penaltu neproměňuje.';
  }

  @override
  String pitchComPenaltyWoodwork3(String player) {
    return 'Tyč! $player nevěří vlastním očím.';
  }

  @override
  String pitchComPenaltyAwarded1(String player) {
    return 'Penalta! $player padá ve vápně.';
  }

  @override
  String pitchComPenaltyAwarded2(String player, String other) {
    return 'Rozhodčí ukazuje na puntík! $other fauluje, $player leží ve vápně.';
  }

  @override
  String pitchComPenaltyAwarded3(String player, String other) {
    return 'Pokutový kop! $other ve vápně fauluje, $player padá.';
  }

  @override
  String pitchComPenaltyAwardedYellow1(String player, String other) {
    return 'Penalta! $player padá ve vápně a $other vidí žlutou.';
  }

  @override
  String pitchComPenaltyAwardedYellow2(String player, String other) {
    return 'Pokutový kop! $other dostává žlutou, faulovaný $player leží ve vápně.';
  }

  @override
  String pitchComPenaltyAwardedYellow3(String player, String other) {
    return 'Penalta a karta! $other ve vápně podráží, $player padá.';
  }

  @override
  String pitchComPenaltyAwardedRed1(String player, String other) {
    return 'Penalta a červená! $player padá ve vápně, $other jde ze hřiště.';
  }

  @override
  String pitchComPenaltyAwardedRed2(String player, String other) {
    return 'Pokutový kop a $other letí ven! Faulovaný $player leží ve vápně.';
  }

  @override
  String pitchComPenaltyAwardedRed3(String player, String other) {
    return 'Červená a penalta! $player jde sám na bránu a $other ho ve vápně sráží.';
  }

  @override
  String pitchComCorner1(String player) {
    return 'Roh. Zahrává $player.';
  }

  @override
  String pitchComCorner2(String player) {
    return '$player posílá rohový kop do vápna.';
  }

  @override
  String pitchComCorner3(String player) {
    return 'Rohový kop, k míči se staví $player.';
  }

  @override
  String pitchComFreeKick1(String player) {
    return 'Volný kop. Zahrává $player.';
  }

  @override
  String pitchComFreeKick2(String player) {
    return 'Standardka z nebezpečné pozice. K míči se staví $player.';
  }

  @override
  String pitchComFreeKick3(String player) {
    return '$player se chystá k zahrání standardky.';
  }

  @override
  String pitchComLongThrow1(String player) {
    return 'Dlouhý aut! $player hází až do vápna.';
  }

  @override
  String pitchComLongThrow2(String player) {
    return '$player vhazuje dlouhý aut do vápna.';
  }

  @override
  String pitchComLongThrow3(String player) {
    return 'Přichází dlouhý aut, hází $player.';
  }

  @override
  String pitchComFoulYellow1(String player) {
    return '$player vidí žlutou kartu.';
  }

  @override
  String pitchComFoulYellow2(String player, String other) {
    return '$player dostává žlutou za faul, $other zůstává ležet.';
  }

  @override
  String pitchComFoulYellow3(String player, String other) {
    return 'Pozdní zákrok, $other padá a $player vidí žlutou.';
  }

  @override
  String pitchComFoulSecondYellow1(String player) {
    return 'Druhá žlutá! $player jde ze hřiště.';
  }

  @override
  String pitchComFoulSecondYellow2(String player) {
    return '$player dostává druhou žlutou a končí.';
  }

  @override
  String pitchComFoulSecondYellow3(String player) {
    return '$player vidí druhou žlutou, a tedy červenou.';
  }

  @override
  String pitchComFoulRed1(String player) {
    return 'Červená karta! $player musí ze hřiště.';
  }

  @override
  String pitchComFoulRed2(String player, String other) {
    return 'Přímá červená! $player fauluje, $other zůstává ležet.';
  }

  @override
  String pitchComFoulRed3(String player) {
    return '$player vidí červenou a musí odejít.';
  }

  @override
  String pitchComOffside1(String player) {
    return 'Ofsajd, $player vybíhá příliš brzy.';
  }

  @override
  String pitchComOffside2(String player) {
    return 'Praporek jde nahoru, $player je v ofsajdu.';
  }

  @override
  String pitchComOffside3(String player) {
    return '$player v ofsajdu, útok končí.';
  }

  @override
  String pitchComSub1(String player, String other) {
    return 'Střídání: $player přichází, $other odchází.';
  }

  @override
  String pitchComSub2(String player, String other) {
    return '$other jde ze hřiště, nahrazuje ho $player.';
  }

  @override
  String pitchComSub3(String player, String other) {
    return 'Na hřiště jde $player, odchází $other.';
  }

  @override
  String pitchComSubFill1(String player) {
    return 'Na hřiště přichází $player.';
  }

  @override
  String pitchComSubFill2(String player) {
    return 'Střídání: nastupuje $player.';
  }

  @override
  String pitchComSubFill3(String player) {
    return '$player jde do hry.';
  }

  @override
  String pitchComInjury1(String player) {
    return '$player leží a potřebuje ošetření.';
  }

  @override
  String pitchComInjury2(String player) {
    return '$player kulhá, vypadá to na zranění.';
  }

  @override
  String pitchComInjury3(String player) {
    return 'Zdravotníci jsou na hřišti, $player nemůže pokračovat.';
  }

  @override
  String pitchComGoalScore(String line, int home, int away) {
    return '$line $home–$away';
  }

  @override
  String get pitchComSomeone => 'Hráč';

  @override
  String pitchComPenaltyAwardedSecondYellow1(String player, String other) {
    return 'Penalta a druhá žlutá! $other jde ze hřiště, $player leží ve vápně.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow2(String player, String other) {
    return 'Pokutový kop! $player padá a $other vidí druhou žlutou.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow3(String player, String other) {
    return 'Penalta! $other podráží ve vápně, $player padá a je z toho druhá žlutá.';
  }

  @override
  String get matchViewChooseTitle => 'Jak chcete zápas sledovat?';

  @override
  String get matchViewChooseHint =>
      'Volba platí i pro další zápasy. Přepnout můžete kdykoli.';

  @override
  String get matchViewPitch => '2D TV';

  @override
  String get matchViewPitchBlurb => 'Hráči v akci na hřišti';

  @override
  String get matchViewTimeline => 'Průběh';

  @override
  String get matchViewTimelineBlurb => 'Zápas událost po události';

  @override
  String get matchViewSwitchToPitch => 'Sledovat ve 2D TV';

  @override
  String get matchViewSwitchToTimeline => 'Sledovat průběh';

  @override
  String get matchTabCommentary => 'KOMENTÁŘ';

  @override
  String get matchSubShout => 'STŘÍDÁNÍ';

  @override
  String matchSubOff(String name) {
    return 'Odchází: $name';
  }

  @override
  String matchSubOn(String name) {
    return 'Přichází: $name';
  }

  @override
  String get editorFilterToFix => 'K opravě';

  @override
  String get editorNothingToFix => 'Tady není co opravovat.';

  @override
  String get editorPromoteTooltip => 'Přesunout do kádru';

  @override
  String editorPromoted(String name) {
    return 'Hráč $name přesunut do kádru';
  }

  @override
  String get editorPromoteFullTitle => 'Kádr je plný';

  @override
  String editorPromoteFullBody(int max) {
    return 'Kádr může mít nejvýše $max hráčů. Vyberte hráče, který se místo něj vrátí do širšího kádru.';
  }

  @override
  String get editorTrophyGallery => 'Vybrat z fotek';

  @override
  String get editorTrophyFile => 'Vybrat soubor';

  @override
  String clubStrengthOf(int stars) {
    return 'Síla klubu: $stars z 5';
  }

  @override
  String get editorClubStrength => 'Síla';

  @override
  String get editorClubStrengthDefault => 'Výchozí';

  @override
  String editorClubStrengthHelp(int stars) {
    return 'Lepší hráči chodí do silnějších klubů. Výchozí: $stars z 5 podle jeho ligy.';
  }

  @override
  String mgrNewsSacked(String nation, String name) {
    return '$nation: trenér $name odvolán';
  }

  @override
  String mgrNewsResigned(String nation, String name) {
    return '$nation: trenér $name rezignoval';
  }

  @override
  String mgrNewsPoached(String nation, String name) {
    return '$nation: trenér $name odchází k jiné reprezentaci';
  }

  @override
  String mgrNewsRetired(String nation, String name) {
    return '$nation: trenér $name končí s trénováním';
  }

  @override
  String mgrNewsContractEnd(String nation, String name) {
    return '$nation: trenérovi $name vypršela smlouva';
  }

  @override
  String mgrNewsReplacedByPlayer(String nation, String name) {
    return '$nation: trenér $name vám uvolňuje místo';
  }

  @override
  String mgrNewsAppointed(String nation, String name) {
    return '$nation: novým trenérem je $name';
  }

  @override
  String mgrNewsAppointedBody(String nation, String name) {
    return '$nation: lavičku přebírá $name.';
  }

  @override
  String pressBeatOpposingManager(String manager) {
    return 'Vy a $manager máte svou historii. Chcete k němu něco říct?';
  }

  @override
  String get pressAnswerHitBackAtManager => 'Ať se stará o svůj tým.';

  @override
  String get pressAnswerRespectManager => 'Mám k němu velký respekt.';

  @override
  String yMgrTie1(String manager) {
    return 'Příště na druhé lavičce $manager. S naším trenérem mají svou historii a já se nemůžu dočkat.';
  }

  @override
  String yMgrTie2(String manager) {
    return 'Příště proti nám $manager. S naším trenérem se znají už nějakou dobu.';
  }

  @override
  String yMgrTie3(String manager) {
    return 'Zase $manager. Ať z toho náš trenér zase nedělá osobní souboj.';
  }

  @override
  String yMgrTie4(String manager) {
    return 'A je to tady. U lajny $manager a náš trenér bude zase řešit osobní spor místo zápasu.';
  }

  @override
  String get mgrRowLabel => 'Trenér';

  @override
  String mgrRowDetail(int age, String date) {
    return '$age let, od $date';
  }

  @override
  String mgrRecordWdl(int won, int drawn, int lost) {
    return '$won V, $drawn R, $lost P';
  }

  @override
  String mgrRowRecord(String record) {
    return 'Pod jeho vedením: $record';
  }

  @override
  String get mgrTieNeutral => 'Bez společné historie';

  @override
  String get mgrTieRespect => 'Respekt';

  @override
  String get mgrTieRival => 'Rival';

  @override
  String get mgrTieGrudge => 'Zášť';

  @override
  String get mgrTieSuccessor => 'Nástupce';

  @override
  String get mgrTieProtege => 'Chráněnec';

  @override
  String get mgrTieFormerPlayer => 'Bývalý hráč';

  @override
  String get mgrEndSacked => 'Odvolán';

  @override
  String get mgrEndResigned => 'Rezignoval';

  @override
  String get mgrEndPoached => 'Odešel k jiné reprezentaci';

  @override
  String get mgrEndRetired => 'Skončil s trénováním';

  @override
  String get mgrEndContractEnd => 'Vypršela smlouva';

  @override
  String get mgrEndReplacedByPlayer => 'Nahrazen vámi';

  @override
  String get mgrProfileSpells => 'Kariéra';

  @override
  String mgrProfileSpellNow(String nation, String from) {
    return '$nation, od $from';
  }

  @override
  String mgrProfileSpellRange(String nation, String from, String to) {
    return '$nation, $from až $to';
  }

  @override
  String mgrProfileSpellEnded(String range, String reason) {
    return '$range, $reason';
  }

  @override
  String get mgrProfileRecordVsYou => 'Bilance proti vám';

  @override
  String get mgrProfileNoMeetings => 'Zatím jste se nepotkali';

  @override
  String get mgrProfileReputation => 'Reputace';

  @override
  String get mgrProfileAge => 'Věk';

  @override
  String get mgrProfileAppointed => 'Jmenován';

  @override
  String get mgrProfileStyle => 'Styl';

  @override
  String get mgrProfileTie => 'Mezi vámi';

  @override
  String mgrPreviewLine(String name) {
    return 'Jejich trenér: $name';
  }

  @override
  String mgrDossierStyle(String style) {
    return 'Styl trenéra: $style';
  }

  @override
  String mgrDossierRecord(String record) {
    return 'Vaše bilance proti němu: $record';
  }

  @override
  String get mgrStylePossession => 'Držení míče';

  @override
  String get mgrStyleHighPress => 'Vysoký presink';

  @override
  String get mgrStyleDefensive => 'Defenzivní';

  @override
  String get mgrStyleDirect => 'Přímočarý';

  @override
  String get mgrStyleCounter => 'Brejky';

  @override
  String get mgrStyleFlair => 'Technický';

  @override
  String get mgrStylePhysical => 'Fyzický';

  @override
  String get mgrStyleBalanced => 'Vyvážený';

  @override
  String get mgrListTitle => 'Trenéři';

  @override
  String get mgrListCurrent => 'Současní';

  @override
  String get mgrListRecentMoves => 'Poslední změny';

  @override
  String get mgrListFilterAll => 'Vše';

  @override
  String get mgrListSortReputation => 'Reputace';

  @override
  String get mgrListSortName => 'Jméno';

  @override
  String get mgrListEmptyMoves => 'Za poslední dva roky žádné změny.';

  @override
  String get mgrListEmptyCurrent =>
      'Trenéři se objeví po přechodu do další sezóny.';

  @override
  String get editorSectionManagers => 'Trenéři';

  @override
  String get editorAboutManagers => 'Kdo vede kterou reprezentaci na začátku';

  @override
  String get editorManagersHint => 'Vybere se při startu kariéry';

  @override
  String get editorManagerName => 'Jméno trenéra';

  @override
  String get editorManagerNationality => 'Národnost';

  @override
  String editorIssueManagerName(int max) {
    return 'Trenér potřebuje jméno o 1 až $max znacích, které hra umí zobrazit';
  }

  @override
  String get editorIssueManagerNationality =>
      'Vyber trenérovi národnost ze seznamu';

  @override
  String get shareButton => 'Sdílet';

  @override
  String get shareSheetTitle => 'Sdílet jako obrázek';

  @override
  String get shareFormatSquare => 'Čtverec';

  @override
  String get shareFormatStory => 'Příběh';

  @override
  String get shareFailed => 'Obrázek se nepodařilo vytvořit.';

  @override
  String get shareSaveToPhotos => 'Uložit do fotek';

  @override
  String get shareSavedToPhotos => 'Uloženo do fotek';

  @override
  String get sharePhotosDenied =>
      'FNM nemá povolení ukládat do fotek. Můžete ho povolit v Nastavení.';

  @override
  String get editorCountryAll => 'Všechny země';

  @override
  String get editorCountryFilterTitle => 'Filtr podle země';

  @override
  String get shareCabinetBig => 'Sdílet moje trofeje';

  @override
  String yExitProud0(String competition) {
    return 'Nečekaná jízda na turnaji $competition a nakonec skvělý výsledek. Jsem na kluky hrdý.';
  }

  @override
  String yExitProud1(String competition) {
    return 'Na turnaji $competition nám nikdo nedával šanci. Došli jsme dál, než si kdo troufl snít. Díky, kluci.';
  }

  @override
  String yExitProud2(String competition) {
    return 'Konec na turnaji $competition, ale jaká to byla jízda. Tenhle tým donutil celou zemi věřit. Hrdost.';
  }

  @override
  String yExitProud3(String competition) {
    return 'Že na turnaji $competition postoupíme ze skupiny, jsem nečekal. Všechno potom byl bonus. Jedeme dál a výš.';
  }

  @override
  String yExitProud4(String competition) {
    return 'Na turnaj $competition jsme jeli s nadějí na bod nebo dva a vracíme se z vyřazovací fáze. Povedený turnaj.';
  }

  @override
  String yExitProud5(String competition) {
    return 'Na turnaji $competition jsme došli dál, než říkaly předpoklady. To je krok dopředu, jednoduše.';
  }

  @override
  String yExitProud6(String competition) {
    return 'Konec na turnaji $competition trochu bolí. Ale buďme upřímní: takhle daleko nás nečekal nikdo.';
  }

  @override
  String yExitProud7(String competition) {
    return 'Dobře, na turnaji $competition jsme skončili. Pořád víc, než se nám povedlo za poslední roky. Beru.';
  }

  @override
  String yExitProud8(String competition) {
    return 'Z turnaje $competition trofej nevezeme a nikdy jsme ani nemohli. Dobrá jízda je dobrá jízda. Teď to zopakujte.';
  }

  @override
  String get yReactionPride0 => 'Jsem hrdý na každého z nich.';

  @override
  String get yReactionPride1 => 'Jaká jízda. Díky, kluci.';

  @override
  String get yReactionPride2 => 'Tohle nikdo nečekal. Na to nezapomeňte.';

  @override
  String get yReactionPride3 => 'Dál a výš.';

  @override
  String get yReactionPride4 => 'Všechno to byl bonus. Užijte si to.';

  @override
  String get yReactionPride5 =>
      'Lepší, než kdokoli předpovídal. Povedený turnaj.';

  @override
  String get yReactionPride6 => 'Venku, ale bez ostudy. To beru.';

  @override
  String get yReactionPride7 =>
      'Postoupil lepší tým. Stejně jsme si udělali čest.';

  @override
  String get yReactionPride8 => 'Nenechme se unést. Ale jo, povedená jízda.';

  @override
  String yExitAccepted0(String competition) {
    return 'Konec na turnaji $competition, zhruba tam, kde se to čekalo. Jsem rád, že to zkusili naplno.';
  }

  @override
  String yExitAccepted1(String competition) {
    return 'Turnaj $competition pro nás skončil. Velkým týmům jsme dali zabrat. Hlavy vzhůru, kluci.';
  }

  @override
  String yExitAccepted2(String competition) {
    return 'Konec na turnaji $competition. Na papíře to tak dopadnout mělo. Poučit se a jít dál.';
  }

  @override
  String yExitAccepted3(String competition) {
    return 'Náš turnaj $competition končí tam, kde to říkal žebříček. Žádná ostuda.';
  }

  @override
  String yExitAccepted4(String competition) {
    return 'Konec na turnaji $competition, jak většina z nás čekala. Žádná katastrofa, jen ani žádné překvapení.';
  }

  @override
  String yExitAccepted5(String competition) {
    return 'Turnaj $competition byl na tenhle kádr zatím moc. Rozdíl je skutečný. Je čas ho dohnat.';
  }

  @override
  String get yReactionAcceptance0 => 'Dali do toho všechno. Víc chtít nejde.';

  @override
  String get yReactionAcceptance1 => 'Hlavy vzhůru. Vrátíme se.';

  @override
  String get yReactionAcceptance2 => 'Bolí to, ale ostudu nám neudělali.';

  @override
  String get yReactionAcceptance3 => 'Upřímně, zhruba co jsme čekali.';

  @override
  String get yReactionAcceptance4 => 'Postoupili lepší. Takový je fotbal.';

  @override
  String get yReactionAcceptance5 => 'Zklamaný, ne naštvaný.';

  @override
  String get yReactionAcceptance6 => 'Upřímně trochu bez šťávy. Ale žádný šok.';

  @override
  String get yReactionAcceptance7 => 'Ještě na to nemáme. Ví to každý.';

  @override
  String get yReactionAcceptance8 =>
      'Stejná úroveň jako minule. Příště to chce krok nahoru.';

  @override
  String get sponsorIndustryExtraSportswear => 'Sportovní oblečení';

  @override
  String get sponsorIndustryExtraAirline => 'Letecká společnost';

  @override
  String get sponsorIndustryExtraRailway => 'Železnice';

  @override
  String get sponsorIndustryExtraHotels => 'Hotelový řetězec';

  @override
  String get sponsorIndustryExtraCoffee => 'Kavárenský řetězec';

  @override
  String get sponsorIndustryExtraChocolate => 'Čokoláda';

  @override
  String get sponsorIndustryExtraMineralWater => 'Minerální voda';

  @override
  String get sponsorIndustryExtraPharmacy => 'Řetězec lékáren';

  @override
  String get sponsorIndustryExtraFashion => 'Móda';

  @override
  String get sponsorIndustryExtraWatches => 'Hodinář';

  @override
  String get sponsorIndustryExtraElectronics => 'Elektronika';

  @override
  String get sponsorIndustryExtraSoftware => 'Software';

  @override
  String get sponsorIndustryExtraStreaming => 'Streamovací služba';

  @override
  String get sponsorIndustryExtraSocialNetwork => 'Sociální síť';

  @override
  String get sponsorIndustryExtraFurniture => 'Nábytek';

  @override
  String get sponsorIndustryExtraTyres => 'Pneumatiky';

  @override
  String get sponsorIndustryExtraShipping => 'Námořní doprava';

  @override
  String get sponsorIndustryExtraLottery => 'Loterie';

  @override
  String get sponsorIndustryExtraTourism => 'Turistická centrála';

  @override
  String get sponsorIndustryExtraCosmetics => 'Kosmetika';

  @override
  String get sponsorIndustryExtraPetFood => 'Krmivo pro zvířata';

  @override
  String get sponsorIndustryExtraBakery => 'Pekárna';

  @override
  String get sponsorIndustryExtraSupermarket => 'Supermarket';

  @override
  String get sponsorIndustryExtraSportsNutrition => 'Sportovní výživa';

  @override
  String get sponsorIndustryExtraWine => 'Víno';

  @override
  String get sponsorIndustryExtraTea => 'Čaj';

  @override
  String get sponsorIndustryExtraRealEstate => 'Reality';

  @override
  String get sponsorIndustryExtraFitness => 'Fitness centra';

  @override
  String get sponsorIndustryExtraNewspaper => 'Deník';

  @override
  String mgrDetailCurrentJob(String nation) {
    return 'Současné působiště: $nation';
  }

  @override
  String get mgrDetailFree => 'Bez angažmá';

  @override
  String get mgrDetailMatches => 'Zápasy';

  @override
  String get mgrDetailTrophies => 'Trofeje';

  @override
  String get mgrDetailWinRate => 'Úspěšnost';

  @override
  String get mgrDetailRecord => 'Bilance';

  @override
  String get mgrDetailNationsLed => 'Vedené reprezentace';

  @override
  String get mgrDetailInCharge => 'Ve funkci';

  @override
  String get mgrDetailNoSpells => 'Zatím nevedl žádnou reprezentaci.';

  @override
  String get mgrDetailNotFound => 'Trenér nenalezen.';

  @override
  String get mgrDetailBackground => 'Minulost';

  @override
  String get mgrOriginFresh => 'Profesionální trenér';

  @override
  String get mgrOriginExAssistant => 'Bývalý asistent trenéra';

  @override
  String mgrNewsSeeManager(String name) {
    return 'Profil trenéra: $name';
  }
}
