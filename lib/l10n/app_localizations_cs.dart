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
    return '$count zápasů';
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
  String matchCouldNotContinue(String error) {
    return 'Nelze pokračovat: $error';
  }

  @override
  String get matchSkipToFullTime => 'Přeskočit do konce';

  @override
  String get matchStatShots => 'Střely';

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
  String get matchContinue => 'Pokračovat';

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
  String get teamOverallOverTime => 'VÝVOJ CELKOVÉHO HODNOCENÍ';

  @override
  String get teamOverall => 'Celkový přehled';

  @override
  String get teamTalkHeading => 'PORADA TÝMU';

  @override
  String get teamTalkPrompt => 'Nastavte tón pro druhý poločas.';

  @override
  String get teamTalkCalmLabel => 'Chladné hlavy';

  @override
  String get teamTalkCalmBlurb => 'Uklidněte tým — mírné celkové zlepšení.';

  @override
  String get teamTalkEncourageLabel => 'Povzbuzení';

  @override
  String get teamTalkEncourageBlurb => 'Zatlačte dopředu a jděte si pro zápas.';

  @override
  String get teamTalkDemandMoreLabel => 'Žádejte víc';

  @override
  String get teamTalkDemandMoreBlurb => 'Vsaďte vše na útok — zaútočte naplno.';

  @override
  String get teamTalkPraiseLabel => 'Držte to vzadu';

  @override
  String get teamTalkPraiseBlurb => 'Zůstaňte kompaktní a udržte si náskok.';

  @override
  String get teamTalkBelieveLabel => 'Věřte si';

  @override
  String get teamTalkBelieveBlurb =>
      'Věřte si — zlepšení na obou koncích hřiště.';

  @override
  String get teamTalkFocusLabel => 'Zůstaňte koncentrovaní';

  @override
  String get teamTalkFocusBlurb => 'Naprostá koncentrace — zamkněte zápas.';

  @override
  String get teamTalkUrgencyLabel => 'Pocit naléhavosti';

  @override
  String get teamTalkUrgencyBlurb =>
      'Hned to dožeňte — vše dopředu, otevřete obranu.';

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
  String get navCareers => 'Moje kariéra';

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
  String get settingsLanguageEnglish => 'Angličtina';

  @override
  String get settingsLanguageCzech => 'Čeština';

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
    return '$count startů';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count gólů';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count asistencí';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MOTM';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count zápasů';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count zápasů';
  }

  @override
  String recordsCodeWins(String code) {
    return 'výhry $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings zápasů · ${wins}V ${draws}R ${losses}P';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}V ${draws}R ${losses}P';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings zápasů · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a a $b se v této hře nikdy nepotkali.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names vyloučen — bez náhrady, hrajete v oslabení.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Potřeba $required k dispozici ($have fit)';
  }

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
    return 'Vyberte alespoň $min hráčů.';
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
  String get tacticsSquadLockedBack => 'Kádr uzamčen — zpět';

  @override
  String get tacticsConfirmSquad => 'Potvrdit kádr';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Kádr je plný — max $max';
  }

  @override
  String get tacticsSquadLocked => 'KÁDR UZAMČEN';

  @override
  String get tacticsNominationOpen => 'NOMINACE OTEVŘENA — VYBERTE KÁDR';

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
  String tacticsSubstitutesCount(int count) {
    return 'NÁHRADNÍCI · $count';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'STŘÍDÁNÍ · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Přetáhněte náhradníka na hráče a pošlete ho na hřiště.';

  @override
  String get tacticsNoSubs => 'Žádní náhradníci k dispozici.';

  @override
  String get tacticsFormation => 'ROZESTAVENÍ';

  @override
  String get tacticsInstructions => 'POKYNY';

  @override
  String get matchInstructionsLocked =>
      'Nastaveno před výkopem. Rozestavení a střídání měnit můžeš, ale herní styl už v průběhu zápasu ne.';

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
  String tacticsPickRole(String role) {
    return 'VYBERTE $role';
  }

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · mimo pozici';
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
    return '$name — $reason';
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
  String get tacticsPenalties => 'Penalty';

  @override
  String get tacticsCornersFreeKicks => 'Rohy a volné kopy';

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
  String tacticsUnavailableCount(int count) {
    return 'NEDOSTUPNÍ · $count';
  }

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
          '$count hráčů základní sestavy chybí (trest nebo zranění) — vyberte náhrady',
      few:
          '$count hráči základní sestavy chybí (trest nebo zranění) — vyberte náhrady',
      one:
          '1 hráč základní sestavy chybí (trest nebo zranění) — vyberte náhradu',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Základní sestava není kompletní — obsaďte volná místa',
      one: 'Základní sestava není kompletní — obsaďte volné místo',
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
    return '$name · $goals gólů';
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
  String get hubNextMatch => 'PŘÍŠTÍ ZÁPAS';

  @override
  String get hubVs => 'VS';

  @override
  String get hubSquadStatus => 'STAV KÁDRU';

  @override
  String hubPlayers(int count) {
    return '$count hráčů';
  }

  @override
  String get hubAvgRating => 'Prům. hodnocení';

  @override
  String get hubMorale => 'Morálka';

  @override
  String get hubManageTeam => 'Spravovat tým';

  @override
  String get hubGroupsToBeDrawn =>
      'Skupiny budou vylosovány — sledujte losování a odhalte je.';

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
  String get careerNoSilverware =>
      'Zatím žádné trofeje — běžte nějakou získat.';

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
  String get careerProUpTo5 => 'Pro: až 10';

  @override
  String get careerThisSave => 'toto uložení';

  @override
  String get careerSlotsFull => 'Pozice plné';

  @override
  String get careerSlotsFullGoPro => 'Pozice plné — pořiďte si Pro pro 10';

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
    return 'Odehráno $minutes min';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return 'Odehráno $hours h $minutes min';
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
    return 'před $n dny';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Cesta na MS $year';
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
  String get careerBestWin => 'Nejlepší výhra';

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
    return '$apps startů';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms× MVP';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent => 'Kapitán — klepnutím pásku sejmete';

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
  String get resultsCategoryWorldCupFinals => 'Mistrovství světa';

  @override
  String get resultsRoundResults => 'VÝSLEDKY KOLA';

  @override
  String get resultsFriendlyInternationals => 'PŘÁTELSKÉ REPREZENTAČNÍ ZÁPASY';

  @override
  String get resultsKnockout => 'Vyřazovací fáze';

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
    return 'Vyhrajte $count velkých trofejí (mistrovství světa, kontinentální nebo Pohár národů).';
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
    return 'Veďte $count různých reprezentací.';
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
  String get achQualWcDesc => 'Postupte na závěrečný turnaj mistrovství světa.';

  @override
  String get achQualCont => 'Účast na kontinentálním šampionátu';

  @override
  String get achQualContDesc =>
      'Postupte na závěrečný turnaj svého kontinentálního šampionátu.';

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
  String get paywallGoPro => 'PŘEJÍT NA PRO';

  @override
  String get paywallOneTimeUnlock => 'Jednorázové odemčení. Žádné předplatné.';

  @override
  String get paywallBenefitEveryNation => 'Spravujte každou zemi na světě';

  @override
  String get paywallBenefitSaveSlots => '10 pozic pro uložení místo 3';

  @override
  String get paywallBenefitEndless => 'Neomezené kariéry, navždy';

  @override
  String get paywallUnlocked => 'Prémiová verze je odemčená — užijte si ji!';

  @override
  String get paywallContactingStore => 'Kontaktuji obchod…';

  @override
  String get paywallUnlockPro => 'Odemknout Pro';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Odemknout Pro · $price';
  }

  @override
  String get paywallRestorePurchases => 'Obnovit nákupy';

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
      'Zatím není dost historie — vraťte se po jednom či dvou cyklech.';

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
  String get nationsNationalLevel => 'REPREZENTAČNÍ ÚROVEŇ';

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
  String get nationsNavCareer => 'Kariéra';

  @override
  String get nationsNavTactics => 'Taktika';

  @override
  String get nationsNavNations => 'Reprezentace';

  @override
  String get nationsNavSettings => 'Nastavení';

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
  String yWinUpset0(String opponent, String score) {
    return 'Sleduju fotbal třicet let a tohle jsem nečekal. $opponent poražen $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Nikdo jim proti $opponent nedával šanci. $score.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score proti $opponent. Vzbuďte sousedy.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Na takový večer se vzpomíná celý život. $opponent $score.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$score proti $opponent. Splněná povinnost, nic víc.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return 'Porazili jsme $opponent $score. Přesně jak se čekalo.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return 'Profesionální $score nad $opponent. Dál.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return '$opponent odbyt $score. Zapsat a jít dál.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score proti $opponent a každá minuta oddřená.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Nervy, ošklivé a vítězné. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Porazili jsme $opponent $score. Body ber a záznam nikdy nepouštěj.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score. $opponent nás nechal dřít o každý centimetr.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return '$score s $opponent. Ztracené dva body, nebo získaný jeden — vyber si.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return 'Remíza s $opponent, $score. Nikdo není šťastný ani vzteklý.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent $score. Nejzapomenutelnějších devadesát minut roku.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return 'Dělili jsme se s $opponent, $score. Jedeme dál.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Prohra $score s $opponent. Stává se.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Byli jsme druzí a není o čem.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Prohráli jsme $score s $opponent. Přeskupit se.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score s $opponent. Ne ostuda, ale málo.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score. S $opponent. Nemám slov a jsem placený za slova.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'To nebyla prohra s $opponent, to byla kapitulace. $score.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Někdo se za to bude zodpovídat.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Chci $score proti $opponent vyškrtnout ze zápisu i z paměti.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'MISTŘI. $opponent. Řekni to nahlas.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Vyhráli jsme to. $opponent. Nejsem v pořádku.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent — a pohár jede domů.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Každý z nich legenda. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Tak blízko. $opponent a medaile, kterou nikdo nechce.';
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
    return 'Druhé místo. Na $opponent. Podejte někdo láhev.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Konec na $opponent. Stejný scénář, jiný rok.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent je místo, kde to končí. Zase.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Vyřazeni na $opponent. A teď vyšetřování.';
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
    return 'Postup na $opponent. Zařiďte si dovolenou.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, přicházíme. Nikdy jsme nepochybovali (pochybovali jsme pořád).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Jsme na $opponent. To těžké je za námi.';
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
    return 'Skupiny na $opponent jsou venku a ta naše se mi nelíbí.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Los na $opponent hotov. Ať začne přehánění.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Pořádá $opponent. Začněte šetřit.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Jede se do $opponent. Předvídatelné, ale dobře.';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'Turnaj bere $opponent. Gratuluji jim, asi.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Pořadatel potvrzen: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent začíná brzy a já neposedím.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Už to nebude dlouho trvat do $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent se blíží. Nominaci, prosím.';
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
  String get yEmpty => 'Zatím není o čem. Odehraj zápas.';

  @override
  String hubEventGrievance(String player) {
    return '$player si chce promluvit';
  }

  @override
  String get hubEventGrievanceSub => 'Chce vědět, na čem je';

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
  String yScorerStar0(String name, String goals) {
    return '$name z toho dal $goals. Nikdo jiný se nepřibližuje.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals pro hráče $name. Táhne celý tým.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals za zápas. To je fotbalista.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$goals jim nasázel $name. Klobouk dolů.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count v řadě. Ať se v kabině říká cokoli, funguje to.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Je to $count za sebou. Do takové série se tým nepotká náhodou.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count výher v řadě a pokračuje se. Sebevědomí je vidět až na tribunu.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Ani jedna prohra v $count zápasech. Zeptejte se kohokoli, kdo trénoval — tohle je to těžké.';
  }

  @override
  String yLossStreak0(String count) {
    return 'Už $count zápasů bez výhry. Výmluvy jednou dojdou.';
  }

  @override
  String yLossStreak1(String count) {
    return 'To je $count proher v řadě. Tohle už není výkyv.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count porážek za sebou. Někdo se z toho bude zpovídat.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Žádná výhra v $count zápasech. Je to na nich vidět.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Říkejte si o tom fotbale co chcete — tenhle počítá dvakrát.';
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
  String yInjuryBlow0(String name) {
    return '$name odstoupil zraněný. To bylo poslední, co tenhle tým potřeboval.';
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
  String get yBoardPressure0 =>
      'Vedení podezřele ztichlo. To nikdy nevěstí nic dobrého.';

  @override
  String get yBoardPressure1 => 'Prý se v kancelářích začalo ptát.';

  @override
  String get yBoardPressure2 => 'Je cítit, že se nahoře něco hýbe.';

  @override
  String get yBoardPressure3 =>
      'Nikdo ve svazu neřekne jediné podporující slovo. Vyvoďte si z toho své.';

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
  String get playerAttrPhysical => 'Fyzično';

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
    return '$name – ŠAMPIONI';
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
      'Prošli jste baráží — jedete na mistrovství světa!';

  @override
  String get tourContPlayoffOut =>
      'V baráži jste nestačili — mistrovství světa tentokrát nebude.';

  @override
  String get tourContContinue => 'Pokračovat';

  @override
  String get tourContPlayoffFinals => 'FINÁLE BARÁŽE';

  @override
  String get tourContPlayoffSeeded => 'Nasazen — volný los';

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
  String get tourCupActive => 'AKTIVNÍ';

  @override
  String get tourCupStillActive => 'Stále aktivní';

  @override
  String get tourCupAllTimeScorers => 'NEJLEPŠÍ STŘELCI HISTORIE';

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
  String get tourCupDestFinals => 'finálový turnaj';

  @override
  String get tourCupDestFinalsPlayoff => 'finálovou baráž';

  @override
  String get tourCupDestIntercontPlayoff => 'mezikontinentální baráž';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Finálový turnaj se losuje po skončení kvalifikace.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Skupiny budou vylosovány — sledujte los MS z rozcestníku.';

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
    return '$nation — $titles titulů z $editions ročníků';
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
  String get tourCupQualDrawSoon =>
      'Skupiny budou vylosovány — sledujte los kvalifikace z rozcestníku.';

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
  String get traitSetPieceBlurb => 'Lepší centry — více gólů ze standardek.';

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
  String get traitPaceyBlurb => 'Extrémní rychlost — hrozba za obranou.';

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
  String get finishDidNotQualify => 'Nepostoupili';

  @override
  String get objectiveAvoidBottom => 'Neskončit v kvalifikaci poslední';

  @override
  String get finishBottomOfQualifyingGroup => 'Poslední v kvalifikační skupině';

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
  String get boardObjectivesTitle => 'Cíle vedení';

  @override
  String get boardObjectivesConfidence => 'Důvěra vedení';

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
  String squadDevPageOf(String page, String pages, String total) {
    return 'Strana $page z $pages · $total hráčů';
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
      'Nová generace, nejlepší talenty nahoře. Prázdné hvězdy jsou odhad skauta — teprve start v reprezentaci ukáže pravdu.';

  @override
  String get u21Empty =>
      'V kádru teď není nikdo do 21 let. Další ročník přijde s novým cyklem.';

  @override
  String u21Breakout(int gain) {
    return '+$gain ZA ROK';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Věk $age · $caps startů';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Věk $age · bez startu';
  }

  @override
  String get u21CallUps => 'Na nominaci';

  @override
  String get tacticsYouth => 'Do 21 let';

  @override
  String get pressTitle => 'Tisková konference';

  @override
  String get pressCardTitle => 'Čekají novináři';

  @override
  String get pressCardSub =>
      'Jedna otázka. Co řeknete, pocítí kabina i vedení.';

  @override
  String get pressTheOpposition => 'soupeř';

  @override
  String get pressSquad => 'Kabina';

  @override
  String get pressBoard => 'Vedení';

  @override
  String get pressNoEffect => 'Nikdo v tom nic nehledá';

  @override
  String pressAskHeavyDefeat(String opponent) {
    return 'Se soupeřem $opponent to byl výprask. Co se stalo?';
  }

  @override
  String pressAskElimination(String opponent) {
    return 'Porážka se soupeřem $opponent a konec turnaje. Jak to vysvětlíte?';
  }

  @override
  String get pressAskUnderPressure =>
      'Tři zápasy bez výhry a vedení se dívá. Jste pořád ten pravý?';

  @override
  String get pressAskPreview => 'Turnaj začíná. Jak daleko tenhle tým dojde?';

  @override
  String get pressAskTriumph => 'Mistři. Kam to řadíte a co bude dál?';

  @override
  String get pressAnswerBackPlayers =>
      'Tihle hráči mi dali všechno. Nevyměnil bych ani jednoho.';

  @override
  String get pressAnswerTakeBlame =>
      'Tohle jde za mnou. Sestavu jsem vybral já.';

  @override
  String get pressAnswerDemandMore =>
      'Málo. Někteří se musí podívat do zrcadla.';

  @override
  String get pressAnswerRaiseBar =>
      'Jsme tu pro vítězství. Cokoli jiného je selhání.';

  @override
  String get pressAnswerPlayDown =>
      'Jdeme zápas od zápasu. Víc k tomu neřeknu.';

  @override
  String get matchNeutralGround => 'NEUTRÁLNÍ';

  @override
  String get matchExtraTimeAhead => 'PRODLOUŽENÍ';

  @override
  String get matchExtraTimeHalf => 'PRODLOUŽENÍ · POLOČAS';

  @override
  String get hubEventPressConference => 'Předstoupit před novínáře';

  @override
  String get hubEventPressConferenceSub =>
      'Světová média chtějí slovo před prvním zápasem';

  @override
  String pressAskOpening(String opponent) {
    return 'Turnaj je zahájen a začínáte proti $opponent. Co vzkazujete zemi?';
  }

  @override
  String get squadDevWonderkid => 'TALENT';

  @override
  String get tacticsPlaystyle => 'Herní styl';

  @override
  String get tacticsPlaystyleBlurb =>
      'Vyberte, jak tým hraje; posuvníky níže styl doladí.';

  @override
  String get tacticsPlaystyleCustom =>
      'Vlastní nastavení — žádný pojmenovaný styl neodpovídá.';

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
      'Nemáte práci ani jméno. Tohle jsou jediní, kdo do vás půjde — vezměte jednu z nabídek a vybudujte něco z ničeho.';

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
      'Kde tým během turnaje bydlí. Každá základna vyměňuje jednu výhodu za druhou.';

  @override
  String get campEffectTravel => 'Cestování';

  @override
  String get campEffectRecovery => 'Regenerace';

  @override
  String get campEffectSharpness => 'Forma';

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
      'Vše po ruce a nikam se necestuje — ale žádný klid a žádný únik před ruchem.';

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
  String get squadSearchHint => 'Hledat podle jména nebo klubu';

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
    return '$name · $caps startů';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals gólů';
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
  String pressAskHeavyDefeat2(String opponent) {
    return 'Čtyři inkasované se soupeřem $opponent. Kde vás takový večer nechává?';
  }

  @override
  String pressAskHeavyDefeat3(String opponent) {
    return '$opponent vás rozebral. Je tenhle tým dost dobrý?';
  }

  @override
  String pressAskElimination2(String opponent) {
    return '$opponent to ukončil. Čtyři roky práce pryč za devadesát minut — vysvětlete nám to.';
  }

  @override
  String pressAskElimination3(String opponent) {
    return 'Konec se soupeřem $opponent. Bylo tohle maximum tohohle týmu?';
  }

  @override
  String get pressAskUnderPressure2 =>
      'Výsledky nejsou a vaše jméno je ve všech sloupcích. Máte obavy?';

  @override
  String get pressAskUnderPressure3 =>
      'Žádné výhry, žádné góly, žádné odpovědi. Co vzkážete fanouškům?';

  @override
  String get pressAskPreview2 => 'Všichni chtějí tip. Dejte nám ten svůj.';

  @override
  String get pressAskPreview3 =>
      'Realisticky — skupina, čtvrtfinále, nebo víc?';

  @override
  String pressAskOpening2(String opponent) {
    return 'Sleduje vás celá země a prvním soupeřem je $opponent. Co vzkazujete?';
  }

  @override
  String pressAskOpening3(String opponent) {
    return 'Začíná se proti $opponent. Jak si přejete, aby si tenhle tým zapamatovali?';
  }

  @override
  String get pressAskTriumph2 => 'Máte to. Je to konec něčeho, nebo začátek?';

  @override
  String get pressAskTriumph3 => 'Konečně mistři. Komu tenhle titul patří?';

  @override
  String pressAskBigWin(String opponent) {
    return 'O tři čisté se soupeřem $opponent. Začíná to tomuhle týmu konečně sedat?';
  }

  @override
  String pressAskBigWin2(String opponent) {
    return 'Rozebrali jste $opponent. Jak dobré to bylo?';
  }

  @override
  String pressAskBigWin3(String opponent) {
    return 'Výsledek jako vzkaz soupeřům, $opponent to odnesl. Mají se ostatní bát?';
  }

  @override
  String get pressAskQualified =>
      'Jste tam. Co postup pro tuhle partu znamená?';

  @override
  String get pressAskQualified2 =>
      'Místo je zajištěné. Hotovo, nebo práce teprve začíná?';

  @override
  String get pressAskQualified3 =>
      'Postup je doma — na co tenhle tým doopravdy má?';

  @override
  String get pressAskMissedOut => 'Tentokrát bez turnaje. Jak k tomu došlo?';

  @override
  String get pressAskMissedOut3 =>
      'Budete se dívat v televizi. Co řeknete zemi, která čekala víc?';

  @override
  String get pressAskMissedOut2 =>
      'Kvalifikace skončila a vy u toho nejste. Kdo za to nese odpovědnost?';

  @override
  String get pressAskUnbeaten =>
      'Měsíce bez porážky. Jak dlouho to může vydržet?';

  @override
  String get pressAskUnbeaten2 =>
      'Celou sezonu na vás nikdo nevyzrál. Čím to je?';

  @override
  String get pressAskUnbeaten3 =>
      'Série pokračuje. Je tohle nejlepší tým, jaký jste měl?';

  @override
  String get pressAskNewJob => 'První den. Co téhle zemi slibujete?';

  @override
  String get pressAskNewJob2 =>
      'Nová práce, nový kádr. Co se změní jako první?';

  @override
  String get pressAskNewJob3 => 'Vzal jste to. Proč zrovna tady a proč teď?';

  @override
  String get pressAskRankingPeak =>
      'Rekordní postavení v žebříčku. Nelichotí tabulka tomuhle týmu?';

  @override
  String get pressAskRankingPeak2 =>
      'Nikdy jste nebyli výš. Patří tenhle tým opravdu ke špičce?';

  @override
  String get pressAskRankingPeak3 =>
      'Na papíře nejvýš. Máte tím pádem terč na zádech?';

  @override
  String get pressAnswerBackPlayers2 =>
      'Nikdo nemaká víc než tahle parta. Budu je bránit pořád.';

  @override
  String get pressAnswerBackPlayers3 =>
      'Ode mě na svoje hráče křivé slovo neuslyšíte.';

  @override
  String get pressAnswerTakeBlame2 =>
      'Suďte mě, ne je. Je to můj tým a moje zodpovědnost.';

  @override
  String get pressAnswerTakeBlame3 => 'Jestli hledáte viníka, sedí přímo tady.';

  @override
  String get pressAnswerDemandMore2 =>
      'Laťka klesla. Někteří přesně vědí, koho myslím.';

  @override
  String get pressAnswerDemandMore3 =>
      'Na téhle úrovni nestačí snaha. Chci víc a řekl jsem jim to.';

  @override
  String get pressAnswerRaiseBar2 =>
      'Nebudu to obcházet — čekáme, že zvedneme trofej.';

  @override
  String get pressAnswerRaiseBar3 =>
      'Druhé místo není to, kvůli čemu nás sem tahle země poslala.';

  @override
  String get pressAnswerPlayDown2 => 'Titulek vám dneska nedám.';

  @override
  String get pressAnswerPlayDown3 => 'Další zápas. Na nic jiného nemyslím.';

  @override
  String get recordsRecordBookSubtitle => 'Starty, góly a klubové rekordy týmu';

  @override
  String get statsLegacy => 'ODKAZ';

  @override
  String pressAskHeavyDefeat4(String opponent) {
    return 'Bolelo to sledovat. Chtěl $opponent prostě víc?';
  }

  @override
  String pressAskHeavyDefeat5(String opponent) {
    return 'Se soupeřem $opponent jste byli všude druzí. Kondice, nebo přístup?';
  }

  @override
  String pressAskHeavyDefeat6(String opponent) {
    return '$opponent dával, kdy chtěl. Kdo nese odpovědnost za tu obranu?';
  }

  @override
  String pressAskHeavyDefeat7(String opponent) {
    return 'Takový výsledek se soupeřem $opponent se za trenérem táhne. Jak se z toho vrací?';
  }

  @override
  String pressAskHeavyDefeat8(String opponent) {
    return 'Po zápase se soupeřem $opponent vás vypískali. Divíte se jim?';
  }

  @override
  String pressAskElimination4(String opponent) {
    return '$opponent vás vyřadil. Kdy jste věděl, že je to pryč?';
  }

  @override
  String pressAskElimination5(String opponent) {
    return 'Další turnaj, další brzký let domů — a postaral se o to $opponent. Proč?';
  }

  @override
  String pressAskElimination6(String opponent) {
    return 'Konec se soupeřem $opponent. Chybí týmu kvalita, nebo nervy?';
  }

  @override
  String pressAskElimination7(String opponent) {
    return '$opponent jde dál, vy ne. Co se říká v takové kabině?';
  }

  @override
  String pressAskElimination8(String opponent) {
    return 'Porážka se soupeřem $opponent ve chvíli, kdy šlo o všechno. Definuje to vaše působení?';
  }

  @override
  String get pressAskUnderPressure4 =>
      'Sázkaři vás vidí jako prvního na odchod. Dostane se to k vám?';

  @override
  String get pressAskUnderPressure5 =>
      'Váš předchůdce po podobné sérii skončil. Čím jste jiný?';

  @override
  String get pressAskUnderPressure6 =>
      'Vedení veřejně mlčí. Je mlčení podpora?';

  @override
  String get pressAskUnderPressure7 =>
      'Každá debata volá po novém trenérovi. Ztratil jste zemi?';

  @override
  String get pressAskUnderPressure8 =>
      'Kolik zápasů si myslíte, že ještě máte?';

  @override
  String get pressAskPreview4 => 'Kdo je favorit a patříte do té debaty?';

  @override
  String get pressAskPreview5 =>
      'Mimo tuhle místnost vám nikdo nevěří. Vyhovuje vám to?';

  @override
  String get pressAskPreview6 =>
      'Co by z tohohle turnaje udělalo úspěch — upřímně?';

  @override
  String get pressAskPreview7 =>
      'Skupina vypadá schůdně. Je cokoli míň než postup selhání?';

  @override
  String get pressAskPreview8 =>
      'Je to nejmladší kádr, s jakým jste na turnaj jel. Risk, nebo plán?';

  @override
  String pressAskOpening4(String opponent) {
    return 'První zápas, $opponent, a nervózní jsou všichni. Jak se tým uklidňuje?';
  }

  @override
  String pressAskOpening5(String opponent) {
    return 'Čekal jste na tohle dva roky. Mění se plán, když před vámi stojí $opponent?';
  }

  @override
  String pressAskOpening6(String opponent) {
    return 'Na úvod $opponent. Výhra a celý turnaj vypadá jinak — říkáte jim to?';
  }

  @override
  String pressAskOpening7(String opponent) {
    return 'Země se kvůli tomu zastavila. Je $opponent dobrý, nebo špatný los?';
  }

  @override
  String pressAskOpening8(String opponent) {
    return 'Zahajovací večer proti $opponent. Co si nesmíte dovolit?';
  }

  @override
  String get pressAskTriumph4 => 'Napsal jste historii. Došlo vám to už?';

  @override
  String get pressAskTriumph5 =>
      'Trofej je v místnosti. Na koho jste pomyslel první?';

  @override
  String get pressAskTriumph6 =>
      'Na tenhle tým bude vzpomínat celá generace. Co si má pamatovat?';

  @override
  String get pressAskTriumph7 =>
      'V téhle místnosti vás odepsali. Užíváte si to?';

  @override
  String get pressAskTriumph8 =>
      'Je tohle vrchol, nebo může tenhle tým vyhrát víc?';

  @override
  String pressAskBigWin4(String opponent) {
    return '$opponent na to neměl odpověď. Plán, nebo hráči?';
  }

  @override
  String pressAskBigWin5(String opponent) {
    return 'Nejlepší výkon vaší éry — a proti soupeři $opponent?';
  }

  @override
  String pressAskBigWin6(String opponent) {
    return 'Se soupeřem $opponent to mohlo být vyšší. Chcete důslednost, nebo berete výhru?';
  }

  @override
  String pressAskBigWin7(String opponent) {
    return 'Takový výsledek se soupeřem $opponent zvedá očekávání. Je vám to příjemné?';
  }

  @override
  String pressAskBigWin8(String opponent) {
    return '$opponent se vás ani nedotkl. Je tenhle tým konečně takový, jaký jste chtěl?';
  }

  @override
  String get pressAskQualified4 => 'Splněno. Byly vůbec pochybnosti?';

  @override
  String get pressAskQualified5 =>
      'Jste tam. Říká vám kvalifikace, jak daleko můžete dojít?';

  @override
  String get pressAskQualified6 =>
      'Místo na turnaji — úleva, nebo zadostiučinění?';

  @override
  String get pressAskQualified7 =>
      'Postoupili jste s předstihem. K čemu jsou ty zbývající zápasy?';

  @override
  String get pressAskQualified8 =>
      'Teď přijde to těžší. Je tenhle kádr na turnaj připravený?';

  @override
  String get pressAskMissedOut4 =>
      'Tentokrát bez turnaje. Problém kádru, nebo trenéra?';

  @override
  String get pressAskMissedOut5 =>
      'Dva roky práce a nic. Věříte téhle partě pořád?';

  @override
  String get pressAskMissedOut6 =>
      'Země svůj tým na turnaji neuvidí. Co jí dlužíte?';

  @override
  String get pressAskMissedOut7 => 'Byl jeden večer, který to stál?';

  @override
  String get pressAskMissedOut8 =>
      'Čekáte, že tuhle práci budete mít i příští sezonu?';

  @override
  String get pressAskUnbeaten4 =>
      'Rok vás nikdo neporazil. Myslíte na rekordy?';

  @override
  String get pressAskUnbeaten5 => 'Ta série je teď hlavní téma. Je už přítěží?';

  @override
  String get pressAskUnbeaten6 =>
      'Soupeři se staví tak, aby s vámi neprohráli. Je to těžší?';

  @override
  String get pressAskUnbeaten7 =>
      'Až to skončí — a skončí — jak byste chtěl, aby to skončilo?';

  @override
  String get pressAskUnbeaten8 =>
      'Neporaženi, ale kolik z toho bylo přesvědčivých?';

  @override
  String get pressAskNewJob4 => 'Přebíráte kádr v přestavbě. Kde začnete?';

  @override
  String get pressAskNewJob5 => 'Jak bude tenhle tým vypadat za dva roky?';

  @override
  String get pressAskNewJob6 => 'Kvůli téhle nabídce jste jiné odmítl. Proč?';

  @override
  String get pressAskNewJob7 =>
      'Některé hráče jste nevybíral vy. Začíná někdo s čistým štítem?';

  @override
  String get pressAskNewJob8 => 'Co tahle země dělá špatně?';

  @override
  String get pressAskRankingPeak4 =>
      'Na papíře nejvýš. Znamená pro vás žebříček něco?';

  @override
  String get pressAskRankingPeak5 =>
      'Nejvýš v historii téhle země. Čí je to zásluha?';

  @override
  String get pressAskRankingPeak6 =>
      'Jste nad týmy s mnohem větší historií. Spravedlivé?';

  @override
  String get pressAskRankingPeak7 =>
      'Čísla říkají, že patříte ke špičce. Říkají to i trofeje?';

  @override
  String get pressAskRankingPeak8 =>
      'Rekordní postavení a zatím žádná trofej. Nesedí vám to?';

  @override
  String get pressAnswerBackPlayers4 =>
      'Otázky vezmu já. Zásluhy oni — tak se to tady dělá.';

  @override
  String get pressAnswerBackPlayers5 =>
      'Tahle parta mě nikdy nezklamala. Ani jednou.';

  @override
  String get pressAnswerBackPlayers6 =>
      'Bolí je to víc než kohokoli jiného. Nebudu přisazovat.';

  @override
  String get pressAnswerTakeBlame4 =>
      'Je to na realizačním týmu a na mně. Na nikom jiném.';

  @override
  String get pressAnswerTakeBlame5 =>
      'Já to vybral, já to postavil, já to zkazil.';

  @override
  String get pressAnswerTakeBlame6 => 'Ukazujte na mě. Za to jsem placený.';

  @override
  String get pressAnswerDemandMore4 =>
      'Někteří jsou hodně daleko od toho, co tenhle dres vyžaduje.';

  @override
  String get pressAnswerDemandMore5 =>
      'Řekl jsem jim to v kabině a řeknu to i tady: nestačí to.';

  @override
  String get pressAnswerDemandMore6 =>
      'Místa jsou otevřená. V kabině to vědí všichni.';

  @override
  String get pressAnswerRaiseBar4 =>
      'Přijeli jsme vyhrát. Nebudu předstírat opak.';

  @override
  String get pressAnswerRaiseBar5 =>
      'Cokoli jiného než trofej a bude to promarněné.';

  @override
  String get pressAnswerRaiseBar6 =>
      'Radši ať mě soudí za vítězství, než chválí za snahu.';

  @override
  String get pressAnswerPlayDown4 => 'Svoje myšlenky si nechám do kabiny.';

  @override
  String get pressAnswerPlayDown5 =>
      'Zápas jste viděli. Váš názor je stejně dobrý jako můj.';

  @override
  String get pressAnswerPlayDown6 => 'Nic, co dneska řeknu, výsledek nezmění.';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name už byl vystřídán – zpátky na hřiště nemůže.';
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
  String get compWorldCupFinals => 'Finálový turnaj MS';

  @override
  String get compWorldCupQualifying => 'Kvalifikace MS';

  @override
  String compQualifiers(String region) {
    return 'Kvalifikace – $region';
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
  String get compEuropeanChampionship => 'Mistrovství Evropy';

  @override
  String get compSouthAmericaCup => 'Pohár Jižní Ameriky';

  @override
  String get compAfricanChampionship => 'Mistrovství Afriky';

  @override
  String get compAsianChampionship => 'Mistrovství Asie';

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
    return '$comp – JSME MISTŘI!';
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
    return '$name ($nation) je světovým hráčem roku $year – a je váš.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) je světovým hráčem roku $year.';
  }

  @override
  String get msgYpotTitle => 'Nejlepší mladý hráč turnaje';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age let, je nejlepším mladým hráčem turnaje $year – a je váš.';
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
    return 'Postup o $_temp0 v tomto cyklu, na #$rank.';
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
    return 'Pád o $_temp0 v tomto cyklu, na #$rank.';
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
  String msgCapsTitle(String name, int count) {
    return '$name má $count startů';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name nastoupil za váš tým už ${count}krát.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name má $count gólů';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name vstřelil za váš tým $count reprezentačních gólů.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Vývoj kádru · $year';
  }

  @override
  String msgNewFacesTitle(int year) {
    return 'Nové tváře · $year';
  }

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
      ' Kapitánská páska je volná – nového kapitána jmenujte na obrazovce nominace.';

  @override
  String msgHofTitle(String name) {
    return '$name uveden do Síně slávy';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name vstupuje do Síně slávy vašeho týmu ($caps startů, $goals gólů). Najdete ho mezi Legendami.';
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
    return '$name $how a má stop na $_temp0 – nebude k dispozici.';
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
    return 'Došli jste ve finále turnaje $cup, ale $opponent bylo lepší. Tak blízko – tentokrát stříbro.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Ve finále turnaje $cup vás porazilo $opponent. Stříbro – k zbláznění blízko.';
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
    return 'Cíl splněn — $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Cíl nesplněn — $comp';
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
    return 'Na mistrovství světa $year jedete jen jako diváci – kvalifikace nevyšla. Další čtyři roky.';
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
  String get newsTransferFree => 'volný přestup';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ $name by přestoupil do reprezentace $nation!';
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
    return 'Na turnaj $cup jste nepostoupili – kvalifikace tentokrát nevyšla.';
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
  String get matchTopBarTitle => 'ZÁPAS';

  @override
  String get matchStatsAtFullTime =>
      'Statistiky budou k dispozici po konci zápasu.';

  @override
  String get matchPlayerRatings => 'ZNÁMKY HRÁČŮ';

  @override
  String get matchSubstitutions => 'STŘÍDÁNÍ';

  @override
  String get matchSubstitutes => 'NÁHRADNÍCI';

  @override
  String get matchPlayerOfTheMatch => 'HRÁČ ZÁPASU';

  @override
  String get matchGoalShout => 'GÓL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'PENALTY $home:$away';
  }

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
    return '$name ukončil reprezentační kariéru ve $age letech s $caps starty. Chtěl vědět, na čem je, odpovědi se nedočkal – a déle už nečekal.';
  }

  @override
  String get pressProbeAccountability1 =>
      'Znovu se zastáváte hráčů. Nenese v té kabině nikdo odpovědnost?';

  @override
  String get pressProbeAccountability2 =>
      'Hráče jste obhájil. Kdo se tedy za takový večer zodpovídá?';

  @override
  String get pressProbeAccountability3 =>
      'Loajalita se hlásá snadno. Ponese to někdo?';

  @override
  String get pressProbeAccountability4 =>
      'Když to nikdy nejsou hráči, zbývá jediné jméno. To vaše.';

  @override
  String get pressProbeYourFuture1 =>
      'Berete to na sebe. Máme se ptát na vaši budoucnost?';

  @override
  String get pressProbeYourFuture2 =>
      'Padnout na meč je ušlechtilé. Je to místo pořád vaše?';

  @override
  String get pressProbeYourFuture3 =>
      'Pořád opakujete, že je to na vás. Odkdy je to rezignace?';

  @override
  String get pressProbeYourFuture4 =>
      'Poslouchá i vedení. Určitě to chcete mít v záznamu?';

  @override
  String get pressProbeDressingRoom1 =>
      'Ostrá slova na veřejnosti. Neztratil jste kabinu?';

  @override
  String get pressProbeDressingRoom2 =>
      'Právě jste zemi řekl, že na to nemají. Jak jim to pomůže?';

  @override
  String get pressProbeDressingRoom3 =>
      'Žádat to tady místo v kabině – je tohle vedení mužstva?';

  @override
  String get pressProbeDressingRoom4 =>
      'Hráči to čtou taky. Co uslyší zítra ráno?';

  @override
  String get pressProbeExpectation1 =>
      'Nahlas jste zvedl laťku. Není to sázka na štěstí?';

  @override
  String get pressProbeExpectation2 =>
      'Velký slib. Co se stane v den, kdy ho nesplníte?';

  @override
  String get pressProbeExpectation3 =>
      'Každý trenér před vámi říkal totéž a pak si sbalil. Proč jste jiný?';

  @override
  String get pressProbeExpectation4 =>
      'Cíl jste si stanovil sám. Odejdete, když ho nesplníte?';

  @override
  String get pressProbeSubstance1 =>
      'S dovolením, tohle není odpověď. Řekněte nám něco.';

  @override
  String get pressProbeSubstance2 => 'Země chce slyšet vás. Aspoň něco?';

  @override
  String get pressProbeSubstance3 =>
      'Můžete dál mlčet. My to budeme dál otiskovat.';

  @override
  String get pressProbeSubstance4 =>
      'Jednu jasnou větu. Co si o tom doopravdy myslíte?';

  @override
  String get pressProbeSelection1 =>
      'Stejná jména, stejné rozestavení, stejný výsledek. Proč pořád nasazujete tuhle sestavu?';

  @override
  String get pressProbeSelection2 =>
      'Hráči ve formě to sledují v televizi. Vysvětlete tu nominaci.';

  @override
  String get pressProbeSelection3 =>
      'Vybíráte jedenáctku podle formy, nebo podle jména?';

  @override
  String get pressProbeSelection4 =>
      'Takticky jsme ten problém viděli všichni. Vy taky?';

  @override
  String get pressProbeTheFans1 =>
      'Tisíce lidí kvůli tomu cestovaly. Co jim dnes večer řeknete?';

  @override
  String get pressProbeTheFans2 =>
      'Fanoušci u tohohle týmu vydrželi roky. Co jim dáváte vy?';

  @override
  String get pressProbeTheFans3 =>
      'Buď vaše jméno skandují, nebo ne. Jak to bude?';

  @override
  String get pressProbeTheFans4 => 'Vzkaz pro lidi doma. Prosím.';

  @override
  String get pressProbeBigPicture1 =>
      'Zkusme odstup. Kam tahle reprezentace vlastně směřuje?';

  @override
  String get pressProbeBigPicture2 =>
      'Zvenčí se tu roky nic nezměnilo. Nebo ano?';

  @override
  String get pressProbeBigPicture3 =>
      'Jak bude tenhle tým vypadat za čtyři roky?';

  @override
  String get pressProbeBigPicture4 => 'Je tohle projekt, nebo jen další zápas?';

  @override
  String get pressNeedleBackPlayers =>
      'Vždycky se jich zastáváte. Slyšeli jsme to už mockrát.';

  @override
  String get pressNeedleTakeBlame => 'Podle vás je to prý vždycky vaše chyba.';

  @override
  String get pressNeedleDemandMore => 'Zase další požadavky.';

  @override
  String get pressNeedleRaiseBar => 'Další slib do archivu.';

  @override
  String get pressNeedlePlayDown => 'Nikdy nám nic neřeknete.';

  @override
  String get pressHeadlineWent1 => 'Trenér, který má situaci pevně v rukou';

  @override
  String get pressHeadlineWent2 => 'Přišli si pro hádku, odešli s vůdcem';

  @override
  String get pressHeadlineWent3 => 'Jasné odpovědi – a sedly';

  @override
  String get pressHeadlineMixed1 => 'Řečeno hodně, vyřešeno málo';

  @override
  String get pressHeadlineMixed2 => 'Něco pro každého – a nic pro nikoho';

  @override
  String get pressHeadlineMixed3 =>
      'Tisková konference, po které otázky zůstaly';

  @override
  String get pressHeadlineBadly1 => 'Perná hodina před kamerami';

  @override
  String get pressHeadlineBadly2 =>
      'Sál se otočil proti němu – a bylo to vidět';

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
  String get yReactionRelief0 => 'tohle mě stálo deset let života';

  @override
  String get yReactionRelief1 => 'Ošklivé. Body doma. Jedeme dál.';

  @override
  String get yReactionRelief2 => 'Nikdo nic neříkejte. Ať to nezakřiknete.';

  @override
  String get yReactionRelief3 => 'Krása to nebyla, ale beru to vždycky.';

  @override
  String get yReactionRelief4 => 'Tep: nepřijatelný.';

  @override
  String get yReactionRelief5 => 'Nějak. Prostě nějak!';

  @override
  String get yReactionFury0 => 'Tohle je fakt bída.';

  @override
  String get yReactionFury1 => 'Málo. Ani zdaleka to nestačí.';

  @override
  String get yReactionFury2 => 'Chci jména.';

  @override
  String get yReactionFury3 => 'Každé čtyři roky to samé. KAŽDÉ čtyři roky.';

  @override
  String get yReactionFury4 => 'Mažu aplikaci. Ve čtvrtek ji stáhnu zpátky.';

  @override
  String get yReactionFury5 => 'Ať mi to někdo vysvětlí. Pomalu.';

  @override
  String get yReactionDespair0 => 'tak.';

  @override
  String get yReactionDespair1 => 'Došla mi slova.';

  @override
  String get yReactionDespair2 => 'Jdu se projít. Na dlouho.';

  @override
  String get yReactionDespair3 => 'tohle je ta nejhorší verze reality';

  @override
  String get yReactionDespair4 => 'Vzbuďte mě za čtyři roky.';

  @override
  String get yReactionDespair5 => 'Dneska bez vtipů. Vůbec nic.';

  @override
  String get yReactionSmugness0 => 'Říkal jsem to v lednu. Zkontrolujte si to.';

  @override
  String get yReactionSmugness1 => 'Někteří z vás nám dluží omluvu.';

  @override
  String get yReactionSmugness2 => 'Potichu, ale: říkal jsem to.';

  @override
  String get yReactionSmugness3 => 'Pochybovači nějak ztichli.';

  @override
  String get yReactionSmugness4 => 'tohle si uložte';

  @override
  String get yReactionSmugness5 => 'Ne že by to někdo počítal. Já to počítám.';

  @override
  String get yReactionShrug0 => 'stalo se. jedeme dál.';

  @override
  String get yReactionShrug1 => 'Dobře. Nevadí. Dál.';

  @override
  String get yReactionShrug2 => 'Zařazuju do složky „fotbal“.';

  @override
  String get yReactionShrug3 => 'žádné myšlenky, prázdno';

  @override
  String get yReactionShrug4 => 'Vzbuďte mě na další.';

  @override
  String get yReactionShrug5 => 'Vážně nemám co dodat.';

  @override
  String get tourThirdsUneven =>
      'Skupiny nejsou stejně velké – výsledky proti poslednímu týmu větších skupin se nezapočítávají, aby se všechny týmy hodnotily podle stejného počtu zápasů.';

  @override
  String get gateTitle => 'PRVNÍ CYKLUS KONČÍ';

  @override
  String get gateLead =>
      'Čtyři roky, kontinentální šampionát a mistrovství světa – to byla část zdarma a nic v ní nechybělo. Za jednorázovou platbu pokračujte v této kariéře dál.';

  @override
  String get gateBenefitEndless => 'Neomezené kariéry – všechny další cykly';

  @override
  String get gateBenefitNations => 'Můžete vést kteroukoli reprezentaci světa';

  @override
  String get gateBenefitSaves => '10 pozic pro uložení místo 3';

  @override
  String get gateBenefitUpdates => 'Všechny budoucí aktualizace v ceně';

  @override
  String get gateBenefitOffline =>
      'Funguje offline – bez předplatného, reklam a účtu';

  @override
  String get gatePriceLead => 'Jedna platba, navždy';

  @override
  String get gatePrice => '11,99 €';

  @override
  String get gateBuy => 'KOUPIT A POKRAČOVAT';

  @override
  String get gateExit => 'ODEJÍT';

  @override
  String get gateNotChargedYet =>
      'Zatím není napojeno na platbu – tlačítko jen pokračuje dál.';

  @override
  String get backupTitle => 'ULOŽENÉ HRY';

  @override
  String get backupBlurb =>
      'Všechny uložené hry jsou v jednom souboru v tomto telefonu. Vytvořte si zálohu, aby vás ztráta nebo přeinstalace telefonu nestála kariéru.';

  @override
  String get backupExport => 'EXPORTOVAT ZÁLOHU';

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
  String get backupExported => 'Záloha je připravená – vyberte, kam ji uložit.';

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
  String get careerShareFailed => 'Kariéru se nepodařilo exportovat.';

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
  String get managerSkillManManagement => 'Vedení lidí';

  @override
  String get managerSkillManManagementBlurb =>
      'To, co řeknete na veřejnosti i ve své kanceláři, má větší dopad.';

  @override
  String get managerSkillTactical => 'Taktika';

  @override
  String get managerSkillTacticalBlurb =>
      'Váš tým si rychleji zvykne na nové rozestavení.';

  @override
  String get managerSkillYouth => 'Práce s mládeží';

  @override
  String get managerSkillYouthBlurb => 'Z akademie vzejde víc talentů.';

  @override
  String get managerSkillNegotiation => 'Vyjednávání';

  @override
  String get managerSkillNegotiationBlurb => 'Federace vás lépe financuje.';

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
      'Vede tréninky. Čemu se věnujete, toho udělá víc.';

  @override
  String get managerRoleScout => 'Hlavní skaut';

  @override
  String get managerRoleScoutBlurb =>
      'Dřív vám řekne, co z mladého hráče bude.';

  @override
  String get managerRoleFitness => 'Kondiční trenér';

  @override
  String get managerRoleFitnessBlurb => 'Udrží hráče na hřišti.';

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
}
