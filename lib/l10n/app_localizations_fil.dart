// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get matchPreviewTitle => 'PREVIEW NG LARO';

  @override
  String get matchKickOff => 'Kick-off';

  @override
  String get matchTactics => 'Taktika';

  @override
  String get matchYourXi => 'ANG IYONG XI';

  @override
  String get matchHeadToHead => 'HEAD TO HEAD';

  @override
  String matchCouldNotLoad(String error) {
    return 'Hindi ma-load ang laro.\n$error';
  }

  @override
  String get matchNoUpcoming => 'Walang paparating na laro.';

  @override
  String get matchUnknownNation => 'Hindi kilala';

  @override
  String get matchH2hFirstMeeting => 'Unang pagkikita pa lang';

  @override
  String get matchH2hYouLead => 'Ikaw ang nangunguna sa head-to-head';

  @override
  String matchH2hOppEdge(String opponent) {
    return 'Lamang ang $opponent';
  }

  @override
  String get matchH2hEven => 'Patas ang bilangan';

  @override
  String matchH2hMet(int count) {
    return '$count beses nagharap';
  }

  @override
  String get matchH2hWon => 'Panalo';

  @override
  String get matchH2hDrawn => 'Tabla';

  @override
  String get matchH2hLost => 'Talo';

  @override
  String get matchDossierTitle => 'Ulat ng scout';

  @override
  String get matchDossierForm => 'PORMA';

  @override
  String get matchDossierNoGames => 'Walang kamakailang laro';

  @override
  String get matchDossierKeyMen => 'MGA SUSING MANLALARO';

  @override
  String matchCouldNotContinue(String error) {
    return 'Hindi makapagpatuloy: $error';
  }

  @override
  String get matchSkipToFullTime => 'Lundagan hanggang full-time';

  @override
  String get matchStatShots => 'Tira';

  @override
  String get matchStatGoals => 'Goal';

  @override
  String get matchStatYellowCards => 'Dilaw';

  @override
  String get matchStatRedCards => 'Pula';

  @override
  String get matchMomentum => 'MOMENTUM';

  @override
  String get matchSwingAtk => 'ATK';

  @override
  String get matchSwingDef => 'DEF';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'KAMPEONATO NG MUNDO $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'NARITO NA ANG FINALS';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'HOST:  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'HOST, KUMPIRMASYON PA';

  @override
  String get matchHalfTime => 'HALF-TIME';

  @override
  String get matchContinue => 'Magpatuloy';

  @override
  String get matchContinuing => 'Nagpapatuloy…';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Taktika · $used/$max pamalit';
  }

  @override
  String matchTiredCount(int count) {
    return 'PAGOD ×$count';
  }

  @override
  String get matchTacticsLabel => 'TAKTIKA';

  @override
  String get teamOverallOverTime => 'OVERALL SA PAGLIPAS NG PANAHON';

  @override
  String get teamOverall => 'Overall';

  @override
  String get teamTalkHeading => 'TEAM TALK';

  @override
  String get teamTalkPrompt => 'Itakda ang tono para sa ikalawang kalahati.';

  @override
  String get teamTalkCalmLabel => 'Kalmado lang';

  @override
  String get teamTalkCalmBlurb =>
      'Patatagin ang koponan. Kaunting angat sa lahat.';

  @override
  String get teamTalkEncourageLabel => 'Palakasin ang loob';

  @override
  String get teamTalkEncourageBlurb => 'Sumulong at habulin ang laro.';

  @override
  String get teamTalkDemandMoreLabel => 'Humingi ng higit pa';

  @override
  String get teamTalkDemandMoreBlurb => 'Ibigay ang lahat. Sumugod nang todo.';

  @override
  String get teamTalkPraiseLabel => 'Higpitan';

  @override
  String get teamTalkPraiseBlurb =>
      'Manatiling siksik at ingatan ang nasa inyo.';

  @override
  String get teamTalkBelieveLabel => 'Maniwala';

  @override
  String get teamTalkBelieveBlurb =>
      'Magtiwala sa sarili. Angat sa magkabilang dulo ng field.';

  @override
  String get teamTalkFocusLabel => 'Manatiling alerto';

  @override
  String get teamTalkFocusBlurb => 'Buong konsentrasyon. Isara ang laro.';

  @override
  String get teamTalkUrgencyLabel => 'Madaliin';

  @override
  String get teamTalkUrgencyBlurb =>
      'Habulin na ngayon. Todo-atake, pero magbubukas ng espasyo.';

  @override
  String get teamTalkReassureLabel => 'Walang pressure';

  @override
  String get teamTalkReassureBlurb =>
      'Pakalmahin ang kaba at panatilihin ang hugis.';

  @override
  String get commonRetry => 'Subukan muli';

  @override
  String get commonSomethingWentWrong => 'May nagkamali';

  @override
  String get commonCrashBox =>
      'May nagkamali rito.\nNasa Mga setting → Diagnostics ang detalye.';

  @override
  String hubCouldNotAdvance(String error) {
    return 'Hindi napausad ang mundo: $error';
  }

  @override
  String get settingsDiagnosticsTitle => 'Diagnostics';

  @override
  String get settingsDiagnosticsBlurb =>
      'Mga error na naitala sa device na ito. Walang ipinapadala kahit saan.';

  @override
  String get settingsContactTitle => 'Makipag-ugnayan';

  @override
  String get settingsContactCopied => 'Nakopya ang address.';

  @override
  String get settingsCommunityTitle => 'Komunidad';

  @override
  String get settingsDiscordSubtitle => 'Sumali sa komunidad';

  @override
  String get settingsLinkCopied => 'Nakopya na ang link.';

  @override
  String get diagnosticsEmpty =>
      'Walang naitalang error. Iyon talaga ang gusto natin.';

  @override
  String get diagnosticsCopy => 'Kopyahin';

  @override
  String get diagnosticsCopied => 'Nakopya ang log sa clipboard.';

  @override
  String get diagnosticsClear => 'Burahin';

  @override
  String get navHub => 'Home';

  @override
  String get navSquad => 'Squad';

  @override
  String get navStandings => 'Standings';

  @override
  String get navCareers => 'Karera Ko';

  @override
  String get settingsTitle => 'MGA SETTING';

  @override
  String get settingsSoundHapticsTitle => 'Tunog at haptics';

  @override
  String get settingsSoundHapticsBlurb =>
      'Vibration at maikling tunog sa goal, kick-off at full-time.';

  @override
  String get settingsLanguageTitle => 'Wika';

  @override
  String get settingsLanguageBlurb =>
      'Piliin ang wika ng app, o sundin ang device mo.';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get matchPreviewAllMeetings => 'Lahat ng pagkikita';

  @override
  String get recordsMeetings => 'MGA PAGKIKITA';

  @override
  String get recordsLegends => 'MGA ALAMAT';

  @override
  String get recordsAllTimeXi => 'ALL-TIME XI';

  @override
  String get recordsHallOfFame => 'HALL OF FAME';

  @override
  String get recordsAllTimeWorld => 'ALL-TIME SA MUNDO';

  @override
  String get recordsAllTimeTopScorers =>
      'PINAKAMAGALING NA SCORER SA LAHAT NG PANAHON';

  @override
  String get recordsMostCapped => 'PINAKAMARAMING CAPS';

  @override
  String get recordsMostWcStarts => 'PINAKAMARAMING STARTS SA MUNDO';

  @override
  String get recordsMostTournaments => 'PINAKAMARAMING NALAKUANG TORNEO';

  @override
  String get recordsRecordBook => 'RECORD BOOK';

  @override
  String get recordsHeadToHead => 'HEAD TO HEAD';

  @override
  String get recordsFiercestRival => 'PINAKAMATINDING KARIBAL';

  @override
  String get recordsMostCaps => 'PINAKAMARAMING CAPS';

  @override
  String get recordsTopScorers => 'MGA TOP SCORER';

  @override
  String get recordsMostAssists => 'PINAKAMARAMING ASSIST';

  @override
  String get recordsYourRecord => 'ANG RECORD MO';

  @override
  String get callUpHome => 'HOME';

  @override
  String get callUpAway => 'AWAY';

  @override
  String get recordsHome => 'HOME';

  @override
  String get recordsAway => 'AWAY';

  @override
  String get recordsActive => 'ACTIVE';

  @override
  String get recordsStillActive => 'Naglalaro pa';

  @override
  String get recordsAvg => 'avg';

  @override
  String get recordsSelect => 'Pumili';

  @override
  String get recordsVs => 'vs';

  @override
  String get recordsDraws => 'Tabla';

  @override
  String get recordsGoalsLabel => 'Goal';

  @override
  String get recordsBestFinish => 'Pinakamataas na pagtatapos';

  @override
  String get recordsNoFinalsYet => 'Wala pang sinalihang finals';

  @override
  String get recordsLongestUnbeaten => 'Pinakamahabang walang talo';

  @override
  String get recordsBiggestWin => 'Pinakamalaking panalo';

  @override
  String get recordsSeeAllMeetings => 'Tingnan lahat ng pagkikita';

  @override
  String get recordsSaveNotFound => 'Hindi nahanap ang save.';

  @override
  String get recordsNoMatches => 'Walang tugma.';

  @override
  String get recordsSearchPlayerOrNation => 'Maghanap ng manlalaro o bansa';

  @override
  String get recordsSearchNation => 'Maghanap ng bansa';

  @override
  String get recordsPickTwoDifferent => 'Pumili ng dalawang magkaibang bansa.';

  @override
  String get recordsPlayToBuildRecord =>
      'Maglaro ng ilang laro at dito mabubuo ang record mo laban sa bawat kalaban.';

  @override
  String get recordsTapOpponent => 'I-tap ang kalaban para sa buong detalye.';

  @override
  String get recordsEdgeUpperHand => 'Nasa iyo ang lamang';

  @override
  String get recordsEdgeTheirNumber => 'Sila ang may hawak sa iyo';

  @override
  String get recordsEdgeEven => 'Patas ang bilangan';

  @override
  String get recordsAllTimeWorldSubtitle =>
      'Mga scorer at pinakamaraming caps sa mundo, bawat bansa';

  @override
  String get recordsHeadToHeadSubtitle =>
      'Ihambing ang all-time record ng alinmang dalawang bansa';

  @override
  String get recordsLegendsSubtitle => 'All-time XI at hall of fame';

  @override
  String get recordsUnitGoals => 'goal';

  @override
  String get recordsUnitCaps => 'caps';

  @override
  String get recordsUnitStarts => 'starts';

  @override
  String get recordsUnitCups => 'torneo';

  @override
  String get recordsUnitAssists => 'assist';

  @override
  String recordsCapsCount(int count) {
    return '$count caps';
  }

  @override
  String recordsGoalsCount(int count) {
    return '$count goal';
  }

  @override
  String recordsAssistsCount(int count) {
    return '$count assist';
  }

  @override
  String recordsMotmCount(int count) {
    return '$count MOTM';
  }

  @override
  String recordsMatchesCount(int count) {
    return '$count laro';
  }

  @override
  String recordsMeetingsCount(int count) {
    return '$count pagkikita';
  }

  @override
  String recordsCodeWins(String code) {
    return 'Panalo ng $code';
  }

  @override
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses) {
    return '$meetings pagkikita · ${wins}P ${draws}T ${losses}N';
  }

  @override
  String recordsWdl(int wins, int draws, int losses) {
    return '${wins}P ${draws}T ${losses}N';
  }

  @override
  String recordsRivalLine(int meetings, String record, String edge) {
    return '$meetings pagkikita · $record · $edge';
  }

  @override
  String recordsNeverMet(String a, String b) {
    return 'Hindi pa nagkaharap ang $a at $b sa save na ito.';
  }

  @override
  String tacticsSentOffNote(String names) {
    return 'Na-sent off: $names. Walang kapalit, kaya kulang kayo ng isang manlalaro.';
  }

  @override
  String tacticsNeedFitPlayers(int required, int have) {
    return 'Kailangan ng $required na available ($have ang fit)';
  }

  @override
  String tacticsMissesOfCamp(int missed, int total) {
    return 'Liban ng $missed/$total';
  }

  @override
  String get tacticsOutForWholeCamp => 'Wala siya sa buong call-up na ito';

  @override
  String get rankingCentreOnMe => 'Itutok sa bansa ko';

  @override
  String get recordsAfterExtraTime => 'a.e.t.';

  @override
  String recordsOnPenalties(int a, int b) {
    return '$a–$b pens';
  }

  @override
  String recordsVersus(String a, String b) {
    return '$a vs $b';
  }

  @override
  String recordsPlayedScore(int played, int gf, int ga) {
    return '$played laro · $gf–$ga';
  }

  @override
  String recordsBiggestWinValue(int gf, int ga, String opp) {
    return '$gf–$ga laban sa $opp';
  }

  @override
  String recordsCouldNotLoad(String error) {
    return 'Hindi ma-load.\n$error';
  }

  @override
  String recordsCouldNotLoadLegends(String error) {
    return 'Hindi ma-load ang mga alamat.\n$error';
  }

  @override
  String recordsCouldNotLoadRecords(String error) {
    return 'Hindi ma-load ang mga record.\n$error';
  }

  @override
  String recordsCouldNotLoadNations(String error) {
    return 'Hindi ma-load ang mga bansa.\n$error';
  }

  @override
  String recordsCouldNotLoadYourRecord(String error) {
    return 'Hindi ma-load ang record mo.\n$error';
  }

  @override
  String recordsCouldNotLoadRecord(String error) {
    return 'Hindi ma-load ang record.\n$error';
  }

  @override
  String recordsNoLegends(String nation) {
    return 'Wala pang alamat. Tapusin ang ilang kampanya at lilitaw dito ang mga dakila ng $nation.';
  }

  @override
  String recordsGreatestSide(String nation) {
    return 'Ang pinakamahusay na koponan na kayang buuin ng $nation.';
  }

  @override
  String get recordsNoWorldHistory =>
      'Wala pang kasaysayan ang mundo. Tapusin ang ilang kampanya at lilitaw dito ang mga dakila sa lahat ng panahon.';

  @override
  String recordsPlayToWriteHistory(String nation) {
    return 'Maglaro ng ilang laro para simulang isulat ang kasaysayan ng $nation.';
  }

  @override
  String get tacticsLineGk => 'GK';

  @override
  String get tacticsLineDef => 'DEF';

  @override
  String get tacticsLineMid => 'MID';

  @override
  String get tacticsLineFwd => 'FWD';

  @override
  String get tacticsGoalkeepers => 'MGA GOALKEEPER';

  @override
  String get tacticsDefenders => 'MGA DEFENDER';

  @override
  String get tacticsMidfielders => 'MGA MIDFIELDER';

  @override
  String get tacticsForwards => 'MGA FORWARD';

  @override
  String get tacticsCallUpsTitle => 'MGA CALL-UP';

  @override
  String tacticsPickAtLeastPlayers(int min) {
    return 'Pumili ng hindi bababa sa $min manlalaro.';
  }

  @override
  String tacticsCouldNotLoadSquad(String error) {
    return 'Hindi ma-load ang squad.\n$error';
  }

  @override
  String get tacticsNoSquad => 'Walang squad.';

  @override
  String tacticsSquadCount(int count, int max) {
    return 'SQUAD · $count/$max';
  }

  @override
  String tacticsMinMax(int min, int max) {
    return 'Min $min · Max $max';
  }

  @override
  String get tacticsBestQuality => 'Pinakamahusay';

  @override
  String get tacticsPreviousSquad => 'Dating squad';

  @override
  String get tacticsSquadLockedBack => 'Bumalik (naka-lock ang squad)';

  @override
  String get tacticsConfirmSquad => 'Kumpirmahin ang squad';

  @override
  String tacticsSquadFullMax(int max) {
    return 'Puno na ang squad (max $max)';
  }

  @override
  String get tacticsSquadLocked => 'NAKA-LOCK ANG SQUAD';

  @override
  String get tacticsNominationOpen => 'BUKAS ANG NOMINASYON. PUMILI NG SQUAD';

  @override
  String get tacticsSquadFixedBlurb =>
      'Nakatakda na ang squad na ito para sa mga laro sa ibaba. Pumili ulit bago ang susunod na nomination window.';

  @override
  String get tacticsSquadWillPlayBlurb =>
      'Ang squad na ito ang maglalaro sa mga laro sa ibaba.';

  @override
  String get tacticsUnknown => 'Hindi kilala';

  @override
  String tacticsAgeValue(int age, String value) {
    return 'Edad $age · $value';
  }

  @override
  String get tacticsFatigueExhausted => 'Ubos na';

  @override
  String get tacticsFatigueTired => 'Pagod';

  @override
  String get tacticsFatigueMatchLegs => 'Pagod sa laro';

  @override
  String tacticsTooManySubs(int max) {
    return 'Sobra ang pagpapalit (max $max).';
  }

  @override
  String tacticsMinuteTitle(int minute) {
    return 'TAKTIKA · $minute\'';
  }

  @override
  String get tacticsApply => 'ILAPAT';

  @override
  String get tacticsTabLineupSubs => 'LINEUP AT PAMALIT';

  @override
  String get tacticsTabTactics => 'TAKTIKA';

  @override
  String get squadLineKeepers => 'MGA KEEPER';

  @override
  String get squadLineDefenders => 'DEPENSA';

  @override
  String get squadLineMidfielders => 'MIDFIELD';

  @override
  String get squadLineForwards => 'ATAKE';

  @override
  String get squadStatXiRating => 'Rating ng XI';

  @override
  String get squadStatAvgAge => 'Avg na edad';

  @override
  String get squadStatSize => 'Squad';

  @override
  String get squadStatUnavailable => 'Wala';

  @override
  String get squadDepthTitle => 'LALIM BAWAT LINYA';

  @override
  String squadAgeShort(int age) {
    return '${age}t';
  }

  @override
  String get tacticsTabOtherPositions => 'IBANG POSISYON';

  @override
  String get tacticsOutOfPositionNote => 'Wala sa natural na posisyon';

  @override
  String get tacticsNobodyElse => 'Wala nang ibang masusubukan dito.';

  @override
  String get tacticsPickSomebodyFirst =>
      'Piliin kung sino ang lalabas at lilitaw dito ang iba pang nasa bench, kasama ang rating nila sa posisyong ito.';

  @override
  String get tacticsTabSuitable => 'ANGKOP';

  @override
  String get tacticsTabOnPitch => 'NASA FIELD';

  @override
  String tacticsSectionSuitable(int count) {
    return 'ANGKOP · $count';
  }

  @override
  String get tacticsNobodySuits =>
      'Walang natural na angkop sa posisyong ito sa bench, kaya ipinapakita ang lahat.';

  @override
  String tacticsSectionOnPitch(int count, int max) {
    return 'NASA FIELD · $count/$max';
  }

  @override
  String tacticsSectionAvailable(int count) {
    return 'AVAILABLE · $count';
  }

  @override
  String get tacticsRowStarted => 'Nagsimula';

  @override
  String tacticsRowCameOn(int minute) {
    return 'Pumasok sa $minute\'';
  }

  @override
  String get tacticsRowSubstitute => 'Pumasok';

  @override
  String get tacticsEnergyLabel => 'ENERGY';

  @override
  String tacticsPickReplacementFor(String name) {
    return 'I-tap ang kapalit ni $name, o i-tap ulit siya para kanselahin.';
  }

  @override
  String get tacticsSlotLostToRedCard =>
      'Dahil sa red card, nawala ang puwestong ito. I-drag ang isang kakampi rito para ilipat ang butas.';

  @override
  String get tacticsSentOffShort => 'SENT OFF';

  @override
  String tacticsSubsUsed(int used, int max) {
    return 'PAMALIT · $used/$max';
  }

  @override
  String get tacticsDragSubOn =>
      'I-tap ang manlalaro sa field para palabasin siya, o hawakan at i-drag ang pamalit papunta sa kaniya.';

  @override
  String get tacticsNoSubs => 'Walang available na pamalit.';

  @override
  String get tacticsChooseShape => 'PUMILI NG HUGIS';

  @override
  String get tacticsFormation => 'FORMATION';

  @override
  String get tacticsInstructions => 'MGA INSTRUKSIYON';

  @override
  String get tacticsDrilling => 'SANAY';

  @override
  String get tacticsDrillingUnplayed => 'HINDI PA NILALARO';

  @override
  String get tacticsDrillingNew => 'BAGO';

  @override
  String get tacticsDrillingSettling => 'NAKAKASANAY';

  @override
  String get tacticsDrillingDrilled => 'SANAY NA SANAY';

  @override
  String get tacticsInstrMentality => 'Mentalidad';

  @override
  String get tacticsInstrDefensive => 'Depensibo';

  @override
  String get tacticsInstrAttacking => 'Atakante';

  @override
  String get tacticsInstrPressing => 'Pressing';

  @override
  String get tacticsInstrLowBlock => 'Low block';

  @override
  String get tacticsInstrHighPress => 'High press';

  @override
  String get tacticsInstrTempo => 'Tempo';

  @override
  String get tacticsInstrPatient => 'Matiyaga';

  @override
  String get tacticsInstrFast => 'Mabilis';

  @override
  String get tacticsInstrWidth => 'Luwang';

  @override
  String get tacticsInstrNarrow => 'Makitid';

  @override
  String get tacticsInstrWide => 'Malawak';

  @override
  String get tacticsInstrDefLine => 'Def. line';

  @override
  String get tacticsInstrDefensiveLine => 'Defensive line';

  @override
  String get tacticsInstrDeep => 'Malalim';

  @override
  String get tacticsInstrHigh => 'Mataas';

  @override
  String get tacticsInstrDirectness => 'Pagkadiretso';

  @override
  String get tacticsInstrPossession => 'Possession';

  @override
  String get tacticsInstrDirect => 'Diretso';

  @override
  String get tacticsPickGoalkeeper => 'PUMILI NG GOALKEEPER';

  @override
  String get tacticsPickLeftBack => 'PUMILI NG LEFT BACK';

  @override
  String get tacticsPickCentreBack => 'PUMILI NG CENTER BACK';

  @override
  String get tacticsPickRightBack => 'PUMILI NG RIGHT BACK';

  @override
  String get tacticsPickDefensiveMid => 'PUMILI NG DEFENSIVE MID';

  @override
  String get tacticsPickCentralMid => 'PUMILI NG CENTRAL MID';

  @override
  String get tacticsPickAttackingMid => 'PUMILI NG ATTACKING MID';

  @override
  String get tacticsPickLeftMid => 'PUMILI NG LEFT MID';

  @override
  String get tacticsPickRightMid => 'PUMILI NG RIGHT MID';

  @override
  String get tacticsPickLeftWing => 'PUMILI NG LEFT WINGER';

  @override
  String get tacticsPickRightWing => 'PUMILI NG RIGHT WINGER';

  @override
  String get tacticsPickStriker => 'PUMILI NG STRIKER';

  @override
  String tacticsRoleOutOfPosition(String role) {
    return '$role · wala sa posisyon';
  }

  @override
  String tacticsAgeOnly(int age) {
    return 'Edad $age';
  }

  @override
  String tacticsRoleAge(String role, int age) {
    return '$role · Edad $age';
  }

  @override
  String get tacticsOn => 'NASA FIELD';

  @override
  String get tacticsSquad => 'SQUAD';

  @override
  String get tacticsTabLineup => 'LINEUP';

  @override
  String get tacticsTabInstructions => 'MGA INSTRUKSIYON';

  @override
  String get tacticsTabRoles => 'MGA ROLE';

  @override
  String get tacticsTabSetPieces => 'SET PIECE';

  @override
  String get tacticsTabRolesSetPieces => 'ROLE AT SET PIECE';

  @override
  String get tacticsRolesSetPiecesBlurb =>
      'Bigyan ng role ang bawat starter. I-tap ang badge ng penalty (⚽) o free-kick (▲) para itakda ang taker mo.';

  @override
  String get tacticsTooltipCallUps => 'Mga call-up';

  @override
  String get tacticsTooltipPresets => 'Mga preset ng taktika';

  @override
  String get tacticsTooltipInstructions => 'Mga instruksiyon';

  @override
  String get tacticsNoTacticSet => 'Walang nakatakdang taktika.';

  @override
  String tacticsReplaceStarters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PALITAN ANG $count STARTER',
      one: 'PALITAN ANG $count STARTER',
    );
    return '$_temp0';
  }

  @override
  String tacticsPlayerOut(String name, String reason) {
    return '$name: $reason';
  }

  @override
  String get tacticsOut => 'Wala';

  @override
  String get tacticsTapSpotReplace =>
      'I-tap ang puwesto nila sa field para pumili ng kapalit.';

  @override
  String get tacticsTapOrDrag =>
      'I-tap ang manlalaro para palitan siya, o hawakan at i-drag para ilipat.';

  @override
  String get tacticsPlayerRoles => 'MGA ROLE NG MANLALARO';

  @override
  String get tacticsRolesBlurb =>
      'Bigyan ng trabaho ang manlalaro: poacher, playmaker, target man. Nakaaapekto kung sino ang nag-i-score at gumagawa ng tsansa.';

  @override
  String get tacticsSetPieceTakers => 'MGA SET-PIECE TAKER';

  @override
  String get tacticsSetPieceBlurb =>
      'Sino ang kukuha ng penalty at dead ball, o ipaubaya sa pinakaangkop na manlalaro.';

  @override
  String get tacticsTakerAuto => 'Awtomatiko';

  @override
  String get tacticsTakerQuickPick => 'Gamitin ang pinakamahuhusay';

  @override
  String get tacticsPenalties => 'Mga penalty';

  @override
  String get tacticsCornersFreeKicks => 'Mga corner at free kick';

  @override
  String get tacticsSkillFin => 'FIN';

  @override
  String get tacticsSkillPas => 'PAS';

  @override
  String tacticsRolePlayer(String name) {
    return 'ROLE · $name';
  }

  @override
  String get tacticsPenaltyTaker => 'PENALTY TAKER';

  @override
  String get tacticsCornerFreeKickTaker => 'CORNER AT FREE-KICK TAKER';

  @override
  String get tacticsAutomatic => 'Awtomatiko';

  @override
  String get tacticsLetBestSuited =>
      'Hayaang ang pinakaangkop na manlalaro ang kumuha.';

  @override
  String get tacticsInXi => 'SA XI';

  @override
  String get tacticsTeamInstructions => 'MGA INSTRUKSIYON NG KOPONAN';

  @override
  String get tacticsTeamInstructionsBlurb =>
      'Itakda kung paano maglaro ang koponan mo. Bawat dial ay may epekto sa buong koponan.';

  @override
  String tacticsSavedPreset(String name) {
    return 'Na-save ang “$name”';
  }

  @override
  String tacticsAppliedPreset(String name) {
    return 'Nailapat ang “$name”';
  }

  @override
  String get tacticsTacticPresets => 'MGA PRESET NG TAKTIKA';

  @override
  String get tacticsPresetsBlurb =>
      'I-save ang hugis na ito bilang magagamit na estilo, o ilapat ang dati mong na-save.';

  @override
  String get tacticsSaveCurrentTactic => 'I-save ang kasalukuyang taktika';

  @override
  String tacticsCouldNotLoadPresets(String error) {
    return 'Hindi ma-load ang mga preset.\n$error';
  }

  @override
  String get tacticsNoPresetsYet =>
      'Wala pang preset. I-tap ang “I-save ang kasalukuyang taktika” para itabi ang setup na ito bilang magagamit na estilo.';

  @override
  String get tacticsNameThisTactic => 'Pangalanan ang taktikang ito';

  @override
  String get tacticsNameHint => 'hal. High press 4-3-3';

  @override
  String get tacticsCancel => 'Kanselahin';

  @override
  String get tacticsSave => 'I-save';

  @override
  String get tacticsTapToAssign => 'I-tap para magtakda';

  @override
  String get tacticsHoldDragSub =>
      'Hawakan ang pamalit, saka i-drag sa isang manlalaro para ipasok siya.';

  @override
  String get hubContinue => 'Magpatuloy';

  @override
  String get hubBrackets => 'Bracket';

  @override
  String hubCouldNotLoad(String error) {
    return 'Hindi ma-load.\n$error';
  }

  @override
  String hubCouldNotLoadFinances(String error) {
    return 'Hindi ma-load ang pananalapi.\n$error';
  }

  @override
  String hubCouldNotLoadSave(String error) {
    return 'Hindi ma-load ang save.\n$error';
  }

  @override
  String get hubSaveNotFound => 'Hindi nahanap ang save.';

  @override
  String get hubUnknown => 'Hindi kilala';

  @override
  String hubWorldChampionsYear(int year) {
    return 'KAMPEON NG MUNDO $year';
  }

  @override
  String get hubCycleComplete => 'Tapos na ang cycle.';

  @override
  String get hubYourJob => 'ANG TRABAHO MO';

  @override
  String get hubStayProject => 'Manatili at ipagpatuloy ang proyekto mo';

  @override
  String get hubChooseNextJob => 'PUMILI NG SUSUNOD NA TRABAHO';

  @override
  String get hubOffersOnTable => 'MGA ALOK NA NASA HARAP MO';

  @override
  String hubOfferSubtitle(String tier, int position) {
    return '$tier · #$position sa mundo';
  }

  @override
  String hubContinueWith(String nation) {
    return 'Magpatuloy sa $nation';
  }

  @override
  String get hubYourNation => 'iyong bansa';

  @override
  String get hubTakeTheJob => 'Tanggapin ang trabaho';

  @override
  String get hubFederationFinances => 'PANANALAPI NG PEDERASYON';

  @override
  String get hubBudgetIntro =>
      'Ang una mong gawain sa susunod na cycle ay itakda ang badyet ng pederasyon at hatiin ito sa mga departamento.';

  @override
  String get hubStarting => 'Nagsisimula…';

  @override
  String get hubBeginNextCycle => 'Simulan ang susunod na cycle';

  @override
  String get hubContinueCareer => 'Ipagpatuloy ang karera mo';

  @override
  String get hubBackToSaves => 'Bumalik sa mga save mo';

  @override
  String get hubOpeningBalance => 'Panimulang balanse';

  @override
  String get hubCentralFunding => 'Sentral na pondo';

  @override
  String get hubPrizeMoney => 'Premyong pera';

  @override
  String get hubCommercialReturn => 'Komersyal na kita';

  @override
  String get hubAvailableToInvest => 'Magagamit na puhunan';

  @override
  String hubReputation(String label, int rep) {
    return 'Reputasyon: $label ($rep)';
  }

  @override
  String get hubNationalHero => 'Pambansang bayani';

  @override
  String get hubFinal => 'Final';

  @override
  String get hubStageRoundOf32 => 'Round of 32';

  @override
  String get hubStageThirdPlace => 'Laro para sa ikatlong puwesto';

  @override
  String get hubEventAdvanceWorld => 'Pausarin ang mundo';

  @override
  String hubEventStartCycle(int year) {
    return 'Simulan ang cycle ng $year';
  }

  @override
  String hubEventWorldChampions(String nation) {
    return 'Kampeon ng mundo ang $nation';
  }

  @override
  String get hubEventSetBudget => 'Itakda ang badyet ng pederasyon';

  @override
  String get hubEventSetBudgetSub =>
      'Hatiin ang pondo ng cycle na ito bago magsimula ang season';

  @override
  String get hubEventNaturalization => 'Suriin ang alok ng naturalisasyon';

  @override
  String get hubEventNaturalizationSub =>
      'May dayuhang manlalaro na gustong lumipat ng katapatan sa iyo';

  @override
  String get hubEventCampaignVerdict =>
      'Tapos na ang kampanya: tingnan ang hatol';

  @override
  String get hubEventCampaignComplete => 'Tapos na ang kampanya';

  @override
  String get hubEventIntercontinentalPlayoff => 'Ang intercontinental play-off';

  @override
  String get hubEventWatchWcDraw => 'Panoorin ang draw ng Kampeonato ng Mundo';

  @override
  String get hubEventWorldCupHere => 'Narito na ang Kampeonato ng Mundo';

  @override
  String get hubEventWatchFinalsDraw => 'Panoorin ang draw ng finals';

  @override
  String get hubEventFinalsHere => 'Narito na ang finals';

  @override
  String get hubEventPlayWcRound =>
      'Laruin ang susunod na round ng Kampeonato ng Mundo';

  @override
  String hubEventPlayCupMatch(String cup) {
    return 'Laruin ang susunod na laro sa $cup';
  }

  @override
  String get hubEventPlayNationsCupMatch =>
      'Laruin ang susunod na laro sa Nations Cup';

  @override
  String get hubEventWatchNationsCupDraw => 'Panoorin ang draw ng Nations Cup';

  @override
  String get hubEventWatchHostSelection => 'Panoorin ang pagpili ng host';

  @override
  String get hubEventWatchQualifyingDraw =>
      'Panoorin ang draw ng kwalipikasyon';

  @override
  String get hubEventWatchWcHostSelection =>
      'Panoorin ang pagpili ng host ng Kampeonato ng Mundo';

  @override
  String get hubEventWatchWcQualifyingDraw =>
      'Panoorin ang draw ng kwalipikasyon para sa Kampeonato ng Mundo';

  @override
  String get hubEventArrangeFriendlies => 'Mag-ayos ng mga friendly';

  @override
  String hubEventFriendliesSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hindi mo pa napupunan ang $count bukas mong friendly window',
      one: 'Hindi mo pa napupunan ang bukas mong friendly window',
    );
    return '$_temp0';
  }

  @override
  String get hubEventReshapeXi => 'Ayusin muli ang panimulang XI mo';

  @override
  String hubEventReshapeOutSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count sa XI mo ang wala (suspendido o injured). Pumili ng mga kapalit',
      one: '1 sa XI mo ang wala (suspendido o injured). Pumili ng kapalit',
    );
    return '$_temp0';
  }

  @override
  String hubEventReshapeShortSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kulang ang panimulang XI mo. Punan ang mga bakanteng puwesto',
      one: 'Kulang ang panimulang XI mo. Punan ang bakanteng puwesto',
    );
    return '$_temp0';
  }

  @override
  String hubEventPlayOpponent(String opponent) {
    return 'Laruin ang $opponent';
  }

  @override
  String get hubEventContinentalFinalsFallback => 'ang kontinental na finals';

  @override
  String get hubCallUpFriendlies => 'Ihayag ang squad para sa mga friendly';

  @override
  String get hubCallUpRequalify =>
      'Ihayag muli ang squad para sa kwalipikasyon';

  @override
  String get hubCallUpWorldCup =>
      'Ihayag ang squad para sa Kampeonato ng Mundo';

  @override
  String get hubCallUpFinals => 'Ihayag ang squad para sa finals';

  @override
  String get hubCallUpNationsCup => 'Ihayag ang squad para sa Nations Cup';

  @override
  String get hubCallUpQualifying => 'Ihayag ang squad para sa kwalipikasyon';

  @override
  String get hubCallUpGeneric => 'Ihayag ang squad';

  @override
  String get hubHost => 'Host';

  @override
  String get hubGoldenBoot => 'Golden Boot';

  @override
  String hubGoldenBootValue(String name, int goals) {
    return '$name · $goals goal';
  }

  @override
  String get hubPens => '(pens)';

  @override
  String get hubNationalHub => 'PUNONG-TANGGAPAN NG PEDERASYON';

  @override
  String get hubMessages => 'Mga mensahe';

  @override
  String get hubWorldChampions => 'KAMPEON NG MUNDO';

  @override
  String get hubViewBracket => 'Tingnan ang bracket ›';

  @override
  String get hubBoardDelighted => 'Tuwang-tuwa';

  @override
  String get hubBoardPleased => 'Kuntento';

  @override
  String get hubBoardExpectingMore => 'Umaasa ng higit pa';

  @override
  String get hubBoardConcerned => 'Nag-aalala';

  @override
  String get hubBoardJobAtRisk => 'Nanganganib ang trabaho';

  @override
  String get hubBoard => 'BOARD';

  @override
  String hubBoardObjective(String label) {
    return 'Layunin ng board: $label';
  }

  @override
  String hubObjectiveMet(String result) {
    return 'NAABOT · $result';
  }

  @override
  String hubObjectiveMissed(String result) {
    return 'HINDI NAABOT · $result';
  }

  @override
  String get hubNoMoreFixtures => 'Wala nang laro sa cycle na ito.';

  @override
  String get hubVs => 'VS';

  @override
  String hubWorldRank(int rank) {
    return '#$rank';
  }

  @override
  String get hubWorldRankLabel => 'Pandaigdigang ranking';

  @override
  String get hubSquadStatus => 'KALAGAYAN NG SQUAD';

  @override
  String hubPlayers(int count) {
    return '$count manlalaro';
  }

  @override
  String get hubAvgRating => 'Avg rating';

  @override
  String get hubMorale => 'Morale';

  @override
  String get hubManageTeam => 'Pamahalaan ang Koponan';

  @override
  String get hubGroupsToBeDrawn =>
      'Hindi pa na-draw ang mga grupo. Panoorin ang draw para malaman.';

  @override
  String hubGroupName(String name) {
    return 'GRUPO $name';
  }

  @override
  String get hubTblTeam => 'KOPONAN';

  @override
  String get hubTblP => 'L';

  @override
  String get hubTblGd => 'DG';

  @override
  String get hubTblPts => 'K';

  @override
  String get homeSettings => 'Mga setting';

  @override
  String get homeLeadTheNation => 'PAMUNUAN ANG BANSA';

  @override
  String get homeYourNation => 'iyong bansa';

  @override
  String get homeNewGame => 'Bagong Laro';

  @override
  String get homeAllSaves => 'Lahat ng save';

  @override
  String get homeLoadGame => 'I-load ang laro';

  @override
  String get homeContinue => 'MAGPATULOY';

  @override
  String homeRoadToWorldCup(String date, int year) {
    return '$date · Patungo sa Kampeonato ng Mundo $year';
  }

  @override
  String get careerManageSaves => 'Pamahalaan ang mga save';

  @override
  String get careerNewGameTitle => 'BAGONG LARO';

  @override
  String careerCouldNotLoadNation(String error) {
    return 'Hindi ma-load ang bansa.\n$error';
  }

  @override
  String get careerNationNotFound => 'Hindi nahanap ang bansa.';

  @override
  String careerWorldRankNum(int rank) {
    return 'PANDAIGDIGANG RANK #$rank';
  }

  @override
  String get careerManagerName => 'Pangalan ng manager';

  @override
  String get careerManagerNameHint => 'hal. Alex Ferguson';

  @override
  String get careerBeginsBlurb =>
      'Magsisimula ang karera mo sa Setyembre 2026, patungo sa Kampeonato ng Mundo 2030.';

  @override
  String get careerFreeCycleNote =>
      'Libre para sa isang buong apat-na-taong cycle: kwalipikasyon, ang kampeonato ng kontinente mo at ang Kampeonato ng Mundo, sa dalawang save. Pagkatapos nito, isang bayad lang ang mag-a-unlock ng walang katapusang cycle.';

  @override
  String get careerStartCareer => 'Simulan ang Karera';

  @override
  String get careersTitle => 'MGA KARERA';

  @override
  String get careerManagerCareer => 'Karera bilang manager';

  @override
  String get careerManagerCareerSubtitle =>
      'Bawat cycle na hinawakan mo at ang kabuuang record mo';

  @override
  String get careerSummaryTitle => 'Buod ng karera';

  @override
  String get careerSummarySubtitle =>
      'Ang trophy cabinet mo at record bilang manager';

  @override
  String get careerAchievements => 'Mga Tagumpay';

  @override
  String get careerAchievementsSubtitle =>
      'Mga milestone, titulo at kasiyahan ng board';

  @override
  String get careerChallenges => 'Mga Hamon';

  @override
  String get careerChallengesSubtitle =>
      'Matitinding pagsubok sa buong karera na dapat harapin';

  @override
  String get careerTeamRecords => 'Mga record ng koponan';

  @override
  String get careerTeamRecordsSubtitle =>
      'Mga pinakamahusay na scorer at pinakamaraming laro sa lahat ng panahon';

  @override
  String get careerMyMatches => 'Mga laro ko';

  @override
  String get careerMyMatchesSubtitle => 'Bawat resulta at paparating na laro';

  @override
  String get careerTitle => 'KARERA';

  @override
  String careerCouldNotLoadCareer(String error) {
    return 'Hindi ma-load ang karera.\n$error';
  }

  @override
  String get careerNoCareer => 'Walang karera.';

  @override
  String get careerTrophyCabinet => 'TROPHY CABINET';

  @override
  String get careerTournamentHistory => 'KASAYSAYAN NG MGA TORNEO';

  @override
  String get careerNoTournamentsYet => 'Wala pang natapos na torneo.';

  @override
  String get careerTeamFallback => 'Koponan';

  @override
  String careerWorldNum(int rank) {
    return 'MUNDO #$rank';
  }

  @override
  String careerPointsNum(int points) {
    return '$points PTS';
  }

  @override
  String careerSeasonNum(int season) {
    return 'SEASON $season';
  }

  @override
  String get careerStatPlayedShort => 'L';

  @override
  String get careerStatsHeading => 'SA MGA NUMERO';

  @override
  String get careerStatsWinRate => 'Win rate';

  @override
  String get careerStatsGoalsFor => 'Mga goal na naipasok';

  @override
  String get careerStatsGoalsAgainst => 'Mga goal na pumasok';

  @override
  String get careerStatsGoalDiff => 'Goal diff.';

  @override
  String get careerStatsCleanSheets => 'Clean sheet';

  @override
  String get careerStatsBiggestWin => 'Pinakamalaking panalo';

  @override
  String get careerStatsWinStreak => 'Sunod na panalo';

  @override
  String get careerStatsUnbeaten => 'Larong walang talo';

  @override
  String get careerStatsShootouts => 'Shootout';

  @override
  String get careerStatsHatTricks => 'Hat-trick';

  @override
  String get careerStatsMotms => 'Man of the match';

  @override
  String get careerStatsBestRating => 'Pinakamataas na rating';

  @override
  String get careerStatWonShort => 'P';

  @override
  String get careerStatDrawnShort => 'T';

  @override
  String get careerStatLostShort => 'N';

  @override
  String get careerStatGoalsForShort => 'GF';

  @override
  String get careerStatGoalsAgainstShort => 'GA';

  @override
  String get careerStatGoalDiffShort => 'DG';

  @override
  String get careerNoSilverware => 'Wala pang tropeo. Manalo ka na ng isa.';

  @override
  String get careerMedalGold => 'GINTO';

  @override
  String get careerMedalSilver => 'PILAK';

  @override
  String get careerMedalBronze => 'TANSO';

  @override
  String careerWinnersName(String name) {
    return 'Kampeon: $name';
  }

  @override
  String get careerSavesTitle => 'MGA SAVE';

  @override
  String careerCouldNotLoadSaves(String error) {
    return 'Hindi ma-load ang mga save.\n$error';
  }

  @override
  String careerSlotsCount(int used, int limit) {
    return 'MGA SLOT  $used/$limit';
  }

  @override
  String get careerThisSave => 'itong save';

  @override
  String get careerSlotsFull => 'Puno na ang mga slot';

  @override
  String careerSlotsUsed(int used) {
    return 'MGA SLOT  $used';
  }

  @override
  String get careerSlotsUnlockMore => 'I-unlock ang higit pang save';

  @override
  String get careerSlotsKeepNote =>
      'Lahat ng save na mayroon ka na ay mapaglalaruan pa rin. Ang bago lang ang nangangailangan ng unlock.';

  @override
  String get careerNewGame => 'Bagong Laro';

  @override
  String get careerDeleteSaveTitle => 'Burahin ang save?';

  @override
  String careerDeleteSaveBody(String label) {
    return 'Permanente nitong buburahin ang karera mo sa $label.';
  }

  @override
  String get careerCancel => 'Kanselahin';

  @override
  String get careerDelete => 'Burahin';

  @override
  String get careerNoSavesYet =>
      'Wala pang save.\nMagsimula ng bagong laro para pamunuan ang isang bansa.';

  @override
  String get careerUnknownNation => 'Hindi kilala';

  @override
  String careerPlayedMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String careerPlayedHours(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String careerLastPlayed(String when) {
    return 'Huling nilaro: $when';
  }

  @override
  String get careerJustNow => 'ngayon lang';

  @override
  String get careerYesterday => 'kahapon';

  @override
  String careerMinutesAgo(int n) {
    return '${n}m ang nakalipas';
  }

  @override
  String careerHoursAgo(int n) {
    return '${n}h ang nakalipas';
  }

  @override
  String careerDaysAgo(int n) {
    return '${n}d ang nakalipas';
  }

  @override
  String careerRoadToWorldCup(int year) {
    return 'Daan patungo sa Kampeonato ng Mundo $year';
  }

  @override
  String get careerManagerCareerTitle => 'KARERA BILANG MANAGER';

  @override
  String careerCouldNotLoad(String error) {
    return 'Hindi ma-load.\n$error';
  }

  @override
  String get careerCycleByCycle => 'BAWAT CYCLE';

  @override
  String careerCyclesNationsLed(int cycles, int nations) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cycle',
      one: '1 cycle',
    );
    String _temp1 = intl.Intl.pluralLogic(
      nations,
      locale: localeName,
      other: '$nations bansang pinamunuan',
      one: '1 bansang pinamunuan',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get careerStatTitles => 'Mga titulo';

  @override
  String get careerStatPlayed => 'Laro';

  @override
  String get careerStatWon => 'Panalo';

  @override
  String get careerStatDrawn => 'Tabla';

  @override
  String get careerStatLost => 'Talo';

  @override
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  ) {
    return 'Mga goal $goalsFor–$goalsAgainst  ($gd)  ·  Win rate $winRate%';
  }

  @override
  String get careerRecordResults => 'MGA RECORD NA RESULTA';

  @override
  String get careerBestWin => 'Pinakamagandang panalo';

  @override
  String get careerWorstDefeat => 'Pinakamasamang talo';

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
    return '${won}P ${drawn}T ${lost}N  ·  GF $goalsFor GA $goalsAgainst ($gd)';
  }

  @override
  String get careerWorldCupLabel => 'Kampeonato ng Mundo';

  @override
  String get careerContinentalLabel => 'Kontinental';

  @override
  String get messagesTitle => 'MGA MENSAHE';

  @override
  String get messagesNoMessagesYet => 'Wala pang mensahe.';

  @override
  String messagesCouldNotLoad(String error) {
    return 'Hindi ma-load ang mga mensahe.\n$error';
  }

  @override
  String get messagesDone => 'Tapos na';

  @override
  String get messagesNext => 'Susunod';

  @override
  String get rankingWorldRanking => 'PANDAIGDIGANG RANKING';

  @override
  String rankingCouldNotLoad(String error) {
    return 'Hindi ma-load ang ranking.\n$error';
  }

  @override
  String get rankingNoRanking => 'Walang ranking.';

  @override
  String get rankingAll => 'LAHAT';

  @override
  String get rankingYourTeam => 'KOPONAN MO';

  @override
  String get rankingYourRankingOverTime => 'RANKING MO SA PAGLIPAS NG PANAHON';

  @override
  String rankingNowRank(int rank) {
    return 'ngayon #$rank';
  }

  @override
  String rankingBestWorst(int best, int worst) {
    return 'pinakamataas #$best · pinakamababa #$worst';
  }

  @override
  String get friendliesTitle => 'MGA FRIENDLY';

  @override
  String friendliesLoadError(String error) {
    return 'Hindi ma-load ang mga friendly.\n$error';
  }

  @override
  String get friendliesContinue => 'Magpatuloy';

  @override
  String friendliesArrangeIntro(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bakanteng window',
      one: '1 bakanteng window',
    );
    return 'Mag-ayos ng warm-up para sa $_temp0 bago ang susunod mong mahalagang laro. I-tap ang kalaban, o iwanan itong bukas.';
  }

  @override
  String get friendliesFree => 'Bakante';

  @override
  String matchGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count GOAL',
      one: '1 GOAL',
    );
    return '$_temp0';
  }

  @override
  String get matchGoalsTitle => 'MGA GOAL';

  @override
  String get matchGoalsNone => 'Walang goal';

  @override
  String get matchGoalPenalty => 'PEN';

  @override
  String get matchGoalSetPiece => 'SET';

  @override
  String matchGoalAssist(String name) {
    return 'assist: $name';
  }

  @override
  String get friendliesHome => 'HOME';

  @override
  String get friendliesAway => 'AWAY';

  @override
  String get friendliesNoneThisWindow => 'Walang friendly sa window na ito';

  @override
  String friendliesConfirmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friendly',
      one: '1 friendly',
    );
    return 'Kumpirmahin ang $_temp0';
  }

  @override
  String get friendliesMonthJan => 'Ene';

  @override
  String get friendliesMonthFeb => 'Peb';

  @override
  String get friendliesMonthMar => 'Mar';

  @override
  String get friendliesMonthApr => 'Abr';

  @override
  String get friendliesMonthMay => 'May';

  @override
  String get friendliesMonthJun => 'Hun';

  @override
  String get friendliesMonthJul => 'Hul';

  @override
  String get friendliesMonthAug => 'Ago';

  @override
  String get friendliesMonthSep => 'Set';

  @override
  String get friendliesMonthOct => 'Okt';

  @override
  String get friendliesMonthNov => 'Nob';

  @override
  String get friendliesMonthDec => 'Dis';

  @override
  String get resultsMyMatches => 'MGA LARO KO';

  @override
  String resultsCouldNotLoad(String error) {
    return 'Hindi ma-load ang mga resulta.\n$error';
  }

  @override
  String get resultsNoFixtures => 'Walang fixture.';

  @override
  String get resultsVs => 'vs';

  @override
  String get resultsStageQualifier => 'QUALIFIER';

  @override
  String get resultsStageFriendly => 'FRIENDLY';

  @override
  String get resultsStageGroupStage => 'GROUP STAGE';

  @override
  String get resultsStageSemiFinal => 'SEMIFINAL';

  @override
  String get resultsStageFinal => 'FINAL';

  @override
  String get resultsStageContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get resultsStageFinalsGroup => 'GRUPO NG FINALS';

  @override
  String get resultsStageRoundOf32 => 'ROUND OF 32';

  @override
  String get resultsStageRoundOf16 => 'ROUND OF 16';

  @override
  String get resultsStageQuarterFinal => 'QUARTERFINAL';

  @override
  String get resultsStageThirdPlace => 'IKATLONG PUWESTO';

  @override
  String get matchSetupWarnCaptain =>
      'Walang itinalagang kapitan. I-tap para ibigay ang armband sa isa';

  @override
  String matchSetupWarnCaptainInjured(String name) {
    return 'Injured si $name at hindi makakapanguna sa laban na ito. I-tap para ipasa ang armband';
  }

  @override
  String matchSetupWarnCaptainSuspended(String name) {
    return 'Suspendido si $name sa laban na ito. I-tap para ipasa ang armband';
  }

  @override
  String matchSetupWarnCaptainDropped(String name) {
    return 'Hawak ni $name ang armband pero wala siya sa squad mo. I-tap para ipasa ito';
  }

  @override
  String get matchSetupWarnSetPieces =>
      'Walang itinalagang kukuha ng set piece. I-tap para piliin kung sino ang haharap';

  @override
  String get matchSetupWarnBoth =>
      'Walang kapitan at walang kukuha ng set piece. I-tap para itakda ang mga ito';

  @override
  String matchStageMatchday(int matchday) {
    return 'MD $matchday';
  }

  @override
  String get squadCaptain => 'Kapitan';

  @override
  String deptEffectYouth(int points) {
    return 'Mas mataas nang humigit-kumulang $points overall ang mga prospect ng akademya';
  }

  @override
  String deptEffectCommercial(String amount) {
    return '$amount ang babalik sa pagtatapos ng cycle';
  }

  @override
  String deptEffectMedical(int percent) {
    return '$percent% mas kaunting injury';
  }

  @override
  String deptEffectNaturalisation(int percent) {
    return '$percent% tsansa na may dayuhang manlalarong hihiling na lumipat';
  }

  @override
  String deptEffectBoard(int points) {
    return '+$points tiyaga ng board bago malagay sa panganib ang trabaho mo';
  }

  @override
  String get deptEffectNone => 'Walang epekto kapag walang pondo';

  @override
  String get statsBestRated => 'Mga rating';

  @override
  String get statsMyCareer => 'Karera';

  @override
  String get statsBestAverageRating => 'PINAKAMATAAS NA AVERAGE RATING';

  @override
  String get statsMyCareerRecord => 'RECORD MO';

  @override
  String get statsNoRatingsRecorded => 'Wala pang naitalang rating ng laro.';

  @override
  String get statsGroupRecord => 'Record';

  @override
  String get statsGroupRuns => 'Mga sunod-sunod';

  @override
  String get statsGroupExtremes => 'Mga sukdulan';

  @override
  String get statsGroupSplits => 'Home at away';

  @override
  String get statsGroupSquad => 'Mga manlalaro mo';

  @override
  String get statsPlayed => 'Mga larong nalaro';

  @override
  String get statsWinDrawLoss => 'Panalo–tabla–talo';

  @override
  String get statsWinRate => 'Win rate';

  @override
  String get statsGoals => 'Goal na naipasok:pumasok';

  @override
  String get statsCleanSheets => 'Clean sheet';

  @override
  String get statsFailedToScore => 'Hindi nakaiskor';

  @override
  String get statsLongestWinStreak => 'Pinakamahabang sunod na panalo';

  @override
  String get statsLongestUnbeaten => 'Pinakamahabang larong walang talo';

  @override
  String get statsLongestCleanSheets => 'Pinakamahabang sunod na clean sheet';

  @override
  String get statsLongestWinless => 'Pinakamahabang larong walang panalo';

  @override
  String get statsCurrentRun => 'Kasalukuyang larong walang talo';

  @override
  String get statsBiggestWin => 'Pinakamalaking panalo';

  @override
  String get statsHeaviestDefeat => 'Pinakamabigat na talo';

  @override
  String get statsMostGoalsInAGame => 'Pinakamaraming goal sa isang laro';

  @override
  String get statsShootouts => 'Shootout: panalo–talo';

  @override
  String get statsComebackWins => 'Panalo mula sa pagkakalamang ng kalaban';

  @override
  String get statsHome => 'Home';

  @override
  String get statsAway => 'Away';

  @override
  String get statsNeutral => 'Neutral';

  @override
  String get statsCompetitive => 'Opisyal na laro';

  @override
  String get statsFriendlies => 'Mga friendly';

  @override
  String get statsHatTricks => 'Hat-trick';

  @override
  String get statsBraces => 'Brace';

  @override
  String get statsMotms => 'Parangal na man of the match';

  @override
  String get statsAssists => 'Assist';

  @override
  String get statsCards => 'Mga kard';

  @override
  String get statsBestRating => 'Pinakamataas na indibidwal na rating';

  @override
  String statsAppsShort(int apps) {
    return '$apps laro';
  }

  @override
  String statsMotmShort(int motms) {
    return '$motms MOTM';
  }

  @override
  String get captainArmband => 'K';

  @override
  String get captainCurrent => 'Kapitan. I-tap para tanggalin ang armband';

  @override
  String get captainFitBorn => 'Isang ipinanganak na lider';

  @override
  String get captainFitNatural => 'Likas na kapitan';

  @override
  String get captainFitCapable => 'Kaya niyang magsuot nito';

  @override
  String get captainFitUnproven => 'Hindi pa lider';

  @override
  String get captainNone => 'Walang itinalagang kapitan';

  @override
  String captainMoraleBoost(int morale) {
    return '+$morale morale ng squad';
  }

  @override
  String get resultsCategoryWorldCupQualifying =>
      'Kwalipikasyon sa Kampeonato ng Mundo';

  @override
  String get resultsCategoryFriendlies => 'Mga Friendly';

  @override
  String get resultsCategoryContinentalClash => 'Continental Clash';

  @override
  String get resultsCategoryNationsCup => 'Nations Cup';

  @override
  String get resultsCategoryContinentalCup => 'Kontinental na Copa';

  @override
  String get resultsCategoryWorldCupQualifyingShort => 'Kwal. sa KnM';

  @override
  String get resultsCategoryContinentalQualifyingShort => 'Kwal. Kont. Copa';

  @override
  String get resultsCategoryContinentalQualifying =>
      'Kwalipikasyon sa Kontinental na Copa';

  @override
  String get resultsCategoryWorldCupFinals => 'Finals ng Kampeonato ng Mundo';

  @override
  String get resultsRoundResults => 'MGA RESULTA NG ROUND';

  @override
  String get resultsFriendlyInternationals => 'MGA INTERNASYONAL NA FRIENDLY';

  @override
  String get resultsKnockout => 'Knockout';

  @override
  String resultsEarlierMatches(int count) {
    return 'Mga naunang laro ($count)';
  }

  @override
  String resultsMatchday(int matchday) {
    return 'MATCHDAY $matchday';
  }

  @override
  String get resultsContinue => 'Magpatuloy';

  @override
  String resultsGroup(String name) {
    return 'GRUPO $name';
  }

  @override
  String get achievementsScreenTitle => 'MGA TAGUMPAY';

  @override
  String get achievementsChallengesTooltip => 'Mga Hamon';

  @override
  String get achievementsChallengesHeading => 'MGA HAMON';

  @override
  String get achievementsBrutalTests => 'Matitinding pagsubok sa buong karera';

  @override
  String achievementsCouldNotLoad(String error) {
    return 'Hindi ma-load.\n$error';
  }

  @override
  String achievementsUnlockedCount(int earned, int total) {
    return '$earned / $total na-unlock';
  }

  @override
  String achievementsConqueredCount(int done, int total) {
    return '$done / $total nalupig';
  }

  @override
  String get achievementsBoardSatisfaction => 'KASIYAHAN NG BOARD';

  @override
  String achievementsUnlockedBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'NA-UNLOCK ANG $count TAGUMPAY',
      one: 'NA-UNLOCK ANG TAGUMPAY',
    );
    return '$_temp0';
  }

  @override
  String get achCatWins => 'Mga Panalo';

  @override
  String get achCatMatches => 'Mga Laro';

  @override
  String get achCatQualifications => 'Mga Kwalipikasyon';

  @override
  String get achCatTitles => 'Mga Titulo';

  @override
  String get achCatMisc => 'Iba pa';

  @override
  String get achCatMega => 'Mega';

  @override
  String get achCatGoals => 'Mga Goal';

  @override
  String get achCatStreaks => 'Mga Sunod-sunod';

  @override
  String get achTierBronze => 'Tanso';

  @override
  String get achTierSilver => 'Pilak';

  @override
  String get achTierGold => 'Ginto';

  @override
  String get achTierPlatinum => 'Platinum';

  @override
  String achGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Goal',
    );
    return '$_temp0';
  }

  @override
  String achGoalsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Makaiskor ng $count goal.',
      one: 'Makaiskor ng 1 goal.',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Clean Sheet',
    );
    return '$_temp0';
  }

  @override
  String achCleanSheetsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Magtala ng $count clean sheet.',
      one: 'Magtala ng 1 clean sheet.',
    );
    return '$_temp0';
  }

  @override
  String get achStreakWin5 => 'Ugaling Panalo';

  @override
  String get achStreakWin5Desc => 'Manalo ng limang sunod na laro.';

  @override
  String get achStreakWin10 => 'Sunod-sunod ang Swerte';

  @override
  String get achStreakWin10Desc => 'Manalo ng sampung sunod na laro.';

  @override
  String get achStreakWin20 => 'Juggernaut';

  @override
  String get achStreakWin20Desc => 'Manalo ng dalawampung sunod na laro.';

  @override
  String get achUnbeaten15 => 'Mahirap Talunin';

  @override
  String get achUnbeaten15Desc =>
      'Umabot ng labinlimang laro nang walang talo.';

  @override
  String get achUnbeaten30 => 'Hindi Magalaw';

  @override
  String get achUnbeaten30Desc => 'Umabot ng tatlumpung laro nang walang talo.';

  @override
  String get achHattrick => 'Bayani ng Hat-trick';

  @override
  String get achHattrickDesc =>
      'Magkaroon ng manlalarong makaiskor ng hat-trick.';

  @override
  String get achMotm10 => 'Namumukod-tangi';

  @override
  String get achMotm10Desc => 'Makakuha ng 10 parangal na man of the match.';

  @override
  String get achMotm50 => 'Talisman';

  @override
  String get achMotm50Desc => 'Makakuha ng 50 parangal na man of the match.';

  @override
  String get achPerfect => 'Perpektong Sampu';

  @override
  String get achPerfectDesc =>
      'Magkaroon ng manlalarong makakuha ng 9.5+ na rating sa laro.';

  @override
  String get achShootout => 'Yelo sa Ugat';

  @override
  String get achShootoutDesc => 'Manalo sa limang penalty shootout.';

  @override
  String get achMassacre => 'Masaker';

  @override
  String get achMassacreDesc => 'Manalo ng 7 goal o higit pa ang agwat.';

  @override
  String get achAnnihilation => 'Pagkawasak';

  @override
  String get achAnnihilationDesc => 'Manalo ng 10 goal o higit pa ang agwat.';

  @override
  String get chTierBronze => 'Tanso';

  @override
  String get chTierSilver => 'Pilak';

  @override
  String get chTierGold => 'Ginto';

  @override
  String get chTierLegendary => 'Alamat';

  @override
  String get chFirstSteps => 'Sa Dugout';

  @override
  String get chFirstStepsDesc => 'Mag-manage nang 5 taon.';

  @override
  String get chUnbeaten10 => 'Sunod-sunod ang Swerte';

  @override
  String get chUnbeaten10Desc =>
      'Umabot ng 10 opisyal na laro nang walang talo.';

  @override
  String get chTwoNations => 'Bagong Hamon';

  @override
  String get chTwoNationsDesc => 'Pamunuan ang 2 magkaibang bansa.';

  @override
  String get chCont1 => 'Kampeon ng Kontinente';

  @override
  String get chCont1Desc => 'Manalo ng kampeonato ng kontinente.';

  @override
  String get chNc1 => 'Nanalo ng Nations Cup';

  @override
  String get chNc1Desc => 'Manalo ng Nations Cup.';

  @override
  String get chWc1 => 'Kampeon ng Mundo';

  @override
  String get chWc1Desc => 'Manalo ng Kampeonato ng Mundo.';

  @override
  String get chYears25 => 'Establisado';

  @override
  String get chYears25Desc => 'Mag-manage nang 25 taon.';

  @override
  String get chWc3 => 'Seryal na Nananalo';

  @override
  String get chWc3Desc => 'Manalo ng 3 Kampeonato ng Mundo.';

  @override
  String get chWc5 => 'Dinastiya';

  @override
  String get chWc5Desc => 'Manalo ng 5 Kampeonato ng Mundo.';

  @override
  String get chWc10 => 'Walang Kamatayan';

  @override
  String get chWc10Desc => 'Manalo ng 10 Kampeonato ng Mundo.';

  @override
  String get chWc2Teams => 'Handang Maglakbay';

  @override
  String get chWc2TeamsDesc =>
      'Manalo ng Kampeonato ng Mundo kasama ang 2 magkaibang bansa.';

  @override
  String get chWc3Teams => 'Globetrotter';

  @override
  String get chWc3TeamsDesc =>
      'Manalo ng Kampeonato ng Mundo kasama ang 3 magkaibang bansa.';

  @override
  String get chWcStreak3 => 'Three-Peat';

  @override
  String get chWcStreak3Desc =>
      'Manalo ng 3 Kampeonato ng Mundo nang sunod-sunod.';

  @override
  String get chWcAllconf => 'Mananakop ng Mundo';

  @override
  String get chWcAllconfDesc =>
      'Manalo ng Kampeonato ng Mundo kasama ang isang bansa mula sa bawat kompederasyon (6).';

  @override
  String get chCont5 => 'Hari ng Kontinente';

  @override
  String get chCont5Desc => 'Manalo ng 5 kampeonato ng kontinente.';

  @override
  String get chContAll => 'Slam ng Anim na Kontinente';

  @override
  String get chContAllDesc =>
      'Manalo ng kampeonato ng kontinente ng bawat kompederasyon (6).';

  @override
  String get chTreble => 'Walis-Tiyak';

  @override
  String get chTrebleDesc =>
      'Manalo ng Kampeonato ng Mundo, titulo ng kontinente at Nations Cup sa iisang karera.';

  @override
  String get chNations10 => 'Palaboy';

  @override
  String get chNations10Desc => 'Pamunuan ang 10 magkaibang bansa.';

  @override
  String get chYears100 => 'Siglo';

  @override
  String get chYears100Desc => 'Mag-manage nang 100 taon.';

  @override
  String get chYears500 => 'Kalahating Milenyo';

  @override
  String get chYears500Desc => 'Mag-manage nang 500 taon.';

  @override
  String get chYears1000 => 'Walang Hanggan';

  @override
  String get chYears1000Desc => 'Mag-manage nang 1000 taon.';

  @override
  String get chGrandmaster => 'Grandmaster';

  @override
  String get chGrandmasterDesc =>
      'Manalo ng 3 Kampeonato ng Mundo AT 5 kampeonato ng kontinente.';

  @override
  String get chUndefeated => 'Hindi Magalaw';

  @override
  String get chUndefeatedDesc =>
      'Manalo ng Kampeonato ng Mundo nang hindi natatalo kahit isang laro.';

  @override
  String get chPerfectQual => 'Walang Butas na Daan';

  @override
  String get chPerfectQualDesc =>
      'Manalo sa bawat laro ng kampanya sa kwalipikasyon para sa Kampeonato ng Mundo.';

  @override
  String get chMinnow => 'Himala ng Maliit';

  @override
  String get chMinnowDesc =>
      'Manalo ng Kampeonato ng Mundo kasama ang bansang nasa labas ng top 32 sa mundo.';

  @override
  String get chGrandTour => 'Home at Away';

  @override
  String get chGrandTourDesc =>
      'Manalo ng Kampeonato ng Mundo bilang host at manalo ng isa sa labas ng sariling bansa.';

  @override
  String get chUnbeaten25 => 'Ang Pader';

  @override
  String get chUnbeaten25Desc =>
      'Umabot ng 25 opisyal na laro nang walang talo.';

  @override
  String get chGoals10k => 'Goal Machine';

  @override
  String get chGoals10kDesc => 'Makaiskor ng 10,000 goal sa karera.';

  @override
  String get chCleanSheets500 => 'Kuta';

  @override
  String get chCleanSheets500Desc => 'Magtala ng 500 clean sheet sa karera.';

  @override
  String get chHatTricks25 => 'Ugaling Hat-trick';

  @override
  String get chHatTricks25Desc =>
      'Magkaroon ng 25 hat-trick mula sa mga manlalaro mo.';

  @override
  String get chWinStreak25 => 'Walang Awat';

  @override
  String get chWinStreak25Desc => 'Manalo ng 25 laro nang sunod-sunod.';

  @override
  String get chCont10 => 'Dinastiya ng Kontinente';

  @override
  String get chCont10Desc => 'Manalo ng 10 kampeonato ng kontinente.';

  @override
  String get chPcWc => 'Seryal na Kampeon';

  @override
  String chPcWcDesc(int count) {
    return 'Manalo ng $count Kampeonato ng Mundo sa save na ito.';
  }

  @override
  String get chPcMajors => 'Kolektor ng Tropeo';

  @override
  String chPcMajorsDesc(int count) {
    return 'Manalo ng $count malalaking tropeo (Kampeonato ng Mundo, kontinental o Nations Cup).';
  }

  @override
  String get chPcUnbeaten => 'Bakal na Pader';

  @override
  String chPcUnbeatenDesc(int count) {
    return 'Umabot ng $count opisyal na laro nang walang talo.';
  }

  @override
  String get chPcNations => 'Beterano';

  @override
  String chPcNationsDesc(int count) {
    return 'Pamunuan ang $count magkaibang bansa.';
  }

  @override
  String get chPcYears => 'Mahabang Biyahe';

  @override
  String chPcYearsDesc(int count) {
    return 'Mag-manage nang $count taon.';
  }

  @override
  String achWins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Panalo',
      one: '1 Panalo',
    );
    return '$_temp0';
  }

  @override
  String achWinsDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Manalo ng $count laro.',
      one: 'Manalo ng 1 laro.',
    );
    return '$_temp0';
  }

  @override
  String achMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Laro',
    );
    return '$_temp0';
  }

  @override
  String achMatchesDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maglaro ng $count laro.',
      one: 'Maglaro ng 1 laro.',
    );
    return '$_temp0';
  }

  @override
  String get achQualWc => 'Kwalipikado sa Kampeonato ng Mundo';

  @override
  String get achQualWcDesc => 'Makapasok sa Kampeonato ng Mundo.';

  @override
  String get achQualCont => 'Kwalipikado sa Kontinental';

  @override
  String get achQualContDesc => 'Makapasok sa kampeonato ng kontinente mo.';

  @override
  String get achTitleWc => 'Kampeon ng Mundo';

  @override
  String get achTitleWcDesc => 'Manalo ng Kampeonato ng Mundo.';

  @override
  String get achTitleEuro => 'Kampeon ng Europa';

  @override
  String get achTitleEuroDesc => 'Manalo ng Kampeonato ng Europa.';

  @override
  String get achTitleCopa => 'Kampeon ng Timog Amerika';

  @override
  String get achTitleCopaDesc => 'Manalo ng Copa ng Timog Amerika.';

  @override
  String get achTitleAfcon => 'Kampeon ng Aprika';

  @override
  String get achTitleAfconDesc => 'Manalo ng Kampeonato ng Aprika.';

  @override
  String get achTitleAsia => 'Kampeon ng Asya';

  @override
  String get achTitleAsiaDesc => 'Manalo ng Kampeonato ng Asya.';

  @override
  String get achTitleConcacaf => 'Kampeon ng Hilagang Amerika';

  @override
  String get achTitleConcacafDesc => 'Manalo ng Copa ng Hilagang Amerika.';

  @override
  String get achTitleOfc => 'Kampeon ng Oceania';

  @override
  String get achTitleOfcDesc => 'Manalo ng Copa ng Oceania.';

  @override
  String get achTitleNations => 'Nanalo ng Nations Cup';

  @override
  String get achTitleNationsDesc => 'Manalo ng Nations Cup.';

  @override
  String get achTitleClash => 'Nanalo ng Continental Clash';

  @override
  String get achTitleClashDesc => 'Manalo ng Continental Clash.';

  @override
  String get achMarksman => 'Sharpshooter ng Kampeonato ng Mundo';

  @override
  String get achMarksmanDesc =>
      'Magkaroon ng manlalaro ng squad na makaiskor ng 6+ goal sa finals ng Kampeonato ng Mundo.';

  @override
  String get achSweep => 'Walis-Tiyak';

  @override
  String get achSweepDesc =>
      'Hawakan ang Kampeonato ng Mundo at ang titulo ng kontinente mo sa iisang karera.';

  @override
  String get achAllstar => 'All-Star ng Torneo';

  @override
  String get achAllstarDesc =>
      'Magkaroon ng manlalarong mapabilang sa Team of the Tournament ng Kampeonato ng Mundo.';

  @override
  String get achGoldenboot => 'Golden Boot';

  @override
  String get achGoldenbootDesc =>
      'Tapusin ng bansa mo bilang top scorer ng isang kampeonato.';

  @override
  String get achDemolition => 'Demolisyon';

  @override
  String get achDemolitionDesc => 'Manalo ng 5 goal o higit pa ang agwat.';

  @override
  String get achievementsNice => 'Ayos!';

  @override
  String get achievementsHardestTests =>
      'Ang pinakamahihirap na pagsubok sa isang manager, sa buong karera at maraming bansa.';

  @override
  String get achievementsThisSave => 'ITONG SAVE';

  @override
  String get achievementsBrutalBadge => 'BRUTAL';

  @override
  String get paywallGoPro => 'MAG-UNLIMITED NA';

  @override
  String get paywallOneTimeUnlock =>
      'Isang beses na unlock. Walang subscription.';

  @override
  String get paywallBenefitCarryOn =>
      'Magpapatuloy ang save na ito eksakto kung saan ito huminto, buo ang bawat cap, record at karibalan.';

  @override
  String get paywallBenefitNoAds =>
      'Walang ads, walang microtransaction, walang subscription. Isang bayad lang, at sa iyo ang bawat susunod na update.';

  @override
  String get paywallBenefitSaves =>
      'Kahit ilang save ang gusto mo. Magpatakbo ng paborito at ng maliit na koponan nang sabay, at tuklasin kung gaano kaiba ang basa sa iisang laro.';

  @override
  String get paywallBenefitEndless =>
      'Bawat cycle mula ngayon. Pumili ng labimpitong taong gulang ngayon at alamin sa 2034 kung tama ang nakita mo.';

  @override
  String get paywallUnlocked => 'Na-unlock na ang Unlimited. Mag-enjoy!';

  @override
  String get paywallContactingStore => 'Kinokontak ang store…';

  @override
  String paywallUnlockProPriced(String price) {
    return 'I-unlock ang Unlimited · $price';
  }

  @override
  String get paywallRestorePurchases => 'Ibalik ang mga binili';

  @override
  String get paywallStoreUnavailable => 'Hindi available ang store';

  @override
  String get paywallStoreUnavailableNote =>
      'Hindi ma-load ang presyo. Tingnan ang koneksyon mo at subukan ulit.';

  @override
  String get paywallTryAgain => 'Subukan ulit';

  @override
  String get gateTitle => 'TAPOS NA ANG UNANG CYCLE MO';

  @override
  String get gateLead =>
      'Ang apat na taon ay isang cycle. Hindi iyon sapat para malaman kung tama ka.';

  @override
  String get gatePriceLead => 'Isang bayad, habambuhay';

  @override
  String get gateBuy => 'BUMILI AT MAGPATULOY';

  @override
  String get gateExit => 'LUMABAS';

  @override
  String get federationNaturalisation => 'NATURALISASYON';

  @override
  String federationNaturalisedTitle(String name) {
    return 'Na-naturalise si $name';
  }

  @override
  String federationNaturalisedBody(String name, String nation) {
    return 'Natapos na ni $name ang paglipat at puwede na siyang piliin para sa $nation. Tawagin siya mula sa pagpili mo ng squad.';
  }

  @override
  String federationCouldNotLoadOffer(String error) {
    return 'Hindi ma-load ang alok.\n$error';
  }

  @override
  String get federationContinue => 'Magpatuloy';

  @override
  String get federationOfferToSwitchAllegiance =>
      'ALOK NA LUMIPAT NG PAMBANSANG PANIG';

  @override
  String federationPlayerMeta(String position, int age, String nation) {
    return '$position · edad $age · mula sa $nation';
  }

  @override
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  ) {
    return 'May ugnayan si $name sa $playerNation at handang ma-naturalise. Tanggapin at puwede siyang piliin; tanggihan at mananatili siya sa $sourceNation.';
  }

  @override
  String get federationDecline => 'Tanggihan';

  @override
  String get federationNaturalise => 'I-naturalise';

  @override
  String get federationBudgetLater => 'Magdesisyon mamaya';

  @override
  String get federationSetYourBudget => 'ITAKDA ANG BADYET MO';

  @override
  String federationCouldNotLoadFinances(String error) {
    return 'Hindi ma-load ang pananalapi.\n$error';
  }

  @override
  String get federationSaveNotFound => 'Hindi nahanap ang save.';

  @override
  String get federationBudgetHeading => 'BADYET NG PEDERASYON';

  @override
  String federationDistributeBudget(String amount) {
    return 'Hatiin ang $amount sa mga departamento para simulan ang cycle. Gamitin nang matalino.';
  }

  @override
  String federationOverBudget(String amount) {
    return 'Lampas ng $amount sa pondo ng pederasyon. Bawasan mo ang ilan';
  }

  @override
  String get federationAllocateFullBudget =>
      'Ilaan ang buong badyet para masimulan ang cycle.';

  @override
  String get federationConfirming => 'Kinukumpirma…';

  @override
  String get federationConfirmBudget => 'Kumpirmahin ang badyet';

  @override
  String get federationFinances => 'PANANALAPI';

  @override
  String get federationInvestmentUpdated => 'Na-update ang investment.';

  @override
  String get federationDevelopment => 'PAGPAPAUNLAD NG PEDERASYON';

  @override
  String get federationProjectedAtSeasonEnd => 'PROYEKSYON SA DULO NG SEASON';

  @override
  String get federationCentralFunding => 'Sentral na pondo';

  @override
  String get federationPrizeMoneySoFar => 'Premyong napanalunan sa ngayon';

  @override
  String get federationCommercialReturn => 'Komersyal na kita';

  @override
  String get federationThisSeasonLocked => 'ITONG SEASON (NAKA-LOCK)';

  @override
  String get federationInvestForNextSeason =>
      'MAG-INVEST PARA SA SUSUNOD NA SEASON';

  @override
  String get federationNextSeasonImpact => 'EPEKTO SA SUSUNOD NA SEASON';

  @override
  String get federationSaving => 'Sine-save…';

  @override
  String get federationConfirmInvestment => 'Kumpirmahin ang investment';

  @override
  String get federationBalance => 'BALANSE NG PEDERASYON';

  @override
  String get federationCommittedToStaff => 'Nakalaan sa staff';

  @override
  String get federationFreeToSpend => 'Malayang magagastos';

  @override
  String get federationWagesNote =>
      'Ibabawas ang mga sahod sa balanse sa dulo ng cycle, kaya nakalaan na ang halagang ito.';

  @override
  String get federationInvestAtCeremony =>
      'Mag-invest para sa susunod na season sa seremonya sa katapusan ng cycle.';

  @override
  String federationLevelBadge(int level) {
    return 'L$level';
  }

  @override
  String get federationAcademyProspects => 'Mga prospect ng akademya';

  @override
  String federationPlusOverall(int value) {
    return '+$value overall';
  }

  @override
  String get federationInjuryRisk => 'Panganib ng injury';

  @override
  String get federationNaturalisationChance => 'Tsansa ng naturalisasyon';

  @override
  String get federationBoardPatience => 'Tiyaga ng board';

  @override
  String get federationUnallocated => 'WALA PANG LAAN';

  @override
  String get nationsVitrineTitle => 'TROPHY CABINET NG BANSA';

  @override
  String nationsCouldNotLoad(String error) {
    return 'Hindi ma-load ang bansa.\n$error';
  }

  @override
  String get nationsNoNation => 'Walang bansa.';

  @override
  String get nationsHonours => 'MGA PARANGAL';

  @override
  String get nationsRankingHistory => 'KASAYSAYAN NG PANDAIGDIGANG RANKING';

  @override
  String get nationsTopScorers => 'PINAKAMARAMING GOAL SA LAHAT NG PANAHON';

  @override
  String get nationsTitles => 'MGA TITULO';

  @override
  String get nationsYourTeam => 'KOPONAN MO';

  @override
  String get nationsWorld => 'MUNDO';

  @override
  String get nationsWorldCup => 'Kampeonato ng Mundo';

  @override
  String get nationsContinental => 'Kontinental';

  @override
  String nationsAppearances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paglabas',
      one: '1 paglabas',
    );
    return '$_temp0';
  }

  @override
  String get nationsNotEnoughHistory =>
      'Kulang pa ang kasaysayan. Bumalik ka pagkatapos ng isa o dalawang cycle.';

  @override
  String nationsBestRank(int rank) {
    return 'Pinakamataas: #$rank';
  }

  @override
  String nationsNowRank(int rank) {
    return 'Ngayon: #$rank';
  }

  @override
  String get nationsNoGoals => 'Wala pang naitalang goal.';

  @override
  String get nationsGoalsAbbrev => 'goal';

  @override
  String get nationsHosts => 'HOST';

  @override
  String get nationsSelectTitle => 'PILIIN ANG PAMBANSANG KOPONAN';

  @override
  String nationsCouldNotLoadNations(String error) {
    return 'Hindi ma-load ang mga bansa.\n$error';
  }

  @override
  String get nationsNoMatch => 'Walang tumutugmang bansa.';

  @override
  String get nationsNationalLevel => 'ANTAS NG BANSA';

  @override
  String get nationsSelectHeading => 'Pumili ng Pambansang Koponan';

  @override
  String get nationsSearchHint => 'Maghanap ng bansa…';

  @override
  String get nationsRank => 'RANK ';

  @override
  String get nationsPremium => 'PREMIUM';

  @override
  String get nationsSelect => 'PILIIN';

  @override
  String get statsTeamRecords => 'MGA RECORD NG KOPONAN';

  @override
  String get statsRecordBook => 'Record book';

  @override
  String statsCouldNotLoadStats(String error) {
    return 'Hindi ma-load ang stats.\n$error';
  }

  @override
  String get statsNoData => 'Walang data.';

  @override
  String get statsTopScorers => 'MGA TOP SCORER';

  @override
  String get statsMostGamesPlayed => 'PINAKAMARAMING LARO';

  @override
  String get statsTeam => 'Koponan';

  @override
  String get statsTopScorersShort => 'Scorer';

  @override
  String get statsMostGames => 'Pinakamaraming laro';

  @override
  String get statsNoGoalsRecorded => 'Wala pang naitalang goal.';

  @override
  String get statsUnknown => 'Hindi kilala';

  @override
  String get playerTitle => 'MANLALARO';

  @override
  String playerLoadError(String error) {
    return 'Hindi ma-load ang manlalaro.\n$error';
  }

  @override
  String get playerNotFound => 'Hindi nahanap ang manlalaro.';

  @override
  String get playerClub => 'CLUB';

  @override
  String get playerClubRole => 'Sa club niya';

  @override
  String get playerPosition => 'Posisyon';

  @override
  String get playerPotential => 'Potensyal';

  @override
  String get playerAge => 'Edad';

  @override
  String get playerValue => 'Halaga';

  @override
  String get clubFirstChoice => 'Naglalaro linggu-linggo';

  @override
  String get clubRotation => 'Paminsan-minsan';

  @override
  String get clubFringe => 'Halos hindi naglalaro';

  @override
  String get clubFrozenOut => 'Hindi naglalaro';

  @override
  String clubAtClub(String club, String standing) {
    return '$club: $standing';
  }

  @override
  String yWinUpset0(String opponent, String score) {
    return 'Tatlumpung taon na akong nanonood ng football at hindi ko ito nakita. Tinalo ang $opponent, $score.';
  }

  @override
  String yWinUpset1(String opponent, String score) {
    return 'Walang naniwala sa kanila laban sa $opponent. $score. Walang-wala.';
  }

  @override
  String yWinUpset2(String opponent, String score) {
    return '$score laban sa $opponent. Gisingin ang buong kapitbahayan.';
  }

  @override
  String yWinUpset3(String opponent, String score) {
    return 'Ganitong gabi ang ikukuwento sa mga apo. $opponent $score.';
  }

  @override
  String yWinUpset4(String opponent, String score) {
    return '$score laban sa $opponent. Kahit paano nangyari, nangyari.';
  }

  @override
  String yWinUpset5(String opponent, String score) {
    return 'Sa papel, tapos na ang laban bago pa magsimula. Iba ang sabi ng $opponent $score.';
  }

  @override
  String yWinUpset6(String opponent, String score) {
    return 'Tinalo ang $opponent, $score. Walang maniniwala sa iskor na iyan pagkalipas ng isang taon.';
  }

  @override
  String yWinUpset7(String opponent, String score) {
    return '$opponent $score. Tamasahin muna, tapos tingnan ang iskedyul.';
  }

  @override
  String yWinUpset8(String opponent, String score) {
    return '$score laban sa $opponent, at swerte ang sumabay sa atin sa walumpu sa siyamnapung minuto.';
  }

  @override
  String yWinUpset9(String opponent, String score) {
    return 'Ang isang gabi laban sa $opponent ay hindi bumubura sa isang taon. $score.';
  }

  @override
  String yWinUpset10(String opponent, String score) {
    return 'Tinalo ang $opponent, $score, at sasabihin na ngayong nakaliko na tayo. Hindi pa.';
  }

  @override
  String yWinUpset11(String opponent, String score) {
    return '$opponent $score. Ang galing. Tanungin mo ulit ako kapag mahalaga na.';
  }

  @override
  String yWinRoutine0(String opponent, String score) {
    return 'Tinalo ang $opponent, $score. Eksakto sa dapat, at may sarap iyon.';
  }

  @override
  String yWinRoutine1(String opponent, String score) {
    return '$score kontra $opponent. Walang awa, at papuri iyan.';
  }

  @override
  String yWinRoutine2(String opponent, String score) {
    return '$opponent $score. Walang gulo, walang kaba, walang reklamo.';
  }

  @override
  String yWinRoutine3(String opponent, String score) {
    return 'Maayos na $score laban sa $opponent. Ganito ang magandang koponan sa tahimik na araw.';
  }

  @override
  String yWinRoutine4(String opponent, String score) {
    return '$score laban sa $opponent. Tapos na ang trabaho, wala tayong natutunan.';
  }

  @override
  String yWinRoutine5(String opponent, String score) {
    return 'Tinalo ang $opponent, $score. Dapat natin iyang gawin, at ginawa natin.';
  }

  @override
  String yWinRoutine6(String opponent, String score) {
    return 'Propesyonal na $score laban sa $opponent. Susunod.';
  }

  @override
  String yWinRoutine7(String opponent, String score) {
    return 'Natapos na ang $opponent, $score. I-file at magpatuloy.';
  }

  @override
  String yWinRoutine8(String opponent, String score) {
    return '$score laban sa $opponent at dapat tayong pumalakpak. Dahil lang natalo natin sila.';
  }

  @override
  String yWinRoutine9(String opponent, String score) {
    return 'Congrats sa lahat ng kasali sa $score laban sa $opponent, siguro.';
  }

  @override
  String yWinRoutine10(String opponent, String score) {
    return '$opponent $score. Ang pagtalo sa ganyang koponan ay pinakamababang pamantayan, hindi tagumpay.';
  }

  @override
  String yWinRoutine11(String opponent, String score) {
    return 'Tinalo natin ang $opponent, $score, at mabigat tingnan ang laro.';
  }

  @override
  String yWinTight0(String opponent, String score) {
    return '$score laban sa $opponent at pinaghirapan ang bawat minuto.';
  }

  @override
  String yWinTight1(String opponent, String score) {
    return 'Kailangan ng tibay ng loob doon. $opponent $score.';
  }

  @override
  String yWinTight2(String opponent, String score) {
    return 'Tinalo ang $opponent, $score, sa mahirap na paraan, ang paraang tumatagal.';
  }

  @override
  String yWinTight3(String opponent, String score) {
    return '$score laban sa $opponent. Ang mga nananalo nang ganito ang nakatayo pa rin pagdating ng Hunyo.';
  }

  @override
  String yWinTight4(String opponent, String score) {
    return 'Kabado, pangit, pero panalo. $opponent $score.';
  }

  @override
  String yWinTight5(String opponent, String score) {
    return 'Tinalo ang $opponent, $score. Kunin ang tatlong puntos at huwag nang panoorin ulit.';
  }

  @override
  String yWinTight6(String opponent, String score) {
    return '$score. Pinahirapan tayo ng $opponent sa bawat pulgada.';
  }

  @override
  String yWinTight7(String opponent, String score) {
    return '$opponent $score. Hindi maganda. Pareho pa rin ang bilang.';
  }

  @override
  String yWinTight8(String opponent, String score) {
    return '$score laban sa $opponent at sampung beses nating pinahirap kaysa sa dapat.';
  }

  @override
  String yWinTight9(String opponent, String score) {
    return 'Hindi dapat tayo nagpupumilit humawak laban sa $opponent. $score.';
  }

  @override
  String yWinTight10(String opponent, String score) {
    return '$opponent $score. Nanalo, pero walang magandang natutunan tungkol sa atin.';
  }

  @override
  String yWinTight11(String opponent, String score) {
    return 'Isang $score laban sa $opponent na masyadong mabait sa atin.';
  }

  @override
  String yDrew0(String opponent, String score) {
    return 'Isang puntos laban sa $opponent, $score. Kunin na at magpatuloy.';
  }

  @override
  String yDrew1(String opponent, String score) {
    return '$score sa $opponent. May mas masahol pang hapon kaysa rito.';
  }

  @override
  String yDrew2(String opponent, String score) {
    return 'Napigil ang $opponent sa $score. Hindi lahat kailangang kuwento.';
  }

  @override
  String yDrew3(String opponent, String score) {
    return '$opponent $score. Ang puntos ay puntos at hindi nagtatanong ang standings kung paano.';
  }

  @override
  String yDrew4(String opponent, String score) {
    return '$score sa $opponent. Dalawang puntos na nawala o isa na nakuha. Ikaw ang bahala sa mood.';
  }

  @override
  String yDrew5(String opponent, String score) {
    return 'Tabla laban sa $opponent, $score. Walang masaya, walang galit.';
  }

  @override
  String yDrew6(String opponent, String score) {
    return '$opponent $score. Ang pinakalimot-limutang siyamnapung minuto ng taon.';
  }

  @override
  String yDrew7(String opponent, String score) {
    return 'Naghati sa puntos sa $opponent, $score. Tuloy lang.';
  }

  @override
  String yDrew8(String opponent, String score) {
    return '$score laban sa $opponent. Ganitong mga tabla ang tahimik na pumapatay sa kampanya.';
  }

  @override
  String yDrew9(String opponent, String score) {
    return 'Dalawang puntos ang itinapon laban sa $opponent. $score. Walang ibang tawag dito.';
  }

  @override
  String yDrew10(String opponent, String score) {
    return '$opponent $score. Siyamnapung minuto at walang ideya kung ano ang gagawin.';
  }

  @override
  String yDrew11(String opponent, String score) {
    return 'Isang $score sa $opponent na walang makakaalala at lahat ay magbabayad.';
  }

  @override
  String yLost0(String opponent, String score) {
    return 'Natalo, $score, sa $opponent. Nangyayari talaga.';
  }

  @override
  String yLost1(String opponent, String score) {
    return '$opponent $score. Walang dapat isisi kanino man. Susunod na.';
  }

  @override
  String yLost2(String opponent, String score) {
    return 'Natalo, $score, sa $opponent matapos ibigay ang lahat. May mga araw na kulang pa iyon.';
  }

  @override
  String yLost3(String opponent, String score) {
    return '$score sa $opponent. Ulo pataas. Marami pang natitira sa koponang ito.';
  }

  @override
  String yLost4(String opponent, String score) {
    return '$opponent $score. Pangalawang pinakamahusay tayo at wala nang debate.';
  }

  @override
  String yLost5(String opponent, String score) {
    return 'Natalo, $score, sa $opponent. Magbalik-lakas.';
  }

  @override
  String yLost6(String opponent, String score) {
    return '$score sa $opponent. Hindi kahiya-hiya, pero hindi sapat.';
  }

  @override
  String yLost7(String opponent, String score) {
    return 'Natalo, $score, sa $opponent. Matuto ka rito o nasayang lang.';
  }

  @override
  String yLost8(String opponent, String score) {
    return '$score sa $opponent at hindi man lang natin sila nasaktan.';
  }

  @override
  String yLost9(String opponent, String score) {
    return 'Natalo sa $opponent, $score. Parehong problema, parehong buwan, parehong dahilan na paparating.';
  }

  @override
  String yLost10(String opponent, String score) {
    return '$opponent $score. Kailan ba titigil ang pagiging malas na lang ito?';
  }

  @override
  String yLost11(String opponent, String score) {
    return 'Natalo, $score, sa $opponent. Resultang dapat may pagbabayaran ang isang tao.';
  }

  @override
  String yLostBadly0(String opponent, String score) {
    return '$score sa $opponent. Isang masamang gabi. Husgahan ang koponan sa buong kampanya, hindi dito.';
  }

  @override
  String yLostBadly1(String opponent, String score) {
    return 'Walang may mas ayaw sa $score laban sa $opponent kaysa sa mga manlalaro mismo.';
  }

  @override
  String yLostBadly2(String opponent, String score) {
    return '$opponent $score. Pangit, at hindi ito ang tunay na koponang ito.';
  }

  @override
  String yLostBadly3(String opponent, String score) {
    return 'Isang $score na dapat kalimutan laban sa $opponent. Babawi sila sa susunod.';
  }

  @override
  String yLostBadly4(String opponent, String score) {
    return '$score. Sa $opponent. Wala akong masabi at binabayaran akong magsalita.';
  }

  @override
  String yLostBadly5(String opponent, String score) {
    return '$opponent $score. May dapat sumagot diyan.';
  }

  @override
  String yLostBadly6(String opponent, String score) {
    return 'Gusto kong burahin ang $score laban sa $opponent sa talaan at sa alaala.';
  }

  @override
  String yLostBadly7(String opponent, String score) {
    return 'Natalo, $score, sa $opponent. Walang paraan para pagandahin ang iskor na iyan.';
  }

  @override
  String yLostBadly8(String opponent, String score) {
    return 'Hindi iyon pagkatalo sa $opponent, pagsuko iyon. $score.';
  }

  @override
  String yLostBadly9(String opponent, String score) {
    return '$score. Laban sa $opponent. May mga taong nagbayad para panoorin iyan.';
  }

  @override
  String yLostBadly10(String opponent, String score) {
    return '$opponent $score. Kapag hindi iyan nagpabago ng kahit ano, wala nang magpapabago.';
  }

  @override
  String yLostBadly11(String opponent, String score) {
    return 'Nakita ko nang napahiya ang koponang ito, pero bagong sahig ang $score sa $opponent.';
  }

  @override
  String yTrophy0(String opponent) {
    return 'KAMPEON. $opponent. Sabihin mo nang malakas.';
  }

  @override
  String yTrophy1(String opponent) {
    return 'Nanalo tayo. $opponent. Hindi ako okay.';
  }

  @override
  String yTrophy2(String opponent) {
    return '$opponent, at pauwi na ang tropeo.';
  }

  @override
  String yTrophy3(String opponent) {
    return 'Alamat ang bawat isa sa kanila. $opponent.';
  }

  @override
  String yRunnerUp0(String opponent) {
    return 'Kaunti na lang. $opponent at medalyang walang may gusto.';
  }

  @override
  String yRunnerUp1(String opponent) {
    return 'Runner-up sa $opponent. Masakit ito sa loob ng maraming taon.';
  }

  @override
  String yRunnerUp2(String opponent) {
    return '$opponent: isang laro na lang sa lahat.';
  }

  @override
  String yRunnerUp3(String opponent) {
    return 'Pangalawa. Sa $opponent. Pakipasa ang bote.';
  }

  @override
  String yEliminated0(String opponent) {
    return 'Lagas sa $opponent. Masakit iyon nang matagal.';
  }

  @override
  String yEliminated1(String opponent) {
    return 'Dito na nagtatapos ang $opponent para sa atin.';
  }

  @override
  String yEliminated2(String opponent) {
    return 'Tanggal sa $opponent. Ngayon ang imbestigasyon.';
  }

  @override
  String yEliminated3(String opponent) {
    return 'Nalaglag sa $opponent. May magpaliwanag nito sa akin.';
  }

  @override
  String yQualified0(String opponent) {
    return 'PUPUNTA TAYO SA $opponent.';
  }

  @override
  String yQualified1(String opponent) {
    return 'Nakapasok sa $opponent. Mag-leave na sa trabaho.';
  }

  @override
  String yQualified2(String opponent) {
    return '$opponent, narito na tayo. Hindi kailanman duda (puro duda talaga).';
  }

  @override
  String yQualified3(String opponent) {
    return 'Pasok sa $opponent. Tapos na ang pinakamahirap.';
  }

  @override
  String yGroupDrawn0(String opponent) {
    return 'Nabuo na ang grupo para sa $opponent. Puwedeng mas masahol. Puwedeng mas masahol pa nang husto.';
  }

  @override
  String yGroupDrawn1(String opponent) {
    return 'Ayan ang draw ng $opponent. Nakakaintriga.';
  }

  @override
  String yGroupDrawn2(String opponent) {
    return 'Labas na ang mga grupo ng $opponent at ayaw ko na agad sa atin.';
  }

  @override
  String yGroupDrawn3(String opponent) {
    return 'Tapos na ang draw ng $opponent. Simulan na ang overreaction.';
  }

  @override
  String yHostNamed0(String opponent) {
    return 'Ang $opponent ang magho-host. Mag-ipon na.';
  }

  @override
  String yHostNamed1(String opponent) {
    return 'Sa $opponent ito mapupunta. Predictable, pero okay.';
  }

  @override
  String yHostNamed2(String opponent) {
    return 'Sa $opponent napunta ang torneo. Congrats sa kanila, siguro.';
  }

  @override
  String yHostNamed3(String opponent) {
    return 'Kumpirmado ang host: $opponent.';
  }

  @override
  String yTournamentSoon0(String opponent) {
    return 'Malapit nang magsimula ang $opponent at hindi ako mapakali.';
  }

  @override
  String yTournamentSoon1(String opponent) {
    return 'Malapit na ang $opponent.';
  }

  @override
  String yTournamentSoon2(String opponent) {
    return 'Halos narito na ang $opponent. Ihayag na ang squad, pakiusap.';
  }

  @override
  String yTournamentSoon3(String opponent) {
    return 'Hindi na matiis ang countdown papunta sa $opponent.';
  }

  @override
  String get navY => 'Y';

  @override
  String get yTitle => 'Y';

  @override
  String get yEmpty => 'Wala pang masabi. Maglaro ng laban.';

  @override
  String get yEarlierHeading => 'Mas maaga ngayong cycle';

  @override
  String get yTraitLoyalist =>
      'Sumusuporta sa koponan anuman ang mangyari. Mabagal magbago ng isip, mabilis magpatawad.';

  @override
  String get yTraitCynic =>
      'Laging inaasahan ang pinakamasama at tuwang-tuwa kapag tama.';

  @override
  String get yTraitNostalgic =>
      'Mas maganda raw noon lahat. Sinusukat ka sa mga lalaking nagretiro na.';

  @override
  String get yTraitStatshead =>
      'Numero lang ang ipo-post at wala nang iba. Halos walang mood.';

  @override
  String get yTraitHypeman =>
      'Dalawang magandang resulta at gintong henerasyon na agad.';

  @override
  String get yTraitContrarian => 'Anuman ang akala ng lahat, kabaligtaran.';

  @override
  String get yTraitDoomer => 'Sasablay ito. Palaging sasablay ito.';

  @override
  String get yProfilePosts => 'MGA POST';

  @override
  String get yProfileEmpty => 'Wala pang post mula sa account na ito.';

  @override
  String hubEventGrievance(String player) {
    return 'Gusto kang makausap ni $player';
  }

  @override
  String get hubEventGrievanceSub =>
      'Gusto niyang malaman kung nasaan siya sa plano';

  @override
  String hubEventManagerSkills(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skill point na gagamitin',
      one: '1 skill point na gagamitin',
    );
    return '$_temp0';
  }

  @override
  String get hubEventManagerSkillsSub =>
      'Mas gumagaling ang koponan kapag gumaling ka';

  @override
  String get grievanceTitle => 'Isang usapan sa opisina mo';

  @override
  String grievanceGameTime(String player) {
    return 'Nasa squad si $player pero hindi pa nakasipa ng bola. Gusto niyang malaman kung bakit.';
  }

  @override
  String grievanceSquadPlace(String player) {
    return 'Wala si $player sa squad at hindi niya maintindihan. Gusto niyang masabihan, oo man o hindi.';
  }

  @override
  String grievanceRole(String player) {
    return 'Palaging nilalaro si $player sa maling posisyon at suko na siya rito.';
  }

  @override
  String get grievanceReassure => 'Kasama ka sa mga plano ko';

  @override
  String get grievanceHonest => 'Nasa likod ka ng iba, at ito ang dahilan';

  @override
  String get grievanceDismiss => 'Ako ang pumipili ng koponan';

  @override
  String yScorerStar0(String name, String goals) {
    return 'Si $name ang gumawa ng $goals sa mga iyon. Walang ibang malapit.';
  }

  @override
  String yScorerStar1(String name, String goals) {
    return '$goals para kay $name. Siya ang bumubuhat sa koponang ito.';
  }

  @override
  String yScorerStar2(String name, String goals) {
    return '$name: $goals ngayong araw. Grabeng manlalaro.';
  }

  @override
  String yScorerStar3(String name, String goals) {
    return 'Pinasok ni $name ang $goals sa kanila. Bow ka na.';
  }

  @override
  String yScorerStar4(String name, String goals) {
    return '$goals para kay $name, at pasahero lang ang iba.';
  }

  @override
  String yScorerStar5(String name, String goals) {
    return 'Si $name ulit. $goals. Isipin ang koponang ito nang wala siya.';
  }

  @override
  String yScorerStar6(String name, String goals) {
    return '$goals mula kay $name. Hindi dapat pasanin ng isang tao ang ganito kalaki.';
  }

  @override
  String yScorerStar7(String name, String goals) {
    return 'Kung wala si $name diyan, $goals na mas kaunti at ibang-iba ang hapon.';
  }

  @override
  String yWinStreak0(String count) {
    return '$count sunod-sunod. Anuman ang sinasabi sa dressing room na iyon, tumatalab.';
  }

  @override
  String yWinStreak1(String count) {
    return '$count na magkakasunod. Hindi nadadapa ang mga koponan sa ganitong takbo.';
  }

  @override
  String yWinStreak2(String count) {
    return '$count sunod-sunod at tuloy pa. Kita sa stands ang kumpiyansa.';
  }

  @override
  String yWinStreak3(String count) {
    return 'Walang talo sa $count. Itanong mo sa sinumang naging coach: iyan ang mahirap.';
  }

  @override
  String yWinStreak4(String count) {
    return '$count sunod-sunod. I-enjoy habang mabait ang iskedyul.';
  }

  @override
  String yWinStreak5(String count) {
    return '$count magkakasunod, at wala tayong natalong may halaga.';
  }

  @override
  String yWinStreak6(String count) {
    return 'Takbong $count. Tanungin mo ulit ako kapag nasubok na.';
  }

  @override
  String yWinStreak7(String count) {
    return '$count sunod-sunod. Bawat koponan ay may ganito minsan.';
  }

  @override
  String yLossStreak0(String count) {
    return '$count nang walang panalo. Darating ang oras na mauubusan ng dahilan.';
  }

  @override
  String yLossStreak1(String count) {
    return '$count sunod-sunod nang talo. Hindi na ito aberya lang.';
  }

  @override
  String yLossStreak2(String count) {
    return '$count sunod-sunod na talo. May dapat sumagot dito.';
  }

  @override
  String yLossStreak3(String count) {
    return 'Walang panalo sa $count. Makikita mo sa laro nila.';
  }

  @override
  String yLossStreak4(String count) {
    return '$count nang walang panalo at pare-parehong mali linggu-linggo.';
  }

  @override
  String yLossStreak5(String count) {
    return '$count sunod-sunod. Anuman ang sinusubukan, hindi ito gumagana.';
  }

  @override
  String yLossStreak6(String count) {
    return '$count magkakasunod. Direksyon ito, hindi lang pagbaba.';
  }

  @override
  String yLossStreak7(String count) {
    return 'Walang panalo sa $count, at walang nagsasalita sa itaas.';
  }

  @override
  String yRivalry0(String opponent, String score) {
    return '$opponent $score. Sabihin mo na ang gusto mo tungkol sa laro. Doble ang bilang nito.';
  }

  @override
  String yRivalry1(String opponent, String score) {
    return 'Laban sa $opponent pa. $score. Walang makakalimot dito.';
  }

  @override
  String yRivalry2(String opponent, String score) {
    return '$score laban sa $opponent. Ito ang pag-uusapan sa mga inuman.';
  }

  @override
  String yRivalry3(String opponent, String score) {
    return 'Magkapitbahay, $score. Tapos na ang yabangan sa ngayon.';
  }

  @override
  String yRivalry4(String opponent, String score) {
    return '$opponent $score. Anuman ang mangyari ngayong taon, mayroon itong isang ito.';
  }

  @override
  String yRivalry5(String opponent, String score) {
    return '$score laban sa $opponent. Mas kailangan ito ng ilan sa atin kaysa ng standings.';
  }

  @override
  String yRivalry6(String opponent, String score) {
    return '$opponent $score. At babawi sila sa susunod, lagi namang ganoon.';
  }

  @override
  String yRivalry7(String opponent, String score) {
    return 'Laban sa $opponent, $score. Isang buong taon ng pagpapaalala tungkol dito.';
  }

  @override
  String yInjuryBlow0(String name) {
    return 'Injured si $name. Iyan ang pinakahuling kailangan ng koponang ito.';
  }

  @override
  String yInjuryBlow1(String name) {
    return 'Nababago ang hugis ng lahat kapag nawala si $name.';
  }

  @override
  String yInjuryBlow2(String name) {
    return 'Paika-ika si $name. Pigil-hininga.';
  }

  @override
  String yInjuryBlow3(String name) {
    return 'Wala si $name nang ilang panahon, kung ganoon. May kailangang umangat.';
  }

  @override
  String yInjuryBlow4(String name) {
    return 'Wala si $name. Siyempre si $name pa.';
  }

  @override
  String yInjuryBlow5(String name) {
    return 'Kung wala si $name, napakaordinaryong koponan ito.';
  }

  @override
  String yInjuryBlow6(String name) {
    return 'Injured ulit si $name. May dapat magtanong kung bakit.';
  }

  @override
  String yInjuryBlow7(String name) {
    return 'Nawala si $name, at walang kapalit sa likod niya. Iyan ang tunay na problema.';
  }

  @override
  String ySentOff0(String name, String minute) {
    return 'Pula para kay $name sa $minute minuto at ang buong bansa ay bumabaling sa kanya. Higit pa ang naibigay niya sa atin kaysa sa karamihan. Tigilan na.';
  }

  @override
  String ySentOff1(String name, String minute) {
    return 'Tanggal si $name pagkalipas ng $minute minuto. Mabigat. Sampu na lang tayo pero lumaban pa rin, may ibig sabihin iyon.';
  }

  @override
  String ySentOff2(String name, String minute) {
    return '$name, $minute minuto, pulang kard. Sampung manlalaro na mula roon.';
  }

  @override
  String ySentOff3(String name, String minute) {
    return 'Sending off: $name sa $minute. Hindi ito ang unang laban na nabago ng isang desisyon.';
  }

  @override
  String ySentOff4(String name, String minute) {
    return 'Ang galing. Lumabas si $name sa $minute minuto at sampu na lang tayo. Ulit.';
  }

  @override
  String ySentOff5(String name, String minute) {
    return 'Pinalabas si $name pagkalipas ng $minute minuto. Sino ba ang humahawak ng disiplina rito?';
  }

  @override
  String ySentOff6(String name, String minute) {
    return '$minute minuto. Ganoon katagal napigil ni $name ang ulo niya. Propesyonal na football.';
  }

  @override
  String ySentOff7(String name, String minute) {
    return 'Pula para kay $name sa $minute minuto, at pinaniniwala akong progreso ito.';
  }

  @override
  String get yBoardPressure0 =>
      'Tumahimik nang husto ang board. Hindi kailanman magandang senyales iyan.';

  @override
  String get yBoardPressure1 =>
      'Balita, nagsimula nang magtanong ang boardroom.';

  @override
  String get yBoardPressure2 => 'Ramdam mo ang paggalaw ng lupa sa itaas.';

  @override
  String get yBoardPressure3 =>
      'Walang sinuman sa pederasyon ang nagsasabi ng suporta. Ikaw na ang bahalang magdesisyon.';

  @override
  String get yBoardPressure4 =>
      'Ilang linggo nang walang sumusuporta sa kanya sa publiko sa itaas.';

  @override
  String get yBoardPressure5 =>
      'Binabanatan ng pederasyon ang sarili nitong manager. Gaya ng dati.';

  @override
  String get yBoardPressure6 =>
      'Kapag tumahimik ang board, nakapagpasya na sila.';

  @override
  String get yBoardPressure7 =>
      'Hahayaan nilang maanod ito hanggang sa desisyon na ng iba.';

  @override
  String get yReplies => 'KARAGDAGAN TUNGKOL SA LARONG ITO';

  @override
  String get yPlayerGrievance0 =>
      'Nagtanong kung nasaan ako. Naghihintay pa rin ng sagot.';

  @override
  String get yPlayerGrievance1 =>
      'Nagsasanay nang mabuti. Wala na akong magagawa.';

  @override
  String get yPlayerGrievance2 =>
      'May mga tanong na isang beses mo lang matatanong.';

  @override
  String get yPlayerGrievance3 =>
      'Hindi ako lumayo para lang magbuhat ng mga bib.';

  @override
  String get playerHonoursTitle => 'MGA PARANGAL';

  @override
  String get awardGoldenBall => 'Golden Ball';

  @override
  String get awardGoldenBoot => 'Golden Boot';

  @override
  String get awardGoldenGlove => 'Golden Glove';

  @override
  String get awardTeamOfTournament => 'Team of the Tournament';

  @override
  String get awardPlayerOfYear => 'Manlalaro ng Taon sa Mundo';

  @override
  String get awardYoungPlayerOfYear => 'Batang Manlalaro ng Taon';

  @override
  String get playerClubHistory => 'KASAYSAYAN NG CLUB';

  @override
  String get playerCareerRecord => 'RECORD SA KARERA';

  @override
  String get playerInternationalGoals => 'Mga international goal';

  @override
  String get playerRecentForm => 'KAMAKAILANG PORMA';

  @override
  String get playerMatchHistory => 'KASAYSAYAN NG MGA LARO';

  @override
  String get playerAttributes => 'MGA KATANGIAN';

  @override
  String get playerUnknown => 'Hindi kilala';

  @override
  String get playerAttrPace => 'Bilis';

  @override
  String get playerAttrPhysical => 'Pisikal';

  @override
  String get playerAttrTechnical => 'Teknikal';

  @override
  String get playerAttrShooting => 'Shooting';

  @override
  String get playerAttrPassing => 'Pasa';

  @override
  String get playerAttrDribbling => 'Dribbling';

  @override
  String get playerAttrTackling => 'Tackling';

  @override
  String get playerAttrPositioning => 'Positioning';

  @override
  String get playerAttrComposure => 'Composure';

  @override
  String get playerAttrDecisions => 'Pagpapasya';

  @override
  String get playerAttrStamina => 'Stamina';

  @override
  String get playerAttrStrength => 'Lakas';

  @override
  String get playerStatCaps => 'Caps';

  @override
  String get playerStatGoals => 'Goal';

  @override
  String get playerStatAssists => 'Assist';

  @override
  String get playerStatAvgRating => 'Avg rating';

  @override
  String get playerStatForm => 'Porma';

  @override
  String get playerStatMotm => 'Player of Match';

  @override
  String get playerStatCleanSheets => 'Clean sheet';

  @override
  String get playerStatBestGame => 'Pinakamahusay na laro';

  @override
  String get playerStatCards => 'Mga kard';

  @override
  String playerCardsValue(int yellows, int reds) {
    return '${yellows}D ${reds}P';
  }

  @override
  String get tourSharedYourRun => 'TAKBO MO';

  @override
  String get tourSharedList => 'Listahan';

  @override
  String get tourSharedBracket => 'Bracket';

  @override
  String get tourSharedVs => 'vs';

  @override
  String tourSharedGroupSeed(String seed) {
    return 'Grupo $seed';
  }

  @override
  String get tourSharedThisEdition => 'Edisyong ito';

  @override
  String get tourSharedAllTime => 'Lahat ng panahon';

  @override
  String get tourSharedUnknown => 'Hindi kilala';

  @override
  String get tourSharedActive => 'ACTIVE';

  @override
  String get tourSharedMedalTable => 'TALAAN NG MEDALYA';

  @override
  String get tourSharedPastWinners => 'MGA DATING KAMPEON';

  @override
  String tourSharedHost(String host) {
    return 'Host: $host';
  }

  @override
  String get tourSharedBeat => 'tinalo';

  @override
  String get tourSharedPens => ' (pens)';

  @override
  String get tourSharedAwardsEmpty =>
      'Pagpapasyahan ang mga parangal kapag natapos na ang torneo.';

  @override
  String get tourSharedGoldenBall => 'GOLDEN BALL';

  @override
  String get tourSharedPlayerOfTournament => 'Manlalaro ng Torneo';

  @override
  String get tourSharedGoldenBoot => 'GOLDEN BOOT';

  @override
  String tourSharedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goal',
      one: '1 goal',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedGoldenGlove => 'GOLDEN GLOVE';

  @override
  String get tourSharedTeamOfTournament => 'TEAM OF THE TOURNAMENT';

  @override
  String get tourSharedStatsEmpty =>
      'Lalabas ang mga record kapag may kasaysayan na ang kompetisyon.';

  @override
  String get tourSharedRecordScorer => 'RECORD SCORER';

  @override
  String get tourSharedStillActive => 'aktibo pa';

  @override
  String get tourSharedMostTitles => 'PINAKAMARAMING TITULO';

  @override
  String tourSharedTitlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titulo',
      one: '1 titulo',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinals => 'PINAKAMARAMING FINAL';

  @override
  String tourSharedFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count final na nilaro',
      one: '1 final na nilaro',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostGamesPlayed => 'PINAKAMARAMING LARO';

  @override
  String tourSharedMatchesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count laro',
      one: '1 laro',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedMostFinalsPlayed => 'PINAKAMARAMING FINALS NA NILARO';

  @override
  String tourSharedFinalsTournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finals tournament',
      one: '1 finals tournament',
    );
    return '$_temp0';
  }

  @override
  String get tourSharedBiggestFinalWin => 'PINAKAMALAKING PANALO SA FINAL';

  @override
  String tourStatsGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goal',
      one: '1 goal',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsStillActive => 'aktibo pa';

  @override
  String tourStatsTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titulo',
      one: '1 titulo',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsContested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count final na nilaro',
      one: '1 final na nilaro',
    );
    return '$_temp0';
  }

  @override
  String tourStatsMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count laro',
      one: '1 laro',
    );
    return '$_temp0';
  }

  @override
  String tourStatsFinalsTournaments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finals tournament',
      one: '1 finals tournament',
    );
    return '$_temp0';
  }

  @override
  String get tourStatsLeaders => 'MGA LIDER SA LAHAT NG PANAHON';

  @override
  String get tourStatsTabGames => 'Laro';

  @override
  String get tourStatsTabCups => 'Cup';

  @override
  String get tourStatsTabScorers => 'Scorer';

  @override
  String tourSharedFinalWinDetail(String opponent, int year) {
    return 'v $opponent · $year';
  }

  @override
  String get tourHolders => 'KASALUKUYANG KAMPEON';

  @override
  String tourHoldersSince(int year) {
    return 'nanalo noong $year';
  }

  @override
  String get tourSharedAllTimeScorers => 'MGA SCORER SA LAHAT NG PANAHON';

  @override
  String get tourSharedSummaryEmpty =>
      'Lalabas ang host at mga istadyum kapag na-draw na ang edisyong ito.';

  @override
  String get tourSharedHostHeading => 'HOST';

  @override
  String get tourSharedHostsHeading => 'MGA HOST';

  @override
  String get tourSharedCoHostsHeading => 'MGA CO-HOST';

  @override
  String get tourSharedVenues => 'MGA VENUE';

  @override
  String get tourSharedMascot => 'MASCOT';

  @override
  String get tourSharedMatchBall => 'BOLA NG LARO';

  @override
  String tourSharedVenueSeats(String city, String capacity) {
    return '$city · $capacity upuan';
  }

  @override
  String get tourSharedCouldNotLoad => 'Hindi ma-load.';

  @override
  String get tourSharedHostTbc => 'KUKUMPIRMAHIN PA ANG HOST';

  @override
  String get tourSharedFinalsAreHere => 'NARITO NA ANG FINALS';

  @override
  String tourSharedHostedBy(String hosts) {
    return 'HOST:  $hosts';
  }

  @override
  String get tourSharedLetFinalsBegin => 'Simulan na ang finals';

  @override
  String get tourSharedCompetitions => 'MGA KOMPETISYON';

  @override
  String get tourSharedWorldRanking => 'Pandaigdigang ranking';

  @override
  String get tourSharedCouldNotLoadTournaments =>
      'Hindi ma-load ang mga torneo.';

  @override
  String get tourSharedPrestigeStage => 'YUGTO NG PRESTIHIYO';

  @override
  String get tourSharedOverview => 'Pangkalahatang-tanaw';

  @override
  String get tourSharedWorldRankingTitle => 'Pandaigdigang Ranking';

  @override
  String get tourSharedYourCompetitions => 'MGA KOMPETISYON MO';

  @override
  String get tourSharedOtherContinents => 'IBANG KONTINENTE';

  @override
  String get tourSharedComingSoon => 'Parating pa lang ang torneo';

  @override
  String get tourSharedSoon => 'MALAPIT NA';

  @override
  String get tourSharedNoQualifyingDraw => 'Walang draw ng kwalipikasyon.';

  @override
  String get tourSharedOpenEnvelope => 'Buksan ang sobre';

  @override
  String tourSharedGroupName(String name) {
    return 'GRUPO $name';
  }

  @override
  String get tourSharedBall => 'Bola';

  @override
  String get tourSharedPot => 'Pot';

  @override
  String get tourSharedAll => 'Lahat';

  @override
  String get tourSharedTapDrawTeam =>
      'I-tap para i-draw ang susunod na koponan';

  @override
  String get tourSharedTapDrawPot => 'I-tap para i-draw ang susunod na pot';

  @override
  String get tourSharedTapDrawAll => 'I-tap para ibunyag ang buong draw';

  @override
  String get tourSharedContinue => 'Magpatuloy';

  @override
  String get tourSharedPause => 'I-pause';

  @override
  String get tourSharedPlay => 'I-play';

  @override
  String get tourSharedSkip => 'Laktawan';

  @override
  String tourSharedPotNumber(int number) {
    return 'POT $number';
  }

  @override
  String get tourSharedDrawComplete => 'TAPOS NA ANG DRAW';

  @override
  String get tourSharedDrawing => 'NAGDO-DRAW…';

  @override
  String get tourContChampionship => 'KAMPEONATO';

  @override
  String get tourContTabSummary => 'BUOD';

  @override
  String get tourContTabQualifying => 'KWALIPIKASYON';

  @override
  String get tourContTabFinals => 'FINALS';

  @override
  String get tourContTabBracket => 'BRACKET';

  @override
  String get tourContTabAwards => 'MGA PARANGAL';

  @override
  String get tourContTabScorers => 'MGA SCORER';

  @override
  String get tourContTabHistory => 'KASAYSAYAN';

  @override
  String get tourContTabRecords => 'MGA RECORD';

  @override
  String tourContCouldNotLoadCup(String error) {
    return 'Hindi ma-load ang cup.\n$error';
  }

  @override
  String get tourContNoCupData => 'Walang data ng cup.';

  @override
  String get tourContUnknown => 'Hindi kilala';

  @override
  String get tourContGroupsToBeDrawnQual =>
      'Ida-draw ang mga grupo ng kwalipikasyon sa seremonya. Manood mula sa Home para makita ang makakalaban mo.';

  @override
  String get tourContQualSeeded =>
      'Seeded ang bansa mo diretso sa finals. Walang kwalipikasyon ngayong cycle.';

  @override
  String tourContBackgroundRegion(String name) {
    return 'Sini-simulate ang $name sa background. Lalabas dito ang mga resulta habang nilalaro ang bawat round.';
  }

  @override
  String get tourContGroupsToBeDrawnFinals =>
      'Ida-draw ang mga grupo ng finals sa seremonya. Manood mula sa Home para makita ang grupo mo.';

  @override
  String get tourContFinalsDrawAfterQual =>
      'Gagawin ang finals draw kapag tapos na ang kwalipikasyon.';

  @override
  String get tourContContestedBeforeWc =>
      'Lalaruin ang mga knockout round bago ang Kampeonato ng Mundo.';

  @override
  String tourContChampionsHeading(String name) {
    return 'KAMPEON NG $name';
  }

  @override
  String tourContWinnersTitle(String name) {
    return 'Mga nanalo sa $name';
  }

  @override
  String get tourContNoGoalsYet => 'Wala pang naiskor na goal.';

  @override
  String tourContGroupHeading(String name) {
    return 'GRUPO $name';
  }

  @override
  String get tourContBestRunnersUp => 'PINAKAMAHUSAY NA RUNNER-UP';

  @override
  String tourContGroupDropdown(String name) {
    return 'Grupo $name';
  }

  @override
  String get tourContMatches => 'MGA LARO';

  @override
  String get tourContNoGroupsDrawn => 'Wala pang na-draw na grupo.';

  @override
  String get tourContQualifyingDraw => 'DRAW NG KWALIPIKASYON';

  @override
  String get tourContWorldQualifyingDraw =>
      'PANDAIGDIGANG DRAW NG KWALIPIKASYON';

  @override
  String get tourContFinalsDraw => 'DRAW NG FINALS';

  @override
  String get tourContSeedingPots => 'MGA SEEDING POT';

  @override
  String get tourContGroupDraw => 'DRAW NG GRUPO';

  @override
  String tourContCouldNotLoadDraw(String error) {
    return 'Hindi ma-load ang draw.\n$error';
  }

  @override
  String get tourContDrawNotReady => 'Hindi pa handa ang draw.';

  @override
  String get tourContContinentalClash => 'CONTINENTAL CLASH';

  @override
  String get tourContTabThisCycle => 'ITONG CYCLE';

  @override
  String tourContCouldNotLoadClash(String error) {
    return 'Hindi ma-load.\n$error';
  }

  @override
  String get tourContNoSaveFound => 'Hindi nahanap ang save.';

  @override
  String get tourContClashSoon =>
      'Lalaruin ang Continental Clash kapag kilala na ang dalawang kampeon ng kontinente.';

  @override
  String get tourContTwoContinentsOneMatch => 'DALAWANG KONTINENTE, ISANG LARO';

  @override
  String get tourContVersusShort => 'vs';

  @override
  String tourContWinTheClash(String name) {
    return 'Panalo ang $name sa Clash';
  }

  @override
  String get tourContNoClashYet => 'Wala pang Continental Clash na nalaro.';

  @override
  String get tourContNationsCup => 'NATIONS CUP';

  @override
  String get tourContTabLeagues => 'MGA LIGA';

  @override
  String get tourContTabFinalsFour => 'FINAL FOUR';

  @override
  String tourContCouldNotLoad(String error) {
    return 'Hindi ma-load.\n$error';
  }

  @override
  String get tourContNoNationsCupGoals =>
      'Wala pang naitalang goal sa Nations Cup.';

  @override
  String get tourContNoNationsCupChampions =>
      'Wala pang kinoronahang kampeon ng Nations Cup.';

  @override
  String get tourContNationsCupOffSeason =>
      'Magsisimula ang Nations Cup ng cycle na ito pagkatapos ng mga continental finals. Nasa History ang mga nakaraang nagwagi.';

  @override
  String get tourContNationsCupGroupsSoon =>
      'Ida-draw ang mga grupo ng Nations Cup ng cycle na ito sa seremonya. Manood mula sa Home para malaman kung sino ang kakaharapin mo.';

  @override
  String get tourContLeagueNoGroups =>
      'Walang laro sa liga na ito ngayong round.';

  @override
  String tourContLeagueHeading(String letter) {
    return 'LIGA $letter';
  }

  @override
  String tourContLeagueHeadingYours(String letter) {
    return 'LIGA $letter · ANG LIGA MO';
  }

  @override
  String get tourContFinalsFourSoon =>
      'Paglalabanan ng mga nanalo sa grupo ng Liga A ang Final Four kapag tapos na ang group stage.';

  @override
  String tourContLeagueChip(String letter) {
    return 'Liga $letter';
  }

  @override
  String tourContLeagueChipStar(String letter) {
    return 'Liga $letter ★';
  }

  @override
  String get tourContSemiFinals => 'SEMIFINAL';

  @override
  String get tourContFinal => 'FINAL';

  @override
  String get tourContNationsCupDraw => 'DRAW NG NATIONS CUP';

  @override
  String get tourContIntercontinentalPlayoff => 'INTERCONTINENTAL PLAY-OFF';

  @override
  String get tourContNoPlayoffThisCycle => 'Walang play-off sa cycle na ito.';

  @override
  String get tourContPlayoffIntro =>
      'Dalawang puwesto sa Kampeonato ng Mundo ang paglalabanan sa knockout ng pinakamahuhusay na bigong nag-qualify.';

  @override
  String get tourContPlayoffThrough =>
      'Nakalusot ka sa play-off. Kasali ka na sa Kampeonato ng Mundo!';

  @override
  String get tourContPlayoffOut =>
      'Kinulang ka sa play-off. Walang Kampeonato ng Mundo para sa iyo ngayon.';

  @override
  String get tourContContinue => 'Magpatuloy';

  @override
  String get tourContPlayoffFinals => 'MGA FINAL NG PLAY-OFF';

  @override
  String get tourContPlayoffSeeded => 'Seeded (bye)';

  @override
  String get tourCupTabSummary => 'BUOD';

  @override
  String get tourCupTabQualifying => 'KWALIPIKASYON';

  @override
  String get tourCupTabPlayoff => 'PLAY-OFF';

  @override
  String get tourCupPlayoffSoon =>
      'Malalaman ang intercontinental play-off kapag tapos na ang kwalipikasyon ng bawat kompederasyon.';

  @override
  String get tourCupTabFinals => 'FINALS';

  @override
  String get tourCupTabBracket => 'BRACKET';

  @override
  String get tourCupTabAwards => 'MGA PARANGAL';

  @override
  String get tourCupTabScorers => 'MGA SCORER';

  @override
  String get tourCupTabHistory => 'KASAYSAYAN';

  @override
  String get tourCupTabRecords => 'MGA RECORD';

  @override
  String get tourCupTitle => 'KAMPEONATO NG MUNDO';

  @override
  String get tourCupNoData => 'Walang datos ng cup.';

  @override
  String tourCupLoadError(String error) {
    return 'Hindi ma-load ang cup.\n$error';
  }

  @override
  String get tourCupUnknown => 'Hindi kilala';

  @override
  String get tourCupWorldChampions => 'MGA KAMPEON NG MUNDO';

  @override
  String get tourCupWorldChampionsTitle => 'Mga Kampeon ng Mundo';

  @override
  String get tourCupStillActive => 'Aktibo pa';

  @override
  String get tourCupAllTimeScorers => 'PINAKAMARAMING GOAL SA KASAYSAYAN';

  @override
  String get tourCupAllConfederations => 'Lahat ng kompederasyon';

  @override
  String get tourCupBestRunnersUp => 'Pinakamahuhusay na runner-up';

  @override
  String get tourCupCompWorld => 'Kampeonato ng Mundo';

  @override
  String get tourCupCompEurope => 'Kampeonato ng Europa';

  @override
  String get tourCupCompSAmerica => 'Copa ng Timog Amerika';

  @override
  String get tourCupDestRoundOf16 => 'Round of 16';

  @override
  String get tourCupDestKnockouts => 'knockout';

  @override
  String get tourCupDestFinals => 'finals';

  @override
  String get tourCupDestFinalsPlayoff => 'finals play-off';

  @override
  String get tourCupDestIntercontPlayoff => 'intercontinental play-off';

  @override
  String get tourCupFinalsDrawnAfterQual =>
      'Ida-draw ang mga grupo ng finals kapag tapos na ang kwalipikasyon.';

  @override
  String get tourCupFinalsDrawSoon =>
      'Hindi pa na-draw ang mga grupo. Panoorin ang draw ng Kampeonato ng Mundo mula sa Home para malaman ang mga ito.';

  @override
  String tourCupGroupName(String name) {
    return 'Grupo $name';
  }

  @override
  String tourCupGroupNameShort(String name) {
    return 'Grupo $name';
  }

  @override
  String tourCupHostLabel(String host) {
    return 'Host: $host';
  }

  @override
  String tourCupHostLabelMulti(String hosts) {
    return 'Mga host: $hosts';
  }

  @override
  String get tourCupIntercontPlayoff => 'Intercontinental play-off';

  @override
  String get tourCupKnockoutSoon =>
      'Magsisimula ang bracket kapag tapos na ang group stage.';

  @override
  String get tourCupMatches => 'MGA LARO';

  @override
  String get tourCupMedalTable => 'TALAAN NG MEDALYA';

  @override
  String get tourCupMostTitles => 'PINAKAMARAMING TITULO';

  @override
  String tourCupMostTitlesValue(String nation, int titles, int editions) {
    return '$nation: $titles titulo sa $editions edisyon';
  }

  @override
  String get tourCupNoGoals => 'Wala pang goal.';

  @override
  String get tourCupNoGroups => 'Wala pang na-draw na grupo.';

  @override
  String get tourCupNoHistory => 'Wala pang kasaysayan.';

  @override
  String get tourCupPastWinners => 'MGA DATING KAMPEON';

  @override
  String get tourCupPlayoffIntro =>
      'Dalawang puwesto sa Kampeonato ng Mundo ang paglalabanan sa knockout ng pinakamahuhusay na bigong nag-qualify.';

  @override
  String get tourCupQualDrawSoon =>
      'Hindi pa na-draw ang mga grupo. Panoorin ang draw ng kwalipikasyon mula sa Home para malaman ang mga ito.';

  @override
  String tourCupRegionYours(String region) {
    return '$region · iyo';
  }

  @override
  String tourCupScorePens(int home, int away) {
    return '$home–$away (pens)';
  }

  @override
  String get tourCupSegAllTime => 'Lahat ng panahon';

  @override
  String get tourCupSegFinals => 'Finals';

  @override
  String get tourCupSegQualifying => 'Kwalipikasyon';

  @override
  String get playerTraitsTitle => 'KILALA SA';

  @override
  String get traitBigGame => 'Pang-malalaking laro';

  @override
  String get traitBigGameBlurb => 'Mas gumagaling sa mga knockout na laban.';

  @override
  String get traitSetPiece => 'Eksperto sa set piece';

  @override
  String get traitSetPieceBlurb =>
      'Mas mahusay na tira at mas maraming goal mula sa dead ball.';

  @override
  String get traitHothead => 'Mainitin ang ulo';

  @override
  String get traitHotheadBlurb =>
      'Mas madalas makakuha ng kard kaysa sa mga kakampi.';

  @override
  String get traitIronMan => 'Iron man';

  @override
  String get traitIronManBlurb =>
      'Bihirang ma-injure at mas hindi agad napapagod.';

  @override
  String get traitWonderkid => 'Wonderkid';

  @override
  String get traitWonderkidBlurb =>
      'Bata pa, magaling na, at mabilis pang gumagaling.';

  @override
  String get traitLeader => 'Lider';

  @override
  String get traitLeaderBlurb =>
      'Pinapalakas ang loob ng bawat kakampi sa pitch.';

  @override
  String get traitPacey => 'Mabilis';

  @override
  String get traitPaceyBlurb =>
      'Nakakapasong bilis, banta sa likod ng depensa.';

  @override
  String get traitOldHead => 'Beterano';

  @override
  String get traitOldHeadBlurb =>
      'Beteranong mas matagal ang talino sa laro kaysa sa lakas ng mga binti.';

  @override
  String get traitWasteful => 'Aksaya';

  @override
  String get traitWastefulBlurb =>
      'Maraming magagandang tsansa ang nasasayang niya.';

  @override
  String get objectiveWorldCup => 'Kampeonato ng Mundo';

  @override
  String get objectiveWinTournament => 'Ipanalo ito';

  @override
  String get objectiveQualifyGeneric => 'Mag-qualify';

  @override
  String hubBoardObjectiveFor(String competition, String label) {
    return '$competition: $label';
  }

  @override
  String get objectiveWinWorldCup => 'Ipanalo ang Kampeonato ng Mundo';

  @override
  String get objectiveReachFinal => 'Umabot sa final';

  @override
  String get objectiveReachSemis => 'Umabot sa semifinal';

  @override
  String get objectiveReachQuarters => 'Umabot sa quarterfinal';

  @override
  String get objectiveReachKnockouts => 'Umabot sa knockout rounds';

  @override
  String get objectiveQualify => 'Mag-qualify sa Kampeonato ng Mundo';

  @override
  String get finishChampions => 'Kampeon';

  @override
  String get finishRunnersUp => 'Runner-up';

  @override
  String get finishSemiFinals => 'Semifinal';

  @override
  String get finishQuarterFinals => 'Quarterfinal';

  @override
  String get finishRoundOf16 => 'Round of 16';

  @override
  String get finishGroupStage => 'Group stage';

  @override
  String get objectiveQualifyingTopHalf =>
      'Tapusin sa itaas na kalahati ng kwalipikasyon';

  @override
  String get finishQualifyingTopHalf =>
      'Itaas na kalahati ng grupo ng kwalipikasyon';

  @override
  String get finishQualifyingBottomHalf =>
      'Ibabang kalahati ng grupo ng kwalipikasyon';

  @override
  String get objectiveNcWinIt => 'Ipanalo ang Nations Cup';

  @override
  String get objectiveNcReachFinal => 'Umabot sa final ng Nations Cup';

  @override
  String get objectiveNcFinalsFour => 'Umabot sa Final Four';

  @override
  String get objectiveNcWinGroup => 'Manguna sa grupo at umangat';

  @override
  String get objectiveNcTopHalf => 'Tapusin sa itaas na kalahati ng grupo';

  @override
  String get objectiveNcSurvive => 'Iwasan ang relegation';

  @override
  String get finishNcChampions => 'Mga kampeon ng Nations Cup';

  @override
  String get finishNcFinalsFour => 'Final Four';

  @override
  String get finishNcGroupWinners => 'Nanguna sa grupo';

  @override
  String get finishNcTopHalf => 'Itaas na kalahati ng grupo';

  @override
  String get finishNcStayedUp => 'Nanatili sa liga';

  @override
  String get finishNcBottom => 'Sa ilalim ng grupo';

  @override
  String get careerNationsCupLabel => 'Nations Cup';

  @override
  String get squadDevPlayer => 'MANLALARO';

  @override
  String get squadDevAge => 'EDAD';

  @override
  String get squadDevPosition => 'POS';

  @override
  String get squadDevChange => 'RATING';

  @override
  String get squadDevNew => 'BAGO';

  @override
  String get squadDevRetired => 'RETIRADO';

  @override
  String get squadDevEmpty => 'Tahimik na taon. Walang pagbabago sa squad.';

  @override
  String get squadDevTierRegulars => 'MGA REGULAR';

  @override
  String get squadDevTierFringe => 'MGA FRINGE';

  @override
  String get squadDevTierYouth => 'KABATAAN';

  @override
  String get boardObjectivesTitle => 'Mga layunin ng board';

  @override
  String get boardObjectivesConfidence => 'Tiwala ng board';

  @override
  String boardObjectiveBeatenBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: '$rounds round na mas mataas sa hiniling',
      one: 'isang round na mas mataas sa hiniling',
    );
    return '$result: $_temp0';
  }

  @override
  String boardObjectiveShortBy(String result, int rounds) {
    String _temp0 = intl.Intl.pluralLogic(
      rounds,
      locale: localeName,
      other: 'kulang ng $rounds round',
      one: 'kulang ng isang round',
    );
    return '$result: $_temp0';
  }

  @override
  String get boardObjectivesPending => 'HINDI PA NAPAPASYAHAN';

  @override
  String boardObjectiveSoFar(String result) {
    return 'SA NGAYON · $result';
  }

  @override
  String get boardObjectivesEmpty =>
      'Wala pang inilatag na layunin ang board para sa cycle na ito.';

  @override
  String get tourContBestWinners => 'PINAKAMAHUSAY NA NANGUNA SA GRUPO';

  @override
  String get tourContBestThirds => 'PINAKAMAHUSAY NA IKATLO';

  @override
  String tourContBestPlaced(String position) {
    return 'PINAKAMAHUSAY NA IKA-$position PUWESTO';
  }

  @override
  String squadDevPageOf(String page, String pages, String total) {
    return '$page/$pages · $total manlalaro';
  }

  @override
  String get matchSoldOut => 'UBOS ANG TIKET';

  @override
  String matchAttendanceOf(String attendance, String capacity) {
    return '$attendance sa $capacity upuan ang puno';
  }

  @override
  String get matchGroundTitle => 'VENUE';

  @override
  String get absenceInjured => 'Injured';

  @override
  String get absenceSuspended => 'Suspendido';

  @override
  String absenceWeeks(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString linggo',
      one: '1 linggo',
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
      other: '$countString laro',
      one: '1 laro',
    );
    return '$_temp0';
  }

  @override
  String absenceBackFor(String opponent) {
    return 'Balik para sa $opponent';
  }

  @override
  String get penaltyOrderTitle => 'Mga penalty';

  @override
  String get penaltyOrderBlurb =>
      'Pangalanan ang limang kukuha, ayon sa pagkakasunod. I-tap ang slot para palitan.';

  @override
  String penaltyOrderPick(int number) {
    return 'Tira $number';
  }

  @override
  String get penaltyOrderPickBlurb =>
      'Piliin kung sino ang tatayo sa spot. Ipinapakita ng bar ang kalmado niya sa penalty.';

  @override
  String get penaltyOrderConfirm => 'Simulan';

  @override
  String get penaltyOrderCancel => 'Bumalik';

  @override
  String get youthTitle => 'Kabataan';

  @override
  String get youthEmptyLevel => 'Wala pang tao sa antas na ito.';

  @override
  String get youthReleased => 'Pinakawalan ngayong taon';

  @override
  String get u21Title => 'Under-21';

  @override
  String get u21Blurb =>
      'Ang susunod na henerasyon, nangunguna ang pinakamahusay na prospect. Ang mga guwang na bituin ay tantiya lang ng scout. Bigyan ng cap ang manlalaro para malaman kung ano talaga ang kaya niya.';

  @override
  String get u21Empty =>
      'Walang under-21 sa pool ngayon. Darating ang susunod na intake sa bagong cycle.';

  @override
  String u21Breakout(int gain) {
    return '+$gain TAONG ITO';
  }

  @override
  String u21AgeCaps(int age, int caps) {
    return 'Edad $age · $caps caps';
  }

  @override
  String u21AgeUncapped(int age) {
    return 'Edad $age · wala pang cap';
  }

  @override
  String get u21CallUps => 'Pumunta sa mga call-up';

  @override
  String get youthWatching => 'Binabantayan';

  @override
  String get youthWatchEmpty =>
      'Wala pang minamarkahan. Markahan ang isang bata sa kahit anong antas at lalabas siya rito, kasama ang narating niya mula noon.';

  @override
  String get youthWatchMark => 'Subaybayan ang batang ito';

  @override
  String get youthWatchUnmark => 'Itigil ang pagsubaybay';

  @override
  String youthWatchMarked(int rating, int age) {
    return 'Minarkahan sa $rating, edad $age';
  }

  @override
  String get youthWatchSenior => 'Umakyat na sa senior pool';

  @override
  String get youthWatchReleased => 'Pinakawalan ng akademya';

  @override
  String get youthWatchGone => 'Wala na sa pyramid';

  @override
  String get tacticsYouth => 'Under-21';

  @override
  String get pressSquad => 'Squad';

  @override
  String get pressBoard => 'Board';

  @override
  String get pressNoEffect => 'Walang masyadong nag-iisip dito';

  @override
  String get matchNeutralGround => 'NEUTRAL';

  @override
  String get matchExtraTimeAhead => 'EXTRA TIME';

  @override
  String get matchExtraTimeHalf => 'EXTRA TIME · HALF-TIME';

  @override
  String get matchClockFullTime => 'FULL-TIME';

  @override
  String get matchClockAfterExtraTime => 'PAGKATAPOS NG EXTRA TIME';

  @override
  String get matchClockPenalties => 'PENALTY';

  @override
  String get matchClockFullTimePenalties => 'FULL-TIME · PENALTY';

  @override
  String get hubEventPressConference => 'Harapin ang media';

  @override
  String get hubEventPressConferenceSub =>
      'Gusto kang makausap ng media ng buong mundo bago ang unang laro mo';

  @override
  String get squadDevWonderkid => 'WONDERKID';

  @override
  String get tacticsPlaystyle => 'Istilo ng laro';

  @override
  String get tacticsPlaystyleBlurb =>
      'Piliin kung paano maglalaro ang koponan; ang mga dial sa ibaba ang magpapino rito.';

  @override
  String get tacticsPlaystyleCustom =>
      'Sarili mong setting. Walang pinangalanang istilo na tugma sa mga dial na ito.';

  @override
  String get playstyleCustom => 'Custom';

  @override
  String get playstyleBalanced => 'Balanse';

  @override
  String get playstylePossession => 'Possession';

  @override
  String get playstyleGegenpress => 'Gegenpress';

  @override
  String get playstyleCounter => 'Counter-attack';

  @override
  String get playstyleDirect => 'Diretso';

  @override
  String get playstyleLowBlock => 'Low block';

  @override
  String get playstyleWingPlay => 'Laro sa gilid';

  @override
  String get playstyleBalancedBlurb =>
      'Matatag sa magkabilang kalahati, walang labis.';

  @override
  String get playstylePossessionBlurb =>
      'Hawakan ang bola, ipasa nang matiyaga, paliitin ang pitch.';

  @override
  String get playstyleGegenpressBlurb =>
      'Bawiin agad ang bola pagkawala nito, sa mataas na bahagi ng pitch.';

  @override
  String get playstyleCounterBlurb =>
      'Umatras, manatiling siksik, saka umatake nang mabilis.';

  @override
  String get playstyleDirectBlurb =>
      'Pasulong agad at habulin ang pangalawang bola.';

  @override
  String get playstyleLowBlockBlurb =>
      'Malalim, makitid at napakahirap lusutan.';

  @override
  String get playstyleWingPlayBlurb =>
      'Palawakin ang pitch, umikot sa gilid at mag-cross.';

  @override
  String get nationsRandomTeam => 'Random na koponan';

  @override
  String get nationsFromTheBottom => 'Mula sa ilalim';

  @override
  String get bottomStartTitle => 'Walang trabaho';

  @override
  String get bottomStartHeading =>
      'Tatlong pederasyon ang gustong makipag-usap';

  @override
  String get bottomStartBlurb =>
      'Wala kang trabaho at wala kang reputasyon. Ito lang ang mga koponang handang sumugal sa iyo. Pumili ng isa at bumuo ng kung ano mula sa wala.';

  @override
  String get bottomStartAccept => 'Tanggapin';

  @override
  String get bottomStartBack => 'Bumalik sa menu';

  @override
  String bottomStartRankOf(int rank, int total) {
    return 'Ika-$rank sa $total sa mundo';
  }

  @override
  String get campTitle => 'Base camp';

  @override
  String campBasedIn(String host) {
    return 'Nakabase sa $host';
  }

  @override
  String get campBlurb =>
      'Dito titira ang squad sa buong torneo. Hindi na ito mapapalitan kapag nagsimula na ang laro, at tatlong bagay ang naaapektuhan nito sa bawat laban: gaano sila kasariwa pagdating, gaano kabilis gumaling ang pinsala, at gaano sila katalas.';

  @override
  String get campEffectTravel => 'Sariwa pagdating';

  @override
  String get campEffectRecovery => 'Gumagaling ang injury';

  @override
  String get campEffectSharpness => 'Talas sa laro';

  @override
  String get campTerrainCity => 'Sentro ng lungsod';

  @override
  String get campTerrainCoastal => 'Resort sa baybayin';

  @override
  String get campTerrainMountain => 'Pahingahan sa bundok';

  @override
  String get campTerrainAltitude => 'Altitude camp';

  @override
  String get campTerrainNationalCentre => 'National centre';

  @override
  String get campTerrainCityBlurb =>
      'Nasa kalapit ang lahat at walang kailangang bumiyahe, pero walang katahimikan at walang takas sa ingay.';

  @override
  String get campTerrainCoastalBlurb =>
      'Kalmado, komportable at mabuti para sa mood; mahabang biyahe sa bus papunta sa bawat stadium.';

  @override
  String get campTerrainMountainBlurb =>
      'Malamig na hangin at pangunahing medical set-up na mabilis magpagaling ng pinsala, malayo sa torneo.';

  @override
  String get campTerrainAltitudeBlurb =>
      'Mahirap mag-ensayo rito, pero tumatagal ang lakas ng mga binti hanggang sa dulo ng torneo.';

  @override
  String get campTerrainNationalCentreBlurb =>
      'Ang sariling pasilidad ng pederasyon: walang kahanga-hanga, pero walang masisira.';

  @override
  String get hubEventChooseCamp => 'Piliin ang base camp';

  @override
  String hubEventChooseCampSub(String host) {
    return 'Kung saan magbabase ang squad sa $host';
  }

  @override
  String get tacticsTabBench => 'Bench';

  @override
  String get squadSearchHint => 'Maghanap ayon sa pangalan o club';

  @override
  String get squadFilterAll => 'Lahat';

  @override
  String get squadFilterInSquad => 'Nasa squad';

  @override
  String get squadFilterUncapped => 'Walang cap';

  @override
  String get squadFilterUnavailable => 'Hindi available';

  @override
  String get squadLineAll => 'Lahat ng linya';

  @override
  String get squadSortBy => 'Ayusin';

  @override
  String get squadSortRating => 'Rating';

  @override
  String get squadSortCaps => 'Caps';

  @override
  String get squadSortGoals => 'Goal';

  @override
  String get squadSortAge => 'Edad';

  @override
  String get squadSortName => 'Pangalan';

  @override
  String get squadLegendTitle => 'Ibig sabihin ng mga marka';

  @override
  String get squadLegendStarting => 'Nasa panimulang XI mo';

  @override
  String get squadLegendCalledUp => 'Tinawag, nasa bench';

  @override
  String get squadLegendRatingUp => 'Tumataas ang rating ngayong taon';

  @override
  String get squadLegendRatingDown => 'Bumababa ang rating ngayong taon';

  @override
  String get squadLegendInjured => 'Injured, hindi available';

  @override
  String get squadLegendSuspended => 'Suspendido, hindi available';

  @override
  String get squadLegendTraits => 'KILALA SA';

  @override
  String squadShowingOf(int shown, int total) {
    return 'Ipinapakita ang $shown sa $total manlalaro';
  }

  @override
  String get squadNobodyMatches =>
      'Walang manlalaro sa pool na tugma sa mga filter na iyon.';

  @override
  String get squadStatPool => 'Pool';

  @override
  String get squadStatInSquad => 'Tinawag';

  @override
  String get squadMostCapped => 'Pinakamaraming caps';

  @override
  String get squadTopScorer => 'Top scorer';

  @override
  String squadCapsValue(String name, int caps) {
    return '$name · $caps caps';
  }

  @override
  String squadGoalsValue(String name, int goals) {
    return '$name · $goals goal';
  }

  @override
  String squadAgeClub(int age, String club) {
    return '$age · $club';
  }

  @override
  String get squadCapsShort => 'Caps';

  @override
  String get squadGoalsShort => 'Goal';

  @override
  String get recordsRecordBookSubtitle =>
      'Mga caps, goal at pangunahing record ng koponan';

  @override
  String get statsLegacy => 'LEGACY';

  @override
  String tacticsSubAlreadyOff(String name) {
    return 'Napalitan na si $name at hindi na maaaring bumalik.';
  }

  @override
  String tacticsSubSentOff(String name) {
    return 'Na-sent off si $name at hindi na makakasali pa.';
  }

  @override
  String get tacticsInjuredShort => 'INJURED';

  @override
  String get tacticsSuspendedShort => 'SUSPENDIDO';

  @override
  String get confEurope => 'Europa';

  @override
  String get confSouthAmerica => 'Timog Amerika';

  @override
  String get confNorthAmerica => 'Hilagang Amerika';

  @override
  String get confAfrica => 'Aprika';

  @override
  String get confAsia => 'Asya';

  @override
  String get confOceania => 'Oceania';

  @override
  String get compWorldCup => 'Kampeonato ng Mundo';

  @override
  String get compWorldCupFinals => 'Finals ng Kampeonato ng Mundo';

  @override
  String get compWorldCupQualifying => 'Kwalipikasyon sa Kampeonato ng Mundo';

  @override
  String compQualifiers(String region) {
    return 'Mga Qualifier ng $region';
  }

  @override
  String get compFriendlies => 'Mga Friendly';

  @override
  String get compNationsCup => 'Nations Cup';

  @override
  String get compContinentalClash => 'Continental Clash';

  @override
  String get compIntercontinentalPlayoff => 'Intercontinental Play-off';

  @override
  String get compContinentalChampionship => 'Kontinental na Kampeonato';

  @override
  String get compEuropeanChampionship => 'Kampeonato ng Europa';

  @override
  String get compSouthAmericaCup => 'Copa ng Timog Amerika';

  @override
  String get compAfricanChampionship => 'Kampeonato ng Aprika';

  @override
  String get compAsianChampionship => 'Kampeonato ng Asya';

  @override
  String get compNorthAmericaCup => 'Copa ng Hilagang Amerika';

  @override
  String get compOceaniaCup => 'Copa ng Oceania';

  @override
  String get msgANation => 'Isang bansa';

  @override
  String get msgAPlayer => 'Isang manlalaro';

  @override
  String get msgAHostNation => 'isang host na bansa';

  @override
  String get msgCycleTitle1 => 'Nagsisimula ang bagong cycle';

  @override
  String msgCycleTitle2(int year) {
    return 'Bukas na ang daan patungong $year';
  }

  @override
  String get msgCycleTitle3 => 'Sumisikat ang bagong kampanya';

  @override
  String get msgCycleTitle4 => 'Balik sa trabaho';

  @override
  String msgCycleBody1(int year) {
    return 'Dito nagsisimula ang daan patungo sa Kampeonato ng Mundo $year.';
  }

  @override
  String msgCycleBody2(int year) {
    return 'Bagong cycle. Ang Kampeonato ng Mundo $year ang target.';
  }

  @override
  String msgCycleBody3(int year) {
    return 'Apat na taon bago ang Kampeonato ng Mundo $year. Simula na ang trabaho.';
  }

  @override
  String msgCycleBody4(int year) {
    return 'Magsisimula ngayon ang kampanya para sa $year.';
  }

  @override
  String msgContHostTitle(String cup, String host) {
    return 'Host ng $cup: $host';
  }

  @override
  String msgContHostBody(String host, String cup) {
    return 'Ang $host ang magiging host ng susunod na $cup.';
  }

  @override
  String msgContQualDrawTitle(String cup) {
    return 'Draw ng kwalipikasyon: $cup';
  }

  @override
  String msgContQualDrawBody(String cup) {
    return 'Na-draw na ang mga grupo ng kwalipikasyon ng $cup.';
  }

  @override
  String msgWcHostTitle(String host, int year) {
    return 'Host ng Kampeonato ng Mundo $year: $host';
  }

  @override
  String msgWcHostBody(String host, int year) {
    return 'Ang $host ang magiging host ng Kampeonato ng Mundo $year.';
  }

  @override
  String get msgWcQualDrawTitle =>
      'Draw ng kwalipikasyon sa Kampeonato ng Mundo';

  @override
  String get msgWcQualDrawBody =>
      'Na-draw na ang mga grupo ng kwalipikasyon ng Kampeonato ng Mundo.';

  @override
  String msgContFinalsDrawTitle(String cup) {
    return 'Draw ng finals: $cup';
  }

  @override
  String msgContFinalsDrawBody(String cup) {
    return 'Na-draw na ang mga grupo ng finals ng $cup.';
  }

  @override
  String get msgWcFinalsDrawTitle => 'Draw ng finals ng Kampeonato ng Mundo';

  @override
  String msgWcFinalsDrawBody(int year) {
    return 'Natapos na ang draw ng finals ng Kampeonato ng Mundo $year.';
  }

  @override
  String get msgQualWcTitle1 => 'Nakalusot sa Kampeonato ng Mundo';

  @override
  String get msgQualWcTitle2 => 'Sigurado na ang Kampeonato ng Mundo';

  @override
  String get msgQualWcTitle3 => 'Pupunta tayo sa Kampeonato ng Mundo';

  @override
  String get msgQualWcTitle4 => 'Hawak na ang tiket';

  @override
  String msgQualWcBody1(int year) {
    return 'Nag-qualify ka na sa finals ng Kampeonato ng Mundo $year.';
  }

  @override
  String msgQualWcBody2(int year) {
    return 'Opisyal na: kasali na ang bansa mo sa Kampeonato ng Mundo $year.';
  }

  @override
  String msgQualWcBody3(int year) {
    return 'Sigurado na ang puwesto sa Kampeonato ng Mundo $year.';
  }

  @override
  String msgQualWcBody4(int year) {
    return 'Nakalusot ka na sa finals ng Kampeonato ng Mundo $year.';
  }

  @override
  String msgQualContTitle1(String cup) {
    return 'Nakalusot sa $cup';
  }

  @override
  String msgQualContTitle2(String cup) {
    return 'Sigurado na ang $cup';
  }

  @override
  String msgQualContTitle3(String cup) {
    return 'Nag-qualify sa $cup';
  }

  @override
  String msgQualContBody1(String cup) {
    return 'Nag-qualify ka na sa finals ng $cup.';
  }

  @override
  String msgQualContBody2(String cup) {
    return 'Nakuha na ng bansa mo ang puwesto sa $cup.';
  }

  @override
  String msgQualContBody3(String cup) {
    return 'Nakalusot ka na sa $cup.';
  }

  @override
  String msgChampTitleMine1(String comp) {
    return 'MGA KAMPEON NG $comp!';
  }

  @override
  String msgChampTitleMine2(String comp) {
    return 'Kampeon ng $comp!';
  }

  @override
  String msgChampTitleMine3(String comp) {
    return 'Napanalunan mo ang $comp!';
  }

  @override
  String msgChampTitleOther1(String comp) {
    return 'Tapos na ang $comp';
  }

  @override
  String msgChampTitleOther2(String comp) {
    return 'Kinoronahan na ang kampeon ng $comp';
  }

  @override
  String msgChampTitleOther3(String comp) {
    return 'May nagwagi na sa $comp';
  }

  @override
  String msgChampBodyMine1(String comp, String loser, String result, int year) {
    return 'Ang bansa mo ang kampeon ng $comp $year, matapos talunin ang $loser$result.';
  }

  @override
  String msgChampBodyMine2(String comp, String loser, String result, int year) {
    return 'Napanalunan mo ang $comp $year, matapos pataubin ang $loser$result.';
  }

  @override
  String msgChampBodyMine3(String comp, String loser, String result, int year) {
    return 'Iyo ang $comp $year. Talo ang $loser$result.';
  }

  @override
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return 'Nagwagi ang $winner sa $comp $year, matapos talunin ang $loser$result.';
  }

  @override
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  ) {
    return 'Kampeon ng $comp $year ang $winner, matapos pataubin ang $loser$result.';
  }

  @override
  String msgFinalScoreSuffix(int home, int away) {
    return ' $home–$away sa final';
  }

  @override
  String msgFinalPensSuffix(int home, int away) {
    return ' sa penalties, pagkatapos ng $home–$away na final';
  }

  @override
  String get msgWpotyTitle => 'Manlalaro ng Taon sa Mundo';

  @override
  String msgWpotyBodyMine(String name, String nation, int year) {
    return 'Si $name ($nation) ang itinanghal na Manlalaro ng Taon sa Mundo $year, isa sa mga manlalaro mo.';
  }

  @override
  String msgWpotyBodyOther(String name, String nation, int year) {
    return 'Si $name ($nation) ang itinanghal na Manlalaro ng Taon sa Mundo $year.';
  }

  @override
  String get msgYpotTitle => 'Batang Manlalaro ng Torneo';

  @override
  String msgYpotBodyMine(String name, String nation, int age, int year) {
    return 'Si $name ($nation), edad $age, ang itinanghal na Batang Manlalaro ng Torneo $year, isa sa mga manlalaro mo.';
  }

  @override
  String msgYpotBodyOther(String name, String nation, int age, int year) {
    return 'Si $name ($nation), edad $age, ang itinanghal na Batang Manlalaro ng Torneo $year.';
  }

  @override
  String msgRankHold1(int rank) {
    return 'Nananatili ka sa #$rank.';
  }

  @override
  String msgRankHold2(int rank) {
    return 'Walang pagbabago, nasa #$rank pa rin.';
  }

  @override
  String msgRankHold3(int rank) {
    return 'Matatag sa #$rank.';
  }

  @override
  String msgRankUp1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puwesto',
      one: '1 puwesto',
    );
    return 'Umakyat ng $_temp0 sa kabuuan, papuntang #$rank.';
  }

  @override
  String msgRankUp2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puwesto',
      one: '1 puwesto',
    );
    return 'Ang pag-akyat ng $_temp0 ang nagdala sa iyo sa #$rank.';
  }

  @override
  String msgRankUp3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puwesto',
      one: '1 puwesto',
    );
    return 'Umakyat ng $_temp0, ngayon ay #$rank.';
  }

  @override
  String msgRankDown1(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puwesto',
      one: '1 puwesto',
    );
    return 'Bumaba ng $_temp0 sa kabuuan, papuntang #$rank.';
  }

  @override
  String msgRankDown2(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puwesto',
      one: '1 puwesto',
    );
    return 'Ang pagbagsak ng $_temp0 ang nagbaba sa iyo sa #$rank.';
  }

  @override
  String msgRankDown3(int move, int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      move,
      locale: localeName,
      other: '$move puwesto',
      one: '1 puwesto',
    );
    return 'Bumaba ng $_temp0, ngayon ay #$rank.';
  }

  @override
  String get msgRankLeadYou => 'Ikaw ang nangunguna sa mundo.';

  @override
  String msgRankLeadOther(String nation) {
    return 'Nangunguna sa mundo ang $nation.';
  }

  @override
  String msgRankTitle(int rank) {
    return 'Pandaigdigang ranking · #$rank';
  }

  @override
  String msgRankBody(String lead, String movement) {
    return 'Na-update na ang pandaigdigang ranking. $lead $movement';
  }

  @override
  String msgRankJumpTitleUp(int rank) {
    return 'Pag-akyat sa #$rank';
  }

  @override
  String msgRankJumpTitleDown(int rank) {
    return 'Pagbagsak sa #$rank';
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
      other: '$move puwesto',
      one: '1 puwesto',
    );
    return 'Binago ng $tournament ang pandaigdigang ranking. Pumasok ang $nation sa #$from at lumabas sa #$to, pag-akyat ng $_temp0.';
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
      other: '$move puwesto',
      one: '1 puwesto',
    );
    return 'Binago ng $tournament ang pandaigdigang ranking. Pumasok ang $nation sa #$from at lumabas sa #$to, pagbagsak ng $_temp0.';
  }

  @override
  String get rankingSinceWcDraw => 'Mula sa draw ng Kampeonato ng Mundo';

  @override
  String get rankingSinceCycleStart => 'Mula nang magsimula ang kampanya';

  @override
  String rankingMovedFromTo(int from, int now) {
    return '#$from papuntang #$now';
  }

  @override
  String msgCapsTitle(String name, int count) {
    return 'Umabot si $name sa $count caps';
  }

  @override
  String msgCapsBody(String name, int count) {
    return 'Nakagawa na si $name ng $count paglabas para sa bansa mo.';
  }

  @override
  String msgGoalsTitle(String name, int count) {
    return 'Umabot si $name sa $count goal';
  }

  @override
  String msgGoalsBody(String name, int count) {
    return 'Nakaiskor na si $name ng $count international goal para sa bansa mo.';
  }

  @override
  String msgDevTitle(int year) {
    return 'Pag-unlad ng squad · $year';
  }

  @override
  String msgThroughTitle(int year) {
    return 'Galing sa akademya · $year';
  }

  @override
  String get msgThroughNote =>
      'Hindi ito bagong intake. Sila ang mga batang pumasok sa edad na labing-isa at ngayon ay lumaki na papunta sa senior pool.';

  @override
  String msgNewFacesTitle(int year) {
    return 'Mga bagong mukha · $year';
  }

  @override
  String get msgIntakeNoteAcademy =>
      'Kita ang puhunan sa akademya: mas malakas ang intake na ito kaysa sa dapat sana.';

  @override
  String get msgIntakeNoteStanding =>
      'Nakatingin ang buong bansa sa koponang ito: dahil sa pag-akyat ng koponan sa pandaigdigang ranking, football na ang pinipili ng mga pinakamahuhusay na bata, at mas malakas ang intake na ito dahil doon.';

  @override
  String get msgIntakeNoteBoth =>
      'Kita ang pera sa akademya at ang pag-akyat ng koponan sa pandaigdigang ranking: mas malakas ang intake na ito kaysa sa dapat sana.';

  @override
  String msgIntakeTitle(int year) {
    return 'Intake ng akademya · $year';
  }

  @override
  String msgRetireCaptainTitle(String name) {
    return 'Nagretiro ang kapitan mong si $name';
  }

  @override
  String msgRetireTitle(String name) {
    return 'Nagretiro si $name sa international football';
  }

  @override
  String msgRetireBody(String name, int age) {
    return 'Nagretiro na si $name sa international football sa edad na $age.';
  }

  @override
  String msgRetireBodyWith(String name, String tally, int age) {
    return 'Nagretiro na si $name sa international football sa edad na $age, bitbit ang $tally.';
  }

  @override
  String msgTallyCaps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caps',
      one: '1 cap',
    );
    return '$_temp0';
  }

  @override
  String msgTallyGoals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goal',
      one: '1 goal',
    );
    return '$_temp0';
  }

  @override
  String get msgArmbandVacant =>
      ' Bakante ang armband. Magpangalan ng bagong kapitan sa screen ng call-up.';

  @override
  String msgHofTitle(String name) {
    return 'Pinasok si $name sa Hall of Fame';
  }

  @override
  String msgHofBody(String name, int caps, int goals) {
    return 'Sumali si $name sa Hall of Fame ng bansa mo ($caps caps, $goals goal). Tingnan siya sa Mga Alamat.';
  }

  @override
  String hubBanTitle(String name) {
    return 'Suspendido si $name';
  }

  @override
  String hubBanBody(String name, String how, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'susunod na $matches laro',
      one: 'susunod mong laro',
    );
    return '$name $how at suspendido para sa $_temp0. Hindi siya available para mapili.';
  }

  @override
  String get hubBanHowSecondYellow => 'ay na-sent off dahil sa ikalawang dilaw';

  @override
  String get hubBanHowViolent =>
      'ay binigyan ng direktang pulang kard dahil sa marahas na asal';

  @override
  String get hubBanHowRed => 'ay na-sent off';

  @override
  String hubInjuryTitle(String name) {
    return 'Injured si $name';
  }

  @override
  String hubInjuryBody(String name, int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: '$matches laro',
      one: '1 laro',
    );
    return 'Nasaktan si $name at wala siya sa $_temp0.';
  }

  @override
  String get hubRunnerUpTitle1 => 'Runner-up';

  @override
  String get hubRunnerUpTitle2 => 'Malapit na, pero hindi pa';

  @override
  String get hubRunnerUpTitle3 => 'Pilak ang inuwi';

  @override
  String hubRunnerUpBody1(String cup, String opponent) {
    return 'Umabot ka sa final ng $cup pero natalo ka sa $opponent. Sayang na sayang. Pilak muna ngayon.';
  }

  @override
  String hubRunnerUpBody2(String cup, String opponent) {
    return 'Natalo ka sa $opponent sa final ng $cup. Runner-up, napakalapit.';
  }

  @override
  String hubRunnerUpBody3(String cup, String opponent) {
    return 'Nawala sa iyo ang final ng $cup laban sa $opponent. Marami kang maipagmamalaki, pero hindi ang tropeo.';
  }

  @override
  String get hubKnockedOutTitle1 => 'Na-knockout';

  @override
  String get hubKnockedOutTitle2 => 'Dulo na ng daan';

  @override
  String get hubKnockedOutTitle3 => 'Tapos na ang biyahe';

  @override
  String hubKnockedOutBody1(String cup, String opponent, String stage) {
    return 'Out ka na sa $cup, natalo sa $opponent sa $stage.';
  }

  @override
  String hubKnockedOutBody2(String cup, String opponent, String stage) {
    return 'Tinapos ng $opponent ang $cup mo sa $stage.';
  }

  @override
  String hubKnockedOutBody3(String cup, String opponent, String stage) {
    return 'Hanggang $stage lang ang $cup mo, natalo sa $opponent.';
  }

  @override
  String get hubGroupExitTitle1 => 'Lagas sa group stage';

  @override
  String get hubGroupExitTitle2 => 'Out sa group stage';

  @override
  String get hubGroupExitTitle3 => 'Maagang uwi';

  @override
  String hubGroupExitBody1(String cup) {
    return 'Tapos na ang $cup mo sa group stage. Hindi sapat para umabot sa knockout.';
  }

  @override
  String hubGroupExitBody2(String cup) {
    return 'Hindi ka nakalabas sa grupo. Dito na nagtatapos ang $cup mo.';
  }

  @override
  String hubGroupExitBody3(String cup) {
    return 'Walang puwesto sa knockout ngayon. Tapos na ang $cup mo sa group stage.';
  }

  @override
  String boardObjectiveMetTitle(String comp) {
    return 'Naabot ang layunin: $comp';
  }

  @override
  String boardObjectiveMissedTitle(String comp) {
    return 'Hindi naabot ang layunin: $comp';
  }

  @override
  String boardObjectiveMetBody(String comp, String demand, String finish) {
    return 'Target ng board sa $comp: $demand. Ito ang naging tapos mo: $finish. Nakuha nila ang hiniling nila.';
  }

  @override
  String boardObjectiveMissedBody(String comp, String demand, String finish) {
    return 'Target ng board sa $comp: $demand. Ito ang naging tapos mo: $finish. Kulang ito sa inaasahan.';
  }

  @override
  String get newsWcMissTitle => 'Tapos na ang pangarap sa Kampeonato ng Mundo';

  @override
  String newsWcMissBody(int year) {
    return 'Hindi ka nakasali sa Kampeonato ng Mundo $year. Kinapos ang kampanya sa kwalipikasyon. Apat na taon pa.';
  }

  @override
  String get newsRecordScorerTitle => 'Pinakamaraming goal sa kasaysayan';

  @override
  String newsRecordScorerBody(String name, int goals) {
    return 'Si $name na ang pinakamahusay na goalscorer sa kasaysayan ng laro, may $goals goal.';
  }

  @override
  String get newsRecordCapsTitle => 'Pinakamaraming caps';

  @override
  String newsRecordCapsBody(String name, int caps) {
    return 'Si $name na ang manlalarong may pinakamaraming caps sa kasaysayan ng laro, may $caps laro.';
  }

  @override
  String get newsARecordBreaker => 'Bagong record-breaker';

  @override
  String newsTransferTitle(String name, String club) {
    return 'Lumipat si $name sa $club';
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
    return 'Umalis si $name ($position, $rating) sa $fromClub at pumirma sa $destination sa halagang $fee.';
  }

  @override
  String newsTransferAbroad(String club, String country) {
    return '$club sa $country';
  }

  @override
  String get newsTransferFree => 'Libre';

  @override
  String newsNatzStarTitle(String name, String nation) {
    return '⭐ Lilipat si $name sa $nation!';
  }

  @override
  String newsNatzTitle(String name, String nation) {
    return 'Gusto ni $name na maglaro para sa $nation';
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
    return 'Si $name, isang $age-taong-gulang na $position na may rating na $rating at kasalukuyang nasa $fromNation, ay may ugnayan ng pamilya sa $nation at bukas sa paglipat. Buksan ang alok ng Naturalisasyon para tanggapin o tanggihan ito.';
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
    return 'Si $name, isang $age-taong-gulang na $position na may rating na $rating at kasalukuyang nasa $fromNation, ay isang star na may ugnayan ng pamilya sa $nation at bukas sa paglipat. Buksan ang alok ng Naturalisasyon para tanggapin o tanggihan ito.';
  }

  @override
  String get newsTheirNation => 'kanilang bansa';

  @override
  String get newsYourNation => 'iyong bansa';

  @override
  String get tourStatusChampions => 'KAMPEON';

  @override
  String get tourStatusFinals => 'FINALS';

  @override
  String get tourStatusQualifying => 'KWALIPIKASYON';

  @override
  String get tourStatusUpcoming => 'PAPARATING';

  @override
  String get tourStatusInProgress => 'NAGAGANAP';

  @override
  String get tourStatusComingSoon => 'MALAPIT NA';

  @override
  String get tourStatusDecided => 'TAPOS NA';

  @override
  String tourStatusLeague(String letter) {
    return 'LIGA $letter';
  }

  @override
  String get tourDrawWcQualifying => 'DRAW NG KWALIPIKASYON SA MUNDO';

  @override
  String tourDrawContQualifying(String cup) {
    return 'DRAW NG KWALIPIKASYON: $cup';
  }

  @override
  String get tourDrawWcHost => 'HOST NG KAMPEONATO NG MUNDO';

  @override
  String tourDrawContHost(String cup) {
    return 'HOST: $cup';
  }

  @override
  String get tourDrawHostsReveal => 'At ang mga host ay…';

  @override
  String get tourDrawHostReveal => 'At ang host ay…';

  @override
  String get tourDrawHostCandidates => 'Ang mga kandidatong nasa laban:';

  @override
  String get tourKickoffContinentalCup => 'KONTINENTAL NA COPA';

  @override
  String tourHostCompetitionYear(String competition, int year) {
    return '$competition $year';
  }

  @override
  String newsContMissTitle(String cup) {
    return 'Hindi nakapasok sa $cup';
  }

  @override
  String newsContMissBody(String cup) {
    return 'Hindi ka nakapasok sa $cup. Kinapos ang kampanya ngayon.';
  }

  @override
  String get potyLabelBest => 'Manlalaro ng Taon';

  @override
  String get potyLabelYoung => 'Batang Manlalaro ng Taon';

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
    return 'Rating $value';
  }

  @override
  String potyRatingValue(String value) {
    return 'Marka $value';
  }

  @override
  String newsPotyTitle(int year) {
    return 'Manlalaro ng Taon sa Mundo $year';
  }

  @override
  String newsPotyBody(String name) {
    return 'Si $name ang pinakamahusay na manlalaro sa mundo ngayong taon.';
  }

  @override
  String newsPotyYoungSuffix(String name) {
    return ' Si $name naman ang nanalo ng parangal para sa batang manlalaro.';
  }

  @override
  String newsWatchTitle(int year) {
    return 'Ang mga binabantayan mong bata, $year';
  }

  @override
  String newsWatchJump(String name, int rating, int gain) {
    String _temp0 = intl.Intl.pluralLogic(
      gain,
      locale: localeName,
      other: '$gain puntos',
      one: 'isang puntos',
    );
    return 'Umangat si $name sa $rating, $_temp0 na mas mataas kaysa noong nakaraang taon.';
  }

  @override
  String newsWatchBand(String name, String band) {
    return 'Umakyat si $name sa $band.';
  }

  @override
  String newsWatchDebutTitle(String name) {
    return 'Nag-debut si $name';
  }

  @override
  String newsWatchDebutBody(String name, int age, int rating) {
    return 'Nakuha ni $name ang unang cap sa edad na $age, may rating na $rating. Isa siya sa mga batang binabantayan mo.';
  }

  @override
  String get matchStatsAtFullTime =>
      'Ang possession, mga rating ng manlalaro at man of the match ay malalaman sa final whistle.';

  @override
  String get matchPlayerRatings => 'MGA RATING NG MANLALARO';

  @override
  String get matchSubstitutions => 'MGA PAGPAPALIT';

  @override
  String get matchSubstitutes => 'MGA PAMALIT';

  @override
  String get matchPlayerOfTheMatch => 'MANLALARO NG LARO';

  @override
  String get matchGoalShout => 'GOAL!';

  @override
  String matchShootoutScore(int home, int away) {
    return 'SHOOTOUT $home–$away';
  }

  @override
  String matchShootoutKickScored(String name) {
    return '$name: SCORED';
  }

  @override
  String matchShootoutKickMissed(String name) {
    return '$name: MISSED';
  }

  @override
  String get matchFeedKickOff => 'Kick-off!';

  @override
  String get matchFeedNoEvents => 'Wala pang nangyayari.';

  @override
  String get tourVenues => 'MGA VENUE';

  @override
  String tourPot(int number) {
    return 'POT $number';
  }

  @override
  String get tourHostSelection => 'PAGPILI NG HOST';

  @override
  String get tourCandidates => 'MGA KANDIDATO';

  @override
  String get tourJointBid => 'SAMA-SAMANG BID';

  @override
  String get tourGoldenGlove => 'GOLDEN GLOVE';

  @override
  String get tourTeamOfTournament => 'TEAM OF THE TOURNAMENT';

  @override
  String get tourYourRun => 'TAKBO MO';

  @override
  String get tourMedalTable => 'TALAAN NG MEDALYA';

  @override
  String tourHostLine(String nation) {
    return 'Host: $nation';
  }

  @override
  String tourHostLineMulti(String hosts) {
    return 'Mga host: $hosts';
  }

  @override
  String tourGroupNamed(String name) {
    return 'Grupo $name';
  }

  @override
  String get tourFinalsDrawBlurb =>
      'Seeded ayon sa pandaigdigang ranking. Hanapin ang bansa mo bago ang draw.';

  @override
  String get tourWorldRanking => 'Pandaigdigang Ranking';

  @override
  String get tourYourCompetitions => 'MGA KOMPETISYON MO';

  @override
  String get tourOtherContinents => 'IBANG KONTINENTE';

  @override
  String get tourZoneGlobal => 'MUNDO';

  @override
  String get tourZoneEurope => 'EUROPA';

  @override
  String get tourZoneSouthAmerica => 'T. AMERIKA';

  @override
  String get tourZoneNorthAmerica => 'H. AMERIKA';

  @override
  String get tourZoneAfrica => 'APRIKA';

  @override
  String get tourZoneAsia => 'ASYA';

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
    return 'HOST:  $hosts';
  }

  @override
  String tourThirdsAdvance(int count, String destination) {
    return 'Aabante ang nangungunang $count sa $destination';
  }

  @override
  String newsWalkoutTitle(String name) {
    return 'Umalis si $name';
  }

  @override
  String newsWalkoutBody(String name, int age, int caps) {
    return 'Nagretiro na si $name sa international football sa edad na $age, may $caps caps. Humingi siya ng malinaw na sagot kung nasaan siya sa plano mo pero walang ibinigay, at hindi na siya maghihintay pa.';
  }

  @override
  String get pressHeadlineWent1 => 'Isang manager na kontrolado ang silid';

  @override
  String get pressHeadlineWent2 =>
      'Dumating sila para sa away, lider ang inabutan';

  @override
  String get pressHeadlineWent3 => 'Tuwid na sagot, at tumama';

  @override
  String get pressHeadlineMixed1 => 'Maraming sinabi, kaunting nalinaw';

  @override
  String get pressHeadlineMixed2 =>
      'Para sa lahat ang sagot, pero walang nakuha ang sinuman';

  @override
  String get pressHeadlineMixed3 =>
      'Isang press conference na nag-iwan ng mga tanong';

  @override
  String get pressHeadlineBadly1 => 'Masakit na hapon sa harap ng mga camera';

  @override
  String get pressHeadlineBadly2 => 'Nagbago ang ihip ng silid, at kita ito';

  @override
  String get pressHeadlineBadly3 =>
      'Mga sagot na mas masakit basahin bukas ng umaga';

  @override
  String get pressHeadlineFlat1 => 'Walang sinabi, walang napala';

  @override
  String get pressHeadlineFlat2 => 'Sampung minuto, walang balita';

  @override
  String get pressHeadlineFlat3 => 'Blangkong pahina para sa back page';

  @override
  String get pressConferenceTitle => 'PRESS CONFERENCE';

  @override
  String pressQuestionOf(int index, int total) {
    return 'Tanong $index sa $total';
  }

  @override
  String get pressTomorrowsHeadline => 'BACK PAGE BUKAS';

  @override
  String get pressLeaveRoom => 'UMALIS SA SILID';

  @override
  String get pressRoomVerdictSquad => 'Dressing room';

  @override
  String get pressRoomVerdictBoard => 'Board';

  @override
  String get yReactionElation0 => 'walang masabi. wala. perpekto.';

  @override
  String get yReactionElation1 => 'Ang saya ko sobra (good).';

  @override
  String get yReactionElation2 =>
      'ifa-frame ko to. ilalagay sa ibabaw ng fireplace.';

  @override
  String get yReactionElation3 => 'we are so back';

  @override
  String get yReactionElation4 =>
      'Isi-screenshot ko ito para sa mga duda. Sa lahat sila.';

  @override
  String get yReactionElation5 => 'Yayabangan ko kayo dito nang sampung taon.';

  @override
  String get yReactionElation6 => 'Ayan. Kaya tayo nanonood.';

  @override
  String get yReactionElation7 => 'Ang mga araw na ganito ang bumabawi sa iba.';

  @override
  String get yReactionElation8 => 'Sa wakas. Totoo, sa wakas.';

  @override
  String get yReactionElation9 =>
      'Ayos. Ulitin ninyo sa susunod na linggo at saka ako maniniwala.';

  @override
  String get yReactionElation10 =>
      'I-enjoy ninyo ngayong gabi, dahil siguradong may paraan ang mga ito para sirain.';

  @override
  String get yReactionElation11 =>
      'Ang isang magandang gabi ay hindi nagiging magaling na koponan.';

  @override
  String get yReactionRelief0 =>
      'Hindi maganda, pero tatanggapin ko iyan kahit kailan.';

  @override
  String get yReactionRelief1 => 'Paano man. Paano man!';

  @override
  String get yReactionRelief2 => 'Pangit. Tatlong puntos. Tuloy na.';

  @override
  String get yReactionRelief3 =>
      'Tatanggapin ko ang pangit maghapon basta may puntos.';

  @override
  String get yReactionRelief4 =>
      'nabawasan ako ng sampung taon sa laro na iyon';

  @override
  String get yReactionRelief5 => 'Walang magsasalita. Walang jinx.';

  @override
  String get yReactionRelief6 => 'Heart rate: hindi katanggap-tanggap.';

  @override
  String get yReactionRelief7 => 'Nakaligtas. Iyon ang salita. Nakaligtas.';

  @override
  String get yReactionRelief8 =>
      'Hindi dapat tayo nakakahinga nang maluwag sa mga larong ganyan.';

  @override
  String get yReactionRelief9 =>
      'Nakahinga ako nang maluwag, at medyo nahihiya akong nakahinga ako nang maluwag.';

  @override
  String get yReactionRelief10 =>
      'Kung iyan na ang standard na ipinagdiriwang natin, may problema tayo.';

  @override
  String get yReactionRelief11 =>
      'Ugali na ang makalusot, at hindi ito magandang ugali.';

  @override
  String get yReactionFury0 => 'Hindi sapat. Hindi man lang malapit.';

  @override
  String get yReactionFury1 =>
      'May magpaliwanag nito sa akin nang dahan-dahan.';

  @override
  String get yReactionFury2 => 'Mahirap panoorin iyan at magalang pa ako.';

  @override
  String get yReactionFury3 => 'Dismayado ako. Totoong dismayado.';

  @override
  String get yReactionFury4 => 'Grabe ang lagay nito.';

  @override
  String get yReactionFury5 => 'Gusto ko ng mga pangalan.';

  @override
  String get yReactionFury6 =>
      'Buburahin ko ang app. Ire-reinstall sa Huwebes.';

  @override
  String get yReactionFury7 =>
      'Walang mukhang gustong manalo sa mga nasa labas.';

  @override
  String get yReactionFury8 =>
      'Tuwing apat na taon, pareho. TUWING apat na taon.';

  @override
  String get yReactionFury9 => 'Hindi iyan performance, insulto iyan.';

  @override
  String get yReactionFury10 =>
      'Isinusuko ng mga tao ang weekend at pera para diyan. Isipin ninyo.';

  @override
  String get yReactionFury11 =>
      'Ilang taon ko nang ipinagtanggol ang koponang ito. Hindi ngayong gabi. Hindi pagkatapos niyan.';

  @override
  String get yReactionDespair0 => 'sige.';

  @override
  String get yReactionDespair1 => 'Walang biro ngayon. Wala.';

  @override
  String get yReactionDespair2 => 'Maglalakad muna ako. Mahabang lakad.';

  @override
  String get yReactionDespair3 => 'Naubusan na ako ng paraan para sabihin ito.';

  @override
  String get yReactionDespair4 =>
      'Gisingin ninyo ako sa susunod na apat na taon.';

  @override
  String get yReactionDespair5 => 'ito na ang pinakamadilim na timeline';

  @override
  String get yReactionDespair6 => 'Hindi na ako galit. Iyon ang nakakabahala.';

  @override
  String get yReactionDespair7 => 'Matagal itong sasakit.';

  @override
  String get yReactionDespair8 =>
      'Hindi ko na alam kung ano ito, pero hindi ito football team.';

  @override
  String get yReactionDespair9 =>
      'Mas malayo na tayo kaysa dati, at walang may gustong magsabi.';

  @override
  String get yReactionDespair10 =>
      'Isang buong henerasyon ang nasayang at ang parehong tao pa rin ang magdedesisyon sa susunod.';

  @override
  String get yReactionDespair11 =>
      'Huwag ninyong sabihing proseso ito. Wala itong pupuntahan.';

  @override
  String get yReactionSmugness0 => 'Mahina lang, pero: sinabi ko na sa inyo.';

  @override
  String get yReactionSmugness1 => 'i-bookmark ninyo ito';

  @override
  String get yReactionSmugness2 => 'Biglang tumahimik ang mga duda.';

  @override
  String get yReactionSmugness3 => 'Hindi sa may nagbibilang. Nagbibilang ako.';

  @override
  String get yReactionSmugness4 =>
      'Sinabi ko noong Enero. Tingnan ang timeline.';

  @override
  String get yReactionSmugness5 =>
      'May utang na paumanhin ang ilan sa inyo sa ilan sa amin.';

  @override
  String get yReactionSmugness6 => 'Ilalagay ko ito sa mga unang sinabi ko.';

  @override
  String get yReactionSmugness7 => 'Walang yabang. Kaunting yabang.';

  @override
  String get yReactionSmugness8 =>
      'Nasaan na ang lahat ng eksperto? Seryosong tanong.';

  @override
  String get yReactionSmugness9 =>
      'Gusto kong sabihin ninyo lahat ito pabalik sa akin.';

  @override
  String get yReactionSmugness10 =>
      'Screenshot, ipinrint, ini-frame, ipinadala sa mga tumawa.';

  @override
  String get yReactionSmugness11 =>
      'Babanggitin ko ito habambuhay at karapat-dapat kayo diyan.';

  @override
  String get yReactionShrug0 => 'nangyari na. next.';

  @override
  String get yReactionShrug1 => 'Sige. Bahala na. Tuloy.';

  @override
  String get yReactionShrug2 => 'Ilalagay ko ito sa ilalim ng \'football\'.';

  @override
  String get yReactionShrug3 => 'Wala talaga akong maidadagdag.';

  @override
  String get yReactionShrug4 => 'walang iniisip, walang laman ang ulo';

  @override
  String get yReactionShrug5 => 'Gisingin ninyo ako para sa susunod.';

  @override
  String get yReactionShrug6 =>
      'Siyamnapung minuto iyan na hindi ko na maibabalik.';

  @override
  String get yReactionShrug7 => 'Wala namang pinagkaiba, sa totoo lang.';

  @override
  String get yReactionShrug8 => 'Wala akong masasabing kahit isang nangyari.';

  @override
  String get yReactionShrug9 =>
      'Isa na naman sa mga ganyan. Marami na ang ganyan.';

  @override
  String get yReactionShrug10 => 'Pinanood ko lahat at wala akong naramdaman.';

  @override
  String get yReactionShrug11 =>
      'Kung wala nang babanggit nito ulit, okay lang sa akin.';

  @override
  String get tourThirdsUneven =>
      'Hindi pantay ang mga grupo, kaya hindi binibilang ang mga resulta laban sa pinakamahinang koponan ng bawat malaking grupo para pare-pareho ang bilang ng laro ng bawat koponan.';

  @override
  String get careerExportSave => 'I-backup ang save na ito';

  @override
  String get careerBackupAll => 'I-BACKUP LAHAT NG SAVE';

  @override
  String get careerBackupAllFailed => 'Hindi naisulat ang backup.';

  @override
  String get backupTitle => 'MGA SAVE';

  @override
  String get backupBlurb =>
      'Nasa iisang file sa teleponong ito ang lahat ng save, at walang kusang nagba-backup nito. Mag-export ng kopya at itago sa labas ng telepono, sa Files o iCloud Drive, para hindi ka mawalan ng karera kapag nawala ang telepono o nabura ang app.';

  @override
  String get backupExport => 'MAG-EXPORT NG BACKUP';

  @override
  String get backupExportSubject => 'Mga FNM save';

  @override
  String get backupRestore => 'IBALIK MULA SA FILE';

  @override
  String get backupRestoreWarnTitle => 'Palitan ang lahat ng save?';

  @override
  String get backupRestoreWarnBody =>
      'Papalitan ng pagbabalik ang lahat ng save sa teleponong ito ng nasa file. Magre-restart ang app.';

  @override
  String get backupRestoreConfirm => 'PALITAN';

  @override
  String get backupCancel => 'KANSELAHIN';

  @override
  String get backupExported =>
      'Handa na ang backup. Piliin kung saan ito itatago.';

  @override
  String get backupFailed => 'Hindi naisulat ang backup.';

  @override
  String get backupRejectedUnreadable => 'Hindi mabuksan ang file na iyon.';

  @override
  String get backupRejectedNotFnm => 'Hindi iyan FNM save.';

  @override
  String get backupRejectedNewer =>
      'Ginawa ang save na iyon ng mas bagong bersyon ng app. Mag-update muna.';

  @override
  String get backupRejectedTooOld =>
      'Masyadong luma ang save na iyon para maibalik ng bersyong ito.';

  @override
  String get careerShare => 'I-share ang karerang ito';

  @override
  String get careerImport => 'MAG-IMPORT NG KARERA';

  @override
  String get careerShareSubject => 'Isang FNM na karera';

  @override
  String get careerImported => 'Na-import na ang karera.';

  @override
  String get careerImportFailedUnreadable =>
      'Hindi FNM na karera ang file na iyon.';

  @override
  String get careerImportFailedNewer =>
      'Na-export ang karerang iyon ng mas bagong bersyon ng app. Mag-update muna.';

  @override
  String get careerImportFailedSlotsFull =>
      'Gamit na ang lahat ng save slot mo. Magbura ng save para magkaroon ng espasyo, o i-unlock ang walang limitasyong save.';

  @override
  String get careerImportFailedNeedsPremium =>
      'Lampas na sa libreng unang cycle ang karerang iyon. I-unlock ang buong laro para madala ito.';

  @override
  String get careerImportFailedCampaignRun =>
      'May kasalukuyang takbo ang kampanyang iyon. Ituloy o iwanan muna ito.';

  @override
  String get careerShareFailed => 'Hindi na-export ang karerang iyon.';

  @override
  String get managerRename => 'Palitan ang pangalan';

  @override
  String get managerRenameSave => 'I-save';

  @override
  String get managerTitle => 'MANAGER';

  @override
  String get managerSkills => 'ANG MGA SKILL MO';

  @override
  String managerPointsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punto na magagamit',
      one: '1 punto na magagamit',
      zero: 'Walang punto na magagamit',
    );
    return '$_temp0';
  }

  @override
  String get managerPointsHow =>
      'Dalawang puntos sa bawat cycle na matapos mo, isa sa bawat tropeo na mapanalunan mo.';

  @override
  String get managerSkillsScale =>
      'Nagsisimula sa 5 ang bawat skill at hanggang 20 lang. Permanente ang ginastos na puntos.';

  @override
  String get managerSkillManManagement => 'Man Management';

  @override
  String get managerSkillManManagementBlurb =>
      'Bawat puntos ay nagpapalakas ng 3% sa dating ng sinasabi mo sa media at sa mga manlalaro sa dressing room.';

  @override
  String get managerSkillTactical => 'Taktika';

  @override
  String get managerSkillTacticalBlurb =>
      'Bawat puntos ay nagpapabilis ng 3% sa pagkasanay sa bagong formation, kaya mas kaunting laro ang nasasayang sa pagbabago ng shape.';

  @override
  String get managerSkillYouth => 'Pagpapaunlad ng Kabataan';

  @override
  String get managerSkillYouthBlurb =>
      'Bawat puntos ay nagdaragdag ng 1% sa talentong lumalabas sa akademya mo, bukod pa sa pondong ibinibigay mo.';

  @override
  String get managerSkillNegotiation => 'Negosasyon';

  @override
  String get managerSkillNegotiationBlurb =>
      'Bawat puntos ay 2% na mas maraming pera mula sa pederasyon, bawat cycle.';

  @override
  String get managerStaff => 'ANG STAFF MO';

  @override
  String managerStaffWages(String amount) {
    return 'Sahod: $amount bawat cycle';
  }

  @override
  String get managerRoleAssistant => 'Assistant Manager';

  @override
  String get managerRoleAssistantBlurb =>
      'Namamahala sa training: mas kaunting injury at mas magagaling na batang lumalabas.';

  @override
  String get managerRoleScout => 'Chief Scout';

  @override
  String get managerRoleScoutBlurb =>
      'Binabasa ang mga prospect mo at ang susunod na kalaban: mas totoong star rating at bentahe sa matchday.';

  @override
  String get managerRoleFitness => 'Fitness Coach';

  @override
  String get managerRoleFitnessBlurb => 'Pinananatiling nasa pitch sila.';

  @override
  String staffEffectInjury(int percent) {
    return '$percent% na mas kaunting injury';
  }

  @override
  String staffEffectYouth(int points) {
    return 'Mga bata +$points overall';
  }

  @override
  String staffHiringInjury(int min, int max) {
    return 'Kapag kumuha: $min% hanggang $max% na mas kaunting injury';
  }

  @override
  String staffHiringYouth(int minPoints, int maxPoints) {
    return 'at mga bata +$minPoints hanggang +$maxPoints overall';
  }

  @override
  String staffEffectScoutRead(int percent) {
    return 'Eksaktong nababasa ang $percent% ng mga prospect';
  }

  @override
  String staffEffectScoutCaps(int caps) {
    String _temp0 = intl.Intl.pluralLogic(
      caps,
      locale: localeName,
      other: 'Alam ang potensyal pagkatapos ng $caps caps',
      one: 'Alam ang potensyal pagkatapos ng 1 cap',
    );
    return '$_temp0';
  }

  @override
  String staffEffectScoutDossier(int points) {
    return '+$points rating mula sa mga dossier ng kalaban';
  }

  @override
  String staffHiringScoutRead(int min, int max) {
    return 'Kapag kumuha: $min% hanggang $max% ng mga read ay eksakto';
  }

  @override
  String staffHiringScoutCaps(int minCaps, int maxCaps) {
    return 'at alam ang potensyal nang $minCaps hanggang $maxCaps caps na mas maaga';
  }

  @override
  String staffHiringScoutDossier(int minPoints, int maxPoints) {
    return 'at +$minPoints hanggang +$maxPoints rating sa bawat laro';
  }

  @override
  String get staffEffectNone => 'Wala pang epekto sa squad mo';

  @override
  String get staffVacant => 'Walang nakatalaga';

  @override
  String get staffLeaveVacant => 'Iwanang bakante ang posisyon';

  @override
  String get managerTierNone => 'Wala';

  @override
  String get managerTierBasic => 'Basic';

  @override
  String get managerTierGood => 'Magaling';

  @override
  String get managerTierElite => 'Elite';

  @override
  String get managerFree => 'libre';

  @override
  String get managerTraining => 'SA PAGITAN NG MGA WINDOW';

  @override
  String get managerTrainingBlurb =>
      'Ang pinagtutuunan ng squad kapag walang laro.';

  @override
  String get managerFocusBalanced => 'Balanse';

  @override
  String get managerFocusBalancedBlurb => 'Kaunti sa lahat.';

  @override
  String get managerFocusFitness => 'Fitness';

  @override
  String get managerFocusFitnessBlurb => 'Mas kaunting injury.';

  @override
  String get managerFocusCohesion => 'Pagkakaisa';

  @override
  String get managerFocusCohesionBlurb => 'Mas mabilis masanay ang shape.';

  @override
  String get managerFocusYouth => 'Kabataan';

  @override
  String get managerFocusYouthBlurb =>
      'Oras kasama ang mga pinakabata sa pool.';

  @override
  String get tourOfferTitle => 'Unang beses mo dito?';

  @override
  String get tourOfferBody =>
      'Malaki ang larong ito. Gusto mo ng mabilis na paglilibot sa mahahalagang screen? Isang minuto lang ito, at puwede mo itong simulan ulit anumang oras sa Mga Setting.';

  @override
  String get tourOfferYes => 'Ilibot mo ako';

  @override
  String get tourOfferNo => 'Huwag na';

  @override
  String get tourBack => 'Bumalik';

  @override
  String get tourNext => 'Susunod';

  @override
  String get tourDone => 'Tapos na';

  @override
  String get tourSkip => 'Laktawan';

  @override
  String get tourHubTitle => 'Ito ang buong laro';

  @override
  String get tourHubBody =>
      'Isang button, at nagbabago ito habang umuusad ang cycle: draw na papanoorin, squad na ihahayag, laro na lalaruin. Sa itaas nito ang tiwala ng board sa iyo at ang mga layuning itinakda nila.';

  @override
  String get tourBudgetTitle => 'Ang pera ng pederasyon';

  @override
  String get tourBudgetBody =>
      'Minsan sa bawat apat-na-taong cycle, hahatiin mo ang pondo sa pagitan ng mga departamento. Unang kinukuha rito ang sahod ng staff mo, kaya ang pagkuha ng elite na scout ay desisyong laban sa akademya, hindi kasabay nito.';

  @override
  String get tourTacticsTitle => 'Paano naglalaro ang koponan';

  @override
  String get tourTacticsBody =>
      'Ang shape mo, ang istilo mo ng paglalaro, ang kapitan mo at kung sino ang kukuha ng set piece. Kapag hindi mo itinakda ang huling dalawa, bibigyan ka ng babala ng laro bago ang kick-off sa halip na tahimik na pumili para sa iyo.';

  @override
  String get tourSquadTitle => 'Lahat ng puwede mong piliin';

  @override
  String get tourSquadBody =>
      'Ang buong pool, hindi lang ang squad: sino ang nasa porma, sino ang may injury, sino ang suspendido, at sino ang kalalabas lang sa akademya.';

  @override
  String get tourCallUpsTitle => 'Paghahayag ng squad';

  @override
  String get tourCallUpsBody =>
      'Isang squad ang ihahayag mo bawat international window at lalaro ito sa bawat laro ng window na iyon, tulad ng tunay na manager. Kapag may na-injure sa loob ng window, may papalit na ipapasok para sa iyo.';

  @override
  String get tourRecordsTitle => 'Ang karera mo';

  @override
  String get tourRecordsBody =>
      'Lahat ng nagawa mo: ang mga laro, ang mga team record, ang mga tropeo, at bawat bansang hinawakan mo.';

  @override
  String get tourCupsTitle => 'Ang natitirang mundo';

  @override
  String get tourCupsBody =>
      'Bawat kompetisyong tumatakbo ngayon: mga grupo, standings at knockout, kasama ang mga hindi mo sinalihan. Patuloy ang paglalaro ng mundo kahit hindi ka nakapasok.';

  @override
  String get settingsTourTitle => 'Ulitin ang tutorial';

  @override
  String get settingsTourBlurb =>
      'Libutin ulit ang mahahalagang screen mula sa simula.';

  @override
  String get tourBoardTitle => 'Sino ang sinasagot mo';

  @override
  String get tourBoardBody =>
      'Ang tiwala ng board sa iyo, at ang mga layuning itinakda nila para sa cycle na ito. Kapag hindi mo naabot ang brief, dito mo ito makikitang paparating.';

  @override
  String get tourStaffTitle => 'Ang mga tao sa paligid mo';

  @override
  String get tourStaffBody =>
      'Isang assistant, isang scout at isang fitness coach, kinukuha ayon sa pangalan. Kinukuha ang sahod nila sa badyet na ito bago ang mga departamento, kaya ang magaling na scout ay desisyong laban sa akademya.';

  @override
  String get tourPlaystyleTitle => 'Ang istilo mo ng paglalaro';

  @override
  String get tourPlaystyleBody =>
      'Kalahati lang ng taktika ang shape. Ito ang kalahati pa: gaano kataas ang pressing mo, gaano ka kadirekta, gaano karaming risk ang kukunin mo.';

  @override
  String get settingsTourNoSave =>
      'Magsimula muna ng karera. Dumadaan ang paglilibot sa sarili mong mga screen.';

  @override
  String tacticsOutOfPositionAge(int age) {
    return 'Wala sa posisyon · Edad $age';
  }

  @override
  String get federationNextCycleLocked =>
      'Itinatakda ang badyet ng susunod na cycle sa simula nito, sabay-sabay. Hanggang doon, ito ang ginagawa ng pera mo.';

  @override
  String get federationBudgetAlreadySet => 'Naitakda na para sa cycle na ito';

  @override
  String yFinalLooms0(String opponent) {
    return '$opponent ang kalaban sa malaking laban. Buong linggo, ito lang ang pag-uusapan ng lahat.';
  }

  @override
  String yFinalLooms1(String opponent) {
    return 'Kumpirmado: $opponent ang humaharang sa pagitan natin at ng tropeo. Apat na taon para dito.';
  }

  @override
  String yFinalLooms2(String opponent) {
    return 'Sige. $opponent. Walang matutulog hanggang matapos ito.';
  }

  @override
  String yFinalLooms3(String opponent) {
    return '$opponent ang susunod, at maghihintay ang lahat ng iba. Ang ganda ng linggong ito.';
  }

  @override
  String get matchSetupLeaveToCoach => 'Ipaubaya sa coach ang mga kukuha';

  @override
  String friendliesLikeYourGroup(String rivals) {
    return 'Namarkahan sa ibaba: mga koponang kapareho maglaro ng $rivals, ang mga makakaharap mo sa mga grupo mo ngayong cycle.';
  }

  @override
  String newsTransferWindowTitle(int year) {
    return 'Transfer window · $year';
  }

  @override
  String careerLastAgo(String when) {
    return '$when na ang nakalipas';
  }

  @override
  String get settingsFreeScopeTitle => 'Isang libreng apat-na-taong cycle';

  @override
  String get settingsFreeScopeBlurb =>
      'Isang kumpletong cycle (kwalipikasyon, ang kampeonato ng kontinente mo at ang Kampeonato ng Mundo) sa dalawang save, bawat bansa sa mundo, walang tinipid. Ang walang katapusang cycle at walang limitasyong save ay isang bayad lang, minsanan, at sakop nito ang bawat update sa hinaharap.';

  @override
  String get settingsUnlockedTitle => 'Naka-unlock';

  @override
  String get settingsUnlockedBlurb =>
      'Walang katapusang cycle, walang limitasyong save at bawat update sa hinaharap. Salamat.';

  @override
  String get settingsFromDeveloperTitle => 'Mula sa developer';

  @override
  String get settingsFromDeveloperBlurb =>
      'Ang Football Nations Manager ay gawa ng isang tao at susuportahan sa mahabang panahon. Hindi magkakaroon ng ads o microtransaction kailanman. Kung nasisiyahan ka sa laro, pag-isipan mong bilhin ang buong bersyon. Ito ang nagpapatuloy ng mga update.';

  @override
  String get settingsFromDeveloperThanksBlurb =>
      'Ang Football Nations Manager ay gawa ng isang tao at susuportahan sa mahabang panahon. Hindi magkakaroon ng ads o microtransaction kailanman. Salamat sa pagbili ng buong bersyon. Ito ang nagpapatuloy ng mga update.';

  @override
  String friendliesLikeYourCampaign(String rivals) {
    return 'Namarkahan sa ibaba: mga koponang kapareho maglaro ng $rivals, na kailangan mo pang harapin.';
  }

  @override
  String get friendliesCloseToYou =>
      'Namarkahan sa ibaba: mga koponang pinakamalapit sa iyo sa pandaigdigang ranking. Kapag na-draw ka na, susunod ang mga marka sa grupo mo.';

  @override
  String transfersMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paglipat',
      one: '1 paglipat',
    );
    return '$_temp0';
  }

  @override
  String hubRoundPage(int page, int pages) {
    return '$page / $pages';
  }

  @override
  String get transfersNewer => 'Bago';

  @override
  String get transfersOlder => 'Higit pa';

  @override
  String get transfersPagePrevious => 'Nakaraan';

  @override
  String get transfersPageNext => 'Susunod';

  @override
  String transfersPageOf(int page, int pages) {
    return 'Pahina $page sa $pages';
  }

  @override
  String get transfersMovedTo => 'Lumipat sa';

  @override
  String get transfersUnknownClub => 'Hindi kilalang club';

  @override
  String yAgainstThemAgain0(String opponent, String count) {
    return '$count beses na natin silang nakalaban, $opponent. May nagbibilang ng score, at sila iyon.';
  }

  @override
  String yAgainstThemAgain1(String opponent, String count) {
    return '$opponent na naman. $count beses nang magkaharap, at hindi pa rin natin sila nalulutas.';
  }

  @override
  String yAgainstThemAgain2(String opponent, String count) {
    return 'Pang-$count laban sa $opponent. Hindi na ito nagkataon.';
  }

  @override
  String yAgainstThemAgain3(String opponent, String count) {
    return '$count beses na nating nakalaro ang $opponent at wala tayong natutunan sa alinman.';
  }

  @override
  String yAgainstThemAgain4(String opponent, String count) {
    return '$opponent, $count beses na. Alam nila eksakto ang gagawin natin.';
  }

  @override
  String yAgainstThemAgain5(String opponent, String count) {
    return 'Anuman ang hawak ng $opponent sa atin, $count beses na tayong nagkaharap, hawak pa rin nila.';
  }

  @override
  String ySameOldStory0(String count) {
    return '$count beses na itong nangyari kamakailan. Kailan pa ba natin matatanggap na ito na tayo?';
  }

  @override
  String ySameOldStory1(String count) {
    return '$count hapon nang ganito. Pattern na ito, hindi swerte.';
  }

  @override
  String ySameOldStory2(String count) {
    return '$count beses na nating nakita ang eksaktong larong ito kamakailan. Parehong script, parehong wakas.';
  }

  @override
  String ySameOldStory3(String count) {
    return '$count bersyon na ng parehong siyamnapung minuto. Walang nag-aayos nito.';
  }

  @override
  String ySameOldStory4(String count) {
    return '$count beses. Kung hindi mo pa nakikita ang pattern, hindi ka tumitingin.';
  }

  @override
  String ySameOldStory5(String count) {
    return 'Parehong kuwento, $count beses na. Naubos ang mga dahilan bago pa ang mga resulta.';
  }

  @override
  String get yToldYouSo0 =>
      'Sinabi kong darating ito habang abala ang lahat sa pagdiriwang.';

  @override
  String get yToldYouSo1 =>
      'Dalawang magandang linggo lang at golden generation na ulit tayo. At heto tayo.';

  @override
  String get yToldYouSo2 =>
      'Tumahimik na ang mga nagsabing mag-enjoy ako noong nakaraang buwan.';

  @override
  String get yToldYouSo3 => 'Hindi ako natutuwa dito. Halos hindi. Medyo.';

  @override
  String get yToldYouSo4 =>
      'Hindi ito kailanman kasing-ganda ng sinabi nila sa inyo, at ito ang patunay.';

  @override
  String get yToldYouSo5 =>
      'Palagi. Sinasabihan tayong iba na ngayon, at palagi, hindi naman.';

  @override
  String get tacticsSubOffAlready => 'Lumabas na';

  @override
  String get tacticsSubInjured => 'Injured';

  @override
  String get tacticsSubSentOffMark => 'Napalabas';

  @override
  String get tacticsSubNoneLeft => 'Wala nang pagpapalit';

  @override
  String get tacticsUndoLastChange => 'I-undo ang huling pagpapalit';

  @override
  String get matchStrengthTitle => 'ANO ANG KUMIKILOS SA KOPONAN';

  @override
  String get strengthFactorFamiliarity => 'Sanay na shape';

  @override
  String get strengthFactorFatigue => 'Pagod na binti';

  @override
  String get strengthFactorClubForm => 'Porma sa club';

  @override
  String get strengthFactorMorale => 'Dressing room';

  @override
  String get strengthFactorCaptain => 'Kapitan';

  @override
  String get strengthFactorStaff => 'Staff room';

  @override
  String get strengthFactorDossier => 'Dossier ng scout';

  @override
  String yDebut0(String name) {
    return 'Nakuha ni $name ang unang cap. Tandaan ang pangalan.';
  }

  @override
  String yDebut1(String name) {
    return 'Debut ni $name. Kita na sa kanya, hindi ba?';
  }

  @override
  String yDebut2(String name) {
    return '$name, unang cap. Tingnan natin kung ano ang gagawin niya rito.';
  }

  @override
  String yDebut3(String name) {
    return 'Debut ni $name. Kailangan ng squad ng sariwang binti sa kung saan.';
  }

  @override
  String yDebut4(String name) {
    return 'Binigyan ng cap si $name. Marami na tayong naipamigay nito kamakailan.';
  }

  @override
  String yDebut5(String name) {
    return 'Debut ni $name. Isa pang makakalimutan natin pagdating ng tagsibol.';
  }

  @override
  String yDrought0(String name, String count) {
    return '$count laro nang walang score si $name at ginagawa ang lahat ng iba sa pitch.';
  }

  @override
  String yDrought1(String name, String count) {
    return '$count laro na walang goal si $name. Tatlo-tatlo silang dumarating, lagi namang ganyan.';
  }

  @override
  String yDrought2(String name, String count) {
    return '$name: $count laro, walang goal.';
  }

  @override
  String yDrought3(String name, String count) {
    return '$count laro nang walang goal si $name. Dapat bantayan.';
  }

  @override
  String yDrought4(String name, String count) {
    return '$count laro. Walang goal. Hindi matamaan ni $name ang pader ng kamalig.';
  }

  @override
  String yDrought5(String name, String count) {
    return 'Hindi pa nakaka-score si $name sa $count. Ipaglaro na ang kahit sino pa.';
  }

  @override
  String yRivalryLooms0(String opponent, String count) {
    return '$opponent ang susunod. $count beses nang magkaharap at lahat pa rin ito.';
  }

  @override
  String yRivalryLooms1(String opponent, String count) {
    return '$count beses na laban sa $opponent. Sige na.';
  }

  @override
  String yRivalryLooms2(String opponent, String count) {
    return '$opponent ang susunod. $count na laro.';
  }

  @override
  String yRivalryLooms3(String opponent, String count) {
    return 'Pang-$count na pagkikita natin sa $opponent ngayong linggo.';
  }

  @override
  String yRivalryLooms4(String opponent, String count) {
    return '$opponent na naman. $count nito at wala tayong natutunan.';
  }

  @override
  String yRivalryLooms5(String opponent, String count) {
    return '$count laro laban sa $opponent at tinatalo pa rin nila tayo. Ang galing.';
  }

  @override
  String get positionGoalkeeper => 'Goalkeeper';

  @override
  String get positionLeftBack => 'Left Back';

  @override
  String get positionCentreBack => 'Center Back';

  @override
  String get positionRightBack => 'Right Back';

  @override
  String get positionDefensiveMid => 'Defensive Mid';

  @override
  String get positionCentralMid => 'Central Mid';

  @override
  String get positionAttackingMid => 'Attacking Mid';

  @override
  String get positionLeftMid => 'Left Mid';

  @override
  String get positionRightMid => 'Right Mid';

  @override
  String get positionLeftWing => 'Left Wing';

  @override
  String get positionRightWing => 'Right Wing';

  @override
  String get positionStriker => 'Striker';

  @override
  String get roleNone => 'Walang role';

  @override
  String get roleTargetMan => 'Target man';

  @override
  String get rolePoacher => 'Poacher';

  @override
  String get rolePlaymaker => 'Playmaker';

  @override
  String get roleBallWinner => 'Ball winner';

  @override
  String get roleInvertedWinger => 'Inverted winger';

  @override
  String get roleBallPlayingDefender => 'Ball-playing defender';

  @override
  String get roleNoneBlurb => 'Naglalaro ng natural niyang laro.';

  @override
  String get roleTargetManBlurb =>
      'Nananalo ng header, ipinapasa. Assist at set piece.';

  @override
  String get rolePoacherBlurb => 'Nakaabang sa box. Mas maraming goal.';

  @override
  String get rolePlaymakerBlurb => 'Gumagawa ng tsansa. Mas maraming assist.';

  @override
  String get roleBallWinnerBlurb =>
      'Sinisira ang laro sa halip na tapusin ito.';

  @override
  String get roleInvertedWingerBlurb =>
      'Pumapasok sa loob para mag-shoot. Mas maraming goal.';

  @override
  String get roleBallPlayingDefenderBlurb =>
      'Nagsisimula ng atake mula sa likod.';

  @override
  String get federationDeptYouth => 'Youth Academy';

  @override
  String get federationDeptCommercial => 'Commercial / PR';

  @override
  String get federationDeptMedical => 'Medical at Sports Science';

  @override
  String get federationDeptNaturalisation => 'Opisina ng Naturalisasyon';

  @override
  String get federationDeptBoardRelations => 'Ugnayan sa Board';

  @override
  String get federationDeptYouthBlurb =>
      'Mas magagaling na prospect ng akademya ang magde-debut para sa bansa mo sa susunod na cycle.';

  @override
  String get federationDeptCommercialBlurb =>
      'Nagdadala ng dagdag na kita ang sponsorship sa pagtatapos ng cycle.';

  @override
  String get federationDeptMedicalBlurb =>
      'Mas kaunting injury. Available ang squad mo buong cycle.';

  @override
  String get federationDeptNaturalisationBlurb =>
      'Mas maraming dayuhang manlalaro ang mag-aalok na lumipat sa bansa mo.';

  @override
  String get federationDeptBoardRelationsBlurb =>
      'Mas matiyaga ang board sa paghusga sa mga resulta mo.';

  @override
  String get federationBuildingAcademy => 'Akademya';

  @override
  String get federationBuildingCommercial => 'Commercial HQ';

  @override
  String get federationBuildingMedical => 'Medical Centre';

  @override
  String get federationBuildingScouting => 'Scouting Office';

  @override
  String get federationBuildingBoardroom => 'Boardroom';

  @override
  String get moraleBuoyant => 'Masigla';

  @override
  String get moralePositive => 'Positibo';

  @override
  String get moraleSettled => 'Panatag';

  @override
  String get moraleUneasy => 'Hindi mapalagay';

  @override
  String get moraleRockBottom => 'Pinakamababa';

  @override
  String get matchTabTimeline => 'TIMELINE';

  @override
  String get matchTabStats => 'STATS';

  @override
  String get matchTabLineups => 'LINEUP';

  @override
  String get matchPenalty => 'PENALTY';

  @override
  String get matchStateLevel => 'Tabla pa rin';

  @override
  String matchStateLead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lamang ka ng $count goal',
      one: 'Lamang ka ng isang goal',
    );
    return '$_temp0';
  }

  @override
  String matchStateTrail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kulang ka ng $count goal',
      one: 'Kulang ka ng isang goal',
    );
    return '$_temp0';
  }

  @override
  String matchPossessionShare(int possession) {
    return '$possession% possession';
  }

  @override
  String get boardVerdictSackedTitle => 'Sinibak ka ng board';

  @override
  String boardVerdictSackedBody(int rating) {
    return 'Isang masamang cycle (rating $rating%). Dito na nagtatapos ang panunungkulan mo. Mas mahihinang bansa na lang ang magtitiwala sa iyo ngayon.';
  }

  @override
  String get boardVerdictDelightedTitle => 'Tuwang-tuwa ang board';

  @override
  String boardVerdictDelightedBody(int rating, String best) {
    return 'Isang natatanging cycle (rating $rating%) matapos ang $best. Interesado ang mas malalaking bansa, o puwede kang manatili at magpatuloy sa pagbuo.';
  }

  @override
  String get boardVerdictSolidTitle => 'Isang solidong cycle';

  @override
  String boardVerdictSolidBody(int rating) {
    return 'Kontento ang board (rating $rating%). May ilang bansang kapantay ang antas na tatanggap sa iyo, pero walang presyur na lumipat.';
  }

  @override
  String get boardVerdictExpectedMoreTitle => 'Mas inaasahan ng board';

  @override
  String boardVerdictExpectedMoreBody(int rating) {
    return 'Isang nakadidismayang cycle (rating $rating%). Mananatili ka sa trabaho, pero pagbaba ang anumang alok.';
  }

  @override
  String get boardVerdictPressureTitle => 'Nasa totoong presyur ka';

  @override
  String boardVerdictPressureBody(int rating) {
    return 'Mahinang cycle (rating $rating%). Nakaligtas ka, pero mga mas mahihinang bansa lang ang interesado sa iyo kung gusto mo ng panibagong simula.';
  }

  @override
  String get boardVerdictHeroTitle => 'Nasa likod mo ang bansa';

  @override
  String boardVerdictHeroNote(String nation, int cycles) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cycle',
      one: '1 cycle',
    );
    return ' Mahal na mahal ka ng $nation, isang pambansang bayani matapos ang $_temp0; ligtas ang trabaho mo hangga\'t gusto mo.';
  }

  @override
  String get boardVerdictTheNation => 'Ang bansa';

  @override
  String get boardVerdictBestQuiet => 'isang tahimik na cycle';

  @override
  String get boardVerdictBestCycle => 'ang cycle';

  @override
  String boardVerdictBestWorld(String placement) {
    return 'ang Kampeonato ng Mundo: $placement';
  }

  @override
  String get finishThirdPlace => 'Ikatlong puwesto';

  @override
  String get finishFourthPlace => 'Ikaapat na puwesto';

  @override
  String get finishDidNotQualify => 'Hindi nakapasok';

  @override
  String get careerRepIconic => 'Iconic';

  @override
  String get careerRepRenowned => 'Kilalang-kilala';

  @override
  String get careerRepEstablished => 'Matatag';

  @override
  String get careerRepRising => 'Umaangat';

  @override
  String get careerRepUnproven => 'Hindi pa subok';

  @override
  String get hubOfferStepUp => 'Pag-angat';

  @override
  String get hubOfferLateral => 'Pantay na lipat';

  @override
  String get hubOfferRebuild => 'Muling pagbuo';

  @override
  String careerNationsCupWon(String league) {
    return 'Liga $league · Kampeon';
  }

  @override
  String careerNationsCupRunnerUp(String league) {
    return 'Liga $league · Runner-up';
  }

  @override
  String careerNationsCupSemi(String league) {
    return 'Liga $league · Semifinalist';
  }

  @override
  String careerNationsCupPlaced(String league, int position) {
    return 'Liga $league · #$position';
  }

  @override
  String tourRunInto(String round) {
    return 'Papasok sa $round';
  }

  @override
  String get tourRunIntoThirdPlace =>
      'Papasok sa laro para sa ikatlong puwesto';

  @override
  String tourRunThrough(String round) {
    return 'Pasok mula sa $round';
  }

  @override
  String tourRunOut(String round) {
    return 'Natanggal sa $round';
  }

  @override
  String get tourRunInGroup => 'Lumalaban sa group stage';

  @override
  String get tourRunGroupOut => 'Natanggal sa group stage';

  @override
  String resultsCycleTitle(int year, String nation) {
    return 'Cycle $year · $nation';
  }

  @override
  String resultsCycleRecord(int played, int won, int drawn, int lost) {
    return '$played laro  ·  ${won}P ${drawn}T ${lost}N';
  }

  @override
  String resultsCycleFinish(String finish) {
    return 'Kampeonato ng Mundo: $finish';
  }

  @override
  String get resultsCycleUnderway => 'Kasalukuyang nilalaro';

  @override
  String yTurnedItRound0(String opponent) {
    return 'Dalawang goal ang talo kontra $opponent sa break at nabawi nila ang lahat. Iyan ang tunay na koponan.';
  }

  @override
  String yTurnedItRound1(String opponent) {
    return 'Dalawang goal ang kulang laban sa $opponent pero pagdating ng dulo, wala nang kuwenta. Hindi lahat ng koponan nagagawa iyon.';
  }

  @override
  String yTurnedItRound2(String opponent) {
    return 'Half-time: dalawang goal ang talo kontra $opponent. Full-time: hindi na. Ibang laro ang second half.';
  }

  @override
  String yTurnedItRound3(String opponent) {
    return 'Bumangon mula sa dalawang goal na kulang laban sa $opponent. Anuman ang sinabi sa break, sabihin ito linggo-linggo.';
  }

  @override
  String yTurnedItRound4(String opponent) {
    return 'Sige, nabawi natin laban sa $opponent. Ngayon, may magpaliwanag nga ng unang apatnapu\'t limang minuto.';
  }

  @override
  String yTurnedItRound5(String opponent) {
    return 'Dalawang goal ang talo kontra $opponent at dapat tayong matuwa? Ayusin ang first half.';
  }

  @override
  String yThrewItAway0(String opponent) {
    return 'Dalawang goal ang lamang kontra $opponent sa break pero nawala pa rin. Nangyayari rin ito sa mas magagaling na koponan.';
  }

  @override
  String yThrewItAway1(String opponent) {
    return 'Dalawang goal ang lamang laban sa $opponent at nawala pa. Mahaba pa ang cycle, marami pang oras.';
  }

  @override
  String yThrewItAway2(String opponent) {
    return 'Half-time: dalawang goal ang lamang kontra $opponent. Full-time: wala man lang.';
  }

  @override
  String yThrewItAway3(String opponent) {
    return 'Dalawang goal na lamang laban sa $opponent, naglaho sa loob ng apatnapu\'t limang minuto.';
  }

  @override
  String yThrewItAway4(String opponent) {
    return 'Lamang ng dalawa tapos natalo pa. Sa $opponent pa. May dapat sumagot dito.';
  }

  @override
  String yThrewItAway5(String opponent) {
    return 'Dalawang goal ang lamang laban sa $opponent at nagawa pa natin ito. Palagi na lang.';
  }

  @override
  String get cycleBackupDone =>
      'Na-back up ang karera sa FNM folder ng teleponong ito. Mabubura ito kapag na-uninstall ang app: para magtabi ng kopya sa ibang lugar, gamitin ang Back up this save sa screen ng mga save.';

  @override
  String get cycleBackupFailed =>
      'Hindi ma-back up ang karera sa pagkakataong ito.';

  @override
  String pressMomentBigWinWarm1(String opponent) {
    return 'Isang gabing hindi malilimutan laban sa $opponent. Gaano kayo ka-proud sa grupong ito?';
  }

  @override
  String pressMomentBigWinWarm2(String opponent) {
    return 'Hindi nakasabay ang $opponent sa inyo. Ito ba ang koponang lagi ninyong pinaniniwalaan?';
  }

  @override
  String pressMomentBigWinNeutral1(String opponent) {
    return 'Malaking panalo laban sa $opponent. Ano ang naging pagkakaiba ngayong gabi?';
  }

  @override
  String pressMomentBigWinNeutral2(String opponent) {
    return 'Tinalo ang $opponent, at madali pa. Saan ninyo napanalunan?';
  }

  @override
  String pressMomentBigWinHostile1(String opponent) {
    return 'Magandang panalo laban sa $opponent. Isang magandang gabi lang ito: bakit may maniniwalang tatagal ito?';
  }

  @override
  String pressMomentBigWinHostile2(String opponent) {
    return 'Magandang resulta laban sa $opponent. Plano ninyo ba iyon, o ang mga manlalaro ang nakaisip nito?';
  }

  @override
  String pressMomentBigLossWarm1(String opponent) {
    return 'Mahirap na gabi laban sa $opponent. Ano ang sasabihin ninyo sa mga manlalaro pagkatapos ng ganito?';
  }

  @override
  String pressMomentBigLossWarm2(String opponent) {
    return 'Walang nakakita nito laban sa $opponent. Isa lang ba itong masamang gabi?';
  }

  @override
  String pressMomentBigLossNeutral1(String opponent) {
    return 'Masakit na gabi laban sa $opponent. Ano ang nagkamali?';
  }

  @override
  String pressMomentBigLossNeutral2(String opponent) {
    return 'Pinaluhod kayo ng $opponent. Sapat ba ang husay ng squad na ito?';
  }

  @override
  String pressMomentBigLossHostile1(String opponent) {
    return 'Huli kayo sa lahat laban sa $opponent. Paano ninyo hinayaang umabot sa ganito?';
  }

  @override
  String pressMomentBigLossHostile2(String opponent) {
    return 'Nakaiskor ang $opponent nang kahit kailan nila gusto. Nasaan ang plano ngayong gabi?';
  }

  @override
  String pressMomentCrisisWarm1(String opponent) {
    return 'Isa na namang laro ang nawala, ngayon laban sa $opponent. Paano ninyo babaliktarin ang takbo?';
  }

  @override
  String pressMomentCrisisWarm2(String opponent) {
    return 'Natuyo na ang mga resulta, at pinalala pa ng $opponent. Naniniwala pa rin ba kayo sa grupong ito?';
  }

  @override
  String pressMomentCrisisNeutral1(String opponent) {
    return 'Wala na namang panalo, ngayon laban sa $opponent, at nakamasid ang board. Ligtas ba ang trabaho ninyo?';
  }

  @override
  String pressMomentCrisisNeutral2(String opponent) {
    return 'Pagkatapos ng $opponent, humahaba na ang takbo. Nag-aalala ba kayo sa kinabukasan ninyo?';
  }

  @override
  String pressMomentCrisisHostile1(String opponent) {
    return 'Pati ang $opponent. Sinibak ang hinalinhan ninyo sa ganitong takbo. Bakit kayo makakaligtas?';
  }

  @override
  String pressMomentCrisisHostile2(String opponent) {
    return 'Pagkatapos ng isa na namang gabi tulad ng $opponent, gusto na kayong mawala ng bawat phone-in. Magbibitiw ba kayo kung hihilingin ng board?';
  }

  @override
  String pressMomentJobVerdictWarm1(String opponent) {
    return 'Isinugal ninyo ang trabaho ninyo, at pagkatapos ng $opponent, hindi ito pumabor sa inyo. Kumusta kayo?';
  }

  @override
  String pressMomentJobVerdictWarm2(String opponent) {
    return 'Tapos na ang tatlong laro, ang huli ay laban sa $opponent. Kayo mismo ang nagtakda ng pagsubok. Ano ang masasabi ninyo sa hatol?';
  }

  @override
  String pressMomentJobVerdictNeutral1(String opponent) {
    return 'Sinabi ninyong husgahan kayo sa susunod na tatlo. Pagkatapos ng $opponent, nahusgahan na kayo. Sa inyo pa rin ba ang trabaho ninyo?';
  }

  @override
  String pressMomentJobVerdictNeutral2(String opponent) {
    return 'Tatlong laro, ang huli laban sa $opponent, at hindi ito ang ipinangako ninyo. Nakipag-usap na ba kayo sa board tungkol sa kinabukasan ninyo?';
  }

  @override
  String pressMomentJobVerdictHostile1(String opponent) {
    return 'Kayo mismo ang nagtakda ng pagsubok at bumagsak kayo laban sa $opponent. Magbibitiw ba kayo?';
  }

  @override
  String pressMomentJobVerdictHostile2(String opponent) {
    return 'Sarili ninyong salita: husgahan ako sa susunod na tatlo. Pagkatapos ng $opponent, bakit nandiyan pa rin kayo?';
  }

  @override
  String get pressBeatWhoToBlameWarm1 =>
      'Gusto ninyo ng higit pa mula sa kanila. May partikular ba?';

  @override
  String get pressBeatWhoToBlameWarm2 =>
      'Mataas ang bar na itinakda ninyo. Sino ang dapat unang umangat?';

  @override
  String get pressBeatWhoToBlameNeutral1 =>
      'Sabi ninyo, may ilan sa kanila na dapat magnilay. Sino ang tinutukoy ninyo?';

  @override
  String get pressBeatWhoToBlameNeutral2 =>
      'Hindi sapat, sabi ninyo. Sino ang pinatutungkulan ninyo?';

  @override
  String get pressBeatWhoToBlameHostile1 =>
      'Palagi ninyong malabo ang sagot. Magpapangalan ba kayo, o babalik ito sa inyo?';

  @override
  String get pressBeatWhoToBlameHostile2 =>
      'Linggo-linggo, kasalanan ng iba. Kanino naman ngayon?';

  @override
  String get pressBeatIfYouDontWarm1 =>
      'Matapang na salita. At kung hindi pumabor ang susunod?';

  @override
  String get pressBeatIfYouDontWarm2 =>
      'Hahawakan kayo ng bansa sa sinabi ninyo. Paano kung hindi ito matupad?';

  @override
  String get pressBeatIfYouDontNeutral1 =>
      'At kung hindi ninyo ito mapanalunan? Ano na?';

  @override
  String get pressBeatIfYouDontNeutral2 =>
      'Nasabi ninyo na. Ano ang mangyayari kung mali kayo?';

  @override
  String get pressBeatIfYouDontHostile1 =>
      'Narinig na namin ang mga pangako sa silid na ito. Ano ang utang ninyo sa mga tagahanga kung masira rin ito?';

  @override
  String get pressBeatIfYouDontHostile2 =>
      'At kapag hindi ito nangyari, ano na naman ang magiging dahilan?';

  @override
  String get pressBeatFollowUpWarm1 =>
      'Isa pa, kung kaya ninyo. Ano pa ang kailangang ayusin ng grupong ito?';

  @override
  String get pressBeatFollowUpWarm2 =>
      'Kapag humupa na ang lahat, ano ang dadalhin ninyo mula ngayong gabi sa susunod na laro?';

  @override
  String get pressBeatFollowUpNeutral1 =>
      'Lumalim tayo nang kaunti. Ano ang kailangang gumanda bago ang susunod na laro?';

  @override
  String get pressBeatFollowUpNeutral2 =>
      'Lampas sa scoreline: nasa gusto ninyo bang kalagayan ang squad na ito?';

  @override
  String get pressBeatFollowUpHostile1 =>
      'Maraming salita, kakaunting laman. Ano ba talaga ang magbabago mula ngayon?';

  @override
  String get pressBeatFollowUpHostile2 =>
      'Gusto ng mga tagahanga ng tuwirang sagot. Sapat ba ang husay ng koponang ito, oo o hindi?';

  @override
  String pressBeatStandoutWarm1(String player) {
    return 'Namukod-tangi si $player ngayong gabi. Hanggang saan siya aabot?';
  }

  @override
  String pressBeatStandoutWarm2(String player) {
    return 'Nasa bawat headline si $player ngayong gabi. Inasahan ninyo ba ito?';
  }

  @override
  String pressBeatStandoutNeutral1(String player) {
    return 'Umangat si $player. Ano ang hiniling ninyo sa kanya ngayong gabi?';
  }

  @override
  String pressBeatStandoutNeutral2(String player) {
    return 'Si $player ba ang naging pagkakaiba ngayong gabi?';
  }

  @override
  String pressBeatStandoutHostile1(String player) {
    return 'Kung wala si $player, iba ang kuwento. Koponan ba ito, o isang manlalaro lang?';
  }

  @override
  String pressBeatStandoutHostile2(String player) {
    return 'Napakahusay ni $player. Dahil sa inyo, o sa kanya?';
  }

  @override
  String pressBeatStrugglerWarm1(String player) {
    return 'Mahirap ang gabi ni $player. May iniinda ba siya?';
  }

  @override
  String pressBeatStrugglerWarm2(String player) {
    return 'Hindi gabi ni $player ito. Aalalayan ninyo ba siya?';
  }

  @override
  String pressBeatStrugglerNeutral1(String player) {
    return 'Nahirapan si $player ngayong gabi. Mananatili ba siya sa puwesto?';
  }

  @override
  String pressBeatStrugglerNeutral2(String player) {
    return 'Parang hindi umabot sa bilis si $player. Ano ang tingin ninyo sa laro niya?';
  }

  @override
  String pressBeatStrugglerHostile1(String player) {
    return 'Pasahero na naman si $player. Bakit patuloy ninyo siyang pinipili?';
  }

  @override
  String pressBeatStrugglerHostile2(String player) {
    return 'Nakita ng lahat na wala sa kondisyon si $player. Maliban ba sa bench?';
  }

  @override
  String get pressThrowbackWinNextKeptWarm =>
      'Sinabi ninyong mananalo kayo sa susunod, at nanalo nga kayo. Masarap bang maging tama?';

  @override
  String get pressThrowbackWinNextKeptNeutral =>
      'Nangako kayo ng panalo sa susunod na laro at tinupad ninyo. Kumpiyansa ba iyan, o yabang?';

  @override
  String get pressThrowbackWinNextKeptHostile =>
      'Sinabi ninyong mananalo kayo sa susunod, at nanalo nga. Swerte lang ba, o dapat na ba kaming makinig?';

  @override
  String get pressThrowbackWinNextBrokenWarm =>
      'Sinabi ninyong mananalo kayo roon. Hindi nangyari. Ano ang nagkamali?';

  @override
  String get pressThrowbackWinNextBrokenNeutral =>
      'Sinabi ninyong mananalo kayo sa susunod. Hindi nangyari. Bakit kami maniniwala sa susunod na pangako?';

  @override
  String get pressThrowbackWinNextBrokenHostile =>
      'Sinabi ninyong mananalo kayo sa susunod. Hindi nangyari. May halaga pa ba ang mga salita ninyo sa silid na ito?';

  @override
  String get pressThrowbackJobKeptWarm =>
      'Hiniling ninyong husgahan kayo sa tatlong laro, at pumasa kayo. Napatunayan ninyo na ba ang sarili ninyo?';

  @override
  String get pressThrowbackJobKeptNeutral =>
      'Husgahan ako sa susunod na tatlo, sabi ninyo. Ginawa namin, at dumating ang mga resulta. Ano ang itinuro ng pagsubok na iyon?';

  @override
  String get pressThrowbackJobKeptHostile =>
      'Binigyan ninyo ang sarili ninyo ng tatlong laro at nalampasan ninyo. Mahirap ba talaga ang pagsubok na iyon?';

  @override
  String get pressThrowbackJobBrokenWarm =>
      'Hiniling ninyong husgahan kayo sa tatlong laro. Hindi pumabor sa inyo ang mga ito. Ano ang natutunan ninyo?';

  @override
  String get pressThrowbackJobBrokenNeutral =>
      'Sabi ninyo, husgahan ako sa susunod na tatlo. Tapos na ang tatlo, at nawala na rin ang benefit of the doubt. Ano na ngayon?';

  @override
  String get pressThrowbackJobBrokenHostile =>
      'Kayo ang nagtakda ng pagsubok at bumagsak kayo. Bakit may maniniwala pa sa salita ninyo?';

  @override
  String pressThrowbackBackKeptWarm(String player) {
    return 'Sinuportahan ninyo si $player noong ayaw ng iba. Nagbunga ito. May bahagi ba kayo sa kredito?';
  }

  @override
  String pressThrowbackBackKeptNeutral(String player) {
    return 'Sinuportahan ninyo si $player. Nagbunga. Pananampalataya, o kaalaman?';
  }

  @override
  String pressThrowbackBackKeptHostile(String player) {
    return 'Sinuportahan ninyo si $player, at sa pagkakataong ito, nagbunga. Ganito rin ba kayo kasigurado sa susunod?';
  }

  @override
  String pressThrowbackBackBrokenWarm(String player) {
    return 'Nanindigan kayo kay $player, at hindi ito nagtagumpay. Naniniwala pa rin ba kayo sa kanya?';
  }

  @override
  String pressThrowbackBackBrokenNeutral(String player) {
    return 'Sinuportahan ninyo si $player. Hindi niya ito nasuklian. Pagkakamali ba iyon?';
  }

  @override
  String pressThrowbackBackBrokenHostile(String player) {
    return 'Ang paghuhusga ninyo o ang katapatan ninyo: alin ang pumalpak kay $player?';
  }

  @override
  String pressThrowbackBlameKeptWarm(String player) {
    return 'Mahigpit kayo kay $player, at pinatunayan ng mga laro mula noon na tama kayo. May kasiyahan ba roon?';
  }

  @override
  String pressThrowbackBlameKeptNeutral(String player) {
    return 'Pinangalanan ninyo si $player, at hindi pa siya sumasagot. May daan pa ba pabalik para sa kanya?';
  }

  @override
  String pressThrowbackBlameKeptHostile(String player) {
    return 'Iniwan ninyong nag-iisa si $player at hindi pa siya nakababangon. Sinira ninyo ba siya?';
  }

  @override
  String pressThrowbackBlameBrokenWarm(String player) {
    return 'Pinangalanan ninyo si $player, at sumagot siya sa inyo sa laro. Iyon ba ang plano mula sa simula?';
  }

  @override
  String pressThrowbackBlameBrokenNeutral(String player) {
    return 'Sinisi ninyo si $player, at mula noon isa na siya sa pinakamahusay ninyo. May utang ba kayong paumanhin sa kanya?';
  }

  @override
  String pressThrowbackBlameBrokenHostile(String player) {
    return 'Isinuko ninyo si $player, at siya na ang pinakamahusay ninyong manlalaro mula noon. Hihingi ba kayo ng paumanhin?';
  }

  @override
  String get pressReplyCreditPlayers1 =>
      'Ibinigay ng mga manlalarong ito ang lahat. Hindi ko ipagpapalit ang kahit isa sa kanila.';

  @override
  String get pressReplyCreditPlayers2 =>
      'Walang mas masipag kaysa sa grupong ito. Ipagtatanggol ko silang lahat buong araw.';

  @override
  String get pressReplyCreditPlayers3 =>
      'Wala kayong maririnig na masama laban sa mga manlalaro ko mula sa upuang ito.';

  @override
  String get pressReplyCreditPlayers4 =>
      'Ang mga manlalaro ang dapat bigyan ng kredito, hindi ako. Sila ang isulat ninyo.';

  @override
  String get pressReplyTakeResponsibility1 =>
      'Ako ang may kasalanan doon. Ako ang pumili ng squad at ako ang nag-ayos sa kanila.';

  @override
  String get pressReplyTakeResponsibility2 =>
      'Ako ang husgahan ninyo, hindi sila. Koponan ko ito at responsibilidad ko.';

  @override
  String get pressReplyTakeResponsibility3 =>
      'Kung may gusto kayong sisihin, nandito lang ako.';

  @override
  String get pressReplyTakeResponsibility4 =>
      'Akin ang responsibilidad. Huwag ninyong idamay ang mga manlalaro.';

  @override
  String get pressReplyDemandMore1 =>
      'Gusto ko ng higit pa. Alam ng ilan sa kanila kung ano ang ibig kong sabihin.';

  @override
  String get pressReplyDemandMore2 =>
      'Hindi sapat ang pagsisikap sa antas na ito. Gusto ko ng higit pa, at sinabi ko na iyon sa kanila.';

  @override
  String get pressReplyDemandMore3 =>
      'Umaasa ako ng higit pa mula sa bawat isa sa kanila, simula bukas.';

  @override
  String get pressReplyDemandMore4 =>
      'May ilan sa kanila na dapat magnilay. Hindi ako kuntento.';

  @override
  String get pressReplyPromiseWinNext1 =>
      'Mananalo kami sa susunod. Isulat ninyo iyan.';

  @override
  String get pressReplyPromiseWinNext2 =>
      'Tandaan ninyo ang salita ko: mananalo kami sa susunod na laro.';

  @override
  String get pressReplyPromiseWinNext3 =>
      'Susunod na laro, panalo kami. Sinasabi ko ito rito para mahawakan ninyo ako sa salita ko.';

  @override
  String get pressReplyPromiseWinNext4 =>
      'Sigurado ako sa koponang ito. Mananalo kami sa susunod na laro.';

  @override
  String get pressReplyJobOnTheLine1 =>
      'Husgahan ninyo ako sa susunod na tatlong laro. Makatarungan iyon.';

  @override
  String get pressReplyJobOnTheLine2 =>
      'Bigyan ninyo ako ng tatlong laro. Kung hindi pa rin maayos pagsapit doon, husgahan ninyo ako.';

  @override
  String get pressReplyJobOnTheLine3 =>
      'Ang susunod na tatlo ang magpapakita kung ako ang tamang tao. Hawakan ninyo ako riyan.';

  @override
  String get pressReplyJobOnTheLine4 =>
      'Tatlong laro. Pagkatapos, isulat ninyo ang gusto ninyo tungkol sa akin.';

  @override
  String get pressReplyDeflect1 =>
      'Isang laro sa bawat pagkakataon. Wala na akong idadagdag.';

  @override
  String get pressReplyDeflect2 =>
      'Hindi ako gagawa ng headline para sa inyo ngayon.';

  @override
  String get pressReplyDeflect3 => 'Susunod na laro. Iyon lang ang iniisip ko.';

  @override
  String get pressReplyDeflect4 =>
      'Ang iniisip ko ay nananatili sa dressing room.';

  @override
  String get pressReplyTakeCredit1 =>
      'Sinabi ko iyon dahil naniniwala ako, at tama ako.';

  @override
  String get pressReplyTakeCredit2 =>
      'Tama ang basa ko. Iyon ang trabaho ko rito.';

  @override
  String get pressReplyTakeCredit3 =>
      'Tawagin ninyo itong paghuhusga. Alam ko ang sinasabi ko.';

  @override
  String get pressReplyTakeCredit4 =>
      'Ako ang nagpasya at tumama. Tatanggapin ko iyon.';

  @override
  String get pressReplyStandByIt1 =>
      'Sinabi ko ang pinaniniwalaan ko. Nanindigan ako rito.';

  @override
  String get pressReplyStandByIt2 => 'Wala akong binabawing salita.';

  @override
  String get pressReplyStandByIt3 =>
      'Parehong sagot noon. Seryoso ako noon, at seryoso pa rin ako ngayon.';

  @override
  String get pressReplyStandByIt4 => 'Uulitin ko ito bukas.';

  @override
  String get pressReplyAdmitMistake1 => 'Mali ako roon. Aaminin ko.';

  @override
  String get pressReplyAdmitMistake2 =>
      'Tama lang, nagkamali ako ng paghusga. Matututo ako rito.';

  @override
  String get pressReplyAdmitMistake3 => 'Mali ako, at kaya kong sabihin iyon.';

  @override
  String get pressReplyAdmitMistake4 =>
      'Hindi umubra ang desisyong iyon, at akin iyon.';

  @override
  String pressReplyBackPlayer1(String player) {
    return 'Buong suporta ko si $player. Bubuti rin siya.';
  }

  @override
  String pressReplyBackPlayer2(String player) {
    return 'Naniniwala ako kay $player, at ipapakita niya sa inyo kung bakit.';
  }

  @override
  String pressReplyBackPlayer3(String player) {
    return 'Wala kayong maririnig na masama laban kay $player mula sa akin. Maghahatid siya.';
  }

  @override
  String pressReplyBackPlayer4(String player) {
    return 'Nasa plano ko pa rin si $player. Panoorin ninyo ang gagawin niya sa susunod.';
  }

  @override
  String pressReplyBlamePlayer1(String player) {
    return 'Binigo kami ni $player ngayong gabi, at alam niya iyon.';
  }

  @override
  String pressReplyBlamePlayer2(String player) {
    return 'Mas marami akong inaasahan kay $player. Dapat niyang panagutan iyon.';
  }

  @override
  String pressReplyBlamePlayer3(String player) {
    return 'Wala sa antas si $player. Sasabihin ko iyan nang hayagan.';
  }

  @override
  String pressReplyBlamePlayer4(String player) {
    return 'Hindi sapat ang ipinakita ni $player, at maririnig niya iyon mula sa akin.';
  }

  @override
  String get pressOnRecordWinNext =>
      'Opisyal na pahayag: mananalo kayo sa susunod na laro.';

  @override
  String get pressOnRecordJob =>
      'Opisyal na pahayag: huhusgahan kayo sa susunod na tatlo.';

  @override
  String pressOnRecordBack(String player) {
    return 'Opisyal na pahayag: sinusuportahan si $player.';
  }

  @override
  String pressOnRecordBlame(String player) {
    return 'Opisyal na pahayag: binigo kayo ni $player.';
  }

  @override
  String yStatementKept0(String nation) {
    return 'Sinabi niya, at nangyari. May manager ang $nation na tinutupad ang sinasabi.';
  }

  @override
  String yStatementKept1(String nation) {
    return 'Sinabi nang malakas, tapos ginawa. Iyan ang taong kailangan ng $nation.';
  }

  @override
  String yStatementKept2(String nation) {
    return '$nation: nahulaan niya, at nagkatotoo. Sige na nga.';
  }

  @override
  String yStatementKept3(String nation) {
    return 'Inilagay niya sa record at nanindigan. Puntos para sa kanya. Tuloy ang $nation.';
  }

  @override
  String yStatementKept4(String nation) {
    return 'Isa ang tama niya. $nation, huwag kayong masanay.';
  }

  @override
  String yStatementKept5(String nation) {
    return 'Kahit ang tumigil na orasan ay tama dalawang beses isang araw. Pinalad lang ang $nation ngayon.';
  }

  @override
  String yStatementBroken0(String nation) {
    return 'Sinabi niya at hindi natupad. Kasama pa rin niya ako. Tuloy ang laban ng $nation.';
  }

  @override
  String yStatementBroken1(String nation) {
    return '$nation: mas marami siyang ipinangako kaysa sa nakuha natin, pero mas gusto ko ang manager na naniniwala sa sarili.';
  }

  @override
  String yStatementBroken2(String nation) {
    return '$nation: sinabi niya sa record at hindi nangyari. Maaalala ito ng mga tao.';
  }

  @override
  String yStatementBroken3(String nation) {
    return 'Malalaking salita, walang laman. $nation: sa susunod, magsalita nang mas kaunti.';
  }

  @override
  String yStatementBroken4(String nation) {
    return 'Tumayo siya at sinabi sa atin. Tapos ito ang nangyari. Mas karapat-dapat ang $nation kaysa sa puro salita.';
  }

  @override
  String yStatementBroken5(String nation) {
    return 'Wala nang halaga ang salita niya ngayon. Isulat ninyo iyan, $nation.';
  }

  @override
  String get ncZoneNorth => 'Hilagang Zone';

  @override
  String get ncZoneWest => 'Kanlurang Zone';

  @override
  String get ncZoneEast => 'Silangang Zone';

  @override
  String get ncZoneCentralSouthern => 'Gitna at Timog na Zone';

  @override
  String careerNationsCupZoneWon(String zone) {
    return '$zone · Kampeon';
  }

  @override
  String careerNationsCupZoneRunnerUp(String zone) {
    return '$zone · Runner-up';
  }

  @override
  String careerNationsCupZoneSemi(String zone) {
    return '$zone · Semifinalist';
  }

  @override
  String careerNationsCupZoneRoundOf16(String zone) {
    return '$zone · Round of 16';
  }

  @override
  String careerNationsCupZoneQuarter(String zone) {
    return '$zone · Quarterfinalist';
  }

  @override
  String careerNationsCupZonePlaced(String zone, int position) {
    return '$zone · #$position';
  }

  @override
  String get objectiveNcFinalsEight => 'Pumasok sa quarterfinal';

  @override
  String get objectiveNcZoneWinGroup => 'Manguna sa grupo';

  @override
  String get finishNcFinalsEight => 'Quarterfinal';

  @override
  String get finishNcBottomHalf => 'Ibabang kalahati ng grupo';

  @override
  String get tourContTabZones => 'MGA ZONE';

  @override
  String get tourContTabFinalsEight => 'KNOCKOUTS';

  @override
  String get tourContFinalsEightSoon =>
      'Magsisimula ang knockouts sa Nobyembre sa Round of 16: lahat ng 14 na nanguna sa grupo at ang 2 pinakamahusay na runner-up.';

  @override
  String get tourContQuarterFinals => 'MGA QUARTERFINAL';

  @override
  String get tourContZoneAdvancement =>
      'Pasok sa Round of 16 ang bawat nanguna sa grupo, kasama ang 2 pinakamahusay na runner-up. Walang bumababa.';

  @override
  String tourContZoneHeadingYours(String zone) {
    return '$zone ★';
  }

  @override
  String get compNorthAmericaNationsCup => 'Nations Cup ng Hilagang Amerika';

  @override
  String get compAfricanNationsCup => 'Nations Cup';

  @override
  String get objectiveNcWinItNorthAmerica =>
      'Pagkampeon sa Nations Cup ng Hilagang Amerika';

  @override
  String get objectiveNcWinItAfrica => 'Pagkampeon sa Nations Cup';

  @override
  String get objectiveNcReachFinalNorthAmerica =>
      'Pumasok sa final ng Nations Cup ng Hilagang Amerika';

  @override
  String get objectiveNcReachFinalAfrica => 'Pumasok sa final ng Nations Cup';

  @override
  String get finishNcChampionsNorthAmerica =>
      'Kampeon ng Nations Cup ng Hilagang Amerika';

  @override
  String get finishNcChampionsAfrica => 'Kampeon ng Nations Cup';

  @override
  String pressAimQualWarm1(String competition) {
    return 'Nagsisimula na ang kwalipikasyon ng $competition, at naniniwala ang bansa sa koponang ito. Ano ang target ninyo?';
  }

  @override
  String pressAimQualWarm2(String competition) {
    return 'Bagong kampanya sa kwalipikasyon ng $competition, at mataas ang moral. Hanggang saan kaya aabot ang koponang ito?';
  }

  @override
  String pressAimQualNeutral1(String competition) {
    return 'Nagsisimula ang kwalipikasyon ng $competition. Ano ang target para sa kampanyang ito?';
  }

  @override
  String pressAimQualNeutral2(String competition) {
    return 'Narito na ang mga qualifier ng $competition. Saan ninyo nakikitang matatapos ang koponang ito?';
  }

  @override
  String pressAimQualHostile1(String competition) {
    return 'Nagsisimula ang kwalipikasyon ng $competition, at marami ang nagdududang makakarating kayo. Ano ang sasabihin ninyo sa kanila?';
  }

  @override
  String pressAimQualHostile2(String competition) {
    return 'Isa na namang kampanya sa kwalipikasyon ng $competition. Bakit may maniniwalang iba ito ngayon?';
  }

  @override
  String pressAimFinalsWarm1(String competition) {
    return 'Narito na ang $competition at nasa likod ninyo ang buong bansa. Hanggang saan kayo aabot?';
  }

  @override
  String pressAimFinalsWarm2(String competition) {
    return 'Nasa $competition na kayo at nangangarap ang mga tagahanga. Ano ang target?';
  }

  @override
  String pressAimFinalsNeutral1(String competition) {
    return 'Magsisimula ang $competition ngayong linggo. Ano ang ituturing na tagumpay?';
  }

  @override
  String pressAimFinalsNeutral2(String competition) {
    return 'Malapit na ang unang laro ninyo sa $competition. Magtakda kayo ng target.';
  }

  @override
  String pressAimFinalsHostile1(String competition) {
    return 'Narito na ang $competition at walang masyadong umaasa. Ano ba talaga ang inaasam ninyo?';
  }

  @override
  String pressAimFinalsHostile2(String competition) {
    return 'Nasa $competition na kayo, pero hindi pa naglalaho ang mga pagdududa. Ano ang target ninyo?';
  }

  @override
  String pressBeatRivalWarm1(String rival) {
    return 'Kasama ninyo sa grupo ang $rival. Kinakabahan ba kayo sa kanila?';
  }

  @override
  String pressBeatRivalWarm2(String rival) {
    return 'Inilagay ng draw ang $rival sa daan ninyo. Ano ang tingin ninyo sa larong iyon?';
  }

  @override
  String pressBeatRivalNeutral1(String rival) {
    return 'Mukhang ang $rival ang pinakamalakas sa grupo ninyo. Sila ba ang paborito?';
  }

  @override
  String pressBeatRivalNeutral2(String rival) {
    return 'Ano ang tingin ninyo sa $rival?';
  }

  @override
  String pressBeatRivalHostile1(String rival) {
    return 'Kasama ninyo sa grupo ang $rival. Maging tapat kayo, kaya ba ninyo sila?';
  }

  @override
  String pressBeatRivalHostile2(String rival) {
    return 'Inaasahan ng karamihan na tatalunin kayo ng $rival. Mali ba sila?';
  }

  @override
  String pressBeatKeyPlayerWarm1(String player) {
    return 'Maganda ang porma ni $player. Ito na ba ang sandali niya?';
  }

  @override
  String pressBeatKeyPlayerWarm2(String player) {
    return 'Nasa bawat headline si $player. Kaya ba niyang buhatin ang koponang ito?';
  }

  @override
  String pressBeatKeyPlayerNeutral1(String player) {
    return 'Gaano nakasalalay kay $player ang kampanyang ito?';
  }

  @override
  String pressBeatKeyPlayerNeutral2(String player) {
    return 'Handa na ba si $player na pamunuan ang koponang ito?';
  }

  @override
  String pressBeatKeyPlayerHostile1(String player) {
    return 'Kung hindi nasa pinakamahusay si $player, may maibibigay pa ba ang koponang ito?';
  }

  @override
  String pressBeatKeyPlayerHostile2(String player) {
    return 'Malaki ang pasan ni $player. Sobra na ba?';
  }

  @override
  String get pressReplyAimHigher1 =>
      'Mas malayo ang aabutin namin kaysa sa inaasahan ng sinuman.';

  @override
  String get pressReplyAimHigher2 =>
      'Gusto ko ng higit pa sa hiniling ng pederasyon, at sasabihin ko ito nang hayagan.';

  @override
  String get pressReplyMatchBrief1 =>
      'Alam namin ang target at aabutin namin ito.';

  @override
  String get pressReplyMatchBrief2 =>
      'Nagtakda ng target ang pederasyon. Tutuparin namin ito.';

  @override
  String get pressReplyPlayDown1 => 'Isang laro sa bawat pagkakataon.';

  @override
  String get pressReplyPlayDown2 =>
      'Walang malalaking pangako. Tingnan natin kung nasaan tayo.';

  @override
  String get pressReplyPromiseQualify1 =>
      'Makakapasok kami. Isulat ninyo iyan.';

  @override
  String get pressReplyPromiseQualify2 => 'Nasa finals ang koponang ito.';

  @override
  String get pressReplyFearNobody1 => 'Wala kaming kinakatakutan.';

  @override
  String get pressReplyFearNobody2 => 'Kailangan din nilang harapin kami.';

  @override
  String get pressReplyRespectRival1 =>
      'Sila ang paborito, at iginagalang namin sila.';

  @override
  String get pressReplyRespectRival2 =>
      'Napakahusay na koponan. Kakailanganin namin ang pinakamahusay namin.';

  @override
  String get pressReplyTeamFirst1 =>
      'Tungkol ito sa buong koponan, hindi sa isang manlalaro.';

  @override
  String get pressReplyTeamFirst2 => 'Walang nananalo nang mag-isa.';

  @override
  String pressOnRecordTarget(String aim) {
    return 'Opisyal na pahayag: $aim.';
  }

  @override
  String get pressOnRecordPlayDown => 'Opisyal na pahayag: walang pangako.';

  @override
  String get pressThrowbackTargetKeptWarm =>
      'Nagtakda kayo ng target bago ang kampanya at naabot ninyo ito. Ito na ba ang pinakamapagmamalaki ninyong sandali?';

  @override
  String get pressThrowbackTargetKeptNeutral =>
      'Sinabi ninyo kung ano ang makakamit ninyo, at nagawa ninyo. Nagduda ba kayo kahit minsan?';

  @override
  String get pressThrowbackTargetKeptHostile =>
      'Naabot ninyo ang itinakda ninyong target. Swerte lang, o talagang plano ninyo iyon?';

  @override
  String get pressThrowbackTargetBrokenWarm =>
      'Nagtakda kayo ng target at kinulang. Ano ang nagkamali?';

  @override
  String get pressThrowbackTargetBrokenNeutral =>
      'Mas marami kayong ipinangako kaysa sa naihatid ng koponang ito. Pinagsisisihan ninyo ba ang pagsabi nito?';

  @override
  String get pressThrowbackTargetBrokenHostile =>
      'Malakas ang hangin ninyo bago ang kampanya at kinulang kayo. Bakit namin kayo paniniwalaan ngayon?';

  @override
  String hubEventPressPreviewSub(String competition) {
    return 'Gustong marinig ng media ang mga layunin mo para sa $competition';
  }

  @override
  String deptLevelCost(int level, String amount) {
    return 'Level $level · $amount';
  }

  @override
  String get formOnFire => 'Nag-aapoy';

  @override
  String get formGood => 'Maganda ang porma';

  @override
  String get formSteady => 'Pantay';

  @override
  String get formPoor => 'Wala sa porma';

  @override
  String get formCold => 'Nanlalamig';

  @override
  String get playerFormTitle => 'PORMA AT KONDISYON';

  @override
  String playerFormAverage(String rating) {
    return 'Average na $rating sa mga huling laro niya';
  }

  @override
  String get playerFormNoGames => 'Kulang pa ang mga huling laro para humusga';

  @override
  String playerFormNextMatch(String delta) {
    return '$delta sa rating niya sa susunod na laro';
  }

  @override
  String get playerFormNoEffect =>
      'Walang pagbabago sa rating niya sa susunod na laro';

  @override
  String get sideGroupHome => 'Home';

  @override
  String get sideGroupTeam => 'Koponan';

  @override
  String get sideGroupCompetitions => 'Mga Kompetisyon';

  @override
  String get sideGroupFederation => 'Pederasyon';

  @override
  String get sideGroupHistory => 'Kasaysayan';

  @override
  String get sideInbox => 'Inbox';

  @override
  String get sideSquad => 'Squad';

  @override
  String get sideTactics => 'Taktika';

  @override
  String get sideMainMenu => 'Main menu';

  @override
  String get sideCallUps => 'Call-up';

  @override
  String get sideTournaments => 'Mga Torneo';

  @override
  String get sideRanking => 'Ranking';

  @override
  String get sideResults => 'Mga Resulta';

  @override
  String get sideFinances => 'Pananalapi';

  @override
  String get sideBoard => 'Board';

  @override
  String get sideManager => 'Manager at staff';

  @override
  String get sideRecords => 'Mga Record';

  @override
  String get sideLegends => 'Mga Alamat';

  @override
  String get sideHeadToHead => 'Head to head';

  @override
  String get sideAchievements => 'Mga Tagumpay';

  @override
  String get sideCareer => 'Karera';

  @override
  String get topBarNext => 'Susunod';

  @override
  String get topBarDrawPending => 'Hinihintay ang draw';

  @override
  String get paneFullProfile => 'Buong profile';

  @override
  String get panePickPlayer =>
      'Pumili ng manlalaro para makita ang card niya rito';

  @override
  String get inboxPickMessage => 'Pumili ng mensahe para mabasa ito rito';

  @override
  String get inboxFilterAll => 'Lahat';

  @override
  String get panelViewAll => 'Tingnan lahat';

  @override
  String get gridViewOverview => 'Pangkalahatan';

  @override
  String get gridColCondition => 'Kondisyon';

  @override
  String get gridColStatus => 'Status';

  @override
  String get gridColRank => 'Ranggo';

  @override
  String get gridColMove => 'Galaw';

  @override
  String get gridColNation => 'Bansa';

  @override
  String get gridColRegion => 'Rehiyon';

  @override
  String get gridColPoints => 'Puntos';

  @override
  String get panePickNation =>
      'Pumili ng bansa para makita ang record nito rito';

  @override
  String get resultsCyclesTitle => 'Mga Cycle';

  @override
  String get tourDrawStart => 'Simulan ang draw';

  @override
  String get tourDrawViewGroups => 'Tingnan ang mga grupo';

  @override
  String get gridColCeiling => 'Hangganan';

  @override
  String get gridColYearGain => 'Dagdag';

  @override
  String get gridColMarkedAt => 'Nang itala';

  @override
  String get budgetSetupTitle => 'Itakda ang badyet mo';

  @override
  String get budgetEffectsTitle => 'Ano ang mabibili ng badyet na ito';

  @override
  String get naturalisationTitle => 'Naturalisasyon';

  @override
  String get yTrending => 'Trending';

  @override
  String get yVoices => 'Mga Boses';

  @override
  String get yConversation => 'Usapan';

  @override
  String get allTimeRecordsTitle =>
      'Mga pandaigdigang record sa lahat ng panahon';

  @override
  String get h2hMeetingsTitle => 'Bawat harapan';

  @override
  String get h2hPickOpponent =>
      'Pumili ng kalaban para makita ang bawat harapan dito';

  @override
  String get savesTitle => 'Mga Save';

  @override
  String get gridColPlayer => 'Manlalaro';

  @override
  String get gridColPos => 'Pos';

  @override
  String get gridColActive => 'Aktibo';

  @override
  String get gridColMotm => 'MOTM';

  @override
  String get gridColAvg => 'Avg';

  @override
  String get gridColOpponent => 'Kalaban';

  @override
  String get gridColStarts => 'Simula';

  @override
  String get gridColTournaments => 'Mga Torneo';

  @override
  String get gridColDate => 'Petsa';

  @override
  String get gridColLastPlayed => 'Huling nilaro';

  @override
  String get gridColManager => 'Manager';

  @override
  String nationsShownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bansa',
      one: '1 bansa',
    );
    return '$_temp0';
  }

  @override
  String get nationsSortedByRank => 'Nakaayos ayon sa pandaigdigang ranggo';

  @override
  String get nationsStrength => 'Lakas';

  @override
  String nationsStrengthOf(int tier) {
    return '$tier sa 5';
  }

  @override
  String get nationsSquadOverall => 'Overall ng squad';

  @override
  String get nationsOpeningBudget => 'Panimulang badyet';

  @override
  String get nationsStarPlayer => 'Pangunahing manlalaro';

  @override
  String nationsStarTile(String position, int rating) {
    return 'Star $position $rating';
  }

  @override
  String nationsStarAge(int age) {
    return 'Edad $age';
  }

  @override
  String get nationsBoardExpects => 'Inaasahan ng board';

  @override
  String nationsManage(String nation) {
    return 'Pamunuan ang $nation';
  }

  @override
  String get nationsManagerNext => 'Susunod mong ipapangalan ang manager mo';

  @override
  String get playerPageTitle => 'Manlalaro';

  @override
  String get nationPageTitle => 'Bansa';

  @override
  String get friendliesYourGames => 'Mga friendly mo';

  @override
  String hubEventInjuryCover(String player) {
    return 'Palitan ang injured na si $player';
  }

  @override
  String hubEventInjuryCoverSub(int matches) {
    String _temp0 = intl.Intl.pluralLogic(
      matches,
      locale: localeName,
      other: 'Wala sa susunod na $matches laro',
      one: 'Wala sa susunod na laro',
    );
    return '$_temp0. Mag-call-up ng iba, o ituloy nang walang kapalit.';
  }

  @override
  String get injuryCoverTitle => 'KAPALIT';

  @override
  String injuryCoverBanner(String player) {
    return 'Injured si $player. Mag-call-up ng sinuman mula sa labas ng squad, sa anumang posisyon, o panatilihin siya at ituloy ang laro.';
  }

  @override
  String injuryCoverConfirm(String player) {
    return 'I-call-up si $player';
  }

  @override
  String injuryCoverKeep(String player) {
    return 'Panatilihin si $player at ituloy';
  }

  @override
  String get injuryCoverPick => 'Pumili ng kapalit';

  @override
  String get injuryCoverNone =>
      'Walang nasa labas ng squad na fit para sumali.';

  @override
  String get nationNowRanking => 'Pandaigdigang ranking';

  @override
  String get nationNowForm => 'Porma';

  @override
  String get nationNowNoForm => 'Wala pang nalalaro';

  @override
  String get nationNowNext => 'Susunod na laro';

  @override
  String get nationNowNoNext => 'Walang nakaiskedyul';

  @override
  String get nationNowSquad => 'Squad';

  @override
  String get nationNowAgainstYou => 'Laban sa iyo';

  @override
  String nationNowRecord(int w, int d, int l) {
    return '${w}P ${d}T ${l}N';
  }

  @override
  String get nationNowLastMeeting => 'Huling harapan';

  @override
  String nationNowOverall(int value) {
    return 'Overall $value';
  }

  @override
  String get hubUpcoming => 'PAPARATING';

  @override
  String get hubFullSchedule => 'Buong iskedyul';

  @override
  String get scheduleTitle => 'Iskedyul';

  @override
  String get scheduleToday => 'Ngayon';

  @override
  String get scheduleKnockoutPending => 'Knockout stage, kung makapasok ka';

  @override
  String get scheduleNextRoundPending => 'Susunod na round';

  @override
  String scheduleFromDate(String date) {
    return 'Mula $date';
  }

  @override
  String get scheduleHomeShort => 'H';

  @override
  String get scheduleAwayShort => 'A';

  @override
  String get tacticsNoPresetsInMatch =>
      'Wala pang naka-save na taktika. Mag-save ng isa mula sa screen ng Taktika bago ang laro.';

  @override
  String get homeCampaigns => 'Mga Kampanya';

  @override
  String get homeContinueCampaign => 'ITULOY ANG KAMPANYA';

  @override
  String homeCampaignCycle(String date, int cycle, int total) {
    return '$date · Siklo $cycle sa $total';
  }

  @override
  String get campaignsTitle => 'Mga Kampanya';

  @override
  String get campaignTransplantTitle => 'Ang Transplant';

  @override
  String get campaignTransplantTwist =>
      'Walong pinakamahusay ng Italy ang lumipat ng katapatan sa San Marino';

  @override
  String get campaignTransplantGoal => 'Makapasok sa Kampeonato ng Europa';

  @override
  String get campaignGrudgeTitle => 'Hinanakit';

  @override
  String get campaignGrudgeTwist => 'Georgia at Albania, pinagsama sa draw';

  @override
  String get campaignGrudgeGoal =>
      'Tapusin sa itaas ng Albania sa kwalipikasyon';

  @override
  String get campaignTransplantIntro =>
      'Hindi pa nagkaroon ng kampanya sa kwalipikasyon ang San Marino na karapat-dapat tawaging ganoon. Tapos walong pinakamahusay ng Italy ang kumuha ng pasaporte at pumasok. May isang cycle ka para gawing tunay na koponan ang isang kuryosidad.';

  @override
  String get campaignGrudgeIntro =>
      'Napunta sa iisang grupo ng kwalipikasyon ang Georgia at Albania, at walang magpapatawad ng talo. Tapusin sa itaas ng Albania, tapos tingnan kung hanggang saan mo ito madadala.';

  @override
  String get campaignStars1Transplant => 'Makapasok';

  @override
  String get campaignStars2Transplant => 'Makaabot sa knockouts';

  @override
  String get campaignStars3Transplant => 'Ipanalo ang Kampeonato ng Europa';

  @override
  String get campaignStars1Grudge => 'Sa itaas ng Albania';

  @override
  String get campaignStars2Grudge => 'At makapasok';

  @override
  String get campaignStars3Grudge => 'At talunin sila nang dalawang beses';

  @override
  String get campaignFree => 'Libre';

  @override
  String get campaignStart => 'Simulan';

  @override
  String get campaignPartOfUnlimited => 'Bahagi ng Unlimited';

  @override
  String get campaignResume => 'Ituloy';

  @override
  String get campaignAbandon => 'Iwanan';

  @override
  String get campaignAbandonConfirm =>
      'Iwanan ang takbong ito? Mawawala ang progreso nito; mananatili ang tatak mo.';

  @override
  String get campaignMoveToSaves => 'Ilipat sa mga save';

  @override
  String get campaignCannotContinue =>
      'Masyadong malayo ang mundo ng kampanyang ito sa totoong mundo para ipagpatuloy bilang karera.';

  @override
  String get campaignMoveSlotsFull =>
      'Puno na ang mga save slot mo. Magbakante muna ng isa.';

  @override
  String get campaignStampConquered => 'Nasakop';

  @override
  String get campaignStampFailed => 'Bigo';

  @override
  String get campaignDifficultyHard => 'Mahirap';

  @override
  String get campaignDifficultyMedium => 'Katamtaman';

  @override
  String get campaignGoalLabel => 'Layunin';

  @override
  String get campaignStarsLabel => 'Mga Bituin';

  @override
  String get campaignRunInProgress =>
      'May kasalukuyang takbo ang kampanyang ito.';

  @override
  String get campaignVerdictWon => 'Nasakop';

  @override
  String get campaignVerdictLost => 'Hindi sa pagkakataong ito';

  @override
  String get campaignVerdictContinue => 'Magpatuloy';

  @override
  String campaignProgressQualifying(String position) {
    return 'Kwalipikasyon: $position';
  }

  @override
  String campaignProgressRival(String rival, String position) {
    return '$rival: $position';
  }

  @override
  String campaignProgressFinals(String stage) {
    return 'Finals: $stage';
  }

  @override
  String get campaignRunInNumbers => 'Ang takbo sa numero';

  @override
  String campaignRunMeetings(int won, int played) {
    return 'Napanalunang harapan: $won sa $played';
  }

  @override
  String campaignPlace(String which, int n) {
    String _temp0 = intl.Intl.selectLogic(
      which,
      {
        'first': 'ika-1',
        'second': 'ika-2',
        'third': 'ika-3',
        'other': 'ika-$n',
      },
    );
    return '$_temp0';
  }

  @override
  String get campaignGuineasTitle => 'Pinakamahusay sa mga Guinea';

  @override
  String get campaignGuineasTwist =>
      'Equatorial Guinea, ang pinakamababa ang ranggo sa mga Guinea ng Aprika, sa loob ng dalawang cycle';

  @override
  String get campaignGuineasGoal => 'Talunin ang Guinea at Guinea-Bissau';

  @override
  String get campaignGuineasIntro =>
      'Tatlong bansa sa Aprika ang may pangalang Guinea, at ang Equatorial Guinea ang pinakamababa ang ranggo sa kanila. May dalawang cycle ka para talunin ang Guinea at Guinea-Bissau nang kahit isang beses bawat isa, tapos tingnan kung hanggang saan ka aabot sa Kampeonato ng Aprika. Ang Papua New Guinea, ang ikaapat na Guinea, ay may nakatakda nang friendly.';

  @override
  String get campaignStars1Guineas => 'Talunin ang Guinea at Guinea-Bissau';

  @override
  String get campaignStars2Guineas => 'At makapasok sa Kampeonato ng Aprika';

  @override
  String get campaignStars3Guineas =>
      'At umabot sa quarterfinal ng Kampeonato ng Aprika';

  @override
  String get campaignYoungFinnsTitle => 'Mga Batang Finn';

  @override
  String get campaignYoungFinnsTwist =>
      'Ang ginintuang henerasyon ng mga tinedyer ng Finland, sa loob ng tatlong cycle';

  @override
  String get campaignYoungFinnsGoal => 'Makapasok sa isang Kampeonato ng Mundo';

  @override
  String get campaignYoungFinnsIntro =>
      'Umatras na ang mga senior na manlalaro ng Finland at isang ginintuang henerasyon ang pumalit sa kanila: bawat manlalarong mapipili mo ay 18 taong gulang o mas bata. Hilaw pa sila ngayon, pero may talento silang maging isa sa pinakamahusay na koponan sa mundo, tulad ng ginawa ng batang henerasyon ng Norway. May tatlong cycle ka para dalhin sila sa isang Kampeonato ng Mundo, tapos ipanalo ang Kampeonato ng Europa at ang Kampeonato ng Mundo.';

  @override
  String get campaignStars1YoungFinns =>
      'Makapasok sa isang Kampeonato ng Mundo';

  @override
  String get campaignStars2YoungFinns => 'Ipanalo ang Kampeonato ng Europa';

  @override
  String get campaignStars3YoungFinns => 'Ipanalo ang Kampeonato ng Mundo';

  @override
  String get campaignPro => 'Pro';

  @override
  String campaignProgressCup(String cup, String year, String status) {
    return '$cup $year: $status';
  }

  @override
  String get campaignCupNotQualified => 'Hindi nakapasok';

  @override
  String get campaignCupOpen => 'Hindi pa tiyak';
}
