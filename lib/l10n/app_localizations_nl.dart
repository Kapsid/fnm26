// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get matchPreviewTitle => 'WEDSTRIJDVOORBESCHOUWING';

  @override
  String get matchKickOff => 'Aftrap';

  @override
  String get matchTactics => 'Tactiek';

  @override
  String get matchYourXi => 'JOUW BASISELF';

  @override
  String get matchHeadToHead => 'ONDERLINGE DUELLEN';

  @override
  String matchCouldNotLoad(String error) {
    return 'Wedstrijd kon niet worden geladen.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Geen komende wedstrijd.';

  @override
  String get matchUnknownNation => 'Onbekend';

  @override
  String get matchH2hFirstMeeting => 'Allereerste ontmoeting';

  @override
  String get matchH2hYouLead => 'Jij staat voor in de onderlinge duels';

  @override
  String matchH2hOppEdge(String opponent) {
    return '$opponent heeft de overhand';
  }

  @override
  String get matchH2hEven => 'Gelijke stand';

  @override
  String matchH2hMet(int count) {
    return '$count keer ontmoet';
  }

  @override
  String get matchH2hWon => 'Gewonnen';

  @override
  String get matchH2hDrawn => 'Gelijk';

  @override
  String get matchH2hLost => 'Verloren';

  @override
  String get matchDossierTitle => 'Scoutingrapport';

  @override
  String get matchDossierForm => 'VORM';

  @override
  String get matchDossierNoGames => 'Geen recente wedstrijden';

  @override
  String get matchDossierKeyMen => 'SLEUTELSPELERS';

  @override
  String get matchDossierHowTheyPlay => 'SPEELWIJZE';

  @override
  String matchScoutFormation1(String formation) {
    return 'Meestal spelen ze in een $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Hun vaste formatie is een $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'Ze kiezen meestal voor een $formation.';
  }

  @override
  String get matchScoutStrengthPressing =>
      'Ze zetten hoog druk en jagen op de bal.';

  @override
  String get matchScoutStrengthDirect =>
      'Ze spelen direct en brengen de bal snel naar voren.';

  @override
  String get matchScoutStrengthPossession =>
      'Ze houden de bal goed en bouwen geduldig op.';

  @override
  String get matchScoutStrengthCounter =>
      'Ze wachten af en counteren razendsnel.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'Ze verdedigen diep en zijn moeilijk open te spelen.';

  @override
  String get matchScoutStrengthWide =>
      'Ze trekken het veld breed en vallen aan over de flanken.';

  @override
  String get matchScoutStrengthAttacking =>
      'Ze nemen graag het initiatief en gaan op de tegenstander af.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Hun aanvallers zijn snel en lopen graag in de diepte.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Hun middenveld passt de bal goed rond.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Hun middenveld kan de hele wedstrijd blijven lopen.';

  @override
  String get matchScoutStrengthSetPieces =>
      'Uit standaardsituaties zijn ze gevaarlijk.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Hun verdediging is snel en moeilijk in de rug te nemen.';

  @override
  String get matchScoutStrengthNone => 'Er springt niets echt uit in hun spel.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Hun hoge linie laat ruimte in de rug voor een lange bal.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Hoog druk zetten kan hun trage opbouw ontregelen.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Wees geduldig: zo\'n diep blok valt open te spelen.';

  @override
  String get matchScoutWeakLongBall =>
      'Laat je linie zakken en hun lange ballen hebben geen ruimte meer.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Hun verdedigers missen snelheid, dus stuur lopers in hun rug.';

  @override
  String get matchScoutWeakAerial =>
      'Bij het verdedigen van standaardsituaties ogen ze wankel.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Hun middenveld komt moeilijk onder druk uit met korte passes.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Hun middenveld mist de benen om lang druk te zetten.';

  @override
  String get matchScoutWeakBluntAttack => 'Hun aanvallers missen snelheid.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Tegen jou zullen ze waarschijnlijk het initiatief nemen.';

  @override
  String get matchScoutApproachEven =>
      'Tegen jou wordt het waarschijnlijk een spannende, gelijkopgaande strijd.';

  @override
  String get matchScoutApproachSitDeep =>
      'Tegen jou zullen ze waarschijnlijk voorzichtig spelen en loeren op de counter.';

  @override
  String get matchScoutLeaningAttacking =>
      'Van een afstand lijken ze een aanvallend team.';

  @override
  String get matchScoutLeaningCautious =>
      'Van een afstand lijken ze een voorzichtig team.';

  @override
  String get matchScoutLeaningUnclear =>
      'Van een afstand is moeilijk te zeggen hoe ze graag spelen.';

  @override
  String get matchScoutHireHint =>
      'Neem een hoofdscout aan om te ontdekken hoe ze spelen.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Doorgaan lukte niet: $error';
  }

  @override
  String get matchSkipToFullTime => 'Door naar het eindsignaal';

  @override
  String get matchStatShots => 'Schoten';

  @override
  String get matchStatGoals => 'Doelpunten';

  @override
  String get matchStatYellowCards => 'Geel';

  @override
  String get matchStatRedCards => 'Rood';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'AAN';

  @override
  String get matchSwingDef => 'VER';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'WK $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'DE EINDRONDE BEGINT';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'GEORGANISEERD DOOR  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'GASTHEER NOG NIET BEKEND';

  @override
  String get matchHalfTime => 'RUST';

  @override
  String matchHalfTimeScore(int home, int away) {
    return 'Rust $home : $away';
  }

  @override
  String get matchContinue => 'Doorgaan';

  @override
  String get matchContinuing => 'Bezig…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Tactiek · $used/$max wissels';
  }

  @override
  String matchTiredCount(int count) {
    return 'MOE ×$count';
  }

  @override
  String get matchTacticsLabel => 'TACTIEK';

  @override
  String get teamOverallOverTime => 'TOTAALCIJFER IN DE LOOP VAN DE TIJD';

  @override
  String get teamOverall => 'Totaalcijfer';

  @override
  String get teamTalkHeading => 'TEAMTALK';

  @override
  String get teamTalkPrompt => 'Bepaal de toon voor de tweede helft.';

  @override
  String get teamTalkCalmLabel => 'Koel blijven';

  @override
  String get teamTalkCalmBlurb =>
      'Breng rust in de ploeg. Een kleine opleving over de hele linie.';

  @override
  String get teamTalkEncourageLabel => 'Aanmoedigen';

  @override
  String get teamTalkEncourageBlurb => 'Zet door en ga voor de wedstrijd.';

  @override
  String get teamTalkDemandMoreLabel => 'Meer eisen';

  @override
  String get teamTalkDemandMoreBlurb => 'Gooi alles in de strijd. Val fel aan.';

  @override
  String get teamTalkPraiseLabel => 'Compact blijven';

  @override
  String get teamTalkPraiseBlurb => 'Houd het compact en bescherm wat je hebt.';

  @override
  String get teamTalkBelieveLabel => 'Geloof erin';

  @override
  String get teamTalkBelieveBlurb =>
      'Geloof in jezelf. Een impuls voor voor- en achterin.';

  @override
  String get teamTalkFocusLabel => 'Scherp blijven';

  @override
  String get teamTalkFocusBlurb =>
      'Volledige concentratie. Zet de boel op slot.';

  @override
  String get teamTalkUrgencyLabel => 'Gevoel van urgentie';

  @override
  String get teamTalkUrgencyBlurb =>
      'Jaag nu op de winst. Alles of niets, en dat laat ruimte open.';

  @override
  String get teamTalkReassureLabel => 'Geen druk';

  @override
  String get teamTalkReassureBlurb =>
      'Kalmeer de zenuwen en houd je vorm vast.';

  @override
  String get commonRetry => 'Opnieuw';

  @override
  String get commonSomethingWentWrong => 'Er ging iets mis';

  @override
  String get commonCrashBox =>
      'Hier ging iets mis.\nInstellingen → Diagnostiek heeft de details.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'De wereld kon niet verder: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostiek';

  @override
  String get settingsDiagnosticsBlurb =>
      'Fouten die op dit apparaat zijn vastgelegd. Er wordt niets verstuurd.';

  @override
  String get settingsContactTitle => 'Contact';

  @override
  String get settingsContactCopied => 'Adres gekopieerd.';

  @override
  String get settingsCommunityTitle => 'Community';

  @override
  String get settingsDiscordSubtitle => 'Word lid van de community';

  @override
  String get settingsLinkCopied => 'Link gekopieerd.';

  @override
  String get diagnosticsEmpty => 'Geen fouten vastgelegd. Zo hoort het.';

  @override
  String get diagnosticsCopy => 'Kopiëren';

  @override
  String get diagnosticsCopied => 'Log gekopieerd naar het klembord.';

  @override
  String get diagnosticsClear => 'Wissen';

  @override
  String get navHub => 'Hoofdmenu';

  @override
  String get navSquad => 'Selectie';

  @override
  String get navStandings => 'Standen';

  @override
  String get navCareers => 'Mijn loopbaan';

  @override
  String get settingsTitle => 'INSTELLINGEN';

  @override
  String get settingsSoundHapticsTitle => 'Geluid en trillingen';

  @override
  String get settingsSoundHapticsBlurb =>
      'Trilling en een korte toon bij doelpunten, aftrap en eindsignaal.';

  @override
  String get settingsLanguageTitle => 'Taal';

  @override
  String get settingsLanguageBlurb =>
      'Kies de taal van de app, of volg je apparaat.';

  @override
  String get settingsLanguageSystem => 'Systeem';

  @override
  String get settingsTextSizeTitle => 'Tekstgrootte';

  @override
  String get settingsTextSizeBlurb =>
      'Maak de tekst groter als die moeilijk te lezen is.';

  @override
  String get settingsTextSizeNormal => 'Normaal';

  @override
  String get settingsTextSizeLarge => 'Groot';

  @override
  String get settingsTextSizeLarger => 'Groter';

  @override
  String get matchPreviewAllMeetings => 'Alle ontmoetingen';

  @override
  String get recordsMeetings => 'ONTMOETINGEN';

  @override
  String get recordsLegends => 'LEGENDES';

  @override
  String get recordsAllTimeXi => 'ELFTAL ALLER TIJDEN';

  @override
  String get recordsHallOfFame => 'HALL OF FAME';

  @override
  String get recordsAllTimeWorld => 'ALLER TIJDEN WERELDWIJD';

  @override
  String get recordsAllTimeTopScorers => 'TOPSCORERS ALLER TIJDEN';

  @override
  String get recordsMostCapped => 'MEESTE INTERLANDS';

  @override
  String get recordsMostWcStarts => 'MEESTE BASISPLAATSEN OP HET WK';

  @override
  String get recordsMostTournaments => 'MEESTE TOERNOOIEN';

  @override
  String get recordsRecordBook => 'RECORDBOEK';

  @override
  String get recordsHeadToHead => 'ONDERLINGE DUELLEN';

  @override
  String get recordsFiercestRival => 'FELSTE RIVAAL';

  @override
  String get recordsMostCaps => 'MEESTE INTERLANDS';

  @override
  String get recordsTopScorers => 'TOPSCORERS';

  @override
  String get recordsMostAssists => 'MEESTE ASSISTS';

  @override
  String get recordsYourRecord => 'JOUW RECORD';

  @override
  String get callUpHome => 'THUIS';

  @override
  String get callUpAway => 'UIT';

  @override
  String get recordsHome => 'THUIS';

  @override
  String get recordsAway => 'UIT';

  @override
  String get recordsActive => 'ACTIEF';

  @override
  String get recordsStillActive => 'Nog actief';

  @override
  String get recordsAvg => 'gem.';

  @override
  String get recordsSelect => 'Kies';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Gelijk';

  @override
  String get recordsGoalsLabel => 'Doelpunten';

  @override
  String get recordsBestFinish => 'Beste resultaat';

  @override
  String get recordsNoFinalsYet => 'Nog geen eindronde bereikt';

  @override
  String get recordsLongestUnbeaten => 'Langste reeks zonder nederlaag';

  @override
  String get recordsBiggestWin => 'Grootste zege';

  @override
  String get recordsSeeAllMeetings => 'Alle ontmoetingen bekijken';

  @override
  String get recordsSaveNotFound => 'Opgeslagen spel niet gevonden.';

  @override
  String get recordsNoMatches => 'Geen resultaten.';

  @override
  String get recordsSearchPlayerOrNation => 'Zoek speler of land';

  @override
  String get recordsSearchNation => 'Zoek land';

  @override
  String get recordsPickTwoDifferent => 'Kies twee verschillende landen.';

  @override
  String get recordsPlayToBuildRecord =>
      'Speel enkele wedstrijden en je record tegen elke tegenstander wordt hier opgebouwd.';

  @override
  String get recordsTapOpponent =>
      'Tik op een tegenstander voor het volledige overzicht.';

  @override
  String get recordsEdgeUpperHand => 'Jij hebt de overhand';

  @override
  String get recordsEdgeTheirNumber => 'Zij hebben jouw nummer';

  @override
  String get recordsEdgeEven => 'Gelijke stand';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Wereldwijde scorers en meeste interlands, elk land';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Vergelijk het record aller tijden van twee landen';

  @override
  String get recordsLegendsSubtitle => 'Elftal aller tijden en hall of fame';

  @override
  String get recordsUnitGoals => 'doelpunten';

  @override
  String get recordsUnitCaps => 'interlands';

  @override
  String get recordsUnitStarts => 'basisplaatsen';

  @override
  String get recordsUnitCups => 'toernooien';

  @override
  String get recordsUnitAssists => 'assists';

  @override
  String recordsCapsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count interlands',
      one: '1 interland',
    );
    return '$_temp0';
  }

  @override
  String recordsGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doelpunten',
      one: '1 doelpunt',
    );
    return '$_temp0';
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
    return '$count MvdW';
  }

  @override
  String recordsMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wedstrijden',
      one: '1 wedstrijd',
    );
    return '$_temp0';
  }

  @override
  String recordsMeetingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ontmoetingen',
      one: '1 ontmoeting',
    );
    return '$_temp0';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code wint';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings ontmoetingen',
      one: '1 ontmoeting',
    );
    return '$_temp0 · ${wins}W ${draws}G ${losses}V';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}W ${draws}G ${losses}V';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    String _temp0 = intl.Intl.pluralLogic(
      meetings,
      locale: localeName,
      other: '$meetings ontmoetingen',
      one: '1 ontmoeting',
    );
    return '$_temp0 · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a en $b hebben elkaar in dit spel nog nooit ontmoet.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names van het veld gestuurd. Geen vervanger, dus je speelt met een man minder.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return '$required beschikbaar nodig ($have fit)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Mist $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Mist de hele oproepperiode';

  @override
  String get rankingCentreOnMe => 'Naar mijn land';

  @override
  String get recordsAfterExtraTime => 'n.v.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b str.';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played gespeeld · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga tegen $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Laden is mislukt.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Legendes konden niet worden geladen.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Records konden niet worden geladen.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Landen konden niet worden geladen.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Jouw record kon niet worden geladen.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Record kon niet worden geladen.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Nog geen legendes. Speel een paar campagnes uit en de grootsten van $nation verschijnen hier.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Het grootste elftal dat $nation ooit kon opstellen.';
  }

  @override
  String get recordsNoWorldHistory =>
      'De wereld heeft nog geen geschiedenis. Speel een paar campagnes uit en de grootsten aller tijden verschijnen hier.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Speel enkele wedstrijden om de geschiedenis van $nation te gaan schrijven.';
  }

  @override
  String get tacticsLineGk => 'KEE';

  @override
  String get tacticsLineDef => 'VER';

  @override
  String get tacticsLineMid => 'MID';

  @override
  String get tacticsLineFwd => 'AAN';

  @override
  String get tacticsGoalkeepers => 'KEEPERS';

  @override
  String get tacticsDefenders => 'VERDEDIGERS';

  @override
  String get tacticsMidfielders => 'MIDDENVELDERS';

  @override
  String get tacticsForwards => 'AANVALLERS';

  @override
  String get tacticsCallUpsTitle => 'OPROEPEN';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Kies minstens $min spelers.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Selectie kon niet worden geladen.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Geen selectie.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'SELECTIE · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min. $min · Max. $max';
  }

  @override
  String get tacticsBestQuality => 'Beste kwaliteit';

  @override
  String get tacticsPreviousSquad => 'Vorige selectie';

  @override
  String get tacticsSquadLockedBack => 'Terug (selectie vergrendeld)';

  @override
  String get tacticsConfirmSquad => 'Selectie bekendmaken';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Selectie vol (max. $max)';
  }

  @override
  String get tacticsSquadLocked => 'SELECTIE VERGRENDELD';

  @override
  String get tacticsNominationOpen => 'SELECTIEPERIODE OPEN. KIES JE SELECTIE';

  @override
  String get tacticsSquadFixedBlurb =>
      'Deze selectie ligt vast voor de onderstaande wedstrijden. Kies opnieuw vóór de volgende selectieperiode.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Deze selectie speelt de onderstaande wedstrijden.';

  @override
  String get tacticsUnknown => 'Onbekend';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Leeftijd $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Uitgeput';

  @override
  String get tacticsFatigueTired => 'Moe';

  @override
  String get tacticsFatigueMatchLegs => 'Wedstrijdbenen';

  @override
  String tacticsTooManySubs(int max) {
    return 'Te veel wissels (max. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TACTIEK · $minute\'';
  }

  @override
  String get tacticsApply => 'TOEPASSEN';

  @override
  String get tacticsTabLineupSubs => 'OPSTELLING EN WISSELS';

  @override
  String get tacticsTabTactics => 'TACTIEK';

  @override
  String get squadLineKeepers => 'KEEPERS';

  @override
  String get squadLineDefenders => 'VERDEDIGING';

  @override
  String get squadLineMidfielders => 'MIDDENVELD';

  @override
  String get squadLineForwards => 'AANVAL';

  @override
  String get squadStatXiRating => 'Cijfer basiself';

  @override
  String get squadStatAvgAge => 'Gem. leeftijd';

  @override
  String get squadStatSize => 'Selectie';

  @override
  String get squadStatUnavailable => 'Uit';

  @override
  String get squadDepthTitle => 'DIEPTE PER LINIE';

  @override
  String squadAgeShort(int age) {
    return '$age jr';
  }

  @override
  String get tacticsTabOtherPositions => 'ANDERE PLEKKEN';

  @override
  String get tacticsOutOfPositionNote => 'Hier buiten positie';

  @override
  String get tacticsNobodyElse => 'Niemand anders om hier uit te proberen.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Kies wie eraf gaat en de rest van de bank verschijnt hier, met het cijfer waarmee ze deze plek zouden spelen.';

  @override
  String get tacticsTabSuitable => 'GESCHIKT';

  @override
  String get tacticsTabOnPitch => 'IN HET VELD';

  @override
  String tacticsSectionSuitable(int count) {
    return 'GESCHIKT · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Niemand op de bank is van nature geschikt voor deze plek, dus hier is iedereen.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'IN HET VELD · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'BESCHIKBAAR · $count';
  }

  @override
  String get tacticsRowStarted => 'Basisspeler';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Erin op $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Erin gekomen';

  @override
  String get tacticsEnergyLabel => 'ENERGIE';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Tik op een vervanger voor $name, of tik nogmaals op hem om te annuleren.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Een rode kaart kostte je deze plek. Sleep een teamgenoot hierheen om het gat te verplaatsen.';

  @override
  String get tacticsSentOffShort => 'UITGESLOTEN';

  @override
  String get tacticsFullBackLeft => 'Linksback';

  @override
  String get tacticsFullBackRight => 'Rechtsback';

  @override
  String get tacticsFullBackUp => 'Opkomen';

  @override
  String get tacticsFullBackDown => 'Achterblijven';

  @override
  String get tacticsFullBackOff => 'Geen instructie';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: opkomen. Iets meer aanval, iets meer risico.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: achterblijven. Iets veiliger, iets minder aanval.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: geen instructie, speelt volgens het teamplan.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, pijl: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'WISSELS · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Tik op een speler in het veld om hem eraf te halen, of houd een wisselspeler vast en sleep hem erheen.';

  @override
  String get tacticsNoSubs => 'Geen wisselspelers beschikbaar.';

  @override
  String get tacticsChooseShape => 'KIES EEN FORMATIE';

  @override
  String get tacticsFormation => 'FORMATIE';

  @override
  String get tacticsInstructions => 'INSTRUCTIES';

  @override
  String get tacticsDrilling => 'INGESTUDEERD';

  @override
  String get tacticsDrillingUnplayed => 'ONGESPEELD';

  @override
  String get tacticsDrillingNew => 'NIEUW';

  @override
  String get tacticsDrillingSettling => 'WENNEN';

  @override
  String get tacticsDrillingDrilled => 'INGESLEPEN';

  @override
  String get tacticsInstrMentality => 'Mentaliteit';

  @override
  String get tacticsInstrDefensive => 'Verdedigend';

  @override
  String get tacticsInstrAttacking => 'Aanvallend';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Laag blok';

  @override
  String get tacticsInstrHighPress => 'Hoge pressing';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Geduldig';

  @override
  String get tacticsInstrFast => 'Snel';

  @override
  String get tacticsInstrWidth => 'Breedte';

  @override
  String get tacticsInstrNarrow => 'Smal';

  @override
  String get tacticsInstrWide => 'Breed';

  @override
  String get tacticsInstrDefLine => 'Verd.lijn';

  @override
  String get tacticsInstrDefensiveLine => 'Verdedigingslijn';

  @override
  String get tacticsInstrDeep => 'Diep';

  @override
  String get tacticsInstrHigh => 'Hoog';

  @override
  String get tacticsInstrDirectness => 'Directheid';

  @override
  String get tacticsInstrPossession => 'Balbezit';

  @override
  String get tacticsInstrDirect => 'Direct';

  @override
  String get tacticsPickGoalkeeper => 'KIES KEEPER';

  @override
  String get tacticsPickLeftBack => 'KIES LINKSBACK';

  @override
  String get tacticsPickCentreBack => 'KIES CENTRALE VERDEDIGER';

  @override
  String get tacticsPickRightBack => 'KIES RECHTSBACK';

  @override
  String get tacticsPickDefensiveMid => 'KIES VERDEDIGENDE MIDDENVELDER';

  @override
  String get tacticsPickCentralMid => 'KIES CENTRALE MIDDENVELDER';

  @override
  String get tacticsPickAttackingMid => 'KIES AANVALLENDE MIDDENVELDER';

  @override
  String get tacticsPickLeftMid => 'KIES LINKSMIDDEN';

  @override
  String get tacticsPickRightMid => 'KIES RECHTSMIDDEN';

  @override
  String get tacticsPickLeftWing => 'KIES LINKSBUITEN';

  @override
  String get tacticsPickRightWing => 'KIES RECHTSBUITEN';

  @override
  String get tacticsPickStriker => 'KIES SPITS';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · buiten positie';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Leeftijd $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Leeftijd $age';
  }

  @override
  String get tacticsOn => 'IN';

  @override
  String get tacticsSquad => 'SELECTIE';

  @override
  String get tacticsTabLineup => 'OPSTELLING';

  @override
  String get tacticsTabInstructions => 'INSTRUCTIES';

  @override
  String get tacticsTabRoles => 'ROLLEN';

  @override
  String get tacticsTabSetPieces => 'STANDAARDSITUATIES';

  @override
  String get tacticsTabRolesSetPieces => 'ROLLEN EN STANDAARDSITUATIES';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Geef elke basisspeler een rol. Tik op de penalty-badge (⚽) of vrije-trap-badge (▲) om je nemer te kiezen.';

  @override
  String get tacticsTooltipCallUps => 'Oproepen';

  @override
  String get tacticsTooltipPresets => 'Tactiekvoorinstellingen';

  @override
  String get tacticsTooltipInstructions => 'Instructies';

  @override
  String get tacticsNoTacticSet => 'Geen tactiek ingesteld.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'VERVANG $count BASISSPELERS',
      one: 'VERVANG $count BASISSPELER',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Uit';

  @override
  String get tacticsTapSpotReplace =>
      'Tik op hun plek in het veld om een vervanger te kiezen.';

  @override
  String get tacticsTapOrDrag =>
      'Tik op een speler om hem te wisselen, of houd er een vast en sleep hem om te verplaatsen.';

  @override
  String get tacticsPlayerRoles => 'SPELERSROLLEN';

  @override
  String get tacticsRolesBlurb =>
      'Geef een speler een taak: een afmaker, een spelmaker, een targetman. Bepaalt wie scoort en wie creëert.';

  @override
  String get tacticsSetPieceTakers => 'NEMERS VAN STANDAARDSITUATIES';

  @override
  String get tacticsSetPieceBlurb =>
      'Wie penalty\'s en spelhervattingen neemt, of laat het over aan de best geschikte speler.';

  @override
  String get tacticsTakerAuto => 'Automatisch';

  @override
  String get tacticsTakerQuickPick => 'Beste nemers gebruiken';

  @override
  String get tacticsPenalties => 'Penalty\'s';

  @override
  String get tacticsCornersFreeKicks => 'Hoekschoppen en vrije trappen';

  @override
  String get tacticsThrowIns => 'Ingooien';

  @override
  String get tacticsThrowInStyle => 'Ingooistijl';

  @override
  String get tacticsThrowInLong => 'Lange ingooien';

  @override
  String get tacticsThrowInNeutral => 'Neutraal';

  @override
  String get tacticsThrowInDefensive => 'Veilige ingooien';

  @override
  String get tacticsThrowInLongBlurb =>
      'Ingooien bij de zestien gaan de zestien in. Iets meer dreiging, vooral met een sterke werper en lange aanvallers, maar de bal gaat wat vaker verloren.';

  @override
  String get tacticsThrowInNeutralBlurb =>
      'Ingooien zoals het spel het toelaat. Er verandert niets.';

  @override
  String get tacticsThrowInDefensiveBlurb =>
      'Elke ingooi kort en veilig. Minder balverlies waaruit gecounterd wordt, en iets minder kansen.';

  @override
  String get matchGoalLongThrow => 'LANGE INGOOI';

  @override
  String get tacticsSkillFin => 'AFW';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROL · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'PENALTYNEMER';

  @override
  String get tacticsCornerFreeKickTaker => 'NEMER HOEKSCHOP EN VRIJE TRAP';

  @override
  String get tacticsAutomatic => 'Automatisch';

  @override
  String get tacticsLetBestSuited => 'Laat de best geschikte speler nemen.';

  @override
  String get tacticsInXi => 'IN BASISELF';

  @override
  String get tacticsTeamInstructions => 'TEAMINSTRUCTIES';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Bepaal hoe je ploeg speelt. Elke regelaar duwt het hele team een beetje.';

  @override
  String tacticsSavedPreset(String name) {
    return '“$name” opgeslagen';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return '“$name” toegepast';
  }

  @override
  String get tacticsTacticPresets => 'TACTIEKVOORINSTELLINGEN';

  @override
  String get tacticsPresetsBlurb =>
      'Sla deze formatie op als herbruikbare stijl, of pas er een toe die je eerder opsloeg.';

  @override
  String get tacticsSaveCurrentTactic => 'Huidige tactiek opslaan';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Voorinstellingen konden niet worden geladen.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Nog geen voorinstellingen. Tik op “Huidige tactiek opslaan” om deze opzet als herbruikbare stijl te bewaren.';

  @override
  String get tacticsNameThisTactic => 'Geef deze tactiek een naam';

  @override
  String get tacticsNameHint => 'bijv. Hoge pressing 4-3-3';

  @override
  String get tacticsCancel => 'Annuleren';

  @override
  String get tacticsSave => 'Opslaan';

  @override
  String get tacticsTapToAssign => 'Tik om toe te wijzen';

  @override
  String get tacticsHoldDragSub =>
      'Houd een wisselspeler vast en sleep hem naar een speler om hem erin te brengen.';

  @override
  String get hubContinue => 'Doorgaan';

  @override
  String get hubBrackets => 'Schema\'s';

  @override
  String hubCouldNotLoad(String error) {
    return 'Laden is mislukt.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Financiën konden niet worden geladen.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Opgeslagen spel kon niet worden geladen.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Opgeslagen spel niet gevonden.';

  @override
  String get hubUnknown => 'Onbekend';

  @override
  String hubWorldChampionsYear(int year) {
    return 'WERELDKAMPIOEN $year';
  }

  @override
  String get hubCycleComplete => 'De cyclus is voltooid.';

  @override
  String get hubYourJob => 'JOUW BAAN';

  @override
  String get hubStayProject => 'Blijf en zet je project voort';

  @override
  String get hubChooseNextJob => 'KIES JE VOLGENDE BAAN';

  @override
  String get hubOffersOnTable => 'AANBIEDINGEN OP TAFEL';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · wereld #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Doorgaan met $nation';
  }

  @override
  String get hubYourNation => 'jouw land';

  @override
  String get hubTakeTheJob => 'Neem de baan aan';

  @override
  String get hubFederationFinances => 'BONDSFINANCIËN';

  @override
  String get hubBudgetIntro =>
      'Je eerste taak volgende cyclus is het bondsbudget vaststellen en over de afdelingen verdelen.';

  @override
  String get hubStarting => 'Bezig met starten…';

  @override
  String get hubBeginNextCycle => 'Volgende cyclus beginnen';

  @override
  String get hubContinueCareer => 'Zet je loopbaan voort';

  @override
  String get hubBackToSaves => 'Terug naar je opslag';

  @override
  String get hubOpeningBalance => 'Beginsaldo';

  @override
  String get hubCentralFunding => 'Centrale financiering';

  @override
  String get hubPrizeMoney => 'Prijzengeld';

  @override
  String get hubCommercialReturn => 'Commerciële opbrengst';

  @override
  String get hubAvailableToInvest => 'Beschikbaar om te investeren';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputatie: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Nationale held';

  @override
  String get hubFinal => 'Finale';

  @override
  String get hubStageRoundOf32 => 'Zestiende finale';

  @override
  String get hubStageThirdPlace => 'Wedstrijd om de derde plaats';

  @override
  String get hubEventAdvanceWorld => 'Laat de wereld doorgaan';

  @override
  String hubEventStartCycle(int year) {
    return 'Start de cyclus van $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return '$nation is wereldkampioen';
  }

  @override
  String get hubEventSetBudget => 'Stel je bondsbudget vast';

  @override
  String get hubEventSetBudgetSub =>
      'Verdeel de oorlogskas van deze cyclus voordat het seizoen begint';

  @override
  String get hubEventNaturalization => 'Naturalisatieaanbod bekijken';

  @override
  String get hubEventNaturalizationSub =>
      'Een buitenlandse speler wil voor jou uitkomen';

  @override
  String get hubEventCampaignVerdict => 'Campagne beslist: bekijk het oordeel';

  @override
  String get hubEventCampaignComplete => 'Campagne voltooid';

  @override
  String get hubEventIntercontinentalPlayoff => 'De intercontinentale play-off';

  @override
  String get hubEventWatchWcDraw =>
      'Bekijk de loting van het Wereldkampioenschap';

  @override
  String get hubEventWorldCupHere => 'Het Wereldkampioenschap is begonnen';

  @override
  String get hubEventWatchFinalsDraw => 'Bekijk de loting van de eindronde';

  @override
  String get hubEventFinalsHere => 'De eindronde is begonnen';

  @override
  String get hubEventPlayWcRound =>
      'Speel de volgende ronde van het Wereldkampioenschap';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Speel de volgende wedstrijd van $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Speel de volgende Nations Cup-wedstrijd';

  @override
  String get hubEventWatchNationsCupDraw =>
      'Bekijk de loting van de Nations Cup';

  @override
  String get hubEventWatchHostSelection => 'Bekijk de keuze van de gastheer';

  @override
  String get hubEventWatchQualifyingDraw => 'Bekijk de kwalificatieloting';

  @override
  String get hubEventWatchWcHostSelection =>
      'Bekijk de keuze van de gastheer van het Wereldkampioenschap';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Bekijk de kwalificatieloting van het Wereldkampioenschap';

  @override
  String get hubEventArrangeFriendlies => 'Oefenwedstrijden regelen';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Je hebt je $count open oefenperiodes nog niet gevuld',
      one: 'Je hebt je open oefenperiode nog niet gevuld',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Hervorm je basiself';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count spelers uit je basiself vallen uit (geschorst of geblesseerd). Kies vervangers',
      one:
          '1 speler uit je basiself valt uit (geschorst of geblesseerd). Kies een vervanger',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Je basiself is niet compleet. Vul de open plekken',
      one: 'Je basiself is niet compleet. Vul de open plek',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Speel tegen $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'de continentale eindronde';

  @override
  String get hubCallUpFriendlies =>
      'Maak je selectie bekend voor de oefenwedstrijden';

  @override
  String get hubCallUpRequalify =>
      'Maak je kwalificatieselectie opnieuw bekend';

  @override
  String get hubCallUpWorldCup =>
      'Maak je selectie voor het Wereldkampioenschap bekend';

  @override
  String get hubCallUpFinals => 'Maak je selectie voor de eindronde bekend';

  @override
  String get hubCallUpNationsCup => 'Maak je Nations Cup-selectie bekend';

  @override
  String get hubCallUpQualifying => 'Maak je kwalificatieselectie bekend';

  @override
  String get hubCallUpGeneric => 'Maak je selectie bekend';

  @override
  String get hubHost => 'Gastheer';

  @override
  String get hubGoldenBoot => 'Gouden Schoen';

  @override
  String hubGoldenBootValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals doelpunten',
      one: '1 doelpunt',
    );
    return '$name · $_temp0';
  }

  @override
  String get hubPens => '(str.)';

  @override
  String get hubNationalHub => 'BONDSBUREAU';

  @override
  String get hubMessages => 'Berichten';

  @override
  String get hubWorldChampions => 'WERELDKAMPIOEN';

  @override
  String get hubViewBracket => 'Schema bekijken ›';

  @override
  String get hubBoardDelighted => 'Opgetogen';

  @override
  String get hubBoardPleased => 'Tevreden';

  @override
  String get hubBoardExpectingMore => 'Verwacht meer';

  @override
  String get hubBoardConcerned => 'Bezorgd';

  @override
  String get hubBoardJobAtRisk => 'Baan in gevaar';

  @override
  String get hubBoard => 'BESTUUR';

  @override
  String hubBoardObjective(String label) {
    return 'Bestuursdoel: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'BEHAALD · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'GEMIST · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Geen wedstrijden meer in deze cyclus.';

  @override
  String get hubVs => 'TEGEN';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Wereldranglijst';

  @override
  String get hubSquadStatus => 'STATUS SELECTIE';

  @override
  String hubPlayers(int count) {
    return '$count spelers';
  }

  @override
  String get hubAvgRating => 'Gem. cijfer';

  @override
  String get hubMorale => 'Moraal';

  @override
  String get hubManageTeam => 'Team beheren';

  @override
  String get hubGroupsToBeDrawn =>
      'De groepen moeten nog worden geloot. Bekijk de loting om ze te onthullen.';

  @override
  String hubGroupName(String name) {
    return 'GROEP $name';
  }

  @override
  String get hubTblTeam => 'TEAM';

  @override
  String get hubTblP => 'GS';

  @override
  String get hubTblGd => 'DS';

  @override
  String get hubTblPts => 'PNT';

  @override
  String get homeSettings => 'Instellingen';

  @override
  String get homeLeadTheNation => 'LEID HET LAND';

  @override
  String get homeYourNation => 'jouw land';

  @override
  String get homeNewGame => 'Nieuw spel';

  @override
  String get homeAllSaves => 'Alle opslag';

  @override
  String get homeLoadGame => 'Spel laden';

  @override
  String get homeContinue => 'DOORGAAN';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · De weg naar het Wereldkampioenschap van $year';
  }

  @override
  String get careerManageSaves => 'Opslag beheren';

  @override
  String get careerNewGameTitle => 'NIEUW SPEL';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Land kon niet worden geladen.\n$error';
  }

  @override
  String get careerNationNotFound => 'Land niet gevonden.';

  @override
  String careerWorldRankNum(int rank) {
    return 'WERELDRANGLIJST #$rank';
  }

  @override
  String get careerManagerName => 'Naam bondscoach';

  @override
  String get careerManagerNameHint => 'bijv. Louis van Gaal';

  @override
  String get careerBeginsBlurb =>
      'Je loopbaan begint in september 2026, op weg naar het Wereldkampioenschap van 2030.';

  @override
  String get careerFreeCycleNote =>
      'Gratis voor één volledige cyclus van vier jaar: kwalificatie, je continentale kampioenschap en het Wereldkampioenschap, met twee opgeslagen spellen. Daarna ontgrendelt één betaling eindeloze cycli.';

  @override
  String get careerStartCareer => 'Loopbaan beginnen';

  @override
  String get careersTitle => 'LOOPBANEN';

  @override
  String get careerManagerCareer => 'Loopbaan als bondscoach';

  @override
  String get careerManagerCareerSubtitle =>
      'Elke cyclus die je hebt geleid en je totale staat van dienst';

  @override
  String get careerSummaryTitle => 'Loopbaanoverzicht';

  @override
  String get careerSummarySubtitle =>
      'Je prijzenkast en je record als bondscoach';

  @override
  String get careerAchievements => 'Prestaties';

  @override
  String get careerAchievementsSubtitle =>
      'Mijlpalen, titels en tevredenheid van het bestuur';

  @override
  String get careerChallenges => 'Uitdagingen';

  @override
  String get careerChallengesSubtitle =>
      'Loodzware loopbaantesten om aan te pakken';

  @override
  String get careerTeamRecords => 'Teamrecords';

  @override
  String get careerTeamRecordsSubtitle =>
      'Topscorers en meeste interlands aller tijden';

  @override
  String get careerMyMatches => 'Mijn wedstrijden';

  @override
  String get careerMyMatchesSubtitle => 'Elke uitslag en aankomende wedstrijd';

  @override
  String get careerTitle => 'LOOPBAAN';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Loopbaan kon niet worden geladen.\n$error';
  }

  @override
  String get careerNoCareer => 'Geen loopbaan.';

  @override
  String get careerTrophyCabinet => 'PRIJZENKAST';

  @override
  String get careerTournamentHistory => 'TOERNOOIGESCHIEDENIS';

  @override
  String get careerNoTournamentsYet => 'Nog geen toernooien afgerond.';

  @override
  String get careerTeamFallback => 'Team';

  @override
  String careerWorldNum(int rank) {
    return 'WERELD #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PNT';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SEIZOEN $season';
  }

  @override
  String get careerStatPlayedShort => 'GS';

  @override
  String get careerStatsHeading => 'IN CIJFERS';

  @override
  String get careerStatsWinRate => 'Winstpercentage';

  @override
  String get careerStatsGoalsFor => 'Doelpunten voor';

  @override
  String get careerStatsGoalsAgainst => 'Doelpunten tegen';

  @override
  String get careerStatsGoalDiff => 'Doelsaldo';

  @override
  String get careerStatsCleanSheets => 'Clean sheets';

  @override
  String get careerStatsBiggestWin => 'Grootste winst';

  @override
  String get careerStatsWinStreak => 'Reeks zeges';

  @override
  String get careerStatsUnbeaten => 'Reeks zonder nederlaag';

  @override
  String get careerStatsShootouts => 'Strafschoppenseries';

  @override
  String get careerStatsHatTricks => 'Hattricks';

  @override
  String get careerStatsMotms => 'Man van de wedstrijd';

  @override
  String get careerStatsBestRating => 'Hoogste cijfer';

  @override
  String get careerStatWonShort => 'W';

  @override
  String get careerStatDrawnShort => 'G';

  @override
  String get careerStatLostShort => 'V';

  @override
  String get careerStatGoalsForShort => 'DV';

  @override
  String get careerStatGoalsAgainstShort => 'DT';

  @override
  String get careerStatGoalDiffShort => 'DS';

  @override
  String get careerNoSilverware => 'Nog geen prijzen. Ga er een winnen.';

  @override
  String get careerMedalGold => 'GOUD';

  @override
  String get careerMedalSilver => 'ZILVER';

  @override
  String get careerMedalBronze => 'BRONS';

  @override
  String careerWinnersName(String name) {
    return 'Winnaar: $name';
  }

  @override
  String get careerSavesTitle => 'OPSLAGEN';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Opgeslagen spellen konden niet worden geladen.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'PLEKKEN  $used/$limit';
  }

  @override
  String get careerThisSave => 'dit spel';

  @override
  String get careerSlotsFull => 'Plekken vol';

  @override
  String careerSlotsUsed(int used) {
    return 'PLEKKEN  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Meer opslagplekken ontgrendelen';

  @override
  String get careerSlotsKeepNote =>
      'Elk opgeslagen spel dat je al hebt, blijft speelbaar. Alleen een nieuw spel vraagt om de ontgrendeling.';

  @override
  String get careerNewGame => 'Nieuw spel';

  @override
  String get careerDeleteSaveTitle => 'Opgeslagen spel verwijderen?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Hiermee verwijder je je loopbaan met $label definitief.';
  }

  @override
  String get careerCancel => 'Annuleren';

  @override
  String get careerDelete => 'Verwijderen';

  @override
  String get careerNoSavesYet =>
      'Nog geen opgeslagen spellen.\nBegin een nieuw spel om een land te leiden.';

  @override
  String get careerUnknownNation => 'Onbekend';

  @override
  String careerPlayedMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '$hours u $minutes min';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Laatst gespeeld: $when';
  }

  @override
  String get careerJustNow => 'zojuist';

  @override
  String get careerYesterday => 'gisteren';

  @override
  String careerMinutesAgo(int n) {
    return '$n min geleden';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n u geleden';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n d geleden';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Op weg naar het Wereldkampioenschap van $year';
  }

  @override
  String homeNextFixture(String match, String when) {
    return 'Volgende: $match, $when';
  }

  @override
  String homeCycleComplete(int year) {
    return 'Het Wereldkampioenschap van $year is voorbij. Nu volgt het oordeel van de bond.';
  }

  @override
  String homeFollowingFinals(int year) {
    return 'Het Wereldkampioenschap van $year als toeschouwer';
  }

  @override
  String get careerManagerCareerTitle => 'LOOPBAAN ALS BONDSCOACH';

  @override
  String careerCouldNotLoad(String error) {
    return 'Laden is mislukt.\n$error';
  }

  @override
  String get careerCycleByCycle => 'CYCLUS VOOR CYCLUS';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cycli',
      one: '1 cyclus',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations landen geleid',
      one: '1 land geleid',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Titels';

  @override
  String get careerStatPlayed => 'Gespeeld';

  @override
  String get careerStatWon => 'Gewonnen';

  @override
  String get careerStatDrawn => 'Gelijk';

  @override
  String get careerStatLost => 'Verloren';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Doelpunten $goalsFor–$goalsAgainst  ($gd)  ·  Winstpercentage $winRate%';
  }

  @override
  String get careerRecordResults => 'RECORDUITSLAGEN';

  @override
  String get careerBestWin => 'Grootste winst';

  @override
  String get careerWorstDefeat => 'Zwaarste nederlaag';

  @override
  String careerVsOpponentDate(String opponent, String date) {
    return 'tegen $opponent · $date';
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
    return '${won}W ${drawn}G ${lost}V  ·  DV $goalsFor DT $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Wereldkampioenschap';

  @override
  String get careerContinentalLabel => 'Continentaal';

  @override
  String get messagesTitle => 'BERICHTEN';

  @override
  String get messagesNoMessagesYet => 'Nog geen berichten.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Berichten konden niet worden geladen.\n$error';
  }

  @override
  String get messagesDone => 'Klaar';

  @override
  String get messagesNext => 'Volgende';

  @override
  String get rankingWorldRanking => 'WERELDRANGLIJST';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Ranglijst kon niet worden geladen.\n$error';
  }

  @override
  String get rankingNoRanking => 'Geen ranglijst.';

  @override
  String get rankingAll => 'ALLE';

  @override
  String get rankingYourTeam => 'JOUW TEAM';

  @override
  String get rankingYourRankingOverTime => 'JOUW RANGLIJSTPOSITIE IN DE TIJD';

  @override
  String rankingNowRank(int rank) {
    return 'nu #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'beste #$best · slechtste #$worst';
  }

  @override
  String get friendliesTitle => 'OEFENWEDSTRIJDEN';

  @override
  String friendliesLoadError(String error) {
    return 'Oefenwedstrijden konden niet worden geladen.\n$error';
  }

  @override
  String get friendliesContinue => 'Doorgaan';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'de $count vrije momenten',
      one: 'het 1 vrije moment',
    );
    return 'Regel oefenduels voor $_temp0 voor je volgende officiële wedstrijd. Tik op een tegenstander, of laat het open.';
  }

  @override
  String get friendliesFree => 'Vrij';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count DOELPUNTEN',
      one: '1 DOELPUNT',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'DOELPUNTEN';

  @override
  String get matchGoalsNone => 'Geen doelpunten';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'SPH';

  @override
  String matchGoalAssist(String name) {
    return 'assist $name';
  }

  @override
  String get friendliesHome => 'THUIS';

  @override
  String get friendliesAway => 'UIT';

  @override
  String get friendliesNoneThisWindow => 'Geen oefenwedstrijden in dit venster';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oefenwedstrijden',
      one: '1 oefenwedstrijd',
    );
    return '$_temp0 bevestigen';
  }

  @override
  String get friendliesMonthJan => 'Jan';

  @override
  String get friendliesMonthFeb => 'Feb';

  @override
  String get friendliesMonthMar => 'Mrt';

  @override
  String get friendliesMonthApr => 'Apr';

  @override
  String get friendliesMonthMay => 'Mei';

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
  String get resultsMyMatches => 'MIJN WEDSTRIJDEN';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Uitslagen konden niet worden geladen.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Geen wedstrijden.';

  @override
  String get resultsVs => 'tegen';

  @override
  String get resultsStageQualifier => 'KWALIFICATIE';

  @override
  String get resultsStageFriendly => 'OEFENWEDSTRIJD';

  @override
  String get resultsStageGroupStage => 'GROEPSFASE';

  @override
  String get resultsStageSemiFinal => 'HALVE FINALE';

  @override
  String get resultsStageFinal => 'FINALE';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'EINDRONDEGROEP';

  @override
  String get resultsStageRoundOf32 => 'ZESTIENDE FINALE';

  @override
  String get resultsStageRoundOf16 => 'ACHTSTE FINALE';

  @override
  String get resultsStageQuarterFinal => 'KWARTFINALE';

  @override
  String get resultsStageThirdPlace => 'DERDE PLAATS';

  @override
  String get matchSetupWarnCaptain =>
      'Geen aanvoerder aangewezen. Tik om iemand de band te geven';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name is geblesseerd en kan de ploeg niet aanvoeren. Tik om de band door te geven';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name is geschorst voor deze wedstrijd. Tik om de band door te geven';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name heeft de band, maar zit niet in je selectie. Tik om hem door te geven';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Geen nemers van spelhervattingen aangewezen. Tik om te kiezen wie het doet';

  @override
  String get matchSetupWarnBoth =>
      'Geen aanvoerder en geen nemers van spelhervattingen. Tik om ze aan te wijzen';

  @override
  String matchStageMatchday(int matchday) {
    return 'SD $matchday';
  }

  @override
  String get squadCaptain => 'Aanvoerder';

  @override
  String deptEffectYouth(int points) {
    return 'Talenten uit de academie komen er ongeveer $points totaalcijfer beter uit';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount terug aan het einde van de cyclus';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% minder blessures';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% kans dat een buitenlandse speler vraagt om over te stappen';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points geduld van het bestuur voordat je baan op het spel staat';
  }

  @override
  String get deptEffectNone => 'Geen effect zonder budget';

  @override
  String get statsBestRated => 'Cijfers';

  @override
  String get statsMyCareer => 'Loopbaan';

  @override
  String get statsBestAverageRating => 'HOOGSTE GEMIDDELDE CIJFER';

  @override
  String get statsMyCareerRecord => 'JOUW RECORD';

  @override
  String get statsNoRatingsRecorded => 'Nog geen wedstrijdcijfers vastgelegd.';

  @override
  String get statsGroupRecord => 'Record';

  @override
  String get statsGroupRuns => 'Reeksen';

  @override
  String get statsGroupExtremes => 'Uitersten';

  @override
  String get statsGroupSplits => 'Thuis en uit';

  @override
  String get statsGroupSquad => 'Jouw spelers';

  @override
  String get statsPlayed => 'Gespeelde wedstrijden';

  @override
  String get statsWinDrawLoss => 'Gewonnen–gelijk–verloren';

  @override
  String get statsWinRate => 'Winstpercentage';

  @override
  String get statsGoals => 'Doelpunten voor:tegen';

  @override
  String get statsCleanSheets => 'Clean sheets';

  @override
  String get statsFailedToScore => 'Niet gescoord';

  @override
  String get statsLongestWinStreak => 'Langste reeks zeges';

  @override
  String get statsLongestUnbeaten => 'Langste reeks zonder nederlaag';

  @override
  String get statsLongestCleanSheets => 'Langste reeks clean sheets';

  @override
  String get statsLongestWinless => 'Langste reeks zonder winst';

  @override
  String get statsCurrentRun => 'Huidige reeks zonder nederlaag';

  @override
  String get statsBiggestWin => 'Grootste winst';

  @override
  String get statsHeaviestDefeat => 'Zwaarste nederlaag';

  @override
  String get statsMostGoalsInAGame => 'Meeste doelpunten in een wedstrijd';

  @override
  String get statsShootouts => 'Strafschoppenseries gewonnen–verloren';

  @override
  String get statsComebackWins => 'Winst na achterstand';

  @override
  String get statsHome => 'Thuis';

  @override
  String get statsAway => 'Uit';

  @override
  String get statsNeutral => 'Neutraal';

  @override
  String get statsCompetitive => 'Officieel';

  @override
  String get statsFriendlies => 'Oefenwedstrijden';

  @override
  String get statsHatTricks => 'Hattricks';

  @override
  String get statsBraces => 'Dubbelslagen';

  @override
  String get statsMotms => 'Man van de wedstrijd-prijzen';

  @override
  String get statsAssists => 'Assists';

  @override
  String get statsCards => 'Kaarten';

  @override
  String get statsBestRating => 'Hoogste individuele cijfer';

  @override
  String statsAppsShort(int apps) {
    return '$apps int.';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MvdW';
  }

  @override
  String get captainArmband => 'A';

  @override
  String get captainCurrent => 'Aanvoerder. Tik om de band weg te halen';

  @override
  String get captainFitBorn => 'Een geboren leider';

  @override
  String get captainFitNatural => 'Een natuurlijke aanvoerder';

  @override
  String get captainFitCapable => 'Kan de band dragen';

  @override
  String get captainFitUnproven => 'Nog geen leider';

  @override
  String get captainNone => 'Geen aanvoerder aangewezen';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale moraal in de selectie';
  }

  @override
  String get viceCaptainFirst => '1e vice-aanvoerder';

  @override
  String get viceCaptainSecond => '2e vice-aanvoerder';

  @override
  String get viceCaptainNone => 'Geen vice-aanvoerder aangewezen';

  @override
  String get viceCaptainHint =>
      'Neemt de band over als de aanvoerder niet kan spelen.';

  @override
  String captainStandIn(String vice, String captain) {
    return 'Vice-aanvoerder $vice leidt het team, aanvoerder $captain is niet beschikbaar';
  }

  @override
  String captainStandInUnnamed(String vice) {
    return 'Vice-aanvoerder $vice leidt het team';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'WK-kwalificatie';

  @override
  String get resultsCategoryFriendlies => 'Oefenwedstrijden';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Continentaal toernooi';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'WK-kwal.';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Cont. kwal.';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Kwalificatie continentaal toernooi';

  @override
  String get resultsCategoryWorldCupFinals => 'WK-eindronde';

  @override
  String get resultsRoundResults => 'UITSLAGEN VAN DE RONDE';

  @override
  String get resultsFriendlyInternationals => 'VRIENDSCHAPPELIJKE INTERLANDS';

  @override
  String get resultsKnockout => 'Knock-out';

  @override
  String resultsEarlierMatches(int count) {
    return 'Eerdere wedstrijden ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'SPEELDAG $matchday';
  }

  @override
  String get resultsContinue => 'Doorgaan';

  @override
  String resultsGroup(String name) {
    return 'GROEP $name';
  }

  @override
  String get achievementsScreenTitle => 'PRESTATIES';

  @override
  String get achievementsChallengesTooltip => 'Uitdagingen';

  @override
  String get achievementsChallengesHeading => 'UITDAGINGEN';

  @override
  String get achievementsBrutalTests => 'Loodzware loopbaantesten';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Laden is mislukt.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total ontgrendeld';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total veroverd';
  }

  @override
  String get achievementsBoardSatisfaction => 'TEVREDENHEID VAN HET BESTUUR';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PRESTATIES ONTGRENDELD',
      one: 'PRESTATIE ONTGRENDELD',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Zeges';

  @override
  String get achCatMatches => 'Wedstrijden';

  @override
  String get achCatQualifications => 'Kwalificaties';

  @override
  String get achCatTitles => 'Titels';

  @override
  String get achCatMisc => 'Overig';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Doelpunten';

  @override
  String get achCatStreaks => 'Reeksen';

  @override
  String get achTierBronze => 'Brons';

  @override
  String get achTierSilver => 'Zilver';

  @override
  String get achTierGold => 'Goud';

  @override
  String get achTierPlatinum => 'Platina';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doelpunten',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scoor $count doelpunten.',
      one: 'Scoor 1 doelpunt.',
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
      other: 'Houd $count keer de nul.',
      one: 'Houd 1 keer de nul.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Winnende gewoonte';

  @override
  String get achStreakWin5Desc => 'Win vijf wedstrijden op rij.';

  @override
  String get achStreakWin10 => 'In vorm';

  @override
  String get achStreakWin10Desc => 'Win tien wedstrijden op rij.';

  @override
  String get achStreakWin20 => 'Stoomwals';

  @override
  String get achStreakWin20Desc => 'Win twintig wedstrijden op rij.';

  @override
  String get achUnbeaten15 => 'Moeilijk te kloppen';

  @override
  String get achUnbeaten15Desc => 'Blijf vijftien wedstrijden ongeslagen.';

  @override
  String get achUnbeaten30 => 'Onaantastbaar';

  @override
  String get achUnbeaten30Desc => 'Blijf dertig wedstrijden ongeslagen.';

  @override
  String get achHattrick => 'Hattrickheld';

  @override
  String get achHattrickDesc => 'Laat een speler een hattrick maken.';

  @override
  String get achMotm10 => 'Uitblinker';

  @override
  String get achMotm10Desc => 'Verzamel 10 prijzen voor man van de wedstrijd.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc => 'Verzamel 50 prijzen voor man van de wedstrijd.';

  @override
  String get achPerfect => 'Perfecte tien';

  @override
  String get achPerfectDesc =>
      'Laat een speler een wedstrijdcijfer van 9,5 of hoger halen.';

  @override
  String get achShootout => 'Ijs in de aderen';

  @override
  String get achShootoutDesc => 'Win vijf strafschoppenseries.';

  @override
  String get achMassacre => 'Slachting';

  @override
  String get achMassacreDesc =>
      'Win een wedstrijd met 7 doelpunten verschil of meer.';

  @override
  String get achAnnihilation => 'Vernietiging';

  @override
  String get achAnnihilationDesc =>
      'Win een wedstrijd met 10 doelpunten verschil of meer.';

  @override
  String get chTierBronze => 'Brons';

  @override
  String get chTierSilver => 'Zilver';

  @override
  String get chTierGold => 'Goud';

  @override
  String get chTierLegendary => 'Legendarisch';

  @override
  String get chFirstSteps => 'In de dug-out';

  @override
  String get chFirstStepsDesc => 'Wees 5 jaar bondscoach.';

  @override
  String get chUnbeaten10 => 'In vorm';

  @override
  String get chUnbeaten10Desc => 'Blijf 10 officiële wedstrijden ongeslagen.';

  @override
  String get chTwoNations => 'Nieuwe uitdaging';

  @override
  String get chTwoNationsDesc => 'Leid 2 verschillende landen.';

  @override
  String get chCont1 => 'Continentaal kampioen';

  @override
  String get chCont1Desc => 'Win een continentaal kampioenschap.';

  @override
  String get chNc1 => 'Nations Cup-winnaar';

  @override
  String get chNc1Desc => 'Win de Nations Cup.';

  @override
  String get chWc1 => 'Wereldkampioen';

  @override
  String get chWc1Desc => 'Win het Wereldkampioenschap.';

  @override
  String get chYears25 => 'Gevestigde orde';

  @override
  String get chYears25Desc => 'Wees 25 jaar bondscoach.';

  @override
  String get chWc3 => 'Seriewinnaar';

  @override
  String get chWc3Desc => 'Win 3 Wereldkampioenschappen.';

  @override
  String get chWc5 => 'Dynastie';

  @override
  String get chWc5Desc => 'Win 5 Wereldkampioenschappen.';

  @override
  String get chWc10 => 'Onsterfelijk';

  @override
  String get chWc10Desc => 'Win 10 Wereldkampioenschappen.';

  @override
  String get chWc2Teams => 'Have Boots, Will Travel';

  @override
  String get chWc2TeamsDesc =>
      'Win het Wereldkampioenschap met 2 verschillende landen.';

  @override
  String get chWc3Teams => 'Wereldreiziger';

  @override
  String get chWc3TeamsDesc =>
      'Win het Wereldkampioenschap met 3 verschillende landen.';

  @override
  String get chWcStreak3 => 'Three-Peat';

  @override
  String get chWcStreak3Desc => 'Win 3 Wereldkampioenschappen op rij.';

  @override
  String get chWcAllconf => 'Wereldveroveraar';

  @override
  String get chWcAllconfDesc =>
      'Win het Wereldkampioenschap met een land uit elke continentale bond (6).';

  @override
  String get chCont5 => 'Continentale koning';

  @override
  String get chCont5Desc => 'Win 5 continentale kampioenschappen.';

  @override
  String get chContAll => 'Zes-continenten-slam';

  @override
  String get chContAllDesc =>
      'Win het continentale kampioenschap van elke continentale bond (6).';

  @override
  String get chTreble => 'Schone lei';

  @override
  String get chTrebleDesc =>
      'Win het Wereldkampioenschap, een continentale titel en de Nations Cup in één loopbaan.';

  @override
  String get chNations10 => 'Nomade';

  @override
  String get chNations10Desc => 'Leid 10 verschillende landen.';

  @override
  String get chYears100 => 'Eeuw';

  @override
  String get chYears100Desc => 'Wees 100 jaar bondscoach.';

  @override
  String get chYears500 => 'Een half millennium';

  @override
  String get chYears500Desc => 'Wees 500 jaar bondscoach.';

  @override
  String get chYears1000 => 'Eeuwig';

  @override
  String get chYears1000Desc => 'Wees 1000 jaar bondscoach.';

  @override
  String get chGrandmaster => 'Grootmeester';

  @override
  String get chGrandmasterDesc =>
      'Win 3 Wereldkampioenschappen EN 5 continentale kampioenschappen.';

  @override
  String get chUndefeated => 'Onaantastbaar';

  @override
  String get chUndefeatedDesc =>
      'Win een Wereldkampioenschap zonder een enkele wedstrijd te verliezen.';

  @override
  String get chPerfectQual => 'Vlekkeloze weg';

  @override
  String get chPerfectQualDesc =>
      'Win elke wedstrijd van een WK-kwalificatiecampagne.';

  @override
  String get chMinnow => 'Wonder van de kleine';

  @override
  String get chMinnowDesc =>
      'Win het Wereldkampioenschap met een land dat buiten de top 32 van de wereldranglijst staat.';

  @override
  String get chGrandTour => 'Thuis en uit';

  @override
  String get chGrandTourDesc =>
      'Win een Wereldkampioenschap als gastheer en win er een buiten je eigen land.';

  @override
  String get chUnbeaten25 => 'De Muur';

  @override
  String get chUnbeaten25Desc => 'Blijf 25 officiële wedstrijden ongeslagen.';

  @override
  String get chGoals10k => 'Doelpuntenmachine';

  @override
  String get chGoals10kDesc => 'Scoor 10.000 doelpunten in je loopbaan.';

  @override
  String get chCleanSheets500 => 'Vesting';

  @override
  String get chCleanSheets500Desc => 'Houd 500 keer de nul in je loopbaan.';

  @override
  String get chHatTricks25 => 'Hattrickgewoonte';

  @override
  String get chHatTricks25Desc => 'Laat je spelers 25 hattricks maken.';

  @override
  String get chWinStreak25 => 'Onverbiddelijk';

  @override
  String get chWinStreak25Desc => 'Win 25 wedstrijden op rij.';

  @override
  String get chCont10 => 'Continentale dynastie';

  @override
  String get chCont10Desc => 'Win 10 continentale kampioenschappen.';

  @override
  String get chPcWc => 'Seriekampioen';

  @override
  String chPcWcDesc(int count) {
    return 'Win $count Wereldkampioenschappen in dit spel.';
  }

  @override
  String get chPcMajors => 'Prijzenverzamelaar';

  @override
  String chPcMajorsDesc(int count) {
    return 'Win $count grote prijzen (Wereldkampioenschap, continentaal toernooi, Nations Cup of Continental Clash).';
  }

  @override
  String get chPcUnbeaten => 'IJzeren muur';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Blijf $count officiële wedstrijden ongeslagen.';
  }

  @override
  String get chPcNations => 'Zwerver';

  @override
  String chPcNationsDesc(int count) {
    return 'Leid $count verschillende landen.';
  }

  @override
  String get chPcYears => 'De lange adem';

  @override
  String chPcYearsDesc(int count) {
    return 'Wees $count jaar bondscoach.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zeges',
      one: '1 zege',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Win $count wedstrijden.',
      one: 'Win 1 wedstrijd.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wedstrijden',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Speel $count wedstrijden.',
      one: 'Speel 1 wedstrijd.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'WK-kwalificant';

  @override
  String get achQualWcDesc => 'Kwalificeer je voor het Wereldkampioenschap.';

  @override
  String get achQualCont => 'Continentaal kwalificant';

  @override
  String get achQualContDesc =>
      'Kwalificeer je voor je continentale kampioenschap.';

  @override
  String get achTitleWc => 'Wereldkampioenen';

  @override
  String get achTitleWcDesc => 'Win het Wereldkampioenschap.';

  @override
  String get achTitleEuro => 'Europees kampioen';

  @override
  String get achTitleEuroDesc => 'Win het Europees Kampioenschap.';

  @override
  String get achTitleCopa => 'Kampioen van Zuid-Amerika';

  @override
  String get achTitleCopaDesc => 'Win de Zuid-Amerikaanse Beker.';

  @override
  String get achTitleAfcon => 'Afrikaans kampioen';

  @override
  String get achTitleAfconDesc => 'Win het Afrikaans Kampioenschap.';

  @override
  String get achTitleAsia => 'Aziatisch kampioen';

  @override
  String get achTitleAsiaDesc => 'Win het Aziatisch Kampioenschap.';

  @override
  String get achTitleConcacaf => 'Kampioen van Noord-Amerika';

  @override
  String get achTitleConcacafDesc => 'Win de Nations Cup van Noord-Amerika.';

  @override
  String get achTitleOfc => 'Kampioen van Oceanië';

  @override
  String get achTitleOfcDesc => 'Win de Oceanische Beker.';

  @override
  String get achTitleNations => 'Nations Cup-winnaars';

  @override
  String get achTitleNationsDesc => 'Win de Nations Cup.';

  @override
  String get achTitleClash => 'Winnaars Continental Clash';

  @override
  String get achTitleClashDesc => 'Win de Continental Clash.';

  @override
  String get achMarksman => 'WK-scherpschutter';

  @override
  String get achMarksmanDesc =>
      'Laat een speler uit je selectie 6 of meer doelpunten maken in een WK-eindronde.';

  @override
  String get achSweep => 'Schone lei';

  @override
  String get achSweepDesc =>
      'Houd het Wereldkampioenschap en je continentale titel vast in één loopbaan.';

  @override
  String get achAllstar => 'Toernooi-All-Star';

  @override
  String get achAllstarDesc =>
      'Laat een speler opnemen in het Elftal van het Toernooi van een Wereldkampioenschap.';

  @override
  String get achGoldenboot => 'Gouden Schoen';

  @override
  String get achGoldenbootDesc =>
      'Laat je land eindigen als topscorer van een kampioenschap.';

  @override
  String get achDemolition => 'Sloop';

  @override
  String get achDemolitionDesc =>
      'Win een wedstrijd met 5 doelpunten verschil of meer.';

  @override
  String get achievementsNice => 'Mooi!';

  @override
  String get achievementsHardestTests =>
      'De zwaarste testen voor een bondscoach, verspreid over een hele loopbaan en veel landen.';

  @override
  String get achievementsThisSave => 'DIT SPEL';

  @override
  String get achievementsBrutalBadge => 'LOODZWAAR';

  @override
  String get paywallGoPro => 'GA UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Eenmalig ontgrendelen. Geen abonnement.';

  @override
  String get paywallBenefitCarryOn =>
      'Dit spel gaat precies verder waar het stopte, met elke interland, elk record en elke rivaliteit intact.';

  @override
  String get paywallBenefitNoAds =>
      'Geen advertenties, geen microtransacties, geen abonnement. Eén betaling, en elke toekomstige update is van jou.';

  @override
  String get paywallBenefitSaves =>
      'Zoveel opgeslagen spellen als je wilt. Leid een favoriet en een underdog tegelijk, en ontdek hoe anders hetzelfde spel aanvoelt.';

  @override
  String get paywallBenefitEndless =>
      'Elke cyclus vanaf nu. Kies vandaag een zeventienjarige en ontdek in 2034 of je het goed zag.';

  @override
  String get paywallUnlocked => 'Unlimited is ontgrendeld. Veel plezier!';

  @override
  String get paywallContactingStore => 'Verbinding met de store…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Unlimited ontgrendelen · $price';
  }

  @override
  String get paywallRestorePurchases => 'Aankopen herstellen';

  @override
  String get paywallStoreUnavailable => 'Store niet beschikbaar';

  @override
  String get paywallStoreUnavailableNote =>
      'De prijs kon niet worden geladen. Controleer je verbinding en probeer het opnieuw.';

  @override
  String get paywallTryAgain => 'Opnieuw proberen';

  @override
  String get gateTitle => 'JE EERSTE CYCLUS IS VOORBIJ';

  @override
  String get gateLead =>
      'Vier jaar is één cyclus. Dat is niet lang genoeg om te ontdekken of je gelijk had.';

  @override
  String get gatePriceLead => 'Eén betaling, voor altijd';

  @override
  String get gateBuy => 'KOPEN EN DOORGAAN';

  @override
  String get gateExit => 'STOPPEN';

  @override
  String get gateSaveTitle => 'DIT SPEL HEEFT PRO NODIG';

  @override
  String get gateSaveLead =>
      'Spellen na de gratis cyclus en Pro-campagnes gaan verder met Pro. Er gaat niets verloren: dit spel wacht precies zoals je het achterliet.';

  @override
  String get careerSaveLockedNote => 'Pro nodig om dit spel voort te zetten';

  @override
  String get federationNaturalisation => 'NATURALISATIE';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name genaturaliseerd';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name heeft de overstap afgerond en is nu speelgerechtigd voor $nation. Roep de speler op via je selectie.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Aanbod kon niet worden geladen.\n$error';
  }

  @override
  String get federationContinue => 'Doorgaan';

  @override
  String get federationOfferToSwitchAllegiance =>
      'EEN AANBOD OM VAN VOETBALNATIE TE WISSELEN';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · leeftijd $age · uit $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name heeft banden met $playerNation en wil zich laten naturaliseren. Accepteer, en de speler kan worden geselecteerd; wijs af, en de speler blijft bij $sourceNation.';
  }

  @override
  String get federationDecline => 'Afwijzen';

  @override
  String get federationNaturalise => 'Naturaliseren';

  @override
  String get federationBudgetLater => 'Later beslissen';

  @override
  String get federationSetYourBudget => 'STEL JE BUDGET IN';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Financiën laden mislukt.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Opgeslagen spel niet gevonden.';

  @override
  String get federationBudgetHeading => 'BONDSBUDGET';

  @override
  String federationDistributeBudget(String amount) {
    return 'Verdeel $amount over de afdelingen om de cyclus te openen. Besteed het verstandig.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount meer dan de bond heeft. Haal er iets af';
  }

  @override
  String get federationAllocateFullBudget =>
      'Verdeel het hele budget om de cyclus te beginnen.';

  @override
  String get federationConfirming => 'Bevestigen…';

  @override
  String get federationConfirmBudget => 'Budget bevestigen';

  @override
  String get federationFinances => 'FINANCIËN';

  @override
  String get federationInvestmentUpdated => 'Investering bijgewerkt.';

  @override
  String get federationDevelopment => 'BONDSONTWIKKELING';

  @override
  String get federationProjectedAtSeasonEnd =>
      'VERWACHT AAN HET EIND VAN HET SEIZOEN';

  @override
  String get federationCentralFunding => 'Centrale financiering';

  @override
  String get federationPrizeMoneySoFar => 'Prijzengeld tot nu toe';

  @override
  String get federationCommercialReturn => 'Commercieel rendement';

  @override
  String get federationThisSeasonLocked => 'DIT SEIZOEN (VERGRENDELD)';

  @override
  String get federationInvestForNextSeason => 'INVESTEER VOOR VOLGEND SEIZOEN';

  @override
  String get federationNextSeasonImpact => 'EFFECT VOLGEND SEIZOEN';

  @override
  String get federationSaving => 'Opslaan…';

  @override
  String get federationConfirmInvestment => 'Investering bevestigen';

  @override
  String get federationBalance => 'BONDSSALDO';

  @override
  String get federationCommittedToStaff => 'Gereserveerd voor staf';

  @override
  String get federationFreeToSpend => 'Vrij te besteden';

  @override
  String get federationWagesNote =>
      'Salarissen gaan aan het eind van de cyclus van het saldo af, dus dit bedrag is al vergeven.';

  @override
  String get federationInvestAtCeremony =>
      'Investeer voor volgend seizoen tijdens de ceremonie aan het eind van de cyclus.';

  @override
  String federationLevelBadge(int level) {
    return 'N$level';
  }

  @override
  String get federationAcademyProspects => 'Talenten uit de academie';

  @override
  String federationPlusOverall(int value) {
    return '+$value totaalcijfer';
  }

  @override
  String get federationInjuryRisk => 'Blessurerisico';

  @override
  String get federationNaturalisationChance => 'Kans op naturalisatie';

  @override
  String get federationBoardPatience => 'Geduld van het bestuur';

  @override
  String get federationUnallocated => 'NIET VERDEELD';

  @override
  String get nationsVitrineTitle => 'PRIJZENKAST';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Land laden mislukt.\n$error';
  }

  @override
  String get nationsNoNation => 'Geen land.';

  @override
  String get nationsHonours => 'PRIJZEN';

  @override
  String get nationsRankingHistory => 'GESCHIEDENIS WERELDRANGLIJST';

  @override
  String get nationsTopScorers => 'TOPSCORERS ALLER TIJDEN';

  @override
  String get nationsTitles => 'TITELS';

  @override
  String get nationsYourTeam => 'JOUW TEAM';

  @override
  String get nationsWorld => 'WERELD';

  @override
  String get nationsWorldCup => 'Wereldkampioenschap';

  @override
  String get nationsContinental => 'Continentaal';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deelnames',
      one: '1 deelname',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Nog niet genoeg geschiedenis. Kom na een cyclus of twee terug.';

  @override
  String nationsBestRank(int rank) {
    return 'Beste: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Nu: #$rank';
  }

  @override
  String get nationsNoGoals => 'Nog geen doelpunten geregistreerd.';

  @override
  String get nationsGoalsAbbrev => 'dpt';

  @override
  String get nationsHosts => 'GASTHEER';

  @override
  String get nationsSelectTitle => 'KIES EEN LAND';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Landen laden mislukt.\n$error';
  }

  @override
  String get nationsNoMatch => 'Geen landen gevonden.';

  @override
  String get nationsSelectHeading => 'Kies een land';

  @override
  String get nationsSearchHint => 'Zoek een land…';

  @override
  String get nationsRank => 'PLAATS ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'KIES';

  @override
  String get statsTeamRecords => 'TEAMRECORDS';

  @override
  String get statsRecordBook => 'Recordboek';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Statistieken laden mislukt.\n$error';
  }

  @override
  String get statsNoData => 'Geen gegevens.';

  @override
  String get statsTopScorers => 'TOPSCORERS';

  @override
  String get statsMostGamesPlayed => 'MEESTE WEDSTRIJDEN';

  @override
  String get statsTeam => 'Team';

  @override
  String get statsTopScorersShort => 'Scorers';

  @override
  String get statsMostGames => 'Meeste wedstr.';

  @override
  String get statsMostGamesShort => 'Duels';

  @override
  String get statsNoGoalsRecorded => 'Nog geen doelpunten geregistreerd.';

  @override
  String get statsUnknown => 'Onbekend';

  @override
  String get playerTitle => 'SPELER';

  @override
  String playerLoadError(String error) {
    return 'Speler laden mislukt.\n$error';
  }

  @override
  String get playerNotFound => 'Speler niet gevonden.';

  @override
  String get playerClub => 'CLUB';

  @override
  String get playerClubRole => 'Bij zijn club';

  @override
  String get playerPosition => 'Positie';

  @override
  String get playerPotential => 'Potentieel';

  @override
  String get playerAge => 'Leeftijd';

  @override
  String get playerValue => 'Waarde';

  @override
  String get clubFirstChoice => 'Speelt elke week';

  @override
  String get clubRotation => 'Wisselend';

  @override
  String get clubFringe => 'Speelt amper';

  @override
  String get clubFrozenOut => 'Speelt niet';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Ik kijk al dertig jaar voetbal en dit zag ik niet aankomen. $opponent verslagen met $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Niemand gaf ze een kans tegen $opponent. $score. Echt niemand.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score tegen $opponent. Ga de buren maar wakker maken.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Dit is zo\'n avond die je later aan je kleinkinderen vertelt. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score tegen $opponent. Hoe het ook gebeurd is, het is gebeurd.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Op papier was dit voorbij voor het begon. $opponent $score zegt iets anders.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponent verslagen, $score. Over een jaar gelooft niemand die uitslag nog.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Geniet ervan en kijk daarna naar het programma.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score tegen $opponent, en we hadden tachtig van de negentig minuten geluk.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Eén avond tegen $opponent maakt een heel jaar niet goed. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent verslagen, $score, en nu horen we dat we een kentering hebben bereikt. Niet dus.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Mooi. Vraag het me nog eens als het ertoe doet.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent verslagen, $score. Precies zoals het hoort, en dat is best prettig.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score over $opponent. Meedogenloos, en dat is een compliment.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Geen gedoe, geen schrik, geen klachten.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Een nette $score tegen $opponent. Zo ziet een goed team eruit op een rustige dag.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score tegen $opponent. Klus geklaard, niets geleerd.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent verslagen, $score. We moesten winnen en dat deden we.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Een professionele $score over $opponent. Volgende.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent afgedaan met $score. Afvinken en door.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score tegen $opponent en daar moeten we voor klappen. Voor het winnen van ze.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Goed gedaan, iedereen, bij die $score over $opponent, neem ik aan.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Zulke teams verslaan is het minimum, geen prestatie.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'We wonnen met $score van $opponent en zagen er stroef uit.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score tegen $opponent en elke minuut verdiend.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Dat vroeg karakter. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent verslagen, $score, op de harde manier, en die blijft hangen.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score tegen $opponent. Teams die dit winnen staan in juni nog overeind.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Zenuwachtig, lelijk, en gewonnen. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent verslagen, $score. Pak de drie punten en kijk het nooit terug.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent liet ons voor elke centimeter werken.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Niet mooi. Telt net zo zwaar.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score tegen $opponent en we maakten het tien keer moeilijker dan nodig.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'We horen niet te hoeven knokken tegen $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Gewonnen, en niets goeds over onszelf geleerd.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'Een $score tegen $opponent die ons flatteerde.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Een punt tegen $opponent, $score. Pak het en ga door.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score tegen $opponent. Er zijn slechtere middagen.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent gehouden op $score. Niet alles hoeft een verhaal te zijn.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Een punt is een punt en de stand vraagt niet hoe.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score tegen $opponent. Twee punten gemist of één gewonnen. Kies je stemming.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Gelijkspel tegen $opponent, $score. Niemand is blij, niemand is woedend.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. De meest vergeetbare negentig minuten van het jaar.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'De punten gedeeld met $opponent, $score. Op naar de volgende.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score tegen $opponent. Zo sterven campagnes stilletjes.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Twee punten weggegooid tegen $opponent. $score. Er is geen andere naam voor.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. We hadden negentig minuten en geen idee wat we ermee moesten.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Een $score tegen $opponent die niemand zich zal herinneren en waar iedereen voor betaalt.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Verslagen door $opponent met $score. Het gebeurt.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Niets om iemand voor op te hangen. Door naar de volgende.';
  }

  @override
  String yLost2(String opponent, String score) {
    return '$score verloren van $opponent en alles gegeven. Soms is dat niet genoeg.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score voor $opponent. Kop op. Dit team heeft nog genoeg in zich.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. We waren de mindere en daar is geen discussie over.';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$score verloren van $opponent. Hergroeperen.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score voor $opponent. Geen schande, niet goed genoeg.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Verslagen door $opponent met $score. Leer ervan, anders was het voor niets.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score voor $opponent en we kwamen er niet aan te pas.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Verloren van $opponent, $score. Dezelfde problemen, dezelfde maand, dezelfde smoesjes op komst.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Wanneer is dit geen pech meer?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Verslagen door $opponent met $score. Dat is een uitslag die iemand iets moet kosten.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score voor $opponent. Eén slechte avond. Beoordeel het team op de campagne, niet hierop.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Niemand wilde die $score tegen $opponent minder dan de spelers zelf.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Lelijk, en niet wie dit team is.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Een $score om te vergeten tegen $opponent. De volgende keer staan ze er wel.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Tegen $opponent. Ik heb geen woorden en ik word betaald om woorden te hebben.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Iemand moet hier verantwoording voor afleggen.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Ik wil die $score tegen $opponent uit de boeken en uit het geheugen geschrapt zien.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Verslagen door $opponent met $score. Zo\'n uitslag kun je niet mooipraten.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Dat was geen nederlaag tegen $opponent, het was een capitulatie. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Tegen $opponent. Mensen hebben geld betaald om dat te zien.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Als dit niets verandert, verandert niets meer.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Ik heb dit team eerder vernederd gezien, maar $score van $opponent is een nieuw dieptepunt.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return '$opponent verslagen, $score. Schrijf de datum op, ze gaan vragen waar je was.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Buiten de kleedkamer geloofde niemand erin. $score tegen $opponent. Trots dekt de lading niet.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score tegen $opponent! Iedereen rende tot er niets meer over was.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Reuzendoder. $opponent, $score. Daarom blijven we altijd komen.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$score tegen $opponent. De voorspellingen zijn net het raam uit gevlogen.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Grote favoriet: $opponent. Eindstand: $score voor ons.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Een van de verrassingen van het jaar: $score tegen $opponent.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Niemand zag het aankomen en niemand kan het echt verklaren.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$score tegen $opponent. Prachtig. Nu vergeet iedereen hoe slecht de rest van het jaar was.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$score tegen $opponent en de bandwagon zit al vol. Ik zat erin toen hij leeg was.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Geweldig, en toch vinden ze een manier om het te verspillen.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Grote avond tegen $opponent, $score. Eén zwaluw maakt nog geen zomer.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$score tegen $opponent. Het doet pijn omdat het ons wat kan schelen. Steun ze toch.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Een avond om te vergeten tegen $opponent, $score. De spelers hebben er het meeste last van.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Kop op. Een ploeg wordt beoordeeld op hoe ze hierop reageert.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$score tegen $opponent. Slecht, ja. Het einde van de wereld, nee.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$score tegen $opponent. Een uitslag waar nog jaren over gepraat wordt, om de verkeerde redenen.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Winst voor $opponent, $score. Hierna hoeft niemand volgende keer verbaasd te zijn.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Een van de slechtste avonden in lange tijd: $score tegen $opponent.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Er komen vragen, en terecht.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$score tegen $opponent. Gênant is nog zacht uitgedrukt.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return '$score verloren van $opponent. De laatste doet het licht uit.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. Het verbaast me niet meer, en dat maakt me bang.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Iemand bovenin mag vanavond zijn cv bijwerken.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$score tegen $opponent! Van zulk voetbal gaat het hele land glimlachen.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return '$opponent van de mat geveegd, $score. Wat een prestatie.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. Tegen $opponent. Vanavond lukte alles.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return 'Een $score-afstraffing van $opponent. Bewaar de samenvatting, die wil je later.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Dat is een ploeg die plezier heeft in voetballen.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$score tegen $opponent, en het hadden er meer kunnen zijn. Heerlijk.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$score tegen $opponent. Een uitslag waar mensen twee keer naar kijken.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return '$opponent verslagen, $score. Na een halfuur was er geen wedstrijd meer.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Eindstand: $score tegen $opponent. Veruit de grootste zege in lange tijd.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. De ene ploeg kwam voetballen, de andere stapte niet eens uit de bus.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. $opponent had nergens een antwoord op.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Een pak slaag: $score tegen $opponent.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$score tegen $opponent. Leuk, maar zij zijn niet bepaald de maatstaf.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$score tegen $opponent. Maak me wakker als we dat bij een goede ploeg doen.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Leuk, maar ik heb ploegen zo zien glanzen en niets zien winnen.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, en iedereen is weer een genie. Het was $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$score tegen $opponent. Niet doordraven, het bewijst weinig.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Geniet ervan, en denk dan aan hoe het afliep de vorige keer dat we enthousiast werden.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Door na strafschoppen tegen $opponent! Zenuwen van staal, stuk voor stuk.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Strafschoppen tegen $opponent, en we hielden ons hoofd koel. Knuffel een vreemde.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Strafschoppenreeks gewonnen tegen $opponent. Mijn hart kan dit niet aan.';
  }

  @override
  String yWinShootout3(String opponent) {
    return '$opponent verslagen na strafschoppen. Door naar de volgende ronde.';
  }

  @override
  String yWinShootout4(String opponent) {
    return 'Tegen $opponent moesten de penalty\'s beslissen, en wij scoorden er meer.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Strafschoppen gewonnen tegen $opponent. Op de moeilijkste manier, maar door.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Door na strafschoppen tegen $opponent. Loterij gewonnen, prestatie vergeten.';
  }

  @override
  String yWinShootout7(String opponent) {
    return '$opponent verslaan na strafschoppen, na zo\'n wedstrijd? Geluk, en dat weet iedereen.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Door tegen $opponent na strafschoppen. Zo ver had het nooit mogen komen.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'DOOR. $score tegen $opponent, en de droom leeft.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'KNOCK-OUTZEGE: $opponent verslagen, $score. Het land mag gaan geloven.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$score tegen $opponent en door naar de volgende ronde. Wat een avond.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return '$opponent naar huis gestuurd, $score. Verder.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'KNOCK-OUT: $score tegen $opponent. Volgende ronde bevestigd.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Door: $score tegen $opponent.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return '$opponent uitgeschakeld, $score. De volgende ronde wacht.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return '$score gewonnen van $opponent. In de knock-outfase vraagt niemand hoe.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Door tegen $opponent, $score. De volgende tegenstander wordt minder vriendelijk.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$score tegen $opponent is genoeg om door te gaan. Volgende keer is er veel meer nodig.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return '$opponent eruit, $score. Eerder overleefd dan gewonnen.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Door naar de volgende ronde na $score tegen $opponent. Vraag niet hoe.';
  }

  @override
  String yUpsetGap0(String opponent, int gap) {
    return '$gap plaatsen verschil op de ranglijst, en toch $opponent verslagen. Geweldig.';
  }

  @override
  String yUpsetGap1(String opponent, int gap) {
    return '$opponent: $gap plaatsen boven ons. Verslagen. Voetbal is prachtig.';
  }

  @override
  String yUpsetGap2(String opponent, int gap) {
    return 'Verschil op de ranglijst: $gap plaatsen. Uitslag: winst tegen $opponent. Blijf altijd geloven.';
  }

  @override
  String yUpsetGap3(String opponent, int gap) {
    return 'Verschil op de ranglijst voor de aftrap: $gap plaatsen. $opponent toch verslagen.';
  }

  @override
  String yUpsetGap4(String opponent, int gap) {
    return 'Op de wereldranglijst stond $opponent $gap plaatsen boven ons. Vanavond niet.';
  }

  @override
  String yUpsetGap5(String opponent, int gap) {
    return 'Verrassingsindex: $gap ranglijstplaatsen tussen beide ploegen. Winst voor ons tegen $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, int gap) {
    return '$gap ranglijstplaatsen scheidden ons van $opponent. Eén avond dicht dat gat niet.';
  }

  @override
  String yUpsetGap7(String opponent, int gap) {
    return '$opponent: $gap plaatsen boven ons, en verslagen. De ranglijst merkt het nauwelijks.';
  }

  @override
  String yUpsetGap8(int gap) {
    return 'Verschil op de ranglijst: $gap plaatsen. Onthoud dat getal voor de volgende keer dat we van een kleintje verliezen.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Ik had deze ploeg afgeschreven. Ik had het mis, en ik heb het nog nooit zo graag mis gehad. $opponent verslagen.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Een portie nederigheid graag. Een grote. De zege op $opponent was geweldig.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Ik zei dat ze niets meer hadden. Ze hadden genoeg. Goed gespeeld tegen $opponent, allemaal.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Voor de duidelijkheid: die zege op $opponent zag ik niet aankomen. Petje af.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Goed. Ik zei dat ze door de mand zouden vallen. $opponent kreeg ze niet zover.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Vanavond eet ik mijn woorden over deze ploeg op. De zege op $opponent verdient dat.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Ja, ik zei dat ze klaar waren. Eén zege op $opponent bewijst nog niet dat ik ongelijk had.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Ik moet na $opponent mijn woorden inslikken. Doe ik, langzaam, en het bonnetje bewaar ik.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'De zege op $opponent was indrukwekkend. Mijn twijfels over deze ploeg zijn nergens heen.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Chapeau voor $nation. $score, en volledig verdiend.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Het doet pijn om te zeggen, maar $nation was vanavond beter. $score. Gefeliciteerd.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Petje af voor $nation, zij wilden het meer.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return '$score verloren van $nation. Ik weet niet eens wat ik moet zeggen.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Onze jongens zouden zich moeten schamen.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$score tegen $nation. Kan iemand mij uitleggen hoe dit gebeurde?';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return '$score verliezen van $nation. Hier kom ik nooit overheen.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$score tegen $nation. Geluk. Puur geluk.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Na die $score zijn ze bij $nation jarenlang onuitstaanbaar. Bedankt voor niets.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Geweldig voor het voetbal. Daarom houden we ervan.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Wat een uitslag voor $nation: $score tegen $opponent. Voetbal op zijn best.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Alle neutralen juichen vanavond voor $nation. $score tegen $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Uitslag van de speelronde: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Niemand had dat op zijn briefje.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Grote uitslag: $nation $score $opponent. De ranglijst gaat schuiven.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Leuk, eens kijken of ze het nog een keer kunnen.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Won $nation het, of verloor $opponent het?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Sensatie: $nation $score $opponent. Reken op een hoop overdreven reacties.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name tegen $opponent. Ze gaan kinderen naar hem vernoemen.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Een standbeeld voor $name. Vanavond tegen $opponent was hij alles.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, wat een speler. Onthoud deze avond tegen $opponent.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name besliste het tegen $opponent. Man van de wedstrijd, geen discussie.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return 'Tegen $opponent was de avond van $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name stond er toen het moest, tegen $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name was briljant tegen $opponent. Nu elke week graag.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name redde de ploeg tegen $opponent. De rest hielp weinig.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Zonder $name was het tegen $opponent een heel andere avond geweest.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$score tegen $opponent. Een ongelukje. Het overkomt iedereen een keer.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return '$score verloren van $opponent. Afschudden, de campagne is niet voorbij.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Pijnlijk, maar één uitslag definieert deze ploeg niet.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$score tegen $opponent. Een slechte dag op kantoor. Door.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Verloren van $opponent, $score. Niemand zag het aankomen.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Een van die avonden die nergens op slaan.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$score tegen $opponent. Een nederlaag die bijblijft.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Verslagen door $opponent, $score. Een stunt, hoe je het ook bekijkt.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$score tegen $opponent. Tegen $opponent! Onaanvaardbaar.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return '$score verloren van $opponent. Ik wil uitleg, geen excuses.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Een nationale schande, en dat is geen beeldspraak.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$score tegen $opponent. Hoe zit iedereen bovenin nog op zijn plek?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$score tegen $opponent. Dat is een topploeg. Leer ervan.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Weggespeeld door $opponent, $score. Geen schande om van de besten te verliezen.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Een les, en van lessen word je beter.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$score tegen $opponent. Pijnlijk, maar zij zijn een niveau hoger.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Winst voor $opponent, $score. Het verschil is echt, en nu heeft iedereen het gezien.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$score tegen $opponent. Een pak slaag, zo simpel is het.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. De betere ploeg, en de uitslag zegt het.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return '$score verloren van $opponent. Geen schande, maar ook geen wedstrijd.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$score tegen $opponent. Betere tegenstander of niet, zo mag je niet verliezen.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Hebben we het überhaupt geprobeerd?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. Tegen $opponent. Lammetjes naar de slachtbank.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return '$score verloren van $opponent, en niemand leek ervan wakker te liggen.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Eruit na strafschoppen tegen $opponent. Ze gaven alles. Trots op ze.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Strafschoppen tegen $opponent. De wreedste manier om eruit te gaan. Kop op.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Strafschoppenreeks verloren tegen $opponent. Niemand verdiende dat.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Eruit na strafschoppen tegen $opponent. De stip besliste.';
  }

  @override
  String yLostShootout4(String opponent) {
    return '$opponent door na strafschoppen. Ons toernooi eindigt hier.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Strafschoppen verloren tegen $opponent. Alweer strafschoppen.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Eruit na strafschoppen tegen $opponent. Oefenen we die eigenlijk ooit?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Verloren van $opponent na strafschoppen. Hadden we veel eerder moeten beslissen.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Strafschoppen tegen $opponent, en verloren. Natuurlijk.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ERUIT. $score tegen $opponent. Een toernooi om trots op te zijn eindigt hier.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Uitgeschakeld door $opponent, $score. Bedankt voor de herinneringen.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$score tegen $opponent. De reis is voorbij, maar wat een reis.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'UITGESCHAKELD: $score tegen $opponent. Kop op.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'KNOCK-OUT: $score tegen $opponent.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Eruit: $score tegen $opponent.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return '$opponent door, $score. Ons toernooi is voorbij.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Uitgeschakeld door $opponent, $score. De lijkschouwing begint.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'ERUIT. $score tegen $opponent. Ander toernooi, zelfde einde.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$score tegen $opponent, en naar huis. Niemand is verbaasd.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Uitgeschakeld door $opponent, $score. Reken morgenochtend op excuses.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Eruit, en het leek nooit anders te gaan aflopen.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$score tegen $nation. Respect, ze komen sterker terug.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Mooie zege voor ons, $score. Slechte dag voor $nation, ik heb met hun fans te doen.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Slechte avond voor $nation, en wij grepen onze kans. Zo gaat dat.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$score tegen $nation! Wie zag dat aankomen? Zij niet.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return '$score gewonnen van $nation. Kijkt iemand even hoe het met hun fans gaat?';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Die gaat in het fotoalbum.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$score tegen $nation. En dan denken ze dat ze een grote ploeg zijn.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Stel je voor dat je $score van ons verliest. Vraag het $nation, zij weten het nu.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Goede vlucht naar huis.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Een grote avond voor $opponent, een zware voor $nation.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Sterkte voor de fans van $nation na $score tegen $opponent. Ze krabbelen wel op.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Elke grote ploeg heeft zo\'n avond.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Stunt van de speelronde: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Niemand zag dat aankomen.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Uitslag van de dag: $nation $score $opponent. Er liggen vragen klaar voor $nation.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Geen toeval, als je goed hebt opgelet.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Daar moet iemand heel wat uitleggen.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Grote naam, kleine prestatie.';
  }

  @override
  String yDownGap0(String opponent, int gap) {
    return '$opponent: $gap plaatsen onder ons. Het gebeurt. Door.';
  }

  @override
  String yDownGap1(int gap) {
    return 'Verschil op de ranglijst: $gap plaatsen in ons voordeel. Voetbal leest geen ranglijsten.';
  }

  @override
  String yDownGap2(String opponent, int gap) {
    return '$gap plaatsen tussen ons en $opponent op papier. Niet op het veld vanavond.';
  }

  @override
  String yDownGap3(String opponent, int gap) {
    return 'Verschil op de ranglijst voor de aftrap: $gap plaatsen in ons voordeel. Toch verloren van $opponent.';
  }

  @override
  String yDownGap4(String opponent, int gap) {
    return 'Op de wereldranglijst stond $opponent $gap plaatsen onder ons. Uitslag: nederlaag.';
  }

  @override
  String yDownGap5(String opponent, int gap) {
    return 'Verrassingsindex: $gap ranglijstplaatsen, de verkeerde kant op, tegen $opponent.';
  }

  @override
  String yDownGap6(String opponent, int gap) {
    return '$gap plaatsen boven $opponent op de ranglijst. Verloren. Leg dat maar uit.';
  }

  @override
  String yDownGap7(int gap) {
    return 'Verloren van een ploeg die $gap plaatsen onder ons staat. Laat dat getal even bezinken.';
  }

  @override
  String yDownGap8(String opponent, int gap) {
    return 'Verschil op de ranglijst: $gap plaatsen. Verloren van $opponent. Iemand mag de dagen gaan tellen.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$score tegen $opponent! Een gelijkspel dat voelt als winst.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$score tegen $opponent. Trots op ieder van hen.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. Zij waren favoriet en wij hielden stand.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$score tegen $opponent. Een punt verdiend met bloed en zweet.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$score tegen $opponent. Een heel goed punt.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return '$score gelijk tegen $opponent. Weinigen verwachtten iets.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponent afgestopt, $score. Een uitslag om op te bouwen.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$score tegen $opponent. Een punt dat niemand ons gunde.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$score tegen $opponent. Goed punt, maar met gelijkspelen win je niets.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$score tegen $opponent. Mooi. We hadden ook geen enkel echt schot.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Eén punt, en iedereen doet alsof we de beker hebben gewonnen.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$score tegen $opponent. Bus voor het doel en veel geluk.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$score tegen $opponent. Frustrerend, maar nog steeds ongeslagen.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Maar $score tegen $opponent. Een offday. Het gebeurt.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Niet goed genoeg, en de spelers weten het.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$score tegen $opponent. Twee punten laten liggen, meer niet.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$score tegen $opponent. Twee punten weggegooid.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Maar $score tegen $opponent. Een slechte uitslag, hoe je het ook verpakt.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Een gelijkspel dat voelt als verlies.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$score tegen $opponent. Zulke wedstrijden moeten we makkelijk winnen.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$score tegen $opponent. Gênant.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Maar een gelijkspel tegen $opponent, $score. Wie is hiervoor verantwoordelijk?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Als we hen niet verslaan, wie dan wel?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$score tegen $opponent. Hun fans vieren een gelijkspel tegen ons. Denk daar eens over na.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'KAMPIOEN. $opponent. Zeg het hardop.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'We hebben het gewonnen. $opponent. Het gaat niet goed met me.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, en de beker komt naar huis.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Stuk voor stuk een legende. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Zo dichtbij. $opponent en een medaille die niemand wil.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Verliezend finalist bij $opponent. Dit blijft jaren pijn doen.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: één wedstrijd van alles.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Tweede. Bij $opponent. Geef de fles maar door.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Uitgeschakeld bij $opponent. Dit doet nog even pijn.';
  }

  @override
  String yEliminated1(String opponent) {
    return 'Bij $opponent houdt het voor ons op.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Uitgeschakeld bij $opponent. Nu het onderzoek.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Eruit bij $opponent. Iemand moet me dat uitleggen.';
  }

  @override
  String yQualified0(String opponent) {
    return 'WE GAAN NAAR $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Gekwalificeerd voor $opponent. Neem maar vrij.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, here we come. Nooit twijfel (er was volop twijfel).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Door naar $opponent. Het moeilijkste is gedaan.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Groep getrokken voor $opponent. Had erger gekund. Had veel erger gekund.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Dus dat is de loting voor $opponent. Interessant.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'De groepen voor $opponent zijn bekend en de onze bevalt me nu al niet.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Loting voor $opponent gedaan. Laat de overdrijving maar beginnen.';
  }

  @override
  String yHostNamed0(String opponent) {
    return '$opponent wordt de gastheer. Begin maar te sparen.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Het gaat naar $opponent. Voorspelbaar, maar prima.';
  }

  @override
  String yHostNamed2(String opponent) {
    return '$opponent krijgt het toernooi. Gefeliciteerd, neem ik aan.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Gastheer bevestigd: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return '$opponent begint binnenkort en ik kan niet stilzitten.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Het duurt niet lang meer tot $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent is bijna daar. Selectie bekendmaken, graag.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'De aftelling naar $opponent is officieel ondraaglijk.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Nog niets te melden. Speel een wedstrijd.';

  @override
  String get yEarlierHeading => 'Eerder in deze cyclus';

  @override
  String get yTraitLoyalist =>
      'Steunt het team wat er ook gebeurt. Traag in omslaan, snel met vergeven.';

  @override
  String get yTraitCynic =>
      'Gaat uit van het ergste en is dolblij als hij gelijk krijgt.';

  @override
  String get yTraitNostalgic =>
      'Vroeger was alles beter. Meet je af aan mannen die gestopt zijn.';

  @override
  String get yTraitStatshead =>
      'Post de cijfers en verder niets. Heeft amper een stemming.';

  @override
  String get yTraitHypeman =>
      'Twee goede resultaten en het is een gouden generatie.';

  @override
  String get yTraitContrarian => 'Wat de rest ook vindt, het tegendeel.';

  @override
  String get yTraitDoomer => 'Het gaat misgaan. Het gaat altijd misgaan.';

  @override
  String get yProfilePosts => 'BERICHTEN';

  @override
  String get yProfileEmpty => 'Nog niets van dit account.';

  @override
  String hubEventGrievance(String player) {
    return '$player wil je spreken';
  }

  @override
  String get hubEventGrievanceSub => 'Hij wil weten waar hij staat';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vaardigheidspunten te besteden',
      one: '1 vaardigheidspunt te besteden',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Waar jij goed in bent, maakt je team beter';

  @override
  String get grievanceTitle => 'Een woordje op je kantoor';

  @override
  String grievanceGameTime(String player) {
    return '$player zit in de selectie en heeft geen bal geraakt. Hij wil weten waarom.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player zit niet in de selectie en snapt er niets van. Hij wil duidelijkheid, zo of zo.';
  }

  @override
  String grievanceRole(String player) {
    return '$player wordt steeds buiten zijn positie gezet en heeft er genoeg van.';
  }

  @override
  String get grievanceReassure => 'Je zit in mijn plannen';

  @override
  String get grievanceHonest => 'Anderen staan voor je, en dit is waarom';

  @override
  String get grievanceDismiss => 'Ik bepaal de opstelling';

  @override
  String yScorerStar0(String name, int goals) {
    return '$name maakte er $goals. Niemand anders komt in de buurt.';
  }

  @override
  String yScorerStar1(String name, int goals) {
    return '$goals voor $name. Hij draagt dit team.';
  }

  @override
  String yScorerStar2(String name, int goals) {
    return '$name: $goals vandaag. Wat een speler.';
  }

  @override
  String yScorerStar3(String name, int goals) {
    return '$goals voorbij ze geschoten, die $name. Maak een buiging.';
  }

  @override
  String yScorerStar4(String name, int goals) {
    return '$goals voor $name, en de rest waren passagiers.';
  }

  @override
  String yScorerStar5(String name, int goals) {
    return 'Weer $name. $goals. Stel je dit team voor zonder hem.';
  }

  @override
  String yScorerStar6(String name, int goals) {
    return '$goals van $name. Eén man zou dit niet allemaal hoeven doen.';
  }

  @override
  String yScorerStar7(String name, int goals) {
    return 'Haal $name eruit en het zijn er $goals minder en een heel andere middag.';
  }

  @override
  String yWinStreak0(int count) {
    return '$count op rij. Wat er ook in die kleedkamer gezegd wordt, het komt aan.';
  }

  @override
  String yWinStreak1(int count) {
    return 'Dat zijn er $count achter elkaar. Teams rollen niet zomaar in zo\'n reeks.';
  }

  @override
  String yWinStreak2(int count) {
    return '$count op rij en nog niet klaar. Het vertrouwen is zichtbaar vanaf de tribune.';
  }

  @override
  String yWinStreak3(int count) {
    return '$count zonder nederlaag. Vraag het elke trainer: dat is het moeilijkste.';
  }

  @override
  String yWinStreak4(int count) {
    return '$count op rij. Geniet ervan zolang het programma meewerkt.';
  }

  @override
  String yWinStreak5(int count) {
    return '$count achter elkaar, en we hebben niemand van betekenis verslagen.';
  }

  @override
  String yWinStreak6(int count) {
    return 'Een reeks van $count. Vraag het me nog eens als ze op de proef wordt gesteld.';
  }

  @override
  String yWinStreak7(int count) {
    return '$count aan een stuk. Elk team heeft er één keer zo\'n reeks in zitten.';
  }

  @override
  String yLossStreak0(int count) {
    return 'Nu $count zonder winst. Op een gegeven moment zijn de smoesjes op.';
  }

  @override
  String yLossStreak1(int count) {
    return 'Dat zijn er $count op rij weg. Dit is geen uitschieter meer.';
  }

  @override
  String yLossStreak2(int count) {
    return '$count nederlagen achter elkaar. Iemand moet daar antwoord op geven.';
  }

  @override
  String yLossStreak3(int count) {
    return '$count zonder winst. Je ziet het aan hoe ze spelen.';
  }

  @override
  String yLossStreak4(int count) {
    return '$count zonder winst en elke week dezelfde fouten.';
  }

  @override
  String yLossStreak5(int count) {
    return '$count op rij. Wat er ook geprobeerd wordt, het werkt niet.';
  }

  @override
  String yLossStreak6(int count) {
    return '$count achter elkaar. Dit is een richting, geen dipje.';
  }

  @override
  String yLossStreak7(int count) {
    return '$count zonder winst, en niemand boven heeft een woord gezegd.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Zeg over het voetbal wat je wilt. Deze telt dubbel.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Tegen $opponent, uitgerekend. $score. Niemand hier vergeet het.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score tegen $opponent. Dit is er één waar ze het in de kroeg over hebben.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Buren: $score. Opschepperij voor even beslecht.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Wat er dit jaar ook gebeurt, dit hebben we.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score tegen $opponent. Sommigen van ons hadden dit harder nodig dan de stand.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. En ze halen het de volgende keer terug, dat doen ze altijd.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Tegen $opponent, $score. Een heel jaar hieraan herinnerd worden.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name geblesseerd eraf. Dat had dit team als laatste nodig.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Het verlies van $name verandert de hele opzet.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name strompelt. Houd je adem in.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Dus een tijdje geen $name. Iemand moet opstaan.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name uit. Natuurlijk is het $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Zonder $name wordt dit een heel gewoon team.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name weer geblesseerd. Iemand moet zich afvragen waarom.';
  }

  @override
  String yInjuryBlow7(String name) {
    return '$name kwijt, en er staat niemand achter hem. Dat is het echte probleem.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Rood voor $name in minuut $minute en het hele land keert zich tegen hem. Hij heeft ons meer gegeven dan de meeste anderen. Laat het.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name eraf na $minute minuten. Hard. Met tien man deden we nog mee, dat zegt iets.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute minuten, rode kaart. Vanaf daar met tien man.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Uitsluiting: $name in minuut $minute. Niet de eerste wedstrijd die op één beslissing draait.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Briljant. $name loopt in minuut $minute van het veld en we zijn weer met tien.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name van het veld gestuurd na $minute minuten. Wie geeft hier eigenlijk training in discipline?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minuten. Zo lang hield $name zijn hoofd koel. Profvoetbal.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Rood voor $name in minuut $minute, en ik moet geloven dat dit vooruitgang is.';
  }

  @override
  String get yBoardPressure0 =>
      'Het bestuur is erg stil geworden. Dat is nooit een goed teken.';

  @override
  String get yBoardPressure1 => 'Naar verluidt stelt de bestuurskamer vragen.';

  @override
  String get yBoardPressure2 => 'Je voelt de grond boven verschuiven.';

  @override
  String get yBoardPressure3 =>
      'Niemand bij de bond zegt iets steunends. Trek je eigen conclusies.';

  @override
  String get yBoardPressure4 =>
      'Niemand boven heeft hem al weken in het openbaar gesteund.';

  @override
  String get yBoardPressure5 =>
      'De bond stookt tegen de eigen bondscoach. Zoals altijd.';

  @override
  String get yBoardPressure6 =>
      'Als een bestuur zwijgt, hebben ze al besloten.';

  @override
  String get yBoardPressure7 =>
      'Ze laten dit sudderen tot het de beslissing van iemand anders is.';

  @override
  String get yReplies => 'OOK OVER DEZE WEDSTRIJD';

  @override
  String get yPlayerGrievance0 =>
      'Gevraagd waar ik sta. Wacht nog op antwoord.';

  @override
  String get yPlayerGrievance1 => 'Hard trainen. Veel meer kan ik niet doen.';

  @override
  String get yPlayerGrievance2 => 'Sommige vragen stel je maar één keer.';

  @override
  String get yPlayerGrievance3 =>
      'Ik ben niet zo ver gekomen om de hesjes te dragen.';

  @override
  String get playerHonoursTitle => 'PRIJZEN';

  @override
  String get awardGoldenBall => 'Gouden Bal';

  @override
  String get awardGoldenBoot => 'Gouden Schoen';

  @override
  String get awardGoldenGlove => 'Gouden Handschoen';

  @override
  String get awardTeamOfTournament => 'Elftal van het Toernooi';

  @override
  String get awardPlayerOfYear => 'Wereldspeler van het Jaar';

  @override
  String get awardYoungPlayerOfYear => 'Jong Talent van het Jaar';

  @override
  String get playerClubHistory => 'CLUBGESCHIEDENIS';

  @override
  String get playerCareerRecord => 'LOOPBAANRECORD';

  @override
  String get playerInternationalGoals => 'Interlanddoelpunten';

  @override
  String get playerRecentForm => 'RECENTE VORM';

  @override
  String get playerMatchHistory => 'WEDSTRIJDGESCHIEDENIS';

  @override
  String get playerAttributes => 'EIGENSCHAPPEN';

  @override
  String get playerUnknown => 'Onbekend';

  @override
  String get playerAttrPace => 'Snelheid';

  @override
  String get playerAttrPhysical => 'Fysiek';

  @override
  String get playerAttrTechnical => 'Technisch';

  @override
  String get playerAttrShooting => 'Schieten';

  @override
  String get playerAttrPassing => 'Passen';

  @override
  String get playerAttrDribbling => 'Dribbelen';

  @override
  String get playerAttrTackling => 'Tackelen';

  @override
  String get playerAttrPositioning => 'Positiespel';

  @override
  String get playerAttrComposure => 'Koelbloedigheid';

  @override
  String get playerAttrDecisions => 'Beslissingen';

  @override
  String get playerAttrStamina => 'Uithoudingsvermogen';

  @override
  String get playerAttrStrength => 'Kracht';

  @override
  String get playerStatCaps => 'Interlands';

  @override
  String get playerStatGoals => 'Doelpunten';

  @override
  String get playerStatAssists => 'Assists';

  @override
  String get playerStatAvgRating => 'Gem. cijfer';

  @override
  String get playerStatForm => 'Vorm';

  @override
  String get playerStatMotm => 'Speler v/d wedstrijd';

  @override
  String get playerStatCleanSheets => 'Clean sheets';

  @override
  String get playerStatBestGame => 'Beste wedstrijd';

  @override
  String get playerStatCards => 'Kaarten';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}G ${reds}R';
  }

  @override
  String get tourSharedYourRun => 'JOUW REEKS';

  @override
  String get tourSharedList => 'Lijst';

  @override
  String get tourSharedBracket => 'Schema';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Groep $seed';
  }

  @override
  String get tourSharedThisEdition => 'Deze editie';

  @override
  String get tourSharedAllTime => 'Aller tijden';

  @override
  String get tourSharedUnknown => 'Onbekend';

  @override
  String get tourSharedActive => 'ACTIEF';

  @override
  String get tourSharedMedalTable => 'MEDAILLESPIEGEL';

  @override
  String get tourSharedPastWinners => 'EERDERE WINNAARS';

  @override
  String tourSharedHost(String host) {
    return 'Gastheer: $host';
  }

  @override
  String get tourSharedBeat => 'versloeg';

  @override
  String get tourSharedPens => ' (str.)';

  @override
  String get tourSharedAwardsEmpty =>
      'De prijzen worden uitgereikt zodra het toernooi is afgelopen.';

  @override
  String get tourSharedGoldenBall => 'GOUDEN BAL';

  @override
  String get tourSharedPlayerOfTournament => 'Speler van het Toernooi';

  @override
  String get tourSharedGoldenBoot => 'GOUDEN SCHOEN';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doelpunten',
      one: '1 doelpunt',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'GOUDEN HANDSCHOEN';

  @override
  String get tourSharedTeamOfTournament => 'ELFTAL VAN HET TOERNOOI';

  @override
  String get tourSharedStatsEmpty =>
      'Records verschijnen zodra de competitie wat geschiedenis heeft.';

  @override
  String get tourSharedRecordScorer => 'RECORDSCORER';

  @override
  String get tourSharedStillActive => 'nog actief';

  @override
  String get tourSharedMostTitles => 'MEESTE TITELS';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titels',
      one: '1 titel',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'MEESTE FINALES';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finales gespeeld',
      one: '1 finale gespeeld',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'MEESTE WEDSTRIJDEN';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wedstrijden',
      one: '1 wedstrijd',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'MEESTE EINDRONDES';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eindrondes',
      one: '1 eindronde',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'GROOTSTE FINALEWINST';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doelpunten',
      one: '1 doelpunt',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'nog actief';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titels',
      one: '1 titel',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finales gespeeld',
      one: '1 finale gespeeld',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wedstrijden',
      one: '1 wedstrijd',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eindrondes',
      one: '1 eindronde',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'RECORDHOUDERS ALLER TIJDEN';

  @override
  String get tourStatsTabGames => 'Wedstr.';

  @override
  String get tourStatsTabCups => 'Edities';

  @override
  String get tourStatsTabScorers => 'Scorers';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'tegen $opponent · $year';
  }

  @override
  String get tourHolders => 'TITELHOUDER';

  @override
  String tourHoldersSince(int year) {
    return 'gewonnen in $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'SCORERS ALLER TIJDEN';

  @override
  String get tourSharedSummaryEmpty =>
      'De gastheer en de stadions verschijnen zodra deze editie is geloot.';

  @override
  String get tourSharedHostHeading => 'GASTHEER';

  @override
  String get tourSharedHostsHeading => 'GASTHEREN';

  @override
  String get tourSharedCoHostsHeading => 'CO-GASTHEREN';

  @override
  String get tourSharedVenues => 'STADIONS';

  @override
  String get tourSharedMascot => 'MASCOTTE';

  @override
  String get tourSharedMatchBall => 'WEDSTRIJDBAL';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity zitplaatsen';
  }

  @override
  String get tourSharedCouldNotLoad => 'Laden mislukt.';

  @override
  String get tourSharedHostTbc => 'GASTHEER NOG TE BEVESTIGEN';

  @override
  String get tourSharedFinalsAreHere => 'DE EINDRONDE IS ER';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ORGANISATIE  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Laat de eindronde beginnen';

  @override
  String get tourSharedCompetitions => 'COMPETITIES';

  @override
  String get tourSharedWorldRanking => 'Wereldranglijst';

  @override
  String get tourSharedCouldNotLoadTournaments => 'Toernooien laden mislukt.';

  @override
  String get tourSharedPrestigeStage => 'HET GROTE PODIUM';

  @override
  String get tourSharedOverview => 'Overzicht';

  @override
  String get tourSharedWorldRankingTitle => 'Wereldranglijst';

  @override
  String get tourSharedYourCompetitions => 'JOUW COMPETITIES';

  @override
  String get tourSharedOtherContinents => 'ANDERE CONTINENTEN';

  @override
  String get tourSharedComingSoon => 'Toernooi komt binnenkort';

  @override
  String get tourSharedSoon => 'BINNENKORT';

  @override
  String get tourSharedNoQualifyingDraw => 'Geen kwalificatieloting.';

  @override
  String get tourSharedOpenEnvelope => 'Open de envelop';

  @override
  String tourSharedGroupName(String name) {
    return 'GROEP $name';
  }

  @override
  String get tourSharedBall => 'Bal';

  @override
  String get tourSharedPot => 'Pot';

  @override
  String get tourSharedAll => 'Alles';

  @override
  String get tourSharedTapDrawTeam => 'Tik om het volgende team te trekken';

  @override
  String get tourSharedTapDrawPot => 'Tik om de volgende pot te trekken';

  @override
  String get tourSharedTapDrawAll => 'Tik om de hele loting te tonen';

  @override
  String get tourSharedContinue => 'Doorgaan';

  @override
  String get tourSharedPause => 'Pauze';

  @override
  String get tourSharedPlay => 'Afspelen';

  @override
  String get tourSharedSkip => 'Overslaan';

  @override
  String tourSharedPotNumber(int number) {
    return 'POT $number';
  }

  @override
  String get tourSharedDrawComplete => 'LOTING KLAAR';

  @override
  String get tourSharedDrawing => 'LOTING…';

  @override
  String get tourContChampionship => 'KAMPIOENSCHAP';

  @override
  String get tourContTabSummary => 'SAMENVATTING';

  @override
  String get tourContTabQualifying => 'KWALIFICATIE';

  @override
  String get tourContTabFinals => 'EINDRONDE';

  @override
  String get tourContTabBracket => 'SCHEMA';

  @override
  String get tourContTabAwards => 'PRIJZEN';

  @override
  String get tourContTabScorers => 'SCORERS';

  @override
  String get tourContTabHistory => 'GESCHIEDENIS';

  @override
  String get tourContTabRecords => 'RECORDS';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Beker laden mislukt.\n$error';
  }

  @override
  String get tourContNoCupData => 'Geen bekergegevens.';

  @override
  String get tourContUnknown => 'Onbekend';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'De kwalificatiegroepen worden geloot tijdens de ceremonie. Kijk vanuit het hoofdmenu wie je treft.';

  @override
  String get tourContQualSeeded =>
      'Jouw land is rechtstreeks geplaatst voor de eindronde. Geen kwalificatie deze cyclus.';

  @override
  String tourContBackgroundRegion(String name) {
    return '$name wordt op de achtergrond gesimuleerd. Uitslagen verschijnen hier zodra elke ronde is gespeeld.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'De groepen voor de eindronde worden geloot tijdens de ceremonie. Kijk vanuit het hoofdmenu in welke groep je zit.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'De loting voor de eindronde vindt plaats zodra de kwalificatie is afgerond.';

  @override
  String get tourContContestedBeforeWc =>
      'De knock-outrondes worden gespeeld vóór het Wereldkampioenschap.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name KAMPIOENEN';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Winnaars $name';
  }

  @override
  String get tourContNoGoalsYet => 'Nog geen doelpunten gemaakt.';

  @override
  String tourContGroupHeading(String name) {
    return 'GROEP $name';
  }

  @override
  String get tourContBestRunnersUp => 'BESTE NUMMERS TWEE';

  @override
  String tourContGroupDropdown(String name) {
    return 'Groep $name';
  }

  @override
  String get tourContMatches => 'WEDSTRIJDEN';

  @override
  String get tourContNoGroupsDrawn => 'Nog geen groepen geloot.';

  @override
  String get tourContQualifyingDraw => 'KWALIFICATIELOTING';

  @override
  String get tourContWorldQualifyingDraw => 'WK-KWALIFICATIELOTING';

  @override
  String get tourContFinalsDraw => 'LOTING EINDRONDE';

  @override
  String get tourContSeedingPots => 'GEPLAATSTE POTTEN';

  @override
  String get tourContGroupDraw => 'GROEPSLOTING';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Loting laden mislukt.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'De loting is nog niet klaar.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'DEZE CYCLUS';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Laden mislukt.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Opgeslagen spel niet gevonden.';

  @override
  String get tourContClashSoon =>
      'De Continental Clash wordt gespeeld zodra beide continentale kampioenen bekend zijn.';

  @override
  String get tourContTwoContinentsOneMatch => 'TWEE CONTINENTEN, ÉÉN WEDSTRIJD';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name wint de Clash';
  }

  @override
  String get tourContNoClashYet => 'Nog geen Continental Clash gespeeld.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'DIVISIES';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Laden mislukt.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Nog geen doelpunten in de Nations Cup.';

  @override
  String get tourContNoNationsCupChampions =>
      'Nog geen Nations Cup-kampioenen gekroond.';

  @override
  String get tourContNationsCupOffSeason =>
      'De Nations Cup van deze cyclus begint na de continentale eindrondes. Eerdere winnaars staan onder Geschiedenis.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'De groepen van de Nations Cup van deze cyclus worden geloot tijdens de ceremonie. Kijk vanuit het hoofdmenu om te zien wie je treft.';

  @override
  String get tourContLeagueNoGroups =>
      'Geen wedstrijden in deze divisie deze ronde.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'DIVISIE $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'DIVISIE $letter · JOUW DIVISIE';
  }

  @override
  String get tourContFinalsFourSoon =>
      'De Final Four wordt gespeeld door de groepswinnaars van de A-divisie zodra de groepsfase voorbij is.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Divisie $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Divisie $letter ★';
  }

  @override
  String get tourContSemiFinals => 'HALVE FINALES';

  @override
  String get tourContFinal => 'FINALE';

  @override
  String get tourContNationsCupDraw => 'LOTING NATIONS CUP';

  @override
  String get tourContIntercontinentalPlayoff => 'INTERCONTINENTALE PLAY-OFF';

  @override
  String get tourContNoPlayoffThisCycle => 'Geen play-off in deze cyclus.';

  @override
  String get tourContPlayoffIntro =>
      'Twee WK-plaatsen worden beslist in een knock-outronde tussen de beste verliezers uit de kwalificatie.';

  @override
  String get tourContPlayoffThrough =>
      'Je hebt de play-off doorstaan. Je staat op het WK!';

  @override
  String get tourContPlayoffOut =>
      'Je viel net buiten de boot in de play-off. Dit keer geen WK.';

  @override
  String get tourContContinue => 'Doorgaan';

  @override
  String get tourContPlayoffFinals => 'PLAY-OFFFINALES';

  @override
  String get tourContPlayoffSeeded => 'Geplaatst (bye)';

  @override
  String get tourCupTabSummary => 'OVERZICHT';

  @override
  String get tourCupTabQualifying => 'KWALIFICATIE';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'De intercontinentale play-off wordt beslist zodra de kwalificatie van elke continentale bond is afgerond.';

  @override
  String get tourCupTabFinals => 'EINDRONDE';

  @override
  String get tourCupTabBracket => 'SCHEMA';

  @override
  String get tourCupTabAwards => 'PRIJZEN';

  @override
  String get tourCupTabScorers => 'SCHUTTERS';

  @override
  String get tourCupTabHistory => 'GESCHIEDENIS';

  @override
  String get tourCupTabRecords => 'RECORDS';

  @override
  String get tourCupTitle => 'WERELDKAMPIOENSCHAP';

  @override
  String get tourCupNoData => 'Geen toernooigegevens.';

  @override
  String tourCupLoadError(String error) {
    return 'Toernooi laden mislukt.\n$error';
  }

  @override
  String get tourCupUnknown => 'Onbekend';

  @override
  String get tourCupWorldChampions => 'WERELDKAMPIOENEN';

  @override
  String get tourCupWorldChampionsTitle => 'Wereldkampioenen';

  @override
  String get tourCupStillActive => 'Nog actief';

  @override
  String get tourCupAllTimeScorers => 'TOPSCHUTTERS ALLER TIJDEN';

  @override
  String get tourCupAllConfederations => 'Alle continentale bonden';

  @override
  String get tourCupBestRunnersUp => 'Beste nummers twee';

  @override
  String get tourCupCompWorld => 'Wereldkampioenschap';

  @override
  String get tourCupCompEurope => 'Europees Kampioenschap';

  @override
  String get tourCupCompSAmerica => 'Zuid-Amerikaanse Beker';

  @override
  String get tourCupDestRoundOf16 => 'de achtste finale';

  @override
  String get tourCupDestKnockouts => 'de knock-outfase';

  @override
  String get tourCupDestFinals => 'de eindronde';

  @override
  String get tourCupDestFinalsPlayoff => 'de play-off voor de eindronde';

  @override
  String get tourCupDestIntercontPlayoff => 'de intercontinentale play-off';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'De eindronde wordt geloot zodra de kwalificatie voorbij is.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Groepen nog te loten. Bekijk de WK-loting vanuit het hoofdmenu om ze te onthullen.';

  @override
  String tourCupGroupName(String name) {
    return 'Groep $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Groep $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Gastheer: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Gastheren: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Intercontinentale play-off';

  @override
  String get tourCupKnockoutSoon =>
      'Het schema begint zodra de groepsfase voorbij is.';

  @override
  String get tourCupMatches => 'WEDSTRIJDEN';

  @override
  String get tourCupMedalTable => 'MEDAILLESPIEGEL';

  @override
  String get tourCupMostTitles => 'MEESTE TITELS';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    String _temp0 = intl.Intl.pluralLogic(
      titles,
      locale: localeName,
      other: '$titles titels',
      one: '1 titel',
    );
    String _temp1 = intl.Intl.pluralLogic(
      editions,
      locale: localeName,
      other: '$editions edities',
      one: '1 editie',
    );
    return '$nation: $_temp0 uit $_temp1';
  }

  @override
  String get tourCupNoGoals => 'Nog geen doelpunten.';

  @override
  String get tourCupNoGroups => 'Geen groepen geloot.';

  @override
  String get tourCupNoHistory => 'Nog geen geschiedenis.';

  @override
  String get tourCupPastWinners => 'EERDERE WINNAARS';

  @override
  String get tourCupPlayoffIntro =>
      'Twee WK-plaatsen worden beslist in een knock-outronde tussen de beste verliezers uit de kwalificatie.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation speelt geen play-off: alle plaatsen worden in de kwalificatiegroepen beslist.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Groepen nog te loten. Bekijk de kwalificatieloting vanuit het hoofdmenu om ze te onthullen.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · jouw regio';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (pen.)';
  }

  @override
  String get tourCupSegAllTime => 'Aller tijden';

  @override
  String get tourCupSegFinals => 'Eindronde';

  @override
  String get tourCupSegQualifying => 'Kwalificatie';

  @override
  String get playerTraitsTitle => 'BEKEND OM';

  @override
  String get traitBigGame => 'Grotewedstrijdenspeler';

  @override
  String get traitBigGameBlurb => 'Tilt zijn spel op in knock-outwedstrijden.';

  @override
  String get traitSetPiece => 'Dode-spelmomentspecialist';

  @override
  String get traitSetPieceBlurb =>
      'Betere voorzetten en meer doelpunten uit spelhervattingen.';

  @override
  String get traitHothead => 'Heethoofd';

  @override
  String get traitHotheadBlurb =>
      'Pikt veel meer kaarten op dan zijn teamgenoten.';

  @override
  String get traitIronMan => 'IJzervreter';

  @override
  String get traitIronManBlurb =>
      'Raakt zelden geblesseerd en wordt minder snel moe.';

  @override
  String get traitWonderkid => 'Wonderkind';

  @override
  String get traitWonderkidBlurb =>
      'Jong, nu al goed en nog steeds snel in ontwikkeling.';

  @override
  String get traitLeader => 'Leider';

  @override
  String get traitLeaderBlurb =>
      'Tilt elke teamgenoot op het veld naar een hoger niveau.';

  @override
  String get traitPacey => 'Snelheidsduivel';

  @override
  String get traitPaceyBlurb => 'Razendsnel, een gevaar in de diepte.';

  @override
  String get traitOldHead => 'Oude rot';

  @override
  String get traitOldHeadBlurb =>
      'Een veteraan wiens spelinzicht zijn benen overleeft.';

  @override
  String get traitWasteful => 'Slordig afmaker';

  @override
  String get traitWastefulBlurb => 'Schiet te veel goede kansen naast.';

  @override
  String get objectiveWorldCup => 'Wereldkampioenschap';

  @override
  String get objectiveWinTournament => 'Win het toernooi';

  @override
  String get objectiveQualifyGeneric => 'Kwalificeer je';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Win het Wereldkampioenschap';

  @override
  String get objectiveReachFinal => 'Bereik de finale';

  @override
  String get objectiveReachSemis => 'Bereik de halve finale';

  @override
  String get objectiveReachQuarters => 'Bereik de kwartfinale';

  @override
  String get objectiveReachKnockouts => 'Bereik de knock-outfase';

  @override
  String get objectiveQualify => 'Kwalificeer je voor het Wereldkampioenschap';

  @override
  String get finishChampions => 'Kampioen';

  @override
  String get finishRunnersUp => 'Verliezend finalist';

  @override
  String get finishSemiFinals => 'Halve finale';

  @override
  String get finishQuarterFinals => 'Kwartfinale';

  @override
  String get finishRoundOf16 => 'Achtste finale';

  @override
  String get finishGroupStage => 'Groepsfase';

  @override
  String get objectiveQualifyingTopHalf =>
      'Eindig in de bovenste helft van de kwalificatie';

  @override
  String get objectiveQualifyingChallenge =>
      'Strijd om een plek, minstens de bovenste helft van de kwalificatie';

  @override
  String get finishQualifyingTopHalf =>
      'Bovenste helft van de kwalificatiegroep';

  @override
  String get finishQualifyingBottomHalf =>
      'Onderste helft van de kwalificatiegroep';

  @override
  String get objectiveNcWinIt => 'Win de Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Bereik de finale van de Nations Cup';

  @override
  String get objectiveNcFinalsFour => 'Bereik de Final Four';

  @override
  String get objectiveNcWinGroup => 'Win je groep en promoveer';

  @override
  String get objectiveNcTopHalf => 'Eindig in de bovenste helft van je groep';

  @override
  String get objectiveNcSurvive => 'Vermijd degradatie';

  @override
  String get objectiveNcOffTheBottom => 'Eindig niet onderaan je groep';

  @override
  String get finishNcChampions => 'Winnaar van de Nations Cup';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Groepswinnaar';

  @override
  String get finishNcTopHalf => 'Bovenste helft van de groep';

  @override
  String get finishNcStayedUp => 'Behouden voor de divisie';

  @override
  String get finishNcClearOfBottom => 'Niet onderaan de groep';

  @override
  String get finishNcBottom => 'Onderaan de groep';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'SPELER';

  @override
  String get squadDevAge => 'LEEFT.';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'CIJFER';

  @override
  String get squadDevNew => 'NIEUW';

  @override
  String get squadDevRetired => 'GESTOPT';

  @override
  String get squadDevEmpty =>
      'Een rustig jaar. Geen veranderingen in de selectie.';

  @override
  String get squadDevTierRegulars => 'VASTE KRACHTEN';

  @override
  String get squadDevTierFringe => 'RANDFIGUREN';

  @override
  String get squadDevTierYouth => 'JEUGD';

  @override
  String get boardObjectivesTitle => 'Bestuursdoelen';

  @override
  String get boardObjectivesConfidence => 'Vertrouwen van het bestuur';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rondes beter dan gevraagd',
      one: 'een ronde beter dan gevraagd',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds rondes tekort',
      one: 'een ronde tekort',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'NOG TE BESLISSEN';

  @override
  String boardObjectiveSoFar(String result) {
    return 'TOT NU TOE · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Het bestuur heeft voor deze cyclus geen doel gesteld.';

  @override
  String get tourContBestWinners => 'BESTE GROEPSWINNAARS';

  @override
  String get tourContBestThirds => 'BESTE NUMMERS DRIE';

  @override
  String tourContBestPlaced(String position) {
    return 'BESTE NUMMERS $position';
  }

  @override
  String squadDevPageOf(String page, String pages, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total spelers',
      one: '1 speler',
    );
    return '$page/$pages · $_temp0';
  }

  @override
  String get matchSoldOut => 'UITVERKOCHT';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance van $capacity plaatsen bezet';
  }

  @override
  String get matchGroundTitle => 'STADION';

  @override
  String get absenceInjured => 'Geblesseerd';

  @override
  String get absenceSuspended => 'Geschorst';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString weken',
      one: '1 week',
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
      other: '$countString wedstrijden',
      one: '1 wedstrijd',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Terug voor $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Strafschoppen';

  @override
  String get penaltyOrderBlurb =>
      'Kies je vijf nemers, op volgorde. Tik op een plek om te wijzigen.';

  @override
  String penaltyOrderPick(int number) {
    return 'Strafschop $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Kies wie er aantreedt. De balk toont zijn koelbloedigheid vanaf de stip.';

  @override
  String get penaltyOrderConfirm => 'Nemen maar';

  @override
  String get penaltyOrderCancel => 'Terug';

  @override
  String get youthTitle => 'Jeugd';

  @override
  String get youthEmptyLevel => 'Nog niemand op dit niveau.';

  @override
  String get youthReleased => 'Dit jaar vrijgegeven';

  @override
  String get u21Title => 'Onder 21';

  @override
  String get u21Blurb =>
      'De volgende generatie, grootste talent eerst. Lege sterren zijn een schatting van een scout. Geef een speler een interland om te ontdekken wat hij echt in huis heeft.';

  @override
  String get u21Empty =>
      'Op dit moment niemand onder de 21 in de pool. De volgende lichting komt met de nieuwe cyclus.';

  @override
  String u21Breakout(int gain) {
    return '+$gain DIT JAAR';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps interlands',
      one: '1 interland',
    );
    return 'Leeftijd $age · $_temp0';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Leeftijd $age · zonder interland';
  }

  @override
  String get u21CallUps => 'Naar de selectie';

  @override
  String get youthWatching => 'Gevolgd';

  @override
  String get youthWatchEmpty =>
      'Nog niemand gemarkeerd. Markeer een jongen op elk niveau en hij verschijnt hier, met wat hij sindsdien is geworden.';

  @override
  String get youthWatchMark => 'Volg deze jongen';

  @override
  String get youthWatchUnmark => 'Niet meer volgen';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Gemarkeerd met $rating, op $age-jarige leeftijd';
  }

  @override
  String get youthWatchSenior => 'Doorgestroomd naar de senioren';

  @override
  String get youthWatchReleased => 'Vrijgegeven door de academie';

  @override
  String get youthWatchGone => 'Niet meer in de piramide';

  @override
  String get tacticsYouth => 'Onder 21';

  @override
  String get pressSquad => 'Selectie';

  @override
  String get pressBoard => 'Bestuur';

  @override
  String get pressNoEffect => 'Niemand leest er veel in';

  @override
  String get matchNeutralGround => 'NEUTRAAL';

  @override
  String get matchExtraTimeAhead => 'VERLENGING';

  @override
  String get matchExtraTimeHalf => 'VERLENGING · RUST';

  @override
  String get matchClockFullTime => 'EINDSIGNAAL';

  @override
  String get matchClockAfterExtraTime => 'NA VERLENGING';

  @override
  String get matchClockPenalties => 'STRAFSCHOPPEN';

  @override
  String get matchClockFullTimePenalties => 'EINDSIGNAAL · PENALTY\'S';

  @override
  String get hubEventPressConference => 'Sta de pers te woord';

  @override
  String get hubEventPressConferenceSub =>
      'De wereldpers wil je spreken voor je volgende wedstrijd';

  @override
  String get squadDevWonderkid => 'WONDERKIND';

  @override
  String get tacticsPlaystyle => 'Speelstijl';

  @override
  String get tacticsPlaystyleBlurb =>
      'Kies hoe het team speelt; de knoppen hieronder stellen het bij.';

  @override
  String get tacticsPlaystyleCustom =>
      'Je eigen instellingen. Geen enkele vaste stijl past bij deze knoppen.';

  @override
  String get playstyleCustom => 'Eigen';

  @override
  String get playstyleBalanced => 'Gebalanceerd';

  @override
  String get playstylePossession => 'Balbezit';

  @override
  String get playstyleGegenpress => 'Gegenpressing';

  @override
  String get playstyleCounter => 'Counter';

  @override
  String get playstyleDirect => 'Direct';

  @override
  String get playstyleLowBlock => 'Laag blok';

  @override
  String get playstyleWingPlay => 'Vleugelspel';

  @override
  String get playstyleBalancedBlurb =>
      'Solide in beide helften, zonder overdrijving.';

  @override
  String get playstylePossessionBlurb =>
      'Houd de bal, speel geduldig rond en knijp het veld dicht.';

  @override
  String get playstyleGegenpressBlurb =>
      'Win de bal terug op het moment dat je hem kwijtraakt, hoog op het veld.';

  @override
  String get playstyleCounterBlurb =>
      'Zak in, blijf compact en sla dan snel toe.';

  @override
  String get playstyleDirectBlurb =>
      'Vroeg naar voren en jagen op de tweede bal.';

  @override
  String get playstyleLowBlockBlurb => 'Diep, smal en zeer moeilijk te openen.';

  @override
  String get playstyleWingPlayBlurb =>
      'Maak het veld breed, ga langs de flanken en geef voorzetten.';

  @override
  String get nationsRandomTeam => 'Willekeurig land';

  @override
  String get nationsFromTheBottom => 'Van onderaf';

  @override
  String get bottomStartTitle => 'Zonder werk';

  @override
  String get bottomStartHeading => 'Drie bonden willen met je praten';

  @override
  String get bottomStartBlurb =>
      'Je hebt geen baan en geen reputatie. Dit zijn de enige landen die een gok op je willen wagen. Kies er een en bouw iets op uit het niets.';

  @override
  String get bottomStartAccept => 'Accepteren';

  @override
  String get bottomStartBack => 'Terug naar menu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return '$rank van $total in de wereld';
  }

  @override
  String get campTitle => 'Basiskamp';

  @override
  String campBasedIn(String host) {
    return 'Gevestigd in $host';
  }

  @override
  String get campBlurb =>
      'Waar de selectie het hele toernooi verblijft. Het kan niet meer worden gewijzigd zodra het spel begint en werkt elke wedstrijd op drie punten: hoe fris ze aankomen, hoe snel een knauw geneest en hoe scherp ze zijn.';

  @override
  String get campEffectTravel => 'Fris aankomen';

  @override
  String get campEffectRecovery => 'Blessures genezen';

  @override
  String get campEffectSharpness => 'Wedstrijdscherpte';

  @override
  String get campTerrainCity => 'Stadscentrum';

  @override
  String get campTerrainCoastal => 'Kustoord';

  @override
  String get campTerrainMountain => 'Bergretraite';

  @override
  String get campTerrainAltitude => 'Hoogtekamp';

  @override
  String get campTerrainNationalCentre => 'Nationaal centrum';

  @override
  String get campTerrainCityBlurb =>
      'Alles om de hoek en niets om naartoe te reizen, maar geen rust en geen ontsnapping aan het lawaai.';

  @override
  String get campTerrainCoastalBlurb =>
      'Rustig, comfortabel en goed voor de sfeer; een lange busrit naar elk stadion.';

  @override
  String get campTerrainMountainBlurb =>
      'Frisse lucht en een eersteklas medische opzet die knauwen snel laat genezen, ver van het toernooi.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Zwaar om in te trainen, maar met benen die tot diep in het toernooi meegaan.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'De eigen faciliteiten van de bond: niets spectaculairs, niets dat misgaat.';

  @override
  String get hubEventChooseCamp => 'Kies het basiskamp';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Waar de selectie verblijft in $host';
  }

  @override
  String get tacticsTabBench => 'Bank';

  @override
  String get squadSearchHint => 'Zoek op naam of club';

  @override
  String get squadFilterAll => 'Iedereen';

  @override
  String get squadFilterInSquad => 'In de selectie';

  @override
  String get squadFilterUncapped => 'Zonder interland';

  @override
  String get squadFilterUnavailable => 'Niet beschikbaar';

  @override
  String get squadLineAll => 'Alle linies';

  @override
  String get squadSortBy => 'Sorteer';

  @override
  String get squadSortRating => 'Cijfer';

  @override
  String get squadSortCaps => 'Interlands';

  @override
  String get squadSortGoals => 'Doelpunten';

  @override
  String get squadSortAge => 'Leeftijd';

  @override
  String get squadSortName => 'Naam';

  @override
  String get squadLegendTitle => 'Wat de tekens betekenen';

  @override
  String get squadLegendStarting => 'In je basiself';

  @override
  String get squadLegendCalledUp => 'Opgeroepen, op de bank';

  @override
  String get squadLegendRatingUp => 'Cijfer stijgt dit jaar';

  @override
  String get squadLegendRatingDown => 'Cijfer daalt dit jaar';

  @override
  String get squadLegendInjured => 'Geblesseerd, niet beschikbaar';

  @override
  String get squadLegendSuspended => 'Geschorst, niet beschikbaar';

  @override
  String get squadLegendTraits => 'BEKEND OM';

  @override
  String squadShowingOf(int shown, int total) {
    return '$shown van $total spelers getoond';
  }

  @override
  String get squadNobodyMatches =>
      'Niemand in de pool voldoet aan die filters.';

  @override
  String get squadStatPool => 'Pool';

  @override
  String get squadStatInSquad => 'Opgeroepen';

  @override
  String get squadMostCapped => 'Meeste interlands';

  @override
  String get squadTopScorer => 'Topscorer';

  @override
  String squadCapsValue(String name, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps interlands',
      one: '1 interland',
    );
    return '$name · $_temp0';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals doelpunten',
      one: '1 doelpunt',
    );
    return '$name · $_temp0';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Int.';

  @override
  String get squadGoalsShort => 'Gls';

  @override
  String get recordsRecordBookSubtitle =>
      'Interlands, doelpunten en de belangrijkste records van het team';

  @override
  String get statsLegacy => 'NALATENSCHAP';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name is al gewisseld en kan niet meer terugkomen.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name is van het veld gestuurd en doet niet meer mee.';
  }

  @override
  String get tacticsInjuredShort => 'BLESSURE';

  @override
  String get tacticsSuspendedShort => 'GESCHORST';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'Zuid-Amerika';

  @override
  String get confNorthAmerica => 'Noord-Amerika';

  @override
  String get confAfrica => 'Afrika';

  @override
  String get confAsia => 'Azië';

  @override
  String get confOceania => 'Oceanië';

  @override
  String get compWorldCup => 'Wereldkampioenschap';

  @override
  String get compWorldCupFinals => 'Eindronde Wereldkampioenschap';

  @override
  String get compWorldCupQualifying => 'WK-kwalificatie';

  @override
  String compQualifiers(String region) {
    return 'Kwalificatie $region';
  }

  @override
  String get compFriendlies => 'Oefenwedstrijden';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Intercontinentale play-off';

  @override
  String get compContinentalChampionship => 'Continentaal Kampioenschap';

  @override
  String get compEuropeanChampionship => 'Europees Kampioenschap';

  @override
  String get compSouthAmericaCup => 'Zuid-Amerikaanse Beker';

  @override
  String get compAfricanChampionship => 'Afrikaans Kampioenschap';

  @override
  String get compAsianChampionship => 'Aziatisch Kampioenschap';

  @override
  String get compNorthAmericaCup => 'Beker van Noord-Amerika';

  @override
  String get compOceaniaCup => 'Oceanische Beker';

  @override
  String get msgANation => 'Een land';

  @override
  String get msgAPlayer => 'Een speler';

  @override
  String get msgAHostNation => 'een gastland';

  @override
  String get msgCycleTitle1 => 'Een nieuwe cyclus begint';

  @override
  String msgCycleTitle2(int year) {
    return 'De weg naar $year gaat open';
  }

  @override
  String get msgCycleTitle3 => 'Een nieuwe campagne breekt aan';

  @override
  String get msgCycleTitle4 => 'Weer aan de slag';

  @override
  String msgCycleBody1(int year) {
    return 'De weg naar het WK van $year begint hier.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Een nieuwe cyclus. Het WK van $year is het doel.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Nog vier jaar tot het WK van $year. Het werk begint nu.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'De campagne voor $year begint vandaag.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Gastheer $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return '$host is gastheer van de volgende editie van $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Kwalificatieloting $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'De kwalificatiegroepen voor $cup zijn geloot.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Gastheer WK $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return '$host is gastheer van het WK van $year.';
  }

  @override
  String get msgWcQualDrawTitle => 'Kwalificatieloting WK';

  @override
  String get msgWcQualDrawBody =>
      'De kwalificatiegroepen voor het WK zijn geloot.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Eindrondeloting $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'De groepen voor de eindronde van $cup zijn geloot.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'Eindrondeloting WK';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'De loting voor de eindronde van het WK van $year heeft plaatsgevonden.';
  }

  @override
  String get msgQualWcTitle1 => 'Door naar het Wereldkampioenschap';

  @override
  String get msgQualWcTitle2 => 'WK-ticket binnen';

  @override
  String get msgQualWcTitle3 => 'We gaan naar het WK';

  @override
  String get msgQualWcTitle4 => 'Ticket geprikt';

  @override
  String msgQualWcBody1(int year) {
    return 'Je hebt je gekwalificeerd voor de eindronde van het WK van $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Het is officieel: jouw land staat op het WK van $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Een plek op het WK van $year is binnen.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Je bent door naar de eindronde van het WK van $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Door naar $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup: ticket binnen';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Gekwalificeerd voor $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Je hebt je gekwalificeerd voor de eindronde van $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Jouw land heeft zijn plek op $cup veiliggesteld.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Je bent door naar $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return 'KAMPIOEN BIJ $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Kampioen van $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Je hebt $comp gewonnen!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp beslist';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'Kampioen van $comp gekroond';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp heeft een winnaar';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Jouw land is kampioen van $comp $year en versloeg $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Je hebt $comp $year gewonnen en $loser verslagen$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year is van jou. $loser is verslagen$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner won $comp $year en versloeg $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner is kampioen van $comp $year na winst op $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' met $home–$away in de finale';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' via strafschoppen, na een $home–$away in de finale';
  }

  @override
  String get msgWpotyTitle => 'Wereldspeler van het Jaar';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) is uitgeroepen tot Wereldspeler van het Jaar $year, een van de jouwen.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) is uitgeroepen tot Wereldspeler van het Jaar $year.';
  }

  @override
  String get msgYpotTitle => 'Jong Talent van het Toernooi';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age jaar, is uitgeroepen tot Jong Talent van het Toernooi $year, een van de jouwen.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age jaar, is uitgeroepen tot Jong Talent van het Toernooi $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Je blijft op #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Geen verandering, nog steeds #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Stabiel op #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plaatsen',
      one: '1 plaats',
    );
    return 'In totaal $_temp0 omhoog, naar #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plaatsen',
      one: '1 plaats',
    );
    return 'Een stijging van $_temp0 tilt je naar #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plaatsen',
      one: '1 plaats',
    );
    return '$_temp0 omhoog, nu #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plaatsen',
      one: '1 plaats',
    );
    return 'In totaal $_temp0 omlaag, naar #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plaatsen',
      one: '1 plaats',
    );
    return 'Een daling van $_temp0 zet je op #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move plaatsen',
      one: '1 plaats',
    );
    return '$_temp0 omlaag, nu #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Jij staat bovenaan de wereld.';

  @override
  String msgRankLeadOther(String nation) {
    return '$nation staat bovenaan de wereld.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Wereldranglijst · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'De wereldranglijst is bijgewerkt. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Een stijging naar #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Een daling naar #$rank';
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
      other: '$move plaatsen',
      one: '1 plaats',
    );
    return '$tournament heeft de wereldranglijst door elkaar geschud. $nation begon op #$from en eindigde op #$to, een stijging van $_temp0.';
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
      other: '$move plaatsen',
      one: '1 plaats',
    );
    return '$tournament heeft de wereldranglijst door elkaar geschud. $nation begon op #$from en eindigde op #$to, een daling van $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Sinds de WK-loting';

  @override
  String get rankingSinceCycleStart => 'Sinds het begin van de campagne';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from naar #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name bereikt $count interlands';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name heeft nu $count interlands gespeeld voor jouw land.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name bereikt $count doelpunten';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name heeft $count interlanddoelpunten gemaakt voor jouw land.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Ontwikkeling van de selectie · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Doorgestroomd uit de academie · $year';
  }

  @override
  String get msgThroughNote =>
      'Dit is geen nieuwe lichting. Het zijn de jongens die op hun elfde binnenkwamen en nu zijn doorgegroeid naar de seniorenpool.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Nieuwe gezichten · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'De investering in de academie werpt vruchten af: deze lichting kwam sterker binnen dan anders.';

  @override
  String get msgIntakeNoteStanding =>
      'Het land kijkt naar dit team: nu de ploeg stijgt op de wereldranglijst kiezen de beste jongens voor voetbal, en daardoor kwam deze lichting sterker binnen.';

  @override
  String get msgIntakeNoteBoth =>
      'Het academiegeld en de opmars van de ploeg op de wereldranglijst werpen allebei vruchten af: deze lichting kwam sterker binnen dan anders.';

  @override
  String msgIntakeTitle(int year) {
    return 'Academielichting · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Je aanvoerder $name stopt';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name stopt als international';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name is op $age-jarige leeftijd gestopt met interlandvoetbal.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name is op $age-jarige leeftijd gestopt met interlandvoetbal en neemt afscheid met $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count interlands',
      one: '1 interland',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doelpunten',
      one: '1 doelpunt',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' De aanvoerdersband is vacant. Benoem een nieuwe aanvoerder via het selectiescherm.';

  @override
  String msgHofTitle(String name) {
    return '$name opgenomen in de Hall of Fame';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps interlands',
      one: '1 interland',
    );
    String _temp1 = intl.Intl.pluralLogic(
      goals,
      locale: localeName,
      other: '$goals doelpunten',
      one: '1 doelpunt',
    );
    return '$name treedt toe tot de Hall of Fame van jouw land ($_temp0, $_temp1). Bekijk hem onder Legendes.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name geschorst';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'de volgende $matches wedstrijden',
      one: 'je volgende wedstrijd',
    );
    return '$name $how en is geschorst voor $_temp0. Hij is niet beschikbaar voor selectie.';
  }

  @override
  String get hubBanHowSecondYellow => 'kreeg na een tweede gele kaart rood';

  @override
  String get hubBanHowViolent => 'kreeg direct rood voor gewelddadig gedrag';

  @override
  String get hubBanHowRed => 'werd van het veld gestuurd';

  @override
  String hubInjuryTitle(String name) {
    return '$name geblesseerd';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches wedstrijden',
      one: '1 wedstrijd',
    );
    return '$name liep een knauw op en is $_temp0 uitgeschakeld.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Verliezend finalist';

  @override
  String get hubRunnerUpTitle2 => 'Zo dichtbij, toch zo ver';

  @override
  String get hubRunnerUpTitle3 => 'Zilveren medailles';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Je haalde de finale van $cup maar verloor van $opponent. Zo dichtbij. Dit keer zilver.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Verslagen door $opponent in de finale van $cup. Verliezend finalist, pijnlijk dichtbij.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'De finale van $cup gleed je door de vingers tegen $opponent. Veel om trots op te zijn, maar geen beker.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Uitgeschakeld';

  @override
  String get hubKnockedOutTitle2 => 'Het einde van de weg';

  @override
  String get hubKnockedOutTitle3 => 'Reis voorbij';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Je bent uitgeschakeld op $cup, verslagen door $opponent in de $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return '$opponent maakt in de $stage een einde aan je $cup.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Je $cup eindigt in de $stage, verslagen door $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Uitgeschakeld in de groepsfase';

  @override
  String get hubGroupExitTitle2 => 'Eruit in de groepsfase';

  @override
  String get hubGroupExitTitle3 => 'Vroeg onder de douche';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Je $cup is voorbij na de groepsfase. Niet genoeg om de knock-outfase te halen.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Je kwam niet door de groep. Hier eindigt je $cup.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Dit keer geen plek in de knock-outfase. Jouw $cup zit erop na de groepsfase.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Doel gehaald: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Doel gemist: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Het doel van het bestuur bij $comp: $demand. Jouw resultaat: $finish. Het bestuur heeft wat het wilde.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Het doel van het bestuur bij $comp: $demand. Jouw resultaat: $finish. Dat blijft achter bij de verwachtingen.';
  }

  @override
  String get newsWcMissTitle => 'Droom van het Wereldkampioenschap voorbij';

  @override
  String newsWcMissBody(int year) {
    return 'Je hebt het Wereldkampioenschap van $year niet gehaald. De kwalificatiecampagne schoot tekort. Nog vier jaar wachten.';
  }

  @override
  String get newsRecordScorerTitle => 'Topscorer aller tijden';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name is nu de topscorer aller tijden van het spel met $goals doelpunten.';
  }

  @override
  String get newsRecordCapsTitle => 'Recordinterlandspeler';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name is nu de recordinterlandspeler van het spel met $caps interlands.';
  }

  @override
  String get newsARecordBreaker => 'Een nieuwe recordbreker';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name tekent bij $club';
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
    return '$name ($position, $rating) heeft $fromClub verlaten en tekent voor $fee bij $destination.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club in $country';
  }

  @override
  String get newsTransferFree => 'Gratis';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name wil overstappen naar $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name wil voor $nation spelen';
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
    return '$name, een $age-jarige $position met cijfer $rating die nu voor $fromNation uitkomt, heeft familiebanden met $nation en staat open voor een overstap. Open het naturalisatieaanbod om te accepteren of af te wijzen.';
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
    return '$name, een $age-jarige $position met cijfer $rating die nu voor $fromNation uitkomt, is een grote naam met familiebanden met $nation en staat open voor een overstap. Open het naturalisatieaanbod om te accepteren of af te wijzen.';
  }

  @override
  String get newsTheirNation => 'hun land';

  @override
  String get newsYourNation => 'jouw land';

  @override
  String get tourStatusChampions => 'KAMPIOEN';

  @override
  String get tourStatusFinals => 'EINDRONDE';

  @override
  String get tourStatusQualifying => 'KWALIFICATIE';

  @override
  String get tourStatusUpcoming => 'AANSTAAND';

  @override
  String get tourStatusInProgress => 'BEZIG';

  @override
  String get tourStatusComingSoon => 'BINNENKORT';

  @override
  String get tourStatusDecided => 'BESLIST';

  @override
  String tourStatusLeague(String letter) {
    return 'DIVISIE $letter';
  }

  @override
  String get tourDrawWcQualifying => 'WERELDKWALIFICATIELOTING';

  @override
  String tourDrawContQualifying(String cup) {
    return 'KWALIFICATIELOTING $cup';
  }

  @override
  String get tourDrawWcHost => 'WK-GASTHEER';

  @override
  String tourDrawContHost(String cup) {
    return 'GASTHEER $cup';
  }

  @override
  String get tourDrawHostsReveal => 'En de gastheren worden…';

  @override
  String get tourDrawHostReveal => 'En de gastheer wordt…';

  @override
  String get tourDrawHostCandidates => 'De kandidaten in de running:';

  @override
  String get tourKickoffContinentalCup => 'CONTINENTALE BEKER';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return '$cup gemist';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Je hebt je niet gekwalificeerd voor $cup. De campagne kwam dit keer tekort.';
  }

  @override
  String get potyLabelBest => 'Speler van het Jaar';

  @override
  String get potyLabelYoung => 'Jong Talent van het Jaar';

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
    return 'Cijfer $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Gemiddeld $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Wereldspeler van het Jaar $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name is dit jaar de beste speler ter wereld.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name wint de prijs voor het grootste talent.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'De jongens die je volgt, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain punten',
      one: 'een punt',
    );
    return '$name is doorgebroken naar $rating, $_temp0 meer dan vorig jaar.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name stroomt door naar de $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name maakt zijn debuut';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name heeft op $age-jarige leeftijd zijn eerste interland gespeeld, met cijfer $rating. Een van de jongens die je volgt.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Balbezit, spelerscijfers en de man van de wedstrijd liggen vast bij het eindsignaal.';

  @override
  String get matchPlayerRatings => 'SPELERSCIJFERS';

  @override
  String get matchSubstitutions => 'WISSELS';

  @override
  String get matchSubstitutes => 'WISSELSPELERS';

  @override
  String get matchLineupsViewPitch => 'Veld';

  @override
  String get matchLineupsViewList => 'Lijst';

  @override
  String get matchLineupsCameOn => 'Ingevallen';

  @override
  String get matchConditionsKickOff => 'Aftrap';

  @override
  String get matchWeatherClear => 'Helder';

  @override
  String get matchWeatherRain => 'Lichte regen';

  @override
  String get matchWeatherSnow => 'Sneeuw';

  @override
  String get matchWeatherHaze => 'Nevel';

  @override
  String get matchWeatherHeavyRain => 'Zware regen';

  @override
  String get matchWeatherThunderstorm => 'Onweer';

  @override
  String get matchWeatherFog => 'Mist';

  @override
  String get matchWeatherWindy => 'Harde wind';

  @override
  String get matchWeatherDustStorm => 'Zandstorm';

  @override
  String get matchWeatherFrostyNight => 'IJzige nacht';

  @override
  String get matchPlayerOfTheMatch => 'MAN VAN DE WEDSTRIJD';

  @override
  String get ratingPlayerOfTheMatch => 'Man van de wedstrijd';

  @override
  String ratingSemantics(String rating) {
    return 'Cijfer $rating';
  }

  @override
  String get matchAverageRating => 'Gemiddeld cijfer';

  @override
  String get matchLiveRatingsNote =>
      'De cijfers volgen de wedstrijd tot nu toe en zijn definitief bij het eindsignaal.';

  @override
  String get matchGoalShout => 'DOELPUNT!';

  @override
  String get matchRedCardShout => 'RODE KAART';

  @override
  String matchShootoutScore(int home, int away) {
    return 'STRAFSCHOPPEN $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: GESCOORD';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: GEMIST';
  }

  @override
  String get matchFeedKickOff => 'Aftrap!';

  @override
  String get matchFeedNoEvents => 'Nog geen gebeurtenissen.';

  @override
  String get tourVenues => 'STADIONS';

  @override
  String tourPot(int number) {
    return 'POT $number';
  }

  @override
  String get tourHostSelection => 'KEUZE GASTHEER';

  @override
  String get tourCandidates => 'KANDIDATEN';

  @override
  String get tourJointBid => 'GEZAMENLIJK BOD';

  @override
  String get tourGoldenGlove => 'GOUDEN HANDSCHOEN';

  @override
  String get tourTeamOfTournament => 'ELFTAL VAN HET TOERNOOI';

  @override
  String get tourYourRun => 'JOUW WEG';

  @override
  String get tourMedalTable => 'MEDAILLESPIEGEL';

  @override
  String tourHostLine(String nation) {
    return 'Gastheer: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Gastheren: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Groep $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Geplaatst volgens de wereldranglijst. Zoek je land voor de loting.';

  @override
  String get tourWorldRanking => 'Wereldranglijst';

  @override
  String get tourYourCompetitions => 'JOUW COMPETITIES';

  @override
  String get tourOtherContinents => 'ANDERE CONTINENTEN';

  @override
  String get tourZoneGlobal => 'WERELD';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'Z.-AMERIKA';

  @override
  String get tourZoneNorthAmerica => 'N.-AMERIKA';

  @override
  String get tourZoneAfrica => 'AFRIKA';

  @override
  String get tourZoneAsia => 'AZIË';

  @override
  String get tourZoneOceania => 'OCEANIË';

  @override
  String get tourZoneIntercontinental => 'INTERCONTINENTAAL';

  @override
  String tourZoneLeague(String league) {
    return 'DIVISIE $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'GASTHEER  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'De beste $count gaan door naar $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name stapt op';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: '$caps interlands',
      one: '1 interland',
    );
    return '$name is op $age-jarige leeftijd gestopt als international, met $_temp0. Hij vroeg om duidelijkheid over zijn positie en kreeg die niet, en hij wacht niet langer.';
  }

  @override
  String get pressHeadlineWent1 => 'Een bondscoach die de zaal de baas is';

  @override
  String get pressHeadlineWent2 => 'Ze kwamen voor ruzie en kregen een leider';

  @override
  String get pressHeadlineWent3 => 'Heldere antwoorden, en ze kwamen aan';

  @override
  String get pressHeadlineMixed1 => 'Veel gezegd, weinig beslist';

  @override
  String get pressHeadlineMixed2 => 'Iets voor iedereen, en niets voor niemand';

  @override
  String get pressHeadlineMixed3 =>
      'Een persconferentie die de vragen open liet';

  @override
  String get pressHeadlineBadly1 => 'Een pijnlijke middag voor de camera\'s';

  @override
  String get pressHeadlineBadly2 =>
      'De zaal keerde zich om, en dat was te zien';

  @override
  String get pressHeadlineBadly3 => 'Antwoorden die morgen slechter lezen';

  @override
  String get pressHeadlineFlat1 => 'Niets gezegd, niets gewonnen';

  @override
  String get pressHeadlineFlat2 => 'Tien minuten, geen nieuws';

  @override
  String get pressHeadlineFlat3 => 'Een blanco pagina voor de achterpagina';

  @override
  String get pressConferenceTitle => 'PERSCONFERENTIE';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Vraag $index van $total';
  }

  @override
  String get pressTomorrowsHeadline => 'ACHTERPAGINA VAN MORGEN';

  @override
  String get pressLeaveRoom => 'VERLAAT DE ZAAL';

  @override
  String get pressRoomVerdictSquad => 'Kleedkamer';

  @override
  String get pressRoomVerdictBoard => 'Bestuur';

  @override
  String get yReactionElation0 => 'geen opmerkingen. geen enkele. perfect.';

  @override
  String get yReactionElation1 => 'Ik voel me niet lekker (positief).';

  @override
  String get yReactionElation2 => 'ik ga dit inlijsten. boven de open haard.';

  @override
  String get yReactionElation3 => 'we zijn zo terug';

  @override
  String get yReactionElation4 =>
      'Screenshot voor de twijfelaars. Voor álle twijfelaars.';

  @override
  String get yReactionElation5 =>
      'Hier ga ik tien jaar lang onuitstaanbaar over doen.';

  @override
  String get yReactionElation6 => 'Juist. Daarom kijken we.';

  @override
  String get yReactionElation7 => 'Dagen als deze maken de rest goed.';

  @override
  String get yReactionElation8 => 'Het werd tijd. Echt, het werd tijd.';

  @override
  String get yReactionElation9 =>
      'Mooi. Doe het volgende week nog eens, dan geloof ik het.';

  @override
  String get yReactionElation10 =>
      'Geniet vanavond, want dit zootje vindt wel een manier om het te verpesten.';

  @override
  String get yReactionElation11 =>
      'Eén goede avond maakt niemand een grote ploeg.';

  @override
  String get yReactionRelief0 => 'Niet mooi, maar ik neem het elke keer.';

  @override
  String get yReactionRelief1 => 'Hoe dan ook. Hoe dan ook!';

  @override
  String get yReactionRelief2 => 'Lelijk. Drie punten. Door naar de volgende.';

  @override
  String get yReactionRelief3 =>
      'Ik neem de hele dag lelijk als er punten bij zitten.';

  @override
  String get yReactionRelief4 => 'daar ging tien jaar van mijn leven af';

  @override
  String get yReactionRelief5 => 'Niemand praten. Niemand het verpesten.';

  @override
  String get yReactionRelief6 => 'Hartslag: onacceptabel.';

  @override
  String get yReactionRelief7 => 'Overleefd. Dat is het woord. Overleefd.';

  @override
  String get yReactionRelief8 =>
      'Na zulke wedstrijden zouden we geen opluchting nodig moeten hebben.';

  @override
  String get yReactionRelief9 =>
      'Opgelucht, en een beetje beschaamd dat ik opgelucht ben.';

  @override
  String get yReactionRelief10 =>
      'Als dit de norm is waar we voor juichen, zitten we in de problemen.';

  @override
  String get yReactionRelief11 =>
      'Er net doorheen komen is een gewoonte, en geen goede.';

  @override
  String get yReactionFury0 => 'Niet goed genoeg. Bij lange na niet.';

  @override
  String get yReactionFury1 => 'Leg me dat maar eens rustig uit.';

  @override
  String get yReactionFury2 =>
      'Dat is zwaar om naar te kijken, en ik ben nog beleefd.';

  @override
  String get yReactionFury3 => 'Teleurgesteld. Echt teleurgesteld.';

  @override
  String get yReactionFury4 => 'Absolute schande.';

  @override
  String get yReactionFury5 => 'Ik wil namen.';

  @override
  String get yReactionFury6 => 'App verwijderen. Donderdag weer installeren.';

  @override
  String get yReactionFury7 => 'Niemand daar zag eruit alsof hij het wilde.';

  @override
  String get yReactionFury8 => 'Elke vier jaar hetzelfde. ELKE vier jaar.';

  @override
  String get yReactionFury9 => 'Dit is geen prestatie, het is een belediging.';

  @override
  String get yReactionFury10 =>
      'Mensen offeren weekenden en geld op voor dit. Denk daar eens over na.';

  @override
  String get yReactionFury11 =>
      'Ik verdedig deze ploeg al jaren. Vanavond niet. Niet na dit.';

  @override
  String get yReactionDespair0 => 'nou.';

  @override
  String get yReactionDespair1 => 'Vandaag geen grappen. Niets.';

  @override
  String get yReactionDespair2 => 'Even gaan wandelen. Een lange wandeling.';

  @override
  String get yReactionDespair3 => 'Ik heb geen woorden meer hiervoor.';

  @override
  String get yReactionDespair4 => 'Maak me over vier jaar wakker.';

  @override
  String get yReactionDespair5 => 'dit is de donkerste tijdlijn';

  @override
  String get yReactionDespair6 =>
      'Ik ben niet eens meer boos. Dat is het zorgwekkende.';

  @override
  String get yReactionDespair7 => 'Deze doet nog lang pijn.';

  @override
  String get yReactionDespair8 =>
      'Ik weet niet meer wat dit is, maar een voetbalploeg is het niet.';

  @override
  String get yReactionDespair9 =>
      'We staan verder weg dan eerst, en niemand durft het te zeggen.';

  @override
  String get yReactionDespair10 =>
      'Een hele generatie verspild en dezelfde mensen beslissen wat er nu gebeurt.';

  @override
  String get yReactionDespair11 =>
      'Hou op met zeggen dat het een proces is. Het gaat nergens heen.';

  @override
  String get yReactionSmugness0 => 'Zachtjes, maar: zei ik het niet.';

  @override
  String get yReactionSmugness1 => 'sla deze op';

  @override
  String get yReactionSmugness2 => 'De twijfelaars zijn opeens heel stil.';

  @override
  String get yReactionSmugness3 => 'Niet dat iemand telt. Ik tel.';

  @override
  String get yReactionSmugness4 => 'In januari al gezegd. Check de tijdlijn.';

  @override
  String get yReactionSmugness5 =>
      'Sommigen van jullie zijn ons een excuus verschuldigd.';

  @override
  String get yReactionSmugness6 =>
      'Dit gaat in de map \'dat zei ik als eerste\'.';

  @override
  String get yReactionSmugness7 => 'Niet opscheppen. Een beetje opscheppen.';

  @override
  String get yReactionSmugness8 => 'Waar zijn alle experts nu? Serieuze vraag.';

  @override
  String get yReactionSmugness9 => 'Ik wil dat elk van jullie het me nazegt.';

  @override
  String get yReactionSmugness10 =>
      'Screenshot, uitgeprint, ingelijst, opgestuurd naar de mensen die lachten.';

  @override
  String get yReactionSmugness11 =>
      'Hier begin ik de rest van mijn leven over en jullie hebben het verdiend.';

  @override
  String get yReactionShrug0 => 'het is gebeurd. volgende.';

  @override
  String get yReactionShrug1 => 'Prima. Maakt niet uit. Door.';

  @override
  String get yReactionShrug2 => 'Dit gaat onder \'voetbal\'.';

  @override
  String get yReactionShrug3 => 'Echt niets aan toe te voegen.';

  @override
  String get yReactionShrug4 => 'geen gedachten, hoofd leeg';

  @override
  String get yReactionShrug5 => 'Maak me wakker voor de volgende.';

  @override
  String get yReactionShrug6 => 'Negentig minuten die ik nooit terugkrijg.';

  @override
  String get yReactionShrug7 => 'Eigenlijk niks bijzonders.';

  @override
  String get yReactionShrug8 =>
      'Ik zou je niet kunnen zeggen wat er gebeurd is.';

  @override
  String get yReactionShrug9 => 'Weer zo eentje. Er zijn er veel van die.';

  @override
  String get yReactionShrug10 =>
      'Ik heb alles gezien en voelde helemaal niets.';

  @override
  String get yReactionShrug11 =>
      'Als niemand het hier nog over heeft, is dat prima voor mij.';

  @override
  String get tourThirdsUneven =>
      'De groepen zijn ongelijk, dus resultaten tegen de laagste ploeg van elke grote groep tellen niet mee en alle ploegen worden over dezelfde wedstrijden beoordeeld.';

  @override
  String get careerExportSave => 'Back-up van deze opslag maken';

  @override
  String get careerBackupAll => 'BACK-UP VAN ALLE OPSLAGEN';

  @override
  String get careerBackupAllFailed => 'De back-up kon niet worden geschreven.';

  @override
  String get backupTitle => 'BACK-UPS';

  @override
  String get backupBlurb =>
      'Alle spelbestanden staan in één bestand op deze telefoon, en niets maakt er vanzelf een back-up van, tenzij je hieronder de automatische back-up aanzet. Bewaar een kopie in de cloud, zodat een verloren telefoon of verwijderde app je geen carrière kost.';

  @override
  String get backupBlurbNoAuto =>
      'Alle spelbestanden staan in één bestand op deze telefoon, en niets maakt er vanzelf een back-up van. Bewaar een kopie in de cloud, zodat een verloren telefoon of verwijderde app je geen carrière kost.';

  @override
  String get backupExport => 'BACK-UP NAAR CLOUD';

  @override
  String get backupExportSubject => 'FNM-opslagen';

  @override
  String get backupRestore => 'HERSTEL UIT BESTAND';

  @override
  String get backupRestoreWarnTitle => 'Alle opslagen vervangen?';

  @override
  String get backupRestoreWarnBody =>
      'Herstellen vervangt alle opslagen op deze telefoon door die uit het bestand. De app wordt opnieuw gestart.';

  @override
  String get backupRestoreConfirm => 'VERVANGEN';

  @override
  String get backupCancel => 'ANNULEREN';

  @override
  String get backupExported => 'Back-up klaar. Kies waar je hem bewaart.';

  @override
  String get backupFailed => 'De back-up kon niet worden geschreven.';

  @override
  String get backupRejectedUnreadable => 'Dat bestand kon niet worden geopend.';

  @override
  String get backupRejectedNotFnm => 'Dat is geen FNM-opslag.';

  @override
  String get backupRejectedNewer =>
      'Die opslag is gemaakt met een nieuwere versie van de app. Update eerst.';

  @override
  String get backupRejectedTooOld =>
      'Die opslag is te oud om door deze versie te worden hersteld.';

  @override
  String get careerShare => 'Deel deze loopbaan';

  @override
  String get careerImport => 'LOOPBAAN IMPORTEREN';

  @override
  String get careerShareSubject => 'Een FNM-loopbaan';

  @override
  String get careerImported => 'Loopbaan geïmporteerd.';

  @override
  String get careerImportFailedUnreadable =>
      'Dat bestand is geen FNM-loopbaan.';

  @override
  String get careerImportFailedNewer =>
      'Die loopbaan is geëxporteerd door een nieuwere versie van de app. Update eerst.';

  @override
  String get careerImportFailedSlotsFull =>
      'Al je opslagplekken zijn in gebruik. Verwijder een opslag om ruimte te maken, of ontgrendel onbeperkt opslaan.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Die loopbaan is voorbij de gratis eerste cyclus. Ontgrendel het volledige spel om hem binnen te halen.';

  @override
  String get careerImportFailedCampaignRun =>
      'Die campagne heeft al een lopende poging. Hervat of beëindig die eerst.';

  @override
  String get careerShareFailed => 'Die loopbaan kon niet worden geëxporteerd.';

  @override
  String get managerRename => 'Naam wijzigen';

  @override
  String get managerRenameSave => 'Opslaan';

  @override
  String get managerTitle => 'BONDSCOACH';

  @override
  String get managerSkills => 'JOUW VAARDIGHEDEN';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punten om te besteden',
      one: '1 punt om te besteden',
      zero: 'Geen punten om te besteden',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Twee punten voor elke voltooide cyclus, één voor elke trofee die je wint.';

  @override
  String get managerSkillsScale =>
      'Elke vaardigheid begint op 5 en stopt op 20. Een besteed punt is blijvend.';

  @override
  String get managerSkillManManagement => 'Mensenkennis';

  @override
  String get managerSkillManManagementBlurb =>
      'Elk punt zorgt ervoor dat wat je tegen de pers en je spelers zegt 3% harder aankomt in de kleedkamer.';

  @override
  String get managerSkillTactical => 'Tactiek';

  @override
  String get managerSkillTacticalBlurb =>
      'Elk punt laat een nieuwe formatie 3% sneller inslijpen, zodat van vorm veranderen je minder wedstrijden kost.';

  @override
  String get managerSkillYouth => 'Jeugdopleiding';

  @override
  String get managerSkillYouthBlurb =>
      'Elk punt voegt 1% toe aan het talent dat uit je academie komt, bovenop wat je erin investeert.';

  @override
  String get managerSkillNegotiation => 'Onderhandelen';

  @override
  String get managerSkillNegotiationBlurb =>
      'Elk punt is 2% meer geld van de bond, elke cyclus.';

  @override
  String get managerStaff => 'JOUW STAF';

  @override
  String managerStaffWages(String amount) {
    return 'Salarissen: $amount per cyclus';
  }

  @override
  String get managerRoleAssistant => 'Assistent-trainer';

  @override
  String get managerRoleAssistantBlurb =>
      'Leidt de training: minder blessures en betere jonkies die doorstromen.';

  @override
  String get managerRoleScout => 'Hoofdscout';

  @override
  String get managerRoleScoutBlurb =>
      'Leest je talenten en je volgende tegenstander: betere sterrenwaardering en een voorsprong op wedstrijddag.';

  @override
  String get managerRoleFitness => 'Conditietrainer';

  @override
  String get managerRoleFitnessBlurb => 'Houdt ze op het veld.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% minder blessures';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Jonkies +$points totaalcijfer';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Eentje aannemen: $min% tot $max% minder blessures';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'en jonkies +$minPoints tot +$maxPoints totaalcijfer';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Leest $percent% van de talenten exact';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potentieel bekend na $caps interlands',
      one: 'Potentieel bekend na 1 interland',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points cijfer door dossiers over tegenstanders';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Eentje aannemen: $min% tot $max% exact gelezen';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'en potentieel $minCaps tot $maxCaps interlands eerder bekend';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'en +$minPoints tot +$maxPoints cijfer elke wedstrijd';
  }

  @override
  String get staffEffectNone => 'Nog geen effect op je selectie';

  @override
  String get staffVacant => 'Niemand in functie';

  @override
  String get staffLeaveVacant => 'Laat de functie leeg';

  @override
  String get managerTierNone => 'Geen';

  @override
  String get managerTierBasic => 'Basis';

  @override
  String get managerTierGood => 'Goed';

  @override
  String get managerTierElite => 'Elite';

  @override
  String get managerFree => 'gratis';

  @override
  String get managerTraining => 'TUSSEN INTERLANDPERIODES';

  @override
  String get managerTrainingBlurb =>
      'Waar de selectie aan werkt als er geen wedstrijd te spelen is.';

  @override
  String get managerFocusBalanced => 'Gebalanceerd';

  @override
  String get managerFocusBalancedBlurb => 'Een beetje van alles.';

  @override
  String get managerFocusFitness => 'Fitheid';

  @override
  String get managerFocusFitnessBlurb => 'Minder blessures.';

  @override
  String get managerFocusCohesion => 'Samenhang';

  @override
  String get managerFocusCohesionBlurb => 'De structuur slijpt sneller in.';

  @override
  String get managerFocusYouth => 'Jeugd';

  @override
  String get managerFocusYouthBlurb => 'Uren met de jongsten in de pool.';

  @override
  String get tourOfferTitle => 'Voor het eerst hier?';

  @override
  String get tourOfferBody =>
      'Dit is een groot spel. Wil je een korte rondleiding langs de schermen die ertoe doen? Het duurt een minuut en je kunt hem altijd opnieuw starten via Instellingen.';

  @override
  String get tourOfferYes => 'Leid me rond';

  @override
  String get tourOfferNo => 'Nee, bedankt';

  @override
  String get tourBack => 'Terug';

  @override
  String get tourNext => 'Volgende';

  @override
  String get tourDone => 'Klaar';

  @override
  String get tourSkip => 'Overslaan';

  @override
  String get tourHubTitle => 'Dit is het hele spel';

  @override
  String get tourHubBody =>
      'Eén knop, die verandert als de cyclus vordert: een loting om te bekijken, een selectie om bekend te maken, een wedstrijd om te spelen. Erboven staan het vertrouwen van het bestuur in jou en de doelen die ze hebben gesteld.';

  @override
  String get tourBudgetTitle => 'Het geld van de bond';

  @override
  String get tourBudgetBody =>
      'Eén keer per cyclus van vier jaar verdeel je de oorlogskas over de afdelingen. Je staf wordt er eerst uit betaald, dus een elite-scout aannemen is een keuze ten koste van de academie, niet ernaast.';

  @override
  String get tourTacticsTitle => 'Hoe de ploeg speelt';

  @override
  String get tourTacticsBody =>
      'Je formatie, je speelwijze, je aanvoerder en wie de standaardsituaties neemt. Laat de laatste twee leeg en het spel waarschuwt je voor de aftrap in plaats van stilletjes voor je te kiezen.';

  @override
  String get tourSquadTitle => 'Iedereen die je kunt kiezen';

  @override
  String get tourSquadBody =>
      'De hele pool, niet alleen de selectie: wie in vorm is, wie een knauw heeft, wie geschorst is en wie net uit de academie komt.';

  @override
  String get tourCallUpsTitle => 'Een selectie bekendmaken';

  @override
  String get tourCallUpsBody =>
      'Je maakt per interlandperiode één selectie bekend en die speelt elke wedstrijd van die periode, precies zoals een echte bondscoach. Bij een blessure in de periode komt er automatisch een vervanger.';

  @override
  String get tourRecordsTitle => 'Jouw loopbaan';

  @override
  String get tourRecordsBody =>
      'Alles wat je hebt gedaan: de wedstrijden, de ploegrecords, de trofeeën en elk land dat je hebt getraind.';

  @override
  String get tourCupsTitle => 'De rest van de wereld';

  @override
  String get tourCupsBody =>
      'Elke competitie die nu loopt: groepen, standen en knock-outrondes, ook die waar je niet in zit. De wereld speelt door, of je je nu kwalificeerde of niet.';

  @override
  String get settingsTourTitle => 'Speel de uitleg opnieuw af';

  @override
  String get settingsTourBlurb =>
      'Loop opnieuw vanaf het begin langs de belangrijkste schermen.';

  @override
  String get tourBoardTitle => 'Wie je verantwoording schuldig bent';

  @override
  String get tourBoardBody =>
      'Het vertrouwen van het bestuur in jou en de doelen die ze voor deze cyclus hebben gesteld. Haal je het niet, dan zie je het hier aankomen.';

  @override
  String get tourStaffTitle => 'De mensen om je heen';

  @override
  String get tourStaffBody =>
      'Een assistent, een scout en een conditietrainer, op naam aangenomen. Hun salaris gaat van dit budget af voordat de afdelingen aan de beurt zijn, dus een geweldige scout is een keuze ten koste van de academie.';

  @override
  String get tourPlaystyleTitle => 'Jouw speelwijze';

  @override
  String get tourPlaystyleBody =>
      'De formatie is maar een halve tactiek. Dit is de andere helft: hoe hoog je pressie zet, hoe direct je speelt, hoeveel risico je neemt.';

  @override
  String get settingsTourNoSave =>
      'Begin eerst een loopbaan. De rondleiding komt langs je eigen schermen.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Uit positie · Leeftijd $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Het budget voor de volgende cyclus wordt aan het begin van die cyclus in één keer vastgesteld. Tot die tijd zie je hier wat je geld nu doet.';

  @override
  String get federationBudgetAlreadySet => 'Al vastgesteld voor deze cyclus';

  @override
  String yFinalLooms0(String opponent) {
    return 'Het wordt $opponent voor de grote wedstrijd. Deze hele week gaat het nergens anders over.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Bevestigd: $opponent staat tussen ons en de beker. Vier jaar voor dit moment.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Juist. $opponent. Niemand slaapt voordat dit voorbij is.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Eerst $opponent, de rest kan wachten. Wat een week om te leven.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Laat de nemers aan de trainer over';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Hieronder gemarkeerd: ploegen die spelen als $rivals, de teams die je deze cyclus in je groepen tegenkomt.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Transferperiode · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Laatst $when geleden';
  }

  @override
  String get settingsFreeScopeTitle => 'Eén gratis cyclus van vier jaar';

  @override
  String get settingsFreeScopeBlurb =>
      'Een complete cyclus (kwalificatie, je continentale kampioenschap en het Wereldkampioenschap) op twee opslagen, met elk land ter wereld, niets achtergehouden. Eindeloze cycli en onbeperkt opslaan zijn één betaling, eenmalig, en gelden voor elke toekomstige update.';

  @override
  String get settingsUnlockedTitle => 'Ontgrendeld';

  @override
  String get settingsUnlockedBlurb =>
      'Eindeloze cycli, onbeperkt opslaan en elke toekomstige update. Bedankt.';

  @override
  String get settingsFromDeveloperTitle => 'Van de ontwikkelaar';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager wordt door één persoon gemaakt en krijgt langdurige ondersteuning. Er komen nooit advertenties of microtransacties. Als je het spel leuk vindt, overweeg dan de volledige versie te kopen. Daardoor blijven de updates komen.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager wordt door één persoon gemaakt en krijgt langdurige ondersteuning. Er komen nooit advertenties of microtransacties. Bedankt voor het kopen van de volledige versie. Daardoor blijven de updates komen.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Hieronder gemarkeerd: ploegen die spelen als $rivals, die je nog moet treffen.';
  }

  @override
  String get friendliesCloseToYou =>
      'Hieronder gemarkeerd: de ploegen die het dichtst bij je staan op de wereldranglijst. Zodra je bent geloot, volgen de markeringen je groep.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transfers',
      one: '1 transfer',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Nieuwer';

  @override
  String get transfersOlder => 'Meer';

  @override
  String get transfersPagePrevious => 'Vorige';

  @override
  String get transfersPageNext => 'Volgende';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Pagina $page van $pages';
  }

  @override
  String get transfersMovedTo => 'Verhuisd naar';

  @override
  String get transfersUnknownClub => 'Onbekende club';

  @override
  String yAgainstThemAgain0(String opponent, int count) {
    return 'Dat is nu $count keer tegen $opponent. Iemand houdt de score bij, en zij zijn het.';
  }

  @override
  String yAgainstThemAgain1(String opponent, int count) {
    return 'Weer $opponent. $count ontmoetingen en we hebben ze nog steeds niet door.';
  }

  @override
  String yAgainstThemAgain2(String opponent, int count) {
    return 'Nummer $count tegen $opponent. Dit is al lang geen toeval meer.';
  }

  @override
  String yAgainstThemAgain3(String opponent, int count) {
    return 'We hebben $count keer tegen $opponent gespeeld en van geen enkele iets geleerd.';
  }

  @override
  String yAgainstThemAgain4(String opponent, int count) {
    return '$opponent, $count keer. Ze weten precies wat we gaan doen.';
  }

  @override
  String yAgainstThemAgain5(String opponent, int count) {
    return 'Wat $opponent ook op ons heeft, na $count ontmoetingen hebben ze het nog steeds.';
  }

  @override
  String ySameOldStory0(int count) {
    return 'Dat is $count keer dat dit de laatste tijd gebeurt. Wanneer is het gewoon wie we zijn?';
  }

  @override
  String ySameOldStory1(int count) {
    return '$count middagen als deze nu. Het is een patroon, geen reeks pech.';
  }

  @override
  String ySameOldStory2(int count) {
    return 'We hebben precies deze wedstrijd de laatste tijd $count keer gezien. Zelfde script, zelfde einde.';
  }

  @override
  String ySameOldStory3(int count) {
    return '$count versies van dezelfde negentig minuten nu. Niemand lost het op.';
  }

  @override
  String ySameOldStory4(int count) {
    return '$count keer. Als je het patroon nu nog niet ziet, kijk je niet.';
  }

  @override
  String ySameOldStory5(int count) {
    return 'Zelfde verhaal, $count keer. De smoesjes zijn op voordat de resultaten dat waren.';
  }

  @override
  String get yToldYouSo0 =>
      'Ik zei dat dit eraan kwam terwijl iedereen aan het vieren was.';

  @override
  String get yToldYouSo1 =>
      'Twee goede weken en we waren weer een gouden generatie. En kijk waar we nu staan.';

  @override
  String get yToldYouSo2 =>
      'De mensen die me vorige maand zeiden te genieten zijn stil geworden.';

  @override
  String get yToldYouSo3 =>
      'Ik beleef hier geen plezier aan. Heel weinig plezier. Een beetje.';

  @override
  String get yToldYouSo4 =>
      'Het was nooit zo goed als ze zeiden, en dit is het bewijs.';

  @override
  String get yToldYouSo5 =>
      'Elke keer weer. Ze zeggen dat het nu anders is, en elke keer is het dat niet.';

  @override
  String get tacticsSubOffAlready => 'Al gewisseld';

  @override
  String get tacticsSubInjured => 'Geblesseerd';

  @override
  String get tacticsSubSentOffMark => 'Uitgesloten';

  @override
  String get tacticsSubNoneLeft => 'Geen wissels meer';

  @override
  String get tacticsUndoLastChange => 'Laatste wijziging ongedaan maken';

  @override
  String get matchStrengthTitle => 'WAT DE PLOEG BEÏNVLOEDT';

  @override
  String get strengthFactorFamiliarity => 'Ingespeelde formatie';

  @override
  String get strengthFactorFatigue => 'Zware benen';

  @override
  String get strengthFactorClubForm => 'Clubvorm';

  @override
  String get strengthFactorMorale => 'Kleedkamer';

  @override
  String get strengthFactorCaptain => 'Aanvoerder';

  @override
  String get strengthFactorStaff => 'Stafkamer';

  @override
  String get strengthFactorDossier => 'Dossier van de scout';

  @override
  String yDebut0(String name) {
    return '$name maakt zijn interlanddebuut. Onthoud die naam.';
  }

  @override
  String yDebut1(String name) {
    return 'Een debuut voor $name. Je ziet het aan hem, toch?';
  }

  @override
  String yDebut2(String name) {
    return '$name, eerste interland. Even kijken wat hij ermee doet.';
  }

  @override
  String yDebut3(String name) {
    return 'Debuut voor $name. De selectie had ergens frisse benen nodig.';
  }

  @override
  String yDebut4(String name) {
    return '$name krijgt een interland cadeau. Daar hebben we er de laatste tijd veel van uitgedeeld.';
  }

  @override
  String yDebut5(String name) {
    return 'Een debuut voor $name. Weer eentje die we in het voorjaar vergeten zijn.';
  }

  @override
  String yDrought0(String name, int count) {
    return '$name wacht al $count wedstrijden op een doelpunt en doet al het andere op het veld wel goed.';
  }

  @override
  String yDrought1(String name, int count) {
    return '$count wedstrijden zonder doelpunt voor $name. Ze komen in drieën, altijd al.';
  }

  @override
  String yDrought2(String name, int count) {
    return '$name: $count wedstrijden, geen goals.';
  }

  @override
  String yDrought3(String name, int count) {
    return '$count wedstrijden zonder doelpunt voor $name. Het in de gaten houden waard.';
  }

  @override
  String yDrought4(String name, int count) {
    return '$count wedstrijden. Geen goals. $name kan geen scheunpoort raken.';
  }

  @override
  String yDrought5(String name, int count) {
    return '$name heeft in $count wedstrijden niet gescoord. Zet gewoon iemand anders neer.';
  }

  @override
  String yRivalryLooms0(String opponent, int count) {
    return 'Eerst $opponent. $count ontmoetingen en het betekent nog steeds alles.';
  }

  @override
  String yRivalryLooms1(String opponent, int count) {
    return 'Nu al $count keer tegen $opponent. Kom maar op.';
  }

  @override
  String yRivalryLooms2(String opponent, int count) {
    return 'Eerst $opponent. $count keer gespeeld.';
  }

  @override
  String yRivalryLooms3(String opponent, int count) {
    return 'Ontmoeting nummer $count met $opponent deze week.';
  }

  @override
  String yRivalryLooms4(String opponent, int count) {
    return 'Weer $opponent. $count van deze wedstrijden en we hebben niets geleerd.';
  }

  @override
  String yRivalryLooms5(String opponent, int count) {
    return '$count wedstrijden tegen $opponent en ze verslaan ons nog steeds. Prachtig.';
  }

  @override
  String get positionGoalkeeper => 'Keeper';

  @override
  String get positionLeftBack => 'Linksback';

  @override
  String get positionCentreBack => 'Centrale verdediger';

  @override
  String get positionRightBack => 'Rechtsback';

  @override
  String get positionDefensiveMid => 'Verdedigende middenvelder';

  @override
  String get positionCentralMid => 'Centrale middenvelder';

  @override
  String get positionAttackingMid => 'Aanvallende middenvelder';

  @override
  String get positionLeftMid => 'Linksmidden';

  @override
  String get positionRightMid => 'Rechtsmidden';

  @override
  String get positionLeftWing => 'Linksbuiten';

  @override
  String get positionRightWing => 'Rechtsbuiten';

  @override
  String get positionStriker => 'Spits';

  @override
  String get roleNone => 'Geen rol';

  @override
  String get roleTargetMan => 'Targetman';

  @override
  String get rolePoacher => 'Afmaker';

  @override
  String get rolePlaymaker => 'Spelmaker';

  @override
  String get roleBallWinner => 'Ballenafpakker';

  @override
  String get roleInvertedWinger => 'Binnendoorbuiten';

  @override
  String get roleBallPlayingDefender => 'Opbouwende verdediger';

  @override
  String get roleNoneBlurb => 'Speelt zijn natuurlijke spel.';

  @override
  String get roleTargetManBlurb =>
      'Wint kopballen, legt af. Assists en standaardsituaties.';

  @override
  String get rolePoacherBlurb =>
      'Loert in het strafschopgebied. Veel meer doelpunten.';

  @override
  String get rolePlaymakerBlurb => 'Creëert kansen. Veel meer assists.';

  @override
  String get roleBallWinnerBlurb =>
      'Breekt het spel van de tegenstander, maakt het niet af.';

  @override
  String get roleInvertedWingerBlurb =>
      'Snijdt naar binnen om te schieten. Meer doelpunten.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Begint de aanval achterin.';

  @override
  String get federationDeptYouth => 'Jeugdacademie';

  @override
  String get federationDeptCommercial => 'Commercie / PR';

  @override
  String get federationDeptMedical => 'Medisch en sportwetenschap';

  @override
  String get federationDeptNaturalisation => 'Naturalisatiebureau';

  @override
  String get federationDeptBoardRelations => 'Bestuurscontacten';

  @override
  String get federationDeptYouthBlurb =>
      'Betere academietalenten debuteren volgende cyclus voor je land.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsoring levert extra inkomsten op aan het einde van de cyclus.';

  @override
  String get federationDeptMedicalBlurb =>
      'Minder blessures. Je selectie blijft de hele cyclus beschikbaar.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Meer buitenlandse spelers bieden aan over te stappen naar je land.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Het bestuur beoordeelt je resultaten geduldiger.';

  @override
  String get federationBuildingAcademy => 'Academie';

  @override
  String get federationBuildingCommercial => 'Commercieel hoofdkantoor';

  @override
  String get federationBuildingMedical => 'Medisch centrum';

  @override
  String get federationBuildingScouting => 'Scoutingbureau';

  @override
  String get federationBuildingBoardroom => 'Bestuurskamer';

  @override
  String get moraleBuoyant => 'Opgetogen';

  @override
  String get moralePositive => 'Positief';

  @override
  String get moraleSettled => 'Stabiel';

  @override
  String get moraleUneasy => 'Onrustig';

  @override
  String get moraleRockBottom => 'Dieptepunt';

  @override
  String get matchTabTimeline => 'VERLOOP';

  @override
  String get matchTabStats => 'STATS';

  @override
  String get matchTabLineups => 'OPSTELLINGEN';

  @override
  String get matchPenalty => 'STRAFSCHOP';

  @override
  String get matchStateLevel => 'Het is gelijk';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Je staat $count doelpunten voor',
      one: 'Je staat een doelpunt voor',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Je staat $count doelpunten achter',
      one: 'Je staat een doelpunt achter',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% balbezit';
  }

  @override
  String get boardVerdictSackedTitle => 'Het bestuur heeft je ontslagen';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Een rampzalige cyclus (beoordeling $rating%). Je tijd als bondscoach eindigt hier. Alleen kleinere landen nemen nu nog een gok op je.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Het bestuur is dolblij';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Een uitmuntende cyclus (beoordeling $rating%) na $best. Grotere landen hebben interesse, of je blijft en bouwt verder.';
  }

  @override
  String get boardVerdictSolidTitle => 'Een solide cyclus';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Het bestuur is tevreden (beoordeling $rating%). Een paar landen van gelijke status willen je wel hebben, maar er is geen druk om te vertrekken.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Het bestuur verwachtte meer';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Een teleurstellende cyclus (beoordeling $rating%). Je houdt je baan, maar elk aanbod is een stap terug.';
  }

  @override
  String get boardVerdictPressureTitle => 'Je staat echt onder druk';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Een zwakke cyclus (beoordeling $rating%). Je overleeft het, maar alleen zwakkere landen zijn geïnteresseerd als je een nieuwe start wilt.';
  }

  @override
  String get boardVerdictHeroTitle => 'Het land staat achter je';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cycli',
      one: '1 cyclus',
    );
    return ' $nation aanbidt je, een nationale held na $_temp0; je baan is veilig zolang je dat wilt.';
  }

  @override
  String get boardVerdictTheNation => 'Het land';

  @override
  String get boardVerdictBestQuiet => 'een rustige cyclus';

  @override
  String get boardVerdictBestCycle => 'de cyclus';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'het Wereldkampioenschap: $placement';
  }

  @override
  String get finishThirdPlace => 'Derde plaats';

  @override
  String get finishFourthPlace => 'Vierde plaats';

  @override
  String get finishDidNotQualify => 'Niet gekwalificeerd';

  @override
  String get careerRepIconic => 'Iconisch';

  @override
  String get careerRepRenowned => 'Gevierd';

  @override
  String get careerRepEstablished => 'Gevestigd';

  @override
  String get careerRepRising => 'Opkomend';

  @override
  String get careerRepUnproven => 'Onbewezen';

  @override
  String get hubOfferStepUp => 'Stap omhoog';

  @override
  String get hubOfferLateral => 'Zijwaartse stap';

  @override
  String get hubOfferRebuild => 'Een heropbouw';

  @override
  String careerNationsCupWon(String league) {
    return 'Divisie $league · Kampioen';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Divisie $league · Verliezend finalist';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Divisie $league · Halve finalist';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Divisie $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Naar de $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Naar de wedstrijd om de derde plaats';

  @override
  String tourRunThrough(String round) {
    return 'Door vanuit de $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Uitgeschakeld in de $round';
  }

  @override
  String get tourRunInGroup => 'Nog in de groepsfase';

  @override
  String get tourRunGroupOut => 'Uitgeschakeld in de groepsfase';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Cyclus $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played gespeeld  ·  ${won}W ${drawn}G ${lost}V';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Wereldkampioenschap: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Nog in volle gang';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Rust: twee achter tegen $opponent, en ze hebben alles teruggepakt. Dat is een team.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Twee achter tegen $opponent en aan het eind deed het er niet meer toe. Niet veel ploegen doen dat.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Rust: twee goals achter tegen $opponent. Eindsignaal: niet meer. De tweede helft was een andere wedstrijd.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Van twee achter teruggekomen tegen $opponent. Wat er ook in de rust gezegd is, zeg het elke week.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Mooi, we hebben het teruggepakt tegen $opponent. Nu moet iemand die eerste vijfenveertig minuten nog uitleggen.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Twee achter tegen $opponent en wij moeten blij zijn. Fix die eerste helft.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Twee voor tegen $opponent bij de rust en het glipte weg. Het overkomt betere ploegen.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Twee goals voor tegen $opponent en het ging mis. Lange cyclus voor de boeg, tijd genoeg.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Rust: twee goals voor tegen $opponent. Eindsignaal: niets daarvan over.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Een voorsprong van twee goals tegen $opponent, weg binnen vijfenveertig minuten.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Twee voor en we gooien het weg. Tegen $opponent. Iemand moet hier antwoord op geven.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Twee goals voor tegen $opponent en dit krijgen we het voor elkaar. Elke keer weer.';
  }

  @override
  String get cycleBackupDone =>
      'Loopbaan opgeslagen in de FNM-map op deze telefoon. Als je de app verwijdert, verdwijnt die ook: gebruik Back-up van deze opslag op het opslagscherm om elders een kopie te bewaren.';

  @override
  String get cycleBackupFailed =>
      'De loopbaan kon dit keer niet worden geback-upt.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Een avond om nooit te vergeten tegen $opponent. Hoe trots bent u op deze groep?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent kon niet met u mee. Is dit het team waarvan u altijd geloofde dat u het had?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Een grote overwinning op $opponent. Wat maakte vanavond het verschil?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent verslagen, en ruim ook. Waar hebt u het gewonnen?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Een goede overwinning op $opponent. Eén goede avond: waarom zou iemand geloven dat dit blijft?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Een mooie uitslag tegen $opponent. Was dat uw plan, of hebben de spelers het zelf bedacht?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Een zware avond tegen $opponent. Wat zegt u tegen de spelers na zo\'n wedstrijd?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Niemand zag dit aankomen tegen $opponent. Was het gewoon zo\'n avond?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Dat was een vernederende avond tegen $opponent. Wat ging er mis?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent speelde jullie helemaal weg. Is deze selectie goed genoeg?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Jullie waren overal de tweede in tegen $opponent. Hoe kon het zo ver komen?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent scoorde naar believen. Waar was het plan vanavond?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Weer een wedstrijd weggegeven, nu tegen $opponent. Hoe keert u deze reeks?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'De resultaten zijn opgedroogd, en $opponent maakte het erger. Gelooft u nog in deze groep?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Weer geen overwinning, nu tegen $opponent, en het bestuur kijkt mee. Is uw baan veilig?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Na $opponent wordt de reeks lang. Maakt u zich zorgen om uw toekomst?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Nu ook $opponent. Uw voorganger werd ontslagen na zo\'n reeks. Waarom zou u het overleven?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Na weer zo\'n avond als tegen $opponent wil elk radioprogramma u weg. Zou u opstappen als het bestuur erom vroeg?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'U zette uw baan op het spel, en na $opponent liep het niet zoals u wilde. Hoe gaat het met u?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'De drie wedstrijden zijn gespeeld, de laatste tegen $opponent. U bepaalde de test zelf. Wat vindt u van het oordeel?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'U zei dat we u moesten beoordelen op de volgende drie. Na $opponent hebben we dat gedaan. Is uw baan nog van u?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Drie wedstrijden, de laatste tegen $opponent, en niet wat u beloofde. Hebt u met het bestuur over uw toekomst gesproken?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'U bepaalde de test zelf en zakte ervoor tegen $opponent. Gaat u opstappen?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Uw woorden, niet de onze: beoordeel me op de volgende drie. Waarom zit u er na $opponent nog?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'U wilt meer van ze. Iemand in het bijzonder?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'U hebt de lat hoog gelegd. Wie moet als eerste een stap zetten?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'U zegt dat sommigen in de spiegel moeten kijken. Wie bedoelt u?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Niet goed genoeg, zegt u. Over wie hebt u het?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'U houdt het vaag. Noemt u namen, of komt het op u terug?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Elke week is het de schuld van een ander. Van wie nu?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Stoute woorden. En als de volgende niet in uw voordeel valt?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Het land houdt u eraan. Wat als het niet lukt?';

  @override
  String get pressBeatIfYouDontNeutral1 => 'En als u hem niet wint? Wat dan?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'U hebt het nu gezegd. Wat gebeurt er als u ongelijk hebt?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'We hebben hier eerder beloftes gehoord. Wat bent u de supporters verschuldigd als ook deze breekt?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'En als het niet gebeurt, wat wordt dan de smoes?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Nog één, als u het in u hebt. Waar moet deze groep nog aan werken?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Als de rook is opgetrokken, wat neemt u van vanavond mee naar de volgende wedstrijd?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Laten we wat dieper gaan. Wat moet beter voor de volgende wedstrijd?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Voorbij de uitslag: staat deze selectie waar u haar wilt hebben?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Veel woorden, weinig gezegd. Wat verandert er nu echt?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'De supporters willen een eerlijk antwoord. Is dit team goed genoeg, ja of nee?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player was uitstekend vanavond. Hoe ver kan hij komen?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player staat vanavond in elke kop. Zag u dat aankomen?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player viel op. Wat vroeg u vanavond van hem?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Was $player vanavond het verschil?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Zonder $player is het een ander verhaal. Is dit een team, of één speler?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player was briljant. Uw verdienste, of de zijne?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return '$player had een zware avond. Draagt hij een knock met zich mee?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return '$player had zijn avond niet. Gaat u een arm om hem heen slaan?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player had het zwaar vanavond. Houdt hij zijn plek?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player zat niet op het tempo. Wat vond u van zijn wedstrijd?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player was weer een meeloper. Waarom blijft u hem opstellen?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Iedereen zag dat $player er niet bij was. Iedereen behalve de bank?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'U zei dat u de volgende zou winnen, en dat deed u. Voelt het goed om gelijk te hebben?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'U beloofde een overwinning in de volgende wedstrijd en maakte het waar. Zelfvertrouwen, of branie?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'U zei dat u de volgende zou winnen, en dat deed u. Geluk, of moeten we naar u gaan luisteren?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'U zei dat u die zou winnen. Het gebeurde niet. Wat ging er mis?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'U zei dat u de volgende zou winnen. Dat deed u niet. Waarom zouden we de volgende belofte geloven?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'U zei dat u de volgende zou winnen. Dat deed u niet. Betekenen uw woorden hier nog iets?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'U vroeg om beoordeeld te worden op drie wedstrijden, en u slaagde. Gerechtvaardigd?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Beoordeel me op de volgende drie, zei u. Dat deden we, en de resultaten kwamen. Wat leerde die test u?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'U gaf uzelf drie wedstrijden en kwam erdoor. Was de test ooit zo zwaar?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'U vroeg om beoordeeld te worden op drie wedstrijden. Ze liepen niet in uw voordeel. Wat hebt u geleerd?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'U zei: beoordeel me op de volgende drie. De drie zijn voorbij, en het voordeel van de twijfel ook. Wat nu?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'U bepaalde de test en zakte ervoor. Waarom zou nu nog iemand u op uw woord geloven?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'U steunde $player toen anderen dat niet deden. Hij leverde. Gaat een deel van de eer naar u?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'U steunde $player. Hij leverde. Vertrouwen, of kennis?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'U steunde $player, en voor één keer betaalde het zich uit. Bent u de volgende keer net zo zeker?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'U stond achter $player, en het is niet goed uitgepakt. Gelooft u nog in hem?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'U steunde $player. Hij heeft het niet terugbetaald. Was dat een fout?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Uw oordeel of uw loyaliteit: wat liet u in de steek bij $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'U was hard voor $player, en de wedstrijden sindsdien geven u gelijk. Geeft dat voldoening?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'U sprak $player publiekelijk aan, en hij heeft niet gereageerd. Is er een weg terug voor hem?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'U liet $player in de steek en hij is niet hersteld. Hebt u hem gebroken?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'U sprak $player publiekelijk aan, en hij antwoordde op het veld. Was dat al die tijd het idee?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'U gaf $player de schuld, en sindsdien is hij een van uw beste spelers. Bent u hem excuses verschuldigd?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'U liet $player vallen, en hij is sindsdien uw beste speler. Gaat u uw excuses aanbieden?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Deze spelers gaven me alles. Ik ruil geen enkele van hen in.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Niemand werkt harder dan deze groep. Ik verdedig ze de hele dag.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Vanaf deze stoel hoor je geen woord tegen mijn spelers.';

  @override
  String get pressReplyCreditPlayers4 =>
      'De spelers verdienen de eer, niet ik. Schrijf over hen.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Deze is voor mij. Ik koos de opstelling en ik zette ze neer.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Beoordeel mij, niet hen. Het is mijn team en mijn verantwoordelijkheid.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Als je iemand de schuld wilt geven, ik zit hier.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'De verantwoordelijkheid is van mij. Laat de spelers erbuiten.';

  @override
  String get pressReplyDemandMore1 =>
      'Ik wil meer. Sommigen van hen weten precies wat ik bedoel.';

  @override
  String get pressReplyDemandMore2 =>
      'Inzet is op dit niveau niet genoeg. Ik wil meer, en dat heb ik ze ook gezegd.';

  @override
  String get pressReplyDemandMore3 =>
      'Ik verwacht meer van elk van hen, vanaf morgen.';

  @override
  String get pressReplyDemandMore4 =>
      'Sommigen van hen moeten in de spiegel kijken. Ik ben niet tevreden.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'We winnen de volgende. Dat mag je opschrijven.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Onthoud mijn woorden: we winnen de volgende wedstrijd.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Volgende wedstrijd winnen we. Ik zeg het hier zodat je me erop kunt aanspreken.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Ik ben zeker van dit team. We winnen de volgende wedstrijd.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Beoordeel me op de volgende drie wedstrijden. Dat is eerlijk.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Geef me drie wedstrijden. Als het dan niet goed zit, beoordeel me erop.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'De volgende drie laten zien of ik de juiste man ben. Houd me eraan.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Drie wedstrijden. Schrijf daarna maar over me wat je wilt.';

  @override
  String get pressReplyDeflect1 =>
      'We nemen het wedstrijd voor wedstrijd. Meer heb ik niet toe te voegen.';

  @override
  String get pressReplyDeflect2 =>
      'Ik ga vandaag geen koppen voor jullie maken.';

  @override
  String get pressReplyDeflect3 =>
      'De volgende wedstrijd. Daar denk ik alleen aan.';

  @override
  String get pressReplyDeflect4 => 'Wat ik denk, blijft in de kleedkamer.';

  @override
  String get pressReplyTakeCredit1 =>
      'Ik zei het omdat ik het geloofde, en ik had gelijk.';

  @override
  String get pressReplyTakeCredit2 => 'Ik las het goed. Daar ben ik voor.';

  @override
  String get pressReplyTakeCredit3 =>
      'Noem het inschattingsvermogen. Ik wist wat ik zei.';

  @override
  String get pressReplyTakeCredit4 =>
      'Ik nam de beslissing en het pakte goed uit. Dat neem ik.';

  @override
  String get pressReplyStandByIt1 =>
      'Ik zei wat ik geloofde. Daar sta ik achter.';

  @override
  String get pressReplyStandByIt2 => 'Ik neem geen woord terug.';

  @override
  String get pressReplyStandByIt3 =>
      'Zelfde antwoord als toen. Ik meende het, en dat doe ik nog steeds.';

  @override
  String get pressReplyStandByIt4 => 'Ik zou het morgen weer zeggen.';

  @override
  String get pressReplyAdmitMistake1 =>
      'Dat had ik verkeerd. Ik neem het op me.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Terecht, ik heb het verkeerd ingeschat. Ik leer ervan.';

  @override
  String get pressReplyAdmitMistake3 => 'Ik zat ernaast, en dat kan ik zeggen.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Die keuze werkte niet, en het was de mijne.';

  @override
  String pressReplyBackPlayer1(String player) {
    return '$player heeft mijn volle steun. Hij komt goed.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Ik geloof in $player, en hij laat jullie zien waarom.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Van mij hoor je geen woord tegen $player. Hij gaat leveren.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return '$player blijft in mijn plannen. Kijk maar wat hij hierna doet.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return '$player liet ons vanavond in de steek, en dat weet hij.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Ik verwachtte veel meer van $player. Daar moet hij antwoord op geven.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return '$player zat niet op niveau. Dat zeg ik publiekelijk.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Dat was niet goed genoeg van $player, en dat hoort hij van mij.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Officieel: je wint de volgende wedstrijd.';

  @override
  String get pressOnRecordJob =>
      'Officieel: je laat je beoordelen op de volgende drie.';

  @override
  String pressOnRecordBack(String player) {
    return 'Officieel: je steunt $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Officieel: $player liet je in de steek.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Hij zei het, en het gebeurde. $nation heeft een bondscoach die meent wat hij zegt.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Hardop gezegd, en toen gedaan. Dat is de man die $nation nodig had.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: hij zei het, en het kwam uit. Eerlijk is eerlijk.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Hij zette het officieel op papier en het hield stand. Eentje voor hem. $nation gaat verder.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Hij had er één goed. $nation, wen er maar niet aan.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Zelfs een stilstaande klok heeft twee keer per dag gelijk. $nation had geluk dit keer.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Hij zei het en het lukte niet. Ik sta nog achter hem. $nation gaat door.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: hij beloofde meer dan we kregen, maar ik heb liever een coach die in zichzelf gelooft.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: hij zei het officieel en het gebeurde niet. Mensen onthouden dat.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Grote woorden, niets erachter. $nation: zeg de volgende keer minder.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Hij stond daar en vertelde het ons. En toen dit. $nation verdient beter dan praatjes.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Zijn woord is nu niets waard. Schrijf het op, $nation.';
  }

  @override
  String get ncZoneNorth => 'Zone Noord';

  @override
  String get ncZoneWest => 'Zone West';

  @override
  String get ncZoneEast => 'Zone Oost';

  @override
  String get ncZoneCentralSouthern => 'Zone Centraal en Zuid';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Kampioen';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Verliezend finalist';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Halve finalist';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Achtste finale';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Kwartfinalist';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Bereik de kwartfinales';

  @override
  String get objectiveNcZoneWinGroup => 'Win je groep';

  @override
  String get finishNcFinalsEight => 'Kwartfinales';

  @override
  String get finishNcBottomHalf => 'Onderste helft van de groep';

  @override
  String get tourContTabZones => 'ZONES';

  @override
  String get tourContTabFinalsEight => 'KNOCKOUTS';

  @override
  String get tourContFinalsEightSoon =>
      'De knock-outfase begint in november met de achtste finales: alle 14 groepswinnaars en de 2 beste nummers twee.';

  @override
  String get tourContQuarterFinals => 'KWARTFINALES';

  @override
  String get tourContZoneAdvancement =>
      'Elke groepswinnaar gaat door naar de achtste finales, samen met de 2 beste nummers twee. Niemand degradeert.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Nations Cup van Noord-Amerika';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Win de Nations Cup van Noord-Amerika';

  @override
  String get objectiveNcWinItAfrica => 'Win de Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Bereik de finale van de Nations Cup van Noord-Amerika';

  @override
  String get objectiveNcReachFinalAfrica =>
      'Bereik de finale van de Nations Cup';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Winnaar Nations Cup van Noord-Amerika';

  @override
  String get finishNcChampionsAfrica => 'Winnaar Nations Cup';

  @override
  String pressAimQualWarm1(String competition) {
    return 'De kwalificatie voor $competition begint, en het land gelooft in deze ploeg. Waar mikt u op?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Een nieuwe kwalificatiecampagne voor $competition, en de stemming is goed. Hoe ver kan dit team komen?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'De kwalificatie voor $competition begint. Wat is het doel voor deze campagne?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'De kwalificatiewedstrijden voor $competition zijn er. Waar eindigt deze ploeg volgens u?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'De kwalificatie voor $competition begint, en veel mensen betwijfelen of u het haalt. Wat zegt u tegen hen?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Alweer een kwalificatiecampagne voor $competition. Waarom zou iemand geloven dat deze anders wordt?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return '$competition is er en het hele land staat achter u. Hoe ver kunt u komen?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'U bent op $competition en de supporters dromen. Wat is het doel?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return '$competition begint deze week. Wat zou een succes zijn?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Uw eerste wedstrijd op $competition komt eraan. Geef ons een doel.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return '$competition is er en niemand verwacht veel. Waar hoopt u echt op?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'U bent op $competition, maar de twijfels zijn niet weg. Wat is uw doel?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return '$rival zit in uw groep. Maakt dat u ongerust?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'De loting zette $rival op uw pad. Hoe ziet u die wedstrijd?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return '$rival lijkt de sterkste ploeg in uw groep. Zijn ze de favoriet?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Wat vindt u van $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return '$rival zit in uw groep. Eerlijk, kunt u met ze meekomen?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'De meeste mensen verwachten dat $rival u verslaat. Hebben ze ongelijk?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player is in uitstekende vorm. Is dit zijn moment?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player staat in elke kop. Kan hij deze ploeg dragen?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Hoeveel hangt deze campagne af van $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Is $player klaar om dit team te leiden?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Als $player niet op zijn best is, heeft deze ploeg dan nog iets?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return '$player draagt veel op zijn schouders. Te veel?';
  }

  @override
  String get pressReplyAimHigher1 => 'We gaan verder dan wie dan ook verwacht.';

  @override
  String get pressReplyAimHigher2 =>
      'Ik wil meer dan de bond vroeg, en dat zeg ik hardop.';

  @override
  String get pressReplyMatchBrief1 =>
      'We kennen het doel en we gaan het halen.';

  @override
  String get pressReplyMatchBrief2 =>
      'De bond stelde een doel. Wij leveren het.';

  @override
  String get pressReplyPlayDown1 =>
      'Laten we het wedstrijd voor wedstrijd nemen.';

  @override
  String get pressReplyPlayDown2 =>
      'Geen grote beloftes. We zien wel waar we uitkomen.';

  @override
  String get pressReplyPromiseQualify1 =>
      'We kwalificeren ons. Dat mag je opschrijven.';

  @override
  String get pressReplyPromiseQualify2 => 'Deze ploeg staat op de eindronde.';

  @override
  String get pressReplyFearNobody1 => 'Wij zijn voor niemand bang.';

  @override
  String get pressReplyFearNobody2 => 'Ze moeten ook tegen ons spelen.';

  @override
  String get pressReplyRespectRival1 =>
      'Zij zijn de favoriet, en wij hebben respect voor ze.';

  @override
  String get pressReplyRespectRival2 =>
      'Een heel goede ploeg. We hebben ons beste spel nodig.';

  @override
  String get pressReplyTeamFirst1 =>
      'Het gaat om het hele team, niet om één speler.';

  @override
  String get pressReplyTeamFirst2 => 'Niemand wint dit alleen.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Officieel: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Officieel: geen beloftes.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'U stelde voor de campagne een doel en u haalde het. Is dat uw mooiste moment tot nu toe?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'U zei wat u zou bereiken, en dat deed u. Was het ooit in twijfel?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'U haalde het doel dat u stelde. Geluk, of was het echt het plan?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'U stelde een doel en bleef erbij achter. Wat ging er mis?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'U beloofde meer dan deze ploeg leverde. Hebt u spijt dat u het zei?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'U deed voor de campagne grote uitspraken en bleef achter. Waarom zouden we u nu geloven?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'De pers wil je ambities horen voor $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Niveau $level · $amount';
  }

  @override
  String get formOnFire => 'In vuur en vlam';

  @override
  String get formGood => 'In vorm';

  @override
  String get formSteady => 'Stabiel';

  @override
  String get formPoor => 'Uit vorm';

  @override
  String get formCold => 'Ijskoud';

  @override
  String get playerFormTitle => 'VORM EN FITHEID';

  @override
  String playerFormAverage(String rating) {
    return 'Gemiddeld $rating in zijn laatste wedstrijden';
  }

  @override
  String get playerFormNoGames =>
      'Te weinig recente wedstrijden om te oordelen';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta op zijn cijfer in de volgende wedstrijd';
  }

  @override
  String get playerFormNoEffect =>
      'Geen verandering in zijn cijfer in de volgende wedstrijd';

  @override
  String get sideGroupHome => 'Thuis';

  @override
  String get sideGroupTeam => 'Team';

  @override
  String get sideGroupCompetitions => 'Competities';

  @override
  String get sideGroupFederation => 'Bond';

  @override
  String get sideGroupHistory => 'Geschiedenis';

  @override
  String get sideInbox => 'Inbox';

  @override
  String get sideSquad => 'Selectie';

  @override
  String get sideTactics => 'Tactiek';

  @override
  String get sideMainMenu => 'Hoofdmenu';

  @override
  String get sideCallUps => 'Oproepen';

  @override
  String get sideTournaments => 'Toernooien';

  @override
  String get sideRanking => 'Ranglijst';

  @override
  String get sideResults => 'Uitslagen';

  @override
  String get sideFinances => 'Financiën';

  @override
  String get sideBoard => 'Bestuur';

  @override
  String get sideManager => 'Coach en staf';

  @override
  String get sideRecords => 'Records';

  @override
  String get sideLegends => 'Legendes';

  @override
  String get sideHeadToHead => 'Onderling';

  @override
  String get sideAchievements => 'Prestaties';

  @override
  String get sideCareer => 'Loopbaan';

  @override
  String get topBarNext => 'Volgende';

  @override
  String get topBarDrawPending => 'Loting volgt';

  @override
  String get paneFullProfile => 'Volledig profiel';

  @override
  String get panePickPlayer => 'Kies een speler om zijn kaart hier te zien';

  @override
  String get inboxPickMessage => 'Kies een bericht om het hier te lezen';

  @override
  String get inboxFilterAll => 'Alles';

  @override
  String get panelViewAll => 'Alles bekijken';

  @override
  String get gridViewOverview => 'Overzicht';

  @override
  String get gridColCondition => 'Conditie';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Plek';

  @override
  String get gridColMove => 'Verschil';

  @override
  String get gridColNation => 'Land';

  @override
  String get gridColRegion => 'Regio';

  @override
  String get gridColPoints => 'Punten';

  @override
  String get panePickNation =>
      'Kies een land om zijn staat van dienst hier te zien';

  @override
  String get resultsCyclesTitle => 'Cycli';

  @override
  String get tourDrawStart => 'Start de loting';

  @override
  String get tourDrawViewGroups => 'Bekijk groepen';

  @override
  String get gridColCeiling => 'Plafond';

  @override
  String get gridColYearGain => 'Groei';

  @override
  String get gridColMarkedAt => 'Bij markering';

  @override
  String get budgetSetupTitle => 'Stel je budget in';

  @override
  String get budgetEffectsTitle => 'Wat dit budget oplevert';

  @override
  String get naturalisationTitle => 'Naturalisatie';

  @override
  String get yTrending => 'Trending';

  @override
  String get yVoices => 'Stemmen';

  @override
  String get yConversation => 'Gesprek';

  @override
  String get allTimeRecordsTitle => 'Wereldrecords aller tijden';

  @override
  String get h2hMeetingsTitle => 'Elke ontmoeting';

  @override
  String get h2hPickOpponent =>
      'Kies een tegenstander om hier elke ontmoeting te zien';

  @override
  String get savesTitle => 'Opgeslagen spellen';

  @override
  String get gridColPlayer => 'Speler';

  @override
  String get gridColPos => 'Pos';

  @override
  String get gridColActive => 'Actief';

  @override
  String get gridColMotm => 'MvdW';

  @override
  String get gridColAvg => 'Gem.';

  @override
  String get gridColOpponent => 'Tegenstander';

  @override
  String get gridColStarts => 'Basis';

  @override
  String get gridColTournaments => 'Toernooien';

  @override
  String get gridColDate => 'Datum';

  @override
  String get gridColLastPlayed => 'Laatst gespeeld';

  @override
  String get gridColManager => 'Bondscoach';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count landen',
      one: '1 land',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Gesorteerd op wereldranglijst';

  @override
  String get nationsStrength => 'Sterkte';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier van 5';
  }

  @override
  String get nationsSquadOverall => 'Totaalcijfer selectie';

  @override
  String get nationsOpeningBudget => 'Startbudget';

  @override
  String get nationsStarPlayer => 'Sterspeler';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Ster $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Leeftijd $age';
  }

  @override
  String get nationsBoardExpects => 'Het bestuur verwacht';

  @override
  String nationsManage(String nation) {
    return 'Neem $nation over';
  }

  @override
  String get nationsManagerNext => 'Je kiest hierna je bondscoach';

  @override
  String get playerPageTitle => 'Speler';

  @override
  String get nationPageTitle => 'Land';

  @override
  String get friendliesYourGames => 'Jouw oefenwedstrijden';

  @override
  String hubEventInjuryCover(String player) {
    return 'Vervang de geblesseerde $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Valt $matches wedstrijden uit',
      one: 'Valt de volgende wedstrijd uit',
    );
    return '$_temp0. Roep iemand op, of speel door zonder hem.';
  }

  @override
  String get injuryCoverTitle => 'VERVANGER';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) is geblesseerd. Roep iedereen van buiten de selectie op, op elke positie, of houd hem en speel door.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Roep $player op';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Houd $player en speel door';
  }

  @override
  String get injuryCoverPick => 'Kies een vervanger';

  @override
  String get injuryCoverNone =>
      'Niemand buiten de selectie is fit genoeg om erbij te komen.';

  @override
  String get nationNowRanking => 'Wereldranglijst';

  @override
  String get nationNowForm => 'Vorm';

  @override
  String get nationNowNoForm => 'Nog geen wedstrijden gespeeld';

  @override
  String get nationNowNext => 'Volgende wedstrijd';

  @override
  String get nationNowNoNext => 'Niets gepland';

  @override
  String get nationNowSquad => 'Selectie';

  @override
  String get nationNowAgainstYou => 'Tegen jou';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}W ${d}G ${l}V';
  }

  @override
  String get nationNowLastMeeting => 'Laatste ontmoeting';

  @override
  String nationNowOverall(int value) {
    return 'Totaalcijfer $value';
  }

  @override
  String get hubUpcoming => 'AANKOMEND';

  @override
  String get hubFullSchedule => 'Volledig programma';

  @override
  String get scheduleTitle => 'Programma';

  @override
  String get scheduleToday => 'Vandaag';

  @override
  String get scheduleKnockoutPending => 'Knock-outfase, als je doorgaat';

  @override
  String get scheduleNextRoundPending => 'Volgende ronde';

  @override
  String scheduleFromDate(String date) {
    return 'Vanaf $date';
  }

  @override
  String get scheduleHomeShort => 'T';

  @override
  String get scheduleAwayShort => 'U';

  @override
  String get tacticsNoPresetsInMatch =>
      'Nog geen opgeslagen tactieken. Sla er een op via het tactiekscherm voor de wedstrijd.';

  @override
  String get homeCampaigns => 'Campagnes';

  @override
  String get homeContinueCampaign => 'CAMPAGNE VOORTZETTEN';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Cyclus $cycle van $total';
  }

  @override
  String get campaignsTitle => 'Campagnes';

  @override
  String get campaignTransplantTitle => 'De Transplant';

  @override
  String get campaignTransplantTwist =>
      'Acht van Italiës beste spelers wisselen van nationaliteit naar San Marino';

  @override
  String get campaignTransplantGoal =>
      'Kwalificeer je voor het Europees Kampioenschap';

  @override
  String get campaignGrudgeTitle => 'Wrok';

  @override
  String get campaignGrudgeTwist => 'Georgië en Albanië, samen geloot';

  @override
  String get campaignGrudgeGoal => 'Eindig in de kwalificatie boven Albanië';

  @override
  String get campaignTransplantIntro =>
      'San Marino heeft nooit een kwalificatiecampagne gehad die die naam waard was. Dan nemen acht van Italiës beste spelers het paspoort aan en lopen binnen. Je hebt één cyclus om van een curiositeit een team te maken.';

  @override
  String get campaignGrudgeIntro =>
      'Georgië en Albanië zijn in dezelfde kwalificatiegroep geloot, en geen van beide vergeeft een nederlaag. Eindig boven Albanië en kijk dan hoe ver je het kunt brengen.';

  @override
  String get campaignStars1Transplant => 'Kwalificeer je';

  @override
  String get campaignStars2Transplant => 'Bereik de knock-outfase';

  @override
  String get campaignStars3Transplant => 'Win het Europees Kampioenschap';

  @override
  String get campaignStars1Grudge => 'Boven Albanië';

  @override
  String get campaignStars2Grudge => 'En kwalificeer je';

  @override
  String get campaignStars3Grudge => 'En versla ze twee keer';

  @override
  String get campaignFree => 'Gratis';

  @override
  String get campaignStart => 'Start';

  @override
  String get campaignPartOfUnlimited => 'Onderdeel van Unlimited';

  @override
  String get campaignResume => 'Hervat';

  @override
  String get campaignAbandon => 'Opgeven';

  @override
  String get campaignAbandonConfirm =>
      'Deze poging opgeven? De voortgang gaat verloren; je stempel blijft.';

  @override
  String get campaignMoveToSaves => 'Naar opslagen';

  @override
  String get campaignCannotContinue =>
      'De wereld van deze campagne staat te ver van de echte af om als loopbaan door te spelen.';

  @override
  String get campaignMoveSlotsFull =>
      'Je opslagplekken zijn vol. Maak er eerst een vrij.';

  @override
  String get campaignStampConquered => 'Veroverd';

  @override
  String get campaignStampFailed => 'Mislukt';

  @override
  String get campaignDifficultyHard => 'Zwaar';

  @override
  String get campaignDifficultyMedium => 'Gemiddeld';

  @override
  String get campaignGoalLabel => 'Doel';

  @override
  String get campaignStarsLabel => 'Sterren';

  @override
  String get campaignRunInProgress => 'Voor deze campagne loopt al een poging.';

  @override
  String get campaignVerdictWon => 'Veroverd';

  @override
  String get campaignVerdictLost => 'Niet deze keer';

  @override
  String get campaignVerdictContinue => 'Doorgaan';

  @override
  String campaignProgressQualifying(String position) {
    return 'Kwalificatie: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Eindronde: $stage';
  }

  @override
  String get campaignRunInNumbers => 'De poging in cijfers';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Duels gewonnen: $won van $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': '1e',
        'second': '2e',
        'third': '3e',
        'other': '${n}e',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Het beste Guinee';

  @override
  String get campaignGuineasTwist =>
      'Equatoriaal-Guinea, het kleinste Guinee van Afrika, voor twee cycli';

  @override
  String get campaignGuineasGoal => 'Versla Guinee en Guinee-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Drie Afrikaanse landen dragen de naam Guinee, en Equatoriaal-Guinea is daarvan het kleinste. Je hebt twee cycli om Guinee en Guinee-Bissau elk minstens één keer te verslaan, en daarna te zien hoe ver je komt op het Afrikaans Kampioenschap. Papoea-Nieuw-Guinea, het vierde Guinee, staat al gepland voor een oefenwedstrijd.';

  @override
  String get campaignStars1Guineas => 'Versla Guinee en Guinee-Bissau';

  @override
  String get campaignStars2Guineas =>
      'En plaats je voor een Afrikaans Kampioenschap';

  @override
  String get campaignStars3Guineas =>
      'En haal de kwartfinale van een Afrikaans Kampioenschap';

  @override
  String get campaignYoungFinnsTitle => 'Jonge Finnen';

  @override
  String get campaignYoungFinnsTwist =>
      'De gouden generatie tieners van Finland, voor drie cycli';

  @override
  String get campaignYoungFinnsGoal => 'Plaats je voor een Wereldkampioenschap';

  @override
  String get campaignYoungFinnsIntro =>
      'De ervaren spelers van Finland hebben plaatsgemaakt voor een gouden generatie: elke speler die je kunt oproepen is 18 jaar of jonger. Vandaag zijn ze nog ruw, maar ze hebben het talent om uit te groeien tot een van de beste ploegen ter wereld, zoals de jonge generatie van Noorwegen deed. Je hebt drie cycli om ze naar een Wereldkampioenschap te leiden en daarna het Europees Kampioenschap en het Wereldkampioenschap te winnen.';

  @override
  String get campaignStars1YoungFinns =>
      'Plaats je voor een Wereldkampioenschap';

  @override
  String get campaignStars2YoungFinns => 'Win het Europees Kampioenschap';

  @override
  String get campaignStars3YoungFinns => 'Win het Wereldkampioenschap';

  @override
  String get campaignGreenlandTitle => 'Een Groenlandse eeuw';

  @override
  String get campaignGreenlandTwist =>
      'Groenland neemt de plaats van San Marino in Europa in, voor honderd jaar';

  @override
  String get campaignGreenlandGoal =>
      'Plaats je voor een Europees Kampioenschap';

  @override
  String get campaignGreenlandIntro =>
      'Groenland heeft nog nooit een officiële interland gespeeld. In deze wereld heeft het de plaats van San Marino in Europa ingenomen en begint het helemaal onderaan de wereldranglijst: amateurspelers, kunstgrasvelden en een seizoen dat tussen de sneeuwbuien in geperst zit. Je hebt honderd jaar, vijfentwintig cycli, om een Europees Kampioenschap te halen, daarna een Wereldkampioenschap en, als je durft te dromen, er een te winnen.';

  @override
  String get campaignStars1Greenland =>
      'Plaats je voor een Europees Kampioenschap';

  @override
  String get campaignStars2Greenland =>
      'Plaats je voor een Wereldkampioenschap';

  @override
  String get campaignStars3Greenland =>
      'Win het Europees Kampioenschap of het Wereldkampioenschap';

  @override
  String get campaignZanzibarTitle => 'Zanzibar in opmars';

  @override
  String get campaignZanzibarTwist =>
      'Zanzibar neemt de plaats van Tsjaad in Afrika in, voor honderd jaar';

  @override
  String get campaignZanzibarGoal =>
      'Plaats je voor een Afrikaans Kampioenschap';

  @override
  String get campaignZanzibarIntro =>
      'Zanzibar heeft een eigen voetbalbond en een eigen nationaal elftal, maar geen plek in het Afrikaanse of het wereldvoetbal. In deze wereld heeft het de plaats van Tsjaad in Afrika ingenomen en begint het vlak bij de onderkant van de wereldranglijst: eilandspelers, kleine stadions en de hitte van de moesson. Je hebt honderd jaar, vijfentwintig cycli, om een Afrikaans Kampioenschap te halen, daarna een Wereldkampioenschap en, als je durft te dromen, het Wereldkampioenschap te winnen.';

  @override
  String get campaignStars1Zanzibar =>
      'Plaats je voor een Afrikaans Kampioenschap';

  @override
  String get campaignStars2Zanzibar => 'Plaats je voor een Wereldkampioenschap';

  @override
  String get campaignStars3Zanzibar => 'Win het Wereldkampioenschap';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Niet geplaatst';

  @override
  String get campaignCupOpen => 'Nog open';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name schittert bij de $level';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Academierapport: $name valt op';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return 'Uitblinker bij de $level: $name';
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
      other: '$count keer',
      one: 'één keer',
    );
    return '$name scoorde $_temp0 voor de $level tegen $opponent in de laatste interlandperiode.';
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
      other: '$count doelpunten',
      one: 'Een doelpunt',
    );
    return '$_temp0 van $name toen de $level deze interlandperiode $opponent trof.';
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
      other: '$count doelpunten',
      one: 'een doelpunt',
    );
    return 'De $level speelde tegen $opponent, en $name hield er $_temp0 aan over.';
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
      other: '$count assists',
      one: 'een assist',
    );
    return '$name gaf voor de $level tegen $opponent $_temp0 en had het spel van begin tot eind in handen.';
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
      one: 'een assist',
    );
    return 'De $level speelde deze interlandperiode tegen $opponent, en $name trok aan de touwtjes: $_temp0 en een optreden waar de staf nog steeds over praat.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name was uitstekend toen de $level tegen $opponent de nul hield.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'De nul gehouden door de $level tegen $opponent, en dat kwam vooral door $name.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name maakte indruk bij de $level tegen $opponent, en de staf gaf zijn optreden een $mark uit tien.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return 'De $level speelde deze interlandperiode tegen $opponent, en de trainers lichtten $name eruit: een $mark uit tien, het hoogste cijfer van het team.';
  }

  @override
  String get newsYouthDevReady1 =>
      'In deze vorm is hij al goed genoeg om in aanmerking te komen voor het A-elftal.';

  @override
  String get newsYouthDevReady2 =>
      'De staf vindt hem nu al klaar voor seniorenvoetbal. De keuze is aan jou.';

  @override
  String get newsYouthDevClose1 =>
      'Hij ontwikkelt zich goed en staat dicht bij een doorbraak naar het A-elftal.';

  @override
  String get newsYouthDevClose2 =>
      'Het A-elftal is niet ver meer weg, en nog één goed seizoen kan genoeg zijn.';

  @override
  String get newsYouthDevGrowing1 =>
      'Hij ontwikkelt zich mooi, al is het A-elftal nog een stap of twee verwijderd.';

  @override
  String get newsYouthDevGrowing2 =>
      'Er is nog werk te doen voordat hij A-international is, maar alles wijst de goede kant op.';

  @override
  String get newsYouthDevRaw1 =>
      'Hij is nog ruw en een paar jaar verwijderd van het A-elftal, maar het talent is duidelijk zichtbaar.';

  @override
  String get newsYouthDevRaw2 =>
      'Het is nog vroeg, en de academie vraagt om geduld in plaats van krantenkoppen.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Zijn reikwijdte en zijn overwicht in de zestien maken het verschil.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Zijn vangzekerheid en opbouw zijn de beste die de academie in jaren heeft gezien.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Zijn concentratie zakt nooit weg: in de negentigste minuut is hij net zo scherp als in de eerste.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Zijn snelheid en kopkracht zijn de sleutel tot zijn spel.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Hij leest het spel ver boven zijn leeftijd en blijft rustig aan de bal.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Hij verslapt nooit en sprint in de laatste minuut nog steeds terug.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Hij verovert ballen met echte kracht en dendert er meteen mee naar voren.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Zijn overzicht en passingrange zijn de sleutel tot zijn spel.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Zijn motor is opmerkelijk: hij komt op elke grasspriet.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Zijn snelheid in de diepte en kracht in de lucht maken hem lastig voor elke verdediging.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Zijn afwerking en loopacties in de zestien zijn de sleutel tot zijn spel.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Hij zet de hele wedstrijd voorin druk en gunt verdedigers geen moment rust.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'De fans zullen nog lang zingen over deze wedstrijd tegen $opponent. Wat zei u tegen de spelers bij het laatste fluitsignaal?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Dat was een statement tegen $opponent. Hoeveel daarvan kwam van het trainingsveld?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Complimenten voor het resultaat tegen $opponent, maar zulke avonden hebben we vaker gezien. Wat is er deze keer anders?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Iedereen heeft weleens een slechte avond, en dit was er een tegen $opponent. Hoe snel kunt u dit achter u laten?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent was in alle linies beter. Waar begint u met repareren?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'De supporters vertrokken al voor het einde tegen $opponent. Kunt u het ze kwalijk nemen?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Het is een zware reeks, en $opponent maakte het er niet makkelijker op. Wat houdt u op de been?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Weer een wedstrijd zonder zege, dit keer tegen $opponent. Hoe lang kan dit nog duren voordat het bestuur ingrijpt?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Nu ook $opponent. Zit er nog iets in uw plan, of is het tijd om plaats te maken voor iemand anders?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Wat u ook schrijft, schrijf het over de spelers. Dat hebben ze verdiend.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Ik heb een groep die voor elkaar door het vuur gaat. Dat is niet niks.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Ik neem de beslissingen, dus de kritiek is voor mij. Zo werkt dit vak.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Kijk eerst naar de bondscoach. Ik heb dingen verkeerd gedaan en ik ga ze rechtzetten.';

  @override
  String get pressReplyDemandMore5 =>
      'Goed is hier niet goed genoeg. Dat heb ik ze recht in het gezicht gezegd.';

  @override
  String get pressReplyDemandMore6 =>
      'Niemand in die kleedkamer is zeker van een basisplaats. Dat weten ze nu.';

  @override
  String get pressReplyDeflect5 =>
      'U kunt het op drie manieren vragen. U krijgt hetzelfde antwoord.';

  @override
  String get pressReplyDeflect6 =>
      'Mijn gedachten houd ik voor de spelers. Dat begrijpt u vast.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$score tegen $opponent. Rustig, gecontroleerd, volwassen voetbal. Heerlijk om te zien.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$opponent met $score verslagen zonder te zweten. Dit team wordt goed in saai, en saai wint prijzen.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Drie punten, geen drama, weer aan het werk.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Een routineuze $score tegen $opponent. Niemand zal het onthouden en dat hoeft ook niet.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$score tegen $opponent en toch maak ik me ergens zorgen.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$opponent met $score verslagen. Tegen een echte ploeg wordt zo\'n optreden afgestraft.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$score tegen $opponent. Tanden op elkaar, geleden, gewonnen. Dat is een team.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$opponent met $score verslagen op pure wilskracht. Ik kies voor een ploeg die weigert te verliezen.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Het bleef spannend tot het einde, maar de punten zijn binnen.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Een krappe $score tegen $opponent. Weinig verschil, en zo is voetbal.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$score tegen $opponent. Eén gelukkige stuit de andere kant op en we voeren een heel ander gesprek.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Ternauwernood overeind gebleven tegen $opponent, $score. Niemand moet dat een prestatie noemen.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$score tegen $opponent. Geen nederlaag, en soms is dat precies het werk.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Een zwaarbevochten punt tegen $opponent, $score. Ik vond de strijd mooi.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Een terechte puntendeling, zoals de oude commentatoren zeiden.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$score tegen $opponent. Geen van beide ploegen deed genoeg om meer te verdienen.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$score tegen $opponent. Zo\'n gelijkspel dat in de bus naar huis als een nederlaag voelt.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Gelijk gespeeld tegen $opponent, $score. We blijven praten over vooruitgang en blijven dit doen.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$score tegen $opponent. Het doet pijn, maar ik heb genoeg gezien om in dit team te geloven.';
  }

  @override
  String yLost13(String opponent, String score) {
    return 'Met $score verloren van $opponent, en ze waren goed. Erkennen en door.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Een nederlaag, een paar lessen, en snel de volgende wedstrijd.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Met $score verloren van $opponent. Weinig tegen in te brengen.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$score tegen $opponent. Dezelfde fouten als de vorige keer, met hetzelfde zelfvertrouwen gemaakt.';
  }

  @override
  String yLost17(String opponent, String score) {
    return 'Met $score verloren van $opponent. Als niemand hierop wordt aangesproken, wat doen we dan eigenlijk?';
  }

  @override
  String get yReactionShrug12 =>
      'Prima toch. Niet elke avond hoeft vuurwerk te zijn.';

  @override
  String get yReactionShrug13 => 'Punten zijn punten. Ik slaap goed vannacht.';

  @override
  String get yReactionShrug14 => 'Gezien. Geen opmerkingen.';

  @override
  String get yReactionShrug15 => 'Ergens tussen prima en prima.';

  @override
  String get yReactionShrug16 =>
      'Hiervoor heb ik de stream betaald. Nooit meer (ik kom terug).';

  @override
  String get yReactionShrug17 =>
      'Negentig minuten niks in de vorm van voetbal.';

  @override
  String get yReactionRelief12 => 'Ik adem weer. Trots dat ze het volhielden.';

  @override
  String get yReactionRelief13 =>
      'Dit zijn de zeges die een team bouwen. Lelijk is mooi.';

  @override
  String get yReactionRelief14 => 'Mijn nagels zijn weg, de punten niet.';

  @override
  String get yReactionRelief15 =>
      'Een laatste fluitsignaal klonk nog nooit zo mooi.';

  @override
  String get yReactionRelief16 => 'Blij dat we wonnen, bezorgd over hoe.';

  @override
  String get yReactionRelief17 => 'We komen er steeds mee weg. Ooit niet meer.';

  @override
  String get yReactionFury12 =>
      'Ik hou van deze ploeg, en juist daarom doet dit pijn.';

  @override
  String get yReactionFury13 =>
      'Slechte avond. Volgende keer zijn ze ons iets verschuldigd, en dat weten ze.';

  @override
  String get yReactionFury14 =>
      'Na zeventig minuten uitgezet. Had zestig moeten zijn.';

  @override
  String get yReactionFury15 => 'Geen strijd, geen ideeën, geen excuses.';

  @override
  String get yReactionFury16 =>
      'Elke keer dezelfde problemen, en niemand lost iets op.';

  @override
  String get yReactionFury17 =>
      'Iemand bij de bond moet dit terugkijken en het uitleggen.';

  @override
  String get backupShareHint =>
      'Maakt één back-upbestand van alle spelbestanden. Kies Google Drive, iCloud Drive of Bestanden om het te bewaren.';

  @override
  String backupLastAt(String date) {
    return 'Laatste back-up: $date';
  }

  @override
  String get backupNever => 'Nog geen back-up';

  @override
  String get backupRemindersTitle => 'Back-upherinneringen';

  @override
  String get backupRemindersBlurb =>
      'Een bericht in je inbox als je laatste back-up oud begint te worden.';

  @override
  String get backupAutoICloudTitle => 'Automatische iCloud-back-up';

  @override
  String get backupAutoDriveTitle => 'Automatische Google Drive-back-up';

  @override
  String get backupAutoBlurb =>
      'Maakt een back-up na wedstrijden, aan het eind van een cyclus en als je de app verlaat. Houdt de laatste twee.';

  @override
  String get backupStatusUploading => 'Back-up bezig.';

  @override
  String get backupStatusUploaded => 'Back-up gemaakt.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud staat uit. Log in bij iCloud en zet iCloud Drive aan in de app Instellingen.';

  @override
  String get backupStatusDriveSignedOut =>
      'Niet ingelogd. Zet de schakelaar aan om in te loggen met Google.';

  @override
  String get backupStatusNotConfigured =>
      'Nog niet beschikbaar in deze versie van de app.';

  @override
  String get backupStatusUnavailable =>
      'De cloud is nu niet bereikbaar. Later wordt het opnieuw geprobeerd.';

  @override
  String get backupStatusFailed =>
      'De laatste automatische back-up is niet gelukt. Later wordt het opnieuw geprobeerd.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Ingelogd als $email';
  }

  @override
  String get backupDriveSignOut => 'UITLOGGEN';

  @override
  String get backupDriveSignInFailed =>
      'Inloggen met Google is niet gelukt. Probeer het later nog eens.';

  @override
  String get backupRestoreICloud => 'HERSTELLEN UIT ICLOUD';

  @override
  String get backupRestoreDrive => 'HERSTELLEN UIT GOOGLE DRIVE';

  @override
  String get backupCrossPlatformHelp =>
      'Overstappen tussen iPhone en Android? Maak op de ene telefoon een back-up naar een bestand en herstel uit dat bestand op de andere.';

  @override
  String get backupCloudListBlurb =>
      'Back-ups van je apparaten op dit account. Tik op een back-up om die te herstellen.';

  @override
  String get backupCloudListEmpty =>
      'Nog geen back-ups gevonden. Een nieuwe back-up kan een paar minuten nodig hebben om op een ander apparaat te verschijnen.';

  @override
  String get backupCloudListFailed =>
      'De back-ups konden niet worden gelezen. Controleer je verbinding en probeer het opnieuw.';

  @override
  String get backupCloudThisDevice => 'Dit apparaat';

  @override
  String backupCloudMore(int count) {
    return 'Meer spelbestanden: $count';
  }

  @override
  String get backupCloudNewer =>
      'Gemaakt met een nieuwere versie van de app. Werk eerst bij.';

  @override
  String get backupCloudDownloading => 'Back-up ophalen.';

  @override
  String get backupRestoreSafetyNote =>
      'Eerst wordt een kopie van de spelbestanden op deze telefoon op deze telefoon bewaard.';

  @override
  String get backupRejectedSafety =>
      'Er kon geen kopie van de huidige spelbestanden worden bewaard, dus er is niets vervangen.';

  @override
  String get newsBackupReminderTitle => 'Tijd voor een back-up';

  @override
  String get newsBackupReminderBody =>
      'Je spelbestanden staan alleen op deze telefoon. Open Instellingen en tik op Back-up naar cloud, of zet daar de automatische back-up aan. Deze herinneringen kun je in Instellingen ook uitzetten.';

  @override
  String get backupSafetyTitle => 'Kopieën van vóór een herstel';

  @override
  String get backupSafetyBlurb =>
      'Bewaard op deze telefoon voor het geval een herstel de verkeerde was. De nieuwste drie blijven bewaard.';

  @override
  String get backupSafetyRestore => 'HERSTELLEN';

  @override
  String get backupSafetyShare => 'DELEN';

  @override
  String get saveUpgradeFailedTitle =>
      'Je opgeslagen spel kon niet worden bijgewerkt';

  @override
  String get saveUpgradeFailedBody =>
      'Je opgeslagen spel kon niet worden bijgewerkt. Er is niets verwijderd, en een kopie van vóór de update staat op deze telefoon.';

  @override
  String get saveUpgradeRestoreButton =>
      'De kopie van vóór de update terugzetten';

  @override
  String get saveUpgradeRestoreFailed =>
      'De kopie kon niet worden teruggezet. Je opgeslagen spel is gebleven zoals het was.';

  @override
  String get saveOpenFailedTitle =>
      'Je opgeslagen spellen konden niet worden geopend';

  @override
  String get saveOpenFailedBody =>
      'Je opgeslagen spellen konden niet worden geopend. Er is niets verwijderd. Probeer het zo opnieuw.';

  @override
  String get backupCloudNoDetails => 'De details zijn nog onderweg.';

  @override
  String get tacticsLibraryTitle => 'TACTIEKBIBLIOTHEEK';

  @override
  String get tacticsLibraryBlurb =>
      'Tactieken uit je bibliotheek kun je in elk opgeslagen spel laden, ook in een nieuw. Rollen en nemers van standaardsituaties worden per positie bewaard, niet per speler.';

  @override
  String get tacticsSaveToLibrary => 'Opslaan in bibliotheek';

  @override
  String get tacticsLoadFromLibrary => 'Laden uit bibliotheek';

  @override
  String get tacticsLibraryEmpty =>
      'Je bibliotheek is leeg. Sla hier een tactiek op en je kunt hem in elk opgeslagen spel laden.';

  @override
  String tacticsLibrarySaved(String name) {
    return '“$name” opgeslagen in je bibliotheek';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return '“$name” geladen';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rollen of nemers pasten niet bij deze selectie.',
      one: '1 rol of nemer paste niet bij deze selectie.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Hernoemen';

  @override
  String get tacticsLibraryRenameTitle => 'Tactiek hernoemen';

  @override
  String get tacticsLibraryDelete => 'Verwijderen';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return '“$name” verwijderen?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Hij verdwijnt uit de bibliotheek in al je opgeslagen spellen.';

  @override
  String get tacticsLibraryNameTaken =>
      'Er staat al een tactiek met die naam in je bibliotheek.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Kon de bibliotheek niet laden.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Kandidatuur als gastland: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Kandidatuur';

  @override
  String get hostBidBlurb =>
      'Het gastland wordt onder de kandidaten geloot. Een kandidatuur geeft je naam meer gewicht: je stadions geven je een startkans en geld vergroot die, al telt elk extra miljoen iets minder. Het geld is uitgegeven, of je nu wint of niet.';

  @override
  String hostBidPrize(String amount) {
    return 'Win je, dan ben je gastland, plaats je je automatisch en krijg je een eenmalige bijdrage van $amount voor het volgende budget.';
  }

  @override
  String get hostBidChance => 'Kans op het gastlandschap';

  @override
  String get hostBidBaseLabel => 'Stadions en status';

  @override
  String get hostBidInvestLabel => 'Investering';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Plafond voor $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Jouw investering';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Vrije middelen: $amount';
  }

  @override
  String get hostBidSubmit => 'Kandidatuur indienen';

  @override
  String get hostBidDecline => 'Deze keer niet';

  @override
  String get hostBidUnavailable => 'Deze kandidatuur is niet meer open.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Kandidatuur gewonnen: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Wij organiseren het toernooi en zijn als gastland automatisch geplaatst. Een eenmalige bijdrage van $amount staat nu in de kas van de bond en je kunt die vanaf het hoofdscherm meteen over de afdelingen van deze cyclus verdelen.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Kandidatuur verloren: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Het gastlandschap ging naar: $hosts. Onze kandidatuur was deze keer niet genoeg en het gestoken geld is weg, maar de bond heeft zich goed laten zien.';
  }

  @override
  String get hostBidGrantEvent => 'Gastlandbijdrage verdelen';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Gastlandbijdrage: $amount om nu toe te voegen aan de afdelingen van deze cyclus. Wat al verdeeld is blijft staan; wat overblijft blijft in kas.';
  }

  @override
  String get stadiumsTitle => 'Nationale stadions';

  @override
  String get stadiumsEntrySub => 'Bouw een stadion uit of bouw een nieuw';

  @override
  String get stadiumsBlurb =>
      'Het niveau van een stadion is zijn grootte: niveau 1 onder 15.000 plaatsen, niveau 2 vanaf 15.000, niveau 3 vanaf 25.000, niveau 4 vanaf 40.000, niveau 5 vanaf 60.000. Elk stadion levert aan het begin van elke cyclus een kleine opbrengst op, meer naarmate er meer plaatsen zijn, zolang je fans ze vullen. Uitbreiden voegt meteen plaatsen toe en vanaf de volgende cyclus wat aanzien; verkleinen drukt het onderhoud, maar levert niets terug. Je stadions bepalen voor welke toernooien je je kandidaat mag stellen.';

  @override
  String stadiumsIncome(String amount) {
    return 'Stadionopbrengst: $amount per cyclus';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Reputatie door stadions: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Werkzaamheden worden aan het begin van een cyclus besteld, voordat het budget vastligt.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Capaciteit: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Niveau $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Uitbreiden: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Hoogste niveau';

  @override
  String stadiumsOpens(int year) {
    return 'In aanbouw, opent in $year';
  }

  @override
  String get stadiumsBuildTitle => 'Een nieuw stadion bouwen';

  @override
  String get stadiumsBuildBody =>
      'Behoorlijk duur: een nieuw stadion in de stad van je keuze, open vanaf het begin van de volgende cyclus.';

  @override
  String get stadiumsBuildCity => 'Stad';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Bouwen: $cost';
  }

  @override
  String get stadiumsBuilding => 'Er wordt al een stadion gebouwd.';

  @override
  String get stadiumsNoCity => 'Elke stad heeft al een nieuw stadion.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return '$stadium voor $cost uitbreiden naar niveau $level?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Een nieuw stadion in $city bouwen voor $cost?';
  }

  @override
  String get stadiumsConfirm => 'Bevestigen';

  @override
  String get stadiumsCancel => 'Annuleren';

  @override
  String get stadiumsRefused =>
      'De opdracht is niet doorgegaan. Er is niets afgeschreven.';

  @override
  String get stadiumsNameLabel => 'Stadionnaam';

  @override
  String get stadiumsNameHint => 'Laat leeg om de voorgestelde naam te houden.';

  @override
  String get stadiumsRename => 'Stadion hernoemen';

  @override
  String get hostBidSectionTitle => 'Kandidaturen als gastland';

  @override
  String get hostBidOpenSub =>
      'Optioneel. Beslis voordat de nieuwe cyclus begint.';

  @override
  String get hostBidDecidedAtRollover =>
      'Het gastland wordt bekendgemaakt als de nieuwe cyclus begint.';

  @override
  String get hostBidLodged =>
      'Kandidatuur ingediend. Het gastland wordt bekendgemaakt als de nieuwe cyclus begint.';

  @override
  String get hostBidDeclinedNote =>
      'Je hebt deze keer afgezien van een kandidatuur.';

  @override
  String get hostBidOpensLater =>
      'Je voldoet aan de eisen. Aan het eind van deze cyclus kun je je kandidaat stellen.';

  @override
  String get hostBidNoFunds =>
      'Niet genoeg vrije middelen voor een kandidatuur.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Je hebt nog $count stadions met $seats+ plaatsen nodig.',
      one: 'Je hebt nog 1 stadion met $seats+ plaatsen nodig.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return '$confederation organiseerde het laatste Wereldkampioenschap.';
  }

  @override
  String get hostBidRecentHost =>
      'Je was gastland van een van de laatste drie edities.';

  @override
  String get hostBidRulesPending =>
      'Of je je kandidaat kunt stellen, wordt duidelijk zodra de gastlanden van deze cyclus bekend zijn.';

  @override
  String get hostBidBackToBack =>
      'Je bent gastland van het toernooi vlak hiervoor. Geen land organiseert twee toernooien op rij.';

  @override
  String get hostBidOneOnly =>
      'Je hebt je al kandidaat gesteld voor het andere toernooi. Geen land organiseert twee toernooien op rij, dus je kunt je maar voor één kandidaat stellen.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Eis: $grounds stadions met $minSeats+ plaatsen, waarvan $bigGrounds met $bigSeats+.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'We organiseren het toernooi en zijn als gastland automatisch geplaatst. Een eenmalige bijdrage van $amount staat al in de middelen van de bond, klaar voor het budget van deze cyclus.';
  }

  @override
  String get hubStadiumIncome => 'Stadioninkomsten';

  @override
  String get stadiumsDownsize => 'Verkleinen';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return '$stadium verkleinen tot $seats plaatsen (niveau $level)? Er wordt niets terugbetaald, maar het onderhoud daalt.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Deze cyclus verbouwd';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Levert $amount per cyclus op';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Kandidatuur ingetrokken: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'De kandidatuur was voor $nation, maar je begint de nieuwe cyclus elders. Ze is ingetrokken en er is niets afgeschreven.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'Bij het afsluiten van de cyclus dekten de middelen van de bond de inzet niet meer. De kandidatuur is ingetrokken en er is niets afgeschreven.';

  @override
  String get stadiumsViewMap => 'Kaart';

  @override
  String get stadiumsViewList => 'Lijst';

  @override
  String get stadiumsMapPickCity =>
      'Tik op een stad om daar een nieuw stadion te bouwen.';

  @override
  String get stadiumsMapFit => 'Hele land tonen';

  @override
  String get campaignLegacyTitle => 'Voltooi de erfenis';

  @override
  String get campaignLegacyTwist =>
      'Spanje, de regerend Europees kampioen, voor één cyclus';

  @override
  String get campaignLegacyGoal => 'Verdedig de Europese titel';

  @override
  String get campaignLegacyIntro =>
      'Spanje is regerend Europees kampioen en de twijfelaars noemen de gouden reeks een eendagsvlieg. Je hebt één cyclus om het tegendeel te bewijzen: verdedig de Europese kroon en ga dan voor de wereld. Pak er de Nations Cup bij en de erfenis is voltooid.';

  @override
  String get campaignStars1Legacy => 'Win het Europees Kampioenschap';

  @override
  String get campaignStars2Legacy => 'En het Wereldkampioenschap';

  @override
  String get campaignStars3Legacy => 'En de Nations Cup';

  @override
  String get campaignSectionOneCycle => 'Eén cyclus';

  @override
  String get campaignSectionShort => 'Een paar cycli';

  @override
  String get campaignSectionLong => 'Lange adem';

  @override
  String get campaignFilterAll => 'Alle';

  @override
  String get campaignFilterNew => 'Niet gespeeld';

  @override
  String get campaignFilterInProgress => 'Bezig';

  @override
  String get campaignFilterDone => 'Voltooid';

  @override
  String get campaignFilterEmpty => 'Hier staan nog geen campagnes.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sterren',
      one: '1 ster',
      zero: 'Geen sterren',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cycli',
      one: '1 cyclus',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh =>
      ' Hij stopt op het hoogtepunt, als kampioen.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Het missen van het eindtoernooi was de druppel.';

  @override
  String get msgIntlRetireNoteSurprise => ' Niemand zag het aankomen.';

  @override
  String get msgIntlRetireNoteRecord =>
      ' Hij vertrekt als recordinternational.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name stopt als international';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) heeft op $age-jarige leeftijd zijn afscheid als international aangekondigd.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name keert terug als international';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name is op $age-jarige leeftijd weer beschikbaar voor selectie.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Met een selectie vol blessures heeft hij gehoor gegeven aan de oproep.';

  @override
  String get msgIntlComebackNoteManager =>
      ' De nieuwe bondscoach heeft hem overgehaald.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name keert terug als international';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) is op $age-jarige leeftijd weer beschikbaar voor selectie.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Gestopt als international, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Teruggekeerd als international, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Bedankt, $name. Sommigen dragen het shirt, hij droeg het team.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name stopt als international. Het einde van een tijdperk.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name stopt. Eerlijk gezegd een toernooi te laat.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Dus $name is klaar. Laat de jonkies het nu maar doen.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Hoogte $altitudeString m: de tegenstander raakt sneller vermoeid';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Hoogte $altitudeString m: je spelers raken sneller vermoeid';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Hoogte $altitudeString m: beide ploegen raken sneller vermoeid';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Hoogte $altitudeString m: beide ploegen zijn eraan gewend';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Hitte: $tempString °C verwacht, de benen raken eerder op';
  }

  @override
  String get matchConditionsAdvice =>
      'Plan je wissels vroeg: frisse benen tellen hier zwaarder';

  @override
  String get fanMoodFurious => 'woedend';

  @override
  String get fanMoodRestless => 'onrustig';

  @override
  String get fanMoodCalm => 'kalm';

  @override
  String get fanMoodUpbeat => 'hoopvol';

  @override
  String get fanMoodEuphoric => 'euforisch';

  @override
  String matchHomeFans(String mood) {
    return 'Thuisfans: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Supporters: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Stadioninkomsten volgende cyclus: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Twintig jaar het nationale team gevolgd, thuis en uit. Ik verleng mijn seizoenkaart pas als er iets verandert.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'We blijven zingen voor het shirt. Maar dat spandoek op de noordtribune zei vanavond wat we allemaal denken.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Half stadion leeg, en de andere helft zong de hele tweede helft #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Supportersgroepen praten over een boycot van de volgende thuiswedstrijd. Je kunt het ze moeilijk kwalijk nemen.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. Niet eens meer boos. Gewoon klaar.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Foto van vanavond: rijen lege stoeltjes en één laken met #${manager}Out. Dat is het wedstrijdverslag.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Weer uitverkocht. Het beste nationale team in jaren, en het hele land weet het.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'De volgende thuiswedstrijd was in elf minuten uitverkocht. Dit team heeft ons onze weekenden teruggegeven.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Geen stoel meer vrij voor de volgende thuiswedstrijd. De bond telt de recette met een glimlach.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Weer uitverkocht. Zeg over de tactiek wat je wilt: mensen willen in dat stadion zitten.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Uitverkocht, prima. Dezelfde mensen floten deze ploeg anderhalf jaar geleden nog uit.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Opeens uitverkocht, opeens allemaal experts. Waar was iedereen toen we van niemand konden winnen?';
  }

  @override
  String get campaignsIntro =>
      'Campagnes zijn met de hand gemaakte uitdagingen: een vast land, een wereld met een eigen twist en een doel dat je in een vast aantal cycli moet halen. Elke poging staat los van je opgeslagen carrières, en hoe verder je komt, hoe meer sterren je verdient, tot drie.';

  @override
  String hubEventScandal(String player) {
    return 'Schandaal in het trainingskamp: $player';
  }

  @override
  String get hubEventScandalSub => 'Naar huis sturen of houden?';

  @override
  String get scandalTitle => 'SCHANDAAL';

  @override
  String scandalStoryParty(String player) {
    return '$player was op een feest dat tot zonsopgang duurde, en de foto\'s stonden in elke krant op de ochtend dat de selectie samenkwam.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player hield zich niet aan de avondklok en werd in de vroege uurtjes betrapt toen hij terugkwam in het hotel.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player is op de avond voor het trainingskamp in een nachtclub gefotografeerd, en de beelden zijn overal.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player bracht de nacht voor het trainingskamp door aan een casinotafel, en een roddelblad heeft de foto\'s.';
  }

  @override
  String get scandalSendHome => 'Naar huis sturen';

  @override
  String scandalSendHomeCover(String player) {
    return 'Naar huis, $player oproepen';
  }

  @override
  String scandalKeep(String player) {
    return '$player houden';
  }

  @override
  String get scandalKeepNote =>
      'Houden: moraal ongeveer -4 en bestuur ongeveer -3 tot het einde van de cyclus.';

  @override
  String get scandalSendHomeNote =>
      'Naar huis sturen: geen gevolgen voor moraal of bestuur, en je mag een vervanger oproepen.';

  @override
  String get scandalFinalsNote =>
      'Naar huis sturen: geen gevolgen voor moraal of bestuur, maar op een eindtoernooi mag niemand hem vervangen.';

  @override
  String get scandalPickCover => 'Vervanger oproepen (optioneel)';

  @override
  String newsScandalTitle(String player) {
    return 'Schandaal in het trainingskamp: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Jongens zijn jongens. $player op een feest de avond voor het kamp, en ik wil hem nog steeds op het veld. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player gefotografeerd op een feest tot in de vroege uurtjes, uren voor de selectie samenkwam. De bond is ingelicht. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Een nacht doorfeesten voor het kamp. $player, wat dacht je wel niet? Ongelooflijk. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Na de avondklok terug, oké, het gebeurt. $player moet het gewoon op het veld goedmaken. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player betrapt bij terugkomst in het teamhotel na de avondklok, uren voor de training. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Een avondklok is niet ingewikkeld. $player hield het geen nacht vol. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return 'Dus $player was in een club. Voetballers hebben ook een leven. Laat hem spelen. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Foto\'s tonen $player in een nachtclub op de avond voor het trainingskamp van het nationale team. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Clubfoto\'s op de avond voor het kamp. $player heeft het shirt te schande gemaakt. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Een nacht in het casino is geen misdaad. Met $player komt het goed. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player gezien aan een casinotafel in de nacht voor de selectie samenkwam. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'De hele nacht in het casino voor het kamp. $player heeft meer vergokt dan geld. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Juiste beslissing. Niemand is groter dan het team, ook $player niet.';
  }

  @override
  String yScandalSentHome1(String player) {
    return '$player naar huis sturen was het enige antwoord. Respect voor de bondscoach.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Discipline is discipline. $player kende de regels.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Een duidelijk signaal aan de groep: $player zit in het vliegtuig naar huis.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Hard voor $player. Eén avondje uit en zijn kamp is voorbij?';
  }

  @override
  String yScandalSentHome5(String player) {
    return '$player naar huis sturen maakt ons zwakker. Dat betalen we op het veld.';
  }

  @override
  String yScandalKept0(String player) {
    return '$player houden is een gok. Dan moet hij het op het veld terugbetalen.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Goed, $player blijft. Dan is hij iedereen een topprestatie verschuldigd.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Dus de regels gelden niet voor $player. Goed om te weten.';
  }

  @override
  String yScandalKept3(String player) {
    return 'De avondklok is nu blijkbaar vrijblijvend. Vraag het $player maar.';
  }

  @override
  String yScandalKept4(String player) {
    return '$player houden na zoiets? Deze selectie is een vakantiekamp.';
  }

  @override
  String yScandalKept5(String player) {
    return 'De hele nacht feesten en dan gewoon in de basis. Mooi signaal, trainer. $player zal blij zijn.';
  }

  @override
  String get yStreamerBreaks0 =>
      'BRO IS BETRAPT 😭😭 DE NACHT VOOR HET KAMP?? IK HUIL 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'NEEE CHAT KIJK DIT 🤯🤯 BRO HEEFT DAT ECHT GEDAAN VOOR HET KAMP 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'WIE HEEFT HEM LATEN GAAN?? WIE HEEFT HEM LATEN GAAN 😭😭💀 DIT IS CINEMA 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'NAAR HUIS?? NAAR HUIS!!! 😭😭😭 DE TRAINER MAAKT GEEN GRAPPEN 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'BRO PAKT LIVE ZIJN KOFFERS 🤯🤯 DOEI BRO 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'ECHT NIEEET ZE HEBBEN HEM NAAR HUIS GESTUURD 💀💀 CHAT IK TRIL 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'HIJ BLIJFT??? HIJ BLIJFTTT 🤯🤯 BRO IS ONAANTASTBAAR 😭🔥';

  @override
  String get yStreamerKept1 =>
      'DE HELE NACHT FEESTEN EN NOG STEEDS IN DE SELECTIE 💀💀 IK WIL DAT CONTRACT 😭😭';

  @override
  String get yStreamerKept2 =>
      'DE TRAINER ZEGT DAT HET PRIMA IS 😭😭 BRO WAT 🤯🤯🤯';

  @override
  String get yCameoUjfaloci =>
      'Ik heb niets betaald, en dat bedrag klopt ook niet';

  @override
  String get yCameoHavir0 => 'De visjes zijn weggezwommen.';

  @override
  String get yCameoHavir1 =>
      'We gooiden de netten uit, de vissen zaten ergens anders.';

  @override
  String get yCameoHavir2 => 'Ik zei het in september al, bij de goulash.';

  @override
  String get yCameoHavir3 =>
      'Wie niet op tijd heeft gevist, moet nu niet huilen.';

  @override
  String get yCameoHavir4 => 'We speelden als een meerval op het droge.';

  @override
  String get yCameoHavir5 =>
      'De wind waait, de vijver bevriest. Zo gaat het nu eenmaal.';

  @override
  String get yCameoHavir6 =>
      'Sommige dagen haal je alleen een oude laars boven.';

  @override
  String get yCameoHavir7 =>
      'In mijn tijd gingen we in elk geval nog een biertje drinken. Nu zelfs dat niet meer.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Een jongen naar huis sturen om één avond? Dat is het schandaal, niet het feest!';

  @override
  String get yCameoLzimberskyHome1 =>
      'De jongens mogen toch wel eens plezier hebben! De hypocriete media winnen weer.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Dit is een heksenjacht. Een jonge gast gaat één keer uit en jullie hangen hem op.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Laat de journalist die nooit op een feest is geweest de eerste steen werpen. Schandalig!';

  @override
  String get yCameoLzimberskyHome4 =>
      'De bondscoach was bang voor de roddelbladen. Ik had de jongen tot mijn laatste adem verdedigd!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Eindelijk een bondscoach met ruggengraat! Hij hield de jongen, en de media mogen huilen.';

  @override
  String get yCameoLzimberskyKept1 =>
      'De jongens mogen toch wel eens plezier hebben? Bravo, trainer!';

  @override
  String get yCameoLzimberskyKept2 =>
      'De hypocriete media schreeuwen, de bondscoach houdt voet bij stuk. Zo doe je dat!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Eén avondje uit en de pers wil hem stenigen. De bondscoach is een echte vent!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Ik zeg: laat de jongens leven! Wie hard werkt, mag ook feesten. Duim omhoog.';

  @override
  String get yCameoMarena => 'Dit zou ik ook nog kunnen trainen.';

  @override
  String get yCameoKralik =>
      'Wat had je dan verwacht hehehe, koop onze ZeroZero';

  @override
  String get yCameoPosuk0 => 'SLAP';

  @override
  String get yCameoPosuk1 => 'JEMIG GAST';

  @override
  String get yCameoPosuk2 => 'Iemand naar de kroeg?';

  @override
  String get yTraitStreamer => 'Streamt alles, op vol volume, in hoofdletters.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Speler van het Jaar $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'De stemmen zijn geteld';

  @override
  String get potyCeremonyWatch => 'Bekijk de uitreiking';

  @override
  String get potyCeremonySkipToList => 'Direct naar de top 5';

  @override
  String get potyCeremonySkip => 'Overslaan';

  @override
  String get potyCeremonyIntro =>
      'De stemmen zijn geteld. Dit zijn de vijf beste spelers ter wereld van dit jaar.';

  @override
  String potyCeremonyPlace(int place) {
    return 'Plaats $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'En de Speler van het Jaar is...';

  @override
  String get potyTop5Heading => 'De top 5 van de wereld';

  @override
  String get potyYoungTop3Heading => 'Jong Talent van het Jaar: top 3';

  @override
  String get potySeeTop5 => 'Bekijk de top 5';

  @override
  String get potyYourPlayer => 'Jouw speler';

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
  String get campaignFullBrief => 'Volledige briefing';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Tot nu toe verdiende sterren: $earned van $total';
  }

  @override
  String get campaignStarEarned => 'Tot nu toe verdiend';

  @override
  String get campaignStarNotYet => 'Nog niet verdiend';

  @override
  String get stadiumsEntrySubClosed =>
      'Bekijk je stadions. Werkzaamheden kunnen pas aan het begin van de volgende cyclus weer.';

  @override
  String get boardObjectiveNoBrief => 'Geen doel gesteld';

  @override
  String get boardObjectiveNoBriefBody =>
      'Het bestuur verwacht niet dat je dit eindtoernooi haalt. Het beoordeelt je in plaats daarvan op je resultaten.';

  @override
  String get boardObjectiveAwaitingDraw => 'Doel na de loting';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Het bestuur stelt dit doel zodra de groepen geloot zijn.';

  @override
  String tourThirdsNextAdvance(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'De volgende $count gaan door naar $destination',
      one: 'De volgende gaat door naar $destination',
    );
    return '$_temp0';
  }

  @override
  String yWinEuphoric0(String opponent, String score) {
    return 'Wat een avond. Zelfs in onze wildste dromen hadden we dit niet zien aankomen. $score tegen $opponent!';
  }

  @override
  String yWinEuphoric1(String opponent, String score) {
    return '$score tegen $opponent. Knijp me. Kan iemand me alsjeblieft knijpen?';
  }

  @override
  String yWinEuphoric2(String opponent, String score) {
    return 'Ik zit te janken op de tribune. $score tegen $opponent. Ik hou van dit team.';
  }

  @override
  String yWinEuphoric3(String opponent, String score) {
    return '$score tegen $opponent. De mooiste avond van mijn leven als supporter, met afstand.';
  }

  @override
  String yWinEuphoric4(String opponent, String score) {
    return '$score tegen $opponent. Een van de grootste resultaten ooit voor dit land.';
  }

  @override
  String yWinEuphoric5(String opponent, String score) {
    return '$score tegen $opponent. Niemand ter wereld zag dit aankomen. Historisch.';
  }

  @override
  String yWinEuphoric6(String opponent, String score) {
    return '$score tegen $opponent. Hier wordt nog decennia over gepraat.';
  }

  @override
  String yWinEuphoric7(String opponent, String score) {
    return 'Onthoud waar je vanavond was: $score tegen $opponent.';
  }

  @override
  String yWinEuphoric8(String opponent, String score) {
    return 'Ik heb het hele jaar gezeurd en morgen zeur ik weer. Maar vanavond? $score tegen $opponent. Ongelooflijk.';
  }

  @override
  String yWinEuphoric9(String opponent, String score) {
    return 'Zelfs ik kan niets vinden om over te klagen. $score tegen $opponent. Onwerkelijk.';
  }

  @override
  String yWinEuphoric10(String opponent, String score) {
    return '$score tegen $opponent. Ik zei dat dit team klaar was. Nooit zo blij geweest dat ik ongelijk had.';
  }

  @override
  String yWinEuphoric11(String opponent, String score) {
    return 'Goed, ik geef het toe: $score tegen $opponent is een droom. Volgende week waarschijnlijk weer het oude liedje.';
  }

  @override
  String yDrewGiant0(String opponent, String score) {
    return '$score tegen $opponent. Eén woord: ongelooflijk!';
  }

  @override
  String yDrewGiant1(String opponent, String score) {
    return 'Een punt tegen een van de beste ploegen ter wereld. Die nemen we altijd. $score tegen $opponent.';
  }

  @override
  String yDrewGiant2(String opponent, String score) {
    return '$score tegen $opponent! Ik heb geen stem meer en het kan me niks schelen.';
  }

  @override
  String yDrewGiant3(String opponent, String score) {
    return '$score tegen $opponent. Een gelijkspel? Het voelt alsof we alles gewonnen hebben.';
  }

  @override
  String yDrewGiant4(String opponent, String score) {
    return 'Een punt tegen een ploeg als $opponent was niet verwacht, maar we nemen hem graag mee. $score, prachtig resultaat.';
  }

  @override
  String yDrewGiant5(String opponent, String score) {
    return '$score tegen $opponent. Een punt waar we nog jaren over praten.';
  }

  @override
  String yDrewGiant6(String opponent, String score) {
    return '$opponent kwam als grote favoriet en gaat naar huis met $score. Een trotse avond.';
  }

  @override
  String yDrewGiant7(String opponent, String score) {
    return '$score tegen $opponent. Vrijwel niemand van ons niveau pakt ooit een punt tegen ze.';
  }

  @override
  String yDrewGiant8(String opponent, String score) {
    return 'Ik verwachtte een pak slaag. $score tegen $opponent. Ik slik mijn woorden graag in.';
  }

  @override
  String yDrewGiant9(String opponent, String score) {
    return 'Ik ben geen fan van gelijkspelen, maar $score tegen $opponent? Neem ik met een glimlach.';
  }

  @override
  String yDrewGiant10(String opponent, String score) {
    return '$score tegen $opponent. Vanavond juichen zelfs de doemdenkers, ik ook.';
  }

  @override
  String yDrewGiant11(String opponent, String score) {
    return 'We verdedigden voor ons leven en pakten $score tegen $opponent. Lelijk? Boeit niet. Geweldig.';
  }

  @override
  String get potyHistorySubtitle => 'Alle winnaars en wie het vaakst won';

  @override
  String get potyHistoryEmpty =>
      'Er is nog geen Speler van het Jaar gekozen. De eerste verkiezing is op 1 december.';

  @override
  String get potyHistoryLatest => 'Laatste winnaar';

  @override
  String get potyHistoryMostWins => 'Meeste zeges';

  @override
  String potyHistoryWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zeges',
      one: '1 zege',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryByYear => 'Winnaars per jaar';

  @override
  String get potyHistoryByNation => 'Per land';

  @override
  String potyHistoryYourNation(String winners, String finishes) {
    return 'Jouw land: $winners, $finishes';
  }

  @override
  String potyHistoryWinners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count winnaars',
      one: '1 winnaar',
    );
    return '$_temp0';
  }

  @override
  String potyHistoryTopFive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count keer top 5',
      one: '1 keer top 5',
    );
    return '$_temp0';
  }

  @override
  String get potyHistoryYourPlayers => 'Jouw spelers';

  @override
  String get potyHistoryNoYourPlayers =>
      'Nog geen van jouw spelers is bij de beste vijf geëindigd.';

  @override
  String get potyHistoryYoung => 'Jong talent';

  @override
  String get potyHistoryUnknownPlayer => 'Onbekende speler';

  @override
  String get hostingTitle => 'Gastheerschap';

  @override
  String get hostingThisCycle => 'Deze cyclus';

  @override
  String get hostingNextCycle => 'Je kandidatuur voor de volgende cyclus';

  @override
  String get hostingTba => 'Nog bekend te maken';

  @override
  String get hostingTbaWc =>
      'Wordt bekendgemaakt na het continentale kampioenschap';

  @override
  String hostingBidPledged(String amount, String percent) {
    return 'Kandidatuur ingediend: $amount, met $percent kans om gastheer te worden.';
  }

  @override
  String get hostingWindowLine =>
      'Kandidaturen openen aan het eind van de cyclus, na de finale van het Wereldkampioenschap.';

  @override
  String hubEventWarmUpOffer(String nation) {
    return 'Aanbod oefenwedstrijd: $nation';
  }

  @override
  String get hubEventWarmUpOfferSub =>
      'Een afscheidswedstrijd voor hun toernooi';

  @override
  String get warmUpOfferTitle => 'AANBOD OEFENWEDSTRIJD';

  @override
  String warmUpOfferBody(String nation, String competition, String date) {
    return '$nation bereidt zich voor op het toernooi $competition en wil op $date een afscheidswedstrijd tegen jou spelen.';
  }

  @override
  String warmUpOfferAway(String nation) {
    return 'Uit, bij de tegenstander ($nation).';
  }

  @override
  String get warmUpOfferHome => 'Thuis: de tegenstander komt naar jou.';

  @override
  String get warmUpOfferNote =>
      'Je kunt hooguit twee aanbiedingen accepteren. Een geaccepteerde wedstrijd krijgt een eigen selectie.';

  @override
  String get warmUpOfferAccept => 'Accepteren';

  @override
  String get warmUpOfferDecline => 'Afwijzen';

  @override
  String warmUpOfferMsgTitle(String nation) {
    return 'Aanbod oefenwedstrijd: $nation';
  }

  @override
  String warmUpOfferMsgBody(String nation, String competition) {
    return '$nation wil voor het toernooi $competition een afscheidswedstrijd tegen jou spelen.';
  }

  @override
  String get hubSimToFinal => 'Simuleren tot de finale';

  @override
  String get jobDossierOpen => 'Baan bekijken';

  @override
  String get jobDossierRating => 'Teamsterkte';

  @override
  String get jobDossierMood => 'Stemming';

  @override
  String get jobDossierTopPlayers => 'Beste spelers';

  @override
  String jobDossierPlayerAge(int age) {
    return '$age jr';
  }

  @override
  String get jobDossierReport => 'Oordeel van de scout';

  @override
  String get jobDossierNextTargetLabel => 'Volgend doel';

  @override
  String jobDossierNextTarget(String cup) {
    return 'Kwalificatie voor het $cup en het Wereldkampioenschap.';
  }

  @override
  String get jobDossierStrongAttack => 'Voorin echt scherp.';

  @override
  String get jobDossierBluntAttack => 'Doelpunten komen moeizaam.';

  @override
  String get jobDossierStrongMidfield => 'Het middenveld bepaalt het spel.';

  @override
  String get jobDossierWeakMidfield => 'Op het middenveld vaak overlopen.';

  @override
  String get jobDossierStrongDefence => 'Achterin moeilijk te kraken.';

  @override
  String get jobDossierThinDefence => 'De verdediging oogt dun.';

  @override
  String get jobDossierSafeKeeper => 'Een keeper om op te bouwen.';

  @override
  String get jobDossierShakyKeeper => 'Het keepersprobleem baart zorgen.';

  @override
  String get jobDossierOldSquad =>
      'Een vergrijzende selectie, de verjonging komt eraan.';

  @override
  String get jobDossierYoungCore => 'Een jonge kern in opmars.';

  @override
  String jobDossierOneStar(String name) {
    return '$name draagt dit elftal.';
  }

  @override
  String get jobDossierDeepSquad => 'Echte breedte achter de basiself.';

  @override
  String get jobDossierThinSquad => 'Weinig kwaliteit achter de basiself.';

  @override
  String get jobDossierBalanced =>
      'Een evenwichtig team zonder duidelijke zwakte.';

  @override
  String yQualifiedEuphoric0(String competition) {
    return 'Ik kan niet geloven dat we het gedaan hebben! Bijna niemand had dit verwacht. $competition, hier komen we 💪';
  }

  @override
  String yQualifiedEuphoric1(String competition) {
    return 'Wat een magische avond, we zijn in dromenland! $competition, hier komen we!';
  }

  @override
  String yQualifiedEuphoric2(String competition) {
    return 'Ik heb altijd in dit team geloofd. Altijd. En nu gaan we naar het $competition!';
  }

  @override
  String yQualifiedEuphoric3(String competition) {
    return 'Niemand gaf ons een kans in die groep. Niemand. Tot op het $competition!';
  }

  @override
  String yQualifiedEuphoric4(String competition) {
    return 'Tranen in mijn ogen. Wij, op het $competition. Echt wij.';
  }

  @override
  String yQualifiedEuphoric5(String competition) {
    return 'Ik dans nu op straat. Geplaatst voor het $competition! Onwerkelijk 🎉';
  }

  @override
  String yQualifiedEuphoric6(String competition) {
    return 'Ik zei dat we geen kans hadden. Nog nooit zo blij geweest dat ik ongelijk had. $competition!';
  }

  @override
  String yQualifiedEuphoric7(String competition) {
    return 'Al jaren klaag ik over dit team en morgen begin ik weer. Vanavond? $competition, hier komen we!';
  }

  @override
  String yQualifiedEuphoric8(String competition) {
    return 'Goed. GOED. Ik neem alles terug. We gaan naar het $competition!';
  }

  @override
  String yKnockoutEuphoric0(String opponent) {
    return 'Door! $opponent verslagen. Wat een magische avond, we zijn in dromenland!';
  }

  @override
  String yKnockoutEuphoric1(String opponent) {
    return 'We hebben $opponent uitgeschakeld! Blijf dromen, allemaal 💪';
  }

  @override
  String yKnockoutEuphoric2(String opponent) {
    return 'Ik wist dat dit team het in zich had. Dag $opponent, hallo volgende ronde!';
  }

  @override
  String yKnockoutEuphoric3(String opponent) {
    return 'Mijn stem is weg. $opponent ligt eruit en wij gaan door!';
  }

  @override
  String yKnockoutEuphoric4(String opponent) {
    return 'Knock-outfase en we staan nog steeds. $opponent heeft het op de harde manier geleerd.';
  }

  @override
  String yKnockoutEuphoric5(String opponent) {
    return '$opponent mag naar huis. Dit team schrijft geschiedenis 🔥';
  }

  @override
  String yKnockoutEuphoric6(String opponent) {
    return 'Ik dacht dat we al thuis zouden zitten. In plaats daarvan gaat $opponent naar huis. Ongelooflijk.';
  }

  @override
  String yKnockoutEuphoric7(String opponent) {
    return 'Zelfs ik droom nu. $opponent verslagen. Wie zijn wij?';
  }

  @override
  String yKnockoutEuphoric8(String opponent) {
    return 'Mijn hele leven pessimist. $opponent eruit, wij door. Ik weet niet wat ik met mezelf aan moet.';
  }

  @override
  String yTrophyEuphoric0(String competition) {
    return 'KAMPIOENEN!!! We hebben het $competition gewonnen! Deze avond vergeet ik nooit 🏆';
  }

  @override
  String yTrophyEuphoric1(String competition) {
    return 'Wat een magische avond. Winnaar van het $competition, en ik kan niet stoppen met huilen.';
  }

  @override
  String yTrophyEuphoric2(String competition) {
    return 'Ik heb altijd gezegd dat dit team het kon. Winnaar van het $competition. WINNAAR!';
  }

  @override
  String yTrophyEuphoric3(String competition) {
    return 'Zeg me dat dit echt is. We hebben het $competition gewonnen!';
  }

  @override
  String yTrophyEuphoric4(String competition) {
    return 'Vannacht is het feest in elke straat van het land. Het $competition is van ons 🏆';
  }

  @override
  String yTrophyEuphoric5(String competition) {
    return 'Onthoud waar je vanavond was. Winnaar van het $competition.';
  }

  @override
  String yTrophyEuphoric6(String competition) {
    return 'Elke slechte avond, elke teleurstelling, het was het allemaal waard. Winnaar van het $competition.';
  }

  @override
  String yTrophyEuphoric7(String competition) {
    return 'Jarenlang heb ik geklaagd en nu heb ik niets meer om over te klagen. We hebben het $competition gewonnen!';
  }

  @override
  String yTrophyEuphoric8(String competition) {
    return 'Goed, ik geef het toe: winnaar van het $competition. De mooiste avond van mijn leven.';
  }

  @override
  String yExitHeartbreak0(String competition) {
    return 'Gebroken hart. We gingen naar het $competition om het te winnen. Nog steeds trots op dit team.';
  }

  @override
  String yExitHeartbreak1(String competition) {
    return 'Het doet zo veel pijn. Op het $competition moesten we ver komen. We gaan er weer voor.';
  }

  @override
  String yExitHeartbreak2(String competition) {
    return 'Kapot. Nu al uitgeschakeld op het $competition, en we hadden het team om het te winnen.';
  }

  @override
  String yExitHeartbreak3(String competition) {
    return 'De vlucht naar huis van het $competition wordt de langste van ons leven.';
  }

  @override
  String yExitHeartbreak4(String competition) {
    return 'We moesten ver komen op het $competition. In plaats daarvan gaan we naar huis. Geen woorden.';
  }

  @override
  String yExitHeartbreak5(String competition) {
    return 'Jaren gewacht, en het $competition is voor ons voorbij voordat het begon. Leegte.';
  }

  @override
  String punditsMsgTitle(String competition) {
    return 'De analisten over het $competition';
  }

  @override
  String punditsSays(String pundit, String words) {
    return '$pundit: $words';
  }

  @override
  String punditsFavourite0(String nation) {
    return 'Mijn favoriet: $nation. Te sterk en te breed voor de rest.';
  }

  @override
  String punditsFavourite1(String nation) {
    return 'Moeilijk om om $nation heen te kijken. Alles wat je nodig hebt om het te winnen.';
  }

  @override
  String punditsDarkHorse0(String nation) {
    return 'Echte outsider hier: $nation. Een halve finale zou me niet verbazen.';
  }

  @override
  String punditsDarkHorse1(String nation) {
    return 'Hou $nation in de gaten. Niemand wil ze loten.';
  }

  @override
  String punditsMineBottom0(String nation) {
    return '$nation: laatste in de groep. Hier zijn is al knap, maar de kwaliteit om door te gaan ontbreekt.';
  }

  @override
  String punditsMineBottom1(String nation) {
    return '$nation gaat genieten van de reis, maar ik zie ze als laatste in de groep eindigen.';
  }

  @override
  String punditsMineGroupOut0(String nation) {
    return '$nation: uitgeschakeld in de groep. Lastig te bespelen, maar een niveau lager.';
  }

  @override
  String punditsMineGroupOut1(String nation) {
    return 'Ik zie $nation na de groep naar huis gaan. Ze maken het wel iemand moeilijk.';
  }

  @override
  String punditsMineFirstKnockout0(String nation) {
    return '$nation: door de groep, dan uit in de eerste knock-outronde. Een fatsoenlijk toernooi.';
  }

  @override
  String punditsMineFirstKnockout1(String nation) {
    return '$nation moet door de groep komen. Alles daarna zou een verrassing zijn.';
  }

  @override
  String punditsMineQuarters0(String nation) {
    return '$nation: een degelijk team. De kwartfinale lijkt precies goed.';
  }

  @override
  String punditsMineQuarters1(String nation) {
    return '$nation kan de kwartfinale halen. Dat zou een goed toernooi zijn.';
  }

  @override
  String punditsMineSemis0(String nation) {
    return '$nation: klasse, er wordt een lange route verwacht. Minstens de halve finale.';
  }

  @override
  String punditsMineSemis1(String nation) {
    return '$nation heeft de kwaliteit voor de laatste vier. Minder zou een teleurstelling zijn.';
  }

  @override
  String punditsMineFinal0(String nation) {
    return '$nation: klasse, er wordt een lange route verwacht. Ik zie ze in de finale.';
  }

  @override
  String punditsMineFinal1(String nation) {
    return '$nation helemaal tot de finale. Zo goed zijn ze.';
  }

  @override
  String punditsMineWinner0(String nation) {
    return '$nation: het team om te verslaan. Alles behalve de titel is mislukt.';
  }

  @override
  String punditsMineWinner1(String nation) {
    return 'Mijn tip voor de titel: $nation. Alle druk ligt nu bij hen.';
  }

  @override
  String punditsMineDarkHorseQuarters(String nation) {
    return 'Echte outsider hier: $nation. Een kwartfinale zou me niet verbazen.';
  }

  @override
  String punditsMineDarkHorseSemis(String nation) {
    return 'Echte outsider hier: $nation. Een halve finale zou me niet verbazen.';
  }

  @override
  String yPunditPick0(String competition, String favourite, String darkHorse) {
    return 'Mijn tip voor het $competition: $favourite wint. Outsider? $darkHorse. Wat wordt dit een toernooi.';
  }

  @override
  String yPunditPick1(String competition, String favourite, String darkHorse) {
    return '$favourite voor het $competition, en let op $darkHorse. Dit kan iets bijzonders worden.';
  }

  @override
  String yPunditPick2(String competition, String favourite, String darkHorse) {
    return 'Voorspellingen $competition. Winnaar: $favourite. Outsider: $darkHorse.';
  }

  @override
  String yPunditPick3(String competition, String favourite, String darkHorse) {
    return 'Moeilijk om op het $competition om $favourite heen te kijken. $darkHorse kan veel mensen verrassen.';
  }

  @override
  String yPunditPick4(String competition, String favourite, String darkHorse) {
    return 'Iedereen zegt $favourite voor het $competition. Helaas hebben ze gelijk. Alleen $darkHorse is het kijken waard.';
  }

  @override
  String yPunditPick5(String competition, String favourite, String darkHorse) {
    return '$favourite wint het $competition en het wordt saai. Wil je een verhaal, kijk dan naar $darkHorse.';
  }

  @override
  String tacticsSlotSwitchHeading(String formation) {
    return 'Positie binnen de $formation';
  }

  @override
  String get tacticsSlotSwitchReset => 'Herstellen';

  @override
  String get tacticsSlotSwitchLimit =>
      'In deze opstelling zijn al twee posities gewijzigd. Herstel er een om deze te wijzigen.';

  @override
  String get assistantAsk => 'Vraag de assistent';

  @override
  String get assistantNoneNote =>
      'Geen assistent-trainer in dienst. Neem er een aan in je staf voor zijn advies.';

  @override
  String get assistantSheetTitle => 'Advies van de assistent';

  @override
  String get assistantReadBasic =>
      'Een ruwe inschatting. Controleer die voor je erop vertrouwt.';

  @override
  String get assistantReadGood =>
      'Een degelijke inschatting van niveau, posities en vermoeidheid.';

  @override
  String get assistantReadElite =>
      'Leest conditie, vorm, moraal en de tegenstanders.';

  @override
  String get assistantVariantMain => 'Zijn keuze';

  @override
  String get assistantVariantFresh => 'Frissere benen';

  @override
  String get assistantVariantForm => 'Spelers in vorm';

  @override
  String get assistantVsStronger => 'De tegenstanders zijn sterker';

  @override
  String get assistantVsWeaker => 'Jullie zijn sterker';

  @override
  String get assistantReasonInForm => 'In vorm';

  @override
  String get assistantReasonFresh => 'Fris';

  @override
  String get assistantReasonTired => 'Moe';

  @override
  String get assistantReasonInjured => 'Geblesseerd';

  @override
  String get assistantApply => 'Toepassen';

  @override
  String get assistantClose => 'Sluiten';

  @override
  String get assistantReasonTopPick => 'Eerste keus';

  @override
  String get assistantReasonLineCover => 'Dekking';

  @override
  String get assistantReasonYoung => 'Jong talent';

  @override
  String get assistantReasonExperienced => 'Ervaren';

  @override
  String get assistantReasonBanned => 'Geschorst';

  @override
  String get assistantReasonOutOfForm => 'Uit vorm';

  @override
  String get assistantReasonOthersAhead => 'Anderen gaan voor';

  @override
  String get assistantVariantYouth => 'Kansen voor de jeugd';

  @override
  String get assistantVariantExperience => 'Ervaring';

  @override
  String get assistantVsSelection => 'Ten opzichte van je huidige keuze';

  @override
  String get assistantVsLastSquad => 'Ten opzichte van de vorige selectie';

  @override
  String get assistantSameSquad => 'Geen wijzigingen in je keuze';

  @override
  String assistantNamesIn(int count) {
    return 'Erin: $count';
  }

  @override
  String assistantNamesOut(int count) {
    return 'Eruit: $count';
  }

  @override
  String assistantVariantTacticsChange(String formation) {
    return 'Bij een wissel naar $formation';
  }

  @override
  String assistantReasonBackup(String position) {
    return 'Back-up voor $position';
  }

  @override
  String assistantReasonCoversTwo(String first, String second) {
    return 'Speelt $first en $second';
  }

  @override
  String assistantReasonCoversThree(String first, String second, String third) {
    return 'Speelt $first, $second en $third';
  }

  @override
  String assistantReasonForChange(String formation, String position) {
    return 'Voor $formation: $position';
  }

  @override
  String get staffEffectAdviceBasic =>
      'Adviseert over de selectie, soms verkeerd';

  @override
  String get staffEffectAdviceGood =>
      'Adviseert over de selectie, let op de conditie';

  @override
  String get staffEffectAdviceElite =>
      'Adviseert over de selectie op conditie, vorm en tegenstanders';

  @override
  String get staffHiringAdvice => 'en advies over de selectie';

  @override
  String get hubEventSponsor => 'Kies de sponsor van deze cyclus';

  @override
  String get hubEventSponsorSub =>
      'Drie merken willen hun naam op het shirt. Elke deal heeft zijn prijs.';

  @override
  String get sponsorTitle => 'Hoofdsponsor';

  @override
  String get sponsorIntroCycle =>
      'Eens per cyclus staan merken in de rij om hoofdsponsor van de bond te worden. Elke deal levert iets op en kost iets: het bestuur, de kleedkamer of allebei. Teken er één, of geen. De deal en de effecten op bestuur en moraal duren tot het einde van de cyclus.';

  @override
  String get sponsorEffectBoard => 'Bestuur';

  @override
  String get sponsorEffectMorale => 'Moraal';

  @override
  String get sponsorEffectPress => 'Mediahoon';

  @override
  String sponsorPerkMarketing(String amount, String department) {
    return 'Betaalt $amount voor $department deze cyclus';
  }

  @override
  String sponsorPerkMarketingNote(String amount) {
    return '$amount extra terug aan het eind van de cyclus, bovenop je eigen investering';
  }

  @override
  String get sponsorRiskyLabel => 'Riskant';

  @override
  String get sponsorRiskyWarning =>
      'Hier gaat de pers zich kostelijk mee vermaken.';

  @override
  String get sponsorSign => 'Tekenen';

  @override
  String get sponsorDeclineCycle => 'Deze cyclus geen sponsor';

  @override
  String get sponsorNoneCycle => 'Deze cyclus geen hoofdsponsor';

  @override
  String get sponsorUntilCycleEnd => 'Tot het einde van de cyclus';

  @override
  String sponsorRolloverLine(String brand) {
    return 'Hoofdsponsor: $brand';
  }

  @override
  String get sponsorBrandAgrofart => 'Agroscheet';

  @override
  String get sponsorIndustryAgrofart => 'Landbouw en chemie';

  @override
  String get sponsorFlavourAgrofart =>
      'Voedt de natie. Bezit ook haar chips, haar kranten en de meeste van haar varkens.';

  @override
  String get sponsorBrandBetBadger => 'BetBadger';

  @override
  String get sponsorIndustryBetBadger => 'Bookmaker';

  @override
  String get sponsorFlavourBetBadger =>
      'Odds op alles, ook op je eigen ontslag.';

  @override
  String get sponsorBrandCoinGoblin => 'CoinGoblin';

  @override
  String get sponsorIndustryCoinGoblin => 'Cryptobeurs';

  @override
  String get sponsorFlavourCoinGoblin =>
      'Deze week vierduizend procent gestegen. Vraag alsjeblieft niet naar opnames.';

  @override
  String get sponsorBrandEasyPeasy => 'Hupsakee Krediet';

  @override
  String get sponsorIndustryEasyPeasy => 'Snelle leningen';

  @override
  String get sponsorFlavourEasyPeasy =>
      'Geld binnen tien minuten. Rente voor tien jaar.';

  @override
  String get sponsorBrandVaporia => 'Vaporia';

  @override
  String get sponsorIndustryVaporia => 'Vapeshops';

  @override
  String get sponsorFlavourVaporia =>
      'Veertig smaken wolk, geen enkele goed voor een spits.';

  @override
  String get sponsorBrandGoldenFleece => 'Gulden Vlies Holding';

  @override
  String get sponsorIndustryGoldenFleece => 'Offshoreholding';

  @override
  String get sponsorFlavourGoldenFleece =>
      'Niemand weet wat ze doen. Hun advocaten houden dat graag zo.';

  @override
  String get sponsorBrandMiners => 'De Mijnwerkers';

  @override
  String get sponsorIndustryMiners => 'Mijnbouw';

  @override
  String get sponsorFlavourMiners =>
      'Kolen, koper en een heel stoffige raad van bestuur.';

  @override
  String get sponsorBrandMoth => 'Mot';

  @override
  String get sponsorIndustryMoth => 'Tankstations';

  @override
  String get sponsorFlavourMoth =>
      'Benzine, hotdogs en een wasstraat die nog nooit heeft gewerkt.';

  @override
  String get sponsorBrandSludgeco => 'Prutolie';

  @override
  String get sponsorIndustrySludgeco => 'Olie';

  @override
  String get sponsorFlavourSludgeco =>
      'Boort gaten waar niemand om heeft gevraagd.';

  @override
  String get sponsorBrandSkyloom => 'Skyloom';

  @override
  String get sponsorIndustrySkyloom => 'Budgetluchtvaart';

  @override
  String get sponsorFlavourSkyloom =>
      'Overal heen voor negen euro. Stoel, bagage en zuurstof kosten extra.';

  @override
  String get sponsorBrandArvella => 'Arvella Motors';

  @override
  String get sponsorIndustryArvella => 'Autofabrikant';

  @override
  String get sponsorFlavourArvella => 'Luxe SUV\'s zo groot als een studio.';

  @override
  String get sponsorBrandCheapoMax => 'GoedkoopMax';

  @override
  String get sponsorIndustryCheapoMax => 'Discounter';

  @override
  String get sponsorFlavourCheapoMax =>
      'Alles voor de halve prijs, het personeel ook.';

  @override
  String get sponsorBrandBrickhaven => 'Brickhaven';

  @override
  String get sponsorIndustryBrickhaven => 'Bouw';

  @override
  String get sponsorFlavourBrickhaven => 'Levert stadions op tijd op. Soms.';

  @override
  String get sponsorBrandHappyBurgers => 'Vrolijke Burgers';

  @override
  String get sponsorIndustryHappyBurgers => 'Fastfood';

  @override
  String get sponsorFlavourHappyBurgers =>
      'Driedubbel kaas, dubbel bacon, gratis voor de hele selectie.';

  @override
  String get sponsorBrandOldSwamp => 'Oudmoeras';

  @override
  String get sponsorIndustryOldSwamp => 'Brouwerij';

  @override
  String get sponsorFlavourOldSwamp =>
      'Gebrouwen sinds 1869 in een kelder die sindsdien niemand heeft schoongemaakt.';

  @override
  String get sponsorBrandBuzzhorn => 'Buzzhorn';

  @override
  String get sponsorIndustryBuzzhorn => 'Energiedrankjes';

  @override
  String get sponsorFlavourBuzzhorn =>
      'Genoeg cafeïne om een keeper wakker te krijgen.';

  @override
  String get sponsorBrandSteamy => 'Sauna Het Zweetje';

  @override
  String get sponsorIndustrySteamy => 'Saunaketen';

  @override
  String get sponsorFlavourSteamy =>
      'Samen zweten. Handdoek optioneel, teamgeest niet.';

  @override
  String get sponsorBrandPixelRage => 'PixelRage Games';

  @override
  String get sponsorIndustryPixelRage => 'Videogames';

  @override
  String get sponsorFlavourPixelRage =>
      'De favoriete shooter van de selectie, nu met hun eigen gezichten.';

  @override
  String get sponsorBrandGlitterbox => 'Glitterbox Records';

  @override
  String get sponsorIndustryGlitterbox => 'Platenlabel';

  @override
  String get sponsorFlavourGlitterbox =>
      'Bij elk doelpunt hoort nu een dansje.';

  @override
  String get sponsorBrandMilkwell => 'Milkwell Zuivel';

  @override
  String get sponsorIndustryMilkwell => 'Zuivel';

  @override
  String get sponsorFlavourMilkwell =>
      'IJskoude melk en schoolreisjes naar de koeien.';

  @override
  String get sponsorBrandHerringKing => 'De Haringkoning';

  @override
  String get sponsorIndustryHerringKing => 'Ingelegde haring';

  @override
  String get sponsorFlavourHerringKing =>
      'Ingelegd, gerookt of in een pot, al sinds de tijd van opa.';

  @override
  String get sponsorBrandUmbrello => 'Umbrello Verzekeringen';

  @override
  String get sponsorIndustryUmbrello => 'Verzekeringen';

  @override
  String get sponsorFlavourUmbrello =>
      'Verzekert alles, zelfs de paraplu van je paraplu.';

  @override
  String get sponsorBrandTidyTeeth => 'Schone Tandjes';

  @override
  String get sponsorIndustryTidyTeeth => 'Tandpasta';

  @override
  String get sponsorFlavourTidyTeeth =>
      'Negen van de tien tandartsen. De tiende is op vakantie.';

  @override
  String get sponsorBrandWoollySocks => 'Wollen Sokken';

  @override
  String get sponsorIndustryWoollySocks => 'Breigoed';

  @override
  String get sponsorFlavourWoollySocks =>
      'Handgebreide sokken voor elke speler, in alle kleuren behalve die van het team.';

  @override
  String get sponsorBrandStackabloc => 'Stackabloc';

  @override
  String get sponsorIndustryStackabloc => 'Speelgoed';

  @override
  String get sponsorFlavourStackabloc =>
      'Bouw je eigen nationale stadion. Vierduizend stukjes, er ontbreekt er één.';

  @override
  String get sponsorBrandPolarPenguin => 'Poolpinguïn';

  @override
  String get sponsorIndustryPolarPenguin => 'IJs';

  @override
  String get sponsorFlavourPolarPenguin =>
      'Dertig smaken, allemaal aan het smelten.';

  @override
  String get sponsorBrandHexagon => 'Hexagon';

  @override
  String get sponsorIndustryHexagon => 'Machinebouw';

  @override
  String get sponsorFlavourHexagon =>
      'Elk probleem heeft zes kanten. Hun ingenieurs zijn nog aan het tellen.';

  @override
  String get sponsorBrandVelocell => 'Velocell';

  @override
  String get sponsorIndustryVelocell => 'Telecom';

  @override
  String get sponsorFlavourVelocell =>
      'Overal volle dekking, behalve in het stadion.';

  @override
  String get sponsorBrandParcelion => 'Parcelion';

  @override
  String get sponsorIndustryParcelion => 'Pakketbezorging';

  @override
  String get sponsorFlavourParcelion =>
      'Morgen bezorgd. Of overmorgen. Of bij de buren.';

  @override
  String get sponsorBrandGridwell => 'Gridwell Energy';

  @override
  String get sponsorIndustryGridwell => 'Energie';

  @override
  String get sponsorFlavourGridwell => 'Houdt de lichtmasten aan. Meestal.';

  @override
  String get sponsorBrandCrownstone => 'Crownstone Bank';

  @override
  String get sponsorIndustryCrownstone => 'Bankwezen';

  @override
  String get sponsorFlavourCrownstone =>
      'Je geld is veilig bij ons. Waarschijnlijk.';

  @override
  String get sponsorBrandClickbait => 'Klikaas Media';

  @override
  String get sponsorIndustryClickbait => 'Mediagroep';

  @override
  String get sponsorFlavourClickbait =>
      'Je gelooft nooit wat er in onze vierde kop staat.';

  @override
  String get sponsorDealLineRisky =>
      'Veel geld en geen vragen. Het bestuur heeft er straks genoeg.';

  @override
  String get sponsorDealLineBigPayer =>
      'Een royale cheque van een naam die het bestuur liever niet noemt.';

  @override
  String get sponsorDealLineCrowdPleaser =>
      'Een leuk merk waar de spelers dol op zijn en dat het bestuur wat overdreven vindt.';

  @override
  String get sponsorDealLineFamilyFriendly =>
      'Een brave naam waar het bestuur dol op is en waar de spelers van gapen.';

  @override
  String get sponsorDealLineMarketing =>
      'Geen geld, alleen campagnes: posters, fotoshoots en veel glimlachen.';

  @override
  String ySponsorDubious0(String brand) {
    return '$brand is de nieuwe hoofdsponsor van de bond. Lach maar, de jeugdopleiding kan het geld nog steeds goed gebruiken.';
  }

  @override
  String ySponsorDubious1(String brand) {
    return 'De bond heeft $brand vastgelegd als nieuwe hoofdsponsor. Het zou het hoogste bod op tafel zijn geweest.';
  }

  @override
  String ySponsorDubious2(String brand) {
    return '$brand. Onze nieuwe hoofdsponsor is $brand. Ik moet even gaan liggen.';
  }

  @override
  String ySponsorMocked0(String brand) {
    return 'Geld is geld. Als $brand nieuwe velden betaalt, draag ik dat shirt met trots.';
  }

  @override
  String ySponsorMocked1(String brand) {
    return 'Zeg wat je wilt over $brand, hun cheque is gedekt.';
  }

  @override
  String ySponsorMocked2(String brand) {
    return 'Ergens is een marketingteam heel trots op dat $brand-logo op onze borst.';
  }

  @override
  String ySponsorMocked3(String brand) {
    return 'Dus we zijn nu het nationale team van $brand. Genoteerd.';
  }

  @override
  String ySponsorMocked4(String brand) {
    return 'Stel je voor: het shirt verkopen aan $brand. Stel het je even voor.';
  }

  @override
  String ySponsorMocked5(String brand) {
    return 'Van alle sponsors ter wereld kiezen wij $brand. Al onze rivalen lachen ons uit.';
  }

  @override
  String get matchTinyWorld => 'WK';

  @override
  String matchTinyQualifying(String comp) {
    return '$comp-kwal.';
  }

  @override
  String get matchTinyEurope => 'EK';

  @override
  String get matchTinySouthAmerica => 'ZAB';

  @override
  String get matchTinyNorthAmerica => 'NAB';

  @override
  String get matchTinyAfrica => 'AfK';

  @override
  String get matchTinyAsia => 'AzK';

  @override
  String get matchTinyOceania => 'OB';

  @override
  String get matchTinyNationsCup => 'NC';

  @override
  String get matchTinyFriendly => 'oefen';

  @override
  String get matchTinyClash => 'Clash';

  @override
  String get matchTinyPlayoff => 'PO';

  @override
  String matchTinyMatchday(int matchday) {
    return 'SD $matchday';
  }

  @override
  String get matchTinyRoundOf32 => '1/16';

  @override
  String get matchTinyRoundOf16 => '1/8';

  @override
  String get matchTinyQuarterFinal => 'KF';

  @override
  String get matchTinySemiFinal => 'HF';

  @override
  String get matchTinyFinal => 'finale';

  @override
  String get matchTinyThirdPlace => '3e pl.';

  @override
  String get callUpHomeShort => 'T';

  @override
  String get callUpAwayShort => 'U';

  @override
  String get homeEditor => 'Editor';

  @override
  String get homeNewGameBlurb => 'Kies je land en begin een carrière';

  @override
  String homeCampaignCycleOnly(int cycle, int total) {
    return 'Cyclus $cycle van $total';
  }

  @override
  String get editorTitle => 'Editor';

  @override
  String get editorIntro =>
      'Maak je eigen startwereld: je spelers, hun cijfers, je namen. Deel hem als bestand; vrienden kunnen hem importeren en er een loopbaan op beginnen.';

  @override
  String get editorEmptyTitle => 'Nog geen databases';

  @override
  String get editorEmptyBody =>
      'Een nieuwe database begint als kopie van de standaardwereld. Verander wat je wilt; alles wordt meteen opgeslagen.';

  @override
  String get editorNew => 'Nieuwe database';

  @override
  String get editorImport => 'Importeren';

  @override
  String get editorEdit => 'Bewerken';

  @override
  String get editorRename => 'Hernoemen';

  @override
  String get editorDuplicate => 'Dupliceren';

  @override
  String get editorExport => 'Exporteren';

  @override
  String get editorDelete => 'Verwijderen';

  @override
  String get editorCancel => 'Annuleren';

  @override
  String get editorCreate => 'Maken';

  @override
  String get editorMore => 'Meer acties';

  @override
  String get editorNameLabel => 'Naam';

  @override
  String get editorNameHint => 'Mijn wereld';

  @override
  String get editorRenameTitle => 'Database hernoemen';

  @override
  String get editorDuplicateTitle => 'Database dupliceren';

  @override
  String editorCopyName(String name) {
    return '$name (kopie)';
  }

  @override
  String get editorNameEmpty => 'Geef hem een naam';

  @override
  String editorNameTooLong(int max) {
    return 'Maximaal $max tekens';
  }

  @override
  String get editorNameBadCharacters => 'Die naam bevat tekens die niet kunnen';

  @override
  String get editorDeleteTitle => 'Database verwijderen?';

  @override
  String editorDeleteBody(String name) {
    return '\"$name\" wordt van dit apparaat verwijderd. Loopbanen die er al op gestart zijn, blijven werken.';
  }

  @override
  String get editorStatusReady => 'Klaar';

  @override
  String editorStatusMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dingen ontbreken',
      one: '1 ding ontbreekt',
    );
    return '$_temp0';
  }

  @override
  String get editorStatusAttention => 'Vraagt aandacht';

  @override
  String get editorStatusUnreadable => 'Kan niet open';

  @override
  String editorEdited(String date) {
    return 'Bewerkt $date';
  }

  @override
  String get editorCreating => 'Standaardwereld kopiëren…';

  @override
  String get editorImported => 'Database geïmporteerd';

  @override
  String get editorImportOpen => 'Openen';

  @override
  String get editorImportTooBig => 'Dat bestand is te groot voor een database.';

  @override
  String get editorImportNotAPack => 'Dat bestand is geen FNM-database.';

  @override
  String get editorImportNewer =>
      'Die database is gemaakt met een nieuwere versie van het spel. Update het spel om hem te importeren.';

  @override
  String get editorImportBadData =>
      'Die database bevat gegevens die het spel niet kan gebruiken, dus er is niets geïmporteerd.';

  @override
  String get editorImportBadTrophy =>
      'Een trofeeafbeelding in dat bestand kon niet worden gelezen, dus er is niets geïmporteerd.';

  @override
  String get editorExportFailed => 'De database kon niet worden geëxporteerd.';

  @override
  String editorExportTooBig(String size, String limit) {
    return 'Deze database is te groot om te delen: het bestand zou $size MB worden en de limiet is $limit MB. Leg minder pools vast of verwijder enkele trofeeafbeeldingen en probeer het opnieuw.';
  }

  @override
  String editorRemoveAllLike(int count) {
    return 'Alle verwijderen ($count)';
  }

  @override
  String get editorNotesTitle => 'Andere talen';

  @override
  String editorUnknownLanguageNote(String language, int count) {
    return 'Namen in \"$language\", een taal die deze versie niet toont: $count. Ze blijven bewaard voor versies die de taal wel kennen.';
  }

  @override
  String get editorShareSubject => 'FNM-database';

  @override
  String get editorPackMissing =>
      'Deze database staat niet meer op dit apparaat.';

  @override
  String get editorReadyTitle => 'Klaar om te spelen';

  @override
  String get editorReadyBody =>
      'Elk land heeft een volledige selectie en alle namen kloppen. Je kunt er een loopbaan op beginnen.';

  @override
  String editorNotReadyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dingen oplossen voordat je kunt spelen',
      one: '1 ding oplossen voordat je kunt spelen',
    );
    return '$_temp0';
  }

  @override
  String get editorNotReadyBody =>
      'Alles wordt meteen opgeslagen, dus je kunt hem nu al delen en later afmaken.';

  @override
  String editorSectionsReady(int ready, int total) {
    return '$ready van $total onderdelen klaar';
  }

  @override
  String get editorMissingTitle => 'Wat ontbreekt';

  @override
  String editorShowAll(int count) {
    return 'Alles tonen ($count)';
  }

  @override
  String get editorShowLess => 'Minder tonen';

  @override
  String get editorUndo => 'Ongedaan maken';

  @override
  String get editorSectionsTitle => 'Onderdelen';

  @override
  String get editorSectionPlayers => 'Spelers';

  @override
  String get editorSectionNations => 'Landen';

  @override
  String get editorSectionClubs => 'Clubs';

  @override
  String get editorSectionStadiums => 'Stadions';

  @override
  String get editorSectionCompetitions => 'Competities';

  @override
  String get editorSectionY => 'Y-accounts';

  @override
  String get editorSectionPress => 'Pers';

  @override
  String get editorSectionNameLists => 'Namenlijsten';

  @override
  String get editorSectionSponsors => 'Sponsors';

  @override
  String get editorSectionTrophies => 'Trofeeën';

  @override
  String get editorAboutPlayers => 'Selecties, cijfers en potentieel';

  @override
  String get editorAboutNations => 'Namen en codes van landen';

  @override
  String get editorAboutClubs => 'Clubnamen';

  @override
  String get editorAboutStadiums => 'Namen van nationale stadions';

  @override
  String get editorAboutCompetitions => 'Namen van competities';

  @override
  String get editorAboutY => 'Accounts op Y';

  @override
  String get editorAboutPress => 'Journalisten en hun media';

  @override
  String get editorAboutNameLists =>
      'Namen voor nieuwe spelers, lokale fans en staf';

  @override
  String get editorAboutSponsors => 'Merken van sponsors';

  @override
  String get editorAboutTrophies => 'Afbeeldingen van trofeeën';

  @override
  String editorCountPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelers',
      one: '1 speler',
    );
    return '$_temp0';
  }

  @override
  String editorCountNations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count landen',
      one: '1 land',
    );
    return '$_temp0';
  }

  @override
  String editorCountChanged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wijzigingen',
      one: '1 wijziging',
      zero: 'Namen van het spel',
    );
    return '$_temp0';
  }

  @override
  String editorCountTrophies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eigen afbeeldingen',
      one: '1 eigen afbeelding',
      zero: 'Afbeeldingen van het spel',
    );
    return '$_temp0';
  }

  @override
  String editorCountToFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count op te lossen',
      one: '1 op te lossen',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nog $count spelers nodig',
      one: 'Nog 1 speler nodig',
    );
    return '$_temp0';
  }

  @override
  String editorIssuePlayersOver(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spelers te veel',
      one: '1 speler te veel',
    );
    return '$_temp0';
  }

  @override
  String editorIssueGoalkeepers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count keepers nodig',
      one: '1 keeper nodig',
    );
    return '$_temp0';
  }

  @override
  String editorIssueDefenders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verdedigers nodig',
      one: '1 verdediger nodig',
    );
    return '$_temp0';
  }

  @override
  String editorIssueMidfielders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count middenvelders nodig',
      one: '1 middenvelder nodig',
    );
    return '$_temp0';
  }

  @override
  String editorIssueForwards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aanvallers nodig',
      one: '1 aanvaller nodig',
    );
    return '$_temp0';
  }

  @override
  String get editorIssuePlayerNoName => 'Een speler heeft geen naam';

  @override
  String editorIssueAge(String name) {
    return '$name: leeftijd moet 15 tot 45 zijn';
  }

  @override
  String editorIssueRating(String name) {
    return '$name: totaalcijfer moet 1 tot 99 zijn';
  }

  @override
  String editorIssuePotential(String name) {
    return '$name: potentieel moet tussen het totaalcijfer en 99 liggen';
  }

  @override
  String editorIssueRenameEmpty(String name) {
    return 'De nieuwe naam voor $name is leeg';
  }

  @override
  String get editorIssueNameEmpty => 'Een naam is leeg';

  @override
  String editorIssueNameTooLong(String name) {
    return '\"$name\" is te lang';
  }

  @override
  String editorIssueNameBadCharacters(String name) {
    return '\"$name\" bevat tekens die niet kunnen';
  }

  @override
  String editorIssueNameTaken(String name) {
    return '\"$name\" is al bezet';
  }

  @override
  String get editorIssueCode => 'De code moet 3 letters zijn, A tot Z';

  @override
  String editorIssueDuplicateCode(String code, String nations) {
    return 'Code $code wordt gebruikt door $nations';
  }

  @override
  String editorIssueFirstNames(int count) {
    return 'Minstens $count voornamen nodig';
  }

  @override
  String editorIssueSurnames(int count) {
    return 'Minstens $count achternamen nodig';
  }

  @override
  String get editorIssueValue => 'Een waarde valt buiten het bereik';

  @override
  String get editorIssueUnknown =>
      'Verwijst naar iets dat niet meer in het spel zit';

  @override
  String get editorSectionSoon => 'Dit onderdeel bewerken komt binnenkort.';

  @override
  String get editorNewFailed =>
      'De database kon niet worden gemaakt. Probeer het opnieuw.';

  @override
  String get editorPickFailed => 'Het bestand kon niet worden geopend.';

  @override
  String get editorRenameFailed => 'De database kon niet worden hernoemd.';

  @override
  String get editorDuplicateFailed => 'De database kon niet worden gekopieerd.';

  @override
  String get editorNationsSearch => 'Zoek landen';

  @override
  String get editorFilterAll => 'Alle';

  @override
  String get editorNationsNone => 'Geen land past bij je zoekopdracht.';

  @override
  String get editorNationSquadReady => 'Selectie klaar';

  @override
  String get editorSquadAdd => 'Speler toevoegen';

  @override
  String editorSquadFull(int max) {
    return 'Een selectie telt hoogstens $max spelers.';
  }

  @override
  String editorSquadRemoved(String name) {
    return '$name uit de selectie gehaald';
  }

  @override
  String get editorPlayerUnnamed => 'Naamloze speler';

  @override
  String get editorSquadDuplicate =>
      'Een andere speler in deze selectie heeft deze naam.';

  @override
  String get editorSquadEmpty => 'Nog geen spelers. Voeg de eerste toe.';

  @override
  String get editorSquadReady => 'Deze selectie is klaar om te spelen.';

  @override
  String editorSquadRules(int min, int max, int gk, int def, int mid, int fwd) {
    return '$min tot $max spelers, met minstens $gk keepers, $def verdedigers, $mid middenvelders en $fwd aanvallers.';
  }

  @override
  String get editorShortGk => 'KEE';

  @override
  String get editorShortDef => 'VER';

  @override
  String get editorShortMid => 'MID';

  @override
  String get editorShortFwd => 'AAN';

  @override
  String editorPlayerAgeShort(int age) {
    return 'Leeftijd $age';
  }

  @override
  String get editorPlayerName => 'Naam';

  @override
  String get editorPlayerNameHint => 'Typ zijn naam';

  @override
  String get editorPlayerNameNeeded => 'Een naam is nodig.';

  @override
  String get editorPlayerNameBad => 'Haal de vreemde tekens weg.';

  @override
  String get editorPlayerAge => 'Leeftijd';

  @override
  String get editorPlayerPosition => 'Positie';

  @override
  String get editorPlayerClub => 'Club';

  @override
  String get editorPlayerFreeAgent => 'Transfervrij';

  @override
  String get editorPlayerClubSearch => 'Zoek clubs';

  @override
  String get editorPlayerClubNone => 'Geen club past bij je zoekopdracht.';

  @override
  String get editorPlayerClubPick => 'Kies een club';

  @override
  String get editorPlayerOverall => 'Totaalcijfer';

  @override
  String get editorPlayerType => 'Spelerstype';

  @override
  String get editorPlayerPotential => 'Potentieel';

  @override
  String get editorPlayerPotentialAbout =>
      'Het hoogste niveau dat hij kan halen als hij zich goed ontwikkelt. Nooit lager dan zijn totaalcijfer.';

  @override
  String get editorPlayerQualities => 'Wat het spel opslaat';

  @override
  String get editorTypeBalanced => 'Allround';

  @override
  String get editorTypeAthlete => 'Atleet';

  @override
  String get editorTypeTechnician => 'Technicus';

  @override
  String get editorTypeEngine => 'Motor';

  @override
  String get editorTypeBalancedAbout =>
      'Gelijk verdeeld over fysiek, techniek en uithouding.';

  @override
  String get editorTypeAthleteAbout => 'Sterk en snel, iets minder technisch.';

  @override
  String get editorTypeTechnicianAbout => 'Vaardig aan de bal, minder fysiek.';

  @override
  String get editorTypeEngineAbout =>
      'Loopt de hele wedstrijd, degelijk in de rest.';

  @override
  String get editorPlayerLess => 'Eén minder';

  @override
  String get editorPlayerMore => 'Eén meer';

  @override
  String get editorPlayerRemove => 'Uit selectie halen';

  @override
  String get editorPlayerGone => 'Deze speler zit niet meer in de selectie.';

  @override
  String get editorNationGone => 'Dit land staat niet in de database.';

  @override
  String get editorPickPlayer => 'Kies een speler om te bewerken.';

  @override
  String get editorPlayerClubAuto => 'Kiest het spel';

  @override
  String get editorPlayerClubAutoAbout =>
      'Het spel plaatst hem bij een club die bij zijn niveau past.';

  @override
  String get editorNamesSearch => 'Zoek namen';

  @override
  String get editorNamesSearchClubs => 'Zoek clubs of landen';

  @override
  String get editorNamesSearchStadiums => 'Zoek stadions, steden of landen';

  @override
  String get editorNamesSearchNations => 'Zoek landen of codes';

  @override
  String get editorNamesNone => 'Niets past bij je zoekopdracht.';

  @override
  String get editorNamesEveryLanguage =>
      'Een eigen naam staat in elke taal, tenzij je een taal een eigen naam geeft.';

  @override
  String editorNamesGameName(String name) {
    return 'Naam in het spel: $name';
  }

  @override
  String get editorNamesReset => 'Origineel herstellen';

  @override
  String get editorNamesDone => 'Klaar';

  @override
  String get editorNamesKeepHint => 'Laat leeg om de spelnaam te houden.';

  @override
  String get editorNamesCode => 'Code';

  @override
  String get editorNamesCodeHelp =>
      '3 letters, A tot Z, door geen ander land gebruikt.';

  @override
  String editorNamesCodeTaken(String code, String nation) {
    return '$code wordt al gebruikt door $nation.';
  }

  @override
  String get editorNamesTaken => 'Een ander account heeft deze naam al.';

  @override
  String get editorLanguageTitle => 'Taal van de namen';

  @override
  String get editorLanguageAll => 'Alle talen';

  @override
  String get editorLanguageAllShort => 'Alle';

  @override
  String get editorLanguageNote =>
      'Alleen de editor schakelt om. Het spel blijft in zijn eigen taal.';

  @override
  String editorLanguageEditing(String language) {
    return 'Namen voor $language. Laat er een leeg om de hoofdnaam te gebruiken.';
  }

  @override
  String get editorLanguageSame => 'Gelijk in alle talen';

  @override
  String editorLanguageMainName(String name) {
    return 'Hoofdnaam: $name';
  }

  @override
  String get editorLanguageKeepHint =>
      'Laat leeg om de hoofdnaam te gebruiken.';

  @override
  String get editorLanguageClear => 'Hoofdnaam gebruiken';

  @override
  String get editorLanguageFull =>
      'Deze database heeft geen ruimte meer voor namen per taal.';

  @override
  String get editorPlayerDelete => 'Speler verwijderen';

  @override
  String get editorPlayerAdvanced => 'Geavanceerd';

  @override
  String get editorPlayerAdvancedAbout =>
      'Stel zijn fysiek, techniek en uithoudingsvermogen apart in.';

  @override
  String get editorPlayerAdvancedOverall => 'Totaalcijfer hieruit';

  @override
  String get editorPlayerTraits => 'Bekend om';

  @override
  String get editorPlayerTraitsRandom => 'Willekeurig';

  @override
  String get editorPlayerTraitsRandomAbout =>
      'Elke loopbaan loot zijn kenmerken, zoals altijd.';

  @override
  String get editorPlayerTraitsNone => 'Geen kenmerken, in elke loopbaan.';

  @override
  String editorPlayerTraitsPicked(int max) {
    return 'Deze kenmerken in elke loopbaan. Kies er maximaal $max.';
  }

  @override
  String editorPlayerTraitsMax(int max) {
    return 'Een speler heeft maximaal $max kenmerken. Haal er eerst een weg.';
  }

  @override
  String editorPlayerTraitUnknown(String trait) {
    return '$trait (onbekend in deze versie)';
  }

  @override
  String editorIssueInLanguage(String issue, String language) {
    return '$issue ($language)';
  }

  @override
  String get editorTabSquad => 'Selectie';

  @override
  String get editorTabPool => 'Pool';

  @override
  String get editorPoolGenerated => 'Gemaakt door het spel';

  @override
  String get editorPoolGeneratedAbout =>
      'Elke loopbaan loot deze pool opnieuw, zoals altijd. Je eerste wijziging legt hem precies vast zoals hij hier staat, in elke loopbaan.';

  @override
  String get editorPoolFixed => 'Jouw pool';

  @override
  String get editorPoolFixedAbout =>
      'Elke loopbaan begint met precies deze spelers.';

  @override
  String get editorPoolReset => 'Terug naar het spel';

  @override
  String get editorPoolResetTitle => 'Terug naar de pool van het spel?';

  @override
  String get editorPoolResetBody =>
      'Je wijzigingen aan deze pool vervallen en elke loopbaan maakt hem weer opnieuw.';

  @override
  String editorPoolMax(int max) {
    return 'Maximaal $max';
  }

  @override
  String editorPoolFull(int max) {
    return 'Een pool telt hoogstens $max spelers.';
  }

  @override
  String editorPoolRemoved(String name) {
    return '$name uit de pool gehaald';
  }

  @override
  String get editorPoolRemove => 'Uit pool halen';

  @override
  String get editorPoolPlayerGone => 'Deze speler zit niet meer in de pool.';

  @override
  String get editorPoolDuplicate =>
      'Een andere speler in deze pool heeft deze naam.';

  @override
  String get editorPoolEmpty =>
      'Geen spelers in deze pool. Voeg de eerste toe.';

  @override
  String get editorPoolLoadFailed =>
      'De pool van het spel kon niet worden gelezen.';

  @override
  String editorPlayerTraitsUnknownDropped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count onbekende kenmerken verwijderd',
      one: '1 onbekend kenmerk verwijderd',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedTag => 'Toegevoegd';

  @override
  String get editorAddedGroup => 'Toegevoegd';

  @override
  String get editorAddedGameGroup => 'In het spel';

  @override
  String get editorAddClub => 'Club toevoegen';

  @override
  String get editorAddSponsor => 'Sponsor toevoegen';

  @override
  String get editorAddY => 'Account toevoegen';

  @override
  String get editorAddedAdd => 'Toevoegen';

  @override
  String get editorAddedDelete => 'Verwijderen';

  @override
  String editorAddedRemoved(String name) {
    return '$name verwijderd';
  }

  @override
  String editorAddedClubsFull(int max) {
    return 'Een database kan maximaal $max clubs toevoegen.';
  }

  @override
  String editorAddedSponsorsFull(int max) {
    return 'Een database kan maximaal $max sponsors toevoegen.';
  }

  @override
  String editorAddedYFull(int max) {
    return 'Een database kan maximaal $max accounts toevoegen.';
  }

  @override
  String get editorAddedGone => 'Dit staat niet meer in de database.';

  @override
  String get editorAddedNameNeeded => 'Geef het een naam';

  @override
  String get editorAddedCountry => 'Land';

  @override
  String get editorAddedCountryPick => 'Kies een land';

  @override
  String editorAddedNoLeague(String country) {
    return '$country heeft geen competitie of steden in het spel, dus deze club krijgt alleen de spelers die jij er plaatst.';
  }

  @override
  String editorAddedClubTaken(String country) {
    return '$country heeft al een club met deze naam.';
  }

  @override
  String get editorAddedClubGameName =>
      'Een club in het spel heeft deze naam al.';

  @override
  String editorAddedClubPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count spelers uit deze database spelen hier. Verwijder je de club, dan plaatst het spel hen elders.',
      one:
          '1 speler uit deze database speelt hier. Verwijder je de club, dan plaatst het spel hem elders.',
    );
    return '$_temp0';
  }

  @override
  String get editorAddedDeal => 'Soort deal';

  @override
  String get editorDealBigPayer => 'Grote betaler';

  @override
  String get editorDealCrowdPleaser => 'Spelersfavoriet';

  @override
  String get editorDealFamilyFriendly => 'Gezinsvriendelijk';

  @override
  String get editorDealMarketing => 'Marketing';

  @override
  String get editorAddedIndustry => 'Sector';

  @override
  String get editorAddedIndustryPick => 'Kies een sector';

  @override
  String get editorAddedDescription => 'Beschrijving (optioneel)';

  @override
  String get editorAddedDescriptionHelp =>
      'Blijft die leeg, dan gebruikt het aanbod de vaste zin van de soort deal.';

  @override
  String get editorAddedVoice => 'Soort account';

  @override
  String get editorYVoiceFan => 'Fan';

  @override
  String get editorYVoicePundit => 'Analist';

  @override
  String get editorYVoiceMeme => 'Memes';

  @override
  String get editorYVoiceStats => 'Stats';

  @override
  String get editorYVoiceRival => 'Rivaal';

  @override
  String get editorYVoiceExpro => 'Ex-prof';

  @override
  String get editorYVoiceNeutral => 'Neutraal';

  @override
  String get editorYVoiceFanAbout =>
      'Een van je eigen supporters. Dolblij, woedend, wispelturig.';

  @override
  String get editorYVoicePunditAbout =>
      'Een bedaarde stem die een hele loopbaan lang opduikt.';

  @override
  String get editorYVoiceMemeAbout =>
      'Zegt niets nuttigs en wordt als eerste gelezen.';

  @override
  String get editorYVoiceStatsAbout => 'Post cijfers en verder niets.';

  @override
  String get editorYVoiceRivalAbout => 'Geniet van jouw pech.';

  @override
  String get editorYVoiceExproAbout =>
      'Een oud-international met een column en geen geduld.';

  @override
  String get editorYVoiceNeutralAbout =>
      'Kijkt al het voetbal en duikt alleen op als er iets groots gebeurt.';

  @override
  String get editorAddedPostsIn => 'Post in';

  @override
  String get editorAddedAllNations => 'Alle landen';

  @override
  String get editorAddedSearch => 'Zoeken';

  @override
  String editorCountAdded(int count) {
    return '$count toegevoegd';
  }

  @override
  String get editorNamesOutlet => 'Medium';

  @override
  String get editorNamesFirstNames => 'Voornamen';

  @override
  String get editorNamesSurnames => 'Achternamen';

  @override
  String editorNamesFirstCount(int count, int min) {
    return '$count / $min voornamen';
  }

  @override
  String editorNamesSurCount(int count, int min) {
    return '$count / $min achternamen';
  }

  @override
  String editorNamesListsHelp(int min) {
    return 'Scheid de namen met komma\'s of nieuwe regels. Elke lijst heeft er minstens $min nodig. Ze geven namen aan nieuwe spelers, lokale fans en staf.';
  }

  @override
  String editorNamesListCounts(int first, int sur) {
    return '$first voornamen, $sur achternamen';
  }

  @override
  String editorNamesMainStadium(String city) {
    return 'Hoofdstadion in $city';
  }

  @override
  String get editorNamesChanged => 'Gewijzigd';

  @override
  String get editorNamesPick => 'Kies een naam om te bewerken.';

  @override
  String get editorNamesStadiumsNote =>
      'Alleen de nationale stadions in deze lijst kun je hernoemen: het hoofdstadion van elke stad.';

  @override
  String get editorTrophiesIntro =>
      'Tik op een trofee om hem je eigen afbeelding te geven. Een PNG met transparante achtergrond ziet er het best uit.';

  @override
  String get editorTrophyCustom => 'Eigen';

  @override
  String get editorTrophyDefault => 'Van het spel';

  @override
  String get editorTrophyChoose => 'Kies een afbeelding';

  @override
  String get editorTrophyReplace => 'Kies een andere afbeelding';

  @override
  String get editorTrophyReset => 'Terug naar standaard';

  @override
  String get editorTrophyResetTitle => 'Afbeelding van het spel gebruiken?';

  @override
  String get editorTrophyResetBody =>
      'Je afbeelding voor deze trofee wordt verwijderd. Ongedaan maken kan hem niet terughalen.';

  @override
  String get editorTrophyResetConfirm => 'Afbeelding verwijderen';

  @override
  String get editorTrophyUnusable =>
      'Deze afbeelding is niet bruikbaar. Kies een PNG of JPEG van maximaal 4096 pixels per zijde.';

  @override
  String get editorTrophyOpening => 'Afbeelding openen';

  @override
  String get editorTrophyPreparing => 'Trofee voorbereiden';

  @override
  String get editorTrophyFrameTitle => 'Trofee kaderen';

  @override
  String get editorTrophyFrameHint =>
      'Sleep om te verplaatsen en knijp om te zoomen. Wat binnen het kader valt, wordt de trofee.';

  @override
  String get editorTrophyFit => 'Passend';

  @override
  String get editorTrophyPreview => 'Voorbeeld';

  @override
  String get editorTrophyPreviewTitle => 'Zo ziet het eruit';

  @override
  String get editorTrophyAdjust => 'Bijstellen';

  @override
  String get editorTrophyUse => 'Deze afbeelding gebruiken';

  @override
  String get editorTrophyRectangle =>
      'Deze afbeelding heeft geen transparante achtergrond, dus het spel toont hem als rechthoek.';

  @override
  String get editorTrophyRectangleShort => 'Toont als rechthoek';

  @override
  String get editorTrophySaved => 'Trofeeafbeelding opgeslagen.';

  @override
  String get editorTrophyRemoved => 'De afbeelding van het spel is terug.';

  @override
  String get editorTrophySaveFailed =>
      'De afbeelding kon niet worden opgeslagen. Probeer het opnieuw.';

  @override
  String get editorSaveFailed =>
      'Je laatste wijzigingen konden niet worden opgeslagen. We proberen het opnieuw.';

  @override
  String get editorTrophyPick =>
      'Kies een trofee om de afbeelding te wijzigen.';

  @override
  String editorTrophySize(int width, int height) {
    return 'Opgeslagen op $width x $height pixels';
  }

  @override
  String editorIssueUnknownEntry(String name) {
    return '$name zit niet meer in het spel';
  }

  @override
  String get editorAttentionBody =>
      'Iets in deze database past niet bij deze versie van het spel: een naamconflict, of iets wat een update van het spel heeft verwijderd. Herstel of verwijder elk item hieronder en hij kan weer een loopbaan starten.';

  @override
  String get editorRemove => 'Verwijderen';

  @override
  String worldChip(String name) {
    return 'Wereld: $name';
  }

  @override
  String get worldDefault => 'Standaard';

  @override
  String get worldDefaultAbout => 'De eigen wereld van het spel';

  @override
  String get worldSheetTitle => 'Kies een wereld';

  @override
  String get worldSheetBlurb =>
      'Databases die je in de Editor hebt gemaakt of geopend. Alleen complete databases kunnen een loopbaan starten.';

  @override
  String get worldPackGone =>
      'Die database staat niet meer op dit apparaat. De loopbaan is niet gestart.';

  @override
  String get worldStarting => 'Je wereld wordt klaargezet';

  @override
  String get settingsDefaultWorldTitle => 'Standaardwereld';

  @override
  String get settingsDefaultWorldBlurb =>
      'De wereld waarmee Nieuw spel start. Je kunt hem per loopbaan nog wijzigen.';

  @override
  String get worldPackNotReady =>
      'Die database kan geen loopbaan meer starten. Los het op in de Editor of kies een andere wereld.';

  @override
  String pitchComShotGoal1(String player) {
    return 'DOELPUNT! $player vindt het net!';
  }

  @override
  String pitchComShotGoal2(String player) {
    return '$player schiet hem erin! DOELPUNT!';
  }

  @override
  String pitchComShotGoal3(String player) {
    return 'DOELPUNT! Koele afwerking van $player.';
  }

  @override
  String pitchComShotSaved1(String player, String keeper) {
    return '$player schiet, maar $keeper houdt hem tegen.';
  }

  @override
  String pitchComShotSaved2(String player) {
    return '$player waagt een poging, maar de keeper is er snel bij.';
  }

  @override
  String pitchComShotSaved3(String player, String keeper) {
    return '$player haalt uit, $keeper tikt hem weg!';
  }

  @override
  String pitchComShotWide1(String player) {
    return '$player schiet naast.';
  }

  @override
  String pitchComShotWide2(String player) {
    return 'Naast het doel door $player.';
  }

  @override
  String pitchComShotWide3(String player) {
    return '$player schiet net langs de paal.';
  }

  @override
  String pitchComShotBlocked1(String player) {
    return '$player schiet, maar het schot wordt geblokt.';
  }

  @override
  String pitchComShotBlocked2(String player) {
    return 'Geblokt! $player vindt geen opening.';
  }

  @override
  String pitchComShotBlocked3(String player) {
    return '$player haalt uit, maar een verdediger gooit zich ertussen.';
  }

  @override
  String pitchComShotWoodwork1(String player) {
    return 'Paal! $player heeft pech.';
  }

  @override
  String pitchComShotWoodwork2(String player) {
    return '$player raakt het houtwerk!';
  }

  @override
  String pitchComShotWoodwork3(String player) {
    return 'Lat! $player strandt op de lat.';
  }

  @override
  String pitchComHeaderGoal1(String player) {
    return 'DOELPUNT! $player kopt hem erin!';
  }

  @override
  String pitchComHeaderGoal2(String player) {
    return '$player stijgt het hoogst op en scoort! DOELPUNT!';
  }

  @override
  String pitchComHeaderGoal3(String player) {
    return 'DOELPUNT! Krachtige kopbal van $player.';
  }

  @override
  String pitchComHeaderSaved1(String player, String keeper) {
    return '$player kopt, $keeper houdt hem tegen.';
  }

  @override
  String pitchComHeaderSaved2(String player) {
    return 'Kopbal van $player, maar de keeper heeft hem.';
  }

  @override
  String pitchComHeaderSaved3(String player, String keeper) {
    return 'Kopbal van $player, $keeper tikt hem weg.';
  }

  @override
  String pitchComHeaderWide1(String player) {
    return '$player kopt naast.';
  }

  @override
  String pitchComHeaderWide2(String player) {
    return 'Kopbal van $player, maar naast het doel.';
  }

  @override
  String pitchComHeaderWide3(String player) {
    return '$player krijgt de kopbal niet naar beneden.';
  }

  @override
  String pitchComHeaderBlocked1(String player) {
    return '$player kopt, maar het wordt geblokt.';
  }

  @override
  String pitchComHeaderBlocked2(String player) {
    return '$player kopt op doel, maar de defensie blokkeert.';
  }

  @override
  String pitchComHeaderBlocked3(String player) {
    return 'Geblokt! $player komt bij de bal, maar er staat een verdediger.';
  }

  @override
  String pitchComHeaderWoodwork1(String player) {
    return '$player kopt tegen de lat!';
  }

  @override
  String pitchComHeaderWoodwork2(String player) {
    return 'Paal! De kopbal van $player komt terug in het veld.';
  }

  @override
  String pitchComHeaderWoodwork3(String player) {
    return 'Houtwerk! $player laat het doel trillen met een kopbal.';
  }

  @override
  String pitchComSetPieceGoal1(String player) {
    return 'DOELPUNT! $player is erbij aan het eind van de aanval!';
  }

  @override
  String pitchComSetPieceGoal2(String player, String other) {
    return 'DOELPUNT! $other geeft voor en $player scoort!';
  }

  @override
  String pitchComSetPieceGoal3(String player) {
    return 'Uit de stilstaande situatie scoort $player! DOELPUNT!';
  }

  @override
  String pitchComSetPieceSaved1(String player, String keeper) {
    return '$player komt bij de bal, maar $keeper houdt hem tegen.';
  }

  @override
  String pitchComSetPieceSaved2(String player) {
    return '$player raakt de bal, de keeper vangt hem.';
  }

  @override
  String pitchComSetPieceSaved3(String player, String keeper) {
    return '$player haalt uit, $keeper is alert.';
  }

  @override
  String pitchComSetPieceWide1(String player) {
    return '$player komt tot een schot, maar naast.';
  }

  @override
  String pitchComSetPieceWide2(String player) {
    return '$player raakt de voorzet, maar naast het doel.';
  }

  @override
  String pitchComSetPieceWide3(String player) {
    return 'Over de lat van $player.';
  }

  @override
  String pitchComSetPieceBlocked1(String player) {
    return '$player komt bij de bal, maar het wordt geblokt.';
  }

  @override
  String pitchComSetPieceBlocked2(String player) {
    return 'Gedrang in het strafschopgebied! $player wordt geblokt.';
  }

  @override
  String pitchComSetPieceBlocked3(String player) {
    return '$player probeert hem erin te werken, maar de defensie ruimt op.';
  }

  @override
  String pitchComSetPieceWoodwork1(String player) {
    return '$player haalt uit en raakt de paal!';
  }

  @override
  String pitchComSetPieceWoodwork2(String player) {
    return 'Lat! $player scoort bijna uit de stilstaande situatie.';
  }

  @override
  String pitchComSetPieceWoodwork3(String player) {
    return 'Houtwerk! $player zo dichtbij na de voorzet.';
  }

  @override
  String pitchComDirectFreeKickGoal1(String player) {
    return 'DOELPUNT! $player draait de vrije trap over de muur!';
  }

  @override
  String pitchComDirectFreeKickGoal2(String player) {
    return 'Wat een vrije trap! $player vindt de kruising!';
  }

  @override
  String pitchComDirectFreeKickGoal3(String player) {
    return 'DOELPUNT! $player verslaat de keeper met een vrije trap.';
  }

  @override
  String pitchComDirectFreeKickSaved1(String player, String keeper) {
    return '$player schiet direct op doel, $keeper houdt hem tegen.';
  }

  @override
  String pitchComDirectFreeKickSaved2(String player) {
    return 'De vrije trap van $player wordt weggetikt.';
  }

  @override
  String pitchComDirectFreeKickSaved3(String player, String keeper) {
    return 'Mooie redding! Vrije trap van $player, $keeper houdt hem uit.';
  }

  @override
  String pitchComDirectFreeKickWide1(String player) {
    return 'De vrije trap van $player gaat over.';
  }

  @override
  String pitchComDirectFreeKickWide2(String player) {
    return '$player probeert het direct, maar naast.';
  }

  @override
  String pitchComDirectFreeKickWide3(String player) {
    return '$player mist het doel met de vrije trap.';
  }

  @override
  String pitchComDirectFreeKickBlocked1(String player) {
    return 'De vrije trap van $player belandt in de muur.';
  }

  @override
  String pitchComDirectFreeKickBlocked2(String player) {
    return 'In de muur van $player.';
  }

  @override
  String pitchComDirectFreeKickBlocked3(String player) {
    return 'De muur houdt stand tegen $player.';
  }

  @override
  String pitchComDirectFreeKickWoodwork1(String player) {
    return '$player raakt de lat met de vrije trap!';
  }

  @override
  String pitchComDirectFreeKickWoodwork2(String player) {
    return 'Paal! Vrije trap van $player, de bal komt terug.';
  }

  @override
  String pitchComDirectFreeKickWoodwork3(String player) {
    return 'Het houtwerk redt de keeper! $player heeft pech.';
  }

  @override
  String pitchComPenaltyGoal1(String player) {
    return 'DOELPUNT! $player stuurt de keeper de verkeerde kant op.';
  }

  @override
  String pitchComPenaltyGoal2(String player) {
    return '$player neemt aanloop en scoort! DOELPUNT!';
  }

  @override
  String pitchComPenaltyGoal3(String player) {
    return 'DOELPUNT! $player schiet de strafschop koel binnen.';
  }

  @override
  String pitchComPenaltySaved1(String player, String keeper) {
    return 'Gestopt! Strafschop van $player, $keeper houdt hem tegen!';
  }

  @override
  String pitchComPenaltySaved2(String player) {
    return '$player neemt aanloop... en de keeper stopt hem!';
  }

  @override
  String pitchComPenaltySaved3(String player, String keeper) {
    return 'Strafschop van $player, $keeper gokt goed en stopt hem!';
  }

  @override
  String pitchComPenaltyMissed1(String player) {
    return '$player mist de strafschop!';
  }

  @override
  String pitchComPenaltyMissed2(String player) {
    return 'Naast! Strafschop van $player langs de paal.';
  }

  @override
  String pitchComPenaltyMissed3(String player) {
    return 'Over! $player jaagt de strafschop de lucht in.';
  }

  @override
  String pitchComPenaltyWoodwork1(String player) {
    return 'Strafschop van $player tegen de paal!';
  }

  @override
  String pitchComPenaltyWoodwork2(String player) {
    return 'Lat! De strafschop van $player gaat er niet in.';
  }

  @override
  String pitchComPenaltyWoodwork3(String player) {
    return 'Houtwerk! $player kan het niet geloven.';
  }

  @override
  String pitchComPenaltyAwarded1(String player) {
    return 'Strafschop! $player wordt neergehaald in het strafschopgebied.';
  }

  @override
  String pitchComPenaltyAwarded2(String player, String other) {
    return 'De scheidsrechter wijst naar de stip! Overtreding van $other op $player.';
  }

  @override
  String pitchComPenaltyAwarded3(String player, String other) {
    return 'Strafschop gegeven! $other haalt $player neer in de zestien.';
  }

  @override
  String pitchComPenaltyAwardedYellow1(String player, String other) {
    return 'Strafschop! $player gaat neer en $other krijgt geel.';
  }

  @override
  String pitchComPenaltyAwardedYellow2(String player, String other) {
    return 'Strafschop, en geel voor $other na de overtreding op $player.';
  }

  @override
  String pitchComPenaltyAwardedYellow3(String player, String other) {
    return 'Strafschop en een kaart! $other raakt $player in de zestien.';
  }

  @override
  String pitchComPenaltyAwardedRed1(String player, String other) {
    return 'Strafschop en rood! $player valt, $other moet eraf.';
  }

  @override
  String pitchComPenaltyAwardedRed2(String player, String other) {
    return 'Strafschop, en $other wordt van het veld gestuurd voor de overtreding op $player!';
  }

  @override
  String pitchComPenaltyAwardedRed3(String player, String other) {
    return 'Rood en strafschop! $other stopt $player die vrij voor de keeper kwam.';
  }

  @override
  String pitchComCorner1(String player) {
    return 'Hoekschop. Genomen door $player.';
  }

  @override
  String pitchComCorner2(String player) {
    return '$player slaat de hoekschop voor.';
  }

  @override
  String pitchComCorner3(String player) {
    return 'Hoekschop, $player legt de bal klaar.';
  }

  @override
  String pitchComFreeKick1(String player) {
    return 'Vrije trap. Genomen door $player.';
  }

  @override
  String pitchComFreeKick2(String player) {
    return 'Vrije trap op een gevaarlijke plek. $player staat bij de bal.';
  }

  @override
  String pitchComFreeKick3(String player) {
    return '$player maakt zich klaar voor de vrije trap.';
  }

  @override
  String pitchComLongThrow1(String player) {
    return 'Lange inworp! $player gooit de bal het strafschopgebied in.';
  }

  @override
  String pitchComLongThrow2(String player) {
    return '$player met een lange inworp het strafschopgebied in.';
  }

  @override
  String pitchComLongThrow3(String player) {
    return 'Daar komt de lange inworp van $player.';
  }

  @override
  String pitchComFoulYellow1(String player) {
    return 'Gele kaart voor $player.';
  }

  @override
  String pitchComFoulYellow2(String player, String other) {
    return '$player krijgt geel voor een overtreding op $other.';
  }

  @override
  String pitchComFoulYellow3(String player, String other) {
    return 'Late tackle op $other, en $player wordt bestraft met geel.';
  }

  @override
  String pitchComFoulSecondYellow1(String player) {
    return 'Tweede geel! $player moet eraf.';
  }

  @override
  String pitchComFoulSecondYellow2(String player) {
    return '$player krijgt opnieuw geel en wordt uitgesloten.';
  }

  @override
  String pitchComFoulSecondYellow3(String player) {
    return 'Tweede gele kaart voor $player, en dus rood.';
  }

  @override
  String pitchComFoulRed1(String player) {
    return 'Rode kaart! $player wordt van het veld gestuurd.';
  }

  @override
  String pitchComFoulRed2(String player, String other) {
    return 'Direct rood voor $player na de overtreding op $other!';
  }

  @override
  String pitchComFoulRed3(String player) {
    return '$player krijgt rood en moet vertrekken.';
  }

  @override
  String pitchComOffside1(String player) {
    return 'Buitenspel. $player ging te vroeg weg.';
  }

  @override
  String pitchComOffside2(String player) {
    return 'De vlag gaat omhoog bij $player.';
  }

  @override
  String pitchComOffside3(String player) {
    return '$player staat buitenspel.';
  }

  @override
  String pitchComSub1(String player, String other) {
    return 'Wissel: $player erin, $other eruit.';
  }

  @override
  String pitchComSub2(String player, String other) {
    return '$other maakt plaats voor $player.';
  }

  @override
  String pitchComSub3(String player, String other) {
    return '$player komt erin voor $other.';
  }

  @override
  String pitchComSubFill1(String player) {
    return '$player komt erin.';
  }

  @override
  String pitchComSubFill2(String player) {
    return 'Wissel: $player staat in het veld.';
  }

  @override
  String pitchComSubFill3(String player) {
    return '$player betreedt het veld.';
  }

  @override
  String pitchComInjury1(String player) {
    return '$player ligt op de grond en heeft verzorging nodig.';
  }

  @override
  String pitchComInjury2(String player) {
    return 'Zorgen bij $player, een knauw opgelopen.';
  }

  @override
  String pitchComInjury3(String player) {
    return 'Blessurezorgen bij $player.';
  }

  @override
  String pitchComGoalScore(String line, int home, int away) {
    return '$line $home–$away';
  }

  @override
  String get pitchComSomeone => 'Speler';

  @override
  String pitchComPenaltyAwardedSecondYellow1(String player, String other) {
    return 'Strafschop en tweede geel! $other moet eraf voor de overtreding op $player.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow2(String player, String other) {
    return 'Strafschop! $player gaat neer en $other krijgt een tweede geel.';
  }

  @override
  String pitchComPenaltyAwardedSecondYellow3(String player, String other) {
    return 'Strafschop! $other raakt $player en krijgt opnieuw geel, dus rood.';
  }

  @override
  String get matchViewChooseTitle => 'Hoe wilt u de wedstrijd volgen?';

  @override
  String get matchViewChooseHint =>
      'Uw keuze blijft bewaard voor de volgende wedstrijd. U kunt altijd wisselen.';

  @override
  String get matchViewPitch => '2D TV';

  @override
  String get matchViewPitchBlurb => 'Volg de spelers op het veld';

  @override
  String get matchViewTimeline => 'Verloop';

  @override
  String get matchViewTimelineBlurb =>
      'Volg de wedstrijd gebeurtenis voor gebeurtenis';

  @override
  String get matchViewSwitchToPitch => 'Kijk in 2D TV-modus';

  @override
  String get matchViewSwitchToTimeline => 'Het verloop bekijken';

  @override
  String get matchTabCommentary => 'COMMENTAAR';

  @override
  String get matchSubShout => 'WISSEL';

  @override
  String matchSubOff(String name) {
    return 'Eruit: $name';
  }

  @override
  String matchSubOn(String name) {
    return 'Erin: $name';
  }

  @override
  String get editorFilterToFix => 'Te herstellen';

  @override
  String get editorNothingToFix => 'Hier hoeft niets hersteld te worden.';

  @override
  String get editorPromoteTooltip => 'Naar de selectie';

  @override
  String editorPromoted(String name) {
    return '$name naar de selectie verplaatst';
  }

  @override
  String get editorPromoteFullTitle => 'De selectie zit vol';

  @override
  String editorPromoteFullBody(int max) {
    return 'Een selectie heeft maximaal $max spelers. Kies de speler die in zijn plaats terug naar de pool gaat.';
  }

  @override
  String get editorTrophyGallery => 'Kies uit je foto’s';

  @override
  String get editorTrophyFile => 'Kies een bestand';

  @override
  String clubStrengthOf(int stars) {
    return 'Clubsterkte: $stars van 5';
  }

  @override
  String get editorClubStrength => 'Sterkte';

  @override
  String get editorClubStrengthDefault => 'Standaard';

  @override
  String editorClubStrengthHelp(int stars) {
    return 'Betere spelers gaan naar sterkere clubs. Standaard: $stars van 5, volgens de competitie.';
  }

  @override
  String mgrNewsSacked(String nation, String name) {
    return '$nation sack $name';
  }

  @override
  String mgrNewsResigned(String nation, String name) {
    return '$nation: $name resigns';
  }

  @override
  String mgrNewsPoached(String nation, String name) {
    return '$nation: $name leaves for another national team';
  }

  @override
  String mgrNewsRetired(String nation, String name) {
    return '$nation: $name retires from management';
  }

  @override
  String mgrNewsContractEnd(String nation, String name) {
    return '$nation: $name leaves as his contract runs out';
  }

  @override
  String mgrNewsReplacedByPlayer(String nation, String name) {
    return '$nation: $name makes way for you';
  }

  @override
  String mgrNewsAppointed(String nation, String name) {
    return '$nation appoint $name';
  }

  @override
  String mgrNewsAppointedBody(String nation, String name) {
    return '$name takes charge of $nation.';
  }

  @override
  String pressBeatOpposingManager(String manager) {
    return 'You and $manager have some history. Anything to say about him?';
  }

  @override
  String get pressAnswerHitBackAtManager =>
      'He should worry about his own team.';

  @override
  String get pressAnswerRespectManager => 'I have a lot of respect for him.';

  @override
  String yMgrTie1(String manager) {
    return '$manager in the other dugout next. History there with our boss, and I cannot wait.';
  }

  @override
  String yMgrTie2(String manager) {
    return 'Next up, $manager in the other dugout. He and our manager go back a while.';
  }

  @override
  String yMgrTie3(String manager) {
    return '$manager again. Our boss had better not turn this into a personal thing.';
  }

  @override
  String yMgrTie4(String manager) {
    return 'Here we go. $manager on the touchline, and our manager trying to win a feud instead of a match.';
  }

  @override
  String get mgrRowLabel => 'Manager';

  @override
  String mgrRowDetail(int age, String date) {
    return '$age years old, since $date';
  }

  @override
  String mgrRecordWdl(int won, int drawn, int lost) {
    return '$won W, $drawn D, $lost L';
  }

  @override
  String mgrRowRecord(String record) {
    return 'In charge: $record';
  }

  @override
  String get mgrTieNeutral => 'No history';

  @override
  String get mgrTieRespect => 'Respect';

  @override
  String get mgrTieRival => 'Rival';

  @override
  String get mgrTieGrudge => 'Grudge';

  @override
  String get mgrTieSuccessor => 'Successor';

  @override
  String get mgrTieProtege => 'Protege';

  @override
  String get mgrTieFormerPlayer => 'Former player';

  @override
  String get mgrEndSacked => 'Sacked';

  @override
  String get mgrEndResigned => 'Resigned';

  @override
  String get mgrEndPoached => 'Left for another national team';

  @override
  String get mgrEndRetired => 'Retired from management';

  @override
  String get mgrEndContractEnd => 'Contract ran out';

  @override
  String get mgrEndReplacedByPlayer => 'Replaced by you';

  @override
  String get mgrProfileSpells => 'Career';

  @override
  String mgrProfileSpellNow(String nation, String from) {
    return '$nation, since $from';
  }

  @override
  String mgrProfileSpellRange(String nation, String from, String to) {
    return '$nation, $from to $to';
  }

  @override
  String mgrProfileSpellEnded(String range, String reason) {
    return '$range, $reason';
  }

  @override
  String get mgrProfileRecordVsYou => 'Record against you';

  @override
  String get mgrProfileNoMeetings => 'You have not met';

  @override
  String get mgrProfileReputation => 'Reputation';

  @override
  String get mgrProfileAge => 'Age';

  @override
  String get mgrProfileAppointed => 'Appointed';

  @override
  String get mgrProfileStyle => 'Style';

  @override
  String get mgrProfileTie => 'Between you';

  @override
  String mgrPreviewLine(String name) {
    return 'Their manager: $name';
  }

  @override
  String mgrDossierStyle(String style) {
    return 'Manager\'s style: $style';
  }

  @override
  String mgrDossierRecord(String record) {
    return 'Your record against him: $record';
  }

  @override
  String get mgrStylePossession => 'Possession';

  @override
  String get mgrStyleHighPress => 'High press';

  @override
  String get mgrStyleDefensive => 'Defensive';

  @override
  String get mgrStyleDirect => 'Direct';

  @override
  String get mgrStyleCounter => 'Counter-attack';

  @override
  String get mgrStyleFlair => 'Flair';

  @override
  String get mgrStylePhysical => 'Physical';

  @override
  String get mgrStyleBalanced => 'Balanced';

  @override
  String get mgrListTitle => 'Managers';

  @override
  String get mgrListCurrent => 'Current';

  @override
  String get mgrListRecentMoves => 'Recent moves';

  @override
  String get mgrListFilterAll => 'All';

  @override
  String get mgrListSortReputation => 'Reputation';

  @override
  String get mgrListSortName => 'Name';

  @override
  String get mgrListEmptyMoves => 'No changes in the last two years.';

  @override
  String get mgrListEmptyCurrent =>
      'Managers appear after the next season rollover.';

  @override
  String get editorSectionManagers => 'Bondscoaches';

  @override
  String get editorAboutManagers => 'Wie elk land op dag één leidt';

  @override
  String get editorManagersHint => 'Gekozen bij de start van een carrière';

  @override
  String get editorManagerName => 'Naam van de bondscoach';

  @override
  String get editorManagerNationality => 'Nationaliteit';

  @override
  String editorIssueManagerName(int max) {
    return 'De bondscoach heeft een naam nodig van 1 tot $max tekens die het spel kan tonen';
  }

  @override
  String get editorIssueManagerNationality =>
      'Kies een nationaliteit voor de bondscoach uit de lijst';
}
