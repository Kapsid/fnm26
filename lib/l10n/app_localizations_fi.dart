// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get matchPreviewTitle => 'OTTELUN ESITTELY';

  @override
  String get matchKickOff => 'Aloita ottelu';

  @override
  String get matchTactics => 'Taktiikka';

  @override
  String get matchYourXi => 'AVAUSKOKOONPANOSI';

  @override
  String get matchHeadToHead => 'KESKINÄISET OTTELUT';

  @override
  String matchCouldNotLoad(String error) {
    return 'Ottelua ei voitu ladata.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Ei tulevia otteluita.';

  @override
  String get matchUnknownNation => 'Tuntematon';

  @override
  String get matchH2hFirstMeeting => 'Ensimmäinen kohtaaminen';

  @override
  String get matchH2hYouLead => 'Johdat keskinäisiä otteluita';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Etulyöntiasema: $opponent';
  }

  @override
  String get matchH2hEven => 'Tasaväkisiä';

  @override
  String matchH2hMet(int count) {
    return '$count kohtaamista';
  }

  @override
  String get matchH2hWon => 'Voitot';

  @override
  String get matchH2hDrawn => 'Tasapelit';

  @override
  String get matchH2hLost => 'Tappiot';

  @override
  String get matchDossierTitle => 'Scouttiraportti';

  @override
  String get matchDossierForm => 'VIRE';

  @override
  String get matchDossierNoGames => 'Ei viimeaikaisia otteluita';

  @override
  String get matchDossierKeyMen => 'AVAINPELAAJAT';

  @override
  String get matchDossierHowTheyPlay => 'PELITAPA';

  @override
  String matchScoutFormation1(String formation) {
    return 'He pelaavat yleensä muodostelmalla $formation.';
  }

  @override
  String matchScoutFormation2(String formation) {
    return 'Heidän tavallinen muodostelmansa on $formation.';
  }

  @override
  String matchScoutFormation3(String formation) {
    return 'He luottavat useimmiten muodostelmaan $formation.';
  }

  @override
  String get matchScoutStrengthPressing =>
      'He prässäävät korkealta ja jahtaavat palloa.';

  @override
  String get matchScoutStrengthDirect =>
      'He pelaavat suoraviivaisesti ja vievät pallon nopeasti eteen.';

  @override
  String get matchScoutStrengthPossession =>
      'He pitävät palloa hyvin ja rakentavat kärsivällisesti.';

  @override
  String get matchScoutStrengthCounter =>
      'He odottavat matalalla ja lähtevät nopeasti vastahyökkäyksiin.';

  @override
  String get matchScoutStrengthDeepDefence =>
      'He puolustavat matalalla, ja heitä on vaikea murtaa.';

  @override
  String get matchScoutStrengthWide =>
      'He levittävät peliä ja hyökkäävät laitojen kautta.';

  @override
  String get matchScoutStrengthAttacking =>
      'He ottavat mielellään ohjat ja käyvät vastustajan kimppuun.';

  @override
  String get matchScoutStrengthQuickForwards =>
      'Heidän hyökkääjänsä ovat nopeita ja rakastavat syvyysjuoksuja.';

  @override
  String get matchScoutStrengthPassingMidfield =>
      'Heidän keskikenttänsä syöttää palloa hyvin.';

  @override
  String get matchScoutStrengthHardRunning =>
      'Heidän keskikenttänsä jaksaa juosta koko ottelun.';

  @override
  String get matchScoutStrengthSetPieces =>
      'He ovat vaarallisia vakiotilanteissa.';

  @override
  String get matchScoutStrengthQuickDefence =>
      'Heidän puolustuslinjansa on nopea, ja sen taakse on vaikea päästä.';

  @override
  String get matchScoutStrengthNone =>
      'Heidän pelissään ei mikään erityisesti erotu.';

  @override
  String get matchScoutWeakSpaceBehind =>
      'Heidän korkea linjansa jättää selustaan tilaa pitkälle pallolle.';

  @override
  String get matchScoutWeakPressedBuildUp =>
      'Korkea prässi voi sotkea heidän hitaan avauspelinsä.';

  @override
  String get matchScoutWeakDeepBlock =>
      'Ole kärsivällinen: heidän kaltaisensa matala puolustus on purettavissa.';

  @override
  String get matchScoutWeakLongBall =>
      'Pudota linjaasi syvemmälle, niin heidän pitkillä palloillaan ei ole minne mennä.';

  @override
  String get matchScoutWeakSlowDefence =>
      'Heidän puolustajiltaan puuttuu vauhtia, joten lähetä juoksijoita heidän selustaansa.';

  @override
  String get matchScoutWeakAerial =>
      'He näyttävät epävarmoilta puolustaessaan vakiotilanteita.';

  @override
  String get matchScoutWeakPoorPassing =>
      'Heidän keskikenttänsä ei tahdo syöttää itseään ulos paineesta.';

  @override
  String get matchScoutWeakTiringMidfield =>
      'Heidän keskikentältään puuttuvat jalat prässin ylläpitämiseen.';

  @override
  String get matchScoutWeakBluntAttack =>
      'Heidän hyökkääjiltään puuttuu vauhtia.';

  @override
  String get matchScoutApproachTakeTheGame =>
      'Sinua vastaan he todennäköisesti ottavat ohjat.';

  @override
  String get matchScoutApproachEven =>
      'Sinua vastaan on luvassa tiukka ja tasainen ottelu.';

  @override
  String get matchScoutApproachSitDeep =>
      'Sinua vastaan he todennäköisesti pelaavat varovasti ja odottavat vastahyökkäyksen paikkaa.';

  @override
  String get matchScoutLeaningAttacking =>
      'Kaukaa katsottuna he vaikuttavat hyökkäävältä joukkueelta.';

  @override
  String get matchScoutLeaningCautious =>
      'Kaukaa katsottuna he vaikuttavat varovaiselta joukkueelta.';

  @override
  String get matchScoutLeaningUnclear =>
      'Kaukaa on vaikea sanoa, miten he haluavat pelata.';

  @override
  String get matchScoutHireHint =>
      'Palkkaa pääscout, niin saat selville, miten he pelaavat.';

  @override
  String matchCouldNotContinue(String error) {
    return 'Jatkaminen ei onnistunut: $error';
  }

  @override
  String get matchSkipToFullTime => 'Siirry loppuvihellykseen';

  @override
  String get matchStatShots => 'Laukaukset';

  @override
  String get matchStatGoals => 'Maalit';

  @override
  String get matchStatYellowCards => 'Keltaiset';

  @override
  String get matchStatRedCards => 'Punaiset';

  @override
  String get matchMomentum => 'PAINE';

  @override
  String get matchSwingAtk => 'HYÖ';

  @override
  String get matchSwingDef => 'PUO';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'MM-KISAT $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'LOPPUTURNAUS ALKAA';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'ISÄNTÄ  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'ISÄNTÄ VAHVISTETAAN';

  @override
  String get matchHalfTime => 'PUOLIAIKA';

  @override
  String get matchContinue => 'Jatka';

  @override
  String get matchContinuing => 'Jatketaan…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktiikka · $used/$max vaihtoa';
  }

  @override
  String matchTiredCount(int count) {
    return 'VÄSYNEET ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIIKKA';

  @override
  String get teamOverallOverTime => 'KOKONAISTASO AJAN MYÖTÄ';

  @override
  String get teamOverall => 'Kokonaistaso';

  @override
  String get teamTalkHeading => 'JOUKKUEPUHE';

  @override
  String get teamTalkPrompt => 'Anna sävy toiselle jaksolle.';

  @override
  String get teamTalkCalmLabel => 'Viileä pää';

  @override
  String get teamTalkCalmBlurb =>
      'Rauhoita joukkue. Pieni nosto joka suuntaan.';

  @override
  String get teamTalkEncourageLabel => 'Kannusta';

  @override
  String get teamTalkEncourageBlurb => 'Paina eteenpäin ja hae peliä.';

  @override
  String get teamTalkDemandMoreLabel => 'Vaadi enemmän';

  @override
  String get teamTalkDemandMoreBlurb => 'Heitä kaikki peliin. Hyökkää kovaa.';

  @override
  String get teamTalkPraiseLabel => 'Pysy tiiviinä';

  @override
  String get teamTalkPraiseBlurb => 'Pysy kompaktina ja suojele johtoasemaa.';

  @override
  String get teamTalkBelieveLabel => 'Usko itseesi';

  @override
  String get teamTalkBelieveBlurb =>
      'Luota itseesi. Nosto kentän molempiin päihin.';

  @override
  String get teamTalkFocusLabel => 'Pysy terävänä';

  @override
  String get teamTalkFocusBlurb => 'Täysi keskittyminen. Lukitse peli.';

  @override
  String get teamTalkUrgencyLabel => 'Kiire päälle';

  @override
  String get teamTalkUrgencyBlurb =>
      'Hae peliä nyt. Täysillä, ja takana jää tilaa.';

  @override
  String get teamTalkReassureLabel => 'Ei paineita';

  @override
  String get teamTalkReassureBlurb => 'Rauhoita hermot ja pidä muodostelma.';

  @override
  String get commonRetry => 'Yritä uudelleen';

  @override
  String get commonSomethingWentWrong => 'Jokin meni pieleen';

  @override
  String get commonCrashBox =>
      'Jokin meni pieleen tässä.\nAsetukset → Diagnostiikka näyttää tiedot.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Maailman eteenpäin vieminen ei onnistunut: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostiikka';

  @override
  String get settingsDiagnosticsBlurb =>
      'Tälle laitteelle tallennetut virheet. Mitään ei lähetetä minnekään.';

  @override
  String get settingsContactTitle => 'Yhteystiedot';

  @override
  String get settingsContactCopied => 'Osoite kopioitu.';

  @override
  String get settingsCommunityTitle => 'Yhteisö';

  @override
  String get settingsDiscordSubtitle => 'Liity yhteisöön';

  @override
  String get settingsLinkCopied => 'Linkki kopioitu.';

  @override
  String get diagnosticsEmpty => 'Ei tallennettuja virheitä. Se on tarkoitus.';

  @override
  String get diagnosticsCopy => 'Kopioi';

  @override
  String get diagnosticsCopied => 'Loki kopioitu leikepöydälle.';

  @override
  String get diagnosticsClear => 'Tyhjennä';

  @override
  String get navHub => 'Etusivu';

  @override
  String get navSquad => 'Joukkue';

  @override
  String get navStandings => 'Taulukot';

  @override
  String get navCareers => 'Urani';

  @override
  String get settingsTitle => 'ASETUKSET';

  @override
  String get settingsSoundHapticsTitle => 'Äänet ja värinä';

  @override
  String get settingsSoundHapticsBlurb =>
      'Värinää ja lyhyt ääni maaleista, aloituksesta ja loppuvihellyksestä.';

  @override
  String get settingsLanguageTitle => 'Kieli';

  @override
  String get settingsLanguageBlurb =>
      'Valitse sovelluksen kieli tai seuraa laitteen kieltä.';

  @override
  String get settingsLanguageSystem => 'Järjestelmä';

  @override
  String get settingsTextSizeTitle => 'Tekstin koko';

  @override
  String get settingsTextSizeBlurb =>
      'Suurenna tekstiä, jos sitä on vaikea lukea.';

  @override
  String get settingsTextSizeNormal => 'Normaali';

  @override
  String get settingsTextSizeLarge => 'Suuri';

  @override
  String get settingsTextSizeLarger => 'Suurempi';

  @override
  String get matchPreviewAllMeetings => 'Kaikki kohtaamiset';

  @override
  String get recordsMeetings => 'KOHTAAMISET';

  @override
  String get recordsLegends => 'LEGENDAT';

  @override
  String get recordsAllTimeXi => 'KAIKKIEN AIKOJEN AVAUSKOKOONPANO';

  @override
  String get recordsHallOfFame => 'HALL OF FAME';

  @override
  String get recordsAllTimeWorld => 'KAIKKIEN AIKOJEN MAAILMA';

  @override
  String get recordsAllTimeTopScorers => 'KAIKKIEN AIKOJEN MAALIPÖRSSI';

  @override
  String get recordsMostCapped => 'ENITEN MAAOTTELUITA';

  @override
  String get recordsMostWcStarts => 'ENITEN MM-KISOJEN AVAUKSIA';

  @override
  String get recordsMostTournaments => 'ENITEN TURNAUKSIA';

  @override
  String get recordsRecordBook => 'ENNÄTYSKIRJA';

  @override
  String get recordsHeadToHead => 'KESKINÄISET OTTELUT';

  @override
  String get recordsFiercestRival => 'KOVIN KILPAILIJA';

  @override
  String get recordsMostCaps => 'ENITEN MAAOTTELUITA';

  @override
  String get recordsTopScorers => 'MAALIPÖRSSI';

  @override
  String get recordsMostAssists => 'ENITEN SYÖTTÖJÄ';

  @override
  String get recordsYourRecord => 'SINUN ENNÄTYKSESI';

  @override
  String get callUpHome => 'KOTI';

  @override
  String get callUpAway => 'VIERAS';

  @override
  String get recordsHome => 'KOTI';

  @override
  String get recordsAway => 'VIERAS';

  @override
  String get recordsActive => 'AKTIIVINEN';

  @override
  String get recordsStillActive => 'Yhä aktiivinen';

  @override
  String get recordsAvg => 'ka.';

  @override
  String get recordsSelect => 'Valitse';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Tasapelit';

  @override
  String get recordsGoalsLabel => 'Maalit';

  @override
  String get recordsBestFinish => 'Paras sijoitus';

  @override
  String get recordsNoFinalsYet => 'Ei vielä lopputurnausta';

  @override
  String get recordsLongestUnbeaten => 'Pisin tappioton putki';

  @override
  String get recordsBiggestWin => 'Suurin voitto';

  @override
  String get recordsSeeAllMeetings => 'Näytä kaikki kohtaamiset';

  @override
  String get recordsSaveNotFound => 'Tallennusta ei löytynyt.';

  @override
  String get recordsNoMatches => 'Ei osumia.';

  @override
  String get recordsSearchPlayerOrNation => 'Hae pelaaja tai maa';

  @override
  String get recordsSearchNation => 'Hae maa';

  @override
  String get recordsPickTwoDifferent => 'Valitse kaksi eri maata.';

  @override
  String get recordsPlayToBuildRecord =>
      'Pelaa muutama ottelu, niin ennätyksesi kutakin vastustajaa vastaan karttuu tähän.';

  @override
  String get recordsTapOpponent =>
      'Napauta vastustajaa nähdäksesi koko erittelyn.';

  @override
  String get recordsEdgeUpperHand => 'Sinulla on niskaote';

  @override
  String get recordsEdgeTheirNumber => 'He ovat sinua parempia';

  @override
  String get recordsEdgeEven => 'Tasaväkisiä';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Maalintekijät ja maaottelukärjet, kaikki maat';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Vertaa minkä tahansa kahden maan keskinäistä historiaa';

  @override
  String get recordsLegendsSubtitle => 'Kaikkien aikojen XI ja Hall of Fame';

  @override
  String get recordsUnitGoals => 'maalia';

  @override
  String get recordsUnitCaps => 'maaottelua';

  @override
  String get recordsUnitStarts => 'avausta';

  @override
  String get recordsUnitCups => 'turnausta';

  @override
  String get recordsUnitAssists => 'syöttöä';

  @override
  String recordsCapsCount(int count) {
    return '$count maaottelua';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count maalia';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count syöttöä';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count × ottelun paras';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count ottelua';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count kohtaamista';
  }

  @override
  String recordsCodeWins(String code) {
    return '$code voitot';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings kohtaamista · ${wins}V ${draws}T ${losses}H';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}V ${draws}T ${losses}H';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings kohtaamista · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return '$a ja $b eivät ole koskaan kohdanneet tässä tallennuksessa.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return '$names on erotettu kentältä. Vaihtoa ei sallita, joten pelaat vajaalla.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Tarvitaan $required pelikuntoista ($have kunnossa)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Poissa $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Poissa koko kutsun ajan';

  @override
  String get rankingCentreOnMe => 'Keskitä omaan maahan';

  @override
  String get recordsAfterExtraTime => 'jatkoajalla';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b rp';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played ottelua · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga vs $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Lataus epäonnistui.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Legendoja ei voitu ladata.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Ennätyksiä ei voitu ladata.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Maita ei voitu ladata.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Ennätystäsi ei voitu ladata.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Ennätystä ei voitu ladata.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Ei vielä legendoja. Pelaa muutama kampanja läpi, niin maan suurimmat nimet nousevat tähän: $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Paras joukkue, jonka tämä maa voisi koskaan kenttään asettaa: $nation.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Maailmalla ei ole vielä historiaa. Pelaa muutama kampanja läpi, niin kaikkien aikojen suuruudet ilmestyvät tähän.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Pelaa muutama ottelu, niin historian kirjoittaminen alkaa: $nation.';
  }

  @override
  String get tacticsLineGk => 'MV';

  @override
  String get tacticsLineDef => 'PU';

  @override
  String get tacticsLineMid => 'KK';

  @override
  String get tacticsLineFwd => 'HY';

  @override
  String get tacticsGoalkeepers => 'MAALIVAHDIT';

  @override
  String get tacticsDefenders => 'PUOLUSTAJAT';

  @override
  String get tacticsMidfielders => 'KESKIKENTTÄPELAAJAT';

  @override
  String get tacticsForwards => 'HYÖKKÄÄJÄT';

  @override
  String get tacticsCallUpsTitle => 'KUTSUT';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Valitse vähintään $min pelaajaa.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Joukkuetta ei voitu ladata.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Ei joukkuetta.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'JOUKKUE · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Väh. $min · Enint. $max';
  }

  @override
  String get tacticsBestQuality => 'Parhaat pelaajat';

  @override
  String get tacticsPreviousSquad => 'Edellinen joukkue';

  @override
  String get tacticsSquadLockedBack => 'Takaisin (joukkue lukittu)';

  @override
  String get tacticsConfirmSquad => 'Vahvista kokoonpano';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Joukkue täynnä (enint. $max)';
  }

  @override
  String get tacticsSquadLocked => 'JOUKKUE LUKITTU';

  @override
  String get tacticsNominationOpen => 'NIMEÄMINEN AUKI. VALITSE JOUKKUEESI';

  @override
  String get tacticsSquadFixedBlurb =>
      'Tämä joukkue on lukittu alla oleviin otteluihin. Valitse uudelleen ennen seuraavaa nimeämisjaksoa.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Tämä joukkue pelaa alla olevat ottelut.';

  @override
  String get tacticsUnknown => 'Tuntematon';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Ikä $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Uupunut';

  @override
  String get tacticsFatigueTired => 'Väsynyt';

  @override
  String get tacticsFatigueMatchLegs => 'Ottelurasitus';

  @override
  String tacticsTooManySubs(int max) {
    return 'Liian monta vaihtoa (enint. $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIIKKA · $minute\'';
  }

  @override
  String get tacticsApply => 'OTA KÄYTTÖÖN';

  @override
  String get tacticsTabLineupSubs => 'KOKOONPANO JA VAIHDOT';

  @override
  String get tacticsTabTactics => 'TAKTIIKKA';

  @override
  String get squadLineKeepers => 'MAALIVAHDIT';

  @override
  String get squadLineDefenders => 'PUOLUSTUS';

  @override
  String get squadLineMidfielders => 'KESKIKENTTÄ';

  @override
  String get squadLineForwards => 'HYÖKKÄYS';

  @override
  String get squadStatXiRating => 'XI-taso';

  @override
  String get squadStatAvgAge => 'Ka. ikä';

  @override
  String get squadStatSize => 'Joukkue';

  @override
  String get squadStatUnavailable => 'Poissa';

  @override
  String get squadDepthTitle => 'SYVYYS LINJOITTAIN';

  @override
  String squadAgeShort(int age) {
    return '$age v';
  }

  @override
  String get tacticsTabOtherPositions => 'MUUT PAIKAT';

  @override
  String get tacticsOutOfPositionNote => 'Väärällä paikalla';

  @override
  String get tacticsNobodyElse => 'Ei ketään muuta kokeiltavaksi.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Valitse ensin, kuka lähtee kentältä, niin loput vaihtopenkistä näkyvät tässä sekä arvosana, jolla he pelaisivat tätä paikkaa.';

  @override
  String get tacticsTabSuitable => 'SOPIVAT';

  @override
  String get tacticsTabOnPitch => 'KENTÄLLÄ';

  @override
  String tacticsSectionSuitable(int count) {
    return 'SOPIVAT · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Kukaan vaihtopenkiltä ei luontaisesti sovi tälle paikalle, joten tässä on kaikki.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'KENTÄLLÄ · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'SAATAVILLA · $count';
  }

  @override
  String get tacticsRowStarted => 'Aloitti';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Sisään $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Tuli sisään';

  @override
  String get tacticsEnergyLabel => 'ENERGIA';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'Napauta korvaaja pelaajalle $name tai napauta häntä uudelleen peruuttaaksesi.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Punainen kortti vei tämän paikan. Vedä joukkuetoveri tähän siirtääksesi aukon.';

  @override
  String get tacticsSentOffShort => 'ERONNUT';

  @override
  String get tacticsFullBackLeft => 'Vasen laitapuolustaja';

  @override
  String get tacticsFullBackRight => 'Oikea laitapuolustaja';

  @override
  String get tacticsFullBackUp => 'Nousee hyökkäykseen';

  @override
  String get tacticsFullBackDown => 'Pysyy takana';

  @override
  String get tacticsFullBackOff => 'Ei ohjetta';

  @override
  String tacticsFullBackUpHint(String side) {
    return '$side: nousee hyökkäykseen. Hieman enemmän hyökkäystä, hieman enemmän riskiä.';
  }

  @override
  String tacticsFullBackDownHint(String side) {
    return '$side: pysyy takana. Hieman turvallisempaa, hieman vähemmän hyökkäystä.';
  }

  @override
  String tacticsFullBackOffHint(String side) {
    return '$side: ei ohjetta, pelaa joukkueen suunnitelman mukaan.';
  }

  @override
  String tacticsFullBackSemantics(String side, String state) {
    return '$side, nuoli: $state';
  }

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'VAIHDOT · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'Napauta kentällä olevaa pelaajaa vaihtaaksesi hänet pois tai pidä pohjassa ja vedä varamies hänen päälleen.';

  @override
  String get tacticsNoSubs => 'Ei varapelaajia.';

  @override
  String get tacticsChooseShape => 'VALITSE PELIJÄRJESTELMÄ';

  @override
  String get tacticsFormation => 'PELIJÄRJESTELMÄ';

  @override
  String get tacticsInstructions => 'OHJEET';

  @override
  String get tacticsDrilling => 'HARJOITTELU';

  @override
  String get tacticsDrillingUnplayed => 'PELAAMATON';

  @override
  String get tacticsDrillingNew => 'UUSI';

  @override
  String get tacticsDrillingSettling => 'VAKIINTUU';

  @override
  String get tacticsDrillingDrilled => 'HARJOITELTU';

  @override
  String get tacticsInstrMentality => 'Mentaliteetti';

  @override
  String get tacticsInstrDefensive => 'Puolustava';

  @override
  String get tacticsInstrAttacking => 'Hyökkäävä';

  @override
  String get tacticsInstrPressing => 'Prässi';

  @override
  String get tacticsInstrLowBlock => 'Matala blokki';

  @override
  String get tacticsInstrHighPress => 'Korkea prässi';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Maltillinen';

  @override
  String get tacticsInstrFast => 'Nopea';

  @override
  String get tacticsInstrWidth => 'Leveys';

  @override
  String get tacticsInstrNarrow => 'Kapea';

  @override
  String get tacticsInstrWide => 'Leveä';

  @override
  String get tacticsInstrDefLine => 'Puol.linja';

  @override
  String get tacticsInstrDefensiveLine => 'Puolustuslinja';

  @override
  String get tacticsInstrDeep => 'Matala';

  @override
  String get tacticsInstrHigh => 'Korkea';

  @override
  String get tacticsInstrDirectness => 'Suoruus';

  @override
  String get tacticsInstrPossession => 'Pallonhallinta';

  @override
  String get tacticsInstrDirect => 'Suora';

  @override
  String get tacticsPickGoalkeeper => 'VALITSE MAALIVAHTI';

  @override
  String get tacticsPickLeftBack => 'VALITSE VASEN LAITAPUOLUSTAJA';

  @override
  String get tacticsPickCentreBack => 'VALITSE KESKUSPUOLUSTAJA';

  @override
  String get tacticsPickRightBack => 'VALITSE OIKEA LAITAPUOLUSTAJA';

  @override
  String get tacticsPickDefensiveMid => 'VALITSE PUOLUSTAVA KESKIKENTTÄ';

  @override
  String get tacticsPickCentralMid => 'VALITSE KESKIKENTTÄPELAAJA';

  @override
  String get tacticsPickAttackingMid => 'VALITSE HYÖKKÄÄVÄ KESKIKENTTÄ';

  @override
  String get tacticsPickLeftMid => 'VALITSE VASEN KESKIKENTTÄ';

  @override
  String get tacticsPickRightMid => 'VALITSE OIKEA KESKIKENTTÄ';

  @override
  String get tacticsPickLeftWing => 'VALITSE VASEN LAITA';

  @override
  String get tacticsPickRightWing => 'VALITSE OIKEA LAITA';

  @override
  String get tacticsPickStriker => 'VALITSE HYÖKKÄÄJÄ';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · väärällä paikalla';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Ikä $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Ikä $age';
  }

  @override
  String get tacticsOn => 'KENTÄLLÄ';

  @override
  String get tacticsSquad => 'JOUKKUE';

  @override
  String get tacticsTabLineup => 'KOKOONPANO';

  @override
  String get tacticsTabInstructions => 'OHJEET';

  @override
  String get tacticsTabRoles => 'ROOLIT';

  @override
  String get tacticsTabSetPieces => 'VAKIOTILANTEET';

  @override
  String get tacticsTabRolesSetPieces => 'ROOLIT JA VAKIOT';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Anna jokaiselle aloittajalle rooli. Napauta rangaistuspotkun (⚽) tai vapaapotkun (▲) merkkiä valitaksesi potkijan.';

  @override
  String get tacticsTooltipCallUps => 'Kutsut';

  @override
  String get tacticsTooltipPresets => 'Taktiikkapohjat';

  @override
  String get tacticsTooltipInstructions => 'Ohjeet';

  @override
  String get tacticsNoTacticSet => 'Ei taktiikkaa.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'KORVAA $count AVAUSPELAAJAA',
      one: 'KORVAA $count AVAUSPELAAJA',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Poissa';

  @override
  String get tacticsTapSpotReplace =>
      'Napauta hänen paikkaansa kentällä valitaksesi korvaajan.';

  @override
  String get tacticsTapOrDrag =>
      'Napauta pelaajaa vaihtaaksesi hänet pois tai pidä pohjassa ja vedä siirtääksesi hänet.';

  @override
  String get tacticsPlayerRoles => 'PELAAJIEN ROOLIT';

  @override
  String get tacticsRolesBlurb =>
      'Anna pelaajalle tehtävä: maalinuuskija, pelintekijä, kärkimies. Vaikuttaa siihen, kuka tekee maalit ja kuka luo ne.';

  @override
  String get tacticsSetPieceTakers => 'VAKIOTILANTEIDEN POTKIJAT';

  @override
  String get tacticsSetPieceBlurb =>
      'Kuka potkaisee rangaistuspotkut ja vakiotilanteet, vai jätätkö valinnan sopivimmalle pelaajalle.';

  @override
  String get tacticsTakerAuto => 'Automaattinen';

  @override
  String get tacticsTakerQuickPick => 'Käytä parhaita potkijoita';

  @override
  String get tacticsPenalties => 'Rangaistuspotkut';

  @override
  String get tacticsCornersFreeKicks => 'Kulma- ja vapaapotkut';

  @override
  String get tacticsSkillFin => 'LAUKAUS';

  @override
  String get tacticsSkillPas => 'SYÖTTÖ';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROOLI · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'RANGAISTUSPOTKUN POTKIJA';

  @override
  String get tacticsCornerFreeKickTaker => 'KULMA- JA VAPAAPOTKUJEN POTKIJA';

  @override
  String get tacticsAutomatic => 'Automaattinen';

  @override
  String get tacticsLetBestSuited => 'Anna sopivimman pelaajan potkaista.';

  @override
  String get tacticsInXi => 'AVAUKSESSA';

  @override
  String get tacticsTeamInstructions => 'JOUKKUEEN OHJEET';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Päätä, miten joukkueesi pelaa. Jokainen säädin ohjaa koko joukkuetta.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Tallennettu “$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Otettu käyttöön “$name”';
  }

  @override
  String get tacticsTacticPresets => 'TAKTIIKKAPOHJAT';

  @override
  String get tacticsPresetsBlurb =>
      'Tallenna tämä pelijärjestelmä uudelleenkäytettäväksi tyyliksi tai ota käyttöön aiemmin tallentamasi.';

  @override
  String get tacticsSaveCurrentTactic => 'Tallenna nykyinen taktiikka';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Pohjia ei voitu ladata.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Ei vielä pohjia. Napauta “Tallenna nykyinen taktiikka” tallentaaksesi tämän asetelman uudelleenkäytettäväksi tyyliksi.';

  @override
  String get tacticsNameThisTactic => 'Nimeä taktiikka';

  @override
  String get tacticsNameHint => 'esim. Korkea prässi 4-3-3';

  @override
  String get tacticsCancel => 'Peruuta';

  @override
  String get tacticsSave => 'Tallenna';

  @override
  String get tacticsTapToAssign => 'Napauta määrittääksesi';

  @override
  String get tacticsHoldDragSub =>
      'Pidä varamiestä pohjassa ja vedä hänet pelaajan päälle tuodaksesi hänet kentälle.';

  @override
  String get hubContinue => 'Jatka';

  @override
  String get hubBrackets => 'Kaaviot';

  @override
  String hubCouldNotLoad(String error) {
    return 'Lataus epäonnistui.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Talouslukuja ei voitu ladata.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Tallennusta ei voitu ladata.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Tallennusta ei löytynyt.';

  @override
  String get hubUnknown => 'Tuntematon';

  @override
  String hubWorldChampionsYear(int year) {
    return '$year MAAILMANMESTARIT';
  }

  @override
  String get hubCycleComplete => 'Kausi on päättynyt.';

  @override
  String get hubYourJob => 'TEHTÄVÄSI';

  @override
  String get hubStayProject => 'Jää ja jatka hankettasi';

  @override
  String get hubChooseNextJob => 'VALITSE SEURAAVA TEHTÄVÄ';

  @override
  String get hubOffersOnTable => 'TARJOUKSET PÖYDÄLLÄ';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · maailmassa #$position';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Jatka: $nation';
  }

  @override
  String get hubYourNation => 'oma maasi';

  @override
  String get hubTakeTheJob => 'Ota tehtävä';

  @override
  String get hubFederationFinances => 'LIITON TALOUS';

  @override
  String get hubBudgetIntro =>
      'Ensimmäinen tehtäväsi ensi kaudella on määrittää liiton budjetti ja jakaa se osastoille.';

  @override
  String get hubStarting => 'Aloitetaan…';

  @override
  String get hubBeginNextCycle => 'Aloita seuraava kausi';

  @override
  String get hubContinueCareer => 'Jatka uraasi';

  @override
  String get hubBackToSaves => 'Takaisin tallennuksiin';

  @override
  String get hubOpeningBalance => 'Alkusaldo';

  @override
  String get hubCentralFunding => 'Keskitetty rahoitus';

  @override
  String get hubPrizeMoney => 'Palkintorahat';

  @override
  String get hubCommercialReturn => 'Kaupallinen tuotto';

  @override
  String get hubAvailableToInvest => 'Sijoitettavissa';

  @override
  String hubReputation(String label, int rep) {
    return 'Maine: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Kansallissankari';

  @override
  String get hubFinal => 'Finaali';

  @override
  String get hubStageRoundOf32 => '32 parhaan kierros';

  @override
  String get hubStageThirdPlace => 'Pronssiottelu';

  @override
  String get hubEventAdvanceWorld => 'Vie maailmaa eteenpäin';

  @override
  String hubEventStartCycle(int year) {
    return 'Aloita $year kausi';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Maailmanmestari: $nation';
  }

  @override
  String get hubEventSetBudget => 'Määritä liiton budjetti';

  @override
  String get hubEventSetBudgetSub =>
      'Jaa tämän kauden varat ennen sesongin alkua';

  @override
  String get hubEventNaturalization => 'Tarkista kansalaistamistarjous';

  @override
  String get hubEventNaturalizationSub =>
      'Ulkomaalainen pelaaja haluaa vaihtaa maajoukkueesi väreihin';

  @override
  String get hubEventCampaignVerdict => 'Kampanja ratkennut: katso tuomio';

  @override
  String get hubEventCampaignComplete => 'Kampanja päättynyt';

  @override
  String get hubEventIntercontinentalPlayoff =>
      'Maanosien välinen jatkokarsinta';

  @override
  String get hubEventWatchWcDraw => 'Katso MM-kisojen arvonta';

  @override
  String get hubEventWorldCupHere => 'MM-kisat alkavat';

  @override
  String get hubEventWatchFinalsDraw => 'Katso lopputurnauksen arvonta';

  @override
  String get hubEventFinalsHere => 'Lopputurnaus alkaa';

  @override
  String get hubEventPlayWcRound => 'Pelaa MM-kisojen seuraava kierros';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Pelaa seuraava ottelu: $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Pelaa seuraava Nations Cup -ottelu';

  @override
  String get hubEventWatchNationsCupDraw => 'Katso Nations Cupin arvonta';

  @override
  String get hubEventWatchHostSelection => 'Katso isäntämaan valinta';

  @override
  String get hubEventWatchQualifyingDraw => 'Katso karsintojen arvonta';

  @override
  String get hubEventWatchWcHostSelection =>
      'Katso MM-kisojen isäntämaan valinta';

  @override
  String get hubEventWatchWcQualifyingDraw => 'Katso MM-karsintojen arvonta';

  @override
  String get hubEventArrangeFriendlies => 'Sovi harjoitusotteluita';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Et ole vielä täyttänyt $count avointa harjoitusottelujaksoa',
      one: 'Et ole vielä täyttänyt avointa harjoitusottelujaksoa',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Muokkaa avauskokoonpanoa';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count avauspelaajistasi on poissa (pelikiellossa tai loukkaantunut). Valitse korvaajat',
      one:
          '1 avauspelaajistasi on poissa (pelikiellossa tai loukkaantunut). Valitse korvaaja',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Avauskokoonpanosta puuttuu pelaajia. Täytä vapaat paikat',
      one: 'Avauskokoonpanosta puuttuu pelaaja. Täytä vapaa paikka',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Pelaa: $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'mannerlopputurnaus';

  @override
  String get hubCallUpFriendlies => 'Nimeä joukkue harjoitusotteluihin';

  @override
  String get hubCallUpRequalify => 'Nimeä karsintajoukkue uudelleen';

  @override
  String get hubCallUpWorldCup => 'Nimeä MM-kisojen joukkue';

  @override
  String get hubCallUpFinals => 'Nimeä joukkue lopputurnaukseen';

  @override
  String get hubCallUpNationsCup => 'Nimeä Nations Cupin joukkue';

  @override
  String get hubCallUpQualifying => 'Nimeä karsintajoukkue';

  @override
  String get hubCallUpGeneric => 'Nimeä joukkue';

  @override
  String get hubHost => 'Isäntä';

  @override
  String get hubGoldenBoot => 'Kultainen kenkä';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals maalia';
  }

  @override
  String get hubPens => '(rp)';

  @override
  String get hubNationalHub => 'LIITON TOIMISTO';

  @override
  String get hubMessages => 'Viestit';

  @override
  String get hubWorldChampions => 'MAAILMANMESTARIT';

  @override
  String get hubViewBracket => 'Näytä kaavio ›';

  @override
  String get hubBoardDelighted => 'Haltioissaan';

  @override
  String get hubBoardPleased => 'Tyytyväinen';

  @override
  String get hubBoardExpectingMore => 'Odottaa enemmän';

  @override
  String get hubBoardConcerned => 'Huolissaan';

  @override
  String get hubBoardJobAtRisk => 'Työ vaarassa';

  @override
  String get hubBoard => 'HALLITUS';

  @override
  String hubBoardObjective(String label) {
    return 'Hallituksen tavoite: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'SAAVUTETTU · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'EPÄONNISTUI · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Ei enää otteluita tällä kaudella.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Maailmanranking';

  @override
  String get hubSquadStatus => 'JOUKKUEEN TILA';

  @override
  String hubPlayers(int count) {
    return '$count pelaajaa';
  }

  @override
  String get hubAvgRating => 'Ka. arvosana';

  @override
  String get hubMorale => 'Moraali';

  @override
  String get hubManageTeam => 'Hallinnoi joukkuetta';

  @override
  String get hubGroupsToBeDrawn =>
      'Lohkot arvotaan. Katso arvonta nähdäksesi ne.';

  @override
  String hubGroupName(String name) {
    return 'LOHKO $name';
  }

  @override
  String get hubTblTeam => 'JOUKKUE';

  @override
  String get hubTblP => 'O';

  @override
  String get hubTblGd => '+/-';

  @override
  String get hubTblPts => 'P';

  @override
  String get homeSettings => 'Asetukset';

  @override
  String get homeLeadTheNation => 'JOHDA MAATASI';

  @override
  String get homeYourNation => 'oma maasi';

  @override
  String get homeNewGame => 'Uusi peli';

  @override
  String get homeAllSaves => 'Kaikki tallennukset';

  @override
  String get homeLoadGame => 'Lataa peli';

  @override
  String get homeContinue => 'JATKA';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Tie $year MM-kisoihin';
  }

  @override
  String get careerManageSaves => 'Hallitse tallennuksia';

  @override
  String get careerNewGameTitle => 'UUSI PELI';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Maata ei voitu ladata.\n$error';
  }

  @override
  String get careerNationNotFound => 'Maata ei löytynyt.';

  @override
  String careerWorldRankNum(int rank) {
    return 'MAAILMANRANKING #$rank';
  }

  @override
  String get careerManagerName => 'Valmentajan nimi';

  @override
  String get careerManagerNameHint => 'esim. Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Urasi alkaa syyskuussa 2026, matkalla vuoden 2030 MM-kisoihin.';

  @override
  String get careerFreeCycleNote =>
      'Ilmainen yhden täyden nelivuotiskauden ajan: karsinnat, mannerkisasi ja MM-kisat, kahdella tallennuksella. Sen jälkeen kertamaksu avaa loputtomat kaudet.';

  @override
  String get careerStartCareer => 'Aloita ura';

  @override
  String get careersTitle => 'URAT';

  @override
  String get careerManagerCareer => 'Valmentajaura';

  @override
  String get careerManagerCareerSubtitle =>
      'Kaikki valmentamasi kaudet ja kokonaistilastosi';

  @override
  String get careerSummaryTitle => 'Uran yhteenveto';

  @override
  String get careerSummarySubtitle => 'Pokaalikaappisi ja valmentajatilastosi';

  @override
  String get careerAchievements => 'Saavutukset';

  @override
  String get careerAchievementsSubtitle =>
      'Virstanpylväät, tittelit ja hallituksen tyytyväisyys';

  @override
  String get careerChallenges => 'Haasteet';

  @override
  String get careerChallengesSubtitle =>
      'Raakoja koko uran mittaisia koitoksia';

  @override
  String get careerTeamRecords => 'Joukkueen ennätykset';

  @override
  String get careerTeamRecordsSubtitle =>
      'Kaikkien aikojen maalintekijät ja pelatut ottelut';

  @override
  String get careerMyMatches => 'Ottelusi';

  @override
  String get careerMyMatchesSubtitle => 'Kaikki tulokset ja tulevat ottelut';

  @override
  String get careerTitle => 'URA';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Uran lataus epäonnistui.\n$error';
  }

  @override
  String get careerNoCareer => 'Ei uraa.';

  @override
  String get careerTrophyCabinet => 'POKAALIKAAPPI';

  @override
  String get careerTournamentHistory => 'TURNAUSHISTORIA';

  @override
  String get careerNoTournamentsYet => 'Ei vielä päättyneitä turnauksia.';

  @override
  String get careerTeamFallback => 'Joukkue';

  @override
  String careerWorldNum(int rank) {
    return 'MAAILMAN #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points P';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SESONKI $season';
  }

  @override
  String get careerStatPlayedShort => 'O';

  @override
  String get careerStatsHeading => 'LUKUJEN VALOSSA';

  @override
  String get careerStatsWinRate => 'Voittoprosentti';

  @override
  String get careerStatsGoalsFor => 'Tehdyt maalit';

  @override
  String get careerStatsGoalsAgainst => 'Päästetyt maalit';

  @override
  String get careerStatsGoalDiff => 'Maaliero';

  @override
  String get careerStatsCleanSheets => 'Nollapelit';

  @override
  String get careerStatsBiggestWin => 'Suurin voitto';

  @override
  String get careerStatsWinStreak => 'Voittoputki';

  @override
  String get careerStatsUnbeaten => 'Tappioton putki';

  @override
  String get careerStatsShootouts => 'Rangaistuspotkukilpailut';

  @override
  String get careerStatsHatTricks => 'Hattutempuut';

  @override
  String get careerStatsMotms => 'Ottelun paras';

  @override
  String get careerStatsBestRating => 'Paras arvosana';

  @override
  String get careerStatWonShort => 'V';

  @override
  String get careerStatDrawnShort => 'T';

  @override
  String get careerStatLostShort => 'H';

  @override
  String get careerStatGoalsForShort => 'TM';

  @override
  String get careerStatGoalsAgainstShort => 'PM';

  @override
  String get careerStatGoalDiffShort => '+/-';

  @override
  String get careerNoSilverware =>
      'Ei vielä pokaaleja. Mene ja voita sellainen.';

  @override
  String get careerMedalGold => 'KULTA';

  @override
  String get careerMedalSilver => 'HOPEA';

  @override
  String get careerMedalBronze => 'PRONSSI';

  @override
  String careerWinnersName(String name) {
    return 'Voittaja: $name';
  }

  @override
  String get careerSavesTitle => 'TALLENNUKSET';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Tallennusten lataus epäonnistui.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'PAIKAT  $used/$limit';
  }

  @override
  String get careerThisSave => 'tämä tallennus';

  @override
  String get careerSlotsFull => 'Paikat täynnä';

  @override
  String careerSlotsUsed(int used) {
    return 'PAIKAT  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'Avaa lisää tallennuksia';

  @override
  String get careerSlotsKeepNote =>
      'Kaikki nykyiset tallennuksesi pysyvät pelattavina. Vain uusi vaatii avaamisen.';

  @override
  String get careerNewGame => 'Uusi peli';

  @override
  String get careerDeleteSaveTitle => 'Poistetaanko tallennus?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Tämä poistaa pysyvästi uran: $label.';
  }

  @override
  String get careerCancel => 'Peruuta';

  @override
  String get careerDelete => 'Poista';

  @override
  String get careerNoSavesYet =>
      'Ei vielä tallennuksia.\nAloita uusi peli johtaaksesi maata.';

  @override
  String get careerUnknownNation => 'Tuntematon';

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
    return 'Viimeksi pelattu $when';
  }

  @override
  String get careerJustNow => 'juuri nyt';

  @override
  String get careerYesterday => 'eilen';

  @override
  String careerMinutesAgo(int n) {
    return '$n min sitten';
  }

  @override
  String careerHoursAgo(int n) {
    return '$n h sitten';
  }

  @override
  String careerDaysAgo(int n) {
    return '$n pv sitten';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Matkalla vuoden $year MM-kisoihin';
  }

  @override
  String get careerManagerCareerTitle => 'VALMENTAJAURA';

  @override
  String careerCouldNotLoad(String error) {
    return 'Lataus epäonnistui.\n$error';
  }

  @override
  String get careerCycleByCycle => 'KAUSI KAUDELTA';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles kautta',
      one: '1 kausi',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations johdettua maata',
      one: '1 johdettu maa',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Tittelit';

  @override
  String get careerStatPlayed => 'Ottelut';

  @override
  String get careerStatWon => 'Voitot';

  @override
  String get careerStatDrawn => 'Tasapelit';

  @override
  String get careerStatLost => 'Tappiot';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Maalit $goalsFor–$goalsAgainst  ($gd)  ·  Voittoprosentti $winRate %';
  }

  @override
  String get careerRecordResults => 'ENNÄTYSTULOKSET';

  @override
  String get careerBestWin => 'Paras voitto';

  @override
  String get careerWorstDefeat => 'Pahin tappio';

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
    return '${won}V ${drawn}T ${lost}H  ·  TM $goalsFor PM $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'MM-kisat';

  @override
  String get careerContinentalLabel => 'Mannerkisat';

  @override
  String get messagesTitle => 'VIESTIT';

  @override
  String get messagesNoMessagesYet => 'Ei vielä viestejä.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Viestien lataus epäonnistui.\n$error';
  }

  @override
  String get messagesDone => 'Valmis';

  @override
  String get messagesNext => 'Seuraava';

  @override
  String get rankingWorldRanking => 'MAAILMANRANKING';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Rankingin lataus epäonnistui.\n$error';
  }

  @override
  String get rankingNoRanking => 'Ei rankingia.';

  @override
  String get rankingAll => 'KAIKKI';

  @override
  String get rankingYourTeam => 'SINUN JOUKKUEESI';

  @override
  String get rankingYourRankingOverTime => 'RANKINGISI AJAN YLI';

  @override
  String rankingNowRank(int rank) {
    return 'nyt #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'paras #$best · huonoin #$worst';
  }

  @override
  String get friendliesTitle => 'HARJOITUSOTTELUT';

  @override
  String friendliesLoadError(String error) {
    return 'Harjoitusottelujen lataus epäonnistui.\n$error';
  }

  @override
  String get friendliesContinue => 'Jatka';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vapaaseen ikkunaan',
      one: '1 vapaaseen ikkunaan',
    );
    return 'Sovi lämmittelyistä $_temp0 ennen seuraavaa kilpaottelua. Napauta vastustajaa tai jätä ikkuna vapaaksi.';
  }

  @override
  String get friendliesFree => 'Vapaa';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count MAALIA',
      one: '1 MAALI',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'MAALIT';

  @override
  String get matchGoalsNone => 'Ei maaleja';

  @override
  String get matchGoalPenalty => 'RP';

  @override
  String get matchGoalSetPiece => 'VT';

  @override
  String matchGoalAssist(String name) {
    return 'syöttö $name';
  }

  @override
  String get friendliesHome => 'KOTI';

  @override
  String get friendliesAway => 'VIERAS';

  @override
  String get friendliesNoneThisWindow => 'Ei harjoitusotteluja tässä ikkunassa';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count harjoitusottelua',
      one: '1 harjoitusottelu',
    );
    return 'Vahvista $_temp0';
  }

  @override
  String get friendliesMonthJan => 'Tammi';

  @override
  String get friendliesMonthFeb => 'Helmi';

  @override
  String get friendliesMonthMar => 'Maalis';

  @override
  String get friendliesMonthApr => 'Huhti';

  @override
  String get friendliesMonthMay => 'Touko';

  @override
  String get friendliesMonthJun => 'Kesä';

  @override
  String get friendliesMonthJul => 'Heinä';

  @override
  String get friendliesMonthAug => 'Elo';

  @override
  String get friendliesMonthSep => 'Syys';

  @override
  String get friendliesMonthOct => 'Loka';

  @override
  String get friendliesMonthNov => 'Marras';

  @override
  String get friendliesMonthDec => 'Joulu';

  @override
  String get resultsMyMatches => 'OTTELUSI';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Tulosten lataus epäonnistui.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Ei otteluita.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'KARSINTA';

  @override
  String get resultsStageFriendly => 'HARJOITUSOTTELU';

  @override
  String get resultsStageGroupStage => 'LOHKOVAIHE';

  @override
  String get resultsStageSemiFinal => 'VÄLIERÄ';

  @override
  String get resultsStageFinal => 'FINAALI';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'LOPPUTURNAUKSEN LOHKO';

  @override
  String get resultsStageRoundOf32 => '32 PARHAAN KIERROS';

  @override
  String get resultsStageRoundOf16 => 'KAHDEKSANNESFINAALI';

  @override
  String get resultsStageQuarterFinal => 'PUOLIVÄLIERÄ';

  @override
  String get resultsStageThirdPlace => 'PRONSSIOTTELU';

  @override
  String get matchSetupWarnCaptain =>
      'Kapteenia ei ole nimetty. Napauta antaaksesi kapteenin nauhan jollekulle';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return '$name on loukkaantunut eikä voi johtaa joukkuetta kentälle. Napauta antaaksesi nauhan toiselle';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return '$name on pelikiellossa tämän ottelun. Napauta antaaksesi nauhan toiselle';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return '$name on kapteeni mutta ei ole kokoonpanossasi. Napauta antaaksesi nauhan toiselle';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Vakiotilanteiden pelaajia ei ole nimetty. Napauta valitaksesi, kuka astuu esiin';

  @override
  String get matchSetupWarnBoth =>
      'Ei kapteenia eikä vakiotilanteiden pelaajia. Napauta asettaaksesi ne';

  @override
  String matchStageMatchday(int matchday) {
    return 'OP $matchday';
  }

  @override
  String get squadCaptain => 'Kapteeni';

  @override
  String deptEffectYouth(int points) {
    return 'Akatemian lupaukset ovat noin $points kokonaistasoa parempia';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount takaisin kauden lopussa';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent % vähemmän loukkaantumisia';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent % todennäköisyys, että ulkomaalainen pelaaja pyytää vaihtoa';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points hallituksen kärsivällisyyttä ennen kuin paikkasi on vaarassa';
  }

  @override
  String get deptEffectNone => 'Ei vaikutusta ilman rahoitusta';

  @override
  String get statsBestRated => 'Arvosanat';

  @override
  String get statsMyCareer => 'Ura';

  @override
  String get statsBestAverageRating => 'PARAS KESKIARVOSANA';

  @override
  String get statsMyCareerRecord => 'TILASTOSI';

  @override
  String get statsNoRatingsRecorded =>
      'Ei vielä tallennettuja ottelun arvosanoja.';

  @override
  String get statsGroupRecord => 'Tilasto';

  @override
  String get statsGroupRuns => 'Putket';

  @override
  String get statsGroupExtremes => 'Ääripäät';

  @override
  String get statsGroupSplits => 'Koti ja vieras';

  @override
  String get statsGroupSquad => 'Pelaajasi';

  @override
  String get statsPlayed => 'Pelatut ottelut';

  @override
  String get statsWinDrawLoss => 'Voitot–tasapelit–tappiot';

  @override
  String get statsWinRate => 'Voittoprosentti';

  @override
  String get statsGoals => 'Tehdyt:päästetyt maalit';

  @override
  String get statsCleanSheets => 'Nollapelit';

  @override
  String get statsFailedToScore => 'Ilman maalia';

  @override
  String get statsLongestWinStreak => 'Pisin voittoputki';

  @override
  String get statsLongestUnbeaten => 'Pisin tappioton putki';

  @override
  String get statsLongestCleanSheets => 'Pisin nollapeliputki';

  @override
  String get statsLongestWinless => 'Pisin voitoton putki';

  @override
  String get statsCurrentRun => 'Nykyinen tappioton putki';

  @override
  String get statsBiggestWin => 'Suurin voitto';

  @override
  String get statsHeaviestDefeat => 'Raskain tappio';

  @override
  String get statsMostGoalsInAGame => 'Eniten maaleja ottelussa';

  @override
  String get statsShootouts => 'Rangaistuspotkukilpailut voitot–tappiot';

  @override
  String get statsComebackWins => 'Voitot takaa-ajosta';

  @override
  String get statsHome => 'Koti';

  @override
  String get statsAway => 'Vieras';

  @override
  String get statsNeutral => 'Neutraali';

  @override
  String get statsCompetitive => 'Kilpaottelut';

  @override
  String get statsFriendlies => 'Harjoitusottelut';

  @override
  String get statsHatTricks => 'Hattutempuut';

  @override
  String get statsBraces => 'Kaksi maalia';

  @override
  String get statsMotms => 'Ottelun paras -palkinnot';

  @override
  String get statsAssists => 'Syötöt';

  @override
  String get statsCards => 'Kortit';

  @override
  String get statsBestRating => 'Paras yksittäinen arvosana';

  @override
  String statsAppsShort(int apps) {
    return '$apps ottelua';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms OP';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent => 'Kapteeni. Napauta poistaaksesi nauhan';

  @override
  String get captainFitBorn => 'Syntynyt johtaja';

  @override
  String get captainFitNatural => 'Luonteva kapteeni';

  @override
  String get captainFitCapable => 'Kelpaisi tehtävään';

  @override
  String get captainFitUnproven => 'Ei vielä johtaja';

  @override
  String get captainNone => 'Kapteenia ei nimetty';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale joukkueen moraalia';
  }

  @override
  String get resultsCategoryWorldCupQualifying => 'MM-karsinnat';

  @override
  String get resultsCategoryFriendlies => 'Harjoitusottelut';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Mannercup';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'MM-kars.';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Mannercup-kars.';

  @override
  String get resultsCategoryContinentalQualifying => 'Mannercupin karsinnat';

  @override
  String get resultsCategoryWorldCupFinals => 'MM-lopputurnaus';

  @override
  String get resultsRoundResults => 'KIERROKSEN TULOKSET';

  @override
  String get resultsFriendlyInternationals => 'HARJOITUSMAAOTTELUT';

  @override
  String get resultsKnockout => 'Pudotuspelit';

  @override
  String resultsEarlierMatches(int count) {
    return 'Aiemmat ottelut ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'OTTELUPÄIVÄ $matchday';
  }

  @override
  String get resultsContinue => 'Jatka';

  @override
  String resultsGroup(String name) {
    return 'LOHKO $name';
  }

  @override
  String get achievementsScreenTitle => 'SAAVUTUKSET';

  @override
  String get achievementsChallengesTooltip => 'Haasteet';

  @override
  String get achievementsChallengesHeading => 'HAASTEET';

  @override
  String get achievementsBrutalTests => 'Raakoja koko uran mittaisia koitoksia';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Lataus epäonnistui.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total avattu';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total voitettu';
  }

  @override
  String get achievementsBoardSatisfaction => 'HALLITUKSEN TYYTYVÄISYYS';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SAAVUTUSTA AVATTU',
      one: 'SAAVUTUS AVATTU',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Voitot';

  @override
  String get achCatMatches => 'Ottelut';

  @override
  String get achCatQualifications => 'Karsinnat';

  @override
  String get achCatTitles => 'Tittelit';

  @override
  String get achCatMisc => 'Muut';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Maalit';

  @override
  String get achCatStreaks => 'Putket';

  @override
  String get achTierBronze => 'Pronssi';

  @override
  String get achTierSilver => 'Hopea';

  @override
  String get achTierGold => 'Kulta';

  @override
  String get achTierPlatinum => 'Platina';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maalia',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tee $count maalia.',
      one: 'Tee 1 maali.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nollapeliä',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pidä $count nollapeliä.',
      one: 'Pidä 1 nollapeli.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Voittamisen tapa';

  @override
  String get achStreakWin5Desc => 'Voita viisi ottelua peräkkäin.';

  @override
  String get achStreakWin10 => 'Vauhdissa';

  @override
  String get achStreakWin10Desc => 'Voita kymmenen ottelua peräkkäin.';

  @override
  String get achStreakWin20 => 'Jyrä';

  @override
  String get achStreakWin20Desc => 'Voita kaksikymmentä ottelua peräkkäin.';

  @override
  String get achUnbeaten15 => 'Vaikea kaataa';

  @override
  String get achUnbeaten15Desc => 'Pelaa viisitoista ottelua ilman tappiota.';

  @override
  String get achUnbeaten30 => 'Koskematon';

  @override
  String get achUnbeaten30Desc => 'Pelaa kolmekymmentä ottelua ilman tappiota.';

  @override
  String get achHattrick => 'Hattutemppujen sankari';

  @override
  String get achHattrickDesc => 'Anna pelaajan tehdä hattutemppu.';

  @override
  String get achMotm10 => 'Erottuja';

  @override
  String get achMotm10Desc => 'Kerää 10 ottelun parhaan palkintoa.';

  @override
  String get achMotm50 => 'Talismaani';

  @override
  String get achMotm50Desc => 'Kerää 50 ottelun parhaan palkintoa.';

  @override
  String get achPerfect => 'Täydellinen kymppi';

  @override
  String get achPerfectDesc =>
      'Anna pelaajan saada ottelusta arvosana 9,5 tai yli.';

  @override
  String get achShootout => 'Jäätä suonissa';

  @override
  String get achShootoutDesc => 'Voita viisi rangaistuspotkukilpailua.';

  @override
  String get achMassacre => 'Verilöyly';

  @override
  String get achMassacreDesc => 'Voita ottelu vähintään 7 maalin erolla.';

  @override
  String get achAnnihilation => 'Tuho';

  @override
  String get achAnnihilationDesc => 'Voita ottelu vähintään 10 maalin erolla.';

  @override
  String get chTierBronze => 'Pronssi';

  @override
  String get chTierSilver => 'Hopea';

  @override
  String get chTierGold => 'Kulta';

  @override
  String get chTierLegendary => 'Legendaarinen';

  @override
  String get chFirstSteps => 'Vaihtopenkillä';

  @override
  String get chFirstStepsDesc => 'Valmenna 5 vuotta.';

  @override
  String get chUnbeaten10 => 'Vauhdissa';

  @override
  String get chUnbeaten10Desc =>
      'Pelaa 10 kilpailullista ottelua ilman tappiota.';

  @override
  String get chTwoNations => 'Uusi haaste';

  @override
  String get chTwoNationsDesc => 'Valmenna 2 eri maata.';

  @override
  String get chCont1 => 'Mannermestari';

  @override
  String get chCont1Desc => 'Voita mannerkisat.';

  @override
  String get chNc1 => 'Nations Cupin voittaja';

  @override
  String get chNc1Desc => 'Voita Nations Cup.';

  @override
  String get chWc1 => 'Maailmanmestari';

  @override
  String get chWc1Desc => 'Voita MM-kisat.';

  @override
  String get chYears25 => 'Vakiintunut';

  @override
  String get chYears25Desc => 'Valmenna 25 vuotta.';

  @override
  String get chWc3 => 'Sarjavoittaja';

  @override
  String get chWc3Desc => 'Voita 3 MM-kisaa.';

  @override
  String get chWc5 => 'Dynastia';

  @override
  String get chWc5Desc => 'Voita 5 MM-kisaa.';

  @override
  String get chWc10 => 'Kuolematon';

  @override
  String get chWc10Desc => 'Voita 10 MM-kisaa.';

  @override
  String get chWc2Teams => 'Kengät jalassa maailmalle';

  @override
  String get chWc2TeamsDesc => 'Voita MM-kisat 2 eri maalla.';

  @override
  String get chWc3Teams => 'Maailmanmatkaaja';

  @override
  String get chWc3TeamsDesc => 'Voita MM-kisat 3 eri maalla.';

  @override
  String get chWcStreak3 => 'Kolmen putki';

  @override
  String get chWcStreak3Desc => 'Voita 3 MM-kisaa peräkkäin.';

  @override
  String get chWcAllconf => 'Maailmanvalloittaja';

  @override
  String get chWcAllconfDesc =>
      'Voita MM-kisat maalla jokaisesta mannerliitosta (6).';

  @override
  String get chCont5 => 'Mannerten kuningas';

  @override
  String get chCont5Desc => 'Voita 5 mannerkisaa.';

  @override
  String get chContAll => 'Kuuden mantereen slam';

  @override
  String get chContAllDesc => 'Voita jokaisen mannerliiton mannerkisat (6).';

  @override
  String get chTreble => 'Puhdas pyyhkäisy';

  @override
  String get chTrebleDesc =>
      'Voita MM-kisat, mannerkisat ja Nations Cup yhdellä uralla.';

  @override
  String get chNations10 => 'Nomadi';

  @override
  String get chNations10Desc => 'Valmenna 10 eri maata.';

  @override
  String get chYears100 => 'Vuosisata';

  @override
  String get chYears100Desc => 'Valmenna 100 vuotta.';

  @override
  String get chYears500 => 'Puoli vuosituhatta';

  @override
  String get chYears500Desc => 'Valmenna 500 vuotta.';

  @override
  String get chYears1000 => 'Ikuisuus';

  @override
  String get chYears1000Desc => 'Valmenna 1000 vuotta.';

  @override
  String get chGrandmaster => 'Suurmestari';

  @override
  String get chGrandmasterDesc => 'Voita 3 MM-kisaa JA 5 mannerkisaa.';

  @override
  String get chUndefeated => 'Koskematon';

  @override
  String get chUndefeatedDesc => 'Voita MM-kisat kadottamatta yhtään ottelua.';

  @override
  String get chPerfectQual => 'Moitteeton matka';

  @override
  String get chPerfectQualDesc => 'Voita jokainen MM-karsintakampanjan ottelu.';

  @override
  String get chMinnow => 'Pikkumaan ihme';

  @override
  String get chMinnowDesc =>
      'Voita MM-kisat maalla, joka on maailmanrankingissa 32 parhaan ulkopuolella.';

  @override
  String get chGrandTour => 'Koti ja vieras';

  @override
  String get chGrandTourDesc =>
      'Voita MM-kisat isäntänä ja voita ne myös vieraissa.';

  @override
  String get chUnbeaten25 => 'Muuri';

  @override
  String get chUnbeaten25Desc =>
      'Pelaa 25 kilpailullista ottelua ilman tappiota.';

  @override
  String get chGoals10k => 'Maalikone';

  @override
  String get chGoals10kDesc => 'Tee 10 000 maalia urallasi.';

  @override
  String get chCleanSheets500 => 'Linnake';

  @override
  String get chCleanSheets500Desc => 'Pidä 500 nollapeliä urallasi.';

  @override
  String get chHatTricks25 => 'Hattutemppujen tekijä';

  @override
  String get chHatTricks25Desc => 'Anna pelaajiesi tehdä 25 hattutemppua.';

  @override
  String get chWinStreak25 => 'Pysäyttämätön';

  @override
  String get chWinStreak25Desc => 'Voita 25 ottelua peräkkäin.';

  @override
  String get chCont10 => 'Mannerdynastia';

  @override
  String get chCont10Desc => 'Voita 10 mannerkisaa.';

  @override
  String get chPcWc => 'Sarjamestari';

  @override
  String chPcWcDesc(int count) {
    return 'Voita $count MM-kisaa tällä tallennuksella.';
  }

  @override
  String get chPcMajors => 'Pokaalinkerääjä';

  @override
  String chPcMajorsDesc(int count) {
    return 'Voita $count suurta pokaalia (MM-kisat, mannerkisat tai Nations Cup).';
  }

  @override
  String get chPcUnbeaten => 'Rautamuuri';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Pelaa $count kilpailullista ottelua ilman tappiota.';
  }

  @override
  String get chPcNations => 'Kisälli';

  @override
  String chPcNationsDesc(int count) {
    return 'Valmenna $count eri maata.';
  }

  @override
  String get chPcYears => 'Pitkä taival';

  @override
  String chPcYearsDesc(int count) {
    return 'Valmenna $count vuotta.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count voittoa',
      one: '1 voitto',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Voita $count ottelua.',
      one: 'Voita 1 ottelu.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ottelua',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pelaa $count ottelua.',
      one: 'Pelaa 1 ottelu.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'MM-kisojen karsiutuja';

  @override
  String get achQualWcDesc => 'Selviä MM-kisoihin.';

  @override
  String get achQualCont => 'Mannerkisojen karsiutuja';

  @override
  String get achQualContDesc => 'Selviä mannerkisoihin.';

  @override
  String get achTitleWc => 'Maailmanmestarit';

  @override
  String get achTitleWcDesc => 'Voita MM-kisat.';

  @override
  String get achTitleEuro => 'Euroopan mestarit';

  @override
  String get achTitleEuroDesc => 'Voita EM-kisat.';

  @override
  String get achTitleCopa => 'Etelä-Amerikan mestarit';

  @override
  String get achTitleCopaDesc => 'Voita Etelä-Amerikan Cup.';

  @override
  String get achTitleAfcon => 'Afrikan mestarit';

  @override
  String get achTitleAfconDesc => 'Voita Afrikan mestaruuskilpailut.';

  @override
  String get achTitleAsia => 'Aasian mestarit';

  @override
  String get achTitleAsiaDesc => 'Voita Aasian mestaruuskilpailut.';

  @override
  String get achTitleConcacaf => 'Pohjois-Amerikan mestarit';

  @override
  String get achTitleConcacafDesc => 'Voita Pohjois-Amerikan Cup.';

  @override
  String get achTitleOfc => 'Oseanian mestarit';

  @override
  String get achTitleOfcDesc => 'Voita Oseanian Cup.';

  @override
  String get achTitleNations => 'Nations Cupin voittajat';

  @override
  String get achTitleNationsDesc => 'Voita Nations Cup.';

  @override
  String get achTitleClash => 'Continental Clashin voittajat';

  @override
  String get achTitleClashDesc => 'Voita Continental Clash.';

  @override
  String get achMarksman => 'MM-kisojen tarkka-ampuja';

  @override
  String get achMarksmanDesc =>
      'Anna joukkueesi pelaajan tehdä 6 tai enemmän MM-lopputurnauksen maalia.';

  @override
  String get achSweep => 'Puhdas pyyhkäisy';

  @override
  String get achSweepDesc => 'Voita MM-kisat ja mannertitteli yhdellä uralla.';

  @override
  String get achAllstar => 'Turnauksen tähti';

  @override
  String get achAllstarDesc => 'Saa pelaaja MM-kisojen tähdistökokoonpanoon.';

  @override
  String get achGoldenboot => 'Kultainen kenkä';

  @override
  String get achGoldenbootDesc => 'Anna maasi päättää turnaus maalikuninkaana.';

  @override
  String get achDemolition => 'Murskaus';

  @override
  String get achDemolitionDesc => 'Voita ottelu vähintään 5 maalin erolla.';

  @override
  String get achievementsNice => 'Hienoa!';

  @override
  String get achievementsHardestTests =>
      'Valmentajan kovimmat koitokset, koko uran ja monen maan aikana.';

  @override
  String get achievementsThisSave => 'TÄMÄ TALLENNUS';

  @override
  String get achievementsBrutalBadge => 'RAAKA';

  @override
  String get paywallGoPro => 'HANKI UNLIMITED';

  @override
  String get paywallOneTimeUnlock => 'Kertaosto. Ei tilausta.';

  @override
  String get paywallBenefitCarryOn =>
      'Tämä tallennus jatkuu täsmälleen siitä, mihin se jäi, kaikki maaottelut, ennätykset ja kilpailuasetelmat tallella.';

  @override
  String get paywallBenefitNoAds =>
      'Ei mainoksia, ei mikromaksuja, ei tilausta. Yksi maksu, ja jokainen tuleva päivitys on sinun.';

  @override
  String get paywallBenefitSaves =>
      'Niin monta tallennusta kuin haluat. Pidä yhtä suosikkia ja yhtä pikkumaata yhtä aikaa ja katso, kuinka eri tavalla sama peli tuntuu.';

  @override
  String get paywallBenefitEndless =>
      'Jokainen kausi tästä eteenpäin. Valitse tänään seitsemäntoistavuotias ja saat selville vuonna 2034, osuiko arviosi oikeaan.';

  @override
  String get paywallUnlocked => 'Unlimited on avattu. Nauti!';

  @override
  String get paywallContactingStore => 'Otetaan yhteyttä kauppaan…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'Avaa Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Palauta ostokset';

  @override
  String get paywallStoreUnavailable => 'Kauppa ei ole käytettävissä';

  @override
  String get paywallStoreUnavailableNote =>
      'Hintaa ei voitu ladata. Tarkista yhteytesi ja yritä uudelleen.';

  @override
  String get paywallTryAgain => 'Yritä uudelleen';

  @override
  String get gateTitle => 'ENSIMMÄINEN KAUTESI ON PÄÄTTYNYT';

  @override
  String get gateLead =>
      'Neljä vuotta on yksi kausi. Se ei riitä selvittämään, olitko oikeassa.';

  @override
  String get gatePriceLead => 'Yksi maksu, ikuisesti';

  @override
  String get gateBuy => 'OSTA JA JATKA';

  @override
  String get gateExit => 'POISTU';

  @override
  String get gateSaveTitle => 'TÄMÄ TALLENNUS VAATII PRON';

  @override
  String get gateSaveLead =>
      'Ilmaisen kauden jälkeiset tallennukset ja Pro-kampanjat jatkuvat Prolla. Mitään ei menetetä: tallennus odottaa juuri sellaisena kuin jätit sen.';

  @override
  String get careerSaveLockedNote => 'Tallennuksen jatkaminen vaatii Pron';

  @override
  String get federationNaturalisation => 'KANSALAISTAMINEN';

  @override
  String federationNaturalisedTitle(String name) {
    return '$name kansalaistettu';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return '$name on saanut vaihdon päätökseen ja on nyt pelikelpoinen. Maa: $nation. Kutsu hänet joukkueeseen kokoonpanon valinnassa.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Tarjouksen lataus epäonnistui.\n$error';
  }

  @override
  String get federationContinue => 'Jatka';

  @override
  String get federationOfferToSwitchAllegiance =>
      'TARJOUS VAIHTAA EDUSTETTAVAA MAATA';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · ikä $age · maa: $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return '$name on valmis kansalaistumaan, ja hänellä on siteitä tähän maahan: $playerNation. Hyväksy, niin hänet voi valita joukkueeseen. Hylkää, niin hän jää edustamaan maata: $sourceNation.';
  }

  @override
  String get federationDecline => 'Hylkää';

  @override
  String get federationNaturalise => 'Kansalaista';

  @override
  String get federationBudgetLater => 'Päätä myöhemmin';

  @override
  String get federationSetYourBudget => 'ASETA BUDJETTISI';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Talouden lataus epäonnistui.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Tallennusta ei löytynyt.';

  @override
  String get federationBudgetHeading => 'LIITON BUDJETTI';

  @override
  String federationDistributeBudget(String amount) {
    return 'Jaa $amount osastoille kauden avaamiseksi. Käytä rahat viisaasti.';
  }

  @override
  String federationOverBudget(String amount) {
    return '$amount enemmän kuin liitolla on. Ota osa takaisin';
  }

  @override
  String get federationAllocateFullBudget =>
      'Jaa koko budjetti aloittaaksesi kauden.';

  @override
  String get federationConfirming => 'Vahvistetaan…';

  @override
  String get federationConfirmBudget => 'Vahvista budjetti';

  @override
  String get federationFinances => 'TALOUS';

  @override
  String get federationInvestmentUpdated => 'Sijoitus päivitetty.';

  @override
  String get federationDevelopment => 'LIITON KEHITYS';

  @override
  String get federationProjectedAtSeasonEnd => 'ENNUSTE SESONGIN LOPUSSA';

  @override
  String get federationCentralFunding => 'Keskusrahoitus';

  @override
  String get federationPrizeMoneySoFar => 'Palkintorahat toistaiseksi';

  @override
  String get federationCommercialReturn => 'Kaupallinen tuotto';

  @override
  String get federationThisSeasonLocked => 'TÄMÄ SESONKI (LUKITTU)';

  @override
  String get federationInvestForNextSeason => 'SIJOITA SEURAAVAAN SESONKIIN';

  @override
  String get federationNextSeasonImpact => 'SEURAAVAN SESONGIN VAIKUTUS';

  @override
  String get federationSaving => 'Tallennetaan…';

  @override
  String get federationConfirmInvestment => 'Vahvista sijoitus';

  @override
  String get federationBalance => 'LIITON SALDO';

  @override
  String get federationCommittedToStaff => 'Sidottu henkilöstöön';

  @override
  String get federationFreeToSpend => 'Vapaasti käytettävissä';

  @override
  String get federationWagesNote =>
      'Palkat vähennetään saldosta kauden lopussa, joten tämä summa on jo varattu.';

  @override
  String get federationInvestAtCeremony =>
      'Sijoita seuraavaan sesonkiin kauden päätösseremoniassa.';

  @override
  String federationLevelBadge(int level) {
    return 'L$level';
  }

  @override
  String get federationAcademyProspects => 'Akatemian lupaukset';

  @override
  String federationPlusOverall(int value) {
    return '+$value kokonaistaso';
  }

  @override
  String get federationInjuryRisk => 'Loukkaantumisriski';

  @override
  String get federationNaturalisationChance =>
      'Kansalaistamisen todennäköisyys';

  @override
  String get federationBoardPatience => 'Hallituksen kärsivällisyys';

  @override
  String get federationUnallocated => 'JAKAMATTA';

  @override
  String get nationsVitrineTitle => 'MAAN VITRIINI';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Maan lataus epäonnistui.\n$error';
  }

  @override
  String get nationsNoNation => 'Ei maata.';

  @override
  String get nationsHonours => 'KUNNIAPALKINNOT';

  @override
  String get nationsRankingHistory => 'MAAILMANRANKINGIN HISTORIA';

  @override
  String get nationsTopScorers => 'KAIKKIEN AIKOJEN MAALIPÖRSSI';

  @override
  String get nationsTitles => 'MESTARUUDET';

  @override
  String get nationsYourTeam => 'SINUN JOUKKUEESI';

  @override
  String get nationsWorld => 'MAAILMA';

  @override
  String get nationsWorldCup => 'MM-kisat';

  @override
  String get nationsContinental => 'Mannerturnaus';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count osallistumista',
      one: '1 osallistuminen',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Historiaa ei vielä ole tarpeeksi. Palaa takaisin kauden tai parin päästä.';

  @override
  String nationsBestRank(int rank) {
    return 'Paras: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Nyt: #$rank';
  }

  @override
  String get nationsNoGoals => 'Maaleja ei ole vielä kirjattu.';

  @override
  String get nationsGoalsAbbrev => 'ml';

  @override
  String get nationsHosts => 'ISÄNTÄ';

  @override
  String get nationsSelectTitle => 'VALITSE MAAJOUKKUE';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Maiden lataus epäonnistui.\n$error';
  }

  @override
  String get nationsNoMatch => 'Ei hakua vastaavia maita.';

  @override
  String get nationsSelectHeading => 'Valitse maajoukkue';

  @override
  String get nationsSearchHint => 'Hae maata…';

  @override
  String get nationsRank => 'SIJA ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'VALITSE';

  @override
  String get statsTeamRecords => 'JOUKKUEEN ENNÄTYKSET';

  @override
  String get statsRecordBook => 'Ennätyskirja';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Tilastojen lataus epäonnistui.\n$error';
  }

  @override
  String get statsNoData => 'Ei tietoja.';

  @override
  String get statsTopScorers => 'MAALIPÖRSSI';

  @override
  String get statsMostGamesPlayed => 'ENITEN OTTELUITA';

  @override
  String get statsTeam => 'Joukkue';

  @override
  String get statsTopScorersShort => 'Maalintekijät';

  @override
  String get statsMostGames => 'Eniten otteluita';

  @override
  String get statsNoGoalsRecorded => 'Maaleja ei ole vielä kirjattu.';

  @override
  String get statsUnknown => 'Tuntematon';

  @override
  String get playerTitle => 'PELAAJA';

  @override
  String playerLoadError(String error) {
    return 'Pelaajan lataus epäonnistui.\n$error';
  }

  @override
  String get playerNotFound => 'Pelaajaa ei löytynyt.';

  @override
  String get playerClub => 'SEURA';

  @override
  String get playerClubRole => 'Seurassaan';

  @override
  String get playerPosition => 'Pelipaikka';

  @override
  String get playerPotential => 'Potentiaali';

  @override
  String get playerAge => 'Ikä';

  @override
  String get playerValue => 'Arvo';

  @override
  String get clubFirstChoice => 'Pelaa joka viikko';

  @override
  String get clubRotation => 'Vuoroin pelissä';

  @override
  String get clubFringe => 'Pelaa vähän';

  @override
  String get clubFrozenOut => 'Ei pelaa';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Olen katsonut jalkapalloa kolmekymmentä vuotta enkä nähnyt tätä tulevaksi. $opponent kaatui $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Kukaan ei uskonut meidän pärjäävän: $opponent. $score. Ei kukaan.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score vastustajasta $opponent. Herätä naapurit.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Tällaisia iltoja kerrotaan lapsenlapsille. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score vastustajasta $opponent. Miten tahansa se tapahtui, se tapahtui.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Paperilla tämä oli ratkaistu ennen alkua. $opponent $score kertoo muuta.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return '$opponent kaatui $score. Vuoden päästä kukaan ei usko tuota lukemaa.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Nauti tästä, ja katso sitten otteluohjelmaa.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score vastustajasta $opponent, ja yhdeksästäkymmenestä minuutista kahdeksankymmentä mentiin tuurilla.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Yksi ilta vastustajaa $opponent vastaan ei pyyhi pois vuotta. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return '$opponent kaatui $score, ja nyt meille kerrotaan, että suunta on kääntynyt. Ei ole.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Hienoa. Kysy uudestaan, kun sillä on merkitystä.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return '$opponent kaatui $score. Juuri niin kuin pitikin, ja siinä on oma ilonsa.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score vastustajasta $opponent. Armoton, ja armottomuus on kehu.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Ei säätöä, ei pelkoa, ei valittamista.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Siisti $score vastustajasta $opponent. Tältä hyvä joukkue näyttää rauhallisena päivänä.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score vastustajasta $opponent. Homma hoidettu, mitään ei opittu.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return '$opponent kaatui $score. Niin piti käydä, ja niin kävi.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Ammattimainen $score vastustajasta $opponent. Seuraava.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return '$opponent hoideltu $score. Arkistoon ja eteenpäin.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score vastustajasta $opponent, ja meidän pitäisi taputtaa. Siitä, että voitimme heidät.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Hyvin tehty kaikille, jotka olivat mukana $score-voitossa vastustajasta $opponent, kai.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Tuollaisten joukkueiden voittaminen on lähtötaso, ei saavutus.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return '$opponent kaatui $score, ja näytimme tahmeilta sen tehdessämme.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score vastustajasta $opponent, ja jokainen minuutti ansaittu.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Tämä vaati luonnetta. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return '$opponent kaatui $score kantapään kautta, ja se on se kestävä tapa.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score vastustajasta $opponent. Tällaiset voittavat joukkueet ovat vielä kesäkuussa pystyssä.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Hermoilua, rumaa, ja voitto. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return '$opponent kaatui $score. Ota kolme pistettä äläkä katso peliä enää koskaan.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. $opponent pakotti meidät tekemään työtä joka sentistä.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Ei kaunista. Lasketaan silti yhtä paljon.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score vastustajasta $opponent, ja teimme siitä kymmenen kertaa vaikeampaa kuin tarvitsi.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Ei meidän pitäisi roikkua kiinni vastustajassa $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Voitettiin, mutta ei opittu itsestämme mitään hyvää.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return '$score vastustajasta $opponent, joka imarteli meitä.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Piste vastustajasta $opponent, $score. Otetaan ja jatketaan.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score vastustajan $opponent kanssa. Huonompiakin iltapäiviä on ollut.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return '$opponent pidettiin $score-tasapeliin. Kaikesta ei tarvitse tehdä tarinaa.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Piste on piste, eikä sarjataulukko kysy miten.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score vastustajan $opponent kanssa. Kaksi pistettä hukattu tai yksi saatu. Valitse fiilis.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Tasapeli vastustajaa $opponent vastaan, $score. Kukaan ei ole iloinen, kukaan ei ole raivoissaan.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Vuoden unohdettavin yhdeksänkymmentä minuuttia.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Pisteet jaettiin: $opponent, $score. Eteenpäin.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score vastustajasta $opponent. Tällaisiin tasapeleihin kampanjat hiljaa kuolevat.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Kaksi pistettä heitetty menemään: $opponent. $score. Muuta sanaa ei ole.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Meillä oli yhdeksänkymmentä minuuttia eikä aavistustakaan, mitä niillä tehdä.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return '$score vastustajan $opponent kanssa, jota kukaan ei muista ja jonka kaikki maksavat.';
  }

  @override
  String yLost0(String opponent, String score) {
    return '$opponent voitti meidät $score. Niin käy.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Ketään ei kannata hirttää. Seuraavaan.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Hävittiin $score vastustajalle $opponent ja annettiin kaikki. Joskus se ei riitä.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score, $opponent vei voiton. Pää pystyyn. Tässä joukkueessa on vielä paljon jäljellä.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Olimme toiseksi parhaita, eikä siitä voi kiistellä.';
  }

  @override
  String yLost5(String opponent, String score) {
    return '$opponent voitti meidät $score. Kasataan itsemme.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score, $opponent vei voiton. Ei häpeä, ei tarpeeksi hyvä.';
  }

  @override
  String yLost7(String opponent, String score) {
    return '$opponent voitti meidät $score. Opi tästä jotain tai se meni hukkaan.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score, $opponent vei voiton, emmekä saaneet iskua perille.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Tappio vastustajalle $opponent, $score. Samat ongelmat, sama kuukausi, samat tekosyyt tulossa.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Missä vaiheessa tämä lakkaa olemasta huonoa tuuria?';
  }

  @override
  String yLost11(String opponent, String score) {
    return '$opponent voitti meidät $score. Tällaisen tuloksen pitäisi maksaa jollekulle jotain.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score, $opponent vei voiton. Yksi huono ilta. Arvioi joukkuetta kampanjan, ei tämän perusteella.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Kukaan ei halunnut tuota $score-tappiota vastustajalle $opponent vähemmän kuin pelaajat itse.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Ruma, eikä tämä ole tämä joukkue.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Unohdettava $score vastustajalle $opponent. Ensi kerralla he nousevat.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Vastustajalle $opponent. Minulla ei ole sanoja, ja minulle maksetaan sanoista.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. Jonkun on vastattava tästä.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Haluan $score-tappion vastustajalle $opponent pois tilastoista ja muistista.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return '$opponent voitti meidät $score. Tällaista lukemaa ei voi kaunistella.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Tämä ei ollut tappio, vaan antautuminen: $opponent. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Vastustajalle $opponent. Ihmiset maksoivat rahaa nähdäkseen tuon.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Jos tämä ei muuta mitään, mikään ei muuta.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Olen nähnyt tämän joukkueen nöyryytettynä ennenkin, mutta $score vastustajalle $opponent on uusi pohja.';
  }

  @override
  String yWinUpset12(String opponent, String score) {
    return 'Voitto $score, vastustajana $opponent. Kirjoittakaa päivämäärä ylös, teiltä kysytään, missä olitte.';
  }

  @override
  String yWinUpset13(String opponent, String score) {
    return 'Pukukopin ulkopuolella kukaan ei uskonut. $opponent-ottelu, $score. Ylpeys ei riitä sanaksi.';
  }

  @override
  String yWinUpset14(String opponent, String score) {
    return '$score, vastustajana $opponent! Jokainen juoksi, kunnes mitään ei ollut jäljellä.';
  }

  @override
  String yWinUpset15(String opponent, String score) {
    return 'Jättiläisen kaataja. $opponent, $score. Tämän takia tulemme aina uudestaan.';
  }

  @override
  String yWinUpset16(String opponent, String score) {
    return '$opponent-ottelu, $score. Ennakkoveikkaukset lensivät juuri ikkunasta ulos.';
  }

  @override
  String yWinUpset17(String opponent, String score) {
    return 'Selvä ennakkosuosikki: $opponent. Lopputulos: $score meille.';
  }

  @override
  String yWinUpset18(String opponent, String score) {
    return 'Yksi vuoden yllätyksistä: $opponent-ottelu, $score.';
  }

  @override
  String yWinUpset19(String opponent, String score) {
    return '$opponent $score. Kukaan ei ennustanut tätä, eikä kukaan osaa oikein selittää sitä.';
  }

  @override
  String yWinUpset20(String opponent, String score) {
    return '$opponent-ottelu, $score. Ihanaa. Nyt kaikki unohtavat, miten huono loppuvuosi oli.';
  }

  @override
  String yWinUpset21(String opponent, String score) {
    return '$opponent-ottelu, $score, ja kelkka on jo täynnä. Minä istuin siinä, kun se oli tyhjä.';
  }

  @override
  String yWinUpset22(String opponent, String score) {
    return '$opponent $score. Loistavaa, ja silti he keksivät keinon heittää tämän hukkaan.';
  }

  @override
  String yWinUpset23(String opponent, String score) {
    return 'Suuri ilta, vastustajana $opponent, $score. Yksi pääsky ei kesää tee.';
  }

  @override
  String yLostBadly12(String opponent, String score) {
    return '$opponent-ottelu, $score. Sattuu, koska välitämme. Tukekaa heitä silti.';
  }

  @override
  String yLostBadly13(String opponent, String score) {
    return 'Unohdettava ilta, vastustajana $opponent, $score. Pelaajiin sattuu eniten.';
  }

  @override
  String yLostBadly14(String opponent, String score) {
    return '$opponent $score. Pää pystyyn. Joukkue tunnetaan siitä, miten se vastaa tähän.';
  }

  @override
  String yLostBadly15(String opponent, String score) {
    return '$opponent-ottelu, $score. Huono, kyllä. Maailmanloppu, ei.';
  }

  @override
  String yLostBadly16(String opponent, String score) {
    return '$opponent-ottelu, $score. Tuloksesta puhutaan vuosia, vääristä syistä.';
  }

  @override
  String yLostBadly17(String opponent, String score) {
    return 'Voitto vastustajalle, $opponent, $score. Tämän jälkeen kenenkään ei pidä yllättyä ensi kerralla.';
  }

  @override
  String yLostBadly18(String opponent, String score) {
    return 'Yksi pitkään aikaan pahimmista illoista: $opponent-ottelu, $score.';
  }

  @override
  String yLostBadly19(String opponent, String score) {
    return '$opponent $score. Kysymyksiä tulee, ja syystäkin.';
  }

  @override
  String yLostBadly20(String opponent, String score) {
    return '$opponent-ottelu, $score. Nolo on liian lievä sana.';
  }

  @override
  String yLostBadly21(String opponent, String score) {
    return 'Tappio $score, vastustajana $opponent. Viimeinen sammuttaa valot.';
  }

  @override
  String yLostBadly22(String opponent, String score) {
    return '$opponent $score. En enää yllätä, ja se pelottaa minua.';
  }

  @override
  String yLostBadly23(String opponent, String score) {
    return '$score. $opponent. Jonkun ylhäällä kannattaa päivittää ansioluettelonsa tänä iltana.';
  }

  @override
  String yWinRout0(String opponent, String score) {
    return '$opponent-ottelu, $score! Tällainen jalkapallo saa koko maan hymyilemään.';
  }

  @override
  String yWinRout1(String opponent, String score) {
    return 'Murskavoitto, vastustajana $opponent, $score. Mikä esitys.';
  }

  @override
  String yWinRout2(String opponent, String score) {
    return '$score. $opponent-ottelu. Tänään onnistui kaikki.';
  }

  @override
  String yWinRout3(String opponent, String score) {
    return '$score-murskaus, vastustajana $opponent. Tallentakaa kooste, haluatte sen myöhemmin.';
  }

  @override
  String yWinRout4(String opponent, String score) {
    return '$opponent $score. Tuo on joukkue, joka nauttii pelaamisesta.';
  }

  @override
  String yWinRout5(String opponent, String score) {
    return '$opponent-ottelu, $score, ja maaleja olisi voinut tulla enemmänkin. Upeaa.';
  }

  @override
  String yWinRout6(String opponent, String score) {
    return '$opponent-ottelu, $score. Lukema, jota katsotaan kahdesti.';
  }

  @override
  String yWinRout7(String opponent, String score) {
    return 'Voitto $score, vastustajana $opponent. Ottelu oli ohi puolessa tunnissa.';
  }

  @override
  String yWinRout8(String opponent, String score) {
    return 'Lopputulos: $opponent-ottelu, $score. Selvästi suurin voitto pitkään aikaan.';
  }

  @override
  String yWinRout9(String opponent, String score) {
    return '$opponent $score. Toinen joukkue tuli pelaamaan, toinen ei edes noussut bussista.';
  }

  @override
  String yWinRout10(String opponent, String score) {
    return '$score. Vastustajalla ($opponent) ei ollut vastausta mihinkään.';
  }

  @override
  String yWinRout11(String opponent, String score) {
    return 'Selkäsauna: $opponent-ottelu, $score.';
  }

  @override
  String yWinRout12(String opponent, String score) {
    return '$opponent-ottelu, $score. Kiva, mutta tuskin mikään mittapuu.';
  }

  @override
  String yWinRout13(String opponent, String score) {
    return '$opponent-ottelu, $score. Herättäkää, kun teemme saman jollekulle hyvälle.';
  }

  @override
  String yWinRout14(String opponent, String score) {
    return '$opponent $score. Hauskaa, mutta olen nähnyt joukkueiden loistavan näin ja voittavan ei mitään.';
  }

  @override
  String yWinRout15(String opponent, String score) {
    return '$score, ja kaikki ovat taas neroja. Vastustaja oli $opponent.';
  }

  @override
  String yWinRout16(String opponent, String score) {
    return '$opponent-ottelu, $score. Ei innostuta liikaa, tämä todistaa hyvin vähän.';
  }

  @override
  String yWinRout17(String opponent, String score) {
    return '$opponent $score. Nauttikaa, ja muistakaa sitten, miten kävi viimeksi, kun innostuimme.';
  }

  @override
  String yWinShootout0(String opponent) {
    return 'Jatkoon rangaistuspotkuilla, vastustajana $opponent! Teräshermot, jokaisella.';
  }

  @override
  String yWinShootout1(String opponent) {
    return 'Rangaistuspotkut, vastustajana $opponent, ja hermot pitivät. Halatkaa tuntematonta.';
  }

  @override
  String yWinShootout2(String opponent) {
    return 'Rangaistuspotkukilpailu voitettu, vastustajana $opponent. Sydämeni ei kestä tätä.';
  }

  @override
  String yWinShootout3(String opponent) {
    return 'Voitto rangaistuspotkuilla, vastustajana $opponent. Jatkoon seuraavalle kierrokselle.';
  }

  @override
  String yWinShootout4(String opponent) {
    return '$opponent-ottelu ratkesi pilkulta, ja me teimme enemmän.';
  }

  @override
  String yWinShootout5(String opponent) {
    return 'Rangaistuspotkut voitettu, vastustajana $opponent. Vaikeinta tietä, mutta jatkoon.';
  }

  @override
  String yWinShootout6(String opponent) {
    return 'Jatkoon rangaistuspotkuilla, vastustajana $opponent. Lotto voitettu, esitys unohdettu.';
  }

  @override
  String yWinShootout7(String opponent) {
    return 'Voitto pilkulta tuollaisen esityksen jälkeen? Vastustaja $opponent. Tuuria, ja kaikki tietävät sen.';
  }

  @override
  String yWinShootout8(String opponent) {
    return 'Jatkoon rangaistuspotkuilla, vastustajana $opponent. Niihin ei olisi pitänyt joutua.';
  }

  @override
  String yKnockoutWin0(String opponent, String score) {
    return 'JATKOON. $opponent-ottelu, $score, ja unelma elää.';
  }

  @override
  String yKnockoutWin1(String opponent, String score) {
    return 'PUDOTUSPELIVOITTO: $opponent-ottelu, $score. Maa voi alkaa uskoa.';
  }

  @override
  String yKnockoutWin2(String opponent, String score) {
    return '$opponent-ottelu, $score, ja seuraavalle kierrokselle. Mikä ilta.';
  }

  @override
  String yKnockoutWin3(String opponent, String score) {
    return 'Kotimatkalle: $opponent, $score. Eteenpäin.';
  }

  @override
  String yKnockoutWin4(String opponent, String score) {
    return 'PUDOTUSPELI: $opponent-ottelu, $score. Seuraava kierros varmistui.';
  }

  @override
  String yKnockoutWin5(String opponent, String score) {
    return 'Jatkoon: $opponent-ottelu, $score.';
  }

  @override
  String yKnockoutWin6(String opponent, String score) {
    return 'Pudotettu: $opponent, $score. Seuraava kierros odottaa.';
  }

  @override
  String yKnockoutWin7(String opponent, String score) {
    return 'Voitto $score, vastustajana $opponent. Pudotuspeleissä kukaan ei kysy miten.';
  }

  @override
  String yKnockoutWin8(String opponent, String score) {
    return 'Jatkoon, vastustajana $opponent, $score. Seuraava vastustaja ei ole yhtä armollinen.';
  }

  @override
  String yKnockoutWin9(String opponent, String score) {
    return '$opponent-ottelu, $score, riittää jatkoon. Ensi kerralla tarvitaan paljon enemmän.';
  }

  @override
  String yKnockoutWin10(String opponent, String score) {
    return 'Ulos: $opponent, $score. Enemmän selvitty kuin voitettu.';
  }

  @override
  String yKnockoutWin11(String opponent, String score) {
    return 'Seuraavalle kierrokselle lukemin $score, vastustajana $opponent. Älkää kysykö miten.';
  }

  @override
  String yUpsetGap0(String opponent, String gap) {
    return 'Rankingissa välillämme oli $gap sijaa, ja silti voitimme. Vastustaja: $opponent. Upeaa.';
  }

  @override
  String yUpsetGap1(String opponent, String gap) {
    return '$opponent: $gap sijaa edellämme. Kaatui. Jalkapallo on ihanaa.';
  }

  @override
  String yUpsetGap2(String opponent, String gap) {
    return 'Rankingero: $gap. Tulos: voitto, vastustajana $opponent. Älkää koskaan lakatko uskomasta.';
  }

  @override
  String yUpsetGap3(String opponent, String gap) {
    return 'Rankingero ennen avausta: $gap. $opponent kaatui silti.';
  }

  @override
  String yUpsetGap4(String opponent, String gap) {
    return 'Maailmanrankingissa $opponent oli $gap sijaa edellämme. Ei tänä iltana.';
  }

  @override
  String yUpsetGap5(String opponent, String gap) {
    return 'Yllätysindeksi: $gap rankingsijaa joukkueiden välillä. Voitto meille, vastustajana $opponent.';
  }

  @override
  String yUpsetGap6(String opponent, String gap) {
    return '$gap rankingsijaa erotti meidät vastustajasta, $opponent. Yksi ilta ei kurota eroa umpeen.';
  }

  @override
  String yUpsetGap7(String opponent, String gap) {
    return '$opponent: $gap sijaa edellä, ja kaatui. Ranking tuskin huomaa.';
  }

  @override
  String yUpsetGap8(String gap) {
    return 'Rankingero: $gap. Muistakaa tämä luku, kun seuraavan kerran häviämme pienelle.';
  }

  @override
  String yEatWords0(String opponent) {
    return 'Olin kirjoittanut tämän joukkueen pois. Olin väärässä, enkä ole koskaan ollut niin iloinen väärässä olemisesta. Vastustaja: $opponent.';
  }

  @override
  String yEatWords1(String opponent) {
    return 'Annos nöyryyttä, kiitos. Iso. Voitto, vastustajana $opponent, oli upea.';
  }

  @override
  String yEatWords2(String opponent) {
    return 'Sanoin, ettei heillä ole enää mitään annettavaa. Oli paljon. Hyvin pelattu, kaikki. Vastustaja: $opponent.';
  }

  @override
  String yEatWords3(String opponent) {
    return 'Pöytäkirjaan: en nähnyt tätä voittoa tulevan. Vastustaja: $opponent. Kunnia sille, jolle se kuuluu.';
  }

  @override
  String yEatWords4(String opponent) {
    return 'Hyvä on. Sanoin, että heidät paljastetaan. $opponent ei paljastanut.';
  }

  @override
  String yEatWords5(String opponent) {
    return 'Tänä iltana syön sanani tästä joukkueesta. Voitto, vastustajana $opponent, ansaitsee sen.';
  }

  @override
  String yEatWords6(String opponent) {
    return 'Kyllä, sanoin, että he ovat valmiita. Yksi voitto, vastustajana $opponent, ei vielä todista minua vääräksi.';
  }

  @override
  String yEatWords7(String opponent) {
    return 'Minun pitäisi kuulemma syödä sanani. Vastustaja: $opponent. Syön, hitaasti, ja kuitin säästän.';
  }

  @override
  String yEatWords8(String opponent) {
    return 'Voitto, vastustajana $opponent, oli vaikuttava. Epäilykseni tästä joukkueesta eivät ole kadonneet.';
  }

  @override
  String yAwayFansWin0(String nation, String score) {
    return 'Hatunnosto: $nation. $score, ja täysin ansaittu.';
  }

  @override
  String yAwayFansWin1(String nation, String score) {
    return 'Sattuu sanoa, mutta parempi tänään oli $nation. $score. Onnittelut.';
  }

  @override
  String yAwayFansWin2(String nation, String score) {
    return '$score. Hattua nostetaan: $nation. He halusivat sitä enemmän.';
  }

  @override
  String yAwayFansWin3(String nation, String score) {
    return 'Tappio $score, vastustajana $nation. En edes tiedä, mitä sanoa.';
  }

  @override
  String yAwayFansWin4(String nation, String score) {
    return '$nation $score. Meidän pitäisi hävetä.';
  }

  @override
  String yAwayFansWin5(String nation, String score) {
    return '$nation-ottelu, $score. Joku selittäköön, miten tuo tapahtui.';
  }

  @override
  String yAwayFansWin6(String nation, String score) {
    return 'Hävitä $score, vastustajana $nation. Tästä en pääse koskaan yli.';
  }

  @override
  String yAwayFansWin7(String nation, String score) {
    return '$nation-ottelu, $score. Tuuria. Puhdasta tuuria.';
  }

  @override
  String yAwayFansWin8(String nation, String score) {
    return 'Tuon $score-tuloksen jälkeen $nation-fanit ovat sietämättömiä vuosia. Kiitos ei mistään.';
  }

  @override
  String yNeutralWin0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Upeaa jalkapallolle. Tämän takia rakastamme sitä.';
  }

  @override
  String yNeutralWin1(String nation, String opponent, String score) {
    return 'Mikä tulos: $nation $score $opponent. Jalkapalloa parhaimmillaan.';
  }

  @override
  String yNeutralWin2(String nation, String opponent, String score) {
    return 'Kaikki puolueettomat kannustavat tänään: $nation. $nation $score $opponent!';
  }

  @override
  String yNeutralWin3(String nation, String opponent, String score) {
    return 'Kierroksen tulos: $nation $score $opponent.';
  }

  @override
  String yNeutralWin4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Tätä ei ollut kenelläkään kupongissa.';
  }

  @override
  String yNeutralWin5(String nation, String opponent, String score) {
    return 'Iso tulos: $nation $score $opponent. Ranking liikkuu.';
  }

  @override
  String yNeutralWin6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Hauskaa, katsotaan pystyvätkö toistamaan.';
  }

  @override
  String yNeutralWin7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Voittiko toinen vai hävisikö toinen?';
  }

  @override
  String yNeutralWin8(String nation, String opponent, String score) {
    return 'Jytky: $nation $score $opponent. Odottakaa runsaasti ylireagointia.';
  }

  @override
  String yScorerHero0(String name, String opponent) {
    return '$name. Vastustaja: $opponent. Lapsia nimetään hänen mukaansa.';
  }

  @override
  String yScorerHero1(String name, String opponent) {
    return 'Patsas pelaajalle $name. Tänä iltana hän oli kaikki. Vastustaja: $opponent.';
  }

  @override
  String yScorerHero2(String name, String opponent) {
    return '$name, mikä pelaaja. Muistakaa tämä $opponent-ottelu.';
  }

  @override
  String yScorerHero3(String name, String opponent) {
    return '$name ratkaisi $opponent-ottelun. Ottelun pelaaja, ei keskustelua.';
  }

  @override
  String yScorerHero4(String name, String opponent) {
    return '$opponent-ottelu oli yhden miehen ilta: $name.';
  }

  @override
  String yScorerHero5(String name, String opponent) {
    return '$name astui esiin, kun sitä tarvittiin. Vastustaja: $opponent.';
  }

  @override
  String yScorerHero6(String name, String opponent) {
    return '$name oli loistava $opponent-ottelussa. Nyt joka viikko.';
  }

  @override
  String yScorerHero7(String name, String opponent) {
    return '$name pelasti joukkueen $opponent-ottelussa. Muut auttoivat vähän.';
  }

  @override
  String yScorerHero8(String name, String opponent) {
    return 'Ilman pelaajaa $name $opponent-ottelu olisi ollut aivan toinen ilta.';
  }

  @override
  String yLostShock0(String opponent, String score) {
    return '$opponent-ottelu, $score. Vahinko. Sattuu kaikille kerran.';
  }

  @override
  String yLostShock1(String opponent, String score) {
    return 'Tappio $score, vastustajana $opponent. Ravistetaan pois, kampanja ei ole ohi.';
  }

  @override
  String yLostShock2(String opponent, String score) {
    return '$opponent $score. Kipeää, mutta yksi tulos ei määrittele tätä joukkuetta.';
  }

  @override
  String yLostShock3(String opponent, String score) {
    return '$opponent-ottelu, $score. Huono päivä töissä. Eteenpäin.';
  }

  @override
  String yLostShock4(String opponent, String score) {
    return 'Tappio, vastustajana $opponent, $score. Kukaan ei nähnyt tätä tulevan.';
  }

  @override
  String yLostShock5(String opponent, String score) {
    return '$opponent $score. Yksi niistä illoista, joissa ei ole mitään järkeä.';
  }

  @override
  String yLostShock6(String opponent, String score) {
    return '$opponent-ottelu, $score. Tappio, joka muistetaan.';
  }

  @override
  String yLostShock7(String opponent, String score) {
    return 'Hävisimme, vastustajana $opponent, $score. Yllätys, katsoi miltä kannalta tahansa.';
  }

  @override
  String yLostShock8(String opponent, String score) {
    return '$opponent-ottelu, $score. Tällaiselle vastustajalle! Kestämätöntä.';
  }

  @override
  String yLostShock9(String opponent, String score) {
    return 'Tappio $score, vastustajana $opponent. Haluan selityksiä, en tekosyitä.';
  }

  @override
  String yLostShock10(String opponent, String score) {
    return '$opponent $score. Kansallinen häpeä, eikä se ole kielikuva.';
  }

  @override
  String yLostShock11(String opponent, String score) {
    return '$opponent-ottelu, $score. Miten kukaan ylhäällä istuu yhä paikallaan?';
  }

  @override
  String yLostRout0(String opponent, String score) {
    return '$opponent-ottelu, $score. Huippujoukkue. Opitaan tästä.';
  }

  @override
  String yLostRout1(String opponent, String score) {
    return 'Vastustaja ($opponent) oli ylivoimainen, $score. Ei häpeä hävitä parhaille.';
  }

  @override
  String yLostRout2(String opponent, String score) {
    return '$opponent $score. Oppitunti, ja oppitunneista kasvetaan.';
  }

  @override
  String yLostRout3(String opponent, String score) {
    return '$opponent-ottelu, $score. Kipeää, mutta he ovat tason ylempänä.';
  }

  @override
  String yLostRout4(String opponent, String score) {
    return 'Voitto vastustajalle, $opponent, $score. Ero on todellinen, ja nyt kaikki näkivät sen.';
  }

  @override
  String yLostRout5(String opponent, String score) {
    return '$opponent-ottelu, $score. Selkäsauna, ei sen kummempaa.';
  }

  @override
  String yLostRout6(String opponent, String score) {
    return '$opponent $score. Parempi joukkue, ja tulos kertoo sen.';
  }

  @override
  String yLostRout7(String opponent, String score) {
    return 'Tappio $score, vastustajana $opponent. Ei häpeä, mutta ei otteluakaan.';
  }

  @override
  String yLostRout8(String opponent, String score) {
    return '$opponent-ottelu, $score. Parempi vastustaja tai ei, noin ei hävitä.';
  }

  @override
  String yLostRout9(String opponent, String score) {
    return '$opponent $score. Yritimmekö edes kilpailla?';
  }

  @override
  String yLostRout10(String opponent, String score) {
    return '$score. $opponent-ottelu. Kuin lampaat teurastamolle.';
  }

  @override
  String yLostRout11(String opponent, String score) {
    return 'Tappio $score, vastustajana $opponent, eikä kukaan näyttänyt välittävän.';
  }

  @override
  String yLostShootout0(String opponent) {
    return 'Ulos rangaistuspotkuilla, vastustajana $opponent. He antoivat kaikkensa. Ylpeä heistä.';
  }

  @override
  String yLostShootout1(String opponent) {
    return 'Rangaistuspotkut, vastustajana $opponent. Julmin tapa pudota. Pää pystyyn.';
  }

  @override
  String yLostShootout2(String opponent) {
    return 'Rangaistuspotkukilpailu hävitty, vastustajana $opponent. Kukaan ei ansainnut sitä.';
  }

  @override
  String yLostShootout3(String opponent) {
    return 'Ulos rangaistuspotkuilla, vastustajana $opponent. Pilkku ratkaisi.';
  }

  @override
  String yLostShootout4(String opponent) {
    return 'Jatkoon rangaistuspotkuilla: $opponent. Meidän turnauksemme päättyy siihen.';
  }

  @override
  String yLostShootout5(String opponent) {
    return 'Rangaistuspotkut hävitty, vastustajana $opponent. Taas pilkku.';
  }

  @override
  String yLostShootout6(String opponent) {
    return 'Ulos rangaistuspotkuilla, vastustajana $opponent. Harjoittelemmeko niitä koskaan?';
  }

  @override
  String yLostShootout7(String opponent) {
    return 'Tappio rangaistuspotkuilla, vastustajana $opponent. Peli olisi pitänyt ratkaista paljon aiemmin.';
  }

  @override
  String yLostShootout8(String opponent) {
    return 'Rangaistuspotkut, vastustajana $opponent, ja hävisimme. Tietenkin.';
  }

  @override
  String yKnockoutLoss0(String opponent, String score) {
    return 'ULOS. $opponent-ottelu, $score. Matka, josta voi olla ylpeä, päättyy tähän.';
  }

  @override
  String yKnockoutLoss1(String opponent, String score) {
    return 'Pudotettu, vastustajana $opponent, $score. Kiitos muistoista.';
  }

  @override
  String yKnockoutLoss2(String opponent, String score) {
    return '$opponent-ottelu, $score. Matka on ohi, mutta mikä matka.';
  }

  @override
  String yKnockoutLoss3(String opponent, String score) {
    return 'PUDOTETTU: $opponent-ottelu, $score. Pää pystyyn.';
  }

  @override
  String yKnockoutLoss4(String opponent, String score) {
    return 'LOPPU: $opponent-ottelu, $score.';
  }

  @override
  String yKnockoutLoss5(String opponent, String score) {
    return 'Ulos: $opponent-ottelu, $score.';
  }

  @override
  String yKnockoutLoss6(String opponent, String score) {
    return 'Jatkoon: $opponent, $score. Meidän turnauksemme on ohi.';
  }

  @override
  String yKnockoutLoss7(String opponent, String score) {
    return 'Pudotettu, vastustajana $opponent, $score. Ruumiinavaus alkaa nyt.';
  }

  @override
  String yKnockoutLoss8(String opponent, String score) {
    return 'ULOS. $opponent-ottelu, $score. Eri turnaus, sama loppu.';
  }

  @override
  String yKnockoutLoss9(String opponent, String score) {
    return '$opponent-ottelu, $score, ja kotiin. Kukaan ei yllättynyt.';
  }

  @override
  String yKnockoutLoss10(String opponent, String score) {
    return 'Pudotettu, vastustajana $opponent, $score. Tekosyitä luvassa aamuun mennessä.';
  }

  @override
  String yKnockoutLoss11(String opponent, String score) {
    return '$opponent $score. Ulos, eikä se koskaan näyttänyt päättyvän toisin.';
  }

  @override
  String yAwayFansGloat0(String nation, String score) {
    return '$nation-ottelu, $score. Kunnioitusta, he palaavat vahvempina.';
  }

  @override
  String yAwayFansGloat1(String nation, String score) {
    return 'Hyvä voitto meille, $score. Huono päivä: $nation. Myötätuntoni faneille.';
  }

  @override
  String yAwayFansGloat2(String nation, String score) {
    return '$score. Huono ilta: $nation. Me tartuimme tilaisuuteen. Sellaista se on.';
  }

  @override
  String yAwayFansGloat3(String nation, String score) {
    return '$nation-ottelu, $score! Kuka näki tämän tulevan? Eivät he.';
  }

  @override
  String yAwayFansGloat4(String nation, String score) {
    return 'Voitto $score, vastustajana $nation. Käykö joku katsomassa, miten heidän faninsa voivat?';
  }

  @override
  String yAwayFansGloat5(String nation, String score) {
    return '$nation $score. Tämä menee valokuva-albumiin.';
  }

  @override
  String yAwayFansGloat6(String nation, String score) {
    return '$nation-ottelu, $score. Ja he luulevat olevansa suuri joukkue.';
  }

  @override
  String yAwayFansGloat7(String nation, String score) {
    return 'Kuvittele häviäväsi meille $score. Kysy, $nation tietää nyt.';
  }

  @override
  String yAwayFansGloat8(String nation, String score) {
    return '$nation, $score. Hyvää kotilentoa.';
  }

  @override
  String yNeutralLoss0(String nation, String opponent, String score) {
    return '$nation $score $opponent. Suuri ilta toiselle, raskas toiselle.';
  }

  @override
  String yNeutralLoss1(String nation, String opponent, String score) {
    return 'Voimia $nation-faneille tuloksen $score jälkeen. Vastustaja: $opponent. He nousevat vielä.';
  }

  @override
  String yNeutralLoss2(String nation, String opponent, String score) {
    return '$nation $score $opponent. Jokaisella suurella joukkueella on tällainen ilta.';
  }

  @override
  String yNeutralLoss3(String nation, String opponent, String score) {
    return 'Kierroksen jytky: $nation $score $opponent.';
  }

  @override
  String yNeutralLoss4(String nation, String opponent, String score) {
    return '$nation $score $opponent. Kukaan ei nähnyt tätä tulevan.';
  }

  @override
  String yNeutralLoss5(String nation, String opponent, String score) {
    return 'Päivän tulos: $nation $score $opponent. Nyt odottavat kysymykset.';
  }

  @override
  String yNeutralLoss6(String nation, String opponent, String score) {
    return '$nation $score $opponent. Ei yksittäistapaus, jos on seurannut.';
  }

  @override
  String yNeutralLoss7(String nation, String opponent, String score) {
    return '$nation $score $opponent. Jollakulla siellä on paljon selitettävää.';
  }

  @override
  String yNeutralLoss8(String nation, String opponent, String score) {
    return '$nation $score $opponent. Iso nimi, pieni esitys.';
  }

  @override
  String yDownGap0(String opponent, String gap) {
    return '$opponent: $gap sijaa takanamme. Sattuu. Eteenpäin.';
  }

  @override
  String yDownGap1(String gap) {
    return 'Rankingero: $gap meidän hyväksemme. Jalkapallo ei lue rankingeja.';
  }

  @override
  String yDownGap2(String opponent, String gap) {
    return '$gap sijaa meidän ja vastustajan ($opponent) välillä paperilla. Ei kentällä tänä iltana.';
  }

  @override
  String yDownGap3(String opponent, String gap) {
    return 'Rankingero ennen avausta: $gap meidän hyväksemme. Tappio silti, vastustajana $opponent.';
  }

  @override
  String yDownGap4(String opponent, String gap) {
    return 'Maailmanrankingissa $opponent oli $gap sijaa takanamme. Tulos: tappio.';
  }

  @override
  String yDownGap5(String opponent, String gap) {
    return 'Yllätysindeksi: $gap rankingsijaa, väärään suuntaan. Vastustaja: $opponent.';
  }

  @override
  String yDownGap6(String opponent, String gap) {
    return '$gap sijaa edellä rankingissa, vastustajana $opponent. Tappio. Selittäkää se.';
  }

  @override
  String yDownGap7(String gap) {
    return 'Tappio joukkueelle, joka on $gap sijaa takanamme. Antakaa luvun upota.';
  }

  @override
  String yDownGap8(String opponent, String gap) {
    return 'Rankingero: $gap. Tappio, vastustajana $opponent. Jonkun kannattaa alkaa laskea päiviä.';
  }

  @override
  String yDrewHeroic0(String opponent, String score) {
    return '$opponent-ottelu, $score! Tasapeli, joka tuntuu voitolta.';
  }

  @override
  String yDrewHeroic1(String opponent, String score) {
    return '$opponent-ottelu, $score. Ylpeä jokaisesta.';
  }

  @override
  String yDrewHeroic2(String opponent, String score) {
    return '$opponent $score. He olivat suosikki, ja pysyimme mukana.';
  }

  @override
  String yDrewHeroic3(String opponent, String score) {
    return '$opponent-ottelu, $score. Piste verellä ja hiellä.';
  }

  @override
  String yDrewHeroic4(String opponent, String score) {
    return '$opponent-ottelu, $score. Todella hyvä piste.';
  }

  @override
  String yDrewHeroic5(String opponent, String score) {
    return 'Tasapeli $score, vastustajana $opponent. Harva odotti mitään.';
  }

  @override
  String yDrewHeroic6(String opponent, String score) {
    return '$opponent pysäytetty, $score. Tulos, jonka päälle rakentaa.';
  }

  @override
  String yDrewHeroic7(String opponent, String score) {
    return '$opponent-ottelu, $score. Piste, jota kukaan ei meille antanut.';
  }

  @override
  String yDrewHeroic8(String opponent, String score) {
    return '$opponent-ottelu, $score. Hyvä piste, mutta tasapeleillä ei voiteta mitään.';
  }

  @override
  String yDrewHeroic9(String opponent, String score) {
    return '$opponent-ottelu, $score. Kiva. Meillä ei ollut yhtään kunnon laukausta.';
  }

  @override
  String yDrewHeroic10(String opponent, String score) {
    return '$opponent $score. Yksi piste, ja kaikki käyttäytyvät kuin olisimme voittaneet pokaalin.';
  }

  @override
  String yDrewHeroic11(String opponent, String score) {
    return '$opponent-ottelu, $score. Bussi maalin eteen ja tuuria.';
  }

  @override
  String yDrewShame0(String opponent, String score) {
    return '$opponent-ottelu, $score. Turhauttavaa, mutta yhä tappioton.';
  }

  @override
  String yDrewShame1(String opponent, String score) {
    return 'Vain $score, vastustajana $opponent. Huono päivä. Sattuu.';
  }

  @override
  String yDrewShame2(String opponent, String score) {
    return '$opponent $score. Ei tarpeeksi hyvä, ja pelaajat tietävät sen.';
  }

  @override
  String yDrewShame3(String opponent, String score) {
    return '$opponent-ottelu, $score. Kaksi pistettä menetetty, ei muuta.';
  }

  @override
  String yDrewShame4(String opponent, String score) {
    return '$opponent-ottelu, $score. Kaksi pistettä heitetty hukkaan.';
  }

  @override
  String yDrewShame5(String opponent, String score) {
    return 'Vain $score, vastustajana $opponent. Huono tulos, miten sen paketoikin.';
  }

  @override
  String yDrewShame6(String opponent, String score) {
    return '$opponent $score. Tasapeli, joka tuntuu tappiolta.';
  }

  @override
  String yDrewShame7(String opponent, String score) {
    return '$opponent-ottelu, $score. Tällaiset ottelut pitää voittaa selvästi.';
  }

  @override
  String yDrewShame8(String opponent, String score) {
    return '$opponent-ottelu, $score. Noloa.';
  }

  @override
  String yDrewShame9(String opponent, String score) {
    return 'Vain tasapeli, vastustajana $opponent, $score. Kuka tästä vastaa?';
  }

  @override
  String yDrewShame10(String opponent, String score) {
    return '$opponent $score. Jos emme voita heitä, kenet sitten voitamme?';
  }

  @override
  String yDrewShame11(String opponent, String score) {
    return '$opponent-ottelu, $score. Heidän faninsa juhlivat tasapeliä meitä vastaan. Miettikää sitä.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'MESTARIT. $opponent. Sano se ääneen.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Voitimme sen. $opponent. En ole kunnossa.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, ja pokaali tulee kotiin.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Jokainen heistä on legenda. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Niin lähellä. $opponent ja mitali, jota kukaan ei halua.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Hopeaa turnauksessa $opponent. Se kirveltää vuosia.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: yhden ottelun päässä kaikesta.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Toinen. Turnauksessa $opponent. Joku ojentakoon pullon.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Ulos turnauksesta $opponent. Tämä sattuu vielä pitkään.';
  }

  @override
  String yEliminated1(String opponent) {
    return 'Matkamme päättyy tähän: $opponent.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Putosimme turnauksesta $opponent. Nyt alkaa jälkipuinti.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Pudotettiin turnauksesta $opponent. Joku selittäköön tämän minulle.';
  }

  @override
  String yQualified0(String opponent) {
    return 'MENEMME TURNAUKSEEN $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Karsinnat selvitetty: $opponent. Varaa vapaat töistä.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, täältä tullaan. Ei koskaan epäilystäkään (epäilyksiä oli ihan kaikkialla).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Mukana turnauksessa $opponent. Vaikein osa on tehty.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Lohkot arvottu: $opponent. Olisi voinut olla huonomminkin. Paljon huonomminkin.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Siinä se on, arvonta: $opponent. Mielenkiintoista.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Lohkot ovat selvillä, $opponent, enkä jo pidä omastamme.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Arvonta tehty: $opponent. Ylireagointi voi alkaa.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Isäntä: $opponent. Alkakaa säästää.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Turnaus menee maahan $opponent. Ennalta-arvattavaa, mutta ihan hyvä.';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'Turnaus: $opponent. Onnittelut heille, kai.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Isäntä vahvistettu: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return 'Turnaus $opponent alkaa pian enkä pysy paikallani.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Ei kauan enää: $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return '$opponent on melkein täällä. Joukkueen nimeäminen, kiitos.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Lähtölaskenta turnaukseen $opponent on virallisesti sietämätön.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Ei vielä sanottavaa. Pelaa ottelu.';

  @override
  String get yEarlierHeading => 'Aiemmin tällä kaudella';

  @override
  String get yTraitLoyalist =>
      'Tukee joukkuetta mitä tahansa tapahtuu. Hidas kääntymään, nopea antamaan anteeksi.';

  @override
  String get yTraitCynic =>
      'Olettaa pahinta ja ilahtuu, kun se osoittautuu todeksi.';

  @override
  String get yTraitNostalgic =>
      'Kaikki oli ennen paremmin. Vertaa sinua miehiin, jotka ovat jo lopettaneet.';

  @override
  String get yTraitStatshead =>
      'Julkaisee lukuja eikä muuta. Tuskin on tunnetilaa.';

  @override
  String get yTraitHypeman =>
      'Kaksi hyvää tulosta ja kyseessä on kultainen sukupolvi.';

  @override
  String get yTraitContrarian =>
      'Mitä tahansa muut ajattelevat, tämä ajattelee päinvastoin.';

  @override
  String get yTraitDoomer => 'Tämä menee pieleen. Tämä menee aina pieleen.';

  @override
  String get yProfilePosts => 'JULKAISUT';

  @override
  String get yProfileEmpty => 'Tililtä ei ole vielä mitään.';

  @override
  String hubEventGrievance(String player) {
    return '$player haluaa puhua';
  }

  @override
  String get hubEventGrievanceSub => 'Hän haluaa tietää, missä seisoo';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taitopistettä käytettävänä',
      one: '1 taitopiste käytettävänä',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Se, missä olet hyvä, tekee joukkueestasi paremman';

  @override
  String get grievanceTitle => 'Puhetta toimistollasi';

  @override
  String grievanceGameTime(String player) {
    return '$player on ollut joukkueessa eikä ole potkaissut palloa kertaakaan. Hän haluaa tietää miksi.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return '$player ei ole joukkueessa eikä ymmärrä sitä. Hän haluaa kuulla asian suoraan, suuntaan tai toiseen.';
  }

  @override
  String grievanceRole(String player) {
    return '$player joutuu jatkuvasti pelaamaan väärällä paikalla, ja hän on saanut tarpeekseen.';
  }

  @override
  String get grievanceReassure => 'Olet suunnitelmissani';

  @override
  String get grievanceHonest => 'Olet muita jäljessä, ja tässä syy';

  @override
  String get grievanceDismiss => 'Minä valitsen kokoonpanon';

  @override
  String yScorerStar0(String name, String goals) {
    return '$name teki niistä $goals. Kukaan muu ei ole lähelläkään.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals maalia: $name. Hän kantaa tätä joukkuetta.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals tänään. Mikä pelaaja.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return '$goals maalia heidän verkkoonsa, ja tekijä oli $name. Kumarra.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals maalia: $name, ja muut olivat matkustajia.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Taas $name. $goals. Kuvittele tämä joukkue ilman häntä.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals maalia: $name. Yhden miehen ei pitäisi joutua tekemään näin paljon.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Poista $name kuvasta, ja maaleja on $goals vähemmän ja iltapäivä aivan toisenlainen.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count voittoa putkeen. Mitä pukukopissa onkaan sanottu, se on mennyt perille.';
  }

  @override
  String yWinStreak1(String count) {
    return 'Siinä $count peräkkäin. Joukkueet eivät kompastu tällaisiin putkiin.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count putkeen ja jatkuu. Itseluottamus näkyy katsomoon asti.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Ei tappiota $count ottelussa. Kysy keneltä tahansa valmentajalta: se on vaikein osa.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count putkeen. Nauti, kun otteluohjelma on suosiollinen.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count peräkkäin, emmekä ole voittaneet ketään merkittävää.';
  }

  @override
  String yWinStreak6(String count) {
    return '$count voiton putki. Kysy uudestaan, kun sitä koetellaan.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count peräkkäin. Jokaisessa joukkueessa on tällainen putki kerran.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count ottelua ilman voittoa. Jossain vaiheessa tekosyyt loppuvat.';
  }

  @override
  String yLossStreak1(String count) {
    return '$count peräkkäin menetetty. Tämä ei ole enää notkahdus.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count tappiota peräkkäin. Jonkun on vastattava tästä.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Ei voittoa $count ottelussa. Sen näkee siitä, miten he pelaavat.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count ottelua ilman voittoa ja samat virheet joka viikko.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count putkeen. Mitä tahansa kokeillaankin, se ei toimi.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count peräkkäin. Tämä on suunta, ei notkahdus.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Ei voittoa $count ottelussa, eikä kukaan ylhäällä ole sanonut sanaakaan.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Sano jalkapallosta mitä haluat. Tämä lasketaan kahteen kertaan.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Ja vastustaja on juuri $opponent. $score. Kukaan täällä ei unohda sitä.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score vastustajasta $opponent. Siitä puhutaan pubeissa.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Naapurit, $score. Kerskumisoikeudet ratkaistu hetkeksi.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Mitä muuta tänä vuonna tapahtuukin, tuo on tehty.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score vastustajasta $opponent. Jotkut meistä tarvitsivat tätä enemmän kuin sarjataulukko.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. He ottavat sen takaisin ensi kerralla, aina ottavat.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return '$opponent, $score. Koko vuoden muistutetaan tästä.';
  }

  @override
  String yInjuryBlow0(String name) {
    return '$name pois loukkaantuneena. Sitä tämä joukkue ei kaivannut.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Kun $name puuttuu, kaiken muoto muuttuu.';
  }

  @override
  String yInjuryBlow2(String name) {
    return '$name ontuu. Pidätä hengitystäsi.';
  }

  @override
  String yInjuryBlow3(String name) {
    return '$name poissa jonkin aikaa, siis. Jonkun on astuttava esiin.';
  }

  @override
  String yInjuryBlow4(String name) {
    return '$name pois. Tietysti se on $name.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Kun $name puuttuu, tästä tulee hyvin tavallinen joukkue.';
  }

  @override
  String yInjuryBlow6(String name) {
    return '$name loukkaantui taas. Jonkun pitäisi kysyä miksi.';
  }

  @override
  String yInjuryBlow7(String name) {
    return '$name pois, eikä hänen takanaan ole ketään. Se on todellinen ongelma.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Punainen kortti, $name, $minute. minuutilla, ja koko maa kääntyy häntä vastaan. Hän on antanut meille enemmän kuin useimmat. Jättäkää rauhaan.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return '$name ulos $minute minuutin jälkeen. Kova tuomio. Kymmenellä miehellä yritimme silti, ja se kertoo jotain.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute. minuutti, punainen kortti. Siitä eteenpäin kymmenellä.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Ulosajo: $name, $minute. minuutilla. Ei ensimmäinen ottelu, joka kääntyy yhteen ratkaisuun.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Loistavaa. $name lähtee $minute. minuutilla ja olemme taas kymmenen miestä.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return '$name ajettiin ulos $minute minuutin jälkeen. Kuka täällä oikein valmentaa kurinalaisuutta?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minuuttia. Niin kauan $name piti pään kylmänä. Ammattilaisjalkapalloa.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return '$name sai punaisen $minute. minuutilla, ja minun pitäisi uskoa tämän olevan edistystä.';
  }

  @override
  String get yBoardPressure0 =>
      'Hallitus on hiljentynyt kovasti. Se ei ole koskaan hyvä merkki.';

  @override
  String get yBoardPressure1 =>
      'Huhun mukaan hallituksen huoneessa on alettu esittää kysymyksiä.';

  @override
  String get yBoardPressure2 => 'Ylhäällä tuntee maan liikkuvan.';

  @override
  String get yBoardPressure3 =>
      'Kukaan liitossa ei sano mitään tukevaa. Tee omat johtopäätöksesi.';

  @override
  String get yBoardPressure4 =>
      'Kukaan ylhäällä ei ole tukenut häntä julkisesti viikkoihin.';

  @override
  String get yBoardPressure5 =>
      'Liitto kertoo taustalla omasta valmentajastaan pahaa. Kuten aina.';

  @override
  String get yBoardPressure6 => 'Kun hallitus vaikenee, se on jo päättänyt.';

  @override
  String get yBoardPressure7 =>
      'He antavat tämän ajautua, kunnes päätös on jonkun toisen tehtävä.';

  @override
  String get yReplies => 'MYÖS TÄSTÄ OTTELUSTA';

  @override
  String get yPlayerGrievance0 => 'Kysyin, missä seison. Odotan yhä vastausta.';

  @override
  String get yPlayerGrievance1 => 'Harjoittelen kovaa. Muuta en voi tehdä.';

  @override
  String get yPlayerGrievance2 =>
      'Joitakin kysymyksiä saa esittää vain kerran.';

  @override
  String get yPlayerGrievance3 => 'En tullut näin pitkälle kantamaan liivejä.';

  @override
  String get playerHonoursTitle => 'KUNNIAPALKINNOT';

  @override
  String get awardGoldenBall => 'Kultainen pallo';

  @override
  String get awardGoldenBoot => 'Kultainen kenkä';

  @override
  String get awardGoldenGlove => 'Kultainen hanska';

  @override
  String get awardTeamOfTournament => 'Turnauksen tähdistökokoonpano';

  @override
  String get awardPlayerOfYear => 'Vuoden maailmanpelaaja';

  @override
  String get awardYoungPlayerOfYear => 'Vuoden nuori pelaaja';

  @override
  String get playerClubHistory => 'SEURAHISTORIA';

  @override
  String get playerCareerRecord => 'URATILASTOT';

  @override
  String get playerInternationalGoals => 'Maajoukkuemaalit';

  @override
  String get playerRecentForm => 'VIIMEAIKAINEN VIRE';

  @override
  String get playerMatchHistory => 'OTTELUHISTORIA';

  @override
  String get playerAttributes => 'OMINAISUUDET';

  @override
  String get playerUnknown => 'Tuntematon';

  @override
  String get playerAttrPace => 'Vauhti';

  @override
  String get playerAttrPhysical => 'Fysiikka';

  @override
  String get playerAttrTechnical => 'Tekniikka';

  @override
  String get playerAttrShooting => 'Laukaisu';

  @override
  String get playerAttrPassing => 'Syöttäminen';

  @override
  String get playerAttrDribbling => 'Harhautus';

  @override
  String get playerAttrTackling => 'Taklaus';

  @override
  String get playerAttrPositioning => 'Sijoittuminen';

  @override
  String get playerAttrComposure => 'Maltti';

  @override
  String get playerAttrDecisions => 'Päätöksenteko';

  @override
  String get playerAttrStamina => 'Kestävyys';

  @override
  String get playerAttrStrength => 'Voima';

  @override
  String get playerStatCaps => 'Maaottelut';

  @override
  String get playerStatGoals => 'Maalit';

  @override
  String get playerStatAssists => 'Syötöt';

  @override
  String get playerStatAvgRating => 'Arvosana ka.';

  @override
  String get playerStatForm => 'Vire';

  @override
  String get playerStatMotm => 'Ottelun paras';

  @override
  String get playerStatCleanSheets => 'Nollapelit';

  @override
  String get playerStatBestGame => 'Paras peli';

  @override
  String get playerStatCards => 'Kortit';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}K ${reds}P';
  }

  @override
  String get tourSharedYourRun => 'SINUN TAIVALTASI';

  @override
  String get tourSharedList => 'Lista';

  @override
  String get tourSharedBracket => 'Kaavio';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Lohko $seed';
  }

  @override
  String get tourSharedThisEdition => 'Tämä turnaus';

  @override
  String get tourSharedAllTime => 'Kaikkien aikojen';

  @override
  String get tourSharedUnknown => 'Tuntematon';

  @override
  String get tourSharedActive => 'AKTIIVINEN';

  @override
  String get tourSharedMedalTable => 'MITALITAULUKKO';

  @override
  String get tourSharedPastWinners => 'AIEMMAT VOITTAJAT';

  @override
  String tourSharedHost(String host) {
    return 'Isäntä: $host';
  }

  @override
  String get tourSharedBeat => 'voitti';

  @override
  String get tourSharedPens => ' (rp)';

  @override
  String get tourSharedAwardsEmpty =>
      'Palkinnot ratkeavat, kun turnaus on pelattu loppuun.';

  @override
  String get tourSharedGoldenBall => 'KULTAINEN PALLO';

  @override
  String get tourSharedPlayerOfTournament => 'Turnauksen pelaaja';

  @override
  String get tourSharedGoldenBoot => 'KULTAINEN KENKÄ';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maalia',
      one: '1 maali',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'KULTAINEN HANSKA';

  @override
  String get tourSharedTeamOfTournament => 'TURNAUKSEN TÄHDISTÖKOKOONPANO';

  @override
  String get tourSharedStatsEmpty =>
      'Ennätykset ilmestyvät, kun kilpailulla on historiaa.';

  @override
  String get tourSharedRecordScorer => 'ENNÄTYSMAALINTEKIJÄ';

  @override
  String get tourSharedStillActive => 'yhä aktiivinen';

  @override
  String get tourSharedMostTitles => 'ENITEN MESTARUUKSIA';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mestaruutta',
      one: '1 mestaruus',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'ENITEN FINAALEJA';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finaalia pelattu',
      one: '1 finaali pelattu',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'ENITEN OTTELUITA';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ottelua',
      one: '1 ottelu',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'ENITEN LOPPUTURNAUKSIA';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lopputurnausta',
      one: '1 lopputurnaus',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'SUURIN FINAALIVOITTO';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maalia',
      one: '1 maali',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'yhä aktiivinen';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mestaruutta',
      one: '1 mestaruus',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finaalia pelattu',
      one: '1 finaali pelattu',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ottelua',
      one: '1 ottelu',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lopputurnausta',
      one: '1 lopputurnaus',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'KAIKKIEN AIKOJEN JOHTAJAT';

  @override
  String get tourStatsTabGames => 'Ottelut';

  @override
  String get tourStatsTabCups => 'Turnaukset';

  @override
  String get tourStatsTabScorers => 'Maalipörssi';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'vs $opponent · $year';
  }

  @override
  String get tourHolders => 'TITTELIN HALTIJAT';

  @override
  String tourHoldersSince(int year) {
    return 'voittanut $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'KAIKKIEN AIKOJEN MAALINTEKIJÄT';

  @override
  String get tourSharedSummaryEmpty =>
      'Isäntä ja stadionit ilmestyvät, kun turnaus on arvottu.';

  @override
  String get tourSharedHostHeading => 'ISÄNTÄ';

  @override
  String get tourSharedHostsHeading => 'ISÄNNÄT';

  @override
  String get tourSharedCoHostsHeading => 'YHTEISISÄNNÄT';

  @override
  String get tourSharedVenues => 'KENTÄT';

  @override
  String get tourSharedMascot => 'MAASKOTTI';

  @override
  String get tourSharedMatchBall => 'OTTELUPALLO';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity paikkaa';
  }

  @override
  String get tourSharedCouldNotLoad => 'Lataus epäonnistui.';

  @override
  String get tourSharedHostTbc => 'ISÄNTÄ VAHVISTETAAN';

  @override
  String get tourSharedFinalsAreHere => 'LOPPUTURNAUS ALKAA';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'ISÄNTÄ  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Lopputurnaus alkakoon';

  @override
  String get tourSharedCompetitions => 'KILPAILUT';

  @override
  String get tourSharedWorldRanking => 'Maailmanranking';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Turnausten lataus epäonnistui.';

  @override
  String get tourSharedPrestigeStage => 'ARVOKISAT';

  @override
  String get tourSharedOverview => 'Yleiskatsaus';

  @override
  String get tourSharedWorldRankingTitle => 'Maailmanranking';

  @override
  String get tourSharedYourCompetitions => 'SINUN KILPAILUSI';

  @override
  String get tourSharedOtherContinents => 'MUUT MANTEREET';

  @override
  String get tourSharedComingSoon => 'Turnaus tulossa pian';

  @override
  String get tourSharedSoon => 'PIAN';

  @override
  String get tourSharedNoQualifyingDraw => 'Ei karsinta-arvontaa.';

  @override
  String get tourSharedOpenEnvelope => 'Avaa kirjekuori';

  @override
  String tourSharedGroupName(String name) {
    return 'LOHKO $name';
  }

  @override
  String get tourSharedBall => 'Pallo';

  @override
  String get tourSharedPot => 'Kori';

  @override
  String get tourSharedAll => 'Kaikki';

  @override
  String get tourSharedTapDrawTeam => 'Napauta arpoaksesi seuraavan joukkueen';

  @override
  String get tourSharedTapDrawPot => 'Napauta arpoaksesi seuraavan korin';

  @override
  String get tourSharedTapDrawAll => 'Napauta paljastaaksesi koko arvonnan';

  @override
  String get tourSharedContinue => 'Jatka';

  @override
  String get tourSharedPause => 'Tauko';

  @override
  String get tourSharedPlay => 'Toista';

  @override
  String get tourSharedSkip => 'Ohita';

  @override
  String tourSharedPotNumber(int number) {
    return 'KORI $number';
  }

  @override
  String get tourSharedDrawComplete => 'ARVONTA VALMIS';

  @override
  String get tourSharedDrawing => 'ARVOTAAN…';

  @override
  String get tourContChampionship => 'MESTARUUSKILPAILU';

  @override
  String get tourContTabSummary => 'YHTEENVETO';

  @override
  String get tourContTabQualifying => 'KARSINTA';

  @override
  String get tourContTabFinals => 'LOPPUTURNAUS';

  @override
  String get tourContTabBracket => 'KAAVIO';

  @override
  String get tourContTabAwards => 'PALKINNOT';

  @override
  String get tourContTabScorers => 'MAALIPÖRSSI';

  @override
  String get tourContTabHistory => 'HISTORIA';

  @override
  String get tourContTabRecords => 'ENNÄTYKSET';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Turnauksen lataus epäonnistui.\n$error';
  }

  @override
  String get tourContNoCupData => 'Ei turnaustietoja.';

  @override
  String get tourContUnknown => 'Tuntematon';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Karsintalohkot arvotaan seremoniassa. Katso arvonta etusivulta nähdäksesi vastustajasi.';

  @override
  String get tourContQualSeeded =>
      'Maasi on sijoitettu suoraan lopputurnaukseen. Tällä kaudella ei karsita.';

  @override
  String tourContBackgroundRegion(String name) {
    return 'Simuloidaan taustalla: $name. Tulokset ilmestyvät tänne kierros kerrallaan.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Lopputurnauksen lohkot arvotaan seremoniassa. Katso arvonta etusivulta nähdäksesi lohkosi.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Lopputurnauksen arvonta pidetään, kun karsinta on ohi.';

  @override
  String get tourContContestedBeforeWc =>
      'Pudotuspelikierrokset pelataan ennen MM-kisoja.';

  @override
  String tourContChampionsHeading(String name) {
    return '$name: MESTARIT';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Voittajat: $name';
  }

  @override
  String get tourContNoGoalsYet => 'Maaleja ei ole vielä tehty.';

  @override
  String tourContGroupHeading(String name) {
    return 'LOHKO $name';
  }

  @override
  String get tourContBestRunnersUp => 'PARHAAT TOISET';

  @override
  String tourContGroupDropdown(String name) {
    return 'Lohko $name';
  }

  @override
  String get tourContMatches => 'OTTELUT';

  @override
  String get tourContNoGroupsDrawn => 'Lohkoja ei ole vielä arvottu.';

  @override
  String get tourContQualifyingDraw => 'KARSINTA-ARVONTA';

  @override
  String get tourContWorldQualifyingDraw => 'MM-KARSINTOJEN ARVONTA';

  @override
  String get tourContFinalsDraw => 'LOPPUTURNAUKSEN ARVONTA';

  @override
  String get tourContSeedingPots => 'SIJOITUSKORIT';

  @override
  String get tourContGroupDraw => 'LOHKOARVONTA';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Arvonnan lataus epäonnistui.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Arvonta ei ole vielä valmis.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'TÄMÄ KAUSI';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Lataus epäonnistui.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Tallennusta ei löytynyt.';

  @override
  String get tourContClashSoon =>
      'Continental Clash pelataan, kun molemmat mannermestarit ovat selvillä.';

  @override
  String get tourContTwoContinentsOneMatch => 'KAKSI MANNERTA, YKSI OTTELU';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return '$name voittaa Clashin';
  }

  @override
  String get tourContNoClashYet => 'Continental Clashia ei ole vielä pelattu.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'DIVISIOONAT';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Lataus epäonnistui.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Nations Cupin maaleja ei ole vielä kirjattu.';

  @override
  String get tourContNoNationsCupChampions =>
      'Nations Cupin mestareita ei ole vielä kruunattu.';

  @override
  String get tourContNationsCupOffSeason =>
      'Tämän kauden Nations Cup alkaa mannerturnausten jälkeen. Aiemmat voittajat löytyvät Historiasta.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Tämän kauden Nations Cupin lohkot arvotaan seremoniassa. Katso arvonta etusivulta nähdäksesi, ketä vastaan pelaat.';

  @override
  String get tourContLeagueNoGroups =>
      'Tässä divisioonassa ei ole otteluita tällä kierroksella.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'DIVISIOONA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'DIVISIOONA $letter · SINUN DIVISIOONASI';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Final Fourissa kamppailevat Divisioona A:n lohkovoittajat lohkovaiheen päätyttyä.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Divisioona $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Divisioona $letter ★';
  }

  @override
  String get tourContSemiFinals => 'VÄLIERÄT';

  @override
  String get tourContFinal => 'FINAALI';

  @override
  String get tourContNationsCupDraw => 'NATIONS CUPIN ARVONTA';

  @override
  String get tourContIntercontinentalPlayoff =>
      'MAANOSIEN VÄLINEN JATKOKARSINTA';

  @override
  String get tourContNoPlayoffThisCycle => 'Ei jatkokarsintaa tällä kaudella.';

  @override
  String get tourContPlayoffIntro =>
      'Kaksi MM-paikkaa ratkaistaan pudotuspelisarjassa parhaiden karsinnoissa vaille paikkaa jääneiden kesken.';

  @override
  String get tourContPlayoffThrough =>
      'Selvisit jatkokarsinnasta. Olet MM-kisoissa!';

  @override
  String get tourContPlayoffOut =>
      'Jäit jatkokarsinnassa vaille paikkaa. Ei MM-kisoja tällä kertaa.';

  @override
  String get tourContContinue => 'Jatka';

  @override
  String get tourContPlayoffFinals => 'JATKOKARSINNAN FINAALIT';

  @override
  String get tourContPlayoffSeeded => 'Sijoitettu (vapaakierros)';

  @override
  String get tourCupTabSummary => 'YHTEENVETO';

  @override
  String get tourCupTabQualifying => 'KARSINTA';

  @override
  String get tourCupTabPlayoff => 'JATKOKARSINTA';

  @override
  String get tourCupPlayoffSoon =>
      'Maanosien välinen jatkokarsinta ratkeaa, kun kaikkien mannerliittojen karsinnat on pelattu.';

  @override
  String get tourCupTabFinals => 'LOPPUTURNAUS';

  @override
  String get tourCupTabBracket => 'KAAVIO';

  @override
  String get tourCupTabAwards => 'PALKINNOT';

  @override
  String get tourCupTabScorers => 'MAALIPÖRSSI';

  @override
  String get tourCupTabHistory => 'HISTORIA';

  @override
  String get tourCupTabRecords => 'ENNÄTYKSET';

  @override
  String get tourCupTitle => 'MM-KISAT';

  @override
  String get tourCupNoData => 'Ei turnaustietoja.';

  @override
  String tourCupLoadError(String error) {
    return 'Turnauksen lataus epäonnistui.\n$error';
  }

  @override
  String get tourCupUnknown => 'Tuntematon';

  @override
  String get tourCupWorldChampions => 'MAAILMANMESTARIT';

  @override
  String get tourCupWorldChampionsTitle => 'Maailmanmestarit';

  @override
  String get tourCupStillActive => 'Yhä mukana';

  @override
  String get tourCupAllTimeScorers => 'KAIKKIEN AIKOJEN MAALINTEKIJÄT';

  @override
  String get tourCupAllConfederations => 'Kaikki mannerliitot';

  @override
  String get tourCupBestRunnersUp => 'Parhaat toiset';

  @override
  String get tourCupCompWorld => 'MM-kisat';

  @override
  String get tourCupCompEurope => 'EM-kisat';

  @override
  String get tourCupCompSAmerica => 'Etelä-Amerikan Cup';

  @override
  String get tourCupDestRoundOf16 => '16 parhaan kierrokseen';

  @override
  String get tourCupDestKnockouts => 'pudotuspeleihin';

  @override
  String get tourCupDestFinals => 'lopputurnaukseen';

  @override
  String get tourCupDestFinalsPlayoff => 'lopputurnauksen jatkokarsintaan';

  @override
  String get tourCupDestIntercontPlayoff =>
      'maanosien väliseen jatkokarsintaan';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Lopputurnauksen lohkot arvotaan karsintojen päätyttyä.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Lohkot arvotaan. Katso MM-kisojen arvonta etusivulta paljastaaksesi ne.';

  @override
  String tourCupGroupName(String name) {
    return 'Lohko $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Lohko $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Isäntä: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Isännät: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Maanosien välinen jatkokarsinta';

  @override
  String get tourCupKnockoutSoon => 'Kaavio avautuu lohkovaiheen päätyttyä.';

  @override
  String get tourCupMatches => 'OTTELUT';

  @override
  String get tourCupMedalTable => 'MITALITAULUKKO';

  @override
  String get tourCupMostTitles => 'ENITEN MESTARUUKSIA';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles mestaruutta, $editions turnausta';
  }

  @override
  String get tourCupNoGoals => 'Ei vielä maaleja.';

  @override
  String get tourCupNoGroups => 'Lohkoja ei ole arvottu.';

  @override
  String get tourCupNoHistory => 'Ei vielä historiaa.';

  @override
  String get tourCupPastWinners => 'AIEMMAT VOITTAJAT';

  @override
  String get tourCupPlayoffIntro =>
      'Kaksi MM-paikkaa ratkaistaan pudotuspelisarjassa parhaiden karsinnoissa vaille paikkaa jääneiden kesken.';

  @override
  String tourCupPlayoffNoEntrants(String confederation) {
    return '$confederation: ei jatkokarsintaa. Kaikki paikat ratkeavat karsintalohkoissa.';
  }

  @override
  String get tourCupQualDrawSoon =>
      'Lohkot arvotaan. Katso karsinta-arvonta etusivulta paljastaaksesi ne.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · sinun';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (rp)';
  }

  @override
  String get tourCupSegAllTime => 'Kaikkien aikojen';

  @override
  String get tourCupSegFinals => 'Lopputurnaus';

  @override
  String get tourCupSegQualifying => 'Karsinta';

  @override
  String get playerTraitsTitle => 'TUNNETTU SIITÄ';

  @override
  String get traitBigGame => 'Suurten pelien pelaaja';

  @override
  String get traitBigGameBlurb => 'Nostaa tasoaan pudotuspeleissä.';

  @override
  String get traitSetPiece => 'Vakiotilanteiden asiantuntija';

  @override
  String get traitSetPieceBlurb =>
      'Parempi pallonjako ja enemmän maaleja vakiotilanteista.';

  @override
  String get traitHothead => 'Kuumapää';

  @override
  String get traitHotheadBlurb =>
      'Kerää selvästi enemmän kortteja kuin joukkuetoverinsa.';

  @override
  String get traitIronMan => 'Rautamies';

  @override
  String get traitIronManBlurb => 'Loukkaantuu harvoin ja väsyy hitaammin.';

  @override
  String get traitWonderkid => 'Ihmelapsi';

  @override
  String get traitWonderkidBlurb =>
      'Nuori, jo nyt hyvä ja kehittyy yhä nopeasti.';

  @override
  String get traitLeader => 'Johtaja';

  @override
  String get traitLeaderBlurb =>
      'Nostaa jokaisen joukkuetoverin tasoa kentällä.';

  @override
  String get traitPacey => 'Nopea';

  @override
  String get traitPaceyBlurb =>
      'Tulinen vauhti, jatkuva uhka puolustuksen selän taakse.';

  @override
  String get traitOldHead => 'Konkari';

  @override
  String get traitOldHeadBlurb =>
      'Veteraani, jonka pelinluku kestää pidempään kuin jalat.';

  @override
  String get traitWasteful => 'Haaskaaja';

  @override
  String get traitWastefulBlurb => 'Ampuu liian monta hyvää paikkaa ohi.';

  @override
  String get objectiveWorldCup => 'MM-kisat';

  @override
  String get objectiveWinTournament => 'Voita turnaus';

  @override
  String get objectiveQualifyGeneric => 'Pääse turnaukseen';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Voita MM-kisat';

  @override
  String get objectiveReachFinal => 'Pääse finaaliin';

  @override
  String get objectiveReachSemis => 'Pääse välieriin';

  @override
  String get objectiveReachQuarters => 'Pääse puolivälieriin';

  @override
  String get objectiveReachKnockouts => 'Pääse pudotuspeleihin';

  @override
  String get objectiveQualify => 'Selviä MM-kisoihin';

  @override
  String get finishChampions => 'Mestarit';

  @override
  String get finishRunnersUp => 'Finalisti';

  @override
  String get finishSemiFinals => 'Välierät';

  @override
  String get finishQuarterFinals => 'Puolivälierät';

  @override
  String get finishRoundOf16 => 'Kahdeksannesfinaali';

  @override
  String get finishGroupStage => 'Lohkovaihe';

  @override
  String get objectiveQualifyingTopHalf =>
      'Sijoitu karsintalohkon yläpuoliskolle';

  @override
  String get finishQualifyingTopHalf => 'Karsintalohkon yläpuolisko';

  @override
  String get finishQualifyingBottomHalf => 'Karsintalohkon alapuolisko';

  @override
  String get objectiveNcWinIt => 'Voita Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Pääse Nations Cupin finaaliin';

  @override
  String get objectiveNcFinalsFour => 'Pääse Final Fouriin';

  @override
  String get objectiveNcWinGroup =>
      'Voita lohkosi ja nouse ylempään divisioonaan';

  @override
  String get objectiveNcTopHalf => 'Sijoitu lohkosi yläpuoliskolle';

  @override
  String get objectiveNcSurvive => 'Vältä putoaminen';

  @override
  String get objectiveNcOffTheBottom => 'Vältä lohkon viimeinen sija';

  @override
  String get finishNcChampions => 'Nations Cupin voittajat';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Lohkovoittajat';

  @override
  String get finishNcTopHalf => 'Lohkon yläpuolisko';

  @override
  String get finishNcStayedUp => 'Säilytti paikkansa';

  @override
  String get finishNcClearOfBottom => 'Ei lohkon viimeinen';

  @override
  String get finishNcBottom => 'Lohkon viimeinen';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'PELAAJA';

  @override
  String get squadDevAge => 'IKÄ';

  @override
  String get squadDevPosition => 'PP';

  @override
  String get squadDevChange => 'TASO';

  @override
  String get squadDevNew => 'UUSI';

  @override
  String get squadDevRetired => 'LOPETTI';

  @override
  String get squadDevEmpty => 'Rauhallinen vuosi. Joukkueessa ei muutoksia.';

  @override
  String get squadDevTierRegulars => 'KANTAPELAAJAT';

  @override
  String get squadDevTierFringe => 'REUNAPELAAJAT';

  @override
  String get squadDevTierYouth => 'NUORET';

  @override
  String get boardObjectivesTitle => 'Hallituksen tavoitteet';

  @override
  String get boardObjectivesConfidence => 'Hallituksen luottamus';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds kierrosta vaadittua pidemmälle',
      one: 'kierros vaadittua pidemmälle',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds kierrosta vaadittua vähemmän',
      one: 'kierros vaadittua vähemmän',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'VIELÄ AVOIN';

  @override
  String boardObjectiveSoFar(String result) {
    return 'TÄHÄN MENNESSÄ · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Hallitus ei ole asettanut tavoitetta tälle kaudelle.';

  @override
  String get tourContBestWinners => 'PARHAAT LOHKOVOITTAJAT';

  @override
  String get tourContBestThirds => 'PARHAAT KOLMOSET';

  @override
  String tourContBestPlaced(String position) {
    return 'PARHAAT $position. SIJAN JOUKKUEET';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total pelaajaa';
  }

  @override
  String get matchSoldOut => 'LOPPUUNMYYTY';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return 'Katsomosta täynnä $attendance/$capacity paikkaa';
  }

  @override
  String get matchGroundTitle => 'OTTELUPAIKKA';

  @override
  String get absenceInjured => 'Loukkaantunut';

  @override
  String get absenceSuspended => 'Pelikiellossa';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString viikkoa',
      one: '1 viikko',
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
      other: '$countString ottelua',
      one: '1 ottelu',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Takaisin: $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Rangaistuspotkut';

  @override
  String get penaltyOrderBlurb =>
      'Nimeä viisi potkijaa järjestyksessä. Vaihda napauttamalla paikkaa.';

  @override
  String penaltyOrderPick(int number) {
    return 'Potku $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Valitse, kuka astuu pisteelle. Palkki näyttää pelaajan malttia rangaistuspotkupisteellä.';

  @override
  String get penaltyOrderConfirm => 'Potkimaan';

  @override
  String get penaltyOrderCancel => 'Takaisin';

  @override
  String get youthTitle => 'Nuoret';

  @override
  String get youthEmptyLevel => 'Tällä tasolla ei ole vielä ketään.';

  @override
  String get youthReleased => 'Vapautettu tänä vuonna';

  @override
  String get u21Title => 'Alle 21-vuotiaat';

  @override
  String get u21Blurb =>
      'Seuraava sukupolvi, paras lupaus ensin. Tyhjät tähdet ovat scoutin arvio. Pelauta pelaajaa maajoukkueessa, niin selviää, mitä hänessä oikeasti on.';

  @override
  String get u21Empty =>
      'Poolissa ei ole juuri nyt ketään alle 21-vuotiasta. Seuraava tulokaskerta saapuu uuden kauden mukana.';

  @override
  String u21Breakout(int gain) {
    return '+$gain TÄNÄ VUONNA';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Ikä $age · $caps maaottelua';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Ikä $age · ei maaotteluita';
  }

  @override
  String get u21CallUps => 'Kutsuihin';

  @override
  String get youthWatching => 'Seurannassa';

  @override
  String get youthWatchEmpty =>
      'Ketään ei ole vielä merkitty. Merkitse poika miltä tahansa tasolta, niin hän ilmestyy tänne sen mukana, mitä hänestä on tullut.';

  @override
  String get youthWatchMark => 'Seuraa tätä poikaa';

  @override
  String get youthWatchUnmark => 'Lopeta seuraaminen';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Merkitty arvosanalla $rating, ikä $age';
  }

  @override
  String get youthWatchSenior => 'Siirtynyt aikuisten pooliin';

  @override
  String get youthWatchReleased => 'Akatemia vapautti';

  @override
  String get youthWatchGone => 'Ei enää nuorten sarjoissa';

  @override
  String get tacticsYouth => 'Alle 21-vuotiaat';

  @override
  String get pressSquad => 'Pukukoppi';

  @override
  String get pressBoard => 'Hallitus';

  @override
  String get pressNoEffect => 'Kukaan ei lue tästä paljoakaan';

  @override
  String get matchNeutralGround => 'NEUTRAALI';

  @override
  String get matchExtraTimeAhead => 'JATKOAIKA';

  @override
  String get matchExtraTimeHalf => 'JATKOAIKA · TAUKO';

  @override
  String get matchClockFullTime => 'LOPPUVIHELLYS';

  @override
  String get matchClockAfterExtraTime => 'JATKOAJAN JÄLKEEN';

  @override
  String get matchClockPenalties => 'RANKKARIT';

  @override
  String get matchClockFullTimePenalties => 'LOPPU · RANKKARIT';

  @override
  String get hubEventPressConference => 'Kohtaa media';

  @override
  String get hubEventPressConferenceSub =>
      'Maailman media haluaa sanasen ennen ensimmäistä ottelua';

  @override
  String get squadDevWonderkid => 'IHMELAPSI';

  @override
  String get tacticsPlaystyle => 'Pelityyli';

  @override
  String get tacticsPlaystyleBlurb =>
      'Valitse, miten joukkue pelaa; alla olevat säätimet hienosäätävät tyyliä.';

  @override
  String get tacticsPlaystyleCustom =>
      'Omat asetukset. Mikään nimetty tyyli ei vastaa näitä säätimiä.';

  @override
  String get playstyleCustom => 'Oma';

  @override
  String get playstyleBalanced => 'Tasapainoinen';

  @override
  String get playstylePossession => 'Pallonhallinta';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Vastahyökkäys';

  @override
  String get playstyleDirect => 'Suora peli';

  @override
  String get playstyleLowBlock => 'Matala blokki';

  @override
  String get playstyleWingPlay => 'Laitapeli';

  @override
  String get playstyleBalancedBlurb =>
      'Vakaa molemmissa päissä, mitään ei viedä äärimmäisyyksiin.';

  @override
  String get playstylePossessionBlurb =>
      'Pidä pallo, kierrätä sitä kärsivällisesti ja kavenna kenttää.';

  @override
  String get playstyleGegenpressBlurb =>
      'Voita pallo takaisin heti kun se menetetään, korkealla kentällä.';

  @override
  String get playstyleCounterBlurb =>
      'Odota matalalla, pysy tiiviinä ja iske sitten nopeasti.';

  @override
  String get playstyleDirectBlurb =>
      'Pallo nopeasti eteen ja pelaa toisesta pallosta.';

  @override
  String get playstyleLowBlockBlurb =>
      'Matalalla, kapeana ja erittäin vaikea murtaa.';

  @override
  String get playstyleWingPlayBlurb =>
      'Levitä kenttä, kierrä laidan kautta ja keskitä.';

  @override
  String get nationsRandomTeam => 'Satunnainen joukkue';

  @override
  String get nationsFromTheBottom => 'Pohjalta alkaen';

  @override
  String get bottomStartTitle => 'Työtön';

  @override
  String get bottomStartHeading => 'Kolme liittoa haluaa puhua kanssasi';

  @override
  String get bottomStartBlurb =>
      'Sinulla ei ole työtä eikä mainetta. Nämä ovat ainoat joukkueet, jotka ovat valmiita ottamaan riskin. Ota yksi ja rakenna tyhjästä jotain suurta.';

  @override
  String get bottomStartAccept => 'Ota työ';

  @override
  String get bottomStartBack => 'Takaisin valikkoon';

  @override
  String bottomStartRankOf(int rank, int total) {
    return 'Sija $rank/$total maailmassa';
  }

  @override
  String get campTitle => 'Leiripaikka';

  @override
  String campBasedIn(String host) {
    return 'Sijainti: $host';
  }

  @override
  String get campBlurb =>
      'Paikka, jossa joukkue asuu koko turnauksen ajan. Sitä ei voi vaihtaa pelien alettua, ja se vaikuttaa jokaiseen otteluun kolmella tavalla: kuinka virkeinä pelaajat saapuvat, kuinka nopeasti tällit paranevat ja kuinka terävässä kunnossa he ovat.';

  @override
  String get campEffectTravel => 'Saapuu virkeänä';

  @override
  String get campEffectRecovery => 'Vammat paranevat';

  @override
  String get campEffectSharpness => 'Ottelukunto';

  @override
  String get campTerrainCity => 'Kaupungin keskusta';

  @override
  String get campTerrainCoastal => 'Rantalomakeskus';

  @override
  String get campTerrainMountain => 'Vuoristoleiri';

  @override
  String get campTerrainAltitude => 'Korkeusleiri';

  @override
  String get campTerrainNationalCentre => 'Valmennuskeskus';

  @override
  String get campTerrainCityBlurb =>
      'Kaikki ovella eikä matkustamista, mutta ei rauhaa eikä pakoa melulta.';

  @override
  String get campTerrainCoastalBlurb =>
      'Rauhallinen, mukava ja hyväksi tunnelmalle; pitkä bussimatka jokaiselle stadionille.';

  @override
  String get campTerrainMountainBlurb =>
      'Viileä ilma ja huippuluokan lääkintätiimi, joka saa tällit nopeasti kuntoon, mutta kaukana turnauksesta.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Rankka harjoitella, mutta jalat kestävät pitkälle turnaukseen.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Liiton omat tilat: ei mitään näyttävää, ei mitään mikä voisi mennä pieleen.';

  @override
  String get hubEventChooseCamp => 'Valitse leiripaikka';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Missä joukkue majoittuu: $host';
  }

  @override
  String get tacticsTabBench => 'Vaihtopenkki';

  @override
  String get squadSearchHint => 'Hae nimellä tai seuralla';

  @override
  String get squadFilterAll => 'Kaikki';

  @override
  String get squadFilterInSquad => 'Kokoonpanossa';

  @override
  String get squadFilterUncapped => 'Ei maaotteluita';

  @override
  String get squadFilterUnavailable => 'Poissa pelistä';

  @override
  String get squadLineAll => 'Kaikki linjat';

  @override
  String get squadSortBy => 'Lajittelu';

  @override
  String get squadSortRating => 'Taso';

  @override
  String get squadSortCaps => 'Maaottelut';

  @override
  String get squadSortGoals => 'Maalit';

  @override
  String get squadSortAge => 'Ikä';

  @override
  String get squadSortName => 'Nimi';

  @override
  String get squadLegendTitle => 'Mitä merkit tarkoittavat';

  @override
  String get squadLegendStarting => 'Avauskokoonpanossasi';

  @override
  String get squadLegendCalledUp => 'Kutsuttu, vaihtopenkillä';

  @override
  String get squadLegendRatingUp => 'Taso nousussa tänä vuonna';

  @override
  String get squadLegendRatingDown => 'Taso laskussa tänä vuonna';

  @override
  String get squadLegendInjured => 'Loukkaantunut, poissa pelistä';

  @override
  String get squadLegendSuspended => 'Pelikiellossa, poissa pelistä';

  @override
  String get squadLegendTraits => 'TUNNETTU SIITÄ';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Näytetään $shown/$total pelaajaa';
  }

  @override
  String get squadNobodyMatches =>
      'Kukaan poolin pelaajista ei vastaa näitä suodattimia.';

  @override
  String get squadStatPool => 'Pooli';

  @override
  String get squadStatInSquad => 'Kutsuttu';

  @override
  String get squadMostCapped => 'Eniten maaotteluita';

  @override
  String get squadTopScorer => 'Maalikuningas';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps maaottelua';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals maalia';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Ott.';

  @override
  String get squadGoalsShort => 'Maal.';

  @override
  String get recordsRecordBookSubtitle =>
      'Maaottelut, maalit ja joukkueen tärkeimmät ennätykset';

  @override
  String get statsLegacy => 'PERINTÖ';

  @override
  String tacticsSubAlreadyOff(String name) {
    return '$name on jo vaihdettu pois eikä voi palata kentälle.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return '$name on ajettu ulos eikä osallistu enää peliin.';
  }

  @override
  String get tacticsInjuredShort => 'LOUKKAUS';

  @override
  String get tacticsSuspendedShort => 'KIELLOSSA';

  @override
  String get confEurope => 'Eurooppa';

  @override
  String get confSouthAmerica => 'Etelä-Amerikka';

  @override
  String get confNorthAmerica => 'Pohjois-Amerikka';

  @override
  String get confAfrica => 'Afrikka';

  @override
  String get confAsia => 'Aasia';

  @override
  String get confOceania => 'Oseania';

  @override
  String get compWorldCup => 'MM-kisat';

  @override
  String get compWorldCupFinals => 'MM-kisojen lopputurnaus';

  @override
  String get compWorldCupQualifying => 'MM-karsinnat';

  @override
  String compQualifiers(String region) {
    return 'Karsinnat: $region';
  }

  @override
  String get compFriendlies => 'Harjoitusottelut';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Maanosien välinen jatkokarsinta';

  @override
  String get compContinentalChampionship => 'Maanosien mestaruuskilpailut';

  @override
  String get compEuropeanChampionship => 'EM-kisat';

  @override
  String get compSouthAmericaCup => 'Etelä-Amerikan Cup';

  @override
  String get compAfricanChampionship => 'Afrikan mestaruuskilpailut';

  @override
  String get compAsianChampionship => 'Aasian mestaruuskilpailut';

  @override
  String get compNorthAmericaCup => 'Pohjois-Amerikan Cup';

  @override
  String get compOceaniaCup => 'Oseanian Cup';

  @override
  String get msgANation => 'Jokin maa';

  @override
  String get msgAPlayer => 'Jokin pelaaja';

  @override
  String get msgAHostNation => 'isäntämaa';

  @override
  String get msgCycleTitle1 => 'Uusi kausi alkaa';

  @override
  String msgCycleTitle2(int year) {
    return 'Tie vuoteen $year avautuu';
  }

  @override
  String get msgCycleTitle3 => 'Uusi kampanja käynnistyy';

  @override
  String get msgCycleTitle4 => 'Takaisin töihin';

  @override
  String msgCycleBody1(int year) {
    return 'Tie MM-kisoihin $year alkaa tästä.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Uusi kausi. Tavoitteena MM-kisat $year.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Neljä vuotta MM-kisoihin $year. Työt alkavat nyt.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Kampanja $year alkaa tänään.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return '$cup, isäntämaa: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return 'Seuraavan kisan $cup isäntämaa on $host.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return '$cup: karsinta-arvonta';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Kisan $cup karsintalohkot on arvottu.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'MM-kisojen $year isäntämaa: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return 'MM-kisojen $year isäntämaa on $host.';
  }

  @override
  String get msgWcQualDrawTitle => 'MM-karsintojen arvonta';

  @override
  String get msgWcQualDrawBody => 'MM-karsintojen lohkot on arvottu.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return '$cup: lopputurnauksen arvonta';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Kisan $cup lopputurnauksen lohkot on arvottu.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'MM-kisojen lopputurnauksen arvonta';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'MM-kisojen $year lopputurnauksen arvonta on suoritettu.';
  }

  @override
  String get msgQualWcTitle1 => 'Matka jatkuu MM-kisoihin';

  @override
  String get msgQualWcTitle2 => 'MM-paikka varmistettu';

  @override
  String get msgQualWcTitle3 => 'Me lähdemme MM-kisoihin';

  @override
  String get msgQualWcTitle4 => 'Lippu taskussa';

  @override
  String msgQualWcBody1(int year) {
    return 'Olet selvittänyt tiesi MM-kisojen $year lopputurnaukseen.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Virallista: maasi on mukana MM-kisoissa $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Paikka MM-kisoihin $year on varmistettu.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Pääsit MM-kisojen $year lopputurnaukseen.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Jatkoon: $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return '$cup: paikka varmistettu';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Pääsy varmistui: $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Olet selvittänyt tiesi kisan $cup lopputurnaukseen.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Maasi varmisti paikkansa kisaan $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Pääsit kisaan $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return '$comp: MESTARIT!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return '$comp: olet mestari!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Voitit kisan $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return '$comp: ratkaisu tehty';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return '$comp: mestari kruunattu';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return '$comp: voittaja selvillä';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return '$comp $year: maasi on mestari. Finaalissa kaatui $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return '$comp $year on sinun. Finaalin hävisi $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return '$comp $year kuuluu sinulle. Häviäjä: $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner voitti kisan $comp $year. Finaalissa kaatui $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return '$winner on kisan $comp $year mestari. Finaalin hävisi $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' ($home–$away)';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' ($home–$away, ratkaisu rangaistuspotkuilla)';
  }

  @override
  String get msgWpotyTitle => 'Vuoden maailmanpelaaja';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return '$name ($nation) valittiin vuoden $year maailmanpelaajaksi, yksi omistasi.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return '$name ($nation) valittiin vuoden $year maailmanpelaajaksi.';
  }

  @override
  String get msgYpotTitle => 'Turnauksen nuori pelaaja';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return '$name ($nation), $age-vuotias, valittiin turnauksen $year nuoreksi pelaajaksi, yksi omistasi.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return '$name ($nation), $age-vuotias, valittiin turnauksen $year nuoreksi pelaajaksi.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Pysyt sijalla #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Ei muutosta, yhä sijalla #$rank.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Vakaasti sijalla #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move sijaa',
      one: '1 sija',
    );
    return 'Nousua yhteensä $_temp0, sijalle #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move sijan',
      one: '1 sijan',
    );
    return '$_temp0 nousu vie sinut sijalle #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move sijaa',
      one: '1 sija',
    );
    return 'Nousua $_temp0, nyt sijalla #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move sijaa',
      one: '1 sija',
    );
    return 'Laskua yhteensä $_temp0, sijalle #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move sijan',
      one: '1 sijan',
    );
    return '$_temp0 pudotus vie sinut sijalle #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move sijaa',
      one: '1 sija',
    );
    return 'Laskua $_temp0, nyt sijalla #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Olet maailman kärjessä.';

  @override
  String msgRankLeadOther(String nation) {
    return 'Maailman kärjessä: $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Maailmanranking · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Maailmanranking on päivitetty. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Nousu sijalle #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Pudotus sijalle #$rank';
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
      other: '$move sijaa',
      one: '1 sija',
    );
    return '$tournament on heilauttanut maailmanrankingia. $nation lähti sijalta #$from ja päätyi sijalle #$to, nousua $_temp0.';
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
      other: '$move sijaa',
      one: '1 sija',
    );
    return '$tournament on heilauttanut maailmanrankingia. $nation lähti sijalta #$from ja päätyi sijalle #$to, laskua $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'MM-kisojen arvonnasta lähtien';

  @override
  String get rankingSinceCycleStart => 'Kampanjan alusta lähtien';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from → #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return '$name saavuttaa $count maaottelua';
  }

  @override
  String msgCapsBody(String name, int count) {
    return '$name on nyt pelannut $count maaottelua maasi paidassa.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return '$name saavuttaa $count maalia';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return '$name on tehnyt $count maalia maasi maajoukkueessa.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Joukkueen kehitys · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Akatemiasta ylös · $year';
  }

  @override
  String get msgThroughNote =>
      'Nämä eivät ole uutta tulokaskertaa. He ovat poikia, jotka tulivat mukaan yksitoistavuotiaina ja ovat nyt kasvaneet aikuisten pooliin.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Uudet kasvot · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Akatemiaan tehty panostus näkyy: tämä tulokaskerta saapui vahvempana kuin muuten olisi saapunut.';

  @override
  String get msgIntakeNoteStanding =>
      'Maa seuraa tätä joukkuetta: kun joukkue nousee maailmanrankingissa, parhaat pojat valitsevat jalkapallon, ja tämä tulokaskerta saapui siksi vahvempana.';

  @override
  String get msgIntakeNoteBoth =>
      'Sekä akatemian rahoitus että joukkueen nousu maailmanrankingissa näkyvät: tämä tulokaskerta saapui vahvempana kuin muuten olisi saapunut.';

  @override
  String msgIntakeTitle(int year) {
    return 'Akatemian tulokkaat · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Kapteenisi $name lopettaa';
  }

  @override
  String msgRetireTitle(String name) {
    return '$name lopettaa maajoukkueuransa';
  }

  @override
  String msgRetireBody(String name, int age) {
    return '$name on lopettanut maajoukkueuransa $age-vuotiaana.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return '$name on lopettanut maajoukkueuransa $age-vuotiaana, uran saldo: $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maaottelua',
      one: '1 maaottelu',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maalia',
      one: '1 maali',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Kapteenin nauha on vapaana. Nimeä uusi kapteeni kutsuruudulla.';

  @override
  String msgHofTitle(String name) {
    return '$name valittiin Hall of Fameen';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return '$name liittyy maasi Hall of Fameen ($caps maaottelua, $goals maalia). Näet hänet Legendat-osiossa.';
  }

  @override
  String hubBanTitle(String name) {
    return '$name pelikieltoon';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'seuraavat $matches ottelua',
      one: 'seuraavan ottelun',
    );
    return '$name $how ja on pelikiellossa $_temp0. Hän ei ole valittavissa.';
  }

  @override
  String get hubBanHowSecondYellow => 'sai ulosajon toisesta keltaisesta';

  @override
  String get hubBanHowViolent =>
      'sai suoran punaisen väkivaltaisesta käytöksestä';

  @override
  String get hubBanHowRed => 'ajettiin ulos';

  @override
  String hubInjuryTitle(String name) {
    return '$name loukkaantui';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches ottelua',
      one: '1 ottelun',
    );
    return '$name sai vamman ja on sivussa $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Hopeasijalle';

  @override
  String get hubRunnerUpTitle2 => 'Niin lähellä, silti kaukana';

  @override
  String get hubRunnerUpTitle3 => 'Hopeamitalit';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Pääsit kisan $cup finaaliin, mutta $opponent oli parempi. Niin lähellä. Hopeaa tällä kertaa.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Finaali ($cup): $opponent oli parempi. Hopealle jäit tuskallisen niukasti.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Finaali ($cup) lipui käsistä, vastustajana $opponent. Ylpeydenaiheita on paljon, mutta pokaali jäi saamatta.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Putosit turnauksesta';

  @override
  String get hubKnockedOutTitle2 => 'Matka päättyi';

  @override
  String get hubKnockedOutTitle3 => 'Taival ohi';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Putosit kisasta $cup. Vastustaja: $opponent, vaihe: $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return 'Taipaleesi kisassa $cup päättyi: $opponent pysäytti sinut, vaihe: $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return '$cup: matkasi päättyy, vaihe: $stage. Vastustaja: $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Lohkovaiheen pudotus';

  @override
  String get hubGroupExitTitle2 => 'Ulos lohkovaiheessa';

  @override
  String get hubGroupExitTitle3 => 'Aikainen suihku';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Kisa $cup päättyi lohkovaiheeseen. Pudotuspeleihin ei riittänyt.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Lohkosta ei päästy jatkoon. Kisa $cup päättyy tähän.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Ei pudotuspelipaikkaa tällä kertaa. Kisa $cup jäi lohkovaiheeseen.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Tavoite saavutettu: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Tavoite jäi saavuttamatta: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Hallituksen tavoite kisassa $comp: $demand. Sijoituksesi: $finish. Hallitus sai mitä pyysi.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Hallituksen tavoite kisassa $comp: $demand. Sijoituksesi: $finish. Se jäi odotuksista.';
  }

  @override
  String get newsWcMissTitle => 'MM-unelma ohi';

  @override
  String newsWcMissBody(int year) {
    return 'Et päässyt MM-kisoihin $year. Karsintakampanja jäi vajaaksi. Neljä vuotta lisää.';
  }

  @override
  String get newsRecordScorerTitle => 'Kaikkien aikojen maalikuningas';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return '$name on nyt pelin kaikkien aikojen paras maalintekijä $goals maalilla.';
  }

  @override
  String get newsRecordCapsTitle => 'Eniten maaotteluita pelannut';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return '$name on nyt pelin eniten maaotteluita pelannut pelaaja $caps ottelulla.';
  }

  @override
  String get newsARecordBreaker => 'Uusi ennätyksentekijä';

  @override
  String newsTransferTitle(String name, String club) {
    return '$name siirtyy: $club';
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
    return '$name ($position, $rating) siirtyi: $fromClub → $destination. Siirtosumma: $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club, $country';
  }

  @override
  String get newsTransferFree => 'Ilmainen';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '$name vaihtaisi maata: $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return '$name haluaa edustaa maata: $nation';
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
    return '$name, $age-vuotias $position (arvosana $rating), edustaa nyt toista maata ($fromNation). Hänellä on perhesiteitä maahan $nation ja hän on valmis vaihtamaan. Avaa kansalaistamistarjous hyväksyäksesi tai hylätäksesi.';
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
    return '$name, $age-vuotias $position (arvosana $rating), edustaa nyt toista maata ($fromNation). Hän on tähtinimi, jolla on perhesiteitä maahan $nation, ja hän on valmis vaihtamaan. Avaa kansalaistamistarjous hyväksyäksesi tai hylätäksesi.';
  }

  @override
  String get newsTheirNation => 'nykyinen maa';

  @override
  String get newsYourNation => 'sinun maasi';

  @override
  String get tourStatusChampions => 'MESTARIT';

  @override
  String get tourStatusFinals => 'LOPPUTURNAUS';

  @override
  String get tourStatusQualifying => 'KARSINNAT';

  @override
  String get tourStatusUpcoming => 'TULOSSA';

  @override
  String get tourStatusInProgress => 'KÄYNNISSÄ';

  @override
  String get tourStatusComingSoon => 'PIAN';

  @override
  String get tourStatusDecided => 'RATKAISTU';

  @override
  String tourStatusLeague(String letter) {
    return 'DIV. $letter';
  }

  @override
  String get tourDrawWcQualifying => 'MM-KARSINTAARVONTA';

  @override
  String tourDrawContQualifying(String cup) {
    return 'KARSINTAARVONTA: $cup';
  }

  @override
  String get tourDrawWcHost => 'MM-ISÄNTÄ';

  @override
  String tourDrawContHost(String cup) {
    return 'ISÄNTÄ: $cup';
  }

  @override
  String get tourDrawHostsReveal => 'Ja isännät ovat…';

  @override
  String get tourDrawHostReveal => 'Ja isäntä on…';

  @override
  String get tourDrawHostCandidates => 'Ehdokkaat:';

  @override
  String get tourKickoffContinentalCup => 'MANNERTURNAUS';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Karsinta epäonnistui: $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Et selvinnyt turnaukseen: $cup. Karsintakampanja jäi tällä kertaa vajaaksi.';
  }

  @override
  String get potyLabelBest => 'Vuoden pelaaja';

  @override
  String get potyLabelYoung => 'Vuoden nuori pelaaja';

  @override
  String potyTallyAssists(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count syöttöä',
      one: '1 syöttö',
    );
    return '$_temp0';
  }

  @override
  String potyOverallValue(int value) {
    return 'Taso $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Arvosana $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Vuoden maailmanpelaaja $year';
  }

  @override
  String newsPotyBody(String name) {
    return '$name on tämän vuoden paras pelaaja maailmassa.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' $name palkittiin vuoden nuorena pelaajana.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Tarkkailemasi pojat, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain pistettä',
      one: 'yksi piste',
    );
    return '$name otti harppauksen tasolle $rating, $_temp0 enemmän kuin viime vuonna.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return '$name nousee ikäryhmään $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return '$name debytoi maajoukkueessa';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return '$name pelasi ensimmäisen maaottelunsa $age-vuotiaana, arvosana $rating. Yksi tarkkailemistasi pojista.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Pallonhallinta, pelaajien arvosanat ja ottelun paras pelaaja selviävät vasta loppuvihellyksellä.';

  @override
  String get matchPlayerRatings => 'PELAAJIEN ARVOSANAT';

  @override
  String get matchSubstitutions => 'VAIHDOT';

  @override
  String get matchSubstitutes => 'VARAPELAAJAT';

  @override
  String get matchPlayerOfTheMatch => 'OTTELUN PARAS PELAAJA';

  @override
  String get matchGoalShout => 'MAALI!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'RANKKARIT $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: MAALI';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: HUTI';
  }

  @override
  String get matchFeedKickOff => 'Aloituspotku!';

  @override
  String get matchFeedNoEvents => 'Ei vielä tapahtumia.';

  @override
  String get tourVenues => 'OTTELUPAIKAT';

  @override
  String tourPot(int number) {
    return 'KORI $number';
  }

  @override
  String get tourHostSelection => 'ISÄNNÄN VALINTA';

  @override
  String get tourCandidates => 'EHDOKKAAT';

  @override
  String get tourJointBid => 'YHTEISHAKEMUS';

  @override
  String get tourGoldenGlove => 'KULTAINEN HANSKA';

  @override
  String get tourTeamOfTournament => 'TURNAUKSEN JOUKKUE';

  @override
  String get tourYourRun => 'SINUN TAIVALEESI';

  @override
  String get tourMedalTable => 'MITALITAULUKKO';

  @override
  String tourHostLine(String nation) {
    return 'Isäntä: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Isännät: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Lohko $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Sijoitus maailmanrankingin mukaan. Bongaa oma maasi ennen arvontaa.';

  @override
  String get tourWorldRanking => 'Maailmanranking';

  @override
  String get tourYourCompetitions => 'SINUN KILPAILUSI';

  @override
  String get tourOtherContinents => 'MUUT MANTEREET';

  @override
  String get tourZoneGlobal => 'MAAILMA';

  @override
  String get tourZoneEurope => 'EUROOPPA';

  @override
  String get tourZoneSouthAmerica => 'ETELÄ-AM.';

  @override
  String get tourZoneNorthAmerica => 'POHJOIS-AM.';

  @override
  String get tourZoneAfrica => 'AFRIKKA';

  @override
  String get tourZoneAsia => 'AASIA';

  @override
  String get tourZoneOceania => 'OSEANIA';

  @override
  String get tourZoneIntercontinental => 'MAANOSIEN VÄLINEN';

  @override
  String tourZoneLeague(String league) {
    return 'DIV. $league';
  }

  @override
  String tourHostedBy(String hosts) {
    return 'ISÄNNÄT  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Parhaat $count etenevät $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return '$name jättää joukkueen';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return '$name lopetti maajoukkueuransa $age-vuotiaana $caps maaottelun jälkeen. Hän pyysi kuulla, missä asemassa on, mutta ei kuullut, eikä hän aio odottaa enää.';
  }

  @override
  String get pressHeadlineWent1 => 'Valmentaja piti tilaisuuden käsissään';

  @override
  String get pressHeadlineWent2 => 'He tulivat riitaan ja saivat johtajan';

  @override
  String get pressHeadlineWent3 => 'Suoria vastauksia, ja ne osuivat';

  @override
  String get pressHeadlineMixed1 => 'Paljon puhetta, vähän ratkaistua';

  @override
  String get pressHeadlineMixed2 => 'Jotain kaikille, eikä mitään kenellekään';

  @override
  String get pressHeadlineMixed3 => 'Tilaisuus, joka jätti kysymykset auki';

  @override
  String get pressHeadlineBadly1 => 'Kolhiva iltapäivä kameroiden edessä';

  @override
  String get pressHeadlineBadly2 => 'Sali kääntyi, ja se näkyi';

  @override
  String get pressHeadlineBadly3 =>
      'Vastaukset, jotka kuulostavat huonommilta aamulla';

  @override
  String get pressHeadlineFlat1 => 'Ei sanottu mitään, ei saatu mitään';

  @override
  String get pressHeadlineFlat2 => 'Kymmenen minuuttia, ei uutisia';

  @override
  String get pressHeadlineFlat3 => 'Tyhjä paperi urheilusivulle';

  @override
  String get pressConferenceTitle => 'LEHDISTÖTILAISUUS';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Kysymys $index/$total';
  }

  @override
  String get pressTomorrowsHeadline => 'HUOMISEN URHEILUSIVU';

  @override
  String get pressLeaveRoom => 'POISTU SALISTA';

  @override
  String get pressRoomVerdictSquad => 'Pukuhuone';

  @override
  String get pressRoomVerdictBoard => 'Hallitus';

  @override
  String get yReactionElation0 => 'ei huomautettavaa. ei yhtään. täydellistä.';

  @override
  String get yReactionElation1 => 'Voin pahoin (hyvällä tavalla).';

  @override
  String get yReactionElation2 => 'kehystän tämän. takan päälle.';

  @override
  String get yReactionElation3 => 'nyt ollaan taas takaisin';

  @override
  String get yReactionElation4 =>
      'Otan tästä kuvakaappauksen epäilijöille. Kaikille.';

  @override
  String get yReactionElation5 =>
      'Tästä tulee ikuisuuden jatkuva hehkutus, varoitan jo nyt.';

  @override
  String get yReactionElation6 => 'Juuri näin. Siksi tätä katsotaan.';

  @override
  String get yReactionElation7 => 'Tällaiset päivät maksavat ne toiset.';

  @override
  String get yReactionElation8 => 'Jo oli aikakin. Ihan oikeasti.';

  @override
  String get yReactionElation9 =>
      'Hienoa. Tee se uudestaan ensi viikolla, niin uskon.';

  @override
  String get yReactionElation10 =>
      'Nauti tästä illasta, koska tämä porukka keksii keinon pilata sen.';

  @override
  String get yReactionElation11 =>
      'Yksi hyvä ilta ei tee kenestäkään huippujoukkuetta.';

  @override
  String get yReactionRelief0 => 'Ei kaunista, mutta otan tämän aina.';

  @override
  String get yReactionRelief1 => 'Jotenkin. Jotenkin!';

  @override
  String get yReactionRelief2 => 'Rumaa. Kolme pistettä. Eteenpäin.';

  @override
  String get yReactionRelief3 =>
      'Otan rumaa vaikka koko päivän, jos pisteet tulevat mukana.';

  @override
  String get yReactionRelief4 => 'tästä lähti kymmenen vuotta elämää';

  @override
  String get yReactionRelief5 => 'Kukaan ei puhu. Kukaan ei vie onnea.';

  @override
  String get yReactionRelief6 => 'Syke: sietämätön.';

  @override
  String get yReactionRelief7 => 'Selvittiin. Se on se sana. Selvittiin.';

  @override
  String get yReactionRelief8 =>
      'Tällaisista peleistä ei pitäisi tarvita helpotusta.';

  @override
  String get yReactionRelief9 =>
      'Helpottunut, ja vähän noloa olla helpottunut.';

  @override
  String get yReactionRelief10 => 'Jos tuota me hurraamme, meillä on ongelma.';

  @override
  String get yReactionRelief11 =>
      'Hädin tuskin selviäminen on tapa, eikä hyvä sellainen.';

  @override
  String get yReactionFury0 => 'Ei riittävää. Ei lähellekään.';

  @override
  String get yReactionFury1 => 'Selittäkää tuo minulle hitaasti.';

  @override
  String get yReactionFury2 =>
      'Tuota oli vaikea katsoa, ja olen silti kohtelias.';

  @override
  String get yReactionFury3 => 'Pettynyt. Oikeasti pettynyt.';

  @override
  String get yReactionFury4 => 'Aivan järkyttävää menoa.';

  @override
  String get yReactionFury5 => 'Haluan nimiä.';

  @override
  String get yReactionFury6 =>
      'Poistan sovelluksen. Asennan torstaina uudestaan.';

  @override
  String get yReactionFury7 =>
      'Kenelläkään kentällä ei näyttänyt olevan halua.';

  @override
  String get yReactionFury8 =>
      'Joka neljäs vuosi sama juttu. JOKA neljäs vuosi.';

  @override
  String get yReactionFury9 => 'Tuo ei ole suoritus, se on loukkaus.';

  @override
  String get yReactionFury10 =>
      'Ihmiset uhraavat viikonloppuja ja rahaa tuollaiseen. Miettikää sitä.';

  @override
  String get yReactionFury11 =>
      'Olen puolustanut tätä joukkuetta vuosia. En tänään. En tuon jälkeen.';

  @override
  String get yReactionDespair0 => 'no niin.';

  @override
  String get yReactionDespair1 => 'Ei vitsejä tänään. Ei mitään.';

  @override
  String get yReactionDespair2 => 'Lähden kävelylle. Pitkälle.';

  @override
  String get yReactionDespair3 => 'Mulla loppuivat sanat tähän.';

  @override
  String get yReactionDespair4 => 'Herättäkää neljän vuoden päästä.';

  @override
  String get yReactionDespair5 => 'tämä on se synkin aikajana';

  @override
  String get yReactionDespair6 =>
      'En ole edes vihainen enää. Se on huolestuttavinta.';

  @override
  String get yReactionDespair7 => 'Tämä kirvelee vielä pitkään.';

  @override
  String get yReactionDespair8 =>
      'En tiedä enää, mitä tämä on, mutta ei se jalkapallojoukkue ole.';

  @override
  String get yReactionDespair9 =>
      'Ollaan kauempana kuin ennen, eikä kukaan sano sitä ääneen.';

  @override
  String get yReactionDespair10 =>
      'Kokonainen sukupolvi hukattu, ja samat ihmiset päättävät jatkosta.';

  @override
  String get yReactionDespair11 =>
      'Lopettakaa jankkaus prosessista. Se ei johda mihinkään.';

  @override
  String get yReactionSmugness0 => 'Hiljaa vaan, mutta: sanoin.';

  @override
  String get yReactionSmugness1 => 'tallenna tämä kirjanmerkkeihin';

  @override
  String get yReactionSmugness2 => 'Epäilijät ovat käyneet hyvin hiljaisiksi.';

  @override
  String get yReactionSmugness3 =>
      'Ei sillä, että kukaan laskisi. Minä lasken.';

  @override
  String get yReactionSmugness4 =>
      'Sanoin tämän tammikuussa. Tarkista aikajana.';

  @override
  String get yReactionSmugness5 =>
      'Jotkut teistä ovat velkaa meille anteeksipyynnön.';

  @override
  String get yReactionSmugness6 =>
      'Laitan tämän kansioon: asiat, jotka mainitsin ensin.';

  @override
  String get yReactionSmugness7 => 'Ei kehumista. Vähän kehumista.';

  @override
  String get yReactionSmugness8 =>
      'Missä kaikki asiantuntijat nyt ovat? Vilpitön kysymys.';

  @override
  String get yReactionSmugness9 =>
      'Haluan, että jokainen teistä sanoo sen takaisin minulle.';

  @override
  String get yReactionSmugness10 =>
      'Kuvakaappaus, tulostettu, kehystetty, lähetetty niille, jotka nauroivat.';

  @override
  String get yReactionSmugness11 =>
      'Muistutan tästä loppuelämäni, ja olette ansainneet sen.';

  @override
  String get yReactionShrug0 => 'tapahtui. seuraava.';

  @override
  String get yReactionShrug1 => 'Okei. Sama se. Eteenpäin.';

  @override
  String get yReactionShrug2 => 'Laitan tämän kategoriaan \'jalkapallo\'.';

  @override
  String get yReactionShrug3 => 'Ei oikeasti lisättävää.';

  @override
  String get yReactionShrug4 => 'ei ajatuksia, pää tyhjä';

  @override
  String get yReactionShrug5 => 'Herätä kun on seuraava.';

  @override
  String get yReactionShrug6 =>
      'Yhdeksänkymmentä minuuttia, joita en saa takaisin.';

  @override
  String get yReactionShrug7 => 'Ei tässä sinänsä mitään suuntaan tai toiseen.';

  @override
  String get yReactionShrug8 => 'En osaa kertoa yhtäkään asiaa, joka tapahtui.';

  @override
  String get yReactionShrug9 => 'Taas yksi tällainen. Näitä on paljon.';

  @override
  String get yReactionShrug10 => 'Katsoin koko pelin enkä tuntenut mitään.';

  @override
  String get yReactionShrug11 =>
      'Jos kukaan ei mainitse tätä enää, sopii minulle.';

  @override
  String get tourThirdsUneven =>
      'Lohkot ovat eri kokoisia, joten tulokset jokaisen suuren lohkon viimeistä joukkuetta vastaan jätetään pois ja kaikkia joukkueita arvioidaan samojen otteluiden perusteella.';

  @override
  String get careerExportSave => 'Varmuuskopioi tämä tallennus';

  @override
  String get careerBackupAll => 'VARMUUSKOPIOI KAIKKI';

  @override
  String get careerBackupAllFailed =>
      'Varmuuskopion kirjoittaminen epäonnistui.';

  @override
  String get backupTitle => 'VARMUUSKOPIOT';

  @override
  String get backupBlurb =>
      'Kaikki tallennukset ovat yhdessä tiedostossa tässä puhelimessa, eikä mikään varmuuskopioi niitä itsestään, ellet laita automaattista varmuuskopiota päälle alta. Pidä kopio pilvessä, jottei kadonnut puhelin tai poistettu sovellus maksa sinulle uraa.';

  @override
  String get backupBlurbNoAuto =>
      'Kaikki tallennukset ovat yhdessä tiedostossa tässä puhelimessa, eikä mikään varmuuskopioi niitä itsestään. Pidä kopio pilvessä, jottei kadonnut puhelin tai poistettu sovellus maksa sinulle uraa.';

  @override
  String get backupExport => 'VARMUUSKOPIOI PILVEEN';

  @override
  String get backupExportSubject => 'FNM-tallennukset';

  @override
  String get backupRestore => 'PALAUTA TIEDOSTOSTA';

  @override
  String get backupRestoreWarnTitle => 'Korvataanko kaikki tallennukset?';

  @override
  String get backupRestoreWarnBody =>
      'Palautus korvaa kaikki tämän puhelimen tallennukset tiedoston tallennuksilla. Sovellus käynnistyy uudelleen.';

  @override
  String get backupRestoreConfirm => 'KORVAA';

  @override
  String get backupCancel => 'PERUUTA';

  @override
  String get backupExported =>
      'Varmuuskopio on valmis. Valitse, minne se tallennetaan.';

  @override
  String get backupFailed => 'Varmuuskopion kirjoittaminen epäonnistui.';

  @override
  String get backupRejectedUnreadable => 'Tiedostoa ei voitu avata.';

  @override
  String get backupRejectedNotFnm => 'Tämä ei ole FNM-tallennus.';

  @override
  String get backupRejectedNewer =>
      'Tallennus on tehty sovelluksen uudemmalla versiolla. Päivitä ensin.';

  @override
  String get backupRejectedTooOld =>
      'Tallennus on liian vanha tämän version palautettavaksi.';

  @override
  String get careerShare => 'Jaa tämä ura';

  @override
  String get careerImport => 'TUO URA';

  @override
  String get careerShareSubject => 'FNM-ura';

  @override
  String get careerImported => 'Ura tuotu.';

  @override
  String get careerImportFailedUnreadable => 'Tämä tiedosto ei ole FNM-ura.';

  @override
  String get careerImportFailedNewer =>
      'Ura on viety sovelluksen uudemmalla versiolla. Päivitä ensin.';

  @override
  String get careerImportFailedSlotsFull =>
      'Kaikki tallennuspaikkasi ovat käytössä. Poista tallennus tehdäksesi tilaa tai avaa rajattomat tallennukset.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Tämä ura on ilmaisen ensimmäisen kauden jälkeinen. Avaa koko peli tuodaksesi sen.';

  @override
  String get careerImportFailedCampaignRun =>
      'Tässä kampanjassa on jo käynnissä oleva ura. Jatka tai hylkää se ensin.';

  @override
  String get careerShareFailed => 'Uran vieminen epäonnistui.';

  @override
  String get managerRename => 'Vaihda nimi';

  @override
  String get managerRenameSave => 'Tallenna';

  @override
  String get managerTitle => 'VALMENTAJA';

  @override
  String get managerSkills => 'TAITOSI';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistettä käytettävissä',
      one: '1 piste käytettävissä',
      zero: 'Ei käytettäviä pisteitä',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Kaksi pistettä jokaisesta suoritetusta kaudesta ja yksi jokaisesta voitetusta pokaalista.';

  @override
  String get managerSkillsScale =>
      'Jokainen taito alkaa arvosta 5 ja päättyy arvoon 20. Käytetty piste on pysyvä.';

  @override
  String get managerSkillManManagement => 'Pelaajajohtaminen';

  @override
  String get managerSkillManManagementBlurb =>
      'Jokainen piste tekee sanomisistasi medialle ja pelaajillesi 3 % tehokkaampia pukuhuoneessa.';

  @override
  String get managerSkillTactical => 'Taktiikka';

  @override
  String get managerSkillTacticalBlurb =>
      'Jokainen piste sisäistää uuden pelijärjestelmän 3 % nopeammin, joten pelijärjestelmän vaihtaminen maksaa vähemmän otteluita.';

  @override
  String get managerSkillYouth => 'Nuorten kehitys';

  @override
  String get managerSkillYouthBlurb =>
      'Jokainen piste lisää akatemiastasi nousevaa lahjakkuutta 1 %, rahoituksen lisäksi.';

  @override
  String get managerSkillNegotiation => 'Neuvottelu';

  @override
  String get managerSkillNegotiationBlurb =>
      'Jokainen piste tuo liitolta 2 % enemmän rahaa joka kausi.';

  @override
  String get managerStaff => 'HENKILÖSTÖSI';

  @override
  String managerStaffWages(String amount) {
    return 'Palkat: $amount / kausi';
  }

  @override
  String get managerRoleAssistant => 'Apuvalmentaja';

  @override
  String get managerRoleAssistantBlurb =>
      'Vastaa harjoittelusta: vähemmän loukkaantumisia ja parempia nuoria.';

  @override
  String get managerRoleScout => 'Pääscout';

  @override
  String get managerRoleScoutBlurb =>
      'Lukee lupauksesi ja seuraavan vastustajasi: tarkemmat tähtiarvosanat ja etu ottelupäivänä.';

  @override
  String get managerRoleFitness => 'Kuntovalmentaja';

  @override
  String get managerRoleFitnessBlurb => 'Pitää heidät kentällä.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent % vähemmän loukkaantumisia';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Nuoret +$points tasoa';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Palkkaaminen: $min–$max % vähemmän loukkaantumisia';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'ja nuoret +$minPoints–+$maxPoints tasoa';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Lukee $percent % lupauksista täsmälleen';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Potentiaali selviää $caps maaottelun jälkeen',
      one: 'Potentiaali selviää 1 maaottelun jälkeen',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points arvosanaa vastustajaselvityksistä';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Palkkaaminen: $min–$max % arvioista täsmällisiä';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'ja potentiaali selviää $minCaps–$maxCaps maaottelua aiemmin';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'ja +$minPoints–+$maxPoints arvosanaa joka ottelussa';
  }

  @override
  String get staffEffectNone => 'Ei vielä vaikutusta joukkueeseesi';

  @override
  String get staffVacant => 'Tehtävässä ei ketään';

  @override
  String get staffLeaveVacant => 'Jätä tehtävä tyhjäksi';

  @override
  String get managerTierNone => 'Ei ketään';

  @override
  String get managerTierBasic => 'Perus';

  @override
  String get managerTierGood => 'Hyvä';

  @override
  String get managerTierElite => 'Huippu';

  @override
  String get managerFree => 'ilmainen';

  @override
  String get managerTraining => 'TAUKOJEN HARJOITTELU';

  @override
  String get managerTrainingBlurb =>
      'Mitä joukkue harjoittelee, kun ottelua ei ole.';

  @override
  String get managerFocusBalanced => 'Tasapainoinen';

  @override
  String get managerFocusBalancedBlurb => 'Vähän kaikkea.';

  @override
  String get managerFocusFitness => 'Kunto';

  @override
  String get managerFocusFitnessBlurb => 'Vähemmän kolhuja.';

  @override
  String get managerFocusCohesion => 'Yhtenäisyys';

  @override
  String get managerFocusCohesionBlurb => 'Pelijärjestelmä asettuu nopeammin.';

  @override
  String get managerFocusYouth => 'Nuoret';

  @override
  String get managerFocusYouthBlurb => 'Tunteja nuorimpien kanssa.';

  @override
  String get tourOfferTitle => 'Ensimmäistä kertaa täällä?';

  @override
  String get tourOfferBody =>
      'Tämä on iso peli. Haluatko nopean kierroksen tärkeimmillä näytöillä? Se vie minuutin, ja voit aloittaa sen uudelleen milloin tahansa Asetuksista.';

  @override
  String get tourOfferYes => 'Näytä minulle';

  @override
  String get tourOfferNo => 'Ei kiitos';

  @override
  String get tourBack => 'Takaisin';

  @override
  String get tourNext => 'Seuraava';

  @override
  String get tourDone => 'Valmis';

  @override
  String get tourSkip => 'Ohita';

  @override
  String get tourHubTitle => 'Tässä on koko peli';

  @override
  String get tourHubBody =>
      'Yksi painike, joka muuttuu kauden edetessä: katsottava arvonta, nimettävä kokoonpano, pelattava ottelu. Sen yläpuolella näkyvät hallituksen luottamus sinuun ja heidän asettamansa tavoitteet.';

  @override
  String get tourBudgetTitle => 'Liiton rahat';

  @override
  String get tourBudgetBody =>
      'Kerran jokaisella nelivuotiskaudella jaat kassan osastojen kesken. Henkilöstösi palkat maksetaan siitä ensin, joten huippuscoutin palkkaaminen on päätös akatemiaa vastaan, ei sen rinnalla.';

  @override
  String get tourTacticsTitle => 'Miten joukkue pelaa';

  @override
  String get tourTacticsBody =>
      'Pelijärjestelmä, pelitapa, kapteeni ja vakiotilanteiden ottajat. Jätä kaksi viimeistä asettamatta, niin peli varoittaa sinua ennen aloitusta sen sijaan, että valitsisi hiljaa puolestasi.';

  @override
  String get tourSquadTitle => 'Kaikki, jotka voit valita';

  @override
  String get tourSquadBody =>
      'Koko joukko, ei vain kokoonpano: kuka on vireessä, kuka kantaa kolhua, kuka on pelikiellossa ja kuka on juuri noussut akatemiasta.';

  @override
  String get tourCallUpsTitle => 'Kokoonpanon nimeäminen';

  @override
  String get tourCallUpsBody =>
      'Nimeät yhden kokoonpanon jokaiselle maaottelutauolle, ja se pelaa kaikki tauon ottelut, aivan kuten oikea valmentaja. Tauon aikainen loukkaantuminen tuo tilalle korvaajan puolestasi.';

  @override
  String get tourRecordsTitle => 'Urasi';

  @override
  String get tourRecordsBody =>
      'Kaikki, mitä olet tehnyt: ottelut, joukkueen ennätykset, pokaalit ja jokainen maa, jota olet valmentanut.';

  @override
  String get tourCupsTitle => 'Muu maailma';

  @override
  String get tourCupsBody =>
      'Kaikki juuri nyt käynnissä olevat kilpailut: lohkot, sarjataulukot ja pudotuspelit, myös ne, joissa et ole mukana. Maailma pelaa eteenpäin, selvisitpä sinä mukaan tai et.';

  @override
  String get settingsTourTitle => 'Katso opastus uudelleen';

  @override
  String get settingsTourBlurb =>
      'Käy tärkeimmät näytöt läpi uudelleen alusta.';

  @override
  String get tourBoardTitle => 'Kenelle vastaat';

  @override
  String get tourBoardBody =>
      'Hallituksen luottamus sinuun ja heidän tälle kaudelle asettamansa tavoitteet. Jos tavoite jää saavuttamatta, näet sen täältä jo etukäteen.';

  @override
  String get tourStaffTitle => 'Ihmiset ympärilläsi';

  @override
  String get tourStaffBody =>
      'Apuvalmentaja, scout ja kuntovalmentaja, palkattuina nimeltä. Heidän palkkansa lähtevät tästä budjetista ennen osastoja, joten loistava scout on päätös akatemiaa vastaan.';

  @override
  String get tourPlaystyleTitle => 'Sinun pelitapasi';

  @override
  String get tourPlaystyleBody =>
      'Pelijärjestelmä on vain puolet taktiikasta. Tämä on toinen puoli: kuinka korkealla prässäät, kuinka suoraviivaisesti pelaat, kuinka paljon riskeeraat.';

  @override
  String get settingsTourNoSave =>
      'Aloita ensin ura. Opastus käy läpi omat näytöt.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Väärällä paikalla · Ikä $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Seuraavan kauden budjetti päätetään sen alussa, kerralla. Siihen asti tämä näyttää, mitä rahasi tekevät.';

  @override
  String get federationBudgetAlreadySet => 'Jo asetettu tälle kaudelle';

  @override
  String yFinalLooms0(String opponent) {
    return 'Vastaan tulee $opponent, ja kyseessä on se iso. Koko viikon kaikki puhuvat vain tästä.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Vahvistettu: edessämme on $opponent. Neljä vuotta tätä varten.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'No niin. $opponent. Kukaan ei nuku ennen kuin tämä on ohi.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return 'Seuraavaksi $opponent, ja kaikki muu voi odottaa. Mikä viikko olla elossa.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Jätä ottajat valmentajalle';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Merkitty alla: joukkueet, jotka pelaavat kuten $rivals, eli lohkosi vastustajat tällä kaudella.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Siirtoikkuna · $year';
  }

  @override
  String careerLastAgo(String when) {
    return 'Viimeksi $when sitten';
  }

  @override
  String get settingsFreeScopeTitle => 'Yksi ilmainen nelivuotiskausi';

  @override
  String get settingsFreeScopeBlurb =>
      'Yksi täysi kausi (karsinnat, mannermestaruuskilpailusi ja MM-kisat) kahdella tallennuksella, kaikki maailman maat, mitään pimittämättä. Loputtomat kaudet ja rajattomat tallennukset ovat kertamaksu, ja se kattaa kaikki tulevat päivitykset.';

  @override
  String get settingsUnlockedTitle => 'Avattu';

  @override
  String get settingsUnlockedBlurb =>
      'Loputtomat kaudet, rajattomat tallennukset ja kaikki tulevat päivitykset. Kiitos.';

  @override
  String get settingsFromDeveloperTitle => 'Kehittäjältä';

  @override
  String get settingsFromDeveloperBlurb =>
      'Football Nations Manager on yhden ihmisen tekemä, ja sitä tuetaan pitkäjänteisesti. Mainoksia tai mikromaksuja ei tule koskaan. Jos pidät pelistä, harkitse täyden version ostamista. Se pitää päivitykset tulossa.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Football Nations Manager on yhden ihmisen tekemä, ja sitä tuetaan pitkäjänteisesti. Mainoksia tai mikromaksuja ei tule koskaan. Kiitos täyden version ostamisesta. Se pitää päivitykset tulossa.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Merkitty alla: joukkueet, jotka pelaavat kuten $rivals, joita vastaan sinulla on vielä ottelut.';
  }

  @override
  String get friendliesCloseToYou =>
      'Merkitty alla: maailmanrankingissa lähimpänä sinua olevat joukkueet. Kun arvonta on tehty, merkinnät seuraavat lohkoasi.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count siirtoa',
      one: '1 siirto',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Uudemmat';

  @override
  String get transfersOlder => 'Lisää';

  @override
  String get transfersPagePrevious => 'Edellinen';

  @override
  String get transfersPageNext => 'Seuraava';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Sivu $page/$pages';
  }

  @override
  String get transfersMovedTo => 'Siirtyi seuraan';

  @override
  String get transfersUnknownClub => 'Tuntematon seura';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return 'Nyt on $count kertaa vastassa $opponent. Joku pitää pisteitä, ja se ovat he.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return 'Taas $opponent. $count kohtaamista, emmekä ole vieläkään keksineet heitä.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Kerta numero $count vastassa $opponent. Tämä ei ole enää sattumaa.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return 'Olemme pelanneet $opponent vastaan $count kertaa emmekä oppineet yhdestäkään mitään.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count kertaa. He tietävät tasan, mitä aiomme tehdä.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Mitä tahansa $opponent meistä tietääkin, $count kohtaamisen jälkeen heillä se yhä on.';
  }

  @override
  String ySameOldStory0(String count) {
    return 'Tämä on tapahtunut $count kertaa viime aikoina. Missä vaiheessa tämä on vain se, mitä me olemme?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count tällaista iltapäivää jo. Tämä on kaava, ei tuuria.';
  }

  @override
  String ySameOldStory2(String count) {
    return 'Olemme nähneet täsmälleen tämän pelin $count kertaa viime aikoina. Sama käsikirjoitus, sama loppu.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count versiota samasta yhdeksästäkymmenestä minuutista. Kukaan ei korjaa tätä.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count kertaa. Jos et näe kaavaa nyt, et katso.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Sama tarina, $count kertaa. Tekosyyt loppuivat ennen tuloksia.';
  }

  @override
  String get yToldYouSo0 =>
      'Sanoin, että tämä on tulossa, kun kaikki juhlivat.';

  @override
  String get yToldYouSo1 =>
      'Kaksi hyvää viikkoa ja olimme taas kultainen sukupolvi. Ja tässä ollaan.';

  @override
  String get yToldYouSo2 =>
      'Ne, jotka käskivät nauttimaan viime kuussa, ovat hiljenneet.';

  @override
  String get yToldYouSo3 =>
      'En saa tästä mitään iloa. Hyvin vähän iloa. Vähän.';

  @override
  String get yToldYouSo4 =>
      'Ei se koskaan ollut niin hyvä kuin sinulle väitettiin, ja tämä on todiste.';

  @override
  String get yToldYouSo5 =>
      'Joka kerta. Meille sanotaan, että nyt on toisin, eikä joka kerta ole.';

  @override
  String get tacticsSubOffAlready => 'Jo vaihdettu pois';

  @override
  String get tacticsSubInjured => 'Loukkaantunut';

  @override
  String get tacticsSubSentOffMark => 'Ulosajettu';

  @override
  String get tacticsSubNoneLeft => 'Ei vaihtoja jäljellä';

  @override
  String get tacticsUndoLastChange => 'Peru viimeisin muutos';

  @override
  String get matchStrengthTitle => 'MIKÄ LIIKUTTAA JOUKKUETTA';

  @override
  String get strengthFactorFamiliarity => 'Harjoiteltu muoto';

  @override
  String get strengthFactorFatigue => 'Väsyneet jalat';

  @override
  String get strengthFactorClubForm => 'Seurojen vire';

  @override
  String get strengthFactorMorale => 'Pukuhuone';

  @override
  String get strengthFactorCaptain => 'Kapteeni';

  @override
  String get strengthFactorStaff => 'Henkilöstö';

  @override
  String get strengthFactorDossier => 'Scoutin selvitys';

  @override
  String yDebut0(String name) {
    return '$name saa ensimmäisen maaottelunsa. Muista nimi.';
  }

  @override
  String yDebut1(String name) {
    return 'Debyytti: $name. Sen näkee hänestä, eikö niin?';
  }

  @override
  String yDebut2(String name) {
    return '$name, ensimmäinen maaottelu. Katsotaan, mitä hän siitä tekee.';
  }

  @override
  String yDebut3(String name) {
    return 'Debyytti: $name. Joukkue tarvitsi tuoreita jalkoja jostain.';
  }

  @override
  String yDebut4(String name) {
    return '$name sai maajoukkuepaidan. Näitä on jaettu paljon viime aikoina.';
  }

  @override
  String yDebut5(String name) {
    return 'Debyytti: $name. Taas yksi, jonka olemme unohtaneet keväällä.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$name on pelannut $count ottelua ilman maalia ja tekee kaiken muun kentällä.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count peliä ilman maalia: $name. Ne tulevat kolmen putkissa, aina on tullut.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count peliä, ei maaleja.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count ottelua ilman maalia: $name. Kannattaa pitää silmällä.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count peliä. Ei maaleja. $name ei osuisi ladon seinään.';
  }

  @override
  String yDrought5(String name, String count) {
    return '$name ei ole tehnyt maalia $count ottelussa. Pelauttakaa vaikka kuka tahansa muu.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return 'Seuraavaksi $opponent. $count kohtaamista ja silti tämä merkitsee kaikkea.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count kertaa vastassa $opponent. Antaa tulla.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return 'Seuraavaksi $opponent. Pelattu $count.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Kohtaaminen numero $count: $opponent tällä viikolla.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return 'Taas $opponent. $count tällaista, emmekä ole oppineet mitään.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count peliä vastaan $opponent, ja yhä he voittavat meidät. Upeaa.';
  }

  @override
  String get positionGoalkeeper => 'Maalivahti';

  @override
  String get positionLeftBack => 'Vasen laitapuolustaja';

  @override
  String get positionCentreBack => 'Keskuspuolustaja';

  @override
  String get positionRightBack => 'Oikea laitapuolustaja';

  @override
  String get positionDefensiveMid => 'Puolustava keskikenttä';

  @override
  String get positionCentralMid => 'Keskikenttä';

  @override
  String get positionAttackingMid => 'Hyökkäävä keskikenttä';

  @override
  String get positionLeftMid => 'Vasen laitakeskikenttä';

  @override
  String get positionRightMid => 'Oikea laitakeskikenttä';

  @override
  String get positionLeftWing => 'Vasen laitahyökkääjä';

  @override
  String get positionRightWing => 'Oikea laitahyökkääjä';

  @override
  String get positionStriker => 'Hyökkääjä';

  @override
  String get roleNone => 'Ei roolia';

  @override
  String get roleTargetMan => 'Kärkimies';

  @override
  String get rolePoacher => 'Maalinuuskija';

  @override
  String get rolePlaymaker => 'Pelintekijä';

  @override
  String get roleBallWinner => 'Pallonvoittaja';

  @override
  String get roleInvertedWinger => 'Sisäänleikkaava laita';

  @override
  String get roleBallPlayingDefender => 'Pelaava puolustaja';

  @override
  String get roleNoneBlurb => 'Pelaa luontaista peliään.';

  @override
  String get roleTargetManBlurb =>
      'Voittaa ilmataistelut ja pudottaa pallon. Syöttöjä ja vakiotilanteita.';

  @override
  String get rolePoacherBlurb =>
      'Vaanii rangaistusalueella. Paljon enemmän maaleja.';

  @override
  String get rolePlaymakerBlurb => 'Luo tilanteita. Paljon enemmän syöttöjä.';

  @override
  String get roleBallWinnerBlurb =>
      'Katkoo peliä sen sijaan, että viimeistelisi.';

  @override
  String get roleInvertedWingerBlurb =>
      'Leikkaa sisään laukomaan. Enemmän maaleja.';

  @override
  String get roleBallPlayingDefenderBlurb => 'Aloittaa hyökkäykset takaa.';

  @override
  String get federationDeptYouth => 'Nuorisoakatemia';

  @override
  String get federationDeptCommercial => 'Kaupallinen / PR';

  @override
  String get federationDeptMedical => 'Lääkintä ja urheilutiede';

  @override
  String get federationDeptNaturalisation => 'Kansalaistamistoimisto';

  @override
  String get federationDeptBoardRelations => 'Hallitussuhteet';

  @override
  String get federationDeptYouthBlurb =>
      'Paremmat akatemian lupaukset debytoivat maajoukkueessasi ensi kaudella.';

  @override
  String get federationDeptCommercialBlurb =>
      'Sponsorointi tuo lisätuloja kauden lopussa.';

  @override
  String get federationDeptMedicalBlurb =>
      'Vähemmän loukkaantumisia. Joukkueesi pysyy valittavissa koko kauden.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Useammat ulkomaiset pelaajat tarjoutuvat vaihtamaan maatasi edustamaan.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Hallitus arvioi tuloksiasi kärsivällisemmin.';

  @override
  String get federationBuildingAcademy => 'Akatemia';

  @override
  String get federationBuildingCommercial => 'Kaupallinen päämaja';

  @override
  String get federationBuildingMedical => 'Lääkintäkeskus';

  @override
  String get federationBuildingScouting => 'Scouttitoimisto';

  @override
  String get federationBuildingBoardroom => 'Hallitushuone';

  @override
  String get moraleBuoyant => 'Innostunut';

  @override
  String get moralePositive => 'Myönteinen';

  @override
  String get moraleSettled => 'Vakaa';

  @override
  String get moraleUneasy => 'Levoton';

  @override
  String get moraleRockBottom => 'Pohjalla';

  @override
  String get matchTabTimeline => 'TAPAHTUMAT';

  @override
  String get matchTabStats => 'TILASTOT';

  @override
  String get matchTabLineups => 'KOKOONPANOT';

  @override
  String get matchPenalty => 'RANGAISTUSPOTKU';

  @override
  String get matchStateLevel => 'Tilanne on tasan';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Johdat $count maalilla',
      one: 'Johdat yhdellä maalilla',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Olet $count maalin tappiolla',
      one: 'Olet yhden maalin tappiolla',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return 'Pallonhallinta $possession %';
  }

  @override
  String get boardVerdictSackedTitle => 'Hallitus erotti sinut';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Surkea kausi (arvosana $rating %). Valmennusurasi päättyy tähän. Vain heikommat maat uskaltavat nyt tarttua sinuun.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Hallitus on ilahtunut';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Erinomainen kausi (arvosana $rating %). Paras saavutus: $best. Isommat maat ovat kiinnostuneita, tai voit jäädä rakentamaan.';
  }

  @override
  String get boardVerdictSolidTitle => 'Vankka kausi';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Hallitus on tyytyväinen (arvosana $rating %). Muutama samantasoinen maa ottaisi sinut, mutta painetta vaihtaa ei ole.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Hallitus odotti enemmän';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Pettymyskausi (arvosana $rating %). Pidät työsi, mutta kaikki tarjoukset ovat askel alaspäin.';
  }

  @override
  String get boardVerdictPressureTitle => 'Olet todellisessa paineessa';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Heikko kausi (arvosana $rating %). Pysyt virassasi, mutta uutta alkua haaveillessasi kiinnostuneita ovat vain heikommat maat.';
  }

  @override
  String get boardVerdictHeroTitle => 'Maa seisoo rinnallasi';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles kauden',
      one: '1 kauden',
    );
    return ' $nation jumaloi sinua: olet kansallissankari $_temp0 jälkeen, ja työsi on turvassa niin pitkään kuin haluat.';
  }

  @override
  String get boardVerdictTheNation => 'Maa';

  @override
  String get boardVerdictBestQuiet => 'hiljainen kausi';

  @override
  String get boardVerdictBestCycle => 'kausi';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'MM-kisat: $placement';
  }

  @override
  String get finishThirdPlace => 'Kolmas sija';

  @override
  String get finishFourthPlace => 'Neljäs sija';

  @override
  String get finishDidNotQualify => 'Ei selvinnyt lopputurnaukseen';

  @override
  String get careerRepIconic => 'Ikoninen';

  @override
  String get careerRepRenowned => 'Arvostettu';

  @override
  String get careerRepEstablished => 'Vakiintunut';

  @override
  String get careerRepRising => 'Nouseva tähti';

  @override
  String get careerRepUnproven => 'Todistamaton';

  @override
  String get hubOfferStepUp => 'Askel ylöspäin';

  @override
  String get hubOfferLateral => 'Sivuaskel';

  @override
  String get hubOfferRebuild => 'Uudelleenrakennus';

  @override
  String careerNationsCupWon(String league) {
    return 'Divisioona $league · Mestarit';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Divisioona $league · Hopealle jääneet';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Divisioona $league · Välierissä';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Divisioona $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Seuraavana: $round';
  }

  @override
  String get tourRunIntoThirdPlace => 'Seuraavana: pronssiottelu';

  @override
  String tourRunThrough(String round) {
    return 'Jatkoon: $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Putosi: $round';
  }

  @override
  String get tourRunInGroup => 'Lohkovaihe käynnissä';

  @override
  String get tourRunGroupOut => 'Putosi lohkovaiheessa';

  @override
  String resultsCycleTitle(int year, String nation) {
    return '$year kausi · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played pelattu  ·  ${won}V ${drawn}T ${lost}H';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'MM-kisat: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Vielä käynnissä';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Kaksi maalia takaa tauolla vastustajaa $opponent vastaan, ja kaikki tuli takaisin. Tuo on joukkue.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Kaksi maalia alla vastustajaa $opponent vastaan, eikä lopussa sillä ollut mitään väliä. Harva joukkue tekee noin.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Puoliaika: kaksi maalia alla, vastustaja $opponent. Lopputulos: ei enää. Toinen jakso oli aivan eri peli.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Käänsimme kahden maalin takaa-ajon vastustajaa $opponent vastaan. Mitä tauolla sanottiinkaan, sanokaa se joka viikko.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'No, saimme sen takaisin vastustajaa $opponent vastaan. Nyt joku selittäköön ne ensimmäiset neljäkymmentäviisi minuuttia.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Kaksi maalia alla vastustajaa $opponent vastaan, ja meidän pitäisi riemuita. Korjatkaa se ensimmäinen jakso.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Kaksi maalia edellä vastustajaa $opponent vastaan tauolla, ja se valui hukkaan. Parhaillekin joukkueille käy niin.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Kaksi maalia edellä vastustajaa $opponent vastaan, ja ne menivät. Edessä on pitkä kausi, aikaa riittää.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Puoliaika: kaksi maalia edellä, vastustaja $opponent. Lopputulos: ei lähelläkään.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Kahden maalin johto vastustajaa $opponent vastaan hävisi neljässäkymmenessäviidessä minuutissa.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Kaksi maalia edellä ja silti hävisimme. Vastustajalle $opponent. Joku vastaa tästä.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Kaksi maalia edellä vastustajaa $opponent vastaan, ja onnistuimme tässäkin. Joka ikinen kerta.';
  }

  @override
  String get cycleBackupDone =>
      'Ura varmuuskopioitu tämän puhelimen FNM-kansioon. Sovelluksen poistaminen poistaa myös sen: jos haluat kopion muualle, käytä tallennusnäytön kohtaa Varmuuskopioi tämä tallennus.';

  @override
  String get cycleBackupFailed =>
      'Uran varmuuskopiointi ei tällä kertaa onnistunut.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Ikimuistoinen ilta vastustajaa $opponent vastaan. Kuinka ylpeä olette tästä porukasta?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return '$opponent ei pysynyt perässä. Onko tämä se joukkue, johon aina uskoitte?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Iso voitto vastustajasta $opponent. Mikä ratkaisi tänä iltana?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return '$opponent kaatui, ja selvästi. Mistä voitto syntyi?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Hieno voitto vastustajasta $opponent. Yksi hyvä ilta: miksi kenenkään pitäisi uskoa sen jatkuvan?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Hieno tulos vastustajaa $opponent vastaan. Oliko tuo teidän suunnitelmanne, vai keksivätkö pelaajat sen itse?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Rankka ilta vastustajaa $opponent vastaan. Mitä sanotte pelaajille tällaisen illan jälkeen?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Kukaan ei osannut odottaa tuota vastustajaa $opponent vastaan. Oliko se vain yksi niistä illoista?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Nöyryyttävä ilta vastustajaa $opponent vastaan. Mikä meni pieleen?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return '$opponent repi teidät palasiksi. Riittääkö tämä joukkue?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Olitte myöhässä joka paikassa vastustajaa $opponent vastaan. Miten annoitte sen mennä näin pahaksi?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return '$opponent maalasi mielin määrin. Missä oli suunnitelma tänä iltana?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Taas yksi karkasi, nyt vastustajaa $opponent vastaan. Miten käännätte tämän putken?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Tulokset ovat kuivuneet, ja $opponent pahensi tilannetta. Uskotteko vielä tähän porukkaan?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Taas ei voittoa, nyt vastustajaa $opponent vastaan, ja hallitus seuraa. Onko työnne turvassa?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Vastustajaa $opponent vastaan pelatun ottelun jälkeen putki alkaa olla pitkä. Huolestuttaako tulevaisuutenne?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Nyt myös $opponent. Edeltäjänne erotettiin tällaisen putken takia. Miksi te selviäisitte?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Taas yksi tällainen ilta vastustajaa $opponent vastaan, ja jokainen puhelinohjelma haluaa teidät pois. Eroaisitteko, jos hallitus pyytäisi?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Pistitte työnne peliin, eikä vastustajaa $opponent vastaan käynyt teidän tahtonne mukaan. Miten jaksatte?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Kolme ottelua on pelattu, viimeisin vastustajaa $opponent vastaan. Asetitte testin itse. Mitä ajattelette tuomiosta?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Käskitte arvioida teidät kolmen seuraavan perusteella. Vastustajaa $opponent vastaan pelatun ottelun jälkeen olemme arvioineet. Onko työnne vielä teidän?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Kolme ottelua, viimeisin vastustajaa $opponent vastaan, eikä tulos ole se mitä lupasitte. Oletteko puhuneet tulevaisuudestanne hallituksen kanssa?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Asetitte testin itse ja reputitte sen vastustajaa $opponent vastaan. Aiotteko erota?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Teidän sananne, ei meidän: arvioikaa minut kolmen seuraavan perusteella. Miksi istutte vielä siinä vastustajaa $opponent vastaan pelatun ottelun jälkeen?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Haluatte heiltä enemmän. Onko jokin tietty pelaaja mielessänne?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Olette asettaneet rimän korkealle. Kenen pitää astua ensin esiin?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Sanotte, että osan heistä pitää katsoa peiliin. Ketä tarkoitatte?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Ei tarpeeksi hyvää, sanotte. Ketä tarkoitatte?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Pysyttelette epämääräisenä. Nimeättekö nimiä, vai palaako vika teille itsellenne?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Joka viikko vika on jonkun muun. Kenen se on tällä kertaa?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Rohkeita sanoja. Entä jos seuraava ei mene teidän mukaanne?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Koko maa pitää teidät sanoissanne. Entä jos se ei onnistu?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'Entä jos ette voita sitä? Mitä sitten?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Nyt sen sanoitte. Mitä tapahtuu, jos olette väärässä?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Tässä huoneessa on kuultu lupauksia ennenkin. Mitä olette velkaa kannattajille, jos tämäkin pettää?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'Ja kun se ei toteudu, mikä on tekosyy?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Vielä yksi, jos jaksatte. Mitä tämän porukan pitää vielä hioa?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Kun pöly laskeutuu, mitä otatte tästä illasta mukaan seuraavaan otteluun?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Mennään vähän syvemmälle. Mitä pitää parantaa ennen seuraavaa ottelua?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Katsotaan tulostaulun taakse: onko joukkue siellä, missä haluatte sen olevan?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Paljon sanoja, vähän sanottua. Mikä oikeasti muuttuu tästä eteenpäin?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Kannattajat haluavat suoran vastauksen. Onko tämä joukkue tarpeeksi hyvä, kyllä vai ei?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return '$player oli loistava tänä iltana. Kuinka pitkälle hän voi päästä?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return '$player on jokaisessa otsikossa tänä iltana. Näittekö tämän tulevan?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return '$player erottui. Mitä pyysitte häneltä tänä iltana?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Oliko $player ratkaisija tänä iltana?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Ilman pelaajaa $player tarina olisi toinen. Onko tämä joukkue vai yksi pelaaja?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return '$player oli upea. Teidän ansionne, vai hänen?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return 'Kova ilta pelaajalle $player. Onko hänellä vamma?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return 'Ilta ei onnistunut pelaajalta $player. Otatteko hänet siipienne suojaan?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return '$player kamppaili tänä iltana. Säilyttääkö hän paikkansa?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return '$player oli askeleen jäljessä. Mitä mieltä olitte hänen pelistään?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return '$player oli taas matkustaja. Miksi pidätte hänet kokoonpanossa?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Kaikki näkivät, ettei $player ollut kunnossa. Kaikki paitsi vaihtopenkki?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Sanoitte, että voitatte seuraavan, ja voititte. Tuntuuko hyvältä olla oikeassa?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Lupasitte voiton seuraavassa ottelussa ja toimititte sen. Itsevarmuutta vai uhoa?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Sanoitte voittavanne seuraavan, ja voititte. Tuuria, vai pitäisikö meidän alkaa kuunnella?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Kerroitte voittavanne sen. Niin ei käynyt. Mikä meni pieleen?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Sanoitte voittavanne seuraavan. Ette voittaneet. Miksi seuraavaan lupaukseen pitäisi uskoa?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Sanoitte voittavanne seuraavan. Ette voittaneet. Merkitsevätkö sananne vielä mitään tässä huoneessa?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Pyysitte tulla arvioiduksi kolmen ottelun perusteella, ja läpäisitte. Saitteko oikeutuksen?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Arvioikaa minut kolmen seuraavan perusteella, sanoitte. Teimme niin, ja tulokset tulivat. Mitä tämä koe opetti teille?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Annoitte itsellenne kolme ottelua ja selvisitte niistä. Oliko koe koskaan niin vaikea?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Pyysitte tulla arvioiduksi kolmen ottelun perusteella. Ne eivät menneet teidän mukaanne. Mitä opitte?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Sanoitte, että arvioikaa minut kolmen seuraavan perusteella. Kolme on pelattu, ja epäilyksen hyöty on mennyt mukana. Mitä nyt?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Asetitte testin ja reputitte sen. Miksi kenenkään pitäisi enää luottaa sanaanne?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Tuitte pelaajaa $player, kun muut eivät. Hän toimitti. Kuuluuko osa kunniasta teille?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Tuitte pelaajaa $player. Hän toimitti. Uskoa vai tietoa?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Tuitte pelaajaa $player, ja kerrankin se kannatti. Oletteko yhtä varma ensi kerralla?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Seisoitte pelaajan $player takana, eikä se ole onnistunut. Uskotteko häneen vielä?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Tuitte pelaajaa $player. Hän ei ole kiittänyt luottamuksesta. Oliko se virhe?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Arvostelukykynne vai uskollisuutenne: kumpi petti pelaajan $player kanssa?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Olitte ankara pelaajaa $player kohtaan, ja ottelut sen jälkeen ovat todistaneet teidät oikeaksi. Tuntuuko se tyydyttävältä?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Haukuitte pelaajaa $player, eikä hän ole vastannut. Onko hänellä tietä takaisin?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Jätitte pelaajan $player yksin ahdinkoon, eikä hän ole toipunut. Rikoitteko hänet?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Haukuitte pelaajaa $player, ja hän vastasi teille kentällä. Oliko se koko ajan ideanne?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Syytitte pelaajaa $player, ja sen jälkeen hän on ollut yksi parhaistanne. Pitäisikö teidän pyytää anteeksi?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Heititte pelaajan $player bussin alle, ja hän on ollut paras pelaajanne siitä lähtien. Pyydättekö anteeksi?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Nämä pelaajat antoivat minulle kaikkensa. En vaihtaisi yhtäkään heistä.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Kukaan ei tee kovempaa työtä kuin tämä porukka. Puolustan heitä vaikka koko päivän.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Tästä paikalta et kuule sanaakaan pelaajiani vastaan.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Pelaajat ansaitsevat kunnian, en minä. Kirjoittakaa heistä.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Se oli minun syytäni. Valitsin kokoonpanon ja asetin joukkueen.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Arvostelkaa minua, ei heitä. Tämä on minun joukkueeni ja minun vastuuni.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Jos haluatte syyllisen, istun tässä.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Vastuu on minun. Jättäkää pelaajat rauhaan.';

  @override
  String get pressReplyDemandMore1 =>
      'Haluan enemmän. Osa heistä tietää tarkalleen, mitä tarkoitan.';

  @override
  String get pressReplyDemandMore2 =>
      'Yrittäminen ei riitä tällä tasolla. Haluan enemmän, ja olen sanonut sen heille.';

  @override
  String get pressReplyDemandMore3 =>
      'Odotan enemmän jokaiselta heistä, huomisesta alkaen.';

  @override
  String get pressReplyDemandMore4 =>
      'Osan heistä pitää katsoa peiliin. En ole tyytyväinen.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Voitamme seuraavan. Voitte kirjoittaa sen muistiin.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Merkitkää sanani: voitamme seuraavan ottelun.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Seuraava peli, voitamme. Sanon sen tässä, jotta voitte pitää minut sanoissani.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Olen varma tästä joukkueesta. Voitamme seuraavan ottelun.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Arvioikaa minut kolmen seuraavan ottelun perusteella. Se on reilua.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Antakaa minulle kolme peliä. Jos asiat eivät ole silloin kunnossa, arvioikaa minut sen mukaan.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Seuraavat kolme näyttävät, olenko oikea mies. Pitäkää minut sanoissani.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Kolme ottelua. Sen jälkeen voitte kirjoittaa minusta mitä haluatte.';

  @override
  String get pressReplyDeflect1 =>
      'Otamme yhden pelin kerrallaan. Ei muuta lisättävää.';

  @override
  String get pressReplyDeflect2 => 'En aio tehdä teille otsikoita tänään.';

  @override
  String get pressReplyDeflect3 =>
      'Seuraava peli. Se on ainoa, mitä ajattelen.';

  @override
  String get pressReplyDeflect4 => 'Mitä ajattelen, jää pukukoppiin.';

  @override
  String get pressReplyTakeCredit1 =>
      'Sanoin sen, koska uskoin siihen, ja olin oikeassa.';

  @override
  String get pressReplyTakeCredit2 =>
      'Luin sen oikein. Sitä varten olen täällä.';

  @override
  String get pressReplyTakeCredit3 =>
      'Kutsukaa sitä arvostelukyvyksi. Tiesin, mitä sanoin.';

  @override
  String get pressReplyTakeCredit4 =>
      'Tein ratkaisun ja se onnistui. Otan sen vastaan.';

  @override
  String get pressReplyStandByIt1 =>
      'Sanoin sen, mitä uskoin. Pidän siitä kiinni.';

  @override
  String get pressReplyStandByIt2 => 'En ota sanaakaan takaisin.';

  @override
  String get pressReplyStandByIt3 =>
      'Sama vastaus kuin silloin. Tarkoitin sitä, ja tarkoitan yhä.';

  @override
  String get pressReplyStandByIt4 => 'Sanoisin sen uudestaan huomenna.';

  @override
  String get pressReplyAdmitMistake1 => 'Erehdyin siinä. Myönnän sen.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Ihan oikein, arvioin väärin. Opin siitä.';

  @override
  String get pressReplyAdmitMistake3 => 'Olin väärässä, ja uskallan sanoa sen.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Se ratkaisu ei toiminut, ja se oli minun.';

  @override
  String pressReplyBackPlayer1(String player) {
    return 'Pelaaja $player saa täyden tukeni. Hän nousee kyllä.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Uskon pelaajaan $player, ja hän näyttää teille miksi.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Pelaajaa $player vastaan en kuule sanaakaan. Hän toimittaa.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return 'Pelaaja $player pysyy suunnitelmissani. Katsokaa, mitä hän tekee seuraavaksi.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return 'Pelaaja $player petti meidät tänä iltana, ja hän tietää sen.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Odotin paljon enemmän pelaajalta $player. Hänen on vastattava siihen.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return 'Pelaaja $player ei ollut tasollaan. Sanon sen julkisesti.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Pelaajalta $player tuo ei riittänyt, ja hän kuulee sen minulta.';
  }

  @override
  String get pressOnRecordWinNext => 'Virallisesti: voitat seuraavan ottelun.';

  @override
  String get pressOnRecordJob =>
      'Virallisesti: sinut arvioidaan kolmen seuraavan perusteella.';

  @override
  String pressOnRecordBack(String player) {
    return 'Virallisesti: tuet pelaajaa $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Virallisesti: pelaaja $player petti sinut.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Hän sanoi sen, ja niin kävi. $nation sai valmentajan, joka tarkoittaa sanansa.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Sanoi sen ääneen ja teki sen. Sellaista miestä $nation tarvitsi.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: hän povasi, ja se toteutui. Kunnia hänelle.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Hän kirjautti sen julkisesti, ja se piti. Piste hänelle. $nation jatkaa matkaa.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Yksi meni oikein. $nation, älä totu siihen.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Pysähtynytkin kello on oikeassa kahdesti päivässä. $nation sai tällä kertaa tuuria.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Hän sanoi sen, eikä se toteutunut. Silti olen hänen puolellaan. $nation yrittää uudelleen.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: hän lupasi enemmän kuin saimme, mutta valmentaja, joka uskoo itseensä, on parempi.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: hän sanoi sen julkisesti, eikä niin käynyt. Ihmiset muistavat.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Isoja sanoja, ei katetta. $nation: ensi kerralla sano vähemmän.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Hän seisoi siinä ja kertoi meille. Sitten tämä. $nation ansaitsee parempaa kuin puheet.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Hänen sanansa eivät ole nyt mitään arvoisia. Kirjoita muistiin, $nation.';
  }

  @override
  String get ncZoneNorth => 'Pohjoinen alue';

  @override
  String get ncZoneWest => 'Läntinen alue';

  @override
  String get ncZoneEast => 'Itäinen alue';

  @override
  String get ncZoneCentralSouthern => 'Keski- ja eteläinen alue';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Mestarit';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Hopealle jääneet';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Välierissä';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · 16 parhaan kierros';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Puolivälierä';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Pääse puolivälieriin';

  @override
  String get objectiveNcZoneWinGroup => 'Voita lohkosi';

  @override
  String get finishNcFinalsEight => 'Puolivälierä';

  @override
  String get finishNcBottomHalf => 'Lohkon alapuoli';

  @override
  String get tourContTabZones => 'ALUEET';

  @override
  String get tourContTabFinalsEight => 'PUDOTUSPELIT';

  @override
  String get tourContFinalsEightSoon =>
      'Pudotuspelit alkavat marraskuussa 16 parhaan kierroksella: kaikki 14 lohkovoittajaa ja 2 parasta kakkossijaa.';

  @override
  String get tourContQuarterFinals => 'PUOLIVÄLIERÄT';

  @override
  String get tourContZoneAdvancement =>
      'Jokainen lohkovoittaja jatkaa 16 parhaan kierrokseen, mukana 2 parasta kakkossijaa. Kukaan ei putoa.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Pohjois-Amerikan Nations Cup';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Voita Pohjois-Amerikan Nations Cup';

  @override
  String get objectiveNcWinItAfrica => 'Voita Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Pääse Pohjois-Amerikan Nations Cupin finaaliin';

  @override
  String get objectiveNcReachFinalAfrica => 'Pääse Nations Cupin finaaliin';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Pohjois-Amerikan Nations Cupin voittajat';

  @override
  String get finishNcChampionsAfrica => 'Nations Cupin voittajat';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Karsinnat alkavat ($competition), ja maa uskoo tähän joukkueeseen. Mikä on tavoitteenne?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Uusi karsintakampanja ($competition), ja tunnelma on korkealla. Kuinka pitkälle tämä joukkue voi mennä?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Karsinnat alkavat ($competition). Mikä on kampanjan tavoite?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Karsinnat ovat täällä ($competition). Mihin näet tämän joukkueen sijoittuvan?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Karsinnat alkavat ($competition), ja monet epäilevät, että pääsette perille. Mitä sanot heille?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Taas yksi karsintakampanja ($competition). Miksi kenenkään pitäisi uskoa tämän olevan erilainen?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Turnaus alkaa ($competition), ja koko maa on takanasi. Kuinka pitkälle voitte mennä?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Olette lopputurnauksessa ($competition), ja kannattajat haaveilevat. Mikä on tavoite?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Turnaus alkaa tällä viikolla ($competition). Mikä olisi onnistuminen?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Ensimmäinen ottelunne lähestyy ($competition). Asettakaa meille tavoite.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Turnaus on täällä ($competition), eikä kukaan odota paljon. Mitä oikeasti toivotte?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Olette lopputurnauksessa ($competition), mutta epäilyt eivät ole poistuneet. Mikä on tavoitteenne?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'Maa $rival on lohkossasi. Huolestuttaako se?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Arvonta toi maan $rival tielle. Miten näette sen ottelun?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return 'Maa $rival vaikuttaa lohkosi vahvimmalta. Ovatko he suosikkeja?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Mitä ajattelette maasta $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'Maa $rival on lohkossanne. Olkaa rehellinen: pärjäättekö heille?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Useimmat odottavat maan $rival voittavan teidät. Ovatko he väärässä?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return '$player on hyvässä vireessä. Onko tämä hänen hetkensä?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return '$player on jokaisessa otsikossa. Voiko hän kantaa tämän joukkueen?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Kuinka paljon tämä kampanja riippuu pelaajasta $player?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Onko $player valmis johtamaan tätä joukkuetta?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Jos $player ei ole parhaimmillaan, onko joukkueella mitään?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return 'Pelaajan $player harteilla on paljon. Liikaa?';
  }

  @override
  String get pressReplyAimHigher1 => 'Menemme pidemmälle kuin kukaan odottaa.';

  @override
  String get pressReplyAimHigher2 =>
      'Haluan enemmän kuin liitto pyysi, ja sanon sen ääneen.';

  @override
  String get pressReplyMatchBrief1 => 'Tiedämme tavoitteen, ja saavutamme sen.';

  @override
  String get pressReplyMatchBrief2 =>
      'Liitto asetti tavoitteen. Toimitamme sen.';

  @override
  String get pressReplyPlayDown1 => 'Otetaan yksi peli kerrallaan.';

  @override
  String get pressReplyPlayDown2 =>
      'Ei isoja lupauksia. Katsotaan, missä olemme.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Selviämme karsinnoista. Voitte kirjoittaa sen muistiin.';

  @override
  String get pressReplyPromiseQualify2 => 'Tämä joukkue on lopputurnauksessa.';

  @override
  String get pressReplyFearNobody1 => 'Emme pelkää ketään.';

  @override
  String get pressReplyFearNobody2 =>
      'Heidän täytyy pelata meitä vastaan myös.';

  @override
  String get pressReplyRespectRival1 =>
      'He ovat suosikkeja, ja kunnioitamme heitä.';

  @override
  String get pressReplyRespectRival2 =>
      'Erittäin hyvä joukkue. Tarvitsemme parastamme.';

  @override
  String get pressReplyTeamFirst1 =>
      'Kyse on koko joukkueesta, ei yhdestä pelaajasta.';

  @override
  String get pressReplyTeamFirst2 => 'Kukaan ei voita tätä yksin.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Virallisesti: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Virallisesti: ei lupauksia.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Asetitte tavoitteen ennen kampanjaa ja saavutitte sen. Onko tämä tähänastisen uranne ylpein hetki?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Kerroitte, mitä saavutatte, ja teitte sen. Oliko se koskaan epävarmaa?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Saavutitte asettamanne tavoitteen. Tuuria, vai oliko se oikeasti suunnitelma?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Asetitte tavoitteen ja jäitte sen alle. Mikä meni pieleen?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Lupasitte enemmän kuin tämä joukkue toimitti. Kadutteko sanojanne?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Puhuitte isosti ennen kampanjaa ja jäitte vajaaksi. Miksi uskoisimme teitä nyt?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Lehdistö haluaa kuulla tavoitteesi ($competition)';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Taso $level · $amount';
  }

  @override
  String get formOnFire => 'Tulessa';

  @override
  String get formGood => 'Hyvässä vireessä';

  @override
  String get formSteady => 'Tasainen';

  @override
  String get formPoor => 'Huonossa vireessä';

  @override
  String get formCold => 'Jääkylmä';

  @override
  String get playerFormTitle => 'VIRE JA KUNTO';

  @override
  String playerFormAverage(String rating) {
    return 'Keskiarvo $rating viimeisimmissä peleissään';
  }

  @override
  String get playerFormNoGames =>
      'Liian vähän viimeaikaisia pelejä arvioitavaksi';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta arvosanaan seuraavassa ottelussa';
  }

  @override
  String get playerFormNoEffect =>
      'Ei muutosta arvosanaan seuraavassa ottelussa';

  @override
  String get sideGroupHome => 'Etusivu';

  @override
  String get sideGroupTeam => 'Joukkue';

  @override
  String get sideGroupCompetitions => 'Kilpailut';

  @override
  String get sideGroupFederation => 'Liitto';

  @override
  String get sideGroupHistory => 'Historia';

  @override
  String get sideInbox => 'Saapuneet';

  @override
  String get sideSquad => 'Joukkue';

  @override
  String get sideTactics => 'Taktiikka';

  @override
  String get sideMainMenu => 'Päävalikko';

  @override
  String get sideCallUps => 'Kutsut';

  @override
  String get sideTournaments => 'Turnaukset';

  @override
  String get sideRanking => 'Ranking';

  @override
  String get sideResults => 'Tulokset';

  @override
  String get sideFinances => 'Talous';

  @override
  String get sideBoard => 'Hallitus';

  @override
  String get sideManager => 'Valmentaja & tiimi';

  @override
  String get sideRecords => 'Ennätykset';

  @override
  String get sideLegends => 'Legendat';

  @override
  String get sideHeadToHead => 'Keskinäiset';

  @override
  String get sideAchievements => 'Saavutukset';

  @override
  String get sideCareer => 'Ura';

  @override
  String get topBarNext => 'Seuraava';

  @override
  String get topBarDrawPending => 'Arvonta tulossa';

  @override
  String get paneFullProfile => 'Koko profiili';

  @override
  String get panePickPlayer => 'Valitse pelaaja nähdäksesi kortin tässä';

  @override
  String get inboxPickMessage => 'Valitse viesti lukeaksesi sen tässä';

  @override
  String get inboxFilterAll => 'Kaikki';

  @override
  String get panelViewAll => 'Näytä kaikki';

  @override
  String get gridViewOverview => 'Yleiskatsaus';

  @override
  String get gridColCondition => 'Kunto';

  @override
  String get gridColStatus => 'Tila';

  @override
  String get gridColRank => 'Sija';

  @override
  String get gridColMove => 'Muutos';

  @override
  String get gridColNation => 'Maa';

  @override
  String get gridColRegion => 'Alue';

  @override
  String get gridColPoints => 'Pisteet';

  @override
  String get panePickNation => 'Valitse maa nähdäksesi sen tilastot tässä';

  @override
  String get resultsCyclesTitle => 'Kaudet';

  @override
  String get tourDrawStart => 'Aloita arvonta';

  @override
  String get tourDrawViewGroups => 'Näytä lohkot';

  @override
  String get gridColCeiling => 'Katto';

  @override
  String get gridColYearGain => 'Kasvu';

  @override
  String get gridColMarkedAt => 'Merkittäessä';

  @override
  String get budgetSetupTitle => 'Aseta budjettisi';

  @override
  String get budgetEffectsTitle => 'Mitä tämä budjetti tuo';

  @override
  String get naturalisationTitle => 'Kansalaistaminen';

  @override
  String get yTrending => 'Trendaavat';

  @override
  String get yVoices => 'Äänet';

  @override
  String get yConversation => 'Keskustelu';

  @override
  String get allTimeRecordsTitle => 'Kaikkien aikojen maailmanennätykset';

  @override
  String get h2hMeetingsTitle => 'Jokainen kohtaaminen';

  @override
  String get h2hPickOpponent =>
      'Valitse vastustaja nähdäksesi jokaisen kohtaamisen tässä';

  @override
  String get savesTitle => 'Tallennukset';

  @override
  String get gridColPlayer => 'Pelaaja';

  @override
  String get gridColPos => 'Pos.';

  @override
  String get gridColActive => 'Aktiivinen';

  @override
  String get gridColMotm => 'OP';

  @override
  String get gridColAvg => 'Ka.';

  @override
  String get gridColOpponent => 'Vastustaja';

  @override
  String get gridColStarts => 'Aloitukset';

  @override
  String get gridColTournaments => 'Turnaukset';

  @override
  String get gridColDate => 'Päivämäärä';

  @override
  String get gridColLastPlayed => 'Viimeksi pelattu';

  @override
  String get gridColManager => 'Valmentaja';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maata',
      one: '1 maa',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Järjestys maailmanrankingin mukaan';

  @override
  String get nationsStrength => 'Vahvuus';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier / 5';
  }

  @override
  String get nationsSquadOverall => 'Joukkueen taso';

  @override
  String get nationsOpeningBudget => 'Aloitusbudjetti';

  @override
  String get nationsStarPlayer => 'Tähtipelaaja';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Tähti $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Ikä $age';
  }

  @override
  String get nationsBoardExpects => 'Hallitus odottaa';

  @override
  String nationsManage(String nation) {
    return 'Valmenna: $nation';
  }

  @override
  String get nationsManagerNext => 'Seuraavaksi nimeät valmentajasi';

  @override
  String get playerPageTitle => 'Pelaaja';

  @override
  String get nationPageTitle => 'Maa';

  @override
  String get friendliesYourGames => 'Harjoitusottelusi';

  @override
  String hubEventInjuryCover(String player) {
    return 'Korvaa loukkaantunut pelaaja: $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Poissa $matches ottelusta',
      one: 'Poissa seuraavasta ottelusta',
    );
    return '$_temp0. Kutsu joku tilalle tai jatka ilman häntä.';
  }

  @override
  String get injuryCoverTitle => 'KORVAAJA';

  @override
  String injuryCoverBanner(String player, String position) {
    return '$player ($position) on loukkaantunut. Kutsu kuka tahansa joukkueen ulkopuolinen missä tahansa pelipaikassa tai pidä hänet ja jatka.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'Kutsu: $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Pidä pelaaja $player ja jatka';
  }

  @override
  String get injuryCoverPick => 'Valitse korvaaja';

  @override
  String get injuryCoverNone =>
      'Kukaan joukkueen ulkopuolinen ei ole kunnossa liittyäkseen.';

  @override
  String get nationNowRanking => 'Maailmanranking';

  @override
  String get nationNowForm => 'Vire';

  @override
  String get nationNowNoForm => 'Ei vielä pelattuja otteluita';

  @override
  String get nationNowNext => 'Seuraava ottelu';

  @override
  String get nationNowNoNext => 'Ei tulevia otteluita';

  @override
  String get nationNowSquad => 'Joukkue';

  @override
  String get nationNowAgainstYou => 'Sinua vastaan';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}V ${d}T ${l}H';
  }

  @override
  String get nationNowLastMeeting => 'Edellinen kohtaaminen';

  @override
  String nationNowOverall(int value) {
    return 'Taso $value';
  }

  @override
  String get hubUpcoming => 'TULOSSA';

  @override
  String get hubFullSchedule => 'Koko aikataulu';

  @override
  String get scheduleTitle => 'Aikataulu';

  @override
  String get scheduleToday => 'Tänään';

  @override
  String get scheduleKnockoutPending => 'Pudotuspelivaihe, jos pääset jatkoon';

  @override
  String get scheduleNextRoundPending => 'Seuraava kierros';

  @override
  String scheduleFromDate(String date) {
    return 'Alkaen $date';
  }

  @override
  String get scheduleHomeShort => 'K';

  @override
  String get scheduleAwayShort => 'V';

  @override
  String get tacticsNoPresetsInMatch =>
      'Ei vielä tallennettuja taktiikoita. Tallenna yksi Taktiikka-näytöllä ennen ottelua.';

  @override
  String get homeCampaigns => 'Kampanjat';

  @override
  String get homeContinueCampaign => 'JATKA KAMPANJAA';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Kierros $cycle/$total';
  }

  @override
  String get campaignsTitle => 'Kampanjat';

  @override
  String get campaignTransplantTitle => 'Elinsiirto';

  @override
  String get campaignTransplantTwist =>
      'Kahdeksan Italian parhaista vaihtaa edustamaan San Marinoa';

  @override
  String get campaignTransplantGoal => 'Selviä EM-kisoihin';

  @override
  String get campaignGrudgeTitle => 'Kaunat';

  @override
  String get campaignGrudgeTwist => 'Georgia ja Albania arvottu samaan lohkoon';

  @override
  String get campaignGrudgeGoal => 'Päädy karsinnassa Albanian edelle';

  @override
  String get campaignTransplantIntro =>
      'San Marinolla ei ole ollut koskaan karsintakampanjaa, jota sellaiseksi voisi kutsua. Sitten kahdeksan Italian parhaista ottaa passin ja astuu sisään. Sinulla on yksi kausi aikaa tehdä uteliaisuudesta joukkue.';

  @override
  String get campaignGrudgeIntro =>
      'Georgia ja Albania on arvottu samaan karsintalohkoon, eikä kumpikaan anna tappiota anteeksi. Päädy Albanian edelle ja katso, kuinka pitkälle sen voi viedä.';

  @override
  String get campaignStars1Transplant => 'Selviä karsinnasta';

  @override
  String get campaignStars2Transplant => 'Pääse pudotuspeleihin';

  @override
  String get campaignStars3Transplant => 'Voita EM-kisat';

  @override
  String get campaignStars1Grudge => 'Albanian edellä';

  @override
  String get campaignStars2Grudge => 'Ja selviä karsinnasta';

  @override
  String get campaignStars3Grudge => 'Ja voita heidät kahdesti';

  @override
  String get campaignFree => 'Ilmainen';

  @override
  String get campaignStart => 'Aloita';

  @override
  String get campaignPartOfUnlimited => 'Osa Unlimitediä';

  @override
  String get campaignResume => 'Jatka';

  @override
  String get campaignAbandon => 'Hylkää';

  @override
  String get campaignAbandonConfirm =>
      'Hylätäänkö tämä yritys? Sen edistyminen menetetään, leimasi säilyy.';

  @override
  String get campaignMoveToSaves => 'Siirrä tallennuksiin';

  @override
  String get campaignCannotContinue =>
      'Tämän kampanjan maailma on liian kaukana todellisesta, jotta sitä voisi jatkaa urana.';

  @override
  String get campaignMoveSlotsFull =>
      'Tallennuspaikkasi ovat täynnä. Vapauta ensin yksi.';

  @override
  String get campaignStampConquered => 'Valloitettu';

  @override
  String get campaignStampFailed => 'Epäonnistui';

  @override
  String get campaignDifficultyHard => 'Vaikea';

  @override
  String get campaignDifficultyMedium => 'Keskitaso';

  @override
  String get campaignGoalLabel => 'Tavoite';

  @override
  String get campaignStarsLabel => 'Tähdet';

  @override
  String get campaignRunInProgress =>
      'Tällä kampanjalla on jo yritys käynnissä.';

  @override
  String get campaignVerdictWon => 'Valloitettu';

  @override
  String get campaignVerdictLost => 'Ei tällä kertaa';

  @override
  String get campaignVerdictContinue => 'Jatka';

  @override
  String campaignProgressQualifying(String position) {
    return 'Karsinta: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Lopputurnaus: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Yritys numeroina';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Voitettuja kohtaamisia: $won / $played';
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
  String get campaignGuineasTitle => 'Guineoiden paras';

  @override
  String get campaignGuineasTwist =>
      'Päiväntasaajan Guinea, Afrikan Guineoista pienin, kahden kauden ajan';

  @override
  String get campaignGuineasGoal => 'Voita Guinea ja Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Kolme Afrikan maata kantaa nimeä Guinea, ja Päiväntasaajan Guinea on niistä pienin. Sinulla on kaksi kautta aikaa voittaa Guinea ja Guinea-Bissau vähintään kerran kumpikin ja katsoa sitten, kuinka pitkälle pääset Afrikan mestaruuskilpailuissa. Papua-Uusi-Guinea, neljäs Guinea, on jo varattu harjoitusotteluun.';

  @override
  String get campaignStars1Guineas => 'Voita Guinea ja Guinea-Bissau';

  @override
  String get campaignStars2Guineas => 'Ja selviä Afrikan mestaruuskilpailuihin';

  @override
  String get campaignStars3Guineas =>
      'Ja pääse Afrikan mestaruuskilpailujen puolivälieriin';

  @override
  String get campaignYoungFinnsTitle => 'Nuoret suomalaiset';

  @override
  String get campaignYoungFinnsTwist =>
      'Suomen teini-ikäisten kultainen sukupolvi, kolmen kauden ajan';

  @override
  String get campaignYoungFinnsGoal => 'Selviä MM-kisoihin';

  @override
  String get campaignYoungFinnsIntro =>
      'Suomen aikuispelaajat ovat väistyneet, ja kultainen sukupolvi on ottanut heidän paikkansa: jokainen valittavissasi oleva pelaaja on 18-vuotias tai nuorempi. Nyt he ovat vielä raakileita, mutta heillä on lahjoja nousta yhdeksi maailman parhaista joukkueista, aivan kuten Norjan nuori sukupolvi nousi. Sinulla on kolme kautta aikaa viedä heidät MM-kisoihin ja voittaa sitten EM-kisat ja MM-kisat.';

  @override
  String get campaignStars1YoungFinns => 'Selviä MM-kisoihin';

  @override
  String get campaignStars2YoungFinns => 'Voita EM-kisat';

  @override
  String get campaignStars3YoungFinns => 'Voita MM-kisat';

  @override
  String get campaignGreenlandTitle => 'Grönlannin vuosisata';

  @override
  String get campaignGreenlandTwist =>
      'Grönlanti ottaa San Marinon paikan Euroopassa sadaksi vuodeksi';

  @override
  String get campaignGreenlandGoal => 'Selviä EM-kisoihin';

  @override
  String get campaignGreenlandIntro =>
      'Grönlanti ei ole koskaan pelannut virallista maaottelua. Tässä maailmassa se on ottanut San Marinon paikan Euroopassa ja aloittaa maailmanrankingin pohjalta: amatööripelaajia, tekonurmikenttiä ja lumisateiden väliin puristettu pelikausi. Sinulla on sata vuotta, kaksikymmentäviisi kautta, aikaa selviytyä EM-kisoihin, sitten MM-kisoihin ja, jos uskallat unelmoida, voittaa toinen niistä.';

  @override
  String get campaignStars1Greenland => 'Selviä EM-kisoihin';

  @override
  String get campaignStars2Greenland => 'Selviä MM-kisoihin';

  @override
  String get campaignStars3Greenland => 'Voita EM-kisat tai MM-kisat';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Ei selvinnyt lopputurnaukseen';

  @override
  String get campaignCupOpen => 'Ratkaisematta';

  @override
  String newsYouthTitle1(String name, String level) {
    return '$name loistaa $level-maajoukkueessa';
  }

  @override
  String newsYouthTitle2(String name, String level) {
    return 'Akatemiaraportti: $name herättää huomiota';
  }

  @override
  String newsYouthTitle3(String name, String level) {
    return '$level-maajoukkueen tähti: $name';
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
      other: '$count kertaa',
      one: 'kerran',
    );
    return '$name osui $_temp0 $level-maajoukkueessa vastustajaa $opponent vastaan viimeisimmällä maaottelutauolla.';
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
      other: '$count maalia',
      one: 'maalin',
    );
    return '$name teki $_temp0, kun $level-maajoukkue kohtasi tällä tauolla vastustajan $opponent.';
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
      other: '$count maalin',
      one: 'yhden maalin',
    );
    return '$level-maajoukkue pelasi vastustajaa $opponent vastaan, ja $name poistui kentältä $_temp0 miehenä.';
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
      other: '$count maalia',
      one: 'yhden maalin',
    );
    return '$name syötti $level-maajoukkueessa $_temp0 vastustajaa $opponent vastaan ja johti peliä alusta loppuun.';
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
      other: '$count syöttöpistettä',
      one: 'yksi syöttöpiste',
    );
    return '$level-maajoukkue kohtasi tällä tauolla vastustajan $opponent, ja lankoja veti $name: $_temp0 ja esitys, josta valmennus puhuu yhä.';
  }

  @override
  String newsYouthCleanSheet1(String name, String level, String opponent) {
    return '$name oli erinomainen, kun $level-maajoukkue pelasi nollapelin vastustajaa $opponent vastaan.';
  }

  @override
  String newsYouthCleanSheet2(String name, String level, String opponent) {
    return 'Nollapeli $level-maajoukkueelle vastustajaa $opponent vastaan, ja suurin syy siihen on $name.';
  }

  @override
  String newsYouthDisplay1(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$name teki vaikutuksen $level-maajoukkueessa vastustajaa $opponent vastaan, ja valmennus antoi esitykselle arvosanan $mark/10.';
  }

  @override
  String newsYouthDisplay2(
    String name,
    String level,
    String opponent,
    int mark,
  ) {
    return '$level-maajoukkue pelasi tällä tauolla vastustajaa $opponent vastaan, ja valmentajat nostivat esiin yhden nimen, $name: $mark/10, joukkueen paras arvosana.';
  }

  @override
  String get newsYouthDevReady1 =>
      'Tällä vireellä hän on jo tarpeeksi hyvä harkittavaksi A-maajoukkueeseen.';

  @override
  String get newsYouthDevReady2 =>
      'Valmennus uskoo, että hän on valmis aikuisten jalkapalloon jo nyt. Päätös on sinun.';

  @override
  String get newsYouthDevClose1 =>
      'Hän kehittyy hyvin ja on lähellä läpimurtoa A-maajoukkueeseen.';

  @override
  String get newsYouthDevClose2 =>
      'A-maajoukkueeseen ei ole enää pitkä matka, ja yksi hyvä kausi lisää voisi riittää.';

  @override
  String get newsYouthDevGrowing1 =>
      'Hän kehittyy mukavasti, vaikka A-maajoukkue on vielä askeleen tai kahden päässä.';

  @override
  String get newsYouthDevGrowing2 =>
      'Työtä on vielä ennen kuin hänestä tulee A-maajoukkuepelaaja, mutta kaikki osoittaa oikeaan suuntaan.';

  @override
  String get newsYouthDevRaw1 =>
      'Hän on vielä raakile ja muutaman vuoden päässä A-maajoukkueesta, mutta lahjakkuus näkyy selvästi.';

  @override
  String get newsYouthDevRaw2 =>
      'On vielä aikaista, ja akatemian valmentajat pyytävät kärsivällisyyttä otsikoiden sijaan.';

  @override
  String get newsYouthStrengthGkPhysical =>
      'Ulottuvuus ja rangaistusalueen hallinta erottavat hänet muista.';

  @override
  String get newsYouthStrengthGkTechnical =>
      'Hänen kiinniottonsa ja avauksensa ovat parhaat, jotka akatemia on nähnyt vuosiin.';

  @override
  String get newsYouthStrengthGkStamina =>
      'Hänen keskittymisensä ei herpaannu koskaan: yhdeksännelläkymmenennellä minuutilla hän on yhtä terävä kuin ensimmäisellä.';

  @override
  String get newsYouthStrengthDefPhysical =>
      'Nopeus ja ilmapelivoima ovat hänen pelinsä avain.';

  @override
  String get newsYouthStrengthDefTechnical =>
      'Hän lukee peliä ikäistään paljon paremmin ja on rauhallinen pallon kanssa.';

  @override
  String get newsYouthStrengthDefStamina =>
      'Hän ei koskaan herpaannu ja spurttaa vielä viimeiselläkin minuutilla takaisin puolustukseen.';

  @override
  String get newsYouthStrengthMidPhysical =>
      'Hän voittaa pallot todellisella voimalla ja vie niitä heti eteenpäin.';

  @override
  String get newsYouthStrengthMidTechnical =>
      'Pelinäkemys ja monipuolinen syöttövalikoima ovat hänen pelinsä avain.';

  @override
  String get newsYouthStrengthMidStamina =>
      'Hänen moottorinsa on huikea: hän kattaa jokaisen ruohonkorren.';

  @override
  String get newsYouthStrengthFwdPhysical =>
      'Nopeus syvyyteen ja voima ilmassa tekevät hänestä riesan jokaiselle puolustukselle.';

  @override
  String get newsYouthStrengthFwdTechnical =>
      'Viimeistely ja liikkuminen boksissa ovat hänen pelinsä avain.';

  @override
  String get newsYouthStrengthFwdStamina =>
      'Hän prässää edestä koko ottelun eikä anna puolustajille hetkenkään rauhaa.';

  @override
  String pressMomentBigWinWarm3(String opponent) {
    return 'Fanit laulavat tästä ottelusta vastustajaa $opponent vastaan vielä pitkään. Mitä sanoitte pelaajille loppuvihellyksen jälkeen?';
  }

  @override
  String pressMomentBigWinNeutral3(String opponent) {
    return 'Se oli vahva näyttö vastustajaa $opponent vastaan. Kuinka paljon siitä syntyi harjoituskentällä?';
  }

  @override
  String pressMomentBigWinHostile3(String opponent) {
    return 'Kunnia tuloksesta vastustajaa $opponent vastaan, mutta tällaisia iltoja on nähty ennenkin. Mikä on tällä kertaa toisin?';
  }

  @override
  String pressMomentBigLossWarm3(String opponent) {
    return 'Jokaisella on huono ilta, ja tämä oli sellainen vastustajaa $opponent vastaan. Kuinka nopeasti saatte sen taaksenne?';
  }

  @override
  String pressMomentBigLossNeutral3(String opponent) {
    return '$opponent oli parempi joka osa-alueella. Mistä aloitatte korjaamisen?';
  }

  @override
  String pressMomentBigLossHostile3(String opponent) {
    return 'Kannattajat lähtivät jo ennen loppua ottelusta vastustajaa $opponent vastaan. Voitteko syyttää heitä?';
  }

  @override
  String pressMomentCrisisWarm3(String opponent) {
    return 'Jakso on ollut raskas, eikä $opponent helpottanut sitä yhtään. Mikä pitää teidät pystyssä?';
  }

  @override
  String pressMomentCrisisNeutral3(String opponent) {
    return 'Taas ottelu ilman voittoa, tällä kertaa vastustajaa $opponent vastaan. Kuinka kauan tätä voi jatkua ennen kuin hallitus puuttuu asiaan?';
  }

  @override
  String pressMomentCrisisHostile3(String opponent) {
    return 'Nyt vielä $opponent. Onko suunnitelmassanne mitään jäljellä, vai onko aika antaa tilaa jollekulle muulle?';
  }

  @override
  String get pressReplyCreditPlayers5 =>
      'Mitä ikinä kirjoitattekin, kirjoittakaa se pelaajista. He ovat ansainneet sen.';

  @override
  String get pressReplyCreditPlayers6 =>
      'Minulla on ryhmä, joka menisi tulen läpi toistensa puolesta. Se ei ole vähän.';

  @override
  String get pressReplyTakeResponsibility5 =>
      'Minä teen päätökset, joten kritiikki kuuluu minulle. Sellaista tämä työ on.';

  @override
  String get pressReplyTakeResponsibility6 =>
      'Katsokaa ensin päävalmentajaa. Tein virheitä, ja korjaan ne.';

  @override
  String get pressReplyDemandMore5 =>
      'Hyvä ei riitä täällä. Sanoin sen heille päin naamaa.';

  @override
  String get pressReplyDemandMore6 =>
      'Kenenkään paikka siinä pukukopissa ei ole taattu. Nyt he tietävät sen.';

  @override
  String get pressReplyDeflect5 =>
      'Voitte kysyä sen kolmella eri tavalla. Vastaus pysyy samana.';

  @override
  String get pressReplyDeflect6 =>
      'Ajatukseni pidän pelaajia varten. Ymmärrätte varmasti.';

  @override
  String yWinRoutine12(String opponent, String score) {
    return '$opponent $score. Rauhallista, hallittua, aikuista jalkapalloa. Tätä on ilo katsoa.';
  }

  @override
  String yWinRoutine13(String opponent, String score) {
    return '$opponent kaatui $score hikoilematta. Tämä joukkue on tulossa hyväksi tylsyydessä, ja tylsyys voittaa mestaruuksia.';
  }

  @override
  String yWinRoutine14(String opponent, String score) {
    return '$opponent $score. Kolme pistettä, ei draamaa, takaisin töihin.';
  }

  @override
  String yWinRoutine15(String opponent, String score) {
    return 'Rutiininomainen $score, vastustajana $opponent. Kukaan ei muista sitä, eikä tarvitsekaan.';
  }

  @override
  String yWinRoutine16(String opponent, String score) {
    return '$opponent $score, ja silti olen jotenkin huolissani.';
  }

  @override
  String yWinRoutine17(String opponent, String score) {
    return '$opponent kaatui $score. Oikeaa joukkuetta vastaan tuollaisesta esityksestä rangaistaan.';
  }

  @override
  String yWinTight12(String opponent, String score) {
    return '$opponent $score. Purtiin hammasta, kärsittiin, voitettiin. Tuo on joukkue.';
  }

  @override
  String yWinTight13(String opponent, String score) {
    return '$opponent kaatui $score pelkillä hermoilla. Otan mieluummin joukkueen, joka kieltäytyy häviämästä.';
  }

  @override
  String yWinTight14(String opponent, String score) {
    return '$opponent $score. Viimeiseen sekuntiin asti, mutta pisteet ovat meidän.';
  }

  @override
  String yWinTight15(String opponent, String score) {
    return 'Niukka $score, vastustajana $opponent. Eroa ei paljon ollut, ja sellaista jalkapallo on.';
  }

  @override
  String yWinTight16(String opponent, String score) {
    return '$opponent $score. Yksi onnekas pomppu toiseen suuntaan, ja keskustelisimme ihan muusta.';
  }

  @override
  String yWinTight17(String opponent, String score) {
    return 'Roikuimme hädin tuskin mukana, vastustajana $opponent, $score. Kukaan ei saa kutsua tuota esitykseksi.';
  }

  @override
  String yDrew12(String opponent, String score) {
    return '$opponent $score. Ei tappio, ja joskus juuri se on tehtävä.';
  }

  @override
  String yDrew13(String opponent, String score) {
    return 'Kovalla työllä ansaittu piste vastustajaa $opponent vastaan, $score. Pidin taistelutahdosta.';
  }

  @override
  String yDrew14(String opponent, String score) {
    return '$opponent $score. Pisteet jaettiin, kuten vanhat selostajat sanoivat.';
  }

  @override
  String yDrew15(String opponent, String score) {
    return '$opponent $score. Kumpikaan ei tehnyt tarpeeksi ansaitakseen enempää.';
  }

  @override
  String yDrew16(String opponent, String score) {
    return '$opponent $score. Sellainen tasapeli, joka tuntuu kotimatkan bussissa tappiolta.';
  }

  @override
  String yDrew17(String opponent, String score) {
    return 'Tasapeli $score, vastustajana $opponent. Puhumme koko ajan kehityksestä ja teemme koko ajan tätä.';
  }

  @override
  String yLost12(String opponent, String score) {
    return '$opponent $score. Se sattuu, mutta näin tarpeeksi uskoakseni tähän joukkueeseen.';
  }

  @override
  String yLost13(String opponent, String score) {
    return '$opponent voitti meidät $score, ja he olivat hyviä. Myönnetään se ja jatketaan.';
  }

  @override
  String yLost14(String opponent, String score) {
    return '$opponent $score. Tappio, muutama opetus ja seuraava ottelu pian.';
  }

  @override
  String yLost15(String opponent, String score) {
    return 'Tappio $score, vastustajana $opponent. Vaikea väittää vastaan.';
  }

  @override
  String yLost16(String opponent, String score) {
    return '$opponent $score. Samat virheet kuin viime kerralla, tehtynä samalla itsevarmuudella.';
  }

  @override
  String yLost17(String opponent, String score) {
    return '$opponent voitti meidät $score. Jos kukaan ei joudu tästä vastuuseen, mitä me oikein teemme?';
  }

  @override
  String get yReactionShrug12 =>
      'Minulle käy. Joka ilta ei tarvitse ilotulitusta.';

  @override
  String get yReactionShrug13 =>
      'Pisteet ovat pisteitä. Tänä yönä nukun hyvin.';

  @override
  String get yReactionShrug14 => 'Nähty. Ei huomautettavaa.';

  @override
  String get yReactionShrug15 => 'Jossain ihan ok:n ja ihan ok:n välissä.';

  @override
  String get yReactionShrug16 =>
      'Maksoin striimistä tämän takia. Ei enää ikinä (tulen takaisin).';

  @override
  String get yReactionShrug17 =>
      'Yhdeksänkymmentä minuuttia jalkapallon muotoista tyhjää.';

  @override
  String get yReactionRelief12 => 'Hengitän taas. Ylpeä, että he kestivät.';

  @override
  String get yReactionRelief13 =>
      'Juuri tällaiset voitot rakentavat joukkueen. Ruma on kaunista.';

  @override
  String get yReactionRelief14 => 'Kynnet meni, mutta pisteet eivät.';

  @override
  String get yReactionRelief15 =>
      'Loppuvihellys ei ole koskaan kuulostanut näin hyvältä.';

  @override
  String get yReactionRelief16 =>
      'Iloinen voitosta, huolissani siitä, miten se tuli.';

  @override
  String get yReactionRelief17 =>
      'Selviämme siitä kerta toisensa jälkeen. Jonain päivänä emme selviä.';

  @override
  String get yReactionFury12 =>
      'Rakastan tätä joukkuetta, ja juuri siksi tämä sattuu.';

  @override
  String get yReactionFury13 =>
      'Huono ilta. Ensi kerralla he ovat meille velkaa, ja he tietävät sen.';

  @override
  String get yReactionFury14 =>
      'Suljin seitsemänkymmenen minuutin kohdalla. Olisi pitänyt kuudenkymmenen.';

  @override
  String get yReactionFury15 => 'Ei taistelua, ei ideoita, ei tekosyitä.';

  @override
  String get yReactionFury16 =>
      'Samat ongelmat joka kerta, eikä kukaan korjaa mitään.';

  @override
  String get yReactionFury17 =>
      'Jonkun liitossa pitää katsoa tämä uudelleen ja selittää se.';

  @override
  String get backupShareHint =>
      'Tekee yhden varmuuskopiotiedoston kaikista tallennuksista. Valitse säilytyspaikaksi Google Drive, iCloud Drive tai Tiedostot.';

  @override
  String backupLastAt(String date) {
    return 'Viimeisin varmuuskopio: $date';
  }

  @override
  String get backupNever => 'Ei vielä varmuuskopiota';

  @override
  String get backupRemindersTitle => 'Varmuuskopiomuistutukset';

  @override
  String get backupRemindersBlurb =>
      'Viesti saapuneisiin, kun viimeisin varmuuskopio alkaa olla vanha.';

  @override
  String get backupAutoICloudTitle => 'Automaattinen iCloud-varmuuskopio';

  @override
  String get backupAutoDriveTitle => 'Automaattinen Google Drive -varmuuskopio';

  @override
  String get backupAutoBlurb =>
      'Varmuuskopioi otteluiden jälkeen, syklin lopussa ja kun poistut sovelluksesta. Säilyttää kaksi uusinta.';

  @override
  String get backupStatusUploading => 'Varmuuskopioidaan.';

  @override
  String get backupStatusUploaded => 'Varmuuskopioitu.';

  @override
  String get backupStatusICloudSignedOut =>
      'iCloud on pois päältä. Kirjaudu iCloudiin ja laita iCloud Drive päälle Asetukset-sovelluksessa.';

  @override
  String get backupStatusDriveSignedOut =>
      'Et ole kirjautunut. Kirjaudu Googlella kytkemällä kytkin päälle.';

  @override
  String get backupStatusNotConfigured =>
      'Ei vielä käytettävissä tässä sovelluksen versiossa.';

  @override
  String get backupStatusUnavailable =>
      'Pilveen ei juuri nyt saada yhteyttä. Uusi yritys myöhemmin.';

  @override
  String get backupStatusFailed =>
      'Viimeisin automaattinen varmuuskopio ei onnistunut. Uusi yritys myöhemmin.';

  @override
  String backupDriveSignedInAs(String email) {
    return 'Kirjautuneena: $email';
  }

  @override
  String get backupDriveSignOut => 'KIRJAUDU ULOS';

  @override
  String get backupDriveSignInFailed =>
      'Google-kirjautuminen ei onnistunut. Yritä myöhemmin uudelleen.';

  @override
  String get backupRestoreICloud => 'PALAUTA ICLOUDISTA';

  @override
  String get backupRestoreDrive => 'PALAUTA GOOGLE DRIVESTA';

  @override
  String get backupCrossPlatformHelp =>
      'Vaihdatko iPhonen ja Androidin välillä? Varmuuskopioi tiedostoon yhdellä puhelimella ja palauta siitä tiedostosta toisella.';

  @override
  String get backupCloudListBlurb =>
      'Laitteidesi varmuuskopiot tällä tilillä. Palauta varmuuskopio napauttamalla sitä.';

  @override
  String get backupCloudListEmpty =>
      'Varmuuskopioita ei löytynyt vielä. Uuden varmuuskopion saapuminen toiselle laitteelle voi kestää muutaman minuutin.';

  @override
  String get backupCloudListFailed =>
      'Varmuuskopioita ei voitu lukea. Tarkista yhteys ja yritä uudelleen.';

  @override
  String get backupCloudThisDevice => 'Tämä laite';

  @override
  String backupCloudMore(int count) {
    return 'Muita tallennuksia: $count';
  }

  @override
  String get backupCloudNewer =>
      'Tehty sovelluksen uudemmalla versiolla. Päivitä ensin.';

  @override
  String get backupCloudDownloading => 'Haetaan varmuuskopiota.';

  @override
  String get backupRestoreSafetyNote =>
      'Ensin puhelimen nykyisistä tallennuksista otetaan kopio talteen tähän puhelimeen.';

  @override
  String get backupRejectedSafety =>
      'Nykyisistä tallennuksista ei voitu ottaa kopiota, joten mitään ei korvattu.';

  @override
  String get newsBackupReminderTitle => 'Varmuuskopion aika';

  @override
  String get newsBackupReminderBody =>
      'Tallennuksesi ovat vain tässä puhelimessa. Avaa Asetukset ja napauta Varmuuskopioi pilveen tai laita automaattinen varmuuskopio päälle siellä. Nämä muistutukset voi myös kytkeä pois Asetuksista.';

  @override
  String get backupSafetyTitle => 'Kopiot ennen palautusta';

  @override
  String get backupSafetyBlurb =>
      'Säilytetään tässä puhelimessa siltä varalta, että palautus oli väärä. Kolme uusinta säilytetään.';

  @override
  String get backupSafetyRestore => 'PALAUTA';

  @override
  String get backupSafetyShare => 'JAA';

  @override
  String get backupCloudNoDetails => 'Tiedot ovat vielä tulossa.';

  @override
  String get tacticsLibraryTitle => 'TAKTIIKKAKIRJASTO';

  @override
  String get tacticsLibraryBlurb =>
      'Kirjastosi taktiikat voi ladata mihin tahansa tallennukseen, myös uuteen. Roolit ja vakioiden potkaisijat tallennetaan pelipaikan, ei pelaajan mukaan.';

  @override
  String get tacticsSaveToLibrary => 'Tallenna kirjastoon';

  @override
  String get tacticsLoadFromLibrary => 'Lataa kirjastosta';

  @override
  String get tacticsLibraryEmpty =>
      'Kirjastosi on tyhjä. Tallenna tähän taktiikka, niin voit ladata sen mihin tahansa tallennukseen.';

  @override
  String tacticsLibrarySaved(String name) {
    return '“$name” tallennettu kirjastoon';
  }

  @override
  String tacticsLibraryLoaded(String name) {
    return 'Ladattu “$name”';
  }

  @override
  String tacticsLibraryNotFitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count roolia tai vakiopotkaisijaa ei sopinut tähän joukkueeseen.',
      one: '1 rooli tai vakiopotkaisija ei sopinut tähän joukkueeseen.',
    );
    return '$_temp0';
  }

  @override
  String get tacticsLibraryRename => 'Nimeä uudelleen';

  @override
  String get tacticsLibraryRenameTitle => 'Nimeä taktiikka uudelleen';

  @override
  String get tacticsLibraryDelete => 'Poista';

  @override
  String tacticsLibraryDeleteTitle(String name) {
    return 'Poistetaanko “$name”?';
  }

  @override
  String get tacticsLibraryDeleteBody =>
      'Se katoaa kirjastosta kaikissa tallennuksissasi.';

  @override
  String get tacticsLibraryNameTaken =>
      'Kirjastossasi on jo tämänniminen taktiikka.';

  @override
  String tacticsLibraryCouldNotLoad(String error) {
    return 'Kirjastoa ei voitu ladata.\n$error';
  }

  @override
  String hostBidHeading(String competition, int year) {
    return 'Isännyyshaku: $competition $year';
  }

  @override
  String get hostBidScreenTitle => 'Isännyyshaku';

  @override
  String get hostBidBlurb =>
      'Isäntä arvotaan hakijoiden kesken. Haku antaa nimellesi enemmän painoa: stadionisi tuovat lähtökohdan ja raha kasvattaa mahdollisuutta, joskin jokainen lisämiljoona vaikuttaa hieman vähemmän. Raha on käytetty, voitit tai et.';

  @override
  String hostBidPrize(String amount) {
    return 'Jos voitat, isännöit turnauksen, pääset mukaan suoraan ja saat kertaluonteisen $amount tuen seuraavaan budjettiin.';
  }

  @override
  String get hostBidChance => 'Mahdollisuus isännyyteen';

  @override
  String get hostBidBaseLabel => 'Stadionit ja asema';

  @override
  String get hostBidInvestLabel => 'Sijoitus';

  @override
  String hostBidCeiling(String nation, String percent) {
    return 'Yläraja, $nation: $percent';
  }

  @override
  String get hostBidInvestment => 'Sijoituksesi';

  @override
  String hostBidFreeFunds(String amount) {
    return 'Vapaat varat: $amount';
  }

  @override
  String get hostBidSubmit => 'Jätä haku';

  @override
  String get hostBidDecline => 'Ei tällä kertaa';

  @override
  String get hostBidUnavailable => 'Tämä haku ei ole enää auki.';

  @override
  String hostBidWonTitle(String competition, int year) {
    return 'Haku onnistui: $competition $year';
  }

  @override
  String hostBidWonBody(String amount) {
    return 'Isännöimme turnauksen ja pääsemme isäntänä suoraan mukaan. Kertaluonteinen $amount tuki on nyt liiton kassassa, ja voit jakaa sen tämän syklin osastoille suoraan päänäkymästä.';
  }

  @override
  String hostBidLostTitle(String competition, int year) {
    return 'Haku epäonnistui: $competition $year';
  }

  @override
  String hostBidLostBody(String hosts) {
    return 'Isännyyden sai: $hosts. Hakumme ei tällä kertaa riittänyt ja siihen käytetyt rahat menivät, mutta liitto teki parhaansa.';
  }

  @override
  String get hostBidGrantEvent => 'Jaa isännyystuki';

  @override
  String hostBidGrantBanner(String amount) {
    return 'Isännyystuki: $amount, jonka voit lisätä heti tämän syklin osastoille. Jo jaettu pysyy, ja ylijäämä jää kassaan.';
  }

  @override
  String get stadiumsTitle => 'Kansalliset stadionit';

  @override
  String get stadiumsEntrySub => 'Paranna stadionia tai rakenna uusi';

  @override
  String get stadiumsBlurb =>
      'Stadionin taso on sen koko: taso 1 alle 15 000 paikkaa, taso 2 alkaen 15 000, taso 3 alkaen 25 000, taso 4 alkaen 40 000, taso 5 alkaen 60 000. Jokainen stadion tuottaa pienen tulon jokaisen kauden alussa, sitä enemmän mitä enemmän paikkoja, kunhan yleisö ne täyttää. Laajennus tuo paikat heti ja hieman mainetta seuraavasta kaudesta alkaen; pienennys leikkaa ylläpitoa, mutta mitään ei palauteta. Stadionisi ratkaisevat, mihin turnauksiin voit hakea isännäksi.';

  @override
  String stadiumsIncome(String amount) {
    return 'Stadiontulot: $amount kaudessa';
  }

  @override
  String stadiumsReputation(int points) {
    return 'Maine stadioneista: +$points';
  }

  @override
  String get stadiumsClosed =>
      'Rakennustyöt tilataan kauden alussa ennen budjetin päättämistä.';

  @override
  String stadiumsCapacity(String seats) {
    return 'Kapasiteetti: $seats';
  }

  @override
  String stadiumsLevel(int level, int max) {
    return 'Taso $level/$max';
  }

  @override
  String stadiumsUpgrade(String cost) {
    return 'Paranna: $cost';
  }

  @override
  String get stadiumsTopLevel => 'Ylin taso';

  @override
  String stadiumsOpens(int year) {
    return 'Rakenteilla, avataan vuonna $year';
  }

  @override
  String get stadiumsBuildTitle => 'Rakenna uusi stadion';

  @override
  String get stadiumsBuildBody =>
      'Melko kallis: uusi stadion valitsemaasi kaupunkiin, käytössä seuraavan kauden alusta.';

  @override
  String get stadiumsBuildCity => 'Kaupunki';

  @override
  String stadiumsBuildButton(String cost) {
    return 'Rakenna: $cost';
  }

  @override
  String get stadiumsBuilding => 'Yksi stadion on jo rakenteilla.';

  @override
  String get stadiumsNoCity => 'Jokaisessa kaupungissa on jo uusi stadion.';

  @override
  String stadiumsConfirmUpgrade(String stadium, int level, String cost) {
    return 'Parannetaanko $stadium tasolle $level hintaan $cost?';
  }

  @override
  String stadiumsConfirmBuild(String city, String cost) {
    return 'Rakennetaanko uusi stadion hintaan $cost? Kaupunki: $city';
  }

  @override
  String get stadiumsConfirm => 'Vahvista';

  @override
  String get stadiumsCancel => 'Peruuta';

  @override
  String get stadiumsRefused => 'Tilaus ei mennyt läpi. Mitään ei veloitettu.';

  @override
  String get stadiumsNameLabel => 'Stadionin nimi';

  @override
  String get stadiumsNameHint => 'Jätä tyhjäksi, niin ehdotettu nimi säilyy.';

  @override
  String get stadiumsRename => 'Nimeä stadion uudelleen';

  @override
  String get hostBidSectionTitle => 'Isännyyshaut';

  @override
  String get hostBidOpenSub => 'Vapaaehtoinen. Päätä ennen uuden kauden alkua.';

  @override
  String get hostBidDecidedAtRollover =>
      'Isäntä julkistetaan uuden kauden alkaessa.';

  @override
  String get hostBidLodged =>
      'Haku jätetty. Isäntä julkistetaan uuden kauden alkaessa.';

  @override
  String get hostBidDeclinedNote => 'Päätit olla hakematta tällä kertaa.';

  @override
  String get hostBidOpensLater =>
      'Ehdot täyttyvät. Voit hakea tämän kauden lopussa.';

  @override
  String get hostBidNoFunds => 'Vapaat varat eivät riitä hakuun.';

  @override
  String hostBidNeedStadiums(int count, String seats) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tarvitset vielä $count stadionia, joissa on $seats+ paikkaa.',
      one: 'Tarvitset vielä 1 stadionin, jossa on $seats+ paikkaa.',
    );
    return '$_temp0';
  }

  @override
  String hostBidBarredConf(String confederation) {
    return 'Edelliset MM-kisat järjesti $confederation.';
  }

  @override
  String get hostBidRecentHost => 'Isännöit yhtä kolmesta viime turnauksesta.';

  @override
  String hostBidRequirement(
    int grounds,
    String minSeats,
    int bigGrounds,
    String bigSeats,
  ) {
    return 'Vaatimus: $grounds stadionia, joissa $minSeats+ paikkaa, niistä $bigGrounds vähintään $bigSeats.';
  }

  @override
  String hostBidWonBodyBudget(String amount) {
    return 'Isännöimme turnauksen ja pääsemme isäntänä suoraan mukaan. $amount kertaluonteinen tuki on jo liiton varoissa ja valmiina tämän kauden budjettiin.';
  }

  @override
  String get hubStadiumIncome => 'Stadiontulot';

  @override
  String get stadiumsDownsize => 'Pienennä';

  @override
  String stadiumsConfirmDownsize(String stadium, String seats, int level) {
    return 'Pienennetäänkö $stadium $seats paikkaan (taso $level)? Mitään ei palauteta, mutta ylläpitokulut laskevat.';
  }

  @override
  String get stadiumsResizedThisCycle => 'Uudistettu tällä kaudella';

  @override
  String stadiumsGroundIncome(String amount) {
    return 'Tuottaa $amount kaudessa';
  }

  @override
  String hostBidLapsedTitle(String competition, int year) {
    return 'Haku peruttu: $competition $year';
  }

  @override
  String hostBidLapsedBodyNation(String nation) {
    return 'Haku tehtiin maalle $nation, mutta aloitat uuden kauden muualla. Haku peruttiin, eikä mitään veloitettu.';
  }

  @override
  String get hostBidLapsedBodyFunds =>
      'Kauden päättyessä liiton varat eivät enää riittäneet panokseen. Haku peruttiin, eikä mitään veloitettu.';

  @override
  String get stadiumsViewMap => 'Kartta';

  @override
  String get stadiumsViewList => 'Lista';

  @override
  String get stadiumsMapPickCity =>
      'Napauta kaupunkia, johon haluat rakentaa uuden stadionin.';

  @override
  String get stadiumsMapFit => 'Näytä koko maa';

  @override
  String get campaignLegacyTitle => 'Perinnön täyttymys';

  @override
  String get campaignLegacyTwist =>
      'Espanja, hallitseva Euroopan mestari, yhden kauden ajan';

  @override
  String get campaignLegacyGoal => 'Puolusta EM-titteliä';

  @override
  String get campaignLegacyIntro =>
      'Espanja on hallitseva Euroopan mestari, ja epäilijät pitävät kultaista kautta kertaluontoisena. Sinulla on yksi kausi aikaa todistaa toisin: puolusta mantereen kruunua ja tavoittele sitten maailmaa. Lisää vielä Nations Cup, niin perintö on täydellinen.';

  @override
  String get campaignStars1Legacy => 'Voita EM-kisat';

  @override
  String get campaignStars2Legacy => 'Ja MM-kisat';

  @override
  String get campaignStars3Legacy => 'Ja Nations Cup';

  @override
  String get campaignSectionOneCycle => 'Yksi kausi';

  @override
  String get campaignSectionShort => 'Muutama kausi';

  @override
  String get campaignSectionLong => 'Pitkä tie';

  @override
  String get campaignFilterAll => 'Kaikki';

  @override
  String get campaignFilterNew => 'Pelaamatta';

  @override
  String get campaignFilterInProgress => 'Kesken';

  @override
  String get campaignFilterDone => 'Suoritettu';

  @override
  String get campaignFilterEmpty => 'Täällä ei ole vielä kampanjoita.';

  @override
  String campaignStarsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tähteä',
      one: '1 tähti',
      zero: 'Ei tähtiä',
    );
    return '$_temp0';
  }

  @override
  String campaignCycles(int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles kautta',
      one: '1 kausi',
    );
    return '$_temp0';
  }

  @override
  String get msgIntlRetireNoteHigh => ' Hän lopettaa huipulla, mestarina.';

  @override
  String get msgIntlRetireNoteMissed =>
      ' Arvokisoista putoaminen oli viimeinen pisara.';

  @override
  String get msgIntlRetireNoteSurprise => ' Kukaan ei osannut odottaa tätä.';

  @override
  String get msgIntlRetireNoteRecord =>
      ' Hän lähtee maajoukkueen ennätysmiehenä.';

  @override
  String msgIntlRetireNewsTitle(String nation, String name) {
    return '$nation: $name lopettaa maajoukkueuransa';
  }

  @override
  String msgIntlRetireNewsBody(String name, String nation, int age) {
    return '$name ($nation) ilmoitti $age-vuotiaana lopettavansa maajoukkueuransa.';
  }

  @override
  String msgIntlComebackTitle(String name) {
    return '$name palaa maajoukkueeseen';
  }

  @override
  String msgIntlComebackBody(String name, int age) {
    return '$name on $age-vuotiaana jälleen valittavissa.';
  }

  @override
  String get msgIntlComebackNoteCrisis =>
      ' Loukkaantumisten runtelema joukkue sai hänet vastaamaan kutsuun.';

  @override
  String get msgIntlComebackNoteManager =>
      ' Uusi päävalmentaja sai hänet muuttamaan mielensä.';

  @override
  String msgIntlComebackNewsTitle(String nation, String name) {
    return '$nation: $name palaa maajoukkueeseen';
  }

  @override
  String msgIntlComebackNewsBody(String name, String nation, int age) {
    return '$name ($nation) on $age-vuotiaana jälleen valittavissa.';
  }

  @override
  String playerIntlRetired(int year) {
    return 'Lopetti maajoukkueuran, $year';
  }

  @override
  String playerIntlComeback(int year) {
    return 'Palasi maajoukkueeseen, $year';
  }

  @override
  String yLegendRetires0(String name) {
    return 'Kiitos, $name. Jotkut pukevat paidan, hän kantoi joukkuetta.';
  }

  @override
  String yLegendRetires1(String name) {
    return '$name lopettaa maajoukkueuransa. Aikakausi päättyy.';
  }

  @override
  String yLegendRetires2(String name) {
    return '$name lopettaa. Rehellisesti sanottuna turnauksen liian myöhään.';
  }

  @override
  String yLegendRetires3(String name) {
    return 'Eli $name on valmis. Annetaan nuorille tilaa.';
  }

  @override
  String matchAltitudeOpponentsTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Korkeus $altitudeString m: vastustaja väsyy nopeammin';
  }

  @override
  String matchAltitudeYouTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Korkeus $altitudeString m: pelaajasi väsyvät nopeammin';
  }

  @override
  String matchAltitudeBothTire(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Korkeus $altitudeString m: molemmat joukkueet väsyvät nopeammin';
  }

  @override
  String matchAltitudeUsedTo(int altitude) {
    final intl.NumberFormat altitudeNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String altitudeString = altitudeNumberFormat.format(altitude);

    return 'Korkeus $altitudeString m: molemmat joukkueet ovat tottuneet siihen';
  }

  @override
  String matchHeatExpected(int temp) {
    final intl.NumberFormat tempNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String tempString = tempNumberFormat.format(temp);

    return 'Helle: odotettavissa $tempString °C, voimat loppuvat aiemmin';
  }

  @override
  String get matchConditionsAdvice =>
      'Suunnittele vaihdot ajoissa: tuoreet jalat ovat täällä kullanarvoisia';

  @override
  String get fanMoodFurious => 'raivoissaan';

  @override
  String get fanMoodRestless => 'levottomia';

  @override
  String get fanMoodCalm => 'rauhallisia';

  @override
  String get fanMoodUpbeat => 'toiveikkaita';

  @override
  String get fanMoodEuphoric => 'euforisia';

  @override
  String matchHomeFans(String mood) {
    return 'Kotikannattajat: $mood';
  }

  @override
  String federationFans(String mood) {
    return 'Kannattajat: $mood';
  }

  @override
  String federationFansIncome(String change) {
    return 'Stadiontulot ensi syklissä: $change';
  }

  @override
  String yFansProtest0(String nation, String manager) {
    return 'Kaksikymmentä vuotta maajoukkueen perässä kotona ja vieraissa. En uusi kausikorttiani ennen kuin jokin muuttuu.';
  }

  @override
  String yFansProtest1(String nation, String manager) {
    return 'Laulamme edelleen pelipaidan puolesta. Mutta pohjoispäädyn banderolli sanoi tänään sen, mitä me kaikki ajattelemme.';
  }

  @override
  String yFansProtest2(String nation, String manager) {
    return 'Puoli stadionia tyhjänä, ja toinen puoli lauloi koko toisen puoliajan #${manager}Out.';
  }

  @override
  String yFansProtest3(String nation, String manager) {
    return 'Kannattajaryhmät puhuvat seuraavan kotiottelun boikotoinnista. Vaikea heitä on syyttää.';
  }

  @override
  String yFansProtest4(String nation, String manager) {
    return '#${manager}Out. En ole enää edes vihainen. Riittää.';
  }

  @override
  String yFansProtest5(String nation, String manager) {
    return 'Kuva tältä illalta: rivikaupalla tyhjiä istuimia ja yksi lakana, jossa lukee #${manager}Out. Siinä otteluraportti.';
  }

  @override
  String yFansSellOut0(String nation) {
    return 'Taas loppuunmyyty. Paras maajoukkue vuosiin, ja koko maa tietää sen.';
  }

  @override
  String yFansSellOut1(String nation) {
    return 'Seuraava kotiottelu myytiin loppuun yhdessätoista minuutissa. Tämä joukkue antoi meille viikonloput takaisin.';
  }

  @override
  String yFansSellOut2(String nation) {
    return 'Seuraavaan kotiotteluun ei ole yhtään vapaata paikkaa. Liitto laskee lipputuloja hymyssä suin.';
  }

  @override
  String yFansSellOut3(String nation) {
    return 'Taas loppuunmyyty. Sanokaa taktiikasta mitä haluatte, ihmiset haluavat olla sillä stadionilla.';
  }

  @override
  String yFansSellOut4(String nation) {
    return 'Loppuunmyyty, hyvä on. Samat ihmiset buuasivat tälle porukalle puolitoista vuotta sitten.';
  }

  @override
  String yFansSellOut5(String nation) {
    return 'Yhtäkkiä loppuunmyyty, yhtäkkiä kaikki asiantuntijoita. Missä te olitte, kun emme voittaneet ketään?';
  }

  @override
  String get campaignsIntro =>
      'Kampanjat ovat käsin rakennettuja haasteita: määrätty maajoukkue, maailma omalla käänteellään ja tavoite, joka on saavutettava tietyssä määrässä kausia. Jokainen yritys pidetään erillään tallennetuista urista, ja mitä pidemmälle pääset, sitä enemmän tähtiä saat, enintään kolme.';

  @override
  String hubEventScandal(String player) {
    return 'Skandaali leirillä: $player';
  }

  @override
  String get hubEventScandalSub => 'Lähetätkö hänet kotiin vai pidätkö hänet?';

  @override
  String get scandalTitle => 'SKANDAALI';

  @override
  String scandalStoryParty(String player) {
    return '$player oli juhlissa aamunkoittoon asti, ja kuvat olivat kaikissa lehdissä sinä aamuna, kun joukkue kokoontui.';
  }

  @override
  String scandalStoryCurfew(String player) {
    return '$player rikkoi ulkonaliikkumiskieltoa ja jäi kiinni palatessaan hotelliin aamuyöllä.';
  }

  @override
  String scandalStoryNightclub(String player) {
    return '$player kuvattiin yökerhossa leirin aattona, ja kuvat ovat kaikkialla.';
  }

  @override
  String scandalStoryCasino(String player) {
    return '$player vietti leiriä edeltävän yön kasinopöydän ääressä, ja iltapäivälehdellä on kuvat.';
  }

  @override
  String get scandalSendHome => 'Lähetä kotiin';

  @override
  String scandalSendHomeCover(String player) {
    return 'Kotiin, kutsu tilalle $player';
  }

  @override
  String scandalKeep(String player) {
    return 'Pidä $player';
  }

  @override
  String get scandalKeepNote =>
      'Jos hän jää: moraali noin -4 ja hallitus noin -3 syklin loppuun.';

  @override
  String get scandalSendHomeNote =>
      'Jos lähetät hänet kotiin: ei vaikutusta moraaliin tai hallitukseen, ja voit kutsua korvaajan.';

  @override
  String get scandalFinalsNote =>
      'Jos lähetät hänet kotiin: ei vaikutusta moraaliin tai hallitukseen, mutta lopputurnauksessa kukaan ei voi korvata häntä.';

  @override
  String get scandalPickCover => 'Kutsu korvaaja (valinnainen)';

  @override
  String newsScandalTitle(String player) {
    return 'Skandaali leirillä: $player';
  }

  @override
  String yScandalParty0(String player, String tag) {
    return 'Pojat ovat poikia. $player juhlissa leiriä edeltävänä iltana, ja haluan hänet silti kentälle. #$tag';
  }

  @override
  String yScandalParty1(String player, String tag) {
    return '$player kuvattiin aamuun jatkuneissa juhlissa tunteja ennen joukkueen kokoontumista. Liitolle on ilmoitettu. #$tag';
  }

  @override
  String yScandalParty2(String player, String tag) {
    return 'Juhlat aamuun asti ennen leiriä. $player, mitä oikein ajattelit? Uskomatonta. #$tag';
  }

  @override
  String yScandalCurfew0(String player, String tag) {
    return 'Takaisin kotiintuloajan jälkeen, no, sattuuhan sitä. $player hoitaa asian kentällä. #$tag';
  }

  @override
  String yScandalCurfew1(String player, String tag) {
    return '$player jäi kiinni palatessaan joukkueen hotelliin kotiintuloajan jälkeen, tunteja ennen harjoituksia. #$tag';
  }

  @override
  String yScandalCurfew2(String player, String tag) {
    return 'Kotiintuloaika ei ole vaikea juttu. $player ei kestänyt yhtäkään yötä. #$tag';
  }

  @override
  String yScandalNightclub0(String player, String tag) {
    return '$player oli siis klubilla. Jalkapalloilijoillakin on elämä. Antakaa hänen pelata. #$tag';
  }

  @override
  String yScandalNightclub1(String player, String tag) {
    return 'Kuvissa $player on yökerhossa maajoukkueleirin aattona. #$tag';
  }

  @override
  String yScandalNightclub2(String player, String tag) {
    return 'Klubikuvia leirin aattona. $player toi häpeää paidalle. #$tag';
  }

  @override
  String yScandalCasino0(String player, String tag) {
    return 'Yö kasinolla ei ole rikos. $player pärjää kyllä. #$tag';
  }

  @override
  String yScandalCasino1(String player, String tag) {
    return '$player nähtiin kasinopöydässä joukkueen kokoontumista edeltävänä yönä. #$tag';
  }

  @override
  String yScandalCasino2(String player, String tag) {
    return 'Koko yö kasinolla ennen leiriä. $player pelasi muutakin kuin rahaa. #$tag';
  }

  @override
  String yScandalSentHome0(String player) {
    return 'Oikea päätös. Kukaan ei ole joukkuetta suurempi, ei myöskään $player.';
  }

  @override
  String yScandalSentHome1(String player) {
    return 'Kotiin lähettäminen oli ainoa vastaus. Kunnioitus päävalmentajalle. $player sai mitä tilasi.';
  }

  @override
  String yScandalSentHome2(String player) {
    return 'Kuri on kuria. $player tiesi säännöt.';
  }

  @override
  String yScandalSentHome3(String player) {
    return 'Selvä viesti joukkueelle: $player istuu kotiinpaluukoneessa.';
  }

  @override
  String yScandalSentHome4(String player) {
    return 'Kovaa. $player käy kerran illalla ulkona, ja leiri loppuu siihen?';
  }

  @override
  String yScandalSentHome5(String player) {
    return 'Kotiin lähettäminen heikentää meitä. $player puuttuu, ja maksamme siitä kentällä.';
  }

  @override
  String yScandalKept0(String player) {
    return 'Pitäminen on uhkapeliä. $player saa maksaa sen takaisin kentällä.';
  }

  @override
  String yScandalKept1(String player) {
    return 'Hyvä on, $player jää. Sitten hän on kaikille velkaa kunnon esityksen.';
  }

  @override
  String yScandalKept2(String player) {
    return 'Säännöt eivät siis koske häntä. $player on poikkeus. Hyvä tietää.';
  }

  @override
  String yScandalKept3(String player) {
    return 'Kotiintuloaika on nyt ilmeisesti vapaaehtoinen. Kysykää vaikka: $player.';
  }

  @override
  String yScandalKept4(String player) {
    return 'Tuon jälkeen hän saa jäädä? $player ja kumppanit ovat kesäleirillä.';
  }

  @override
  String yScandalKept5(String player) {
    return 'Juhlat koko yön ja sitten suoraan avauskokoonpanoon. Hieno viesti, valmentaja. $player on varmasti ihastuksissaan.';
  }

  @override
  String get yStreamerBreaks0 =>
      'VELI JÄI KIINNI 😭😭 LEIRIÄ EDELTÄVÄNÄ YÖNÄ?? MÄ ITKEN 💀💀💀';

  @override
  String get yStreamerBreaks1 =>
      'EIII CHAT KATTOKAA TÄTÄ 🤯🤯 VELI OIKEESTI TEKI SEN ENNEN LEIRIÄ 😭🔥';

  @override
  String get yStreamerBreaks2 =>
      'KUKA PÄÄSTI SEN ULOS?? KUKA PÄÄSTI SEN ULOS 😭😭💀 TÄÄ ON ELOKUVAA 🔥🔥';

  @override
  String get yStreamerSentHome0 =>
      'KOTIIN?? KOTIIN!!! 😭😭😭 VALMENTAJA EI PELLEILE 💀🔥';

  @override
  String get yStreamerSentHome1 =>
      'VELI PAKKAA LAUKKUJA SUORANA 🤯🤯 MOIKKA VELI 😭👋';

  @override
  String get yStreamerSentHome2 =>
      'EI VOI OLLAAA NE LÄHETTI SEN KOTIIN 💀💀 CHAT MÄ TÄRISEN 🔥🔥🔥';

  @override
  String get yStreamerKept0 =>
      'SE JÄÄ??? SE JÄÄÄÄ 🤯🤯 VELI ON KOSKEMATON 😭🔥';

  @override
  String get yStreamerKept1 =>
      'BILEET KOKO YÖN JA EDELLEEN JOUKKUEESSA 💀💀 MÄ HALUUN TON SOPPARIN 😭😭';

  @override
  String get yStreamerKept2 =>
      'VALMENTAJA SANOO ET KAIKKI OK 😭😭 VELI MITÄ 🤯🤯🤯';

  @override
  String get yCameoUjfaloci => 'En maksanut mitään, eikä se summakaan täsmää';

  @override
  String get yCameoHavir0 => 'Pikku kalat uivat tiehensä.';

  @override
  String get yCameoHavir1 => 'Heitimme verkot, kalat olivat muualla.';

  @override
  String get yCameoHavir2 => 'Sanoin sen jo syyskuussa gulassin äärellä.';

  @override
  String get yCameoHavir3 => 'Joka ei kalastanut ajoissa, älköön itkekö nyt.';

  @override
  String get yCameoHavir4 => 'Pelasimme kuin monni kuivalla maalla.';

  @override
  String get yCameoHavir5 => 'Tuuli puhaltaa, lampi jäätyy. Niin se menee.';

  @override
  String get yCameoHavir6 => 'Joskus nostaa ylös vain vanhan saappaan.';

  @override
  String get yCameoHavir7 =>
      'Minun aikanani mentiin sentään oluelle. Nyt ei sitäkään.';

  @override
  String get yCameoLzimberskyHome0 =>
      'Pojan lähettäminen kotiin yhden illan takia? Se on skandaali, eivät juhlat!';

  @override
  String get yCameoLzimberskyHome1 =>
      'Pojat saavat kai vähän pitää hauskaa! Tekopyhä media voittaa taas.';

  @override
  String get yCameoLzimberskyHome2 =>
      'Tämä on noitavaino. Nuori mies käy kerran ulkona, ja te hirtätte hänet.';

  @override
  String get yCameoLzimberskyHome3 =>
      'Se toimittaja, joka ei ole koskaan ollut juhlissa, heittäköön ensimmäisen kiven. Häpeä!';

  @override
  String get yCameoLzimberskyHome4 =>
      'Valmentaja pelästyi iltapäivälehtiä. Minä olisin puolustanut poikaa viimeiseen hengenvetoon!';

  @override
  String get yCameoLzimberskyKept0 =>
      'Vihdoin valmentaja, jolla on selkärankaa! Hän piti pojan, ja media saa itkeä.';

  @override
  String get yCameoLzimberskyKept1 =>
      'Pojat saavat kai vähän pitää hauskaa, eikö? Bravo, valmentaja!';

  @override
  String get yCameoLzimberskyKept2 =>
      'Tekopyhä media huutaa, valmentaja pitää päänsä. Niin se tehdään!';

  @override
  String get yCameoLzimberskyKept3 =>
      'Yksi ilta ulkona, ja lehdistö haluaa kivittää hänet. Valmentaja on oikea mies!';

  @override
  String get yCameoLzimberskyKept4 =>
      'Minä sanon: antakaa poikien elää! Joka tekee töitä, saa myös juhlia. Peukku ylös.';

  @override
  String get yTraitStreamer =>
      'Striimaa kaiken, täysillä ja isoilla kirjaimilla.';

  @override
  String hubEventAwardsCeremony(int year) {
    return 'Vuoden pelaaja $year';
  }

  @override
  String get hubEventAwardsCeremonySub => 'Äänet on laskettu';

  @override
  String get potyCeremonyWatch => 'Katso gaala';

  @override
  String get potyCeremonySkipToList => 'Suoraan kärkiviisikkoon';

  @override
  String get potyCeremonySkip => 'Ohita';

  @override
  String get potyCeremonyIntro =>
      'Äänet on laskettu. Tässä ovat tämän vuoden viisi maailman parasta pelaajaa.';

  @override
  String potyCeremonyPlace(int place) {
    return 'Sija $place';
  }

  @override
  String get potyCeremonyWinnerIs => 'Ja vuoden pelaaja on...';

  @override
  String get potyTop5Heading => 'Maailman kärkiviisikko';

  @override
  String get potyYoungTop3Heading => 'Vuoden nuori pelaaja: kärkikolmikko';

  @override
  String get potySeeTop5 => 'Näytä kärkiviisikko';

  @override
  String get potyYourPlayer => 'Sinun pelaajasi';

  @override
  String potyTallyCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nollapeliä',
      one: '1 nollapeli',
    );
    return '$_temp0';
  }

  @override
  String get campaignFullBrief => 'Koko tehtävänanto';

  @override
  String campaignStarsSoFar(int earned, int total) {
    return 'Tähtiä tähän mennessä: $earned/$total';
  }

  @override
  String get campaignStarEarned => 'Ansaittu tähän mennessä';

  @override
  String get campaignStarNotYet => 'Ei vielä ansaittu';

  @override
  String get stadiumsEntrySubClosed =>
      'Katso stadionisi. Rakennustöitä voi tilata taas seuraavan kauden alussa.';

  @override
  String get boardObjectiveNoBrief => 'Ei tavoitetta';

  @override
  String get boardObjectiveNoBriefBody =>
      'Hallitus ei odota pääsyä näihin loppuotteluihin. Se arvioi sinua sen sijaan tulosten perusteella.';

  @override
  String get boardObjectiveAwaitingDraw => 'Tavoite arvonnan jälkeen';

  @override
  String get boardObjectiveAwaitingDrawBody =>
      'Hallitus asettaa tämän tavoitteen, kun lohkot on arvottu.';
}
