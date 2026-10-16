// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get matchPreviewTitle => 'ZAPOWIEDŹ MECZU';

  @override
  String get matchKickOff => 'Rozpocznij mecz';

  @override
  String get matchTactics => 'Taktyka';

  @override
  String get matchYourXi => 'TWOJA JEDENASTKA';

  @override
  String get matchHeadToHead => 'BILANS SPOTKAŃ';

  @override
  String matchCouldNotLoad(String error) {
    return 'Nie udało się wczytać meczu.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Brak nadchodzącego meczu.';

  @override
  String get matchUnknownNation => 'Nieznana';

  @override
  String get matchH2hFirstMeeting => 'Pierwsze spotkanie w historii';

  @override
  String get matchH2hYouLead => 'Bilans przemawia za tobą';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Bilans na korzyść: $opponent';
  }

  @override
  String get matchH2hEven => 'Bilans wyrównany';

  @override
  String matchH2hMet(int count) {
    return 'Spotkania: $count';
  }

  @override
  String get matchH2hWon => 'Wygrane';

  @override
  String get matchH2hDrawn => 'Remisy';

  @override
  String get matchH2hLost => 'Przegrane';

  @override
  String get matchDossierTitle => 'Raport skautów';

  @override
  String get matchDossierForm => 'FORMA';

  @override
  String get matchDossierNoGames => 'Brak ostatnich meczów';

  @override
  String get matchDossierKeyMen => 'KLUCZOWI ZAWODNICY';

  @override
  String matchCouldNotContinue(String error) {
    return 'Nie udało się kontynuować: $error';
  }

  @override
  String get matchSkipToFullTime => 'Przewiń do końca meczu';

  @override
  String get matchStatShots => 'Strzały';

  @override
  String get matchStatGoals => 'Gole';

  @override
  String get matchStatYellowCards => 'Żółte';

  @override
  String get matchStatRedCards => 'Czerwone';

  @override
  String get matchMomentum => 'PRZEWAGA';

  @override
  String get matchSwingAtk => 'ATK';

  @override
  String get matchSwingDef => 'OBR';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'MISTRZOSTWA ŚWIATA $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'CZAS NA TURNIEJ FINAŁOWY';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'GOSPODARZ:  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'GOSPODARZ DO USTALENIA';

  @override
  String get matchHalfTime => 'PRZERWA';

  @override
  String get matchContinue => 'Dalej';

  @override
  String get matchContinuing => 'Zapisywanie…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktyka · zmiany $used/$max';
  }

  @override
  String matchTiredCount(int count) {
    return 'ZMĘCZENI ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTYKA';

  @override
  String get teamOverallOverTime => 'OCENA OGÓLNA NA PRZESTRZENI LAT';

  @override
  String get teamOverall => 'Ogółem';

  @override
  String get teamTalkHeading => 'ODPRAWA';

  @override
  String get teamTalkPrompt => 'Nadaj ton drugiej połowie.';

  @override
  String get teamTalkCalmLabel => 'Spokojnie';

  @override
  String get teamTalkCalmBlurb =>
      'Uspokój zespół. Niewielki wzrost we wszystkim.';

  @override
  String get teamTalkEncourageLabel => 'Zachęć';

  @override
  String get teamTalkEncourageBlurb => 'Do przodu, grajcie o zwycięstwo.';

  @override
  String get teamTalkDemandMoreLabel => 'Wymagaj więcej';

  @override
  String get teamTalkDemandMoreBlurb => 'Wszystko na jedną kartę. Mocny atak.';

  @override
  String get teamTalkPraiseLabel => 'Zagęść szyki';

  @override
  String get teamTalkPraiseBlurb => 'Zostańcie zwarci i brońcie wyniku.';

  @override
  String get teamTalkBelieveLabel => 'Uwierzcie';

  @override
  String get teamTalkBelieveBlurb =>
      'Zaufajcie sobie. Wzrost w obronie i w ataku.';

  @override
  String get teamTalkFocusLabel => 'Pełna koncentracja';

  @override
  String get teamTalkFocusBlurb => 'Totalne skupienie. Zamknijcie mecz.';

  @override
  String get teamTalkUrgencyLabel => 'Nie ma czasu';

  @override
  String get teamTalkUrgencyBlurb =>
      'Gonimy wynik teraz. Wszystko do przodu, z lukami z tyłu.';

  @override
  String get teamTalkReassureLabel => 'Bez presji';

  @override
  String get teamTalkReassureBlurb => 'Uspokój nerwy i trzymaj ustawienie.';

  @override
  String get commonRetry => 'Ponów';

  @override
  String get commonSomethingWentWrong => 'Coś poszło nie tak';

  @override
  String get commonCrashBox =>
      'Coś tu poszło nie tak.\nSzczegóły w Ustawienia → Diagnostyka.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Nie udało się przesunąć świata: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostyka';

  @override
  String get settingsDiagnosticsBlurb =>
      'Błędy zapisane na tym urządzeniu. Nic nie jest nigdzie wysyłane.';

  @override
  String get settingsContactTitle => 'Kontakt';

  @override
  String get settingsContactCopied => 'Adres skopiowany.';

  @override
  String get diagnosticsEmpty => 'Brak zapisanych błędów. I o to chodzi.';

  @override
  String get diagnosticsCopy => 'Kopiuj';

  @override
  String get diagnosticsCopied => 'Log skopiowany do schowka.';

  @override
  String get diagnosticsClear => 'Wyczyść';

  @override
  String get navHub => 'Centrum';

  @override
  String get navSquad => 'Kadra';

  @override
  String get navStandings => 'Tabele';

  @override
  String get navCareers => 'Kariera';

  @override
  String get settingsTitle => 'USTAWIENIA';

  @override
  String get settingsSoundHapticsTitle => 'Dźwięk i wibracje';

  @override
  String get settingsSoundHapticsBlurb =>
      'Wibracja i krótki sygnał przy golach, rozpoczęciu i końcu meczu.';

  @override
  String get settingsLanguageTitle => 'Język';

  @override
  String get settingsLanguageBlurb =>
      'Wybierz język aplikacji albo używaj języka urządzenia.';

  @override
  String get settingsLanguageSystem => 'Systemowy';

  @override
  String get matchPreviewAllMeetings => 'Wszystkie spotkania';

  @override
  String get recordsMeetings => 'SPOTKANIA';

  @override
  String get recordsLegends => 'LEGENDY';

  @override
  String get recordsAllTimeXi => 'JEDENASTKA WSZECH CZASÓW';

  @override
  String get recordsHallOfFame => 'GALERIA SŁAWY';

  @override
  String get recordsAllTimeWorld => 'ŚWIAT WSZECH CZASÓW';

  @override
  String get recordsAllTimeTopScorers => 'NAJLEPSI STRZELCY W HISTORII';

  @override
  String get recordsMostCapped => 'NAJWIĘCEJ WYSTĘPÓW';

  @override
  String get recordsMostWcStarts => 'NAJWIĘCEJ MECZÓW NA MŚ';

  @override
  String get recordsMostTournaments => 'NAJWIĘCEJ TURNIEJÓW';

  @override
  String get recordsRecordBook => 'KSIĘGA REKORDÓW';

  @override
  String get recordsHeadToHead => 'BILANS SPOTKAŃ';

  @override
  String get recordsFiercestRival => 'NAJWIĘKSZY RYWAL';

  @override
  String get recordsMostCaps => 'NAJWIĘCEJ WYSTĘPÓW';

  @override
  String get recordsTopScorers => 'NAJLEPSI STRZELCY';

  @override
  String get recordsMostAssists => 'NAJWIĘCEJ ASYST';

  @override
  String get recordsYourRecord => 'TWÓJ BILANS';

  @override
  String get callUpHome => 'U SIEBIE';

  @override
  String get callUpAway => 'NA WYJEŹDZIE';

  @override
  String get recordsHome => 'GOSPODARZE';

  @override
  String get recordsAway => 'GOŚCIE';

  @override
  String get recordsActive => 'AKTYWNY';

  @override
  String get recordsStillActive => 'Wciąż gra';

  @override
  String get recordsAvg => 'śr.';

  @override
  String get recordsSelect => 'Wybierz';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Remisy';

  @override
  String get recordsGoalsLabel => 'Gole';

  @override
  String get recordsBestFinish => 'Najlepszy wynik';

  @override
  String get recordsNoFinalsYet => 'Jeszcze bez awansu do turnieju finałowego';

  @override
  String get recordsLongestUnbeaten => 'Najdłuższa seria bez porażki';

  @override
  String get recordsBiggestWin => 'Najwyższe zwycięstwo';

  @override
  String get recordsSeeAllMeetings => 'Zobacz wszystkie spotkania';

  @override
  String get recordsSaveNotFound => 'Nie znaleziono zapisu.';

  @override
  String get recordsNoMatches => 'Brak wyników.';

  @override
  String get recordsSearchPlayerOrNation => 'Szukaj zawodnika lub kraju';

  @override
  String get recordsSearchNation => 'Szukaj kraju';

  @override
  String get recordsPickTwoDifferent => 'Wybierz dwa różne kraje.';

  @override
  String get recordsPlayToBuildRecord =>
      'Rozegraj kilka meczów, a tutaj powstanie twój bilans z każdym rywalem.';

  @override
  String get recordsTapOpponent => 'Dotknij rywala, by zobaczyć szczegóły.';

  @override
  String get recordsEdgeUpperHand => 'Masz przewagę';

  @override
  String get recordsEdgeTheirNumber => 'Oni wiedzą, jak cię ograć';

  @override
  String get recordsEdgeEven => 'Bilans wyrównany';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Strzelcy i rekordziści występów, wszystkie kraje';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Porównaj historyczny bilans dowolnych dwóch krajów';

  @override
  String get recordsLegendsSubtitle =>
      'Jedenastka wszech czasów i galeria sławy';

  @override
  String get recordsUnitGoals => 'gole';

  @override
  String get recordsUnitCaps => 'wyst.';

  @override
  String get recordsUnitStarts => 'mecze';

  @override
  String get recordsUnitCups => 'turnieje';

  @override
  String get recordsUnitAssists => 'asysty';

  @override
  String recordsCapsCount(int count) {
    return 'Występy: $count';
  }

  @override
  String recordsGoalsCount(int count) {
    return 'Gole: $count';
  }

  @override
  String recordsAssistsCount(int count) {
    return 'Asysty: $count';
  }

  @override
  String recordsMotmCount(int count) {
    return 'MVP: $count';
  }

  @override
  String recordsMatchesCount(int count) {
    return 'Mecze: $count';
  }

  @override
  String recordsMeetingsCount(int count) {
    return 'Spotkania: $count';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Wygrane $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return 'Spotkania: $meetings · ${wins}Z ${draws}R ${losses}P';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}Z ${draws}R ${losses}P';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return 'Spotkania: $meetings · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a i $b: w tym zapisie brak wzajemnych spotkań.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Czerwona kartka: $names. Nie ma zmiennika, więc grasz w osłabieniu.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Potrzeba $required dostępnych (zdrowi: $have)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Opuści $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Wypada na całe zgrupowanie';

  @override
  String get rankingCentreOnMe => 'Pokaż mój kraj';

  @override
  String get recordsAfterExtraTime => 'po dogr.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b k.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return 'Mecze: $played · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga z: $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Nie udało się wczytać.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Nie udało się wczytać legend.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Nie udało się wczytać rekordów.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Nie udało się wczytać krajów.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Nie udało się wczytać twojego bilansu.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Nie udało się wczytać bilansu.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Brak legend. Rozegraj kilka kampanii, a tutaj pojawią się wielcy zawodnicy. Kraj: $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Najlepsza drużyna, jaką może wystawić reprezentacja: $nation.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Świat nie ma jeszcze historii. Rozegraj kilka kampanii, a tutaj pojawią się najwięksi wszech czasów.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Rozegraj kilka meczów i zacznij pisać historię. Reprezentacja: $nation.';
  }

  @override
  String get tacticsLineGk => 'BR';

  @override
  String get tacticsLineDef => 'OBR';

  @override
  String get tacticsLineMid => 'POM';

  @override
  String get tacticsLineFwd => 'NAP';

  @override
  String get tacticsGoalkeepers => 'BRAMKARZE';

  @override
  String get tacticsDefenders => 'OBROŃCY';

  @override
  String get tacticsMidfielders => 'POMOCNICY';

  @override
  String get tacticsForwards => 'NAPASTNICY';

  @override
  String get tacticsCallUpsTitle => 'POWOŁANIA';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Wybierz co najmniej $min zawodników.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Nie udało się wczytać kadry.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Brak kadry.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'KADRA · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min. $min · Maks. $max';
  }

  @override
  String get tacticsBestQuality => 'Najlepsza jakość';

  @override
  String get tacticsPreviousSquad => 'Poprzednia kadra';

  @override
  String get tacticsSquadLockedBack => 'Wstecz (kadra zamknięta)';

  @override
  String get tacticsConfirmSquad => 'Zatwierdź kadrę';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Kadra pełna (maks. $max)';
  }

  @override
  String get tacticsSquadLocked => 'KADRA ZAMKNIĘTA';

  @override
  String get tacticsNominationOpen => 'POWOŁANIA OTWARTE. WYBIERZ KADRĘ';

  @override
  String get tacticsSquadFixedBlurb =>
      'Ta kadra jest ustalona na poniższe mecze. Wybierzesz ją ponownie przed kolejnym oknem powołań.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Ta kadra zagra w poniższych meczach.';

  @override
  String get tacticsUnknown => 'Nieznany';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Wiek $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Wyczerpany';

  @override
  String get tacticsFatigueTired => 'Zmęczony';

  @override
  String get tacticsFatigueMatchLegs => 'Ciężkie nogi';

  @override
  String tacticsTooManySubs(int max) {
    return 'Za dużo zmian (maks. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTYKA · $minute\'';
  }

  @override
  String get tacticsApply => 'ZASTOSUJ';

  @override
  String get tacticsTabLineupSubs => 'SKŁAD I ZMIANY';

  @override
  String get tacticsTabTactics => 'TAKTYKA';

  @override
  String get squadLineKeepers => 'BRAMKARZE';

  @override
  String get squadLineDefenders => 'OBRONA';

  @override
  String get squadLineMidfielders => 'POMOC';

  @override
  String get squadLineForwards => 'ATAK';

  @override
  String get squadStatXiRating => 'Ocena XI';

  @override
  String get squadStatAvgAge => 'Śr. wiek';

  @override
  String get squadStatSize => 'Kadra';

  @override
  String get squadStatUnavailable => 'Poza grą';

  @override
  String get squadDepthTitle => 'GŁĘBIA FORMACJI';

  @override
  String squadAgeShort(int age) {
    return '$age l.';
  }

  @override
  String get tacticsTabOtherPositions => 'INNE POZYCJE';

  @override
  String get tacticsOutOfPositionNote => 'Nie na swojej pozycji';

  @override
  String get tacticsNobodyElse => 'Nie ma tu nikogo innego do sprawdzenia.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Wybierz, kto schodzi, a tutaj pojawi się reszta ławki z oceną na tej pozycji.';

  @override
  String get tacticsTabSuitable => 'PASUJĄCY';

  @override
  String get tacticsTabOnPitch => 'NA BOISKU';

  @override
  String tacticsSectionSuitable(int count) {
    return 'PASUJĄCY · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Nikt z ławki nie gra naturalnie na tej pozycji, więc oto wszyscy.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'NA BOISKU · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'DOSTĘPNI · $count';
  }

  @override
  String get tacticsRowStarted => 'W wyjściowym składzie';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Wszedł w $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Wszedł z ławki';

  @override
  String get tacticsEnergyLabel => 'ENERGIA';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Wybierz zmiennika. Schodzi: $name. Dotknij go ponownie, by anulować.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Straciłeś to miejsce przez czerwoną kartkę. Przeciągnij tu kolegę z drużyny, aby przesunąć lukę.';

  @override
  String get tacticsSentOffShort => 'CZERWONA';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'ZMIANY · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Dotknij zawodnika na boisku, by go zdjąć, albo przytrzymaj i przeciągnij na niego rezerwowego.';

  @override
  String get tacticsNoSubs => 'Brak dostępnych rezerwowych.';

  @override
  String get tacticsChooseShape => 'WYBIERZ USTAWIENIE';

  @override
  String get tacticsFormation => 'USTAWIENIE';

  @override
  String get tacticsInstructions => 'INSTRUKCJE';

  @override
  String get tacticsDrilling => 'ZGRANIE';

  @override
  String get tacticsDrillingUnplayed => 'NIEGRANE';

  @override
  String get tacticsDrillingNew => 'NOWE';

  @override
  String get tacticsDrillingSettling => 'WDRAŻANE';

  @override
  String get tacticsDrillingDrilled => 'OPANOWANE';

  @override
  String get matchInstructionsLocked =>
      'Ustalone przed meczem. Możesz zmienić ustawienie i dokonywać zmian, ale nie zmienisz podejścia w trakcie gry.';

  @override
  String get tacticsInstrMentality => 'Nastawienie';

  @override
  String get tacticsInstrDefensive => 'Defensywne';

  @override
  String get tacticsInstrAttacking => 'Ofensywne';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Niski blok';

  @override
  String get tacticsInstrHighPress => 'Wysoki pressing';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Cierpliwe';

  @override
  String get tacticsInstrFast => 'Szybkie';

  @override
  String get tacticsInstrWidth => 'Szerokość';

  @override
  String get tacticsInstrNarrow => 'Wąsko';

  @override
  String get tacticsInstrWide => 'Szeroko';

  @override
  String get tacticsInstrDefLine => 'Linia obr.';

  @override
  String get tacticsInstrDefensiveLine => 'Linia obrony';

  @override
  String get tacticsInstrDeep => 'Głęboko';

  @override
  String get tacticsInstrHigh => 'Wysoko';

  @override
  String get tacticsInstrDirectness => 'Bezpośredniość';

  @override
  String get tacticsInstrPossession => 'Posiadanie';

  @override
  String get tacticsInstrDirect => 'Bezpośrednio';

  @override
  String get tacticsPickGoalkeeper => 'WYBIERZ BRAMKARZA';

  @override
  String get tacticsPickLeftBack => 'WYBIERZ LEWEGO OBROŃCĘ';

  @override
  String get tacticsPickCentreBack => 'WYBIERZ ŚRODKOWEGO OBROŃCĘ';

  @override
  String get tacticsPickRightBack => 'WYBIERZ PRAWEGO OBROŃCĘ';

  @override
  String get tacticsPickDefensiveMid => 'WYBIERZ DEFENSYWNEGO POMOCNIKA';

  @override
  String get tacticsPickCentralMid => 'WYBIERZ ŚRODKOWEGO POMOCNIKA';

  @override
  String get tacticsPickAttackingMid => 'WYBIERZ OFENSYWNEGO POMOCNIKA';

  @override
  String get tacticsPickLeftMid => 'WYBIERZ LEWEGO POMOCNIKA';

  @override
  String get tacticsPickRightMid => 'WYBIERZ PRAWEGO POMOCNIKA';

  @override
  String get tacticsPickLeftWing => 'WYBIERZ LEWEGO SKRZYDŁOWEGO';

  @override
  String get tacticsPickRightWing => 'WYBIERZ PRAWEGO SKRZYDŁOWEGO';

  @override
  String get tacticsPickStriker => 'WYBIERZ NAPASTNIKA';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · nie na swojej pozycji';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Wiek $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Wiek $age';
  }

  @override
  String get tacticsOn => 'GRA';

  @override
  String get tacticsSquad => 'KADRA';

  @override
  String get tacticsTabLineup => 'SKŁAD';

  @override
  String get tacticsTabInstructions => 'INSTRUKCJE';

  @override
  String get tacticsTabRoles => 'ROLE';

  @override
  String get tacticsTabSetPieces => 'STAŁE FRAGMENTY';

  @override
  String get tacticsTabRolesSetPieces => 'ROLE I STAŁE FRAGMENTY';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Daj każdemu zawodnikowi z wyjściowego składu rolę. Dotknij plakietki rzutu karnego (⚽) lub rzutu wolnego (▲), by wyznaczyć wykonawcę.';

  @override
  String get tacticsTooltipCallUps => 'Powołania';

  @override
  String get tacticsTooltipPresets => 'Zapisane taktyki';

  @override
  String get tacticsTooltipInstructions => 'Instrukcje';

  @override
  String get tacticsNoTacticSet => 'Brak ustawionej taktyki.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ZASTĄP $count ZAWODNIKA',
      many: 'ZASTĄP $count ZAWODNIKÓW',
      few: 'ZASTĄP $count ZAWODNIKÓW',
      one: 'ZASTĄP $count ZAWODNIKA',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Poza grą';

  @override
  String get tacticsTapSpotReplace =>
      'Dotknij jego miejsca na boisku, by wybrać zmiennika.';

  @override
  String get tacticsTapOrDrag =>
      'Dotknij zawodnika, by go wymienić, albo przytrzymaj i przeciągnij, by go przesunąć.';

  @override
  String get tacticsPlayerRoles => 'ROLE ZAWODNIKÓW';

  @override
  String get tacticsRolesBlurb =>
      'Daj zawodnikowi zadanie: lis pola karnego, rozgrywający, wysoki napastnik. To decyduje, kto strzela, a kto kreuje.';

  @override
  String get tacticsSetPieceTakers => 'WYKONAWCY STAŁYCH FRAGMENTÓW';

  @override
  String get tacticsSetPieceBlurb =>
      'Kto wykonuje rzuty karne i stałe fragmenty. Możesz też zostawić to najlepiej przygotowanemu.';

  @override
  String get tacticsTakerAuto => 'Automatycznie';

  @override
  String get tacticsTakerQuickPick => 'Wybierz najlepszych';

  @override
  String get tacticsPenalties => 'Rzuty karne';

  @override
  String get tacticsCornersFreeKicks => 'Rożne i wolne';

  @override
  String get tacticsSkillFin => 'WYK';

  @override
  String get tacticsSkillPas => 'POD';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROLA · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'WYKONAWCA KARNYCH';

  @override
  String get tacticsCornerFreeKickTaker => 'WYKONAWCA ROŻNYCH I WOLNYCH';

  @override
  String get tacticsAutomatic => 'Automatycznie';

  @override
  String get tacticsLetBestSuited =>
      'Niech wykona najlepiej przygotowany zawodnik.';

  @override
  String get tacticsInXi => 'W XI';

  @override
  String get tacticsTeamInstructions => 'INSTRUKCJE DRUŻYNOWE';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Ustal, jak gra twój zespół. Każde pokrętło wpływa na całą drużynę.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Zapisano „$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Zastosowano „$name”';
  }

  @override
  String get tacticsTacticPresets => 'ZAPISANE TAKTYKI';

  @override
  String get tacticsPresetsBlurb =>
      'Zapisz to ustawienie jako styl do ponownego użycia albo zastosuj zapisany wcześniej.';

  @override
  String get tacticsSaveCurrentTactic => 'Zapisz obecną taktykę';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Nie udało się wczytać taktyk.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Brak zapisanych taktyk. Dotknij „Zapisz obecną taktykę”, by zachować to ustawienie jako styl.';

  @override
  String get tacticsNameThisTactic => 'Nazwij tę taktykę';

  @override
  String get tacticsNameHint => 'np. Wysoki pressing 4-3-3';

  @override
  String get tacticsCancel => 'Anuluj';

  @override
  String get tacticsSave => 'Zapisz';

  @override
  String get tacticsTapToAssign => 'Dotknij, by przypisać';

  @override
  String get tacticsHoldDragSub =>
      'Przytrzymaj rezerwowego i przeciągnij go na zawodnika, by go wprowadzić.';

  @override
  String get hubContinue => 'Dalej';

  @override
  String get hubBrackets => 'Drabinka';

  @override
  String hubCouldNotLoad(String error) {
    return 'Nie udało się wczytać.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Nie udało się wczytać finansów.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Nie udało się wczytać zapisu.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Nie znaleziono zapisu.';

  @override
  String get hubUnknown => 'Nieznane';

  @override
  String hubWorldChampionsYear(int year) {
    return 'MISTRZ ŚWIATA $year';
  }

  @override
  String get hubCycleComplete => 'Cykl dobiegł końca.';

  @override
  String get hubYourJob => 'TWOJA POSADA';

  @override
  String get hubStayProject => 'Zostań i kontynuuj swój projekt';

  @override
  String get hubChooseNextJob => 'WYBIERZ KOLEJNĄ POSADĘ';

  @override
  String get hubOffersOnTable => 'OFERTY NA STOLE';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · świat #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Kontynuuj: $nation';
  }

  @override
  String get hubYourNation => 'twój kraj';

  @override
  String get hubTakeTheJob => 'Przyjmij posadę';

  @override
  String get hubFederationFinances => 'FINANSE FEDERACJI';

  @override
  String get hubBudgetIntro =>
      'Twoim pierwszym zadaniem w nowym cyklu będzie ustalenie budżetu federacji i podział go między działy.';

  @override
  String get hubStarting => 'Rozpoczynanie…';

  @override
  String get hubBeginNextCycle => 'Rozpocznij kolejny cykl';

  @override
  String get hubContinueCareer => 'Kontynuuj karierę';

  @override
  String get hubBackToSaves => 'Wróć do zapisów';

  @override
  String get hubOpeningBalance => 'Saldo początkowe';

  @override
  String get hubCentralFunding => 'Środki centralne';

  @override
  String get hubPrizeMoney => 'Premie za wyniki';

  @override
  String get hubCommercialReturn => 'Przychody komercyjne';

  @override
  String get hubAvailableToInvest => 'Do zainwestowania';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputacja: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Bohater narodowy';

  @override
  String get hubFinal => 'Finał';

  @override
  String get hubStageRoundOf32 => '1/16 finału';

  @override
  String get hubStageThirdPlace => 'Mecz o 3. miejsce';

  @override
  String get hubEventAdvanceWorld => 'Przesuń świat';

  @override
  String hubEventStartCycle(int year) {
    return 'Rozpocznij cykl $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Mistrz świata: $nation';
  }

  @override
  String get hubEventSetBudget => 'Ustal budżet federacji';

  @override
  String get hubEventSetBudgetSub =>
      'Rozdziel fundusze tego cyklu przed startem sezonu';

  @override
  String get hubEventNaturalization => 'Rozpatrz ofertę naturalizacji';

  @override
  String get hubEventNaturalizationSub =>
      'Zagraniczny zawodnik chce grać dla twojej reprezentacji';

  @override
  String get hubEventIntercontinentalPlayoff => 'Baraż interkontynentalny';

  @override
  String get hubEventWatchWcDraw => 'Obejrzyj losowanie Mistrzostw Świata';

  @override
  String get hubEventWorldCupHere => 'Mistrzostwa Świata czas zacząć';

  @override
  String get hubEventWatchFinalsDraw =>
      'Obejrzyj losowanie turnieju finałowego';

  @override
  String get hubEventFinalsHere => 'Turniej finałowy czas zacząć';

  @override
  String get hubEventPlayWcRound => 'Rozegraj kolejną rundę Mistrzostw Świata';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Rozegraj kolejny mecz turnieju: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Rozegraj kolejny mecz Pucharu Narodów';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Obejrzyj losowanie Pucharu Narodów';

  @override
  String get hubEventWatchHostSelection => 'Obejrzyj wybór gospodarza';

  @override
  String get hubEventWatchQualifyingDraw => 'Obejrzyj losowanie eliminacji';

  @override
  String get hubEventWatchWcHostSelection =>
      'Obejrzyj wybór gospodarza Mistrzostw Świata';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Obejrzyj losowanie eliminacji Mistrzostw Świata';

  @override
  String get hubEventArrangeFriendlies => 'Umów mecze towarzyskie';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nie wypełniłeś jeszcze $count wolnych okien na mecze towarzyskie',
      many: 'Nie wypełniłeś jeszcze $count wolnych okien na mecze towarzyskie',
      few: 'Nie wypełniłeś jeszcze $count wolnych okien na mecze towarzyskie',
      one: 'Nie wypełniłeś jeszcze wolnego okna na mecz towarzyski',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Przebuduj wyjściową jedenastkę';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count zawodnika z twojej XI wypada (kartki lub kontuzje). Wybierz zmienników',
      many:
          '$count zawodników z twojej XI wypada (kartki lub kontuzje). Wybierz zmienników',
      few:
          '$count zawodników z twojej XI wypada (kartki lub kontuzje). Wybierz zmienników',
      one:
          '1 zawodnik z twojej XI wypada (kartki lub kontuzja). Wybierz zmiennika',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'W wyjściowej XI brakuje zawodników. Uzupełnij wolne miejsca',
      many: 'W wyjściowej XI brakuje zawodników. Uzupełnij wolne miejsca',
      few: 'W wyjściowej XI brakuje zawodników. Uzupełnij wolne miejsca',
      one: 'W wyjściowej XI brakuje zawodnika. Uzupełnij wolne miejsce',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Zagraj z rywalem: $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'turniej kontynentalny';

  @override
  String get hubCallUpFriendlies => 'Powołaj kadrę na mecze towarzyskie';

  @override
  String get hubCallUpRequalify => 'Powołaj ponownie kadrę na eliminacje';

  @override
  String get hubCallUpWorldCup => 'Powołaj kadrę na Mistrzostwa Świata';

  @override
  String get hubCallUpFinals => 'Powołaj kadrę na turniej finałowy';

  @override
  String get hubCallUpNationsCup => 'Powołaj kadrę na Puchar Narodów';

  @override
  String get hubCallUpQualifying => 'Powołaj kadrę na eliminacje';

  @override
  String get hubCallUpGeneric => 'Powołaj kadrę';

  @override
  String get hubHost => 'Gospodarz';

  @override
  String get hubGoldenBoot => 'Złoty But';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · gole: $goals';
  }

  @override
  String get hubPens => '(k.)';

  @override
  String get hubNationalHub => 'CENTRUM REPREZENTACJI';

  @override
  String get hubMessages => 'Wiadomości';

  @override
  String get hubWorldChampions => 'MISTRZ ŚWIATA';

  @override
  String get hubViewBracket => 'Zobacz drabinkę ›';

  @override
  String get hubBoardDelighted => 'Zachwycony';

  @override
  String get hubBoardPleased => 'Zadowolony';

  @override
  String get hubBoardExpectingMore => 'Oczekuje więcej';

  @override
  String get hubBoardConcerned => 'Zaniepokojony';

  @override
  String get hubBoardJobAtRisk => 'Posada zagrożona';

  @override
  String get hubBoard => 'ZARZĄD';

  @override
  String hubBoardObjective(String label) {
    return 'Cel zarządu: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'OSIĄGNIĘTY · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'NIEOSIĄGNIĘTY · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Brak kolejnych meczów w tym cyklu.';

  @override
  String get hubNextMatch => 'NASTĘPNY MECZ';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Ranking światowy';

  @override
  String get hubSquadStatus => 'STAN KADRY';

  @override
  String hubPlayers(int count) {
    return 'Zawodnicy: $count';
  }

  @override
  String get hubAvgRating => 'Śr. ocena';

  @override
  String get hubMorale => 'Morale';

  @override
  String get hubManageTeam => 'Zarządzaj drużyną';

  @override
  String get hubGroupsToBeDrawn =>
      'Grupy nie zostały jeszcze rozlosowane. Obejrzyj losowanie, by je poznać.';

  @override
  String hubGroupName(String name) {
    return 'GRUPA $name';
  }

  @override
  String get hubTblTeam => 'DRUŻYNA';

  @override
  String get hubTblP => 'M';

  @override
  String get hubTblGd => 'RB';

  @override
  String get hubTblPts => 'PKT';

  @override
  String get homeSettings => 'Ustawienia';

  @override
  String get homeLeadTheNation => 'POPROWADŹ REPREZENTACJĘ';

  @override
  String get homeYourNation => 'twój kraj';

  @override
  String get homeNewGame => 'Nowa gra';

  @override
  String get homeAllSaves => 'Wszystkie zapisy';

  @override
  String get homeLoadGame => 'Wczytaj grę';

  @override
  String get homeContinue => 'KONTYNUUJ';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Droga na Mistrzostwa Świata $year';
  }

  @override
  String get careerManageSaves => 'Zarządzaj zapisami';

  @override
  String get careerNewGameTitle => 'NOWA GRA';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Nie udało się wczytać kraju.\n$error';
  }

  @override
  String get careerNationNotFound => 'Nie znaleziono kraju.';

  @override
  String careerWorldRankNum(int rank) {
    return 'RANKING ŚWIATOWY #$rank';
  }

  @override
  String get careerManagerName => 'Imię i nazwisko selekcjonera';

  @override
  String get careerManagerNameHint => 'np. Kazimierz Górski';

  @override
  String get careerBeginsBlurb =>
      'Twoja kariera zaczyna się we wrześniu 2026 roku, na drodze do Mistrzostw Świata 2030.';

  @override
  String get careerFreeCycleNote =>
      'Za darmo przez jeden pełny czteroletni cykl: eliminacje, mistrzostwa kontynentu i Mistrzostwa Świata, w dwóch zapisach. Potem jedna płatność odblokowuje nieskończone cykle.';

  @override
  String get careerStartCareer => 'Rozpocznij karierę';

  @override
  String get careersTitle => 'KARIERY';

  @override
  String get careerManagerCareer => 'Kariera selekcjonera';

  @override
  String get careerManagerCareerSubtitle =>
      'Każdy prowadzony cykl i twój ogólny bilans';

  @override
  String get careerSummaryTitle => 'Podsumowanie kariery';

  @override
  String get careerSummarySubtitle =>
      'Gablota z trofeami i bilans selekcjonera';

  @override
  String get careerAchievements => 'Osiągnięcia';

  @override
  String get careerAchievementsSubtitle =>
      'Kamienie milowe, tytuły i zadowolenie zarządu';

  @override
  String get careerChallenges => 'Wyzwania';

  @override
  String get careerChallengesSubtitle => 'Brutalne testy na całą karierę';

  @override
  String get careerTeamRecords => 'Rekordy drużyny';

  @override
  String get careerTeamRecordsSubtitle =>
      'Najlepsi strzelcy i rekordziści występów';

  @override
  String get careerMyMatches => 'Moje mecze';

  @override
  String get careerMyMatchesSubtitle => 'Każdy wynik i nadchodzący mecz';

  @override
  String get careerTitle => 'KARIERA';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Nie udało się wczytać kariery.\n$error';
  }

  @override
  String get careerNoCareer => 'Brak kariery.';

  @override
  String get careerTrophyCabinet => 'GABLOTA Z TROFEAMI';

  @override
  String get careerTournamentHistory => 'HISTORIA TURNIEJÓW';

  @override
  String get careerNoTournamentsYet =>
      'Nie zakończono jeszcze żadnego turnieju.';

  @override
  String get careerTeamFallback => 'Drużyna';

  @override
  String careerWorldNum(int rank) {
    return 'ŚWIAT #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PKT';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SEZON $season';
  }

  @override
  String get careerStatPlayedShort => 'M';

  @override
  String get careerStatsHeading => 'W LICZBACH';

  @override
  String get careerStatsWinRate => '% zwycięstw';

  @override
  String get careerStatsGoalsFor => 'Gole strzelone';

  @override
  String get careerStatsGoalsAgainst => 'Gole stracone';

  @override
  String get careerStatsGoalDiff => 'Różnica bramek';

  @override
  String get careerStatsCleanSheets => 'Czyste konta';

  @override
  String get careerStatsBiggestWin => 'Najwyższe zwycięstwo';

  @override
  String get careerStatsWinStreak => 'Seria zwycięstw';

  @override
  String get careerStatsUnbeaten => 'Seria bez porażki';

  @override
  String get careerStatsShootouts => 'Serie karnych';

  @override
  String get careerStatsHatTricks => 'Hat-tricki';

  @override
  String get careerStatsMotms => 'Zawodnik meczu';

  @override
  String get careerStatsBestRating => 'Najlepsza ocena';

  @override
  String get careerStatWonShort => 'Z';

  @override
  String get careerStatDrawnShort => 'R';

  @override
  String get careerStatLostShort => 'P';

  @override
  String get careerStatGoalsForShort => 'BZ';

  @override
  String get careerStatGoalsAgainstShort => 'BS';

  @override
  String get careerStatGoalDiffShort => 'RB';

  @override
  String get careerNoSilverware => 'Jeszcze bez trofeów. Idź i jakieś zdobądź.';

  @override
  String get careerMedalGold => 'ZŁOTO';

  @override
  String get careerMedalSilver => 'SREBRO';

  @override
  String get careerMedalBronze => 'BRĄZ';

  @override
  String careerWinnersName(String name) {
    return 'Zwycięzca: $name';
  }

  @override
  String get careerSavesTitle => 'ZAPISY';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Nie udało się wczytać zapisów.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'MIEJSCA  $used/$limit';
  }

  @override
  String get careerThisSave => 'ten zapis';

  @override
  String get careerSlotsFull => 'Brak miejsc';

  @override
  String careerSlotsUsed(int used) {
    return 'MIEJSCA  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Odblokuj więcej zapisów';

  @override
  String get careerSlotsKeepNote =>
      'Każdy istniejący zapis nadal jest grywalny. Odblokowania wymaga tylko nowy.';

  @override
  String get careerNewGame => 'Nowa gra';

  @override
  String get careerDeleteSaveTitle => 'Usunąć zapis?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'To trwale usunie twoją karierę: $label.';
  }

  @override
  String get careerCancel => 'Anuluj';

  @override
  String get careerDelete => 'Usuń';

  @override
  String get careerNoSavesYet =>
      'Brak zapisów.\nRozpocznij nową grę i poprowadź reprezentację.';

  @override
  String get careerUnknownNation => 'Nieznany';

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
    return 'Ostatnio grane: $when';
  }

  @override
  String get careerJustNow => 'przed chwilą';

  @override
  String get careerYesterday => 'wczoraj';

  @override
  String careerMinutesAgo(int n) {
    return '$n min temu';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n h temu';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n d. temu';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Droga na Mistrzostwa Świata $year';
  }

  @override
  String get careerManagerCareerTitle => 'KARIERA SELEKCJONERA';

  @override
  String careerCouldNotLoad(String error) {
    return 'Nie udało się wczytać.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CYKL PO CYKLU';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cyklu',
      many: '$cycles cykli',
      few: '$cycles cykle',
      one: '1 cykl',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations prowadzonego kraju',
      many: '$nations prowadzonych krajów',
      few: '$nations prowadzone kraje',
      one: '1 prowadzony kraj',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Tytuły';

  @override
  String get careerStatPlayed => 'Mecze';

  @override
  String get careerStatWon => 'Wygrane';

  @override
  String get careerStatDrawn => 'Remisy';

  @override
  String get careerStatLost => 'Przegrane';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Bramki $goalsFor–$goalsAgainst  ($gd)  ·  Zwycięstwa $winRate%';
  }

  @override
  String get careerRecordResults => 'REKORDOWE WYNIKI';

  @override
  String get careerBestWin => 'Najwyższe zwycięstwo';

  @override
  String get careerWorstDefeat => 'Najwyższa porażka';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'rywal: $opponent · $date';
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
    return '${won}Z ${drawn}R ${lost}P  ·  BZ $goalsFor BS $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Mistrzostwa Świata';

  @override
  String get careerContinentalLabel => 'Kontynentalny';

  @override
  String get messagesTitle => 'WIADOMOŚCI';

  @override
  String get messagesNoMessagesYet => 'Brak wiadomości.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Nie udało się wczytać wiadomości.\n$error';
  }

  @override
  String get messagesDone => 'Gotowe';

  @override
  String get messagesNext => 'Dalej';

  @override
  String get rankingWorldRanking => 'RANKING ŚWIATOWY';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Nie udało się wczytać rankingu.\n$error';
  }

  @override
  String get rankingNoRanking => 'Brak rankingu.';

  @override
  String get rankingAll => 'WSZYSTKIE';

  @override
  String get rankingYourTeam => 'TWOJA DRUŻYNA';

  @override
  String get rankingYourRankingOverTime =>
      'TWOJE MIEJSCE W RANKINGU NA PRZESTRZENI LAT';

  @override
  String rankingNowRank(int rank) {
    return 'teraz #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'najwyżej #$best · najniżej #$worst';
  }

  @override
  String get friendliesTitle => 'MECZE TOWARZYSKIE';

  @override
  String friendliesLoadError(String error) {
    return 'Nie udało się wczytać meczów towarzyskich.\n$error';
  }

  @override
  String get friendliesContinue => 'Dalej';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wolne okna: $count',
      many: 'Wolne okna: $count',
      few: 'Wolne okna: $count',
      one: 'Wolne okna: 1',
    );
    return 'Umów sparingi przed kolejnym meczem o punkty. $_temp0. Dotknij rywala albo zostaw okno wolne.';
  }

  @override
  String get friendliesFree => 'Wolne';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count GOLA',
      many: '$count GOLI',
      few: '$count GOLE',
      one: '1 GOL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'GOLE';

  @override
  String get matchGoalsNone => 'Brak goli';

  @override
  String get matchGoalPenalty => 'K';

  @override
  String get matchGoalSetPiece => 'SF';

  @override
  String matchGoalAssist(String name) {
    return 'asysta: $name';
  }

  @override
  String get friendliesHome => 'U SIEBIE';

  @override
  String get friendliesAway => 'NA WYJEŹDZIE';

  @override
  String get friendliesNoneThisWindow => 'Bez sparingów w tym oknie';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sparingu',
      many: '$count sparingów',
      few: '$count sparingi',
      one: '1 sparing',
    );
    return 'Zatwierdź $_temp0';
  }

  @override
  String get friendliesMonthJan => 'sty';

  @override
  String get friendliesMonthFeb => 'lut';

  @override
  String get friendliesMonthMar => 'mar';

  @override
  String get friendliesMonthApr => 'kwi';

  @override
  String get friendliesMonthMay => 'maj';

  @override
  String get friendliesMonthJun => 'cze';

  @override
  String get friendliesMonthJul => 'lip';

  @override
  String get friendliesMonthAug => 'sie';

  @override
  String get friendliesMonthSep => 'wrz';

  @override
  String get friendliesMonthOct => 'paź';

  @override
  String get friendliesMonthNov => 'lis';

  @override
  String get friendliesMonthDec => 'gru';

  @override
  String get resultsMyMatches => 'MOJE MECZE';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Nie udało się wczytać wyników.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Brak meczów.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'ELIMINACJE';

  @override
  String get resultsStageFriendly => 'TOWARZYSKI';

  @override
  String get resultsStageGroupStage => 'FAZA GRUPOWA';

  @override
  String get resultsStageSemiFinal => 'PÓŁFINAŁ';

  @override
  String get resultsStageFinal => 'FINAŁ';

  @override
  String get resultsStageContinentalClash => 'STARCIE KONTYNENTÓW';

  @override
  String get resultsStageFinalsGroup => 'GRUPA TURNIEJU';

  @override
  String get resultsStageRoundOf32 => '1/16 FINAŁU';

  @override
  String get resultsStageRoundOf16 => '1/8 FINAŁU';

  @override
  String get resultsStageQuarterFinal => 'ĆWIERĆFINAŁ';

  @override
  String get resultsStageThirdPlace => 'MECZ O 3. MIEJSCE';

  @override
  String get matchSetupWarnCaptain =>
      'Brak kapitana. Dotknij, by komuś dać opaskę';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name jest kontuzjowany i nie wyprowadzi drużyny. Dotknij, by przekazać opaskę';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name pauzuje za kartki w tym meczu. Dotknij, by przekazać opaskę';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name ma opaskę, ale nie ma go w kadrze. Dotknij, by ją przekazać';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Brak wykonawców stałych fragmentów. Dotknij, by ich wybrać';

  @override
  String get matchSetupWarnBoth =>
      'Brak kapitana i wykonawców stałych fragmentów. Dotknij, by ich wyznaczyć';

  @override
  String matchStageMatchday(int matchday) {
    return 'KOL. $matchday';
  }

  @override
  String get squadCaptain => 'Kapitan';

  @override
  String deptEffectYouth(int points) {
    return 'Talenty z akademii lepsze o około $points pkt oceny';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount zwrotu na koniec cyklu';
  }

  @override
  String deptEffectMedical(int percent) {
    return 'O $percent% mniej kontuzji';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% szans, że zagraniczny zawodnik poprosi o zmianę barw';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points cierpliwości zarządu, zanim posada będzie zagrożona';
  }

  @override
  String get deptEffectNone => 'Brak efektu bez finansowania';

  @override
  String get statsBestRated => 'Oceny';

  @override
  String get statsMyCareer => 'Kariera';

  @override
  String get statsBestAverageRating => 'NAJLEPSZA ŚREDNIA OCENA';

  @override
  String get statsMyCareerRecord => 'TWÓJ BILANS';

  @override
  String get statsNoRatingsRecorded => 'Brak zapisanych ocen meczowych.';

  @override
  String get statsGroupRecord => 'Bilans';

  @override
  String get statsGroupRuns => 'Serie';

  @override
  String get statsGroupExtremes => 'Skrajności';

  @override
  String get statsGroupSplits => 'Dom i wyjazd';

  @override
  String get statsGroupSquad => 'Twoi zawodnicy';

  @override
  String get statsPlayed => 'Rozegrane mecze';

  @override
  String get statsWinDrawLoss => 'Zwycięstwa–remisy–porażki';

  @override
  String get statsWinRate => '% zwycięstw';

  @override
  String get statsGoals => 'Bramki zdobyte:stracone';

  @override
  String get statsCleanSheets => 'Czyste konta';

  @override
  String get statsFailedToScore => 'Bez strzelonego gola';

  @override
  String get statsLongestWinStreak => 'Najdłuższa seria zwycięstw';

  @override
  String get statsLongestUnbeaten => 'Najdłuższa seria bez porażki';

  @override
  String get statsLongestCleanSheets => 'Najdłuższa seria czystych kont';

  @override
  String get statsLongestWinless => 'Najdłuższa seria bez zwycięstwa';

  @override
  String get statsCurrentRun => 'Obecna seria bez porażki';

  @override
  String get statsBiggestWin => 'Najwyższe zwycięstwo';

  @override
  String get statsHeaviestDefeat => 'Najwyższa porażka';

  @override
  String get statsMostGoalsInAGame => 'Najwięcej goli w meczu';

  @override
  String get statsShootouts => 'Serie karnych wygrane–przegrane';

  @override
  String get statsComebackWins => 'Zwycięstwa po odrobieniu strat';

  @override
  String get statsHome => 'U siebie';

  @override
  String get statsAway => 'Na wyjeździe';

  @override
  String get statsNeutral => 'Teren neutralny';

  @override
  String get statsCompetitive => 'O punkty';

  @override
  String get statsFriendlies => 'Towarzyskie';

  @override
  String get statsHatTricks => 'Hat-tricki';

  @override
  String get statsBraces => 'Dublety';

  @override
  String get statsMotms => 'Nagrody dla zawodnika meczu';

  @override
  String get statsAssists => 'Asysty';

  @override
  String get statsCards => 'Kartki';

  @override
  String get statsBestRating => 'Najlepsza ocena indywidualna';

  @override
  String statsAppsShort(int apps) {
    return 'wyst.: $apps';
  }

  @override
  String statsMotmShort(int motms) {
    return 'MVP: $motms';
  }

  @override
  String get captainArmband => 'C';

  @override
  String get captainCurrent => 'Kapitan. Dotknij, by odebrać opaskę';

  @override
  String get captainFitBorn => 'Urodzony przywódca';

  @override
  String get captainFitNatural => 'Naturalny kapitan';

  @override
  String get captainFitCapable => 'Udźwignie opaskę';

  @override
  String get captainFitUnproven => 'Jeszcze nie lider';

  @override
  String get captainNone => 'Nie wyznaczono kapitana';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale morale kadry';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Eliminacje Mistrzostw Świata';

  @override
  String get resultsCategoryFriendlies => 'Mecze towarzyskie';

  @override
  String get resultsCategoryContinentalClash => 'Starcie Kontynentów';

  @override
  String get resultsCategoryNationsCup => 'Puchar Narodów';

  @override
  String get resultsCategoryContinentalCup => 'Puchar kontynentu';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'El. MŚ';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'El. kontynentu';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Eliminacje mistrzostw kontynentu';

  @override
  String get resultsCategoryWorldCupFinals =>
      'Turniej finałowy Mistrzostw Świata';

  @override
  String get resultsRoundResults => 'WYNIKI KOLEJKI';

  @override
  String get resultsFriendlyInternationals => 'MECZE TOWARZYSKIE REPREZENTACJI';

  @override
  String get resultsKnockout => 'Faza pucharowa';

  @override
  String resultsEarlierMatches(int count) {
    return 'Wcześniejsze mecze ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'KOLEJKA $matchday';
  }

  @override
  String get resultsContinue => 'Dalej';

  @override
  String resultsGroup(String name) {
    return 'GRUPA $name';
  }

  @override
  String get achievementsScreenTitle => 'OSIĄGNIĘCIA';

  @override
  String get achievementsChallengesTooltip => 'Wyzwania';

  @override
  String get achievementsChallengesHeading => 'WYZWANIA';

  @override
  String get achievementsBrutalTests => 'Brutalne testy na całą karierę';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Nie udało się wczytać.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return 'Odblokowane: $earned / $total';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return 'Zaliczone: $done / $total';
  }

  @override
  String get achievementsBoardSatisfaction => 'ZADOWOLENIE ZARZĄDU';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count OSIĄGNIĘCIA ODBLOKOWANEGO',
      many: '$count OSIĄGNIĘĆ ODBLOKOWANYCH',
      few: '$count OSIĄGNIĘCIA ODBLOKOWANE',
      one: 'OSIĄGNIĘCIE ODBLOKOWANE',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Zwycięstwa';

  @override
  String get achCatMatches => 'Mecze';

  @override
  String get achCatQualifications => 'Awanse';

  @override
  String get achCatTitles => 'Tytuły';

  @override
  String get achCatMisc => 'Różne';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Gole';

  @override
  String get achCatStreaks => 'Serie';

  @override
  String get achTierBronze => 'Brąz';

  @override
  String get achTierSilver => 'Srebro';

  @override
  String get achTierGold => 'Złoto';

  @override
  String get achTierPlatinum => 'Platyna';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gola',
      many: '$count goli',
      few: '$count gole',
      one: '$count gol',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Strzel $count gola.',
      many: 'Strzel $count goli.',
      few: 'Strzel $count gole.',
      one: 'Strzel 1 gola.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count czystego konta',
      many: '$count czystych kont',
      few: '$count czyste konta',
      one: '$count czyste konto',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zachowaj $count czystego konta.',
      many: 'Zachowaj $count czystych kont.',
      few: 'Zachowaj $count czyste konta.',
      one: 'Zachowaj 1 czyste konto.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Zwycięski nawyk';

  @override
  String get achStreakWin5Desc => 'Wygraj pięć meczów z rzędu.';

  @override
  String get achStreakWin10 => 'Rozpędzeni';

  @override
  String get achStreakWin10Desc => 'Wygraj dziesięć meczów z rzędu.';

  @override
  String get achStreakWin20 => 'Walec';

  @override
  String get achStreakWin20Desc => 'Wygraj dwadzieścia meczów z rzędu.';

  @override
  String get achUnbeaten15 => 'Trudni do pokonania';

  @override
  String get achUnbeaten15Desc => 'Zagraj piętnaście meczów bez porażki.';

  @override
  String get achUnbeaten30 => 'Nietykalni';

  @override
  String get achUnbeaten30Desc => 'Zagraj trzydzieści meczów bez porażki.';

  @override
  String get achHattrick => 'Bohater hat-tricka';

  @override
  String get achHattrickDesc => 'Niech twój zawodnik ustrzeli hat-tricka.';

  @override
  String get achMotm10 => 'Wyróżniający się';

  @override
  String get achMotm10Desc => 'Zbierz 10 nagród dla zawodnika meczu.';

  @override
  String get achMotm50 => 'Talizman';

  @override
  String get achMotm50Desc => 'Zbierz 50 nagród dla zawodnika meczu.';

  @override
  String get achPerfect => 'Perfekcyjna dziesiątka';

  @override
  String get achPerfectDesc =>
      'Niech twój zawodnik dostanie ocenę 9,5+ za mecz.';

  @override
  String get achShootout => 'Lód w żyłach';

  @override
  String get achShootoutDesc => 'Wygraj pięć serii rzutów karnych.';

  @override
  String get achMassacre => 'Masakra';

  @override
  String get achMassacreDesc => 'Wygraj mecz różnicą co najmniej 7 goli.';

  @override
  String get achAnnihilation => 'Anihilacja';

  @override
  String get achAnnihilationDesc => 'Wygraj mecz różnicą co najmniej 10 goli.';

  @override
  String get chTierBronze => 'Brąz';

  @override
  String get chTierSilver => 'Srebro';

  @override
  String get chTierGold => 'Złoto';

  @override
  String get chTierLegendary => 'Legendarne';

  @override
  String get chFirstSteps => 'Na ławce';

  @override
  String get chFirstStepsDesc => 'Prowadź reprezentację przez 5 lat.';

  @override
  String get chUnbeaten10 => 'Rozpędzeni';

  @override
  String get chUnbeaten10Desc => 'Zagraj 10 meczów o punkty bez porażki.';

  @override
  String get chTwoNations => 'Nowe wyzwanie';

  @override
  String get chTwoNationsDesc => 'Poprowadź 2 różne reprezentacje.';

  @override
  String get chCont1 => 'Mistrz kontynentu';

  @override
  String get chCont1Desc => 'Wygraj mistrzostwa kontynentu.';

  @override
  String get chNc1 => 'Zdobywca Pucharu Narodów';

  @override
  String get chNc1Desc => 'Wygraj Puchar Narodów.';

  @override
  String get chWc1 => 'Mistrz świata';

  @override
  String get chWc1Desc => 'Wygraj Mistrzostwa Świata.';

  @override
  String get chYears25 => 'Instytucja';

  @override
  String get chYears25Desc => 'Prowadź reprezentacje przez 25 lat.';

  @override
  String get chWc3 => 'Seryjny zwycięzca';

  @override
  String get chWc3Desc => 'Wygraj Mistrzostwa Świata 3 razy.';

  @override
  String get chWc5 => 'Dynastia';

  @override
  String get chWc5Desc => 'Wygraj Mistrzostwa Świata 5 razy.';

  @override
  String get chWc10 => 'Nieśmiertelny';

  @override
  String get chWc10Desc => 'Wygraj Mistrzostwa Świata 10 razy.';

  @override
  String get chWc2Teams => 'Mam korki, mogę jechać';

  @override
  String get chWc2TeamsDesc =>
      'Wygraj Mistrzostwa Świata z 2 różnymi reprezentacjami.';

  @override
  String get chWc3Teams => 'Obieżyświat';

  @override
  String get chWc3TeamsDesc =>
      'Wygraj Mistrzostwa Świata z 3 różnymi reprezentacjami.';

  @override
  String get chWcStreak3 => 'Hat-trick tytułów';

  @override
  String get chWcStreak3Desc => 'Wygraj Mistrzostwa Świata 3 razy z rzędu.';

  @override
  String get chWcAllconf => 'Zdobywca świata';

  @override
  String get chWcAllconfDesc =>
      'Wygraj Mistrzostwa Świata z reprezentacją z każdej konfederacji (6).';

  @override
  String get chCont5 => 'Król kontynentu';

  @override
  String get chCont5Desc => 'Wygraj mistrzostwa kontynentu 5 razy.';

  @override
  String get chContAll => 'Szlem sześciu kontynentów';

  @override
  String get chContAllDesc =>
      'Wygraj mistrzostwa kontynentu w każdej konfederacji (6).';

  @override
  String get chTreble => 'Komplet';

  @override
  String get chTrebleDesc =>
      'Wygraj Mistrzostwa Świata, mistrzostwo kontynentu i Puchar Narodów w jednej karierze.';

  @override
  String get chNations10 => 'Koczownik';

  @override
  String get chNations10Desc => 'Poprowadź 10 różnych reprezentacji.';

  @override
  String get chYears100 => 'Stulecie';

  @override
  String get chYears100Desc => 'Prowadź reprezentacje przez 100 lat.';

  @override
  String get chYears500 => 'Pół tysiąclecia';

  @override
  String get chYears500Desc => 'Prowadź reprezentacje przez 500 lat.';

  @override
  String get chYears1000 => 'Wieczny';

  @override
  String get chYears1000Desc => 'Prowadź reprezentacje przez 1000 lat.';

  @override
  String get chGrandmaster => 'Arcymistrz';

  @override
  String get chGrandmasterDesc =>
      'Wygraj Mistrzostwa Świata 3 razy ORAZ mistrzostwa kontynentu 5 razy.';

  @override
  String get chUndefeated => 'Nietykalni';

  @override
  String get chUndefeatedDesc =>
      'Wygraj Mistrzostwa Świata bez żadnej porażki.';

  @override
  String get chPerfectQual => 'Bezbłędny awans';

  @override
  String get chPerfectQualDesc =>
      'Wygraj każdy mecz eliminacji Mistrzostw Świata.';

  @override
  String get chMinnow => 'Cud kopciuszka';

  @override
  String get chMinnowDesc =>
      'Wygraj Mistrzostwa Świata z reprezentacją spoza światowej czołowej 32.';

  @override
  String get chGrandTour => 'U siebie i na wyjeździe';

  @override
  String get chGrandTourDesc =>
      'Wygraj Mistrzostwa Świata jako gospodarz i raz poza swoim krajem.';

  @override
  String get chUnbeaten25 => 'Mur';

  @override
  String get chUnbeaten25Desc => 'Zagraj 25 meczów o punkty bez porażki.';

  @override
  String get chGoals10k => 'Maszyna do goli';

  @override
  String get chGoals10kDesc => 'Zdobądź 10 000 goli w karierze.';

  @override
  String get chCleanSheets500 => 'Twierdza';

  @override
  String get chCleanSheets500Desc => 'Zachowaj 500 czystych kont w karierze.';

  @override
  String get chHatTricks25 => 'Hat-trickowy nawyk';

  @override
  String get chHatTricks25Desc =>
      'Niech twoi zawodnicy ustrzelą 25 hat-tricków.';

  @override
  String get chWinStreak25 => 'Bezlitośni';

  @override
  String get chWinStreak25Desc => 'Wygraj 25 meczów z rzędu.';

  @override
  String get chCont10 => 'Dynastia kontynentu';

  @override
  String get chCont10Desc => 'Wygraj mistrzostwa kontynentu 10 razy.';

  @override
  String get chPcWc => 'Seryjny mistrz';

  @override
  String chPcWcDesc(int count) {
    return 'Wygraj Mistrzostwa Świata w tym zapisie. Liczba tytułów: $count.';
  }

  @override
  String get chPcMajors => 'Kolekcjoner trofeów';

  @override
  String chPcMajorsDesc(int count) {
    return 'Zdobądź wielkie trofea (Mistrzostwa Świata, kontynentu lub Puchar Narodów). Liczba: $count.';
  }

  @override
  String get chPcUnbeaten => 'Żelazny mur';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Zagraj bez porażki tyle meczów o punkty z rzędu: $count.';
  }

  @override
  String get chPcNations => 'Wędrowniczek';

  @override
  String chPcNationsDesc(int count) {
    return 'Poprowadź różne reprezentacje. Liczba: $count.';
  }

  @override
  String get chPcYears => 'Długi dystans';

  @override
  String chPcYearsDesc(int count) {
    return 'Prowadź reprezentacje przez lata. Liczba lat: $count.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zwycięstwa',
      many: '$count zwycięstw',
      few: '$count zwycięstwa',
      one: '1 zwycięstwo',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wygraj $count meczu.',
      many: 'Wygraj $count meczów.',
      few: 'Wygraj $count mecze.',
      one: 'Wygraj 1 mecz.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meczu',
      many: '$count meczów',
      few: '$count mecze',
      one: '$count mecz',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rozegraj $count meczu.',
      many: 'Rozegraj $count meczów.',
      few: 'Rozegraj $count mecze.',
      one: 'Rozegraj 1 mecz.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Awans na Mistrzostwa Świata';

  @override
  String get achQualWcDesc => 'Awansuj na Mistrzostwa Świata.';

  @override
  String get achQualCont => 'Awans na mistrzostwa kontynentu';

  @override
  String get achQualContDesc => 'Awansuj na mistrzostwa kontynentu.';

  @override
  String get achTitleWc => 'Mistrzowie świata';

  @override
  String get achTitleWcDesc => 'Wygraj Mistrzostwa Świata.';

  @override
  String get achTitleEuro => 'Mistrzowie Europy';

  @override
  String get achTitleEuroDesc => 'Wygraj Mistrzostwa Europy.';

  @override
  String get achTitleCopa => 'Mistrzowie Ameryki Południowej';

  @override
  String get achTitleCopaDesc => 'Wygraj Puchar Ameryki Południowej.';

  @override
  String get achTitleAfcon => 'Mistrzowie Afryki';

  @override
  String get achTitleAfconDesc => 'Wygraj Mistrzostwa Afryki.';

  @override
  String get achTitleAsia => 'Mistrzowie Azji';

  @override
  String get achTitleAsiaDesc => 'Wygraj Mistrzostwa Azji.';

  @override
  String get achTitleConcacaf => 'Mistrzowie Ameryki Północnej';

  @override
  String get achTitleConcacafDesc => 'Wygraj Puchar Ameryki Północnej.';

  @override
  String get achTitleOfc => 'Mistrzowie Oceanii';

  @override
  String get achTitleOfcDesc => 'Wygraj Puchar Oceanii.';

  @override
  String get achTitleNations => 'Zdobywcy Pucharu Narodów';

  @override
  String get achTitleNationsDesc => 'Wygraj Puchar Narodów.';

  @override
  String get achTitleClash => 'Zwycięzcy Starcia Kontynentów';

  @override
  String get achTitleClashDesc => 'Wygraj Starcie Kontynentów.';

  @override
  String get achMarksman => 'Snajper Mistrzostw Świata';

  @override
  String get achMarksmanDesc =>
      'Niech zawodnik z kadry strzeli 6+ goli w turnieju finałowym Mistrzostw Świata.';

  @override
  String get achSweep => 'Komplet';

  @override
  String get achSweepDesc =>
      'Zdobądź Mistrzostwo Świata i tytuł kontynentalny w jednej karierze.';

  @override
  String get achAllstar => 'Gwiazda turnieju';

  @override
  String get achAllstarDesc =>
      'Niech zawodnik trafi do jedenastki turnieju Mistrzostw Świata.';

  @override
  String get achGoldenboot => 'Złoty But';

  @override
  String get achGoldenbootDesc =>
      'Niech zawodnik twojej reprezentacji zostanie królem strzelców mistrzostw.';

  @override
  String get achDemolition => 'Demolka';

  @override
  String get achDemolitionDesc => 'Wygraj mecz różnicą co najmniej 5 goli.';

  @override
  String get achievementsNice => 'Super!';

  @override
  String get achievementsHardestTests =>
      'Najtrudniejsze próby dla selekcjonera, na całą karierę i wiele reprezentacji.';

  @override
  String get achievementsThisSave => 'TEN ZAPIS';

  @override
  String get achievementsBrutalBadge => 'BRUTALNE';

  @override
  String get paywallGoPro => 'PRZEJDŹ NA UNLIMITED';

  @override
  String get paywallOneTimeUnlock =>
      'Jednorazowe odblokowanie. Bez subskrypcji.';

  @override
  String get paywallBenefitCarryOn =>
      'Ten zapis toczy się dokładnie od miejsca, w którym stanął, z każdym występem, rekordem i rywalizacją.';

  @override
  String get paywallBenefitNoAds =>
      'Bez reklam, bez mikrotransakcji, bez subskrypcji. Jedna płatność i każda przyszła aktualizacja jest twoja.';

  @override
  String get paywallBenefitSaves =>
      'Tyle zapisów, ile chcesz. Prowadź faworyta i kopciuszka jednocześnie i przekonaj się, jak inaczej czyta się tę samą grę.';

  @override
  String get paywallBenefitEndless =>
      'Każdy kolejny cykl. Postaw dziś na siedemnastolatka i dowiedz się w 2034 roku, czy miałeś nosa.';

  @override
  String get paywallUnlocked => 'Unlimited odblokowane. Miłej gry!';

  @override
  String get paywallContactingStore => 'Łączenie ze sklepem…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Odblokuj Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Przywróć zakupy';

  @override
  String get paywallStoreUnavailable => 'Sklep niedostępny';

  @override
  String get paywallStoreUnavailableNote =>
      'Nie udało się pobrać ceny. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get paywallTryAgain => 'Spróbuj ponownie';

  @override
  String get gateTitle => 'TWÓJ PIERWSZY CYKL DOBIEGŁ KOŃCA';

  @override
  String get gateLead =>
      'Cztery lata to jeden cykl. To za mało, by przekonać się, czy miałeś rację.';

  @override
  String get gatePriceLead => 'Jedna płatność, na zawsze';

  @override
  String get gateBuy => 'KUP I GRAJ DALEJ';

  @override
  String get gateExit => 'WYJDŹ';

  @override
  String get federationNaturalisation => 'NATURALIZACJA';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name naturalizowany';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name zakończył zmianę barw i może już grać dla twojej reprezentacji ($nation). Powołaj go przy wyborze kadry.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Nie udało się wczytać oferty.\n$error';
  }

  @override
  String get federationContinue => 'Dalej';

  @override
  String get federationOfferToSwitchAllegiance => 'OFERTA ZMIANY BARW';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · wiek $age · kraj: $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name ma związki z krajem $playerNation i jest gotów przyjąć obywatelstwo. Zgódź się, a będzie mógł zostać powołany. Odmów, a zostanie przy reprezentacji $sourceNation.';
  }

  @override
  String get federationDecline => 'Odrzuć';

  @override
  String get federationNaturalise => 'Naturalizuj';

  @override
  String get federationBudgetLater => 'Zdecyduj później';

  @override
  String get federationSetYourBudget => 'USTAL BUDŻET';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Nie udało się wczytać finansów.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Nie znaleziono zapisu.';

  @override
  String get federationBudgetHeading => 'BUDŻET FEDERACJI';

  @override
  String federationDistributeBudget(String amount) {
    return 'Rozdziel $amount między działy, by otworzyć cykl. Wydawaj mądrze.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount ponad stan federacji. Zabierz trochę z powrotem';
  }

  @override
  String get federationAllocateFullBudget =>
      'Rozdziel cały budżet, by rozpocząć cykl.';

  @override
  String get federationConfirming => 'Zatwierdzanie…';

  @override
  String get federationConfirmBudget => 'Zatwierdź budżet';

  @override
  String get federationFinances => 'FINANSE';

  @override
  String get federationInvestmentUpdated => 'Inwestycje zaktualizowane.';

  @override
  String get federationDevelopment => 'ROZWÓJ FEDERACJI';

  @override
  String get federationProjectedAtSeasonEnd => 'PROGNOZA NA KONIEC SEZONU';

  @override
  String get federationCentralFunding => 'Środki centralne';

  @override
  String get federationPrizeMoneySoFar => 'Dotychczasowe premie';

  @override
  String get federationCommercialReturn => 'Przychody komercyjne';

  @override
  String get federationThisSeasonLocked => 'TEN SEZON (ZABLOKOWANE)';

  @override
  String get federationInvestForNextSeason => 'INWESTUJ NA PRZYSZŁY SEZON';

  @override
  String get federationNextSeasonImpact => 'EFEKT W PRZYSZŁYM SEZONIE';

  @override
  String get federationSaving => 'Zapisywanie…';

  @override
  String get federationConfirmInvestment => 'Zatwierdź inwestycje';

  @override
  String get federationBalance => 'SALDO FEDERACJI';

  @override
  String get federationCommittedToStaff => 'Zarezerwowane na sztab';

  @override
  String get federationFreeToSpend => 'Do wydania';

  @override
  String get federationWagesNote =>
      'Pensje schodzą z salda na koniec cyklu, więc ta kwota jest już zajęta.';

  @override
  String get federationInvestAtCeremony =>
      'Zainwestujesz na przyszły sezon podczas ceremonii na koniec cyklu.';

  @override
  String federationLevelBadge(int level) {
    return 'P$level';
  }

  @override
  String get federationAcademyProspects => 'Talenty z akademii';

  @override
  String federationPlusOverall(int value) {
    return '+$value oceny';
  }

  @override
  String get federationInjuryRisk => 'Ryzyko kontuzji';

  @override
  String get federationNaturalisationChance => 'Szansa na naturalizację';

  @override
  String get federationBoardPatience => 'Cierpliwość zarządu';

  @override
  String get federationUnallocated => 'NIEROZDZIELONE';

  @override
  String get nationsVitrineTitle => 'GABLOTA REPREZENTACJI';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Nie udało się wczytać kraju.\n$error';
  }

  @override
  String get nationsNoNation => 'Brak kraju.';

  @override
  String get nationsHonours => 'SUKCESY';

  @override
  String get nationsRankingHistory => 'HISTORIA W RANKINGU ŚWIATOWYM';

  @override
  String get nationsTopScorers => 'NAJLEPSI STRZELCY W HISTORII';

  @override
  String get nationsTitles => 'TYTUŁY';

  @override
  String get nationsYourTeam => 'TWOJA DRUŻYNA';

  @override
  String get nationsWorld => 'ŚWIAT';

  @override
  String get nationsWorldCup => 'Mistrzostwa Świata';

  @override
  String get nationsContinental => 'Kontynent';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count występu',
      many: '$count występów',
      few: '$count występy',
      one: '1 występ',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Za mało historii. Zajrzyj tu po cyklu lub dwóch.';

  @override
  String nationsBestRank(int rank) {
    return 'Najwyżej: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Teraz: #$rank';
  }

  @override
  String get nationsNoGoals => 'Brak zapisanych goli.';

  @override
  String get nationsGoalsAbbrev => 'gole';

  @override
  String get nationsHosts => 'GOSPODARZ';

  @override
  String get nationsSelectTitle => 'WYBIERZ REPREZENTACJĘ';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Nie udało się wczytać krajów.\n$error';
  }

  @override
  String get nationsNoMatch => 'Brak pasujących krajów.';

  @override
  String get nationsNationalLevel => 'POZIOM REPREZENTACJI';

  @override
  String get nationsSelectHeading => 'Wybierz reprezentację';

  @override
  String get nationsSearchHint => 'Szukaj kraju…';

  @override
  String get nationsRank => 'MIEJSCE ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'WYBIERZ';

  @override
  String get statsTeamRecords => 'REKORDY DRUŻYNY';

  @override
  String get statsRecordBook => 'Księga rekordów';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Nie udało się wczytać statystyk.\n$error';
  }

  @override
  String get statsNoData => 'Brak danych.';

  @override
  String get statsTopScorers => 'NAJLEPSI STRZELCY';

  @override
  String get statsMostGamesPlayed => 'NAJWIĘCEJ MECZÓW';

  @override
  String get statsTeam => 'Drużyna';

  @override
  String get statsTopScorersShort => 'Strzelcy';

  @override
  String get statsMostGames => 'Najwięcej meczów';

  @override
  String get statsNoGoalsRecorded => 'Brak zapisanych goli.';

  @override
  String get statsUnknown => 'Nieznany';

  @override
  String get playerTitle => 'ZAWODNIK';

  @override
  String playerLoadError(String error) {
    return 'Nie udało się wczytać zawodnika.\n$error';
  }

  @override
  String get playerNotFound => 'Nie znaleziono zawodnika.';

  @override
  String get playerClub => 'KLUB';

  @override
  String get playerClubRole => 'W klubie';

  @override
  String get playerPosition => 'Pozycja';

  @override
  String get playerPotential => 'Potencjał';

  @override
  String get playerAge => 'Wiek';

  @override
  String get playerValue => 'Wartość';

  @override
  String get clubFirstChoice => 'Gra co tydzień';

  @override
  String get clubRotation => 'Raz gra, raz nie';

  @override
  String get clubFringe => 'Prawie nie gra';

  @override
  String get clubFrozenOut => 'Nie gra';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Oglądam piłkę od trzydziestu lat i tego się nie spodziewałem. Rywal: $opponent, pokonany $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Nikt nie dawał nam szans. $opponent, $score. Absolutnie nikt.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score, rywal: $opponent. Idźcie obudzić sąsiadów.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'O takich nocach opowiada się wnukom. $opponent, $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score, rywal: $opponent. Jakkolwiek to się stało, stało się.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Na papierze było po meczu przed pierwszym gwizdkiem. $opponent, $score, mówi coś innego.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Wygrana $score, rywal: $opponent. Za rok nikt w ten wynik nie uwierzy.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent, $score. Cieszcie się, a potem spójrzcie w terminarz.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score, rywal: $opponent, a przez osiemdziesiąt z dziewięćdziesięciu minut jechaliśmy na farcie.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Jeden wieczór z rywalem $opponent nie wymaże całego roku. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Wygrana $score, rywal: $opponent, i zaraz usłyszymy o przełomie. Żadnego przełomu nie ma.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent, $score. Pięknie. Zapytaj mnie, kiedy będzie o coś grane.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Wygrana $score, rywal: $opponent. Dokładnie tak, jak powinno być, i jest w tym przyjemność.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score, rywal: $opponent. Bezlitośnie, a to komplement.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent, $score. Bez nerwów, bez strachu, bez narzekania.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Schludne $score, rywal: $opponent. Tak wygląda dobra drużyna w spokojny dzień.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score, rywal: $opponent. Robota zrobiona, niczego się nie nauczyliśmy.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Wygrana $score, rywal: $opponent. Mieliśmy wygrać i wygraliśmy.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Profesjonalne $score, rywal: $opponent. Następny.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return 'Rywal ($opponent) odprawiony $score. Do archiwum i dalej.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score, rywal: $opponent, a my mamy klaskać. Za to, że ich pokonaliśmy.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Gratulacje dla wszystkich za $score, rywal: $opponent. Chyba.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent, $score. Wygrywanie z takimi to minimum, a nie osiągnięcie.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Wygraliśmy $score, rywal: $opponent, i męczyliśmy się przy tym okropnie.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score, rywal: $opponent, i każda minuta wywalczona.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'To wymagało charakteru. $opponent, $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Wygrana $score, rywal: $opponent, i to w trudny sposób. Taki zostaje na dłużej.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score, rywal: $opponent. Drużyny, które wygrywają takie mecze, w czerwcu wciąż są w grze.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Nerwowo, brzydko, ale wygrana. $opponent, $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Wygrana $score, rywal: $opponent. Bierzemy trzy punkty i nigdy więcej tego nie oglądamy.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. Rywal ($opponent) kazał nam walczyć o każdy centymetr.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent, $score. Nie było pięknie. Liczy się tak samo.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score, rywal: $opponent, a zrobiliśmy z tego dziesięć razy trudniejszy mecz, niż był.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Nie powinniśmy drżeć o wynik z takim rywalem jak $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent, $score. Wygrane, ale nie dowiedzieliśmy się o sobie niczego dobrego.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$score, rywal: $opponent. I ten wynik nam jeszcze schlebia.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Punkt, rywal: $opponent, $score. Bierzemy i idziemy dalej.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score, rywal: $opponent. Bywają gorsze popołudnia.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Zatrzymaliśmy rywala ($opponent) na $score. Nie wszystko musi być historią.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent, $score. Punkt to punkt, a tabela nie pyta jak.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score, rywal: $opponent. Dwa punkty stracone albo jeden zdobyty. Wybierz nastrój.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Remis, rywal: $opponent, $score. Nikt nie jest zadowolony, nikt nie jest wściekły.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent, $score. Najbardziej zapomniane dziewięćdziesiąt minut roku.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Podział punktów, rywal: $opponent, $score. Jedziemy dalej.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score, rywal: $opponent. Tak po cichu umierają kampanie.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Dwa punkty wyrzucone do kosza, rywal: $opponent. $score. Inaczej tego nie nazwę.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent, $score. Mieliśmy dziewięćdziesiąt minut i zero pomysłu, co z nimi zrobić.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$score, rywal: $opponent. Nikt tego nie zapamięta, a wszyscy za to zapłacą.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Porażka $score, rywal: $opponent. Zdarza się.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent, $score. Nie ma kogo wieszać. Następny mecz.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Porażka $score, rywal: $opponent, ale zostawili serce na boisku. Czasem to za mało.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score, rywal: $opponent. Głowy do góry. Ta drużyna ma jeszcze sporo do pokazania.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent, $score. Byliśmy gorsi i nie ma o czym dyskutować.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Porażka $score, rywal: $opponent. Zbieramy się.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score, rywal: $opponent. Nie wstyd, ale nie dość dobrze.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Porażka $score, rywal: $opponent. Wyciągnijcie z tego wnioski, inaczej to strata czasu.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score, rywal: $opponent, a my nawet ich nie drasnęliśmy.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Porażka, rywal: $opponent, $score. Te same problemy, ten sam miesiąc, zaraz te same wymówki.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent, $score. Kiedy to przestaje być pechem?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Porażka $score, rywal: $opponent. Za taki wynik ktoś powinien zapłacić.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score, rywal: $opponent. Jeden zły wieczór. Oceniajcie drużynę po całej kampanii, nie po tym.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Nikt nie chciał tego $score (rywal: $opponent) mniej niż sami piłkarze.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent, $score. Brzydko i to nie jest prawdziwe oblicze tej drużyny.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return '$score do zapomnienia, rywal: $opponent. Następnym razem stawią czoła.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Rywal: $opponent. Brak mi słów, a płacą mi za słowa.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent, $score. Ktoś musi za to odpowiedzieć.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Chcę, żeby $score z rywalem $opponent wymazano z kronik i z pamięci.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Porażka $score, rywal: $opponent. Takiego wyniku nie da się ładnie opakować.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'To nie była porażka, to była kapitulacja. Rywal: $opponent. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Rywal: $opponent. Ludzie zapłacili, żeby to oglądać.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent, $score. Jeśli to niczego nie zmieni, nic już nie zmieni.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Widziałem już tę drużynę upokorzoną, ale $score (rywal: $opponent) to nowe dno.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'MISTRZOWIE. $opponent. Powiedz to na głos.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Wygraliśmy. $opponent. Nie ogarniam.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, a puchar jedzie do domu.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Każdy z nich to legenda. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Tak blisko. $opponent i medal, którego nikt nie chce.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Wicemistrzowie. $opponent. To będzie boleć latami.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: jeden mecz od wszystkiego.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Drudzy. $opponent. Niech ktoś poda butelkę.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Koniec przygody. $opponent. To będzie boleć jeszcze długo.';
  }

  @override
  String yEliminated1(String opponent) {
    return '$opponent: tu się dla nas kończy.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Odpadamy. $opponent. Czas na rozliczenia.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Odpadliśmy. $opponent. Niech mi ktoś to wytłumaczy.';
  }

  @override
  String yQualified0(String opponent) {
    return 'JEDZIEMY! $opponent!';
  }

  @override
  String yQualified1(String opponent) {
    return 'Awans! $opponent. Bierzcie urlop.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, nadchodzimy. Ani przez chwilę nie było wątpliwości (były same wątpliwości).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Awans: $opponent. Najtrudniejsze za nami.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Grupy rozlosowane. $opponent. Mogło być gorzej. Dużo gorzej.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Czyli tak wygląda losowanie. $opponent. Ciekawe.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Grupy na turniej ($opponent) znane, a naszej już nie lubię.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Losowanie za nami: $opponent. Niech zacznie się histeria.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Gospodarz: $opponent. Zacznijcie oszczędzać.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Turniej trafia do kraju $opponent. Przewidywalne, ale niech będzie.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent dostaje turniej. Gratulacje, chyba.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Gospodarz potwierdzony: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent już niedługo, a ja nie mogę usiedzieć na miejscu.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Niedługo startuje: $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent tuż-tuż. Poproszę ogłoszenie kadry.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Odliczanie: $opponent. Oficjalnie nie do zniesienia.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Na razie cisza. Zagraj mecz.';

  @override
  String get yEarlierHeading => 'Wcześniej w tym cyklu';

  @override
  String get yTraitLoyalist =>
      'Wspiera drużynę bez względu na wszystko. Wolno się obraża, szybko wybacza.';

  @override
  String get yTraitCynic => 'Zakłada najgorsze i cieszy się, gdy ma rację.';

  @override
  String get yTraitNostalgic =>
      'Kiedyś wszystko było lepsze. Porównuje cię z emerytami.';

  @override
  String get yTraitStatshead =>
      'Wrzuca liczby i nic więcej. Nastrój prawie zerowy.';

  @override
  String get yTraitHypeman => 'Dwa dobre wyniki i już mamy złote pokolenie.';

  @override
  String get yTraitContrarian => 'Cokolwiek myśli reszta, on odwrotnie.';

  @override
  String get yTraitDoomer => 'Coś pójdzie nie tak. Zawsze coś pójdzie nie tak.';

  @override
  String get yProfilePosts => 'WPISY';

  @override
  String get yProfileEmpty => 'To konto jeszcze nic nie napisało.';

  @override
  String hubEventGrievance(String player) {
    return '$player chce porozmawiać';
  }

  @override
  String get hubEventGrievanceSub => 'Chce wiedzieć, na czym stoi';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punktu umiejętności do wydania',
      many: '$count punktów umiejętności do wydania',
      few: '$count punkty umiejętności do wydania',
      one: '1 punkt umiejętności do wydania',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'To, w czym jesteś dobry, czyni lepszą twoją drużynę';

  @override
  String get grievanceTitle => 'Rozmowa w twoim gabinecie';

  @override
  String grievanceGameTime(String player) {
    return '$player jest w kadrze, a nie zagrał ani minuty. Chce wiedzieć dlaczego.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player nie jest w kadrze i nie rozumie dlaczego. Chce usłyszeć jasną odpowiedź.';
  }

  @override
  String grievanceRole(String player) {
    return '$player ciągle gra nie na swojej pozycji i ma tego dość.';
  }

  @override
  String get grievanceReassure => 'Jesteś w moich planach';

  @override
  String get grievanceHonest => 'Inni są przed tobą, i oto dlaczego';

  @override
  String get grievanceDismiss => 'To ja wybieram skład';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name trafił $goals razy. Nikt nawet się nie zbliżył.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$name i $goals trafienia na koncie. On niesie tę drużynę.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals gole w jednym meczu. Co za piłkarz.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$goals razy ich pokonał. $name, ukłon.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$name trafił $goals razy, a reszta była tylko pasażerami.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Znowu $name. $goals gole. Wyobraźcie sobie tę drużynę bez niego.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$name strzelił $goals razy. Jeden człowiek nie powinien musieć robić tyle sam.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Bez tego zawodnika ($name) mielibyśmy o $goals gole mniej i zupełnie inne popołudnie.';
  }

  @override
  String yWinStreak0(String count) {
    return 'Zwycięstwa z rzędu: $count. Cokolwiek mówi się w tej szatni, działa.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Już $count z rzędu. W takie serie nie wpada się przypadkiem.';
  }

  @override
  String yWinStreak2(String count) {
    return 'Seria trwa: $count z rzędu. Pewność siebie widać z trybun.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Bez porażki od $count meczów. Zapytaj każdego trenera: to jest najtrudniejsze.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count z rzędu. Cieszcie się, póki terminarz jest łaskawy.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count z rzędu, a nie pokonaliśmy nikogo, kto się liczy.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Seria: $count. Zapytaj mnie, kiedy przyjdzie prawdziwy test.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count z rzędu. Każda drużyna ma raz w życiu taką serię.';
  }

  @override
  String yLossStreak0(String count) {
    return 'Mecze bez zwycięstwa: $count. W końcu wymówki się skończą.';
  }

  @override
  String yLossStreak1(String count) {
    return 'Kolejne $count mecze w plecy. To już nie jest wypadek przy pracy.';
  }

  @override
  String yLossStreak2(String count) {
    return 'Porażki z rzędu: $count. Ktoś musi za to odpowiedzieć.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Bez zwycięstwa od $count meczów. Widać to po tym, jak grają.';
  }

  @override
  String yLossStreak4(String count) {
    return 'Mecze bez zwycięstwa: $count, i co tydzień te same błędy.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count z rzędu. Cokolwiek próbują, nie działa.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count z rzędu. To kierunek, a nie dołek.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Bez zwycięstwa od $count meczów, a na górze nikt nie powiedział ani słowa.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent, $score. Mówcie, co chcecie, o grze. Ten mecz liczy się podwójnie.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Akurat z nimi. $opponent. $score. Nikt tu tego nie zapomni.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score, rywal: $opponent. O tym będzie się gadać w pubach.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Derby z sąsiadem, $score. Kwestia, kto rządzi, załatwiona na jakiś czas.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent, $score. Cokolwiek jeszcze się wydarzy w tym roku, to zostanie.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score, rywal: $opponent. Niektórzy z nas potrzebowali tego bardziej niż tabela.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent, $score. Następnym razem się odegrają, zawsze się odgrywają.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return '$opponent, $score. Cały rok będą nam o tym przypominać.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name schodzi z kontuzją. Tego tej drużynie brakowało najmniej.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Bez zawodnika, jakim jest $name, wszystko wygląda inaczej.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name kuleje. Wstrzymajcie oddech.';
  }

  @override
  String yInjuryBlow3(String name) {
    return '$name wypada na jakiś czas. Ktoś musi wziąć to na siebie.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name poza grą. No jasne, że $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Bez niego ($name) to bardzo przeciętna drużyna.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name znowu kontuzjowany. Ktoś powinien zapytać dlaczego.';
  }

  @override
  String yInjuryBlow7(String name) {
    return '$name wypada, a za nim nie ma nikogo. To jest prawdziwy problem.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return '$name z czerwoną kartką w $minute. minucie i cały kraj się na niego rzuca. Dał nam więcej niż większość. Odpuśćcie.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name wyrzucony z boiska w $minute. minucie. Surowo. W dziesiątkę i wciąż próbowaliśmy, to coś mówi.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute. minuta, czerwona kartka. Od tej chwili w dziesiątkę.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Czerwona kartka: $name, $minute. minuta. Nie pierwszy mecz, który odwróciła jedna decyzja.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Wspaniale. $name wylatuje w $minute. minucie i gramy w dziesiątkę. Znowu.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name z czerwoną w $minute. minucie. Kto tu właściwie uczy dyscypliny?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minut. Tyle $name wytrzymał bez utraty głowy. Zawodowa piłka.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Czerwona dla zawodnika $name w $minute. minucie, a ja mam wierzyć, że to postęp.';
  }

  @override
  String get yBoardPressure0 =>
      'W zarządzie zrobiło się bardzo cicho. To nigdy nie jest dobry znak.';

  @override
  String get yBoardPressure1 => 'Podobno w gabinetach zaczęto zadawać pytania.';

  @override
  String get yBoardPressure2 => 'Czuć, że na górze grunt zaczyna się ruszać.';

  @override
  String get yBoardPressure3 =>
      'Nikt w federacji nie mówi nic wspierającego. Wyciągnijcie wnioski.';

  @override
  String get yBoardPressure4 =>
      'Od tygodni nikt na górze nie stanął za nim publicznie.';

  @override
  String get yBoardPressure5 =>
      'Federacja podkopuje własnego selekcjonera. Jak zawsze.';

  @override
  String get yBoardPressure6 => 'Kiedy zarząd milknie, decyzja już zapadła.';

  @override
  String get yBoardPressure7 =>
      'Będą to przeciągać, aż decyzję podejmie ktoś inny.';

  @override
  String get yReplies => 'TAKŻE O TYM MECZU';

  @override
  String get yPlayerGrievance0 =>
      'Zapytałem, na czym stoję. Wciąż czekam na odpowiedź.';

  @override
  String get yPlayerGrievance1 =>
      'Ciężko trenuję. Niewiele więcej mogę zrobić.';

  @override
  String get yPlayerGrievance2 => 'Niektóre pytania można zadać tylko raz.';

  @override
  String get yPlayerGrievance3 =>
      'Nie zaszedłem tak daleko, żeby nosić znaczniki.';

  @override
  String get playerHonoursTitle => 'WYRÓŻNIENIA';

  @override
  String get awardGoldenBall => 'Złota Piłka';

  @override
  String get awardGoldenBoot => 'Złoty But';

  @override
  String get awardGoldenGlove => 'Złota Rękawica';

  @override
  String get awardTeamOfTournament => 'Jedenastka turnieju';

  @override
  String get awardPlayerOfYear => 'Piłkarz Roku na świecie';

  @override
  String get awardYoungPlayerOfYear => 'Młody Piłkarz Roku';

  @override
  String get playerClubHistory => 'HISTORIA KLUBOWA';

  @override
  String get playerCareerRecord => 'BILANS KARIERY';

  @override
  String get playerInternationalGoals => 'Gole w reprezentacji';

  @override
  String get playerRecentForm => 'OSTATNIA FORMA';

  @override
  String get playerMatchHistory => 'HISTORIA MECZÓW';

  @override
  String get playerAttributes => 'ATRYBUTY';

  @override
  String get playerUnknown => 'Nieznane';

  @override
  String get playerAttrPace => 'Szybkość';

  @override
  String get playerAttrPhysical => 'Fizyczność';

  @override
  String get playerAttrTechnical => 'Technika';

  @override
  String get playerAttrShooting => 'Strzał';

  @override
  String get playerAttrPassing => 'Podania';

  @override
  String get playerAttrDribbling => 'Drybling';

  @override
  String get playerAttrTackling => 'Odbiór';

  @override
  String get playerAttrPositioning => 'Ustawianie się';

  @override
  String get playerAttrComposure => 'Opanowanie';

  @override
  String get playerAttrDecisions => 'Decyzje';

  @override
  String get playerAttrStamina => 'Wytrzymałość';

  @override
  String get playerAttrStrength => 'Siła';

  @override
  String get playerStatCaps => 'Występy';

  @override
  String get playerStatGoals => 'Gole';

  @override
  String get playerStatAssists => 'Asysty';

  @override
  String get playerStatAvgRating => 'Śr. ocena';

  @override
  String get playerStatForm => 'Forma';

  @override
  String get playerStatMotm => 'Zawodnik meczu';

  @override
  String get playerStatCleanSheets => 'Czyste konta';

  @override
  String get playerStatBestGame => 'Najlepszy mecz';

  @override
  String get playerStatCards => 'Kartki';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '$yellowsŻ ${reds}C';
  }

  @override
  String get tourSharedYourRun => 'TWOJA DROGA';

  @override
  String get tourSharedList => 'Lista';

  @override
  String get tourSharedBracket => 'Drabinka';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Grupa $seed';
  }

  @override
  String get tourSharedThisEdition => 'Ta edycja';

  @override
  String get tourSharedAllTime => 'Wszech czasów';

  @override
  String get tourSharedUnknown => 'Nieznany';

  @override
  String get tourSharedActive => 'AKTYWNY';

  @override
  String get tourSharedMedalTable => 'KLASYFIKACJA MEDALOWA';

  @override
  String get tourSharedPastWinners => 'DAWNI ZWYCIĘZCY';

  @override
  String tourSharedHost(String host) {
    return 'Gospodarz: $host';
  }

  @override
  String get tourSharedBeat => 'pokonał';

  @override
  String get tourSharedPens => ' (k.)';

  @override
  String get tourSharedAwardsEmpty =>
      'Nagrody zostaną przyznane po rozegraniu turnieju.';

  @override
  String get tourSharedGoldenBall => 'ZŁOTA PIŁKA';

  @override
  String get tourSharedPlayerOfTournament => 'Zawodnik turnieju';

  @override
  String get tourSharedGoldenBoot => 'ZŁOTY BUT';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gola',
      many: '$count goli',
      few: '$count gole',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'ZŁOTA RĘKAWICA';

  @override
  String get tourSharedTeamOfTournament => 'JEDENASTKA TURNIEJU';

  @override
  String get tourSharedStatsEmpty =>
      'Rekordy pojawią się, gdy rozgrywki nabiorą historii.';

  @override
  String get tourSharedRecordScorer => 'REKORDZISTA STRZELECKI';

  @override
  String get tourSharedStillActive => 'wciąż gra';

  @override
  String get tourSharedMostTitles => 'NAJWIĘCEJ TYTUŁÓW';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tytułu',
      many: '$count tytułów',
      few: '$count tytuły',
      one: '1 tytuł',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'NAJWIĘCEJ FINAŁÓW';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozegranego finału',
      many: '$count rozegranych finałów',
      few: '$count rozegrane finały',
      one: '1 rozegrany finał',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'NAJWIĘCEJ MECZÓW';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meczu',
      many: '$count meczów',
      few: '$count mecze',
      one: '1 mecz',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'NAJWIĘCEJ TURNIEJÓW FINAŁOWYCH';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnieju finałowego',
      many: '$count turniejów finałowych',
      few: '$count turnieje finałowe',
      one: '1 turniej finałowy',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'NAJWYŻSZE ZWYCIĘSTWO W FINALE';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gola',
      many: '$count goli',
      few: '$count gole',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'wciąż gra';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tytułu',
      many: '$count tytułów',
      few: '$count tytuły',
      one: '1 tytuł',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rozegranego finału',
      many: '$count rozegranych finałów',
      few: '$count rozegrane finały',
      one: '1 rozegrany finał',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meczu',
      many: '$count meczów',
      few: '$count mecze',
      one: '1 mecz',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnieju finałowego',
      many: '$count turniejów finałowych',
      few: '$count turnieje finałowe',
      one: '1 turniej finałowy',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'LIDERZY WSZECH CZASÓW';

  @override
  String get tourStatsTabGames => 'Mecze';

  @override
  String get tourStatsTabCups => 'Turnieje';

  @override
  String get tourStatsTabScorers => 'Strzelcy';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'rywal: $opponent · $year';
  }

  @override
  String get tourHolders => 'OBROŃCA TYTUŁU';

  @override
  String tourHoldersSince(int year) {
    return 'zwycięzca z $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'STRZELCY WSZECH CZASÓW';

  @override
  String get tourSharedSummaryEmpty =>
      'Gospodarz i stadiony pojawią się po losowaniu tej edycji.';

  @override
  String get tourSharedHostHeading => 'GOSPODARZ';

  @override
  String get tourSharedHostsHeading => 'GOSPODARZE';

  @override
  String get tourSharedCoHostsHeading => 'WSPÓŁGOSPODARZE';

  @override
  String get tourSharedVenues => 'STADIONY';

  @override
  String get tourSharedMascot => 'MASKOTKA';

  @override
  String get tourSharedMatchBall => 'PIŁKA MECZOWA';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · miejsca: $capacity';
  }

  @override
  String get tourSharedCouldNotLoad => 'Nie udało się wczytać.';

  @override
  String get tourSharedHostTbc => 'GOSPODARZ DO USTALENIA';

  @override
  String get tourSharedFinalsAreHere => 'CZAS NA TURNIEJ FINAŁOWY';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'GOSPODARZ:  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Niech turniej się zacznie';

  @override
  String get tourSharedCompetitions => 'ROZGRYWKI';

  @override
  String get tourSharedWorldRanking => 'Ranking światowy';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Nie udało się wczytać turniejów.';

  @override
  String get tourSharedPrestigeStage => 'PRESTIŻOWA SCENA';

  @override
  String get tourSharedOverview => 'Przegląd';

  @override
  String get tourSharedWorldRankingTitle => 'Ranking światowy';

  @override
  String get tourSharedYourCompetitions => 'TWOJE ROZGRYWKI';

  @override
  String get tourSharedOtherContinents => 'INNE KONTYNENTY';

  @override
  String get tourSharedComingSoon => 'Turniej już wkrótce';

  @override
  String get tourSharedSoon => 'WKRÓTCE';

  @override
  String get tourSharedNoQualifyingDraw => 'Brak losowania eliminacji.';

  @override
  String get tourSharedOpenEnvelope => 'Otwórz kopertę';

  @override
  String tourSharedGroupName(String name) {
    return 'GRUPA $name';
  }

  @override
  String get tourSharedBall => 'Kula';

  @override
  String get tourSharedPot => 'Koszyk';

  @override
  String get tourSharedAll => 'Wszystko';

  @override
  String get tourSharedTapDrawTeam => 'Dotknij, by wylosować kolejną drużynę';

  @override
  String get tourSharedTapDrawPot => 'Dotknij, by wylosować kolejny koszyk';

  @override
  String get tourSharedTapDrawAll => 'Dotknij, by odsłonić całe losowanie';

  @override
  String get tourSharedContinue => 'Dalej';

  @override
  String get tourSharedPause => 'Pauza';

  @override
  String get tourSharedPlay => 'Odtwórz';

  @override
  String get tourSharedSkip => 'Pomiń';

  @override
  String tourSharedPotNumber(int number) {
    return 'KOSZYK $number';
  }

  @override
  String get tourSharedDrawComplete => 'LOSOWANIE ZAKOŃCZONE';

  @override
  String get tourSharedDrawing => 'LOSOWANIE…';

  @override
  String get tourContChampionship => 'MISTRZOSTWA';

  @override
  String get tourContTabSummary => 'PODSUMOWANIE';

  @override
  String get tourContTabQualifying => 'ELIMINACJE';

  @override
  String get tourContTabFinals => 'TURNIEJ';

  @override
  String get tourContTabBracket => 'DRABINKA';

  @override
  String get tourContTabAwards => 'NAGRODY';

  @override
  String get tourContTabScorers => 'STRZELCY';

  @override
  String get tourContTabHistory => 'HISTORIA';

  @override
  String get tourContTabRecords => 'REKORDY';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Nie udało się wczytać turnieju.\n$error';
  }

  @override
  String get tourContNoCupData => 'Brak danych turnieju.';

  @override
  String get tourContUnknown => 'Nieznane';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Grupy eliminacyjne zostaną rozlosowane podczas ceremonii. Obejrzyj ją z centrum, by poznać rywali.';

  @override
  String get tourContQualSeeded =>
      'Twoja reprezentacja ma zapewniony udział w turnieju finałowym. W tym cyklu bez eliminacji.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name: symulowane w tle. Wyniki pojawią się tutaj po każdej rundzie.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Grupy turnieju finałowego zostaną rozlosowane podczas ceremonii. Obejrzyj ją z centrum, by poznać swoją grupę.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Losowanie turnieju finałowego odbędzie się po zakończeniu eliminacji.';

  @override
  String get tourContContestedBeforeWc =>
      'Faza pucharowa zostanie rozegrana przed Mistrzostwami Świata.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name: MISTRZOWIE';
  }

  @override
  String tourContWinnersTitle(String name) {
    return '$name: zwycięzcy';
  }

  @override
  String get tourContNoGoalsYet => 'Nie padły jeszcze żadne gole.';

  @override
  String tourContGroupHeading(String name) {
    return 'GRUPA $name';
  }

  @override
  String get tourContBestRunnersUp => 'NAJLEPSZE DRUGIE DRUŻYNY';

  @override
  String tourContGroupDropdown(String name) {
    return 'Grupa $name';
  }

  @override
  String get tourContMatches => 'MECZE';

  @override
  String get tourContNoGroupsDrawn => 'Grupy nie zostały jeszcze rozlosowane.';

  @override
  String get tourContQualifyingDraw => 'LOSOWANIE ELIMINACJI';

  @override
  String get tourContWorldQualifyingDraw => 'LOSOWANIE ELIMINACJI MŚ';

  @override
  String get tourContFinalsDraw => 'LOSOWANIE TURNIEJU';

  @override
  String get tourContSeedingPots => 'KOSZYKI';

  @override
  String get tourContGroupDraw => 'LOSOWANIE GRUP';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Nie udało się wczytać losowania.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Losowanie nie jest jeszcze gotowe.';

  @override
  String get tourContContinentalClash => 'STARCIE KONTYNENTÓW';

  @override
  String get tourContTabThisCycle => 'TEN CYKL';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Nie udało się wczytać.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Nie znaleziono zapisu.';

  @override
  String get tourContClashSoon =>
      'Starcie Kontynentów rozgrywa się, gdy znani są obaj mistrzowie kontynentów.';

  @override
  String get tourContTwoContinentsOneMatch => 'DWA KONTYNENTY, JEDEN MECZ';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name wygrywa Starcie';
  }

  @override
  String get tourContNoClashYet => 'Nie rozegrano jeszcze Starcia Kontynentów.';

  @override
  String get tourContNationsCup => 'PUCHAR NARODÓW';

  @override
  String get tourContTabLeagues => 'DYWIZJE';

  @override
  String get tourContTabFinalsFour => 'FINAŁ CZTERECH';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Nie udało się wczytać.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals => 'Brak goli w Pucharze Narodów.';

  @override
  String get tourContNoNationsCupChampions =>
      'Puchar Narodów nie ma jeszcze zwycięzcy.';

  @override
  String get tourContNationsCupOffSeason =>
      'Puchar Narodów w tym cyklu rusza po turnieju kontynentalnym. Dawni zwycięzcy są w zakładce Historia.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Grupy Pucharu Narodów w tym cyklu zostaną rozlosowane podczas ceremonii. Obejrzyj ją z centrum, by poznać rywali.';

  @override
  String get tourContLeagueNoGroups =>
      'W tej dywizji nie ma meczów w tej rundzie.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'DYWIZJA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'DYWIZJA $letter · TWOJA';
  }

  @override
  String get tourContFinalsFourSoon =>
      'W Finale Czterech zagrają zwycięzcy grup Dywizji A po zakończeniu fazy grupowej.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Dywizja $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Dywizja $letter ★';
  }

  @override
  String get tourContSemiFinals => 'PÓŁFINAŁY';

  @override
  String get tourContFinal => 'FINAŁ';

  @override
  String get tourContNationsCupDraw => 'LOSOWANIE PUCHARU NARODÓW';

  @override
  String get tourContIntercontinentalPlayoff => 'BARAŻ INTERKONTYNENTALNY';

  @override
  String get tourContNoPlayoffThisCycle => 'W tym cyklu nie ma barażu.';

  @override
  String get tourContPlayoffIntro =>
      'Dwa miejsca na Mistrzostwach Świata rozstrzygane w fazie pucharowej najlepszych drużyn, którym zabrakło awansu w eliminacjach.';

  @override
  String get tourContPlayoffThrough =>
      'Przeszedłeś przez baraż. Jedziesz na Mistrzostwa Świata!';

  @override
  String get tourContPlayoffOut =>
      'Zabrakło ci w barażu. Tym razem bez Mistrzostw Świata.';

  @override
  String get tourContContinue => 'Dalej';

  @override
  String get tourContPlayoffFinals => 'FINAŁY BARAŻU';

  @override
  String get tourContPlayoffSeeded => 'Rozstawiony (wolny los)';

  @override
  String get tourCupTabSummary => 'PODSUMOWANIE';

  @override
  String get tourCupTabQualifying => 'ELIMINACJE';

  @override
  String get tourCupTabPlayoff => 'BARAŻ';

  @override
  String get tourCupPlayoffSoon =>
      'Baraż interkontynentalny rozstrzyga się po zakończeniu eliminacji we wszystkich konfederacjach.';

  @override
  String get tourCupTabFinals => 'TURNIEJ';

  @override
  String get tourCupTabBracket => 'DRABINKA';

  @override
  String get tourCupTabAwards => 'NAGRODY';

  @override
  String get tourCupTabScorers => 'STRZELCY';

  @override
  String get tourCupTabHistory => 'HISTORIA';

  @override
  String get tourCupTabRecords => 'REKORDY';

  @override
  String get tourCupTitle => 'MISTRZOSTWA ŚWIATA';

  @override
  String get tourCupNoData => 'Brak danych turnieju.';

  @override
  String tourCupLoadError(String error) {
    return 'Nie udało się wczytać turnieju.\n$error';
  }

  @override
  String get tourCupUnknown => 'Nieznane';

  @override
  String get tourCupWorldChampions => 'MISTRZOWIE ŚWIATA';

  @override
  String get tourCupWorldChampionsTitle => 'Mistrzowie świata';

  @override
  String get tourCupStillActive => 'Wciąż gra';

  @override
  String get tourCupAllTimeScorers => 'STRZELCY WSZECH CZASÓW';

  @override
  String get tourCupAllConfederations => 'Wszystkie konfederacje';

  @override
  String get tourCupBestRunnersUp => 'Najlepsze drugie drużyny';

  @override
  String get tourCupCompWorld => 'Mistrzostwa Świata';

  @override
  String get tourCupCompEurope => 'Mistrzostwa Europy';

  @override
  String get tourCupCompSAmerica => 'Puchar Ameryki Południowej';

  @override
  String get tourCupDestRoundOf16 => '1/8 finału';

  @override
  String get tourCupDestKnockouts => 'fazy pucharowej';

  @override
  String get tourCupDestFinals => 'turnieju finałowego';

  @override
  String get tourCupDestFinalsPlayoff => 'baraży o turniej finałowy';

  @override
  String get tourCupDestIntercontPlayoff => 'baraży interkontynentalnych';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Losowanie turnieju finałowego po zakończeniu eliminacji.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Grupy nie zostały jeszcze rozlosowane. Obejrzyj losowanie Mistrzostw Świata z centrum, by je poznać.';

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
    return 'Gospodarz: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Gospodarze: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Baraż interkontynentalny';

  @override
  String get tourCupKnockoutSoon =>
      'Drabinka ruszy po zakończeniu fazy grupowej.';

  @override
  String get tourCupMatches => 'MECZE';

  @override
  String get tourCupMedalTable => 'KLASYFIKACJA MEDALOWA';

  @override
  String get tourCupMostTitles => 'NAJWIĘCEJ TYTUŁÓW';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: tytuły $titles, edycje $editions';
  }

  @override
  String get tourCupNoGoals => 'Brak goli.';

  @override
  String get tourCupNoGroups => 'Grupy nie zostały rozlosowane.';

  @override
  String get tourCupNoHistory => 'Brak historii.';

  @override
  String get tourCupPastWinners => 'DAWNI ZWYCIĘZCY';

  @override
  String get tourCupPlayoffIntro =>
      'Dwa miejsca na Mistrzostwach Świata rozstrzygane w fazie pucharowej najlepszych drużyn, którym zabrakło awansu w eliminacjach.';

  @override
  String get tourCupQualDrawSoon =>
      'Grupy nie zostały jeszcze rozlosowane. Obejrzyj losowanie eliminacji z centrum, by je poznać.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · twój';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (k.)';
  }

  @override
  String get tourCupSegAllTime => 'Wszech czasów';

  @override
  String get tourCupSegFinals => 'Turniej';

  @override
  String get tourCupSegQualifying => 'Eliminacje';

  @override
  String get playerTraitsTitle => 'ZNANY Z';

  @override
  String get traitBigGame => 'Gracz na wielkie mecze';

  @override
  String get traitBigGameBlurb => 'Wznosi się na wyżyny w meczach pucharowych.';

  @override
  String get traitSetPiece => 'Specjalista od stałych fragmentów';

  @override
  String get traitSetPieceBlurb =>
      'Lepsze dośrodkowania i więcej goli ze stałych fragmentów.';

  @override
  String get traitHothead => 'Narwaniec';

  @override
  String get traitHotheadBlurb =>
      'Zbiera dużo więcej kartek niż koledzy z drużyny.';

  @override
  String get traitIronMan => 'Człowiek z żelaza';

  @override
  String get traitIronManBlurb => 'Rzadko łapie urazy i wolniej się męczy.';

  @override
  String get traitWonderkid => 'Cudowne dziecko';

  @override
  String get traitWonderkidBlurb =>
      'Młody, już dobry i wciąż szybko się rozwija.';

  @override
  String get traitLeader => 'Lider';

  @override
  String get traitLeaderBlurb => 'Podnosi poziom każdego kolegi na boisku.';

  @override
  String get traitPacey => 'Szybki';

  @override
  String get traitPaceyBlurb =>
      'Piorunująca szybkość, groźny za plecami obrońców.';

  @override
  String get traitOldHead => 'Stary wyga';

  @override
  String get traitOldHeadBlurb =>
      'Weteran, którego czytanie gry trzyma się dłużej niż nogi.';

  @override
  String get traitWasteful => 'Marnotrawny';

  @override
  String get traitWastefulBlurb => 'Pudłuje zbyt wiele dobrych okazji.';

  @override
  String get objectiveWorldCup => 'Mistrzostwa Świata';

  @override
  String get objectiveWinTournament => 'Wygraj turniej';

  @override
  String get objectiveQualifyGeneric => 'Awansuj';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Wygraj Mistrzostwa Świata';

  @override
  String get objectiveReachFinal => 'Dojdź do finału';

  @override
  String get objectiveReachSemis => 'Dojdź do półfinału';

  @override
  String get objectiveReachQuarters => 'Dojdź do ćwierćfinału';

  @override
  String get objectiveReachKnockouts => 'Wyjdź z grupy';

  @override
  String get objectiveQualify => 'Awansuj na Mistrzostwa Świata';

  @override
  String get finishChampions => 'Mistrzostwo';

  @override
  String get finishRunnersUp => 'Wicemistrzostwo';

  @override
  String get finishSemiFinals => 'Półfinał';

  @override
  String get finishQuarterFinals => 'Ćwierćfinał';

  @override
  String get finishRoundOf16 => '1/8 finału';

  @override
  String get finishGroupStage => 'Faza grupowa';

  @override
  String get objectiveQualifyingTopHalf =>
      'Zakończ eliminacje w górnej połowie tabeli';

  @override
  String get finishQualifyingTopHalf => 'Górna połowa grupy eliminacyjnej';

  @override
  String get finishQualifyingBottomHalf => 'Dolna połowa grupy eliminacyjnej';

  @override
  String get objectiveNcWinIt => 'Wygraj Puchar Narodów';

  @override
  String get objectiveNcReachFinal => 'Dojdź do finału Pucharu Narodów';

  @override
  String get objectiveNcFinalsFour => 'Awansuj do Finału Czterech';

  @override
  String get objectiveNcWinGroup => 'Wygraj grupę i awansuj';

  @override
  String get objectiveNcTopHalf => 'Zakończ w górnej połowie grupy';

  @override
  String get objectiveNcSurvive => 'Unikaj spadku';

  @override
  String get finishNcChampions => 'Zdobywcy Pucharu Narodów';

  @override
  String get finishNcFinalsFour => 'Finał Czterech';

  @override
  String get finishNcGroupWinners => 'Zwycięzcy grupy';

  @override
  String get finishNcTopHalf => 'Górna połowa grupy';

  @override
  String get finishNcStayedUp => 'Utrzymanie';

  @override
  String get finishNcBottom => 'Ostatnie miejsce w grupie';

  @override
  String get careerNationsCupLabel => 'Puchar Narodów';

  @override
  String get squadDevPlayer => 'ZAWODNIK';

  @override
  String get squadDevAge => 'WIEK';

  @override
  String get squadDevPosition => 'POZ';

  @override
  String get squadDevChange => 'OCENA';

  @override
  String get squadDevNew => 'NOWY';

  @override
  String get squadDevRetired => 'KONIEC KARIERY';

  @override
  String get squadDevEmpty => 'Spokojny rok. Żadnych zmian w kadrze.';

  @override
  String get squadDevTierRegulars => 'STALI BYWALCY';

  @override
  String get squadDevTierFringe => 'NA OBRZEŻACH';

  @override
  String get squadDevTierYouth => 'MŁODZIEŻ';

  @override
  String get boardObjectivesTitle => 'Cele zarządu';

  @override
  String get boardObjectivesConfidence => 'Zaufanie zarządu';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'o $rounds rundy lepiej niż oczekiwano',
      many: 'o $rounds rund lepiej niż oczekiwano',
      few: 'o $rounds rundy lepiej niż oczekiwano',
      one: 'o rundę lepiej niż oczekiwano',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'zabrakło $rounds rundy',
      many: 'zabrakło $rounds rund',
      few: 'zabrakło $rounds rund',
      one: 'zabrakło jednej rundy',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'JESZCZE NIEROZSTRZYGNIĘTE';

  @override
  String boardObjectiveSoFar(String result) {
    return 'NA RAZIE · $result';
  }

  @override
  String get boardObjectivesEmpty => 'Zarząd nie wyznaczył celu na ten cykl.';

  @override
  String get tourContBestWinners => 'NAJLEPSI ZWYCIĘZCY GRUP';

  @override
  String get tourContBestThirds => 'NAJLEPSZE TRZECIE DRUŻYNY';

  @override
  String tourContBestPlaced(String position) {
    return 'NAJLEPSZE DRUŻYNY Z $position. MIEJSC';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · zawodnicy: $total';
  }

  @override
  String get matchSoldOut => 'KOMPLET WIDZÓW';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return 'Zajęte miejsca: $attendance z $capacity';
  }

  @override
  String get matchGroundTitle => 'STADION';

  @override
  String get absenceInjured => 'Kontuzja';

  @override
  String get absenceSuspended => 'Zawieszony';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString tygodnia',
      many: '$countString tygodni',
      few: '$countString tygodnie',
      one: '1 tydzień',
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
      other: '$countString meczu',
      many: '$countString meczów',
      few: '$countString mecze',
      one: '1 mecz',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Wraca na mecz z rywalem: $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Rzuty karne';

  @override
  String get penaltyOrderBlurb =>
      'Wyznacz pięciu wykonawców w kolejności. Dotknij pola, by je zmienić.';

  @override
  String penaltyOrderPick(int number) {
    return 'Rzut $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Wybierz, kto podejdzie do piłki. Pasek pokazuje opanowanie przy rzutach karnych.';

  @override
  String get penaltyOrderConfirm => 'Do dzieła';

  @override
  String get penaltyOrderCancel => 'Wstecz';

  @override
  String get youthTitle => 'Młodzież';

  @override
  String get youthEmptyLevel => 'Na tym poziomie nikogo jeszcze nie ma.';

  @override
  String get youthReleased => 'Zwolnieni w tym roku';

  @override
  String get u21Title => 'U-21';

  @override
  String get u21Blurb =>
      'Następne pokolenie, od największego talentu. Puste gwiazdki to szacunek skautów. Daj zawodnikowi zadebiutować, by poznać jego prawdziwą wartość.';

  @override
  String get u21Empty =>
      'W puli nie ma teraz nikogo poniżej 21 lat. Kolejny nabór przyjdzie z nowym cyklem.';

  @override
  String u21Breakout(int gain) {
    return '+$gain W TYM ROKU';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Wiek $age · występy: $caps';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Wiek $age · bez debiutu';
  }

  @override
  String get u21CallUps => 'Przejdź do powołań';

  @override
  String get youthWatching => 'Obserwowani';

  @override
  String get youthWatchEmpty =>
      'Nikogo jeszcze nie oznaczono. Oznacz chłopaka na dowolnym poziomie, a pojawi się tutaj z informacją, kim od tego czasu się stał.';

  @override
  String get youthWatchMark => 'Obserwuj tego chłopaka';

  @override
  String get youthWatchUnmark => 'Przestań go obserwować';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Oznaczony z oceną $rating, w wieku $age lat';
  }

  @override
  String get youthWatchSenior => 'Przeszedł do seniorów';

  @override
  String get youthWatchReleased => 'Zwolniony przez akademię';

  @override
  String get youthWatchGone => 'Już poza piramidą';

  @override
  String get tacticsYouth => 'U-21';

  @override
  String get pressSquad => 'Kadra';

  @override
  String get pressBoard => 'Zarząd';

  @override
  String get pressNoEffect => 'Nikt nie przywiązuje do tego wagi';

  @override
  String get matchNeutralGround => 'NEUTRALNY';

  @override
  String get matchExtraTimeAhead => 'DOGRYWKA';

  @override
  String get matchExtraTimeHalf => 'DOGRYWKA · PRZERWA';

  @override
  String get matchClockFullTime => 'KONIEC';

  @override
  String get matchClockAfterExtraTime => 'PO DOGRYWCE';

  @override
  String get matchClockPenalties => 'RZUTY KARNE';

  @override
  String get matchClockFullTimePenalties => 'KONIEC · KARNE';

  @override
  String get hubEventPressConference => 'Stań przed mediami';

  @override
  String get hubEventPressConferenceSub =>
      'Media z całego świata chcą porozmawiać przed twoim pierwszym meczem';

  @override
  String get squadDevWonderkid => 'CUDOWNE DZIECKO';

  @override
  String get tacticsPlaystyle => 'Styl gry';

  @override
  String get tacticsPlaystyleBlurb =>
      'Wybierz, jak gra drużyna. Pokrętła poniżej to dopracują.';

  @override
  String get tacticsPlaystyleCustom =>
      'Twoje własne ustawienia. Żaden nazwany styl do nich nie pasuje.';

  @override
  String get playstyleCustom => 'Własny';

  @override
  String get playstyleBalanced => 'Zrównoważony';

  @override
  String get playstylePossession => 'Posiadanie piłki';

  @override
  String get playstyleGegenpress => 'Gegenpressing';

  @override
  String get playstyleCounter => 'Kontratak';

  @override
  String get playstyleDirect => 'Bezpośredni';

  @override
  String get playstyleLowBlock => 'Niski blok';

  @override
  String get playstyleWingPlay => 'Gra skrzydłami';

  @override
  String get playstyleBalancedBlurb =>
      'Solidnie w obu połowach, bez przesady w niczym.';

  @override
  String get playstylePossessionBlurb =>
      'Trzymaj piłkę, rozgrywaj cierpliwie, zamykaj boisko.';

  @override
  String get playstyleGegenpressBlurb =>
      'Odbierz piłkę od razu po stracie, wysoko na połowie rywala.';

  @override
  String get playstyleCounterBlurb =>
      'Cofnij się, trzymaj zwartość, a potem kontruj z prędkością.';

  @override
  String get playstyleDirectBlurb => 'Szybko do przodu i walka o drugą piłkę.';

  @override
  String get playstyleLowBlockBlurb =>
      'Głęboko, wąsko i bardzo trudno do sforsowania.';

  @override
  String get playstyleWingPlayBlurb =>
      'Rozciągnij boisko, obiegaj bokami i dośrodkowuj.';

  @override
  String get nationsRandomTeam => 'Losowa drużyna';

  @override
  String get nationsFromTheBottom => 'Od zera';

  @override
  String get bottomStartTitle => 'Bez pracy';

  @override
  String get bottomStartHeading => 'Trzy federacje chcą rozmawiać';

  @override
  String get bottomStartBlurb =>
      'Nie masz posady ani reputacji. Tylko te drużyny chcą zaryzykować. Wybierz jedną i zbuduj coś z niczego.';

  @override
  String get bottomStartAccept => 'Biorę';

  @override
  String get bottomStartBack => 'Wróć do menu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank. miejsce na świecie (z $total)';
  }

  @override
  String get campTitle => 'Baza';

  @override
  String campBasedIn(String host) {
    return 'Baza w kraju: $host';
  }

  @override
  String get campBlurb =>
      'Tu kadra mieszka przez cały turniej. Po starcie nie można tego zmienić, a baza wpływa na trzy rzeczy w każdym meczu: świeżość zawodników, szybkość leczenia urazów i ostrość.';

  @override
  String get campEffectTravel => 'Świeżość';

  @override
  String get campEffectRecovery => 'Leczenie urazów';

  @override
  String get campEffectSharpness => 'Ostrość meczowa';

  @override
  String get campTerrainCity => 'Centrum miasta';

  @override
  String get campTerrainCoastal => 'Kurort nadmorski';

  @override
  String get campTerrainMountain => 'Górska kryjówka';

  @override
  String get campTerrainAltitude => 'Obóz wysokogórski';

  @override
  String get campTerrainNationalCentre => 'Ośrodek narodowy';

  @override
  String get campTerrainCityBlurb =>
      'Wszystko pod ręką i nigdzie nie trzeba jeździć, ale ani chwili spokoju i ucieczki od hałasu.';

  @override
  String get campTerrainCoastalBlurb =>
      'Spokojnie, wygodnie i dobrze dla nastrojów. Długa jazda autokarem na każdy stadion.';

  @override
  String get campTerrainMountainBlurb =>
      'Chłodne powietrze i pierwszorzędne zaplecze medyczne, które szybko stawia na nogi, daleko od turnieju.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Ciężko się trenuje, ale nogi wytrzymują do późnych faz turnieju.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Własne obiekty federacji: nic spektakularnego, nic nie może pójść źle.';

  @override
  String get hubEventChooseCamp => 'Wybierz bazę';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Gdzie kadra zamieszka. Gospodarz: $host';
  }

  @override
  String get tacticsTabBench => 'Ławka';

  @override
  String get squadSearchHint => 'Szukaj po nazwisku lub klubie';

  @override
  String get squadFilterAll => 'Wszyscy';

  @override
  String get squadFilterInSquad => 'W kadrze';

  @override
  String get squadFilterUncapped => 'Bez debiutu';

  @override
  String get squadFilterUnavailable => 'Niedostępni';

  @override
  String get squadLineAll => 'Wszystkie formacje';

  @override
  String get squadSortBy => 'Sortuj';

  @override
  String get squadSortRating => 'Ocena';

  @override
  String get squadSortCaps => 'Występy';

  @override
  String get squadSortGoals => 'Gole';

  @override
  String get squadSortAge => 'Wiek';

  @override
  String get squadSortName => 'Nazwisko';

  @override
  String get squadLegendTitle => 'Co oznaczają symbole';

  @override
  String get squadLegendStarting => 'W wyjściowej jedenastce';

  @override
  String get squadLegendCalledUp => 'Powołany, na ławce';

  @override
  String get squadLegendRatingUp => 'Ocena rośnie w tym roku';

  @override
  String get squadLegendRatingDown => 'Ocena spada w tym roku';

  @override
  String get squadLegendInjured => 'Kontuzjowany, niedostępny';

  @override
  String get squadLegendSuspended => 'Zawieszony, niedostępny';

  @override
  String get squadLegendTraits => 'ZNANY Z';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Widoczni: $shown z $total';
  }

  @override
  String get squadNobodyMatches => 'Nikt w puli nie pasuje do tych filtrów.';

  @override
  String get squadStatPool => 'Pula';

  @override
  String get squadStatInSquad => 'Powołani';

  @override
  String get squadMostCapped => 'Najwięcej występów';

  @override
  String get squadTopScorer => 'Najlepszy strzelec';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · występy: $caps';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · gole: $goals';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Wyst.';

  @override
  String get squadGoalsShort => 'Gole';

  @override
  String get recordsRecordBookSubtitle =>
      'Występy, gole i najważniejsze rekordy drużyny';

  @override
  String get statsLegacy => 'DZIEDZICTWO';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name został już zmieniony i nie może wrócić na boisko.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name został wyrzucony z boiska i nie weźmie już udziału w grze.';
  }

  @override
  String get tacticsInjuredShort => 'URAZ';

  @override
  String get tacticsSuspendedShort => 'PAUZA';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'Ameryka Południowa';

  @override
  String get confNorthAmerica => 'Ameryka Północna';

  @override
  String get confAfrica => 'Afryka';

  @override
  String get confAsia => 'Azja';

  @override
  String get confOceania => 'Oceania';

  @override
  String get compWorldCup => 'Mistrzostwa Świata';

  @override
  String get compWorldCupFinals => 'Turniej finałowy MŚ';

  @override
  String get compWorldCupQualifying => 'Eliminacje Mistrzostw Świata';

  @override
  String compQualifiers(String region) {
    return 'Eliminacje: $region';
  }

  @override
  String get compFriendlies => 'Mecze towarzyskie';

  @override
  String get compNationsCup => 'Puchar Narodów';

  @override
  String get compContinentalClash => 'Starcie Kontynentów';

  @override
  String get compIntercontinentalPlayoff => 'Baraż interkontynentalny';

  @override
  String get compContinentalChampionship => 'Mistrzostwa kontynentu';

  @override
  String get compEuropeanChampionship => 'Mistrzostwa Europy';

  @override
  String get compSouthAmericaCup => 'Puchar Ameryki Południowej';

  @override
  String get compAfricanChampionship => 'Mistrzostwa Afryki';

  @override
  String get compAsianChampionship => 'Mistrzostwa Azji';

  @override
  String get compNorthAmericaCup => 'Puchar Ameryki Północnej';

  @override
  String get compOceaniaCup => 'Puchar Oceanii';

  @override
  String get msgANation => 'Pewien kraj';

  @override
  String get msgAPlayer => 'Pewien zawodnik';

  @override
  String get msgAHostNation => 'kraj gospodarz';

  @override
  String get msgCycleTitle1 => 'Nowy cykl się zaczyna';

  @override
  String msgCycleTitle2(int year) {
    return 'Droga do roku $year otwarta';
  }

  @override
  String get msgCycleTitle3 => 'Świta nowa kampania';

  @override
  String get msgCycleTitle4 => 'Z powrotem do pracy';

  @override
  String msgCycleBody1(int year) {
    return 'Tu zaczyna się droga na Mistrzostwa Świata $year.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Nowy cykl. Cel: Mistrzostwa Świata $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Cztery lata do Mistrzostw Świata $year. Praca zaczyna się teraz.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Kampania $year rusza dzisiaj.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup, gospodarz: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return 'Gospodarz kolejnej edycji ($cup): $host.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup: losowanie eliminacji';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return '$cup: grupy eliminacyjne zostały rozlosowane.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Gospodarz Mistrzostw Świata $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return 'Mistrzostwa Świata $year zorganizuje: $host.';
  }

  @override
  String get msgWcQualDrawTitle => 'Losowanie eliminacji Mistrzostw Świata';

  @override
  String get msgWcQualDrawBody =>
      'Grupy eliminacyjne Mistrzostw Świata zostały rozlosowane.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup: losowanie turnieju finałowego';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return '$cup: grupy turnieju finałowego zostały rozlosowane.';
  }

  @override
  String get msgWcFinalsDrawTitle =>
      'Losowanie turnieju finałowego Mistrzostw Świata';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Odbyło się losowanie turnieju finałowego Mistrzostw Świata $year.';
  }

  @override
  String get msgQualWcTitle1 => 'Awans na Mistrzostwa Świata';

  @override
  String get msgQualWcTitle2 => 'Mistrzostwa Świata zaklepane';

  @override
  String get msgQualWcTitle3 => 'Jedziemy na Mistrzostwa Świata';

  @override
  String get msgQualWcTitle4 => 'Bilet wywalczony';

  @override
  String msgQualWcBody1(int year) {
    return 'Awansowałeś do turnieju finałowego Mistrzostw Świata $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Oficjalnie: twoja reprezentacja zagra na Mistrzostwach Świata $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Miejsce na Mistrzostwach Świata $year zapewnione.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Jesteś w turnieju finałowym Mistrzostw Świata $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Awans: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup: miejsce zaklepane';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Awans wywalczony: $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Awansowałeś do turnieju finałowego. Rozgrywki: $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Twoja reprezentacja zapewniła sobie udział. Rozgrywki: $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Jesteś w turnieju: $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: MISTRZOWIE!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Mistrzowie! $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Wygrałeś $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: rozstrzygnięte';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: mistrz koronowany';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp: znamy zwycięzcę';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Twoja reprezentacja zwycięża: $comp $year. Pokonany rywal: $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Wygrałeś $comp $year. W finale pokonany: $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year należy do ciebie. Pokonany rywal: $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year: wygrywa $winner. Pokonany w finale: $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$comp $year: mistrzem zostaje $winner. Pokonany: $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ', wynik finału $home–$away';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ', po rzutach karnych, finał $home–$away';
  }

  @override
  String get msgWpotyTitle => 'Piłkarz Roku na świecie';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) Piłkarzem Roku $year na świecie. To twój zawodnik.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) Piłkarzem Roku $year na świecie.';
  }

  @override
  String get msgYpotTitle => 'Młody Zawodnik Turnieju';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), lat $age, Młodym Zawodnikiem Turnieju $year. To twój zawodnik.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), lat $age, Młodym Zawodnikiem Turnieju $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Utrzymujesz #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Bez zmian, wciąż #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabilnie na #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move miejsca',
      many: '$move miejsc',
      few: '$move miejsca',
      one: '1 miejsce',
    );
    return 'Łącznie w górę o $_temp0, na #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move miejsca',
      many: '$move miejsc',
      few: '$move miejsca',
      one: '1 miejsce',
    );
    return 'Awans o $_temp0 wynosi cię na #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move miejsca',
      many: '$move miejsc',
      few: '$move miejsca',
      one: '1 miejsce',
    );
    return 'W górę o $_temp0, teraz #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move miejsca',
      many: '$move miejsc',
      few: '$move miejsca',
      one: '1 miejsce',
    );
    return 'Łącznie w dół o $_temp0, na #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move miejsca',
      many: '$move miejsc',
      few: '$move miejsca',
      one: '1 miejsce',
    );
    return 'Spadek o $_temp0 spycha cię na #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move miejsca',
      many: '$move miejsc',
      few: '$move miejsca',
      one: '1 miejsce',
    );
    return 'W dół o $_temp0, teraz #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Jesteś numerem jeden na świecie.';

  @override
  String msgRankLeadOther(String nation) {
    return 'Numer jeden na świecie: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Ranking światowy · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Ranking światowy został zaktualizowany. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Awans na #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Spadek na #$rank';
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
      other: '$move miejsca',
      many: '$move miejsc',
      few: '$move miejsca',
      one: '1 miejsce',
    );
    return '$tournament zmienił ranking światowy. $nation: przed turniejem #$from, po turnieju #$to, awans o $_temp0.';
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
      other: '$move miejsca',
      many: '$move miejsc',
      few: '$move miejsca',
      one: '1 miejsce',
    );
    return '$tournament zmienił ranking światowy. $nation: przed turniejem #$from, po turnieju #$to, spadek o $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Od losowania Mistrzostw Świata';

  @override
  String get rankingSinceCycleStart => 'Od początku kampanii';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from na #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name: już $count występów';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name ma już na koncie $count występów w twojej reprezentacji.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name: już $count goli';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name strzelił już $count goli dla twojej reprezentacji.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Rozwój kadry · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Wychowankowie akademii · $year';
  }

  @override
  String get msgThroughNote =>
      'To nie jest nowy nabór. To chłopcy, którzy przyszli w wieku jedenastu lat i dorośli do puli seniorów.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Nowe twarze · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Inwestycje w akademię procentują: ten nabór jest mocniejszy, niż byłby bez nich.';

  @override
  String get msgIntakeNoteStanding =>
      'Kraj śledzi tę drużynę: reprezentacja pnie się w rankingu, najlepsi chłopcy wybierają piłkę, a ten nabór jest przez to mocniejszy.';

  @override
  String get msgIntakeNoteBoth =>
      'Widać i pieniądze na akademię, i awans reprezentacji w rankingu: ten nabór jest mocniejszy, niż byłby bez tego.';

  @override
  String msgIntakeTitle(int year) {
    return 'Nabór do akademii · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Twój kapitan kończy karierę: $name';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name kończy karierę reprezentacyjną';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name zakończył karierę reprezentacyjną w wieku $age lat.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name zakończył karierę reprezentacyjną w wieku $age lat. Dorobek: $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count występu',
      many: '$count występów',
      few: '$count występy',
      one: '1 występ',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gola',
      many: '$count goli',
      few: '$count gole',
      one: '1 gol',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Opaska kapitana jest wolna. Wyznacz nowego kapitana na ekranie powołań.';

  @override
  String msgHofTitle(String name) {
    return '$name w Galerii Sławy';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name trafia do Galerii Sławy twojej reprezentacji (występy: $caps, gole: $goals). Zobacz w Legendach.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name zawieszony';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'pauzuje w $matches kolejnych meczach',
      many: 'pauzuje w $matches kolejnych meczach',
      few: 'pauzuje w $matches kolejnych meczach',
      one: 'pauzuje w twoim następnym meczu',
    );
    return '$name $how i $_temp0. Nie będzie dostępny do wyboru.';
  }

  @override
  String get hubBanHowSecondYellow => 'wyleciał z boiska za drugą żółtą kartkę';

  @override
  String get hubBanHowViolent =>
      'dostał bezpośrednią czerwoną kartkę za brutalny faul';

  @override
  String get hubBanHowRed => 'wyleciał z boiska';

  @override
  String hubInjuryTitle(String name) {
    return '$name kontuzjowany';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches meczu',
      many: '$matches meczów',
      few: '$matches mecze',
      one: '1 mecz',
    );
    return '$name doznał urazu i opuści $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Wicemistrzowie';

  @override
  String get hubRunnerUpTitle2 => 'Tak blisko, a jednak tak daleko';

  @override
  String get hubRunnerUpTitle3 => 'Srebrne medale';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Doszedłeś do finału ($cup), ale lepszy okazał się rywal: $opponent. Tak blisko. Tym razem srebro.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Porażka w finale ($cup). Rywal: $opponent. Wicemistrzostwo, boleśnie blisko.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Finał ($cup) wymknął się z rąk. Rywal: $opponent. Jest z czego być dumnym, ale trofeum nie ma.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Odpadliśmy';

  @override
  String get hubKnockedOutTitle2 => 'Koniec drogi';

  @override
  String get hubKnockedOutTitle3 => 'Koniec podróży';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Odpadasz. Rozgrywki: $cup, etap: $stage. Lepszy rywal: $opponent.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent kończy twój udział ($cup). Etap: $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Twój turniej ($cup) kończy się na etapie: $stage. Lepszy rywal: $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Odpadnięcie w grupie';

  @override
  String get hubGroupExitTitle2 => 'Koniec w fazie grupowej';

  @override
  String get hubGroupExitTitle3 => 'Wcześnie pod prysznic';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Twój turniej ($cup) kończy się w fazie grupowej. Za mało, by wejść do fazy pucharowej.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Nie udało się wyjść z grupy. Twój turniej ($cup) kończy się tutaj.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Tym razem bez fazy pucharowej. Twój turniej ($cup) kończy się na grupie.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Cel osiągnięty: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Cel nieosiągnięty: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Cel zarządu ($comp): $demand. Twój wynik: $finish. Dostali to, czego chcieli.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Cel zarządu ($comp): $demand. Twój wynik: $finish. To poniżej oczekiwań.';
  }

  @override
  String get newsWcMissTitle => 'Koniec marzeń o Mistrzostwach Świata';

  @override
  String newsWcMissBody(int year) {
    return 'Nie awansowałeś na Mistrzostwa Świata $year. Eliminacje nie wyszły. Kolejne cztery lata.';
  }

  @override
  String get newsRecordScorerTitle => 'Najlepszy strzelec w historii';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name jest teraz najlepszym strzelcem w historii gry. Gole: $goals.';
  }

  @override
  String get newsRecordCapsTitle => 'Rekordzista występów';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name jest teraz rekordzistą występów w historii gry. Występy: $caps.';
  }

  @override
  String get newsARecordBreaker => 'Nowy rekordzista';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name przechodzi do klubu $club';
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
    return '$name ($position, $rating) odchodzi z klubu $fromClub. Nowy klub: $destination. Kwota: $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club ($country)';
  }

  @override
  String get newsTransferFree => 'Za darmo';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ $name gotów grać dla reprezentacji: $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name chce grać dla reprezentacji: $nation';
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
    return '$name, $age lat, pozycja: $position, ocena $rating, obecnie w kadrze kraju $fromNation. Ma rodzinne związki z krajem $nation i jest otwarty na zmianę barw. Otwórz ofertę naturalizacji, by ją przyjąć lub odrzucić.';
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
    return '$name, $age lat, pozycja: $position, ocena $rating, obecnie w kadrze kraju $fromNation. To gwiazda z rodzinnymi związkami z krajem $nation, otwarta na zmianę barw. Otwórz ofertę naturalizacji, by ją przyjąć lub odrzucić.';
  }

  @override
  String get newsTheirNation => 'jego kraj';

  @override
  String get newsYourNation => 'twój kraj';

  @override
  String get tourStatusChampions => 'MISTRZOWIE';

  @override
  String get tourStatusFinals => 'TURNIEJ';

  @override
  String get tourStatusQualifying => 'ELIMINACJE';

  @override
  String get tourStatusUpcoming => 'NADCHODZI';

  @override
  String get tourStatusInProgress => 'W TOKU';

  @override
  String get tourStatusComingSoon => 'WKRÓTCE';

  @override
  String get tourStatusDecided => 'ROZSTRZYGNIĘTE';

  @override
  String tourStatusLeague(String letter) {
    return 'DYWIZJA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'LOSOWANIE ELIMINACJI MŚ';

  @override
  String tourDrawContQualifying(String cup) {
    return '$cup: LOSOWANIE ELIMINACJI';
  }

  @override
  String get tourDrawWcHost => 'GOSPODARZ MISTRZOSTW ŚWIATA';

  @override
  String tourDrawContHost(String cup) {
    return '$cup: GOSPODARZ';
  }

  @override
  String get tourDrawHostsReveal => 'A gospodarzami będą…';

  @override
  String get tourDrawHostReveal => 'A gospodarzem będzie…';

  @override
  String get tourDrawHostCandidates => 'Kandydaci w grze:';

  @override
  String get tourKickoffContinentalCup => 'MISTRZOSTWA KONTYNENTU';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Bez awansu: $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Nie awansowałeś do turnieju ($cup). Tym razem kampania nie wyszła.';
  }

  @override
  String get potyLabelBest => 'Piłkarz Roku';

  @override
  String get potyLabelYoung => 'Młody Piłkarz Roku';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count asysty',
      many: '$count asyst',
      few: '$count asysty',
      one: '1 asysta',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Ocena $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Nota $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Piłkarz Roku $year na świecie';
  }

  @override
  String newsPotyBody(String name) {
    return '$name jest najlepszym piłkarzem świata w tym roku.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' Nagroda dla młodego piłkarza: $name.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Chłopcy, których obserwujesz, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: 'o $gain punktu',
      many: 'o $gain punktów',
      few: 'o $gain punkty',
      one: 'o punkt',
    );
    return '$name poszedł do przodu, ocena $rating, $_temp0 więcej niż rok temu.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name przechodzi do kategorii $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name debiutuje';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name zadebiutował w reprezentacji w wieku $age lat, z oceną $rating. To jeden z chłopców, których obserwujesz.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Posiadanie piłki, oceny zawodników i zawodnik meczu są ustalane po końcowym gwizdku.';

  @override
  String get matchPlayerRatings => 'OCENY ZAWODNIKÓW';

  @override
  String get matchSubstitutions => 'ZMIANY';

  @override
  String get matchSubstitutes => 'REZERWOWI';

  @override
  String get matchPlayerOfTheMatch => 'ZAWODNIK MECZU';

  @override
  String get matchGoalShout => 'GOL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'KARNE $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: TRAFIA';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: PUDŁUJE';
  }

  @override
  String get matchFeedKickOff => 'Początek meczu!';

  @override
  String get matchFeedNoEvents => 'Na razie brak zdarzeń.';

  @override
  String get tourVenues => 'STADIONY';

  @override
  String tourPot(int number) {
    return 'KOSZYK $number';
  }

  @override
  String get tourHostSelection => 'WYBÓR GOSPODARZA';

  @override
  String get tourCandidates => 'KANDYDACI';

  @override
  String get tourJointBid => 'WSPÓLNA KANDYDATURA';

  @override
  String get tourGoldenGlove => 'ZŁOTA RĘKAWICA';

  @override
  String get tourTeamOfTournament => 'JEDENASTKA TURNIEJU';

  @override
  String get tourYourRun => 'TWOJA DROGA';

  @override
  String get tourMedalTable => 'KLASYFIKACJA MEDALOWA';

  @override
  String tourHostLine(String nation) {
    return 'Gospodarz: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Gospodarze: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Grupa $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Rozstawienie według rankingu światowego. Znajdź swój kraj przed losowaniem.';

  @override
  String get tourWorldRanking => 'Ranking światowy';

  @override
  String get tourYourCompetitions => 'TWOJE ROZGRYWKI';

  @override
  String get tourOtherContinents => 'INNE KONTYNENTY';

  @override
  String get tourZoneGlobal => 'ŚWIAT';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'AM. PŁD.';

  @override
  String get tourZoneNorthAmerica => 'AM. PŁN.';

  @override
  String get tourZoneAfrica => 'AFRYKA';

  @override
  String get tourZoneAsia => 'AZJA';

  @override
  String get tourZoneOceania => 'OCEANIA';

  @override
  String get tourZoneIntercontinental => 'MIĘDZYKONTYNENTALNE';

  @override
  String tourZoneLeague(String league) {
    return 'DYWIZJA $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'GOSPODARZ:  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Awans do $destination: czołowe $count';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name odchodzi';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name zakończył karierę reprezentacyjną w wieku $age lat, z dorobkiem występów: $caps. Prosił o jasną odpowiedź, na czym stoi, nie dostał jej i nie zamierza dłużej czekać.';
  }

  @override
  String get pressHeadlineWent1 => 'Selekcjoner panuje nad salą';

  @override
  String get pressHeadlineWent2 => 'Przyszli po awanturę, dostali lidera';

  @override
  String get pressHeadlineWent3 => 'Konkretne odpowiedzi, które trafiły';

  @override
  String get pressHeadlineMixed1 => 'Dużo słów, mało konkretów';

  @override
  String get pressHeadlineMixed2 => 'Coś dla każdego i nic dla nikogo';

  @override
  String get pressHeadlineMixed3 =>
      'Konferencja, po której pytania zostały otwarte';

  @override
  String get pressHeadlineBadly1 => 'Bolesne popołudnie przed kamerami';

  @override
  String get pressHeadlineBadly2 => 'Sala się odwróciła i było to widać';

  @override
  String get pressHeadlineBadly3 =>
      'Odpowiedzi, które rano będą brzmieć jeszcze gorzej';

  @override
  String get pressHeadlineFlat1 => 'Nic nie powiedziano, nic nie zyskano';

  @override
  String get pressHeadlineFlat2 => 'Dziesięć minut, zero newsów';

  @override
  String get pressHeadlineFlat3 => 'Pusta strona w dziale sportowym';

  @override
  String get pressConferenceTitle => 'KONFERENCJA PRASOWA';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Pytanie $index z $total';
  }

  @override
  String get pressTomorrowsHeadline => 'JUTRZEJSZY NAGŁÓWEK';

  @override
  String get pressLeaveRoom => 'WYJDŹ Z SALI';

  @override
  String get pressRoomVerdictSquad => 'Szatnia';

  @override
  String get pressRoomVerdictBoard => 'Zarząd';

  @override
  String get yReactionElation0 => 'bez uwag. żadnych. perfekcja.';

  @override
  String get yReactionElation1 => 'Słabo mi (pozytywnie).';

  @override
  String get yReactionElation2 => 'oprawiam to w ramkę. nad kominek.';

  @override
  String get yReactionElation3 => 'wróciliśmy, i to jak';

  @override
  String get yReactionElation4 =>
      'Robię screena dla niedowiarków. Dla wszystkich.';

  @override
  String get yReactionElation5 => 'Przez dekadę będę o tym nie do zniesienia.';

  @override
  String get yReactionElation6 => 'No właśnie. Dlatego to oglądamy.';

  @override
  String get yReactionElation7 => 'Takie dni wynagradzają wszystkie inne.';

  @override
  String get yReactionElation8 => 'Najwyższy czas. Naprawdę najwyższy czas.';

  @override
  String get yReactionElation9 =>
      'Super. Zróbcie to jeszcze raz w przyszłym tygodniu, to uwierzę.';

  @override
  String get yReactionElation10 =>
      'Cieszcie się dziś, bo ta ekipa znajdzie sposób, żeby to zepsuć.';

  @override
  String get yReactionElation11 =>
      'Jeden dobry wieczór nikogo nie robi wielką drużyną.';

  @override
  String get yReactionRelief0 =>
      'Nie było pięknie, ale biorę to za każdym razem.';

  @override
  String get yReactionRelief1 => 'Jakimś cudem. Jakimś cudem!';

  @override
  String get yReactionRelief2 => 'Brzydko. Trzy punkty. Idziemy dalej.';

  @override
  String get yReactionRelief3 =>
      'Mogę oglądać brzydką grę cały dzień, jeśli są punkty.';

  @override
  String get yReactionRelief4 => 'to mi zabrało dziesięć lat życia';

  @override
  String get yReactionRelief5 => 'Nikt nic nie mówi. Nie zapeszajcie.';

  @override
  String get yReactionRelief6 => 'Tętno: nie do przyjęcia.';

  @override
  String get yReactionRelief7 =>
      'Przetrwaliśmy. To jest to słowo. Przetrwaliśmy.';

  @override
  String get yReactionRelief8 =>
      'Nie powinniśmy odczuwać ulgi po takich meczach.';

  @override
  String get yReactionRelief9 => 'Ulga, i trochę wstyd, że to ulga.';

  @override
  String get yReactionRelief10 =>
      'Jeśli to jest poziom, który oklaskujemy, to mamy problem.';

  @override
  String get yReactionRelief11 =>
      'Prześlizgiwanie się to nawyk, i to nie dobry.';

  @override
  String get yReactionFury0 => 'Za mało. Zdecydowanie za mało.';

  @override
  String get yReactionFury1 => 'Niech mi ktoś to powoli wytłumaczy.';

  @override
  String get yReactionFury2 =>
      'Ciężko się to oglądało, a i tak jestem uprzejmy.';

  @override
  String get yReactionFury3 => 'Rozczarowanie. Prawdziwe rozczarowanie.';

  @override
  String get yReactionFury4 => 'Co tu się w ogóle dzieje.';

  @override
  String get yReactionFury5 => 'Chcę nazwisk.';

  @override
  String get yReactionFury6 =>
      'Usuwam aplikację. Instaluję z powrotem w czwartek.';

  @override
  String get yReactionFury7 => 'Nikt tam nie wyglądał, jakby mu zależało.';

  @override
  String get yReactionFury8 => 'Co cztery lata to samo. CO cztery lata.';

  @override
  String get yReactionFury9 => 'To nie był występ, to była obelga.';

  @override
  String get yReactionFury10 =>
      'Ludzie poświęcają na to weekendy i pieniądze. Pomyślcie o tym.';

  @override
  String get yReactionFury11 =>
      'Bronię tej drużyny od lat. Nie dziś. Nie po tym.';

  @override
  String get yReactionDespair0 => 'no cóż.';

  @override
  String get yReactionDespair1 => 'Dziś bez żartów. Nic.';

  @override
  String get yReactionDespair2 => 'Idę na spacer. Długi.';

  @override
  String get yReactionDespair3 =>
      'Skończyły mi się sposoby, żeby to powiedzieć.';

  @override
  String get yReactionDespair4 => 'Obudźcie mnie za cztery lata.';

  @override
  String get yReactionDespair5 => 'to najczarniejszy scenariusz';

  @override
  String get yReactionDespair6 =>
      'Nawet już nie jestem zły. To jest najgorsze.';

  @override
  String get yReactionDespair7 => 'To będzie boleć jeszcze bardzo długo.';

  @override
  String get yReactionDespair8 =>
      'Nie wiem już, co to jest, ale nie drużyna piłkarska.';

  @override
  String get yReactionDespair9 =>
      'Jesteśmy dalej niż byliśmy, a nikt tego nie powie.';

  @override
  String get yReactionDespair10 =>
      'Całe pokolenie zmarnowane, a o tym, co dalej, decydują ci sami ludzie.';

  @override
  String get yReactionDespair11 =>
      'Przestańcie mi mówić, że to proces. To nigdzie nie prowadzi.';

  @override
  String get yReactionSmugness0 => 'Po cichu, ale: a nie mówiłem.';

  @override
  String get yReactionSmugness1 => 'zapiszcie to sobie';

  @override
  String get yReactionSmugness2 => 'Niedowiarkowie jakoś ucichli.';

  @override
  String get yReactionSmugness3 => 'Nie żeby ktoś liczył. Ja liczę.';

  @override
  String get yReactionSmugness4 => 'Mówiłem to w styczniu. Sprawdźcie.';

  @override
  String get yReactionSmugness5 =>
      'Niektórzy z was są winni niektórym z nas przeprosiny.';

  @override
  String get yReactionSmugness6 =>
      'Odkładam do teczki: rzeczy, o których mówiłem pierwszy.';

  @override
  String get yReactionSmugness7 => 'Bez triumfalizmu. No, trochę triumfalizmu.';

  @override
  String get yReactionSmugness8 =>
      'Gdzie są teraz wszyscy eksperci? Pytam serio.';

  @override
  String get yReactionSmugness9 =>
      'Chciałbym, żeby każdy z was mi to powtórzył.';

  @override
  String get yReactionSmugness10 =>
      'Screen, wydruk, ramka, wysłane do tych, co się śmiali.';

  @override
  String get yReactionSmugness11 =>
      'Będę to wypominał do końca życia i zasłużyliście na to.';

  @override
  String get yReactionShrug0 => 'stało się. następny.';

  @override
  String get yReactionShrug1 => 'Dobra. Niech będzie. Dalej.';

  @override
  String get yReactionShrug2 => 'Odkładam do teczki „piłka nożna”.';

  @override
  String get yReactionShrug3 => 'Naprawdę nie mam nic do dodania.';

  @override
  String get yReactionShrug4 => 'zero myśli, pusta głowa';

  @override
  String get yReactionShrug5 => 'Obudźcie mnie na następny.';

  @override
  String get yReactionShrug6 =>
      'Dziewięćdziesiąt minut, których nikt mi nie odda.';

  @override
  String get yReactionShrug7 => 'Ani to, ani tamto.';

  @override
  String get yReactionShrug8 =>
      'Nie powiem wam ani jednej rzeczy, która się wydarzyła.';

  @override
  String get yReactionShrug9 => 'Kolejny taki mecz. Dużo jest takich meczów.';

  @override
  String get yReactionShrug10 =>
      'Obejrzałem wszystko i nie poczułem kompletnie nic.';

  @override
  String get yReactionShrug11 =>
      'Jeśli nikt już o tym nie wspomni, mnie to pasuje.';

  @override
  String get tourThirdsUneven =>
      'Grupy są nierówne, więc wyniki z ostatnimi drużynami większych grup są pomijane i każdy jest oceniany na podstawie tej samej liczby meczów.';

  @override
  String get careerExportSave => 'Kopia zapasowa tego zapisu';

  @override
  String get careerBackupAll => 'KOPIA WSZYSTKICH ZAPISÓW';

  @override
  String get careerBackupAllFailed => 'Nie udało się zapisać kopii.';

  @override
  String get backupTitle => 'ZAPISY';

  @override
  String get backupBlurb =>
      'Wszystkie zapisy są w jednym pliku na tym telefonie i nic nie robi ich kopii samo. Wyeksportuj kopię i trzymaj ją poza telefonem, w Plikach lub na iCloud Drive, żeby zgubiony telefon albo usunięta aplikacja nie kosztowały cię kariery.';

  @override
  String get backupExport => 'EKSPORTUJ KOPIĘ';

  @override
  String get backupExportSubject => 'Zapisy FNM';

  @override
  String get backupRestore => 'PRZYWRÓĆ Z PLIKU';

  @override
  String get backupRestoreWarnTitle => 'Zastąpić wszystkie zapisy?';

  @override
  String get backupRestoreWarnBody =>
      'Przywrócenie zastąpi wszystkie zapisy na tym telefonie tymi z pliku. Aplikacja uruchomi się ponownie.';

  @override
  String get backupRestoreConfirm => 'ZASTĄP';

  @override
  String get backupCancel => 'ANULUJ';

  @override
  String get backupExported => 'Kopia gotowa. Wybierz, gdzie ją zachować.';

  @override
  String get backupFailed => 'Nie udało się zapisać kopii.';

  @override
  String get backupRejectedUnreadable => 'Nie udało się otworzyć tego pliku.';

  @override
  String get backupRejectedNotFnm => 'To nie jest zapis FNM.';

  @override
  String get backupRejectedNewer =>
      'Ten zapis pochodzi z nowszej wersji aplikacji. Najpierw zaktualizuj.';

  @override
  String get backupRejectedTooOld =>
      'Ten zapis jest zbyt stary, by ta wersja mogła go przywrócić.';

  @override
  String get careerShare => 'Udostępnij tę karierę';

  @override
  String get careerImport => 'IMPORTUJ KARIERĘ';

  @override
  String get careerShareSubject => 'Kariera w FNM';

  @override
  String get careerImported => 'Kariera zaimportowana.';

  @override
  String get careerImportFailedUnreadable => 'Ten plik nie jest karierą FNM.';

  @override
  String get careerImportFailedNewer =>
      'Ta kariera pochodzi z nowszej wersji aplikacji. Najpierw zaktualizuj.';

  @override
  String get careerImportFailedSlotsFull =>
      'Wszystkie miejsca na zapis są zajęte. Usuń zapis albo odblokuj nielimitowane zapisy.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Ta kariera jest już za pierwszym darmowym cyklem. Odblokuj pełną grę, aby ją zaimportować.';

  @override
  String get careerShareFailed => 'Nie udało się wyeksportować tej kariery.';

  @override
  String get managerRename => 'Zmień nazwisko';

  @override
  String get managerRenameSave => 'Zapisz';

  @override
  String get managerTitle => 'SELEKCJONER';

  @override
  String get managerSkills => 'TWOJE UMIEJĘTNOŚCI';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punktu do wydania',
      many: '$count punktów do wydania',
      few: '$count punkty do wydania',
      one: '1 punkt do wydania',
      zero: 'Brak punktów do wydania',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Dwa punkty za każdy ukończony cykl, jeden za każde zdobyte trofeum.';

  @override
  String get managerSkillsScale =>
      'Każda umiejętność zaczyna od 5 i kończy na 20. Wydany punkt jest na stałe.';

  @override
  String get managerSkillManManagement => 'Zarządzanie ludźmi';

  @override
  String get managerSkillManManagementBlurb =>
      'Każdy punkt sprawia, że twoje słowa do mediów i zawodników trafiają w szatni o 3% mocniej.';

  @override
  String get managerSkillTactical => 'Taktyka';

  @override
  String get managerSkillTacticalBlurb =>
      'Każdy punkt to o 3% szybsze wdrożenie nowego ustawienia, więc zmiana kosztuje mniej meczów.';

  @override
  String get managerSkillYouth => 'Rozwój młodzieży';

  @override
  String get managerSkillYouthBlurb =>
      'Każdy punkt dodaje 1% do talentu z twojej akademii, ponad to, co dają pieniądze.';

  @override
  String get managerSkillNegotiation => 'Negocjacje';

  @override
  String get managerSkillNegotiationBlurb =>
      'Każdy punkt to 2% więcej pieniędzy od federacji w każdym cyklu.';

  @override
  String get managerStaff => 'TWÓJ SZTAB';

  @override
  String managerStaffWages(String amount) {
    return 'Pensje: $amount na cykl';
  }

  @override
  String get managerRoleAssistant => 'Asystent';

  @override
  String get managerRoleAssistantBlurb =>
      'Prowadzi treningi: mniej kontuzji i lepsza młodzież.';

  @override
  String get managerRoleScout => 'Szef skautów';

  @override
  String get managerRoleScoutBlurb =>
      'Ocenia talenty i najbliższego rywala: trafniejsze gwiazdki i przewaga w dniu meczu.';

  @override
  String get managerRoleFitness => 'Trener przygotowania fizycznego';

  @override
  String get managerRoleFitnessBlurb => 'Utrzymuje ich na boisku.';

  @override
  String staffEffectInjury(int percent) {
    return 'O $percent% mniej kontuzji';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Młodzież +$points oceny';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Po zatrudnieniu: od $min% do $max% mniej kontuzji';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'i młodzież od +$minPoints do +$maxPoints oceny';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Trafnie ocenia $percent% talentów';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potencjał znany po $caps występu',
      many: 'Potencjał znany po $caps występach',
      few: 'Potencjał znany po $caps występach',
      one: 'Potencjał znany po 1 występie',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points oceny dzięki raportom o rywalach';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Po zatrudnieniu: od $min% do $max% trafnych ocen';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'i potencjał znany o $minCaps do $maxCaps występów wcześniej';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'i od +$minPoints do +$maxPoints oceny w każdym meczu';
  }

  @override
  String get staffEffectNone => 'Na razie bez wpływu na kadrę';

  @override
  String get staffVacant => 'Stanowisko nieobsadzone';

  @override
  String get staffLeaveVacant => 'Zostaw stanowisko wolne';

  @override
  String get managerTierNone => 'Brak';

  @override
  String get managerTierBasic => 'Podstawowy';

  @override
  String get managerTierGood => 'Dobry';

  @override
  String get managerTierElite => 'Elitarny';

  @override
  String get managerFree => 'za darmo';

  @override
  String get managerTraining => 'MIĘDZY ZGRUPOWANIAMI';

  @override
  String get managerTrainingBlurb =>
      'Nad czym kadra pracuje, gdy nie ma meczu.';

  @override
  String get managerFocusBalanced => 'Zrównoważony';

  @override
  String get managerFocusBalancedBlurb => 'Wszystkiego po trochu.';

  @override
  String get managerFocusFitness => 'Kondycja';

  @override
  String get managerFocusFitnessBlurb => 'Mniej urazów.';

  @override
  String get managerFocusCohesion => 'Zgranie';

  @override
  String get managerFocusCohesionBlurb =>
      'Ustawienie szybciej wchodzi w nawyk.';

  @override
  String get managerFocusYouth => 'Młodzież';

  @override
  String get managerFocusYouthBlurb => 'Godziny z najmłodszymi w puli.';

  @override
  String get tourOfferTitle => 'Pierwszy raz tutaj?';

  @override
  String get tourOfferBody =>
      'To duża gra. Chcesz szybko przejść przez najważniejsze ekrany? To zajmie minutę, a w każdej chwili możesz zacząć od nowa w Ustawieniach.';

  @override
  String get tourOfferYes => 'Oprowadź mnie';

  @override
  String get tourOfferNo => 'Nie, dzięki';

  @override
  String get tourBack => 'Wstecz';

  @override
  String get tourNext => 'Dalej';

  @override
  String get tourDone => 'Gotowe';

  @override
  String get tourSkip => 'Pomiń';

  @override
  String get tourHubTitle => 'To cała gra';

  @override
  String get tourHubBody =>
      'Jeden przycisk, który zmienia się wraz z cyklem: losowanie do obejrzenia, kadra do powołania, mecz do rozegrania. Nad nim zaufanie zarządu i wyznaczone przez niego cele.';

  @override
  String get tourBudgetTitle => 'Pieniądze federacji';

  @override
  String get tourBudgetBody =>
      'Raz na czteroletni cykl dzielisz fundusze między działy. Najpierw idą z nich pensje sztabu, więc zatrudnienie elitarnego skauta to decyzja kosztem akademii, a nie obok niej.';

  @override
  String get tourTacticsTitle => 'Jak gra drużyna';

  @override
  String get tourTacticsBody =>
      'Ustawienie, styl gry, kapitan i wykonawcy stałych fragmentów. Jeśli nie wyznaczysz dwóch ostatnich, gra ostrzeże cię przed meczem, zamiast po cichu wybierać za ciebie.';

  @override
  String get tourSquadTitle => 'Wszyscy, których możesz wybrać';

  @override
  String get tourSquadBody =>
      'Cała pula, nie tylko kadra: kto jest w formie, kto ma uraz, kto pauzuje i kto właśnie wyszedł z akademii.';

  @override
  String get tourCallUpsTitle => 'Powoływanie kadry';

  @override
  String get tourCallUpsBody =>
      'Powołujesz jedną kadrę na każde okno reprezentacyjne i gra ona wszystkie mecze tego okna, dokładnie jak u prawdziwego selekcjonera. Kontuzja w trakcie okna oznacza automatyczne dowołanie zastępcy.';

  @override
  String get tourRecordsTitle => 'Twoja kariera';

  @override
  String get tourRecordsBody =>
      'Wszystko, czego dokonałeś: mecze, rekordy drużyny, trofea i każda prowadzona reprezentacja.';

  @override
  String get tourCupsTitle => 'Reszta świata';

  @override
  String get tourCupsBody =>
      'Wszystkie trwające rozgrywki: grupy, tabele i fazy pucharowe, także te, w których nie grasz. Świat gra dalej, czy awansowałeś, czy nie.';

  @override
  String get settingsTourTitle => 'Powtórz samouczek';

  @override
  String get settingsTourBlurb =>
      'Przejdź jeszcze raz przez najważniejsze ekrany od początku.';

  @override
  String get tourBoardTitle => 'Przed kim odpowiadasz';

  @override
  String get tourBoardBody =>
      'Zaufanie zarządu i cele na ten cykl. Jeśli nie spełniasz oczekiwań, tutaj zobaczysz, co nadchodzi.';

  @override
  String get tourStaffTitle => 'Ludzie wokół ciebie';

  @override
  String get tourStaffBody =>
      'Asystent, skaut i trener przygotowania fizycznego, zatrudniani z nazwiska. Ich pensje schodzą z budżetu przed działami, więc świetny skaut to decyzja kosztem akademii.';

  @override
  String get tourPlaystyleTitle => 'Twój styl gry';

  @override
  String get tourPlaystyleBody =>
      'Ustawienie to tylko połowa taktyki. To jest druga połowa: jak wysoko pressujesz, jak bezpośrednio grasz, jak bardzo ryzykujesz.';

  @override
  String get settingsTourNoSave =>
      'Najpierw rozpocznij karierę. Samouczek przechodzi przez twoje własne ekrany.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Nie na swojej pozycji · Wiek $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Budżet następnego cyklu ustalasz na jego początku, za jednym razem. Do tego czasu tak pracują twoje pieniądze.';

  @override
  String get federationBudgetAlreadySet => 'Już ustalony na ten cykl';

  @override
  String yFinalLooms0(String opponent) {
    return 'W wielkim meczu czeka $opponent. Cały tydzień nikt nie będzie mówił o niczym innym.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Potwierdzone: między nami a pucharem stoi $opponent. Cztery lata na to czekaliśmy.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'No dobra. $opponent. Nikt nie śpi, dopóki to się nie skończy.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Następny rywal: $opponent, a wszystko inne może poczekać. Co za tydzień.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Zostaw wykonawców trenerowi';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Oznaczone poniżej: drużyny grające jak $rivals, czyli rywale z twoich grup w tym cyklu.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Okno transferowe · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Ostatnio $when temu';
  }

  @override
  String get settingsFreeScopeTitle => 'Jeden darmowy czteroletni cykl';

  @override
  String get settingsFreeScopeBlurb =>
      'Pełny cykl (eliminacje, mistrzostwa kontynentu i Mistrzostwa Świata) w dwóch zapisach, każdy kraj na świecie, nic nie jest ukryte. Nieskończone cykle i nielimitowane zapisy to jedna płatność, raz, obejmująca każdą przyszłą aktualizację.';

  @override
  String get settingsUnlockedTitle => 'Odblokowane';

  @override
  String get settingsUnlockedBlurb =>
      'Nieskończone cykle, nielimitowane zapisy i każda przyszła aktualizacja. Dziękujemy.';

  @override
  String get settingsFromDeveloperTitle => 'Od twórcy';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager tworzy jedna osoba, a gra będzie wspierana długoterminowo. Nigdy nie będzie w niej reklam ani mikrotransakcji. Jeśli gra ci się podoba, rozważ zakup pełnej wersji. To dzięki temu pojawiają się kolejne aktualizacje.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager tworzy jedna osoba, a gra będzie wspierana długoterminowo. Nigdy nie będzie w niej reklam ani mikrotransakcji. Dziękuję za zakup pełnej wersji. To dzięki temu pojawiają się kolejne aktualizacje.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Oznaczone poniżej: drużyny grające jak $rivals, z którymi jeszcze zagrasz.';
  }

  @override
  String get friendliesCloseToYou =>
      'Oznaczone poniżej: drużyny najbliżej ciebie w rankingu światowym. Po losowaniu oznaczenia dopasują się do twojej grupy.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transferu',
      many: '$count transferów',
      few: '$count transfery',
      one: '1 transfer',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Nowsze';

  @override
  String get transfersOlder => 'Więcej';

  @override
  String get transfersPagePrevious => 'Poprzednia';

  @override
  String get transfersPageNext => 'Następna';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Strona $page z $pages';
  }

  @override
  String get transfersMovedTo => 'Przeszedł do';

  @override
  String get transfersUnknownClub => 'Nieznany klub';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'To już $count. mecz z rywalem: $opponent. Ktoś prowadzi rachunki, i to oni.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Znowu $opponent. Po $count spotkaniach wciąż ich nie rozgryźliśmy.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Spotkanie numer $count, rywal: $opponent. To już nie przypadek.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Rywal: $opponent. Graliśmy z nimi $count razy i z żadnego meczu niczego się nie nauczyliśmy.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, spotkanie numer $count. Wiedzą dokładnie, co zrobimy.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Cokolwiek $opponent ma na nas, po $count spotkaniach wciąż to działa.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'To już $count. raz ostatnio. Kiedy to po prostu staje się tym, kim jesteśmy?';
  }

  @override
  String ySameOldStory1(String count) {
    return 'Już $count. takie popołudnie. To schemat, a nie seria pecha.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Ostatnio widzieliśmy ten sam mecz $count razy. Ten sam scenariusz, to samo zakończenie.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count. wersja tych samych dziewięćdziesięciu minut. Nikt tego nie naprawia.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count razy. Jeśli dalej nie widzisz schematu, to nie patrzysz.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Ta sama historia, $count razy. Wymówki skończyły się szybciej niż wyniki.';
  }

  @override
  String get yToldYouSo0 =>
      'Mówiłem, że to nadchodzi, kiedy wszyscy byli zajęci świętowaniem.';

  @override
  String get yToldYouSo1 =>
      'Dwa dobre tygodnie i znów byliśmy złotym pokoleniem. I proszę.';

  @override
  String get yToldYouSo2 =>
      'Ci, co w zeszłym miesiącu kazali mi się cieszyć, jakoś ucichli.';

  @override
  String get yToldYouSo3 =>
      'Nie sprawia mi to przyjemności. Bardzo małą. Trochę.';

  @override
  String get yToldYouSo4 =>
      'Nigdy nie było tak dobrze, jak wam mówili, a to jest dowód.';

  @override
  String get yToldYouSo5 =>
      'Za każdym razem. Mówią nam, że tym razem będzie inaczej, i za każdym razem nie jest.';

  @override
  String get tacticsSubOffAlready => 'Już zmieniony';

  @override
  String get tacticsSubInjured => 'Kontuzjowany';

  @override
  String get tacticsSubSentOffMark => 'Czerwona kartka';

  @override
  String get tacticsSubNoneLeft => 'Brak zmian';

  @override
  String get tacticsUndoLastChange => 'Cofnij ostatnią zmianę';

  @override
  String get matchStrengthTitle => 'CO WPŁYWA NA DRUŻYNĘ';

  @override
  String get strengthFactorFamiliarity => 'Zgranie ustawienia';

  @override
  String get strengthFactorFatigue => 'Zmęczenie';

  @override
  String get strengthFactorClubForm => 'Forma klubowa';

  @override
  String get strengthFactorMorale => 'Szatnia';

  @override
  String get strengthFactorCaptain => 'Kapitan';

  @override
  String get strengthFactorStaff => 'Sztab';

  @override
  String get strengthFactorDossier => 'Raport skauta';

  @override
  String yDebut0(String name) {
    return '$name z debiutem w kadrze. Zapamiętajcie to nazwisko.';
  }

  @override
  String yDebut1(String name) {
    return 'Debiut: $name. Widać to w nim, prawda?';
  }

  @override
  String yDebut2(String name) {
    return '$name, pierwszy występ. Zobaczymy, co z tym zrobi.';
  }

  @override
  String yDebut3(String name) {
    return 'Debiut: $name. Kadrze przydały się gdzieś świeże nogi.';
  }

  @override
  String yDebut4(String name) {
    return '$name z pierwszym występem. Ostatnio rozdajemy ich sporo.';
  }

  @override
  String yDebut5(String name) {
    return 'Debiut: $name. Kolejny, o którym do wiosny zapomnimy.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name nie strzelił gola od $count meczów, a poza tym robi na boisku wszystko.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$name bez gola od $count meczów. Gole przychodzą seriami, zawsze tak było.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: mecze bez gola: $count.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$name bez gola od $count meczów. Warto mieć na to oko.';
  }

  @override
  String yDrought4(String name, String count) {
    return 'Bez gola od $count meczów. $name nie trafiłby w bramę stodoły.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name nie strzelił od $count meczów. Wystawcie dosłownie kogokolwiek innego.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Następny rywal: $opponent. Po $count spotkaniach to wciąż znaczy wszystko.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return 'Spotkanie numer $count, rywal: $opponent. Dawajcie.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Następny rywal: $opponent. Rozegrane mecze: $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'W tym tygodniu spotkanie numer $count. Rywal: $opponent.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Znowu $opponent. Po $count takich meczach niczego się nie nauczyliśmy.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return 'Po $count meczach z rywalem $opponent oni wciąż nas ogrywają. Cudownie.';
  }

  @override
  String get positionGoalkeeper => 'Bramkarz';

  @override
  String get positionLeftBack => 'Lewy obrońca';

  @override
  String get positionCentreBack => 'Środkowy obrońca';

  @override
  String get positionRightBack => 'Prawy obrońca';

  @override
  String get positionDefensiveMid => 'Defensywny pomocnik';

  @override
  String get positionCentralMid => 'Środkowy pomocnik';

  @override
  String get positionAttackingMid => 'Ofensywny pomocnik';

  @override
  String get positionLeftMid => 'Lewy pomocnik';

  @override
  String get positionRightMid => 'Prawy pomocnik';

  @override
  String get positionLeftWing => 'Lewy skrzydłowy';

  @override
  String get positionRightWing => 'Prawy skrzydłowy';

  @override
  String get positionStriker => 'Napastnik';

  @override
  String get roleNone => 'Bez roli';

  @override
  String get roleTargetMan => 'Wysoki napastnik';

  @override
  String get rolePoacher => 'Lis pola karnego';

  @override
  String get rolePlaymaker => 'Rozgrywający';

  @override
  String get roleBallWinner => 'Odbierający';

  @override
  String get roleInvertedWinger => 'Odwrócony skrzydłowy';

  @override
  String get roleBallPlayingDefender => 'Obrońca rozgrywający';

  @override
  String get roleNoneBlurb => 'Gra swoją naturalną grę.';

  @override
  String get roleTargetManBlurb =>
      'Wygrywa główki, zgrywa piłkę. Asysty i stałe fragmenty.';

  @override
  String get rolePoacherBlurb => 'Czai się w polu karnym. Dużo więcej goli.';

  @override
  String get rolePlaymakerBlurb => 'Kreuje sytuacje. Dużo więcej asyst.';

  @override
  String get roleBallWinnerBlurb => 'Przerywa akcje, zamiast je kończyć.';

  @override
  String get roleInvertedWingerBlurb =>
      'Schodzi do środka na strzał. Więcej goli.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Rozpoczyna akcje od tyłu.';

  @override
  String get federationDeptYouth => 'Akademia';

  @override
  String get federationDeptCommercial => 'Marketing / PR';

  @override
  String get federationDeptMedical => 'Medycyna i nauka o sporcie';

  @override
  String get federationDeptNaturalisation => 'Biuro naturalizacji';

  @override
  String get federationDeptBoardRelations => 'Relacje z zarządem';

  @override
  String get federationDeptYouthBlurb =>
      'Lepsze talenty z akademii zadebiutują w twojej reprezentacji w kolejnym cyklu.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsorzy przynoszą dodatkowy dochód na koniec cyklu.';

  @override
  String get federationDeptMedicalBlurb =>
      'Mniej kontuzji. Kadra jest dostępna przez cały cykl.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Więcej zagranicznych zawodników chce grać dla twojej reprezentacji.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Zarząd cierpliwiej ocenia twoje wyniki.';

  @override
  String get federationBuildingAcademy => 'Akademia';

  @override
  String get federationBuildingCommercial => 'Siedziba marketingu';

  @override
  String get federationBuildingMedical => 'Centrum medyczne';

  @override
  String get federationBuildingScouting => 'Biuro skautingu';

  @override
  String get federationBuildingBoardroom => 'Sala zarządu';

  @override
  String get moraleBuoyant => 'Euforia';

  @override
  String get moralePositive => 'Dobre';

  @override
  String get moraleSettled => 'Stabilne';

  @override
  String get moraleUneasy => 'Niepewne';

  @override
  String get moraleRockBottom => 'Na dnie';

  @override
  String get matchTabTimeline => 'PRZEBIEG';

  @override
  String get matchTabStats => 'STATYSTYKI';

  @override
  String get matchTabLineups => 'SKŁADY';

  @override
  String get matchPenalty => 'RZUT KARNY';

  @override
  String get matchStateLevel => 'Remis';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prowadzisz $count gola',
      many: 'Prowadzisz $count golami',
      few: 'Prowadzisz $count golami',
      one: 'Prowadzisz jednym golem',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Przegrywasz $count gola',
      many: 'Przegrywasz $count golami',
      few: 'Przegrywasz $count golami',
      one: 'Przegrywasz jednym golem',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return 'Posiadanie piłki: $possession%';
  }

  @override
  String get boardVerdictSackedTitle => 'Zarząd cię zwolnił';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Fatalny cykl (ocena $rating%). Twoje rządy tu się kończą. Teraz zaryzykują z tobą tylko słabsze reprezentacje.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Zarząd jest zachwycony';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Znakomity cykl (ocena $rating%), a w nim $best. Interesują się tobą większe reprezentacje, ale możesz też zostać i budować dalej.';
  }

  @override
  String get boardVerdictSolidTitle => 'Solidny cykl';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Zarząd jest zadowolony (ocena $rating%). Kilka reprezentacji podobnego kalibru chętnie by cię wzięło, ale nic nie zmusza cię do zmiany.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Zarząd oczekiwał więcej';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Rozczarowujący cykl (ocena $rating%). Zachowujesz posadę, ale ewentualne oferty to krok w dół.';
  }

  @override
  String get boardVerdictPressureTitle => 'Jesteś pod prawdziwą presją';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Słaby cykl (ocena $rating%). Utrzymujesz się, ale jeśli chcesz zacząć od nowa, interesują się tobą tylko słabsze reprezentacje.';
  }

  @override
  String get boardVerdictHeroTitle => 'Kraj stoi za tobą';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cyklu',
      many: '$cycles cyklach',
      few: '$cycles cyklach',
      one: '1 cyklu',
    );
    return ' Kraj ($nation) cię uwielbia, jesteś bohaterem narodowym po $_temp0. Twoja posada jest bezpieczna, dopóki jej chcesz.';
  }

  @override
  String get boardVerdictTheNation => 'Kraj';

  @override
  String get boardVerdictBestQuiet => 'spokojny przebieg';

  @override
  String get boardVerdictBestCycle => 'cały cykl';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'Mistrzostwa Świata: $placement';
  }

  @override
  String get finishThirdPlace => 'Trzecie miejsce';

  @override
  String get finishFourthPlace => 'Czwarte miejsce';

  @override
  String get finishDidNotQualify => 'Brak awansu';

  @override
  String get careerRepIconic => 'Ikona';

  @override
  String get careerRepRenowned => 'Uznany';

  @override
  String get careerRepEstablished => 'Ugruntowany';

  @override
  String get careerRepRising => 'Wschodząca gwiazda';

  @override
  String get careerRepUnproven => 'Niesprawdzony';

  @override
  String get hubOfferStepUp => 'Krok w górę';

  @override
  String get hubOfferLateral => 'Ruch w bok';

  @override
  String get hubOfferRebuild => 'Odbudowa';

  @override
  String careerNationsCupWon(String league) {
    return 'Dywizja $league · Zwycięzcy';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Dywizja $league · Finaliści';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Dywizja $league · Półfinaliści';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Dywizja $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Następna runda: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Awans do meczu o 3. miejsce';

  @override
  String tourRunThrough(String round) {
    return 'Przeszli rundę: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Odpadli, runda: $round';
  }

  @override
  String get tourRunInGroup => 'W grze w fazie grupowej';

  @override
  String get tourRunGroupOut => 'Odpadli w fazie grupowej';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Cykl $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return 'Mecze: $played  ·  ${won}Z ${drawn}R ${lost}P';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Mistrzostwa Świata: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Wciąż w toku';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Dwa gole straty do przerwy, rywal: $opponent, i odrobili wszystko. To jest drużyna.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Dwie bramki straty, rywal: $opponent, a na koniec nie miało to znaczenia. Mało kto tak potrafi.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Przerwa: dwa gole straty, rywal: $opponent. Koniec: już nie. Druga połowa to był inny mecz.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Odrobione dwa gole straty, rywal: $opponent. Cokolwiek padło w przerwie, mówcie to co tydzień.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Dobra, odrobiliśmy straty, rywal: $opponent. A teraz niech ktoś wytłumaczy pierwsze czterdzieści pięć minut.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Dwa gole w plecy, rywal: $opponent, a my mamy być zachwyceni. Naprawcie pierwszą połowę.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Dwa gole przewagi do przerwy, rywal: $opponent, i wszystko się wymknęło. Lepszym drużynom też się to zdarza.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Dwie bramki przewagi, rywal: $opponent, i przepadło. Cykl jest długi, czasu sporo.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Przerwa: dwa gole przewagi, rywal: $opponent. Koniec: nic z tego.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Dwubramkowe prowadzenie, rywal: $opponent, roztrwonione w czterdzieści pięć minut.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Dwa gole przewagi i przegraliśmy. Rywal: $opponent. Ktoś za to odpowie.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Dwie bramki przewagi, rywal: $opponent, i proszę, co z tego zrobiliśmy. Za każdym razem.';
  }

  @override
  String get cycleBackupDone =>
      'Kopia kariery zapisana w folderze FNM na tym telefonie. Odinstalowanie aplikacji ją usunie: żeby trzymać kopię gdzie indziej, użyj opcji Kopia zapasowa tego zapisu na ekranie zapisów.';

  @override
  String get cycleBackupFailed =>
      'Tym razem nie udało się zrobić kopii kariery.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Wieczór do zapamiętania, rywal: $opponent. Jak bardzo jest Pan dumny z tej grupy?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return 'Rywal ($opponent) nie miał z wami szans. Czy to jest drużyna, w którą zawsze Pan wierzył?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Wysokie zwycięstwo, rywal: $opponent. Co dziś przesądziło?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'Rywal ($opponent) pokonany, i to pewnie. Gdzie wygraliście ten mecz?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Dobre zwycięstwo, rywal: $opponent. Jeden dobry wieczór: dlaczego ktoś miałby wierzyć, że to potrwa?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Świetny wynik, rywal: $opponent. To był Pana plan, czy zawodnicy sami to wymyślili?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Ciężki wieczór, rywal: $opponent. Co mówi Pan zawodnikom po takim meczu?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Nikt się tego nie spodziewał, rywal: $opponent. To był po prostu jeden z tych wieczorów?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'To był bolesny wieczór, rywal: $opponent. Co poszło nie tak?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return 'Rywal ($opponent) rozbił was na kawałki. Czy ta kadra jest wystarczająco dobra?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Byliście gorsi we wszystkim, rywal: $opponent. Jak Pan do tego dopuścił?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return 'Rywal ($opponent) strzelał, kiedy chciał. Gdzie był dziś plan?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Kolejny mecz wymyka się z rąk, tym razem rywal: $opponent. Jak odwrócić tę serię?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Wyniki się skończyły, a mecz z rywalem $opponent tylko pogorszył sprawę. Wciąż wierzy Pan w tę grupę?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Znowu bez zwycięstwa, tym razem rywal: $opponent, a zarząd patrzy. Czy Pana posada jest bezpieczna?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Po meczu z rywalem $opponent ta seria robi się długa. Martwi się Pan o swoją przyszłość?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Teraz jeszcze $opponent. Pana poprzednika zwolniono po takiej serii. Dlaczego Pan miałby to przetrwać?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Po kolejnym takim wieczorze (rywal: $opponent) każdy program radiowy chce Pana odejścia. Ustąpiłby Pan, gdyby zarząd poprosił?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Postawił Pan posadę na szali, a po meczu z rywalem $opponent nie poszło po Pana myśli. Jak się Pan trzyma?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Trzy mecze za nami, ostatni z rywalem $opponent. Sam Pan wyznaczył ten test. Co Pan myśli o werdykcie?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Kazał nam Pan oceniać się po trzech kolejnych meczach. Po meczu z rywalem $opponent oceniliśmy. Czy posada wciąż jest Pana?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Trzy mecze, ostatni z rywalem $opponent, i nie to, co Pan obiecywał. Rozmawiał Pan z zarządem o swojej przyszłości?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Sam Pan wyznaczył test i oblał go. Rywal: $opponent. Poda się Pan do dymisji?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Pana słowa, nie nasze: oceniajcie mnie po trzech meczach. Po meczu z rywalem $opponent: dlaczego wciąż Pan tu siedzi?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Oczekuje Pan od nich więcej. Ktoś konkretny?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Podniósł Pan poprzeczkę wysoko. Kto musi zrobić krok naprzód pierwszy?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Mówi Pan, że niektórzy powinni spojrzeć w lustro. Kogo ma Pan na myśli?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Mówi Pan, że to za mało. O kim Pan mówi?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Mówi Pan ogólnikami. Poda Pan nazwiska, czy to wraca do Pana?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Co tydzień to wina kogoś innego. Czyja tym razem?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Odważne słowa. A jeśli następny mecz nie pójdzie po Pana myśli?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Kraj będzie Pana z tego rozliczał. A jeśli się nie uda?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'A jeśli nie wygracie? Co wtedy?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Powiedział Pan to głośno. Co, jeśli się Pan myli?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Słyszeliśmy już w tej sali obietnice. Co jest Pan winien kibicom, jeśli i ta pęknie?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'A kiedy się nie uda, jaka będzie wymówka?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Jeszcze jedno, jeśli Pan pozwoli. Nad czym ta grupa musi jeszcze pracować?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Kiedy opadnie kurz, co z dzisiejszego wieczoru zabierze Pan do następnego meczu?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Pójdźmy nieco głębiej. Co musi się poprawić przed następnym meczem?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Patrząc poza wynik: czy ta kadra jest tam, gdzie chce ją Pan widzieć?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Dużo słów, mało treści. Co się właściwie teraz zmieni?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Kibice chcą prostej odpowiedzi. Czy ta drużyna jest wystarczająco dobra, tak czy nie?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player był dziś znakomity. Jak daleko może zajść?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player jest dziś w każdym nagłówku. Spodziewał się Pan tego?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player się wyróżnił. Czego Pan od niego dziś oczekiwał?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Czy to $player zrobił dziś różnicę?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Bez niego ($player) to byłaby inna historia. To drużyna czy jeden zawodnik?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player był świetny. To Pana zasługa czy jego?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player miał ciężki wieczór. Czy coś mu dolega?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player nie miał swojego dnia. Obejmie go Pan ramieniem?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player dziś męczył się na boisku. Czy zachowa miejsce w składzie?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player nie nadążał za grą. Jak Pan ocenia jego występ?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player znowu był tylko pasażerem. Dlaczego ciągle Pan na niego stawia?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Wszyscy widzieli, że $player nie był sobą. Wszyscy oprócz ławki?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Mówił Pan, że wygracie następny mecz, i wygraliście. Miło mieć rację?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Obiecał Pan zwycięstwo w następnym meczu i dotrzymał słowa. Pewność siebie czy brawura?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Mówił Pan, że wygracie następny mecz, i wygraliście. Szczęście, czy mamy zacząć słuchać?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Mówił nam Pan, że wygracie tamten mecz. Nie wyszło. Co poszło nie tak?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Mówił Pan, że wygracie następny mecz. Nie wygraliście. Dlaczego mamy wierzyć w kolejną obietnicę?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Mówił Pan, że wygracie następny mecz. Nie wygraliście. Czy Pana słowa jeszcze coś znaczą w tej sali?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Prosił Pan, by oceniać go po trzech meczach, i zdał Pan test. Czuje się Pan zrehabilitowany?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Oceniajcie mnie po trzech meczach, mówił Pan. Oceniliśmy i wyniki przyszły. Czego nauczył Pana ten test?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Dał Pan sobie trzy mecze i je przetrwał. Czy ten test w ogóle był trudny?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Prosił Pan, by oceniać go po trzech meczach. Nie poszły po Pana myśli. Czego się Pan nauczył?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Oceniajcie mnie po trzech meczach, mówił Pan. Te trzy mecze minęły, a z nimi kredyt zaufania. Co teraz?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Sam Pan wyznaczył test i go oblał. Dlaczego ktokolwiek miałby teraz wierzyć Pana słowu?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Stanął Pan za zawodnikiem ($player), kiedy inni tego nie robili. Odpłacił się. Część zasługi Pana?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Postawił Pan na niego ($player). Odpłacił się. Wiara czy wiedza?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Postawił Pan na niego ($player) i tym razem się opłaciło. Następnym razem też będzie Pan taki pewny?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Stał Pan murem za zawodnikiem ($player) i to nie wyszło. Wciąż Pan w niego wierzy?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Postawił Pan na niego ($player). Nie odpłacił się. To był błąd?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Pana osąd czy Pana lojalność: co zawiodło w przypadku zawodnika $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Był Pan surowy dla zawodnika ($player), a kolejne mecze przyznały Panu rację. Daje to jakąś satysfakcję?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Skrytykował go Pan publicznie ($player), a on nie odpowiedział. Czy jest dla niego droga powrotu?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Wystawił go Pan na pożarcie ($player) i on się nie podniósł. Złamał go Pan?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Skrytykował go Pan publicznie ($player), a on odpowiedział na boisku. Taki był od początku plan?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Obwinił go Pan ($player), a od tamtej pory jest jednym z najlepszych. Jest mu Pan winien przeprosiny?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Rzucił go Pan pod autobus ($player), a od tamtej pory jest Pana najlepszym zawodnikiem. Przeprosi Pan?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Ci zawodnicy dali mi wszystko. Nie zamieniłbym żadnego z nich.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Nikt nie pracuje ciężej niż ta grupa. Będę ich bronił cały dzień.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Ode mnie nie usłyszycie złego słowa o moich zawodnikach.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Zasługa należy do zawodników, nie do mnie. Piszcie o nich.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'To moja wina. Ja wybrałem skład i ja ich ustawiłem.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Oceniajcie mnie, nie ich. To moja drużyna i moja odpowiedzialność.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Jeśli szukacie winnego, siedzę tutaj.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Odpowiedzialność jest moja. Zostawcie zawodników w spokoju.';

  @override
  String get pressReplyDemandMore1 =>
      'Chcę więcej. Niektórzy dokładnie wiedzą, o co mi chodzi.';

  @override
  String get pressReplyDemandMore2 =>
      'Na tym poziomie samo zaangażowanie nie wystarcza. Chcę więcej i powiedziałem im to.';

  @override
  String get pressReplyDemandMore3 =>
      'Oczekuję więcej od każdego z nich, od jutra.';

  @override
  String get pressReplyDemandMore4 =>
      'Niektórzy muszą spojrzeć w lustro. Nie jestem zadowolony.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Wygramy następny mecz. Możecie to zapisać.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Zapamiętajcie moje słowa: wygrywamy następny mecz.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Następny mecz wygrywamy. Mówię to tutaj, żebyście mogli mnie z tego rozliczyć.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Jestem pewny tej drużyny. Wygrywamy następny mecz.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Oceniajcie mnie po trzech następnych meczach. To uczciwe.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Dajcie mi trzy mecze. Jeśli do tego czasu nie będzie dobrze, rozliczcie mnie.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Trzy następne mecze pokażą, czy jestem właściwym człowiekiem. Trzymajcie mnie za słowo.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Trzy mecze. Potem piszcie o mnie, co chcecie.';

  @override
  String get pressReplyDeflect1 =>
      'Skupiamy się na każdym meczu po kolei. Nie mam nic do dodania.';

  @override
  String get pressReplyDeflect2 => 'Dziś nie dam wam nagłówków.';

  @override
  String get pressReplyDeflect3 => 'Następny mecz. Tylko o tym myślę.';

  @override
  String get pressReplyDeflect4 => 'To, co myślę, zostaje w szatni.';

  @override
  String get pressReplyTakeCredit1 =>
      'Powiedziałem to, bo w to wierzyłem, i miałem rację.';

  @override
  String get pressReplyTakeCredit2 =>
      'Dobrze to odczytałem. Od tego tu jestem.';

  @override
  String get pressReplyTakeCredit3 =>
      'Nazwijcie to wyczuciem. Wiedziałem, co mówię.';

  @override
  String get pressReplyTakeCredit4 => 'Podjąłem decyzję i się udało. Biorę to.';

  @override
  String get pressReplyStandByIt1 =>
      'Powiedziałem, w co wierzyłem. Podtrzymuję to.';

  @override
  String get pressReplyStandByIt2 => 'Nie cofam ani słowa.';

  @override
  String get pressReplyStandByIt3 =>
      'Ta sama odpowiedź co wtedy. Myślałem tak i nadal tak myślę.';

  @override
  String get pressReplyStandByIt4 => 'Jutro powiedziałbym to samo.';

  @override
  String get pressReplyAdmitMistake1 => 'Tu się pomyliłem. Biorę to na siebie.';

  @override
  String get pressReplyAdmitMistake2 =>
      'W porządku, źle to oceniłem. Wyciągnę wnioski.';

  @override
  String get pressReplyAdmitMistake3 => 'Myliłem się i potrafię to przyznać.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Ta decyzja nie zadziałała, a była moja.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player ma moje pełne wsparcie. Jeszcze pokaże, na co go stać.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Wierzę w niego ($player) i on wam pokaże dlaczego.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Nie usłyszycie ode mnie złego słowa o nim ($player). Dostarczy.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player jest w moich planach. Patrzcie, co zrobi dalej.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player zawiódł nas dziś i on o tym wie.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Oczekiwałem od niego dużo więcej ($player). Musi na to odpowiedzieć.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player nie był na poziomie. Mówię to publicznie.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return '$player zagrał za słabo i usłyszy to ode mnie.';
  }

  @override
  String get pressOnRecordWinNext => 'Do protokołu: wygrasz następny mecz.';

  @override
  String get pressOnRecordJob =>
      'Do protokołu: oceniajcie cię po trzech następnych meczach.';

  @override
  String pressOnRecordBack(String player) {
    return 'Do protokołu: wspierasz zawodnika $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Do protokołu: $player cię zawiódł.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Powiedział i tak się stało. $nation ma selekcjonera, który mówi, co myśli.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Powiedział to głośno, a potem to zrobił. $nation potrzebuje właśnie takiego człowieka.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: przewidział to i się sprawdziło. Uczciwie.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Powiedział to do protokołu i słowo się obroniło. Punkt dla niego. $nation idzie dalej.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Raz trafił. $nation, nie przyzwyczajajcie się.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Nawet zepsuty zegar dwa razy na dobę pokazuje dobrą godzinę. $nation: tym razem fart.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Powiedział i nie wyszło. Wciąż jestem z nim. $nation próbuje dalej.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: obiecał więcej, niż dostaliśmy, ale wolę selekcjonera, który wierzy w siebie.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: powiedział to do protokołu i nic z tego nie wyszło. Ludzie zapamiętają.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Wielkie słowa, nic za nimi. $nation: następnym razem mniej gadania.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Stał tam i nam to mówił. A potem to. $nation zasługuje na coś więcej niż gadanie.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Jego słowo jest teraz nic niewarte. Zapiszcie to sobie, $nation.';
  }

  @override
  String get ncZoneNorth => 'Strefa Północna';

  @override
  String get ncZoneWest => 'Strefa Zachodnia';

  @override
  String get ncZoneEast => 'Strefa Wschodnia';

  @override
  String get ncZoneCentralSouthern => 'Strefa Środkowo-Południowa';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Zwycięzcy';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Finaliści';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Półfinaliści';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · 1/8 finału';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Ćwierćfinaliści';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Awansuj do ćwierćfinału';

  @override
  String get objectiveNcZoneWinGroup => 'Wygraj grupę';

  @override
  String get finishNcFinalsEight => 'Ćwierćfinał';

  @override
  String get finishNcBottomHalf => 'Dolna połowa grupy';

  @override
  String get tourContTabZones => 'STREFY';

  @override
  String get tourContTabFinalsEight => 'FAZA PUCHAROWA';

  @override
  String get tourContFinalsEightSoon =>
      'Faza pucharowa rusza w listopadzie od 1/8 finału: wszyscy 14 zwycięzców grup i 2 najlepsze drużyny z drugich miejsc.';

  @override
  String get tourContQuarterFinals => 'ĆWIERĆFINAŁY';

  @override
  String get tourContZoneAdvancement =>
      'Każdy zwycięzca grupy awansuje do 1/8 finału, a z nim 2 najlepsze drużyny z drugich miejsc. Nikt nie spada.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Puchar Narodów Ameryki Północnej';

  @override
  String get compAfricanNationsCup => 'Puchar Narodów';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Wygraj Puchar Narodów Ameryki Północnej';

  @override
  String get objectiveNcWinItAfrica => 'Wygraj Puchar Narodów';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Dojdź do finału Pucharu Narodów Ameryki Północnej';

  @override
  String get objectiveNcReachFinalAfrica => 'Dojdź do finału Pucharu Narodów';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Zdobywcy Pucharu Narodów Ameryki Północnej';

  @override
  String get finishNcChampionsAfrica => 'Zdobywcy Pucharu Narodów';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Eliminacje: $competition. Cały kraj wierzy w tę drużynę. Jaki masz cel?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Nowe eliminacje, $competition, a nastroje są świetne. Jak daleko może zajść ta drużyna?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Ruszają eliminacje, $competition. Jaki jest cel tej kampanii?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Eliminacje już są, $competition. Gdzie widzisz tę drużynę na koniec?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Ruszają eliminacje, $competition, a wielu wątpi, że awansujesz. Co im odpowiesz?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Kolejne eliminacje, $competition. Dlaczego ktoś miałby wierzyć, że tym razem będzie inaczej?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Zaczyna się: $competition. Cały kraj jest za wami. Jak daleko możecie zajść?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Jesteście tam: $competition. Kibice marzą. Jaki jest cel?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'W tym tygodniu start: $competition. Co byłoby sukcesem?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Pierwszy mecz tuż-tuż, $competition. Podaj nam cel.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Zaczyna się: $competition, a nikt wiele nie oczekuje. Na co naprawdę liczysz?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Jesteście tam: $competition, ale wątpliwości nie zniknęły. Jaki masz cel?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'W twojej grupie jest rywal: $rival. Martwi cię to?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Losowanie dało wam rywala: $rival. Jak widzisz ten mecz?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return 'Najmocniejszy rywal w grupie: $rival. To faworyt?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Co sądzisz o rywalu: $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'W grupie jest rywal: $rival. Szczerze, dacie radę?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Większość spodziewa się porażki, rywal: $rival. Mylą się?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player jest w świetnej formie. To jego czas?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player jest we wszystkich nagłówkach. Pociągnie tę drużynę?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Jak bardzo ta kampania zależy od zawodnika $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Czy $player jest gotowy poprowadzić tę drużynę?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Jeśli $player nie będzie w formie, czy ta drużyna ma coś jeszcze?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player ma dużo na barkach. Za dużo?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Zajdziemy dalej, niż ktokolwiek się spodziewa.';

  @override
  String get pressReplyAimHigher2 =>
      'Chcę więcej, niż oczekuje federacja, i mówię to głośno.';

  @override
  String get pressReplyMatchBrief1 => 'Znamy cel i go osiągniemy.';

  @override
  String get pressReplyMatchBrief2 =>
      'Federacja wyznaczyła cel. Zrealizujemy go.';

  @override
  String get pressReplyPlayDown1 => 'Skupiamy się na kolejnym meczu.';

  @override
  String get pressReplyPlayDown2 =>
      'Żadnych wielkich obietnic. Zobaczymy, gdzie będziemy.';

  @override
  String get pressReplyPromiseQualify1 => 'Awansujemy. Możecie to zapisać.';

  @override
  String get pressReplyPromiseQualify2 =>
      'Ta drużyna zagra w turnieju finałowym.';

  @override
  String get pressReplyFearNobody1 => 'Nie boimy się nikogo.';

  @override
  String get pressReplyFearNobody2 => 'Oni też muszą z nami zagrać.';

  @override
  String get pressReplyRespectRival1 => 'To faworyt i mamy do nich szacunek.';

  @override
  String get pressReplyRespectRival2 =>
      'Bardzo dobra drużyna. Będziemy musieli dać z siebie wszystko.';

  @override
  String get pressReplyTeamFirst1 =>
      'Liczy się cała drużyna, nie jeden zawodnik.';

  @override
  String get pressReplyTeamFirst2 => 'Nikt nie wygra tego sam.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Do protokołu: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Do protokołu: żadnych obietnic.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Przed kampanią wyznaczyłeś cel i go osiągnąłeś. To twój najdumniejszy moment?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Powiedziałeś, co osiągniesz, i to zrobiłeś. Miałeś wątpliwości?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Osiągnąłeś swój cel. Szczęście czy naprawdę taki był plan?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Wyznaczyłeś cel i go nie osiągnąłeś. Co poszło nie tak?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Obiecałeś więcej, niż drużyna dała. Żałujesz tych słów?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Przed kampanią mówiłeś wielkie słowa i nie dowiozłeś. Dlaczego mamy ci teraz wierzyć?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Dziennikarze chcą poznać twoje cele: $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Poziom $level · $amount';
  }

  @override
  String get formOnFire => 'W gazie';

  @override
  String get formGood => 'W formie';

  @override
  String get formSteady => 'Równa forma';

  @override
  String get formPoor => 'Bez formy';

  @override
  String get formCold => 'Kompletnie bez formy';

  @override
  String get playerFormTitle => 'FORMA I KONDYCJA';

  @override
  String playerFormAverage(String rating) {
    return 'Średnia ocena $rating w ostatnich meczach';
  }

  @override
  String get playerFormNoGames => 'Za mało ostatnich meczów, by ocenić';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta do oceny w następnym meczu';
  }

  @override
  String get playerFormNoEffect => 'Bez zmiany oceny w następnym meczu';

  @override
  String get sideGroupHome => 'Start';

  @override
  String get sideGroupTeam => 'Drużyna';

  @override
  String get sideGroupCompetitions => 'Rozgrywki';

  @override
  String get sideGroupFederation => 'Federacja';

  @override
  String get sideGroupHistory => 'Historia';

  @override
  String get sideInbox => 'Skrzynka';

  @override
  String get sideSquad => 'Kadra';

  @override
  String get sideTactics => 'Taktyka';

  @override
  String get sideMainMenu => 'Menu główne';

  @override
  String get sideCallUps => 'Powołania';

  @override
  String get sideTournaments => 'Turnieje';

  @override
  String get sideRanking => 'Ranking';

  @override
  String get sideResults => 'Wyniki';

  @override
  String get sideFinances => 'Finanse';

  @override
  String get sideBoard => 'Zarząd';

  @override
  String get sideManager => 'Trener i sztab';

  @override
  String get sideRecords => 'Rekordy';

  @override
  String get sideLegends => 'Legendy';

  @override
  String get sideHeadToHead => 'Bilans spotkań';

  @override
  String get sideAchievements => 'Osiągnięcia';

  @override
  String get sideCareer => 'Kariera';

  @override
  String get topBarNext => 'Następny';

  @override
  String get topBarDrawPending => 'Losowanie wkrótce';

  @override
  String get paneFullProfile => 'Pełny profil';

  @override
  String get panePickPlayer => 'Wybierz zawodnika, aby zobaczyć tu jego kartę';

  @override
  String get inboxPickMessage => 'Wybierz wiadomość, aby ją tu przeczytać';

  @override
  String get inboxFilterAll => 'Wszystkie';

  @override
  String get panelViewAll => 'Zobacz wszystko';

  @override
  String get gridViewOverview => 'Przegląd';

  @override
  String get gridColCondition => 'Kondycja';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Miejsce';

  @override
  String get gridColMove => 'Zmiana';

  @override
  String get gridColNation => 'Reprezentacja';

  @override
  String get gridColRegion => 'Region';

  @override
  String get gridColPoints => 'Punkty';

  @override
  String get panePickNation =>
      'Wybierz reprezentację, aby zobaczyć tu jej historię';

  @override
  String get resultsCyclesTitle => 'Cykle';

  @override
  String get tourDrawStart => 'Rozpocznij losowanie';

  @override
  String get tourDrawViewGroups => 'Zobacz grupy';

  @override
  String get gridColCeiling => 'Potencjał';

  @override
  String get gridColYearGain => 'Postęp';

  @override
  String get gridColMarkedAt => 'Przy oznaczeniu';

  @override
  String get budgetSetupTitle => 'Ustal budżet';

  @override
  String get budgetEffectsTitle => 'Co daje ten budżet';

  @override
  String get naturalisationTitle => 'Naturalizacja';

  @override
  String get yTrending => 'Na czasie';

  @override
  String get yVoices => 'Głosy';

  @override
  String get yConversation => 'Rozmowa';

  @override
  String get allTimeRecordsTitle => 'Rekordy świata wszech czasów';

  @override
  String get h2hMeetingsTitle => 'Wszystkie spotkania';

  @override
  String get h2hPickOpponent =>
      'Wybierz rywala, aby zobaczyć tu wszystkie spotkania';

  @override
  String get savesTitle => 'Zapisy';

  @override
  String get gridColPlayer => 'Zawodnik';

  @override
  String get gridColPos => 'Poz.';

  @override
  String get gridColActive => 'Aktywny';

  @override
  String get gridColMotm => 'MVP';

  @override
  String get gridColAvg => 'Śr.';

  @override
  String get gridColOpponent => 'Rywal';

  @override
  String get gridColStarts => 'W podstawie';

  @override
  String get gridColTournaments => 'Turnieje';

  @override
  String get gridColDate => 'Data';

  @override
  String get gridColLastPlayed => 'Ostatnio grane';

  @override
  String get gridColManager => 'Trener';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reprezentacji',
      many: '$count reprezentacji',
      few: '$count reprezentacje',
      one: '1 reprezentacja',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Według rankingu światowego';

  @override
  String get nationsStrength => 'Siła';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier z 5';
  }

  @override
  String get nationsSquadOverall => 'Ocena kadry';

  @override
  String get nationsOpeningBudget => 'Budżet na start';

  @override
  String get nationsStarPlayer => 'Gwiazda drużyny';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Gwiazda $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Wiek $age';
  }

  @override
  String get nationsBoardExpects => 'Zarząd oczekuje';

  @override
  String nationsManage(String nation) {
    return 'Obejmij kadrę ($nation)';
  }

  @override
  String get nationsManagerNext => 'Imię trenera podasz w następnym kroku';

  @override
  String get playerPageTitle => 'Zawodnik';

  @override
  String get nationPageTitle => 'Reprezentacja';

  @override
  String get friendliesYourGames => 'Twoje sparingi';
}
